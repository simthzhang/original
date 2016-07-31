#!/bin/bash

list_case()
{
    rm -rf ./rally_case
    ls -l |grep thinkstack|awk '{print $9}' >> rally_case
}

run_case()
{
cat rally_case|while read myline
do
echo ++++++++++++++++
    rally task start  ./$myline |tee simth.log
    sleep 1
done

}



list_case
run_case
