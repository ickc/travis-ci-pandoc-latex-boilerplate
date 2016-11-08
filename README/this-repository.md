# Description

This is a test of the config of travis CI on a private project.

-   `README-*.md` are empty except for `README-main.md`.
-   `makefile`, `workbook.sty`, `workbook.yml`, `.gitignore`, `script/*` are from the project, `README-main.md` are appended from the project
-   `workbook.csv`, `test1*`, `test2*` are dummy contents
-   `make.sh` auto copies the necessary files from the private repository

## Testing Travis CI With Pandoc and TeXLive

-   pandoc convert `.md` to `.tex` & `.pdf`
-   latexmk compile `.tex` to `.pdf`

## Todo

-   `lint`

## Statistics

| OS              | Language | Time       |                                                                Travis CI Build \#|
|-----------------|----------|------------|---------------------------------------------------------------------------------:|
| Ubuntu 12.04    | R        | 1 min 20 s |  [107.1](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174107099)|
| Ubuntu 14.04    | R        | 1 min 34 s |  [107.2](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174107100)|
| Ubuntu 14.04    | Python   | 8 min 21 s |  [107.3](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174107101)|
| OS X El Capitan | R        | 8 min 25 s |  [107.4](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174107102)|
| OS X El Capitan | Generic  | 6 min 42 s |  [107.5](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174107103)|

<!-- from the private project: -->

