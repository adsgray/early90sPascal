Program YetAnotherBankOne;
{ Chapter 8
  Programming Project #3
  Andrew Gray }

uses CRT, BdrWin, Utils;
const
  months=120;
  Interest:real=0.065;

var
 di,
 ct,
 pa            :byte;
 MInterest,
 TInvestment,
 TAmount       : Real;
 DWin          : BdrWindow;


procedure InitWin;
begin
 textbackground(cyan);
 clrscr;
 with DWin do begin
  Init(0,5,2,75,23,white+blue shl 4,'Bank Account Program');
  title.attr:=yellow+red shl 4;
  shstatus:=true;
  brdrtype:=2;
  brdrattr:=white+red shl 4;
  show;
 end;
end;

procedure AddInterest(var Amount, InInt, EarnInt: real);
begin
 Amount:=Amount*InInt;
 EarnInt:=Amount*(InInt-1.0);
end;


begin
InitWin;
di:=0;
pa:=0;
TInvestment:=0;
TAmount:=0;
Interest:=1.0+(Interest/4.0); {take 1/4 of it}
writeln('Month':15,'Investment':15,'New Amount':15,'Interest':15,'Total Savings':15);
for ct:=1 to months do begin
 inc(di);
 inc(pa);
 TInvestment:=TInvestment+50.0;
 TAmount:=TAmount+50.0;
 write(ct:15,TInvestment:15:2,TAmount:15:2,MInterest:15:2);
 if pa=3 then begin
  AddInterest(TAmount,Interest,MInterest);
  pa:=0;
 end;
 writeln(TAmount:15:2);
 if di=19 then begin
  pressenter(textattr);
  di:=0;
  clrscr;
 end;
end;
end.