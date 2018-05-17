unit VertexUnit;

interface

uses Classes;

type
  TVertex = Class(TObject)
  private
    FX: double;
    FY: Double;
    procedure SetX(const Value: double);
    procedure SetY(const Value: Double);
  public
    Moved : boolean;
    Property X : double read FX write SetX;
    Property Y : Double read FY write SetY;
    function Copy : TVertex;
    Constructor Create;
    function DistanceToVertex(AVertex : TVertex) : double;
  end;


implementation

{ TVertex }

function TVertex.Copy: TVertex;
begin
  result := TVertex.Create;
  result.FX := FX;
  result.FY := FY;
end;

constructor TVertex.Create;
begin
  Moved := False;
end;

function TVertex.DistanceToVertex(AVertex: TVertex): double;
begin
  result := Sqrt(Sqr(AVertex.X - X) + Sqr(AVertex.Y - Y));
end;

procedure TVertex.SetX(const Value: double);
begin
  FX := Value;
end;

procedure TVertex.SetY(const Value: Double);
begin
  FY := Value;
end;

end.
