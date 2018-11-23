## All Rmarkdown files in the working directory

SRCDIR = source
OUTDIR = docs

RMD = $(wildcard $(SRCDIR)/*.Rmd)

# HTML  = $(RMD:.Rmd=.html)
TMP  = $(RMD:.Rmd=.html)
HTML = ${subst $(SRCDIR),$(OUTDIR),$(TMP)}

all: clean update html

html:	$(HTML)

# %.html: %.Rmd
$(OUTDIR)/%.html: $(SRCDIR)/%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_format = 'prettydoc::html_pretty', output_dir = './$(OUTDIR)/')"

update:
	@Rscript -e "devtools::load_all(here::here()); emeScheme:::updateFromGoogleSheet(token = './source/googlesheets_token.rds')"

publish:
	git add DESCRIPTION data/emeScheme.rda data/emeScheme_gd.rda inst/googlesheet/emeScheme.xlsx docs/index.html
	git commit -m "Update From Googlesheets"
	git push

clean:
	rm -f $(HTML)

files:
	@echo RMD: $(RMD)
	@echo TMP: $(TMP)
	@echo HTML: $(HTML)

## from https://stackoverflow.com/a/26339924/632423
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

.PHONY: list files update clean all publish
