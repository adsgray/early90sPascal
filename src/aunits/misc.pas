{$A+,B-,D+,E-,F-,G+,I-,L+,N-,O+,R-,S+,V-,X+}
Unit misc;
Interface
uses dos;
var
 ticker:longint absolute $40:$6c; {ticks since midnight}
 overtimer:byte absolute $40:$70; {0 until after midnight}
 kbshift:byte absolute $40:$17; {shift key status}
 kbeshift:byte absolute $40:$18; {enhanced shift key status}
 kbstat3:byte absolute $40:$96; {special status 3}
 kbstat2:byte absolute $40:$97; {special status 2}
 resetflag:word absolute $40:$72; {reset status for POST}
Const
 pcburnin=$64; {PC burn in, use with ResetFlag}
 warmboot=$1234; {use with ResetFlag. Coldboot = 0}
 fileonly=$27; {for findfirst}
 empty=$80; {frame Procedure use, clear window setting+border type}
{colors}
 bgmask=$f0;
 fgmask=$f;
 Black=0;
 Blue=1;
 Green=2;
 Cyan=3;
 Red=4;
 Magenta=5;
 Brown=6;
 LGray=7;
 DGray=8;
 LBlue=9;
 LGreen=$a;
 LCyan=$b;
 LRed=$c;
 LMagenta=$d;
 Yellow=$e;
 White=$f;
{extended keys}
 kcUp=#72;     {up key}
 kcDown=#80;   {down key}
 kcLeft=#75;   {left key}
 kcRight=#77;  {rigft key}
 kccleft=#115; {ctrl-lef key}
 kccright=#116;{ctrl-right key}
 kcPgup=#73;   {page up key}
 kcPgdn=#81;   {page down key}
 kccpgup=#132; {ctrl-page up}
 kccpgdn=#118; {ctrl-page down key}
 kcHome=#71;   {home key}
 kcEnd=#79;    {end key}
 kcchome=#119; {ctrl-home key}
 kccend=#117;  {ctrl-end key}
 kcIns=#82;    {insert key}
 kcDel=#83;    {delete key}
{Function keys}
 f1=#59;
 f2=#60;
 f3=#61;
 f4=#62;
 f5=#63;
 f6=#64;
 f7=#65;
 f8=#66;
 f9=#67;
 f10=#68;
 a1k=#120; {alt-Function keys}
 a2k=#121;
 a3k=#122;
 a4k=#123;
 a5k=#124;
 a6k=#125;
 a7k=#126;
 a8k=#127;
 a9k=#128;
 a10k=#129;
{shift key status, non-enhanced, use with byte kbShift}
 rshift=1; {right shift}
 lshift=2; {left shift}
 ctrl=4; {ctrl key}
 alt=8; {alt key}
 slk=16; {scroll lock on}
 numlock=32; {num lock on}
 caps=64; {caps lock}
 ins=128; {insert key}
{enhanced shift key status, use with byte kbEshift}
 lctrl=1;       {left ctrl}
 lalt=2;        {left alt}
 sysreq=4;      {right control}
 pauseOK=8;       {right alt}
 slkdown=16; {scroll lock held down}
 numdown=22;    {num lock held down}
 capsdown=64;  {caps lock held down}
 insdown=128;    {system-request held down (alt printscreen)}
{special keyboard status 3, use with KbStat3}
 readingID=128; {reading ID from KB}
 code1of2=64; {another code will be read}
 forcenumlk=32; {force numlock on if enhanced keyboard & reading ID}
 kbenhanced=16; {set if enhanced KB}
 ralt=8; {right alt}
 rctrl=4; {right ctrl}
 lastE0=2; {last code was E0}
 lastE1=1; {last code was E1}
{special keyboard status 2, use with kbStat2}
 transmiterror=128; {transmit error flag}
 updatingLED=64; {updating an LED}
 kbresend=32; {RESEND received from KB}
 kback=16; {ACK received from KB}
 capsLED=4; {capslock LED}
 numLED=2; {numlock LED}
 slkLED=1; {scroll lock LED}
{filemode constants}
 fmread=0;     {read only}
 fmwrite=1;    {write only}
 fmOK=2;       {read/write}
 fmnoshare=16; {no sharing}
 fmshread=32;  {share: readonly}
 fmshwrite=48; {share: writeonly}
 fmshOK=64;    {share: read/write}
 fmpriv=128;   {private to current process/program}

Type
 st2=string[2];
 st4=string[4];
 st8=string[8];
 bits=set of 1..8;
 Cset=set of char; {set of characters}
 bset=set of byte; {set of bytes}
 WRec = record Lo, Hi: Byte; end;
 LRec = record case word of 1:(Lo, Hi: Word); 2:(lo2,hi2:wrec); end;
 PRec = record Ofs, Seg: Word; end;
 Rect = record
 case word of
  1:(x1,y1,x2,y2:byte);
  2:(min,max:word);
 end;

 Function Clw(color,x1,y1,x2,y2:byte):boolean;
 Function dironly(s:string):string;
 Function fexist(fn:pathstr):boolean;
 Function findself:string;
 Function GtBrdr:byte;
 Function Hex(b:byte):st2;
 Function Hexl(l:longint):st8;
 Function Hexw(w:word):st4;
 Function Inkey:word;
 Function Is286: Boolean;
 Function IEEEMS (ie : real) : LongInt;
 Function leapyear(y:word):boolean;
 Function locase(ch:char):char;
 Function lostr(s:string):string;
 Function MSIEEE (L:LongInt):LongInt;
 Function on(n,mask:longint):boolean;
 Function power(a,b:real):real;
 Function tan(n:real):real;
 Function uniquefile(var path:pathstr):boolean;
 Function upstr(s:string):string;
 Function xmax:byte;
 Function ymax:byte;
 Function yn:boolean;
 Function Zeller(d,m:byte; y:word):byte;
Procedure blinkm(blinkon:boolean);
Procedure cursoroff;
Procedure cursoron;
Procedure diskreset;
Procedure Frame(x,y,wid,high,color,Tborder:byte); {}
Procedure hilite(color,hicolor:byte; s:string);
Procedure outkey(key:word);
Procedure pause;
Procedure SpeedKey;
Procedure StBrdr(Color:byte);
Procedure Wrt(s:string);
Procedure WrtLn(s:String);
{next, if any, are for testing}

Implementation
Uses Crt;

Const
 hexid:array [0..$F] of char=('0','1','2','3','4','5','6','7','8','9',
 'A','B','C','D','E','F');

Function Clw(color,x1,y1,x2,y2:byte):boolean;
Var
 wmin,wmax:word; ta,x,y:byte;
Begin
 wmin:=windmin;
 wmax:=windmax;
 ta:=textattr;
 x:=wherex;
 y:=wherey;
 window(x1,y1,x2,Y2);
 if ((x1-1)+(y1-1) shl 8=windmin) and ((x2-1)+(y2-1) shl 8=windmax) then
 begin
  textattr:=color;
  clrscr;
  clw:=true;
 end
 else
  clw:=false;
 windmin:=wmin;
 wmax:=windmax;
 textattr:=ta;
 gotoxy(wherex,wherey);
{                               Clear a window
 Store previous window & related info
 set new window
 if new window was set
  change color, clear window (clrscr)
 if window NOT set
  return failure
 Restore previous window & related info}
End;

Function dironly(s:string):string;
begin
 while (s[0]>#0) and (s[byte(s[0])]<>'\') do dec(s[0]);
 dironly:=s;
end;

Function fexist(fn:pathstr):boolean;
var f:file; it:word;
begin
 assign(f,fn);
 getfattr(f,it);
 fexist:=doserror=0;
end;

Function findself:string;
Var
 prg:string[80];
Begin
 findself:=dironly(paramstr(0));
End;

Function GtBrdr:byte;
 assembler;
 asm mov ax,1008h; int 10h; mov al,bh;
 {get border color}
End;

Function Hex(b:byte):st2;
begin
 hex:=hexid[b shr 4]+hexid[b and $f];
end;

Function Hexl(l:longint):st8;
var s:string[8]; c:byte; n:array [1..4] of byte absolute l;
begin
 s:='';
 for c:=4 downto 1 do s:=s+hexid[n[c] shr 4]+hexid[n[c] and $f];
 hexl:=s;
end;

Function Hexw(w:word):st4;
var w2:wrec absolute w;
begin
 hexw:=hexid[w2.hi shr 4]+hexid[w2.hi and $f]+hexid[w2.lo shr 4]+
  hexid[w2.lo and $f];
end;

Function Inkey:word;
assembler;
asm
 xor ah,ah
 int 16h
{                    Read char from buffer, wait if empty
 AH = scan code
 AL = character
 Note: on extended keyboards, this Function discards any extended key-
 strokes, returning only when a non-extended keystroke is available}
end;

Function Is286: Boolean;
assembler;
asm
 PUSHF
 POP  BX
 AND  BX,0FFFH
 PUSH BX
 POPF
 PUSHF
 POP  BX
 AND  BX,0F000H
 CMP  BX,0F000H
 MOV  AX,0
 JZ   @@1
 MOV  AX,1
@@1:
end;

function IEEEMS (ie : real) : LongInt;
var
 MS:array [0..3] of byte;
 MSN:longint absolute MS;
 IEEE:array[0..5] of byte absolute ie;
begin
    MS [3] := IEEE[0];
    MS [0] := IEEE[3];
    MS [1] := IEEE[4];
    MS [2] := IEEE[5];
    IEEEMS := LongInt (MS);
{Longint type used only for convenience of typecasting. Note that this will
 only be effective where the accuracy required can be obtained in the 23
 bits that are available with the MKS type.}
end;

Function leapyear(y:word):boolean;
begin
 leapyear:=(y mod 1000=0) or ((y mod 4=0) and (y mod 100<>0))
end;

Function locase(ch:char):char;
begin
 if {(ch in ['A'..'Z'])} (ch>='A') and (ch<='Z') then inc(byte(ch),32)
 else locase:=ch;
end;

Function lostr(s:string):string;
var c:byte;
begin
 if length(s)>0 then for c:=1 to length(s) do s[c]:=locase(s[c]);
 lostr:=s;
end;

Function MSIEEE (L:LongInt):LongInt;
var
 MS:array [0..3] of Byte absolute L;
 r:real;
 ieee:array[0..5] of byte absolute r;
begin
    FillChar(r,sizeof(r),0);
    ieee[0] := MS[3];
    ieee[3] := MS[0];
    ieee[4] := MS[1];
    ieee[5] := MS[2];
    MSIEEE  := Round (R);
{MS Single to IEEE real (as longint)}
end;

Function on(n,mask:longint):boolean;
Begin
 on:=n and mask=mask;
end; {ON}

Function power(a,b:real):real;
begin
 power:=exp(b*ln(a));
end;

Function tan(n:real):real;
begin
 tan:=sin(n)/cos(n);
end;

Function uniquefile(var path:pathstr):boolean;
var
 tmp:string[12];
 oldseed:longint;
 f:file;
begin
 oldseed:=randseed;
 randomize;
 repeat
  tmp:='';
  while length(tmp)<>11 do tmp:=tmp+char(48+random(10));
  insert('.',tmp,9);
 until not fexist(path+'\'+tmp);
 path:=fexpand(path+tmp);
 assign(f,path);
 rewrite(f);
 close(f);
 uniquefile:=ioresult=0;
 randseed:=oldseed;
{                              Make unique file
 save the random seed
 set the random seed
 generate a random file name until one is found that doesn't exist
 create the file, close the file (size:0)
 if error, return false
 restore the random seed
 the path of the file is returned regardless of the error status}
end;

Function upstr(s:string):string;
var c:byte;
begin
 if length(s)>0 then for c:=1 to length(s) do s[c]:=upcase(s[c]);
 upstr:=s;
end;

Function xmax:byte;
Begin
 xmax:=wrec(windmax).lo-wrec(windmin).lo+1;
End;

Function ymax:byte;
Begin
 ymax:=wrec(windmax).hi-wrec(windmin).hi+1;
End;

Function yn:boolean;
Var ch:char;
Begin
 repeat
  ch:=upcase(readkey);
  if ch=#0 then readkey;
 until ch in ['Y','N'];
 yn:=ch='Y'
end;

Function Zeller(d,m:byte;y:word):byte;
var
 amonth,ayear,century,last2,mcorrect,ycorrect:word;
begin
 if m<=2 then begin
  amonth:=10+m;
  ayear:=y-1;
 end
 else begin
  amonth:=m-2;
  ayear:=y;
 end;
 mcorrect:=(26*amonth-2) div 10;
 century:=ayear div 100;
 last2:=ayear mod 100;
 ycorrect:=last2 + last2 div 4 + century div 4 + 5*century;
 zeller:=(d+mcorrect+ycorrect) mod 7;
{Day of week: 0 to 6=Sunday to Saturday}
end;

Procedure blinkm(blinkon:boolean);
Begin
 asm
  mov ax,1003h
  mov bl,blinkon;
  int 10h
 End
End;

Procedure CursorOff;
Assembler;
Asm
 Mov ah,3;
 Mov bh,0;
 Int $10;
 Or  ch,$20;
 Mov ah,1;
 Int $10;
End;

Procedure CursorOn;
Assembler;
Asm
 Mov ah,3;
 Mov bh,0;
 Int $10;
 And ch,$DF;
 Mov ah,1;
 Int $10;
End;

Procedure diskreset;
assembler;
asm
 mov ah,$d {disk reset option, flush all disk buffers}
 int $21
end;

Procedure Frame(x,y,wid,high,color,Tborder:byte);
type
 border=array [1..6] of char;
Const
{border types}
 box1:border=(#218,#191,#192,#217,#196,#179);
 box2:border=(#201,#187,#200,#188,#205,#186);
 box3:border=(#15,#15,#15,#15,#219,#219);
Var
{counter, textattr, save cursor, save last window}
 c,ta,oldx,oldy:byte; wmin,wmax:word;
 box:^border;
Begin {FRAME}
 ta:=textattr; wmin:=windmin; wmax:=windmax; oldx:=wherex; oldy:=wherey;
 window(x,y,x+wid-1,y+high-1);
 if (xmax=wid) and (ymax=high)
 then Begin
 box:=@box1;
  textattr:=color;
  if not on(tborder,empty) then clrscr;
  case Tborder and not empty of
   1:box:=@box2;
   2:box:=@box3;
  end;
  for c:=1 to xmax do write(box^[5]);
  for c:=1 to ymax-1 do Begin
   gotoxy(xmax,c);
   write(box^[6]+box^[6]);
  End;
  for c:=3 to xmax do write(box^[5]);
  gotoxy(1,1); write(box^[1]);
  gotoxy(xmax,1); write(box^[2]);
  gotoxy(1,ymax); write(box^[3]);
  gotoxy(xmax,ymax); inc(windmax); write(box^[4]);
 End;
 textattr:=ta; windmin:=wmin; windmax:=wmax; gotoxy(oldx,oldy);
End; {FRAME}

Procedure hilite(color,hicolor:byte; s:string);
Var ta:byte; c:byte;
Begin
 ta:=textattr;
 textattr:=color;
 if length(s)>0 then for c:=1 to length(s) do begin
  if s[c]=#0 then textattr:=hicolor
  else begin
   write(s[c]);
   textattr:=color;
  end
 end;
 textattr:=ta;
End; {HILITE}

Procedure outkey(key:word);
assembler; {outkey}
 asm; mov ah,5; mov cx,key; int 16h;
end;

Procedure pause;
Begin
 {read keys until no more left in buffer. Extended Syntax required: $X+}
 repeat readkey until not keypressed;
End;

Procedure SpeedKey;
assembler;
asm
 mov ax,$305
 xor bx,bx
 int 16h
end;

Procedure StBrdr(color:byte);
assembler;
asm
 mov ax,1001h; mov bh,color; int 10h
End;

Procedure Wrt(s:string);
begin
 write(s);
end;

Procedure WrtLn(s:string);
begin
 wrt(s);
 wrt(#13#10);
end;

{routine reordering point}

{insertion point for new routines}
{define test TP 6, prefix $ for test mode}
{$ifdef test}
Const
 testmode:byte=0;
var x:string;
begin
 writeln('Testing MISC unit.');
 case testmode of
  0:begin
  end;
 end;
{$endif}
End.

{
INT 16 - KEYBOARD - WRITE TO KEYBOARD BUFFER (AT model 339,XT2,XT286,PS)
	AH = 05h
	CH = scan code
	CL = character
Return: AL = 01h if buffer full
SeeAlso: AH=71h, INT 15/AX=DE10h
}

Function Theta(x, y: real): real;
begin
 if x = 0 then begin
 if      y > 0 then Theta :=  pi / 2
 else if y < 0 then Theta := -pi / 2
 else               Theta :=  0;
 end
 else Theta := arctan(y / x);
end;

Function Radius(X,Y:Integer):Real;
begin
  Radius := sqrt(sqr(X) + sqr(Y));
end;

