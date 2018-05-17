unit WriteStrUnit;
{
  Write the input for the STR package.
}

interface

uses Sysutils, classes, contnrs, Forms, Grids, AnePIE,
  WriteModflowDiscretization,
  OptionsUnit, IntListUnit, RealListUnit, WriteLakesUnit;

type
  TStrReachRecord = record
    Layer : integer;
    Row : integer;
    Column : integer;
    ChannelLength : double;
    HydraulicConductivity: double;
    StreamBedTop: array of double;
    StreamBedBottom: array of double;
    Stage: array of double;
    Width: array of double;
    Slope: array of double;
    Roughness: array of double;
  end;

  TStrParamIndicies = record
    ParameterNameIndex: ANE_INT32;
    IsParameterIndex: ANE_INT32;
    SegmentNumberIndex: ANE_INT32;
    DownstreamSegmentNumberIndex: ANE_INT32; 
    DiversionSegmentNumberIndex: ANE_INT32;
    HydraulicConductivityIndex: ANE_INT32;
    HydraulicConductivityName: string;
    StatFlagIndex: ANE_INT32;
    PlotSymbolIndex: ANE_INT32;
    HydmodStageIndex: ANE_INT32;
    HydmodFlowInIndex: ANE_INT32;
    HydmodFlowOutIndex: ANE_INT32;
    HydmodFlowIntoAquiferIndex: ANE_INT32;
    HydmodLabelIndex: ANE_INT32;
  end;

  TStrTimeParamIndicies = record
    OnOffParamIndex : ANE_INT32;
    StreamFlowParamIndex : ANE_INT32;
    StreamUpTopElevParamIndex : ANE_INT32;
    DownstreamTopElevationParamIndex : ANE_INT32;
    TopElevName: string;
    UpstreamBottomParamIndex : ANE_INT32;
    DownstreamBottomParamIndex : ANE_INT32;
    BottomElevName: string;
    UpsteamStageIndex : ANE_INT32;
    DownstreamStageIndex : ANE_INT32;
    StageName: string;
    UpstreamWidthIndex : ANE_INT32;
    WidthName: string;
    DownstreamWidthIndex : ANE_INT32;
    SlopeIndex : ANE_INT32;
    SlopeName: string;
    RoughnessIndex : ANE_INT32;
    RoughnessName: string;
    IFACEParamIndex : ANE_INT32;
    MT3D_ConcentrationIndicies : array of ANE_INT32;
  end;

  TStrObservationTimeParamIndicies = record
    ObservationNameParamIndex : ANE_INT32;
    TimeParamIndex : ANE_INT32;
    LossParamIndex : ANE_INT32;
    StatisticParamIndex : ANE_INT32;
    IsObservationParamIndex : ANE_INT32;
    IsPredictionParamIndex : ANE_INT32;
    ObservationNumberIndex : ANE_INT32;
    ReferenceStressPeriodIndex: ANE_INT32;
  end;

  EStreamError = class(Exception);

  TStrReachObject = class(TObject)
    private
    Reach : TStrReachRecord;
    procedure WriteMT3DConcentrations(const Lines: TStrings;
      const Concentration : string);
    function GetCol: integer;
    function GetLayer: integer;
    function GetRow: integer;
  public
    property Col: integer read GetCol;
    property Row: integer read GetRow;
    property Layer: integer read GetLayer;
  end;

  TStreamObservation = class(TObject)
    ObservationNumber : integer;
    Segments : TList;
    constructor Create;
    Destructor Destroy; override;
  end;

  TStrSegment = Class;
  TStrWriter = class;

  TStrReachList = Class(TObjectList)
  private
    Segment : TStrSegment;
    function GetItems(Index: Integer): TStrReachObject;
    procedure SetItems(Index: Integer; const Value: TStrReachObject);
    function Add(StreamReach: TStrReachRecord): TStrReachObject; overload;
    Procedure Write(StreamWriter: TStrWriter;
      Const TimeIndex : integer);
    Procedure WriteWidthSlopeRoughness(StreamWriter: TStrWriter;
      Const TimeIndex : integer);
    Constructor Create(const Segment : TStrSegment);
    function GetTotalLength : double;
    Procedure WriteObservation(const ReachList : TStringList);
    procedure WriteMT3DConcentrations(const Lines: TStrings;
      const Concentration : string);
  public
    property Items[Index: Integer]: TStrReachObject read GetItems
      write SetItems; default;
  end;

  TStrSegment = class(TObject)
  Private
    Active : array of boolean;
    IsPrediction : array of boolean;
    IsObservation : array of boolean;
    // Data Sets 4A and 6A
    Slope : TRealList;
    Flow : TRealList;
    ChannelRoughness : TRealList; // ROUGHCH
    // Data Sets 4B and 6B
    HydraulicConductivity : double; // Hc1fact, HCOND1
    UpstreamBedBottom : TRealList; // THICKM1
    UpstreamBedElevation : TRealList; // ELEVUP
    UpstreamWidth : TRealList; // WIDTH1
    UpstreamStage : TRealList; // DEPTH1
    // Data Sets 4C and 6C
    DownstreamBedBottom : TRealList; // THICKM2
    DownstreamBedElevation : TRealList; // ELEVdn
    DownstreamWidth : TRealList; // WIDTH2
    DownstreamStage : TRealList; // DEPTH2
    IFACE : TIntegerList;
    // Data Set 4F and 6F
    FNumber : integer; // NSEG
    FOutflowSegment : integer; // OUTSEG
    FDiversionSegment : integer; // IUPSEG
    Tributaries : TList;
    StreamWriter : TStrWriter;
    StatFlag : integer;
    PlotSymbol : integer;
    ObservationTimes : TRealList;
    ObservationLoss : TRealList;
    ObservationStatistic : TRealList;
    ObservationNames : TStringList;
    ObservationNumbers : TIntegerList;
    HydmodStageObservation : boolean;
    HydmodFlowInObservation : boolean;
    HydmodFlowOutObservation : boolean;
    HydmodFlowIntoAquiferObservation : boolean;
    HydmodLabel : string;
    MT3D_Concentrations : array of array of double;
    SpeciesCount : integer;
    ReferenceStressPeriod: TIntegerList;
    ReachList : TStrReachList;
    function Use(const ObsIndex : integer) : boolean;
    Function GetNumber : integer;
    function GetDiversionSegment : integer;
    function GetSegmentByNumber(const SegmentNumber : integer) : TStrSegment;
    function GetReach(Index: integer): TStrReachObject;
    property DiversionSegment : integer read GetDiversionSegment;
    function ValuesAreValid(var ErrorMessage : string;
      const TimeIndex : integer; const ICALC : integer;
      const AlternateExportTemplate: boolean) : boolean;
    procedure WriteSegment(const StreamWriter : TStrWriter;
      const TimeIndex : integer);
    function Width(TimeIndex : integer; const Factor : double) : double;
    procedure WriteHydmod(const HydmodWriter : TListWriter);
    procedure WriteMT3DConcentrations(
      const StressPeriod: integer; const Lines: TStrings);
  public
    // Data Set 4F and 6F
    property UserAssignedNumber: integer read FNumber;
    property Number : integer read GetNumber;
    Constructor Create;
    Destructor Destroy; override;
    function ReachCount: integer;
    property Reaches[Index: integer]: TStrReachObject read GetReach;
  end;

  TStrSegmentList = class(TObjectList)
  private
    Procedure Write(const StreamWriter: TStrWriter;
      const TimeIndex : integer; var ErrorsFound : boolean);
    procedure WriteMT3DConcentrations(
      const StressPeriod: integer; const Lines: TStrings);
  end;

  TStrParameterRecord = record
    Name: ShortString;
    Value : double;
  end;

  TStrParameterObject = class(TObject)
  private
    FName: ShortString;
    Value : double;
    SegmentList : TStrSegmentList;
    Active : array of boolean;
    InstanceNamesUsed: array of string;
    Instances : TStringList;
    procedure SetName(const Value: ShortString);
    property Name : ShortString read FName write SetName;
    Procedure Write(StreamWriter: TStrWriter; var ErrorsFound : boolean);
  public
    Constructor Create;
    Destructor Destroy; override;
  end;

  TStrParameterList = class(TObjectList)
  private
    function Add(Parameter : TStrParameterRecord) : TStrParameterObject;
    Procedure Write(StreamWriter: TStrWriter; var ErrorFound : boolean);
    function GetParameterByName(Name : string) : TStrParameterObject;
  end;

  TStrWriter = class(TListWriter)
  private
    ICALC : integer;
    NTRIB :integer;
    NDIV : integer;
    CurrentModelHandle : ANE_PTR;
    ParameterList : TStrParameterList;
    SegmentList : TStrSegmentList;
    DisWriter : TDiscretizationWriter;
    StreamObservations : TStringList;
    NQST, NQCST, NQTST : integer;
    ObservationIndicies : TIntegerList;
    ITMP : integer;
    LineErrors : integer;
    AlternateExportTemplate: boolean;
    ListOfSegments : TList;
    procedure AddParameters;
    procedure GetStreamParameterIndicies(const Layer: TLayerOptions;
      var  Indicies : TStrParamIndicies);
    procedure GetStreamTimeParameterIndicies(Const Layer: TLayerOptions;
      var Indicies : TStrTimeParamIndicies; const TimeIndex : integer);
    procedure GetStreamSegmentValues(const Indicies : TStrParamIndicies;
      const Segment : TStrSegment; const Contour : TContourObjectOptions);
    procedure GetStreamTimeParameterValues(
      const Indicies: TStrTimeParamIndicies;
      const Segment: TStrSegment;
      const Contour: TContourObjectOptions;
      const TimeIndex : integer);
    Procedure AddCells(const Segment : TStrSegment;
      const ContourIndex, UnitIndex : integer;
      const Layer: TLayerOptions; const Indicies : TStrParamIndicies;
      const TimeIndicies : array of TStrTimeParamIndicies);
    procedure EvaluateStreamLayer(const UnitIndex : integer);
    function ComputeStreamConstant : double;
    Procedure WriteDataSets1and2;
    Procedure WriteDataSets3and4(var ErrorsFound: boolean);
    Procedure WriteDataSets5To7(StressPeriod : integer;
      var ErrorsFound: boolean);
    procedure MakeListOfSegments;
    procedure EvaluateTributaries;
    procedure SetICALC;
    procedure WriteDataSet8(StressPeriod: integer);
    procedure WriteDataSet9(var ErrorFound : boolean;
      Const EvaluateErrors : boolean);
    procedure WriteDataSet10(var ErrorFound : boolean;
      Const EvaluateErrors : boolean);
    procedure GetStreamObservationTimeParameterIndicies(
      const Layer: TLayerOptions;
      var Indicies: TStrObservationTimeParamIndicies;
      const TimeIndex: integer);
    procedure GetStreamObservationTimeParameterValues(
      const Indicies: TStrObservationTimeParamIndicies;
      const Segment: TStrSegment;
      const Contour: TContourObjectOptions;
      const TimeIndex : integer);
    procedure EvaluateStreamObservations;
    Procedure WriteObservationsDataSets1to5(const ObsFile : TStringList;
      const FileName : string);
    Procedure WriteObservationsDataSets3to5(const ObsFile : TStringList);
    procedure WriteObservationsDataSet6(const ObsFile : TStringList);
    procedure WriteObservationsDataSet7(const ObsFile : TStringList);
    procedure WriteObservationsDataSets6and7(const ObsFile : TStringList);
    procedure EvaluateStreams(var ErrorFound : boolean);
    function GetSegment(Index: integer): TStrSegment;
  public
    procedure Evaluate(const DiscretizationWriter: TDiscretizationWriter);
    constructor Create;
    Destructor Destroy; override;
    procedure WriteFile(const Root : string;
      const DiscretizationWriter : TDiscretizationWriter);
    procedure WriteObservationFile(const Root: string);
    function HydmodCount: integer;
    procedure WriteHydmod(const HydmodWriter : TListWriter);
    procedure WriteMT3DConcentrations(
      const StressPeriod: integer; const Lines: TStrings);
    class procedure AssignUnitNumbers;
    function SegmentCount: integer;
    property Segments[Index: integer]: TStrSegment read GetSegment;
  end;

implementation

uses Math, ProgressUnit, GetCellUnit, BL_SegmentUnit, GetFractionUnit,
  ModflowLayerFunctions, Variables, WriteNameFileUnit, WriteGageUnit,
  WriteHydmodUnit, UtilityFunctions, FixNameUnit;


function SortSegments(Item1, Item2: Pointer): Integer;
Var
  Seg1, Seg2 : TStrSegment;
begin
  Seg1 := Item1;
  Seg2 := Item2;
  result := Seg1.FNumber - Seg2.FNumber;
end;


function SortParameters(Item1, Item2: Pointer): Integer;
Var
  Par1, Par2 : TStrParameterObject;
  Seg1, Seg2 : TStrSegment;
begin
  Par1 := Item1;
  Par2 := Item2;
  if (Par1.SegmentList.Count = 0) and (Par2.SegmentList.Count = 0) then
  begin
    result := 0;
  end
  else if Par1.SegmentList.Count = 0 then
  begin
    result := -1;
  end
  else if Par2.SegmentList.Count = 0 then
  begin
    result := 1;
  end
  else
  begin
    Seg1 := Par1.SegmentList[0] as TStrSegment;
    Seg2 := Par2.SegmentList[0] as TStrSegment;
    result := Seg1.FNumber - Seg2.FNumber;
  end;

end;

{ TStrSegment }

constructor TStrSegment.Create;
var
  TimeCount : integer;
  ObservationTimeCount : integer;
begin
  inherited;
  ReachList := TStrReachList.Create(self);
  Flow := TRealList.Create;
  ChannelRoughness := TRealList.Create;
  ReferenceStressPeriod := TIntegerList.Create;
  TimeCount := frmModflow.dgTime.RowCount -1;
  SetLength(Active,TimeCount);

  ObservationTimeCount := StrToInt(frmModflow.adeObsSTRTimeCount.Text);
  SetLength(IsPrediction,ObservationTimeCount);
  SetLength(IsObservation,ObservationTimeCount);

  UpstreamBedBottom := TRealList.Create;
  UpstreamBedElevation := TRealList.Create;
  UpstreamWidth := TRealList.Create;
  UpstreamStage := TRealList.Create;
  DownstreamBedBottom := TRealList.Create;
  DownstreamBedElevation := TRealList.Create;
  DownstreamWidth := TRealList.Create;
  DownstreamStage := TRealList.Create;
  Slope := TRealList.Create;
  IFACE := TIntegerList.Create;
  if frmModflow.cbMT3D.Checked then
  begin
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(MT3D_Concentrations,TimeCount,SpeciesCount);
  end;
  Tributaries := TList.Create;

  ObservationTimes := TRealList.Create;
  ObservationLoss := TRealList.Create;
  ObservationStatistic := TRealList.Create;
  ObservationNumbers := TIntegerList.Create;
  ObservationNames := TStringList.Create;
end;

destructor TStrSegment.Destroy;
begin
  Flow.Free;
  ReachList.Free;
  ChannelRoughness.Free;
  ReferenceStressPeriod.Free;
  UpstreamBedBottom.Free;
  UpstreamBedElevation.Free;
  UpstreamWidth.Free;
  UpstreamStage.Free;
  DownstreamBedBottom.Free;
  DownstreamBedElevation.Free;
  DownstreamWidth.Free;
  DownstreamStage.Free;
  Slope.Free;
  SetLength(MT3D_Concentrations, 0, 0);
  IFACE.Free;
  Tributaries.Free;
  ObservationTimes.Free;
  ObservationLoss.Free;
  ObservationStatistic.Free;
  ObservationNumbers.Free;
  ObservationNames.Free;
  inherited;
end;

function TStrSegment.GetDiversionSegment: integer;
var
  ASegment : TStrSegment;
begin
  if FDiversionSegment = 0 then
  begin
    result := 0;
  end
  else
  begin
    ASegment := GetSegmentByNumber(FDiversionSegment);
    Assert(ASegment <> nil);
    result := ASegment.Number;
  end;
end;

function TStrSegment.GetNumber: integer;
begin
  Assert((StreamWriter <> nil) and (StreamWriter.ListOfSegments <> nil));
  result := StreamWriter.ListOfSegments.IndexOf(self) + 1;
  Assert(result > 0)
end;

function TStrSegment.GetReach(Index: integer): TStrReachObject;
begin
  result := ReachList[Index];
end;

function TStrSegment.GetSegmentByNumber(const SegmentNumber : integer): TStrSegment;
var
  Index : integer;
  ASegment : TStrSegment;
begin
  Assert((StreamWriter <> nil) and  (StreamWriter.ListOfSegments <> nil));
  result := nil;
  for Index := 0 to StreamWriter.ListOfSegments.Count -1 do
  begin
    ASegment := StreamWriter.ListOfSegments[Index];
    if ASegment.FNumber = SegmentNumber then
    begin
      result := ASegment;
      Exit;
    end;
  end;
end;

function TStrSegment.ReachCount: integer;
begin
  result := ReachList.Count;
end;

function TStrSegment.Use(const ObsIndex : integer): boolean;
begin
  result := (ObsIndex = 0) or (ObservationTimes[ObsIndex] <> 0)
    or (ReferenceStressPeriod[ObsIndex] <> 1);
  if result and frmModflow.cbParamEst.Checked then
  begin
    if frmModflow.comboYcintInput.ItemIndex = 0 then
    begin
      result := IsObservation[ObsIndex];
    end
    else
    begin
      result := IsPrediction[ObsIndex];
    end;
  end;
end;

function TStrSegment.ValuesAreValid(var ErrorMessage: string;
  const TimeIndex : integer; const ICALC : integer;
  const AlternateExportTemplate: boolean): boolean;
var
  FirstError : boolean;
  Index: integer;
  ErrorFound: boolean;
  Reach: TStrReachObject;
  Procedure AddCommaIfNeeded;
  begin
    if not FirstError then
    begin
      ErrorMessage := ErrorMessage + ', ';
    end;
  end;
begin
  ErrorMessage := 'Errors in Segment ' + IntToStr(FNumber)
    + ' in Stress period ' + IntToStr(TimeIndex+1) +': ';
  FirstError := True;
  if DiversionSegment < 0 then
  begin
    if Flow[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Invalid upstream Flow from stream to Lake (IUPSEG < 0 and Flow < 0)';
      FirstError := False;
    end;
  end;
  if ICALC > 0 then
  begin
    ErrorFound := False;
    if AlternateExportTemplate then
    begin
      for Index := 0 to ReachList.Count -1 do
      begin
        Reach:= ReachList[Index];
        if Reach.Reach.Roughness[TimeIndex] <= 0 then
        begin
          ErrorFound := True;
          Break;
        end;
      end;

    end
    else
    begin
      if ChannelRoughness[TimeIndex] <= 0 then
      begin
        ErrorFound := True;
      end
    end;
    if ErrorFound then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Invalid negative channel roughness (ROUGHCH < 0)';
      FirstError := False;
    end;
  end;

  // test Hydraulic conductivity
  ErrorFound := False;
  if AlternateExportTemplate then
  begin
    for Index := 0 to ReachList.Count -1 do
    begin
      Reach:= ReachList[Index];
      if Reach.Reach.HydraulicConductivity <= 0 then
      begin
        ErrorFound := True;
        Break;
      end;
    end;
  end
  else
  begin
    if HydraulicConductivity <= 0 then
    begin
      ErrorFound := True;
    end
  end;
  if ErrorFound then
  begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Invalid negative hydraulic conductivity (Hc1fact or HCOND1 < 0)';
      FirstError := False;
  end;

  // test elevations of bed bottom and top
  ErrorFound := False;
  if AlternateExportTemplate then
  begin
    for Index := 0 to ReachList.Count -1 do
    begin
      Reach:= ReachList[Index];
      if Reach.Reach.StreamBedBottom[TimeIndex] >= Reach.Reach.StreamBedTop[TimeIndex] then
      begin
        ErrorFound := True;
        Break;
      end;
    end;
  end
  else
  begin
    if UpstreamBedBottom[TimeIndex] >= UpstreamBedElevation[TimeIndex] then
    begin
      ErrorFound := True;
    end
  end;
  if ErrorFound then
  begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Warning: negative or zero upstream bed thickness (THICKM1 <= 0)';
      FirstError := False;
  end;

  // test downstream bed bottom and top.
  if not AlternateExportTemplate and
    (DownstreamBedBottom[TimeIndex] >= DownstreamBedElevation[TimeIndex]) then
  begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Warning: negative or zero downstream bed thickness (THICKM2 <= 0)';
      FirstError := False;
  end;

  // test stream width
  ErrorFound := False;
  if AlternateExportTemplate then
  begin
    for Index := 0 to ReachList.Count -1 do
    begin
      Reach:= ReachList[Index];
      if Reach.Reach.Width[TimeIndex] <= 0 then
      begin
        ErrorFound := True;
        Break;
      end;
    end;
  end
  else
  begin
    if UpstreamWidth[TimeIndex] <= 0 then
    begin
      ErrorFound := True;
    end
  end;
  if ErrorFound then
  begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Invalid negative or zero upstream stream width with ICALC < 2 (WIDTH1 < 0)';
      FirstError := False;
  end;

  // test downstream width.
  if not AlternateExportTemplate and (DownstreamWidth[TimeIndex] <= 0) then
  begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Invalid negative or zero downstream stream width with ICALC < 2 (WIDTH2 < 0)';
      FirstError := False;
  end;

  if ICALC = 0 then
  begin
    // test stage
    ErrorFound := False;
    if AlternateExportTemplate then
    begin
      for Index := 0 to ReachList.Count -1 do
      begin
        Reach:= ReachList[Index];
        if Reach.Reach.Stage[TimeIndex] < Reach.Reach.StreamBedTop[TimeIndex] then
        begin
          ErrorFound := True;
          Break;
        end;
      end;
    end
    else
    begin
      if UpstreamStage[TimeIndex] < UpstreamBedElevation[TimeIndex] then
      begin
        ErrorFound := True;
      end
    end;
    if ErrorFound then
    begin
        AddCommaIfNeeded;
        ErrorMessage := ErrorMessage + 'Warning: negative upstream stream depth (DEPTH1 < 0)';
        FirstError := False;
    end;

    if not AlternateExportTemplate and
      (DownstreamStage[TimeIndex] < DownstreamBedElevation[TimeIndex]) then
    begin
        AddCommaIfNeeded;
        ErrorMessage := ErrorMessage + 'Warning: negative downstream stream depth (DEPTH2 < 0)';
        FirstError := False;
    end;
  end;

  result := FirstError;
end;


function TStrSegment.Width(TimeIndex: integer;
  const Factor: double): double;
begin
  result := UpstreamWidth[TimeIndex]
    - (UpstreamWidth[TimeIndex] - DownstreamWidth[TimeIndex]) * Factor;

end;

procedure TStrSegment.WriteHydmod(const HydmodWriter: TListWriter);
var
  HydWriter : THydmodWriter;
  Seg : integer;
  Index : integer;
  StreamReachObject : TStrReachObject;
begin
  if HydmodStageObservation or HydmodFlowInObservation or
    HydmodFlowOutObservation or HydmodFlowIntoAquiferObservation then
  begin
    Seg := Number;
    HydWriter := HydmodWriter as THydmodWriter;
    for Index := 0 to ReachList.Count -1 do
    begin
      StreamReachObject := ReachList[Index];
      if HydmodStageObservation then
      begin
        Writeln(HydWriter.HydFile, 'STR ST C ', StreamReachObject.Reach.Layer,
          ' ', Seg, ' ', Index+1, ' ', HydmodLabel);
      end;
      if HydmodFlowInObservation then
      begin
        Writeln(HydWriter.HydFile, 'STR SI C ', StreamReachObject.Reach.Layer,
          ' ', Seg, ' ', Index+1, ' ', HydmodLabel);
      end;
      if HydmodFlowOutObservation then
      begin
        Writeln(HydWriter.HydFile, 'STR SO C ', StreamReachObject.Reach.Layer,
          ' ', Seg, ' ', Index+1, ' ', HydmodLabel);
      end;
      if HydmodFlowIntoAquiferObservation then
      begin
        Writeln(HydWriter.HydFile, 'STR SA C ', StreamReachObject.Reach.Layer,
          ' ', Seg, ' ', Index+1, ' ', HydmodLabel);
      end;

    end;
  end;
end;

procedure TStrSegment.WriteMT3DConcentrations(const StressPeriod: integer;
  const Lines: TStrings);
var
  ConcentrationString : string;
  SpeciesIndex : integer;
begin
  Assert(SpeciesCount >= 1);
  ConcentrationString :=
    TModflowWriter.FixedFormattedReal(MT3D_Concentrations[StressPeriod-1,0], 10)
    + TModflowWriter.FixedFormattedInteger(21, 10) + ' ';
  for SpeciesIndex := 0 to SpeciesCount-1 do
  begin
    ConcentrationString := ConcentrationString + TModflowWriter.FreeFormattedReal
      (MT3D_Concentrations[StressPeriod-1,SpeciesIndex]);
  end;
  ReachList.WriteMT3DConcentrations(Lines, ConcentrationString);
end;

procedure TStrSegment.WriteSegment(const StreamWriter: TStrWriter; const TimeIndex : integer);
begin
  ReachList.Write(StreamWriter,TimeIndex);
end;

{ TStrSegmentList }

procedure TStrSegmentList.Write(const StreamWriter: TStrWriter;
  const TimeIndex : integer; var ErrorsFound : boolean) ;
var
  Index : integer;
  Segment : TStrSegment;
  StreamErrors : TStringList;
  ErrorMessage : string;
begin
  ErrorsFound := False;
  StreamErrors := TStringList.Create;
  StreamErrors.Add('');
  try
    for Index := 0 to Count -1 do
    begin
      Segment := Items[Index] as TStrSegment;

      if not Segment.ValuesAreValid(ErrorMessage, TimeIndex,
        StreamWriter.ICALC, StreamWriter.AlternateExportTemplate) then
      begin
        StreamErrors.Add(ErrorMessage);
      end;
      Segment.WriteSegment(StreamWriter, TimeIndex);
    end;
  finally
    if StreamErrors <> nil then
    begin
      if StreamErrors.Count > 1 then
      begin
        if ErrorMessages <> nil then
        begin
          ErrorMessages.AddStrings(StreamErrors);
        end;
        ErrorsFound := True;
      end;
    end;
    StreamErrors.Free;
  end;
end;

procedure TStrSegmentList.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  Index : integer;
  Segment : TStrSegment;
begin
  for Index := 0 to Count -1 do
  begin
    Segment := Items[Index] as TStrSegment;
    Segment.WriteMT3DConcentrations(StressPeriod, Lines);
  end;
end;

{ TStrParameterObject }

constructor TStrParameterObject.Create;
var
  TimeCount : integer;
begin
  inherited;
  Instances := TStringList.Create;
  TimeCount := frmModflow.dgTime.RowCount -1;
  SegmentList := TStrSegmentList.Create;
  SetLength(Active,TimeCount);
  SetLength(InstanceNamesUsed, TimeCount);
end;

destructor TStrParameterObject.Destroy;
begin
  Instances.Free;
  SegmentList.Free;
  inherited;
end;

procedure TStrParameterObject.SetName(const Value: ShortString);
var
  Index : integer;
begin
  FName := UpperCase(Trim(Value));
  if Length(FName) > 10 then
  begin
    SetLength(FName,10)
  end;
  for Index := 1 to Length(FName) do
  begin
    if FName[Index] = ' ' then
    begin
      FName[Index] := '_';
    end;
  end;
end;

procedure TStrParameterObject.Write(StreamWriter: TStrWriter;
  var ErrorsFound : boolean);
var
  Index : integer;
  ReachCount : integer;
  Segment : TStrSegment;
  TimeIndex : integer;
begin
  ReachCount := 0;
  for Index := 0 to SegmentList.Count -1 do
  begin
    Segment := SegmentList[Index] as TStrSegment;
    ReachCount := ReachCount + Segment.ReachList.Count;
  end;

  // data set 3
  System.Write(StreamWriter.FFile, Name, ' STR ',
    StreamWriter.FreeFormattedReal(Value),
    ReachCount);
  if Instances.Count > 0 then
  begin
    System.Write(StreamWriter.FFile, ' INSTANCES ', Instances.Count);
  end;


  Writeln(StreamWriter.FFile);

  if Instances.Count = 0 then
  begin
    SegmentList.Write(StreamWriter, 0, ErrorsFound);
  end
  else
  begin
    for TimeIndex := 0 to Instances.Count -1 do
    begin
      WriteLn(StreamWriter.FFile, Instances[TimeIndex]);
      SegmentList.Write(StreamWriter, TimeIndex, ErrorsFound);
    end;
  end;

end;

{ TStrReachList }

function TStrReachList.Add(StreamReach: TStrReachRecord): TStrReachObject;
begin
  result := TStrReachObject.Create;
  result.Reach := StreamReach;
  inherited Add(result);
end;

constructor TStrReachList.Create(const Segment: TStrSegment);
begin
  inherited Create;
  self.Segment := Segment
end;

function TStrReachList.GetItems(Index: Integer): TStrReachObject;
begin
  result := inherited Items[Index] as TStrReachObject;
end;

function TStrReachList.GetTotalLength: double;
var
  Index : integer;
  StreamReachObject : TStrReachObject;
begin
  result := 0;
  for Index := 0 to Count - 1 do
  begin
    StreamReachObject := Items[Index];
    result := result + StreamReachObject.Reach.ChannelLength;
  end;

end;

procedure TStrReachList.SetItems(Index: Integer;
  const Value: TStrReachObject);
begin
  inherited Items[Index] := Value;
end;

procedure TStrReachList.Write(StreamWriter: TStrWriter;
  Const TimeIndex : integer);
var
  Seg : integer;
  Index : integer;
  StreamReachObject : TStrReachObject;
  TotalLength : double;
  PreviousLength : double;
  CurrentLength : double;
  Stage : double;
  Conductance : double;
  Sbot : double;
  Stop : double;
  Factor : double;
  Width : double;
  Flow : double;
begin
  Assert(Segment <> nil);
  Seg := Segment.Number;

  TotalLength := GetTotalLength;

  PreviousLength := 0;
  for Index := 0 to Count - 1 do
  begin
    StreamReachObject := Items[Index];
    if Index = 0 then
    begin
      CurrentLength := 0;
    end
    else if Index = Count - 1 then
    begin
      CurrentLength := TotalLength;
    end
    else
    begin
      CurrentLength := PreviousLength
        + StreamReachObject.Reach.ChannelLength/2;
    end;

    if TotalLength = 0 then
    begin
      Factor := 1;
    end
    else
    begin
      Factor := CurrentLength/TotalLength;
    end;

    if Index > 0 then
    begin
      Flow := 0;
    end
    else if Segment.Tributaries.Count > 0 then
    begin
      Flow := -1;
    end
    else
    begin
      Flow := Segment.Flow[TimeIndex];
    end;

    if StreamWriter.AlternateExportTemplate then
    begin
      Stage := StreamReachObject.Reach.Stage[TimeIndex];
      Width := StreamReachObject.Reach.Width[TimeIndex];
      Sbot := StreamReachObject.Reach.StreamBedBottom[TimeIndex];
      Stop := StreamReachObject.Reach.StreamBedTop[TimeIndex];
    end
    else
    begin
      Stage := Segment.UpstreamStage[TimeIndex]
        - (Segment.UpstreamStage[TimeIndex]
           - Segment.DownstreamStage[TimeIndex])
           * Factor;

      Width := Segment.Width(TimeIndex, Factor);

      Sbot := Segment.UpstreamBedBottom[TimeIndex]
        - (Segment.UpstreamBedBottom[TimeIndex]
           - Segment.DownstreamBedBottom[TimeIndex])
           * Factor;

      Stop := Segment.UpstreamBedElevation[TimeIndex]
        - (Segment.UpstreamBedElevation[TimeIndex]
           - Segment.DownstreamBedElevation[TimeIndex])
           * Factor;

    end;

    if Sbot = Stop then
    begin
      raise EStreamError.Create('Error in Stream package: the top and bottom '
        + 'elevations of the stream reach in (Layer, Row, Column) = ('
        + IntToStr(StreamReachObject.Reach.Layer) + ', '
        + IntToStr(StreamReachObject.Reach.Row) + ', '
        + IntToStr(StreamReachObject.Reach.Column) + ') '
        + 'are the same.  This must be fixed before the Stream package input '
        + 'file can be exported.');
    end;


    if StreamWriter.AlternateExportTemplate then
    begin
      Conductance := StreamReachObject.Reach.HydraulicConductivity
        * StreamReachObject.Reach.ChannelLength
        * Width / (Stop - Sbot);
    end
    else
    begin
      Conductance := Segment.HydraulicConductivity
        * StreamReachObject.Reach.ChannelLength
        * Width / (Stop - Sbot);
    end;

    Writeln(StreamWriter.FFile,
      StreamWriter.FixedFormattedInteger(StreamReachObject.Reach.Layer, 5),
      StreamWriter.FixedFormattedInteger(StreamReachObject.Reach.Row, 5),
      StreamWriter.FixedFormattedInteger(StreamReachObject.Reach.Column, 5),
      StreamWriter.FixedFormattedInteger(Seg, 5),
      StreamWriter.FixedFormattedInteger(Index + 1, 5),
      StreamWriter.FixedFormattedReal(Flow,15),
      StreamWriter.FixedFormattedReal(Stage,10),
      StreamWriter.FixedFormattedReal(Conductance,10),
      StreamWriter.FixedFormattedReal(Sbot,10),
      StreamWriter.FixedFormattedReal(Stop,10),
      ' \\ Segment number = ', Segment.FNumber);

    PreviousLength := PreviousLength
      + StreamReachObject.Reach.ChannelLength;
  end;
end;

procedure TStrReachList.WriteMT3DConcentrations(const Lines: TStrings;
  const Concentration: string);
var
  Index : integer;
  StreamReachObject : TStrReachObject;
begin
  for Index := 0 to Count - 1 do
  begin
    StreamReachObject := Items[Index];
    StreamReachObject.WriteMT3DConcentrations(Lines, Concentration)
  end;
end;

procedure TStrReachList.WriteObservation(const ReachList : TStringList);
var
  Seg : integer;
  Index : integer;
  ALine : string;
begin
  Assert(Segment <> nil);
  Seg := Segment.Number;

  for Index := 0 to Count - 1 do
  begin
    ALine := IntToStr(Seg) + ' '
      + IntToStr(Index + 1) + ' 1';
    ReachList.Add(ALine);
  end;
end;

procedure TStrReachList.WriteWidthSlopeRoughness(StreamWriter: TStrWriter;
  const TimeIndex: integer);
var
  Index : integer;
  StreamReachObject : TStrReachObject;
  TotalLength : double;
  PreviousLength : double;
  CurrentLength : double;
  Factor : double;
  Width, Slope, Roughness : double;
begin
  Assert(Segment <> nil);

  TotalLength := GetTotalLength;

  PreviousLength := 0;
  for Index := 0 to Count - 1 do
  begin
    StreamReachObject := Items[Index];
    if Index = 0 then
    begin
      CurrentLength := 0;
    end
    else if Index = Count - 1 then
    begin
      CurrentLength := TotalLength;
    end
    else
    begin
      CurrentLength := PreviousLength
        + StreamReachObject.Reach.ChannelLength/2;
    end;

    if TotalLength = 0 then
    begin
      Factor := 1;
    end
    else
    begin
      Factor := CurrentLength/TotalLength;
    end;

    if StreamWriter.AlternateExportTemplate then
    begin
      Width := StreamReachObject.Reach.Width[TimeIndex];
      Slope := StreamReachObject.Reach.Slope[TimeIndex];
      Roughness := StreamReachObject.Reach.Roughness[TimeIndex];
    end
    else
    begin
      Width := Segment.Width(TimeIndex, Factor);
      Slope := Segment.Slope[TimeIndex];
      Roughness := Segment.ChannelRoughness[TimeIndex];
    end;

    Writeln(StreamWriter.FFile,
      StreamWriter.FixedFormattedReal(Width,10),
      StreamWriter.FixedFormattedReal(Slope,10),
      StreamWriter.FixedFormattedReal(Roughness,10));

    PreviousLength := PreviousLength
      + StreamReachObject.Reach.ChannelLength;
  end;
end;

{ TStrWriter }

function TStrWriter.ComputeStreamConstant: double;
var
  ErrorMessage : string;
begin
  result := 1;
  case frmModflow.comboLengthUnits.ItemIndex of
    0:
      begin
        ErrorMessage := 'Error in Stream package: Length units for model are undefined';
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add(' ');
        ErrorMessages.Add(ErrorMessage);
      end;
    1: // feet
      begin
        result := 1/0.3048;
      end;
    2: // m
      begin
      end;
    3: // cm
      begin
        result := 1/100;
      end;
  else Assert(False);
  end;
  if result <> 1 then
  begin
    result := Power(result, 1/3);
  end;
  case frmModflow.comboTimeUnits.ItemIndex of
    0: // Undefined
      begin
        ErrorMessage := 'Error in Stream package: Time units for model are undefined';
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add(' ');
        ErrorMessages.Add(ErrorMessage);
      end;
    1: // Seconds
      begin
      end;
    2: // Minutes
      begin
        result := result * 60;
      end;
    3: // Hours
      begin
        result := result * 60 * 60;
      end;
    4: // Days
      begin
        result := result * 60 * 60 * 24;
      end;
    5: // Years
      begin
        result := result * 60 * 60 * 24 * 365.25;
      end;
  else Assert(False);
  end;
end;

constructor TStrWriter.Create;
begin
  inherited;
  LineErrors := 0;
  ParameterList := TStrParameterList.Create;
  SegmentList := TStrSegmentList.Create;
  ListOfSegments := TList.Create;
  StreamObservations := TStringList.Create;
  ObservationIndicies := TIntegerList.Create;
  NQCST := 0;
  NQTST := 0;
end;

destructor TStrWriter.Destroy;
var
  Index : integer;
begin
  ParameterList.Free;
  SegmentList.Free;
  ListOfSegments.Free;
  ObservationIndicies.Free;
  for Index := StreamObservations.Count -1 downto 0 do
  begin
    StreamObservations.Objects[Index].Free;
  end;
  StreamObservations.Free;

  inherited;
end;

procedure TStrWriter.EvaluateTributaries;
var
  OuterIndex : integer;
  InnerIndex : integer;
  Seg1, Seg2 : TStrSegment;
begin
  if frmMODFLOW.cbStreamTrib.Checked then
  begin
    for OuterIndex := 0 to ListOfSegments.Count -1 do
    begin
      Seg1 := ListOfSegments[OuterIndex];
      if Seg1.FOutflowSegment <> 0 then
      begin
        for InnerIndex := 0 to ListOfSegments.Count -1  do
        begin
          Seg2 := ListOfSegments[InnerIndex];
          if Seg1.FOutflowSegment = Seg2.FNumber then
          begin
            Seg2.Tributaries.Add(Seg1);
            break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TStrWriter.EvaluateStreamLayer(const UnitIndex: integer);
var
  LayerName : string;
  Layer : TLayerOptions;
  ContourCount : integer;
  Contour : TContourObjectOptions;
  ContourIndex : ANE_INT32;
  Indicies : TStrParamIndicies;
  TimeIndicies : array of TStrTimeParamIndicies;
  StreamObservationIndicies : array of TStrObservationTimeParamIndicies;
  TimeCount : integer;
  TimeIndex : integer;
  IsParam : boolean;
  ParameterName : string;
  ParameterObject : TStrParameterObject;
  Segment : TStrSegment;
  TimesToUse : integer;
  ObservationTimeCount : integer;
  ErrorMessage : string;
begin
  if frmModflow.Simulated(UnitIndex) then
  begin
    LayerName := ModflowTypes.GetMFStreamLayerType.ANE_LayerName
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
    try
      GetStreamParameterIndicies(Layer, Indicies);

      if frmMODFLOW.comboStreamOption.ItemIndex = 0 then
      begin
        TimeCount := 1;
      end
      else
      begin
        TimeCount := frmModflow.dgTime.RowCount - 1;
      end;

      SetLength(TimeIndicies,TimeCount);
      for TimeIndex := 0 to TimeCount -1 do
      begin
        GetStreamTimeParameterIndicies(Layer,TimeIndicies[TimeIndex], TimeIndex+1);
      end;

      if frmMODFLOW.cbStreamObservations.Checked
        and frmModflow.cbObservations.Checked then
      begin
        ObservationTimeCount := StrToInt(frmMODFLOW.adeObsSTRTimeCount.Text);
        SetLength(StreamObservationIndicies,ObservationTimeCount);
        for TimeIndex := 0 to ObservationTimeCount -1 do
        begin
          GetStreamObservationTimeParameterIndicies(Layer,
            StreamObservationIndicies[TimeIndex], TimeIndex+1);
        end;
      end
      else
      begin
        ObservationTimeCount := 0;
      end;

      ContourCount := Layer.NumObjects(CurrentModelHandle,pieContourObject);
      frmProgress.pbActivity.Max := ContourCount;
      for ContourIndex := 0 to ContourCount -1 do
      begin
        Contour := TContourObjectOptions.Create(CurrentModelHandle,
          Layer.LayerHandle, ContourIndex);
        try
          if Contour.ContourType(CurrentModelHandle) <> ctOpen then
          begin
            Inc(LineErrors);
          end
          else
          begin
            Segment := TStrSegment.Create;
            IsParam := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsParameterIndex);
            if IsParam then
            begin
              ParameterName := UpperCase(Contour.GetStringParameter
                (CurrentModelHandle,Indicies.ParameterNameIndex));
              if Length(ParameterName) > 10 then
              begin
                SetLength(ParameterName,10);
              end;
              ParameterObject := ParameterList.GetParameterByName(ParameterName);
              TimesToUse := 0;
              if ParameterObject = nil then
              begin
                ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
                  + ' in the Stream package.  Contours using this parameter name will be '
                  + 'ignored.';
                ErrorMessages.Add(ErrorMessage);
                frmProgress.reErrors.Lines.Add(ErrorMessage);
                Segment.Free;
                Break;
              end
              else
              begin
                ParameterObject.SegmentList.Add(Segment);
                TimesToUse := ParameterObject.Instances.Count;
                if TimesToUse = 0 then
                begin
                  TimesToUse := 1;
                end;
              end;
            end // if IsParam then
            else
            begin
              SegmentList.Add(Segment);
              TimesToUse := TimeCount;
            end;
            GetStreamSegmentValues(Indicies,Segment,Contour);
            for TimeIndex := 0 to TimesToUse -1 do
            begin
              GetStreamTimeParameterValues(TimeIndicies[TimeIndex],
                Segment,Contour,TimeIndex);
            end;

            for TimeIndex := 0 to ObservationTimeCount -1 do
            begin
              GetStreamObservationTimeParameterValues(
                StreamObservationIndicies[TimeIndex],
                Segment,Contour,TimeIndex);
            end;

            AddCells(Segment, ContourIndex, UnitIndex, Layer, Indicies,
              TimeIndicies);
          end;
        finally
          Contour.Free;
        end;
        frmProgress.pbActivity.StepIt;
      end;
    finally
      Layer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TStrWriter.GetStreamTimeParameterValues(
  const Indicies: TStrTimeParamIndicies; const Segment: TStrSegment;
  const Contour: TContourObjectOptions; const TimeIndex : integer);
var
  SpeciesIndex : integer;
begin
  Segment.Active[TimeIndex] := Contour.GetBoolParameter(CurrentModelHandle,
    Indicies.OnOffParamIndex);

  Segment.Flow.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.StreamFlowParamIndex));

  Segment.UpstreamBedElevation.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.StreamUpTopElevParamIndex));

  Segment.DownstreamBedElevation.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DownstreamTopElevationParamIndex));

  Segment.UpstreamBedBottom.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.UpstreamBottomParamIndex));

  Segment.DownstreamBedBottom.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DownstreamBottomParamIndex));

  Segment.UpstreamStage.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.UpsteamStageIndex));

  Segment.DownstreamStage.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DownstreamStageIndex));

  Segment.UpstreamWidth.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.UpstreamWidthIndex));

  Segment.DownstreamWidth.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DownstreamWidthIndex));

  if ICALC > 0 then
  begin
  Segment.Slope.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.SlopeIndex));

  Segment.ChannelRoughness.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.RoughnessIndex));

  end;
  if Indicies.IFACEParamIndex > -1 then
  begin
    Segment.IFACE.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.IFACEParamIndex));
  end;

  for SpeciesIndex := 0 to Length(Indicies.MT3D_ConcentrationIndicies) -1 do
  begin
    Segment.MT3D_Concentrations[TimeIndex, SpeciesIndex] :=
      Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.MT3D_ConcentrationIndicies[SpeciesIndex])
  end;

end;

procedure TStrWriter.GetStreamParameterIndicies(const Layer: TLayerOptions;
  var  Indicies : TStrParamIndicies);
var
  ParameterName : string;
begin
  ParameterName := ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  Indicies.ParameterNameIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.ParameterNameIndex > -1);

  ParameterName := ModflowTypes.GetMFIsParameterParamType.ANE_ParamName;
  Indicies.IsParameterIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.IsParameterIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName;
  Indicies.SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.SegmentNumberIndex > -1);

  if frmMODFLOW.cbStreamTrib.Checked then
  begin
    ParameterName := ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName;
    Indicies.DownstreamSegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.DownstreamSegmentNumberIndex > -1);
  end
  else
  begin
    Indicies.DownstreamSegmentNumberIndex := -1;
  end;

  ParameterName := ModflowTypes.GetMFStreamHydCondParamType.ANE_ParamName;
  Indicies.HydraulicConductivityName := ParameterName;
  Indicies.HydraulicConductivityIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.HydraulicConductivityIndex > -1);

  if frmMODFLOW.cbStreamDiversions.Checked then
  begin
    ParameterName := ModflowTypes.GetMFStreamDivSegNumParamType.ANE_ParamName;
    Indicies.DiversionSegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.DiversionSegmentNumberIndex > -1);
  end
  else
  begin
    Indicies.DiversionSegmentNumberIndex := -1;
  end;

  if frmMODFLOW.cbObservations.Checked and frmMODFLOW.cbStreamObservations.Checked then
  begin
    ParameterName := ModflowTypes.GetMFStatFlagParamType.ANE_ParamName;
    Indicies.StatFlagIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.StatFlagIndex > -1);

    ParameterName := ModflowTypes.GetMFPlotSymbolParamType.ANE_ParamName;
    Indicies.PlotSymbolIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.PlotSymbolIndex > -1);

  end
  else
  begin
    Indicies.StatFlagIndex := -1;
    Indicies.PlotSymbolIndex := -1;
  end;

  if frmMODFLOW.cbHYD.Checked then
  begin
    ParameterName := ModflowTypes.GetMFHydmodStreamStageObservationParamType.ANE_ParamName;
    Indicies.HydmodStageIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.HydmodStageIndex > -1);

    ParameterName := ModflowTypes.GetMFHydmodStreamFlowInObservationParamType.ANE_ParamName;
    Indicies.HydmodFlowInIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.HydmodFlowInIndex > -1);

    ParameterName := ModflowTypes.GetMFHydmodStreamFlowOutObservationParamType.ANE_ParamName;
    Indicies.HydmodFlowOutIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.HydmodFlowOutIndex > -1);

    ParameterName := ModflowTypes.GetMFHydmodStreamFlowIntoAquiferObservationParamType.ANE_ParamName;
    Indicies.HydmodFlowIntoAquiferIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.HydmodFlowIntoAquiferIndex > -1);

    ParameterName := ModflowTypes.GetMFHydmodLabelParamType.ANE_ParamName;
    Indicies.HydmodLabelIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.HydmodLabelIndex > -1);
  end
  else
  begin
    Indicies.HydmodStageIndex := -1;
    Indicies.HydmodFlowInIndex := -1;
    Indicies.HydmodFlowOutIndex := -1;
    Indicies.HydmodFlowIntoAquiferIndex := -1;
    Indicies.HydmodLabelIndex := -1;
  end;


end;

procedure TStrWriter.GetStreamSegmentValues(
  const Indicies: TStrParamIndicies; const Segment: TStrSegment;
  const Contour: TContourObjectOptions);
begin
  Segment.FNumber := Contour.GetIntegerParameter(CurrentModelHandle,
    Indicies.SegmentNumberIndex);

  if Indicies.DownstreamSegmentNumberIndex > -1 then
  begin
    Segment.FOutflowSegment := Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.DownstreamSegmentNumberIndex);
  end
  else
  begin
    Segment.FOutflowSegment := 0;
  end;

  if Indicies.DiversionSegmentNumberIndex > -1 then
  begin
    Segment.FDiversionSegment := Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.DiversionSegmentNumberIndex);
  end
  else
  begin
    Segment.FDiversionSegment := 0;
  end;

  Segment.HydraulicConductivity := Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.HydraulicConductivityIndex);

  if frmModflow.cbStreamObservations.Checked
    and frmModflow.cbObservations.Checked then
  begin
    Segment.StatFlag := Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.StatFlagIndex);

    Segment.PlotSymbol := Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.PlotSymbolIndex);
  end;

  if frmModflow.cbHYD.Checked then
  begin
    Segment.HydmodStageObservation := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.HydmodStageIndex);

    Segment.HydmodFlowInObservation := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.HydmodFlowInIndex);

    Segment.HydmodFlowOutObservation := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.HydmodFlowOutIndex);

    Segment.HydmodFlowIntoAquiferObservation := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.HydmodFlowIntoAquiferIndex);

    Segment.HydmodLabel := Contour.GetStringParameter(CurrentModelHandle,
      Indicies.HydmodLabelIndex) + ' ';
  end;
end;

function TStrWriter.GetSegment(Index: integer): TStrSegment;
begin
  result := ListOfSegments[Index];
end;

procedure TStrWriter.GetStreamObservationTimeParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TStrObservationTimeParamIndicies;
  const TimeIndex: integer);
var
  TimeString : string;
  ParameterName : string;
begin
  TimeString := IntToStr(TimeIndex);

  ParameterName := ModflowTypes.GetMFObservationNameParamType.ANE_ParamName + TimeString;
  Indicies.ObservationNameParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.ObservationNameParamIndex > -1);

  ParameterName := ModflowTypes.GetMFTimeParamType.ANE_ParamName + TimeString;
  Indicies.TimeParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.TimeParamIndex > -1);

  ParameterName := ModflowTypes.GetMFLossParamType.ANE_ParamName + TimeString;
  Indicies.LossParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.LossParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStatisticParamType.ANE_ParamName + TimeString;
  Indicies.StatisticParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.StatisticParamIndex > -1);

  ParameterName := ModflowTypes.GetMFIsObservationParamType.ANE_ParamName + TimeString;
  Indicies.IsObservationParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.IsObservationParamIndex > -1);

  ParameterName := ModflowTypes.GetMFIsPredictionParamType.ANE_ParamName + TimeString;
  Indicies.IsPredictionParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.IsPredictionParamIndex > -1);

  ParameterName := ModflowTypes.GetMFReferenceStressPeriodParamClassType.ANE_ParamName + TimeString;
  Indicies.ReferenceStressPeriodIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.ReferenceStressPeriodIndex > -1);

  if frmMODFLOW.cbSpecifyStreamCovariances.Checked then
  begin
    ParameterName := ModflowTypes.GetMFObservationNumberParamType.ANE_ParamName + TimeString;
    Indicies.ObservationNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.ObservationNumberIndex > -1);
  end
  else
  begin
    Indicies.ObservationNumberIndex := -1;
  end;
end;

procedure TStrWriter.GetStreamTimeParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TStrTimeParamIndicies;
  const TimeIndex: integer);
var
  TimeString : string;
  ParameterName : string;
  SpeciesCount, SpeciesIndex : integer;
begin
  TimeString := IntToStr(TimeIndex);

  ParameterName := ModflowTypes.GetMFOnOffParamType.ANE_ParamName + TimeString;
  Indicies.OnOffParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.OnOffParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName + TimeString;
  Indicies.StreamFlowParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.StreamFlowParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamUpTopElevParamType.ANE_ParamName + TimeString;
  Indicies.TopElevName := ParameterName;
  Indicies.StreamUpTopElevParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.StreamUpTopElevParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamDownTopElevParamType.ANE_ParamName + TimeString;
  Indicies.DownstreamTopElevationParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.DownstreamTopElevationParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamUpBotElevParamType.ANE_ParamName + TimeString;
  Indicies.BottomElevName := ParameterName;
  Indicies.UpstreamBottomParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.UpstreamBottomParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamDownBotElevParamType.ANE_ParamName + TimeString;
  Indicies.DownstreamBottomParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.DownstreamBottomParamIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamUpStageParamType.ANE_ParamName + TimeString;
  Indicies.StageName := ParameterName;
  Indicies.UpsteamStageIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.UpsteamStageIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamDownStageParamType.ANE_ParamName + TimeString;
  Indicies.DownstreamStageIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.DownstreamStageIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamUpWidthParamType.ANE_ParamName + TimeString;
  Indicies.WidthName := ParameterName;
  Indicies.UpstreamWidthIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.UpstreamWidthIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamDownWidthParamType.ANE_ParamName + TimeString;
  Indicies.DownstreamWidthIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
  Assert(Indicies.DownstreamWidthIndex > -1);

  if ICALC > 0 then
  begin
    ParameterName := ModflowTypes.GetMFStreamSlopeParamType.ANE_ParamName + TimeString;
    Indicies.SlopeName := ParameterName;
    Indicies.SlopeIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.SlopeIndex > -1);

    ParameterName := ModflowTypes.GetMFStreamRoughParamType.ANE_ParamName + TimeString;
    Indicies.RoughnessName := ParameterName;
    Indicies.RoughnessIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.RoughnessIndex > -1);
  end
  else
  begin
    Indicies.SlopeIndex := -1;
    Indicies.SlopeName := '';
    Indicies.RoughnessIndex := -1;
    Indicies.RoughnessName := '';
  end;

  if ModflowTypes.GetMFStreamLayerType.UseIFACE then
  begin
    ParameterName := ModflowTypes.GetMFIFACEParamType.ANE_ParamName + TimeString;
    Indicies.IFACEParamIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
    Assert(Indicies.IFACEParamIndex > -1);
  end
  else
  begin
    Indicies.IFACEParamIndex := -1;
  end;

  if frmModflow.cbMT3D.Checked then
  begin
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(Indicies.MT3D_ConcentrationIndicies, SpeciesCount);

    for SpeciesIndex := 1 to SpeciesCount do
    begin
      case SpeciesIndex of
        1: ParameterName := ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName;
        2: ParameterName := ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName;
        3: ParameterName := ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName;
        4: ParameterName := ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName;
        5: ParameterName := ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName;
      else Assert(False);
      end;
      ParameterName := ParameterName + TimeString;
      Indicies.MT3D_ConcentrationIndicies[SpeciesIndex-1]
        := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
      Assert(Indicies.MT3D_ConcentrationIndicies[SpeciesIndex-1] > -1);
    end;
  end;
end;

procedure TStrWriter.MakeListOfSegments;
var
  Segment : TStrSegment;
  SegmentIndex : integer;
  ParameterIndex : integer;
  Parameter : TStrParameterObject;
begin
  ListOfSegments.Clear;
  if ParameterList.Count = 0 then
  begin
    for SegmentIndex := 0 to SegmentList.Count -1 do
    begin
      Segment := SegmentList[SegmentIndex] as TStrSegment;
      if ListOfSegments.IndexOf(Segment) < 0 then
      begin
        ListOfSegments.Add(Segment);
        Segment.StreamWriter := self;
      end;
    end;
  end
  else
  begin
    for ParameterIndex := 0 to ParameterList.Count -1 do
    begin
      Parameter := ParameterList.Items[ParameterIndex] as TStrParameterObject;
      Parameter.SegmentList.Sort(SortSegments);
    end;
    ParameterList.Sort(SortParameters);
    for ParameterIndex := 0 to ParameterList.Count -1 do
    begin
      Parameter := ParameterList.Items[ParameterIndex] as TStrParameterObject;
      for SegmentIndex := 0 to Parameter.SegmentList.Count -1 do
      begin
        Segment := Parameter.SegmentList[SegmentIndex] as TStrSegment;
        if ListOfSegments.IndexOf(Segment) < 0 then
        begin
          ListOfSegments.Add(Segment);
          Segment.StreamWriter := self;
        end;
      end;
    end;
  end;

  EvaluateTributaries;

  if ParameterList.Count = 0 then
  begin
    ListOfSegments.Sort(SortSegments);
    SegmentList.Sort(SortSegments);
  end;
end;

function TStrWriter.SegmentCount: integer;
begin
  result := ListOfSegments.Count;
end;

procedure TStrWriter.SetICALC;
begin
  if frmMODFLOW.cbStreamCalcFlow.Checked then
  begin
    ICALC := 1;
  end
  else
  begin
    ICALC := 0;
  end;
end;


procedure TStrWriter.WriteDataSets1and2;
var
  Segment : TStrSegment;
  SegmentIndex, ParameterIndex : integer;
  MXACTS : integer;
  NSS : integer;
  NPSTR : integer;
  StreamConstant : double; // CONST
  ISTCB1 : integer;
  ISTCB2 : integer;
  MXL : integer;
  Param : TStrParameterObject;
  ParamReachCount : integer;
begin

  MXACTS := 0;
  NTRIB := 0;
  MXL := 0;

  for SegmentIndex := 0 to ListOfSegments.Count -1 do
  begin
    Segment := ListOfSegments[SegmentIndex];
    MXACTS := MXACTS + Segment.ReachList.Count;
    if Segment.Tributaries.Count > NTRIB then
    begin
      NTRIB := Segment.Tributaries.Count;
    end;
  end;

  NPSTR := ParameterList.Count;
  if NPSTR > 0 then
  begin
    for ParameterIndex := 0 to ParameterList.Count -1 do
    begin
      Param := ParameterList[ParameterIndex] as TStrParameterObject;
      ParamReachCount := 0;
      for SegmentIndex := 0 to Param.SegmentList.Count -1 do
      begin
        Segment := Param.SegmentList[SegmentIndex] as TStrSegment;
        ParamReachCount := ParamReachCount + Segment.ReachList.Count;
      end;

      if Param.Instances.Count > 0 then
      begin
        MXL := MXL + Param.Instances.Count*ParamReachCount;
      end
      else
      begin
        MXL := MXL + ParamReachCount;
      end;

    end;

  end;

  NSS := ListOfSegments.Count;

  if frmMODFLOW.cbStreamDiversions.Checked then
  begin
    NDIV := 1;
  end
  else
  begin
    NDIV := -1;
  end;

  StreamConstant := ComputeStreamConstant;

  if frmModflow.cbFlowSTR.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      ISTCB1 := frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      ISTCB1 := frmModflow.GetUnitNumber('BSt1Unit')
    end;
  end
  else
  begin
      ISTCB1 := -1;
  end;

  if frmModflow.cbFlowSTR2.Checked then
  begin
      ISTCB2 := frmModflow.GetUnitNumber('BSt2Unit')
  end
  else
  begin
      ISTCB2 := 0;
  end;

  if NPSTR > 0 then
  begin
    writeLn(FFile, 'PARAMETER ', NPSTR, ' ', MXL);
  end;

  writeLn(FFile, FixedFormattedInteger(MXACTS, 10),
    FixedFormattedInteger(NSS, 10),
    FixedFormattedInteger(NTRIB, 10),
    FixedFormattedInteger(NDIV, 10),
    FixedFormattedInteger(ICALC, 10),
    FixedFormattedReal(StreamConstant,10),
    FixedFormattedInteger(ISTCB1, 10),
    FixedFormattedInteger(ISTCB2, 10));
end;

procedure TStrWriter.WriteDataSets3and4(var ErrorsFound: boolean);
begin
  ParameterList.Write(self,ErrorsFound);
end;

procedure TStrWriter.WriteDataSets5To7(StressPeriod: integer;
  var ErrorsFound: boolean);
var
  IRDFLG : integer;
  IPTFLG : integer;
  NP : integer;
  Index : integer;
  AParameter : TStrParameterObject;
  ActiveParameters : TStringList;
  Error : boolean;
  Segment : TStrSegment;
begin
  IRDFLG := 0;
  if frmMODFLOW.cbStrPrintFlows.Checked then
  begin
    IPTFLG := 0;
  end
  else
  begin
    IPTFLG := 1;
  end;
  NP := 0;
  ActiveParameters := TStringList.Create;
  try
    if ParameterList.Count > 0 then
    begin
      for Index := 0 to ParameterList.Count -1 do
      begin
        AParameter := ParameterList.Items[Index] as TStrParameterObject;
        Assert(StressPeriod <= Length(AParameter.Active));
        if AParameter.Active[StressPeriod-1] then
        begin
          Inc(NP);
          ActiveParameters.AddObject(AParameter.Name, AParameter);
        end;
      end;
      ITMP := NP;
    end
    else
    begin
      if (StressPeriod = 1) or (frmModflow.comboStreamOption.ItemIndex = 1) then
      begin
        ITMP := 0;
        for Index := 0 to SegmentList.Count - 1 do
        begin
          Segment := SegmentList[Index] as TStrSegment;
          if Segment.Active[StressPeriod-1] then
          begin
            ITMP := ITMP + Segment.ReachList.Count;
          end;
        end;
      end
      else
      begin
        ITMP := -1;
      end;
    end;
    // Data Set 5

    WriteLn(FFile, FixedFormattedInteger(ITMP,10),
      FixedFormattedInteger(IRDFLG,10),
      FixedFormattedInteger(IPTFLG,10));
    if ParameterList.Count = 0 then
    begin
      // Data Set 6
      if ITMP > 0 then
      begin
        SegmentList.Write(self, StressPeriod-1,  Error);
        ErrorsFound := Error or ErrorsFound;
      end;
    end
    else
    begin
      // Data Set 7
      for Index := 0 to ActiveParameters.Count -1 do
      begin
        Write(FFile, ActiveParameters[Index]);
        AParameter := ActiveParameters.Objects[Index] as TStrParameterObject;
        if AParameter.Instances.Count > 0 then
        begin
          Write(FFile, ' ', AParameter.InstanceNamesUsed[StressPeriod-1]);
        end;

        Writeln(FFile);
      end;
    end;
  finally
    ActiveParameters.Free;
  end;
end;

procedure TStrWriter.WriteDataSet8(StressPeriod: integer);
var
  ParameterIndex : integer;
  AParameter : TStrParameterObject;
  SegmentIndex : integer;
  Segment : TStrSegment;
  SP : integer;
  Instance : integer;
begin
  if ICALC > 0 then
  begin
    If ITMP < 0 then
    begin
      Exit;
//      SP := 0;
    end
    else
    begin
      if ITMP = 0 then Exit;
      SP := StressPeriod-1;
    end;
    if ParameterList.Count = 0 then
    begin
      // Data Set 8
      for SegmentIndex := 0 to SegmentList.Count -1 do
      begin
        Segment := SegmentList[SegmentIndex] as TStrSegment;
        Segment.ReachList.WriteWidthSlopeRoughness(self, SP);
      end;
    end
    else
    begin
      for ParameterIndex := 0 to ParameterList.Count -1 do
      begin
        AParameter := ParameterList.Items[ParameterIndex] as TStrParameterObject;
        Assert(StressPeriod <= Length(AParameter.Active));
        if AParameter.Active[SP] then
        begin
          if AParameter.Instances.Count > 0 then
          begin
            Instance := AParameter.Instances.IndexOf(AParameter.InstanceNamesUsed[SP]);
          end
          else
          begin
            Instance := 0;
          end;

          for SegmentIndex := 0 to AParameter.SegmentList.Count -1 do
          begin
            Segment := AParameter.SegmentList[SegmentIndex] as TStrSegment;
            Segment.ReachList.WriteWidthSlopeRoughness(self, Instance);
          end;
        end;
      end;
    end;
  end;
end;

procedure TStrWriter.EvaluateStreamObservations;
var
  ParameterIndex : integer;
  SegmentIndex : integer;
  AParameter : TStrParameterObject;
  Segment : TStrSegment;
  Procedure EvaluateObservations;
  var
    ObservationIndex : integer;
    ObservationName : string;
    ObsIndex : integer;
    Observation : TStreamObservation;
  begin
    for ObservationIndex := 0 to Segment.ObservationNames.Count -1 do
    begin
      ObservationName := Segment.ObservationNames[ObservationIndex];

      if (ObservationName <> '') and (LowerCase(ObservationName) <> '$n/a') then
      begin
        ObsIndex := StreamObservations.IndexOf(ObservationName);
        if ObsIndex < 0 then
        begin
          Observation := TStreamObservation.Create;
          try
            if ObservationIndex < Segment.ObservationNumbers.Count then
            begin
              Observation.ObservationNumber := Segment.ObservationNumbers[ObservationIndex];
            end
            else
            begin
              Observation.ObservationNumber := 0
            end;
            Observation.Segments.Add(Segment);
            StreamObservations.AddObject(ObservationName,Observation);
          except
            Observation.Free;
          end;
        end
        else
        begin
          Observation := StreamObservations.Objects[ObsIndex]
            as TStreamObservation;
          if Observation.Segments.IndexOf(Segment) < 0 then
          begin
            Observation.Segments.Add(Segment);
          end;
        end;
      end;
    end;
  end;
begin
//  NQST := 0;
  if frmModflow.cbStreamObservations.Checked
    and frmModflow.cbObservations.Checked then
  begin
    if ParameterList.Count > 0 then
    begin
      for ParameterIndex := 0 to ParameterList.Count -1 do
      begin
        AParameter := ParameterList.Items[ParameterIndex] as TStrParameterObject;
        for SegmentIndex := 0 to AParameter.SegmentList.Count -1 do
        begin
          Segment := AParameter.SegmentList[SegmentIndex] as TStrSegment;
          EvaluateObservations;
        end;
      end;
    end
    else
    begin
      for SegmentIndex := 0 to SegmentList.Count -1 do
      begin
        Segment := SegmentList[SegmentIndex] as TStrSegment;
        EvaluateObservations;
      end;
    end;
  end;
end;

procedure TStrWriter.EvaluateStreams(var ErrorFound : boolean);
var
  UnitIndex : integer;
  UnitCount : integer;
begin
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Stream';
    SetICALC;
    if ContinueExport then
    begin
      // Read the MODFLOW-2000 stream parameters and
      // add them to ParameterList.
      AddParameters;
      UnitCount := frmModflow.dgGeol.RowCount -1;
      frmProgress.pbPackage.Position := 0;
      frmProgress.pbPackage.Max := UnitCount;
      for UnitIndex := 1 to UnitCount do
      begin
        if not ContinueExport then Exit;
        frmProgress.lblActivity.Caption := 'Evaluating Streams in Unit '
          + IntToStr(UnitIndex) + '.';
        EvaluateStreamLayer(UnitIndex);
        frmProgress.pbPackage.StepIt
      end;
    end;
    EvaluateStreamObservations;
  end;
  ErrorFound := False;
  if (ParameterList.Count > 0) and (SegmentList.Count > 0) then
  begin
    ErrorFound := True;
    ErrorMessages.Add('');
    ErrorMessages.Add('Stream package error');
    ErrorMessages.Add('Error: In the stream package, ALL streams must be '
      + 'simulated using parameters or NONE must be simulated with '
      + 'parameters.  In this model, some are simulated with parameters '
      + 'and others aren''t.  Only the segments simulated with parameters '
      + 'will be used in the model.');
  end;
end;

procedure TStrWriter.Evaluate
  (const DiscretizationWriter : TDiscretizationWriter);
var
  ErrorFound : boolean;
  ErrorMessage : string;
begin
  if ContinueExport then
  begin
    CurrentModelHandle := frmModflow.CurrentModelHandle;
    AlternateExportTemplate := frmModflow.cbAltSTR.Checked;
    DisWriter := DiscretizationWriter;
    Assert(DisWriter <> nil);
    EvaluateStreams(ErrorFound);
    if ErrorFound then
    begin
      frmProgress.reErrors.Lines.Add('Stream package error');
    end;
  end;
  MakeListOfSegments;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      +  ModflowTypes.GetMFStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
end;

procedure TStrWriter.WriteObservationFile(const Root : string);
var
  ObsFile : TStringList;
  FileName : string;
begin
  frmProgress.lblPackage.Caption := 'Stream Observation';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := StreamObservations.Count + 1;
  ObsFile := TStringList.Create;
  try
    FileName := GetCurrentDir + '\' + Root + rsStob;
    WriteObservationsDataSets1to5(ObsFile, FileName);

    WriteObservationsDataSets6and7(ObsFile);
    ObsFile.SaveToFile(FileName);
  finally
    ObsFile.Free;
  end;
end;

procedure TStrWriter.WriteFile(const Root : string;
  const DiscretizationWriter : TDiscretizationWriter);
var
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  FileName : string;
  Error, ErrorsFound: boolean;
begin
  Error := False;
  Evaluate(DiscretizationWriter);
  StressPeriodCount := frmModflow.dgTime.RowCount -1;
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := StressPeriodCount + 2;
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := 4;
  frmProgress.lblActivity.Caption := 'Writing Stream package file';
  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsSTR;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSets1and2;
      frmProgress.pbPackage.StepIt;
      WriteDataSets3and4(ErrorsFound);
      frmProgress.pbPackage.StepIt;
      Error := Error or ErrorsFound;
      for StressPeriodIndex := 1 to StressPeriodCount do
      begin
        frmProgress.pbActivity.Position := 0;

        WriteDataSets5To7(StressPeriodIndex, ErrorsFound);
        Error := Error or ErrorsFound;
        frmProgress.pbActivity.StepIt;

        WriteDataSet8(StressPeriodIndex);
        frmProgress.pbActivity.StepIt;

        WriteDataSet9(ErrorsFound, StressPeriodIndex = 1);
        Error := Error or ErrorsFound;
        frmProgress.pbActivity.StepIt;

        WriteDataSet10(ErrorsFound, StressPeriodIndex = 1);
        Error := Error or ErrorsFound;
        frmProgress.pbActivity.StepIt;

        frmProgress.pbPackage.StepIt;
      end;
      if Error then
      begin
        frmProgress.reErrors.Lines.Add('Errors or warnings in Stream package');
      end;
    finally
      begin
        CloseFile(FFile);
        Application.ProcessMessages;
      end;
    end;
  end;
end;

procedure TStrWriter.AddCells(const Segment: TStrSegment;
  const ContourIndex, UnitIndex: integer; const Layer: TLayerOptions;
  const Indicies : TStrParamIndicies;
  const TimeIndicies : array of TStrTimeParamIndicies);
var
  StreamReachRecord : TStrReachRecord;
  CellCount : integer;
  Top, Bottom : double;
  PreviousLength, ThisLength, TotalLength, TempLength, Fraction : double;
  Elevation : double;
  UpStreamElevation, DownStreamElevation : double;
  CellIndex : integer;
  X, Y: ANE_DOUBLE;
  ABlock: TBlockObjectOptions;
  BlockIndex: integer;
  Index: integer;
begin
  X := 0;
  Y := 0;
  TotalLength := GGetLineLength(ContourIndex);
  if TotalLength > 0 then
  begin
    UpStreamElevation := Segment.UpstreamBedElevation[0];
    DownStreamElevation := Segment.DownstreamBedElevation[0];
    TempLength := 0;
    PreviousLength := 0;
    CellCount := GGetCountOfACellList(ContourIndex);
    for CellIndex := 0 to CellCount -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      StreamReachRecord.Row := GGetCellRow(ContourIndex, CellIndex);
      StreamReachRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
      StreamReachRecord.ChannelLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);

      Top := DisWriter.Elevations[StreamReachRecord.Column-1,StreamReachRecord.Row-1,UnitIndex-1];
      Bottom := DisWriter.Elevations[StreamReachRecord.Column-1,StreamReachRecord.Row-1,UnitIndex];
      ThisLength := StreamReachRecord.ChannelLength;
      if CellIndex > 0 then
      begin
        TempLength := TempLength + PreviousLength;
      end;
      if CellIndex = 0 then
      begin
        fraction := 0;
      end
      else if CellIndex = CellCount -1 then
      begin
        fraction := 1;
      end
      else
      begin
        fraction := (TempLength + ThisLength/2)/TotalLength;
      end;
      PreviousLength := ThisLength;

      if AlternateExportTemplate then
      begin
        BlockIndex := DisWriter.BlockIndex(StreamReachRecord.Row-1,
          StreamReachRecord.Column-1);
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          DisWriter.GridLayerHandle, BlockIndex);
        try
          ABlock.GetCenter(CurrentModelHandle, X, Y);
        finally
          ABlock.Free;
        end;
        Elevation := Layer.RealValueAtXY(CurrentModelHandle, X, Y,
          TimeIndicies[0].TopElevName);
      end
      else
      begin
        Elevation := UpStreamElevation
          + (DownStreamElevation - UpStreamElevation)*fraction;
      end;

      StreamReachRecord.Layer := frmModflow.ModflowLayer
        (UnitIndex, Top, Bottom, Elevation);

      if AlternateExportTemplate then
      begin
        StreamReachRecord.HydraulicConductivity := Layer.RealValueAtXY(
          CurrentModelHandle, X, Y, Indicies.HydraulicConductivityName);
        SetLength(StreamReachRecord.StreamBedTop, Segment.UpstreamBedElevation.Count);
        SetLength(StreamReachRecord.StreamBedBottom, Segment.UpstreamBedBottom.Count);
        SetLength(StreamReachRecord.Stage, Segment.UpstreamStage.Count);
        SetLength(StreamReachRecord.Width, Segment.UpstreamWidth.Count);
        SetLength(StreamReachRecord.Slope, Segment.Slope.Count);
        SetLength(StreamReachRecord.Roughness, Segment.ChannelRoughness.Count);
        //StreamReachRecord.HydraulicConductivity := Segment.HydraulicConductivity;
        for Index := 0 to Segment.UpstreamBedElevation.Count -1 do
        begin
          StreamReachRecord.StreamBedTop[Index] := Layer.RealValueAtXY(
            CurrentModelHandle, X, Y, TimeIndicies[Index].TopElevName);
        end;
        for Index := 0 to Segment.UpstreamBedBottom.Count -1 do
        begin
          StreamReachRecord.StreamBedBottom[Index] := Layer.RealValueAtXY(
            CurrentModelHandle, X, Y, TimeIndicies[Index].BottomElevName);
        end;
        for Index := 0 to Segment.UpstreamStage.Count -1 do
        begin
          StreamReachRecord.Stage[Index] := Layer.RealValueAtXY(
            CurrentModelHandle, X, Y, TimeIndicies[Index].StageName);
        end;
        for Index := 0 to Segment.UpstreamWidth.Count -1 do
        begin
          StreamReachRecord.Width[Index] := Layer.RealValueAtXY(
            CurrentModelHandle, X, Y, TimeIndicies[Index].WidthName);
        end;
        for Index := 0 to Segment.Slope.Count -1 do
        begin
          StreamReachRecord.Slope[Index] := Layer.RealValueAtXY(
            CurrentModelHandle, X, Y, TimeIndicies[Index].SlopeName);
        end;
        for Index := 0 to Segment.ChannelRoughness.Count -1 do
        begin
          StreamReachRecord.Roughness[Index] := Layer.RealValueAtXY(
            CurrentModelHandle, X, Y, TimeIndicies[Index].RoughnessName);
        end;
      end;

      Segment.ReachList.Add(StreamReachRecord);
    end;
  end;
end;

procedure TStrWriter.AddParameters;
var
  Parameter : TStrParameterRecord;
  RowIndex, InstanceIndex : integer;
  ParameterObject : TStrParameterObject;
  ColIndex : integer;
  TimeIndex, TimeCount : integer;
  Active : boolean;
  AStringGrid : TStringGrid;
begin
  TimeCount := frmModflow.dgTime.RowCount -1;
  for RowIndex := 1 to frmModflow.dgSTRParametersN.RowCount -1 do
  begin
    Parameter.Name := UpperCase(frmModflow.dgSTRParametersN.Cells[0,RowIndex]);
    Parameter.Value := InternationalStrToFloat(frmModflow.dgSTRParametersN.
      Cells[2,RowIndex]);
    ParameterObject := ParameterList.Add(Parameter);
    AStringGrid := frmModflow.sg3dSTRParamInstances.Grids[RowIndex-1];
    for InstanceIndex := 1 to AStringGrid.RowCount -1 do
    begin
      ParameterObject.Instances.Add(AStringGrid.Cells[0,InstanceIndex]);
    end;
    for TimeIndex := 0 to TimeCount -1 do
    begin
      ColIndex := 4 + TimeIndex;
      Active := frmModflow.dgSTRParametersN.Cells[ColIndex,RowIndex]
        <> frmModflow.dgSTRParametersN.Columns[ColIndex].PickList[0];
      ParameterObject.Active[TimeIndex] := Active;
      ParameterObject.InstanceNamesUsed[TimeIndex]
        := frmModflow.dgSTRParametersN.Cells[ColIndex,RowIndex];
    end;
  end;
end;

procedure TStrWriter.WriteDataSet9(var ErrorFound : boolean;
  Const EvaluateErrors : boolean);
var
  OuterIndex, InnerIndex : integer;
  Segment, Tributary : TStrSegment;
  SegNumber, TribNumber : integer;
  ErrorMessage : string;
  StreamErrors : TStringList;
  ErrorInSegment : boolean;
begin
  if ITMP <= 0 then Exit;
  if NTRIB > 0 then
  begin
    StreamErrors := TStringList.Create;
    try
      ErrorFound := False;
      for OuterIndex := 0 to ListOfSegments.Count -1 do
      begin
        Segment := ListOfSegments[OuterIndex];
        SegNumber := Segment.Number;
        ErrorMessage := 'Errors in Segment ' + IntToStr(Segment.FNumber) + ': ';
        ErrorInSegment := False;
        for InnerIndex := 0 to Segment.Tributaries.Count - 1 do
        begin
          Tributary := Segment.Tributaries[InnerIndex];
          TribNumber := Tributary.Number;
          Write(FFile, Format(' %4.4u', [TribNumber]));
          if EvaluateErrors and (TribNumber >= SegNumber) then
          begin
            ErrorFound := True;
            ErrorInSegment := True;
            ErrorMessage := ErrorMessage + 'Error: Tributary Segment '
              + IntToStr(Tributary.FNumber) + ' is not a valid tributary '
              + 'because it has a higher number than the segment into '
              + 'which it should flow or because either it or '
               + IntToStr(Segment.FNumber) + ' is one of the segments '
              + 'in a parameter that includes segment numbers both higher and '
              + 'lower than a segment number in the other parameter.'
          end;

        end;
        for InnerIndex := Segment.Tributaries.Count to NTRIB -1 do
        begin
          Write(FFile, '    0');
        end;
        WriteLn(FFile);
        if ErrorInSegment then
        begin
          StreamErrors.Add(ErrorMessage);
        end;
      end;
      if ErrorFound then
      begin
        ErrorMessages.Add('');
        ErrorMessages.Add('Stream package tributary error messages');
        ErrorMessages.Add('');
        ErrorMessages.AddStrings(StreamErrors);
      end;

    finally
      StreamErrors.Free;
    end;
  end;
end;

procedure TStrWriter.WriteDataSet10(var ErrorFound : boolean;
  Const EvaluateErrors : boolean);
var
  Index : integer;
  Segment : TStrSegment;
  DivSegNumber : integer;
  StreamErrors : TStringList;
begin
  if ITMP <= 0 then Exit;
  ErrorFound := False;
  if NDIV > 0 then
  begin
    StreamErrors := TStringList.Create;
    try
      for Index := 0 to ListOfSegments.Count -1 do
      begin
        Segment := ListOfSegments[Index];
        DivSegNumber := Segment.DiversionSegment;
        Writeln(FFile, Format(' %9.9u', [DivSegNumber]));
        if EvaluateErrors and (DivSegNumber >= Segment.Number) then
        begin
          StreamErrors.Add('In segment ' + IntToStr(Segment.FNumber)
            + ', the upstream segment from which flow is to be diverted '
            + 'is invalid because it either has a higher number or because '
            + 'it is one of the segments of a parameter that has segments '
            + 'both upstream and downstream of the current segment.');
        end;
      end;
      if StreamErrors.Count > 0 then
      begin
        ErrorFound := True;
        ErrorMessages.Add('');
        ErrorMessages.Add('Diversion errors in stream package.');
        ErrorMessages.Add('');
        ErrorMessages.AddStrings(StreamErrors);
      end;

    finally
      StreamErrors.Free;
    end;
  end;
end;

procedure TStrWriter.GetStreamObservationTimeParameterValues(
  const Indicies: TStrObservationTimeParamIndicies;
  const Segment: TStrSegment; const Contour: TContourObjectOptions;
  const TimeIndex: integer);
var
 ObservationName : string;
 InvalidName : string;
 Index : integer;
begin
  Segment.IsPrediction[TimeIndex] := Contour.GetBoolParameter(CurrentModelHandle,
    Indicies.IsPredictionParamIndex);

  Segment.IsObservation[TimeIndex] := Contour.GetBoolParameter(CurrentModelHandle,
    Indicies.IsObservationParamIndex);

  Segment.ObservationTimes.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.TimeParamIndex));

  Segment.ReferenceStressPeriod.Add(Contour.GetIntegerParameter(CurrentModelHandle,
    Indicies.ReferenceStressPeriodIndex));

  Segment.ObservationLoss.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.LossParamIndex));

  Segment.ObservationStatistic.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.StatisticParamIndex));

  if Indicies.ObservationNumberIndex >= 0 then
  begin
    Segment.ObservationNumbers.Add(Contour.
      GetIntegerParameter(CurrentModelHandle,
      Indicies.ObservationNumberIndex));
  end;

  InvalidName := ModflowTypes.GetMFObservationNameParamType.PermValue;
  for Index := 1 to Length(InvalidName) do
  begin
    if InvalidName[Index] = '"' then
    begin
      InvalidName[Index] := ' '
    end
  end;

  InvalidName := Trim(InvalidName);

  ObservationName := Contour.GetStringParameter
    (CurrentModelHandle, Indicies.ObservationNameParamIndex);
  if (ObservationName = '0') or (ObservationName = InvalidName) then
  begin
    ObservationName := '';
  end;
  ObservationName := Trim(ObservationName);
  if Length(ObservationName) > 12 then
  begin
    SetLength(ObservationName, 12);
  end;
  ObservationName := Trim(ObservationName);
  Segment.ObservationNames.Add(ObservationName);
end;

procedure TStrWriter.WriteObservationsDataSets3to5
  (const ObsFile : TStringList);
var
  Index : integer;
  OBSNAM : string; //
  TOFFSET : double;
  HOBS : double;
  STATISTIC : double;
  IREFSP : integer;
  STATFLAG : integer; //
  PLOTSYMBOL : integer; //
  Observation : TStreamObservation;
  Segment : TStrSegment;
  SegmentIndex : integer;
  ObsIndex : integer;
  Use : boolean;
  ALine : string;
  NQOBST, NQCLST : integer;
  Reaches : TStringList;
  ObsFileLocal : TStringList;
  AName: string;
  Position : integer;
begin
  frmProgress.lblActivity.Caption := 'Writing observations';
  frmProgress.pbActivity.Position := 0;
  ObsFile.Clear;
  Reaches := TStringList.Create;
  ObsFileLocal := TStringList.Create;
  try
    for Index := 0 to StreamObservations.Count - 1 do
    begin
      OBSNAM := StreamObservations[Index];
      Observation := StreamObservations.Objects[Index] as TStreamObservation;
      ObservationIndicies.Add(Observation.ObservationNumber);
      ObsFileLocal.Clear;
      if Observation.Segments.Count > 0 then
      begin
        Segment := Observation.Segments[0];
        ObsIndex := Segment.ObservationNames.IndexOf(OBSNAM);
        Use := Segment.Use(ObsIndex);

        if Use then
        begin
          Inc(NQST);

          AName := Trim(OBSNAM);
          Position := Pos(' ', AName);
          while (Position > 0) do
          begin
            AName[Position] := '_';
            Position := Pos(' ', AName);
          end;
          AddObservationName(AName);
          AName := '''' + AName + ''' ';

          STATFLAG := Segment.StatFlag;
          PLOTSYMBOL := Segment.PlotSymbol;
          IREFSP := Segment.ReferenceStressPeriod[ObsIndex];
          TOFFSET := Segment.ObservationTimes[ObsIndex];
          HOBS := Segment.ObservationLoss[ObsIndex];
          STATISTIC := Segment.ObservationStatistic[ObsIndex];
          ALine := AName
            + IntToStr(IREFSP) + ' '
            + InternationalFloatToStr(TOFFSET) + ' '
            + InternationalFloatToStr(HOBS) + ' '
            + InternationalFloatToStr(STATISTIC) + ' '
            + IntToStr(STATFLAG) + ' '
            + IntToStr(PLOTSYMBOL);
          ObsFileLocal.Add(ALine);

          Reaches.Clear;
          for SegmentIndex := 0 to Observation.Segments.Count -1 do
          begin
            Segment := Observation.Segments[SegmentIndex];
            Segment.ReachList.WriteObservation(Reaches);
          end;
          NQOBST := 1;
          NQCLST := Reaches.Count;
          NQCST := NQCST + NQCLST;
          NQTST := NQTST + NQOBST;
          ObsFile.Add(IntToStr(NQOBST) + ' ' + IntToStr(NQCLST));
          ObsFile.AddStrings(ObsFileLocal);
          ObsFile.AddStrings(Reaches);
        end;

      end;
      frmProgress.pbPackage.StepIt;
    end;
  finally
    Reaches.Free;
    ObsFileLocal.Free;
  end;
end;

procedure TStrWriter.WriteObservationsDataSet6(const ObsFile : TStringList);
var
  IPRN : integer;
  Line : string;
begin
  IPRN := frmModflow.comboStreamObsPrintFormats.ItemIndex + 1;
  Line := '(' + IntToStr(NQST) + 'F21.0) ' + IntToStr(IPRN);
  ObsFile.Add(Line);
end;

procedure TStrWriter.WriteObservationsDataSet7(const ObsFile : TStringList);
var
  RowIndex, ColIndex : integer;
  Row, Col : integer;
  AStringGrid : TStringGrid;
  Observation : TStreamObservation;
  ObsIndex : integer;
  Statistic : double;
  ALine : string;
  Segment : TStrSegment;
  function UseObservation(Index : integer) : boolean;
  var
    OBSNAM : string;
  begin
    result := False;
    OBSNAM := StreamObservations[Index];
    Observation := StreamObservations.Objects[Index] as TStreamObservation;
    if Observation.Segments.Count > 0 then
    begin
      Segment := Observation.Segments[0];
      ObsIndex := Segment.ObservationNames.IndexOf(OBSNAM);
      result := Segment.Use(ObsIndex);
    end;
  end;
begin
  if NQST > 0 then
  begin
    frmProgress.pbActivity.Max := Sqr(NQST);
    frmProgress.pbActivity.Position := 0;
    frmProgress.lblActivity.Caption := 'Writing variance-covariance matrix';
    Application.ProcessMessages;
    AStringGrid := frmMODFLOW.dgSTRObsBoundCovariances;
    for ColIndex := 1 to StreamObservations.Count do
    begin
      If ContinueExport and UseObservation(ColIndex -1) then
      begin
        ALine := '';
        Col := ObservationIndicies[ColIndex-1];
        for RowIndex := 1 to StreamObservations.Count do
        begin
          If ContinueExport and UseObservation(RowIndex -1) then
          begin
            Row := ObservationIndicies[RowIndex-1];
            if (Col < 1) or (Row < 1)
              or (Col > AStringGrid.ColCount-1)
              or (Row > AStringGrid.RowCount-1) then
            begin
              if ColIndex = RowIndex then
              begin
                Statistic := Segment.ObservationStatistic[ObsIndex];
                ALine := ALine + FreeFormattedReal(Statistic);
              end
              else
              begin
                ALine := ALine + FreeFormattedReal(0.0);
              end;
            end
            else
            begin
              ALine := ALine + FreeFormattedReal(InternationalStrToFloat(AStringGrid.Cells[Col,Row]));
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
          end;
        end;
        ObsFile.Add(ALine);
      end;
    end;
  end;
  frmProgress.pbPackage.StepIt;
end;

procedure TStrWriter.WriteObservationsDataSets1to5(
  const ObsFile: TStringList; const FileName : string);
var
  DataSet0 : string;
  DataSet1 : string;
  DataSet2 : string;
  EVFST : double;
  IOWTQST : integer;
begin
  WriteObservationsDataSets3to5(ObsFile);

  DataSet0 := '# Data read from ' + FileName;
  DataSet1 := IntToStr(NQST) + ' ' +
    IntToStr(NQCST) + ' ' + IntToStr(NQTST);
  EVFST := InternationalStrToFloat(frmMODFLOW.adeStrObsErrMult.Text);
  if frmMODFLOW.cbSpecifyStreamCovariances.Checked then
  begin
    IOWTQST := 1;
  end
  else
  begin
    IOWTQST := 0;
  end;
  DataSet2 := '1. ' + FreeFormattedReal(EVFST) + IntToStr(IOWTQST);

  ObsFile.Insert(0,DataSet0);
  ObsFile.Insert(1,DataSet1);
  ObsFile.Insert(2,DataSet2);
end;

procedure TStrWriter.WriteObservationsDataSets6and7(
  const ObsFile: TStringList);
begin
  if frmMODFLOW.cbSpecifyStreamCovariances.Checked then
  begin
    WriteObservationsDataSet6(ObsFile);
    WriteObservationsDataSet7(ObsFile);
  end;
end;

function TStrWriter.HydmodCount : integer;
var
  Index : integer;
  Segment : TStrSegment;
begin
  result := 0;
  for Index := 0 to ListOfSegments.Count - 1 do
  begin
    Segment := ListOfSegments[Index];

    if Segment.HydmodStageObservation then
    begin
      result := result + Segment.ReachList.Count;
    end;
    if Segment.HydmodFlowInObservation then
    begin
      result := result + Segment.ReachList.Count;
    end;
    if Segment.HydmodFlowOutObservation then
    begin
      result := result + Segment.ReachList.Count;
    end;
    if Segment.HydmodFlowIntoAquiferObservation then
    begin
      result := result + Segment.ReachList.Count;
    end;
  end;
end;


procedure TStrWriter.WriteHydmod(const HydmodWriter: TListWriter);
var
  Index : integer;
  Segment : TStrSegment;
begin
  for Index := 0 to ListOfSegments.Count - 1 do
  begin
    Segment := ListOfSegments[Index];
    Segment.WriteHydmod(HydmodWriter);
  end;
end;

procedure TStrWriter.WriteMT3DConcentrations(const StressPeriod: integer;
  const Lines: TStrings);
var
  NP : integer;
  Index : integer;
  AParameter : TStrParameterObject;
  ActiveParameters : TList;
  Segment : TStrSegment;
begin
  NP := 0;
  ActiveParameters := TList.Create;
  try
    if ParameterList.Count > 0 then
    begin
      for Index := 0 to ParameterList.Count -1 do
      begin
        AParameter := ParameterList.Items[Index] as TStrParameterObject;
        Assert(StressPeriod <= Length(AParameter.Active));
        if AParameter.Active[StressPeriod-1] then
        begin
          Inc(NP);
          ActiveParameters.Add(AParameter);
        end;
      end;
      ITMP := NP;
    end
    else
    begin
      if (StressPeriod = 1) or (frmModflow.comboStreamOption.ItemIndex = 1) then
      begin
        ITMP := 0;
        for Index := 0 to SegmentList.Count - 1 do
        begin
          Segment := SegmentList[Index] as TStrSegment;
          if Segment.Active[StressPeriod-1] then
          begin
            ITMP := ITMP + Segment.ReachList.Count;
          end;
        end;
      end
      else
      begin
        ITMP := -1;
      end;
    end;
    // Data Set 5
    if ParameterList.Count = 0 then
    begin
      // Data Set 6
      if ITMP > 0 then
      begin
        SegmentList.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    end
    else
    begin
      // Data Set 7
      for Index := 0 to ActiveParameters.Count -1 do
      begin
        AParameter := ActiveParameters[Index];
        AParameter.SegmentList.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    end;
  finally
    ActiveParameters.Free;
  end;
end;

class procedure TStrWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowSTR.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      frmModflow.GetUnitNumber('BSt1Unit')
    end;
  end;

  if frmModflow.cbFlowSTR2.Checked then
  begin
      frmModflow.GetUnitNumber('BSt2Unit')
  end;
end;

{ TStrParameterList }

function TStrParameterList.Add(
  Parameter: TStrParameterRecord): TStrParameterObject;
begin
  result := TStrParameterObject.Create;
  result.Name := Parameter.Name;
  result.Value := Parameter.Value;
  inherited Add(result);
end;

function TStrParameterList.GetParameterByName(
  Name: string): TStrParameterObject;
var
  Index : integer;
  ParameterObject : TStrParameterObject;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ParameterObject := Items[Index] as TStrParameterObject;
    if ParameterObject.Name = Name then
    begin
      result := ParameterObject;
      Exit;
    end;
  end;
end;

procedure TStrParameterList.Write(StreamWriter: TStrWriter; var ErrorFound : boolean);
var
  Index : integer;
  StreamParameter : TStrParameterObject;
  Error : boolean;
begin
  ErrorFound := False;
  for Index := 0 to Count -1 do
  begin
    StreamParameter := Items[Index] as TStrParameterObject;
    StreamParameter.Write(StreamWriter,Error);
    ErrorFound := ErrorFound or Error;
  end;
end;

{ TStreamObservation }

constructor TStreamObservation.Create;
begin
  inherited;
  Segments := TList.Create;
  ObservationNumber := 0;
end;

destructor TStreamObservation.Destroy;
begin
  Segments.Free;
  inherited;
end;

{ TStrReachObject }

function TStrReachObject.GetCol: integer;
begin
  result := Reach.Column;
end;

function TStrReachObject.GetLayer: integer;
begin
  result := Reach.Layer;
end;

function TStrReachObject.GetRow: integer;
begin
  result := Reach.Row;
end;

procedure TStrReachObject.WriteMT3DConcentrations(const Lines: TStrings;
  const Concentration: string);
var
  ALine : string;
begin
  ALine := TModflowWriter.FixedFormattedInteger(Reach.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Reach.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Reach.Column, 10)
    + Concentration;
  Lines.Add(ALine);
end;

end.
