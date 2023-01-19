//
//  sieves.c
//
//
//  Created by Clara Cyon on 2021-09-20.
//

//#include "sieves2.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define COLUMNS 6

int printed_col = 0;

void print_number(int n){
    printf("%10d ", n);
    printed_col += 1;
    if (printed_col == COLUMNS) {
        printf("\n");
        printed_col = 0;
    }
}

void print_sieves(int max){
    char *numbers = malloc(sizeof(char)*max);
    
    for (int n = 0; n < max; n++) {
        numbers[n] = 1;
    }
    
    for (int i = 2; i < sqrt(max); i++) {           //for i = 2, 3, 4, ..., not exceeding √n
        if (numbers[i] == 1){                       //if numbers[i] is true
            for (int j = i*i; j < max; j += i) {    //for j = i^2, i^2+i, i^2+2i, i^2+3i, ..., not exceeding n
                numbers[j] = 0;                     //set numbers[j] to false
            }
        }
    }
    
    for (int k = 2; k < max; k++) {     //if numbers(k) == 1, print k
        if (numbers[k] == 1){
            print_number(k);
        }
    }
    printf("\n");
    free(numbers);
}

int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
