DOCS = cpp cppinternals gcc gccint gfortran treelang
VER = 4.1
FULLVER = 4.1.1

INFODOCS = $(DOCS:%=%-$(VER).info)
HTMLDOCS = $(DOCS:%=%.html)
FORTRANMAN = gfortran-$(VER).1

TARGETS = $(INFODOCS) $(HTMLDOCS) $(FORTRANMAN)
GENFILES = $(TARGETS) gcc-vers.texi gfortran.pod

all : $(TARGETS)

gfortran-$(VER).info : fortran-texi/gfortran.texi gcc-vers.texi
	makeinfo --no-split -Itexi -o $@ $<

%-$(VER).info : texi/%.texi gcc-vers.texi
	makeinfo --no-split -o $@ $<

gfortran.html : fortran-texi/gfortran.texi gcc-vers.texi
	makeinfo --html --no-split -Itexi -o $@ $<

%.html : texi/%.texi gcc-vers.texi
	makeinfo --html --no-split -o $@ $<

$(FORTRANMAN) : gfortran.pod
	pod2man --center="GNU" --release="gcc-$(FULLVER)" --section=1 $< > $@

gfortran.pod : fortran-texi/invoke.texi gcc-vers.texi
	perl ./texi2pod.pl < fortran-texi/invoke.texi > $@

gcc-vers.texi :
	(echo @set version-GCC $(FULLVER); echo @clear DEVELOPMENT) > $@

clean:
	rm -f $(GENFILES)
