The `.md` in `/src` are compiled to PDFs, which are then moved to `/pdfs`.

**Look in `/pdfs` for curricular materials. View `overview.md` or `overview.pdf` for details.**

The Python script `build.py` calls GNU `make` on each subdirectory, converting Markdown files to PDFs (this is true of all subdirectories in this repository), and then moves files in `/src` with extensions *not* `.md` into the `/pdfs` folder.