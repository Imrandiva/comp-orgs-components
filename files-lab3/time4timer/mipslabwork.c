/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */
#include <stdio.h>

int mytime = 0x5957;
volatile int* porte_ = (volatile int*) 0xbf886110;
char textstring[] = "text, more text, and even more text!";
int timeoutcount;
/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  TMR2 = 0; //Clear TMR2
  volatile int* trise_ = (volatile int*) 0xbf886100;
  *trise_ &= ~0xff;    //setting bits 7 to 0 of port E as output
  *porte_ = 0;       //Initialize value of port E to 0
  TRISD |= 0xfe0; // Set bits 11 to 5 of port D as input
  timeoutcount = 0; // timeoutcount to 0
  T2CON = 0x70;// Timer Input Clock Prescale Select bits 111 for 1:256 
  T2CONSET = 0x8000;// bit 15 should be 1 to set timer ON
  PR2 = (80000000 * 0.1)/ 256; //(ck_freq * periodms)/scale gives compile-time constant for our period;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  int SWS = getsw();
  int BTNS = getbtns();
   if (BTNS & 4){ // 4=0100, checks if byte 2 is 1, aka btn 4 pressed
    mytime &= ~0xf000;
    mytime |= (SWS << 12);
  }
     mytime &= ~0xf000;
    mytime |= (SWS << 12);
   if (BTNS & 2){ // 2=0010, checks if byte 1 is 1, aka btn 3  pressed
    mytime &= ~0x0f00;
    mytime |= (SWS << 8);
  }
   if (BTNS & 1){ // 1=0001, checks if lsb is 1, aka btn 2 pressed
    mytime &= ~0x00f0;
    mytime |= (SWS << 4);
  }
  //delay( 1000 );
  if (IFS(0) & 0x100){ // bit 8 of IFS0 determines event flag. Check if 1.
    timeoutcount++;
    IFS(0) = 0;//Reset all event flags
    if (timeoutcount==10){
    time2string( textstring, mytime );
    display_string( 3, textstring );
   
    display_update();
    tick( &mytime );
    (*porte_)++; // Increment port E when tick is called to increase binary value
    timeoutcount = 0;
    
    }
     display_image(96, icon);
  }
  
}
