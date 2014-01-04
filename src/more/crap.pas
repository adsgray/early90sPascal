uses crt,shwin,bdrwin,utils;

var
 bw:bdrwindow;
 aw:shwindow;
 origmode:word;

procedure Init;
begin
 origmode:=lastmode;
 textmode(259); {80x50}
 with bw do begin
   init(1,6,3,60,18,yellow+lightblue shl 4,'Window 1');
   shclr:=magenta;
   tshadow;
   brdrtype:=2;
   title.attr:=white+red shl 4;
   brdrattr:=red+lightred shl 4;
 end;
 with aw do begin
   init(1,5,26,70,21,lightblue+yellow shl 4);
   tshadow;
   shclr:=magenta;
 end;
 textattr:=lightmagenta shl 4;
 clrscr;
end;

begin
 Init;
 blinkm(false);
 bw.show;
 aw.show;
 bw.current;
 readln;
 bw.hide(lightmagenta);
 aw.current;
 readln;
 bw.show;
 aw.current;
 readln;
 blinkm(true);
 textmode(origmode);
end.

