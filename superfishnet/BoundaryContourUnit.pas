unit BoundaryContourUnit;

interface

uses Classes, SysUtils, VertexUnit;

type
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
  end;

procedure CreateBoundaryContours(ContourStrings: TStrings; ContourList : TList);

implementation

procedure CreateBoundaryContours(ContourStrings: TStrings; ContourList : TList);
var
  AStringList : TStringList;
  Index : Integer;
  AContour : TBoundaryContour;
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
  finally
    AStringList.Free;
  end;
end;


{ TBoundaryContour }

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
