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

| OS              | Language  | Time       |                                                                Travis CI Build \#|
|-----------------|-----------|------------|---------------------------------------------------------------------------------:|
| Ubuntu 12.04    | R         | 1 min 15 s |  [111.1](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118169)|
| Ubuntu 14.04    | R         | 1 min 46 s |  [111.2](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118170)|
| Ubuntu 14.04    | Python    | 8 min 23 s |  [111.3](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118171)|
| OS X El Capitan | R         | 7 min 58 s |  [111.4](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118172)|
| OS X El Capitan | Generic   | 2 min 07 s |  [111.5](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118173)|
| OS X El Capitan | R, Xcode8 | 7 min 48 s |  [111.6](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118174)|
| OS X El Capitan | Xcode8    | 3 min 44 s |  [111.7](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/jobs/174118175)|

<!-- from the private project: -->

