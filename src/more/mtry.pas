Uses AMouse,ascreen,crt;
Var
  MData : AMouseData;
  Mx,My : byte;
  IC    : char;
  origmode : word;

const
  drawing:boolean = false;
  dclick = 250;
  bclr = Yellow;
  maxstyles = 7;
  styles : array [1..maxstyles] of char =
           (#219,#176,#177,#178,'*','#','@');
  curstyle : byte = 1;

Begin
   randomize;
   origmode := lastmode;
   textmode(259);
   {asm mov ah,0; mov al,13h; int 10h; end;}

   AMouse.Init;
   CBlink(false);
   TextAttr := LightBlue + bclr ShL 4;
   setborder(lightblue);
   ClrScr;
   Cursor(false);
   crt.GotoXY(20,2);
   Write('GO TO UPPER RIGHT CORNER TO QUIT');
   AMouse.Show;
   Mx := 1;
   My := 1;
   AMouse.tGotoXY(Mx,My);

   Repeat
      MData.tX := AMouse.tWhereX; MData.tY := AMouse.tWhereY;

      With MData Do If (tX <> Mx) or (tY <> My) then begin
        Mx := tX; My := tY;
        If drawing Then Begin
           crt.gotoxy(Mx,My);
           Write(styles[curstyle]);
        End;
        crt.GotoXY(30,1);
        Write(tX,',',tY,' ');
      End

      Else If leftpressed Then Begin
         crt.GotoXY(30,3);
         Write('L: ',amouse.gwhereX,',',amouse.gwhereY,'      ');
         delay(dclick);
         LeftPressData(MData);
         While leftpressed Do;
         if MData.Count = 2 then drawing := not drawing;
      End

      Else If rightpressed Then Begin
         crt.GotoXY(30,3);
         Write('R: ',amouse.gwhereX,',',amouse.gwhereY,'      ');
         delay(dclick);
         RightPressData(MData);
         While leftpressed Do;
         if MData.Count = 2 then clrscr;
      End

      Else If KeyPressed then begin
        IC := upcase(readkey);

        case IC of
          'F' : if drawing then begin
                   if curstyle + 1 <= maxstyles then
                      inc(curstyle)
                   else curstyle := 1;
                end;
          'D' : drawing := not drawing;
          'C' : clrscr;
          'A' : textattr := random(8) + 1 + bclr shl 4;
          'H' : AMouse.hide;
          'S' : AMouse.show;
          #0  : while readkey = #0 do;
        end;

      End;

   Until ((AMouse.tWhereX = 80) And (AMouse.tWhereY = 1)) Or
         (IC = #27);

   AMouse.Hide;
   TextMode(origmode);
   Cursor(true);
End.
