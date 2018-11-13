#!/bin/bash
image_size=102400
image_count=9
image_begin=6
image_pool=rbd
for (( i=$image_begin;i<image_count;i++ ));do
    rbd create testimage_100GB_$i --image-format 2 --size ${image_size} --pool $image_pool
    rbd info -p $image_pool --image testimage_100GB_$i
done
