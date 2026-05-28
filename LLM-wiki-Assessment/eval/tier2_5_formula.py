"""Tier 2.5 — Vérification de formules par extraction PDF via vision.

Ce tier optionnel compare la section ## Model Equation d'une fiche estimateur
avec les formules extraites du PDF source brut, en utilisant l'API vision Claude.

Architecture (compartiment par compartiment)
-------------------------------------------

COMPARTIMENT 1 — Résolution du PDF source
    fiche.md frontmatter sources: [GAMboosting.pdf]
        ↓
    _find_pdf_source(fiche_path, frontmatter)
        → cherche dans raw/paper/, raw/estimators/, raw/
        → retourne Path ou None

COMPARTIMENT 2 — Extraction des images de pages
    raw/paper/GAMboosting.pdf
        ↓
    extract_pages_as_images(pdf_path, dpi=150)
        → PyMuPDF (fitz) : rendu page par page en PNG bytes
        → retourne list[bytes]

COMPARTIMENT 3 — Extraction des formules par vision LLM
    list[bytes] (images PNG)
        ↓
    extract_formulas_from_page(image_bytes, client)
        → appel API Claude vision : "Extrais toutes les formules mathématiques en LaTeX"
        → retourne list[str] (formules LaTeX pour cette page)

COMPARTIMENT 4 — Sauvegarde dans le manifeste
    data/manifests/papers/<stem>_formulas_extracted.json
    {
      "pdf_path": "raw/paper/GAMboosting.pdf",
      "extracted_at": "2026-05-13T...",
      "model": "claude-opus-4-5-20251001",
      "pages": [{"page": 1, "formulas": ["...", ...]}, ...],
      "all_formulas": ["...", ...]
    }

COMPARTIMENT 5 — Comparaison avec la fiche
    wiki/estimators/gamboost.md  +  manifeste JSON
        ↓
    compare_formulas_with_fiche(fiche_path, manifest_path, client)
        → extrait la section ## Model Equation de la fiche
        → envoie section + formules PDF à Claude
        → retourne FormulaComparisonResult (JSON structuré)

COMPARTIMENT 6 — Point d'entrée principal
    run(fiche_path, frontmatter, force_reextract=False)
        → orchestre les compartiments 1 à 5
        → retourne FormulaResult (dataclass)

Usage depuis run_eval.py :
    from eval import tier2_5_formula
    result = tier2_5_formula.run(fiche_path, frontmatter)
    # result.score, result.assessment, result.report
"""

from __future__ import annotations

import base64
import json
import os
import re
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.parent  # LLM-wiki-Assessment/eval/ → llm-wiki-karpathy/
MANIFEST_DIR = PROJECT_ROOT / "data" / "manifests" / "papers"

# Modèle vision par défaut (configurable via env FORMULA_MODEL).
# Même modèle que Tier 2 (claude-haiku-4-5-20251001) pour cohérence et disponibilité.
# Remplacez par FORMULA_MODEL=claude-3-5-sonnet-... si votre compte y a accès.
DEFAULT_FORMULA_MODEL = os.environ.get("FORMULA_MODEL", "claude-haiku-4-5-20251001")

# Résolution DPI pour le rendu des pages PDF
PDF_RENDER_DPI = int(os.environ.get("FORMULA_PDF_DPI", "150"))

# Répertoires où chercher les PDFs sources
PDF_SEARCH_DIRS = [
    PROJECT_ROOT / "raw" / "paper",
    PROJECT_ROOT / "raw" / "estimators",
    PROJECT_ROOT / "raw",
]


# ---------------------------------------------------------------------------
# Dataclasses de résultat
# ---------------------------------------------------------------------------

@dataclass
class FormulaResult:
    """Résultat global du Tier 2.5."""
    score: float = 0.80
    assessment: str = "not_run"   # faithful | partial | divergent | not_verifiable | not_run | error
    report: str = ""
    manifest_path: Path | None = None
    skipped: bool = False
    error: str = ""
    details: dict = field(default_factory=dict)


# ---------------------------------------------------------------------------
# COMPARTIMENT 1 — Résolution du PDF source
# ---------------------------------------------------------------------------

def _find_pdf_source(frontmatter: dict) -> Path | None:
    """Cherche le PDF source dans les répertoires raw/ à partir du frontmatter.

    Regarde le champ `sources` du frontmatter et essaie de trouver le fichier
    correspondant dans PDF_SEARCH_DIRS.

    Returns:
        Path vers le PDF trouvé, ou None si aucun PDF n'est localisé.
    """
    sources = frontmatter.get("sources") or []
    if isinstance(sources, str):
        sources = [sources]

    pdf_names = [s for s in sources if str(s).lower().endswith(".pdf")]

    for name in pdf_names:
        name_only = Path(str(name)).name
        # Chemin absolu ou relatif au projet
        candidate = Path(str(name))
        if candidate.is_absolute() and candidate.exists():
            return candidate
        proj_relative = PROJECT_ROOT / candidate
        if proj_relative.exists():
            return proj_relative
        # Chercher par nom dans les répertoires connus
        for search_dir in PDF_SEARCH_DIRS:
            found = search_dir / name_only
            if found.exists():
                return found

    return None


# ---------------------------------------------------------------------------
# COMPARTIMENT 2 — Extraction des images de pages
# ---------------------------------------------------------------------------

def extract_pages_as_images(pdf_path: Path, dpi: int = PDF_RENDER_DPI) -> list[bytes]:
    """Rend chaque page du PDF en PNG bytes via PyMuPDF.

    Args:
        pdf_path: Chemin vers le fichier PDF.
        dpi:      Résolution de rendu (150 dpi suffit pour la lecture de formules).

    Returns:
        Liste de bytes PNG, un élément par page.

    Raises:
        ImportError: si pymupdf n'est pas installé.
        RuntimeError: si le PDF ne peut pas être ouvert.
    """
    try:
        import fitz  # PyMuPDF
    except ImportError as exc:
        raise ImportError(
            "PyMuPDF est requis pour l'extraction de formules PDF. "
            "Installez-le avec : pip install pymupdf"
        ) from exc

    try:
        doc = fitz.open(str(pdf_path))
    except Exception as exc:
        raise RuntimeError(f"Impossible d'ouvrir le PDF {pdf_path.name}: {exc}") from exc

    pages_bytes: list[bytes] = []
    matrix = fitz.Matrix(dpi / 72, dpi / 72)  # facteur d'échelle par rapport à 72 dpi de base

    for page_num in range(len(doc)):
        page = doc[page_num]
        pix = page.get_pixmap(matrix=matrix, colorspace=fitz.csRGB)
        pages_bytes.append(pix.tobytes("png"))

    doc.close()
    return pages_bytes


# ---------------------------------------------------------------------------
# COMPARTIMENT 3 — Extraction des formules par vision LLM
# ---------------------------------------------------------------------------

_FORMULA_EXTRACT_PROMPT = """\
Tu analyses une page de publication scientifique.

Extrais TOUTES les formules mathématiques présentes sur cette page.
Pour chaque formule, donne la notation LaTeX la plus précise possible.

Règles :
- Inclus les équations numérotées et non numérotées.
- Inclus les définitions, mises à jour itératives, fonctions de perte, termes de régularisation.
- N'inclus PAS le texte courant, seulement les expressions mathématiques.
- Si la page ne contient aucune formule, retourne une liste vide.

Réponds UNIQUEMENT avec un objet JSON valide, sans texte autour :
{"formulas": ["<formule LaTeX 1>", "<formule LaTeX 2>", ...]}
"""


def extract_formulas_from_page(image_bytes: bytes, client) -> list[str]:
    """Envoie une image de page PDF à Claude vision et retourne les formules LaTeX extraites.

    Args:
        image_bytes: Contenu PNG de la page.
        client:      Instance `anthropic.Anthropic`.

    Returns:
        Liste de formules LaTeX (peut être vide).
    """
    image_b64 = base64.standard_b64encode(image_bytes).decode("utf-8")

    response = client.messages.create(
        model=DEFAULT_FORMULA_MODEL,
        max_tokens=2048,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "image",
                        "source": {
                            "type": "base64",
                            "media_type": "image/png",
                            "data": image_b64,
                        },
                    },
                    {
                        "type": "text",
                        "text": _FORMULA_EXTRACT_PROMPT,
                    },
                ],
            }
        ],
    )

    raw_text = (response.content[0].text or "").strip()
    # Chercher le JSON dans la réponse (robustesse si le modèle ajoute du texte)
    json_match = re.search(r"\{[\s\S]+\}", raw_text)
    if not json_match:
        return []
    try:
        data = json.loads(json_match.group())
        formulas = data.get("formulas") or []
        return [str(f) for f in formulas if f]
    except (json.JSONDecodeError, TypeError):
        return []


# ---------------------------------------------------------------------------
# COMPARTIMENT 4 — Sauvegarde dans le manifeste
# ---------------------------------------------------------------------------

def run_formula_extraction(
    pdf_path: Path,
    manifest_path: Path,
    force: bool = False,
) -> dict:
    """Orchestre l'extraction page par page et sauvegarde le manifeste JSON.

    Si le manifeste existe déjà et que `force=False`, charge et retourne
    le manifeste existant sans relancer l'extraction (cache).

    Args:
        pdf_path:      Chemin vers le PDF source.
        manifest_path: Chemin de destination du manifeste JSON.
        force:         Si True, force la réextraction même si le manifeste existe.

    Returns:
        Dictionnaire manifeste (équivalent au JSON sauvegardé).
    """
    if not force and manifest_path.exists():
        print(f"  Cache manifeste trouvé : {manifest_path.name} (utilisez --force-formulas pour réextraire)")
        return json.loads(manifest_path.read_text(encoding="utf-8"))

    try:
        import anthropic
    except ImportError as exc:
        raise RuntimeError("Package 'anthropic' requis : pip install anthropic") from exc

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise RuntimeError("ANTHROPIC_API_KEY non défini — Tier 2.5 ne peut pas fonctionner")

    client = anthropic.Anthropic(api_key=api_key)

    print(f"  Extraction formules depuis : {pdf_path.name}")
    pages_bytes = extract_pages_as_images(pdf_path)
    print(f"  {len(pages_bytes)} page(s) à analyser...")

    pages_data = []
    all_formulas: list[str] = []

    for i, page_bytes in enumerate(pages_bytes, start=1):
        print(f"    Page {i}/{len(pages_bytes)}...", end="\r")
        formulas = extract_formulas_from_page(page_bytes, client)
        pages_data.append({"page": i, "formulas": formulas})
        all_formulas.extend(formulas)

    print()  # newline après les pages

    manifest = {
        "pdf_path": str(pdf_path.relative_to(PROJECT_ROOT) if pdf_path.is_relative_to(PROJECT_ROOT) else pdf_path),
        "extracted_at": datetime.now(timezone.utc).isoformat(),
        "model": DEFAULT_FORMULA_MODEL,
        "dpi": PDF_RENDER_DPI,
        "page_count": len(pages_bytes),
        "total_formulas": len(all_formulas),
        "pages": pages_data,
        "all_formulas": all_formulas,
    }

    MANIFEST_DIR.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"  Manifeste sauvegardé : {manifest_path.name}")
    print(f"  {len(all_formulas)} formule(s) extraite(s) au total")

    return manifest


# ---------------------------------------------------------------------------
# COMPARTIMENT 5 — Comparaison avec la fiche
# ---------------------------------------------------------------------------

_FORMULA_COMPARE_PROMPT = """\
Tu es un expert en statistique et en modélisation mathématique.

Tu dois comparer les formules déclarées dans la section "## Model Equation" d'une fiche wiki estimateur
avec les formules extraites du PDF source correspondant.

## Section ## Model Equation de la fiche

{fiche_equation_section}

## Formules extraites du PDF (LaTeX)

{pdf_formulas}

## Tâche

Évalue la fidélité de la fiche par rapport au PDF.

Critères :
1. Les formules clés du papier sont-elles présentes dans la fiche ?
2. Y a-t-il des divergences notables (signe différent, paramètre manquant, structure incorrecte) ?
3. Y a-t-il des formules importantes dans le PDF absentes de la fiche ?

Réponds UNIQUEMENT avec un objet JSON valide (pas de texte autour) :
{{
  "assessment": "<faithful | partial | divergent | not_verifiable>",
  "score": <float entre 0.0 et 1.0>,
  "matched_formulas": ["<formule du PDF qui correspond à la fiche>", ...],
  "missing_from_fiche": ["<formule PDF importante absente de la fiche>", ...],
  "divergences": ["<description d'une divergence spécifique>", ...],
  "reasoning": "<explication en français, 2-4 phrases>"
}}

Valeurs d'assessment :
- "faithful"        : les formules de la fiche correspondent bien aux formules PDF clés
- "partial"         : les formules principales sont là mais certaines sont absentes ou simplifiées
- "divergent"       : au moins une formule clé est incorrecte ou manquante de façon significative
- "not_verifiable"  : le PDF ou la fiche ne contient pas assez de formules pour trancher
"""


def _extract_model_equation_section(fiche_content: str) -> str:
    """Extrait le contenu de la section ## Model Equation depuis le corps de la fiche."""
    # Chercher la section ## Model Equation
    match = re.search(
        r"^##\s+Model Equation\s*\n([\s\S]*?)(?=^##\s|\Z)",
        fiche_content,
        re.MULTILINE,
    )
    if match:
        return match.group(1).strip()
    return ""


def compare_formulas_with_fiche(
    fiche_path: Path,
    manifest: dict,
    client,
) -> dict:
    """Compare la section ## Model Equation de la fiche avec les formules PDF extraites.

    Args:
        fiche_path: Chemin de la fiche wiki estimateur.
        manifest:   Dictionnaire manifeste chargé depuis le JSON.
        client:     Instance `anthropic.Anthropic`.

    Returns:
        Dictionnaire de résultat structuré (assessment, score, matched, missing, divergences, reasoning).
    """
    fiche_content = fiche_path.read_text(encoding="utf-8-sig")
    equation_section = _extract_model_equation_section(fiche_content)

    if not equation_section:
        return {
            "assessment": "not_verifiable",
            "score": 0.70,
            "matched_formulas": [],
            "missing_from_fiche": [],
            "divergences": [],
            "reasoning": "La section ## Model Equation est absente ou vide dans la fiche. Vérification impossible.",
        }

    all_formulas = manifest.get("all_formulas") or []
    if not all_formulas:
        return {
            "assessment": "not_verifiable",
            "score": 0.70,
            "matched_formulas": [],
            "missing_from_fiche": [],
            "divergences": [],
            "reasoning": "Aucune formule n'a été extraite du PDF. Vérification impossible.",
        }

    # Limiter à 50 formules pour rester dans le budget de tokens
    formulas_sample = all_formulas[:50]
    formulas_text = "\n".join(f"- {f}" for f in formulas_sample)
    if len(all_formulas) > 50:
        formulas_text += f"\n... ({len(all_formulas) - 50} formules supplémentaires non affichées)"

    prompt = _FORMULA_COMPARE_PROMPT.format(
        fiche_equation_section=equation_section,
        pdf_formulas=formulas_text,
    )

    response = client.messages.create(
        model=DEFAULT_FORMULA_MODEL,
        max_tokens=2048,
        messages=[{"role": "user", "content": prompt}],
    )

    raw_text = (response.content[0].text or "").strip()
    json_match = re.search(r"\{[\s\S]+\}", raw_text)
    if not json_match:
        return {
            "assessment": "not_verifiable",
            "score": 0.70,
            "matched_formulas": [],
            "missing_from_fiche": [],
            "divergences": [],
            "reasoning": f"Réponse du modèle non parseable : {raw_text[:200]}",
        }

    raw_json = json_match.group()
    try:
        result = json.loads(raw_json)
    except json.JSONDecodeError:
        # Tentative de réparation : les formules LaTeX peuvent contenir des \ non échappés
        # On remplace les \lettre (hors \\ déjà échappé) par \\lettre
        repaired = re.sub(r'(?<!\\)\\(?![\\"/bfnrtu])', r'\\\\', raw_json)
        try:
            result = json.loads(repaired)
        except (json.JSONDecodeError, TypeError, ValueError) as exc:
            return {
                "assessment": "not_verifiable",
                "score": 0.70,
                "matched_formulas": [],
                "missing_from_fiche": [],
                "divergences": [str(exc)],
                "reasoning": "Erreur de parsing du résultat de comparaison (JSON invalide même après réparation).",
            }
    except (TypeError, ValueError) as exc:
        return {
            "assessment": "not_verifiable",
            "score": 0.70,
            "matched_formulas": [],
            "missing_from_fiche": [],
            "divergences": [str(exc)],
            "reasoning": "Erreur de parsing du résultat de comparaison.",
        }

    # Valider et normaliser le score
    score = float(result.get("score", 0.70))
    result["score"] = max(0.0, min(1.0, score))
    return result


# ---------------------------------------------------------------------------
# COMPARTIMENT 6 — Point d'entrée principal
# ---------------------------------------------------------------------------

def run(fiche_path: Path, frontmatter: dict, force_reextract: bool = False) -> FormulaResult:
    """Point d'entrée du Tier 2.5.

    Orchestre la résolution PDF → extraction → comparaison → résultat.

    Args:
        fiche_path:       Chemin de la fiche wiki estimateur.
        frontmatter:      Dict YAML du frontmatter (pour résolution des sources).
        force_reextract:  Si True, réextrait même si le manifeste existe déjà.

    Returns:
        FormulaResult avec score, assessment, et rapport textuel.
    """
    entity_type = frontmatter.get("type", "")
    if entity_type != "estimator":
        return FormulaResult(
            skipped=True,
            assessment="not_run",
            report=f"Tier 2.5 ignoré — type '{entity_type}' (seuls les estimateurs sont vérifiés)",
        )

    # Résolution du PDF
    pdf_path = _find_pdf_source(frontmatter)
    if pdf_path is None:
        return FormulaResult(
            skipped=True,
            assessment="not_run",
            report=(
                "Tier 2.5 ignoré — aucun PDF trouvé dans les sources du frontmatter. "
                "Ajoutez un fichier .pdf dans sources: pour activer la vérification."
            ),
        )

    # Chemin du manifeste
    stem = pdf_path.stem  # ex: "GAMboosting"
    manifest_path = MANIFEST_DIR / f"{stem}_formulas_extracted.json"

    print("\nTier 2.5 - Verification formules PDF")
    print(f"  PDF source : {pdf_path.name}")
    print(f"  Manifeste  : {manifest_path.relative_to(PROJECT_ROOT)}")

    # Vérification que l'API est disponible
    try:
        import anthropic
    except ImportError as exc:
        return FormulaResult(
            error=str(exc),
            assessment="not_run",
            report="Tier 2.5 non exécuté — package 'anthropic' requis : pip install anthropic",
        )

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        return FormulaResult(
            error="ANTHROPIC_API_KEY non défini",
            assessment="not_run",
            report="Tier 2.5 non exécuté — ANTHROPIC_API_KEY absent de l'environnement",
        )

    # Compartiment 2-4 : extraction (avec cache)
    try:
        manifest = run_formula_extraction(pdf_path, manifest_path, force=force_reextract)
    except ImportError as exc:
        return FormulaResult(
            error=str(exc),
            assessment="not_run",
            report=str(exc),
        )
    except Exception as exc:
        return FormulaResult(
            error=str(exc),
            assessment="error",
            report=f"Erreur d'extraction PDF : {exc}",
        )

    # Compartiment 5 : comparaison
    client = anthropic.Anthropic(api_key=api_key)
    try:
        comparison = compare_formulas_with_fiche(fiche_path, manifest, client)
    except Exception as exc:
        return FormulaResult(
            error=str(exc),
            assessment="error",
            report=f"Erreur lors de la comparaison : {exc}",
        )

    assessment = comparison.get("assessment", "not_verifiable")
    score = float(comparison.get("score", 0.70))
    reasoning = comparison.get("reasoning", "")
    matched = comparison.get("matched_formulas") or []
    missing = comparison.get("missing_from_fiche") or []
    divergences = comparison.get("divergences") or []

    # Rapport textuel
    lines = [
        f"  Assessment : {assessment}",
        f"  Score      : {score:.2f}",
    ]
    if matched:
        lines.append(f"  Formules correspondantes ({len(matched)}) :")
        for f in matched[:5]:
            lines.append(f"    ✓ {f[:100]}")
        if len(matched) > 5:
            lines.append(f"    ... ({len(matched) - 5} autres)")
    if missing:
        lines.append(f"  Formules absentes de la fiche ({len(missing)}) :")
        for f in missing[:5]:
            lines.append(f"    ✗ {f[:100]}")
        if len(missing) > 5:
            lines.append(f"    ... ({len(missing) - 5} autres)")
    if divergences:
        lines.append(f"  Divergences ({len(divergences)}) :")
        for d in divergences[:3]:
            lines.append(f"    ! {d[:120]}")
    if reasoning:
        lines.append(f"  Raison : {reasoning}")

    report = "\n".join(lines)

    return FormulaResult(
        score=score,
        assessment=assessment,
        report=report,
        manifest_path=manifest_path,
        details=comparison,
    )
