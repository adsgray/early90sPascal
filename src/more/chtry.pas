Program ChTry;
{test of the ChWindow object (buttons etc...)}
Uses
   ChWin, ATxt, Mouse, Utils, MUtils, CRT, SCSave;

Var
   temp  : chwindow;
   minfo : tminfo;
   omode : Word;
   CH    : Char;
   wx, wy : byte;
   sc     : screenptr;
   
Procedure InitWin;
Begin
   wx:=wherex;
   wy:=wherey;
   omode:=LastMode;
   new(sc);
   sc^:=curscreen^; {save screen}
   omode:=LastMode;
   TextMode(259);

   minfo.nbuttons:=mouse.init;
   With temp Do Begin
      init(0,4,4,40,40,Yellow+Blue ShL 4,'Blah Blah Blah');
      shclr:=Cyan;
      shstatus:=True;
      brdrattr:=Yellow+Red ShL 4;
      brdrtype:=2;
      title.Attr:=White+Red ShL 4;
      current;
      MLimits;
      With button1 Do Begin
         init(0,leftpos,Bottom,1,1,White+Green ShL 4);
         {5 from left, 3 from bottom}
         Bnotpressed.init('OK',1,1,White+Green ShL 4);
         autoset;
         BPressed.Attr:=LightGray ShL 4;
      End;
      With button2 Do Begin
         init(0,rightpos('blah'),Bottom,1,1,White+Red ShL 4);
         {10 from right, 3 from bottom}
         Bnotpressed.init('EXIT',1,1,White+Red ShL 4);
         autoset;
         BPressed.Attr:=LightGray ShL 4;
      End;
      Show;
   End;
   cursor_off;
   mouse.ShowCursor;
End;

Procedure EndProc;
Begin
   temp.button2.showpressed;
   mouse.hidecursor;
   cursor_on;
   TextMode(omode);
   curscreen^:=sc^; {restore screen}
   gotoxy(wx,wy-1);
   Halt;
End;

Procedure WriteOK;
Begin
   temp.current;
   temp.respos;
   Write(' OK! ');
   temp.savepos;
End;

Begin
   InitWin;
   Repeat
      If leftbutton Then
         With minfo Do Begin
            leftclick(count,X,Y);
            If temp.button1.ispressed(X,Y) Then Begin
               temp.button1.showpressed;
               writeOK;
               {Doesn't really need to be there, but if you keep clicking
               on OK!, the lines will scroll down to the buttons...}
            End
            Else If temp.button2.ispressed(X,Y) Then EndProc;
         End
      Else If KeyPressed Then Begin
         Case ReadKey Of
            #13 : WriteOK;
            #27 : EndProc;
            #0  : CH:=ReadKey;
         End;
      End;
   Until 1>2; {Endless loop...}
End.
