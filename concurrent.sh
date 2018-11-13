#!/bin/bash
for i in {1..4}
do
nohup ssh vm-client$i 'cd /home/simth/; ./run_vdbench.sh ' & 
done
