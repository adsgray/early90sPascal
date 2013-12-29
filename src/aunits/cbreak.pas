unit CBreak;

(***************) Interface (***************)
const
  CtrlBreakPressed : boolean = false;

(***************) Implementation (***************)
uses Dos;
var
  oldint1b,oldexit: pointer;

procedure newint1b;interrupt;
begin
  ctrlbreakpressed := true;
end;

procedure Done; far;
begin
  exitproc := oldexit;
  SetIntVec($1B, OldInt1B);
end;

(*************** Initialization ***************)
begin
  GetIntVec($1B, OldInt1B);
  SetIntVec($1B, @NewInt1B);
  oldexit := exitproc;
  ExitProc := @Done;
end.
