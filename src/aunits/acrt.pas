Unit ACrt;

(*******************) Interface (*******************)
Type
   krec = {Key Record}
      record
        case word of
        0 : (hard : word);
        1:(
        ch : char; {char}
        sc : byte; {scan} );
      end;
   crec = {Cursor position record}
      record
        X : byte;
        Y : byte;
      end;
   wrec = {lo/hi byte of word record}
      record
        lo : byte;
        hi : byte;
      end;
   prec = record
     seg,ofs : word;
   end;

{Const}
{ Extended key codes }
{
  kbEsc       = $011B;  kbAltSpace  = $0200;  kbCtrlIns   = $0400;
  kbShiftIns  = $0500;  kbCtrlDel   = $0600;  kbShiftDel  = $0700;
  kbBack      = $0E08;  kbCtrlBack  = $0E7F;  kbShiftTab  = $0F00;
  kbTab       = $0F09;  kbAltQ      = $1000;  kbAltW      = $1100;
  kbAltE      = $1200;  kbAltR      = $1300;  kbAltT      = $1400;
  kbAltY      = $1500;  kbAltU      = $1600;  kbAltI      = $1700;
  kbAltO      = $1800;  kbAltP      = $1900;  kbCtrlEnter = $1C0A;
  kbEnter     = $1C0D;  kbAltA      = $1E00;  kbAltS      = $1F00;
  kbAltD      = $2000;  kbAltF      = $2100;  kbAltG      = $2200;
  kbAltH      = $2300;  kbAltJ      = $2400;  kbAltK      = $2500;
  kbAltL      = $2600;  kbAltZ      = $2C00;  kbAltX      = $2D00;
  kbAltC      = $2E00;  kbAltV      = $2F00;  kbAltB      = $3000;
  kbAltN      = $3100;  kbAltM      = $3200;  kbF1        = $3B00;
  kbF2        = $3C00;  kbF3        = $3D00;  kbF4        = $3E00;
  kbF5        = $3F00;  kbF6        = $4000;  kbF7        = $4100;
  kbF8        = $4200;  kbF9        = $4300;  kbF10       = $4400;
  kbF11 = 34048;        kbF12 = 34304;
  kbShiftF11 = 34560;   kbShiftF12 = 35328;
  kbAltF11 = 35584;     kbAltF12 = 35840;
  kbCtrlF11 = 35072;    kbCtrlF12 = 35328;
  kbHome      = $4700;  kbUp        = $4800;  kbPgUp      = $4900;
  kbGrayMinus = $4A2D;  kbLeft      = $4B00;  kbRight     = $4D00;
  kbGrayPlus  = $4E2B;  kbEnd       = $4F00;  kbDown      = $5000;
  kbPgDn      = $5100;  kbIns       = $5200;  kbDel       = $5300;
  kbShiftF1   = $5400;  kbShiftF2   = $5500;  kbShiftF3   = $5600;
  kbShiftF4   = $5700;  kbShiftF5   = $5800;  kbShiftF6   = $5900;
  kbShiftF7   = $5A00;  kbShiftF8   = $5B00;  kbShiftF9   = $5C00;
  kbShiftF10  = $5D00;  kbCtrlF1    = $5E00;  kbCtrlF2    = $5F00;
  kbCtrlF3    = $6000;  kbCtrlF4    = $6100;  kbCtrlF5    = $6200;
  kbCtrlF6    = $6300;  kbCtrlF7    = $6400;  kbCtrlF8    = $6500;
  kbCtrlF9    = $6600;  kbCtrlF10   = $6700;  kbAltF1     = $6800;
  kbAltF2     = $6900;  kbAltF3     = $6A00;  kbAltF4     = $6B00;
  kbAltF5     = $6C00;  kbAltF6     = $6D00;  kbAltF7     = $6E00;
  kbAltF8     = $6F00;  kbAltF9     = $7000;  kbAltF10    = $7100;
  kbCtrlPrtSc = $7200;  kbCtrlLeft  = $7300;  kbCtrlRight = $7400;
  kbCtrlEnd   = $7500;  kbCtrlPgDn  = $7600;  kbCtrlHome  = $7700;
  kbCtrlUp = 36320;  kbCtrlDown = 37344;
  kbAltUp = 38912;   kbAltDown = 40960;
  kbAlt1      = $7800;  kbAlt2      = $7900;  kbAlt3      = $7A00;
  kbAlt4      = $7B00;  kbAlt5      = $7C00;  kbAlt6      = $7D00;
  kbAlt7      = $7E00;  kbAlt8      = $7F00;  kbAlt9      = $8000;
  kbAlt0      = $8100;  kbAltMinus  = $8200;  kbAltEqual  = $8300;
  kbCtrlPgUp  = $8400;  kbAltBack   = $0800;  kbNoKey     = $0000;
}

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
Function GetKey:word;

Procedure ClearBuffer;
Procedure PutKey(IKey : Word);
Function KeyPressed:Boolean;

procedure SetBorder(InB : byte);
procedure SetBorder2(InB : byte); { setpal }
function GetBorder:byte;
procedure CBlink(ya : boolean);
Procedure Cursor(X:boolean);
procedure Vga50; { changes font, doesn't clear screen }

(*******************) Implementation (*******************)

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
   xchg AL,BH
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
   xchg AL,DL
End;

Function WY:Byte;Assembler;
Asm
   mov AH,3
   XOr BH,BH
   Int 10h
   xchg AL,DH
End;

Function CWhere:Word;
begin
  CWhere := WX + WY shl 8;
  {X = lo, Y = hi}
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
   xchg AL,AH
End;

Function getchar:Char;
Assembler;
Asm
   mov AH,10h
   Int 16h
End;

{char = lo, scan = hi}
Function GetKey:word;
assembler;
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

Procedure PutKey(IKey : word);
assembler;
   Asm
      mov AH,5
      mov CX,Ikey
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
  xchg AL,BH
end;

procedure CBlink(ya : boolean);assembler;
asm
  mov AX,1003h
  mov BL,ya
  int 10h
end;

Procedure Cursor(X:boolean);
Begin
  If X then asm
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

procedure Vga50;assembler;
asm
  MOV AH,11h
  MOV AL,12h
  Xor BL,BL
  INT 10h
end;
end.
