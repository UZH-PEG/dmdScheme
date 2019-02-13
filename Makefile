## All Rmarkdown files in the working directory

SRCDIR = source
OUTDIR = docs
DATADIR = $(OUTDIR)/data
INSTDIR = inst

VIGDIR = vignettes
VIGHTMLDIR = doc

DOCDIR = doc

VIGRMD = $(wildcard $(VIGDIR)/*.Rmd)
TMP1  = $(VIGRMD:.Rmd=.html)
VIGHTML = ${subst $(VIGDIR),$(VIGHTMLDIR),$(TMP1)}
VIGHTMLOUT = ${subst $(VIGDIR),$(OUTDIR),$(TMP1)}

EXAMPLEXML = $(wildcard $(INSTDIR)/emeScheme_example.xml)

RMD = $(wildcard $(SRCDIR)/*.Rmd)
TMP2  = $(RMD:.Rmd=.html)
HTML = ${subst $(SRCDIR),$(OUTDIR),$(TMP2)}

READMERMD = Readme.Rmd
READMEMD = Readme.md
READMEHTML = Readme.html

#############

all: clean update web

#############

readme: $(READMEMD)
Readme.md: $(READMERMD)
	@Rscript -e "rmarkdown::render('$(READMERMD)', output_format = 'rmarkdown::github_document')"
	rm -f $(READMEHTML)

clean_readme:
	rm -f $(READMEMD)

#############

vignettes: $(VIGHTML)

$(VIGHTML): $(VIGRMD)
	@Rscript -e "devtools::build_vignettes()"

clean_vignettes:
	@Rscript -e "devtools::clean_vignettes()"

#############

html:	$(HTML)
# %.html: %.Rmd
$(OUTDIR)/%.html: $(SRCDIR)/%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_format = 'prettydoc::html_pretty', output_dir = './$(OUTDIR)/')"

clean_html:
	rm -f $(HTML)

#############

web: html vignettes readme
	cp -f $(VIGHTML) $(OUTDIR)/
	mkdir -p $(DATADIR)
	cp -f $(EXAMPLEXML) $(DATADIR)/

clean_web: clean_html clean_vignettes clean_readme
	rm -f VIGHTMLOUT
	rm -rf $(DATADIR)

#############

update:
	@Rscript -e "devtools::load_all(here::here()); emeScheme:::updateFromGoogleSheet(token = './source/googlesheets_token.rds')"

#############

test:
	@Rscript -e "devtools::test()"

#############

check:
	@Rscript -e "devtools::check(args = c('--as-cran'))"

#############

publish:
	git add DESCRIPTION data/emeScheme.rda data/emeScheme_gd.rda inst/googlesheet/emeScheme.xlsx docs/index.html
	git commit -m "Update From Googlesheets"
	git push

#############

clean: clean_web

#############

list_files:
	@echo SRCDIR  : $(SRCDIR)
	@echo OUTDIR  : $(OUTDIR)
	@echo DATADIR : $(DATADIR)
	@echo
	@echo VIGDIR  : $(VIGDIR)
	@echo VIGHTMLDIR  : $(VIGHTMLDIR)
	@echo
	@echo READMERMD : $(READMERMD)
	@echo READMEMD : $(READMEMD)
	@echo
	@echo VIGRMD  : $(VIGRMD)
	@echo TMP1    : $(TMP1)
	@echo VIGHTML : $(VIGHTML)
	@echo VIGHTMLOUT : $(VIGHTMLOUT)
	@echo
	@echo RMD     : $(RMD)
	@echo TMP2    : $(TMP2)
	@echo HTML    : $(HTML)
	@echo
	@echo EXAMPLEXML : $(EXAMPLEXML)

## from https://stackoverflow.com/a/26339924/632423
list: list_files
	@echo
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

#############

.PHONY: list files update clean clean_vignettes clean_web clean_html publish
