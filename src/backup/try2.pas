uses
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
  backg:word = 216 + (yellow + lblue shl 4) shl 8;

type
  tWindow = record
    battr,
    btype : byte;
    wmi,wma : word;
  end;

procedure Show(var win : tWindow);
begin
  with win do begin
    tattr := battr;
    window(crec(wmi).x,crec(wmi).y,crec(wma).x,crec(wma).y);
    borderwindow(btype);
  end;
end;

procedure Hide(var win : tWindow; thing : word);
begin
  with win do window(crec(wmi).x,crec(wmi).y,crec(wma).x,crec(wma).y);
  FillWin(thing);
end;

var
 win1 : twindow;
 ikey : byte;

begin
  randomize;
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
    battr := red + yellow shl 4;
    btype := 1;
    wmi := 0;
    wma := 10 + 10 shl 8;
  end;
  show(win1);

  fadein(save_pal);

  repeat
    ikey := getscan;
    case ikey of
      { up }    72: with win1 do begin
                      Hide(win1,backg);
                      with crec(wmi) do dec(y);
                      with crec(wma) do dec(y);
                      Show(win1);
                    end;
      { left }  75: with win1 do begin
                      Hide(win1,backg);
                      with crec(wmi) do dec(x);
                      with crec(wma) do dec(x);
                      Show(win1);
                    end;
      { down }  80: with win1 do begin
                      Hide(win1,backg);
                      with crec(wmi) do inc(y);
                      with crec(wma) do inc(y);
                      Show(win1);
                    end;
      { right } 77: with win1 do begin
                      Hide(win1,backg);
                      with crec(wmi) do inc(x);
                      with crec(wma) do inc(x);
                      Show(win1);
                    end;
      { minus } 12: with win1 do begin
                      Hide(win1,backg);
                      with crec(wma) do dec(y);
                      show(win1);
                    end;
                74: with win1 do begin
                      Hide(win1,backg);
                      with crec(wma) do dec(x);
                      show(win1);
                    end;
      { plus }  78: with win1 do begin
                      Hide(win1,backg);
                      with crec(wma) do inc(x);
                      show(win1);
                    end;
                13: with win1 do begin
                      Hide(win1,backg);
                      with crec(wma) do inc(y);
                      show(win1);
                    end;
      { B }     48: with win1 do begin
                      btype := random(3) + 1;
                      battr := random(256);
                      show(win1);
                    end;
    end;
  until ikey = 1;
end.
