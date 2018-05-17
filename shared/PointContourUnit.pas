unit PointContourUnit;

interface

uses Classes, Sysutils, Graphics, RBWZoomBox, AnePIE;

type
  TArgusPoint = class(TRBWZoomPoint)
  public
    function PointToString : string;
    procedure StringToPoint(AString : string; const Separator: char);
    Procedure Draw; virtual; abstract;
    function Select(const AnX, AY : integer) : boolean; virtual;
    Constructor Create; reintroduce; virtual; 
    class Function GetZoomBox : TRBWZoomBox; virtual; abstract;
  end;

  TArgusPointClass = class of TArgusPoint;

  TContour = class(TObject)
  private
    PointClass : TArgusPointClass;
    Separator : char;
    function GetPoints(Index: integer): TArgusPoint;
    procedure SetPoints(Index: integer; const Value: TArgusPoint);
  public
    FPoints : TList;
    Heading : TStringlist;
    PointsReady : boolean;
    PointStrings : TStringList;
    Value : string;
    OwnsPoints : boolean;
    function AddPoint(APoint : TArgusPoint) : integer;
    constructor Create(const APointClass : TArgusPointClass;
      Const ASeparator : char);
    Destructor Destroy; override;
    Procedure Draw; virtual; abstract; 
    procedure ExchangePoints(Index1, Index2 : integer);
    function PointCount : integer;
    Procedure PointsToStrings;
    Property PointValues[Index : integer] : TArgusPoint read GetPoints write SetPoints;
    function Select(AnX, AY : integer) : TArgusPoint;
    procedure StringsToPoints;
    Procedure MakeOpenContour;
    procedure MakeDefaultHeading;
    Procedure FixValue(const aneHandle : ANE_PTR);
  end;

  TContourClass = class of TContour;

implementation

uses UtilityFunctions, OptionsUnit;

{ TContour }

function TContour.AddPoint(APoint: TArgusPoint): integer;
begin
  result := FPoints.Add(APoint);
end;

constructor TContour.Create(const APointClass : TArgusPointClass;
  Const ASeparator : char);
begin
  inherited Create;
  Separator := ASeparator;
  PointClass := APointClass;
  Heading := TStringlist.Create;
  PointStrings := TStringList.Create;
  FPoints := TList.Create;
  PointsReady := False;
  OwnsPoints := True;

end;

destructor TContour.Destroy;
var
    Index : integer;
    PointIndex : integer;
    APoint : TArgusPoint;
begin
  Heading.Free;
  PointStrings.Free;
  if OwnsPoints then
  begin
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

procedure TContour.FixValue(const aneHandle: ANE_PTR);
var
  Delimiter: Char;
  Project: TProjectOptions;
  TabPos: integer;
  TempValue, AValue: string;
  ValueList: TStringList;
  ValueIndex: integer;
  V: double;
  E: integer;
begin
  // This procedure has been copied to ContourListUnit and import
  // in the MODFLOW GUI. and to JoinUnit.
  // Find out what Argus ONE is using to separate the individual values.
  Project := TProjectOptions.Create;
  try
    Delimiter := Project.ExportDelimiter[aneHandle];
  finally
    Project.Free;
  end;

  // Extract each parameter value and place it in ValueList
  TempValue := Value;
  ValueList := TStringList.Create;
  try
    TabPos := Pos(Delimiter, TempValue);
    while TabPos > 0 do
    begin
      AValue := Copy(TempValue, 1, TabPos -1);
      TempValue := Copy(TempValue, TabPos+1, MAXINT);
      ValueList.Add(AValue);
      TabPos := Pos(Delimiter, TempValue);
    end;
    if TempValue <> '' then
    begin
      ValueList.Add(TempValue);
    end;

    // put the updated paramter values in Value.
    TempValue := '';
    for ValueIndex := 0 to ValueList.Count -1 do
    begin
      AValue := ValueList[ValueIndex];
      // put string paramter values in quotes.
      if (AValue <> 'True') and (AValue <> 'False') then
      begin
        Val(AValue, V, E);
        if E <> 0 then
        begin
          AValue := '"' + AValue + '"';
        end;
      end;
      // Use of #9 rather than Delimiter is correct.
      TempValue := TempValue + #9 + AValue;
    end;
    // delete the #9 at the beginning of TempValue.
    Delete(TempValue, 1, 1);
    Value := TempValue;
  finally
    ValueList.Free;
  end;
end;

function TContour.GetPoints(Index: integer): TArgusPoint;
begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  result := FPoints.Items[Index];
end;

procedure TContour.MakeDefaultHeading;
begin
  Heading.Clear;
  PointsReady := True;
  Heading.Add('## Name:');
  Heading.Add('## Icon:0');
  Heading.Add('# Points Count' + Chr(9) + 'Value');
  Heading.Add(IntToStr(PointCount) + Chr(9) + Value);
  Heading.Add('# X pos' + Chr(9) + 'Y pos');
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
    if APoint.Select(AnX, AY) then
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
      APoint.StringToPoint(AString, Separator);
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
  result := InternationalFloatToStr(x) + Chr(9) + InternationalFloatToStr(y);
  CommaPosition := Pos(',',result);
  While CommaPosition > 0 do
  begin
    result[CommaPosition] := '.';
    CommaPosition := Pos(',',result);
  end;
end;

function TArgusPoint.Select(const AnX, AY : integer): boolean;
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

procedure TArgusPoint.StringToPoint(AString: string; const Separator: char);
var
  XString, YString : string ;
  TabPosition : integer;
begin
    TabPosition := Pos(Separator,AString);
    XString := copy(AString, 1, TabPosition-1);
    YString := Copy(AString, TabPosition+1, Length(AString));
    X := InternationalStrToFloat(XString);
    Y := InternationalStrToFloat(YString);
end;


end.
