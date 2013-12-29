unit ascreen2;
interface
const
  Black=0; Blue=1; Green=2; Cyan=3;
  Red=4; Magenta=5; Brown=6; LGray=7;
  DGray=8; LBlue=9; LGreen=10; LCyan=11;
  LRed=12; LMagenta=13; Yellow=14; White=15;
  Blink=128;
type
  scrolltype = (sUP,sDOWN);
type
  tcell = record
    case byte of
      0 : (cell : word);
      1 : (ch : char; at : byte);
  end;
  tTextScreen = array [0..49,0..79] of tcell;
  pTextScreen = ^ttextscreen;
type
  tSaveScreen = record
    save_screen : tTextScreen;
    save_mode : byte;
    save_border : byte;
    save_pos : word;
  end;
  pSaveScreen = ^tSaveScreen;
const
  textscreensize = sizeof(ttextscreen);
type
  tborder = array [1..6] of char;
  pborder = ^tborder;
const
  tborders : array [1..4] of tborder =
  ((#201,#205,#187,#186,#200,#188),
   (#218,#196,#191,#179,#192,#217),
   (#213,#205,#184,#179,#212,#190),
   (#214,#196,#183,#186,#211,#189));

var
  TextScreen : tTextScreen absolute $b800:0;
{  WriteScr   : pTextScreen; }
  WindMin,
  WindMax    : Word;
  Tattr      : byte;

procedure aWrite(what : string; repos : boolean);
procedure aWriteXY(x,y : byte; what : string; repos : boolean);
procedure awritech(ch : char; repos : boolean);
procedure awritechxy(x,y : byte; ch:char; repos : boolean);
procedure NextLine;
procedure ClrScr;
Procedure Window(X1,Y1,X2,Y2 : byte);
procedure Scroll(whichway : scrolltype;nlines : byte);
function ywid : byte;
function xwid : byte;
procedure borderwindow(brtype : byte);
procedure CopyScr(var source,dest : ttextscreen);
procedure FillScr(var tscr : ttextscreen; inch : word);
procedure FillWin(inch : word);
procedure Cls(var tscr : ttextscreen; inattr : byte);
procedure SaveInfo(var s : tSaveScreen);
procedure RestoreInfo(var s : tSaveScreen);
function getstr(max : byte):string;


implementation
uses acrt;
procedure aWrite(what : string; repos : boolean);
var
  x,y,
  ct : byte;

begin
  x := wx;
  y := wy;
  for ct := 0 to ord(what[0])-1 do
    TextScreen[y,ct+x].cell := ord(what[ct+1]) + tattr shl 8;
  if repos then goxy(x+ord(what[0]),y);
end;

procedure aWriteXY(x,y : byte; what : string; repos : boolean);
var ct : byte;
begin
  for ct := 0 to ord(what[0])-1 do
    TextScreen[y,ct+x].cell := ord(what[ct+1]) + tattr shl 8;
  if repos then goxy(x+ord(what[0]),y);
end;

procedure awritech(ch : char; repos : boolean);
var x,y : byte;
begin
  x := wx; y := wy;
  TextScreen[y,x].cell := ord(ch) + tattr shl 8;
  if repos then goxy(x+1,y);
end;

procedure awritechxy(x,y : byte; ch:char; repos : boolean);
begin
  TextScreen[y,x].cell := ord(ch) + tattr shl 8;
  if repos then goxy(x+1,y);
end;

procedure NextLine;
begin
  with crec(windmin) do goxy(x,wy+1);
end;

Procedure Window(X1,Y1,X2,Y2 : byte);
begin
  WindMin := x1 + y1 shl 8;
  WindMax := x2 + y2 shl 8;
  with crec(windmin) do goxy(x,y);
end;

procedure Scroll(whichway : scrolltype;nlines : byte);
begin
  if whichway = sUP then asm
    mov ah,6
  end else asm
    mov ah,7
  end;
  asm
    push bp
    mov al,nlines
    mov cx,windmin
    mov dx,windmax
    mov bh,tattr
    int 10h
    pop bp
  end;
end;

Procedure ClrScr;
begin
  scroll(sUP,0);
  with crec(windmin) do goxy(x,y);
end;

function ywid : byte;
begin
  ywid := crec(windmax).y - crec(windmin).y +1;
end;

function xwid : byte;
begin
  xwid := crec(windmax).x - crec(windmin).x +1;
end;

procedure borderwindow(brtype : byte);
var
  temp : string[81];
  ct,
  xw,yw : byte;
  brdr : pborder;
begin
  brdr := @tborders[brtype];
  xw := xwid; yw := ywid;
  fillchar(temp,xwid,brdr^[2]);
  temp[0] := chr(xwid);
  temp[1] := brdr^[1];
  temp[xwid] := brdr^[3];
  with crec(windmin) do awritexy(x,y,temp,false);
  temp[1] := brdr^[5];
  temp[xwid] := brdr^[6];
  awritexy(crec(windmin).x,crec(windmax).y,temp,false);
  for ct := crec(windmin).y+1 to crec(windmax).y-1 do begin
    TextScreen[ct,crec(windmin).x].cell := ord(brdr^[4]) + tattr shl 8;
    TextScreen[ct,crec(windmax).x].cell := ord(brdr^[4]) + tattr shl 8;
  end;
end;


procedure CopyScr(var source,dest : ttextscreen);
begin
  move(source,dest,textscreensize);
end;

procedure FillScr(var tscr : ttextscreen; inch : word);
var x,y:byte;
begin
  for y := 0 to 49 do
    for x := 0 to 79 do
      tscr[y,x].cell := inch;
end;

procedure Cls(var tscr : ttextscreen; inattr : byte);
begin
  FillScr(tscr,32 + tattr shl 8);
end;

procedure FillWin(inch : word);
var x,y,xofs,yofs : byte;
begin
  xofs := crec(windmin).x;
  yofs := crec(windmin).y;
  for x := 0 to xwid-1 do
    for y := 0 to ywid-1 do
      TextScreen[y+yofs,x+xofs].cell := inch;
end;

procedure SaveInfo(var s : tSaveScreen);
begin
  with s do begin
    save_mode := curmode;
    save_border := getborder;
    save_pos := cwhere;
    copyscr(TextScreen,save_screen);
  end;
end;

procedure RestoreInfo(var s : tSaveScreen);
begin
  with s do begin
    vmode(save_mode);
    setborder(save_border);
    copyscr(save_screen,TextScreen);
    with crec(save_pos) do goxy(x,y);
  end;
end;

function getstr(max : byte):string;
var
  whst : string;
  key : krec;
  insertf : boolean;
  row,
  idx,
  startpos : byte;

procedure UpDate;
begin
  goxy(startpos,row);
  write(whst+#32);
  goxy(startpos + idx-1,row);
end;

begin
  whst := '';
  insertf := true;
  row := wy;
  startpos := wx;
  idx := 1;
  repeat
    word(key) := getkey;
    if (key.ch = #224) or (key.ch = #0) then case key.sc of
       75 : if (ord(whst[0]) > 0) and (idx > 1) then begin
                dec(idx);
                write(#8);
              end;
       77 : if idx < ord(whst[0]) then begin
                write(whst[idx]);
                inc(idx);
              end;
       82 : insertf := not insertf;
       71 : begin
                goxy(startpos,row);
                idx := 1;
              end;
       79 : begin
                idx := ord(whst[0])+1;
                goxy(startpos + idx-1,row);
              end;
       83 : begin
                delete(whst,idx,1);
                UpDate;
              end;
       116 : begin
            {    idx := pos(#32,copy(whst,idx-1,ord(whst[0])-idx))+1;
                goxy(startpos + idx-1,row); }
              end;
       115 : begin
              end;
    end else
      case key.ch of
        #08 : if ord(whst[0]) > 0 then
              if insertf then begin
                write(#8#32#8);
                if idx = ord(whst[0])+1 then
                  dec(byte(whst[0]))
                else
                  whst[idx-1] := #32;
                dec(idx);
              end
              else begin
                if ord(whst[0]) > 0 then begin
                  dec(idx);
                  delete(whst,idx,1);
                  update;
                end;
              end;
        #27 : ;
        #13 : ;
        else if insertf then begin
                 if ord(whst[0]) > idx-1 then begin
                   write(key.ch);
                   whst[idx] := key.ch;
                   inc(idx);
                 end
                 else if ord(whst[0]) < max then begin
                   whst := whst + key.ch;
                   write(key.ch);
                   inc(idx);
                 end
               end else begin
                 if ord(whst[0]) < max then begin
                   insert(key.ch,whst,idx);
                   inc(idx);
                   UpDate;
                 end;
               end;
      end;
  until (key.ch = #27) or (key.ch = #13);
  writeln;
  if key.ch = #27 then getstr := '' else getstr := whst;
end;

begin
{  WriteScr := @textscreen; }
  windmin := 0;
  windmax := 79 + 24 shl 8;
  tattr := lgray;
end.
