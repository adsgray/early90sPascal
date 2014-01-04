{$x+}
Unit Utils;
{various utilities}
Interface
Uses atxt;
Var
   ent,
   any :atext;
   
 Procedure PressEnter(WAttr:Byte); {Press Enter}
 {goes to bottom of screen, writes 'Press Enter...' in
  WAttr, waits for Enter to be pressed}

 Procedure PressAnyKey(WAttr:Byte);
 {goes to bottom of screen, writes 'Press Any Key' in
  WAttr, waits for any key to be pressed.
  (Where is that "Any" key anyway?...)}

 Procedure Pause;
 {pauses until a key is pressed}

 Procedure YesNo(Var choice:Char);
 {returns 'Y' or 'N'}

 Procedure cursor_off;
 Procedure cursor_on;
 procedure cursor(huh : boolean);
 Procedure blinkm(blinkon:boolean);

Implementation
Uses keyfilt,
   crt;

Procedure blinkm(blinkon:boolean);
Begin
 asm
  mov ax,1003h
  mov bl,blinkon;
  int 10h
 End
End;

Procedure PressEnter(WAttr:Byte); {Press Enter}
{You must be in the window you want this to appear in}
{ WAttr is the attribute you want the message to appear in.
  *Should just send the attribute of the current window.
   ex PEnter(CurWindow.attr); }
Begin
   ent.attr:=WAttr;
   ent.setcoords(ent.XCenter,bline);
   ent.show;
   { ent.gotofront;}
   keyfilt.pressenter;
End;


Procedure Pause; {redone by IDL using $X extended syntax}
Begin
   Repeat readkey until not keypressed;
End; {Pause}


Procedure PressAnyKey(WAttr:Byte);
Begin
   any.attr:=WAttr;
   any.setcoords(any.XCenter,bline);
   any.show;
   { any.gotofront;}
   pause;
End;


Procedure YesNo(Var choice:Char);
Var
   CH:Char;
Begin
   Repeat
      choice:=UpCase(ReadKey);
      If choice=#0 Then begin
       CH:=ReadKey; {remove next key from buffer}
       ch:=#0; {Y,N might be set now by ACCIDENT from an extended code. This
                is a filter added by IDL for safety}
   Until choice In['Y','N'];
End; {YesNo}

Procedure cursor_off; Begin Inline($b8/$00/$01/$b9/$00/$20/$cd/$10);End;
Procedure cursor_on;  Begin Inline($b8/$00/$01/$b9/$07/$06/$cd/$10);End;
procedure cursor(huh : boolean); begin
 if huh then cursor_on else cursor_off; end;
Begin {INITIALIZATION}
   ent.init('Press ÄÄÙ Enter',1,1,15);
   any.init('Press Any Key',1,1,15);
End.
