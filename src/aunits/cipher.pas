unit cipher;

Interface
type
  tTextBuf = array [1..$FFFF] of byte;
  pTextBuf = ^tTextBuf;

procedure Cipherstr(var inBuf : tTextBuf; bufsize,rands:word);

Implementation
procedure Cipherstr(var inBuf : tTextBuf; bufsize, rands : word);
var
  ct : word;
begin
  randseed := rands;
  for ct := 1 to bufsize do
    inbuf[ct] := inbuf[ct] xor random(200);
end;

end.
