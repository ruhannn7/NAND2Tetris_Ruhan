// Computes R2 = max(R0, R1)  (R0,R1,R2 refer to RAM[0],RAM[1],RAM[2])
// Usage: put values in R0, R1

   @R0
   D=M              // D = R0
   @R1
   D=D-M            // D = R0 - R1
   @OUTPUT_FIRST
   D;JGT            // if R0 > R1 goto OUTPUT_FIRST
   @R1
   D=M              // D = R1
   @OUTPUT_D
   0;JMP            // goto OUTPUT_D
(OUTPUT_FIRST)
   @R0
   D=M              // D = R0
(OUTPUT_D)
   @R2
   M=D              // R2 = D (greatest number)
(INFINITE_LOOP)
   @INFINITE_LOOP
   0;JMP            // infinite loop