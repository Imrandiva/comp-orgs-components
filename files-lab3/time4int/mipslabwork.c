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
int prime = 1234567;
volatile int* porte_ = (volatile int*) 0xbf886110;
char textstring[] = "text, more text, and even more text!";
int timeoutcount;
/* Interrupt Service Routine */
void user_isr( void )
{
  IFS(0) = 0;
  timeoutcount++;
  if (timeoutcount == 10){
    timeoutcount=0;
    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime );
  }
  
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
  
    IEC(0) = 0x100;
    IPC(2) = 0x1f;
    enable_interrupt();

}


/* This function is called repetitively from the main program */
void labwork( void )
{
  prime = nextprime( prime );
  display_string( 0, itoaconv( prime ) );
  display_update();
  
}
