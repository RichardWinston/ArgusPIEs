unit ContourListUnit;

interface

{ContourListUnit provides methods for reading and writing contours from and to
 Argus ONE}

uses Classes, Graphics, SysUtils;

type
  TContourList = class;
  TContour = class;

  TZoomPoint = class(TObject)
  private
    ContourList : TContourList;
    Contour : TContour;
    function GetXCoord : Integer;
    function GetYCoord : Integer;
    Procedure SetXCoord(AnX : Integer);
    Procedure SetYCoord(AY  : Integer);
  public
    X : Extended;
    Y : Extended;
    Constructor Create(AContourList : TContourList; AContour : TContour);
    function PointToString : string;
    procedure StringToPoint(AString : string);
    Property XCoord : Integer read GetXCoord write SetXCoord;
    property YCoord : Integer read GetYCoord write SetYCoord;
    Procedure Draw(ACanvas : TCanvas);
    function Selected(AnX, AY : integer) : boolean;
  end;

  TContour = class(TObject)
  private
    FPoints : TList;
    PointsReady : boolean;
    ContourList : TContourList;
    function GetPoints(Index: integer): TZoomPoint;
    procedure SetPoints(Index: integer; const Value: TZoomPoint);
    procedure StringsToPoints;
    Procedure PointsToStrings;
    function Select(AnX, AY : integer) : TZoomPoint;
    function GetCount : integer;
  public
    Value : string;
    Heading : TStringlist;
    PointStrings : TStringList;
    Constructor Create(AContourList : TContourList);
    Destructor Destroy; override;
    Property PointValues[Index : integer] : TZoomPoint
      read GetPoints write SetPoints;
    Procedure Draw(ACanvas : TCanvas);
    property Count : integer read GetCount ;
    procedure Add(APoint : TZoomPoint);
  end;

  TContourList = class(TList)
    Multiplier : double;
    MinX, MinY : double;
    Margin : integer;
    Height : integer; // height of paintbox
    CurrentPoint : TZoomPoint;
    procedure ReadContours(AString : String);
    function WriteContours: String; // at present, this does not count the
    // points in the contours.
  end;

implementation

  { TZoomPoint }

constructor TZoomPoint.Create(AContourList: TContourList; AContour: TContour);
begin
  inherited Create;
  ContourList := AContourList;
  Contour := AContour;
end;

procedure TZoomPoint.Draw(ACanvas : TCanvas);
const
  size = 2;
var
  AColor : TColor;
begin
  AColor := ACanvas.Brush.Color;
  if self <> ContourList.CurrentPoint then
  begin
    ACanvas.Brush.Color := clBlack;
  end
  else
  begin
    ACanvas.Brush.Color := clWhite;
  end;
  ACanvas.Rectangle(XCoord-size,YCoord-size,XCoord+size,YCoord+size);
  ACanvas.Brush.Color := AColor;

end;

function TZoomPoint.GetXCoord: Integer;
begin
  result := Round((X*ContourList.Multiplier
    - ContourList.MinX*ContourList.Multiplier) + ContourList.Margin);

end;

function TZoomPoint.GetYCoord: Integer;
begin
  result := ContourList.Height -
    Round((Y*ContourList.Multiplier
      - ContourList.MinY*ContourList.Multiplier) + ContourList.Margin);

end;

function TZoomPoint.PointToString: string;
begin
  result := FloatToStr(x) + Chr(9) + FloatToStr(y)
end;

function TZoomPoint.Selected(AnX, AY: integer): boolean;
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

procedure TZoomPoint.SetXCoord(AnX: Integer);
begin
  X :=  (AnX -  ContourList.Margin)/ContourList.Multiplier + ContourList.MinX

end;

procedure TZoomPoint.SetYCoord(AY: Integer);
begin
   Y := (ContourList.Height - AY -
     ContourList.Margin )/ContourList.Multiplier + ContourList.MinY ;

end;

procedure TZoomPoint.StringToPoint(AString: string);
var
  XString, YString : string ;
  TabPosition : integer;
begin
    TabPosition := Pos(Chr(9),AString);
    XString := copy(AString, 1, TabPosition-1);
    YString := Copy(AString, TabPosition+1, Length(AString));
    X := StrToFloat(XString);
    Y := StrToFloat(YString);

end;

{ TContour }

procedure TContour.Add(APoint: TZoomPoint);
begin
  FPoints.Add(APoint);
  PointStrings.Add(APoint.PointToString);
end;

constructor TContour.Create(AContourList : TContourList);
begin
    inherited Create;
    ContourList := AContourList;
    Heading := TStringlist.Create;
    PointStrings := TStringList.Create;
    FPoints := TList.Create;
    PointsReady := False;

end;

destructor TContour.Destroy;
var
    Index : integer;
    PointIndex : integer;
    APoint : TZoomPoint;
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
  Inherited;
end;

procedure TContour.Draw(ACanvas : TCanvas);
var
  APoint : TZoomPoint;
  var Index : integer;

begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  if FPoints.Count > 0 then
  begin
    APoint := PointValues[0];
    ACanvas.MoveTo(APoint.XCoord,APoint.YCoord);
    APoint.Draw(ACanvas);
    For Index := 1 to FPoints.Count -1 do
    begin
      APoint := PointValues[Index];
      ACanvas.LineTo(APoint.XCoord,APoint.YCoord);
      APoint.Draw(ACanvas);
    end;
  end;
end;

function TContour.GetCount: integer;
begin
  result := FPoints.Count;
end;

function TContour.GetPoints(Index: integer): TZoomPoint;
begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  result := FPoints.Items[Index];

end;

procedure TContour.PointsToStrings;
var
    Index : integer;
begin
  PointStrings.Clear;
  PointStrings.Add('');
  for Index := 0 to FPoints.Count -1 do
  begin
    PointStrings.Add(TZoomPoint(FPoints[Index]).PointToString);
  end;
end;

function TContour.Select(AnX, AY: integer): TZoomPoint;
var
  Index : integer;
  APoint : TZoomPoint;
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

procedure TContour.SetPoints(Index: integer; const Value: TZoomPoint);
begin
  FPoints.Items[Index] := Value;
end;

procedure TContour.StringsToPoints;
var
  index : Integer;
  AString : string;
  APoint : TZoomPoint;
begin
  for Index := FPoints.Count -1 downto 0 do
  begin
    TZoomPoint(FPoints[Index]).Free;
  end;
  FPoints.Clear;
  For Index := 0 to PointStrings.Count - 1 do
  begin
    AString := PointStrings[Index];
    if AString <> '' then
    begin
      APoint := TZoomPoint.Create(Contourlist, self);
      APoint.StringToPoint(AString);
      FPoints.Add(APoint);
    end;
  end;
  PointsReady := True;
end;

{ TContourList }

procedure TContourList.ReadContours(AString: String);
var
  ContourStringList : TStringList;
  Index : integer;
  AContour : TContour;
  HeadingTest : boolean;
begin
  ContourStringList := TStringList.Create;
  ContourStringList.Text := AString;
  AContour := nil;
  HeadingTest := False;
  For Index := 0 to ContourStringList.Count -1 do
  begin
    if ContourStringList.Strings[Index] = '' then
    begin
      HeadingTest := False;
    end;
    if not HeadingTest and (Pos('#', ContourStringList.Strings[Index]) > 0) then
//    if Pos('## Name:', ContourStringList.Strings[Index]) > 0 then
    begin
      AContour := TContour.Create(self);
      Add(AContour);
      HeadingTest := True;
    end;
    if not (AContour = nil) then
    begin
      if HeadingTest
      then
        begin
          AContour.Heading.Add(ContourStringList.Strings[Index]);
        end
      else
        begin
          if not (ContourStringList.Strings[Index] = '') then
          begin
            AContour.PointStrings.Add(ContourStringList.Strings[Index]);
          end;
        end;
      if Pos('# X pos', ContourStringList.Strings[Index]) > 0 then
      begin
        HeadingTest := False;
      end;
    end;
  end;
  For index := 0 to Count -1 do
  begin
    AContour := Items[index];
    if not AContour.PointsReady then
    begin
      AContour.StringsToPoints;
    end;
    if AContour.FPoints.Count > 1 then
    begin
      if (AContour.PointValues[0].X =
          AContour.PointValues[AContour.FPoints.Count-1].X) and
         (AContour.PointValues[0].y =
          AContour.PointValues[AContour.FPoints.Count-1].y) then
      begin
        TZoomPoint(AContour.FPoints.Items[AContour.FPoints.Count-1]).Free;
        AContour.FPoints.Items[AContour.FPoints.Count-1]
          := AContour.FPoints.Items[0];
      end;
    end;
  end;

  ContourStringList.Free;

end;

function TContourList.WriteContours : String;
var
  ContourStringList : TStringList;
  Index : integer;
  AContour : TContour;
begin
  ContourStringList := TStringList.Create;
  ContourStringList.Text := '';
  For index := 0 to Count -1 do
  begin
    AContour := Items[index];
    AContour.PointsToStrings;
    AContour.PointStrings.Add('');
    ContourStringList.Text := ContourStringList.Text + AContour.Heading.Text + AContour.PointStrings.Text;
  end;

  result := '';
  For index := 0 to ContourStringList.Count -1 do
  begin
    result := result + ContourStringList.strings[index] + Chr(10);
  end;

  result := result + Chr(10);

  ContourStringList.Free;

end;


end.
