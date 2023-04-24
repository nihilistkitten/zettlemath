BUILD_DIR = build
OUT_DIR = notes

LATEX_ARGS = -halt-on-error -shell-escape
SPECIAL = index.pdf

.PHONY: clean all _build

all: $(filter-out $(OUT_DIR)/index.pdf, $(patsubst %.tex,$(OUT_DIR)/%.pdf,$(wildcard *.tex))) $(OUT_DIR)/index.pdf

$(OUT_DIR)/%.pdf: $(BUILD_DIR)/%.pdf $(OUT_DIR)
	cp $< $(OUT_DIR)

$(BUILD_DIR)/%.pdf: %.tex resources/*
	latexmk -pdflua $(LATEX_ARGS) -output-directory=$(BUILD_DIR) $<

$(OUT_DIR):
	mkdir $(OUT_DIR)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
	-rm -rf $(BUILD_DIR) $(OUT_DIR)
