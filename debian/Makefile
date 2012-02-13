I_GCC = gcc gccint cpp cppinternals
I_FORTRAN = gfortran
I_ADA = gnat-style gnat_rm gnat_ugn
I_GCJ = gcj
I_GO = gccgo
I = $(I_GCC) $(I_FORTRAN) $(I_ADA) $(I_GCJ) $(I_GO)
INFODOCS = $(I:%=%-$(VER).info) gccinstall-$(VER).info
HTMLDOCS = $(I:%=%.html)

GCJ_M1 = gcj gij jcf-dump jv-convert grmic gcj-dbtool gc-analyse
M1 = gcc gcov cpp gfortran $(GCJ_M1) gccgo
M = $(M1)
MANS = $(M:%=%-$(VER).1)
PODS = $(M:%=%.pod)

VER = 4.6
FULLVER = 4.6.2

GCCVERS = gcc/doc/gcc-vers.texi

TARGETS = $(INFODOCS) $(HTMLDOCS) $(MANS)
GENFILES = $(TARGETS) $(PODS) $(GCCVERS)

MKINFO_DEFINES := -D "fncpp cpp-$(VER)" \
		  -D "fncppint cppinternals-$(VER)" \
		  -D "fngcc gcc-$(VER)" \
		  -D "fngxx g++-$(VER)" \
		  -D "fngccint gccint-$(VER)" \
		  -D "fngccinstall gccinstall-$(VER)" \
		  -D "fngcj gcj-$(VER)" \
		  -D "fngfortran gfortran-$(VER)" \
		  -D "fntreelang treelang-$(VER)" \
		  -D "BUGURL http://bugs.debian.org/"
MKINFO_FLAGS := --no-split -Igcc/doc -Igcc/doc/include
MKINFO = makeinfo $(MKINFO_DEFINES) $(MKINFO_FLAGS)

TEXI2POD_DEFINES := -Dfngccint=gccint-$(VER) -DBUGURL=http://bugs.debian.org/
TEXI2POD = perl ../../contrib/texi2pod.pl $(TEXI2POD_DEFINES)

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

$(I_ADA:%=%-$(VER).info) : %-$(VER).info : gcc/ada/%.texi $(GCCVERS)
	$(MKINFO) -D unw -o $@ $<

$(I_ADA:%=%.html) : %.html : gcc/ada/%.texi $(GCCVERS)
	$(MKINFO) -D unw --html -o $@ $<

$(I_GCJ:%=%-$(VER).info) : %-$(VER).info : gcc/java/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_GCJ:%=%.html) : %.html : gcc/java/%.texi $(GCCVERS)
	$(MKINFO) --html -o $@ $<

$(I_GO:%=%-$(VER).info) : %-$(VER).info : gcc/go/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_GO:%=%.html) : %.html : gcc/go/%.texi $(GCCVERS)
	$(MKINFO) --html -o $@ $<

%-$(VER).1 : %.pod
	pod2man --center="GNU" --release="gcc-$(FULLVER)" --section=1 $< > $@

gcc.pod : gcc/doc/invoke.texi $(GCCVERS)
	(cd gcc/doc && $(TEXI2POD)) < $< > $@

gcov.pod : gcc/doc/gcov.texi $(GCCVERS)
	(cd gcc/doc && $(TEXI2POD)) < $< > $@

cpp.pod : gcc/doc/cpp.texi $(GCCVERS)
	(cd gcc/doc && $(TEXI2POD)) < $< > $@

$(GCJ_M1:%=%.pod) : %.pod : gcc/java/gcj.texi
	(cd gcc/java && $(TEXI2POD) -D$(@:%.pod=%)) < $< > $@

gfortran.pod: gcc/fortran/invoke.texi $(GCCVERS)
	(cd gcc/fortran && $(TEXI2POD)) < $< > $@

gccgo.pod: gcc/go/gccgo.texi $(GCCVERS)
	(cd gcc/go && $(TEXI2POD)) < $< > $@

$(GCCVERS) :
	(echo @set version-GCC $(FULLVER); \
	 echo @clear DEVELOPMENT; \
	 echo @set srcdir `pwd`/gcc ) > $@

clean:
	rm -f $(GENFILES)
