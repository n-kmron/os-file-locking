compileLatex:
	pdflatex main.tex
	bibtex main
	pdflatex main.tex
	cp main.pdf ..
	mv ../main.pdf ../Noupoue_FileLocking.pdf
	evince -f ../Noupoue_FileLocking.pdf


clean:
	@rm -f texput.log main.aux main.toc main.bbl main.blg main.log main.out main.pdf

