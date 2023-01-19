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

//int printed_col = 0;


// void print_number(int n){
//     printf("%10d ", n);
//     printed_col += 1;
//     if (printed_col == COLUMNS) {
//         printf("\n");
//         printed_col = 0;
//     }
// }

void mean_sieves(int N){
   
    char numbers[N];
    
    for (int n = 0; n < N; n++) {
        numbers[n] = 1;                             // set all elements to 1
    }
    
    for (int i = 2; i < sqrt(N); i++) {           // for i = 2, 3, 4, ..., not exceeding √n do
        if (numbers[i] == 1){                       // if A[i] is true
            for (int j = i*i; j < N; j += i) {    // for j = i^2, i^2+i, i^2+2i, i^2+3i, ..., not exceeding n do
                numbers[j] = 0;                     // A[j] := false
            }
        }
    }
    int sum =0;
    int amount = 0;
    for (int k = 2; k < N; k++) {     //if numbers(k) == 1, print k
        if (numbers[k] == 1){
            sum += k;
            amount += 1;
        }
    }
    float mean = (float) sum / amount; 
    printf("%f",mean);
    printf("\n");
}

int main(int argc, char *argv[]){
  if(argc == 2)
    mean_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
