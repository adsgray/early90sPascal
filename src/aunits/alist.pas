unit alist;
interface
const
  xmax = 78;
type
  prec = ^trec;
  trec = record
    line : string[xmax];
    next,prev : prec;
  end;
const
  recsize = sizeof(trec);
type
  tlist = record
    first,last : prec;
  end;

procedure InitList(var list : tlist);
procedure DoneList(var list : tlist);
procedure NewLast(var list : tlist);
procedure LoadIn(var list : tlist;var flname : string);
procedure ViewList(var list : tlist);

implementation
uses acrt,ascreen2;

procedure InitList(var list : tlist);
begin
  with list do begin
    first := nil; last := nil;
  end;
end;

procedure DoneList(var list : tlist);
var cur : prec;
begin
  cur := list.first;
  while cur <> list.last do begin
    cur := cur^.next;
    dispose(cur^.prev);
  end;
  if cur <> nil then begin
    dispose(cur^.prev); dispose(cur);
  end;
end;

procedure NewLast(var list : tlist);
begin
  with list do begin
    new(last^.next);
    last^.next^.prev := last;
    last := last^.next;
  end;
end;

procedure LoadIn(var list : tlist;var flname : string);
var f : text;
begin
  assign(f,flname);
  reset(f);
  if list.first = nil then begin
    new(list.first);
    list.first^.next := nil;
    list.first^.prev := nil;
    list.last := list.first;
    if (not eof(f)) and (memavail >= recsize) then
      readln(f,list.first^.line);
  end;
  while (not eof(f)) and (memavail >= recsize) do begin
    newlast(list);
    readln(f,list.last^.line);
  end;
  close(f);
  if memavail >= recsize then begin
    newlast(list);
    list.last^.line :=
    '*** END OF FILE ***';
  end;
  list.last^.next := list.first;
  list.first^.prev := list.last;
end;

procedure ViewList(var list : tlist);
const
  kup=72; kdown=80;
  kpgup=73; kpgdn=81;
  khome=71; kend=79;
var
  ymax,
  tct : byte;
  pagetop,pagebottom,
  cur : prec;
  key : krec;
begin
  ymax := ywid;
  cur := list.first;
  pagetop := cur;
  for tct := 1 to ymax do begin
    if length(cur^.line) > 0 then awrite(cur^.line,false);
    nextline;
    cur := cur^.next;
  end;
  pagebottom := cur^.prev;
  repeat
    word(key) := getkey;
    case key.sc of
      kup : begin
               scroll(sDOWN,1);
               pagetop := pagetop^.prev;
               pagebottom := pagebottom^.prev;
               if length(pagetop^.line) > 0 then
                 with crec(windmin) do
                   awritexy(x,y,pagetop^.line,false);
             end;
      kdown : begin
                 scroll(sUP,1);
                 pagetop := pagetop^.next;
                 pagebottom := pagebottom^.next;
                 if length(pagebottom^.line) > 0 then
                   awritexy(crec(windmin).x,crec(windmax).y,
                            pagebottom^.line,false);
               end;
      kpgup : begin
                pagebottom := pagetop;
                for tct := 1 to ymax-1 do
                  pagetop := pagetop^.prev;
                cur := pagetop;
                clrscr;
                for tct := 1 to ymax do begin
                  if length(cur^.line) > 0 then
                    awrite(cur^.line,false);
                  nextline;
                  cur := cur^.next;
                end;
              end;
      kpgdn : begin
                pagetop := pagebottom;
                for tct := 1 to ymax-1 do
                  pagebottom := pagebottom^.next;
                cur := pagetop;
                clrscr;
                for tct := 1 to ymax do begin
                  if length(cur^.line) > 0 then
                    awrite(cur^.line,false);
                  nextline;
                  cur := cur^.next;
                end;
              end;
      khome : begin
                pagetop := list.first;
                pagebottom := pagetop;
                for tct := 1 to ymax-1 do
                  pagebottom := pagebottom^.next;
                cur := pagetop;
                clrscr;
                for tct := 1 to ymax do begin
                  if length(cur^.line) > 0 then
                    awrite(cur^.line,false);
                  nextline;
                  cur := cur^.next;
                end;
              end;
      kend  : begin
                pagebottom := list.last;
                pagetop := pagebottom;
                for tct := 1 to ymax-1 do
                  pagetop := pagetop^.prev;
                cur := pagetop;
                clrscr;
                for tct := 1 to ymax do begin
                  if length(cur^.line) > 0 then
                    awrite(cur^.line,false);
                  nextline;
                  cur := cur^.next;
                end;
              end;
    end;
  until key.sc = 1;
end;

end.
