UNIT Ansi;

INTERFACE

USES Crt;

PROCEDURE Display_ANSI(ch:char);
{ Displays ch following ANSI graphics protocol }

{---------------------------------------------------------------------------} {
Useful information for porting this thing over to other computers:

  Change background text color        Change foreground text color
  TextBackground(0) = black           TextColor(0) = black
  TextBackground(1) = blue            TextColor(1) = blue
  TextBackground(2) = green           TextColor(2) = green
  TextBackground(3) = cyan            TextColor(3) = cyan
  TextBackground(4) = red             TextColor(4) = red
  TextBackground(5) = Magenta         TextColor(5) = magenta
  TextBackground(6) = brown           TextColor(6) = brown
  TextBackground(7) = light grey      TextColor(7) = white
                                      TextColor(8) = grey
  Delete(s,i,c);                      TextColor(9) = bright blue
    Delete c characters from          TextColor(10)= bright green
    string s starting at i            TextColor(11)= bright cyan
  Val(s,v,c);                         TextColor(12)= bright red
    convert string s to numeric       TextColor(13)= bright magenta
    value v. code=0 if ok.            TextColor(14)= bright yellow
  Length(s)                           TextColor(15)= bright white
    length of string s
}

IMPLEMENTATION

VAR
  ANSI_St   :String ;  {stores ANSI escape sequence if receiving ANSI}
  ANSI_SCPL :INTEGER;  {stores the saved cursor position line}
  ANSI_SCPC :INTEGER;  {   "    "    "      "       "    column}
  ANSI_FG   :INTEGER;  {stores current foreground}
  ANSI_BG   :INTEGER;  {stores current background}
  ANSI_C,ANSI_I,ANSI_B,ANSI_R:BOOLEAN ;  {stores current attribute options}

p,x,y : INTEGER;

PROCEDURE Display_ANSI(ch:char);
{ Displays ch following ANSI graphics protocal }

  PROCEDURE TABULATE;
  VAR x:INTEGER;
  BEGIN
    x:=WHEREX;
    IF x<80 THEN
      REPEAT
        Inc(x);
      UNTIL (x MOD 8)=0;
    IF x=80 THEN x:=1;
    GOTOXY(x,WHEREY);
    IF x=1 THEN WRITELN;
  END;

  PROCEDURE BACKSPACE;
  VAR x:INTEGER;
  BEGIN
    IF WHEREX>1 THEN
      WRITE(^H,' ',^H)
    ELSE
      IF WHEREY>1 THEN BEGIN
        GOTOXY(80,WHEREY-1);
        WRITE(' ');
        GOTOXY(80,WHEREY-1);
      END;
  END;

  PROCEDURE TTY(ch:char);
  VAR x:INTEGER;
  BEGIN
    IF ANSI_C THEN BEGIN
      IF ANSI_I THEN ANSI_FG:=ANSI_FG OR 8;
      IF ANSI_B THEN ANSI_FG:=ANSI_FG OR 16;
      IF ANSI_R THEN BEGIN
        x:=ANSI_FG;
        ANSI_FG:=ANSI_BG;
        ANSI_BG:=x;
      END;
      ANSI_C:=FALSE;
    END;
    TextColor(ANSI_FG);
    TextBackground(ANSI_BG);
    CASE Ch of
      ^G: BEGIN
            Sound(2000);
            Delay(75);
            NoSound;
          END;
      ^H: Backspace;
      ^I: Tabulate;
      ^J: BEGIN
            TextBackground(0);
            Write(^J);
          END;
      ^K: GotoXY(1,1);
      ^L: BEGIN
            TextBackground(0);
            ClrScr;
          END;
      ^M: BEGIN
            TextBackground(0);
            Write(^M);
          END;
      ELSE Write(Ch);
    END;
  END;

  PROCEDURE ANSIWrite(S:String);
  VAR x:INTEGER;
  BEGIN
    FOR x:=1 to Length(S) do
      TTY(S[x]);
  END;

  FUNCTION Param:INTEGER;   {returns -1 if no more parameters}
  VAR S:String;
      x,XX:INTEGER;
      B:BOOLEAN;
  BEGIN
    B:=FALSE;
    FOR x:=3 TO Length(ANSI_St) DO
      IF ANSI_St[x] in ['0'..'9'] THEN B:=TRUE;
    IF NOT B THEN
      Param:=-1
    ELSE BEGIN
      S:='';
      x:=3;
      IF ANSI_St[3]=';' THEN BEGIN
        Param:=0;
        Delete(ANSI_St,3,1);
        EXIT;
      END;
      REPEAT
        S:=S+ANSI_St[x];
        x:=x+1;
      UNTIL (NOT (ANSI_St[x] IN ['0'..'9'])) or (Length(S)>2) or
(x>Length(ANSI_St));
      IF Length(S)>2 THEN BEGIN
        ANSIWrite(ANSI_St+Ch);
        ANSI_St:='';
        Param:=-1;
        EXIT;
      END;
      Delete(ANSI_St,3,Length(S));
      IF ANSI_St[3]=';' THEN Delete(ANSI_St,3,1);
      Val(S,x,XX);
      Param:=x;
    END;
  END;

BEGIN
  IF (Ch<>#27) and (ANSI_St='') THEN BEGIN
    TTY(Ch);
    Exit;
  END;
  IF Ch=#27 THEN BEGIN
    IF ANSI_St<>'' THEN BEGIN
      ANSIWrite(ANSI_St+#27);
      ANSI_St:='';
    END ELSE ANSI_St:=#27;
    EXIT;
  END;
  IF ANSI_St=#27 THEN BEGIN
    IF Ch='[' THEN
      ANSI_St:=#27+'['
    ELSE BEGIN
      ANSIWrite(ANSI_St+Ch);
      ANSI_St:='';
    END;
    Exit;
  END;
  IF (Ch='[') and (ANSI_St<>'') THEN BEGIN
    ANSIWrite(ANSI_St+'[');
    ANSI_St:='';
    EXIT;
  END;
  IF not (Ch in ['0'..'9',';','A'..'D','f','H','J','K','m','s','u']) THEN BEGIN
    ANSIWrite(ANSI_St+Ch);
    ANSI_St:='';
    EXIT;
  END;
  IF Ch in ['A'..'D','f','H','J','K','m','s','u'] THEN BEGIN
    CASE Ch of
    'A': BEGIN
           p:=Param;
           IF p=-1 THEN p:=1;
           IF WhereY-p<1 THEN
             GotoXY(Wherex,1)
           ELSE GotoXY(WhereX,WhereY-p);
         END;
    'B': BEGIN
           p:=Param;
           IF p=-1 THEN p:=1;
           IF WhereY+p>25 THEN
             GotoXY(WhereX,25)
           ELSE GotoXY(WhereX,WhereY+p);
         END;
    'C': BEGIN
           p:=Param;
           IF p=-1 THEN p:=1;
           IF WhereX+p>80 THEN
             GotoXY(80,WhereY)
           ELSE GotoXY(WhereX+p,WhereY);
         END;
    'D': BEGIN
           p:=Param;
           IF p=-1 THEN p:=1;
           IF WhereX-p<1 THEN
             GotoXY(1,WhereY)
           ELSE GotoXY(WhereX-p,WhereY);
         END;
'H','f': BEGIN
           Y:=Param;
           x:=Param;
           IF Y<1 THEN Y:=1;
           IF x<1 THEN x:=1;
           IF (x>80) or (x<1) or (Y>25) or (Y<1) THEN BEGIN
             ANSI_St:='';
             EXIT;
           END;
           GotoXY(x,Y);
         END;
    'J': BEGIN
           p:=Param;
           IF p=2 THEN BEGIN
             TextBackground(0);
             ClrScr;
           END;
           IF p=0 THEN BEGIN
             x:=WhereX;
             Y:=WhereY;
             Window(1,y,80,25);
             TextBackground(0);
             ClrScr;
             Window(1,1,80,25);
             GotoXY(x,Y);
           END;
           IF p=1 THEN BEGIN
             x:=WhereX;
             Y:=WhereY;
             Window(1,1,80,wherey);
             TextBackground(0);
             ClrScr;
             Window(1,1,80,25);
             GotoXY(x,Y);
           END;
         END;
    'K': BEGIN
           TextBackground(0);
           ClrEol;
         END;
    'm': BEGIN
           IF ANSI_St=#27+'[' THEN BEGIN
             ANSI_FG:=7;
             ANSI_BG:=0;
             ANSI_I:=FALSE;
             ANSI_B:=FALSE;
             ANSI_R:=FALSE;
           END;
           REPEAT
             p:=Param;
             CASE p of
               -1:;
                0:BEGIN
                    ANSI_FG:=7;
                    ANSI_BG:=0;
                    ANSI_I:=FALSE;
                    ANSI_R:=FALSE;
                    ANSI_B:=FALSE;
                  END;
                1:ANSI_I:=true;
                5:ANSI_B:=true;
                7:ANSI_R:=true;
               30:ANSI_FG:=0;
               31:ANSI_FG:=4;
               32:ANSI_FG:=2;
               33:ANSI_FG:=6;
               34:ANSI_FG:=1;
               35:ANSI_FG:=5;
               36:ANSI_FG:=3;
               37:ANSI_FG:=7;
               40:ANSI_BG:=0;
               41:ANSI_BG:=4;
               42:ANSI_BG:=2;
               43:ANSI_BG:=6;
               44:ANSI_BG:=1;
               45:ANSI_BG:=5;
               46:ANSI_BG:=3;
               47:ANSI_BG:=7;
             END;
             IF ((p>=30) and (p<=47)) or (p=1) or (p=5) or (p=7) THEN
ANSI_C:=true;
           UNTIL p=-1;
         END;
    's': BEGIN
           ANSI_SCPL:=WhereY;
           ANSI_SCPC:=WhereX;
         END;
    'u': BEGIN
           IF ANSI_SCPL>-1 THEN GotoXY(ANSI_SCPC,ANSI_SCPL);
           ANSI_SCPL:=-1;
           ANSI_SCPC:=-1;
         END;
    END;
    ANSI_St:='';
    EXIT;
  END;
  IF Ch in ['0'..'9',';'] THEN
    ANSI_St:=ANSI_St+Ch;
  IF Length(ANSI_St)>50 THEN BEGIN
    ANSIWrite(ANSI_St);
    ANSI_St:='';
    EXIT;
  END;
END;


BEGIN
  ANSI_St:='';
  ANSI_SCPL:=-1;
  ANSI_SCPC:=-1;
  ANSI_FG:=7;
  ANSI_BG:=0;
  ANSI_C:=FALSE;
  ANSI_I:=FALSE;
  ANSI_B:=FALSE;
  ANSI_R:=FALSE;
END.
