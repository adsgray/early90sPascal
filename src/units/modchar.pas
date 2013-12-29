Unit ModChar;

      {                       Unit Name: ModChar                       }
      {                      Author: Rob Perelman                      }

Interface

Const LoadChar=False;
      SaveChar=True;

Type CharPic=Array[1..16] of Byte;

Const CRLeft: CharPic=(0,31,48,99,198,140,140,140,140,140,140,198,99,48,
        31,0);
      CRRight: CharPic=(0,248,12,198,99,1,1,1,1,1,33,99,198,12,248,0);
      BigCRLeft: CharPic=(31,48,96,195,134,140,140,140,140,140,140,134,
        195,96,48,31);
      BigCRRight: CharPic=(248,12,6,195,97,1,1,1,1,1,33,97,195,6,12,
        248);

  Procedure ProcessChar(CharNum: Byte; var Pic: CharPic; Which: Boolean);

Implementation

Uses Dos;

Procedure ProcessChar(CharNum: Byte; var Pic: CharPic; Which: Boolean);
Begin
  Inline($FA);
  PortW[$3C4]:=$0402;
  PortW[$3C4]:=$0704;
  PortW[$3CE]:=$0204;
  PortW[$3CE]:=$0005;
  PortW[$3CE]:=$0006;
  If Which then Move(Pic, Mem[SEGA000:CharNum*32], SizeOf(CharPic))
           Else Move(Mem[SEGA000:CharNum*32], Pic, SizeOf(CharPic));
  PortW[$3C4]:=$0302;
  PortW[$3C4]:=$0304;
  PortW[$3CE]:=$0004;
  PortW[$3CE]:=$1005;
  PortW[$3CE]:=$0E06;
  Inline($FB);
End;
End.
