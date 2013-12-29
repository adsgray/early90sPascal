unit Macros;

{ -=:*:=-  macros  -=:*:=- }

{ various inline macros collected/rewritten/written by
  Bj”rn Felten @ 2:203/208    Jan 1994 }

{ -- Public Domain -- }

interface

{ check if we have VGA capabilities }
function vgaPresent:boolean;inline
($B8/$1A00/     { mov ax,$1A00    }
 $CD/$10/       { int $10     ;get display combo}
 $3C/$1A/       { cmp al,$1A  ;function supported}
 $75/10/        { jne @ER     ;nop}
 $80/$FB/7/     { cmp bl,7    ;VGA or better}
 $72/5/         { jb  @ER     ;nop}
 $80/$FB/<-1/   { cmp bl,$FF  ;unknown display type}
 $75/4/         { jnz @OK     ;nop}
 $B0/0/         {@ER: mov al,false}
 $EB/2/         { jmp @EXIT       }
 $B0/1);        {@OK: mov al,true }
                {@EXIT:           }

{ gotoXY in graphic mode }
procedure vgaPos(p:word);
inline
 ($58       { pop   ax      }
 /$8b/$d8   { mov   bx,ax   }
 /$ba/$03d4 { mov   dx,3D4h }
 /$b0/$0c   { mov   al,0Ch  }
 /$ef       { out   dx,ax ; port 3D4h, CGA/EGA reg index }
            {             ;  al = 0Ch, start address high}

 /$8a/$e3   { mov   ah,bl   }
 /$b0/$0d   { mov   al,0Dh  }
 /$ef);     { out   dx,ax ; port 3D4h, CGA/EGA reg index }
            {             ;  al = 0Dh, start address low }

{ put a pixel in mode $2f}
procedure putPix2f(x,y,c:word);inline
($5B/           { pop bx      ; c }
 $5E/           { pop si      ; y }
 $5F/           { pop di      ; x }
 $8E/6/sega000/ { mov es,$A000    }
 $B8/640/       { mov ax,640      }
 $F7/$E6/       { mul si          }
 $01/$C7/       { add di,ax       }
 $83/$D2/0/     { adc dx,0        }
 $92/           { xchg ax,dx      }
 $BA/$3CD/      { mov dx,3cdh     }
 $EE/           { out dx,al       }
 $89/$D8/       { mov ax,bx       }
 $AA);          { stosb           }

{ put a pixel in mode $13}
procedure putPix(x,y,c:word);inline
($5B/           { pop bx      ; c }
 $5E/           { pop si      ; y }
 $5F/           { pop di      ; x }
 $8E/6/sega000/ { mov es,$A000    }
 $B8/320/       { mov ax,320      }
 $F7/$E6/       { mul si          }
 $01/$C7/       { add di,ax       }
 $89/$D8/       { mov ax,bx       }
 $AA);          { stosb           }

{ put a dot in mode $12}
procedure putDot(x,y,c:word);inline
 ($5B           { pop bx      ; c }
 /$5E           { pop si      ; y }
 /$5F           { pop di      ; x }
 /$8E/6/sega000 { mov es,$A000    }
 /$B8/80/0      { mov ax,80       }
 /$F7/$E6       { mul si          }
 /$89/$F9   { mov cx,di   }
 /$C1/$EF/3 { shr di,3    }
 /$80/$E1/7 { and cl,111b     }
 /$01/$C7   { add di,ax   }
 /$26/$8A/5 { mov al,[es:di]  }
 /$80/$E3/1 { and bl,1    }
 /$75/8     { jne @1      }
 /$B3/$7F   { mov bl,7fh      }
 /$D2/$CB   { ror bl,cl   }
 /$20/$D8   { and al,bl   }
 /$EB/6     { jmp @2      }
 /$B3/$80   {@1: mov bl,80h   }
 /$D2/$CB   { ror bl,cl   }
 /$08/$D8   { or al,bl    }
 /$AA);     {@2: stosb    }

{ toggle a pixel in mode $13 }
procedure togglePix(x,y:word);inline
($5E/           { pop si      ; y }
 $5F/           { pop di      ; x }
 $8E/6/sega000/ { mov es,$A000    }
 $B8/320/       { mov ax,320      }
 $F7/$E6/       { mul si          }
 $01/$C7/       { add di,ax       }
 $26/           { es:             }
 $F6/$15);      { not byte[di]    }

{ set current videomode  }
procedure setMode(mode:word);inline
($58/           { pop ax          }
 $CD/$10);      { int 10h         }

{ get current videomode  }
function getMode:byte;inline
($B4/$0F/       { mov ah,0fh      }
 $CD/$10);      { int 10h         }

{ wait for video retrace }
procedure waitRetrace;inline
($8E/6/seg0040/ {  mov es,$0040   }
 $26/           {  es:            }
 $8B/$16/>$63/  {  mov dx,[$63]   }
 $83/$C2/6/     {  add dx,6   ;crt status reg (input port #1)}
 $EC/           {@L1: in al,dx    }
 $A8/8/         {  test al,8      }
 $75/$FB/       {  jnz @L1    ;wait for no v retrace}
 $EC/           {@L2: in al,dx    }
 $A8/8/         {  test al,8      }
 $74/$FB);      {  jnz @L1    ;wait for v retrace}

function readKey:char;inline
($B4/$07/       { mov ah,7        }
 $CD/$21);      { int $21         }

function keyPressed:boolean;inline
($B4/$0B/       { mov ah,$B       }
 $CD/$21/       { int $21         }
 $24/$FE);      { and al,$FE      }

{ fast sqrt -- returns int part in hi word and fract part in low}
function iSqrt(x:longint):longint;
inline
 ($66/$33/$c0       { xor   eax,eax}
 /$66/$33/$d2       { xor   edx,edx}
 /$66/$5f       { pop   edi}
 /$b9/$20/$00       { mov   cx,32}
            {@L:}
 /$66/$d1/$e7       { shl   edi,1}
 /$66/$d1/$d2       { rcl   edx,1}
 /$66/$d1/$e7       { shl   edi,1}
 /$66/$d1/$d2       { rcl   edx,1}
 /$66/$d1/$e0       { shl   eax,1}
 /$66/$8b/$d8       { mov   ebx,eax}
 /$66/$d1/$e3       { shl   ebx,1}
 /$66/$43       { inc   ebx}
 /$66/$3b/$d3       { cmp   edx,ebx}
 /$7c/$05       { jl    @S}
 /$66/$2b/$d3       { sub   edx,ebx}
 /$66/$40       { inc   eax}
            {@S:}
 /$e2/$dd       { loop  @L}
 /$66/$8b/$d0       { mov   edx,eax}
 /$66/$c1/$ea/$10); { shr   edx,16}

function swapWords(l:longint):longint;
inline
 ($5a           { pop   dx  }
 /$58);         { pop   ax  }

procedure Lines200;
{ Set 200 scanlines on VGA display }
InLine(
  $B8/$03/$00/  {  mov   AX,$0003  }
  $CD/$10/      {  int   $10       }
  $B8/$00/$12/  {  mov   AX,$1200  }
  $B3/$30/      {  mov   BL,$30    }
  $CD/$10);     {  int   $10       }

procedure Lines350;
{ Set 350 scanlines on VGA display }
InLine(
  $B8/$03/$00/  {  mov   AX,$0003  }
  $CD/$10/      {  int   $10       }
  $B8/$01/$12/  {  mov   AX,$1201  }
  $B3/$30/      {  mov   BL,$30    }
  $CD/$10);     {  int   $10       }

procedure Lines400;
{ Set 400 scanlines on VGA display }
InLine(
  $B8/$03/$00/  {  mov   AX,$0003  }
  $CD/$10/      {  int   $10       }
  $B8/$02/$12/  {  mov   AX,$1202  }
  $B3/$30/      {  mov   BL,$30    }
  $CD/$10);     {  int   $10       }

procedure Font8x8;
{ Set 8x8 CGA-font on VGA display. }
InLine(
  $B8/$03/$00/  {  mov   AX,$0003  }
  $CD/$10/      {  int   $10       }
  $B8/$12/$11/  {  mov   AX,$1112  }
  $B3/$00/      {  mov   BL,0      }
  $CD/$10);     {  int   $10       }

procedure Font8x14;
{ Set 8x14 EGA-font on VGA display }
InLine(
  $B8/$03/$00/  {  mov   AX,$0003  }
  $CD/$10/      {  int   $10       }
  $B8/$11/$11/  {  mov   AX,$1111  }
  $B3/$00/      {  mov   BL,0      }
  $CD/$10);     {  int   $10       }

procedure Font8x16;
{ Set 8x16 VGA-font on VGA display }
InLine(
  $B8/$03/$00/  {  mov   AX,$0003  }
  $CD/$10/      {  int   $10       }
  $B8/$14/$11/  {  mov   AX,$1114  }
  $B3/$00/      {  mov   BL,0      }
  $CD/$10);     {  int   $10       }

implementation

end.
