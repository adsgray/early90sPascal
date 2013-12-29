unit AStat;
{************************} Interface {************************}

{
                   List of definitions:
}
type
  datatype = word; {can be modified; recompiled}
const
  a_max = $FFFF div sizeof(datatype) - 5;
type
  tDArray = array [1..a_max] of datatype;
  pDArray = ^tData;
  tData = record
    data : tDArray; {data}
    count : longint;     {num. of pos'n's filled}
    sorted : boolean;
  end;

{
                  List of Procedures:
}
    procedure QSort(var a:tData);
    function Mean(var a:tData):real;
    function Median(var a:tData):real;
    function Std_Dev(var a:tData):real;

{************************} Implementation {************************}

procedure QSort(var a:tData);
procedure Sort(l, r: word);
var
  i,j : word;
  x, y: datatype;
begin
  i := l; j := r; x := a.data[(l+r) DIV 2];
  repeat
    while a.data[i] < x do i := i + 1;
    while x < a.data[j] do j := j - 1;
    if i <= j then
    begin
      y := a.data[i]; a.data[i] := a.data[j]; a.data[j] := y;
      i := i + 1; j := j - 1;
    end;
  until i > j;
  if l < j then Sort(l, j);
  if i < r then Sort(i, r);
end;
begin {QuickSort};
  if a.count > 1 then
    Sort(1,a.count);
end;

function Mean(var a:tData):real;
var
  rsum : longint;
  ct : longint;
  temp : real;

begin
  rsum := 0;
  for ct := 1 to a.count do
    rsum := rsum + a.data[ct];
  temp := rsum / a.count;
  Mean := temp;
end;

function Median(var a:tData):real;
begin
  Median := a.count; {temporary}
end;

function Std_Dev(var a:tData):real;
begin
  Std_Dev := a.count; {temporary}
end;
end.
