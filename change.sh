#!/bin/bash
sed -i 's/ioengine\=rbd/ioengine\=libaio/g' *.config
sed -i 's/clientname=admin//g' *.config
sed -i 's/pool=rbd//g' *.config
sed -i 's/rbdname/filename/g' *.config
sed -i 's/rbd_image/device/g' *.config
sed -i 's/testimage_100GB_0/\/dev\/sdb/g' *.config
sed -i 's/testimage_100GB_1/\/dev\/sdc/g' *.config
sed -i 's/testimage_100GB_2/\/dev\/sdb/g' *.config
sed -i 's/testimage_100GB_3/\/dev\/sdc/g' *.config
sed -i 's/testimage_100GB_4/\/dev\/sdb/g' *.config
sed -i 's/testimage_100GB_5/\/dev\/sdc/g' *.config
