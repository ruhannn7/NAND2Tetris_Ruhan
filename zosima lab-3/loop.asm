@R1
M=0        // 1. Start: result = 0
@R0
D=M
@n
M=D        // 1. Start: n = R0 (counter)
(LOOP)
@n
D=M
@END
D;JEQ      // 2. Test: if n == 0, stop
@R1
M=M+1      // 3. Work: R1 = R1 + 1
@n
M=M-1      // 3. Work: n = n - 1
@LOOP
0;JMP      // 4. Go back
(END)
@END
0;JMP