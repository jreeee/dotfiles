#! /bin/bash

# get ids
id_dev=$(echo $(xinput list | grep "TouchPad" | grep -oP 'id=\K[0-9]+'))
id_mmb=$(echo $(xinput list-props $id_dev | grep "Middle Emulation Enabled (" | grep -oP '\(\K[0-9]+'))

echo $id_dev $id_mmb
# disable

xinput set-prop $id_dev $id_mmb 1
