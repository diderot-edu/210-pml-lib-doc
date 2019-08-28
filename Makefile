# Make this point to your Diderot guide directory
GUIDE_DIR = ../diderot-guide

######################################################################
## Begin: Setup

PDFLATEX = pdflatex
LATEX = latex
WWW-BOOK = ~/Google\ Drive/algorithms-book

PREAMBLE = ./templates/diderot-preamble.tex
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

FLAG_VERBOSE = -v 
FLAG_DBG = -d

DC = $(DC_HOME)/dc -meta ./meta
## End: Setup
######################################################################

######################################################################
## Begin: Compile

FORCE: 

.PHONY: book html book-www book.pdf 


# Generate html. Might have to modify book-html.tex
html: FORCE
	$(PANDOC) -s book-html.tex > book.html

## Unused, keep for reference.
%_led.tex : %.tex FORCE
	$(LABELTEX) $<  -o $@

## xml
%.xml : %.tex FORCE
ifdef debug
ifdef verbose
	$(DC) $(FLAG_DBG) $(FLAG_VERBOSE) $< -preamble $(PREAMBLE) -o $@
 else
	$(DC) $(FLAG_DBG) $< -preamble $(PREAMBLE) -o $@
endif
else
ifdef verbose
	$(DC) $(FLAG_VERBOSE) $< -preamble $(PREAMBLE) -o $@
 else
	$(DC) $< -preamble $(PREAMBLE) -o $@
endif
endif

clean: 
	rm *.aux *.idx *.log *.out *.toc */*.aux */*.idx */*.log */*.out 

reset: 
	make clean; rm *.pdf; rm*.html; rm  *~; rm */*~; rm  \#*\#; rm */\#*\#; 


all-xml: \
introduction/introduction.xml introduction/spec.xml genome/genome.xml \
background/sets.xml background/graphs.xml \
language/lambda.xml language/sparc.xml language/functional.xml \
analysis/asymptotics.xml analysis/models.xml analysis/recurrences.xml \
sequences/introduction.xml sequences/adt.xml sequences/implement.xml \
sequences/cost.xml sequences/examples.xml sequences/ephemeral.xml \
design/basics.xml design/divide-conquer.xml design/contraction.xml \
mcss/mcss.xml \
probability/theory.xml probability/randomvars.xml probability/expectation.xml \
probability/theory.xml probability/randomvars.xml probability/expectation.xml \
randomization/introduction.xml randomization/select.xml randomization/qsort.xml \
bsts/adt.xml bsts/parametric.xml bsts/treaps.xml bsts/augment.xml \
sets-and-tables/sets.xml sets-and-tables/tables.xml \
sets-and-tables/ordered.xml sets-and-tables/examples.xml \
graphs/graphs.xml \
graph-search/search.xml graph-search/bfs.xml \
shortest-paths/introduction.xml shortest-paths/dijkstra.xml \
shortest-paths/bellmanford.xml shortest-paths/johnson.xml \
graph-contraction/introduction.xml graph-contraction/edge.xml \
graph-contraction/star.xml graph-contraction/connectivity.xml \
mst/intro.xml mst/seq.xml mst/par.xml \
dp/intro.xml dp/ssandmed.xml dp/implement.xml dp/obst.xml \
pq/pq.xml \
hashing/foundations.xml hashing/tables.xml \
concurrency/threads-new.xml concurrency/mutex.xml \

some-xml: \
background/sets.xml background/graphs.xml \
language/lambda.xml language/sparc.xml language/functional.xml \
sequences/introduction.xml sequences/adt.xml sequences/implement.xml \
sequences/cost.xml sequences/examples.xml sequences/ephemeral.xml \
mcss/mcss.xml \
randomization/introduction.xml randomization/select.xml randomization/qsort.xml \
bsts/adt.xml bsts/parametric.xml bsts/treaps.xml bsts/augment.xml \
shortest-paths/introduction.xml shortest-paths/dijkstra.xml \
shortest-paths/bellmanford.xml shortest-paths/johnson.xml \
graph-contraction/introduction.xml graph-contraction/edge.xml \
graph-contraction/star.xml graph-contraction/connectivity.xml \


######################################################################
## PDFs


book:
	$(PDFLATEX) --jobname="book" '\input{book}' ; 
	$(PDFLATEX) --jobname="book" '\input{book}' ; \

book-www: book
	cp book.pdf $(WWW-BOOK)


exam:
	$(PDFLATEX) --jobname="exam" '\input{exam}' ; 
	$(PDFLATEX) --jobname="exam" '\input{exam}' ; \


## intro
intro: book introduction/introduction.tex introduction/spec.tex genome/genome.tex
	$(PDFLATEX) --jobname="intro" '\includeonly{introduction/introduction, introduction/spec, genome/genome}\input{book} '

intro-www: intro
	cp intro.pdf $(WWW-BOOK)

## background
background: book background/sets.tex background/graphs.tex
	$(PDFLATEX) --jobname="background" '\includeonly{background/part, background/sets, background/graphs} \input{book} '

background-www: background
	cp background.pdf $(WWW-BOOK)

## language
language: book language/lambda.tex language/sparc.tex language/functional.tex
	$(PDFLATEX) --jobname="language" '\includeonly{language/part, language/lambda, language/sparc, language/functional} \input{book} '

language-www: language
	cp language.pdf $(WWW-BOOK)


## analysis
analysis: book analysis/asymptotics.tex analysis/models.tex analysis/recurrences.tex
	$(PDFLATEX) --jobname="analysis" '\includeonly{analysis/part, analysis/asymptotics, analysis/models, analysis/recurrences} \input{book}'

analysis-www: analysis
	cp analysis.pdf $(WWW-BOOK)


## Sequences
sequences: book sequences/introduction.tex sequences/adt.tex sequences/implement.tex sequences/cost.tex sequences/examples.tex sequences/ephemeral.tex
	$(PDFLATEX) --jobname="sequences" '\includeonly{sequences/part, sequences/introduction, sequences/adt, sequences/implement, sequences/cost, sequences/examples, sequences/ephemeral} \input{book}'

sequences-www: sequences
	cp sequences.pdf $(WWW-BOOK)

## Design
design: book design/basics.tex design/divide-conquer.tex design/contraction.tex mcss/mcss.tex
	$(PDFLATEX) --jobname="design" '\includeonly{design/part, design/basics, design/divide-conquer, design/contraction, mcss/mcss} \input{book}'

design-www: design
	cp design.pdf $(WWW-BOOK)

## Probability
probability: book probability/theory.tex probability/randomvars.tex probability/expectation.tex
	$(PDFLATEX) --jobname="probability" '\includeonly{probability/part, probability/theory, probability/randomvars, probability/expectation} \input{book}'

probability-www: probability
	cp probability.pdf $(WWW-BOOK)


## Randomization
randomization: book randomization/introduction.tex randomization/select.tex randomization/qsort.tex
	$(PDFLATEX) --jobname="randomization" '\includeonly{randomization/part, randomization/introduction, randomization/select, randomization/qsort} \input{book}'

randomization-www: randomization
	cp randomization.pdf $(WWW-BOOK)

## Bsts
bsts: book bsts/adt.tex bsts/parametric.tex bsts/treaps.tex bsts/augment.tex
	$(PDFLATEX) --jobname="bsts" '\includeonly{bsts/part, bsts/adt, bsts/parametric, bsts/treaps, bsts/augment} \input{book}'

bsts-www: bsts
	cp bsts.pdf $(WWW-BOOK)

## Sets-And-Tables
sets-and-tables: book sets-and-tables/sets.tex sets-and-tables/tables.tex sets-and-tables/ordered.tex sets-and-tables/examples.tex
	$(PDFLATEX) --jobname="sets-and-tables" '\includeonly{sets-and-tables/part, sets-and-tables/sets, sets-and-tables/tables, sets-and-tables/ordered, sets-and-tables/examples} \input{book}'

sets-and-tables-www: sets-and-tables
	cp sets-and-tables.pdf $(WWW-BOOK)

## Graphs
graphs: book graphs/graphs.tex graph-search/search.tex graph-search/bfs.tex graph-search/dfs.tex 
	$(PDFLATEX) --jobname="graphs" '\includeonly{graphs/part, graphs/graphs, graph-search/search, graph-search/bfs, graph-search/dfs} \input{book}'

graphs-www: graphs
	cp graphs.pdf $(WWW-BOOK)

## Dijkstra
dijkstra: book shortest-paths/dijkstra.tex

	$(PDFLATEX) --jobname="dijkstra" '\includeonly{shortest-paths/dijkstra} \input{book}'


## Shortest-Paths
shortest-paths: book shortest-paths/introduction.tex  shortest-paths/dijkstra.tex  shortest-paths/bellmanford.tex  shortest-paths/johnson.tex

	$(PDFLATEX) --jobname="shortest-paths" '\includeonly{shortest-paths/part, shortest-paths/introduction, shortest-paths/dijkstra, shortest-paths/bellmanford, shortest-paths/johnson} \input{book}'

## Graph-Contraction
graph-contraction: book graph-contraction/contraction.tex  graph-contraction/edge.tex  graph-contraction/star.tex graph-contraction/connectivity.tex

	$(PDFLATEX) --jobname="graph-contraction" '\includeonly{graph-contraction/part, graph-contraction/introduction, graph-contraction/edge, graph-contraction/star, graph-contraction/connectivity} \input{book}'

## Graph-Contraction
star: book graph-contraction/star.tex

	$(PDFLATEX) --jobname="star" '\includeonly{graph-contraction/star} \input{book}'

graph-contraction-www: graph-contraction
	cp graph-contraction.pdf $(WWW-BOOK)


## Mst
mst: book mst/intro.tex mst/seq.tex mst/par.tex
	$(PDFLATEX) --jobname="mst" '\includeonly{mst/part, mst/intro, mst/seq, mst/par} \input{book}'

mst-www: mst
	cp mst.pdf $(WWW-BOOK)

## DP
dp: book dp/part.tex dp/intro.tex dp/ssandmed.tex dp/implement.tex
	$(PDFLATEX) --jobname="dp" '\includeonly{dp/part, dp/intro, dp/ssandmed, dp/implement, dp/obst} \input{book}'

dp-www: dp
	cp dp.pdf $(WWW-BOOK)

## Priority Queues
pq: book pq/part.tex pq/pq.tex 
	$(PDFLATEX) --jobname="pq" '\includeonly{pq/part, pq/pq, pq/pq} \input{book}'

pq-www: pq
	cp pq.pdf $(WWW-BOOK)

## Hashing
hashing: book hashing/part.tex hashing/foundations.tex hashing/tables.tex 
	$(PDFLATEX) --jobname="hashing" '\includeonly{hashing/part, hashing/foundations, hashing/tables} \input{book}'

hashing-www: hashing
	cp hashing.pdf $(WWW-BOOK)

## Concurrency
concurrency: book concurrency/part.tex concurrency/threads.tex   concurrency/mutex.tex  
	$(PDFLATEX) --jobname="concurrency" '\includeonly{concurrency/part, concurrency/threads-new, concurrency/sequences, concurrency/mutex} \input{book}'

## Quiz
quiz: exam  quiz/quiz.tex 
	$(PDFLATEX) --jobname="quiz" '\includeonly{quiz/quiz-simple} \input{exam}'

concurrency-www: concurrency
	cp concurrency.pdf $(WWW-BOOK)


all-www: book book-www intro-www background-www language-www \
         analysis-www sequences-www design-www	probability-www \
         randomization-www bsts-www sets-and-tables-www \
         graphs-www shortest-paths-www shortest-paths-www \
         graph-contraction-www mst-www dp-www
	cp book.pdf $(WWW-BOOK)

