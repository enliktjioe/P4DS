require(knitr)
require(markdown)

knit("regression.Rmd")
markdownToHTML('regression.md', 'regression.html', options=c("use_xhml"))
system("pandoc --pdf-engine=xelatex  -s regression.html -o regression.pdf")


# Reference: http://rprogramming.net/create-html-or-pdf-files-with-r-knitr-miktex-and-pandoc/