unit aBitMap;

(******************) Interface (******************)
Const
  { Bit Constants }
  Bit0=1;Bit1=2;Bit2=4;Bit3=8;
  Bit4=16;Bit5=32;Bit6=64;Bit7=128;
  Bit8=256;Bit9=512;Bit10=1024;
  Bit11=2048;Bit12=4096;Bit13=8192;
  Bit14=16384;Bit15=32768;

Type
  TBitMap8x8 = array [1..8] of Byte;
  TBitMap16x16 = array [1..16] of Word;

  TPoint = record X,Y : Word; end;
  OBaseBitMap = object
    Base : TPoint;
    Colour : Byte;
  end;

  OBitMap8x8 = object(OBaseBitMap)
    BitMap : TBitMap8x8;
    procedure Show;
    procedure Hide(IC : Byte);    { colour }
    private
    procedure PutRow(Row,C:byte); { row and colour }
  end;

  OBitMap16x16 = object(OBaseBitMap)
    BitMap : TBitMap16x16;
    procedure Show;
    procedure Hide(IC : Byte);      { colour }
    private
    procedure PutRow(Row,C : byte); { row and colour }
  end;

(******************) Implementation (******************)
Type
 aScreen = Array[1..200,1..320] of byte;
var
 VGAScreen : aScreen absolute $A000:0;

procedure PutPixel(x,y:word;c:byte);
begin
  VGAScreen[y,x] := c;
end;

procedure OBitMap8x8.PutRow(Row,C:byte);
var
  temp,
  ct:byte; { counter }
begin
  Temp := BitMap[Row];
  for ct := 0 to 7 do begin
    if temp and Bit7 = Bit7 then
      putpixel(Base.X + ct,Base.Y + (row - 1),C);
    temp := temp shl 1;
  end;
end;

procedure OBitMap8x8.Hide(IC : Byte);
var ct:byte; { counter }
begin
  for ct := 1 to 8 do PutRow(ct,IC);
end;

procedure OBitMap8x8.Show;
begin
  Hide(Colour);
end;

procedure OBitMap16x16.PutRow(Row,C:byte);
var
  temp : word;
  ct:byte; { counter }
begin
  Temp := BitMap[Row];
  for ct := 0 to 15 do begin
    if temp and Bit15 = Bit15 then
      putpixel(Base.X + ct,Base.Y + (row - 1),C);
    temp := temp shl 1;
  end;
end;

procedure OBitMap16x16.Hide(IC : Byte);
var ct:byte; { counter }
begin
  for ct := 1 to 16 do PutRow(ct,IC);
end;

procedure OBitMap16x16.Show;
begin
  Hide(Colour);
end;
end.
