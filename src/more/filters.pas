{sample filters for KEYFILT.TPU
 FilterType and all other undefined filters
 are contained within KEYFILT.TPU}

var
 UpperCase,LowerCase,
 ShiftNum, {shift-numbers [!..)]}
 Ekeys,   {All Extended Keys}
 AllFunc, {All Function Keys}
 NFunc,   {Normal Function Keys}
 SFunc,   {Shift-Function Keys}
 CFunc,   {Ctrl-Function Keys}
 AFunc,   {Alt-Function Keys}
 Arrows,  {Arrows (includes keypad-keys)}
 CArrows, {Ctrl-Arrows}
 KeyPad,  {Arrows and Ctrl-Arrows}
 KeyBoard {Normal Keyboard}
                    : FilterType;

begin
{ NORMAL KEYS }
 UpperCase:=['A'..'Z'];
 LowerCase:=['a'..'z'];
 ShiftNum:=['!','@','#','$','%','^','&','*','(',')'];
 KeyBoard:=Letters+Numbers+ShiftNum+Punc
 +['/','\','-','_','+','[',']','=','{','}'];
{ EXTENDED KEYS }
 SFunc:=[SF1,SF2,SF3,SF4,SF5,SF6,SF7,SF8,SF9,SF10];
 CFunc:=[CF1,CF2,CF3,CF4,CF5,CF6,CF7,CF8,CF9,CF10];
 AFunc:=[AF1,AF2,AF3,AF4,AF5,AF6,AF7,AF8,AF9,AF10];
 NFunc:=[F1,F2,F3,F4,F5,F6,F7,F8,F9,F10];
 AllFunc:=NFunc+SFunc+CFunc+AFunc;
 Arrows:=[Left,Right,Up,Down,Home,PgUp,PgDn,Endk,Ins,Del];
 CArrows:=[CLeft,CRight,CHome,CPgUp,CPgDn,CEndk];
 KeyPad:=Arrows+CArrows;
 EKeys:=KeyPad+AllFunc;
end.
