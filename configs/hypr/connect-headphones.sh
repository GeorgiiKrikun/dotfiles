#!/bin/bash
DEVICE=$(bluetoothctl devices | rg '^Device\W(.*)\Wsoundcore\WQ20i$' -r '$1')
[ -n "$DEVICE" ] && bluetoothctl connect "$DEVICE"
