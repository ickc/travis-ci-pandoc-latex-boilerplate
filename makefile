SHELL := /bin/bash

# specify LaTeX engine
## LaTeX workflow: pdf; xelatex; lualatex
latexmkEngine := pdf
## pandoc workflow: pdflatex; xelatex; lualatex
pandocEngine := pdflatex

course := Master 7A 8A
# LaTeX workflow
latexmkTeX := $(addsuffix .tex,$(addprefix workbook_, $(course)))
latexmkPDF := $(addsuffix .pdf,$(addprefix workbook_, $(course)))
# pandoc workflow
pandocTeX := $(addsuffix .tex,$(addprefix workbook-, $(course)))
pandocPDF := $(addsuffix .pdf,$(addprefix workbook-, $(course)))
pandocHTML := $(addsuffix .html,$(addprefix workbook-, $(course)))

CSV := $(wildcard *.csv)
# LaTeX workflow
CSV2TeX7A := $(patsubst %.csv,%_7A.tex,$(CSV))
CSV2TeX8A := $(patsubst %.csv,%_8A.tex,$(CSV))
CSV2TeXMaster := $(patsubst %.csv,%_Master.tex,$(CSV))
# pandoc workflow
CSV2MD7A := $(patsubst %.csv,%-7A.md,$(CSV))
CSV2MD8A := $(patsubst %.csv,%-8A.md,$(CSV))
CSV2MDMaster := $(patsubst %.csv,%-Master.md,$(CSV))

MD := $(wildcard */*.md)
# LaTeX workflow
MD2TeX := $(patsubst %.md,%.tex,$(MD))

filterPath:=submodule/pandoc-amsthm/bin/
headerPath:=submodule/pandoc-amsthm/template/include/
pandocArgCommon := -f markdown+autolink_bare_uris-fancy_lists --toc --normalize -S -V linkcolorblue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --latex-engine=$(pandocEngine) -M date="`date "+%B %e, %Y"`"
# README
pandocArgReadmePDF := $(pandocArgCommon) --toc-depth=6 -s
pandocArgReadmeGitHub := $(pandocArgCommon) --toc-depth=2 -s -t markdown_github --reference-location=block
# Workbooks
## LaTeX workflow
latexmkArg := -$(latexmkEngine)
pandocArgFragment := $(pandocArgCommon) --top-level-division=part --filter=$(filterPath)pandoc-amsthm.py
## pandoc workflow
pandocArgStandalone := $(pandocArgFragment) --toc-depth=1 -s -N -H $(headerPath)default.tex -H workbook.sty
## HTML
pandocArgHTML := $(pandocArgFragment) --toc-depth=2 -s -N -H $(headerPath)default.html -H submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html --mathjax -c https://ickc.github.io/markdown-latex-css/css/common.css -c https://ickc.github.io/markdown-latex-css/fonts/fonts.css

preamble := workbook.yml workbook.sty $(headerPath)default.tex

# building
## LaTeX workflow
latexmk: $(latexmkPDF)
7a: workbook_7A.pdf
8a: workbook_8A.pdf
master: workbook_Master.pdf
## pandoc workflow
pandoc: $(pandocPDF) $(pandocTeX)
7A: workbook-7A.pdf workbook-7A.tex
8A: workbook-8A.pdf workbook-8A.tex
Master: workbook-Master.pdf workbook-Master.tex
html: $(pandocHTML)
## commonly used
travis: latexmk $(pandocPDF)
readme: README.md
all: readme latexmk pandoc

# cleaning generated files
## clean everything
Clean:
	latexmk -C -f $(latexmkTeX) $(pandocTeX)
	rm -f $(MD2TeX) $(CSV2TeX7A) $(CSV2TeX8A) $(CSV2TeXMaster) $(CSV2MD7A) $(CSV2MD8A) $(CSV2MDMaster) $(pandocTeX) workbook.tex
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

# remove span and bold
unspan:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i 's/<span>\([*]\+\)\([^*]\+\)\([*]\+\)<\/span>/\1\2\3/g' {} \;

# enclose environments: ignore filename containing `-fm` and `lab`, and files containing a div.
enclose:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec bash -c 'if [[ "$$0" != *"-fm"* && "$$0" != *"lab"* ]]; then if ! grep -q "<div class=" "$$0"; then script/enclose-problem-environment.sh "$$0"; fi; fi' {} \;

# Normalize white spaces:
## 1. Add 2 trailing newlines
## 2. transform non-breaking space into (explicit) space
## 3. temporarily transform traling `\ ` into non-breaking space
## 4. delete all CONSECUTIVE blank lines from file except the first; deletes all blank lines from top and end of file; allows 0 blanks at top, 0,1,2 at EOF
## 5. delete trailing whitespace (spaces, tabs) from end of each line
## 6. transform temporary non-breaking space into `\ ` in (3)
normalize:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec bash -c 'printf "\n\n" >> "$$0"; sed -i -e "s/ / /g" -e '"'"'s/\\ $$/ /g'"'"' -e '"'"'/./,/^$$/!d'"'"' -e '"'"'s/[ \t]*$$//'"'"' -e '"'"'s/ /\\ /g'"'"' $$0' {} \;

nonbreaking:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i -e 's/e\.g\. /e\.g\.\\ /g' -e 's/i\.e\. /i\.e\.\\ /g' {} \;

# detect unicode
## non-ASCII (tolerate è, ö, etc.)
detect:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec grep --color='auto' -P -H -n "[^™[:ascii:]]" {} \;
## UTF-8
detectStrict:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec grep --color='auto' -P -H -n "[^\x00-\x7F]" {} \;
## raw HTML/LaTeX
detectRAW:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec pandoc $(pandocArgFragment) -t native workbook.yml {} -o {}.native \;
	find . -maxdepth 2 -mindepth 2 -iname "*.md.native" -exec grep --color='auto' -H -n "RawInline" {} \;
	find . -maxdepth 2 -mindepth 2 -iname "*.md.native" -exec rm {} \;	
	# find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec bash -c 'pandoc $(pandocArgFragment) -t native workbook.yml $$0 | if grep -q "RawInline" -; then printf "%s\n" "$$0"; fi' {} \;

# convert unicode to LaTeX Math
convert:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec script/unicode-to-math.sh {} \;

# use lacheck and chktex to check LaTeX styling problems
lint: $(MD2TeX)
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec chktex -q {} \;
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec lacheck {} \;

# pandoc cleanup:
## 1. pandoc from markdown to markdown
## 2. `{.unnumbered}` to `{-}`
## 3. transform unicode non-breaking space back to `\ `
## 4. transform unicode trademark back to HTML trademark
style:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec bash -c 'pandoc -f markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash-latex_macros-auto_identifiers -t markdown+raw_tex-native_spans-simple_tables-multiline_tables-grid_tables-latex_macros --normalize -s --wrap=none --column=999 --atx-headers --reference-location=block -o $$0 $$0; sed -i -e '"'"'s/ /\\ /g'"'"' $$0' {} \;

# Making dependancies #################################################################################################################################################################################

# README
README.md: README-Master.md
	printf "%s\n\n" "<!--This README is auto-generated from \`README/*.md\`. Do not edit this file directly.-->" "[![Build Status](https://travis-ci.com/ucb-physics/workbook-7-8.svg?token=JQDb9LAgeZpmqErJzpBD&branch=master)](https://travis-ci.com/ucb-physics/workbook-7-8)" > $@
	pandoc $(pandocArgReadmeGitHub) $< >> $@

# LaTeX workflow
## $(MD2TeX)
%.tex: %.md workbook.yml $(filterPath)pandoc-amsthm.py
	pandoc $(pandocArgFragment) -o $@ workbook.yml $<
## workbook.tex
workbook.tex: $(preamble)
	pandoc $(pandocArgStandalone) -t latex $< | sed 's/\\end{document}//' > $@
## $(CSV2TeX*)
### workbook_*.tex
workbook_7A.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics 7A}" > $@
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{\1_7A.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
workbook_8A.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics 8A}" > $@
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{\1_8A.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
workbook_Master.tex: workbook.csv workbook.tex
	printf "%s\n" "\title{Physics Master}" > $@
	cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=\\input{\1_Master.tex}=g' | cat workbook.tex - >> $@
	printf "%s\n" "\end{document}" >> $@
### <collection>-*.tex (i.e. excluding workbook_*.tex)
%_7A.tex: %.csv
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{$(patsubst %.csv,%,$<)/\1.tex}=g' > $@
%_8A.tex: %.csv
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=\\input{$(patsubst %.csv,%,$<)/\1.tex}=g' > $@
%_Master.tex: %.csv
	cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=\\input{$(patsubst %.csv,%,$<)/\1.tex}=g' > $@
# pandoc workflow
## $(CSV2MD*)
### workbook-*.md
workbook-7A.md: workbook.csv $(CSV2MD7A)
	listCollection=$$(grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=$$=-7A.md=g'); cat $$listCollection > $@
workbook-8A.md: workbook.csv $(CSV2MD8A)
	listCollection=$$(grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=$$=-8A.md=g'); cat $$listCollection > $@
workbook-Master.md: workbook.csv $(CSV2MDMaster)
	listCollection=$$(cut -d, -f 1 $< | tail -n +2 | sed 's=$$=-Master.md=g'); cat $$listCollection > $@
### <collection>-*.md (i.e. excluding workbook-*.md). The if-statement is for the case that the <collection> is actually empty
%-7A.md: %.csv $(MD)
	listUnit=$$(grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=$(patsubst %.csv,%,$<)/\1.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-8A.md: %.csv $(MD)
	listUnit=$$(grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=$(patsubst %.csv,%,$<)/\1.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi
%-Master.md: %.csv $(MD)
	listUnit=$$(cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=$(patsubst %.csv,%,$<)/\1.md=g'); if [ -n "$$listUnit" ]; then cat $$listUnit > $@; fi

# LaTeX workflow
## TeX to PDF: $(latexmkPDF)
workbook_7A.pdf: $(MD2TeX) $(CSV2TeX7A)
	latexmk $(latexmkArg) $(patsubst %.pdf,%.tex,$@)
workbook_8A.pdf: $(MD2TeX) $(CSV2TeX8A)
	latexmk $(latexmkArg) $(patsubst %.pdf,%.tex,$@)
workbook_Master.pdf: $(MD2TeX) $(CSV2TeXMaster)
	latexmk $(latexmkArg) $(patsubst %.pdf,%.tex,$@)
# pandoc workflow
## md to TeX: $(pandocTeX)
workbook-%.tex: workbook-%.md $(preamble)
	pandoc $(pandocArgStandalone) -M title="Physics $(patsubst workbook-%.md,%,$<)" -o $@ workbook.yml $<
## md to PDF: $(pandocPDF). This rule can also be used to make <collection>-<course>.pdf. e.g. make 2d-kinematics-Master.pdf
%.pdf: %.md $(preamble)
	pandoc $(pandocArgStandalone) -M title="Physics $(patsubst workbook-%.md,%,$<)" -o $@ workbook.yml $<
%.html: %.md $(preamble)
	pandoc $(pandocArgHTML) -M title="Physics $(patsubst workbook-%.md,%,$<)" -o $@ workbook.yml $<