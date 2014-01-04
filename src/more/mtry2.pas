Program MTry2;
Uses amouse,acrt;

const big:boolean = false;

Procedure WriteDot;

  Procedure ppxl(r,c : Word; clr : Byte);
  Assembler;
  Asm
     mov AH,0Ch
     mov AL,clr
     mov CX,r
     mov DX,c
     Int 10h
  End;

  Var
    c : Byte;
    x,y:word;

Begin
   c := Random(32) {+ 128};
   x := gwherex; y := gwherey;
   ppxl(x,y,c);
   if big then begin
      ppxl(x+1,y,c);
      ppxl(x-1,y,c);
      ppxl(x,y-1,c);
      ppxl(x,y+1,c);
      ppxl(x+1,y+1,c);
      ppxl(x-1,y-1,c);
      ppxl(x+1,y-1,c);
      ppxl(x-1,y+1,c);
   end;
End;

{ Type coordt = Record
      X, Y : Integer;
  End; }

Var
{  last : coordt; }
   origmode : Byte;
{  ss : screenptr; }
   
Const
   vm = $10;
   xlim = 639;
   ylim = 479;
   ICh : char = #2;

procedure ClearV;
begin
   amouse.hide;
   vmode(vm);
   amouse.show;
end;

Begin
{   new(ss);
   ss^ := curscreen^; }
   if not amouse.init then halt(1);
   origmode := CurMode;
   vmode(vm);
   Randomize;
   setborder2(Random(256));
   amouse.show;
{   With last Do Begin
      X := gwherex; Y := gwherey;
   End; }

   Repeat
    { If (last.X <> gwherex) Or (last.Y <> gwherey) Then Begin
         last.X := gwherex; last.Y := gwherey;
         goxy(0,0);
         Write(last.X,',',last.Y,'    ');
      End; }
      If leftpressed Then
       { If (gwherex = xlim) And (gwherey = ylim) Then
            Randomize
         Else }
            WriteDot Else
      If rightpressed Then
       { If (gwherex = xlim) And (gwherey = ylim) Then
            ClearV
         Else }
            setborder2(Random(256));
      if keypressed then begin
         ICh := getscancode;
         case ICh of
           { c } #46 : ClearV;
           { h } #35 : Hide;
           { s } #31 : Show;
           { r } #19 : randomize;
           { d } #32 : WriteDot;
           { p } #25 : setborder2(Random(256));
           { b } #48 : big := not big;
         end;
      end;
   Until ICh = {Esc}#1;
   
   vmode(origmode);
{  curscreen^ := ss^;
   goxy(0,23); }
End.
