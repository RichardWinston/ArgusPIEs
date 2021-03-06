unit SegmentUnit;

interface

uses Classes, Math, VertexUnit;

type
  TSegment = class(TObject)
  private
    FFirstVertex : TVertex;
    FSecondVertex : TVertex;
    function Intercept : double;
    procedure SimpleIntersection(ASegment : TSegment; ResultVertex : TVertex);
    function OverLap(ASegment : TSegment; ResultVertex : TVertex)
      : boolean;
  public
     constructor Create(FirstVertex, SecondVertex : TVertex);
     destructor Destroy; override;
     function Intersection(ASegment : TSegment; ResultVertex : TVertex)
       : boolean;
     property FirstVertex : TVertex read FFirstVertex;
     property SecondVertex : TVertex read FSecondVertex;
    function IsHorizontal : boolean;
    function IsVertical : boolean;
    function VertexWithinExtents(AVertex : TVertex) : boolean;
    function Slope : double;
   end;

implementation

{ TSegment }

constructor TSegment.Create(FirstVertex, SecondVertex: TVertex);
begin
  inherited Create;
  FFirstVertex := FirstVertex.Copy;
  FSecondVertex := SecondVertex.Copy;
end;

destructor TSegment.Destroy;
begin
  FFirstVertex.Free;
  FSecondVertex.Free;
  inherited;
end;

function TSegment.Intercept: double;
begin
  result := FFirstVertex.Y - Slope * FFirstVertex.X;
end;

function TSegment.Intersection(ASegment: TSegment;
  ResultVertex: TVertex): boolean;
begin
  if IsVertical then
  begin
    if ASegment.IsVertical then
    begin
      result := (FFirstVertex.X = ASegment.FFirstVertex.X) and
        Overlap(ASegment, ResultVertex);
    end
    else
    begin
      ResultVertex.X := FFirstVertex.X;
      ResultVertex.Y := ASegment.Slope * ResultVertex.X + ASegment.Intercept;
      result := ASegment.VertexWithinExtents(ResultVertex)
        and VertexWithinExtents(ResultVertex);
    end;
  end
  else if ASegment.IsVertical then
  begin
    ResultVertex.X := ASegment.FFirstVertex.X;
    ResultVertex.Y := Slope * ResultVertex.X + Intercept;
    result := ASegment.VertexWithinExtents(ResultVertex)
        and VertexWithinExtents(ResultVertex);
  end
  else if Slope = ASegment.Slope then
  begin
    result := (ASegment.Intercept = Intercept) and
      Overlap(ASegment, ResultVertex);
  end
  else
  begin
    SimpleIntersection(ASegment, ResultVertex);
    result := VertexWithinExtents(ResultVertex)
      and ASegment.VertexWithinExtents(ResultVertex);
  end;

end;

function TSegment.IsHorizontal: boolean;
begin
  result := FSecondVertex.Y = FFirstVertex.Y
end;

function TSegment.IsVertical: boolean;
begin
  result := FSecondVertex.X = FFirstVertex.X
end;

function TSegment.OverLap(ASegment: TSegment;
  ResultVertex: TVertex): boolean;
begin
  result := True;
  if VertexWithinExtents(ASegment.FFirstVertex) then
  begin
    ResultVertex.X := ASegment.FFirstVertex.X;
    ResultVertex.Y := ASegment.FFirstVertex.Y;
  end
  else if VertexWithinExtents(ASegment.FSecondVertex) then
  begin
    ResultVertex.X := ASegment.FSecondVertex.X;
    ResultVertex.Y := ASegment.FSecondVertex.Y;
  end
  else if ASegment.VertexWithinExtents(FFirstVertex) then
  begin
    ResultVertex.X := FFirstVertex.X;
    ResultVertex.Y := FFirstVertex.Y;
  end
  else if ASegment.VertexWithinExtents(FSecondVertex) then
  begin
    ResultVertex.X := FSecondVertex.X;
    ResultVertex.Y := FSecondVertex.Y;
  end
  else
  begin
    result := False;
  end;

end;

procedure TSegment.SimpleIntersection(ASegment: TSegment;
  ResultVertex: TVertex);
var
  X, Y : double;
begin
  X := (Intercept - ASegment.Intercept)/(ASegment.Slope - Slope);
  Y := Slope * X + Intercept;
  ResultVertex.X := X;
  ResultVertex.Y := Y;
end;

function TSegment.Slope: double;
begin
  result := (FSecondVertex.Y - FFirstVertex.Y)/
    (FSecondVertex.X - FFirstVertex.X);
end;

function TSegment.VertexWithinExtents(AVertex: TVertex): boolean;
Var
  Higher, Lower : double;
begin
  Higher := Max(FFirstVertex.X, FSecondVertex.X);
  Lower := Min(FFirstVertex.X, FSecondVertex.X);
  result := (Higher >= AVertex.X) and (AVertex.X >= Lower);
  if result then
  begin
    Higher := Max(FFirstVertex.Y, FSecondVertex.Y);
    Lower := Min(FFirstVertex.Y, FSecondVertex.Y);
    result := (Higher >= AVertex.Y) and (AVertex.Y >= Lower);
  end;
end;

end.
