TEMPLATE = "/home/kironide/Shared/Programming/andrewjho/_inc/pandoc-template.php"

MDS = $(wildcard *.md)
PDFS = $(patsubst %.md,%.pdf,$(MDS))
.PHONY: all
all: $(PDFS)

%.pdf: %.md
	pandoc "$<" -o "$@" -f markdown -t latex --smart -M colorlinks:true

.PHONY: clean
clean:
	rm -f $(PHPS)
