#include "devscc.h"
#include "sf-types.h"
#include "sh7708.h"

#include "e-types.h"

int main(void) {
  // volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
  volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x8000000;

  int i;
  float A = 2.4;
  float B = 9.8;

  *gDebugLedsMemoryMappedRegister = 0xFF;  // ON

  for(int i = 0; i < 100000; i++);

  *gDebugLedsMemoryMappedRegister = 0x00;  // OFF

  for(int i = 0; i < 100000; i++){
    B = A * i;  // multiplication
    B = A / i;  // division
  }

  *gDebugLedsMemoryMappedRegister = 0xFF;  // ON

  for(int i = 0; i < 100000; i++);

  *gDebugLedsMemoryMappedRegister = 0x00;  // OFF

  return 0;
}