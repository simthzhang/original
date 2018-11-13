#!/bin/bash
/home/simth/filterdevice.sh 1 128 32
ssh client222 /home/simth/filterdevice.sh 1 128 32
ssh client223 /home/simth/filterdevice.sh 1 128 32
./rbd.sh
cat /home/simth/log*/vdb*/err*

