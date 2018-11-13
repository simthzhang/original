#!/bin/bash
rm -rf *.file
total_device_count=21
file_num=1
file_name="0.file "
for ((i=0;i<$total_device_count;i++));do echo device$i;./pre_multiclient.sh $i $i.file;done
for ((i=file_num;i<$total_device_count;i++))
    do 
    file_name="$file_name ${file_num}.file"    
    file_num=`expr ${file_num} + 1`
    done
    echo $file_name 
paste -d "," $file_name


# paste -d "," 0.file	1.file	2.file	3.file	4.file	5.file	6.file	7.file	8.file	9.file	10.file	11.file	12.file	13.file	14.file	15.file	16.file	17.file	18.file	19.file	20.file	21.file	22.file	23.file	24.file	25.file	26.file	27.file	28.file	29.file	30.file	31.file	32.file	33.file	34.file	35.file	36.file	37.file	38.file	39.file	40.file	41.file	42.file	43.file	44.file	45.file	46.file	47.file	48.file	49.file

