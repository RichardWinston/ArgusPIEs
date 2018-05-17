unit frmSampleUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Contnrs, WriteContourUnit, AnePIE, QuadtreeClass;

type
  TGridImportChoice = (gicNone, gicClosest, gicAverage, gicHighest, gicLowest,
    gicAll);
  TMeshImportChoice = (micNone, micClosestNode, micAverageNode, micHighestNode,
    micLowestNode, micClosestElement, micAverageElement, micHighestElement,
    micLowestElement, micAll);

  TRealPoint = class;

  TRealPointArray = array of TRealPoint;
  TVDoubleArray = Array of double;
  PVDoubleArray = ^TVDoubleArray;

  TRealPoint = class(TObject)
  private
    FValues: TVDoubleArray;
    FX, FY: ANE_DOUBLE;
    function GetValues : TVDoubleArray; virtual;
  public
    property X: ANE_DOUBLE read FX;
    property Y: ANE_DOUBLE read FY;
    Property Values : TVDoubleArray read GetValues;
  end;

  TNode = class(TRealPoint)
  private
    FCount : integer;
    Distance2 : double;
    Elements : TList;
    Points : TRealPointArray;
    procedure SetValues(const LocX, LocY: double; const Values: TVDoubleArray);
    function GetValues : TVDoubleArray; override;
    procedure MakeCell;
    function IsInside(PointX, PointY: extended): boolean;
  public
    property Count: integer read FCount;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TElement = class(TRealPoint)
  private
    FCount : integer;
    Distance2 : double;
    Points : TRealPointArray;
    function GetValues : TVDoubleArray; override;
    procedure SetValues(const LocX, LocY: double; const Values: TVDoubleArray); virtual;
    procedure SetCenterPoint;
    function IndexOf(const Node : TNode) : integer;
    function IsInside(PointX, PointY: extended): boolean;
  public
    property Count: integer read FCount;
  end;

  TSegment = class(TObject)
  private
    Point1, Point2 : TRealPoint;
    function IsSimilar(const ASegment : TSegment;
      const Epsilon : extended) : boolean;
  public
    destructor Destroy; override;
  end;

  TBlock = class(TElement)
  private
    FIndex : integer;
    procedure SetValues(const LocX, LocY: double; const Values: TVDoubleArray); override;
    function GetValues : TVDoubleArray; override;
  public
    Constructor Create(const Index : integer);
    Destructor Destroy; override;
  end;

  TfrmSample = class(TfrmWriteContour)
    qtBlocksElements: TRbwQuadTree;
    qtNodes: TRbwQuadTree;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
  private
    MapLayerName : string;
    RowCount, ColCount : integer;
    { Private declarations }
  protected
    GridImportChoice : TGridImportChoice;
    MeshImportChoice : TMeshImportChoice;
    BlockList : TObjectList;
    NodeList : TObjectList;
    ElementList : TObjectList;
    GridOutline : TRealPointArray;
    MinMeshX, MaxMeshX, MinMeshY, MaxMeshY : double;
    NodeSearchRadius : double;
    SearchRadius : double;
    procedure GetGridOutline(const LayerName: string;
      var LayerHandle: ANE_PTR; var NRow, NCol: ANE_INT32;
      var GridAngle: ANE_DOUBLE);
    procedure ResetData;
    Procedure SetValues(const Values: TVDoubleArray; const LocX, LocY: double);
    { Protected declarations }
  public
    LastBlock : TBlock;
    LastNode : TNode;
    LastElement : TElement;
    Procedure GetBlockCenteredGrid(Const LayerName : string);
    procedure GetNodeCenteredGrid(const LayerName: string);
    Procedure GetMeshWithName(const LayerName : string);
    { Public declarations }
  end;

function PointsNearlyTheSame(const Point1,Point2 : TRealPoint;
  const Epsilon: extended) : boolean;

function IsPointInside(const X, Y: extended;
  const ZoomPointArray: TRealPointArray): boolean;
  
var
  frmSample: TfrmSample;

const
  CornerCount = 4;

implementation

uses UtilityFunctions, RealListUnit, OptionsUnit;

{$R *.DFM}

function NearlyTheSame(const X,Y, Epsilon : extended) : boolean;
begin
  result := (X = Y)
    or (Abs(X-Y) < Epsilon)
    or (Abs(X-Y)/(Abs(X)+Abs(Y)+Epsilon) < Epsilon);
end;

function PointsNearlyTheSame(const Point1,Point2 : TRealPoint;
  const Epsilon: extended) : boolean;
var
  X1, X2, Y1, Y2 : double;
begin
  X1 := Point1.X;
  X2 := Point2.X;
  Y1 := Point1.Y;
  Y2 := Point2.Y;
  result := NearlyTheSame(X1, X2, Epsilon)
    and NearlyTheSame(Y1, Y2, Epsilon);
end;

function IsPointInside(const X, Y: extended;
  const ZoomPointArray: TRealPointArray): boolean;
var
  VertexIndex : integer;
  AZoomPoint, AnotherZoomPoint : TRealPoint;
begin   // based on CACM 112
  if Length(ZoomPointArray) < 4 then
  begin
    result := false;
    Exit;
  end;
  AZoomPoint := ZoomPointArray[0];
  AnotherZoomPoint := ZoomPointArray[Length(ZoomPointArray) -1];
  if (AZoomPoint.X <> AnotherZoomPoint.X) or
    (AZoomPoint.Y <> AnotherZoomPoint.Y) then
  begin
    result := False;
    Exit;
  end;

  result := true;
  For VertexIndex := 0 to Length(ZoomPointArray) -2 do
  begin
    AZoomPoint := ZoomPointArray[VertexIndex];
    AnotherZoomPoint := ZoomPointArray[VertexIndex+1];
    if ((Y <= AZoomPoint.Y) = (Y > AnotherZoomPoint.Y)) and
       (X - AZoomPoint.X - (Y - AZoomPoint.Y) *
         (AnotherZoomPoint.X - AZoomPoint.X)/
         (AnotherZoomPoint.Y - AZoomPoint.Y) < 0) then
    begin
      result := not result;
    end;
  end;
  result := not result;
end;

{ TRealPoint }

function TRealPoint.GetValues: TVDoubleArray;
begin
  result := nil;
end;

{ TNode }

constructor TNode.Create;
begin
  inherited Create;
  Elements := TList.Create;
end;

destructor TNode.Destroy;
var
  PointIndex : integer;
begin
  Elements.Free;
  for PointIndex := 0 to Length(Points)-1 do
  begin
    Points[PointIndex].Free;
  end;
  inherited;
end;

function TNode.GetValues : TVDoubleArray;
var
  Index: integer;
begin
  case frmSample.MeshImportChoice of
    micClosestNode, micHighestNode, micLowestNode:
      begin
        if Count = 0 then
        begin
          result := nil;
        end
        else
        begin
          result := FValues;
          SetLength(result, Length(result));
        end;
      end;
    micAverageNode:
      begin
        if Count = 0 then
        begin
          result := nil;
        end
        else
        begin
          SetLength(result, Length(FValues));
          for Index := 0 to Length(FValues) -1 do
          begin
            result[Index] := FValues[Index]/Count;
          end;
        end;
      end;
  else
    result := nil;
  end;
end;

function TNode.IsInside(PointX, PointY: extended): boolean;
var
  ArrayLength : integer;
begin
  ArrayLength := Length(Points);
  try
    SetLength(Points,ArrayLength+1);
    Points[ArrayLength] := Points[0];
    result := IsPointInside(PointX, PointY, Points);
  finally
    SetLength(Points,ArrayLength);
  end;
end;

procedure TNode.MakeCell;
const
  Epsilon = 1e-8;
Var
  NextNode, PreviousNode : TNode;
  NodeIndex, SegmentIndex : integer;
  Element : TElement;
  CellParts : TList;
  CellPart : TList;
  ElementIndex : integer;
  OuterCellPart, InnerCellPart : TList;
  SideDeleted : boolean;
  NextSideFound : boolean;
  CellList : TList;
  FirstPoint, LastPoint : TRealPoint;
  ASegment : TSegment;
  function DeleteSide : boolean;
  var
    OuterCellPartIndex, InnerCellPartIndex : integer;
    OuterSegmentIndex, InnerSegmentIndex : integer;
    Seg1, Seg2 : TSegment;
  begin
    result := False;
    for OuterCellPartIndex := 0 to CellParts.Count -2 do
    begin
      OuterCellPart := CellParts[OuterCellPartIndex];
      for InnerCellPartIndex := OuterCellPartIndex + 1 to CellParts.Count -1 do
      begin
        InnerCellPart := CellParts[InnerCellPartIndex];
        for OuterSegmentIndex := OuterCellPart.Count -1 downto 0 do
        begin
          Seg1 := OuterCellPart[OuterSegmentIndex];
          for InnerSegmentIndex := InnerCellPart.Count -1 downto 0 do
          begin
            Seg2 := InnerCellPart[InnerSegmentIndex];
            if Seg1.IsSimilar(Seg2, Epsilon) then
            begin
              result := True;
              Seg1.Free;
              Seg2.Free;
              OuterCellPart.Delete(OuterSegmentIndex);
              InnerCellPart.Delete(InnerSegmentIndex);
              Exit;
            end;
          end;
        end;
      end;
    end;
  end;
  function GetNextSide : boolean;
  var
    ElementIndex : integer;
    SegmentIndex : integer;
    LastPoint, NextPoint : TRealPoint;
    ASegment : TSegment;
  begin
    result := False;
    LastPoint := CellList[CellList.Count -1];
    for ElementIndex := 0 to CellParts.Count -1 do
    begin
      CellPart := CellParts[ElementIndex];
      if CellPart.Count > 0 then
      begin
        ASegment := CellPart[0];
        NextPoint := ASegment.Point1;
        if PointsNearlyTheSame(LastPoint,NextPoint,Epsilon) then
        begin
          for SegmentIndex := 0 to CellPart.Count -1 do
          begin
            ASegment := CellPart[SegmentIndex];
            CellList.Add(ASegment.Point2);
            ASegment.Point2 := nil;
            ASegment.Free;
          end;
          CellPart.Clear;
          result := True;
          Exit;
        end
        else
        begin
          ASegment := CellPart[CellPart.Count -1];
          NextPoint := ASegment.Point2;
          if PointsNearlyTheSame(LastPoint,NextPoint,Epsilon) then
          begin
            for SegmentIndex := CellPart.Count -1 downto 0 do
            begin
              ASegment := CellPart[SegmentIndex];
              CellList.Add(ASegment.Point1);
              ASegment.Point1 := nil;
              ASegment.Free;
            end;
            CellPart.Clear;
            result := True;
            Exit;
          end
        end;

      end;
    end;
  end;
begin
  CellList := TList.Create;
  CellParts := TList.Create;
  try
    for ElementIndex := 0 to Elements.Count -1 do
    begin
      Element := Elements[ElementIndex];
      NodeIndex := Element.IndexOf(self);
      if NodeIndex >= Length(Element.Points) - 1 then
      begin
        NodeIndex := 0
      end
      else
      begin
        Inc(NodeIndex);
      end;
      NextNode := Element.Points[NodeIndex] as TNode;
      Dec(NodeIndex,2);
      if NodeIndex < 0 then
      begin
        NodeIndex := Length(Element.Points) + NodeIndex;
      end;
      PreviousNode := Element.Points[NodeIndex] as TNode;
      CellPart := TList.Create;
      CellParts.Add(CellPart);

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRealPoint.Create;
      ASegment.Point1.FX := X;
      ASegment.Point1.FY := Y;
      ASegment.Point2 := TRealPoint.Create;
      ASegment.Point2.FX := (X + PreviousNode.X)/2;
      ASegment.Point2.FY := (Y + PreviousNode.Y)/2;

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRealPoint.Create;
      ASegment.Point1.FX := (X + PreviousNode.X)/2;
      ASegment.Point1.FY := (Y + PreviousNode.Y)/2;
      ASegment.Point2 := TRealPoint.Create;
      ASegment.Point2.FX := Element.X;
      ASegment.Point2.FY := Element.Y;

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRealPoint.Create;
      ASegment.Point1.FX := Element.X;
      ASegment.Point1.FY := Element.Y;
      ASegment.Point2 := TRealPoint.Create;
      ASegment.Point2.FX := (X + NextNode.X)/2;
      ASegment.Point2.FY := (Y + NextNode.Y)/2;

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRealPoint.Create;
      ASegment.Point1.FX := (X + NextNode.X)/2;
      ASegment.Point1.FY := (Y + NextNode.Y)/2;
      ASegment.Point2 := TRealPoint.Create;
      ASegment.Point2.FX := X;
      ASegment.Point2.FY := Y;
    end;
    Repeat
      SideDeleted := DeleteSide;
    until not SideDeleted;

    for ElementIndex := CellParts.Count -1 downto 0 do
    begin
      CellPart := CellParts[ElementIndex];
      if CellPart.Count = 0 then
      begin
        CellPart.Free;
        CellParts.Delete(ElementIndex);
      end;
    end;

    if CellParts.Count > 0 then
    begin
      CellPart := CellParts[0];
      for SegmentIndex := 0 to CellPart.Count -1 do
      begin
        ASegment := CellPart[SegmentIndex];
        if SegmentIndex = 0 then
        begin
          CellList.Add(ASegment.Point1);
          ASegment.Point1 := nil;
        end;
        CellList.Add(ASegment.Point2);
        ASegment.Point2 := nil;
        ASegment.Free;
      end;
      CellPart.Free;
      CellParts.Delete(0);

      repeat
        NextSideFound := GetNextSide
      until not NextSideFound;

    end;

    if CellList.Count > 1 then
    begin
      FirstPoint := CellList[0];
      LastPoint := CellList[CellList.Count -1];
      if PointsNearlyTheSame(FirstPoint,LastPoint,Epsilon) then
      begin
        LastPoint.Free;
        CellList.Delete(CellList.Count -1);
      end;

    end;

    SetLength(Points,CellList.Count);
    for NodeIndex := 0 to CellList.Count -1 do
    begin
      Points[NodeIndex] := CellList[NodeIndex];
    end;

  finally
    for ElementIndex := 0 to CellParts.Count -1 do
    begin
      CellPart := CellParts[ElementIndex];
      CellPart.Free;
    end;
    CellParts.Free;
    CellList.Free;
  end;

end;

procedure TNode.SetValues(const LocX, LocY: double; const Values: TVDoubleArray);
var
  PointDistance2 : double;
  Index: integer;
begin
  case frmSample.MeshImportChoice of
    micClosestNode:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
          Distance2 := Sqr(X - LocX) + Sqr(Y - LocY);
        end
        else
        begin
          PointDistance2 := Sqr(X - LocX) + Sqr(Y - LocY);
          if PointDistance2 < Distance2 then
          begin
            FValues := Values;
            SetLength(FValues, Length(FValues));
            Distance2 := PointDistance2;
          end;
        end;
      end;
    micAverageNode:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            FValues[Index] := FValues[Index] + Values[Index];
          end;
          Inc(FCount);
        end;
      end;
    micHighestNode:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            if FValues[Index] < Values[Index] then
            begin
              FValues[Index] := Values[Index] ;
            end;
          end;
        end;
      end;
    micLowestNode:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            if FValues[Index] > Values[Index] then
            begin
              FValues[Index] := Values[Index] ;
            end;
          end;
        end;
      end;
  end;
end;

{ TElement }

function TElement.GetValues : TVDoubleArray;
var
  Index: integer;
begin
  case frmSample.MeshImportChoice of
    micClosestElement, micHighestElement, micLowestElement:
      begin
        if Count = 0 then
        begin
          result := nil;
        end
        else
        begin
          result := FValues;
          SetLength(result, Length(FValues));
        end;
      end;
    micAverageElement:
      begin
        if Count = 0 then
        begin
          result := nil;
        end
        else
        begin
          SetLength(result, Length(FValues));
          for Index := 0 to Length(FValues) -1 do
          begin
            result[Index] := FValues[Index]/Count;
          end;
        end;
      end;
  else
    result := nil;
  end;
end;

function TElement.IndexOf(const Node: TNode): integer;
var
  Index : integer;
begin
  result := -1;
  for Index := 0 to Length(Points) -1 do
  begin
    if Points[Index] = Node then
    begin
      result := Index;
      Exit;
    end;
  end;
end;

function TElement.IsInside(PointX, PointY: extended): boolean;
var
  ArrayLength : integer;
begin
  ArrayLength := Length(Points);
  try
    SetLength(Points,ArrayLength+1);
    Points[ArrayLength] := Points[0];
    result := IsPointInside(PointX, PointY, Points);
  finally
    SetLength(Points,ArrayLength);
  end;
end;

procedure TElement.SetCenterPoint;
var
  Index : integer;
begin
  FX := 0;
  FY := 0;
  for Index := 0 to Length(Points) -1 do
  begin
    FX := X + Points[Index].X;
    FY := Y + Points[Index].Y;
  end;
  FX := X/Length(Points);
  FY := Y/Length(Points);
end;


procedure TElement.SetValues(const LocX, LocY: double; const Values: TVDoubleArray);
var
  PointDistance2 : double;
  Index: integer;
begin
  case frmSample.MeshImportChoice of
    micClosestElement:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
          Distance2 := Sqr(X - LocX) + Sqr(Y - LocY);
        end
        else
        begin
          PointDistance2 := Sqr(X - LocX) + Sqr(Y - LocY);
          if PointDistance2 < Distance2 then
          begin
            FValues := Values;
            SetLength(FValues, Length(FValues));
            Distance2 := PointDistance2;
          end;
        end;
      end;
    micAverageElement:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            FValues[Index] := FValues[Index] + Values[Index];
          end;
          Inc(FCount);
        end;

      end;
    micHighestElement:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            if FValues[Index] < Values[Index] then
            begin
              FValues[Index] := Values[Index] ;
            end;
          end;
        end;
      end;
    micLowestElement:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            if FValues[Index] > Values[Index] then
            begin
              FValues[Index] := Values[Index] ;
            end;
          end;
        end;
      end;
  end;
end;

{ TSegment }

destructor TSegment.Destroy;
begin
  Point1.Free;
  Point2.Free;
  inherited;
end;

function TSegment.IsSimilar(const ASegment: TSegment;
  const Epsilon : extended): boolean;
begin
  result := (PointsNearlyTheSame(Point1,ASegment.Point1, Epsilon)
    and PointsNearlyTheSame(Point2,ASegment.Point2, Epsilon)) or
    (PointsNearlyTheSame(Point1,ASegment.Point2, Epsilon)
    and PointsNearlyTheSame(Point2,ASegment.Point1, Epsilon))
end;

{ TBlock }

constructor TBlock.Create(const Index : integer);
begin
  inherited Create;
  FIndex := Index;
  SetLength(Points, CornerCount);
end;

destructor TBlock.Destroy;
var
  PointIndex : integer;
begin
  for PointIndex := 0 to Length(Points)-1 do
  begin
    Points[PointIndex].Free;
  end;
  inherited;
end;

function TBlock.GetValues : TVDoubleArray;
var
  Index: integer;
begin
  case frmSample.GridImportChoice of
    gicClosest, gicHighest, gicLowest:
      begin
        if Count = 0 then
        begin
          result := nil;
        end
        else
        begin
          result := FValues;
          SetLength(result, Length(FValues));
        end;
      end;
    gicAverage:
      begin
        if Count = 0 then
        begin
          result := nil;
        end
        else
        begin
          SetLength(result, Length(FValues));
          for Index := 0 to Length(FValues) -1 do
          begin
            result[Index] := FValues[Index]/Count;
          end;
        end;
      end;
  else
    result := nil;
  end;
end;

procedure TBlock.SetValues(const LocX, LocY: double; const Values: TVDoubleArray);
var
  PointDistance2 : double;
  Index: integer;
begin
  case frmSample.GridImportChoice of
    gicClosest:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
          Distance2 := Sqr(X - LocX) + Sqr(Y - LocY);
        end
        else
        begin
          PointDistance2 := Sqr(X - LocX) + Sqr(Y - LocY);
          if PointDistance2 < Distance2 then
          begin
            FValues := Values;
            SetLength(FValues, Length(FValues));
            Distance2 := PointDistance2;
          end;
        end;
      end;
    gicAverage:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            FValues[Index] := FValues[Index] + Values[Index];
          end;
          Inc(FCount);
        end;
      end;
    gicHighest:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            if FValues[Index] < Values[Index] then
            begin
              FValues[Index] := Values[Index] ;
            end;
          end;
        end;
      end;
    gicLowest:
      begin
        if Count = 0 then
        begin
          FValues := Values;
          SetLength(FValues, Length(FValues));
          FCount := 1;
        end
        else
        begin
          Assert(Length(FValues) = Length(Values));
          for Index := 0 to Length(FValues) -1 do
          begin
            if FValues[Index] > Values[Index] then
            begin
              FValues[Index] := Values[Index] ;
            end;
          end;
        end;
      end;
  end;
end;



procedure TfrmSample.FormCreate(Sender: TObject);
begin
  inherited;
  frmSample := self;
end;

procedure TfrmSample.GetBlockCenteredGrid(const LayerName: string);
var
  LayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  GridAngle : ANE_DOUBLE;
  RowPositions1, ColPositions1 : TRealList;
  RowIndex, ColIndex : integer;
  GridLayer : TGridLayerOptions;
  Block : TBlock;
  X, Y : double;
  RowsReversed, ColumnsReversed : boolean;
  Temp : double;
  CornerIndex : integer;
begin
  SearchRadius := 0;
  qtBlocksElements.Clear;
  MapLayerName := '';
  GetGridOutline(LayerName,
    LayerHandle, NRow, NCol, GridAngle);
  if (NRow > 0) and (NCol > 0) then
  begin
    RowPositions1 := TRealList.Create;
    ColPositions1 := TRealList.Create;
    GridLayer := TGridLayerOptions.Create(CurrentModelHandle, LayerHandle);
    try
      for RowIndex := 0 to NRow do
      begin
        RowPositions1.Add(GridLayer.RowPositions(CurrentModelHandle,RowIndex));
      end;
      for ColIndex := 0 to NCol do
      begin
        ColPositions1.Add(GridLayer.ColumnPositions(CurrentModelHandle,ColIndex));
      end;

      RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
      ColumnsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];

      if RowsReversed then
      begin
        for RowIndex := 0 to ((RowPositions1.Count -1) div 2) do
        begin
          RowPositions1.Exchange(RowIndex, RowPositions1.Count-1 -RowIndex);
        end;
      end;

      if ColumnsReversed then
      begin
        for ColIndex := 0 to ((ColPositions1.Count -1) div 2) do
        begin
          ColPositions1.Exchange(ColIndex, ColPositions1.Count-1 -ColIndex);
        end;
      end;

      RowCount := RowPositions1.Count -1;
      ColCount := ColPositions1.Count -1;
      BlockList := TObjectList.Create;
      for RowIndex := 0 to RowPositions1.Count -2 do
      begin
        for ColIndex := 0 to ColPositions1.Count -2 do
        begin
          Block := TBlock.Create(BlockList.Count);
          BlockList.Add(Block);

          X := ColPositions1[ColIndex];
          Y := RowPositions1[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[0] := TRealPoint.Create;
          Block.Points[0].FX := X;
          Block.Points[0].FY := Y;
          Block.FX := X;
          Block.FY := Y;

          X := ColPositions1[ColIndex+1];
          Y := RowPositions1[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[1] := TRealPoint.Create;
          Block.Points[1].FX := X;
          Block.Points[1].FY := Y;
          Block.FX := Block.X + X;
          Block.FY := Block.Y + Y;

          X := ColPositions1[ColIndex+1];
          Y := RowPositions1[RowIndex+1];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[2] := TRealPoint.Create;
          Block.Points[2].FX := X;
          Block.Points[2].FY := Y;
          Block.FX := Block.X + X;
          Block.FY := Block.Y + Y;

          X := ColPositions1[ColIndex];
          Y := RowPositions1[RowIndex+1];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[3] := TRealPoint.Create;
          Block.Points[3].FX := X;
          Block.Points[3].FY := Y;
          Block.FX := Block.X + X;
          Block.FY := Block.Y + Y;

          Block.FX := Block.X/4;
          Block.FY := Block.Y/4;

          qtBlocksElements.AddPoint(Block.X, Block.Y, Block);

          for CornerIndex := 0 to 3 do
          begin
            Temp := Sqrt(Sqr(Block.Points[CornerIndex].X - Block.X)
              + Sqr(Block.Points[CornerIndex].Y - Block.Y));
            if Temp > SearchRadius then
            begin
              SearchRadius := Temp;
            end;
          end;
        end;
      end;
      SearchRadius := 1.01*SearchRadius;
    finally
      RowPositions1.Free;
      ColPositions1.Free;
      GridLayer.Free(CurrentModelhandle);
    end;
  end;
end;

procedure TfrmSample.GetGridOutline(const LayerName: string;
  var LayerHandle: ANE_PTR; var NRow, NCol: ANE_INT32;
  var GridAngle: ANE_DOUBLE);
var
  MinX, MaxX, MinY, MaxY : ANE_DOUBLE;
  Index : integer;
  X, Y : double;
begin
  GetGrid(CurrentModelHandle, LayerName,
    LayerHandle, NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);
  SetLength(GridOutline,5);
  for Index := 0 to 3 do
  begin
    GridOutline[Index] := TRealPoint.Create;
  end;
  GridOutline[4] := GridOutline[0];

  X := MinX;
  Y := MinY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[0].FX := X;
  GridOutline[0].FY := Y;

  X := MaxX;
  Y := MinY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[1].FX := X;
  GridOutline[1].FY := Y;

  X := MaxX;
  Y := MaxY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[2].FX := X;
  GridOutline[2].FY := Y;

  X := MinX;
  Y := MaxY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[3].FX := X;
  GridOutline[3].FY := Y;

  MinX := GridOutline[0].X;
  MaxX := MinX;
  MinY := GridOutline[0].Y;
  MaxY := MinY;

  for Index := 1 to 3 do
  begin
    if GridOutline[0].X < MinX then
    begin
      MinX := GridOutline[0].X
    end;
    if GridOutline[0].X > MaxX then
    begin
      MaxX := GridOutline[0].X
    end;
    if GridOutline[0].Y < MinY then
    begin
      MinY := GridOutline[0].Y
    end;
    if GridOutline[0].Y > MaxY then
    begin
      MaxY := GridOutline[0].Y
    end;

  end;
  qtBlocksElements.XMin := MinX;
  qtBlocksElements.XMax := MaxX;
  qtBlocksElements.YMin := MinY;
  qtBlocksElements.YMax := MaxY;
end;

procedure TfrmSample.GetMeshWithName(const LayerName: string);
var
  MeshLayer : TLayerOptions;
  NodeIndex : ANE_INT32;
  ElementIndex : ANE_INT32;
  NodeOption : TNodeObjectOptions;
  Node : TNode;
  X, Y: ANE_DOUBLE;
  ElementOptions : TElementObjectOptions;
  Element : TElement;
  NodeCount : integer;
  Temp : double;
  MinX, MinY, MaxX, MaxY : double;
  PointIndex : integer;
begin
  MinX := 0;
  MaxX := 0;
  MinY := 0;
  MaxY := 0;
  SearchRadius := 0;
  NodeSearchRadius := 0;
  qtBlocksElements.Clear;
  qtNodes.Clear;
  MapLayerName := '';
  MeshLayer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
  try
    NodeList := TObjectList.Create;
    ElementList := TObjectList.Create;

    NodeCount := MeshLayer.NumObjects
      (CurrentModelHandle, pieNodeObject);
    if NodeCount <= 0 then
    begin
      Beep;
      MessageDlg('You must have a mesh before attempting to import data.',
        mtError, [mbOK], 0);
    end;

    for NodeIndex := 0 to NodeCount -1 do
    begin
      NodeOption := TNodeObjectOptions.Create(CurrentModelHandle,
        MeshLayer.LayerHandle, NodeIndex);
      try
        Node := TNode.Create;
        NodeList.Add(Node);
        NodeOption.GetLocation(CurrentModelHandle, X, Y);
        Node.FX := X;
        Node.FY := Y;

        if NodeIndex = 0 then
        begin
          MinX := X;
          MaxX := X;
          MinY := Y;
          MaxY := Y;
        end
        else
        begin
          if X > MaxX then
          begin
            MaxX := X;
          end;
          if X < MinX then
          begin
            MinX := X;
          end;
          if Y > MaxY then
          begin
            MaxY := Y;
          end;
          if Y < MinY then
          begin
            MinY := Y;
          end;
        end;

      finally
        NodeOption.Free;
      end;
    end;

    qtBlocksElements.XMin := MinX;
    qtBlocksElements.XMax := MaxX;
    qtBlocksElements.YMin := MinY;
    qtBlocksElements.YMax := MaxY;

    qtNodes.XMin := MinX;
    qtNodes.XMax := MaxX;
    qtNodes.YMin := MinY;
    qtNodes.YMax := MaxY;


    for ElementIndex := 0 to MeshLayer.NumObjects
      (CurrentModelHandle, pieElementObject) -1 do
    begin
      ElementOptions := TElementObjectOptions.Create
        (CurrentModelHandle,MeshLayer.LayerHandle, ElementIndex);
      try
        NodeCount := ElementOptions.NumberOfNodes(CurrentModelHandle);
        Element := TElement.Create;
        ElementList.Add(Element);
        SetLength(Element.Points,NodeCount);
        for NodeIndex := 0 to NodeCount-1 do
        begin
          Node := NodeList[ElementOptions.GetNthNodeNumber
            (CurrentModelHandle,NodeIndex) -1] as TNode;
          Element.Points[NodeIndex] := Node;
          Node.Elements.Add(Element);
        end;
        Element.SetCenterPoint;

        qtBlocksElements.AddPoint(Element.X, Element.Y, Element);

        for NodeIndex := 0 to NodeCount-1 do
        begin
          Node := Element.Points[NodeIndex] as TNode;
          Temp := Sqrt(Sqr(Element.X - Node.X)
            + Sqr(Element.Y - Node.Y));
          if Temp > SearchRadius then
          begin
            SearchRadius := Temp;
          end;
        end;
        SearchRadius := 1.01*SearchRadius;
      finally
        ElementOptions.Free;
      end;
    end;
    for NodeIndex := 0 to NodeList.Count -1 do
    begin
      Node := NodeList[NodeIndex] as TNode;
      Node.MakeCell;

      qtNodes.AddPoint(Node.X, Node.Y, Node);
      for PointIndex := 0 to Length(Node.Points) -1 do
      begin
        Temp := Sqrt(Sqr(Node.X - Node.Points[PointIndex].X)
          + Sqr(Node.Y - Node.Points[PointIndex].Y));
        if Temp > NodeSearchRadius then
        begin
          NodeSearchRadius := Temp;
        end;
      end;
    end;

  finally
    MeshLayer.Free(CurrentModelHandle);
  end;
  MinMeshX := MinX;
  MaxMeshX := MaxX;
  MinMeshY := MinY;
  MaxMeshY := MaxY;
end;

procedure TfrmSample.GetNodeCenteredGrid(const LayerName: string);
var
  LayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  GridAngle : ANE_DOUBLE;
  RowPositions1, ColPositions1 : TRealList;
  RowPositions2, ColPositions2 : TRealList;
  RowIndex, ColIndex : integer;
  GridLayer : TGridLayerOptions;
  Block : TBlock;
  X, Y : double;
  RowsReversed, ColumnsReversed : boolean;
  Temp : double;
  CornerIndex : integer;
begin
  SearchRadius := 0;
  qtBlocksElements.Clear;
  MapLayerName := '';
  GetGridOutline(LayerName,
    LayerHandle, NRow, NCol, GridAngle);
  if (NRow > 0) and (NCol > 0) then
  begin
    RowPositions1 := TRealList.Create;
    ColPositions1 := TRealList.Create;
    RowPositions2 := TRealList.Create;
    ColPositions2 := TRealList.Create;
    GridLayer := TGridLayerOptions.Create(CurrentModelHandle, LayerHandle);
    try
      for RowIndex := 0 to NRow-1 do
      begin
        RowPositions1.Add(GridLayer.RowPositions(CurrentModelHandle,RowIndex));
      end;
      for ColIndex := 0 to NCol-1 do
      begin
        ColPositions1.Add(GridLayer.ColumnPositions(CurrentModelHandle,ColIndex));
      end;

      RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
      ColumnsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];

      if RowsReversed then
      begin
        for RowIndex := 1 to ((RowPositions1.Count -1) div 2) do
        begin
          RowPositions1.Exchange(RowIndex, RowPositions1.Count -RowIndex);
        end;
      end;

      if ColumnsReversed then
      begin
        for ColIndex := 1 to ((ColPositions1.Count -1) div 2) do
        begin
          ColPositions1.Exchange(ColIndex, ColPositions1.Count -ColIndex);
        end;
      end;

      RowPositions2.Add(RowPositions1[0]);
      for RowIndex := 0 to RowPositions1.Count -2 do
      begin
        RowPositions2.Add((RowPositions1[RowIndex] + RowPositions1[RowIndex+1])/2);
      end;
      RowPositions2.Add(RowPositions1[RowPositions1.Count-1]);

      ColPositions2.Add(ColPositions1[0]);
      for ColIndex := 0 to ColPositions1.Count -2 do
      begin
        ColPositions2.Add((ColPositions1[ColIndex] + ColPositions1[ColIndex+1])/2);
      end;
      ColPositions2.Add(ColPositions1[ColPositions1.Count-1]);

      RowCount := RowPositions2.Count -1;
      ColCount := ColPositions2.Count -1;
      BlockList := TObjectList.Create;
      for RowIndex := 0 to RowPositions2.Count -2 do
      begin
        for ColIndex := 0 to ColPositions2.Count -2 do
        begin
          Block := TBlock.Create(BlockList.Count);
          BlockList.Add(Block);

          X := ColPositions2[ColIndex];
          Y := RowPositions2[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[0] := TRealPoint.Create;
          Block.Points[0].FX := X;
          Block.Points[0].FY := Y;

          X := ColPositions2[ColIndex+1];
          Y := RowPositions2[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[1] := TRealPoint.Create;
          Block.Points[1].FX := X;
          Block.Points[1].FY := Y;

          X := ColPositions2[ColIndex+1];
          Y := RowPositions2[RowIndex+1];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[2] := TRealPoint.Create;
          Block.Points[2].FX := X;
          Block.Points[2].FY := Y;

          X := ColPositions2[ColIndex];
          Y := RowPositions2[RowIndex+1];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[3] := TRealPoint.Create;
          Block.Points[3].FX := X;
          Block.Points[3].FY := Y;

          X := ColPositions1[ColIndex];
          Y := RowPositions1[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.FX := X;
          Block.FY := Y;

          qtBlocksElements.AddPoint(Block.X, Block.Y, Block);

          for CornerIndex := 0 to 3 do
          begin
            Temp := Sqrt(Sqr(Block.Points[CornerIndex].X - Block.X)
              + Sqr(Block.Points[CornerIndex].Y - Block.Y));
            if Temp > SearchRadius then
            begin
              SearchRadius := Temp;
            end;
          end;
        end;
      end;
      SearchRadius := 1.01*SearchRadius;
    finally
      RowPositions1.Free;
      ColPositions1.Free;
      RowPositions2.Free;
      ColPositions2.Free;
      GridLayer.Free(CurrentModelhandle);
    end;
  end;
end;

procedure TfrmSample.ResetData;
var
  Index : integer;
  Block : TBlock;
  Node : TNode;
  Element : TElement;
begin
  if BlockList <> nil then
  begin
    for Index := 0 to BlockList.Count -1 do
    begin
      Block := BlockList[Index] as TBlock;
      Block.FCount := 0;
      Block.FValues := nil;
      Block.Distance2 := 0;
    end;
  end;
  if NodeList <> nil then
  begin
    for Index := 0 to NodeList.Count -1 do
    begin
      Node := NodeList[Index] as TNode;
      Node.FCount := 0;
      Node.FValues := nil;
      Node.Distance2 := 0;
    end;
  end;
  if ElementList <> nil then
  begin
    for Index := 0 to ElementList.Count -1 do
    begin
      Element := ElementList[Index] as TElement;
      Element.FCount := 0;
      Element.FValues := nil;
      Element.Distance2 := 0;
    end;
  end;
end;

procedure TfrmSample.SetValues(const Values: TVDoubleArray; const LocX,
  LocY: double);
var
  Index : integer;
  Block : TBlock;
  Node : TNode;
  Element : TElement;
  Points: TQuadPointInRegionArray;
begin
  if BlockList <> nil then
  begin
    if GridImportChoice = gicAll then
    begin
      Exit;
    end;
    if IsPointInside(LocX, LocY, GridOutline) then
    begin
      if (LastBlock <> nil) and (LastBlock.IsInside(LocX, LocY)) then
      begin
        LastBlock.SetValues(LocX, LocY, Values);
      end
      else
      begin
        qtBlocksElements.FindPointsInCircle(LocX, LocY, SearchRadius, Points);
        LastBlock := nil;
        for Index := 0 to Length(Points) -1 do
        begin
          Block := Points[Index].Data[0];
          if Block.IsInside(LocX, LocY) then
          begin
            Block.SetValues(LocX, LocY, Values);
            LastBlock := Block;
            break;
          end;
        end;
      end;
    end;
  end
  else if NodeList <> nil then
  begin
    if MeshImportChoice = micAll then
    begin
      Exit;
    end;
    if (LocX <= MaxMeshX) and (LocX >= MinMeshX)
      and (LocY <= MaxMeshY) and (LocY >= MinMeshY) then
    begin
      case MeshImportChoice of
        micClosestNode, micAverageNode, micHighestNode, micLowestNode:
          begin
            if (LastNode <> nil) and (LastNode.IsInside(LocX, LocY)) then
            begin
              LastNode.SetValues(LocX, LocY, Values);
            end
            else
            begin
              qtNodes.FindPointsInCircle(LocX, LocY, NodeSearchRadius, Points);
              for Index := 0 to Length(Points) -1 do
              begin
                Node := Points[Index].Data[0];
                if Node.IsInside(LocX, LocY) then
                begin
                  Node.SetValues(LocX, LocY, Values);
                  LastNode := Node;
                  break;
                end;
              end;
            end;
          end;
        micClosestElement, micAverageElement, micHighestElement, micLowestElement:
          begin
            if (LastElement <> nil) and (LastElement.IsInside(LocX, LocY)) then
            begin
              LastElement.SetValues(LocX, LocY, Values);
            end
            else
            begin
              qtBlocksElements.FindPointsInCircle(LocX, LocY, SearchRadius, Points);
              for Index := 0 to Length(Points) -1 do
              begin
                Element := Points[Index].Data[0];
                if Element.IsInside(LocX, LocY) then
                begin
                  Element.SetValues(LocX, LocY, Values);
                  LastElement := Element;
                  break;
                end;
              end;
            end;
          end;
      end;
    end;
  end;
end;

procedure TfrmSample.FormDestroy(Sender: TObject);
var
  Index : integer;
begin
  inherited;
  BlockList.Free;
  NodeList.Free;
  ElementList.Free;
  for Index := 0 to Length(GridOutline) -2 do
  begin
    GridOutline[Index].Free;
  end;
  frmSample := nil;
end;

end.
