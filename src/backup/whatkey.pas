uses acrt;
var
  key:krec;

begin
  repeat
    word(key) := getkey;
    writeln('ch: ',ord(key.ch),'  sc: ',key.sc,'     ',key.hard);
  until key.sc = 1;
end.
