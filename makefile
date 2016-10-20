SHELL := /bin/bash

# specify LaTeX engine
## LaTeX workflow: pdf; xelatex; lualatex
LaTeXengine := pdf
## pandoc workflow: pdflatex; xelatex; lualatex
pandocEngine := pdflatex

course := Master 7A 8A
# LaTeX workflow
LaTeXtex := $(addsuffix .tex,$(addprefix workbook-, $(course)))
LaTeXpdf := $(addsuffix .pdf,$(addprefix workbook-, $(course)))
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

filterPATH:=submodule/pandoc-amsthm/bin/
headerPATH:=submodule/pandoc-amsthm/template/include/
pandocArcCommon := -f markdown+autolink_bare_uris-implicit_figures-fancy_lists --toc --normalize -S -V linkcolorblue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --latex-engine=$(pandocEngine)
pandocArcREADMEpdf := $(pandocArcCommon) --toc-depth=6
pandocArcREADMEgithub := $(pandocArcCommon) --toc-depth=2 -t markdown_github -N
# LaTeX workflow
LaTeXarc := -$(LaTeXengine)
pandocArcLaTeX := $(pandocArcCommon) --chapters -N --toc-depth=1 --filter=$(filterPATH)pandoc-amsthm.py
# pandoc workflow
pandocArcPandoc := $(pandocArcLaTeX) -H $(headerPATH)default.tex -H workbook.sty

# building
## LaTeX workflow
LaTeX: $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(LaTeXpdf) workbook.tex
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
	latexmk -C -f $(LaTeXtex) $(pandocTeX)
	rm -f $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(CSV2MD7A) $(CSV2MD8A) $(CSV2MDMaster) $(pandocTeX) $(pandocPDF) workbook.tex README.pdf
## clean everthing but PDF output
clean:
	latexmk -c -f $(LaTeXtex) $(pandocTeX)
	rm -f $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(CSV2MD7A) $(CSV2MD8A) $(CSV2MDMaster) $(pandocTeX) workbook.tex

# update submodule
update:
	git submodule update --recursive --remote

# Automation on */*.md, in the order from draft to finish #############################################################################################################################################

# this touches all md files expected from the CSV. Best for initial creation.
touch:
	listCollection=$$(cut -d, -f 1 workbook.csv | tail -n +2);for eachCollection in $$listCollection; do mkdir -p $$eachCollection; listUnit=$$(cut -d, -f 1 $$eachCollection.csv | tail -n +2 | sed -e 's=^='$$eachCollection'/=g' -e 's=$$=.md=g'); touch $$listUnit; done

# enclose environments: ignore filename containing `-fm` and `lab`, and files containing a div.
enclose:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec bash -c 'if [[ "{}" != *"-fm"* && "{}" != *"lab"* ]]; then if ! grep -q "<div class=" "{}"; then script/enclose-problem-environment.sh "{}"; fi; fi' \;

# Normalize white spaces: 1. Add 2 trailing newlines 2. delete all CONSECUTIVE blank lines from file except the first; deletes all blank lines from top and end of file; allows 0 blanks at top, 0,1,2 at EOF 3. delete trailing whitespace (spaces, tabs) from end of each line 
normalize:
	find . -maxdepth 2 -iname "*.md" -exec bash -c 'printf "\n\n" >> '{}'' \; -exec sed -i -e '/./,/^$$/!d' -e 's/[ \t]*$$//' '{}' \;

# Greek conversion
greek:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i -e 's/α/\$$\\alpha\$$/g' -e 's/β/\$$\\beta\$$/g' -e 's/ψ/\$$\\psi\$$/g' -e 's/δ/\$$\\delta\$$/g' -e 's/ε/\$$\\epsilon\$$/g' -e 's/φ/\$$\\phi\$$/g' -e 's/γ/\$$\\gamma\$$/g' -e 's/η/\$$\\eta\$$/g' -e 's/ι/\$$\\iota\$$/g' -e 's/ξ/\$$\\xi\$$/g' -e 's/κ/\$$\\kappa\$$/g' -e 's/λ/\$$\\lambda\$$/g' -e 's/μ/\$$\\mu\$$/g' -e 's/ν/\$$\\nu\$$/g' -e 's/π/\$$\\pi\$$/g' -e 's/ρ/\$$\\rho\$$/g' -e 's/σ/\$$\\sigma\$$/g' -e 's/τ/\$$\\tau\$$/g' -e 's/θ/\$$\\theta\$$/g' -e 's/ω/\$$\\omega\$$/g' -e 's/ς/\$$\\varsigma\$$/g' -e 's/χ/\$$\\chi\$$/g' -e 's/υ/\$$\\upsilon\$$/g' -e 's/ζ/\$$\\zeta\$$/g' -e 's/Ψ/\$$\\Psi\$$/g' -e 's/Δ/\$$\\Delta\$$/g' -e 's/Φ/\$$\\Phi\$$/g' -e 's/Γ/\$$\\Gamma\$$/g' -e 's/Ξ/\$$\\Xi\$$/g' -e 's/Λ/\$$\\Lambda\$$/g' -e 's/Π/\$$\\Pi\$$/g' -e 's/Σ/\$$\\Sigma\$$/g' -e 's/Θ/\$$\\Theta\$$/g' -e 's/Ω/\$$\\Omega\$$/g' -e 's/Υ/\$$\\Upsilon\$$/g' '{}' \;
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i 's/ο/ 0/g' '{}' \; #probably omicron means 0 in subscript

# use lacheck and chktex to check LaTeX styling problems
lint: $(MD2TeX)
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec chktex -q '{}' \;
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec lacheck '{}' \;

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
	pandoc $(pandocArcREADMEpdf) -s -o $@ README-pdf.md
	rm README-pdf.md
README.md: README
	printf "%s\n\n" "<!--This README is auto-generated from \`README-*.md\`. Do not edit this file directly.-->" "[![Build Status](https://travis-ci.com/ucb-physics/workbook-7-8.svg?token=JQDb9LAgeZpmqErJzpBD&branch=master)](https://travis-ci.com/ucb-physics/workbook-7-8)" > $@
	pandoc $(pandocArcREADMEgithub) -s $< >> $@

# LaTeX workflow
## $(MD2TeX)
%.tex: %.md workbook.yml $(filterPATH)pandoc-amsthm.py
	cat workbook.yml $< | pandoc $(pandocArcLaTeX) -o $@
## workbook.tex
workbook.tex: workbook.yml $(headerPATH)default.tex workbook.sty
	pandoc $(pandocArcPandoc) -t latex -s $< | sed 's/\\end{document}//' > $@
## $(CSV2TeX*)
### workbook-*.tex
workbook-7A.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics 7A}" > $@
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=^=\\input{=g' -e 's=$$=-7A.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
workbook-8A.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics 8A}" > $@
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=^=\\input{=g' -e 's=$$=-8A.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
workbook-Master.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics Master}" > $@
	cut -d, -f 1 $< | tail -n +2 | sed -e 's=^=\\input{=g' -e 's=$$=-Master.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
### <collection>-*.tex (i.e. excluding workbook-*.tex)
%-7A.tex: %.csv
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=^=\\input{$(patsubst %.csv,%,$<)/=g' -e 's=$$=.tex}=g' > $@
%-8A.tex: %.csv
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=^=\\input{$(patsubst %.csv,%,$<)/=g' -e 's=$$=.tex}=g' > $@
%-Master.tex: %.csv
	cut -d, -f 1 $< | tail -n +2 | sed -e 's=^=\\input{$(patsubst %.csv,%,$<)/=g' -e 's=$$=.tex}=g' > $@
# pandoc workflow
## $(CSV2MD*)
### workbook-*.md
workbook-7A.md: workbook.csv workbook.yml $(CSV2MD7A)
	cat workbook.yml > $@
	listCollection=$$(grep 7A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=$$=-7A.md=g'); cat $$listCollection >> $@
workbook-8A.md: workbook.csv workbook.yml $(CSV2MD8A)
	cat workbook.yml > $@
	listCollection=$$(grep 8A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=$$=-8A.md=g'); cat $$listCollection >> $@
workbook-Master.md: workbook.csv workbook.yml $(CSV2MDMaster)
	cat workbook.yml > $@
	listCollection=$$(cut -d, -f 1 $< | tail -n +2 | sed -e 's=$$=-Master.md=g'); cat $$listCollection >> $@
### <collection>-*.md (i.e. excluding workbook-*.md). The if-statement is for the case that the <collection> is actually empty
%-7A.md: %.csv $(MD)
	listUnit=$$(grep 7A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=^=$(patsubst %.csv,%,$<)/=g' -e 's=$$=.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-8A.md: %.csv $(MD)
	listUnit=$$(grep 8A $< | cut -d, -f 1 | tail -n +2 | sed -e 's=^=$(patsubst %.csv,%,$<)/=g' -e 's=$$=.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-Master.md: %.csv $(MD)
	listUnit=$$(cut -d, -f 1 $< | tail -n +2 | sed -e 's=^=$(patsubst %.csv,%,$<)/=g' -e 's=$$=.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi

# LaTeX workflow
## TeX to PDF: $(LaTeXpdf)
workbook-%.pdf: $(MD2TeX) $(CSV2TeX%)
	latexmk $(LaTeXarc) $(patsubst %.pdf,%.tex,$@)
# pandoc workflow
## md to TeX: $(pandocTeX)
workbook_%.tex: workbook-%.md $(headerPATH)default.tex workbook.sty
	pandoc $(pandocArcPandoc) -M title="Physics $(patsubst workbook-%.md,%,$<)" -s -o $@ $<
## md to PDF: $(pandocPDF)
workbook_%.pdf: workbook_%.tex $(headerPATH)default.tex workbook.sty
	latexmk $(LaTeXarc) $<
