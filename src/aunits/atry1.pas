Program atry1;

Uses ascreen2,acrt;

Const
  backg:Word = 176 + (Red + Blue ShL 4) ShL 8;
Var
  oldexit : pointer;
  save_screen : tSaveScreen;
  
Procedure Finish; Far;
Begin
  ExitProc := oldexit;
  restoreinfo(save_screen);
End;

Procedure SetUpScreen;
Begin
  fillscr(TextScreen, backg);
  tattr := Red + Blue ShL 4;
  borderwindow(2);
  Window(10,5,70,20);
  fillwin(176 + (Blue + Red ShL 4) ShL 8);
  tattr := Yellow + Cyan ShL 4;
  borderwindow(3);
End;

Procedure dostuff;
Var
  s1,s2,s3 : String;
Begin
  SetUpScreen;
  getkey;
End;

Begin
  oldexit := ExitProc;
  ExitProc := @Finish;
  saveinfo(save_screen);
  dostuff;
End.
