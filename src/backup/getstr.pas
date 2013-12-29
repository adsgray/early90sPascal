{$R-,D-,E-,L-,I-}
uses acrt,ascreen2;

function getstr(max : byte):string;
var
  whst : string;
  key : krec;
  insertf : boolean;
  row,
  idx,
  startpos : byte;

procedure UpDate;
begin
  goxy(startpos,row);
  write(whst+#32);
  goxy(startpos + idx-1,row);
end;

begin
  whst := '';
  insertf := true;
  row := wy;
  startpos := wx;
  idx := 1;
  repeat
    word(key) := getkey;
    if (key.ch = #224) or (key.ch = #0) then case key.sc of
       75 : if (ord(whst[0]) > 0) and (idx > 1) then begin
                dec(idx);
                write(#8);
              end;
       77 : if idx < ord(whst[0]) then begin
                write(whst[idx]);
                inc(idx);
              end;
       82 : insertf := not insertf;
       71 : begin
                goxy(startpos,row);
                idx := 1;
              end;
       79 : begin
                idx := ord(whst[0])+1;
                goxy(startpos + idx-1,row);
              end;
       83 : begin
                delete(whst,idx,1);
                UpDate;
              end;
       116 : begin
            {    idx := pos(#32,copy(whst,idx-1,ord(whst[0])-idx))+1;
                goxy(startpos + idx-1,row); }
              end;
       115 : begin
              end;
    end else
      case key.ch of
        #08 : if ord(whst[0]) > 0 then
              if insertf then begin
                write(#8#32#8);
                if idx = ord(whst[0])+1 then
                  dec(byte(whst[0]))
                else
                  whst[idx-1] := #32;
                dec(idx);
              end
              else begin
                if ord(whst[0]) > 0 then begin
                  dec(idx);
                  delete(whst,idx,1);
                  update;
                end;
              end;
        #27 : ;
        #13 : ;
        else if insertf then begin
                 if ord(whst[0]) > idx-1 then begin
                   write(key.ch);
                   whst[idx] := key.ch;
                   inc(idx);
                 end
                 else if ord(whst[0]) < max then begin
                   whst := whst + key.ch;
                   write(key.ch);
                   inc(idx);
                 end
               end else begin
                 if ord(whst[0]) < max then begin
                   insert(key.ch,whst,idx);
                   inc(idx);
                   UpDate;
                 end;
               end;
      end;
  until (key.ch = #27) or (key.ch = #13);
  writeln;
  if key.ch = #27 then getstr := '' else getstr := whst;
end;

var temp : string;

begin
  clrscr;
  window(5,12,75,12);
  cblink(false);
  tattr := yellow + lblue shl 4;
  clrscr;
  temp := getstr(xwid-1);
  tattr := yellow + red shl 4;
  clrscr;
  cblink(true);
  write(temp);
end.
