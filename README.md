# Description

This is a test of the config of travis CI on a private project.

- `README-*.md` are empty
- `makefile`, `workbook.sty`, `workbook.yml`, `.gitignore` are from the project
- `README.md`, `workbook.csv`, `test1*`, `test2*` are dummy contents

# Testing Travis CI With Pandoc and TeXLive

- pandoc convert `.md` to `.tex` & `.pdf`
- latexmk compile `.tex` to `.pdf`

# Todo

- `lint`
