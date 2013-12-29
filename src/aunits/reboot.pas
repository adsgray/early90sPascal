UNIT reboot;
(*************) Interface (*************)

PROCEDURE warmboot;
PROCEDURE coldboot;

(*************) Implementation (*************)

CONST
     warmbootflag = $1234;
     coldbootflag = 0;

VAR 
     boot : PROCEDURE;
     boottype : word absolute $0040:$0072;

PROCEDURE resetdisk; assembler;
asm
     mov ah, $0D
     int $21
end;

PROCEDURE warmboot;
begin
     resetdisk;
     boottype := warmbootflag;
     boot;
end;

PROCEDURE coldboot;
begin
     resetdisk;
     boottype := coldbootflag;
     boot;
end;

(*******INITIALIZATION**********)
BEGIN
     @boot := ptr($FFFF, $0000);
end.
