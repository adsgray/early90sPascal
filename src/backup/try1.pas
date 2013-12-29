uses
  ASObjs,
  AScreen2,
  Acrt,
  AVGA,
  VGAFade;

var
 org_screen : tSaveScreen;
 oldexit : pointer;
 save_pal : aPalette;

procedure Done; FAR;
begin
  exitproc := oldexit;
  fadeout;
  cblink(true);
  cursor(true);
  RestoreInfo(org_screen);
  fadein(save_pal);
end;

const
  backg:word = 197 + (lred + white shl 4) shl 8;

var
 win1 : shadwin;
 ikey : byte;

begin
  SaveInfo(org_screen);
  oldexit := exitproc;
  exitproc := @Done;
  getpalette(@save_pal);
  fadeout;
  VGA50;
  cblink(false);
  cursor(false);
  FillScr(TextScreen,backg);

  with win1 do begin
    Init(0,0,11,11,yellow + lblue shl 4,red + yellow shl 4,1);
    showshadow := true;
    shadowcell := wrec(backg).lo + (black + blue shl 4) shl 8;
{    title := '1995';
    titleattr := red + yellow shl 4; }
    show;
  end;
  fadein(save_pal);

  repeat
    ikey := getscan;
    case ikey of
      { up }    72: with win1 do begin
                      hide(backg); dec(crec(wmi).y);
                      dec(crec(wma).y); show;
                    end;
      { left }  75: with win1 do begin
                      hide(backg); dec(crec(wmi).x);
                      dec(crec(wma).x); show;
                    end;
      { down }  80: with win1 do begin
                      hide(backg); inc(crec(wmi).y);
                      inc(crec(wma).y); show;
                    end;
      { right } 77: with win1 do begin
                      hide(backg); inc(crec(wmi).x);
                      inc(crec(wma).x); show;
                    end;
      { minus } 12,74: with win1 do begin
                         hide(backg);
                         with crec(wmi) do begin
                           inc(x); inc(y); end;
                         with crec(wma) do begin
                           dec(x); dec(y); end;
                         show;
                       end;
      { plus }  78,13: with win1 do begin
                         with crec(wmi) do begin
                           dec(x); dec(y); end;
                         with crec(wma) do begin
                           inc(x); inc(y); end;
                         show;
                       end;
      { B }        48: with win1 do begin
                         battr := random(256);
                         btype := random(3) + 1;
                         show;
                       end;
      { S }        31: with win1 do begin
                         shadowcell := wrec(backg).lo + random(256) shl 8;
                         show;
                       end;
      { F }        33: with win1 do begin
                         attr := random(256);
                         show;
                       end;
    end;
  until ikey = 1;
end.
