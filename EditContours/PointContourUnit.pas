unit PointContourUnit;

interface

uses Classes, Sysutils, Graphics, RBWZoomBox;

type
  TArgusPoint = class(TRBWZoomPoint)
  public
    function PointToString : string;
    procedure StringToPoint(AString : string);
    Procedure Draw; virtual; abstract;
    function Selected(AnX, AY : integer) : boolean;
    Constructor Create; reintroduce; virtual; 
    class Function GetZoomBox : TRBWZoomBox; virtual; abstract;
  end;

  TArgusPointClass = class of TArgusPoint;

  TContour = class(TObject)
  private
    PointClass : TArgusPointClass;
    function GetPoints(Index: integer): TArgusPoint;
    procedure SetPoints(Index: integer; const Value: TArgusPoint);
  public
    FPoints : TList;
    Heading : TStringlist;
    PointsReady : boolean;
    PointStrings : TStringList;
    Value : string;
    function AddPoint(APoint : TArgusPoint) : integer;
    constructor Create(const APointClass : TArgusPointClass);
    Destructor Destroy; override;
    Procedure Draw; virtual; abstract;
    procedure ExchangePoints(Index1, Index2 : integer);
    function PointCount : integer;
    Procedure PointsToStrings;
    Property PointValues[Index : integer] : TArgusPoint read GetPoints
      write SetPoints;
    function Select(AnX, AY : integer) : TArgusPoint;
    procedure StringsToPoints;
    Procedure MakeOpenContour;
  end;

  TContourClass = class of TContour;

implementation

uses UtilityFunctions;

{ TContour }

function TContour.AddPoint(APoint: TArgusPoint): integer;
begin
  result := FPoints.Add(APoint);
end;

constructor TContour.Create(const APointClass : TArgusPointClass);
begin
  inherited Create;
  PointClass := APointClass;
  Heading := TStringlist.Create;
  PointStrings := TStringList.Create;
  FPoints := TList.Create;
  PointsReady := False;
end;

destructor TContour.Destroy;
var
    Index : integer;
    PointIndex : integer;
    APoint : TArgusPoint;
begin
  Heading.Free;
  PointStrings.Free;
  for Index := FPoints.Count -1 downto 0 do
  begin
    APoint := FPoints[Index];
    if APoint <> nil then
    begin
      FPoints.Delete(Index);
      PointIndex := FPoints.IndexOf(APoint);
      if PointIndex > -1 then
      begin
        FPoints[PointIndex] := nil;
      end;
      APoint.Free;
    end;
  end;
  FPoints.Free;
  Inherited;
end;

{procedure TContour.Draw;
var
  APoint, FirstPoint : TArgusPoint;
  Index : integer;

begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  if FPoints.Count > 0 then
  begin
    FirstPoint := PointValues[0];
    frmEditContours.PaintBox1.Canvas.MoveTo(FirstPoint.XCoord,FirstPoint.YCoord);
    FirstPoint.Draw;
    For Index := 1 to FPoints.Count -1 do
    begin
      APoint := PointValues[Index];
      frmEditContours.PaintBox1.Canvas.LineTo(APoint.XCoord,APoint.YCoord);
      APoint.Draw;
    end;
  end;
end; }

procedure TContour.ExchangePoints(Index1, Index2: integer);
begin
  FPoints.Exchange(Index1, Index2);
end;

function TContour.GetPoints(Index: integer): TArgusPoint;
begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  result := FPoints.Items[Index];
end;

procedure TContour.MakeOpenContour;
var
  Point1,Point2 : TArgusPoint;
begin
  if PointCount > 1 then
  begin
    Point1 := PointValues[0];
    Point2 := PointValues[PointCount-1];
    if (Point1 = Point2) then
    begin
      FPoints.Count := FPoints.Count - 1;
    end;
  end;

end;

function TContour.PointCount: integer;
begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  result := FPoints.Count;
end;

procedure TContour.PointsToStrings;
var
    Index : integer;
begin
  PointStrings.Clear;
//  PointStrings.Add('');
  for Index := 0 to FPoints.Count -1 do
  begin
    PointStrings.Add(TArgusPoint(FPoints[Index]).PointToString);
  end;
end;

function TContour.Select(AnX, AY: integer): TArgusPoint;
var
  Index : integer;
  APoint : TArgusPoint;
begin
  result := nil;
  for Index := 0 to FPoints.Count -1 do
  begin
    APoint := FPoints[Index];
    if APoint.Selected(AnX, AY) then
    begin
      result := APoint;
      break;
    end;
  end;
end;

procedure TContour.SetPoints(Index: integer; const Value: TArgusPoint);
begin
  TArgusPoint(FPoints.Items[Index]).Free;
  FPoints.Items[Index] := Value;
end;

procedure TContour.StringsToPoints;
var
  index : Integer;
  AString : string;
  APoint : TArgusPoint;
begin
  for Index := FPoints.Count -1 downto 0 do
  begin
    TArgusPoint(FPoints[Index]).Free;
  end;
  FPoints.Clear;
  For Index := 0 to PointStrings.Count - 1 do
  begin
    AString := PointStrings[Index];
    if AString <> '' then
    begin
      APoint := PointClass.Create;
      APoint.StringToPoint(AString);
      FPoints.Add(APoint);
    end;
  end;
  PointsReady := True;
end;

{ TArgusPoint }

{procedure TArgusPoint.Draw;
const
  size = 2;
var
  AColor : TColor;
begin
  AColor := frmEditContours.PaintBox1.Canvas.Brush.Color;
  if self <> frmEditContours.CurrentPoint then
  begin
    frmEditContours.PaintBox1.Canvas.Brush.Color := clBlack;
  end
  else
  begin
    frmEditContours.PaintBox1.Canvas.Brush.Color := clWhite;
  end;
  frmEditContours.PaintBox1.Canvas.Rectangle(XCoord-size,YCoord-size,XCoord+size,YCoord+size);
  frmEditContours.PaintBox1.Canvas.Brush.Color := AColor;
end; }

constructor TArgusPoint.Create;
begin
  inherited Create(GetZoomBox);
end;

{function TArgusPoint.GetXCoord: Integer;
begin
  result := Round((X*frmEditContours.Multiplier
    - frmEditContours.MinX*frmEditContours.Multiplier) + Margin);
end;

function TArgusPoint.GetYCoord: Integer;
begin
  result := frmEditContours.PaintBox1.Height -
    Round((Y*frmEditContours.Multiplier
      - frmEditContours.MinY*frmEditContours.Multiplier) + Margin);
end;  }

function TArgusPoint.PointToString: string;
var
  CommaPosition : integer;
begin
  result := FloatToStr(x) + Chr(9) + FloatToStr(y);
  CommaPosition := Pos(',',result);
  While CommaPosition > 0 do
  begin
    result[CommaPosition] := '.';
    CommaPosition := Pos(',',result);
  end;
end;

function TArgusPoint.Selected(AnX, AY: integer): boolean;
var
  XPosition , YPosition : integer;
begin
  XPosition := XCoord;
  YPosition := YCoord;
  if (AnX < XPosition + 3) and (AnX > XPosition - 3) and
    (AY < YPosition + 3) and (AY > YPosition - 3) then
  begin
    result := True;
  end
  else
  begin
    result := False;
  end;
end;

{procedure TArgusPoint.SetXCoord(AnX: Integer);
begin
  X :=  (AnX -  Margin)/frmEditContours.Multiplier + frmEditContours.MinX
end;

procedure TArgusPoint.SetYCoord(AY: Integer);
begin
   Y := (frmEditContours.PaintBox1.Height - AY -
     Margin )/frmEditContours.Multiplier + frmEditContours.MinY ;
end; }

procedure TArgusPoint.StringToPoint(AString: string);
var
  XString, YString : string ;
  TabPosition : integer;
begin
  TabPosition := Pos(Chr(9),AString);
  XString := copy(AString, 1, TabPosition-1);
  YString := Copy(AString, TabPosition+1, Length(AString));
  X := InternationalStrToFloat(XString);
  Y := InternationalStrToFloat(YString);
end;


end.
