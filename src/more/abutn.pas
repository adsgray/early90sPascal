Unit AButn;
Interface
uses ShWin,ATxt;
type
{ dset=set of 1..80;}
 {use text coords for button domain...}
 PAButton=^AButton;
 AButton=object(ShWindow)
   Pressed : Boolean;
   BPressed,
   BNotPressed  :AText;
   Constructor Init(WType:byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte);
   procedure AutoSet;
   function IsPressed(x,y:integer):Boolean;
   procedure ShowPressed;
   procedure Show; virtual;
 end;

Implementation Uses Mouse;
procedure MtoT(ix,iy:integer;var ox,oy:integer);
begin                                           
 ox:=ix div 8 + 1;
 oy:=iy div 8 + 1;
end;

Constructor AButton.Init(WType:byte;Ix1,Iy1,Ix2,Iy2,Iattr:Byte);
begin
 ShWindow.Init(WType,Ix1,Iy1,Ix2,Iy2,Iattr);
 Pressed:=False;
end;

procedure AButton.AutoSet;
{Sets button size up to fit around BText, using the
 x1 and y1 coords for the upper-left corner.
 Init must be run first...}
begin
 with coords do setcoords(1,x1,y1,3+length(BNotPressed.Contents),2);
 with BNotPressed.coords do BNotPressed.SetCoords(3,2);
 BPressed:=BNotPressed;
end;

function AButton.IsPressed(x,y:integer):Boolean;
{True if coords (x,y) are in the x and y domain
 of the button}
var tx,ty:integer; {mouse coordinates}
begin
 MToT(x,y,tx,ty);
 {convert coordinates}
 with coords do IsPressed:=(tx>=x1) and (tx<=x2) and (ty>=y1) and (ty<=y2);
end;

procedure AButton.Show;
begin
 ShWindow.Show;
 if not pressed then BNotPressed.Show else BPressed.Show;
 {must run 'current' on last window to return}
end;

procedure AButton.ShowPressed;
Begin
   mouse.hidecursor;
   current;
   BPressed.Show;
   Repeat Until Not leftbutton;
   {wait for them to let go}
   BNotPressed.Show;
   mouse.ShowCursor;
End;
end.
