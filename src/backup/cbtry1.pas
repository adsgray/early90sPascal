uses cbreak,acrt,ascreen2;

var
  sc : byte;
  save_screen : tSaveScreen;

begin
  saveinfo(save_screen);
  clrscr;
  cursor(false);
  sc := 0;
  repeat
  {  if keypressed then  } sc := getscan;
    if ctrlbreakpressed then begin
      ctrlbreakpressed := false;
      goxy(30,0);
      write('Ctrl-Break pressed!');
    end else begin
      goxy(30,0);
      write('                   ');
    end;
  until sc = 1;
  cursor(true);
  restoreinfo(save_screen);
end.
