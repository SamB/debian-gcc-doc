I_GCC = gcc gccint cpp cppinternals
I_FORTRAN = gfortran
I_TREELANG = treelang
I_ADA = gnat-style gnat_rm gnat_ugn
I = $(I_GCC) $(I_FORTRAN) $(I_TREELANG) $(I_ADA)
INFODOCS = $(I:%=%-$(VER).info) gccinstall-$(VER).info
HTMLDOCS = $(I:%=%.html)

M1 = gcc gcov cpp gfortran
M = $(M1)
MANS = $(M:%=%-$(VER).1)
PODS = $(M:%=%.pod)

VER = 4.2
FULLVER = 4.2.3

GCCVERS = gcc/doc/gcc-vers.texi

TARGETS = $(INFODOCS) $(HTMLDOCS) $(MANS)
GENFILES = $(TARGETS) $(PODS) $(GCCVERS)

MKINFO_DEFINES := -D "fncpp cpp-$(VER)" \
		  -D "fncppint cppinternals-$(VER)" \
		  -D "fngcc gcc-$(VER)" \
		  -D "fngccint gccint-$(VER)" \
		  -D "fngccinstall gccinstall-$(VER)" \
		  -D "fngcj gcj-$(VER)" \
		  -D "fngfortran gfortran-$(VER)" \
		  -D "fntreelang treelang-$(VER)"
MKINFO_FLAGS := --no-split -Igcc/doc -Igcc/doc/include
MKINFO = makeinfo $(MKINFO_DEFINES) $(MKINFO_FLAGS)

all : $(TARGETS)

$(I_GCC:%=%-$(VER).info) : %-$(VER).info : gcc/doc/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

gccinstall-$(VER).info : gcc/doc/install.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_GCC:%=%.html) : %.html : gcc/doc/%.texi $(GCCVERS)
	$(MKINFO) --html -o $@ $<

$(I_FORTRAN:%=%-$(VER).info) : %-$(VER).info : gcc/fortran/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_FORTRAN:%=%.html) : %.html : gcc/fortran/%.texi $(GCCVERS)
	$(MKINFO) --html -o $@ $<

$(I_TREELANG:%=%-$(VER).info) : %-$(VER).info : gcc/treelang/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_TREELANG:%=%.html) : %.html : gcc/treelang/%.texi $(GCCVERS)
	$(MKINFO) --html -o $@ $<

$(I_ADA:%=%-$(VER).info) : %-$(VER).info : gcc/ada/%.texi $(GCCVERS)
	$(MKINFO) -D unw -o $@ $<

$(I_ADA:%=%.html) : %.html : gcc/ada/%.texi $(GCCVERS)
	$(MKINFO) -D unw --html -o $@ $<

%-$(VER).1 : %.pod
	pod2man --center="GNU" --release="gcc-$(FULLVER)" --section=1 $< > $@

gcc.pod : gcc/doc/invoke.texi $(GCCVERS)
	(cd gcc/doc && perl ../../texi2pod.pl -Dfngccint=gccint-$(VER)) < $< > $@

gcov.pod : gcc/doc/gcov.texi $(GCCVERS)
	(cd gcc/doc && perl ../../texi2pod.pl) < $< > $@

cpp.pod : gcc/doc/cpp.texi $(GCCVERS)
	(cd gcc/doc && perl ../../texi2pod.pl) < $< > $@

gfortran.pod: gcc/fortran/invoke.texi $(GCCVERS)
	(cd gcc/fortran && perl ../../texi2pod.pl) < $< > $@

$(GCCVERS) :
	(echo @set version-GCC $(FULLVER); \
	 echo @clear DEVELOPMENT; \
	 echo @set srcdir `pwd`/gcc ) > $@

clean:
	rm -f $(GENFILES)
