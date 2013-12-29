unit AKBD;

(*****************) Interface (*****************)
const
  {kb1}
  rsp=1; lsp=2; cp=4; ap=8; scon=16; numon=32; capson=64; inson=128;

  {kb2}
  lcp=1; lap=2; sysreqp=4; pauseon=8; scp=16; nump=32; capsp=64; insp=128;

  {kb3}
  rcp=4; rap=8; enhkbd=16;

  {kb4}
  scled=1; numled=2; capsled=4;

var
  kb1 : byte absolute $40:$17;
  kb2 : byte absolute $40:$18;
  kb3 : byte absolute $40:$96;
  kb4 : byte absolute $40:$97;

function bitson(var what : byte; mask : byte):boolean;
procedure switchbit(var what:byte; mask : byte);
procedure setbit(var what:byte; mask : byte);

(*****************) Implementation (*****************)
function bitson(var what : byte; mask : byte):boolean;
begin
  bitson := what and mask = mask;
end;

procedure switchbit(var what:byte; mask : byte);
begin
  what := what xor mask;
end;

procedure setbit(var what:byte; mask : byte);
begin
  what := what or mask;
end;

end.
{ 17h  BYTE  Keyboard status flags 1:
		    bit 7 =1 INSert active
		    bit 6 =1 Caps Lock active
		    bit 5 =1 Num Lock active
		    bit 4 =1 Scroll Lock active
		    bit 3 =1 either Alt pressed
		    bit 2 =1 either Ctrl pressed
		    bit 1 =1 Left Shift pressed
		    bit 0 =1 Right Shift pressed
 18h	BYTE	Keyboard status flags 2:
		    bit 7 =1 INSert pressed
		    bit 6 =1 Caps Lock pressed
		    bit 5 =1 Num Lock pressed
		    bit 4 =1 Scroll Lock pressed
		    bit 3 =1 Pause state active
		    bit 2 =1 Sys Req pressed
		    bit 1 =1 Left Alt pressed
		    bit 0 =1 Left Ctrl pressed
 96h	BYTE	Keyboard status byte 3
		    bit 7 =1 read-ID in progress
		    bit 6 =1 last code read was first of two ID codes
		    bit 5 =1 force Num Lock if read-ID and enhanced keyboard
		    bit 4 =1 enhanced keyboard installed
		    bit 3 =1 Right Alt pressed
		    bit 2 =1 Right Ctrl pressed
		    bit 1 =1 last code read was E0h
		    bit 1 =1 last code read was E1h
 97h	BYTE	Keyboard status byte 2
		    bit 7 =1 keyboard transmit error flag
		    bit 6 =1 LED update in progress
		    bit 5 =1 RESEND received from keyboard
		    bit 4 =1 ACK received from keyboard
		    bit 3 reserved, must be zero
		    bit 2 Caps Lock LED
		    bit 1 Num Lock LED
        bit 0 Scroll Lock LED}
