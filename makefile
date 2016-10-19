SHELL := /bin/bash

# specify LaTeX engine
## LaTeX workflow: pdf; xelatex; lualatex
LaTeXengine := pdf
## pandoc workflow: pdflatex; xelatex; lualatex
pandocEngine := pdflatex

course := master 7a 8a
# LaTeX workflow
LaTeXtex := $(addsuffix .tex,$(addprefix workbook-, $(course)))
LaTeXpdf := $(addsuffix .pdf,$(addprefix workbook-, $(course)))
# pandoc workflow
pandocTeX := $(addsuffix .tex,$(addprefix workbook_, $(course)))
pandocPDF := $(addsuffix .pdf,$(addprefix workbook_, $(course)))

CSV := $(wildcard *.csv)
# LaTeX workflow
CSV2TeX7a := $(patsubst %.csv,%-7a.tex,$(CSV))
CSV2TeX8a := $(patsubst %.csv,%-8a.tex,$(CSV))
CSV2TeXmaster := $(patsubst %.csv,%-master.tex,$(CSV))
# pandoc workflow
CSV2MD7a := $(patsubst %.csv,%-7a.md,$(CSV))
CSV2MD8a := $(patsubst %.csv,%-8a.md,$(CSV))
CSV2MDmaster := $(patsubst %.csv,%-master.md,$(CSV))

MD := $(wildcard */*.md)
# LaTeX workflow
MD2TeX := $(patsubst %.md,%.tex,$(MD))

filterPATH:=submodule/pandoc-amsthm/bin/
headerPATH:=submodule/pandoc-amsthm/template/include/
pandocArcCommon := -f markdown+autolink_bare_uris-implicit_figures-fancy_lists --toc --normalize -V linkcolorblue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --latex-engine=$(pandocEngine)
pandocArcREADME := $(pandocArcCommon) --toc-depth=6
# LaTeX workflow
LaTeXarc := -$(LaTeXengine)
pandocArcLaTeX := $(pandocArcCommon) --chapters -N --toc-depth=1 --filter=$(filterPATH)pandoc-amsthm.py
# pandoc workflow
pandocArcPandoc := $(pandocArcLaTeX) -H $(headerPATH)default.tex -H workbook.sty

# building
## LaTeX workflow
LaTeX: $(MD2TeX) $(CSV2TeX7a) $(CSV2TeX8a) $(CSV2TeXmaster) $(LaTeXpdf) README.md workbook.tex # README.pdf
7a: $(MD2TeX) $(CSV2TeX7a) workbook-7a.pdf workbook.tex
8a: $(MD2TeX) $(CSV2TeX8a) workbook-8a.pdf workbook.tex
master: $(MD2TeX) $(CSV2TeXmaster) workbook-master.pdf workbook.tex
## pandoc workflow
pandoc: $(CSV2MD7a) $(CSV2MD8a) $(CSV2MDmaster) $(pandocTeX) $(pandocPDF) README.md # README.pdf
pandoc7a: $(CSV2MD7a) workbook_7a.tex workbook_7a.pdf
pandoc8a: $(CSV2MD8a) workbook_8a.tex workbook_8a.pdf
pandocMaster: $(CSV2MD7a) workbook_master.tex workbook_master.pdf

readme: README.md # README.pdf

# cleaning generated files
## clean everything
Clean:
	latexmk -C -f $(LaTeXtex)
	rm -f $(MD2TeX) $(CSV2TeX7a) $(CSV2TeX8a) $(CSV2TeXmaster) $(CSV2MD7a) $(CSV2MD8a) $(CSV2MDmaster) $(pandocTeX) $(pandocPDF) workbook.tex README.pdf
## clean everthing but PDF output
clean:
	latexmk -c -f $(LaTeXtex)
	rm -f $(MD2TeX) $(CSV2TeX7a) $(CSV2TeX8a) $(CSV2TeXmaster) $(CSV2MD7a) $(CSV2MD8a) $(CSV2MDmaster) $(pandocTeX) workbook.tex

# update submodule
update:
	git submodule update --recursive --remote

# Automation on */*.md, in the order from draft to finish #############################################################################################################################################

# this touches all md files expected from the CSV. Best for initial creation.
touch:
	listCollection=$$(cut -d, -f 6 workbook.csv | tail -n +2);for eachCollection in $$listCollection; do mkdir -p $$eachCollection; listUnit=$$(cut -d, -f 6 $$eachCollection.csv | tail -n +2 | sed -e 's=^='$$eachCollection'/=g' -e 's=$$=.md=g'); touch $$listUnit; done

# enclose environments: ignore filename containing `-fm` and `lab`, and files containing a div.
enclose:
	find */*.md -exec bash -c 'if [[ "{}" != *"-fm"* && "{}" != *"lab"* ]]; then if ! grep -q "<div class=" "{}"; then script/enclose-problem-environment.sh "{}"; fi; fi' \;

# Normalize white spaces
normalize:
	find */*.md -exec sed -i 's/[ \t]*$$//' '{}' \; # delete trailing whitespace (spaces, tabs) from end of each line
	find */*.md -exec sed -i '/./,/^$$/!d' '{}' \; # delete all CONSECUTIVE blank lines from file except the first; deletes all blank lines from top and end of file; allows 0 blanks at top, 1 at EOF
	find */*.md -exec sed -i '1i\'$$'\n' '{}' \; # add leading new line
	find ./*.md -exec sed -i 's/[ \t]*$$//' '{}' \; # delete trailing whitespace (spaces, tabs) from end of each line
	find ./*.md -exec sed -i '/./,/^$$/!d' '{}' \; # delete all CONSECUTIVE blank lines from file except the first; deletes all blank lines from top and end of file; allows 0 blanks at top, 1 at EOF
	find ./*.md -exec sed -i '1i\'$$'\n' '{}' \; # add leading new line

# Greek conversion
greek:
	find */*.md -exec sed -i -e 's/α/\$$\\alpha\$$/g' -e 's/β/\$$\\beta\$$/g' -e 's/ψ/\$$\\psi\$$/g' -e 's/δ/\$$\\delta\$$/g' -e 's/ε/\$$\\epsilon\$$/g' -e 's/φ/\$$\\phi\$$/g' -e 's/γ/\$$\\gamma\$$/g' -e 's/η/\$$\\eta\$$/g' -e 's/ι/\$$\\iota\$$/g' -e 's/ξ/\$$\\xi\$$/g' -e 's/κ/\$$\\kappa\$$/g' -e 's/λ/\$$\\lambda\$$/g' -e 's/μ/\$$\\mu\$$/g' -e 's/ν/\$$\\nu\$$/g' -e 's/π/\$$\\pi\$$/g' -e 's/ρ/\$$\\rho\$$/g' -e 's/σ/\$$\\sigma\$$/g' -e 's/τ/\$$\\tau\$$/g' -e 's/θ/\$$\\theta\$$/g' -e 's/ω/\$$\\omega\$$/g' -e 's/ς/\$$\\varsigma\$$/g' -e 's/χ/\$$\\chi\$$/g' -e 's/υ/\$$\\upsilon\$$/g' -e 's/ζ/\$$\\zeta\$$/g' -e 's/Ψ/\$$\\Psi\$$/g' -e 's/Δ/\$$\\Delta\$$/g' -e 's/Φ/\$$\\Phi\$$/g' -e 's/Γ/\$$\\Gamma\$$/g' -e 's/Ξ/\$$\\Xi\$$/g' -e 's/Λ/\$$\\Lambda\$$/g' -e 's/Π/\$$\\Pi\$$/g' -e 's/Σ/\$$\\Sigma\$$/g' -e 's/Θ/\$$\\Theta\$$/g' -e 's/Ω/\$$\\Omega\$$/g' -e 's/Υ/\$$\\Upsilon\$$/g' '{}' \;
	find */*.md -exec sed -i 's/ο/ 0/g' '{}' \; #probably omicron means 0 in subscript

# use lacheck and chktex to check LaTeX styling problems
lint: $(MD2TeX)
	find */ -iname '*.tex' -exec chktex -q '{}' \;
	find */ -iname '*.tex' -exec lacheck '{}' \;

# Making dependancies #################################################################################################################################################################################

# README
README.md: README-organization.md README-guidelines.md README-contributing.md README-textbook-toc-7.md README-textbook-toc-8.md
	echo "---" > README.md
	printf "title:	Readme\nfontfamily:	lmodern,siunitx,cancel,physics,placeins\n...\n\n<!--This README is auto-generated from \`README-*.md\`. Do not edit this file directly.-->\n\n" >> README.md
	printf "\n# Organization\n" >> README.md
	sed s=^#=##=g README-organization.md >> README.md
	printf "\n# Guidelines from Ben\n" >> README.md
	sed s=^#=##=g README-guidelines.md >> README.md
	printf "\n# Contributing\n" >> README.md
	sed s=^#=##=g README-contributing.md >> README.md
	printf "\n# Resources\n" >> README.md
	sed s=^#=##=g README-textbook-toc-7.md >> README.md
	sed s=^#=##=g README-textbook-toc-8.md >> README.md
README.pdf: README.md
	pandoc $(pandocArcREADME) -s -o $@ $<

# LaTeX workflow
## $(MD2TeX)
%.tex: %.md workbook.yml
	cat workbook.yml $< | pandoc $(pandocArcLaTeX) -o $@
## workbook.tex
workbook.tex: workbook.yml
	pandoc $(pandocArcPandoc) -t latex -s $< | sed 's/\\end{document}//' > $@
## $(CSV2TeX*)
### workbook-*.tex
workbook-7a.tex: workbook.csv workbook.tex
	printf '%s\n' "\title{Physics 7A}" > $@
	grep 7a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=^=\\input{=g' -e 's=$$=-7a.tex}=g' | cat workbook.tex - >> $@
	echo "\end{document}" >> $@
workbook-8a.tex: workbook.csv workbook.tex
	printf '%s\n' "\title{Physics 8A}" > $@
	grep 8a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=^=\\input{=g' -e 's=$$=-8a.tex}=g' | cat workbook.tex - >> $@
	echo "\end{document}" >> $@
workbook-master.tex: workbook.csv workbook.tex
	printf '%s\n' "\title{Physics Master}" > $@
	cut -d, -f 6 $< | tail -n +2 | sed -e 's=^=\\input{=g' -e 's=$$=-master.tex}=g' | cat workbook.tex - >> $@
	echo "\end{document}" >> $@
### <collection>-*.tex (i.e. excluding workbook-*.tex)
%-7a.tex: %.csv
	grep 7a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=^=\\input{$(patsubst %.csv,%,$<)/=g' -e 's=$$=.tex}=g' > $@
%-8a.tex: %.csv
	grep 8a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=^=\\input{$(patsubst %.csv,%,$<)/=g' -e 's=$$=.tex}=g' > $@
%-master.tex: %.csv
	cut -d, -f 6 $< | tail -n +2 | sed -e 's=^=\\input{$(patsubst %.csv,%,$<)/=g' -e 's=$$=.tex}=g' > $@
# pandoc workflow
## $(CSV2MD*)
### workbook-*.md
workbook-7a.md: workbook.csv workbook.yml $(CSV2MD7a)
	cat workbook.yml > $@
	listCollection=$$(grep 7a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=$$=-7a.md=g'); cat $$listCollection >> $@
workbook-8a.md: workbook.csv workbook.yml $(CSV2MD8a)
	cat workbook.yml > $@
	listCollection=$$(grep 8a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=$$=-8a.md=g'); cat $$listCollection >> $@
workbook-master.md: workbook.csv workbook.yml $(CSV2MDmaster)
	cat workbook.yml > $@
	listCollection=$$(cut -d, -f 6 $< | tail -n +2 | sed -e 's=$$=-master.md=g'); cat $$listCollection >> $@
### <collection>-*.md (i.e. excluding workbook-*.md). The if-statement is for the case that the <collection> is actually empty
%-7a.md: %.csv $(MD)
	listUnit=$$(grep 7a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=^=$(patsubst %.csv,%,$<)/=g' -e 's=$$=.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-8a.md: %.csv $(MD)
	listUnit=$$(grep 8a $< | cut -d, -f 6 | tail -n +2 | sed -e 's=^=$(patsubst %.csv,%,$<)/=g' -e 's=$$=.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-master.md: %.csv $(MD)
	listUnit=$$(cut -d, -f 6 $< | tail -n +2 | sed -e 's=^=$(patsubst %.csv,%,$<)/=g' -e 's=$$=.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi

# LaTeX workflow
## TeX to PDF: $(LaTeXpdf)
workbook-%.pdf: $(MD2TeX) $(CSV2TeX%)
	latexmk $(LaTeXarc) $(patsubst %.pdf,%.tex,$@)
# pandoc workflow
## md to TeX: $(pandocTeX)
workbook_%.tex: workbook-%.md
	pandoc $(pandocArcPandoc) -M title="Physics $(patsubst workbook-%.md,%,$<)" -s -o $@ $<
## md to PDF: $(pandocPDF)
workbook_%.pdf: workbook-%.md
	pandoc $(pandocArcPandoc) -s -o $@ $<
