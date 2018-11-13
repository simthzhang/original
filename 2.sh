echo 1 > /sys/class/scsi_disk/42\:0\:0\:1/device/timeout 
echo 1 > /sys/class/scsi_disk/43\:0\:0\:1/device/timeout 
echo 1 > /sys/class/scsi_disk/41\:0\:0\:1/device/timeout 
cat /sys/class/scsi_disk/42\:0\:0\:1/device/timeout 
cat /sys/class/scsi_disk/43\:0\:0\:1/device/timeout 
cat /sys/class/scsi_disk/41\:0\:0\:1/device/timeout
