#!/bin/bash
sed -i s/node\.session\.cmds\_max\ \=\ 128 

# To control the device's queue depth set node.session.queue_depth
# to a value between 1 and 1024. The default is 32.
node.session.queue_depth = 32

