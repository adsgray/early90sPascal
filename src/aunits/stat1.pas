uses astat;

procedure Display(var a:tData);
var
  ct : longint;
  lct : byte;
begin
  lct := 0;
  for ct := 1 to a.count do begin
    inc(lct);
    write(a.data[ct]:5);
    if lct > 8 then begin
      lct := 0;
      writeln;
    end;
  end;
end;

