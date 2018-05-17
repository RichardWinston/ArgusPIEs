unit MFGenParam;

interface

{MFGenParam defines parameters which are used in more than one type of layer.}

uses SysUtils, ANE_LayerUnit, OptionsUnit;

type
  TCustomSimulatedParameter = class(T_ANE_LayerParam)
    function UnitSimulated : boolean; virtual;
  end;

  TCustomUnitParameter = class(TCustomSimulatedParameter)
    function EvaluateLock: TParamLock; override;
  end;

  TCustomParentSimulatedParameter = class(T_ANE_ParentIndexLayerParam)
    function UnitSimulated : boolean; virtual;
  end;

  TCustomParentUnitParameter = class(TCustomParentSimulatedParameter)
    function EvaluateLock: TParamLock; override;
  end;

  TCustomSteadyParameter = class(TCustomSimulatedParameter)
    function EvaluateLock: TParamLock; override;
    function IsSteadyStress : boolean; virtual;
  end;

  TCustomSteadyLengthParameter = class(TCustomSteadyParameter)
    function Units : string; override;
  end;

  TConcentration = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TConductance = class(TCustomUnitParameter)
    Class Function WriteFactorName: string; virtual;
    class Function ANE_ParamName : string ; override;
    function WriteName: string; override;
    function Units : string; override;
    function Value : string; override;
    function FactorUsed: boolean; virtual; abstract;
  end;

  TIFACEParam = class(TCustomSteadyParameter)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TReferenceStressPeriodParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
  end;

  TModflowLayerParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
  end;

  TModflowParameterNameParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TIsParameterParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TOnOffParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TObjectObservationNameParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
    function Units : string; override;
    class Function PermValue : string; virtual;
  end;

  TObservationNameParam = class(TObjectObservationNameParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;



  TStatisticParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TStatFlagParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TPlotSymbolParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
  end;

  TTopObsElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : String; override;
  end;

  TBottomObsElevParam = class(TTopObsElevParam)
    class Function ANE_ParamName : string ; override;
  end;

  TCustomLayerParam = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function ElevationName: string; virtual; abstract;
    function Value : string; override;
  end;

  TTopLayerParam = class(TCustomLayerParam)
    class Function ANE_ParamName : string ; override;
    function ElevationName: string; override;
  end;

  TBottomLayerParam = class(TCustomLayerParam)
    class Function ANE_ParamName : string ; override;
    function ElevationName: string; override;
  end;

  TTimeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TSteadyTimeParamList = class( T_ANE_IndexedParameterList)
    function IsSteadyStress : boolean; virtual; abstract;
  end;

  TIsObservationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TIsPredictionParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TElevationParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    Class Function UseInGHB: boolean;
  end;

  TBoundaryDensityParam = class(T_ANE_LayerParam)
    public
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function UseInWells: boolean;
    class function UseInRivers: boolean;
    class function UseInGHB: boolean;
  end;

  TCustomIFACE_Layer = Class(T_ANE_InfoLayer)
    class function UseIFACE: boolean; virtual;
  end;

  TGWM_UseInPeriod = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  TGWM_TimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

ResourceString
  kMFConductance = 'Conductance';
  kMFConductanceFactor = 'Conductance Multiplier';

implementation

uses Variables;

ResourceString
  kMFConcParam = 'Concentration';
  kMFFace = 'IFACE';
  kMFLayer = 'MODFLOW Layer';
  kMFObjectName = 'Object Name';
  kMFParameterName = 'Parameter Name';
  kIsParameter = 'IS PARAMETER';
  kParameterValue = 'Parameter Value';
  kStressUsed = 'Stress Is Used';
  kOnOff = 'On or Off Stress';
  kObservationName = 'Observation Name';
  kStatistic = 'Statistic';
  kStatFlag = 'Stat Flag';
  kPlotSymbol = 'Plot Symbol';
  kTopElev = 'Top Elevation';
  kBottomElev = 'Bottom Elevation';
  kTopLayer = 'TOP LAYER';
  kBottomLayer = 'BOTTOM LAYER';
  kTime = 'Time';
  kIsObservation = 'Is_Observation';
  kIsPrediction = 'Is_Prediction';
  kElevation = 'Elevation';
  kReferenceStressPeriod = 'Reference Stress Period';
  rsDensity = 'Fluid Density';
  rsGWM_UseInPeriod = 'Use in Period';

//---------------------------
class Function TConcentration.ANE_ParamName : string ;
begin
  result := kMFConcParam;
end;

constructor TConcentration.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;

end;

function TConcentration.Units : string;
begin
  result := 'M/L^3';
end;

//---------------------------
class Function TConductance.ANE_ParamName : string ;
begin
  result := kMFConductance;
end;

function TConductance.Units : string;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if (Pos('Point', ALayer.ANE_LayerName) > 0) or not FactorUsed then
  begin
    result := LengthUnit  + '^2/' + TimeUnit;
  end
  else if Pos('Line', ALayer.ANE_LayerName) > 0 then
  begin
    result := LengthUnit  + '/' + TimeUnit;
  end
  else
  begin
    result := '1/' + TimeUnit;
  end;
end;

function TConductance.Value : string;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if Pos('Area', ALayer.ANE_LayerName) > 0 then
    begin
      result := kNA;
    end
  else
    begin
      result := inherited Value;
    end;
end;

class function TConductance.WriteFactorName: string;
begin
  result := kMFConductanceFactor;
end;

function TConductance.WriteName: string;
begin
  if FactorUsed then
  begin
    result := WriteFactorName;
  end
  else
  begin
    result := inherited WriteName;
  end;
end;

//---------------------------

constructor TIFACEParam.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TIFACEParam.ANE_ParamName : string ;
begin
  result := kMFFace;
end;

function TIFACEParam.Units : string;
begin
  result := '';
end;

//---------------------------

{ TModflowLayerParam }

class function TModflowLayerParam.ANE_ParamName: string;
begin
  result := kMFLayer;
end;

constructor TModflowLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TModflowLayerParam.Units: string;
begin
  result := 'number';
end;

function TModflowLayerParam.Value: string;
begin
  result := '1';
end;

{ TModflowParameterNameParam }

class function TModflowParameterNameParam.ANE_ParamName: string;
begin
  result := kMFParameterName;
end;

constructor TModflowParameterNameParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Valuetype := pvString;
end;

function TModflowParameterNameParam.Units: string;
begin
  result := '<= 10 characters';
end;

{function TModflowParameterNameParam.Value: string;
begin
//  result := '""';
  result := '0';
end;  }

{ TIsParameterParam }

class function TIsParameterParam.ANE_ParamName: string;
begin
  result := kIsParameter;
end;

constructor TIsParameterParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Valuetype := pvBoolean;
  Lock := Lock + [plDef_Val, plDont_Override];
end;

function TIsParameterParam.Units: string;
begin
  result := 'CALCULATED';
end;

function TIsParameterParam.Value: string;
begin
  result := '('
    + ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName
    + WriteIndex
    + '!="")&('
    + ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName
    + WriteIndex
    + '!=0)';
end;

{ TOnOffParam }

class function TOnOffParam.ANE_ParamName: string;
begin
  result := kOnOff
end;

constructor TOnOffParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TOnOffParam.Units: string;
begin
  result := '0 or 1';
end;

function TOnOffParam.Value: string;
begin
  result := '1';
end;

{ TObservationNameParam }

class function TObservationNameParam.ANE_ParamName: string;
begin
  result := kObservationName;
end;



function TObservationNameParam.Units: string;
begin
  result := '<= 12 characters';
end;

function TObservationNameParam.Value: string;
var
  TimeString: string;
begin
  TimeString := WriteIndex;
  if TimeString = '' then
  begin
    result := PermValue;
  end
  else
  begin
    While Length(TimeString) < 4 do
    begin
      TimeString := '_' + TimeString;
    end;
    result := 'If(('
      + ModflowTypes.GetMFObjectObservationNameParamClassType.Ane_ParamName
      + '!="")&('
      + ModflowTypes.GetMFObjectObservationNameParamClassType.Ane_ParamName
      + '!=$N/A)&('
      + ModflowTypes.GetMFObjectObservationNameParamClassType.Ane_ParamName
      + '!='
      + ModflowTypes.GetMFObjectObservationNameParamClassType.PermValue
      + '),'
      + ModflowTypes.GetMFObjectObservationNameParamClassType.Ane_ParamName
      + ' + "' + TimeString + '"'
      + ',"")';
  end;

end;

{ TStatisticParam }

class function TStatisticParam.ANE_ParamName: string;
begin
  result := kStatistic;
end;

{ TStatFlagParam }

class function TStatFlagParam.ANE_ParamName: string;
begin
  result := kStatFlag;
end;

constructor TStatFlagParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TStatFlagParam.Units: string;
begin
  result := '0, 1, or 2'
end;

function TStatFlagParam.Value: string;
begin
  result := '1';
end;

{ TTopObsElevParam }

class function TTopObsElevParam.ANE_ParamName: string;
begin
  result := kTopElev;
end;

function TTopObsElevParam.Units: String;
begin
  result := LengthUnit;
end;

{ TBottomObsElevParam }

class function TBottomObsElevParam.ANE_ParamName: string;
begin
  result := kBottomElev;
end;

{ TTopLayerParam }

class function TTopLayerParam.ANE_ParamName: string;
begin
  result := kTopLayer;
end;

function TTopLayerParam.ElevationName: string;
begin
  result := ModflowTypes.GetMFTopObsElevParamType.ANE_ParamName;
end;

//function TTopLayerParam.Value: string;
//begin
//  result := 'MF_Layer(' + ModflowTypes.GetMFTopObsElevParamType.ANE_ParamName
//    + ')';
//end;

{ TBottomLayerParam }

class function TBottomLayerParam.ANE_ParamName: string;
begin
  result := kBottomLayer;
end;

function TBottomLayerParam.ElevationName: string;
begin
  result := ModflowTypes.GetMFBottomObsElevParamType.ANE_ParamName;
end;

//function TBottomLayerParam.Value: string;
//begin
//  result := 'MF_Layer(' + ModflowTypes.GetMFBottomObsElevParamType.ANE_ParamName
//    + ')';
//end;

{ TTimeParam }

class function TTimeParam.ANE_ParamName: string;
begin
  result := kTime;
end;

function TTimeParam.Units: string;
begin
  result := TimeUnit;
end;

{ TPlotSymbolParam }

class function TPlotSymbolParam.ANE_ParamName: string;
begin
  result := kPlotSymbol;
end;

constructor TPlotSymbolParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TPlotSymbolParam.Value: string;
begin
  result := '1';
end;

{ TCustomSteadyParameter }

function TCustomSteadyParameter.EvaluateLock: TParamLock;
{var
  ParentLayer : T_ANE_Layer;
//  UnitIndex : integer; }
begin
  result := inherited EvaluateLock;
  {$IFDEF Argus5}
  if (IsSteadyStress and
    ((ParameterList as T_ANE_IndexedParameterList).Index > 1))
    or not UnitSimulated then
  begin
    result := result + [plDef_Val, plDont_Override, plDontEvalColor]
  end
  else
  begin
    result := result - [plDef_Val, plDont_Override, plDontEvalColor]
  end;
  {$ENDIF}
end;

function TCustomSteadyParameter.IsSteadyStress: boolean;
begin
  {$IFDEF Argus5}
  if ParameterList is TSteadyTimeParamList then
  begin
    result := (ParameterList as TSteadyTimeParamList).IsSteadyStress;
  end
  else
  begin
    result := False;
  end;
  {$ELSE}
  result := false;
  {$ENDIF}
end;

{ TCustomSimulatedParameter }

function TCustomSimulatedParameter.UnitSimulated: boolean;
{$IFDEF ARGUS5}
var
  ParentLayer : T_ANE_Layer;
  UnitIndex : integer;
{$ENDIF}
begin
{$IFDEF ARGUS5}
  ParentLayer := GetParentLayer;
  if ParentLayer.LayerList is T_ANE_IndexedLayerList then
  begin
    UnitIndex := (ParentLayer.LayerList as T_ANE_IndexedLayerList).Index;
    result := frmModflow.Simulated(UnitIndex);
  end
  else
  begin
    result := True;
  end;
{$ELSE}
    result := True;
{$ENDIF}
end;

{ TCustomUnitParameter }

function TCustomUnitParameter.EvaluateLock: TParamLock;
begin
  result := inherited EvaluateLock;
{$IFDEF ARGUS5}
  if UnitSimulated then
  begin
    result := result - [plDef_Val, plDont_Override, plDontEvalColor]
  end
  else
  begin
    result := result + [plDef_Val, plDont_Override, plDontEvalColor]
  end;
{$ENDIF}
end;

{ TIsObservationParam }

class function TIsObservationParam.ANE_ParamName: string;
begin
  result := kIsObservation
end;

constructor TIsObservationParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TIsObservationParam.Value: string;
begin
  result := '1';
end;

{ TIsPredictionParam }

class function TIsPredictionParam.ANE_ParamName: string;
begin
  result := kIsPrediction
end;

constructor TIsPredictionParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

{ TCustomSteadyLengthParameter }

function TCustomSteadyLengthParameter.Units: string;
begin
  result := LengthUnit;
end;

{ TCustomParentSimulatedParameter }

function TCustomParentSimulatedParameter.UnitSimulated: boolean;
{$IFDEF ARGUS5}
var
  ParentLayer : T_ANE_Layer;
  UnitIndex : integer;
{$ENDIF}
begin
{$IFDEF ARGUS5}
  ParentLayer := GetParentLayer;
  if ParentLayer.LayerList is T_ANE_IndexedLayerList then
  begin
    UnitIndex := (ParentLayer.LayerList as T_ANE_IndexedLayerList).Index;
    result := frmModflow.Simulated(UnitIndex);
  end
  else
  begin
    result := True;
  end;
{$ELSE}
    result := True;
{$ENDIF}
end;

{ TCustomParentUnitParameter }

function TCustomParentUnitParameter.EvaluateLock: TParamLock;
begin
  result := inherited EvaluateLock;
{$IFDEF ARGUS5}
  if UnitSimulated then
  begin
    result := result - [plDef_Val, plDont_Override, plDontEvalColor]
  end
  else
  begin
    result := result + [plDef_Val, plDont_Override, plDontEvalColor]
  end;
{$ENDIF}  
end;

{ TElevationParam }

class function TElevationParam.ANE_ParamName: string;
begin
  result := kElevation;
end;

function TElevationParam.Units: string;
begin
  Result := LengthUnit;
end;

class function TElevationParam.UseInGHB: boolean;
begin
  with frmModflow do
  begin
    result := cbSW_VDF.Checked and cbSeaWat.Checked and cbGHB.Checked
      and cbSW_GHB_Elevation.Checked;
  end;
end;

{ TReferenceStressPeriodParam }

class function TReferenceStressPeriodParam.ANE_ParamName: string;
begin
  result := kReferenceStressPeriod;
end;

constructor TReferenceStressPeriodParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TReferenceStressPeriodParam.Value: string;
begin
  result := '1';
end;

{ TObjectObservationNameParam }

class function TObjectObservationNameParam.ANE_ParamName: string;
begin
  result := kMFObjectName;
end;

constructor TObjectObservationNameParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

class function TObjectObservationNameParam.PermValue: string;
begin
  result := '"A_Name"';
end;

function TObjectObservationNameParam.Units: string;
begin
  result := '<= 8 characters';
end;

function TObjectObservationNameParam.Value: string;
begin
  result := PermValue;
end;

{ TCustomIFACE_Layer }

class function TCustomIFACE_Layer.UseIFACE: boolean;
begin
  result := frmMODFLOW.cbMODPATH.Checked or (frmMODFLOW.cbMOC3D.Checked
    and frmMODFLOW.cbBFLX.Checked);
end;

{ TBoundaryDensity }

class function TBoundaryDensityParam.ANE_ParamName: string;
begin
  result := rsDensity;
end;

function TBoundaryDensityParam.Units: string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;

class function TBoundaryDensityParam.UseInGHB: boolean;
begin
  with frmModflow do
  begin
    result := cbSW_GHB_FluidDensity.Checked and cbSeaWat.Checked
      and cbGHB.Checked and cbSW_VDF.Checked;
  end
end;

class function TBoundaryDensityParam.UseInRivers: boolean;
begin
  with frmModflow do
  begin
    result := cbSW_RiverFluidDensity.Checked and cbSeaWat.Checked
      and cbRIV.Checked and cbSW_VDF.Checked;
  end
end;

class function TBoundaryDensityParam.UseInWells: boolean;
begin
  with frmModflow do
  begin
    result := cbSW_WellFluidDensity.Checked and cbSeaWat.Checked
      and cbWEL.Checked and cbSW_VDF.Checked;
  end
end;

function TBoundaryDensityParam.Value: string;
begin
  result := frmModflow.adeRefFluidDens.Text;
end;

{ TGWM_UseInPeriod }

class function TGWM_UseInPeriod.ANE_ParamName: string;
begin
  result := rsGWM_UseInPeriod;
end;

constructor TGWM_UseInPeriod.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TGWM_UseInPeriod.Units: string;
begin
  result := '0 or 1';
end;

function TGWM_UseInPeriod.Value: String;
begin
  result := '1';
end;

{ TGWM_TimeParamList }

constructor TGWM_TimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ModflowTypes.GetMFGWM_UseInPeriodParamType.Create(self, -1);

end;

{ TCustomLayerParam }

constructor TCustomLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TCustomLayerParam.Units: string;
begin
  result := 'CALCULATED'
end;

function TCustomLayerParam.Value: string;
var
  UnitCount: integer;
  TopLayers, BottomLayers: array of integer;
  Index: integer;
  LayerCount: integer;
//  DisCount: integer;
  BotUnitElevationRoot: string;
  TopUnit1: string;
  function HandleLayer(LayerIndex: integer): string;
  var
    LayerAboveString: string;
    LayerBottomString: string;
    Function FindDiscretizedLayer: string;
    begin
      result := IntToStr(TopLayers[LayerIndex-1]) + '+ Floor('
        + IntToStr(BottomLayers[LayerIndex-1]-TopLayers[LayerIndex-1]+1)
        + ' * (1 - (' +  ElevationName + ' - ' + LayerBottomString
        + ') / (' + LayerAboveString + ' - ' + LayerBottomString + ')))'
    end;
  begin
    LayerBottomString:= BotUnitElevationRoot + IntToStr(LayerIndex)
      + '.' + ModflowTypes.GetMFBottomElevParamType.ANE_ParamName
      + IntToStr(LayerIndex);
    if LayerIndex > 1 then
    begin
      LayerAboveString := BotUnitElevationRoot + IntToStr(LayerIndex-1)
        + '.' + ModflowTypes.GetMFBottomElevParamType.ANE_ParamName
        + IntToStr(LayerIndex-1)
    end
    else
    begin
      LayerAboveString := TopUnit1;
    end;
    if LayerIndex < UnitCount then
    begin
      result := 'If(' + ElevationName + ' > '
          + LayerBottomString + ', ';
      if TopLayers[LayerIndex-1] = BottomLayers[LayerIndex-1] then
      begin
        result := result + IntToStr(TopLayers[LayerIndex-1]);
      end
      else
      begin
        result := result + FindDiscretizedLayer;
      end;
      result := result + ', ' + HandleLayer(LayerIndex+1) + ')';
    end
    else
    begin
      if TopLayers[LayerIndex-1] = BottomLayers[LayerIndex-1] then
      begin
        result := IntToStr(TopLayers[LayerIndex-1]);
      end
      else
      begin
        result := 'If(' + ElevationName + ' > '
          + LayerBottomString + ', '
          + FindDiscretizedLayer
          + ', ' + IntToStr(BottomLayers[LayerIndex-1])
          + ')';
      end;
    end;
  end;
begin
  UnitCount := frmModflow.UnitCount;
  SetLength(TopLayers, UnitCount);
  SetLength(BottomLayers, UnitCount);
  LayerCount := 0;
  for Index := 1 to UnitCount do
  begin
    if frmModflow.Simulated(Index) then
    begin
      TopLayers[Index-1] := LayerCount + 1;
      LayerCount := LayerCount + frmModflow.DiscretizationCount(Index);
      BottomLayers[Index-1] := LayerCount;
    end
    else
    begin
      TopLayers[Index-1] := LayerCount;
      BottomLayers[Index-1] := LayerCount;
    end;
  end;

  if (UnitCount = 1) and (TopLayers[0] = BottomLayers[0]) then
  begin
    result := '1';
  end
  else
  begin
    TopUnit1 := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + '1.'
      + ModflowTypes.GetMFTopElevParamType.ANE_ParamName + '1';
    BotUnitElevationRoot := ModflowTypes.GetBottomElevLayerType.ANE_LayerName;
    result := 'If(' + ElevationName + ' >= '
      + TopUnit1 + ', 1, '
      + HandleLayer(1)
      + ')';
  end;
end;

end.
