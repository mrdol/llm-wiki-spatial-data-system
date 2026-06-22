Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

ResumeNames: Are Emily and Greg More Employable Than Lakisha and Jamal?

Are Emily and Greg More Employable Than Lakisha and Jamal?

Description

     Cross-section data about resume, call-back and employer
     information for 4,870 fictitious resumes.

Usage

     data("ResumeNames")

Format

     A data frame containing 4,870 observations on 27 variables.

     name factor indicating applicant's first name.

     gender factor indicating gender.

     ethnicity factor indicating ethnicity (i.e., Caucasian-sounding
          vs. African-American sounding first name).

     quality factor indicating quality of resume.

     call factor. Was the applicant called back?

     city factor indicating city: Boston or Chicago.

     jobs number of jobs listed on resume.

     experience number of years of work experience on the resume.

     honors factor. Did the resume mention some honors?

     volunteer factor. Did the resume mention some volunteering
          experience?

     military factor. Does the applicant have military experience?

     holes factor. Does the resume have some employment holes?

     school factor. Does the resume mention some work experience while
          at school?

     email factor. Was the e-mail address on the applicant's resume?

     computer factor. Does the resume mention some computer skills?

     special factor. Does the resume mention some special skills?

     college factor. Does the applicant have a college degree or more?

     minimum factor indicating minimum experience requirement of the
          employer.

     equal factor. Is the employer EOE (equal opportunity employment)?

     wanted factor indicating type of position wanted by employer.

     requirements factor. Does the ad mention some requirement for the
          job?

     reqexp factor. Does the ad mention some experience requirement?

     reqcomm factor. Does the ad mention some communication skills
          requirement?

     reqeduc factor. Does the ad mention some educational requirement?

     reqcomp factor. Does the ad mention some computer skills
          requirement?

     reqorg factor. Does the ad mention some organizational skills
          requirement?

     industry factor indicating type of employer industry.

Details

     Cross-section data about resume, call-back and employer
     information for 4,870 fictitious resumes sent in response to
     employment advertisements in Chicago and Boston in 2001, in a
     randomized controlled experiment conducted by Bertrand and
     Mullainathan (2004). The resumes contained information concerning
     the ethnicity of the applicant. Because ethnicity is not typically
     included on a resume, resumes were differentiated on the basis of
     so-called “Caucasian sounding names” (such as Emily Walsh or
     Gregory Baker) and “African American sounding names” (such as
     Lakisha Washington or Jamal Jones). A large collection of
     fictitious resumes were created and the pre-supposed ethnicity
     (based on the sound of the name) was randomly assigned to each
     resume. These resumes were sent to prospective employers to see
     which resumes generated a phone call from the prospective
     employer.

Source

     Online complements to Stock and Watson (2007).

References

     Bertrand, M. and Mullainathan, S. (2004). Are Emily and Greg More
     Employable Than Lakisha and Jamal? A Field Experiment on Labor
     Market Discrimination.  _American Economic Review_, *94*,
     991-1013.

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

name: factor ; missing=0 ; examples=Allison, Kristen, Lakisha

gender: factor ; missing=0 ; examples=female

ethnicity: factor ; missing=0 ; examples=cauc, afam

quality: factor ; missing=0 ; examples=low, high

call: factor ; missing=0 ; examples=no

city: factor ; missing=0 ; examples=chicago

jobs: integer ; missing=0 ; examples=2, 3, 1

experience: integer ; missing=0 ; examples=6

honors: factor ; missing=0 ; examples=no

volunteer: factor ; missing=0 ; examples=no, yes

military: factor ; missing=0 ; examples=no, yes

holes: factor ; missing=0 ; examples=yes, no

school: factor ; missing=0 ; examples=no, yes

email: factor ; missing=0 ; examples=no, yes

computer: factor ; missing=0 ; examples=yes

special: factor ; missing=0 ; examples=no

college: factor ; missing=0 ; examples=yes, no

minimum: factor ; missing=0 ; examples=5

equal: factor ; missing=0 ; examples=yes

wanted: factor ; missing=0 ; examples=supervisor

requirements: factor ; missing=0 ; examples=yes

reqexp: factor ; missing=0 ; examples=yes

reqcomm: factor ; missing=0 ; examples=no

reqeduc: factor ; missing=0 ; examples=no

reqcomp: factor ; missing=0 ; examples=yes

reqorg: factor ; missing=0 ; examples=no

industry: factor ; missing=0 ; examples=manufacturing

Examples
Run this code

     data("ResumeNames")
     summary(ResumeNames)
     prop.table(xtabs(~ ethnicity + call, data = ResumeNames), 1)

