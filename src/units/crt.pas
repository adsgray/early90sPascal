
{*******************************************************}
{                                                       }
{       Turbo Pascal Runtime Library                    }
{       CRT Interface Unit                              }
{                                                       }
{       Copyright (C) 1988,92 Borland International     }
{                                                       }
{*******************************************************}

unit Crt;

{$I-,S-}

interface

const

{ CRT modes }

  BW40          = 0;            { 40x25 B/W on Color Adapter }
  CO40          = 1;            { 40x25 Color on Color Adapter }
  BW80          = 2;            { 80x25 B/W on Color Adapter }
  CO80          = 3;            { 80x25 Color on Color Adapter }
  Mono          = 7;            { 80x25 on Monochrome Adapter }
  Font8x8       = 256;          { Add-in for ROM font }

{ Mode constants for 3.0 compatibility }

  C40           = CO40;
  C80           = CO80;

{ Foreground and background color constants }

  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

{ Foreground color constants }

  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

{ Add-in for blinking }

  Blink         = 128;

var

{ Interface variables }

  CheckBreak: Boolean;    { Enable Ctrl-Break }
  CheckEOF: Boolean;      { Enable Ctrl-Z }
  DirectVideo: Boolean;   { Enable direct video addressing }
  CheckSnow: Boolean;     { Enable snow filtering }
  LastMode: Word;         { Current text mode }
  TextAttr: Byte;         { Current text attribute }
  WindMin: Word;          { Window upper left coordinates }
  WindMax: Word;          { Window lower right coordinates }

{ Interface procedures }

procedure AssignCrt(var F: Text);
function KeyPressed: Boolean;
function ReadKey: Char;
procedure TextMode(Mode: Integer);
procedure Window(X1,Y1,X2,Y2: Byte);
procedure GotoXY(X,Y: Byte);
function WhereX: Byte;
function WhereY: Byte;
procedure ClrScr;
procedure ClrEol;
procedure InsLine;
procedure DelLine;
procedure TextColor(Color: Byte);
procedure TextBackground(Color: Byte);
procedure LowVideo;
procedure HighVideo;
procedure NormVideo;
procedure Delay(MS: Word);
procedure Sound(Hz: Word);
procedure NoSound;

implementation

{$IFDEF DPMI}

{$L CRT.OBP}

{$ELSE}

{$L CRT.OBJ}

{$ENDIF}

procedure Initialize; external;
procedure AssignCrt; external;
function KeyPressed; external;
function ReadKey; external;
procedure TextMode; external;
procedure Window; external;
procedure GotoXY; external;
function WhereX; external;
function WhereY; external;
procedure ClrScr; external;
procedure ClrEol; external;
procedure InsLine; external;
procedure DelLine; external;
procedure TextColor; external;
procedure TextBackground; external;
procedure LowVideo; external;
procedure HighVideo; external;
procedure NormVideo; external;
procedure Delay; external;
procedure Sound; external;
procedure NoSound; external;

procedure Break;
begin
  Halt(255);
end;

begin
  Initialize;
  AssignCrt(Input); Reset(Input);
  AssignCrt(Output); Rewrite(Output);
end.