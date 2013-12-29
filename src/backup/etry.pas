{$R-,D-,I-}
Uses
  amouse,
  aevent,
  acrt,
  ascreen;

Const
  xmax = 79;
  ymax = 49;
  
Var
  event : tEvent;
  oldexit : pointer;
  
Procedure Done; Far;
Begin
  ExitProc := oldexit;
  amouse.show(false);
  Cursor (True);
  Cblink (True);
  vmode (3);
  Write ('Error(', ExitCode, '): ');
  Case ExitCode Of
    0 : WriteLn ('Escape pressed.');
    5 : WriteLn ('Mouse not found.');
    255 : WriteLn ('Ctrl-Break pressed.');
    else writeln('Unknown error.');
  End;
End;

Procedure mouse_update;
Var
  sx, sy : Byte;
Begin
  sx := wx;
  sy := wy;
  goxy (73, 0);
  Write ('(', amouse. twherex: 2, ',', amouse. twherey: 2, ')');
  goxy (sx, sy);
End;

Procedure Rand_Wins;
Var
  ev_temp : tEvent;
  X1, Y1,
  X2, Y2   : Byte;
Begin
  Repeat
    X1 := Random (80);
    Y1 := Random (25);
    X2 := X1 + Random (xmax Div 2);
    Y2 := Y1 + Random (ymax Div 2);
    Window (X1, Y1, X2, Y2);
    tattr := Random (256);
    ClrScr;
    GetEvent (ev_temp);
  Until (ev_temp.what <> enothing);
  Window (0, 0, xmax, ymax);
End;

Procedure b_switch (Var b1, b2: Byte);
Var
  temp : Byte;
Begin
  temp := b1;
  b1 := b2;
  b2 := temp;
End;

Procedure dragwindow (X1, Y1: Byte);
Var
  X2, Y2 : Byte;
  ev_temp : tEvent;
Begin
  Repeat
    GetEvent (ev_temp);
    mouse_update;
  Until (ev_temp. what <> emouse);
  X2 := amouse. Twherex;
  Y2 := amouse. Twherey;
  If X1 > X2 Then b_switch (X1, X2);
  If Y1 > Y2 Then b_switch (Y1, Y2);
  Window (X1, Y1, X2, Y2);
  tattr := Random (256);
  amouse. show(false);
  ClrScr;
  amouse. show(true);
  Window (0, 0, xmax, ymax);
End;

procedure mouse_draw;
var
 ev_temp : tEvent;
begin
  repeat
    GetEvent(ev_temp);
    amouse.show(false);
    word(TextScreen[amouse.twherey,amouse.twherex]) := random($FFFF);
    amouse.show(true);
    mouse_update;
  until (ev_temp.what <> eMouse);
end;

procedure FillScr(var tscr : ttextscreen; inch : word);
var x,y:byte;
begin
  for y := 0 to 49 do
    for x := 0 to 79 do
      word(tscr[y,x]) := inch;
end;

Begin
  oldexit := ExitProc;
  ExitProc := @Done;
  If Not amouse. init Then Halt (5);
  VGA50;
  Cursor (False);
  Cblink (False);
  Window (0, 0, xmax, ymax);
  amouse. show(true);
  Randomize;
  Repeat
    Repeat
      getevent (event);
      mouse_update;
    Until event.what <> enothing;
    Case event.what Of
      ekeyboard : 
                  Begin
                    Case event.ekey.sc Of
                      { C }  46: Begin
                                   tattr := Random (256);
                                   amouse. show(false);
                                   ClrScr;
                                   amouse. show(true);
                                   goxy (0, 0);
                                 End;
                      { W }  17: Rand_Wins;
                      { F }  33: begin
                                   amouse.show(false);
                                   FillScr(TextScreen,random($FFFF));
                                   amouse.show(true);
                                 end;
                      Else With event. ekey Do
                        WriteLn ('keyboard: (', ch: 3, ',', sc: 3, ')  (', hard: 5, ')');
                    End;
                  End;
      emouse    : if event.whichb = mLeft then
                    With event. minfo Do dragwindow(tx,ty)
                  else mouse_draw;
    End;
  Until (event.what  = ekeyboard) And (event.ekey.sc = 1);
End.
