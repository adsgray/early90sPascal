Unit AScreen;
{ use this instead of the crt unit when you don't want
  to do anything too fancy }

Interface
Const
  Black      = 0;
  Blue       = 1;
  Green      = 2;
  Cyan       = 3;
  Red        = 4;
  Magenta    = 5;
  Brown      = 6;
  LGray      = 7;
  DGray      = 8;
  LBlue      = 9;
  LGreen     = 10;
  LCyan      = 11;
  LRed       = 12;
  LMagenta   = 13;
  Yellow     = 14;
  White      = 15;
  Blink      = 128;

Var
  WindMin,
  WindMax  : Word;
  Tattr : byte;

  Procedure ClrScr;
  Procedure wrtchar(ich:char);
  Procedure Wrt(INST : string);
  Procedure ReadStr(var INST : string);
  Procedure Window(X1,Y1,X2,Y2 : byte);

Implementation uses Acrt;

Procedure ClrScr;Assembler;
Asm
  push bp
  xor AX,AX
  mov AH,6
  mov BH,tattr
  mov CX,WindMin
  mov DX,WindMax
  int 10h
  pop bp
End;

Procedure wrtchar(ich:char);Assembler;
Asm
  mov AH,0Eh
  mov AL,ich
  mov BH,0
  mov BL,tattr
  int 10h
End;

Procedure Wrt(INST : string);
Var ct:byte;
Begin
  For ct := 1 to length(INST) do
  Begin
    wrtchar(INST[ct]);
  End;
End;

procedure ReadStr(var INST : string);
var TCh : char;
begin
  INST := '';
  Tch := GetChar;
  while (TCh <> #13) do begin
    if TCh <> #0 then begin
      wrtchar(Tch);
      INST := INST + Tch;
    end;
    Tch := getchar;
  end;
end;

Procedure Window(X1,Y1,X2,Y2 : byte);
begin
  WindMin := x1 + y1 shl 8;
  WindMax := x2 + y2 shl 8;
  with crec(windmin) do goxy(X,Y);
end;

Begin
  windmin := 0;
  windmax := 79 + 24 shl 8;
  Tattr := 7;
End.
