## Process this file with automake to produce Makefile.in

## Copyright (C) 2011 Samediggi

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

# build before test
SUBDIRS=. test

# Add language-specific flags for hfst-lexc compilation here:
if HAVE_SHARED_COMMON
HFST_LEXC_LOCAL_FLAGS=  # --Werror # uncomment if lexc is good enough
else
HFST_LEXC_LOCAL_FLAGS=  # No --Werror if deps are missing !
endif


####### Morphology source file defs: ########

# Set this to name of lexc file containing Multichar_Symbols and LEXICON Root
GT_LEXC_ROOT=root.lexc

# Set this to the names of all regular lexc source files:
GT_LEXC_SRCS_L1_L2=

# If you are building an error-detecting L2 analyser, specify the lexc files
# that differ between the regular L1 and the L2 analysers below, in L1 and
# L2 respectively. L2 files must end in "*-L2.lexc". See SME for an example.
L1=

L2=

GT_LEXC_SRCS=\
			$(GT_LEXC_SRCS_L1_L2) \
			$(L1)

GT_LEXC_L2_SRCS=\
			$(GT_LEXC_SRCS_L1_L2) \
			$(L2)

# Set this to the names of all generated lexc files, if any
GENERATED_LEXC_SRCS=generated_files/mul-$(GLANG)-punctuation.lexc \
                    generated_files/mul-$(GLANG)-symbols.lexc

# change handling of shared lexical data here:
if HAVE_SHARED_COMMON
.generated/url.tmp.lexc: $(gt_SHARED_common)/src/fst/url.lexc
	$(MAKE) $(GENDIR)
	$(AM_V_CP)cp -f $< $@

generated_files/mul-$(GLANG)-%.lexc: $(gt_SHARED_common)/src/fst/stems/%.lexc
	$(AM_V_at)$(MKDIR_P) generated_files
	$(AM_V_CP)cp -f $< $@
else
# this is "safe" fallback (compiles but you miss everything)
.generated/url.tmp.lexc:
	echo "LEXICON Root" > $@
	echo "< h t t p (s) %: %/ %/ ?*> # ;" >> $@

.generated/mul-$(GLANG)-%.lexc:
	$(MAKE) $(GENDIR)
	echo "! Missing shared common data" > $@
endif
# add other lexical shared data handling here

# Set this to the names of all source xml files, if any
GT_XML_SRCS=

# Define any additional lexc sources here (compiled on their own):
GT_LOCAL_SRCS=

# Define local xfscripts here:
GT_LOCAL_XFSCRIPT_SRCS=

# Define here any additional sources just included in the distro:
GT_DISTRO_SRCS=

### BEGIN: Local processing: ###

### List additional targets in the following variable, for build targets not
### covered by other means. This comes ***in addition to*** what you can do by
### just targeting lexicon.*: lexicon.tmp.*, and is useful if you want to build
### separate fst's that need further treatment in the src/ dir. See the language
### gle/ for an example of how this is used.

GIELLA_LOCAL_TARGETS=

HFST_REGEXP2FST_FLAGS=--xerox-composition=true

TAG_EXTRACTION_FST=$(builddir)/lexicon.tmp
TAG_EXTRACTION_TTS_FST=$(builddir)/lexicon.tmp
TAG_FILE=tags.txt
LEX_TAG_FILE=lexicon-$(TAG_FILE)

$(srcdir)/ext-Apertium-$(GLANG)/configure: \
        $(srcdir)/ext-Apertium-$(GLANG)/configure.ac
	$(AM_V_GEN)cd $(dir $@ ) && ./autogen.sh

$(srcdir)/ext-Apertium-$(GLANG)/$(GLANG).automorf.att.gz: $(GT_LEXC_ROOT) \
        $(srcdir)/ext-Apertium-$(GLANG)/configure
	$(AM_V_GEN)cd $(dir $@ ) && $(MAKE) $(notdir $@ )

.generated/lexicon.tmp.hfst: $(srcdir)/ext-Apertium-$(GLANG)/$(GLANG).automorf.att.gz \
		$(GENDIR)
	$(AM_V_TXT2FST)gunzip --stdout $< \
		| sed -e "s/ /\'@_SPACE_@\'/g" \
		| $(HFST_TXT2FST) $(MORE_VERBOSITY) $(HFST_FORMAT) --epsilon=ε \
		| $(HFST_INVERT) $(MORE_VERBOSITY) \
		-o $@

.generated/lexicon-tags.txt: .generated/lexicon-sigma.txt
	$(AM_V_GEN)grep '<.*>' $< > $@

# To produce init uppercase tags, use this (the \u is the crucial part):
# 		| perl -pe 's/^(.)/+\u$$1/'
.generated/lexicon-tags.relabel: .generated/lexicon-tags.txt Makefile
	$(AM_V_GEN)sed -e 's/<//' -e 's/>//' $< \
		| perl -pe 's/^(.)/+\u$$1/' \
		| paste $< - > $@

.generated/spa-apertium-gt.relabel: spa-apertium-gt.csv $(GENDIR)
	$(AM_V_GEN)cut -f1-2 < $< > $@

#lexicon-relabel.regex: lexicon-tags.txt
#	$(AM_V_GEN)sed -e 's/<//' -e 's/>//' $< \
#		| perl -pe 's/^(.)(.*)/"+\u$$1$$2"\t<-/' \
#		| paste - $< \
#		| perl -pe 's/<-\t/<-\t"/' \
#		| sed -e 's/$$/",/' \
#		| sed '$$ s/,/;/' \
#		> $@

# Relabel analyser tags from Apertium style to GiellaLT style:
.generated/lexicon.hfst: .generated/lexicon.tmp.hfst .generated/lexicon-tags.relabel
	$(AM_V_HSUBST)$(HFST_SUBSTITUTE) $(MORE_VERBOSITY) $(HFSTFLAGS) \
		-i $< --from-file=.generated/lexicon-tags.relabel -o $@

#lexicon.hfst lexicon.foma: \
#lexicon.%: lexicon.tmp.% lexicon-relabel.%
#	$(AM_V_XFST_TOOL)$(PRINTF) "read regex \
#				@\"lexicon-relabel.$*\"    \
#			.o. @\"$<\" \
#			; \n\
#		save stack $@\n\
#		quit\n" | $(XFST_TOOL)

# Commented out till there is time to look at this:
#lexicon.foma: ext-Apertium-$(GLANG)/$(GLANG).automorf.att.gz
#	$(AM_V_GEN)gunzip --force $<
#	$(AM_V_CP)cp -f $< $@


### END: Local processing: ###

####### Other targets: ###########
# Clean: add local clean targets on separate lines, so that the first line can
# easily get updates from the template dir through svn merge.

include $(srcdir)/Makefile.modifications-local.am
include $(srcdir)/Makefile.modifications-phon.am
include $(top_srcdir)/../giella-core/am-shared/src-morphology-dir-include.am

# vim: set ft=automake:
include $(top_srcdir)/../giella-core/am-shared/devtest-include.am
