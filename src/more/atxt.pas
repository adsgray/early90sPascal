Unit ATxt;
Interface
Type
   PosStat=Record
      {Cursor Coordinates}
      X,Y:Byte;
   End;
   ATextt=String[80];
   AText=Object
      Contents:ATextt;   { Text }
      Attr:Byte;         { textattr of Text }
      coords:PosStat;    { location of Text }
      Procedure Init(InCon:Atextt; ix,iy,Iattr:Byte);
      Procedure Show;
      Procedure Hide(Iattr:Byte);
      Procedure SetCoords(ix,iy:Byte);
      Function XCenter:Byte;
      Procedure SetCon(InCon:Atextt);
      Procedure GotoFront;
   End; {AText}
   
Function YCenter:Byte;
{returns the Y coordinate of
 the center of the current window }

Function BLine:Byte;
{Bottom Line: returns the in-window Y-Coordinate of
 the bottom line of the current window }

Implementation Uses crt;
Function BLine:Byte;
Begin
   BLine:=(Hi(WindMax)-Hi(WindMin))+1;
End; {Bline}

Function YCenter:Byte;
Begin
   YCenter:=(Hi(WindMax)-Hi(WindMin))Div(2)+1
End; {YCenter}

Procedure AText.Init(InCon:Atextt; ix,iy,Iattr:Byte);
Begin
   Attr:=Iattr;
   With coords Do Begin X:=ix; Y:=iy; End;
   Contents:=InCon;
End; {Init}


Procedure AText.SetCoords(ix,iy:Byte);
Begin
   With coords Do Begin X:=ix; Y:=iy; End;
End; {SetCoords}


Procedure AText.GotoFront;
Begin
   With coords Do GotoXY(X,Y);
End; {GotoFront}


Procedure AText.Show;
Var temp:Byte;
   {save textattr}
Begin
   temp:=TextAttr;
   TextAttr:=Attr;
   With coords Do GotoXY(X,Y);
   Write(Contents);
   TextAttr:=temp;
End; {Show}

    
Procedure AText.Hide(Iattr:Byte);
Var b,temp:Byte;
   {save textattr}
Begin
   temp:=TextAttr;
   TextBackground(Iattr);
   With coords Do GotoXY(X,Y);
   For b:=1 To Length(contents) Do Write(' ');
   TextAttr:=temp;
End; {Hide}

Procedure AText.SetCon(InCon:Atextt);
Begin
   contents:=InCon;
End; {SetCon}

Function AText.XCenter:Byte;
Var X1,X2:Byte;
Begin
   X1:=Lo(WindMin);
   X2:=Lo(WindMax);
   XCenter:=(X2-X1)Div(2)-(Length(Contents))Div(2)+2;
End; {XCenter}
End. {ATxt}
