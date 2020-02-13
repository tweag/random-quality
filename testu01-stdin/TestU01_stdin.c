/*
**********************************************************************

TestU01_stdin : Testing any Random Number Generator by reading
                its Output from STDIN

**********************************************************************

This source TestU01_stdin.c make use of TESTU01, a random number
generator test battery copyright (c) 2002 Pierre L'Ecuyer. The source
code of TestU01_stdin.c include and use librarys having the
copyright as follows:

======================================================================

*** TestU01 ***

Copyright (c) 2002 Pierre L'Ecuyer, DIRO, Universite de Montreal.
e-mail: lecuyer@iro.umontreal.ca http://www.iro.umontreal.ca/~lecuyer/

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted without a fee for private, research,
academic, or other non-commercial purposes. Any use of this software
in a commercial environment requires a written licence from the
copyright owner.

Any changes made to this package must be clearly identified as such.

In scientific publications which used this software, a reference to it
would be appreciated.

Redistributions of source code must retain this copyright notice and
the following disclaimer.

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

=======================================================================
*/

#include "unif01.h" 
#include "gdef.h"
#include "swrite.h"
#include "bbattery.h" 

#include <stdlib.h>
#include <stdio.h> 
#include <stdint.h>
#include <string.h>
#include <time.h>


/*
=======================================================================

Compile Instructions
=====================
unzip TestU01.zip

cd TestU01-1.2.3/

# I prefer /opt/testu01/ as prefix
# because in case I'd like to delete
# TestU01 for same reason later
# I need just remove the testu01 
# folder in /opt
#

./configure --prefix=/opt/testu01/
make && make install


now add to your ~/.profile or ~/.bashrc

# TestU01
export LD_LIBRARY_PATH=/opt/testu01/lib:${LD_LIBRARY_PATH}
export LIBRARY_PATH=/opt/testu01/lib:${LIBRARY_PATH}
export C_INCLUDE_PATH=/opt/testu01/include:${C_INCLUDE_PATH}

now activate by

source ~/.profile or ~/.bashrc

 -------------------------------------------------------------

 rm -f ./TestU01_stdin; gcc -std=c99 -O3 -fomit-frame-pointer -mtune=native TestU01_stdin.c -o TestU01_stdin -ltestu01 -lprobdist -lmylib -lm

 PRNG output | ./TestU01_stdin -s

 -------------------------------------------------------------
 
 for example a smallcrush test run based
 on the output of bcd32 would be started like this

    ./bcd32_keystream 2ddd6a2c 0xfffffffe | ./TestU01_stdin -s
      ^               ^        ^
     algorithm        seed     sample count
     
 
 or for testing the keystream quality of RC4 like this
   
    ./rc4_keystream 2ddd6a2c 0xfffffffe | ./TestU01_stdin -s
 
 and for cross check that TestU01 can identify a bad PRNG 

    ./C_Rand_stdio 0x2ddd6a2c 0xfffffffe | ./TestU01_stdin -s
 
    ./LCG_stdio 0x2ddd6a2c 0xfffffffe | ./TestU01_stdin -s
 
  -------------------------------------------------------------

  View and Store the Results with for example


  SmallCrush:
  ===========
  (nice -n 19 ./bcd32_keystream 2ddd6a2c 0xfffffffe | ./TestU01_stdin -s  3>&1 2>&3- | tee bcd32_keystream--key-2ddd6a2c--SmallCrush.txt)&

  (nice -n 19 ./bcd32_keystream 570be2644d3c3fe12e85f4645c6fe918 0xfffffffe | ./TestU01_stdin -s  3>&1 2>&3- | tee bcd32_keystream--key-570be2644d3c3fe12e85f4645c6fe918--SmallCrush.txt)&


  Crush:
  ======
  (nice -n 19 ./bcd32_keystream 2ddd6a2c 0xfffffffffffffffe | ./TestU01_stdin -c  3>&1 2>&3- | tee bcd32_keystream--key-2ddd6a2c--Crush.txt)&

  (nice -n 19 ./bcd32_keystream 570be2644d3c3fe12e85f4645c6fe918 0xfffffffffffffffe | ./TestU01_stdin -c  3>&1 2>&3- | tee bcd32_keystream--key-570be2644d3c3fe12e85f4645c6fe918--Crush.txt)&

  -------------------------------------------------------------

*/


//-----------------------------------------
//
void ShowUsage(char* ThisName) 
{
    fprintf(stderr, "Usage: PRNG_output | %s [-s] [-c] [-b]\n", ThisName);
    fprintf(stderr, "where: -s = SmallCrush\n");
    fprintf(stderr, "where: -c = Crush\n");
    fprintf(stderr, "where: -b = BigCrush\n");
}


static uint64_t totalProcessed32Bit = 0;


// Read in 32bit and pass it back to the test function
uint32_t stdin32bit() {
  uint32_t  uint32bit;

  totalProcessed32Bit++;

  uint8_t bufferRead = fread(&uint32bit, sizeof(uint32_t), 1, stdin);

  return (uint32bit);
}

//-----------------------------------------
// Main 
int main (int argc, char *argv[]) 
{ 
  // Check if a Prarmeter is passed through
  char* PrgName;
  
  PrgName = argv[0];

  if (argc < 2) {
    ShowUsage(PrgName);
    return 1;
    
  } else {
  
    if ( (strcmp(argv[1], "-s") != 0) && (strcmp(argv[1], "-c") != 0) \
       &&(strcmp(argv[1], "-b") != 0) ) {
        
      ShowUsage(PrgName);
      return 1;
    }
  }


  fflush(stdin);
  fflush(stdout);

  //-----------------------------------------
  unif01_Gen *gen; 
  
  gen = unif01_CreateExternGenBits("32-bit stdin", stdin32bit); 
  
  //-----------------------------------------
  // Test Routine Selection
  if (strcmp(argv[1], "-s") == 0) {
    bbattery_SmallCrush(gen);
    
  } else if (strcmp(argv[1], "-c") == 0) {
    bbattery_Crush(gen); 
    
  } else if (strcmp(argv[1], "-b") == 0) {
    bbattery_BigCrush(gen); 
    
  } 
  
  unif01_DeleteExternGenBits(gen); 

  fprintf(stderr, "Total processed 32Bit Samples = %16llu\n",   totalProcessed32Bit);

  return 0; 
} 
