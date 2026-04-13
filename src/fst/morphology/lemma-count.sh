#!/bin/bash

# For debugging, uncomment this command:
# set -x

srcdir=$1

lemmacount=$(fgrep '<e lm=' $srcdir/src/fst/morphology/ext-Apertium-spa/apertium-spa.spa.metadix | wc -l)

echo $lemmacount
