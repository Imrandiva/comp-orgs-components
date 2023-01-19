/*
 sieves.c
By Imran Diva
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>
#include <math.h>

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

void print_sieves(int n){
  // Should print out all prime numbers less than 'n'
  // with the following formatting.
  // Iniatizes all values from index 2 to n in array to 1=true
  int array[n];
  // Sparar alla tal från 2 till n i en array
  for (int i = 2;i<n;i++){
    array[i] = 1;
  }

  // Hittar alla multiplar för varje primtal mindre än roten av n
  for(int i=2; i< sqrt(n);i++) {
    if (array[i] == 1) {
      int j = i*i; // Används för att minska redundans
      while (j<n){
        array[j] = 0; 
        j+=i;
      }
    }
  }
   // Skriver ut de tal som inte är en multipel av något annat
  for (int i=2; i<n;i++){
    if (array[i]==1){
       print_number(i);
    }
  }

}



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
