Configuring Stemtech's packet_forwarder protocol on modern distributions of the Raspberry OS for the Arduino Pro Gateway:

Software used:
- Raspberry OS Bookworm (tested on the linked version): https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/
- Packet forwarder: https://github.com/Lora-net/packet_forwarder.git
- Gateway HAL: https://github.com/Lora-net/lora_gateway.git 

# Configuration

First thing, add the following lines to `/boot/config.txt`:

```
# Arduino Pro Gateway SPI, PWM fan control, etc.
dtparam=i2c_arm=on
dtparam=i2s=on
dtparam=spi=on
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

The file `/etc/embit/embConfigs.sh` need to be installed manually.
Useful functions and info on the GPIO pins can be sourced therein. 

Clone both the repositories indicated on the top of the page into `/home/pi` or your custom home directory. 
Build the executable by running `./compile.sh` inside the `packet_forwarder/` directory.

Setup .conf files in `~/packet_forwarder/lora_pkt_fwd` according to the readme.
Notes: 
- the EMB-LR1301-mPCIe chip should be PCB_E336 as the datasheet includes a FPGA. Fetch the right basic `global_conf` from the `~/packet_forwarder/lora_pkt_fwd/cfg/` directory
- a gateway Id can be automaticaly generated and written in local.conf via `~/packet_forwarder/lora_pkt_fwd/update_gwid.sh`

Copy `start.sh` into `home/pi` or your custom home directory.
The packet_forwarder can now be run with `sudo ./start.sh`.
Sometimes the concentrator fails to start, so the execution is looped until it does.

# Automatic start

The file `lora_pkt_fwd.service` is provided to automatically run the executable at startup.
It may need to be edited accordingly if you used a custom home directory installation.
Copy it in the `/etc/systemd/system/` directory and run 
```
sudo systemctl enable lora_pkt_fwd.service && \
sudo systemctl start lora_pkt_fwd.service
```
to install and run the service on your system.

# More info

The previous and following knowledge was derived from reverse-enginnering the linux .iso provided for the Arduino Pro Gateway at:
- https://support.arduino.cc/hc/en-us/articles/4409774456082-Create-a-bootable-microSD-card-for-Arduino-Pro-Gateway 
- (direct download link) https://downloads.arduino.cc/arduino_pro_gateway_for_lora/prod/sd_kit_image_releases/v1.1.0/20190206PROD_ArduinoProGateway_SD.zip

The original .iso was running a very outdated version of Raspbian (now Raspberry OS) and was set up to execute the Arduino Connector LoRa forwarding protocol for The Things Network.
This was done through a system service monitoring the commissioning state of the gateway from the Arduino website.
The file-system was mounted in read-only mode, so the first step was to modify the mountpoint in /etc/fstab to rw, and only after reboot the service could be permanently disabled via systemctl disable.
Most tools (as embits scripts to reset the board) were installed in the /opt/ directory.
