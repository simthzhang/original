#!/bin/bash

for diff_env in `find ./ -name *.json`
do
    sed -i 's/\^cirros\.\*uec\$/root_centos/g' $diff_env
    sed -i 's/cirros/root_centos/g' $diff_env
    sed -i 's/cirros\-0\.3\.4\-x86\_64\-disk\.img/CentOS-7-x86_64-logable-root-root.qcow2/g' $diff_env
done

#create-and-delete-secgroups.json:10:                "times": 20,
#boot-from-volume-and-delete.json:17:                "times": 20,
#boot-and-rebuild.json:18:                "times": 20,
#create-and-delete-keypair.json:6:                "times": 20,
#create-and-list-secgroups.json:10:                "times": 20,
#boot-from-volume.json:16:                "times": 20,
#boot-server-attach-created-volume-and-live-migrate.json:19:                "times": 20,
#boot-lock-unlock-and-delete.json:15:                "times": 20,
#boot-and-live-migrate.json:16:                "times": 20,
#boot-and-migrate.json:15:                "times": 20,
#boot-bounce-delete.json:22:                "times": 20,
#boot-server-from-volume-and-live-migrate.json:18:                "times": 20,
#boot-server-attach-created-volume-and-resize.json:24:                "times": 20,
#create-and-update-secgroups.json:9:                "times": 20,
#create-and-list-keypairs.json:6:                "times": 20,
#boot-snapshot-boot-delete.json:16:                "times": 20,
#boot-and-show-server.json:16:                "times": 20,
#boot-from-volume-and-resize.json:24:

