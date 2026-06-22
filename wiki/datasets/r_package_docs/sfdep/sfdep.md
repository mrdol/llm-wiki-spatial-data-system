# sfdep package help

## Package Description

- Package: sfdep
- Title: Spatial Dependence for Simple Features
- Version: 0.2.5
- Description: An interface to 'spdep' to integrate with 'sf' objects and the 'tidyverse'.
- Authors@R: c(
    person("Josiah", "Parry", email = "josiah.parry@gmail.com", role = c("aut"),
           comment = c(ORCID = "0000-0001-9910-865X")),
    person("Dexter", "Locke", email = "dexter.locke@gmail.com", role = c("aut", "cre"),
           comment = c(ORCID = "0000-0003-2704-9720"))
  )
- Author: Josiah Parry [aut] (<https://orcid.org/0000-0001-9910-865X>),
  Dexter Locke [aut, cre] (<https://orcid.org/0000-0003-2704-9720>)
- Maintainer: Dexter Locke <dexter.locke@gmail.com>
- Depends: R (>= 3.5.0)
- Imports: sf, cli, spdep, stats, rlang
- Suggests: broom, dbscan, dplyr, ggplot2, knitr, magrittr, patchwork,
purrr, pracma, rmarkdown, sfnetworks, stringr, testthat (>=
3.0.0), tibble, tidyr, vctrs, yaml, zoo, Kendall, igraph,
tidygraph
- License: GPL-3
- URL: https://sfdep.josiahparry.com,
https://github.com/josiahparry/sfdep

## Help Pages

- activate: Activate spacetime context
- as_spacetime: Cast between 
list("spacetime")
 and 
list("sf")
 classes
- center_mean: Calculate Center Mean Point
- check_pkg_suggests: Check if a vector of packages are available
- check_polygon: Checks geometry for polygons.
- class_modify: Modify object classes
- classify_hotspot: Classify Hot Spot results
- complete_spacetime_cube: Convert spacetime object to spacetime cube
- cond_permute_nb: Conditional permutation of neighbors
- critical_threshold: Identify critical threshold
- ellipse: Create an Ellipse
- emerging_hotspot_analysis: Emerging Hot Spot Analysis
- find_xj: Identify xj values
- global_c: Compute Geary's C
- global_c_perm: Global C Permutation Test
- global_c_test: Global C Test
- global_colocation: Global Colocation Quotient
- global_colocation_calc: Calculate the Global Colocation Quotient
- global_colocation_perm_impl: Global Colocation Quotient Conditional Permutation Implementation
- global_g_test: Getis-Ord Global G
- global_jc_perm: Global Join Counts
- global_moran: Calculate Global Moran's I
- global_moran_bv: Compute the Global Bivariate Moran's I
- global_moran_perm: Global Moran Permutation Test
- global_moran_test: Global Moran Test
- guerry: "Essay on the Moral Statistics of France" data set.
- include_self: Includes self in neighbor list
- inverse_dist_calc: Calculate inverse distance weights
- is_spacetime_cube: Test if a spacetime object is a spacetime cube
- jc_bjc_calc: Calculate BJC Bivariate Case
- jc_bjc_perm_impl: Calculate BJC BV for conditional permutations
- jc_clc_perm_impl: Calculate CLC BV for conditional permutations
- kernels: Kernel functions
- local_c: Compute Local Geary statistic
- local_colocation: Local indicator of Colocation Quotient
- local_colocation_calc: Calculate the local colocation quotient
- local_colocation_impl: spdep implementation of local colocation quotient
- local_g: Local G
- local_g_spt: Calculate the Local Gi* for a spacetime cube
- local_gstar: Local G*
- local_jc_bv: Bivariate local join count
- local_jc_uni: Compute local univariate join count
- local_moran: Calculate the Local Moran's I Statistic
- local_moran_bv: Compute the Local Bivariate Moran's I Statistic
- local_moran_bv_calc: Calculate the Local Bivariate Moran Statistic
- local_moran_bv_impl: Local Bivariate Moran's I spdep implementation
- local_moran_bv_perm_impl: Local Bivariate Moran's I conditional permutation implementation
- losh: Local spatial heteroscedacity
- nb_match_test: Local Neighbor Match Test
- nb_union: Set Operations
- nmt_calc: Identify matches between two neighbor lists
- nmt_impl: Implementation of Neighbor Match Test
- nmt_perm_impl: Find conditionally permuted neighbor matches

Given a kNN attribute neighbor list and a listw object, find the number of matches given a conditional permutation.
- node_get_nbs: Create node features from edges
- pairwise_colocation: Pairwise Colocation Quotient
- pairwise_colocation_calc: Pairwise CLQ calculation
- pairwise_colocation_perm_impl: Pairwise CLQ conditional permutation implementation
- pct_nonzero: Percent Non-zero Neighbors
- permute_listw: Conditionally permutes a listw object
- recreate_listw: Create a listw object from a neighbors and weight list
- set_col: Set columns from 
list("geometry")
 to 
list("data")
- shuffle_nbs: Internal function to shuffle neighbors
- sin_d: Trigonometric functions
- spacetime: Construct a 
list("spacetime")
 object
- spatial_gini: Spatial Gini Index
- spt_nb: Create time lagged spatial neighbors
- spt_order: Order a spacetime cube
- spt_update: Update spacetime attributes
- spt_wt: Create time lagged spatial weights
- st_as_edges: Convert to an edge lines object
- st_as_graph: Create an sfnetwork
- st_as_nodes: Convert to a node point object
- st_block_nb: Create Block Contiguity for Spatial Regimes
- st_cardinalties: Calculate neighbor cardinalities
- st_complete_nb: Create Neighbors as Complete Graph
- st_contiguity: Identify polygon neighbors
- st_dist_band: Neighbors from a distance band
- st_inverse_distance: Calculate inverse distance weights
- st_kernel_weights: Calculate Kernel Weights
- st_knn: Calculate K-Nearest Neighbors
- st_lag: Calculate spatial lag
- st_nb_apply: Apply a function to neighbors
- st_nb_delaunay: Graph based neighbors
- st_nb_dists: Calculate neighbor distances
- st_nb_lag: Pure Higher Order Neighbors
- st_nb_lag_cumul: Encompassing Higher Order Neighbors
- st_weights: Calculate spatial weights
- std_dev_ellipse: Calculation Standard Deviational Ellipse
- std_distance: Calculate standard distance
- szero: Global sum of weights
- tidyverse: tidyverse methods for spacetime objects
- wt_as_matrix: Convert neighbor or weights list to matrix

## Package Rd Help

No package-level Rd help page found.
