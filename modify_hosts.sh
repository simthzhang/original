#!/bin/bash

cat /etc/hosts|grep -v '#'|grep $1 1>/dev/null

if (($?==1));then
    echo "$2    $1">>/etc/hosts
else
    cat /etc/hosts|sed 's/^[^#]..*'$1'/'$2'    '$1'/g'>/etc/hosts_
    mv /etc/hosts_ /etc/hosts
fi

