all: docs/index.html

docs/index.html: index.Rmd Makefile
	R -q -e 'rmarkdown::render("$<", output_dir = "docs")'
