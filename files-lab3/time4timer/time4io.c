#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

//  Get bits 11 to 8 of port d. Shift 8 steps to the right
// and take the 4 lsb
int getsw(void){
    int SW = (PORTD >> 8) & 0xf; 
    return SW;
}

//Get bits 7,6,5 from portd
// Shift 5 steps to the right and take 3 lsb
int getbtns(void){
    int BTN = (PORTD >> 5) & 0x0007; 
    return BTN; 
}