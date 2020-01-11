GUIDE_DIR = ../../diderot-guide
DIDEROT_ADMIN = ../../diderot-cli/diderot_admin

PDFLATEX = pdflatex
LATEX = latex
FLAG_VERBOSE = -v 
FLAG_DBG = -d 

# Course and Book Settings
LABEL_COURSE="CMU:Pittsburgh, PA:15210:Spring:2019-20"
LABEL_TEXTBOOK="LIBDOC"

# Set up some variables
NO=0
FILE=""
ATTACH=""


PREAMBLE = ./templates/preamble-diderot.tex
# resource paths don't seem to work
PANDOC = pandoc --mathjax -f latex


ifeq ($(OS),Windows_NT)
	DC_HOME = $(GUIDE_DIR)/bin/windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		DC_HOME = $(GUIDE_DIR)/bin/ubuntu
	endif
	ifeq ($(UNAME_S),Darwin)
		DC_HOME = $(GUIDE_DIR)/bin/macos
	endif
endif


DC = $(DC_HOME)/dc 
DCDBG = $(DC_HOME)/dc.dbg 


default: pdf

FORCE: 

.PHONY: book html pdf

html: FORCE
	$(PANDOC) -s book-html.tex > book.html

clean: 
	rm *.aux *.idx *.log *.out *.toc */*.aux */*.idx */*.log */*.out 

reset: 
	make clean; rm *.pdf; rm*.html; rm  *~; rm */*~; rm  \#*\#; rm */\#*\#; 



######################################################################
## BEGIN: XML
######################################################################

html: FORCE
	$(PANDOC) -s book-html.tex > book.html


%.xml : %.tex FORCE
ifdef debug
ifdef verbose
	$(DC) $(FLAG_DBG) $(FLAG_VERBOSE)  -meta ./meta -preamble $(PREAMBLE) $< -o $@
 else
	$(DC) $(FLAG_DBG) -meta ./meta -preamble $(PREAMBLE)  $< -o $@
endif
else
ifdef verbose
	$(DC) $(FLAG_VERBOSE)  -meta ./meta -preamble $(PREAMBLE) $< -o $@
 else
	$(DC)  -meta ./meta -preamble $(PREAMBLE)  $< -o $@
endif
endif

%.xml : %.md FORCE
ifdef debug
ifdef verbose
	$(DC)  $(FLAG_DBG) $(FLAG_VERBOSE) $< -o $@
 else
	$(DC)  $(FLAG_DBG) $< -o $@
endif
else
ifdef verbose
	$(DC) $(FLAG_VERBOSE) $< -o $@
 else
	$(DC) $< -o $@
endif
endif


######################################################################
## END: XML
######################################################################

######################################################################
## BEGIN: PDF
######################################################################
book: 
	$(PDFLATEX) --jobname="book" '\input{book}' ; 
	$(PDFLATEX) --jobname="book" '\input{book}' ; \

%.pdf : %.tex book
	$(PDFLATEX) --shell-escape --jobname="target" "\includeonly{$*}\input{book} ";
	mv target.pdf $@

upload_xml_pdf: 
	-$(DIDEROT_ADMIN) create_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --number $(NO)
	$(DIDEROT_ADMIN) upload_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --chapter_number $(NO) --xml $(FILE).xml --xml_pdf $(FILE).pdf

upload_xml_pdf_attach: 
	-$(DIDEROT_ADMIN) create_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --number $(NO)
	$(DIDEROT_ADMIN) upload_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --chapter_number $(NO) --xml $(FILE).xml --xml_pdf $(FILE).pdf --attach $(ATTACH)



# Chapter: overview
sequences: \
  sequences/interface.pdf \
  sequences/interface.xml \
  sequences/arrays.pdf \
  sequences/arrays.xml \


upload_sequences_interface: NO=1 
upload_sequences_interface: FILE=sequences/interface
upload_sequences_interface: sequences/interface.xml sequences/interface.pdf upload_xml_pdf


upload_sequences_arrays: NO=2 
upload_sequences_arrays: FILE=sequences/arrays
upload_sequences_arrays: sequences/arrays.xml sequences/arrays.pdf upload_xml_pdf

