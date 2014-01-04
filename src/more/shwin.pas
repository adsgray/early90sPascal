Unit ShWin;
{  Screen objects
   Andrew Gray    }

Interface Uses AWin;
Type
   PShWindow=^ShWindow;
   ShWindow=Object(AWindow)
      shclr:Byte;        { the colour of the shadow              }
      shcoords:Wcoordt;  { the coordinates of the window shadow  }
      ShStatus:Boolean;  { whether shadow is active              }
      Constructor Init(WType:byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte);
      Procedure SetCoords(WType:byte;Ix1,Iy1,Ix2,Iy2:Byte); Virtual;
      Procedure Clear; Virtual;{Show}
      Procedure Show; Virtual;
      Procedure Hide(Iattr:Byte); Virtual;
      Procedure HideShadow(bklr:Byte);
      Procedure ShowShadow;
      Procedure TShadow;
   End; {ShWindow}
   
Implementation Uses crt;
Procedure ShWindow.TShadow;
Begin
   ShStatus:=Not ShStatus;
End; {Tshadow}

Procedure ShWindow.HideShadow(bklr:Byte);
Var
   tempx,tempy:Byte;
Begin
   { the manual (sloppy) way }
   { self.savepos;
   self.hide(bklr);
   self.setshadow(off);
   self.show;
   self.respos; }
   
   tempx:=WhereX; tempy:=WhereY;
   TextAttr:=bklr ShL 4;
   Window(coords.X2+1,shcoords.Y1,shcoords.X2,coords.Y2);
   ClrScr;
   Window(shcoords.X1,coords.Y2+1,shcoords.X2,shcoords.Y2);
   ClrScr;
   current;
   GotoXY(tempx,tempy);
End; {HideShadow}


Procedure ShWindow.ShowShadow;
Var
   tt,tempx,tempy:Byte;
Begin
   tempx:=WhereX; tempy:=WhereY;
   tt:=TextAttr;
   TextAttr:=shclr ShL 4;
   Window(coords.X2+1,shcoords.Y1,shcoords.X2,coords.Y2);
   ClrScr;
   Window(shcoords.X1,coords.Y2+1,shcoords.X2,shcoords.Y2);
   ClrScr;
   current;
   GotoXY(tempx,tempy);
   TextAttr:=tt;
End; {ShowShadow}


Procedure ShWindow.SetCoords(WType:byte;Ix1,Iy1,Ix2,Iy2:Byte);
Begin
   AWindow.SetCoords(WType,Ix1,Iy1,Ix2,Iy2);
   shcoords.X1:=coords.X1+1;
   shcoords.Y1:=coords.Y1+1;
   shcoords.X2:=coords.X2+1;
   shcoords.Y2:=coords.Y2+1;
End; {SetCoords}


Constructor ShWindow.Init(WType:byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte);
Begin
   AWindow.Init(WType,Ix1,Iy1,Ix2,Iy2,Iattr);
   shclr:=Black; {default shadow colour}
   ShStatus:=False;
End; {ShWindow.Init}


Procedure ShWindow.Clear; {show}
Begin
   If ShStatus Then showshadow;
   AWindow.Clear;
End; {Clear}

Procedure ShWindow.Show;
Begin
   clear;
End; {Show}


Procedure ShWindow.Hide(Iattr:Byte);
Begin
   If ShStatus Then HideShadow(Iattr);
   AWindow.Hide(Iattr);
End; {Hide}
End. {ShWin}
