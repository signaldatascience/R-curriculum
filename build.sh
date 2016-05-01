find ./ -iname "*.md" -type f -exec sh -c 'pandoc --smart --ascii -f markdown -t html --mathjax -s "${0}" -o "${0%.md}.html"' {} \;
