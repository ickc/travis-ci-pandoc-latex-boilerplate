# README

## Organization

The file and folder structure is

-   `<collection>/<unit>.md`: contain the smallest indivisible unit, e.g.\ a single problem/lab
-   `<collection>/media/<unit>-#.*`: contain the corresponding media file. e.g.\ `.ai`
-   `<collection>.csv`: for bookkeeping and also for auto-generating the necessary files according to the `filename` column and the first few columns declaring if the unit should be included in the workbook or not. Each row is a `<unit>`.
-   `workbook.csv`: similar to `<collection>.csv`, but each row represent a `<collection>` instead.
-   `workbook.yml`: containing the metadata of the workbooks. It controls most of the styles too (e.g.\ memoir class).
-   `workbook.sty`: finer control of the style than the above.

The output files will be named `workbook*.pdf` where `*` can be `7a`, `8a`, `master`, etc.

## Dependencies

Run the `script/install-*.sh` scripts to install the dependencies for the project:

-   `install-<OS>.sh` installs:
    -   pandoc
    -   pip & pandocfilters
-   `install-<OS>-<TeX>.sh` install TeXLive

## Makefile

### Building the PDFs

`makefile`: all actions required to build the workbook is there. In terminal,

-   `cd` into the folder
-   `make` will compile the workbook
-   `make pandoc` will compile the workbook in an alternative way. The resulting PDFs should be visually identical to `make`.
-   `make clean` will delete all auxiliary files other than the PDFs
-   `make Clean` (notice the capital `C`) will delete all auxiliary files **including** the PDFs
-   To terminate the process, use `Ctrl-D` or `Ctrl-C`.

### Automation on Individual Units

The `makefile` contains a lot of helpful commands for initial creation of problems:

-   Preparation:
    -   `make touch`: create every files expected from the `.csv` filenames.
    -   `make enclose`: enclose every problem with a problem environment if not present yet.
-   Batch formatting and styling:
    -   `make unspan`: remove `span` surrounding emphasis.
    -   `make convert`: auto-convert `doc` math expression to LaTeX math expression
    -   `make nonbreaking`: auto create non-breaking space after shortform
-   Cleanup source code:
    -   `make normalize`: normalize white spaces in the files.
    -   `make style`: use pandoc to conform the source into a style. Must use `make normalize` after this command: `make style && make normalize`.
-   Detecting potential problems:
    -   `make detect`: highlight "illegal" characters (defined by me)
    -   `make detectStrict`: highlight any unicode characters
    -   `make detectAllCaps`: detect all-capped words --- typographically poor when it is not necessary (e.g.\ abbreviations).
    -   `make detectRAW`: detect any raw HTML and raw LaTeX syntax in pandoc's internal AST format (useful to ensure the source is portable for both HTML and LaTeX generation).
    -   `make detectDollar`: detect `$` sign, probably are math which accidentally turned into `Code` (unparsed).
    -   `make detectCode`: A more general detection to detect accidental `Code` (unparsed).
    -   `make lint`: use `chktex` and `lacheck` to check for potential typographical mistakes in the files.

## Naming Convention

Starting from `2d-kinematics`, the filename should follow the convention:

-   Make a title first. This will becomes the title shown in the workbooks. e.g.\ "Water-ballon Cannon on Cliff"
-   Replaces hyphens by underscores: `Water_ballon Cannon on Cliff`
-   Replaces spaces by hyphens: `Water_ballon-Cannon-on-Cliff`
-   For headline or caption, drop all articles. See references below:
    1.  [5 tested rules to follow when writing headlines](http://www.easymedia.in/5-tested-rules-to-follow-when-writing-headlines/)
    2.  [Article drop in headlines and truncation of CP](http://www.linguisticsociety.org/sites/default/files/3540-6845-1-SM.pdf)
    3.  [Article drop in English headlinese](http://folk.ntnu.no/andrewww/Weir-2009-headlinese.pdf)

Notice that in Mac the file system is by default case-insensitive. If you make a mistake in the cases, the error won't show up on your computer, but it will break the build for someone else (and Travis).

## Contributing

### Practices

-   Do not italicize Latin: `e.g.`, `i.e.`. See [Latin phrases in scientific writing: italics or not | Editage Insights](http://www.editage.com/insights/latin-phrases-in-scientific-writing-italics-or-not).
-   End shortform in non-breaking space, like this: `e.g.\ some example`, `i.e.\ the law...`. The backslash escaped space, `\ \ \ ...`, represented a non-breaking space. See more at [Nonbreaking spaces | Butterick's Practical Typography](http://practicaltypography.com/nonbreaking-spaces.html).
-   Math delimiters: dollar sign with be used: `$...$`, `$$...$$`. The output in LaTeX will actually be `\(...\)` and `\[...\]` (i.e.\ *correct*, as you may know, `$`s are decouraged in LaTeX). However in pandoc, `\` means escape. So if one want to output `\(`, you need to type `\\(` instead, i.e.\ cumbersome.
-   LaTeX packages:
    -   use `physics`: why:
        -   try $\frac{dx}{dt}$ vs $\dv{x}{t}$.
        -   exercise: how to correct the former one?
        -   conclusion: it will be clumsy to type the correct expression without a macro. Using a standard package is better than creating your own macro using non-standard (or even standard) names.
    -   use `sinunitx`
        -   $$x(t) = 15~\mbox{m} + (20~\mbox{m/s}) t  -  (1.3~\mbox{m/s$^2$}) t^2$$ vs $$x(t) = \SI{15}{\m} + \pqty{\SI{20}{\m \per \s}} t  - \pqty{\SI{1.3}{\m \per \s^2}} t^2$$
        -   In LaTeX, `\SI` and `\si` commands can be optionally enclosed in math. Here, we enforce it to be enclosed with `$` (for compatibility in output other than LaTeX).
-   Prefer concise: e.g.
    -   Prefer arabic numerals whenever possible (excluding in titles)
    -   Prefer "$a$-$t$ graph" rather than "acceleration versus time graph", etc.
-   other spelling: `vs.`
-   If possible, do not use non-ASCII characters, exception: `™`, `Ampére`, `Schriödinger`
