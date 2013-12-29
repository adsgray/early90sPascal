Unit AMouse;
{ Andrew Gray
  06-01-94
  06-07-94
  06-17-94 }

(******************) Interface (******************)
Type
   AMouseData = Record
      TX,TY,
      Count   : Byte;
      GX,GY   : Word;
      Pressed : Boolean;
   End;
   
Function Init : Boolean;
Procedure Show(eh:boolean);

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

Procedure TWindow(X1,Y1,X2,Y2 : Byte);
Procedure GWindow(X1,Y1,X2,Y2 : Integer);
Procedure setsens(X,Y:Word);
Function GetXsens : Word;
Function GetYsens : Word;

(******************) Implementation (******************)
Function Init : Boolean;Assembler;
Asm
   XOr AX,AX; Int 33h;
End;

Procedure Show(eh:boolean);
begin
  if eh then asm
    mov AX,1; Int 33h;
  end else asm
   mov AX,2; Int 33h;
  end;
End;


Function TWhereX : Byte;
Var T : Word;
Begin
   Asm
      mov AX,3
      Int 33h
      mov T,CX
   End;
   TWhereX := (T ShR 3);
End;

Function TWhereY : Byte;
Var T : Word;
Begin
   Asm
      mov AX,3;
      Int 33h
      mov T,DX
   End;
   TWhereY := (T ShR 3);
End;

Procedure TGotoXY(IX,IY : Byte);
Var tx,ty : Word;
Begin
   tx := (IX) ShL 3;
   ty := (IY) ShL 3;
   Asm
      mov AX,4
      mov CX,tx
      mov DX,ty
      Int 33h
   End;
End;

Function GWhereX : Word;
Assembler;
   Asm
      mov AX,3
      Int 33h
      mov AX,CX
   End;

Function GWhereY : Word;
Assembler;
   Asm
      mov AX,3
      Int 33h
      mov AX,DX
   End;

Procedure GGotoXY(IX,IY : Word);
Assembler;
Asm
   mov AX,4
   mov CX,IX
   mov DX,IY
   Int 33h
End;

Function LeftPressed : Boolean;
Var t : Word;
Begin
   Asm
      mov AX,3
      Int 33h
      mov t,BX
   End;
   LeftPressed := t = 1;
End;

Function RightPressed : Boolean;
Var t : Word;
Begin
   Asm
      mov AX,3
      Int 33h
      mov t,BX
   End;
   RightPressed := t = 2;
End;

Function BothPressed : Boolean;
Var t : Word;
Begin
   Asm
      mov AX,3
      Int 33h
      mov t,BX
   End;
   BothPressed := t = 3;
End;

Function MiddlePressed : Boolean;
Var t : Word;
Begin
   Asm
      mov AX,3
      Int 33h
      mov t,BX
   End;
   MiddlePressed := t = 4;
End;

Procedure LeftPressData(Var InMDataT : AMouseData);
Var A,B,C,D : Word;
Begin
   Asm
      mov AX,5
      XOr BX,BX
      Int 33h
      mov A,AX
      mov B,BX
      mov C,CX
      mov D,DX
   End;
   With InMDataT Do Begin
      count := B;
      TX := (C ShR 3);
      TY := (D ShR 3);
      GX := C;
      GY := D;
      Pressed := A = 1;
   End;
End;

Procedure RightPressData(Var InMDataT : AMouseData);
Var A,B,C,D : Word;
Begin
   Asm
      mov AX,5
      mov BX,1
      Int 33h
      mov A,AX
      mov B,BX
      mov C,CX
      mov D,DX
   End;
   With InMDataT Do Begin
      count := B;
      TX := (C ShR 3);
      TY := (D ShR 3);
      GX := C;
      GY := D;
      Pressed := A = 2;
   End;
End;

Procedure TWindow(X1,Y1,X2,Y2 : Byte);
Var T1,T2:Word;
Begin
   T1 := (X1) ShL 3;
   T2 := (X2) ShL 3;
   Asm
      mov AX,7
      mov CX,T1
      mov DX,T2
      Int 33h
   End;
   T1 := (Y1) ShL 3;
   T2 := (Y2) ShL 3;
   Asm
      mov AX,8
      mov CX,T1
      mov DX,T2
      Int 33h
   End;
End;

Procedure GWindow(X1,Y1,X2,Y2 : Integer);Assembler;
Asm
   mov AX,7
   mov CX,X1
   mov DX,X2
   Int 33h
   mov AX,8
   mov CX,Y1
   mov DX,Y2
   Int 33h
End;

Procedure setsens(X,Y:Word);
Assembler;
Asm
   mov AX,1AH
   mov BX,X
   mov CX,Y
   XOr DX,DX
   Int 33h
End;

Function GetXsens : Word;
Assembler;
Asm
   mov AX,1BH
   Int 33h
   xchg AX,BX
End;

Function GetYsens : Word;
Assembler;
Asm
   mov AX,1BH
   Int 33h
   xchg AX,CX
End;
End.
