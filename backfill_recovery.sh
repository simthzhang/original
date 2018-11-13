#!/bin/bash
old()
{
ceph_node=(10.120.5.1 10.120.5.2 10.120.5.3 10.120.5.4 10.120.5.5 10.120.5.6 10.120.5.7 10.120.5.8 10.120.5.9 10.120.5.10 10.120.5.11 10.120.5.12 10.120.5.13 10.120.5.14 10.120.5.15 10.120.5.16 10.120.5.17 10.120.5.18 10.120.5.19 10.120.5.20)

  for i in "${!ceph_node[@]}";do
      osd_id=`ssh  ${ceph_node[$i]} ls /var/run/ceph/ |grep ceph-osd`
      for j in $osd_id; do
          echo osd number: $j in ${ceph_node[$i]}
          ssh ${ceph_node[$i]} ceph --admin-daemon /var/run/ceph/$j config show |grep -E "osd_recovery_max_active|osd_max_backfills"
      done
  done
}


check_back_recory()
{
    rm templog
    test_simth=`cat osds`
    for singleline in $test_simth
    do
        nodes=`echo $singleline|awk -F "_" '{print $1}'`
        osd=`echo $singleline|awk -F "_" '{print $2}'`
        state=`ssh $nodes ceph --admin-daemon /var/run/ceph/ceph-${osd}.asok config show |grep -E "osd_recovery_max_active|osd_max_backfills"`
        echo $nodes $osd $state >> templog
    done
    cat templog|grep "osd_recovery_max_active"|grep \"1\"|wc
}

check_back_recory
