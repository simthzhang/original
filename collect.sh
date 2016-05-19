#!/bin/bash
array=(200 300 400 500 600 700 800 900 1000)
array=(10 20 30 40 50 60 70 80 90)
change_unit=1048576
size_tocollect=10K
internalcount=0
reset_count=0
#rm -rf ./*.csv
test_index="Failed#requests across#all#concurrent#requests Time#taken#for#tests Total#transferred Requests#per#second Transfer#rate"

function collect()
{
	echo  $1


		for diff_env in `find -name $size_tocollect.log|awk -F "/" '{print $2}'` #diff_env descripte the basic hw sw optimzied env 
			do

				actualcurrency=`grep -w 'Concurrency Level' ./$diff_env/$size_tocollect.log |awk -F " " '{print $3}'`
					actualfailrequest=`grep -w "$1" ./$diff_env/$size_tocollect.log |awk -F ":" '{print $2}'|awk -F " " '{print $1}'`
					test_forreq=($actualfailrequest)
					echo -n $diff_env, >> ./result_$size_tocollect.csv
					for expected_concurrency in "${!array[@]}"; do

						echo $actualcurrency | grep "${array[$expected_concurrency]}" >> temo.log
							if [ "$?" -eq 0 ]
								then





									echo $1|grep "Total" >> temo.log

									if [ "$?" -eq 0 ]
										then
											echo -n $((10#${test_forreq[$internalcount]}/$change_unit))"," >>  ./result_$size_tocollect.csv

										else

										echo -n ${test_forreq[$internalcount]}"," >> ./result_$size_tocollect.csv
											fi

											((internalcount=internalcount+1))
							else
								echo -n "x," >> ./result_$size_tocollect.csv
									((reset_count=reset_count+1))
									fi
									done
									echo -n reset_count is: $reset_count >>result_$size_tocollect.csv
									internalcount=0
									reset_count=0
									echo "" >> ./result_$size_tocollect.csv
									done

}




for single_testindex in $test_index
do
echo $single_testindex |sed 's/#/ /g' >> ./result_$size_tocollect.csv
collect "`echo $single_testindex |sed 's/#/ /g'`"
done




#for i in "${!array[@]}"; do 
#    printf "%s\t%s\n" "$i" "${array[$i]}"
#done


#for NUM in ${array[*]}
#do

#	echo $NUM
#done

