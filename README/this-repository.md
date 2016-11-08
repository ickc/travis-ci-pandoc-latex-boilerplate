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

| OS              | Language | pandoc/LaTeX | Time       |                                                               Travis CI Build \#|
|-----------------|----------|--------------|------------|--------------------------------------------------------------------------------:|
| Ubuntu 12.04    | R        | Both         | 2 min 15 s |  [54](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/168124576)|
| Ubuntu 14.04    | R        | LaTeXmk      | 1 min 40 s |  [37](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167984036)|
| Ubuntu 14.04    | R        | pandoc       | 1 min 47 s |  [36](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167983871)|
| Ubuntu 14.04    | R        | Both         | 1 min 57 s |  [34](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167982738)|
| OS X El Capitan | R        | LaTeXmk      | 6 min 9 s  |  [39](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167984116)|
| OS X El Capitan | R        | pandoc       | 6 min 31 s |  [38](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167984066)|
| OS X El Capitan | R        | Both         | 7 min 4 s  |  [35](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167983084)|
| Ubuntu 14.04    | Python   | Both         | 8 min 14 s |  [27](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167979150)|
| Dual OSes       | R        | Both         | 9 min 40 s |  [43](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167995239)|
| Triple OSes     | R        | Both         | 8 min 35 s |  [55](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/168132853)|

<!-- from the private project: -->