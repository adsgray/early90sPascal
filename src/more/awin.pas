Unit AWin;
{  Screen objects
   Andrew Gray    }

Interface
Type
   Wcoordt=Record
      {Window Coordinates}
      X1,Y1,X2,Y2:Byte;
   End;
   
   PosStat=Record
      {Cursor Coordinates}
      X,Y:Byte;
   End;
   
   { Only one style of shadow is supported }
   PAWindow=^AWindow;
   AWindow=Object
      Attr:Byte;         { fore/back of window                   }
      coords:Wcoordt;    { the coordinates of the window         }
      Pos:PosStat;       { the cursor position inside the window }
      Constructor Init(WType:byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte);
      Procedure Shrink(Num:Byte);
      Procedure Grow(Num:Byte);
      Procedure SetCoords(WType:byte;Ix1,Iy1,Ix2,Iy2:Byte); Virtual;
      Procedure Clear; Virtual;{Show}
      Procedure Show; Virtual;
      Procedure Current; Virtual;
      Procedure Hide(Iattr:Byte); Virtual;
      Procedure SavePos;
      Procedure ResPos;
      Procedure SetPos(ix,iy:Byte);
   End; {Awindow}
   
Implementation Uses crt;
Procedure AWindow.SetPos(ix,iy:Byte);
Begin
   With Pos Do Begin
      X:=ix;Y:=iy; 
   End;
End; {SetPos}


Procedure AWindow.SetCoords(WType:byte;Ix1,Iy1,Ix2,Iy2:Byte);
Begin
   Case WType Of
      0 :
      Begin
         coords.X1:=Ix1;
         coords.Y1:=Iy1;
         coords.X2:=Ix2;
         coords.Y2:=Iy2;
      End; {c}
      1 :
      Begin
         coords.X1:=Ix1;
         coords.Y1:=Iy1;
         coords.X2:=Ix1+Ix2;
         coords.Y2:=Iy1+Iy2;
      End; {s}
   End; {case}
End; {SetCoords}


Constructor AWindow.Init(WType:byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte);
Begin
   Attr:=Iattr;
   setcoords(WType,Ix1,Iy1,Ix2,Iy2);
   setpos(1,1); {Init. cursor position}
End; {AWindow.Init}


Procedure AWindow.Clear; {show}
Begin
   TextAttr:=Attr;
   With coords Do Window(X1,Y1,X2,Y2);
   ClrScr;
End; {Clear}

Procedure AWindow.Show;
Begin
   clear;
End; {Show}


Procedure AWindow.Current;
Begin
   TextAttr:=Attr;
   With coords Do Window(X1,Y1,X2,Y2);
End; {Current}


Procedure AWindow.Hide(Iattr:Byte);
Begin
   TextAttr:=Iattr ShL 4;
   With coords Do Window(X1,Y1,X2,Y2);
   ClrScr;
End; {Hide}


Procedure AWindow.SavePos;
Begin
   With Pos Do Begin
      X:=WhereX;
      Y:=WhereY;
   End; {with}
End; {SavePos}


Procedure AWindow.ResPos;
Begin
   Current;
   With Pos Do GotoXY(X,Y);
End; {ResPos}


Procedure AWindow.Shrink(Num:Byte);
Begin
   With coords Do setcoords(0,X1+Num,Y1+Num,X2-Num,Y2-Num);
End; {Shrink}


Procedure AWindow.Grow(Num:Byte);
Begin
   With coords Do setcoords(0,X1-Num,Y1-Num,X2+Num,Y2+Num);
End; {Grow}
End. {AWin}
