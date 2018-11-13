#!/bin/bash
rm -rf log
rm -rf log0

mkdir log
cp log_5image/* log 
cp ./log/run_config ./
./run_multi.sh
rm -rf log
rm -rf log0


mkdir log
cp log_10image/* log
cp ./log/run_config ./
./run_multi.sh
rm -rf log
rm -rf log0
mkdir log
cp log_15image/* log
cp ./log/run_config ./
./run_multi.sh

