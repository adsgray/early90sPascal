uses akbd,acrt;

function ShiftPressed:boolean;
begin
  ShiftPressed := bitson(kb1,rsp) or bitson(kb1,lsp);
end;

function AltPressed:boolean;
begin
  AltPressed := bitson(kb1,ap);
end;

function CtrlPressed:boolean;
begin
  CtrlPressed := bitson(kb1,cp);
end;

begin
  switchbit(kb1,scon or numon or capson);
  cursor(false);
  repeat
    if shiftpressed then begin
      goxy(5,0);
      write('SHIFT');
    end else begin
      goxy(5,0);
      write('     ');
    end;
    if altpressed then begin
      goxy(20,0);
      write('ALT');
    end else begin
      goxy(20,0);
      write('   ');
    end;
    if ctrlpressed then begin
      goxy(40,0);
      write('CTRL');
    end else begin
      goxy(40,0);
      write('    ');
    end;         
  until ShiftPressed and AltPressed and CtrlPressed;
  switchbit(kb1,scon or numon or capson);
  cursor(true);
end.
