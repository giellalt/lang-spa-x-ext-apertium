###############################################################################
## Makefile for apertium-spa
###############################################################################

LANG1=spa
BASENAME=apertium-$(LANG1)

TARGETS_COMMON =			\
	$(LANG1).automorf.bin		\
	$(LANG1).automorf.att.gz	\
	$(LANG1).autogen.bin		\
	$(LANG1).autogen.att.gz		\
	$(LANG1).autopgen.bin		\
	$(LANG1).rlx.bin		\
	$(LANG1).lrx.bin

# Use this goal for creating .deps, otherwise make -j2 will give problems:
@ap_include@

###############################################################################
## Spanish transducer
###############################################################################

.deps/$(BASENAME).$(LANG1).dix: $(BASENAME).$(LANG1).metadix .deps/.d
	python3 convert-metadix-dix.py $< $@ 
	apertium-validate-dictionary $@

$(LANG1).autogen.bin: .deps/$(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(LANG1).automorf.bin: .deps/$(BASENAME).$(LANG1).dix $(BASENAME).$(LANG1).acx
	apertium-validate-dictionary $<
	lt-comp lr .deps/$(BASENAME).$(LANG1).dix $@ $(BASENAME).$(LANG1).acx

$(LANG1).autogen.att.gz: $(LANG1).autogen.bin
	lt-print $< | gzip -9 -c -n > $@

$(LANG1).automorf.att.gz: $(LANG1).automorf.bin
	lt-print $< | gzip -9 -c -n > $@

$(LANG1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp lr $< $@

###############################################################################
## Morph disambiguation rules
###############################################################################

$(LANG1).lrx.bin: $(BASENAME).$(LANG1).lrx
	lrx-comp $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx
	cg-comp $< $@

###############################################################################
## Distribution
###############################################################################
EXTRA_DIST=$(BASENAME).$(LANG1).metadix		\
	   $(BASENAME).post-$(LANG1).dix	\
	   $(BASENAME).$(LANG1).acx		\
	   $(BASENAME).$(LANG1).rlx		\
	   $(BASENAME).$(LANG1).lrx		\
           $(LANG1).prob			\
	   modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_spa_dir: This is where the compiled binaries go
#   apertium_spa_srcdir: This is where the source files go

apertium_spadir=$(prefix)/share/apertium/$(BASENAME)/
apertium_spa_srcdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_spa_DATA=$(TARGETS_COMMON) \
	$(LANG1).prob \
	$(BASENAME).$(LANG1).acx \
	$(BASENAME).$(LANG1).metadix \
	$(BASENAME).$(LANG1).rlx

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	apertium-regtest test
