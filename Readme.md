Domain specific MetaData Scheme (dmdScheme): Package to develop and
manage Domain Specific Metadata Schemes
================
Rainer M. Krug
30 April, 2020

<!-- README.md is generated from README.Rmd. Please edit that file -->

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3581970.svg)](https://doi.org/10.5281/zenodo.3581970)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/dmdScheme)](https://cran.r-project.org/package=dmdScheme)
[![CRAN\_Status\_Badge\_version\_last\_release](https://www.r-pkg.org/badges/version-last-release/dmdScheme)](https://cran.r-project.org/package=dmdScheme)

**master**: [![Build
Status](https://travis-ci.org/Exp-Micro-Ecol-Hub/dmdScheme.svg?branch=master)](https://travis-ci.org/Exp-Micro-Ecol-Hub/dmdScheme)
[![Coverage
status](https://codecov.io/gh/Exp-Micro-Ecol-Hub/dmdScheme/branch/master/graph/badge.svg)](https://codecov.io/github/Exp-Micro-Ecol-Hub/dmdScheme?branch=master)

**dev**: [![Build
Status](https://travis-ci.org/Exp-Micro-Ecol-Hub/dmdScheme.svg?branch=dev)](https://travis-ci.org/Exp-Micro-Ecol-Hub/dmdScheme)
[![Coverage
status](https://codecov.io/gh/Exp-Micro-Ecol-Hub/dmdScheme/branch/master/graph/badge.svg)](https://codecov.io/github/Exp-Micro-Ecol-Hub/dmdScheme?branch=dev)
<!-- [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/Exp-Micro-Ecol-Hub/dmdScheme?branch=master&svg=true)](https://ci.appveyor.com/project/Exp-Micro-Ecol-Hub/dmdScheme) -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-orange.png)](https://www.tidyverse.org/lifecycle/#maturing)

-----

# dmdScheme version v1.1.3.1

Github site <https://github.com/Exp-Micro-Ecol-Hub/dmdScheme>

# The R Package

The R package `dmdScheme` is the base package for all `dmdScheme`
schemes. The metadata scheme used by this package (`dmdScheme`) in
itself is just a template and of no real applicability. It needs to be
adjusted to actual needs and uploaded to the site [dmdScheme
repository](https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/tree/master)
so that it can be used.

The definition of the dmdScheme can be found at the [dmdScheme
repository](https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository).
The R package provides the functionality to work in R with the scheme,
i.e. to enter, validate and export the metadata.

## Installation

The recommended way is to install from CRAN the stable released version:

``` r
install.packages("dmdScheme")
```

To install the **master** branch, the stable branch which will become
the new CRAN release, from the [dmdScheme repository on
github](https://github.com/Exp-Micro-Ecol-Hub/dmdScheme/tree/master),
run

``` r
## install the devtools package if not installed yet
# install.packages("devtools")

devtools::install_github("Exp-Micro-Ecol-Hub/dmdScheme", ref = "master", build_opts = NULL)
```

If you are feeling adventourous, want to live at the bleeding edge and
can live with non-working features, you can install the **dev** branch.
This branch is **not stable** and features and functionality can appear
or be remioved without prior notice:

``` r
## install the devtools package if not installed yet
# install.packages("devtools")

devtools::install_github("Exp-Micro-Ecol-Hub/dmdScheme", ref = "dev", build_opts = NULL)
```

Other branches are not generally recommended for instalation unless you
are developing `dmdScheme`\!

## Loading the package

When you load the package, the definition of the scheme is downloaded
from the [dmdScheme
repository](https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/tree/master)
installed to a temporary scheme library in a temporary directory for
usage in this R session. As this scheme library is styored in a
temporary directory, it will be deleted when youu quit your R session
and re-downloaded each time you start a new session and load the
package. To create a permanent package library you have to create a
cache in the user directory. To do this, run

``` r
cache(createPermanent = TRUE)
```

and restart your R session. Noiw the definitions of the installed
`dmdSchemes` will be installed in this user cache and be available
permanently. For further info, see the documenatation of the command
`cache()`.

## Accompagnying documentation (vignettes)

  - <a href="r_package_introduction.html" target="_blank">‘R Package
    Introduction’</a> for a general description of the package
  - <a href="Howto_create_new_scheme.html" target="_blank">‘Howto Create
    a new scheme’</a> for a walk-through of creating a new scheme
  - <a href="minimum_requirements_dmdscheme.html" target="_blank">‘Minimum
    requirements for metadatascheme based on dmdScheme’</a> for the
    minimum requirements of what a new scheme definition must contain.

# Other Resources

## Example scheme

For a workable example with data see the documentation of the
[emeScheme](https://exp-micro-ecol-hub.github.io/emeScheme/)

## Presentations

  - July 2019: [Metadata is
    sexy\!](https://rkrug.github.io/metadata_is_sexy/metadata_is_sexy.html)
    by Rainer M. Krug  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3246331.svg)](https://doi.org/10.5281/zenodo.3246331)
  - September 2019: [Live
    Demo](https://rkrug.github.io/LiveDemoDmdScheme/) by Rainer M.
    Krug  
  - September 2019, GFÖ, Münster: [Metadata can be
    easy\!](https://rkrug.github.io/GFO_2019) by Rainer M. Krug & Owen
    L. Petchey  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3386077.svg)](https://doi.org/10.5281/zenodo.3386077)
  - [From Zero to Hero - Metadata Made
    Easy\!](https://rkrug.github.io/from_zero_to_hero-metadata_made_easy/from_zero_to_hero-metadata_can_be_easy.html)
    by Rainer M. Krug  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3517816.svg)](https://doi.org/10.5281/zenodo.3517816)
  - December 2019, BES, Belfast: Metadata made easy by Rainer M. Krug &
    Owen L. Petchey  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3571351.svg)](https://doi.org/10.5281/zenodo.3571351)

# Outdated Resources (**Just for historical reasons**)

## Presentations

  - December 2018: [The dmdScheme - an
    Introduction](https://rkrug.github.io/emeScheme_Introduction/The_emeScheme.html)
    by Rainer M Krug  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2244998.svg)](https://doi.org/10.5281/zenodo.2244998)

# Other Links:

  - The [Experimental Microbial Ecology Hub](http://emeh.info)
  - The [Experimental Microbial Ecology
    Protocols](http://emeh-protocols.readthedocs.org/en/latest/)
