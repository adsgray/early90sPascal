Unit NWin;
Interface Uses Shwin,ATxt;
Type
   PNWindow=^NWindow;
   NWindow=Object(ShWindow)
      HNote,
      FNote  : AText;
      Shrunk : Boolean;
      Procedure SetUp;
      Procedure Show; Virtual;
   End;
   
Implementation Uses Crt;
Procedure NWindow.SetUp;
Var wma,wmi:Word;
Begin
   wma:=WindMax;
   wmi:=WindMin;
   current;
   HNote.SetCoords(HNote.XCenter,1);
   FNote.SetCoords(FNote.XCenter,Bline+2);
   WindMax:=wma;
   WindMin:=wmi;
End;

Procedure NWindow.Show;
Begin
   If shrunk Then Begin grow(1); shrunk:=False; End;
   ShWindow.Show;
   HNote.Show;
   FNote.Show;
   shrink(1);
   Shrunk:=True;
   current;
End;
End. {NWin}
