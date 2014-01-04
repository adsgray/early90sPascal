Uses
   CRT, MenuB, Utils;

Var
   mb  : menubox;
   opt : Byte;
   
Begin
   cursor_off;
   blinkm(False);
   
   With mb Do Begin
      init(1,35,10,1,1,Yellow+LightRed ShL 4);
      barattr:=Black+Yellow ShL 4;
      numoptions:=6;
      options[1]:='  Load';
      options[2]:='  Save';
      options[3]:='  Edit';
      options[4]:=' Display';
      options[5]:=' Min/Max';
      options[6]:='  Exit';
      Size; {set up size of window}
      Show;
   End;
   
   Repeat;
      opt:=mb.choose(True);
      { the TRUE means ESC can be used to exit the menu.
      If ESC is used to exit the menu, 0 is returned by
      choose }
   Until opt In [0,6];
   
   cursor_on;
   blinkm(True);
End.
