Unit AMem;
{ Andrew Gray }
{ 07/22/94 }

(***************) Interface (***************)
type
  MemRec = record
    size : word;
    buf : pointer;
  end;

procedure Malloc(var mrec : MemRec; msize: word);
procedure Free(var mrec:MemRec);

(***************) Implementation (***************)
procedure Malloc(var mrec : MemRec; msize: word);
begin
  mrec.size := msize;
  with mrec do getmem(buf,size);
end;

procedure Free(var mrec:MemRec);
begin
  with mrec do freemem(buf,size);
end;
end.
