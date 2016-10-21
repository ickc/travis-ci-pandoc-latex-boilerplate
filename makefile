SHELL := /bin/bash

# specify LaTeX engine
## LaTeX workflow: pdf; xelatex; lualatex
latexmkEngine := pdf
## pandoc workflow: pdflatex; xelatex; lualatex
pandocEngine := pdflatex

course := Master 7A 8A
# LaTeX workflow
latexmkTeX := $(addsuffix .tex,$(addprefix workbook-, $(course)))
latexmkPDF := $(addsuffix .pdf,$(addprefix workbook-, $(course)))
# pandoc workflow
pandocTeX := $(addsuffix .tex,$(addprefix workbook_, $(course)))
pandocPDF := $(addsuffix .pdf,$(addprefix workbook_, $(course)))

CSV := $(wildcard *.csv)
# LaTeX workflow
CSV2TeX7A := $(patsubst %.csv,%-7A.tex,$(CSV))
CSV2TeX8A := $(patsubst %.csv,%-8A.tex,$(CSV))
CSV2TeXMaster := $(patsubst %.csv,%-Master.tex,$(CSV))
# pandoc workflow
CSV2MD7A := $(patsubst %.csv,%-7A.md,$(CSV))
CSV2MD8A := $(patsubst %.csv,%-8A.md,$(CSV))
CSV2MDMaster := $(patsubst %.csv,%-Master.md,$(CSV))

MD := $(wildcard */*.md)
# LaTeX workflow
MD2TeX := $(patsubst %.md,%.tex,$(MD))

filterPath:=submodule/pandoc-amsthm/bin/
headerPath:=submodule/pandoc-amsthm/template/include/
pandocArgCommon := -f markdown+autolink_bare_uris-implicit_figures-fancy_lists --toc --normalize -S -V linkcolorblue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --latex-engine=$(pandocEngine)
# README
pandocArgReadmePDF := $(pandocArgCommon) --toc-depth=6 -s
pandocArgReadmeGitHub := $(pandocArgCommon) --toc-depth=2 -s -t markdown_github
# Workbooks
## LaTeX workflow
latexmkArg := -$(latexmkEngine)
pandocArgFragment := $(pandocArgCommon) --chapters --filter=$(filterPath)pandoc-amsthm.py
## pandoc workflow
pandocArgStandalone := $(pandocArgFragment) --toc-depth=1 -s -N -H $(headerPath)default.tex -H workbook.sty

# building
## LaTeX workflow
LaTeX: $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(latexmkPDF) workbook.tex
7A: $(MD2TeX) $(CSV2TeX7A) workbook-7A.pdf workbook.tex
8A: $(MD2TeX) $(CSV2TeX8A) workbook-8A.pdf workbook.tex
Master: $(MD2TeX) $(CSV2TeXMaster) workbook-Master.pdf workbook.tex
## pandoc workflow
pandoc: $(CSV2MD7A) $(CSV2MD8A) $(CSV2MDMaster) $(pandocPDF) $(pandocTeX)
pandoc7A: $(CSV2MD7A) workbook_7A.pdf workbook_7A.tex
pandoc8A: $(CSV2MD8A) workbook_8A.pdf workbook_8A.tex
pandocMaster: $(CSV2MD7A) workbook_Master.pdf workbook_Master.tex

readme: README.md README.pdf
all: readme LaTeX pandoc

# cleaning generated files
## clean everything
Clean:
	latexmk -C -f $(latexmkTeX) $(pandocTeX)
	rm -f $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(CSV2MD7A) $(CSV2MD8A) $(CSV2MDMaster) $(pandocTeX) $(pandocPDF) workbook.tex README.pdf
## clean everthing but PDF output
clean:
	latexmk -c -f $(latexmkTeX) $(pandocTeX)
	rm -f $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(CSV2MD7A) $(CSV2MD8A) $(CSV2MDMaster) $(pandocTeX) workbook.tex

# update submodule
update:
	git submodule update --recursive --remote

# Automation on */*.md, in the order from draft to finish #############################################################################################################################################

# this touches all md files expected from the CSV. Best for initial creation.
touch:
	listCollection=$$(cut -d, -f 1 workbook.csv | tail -n +2);for eachCollection in $$listCollection; do mkdir -p $$eachCollection; listUnit=$$(cut -d, -f 1 $$eachCollection.csv | tail -n +2 | sed 's=^\(.*\)$$='$$eachCollection'/\1.md=g'); touch $$listUnit; done

# enclose environments: ignore filename containing `-fm` and `lab`, and files containing a div.
enclose:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec bash -c 'if [[ "$$0" != *"-fm"* && "$$0" != *"lab"* ]]; then if ! grep -q "<div class=" "$$0"; then script/enclose-problem-environment.sh "$$0"; fi; fi' {} \;

# Normalize white spaces: 1. Add 2 trailing newlines 2. delete all CONSECUTIVE blank lines from file except the first; deletes all blank lines from top and end of file; allows 0 blanks at top, 0,1,2 at EOF 3. delete trailing whitespace (spaces, tabs) from end of each line 
normalize:
	find . -maxdepth 2 -iname "*.md" -exec bash -c 'printf "\n\n" >> "$$0"' {} \; -exec sed -i -e '/./,/^$$/!d' -e 's/[ \t]*$$//' {} \;

# Greek conversion
greek:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i -e 's/α/\$$\\alpha\$$/g' -e 's/β/\$$\\beta\$$/g' -e 's/ψ/\$$\\psi\$$/g' -e 's/δ/\$$\\delta\$$/g' -e 's/ε/\$$\\epsilon\$$/g' -e 's/φ/\$$\\phi\$$/g' -e 's/γ/\$$\\gamma\$$/g' -e 's/η/\$$\\eta\$$/g' -e 's/ι/\$$\\iota\$$/g' -e 's/ξ/\$$\\xi\$$/g' -e 's/κ/\$$\\kappa\$$/g' -e 's/λ/\$$\\lambda\$$/g' -e 's/μ/\$$\\mu\$$/g' -e 's/ν/\$$\\nu\$$/g' -e 's/π/\$$\\pi\$$/g' -e 's/ρ/\$$\\rho\$$/g' -e 's/σ/\$$\\sigma\$$/g' -e 's/τ/\$$\\tau\$$/g' -e 's/θ/\$$\\theta\$$/g' -e 's/ω/\$$\\omega\$$/g' -e 's/ς/\$$\\varsigma\$$/g' -e 's/χ/\$$\\chi\$$/g' -e 's/υ/\$$\\upsilon\$$/g' -e 's/ζ/\$$\\zeta\$$/g' -e 's/Ψ/\$$\\Psi\$$/g' -e 's/Δ/\$$\\Delta\$$/g' -e 's/Φ/\$$\\Phi\$$/g' -e 's/Γ/\$$\\Gamma\$$/g' -e 's/Ξ/\$$\\Xi\$$/g' -e 's/Λ/\$$\\Lambda\$$/g' -e 's/Π/\$$\\Pi\$$/g' -e 's/Σ/\$$\\Sigma\$$/g' -e 's/Θ/\$$\\Theta\$$/g' -e 's/Ω/\$$\\Omega\$$/g' -e 's/Υ/\$$\\Upsilon\$$/g' {} \;
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i 's/ο/ 0/g' {} \; #probably omicron means 0 in subscript

# use lacheck and chktex to check LaTeX styling problems
lint: $(MD2TeX)
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec chktex -q {} \;
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec lacheck {} \;

# Making dependancies #################################################################################################################################################################################

# README
.INTERMEDIATE: README
README: README-main.md README-guidelines.md README-textbook-toc-7.md README-textbook-toc-8.md
	cat README-main.md > README
	printf "%s\n\n" "# Guidelines from Ben" >> README
	sed s=^#=##=g README-guidelines.md >> README
	printf "%s\n\n" "# Resources" >> README
	sed s=^#=##=g README-textbook-toc-7.md >> README
	sed s=^#=##=g README-textbook-toc-8.md >> README
README.pdf: README
	printf "%s\n" "---" "title:	README" "fontfamily:	lmodern,siunitx,cancel,physics,placeins" "..." "" > README-pdf.md
	cat $< >> README-pdf.md
	pandoc $(pandocArgReadmePDF) -o $@ README-pdf.md
	rm README-pdf.md
README.md: README
	printf "%s\n\n" "<!--This README is auto-generated from \`README-*.md\`. Do not edit this file directly.-->" "[![Build Status](https://travis-ci.com/ucb-physics/workbook-7-8.svg?token=JQDb9LAgeZpmqErJzpBD&branch=master)](https://travis-ci.com/ucb-physics/workbook-7-8)" > $@
	pandoc $(pandocArgReadmeGitHub) $< >> $@

# LaTeX workflow
## $(MD2TeX)
%.tex: %.md workbook.yml $(filterPath)pandoc-amsthm.py
	cat workbook.yml $< | pandoc $(pandocArgFragment) -o $@
## workbook.tex
workbook.tex: workbook.yml $(headerPath)default.tex workbook.sty
	pandoc $(pandocArgStandalone) -t latex $< | sed 's/\\end{document}//' > $@
## $(CSV2TeX*)
### workbook-*.tex
workbook-7A.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics 7A}" > $@
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{\1-7A.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
workbook-8A.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics 8A}" > $@
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{\1-8A.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
workbook-Master.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics Master}" > $@
	cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=\\input{\1-Master.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
### <collection>-*.tex (i.e. excluding workbook-*.tex)
%-7A.tex: %.csv
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{$(patsubst %.csv,%,$<)/\1.tex}=g' > $@
%-8A.tex: %.csv
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{$(patsubst %.csv,%,$<)/\1.tex}=g' > $@
%-Master.tex: %.csv
	cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=\\input{$(patsubst %.csv,%,$<)/\1.tex}=g' > $@
# pandoc workflow
## $(CSV2MD*)
### workbook-*.md
workbook-7A.md: workbook.csv workbook.yml $(CSV2MD7A)
	cat workbook.yml > $@
	listCollection=$$(grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=$$=-7A.md=g'); cat $$listCollection >> $@
workbook-8A.md: workbook.csv workbook.yml $(CSV2MD8A)
	cat workbook.yml > $@
	listCollection=$$(grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=$$=-8A.md=g'); cat $$listCollection >> $@
workbook-Master.md: workbook.csv workbook.yml $(CSV2MDMaster)
	cat workbook.yml > $@
	listCollection=$$(cut -d, -f 1 $< | tail -n +2 | sed 's=$$=-Master.md=g'); cat $$listCollection >> $@
### <collection>-*.md (i.e. excluding workbook-*.md). The if-statement is for the case that the <collection> is actually empty
%-7A.md: %.csv $(MD)
	listUnit=$$(grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=$(patsubst %.csv,%,$<)/\1.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-8A.md: %.csv $(MD)
	listUnit=$$(grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=$(patsubst %.csv,%,$<)/\1.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-Master.md: %.csv $(MD)
	listUnit=$$(cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=$(patsubst %.csv,%,$<)/\1.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi

# LaTeX workflow
## TeX to PDF: $(latexmkPDF)
workbook-7A.pdf: $(MD2TeX) $(CSV2TeX7A)
	latexmk $(latexmkArg) $(patsubst %.pdf,%.tex,$@)
workbook-8A.pdf: $(MD2TeX) $(CSV2TeX8A)
	latexmk $(latexmkArg) $(patsubst %.pdf,%.tex,$@)
workbook-Master.pdf: $(MD2TeX) $(CSV2TeXMaster)
	latexmk $(latexmkArg) $(patsubst %.pdf,%.tex,$@)
# pandoc workflow
## md to TeX: $(pandocTeX)
workbook_%.tex: workbook-%.md $(headerPath)default.tex workbook.sty
	pandoc $(pandocArgStandalone) -M title="Physics $(patsubst workbook-%.md,%,$<)" -o $@ $<
## md to PDF: $(pandocPDF)
workbook_%.pdf: workbook_%.tex $(headerPath)default.tex workbook.sty
	latexmk $(latexmkArg) $<
