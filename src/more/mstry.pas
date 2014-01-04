Program MSTry;
{Attempt at using mouse}
Uses CRT, Mouse, MUtils, Utils, BdrWin;


Const wait=250; {pause for double-click}
   
Var
   wd       : BdrWindow;
   minfo    : TMinfo;
   ta       : Byte;
   origmode : Word;
   ch       : Char;
   
   
Procedure InitStuff;
{Initialize everything: window, mouse limits, colours, lastmode...}
Begin
   minfo.count:=0; {init press count}
   Randomize;
   origmode:=LastMode; {save textmode}
   ta:=TextAttr;       {save textattr}
   TextMode(259);
   blinkm(false);
   {P. if in 25 line mode, go into 50 line mode}
   TextBackground(cyan); ClrScr;
   If wrec(WindMax).Hi>25 Then
      wd.init(0,2,2,78,48,White+Blue*16,' Mouse Demo  50 Lines ')
   Else wd.init(0,2,2,78,23,White+blue*16,' Mouse Demo  25 Lines ');
   {P. if *still* in 25 line mode (unable to go to 50 line mode), 
   init. a smaller window}
   With wd Do Begin
      shstatus:=true;
      shclr:=black;
      title.attr:=yellow+blue shl 4;
      brdrattr:=white+blue shl 4;
      show;
      shrink(1);
      current;
   End;
   MInfo.NButtons:=Mouse.Init;
   {Init. mouse, get # of buttons}
   MLimits;
   {Set mouse limits to current window}
   wd.grow(1); wd.current;
   Mouse.ShowCursor;
   utils.cursor_off;
End; {InitStuff}


Procedure DisplayInfo;
Var t:Byte;
Begin
   t:=TextAttr; {save textattr}
   TextColor(White);
   writeln;
   WriteLn(' ',minfo.nbuttons,' button mouse.');
   WriteLn(' Double-Click Left Button to Quit.');
   writeln;
   TextAttr:=t; {restore textattr}
End;

Var CX,cy:Integer;
   
Begin {MAIN}
   ch:='A';
   InitStuff;
   DisplayInfo;
   TextColor(Yellow);
   
   (************************************************************)
   {P.repeat
   if left button of mouse pressed then
   pause for WAITms (let user press it again)
   display coords of mouse
   get # of clicks
   right button=random colours
   until double click on left button}
   
   Repeat
      If mouse.leftbutton Then Begin
         Delay(wait);
         Write(' ',mouse.WhereX,',',mouse.WhereY);
         MtoT(mouse.WhereX,mouse.WhereY,CX,cy);
         Write(' ',CX,',',cy);
         With minfo Do leftclick(count,X,Y);
      End
      Else If mouse.rightbutton Then Begin
         Delay(wait);
         With minfo Do rightclick(count,X,Y);
         If minfo.count=2 Then Begin
            mouse.hidecursor;
            TextAttr:=Random(256);
            ClrScr;
            DisplayInfo;
            minfo.count:=1; {reset}
            mouse.ShowCursor;
         End;
      End
     Else if keypressed then ch:=readkey;
   Until (minfo.count=2) or (ch=#27);
   (************************************************************)
   
   Mouse.HideCursor;
   TextMode(origmode); {restore textmode}
   TextAttr:=ta;       {restore textattr}
   utils.cursor_on;
   blinkm(true);
End. {MTry}
