# FIXME: xindy can't handle UTF-8 filenames
FILENAME := 线性代数荣誉课辅学讲义
CPNAME := LALU

LATEXMK := latexmk
LATEXMK_FLAGS := -xelatex -shell-escape -interaction=nonstopmode -file-line-error

.PHONY: all clean

all:
	# Building $(FILENAME).pdf
ifdef CPNAME
	@cp -p $(FILENAME).tex $(CPNAME).tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(CPNAME).tex
	@rm -f $(CPNAME).tex
	-@mv $(CPNAME).pdf $(FILENAME).pdf
else
	$(LATEXMK) $(LATEXMK_FLAGS) $(FILENAME).tex
endif
	# Building answers.pdf
	$(LATEXMK) $(LATEXMK_FLAGS) LALU-answers.tex

clean:
	rm -f *.aux *.log *.idx *.ind *.ilg *.thm *.toc *.blg *.bbl *.bcf *.out *.fls *.fdb_latexmk *.run.xml *.synctex.gz *.xdv *~ *.lof *.lot
ifdef CPNAME
	rm -f $(CPNAME).pdf $(CPNAME).tex
endif
