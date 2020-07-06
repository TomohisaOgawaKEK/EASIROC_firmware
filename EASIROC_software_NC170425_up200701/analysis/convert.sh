#!/bin/bash

DIR="../data/"
#DIR="../data_calib/"
#DIR="../data_store/data200628_farm8_calibTrigDelay_UT18/"
#DIR="../data_store/data200628_farm8_calibFQADC_UT18/"
# get the list of input files
#INFILES=`ls ../data/ | grep ${lr} | grep ${subprocess}`
#INFILES=`ls ../data/ | grep .dat`
INFILES=`ls ${DIR} | grep .dat`

# first check whether there is 1 input file at least
NFILES=0
for infile in $INFILES; do
   echo "${infile}"
   let NFILES=$NFILES+1
   ../cmdtree/tree ${DIR}/${infile}
done
echo "found #files ### ${NFILES} ###"

