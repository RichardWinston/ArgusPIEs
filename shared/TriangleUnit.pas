unit TriangleUnit;

interface

uses Classes, VertexUnit;

type
  TTriangle = class (TObject)
  private
    FVertexA : TVertex;
    FVertexB : TVertex;
    FVertexC : TVertex;
    function GetE(AMorphVertex : TVertex) : TVertex;
    procedure ApplyMorph(AMorphVertex: TVertex;
      FirstRatio, SecondRatio: double);
  public
    Constructor Create (const Vertex1, Vertex2, Vertex3 : TVertex);
    Destructor Destroy; override;
    procedure Morph(ATriangle : TTriangle; AMorphVertex : TVertex);
    function PointInside(TestVertex: TVertex): boolean;
  end;

implementation

uses SegmentUnit;

{ TTriangle }

function TTriangle.PointInside(TestVertex : TVertex) : boolean;
var
  VertexIndex : integer;
  AVertex, AnotherVertex : TVertex;
  VertexList : TList;
begin   // based on CACM 112
  result := true;
  VertexList := TList.Create;
  VertexList.Capacity := 4;
  try
    VertexList.Add(FVertexA);
    VertexList.Add(FVertexB);
    VertexList.Add(FVertexC);
    VertexList.Add(FVertexA);
    For VertexIndex := 0 to VertexList.Count -2 do
    begin
      AVertex := VertexList.Items[VertexIndex];
      AnotherVertex := VertexList.Items[VertexIndex+1];
      if ((TestVertex.Y <= AVertex.Y) = (TestVertex.Y > AnotherVertex.Y)) and
         (TestVertex.X - AVertex.X - (TestVertex.Y - AVertex.Y) *
           (AnotherVertex.X - AVertex.X)/
           (AnotherVertex.Y - AVertex.Y) < 0) then
        begin
          result := not result;
        end;
    end;
  finally
    VertexList.Free;
  end;
  result := not result;
end;


constructor TTriangle.Create(const Vertex1, Vertex2, Vertex3: TVertex);
begin
  inherited Create;
  FVertexA := Vertex1.Copy;
  FVertexB := Vertex2.Copy;
  FVertexC := Vertex3.Copy;
end;

destructor TTriangle.Destroy;
begin
  FVertexA.Free;
  FVertexB.Free;
  FVertexC.Free;
  inherited;
end;

function TTriangle.GetE(AMorphVertex: TVertex): TVertex;
var
  FirstSide, SecondSide, DSegment : TSegment;
  AVertex : TVertex;
  X, Y : double;
begin
  FirstSide := TSegment.Create(FVertexA,FVertexB);
  SecondSide := TSegment.Create(FVertexA,FVertexC);
  try

    if AMorphVertex.X = 0 then
    begin
      X := 1;
    end
    else
    begin
      X := AMorphVertex.X * 10;
    end;
    Y := AMorphVertex.Y + (X-AMorphVertex.X) * SecondSide.Slope;

    AVertex := TVertex.Create;
    try
      AVertex.X := X;
      AVertex.Y := Y;
      DSegment := TSegment.Create(AMorphVertex,AVertex);
      try
        result := TVertex.Create;
        DSegment.Intersection(FirstSide, result);
      finally
        DSegment.Free;
      end;

    finally
      AVertex.Free;
    end;

  finally
    FirstSide.Free;
    SecondSide.Free;
  end;


end;

procedure TTriangle.ApplyMorph(AMorphVertex: TVertex;
  FirstRatio, SecondRatio : double);
begin
  AMorphVertex.X := FVertexA.X + (FVertexB.X - FVertexA.X)*FirstRatio
    + (FVertexC.X - FVertexA.X)*SecondRatio;
  AMorphVertex.Y := FVertexA.Y + (FVertexB.Y - FVertexA.Y)*FirstRatio
    + (FVertexC.Y - FVertexA.Y)*SecondRatio;
end;

procedure TTriangle.Morph(ATriangle: TTriangle; AMorphVertex: TVertex);
var
  VertexE : TVertex;
  FirstRatio, SecondRatio : double;
begin
  VertexE := GetE(AMorphVertex);
  try
    FirstRatio := FVertexA.DistanceToVertex(VertexE)/FVertexA.DistanceToVertex(FVertexB);
    SecondRatio := VertexE.DistanceToVertex(AMorphVertex)/FVertexA.DistanceToVertex(FVertexC);
    ATriangle.ApplyMorph(AMorphVertex, FirstRatio, SecondRatio);
  finally
    VertexE.Free;
  end;

end;

end.
