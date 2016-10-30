#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
rsync -av --delete --include="main.md" --exclude="*" ../workbook-7-8/README/ ./README/
rsync -av --delete --include="makefile" --include="workbook.sty" --include="workbook.yml" --include=".gitignore" --include="script/*" --exclude="*" ../workbook-7-8/ ./
