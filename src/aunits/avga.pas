Unit AVGA;

(***********************) Interface (***********************)

Type
 aScreen = Array[1..200,1..320] of byte;
 pScreen = ^aScreen;
 PalRec = record
   r,g,b:byte;
 end;
 aPalette = Array[0..255] of PalRec;
 pPalette = ^aPalette;

const { size constants }
  ScreenSize = sizeof(aScreen);
  PalSize = sizeof(aPalette);

{ give the client program access to
  VGA memory, and the save buffers. }
var
 PsavescreenVGA : pScreen;
 VGAscreen : aScreen absolute $A000:0;
 Psavepalette : pPalette;

Procedure SetPal(c,r,g,b : byte);
procedure GetPal(var IPalr : PalRec; c : byte);
Procedure InitVGA;
Procedure CloseVGA;
procedure savescreen;
procedure restorescreen;
procedure SavePalette;
procedure RestorePalette;
procedure GetPalette(PalBuf : pPalette);
procedure SetPalette(PalBuf : pPalette);
Procedure GetImage(X1,Y1,X2,Y2:Integer;P:Pointer);
Procedure PutImage(X1,Y1:Integer;P:Pointer);
procedure cls(scr : pScreen);
procedure retrace;
procedure flip(srcscr, destscr : pScreen);
procedure PutPixel(X,Y : word; clr : byte);
procedure Circle( xCtr, yCtr, rad : word; clr : byte);
procedure line(x, y, x2, y2 : word; clr : byte);
PROCEDURE load_pcx(dx, dy : WORD; name : STRING);

(*******************) Implementation (*********************)

Procedure SetPal(c,r,g,b : byte);
Begin
  port[968] := c;
  port[969] := r;
  port[969] := g;
  port[969] := b;
end;

procedure GetPal(var IPalr : PalRec; c : byte);
begin
  port[967] := c;
  IPalr.r := port[969];
  IPalr.g := port[969];
  IPalr.b := port[969];
end;

Procedure InitVGA;
assembler;
asm
  mov AX,13h
  int 10h
end;

procedure CloseVGA;
assembler;
asm
  mov AX,3
  int 10h
end;

procedure savescreen;
begin
  move(VGAscreen,PsavescreenVGA^,ScreenSize);
end;

procedure restorescreen;
begin
  move(PsavescreenVGA^,VGAscreen,ScreenSize);
end;

procedure GetPalette(PalBuf : pPalette);
var ct:byte;
begin
  for ct := 0 to 255 do begin
    port[967] := ct;
    PalBuf^[ct].r := port[969];
    PalBuf^[ct].g := port[969];
    PalBuf^[ct].b := port[969];
  end;
end;

procedure SetPalette(PalBuf : pPalette);
var ct:byte;
begin
  for ct := 0 to 255 do begin
    port[968] := ct;
    port[969] := PalBuf^[ct].r;
    port[969] := PalBuf^[ct].g;
    port[969] := PalBuf^[ct].b;
  end;
end;

procedure SavePalette;
begin
  GetPalette(Psavepalette);
end;
   
procedure RestorePalette;
begin
  SetPalette(Psavepalette);
end;

Procedure GetImage(X1,Y1,X2,Y2:Integer;P:Pointer);
assembler;
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

Procedure PutImage(X1,Y1:Integer;P:Pointer);
assembler;
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

procedure cls(scr : pScreen);
assembler;
asm
        les di,scr
        xor ax,ax
        mov cx,320*200/2
        rep stosw
end;

procedure retrace;
assembler;
asm
        mov dx,03dah
@vert1: in al,dx
        test al,8
        jnz @vert1
@vert2: in al,dx
        test al,8
        jz @vert2
end;

procedure flip(srcscr, destscr : pScreen);
assembler;
{copy screen}
asm
        push ds
        lds si,srcscr
        les di,destscr
        mov cx,320*200/2
        rep movsw
        pop ds
end;

procedure PutPixel(X,Y : word; clr : byte);
begin
  VGAscreen[y,x] := clr;
end;

procedure Circle( xCtr, yCtr, rad : word; clr : byte);
var
    x, y, d   : integer;
begin
  x := 0;
  y := rad;
  d := 2 * (1 - rad);

  while (y >= 0) do
    begin
      PutPixel(xCtr + x, yCtr + y, clr);
      PutPixel(xCtr + x, yCtr - y, clr);
      PutPixel(xCtr - x, yCtr + y, clr);
      PutPixel(xCtr - x, yCtr - y, clr);
      if (d + y > 0) then
        begin
          y := y - 1;
          d := d - (2 * y * 320 div 200) - 1;
        end;
      if (x > d) then
        begin
          x := x + 1;
          d := d + (2 * x) + 1;
        end
    end;
end;

procedure line(x, y, x2, y2 : word; clr : byte);
var
     i, sx, sy, dx, dy, e : integer;
     steep                : boolean;
begin
     steep     := False;
     if x2 > x then
       begin
         sx := 1;
         dx := x2 - x;
       end
     else
       begin
         sx := -1;
         dx := x-x2;
       end;
     if y2 > y then
       begin
         sy := 1;
         dy := y2 - y;
       end
     else
       begin
         sy := -1;
         dy := y - y2;
       end;

     if dy > dx then
       begin
         steep := True;
         x  := x XOR y;  { swap x and y }
         y  := y XOR x;
         x  := x XOR y;
         dx := dx XOR dy; { swap dx and dy }
         dy := dy XOR dx;
         dx := dx XOR dy;
         sx := sx XOR sy; { swap sx and sy }
         sy := sy XOR sx;
         sx := sx XOR sy;
      end;

      e := 2 * dy - dx;
      for i := 0 to (dx-1) do
        begin
          if steep then
              PutPixel(y, x, clr)
          else
              PutPixel(x, y, clr);

          while e >= 0 do
            begin
              y := y + sy;
              e := e - 2 * dx;
            end;

          x := x + sx;
          e := e + 2 * dy;
        end;
    PutPixel(x2, y2, clr);
end;

PROCEDURE load_pcx(dx, dy : WORD; name : STRING);
VAR q                          : FILE;        { Quellendatei-Handle         }
    b                          : ARRAY[0..2047] OF BYTE;  { Puffer          }
    anz, pos, c, w, h, e, pack : WORD;        { diverse benîtigte Variablen }
    x, y                       : WORD;        { fÅr die PCX-Laderoutine     }

LABEL ende_background;                        { Sprungmarken definieren     }

BEGIN
  x := dx; y := dy;                           { Nullpunkt festsetzen        }

  ASSIGN(q, name); {$I-} RESET(q, 1); {$I+}   { Quellendatei îffnen         }
  IF IORESULT <> 0 THEN                       { Fehler beim ôffnen?         }
    GOTO ende_background;                     { Ja: zum Ende springen       }

  BLOCKREAD(q, b, 128, anz);                  { Header einlesen             }

  IF (b[0] <> 10) OR (b[3] <> 8) THEN         { wirklich ein PCX-File?      }
  BEGIN
    CLOSE(q);                                 { Nein: Datei schlie·en und   }
    GOTO ende_background;                     {       zum Ende springen     }
  END;

  w := SUCC((b[9] - b[5]) SHL 8 + b[8] - b[4]);  { Breite auslesen          }
  h := SUCC((b[11] - b[7]) SHL 8 + b[10] - b[6]);  { Hîhe auslesen          }

  pack := 0; c := 0; e := y + h;
  REPEAT
    BLOCKREAD(q, b, 2048, anz);

    pos := 0;
    WHILE (pos < anz) AND (y < e) DO
    BEGIN
      IF pack <> 0 THEN
      BEGIN
        FOR c := c TO c + pack DO
          MEM[SEGA000:y*320+(x+c)] := b[pos];
        pack := 0;
      END
      ELSE
        IF (b[pos] AND $C0) = $C0 THEN
          pack := b[pos] AND $3F
        ELSE
        BEGIN
          MEM[SEGA000:y*320+(x+c)] := b[pos];
          INC(c);
        END;

      INC(pos);
      IF c = w THEN                           { letzte Spalte erreicht?     }
      BEGIN
        c := 0;                               { Ja: Spalte auf 0 setzen und }
        INC(y);                               {     in die nÑchste Zeile    }
      END;
    END;
  UNTIL (anz = 0) OR (y = e);

  SEEK(q, FILESIZE(q) - 3 SHL 8 - 1);
  BLOCKREAD(q, b, 3 SHL 8 + 1);

  IF b[0] = 12 THEN
    FOR x := 1 TO 3 SHL 8 + 1 DO
      b[x] := b[x] SHR 2;

  PORT[$3C8] := 0;

  FOR x := 0 TO 255 DO
  BEGIN
    PORT[$3C9] := b[x*3+1];
    PORT[$3C9] := b[x*3+2];
    PORT[$3C9] := b[x*3+3];
  END;

  CLOSE(q);

ende_background:
END;

begin
  new(PsavescreenVGA);
  new(Psavepalette);
  { allocate the "save" buffers }
end.

procedure putpixel(r,c : word; c : byte);
Assembler;
{ draws a pixel at (row,col) r,c with colour clr }
Asm
   mov AH,0Ch
   mov AL,clr
   mov CX,r
   mov DX,c
   Int 10h
End; { putpixel }
