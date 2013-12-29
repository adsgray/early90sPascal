Unit use;
(*************************) Interface (*************************)
function ITOA (N : Longint; W : byte): string; { Convert LongInt to String }
function RTOA (N : real; W,D : byte): string;     { Convert Real to String }
procedure blink(state:boolean);
procedure scrwrite(s:string; x,y,col:byte);
Procedure GetImage (X1,Y1,X2,Y2:Integer;P:Pointer);
Procedure PutImage (X1,Y1:Integer;P:Pointer);
Procedure CPUDelay(D: Word);
PROCEDURE InitVGA;
PROCEDURE InitTEXT;
PROCEDURE SetColor (ColorNo, Red, Green, Blue : byte); 
PROCEDURE MovCursor (X,Y : byte);  {Moves the cursor to (X,Y)} 
FUNCTION ReadCursorX: byte;
FUNCTION ReadCursorY: byte;
PROCEDURE PutText (TextData : string; Color : byte);  {Write a string} 
PROCEDURE PlotPixel(X, Y: Word; Color: Byte);
Function fexist(fn:string):boolean;
Function FileExist(filename : String) : Boolean;
procedure qwrite(x, y: byte; s: string; f, b: byte);
Procedure SetTypeRate(Kdelay, Krate:Byte);
Procedure SetRGB(color,r,g,b:Byte);
Function Hex(num: Word; nib: Byte): String;
Function Binary(num: Word; bits: Byte): String;
function checksum(s:string):word;

(*************************) Implementation (*************************)
uses Dos;
function ITOA (N : Longint; W : byte): string; { Convert LongInt to String }
var S : string;
begin
  if W > 0 then Str (N:W,S)
  else          Str (N,S);
  ITOA := S
end;  { ITOA }

function RTOA (N : real; W,D : byte): string;     { Convert Real to String }
var S : string;
begin
  Str (N:W:D,S); RTOA := S
end;  { RTOA }

procedure blink(state:boolean); assembler;
asm
  mov dx,3dah
  in al,dx
  mov dx,3c0h
  mov al,10h+32
  out dx,al
  inc dx
  in al,dx
  and al,11110111b
  mov ah,state
  shl ah,3
  or al,ah
  dec dx
  out dx,al
end;

procedure scrwrite(s:string; x,y,col:byte);
var offset : word; i : byte;
begin
  offset := y*160+x+x;
  if length(s) > 0 then
    for i := 0 to length(s)-1 do
      memw[segA000:offset+i+i] := col*256+ord(s[i+1]);
end;

Procedure GetImage (X1,Y1,X2,Y2:Integer;P:Pointer); assembler;
asm
    mov  bx,320
    push ds
    les  di,P

    mov  ax,0A000h
    mov  ds,ax
    mov  ax,Y1
    mov  dx,320
    mul  dx
    add  ax,X1
    mov  si,ax

    mov  ax,X2
    sub  ax,X1
    inc  ax
    mov  dx,ax
    stosw

    mov  ax,Y2
    sub  ax,Y1
    inc  ax
    stosw
    mov  cx,ax

  @@1:
    mov  cx,dx

    shr  cx,1
    cld
    rep  movsw

    test dx,1
    jz         @@2
    movsb
  @@2:
    add  si,bx
    sub  si,dx

    dec  ax
    jnz  @@1

    pop  ds
end;

Procedure PutImage (X1,Y1:Integer;P:Pointer); assembler;
asm
    mov  bx,320
    push ds
    lds  si,P

    mov  ax,0A000h
    mov  es,ax
    mov  ax,Y1
    mov  dx,320
    mul  dx
    add  ax,X1
    mov  di,ax

    lodsw
    mov  dx,ax

    lodsw

  @@1:
    mov  cx,dx

    shr  cx,1
    cld
    rep  movsw

    test dx,1
    jz         @@2
    movsb
  @@2:
    add  di,bx
    sub  di,dx

    dec  ax
    jnz  @@1

    pop  ds
end;

Procedure CPUDelay(D: Word); Assembler;
asm
  @@1:
    mov cx,$FFFF
  @@2:
    nop
    loop @@2
    dec[d]
    jnz @@1
end;

PROCEDURE InitVGA; ASSEMBLER;  {Puts you in 320x200x256 VGA} 
asm 
   mov  ax, 13h 
   int  10h 
end; 
 
PROCEDURE InitTEXT; ASSEMBLER; {Puts you back in 80x25 text mode} 
asm 
   mov  ax, 03h 
   int  10h 
end; 
 
PROCEDURE SetColor (ColorNo, Red, Green, Blue : byte); 
begin     {Changes the pallete data for a particular colour} 
     PORT[$3C8] := ColorNo; 
     PORT[$3C9] := Red; 
     PORT[$3C9] := Green; 
     PORT[$3C9] := Blue; 
end; 
 
PROCEDURE MovCursor (X,Y : byte);  {Moves the cursor to (X,Y)} 
begin 
  asm 
  MOV   ah, 02h 
  XOR   bx, bx 
  MOV   dh, Y 
  MOV   dl, X 
  INT   10h 
  end; 
end; 
 
FUNCTION ReadCursorX: byte; assembler;  {Get X position of cursor} 
asm 
  MOV   ah, 03h 
  XOR   bx, bx 
  INT   10h 
  MOV   al, dl 
end; 
 
FUNCTION ReadCursorY: byte; assembler;  {Get Y position of cursor} 
asm 
  MOV   ah, 03h 
  XOR   bx, bx 
  INT   10h 
  MOV   al, dh 
end; 
 
PROCEDURE PutText (TextData : string; Color : byte);  {Write a string} 
var      {It's not the fastest way to do it, but it does the job} 
 z, ASCdata, CursorX, CursorY : byte; 
begin 
 CursorX := ReadCursorX; 
 CursorY := ReadCursorY; 
 for z := 1 to Length(TextData) do 
 begin 
  ASCdata := Ord(TextData[z]); 
  asm 
  MOV   ah, 0Ah 
  MOV   al, ASCdata 
  XOR   bx, bx 
  MOV   bl, Color 
  MOV   cx, 1 
  INT   10h 
  end; 
  inc(CursorX); 
  if CursorX=40 then begin CursorX:=0; inc(CursorY); end; 
  MovCursor(CursorX,CursorY); 
 end; 
end; 
 
PROCEDURE PlotPixel(X, Y: Word; Color: Byte); ASSEMBLER; {Plots a pixel} 
asm 
   push es 
   push di 
   mov  ax, Y 
   mov  bx, ax 
   shl  ax, 8 
   shl  bx, 6 
   add  ax, bx 
   add  ax, X 
   mov  di, ax 
   mov  ax, $A000 
   mov  es, ax 
   mov  al, Color 
   mov  es:[di], al 
   pop  di 
   pop  es 
end;

{ uses dos; }
Function fexist(fn:string):boolean;
var
  f:file;
  it:word;
begin
  assign(f,fn);
  getfattr(f,it);
  fexist:=doserror=0;
end;

{
     get palette entry:

     Port[967] := Color;
     Red := Port[969];
     Green := Port[969];
     Blue := Port[969];

     Set palette entry:
   
     Port[968] := Color;
     Port[969] := Red;
     Port[969] := Green;
     Port[969] := Blue;
}

procedure qwrite(x, y: byte; s: string; f, b: byte); assembler;

{ Does a direct video write -- extremely fast. }

  asm
      push ds
      cld
      mov dh, y         { move X and Y into DL and DH }
      mov dl, x
      xor al, al
      mov ah, b         { load background into AH }
      mov cl, 4         { shift background over to next nibble }
      shl ax, cl
      add ah, f         { add foreground }
      push ax           { PUSH color combo onto the stack }
      mov bx, 0040h     { look at 0040h:0049h to get video mode }
      mov es, bx
      mov bx, 0049h
      mov al, es:[bx]
      cmp al, 7         { see if mode = 7 (i.e., monochrome) }
      je @mono_segment
      mov ax, 0b800h    { it's color: use segment B800h }
      jmp @got_segment
    @mono_segment:
      mov ax, 0b000h    { it's mono: use segment B000h }
    @got_segment:
      push ax           { PUSH video segment onto stack }
      mov bx, 004ah     { check 0040h:0049h to get number of screen columns }
      xor ch, ch
      mov cl, es:[bx]
      xor ah, ah        { move Y into AL; decrement to convert Pascal coords }
      mov al, dh
      dec al
      xor bh, bh        { shift X over into BL; decrement again }
      mov bl, dl
      dec bl
      cmp cl, $50       { see if we're in 80-column mode }
      je @eighty_column
      mul cx            { multiply Y by the number of columns }
      jmp @multiplied
    @eighty_column:     { 80-column mode: it may be faster to perform the }
      mov cl, 4         {   multiplication via shifts and adds: remember  }
      shl ax, cl        {   that 80d = 1010000b , so one can SHL 4, store }
      mov dx, ax        {   the result in DX, SHL by 2, and add DX in.    }
      mov cl, 2
      shl ax, cl
      add ax, dx
    @multiplied:
      add ax, bx        { add X in }
      shl ax, 1         { multiply by 2 to get offset into video segment }
      mov di, ax        { video pointer is in DI }
      lds si, s         { string pointer is in SI }
      lodsb
      mov cl, al
      xor ch, ch        { string length is in CX }
      pop es            { get video segment back from stack; put in ES }
      pop ax            { get color back from stack; put in AX (AH = color) }
      cmp cl, 00h       { zero-length string: we're done }
      je @done
    @write_loop:
      lodsb             { get character to write }
      mov es:[di], ax   { write AX to video memory }
      inc di            { increment video pointer }
      inc di
      loop @write_loop  { if CX > 0, go back to top of loop }
    @done:              { end }
      pop ds
    end;

Procedure SetTypeRate(Kdelay, Krate:Byte);
assembler;
asm
  Mov AX,$0305
  Mov BH, Kdelay
  Mov BL, Krate
  Int 16h
End;

Procedure SetRGB(color,r,g,b:Byte);
begin
  IF Color =6 Then Color:=20 ELSE IF Color>=8 Then Color:=Color+48;
  port[$3c8]:=color;
  port[$3c9]:=r;
  port[$3c9]:=g;
  port[$3c9]:=b;
end;
(* Hex converts a number (num) to Hexadecimal.                      *)
(*    num  is the number to convert                                 *)
(*    nib  is the number of Hexadecimal digits to return            *)
(* Example: Hex(31, 4) returns '001F'                               *)

Function Hex(num: Word; nib: Byte): String; Assembler;
ASM
      PUSHF
      LES  DI, @Result
      XOR  CH, CH
      MOV  CL, nib
      MOV  ES:[DI], CL
      JCXZ @@3
      ADD  DI, CX
      MOV  BX, num
      STD
@@1:  MOV  AL, BL
      AND  AL, $0F
      OR   AL, $30
      CMP  AL, $3A
      JB   @@2
      ADD  AL, $07
@@2:  STOSB
      SHR  BX, 1
      SHR  BX, 1
      SHR  BX, 1
      SHR  BX, 1
      LOOP @@1
@@3:  POPF
End;


(* Binary converts a number (num) to Binary.                        *)
(*    num  is the number to convert                                 *)
(*    bits is the number of Binary digits to return                 *)
(* Example: Binary(31, 16) returns '0000000000011111'               *)

Function Binary(num: Word; bits: Byte): String; Assembler;
ASM
      PUSHF
      LES  DI, @Result
      XOR  CH, CH
      MOV  CL, bits
      MOV  ES:[DI], CL
      JCXZ @@3
      ADD  DI, CX
      MOV  BX, num
      STD
@@1:  MOV  AL, BL
      AND  AL, $01
      OR   AL, $30
      STOSB
      SHR  BX, 1
      LOOP @@1
@@3:  POPF
End;

Function FileExist(filename : String) : Boolean; Assembler;
ASM
        PUSH   DS
        LDS    SI, [filename]      { make ASCIIZ }
        XOR    AH, AH
        LODSB
        XCHG   AX, BX
        MOV    Byte Ptr [SI+BX], 0
        MOV    DX, SI
        MOV    AX, 4300h           { get file attributes }
        INT    21h
        MOV    AL, False
        JC     @1                  { fail? }
        INC    AX
@1:     POP    DS
end;  { FileExist }

  function checksum(s:string):word;
  {
    However, checksum values are the same for different
    permutations of the same characters. Also, the checksum values
    have to be encoded in the case statement and cannot be
    calculated during run-time.
  }
  var
    r: registers;
  begin
    r.ax:= $121c;            {ax = interrupt function}
    r.ds:= seg(s[1]);        {ds = segment of 1st byte in string}
    r.si:= ofs(s[1]);        {si = offset of 1st byte in string}
    r.cx:= length(s);        {cx = length of string}
    r.dx:= 0;                {dx = initial sum value}
    intr($2f,r);             {call 2fh interrupt}
    checksum:= r.dx;         {dx = returns checksum value}
  end;
End. { Unit }
