#!/bin/bash

date -d "`echo|awk -F "." '{print $1}'|awk -F "_" '{print $2"-"$3"-"$4" "$5":"$6":"$7}'`" +%s

