uses ascreen;

procedure text_replace;
var
  x,y : byte;
begin
  for x := 0 to 24 do
    for y := 0 to 80 do
      if TextScreen[x,y].ch <> #32 then
        byte(TextScreen[x,y].ch) := random($FF);
end;

procedure new_attr;
var
  x,y,attr:byte;
begin
  attr := random($FF);
  attr := attr and not 128;
  for x := 0 to 24 do
    for y := 0 to 80 do
      TextScreen[x,y].at := attr;
end;

begin
  randomize;
  new_attr;
  text_replace;
end.
