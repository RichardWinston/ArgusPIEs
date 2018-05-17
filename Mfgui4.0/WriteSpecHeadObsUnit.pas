unit WriteSpecHeadObsUnit;

interface

uses Sysutils, contnrs, Math, ANEPIE, OptionsUnit, WriteModflowDiscretization,
  WriteBCF_Unit;

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
  end;

  TMultObsTime = record
    Name : string[12];
    Time : double;
    Head : double;
    STATh : double;
    STATdd : double;
    StatFlag : integer;
    PlotSymbol : integer;
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
  end;

  TTimeParamIndicies = record
    NameIndex : ANE_INT16;
    HeadIndex : ANE_INT16;
    TimeIndex : ANE_INT16;
    STAThIndex : ANE_INT16;
    STATddIndex : ANE_INT16;
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
      FlowWriter : TFlowWriter );
    procedure EvaluteNormalLayers(Discretization : TDiscretizationWriter;
      FlowWriter : TFlowWriter);
    procedure GetContourProperties(Layer: TLayerOptions;
      Discretization: TDiscretizationWriter; FlowWriter: TFlowWriter);
    procedure WriteDataSet1;
    Procedure WriteDataSet2;
    procedure WriteDataSet3to6(Discretization: TDiscretizationWriter);
  public
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter);
  end;

  TMultiObservationTimeObject = class(TObject)
    ObsTime : TMultObsTime;
    private
    procedure GetStressAndOffset(var IREFSP : integer; var TOFFSET : double;
      Discretization : TDiscretizationWriter);
    procedure WriteMultiTime(Discretization : TDiscretizationWriter;
      HeadObsWriter : THeadObsWriter);
  end;

  TMultiObservationTimeList = class(TObjectList)
    function Add(ATime : TMultObsTime): Integer;
    procedure WriteMultiTimes(Discretization : TDiscretizationWriter;
      HeadObsWriter : THeadObsWriter);
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
    procedure GetStressAndOffset(var IREFSP : integer; var TOFFSET : double;
      Discretization : TDiscretizationWriter);
    procedure WriteTime({LayerCount, TimeCount : integer;}
      Discretization : TDiscretizationWriter;
      HeadObsWriter : THeadObsWriter);
  public
    Constructor Create;
    Destructor Destroy; override;
  end;

  TObservationList = class(TObjectList)
    function Add(ObsTime : THeadObsTime): TObservationTimeObject;
    procedure WriteObservations(Discretization : TDiscretizationWriter;
      HeadObsWriter : THeadObsWriter);
  end;


implementation

uses Variables, UtilityFunctions, GetCellUnit, GetCellVertexUnit, GridUnit,
  ProgressUnit;

{ TObservationTimeObject }

constructor TObservationTimeObject.Create;
begin
  inherited;
  LayerList := TLayerList.Create;
  MultiTimeList := TMultiObservationTimeList.Create;
end;

destructor TObservationTimeObject.Destroy;
begin
  inherited;
  LayerList.Free;
  MultiTimeList.Free;
end;

procedure TObservationTimeObject.GetStressAndOffset(var IREFSP: integer;
  var TOFFSET: double; Discretization: TDiscretizationWriter);
begin
  Discretization.GetPeriodAndOffset(ObsTime.Time,  IREFSP, TOFFSET);
end;

procedure TObservationTimeObject.WriteTime({LayerCount, TimeCount: integer;}
  Discretization: TDiscretizationWriter; HeadObsWriter: THeadObsWriter);
var
  IREFSP : integer;
  TOFFSET : double;
  LAYER : integer;
begin

  If LayerList.Count > 1 then
  begin
    LAYER := - LayerList.Count;
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
    GetStressAndOffset(IREFSP, TOFFSET, Discretization)
  end;

  WriteLn(HeadObsWriter.FFile, ObsTime.Name, ' ', LAYER, ' ', ObsTime.Row,
    ' ', ObsTime.Column, ' ', IREFSP, Format(' %.13e %.13e %.13e %.13e %.13e ',
    [TOFFSET, ObsTime.RowOffset, ObsTime.ColOffset, ObsTime.Head,
    ObsTime.Statistic]), ObsTime.StatFlag, ' ', ObsTime.PlotSymbol);

  if LAYER < 0 then
  begin
    LayerList.WriteLayers(HeadObsWriter);
  end;
  if IREFSP < 0 then
  begin
    WriteLn(HeadObsWriter.FFile, ITT);
    MultiTimeList.WriteMultiTimes(Discretization, HeadObsWriter);
  end;
end;

{ TMultiObservationTimeObject }

procedure TMultiObservationTimeObject.GetStressAndOffset(
  var IREFSP: integer; var TOFFSET: double;
  Discretization: TDiscretizationWriter);
begin
  Discretization.GetPeriodAndOffset(ObsTime.Time,  IREFSP, TOFFSET);
end;

procedure TMultiObservationTimeObject.WriteMultiTime(
  Discretization: TDiscretizationWriter; HeadObsWriter: THeadObsWriter);
var
  IREFSP : integer;
  TOFFSET : double;
begin
  GetStressAndOffset(IREFSP, TOFFSET, Discretization);

  WriteLn(HeadObsWriter.FFile, ObsTime.Name, ' ',  IREFSP,
    Format(' %.13e %.13e %.13e %.13e ',
    [TOFFSET, ObsTime.Head, ObsTime.STATh, ObsTime.STATdd]),
    ObsTime.StatFlag, ' ', ObsTime.PlotSymbol);
end;

{ TMultiLayerObject }

procedure TMultiLayerObject.WriteLayer(HeadObsWriter: THeadObsWriter);
begin
  Writeln(HeadObsWriter.FFile, Layer.Layer, Format(' %.13e ', [Layer.Weight]));
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
    LayerObject.Layer.Weight := LayerObject.Layer.Weight/Sum;
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
  Discretization: TDiscretizationWriter; HeadObsWriter: THeadObsWriter);
var
  Index : integer;
  MultiTimeObject : TMultiObservationTimeObject;
begin
  for Index := 0 to Count -1 do
  begin
    MultiTimeObject := Items[Index] as TMultiObservationTimeObject;
    MultiTimeObject.WriteMultiTime(Discretization, HeadObsWriter);
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

procedure TObservationList.WriteObservations(
  Discretization: TDiscretizationWriter; HeadObsWriter: THeadObsWriter);
var
  Index : Integer;
  Observation : TObservationTimeObject;
begin
  for Index := 0 to Count -1 do
  begin
    Observation := Items[Index] as TObservationTimeObject;
    Observation.WriteTime(Discretization,HeadObsWriter);
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
  (Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter);
var
  LayerIndex : integer;
  LayerName : String;
  Layer : TLayerOptions;
begin
  for LayerIndex := 1 to NormalLayerCount do
  begin
    AddNormalLayer(LayerIndex);
    LayerName := NormalLayerName(LayerIndex);
    Layer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
    GetContourProperties(Layer, Discretization, FlowWriter);
  end;
end;

procedure THeadObsWriter.GetContourProperties(Layer : TLayerOptions;
  Discretization : TDiscretizationWriter; FlowWriter : TFlowWriter);
var
  ContourIndex : integer;
  ParamIndicies : TParamIndicies;
  TimeIndex : integer;
  TimeIndicies : TimeParameterList;
begin
  ParamIndicies := GetParamIndicies(Layer);
  TimeIndicies := TimeParameterList.Create;
  try
    for TimeIndex := 1 To TimeCount do
    begin
      TimeIndicies.Add(GetTimeParamIndicies(Layer, TimeIndex));
    end;
    for ContourIndex := 0 to Layer.NumObjects(ModelHandle, pieContourObject) do
    begin
      GetAContourProperties(Layer.LayerHandle,ContourIndex,ParamIndicies,
        TimeIndicies, Discretization, FlowWriter);
    end;
  finally
    TimeIndicies.Free;
  end;
end;

procedure THeadObsWriter.GetAContourProperties(LayerHandle : ANE_PTR;
  ContourIndex : ANE_INT32; ParamIndicies : TParamIndicies;
  TimeIndicies : TimeParameterList; Discretization : TDiscretizationWriter;
  FlowWriter : TFlowWriter );
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
  Top, Bottom, LayerTop, LayerBottom, Transmissivity : double;
  UnitIndex : integer;
  UnitTop, UnitBottom : double;
  DisIndex, DisCount : integer;
  ITT : integer;
begin
  Contour := TContourObjectOptions.Create(ModelHandle, LayerHandle, ContourIndex);
  try
    if Contour.ContourType(ModelHandle) = ctPoint then
    begin
      TopLayer := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.TopLayerIndex);
      BottomLayer := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.BottomLayerIndex);
      if TopLayer <> BottomLayer then
      begin
        TopElev := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.TopElevIndex);
        BottomElev := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.BotElevIndex);
      end;
      Observation.Layer := TopLayer;
      Observation.StatFlag := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.StatFlagIndex);
      Observation.PlotSymbol := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.PlotSymbolIndex);
      if TimeCount > 1 then
      begin
        ITT := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.ITTIndex);
      end;
      for BlockIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
      begin
        Observation.Row := GGetCellRow(ContourIndex,BlockIndex);
        Observation.Column := GGetCellColumn(ContourIndex,BlockIndex);
        if GGetCellVertexCount(ContourIndex,BlockIndex) > 0 then
        begin
          X := GGetCellVertexXPos(ContourIndex, BlockIndex, 0);
          Y := GGetCellVertexYPos(ContourIndex, BlockIndex, 0);

          Below := GGetColumnBoundaryPosition(Observation.Column -1);
          Above := GGetColumnBoundaryPosition(Observation.Column);
          Observation.ColOffset := (X - (Below + Above)/2)/(Above - Below);

          Below := GGetRowBoundaryPosition(Observation.Row -1);
          Above := GGetRowBoundaryPosition(Observation.Row);
          Observation.RowOffset := (X - (Below + Above)/2)/(Above - Below);
          ObservationObject := nil;
          for TimeIndex := 1 to TimeCount do
          begin
            TimeParamIndicies := TimeIndicies.Items[TimeIndex -1];

            MultObsTime.Time := Contour.GetFloatParameter (ModelHandle,
              TimeParamIndicies.TimeIndex);
            if (TimeIndex = 1) or (MultObsTime.Time <> 0) then
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
              if TimeIndex = 1 then
              begin
                Observation.Time := MultObsTime.Time;
                Observation.Head := MultObsTime.Head;
                Observation.Statistic := MultObsTime.STATh;
                ObservationObject := ObservationList.Add(Observation);
                ObservationObject.ITT := ITT;
              end;
              ObservationObject.MultiTimeList.Add(MultObsTime);
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
              Transmissivity := FlowWriter.Trans(Observation.Column-1,
                Observation.Row-1, UnitIndex-1, Discretization);
              MultLayer.Weight := (Top-Bottom)/(LayerTop-LayerBottom)*Transmissivity;
              ObservationObject.LayerList.Add(MultLayer);
            end;
            ObservationObject.LayerList.SetProportions;
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
  Root: string; Discretization: TDiscretizationWriter; FlowWriter : TFlowWriter);
var
  FileName : string;
begin
  ModelHandle := CurrentModelHandle;
  ObservationList := TObservationList.Create;
  try
    EvaluteNormalLayers(Discretization, FlowWriter);
    if ContinueExport then
    begin
      frmProgress.lblPackage.Caption := 'Head Observations';

      FileName := GetCurrentDir + '\' + Root + '.hob';
      AssignFile(FFile,FileName);
      try
        Rewrite(FFile);
        WriteDataSet1;
        WriteDataSet2;
        WriteDataSet3to6(Discretization);
      finally
        CloseFile(FFile);
      end;
    end;
  finally
    ObservationList.Free;
  end;

end;

procedure THeadObsWriter.WriteDataSet2;
const
  TOMULT = 1.0;
var
  EVH : double;
begin
  EVH := StrToFloat(frmMODFLOW.adeHeadObsErrMult.Text);
  WriteLn(FFile, Format('%.13e %.13e', [TOMULT,EVH]));
end;

procedure THeadObsWriter.WriteDataSet1;
var
  ObsIndex : integer;
  Observation : TObservationTimeObject;
  NH, MOBS, MAXM : integer;
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
  WriteLn(FFile, NH, ' ', MOBS, ' ', MAXM)
end;

procedure THeadObsWriter.WriteDataSet3to6(
  Discretization: TDiscretizationWriter);
var
  ObsIndex : integer;
  Observation : TObservationTimeObject;
begin
  for ObsIndex := 0 to ObservationList.Count -1 do
  begin
    Observation := ObservationList.Items[ObsIndex] as TObservationTimeObject;
    Observation.WriteTime(Discretization, self);
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
