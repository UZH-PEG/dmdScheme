# `dmdScheme`  
An R Package to develop and manage Domain Specific Metadata Schemes (dmdSchemes)

## General

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3581970.svg)](https://doi.org/10.5281/zenodo.3581970)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.png)](https://www.tidyverse.org/lifecycle/#stable)

## Checks

[![R-CMD-check](https://github.com/UZH-PEG/dmdScheme/workflows/R-CMD-check/badge.svg)](https://github.com/UZH-PEG/dmdScheme/actions)
[![:registry status
badge](https://uzh-peg.r-universe.dev/badges/:registry)](https://uzh-peg.r-universe.dev)

## Coverage

[![codecov coverage
status](https://codecov.io/gh/UZH-PEG/dmdScheme/branch/master/graph/badge.svg?token=hCiW2fKgTv)](https://codecov.io/gh/UZH-PEG/dmdScheme)

## CRAN (might be behind the R-Universe, but more stable)

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/dmdScheme)](https://cran.r-project.org/package=dmdScheme)
[![CRAN_Status_Badge_version_last_release](https://www.r-pkg.org/badges/version-last-release/dmdScheme)](https://cran.r-project.org/package=dmdScheme)
[![](http://cranlogs.r-pkg.org/badges/grand-total/dmdScheme?color=green)](https://cran.r-project.org/package=dmdScheme)

## R-Universe (official distribution channel of the `master` branch of github)

[![:name status
badge](https://uzh-peg.r-universe.dev/badges/:name)](https://uzh-peg.r-universe.dev)
[![dmdScheme status
badge](https://uzh-peg.r-universe.dev/badges/dmdScheme)](https://uzh-peg.r-universe.dev)

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

The easiest way is to install from CRAN

```{r}
install.packages("dmdScheme")
```

The CRAN release might be behind the R-Universe (which reflects the `master` branch), but would be the conservative choice.

The recommended way to install the version which is the last one on the `master` branch from the
[R-Universe](https://uzh-peg.r-universe.dev/) where the stable released
will always be available:

```{r}
# Enable universe by uzh-peg
options(repos = c(
  uzhpeg = 'https://uzh-peg.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))

# Install dmdScheme
install.packages('dmdScheme')
```

If you are feling adventurous, want to live at the bleeding edge and can
live with non-working features, you can install the **dev** branch. This
branch is under development and **not guranteed to be stable**! Features
and functionality can appear or be removed without prior notice:

``` r
## install the remotes package if not installed yet
if (require("remotes")) {
  install.packages("remotes")
}

devtools::install_github("Exp-Micro-Ecol-Hub/dmdScheme", ref = "dev", build_opts = NULL)
```

Other branches are not generally recommended for installation unless you
are developing `dmdScheme` or need certain features available in other
brances!

## Loading the package

When you load the package, the definition of the scheme is downloaded
from the [dmdScheme
repository](https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/tree/master)
and installed in a temporary scheme library in a temporary directory for
usage in this R session only. As this scheme library is stored in a
temporary directory, it will be deleted when you quit your R session and
must be re-downloaded each time you start a new session and load the
package. To create a permanent package library you have to create a
cache in the user directory. To do this, run

``` r
library(dmdScheme)
cache(createPermanent = TRUE)
```

and restart your R session. Now the definitions of the installed
`dmdSchemes` will be installed in this user cache and be available
permanently. For further info, see the documentation of the command
`cache()` in the `dmdScheme` package.

## Accompagnying documentation (vignettes)

-   <a href="r_package_introduction.html" target="_blank">‘R Package
    Introduction’</a> for a general description of the package
-   <a href="Howto_create_new_scheme.html" target="_blank">‘Howto Create
    a new scheme’</a> for a walk-through of creating a new scheme
-   <a href="minimum_requirements_dmdscheme.html" target="_blank">‘Minimum
    requirements for metadatascheme based on dmdScheme’</a> for the
    minimum requirements of what a new scheme definition must contain.

# Other Resources

## Example scheme

For a workable example with data see the documentation of the
[emeScheme](https://exp-micro-ecol-hub.github.io/emeScheme/)

## Presentations

-   July 2019: [Metadata is
    sexy!](https://rkrug.github.io/metadata_is_sexy/metadata_is_sexy.html)
    by Rainer M. Krug  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3246331.svg)](https://doi.org/10.5281/zenodo.3246331)
-   September 2019: [Live
    Demo](https://rkrug.github.io/LiveDemoDmdScheme/) by Rainer M.
    Krug  
-   September 2019, GFÖ, Münster: [Metadata can be
    easy!](https://rkrug.github.io/GFO_2019) by Rainer M. Krug & Owen L.
    Petchey  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3386077.svg)](https://doi.org/10.5281/zenodo.3386077)
-   [From Zero to Hero - Metadata Made
    Easy!](https://rkrug.github.io/from_zero_to_hero-metadata_made_easy/from_zero_to_hero-metadata_can_be_easy.html)
    by Rainer M. Krug  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3517816.svg)](https://doi.org/10.5281/zenodo.3517816)
-   December 2019, BES, Belfast: Metadata made easy by Rainer M. Krug &
    Owen L. Petchey  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3571351.svg)](https://doi.org/10.5281/zenodo.3571351)

# Outdated Resources (**Just for historical reasons**)

## Presentations

-   December 2018: [The dmdScheme - an
    Introduction](https://rkrug.github.io/emeScheme_Introduction/The_emeScheme.html)
    by Rainer M Krug  
    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2244998.svg)](https://doi.org/10.5281/zenodo.2244998)

------------------------------------------------------------------------

Please see the [github repository](https://UZH-PEG.github.io/dmdScheme/)
or the [dmdScheme Homepage](https://uzh-peg.github.io/dmdScheme/) for
details.

# Other Links:

-   The [Experimental Microbial Ecology Hub](http://emeh.info)
-   The [Experimental Microbial Ecology
    Protocols](http://emeh-protocols.readthedocs.org/en/latest/)
