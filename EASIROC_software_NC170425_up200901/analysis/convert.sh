#!/bin/bash

DIR="../data/"
#DIR="../data_store/easiroc200624_farm1_led_temp20_SAMTEC1.0mNo1_Ecable1.0mNo78_UT18/"
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

