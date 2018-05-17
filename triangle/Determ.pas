unit Determ;

interface

TYPE
  TDetArray = array of array of double;

function Determinant(const AnArray : TDetArray; const Size : integer) : double;
// Input
//   AnArray : the array whose determinant is to be determined.
//   Size: the size or AnArray in both the first and second dimension.
// Output: the derminant of the array.
// Note: The actual size AnArray may be larger than Size in either direction
//   but any values beyond the limits [Size-1,Size-1] will be ignored.

implementation

function Determinant(const AnArray : TDetArray; const Size : integer) : double;
// Based on CACM 224
var
  product, factor, temp, divf, piv, abpiv, maxpiv : double;
  ssign, i, j, r, imax, n : integer;
  a : TDetArray;
begin
  // copy AnArray into a so that the values in AnArray wont be altered.
  n := Size;
  setLength(a, n, n);
  for i := 0 to n-1 do
  begin
    for j := 0 to n-1 do
    begin
      a[i,j] := AnArray[i,j];
    end;
  end;

  // calculate determinant.
  ssign := 1;
  product := 1;
  for r := 0 to n-2 do
  begin
    maxpiv := 0;
    for i := r to n-1 do
    begin
      piv := a[i,r];
      abpiv := abs(piv);
      if abpiv > maxpiv then
      begin
        maxpiv := abpiv;
        divf := piv;
        imax := i;
      end;
    end;
    if maxpiv = 0 then
    begin
      result := 0;
      Exit;
    end
    else
    begin
      if imax <> r then
      begin
        for j := r to n-1 do
        begin
          temp := a[imax, j];
          a[imax,j] := a[r,j];
          a[r,j] := temp;
        end;
        ssign := -ssign;
      end;
    end;
    for i := r+1 to n-1 do
    begin
      factor := a[i,r]/divf;
      for j := r+1 to n-1 do
      begin
        a[i,j] := a[i,j] - factor * a[r,j];
      end;
    end;
  end;
  for i := 0 to n-1 do
  begin
    product := product * a[i,i];
  end;
  result := ssign * product;

end;

//FUNCTION Deter3 (const A: TAry3): double;
{ calculate the determinant of a 3-by-3 matrix }
{BEGIN
  result := A[1,1] * (A[2,2]*A[3,3] - A[3,2]*A[2,3])
       - A[1,2] * (A[2,1]*A[3,3] - A[3,1]*A[2,3])
       + A[1,3] * (A[2,1]*A[3,2] - A[3,1]*A[2,2]);
END;

FUNCTION Deter4 (const A: TAry4): double;
begin
  result :=
    A[1,1] *
        (A[2,2] * (A[3,3]*A[4,4] - A[4,3]*A[3,4])
       - A[2,3] * (A[3,2]*A[4,4] - A[4,2]*A[3,4])
       + A[2,4] * (A[3,2]*A[4,3] - A[4,2]*A[3,3]))
    - A[1,2] *
        (A[2,1] * (A[3,3]*A[4,4] - A[4,3]*A[3,4])
       - A[2,3] * (A[3,1]*A[4,4] - A[4,1]*A[3,4])
       + A[2,4] * (A[3,1]*A[4,3] - A[4,1]*A[3,3]))
    + A[1,3] *
        (A[2,1] * (A[3,2]*A[4,4] - A[4,2]*A[3,4])
       - A[2,2] * (A[3,1]*A[4,4] - A[4,1]*A[3,4])
       + A[2,4] * (A[3,1]*A[4,2] - A[4,1]*A[3,2]))
    - A[1,4] *
        (A[2,1] * (A[3,2]*A[4,3] - A[4,2]*A[3,3])
       - A[2,2] * (A[3,1]*A[4,3] - A[4,1]*A[3,3])
       + A[2,3] * (A[3,1]*A[4,2] - A[4,1]*A[3,2]))
end;

function Determ(const A : TDetArray; const Size : integer;
  const Indicies : TIntegerDynArray; const FirstColumn, LastColumn : integer) : double;
var
  NewIndicies : TIntegerDynArray;
  i, j, NewFirstColumn : integer;
  Index : integer;
  CurrentTerm : double;
  CurrentSign : integer;
begin
  If Size = 2 then
  begin
    i := Indicies[0];
    j := Indicies[1];
    result := A[FirstColumn,i]*A[LastColumn,j] - A[LastColumn,i]*A[FirstColumn,j];
  end
  else
  begin
    result := 0;
    SetLength(NewIndicies,Size-1);
    for Index := 0 to Size-2 do
    begin
      NewIndicies[Index] := Indicies[Index+1];
    end;
    NewFirstColumn := Indicies[1];
    CurrentSign := 1;
    for Index := 0 to Size-1 do
    begin
      i := Indicies[Index];
      CurrentTerm := A[FirstColumn,i];
      if CurrentTerm <> 0 then
      begin
        result := result + CurrentSign*CurrentTerm * Determ(A, Size-1,
          NewIndicies, NewFirstColumn, LastColumn);
      end;
      if Index < Size-1 then
      begin
        CurrentSign := -CurrentSign;
        NewIndicies[Index] := Indicies[Index];
      end;
    end;

  end;
end;

function Determinant(const A : TDetArray; const Size : integer) : double;
var
  Index : integer;
  Indicies : TIntegerDynArray;
begin
  // verify that the input is valid;
  Assert((Size > 0) and (Size <= Length(A)));
  for Index := 0 to Size-1 do
  begin
    Assert(Size <= Length(A[Index]));
  end;

  if Size = 1 then
  begin
    result := A[0,0];
    Exit;
  end;
  SetLength(Indicies,Size);
  for Index := 0 to Size-1 do
  begin
    Indicies[Index] := Index;
  end;

  result := Determ(A, Size, Indicies, 0, Size-1);

end;  }

END.



