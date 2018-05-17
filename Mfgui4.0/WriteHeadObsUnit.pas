unit WriteHeadObsUnit;

interface

uses Sysutils, Classes, StdCtrls, contnrs, Math, ANEPIE, OptionsUnit,
  WriteModflowDiscretization, WriteBCF_Unit, IntListUnit;

type
  THeadObsTime = record
    Name : string[12];
    Time : double;
    Head : double;
    Layer : integer;
    Row : integer;
    Column : integer;
    RowOffset : double;
    ColOffset : double;
    Statistic : double;
    StatFlag : integer;
    PlotSymbol : integer;
//    ReferenceStressPeriod: integer;
  end;

  TMultObsTime = record
    Name : string[12];
    Time : double;
    Head : double;
    STATh : double;
    STATdd : double;
    StatFlag : integer;
    PlotSymbol : integer;
    ReferenceStressPeriod: integer;
  end;

  TMultLayer = record
    Layer : integer;
    Weight : double;
  end;

  TParamIndicies = record
    TopElevIndex : ANE_INT16;
    BotElevIndex : ANE_INT16;
    TopLayerIndex : ANE_INT16;
    BottomLayerIndex : ANE_INT16;
    StatFlagIndex : ANE_INT16;
    PlotSymbolIndex : ANE_INT16;
    ITTIndex : ANE_INT16;
//    ReferenceStressPeriodIndex : ANE_INT16;
  end;

  TTimeParamIndicies = record
    NameIndex : ANE_INT16;
    HeadIndex : ANE_INT16;
    TimeIndex : ANE_INT16;
    STAThIndex : ANE_INT16;
    STATddIndex : ANE_INT16;
    IsObservationIndex : ANE_INT16;
    IsPredictionIndex : ANE_INT16;
    RefStressPeriodIndex : ANE_INT16;
  end;

  TTimeParameterObject = Class(TObject)
    Indicies : TTimeParamIndicies;
  end;

  TimeParameterList = Class(TObjectList)
  private
    function GetItem(Index: Integer): TTimeParamIndicies;
    procedure SetItem(Index: Integer; Indicies: TTimeParamIndicies);
  public
    function Add(Indicies : TTimeParamIndicies) : integer;
    property Items[Index: Integer] : TTimeParamIndicies read GetItem Write SetItem;
  end;

  TObservationList = class;

  THeadObsWriter = class(TListWriter)
  private
    ModelHandle : ANE_PTR;
    ObservationList : TObservationList;
    UsePredictions : boolean;
    PointErrors : integer;
    function NormalLayerName(LayerIndex : integer) : string;
    function WeightLayerName(LayerIndex : integer) : string;
    procedure AddNormalLayer(LayerIndex : integer);
    procedure AddWeightedLayer(LayerIndex : integer);
    function NormalLayerCount : integer;
    function WeightedLayerCount : integer;
    function TimeCount : integer;
    function GetParamIndicies(Layer : TLayerOptions) : TParamIndicies;
    function GetTimeParamIndicies(Layer : TLayerOptions; TimeIndex : integer) : TTimeParamIndicies;
    procedure GetAContourProperties(LayerHandle : ANE_PTR;
      ContourIndex : ANE_INT32; ParamIndicies : TParamIndicies;
      TimeIndicies : TimeParameterList; Discretization : TDiscretizationWriter;
      FlowWriter : TFlowWriter; BasicWriter: TBasicPkgWriter; Weighted : boolean;
      WeightIndicies : TIntegerList);
    procedure EvaluteNormalLayers(Discretization : TDiscretizationWriter;
      FlowWriter : TFlowWriter; BasicWriter: TBasicPkgWriter);
    procedure GetContourProperties(Layer: TLayerOptions;
      Discretization: TDiscretizationWriter; FlowWriter: TFlowWriter;
      BasicWriter: TBasicPkgWriter; Weighted : boolean);
    procedure WriteDataSet1;
    Procedure WriteDataSet2;
    procedure WriteDataSet3to6;
    function GetWeightIndicies(Layer: TLayerOptions): TIntegerList;
    procedure EvaluteWeightedLayers(Discretization: TDiscretizationWriter;
      FlowWriter: TFlowWriter; BasicWriter: TBasicPkgWriter);
  public
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter;
      BasicWriter: TBasicPkgWriter);
  end;

  TMultiObservationTimeObject = class(TObject)
    ObsTime : TMultObsTime;
    private
    procedure WriteMultiTime(HeadObsWriter : THeadObsWriter);
  end;

  TMultiObservationTimeList = class(TObjectList)
    function Add(ATime : TMultObsTime): Integer;
    procedure WriteMultiTimes(const HeadObsWriter : THeadObsWriter;
      const Errors: TStringList);
  end;

  TMultiLayerObject = class(TObject)
    Layer : TMultLayer;
    procedure WriteLayer(HeadObsWriter : THeadObsWriter);
  end;

  TLayerList = class(TObjectList)
    function Add(ALayer : TMultLayer): Integer;
    procedure WriteLayers(HeadObsWriter : THeadObsWriter);
    procedure SetProportions;
  end;

  TObservationTimeObject = class(TObject)
  private
    ITT : integer;
    ObsTime : THeadObsTime;
    LayerList : TLayerList;
    MultiTimeList : TMultiObservationTimeList;
    procedure WriteTime(HeadObsWriter : THeadObsWriter;
      const TimeErrors, StatErrors: TStringList);
    Procedure SetLayerOrder(BasicWriter : TBasicPkgWriter; Discretization : TDiscretizationWriter);
  public
    Constructor Create;
    Destructor Destroy; override;
  end;

  TObservationList = class(TObjectList)
    function Add(ObsTime : THeadObsTime): TObservationTimeObject;
    procedure WriteObservations(HeadObsWriter : THeadObsWriter;
      const TimeErrors, StatErrors: TStringList);
  end;


implementation

uses Variables, UtilityFunctions, GetCellUnit, GetCellVertexUnit, GridUnit,
  ProgressUnit, WriteNameFileUnit, FixNameUnit;

{ TObservationTimeObject }

constructor TObservationTimeObject.Create;
begin
  inherited;
  LayerList := TLayerList.Create;
  MultiTimeList := TMultiObservationTimeList.Create;
end;

destructor TObservationTimeObject.Destroy;
begin
  LayerList.Free;
  MultiTimeList.Free;
  inherited;
end;

procedure TObservationTimeObject.SetLayerOrder(
  BasicWriter: TBasicPkgWriter; Discretization : TDiscretizationWriter);
  function IUNIT(Column, Row, UnitIndex : integer) : integer;
  begin
    result := BasicWriter.IBOUND[Column -1, Row -1, UnitIndex -1];
  end;
Var
  AnotherRow, AnotherColumn : integer;
  LayerIndex : integer;
  UnitIndex : integer;
  Layer : TMultiLayerObject;
  Count, Minimum : integer;
  SmallestLayer : integer;
begin
  if ObsTime.RowOffset > 0 then
  begin
    AnotherRow := ObsTime.Row + 1;
  end
  else
  begin
    AnotherRow := ObsTime.Row - 1;
  end;

  if ObsTime.ColOffset > 0 then
  begin
    AnotherColumn := ObsTime.Column + 1;
  end
  else
  begin
    AnotherColumn := ObsTime.Column - 1;
  end;

  Minimum := 5;
  SmallestLayer := 0;
  for LayerIndex := 0 to LayerList.Count -1 do
  begin
    Layer := LayerList[LayerIndex] as TMultiLayerObject;
    UnitIndex := frmModflow.GetUnitIndex(Layer.Layer.Layer);
    Count := 0;
    if IUNIT(ObsTime.Column, ObsTime.Row, UnitIndex) <> 0 then
    begin
      Inc(Count);
    end;
    if (AnotherRow > 0) and (AnotherRow < Discretization.NROW) and
      (IUNIT(ObsTime.Column, AnotherRow, UnitIndex) <> 0) then
    begin
      Inc(Count);
    end;
    if (AnotherColumn > 0) and (AnotherColumn <Discretization.NCOL) and
      (IUNIT(AnotherColumn, ObsTime.Row, UnitIndex) <> 0) then
    begin
      Inc(Count);
    end;
    if (AnotherRow > 0) and (AnotherRow < Discretization.NROW) and
      (AnotherColumn > 0) and (AnotherColumn <Discretization.NCOL) and
      (IUNIT(AnotherColumn, AnotherRow, UnitIndex) <> 0) then
    begin
      Inc(Count);
    end;
    if Count < Minimum then
    begin
      Minimum := Count;
      SmallestLayer := LayerIndex;
    end;
  end;
  if SmallestLayer <> 0 then
  begin
    LayerList.Exchange(0, SmallestLayer);
  end;

end;

procedure TObservationTimeObject.WriteTime(HeadObsWriter: THeadObsWriter;
  const TimeErrors, StatErrors: TStringList);
var
  IREFSP : integer;
  TOFFSET : double;
  LAYER : integer;
  AName: string;
  Position: integer;
  Time : TMultiObservationTimeObject;
  Item: TMultiLayerObject;
begin
  If LayerList.Count > 1 then
  begin
    LAYER := - LayerList.Count;
  end
  else if LayerList.Count = 1 then
  begin
    Item := LayerList[0] as TMultiLayerObject;
    LAYER := Item.Layer.Layer;
  end
  else
  begin
    LAYER := ObsTime.Layer
  end;

  if MultiTimeList.Count > 1 then
  begin
    IREFSP := -MultiTimeList.Count;
    TOFFSET := 0;
  end
  else
  begin
    Assert(MultiTimeList.Count = 1);
    Time := MultiTimeList.Items[0] as TMultiObservationTimeObject;
    IREFSP := Time.ObsTime.ReferenceStressPeriod;
    TOFFSET := ObsTime.Time;
  end;

  AName := Trim(ObsTime.Name);
  Position := Pos(' ', AName);
  while (Position > 0) do
  begin
    AName[Position] := '_';
    Position := Pos(' ', AName);
  end;
  if IREFSP >= 0 then
  begin
    AddObservationName(AName);
  end;
  AName := '''' + AName + ''' ';

  if frmMODFLOW.rbModflow2005.Checked then
  begin
    WriteLn(HeadObsWriter.FFile, AName, LAYER, ' ', ObsTime.Row,
      ' ', ObsTime.Column, ' ', IREFSP, ' ',
      HeadObsWriter.FreeFormattedReal(TOFFSET),
      HeadObsWriter.FreeFormattedReal(ObsTime.RowOffset),
      HeadObsWriter.FreeFormattedReal(ObsTime.ColOffset),
      HeadObsWriter.FreeFormattedReal(ObsTime.Head));
  end
  else
  begin
    WriteLn(HeadObsWriter.FFile, AName, LAYER, ' ', ObsTime.Row,
      ' ', ObsTime.Column, ' ', IREFSP, ' ',
      HeadObsWriter.FreeFormattedReal(TOFFSET),
      HeadObsWriter.FreeFormattedReal(ObsTime.RowOffset),
      HeadObsWriter.FreeFormattedReal(ObsTime.ColOffset),
      HeadObsWriter.FreeFormattedReal(ObsTime.Head),
      HeadObsWriter.FreeFormattedReal(ObsTime.Statistic),
      ObsTime.StatFlag, ' ', ObsTime.PlotSymbol);
  end;

  if ObsTime.Statistic <= 0 then
  begin
    StatErrors.Add('Observation Name = '+ ObsTime.Name + '; Statistic <= 0');
  end;


  if LAYER < 0 then
  begin
    LayerList.WriteLayers(HeadObsWriter);
  end;
  if IREFSP < 0 then
  begin
    WriteLn(HeadObsWriter.FFile, ITT);
    MultiTimeList.WriteMultiTimes(HeadObsWriter, TimeErrors);
  end;
end;

{ TMultiObservationTimeObject }


procedure TMultiObservationTimeObject.WriteMultiTime(
  HeadObsWriter: THeadObsWriter);
var
  AName: string;
  Position : integer;
begin
  AName := Trim(ObsTime.Name);
  Position := Pos(' ', AName);
  while (Position > 0) do
  begin
    AName[Position] := '_';
    Position := Pos(' ', AName);
  end;
  AddObservationName(AName);
  AName := '''' + AName + ''' ';

  if frmMODFLOW.rbModflow2005.Checked then
  begin
    WriteLn(HeadObsWriter.FFile, AName,  ObsTime.ReferenceStressPeriod, ' ',
      HeadObsWriter.FreeFormattedReal(ObsTime.Time),
      HeadObsWriter.FreeFormattedReal(ObsTime.Head));
  end
  else
  begin
    WriteLn(HeadObsWriter.FFile, AName,  ObsTime.ReferenceStressPeriod, ' ',
      HeadObsWriter.FreeFormattedReal(ObsTime.Time),
      HeadObsWriter.FreeFormattedReal(ObsTime.Head),
      HeadObsWriter.FreeFormattedReal(ObsTime.STATh),
      HeadObsWriter.FreeFormattedReal(ObsTime.STATdd),
      ObsTime.StatFlag, ' ', ObsTime.PlotSymbol);
  end;
end;

{ TMultiLayerObject }

procedure TMultiLayerObject.WriteLayer(HeadObsWriter: THeadObsWriter);
begin
  Writeln(HeadObsWriter.FFile, Layer.Layer, ' ',
    HeadObsWriter.FreeFormattedReal(Layer.Weight));
end;

{ TLayerList }

function TLayerList.Add(ALayer: TMultLayer): Integer;
var
  LayerObject : TMultiLayerObject;
begin
  LayerObject := TMultiLayerObject.Create;
  LayerObject.Layer := ALayer;
  result := inherited Add(LayerObject);
end;

procedure TLayerList.SetProportions;
var
  LayerObject : TMultiLayerObject;
  Sum : double;
  Index : integer;
begin
  Sum := 0;
  for Index := 0 to Count -1 do
  begin
    LayerObject := Items[Index] as TMultiLayerObject;
    Sum := Sum + LayerObject.Layer.Weight;
  end;
  for Index := 0 to Count -1 do
  begin
    LayerObject := Items[Index] as TMultiLayerObject;
    If Sum = 0 then
    begin
      LayerObject.Layer.Weight := 1/Count;
    end
    else
    begin
      LayerObject.Layer.Weight := LayerObject.Layer.Weight/Sum;
    end;
  end;
  for Index := Count -1 downto 0 do
  begin
    LayerObject := Items[Index] as TMultiLayerObject;
    if LayerObject.Layer.Weight = 0 then
    begin
      Delete(Index);
    end;
  end;
end;

procedure TLayerList.WriteLayers(HeadObsWriter: THeadObsWriter);
var
  Index : integer;
  LayerObject : TMultiLayerObject;
begin
  for Index := 0 to Count -1 do
  begin
    LayerObject := Items[Index] as TMultiLayerObject;
    LayerObject.WriteLayer(HeadObsWriter);
  end;

end;

{ TMultiObservationTimeList }

function TMultiObservationTimeList.Add(ATime: TMultObsTime): Integer;
var
  Time : TMultiObservationTimeObject;
begin
  Time := TMultiObservationTimeObject.Create;
  Time.ObsTime := ATime;
  result := inherited Add(Time);
end;

procedure TMultiObservationTimeList.WriteMultiTimes(
  const HeadObsWriter: THeadObsWriter;
  const Errors: TStringList);
var
  Index : integer;
  MultiTimeObject : TMultiObservationTimeObject;
begin
  for Index := 0 to Count -1 do
  begin
    MultiTimeObject := Items[Index] as TMultiObservationTimeObject;
    MultiTimeObject.WriteMultiTime(HeadObsWriter);
    if Index = 0 then
    begin
      if MultiTimeObject.ObsTime.STATh <= 0 then
      begin
        Errors.Add('Observation Name = '+ MultiTimeObject.ObsTime.Name + '; STATh <= 0');
      end;
    end
    else
    begin
      if MultiTimeObject.ObsTime.STATdd <= 0 then
      begin
        Errors.Add('Observation Name = '+ MultiTimeObject.ObsTime.Name + '; STATdd <= 0');
      end;
    end;
  end;
end;

{ TObservationList }

function TObservationList.Add(
  ObsTime: THeadObsTime): TObservationTimeObject;
begin
  result := TObservationTimeObject.Create;
  result.ObsTime := ObsTime;
  inherited Add(result);
end;

procedure TObservationList.WriteObservations(HeadObsWriter: THeadObsWriter;
  const TimeErrors, StatErrors: TStringList);
var
  Index : Integer;
  Observation : TObservationTimeObject;
begin
  for Index := 0 to Count -1 do
  begin
    Observation := Items[Index] as TObservationTimeObject;
    Observation.WriteTime(HeadObsWriter, TimeErrors, StatErrors);
  end;
end;

{ THeadObsWriter }

procedure THeadObsWriter.AddNormalLayer(LayerIndex: integer);
begin
  AddVertexLayer(ModelHandle, NormalLayerName(LayerIndex));
end;

procedure THeadObsWriter.AddWeightedLayer(LayerIndex: integer);
begin
  AddVertexLayer(ModelHandle, WeightLayerName(LayerIndex));
end;

procedure THeadObsWriter.EvaluteNormalLayers
  (Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter;
  BasicWriter: TBasicPkgWriter);
var
  LayerIndex : integer;
  LayerName : String;
  Layer : TLayerOptions;
begin
  for LayerIndex := 1 to NormalLayerCount do
  begin
    if frmModflow.clbObservationLayers.State[LayerIndex-1] = cbChecked then
    begin
      AddNormalLayer(LayerIndex);
      LayerName := NormalLayerName(LayerIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
      try
        GetContourProperties(Layer, Discretization, FlowWriter, BasicWriter, False);
      finally
        Layer.Free(ModelHandle);
      end;
    end;

  end;
end;

procedure THeadObsWriter.EvaluteWeightedLayers
  (Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter;
  BasicWriter: TBasicPkgWriter);
var
  LayerIndex : integer;
  LayerName : String;
  Layer : TLayerOptions;
begin
  for LayerIndex := 1 to WeightedLayerCount do
  begin
    if frmModflow.clbWeightedObservationLayers.State[LayerIndex-1] = cbChecked then
    begin
      AddWeightedLayer(LayerIndex);
      LayerName := WeightLayerName(LayerIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
      try
        GetContourProperties(Layer, Discretization, FlowWriter, BasicWriter, True);
      finally
        Layer.Free(ModelHandle);
      end;
    end;
  end;
end;

procedure THeadObsWriter.GetContourProperties(Layer : TLayerOptions;
  Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter;
  BasicWriter: TBasicPkgWriter; Weighted : boolean);
var
  ContourIndex : integer;
  ParamIndicies : TParamIndicies;
  TimeIndex : integer;
  TimeIndicies : TimeParameterList;
  WeightIndicies : TIntegerList;
begin
  ParamIndicies := GetParamIndicies(Layer);
  if Weighted then
  begin
    WeightIndicies := GetWeightIndicies(Layer);
  end
  else
  begin
    WeightIndicies := nil;
  end;
  try
    TimeIndicies := TimeParameterList.Create;
    try
      for TimeIndex := 1 To TimeCount do
      begin
        TimeIndicies.Add(GetTimeParamIndicies(Layer, TimeIndex));
      end;
      for ContourIndex := 0 to Layer.NumObjects(ModelHandle, pieContourObject) -1 do
      begin
        GetAContourProperties(Layer.LayerHandle,ContourIndex,ParamIndicies,
          TimeIndicies, Discretization, FlowWriter, BasicWriter, Weighted, WeightIndicies);
      end;
    finally
      TimeIndicies.Free;
    end;
  finally
    WeightIndicies.Free;
  end;
end;

procedure THeadObsWriter.GetAContourProperties(LayerHandle : ANE_PTR;
  ContourIndex : ANE_INT32; ParamIndicies : TParamIndicies;
  TimeIndicies : TimeParameterList; Discretization : TDiscretizationWriter;
  FlowWriter : TFlowWriter; BasicWriter: TBasicPkgWriter; Weighted : boolean;
  WeightIndicies : TIntegerList);
var
  Contour : TContourObjectOptions;
  TopLayer, BottomLayer : integer;
  Observation : THeadObsTime;
  BlockIndex : integer;
  X, Y : double;
  Below, Above : double;
  TimeParamIndicies : TTimeParamIndicies;
  TimeIndex : integer;
  MultObsTime : TMultObsTime;
  ObservationObject : TObservationTimeObject;
  LayerIndex : integer;
  MultLayer : TMultLayer;
  TopElev, BottomElev : double;
  Top, Bottom, LayerTop, LayerBottom, UnitWeight : double;
  UnitIndex : integer;
  UnitTop, UnitBottom : double;
  DisIndex, DisCount : integer;
  ITT : integer;
  UseTime : boolean;
begin
  Contour := TContourObjectOptions.Create(ModelHandle, LayerHandle, ContourIndex);
  try
    if Contour.ContourType(ModelHandle) <> ctPoint then
    begin
      Inc(PointErrors);
    end
    else
    begin
      TopLayer := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.TopLayerIndex);
      BottomLayer := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.BottomLayerIndex);
      TopElev := 0;
      BottomElev := 0;
      if TopLayer <> BottomLayer then
      begin
        TopElev := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.TopElevIndex);
        BottomElev := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.BotElevIndex);
      end;
      Observation.Layer := TopLayer;
      Observation.StatFlag := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.StatFlagIndex);
      Observation.PlotSymbol := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.PlotSymbolIndex);
//      Observation.ReferenceStressPeriod := Contour.GetIntegerParameter(ModelHandle,
//        ParamIndicies.ReferenceStressPeriodIndex);
      if TimeCount > 1 then
      begin
        ITT := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.ITTIndex);
      end;
      for BlockIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
      begin
        if BlockIndex > 0 then
        begin
          Continue;
        end;

        Observation.Row := GGetCellRow(ContourIndex,BlockIndex);
        Observation.Column := GGetCellColumn(ContourIndex,BlockIndex);
        if GGetCellVertexCount(ContourIndex,BlockIndex) > 0 then
        begin
          X := GGetCellVertexXPos(ContourIndex, BlockIndex, 0);
          Y := GGetCellVertexYPos(ContourIndex, BlockIndex, 0);

          Below := GGetColumnBoundaryPosition(Observation.Column-1);
          Above := GGetColumnBoundaryPosition(Observation.Column);
          Observation.ColOffset := (X - (Below + Above)/2)/(Above - Below);

          Below := GGetRowBoundaryPosition(Observation.Row-1);
          Above := GGetRowBoundaryPosition(Observation.Row);

          Observation.RowOffset := (Y - (Below + Above)/2)/(Above - Below);
          ObservationObject := nil;
          for TimeIndex := 1 to TimeCount do
          begin
            TimeParamIndicies := TimeIndicies.Items[TimeIndex -1];

            if UsePredictions then
            begin
              UseTime := Contour.GetBoolParameter (ModelHandle,
                TimeParamIndicies.IsPredictionIndex);
            end
            else
            begin
              UseTime := Contour.GetBoolParameter (ModelHandle,
                TimeParamIndicies.IsObservationIndex);
            end;

            {if (TimeIndex = 1) and not UseTime then
            begin
              break;
            end;}

            if UseTime then
            begin
              MultObsTime.Time := Contour.GetFloatParameter (ModelHandle,
                TimeParamIndicies.TimeIndex);
              MultObsTime.ReferenceStressPeriod := Contour.
                GetIntegerParameter(ModelHandle,
                TimeParamIndicies.RefStressPeriodIndex);
              if (TimeIndex = 1) or (MultObsTime.Time <> 0)
                or (MultObsTime.ReferenceStressPeriod <> 1) then
              begin
                MultObsTime.Name := Contour.GetStringParameter(ModelHandle,
                  TimeParamIndicies.NameIndex);
                MultObsTime.Head := Contour.GetFloatParameter(ModelHandle,
                  TimeParamIndicies.HeadIndex);
                MultObsTime.STATh := Contour.GetFloatParameter(ModelHandle,
                  TimeParamIndicies.STAThIndex);
                MultObsTime.STATdd := Contour.GetFloatParameter(ModelHandle,
                  TimeParamIndicies.STATddIndex);
                MultObsTime.StatFlag := Observation.StatFlag;
                MultObsTime.PlotSymbol := Observation.PlotSymbol;
                if (TimeIndex = 1) or (ObservationObject = nil) then
                begin
                  Observation.Name := MultObsTime.Name;
                  Observation.Time := MultObsTime.Time;
                  Observation.Head := MultObsTime.Head;
                  Observation.Statistic := MultObsTime.STATh;
                  ObservationObject := ObservationList.Add(Observation);
                  ObservationObject.ITT := ITT;
                end;
                ObservationObject.MultiTimeList.Add(MultObsTime);
              end;
            end;
          end;
          if (ObservationObject <> nil) and (TopLayer <> BottomLayer) then
          begin
            for LayerIndex := TopLayer to BottomLayer do
            begin
              MultLayer.Layer := LayerIndex;
              UnitIndex := frmModflow.GetUnitIndex(LayerIndex);
              DisCount := frmModflow.DiscretizationCount(UnitIndex);
              UnitTop := Discretization.Elevations[Observation.Column-1,
                Observation.Row-1, UnitIndex-1];
              UnitBottom := Discretization.Elevations[Observation.Column-1,
                Observation.Row-1, UnitIndex];
              if DisCount > 1 then
              begin
                DisIndex := frmModflow.GetDiscretizationIndex(UnitIndex, LayerIndex);
                LayerTop := UnitTop - (UnitTop - UnitBottom) * (DisIndex-1)/DisCount;
                LayerBottom := UnitTop - (UnitTop - UnitBottom) * DisIndex/DisCount;
              end
              else
              begin
                LayerTop := UnitTop;
                LayerBottom := UnitBottom;
              end;
              Top := Min(TopElev,LayerTop);
              Bottom := Max(BottomElev,LayerBottom);
              if Weighted then
              begin
                UnitWeight := Contour.GetFloatParameter(ModelHandle,
                  WeightIndicies.Items[UnitIndex-1]);
              end
              else
              begin
                UnitWeight := FlowWriter.Trans(Observation.Column-1,
                  Observation.Row-1, UnitIndex, Discretization);
              end;
              if (LayerTop = LayerBottom) or (Top < Bottom) then
              begin
                MultLayer.Weight := 0;
              end
              else
              begin
                MultLayer.Weight := (Top-Bottom)/(LayerTop-LayerBottom)*UnitWeight;
              end;
              ObservationObject.LayerList.Add(MultLayer);
            end;
            ObservationObject.LayerList.SetProportions;
            ObservationObject.SetLayerOrder(BasicWriter, Discretization);
          end;
        end;
      end;
    end;
  finally
    Contour.Free;
  end;
end;

function THeadObsWriter.GetParamIndicies(Layer : TLayerOptions): TParamIndicies;
begin
  result.TopElevIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFTopObsElevParamType.WriteParamName);
  result.BotElevIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFBottomObsElevParamType.WriteParamName);
  result.TopLayerIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFTopLayerParamType.WriteParamName);
  result.BottomLayerIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFBottomLayerParamType.WriteParamName);
  result.StatFlagIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFStatFlagParamType.WriteParamName);
  result.PlotSymbolIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFPlotSymbolParamType.WriteParamName);
  result.ITTIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFIttParamType.WriteParamName);
//  result.ReferenceStressPeriodIndex := Layer.GetParameterIndex(ModelHandle,
//    ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName);
end;

function THeadObsWriter.GetWeightIndicies(Layer : TLayerOptions): TIntegerList;
var
  UnitIndex : integer;
begin
  result := TIntegerList.Create;
  for UnitIndex := 1 to frmModflow.UnitCount do
  begin
    result.Add(Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMFWeightParamType.WriteParamName + IntToStr(UnitIndex)));
  end;
end;


function THeadObsWriter.GetTimeParamIndicies(
  Layer: TLayerOptions; TimeIndex : integer): TTimeParamIndicies;
var
  TimeString : string;
begin
  TimeString := IntToStr(TimeIndex);
  result.NameIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFObservationNameParamType.WriteParamName + TimeString);
  result.HeadIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFObservedHeadParamType.WriteParamName + TimeString);
  result.TimeIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFTimeParamType.WriteParamName + TimeString);
  result.STAThIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFStathParamType.WriteParamName + TimeString);
  result.STATddIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFStatddParamType.WriteParamName + TimeString);
  result.IsObservationIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFIsObservationParamType.WriteParamName + TimeString);
  result.IsPredictionIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFIsPredictionParamType.WriteParamName + TimeString);
  result.RefStressPeriodIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName + TimeString);
end;


function THeadObsWriter.NormalLayerCount: integer;
begin
  result := StrToInt(frmModflow.adeHeadObsLayerCount.Text);
end;

function THeadObsWriter.NormalLayerName(LayerIndex: integer): string;
begin
  result := ModflowTypes.GetMFHeadObservationsLayerType.WriteNewRoot +
    IntToStr(LayerIndex);
end;

function THeadObsWriter.TimeCount: integer;
begin
  result := StrToInt(frmModflow.adeObsHeadCount.Text);
end;

function THeadObsWriter.WeightedLayerCount: integer;
begin
  result := StrToInt(frmModflow.adeWeightedHeadObsLayerCount.Text);
end;

function THeadObsWriter.WeightLayerName(LayerIndex: integer): string;
begin
  result := ModflowTypes.GetMFWeightedHeadObservationsLayerType.WriteNewRoot +
    IntToStr(LayerIndex);
end;

procedure THeadObsWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter; FlowWriter : TFlowWriter;
  BasicWriter: TBasicPkgWriter);
var
  FileName : string;
  ErrorMessage : string;
begin
  PointErrors := 0;
  ModelHandle := CurrentModelHandle;
  ObservationList := TObservationList.Create;
  try
    UsePredictions := frmModflow.UsePredictions;
    EvaluteNormalLayers(Discretization, FlowWriter, BasicWriter);
    EvaluteWeightedLayers(Discretization, FlowWriter, BasicWriter);
    if ContinueExport then
    begin
      frmProgress.lblPackage.Caption := 'Head Observations';

      FileName := GetCurrentDir + '\' + Root + rsHob;
      AssignFile(FFile,FileName);
      try
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        WriteDataSet1;
        WriteDataSet2;
        WriteDataSet3to6;
        Flush(FFile);
      finally
        CloseFile(FFile);
      end;
    end;
  finally
    ObservationList.Free;
  end;
  if PointErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
      + ' contours in the HOB (Head Observation) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure THeadObsWriter.WriteDataSet2;
const
  TOMULT = 1.0;
var
  EVH : double;
begin
  EVH := InternationalStrToFloat(frmMODFLOW.adeHeadObsErrMult.Text);
  if frmMODFLOW.rbModflow2005.Checked then
  begin
    WriteLn(FFile, FreeFormattedReal(TOMULT));
  end
  else
  begin
    WriteLn(FFile, FreeFormattedReal(TOMULT), FreeFormattedReal(EVH));
  end;
end;

procedure THeadObsWriter.WriteDataSet1;
var
  ObsIndex : integer;
  Observation : TObservationTimeObject;
  NH, MOBS, MAXM : integer;
  IUHOBSV: Integer;
begin
  NH := 0;
  MOBS := 0;
  MAXM := 0;
  for ObsIndex := 0 to ObservationList.Count -1 do
  begin
    Observation := ObservationList.Items[ObsIndex] as TObservationTimeObject;
    NH := NH + Observation.MultiTimeList.Count;
    if Observation.LayerList.Count > 1 then
    begin
      MOBS := MOBS + Observation.MultiTimeList.Count;
      if Observation.LayerList.Count > MAXM then
      begin
        MAXM := Observation.LayerList.Count;
      end;
    end;
  end;
  if frmMODFLOW.rbModflow2005.Checked then
  begin
    IUHOBSV := frmModflow.GetUnitNumber('HOB_OUT');
    WriteLn(FFile, NH, ' ', MOBS, ' ', MAXM, ' ', IUHOBSV, ' -1e20')
  end
  else
  begin
    WriteLn(FFile, NH, ' ', MOBS, ' ', MAXM)
  end;
end;

procedure THeadObsWriter.WriteDataSet3to6;
var
  ObsIndex : integer;
  Observation : TObservationTimeObject;
  ErrorMessage : string;
  TimeErrors, StatErrors: TStringList;
begin
  if ObservationList.Count = 0 then
  begin
    ErrorMessage := 'Error: no observations were specified for use with the '
      + 'Head Observation package.  You should either turn off the Head Observation '
      + 'package or specify some observations to use with it.';
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end;

  TimeErrors := TStringList.Create;
  StatErrors := TStringList.Create;
  try
    for ObsIndex := 0 to ObservationList.Count -1 do
    begin
      Observation := ObservationList.Items[ObsIndex] as TObservationTimeObject;
      Observation.WriteTime(self, TimeErrors, StatErrors);
    end;

    if StatErrors.Count > 0 then
    begin
      ErrorMessage := 'Statistic < 0 for one or more head observations.';
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.AddStrings(StatErrors);
    end;
    if TimeErrors.Count > 0 then
    begin
      ErrorMessage := 'Stath or Statdd < 0 for one or more head observations.';
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.AddStrings(StatErrors);
    end;

  finally
    TimeErrors.Free;
    StatErrors.Free;
  end;
end;

{ TimeParameterList }

function TimeParameterList.Add(Indicies: TTimeParamIndicies): integer;
var
  IndiciesObject : TTimeParameterObject;
begin
  IndiciesObject := TTimeParameterObject.Create;
  IndiciesObject.Indicies := Indicies;
  result := inherited Add(IndiciesObject);
end;

function TimeParameterList.GetItem(Index: Integer): TTimeParamIndicies;
var
  IndiciesObject : TTimeParameterObject;
begin
  IndiciesObject := inherited Items[Index] as TTimeParameterObject;
  result := IndiciesObject.Indicies;
end;

procedure TimeParameterList.SetItem(Index: Integer;
  Indicies: TTimeParamIndicies);
var
  IndiciesObject : TTimeParameterObject;
begin
  IndiciesObject := inherited Items[Index] as TTimeParameterObject;
  IndiciesObject.Indicies := Indicies;
end;

end.
