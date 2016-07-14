TEMPLATE = "/home/kironide/Shared/Documents/Signal/curriculum/_build/pandoc-template-latex.latex"

MDS = $(wildcard *.md)
PDFS = $(patsubst %.md,%.pdf,$(MDS))
.PHONY: all
all: $(PDFS)

%.pdf: %.md
	pandoc "$<" -o "$@" -f markdown -t latex --template=$(TEMPLATE) --smart -M urlcolor:MidnightBlue -M fontfamily:mathpazo

.PHONY: clean
clean:
	rm -f $(PDFS)
