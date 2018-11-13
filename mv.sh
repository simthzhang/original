#!/bin/bash
cat 1|while read singleline
do
    origi=`echo $singleline|awk '{print $1}'`
    target=`echo $singleline|awk '{print $2}'`
    mv ./log/$origi ./log/$target

done
