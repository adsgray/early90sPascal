Unit KeyFilt;
  {
  Unit to aid in filtering keyboard input
  }

Interface
Const
   Nul=#0;
   Enter=#13;        { Letters and Numbers are defined in }
   Esc=#27;          { the initialization section         }
   Space=#32;
   Tab=#9;
   BSpace=#8;
   
   { *EXTENDED KEYS* }
   { Function Keys }
   F1=#59;   SF1=#84;    CF1=#94;    AF1=#104;
   F2=#60;   SF2=#85;    CF2=#95;    AF2=#105;
   F3=#61;   SF3=#86;    CF3=#96;    AF3=#106;
   F4=#62;   SF4=#87;    CF4=#97;    AF4=#107;
   F5=#63;   SF5=#88;    CF5=#98;    AF5=#108;
   F6=#64;   SF6=#89;    CF6=#99;    AF6=#109;
   F7=#65;   SF7=#90;    CF7=#100;   AF7=#110;
   F8=#66;   SF8=#91;    CF8=#101;   AF8=#111;
   F9=#67;   SF9=#92;    CF9=#102;   AF9=#112;
   F10=#68;  SF10=#93;   CF10=#103;  AF10=#113;
   
   { KeyPad Keys (Ctrl included) }
   Ins=#82;   Del=#83;
   Left=#75;  CLeft=#115;
   Right=#77; CRight=#116;
   Up=#72;    {no Ctrl-Up}
   Down=#80;  {no Ctrl-Down}
   Home=#71;  CHome=#119;
   PgUp=#73;  CPgUp=#132;
   PgDn=#81;  CPgDn=#118;
   Endk=#79;  CEndk=#117;
   
Type
   FilterType=Set Of Char;
Var
   { default filters }
   Letters,
   Numbers,
   Punc    {Puncuation}
   :FilterType;
   
Procedure GetNKey(Var Key: Char;
                 filter: FilterType);
{ returns Key if it is in filter and not extended
  *Should not be used to read extended keys }


Procedure GetEKey(Var EKey:Char;
                  filter: FilterType);
{ Returns an Extended Key in Ekey if it is in filter
  ***Note: Only good for extended keys
      *****WILL NOT RETURN UNTIL AN EXTENDED KEY*****
      *****IN FILTER IS ENTERED.                ***** }


Procedure GetKey(Var Key: Char;
                 NFilter, Efilter: filtertype;
                 Var EXTFlag: Boolean);
{ Filters both normal and extended keys, returns a
  boolean true if the key is extended, false if normal }


Procedure EnterInteger(Var Num: Integer);
{ Verifies input of an integer: user can only use
  Number keys, backspace/Left-arrow, Enter, and Neg. sign }


Procedure EnterReal(Var Num: Real);
{ Verifies input of a real number.
  User can use Number Keys, decimal point, minus, Backspace/Left-Arrow}


Procedure EnterString(Var InString: String;
                      SFilter: filtertype);
{  Filters input of a string through SFilter.
   Input ends when [Enter] is pressed.
   user can use [<--] or BkSp to erase. }


Procedure EnterFileName(Var FileName:String);
{  User can input a filename with full path }

Procedure PressEnter;
Implementation
Uses crt;
Procedure GetNKey(Var Key: Char;
                 filter: FilterType);
Var
   Temp : Char;
   
Begin
   filter:=filter-[Nul];
   Repeat
      Key:=ReadKey;
      If Key=Nul Then Temp:=ReadKey;
   Until Key In filter;
End; {GetNKey}

Procedure PressEnter;
Var k:Char;
Begin
   GetNKey(k,[Enter]);
End;

Procedure GetEKey(Var EKey:Char;
                  filter: FilterType);
Var
   Key : Char;
   
Begin
   Repeat {Until EKey is in Filter}
      Repeat  {Until Extended Key is entered}
         Key:=ReadKey;
      Until Key=Nul;
      Ekey:=ReadKey;  {take 2nd readkey}
   Until Ekey In Filter;
End; {GetEKey}


Procedure GetKey(Var Key: Char;
                 NFilter, Efilter: filtertype;
                 Var EXTFlag: Boolean);
{ Filters both normal and extended keys, returns a
  boolean true if the key is extended, false if normal }

Var
   NKey, EKey : Char;
   
Begin
   NFilter:=NFilter+[Nul]; {Init. Filter}
   Repeat
      Repeat
         NKey:=ReadKey;
      Until NKey In NFilter;
      If NKey=Nul Then Ekey:=ReadKey;
   Until (NKey<>Nul {a Normal Key filters through})
         Or (Ekey In EFilter {an extended key filters through});
   EXTFlag:=Nkey=Nul;
   If EXTFlag Then Key:=Ekey Else Key:=Nkey;
End; {GetKey}


Function DotCount(filename: String): Integer;
{ returns the number of dots (.) in a filename }
Var
   X,
   count : Integer;
   
Begin
   count:=0;
   For X:=1 To Length(filename) Do
      If filename[X]='.' Then count:=count+1;
   DotCount:=count;
End; {DotCount}


Procedure BackUp(Var InString: String);
{ Erases last character in InString, and erases it from
  the screen }

 Procedure BackSpace;
 { "Deletes" last character from the screen }
 Var
    Xpos, Ypos : Integer;
 Begin
    Xpos:=WhereX; Ypos:=WhereY;
    If Xpos=1 Then Begin
       Xpos:=Lo(WindMax)+1;
       Ypos:=Ypos-1;
    End Else
       Xpos:=Xpos-1;
    GotoXY(Xpos,Ypos);
    Write(Space);
    GotoXY(Xpos,Ypos);
 End;

Begin
   If Length(InString)>0 Then Begin  {if the string is nothing, do nothing}
      BackSpace;
      Delete(Instring,Length(Instring),1);
   End;
End; {BackUp}


Procedure EnterInteger(Var Num: Integer);
Var
   Filter    : FilterType;
   CH        : Char;
   TempNum   : String;
   FirstDone,
   EXT       : Boolean;
   Error     : Integer;
   
Begin
   Filter:=Numbers+['-',BSpace,Enter]; {Init. Filter}
   FirstDone:=False; {FLAG: has first char. been entered?}
   TempNum:='';
   Repeat {Until Enter is Pressed}
      If FirstDone Then Filter:=Filter-['-'];
      {if first char. has been entered, user can no longer use
      the minus (-) sigh}
      GetKey(CH,Filter,[Left],EXT); {Get "Filtered" Key}
      If EXT Then BackUp(TempNum) {Extended Key}
         {only [Left] can get through filter}
      Else Begin {Normal Key}
         If CH=BSpace Then
            BackUp(TempNum)
         Else If CH<>Enter Then
         Begin
            Write(CH);
            TempNum:=TempNum+CH;
            FirstDone:=True; {at least 1 character has been entered}
         End;
      End;
      If TempNum='' Then  {if nothing is in the string...}
      Begin
         FirstDone:=False;  {...then no char.'s have been entered}
         Filter:=Filter+['-']; {user can input minus (-) sign}
      End;
   Until (Not EXT) And (CH=Enter);
   Val(TempNum,Num,Error);
End; {EnterInteger}


Procedure EnterReal(Var Num: Real);
Var
   Filter    : FilterType;
   CH        : Char;
   EXT,
   FirstDone,
   DotDone   : Boolean;
   TempNum   : String;
   Error     : Integer;
   
Begin
   Filter:=Numbers+[BSpace,Enter,'-','.']; {Init. Filter}
   FirstDone:=False; DotDone:=False;
   {FLAGS: has 1st char. been entered?, has dot (.) been entered?}
   TempNum:='';
   Repeat {Until Enter is pressed}
      GetKey(CH,Filter,[Left],EXT); {Get "filtered" key}
      If EXT Then Begin {Extended Key}
         BackUp(TempNum); {only [Left] can get through filter}
         DotDone:=DotCount(TempNum)>0;
         {Dot Entered if more than zero dots (.) in string}
         FirstDone:=TempNum<>'';
         {a char. entered if string is not equal to nothing}
      End
      Else Begin { Normal Key }
         If CH<>Enter Then Begin
            If CH=BSpace Then
               Backup(TempNum)
            Else Begin
               TempNum:=TempNum+CH;
               Write(CH);
            End;
            DotDone:=DotCount(TempNum)>0;
            {Dot Entered if more than zero dots (.) in string}
            FirstDone:=TempNum<>'';
            {a char. entered if string is not equal to nothing}
         End; {if}
      End; {|if}
      If FirstDone Then            {if a char. has been entered, the       }
         Filter:=Filter-['-']        {user can no longer enter the minus sign}
      Else If (Not FirstDone) Then
         Filter:=Filter+['-'];
      If DotDone Then              {if a Dot (.) has been entered, the}
         Filter:=Filter-['.']        {user can't enter it again         }
      Else If (Not DotDone) Then
         Filter:=Filter+['.'];
   Until (Not EXT) And (CH=Enter);
   Val(TempNum,Num,Error);
End; {InputReal}


Procedure EnterString(Var InString: String;
                      SFilter: filtertype);
Var
   CH         : Char;
   EXT        : Boolean;
   
Begin
   InString:=''; {Init. string}
   SFilter:=SFilter+[BSpace,Enter]; {Init. Filter}
   {Nul (#0) is added to filter in procedure 'GetKey'}
   Repeat {Until Enter is pressed}
      GetKey(CH,SFilter,[Left],EXT);  {get "filtered" key}
      If EXT Then BackUp(InString)  { Extended Key }
         {ONLY LEFT CAN GET THROUGH FILTER}
      Else Begin  { Normal Key }
         If CH=BSpace Then
            BackUp(InString)
         Else If CH<>Enter Then Begin
            Write(CH);
            InString:=InString+CH;
         End; {if}
      End; {|if}
   Until (Not EXT) And (CH=Enter);
End; {EnterString}


Procedure EnterFileName(Var FileName:String);
Var
   CH     : Char;
   EXT    : Boolean;
   Filter : filtertype;
   SecondDone : Boolean;
   
Begin
   FileName:='';
   Filter:=Letters+Numbers+['\',':','.',Enter,BSpace]-[' ']; {Init. Filter}
   SecondDone:=False; {FLAG: has 2nd char. been entered?}
   Repeat
      If Length(filename)=0 Then
         filter:=filter-[':'];      {':' can't be the 1st char.}
      GetKey(CH,Filter,[Left],EXT);
      If EXT Then Begin  { Extended Key }
         BackUp(FileName);
         SecondDone:=Length(FileName)>1;
      End
      Else Begin  { Normal Key }
         If CH<>Enter Then Begin
            If CH=BSpace Then
               BackUp(FileName)
            Else Begin
               FileName:=FileName+CH;
               Write(CH);
            End; {if}
            SecondDone:=Length(FileName)>1;
         End; {|if}
      End; {||if}
      If SecondDone Then
         Filter:=Filter-[':']
      Else Filter:=Filter+[':'];
   Until (Not EXT) And (CH=Enter);
End; {EnterFileName}


Begin
   {* Set up all default filters *}
   { NORMAL KEYS }
   Letters:=['A'..'Z']+['a'..'z']+[Space];
   Numbers:=['0'..'9'];
   Punc:=[',',':',';','"',#39,'.','?','(',')','!','<','>'];
End. {KeyFilt}