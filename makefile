SHELL := /bin/bash

# configure engine
## specify LaTeX engine
### LaTeX workflow: pdf; xelatex; lualatex
latexmkEngine := pdf
### pandoc workflow: pdflatex; xelatex; lualatex
pandocEngine := pdflatex
## HTML
HTMLVersion := html5
## ePub
ePubVersion := epub

course := Master 7A 8A
# LaTeX workflow
latexmkTeX := $(addsuffix .tex,$(addprefix workbook_, $(course)))
latexmkPDF := $(addsuffix .pdf,$(addprefix workbook_, $(course)))
# pandoc workflow
pandocMD := $(addsuffix .md,$(addprefix workbook-, $(course)))
pandocHTML := $(addsuffix .html,$(addprefix workbook-, $(course)))
pandocePub := $(addsuffix .epub,$(addprefix workbook-, $(course)))
pandocePubUnzip := $(addsuffix /,$(addprefix workbook-, $(course)))
pandocTeX := $(addsuffix .tex,$(addprefix workbook-, $(course)))
pandocPDF := $(addsuffix .pdf,$(addprefix workbook-, $(course)))

CSV := $(wildcard *.csv)
CSV2List7A := $(patsubst %.csv,%-7A.list,$(CSV))
CSV2List8A := $(patsubst %.csv,%-8A.list,$(CSV))
CSV2ListMaster := $(patsubst %.csv,%-Master.list,$(CSV))

MD := $(wildcard */*.md)
# LaTeX workflow
MD2TeX := $(patsubst %.md,%.tex,$(MD))
# pandoc AST: for debug
MD2Native := $(patsubst %.md,%.native,$(MD))

filterPath:=submodule/pandoc-amsthm/bin
headerPath:=submodule/pandoc-amsthm/template/include
mathjaxPath:=submodule/markdown-latex-css/js/mathjax
CSSURL:=https://ickc.github.io/markdown-latex-css
pandocArgCommon := -f markdown+autolink_bare_uris-fancy_lists --toc --normalize -S -V linkcolorblue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --latex-engine=$(pandocEngine) -M date="`date "+%B %e, %Y"`"
# README
pandocArgReadmePDF := $(pandocArgCommon) --toc-depth=6 -s
pandocArgReadmeGitHub := $(pandocArgCommon) --toc-depth=2 -s -t markdown_github --reference-location=block
# Workbooks
## LaTeX workflow
latexmkArg := -$(latexmkEngine)
pandocArgFragment := $(pandocArgCommon) --top-level-division=part --filter=$(filterPath)/pandoc-amsthm.py
## pandoc workflow
pandocArgStandalone := $(pandocArgFragment) --toc-depth=1 -s -N -H $(headerPath)/default.tex -H workbook.sty
## HTML
pandocArgHTML := $(pandocArgFragment) -t $(HTMLVersion) --toc-depth=2 -s -N -H $(headerPath)/default.html -H $(mathjaxPath)/setup-mathjax-cdn.html --mathjax -c $(CSSURL)/css/common.css -c $(CSSURL)/fonts/fonts.css
pandocArgePub := $(pandocArgHTML) -t $(ePubVersion) -H $(mathjaxPath)/load-mathjax-cdn.html --epub-chapter-level=2
## MD
pandocArgMD := -f markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash-latex_macros-auto_identifiers -t markdown+raw_tex-native_spans-simple_tables-multiline_tables-grid_tables-latex_macros --normalize -s --wrap=none --column=999 --atx-headers --reference-location=block --file-scope

# A list of dependencies
## make workbook.tex requires workbook.yml to be the first
preamble := workbook.yml workbook.sty $(headerPath)/default.tex $(filterPath)/pandoc-amsthm.py
HTMLHeader := $(headerPath)/default.html $(mathjaxPath)/setup-mathjax-cdn.html $(filterPath)/pandoc-amsthm.py
ePubHeader := $(HTMLHeader) $(mathjaxPath)/load-mathjax-cdn.html

# building
## LaTeX workflow
latexmk: $(latexmkPDF) $(latexmkTeX)
7a: workbook_7A.pdf workbook_7A.tex
8a: workbook_8A.pdf workbook_8A.tex
master: workbook_Master.pdf workbook_Master.tex
## pandoc workflow
pandoc: $(pandocPDF) $(pandocTeX)
7A: workbook-7A.pdf workbook-7A.tex
8A: workbook-8A.pdf workbook-8A.tex
Master: workbook-Master.pdf workbook-Master.tex
md: $(pandocMD)
html: $(pandocHTML)
epub: $(pandocePub) $(pandocePubUnzip)
## commonly used
readme: README.md
travis: $(latexmkPDF) $(pandocPDF) $(pandocePub)
all: readme latexmk pandoc md html epub

# cleaning generated files
## clean everything
Clean:
	latexmk -C -f $(latexmkTeX) $(pandocTeX)
	rm -f $(latexmkTeX) $(pandocMD) $(pandocHTML) $(pandocePub) $(pandocTeX) $(CSV2List7A) $(CSV2List8A) $(CSV2ListMaster) $(MD2TeX) $(MD2Native) workbook.tex
	rm -rf $(pandocePubUnzip)
## clean everthing but PDF output
clean:
	latexmk -c -f $(latexmkTeX) $(pandocTeX)
	rm -f $(latexmkTeX) $(pandocMD) $(pandocHTML) $(pandocePub) $(pandocTeX) $(CSV2List7A) $(CSV2List8A) $(CSV2ListMaster) $(MD2TeX) $(MD2Native) workbook.tex
	rm -rf $(pandocePubUnzip)

# update submodule
update:
	git submodule update --recursive --remote

# Automation on */*.md, in the order from draft to finish #############################################################################################################################################

# Preparation
## this touches all md files expected from the CSV. Best for initial creation.
touch:
	listCollection=$$(cut -d, -f 1 workbook.csv | tail -n +2);for eachCollection in $$listCollection; do mkdir -p $$eachCollection && listUnit=$$(cut -d, -f 1 $$eachCollection.csv | tail -n +2 | sed 's=^\(.*\)$$='$$eachCollection'/\1.md=g') && touch $$listUnit & done
## enclose environments: ignore filename containing `-fm` and `lab`, and files containing a div.
enclose:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" | xargs -i -n1 -P8 bash -c 'if [[ "$$0" != *"-fm"* && "$$0" != *"lab"* && "$$0" != *"README"* ]]; then if ! grep -q "<div class=" "$$0"; then script/enclose-problem-environment.sh "$$0"; fi; fi' {}

# Batch formatting and styling
## remove span and bold
unspan:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i 's/<span>\([*]\+\)\([^*]\+\)\([*]\+\)<\/span>/\1\2\3/g' {} +
## convert unicode to LaTeX Math
convert:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" | xargs -i -n1 -P8 script/unicode-to-math.sh {}
## auto create non-breaking space after shortform
nonbreaking:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec sed -i -e 's/e\.g\. /e\.g\.\\ /g' -e 's/i\.e\. /i\.e\.\\ /g' {} +

# cleanup source code
cleanup: style normalize
## Normalize white spaces:
### 1. Add 2 trailing newlines
### 2. transform non-breaking space into (explicit) space
### 3. temporarily transform markdown non-breaking space `\ ` into unicode
### 4. delete all CONSECUTIVE blank lines from file except the first; deletes all blank lines from top and end of file; allows 0 blanks at top, 0,1,2 at EOF
### 5. delete trailing whitespace (spaces, tabs) from end of each line
### 6. revert (3)
normalize:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" | xargs -i -n1 -P8 bash -c 'printf "\n\n" >> "$$0" && sed -i -e "s/ / /g" -e '"'"'s/\\ / /g'"'"' -e '"'"'/./,/^$$/!d'"'"' -e '"'"'s/[ \t]*$$//'"'"' -e '"'"'s/ /\\ /g'"'"' $$0' {}
## pandoc cleanup:
### 1. pandoc from markdown to markdown
### 2. transform unicode non-breaking space back to `\ `
style:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" | xargs -i -n1 -P8 bash -c 'pandoc $(pandocArgMD) -o $$0 $$0 && sed -i -e '"'"'s/ /\\ /g'"'"' $$0' {}

# detect potential problems (`|| true` is for when grep find nothing and have exit code 1)
## detect unicode
### Non-Printable character: a subset of ASCII. e.g. representated as <NP> in textmate.
detect:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec grep --color='auto' -H -n "[^[:print:]]" {} + || true
### UTF-8
detectStrict:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec grep --color='auto' -P -H -n "[^\x00-\x7F]" {} + || true
## Detect allcaps
detectAllCaps:
	find . -maxdepth 2 -mindepth 2 -iname "*.md" -exec grep --color='auto' -H -n '[^\{`]\<[A-Z][A-Z]\+\>' {} + || true
## raw HTML/LaTeX
detectRAW: $(MD2Native)
	find . -maxdepth 2 -mindepth 2 -iname "*.native" -exec grep --color='auto' -H -n "RawInline" {} + || true
## unparsed math: $
detectDollar: $(MD2TeX)
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec grep --color='auto' -H -n '\$$' {} + || true
## Code/CodeBlock
detectCode: $(MD2TeX)
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" -exec grep --color='auto' -H -n -e '\\texttt{' -e '\\begin{verbatim}' {} + || true
## use lacheck and chktex to check LaTeX styling problems
lint: $(MD2TeX)
	find . -maxdepth 2 -mindepth 2 -iname "*.tex" | xargs -i -n1 -P8 bash -c 'lacheck "$$0"; chktex -q "$$0"' {}

# Making dependancies #################################################################################################################################################################################

# README
README.md: README-Master.list
	printf "%s\n\n" "<!--This README is auto-generated from \`README/*.md\`. Do not edit this file directly.-->" "[![Build Status](https://travis-ci.com/ucb-physics/workbook-7-8.svg?token=JQDb9LAgeZpmqErJzpBD&branch=master)](https://travis-ci.com/ucb-physics/workbook-7-8)" > $@
	< $< xargs pandoc $(pandocArgReadmeGitHub) >> $@

# Preparation: LaTeX workflow
## $(MD2Native): debug
%.native: %.md workbook.yml $(filterPath)/pandoc-amsthm.py
	pandoc $(pandocArgFragment) -t native -o $@ workbook.yml $<
## $(MD2TeX)
%.tex: %.md workbook.yml $(filterPath)/pandoc-amsthm.py
	pandoc $(pandocArgFragment) -o $@ workbook.yml $<
## workbook.tex
workbook.tex: $(preamble)
	pandoc $(pandocArgStandalone) -t latex $< | sed 's/\\end{document}//' > $@
## $(latexmkTeX)
workbook_%.tex: workbook-%.list workbook.csv workbook.tex
	sed 's=^\(.*\)\.md$$=\\input{\1.tex}=g' $< | cat workbook.tex - > $@
	printf "%s\n" "\end{document}" >> $@

# $(CSV2List*)
## workbook-*.list
workbook-7A.list: workbook.csv $(CSV2List7A)
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=$$=-7A.list=g' | xargs cat > $@
workbook-8A.list: workbook.csv $(CSV2List8A)
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=$$=-8A.list=g' | xargs cat > $@
workbook-Master.list: workbook.csv $(CSV2ListMaster)
	cut -d, -f 1 $< | tail -n +2 | sed 's=$$=-Master.list=g' | xargs cat > $@
## <collection>-*.list (i.e. excluding workbook-*.list)
%-7A.list: %.csv $(MD)
	grep 7A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=$*/\1.md=g' > $@
%-8A.list: %.csv $(MD)
	grep 8A $< | cut -d, -f 1 | tail -n +2 | sed 's=^\(.*\)$$=$*/\1.md=g' > $@
%-Master.list: %.csv $(MD)
	cut -d, -f 1 $< | tail -n +2 | sed 's=^\(.*\)$$=$*/\1.md=g' > $@

# Building the final products
## LaTeX workflow
### TeX to PDF: $(latexmkPDF)
workbook_%.pdf: workbook_%.tex $(MD2TeX)
	latexmk $(latexmkArg) $<
## pandoc workflow: These rules can also be used to make <collection>-<course>.*, where * can be md, tex, pdf, html. e.g. make 2d-kinematics-Master.pdf
### list to md: $(pandocMD)
%.md: %.list
	title=$*;title=$${title##*-};< $< xargs pandoc $(pandocArgMD) -M title="Physics $$title" workbook.yml | sed 's/ /\\ /g' > $@
### md to TeX: $(pandocTeX)
workbook-%.tex: workbook-%.md $(preamble)
	pandoc $(pandocArgStandalone) -o $@ workbook.yml $<
### md to PDF: $(pandocPDF)
%.pdf: %.md $(preamble)
	pandoc $(pandocArgStandalone) -o $@ workbook.yml $<
### md to HTML: $(pandocHTML)
%.html: %.md $(HTMLHeader)
	pandoc $(pandocArgHTML) -o $@ workbook.yml $<
### md to ePub: $(pandocePub)
%.epub: %.md $(ePubHeader)
	pandoc $(pandocArgePub) -o $@ workbook.yml $<
# unzip epub $(pandocePubUnzip)
%/: %.epub
	unzip -o $< -d $@
