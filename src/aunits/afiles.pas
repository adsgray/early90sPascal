Unit afiles;

(**********) Interface (**********)
const
  max = 500; {  ($FFFF - 57) div 13 is true maximum }
  ReadOnly  = $01;
  Hidden    = $02;
  SysFile   = $04;
  VolumeID  = $08;
  Directory = $10;
  Archive   = $20;
  AnyFile   = $3F;

type
  nametype = string[12];
  tfilearray = array [1..max] of nametype;
  pfilearray = ^tfilearray;
type
  tfilesrec = record
    totalsize : longint;
    desc  : string[50];
    names : tfilearray;
    count : word;
  end;
  pfilesrec = ^tfilesrec;

procedure FindFiles(mask:string; filemask:word; var files:tfilesrec);
{ Finds all files which match the mask (*.whatever) and filemask
  (defined by dos file attributes).  Stores names of files in
  Files.Names.  Total number of files found is put in Files.Count.
  The Mask:string parameter is put in the Files.Desc(ription) string
  for later reference. }

procedure NameSort(var A: tfilesrec);
{ Sorts the A.Names array to alphabetical order by FileName. }

procedure ExtSort(var A: tfilesrec);
{ Sorts the A.Names array to alphabetical order by Extension. }

Function Search(var InFiles : tfilesrec; forname : nametype) : word;
{ Searches InFiles.Names for ForName.  Returns its position in
  the array if found, or 0 if not found. }

(**********) Implementation (**********)
Uses DOS;

procedure FindFiles(mask:string; filemask:word; var files : tfilesrec);
var
  temp : searchrec;
begin
  files.count := 0;
  files.desc := mask;
  files.totalsize := 0;
  findfirst(mask,filemask,temp);
  while doserror = 0 do begin
    inc(files.count);
    files.names[files.count] := temp.name;
    inc(files.totalsize,temp.size);
    findnext(temp);
  end;
end;

procedure NameSort(var A: tfilesrec);
procedure Sort(l, r: word);
var
  i,j : word;
  x, y: nametype;
begin
  i := l; j := r; x := a.names[(l+r) DIV 2];
  repeat
    while a.names[i] < x do i := i + 1;
    while x < a.names[j] do j := j - 1;
    if i <= j then
    begin
      y := a.names[i]; a.names[i] := a.names[j]; a.names[j] := y;
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

procedure ExtSort(var a:tfilesrec);
procedure Sort(l, r: word);
function getsname(var Path : nametype) : nametype;
var
  idx : byte;
begin
  idx := pos('.',path);
  getsname := copy(path,idx+1,length(path)-idx) + copy(path,1,idx);
end;
var
  i,j : word;
  x, y: nametype;
begin
  i := l; j := r;
  x := getsname(a.names[(l+r) DIV 2]);
  repeat
    while getsname(a.names[i]) < x do i := i + 1;
    while x < getsname(a.names[j]) do j := j - 1;
    if i <= j then
    begin
      y := a.names[i]; a.names[i] := a.names[j]; a.names[j] := y;
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

Function Search(var InFiles : tfilesrec; forname : nametype) : word;
var
  high,low,
  mid : word;
  found : boolean;
begin
  low := 1;
  high := infiles.count;
  found := false;
  if high > 0 then
  repeat
    mid := (high + low) div 2;
    if forname = infiles.names[mid] then
      found := true
    else if forname > infiles.names[mid] then
      low := mid + 1
    else high := mid - 1;
  until (high < low) or (found);
  if found then Search := mid else Search := 0;
end;
end.
