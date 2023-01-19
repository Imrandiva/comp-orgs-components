/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6
int primeCount=0;

// Skriver ut primtalet
void print_number(int n){

  primeCount++;
  printf("%10d ", n);
  if (primeCount % COLUMNS == 0){
    printf("\n");
  }


}
// Kollar om talet har några delare
int is_prime(int n){
  int i;
  if(n<2){
    return 0;
  }
  for(i=2;i<n;i++) {
    if(n%i==0){
      return 0;
    }
  }
  return 1;
}



// Skriver ut alla primtal i kolumner
void print_primes(int n){
  int i;
  for(i = 0; i < n;i++){
    if(is_prime(i) == 1){
      print_number(i);
    }
  }
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
