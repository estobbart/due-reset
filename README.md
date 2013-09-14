due-reset
=========

Command-line tool to reset an Arduino Due board for OS X.

Setup:
------------
Using XCode for Atmel development on an Arduino Due with the Atmel Software Framework (asf).

Tools:
------------
Download the ASF from Atmel (you'll need to create a login if you don't already have one).

[http://asf.atmel.com](http://asf.atmel.com)

Download the ARM compiler that's distributed with the Arduino source. (see build/build.xml for details)

[http://arduino.googlecode.com/files/gcc-arm-none-eabi-4.4.1-2010q1-188-macos.tar.gz](http://arduino.googlecode.com/files/gcc-arm-none-eabi-4.4.1-2010q1-188-macos.tar.gz)

Copy `bossac` from `build/macosx/dist/bossac` in the Arduino source.
[http://arduino.cc/en/Main/ArduinoBoardDue](http://arduino.cc/en/Main/ArduinoBoardDue) (see programming for details)


Solution:
------------

Before using `bossac` with an Arduino Due you must first issue a reset.

[http://arduino.cc/en/Guide/ArduinoDue#toc4](http://arduino.cc/en/Guide/ArduinoDue#toc4)

If you don't issue a reset first you'll get the following error from bossac:

	No device found on tty.usbmodem

Now you can write an install script to run after your Makefile from XCode.

	#!/bin/bash
	./due-reset /dev/tty.usbmodem####
	./bossac --port=tty.usbmodem#### -U false -e -w -v -b [MyApp].bin -R