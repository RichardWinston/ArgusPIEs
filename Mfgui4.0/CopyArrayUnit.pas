unit CopyArrayUnit;

interface

type
  T1DDoubleArray = array of double;
  T2DDoubleArray = array of array of double;

procedure Copy1DDoubleArray(const Source : T1DDoubleArray;
  var Destination : T1DDoubleArray);

procedure Copy2DDoubleArray(const Source : T2DDoubleArray;
  var Destination : T2DDoubleArray);

implementation

procedure Copy1DDoubleArray(const Source : T1DDoubleArray;
  var Destination : T1DDoubleArray);
var
  Index : integer;
begin
  SetLength(Destination, Length(Source));
  for Index := 0 to Length(Source)-1 do
  begin
    Destination[Index] := Source[Index];
  end;
end;

procedure Copy2DDoubleArray(const Source : T2DDoubleArray;
  var Destination : T2DDoubleArray);
var
  Index1, Index2 : integer;
begin
  if Length(Source) > 0 then
  begin
    SetLength(Destination, Length(Source), Length(Source[0]));
    for Index1 := 0 to Length(Source)-1 do
    begin
      for Index2 := 0 to Length(Source[0])-1 do
      begin
        Destination[Index1,Index2] := Source[Index1,Index2];
      end;

    end;
  end
  else
  begin
    SetLength(Destination, 0, 0);
  end;

end;


end.
