unit AMutils;

(***************) Interface (***************)
  Type
    GMCursorType = array [1..32] of word;
  Const
    MCross:GMCursorType =
    (64575,64575,64575,64575,64575,64575,
     0,0,0,0,
     64575,64575,64575,64575,64575,64575,
     960,960,960,960,960,960,
     65535,65535,65535,65535,
     960,960,960,960,960,960);
    MSquare:GMCursorType =
    (65535,65535,65535,65535,65535,65535,
     64575,64575,64575,64575,
     65535,65535,65535,65535,65535,65535,
    0,0,0,0,0,0,
    960,960,960,960,
    0,0,0,0,0,0);
  MCheck : gmcursortype = ($FFF0, $FFE0, $FFC0, $FF81,  { Screen mask }
                        $FF03, $0607, $000F, $001F,
  { Check }             $C03F, $F07F, $FFFF, $FFFF,
  { mark  }             $FFFF, $FFFF, $FFFF, $FFFF,
                        $0000, $0006, $000C, $0018,  { Cursor mask }
                        $0030, $0060, $70C0, $1D80,
                        $0700, $0000, $0000, $0000,
                        $0000, $0000, $0000, $0000);

  MLArr  : gmcursortype = ($FE1F, $F01F, $0000, $0000,  { Screen mask }
                        $0000, $F01F, $FE1F, $FFFF,
  { Left  }             $FFFF, $FFFF, $FFFF, $FFFF,
  { arrow }             $FFFF, $FFFF, $FFFF, $FFFF,
                        $0000, $00C0, $07C0, $7FFE,  { Cursor mask }
                        $07C0, $00C0, $0000, $0000,
                        $0000, $0000, $0000, $0000,
                        $0000, $0000, $0000, $0000);

  MCross2 : gmcursortype = ($FC3F, $FC3F, $FC3F, $0000,  { Screen mask }
                        $0000, $0000, $FC3F, $FC3F,
  { Cross }             $FC3F, $FFFF, $FFFF, $FFFF,
                        $FFFF, $FFFF, $FFFF, $FFFF,
                        $0000, $0180, $0180, $0180,  { Cursor mask }
                        $7FFE, $0180, $0180, $0180,
                        $0000, $0000, $0000, $0000,
                        $0000, $0000, $0000, $0000);

const watchData : gmcursortype =
	($E007,$C003,$8001,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$8001,$C003,$E007,
	 $0,$1FF8,$318C,$6186,$4012,$4022,$4042,$718C,$718C,$4062,$4032,
	 $4002,$6186,$318C,$1FF8,$0);

const arrowData : gmcursortype =
	($FFFF,$8FFF,$8FFF,$87FF,$83FF,$81FF,$80FF,$807F,$803F,$801F,$800F,
	 $801F,$807F,$887F,$DC3F,$FC3F,
	 $0,$0,$2000,$3000,$3800,$3C00,$3E00,$3F00,$3F80,$3FC0,
	 $3FE0,$3E00,$3300,$2300,$0180,$0180);

const UpArrowCursor : gmcursortype =
         ($f9ff,$f0ff,$e07f,$e07f,$c03f,$c03f,$801f,$801f,
          $f,$f,$f0ff,$f0ff,$f0ff,$f0ff,$f0ff,$f0ff,
          $0,$600,$f00,$f00,$1f80,$1f80,$3fc0,$3fc0,
          $7fe0,$600, $600, $600, $600, $600, $600, $600);

const  LeftArrowCursor : gmcursortype
       = ($fe1f,$f01f,$0,   $0,   $0,   $f01f,$fe1f,$ffff,
          $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,
          $0,   $c0,  $7c0, $7ffe,$7c0, $c0,  $0,   $0,
          $0,   $0,   $0,   $0,   $0,   $0,   $0,   $0);

const  CheckMarkCursor : gmcursortype
       = ($fff0,$ffe0,$ffc0,$ff81,$ff03,$607, $f,   $1f,
          $c03f,$f07f,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,
          $0,   $6,   $c,   $18,  $30,  $60,  $70c0,$1d80,
          $700, $0,   $0,   $0,   $0,   $0,   $0,   $0);

const  PointingHandCursor : gmcursortype
       = ($e1ff,$e1ff,$e1ff,$e1ff,$e1ff,$e000,$e000,$e000,
          $0,   $0,   $0,   $0,   $0,   $0,   $0,   $0,
          $1e00,$1200,$1200,$1200,$1200,$13ff,$1249,$1249,
          $f249,$9001,$9001,$9001,$8001,$8001,$8001,$ffff);

const  DiagonalcrossCursor : gmcursortype
       = ($7e0, $180, $0,   $c003,$f00f,$c003,$0,   $180,
          $7e0, $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,
          $0,   $700e,$1c38,$660, $3c0, $660, $1c38,$700e,
          $0,   $0,   $0,   $0,   $0,   $0,   $0,   $0);

const  
   RectangularCrossCursor : gmcursortype
       = ($fc3f,$fc3f,$fc3f,$0,$0,   $0,   $fc3f,$fc3f,
          $fc3f,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,
          $0,   $180, $180, $180, $7ffe,$180, $180, $180,
          $0,   $0,   $0,   $0,   $0,   $0,   $0,   $0);

const  
   HourglassCursor : gmcursortype
       = ($0,   $0,   $0,   $0,   $8001,$c003,$e007,$f00f,
          $e007,$c003,$8001,$0,   $0,   $0,   $0,   $ffff,
          $0,   $7ffe,$6006,$300c,$1818,$c30, $660, $3c0,
          $660, $c30, $1998,$33cc,$67e6,$7ffe,$0,   $0);

const 
   newWatchCursor : gmcursortype
       = ( $ffff, $c003, $8001, $0, $0, $0, $0, $0, $0, 
           $0, $0, $0, $0, $8001, $c003, $ffff, $0, $0, 
           $1ff8, $2004, $4992, $4022, $4042, $518a, $4782, 
           $4002, $4992, $4002, $2004, $1ff8, $0, $0 );



  procedure SetGraphCursor(var IC : GMCursorType);

(***************) Implementation (***************)

procedure SetGraphCursor(var IC : GMCursorType);
assembler;
asm
  mov AX,09h
  xor BX,BX
  xor CX,CX
  les DX,IC
  int 33h
end;
end.
