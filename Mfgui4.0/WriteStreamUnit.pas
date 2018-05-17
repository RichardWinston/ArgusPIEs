unit WriteStreamUnit;

{
  Write the input for the SFR package.
}

interface

uses Sysutils, classes, contnrs, Forms, AnePIE, WriteModflowDiscretization,
  OptionsUnit, IntListUnit, RealListUnit, WriteLakesUnit;

const
  MaxCrossSectionPts = 8;

type
  TStreamReachRecord = record
    Layer: integer;
    Row: integer;
    Column: integer;
    ChannelLength: double;
    // SFR2 variables
    StreambedTop: double;
    Slope: double;
    StreambedThickness: double;
    StreambedHydraulicConductivity: double;
    SaturatedWaterContent: double;
    InitialWaterContent: double;
    BrooksCoreyExponent: double;
    UnsatZoneHydraulicConductivity: double;
  end;

  TStreamParamIndicies = record
    ParameterNameIndex: ANE_INT32;
    IsParameterIndex: ANE_INT32;
    IsGageIndex: ANE_INT32;
    GageOutputTypeIndex: ANE_INT32;
    DiversionGageIndex: ANE_INT32;
    UnsatFlowIndex: ANE_INT32;
    UnsatFlowProfileIndex: ANE_INT32;
    SegmentNumberIndex: ANE_INT32;
    DownstreamSegmentNumberIndex: ANE_INT32;
    DiversionSegmentNumberIndex: ANE_INT32;
    UpstreamKIndex: ANE_INT32;
    DownstreamKIndex: ANE_INT32;
    StreamPriorityIndex: ANE_INT32;
    //sfr2
    StreamTopName: string;
    StreamSlopeName: string;
    StreamBedThicknessName: string;
    StreamHydraulicConductivityName: string;
    StreamSaturatedWaterContentName: string;
    StreamInitialWaterContentName: string;
    StreamBrooksCoreyName: string;
    StreamUnsatZoneHydraulicConductivityName: string;
    // isfropt = 4 or 5
//    StreamUpTopElevParamIndex: ANE_INT32;
//    DownstreamTopElevationParamIndex: ANE_INT32;
//    UpstreamBedThicknessParamIndex: ANE_INT32;
//    DownstreamBedThicknessParamIndex: ANE_INT32;

    UpstreamSaturatedWaterContentParamIndex: ANE_INT32;
    DownstreamSaturatedWaterContentParamIndex: ANE_INT32;
    UpstreamInitialWaterContentParamIndex: ANE_INT32;
    DownstreamInitialWaterContentParamIndex: ANE_INT32;
    UpstreamBrooksCoreyExponentParamIndex: ANE_INT32;
    DownstreamBrooksCoreyExponentParamIndex: ANE_INT32;
    UpstreamUnsatZoneHydraulicConductivityParamIndex: ANE_INT32;
    DownstreamUnsatZoneHydraulicConductivityParamIndex: ANE_INT32;
  end;

  TStreamTimeParamIndicies = record
    OnOffParamIndex: ANE_INT32;
    StreamFlowParamIndex: ANE_INT32;
    StreamUpTopElevParamIndex: ANE_INT32;
    DownstreamTopElevationParamIndex: ANE_INT32;
    UpstreamBedThicknessParamIndex: ANE_INT32;
    DownstreamBedThicknessParamIndex: ANE_INT32;
    ETExtFluxParamIndex: ANE_INT32;
    PrecipitationParamIndex: ANE_INT32;
    RunoffParamIndex: ANE_INT32;
    IFACEParamIndex: ANE_INT32;
    FlowConcentrationParamIndex: ANE_INT32;
    PrecipitationConcentrationParamIndex: ANE_INT32;
    RunoffConcentrationParamIndex: ANE_INT32;
    // SFR2
{    UpstreamSaturatedWaterContentParamIndex: ANE_INT32;
    DownstreamSaturatedWaterContentParamIndex: ANE_INT32;
    UpstreamInitialWaterContentParamIndex: ANE_INT32;
    DownstreamInitialWaterContentParamIndex: ANE_INT32;
    UpstreamBrooksCoreyExponentParamIndex: ANE_INT32;
    DownstreamBrooksCoreyExponentParamIndex: ANE_INT32;
    UpstreamUnsatZoneHydraulicConductivityParamIndex: ANE_INT32;
    DownstreamUnsatZoneHydraulicConductivityParamIndex: ANE_INT32;  }
  end;

  TSimpleStreamTimeParamIndicies = record
    UpsteamDepthIndex: ANE_INT32;
    DownstreamDepthIndex: ANE_INT32;
    UpstreamWidthIndex: ANE_INT32;
    DownstreamWidthIndex: ANE_INT32;
    RoughnessIndex: ANE_INT32;
  end;

  TCrossSectionParamIndicies = record
    XIndex: ANE_INT32;
    ZIndex: ANE_INT32;
  end;

  TCrossSectionTimeParamIndicies = record
    ChannelRoughnessIndex: ANE_INT32;
    BankRoughnessIndex: ANE_INT32;
  end;

  TTableParamIndicies = record
    FlowIndex: ANE_INT32;
    WidthIndex: ANE_INT32;
    DepthIndex: ANE_INT32;
  end;

  TFormulaTimeParamIndicies = record
    DepthCoefficientIndex: ANE_INT32;
    WidthCoefficientIndex: ANE_INT32;
    DepthExponentIndex: ANE_INT32;
    WidthExponentIndex: ANE_INT32;
  end;

  TConcentrationRecord = record
    InflowConcentration: double; // CONCQ
    RunoffConcentration: double; // CONCRUN
    PrecipitationConcentration: double; // CONCPPT
  end;

  TStreamReachObject = class(TObject)
    Reach: TStreamReachRecord;
  end;

  TSegment = class;
  TStreamWriter = class;

  TStreamReachList = class(TObjectList)
  private
    Segment: TSegment;
    function GetItems(Index: Integer): TStreamReachObject;
    procedure SetItems(Index: Integer; const Value: TStreamReachObject);
    function Add(StreamReach: TStreamReachRecord): TStreamReachObject; overload;
    property Items[Index: Integer]: TStreamReachObject read GetItems
    write SetItems; default;
    procedure Write(StreamWriter: TStreamWriter;
      SlopeErrors, ThicknessErrors: TStringList);
    constructor Create(const Segment: TSegment);
  end;

  TFlowTableRecord = record
    Flow: double;
    Depth: double;
    Width: double;
  end;

  TFlowTableEntry = class(TObject)
    Flow: TFlowTableRecord;
  end;

  TFlowTableList = class(TObjectList)
    function Add(FlowRecord: TFlowTableRecord): integer;
  end;

  TConcentrationEntry = class(TObject)
    Conc: TConcentrationRecord; //
  end;

  TConcentrationList = class(TObjectList)
    function Add(Concentrations: TConcentrationRecord): Integer;
  end;

  TSegment = class(TObject)
  private
    Active: array of boolean;
    // Data Sets 4A and 6A
    ICALC: integer;
    DiversionPriority: integer; // IPRIOR
    Flow: TRealList;
    RunOff: TRealList;
    Evaporation: TRealList; // ETSW
    Precipitation: TRealList; // PPTSW
    ChannelRoughness: TRealList; // ROUGHCH
    OverBankRoughness: TRealList; // ROUGHBK
    DepthCoefficient: TRealList; // ADPTH
    DepthExponent: TRealList; // BDPTH
    WidthCoefficient: TRealList; // AWDTH
    WidthExponent: TRealList; // BWDTH
    // Data Sets 4B and 6B
    UpstreamK: double; // Hc1fact, HCOND1
    UpstreamBedThickness: TRealList; // THICKM1
    UpstreamBedElevation: TRealList; // ELEVUP
    UpstreamWidth: TRealList; // WIDTH1
    UpstreamDepth: TRealList; // DEPTH1
    // Data Sets 4C and 6C
    DownstreamK: double; // Hc2fact, HCOND2
    DownstreamBedThickness: TRealList; // THICKM2
    DownstreamBedElevation: TRealList; // ELEVdn
    DownstreamWidth: TRealList; // WIDTH2
    DownstreamDepth: TRealList; // DEPTH2
    IFACE: TIntegerList;
    // SFR2 6B
    UpstreamSaturatedWaterContent: double;
    UpstreamInitialWaterContent: double;
    UpstreamBrooksCoreyExponent: double;
    UpstreamUnsatZoneHydraulicConductivity: double;
    // SFR2 6C
    DownstreamSaturatedWaterContent: double;
    DownstreamInitialWaterContent: double;
    DownstreamBrooksCoreyExponent: double;
    DownstreamUnsatZoneHydraulicConductivity: double;

    // Data Sets 4D and 6D
    CrossSection: array[1..2, 1..MaxCrossSectionPts] of double;
      // XCPT1, XCPT2 ... XCPT8, ZCPT1, ZCPT2 ... ZCPT8
    // Data Sets 4E and 6E
    FlowTableList: TFlowTableList; // Count = NSTRPTS in 4A and 6A
    // Data Set 4F and 6F
    ConcentrationList: TConcentrationList;
    ReachList: TStreamReachList;
    FNumber: integer; // NSEG
    FOutflowSegment: integer; // OUTSEG
    FDiversionSegment: integer; // IUPSEG
    StreamWriter: TStreamWriter;
    IsGage: boolean;
    GageOutputType: integer;
    GageDiversion: boolean;
    GageUnsatFlow: boolean;
    GageUnsatProfile: boolean;
    DiversionErrors: TStringList;
    function GetNumber: integer;
    function GetOutflowSegment: integer;
    function GetDiversionSegment: integer;
    function GetSegmentByNumber(const SegmentNumber: integer): TSegment;
    function GetReach(Index: integer): TStreamReachObject;
    property OutflowSegment: integer read GetOutflowSegment;
    property DiversionSegment: integer read GetDiversionSegment;
    function ValuesAreValid(var ErrorMessage: string;
      const TimeIndex: integer): boolean;
    procedure WriteSegment(const StreamWriter: TStreamWriter;
      const TimeIndex: integer; const IsParam: boolean);
    procedure WriteSegmentA(StreamWriter: TStreamWriter;
      const TimeIndex: integer);
    procedure WriteSegmentB(const StreamWriter: TStreamWriter;
      const TimeIndex: integer; const IsParam: boolean);
    procedure WriteSegmentC(const StreamWriter: TStreamWriter;
      const TimeIndex: integer; const IsParam: boolean);
    procedure WriteSegmentD(const StreamWriter: TStreamWriter);
    procedure WriteSegmentE(const StreamWriter: TStreamWriter);
    procedure WriteSegmentF(const StreamWriter: TStreamWriter;
      const TimeIndex: integer);
    function ShouldWriteHydraulicConductivity(const IsParam: boolean;
      const StreamWriter: TStreamWriter): boolean;
    function ShouldWriteThicknessAndElevation(const IsParam: boolean;
      const StreamWriter: TStreamWriter;
      const TimeIndex: integer): boolean;
    function ShouldWriteWidth(const IsParam: boolean;
      const StreamWriter: TStreamWriter; const TimeIndex: integer): boolean;
    function ShouldWriteDepth: boolean;
    function ShouldWriteUnsaturatedProperties(const IsParam: boolean;
      const StreamWriter: TStreamWriter): boolean;
  public
    property UserAssignedNumber: integer read FNumber;
    function ReachCount: integer;
    property Reaches[Index: integer]: TStreamReachObject read GetReach;
    constructor Create;
    destructor Destroy; override;
    property Number: integer read GetNumber;
  end;

  TSegmentList = class(TObjectList)
    procedure Write(const StreamWriter: TStreamWriter;
      const TimeIndex: integer; var ErrorsFound: boolean; const IsParam: boolean);
  end;

  TStreamParameterRecord = record
    Name: ShortString;
    Value: double;
  end;

  TStreamParameterObject = class(TObject)
  private
    FName: ShortString;
    Value: double;
    SegmentList: TSegmentList;
    Active: array of boolean;
    Instances: TStringList;
    procedure SetName(const Value: ShortString);
    property Name: ShortString read FName write SetName;
    procedure Write(StreamWriter: TStreamWriter; var ErrorsFound: boolean);
    procedure SortTheSegments;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TStreamParameterList = class(TObjectList)
  private
    function Add(Parameter: TStreamParameterRecord): TStreamParameterObject;
    procedure Write(StreamWriter: TStreamWriter; var ErrorFound: boolean);
    function GetParameterByName(Name: string): TStreamParameterObject;
  public
  end;

  TStreamWriter = class(TListWriter)
  private
    CurrentModelHandle: ANE_PTR;
    ParameterList: TStreamParameterList;
    SegmentList: TSegmentList;
    DisWriter: TDiscretizationWriter;
    ListOfSegments: TList;
    LakeWriter: TLakeWriter;
    EightPointStreamErrors, FormulaStreamErrors: integer;
    SimpleStreamErrors, TableStreamErrors: integer;
    InvalidParameters: TStringList;
    ISFROPT: integer;
    NSTRM: integer;
    procedure AddParameters;
    procedure GetStreamParameterIndicies(const Layer: TLayerOptions;
      var Indicies: TStreamParamIndicies; const IsUnsatLayer: boolean);
    procedure GetStreamTimeParameterIndicies(const Layer: TLayerOptions;
      var Indicies: TStreamTimeParamIndicies; const TimeIndex: integer);
    procedure GetStreamICALC_Index(const Layer: TLayerOptions;
      var ICALC_Index: ANE_INT32);
    procedure GetSimpleStreamTimeParameterIndicies(const Layer: TLayerOptions;
      var Indicies: TSimpleStreamTimeParamIndicies; const TimeIndex: integer);
    procedure GetStreamSegmentValues(const Indicies: TStreamParamIndicies;
      const Segment: TSegment; const Contour: TContourObjectOptions);
    procedure GetSimpleStreamSegmentICALC(const ICALC_Index: ANE_INT32;
      const Segment: TSegment; const Contour: TContourObjectOptions);
    procedure GetStreamTimeParameterValues(
      const Indicies: TStreamTimeParamIndicies;
      const Segment: TSegment;
      const Contour: TContourObjectOptions;
      const TimeIndex: integer);
    procedure GetSimpleStreamTimeParameterValues(
      const Indicies: TSimpleStreamTimeParamIndicies;
      const Segment: TSegment;
      const Contour: TContourObjectOptions);
    procedure AddCells(const Segment: TSegment;
      const ContourIndex, UnitIndex: integer; const Layer: TLayerOptions;
      const Indicies: TStreamParamIndicies);
    procedure EvaluateSimpleStreamLayer(const UnitIndex: integer; out ContourCount: integer);
    function ComputeStreamConstant: double;
    procedure WriteDataSets1and2;
    procedure WriteDataSets3and4(var ErrorsFound: boolean);
    procedure WriteDataSets5To7(StressPeriod: integer;
      var ErrorsFound: boolean);
    procedure Evaluate8PointCrossSectionStreamLayer(const UnitIndex: integer;
      out ContourCount: integer);
    procedure GetChannelRoughnessIndex(const Layer: TLayerOptions;
      var RoughnessIndex: ANE_INT32; const TimeIndex: integer);
    procedure GetChannelRoughness(const RoughnessIndex: ANE_INT32;
      const Segment: TSegment; const Contour: TContourObjectOptions);
    procedure GetCrossSectionParameterIndicies(const Layer: TLayerOptions;
      var Indicies: TCrossSectionParamIndicies;
      const PositionIndex: integer);
    procedure GetCrossSectionParameterValues(
      const Indicies: TCrossSectionParamIndicies;
      const Segment: TSegment;
      const Contour: TContourObjectOptions;
      const PositionIndex: integer);
    procedure EvaluateFormulaStreamLayer(const UnitIndex: integer;
      out ContourCount: integer);
    procedure GetFormulaTimeParameterIndicies(const Layer: TLayerOptions;
      var Indicies: TFormulaTimeParamIndicies; const TimeIndex: integer);
    procedure GetFormulaTimeParameterValues(
      const Indicies: TFormulaTimeParamIndicies; const Segment: TSegment;
      const Contour: TContourObjectOptions);
    procedure EvaluateTableStreamLayer(const UnitIndex: integer;
      out ContourCount: integer);
    procedure GetTableParameterIndicies(const Layer: TLayerOptions;
      var Indicies: TTableParamIndicies; const PositionIndex: integer);
    procedure GetTableParameterValues(const Indicies: TTableParamIndicies;
      const Segment: TSegment; const Contour: TContourObjectOptions);
    procedure EvaluateStreamUnits(const UnitIndex: integer; var LayerTypeError: boolean);
    procedure GetChannelTimeParameterIndecies(const Layer: TLayerOptions;
      var Indicies: TCrossSectionTimeParamIndicies;
      const TimeIndex: integer);
    procedure GetChannelTimeValues(
      const Indicies: TCrossSectionTimeParamIndicies;
      const Segment: TSegment; const Contour: TContourObjectOptions);
    procedure MakeListOfSegments(out NPARSEG: integer);
    procedure EvaluateGages;
    procedure AssignGageParametersToSegment(
      const Contour: TContourObjectOptions; const Segment: TSegment;
      const Indicies: TStreamParamIndicies);
    function GetSegment(Index: integer): TSegment;
  public
    procedure Evaluate(const DiscretizationWriter: TDiscretizationWriter;
      const ALakeWriter: TLakeWriter);
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(const Root: string;
      const DiscretizationWriter: TDiscretizationWriter;
      const ALakeWriter: TLakeWriter);
    procedure InitializeGages(
      const DiscretizationWriter: TDiscretizationWriter;
      const ALakeWriter: TLakeWriter);
    function ConvertSegmentNumber(OriginalSegmentNumber: integer): integer;
    class procedure AssignUnitNumbers;
    function SegmentCount: integer;
    property Segments[Index: integer]: TSegment read GetSegment;
  end;

implementation

uses Math, ProgressUnit, GetCellUnit, BL_SegmentUnit, GetFractionUnit,
  ModflowLayerFunctions, Variables, WriteNameFileUnit, WriteGageUnit,
  UtilityFunctions;

function SortSegments(Item1, Item2: Pointer): Integer;
Var
  Seg1, Seg2 : TSegment;
begin
  Seg1 := Item1;
  Seg2 := Item2;
  result := Seg1.FNumber - Seg2.FNumber;
end;

{ TSegment }

constructor TSegment.Create;
var
  TimeCount: integer;
begin
  inherited;
  DiversionErrors := TStringList.Create;
  FlowTableList := TFlowTableList.Create;
  ConcentrationList := TConcentrationList.Create;
  ReachList := TStreamReachList.Create(self);
  Flow := TRealList.Create;
  Evaporation := TRealList.Create;
  Precipitation := TRealList.Create;
  ChannelRoughness := TRealList.Create;
  OverBankRoughness := TRealList.Create;
  DepthCoefficient := TRealList.Create;
  DepthExponent := TRealList.Create;
  WidthCoefficient := TRealList.Create;
  WidthExponent := TRealList.Create;
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(Active, TimeCount);

  UpstreamBedThickness := TRealList.Create;
  UpstreamBedElevation := TRealList.Create;
  UpstreamWidth := TRealList.Create;
  UpstreamDepth := TRealList.Create;
  DownstreamBedThickness := TRealList.Create;
  DownstreamBedElevation := TRealList.Create;
  DownstreamWidth := TRealList.Create;
  DownstreamDepth := TRealList.Create;
  IFACE := TIntegerList.Create;
  RunOff := TRealList.Create;
end;

destructor TSegment.Destroy;
begin
  DiversionErrors.Free;
  Flow.Free;
  FlowTableList.Free;
  ConcentrationList.Free;
  ReachList.Free;
  Evaporation.Free;
  Precipitation.Free;
  ChannelRoughness.Free;
  OverBankRoughness.Free;
  DepthCoefficient.Free;
  DepthExponent.Free;
  WidthCoefficient.Free;
  WidthExponent.Free;
  UpstreamBedThickness.Free;
  UpstreamBedElevation.Free;
  UpstreamWidth.Free;
  UpstreamDepth.Free;
  DownstreamBedThickness.Free;
  DownstreamBedElevation.Free;
  DownstreamWidth.Free;
  DownstreamDepth.Free;
  IFACE.Free;
  RunOff.Free;
  inherited;
end;

function TSegment.GetDiversionSegment: integer;
var
  ASegment: TSegment;
begin
  if FDiversionSegment = 0 then
  begin
    result := 0;
  end
  else if FDiversionSegment > 0 then
  begin
    ASegment := GetSegmentByNumber(FDiversionSegment);
    //    Assert(ASegment <> nil);
    if ASegment = nil then
    begin
      DiversionErrors.Add('In Segment number ' + IntToStr(FNumber)
        + ', an invalid diversion segment number of '
        + IntToStr(FDiversionSegment) + ' was specified.');
      result := 0;
      Exit;
    end;
    result := ASegment.Number;
  end
  else
  begin
    Assert((StreamWriter <> nil) and (StreamWriter.LakeWriter <> nil));
    result := -StreamWriter.LakeWriter.MFLakeNumber(-FDiversionSegment);
    if result = 0 then
    begin
      DiversionErrors.Add('In Segment number ' + IntToStr(FNumber)
        + ', an invalid diversion segment number of '
        + IntToStr(FDiversionSegment) + ' was specified.');
    end;
    //    Assert(result <> 0);
  end;
end;

function TSegment.GetNumber: integer;
begin
  Assert((StreamWriter <> nil) and (StreamWriter.ListOfSegments <> nil));
  result := StreamWriter.ListOfSegments.IndexOf(self) + 1;
  Assert(result > 0)
end;

function TSegment.GetOutflowSegment: integer;
var
  ASegment: TSegment;
begin
  if FOutflowSegment = 0 then
  begin
    result := 0;
  end
  else if FOutflowSegment > 0 then
  begin
    ASegment := GetSegmentByNumber(FOutflowSegment);
    if (ASegment = nil) then
    begin
      DiversionErrors.Add('In Segment number ' + IntToStr(FNumber)
        + ', an invalid outflow segment number of '
        + IntToStr(FOutflowSegment) + ' was specified.');
      result := 0;
      Exit;
    end;
    result := ASegment.Number;
  end
  else
  begin
    if StreamWriter.LakeWriter = nil then
    begin
      result := -10000;
      DiversionErrors.Add('In Segment number ' + IntToStr(FNumber)
        + ', an invalid outflow segment number of '
        + IntToStr(FOutflowSegment) + ' was specified.');
      Exit;
    end;

    Assert((StreamWriter <> nil) and (StreamWriter.LakeWriter <> nil));
    result := -StreamWriter.LakeWriter.MFLakeNumber(-FOutflowSegment);
    if result = 0 then
    begin
      DiversionErrors.Add('In Segment number ' + IntToStr(FNumber)
        + ', an invalid outflow segment number of '
        + IntToStr(FOutflowSegment) + ' was specified.');
    end;
  end;
end;

function TSegment.GetReach(Index: integer): TStreamReachObject;
begin
  result := ReachList[Index];
end;

function TSegment.GetSegmentByNumber(const SegmentNumber: integer): TSegment;
var
  Index: integer;
  ASegment: TSegment;
begin
  Assert((StreamWriter <> nil) and (StreamWriter.ListOfSegments <> nil));
  result := nil;
  for Index := 0 to StreamWriter.ListOfSegments.Count - 1 do
  begin
    ASegment := StreamWriter.ListOfSegments[Index];
    if ASegment.FNumber = SegmentNumber then
    begin
      result := ASegment;
      Exit;
    end;
  end;
end;

function TSegment.ReachCount: integer;
begin
  result := ReachList.Count;
end;

function TSegment.ValuesAreValid(var ErrorMessage: string; const TimeIndex:
  integer): boolean;
var
  FirstError: boolean;
  MinValue: double;
  Index: integer;
  MinIndex: integer;
  ConcObject: TConcentrationEntry;
  TempDivSegment: integer;
  procedure AddCommaIfNeeded;
  begin
    if not FirstError then
    begin
      ErrorMessage := ErrorMessage + ', ';
    end;
  end;
begin
  // TimeIndex is the Stress period minus 1.
  ErrorMessage := 'Errors in Segment ' + IntToStr(Number)
    + ' in Stress period ' + IntToStr(TimeIndex + 1) + ': ';
  FirstError := True;
  if ICalc > 4 then
  begin
    ErrorMessage := ErrorMessage + 'Invalid ICALC (ICALC > 4)';
    FirstError := False;
  end;
  TempDivSegment := DiversionSegment;
  Assert(UpstreamBedElevation.Count = DownstreamBedElevation.Count);
  if (frmMODFLOW.ISFROPT  = 0) or ((frmMODFLOW.ISFROPT in [4,5])
    and ({(ICALC in [0,3,4]) or} ((ICALC in [1,2]) and (TimeIndex = 0))))  then
  begin
    Assert(TimeIndex < UpstreamBedElevation.Count);
    if UpstreamBedElevation[TimeIndex] <= DownstreamBedElevation[TimeIndex] then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Upstream Bed Elevation <= '
        + 'Downstream Bed Elevation';
      FirstError := False;
    end;
  end;

  if TempDivSegment > 0 then
  begin
    if DiversionPriority < -3 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage + 'Invalid IPRIOR (IPRIOR < -3)';
      FirstError := False;
    end;
    if (DiversionPriority = -2) then
    begin
      if (Flow[TimeIndex] > 1) then
      begin
        AddCommaIfNeeded;
        ErrorMessage := ErrorMessage +
          'Invalid Flow with IPRIOR = -2 (Flow > 1)';
        FirstError := False;
      end;
      if (Flow[TimeIndex] < 0) then
      begin
        AddCommaIfNeeded;
        ErrorMessage := ErrorMessage +
          'Invalid Flow with IPRIOR = -2 (Flow < 0)';
        FirstError := False;
      end;
    end;
  end;
  if ICALC = 4 then
  begin
    if (FlowTableList.Count < 2) then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Number of entries in flow/depth/width table < 2 (NSTRPTS < 2)';
      FirstError := False;
    end;
    if (FlowTableList.Count > 50) then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Number of entries in flow/depth/width table > 50 (NSTRPTS > 50)';
      FirstError := False;
    end;
  end;
  if TempDivSegment < 0 then
  begin
    if Flow[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid upstream Flow from stream to Lake (IUPSEG < 0 and Flow < 0)';
      FirstError := False;
    end;
  end;
  if (ICALC = 1) or (ICALC = 2) then
  begin
    if ChannelRoughness[TimeIndex] <= 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative channel roughness (ROUGHCH < 0)';
      FirstError := False;
    end;
  end;
  if (ICALC = 2) then
  begin
    if OverBankRoughness[TimeIndex] <= 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative bank roughness (ROUGHBK < 0)';
      FirstError := False;
    end;
  end;
  if ICALC = 3 then
  begin
    if DepthCoefficient[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative depth coefficient (ADPTH < 0)';
      FirstError := False;
    end;
    if WidthCoefficient[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative width coefficient (AWDTH < 0)';
      FirstError := False;
    end;
    if (DepthCoefficient[TimeIndex] = 0) and (WidthCoefficient[TimeIndex] = 0)
      then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Width and depth coefficients both = 0 (ADPTH = AWDTH = 0)';
      FirstError := False;
    end;
    if DepthExponent[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative depth exponent (BDPTH < 0)';
      FirstError := False;
    end;
    if WidthExponent[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative depth exponent (BWDTH < 0)';
      FirstError := False;
    end;
  end;
  if UpstreamK < 0 then
  begin
    AddCommaIfNeeded;
    ErrorMessage := ErrorMessage +
      'Invalid negative upstream hydraulic conductivity '
      + '(Hc1fact or HCOND1 < 0)';
    FirstError := False;
  end;
  if DownstreamK < 0 then
  begin
    AddCommaIfNeeded;
    ErrorMessage := ErrorMessage +
      'Invalid negative downstream hydraulic conductivity '
      + '(Hc2fact or HCOND2 < 0)';
    FirstError := False;
  end;
  if (frmMODFLOW.ISFROPT  = 0) or ((frmMODFLOW.ISFROPT in [4,5])
    and ({(ICALC in [0,3,4]) or} ((ICALC in [1,2]) and (TimeIndex = 0))))  then
  begin
    if UpstreamBedThickness[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative upstream bed thickness (THICKM1 < 0)';
      FirstError := False;
    end;
    if DownstreamBedThickness[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative downstream bed thickness (THICKM2 < 0)';
      FirstError := False;
    end;
  end;
  if ICALC < 2 then
  begin
    if UpstreamWidth[TimeIndex] <= 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative or zero upstream stream width with '
        + 'ICALC < 2 (WIDTH1 < 0)';
      FirstError := False;
    end;
    if DownstreamWidth[TimeIndex] <= 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative or zero downstream stream width with '
        + 'ICALC < 2 (WIDTH2 < 0)';
      FirstError := False;
    end;
  end;
  if ICALC = 0 then
  begin
    if UpstreamDepth[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative upstream stream depth (DEPTH1 < 0)';
      FirstError := False;
    end;
    if DownstreamDepth[TimeIndex] < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Invalid negative downstream stream depth (DEPTH2 < 0)';
      FirstError := False;
    end;
  end;
  if ICALC = 2 then
  begin
    MinValue := CrossSection[2, 1];
    MinIndex := 1;
    for Index := 2 to MaxCrossSectionPts do
    begin
      if CrossSection[2, Index] < MinValue then
      begin
        MinValue := CrossSection[2, Index];
        MinIndex := Index;
      end;
    end;
    if (MinIndex = 1) or (MinIndex = 8) then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Lowest depth on cross section is at the left or right bank '
        + '(ZCPT1 or ZCPT8 is the lowest point)';
      FirstError := False;
    end;
    for Index := 2 to MaxCrossSectionPts do
    begin
      if CrossSection[1, Index] < CrossSection[1, Index - 1] then
      begin
        AddCommaIfNeeded;
        ErrorMessage := ErrorMessage +
          'X coordinates in cross section do not increase '
          + '(XCPT[i] < XCPT[i+1])';
        FirstError := False;
        break
      end;
    end;

  end;
  if TempDivSegment = 0 then
  begin
    for Index := 0 to ConcentrationList.Count - 1 do
    begin
      ConcObject := ConcentrationList[Index] as TConcentrationEntry;
      if ConcObject.Conc.InflowConcentration < 0 then
      begin
        AddCommaIfNeeded;
        ErrorMessage := ErrorMessage +
          'Concentration in specified inflow is negative (CONCQ < 0)';
        FirstError := False;
        break
      end;
    end;
  end;
  for Index := 0 to ConcentrationList.Count - 1 do
  begin
    ConcObject := ConcentrationList[Index] as TConcentrationEntry;
    if ConcObject.Conc.RunoffConcentration < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Runoff concentration is negative (CONCRUN < 0)';
      FirstError := False;
      break
    end;
  end;
  for Index := 0 to ConcentrationList.Count - 1 do
  begin
    ConcObject := ConcentrationList[Index] as TConcentrationEntry;
    if ConcObject.Conc.PrecipitationConcentration < 0 then
    begin
      AddCommaIfNeeded;
      ErrorMessage := ErrorMessage +
        'Precipitation concentration is negative (CONCPPT < 0)';
      FirstError := False;
      break
    end;
  end;

  result := FirstError;
end;

procedure TSegment.WriteSegment(const StreamWriter: TStreamWriter; const
  TimeIndex: integer; const IsParam: boolean);
begin
  // TimeIndex is the Stress period minus 1.
  // data set 4b or 6a
  WriteSegmentA(StreamWriter, TimeIndex);
  // data set 4c or 6b
  WriteSegmentB(StreamWriter, TimeIndex, IsParam);
  // data set 4d or 6c
  WriteSegmentC(StreamWriter, TimeIndex, IsParam);

  // uncomment the following line for update to SFR2 package.
  if (StreamWriter.ISFROPT <= 1) or (TimeIndex = 0) then
  begin
    // data set 4e or 6d
    WriteSegmentD(StreamWriter);
  end;
  // data set 4f or 6e
  WriteSegmentE(StreamWriter);
  // data set 4g or 6f
  WriteSegmentF(StreamWriter, TimeIndex);
end;

procedure TSegment.WriteSegmentA(StreamWriter: TStreamWriter;
  const TimeIndex: integer);
var
  TempDivSegment: integer;
  Variables: string;
begin
  // TimeIndex is the Stress period minus 1.
  // Data sets 4b and 6A
  TempDivSegment := DiversionSegment;
  Write(StreamWriter.FFile, Number, ' ', ICALC, ' ', OutflowSegment, ' ',
    TempDivSegment, ' ');
  Variables := ' NSEG, ICALC, OUTSEG, IUPSEG, ';
  if TempDivSegment > 0 then
  begin
    Write(StreamWriter.FFile, DiversionPriority, ' ');
    Variables := Variables + 'IPRIOR, ';
  end;
  if ICALC = 4 then
  begin
    Write(StreamWriter.FFile, FlowTableList.Count, ' ');
    Variables := Variables + 'NSSTRSPTS, ';
  end;
  Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(Flow[TimeIndex]),
    StreamWriter.FreeFormattedReal(RunOff[TimeIndex]),
    StreamWriter.FreeFormattedReal(Evaporation[TimeIndex]),
    StreamWriter.FreeFormattedReal(Precipitation[TimeIndex]));
    Variables := Variables + 'FLOW, RUNORR, ETSW, PPTSW';
  if (ICALC = 1) or (ICALC = 2) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(ChannelRoughness[TimeIndex]));
    Variables := Variables + ', ROUGHCH';
  end;
  if (ICALC = 2) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(OverBankRoughness[TimeIndex]));
    Variables := Variables + ', ROUGHBK';
  end;
  if (ICALC = 3) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(DepthCoefficient[TimeIndex]),
      StreamWriter.FreeFormattedReal(DepthExponent[TimeIndex]),
      StreamWriter.FreeFormattedReal(WidthCoefficient[TimeIndex]),
      StreamWriter.FreeFormattedReal(WidthExponent[TimeIndex]));
    Variables := Variables + ', CDPTH, FDPTH, AWDTH, BWDTH';
  end;
  WriteLn(StreamWriter.FFile, Variables);

end;

function TSegment.ShouldWriteHydraulicConductivity(const IsParam: boolean;
  const StreamWriter: TStreamWriter): boolean;
begin
  // test whether hydraulic conductivity should be written in data sets
  // 4b. 4c, 6a and 6b.
  // Hc1fact or HCOND1
  // Hc1fact (IsParam = true) is always required
  // HCOND1 (IsParam = false) is required when
  // NSTRM is positive or when ISFROPT is 4 or 5.
  result := False;
  if IsParam then
  begin
    result := True;
  end
  else if (StreamWriter.NSTRM > 0) then
  begin
    result := True;
  end
  else if (StreamWriter.ISFROPT in [4,5]) then 
  begin
    result := True;
  end;
end;

function TSegment.ShouldWriteThicknessAndElevation(const IsParam: boolean;
  const StreamWriter: TStreamWriter; const TimeIndex: integer): boolean;
begin
  // THICKM1
  // If IsParam is true (Data set 4c), THICKM1 is always specified.
  // If IsParam is false (Data set 6b), THICKM1 is specified:
  // 1. for all stress periods if NSTRM is positive
  // 2. only for the first stress period when ICALC is 1 or 2 and ISFROPT is 4 or 5.

  // ELEVUP is required exactly as THICKM1
  // If IsParam is true (Data set 4c), ELEVUP is always specified.
  // If IsParam is false (Data set 6b), ELEVUP is specified:
  // 1. for all stress periods if NSTRM is positive
  // 2. only for the first stress period when ICALC is 1 or 2 and ISFROPT is 4 or 5.

  result := False;
  if IsParam or (StreamWriter.NSTRM > 0) then
  begin
    result := True;
  end
  else if ((ICALC <= 0) or (ICALC >= 3))
    and (StreamWriter.ISFROPT in [4,5]) then
  begin
    result := True;
  end
  else if (TimeIndex = 0)
    and (ICALC in [1,2])
    and (StreamWriter.ISFROPT in [4,5]) then
  begin
    result := True;
  end;
end;

function TSegment.ShouldWriteWidth(const IsParam: boolean;
  const StreamWriter: TStreamWriter; const TimeIndex: integer): boolean;
begin
  // WIDTH1
  // If IsParam is true (Data set 4c), WIDTH1 is only specified if ICALC <= 1.
  // If IsParam is false (Data set 6b), WIDTH1 is specified:
  // 1. for all stress periods if NSTRM is positive
  // 2. is read for all stress periods when ICALC <= 1 and ISFROPT is 1
  // 3. is only read for the first stress period when ISFROPT is greater than 1 and ICALC <= 1.
  // 4. is read for all stress periods when ICALC is 0 and is not dependent on the value of ISFROPT.

  result := False;
  if IsParam then
  begin
    if ICALC <= 1 then
    begin
      result := True;
    end;
  end
  else
  begin
    if (StreamWriter.NSTRM > 0) and (ICALC <= 1) then
    begin
      // conditions 1
      result := True;
    end else if (StreamWriter.ISFROPT = 1) and (ICALC <= 1) then
    begin
      // conditions 2
      result := True;
    end
    else if StreamWriter.ISFROPT > 1 then
    begin
      if (TimeIndex = 0) and (ICALC <= 1) then
      begin
        // condition 3
        result := True;
      end;
    end;

    if (ICALC = 0) then
    begin
      // condition 4
      result := True;
    end;
  end;
end;

function TSegment.ShouldWriteDepth: boolean;
begin
  // DEPTH1
  // If IsParam is true (Data set 4c), DEPTH1 is only specified if ICALC = 0.
  // If IsParam is false (Data set 6b), DEPTH1 is specified:
  // 1. DEPTH1 is read for each stress period when NSTRM is positive, (and?)
  // 2. DEPTH1 is read for each stress period when ICALC is 0 and is not dependent on the value of ISFROPT.

  result := False;
  if ICALC = 0 then
  begin
    result := True;
  end;
{  if IsParam then
  begin
    if ICALC = 0 then
    begin
      result := True;
    end;
  end
  else
  begin
    if (ICALC = 0) then
    begin
      result := True;
    end;
  end; }
end;

function TSegment.ShouldWriteUnsaturatedProperties(const IsParam: boolean;
  const StreamWriter: TStreamWriter): boolean;
begin
  // THTS1, THTI1, EPS1 and UHC1
  // if If IsParam is true (Data set 4c), THTS1, THTI1, EPS1 and UHC1 are not read.
  // If IsParam is false (Data set 6b), THTS1, THTI1, EPS1 and UHC1 are read
  // only for the first stress period when ICALC is 1 or 2 and ISFROPT is 4 or 5.

  result := False;
  if not IsParam then
  begin
    if (ICALC in [1, 2]) and (StreamWriter.ISFROPT in [4, 5]) then
    begin
      result := True;
    end;
  end;
end;

procedure TSegment.WriteSegmentB(const StreamWriter: TStreamWriter;
  const TimeIndex: integer; const IsParam: boolean);
var
  K: double;
  Variables: string;
begin
  // TimeIndex is the Stress period minus 1.
  if Active[TimeIndex] then
  begin
    K := UpstreamK;
  end
  else
  begin
    K := 0;
  end;
  Variables := '';

  if ShouldWriteHydraulicConductivity(IsParam, StreamWriter) then
  begin
    Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
    if IsParam then
    begin
      Variables := Variables + 'Hc1fact, ';
    end
    else
    begin
      Variables := Variables + 'HCOND1, ';
    end;
  end;

  if ShouldWriteThicknessAndElevation(IsParam, StreamWriter, TimeIndex) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
      StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]));
    Variables := Variables + 'THICKM1, ELEVUP, ';
  end;

  if ShouldWriteWidth(IsParam, StreamWriter, TimeIndex) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]));
    Variables := Variables + 'WIDTH1, ';
  end;

  if ShouldWriteDepth then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(UpstreamDepth[TimeIndex]));
    Variables := Variables + 'DEPTH1, ';
  end;

  if ShouldWriteUnsaturatedProperties(IsParam, StreamWriter) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(UpstreamSaturatedWaterContent),
      StreamWriter.FreeFormattedReal(UpstreamInitialWaterContent),
      StreamWriter.FreeFormattedReal(UpstreamBrooksCoreyExponent),
      StreamWriter.FreeFormattedReal(UpstreamUnsatZoneHydraulicConductivity));

    Variables := Variables + 'THTS1, THTI1, EPS1, UHC1';
  end;

  Variables := Trim(Variables);
  if (Length(Variables) > 0) then
  begin
    if (Variables[Length(Variables)] = ',') then
    begin
      SetLength(Variables, Length(Variables)-1);
    end;
    Variables := ' ' + Variables;
    Writeln(StreamWriter.FFile, Variables);
  end;

{  case StreamWriter.ISFROPT of
    0:
      begin
        Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
          StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
          StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]));
        if IsParam then
        begin
          Variables := ' Hc1fact, THICKM1, ELEVUP';
        end
        else
        begin
          Variables := ' HCOND1, THICKM1, ELEVUP';
        end;

        if ICALC < 2 then
        begin
          Write(StreamWriter.FFile,
            StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]));
          Variables := Variables + ', WIDTH1';
        end;
        if ICALC = 0 then
        begin
          Write(StreamWriter.FFile,
            StreamWriter.FreeFormattedReal(UpstreamDepth[TimeIndex]));
          Variables := Variables + ', DEPTH1';
        end;
        Writeln(StreamWriter.FFile, Variables);
      end;
    1:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]));
              Variables := Variables + ', WIDTH1';
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(UpstreamDepth[TimeIndex]));
              Variables := Variables + ', DEPTH1';
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]));
              Variables := Variables + ', WIDTH1';
              Writeln(StreamWriter.FFile, Variables);
            end;
          2:
            begin
              // do nothing
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
    2, 3:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]));
              Variables := Variables + ', WIDTH1';
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(UpstreamDepth[TimeIndex]));
              Variables := Variables + ', DEPTH1';
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile,
                  StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]));
                Variables := Variables + ', WIDTH1';
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          2:
            begin
              // do nothing
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
    4:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamDepth[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, DEPTH1';
              end
              else
              begin
                Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, DEPTH1';
              end;

              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamBrooksCoreyExponent));
                if IsParam then
                begin
                  Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
                end
                else
                begin
                  Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc1fact';
                end
                else
                begin
                  Variables := ' HCOND1';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          2:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamBrooksCoreyExponent));
                if IsParam then
                begin
                  Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
                end
                else
                begin
                  Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc1fact';
                end
                else
                begin
                  Variables := ' HCOND1';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          3,4:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
              end
              else
              begin
                Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
              end;

              Writeln(StreamWriter.FFile, Variables);
            end;
        else
          begin
            Assert(False);
          end;
        end;

      end;
    5:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamDepth[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, DEPTH1';
              end
              else
              begin
                Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, DEPTH1';
              end;
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamWidth[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamBrooksCoreyExponent),
                  StreamWriter.FreeFormattedReal(UpstreamUnsatZoneHydraulicConductivity));
                if IsParam then
                begin
                  Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1, UHC1';
                end
                else
                begin
                  Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1, UHC1';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc1fact';
                end
                else
                begin
                  Variables := ' HCOND1';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          2:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(UpstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(UpstreamBrooksCoreyExponent),
                  StreamWriter.FreeFormattedReal(UpstreamUnsatZoneHydraulicConductivity));
                if IsParam then
                begin
                  Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1, UHC1';
                end
                else
                begin
                  Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1, UHC1';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc1fact';
                end
                else
                begin
                  Variables := ' HCOND1';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          3,4:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(UpstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(UpstreamBedElevation[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc1fact, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
              end
              else
              begin
                Variables := ' HCOND1, THICKM1, ELEVUP, WIDTH1, THTS1, THTI1, EPS1';
              end;

              Writeln(StreamWriter.FFile, Variables);
            end;
        else
          begin
            Assert(False);
          end;
        end;

      end;
  else
    begin
      Assert(False);
    end;
  end;  }
end;

procedure TSegment.WriteSegmentC(const StreamWriter: TStreamWriter;
  const TimeIndex: integer; const IsParam: boolean);
var
  K: double;
  Variables: string;
begin
  // TimeIndex is the Stress period minus 1.
  if Active[TimeIndex] then
  begin
    K := DownstreamK;
  end
  else
  begin
    K := 0;
  end;

  Variables := '';

  if ShouldWriteHydraulicConductivity(IsParam, StreamWriter) then
  begin
    Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
    if IsParam then
    begin
      Variables := Variables + 'Hc2fact, ';
    end
    else
    begin
      Variables := Variables + 'HCOND2, ';
    end;
  end;

  if ShouldWriteThicknessAndElevation(IsParam, StreamWriter, TimeIndex) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
      StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]));
    Variables := Variables + 'THICKM2, ELEVDN, ';
  end;

  if ShouldWriteWidth(IsParam, StreamWriter, TimeIndex) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]));
    Variables := Variables + 'WIDTH2, ';
  end;

  if ShouldWriteDepth then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(DownstreamDepth[TimeIndex]));
    Variables := Variables + 'DEPTH2, ';
  end;

  if ShouldWriteUnsaturatedProperties(IsParam, StreamWriter) then
  begin
    Write(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(DownstreamSaturatedWaterContent),
      StreamWriter.FreeFormattedReal(DownstreamInitialWaterContent),
      StreamWriter.FreeFormattedReal(DownstreamBrooksCoreyExponent),
      StreamWriter.FreeFormattedReal(DownstreamUnsatZoneHydraulicConductivity));
    Variables := Variables + 'THTS1, THTI1, EPS1, UHC1';
  end;

  Variables := Trim(Variables);
  if (Length(Variables) > 0) then
  begin
    if (Variables[Length(Variables)] = ',') then
    begin
      SetLength(Variables, Length(Variables)-1);
    end;
    Variables := ' ' + Variables;
    Writeln(StreamWriter.FFile, Variables);
  end;

{  Variables := '';
  // ISFROPT = 4 or 5 not supported
  case StreamWriter.ISFROPT of
    0:
      begin
        Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
          StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
          StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]));
        if IsParam then
        begin
          Variables := ' Hc2fact, THICKM2, ELEVDN';
        end
        else
        begin
          Variables := ' HCOND2, THICKM2, ELEVDN';
        end;

        if ICALC < 2 then
        begin
          Write(StreamWriter.FFile,
            StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]));
          Variables := Variables + ', WIDTH2';
        end;
        if ICALC = 0 then
        begin
          Write(StreamWriter.FFile,
            StreamWriter.FreeFormattedReal(DownstreamDepth[TimeIndex]));
          Variables := Variables + ', DEPTH2';
        end;
        Writeln(StreamWriter.FFile, Variables);
      end;
    1:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]));
              Variables := Variables + ', WIDTH2';
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(DownstreamDepth[TimeIndex]));
              Variables := Variables + ', DEPTH2';
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]));
              Variables := Variables + ', WIDTH2';
              Writeln(StreamWriter.FFile, Variables);
            end;
          2:
            begin
              // do nothing
            end;
        else
          begin
            Assert(False);
          end;
        end;

      end;
    2, 3:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]));
              Variables := Variables + ', WIDTH2';
              Write(StreamWriter.FFile,
                StreamWriter.FreeFormattedReal(DownstreamDepth[TimeIndex]));
              Variables := Variables + ', DEPTH2';
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile,
                  StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]));
                Variables := Variables + ', WIDTH2';
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          2:
            begin
              // do nothing
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
    4:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamDepth[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc2fact, THICKM2, ELEVDN, WIDTH2, DEPTH2';
              end
              else
              begin
                Variables := ' HCOND2, THICKM2, ELEVDN, WIDTH2, DEPTH2';
              end;
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamBrooksCoreyExponent));
                if IsParam then
                begin
                  Variables := ' Hc2fact, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2';
                end
                else
                begin
                  Variables := ' HCOND2, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc2fact';
                end
                else
                begin
                  Variables := ' HCOND2';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          2:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamBrooksCoreyExponent));
                if IsParam then
                begin
                  Variables := ' Hc2fact, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2';
                end
                else
                begin
                  Variables := ' HCOND2, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc2fact';
                end
                else
                begin
                  Variables := ' HCOND2';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          3,4:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc2fact, THICKM2, ELEVDN';
              end
              else
              begin
                Variables := ' HCOND2, THICKM2, ELEVDN';
              end;

              Writeln(StreamWriter.FFile, Variables);
            end;
        else
          begin
            Assert(False);
          end;
        end;

      end;
    5:
      begin
        case ICALC of
          0:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamDepth[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc2fact, THICKM2, ELEVDN, WIDTH2, DEPTH2';
              end
              else
              begin
                Variables := ' HCOND2, THICKM2, ELEVDN, WIDTH2, DEPTH2';
              end;
              Writeln(StreamWriter.FFile, Variables);
            end;
          1:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamWidth[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamBrooksCoreyExponent),
                  StreamWriter.FreeFormattedReal(DownstreamUnsatZoneHydraulicConductivity));
                if IsParam then
                begin
                  Variables := ' Hc2fact, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2, UHC2';
                end
                else
                begin
                  Variables := ' HCOND2, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2, UHC2';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc2fact';
                end
                else
                begin
                  Variables := ' HCOND2';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          2:
            begin
              if TimeIndex = 0 then
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                  StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]),
                  StreamWriter.FreeFormattedReal(DownstreamSaturatedWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamInitialWaterContent),
                  StreamWriter.FreeFormattedReal(DownstreamBrooksCoreyExponent),
                  StreamWriter.FreeFormattedReal(DownstreamUnsatZoneHydraulicConductivity));
                if IsParam then
                begin
                  Variables := ' Hc2fact, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2, UHC2';
                end
                else
                begin
                  Variables := ' HCOND2, THICKM2, ELEVDN, WIDTH2, THTS2, THTI2, EPS2, UHC2';
                end;

                Writeln(StreamWriter.FFile, Variables);
              end
              else
              begin
                Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K));
                if IsParam then
                begin
                  Variables := ' Hc2fact';
                end
                else
                begin
                  Variables := ' HCOND2';
                end;
                Writeln(StreamWriter.FFile, Variables);
              end;
            end;
          3,4:
            begin
              Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal(K),
                StreamWriter.FreeFormattedReal(DownstreamBedThickness[TimeIndex]),
                StreamWriter.FreeFormattedReal(DownstreamBedElevation[TimeIndex]));
              if IsParam then
              begin
                Variables := ' Hc2fact, THICKM2, ELEVDN';
              end
              else
              begin
                Variables := ' HCOND2, THICKM2, ELEVDN';
              end;

              Writeln(StreamWriter.FFile, Variables);
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
  else
    begin
      Assert(False);
    end;
  end;  }

end;

procedure TSegment.WriteSegmentD(const StreamWriter: TStreamWriter);
var
  PointIndex, DimensionIndex: integer;
  Variables: string;
  Prefix: string;
begin
  // Write items 6d and 4e

  if ICALC = 2 then
  begin
    for DimensionIndex := 1 to 2 do
    begin
      if DimensionIndex = 1 then
      begin
        Prefix := 'XCPT'
      end
      else
      begin
        Prefix := 'ZCPT'
      end;

      Variables := ' ';
      for PointIndex := 1 to MaxCrossSectionPts do
      begin
        Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal
          (CrossSection[DimensionIndex, PointIndex]));
        Variables := Variables + Prefix + IntToStr(PointIndex) + ', ';
      end;
      SetLength(Variables, Length(Variables) -2 );
      WriteLn(StreamWriter.FFile, Variables);
    end;
  end;
end;

procedure TSegment.WriteSegmentE(const StreamWriter: TStreamWriter);
var
  Index: integer;
  FlowTableEntry: TFlowTableEntry;
begin
  // Write Flows
  // items 6e or 4f
  if ICALC = 4 then
  begin
    for Index := 0 to FlowTableList.Count - 1 do
    begin
      FlowTableEntry := FlowTableList[Index] as TFlowTableEntry;
      Write(StreamWriter.FFile,
        StreamWriter.FreeFormattedReal(FlowTableEntry.Flow.Flow));
      if (Index + 1 mod 5 = 0) then
      begin
        Writeln(StreamWriter.FFile);
      end;
    end;
    if (FlowTableList.Count mod 5 <> 0) then
    begin
      Writeln(StreamWriter.FFile);
    end;
    // Write Depths
    for Index := 0 to FlowTableList.Count - 1 do
    begin
      FlowTableEntry := FlowTableList[Index] as TFlowTableEntry;
      Write(StreamWriter.FFile,
        StreamWriter.FreeFormattedReal(FlowTableEntry.Flow.Depth));
      if (Index + 1 mod 5 = 0) then
      begin
        Writeln(StreamWriter.FFile);
      end;
    end;
    if (FlowTableList.Count mod 5 <> 0) then
    begin
      Writeln(StreamWriter.FFile);
    end;
    // Write Widths
    for Index := 0 to FlowTableList.Count - 1 do
    begin
      FlowTableEntry := FlowTableList[Index] as TFlowTableEntry;
      Write(StreamWriter.FFile,
        StreamWriter.FreeFormattedReal(FlowTableEntry.Flow.Width));
      if (Index + 1 mod 5 = 0) then
      begin
        Writeln(StreamWriter.FFile);
      end;
    end;
    if (FlowTableList.Count mod 5 <> 0) then
    begin
      Writeln(StreamWriter.FFile);
    end;
  end;
end;

procedure TSegment.WriteSegmentF(const StreamWriter: TStreamWriter;
  const TimeIndex: integer);
var
  ConcObject: TConcentrationEntry;
begin
  // write items 4g and 6f
  if frmModflow.cbMOC3D.Checked and frmModflow.cbUseSolute.Checked then
  begin
    ConcObject := ConcentrationList[TimeIndex] as TConcentrationEntry;
    if DiversionSegment = 0 then
    begin
      // CONCQ
      Write(StreamWriter.FFile, StreamWriter.FreeFormattedReal
        (ConcObject.Conc.InflowConcentration));
    end;
    // CONCRUN, CONCPPT
    WriteLn(StreamWriter.FFile,
      StreamWriter.FreeFormattedReal(ConcObject.Conc.RunoffConcentration),
      StreamWriter.FreeFormattedReal(
        ConcObject.Conc.PrecipitationConcentration));
  end;
end;

{ TSegmentList }

procedure TSegmentList.Write(const StreamWriter: TStreamWriter;
  const TimeIndex: integer; var ErrorsFound: boolean; const IsParam: boolean);
var
  Index: integer;
  Segment: TSegment;
  StreamErrors: TStringList;
  ErrorMessage: string;
begin
  // TimeIndex is the Stress period minus 1.
  ErrorsFound := False;
  StreamErrors := TStringList.Create;
  //  TimeCount := frmModflow.dgTime.RowCount -1;
  StreamErrors.Add('');
  try
    for Index := 0 to Count - 1 do
    begin
      Segment := Items[Index] as TSegment;

      if not Segment.ValuesAreValid(ErrorMessage, TimeIndex) then
      begin
        StreamErrors.Add(ErrorMessage);
      end;
      Segment.WriteSegment(StreamWriter, TimeIndex, IsParam);
    end;
    if StreamErrors.Count > 1 then
    begin
      ErrorMessages.AddStrings(StreamErrors);
      ErrorsFound := True;
    end;
  finally
    StreamErrors.Free;
  end;
end;

{ TStreamParameterObject }

constructor TStreamParameterObject.Create;
var
  TimeCount: integer;
begin
  inherited;
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SegmentList := TSegmentList.Create;
  SetLength(Active, TimeCount);
  Instances:= TStringList.Create;
end;

destructor TStreamParameterObject.Destroy;
begin
  SegmentList.Free;
  Instances.Free;
  inherited;
end;

procedure TStreamParameterObject.SetName(const Value: ShortString);
var
  Index: integer;
begin
  FName := UpperCase(Trim(Value));
  if Length(FName) > 10 then
  begin
    SetLength(FName, 10)
  end;
  for Index := 1 to Length(FName) do
  begin
    if FName[Index] = ' ' then
    begin
      FName[Index] := '_';
    end;
  end;
end;

procedure TStreamParameterObject.SortTheSegments;
begin
  SegmentList.Sort(SortSegments);
end;

procedure TStreamParameterObject.Write(StreamWriter: TStreamWriter;
  var ErrorsFound: boolean);
var
  Index: integer;
begin
  // data set 3
  if Instances.Count > 0 then
  begin
    WriteLn(StreamWriter.FFile, Name, ' SFR ',
      StreamWriter.FreeFormattedReal(Value),
      SegmentList.Count, ' INSTANCES ', Instances.Count);

    // data set 4a
    for Index := 0 to Instances.Count -1 do
    begin
      WriteLn(StreamWriter.FFile, Instances[Index]);

      // Data Set 4b - 4g
      SegmentList.Write(StreamWriter, Index, ErrorsFound, True);
    end;
  end
  else
  begin
    WriteLn(StreamWriter.FFile, Name, ' SFR ',
      StreamWriter.FreeFormattedReal(Value),
      SegmentList.Count);

    // Data Set 4b - 4g
    SegmentList.Write(StreamWriter, 0, ErrorsFound, True);
  end;
end;

{ TStreamReachList }

function TStreamReachList.Add(StreamReach: TStreamReachRecord):
  TStreamReachObject;
begin
  result := TStreamReachObject.Create;
  result.Reach := StreamReach;
  inherited Add(result);
end;

constructor TStreamReachList.Create(const Segment: TSegment);
begin
  inherited Create;
  self.Segment := Segment
end;

function TStreamReachList.GetItems(Index: Integer): TStreamReachObject;
begin
  result := inherited Items[Index] as TStreamReachObject;
end;

procedure TStreamReachList.SetItems(Index: Integer;
  const Value: TStreamReachObject);
begin
  inherited Items[Index] := Value;
end;

procedure TStreamReachList.Write(StreamWriter: TStreamWriter;
  SlopeErrors, ThicknessErrors: TStringList);
var
  ISEG: integer;
  IREACH: integer;  // = IREACH - 1
  StreamReachObject: TStreamReachObject;
  variables: string;
begin
  Assert(Segment <> nil);
  ISEG := Segment.Number;
  for IREACH := 1 to Count do
  begin
    StreamReachObject := Items[IREACH-1];
    // KRCH, IRCH, JRCH, ISEG, IREACH, RCHLEN
    variables := 'KRCH, IRCH, JRCH, ISEG, IREACH, RCHLEN, ';
    System.Write(StreamWriter.FFile,
      StreamReachObject.Reach.Layer, ' ',
      StreamReachObject.Reach.Row, ' ',
      StreamReachObject.Reach.Column, ' ',
      ISEG, ' ',
      IREACH, ' ',
      StreamWriter.FreeFormattedReal(StreamReachObject.Reach.ChannelLength));
    if (StreamWriter.NSTRM < 0) and (StreamWriter.ISFROPT in [1,2,3]) then
    begin
      // STRTOP, SLOPE, STRTHICK, and STRHC1
      variables := variables + 'STRTOP, SLOPE, STRTHICK, STRHC1, ';
      System.Write(StreamWriter.FFile,
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.StreambedTop),
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.Slope),
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.StreambedThickness),
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.StreambedHydraulicConductivity));
      if (StreamReachObject.Reach.Slope <= 0) then
      begin
        SlopeErrors.Add(IntToStr(StreamReachObject.Reach.Layer)
          + ' ' + IntToStr(StreamReachObject.Reach.Row)
          + ' ' + IntToStr(StreamReachObject.Reach.Column));
      end;
      if StreamReachObject.Reach.StreambedThickness <= 0  then
      begin
        ThicknessErrors.Add(IntToStr(StreamReachObject.Reach.Layer)
          + ' ' + IntToStr(StreamReachObject.Reach.Row)
          + ' ' + IntToStr(StreamReachObject.Reach.Column));
      end;

    end;
    if (StreamWriter.NSTRM < 0) and (StreamWriter.ISFROPT in [2,3]) then
    begin
      // THTS, THTI, and EPS
      variables := variables + 'THTS, THTI, EPS, ';
      System.Write(StreamWriter.FFile,
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.SaturatedWaterContent),
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.InitialWaterContent),
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.BrooksCoreyExponent));
    end;
    if (StreamWriter.NSTRM < 0) and (StreamWriter.ISFROPT = 3) then
    begin
      // UHC
      variables := variables + 'UHC';
      System.Write(StreamWriter.FFile,
        StreamWriter.FreeFormattedReal(StreamReachObject.Reach.UnsatZoneHydraulicConductivity));
    end;
    Assert(Length(variables) > 0);
    variables := Trim(Variables);
    if Variables[Length(variables)] = ',' then
    begin
      SetLength(variables, Length(variables)-1);
    end;
    writeln(StreamWriter.FFile, variables);
  end;
end;

{ TStreamWriter }

function TStreamWriter.ComputeStreamConstant: double;
var
  ErrorMessage: string;
begin
  result := 1;
  case frmModflow.comboLengthUnits.ItemIndex of
    0:
      begin
        ErrorMessage :=
          'Error in SFR package: Length units for model are undefined';
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add(' ');
        ErrorMessages.Add(ErrorMessage);
      end;
    1: // feet
      begin
        result := 1 / 0.3048;
      end;
    2: // m
      begin
      end;
    3: // cm
      begin
        result := 1 / 100;
      end;
  else
    Assert(False);
  end;
  if result <> 1 then
  begin
    result := Power(result, 1 / 3);
  end;
  case frmModflow.comboTimeUnits.ItemIndex of
    0: // Undefined
      begin
        ErrorMessage :=
          'Error in SFR package: Time units for model are undefined';
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
  else
    Assert(False);
  end;
end;

constructor TStreamWriter.Create;
begin
  inherited;
  EightPointStreamErrors := 0;
  FormulaStreamErrors := 0;
  SimpleStreamErrors := 0;
  TableStreamErrors := 0;
  ParameterList := TStreamParameterList.Create;
  SegmentList := TSegmentList.Create;
  ListOfSegments := TList.Create;
  InvalidParameters:= TStringList.Create;
end;

destructor TStreamWriter.Destroy;
begin
  ParameterList.Free;
  SegmentList.Free;
  ListOfSegments.Free;
  InvalidParameters.Free;
  inherited;
end;

procedure TStreamWriter.AssignGageParametersToSegment(
  const Contour: TContourObjectOptions; const Segment: TSegment;
  const Indicies: TStreamParamIndicies);
begin
  Segment.IsGage := Contour.GetBoolParameter(CurrentModelHandle,
    Indicies.IsGageIndex);
  Segment.GageOutputType := Contour.GetIntegerParameter(
    CurrentModelHandle, Indicies.GageOutputTypeIndex);
  if Indicies.DiversionGageIndex > 0 then
  begin
    Segment.GageDiversion := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.DiversionGageIndex);
  end
  else
  begin
    Segment.GageDiversion := False;
  end;

  if Indicies.UnsatFlowIndex > 0 then
  begin
    Segment.GageUnsatFlow := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.UnsatFlowIndex);
  end
  else
  begin
    Segment.GageUnsatFlow := False;
  end;

  if Indicies.UnsatFlowProfileIndex > 0 then
  begin
    Segment.GageUnsatProfile := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.UnsatFlowProfileIndex);
  end
  else
  begin
    Segment.GageUnsatProfile := False;
  end;

end;

procedure TStreamWriter.EvaluateSimpleStreamLayer(const UnitIndex: integer;
  out ContourCount: integer);
var
  LayerName: string;
  Layer: TLayerOptions;
//  ContourCount: integer;
  Contour: TContourObjectOptions;
  ContourIndex: ANE_INT32;
  Indicies: TStreamParamIndicies;
  ICALC_Index: ANE_INT32;
  TimeIndicies: array of TStreamTimeParamIndicies;
  SimpleTimeIndicies: array of TSimpleStreamTimeParamIndicies;
  TimeCount: integer;
  TimeIndex: integer;
  IsParam: boolean;
  ParameterName: string;
  ParameterObject: TStreamParameterObject;
  Segment: TSegment;
  TimesToUse: integer;
  ErrorMessage: string;
  IFaceErrors: TStringList;
begin
  ContourCount := 0;
  if frmModflow.Simulated(UnitIndex) then
  begin
    IFaceErrors := TStringList.Create;
    try
      LayerName := ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName
        + IntToStr(UnitIndex);
      AddVertexLayer(CurrentModelHandle, LayerName);
      Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
      try
        GetStreamParameterIndicies(Layer, Indicies, True);

        GetStreamICALC_Index(Layer, ICALC_Index);

        TimeCount := frmModflow.dgTime.RowCount - 1;

        SetLength(TimeIndicies, TimeCount);
        SetLength(SimpleTimeIndicies, TimeCount);
        for TimeIndex := 0 to TimeCount - 1 do
        begin
          GetStreamTimeParameterIndicies(Layer, TimeIndicies[TimeIndex], TimeIndex
            + 1);
          GetSimpleStreamTimeParameterIndicies(Layer,
            SimpleTimeIndicies[TimeIndex], TimeIndex + 1);
        end;

        ContourCount := Layer.NumObjects(CurrentModelHandle, pieContourObject);
        for ContourIndex := 0 to ContourCount - 1 do
        begin
          Contour := TContourObjectOptions.Create(CurrentModelHandle,
            Layer.LayerHandle, ContourIndex);
          try
            if Contour.ContourType(CurrentModelHandle) <> ctOpen then
            begin
              Inc(SimpleStreamErrors);
            end
            else
            begin
              Segment := TSegment.Create;

              AssignGageParametersToSegment(Contour, Segment, Indicies);

              IsParam := Contour.GetBoolParameter(CurrentModelHandle,
                Indicies.IsParameterIndex);
              if IsParam then
              begin
                ParameterName := UpperCase(Contour.GetStringParameter
                  (CurrentModelHandle, Indicies.ParameterNameIndex));
                if Length(ParameterName) > 10 then
                begin
                  SetLength(ParameterName, 10);
                end;
                ParameterObject :=
                  ParameterList.GetParameterByName(ParameterName);
                if ParameterObject = nil then
                begin
                  if InvalidParameters.IndexOf(ParameterName) < 0 then
                  begin
                    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
                      + ' in the SFR package.  Contours using this parameter name will be '
                      + 'ignored.';
                    ErrorMessages.Add(ErrorMessage);
                    frmProgress.reErrors.Lines.Add(ErrorMessage);
                    InvalidParameters.Add(ParameterName);
                  end;
                  TimesToUse := TimeCount;
                end
                else
                begin
                  ParameterObject.SegmentList.Add(Segment);
                  TimesToUse := ParameterObject.Instances.Count;
                  if TimesToUse <= 0 then
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
              GetStreamSegmentValues(Indicies, Segment, Contour);
              GetSimpleStreamSegmentICALC(ICALC_Index, Segment, Contour);
              if not (Segment.ICALC in [0,1]) then
              begin
                Segment.ICALC := 1;
                IFaceErrors.Add(IntToStr(Segment.FNumber));
              end;

              for TimeIndex := 0 to TimesToUse - 1 do
              begin
                GetStreamTimeParameterValues(TimeIndicies[TimeIndex],
                  Segment, Contour, TimeIndex);
                GetSimpleStreamTimeParameterValues(SimpleTimeIndicies[TimeIndex],
                  Segment, Contour);
              end;
              AddCells(Segment, ContourIndex, UnitIndex, Layer, Indicies);
            end;
          finally
            Contour.Free;
          end;
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
      if IFaceErrors.Count > 0 then
      begin
        if IFaceErrors.Count = 1 then
        begin
          ErrorMessage := 'Invalid ICALC value on '
        end
        else
        begin
          ErrorMessage := 'Invalid ICALC values on '
        end;

        ErrorMessage := ErrorMessage + LayerName
          + '.  A value of "1" will be used.';
        frmProgress.reErrors.Lines.Add('');
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add(ErrorMessage);


          ErrorMessage := 'The segment(s) with the following '
          + 'segment numbers have this problem.';
        ErrorMessages.Add(ErrorMessage);
        ErrorMessages.AddStrings(IFaceErrors);
      end;
    finally
      IFaceErrors.Free;
    end;
  end;
end;

procedure TStreamWriter.EvaluateTableStreamLayer(const UnitIndex: integer;
  out ContourCount: integer);
var
  LayerName: string;
  Layer: TLayerOptions;
//  ContourCount: integer;
  Contour: TContourObjectOptions;
  ContourIndex: ANE_INT32;
  Indicies: TStreamParamIndicies;
  //  ICALC_Index: ANE_INT32;
  TimeIndicies: array of TStreamTimeParamIndicies;
  TableIndicies: array of TTableParamIndicies;
  TimeCount: integer;
  TimeIndex: integer;
  IsParam: boolean;
  ParameterName: string;
  ParameterObject: TStreamParameterObject;
  Segment: TSegment;
  TimesToUse: integer;
  TableCount: integer;
  TableIndex: integer;
  ErrorMessage: string;
begin
  ContourCount := 0;
  if frmModflow.cbSFRCalcFlow.Checked and frmModflow.Simulated(UnitIndex) then
  begin
    LayerName := ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle, LayerName);
    Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
    try
      GetStreamParameterIndicies(Layer, Indicies, False);

      TimeCount := frmModflow.dgTime.RowCount - 1;

      SetLength(TimeIndicies, TimeCount);
      for TimeIndex := 0 to TimeCount - 1 do
      begin
        GetStreamTimeParameterIndicies(Layer, TimeIndicies[TimeIndex], TimeIndex
          + 1);
      end;

      TableCount := StrToInt(frmModflow.adeStreamTableEntriesCount.Text);
      SetLength(TableIndicies, TableCount);
      for TableIndex := 0 to TableCount - 1 do
      begin
        GetTableParameterIndicies(Layer, TableIndicies[TableIndex], TableIndex +
          1);
      end;

      ContourCount := Layer.NumObjects(CurrentModelHandle, pieContourObject);
      for ContourIndex := 0 to ContourCount - 1 do
      begin
        Contour := TContourObjectOptions.Create(CurrentModelHandle,
          Layer.LayerHandle, ContourIndex);
        try
          if Contour.ContourType(CurrentModelHandle) <> ctOpen then
          begin
            Inc(TableStreamErrors);
          end
          else
          begin
            Segment := TSegment.Create;
            Segment.ICALC := 4;
            AssignGageParametersToSegment(Contour, Segment, Indicies);

            {Segment.IsGage := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsGageIndex);
            Segment.GageOutputType := Contour.GetIntegerParameter(
              CurrentModelHandle, Indicies.GageOutputTypeIndex);   }
            IsParam := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsParameterIndex);
            if IsParam then
            begin
              ParameterName := UpperCase(Contour.GetStringParameter
                (CurrentModelHandle, Indicies.ParameterNameIndex));
              if Length(ParameterName) > 10 then
              begin
                SetLength(ParameterName, 10);
              end;
              ParameterObject :=
                ParameterList.GetParameterByName(ParameterName);
              if ParameterObject = nil then
              begin
                if InvalidParameters.IndexOf(ParameterName) < 0 then
                begin
                  ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
                    + ' in the SFR package.  Contours using this parameter name will be '
                    + 'ignored.';
                  ErrorMessages.Add(ErrorMessage);
                  frmProgress.reErrors.Lines.Add(ErrorMessage);
                  InvalidParameters.Add(ParameterName);
                end;
                TimesToUse := TimeCount;
              end
              else
              begin
                ParameterObject.SegmentList.Add(Segment);
                TimesToUse := ParameterObject.Instances.Count;
                if TimesToUse <= 0 then
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
            GetStreamSegmentValues(Indicies, Segment, Contour);
            for TimeIndex := 0 to TimesToUse - 1 do
            begin
              GetStreamTimeParameterValues(TimeIndicies[TimeIndex],
                Segment, Contour, TimeIndex);
            end;
            for TableIndex := 0 to TableCount - 1 do
            begin
              GetTableParameterValues(TableIndicies[TableIndex],
                Segment, Contour);
            end;
            AddCells(Segment, ContourIndex, UnitIndex, Layer, Indicies);
          end;
        finally
          Contour.Free;
        end;
      end;
    finally
      Layer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TStreamWriter.EvaluateFormulaStreamLayer(const UnitIndex: integer;
  out ContourCount: integer);
var
  LayerName: string;
  Layer: TLayerOptions;
//  ContourCount: integer;
  Contour: TContourObjectOptions;
  ContourIndex: ANE_INT32;
  Indicies: TStreamParamIndicies;
  //  ICALC_Index: ANE_INT32;
  TimeIndicies: array of TStreamTimeParamIndicies;
  FormulaTimeIndicies: array of TFormulaTimeParamIndicies;
  TimeCount: integer;
  TimeIndex: integer;
  IsParam: boolean;
  ParameterName: string;
  ParameterObject: TStreamParameterObject;
  Segment: TSegment;
  TimesToUse: integer;
  ErrorMessage: string;
begin
  ContourCount := 0;
  if frmModflow.cbSFRCalcFlow.Checked and frmModflow.Simulated(UnitIndex) then
  begin
    LayerName := ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle, LayerName);
    Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
    try
      GetStreamParameterIndicies(Layer, Indicies, False);

      TimeCount := frmModflow.dgTime.RowCount - 1;

      SetLength(TimeIndicies, TimeCount);
      SetLength(FormulaTimeIndicies, TimeCount);
      for TimeIndex := 0 to TimeCount - 1 do
      begin
        GetStreamTimeParameterIndicies(Layer, TimeIndicies[TimeIndex], TimeIndex
          + 1);
        GetFormulaTimeParameterIndicies(Layer, FormulaTimeIndicies[TimeIndex],
          TimeIndex + 1);
      end;

      ContourCount := Layer.NumObjects(CurrentModelHandle, pieContourObject);
      for ContourIndex := 0 to ContourCount - 1 do
      begin
        Contour := TContourObjectOptions.Create(CurrentModelHandle,
          Layer.LayerHandle, ContourIndex);
        try
          if Contour.ContourType(CurrentModelHandle) <> ctOpen then
          begin
            Inc(FormulaStreamErrors);
          end
          else
          begin
            Segment := TSegment.Create;
            Segment.ICALC := 3;
            AssignGageParametersToSegment(Contour, Segment, Indicies);

            {Segment.IsGage := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsGageIndex);
            Segment.GageOutputType := Contour.GetIntegerParameter(
              CurrentModelHandle, Indicies.GageOutputTypeIndex);  }
            IsParam := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsParameterIndex);
            if IsParam then
            begin
              ParameterName := UpperCase(Contour.GetStringParameter
                (CurrentModelHandle, Indicies.ParameterNameIndex));
              if Length(ParameterName) > 10 then
              begin
                SetLength(ParameterName, 10);
              end;
              ParameterObject :=
                ParameterList.GetParameterByName(ParameterName);
              if ParameterObject = nil then
              begin
                if InvalidParameters.IndexOf(ParameterName) < 0 then
                begin
                  ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
                    + ' in the SFR package.  Contours using this parameter name will be '
                    + 'ignored.';
                  ErrorMessages.Add(ErrorMessage);
                  frmProgress.reErrors.Lines.Add(ErrorMessage);
                  InvalidParameters.Add(ParameterName);
                end;
                TimesToUse := TimeCount;
              end
              else
              begin
                ParameterObject.SegmentList.Add(Segment);
                TimesToUse := ParameterObject.Instances.Count;
                if TimesToUse <= 0 then
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
            GetStreamSegmentValues(Indicies, Segment, Contour);
            //            GetSimpleStreamSegmentICALC(ICALC_Index, Segment, Contour);
            for TimeIndex := 0 to TimesToUse - 1 do
            begin
              GetStreamTimeParameterValues(TimeIndicies[TimeIndex],
                Segment, Contour, TimeIndex);
              GetFormulaTimeParameterValues(FormulaTimeIndicies[TimeIndex],
                Segment, Contour);
            end;
            AddCells(Segment, ContourIndex, UnitIndex, Layer, Indicies);
          end;
        finally
          Contour.Free;
        end;
      end;
    finally
      Layer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TStreamWriter.Evaluate8PointCrossSectionStreamLayer(const UnitIndex:
  integer; out ContourCount: integer);
var
  LayerName: string;
  Layer: TLayerOptions;
//  ContourCount: integer;
  Contour: TContourObjectOptions;
  ContourIndex: ANE_INT32;
  Indicies: TStreamParamIndicies;
  //  ICALC_Index: ANE_INT32;
  TimeIndicies: array of TStreamTimeParamIndicies;
  //  SimpleTimeIndicies : array of TSimpleStreamTimeParamIndicies;
  ChannelRoughnessIndicies: array of TCrossSectionTimeParamIndicies;
  CrossSectionIndicies: array[1..MaxCrossSectionPts] of
    TCrossSectionParamIndicies;
  TimeCount: integer;
  TimeIndex: integer;
  IsParam: boolean;
  ParameterName: string;
  ParameterObject: TStreamParameterObject;
  Segment: TSegment;
  TimesToUse: integer;
  PositionIndex: integer;
  ErrorMessage: string;
begin
  ContourCount := 0;
  if frmModflow.cbSFRCalcFlow.Checked and frmModflow.Simulated(UnitIndex) then
  begin
    LayerName := ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle, LayerName);
    Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
    try
      GetStreamParameterIndicies(Layer, Indicies, True);

      TimeCount := frmModflow.dgTime.RowCount - 1;

      SetLength(TimeIndicies, TimeCount);
      SetLength(ChannelRoughnessIndicies, TimeCount);
      for TimeIndex := 0 to TimeCount - 1 do
      begin
        GetStreamTimeParameterIndicies
          (Layer, TimeIndicies[TimeIndex], TimeIndex + 1);
        GetChannelTimeParameterIndecies(Layer,
          ChannelRoughnessIndicies[TimeIndex], TimeIndex + 1);
      end;

      for PositionIndex := 1 to MaxCrossSectionPts do
      begin
        GetCrossSectionParameterIndicies(Layer,
          CrossSectionIndicies[PositionIndex], PositionIndex);
      end;

      ContourCount := Layer.NumObjects(CurrentModelHandle, pieContourObject);
      for ContourIndex := 0 to ContourCount - 1 do
      begin
        Contour := TContourObjectOptions.Create(CurrentModelHandle,
          Layer.LayerHandle, ContourIndex);
        try
          if Contour.ContourType(CurrentModelHandle) <> ctOpen then
          begin
            Inc(EightPointStreamErrors);
          end
          else
          begin
            Segment := TSegment.Create;
            Segment.ICALC := 2;
            AssignGageParametersToSegment(Contour, Segment, Indicies);
            {Segment.IsGage := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsGageIndex);
            Segment.GageOutputType := Contour.GetIntegerParameter(
              CurrentModelHandle, Indicies.GageOutputTypeIndex);  }
            IsParam := Contour.GetBoolParameter(CurrentModelHandle,
              Indicies.IsParameterIndex);
            if IsParam then
            begin
              ParameterName := UpperCase(Contour.GetStringParameter
                (CurrentModelHandle, Indicies.ParameterNameIndex));
              if Length(ParameterName) > 10 then
              begin
                SetLength(ParameterName, 10);
              end;
              ParameterObject :=
                ParameterList.GetParameterByName(ParameterName);
              if ParameterObject = nil then
              begin
                if InvalidParameters.IndexOf(ParameterName) < 0 then
                begin
                  ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
                    + ' in the SFR package.  Contours using this parameter name will be '
                    + 'ignored.';
                  ErrorMessages.Add(ErrorMessage);
                  frmProgress.reErrors.Lines.Add(ErrorMessage);
                  InvalidParameters.Add(ParameterName);
                end;
                TimesToUse := TimeCount;
              end
              else
              begin
                ParameterObject.SegmentList.Add(Segment);
                TimesToUse := ParameterObject.Instances.Count;
                if TimesToUse <= 0 then
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
            GetStreamSegmentValues(Indicies, Segment, Contour);
            for PositionIndex := 1 to MaxCrossSectionPts do
            begin
              GetCrossSectionParameterValues
                (CrossSectionIndicies[PositionIndex],
                Segment, Contour, PositionIndex);
            end;
            for TimeIndex := 0 to TimesToUse - 1 do
            begin
              GetStreamTimeParameterValues(TimeIndicies[TimeIndex],
                Segment, Contour, TimeIndex);
              GetChannelTimeValues(ChannelRoughnessIndicies[TimeIndex],
                Segment, Contour);
            end;
            AddCells(Segment, ContourIndex, UnitIndex, Layer, Indicies);
          end;
        finally
          Contour.Free;
        end;
      end;
    finally
      Layer.Free(CurrentModelHandle);
    end;
  end;
end;

function TStreamWriter.GetSegment(Index: integer): TSegment;
begin
  result := ListOfSegments[Index];
end;

procedure TStreamWriter.GetSimpleStreamSegmentICALC(
  const ICALC_Index: ANE_INT32; const Segment: TSegment;
  const Contour: TContourObjectOptions);
begin
  if ICALC_Index > -1 then
  begin
    Segment.ICALC := Contour.GetIntegerParameter(CurrentModelHandle,
      ICALC_Index);
  end
  else
  begin
    Segment.ICALC := 0;
  end;
end;

procedure TStreamWriter.GetCrossSectionParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TCrossSectionParamIndicies;
  const PositionIndex: integer);
var
  PositionString: string;
  ParameterName: string;
begin
  PositionString := IntToStr(PositionIndex);

  ParameterName := ModflowTypes.GetMF2KCrossSectionXParamType.ANE_ParamName +
    PositionString;
  Indicies.XIndex := Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
  Assert(Indicies.XIndex > -1);

  ParameterName := ModflowTypes.GetMF2KCrossSectionZParamType.ANE_ParamName +
    PositionString;
  Indicies.ZIndex := Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
  Assert(Indicies.ZIndex > -1);
end;

procedure TStreamWriter.GetFormulaTimeParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TFormulaTimeParamIndicies;
  const TimeIndex: integer);
var
  TimeString: string;
  ParameterName: string;
begin
  TimeString := IntToStr(TimeIndex);

  ParameterName := ModflowTypes.GetMF2KDepthCoefficientParamType.ANE_ParamName +
    TimeString;
  Indicies.DepthCoefficientIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.DepthCoefficientIndex > -1);

  ParameterName := ModflowTypes.GetMF2KWidthCoefficientParamType.ANE_ParamName +
    TimeString;
  Indicies.WidthCoefficientIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.WidthCoefficientIndex > -1);

  ParameterName := ModflowTypes.GetMF2KDepthExponentParamType.ANE_ParamName +
    TimeString;
  Indicies.DepthExponentIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.DepthExponentIndex > -1);

  ParameterName := ModflowTypes.GetMF2KWidthExponentParamType.ANE_ParamName +
    TimeString;
  Indicies.WidthExponentIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.WidthExponentIndex > -1);
end;

procedure TStreamWriter.GetTableParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TTableParamIndicies;
  const PositionIndex: integer);
var
  PositionString: string;
  ParameterName: string;
begin
  PositionString := IntToStr(PositionIndex);

  ParameterName := ModflowTypes.GetMF2KTableFlowParamType.ANE_ParamName +
    PositionString;
  Indicies.FlowIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.FlowIndex > -1);

  ParameterName := ModflowTypes.GetMF2KTableWidthParamType.ANE_ParamName +
    PositionString;
  Indicies.WidthIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.WidthIndex > -1);

  ParameterName := ModflowTypes.GetMF2KTableDepthParamType.ANE_ParamName +
    PositionString;
  Indicies.DepthIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.DepthIndex > -1);
end;

procedure TStreamWriter.GetSimpleStreamTimeParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TSimpleStreamTimeParamIndicies;
  const TimeIndex: integer);
var
  TimeString: string;
  ParameterName: string;
begin
  TimeString := IntToStr(TimeIndex);

  ParameterName := ModflowTypes.GetMF2KUpsteamDepthParamType.ANE_ParamName +
    TimeString;
  Indicies.UpsteamDepthIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.UpsteamDepthIndex > -1);

  ParameterName := ModflowTypes.GetMF2KDownstreamDepthParamType.ANE_ParamName +
    TimeString;
  Indicies.DownstreamDepthIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.DownstreamDepthIndex > -1);

  ParameterName := ModflowTypes.GetMFSKStreamUpWidthParamType.ANE_ParamName +
    TimeString;
  Indicies.UpstreamWidthIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.UpstreamWidthIndex > -1);

  ParameterName := ModflowTypes.GetMF2KStreamDownWidthParamType.ANE_ParamName +
    TimeString;
  Indicies.DownstreamWidthIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.DownstreamWidthIndex > -1);

  GetChannelRoughnessIndex(Layer, Indicies.RoughnessIndex, TimeIndex);
  {  if frmModflow.cbStreamCalcFlow.Checked then
    begin
      ParameterName := ModflowTypes.GetMF2KChanelRoughnessParamType.ANE_ParamName + TimeString;
      Indicies.RoughnessIndex := Layer.GetParameterIndex(CurrentModelHandle,ParameterName);
      Assert(Indicies.RoughnessIndex > -1);
    end
    else
    begin
      Indicies.RoughnessIndex := -1;
    end;   }
end;

procedure TStreamWriter.GetStreamTimeParameterValues(
  const Indicies: TStreamTimeParamIndicies; const Segment: TSegment;
  const Contour: TContourObjectOptions; const TimeIndex: integer);
var
  Concentrations: TConcentrationRecord;
begin
  if Indicies.OnOffParamIndex >= 0 then
  begin
    Segment.Active[TimeIndex] := Contour.GetBoolParameter(CurrentModelHandle,
      Indicies.OnOffParamIndex);
  end
  else
  begin
    Segment.Active[TimeIndex] := True;
  end;

  Segment.Flow.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.StreamFlowParamIndex));

  if Indicies.StreamUpTopElevParamIndex >= 0 then
  begin
    Segment.UpstreamBedElevation.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.StreamUpTopElevParamIndex));
  end;

  if Indicies.DownstreamTopElevationParamIndex >= 0 then
  begin
    Segment.DownstreamBedElevation.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamTopElevationParamIndex));
  end;

  if Indicies.UpstreamBedThicknessParamIndex >= 0 then
  begin
    Segment.UpstreamBedThickness.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamBedThicknessParamIndex));
  end;

  if Indicies.DownstreamBedThicknessParamIndex >= 0 then
  begin
    Segment.DownstreamBedThickness.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamBedThicknessParamIndex));
  end;

  Segment.Evaporation.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.ETExtFluxParamIndex));

  Segment.Precipitation.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.PrecipitationParamIndex));

  Segment.RunOff.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.RunoffParamIndex));

  if Indicies.IFACEParamIndex > -1 then
  begin
    Segment.IFACE.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.IFACEParamIndex));
  end;

  if (Indicies.FlowConcentrationParamIndex > -1)
    and (Indicies.PrecipitationConcentrationParamIndex > -1)
    and (Indicies.RunoffConcentrationParamIndex > -1) then
  begin
    Concentrations.InflowConcentration :=
      Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.FlowConcentrationParamIndex);
    Concentrations.PrecipitationConcentration :=
      Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.PrecipitationConcentrationParamIndex);
    Concentrations.RunoffConcentration :=
      Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.RunoffConcentrationParamIndex);
    Segment.ConcentrationList.Add(Concentrations);
  end;

{  if Indicies.UpstreamSaturatedWaterContentParamIndex > -1 then
  begin
    Segment.UpstreamSaturatedWaterContent.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.UpstreamSaturatedWaterContentParamIndex));
  end;

  if Indicies.UpstreamInitialWaterContentParamIndex > -1 then
  begin
    Segment.UpstreamInitialWaterContent.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.UpstreamInitialWaterContentParamIndex));
  end;

  if Indicies.UpstreamBrooksCoreyExponentParamIndex > -1 then
  begin
    Segment.UpstreamBrooksCoreyExponent.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.UpstreamBrooksCoreyExponentParamIndex));
  end;

  if Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex > -1 then
  begin
    Segment.UpstreamUnsatZoneHydraulicConductivity.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex));
  end;

  if Indicies.DownstreamSaturatedWaterContentParamIndex > -1 then
  begin
    Segment.DownstreamSaturatedWaterContent.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.DownstreamSaturatedWaterContentParamIndex));
  end;

  if Indicies.DownstreamInitialWaterContentParamIndex > -1 then
  begin
    Segment.DownstreamInitialWaterContent.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.DownstreamInitialWaterContentParamIndex));
  end;

  if Indicies.DownstreamBrooksCoreyExponentParamIndex > -1 then
  begin
    Segment.DownstreamBrooksCoreyExponent.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.DownstreamBrooksCoreyExponentParamIndex));
  end;

  if Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex > -1 then
  begin
    Segment.DownstreamUnsatZoneHydraulicConductivity.Add(Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex));
  end; }
end;

procedure TStreamWriter.GetChannelTimeValues(
  const Indicies: TCrossSectionTimeParamIndicies; const Segment: TSegment;
  const Contour: TContourObjectOptions);
begin
  if Indicies.BankRoughnessIndex > -1 then
  begin
    Segment.OverBankRoughness.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.BankRoughnessIndex));
  end;

  GetChannelRoughness(Indicies.ChannelRoughnessIndex, Segment, Contour);
end;

procedure TStreamWriter.GetChannelRoughness(
  const RoughnessIndex: ANE_INT32; const Segment: TSegment;
  const Contour: TContourObjectOptions);
begin
  if RoughnessIndex > -1 then
  begin
    Segment.ChannelRoughness.Add(Contour.GetFloatParameter(CurrentModelHandle,
      RoughnessIndex));
  end;
end;

procedure TStreamWriter.GetFormulaTimeParameterValues(
  const Indicies: TFormulaTimeParamIndicies; const Segment: TSegment;
  const Contour: TContourObjectOptions);
begin
  Segment.DepthCoefficient.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DepthCoefficientIndex));

  Segment.WidthCoefficient.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.WidthCoefficientIndex));

  Segment.DepthExponent.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DepthExponentIndex));

  Segment.WidthExponent.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.WidthExponentIndex));
end;

procedure TStreamWriter.GetTableParameterValues(
  const Indicies: TTableParamIndicies; const Segment: TSegment;
  const Contour: TContourObjectOptions);
var
  FlowRecord: TFlowTableRecord;
begin
  FlowRecord.Flow := Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.FlowIndex);
  FlowRecord.Width := Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.WidthIndex);
  FlowRecord.Depth := Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DepthIndex);

  Segment.FlowTableList.Add(FlowRecord);
end;

procedure TStreamWriter.GetSimpleStreamTimeParameterValues(
  const Indicies: TSimpleStreamTimeParamIndicies; const Segment: TSegment;
  const Contour: TContourObjectOptions);
begin
  Segment.UpstreamDepth.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.UpsteamDepthIndex));

  Segment.DownstreamDepth.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DownstreamDepthIndex));

  Segment.UpstreamWidth.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.UpstreamWidthIndex));

  Segment.DownstreamWidth.Add(Contour.GetFloatParameter(CurrentModelHandle,
    Indicies.DownstreamWidthIndex));

  GetChannelRoughness(Indicies.RoughnessIndex, Segment, Contour);
end;

procedure TStreamWriter.GetStreamICALC_Index(const Layer: TLayerOptions;
  var ICALC_Index: ANE_INT32);
var
  ParameterName: string;
begin
  if frmModflow.cbSFRCalcFlow.Checked then
  begin
    ParameterName := ModflowTypes.GetMF2K_ICALC_ParamType.ANE_ParamName;
    ICALC_Index := Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(ICALC_Index > -1);
  end
  else
  begin
    ICALC_Index := -1;
  end;
end;

procedure TStreamWriter.GetStreamParameterIndicies(const Layer: TLayerOptions;
  var Indicies: TStreamParamIndicies; const IsUnsatLayer: boolean);
var
  ParameterName: string;
begin
  ParameterName :=
    ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  Indicies.ParameterNameIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.ParameterNameIndex > -1);

  ParameterName := ModflowTypes.GetMFIsParameterParamType.ANE_ParamName;
  Indicies.IsParameterIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.IsParameterIndex > -1);

  ParameterName := ModflowTypes.GetMFGageParamType.ANE_ParamName;
  Indicies.IsGageIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.IsGageIndex > -1);

  ParameterName := ModflowTypes.GetMFStreamGageOutputTypeParamType.ANE_ParamName;
  Indicies.GageOutputTypeIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.GageOutputTypeIndex > -1);

  if frmModflow.cbSFRDiversions.Checked then
  begin
    ParameterName := ModflowTypes.GetMFGageDiversioParamType.ANE_ParamName;
    Indicies.DiversionGageIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.DiversionGageIndex > -1);
  end
  else
  begin
    Indicies.DiversionGageIndex := -1;
  end;

  if (frmModflow.ISFROPT in [2,3,4,5]) and IsUnsatLayer then
  begin
    ParameterName := ModflowTypes.GetMFUnsatGageParamType.ANE_ParamName;
    Indicies.UnsatFlowIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.UnsatFlowIndex > -1);

    ParameterName := ModflowTypes.GetMFUnsatProfileGageParamType.ANE_ParamName;
    Indicies.UnsatFlowProfileIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.UnsatFlowProfileIndex > -1);
  end
  else
  begin
    Indicies.UnsatFlowIndex := -1;
    Indicies.UnsatFlowProfileIndex := -1;
  end;

  ParameterName := ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName;
  Indicies.SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.SegmentNumberIndex > -1);

  if frmMODFLOW.cbSFRTrib.Checked then
  begin
    ParameterName := ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName;
    Indicies.DownstreamSegmentNumberIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamSegmentNumberIndex > -1);
  end
  else
  begin
    Indicies.DownstreamSegmentNumberIndex := -1;
  end;

  if frmModflow.ISFROPT in [1,2,3] then
  begin
{    ParameterName := ModflowTypes.GetMFStreamHydCondParamType.ANE_ParamName;
    Indicies.UpstreamKIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.UpstreamKIndex > -1);}

    Indicies.UpstreamKIndex := -1;
    Indicies.DownstreamKIndex := -1;
  end
  else
  begin
    ParameterName := ModflowTypes.GetMF2KUpstreamKParamType.ANE_ParamName;
    Indicies.UpstreamKIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.UpstreamKIndex > -1);

    ParameterName := ModflowTypes.GetMF2KDownstreamKParamType.ANE_ParamName;
    Indicies.DownstreamKIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.DownstreamKIndex > -1);
  end;


  if frmMODFLOW.cbSFRDiversions.Checked then
  begin
    ParameterName := ModflowTypes.GetMF2KStreamDivSegNumParamType.ANE_ParamName;
    Indicies.DiversionSegmentNumberIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DiversionSegmentNumberIndex > -1);

    ParameterName := ModflowTypes.GetMF2KStreamPriorityParamType.ANE_ParamName;
    Indicies.StreamPriorityIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.StreamPriorityIndex > -1);
  end
  else
  begin
    Indicies.DiversionSegmentNumberIndex := -1;
    Indicies.StreamPriorityIndex := -1;
  end;

  //SFR2
  if frmModflow.ISFROPT in [1,2,3] then
  begin
    ParameterName := ModflowTypes.GetMFSfr2StreambedTopElevParamType.ANE_ParamName;
    Indicies.StreamTopName := ParameterName;

    ParameterName := ModflowTypes.GetMFStreamSlopeParamType.ANE_ParamName;
    Indicies.StreamSlopeName := ParameterName;

    ParameterName := ModflowTypes.GetMFSfr2StreambedThicknessParamType.ANE_ParamName;
    Indicies.StreamBedThicknessName := ParameterName;

    ParameterName := ModflowTypes.GetMFStreamHydCondParamType.ANE_ParamName;
    Indicies.StreamHydraulicConductivityName := ParameterName;
  end
  else
  begin
    Indicies.StreamTopName := '';
    Indicies.StreamSlopeName := '';
    Indicies.StreamBedThicknessName := '';
    Indicies.StreamHydraulicConductivityName := '';
  end;

  if (frmModflow.ISFROPT in [2,3]) and IsUnsatLayer then
  begin
    ParameterName := ModflowTypes.GetMFSfr2SaturatedWaterContentParamType.ANE_ParamName;
    Indicies.StreamSaturatedWaterContentName := ParameterName;

    ParameterName := ModflowTypes.GetMFSfr2InitialWaterContentParamType.ANE_ParamName;
    Indicies.StreamInitialWaterContentName := ParameterName;

    ParameterName := ModflowTypes.GetMFSfr2BrooksCoreyExponentParamType.ANE_ParamName;
    Indicies.StreamBrooksCoreyName := ParameterName;
  end
  else
  begin
    Indicies.StreamSaturatedWaterContentName := '';
    Indicies.StreamInitialWaterContentName := '';
    Indicies.StreamBrooksCoreyName := '';
  end;

  if (frmModflow.ISFROPT = 3) and IsUnsatLayer then
  begin
    ParameterName := ModflowTypes.GetMFSfr2UnsatZoneHydraulicConductivityParamType.ANE_ParamName;
    Indicies.StreamUnsatZoneHydraulicConductivityName := ParameterName;
  end
  else
  begin
    Indicies.StreamUnsatZoneHydraulicConductivityName := '';
  end;

  if (not IsUnsatLayer) or ((frmModflow.ISFROPT in [4,5]) and IsUnsatLayer) then
  begin
{    ParameterName := ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName;
    Indicies.StreamUpTopElevParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.StreamUpTopElevParamIndex > -1);

    ParameterName := ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName;
    Indicies.DownstreamTopElevationParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamTopElevationParamIndex > -1); }

{    ParameterName := ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName;
    Indicies.UpstreamBedThicknessParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamBedThicknessParamIndex > -1);

    ParameterName := ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName;
    Indicies.DownstreamBedThicknessParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamBedThicknessParamIndex > -1);  }
  end
  else
  begin
//    Indicies.StreamUpTopElevParamIndex := -1;
//    Indicies.DownstreamTopElevationParamIndex := -1;
//    Indicies.UpstreamBedThicknessParamIndex := -1;
//    Indicies.DownstreamBedThicknessParamIndex := -1;
  end;

  if (frmModflow.ISFROPT in [4,5]) and IsUnsatLayer then
  begin
    ParameterName := ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType.ANE_ParamName;
    Indicies.UpstreamSaturatedWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamSaturatedWaterContentParamIndex > -1);

    ParameterName := ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType.ANE_ParamName;
    Indicies.DownstreamSaturatedWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamSaturatedWaterContentParamIndex > -1);

    ParameterName := ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType.ANE_ParamName;
    Indicies.UpstreamInitialWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamInitialWaterContentParamIndex > -1);

    ParameterName := ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType.ANE_ParamName;
    Indicies.DownstreamInitialWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamInitialWaterContentParamIndex > -1);

    ParameterName := ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType.ANE_ParamName;
    Indicies.UpstreamBrooksCoreyExponentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamBrooksCoreyExponentParamIndex > -1);

    ParameterName := ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType.ANE_ParamName;
    Indicies.DownstreamBrooksCoreyExponentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamBrooksCoreyExponentParamIndex > -1);
  end
  else
  begin
    Indicies.UpstreamSaturatedWaterContentParamIndex := -1;
    Indicies.DownstreamSaturatedWaterContentParamIndex := -1;
    Indicies.UpstreamInitialWaterContentParamIndex := -1;
    Indicies.DownstreamInitialWaterContentParamIndex := -1;
    Indicies.UpstreamBrooksCoreyExponentParamIndex := -1;
    Indicies.DownstreamBrooksCoreyExponentParamIndex := -1;
  end;

  if (frmModflow.ISFROPT = 5) and IsUnsatLayer then
  begin
    ParameterName := ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName;
    Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex > -1);

    ParameterName := ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName;
    Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex > -1);
  end
  else
  begin
    Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex := -1;
    Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex := -1;
  end;

end;

procedure TStreamWriter.GetStreamSegmentValues(
  const Indicies: TStreamParamIndicies; const Segment: TSegment;
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

  if Indicies.UpstreamKIndex >= 0 then
  begin
    Segment.UpstreamK := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamKIndex);
  end;

  if Indicies.DownstreamKIndex >= 0 then
  begin
    Segment.DownstreamK := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamKIndex);
  end;

  if Indicies.StreamPriorityIndex > -1 then
  begin
    Segment.DiversionPriority := Contour.GetIntegerParameter(CurrentModelHandle,
      Indicies.StreamPriorityIndex);
  end
  else
  begin
    Segment.DiversionPriority := 0;
  end;




{  if Indicies.StreamUpTopElevParamIndex > -1 then
  begin
    Segment.UpstreamBedElevation.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.StreamUpTopElevParamIndex));
  end;

  if Indicies.DownstreamTopElevationParamIndex > -1 then
  begin
    Segment.DownstreamBedElevation.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamTopElevationParamIndex));
  end;   }

{  if Indicies.UpstreamBedThicknessParamIndex > -1 then
  begin
    Segment.UpstreamBedThickness.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamBedThicknessParamIndex));
  end;

  if Indicies.DownstreamBedThicknessParamIndex > -1 then
  begin
    Segment.DownstreamBedThickness.Add(Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamBedThicknessParamIndex));
  end;  }

  if Indicies.UpstreamSaturatedWaterContentParamIndex > -1 then
  begin
    Segment.UpstreamSaturatedWaterContent := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamSaturatedWaterContentParamIndex);
  end
  else
  begin
    Segment.UpstreamSaturatedWaterContent := 0;
  end;

  if Indicies.DownstreamSaturatedWaterContentParamIndex > -1 then
  begin
    Segment.DownstreamSaturatedWaterContent := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamSaturatedWaterContentParamIndex);
  end
  else
  begin
    Segment.DownstreamSaturatedWaterContent := 0;
  end;

  if Indicies.UpstreamInitialWaterContentParamIndex > -1 then
  begin
    Segment.UpstreamInitialWaterContent := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamInitialWaterContentParamIndex);
  end
  else
  begin
    Segment.UpstreamInitialWaterContent := 0;
  end;

  if Indicies.DownstreamInitialWaterContentParamIndex > -1 then
  begin
    Segment.DownstreamInitialWaterContent := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamInitialWaterContentParamIndex);
  end
  else
  begin
    Segment.DownstreamInitialWaterContent := 0;
  end;

  if Indicies.UpstreamBrooksCoreyExponentParamIndex > -1 then
  begin
    Segment.UpstreamBrooksCoreyExponent := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamBrooksCoreyExponentParamIndex);
  end
  else
  begin
    Segment.UpstreamBrooksCoreyExponent := 0;
  end;

  if Indicies.DownstreamBrooksCoreyExponentParamIndex > -1 then
  begin
    Segment.DownstreamBrooksCoreyExponent := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamBrooksCoreyExponentParamIndex);
  end
  else
  begin
    Segment.DownstreamBrooksCoreyExponent := 0;
  end;

  if Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex > -1 then
  begin
    Segment.UpstreamUnsatZoneHydraulicConductivity := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex);
  end
  else
  begin
    Segment.UpstreamUnsatZoneHydraulicConductivity := 0;
  end;

  if Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex > -1 then
  begin
    Segment.DownstreamUnsatZoneHydraulicConductivity := Contour.GetFloatParameter(CurrentModelHandle,
      Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex);
  end
  else
  begin
    Segment.DownstreamUnsatZoneHydraulicConductivity := 0;
  end;
end;

procedure TStreamWriter.GetStreamTimeParameterIndicies(
  const Layer: TLayerOptions; var Indicies: TStreamTimeParamIndicies;
  const TimeIndex: integer);
var
  TimeString: string;
  ParameterName: string;
begin
  TimeString := IntToStr(TimeIndex);

  if frmModflow.ISFROPT in [0,4,5] then
  begin
    ParameterName := ModflowTypes.GetMFOnOffParamType.ANE_ParamName + TimeString;
    Indicies.OnOffParamIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.OnOffParamIndex > -1);
  end
  else
  begin
    Indicies.OnOffParamIndex := -1;
  end;


  ParameterName := ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName +
    TimeString;
  Indicies.StreamFlowParamIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.StreamFlowParamIndex > -1);

//  if frmModflow.ISFROPT = 0 then
  if frmModflow.ISFROPT in [0,4,5] then
  begin
    ParameterName := ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName +
      TimeString;
    Indicies.StreamUpTopElevParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.StreamUpTopElevParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName +
      TimeString;
    Indicies.DownstreamTopElevationParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamTopElevationParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName + TimeString;
    Indicies.UpstreamBedThicknessParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamBedThicknessParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName +
      TimeString;
    Indicies.DownstreamBedThicknessParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamBedThicknessParamIndex > -1);
  end
  else
  begin
    Indicies.StreamUpTopElevParamIndex := -1;
    Indicies.DownstreamTopElevationParamIndex := -1;
    Indicies.UpstreamBedThicknessParamIndex := -1;
    Indicies.DownstreamBedThicknessParamIndex := -1;
  end;

  ParameterName := ModflowTypes.GetMF2KStreamEvapParamType.ANE_ParamName +
    TimeString;
  Indicies.ETExtFluxParamIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.ETExtFluxParamIndex > -1);

  ParameterName := ModflowTypes.GetMF2KPrecipitationParamType.ANE_ParamName +
    TimeString;
  Indicies.PrecipitationParamIndex :=
    Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
  Assert(Indicies.PrecipitationParamIndex > -1);

  ParameterName := ModflowTypes.GetMF2KRunoffParamType.ANE_ParamName +
    TimeString;
  Indicies.RunoffParamIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.RunoffParamIndex > -1);

  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ParameterName := ModflowTypes.GetMFIFACEParamType.ANE_ParamName +
      TimeString;
    Indicies.IFACEParamIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(Indicies.IFACEParamIndex > -1);
  end
  else
  begin
    Indicies.IFACEParamIndex := -1;
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ParameterName := ModflowTypes.GetMF2KFlowConcentrationParamType.ANE_ParamName
      + TimeString;
    Indicies.FlowConcentrationParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.FlowConcentrationParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMF2KPrecipitationConcentrationParamType.ANE_ParamName +
      TimeString;
    Indicies.PrecipitationConcentrationParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.PrecipitationConcentrationParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMF2KRunoffConcentrationParamType.ANE_ParamName + TimeString;
    Indicies.RunoffConcentrationParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.RunoffConcentrationParamIndex > -1);
  end
  else
  begin
    Indicies.FlowConcentrationParamIndex := -1;
    Indicies.PrecipitationConcentrationParamIndex := -1;
    Indicies.RunoffConcentrationParamIndex := -1;
  end;

  // SFR2
{  if frmModflow.ISFROPT in [4,5] then
  begin
    ParameterName := ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType.ANE_ParamName +
      TimeString;
    Indicies.UpstreamSaturatedWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamSaturatedWaterContentParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType.ANE_ParamName +
      TimeString;
    Indicies.DownstreamSaturatedWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamSaturatedWaterContentParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType.ANE_ParamName + TimeString;
    Indicies.UpstreamInitialWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamInitialWaterContentParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType.ANE_ParamName +
      TimeString;
    Indicies.DownstreamInitialWaterContentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamInitialWaterContentParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType.ANE_ParamName +
      TimeString;
    Indicies.UpstreamBrooksCoreyExponentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamBrooksCoreyExponentParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType.ANE_ParamName +
      TimeString;
    Indicies.DownstreamBrooksCoreyExponentParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamBrooksCoreyExponentParamIndex > -1);
  end
  else
  begin
    Indicies.UpstreamSaturatedWaterContentParamIndex := -1;
    Indicies.DownstreamSaturatedWaterContentParamIndex := -1;
    Indicies.UpstreamInitialWaterContentParamIndex := -1;
    Indicies.DownstreamInitialWaterContentParamIndex := -1;
    Indicies.UpstreamBrooksCoreyExponentParamIndex := -1;
    Indicies.DownstreamBrooksCoreyExponentParamIndex := -1;
  end;

  if frmModflow.ISFROPT = 5 then
  begin
    ParameterName :=
      ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName +
      TimeString;
    Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex > -1);

    ParameterName :=
      ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName +
      TimeString;
    Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex :=
      Layer.GetParameterIndex(CurrentModelHandle, ParameterName);
    Assert(Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex > -1);
  end
  else
  begin
    Indicies.UpstreamUnsatZoneHydraulicConductivityParamIndex := -1;
    Indicies.DownstreamUnsatZoneHydraulicConductivityParamIndex := -1;
  end;
}

end;

procedure TStreamWriter.EvaluateGages;
var
  Segment: TSegment;
  SegmentIndex: integer;
begin
  WriteGageUnit.InitializeStreamGages;
  for SegmentIndex := 0 to ListOfSegments.Count - 1 do
  begin
    Segment := ListOfSegments[SegmentIndex];
    if Segment.IsGage then
    begin
      StreamGageList.Add(Segment.Number);
      StreamReachList.Add(Segment.ReachList.Count);
      StreamGageOutputTypeList.Add(Segment.GageOutputType);
    end;
    if Segment.GageDiversion then
    begin
      StreamGageList.Add(Segment.Number);
      StreamReachList.Add(Segment.ReachList.Count);
      StreamGageOutputTypeList.Add(5);
    end;
    if Segment.GageUnsatFlow then
    begin
      StreamGageList.Add(Segment.Number);
      StreamReachList.Add(Segment.ReachList.Count);
      StreamGageOutputTypeList.Add(6);
    end;
    if Segment.GageUnsatProfile then
    begin
      StreamGageList.Add(Segment.Number);
      StreamReachList.Add(Segment.ReachList.Count);
      StreamGageOutputTypeList.Add(7);
    end;

  end;
end;

procedure TStreamWriter.MakeListOfSegments(out NPARSEG: integer);
var
  Segment: TSegment;
  SegmentIndex: integer;
  ParameterIndex: integer;
  Parameter: TStreamParameterObject;
begin
  ListOfSegments.Clear;
  for SegmentIndex := 0 to SegmentList.Count - 1 do
  begin
    Segment := SegmentList[SegmentIndex] as TSegment;
    if ListOfSegments.IndexOf(Segment) < 0 then
    begin
      ListOfSegments.Add(Segment);
      Segment.StreamWriter := self;
    end;
  end;

  NPARSEG := 0;
  for ParameterIndex := 0 to ParameterList.Count - 1 do
  begin
    Parameter := ParameterList.Items[ParameterIndex] as TStreamParameterObject;
    if Parameter.Instances.Count > 1 then
    begin
      NPARSEG := NPARSEG + Parameter.SegmentList.Count * Parameter.Instances.Count;
    end
    else
    begin
      NPARSEG := NPARSEG + Parameter.SegmentList.Count;
    end;

    for SegmentIndex := 0 to Parameter.SegmentList.Count - 1 do
    begin
      Segment := Parameter.SegmentList[SegmentIndex] as TSegment;
      if ListOfSegments.IndexOf(Segment) < 0 then
      begin
        ListOfSegments.Add(Segment);
        Segment.StreamWriter := self;
      end;
    end;
  end;

end;

function TStreamWriter.SegmentCount: integer;
begin
  result := ListOfSegments.Count;
end;

procedure TStreamWriter.WriteDataSets1and2;
var
  Segment: TSegment;
  SegmentIndex: integer;
  NSS: integer;
  NSTPAR: integer;
  NPARSEG: integer;
  StreamConstant: double; // CONST
  LeakageTolerance: double; // DLEAK
  ISTCB1: integer;
  ISTCB2: integer;
  NSTRAIL: integer;
  ISUZN: integer;
  NSFRSETS: integer;
  SlopeErrors: TStringList;
  ThicknessErrors: TStringList;
  ErrorMessage: string;
  IRTFLG: Integer;
  NUMTIM: Integer;
  WEIGHT: double;
  FLWTOL: double;
begin
  MakeListOfSegments(NPARSEG);

  EvaluateGages;

  NSTRM := 0;
  NSFRSETS := 0;
  for SegmentIndex := 0 to ListOfSegments.Count - 1 do
  begin
    Segment := ListOfSegments[SegmentIndex];
    NSTRM := NSTRM + Segment.ReachList.Count;
  end;

  NSS := ListOfSegments.Count;
  NSTPAR := ParameterList.Count;

  StreamConstant := ComputeStreamConstant;
  LeakageTolerance :=
    InternationalStrToFloat(frmModflow.adeStreamTolerance.Text);

  if frmModflow.cbFlowSfr.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      ISTCB1 := frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      ISTCB1 := frmModflow.GetUnitNumber('BS1Unit')
    end;
  end
  else
  begin
    ISTCB1 := -1;
  end;

  if frmModflow.cbFlowSfr2.Checked then
  begin
    ISTCB2 := frmModflow.GetUnitNumber('BS2Unit')
  end
  else
  begin
    ISTCB2 := 0;
  end;

  if frmModflow.cbKinematicRouting.Checked then
  begin
    IRTFLG := 1;
    NUMTIM := StrToInt(frmModflow.adeSfrKinematicTimeSteps.Text);
    WEIGHT := StrToFloat(frmModflow.adeSfrTimeWeightingFactor.Text);
    FLWTOL := StrToFloat(frmModflow.adeSfrToleranceForConvergence.Text);
  end
  else
  begin
    IRTFLG := 0;
    NUMTIM := 0;
    WEIGHT := 0;
    FLWTOL := 0;
  end;

  ISFROPT := frmMODFLOW.ISFROPT;
  ISUZN := 1;
  NSTRAIL := 0;
  if (ISFROPT <> 0) or (IRTFLG <> 0) then
  begin
    NSTRM := -NSTRM;
  end;

  if ISFROPT <> 0 then
  begin
    NSTRAIL := StrToInt(frmModflow.adeSfrTrailigWaveIncrements.Text);

    for SegmentIndex := 0 to ListOfSegments.Count -1 do
    begin
      Segment := ListOfSegments[SegmentIndex];
      if Segment.ICALC <> 1 then
      begin
        ISUZN := StrToInt(frmModflow.adeSfrMaxUnsatCells.Text);
        break;
      end;
    end;

    NSFRSETS := StrToInt(frmModflow.adeSfrMaxTrailingWaves.Text);
  end;

  // Data Set 1
  if NSTRM > 0 then
  begin
    writeLn(FFile, NSTRM, ' ', NSS, ' ', NSTPAR, ' ', NPARSEG, ' ',
      FreeFormattedReal(StreamConstant),
      FreeFormattedReal(LeakageTolerance),
      ISTCB1, ' ', ISTCB2);
  end
  else
  begin
    if ISFROPT  > 1 then
    begin
      if IRTFLG = 0 then
      begin
        writeLn(FFile, NSTRM, ' ', NSS, ' ', NSTPAR, ' ', NPARSEG, ' ',
          FreeFormattedReal(StreamConstant),
          FreeFormattedReal(LeakageTolerance),
          ISTCB1, ' ', ISTCB2, ' ', ISFROPT, ' ', NSTRAIL, ' ',
          ISUZN, ' ', NSFRSETS, ' ', IRTFLG);
      end
      else
      begin
        writeLn(FFile, NSTRM, ' ', NSS, ' ', NSTPAR, ' ', NPARSEG, ' ',
          FreeFormattedReal(StreamConstant),
          FreeFormattedReal(LeakageTolerance),
          ISTCB1, ' ', ISTCB2, ' ', ISFROPT, ' ', NSTRAIL, ' ',
          ISUZN, ' ', NSFRSETS, ' ', IRTFLG,
          ' ', NUMTIM, ' ', WEIGHT, ' ', FLWTOL);
      end;
    end
    else
    begin
      if IRTFLG = 0 then
      begin
        writeLn(FFile, NSTRM, ' ', NSS, ' ', NSTPAR, ' ', NPARSEG, ' ',
          FreeFormattedReal(StreamConstant),
          FreeFormattedReal(LeakageTolerance),
          ISTCB1, ' ', ISTCB2, ' ', ISFROPT, ' ', IRTFLG);
      end
      else
      begin
        writeLn(FFile, NSTRM, ' ', NSS, ' ', NSTPAR, ' ', NPARSEG, ' ',
          FreeFormattedReal(StreamConstant),
          FreeFormattedReal(LeakageTolerance),
          ISTCB1, ' ', ISTCB2, ' ', ISFROPT, ' ', IRTFLG,
          ' ', NUMTIM, ' ', WEIGHT, ' ', FLWTOL);
      end;
    end;
  end;

  // Data Set 2
  SlopeErrors:= TStringList.Create;
  ThicknessErrors := TStringList.Create;
  try
    for SegmentIndex := 0 to ListOfSegments.Count - 1 do
    begin
      Segment := ListOfSegments[SegmentIndex];
      Segment.ReachList.Write(self, SlopeErrors, ThicknessErrors);
    end;
    if SlopeErrors.Count > 0 then
    begin
      ErrorMessage :=
        'Error in SFR package: Slopes for one or more reaches are less than or equal to 0';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(' ');
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.Add('The layer, row, and column of the stream reaches are listed below.');
      ErrorMessages.AddStrings(SlopeErrors);
    end;
    if ThicknessErrors.Count > 0 then
    begin
      ErrorMessage :=
        'Error in SFR package: Thicknesses for one or more reaches are less than or equal to 0';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(' ');
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.Add('The layer, row, and column of the stream reaches are listed below.');
      ErrorMessages.AddStrings(SlopeErrors);
    end;
  finally
    SlopeErrors.Free;
    ThicknessErrors.Free;
  end;

end;

procedure TStreamWriter.WriteDataSets3and4(var ErrorsFound: boolean);
begin
  ParameterList.Write(self, ErrorsFound);
end;

procedure TStreamWriter.WriteDataSets5To7(StressPeriod: integer;
  var ErrorsFound: boolean);
var
  ITMP: integer;
  IRDFLG: integer;
  IPTFLG: integer;
  NP: integer;
  Index: integer;
  AParameter: TStreamParameterObject;
  ActiveParameters: TStringList;
  Error: boolean;
begin
  if (StressPeriod = 1) or (frmModflow.comboSFROption.ItemIndex = 1) then
  begin
    ITMP := SegmentList.Count;
  end
  else
  begin
    ITMP := -1;
  end;
  IRDFLG := 0;
  if frmMODFLOW.cbSFRPrintFlows.Checked then
  begin
    IPTFLG := 0;
  end
  else
  begin
    IPTFLG := 1;
  end;
  NP := 0;

  // each line in ActiveParameters will hold Pname [Iname]
  ActiveParameters := TStringList.Create;
  try
    for Index := 0 to ParameterList.Count - 1 do
    begin
      AParameter := ParameterList.Items[Index] as TStreamParameterObject;
      Assert(StressPeriod <= Length(AParameter.Active));
      if AParameter.Active[StressPeriod - 1] then
      begin
        Inc(NP);
        if AParameter.Instances.Count > 0 then
        begin
          ActiveParameters.Add(AParameter.Name
            + ' ' + AParameter.Instances[StressPeriod-1]);
        end
        else
        begin
          ActiveParameters.Add(AParameter.Name);
        end;
      end;
    end;
    // Data Set 5
    WriteLn(FFile, ITMP, ' ', IRDFLG, ' ', IPTFLG, ' ', NP,
      ' Item 5, Stress period ', StressPeriod );
    // Data Set 6
    if ITMP > 0 then
    begin
      SegmentList.Write(self, StressPeriod - 1, Error, False);
      ErrorsFound := Error or ErrorsFound;
    end;
    // Data Set 7
    // each line in ActiveParameters holds Pname [Iname]
    for Index := 0 to ActiveParameters.Count - 1 do
    begin
      WriteLn(FFile, ActiveParameters[Index]);
    end;
  finally
    ActiveParameters.Free;
  end;
end;

procedure TStreamWriter.InitializeGages(
  const DiscretizationWriter: TDiscretizationWriter;
  const ALakeWriter: TLakeWriter);
var
  UnitIndex: integer;
  UnitCount: integer;
//  Error: boolean;
  ErrorMessage: string;
  NPARSEG: integer;
  LayerTypeError: boolean;
begin
  if ContinueExport then
  begin
//    Error := False;
    CurrentModelHandle := frmModflow.CurrentModelHandle;
    DisWriter := DiscretizationWriter;
    Assert(DisWriter <> nil);
    LakeWriter := ALakeWriter;
    if ContinueExport then
    begin
      if ContinueExport then
      begin
        AddParameters;
        UnitCount := frmModflow.dgGeol.RowCount - 1;
        LayerTypeError := False;
        for UnitIndex := 1 to UnitCount do
        begin
          EvaluateStreamUnits(UnitIndex, LayerTypeError);
        end;
      end;
    end;
  end;

  MakeListOfSegments(NPARSEG);

  EvaluateGages;

  if EightPointStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(EightPointStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if FormulaStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(FormulaStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if SimpleStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(SimpleStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if TableStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(TableStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TStreamWriter.Evaluate(
  const DiscretizationWriter: TDiscretizationWriter;
  const ALakeWriter: TLakeWriter);
var
  UnitIndex: integer;
  UnitCount: integer;
//  StressPeriodCount: integer;
//  StressPeriodIndex: integer;
//  FileName: string;
//  Error: boolean;
  SegmentIndex: integer;
  ASegment: TSegment;
  ErrorMessage: string;
  LayerTypeError: boolean;
  dummy: Integer;
begin
  if ContinueExport then
  begin
//    Error := False;
    CurrentModelHandle := frmModflow.CurrentModelHandle;
    DisWriter := DiscretizationWriter;
    Assert(DisWriter <> nil);
    LakeWriter := ALakeWriter;
    if ContinueExport then
    begin
      if ContinueExport then
      begin
        AddParameters;
        UnitCount := frmModflow.dgGeol.RowCount - 1;
        LayerTypeError := False;
        for UnitIndex := 1 to UnitCount do
        begin
          EvaluateStreamUnits(UnitIndex, LayerTypeError);
        end;
        if LayerTypeError then
        begin
          ErrorMessage := 'Error: In the SFR package, unsaturated flow can only be '
            + 'simulated if the layers containing the streams are convertible.';
          frmProgress.reErrors.Lines.Add(ErrorMessage);
          ErrorMessages.Add('');
          ErrorMessages.Add(ErrorMessage);
        end;
      end;
      if frmModflow.cbSensitivity.Checked then
      begin
        for SegmentIndex := 0 to SegmentList.Count - 1 do
        begin
          ASegment := SegmentList[SegmentIndex] as TSegment;
          if ASegment.ICALC > 1 then
          begin
//            Error := True;
            ErrorMessage := 'Error: When the SFR package is used, you can not '
              + 'perform sensitivity analysis except when all the ICALC '
              + 'values are less than or equal to 1.  This means that you '
              + 'can not use any streams on any of the '
              + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
              + '[i], '
              + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
              + '[i], or '
              + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
              + '[i] layers.';
            frmProgress.reErrors.Lines.Add(ErrorMessage);
            ErrorMessages.Add(ErrorMessage);
            break;
          end;
        end;
      end;
    end;
    MakeListOfSegments(dummy);
  end;
  if EightPointStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(EightPointStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if FormulaStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(FormulaStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if SimpleStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(SimpleStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorMessage);
  end;
  if TableStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(TableStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorMessage);
  end;
end;

procedure TStreamWriter.WriteFile(const Root: string;
  const DiscretizationWriter: TDiscretizationWriter;
  const ALakeWriter: TLakeWriter);
var
  UnitIndex: integer;
  UnitCount: integer;
  StressPeriodCount: integer;
  StressPeriodIndex: integer;
  FileName: string;
  Error, ErrorsFound: boolean;
  SegmentIndex: integer;
  ASegment: TSegment;
  ErrorMessage: string;
  LayerTypeError: boolean;
begin
  if ContinueExport then
  begin
    Error := False;
    CurrentModelHandle := frmModflow.CurrentModelHandle;
    DisWriter := DiscretizationWriter;
    Assert(DisWriter <> nil);
    LakeWriter := ALakeWriter;
    if ContinueExport then
    begin
      if ContinueExport then
      begin
        AddParameters;
        UnitCount := frmModflow.dgGeol.RowCount - 1;
        LayerTypeError := False;
        for UnitIndex := 1 to UnitCount do
        begin
          EvaluateStreamUnits(UnitIndex, LayerTypeError);
        end;
        if LayerTypeError then
        begin
          ErrorMessage := 'Error: In the SFR package, unsaturated flow can only be '
            + 'simulated if the layers containing the streams are convertible.';
          frmProgress.reErrors.Lines.Add(ErrorMessage);
          ErrorMessages.Add('');
          ErrorMessages.Add(ErrorMessage);
        end;
      end;
      if frmModflow.cbSensitivity.Checked then
      begin
        for SegmentIndex := 0 to SegmentList.Count - 1 do
        begin
          ASegment := SegmentList[SegmentIndex] as TSegment;
          if ASegment.ICALC > 1 then
          begin
            Error := True;
            ErrorMessage := 'Error: When the SFR package is used, you can not '
              + 'perform sensitivity analysis except when all the ICALC '
              + 'values are less than or equal to 1.  This means that you '
              + 'can not use any streams on any of the '
              + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
              + '[i], '
              + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
              + '[i], or '
              + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
              + '[i] layers.';
            frmProgress.reErrors.Lines.Add(ErrorMessage);
            ErrorMessages.Add(ErrorMessage);
            break;
          end;
        end;
      end;

      FileName := GetCurrentDir + '\' + Root + rsSFR;
      AssignFile(FFile, FileName);
      try
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        WriteDataSets1and2;
        WriteDataSets3and4(ErrorsFound);
        Error := Error or ErrorsFound;
        StressPeriodCount := frmModflow.dgTime.RowCount - 1;
        for StressPeriodIndex := 1 to StressPeriodCount do
        begin
          WriteDataSets5To7(StressPeriodIndex, ErrorsFound);
          Error := Error or ErrorsFound;
        end;
        for SegmentIndex := 0 to SegmentList.Count - 1 do
        begin
          ASegment := SegmentList[SegmentIndex] as TSegment;
          Error := Error or (ASegment.DiversionErrors.Count > 0);
          ErrorMessages.AddStrings(ASegment.DiversionErrors);
        end;

        if Error then
        begin
          frmProgress.reErrors.Lines.Add('Invalid Stream-flow routing (SFR) data');
        end;
      finally
        begin
          CloseFile(FFile);
          Application.ProcessMessages;
        end;
      end;
    end;
  end;
  if EightPointStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(EightPointStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if FormulaStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(FormulaStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if SimpleStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(SimpleStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorMessage);
  end;
  if TableStreamErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(TableStreamErrors)
      + ' contours in the SFR (Stream-flow routing) package '
      + 'are point or closed contours but are on a '
      + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
      + ' layer reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TStreamWriter.AddCells(const Segment: TSegment;
  const ContourIndex, UnitIndex: integer; const Layer: TLayerOptions;
  const Indicies: TStreamParamIndicies);
var
  StreamReachRecord: TStreamReachRecord;
  CellCount: integer;
  Top, Bottom: double;
  PreviousLength, ThisLength, TotalLength, TempLength, Fraction: double;
  Elevation: double;
  UpStreamElevation, DownStreamElevation: double;
  CellIndex: integer;
  BlockIndex:ANE_INT32;
  Block: TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  ISFROPT: integer;
begin
  TotalLength := GGetLineLength(ContourIndex);
  if TotalLength > 0 then
  begin
    ISFROPT := frmModflow.ISFROPT;

    UpStreamElevation := 0;
    DownStreamElevation := 0;
    if not (ISFROPT in [1,2,3]) then
    begin
      Assert(Segment.UpstreamBedElevation.Count > 0);
      UpStreamElevation := Segment.UpstreamBedElevation[0];
      DownStreamElevation := Segment.DownstreamBedElevation[0];
    end;
    TempLength := 0;
    PreviousLength := 0;
    CellCount := GGetCountOfACellList(ContourIndex);
    for CellIndex := 0 to CellCount - 1 do
    begin
      if not ContinueExport then
        break;
      Application.ProcessMessages;
      StreamReachRecord.Row := GGetCellRow(ContourIndex, CellIndex);
      StreamReachRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
      StreamReachRecord.ChannelLength := GGetCellSumSegmentLength(ContourIndex,
        CellIndex);

      Top := DisWriter.Elevations[StreamReachRecord.Column - 1,
        StreamReachRecord.Row - 1, UnitIndex - 1];
      Bottom := DisWriter.Elevations[StreamReachRecord.Column - 1,
        StreamReachRecord.Row - 1, UnitIndex];
      ThisLength := StreamReachRecord.ChannelLength;
      if CellIndex > 0 then
      begin
        TempLength := TempLength + PreviousLength;
      end;
      if CellIndex = 0 then
      begin
        fraction := 0;
      end
      else if CellIndex = CellCount - 1 then
      begin
        fraction := 1;
      end
      else
      begin
        fraction := (TempLength + ThisLength / 2) / TotalLength;
      end;
      PreviousLength := ThisLength;

      if ISFROPT in [1,2,3] then
      begin

        BlockIndex := DisWriter.BlockIndex(StreamReachRecord.Row -1,
          StreamReachRecord.Column-1);
        Block := TBlockObjectOptions.Create(CurrentModelHandle,
          DisWriter.GridLayerHandle, BlockIndex);
        try
          Block.GetCenter(CurrentModelHandle, X,Y);
        finally
          Block.Free;
        end;

        StreamReachRecord.StreambedTop := Layer.RealValueAtXY(
          CurrentModelHandle, X,Y, Indicies.StreamTopName);
        Elevation := StreamReachRecord.StreambedTop;

        StreamReachRecord.Slope := Layer.RealValueAtXY(
          CurrentModelHandle, X,Y, Indicies.StreamSlopeName);

        StreamReachRecord.StreambedThickness := Layer.RealValueAtXY(
          CurrentModelHandle, X,Y, Indicies.StreamBedThicknessName);

        StreamReachRecord.StreambedHydraulicConductivity := Layer.RealValueAtXY(
          CurrentModelHandle, X,Y, Indicies.StreamHydraulicConductivityName);

        if ISFROPT in [2,3] then
        begin
          StreamReachRecord.SaturatedWaterContent := Layer.RealValueAtXY(
            CurrentModelHandle, X,Y, Indicies.StreamSaturatedWaterContentName);

          StreamReachRecord.InitialWaterContent := Layer.RealValueAtXY(
            CurrentModelHandle, X,Y, Indicies.StreamInitialWaterContentName);

          StreamReachRecord.BrooksCoreyExponent := Layer.RealValueAtXY(
            CurrentModelHandle, X,Y, Indicies.StreamBrooksCoreyName);
        end;

        if ISFROPT = 3 then
        begin
          StreamReachRecord.UnsatZoneHydraulicConductivity := Layer.RealValueAtXY(
            CurrentModelHandle, X,Y, Indicies.StreamUnsatZoneHydraulicConductivityName);
        end;
      end
      else
      begin
        Elevation := UpStreamElevation
          + (DownStreamElevation - UpStreamElevation) * fraction;
      end;

      StreamReachRecord.Layer := frmModflow.ModflowLayer
        (UnitIndex, Top, Bottom, Elevation);

      Segment.ReachList.Add(StreamReachRecord);
    end;
  end;
end;

procedure TStreamWriter.GetChannelTimeParameterIndecies(const Layer:
  TLayerOptions;
  var Indicies: TCrossSectionTimeParamIndicies; const TimeIndex: integer);
var
  TimeString: string;
  ParameterName: string;
begin
  TimeString := IntToStr(TimeIndex);
  ParameterName := ModflowTypes.GetMF2KBankRoughnessParamType.ANE_ParamName +
    TimeString;
  Indicies.BankRoughnessIndex := Layer.GetParameterIndex(CurrentModelHandle,
    ParameterName);
  Assert(Indicies.BankRoughnessIndex > -1);

  GetChannelRoughnessIndex(Layer, Indicies.ChannelRoughnessIndex, TimeIndex);
end;

procedure TStreamWriter.GetChannelRoughnessIndex(const Layer: TLayerOptions;
  var RoughnessIndex: ANE_INT32; const TimeIndex: integer);
var
  TimeString: string;
  ParameterName: string;
begin
  if frmModflow.cbSFRCalcFlow.Checked then
  begin
    TimeString := IntToStr(TimeIndex);
    ParameterName := ModflowTypes.GetMF2KChanelRoughnessParamType.ANE_ParamName
      + TimeString;
    RoughnessIndex := Layer.GetParameterIndex(CurrentModelHandle,
      ParameterName);
    Assert(RoughnessIndex > -1);
  end
  else
  begin
    RoughnessIndex := -1;
  end;
end;

procedure TStreamWriter.GetCrossSectionParameterValues(
  const Indicies: TCrossSectionParamIndicies; const Segment: TSegment;
  const Contour: TContourObjectOptions; const PositionIndex: integer);
begin
  Segment.CrossSection[1, PositionIndex] := Contour.
    GetFloatParameter(CurrentModelHandle, Indicies.XIndex);
  Segment.CrossSection[2, PositionIndex] := Contour.
    GetFloatParameter(CurrentModelHandle, Indicies.ZIndex);
end;

procedure TStreamWriter.EvaluateStreamUnits(const UnitIndex: integer; var LayerTypeError: boolean);
var
  Index: integer;
  AParameter: TStreamParameterObject;
  ContourCount: integer;
  LayType: integer;

begin
//  LayerTypeError := False;
  LayType := frmModflow.ModflowLayerType(UnitIndex);
  EvaluateSimpleStreamLayer(UnitIndex, ContourCount);
  LayerTypeError := LayerTypeError or (LayType = 0) and (ContourCount > 0)
    and frmModflow.cbSfrUnsatflow.Checked;

  Evaluate8PointCrossSectionStreamLayer(UnitIndex, ContourCount);
  LayerTypeError := LayerTypeError or ((LayType = 0) and (ContourCount > 0)
    and frmModflow.cbSfrUnsatflow.Checked);

  EvaluateFormulaStreamLayer(UnitIndex, ContourCount);
  LayerTypeError := LayerTypeError or ((LayType = 0) and (ContourCount > 0)
    and frmModflow.cbSfrUnsatflow.Checked);

  EvaluateTableStreamLayer(UnitIndex, ContourCount);
  LayerTypeError := LayerTypeError or ((LayType = 0) and (ContourCount > 0)
    and frmModflow.cbSfrUnsatflow.Checked);

  SegmentList.Sort(SortSegments);
  for Index := 0 to ParameterList.Count - 1 do
  begin
    AParameter := ParameterList.Items[Index] as TStreamParameterObject;
    AParameter.SortTheSegments;
  end;
end;

procedure TStreamWriter.AddParameters;
var
  Parameter: TStreamParameterRecord;
  RowIndex: integer;
  ParameterObject: TStreamParameterObject;
  ColIndex: integer;
  TimeIndex, TimeCount: integer;
  Active: boolean;
begin
  TimeCount := frmModflow.dgTime.RowCount - 1;
  for RowIndex := 1 to frmModflow.dgSFRParametersN.RowCount - 1 do
  begin
    Parameter.Name := UpperCase(frmModflow.dgSFRParametersN.Cells[0, RowIndex]);
    Parameter.Value :=
      InternationalStrToFloat(frmModflow.dgSFRParametersN.Cells[2, RowIndex]);
    ParameterObject := ParameterList.Add(Parameter);
    for TimeIndex := 0 to TimeCount - 1 do
    begin
      ColIndex := 4 + TimeIndex;
      Active := frmModflow.dgSFRParametersN.Cells[ColIndex, RowIndex]
        <> frmModflow.dgSFRParametersN.Columns[ColIndex].PickList[0];
      ParameterObject.Active[TimeIndex] := Active;
    end;
    with frmModflow.sg3dSFRParamInstances.Grids[RowIndex -1] do
    begin
      for TimeIndex := 1 to RowCount-1 do
      begin
        ParameterObject.Instances.Add(Cells[0,TimeIndex]);
      end;
    end;
  end;
end;

class procedure TStreamWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowSfr.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      frmModflow.GetUnitNumber('BS1Unit')
    end;
  end;

  if frmModflow.cbFlowSfr2.Checked then
  begin
    frmModflow.GetUnitNumber('BS2Unit')
  end;
end;

function TStreamWriter.ConvertSegmentNumber(
  OriginalSegmentNumber: integer): integer;
var
  Index: integer;
  ASegment: TSegment;
begin
  Assert((ListOfSegments <> nil));
  result := -1;
  for Index := 0 to ListOfSegments.Count - 1 do
  begin
    ASegment := ListOfSegments[Index];
    if ASegment.FNumber = OriginalSegmentNumber then
    begin
      result := Index +1;
      Exit;
    end;
  end;
end;

{ TStreamParameterList }

function TStreamParameterList.Add(
  Parameter: TStreamParameterRecord): TStreamParameterObject;
begin
  result := TStreamParameterObject.Create;
  result.Name := Parameter.Name;
  result.Value := Parameter.Value;
  inherited Add(result);
end;

function TStreamParameterList.GetParameterByName(
  Name: string): TStreamParameterObject;
var
  Index: integer;
  ParameterObject: TStreamParameterObject;
begin
  result := nil;
  for Index := 0 to Count - 1 do
  begin
    ParameterObject := Items[Index] as TStreamParameterObject;
    if ParameterObject.Name = Name then
    begin
      result := ParameterObject;
      Exit;
    end;
  end;
end;

procedure TStreamParameterList.Write(StreamWriter: TStreamWriter; var
  ErrorFound: boolean);
var
  Index: integer;
  StreamParameter: TStreamParameterObject;
  Error: boolean;
begin
  ErrorFound := False;
  for Index := 0 to Count - 1 do
  begin
    StreamParameter := Items[Index] as TStreamParameterObject;
    StreamParameter.Write(StreamWriter, Error);
    ErrorFound := ErrorFound or Error;
  end;
end;

{ TConcentrationList }

function TConcentrationList.Add(
  Concentrations: TConcentrationRecord): Integer;
var
  ConcentrationEntry: TConcentrationEntry;
begin
  ConcentrationEntry := TConcentrationEntry.Create;
  try
    ConcentrationEntry.Conc := Concentrations;
    result := inherited Add(ConcentrationEntry);
  except
    ConcentrationEntry.Free;
    raise;
  end;
end;

{ TFlowTableList }

function TFlowTableList.Add(FlowRecord: TFlowTableRecord): integer;
var
  FlowTableEntry: TFlowTableEntry;
begin
  FlowTableEntry := TFlowTableEntry.Create;
  try
    FlowTableEntry.Flow := FlowRecord;
    result := inherited Add(FlowTableEntry);
  except
    FlowTableEntry.Free;
    raise;
  end;
end;

end.

