# This file is included by Makefile in subdirectories.

LATEXMK = latexmk
LATEXMK_FLAGS = -xelatex -shell-escape -interaction=nonstopmode -file-line-error

.PHONY: all clean

all:
	# Building $(FILENAME).pdf
ifdef CPNAME
	@cp -p $(FILENAME).tex $(CPNAME).tex
	-$(LATEXMK) $(LATEXMK_FLAGS) $(CPNAME).tex
	@rm -f $(CPNAME).tex
	-@mv $(CPNAME).pdf $(FILENAME).pdf
else
	- $(LATEXMK) $(LATEXMK_FLAGS) $(FILENAME).tex
endif

clean:
	@rm -f *.aux *.log *.idx *.ind *.ilg *.thm *.toc *.blg *.bbl *.bcf *.out *.fls *.fdb_latexmk *.run.xml *.synctex.gz *.xdv *~ *.lof *.lot
