SRCDIRA=Source
SRCDIRB=TwoPageCV
PREVDIR=PreviousCVs
OLDNAME=$(shell date | awk '{printf "CV_Until_%s_%s_%s.pdf", $$2, $$3, $$6}')

ifneq ("$(wildcard $(PREVDIR)/$(OLDNAME))","")
	FILE_EXISTS = 1
else
	FILE_EXISTS = 0
endif

default: all

all: main twopage update

pushUpdate: main twopage update autopush

main:
	cd $(SRCDIRA); make

twopage:
	cd $(SRCDIRB); make

update: Source/cv.tex
ifeq ($(FILE_EXISTS),0)
	mv CV.pdf $(PREVDIR)/$(OLDNAME)
	cp $(SRCDIRA)/cv.pdf ./CV.pdf
else
	$(info "CV Already moved today! If you want to manually force a move delete the file $(PREVDIR)/$(OLDNAME))
endif

autopush:
	git add .
	git commit -m "Updated CV and stashed old as $(OLDNAME)"
	git push origin master
