#!/bin/bash
para_to_replace="concurrency tim define_tenant_id define_tenant_name define_user_id define_user_name define_user_password"
#   para_to_replace="concurrency tim define_tenant_id"
	para_tim="100,"
	para_concurrency=1
	para_define_tenant_id="\"b9b3695d8c5b4cfc93120233c37c90dc\","
	para_define_tenant_name="\"scalability\","
	para_define_user_id="\"f939e9a43d8949a5a768aa0da12179b5\","
	para_define_user_name="\"scalability\","
	para_define_user_password="\"123456\""
    flavor_orginal=m1.tiny
    flavor_target=large-scale-100-centos_4G
    test_simth()
    {
        for i in $para_to_replace; do
#            echo $i
            echo  `eval echo '$'para_"$i"`
        done
    }


    delete_serverid()
    {
sed -i 's/\"serverid\_kwargs": {//g' *.json
    }


    modify_flavor()
{
    rm -rf /tmp/flavor
    sed -i 's/m1.tiny/large-scale-100-centos_4G/g' *.json
    sed -i 's/m1.small/large-scale-100-centos_4G/g' *.json
    sed -i 's/m1.medium/large-scale-100-centos_4G/g' *.json

}
modify_image()
{
    sed -i 's/\*//g' *.json
    sed -i 's/\^cirros\.uec\$/root_centos/g' *.json
    sed -i 's//root_centos/g' *.json
}

modify_parameter()
{

	for i in $para_to_replace
		do		

			rm -rf /tmp/tmp.log
				grep -rn $i ./*.json|awk -F ":" '{print $1" " $2}' >> /tmp/tmp.log


#o linenumber is: $linenumber
cat /tmp/tmp.log|while read singleline
do
linenumber=`echo $singleline|awk '{print $2}'`
linefile=`echo $singleline|awk '{print $1}'`
echo  line number is: $linenumber
echo  line file is: $linefile
linecontenttoreplace=`sed -n "$linenumber"p  $linefile`
originalcycle=`echo $linecontenttoreplace|awk '{print $2}'` 
echo $originalcycle
target=`eval echo '$'para_"$i"`
echo target =============$target
sed -i "s/$originalcycle/$target/g" $linefile
#sed -i "s/$linecontenttoreplace/"concurrency:" $targenumber/g" $linefile
#echo singleline $singleline
done
done

}






#test_simth
modify_parameter
modify_flavor
modify_image
