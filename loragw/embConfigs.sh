
#    ______           _     _ _   
#	|  ____|         | |   (_) |  
#	| |__   _ __ ___ | |__  _| |_ 
#	|  __| | '_ ` _ \| '_ \| | __|
#	| |____| | | | | | |_) | | |_ 
#	|______|_| |_| |_|_.__/|_|\__|        
# 

#
# Default configs
#
# FPGA
RESET_FPGA=0
RELEASE_FPGA=1
# LORA
RESET_LORA=1
RELEASE_LORA=0
# GPS
RESET_GPS=0
RELEASE_GPS=1
# ON OFF
POWER_ON=1
POWER_OFF=0
ON=$POWER_ON
OFF=$POWER_OFF
# ON OFF
DIR="out"
# PIN Configs
POWER_ON_PIN=17
FPGA_RESET_PIN=23
LORA1301_RESET_PIN=4
GPS_RESET_PIN=18
SLEEP_TIME=0.5
BOARD_ON_DELAY=10
LED2_PIN=27
LED1_PIN=22
#
# SPIs pin configs
#
SPI_HOST_MISO=9
SPI_HOST_MOSI=10
SPI_HOST_CLK=11
SPI_HOST_CN=8
# Programming
SPI_PROG_MISO=19
SPI_PROG_MOSI=20
SPI_PROG_CLK=21
SPI_PROG_CN=16
#
# Fan configs
#
# Info: FAN_PIN=13
FAN_PWM_PATH="/sys/class/pwm/pwmchip0"
FAN_PERIOD=10000
FAN_DUTY_CYCLE=1500
#
if [ -z "$EMBFOLDER" ]; then
	EMBFOLDER="/etc/embit"
fi


## 
## Init GPIO
ioInit()
{

	# check if the IO are already initialized
	if [ ! -d /sys/class/gpio/gpio$POWER_ON_PIN ]; then
		
		echo "     -Init GPIO" >&2;
		
		if [ ! -d /sys/class/gpio/gpio$POWER_ON_PIN ]; then
			echo $POWER_ON_PIN > /sys/class/gpio/export
		fi
		echo $DIR > /sys/class/gpio/gpio$POWER_ON_PIN/direction

		if [ ! -d /sys/class/gpio/gpio$LORA1301_RESET_PIN ]; then
			echo $LORA1301_RESET_PIN > /sys/class/gpio/export
		fi
		echo $DIR > /sys/class/gpio/gpio$LORA1301_RESET_PIN/direction

		if [ ! -d /sys/class/gpio/gpio$FPGA_RESET_PIN ]; then
			echo $FPGA_RESET_PIN > /sys/class/gpio/export
		fi
		# set as input, resetLoRaModule reset the FPGA too
		echo in > /sys/class/gpio/gpio$FPGA_RESET_PIN/direction

		if [ ! -d /sys/class/gpio/gpio$GPS_RESET_PIN ]; then
			echo $GPS_RESET_PIN > /sys/class/gpio/export
		fi
		echo $DIR > /sys/class/gpio/gpio$GPS_RESET_PIN/direction

		if [ ! -d /sys/class/gpio/gpio$LED1_PIN ]; then
			echo $LED1_PIN > /sys/class/gpio/export
		fi
		echo $DIR > /sys/class/gpio/gpio$LED1_PIN/direction

		if [ ! -d /sys/class/gpio/gpio$LED2_PIN ]; then
			echo $LED2_PIN > /sys/class/gpio/export
		fi
		echo $DIR > /sys/class/gpio/gpio$LED2_PIN/direction
	fi
}
## 
## Board on and off

	## 
	## Power ON
	boardON()
	{
		echo "     -POWER ON" >&2;
		echo $POWER_ON > /sys/class/gpio/gpio$POWER_ON_PIN/value
	}

	## 
	## Power OFF
	boardOFF()
	{
		echo "     -POWER OFF" >&2;
		echo $POWER_OFF > /sys/class/gpio/gpio$POWER_ON_PIN/value
	}
## 
## Board reset devices
	## 
	## Reset sx1301
	resetLoRaModule()
	{
		echo "     -RESET RF MODULE" >&2;
		echo $RESET_LORA > /sys/class/gpio/gpio$LORA1301_RESET_PIN/value
	}
	## 
	## Reset U-BLOX GPS module
	resetGPSModule()
	{
		echo "     -RESET GPS MODULE" >&2;
		echo $RESET_GPS > /sys/class/gpio/gpio$GPS_RESET_PIN/value
	}
## 
## Board release devices
	## 
	## Release sx1301
	releaseLoRaModule()
	{
		echo "     -RELEASE RF MODULE" >&2;
		echo $RELEASE_LORA > /sys/class/gpio/gpio$LORA1301_RESET_PIN/value
	}
	## 
	## Release U-BLOX GPS module
	releaseGPSModule()
	{
		echo "     -RELEASE GPS MODULE" >&2;
		echo $RELEASE_GPS > /sys/class/gpio/gpio$GPS_RESET_PIN/value
	}
## 
## Leds
	## 
	## led 1 on
	led_1_ON()
	{
		echo $ON > /sys/class/gpio/gpio$LED1_PIN/value	
	}
	## 
	## led 1 off
	led_1_OFF()
	{
		echo $OFF > /sys/class/gpio/gpio$LED1_PIN/value	
	}
	## 
	## led 1 toggle
	led_1_toggle()
	{
		read led1Value < /sys/class/gpio/gpio$LED1_PIN/value
		echo $(( ! led1Value )) > /sys/class/gpio/gpio$LED1_PIN/value
	}
	## 
	## led 2 on
	led_2_ON()
	{
		echo $ON > /sys/class/gpio/gpio$LED2_PIN/value	
	}
	## 
	## led 2 off
	led_2_OFF()
	{
		echo $OFF > /sys/class/gpio/gpio$LED2_PIN/value	
	}
	## 
	## led 2 toggle
	led_2_toggle()
	{
		read led2Value < /sys/class/gpio/gpio$LED2_PIN/value
		echo $(( ! led2Value )) > /sys/class/gpio/gpio$LED2_PIN/value
	}
## 
## FAN
	## 
	## init pwm pin
	fanInit()
	{
		if [ ! -d $FAN_PWM_PATH/pwm1 ]; then
			echo 1 > $FAN_PWM_PATH/export 					#export pwm pin 1
			echo $FAN_PERIOD > $FAN_PWM_PATH/pwm1/period 	#set period
			echo $FAN_DUTY_CYCLE > $FAN_PWM_PATH/pwm1/duty_cycle #set duty_cycle to 15%
		fi
	}
	## 
	## enable
	fanEnalbe()
	{
		fanInit
		echo "     -FAN ON" >&2;
		echo 1 > $FAN_PWM_PATH/pwm1/enable #enable pwm
	}
	## 
	## disable
	fanDisable()
	{
		fanInit
		echo "     -FAN OFF" >&2;
		echo 0 > $FAN_PWM_PATH/pwm1/enable #disable pwm
	}
## 
## reset LoRa Board
	resetBoard()
	{
		ioInit
		sleep $SLEEP_TIME
		resetLoRaModule
		resetGPSModule
		sleep $SLEEP_TIME
		boardOFF
		sleep $SLEEP_TIME
		boardON
		sleep $SLEEP_TIME
		releaseLoRaModule
		releaseGPSModule
		
		#
		# wait for rf board initialization
		led_1_ON
		led_2_OFF
		i=0
		while [ $((i+=1)) -le $BOARD_ON_DELAY  ]
		do
			led_1_toggle; led_2_toggle; sleep $SLEEP_TIME
			
		done
		# #
		led_1_ON
		led_2_OFF	
	}
## 
## print board EUI 
	getBoardEUI()
	{
		ioInit > /dev/null
		boardON > /dev/null
		IEEE=$( $EMBFOLDER/embReadInfo | grep DEVICEIEEE | cut -d " " -f 3)
		echo $IEEE
	}
## 
## print board serial number 
	getBoardSerialNumber()
	{
		ioInit > /dev/null
		boardON > /dev/null
		SN=$( $EMBFOLDER/embReadInfo | grep SERIALNUMBER | cut -d " " -f 3)
		echo $SN
	}
## 
## print device id
	getBoardId()
	{
		ioInit > /dev/null
		boardON > /dev/null
		ID=$( $EMBFOLDER/embReadInfo | grep DEVICEID | cut -d " " -f 3)
		echo $ID
	}
## 
## print JWT
	getJWT()
	{
		ioInit > /dev/null
		boardON > /dev/null
		JWT=$( $EMBFOLDER/arduinoAskInfo -t | grep JWT | cut -d " " -f 3)
		echo $JWT
	}
## 
## Arduino web service -> ask info
	arduinoAskInfo()
	{
		ioInit > /dev/null
		boardON > /dev/null
		ASKINFO_RESPONSE=$( $EMBFOLDER/arduinoAskInfo -p)
		echo "$ASKINFO_RESPONSE" | grep "OK!\|ERROR"
	}
## 
## Setup LoRa board for packet forwarder
	pktForwarderSetup()
	{
		resetBoard
		fanEnalbe
	}
	
