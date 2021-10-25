#!/bin/bash

processes=(
data200120_pf001_x45.dat
data200120_pf001_x46.dat
data200120_pf100_x00.dat
data200120_pf100_x01.dat
data200120_pf100_x02.dat
data200120_pf100_x03.dat
data200120_pf100_x04.dat
data200120_pf100_x05.dat
data200120_pf100_x06.dat
data200120_pf100_x07.dat
data200120_pf100_x09.dat
data200120_pf100_x10.dat
data200120_pf100_x12.dat
data200120_pf100_x13.dat
data200120_pf100_x14.dat
data200120_pf100_x16.dat
data200120_pf100_x17.dat
data200120_pf100_x18.dat
data200120_pf100_x19.dat
data200120_pf100_x20.dat
data200120_pf100_x21.dat
data200120_pf100_x22.dat
data200120_pf100_x23.dat
data200120_pf100_x24.dat
data200120_pf100_x25.dat
data200120_pf100_x26.dat
data200120_pf100_x27.dat
data200120_pf100_x28.dat
data200120_pf100_x29.dat
data200120_pf100_x30.dat
data200120_pf100_x31.dat
data200120_pf100_x32.dat
data200120_pf100_x33.dat
data200120_pf100_x34.dat
data200120_pf100_x35.dat
data200120_pf100_x36.dat
data200120_pf100_x37.dat
data200120_pf100_x38.dat
data200120_pf100_x39.dat
data200120_pf100_x40.dat
data200120_pf100_x41.dat
data200120_pf100_x42.dat
data200120_pf100_x43.dat
data200120_pf100_x44.dat
data200120_pf100_x45.dat
data200120_pf100_x46.dat
data200120_pf100_x47.dat
data200120_pf100_x48.dat
data200120_pf100_x49.dat
data200120_pf100_x50.dat
data200120_pf100_x51.dat
data200120_pf100_x52.dat
data200120_pf100_x53.dat
data200120_pf100_x54.dat
data200120_pf100_x55.dat
data200120_pf100_x56.dat
data200120_pf100_x57.dat
data200120_pf100_x58.dat
data200120_pf100_x59.dat
data200120_pf100_x60.dat
data200120_pf100_x61.dat
data200120_pf100_x62.dat
data200120_pf100_x63.dat
)
BASE=$PWD

# loop over processes
for process in "${processes[@]}"; do
   echo -e "proc: $process "
   ../cmdtree/tree $process
done

