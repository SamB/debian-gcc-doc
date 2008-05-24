I_DOC = gcc gccint cpp cppinternals
I_FORTRAN = gfortran
I_TREELANG = treelang
I_ADA = gnat-style gnat_rm gnat_ugn
I_GCJ = gcj
I = $(I_DOC) $(I_FORTRAN) $(I_TREELANG) $(I_ADA) $(I_GCJ)
INFODOCS = $(I:%=%-$(VER).info) gccinstall-$(VER).info
HTMLDOCS = $(I:%=%.html)

GCJ_M1 = gcj gij jcf-dump jv-convert grmic gcj-dbtool gc-analyse
M1 = gcc gcov cpp gfortran $(GCJ_M1)
M = $(M1)
MANS = $(M:%=%-$(VER).1)
PODS = $(M:%=%.pod)

VER = 4.1
FULLVER = 4.1.2

TARGETS = $(INFODOCS) $(HTMLDOCS) $(MANS)
GENFILES = $(TARGETS) gcc-vers.texi $(PODS)

MKINFO_DEFINES := -D "fncpp cpp-$(VER)" \
		  -D "fncppint cppinternals-$(VER)" \
		  -D "fngcc gcc-$(VER)" \
		  -D "fngccint gccint-$(VER)" \
		  -D "fngccinstall gccinstall-$(VER)" \
		  -D "fngcj gcj-$(VER)" \
		  -D "fngfortran gfortran-$(VER)" \
		  -D "fntreelang treelang-$(VER)"
MKINFO = makeinfo $(MKINFO_DEFINES)

all : $(TARGETS)

$(I_DOC:%=%-$(VER).info) : %-$(VER).info : doc/%.texi gcc-vers.texi
	$(MKINFO) --no-split -Idoc -Idoc/include -o $@ $<

gccinstall-$(VER).info : doc/install.texi gcc-vers.texi
	$(MKINFO) -Idoc/include -o $@ $<

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

$(I_GCJ:%=%-$(VER).info) : %-$(VER).info : java/%.texi gcc-vers.texi
	$(MKINFO) --no-split -Idoc -Idoc/include -o $@ $<

$(I_GCJ:%=%.html) : %.html : java/%.texi gcc-vers.texi
	$(MKINFO) --html --no-split -Idoc -Idoc/include -o $@ $<

%-$(VER).1 : %.pod
	pod2man --center="GNU" --release="gcc-$(FULLVER)" --section=1 $< > $@

gcc.pod : doc/invoke.texi gcc-vers.texi
	(cd doc && perl ../texi2pod.pl -Dfngccint=gccint-$(VER)) < $< > $@

gcov.pod : doc/gcov.texi gcc-vers.texi
	(cd doc && perl ../texi2pod.pl) < $< > $@

cpp.pod : doc/cpp.texi gcc-vers.texi
	(cd doc && perl ../texi2pod.pl) < $< > $@

gfortran.pod: fortran/invoke.texi gcc-vers.texi
	(cd fortran && perl ../texi2pod.pl) < $< > $@

$(GCJ_M1:%=%.pod) : %.pod : java/gcj.texi gcc-vers.texi
	(cd java && perl ../texi2pod.pl -D$(@:%.pod=%)) < $< > $@

gcc-vers.texi :
	(echo @set version-GCC $(FULLVER); echo @clear DEVELOPMENT) > $@

clean:
	rm -f $(GENFILES)
