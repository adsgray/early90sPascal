unit appnddat;

(*
  APPNDDAT - Copyright (c) Steve Rogers, 1994

  Allows user to store configuration data at the end of an EXE file.
  The putConfig procedure stores a record at the end of the EXE file.
  If data is already present in the EXE, it will be overwritten.
  GetConfig will retreive data that has been appended to the EXE.

  NOTE: The pCfgRec parameter passed to both putConfig & getConfig is
        a raw pointer, RecSize is the size of the config record.

        Also, since this unit gets its data from the data following
        the executeable code, it won't work if you compile your EXE
        in the $d+ state (include debug information).
*)

(* We'll do our own i/o checking, thanks. *)
{$i-}

interface

function EXESize(fname : string) : longint;
function DataAppended(fname : string) : boolean;
procedure putConfig(fname : string;pCfgRec : pointer;RecSize : word);
procedure getConfig(fname : string;pCfgRec : pointer;RecSize : word);

implementation
uses
  dos;

{----------------------}
function EXESize(fname : string) : longint;
{ Returns size of executable code in EXE file }

type
  tSizeRec=record    { first 6 bytes of EXE header }
    mz,
    remainder,
    pages : word;
  end;

var
  f : file of tSizeRec;
  sz : tSizeRec;

begin
  assign(f,fname);
  reset(f);
  if (ioresult<>0) then EXESize:= 0 else begin
    read(f,sz);
    close(f);
    with sz do EXESize:= remainder+(pred(pages)*512);
  end;
end;

{----------------------}
function DataAppended(fname : string) : boolean;
var
  f : file;
  sz : longint;

begin
  assign(f,fname);
  reset(f,1);
  if (ioresult<>0) then DataAppended:= false else begin
    sz:= filesize(f);
    close(f);
    DataAppended:= (sz>EXESize(fname));
  end;
end;

{-----------------------}
procedure putConfig(fname : string;pCfgRec : pointer;RecSize : word);
var
  f : file;
  DataOffset : longint;

begin
  DataOffset:= EXESize(fname);

  assign(f,fname);
  reset(f,1);
  seek(f,DataOffset);
  blockwrite(f,pCfgRec^,RecSize);
  close(f);
end;

{-----------------------}
procedure getConfig(fname : string;pCfgRec : pointer;RecSize : word);
var
  f : file;
  DataOffset : longint;

begin
  if (DataAppended(fname)) then begin
    DataOffset:= EXESize(fname);
    assign(f,fname);
    reset(f,1);
    seek(f,DataOffset);
    blockread(f,pCfgRec^,RecSize);
    close(f);
  end;
end;

{----------------------}
end.

  Here's a test program:

uses
  dos,
  appnddat;

type                                { Note that APPNDDAT can handle any }
  tCfgRec=record                    { record structure you can use in BP }
    name : string;
    year : word;
  end;


var
  myCfg : tCfgRec;

begin
  with myCfg do begin
    name:= 'Steve';
    year:= 1994;
  end;

  with myCfg do
    writeln('At start MyCfg = ("',name,'", ',year,')');

  putConfig(paramstr(0),@myCfg,sizeof(tCfgRec));  { Note @ operator }
  fillchar(myCfg,sizeof(myCfg),0);   { zero the record to show progress }

  with myCfg do
    writeln('After zeroing MyCfg = ("',name,'", ',year,')');

  getConfig(paramstr(0),@myCfg,sizeof(tCfgRec));  { Note @ operator }

  with myCfg do
    writeln('After reading back MyCfg = ("',name,'", ',year,')');
  writeln(memavail,' bytes');
end.
