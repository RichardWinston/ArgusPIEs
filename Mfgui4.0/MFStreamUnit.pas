{MFStreamUnit defines layers related to the STR and SFR packages
 and the associated parameters and Parameterlist.}

unit MFStreamUnit;

interface

uses ANE_LayerUnit, SysUtils, MFGenParam, MFLakes;

type
  TStreamGageOutputTypeParam = class(TGageOutputTypeParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TCustomUnsatGage = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TGageDiversionParam = class(TCustomUnsatGage)
    class Function ANE_ParamName : string ; override;
  end;

  TUnsatGageParam = class(TCustomUnsatGage)
    class Function ANE_ParamName : string ; override;
  end;

  TUnsatProfileGageParam = class(TCustomUnsatGage)
    class Function ANE_ParamName : string ; override;
  end;

  TStreamSegNum = class(TCustomUnitParameter)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownSegNum = class(TStreamSegNum)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units: string; override;
  end;

  TStreamDivSegNum = class(TStreamSegNum)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units: string; override;
  end;

  TStreamHydCondParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function BaseUnits: string;
    function Units : string; override;
  end;

  TStreamFlow = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamUpStage = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownStage = class(TStreamUpStage)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TStreamUpBotElev = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownBotElev = class(TStreamUpBotElev)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TStreamUpTopElev = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownTopElev = class(TStreamUpTopElev)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TStreamUpWidthParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TStreamDownWidthParam = class(TStreamUpWidthParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMFSKStreamUpWidthParam = class(TStreamUpWidthParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamSlope = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TStreamRough = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function BaseUnits: string;
    function Units : string; override;
    function Value : string; override;
  end;

  TStreamTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TStreamObservationParamList = class(T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TStreamLayer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    class function UseIFACE: boolean; override;
  end;

  // Begin implementing MF2K

  TMF2KUpstreamK = class(TStreamHydCondParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TMF2KDownstreamK = class(TStreamHydCondParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TMF2KStreamPriority = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TMF2KUpsteamDepth = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMF2KDownstreamDepth = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMF2KStreamDownWidthParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMF2KChanelRoughnessParam = class(TStreamRough)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KBankRoughnessParam = class(TStreamRough)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMF2KPrecipitationParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KRunoffParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KDownstreamTopElevationParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KUpstreamBedThicknessParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMF2KDownstreamBedThicknessParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMF2KCrossSectionXParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KCrossSectionZParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KTableWidthParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KTableDepthParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KTableFlowParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KCustomExponentParam = class(TCustomSteadyParameter)
    function Units : string; override;
  end;

  TMF2KWidthExponentParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KDepthExponentParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KWidthCoefficientParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KDepthCoefficientParam = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2K_ICALC_Param = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TFlowConcentration = class(TConcentration)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TRunoffConcentration = class(TConcentration)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TPrecipitationConcentration = class(TConcentration)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KStreamEvap = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMF2KStreamDivSegNum = class(TStreamDivSegNum)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TMF2KStreamUpTopElev = class(TCustomSteadyLengthParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

   // SFR2 variables
  // STRTOP
  TSfr2StreambedTopElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  // SLOPE, use TStreamSlope

  // STRTHICK
  TSfr2StreambedThickness = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  // STRHC1, use TStreamHydCondParam

  // THTS
  TSfr2SaturatedWaterContent = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  // THTI
  TSfr2InitialWaterContent = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  // EPS
  TSfr2BrooksCoreyExponent = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  // UHC
  TSfr2UnsatZoneHydraulicConductivity = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  // THTS1
  TSfr2UpstreamSaturatedWaterContent = class(TSfr2SaturatedWaterContent)
    class Function ANE_ParamName : string ; override;
  end;

  // THTI1
  TSfr2UpstreamInitialWaterContent = class(TSfr2InitialWaterContent)
    class Function ANE_ParamName : string ; override;
  end;

  // EPS1
  TSfr2UpstreamBrooksCoreyExponent = class(TSfr2BrooksCoreyExponent)
    class Function ANE_ParamName : string ; override;
  end;

  // UHC1
  TSfr2UpstreamUnsatZoneHydraulicConductivity = class(TSfr2UnsatZoneHydraulicConductivity)
    class Function ANE_ParamName : string ; override;
  end;

  // THTS2
  TSfr2DownstreamSaturatedWaterContent = class(TSfr2SaturatedWaterContent)
    class Function ANE_ParamName : string ; override;
  end;

  // THTI2
  TSfr2DownstreamInitialWaterContent = class(TSfr2InitialWaterContent)
    class Function ANE_ParamName : string ; override;
  end;

  // EPS2
  TSfr2DownstreamBrooksCoreyExponent = class(TSfr2BrooksCoreyExponent)
    class Function ANE_ParamName : string ; override;
  end;

  // UHC2
  TSfr2DownstreamUnsatZoneHydraulicConductivity = class(TSfr2UnsatZoneHydraulicConductivity)
    class Function ANE_ParamName : string ; override;
  end;

  TMF2KCustomStreamTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TCustomUnsatStreamTimeParamList = class(TMF2KCustomStreamTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  // sfr2, ICALC = 0 OR 1
  TMF2KSimpleStreamTimeParamList = class(TCustomUnsatStreamTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  // sfr2, ICALC = 2
  TMF2K8PointChannelStreamTimeParamList = class(TCustomUnsatStreamTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TCustomSatStreamTimeParamList = class(TMF2KCustomStreamTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  // sfr2, ICALC = 4
  TMF2KTableStreamTimeParamList = class(TCustomSatStreamTimeParamList)
  end;

  TMF2KStreamCrossSectionParamList = class(T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  // sfr2, ICALC = 3
  TMF2KStreamFormulaTimeParamList = class(TCustomSatStreamTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMF2KStreamTableParamList = class(T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TCustomMF2KStreamLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    function NumberOfPeriods : integer;
  end;

  TCustomUnsatStreamLayer = Class(TCustomMF2KStreamLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  // SFR2, ICALC = 0 or 1
  TMF2KSimpleStreamLayer = Class(TCustomUnsatStreamLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  // SFR2, ICALC = 2
  TMF2K8PointChannelStreamLayer = Class(TCustomUnsatStreamLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TCustomSatStreamLayer = class(TCustomMF2KStreamLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  // SFR2, ICALC = 3
  TMF2KFormulaStreamLayer = Class(TCustomSatStreamLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  // SFR2, ICALC = 4
  TMF2KTableStreamLayer = Class(TCustomSatStreamLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables, WriteStreamUnit;

ResourceString
  kMFSegmentNum = 'Segment Number';
  kMFDownSegmentNum = 'Downstream Segment Number';
  kMFDivSegmentNum = 'Upstream Diversion Segment Number'; //Segment Number of Diversion Source
  kMFStreamHydCondParam = 'Streambed Hydraulic Conductivity';
  kMFStreamFlow = 'Flow';
  kMFStreamUpStage = 'Upstream Stage';
  kMFStreamDownStage = 'Downstream Stage';
  kMFStreamCond = 'Conductance per length';
  kMFStreamUpBotElev = 'Upstream bottom elevation';
  kMFStreamDownBotElev = 'Downstream bottom elevation';
  kMFStreamUpTopElev = 'Upstream top elevation'; //Upstream bed top elevation
  kMFStreamDownTopElev = 'Downstream top elevation'; //Downstream bed top elevation
  kMFStreamUpWidthParam = 'Upstream width';
  kMFStreamDownWidthParam = 'Downstream width';
  kMFStreamWidth = 'Width';
  kMFStreamSlope = 'Slope';
  kMFStreamRough = 'Mannings roughness';
  kMFStreamLayer = 'Stream Unit';
  // MF2K
  kMF2KUpstream = 'Upstream ';
  kMF2KDownstream = 'Downstream ';
  kMF2KHydraulicK = 'Bed Hydraulic Conductivity';
  kMF2KPriority = 'Priority Code';
  kMF2KDepth = 'Depth';
  kMF2KChanRough = 'Channel Roughness';
  kMF2KBankRough = 'Overbank Roughness';
  kMF2KStreamPrecip = 'Precipitation';
  kMF2KStreamEvap = 'Evapotranspiration';
  kMF2KRunoff = 'Overland Runoff';
  kMF2KBedThickness = 'Bed Thickness';
  kMF2KCrossSectionX = 'Cross Section X';
  kMF2KCrossSectionZ = 'Cross Section Z';
  kMF2KTableFlow = 'Table Flow';
  kMF2KTableDepth = 'Table Depth';
  kMF2KTableWidth = 'Table Width';
  kMF2KWidthCoefficient = 'Width Coefficient';
  kMF2KWidthExponent = 'Width Exponent';
  kMF2KDepthCoefficient = 'Depth Coefficient';
  kMF2KDepthExponent = 'Depth Exponent';
  kMF2K_ICALC = 'ICALC';
  kMF2KStreamLayer = 'SFR Unit';
  kMF2K8PointStreamLayer = 'Eight Point Channel SFR Unit';
  kMF2KFormulaStreamLayer = 'Formula SFR Unit';
  kMF2KTableStreamLayer = 'Table SFR Unit';
  kMF2KFlowPrefix = 'Flow ';
  kMF2KRunoffPrefix = 'Runoff ';
  kMF2KPrecipitationPrefix = 'Precipitation ';
  kMF2KDivSegmentNum = 'Segment Number of Diversion Source';
  kMF2KStreamDownTopElev = 'Downstream Bed Top Elevation';
  kMF2KStreamUpTopElev = 'Upstream Bed Top Elevation';
  kMF2kStreamUpWidthParam = 'Upstream Width';
  kMF2kStreamDownWidthParam = 'Downstream Width';

  kMF2KGageOutputtype = 'Gage Output Type';
  KMF2KGageDiversion = 'Gage Diversion';
  KMF2KUnsaturatedFlowGage = 'Gage Unsaturated Flow';
  KMF2KUnsaturatedGageProfile = 'Gage Unsaturated Profile';
   // SFR2 variables
{    StreambedTop: double;
    StreambedThickness: double;
    SaturatedWaterContent: double;
    InitialWaterContent: double;
    BrooksCoreyExponent: double;
    UnsatZoneHydraulicConductivity: double;
 }
  kSfr2StreambedTop = 'Streambed Top Elevation';
  kSfr2StreambedThickness = 'Streambed Thickness';
  kSfr2SaturatedWaterContent = 'Saturated Water Content';
  kSfr2InitialWaterContent= 'Initial Water Content';
  kSfr2BrooksCoreyExponent = 'Brooks Corey Exponent';
  kSfr2UnsatZoneHydraulicConductivity = 'Unsat Zone Hydraulic Conductivity';

  kSfr2UpstreamSaturatedWaterContent = 'Upstream Saturated Water Content';
  kSfr2UpstreamInitialWaterContent= 'Upstream Initial Water Content';
  kSfr2UpstreamBrooksCoreyExponent = 'Upstream Brooks Corey Exponent';
  kSfr2UpstreamUnsatZoneHydraulicConductivity = 'Upstream Unsat Zone Hydraulic Conductivity';

  kSfr2DownstreamSaturatedWaterContent = 'Downstream Saturated Water Content';
  kSfr2DownstreamInitialWaterContent= 'Downstream Initial Water Content';
  kSfr2DownstreamBrooksCoreyExponent = 'Downstream Brooks Corey Exponent';
  kSfr2DownstreamUnsatZoneHydraulicConductivity = 'Downstream Unsat Zone Hydraulic Conductivity';


constructor TStreamSegNum.Create(
      AParameterList : T_ANE_ParameterList; Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TStreamSegNum.ANE_ParamName : string ;
begin
  result := kMFSegmentNum;
end;

function TStreamSegNum.Units : string;
begin
  result := '(Seg or ISEG)';
end;

//---------------------------
class Function TStreamDownSegNum.ANE_ParamName : string ;
begin
  result := kMFDownSegmentNum;
end;

constructor TStreamDownSegNum.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;

end;

function TStreamDownSegNum.Units: string;
begin
  result := '(Itrib or OUTSEG)';
end;

function TStreamDownSegNum.Value: string;
begin
  result := kNa;
end;

//---------------------------
class Function TStreamDivSegNum.ANE_ParamName : string ;
begin
  result := kMFDivSegmentNum;
end;

constructor TStreamDivSegNum.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

function TStreamDivSegNum.Units: string;
begin
  result := '(IUPSEG)';
end;

function TStreamDivSegNum.Value: string;
begin
  result := kNA;

end;

//---------------------------
{ TStreamHydCondParam }

class function TStreamHydCondParam.ANE_ParamName: string;
begin
  result := kMFStreamHydCondParam;
end;

function TStreamHydCondParam.BaseUnits: string;
begin
  result := LengthUnit + '/' +TimeUnit
end;

function TStreamHydCondParam.Units: string;
begin
  result := BaseUnits + ' (Cond, Condfact)';
end;

function TStreamHydCondParam.Value: string;
begin
  result := '1';
end;


//---------------------------
class Function TStreamFlow.ANE_ParamName : string ;
begin
  result := kMFStreamFlow;
end;

function TStreamFlow.Units : string;
begin
  result := LengthUnit + '^3/' +TimeUnit + ' (Flow)';
end;

//---------------------------
class Function TStreamUpStage.ANE_ParamName : string ;
begin
  result := kMFStreamUpStage;
end;

//---------------------------
class Function TStreamDownStage.ANE_ParamName : string ;
begin
  result := kMFStreamDownStage;
end;

function TStreamDownStage.Value : string;
begin
  result := kNA;
end;

//---------------------------
{class Function TStreamCond.ANE_ParamName : string ;
begin
  result := kMFStreamCond;
end;

function TStreamCond.Units : string;
begin
  result := 'L/t';
end;
}
//---------------------------
class Function TStreamUpBotElev.ANE_ParamName : string ;
begin
  result := kMFStreamUpBotElev;
end;


//---------------------------
class Function TStreamDownBotElev.ANE_ParamName : string ;
begin
  result := kMFStreamDownBotElev;
end;

function TStreamDownBotElev.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TStreamUpTopElev.ANE_ParamName : string ;
begin
  result := kMFStreamUpTopElev;
end;

//---------------------------
class Function TStreamDownTopElev.ANE_ParamName : string ;
begin
  result := kMFStreamDownTopElev;
end;

function TStreamDownTopElev.Value : string;
begin
  result := kNA;
end;

//---------------------------
{class Function TStreamWidth.ANE_ParamName : string ;
begin
  result := kMFStreamWidth;
end;

function TStreamWidth.Units : string;
begin
  result := 'L';
end;
}
//---------------------------
class Function TStreamSlope.ANE_ParamName : string ;
begin
  result := kMFStreamSlope;
end;

function TStreamSlope.Units : string;
begin
  result := LengthUnit + '/' + LengthUnit + ' (Slope)';
end;

//---------------------------
class Function TStreamRough.ANE_ParamName : string ;
begin
  result := kMFStreamRough;
end;

function TStreamRough.BaseUnits: string;
begin
  result := TimeUnit + '/' + LengthUnit + '^(1/3)';
end;

function TStreamRough.Units : string;
begin
  result := BaseUnits + ' (Rough)';
end;

//---------------------------
constructor TStreamTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
var
  NCOMP : integer;
begin
  inherited Create(AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFOnOffParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpBotElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownBotElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpTopElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownTopElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpWidthParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownWidthParamType.ANE_ParamName);
//  ParameterOrder.Add(TStreamWidth.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamSlopeParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamRoughParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName);

  ModflowTypes.GetMFOnOffParamType.Create( self, -1);
  ModflowTypes.GetMFStreamFlowParamType.Create(self, -1);
  ModflowTypes.GetMFStreamUpStageParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownStageParamType.Create( self, -1);

  ModflowTypes.GetMFStreamUpBotElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownBotElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamUpTopElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownTopElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamUpWidthParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownWidthParamType.Create( self, -1);

  if frmMODFLOW.cbStreamCalcFlow.Checked then
  begin
//    TStreamWidth.Create( self, -1);
    ModflowTypes.GetMFStreamSlopeParamType.Create( self, -1);
    ModflowTypes.GetMFStreamRoughParamType.Create( self, -1);
  end;

{  if frmMODFLOW.cbStreamTrib.Checked then
  begin
    ModflowTypes.GetMFStreamDownSegNumParamType.Create( self, -1);
  end; }

  if (ParentLayer as TStreamLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
    NCOMP := StrToInt(frmMODFLOW.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(self, -1);
    end;
  end;
end;

//---------------------------
constructor TStreamLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfPeriods, ObservationTimes: Integer;
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamHydCondParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObjectObservationNameParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamDivSegNumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStatFlagParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFPlotSymbolParamType.ANE_ParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFReferenceStressPeriodParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodStreamStageObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodStreamFlowInObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodStreamFlowOutObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodStreamFlowIntoAquiferObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodLabelParamType.ANE_ParamName);

  ModflowTypes.GetMFStreamSegNumParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStreamHydCondParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  if frmMODFLOW.cbStreamObservations.Checked then
  begin
    ModflowTypes.GetMFObjectObservationNameParamClassType.Create( ParamList, -1);
    ModflowTypes.GetMFStatFlagParamType.Create( ParamList, -1);
    ModflowTypes.GetMFPlotSymbolParamType.Create( ParamList, -1);
//    ModflowTypes.GetMFReferenceStressPeriodParamClassType.Create( ParamList, -1);
  end;

  if frmMODFLOW.cbHYD.Checked then
  begin
    ModflowTypes.GetMFHydmodStreamStageObservationParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHydmodStreamFlowInObservationParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHydmodStreamFlowOutObservationParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHydmodStreamFlowIntoAquiferObservationParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHydmodLabelParamType.Create( ParamList, -1);
  end;

  if frmMODFLOW.cbStreamTrib.Checked then
  begin
    ModflowTypes.GetMFStreamDownSegNumParamType.Create( ParamList, -1);
  end;

  if frmMODFLOW.cbStreamDiversions.Checked then
  begin
    ModflowTypes.GetMFStreamDivSegNumParamType.Create( ParamList, -1);
  end;


  NumberOfPeriods := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMFStreamTimeParamListType.Create(IndexedParamList2, -1);
  end;

  if frmMODFLOW.cbStreamObservations.Checked then
  begin
    ObservationTimes := StrToInt(frmMODFLOW.adeObsSTRTimeCount.Text);
    For TimeIndex := 1 to ObservationTimes do
    begin
      ModflowTypes.GetMFStreamObservationParamListType.Create(IndexedParamList0, -1);
    end;
  end;
end;

class Function TStreamLayer.ANE_LayerName : string ;
begin
  result := kMFStreamLayer;
end;

{ TStreamUpWidthParam }

class function TStreamUpWidthParam.ANE_ParamName: string;
begin
  result := kMFStreamUpWidthParam;
end;

{ TSreamDownWidthParam }

class function TStreamDownWidthParam.ANE_ParamName: string;
begin
  result := kMFStreamDownWidthParam;
end;


function TStreamDownWidthParam.Value: string;
begin
  result := kNa;
end;

function TStreamTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboStreamOption.ItemIndex = 0;
end;


{ TUpstreamK }

class function TMF2KUpstreamK.ANE_ParamName: string;
begin
  result := kMF2KUpstream + kMF2KHydraulicK;
end;

{ TDownstreamK }

class function TMF2KDownstreamK.ANE_ParamName: string;
begin
  result := kMF2KDownstream + kMF2KHydraulicK;
end;

{ TStreamPriority }

class function TMF2KStreamPriority.ANE_ParamName: string;
begin
  result := kMF2KPriority;
end;

constructor TMF2KStreamPriority.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TStreamUpWidthParam.Units: string;
begin
  result := inherited Units + ' (Width)';
end;

function TStreamUpWidthParam.Value: string;
begin
  result := '1';
end;

{ TMF2KUpsteamDepth }

class function TMF2KUpsteamDepth.ANE_ParamName: string;
begin
  result := kMF2KUpstream + kMF2KDepth;
end;

function TMF2KUpsteamDepth.Units: string;
begin
  result := inherited Units + ' (DEPTH1)';
end;

function TMF2KUpsteamDepth.Value: string;
begin
  result := '1';
end;

{ TMF2KDownstreamDepth }

class function TMF2KDownstreamDepth.ANE_ParamName: string;
begin
  result := kMF2KDownstream + kMF2KDepth;
end;

function TMF2KDownstreamDepth.Units: string;
begin
  result := inherited Units + ' (DEPTH2)';
end;

function TMF2KDownstreamDepth.Value: string;
begin
  result := '1';
end;

{ TMF2KStreamDownWidthParam }

class function TMF2KStreamDownWidthParam.ANE_ParamName: string;
begin
  result := kMF2kStreamDownWidthParam;
end;

function TMF2KStreamDownWidthParam.Units: string;
begin
  result := inherited Units + ' (WIDTH2)';
end;

function TMF2KStreamDownWidthParam.Value: string;
begin
  result := '1';
end;

{ TMF2KChanelRoughnessParam }

class function TMF2KChanelRoughnessParam.ANE_ParamName: string;
begin
  result := kMF2KChanRough;
end;

function TMF2KChanelRoughnessParam.Units: string;
begin
  result := BaseUnits + ' (ROUGHCH)';
end;

{ TMF2KBankRoughnessParam }

class function TMF2KBankRoughnessParam.ANE_ParamName: string;
begin
  result := kMF2KBankRough;
end;

function TMF2KBankRoughnessParam.Units: string;
begin
  result := BaseUnits + ' (ROUGHBK)';
end;

function TMF2KBankRoughnessParam.Value: string;
begin
  result := '0.06';
end;

{ TMF2KPrecipitationParam }

class function TMF2KPrecipitationParam.ANE_ParamName: string;
begin
  result := kMF2KStreamPrecip;
end;

function TMF2KPrecipitationParam.Units: string;
begin
  Result := LengthUnit + '/' + TimeUnit + ' (PPTSW)';
end;

{ TMF2KDownstreamTopElevationParam }

class function TMF2KDownstreamTopElevationParam.ANE_ParamName: string;
begin
  result := kMF2KStreamDownTopElev;
end;

function TMF2KDownstreamTopElevationParam.Units: string;
begin
  result := inherited Units + ' (ELEVDN)';
end;

{ TMF2KUpstreamBedThicknessParam }

class function TMF2KUpstreamBedThicknessParam.ANE_ParamName: string;
begin
  result := kMF2KUpstream + kMF2KBedThickness;
end;

function TMF2KUpstreamBedThicknessParam.Units: string;
begin
  result := inherited Units + ' (THICKM1)';
end;

function TMF2KUpstreamBedThicknessParam.Value: string;
begin
  result := '1';
end;

{ TMF2KDownstreamBedThicknessParam }

class function TMF2KDownstreamBedThicknessParam.ANE_ParamName: string;
begin
  result := kMF2KDownstream + kMF2KBedThickness;
end;

function TMF2KDownstreamBedThicknessParam.Units: string;
begin
  result := inherited Units + ' (THICKM2)';
end;

function TMF2KDownstreamBedThicknessParam.Value: string;
begin
  result := '1';
end;

{ TMF2KCrossSectionXParam }

class function TMF2KCrossSectionXParam.ANE_ParamName: string;
begin
  result := kMF2KCrossSectionX;
end;

function TMF2KCrossSectionXParam.Units: string;
begin
  result := LengthUnit + ' (XCPT' + WriteIndex + ')';
end;

{ TMF2KCrossSectionZParam }

class function TMF2KCrossSectionZParam.ANE_ParamName: string;
begin
  result := kMF2KCrossSectionZ;
end;

function TMF2KCrossSectionZParam.Units: string;
begin
  result := LengthUnit + ' (ZCPT' + WriteIndex + ')';
end;

{ TMF2KTableFlowParam }

class function TMF2KTableFlowParam.ANE_ParamName: string;
begin
  result := kMF2KTableFlow;
end;

function TMF2KTableFlowParam.Units: string;
begin
  result := LengthUnit + '^3/' +TimeUnit + ' (FLOWTAB(' + WriteIndex + '))';
end;

{ TMF2KTableWidthParam }

class function TMF2KTableWidthParam.ANE_ParamName: string;
begin
  result := kMF2KTableWidth;
end;

function TMF2KTableWidthParam.Units: string;
begin
  result := LengthUnit + ' (WDTHTAB(' + WriteIndex + '))';
end;

{ TMF2KTableDepthParam }

class function TMF2KTableDepthParam.ANE_ParamName: string;
begin
  result := kMF2KTableDepth;
end;

function TMF2KTableDepthParam.Units: string;
begin
  result := LengthUnit + ' (DPTHTAB(' + WriteIndex + '))';
end;

{ TMF2KCustomExponentParam }

function TMF2KCustomExponentParam.Units: string;
begin
  result := '';
end;

{ TMF2KWidthCoefficientParam }

class function TMF2KWidthCoefficientParam.ANE_ParamName: string;
begin
  result := kMF2KWidthCoefficient;
end;

function TMF2KWidthCoefficientParam.Units: string;
begin
  result := inherited Units + ' (AWDTH)';
end;

{ TMF2KWidthExponentParam }

class function TMF2KWidthExponentParam.ANE_ParamName: string;
begin
  result := kMF2KWidthExponent;
end;

function TMF2KWidthExponentParam.Units: string;
begin
  result := '(BWDTH)';
end;

{ TMF2KDepthCoefficientParam }

class function TMF2KDepthCoefficientParam.ANE_ParamName: string;
begin
  result := kMF2KDepthCoefficient;
end;

function TMF2KDepthCoefficientParam.Units: string;
begin
  result := inherited Units + ' (CDPTH)';
end;

{ TMF2KDepthExponentParam }

class function TMF2KDepthExponentParam.ANE_ParamName: string;
begin
  result := kMF2KDepthExponent;
end;

function TMF2KDepthExponentParam.Units: string;
begin
  result := '(FDPTH)';
end;

{ TMF2K_ICALC_Param }

class function TMF2K_ICALC_Param.ANE_ParamName: string;
begin
  result := kMF2K_ICALC;
end;

constructor TMF2K_ICALC_Param.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TMF2K_ICALC_Param.Units: string;
begin
  result := '0 or 1 (ICALC)';
end;


{ TMF2KCustomStreamTimeParamList }

constructor TMF2KCustomStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create(AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFOnOffParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMF2KStreamEvapParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMF2KRunoffParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMF2KPrecipitationParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMF2KFlowConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMF2KRunoffConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMF2KPrecipitationConcentrationParamType.ANE_ParamName);

  ModflowTypes.GetMFStreamFlowParamType.Create(self, -1);


  ModflowTypes.GetMF2KStreamEvapParamType.Create( self, -1);
  ModflowTypes.GetMF2KRunoffParamType.Create( self, -1);
  ModflowTypes.GetMF2KPrecipitationParamType.Create( self, -1);

  if frmModflow.ISFROPT in [0,4,5] then
  begin
    // HYDCOND1, HYDCOND2
    ModflowTypes.GetMFOnOffParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMF2KFlowConcentrationParamType.Create( self, -1);
    ModflowTypes.GetMF2KPrecipitationConcentrationParamType.Create( self, -1);
    ModflowTypes.GetMF2KRunoffConcentrationParamType.Create( self, -1);
  end;
end;

function TMF2KCustomStreamTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboSFROption.ItemIndex = 0;
end;

{ TMF2KSimpleStreamTimeParamList }

constructor TMF2KSimpleStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  ParamPosition : integer;
begin
  inherited;
  ParameterOrder.Insert(0,ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName);
  ParameterOrder.Insert(1,ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName);

  ParamPosition := ParameterOrder.IndexOf
    (ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);
  Assert(ParamPosition >= 0);

  ParameterOrder.Insert(ParamPosition+1,ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName);
  ParameterOrder.Insert(ParamPosition+2,ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName);

  ParameterOrder.Insert(ParamPosition+1,ModflowTypes.GetMF2KUpsteamDepthParamType.ANE_ParamName);
  ParameterOrder.Insert(ParamPosition+2,ModflowTypes.GetMF2KDownstreamDepthParamType.ANE_ParamName);

  ParamPosition := ParameterOrder.IndexOf
    (ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName);
  Assert(ParamPosition >= 0);
  ParameterOrder.Insert(ParamPosition + 1,ModflowTypes.GetMFSKStreamUpWidthParamType.ANE_ParamName);
  ParameterOrder.Insert(ParamPosition + 2,ModflowTypes.GetMF2KStreamDownWidthParamType.ANE_ParamName);
  ParameterOrder.Insert(ParamPosition + 3,ModflowTypes.GetMF2KChanelRoughnessParamType.ANE_ParamName);

  if frmModflow.ISFROPT IN [0, 4, 5] then
  begin
    // ELEVUP
    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( self, -1);
    // ELEVDN
    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( self, -1);
    // THICKM1
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( self, -1);
    // THICKM2
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( self, -1);
  end;
  // DEPTH1
  ModflowTypes.GetMF2KUpsteamDepthParamType.Create( self, -1);
  // DEPTH2
  ModflowTypes.GetMF2KDownstreamDepthParamType.Create( self, -1);

  // WIDTH1
  ModflowTypes.GetMFSKStreamUpWidthParamType.Create( self, -1);
  // WIDTH2
  ModflowTypes.GetMF2KStreamDownWidthParamType.Create( self, -1);

  if frmModflow.cbSFRCalcFlow.Checked then
  begin
    ModflowTypes.GetMF2KChanelRoughnessParamType.Create( self, -1);
  end;

end;

{ TMF2K8PointChannelStreamTimeParamList }

constructor TMF2K8PointChannelStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  ParamPosition : integer;
begin
  inherited;
  ParameterOrder.Insert(0,ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName);
  ParameterOrder.Insert(1,ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName);
  ParamPosition := ParameterOrder.IndexOf
    (ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);
  Assert(ParamPosition >= 0);

  ParameterOrder.Insert(ParamPosition+1,ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName);
  ParameterOrder.Insert(ParamPosition+2,ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName);


//  ParamPosition := ParameterOrder.IndexOf
//    (ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);
//  Assert(ParamPosition >= 0);
  ParameterOrder.Insert(ParamPosition + 5,ModflowTypes.GetMF2KChanelRoughnessParamType.ANE_ParamName);
  ParameterOrder.Insert(ParamPosition + 6,ModflowTypes.GetMF2KBankRoughnessParamType.ANE_ParamName);


  if frmModflow.ISFROPT in [0, 4, 5] then
  begin
    // ELEVUP
    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( self, -1);
    // ELEVDN
    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( self, -1);
    // THICKM1
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( self, -1);
    // THICKM2
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( self, -1);
  end;
  ModflowTypes.GetMF2KChanelRoughnessParamType.Create( self, -1);
  ModflowTypes.GetMF2KBankRoughnessParamType.Create( self, -1);

end;

{ TMF2KStreamCrossSectionParamList }

constructor TMF2KStreamCrossSectionParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMF2KCrossSectionXParamType.Create( self, -1);
  ModflowTypes.GetMF2KCrossSectionZParamType.Create( self, -1);

end;

{ TMF2KStreamTableParamList }

constructor TMF2KStreamTableParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMF2KTableFlowParamType.Create( self, -1);
  ModflowTypes.GetMF2KTableWidthParamType.Create( self, -1);
  ModflowTypes.GetMF2KTableDepthParamType.Create( self, -1);
end;

{ TMF2KStreamFormulaTimeParamList }

constructor TMF2KStreamFormulaTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NewParamPosition: integer;
begin
  inherited;
  NewParamPosition := ParameterOrder.IndexOf(
    ModflowTypes.GetMF2KFlowConcentrationParamType.ANE_ParamName);

  ParameterOrder.Insert(NewParamPosition, ModflowTypes.GetMF2KDepthExponentParamType.ANE_ParamName);
  ParameterOrder.Insert(NewParamPosition, ModflowTypes.GetMF2KDepthCoefficientParamType.ANE_ParamName);
  ParameterOrder.Insert(NewParamPosition, ModflowTypes.GetMF2KWidthExponentParamType.ANE_ParamName);
  ParameterOrder.Insert(NewParamPosition, ModflowTypes.GetMF2KWidthCoefficientParamType.ANE_ParamName);

  ModflowTypes.GetMF2KWidthCoefficientParamType.Create( self, -1);
  ModflowTypes.GetMF2KWidthExponentParamType.Create( self, -1);
  ModflowTypes.GetMF2KDepthCoefficientParamType.Create( self, -1);
  ModflowTypes.GetMF2KDepthExponentParamType.Create( self, -1);

end;

{ TCustomMF2KStreamLayer }

constructor TCustomMF2KStreamLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGageParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamGageOutputTypeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGageDiversioParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KStreamDivSegNumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KUpstreamKParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KDownstreamKParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KStreamPriorityParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2StreambedTopElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamSlopeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2StreambedThicknessParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamHydCondParamType.ANE_ParamName);


  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGageParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStreamGageOutputTypeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStreamSegNumParamType.Create( ParamList, -1);


  if frmMODFLOW.cbSFRTrib.Checked then
  begin
    ModflowTypes.GetMFStreamDownSegNumParamType.Create( ParamList, -1);
  end;

  if frmMODFLOW.cbSFRDiversions.Checked then
  begin
    ModflowTypes.GetMF2KStreamDivSegNumParamType.Create( ParamList, -1);
    ModflowTypes.GetMF2KStreamPriorityParamType.Create( ParamList, -1);
    ModflowTypes.GetMFGageDiversioParamType.Create( ParamList, -1);
  end;

  if frmModflow.ISFROPT in [1,2,3] then
  begin
    ModflowTypes.GetMFSfr2StreambedTopElevParamType.Create( ParamList, -1);
    ModflowTypes.GetMFStreamSlopeParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2StreambedThicknessParamType.Create( ParamList, -1);
    ModflowTypes.GetMFStreamHydCondParamType.Create( ParamList, -1);
  end;
  
{  NumberOfPeriods := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMFStreamTimeParamListType.Create(IndexedParamList2, -1);
  end; }
end;

function TCustomMF2KStreamLayer.NumberOfPeriods: integer;
begin
  result := frmModflow.dgTime.RowCount -1;
end;

{ TMF2KSimpleStreamLayer }

class function TMF2KSimpleStreamLayer.ANE_LayerName: string;
begin
  result := kMF2KStreamLayer;
end;

constructor TMF2KSimpleStreamLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  PeriodIndex : integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2K_ICALC_ParamType.ANE_ParamName);

  if frmModflow.cbSFRCalcFlow.Checked then
  begin
    ModflowTypes.GetMF2K_ICALC_ParamType.Create( ParamList, -1);
  end;

  for PeriodIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMF2KSimpleStreamTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

{ TMF2K8PointChannelStreamLayer }

class function TMF2K8PointChannelStreamLayer.ANE_LayerName: string;
begin
  result := kMF2K8PointStreamLayer;
end;

constructor TMF2K8PointChannelStreamLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParameterListIndex : integer;
begin
  inherited;

  for ParameterListIndex := 1 to MaxCrossSectionPts do
  begin
    ModflowTypes.GetMF2KStreamCrossSectionParamListType.Create(IndexedParamList1, -1);
  end;

  for ParameterListIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMF2K8PointChannelStreamTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

{ TMF2KFormulaStreamLayer }

class function TMF2KFormulaStreamLayer.ANE_LayerName: string;
begin
  result := kMF2KFormulaStreamLayer;
end;

constructor TMF2KFormulaStreamLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ParameterListIndex : integer;
begin
  inherited;
  for ParameterListIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMF2KStreamFormulaTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

{ TMF2KTableStreamLayer }

class function TMF2KTableStreamLayer.ANE_LayerName: string;
begin
  result := kMF2KTableStreamLayer;
end;

constructor TMF2KTableStreamLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ParameterListIndex : integer;
begin
  inherited;
  for ParameterListIndex := 1 to StrToInt(frmModflow.adeStreamTableEntriesCount.Text) do
  begin
    ModflowTypes.GetMF2KStreamTableParamListType.Create(IndexedParamList1, -1);
  end;

  for ParameterListIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMF2KTableStreamTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;


{ TFlowConcentration }

class function TFlowConcentration.ANE_ParamName: string;
begin
  result := kMF2KFlowPrefix + inherited ANE_ParamName;
end;


function TFlowConcentration.Units: string;
begin
  result := inherited Units + ' (CONCQ)';
end;

{ TRunoffConcentration }

class function TRunoffConcentration.ANE_ParamName: string;
begin
  result := kMF2KRunoffPrefix + inherited ANE_ParamName;
end;

function TRunoffConcentration.Units: string;
begin
  result := inherited Units + ' (CONCRUN)';
end;

{ TPrecipitationConcentration }

class function TPrecipitationConcentration.ANE_ParamName: string;
begin
  result := kMF2KPrecipitationPrefix + inherited ANE_ParamName;
end;

function TPrecipitationConcentration.Units: string;
begin
  result := inherited Units + ' (CONCPPT)';
end;

{ TMF2KRunoffParam }

class function TMF2KRunoffParam.ANE_ParamName: string;
begin
  result := kMF2KRunoff;
end;

function TMF2KRunoffParam.Units: string;
begin
  Result := LengthUnit + '^3/' + TimeUnit + ' (RUNOFF)';
end;

function TMF2KStreamPriority.Units: string;
begin
  result := '> -4 (IPRIOR)'
end;

{ TMF2KStreamEvap }

class function TMF2KStreamEvap.ANE_ParamName: string;
begin
  result := kMF2KStreamEvap;
end;

function TMF2KStreamEvap.Units: string;
begin
  Result := LengthUnit + '/' + TimeUnit + ' (ETSW)';
end;

function TStreamRough.Value: string;
begin
  result := '0.04';
end;

{ TMF2KStreamDivSegNum }

class function TMF2KStreamDivSegNum.ANE_ParamName: string;
begin
  result := kMF2KDivSegmentNum;
end;

function TMF2KStreamDivSegNum.Value: string;
begin
  result := '0';
end;

{ TMF2KStreamUpTopElev }

class function TMF2KStreamUpTopElev.ANE_ParamName: string;
begin
  result := kMF2KStreamUpTopElev;
end;

function TMF2KStreamUpTopElev.Units: string;
begin
  result := inherited Units + ' (ELEVUP)';
end;

{ TStreamObservationParamList }

constructor TStreamObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFObservationNameParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFReferenceStressPeriodParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFTimeParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLossParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStatisticParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFObservationNumberParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIsObservationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIsPredictionParamType.ANE_ParamName);

  ModflowTypes.GetMFObservationNameParamType.Create( self, -1);
  ModflowTypes.GetMFReferenceStressPeriodParamClassType.Create( self, -1);
  ModflowTypes.GetMFTimeParamType.Create( self, -1);
  ModflowTypes.GetMFLossParamType.Create( self, -1);
  ModflowTypes.GetMFStatisticParamType.Create( self, -1);
  if frmMODFLOW.cbSpecifyStreamCovariances.Checked then
  begin
    ModflowTypes.GetMFObservationNumberParamType.Create( self, -1);
  end;
  ModflowTypes.GetMFIsObservationParamType.Create( self, -1);
  ModflowTypes.GetMFIsPredictionParamType.Create( self, -1);
end;

class function TStreamLayer.UseIFACE: boolean;
begin
  result := frmMODFLOW.cbMODPATH.Checked;
end;

{ TStreamGageOutputTypeParam }

class function TStreamGageOutputTypeParam.ANE_ParamName: string;
begin
  result := kMF2KGageOutputtype;

end;

function TStreamGageOutputTypeParam.Units: string;
begin
  result := '0 to 4 (OUTTYPE)';
end;

{ TMFSKStreamUpWidthParam }

class function TMFSKStreamUpWidthParam.ANE_ParamName: string;
begin
  result := kMF2kStreamUpWidthParam;
end;

function TStreamUpStage.Units: string;
begin
  result := inherited Units + ' (Stage)';
end;

function TStreamUpBotElev.Units: string;
begin
  result := inherited Units + ' (Sbot)';
end;

function TStreamUpTopElev.Units: string;
begin
  result := inherited Units + ' (Stop)';
end;

function TMFSKStreamUpWidthParam.Units: string;
begin
  result := LengthUnit + ' (WIDTH1)'
end;

function TMF2KUpstreamK.Units: string;
begin
  result := BaseUnits + ' (Hc1fact, HCOND1)';
end;

function TMF2KDownstreamK.Units: string;
begin
  result := BaseUnits + ' (Hc2fact, HCOND2)';
end;

{ TSfr2StreambedTopElev }

class function TSfr2StreambedTopElev.ANE_ParamName: string;
begin
  result := kSfr2StreambedTop;
end;

function TSfr2StreambedTopElev.Units: string;
begin
  result := LengthUnit + ' (STRTOP)'
end;

{ TSfr2StreambedThickness }

class function TSfr2StreambedThickness.ANE_ParamName: string;
begin
  result := kSfr2StreambedThickness;
end;

function TSfr2StreambedThickness.Units: string;
begin
  result := LengthUnit + ' (STRTHICK)'
end;

function TSfr2StreambedThickness.Value: string;
begin
  result := '1.0';
end;

{ TSfr2SaturatedWaterContent }

class function TSfr2SaturatedWaterContent.ANE_ParamName: string;
begin
  result := kSfr2SaturatedWaterContent;
end;

function TSfr2SaturatedWaterContent.Units: string;
begin
   result := '0 to 1';
end;

function TSfr2SaturatedWaterContent.Value: string;
begin
  result := '0.3';
end;

{ TSfr2InitialWaterContent }

class function TSfr2InitialWaterContent.ANE_ParamName: string;
begin
  result := kSfr2InitialWaterContent;
end;

function TSfr2InitialWaterContent.Units: string;
begin
  result := '0 t0 1';
end;

function TSfr2InitialWaterContent.Value: string;
begin
  result := '0.1';
end;

{ TSfr2BrooksCoreyExponent }

class function TSfr2BrooksCoreyExponent.ANE_ParamName: string;
begin
  result := kSfr2BrooksCoreyExponent;
end;

function TSfr2BrooksCoreyExponent.Units: string;
begin
  result := '(EPS)';
end;

function TSfr2BrooksCoreyExponent.Value: string;
begin
  result := '3.5';
end;

{ TSfr2UnsatZoneHydraulicConductivity }

class function TSfr2UnsatZoneHydraulicConductivity.ANE_ParamName: string;
begin
  result := kSfr2UnsatZoneHydraulicConductivity;
end;

function TSfr2UnsatZoneHydraulicConductivity.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit;
end;

function TSfr2UnsatZoneHydraulicConductivity.Value: string;
begin
  result := '1e-6';
end;

{ TSfr2UpstreamInitialWaterContent }

class function TSfr2UpstreamInitialWaterContent.ANE_ParamName: string;
begin
  result := kSfr2UpstreamInitialWaterContent;
end;

{ TSfr2UpstreamBrooksCoreyExponent }

class function TSfr2UpstreamBrooksCoreyExponent.ANE_ParamName: string;
begin
  result := kSfr2UpstreamBrooksCoreyExponent;
end;

{ TSfr2UpstreamUnsatZoneHydraulicConductivity }

class function TSfr2UpstreamUnsatZoneHydraulicConductivity.ANE_ParamName: string;
begin
  result := kSfr2UpstreamUnsatZoneHydraulicConductivity;
end;

{ TSfr2UpstreamSaturatedWaterContent }

class function TSfr2UpstreamSaturatedWaterContent.ANE_ParamName: string;
begin
  result := kSfr2UpstreamSaturatedWaterContent;
end;

{ TSfr2DownstreamSaturatedWaterContent }

class function TSfr2DownstreamSaturatedWaterContent.ANE_ParamName: string;
begin
  result := kSfr2DownstreamSaturatedWaterContent;
end;

{ TSfr2DownstreamInitialWaterContent }

class function TSfr2DownstreamInitialWaterContent.ANE_ParamName: string;
begin
  result := kSfr2DownstreamInitialWaterContent;
end;

{ TSfr2DownstreamBrooksCoreyExponent }

class function TSfr2DownstreamBrooksCoreyExponent.ANE_ParamName: string;
begin
  result := kSfr2DownstreamBrooksCoreyExponent;
end;

{ TSfr2DownstreamUnsatZoneHydraulicConductivity }

class function TSfr2DownstreamUnsatZoneHydraulicConductivity.ANE_ParamName: string;
begin
  result := kSfr2DownstreamUnsatZoneHydraulicConductivity;
end;


{ TCustomUnsatStreamLayer }

constructor TCustomUnsatStreamLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ISFROPT: integer;
  Position: integer;
begin
  inherited;
  // sfr2
  Position := ParamList.ParameterOrder.IndexOf(ModflowTypes.GetMFGageDiversioParamType.ANE_ParamName) + 1;
  Assert(Position > 0);
  ParamList.ParameterOrder.Insert(Position, ModflowTypes.GetMFUnsatGageParamType.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position+1, ModflowTypes.GetMFUnsatProfileGageParamType.ANE_ParamName);

//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2StreambedTopElevParamType.ANE_ParamName);

//  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName);

//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamSlopeParamType.ANE_ParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2StreambedThicknessParamType.ANE_ParamName);

//  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName);

//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStreamHydCondParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2SaturatedWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2InitialWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2BrooksCoreyExponentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2UnsatZoneHydraulicConductivityParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName);


  ISFROPT := frmMODFLOW.ISFROPT;

  if ISFROPT in [0,4,5] then
  begin
    ModflowTypes.GetMF2KUpstreamKParamType.Create( ParamList, -1);
    ModflowTypes.GetMF2KDownstreamKParamType.Create( ParamList, -1);
  end;

  if ISFROPT in [2,3,4,5] then
  begin
    ModflowTypes.GetMFUnsatGageParamType.Create( ParamList, -1);
    ModflowTypes.GetMFUnsatProfileGageParamType.Create( ParamList, -1);
  end;

{  if ISFROPT in [1,2,3] then
  begin
    ModflowTypes.GetMFSfr2StreambedTopElevParamType.Create( ParamList, -1);
    ModflowTypes.GetMFStreamSlopeParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2StreambedThicknessParamType.Create( ParamList, -1);
    ModflowTypes.GetMFStreamHydCondParamType.Create( ParamList, -1);
  end; }

  if ISFROPT in [2,3] then
  begin
    ModflowTypes.GetMFSfr2SaturatedWaterContentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2InitialWaterContentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2BrooksCoreyExponentParamType.Create( ParamList, -1);
  end;

  if ISFROPT = 3 then
  begin
    ModflowTypes.GetMFSfr2UnsatZoneHydraulicConductivityParamType.Create( ParamList, -1);
  end;

  // sfr2
//  if ISFROPT in [0,4,5] then
//  begin
//    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( ParamList, -1);
//    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( ParamList, -1);
//    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( ParamList, -1);
//    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( ParamList, -1);
//  end;

  if ISFROPT in [4,5] then
  begin
//    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( ParamList, -1);
//    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( ParamList, -1);
//    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( ParamList, -1);
//    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType.Create( ParamList, -1);
  end;

  // sfr2
  if frmModflow.ISFROPT = 5 then
  begin
    ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType.Create( ParamList, -1);
    ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType.Create( ParamList, -1);
  end;

end;

{ TCustomUnsatStreamTimeParamList }

{constructor TCustomUnsatStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  // sfr2
{
  ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType.ANE_ParamName);
}

  // sfr2
//  if frmModflow.ISFROPT in [0,4,5] then
{  if frmModflow.ISFROPT = 0 then
  begin
    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( self, -1);
    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( self, -1);
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( self, -1);
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( self, -1);
  end;

  // sfr2
{  if frmModflow.ISFROPT in [4,5] then
  begin
    ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType.Create( self, -1);
    ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType.Create( self, -1);
    ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType.Create( self, -1);
    ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType.Create( self, -1);
    ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType.Create( self, -1);
    ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType.Create( self, -1);
  end;  }

  // sfr2
{  if frmModflow.ISFROPT = 5 then
  begin
    ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType.Create( self, -1);
    ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType.Create( self, -1);
  end;   }
//end;

{ TCustomSatStreamTimeParamList }

{constructor TCustomSatStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( self, -1);
  ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( self, -1);
  ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( self, -1);
  ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( self, -1);
end;  }

{ TCustomSatStreamLayer }

constructor TCustomSatStreamLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName);

  ModflowTypes.GetMF2KUpstreamKParamType.Create( ParamList, -1);
  ModflowTypes.GetMF2KDownstreamKParamType.Create( ParamList, -1);

  if frmModflow.ISFROPT in [0,4,5] then
  begin
    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( ParamList, -1);
    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( ParamList, -1);
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( ParamList, -1);
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( ParamList, -1);
  end;

end;

{ TUnsatProfileGageParam }

class function TUnsatProfileGageParam.ANE_ParamName: string;
begin
  result := KMF2KUnsaturatedGageProfile;
end;

{ TGageDiversionParam }

class function TGageDiversionParam.ANE_ParamName: string;
begin
  result := KMF2KGageDiversion;
end;

{ TCustomUnsatGage }

constructor TCustomUnsatGage.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TCustomUnsatGage.Units: string;
begin
  result := '0 or 1';
end;

{ TUnsatGageParam }

class function TUnsatGageParam.ANE_ParamName: string;
begin
  result := KMF2KUnsaturatedFlowGage;
end;

{ TCustomUnsatStreamTimeParamList }

constructor TCustomUnsatStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
end;

{ TCustomSatStreamTimeParamList }

constructor TCustomSatStreamTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
{var
  ParamPosition: integer;}
begin
  inherited;
  ParameterOrder.Insert(0,ModflowTypes.GetMF2KStreamUpTopElevParamType.ANE_ParamName);
  ParameterOrder.Insert(1,ModflowTypes.GetMF2KDownstreamTopElevationParamType.ANE_ParamName);
  ParameterOrder.Insert(2,ModflowTypes.GetMF2KUpstreamBedThicknessParamType.ANE_ParamName);
  ParameterOrder.Insert(3,ModflowTypes.GetMF2KDownstreamBedThicknessParamType.ANE_ParamName);
{  ParamPosition := ParameterOrder.IndexOf
    (ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);
  Assert(ParamPosition >= 0);}

  if frmModflow.ISFROPT in [0, 4, 5] then
  begin
    // ELEVUP
    ModflowTypes.GetMF2KStreamUpTopElevParamType.Create( self, -1);
    // ELEVDN
    ModflowTypes.GetMF2KDownstreamTopElevationParamType.Create( self, -1);
    // THICKM1
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType.Create( self, -1);
    // THICKM2
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType.Create( self, -1);
  end;
//  ModflowTypes.GetMFOnOffParamType.Create( self, -1);
end;

function TStreamSlope.Value: string;
begin
  result := '0.001';
end;

end.
