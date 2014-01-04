Program MouseMenu;
{attempt at using mouse for a menu}
Uses crt,bdrwin,mouse,utils,mutils;
Const bklr=Cyan;
Var
   txt:Byte;
   wma,wmi:Word;
   minfo:tminfo;
   mwin,
   pwin : bdrwindow;
   Line:Array[1..4]Of Integer;
   
Procedure InitAll;
Begin
   txt:=TextAttr;
   wma:=WindMax; wmi:=WindMin;
   CheckBreak:=False;
   utils.cursor_off;
   TextBackground(bklr);
   ClrScr;
   minfo.nbuttons:=mouse.init;
   With pwin Do Begin
      init(1,30,18,30,5,Yellow+Blue*16,' Procedure ');
      shstatus:=True;
      brdrattr:=White+Blue*16;
   End;
   With mwin Do Begin
      init(1,20,10,14,5,White+Red*16,' Menu ');
      title.Attr:=Yellow+Red*16;
      brdrattr:=LightGreen+Red*16;
      brdrtype:=2;
      tshadow;
      show;
      MLimits;
   End;
End;

Procedure InitMenu;
Begin
   {mouse coords}
   Line[1]:=80;
   Line[2]:=88;
   Line[3]:=96;
   Line[4]:=104;
   mwin.current;
   WriteLn('   Proc 1');
   WriteLn('   Proc 2');
   WriteLn('   Proc 3');
   Write('   Proc 4');
   mouse.ShowCursor;
End;

Procedure Proc(what:String);
Begin
   mouse.hidecursor;
   pwin.title.contents:=what;
   pwin.show;
   WriteLn(what);
   pressanykey(TextAttr);
   pwin.hide(bklr);
   mouse.ShowCursor;
End;

Procedure Menu;
Var CH:Char;
Begin
   CH:=#255;
   Repeat
      If leftbutton Then Begin
         With minfo Do Begin
            leftclick(count,X,Y);
            If Y=Line[1] Then proc(' Proc 1 ')
            Else If Y=Line[2] Then proc(' Proc 2 ')
            Else If Y=Line[3] Then proc(' Proc 3 ')
            Else If Y=Line[4] Then proc(' Proc 4 ');
         End;
      End;
      If KeyPressed Then Begin
         CH:=ReadKey;
         If CH<>#0 Then
            Case CH Of
               '1':proc(' Proc 1 ');
               '2':proc(' Proc 2 ');
               '3':proc(' Proc 3 ');
               '4':proc(' Proc 4 ');
            End
         Else Begin
            CH:=ReadKey;
            Case CH Of
               #120:proc(' Proc 1 ');
               #121:proc(' Proc 2 ');
               #122:proc(' Proc 3 ');
               #123:proc(' Proc 4 ');
            End;
         End;
      End;
   Until (rightbutton) Or (CH=#24) Or (CH=#27);
End;

Begin
   InitAll;
   InitMenu;
   Menu;
   utils.cursor_on;
   mouse.hidecursor;
   WindMin:=wmi; WindMax:=wma;
   TextAttr:=txt;
   ClrScr;
End.

