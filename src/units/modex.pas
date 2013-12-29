unit modex;

(***************) Interface (***************)
const
  x320x200 = 0;
  x320x400 = 1;
  x360x200 = 2;
  x360x400 = 3;
  x320x240 = 4;
  x320x480 = 5;
  x360x240 = 6;
  x360x480 = 7;

	{ Mode Setting Routines }

Function SET_VGA_MODEX (Mode,MaxXpos,MaxYpos,Pages : integer) : integer;
Function SET_MODEX (Mode:integer) : Integer;

	{ Graphics Primitives }

Procedure CLEAR_VGA_SCREEN (Color:integer);
Procedure SET_POINT (Xpos,Ypos,Color : integer);
Function READ_POINT (Xpos,Ypos:integer) : integer;
Procedure FILL_BLOCK (Xpos1,Ypos1,Xpos2,Ypos2,Color:integer);
Procedure DRAW_LINE (Xpos1,Ypos1,Xpos2,Ypos2,Color:integer);

	{ VGA DAC Routines }

Procedure SET_DAC_REGISTER (RegNo,Red,Green,Blue:integer);
Procedure GET_DAC_REGISTER (RegNo,Red,Green,Blue:integer);

	{ Page and Window Control Routines }

Procedure SET_ACTIVE_PAGE (PageNo:integer);
Function GET_ACTIVE_PAGE : integer;
Procedure SET_DISPLAY_PAGE (PageNo:integer);
Function GET_DISPLAY_PAGE : integer;
Procedure SET_WINDOW (DisplayPage,XOffset,YOffset : integer);
Function GET_X_OFFSET : integer;
Function GET_Y_OFFSET : integer;
Procedure SYNC_DISPLAY;

	{ Text Display Routines }

Procedure GPRINTC (CharNum,Xpos,Ypos,ColorF,ColorB:integer);
Procedure TGPRINTC ( CharNum,Xpos,Ypos,ColorF : integer);
Procedure PRINT_STR (Var Text;MaxLen,Xpos,Ypos,ColorF,ColorB:integer);
Procedure TPRINT_STR (Var Text;MaxLen,Xpos,Ypos,ColorF:integer);
Procedure SET_DISPLAY_FONT (Var FontData;FontNumber:integer);

	{ Sprite and VGA memory -> Vga memory Copy Routines }

Procedure DRAW_BITMAP (Var Image;Xpos,Ypos,Width,Height:integer);
Procedure TDRAW_BITMAP (Var Image;Xpos,Ypos,Width,Height:integer);
Procedure COPY_PAGE (SourcePage,DestPage:integer);
Procedure COPY_BITMAP (SourcePage,X1,Y1,X2,Y2,DestPage,DestX1,DestY1:integer);

(***************) Implementation (***************)

Function SET_VGA_MODEX (Mode,MaxXpos,MaxYpos,Pages : integer) : integer; external;
Function SET_MODEX (Mode:integer) : Integer; external;

Procedure CLEAR_VGA_SCREEN (Color:integer); external;
Procedure SET_POINT (Xpos,Ypos,Color : integer); external;
Function READ_POINT (Xpos,Ypos:integer) : integer; external;
Procedure FILL_BLOCK (Xpos1,Ypos1,Xpos2,Ypos2,Color:integer); external;
Procedure DRAW_LINE (Xpos1,Ypos1,Xpos2,Ypos2,Color:integer); external;

Procedure SET_DAC_REGISTER (RegNo,Red,Green,Blue:integer); external;
Procedure GET_DAC_REGISTER (RegNo,Red,Green,Blue:integer); external;

Procedure SET_ACTIVE_PAGE (PageNo:integer); external;
Function GET_ACTIVE_PAGE : integer; external;
Procedure SET_DISPLAY_PAGE (PageNo:integer); external;
Function GET_DISPLAY_PAGE : integer; external;
Procedure SET_WINDOW (DisplayPage,XOffset,YOffset : integer); external;
Function GET_X_OFFSET : integer; external;
Function GET_Y_OFFSET : integer; external;
Procedure SYNC_DISPLAY; external;

Procedure GPRINTC (CharNum,Xpos,Ypos,ColorF,ColorB:integer); external;
Procedure TGPRINTC ( CharNum,Xpos,Ypos,ColorF : integer); external;
Procedure PRINT_STR (Var Text;MaxLen,Xpos,Ypos,ColorF,ColorB:integer); external;
Procedure TPRINT_STR (Var Text;MaxLen,Xpos,Ypos,ColorF:integer); external;
Procedure SET_DISPLAY_FONT (Var FontData;FontNumber:integer); external;

Procedure DRAW_BITMAP (Var Image;Xpos,Ypos,Width,Height:integer); external;
Procedure TDRAW_BITMAP (Var Image;Xpos,Ypos,Width,Height:integer); external;
Procedure COPY_PAGE (SourcePage,DestPage:integer); external;
Procedure COPY_BITMAP (SourcePage,X1,Y1,X2,Y2,DestPage,DestX1,DestY1:integer); external;

begin
{$L modex2.obj}   { This file is the external ModeX Library .OBJ }
end.
