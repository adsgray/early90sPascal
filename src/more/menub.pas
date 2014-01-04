Unit MenuB;

Interface Uses ShWin;

Type
   MenuBox=Object(ShWindow)
      options : Array [1..10] Of String[20];
      barattr,
      NumOptions,
      LastPos : Byte;
      Procedure Show; Virtual;
      Procedure Size;
      Function choose(escallow:Boolean):Byte;
   Private
      barlength : Byte;
      Function MaxOptLen:Byte;
      Procedure PadOptions;
   End;
   
Implementation Uses CRT, KeyFilt; {getkey}

Function MenuBox.MaxOptLen:Byte;
Var ct,t:Byte;
Begin
   t:=0;
   For ct:=1 To numoptions Do
      If Length(options[ct])>t Then t:=Length(options[ct]);
   MaxOptLen:=t;
End;

Procedure MenuBox.PadOptions;
var ct:Byte;
begin
 for ct:=1 to numoptions do
  if options[ct][1]<>#32 then options[ct]:=#32+options[ct];
end;

Procedure MenuBox.Size;
{ options and numoptions should have values now.
  Use ShWindow.Init to set upper left coord of window,
  the other coordinates will be stretched to fit around the
  options text }
Begin
   LastPos:=1;
   PadOptions;
   BarLength:=MaxOptLen+1;
   With coords Do setcoords(1,X1,Y1,BarLength-1,NumOptions+1);
End;

Procedure MenuBox.Show;
Var ct:Byte;
Begin
   ShWindow.Show;
   WriteLn;
   For ct:=1 To numoptions Do WriteLn(options[ct]);
End;

Function MenuBox.Choose(escallow:Boolean):Byte;
Procedure ShowBar(which:Byte);
Begin
   GotoXY(1,lastpos+1);
   TextAttr:=barattr;
   Write(options[lastpos],'':(BarLength-Length(options[lastpos])));
End;

Procedure BarUp;
Begin
   GotoXY(1,lastpos+1);
   TextAttr:=Attr;
   Write(options[lastpos],'':(BarLength-Length(options[lastpos])));
   If lastpos-1>=1 Then
      lastpos:=lastpos-1
   Else
      lastpos:=numoptions;
End;

Procedure BarDown;
Begin
   GotoXY(1,lastpos+1);
   TextAttr:=Attr;
   Write(options[lastpos],'':(BarLength-Length(options[lastpos])));
   If lastpos+1<=numoptions Then
      lastpos:=lastpos+1
   Else
      lastpos:=1;
End;

Var
   CH      : Char;
   ext     : Boolean;
   NFilter : filtertype;
   
Begin
   {with coords do window(x1,y1,x2+1,y2);}
   current;
   If escallow Then NFilter:=[Enter,Esc] Else NFilter:=[Enter];
   Repeat
      showbar(lastpos);
      getkey(CH,NFilter,[up,down],ext);
      If ext Then
         Case CH Of
            up:barup;
            down:bardown;
         End;
   Until (Not ext);
   If CH=esc Then choose:=0 Else choose:=lastpos;
End;
End.
