Unit BdrWin;
Interface Uses Shwin,ATxt;
Type
   PBdrWindow=^BdrWindow;
   BdrWindow=Object(ShWindow)
      Title : AText;
      BrdrAttr,
      BrdrType  : Byte;
      Shrunk : Boolean;
      Constructor Init(WType:Byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte;cont:ATextt);
      Procedure Show; Virtual;
      Procedure Clear; Virtual;
      Procedure Current; Virtual;
      Procedure Hide(Iattr:Byte); Virtual;
   End;
   
Implementation Uses crt;
Constructor BdrWindow.Init(WType:Byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte;cont:ATextt);
Begin
   ShWindow.Init(WType,ix1,iy1,ix2,iy2,iattr);
   Title.Attr:=IAttr;
   Title.SetCon(cont);
   BrdrAttr:=Iattr;
   BrdrType:=1;
   Shrunk:=False;
End; {Init}

Procedure BdrWindow.Show;
Var
   b, xw, yw:Byte;
   Brdr:Array[1..6] Of Char;
   l,r : Char;
   
Begin
   If shstatus Then
      If shrunk Then Begin
         grow(1);
         showshadow;
         shrink(1);
      End
   Else showshadow;
   ShWindow.Show;
   TextAttr:=brdrattr;
   Case BrdrType Of
      1:
      Begin
         Brdr[1]:='É'; Brdr[2]:='Í'; Brdr[3]:='»';
         Brdr[4]:='º'; Brdr[5]:='È'; Brdr[6]:='¼';
         l:='µ';   r:='Æ';
      End;
      2:
      Begin
         Brdr[1]:='Ú'; Brdr[2]:='Ä'; Brdr[3]:='¿';
         Brdr[4]:='³'; Brdr[5]:='À'; Brdr[6]:='Ù';
         l:='´';   r:='Ã';
      End;
      3:
      Begin
         Brdr[1]:='Õ'; Brdr[2]:='Í'; Brdr[3]:='¸';
         Brdr[4]:='³'; Brdr[5]:='Ô'; Brdr[6]:='¾';
         l:='µ';   r:='Æ';
      End;
      4:
      Begin
         Brdr[1]:='Ö'; Brdr[2]:='Ä'; Brdr[3]:='·';
         Brdr[4]:='º'; Brdr[5]:='Ó'; Brdr[6]:='½';
         l:='´';   r:='Ã';
      End;
      5:
      Begin
         Brdr[1]:='+'; Brdr[2]:='-'; Brdr[3]:='+';
         Brdr[4]:='|'; Brdr[5]:='+'; Brdr[6]:='+';
         l:='|';   r:='|';
      End;
      8:
      Begin
         Brdr[1]:='²'; Brdr[2]:='²'; Brdr[3]:='²';
         Brdr[4]:='²'; Brdr[5]:='²'; Brdr[6]:='²';
         l:='²';   r:='²';
      End;
      7:
      Begin
         Brdr[1]:='±'; Brdr[2]:='±'; Brdr[3]:='±';
         Brdr[4]:='±'; Brdr[5]:='±'; Brdr[6]:='±';
         l:='±';   r:='±';
      End;
      6:
      Begin
         Brdr[1]:='°'; Brdr[2]:='°'; Brdr[3]:='°';
         Brdr[4]:='°'; Brdr[5]:='°'; Brdr[6]:='°';
         l:='°';   r:='°';
      End;
      9:
      Begin
         Brdr[1]:='Û'; Brdr[2]:='Û'; Brdr[3]:='Û';
         Brdr[4]:='Û'; Brdr[5]:='Û'; Brdr[6]:='Û';
         l:='Û';   r:='Û';
      End;
   End; {case}
   If Shrunk Then Begin grow(1); Shrunk:=False; End;
   Title.SetCoords(Title.XCenter,1);
   With coords Do Begin
      xw:=X2-X1+1;
      yw:=Y2-Y1+1;
      Window(X1,Y1,X2+1,Y2+1);
   End;
   GotoXY(1,1);
   Write(Brdr[1]);
   For b:=2 To xw-1 Do Write(Brdr[2]);
   Write(Brdr[3]);
   For b:=2 To yw-1 Do Begin
      GotoXY(1,b);
      Write(Brdr[4]);
      GotoXY(xw,b);
      Write(Brdr[4]);
   End;
   GotoXY(1,yw);
   Write(Brdr[5]);
   For b:=2 To xw-1 Do Write(Brdr[2]);
   Write(Brdr[6]);
   With coords Do Window(X1,Y1,X2-1,Y2-1);
   If title.contents<>'' Then
      With title.coords Do Begin
         GotoXY(X-1,Y);
         Write(l);
         GotoXY(X+Length(title.contents),Y);
         Write(r);
      End;
   Title.Show;
   If Not Shrunk Then Begin shrink(1); Shrunk:=True; End;
   ShWindow.current;
End; {Show}

Procedure BdrWindow.Hide(IAttr:Byte);
Begin
   If Shrunk Then Begin grow(1); Shrunk:=False; End;
   If ShStatus Then HideShadow(Iattr);
   TextAttr:=Iattr ShL 4;
   If shstatus Then
      With coords Do Window(X1-1,Y1-1,X2+1,Y2+1) {?}
   Else
      With coords Do Window(X1,Y1,X2,Y2); {?}
   ClrScr;
End; {Hide}

Procedure BdrWindow.Current;
Begin
   If Not Shrunk Then Begin shrink(1); Shrunk:=True; End;
   ShWindow.Current;
End; {Current}

Procedure BdrWindow.Clear;
Begin
   BdrWindow.current;
   ClrScr;
End; {Clear}
End. {BdrWin}
