//
//  main.m
//  due-reset
//
//  Created by Eric Stobbart on 7/16/13.
//  Copyright (c) 2013 EricStobbart. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <termios.h>
#include <sysexits.h>
#include <sys/ioctl.h>

static struct termios gDeviceTTYAttributes;

int main(int argc, const char * argv[])
{
  if (argc != 2) {
    //TODO(EStobbart):2.0 will detect the devices and prompt the user
    printf( "Usage: %s /dev/tty.usbmodem####\n", argv[0] );
    return EX_USAGE;
  }
  int fd = -1;
  struct termios ttyAttrCopy;
  //Open the device
  fd = open(argv[1],  O_RDWR | O_NOCTTY | O_NDELAY);
  if (fd == -1) {
    printf("Error opening serial port %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    return EX_NOINPUT;
  }
  
  //Exclusive mode (block the other non-admin open calls)
  if (ioctl(fd, TIOCEXCL) == -1) {
    printf("Error setting TIOCEXCL on %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    close(fd);
    return -1;
  }
  
  //Get the settings
  if (tcgetattr(fd, &gDeviceTTYAttributes) == -1) {
    printf("Error getting tty attributes %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    close(fd);
    return -1;
  }
  ttyAttrCopy = gDeviceTTYAttributes;
  //printf("Current Input speed:%li\n", cfgetispeed(&gDeviceTTYAttributes));
  //printf("Current Output speed:%li\n", cfgetospeed(&gDeviceTTYAttributes));
  
  //Add an if for if the current speed is 1200?
  
  //Set the new speed
  cfsetspeed(&ttyAttrCopy, B1200);
  
  //Apply the changes to the device
  if (tcsetattr(fd, TCSANOW, &ttyAttrCopy) == -1) {
    printf("Error setting tty attributes %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    close(fd);
    return -1;
  }
  
  //Clear data terminal ready (we should now have both l/on lit)
  if (ioctl(fd, TIOCCDTR) == -1) {
    printf("Error clearing DTR %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    close(fd);
    return -1;
  }
  
  //Reset back to the original attributes (be kind, please rewind)
  if (tcsetattr(fd, TCSANOW, &gDeviceTTYAttributes) == -1) {
    printf("Error setting tty attributes %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    close(fd);
    return -1;
  }
  
  //Reset exclusive mode
  if (ioctl(fd, TIOCNXCL) == -1) {
    printf("Error setting TIOCNXCL on %s - %s(%d).\n",
           argv[1], strerror(errno), errno);
    close(fd);
    return -1;
  }
  
  close(fd);
  return EXIT_SUCCESS;
}

