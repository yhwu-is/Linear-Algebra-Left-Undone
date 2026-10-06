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

FIGS_DIR := figs
FIGURE_TEX := $(filter-out $(FIGS_DIR)/preamble.tex,$(wildcard $(FIGS_DIR)/*.tex))
FIGURE_PDF := $(FIGURE_TEX:.tex=.pdf)

.PHONY: all figures figure clean

# 编译全部独立插图，或用 `make figure FIG=<文件名>` 编译其中一张。
all: figures
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

figures: $(FIGURE_PDF)

figure:
	@test -n "$(FIG)" || { echo "Usage: make figure FIG=<figure name>"; exit 1; }
	$(MAKE) $(FIGS_DIR)/$(FIG).pdf

$(FIGS_DIR)/%.pdf: $(FIGS_DIR)/%.tex $(FIGS_DIR)/preamble.tex
	$(LATEXMK) -cd $(LATEXMK_FLAGS) $<

clean:
	rm -f *.aux *.log *.idx *.ind *.ilg *.thm *.toc *.blg *.bbl *.bcf *.out *.fls *.fdb_latexmk *.run.xml *.synctex.gz *.xdv *~ *.lof *.lot
	rm -f LALU-ans-contents.tex *.answer-manifest.pending.tex
	rm -f $(FIGS_DIR)/*.aux $(FIGS_DIR)/*.log $(FIGS_DIR)/*.fls $(FIGS_DIR)/*.fdb_latexmk $(FIGS_DIR)/*.xdv $(FIGS_DIR)/*.out $(FIGS_DIR)/*.synctex.gz $(FIGS_DIR)/*.toc $(FIGS_DIR)/*.sta $(FIGS_DIR)/*.dpth $(FIGS_DIR)/*.md5
	rm -rf -- $(ANSWER_BUILD_DIR)
