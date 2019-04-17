## R parts based on https://github.com/yihui/knitr/blob/master/Makefile

PKGNAME := $(shell sed -n "s/^Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/^Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)


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

all: check clean_web web clean_check

####

clean: clean_web

########### Website ###########

####

readme: $(READMEMD)
Readme.md: $(READMERMD)
	@Rscript -e "rmarkdown::render('$(READMERMD)', output_format = 'rmarkdown::github_document')"
	rm -f $(READMEHTML)

clean_readme:
	rm -f $(READMEMD)

####

vignettes: $(VIGHTML)

$(VIGHTML): $(VIGRMD)
	@Rscript -e "devtools::build_vignettes()"

clean_vignettes:
	@Rscript -e "devtools::clean_vignettes()"

#####

html:	$(HTML)
# %.html: %.Rmd
$(OUTDIR)/%.html: $(SRCDIR)/%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_format = 'prettydoc::html_pretty', output_dir = './$(OUTDIR)/')"

clean_html:
	rm -f $(HTML)

####

web: html vignettes readme
	cp -f $(VIGHTML) $(OUTDIR)/
	mkdir -p $(DATADIR)
	cp -f $(EXAMPLEXML) $(DATADIR)/

clean_web: clean_html clean_vignettes clean_readme
	rm -f VIGHTMLOUT
	rm -rf $(DATADIR)

####

########### Package  ###########

####

update:
	Rscript -e "devtools::load_all(here::here()); emeScheme:::updateFromNewSheet()"

####

updateForce:
	@Rscript -e "devtools::load_all(here::here()); emeScheme:::updateFromNewSheet(force = TRUE)"

####

docs:
	Rscript -e "devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))"

build:
	cd ..;\
	R CMD build --no-manual $(PKGSRC)

####

build-cran:
	cd ..;\
	R CMD build $(PKGSRC)

####

install: build
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

####

check: build-cran
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

clean_check:
	$(RM) -r ./../$(PKGNAME).Rcheck/

####

test:
	@Rscript -e "devtools::test()"

####

############# Help targets #############

list_variables:
	@echo
	@echo "#############################################"
	@echo "## Variables ################################"
	make -pn | grep -A1 "^# makefile"| grep -v "^#\|^--" | sort | uniq
	@echo "#############################################"
	@echo ""

## from https://stackoverflow.com/a/26339924/632423
list_targets:
	@echo
	@echo "#############################################"
	@echo "## Targets    ###############################"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo "#############################################"
	@echo

list: list_variables list_targets

#############

.PHONY: list files update clean clean_vignettes clean_web clean_html publish docs
