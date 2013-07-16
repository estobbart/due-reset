due-reset
=========

Command-line tool to reset an Arduino Due board for OS X.

Setup:
------------

I chose to use XCode as my IDE for Arduino Due Developement with the Atmel Software Framework (asf)

http://asf.atmel.com

To do this I had to setup the following.

I also use the ARM compiler that is distributed with the Arduino source.
build/build.xml

http://arduino.googlecode.com/files/gcc-arm-none-eabi-4.4.1-2010q1-188-macos.tar.gz

I'm using bossac as descirbed in the Arudino docs.

build/macosx/dist/bossac

http://arduino.cc/en/Main/ArduinoBoardDue (see programming)

Solution:
------------

Before using bossac with an Arduino Due you must first issue a reset.

http://arduino.cc/en/Guide/ArduinoDue#toc4

If you don't issue a reset first you'll get the following error from bossac:
	No device found on tty.usbmodem

Now you can write an install script to run after your Makefile from XCode.
	#!/bin/bash
	./due-reset /dev/tty.usbmodem####
	./bossac --port=tty.usbmodem#### -U false -e -w -v -b [MyApp].bin -R
