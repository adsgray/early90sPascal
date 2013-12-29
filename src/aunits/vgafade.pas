Unit VGAfade;
(************) Interface (************)
uses AVGA;
procedure Fadeout;
procedure fadein(var ToPal : aPalette);
procedure FadetoPal(var ToPal : aPalette);

(************) Implementation (************)
procedure Fadeout;
var
  i,j,r,g,b:byte;

begin
  for i:=63 downto 0 do    (* there is 64 RGB levels per color *)
  begin
      retrace;retrace;
      for j:=0 to 255 do    (* an VGA has a 255 colour palette *)
      begin

        port[$3C7]:=j;      (* get RBG of a color *)
        r:=port[$3C9];
        g:=port[$3C9];
        b:=port[$3C9];

        if r>0 then dec(r); (* we DEC it until zero *)
        if g>0 then dec(g);
        if b>0 then dec(b);

        port[$3C8]:=j;      (* set RGB of a color *)
        port[$3C9]:=r;
        port[$3C9]:=g;
        port[$3C9]:=b;
      end;
  end;
end;



procedure fadein(var ToPal : aPalette);
  var i,r,g,b,j : byte;
begin
 for i:=0 to 63 do
 begin
 retrace;retrace;
 for j:=0 to 255 do
  begin
    port[$3C7]:=j;
    r:=port[$3C9];
    g:=port[$3C9];
    b:=port[$3C9];
    if r<ToPal[j].r then inc(r);
    if g<ToPal[j].g then inc(g);
    if b<ToPal[j].b then inc(b);
    port[$3C8]:=j;
    port[$3C9]:=r;
    port[$3C9]:=g;
    port[$3C9]:=b;
  end;
 end;
end;

procedure FadetoPal(var ToPal : aPalette);
{ fades from current palette to ToPal }
var
  t : palrec;
  i,j : byte;
begin
  for i := 0 to 63 do begin
    retrace;retrace;
    for j := 0 to 255 do begin
      port[$3c7] := j;
      t.r := port[$3c9];
      t.g := port[$3c9];
      t.b := port[$3c9];
      if t.r<ToPal[j].r then inc(t.r);
      if t.g<ToPal[j].g then inc(t.g);
      if t.b<ToPal[j].b then inc(t.b);
      if t.r>ToPal[j].r then dec(t.r);
      if t.g>ToPal[j].g then dec(t.g);
      if t.b>ToPal[j].b then dec(t.b);
      with t do setpal(j,r,g,b);
    end;
  end;
end;
end.
