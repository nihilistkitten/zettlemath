BUILD_DIR = build
OUT_DIR = notes

.PHONY: clean all _build

all: $(patsubst %.tex,$(OUT_DIR)/%.pdf,$(wildcard *.tex))

$(OUT_DIR)/%.pdf: $(BUILD_DIR)/%.pdf $(OUT_DIR)
	cp $< $(OUT_DIR)

$(BUILD_DIR)/%.pdf: %.tex resources/*
	latexmk -pdflua -halt-on-error -output-directory=$(BUILD_DIR) $<

$(OUT_DIR):
	mkdir $(OUT_DIR)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
	-rm -rf $(BUILD_DIR) $(OUT_DIR)
