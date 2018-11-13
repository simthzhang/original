#!/bin/bash
removeosd()
{
for((i=8;i<16;i++));do
echo $i
ceph osd out osd.$i
ceph osd stop osd.$i
ceph osd down osd.$i
ceph osd crush remove osd.$i
ceph auth del osd.$i
ceph osd rm osd.$i




done
}
test()
{
ceph osd out osd.32
ceph osd stop osd.
ceph osd down osd.xxx
ceph osd crush remove osd
ceph auth del osd.xxx
ceph osd rm osd.xxx
}
removeosd
