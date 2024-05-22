#include "devscc.h"
#include "sf-types.h"
#include "sh7708.h"

#include "e-types.h"

void functionA(void){
    int A = 43;
    int B = 868920;
    int C = 2;
    unsigned int D = 28;

    // Arithmetic
    A = A + 3840; // ADDI
    A = A + C; // ADD
    A = B - A; // SUB

    // Shift
    A = A >> 2; // SRAI, arithmetic shift for signed int
    A = A >> C; // SRA
    D = D >> 4; // SRLI, logical shift for unsigned int
    D = D >> C; // SRL
    D = D << 4; // SLLI
    D = D << C; // SLL
}

void functionB(void){
    int A = 43;
    int B = 868920;

    // Logical
    A = A ^ 2380; // XORI
    B = A ^ B; // XOR
    A = A | 43908; // ORI
    B = A | B; // OR
    A = A & 309840; // ANDI
    B = A & B; // AND
}

int main(void) {
  // volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
  volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x8000000;

  *gDebugLedsMemoryMappedRegister = 0xFF;  // ON

  for(int i = 0; i < 100000; i++);

  *gDebugLedsMemoryMappedRegister = 0x00;  // OFF

  for(int i = 0; i < 100000; i++){
    // branch to function A at every multiple of 4
    if ((i & 3) == 0){
      functionA();
    }
    else {
      functionB();
    }
  }

  *gDebugLedsMemoryMappedRegister = 0xFF;  // ON

  for(int i = 0; i < 100000; i++);

  *gDebugLedsMemoryMappedRegister = 0x00;  // OFF

  return 0;
}