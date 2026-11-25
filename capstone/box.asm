(LOOP)
@KBD
D=M
@BLACK
D;JNE

@COLOR
M=0
@DRAW
0;JMP

(BLACK)
@COLOR
M=-1

(DRAW)
@16864  // 16384 + (32 * k)
D=A
@ADDR
M=D

@20
D=A
@ROWS
M=D

(ROW_LOOP)
@4
D=A
@COLS
M=D

(COL_LOOP)
@COLOR
D=M
@ADDR
A=M
M=D

@ADDR
M=M+1

@COLS
MD=M-1
@COL_LOOP
D;JGT

@28
D=A
@ADDR
M=D+M

@ROWS
MD=M-1
@ROW_LOOP
D;JGT

@LOOP
0;JMP