Unit AMouse;
{ Andrew Gray
  6-1-94
  6-7-94 }

Interface
Type
   AMouseData = Record
      TX,TY,
      Count   : Byte;
      GX,GY   : Word;
      Pressed : Boolean;
   End;

Function Init : Boolean;
Procedure Show;
Procedure Hide;

Function TWhereX : Byte;
Function TWhereY : Byte;
Procedure TGotoXY(IX,IY : Byte);

Function GWhereX : Word;
Function GWhereY : Word;
Procedure GGotoXY(IX,IY : Word);

Function LeftPressed : Boolean;
Function RightPressed : Boolean;
Function BothPressed : Boolean;
Function MiddlePressed : Boolean;

Procedure LeftPressData(Var InMDataT : AMouseData);
Procedure RightPressData(Var InMDataT : AMouseData);

procedure TWindow(X1,Y1,X2,Y2 : Byte);
procedure GWindow(X1,Y1,X2,Y2 : Integer);
Procedure MTA (MTA: Word);

Implementation
Function Init : Boolean;Assembler;
Asm
   XOr AX,AX; Int 33h;
End;

Procedure Show;Assembler;
Asm
   mov AX,1; Int 33h;
End;

Procedure Hide;Assembler;
Asm
   mov AX,2; Int 33h;
End;

Function TWhereX : Byte;
var T : Word;
Begin
   Asm
     mov AX,3
     int 33h
     mov T,CX
   End;
   TWhereX := (T shr 3) + 1;
End;

Function TWhereY : Byte;
var T : Word;
Begin
   Asm
     mov AX,3;
     int 33h
     mov T,DX
   End;
   TWhereY := (T shr 3) + 1;
End;

Procedure TGotoXY(IX,IY : Byte);
var tx,ty : word;
Begin
   tx := (IX-1) shl 3;
   ty := (IY-1) shl 3;
   Asm
      mov AX,4
      mov CX,tx
      mov DX,ty
      int 33h
   End;
End;

Function GWhereX : Word;
Assembler;
   Asm
     mov AX,3
     int 33h
     mov AX,CX
   End;

Function GWhereY : Word;
Assembler;
   Asm
     mov AX,3
     int 33h
     mov AX,DX
   End;

Procedure GGotoXY(IX,IY : Word);
assembler;
asm
    mov AX,4
    mov CX,IX
    mov DX,IY
    int 33h
End;

Function LeftPressed : Boolean;
Var t : word;
Begin
   Asm
     mov AX,3
     int 33h
     mov t,BX
   End;
   LeftPressed := t = 1;
End;

Function RightPressed : Boolean;
Var t : word;
Begin
   Asm
     mov AX,3
     int 33h
     mov t,BX
   End;
   RightPressed := t = 2;
End;

Function BothPressed : Boolean;
Var t : word;
Begin
  Asm
    mov AX,3
    int 33h
    mov t,BX
  End;
  BothPressed := t = 3;
End;

Function MiddlePressed : Boolean;
Var t : word;
Begin
   Asm
     mov AX,3
     int 33h
     mov t,BX
   End;
   MiddlePressed := t = 4;
End;

Procedure LeftPressData(Var InMDataT : AMouseData);
Var A,B,C,D : word;
Begin
   Asm
     mov AX,5
     XOr BX,BX
     int 33h
     mov A,AX
     mov B,BX
     mov C,CX
     mov D,DX
   End;
   With InMDataT Do Begin
      count := B;
      TX := (C shr 3) + 1;
      TY := (D shr 3) + 1;
      GX := C;
      GY := D;
      Pressed := A = 1;
   End;
End;

Procedure RightPressData(Var InMDataT : AMouseData);
Var A,B,C,D : word;
Begin
   Asm
     mov AX,5
     mov BX,1
     int 33h
     mov A,AX
     mov B,BX
     mov C,CX
     mov D,DX
   End;
   With InMDataT Do Begin
      count := B;
      TX := (C shr 3) + 1;
      TY := (D shr 3) + 1;
      GX := C;
      GY := D;
      Pressed := A = 2;
   End;
End;

procedure TWindow(X1,Y1,X2,Y2 : Byte);
var T1,T2:word;
begin
  T1 := (X1-1) shl 3;
  T2 := (X2-1) shl 3;
  Asm
    mov AX,7
    mov CX,T1
    mov DX,T2
    int 33h
  End;
  T1 := (Y1-1) shl 3;
  T2 := (Y2-1) shl 3;
  Asm
    mov AX,8
    mov CX,T1
    mov DX,T2
    int 33h
  End;
end;

procedure GWindow(X1,Y1,X2,Y2 : Integer);assembler;
asm
  mov AX,7
  mov CX,X1
  mov DX,X2
  int 33h
  mov AX,8
  mov CX,Y1
  mov DX,Y2
  int 33h
end;

Procedure MTA (MTA: Word); Assembler;
Asm
 mov ax,000Ah
 mov bx,0
 mov cx,mta  { CH controls then textbackground of mouse cursor  }
 mov dh,cl   { CL controls the text on screen that's changed    }
 mov cl,255  { DH controls then text color of mouse cursor      }
 xor dl,dl   { DL controls the mouse cursor character           }
 int 33h     { CL is set to 255 and DL to 0 for no change       }
End;

End.
