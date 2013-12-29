unit Squisht;
{ Unit for "squishing" the text screen up to the top }
{ by Eric Coolman, Simple Minded Software, 1994. }

(*****************) Interface (*****************)
Procedure Squish(doit : boolean);

(*****************) Implementation (*****************)

Function SetChrScan(ChrScan : byte) : byte;
begin
   if((ChrScan <> 0) and (ChrScan <= 32)) then   { within allowable? }
     begin                                    { Nope, so let's do it }
       while (port[$3da] and $08) <> $00 do;
       while (port[$3da] and $08) <> $08 do;
       asm
          pushf
          push    ds
          push    ax
          push    dx

          { set up scanline height of characters }
          mov     dx, 03d4h             { CRT Port -> index register }
                                       { (Ega/Vga -- Mono uses 3b4h) }
          mov     al, 09h                   { Max scanlines register }
          out     dx, al          { output reg to CRT port index reg }

          inc     dx              { CRT Port -> data register (3d5h) }
                                       { (Ega/Vga -- Mono uses 3b5h) }
          in      al, dx                 { read a byte from CRT port }
          and     al, 0e0h       { dec.224 = mask bits 5-7 (0 based) }
                                { store bit 9 (0 based) for each of: }
                                            { 5 -> vertical blanking }
                                                 { 6 -> line compare }
                                            { 7 -> 200 line doubling }
          or      al, ChrScan { scanline height of char (0-31 valid) }
                             { set bits 0-4 to (scan height of char) }
          out     dx, al              { send it out to CRT data port }

          pop     dx
          pop     ax
          pop     ds
          popf
       end;
       SetChrScan := 0;       { indicate success }
     end
   else
       SetChrScan := 255;     { indicate error }
end;

Procedure Squish(doit : boolean);
var
   linectr, err,
   normalheight : byte; { stored by BIOS (at 40h:85h) as word (why?) }
begin
   normalheight := mem[$40:$85] - 1;
   if doit then
     for linectr := normalheight downto 1 do
       err := SetChrScan(linectr)
   else
     for linectr := 1 to normalheight do
       err := SetChrScan(linectr);
end;
end.
