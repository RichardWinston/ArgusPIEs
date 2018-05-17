unit BoundaryContourUnit;

interface

uses Classes, SysUtils, VertexUnit;

type
  TContourType = (ctNone, ctPoint, ctOpen, ctClosed);

  TBoundaryContour = class(TObject)
    private
      FVertexList : TList;
      function GetVertex(Index : integer) : TVertex;
      function GetVertexCount : integer;
    public
      constructor Create(Lines : TStrings);
      Destructor Destroy; override;
      property Verticies[Index : integer] : TVertex read GetVertex;
      property VertexCount : integer read GetVertexCount;
      function ContourType : TContourType;
  end;

procedure CreateBoundaryContours(ContourStrings: TStrings; ContourList : TList);

implementation

procedure CreateBoundaryContours(ContourStrings: TStrings; ContourList : TList);
var
  AStringList : TStringList;
  Index : Integer;
  AContour : TBoundaryContour;
  ContourType : TContourType;
begin
  AStringList := TStringList.Create;
  try
    for Index := 0 to ContourStrings.Count -1 do
    begin
      if (ContourStrings[Index] = '') or (Index = ContourStrings.Count -1) then
      begin
        if (Index = ContourStrings.Count -1) then
        begin
          AStringList.Add(ContourStrings[Index]);
        end;
        AContour := TBoundaryContour.Create(AStringList);
        ContourList.Add(AContour);
        AStringList.Clear;
      end
      else
      begin
        AStringList.Add(ContourStrings[Index]);
      end;
    end;
    for Index := ContourList.Count -1 downto 0 do
    begin
      AContour := ContourList[Index];
      ContourType := AContour.ContourType;
      if (ContourType = ctClosed) or (ContourType = ctNone) then
      begin
        AContour.Free;
        ContourList.Delete(Index);
      end;
    end;

  finally
    AStringList.Free;
  end;
end;


{ TBoundaryContour }

function TBoundaryContour.ContourType: TContourType;
var
  Vertex1, Vertex2 : TVertex;
begin
  if FVertexList.Count = 0 then
  begin
    result := ctNone;
  end
  else if
  FVertexList.Count = 1 then
  begin
    result := ctPoint;
  end
  else
  begin
    Vertex1 := FVertexList[0];
    Vertex2 := FVertexList[FVertexList.Count-1];
    if (Vertex1.X = Vertex2.X) and (Vertex1.Y = Vertex2.Y) then
    begin
      result := ctClosed;
    end
    else
    begin
      result := ctOpen;
    end;
  end;
end;

constructor TBoundaryContour.Create(Lines: TStrings);
var
  Index : Integer;
  AString : String;
  LineIndex : integer;
  XPos, YPos : double;
  CharIndex : integer;
  AVertex : TVertex;
begin
  inherited Create;
  FVertexList := TList.Create;
  LineIndex := 0;
  for Index := 0 to Lines.Count-1 do
  begin
    if Pos('# X pos',Lines[Index]) = 1 then
    begin
      LineIndex := Index;
      break;
    end;
  end;

  for Index := LineIndex + 1 to Lines.Count-1  do
  begin
    AString := Lines[Index];
    for CharIndex := 1 to Length(AString) do
    begin
      if (AString[CharIndex] = Chr(9)) or (AString[CharIndex] = ' ') then
      begin
        XPos := StrToFloat(Copy(AString,1,CharIndex-1));
        YPos := StrToFloat(Trim(Copy(AString,CharIndex+1,Length(AString))));
        AVertex := TVertex.Create;
        FVertexList.Add(AVertex);
        AVertex.X := XPos;
        AVertex.Y := YPos;
        break;
      end;
    end;
  end;

end;

destructor TBoundaryContour.Destroy;
var
  Index : integer;
begin
  for Index := 0 to FVertexList.Count -1 do
  begin
    TVertex(FVertexList[Index]).Free;
  end;
  FVertexList.Free;
  inherited;

end;

function TBoundaryContour.GetVertex(Index: integer): TVertex;
begin
  result := FVertexList.Items[Index];
end;

function TBoundaryContour.GetVertexCount: integer;
begin
  result := FVertexList.Count;
end;

end.
