Program BTry;
{test for AButton object}
Uses
   AButn,
   CRT,
   Utils,
   Mouse,
   MUtils;

const
  L50 = 259;

Var
   CH : Char;
   B: Array [1..5] Of AButton;
   minfo: TMinfo;
   omode: Word;
   
Procedure Setup;
var temp:byte;
Begin
   omode:=lastmode;
   TextMode(L50);
   blinkm(False);
   TextAttr:=LightCyan ShL 4;
   ClrScr;
   With B[1] Do Begin
      init(0,2,2,5,5,LightRed ShL 4);
      bnotpressed.init('OK',1,1,LightBlue+LightRed ShL 4);
      autoset;
      bpressed.Attr:=LightGreen+LightBlue ShL 4;
      shstatus:=true;
      shclr:=cyan;
   End;
   With B[2] Do Begin
      init(0,10,20,10,10,Yellow ShL 4);
      bnotpressed.init('Cancel',1,1,Black+Yellow ShL 4);
      autoset;
      bpressed.Attr:=Yellow;
      shstatus:=true;
      shclr:=cyan;
   End;
   With B[3] Do Begin
      init(0,15,30,10,10,lightmagenta ShL 4);
      bnotpressed.init('Yodle Loudly',1,1,LightGreen+lightmagenta ShL 4);
      autoset;
      bpressed.Attr:=Yellow+Red ShL 4;
      shstatus:=true;
      shclr:=cyan;
   End;
   With B[4] Do Begin
      init(0,40,10,10,10,LightBlue ShL 4);
      bnotpressed.init('Exit!',1,1,White+LightBlue ShL 4);
      autoset;
      bpressed.Attr:=LightBlue+White ShL 4;
      shstatus:=true;
      shclr:=cyan;
   End;
   With B[5] Do Begin
      init(0,50,35,10,10,White ShL 4);
      bnotpressed.init('Load File',1,1,Black+White ShL 4);
      autoset;
      bpressed.Attr:=White+LightRed ShL 4;
      shstatus:=true;
      shclr:=cyan;
   End;
   for temp:=1 to 5 do b[temp].show;
   cursor_off;
   minfo.nbuttons:=mouse.init;
   mouse.ShowCursor;
End;

Begin
   setup;
   CH:='A';
   Repeat
      If leftbutton Then
         With minfo Do Begin
            leftclick(count,X,Y);
            If B[1].ispressed(X,Y) Then B[1].ShowPressed
            Else If B[2].ispressed(X,Y) Then B[2].ShowPressed
            Else If B[3].ispressed(X,Y) Then B[3].ShowPressed
            Else If B[4].ispressed(X,Y) Then B[4].ShowPressed
            Else If B[5].ispressed(X,Y) Then B[5].ShowPressed
         End
      Else If KeyPressed Then CH:=ReadKey;
   Until rightbutton Or (CH=#27);

   {===================}
   TextMode(omode);
   blinkm(True);
   cursor_on;
   mouse.hidecursor;
   {===================}

End.
