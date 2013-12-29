unit aevent;
Interface
  uses amouse;
type
  keyrec = record
    case byte of
      0 : (ch : byte; sc : byte);
      1 : (hard : word);
  end;

type
  EventType = (emouse,ekeyboard,enothing);
  mouseb = (mleft,mright,mmiddle);
  tEvent = record
    case what : EventType of
      enothing : ();
      ekeyboard : (ekey : keyrec);
      emouse : (minfo : amousedata;
               whichb : mouseb);
    end;
  pEvent = ^tEvent;

procedure GetEvent(var gEv : tEvent);

implementation
uses acrt;

procedure GetEvent(var gEv : tEvent);
begin
  if acrt.keypressed then begin
    gEv.what := ekeyboard;
    word(gEv.ekey) := getkey;
  end
  else if amouse.leftpressed then begin
    gEv.what := emouse;
    gEv.whichb := mleft;
    leftpressdata(gEv.minfo);
  end
  else if amouse.rightpressed then begin
    gEv.what := emouse;
    gEv.whichb := mright;
    rightpressdata(gEv.minfo);
  end
  else gEv.what := enothing;
end;
end.
