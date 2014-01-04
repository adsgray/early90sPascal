Unit ACrt;
Interface
Type
   { type casting records }
   KRec = record
     ch : Byte;
     sc : Byte;
   end;

   CRec = record
     X : Byte;
     Y : Byte;
   end;

   WRec = record
     Lo : Byte;
     Hi : Byte;
   end;

   ScreenArray = Array [1..50 * 80] Of Word;
   ScreenPtr = ^ScreenArray;

Var
  CurScreen : ScreenPtr;

Procedure DPage(IPage : Byte);
Procedure Cls;

Procedure GoXY(X,Y:Byte);
Function WX:Byte;
Function WY:Byte;
Function CWhere:Word;

Procedure VMode(Imode : Byte);
Function CurMode:Byte;
Function CurPage:Byte;

Function getscan:Byte;
Function getchar:Char;
Function GetKey:Word;

Procedure ClearBuffer;
Procedure PutKey(IKey : Word);
Function KeyPressed:Boolean;

procedure SetBorder(InB : byte);
procedure SetBorder2(InB : byte);
function GetBorder:byte;
procedure CBlink(ya : boolean);
Procedure Cursor(Cson:boolean);

Implementation

Procedure DPage(IPage : Byte);
Assembler;
Asm
   mov AH,5
   mov AL,IPage
   Int 10h
End;

Function CurPage:Byte;
Assembler;
Asm
   mov AH,0Fh
   Int 10h
   mov AL,BH
End;

Procedure VMode(Imode : Byte);
Assembler;
Asm
   XOr AH,AH
   mov AL,Imode
   Int 10h
End;

Procedure GoXY(X,Y:Byte);
Assembler;
Asm
   mov AH,2
   mov DL,X
   mov DH,Y
   mov BH,0
   Int 10h
End;

Function WX:Byte;Assembler;
Asm
   mov AH,3
   XOr BH,BH
   Int 10h
   mov AL,DL
End;

Function WY:Byte;Assembler;
Asm
   mov AH,3
   XOr BH,BH
   Int 10h
   mov AL,DH
End;

Function CWhere:Word;
begin
  CWhere := WX + WY shl 8;
end;

Function CurMode:Byte;
Assembler;
Asm
   mov AH,0Fh
   Int 10h
End;

Procedure Cls;
Begin
  VMode(CurMode);
end;

Function getscan:Byte;
Assembler;
Asm
   mov AH,10h
   Int 16h
   mov AL,AH
End;

Function getchar:Char;
Assembler;
Asm
   mov AH,10h
   Int 16h
End;

Function GetKey:Word;
Assembler;
   Asm
      mov AH,10h
      Int 16h
   End;

Procedure ClearBuffer;Assembler;
Asm
   mov AH,0CH
   XOr AL,AL
   Int 21h
End;

Function KeyPressed:Boolean;
Var t : Byte;
Begin
   Asm
      mov AH,0Bh
      Int 21h;
      mov t,AL
   End;
   KeyPressed := t = $FF;
End;

Procedure PutKey(IKey : Word);
Assembler;
   Asm
      mov AH,5
      mov CX,IKey
      Int 16h
   End;

procedure SetBorder(InB : byte);assembler;
asm
  mov AX,1001h
  mov BH,InB
  int 10h
end;

procedure SetBorder2(InB : byte);assembler;
asm
  mov AH,0Bh
  xor BH,BH
  mov BL,InB
  int 10h
end;

function GetBorder:Byte;
assembler;
asm
  mov AX,1008h
  int 10h
  mov AL,BH
end;

procedure CBlink(ya : boolean);assembler;
asm
  mov AX,1003h
  mov BL,ya
  int 10h
end;

Procedure Cursor(Cson:boolean);
Begin
  If Cson then asm
     mov CH,7
     mov CL,8
  end else asm
     mov CH,9
     xor CL,CL
  end;
  asm
    mov AH,1
    int 10h
  end;
end;

Begin
  curscreen := PTR($B800,0); {Mono = ($B000,0)}
End.
