MAIN_JOB := LALU

LATEXMK := latexmk
LATEXMK_FLAGS := \
	-xelatex \
	-interaction=nonstopmode \
	-halt-on-error \
	-file-line-error \
	-no-shell-escape
ANSWER_BUILD_DIR := build/answers
ANSWER_MANIFEST := $(ANSWER_BUILD_DIR)/$(MAIN_JOB).manifest.tex
ANSWER_PUBLISHER := scripts/publish-answer-manifest.pl

.PHONY: all clean

all:
	@mkdir -p $(ANSWER_BUILD_DIR)
	@set -eu; \
	answer_tmp=$$(mktemp "$(ANSWER_BUILD_DIR)/$(MAIN_JOB).manifest.XXXXXX"); \
	answer_stage=$$(mktemp -d "$(ANSWER_BUILD_DIR)/$(MAIN_JOB).answers.XXXXXX"); \
	cleanup() { \
		rm -f "$$answer_tmp"; \
		rm -rf -- "$$answer_stage"; \
	}; \
	trap cleanup EXIT HUP INT TERM; \
	$(LATEXMK) -g $(LATEXMK_FLAGS) \
		-usepretex="\\def\\LALUAnswerManifestTempPath{$$answer_tmp}" \
		$(MAIN_JOB).tex; \
	perl $(ANSWER_PUBLISHER) --check "$$answer_tmp"; \
	$(LATEXMK) -g $(LATEXMK_FLAGS) \
		-outdir="$$answer_stage" \
		-usepretex="\\def\\LALUAnswerManifestPath{$$answer_tmp}\\def\\LALUAnswerManifestJob{$(MAIN_JOB)}" \
		LALU-answers.tex; \
	test -s "$(MAIN_JOB).pdf"; \
	test -s "$$answer_stage/LALU-answers.pdf"; \
	mv "$$answer_stage/LALU-answers.pdf" LALU-answers.pdf; \
	perl $(ANSWER_PUBLISHER) --publish "$$answer_tmp" "$(ANSWER_MANIFEST)"

clean:
	rm -f *.aux *.log *.idx *.ind *.ilg *.thm *.toc *.blg *.bbl *.bcf *.out *.fls *.fdb_latexmk *.run.xml *.synctex.gz *.xdv *~ *.lof *.lot
	rm -f LALU-ans-contents.tex *.answer-manifest.pending.tex
	rm -rf -- $(ANSWER_BUILD_DIR)
