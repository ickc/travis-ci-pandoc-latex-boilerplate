# Description

This is a test of the config of travis CI on a private project.

- `README-*.md` are empty except for `README-main.md`.
- `makefile`, `workbook.sty`, `workbook.yml`, `.gitignore`, `script/*` are from the project, `README-main.md` are appended from the project
- `workbook.csv`, `test1*`, `test2*` are dummy contents
- `make.sh` auto copies the necessary files from the private repository

## Testing Travis CI With Pandoc and TeXLive

- pandoc convert `.md` to `.tex` & `.pdf`
- latexmk compile `.tex` to `.pdf`

## Todo

- `lint`

## Statistics

| OS	| Language	| pandoc/LaTeX	| Time	| Travis CI Build #	|  
|  ------	| ------	| ------	| ------	| ------:	|  
| Ubuntu 12.04	| R	| Both	| 2 min 15 s	| [54](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/168124576)	| 
| Ubuntu 14.04	| R	| LaTeXmk	| 1 min 40 s	| [37](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167984036)	|  
| Ubuntu 14.04	| R	| pandoc	| 1 min 47 s	| [36](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167983871)	|  
| Ubuntu 14.04	| R	| Both	| 1 min 57 s	| [34](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167982738)	|  
| OS X El Capitan	| R	| LaTeXmk	| 6 min 9 s	| [39](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167984116)	|  
| OS X El Capitan	| R	| pandoc	| 6 min 31 s	| [38](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167984066)	|  
| OS X El Capitan	| R	| Both	| 7 min 4 s	| [35](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167983084)	|  
| Ubuntu 14.04	| Python	| Both	| 8 min 14 s	| [27](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167979150)	|  
| Dual OSes	| R	| Both	| 9 min 40 s	| [43](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/167995239)	|  
| Triple OSes	| R	| Both	| 8 min 35 s	| [55](https://travis-ci.org/ickc/travis-ci-pandoc-latex-config/builds/168132853)	|  

<!-- from the private project: -->

# Organization

The file and folder structure is

* `<collection>/<unit>.md`: contain the smallest indivisible unit, *e.g.* a single problem/lab
* `<collection>/media/<unit>-#.*`: contain the corresponding media file. *e.g.* `.ai`
* `<collection>.csv`: for bookkeeping and also for auto-generating the necessary files according to the `filename` column and the first few columns declaring if the unit should be included in the workbook or not. Each row is a `<unit>`.
* `workbook.csv`: similar to `<collection>.csv`, but each row represent a `<collection>` instead.
* `workbook.yml`: containing the metadata of the workbooks. It controls most of the styles too (*e.g.* memoir class).
* `workbook.sty`: finer control of the style than the above.

The output files will be named `workbook*.pdf` where `*` can be `7a`, `8a`, `master`, etc.

# Dependencies

Run the `script/install-*.sh` scripts to install the dependencies for the project:

- `install-<OS>.sh` installs:
	- pandoc
	- pip & pandocfilters
- `install-<OS>-<TeX>.sh` install TeXLive

# Makefile

## Building the PDFs

`makefile`: all actions required to build the workbook is there. In terminal,

- `cd` into the folder
- `make` will compile the workbook
- `make pandoc` will compile the workbook in an alternative way. The resulting PDFs should be visually identical to `make`.
- `make clean` will delete all auxiliary files other than the PDFs
- `make Clean` (notice the capital `C`) will delete all auxiliary files **including** the PDFs
- To terminate the process, use `Ctrl-D` or `Ctrl-C`.

## Preprocessing Individual Problems

The `makefile` contains a lot of helpful commands for initial creation of problems:

- `make touch`: create every files expected from the `.csv` filenames.
- `make enclose`: enclose every problem with a problem environment if not present yet.
- `make normalize`: normalize white spaces in the files.
- `make greek`: convert unicode Greek characters to LaTeX's command (which comes from conversion from `.docx`). This is not perfect but to save you some work, and to make sure `pdflatex` can handle it.
- `make lint`: use `chktex` and `pacheco` to check for potential typographical mistakes in the files.

# Naming Convention

Starting from `2d-kinematics`, the filename should follow the convention:

- Make a title first. This will becomes the title shown in the workbooks. *e.g.* "Water-ballon Cannon on Cliff"
- Replaces hyphens by underscores: "Water_ballon Cannon on Cliff"
- Replaces spaces by hyphens: "Water_ballon-Cannon-on-Cliff"
- For headline or caption, drop all articles. See references below:
	1. [5 tested rules to follow when writing headlines](http://www.easymedia.in/5-tested-rules-to-follow-when-writing-headlines/)
	2. [Article drop in headlines and truncation of CP](http://www.linguisticsociety.org/sites/default/files/3540-6845-1-SM.pdf)
	3. [Article drop in English headlinese](http://folk.ntnu.no/andrewww/Weir-2009-headlinese.pdf)

Notice that in Mac the file system is by default case-insensitive. If you make a mistake in the cases, the error won't show up on your computer, but it will break the build for someone else (and Travis).

# Contributing

## Practices

- Italicize Latin: *e.g.*, *i.e.*
- LaTeX packages:
	- use `physics`: why:
		- try $\frac{dx}{dt}$ vs $\dv{x}{t}$.
		- exercise: how to correct the former one?
		- conclusion: it will be clumsy to type the correct expression without a macro. Using a standard package is better than creating your own macro using non-standard (or even standard) names.
	- use `sinunitx`
		- $$x(t) = 15~\mbox{m} + (20~\mbox{m/s}) t  -  (1.3~\mbox{m/s$^2$}) t^2$$ vs $$x(t) = \SI{15}{\m} + \pqty{\SI{20}{\m \per \s}} t  - \pqty{\SI{1.3}{\m \per \s^2}} t^2$$
- Prefer concise: *e.g.*
	- Prefer arabic numerals whenever possible (excluding in titles)
	- Prefer "$a$-$t$ graph" rather than "acceleration versus time graph", etc.
- other spelling: `vs.`

