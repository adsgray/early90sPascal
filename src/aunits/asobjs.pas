unit asobjs;
{ A ScreenOBJectS }

Interface
uses ascreen2;
type
  bdrwin = object
    btype,
    battr,
    attr   : byte;
    wmi, wma : word;
    constructor init(x1,y1,x2,y2,iattr,ibattr,ibtype : byte);
    destructor done;
    procedure Show; virtual;
    procedure Hide(inch : word); virtual;
    procedure Current;
  end;
  pbdrwin = ^bdrwin;

type
  Titlewin = object(bdrwin)
    title : string;
    titleattr : byte;
    procedure show; virtual;
  end;
  ptitlewin = ^titlewin;

type
  shadwin = object(titlewin)
    showshadow : boolean;
    shadowcell : word; { tcell format }
    procedure show; virtual;
    procedure hide(inch : word); virtual;
  end;
  pshadwin = ^shadwin;

const
  MaxOptions = 15;
  MaxOptLen = 30;

type
  tOptions = array [1..MaxOptions] of string[MaxOptLen];
  pOptions = ^tOptions;

  menuwin = object(shadwin)
    curoption,
    numoptions,
    barattr : byte;
    Options : pOptions;
    Constructor Init(x1,y1,iattr,ibattr,brtype:byte);
    procedure InitOptions(inNUM : byte);
    Destructor Done;
    procedure show; virtual;
    procedure Setup;
    function choice:byte;
  end;
  pmenuwin = ^menuwin;

type
  scr = object
    contents : ttextscreen;
    pos,wmi,wma : word;
    attr : byte;
    procedure Save;
    procedure Restore;
  end;
  pscr = ^scr;

Implementation
uses acrt;
constructor bdrwin.init(x1,y1,x2,y2,iattr,ibattr,ibtype : byte);
begin
  btype := ibtype; battr := ibattr;
  attr := iattr;
  wmi := x1 + y1 shl 8;
  wma := x2 + y2 shl 8;
end;

procedure bdrwin.current;
begin
  tattr := attr;
  windmax := wma; windmin := wmi;
  inc(crec(windmin).x); inc(crec(windmin).y);
  dec(crec(windmax).x); dec(crec(windmax).y);
  with crec(windmin) do goxy(x,y);
end;

destructor bdrwin.done;
begin
end;

procedure bdrwin.show;
begin
  windmin := wmi; windmax := wma;
  tattr := battr;
  borderwindow(btype);
  inc(crec(windmin).x); inc(crec(windmin).y);
  dec(crec(windmax).x); dec(crec(windmax).y);
  tattr := attr;
  clrscr;
end;

procedure bdrwin.Hide(inch : word);
begin
  windmin := wmi;
  windmax := wma;
  fillwin(inch);
end;

procedure titlewin.show;
var
  centerpos : byte;
begin
  inherited show;
  if ord(title[0]) > 0 then begin
    centerpos := (crec(windmin).x-1) +
    ( ((xwid+1)div 2) - (ord(title[0]) div 2));
    tattr := titleattr;
    awritexy(centerpos,wy-1,title,false);
    tattr := attr;
  end;
end;

procedure ShadWin.show;
var
  t:string[80];
  ct : byte;
begin
  inherited show;
  if showshadow then begin
    fillchar(t,81,tcell(shadowcell).ch);
    t[0] := chr(xwid+2);
    tattr := tcell(shadowcell).at;
    awritexy(crec(windmin).x,crec(windmax).y+2,t,false);
    for ct := 0 to ywid +1 do
      awritechxy(crec(windmax).x+2,crec(windmin).y+ct,
        tcell(shadowcell).ch,false);
  end;
end;

procedure ShadWin.Hide(inch:word);
var
  t:string[80];
  ct : byte;
begin
  inherited hide(inch);
  fillchar(t,81,tcell(inch).ch);
  t[0] := chr(xwid);
  tattr := tcell(inch).at;
  awritexy(crec(windmin).x+1,crec(windmax).y+1,t,false);
  for ct := 1 to ywid do
    awritechxy(crec(windmax).x+1,crec(windmin).y + ct,
      tcell(inch).ch,false);
end;

Constructor MenuWin.Init(x1,y1,iattr,ibattr,brtype:byte);
begin
  wmi := x1 + y1 shl 8;
  attr := iattr;
  battr := ibattr;
  btype := brtype;
end;

destructor MenuWin.Done;
begin
  if options <> nil then dispose(options);
end;

procedure MenuWin.InitOptions(inNUM : byte);
begin
  new(options);
  numoptions := inNUM;
  curoption := 1;
end;

procedure MenuWin.Show;
var ct : byte;
begin
  inherited show;
  tattr := attr;
  for ct := 1 to numoptions do begin
    awrite(options^[ct],false);
    nextline;
  end;
end;

procedure MenuWin.Setup;
var
  ct,
  HighLen : byte;
begin
  HighLen := 0;
  for ct := 1 to NumOptions do
    if byte(options^[ct][0]) > HighLen then
      HighLen := byte(options^[ct][0]);
  crec(wma).x := crec(windmin).x + HighLen + 5;
  crec(wma).y := crec(windmin).y + NumOptions + 5;
end;

function MenuWin.Choice:byte;
procedure ShowBar;
var t : string[MaxOptLen];
begin
  with crec(windmin) do
    goxy(x,y+curoption-1);
  tattr := barattr;
  awrite(options^[curoption],true);
  fillchar(t,maxoptlen+1,32);
  byte(t[0]) := xwid - byte(options^[curoption][0]);
  if byte(t[0]) > 1 then
    awrite(t,false);
end;

procedure HideBar;
var t : string[MaxOptLen];
begin
  with crec(windmin) do
    goxy(x,y + curoption-1);
  tattr := attr;
  awrite(options^[curoption],true);
  fillchar(t,maxoptlen,32);
  byte(t[0]) := xwid - byte(options^[curoption][0]);
  if byte(t[0]) > 1 then
    awrite(t,false);
end;

procedure BarUp;
begin
  HideBar;
  if curoption - 1 >= 1 then
    dec(curoption)
  else curoption := numoptions;
  ShowBar;
end;

procedure BarDown;
begin
  HideBar;
  if curoption + 1 <= numoptions then
    inc(curoption)
  else curoption := 1;
  ShowBar;
end;

const
  kup = 72; kdown = 80;
  khome = 71; kend = 79;

var
  Key : krec;
begin
  ShowBar;
  repeat
    word(key) := getkey;
    case key.sc of
      kup : BarUp;
      kdown : BarDown;
      khome : begin
                HideBar;
                curoption := 1;
                ShowBar;
              end;
      kend : begin
               HideBar;
               curoption := numoptions;
               ShowBar;
             end;
    end;
  until (key.sc = 1) or (key.ch = #13);
  if (key.sc = 1) then
    choice := 0
  else
    choice := curoption;
end;

procedure scr.save;
begin
  wmi := windmin; wma := windmax;
  attr := tattr; pos := cwhere;
  copyscr(textscreen,contents);
end;

procedure scr.restore;
begin
  windmin := wmi; windmax := wma;
  tattr := attr;
  copyscr(contents,textscreen);
  with crec(pos) do goxy(x,y);
end;
end.
