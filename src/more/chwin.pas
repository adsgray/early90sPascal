Unit ChWin;
interface uses AButn,BdrWin,ATxt;
type
 PChWindow=^ChWindow;
 ChWindow=object(BdrWindow)
   Button1,
   Button2   : AButton;
   procedure Show; Virtual;
   function LeftPos:Byte;
   function RightPos(what:string):Byte;
   function Bottom:byte;
 end;

Implementation
procedure ChWindow.Show;
begin
 BdrWindow.Show;
 Button1.Show;
 Button2.Show;
end;

Function ChWindow.LeftPos:Byte;
begin
 LeftPos:=coords.x1+4;
end;

Function ChWindow.RightPos(what:string):Byte;
begin
 RightPos:=coords.x2-(length(what)+7);
end;

Function ChWindow.Bottom:byte;
begin
 Bottom:=coords.y2-3;
end;
end.
{ This procedure should be copied and used to init. other
  ChWindows...
Procedure InitWin;
Begin
   omode:=LastMode;
   TextMode(259);
   minfo.nbuttons:=mouse.init;
   With temp Do Begin
      init(0,4,4,70,40,Yellow+Blue ShL 4,' Demo Button Window ');
      shclr:=Cyan;
      shstatus:=True;
      brdrattr:=Yellow+Red ShL 4;
      brdrtype:=2;
      title.Attr:=White+Red ShL 4;
      current;
      MLimits;
      With button1 Do Begin
         init(0,temp.coords.X1+5,temp.coords.Y2-3,5,5,White+Red ShL 4);
         {5 from left, 3 from bottom}
         Bnotpressed.init('OK!',1,1,White+Red ShL 4);
         autoset;
         BPressed.Attr:=LightGray ShL 4;
      End;
      With button2 Do Begin
         init(0,temp.coords.X2-10,temp.coords.Y2-3,5,5,White+Red ShL 4);
         {10 from right, 3 from bottom}
         Bnotpressed.init('EXIT',1,1,White+Red ShL 4);
         autoset;
         BPressed.Attr:=LightGray ShL 4;
      End;
      Show;
   End;
   cursor_off;
   mouse.ShowCursor;
End;           }
