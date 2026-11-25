// Draws a 64-pixel (4-word) wide by 20-row tall box starting at row 15
// on the left edge of the screen while a key is pressed (KBD != 0),
// and clears it when no key is pressed (KBD == 0).

(LOOP)
   @KBD
   D=M
   @CLEAR
   D;JEQ

   D=0
   D=!D
   @color
   M=D
   @DRAW
   0;JMP

(CLEAR)
   @color
   M=0

(DRAW)
   // Row 15 start address: 16384 + 15 * 32 = 16864
   @16864
   D=A
   @rowAddr
   M=D

   @20
   D=A
   @rows
   M=D

(ROW_LOOP)
   @rows
   D=M
   @LOOP
   D;JEQ

   @rowAddr
   D=M
   @wAddr
   M=D

   // Word 0 (pixels 0..15)
   @color
   D=M
   @wAddr
   A=M
   M=D

   // Word 1 (pixels 16..31)
   @wAddr
   M=M+1
   @color
   D=M
   @wAddr
   A=M
   M=D

   // Word 2 (pixels 32..47)
   @wAddr
   M=M+1
   @color
   D=M
   @wAddr
   A=M
   M=D

   // Word 3 (pixels 48..63)
   @wAddr
   M=M+1
   @color
   D=M
   @wAddr
   A=M
   M=D

   // Move down 1 row (+32 screen words)
   @32
   D=A
   @rowAddr
   M=D+M

   @rows
   M=M-1
   @ROW_LOOP
   0;JMP