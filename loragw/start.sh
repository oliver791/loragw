#!/bin/sh

if [ -z "$PKT_FWD_PATH" ]; then
	PKT_FWD_PATH="/home/pi/packet_forwarder"
fi

if [ ! -e $PKT_FWD_PATH/lora_pkt_fwd/lora_pkt_fwd ]; then
	echo 'executable not found (please set $PKT_FWD_PATH to the cloned packet_forwarder repo or run .$PKT_FWD_PATH/compile.sh to build the executable)' >&2
	exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

# Prepare board
. /etc/embit/embConfigs.sh
pktForwarderSetup

# Run executable in dir to load conf
cd $PKT_FWD_PATH/lora_pkt_fwd
./lora_pkt_fwd
while [ $? -ne 0 ]; do
	pkill lora_pkt_fwd
	sleep 1
    	./lora_pkt_fwd
done
