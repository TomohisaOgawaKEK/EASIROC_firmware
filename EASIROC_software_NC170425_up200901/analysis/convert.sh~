#!/bin/bash

# get the list of input files
#INFILES=`ls ../data/ | grep ${lr} | grep ${subprocess}`
INFILES=`ls ../data/ | grep .dat`

# first check whether there is 1 input file at least
NFILES=0
for infile in $INFILES; do
   echo "${infile}"
   let NFILES=$NFILES+1
   ../cmdtree/tree ../data/${infile}
done
echo "found #files ### ${NFILES} ###"

