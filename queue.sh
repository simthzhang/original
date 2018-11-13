
tunning_disk(){
	local dev=$1
	echo -e "Tunning /dev/\e[1;42m$dev\e[0m..."
        # 修改内核的I/O调度程序
        echo noop > /sys/block/$dev/queue/scheduler
        echo /sys/block/$dev/queue/scheduler=`cat /sys/block/$dev/queue/scheduler`

        # 
        echo "0" > /sys/block/$dev/queue/nomerges
        echo /sys/block/$dev/queue/nomerges=`cat /sys/block/$dev/queue/nomerges`

        # 增大队列深度(QD)，从默认的128增加至256或更大
        echo 2048 > /sys/block/$dev/queue/nr_requests
        echo /sys/block/$dev/queue/nr_requests=`cat /sys/block/$dev/queue/nr_requests`

        #echo 1024 > /sys/block/sdf/device/queue_depth
        echo /sys/block/$dev/device/queue_depth=`cat /sys/block/$dev/device/queue_depth`

        # 向操作系统表明使用的是非旋转式设备
        echo 0    > /sys/block/$dev/queue/rotational
        echo /sys/block/$dev/queue/rotational=`cat /sys/block/$dev/queue/rotational`

        # 将器件与8k边界对齐
        #echo “16,,”| sfdisk -uS /dev/sdf

        # （将器件与1M边界对齐）（优先）
        #echo "2048,," | sfdisk -uS /dev/sdf 

	}

tunning_mdisk(){
        local dev=$1
        echo -e "Tunning /dev/\e[1;42m$dev\e[0m..."
        # 修改内核的I/O调度程序
        echo noop > /sys/block/$dev/queue/scheduler
        echo /sys/block/$dev/queue/scheduler=`cat /sys/block/$dev/queue/scheduler`

        # 增大队列深度(QD)，从默认的128增加至256或更大
        echo 2048 > /sys/block/$dev/queue/nr_requests
        echo /sys/block/$dev/queue/nr_requests=`cat /sys/block/$dev/queue/nr_requests`

        #echo 1024 > /sys/block/sdf/device/queue_depth
        #echo /sys/block/$dev/device/queue_depth=`cat /sys/block/$dev/device/queue_depth`

        # 向操作系统表明使用的是非旋转式设备
        echo 0    > /sys/block/$dev/queue/rotational
        echo /sys/block/$dev/queue/rotational=`cat /sys/block/$dev/queue/rotational`

        # 将器件与8k边界对齐
        #echo “16,,”| sfdisk -uS /dev/sdf

        # （将器件与1M边界对齐）（优先）
        #echo "2048,," | sfdisk -uS /dev/sdf 

        }



devlist=`lsscsi | grep -i virtual-disk | awk '{print $6}' | cut -d / -f 3`
for xdev in $devlist ; do tunning_disk $xdev ; done

# devlist="dm-0 dm-1 dm-2" ; for xdev in ${devlist} ; do echo  ==== $xdev ; done
devlist=("dm-3" "dm-4")
for xdev in ${devlist[@]} ; do tunning_mdisk $xdev ; done

for dev in `lsscsi | grep -i virtual-disk | awk '{print $6}'` ; do echo -n "$dev "  ; /usr/lib/udev/scsi_id  -g -u $dev ; done
