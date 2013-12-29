uses afiles;

procedure DisplayFiles(what : tfilesrec);
var ct : word;
begin
  for ct := 1 to what.count do
    writeln(what.names[ct]);
end;

var
  allfiles : tfilesrec;

begin
  findfiles('*.*',readonly or hidden or sysfile or archive or directory ,allfiles);
  ExtSort(allfiles);
  DisplayFiles(allfiles);
end.
