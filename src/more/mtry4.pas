uses amouse,acrt;
type
  CoRec = record
     X,Y : word;
  end;

  PicArray = Array [1 .. 20 * 2] of Integer;
  PicRec = {array of points, and the number of points (up to 40)}
   record
     Pic : PicArray;
     NPoints : Byte;
     clr : Byte;
   end;

var
  omode : byte;
  pos : CoRec;
  TPic : PicRec;

procedure InitS;
begin
  randomize;
  if not amouse.init then halt(1);
  with pos do begin X := gwherex; Y := gwhereY; end;
  with TPic do begin
    Pic[1] := pos.X;
    Pic[2] := pos.Y;
    NPoints := 20;
    pic[3] := -1;
    pic[4] := 1;
    pic[5] := -2;
    pic[6] := 2;
    pic[7] := -3;
    pic[8] := 3;
    pic[9] := -4;
    pic[10] := 4;

    pic[11] := 3;
    pic[12] := 3;
    pic[13] := 4;
    pic[14] := 4;
    pic[15] := 5;
    pic[16] := 5;
    pic[17] := 6;
    pic[18] := 6;
    pic[19] := 7;
    pic[20] := 7;
    clr := random(256);
  end;
  omode := curmode;
  vmode($12);
end;

Procedure RestoreS;
begin
  vmode(omode);
  halt(0);
end;

Procedure ppxl(r,c : Word; clr : Byte);
Assembler;
Asm
   mov AH,0Ch
   mov AL,clr
   mov CX,r
   mov DX,c
   Int 10h
End;

procedure DrawThing(var InPic : PicRec);
var ct : byte;
    base : CoRec;
begin
  with base do begin
    X := InPic.Pic[1];
    Y := InPic.Pic[2];
  end;
  ppxl(Inpic.pic[1],inpic.pic[2],inpic.clr);
  ct := 3;
  with InPic do while ct < Npoints do begin
    ppxl(base.X + Pic[ct],base.Y + pic[ct+1],clr);
    inc(ct,2);
  end;
end;

begin
 InitS;
 DrawThing(TPic);
 repeat
   if (gwherex <> Pos.X) or (gwherey <> Pos.Y) then begin
     Pos.X := gwhereX;
     Pos.Y := gwhereY;
     TPic.Pic[1] := Pos.X;
     TPic.Pic[2] := Pos.Y;
     if leftpressed then
     DrawThing(TPic);
   end;
   if leftpressed then
     DrawThing(TPic);
   if rightpressed then setborder2(random(256));
   if bothpressed then TPic.clr := random(24);
 until keypressed;
 while getscan = 0 do; {get rid of keys}
 RestoreS;
end.