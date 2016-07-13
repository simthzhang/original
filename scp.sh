#!/usr/bin/expect -f
set name root
set floatingip 15.15.15.89
set password root
set yesorno yes 
set timeout 10
set file networkshow.sh
set vms_dir /tmp/scalability
cat $vms_dir/serverid_floatingip.log|while read myline
do
echo $myline|awk '{print $4}'

        spawn scp ./$file root@$ip:/tmp
        expect {
            #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            expect "password:"
                send "root\r"
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "root\r"
            }
        }
        expect "*"
        send "exit\r"
        expect eof

done
