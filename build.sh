#find /home/kironide/Shared/Documents/Signal/curriculum/ -iname "*.md" -type f -exec sh -c 'pandoc --smart --ascii -f markdown -t html -s "${0}" -o "${0%.md}.html"' {} \;
find /home/kironide/Shared/Documents/Signal/curriculum/ -iname "*.md" -type f -exec sh -c 'pandoc --smart -f markdown -t latex -s "${0}" -o "${0%.md}.pdf"' {} \;
