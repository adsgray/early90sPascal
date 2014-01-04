uses acrt;
var IK : keytype;
begin
  repeat
    getkey(IK);
    writeln('Char: ',ord(IK.ccode),' ...  Scan: ',ord(IK.scode));
  until IK.scode = #1;
end.