## Based on https://github.com/kjhealy/rmd-starter/blob/master/Makefile

### From Rmd to PDF or html via md

## A Makefile in for your Rmarkdown-based paper project.
## Assuming you are using the rest of my templates and toolchain,
## (see http://kieranhealy.org/resources) you can use it
### to create .html, .tex, and .pdf output files (complete with
### bibliography, if present) from your Rmarkdown file.
## -    Install the `pandoc-citeproc` and `pandoc-citeproc-preamble`
##      filters for `pandoc`.
## -	Change the paths at the top of the file as needed.
## -	Using `make` without arguments will generate html, tex, and pdf
## 	output files from all of the `.Rmd` files in the folder.
##      The `.md` files are created from `.Rmd` sources via R and `knitr`.
## -	You can specify an output format with `make tex`, `make pdf` or
## - 	`make html`.
## -	Doing `make clean` will remove all the .md .tex, .html, and .pdf files
## 	in your working directory. Make sure you do not have files in these
##	formats that you want to keep!

## All Rmarkdown files in the working directory
OUTDIR='./docs/'

SRC = $(wildcard ./source/*.Rmd)

HTML  = $(SRC:.Rmd=.html)


html:	$(HTML)

%.html:	%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_format = 'prettydoc::html_pretty', output_dir = $(OUTDIR))"


# clean: cleanhtml

# cleanhtml:
#	rm -f $(OUTDIR)

#cleancache:
#	rm -rf *_cache

all: clean html

## from https://stackoverflow.com/a/26339924/632423
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

.PHONY: clean cleanhtml all list
