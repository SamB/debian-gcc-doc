I_GCC = gcc gccint cpp cppinternals # install
I_FORTRAN = gfortran
I_ADA = gnat-style gnat_rm # gnat_ugn
I_GCJ = gcj
I_GO = gccgo
I = $(I_GCC) $(I_FORTRAN) $(I_ADA) gnat_ugn $(I_GCJ) $(I_GO)
INFODOCS = $(I:%=%-$(VER).info) gccinstall-$(VER).info
PDFDOCS = $(I:%=%.pdf) gccinstall.pdf
HTMLDOCS = $(I:%=%.html)

GCJ_M1 = gcj gij jcf-dump jv-convert grmic gcj-dbtool gc-analyse
M1 = gcc gcov cpp gfortran $(GCJ_M1) gccgo
M = $(M1)
MANS = $(M:%=%-$(VER).1)
PODS = $(M:%=%.pod)

VER = $(BASE_VERSION)
FULLVER = $(GCC_VERSION)

GCCVERS = gcc/doc/gcc-vers.texi

TARGETS = $(INFODOCS) $(HTMLDOCS) $(MANS) $(PDFDOCS)
GENFILES_GNAT = xgnatugn* gcc/doc/gnat_ugn.texi gcc/doc/projects.texi
GENFILES = $(TARGETS) $(PODS) $(GCCVERS) $(GENFILES_GNAT)

MKINFO_DEFINES := -D"fncpp cpp-$(VER)" \
		  -D"fncppint cppinternals-$(VER)" \
		  -D"fngcc gcc-$(VER)" \
		  -D"fngxx g++-$(VER)" \
		  -D"fngccint gccint-$(VER)" \
		  -D"fngccinstall gccinstall-$(VER)" \
		  -D"fngcj gcj-$(VER)" \
		  -D"fngfortran gfortran-$(VER)" \
		  -D"fntreelang treelang-$(VER)" \
		  -D"BUGURL http://bugs.debian.org/"
MKINFO_FLAGS := --no-split -Igcc/doc -Igcc/doc/include
MKINFO = makeinfo $(MKINFO_DEFINES) $(MKINFO_FLAGS)

MKHTML_DEFINES := -D"fncpp cpp" \
		  -D"fncppint cppinternals" \
		  -D"fngcc gcc" \
		  -D"fngxx g++" \
		  -D"fngccint gccint" \
		  -D"fngccinstall gccinstall" \
		  -D"fngcj gcj" \
		  -D"fngfortran gfortran" \
		  -D"fntreelang treelang" \
		  -D"BUGURL http://bugs.debian.org/"
MKHTML_FLAGS := --no-split -Igcc/doc -Igcc/doc/include
MKHTML = makeinfo $(MKHTML_DEFINES) $(MKHTML_FLAGS) --html

TEXI2POD_DEFINES := -Dfngccint=gccint-$(VER) -DBUGURL=http://bugs.debian.org/
TEXI2POD = perl ../../contrib/texi2pod.pl $(TEXI2POD_DEFINES)

TEXI2PDF_DEFINES := $(MKHTML_DEFINES:-D%=--command="@set "%)
TEXI2PDF_FLAGS = --batch -t '@errorcontextlines 16' --build-dir=build -I debian -I gcc/doc -I gcc/doc/include
TEXI2PDF = texi2pdf $(TEXI2PDF_DEFINES) $(TEXI2PDF_FLAGS)


all : $(TARGETS)


#
# Simple makeinfo rules
#

$(I_GCC:%=%-$(VER).info) : %-$(VER).info : gcc/doc/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_GCC:%=%.html) : %.html : gcc/doc/%.texi $(GCCVERS)
	$(MKHTML) -o $@ $<

$(I_GCC:%=%.pdf) : %.pdf : gcc/doc/%.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


gccinstall-$(VER).info : gcc/doc/install.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

gccinstall.pdf : gcc/doc/install.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


$(I_FORTRAN:%=%-$(VER).info) : %-$(VER).info : gcc/fortran/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_FORTRAN:%=%.html) : %.html : gcc/fortran/%.texi $(GCCVERS)
	$(MKHTML) -o $@ $<

$(I_FORTRAN:%=%.pdf) : %.pdf : gcc/fortran/%.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


$(I_GCJ:%=%-$(VER).info) : %-$(VER).info : gcc/java/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_GCJ:%=%.html) : %.html : gcc/java/%.texi $(GCCVERS)
	$(MKHTML) -o $@ $<

$(I_GCJ:%=%.pdf) : %.pdf : gcc/java/%.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


$(I_GO:%=%-$(VER).info) : %-$(VER).info : gcc/go/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_GO:%=%.html) : %.html : gcc/go/%.texi $(GCCVERS)
	$(MKHTML) -o $@ $<

$(I_GO:%=%.pdf) : %.pdf : gcc/go/%.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


#
# ADA/GNAT documentation
#

xgnatugn : gcc/ada/xgnatugn.adb
	gnatmake gcc/ada/xgnatugn

gcc/doc/gnat_ugn.texi : gcc/ada/gnat_ugn.texi xgnatugn gcc/doc/projects.texi
	./xgnatugn unw $< gcc/ada/ug_words $@

gcc/doc/projects.texi : gcc/ada/projects.texi xgnatugn
	./xgnatugn unw $< gcc/ada/ug_words $@

gnat_ugn-$(VER).info : gcc/doc/gnat_ugn.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

gnat_ugn.html : gcc/doc/gnat_ugn.texi $(GCCVERS)
	$(MKHTML) -o $@ $<

gnat_ugn.pdf : gcc/doc/gnat_ugn.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


$(I_ADA:%=%-$(VER).info) : %-$(VER).info : gcc/ada/%.texi $(GCCVERS)
	$(MKINFO) -o $@ $<

$(I_ADA:%=%.html) : %.html : gcc/ada/%.texi $(GCCVERS)
	$(MKHTML) -o $@ $<

$(I_ADA:%=%.pdf) : %.pdf : gcc/ada/%.texi $(GCCVERS)
	$(TEXI2PDF) -o $@ $<


#
# Manpages
#

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
	rm -f $(GENFILES) -r build
