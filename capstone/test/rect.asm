// Draws a filled rectangle at the screen's top left corner,
// width = 16 pixels, height = RAM[0] (R0).
// Usage: put a non-negative number in R0.

   @R0
   D=M              // D = R0
   @INFINITE_LOOP
   D;JLE            // if R0 <= 0 goto INFINITE_LOOP
   @counter
   M=D              // counter = R0
   @SCREEN
   D=A
   @address
   M=D              // address = 16384 (SCREEN)
(LOOP)
   @address
   A=M              // A = address
   M=-1             // RAM[address] = -1 (1111111111111111 in binary)
   @counter
   MD=M-1           // counter-- and D = counter
   @INFINITE_LOOP
   D;JEQ            // if counter == 0 goto INFINITE_LOOP
   @32
   D=A
   @address
   M=D+M            // address += 32 (next screen row)
   @LOOP
   0;JMP            // goto LOOP
(INFINITE_LOOP)
   @INFINITE_LOOP
   0;JMP            // infinite loop