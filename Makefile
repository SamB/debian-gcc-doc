I_DOC = gcc gccint cpp cppinternals
I_FORTRAN = gfortran
I_TREELANG = treelang
I_ADA = gnat-style gnat_rm gnat_ugn
I = $(I_DOC) $(I_FORTRAN) $(I_TREELANG) $(I_ADA)
INFODOCS = $(I:%=%-$(VER).info)
HTMLDOCS = $(I:%=%.html)

M1 = gcc gcov cpp gfortran
M = $(M1)
MANS = $(M:%=%-$(VER).1)
PODS = $(M:%=%.pod)

VER = 4.1
FULLVER = 4.1.1

TARGETS = $(INFODOCS) $(HTMLDOCS) $(MANS)
GENFILES = $(TARGETS) gcc-vers.texi $(PODS)

MKINFO_DEFINES := $(shell echo $(I) gcj cppint | sed 's/\([-_a-z]\+\)/-D "fn\1 \1-$(VER)"/g')
MKINFO = makeinfo $(MKINFO_DEFINES)

all : $(TARGETS)

$(I_DOC:%=%-$(VER).info) : %-$(VER).info : doc/%.texi gcc-vers.texi
	$(MKINFO) --no-split -Idoc -Idoc/include -o $@ $<

$(I_DOC:%=%.html) : %.html : doc/%.texi gcc-vers.texi
	$(MKINFO) --html --no-split -Idoc -Idoc/include -o $@ $<

$(I_FORTRAN:%=%-$(VER).info) : %-$(VER).info : fortran/%.texi gcc-vers.texi
	$(MKINFO) --no-split -Idoc -Idoc/include -o $@ $<

$(I_FORTRAN:%=%.html) : %.html : fortran/%.texi gcc-vers.texi
	$(MKINFO) --html --no-split -Idoc -Idoc/include -o $@ $<

$(I_TREELANG:%=%-$(VER).info) : %-$(VER).info : treelang/%.texi gcc-vers.texi
	$(MKINFO) --no-split -Idoc -Idoc/include -o $@ $<

$(I_TREELANG:%=%.html) : %.html : treelang/%.texi gcc-vers.texi
	$(MKINFO) --html --no-split -Idoc -Idoc/include -o $@ $<

$(I_ADA:%=%-$(VER).info) : %-$(VER).info : ada/%.texi gcc-vers.texi
	$(MKINFO) -D unw --no-split -Idoc -Idoc/include -o $@ $<

$(I_ADA:%=%.html) : %.html : ada/%.texi gcc-vers.texi
	$(MKINFO) -D unw --html --no-split -Idoc -Idoc/include -o $@ $<

%-$(VER).1 : %.pod
	pod2man --center="GNU" --release="gcc-$(FULLVER)" --section=1 $< > $@

gcc.pod : doc/invoke.texi gcc-vers.texi
	(cd doc && perl ../texi2pod.pl) < $< > $@

gcov.pod : doc/gcov.texi gcc-vers.texi
	(cd doc && perl ../texi2pod.pl) < $< > $@

cpp.pod : doc/cpp.texi gcc-vers.texi
	(cd doc && perl ../texi2pod.pl) < $< > $@

gfortran.pod: fortran/invoke.texi gcc-vers.texi
	(cd fortran && perl ../texi2pod.pl) < $< > $@

gcc-vers.texi :
	(echo @set version-GCC $(FULLVER); echo @clear DEVELOPMENT) > $@

clean:
	rm -f $(GENFILES)
