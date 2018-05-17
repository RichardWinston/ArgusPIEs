unit MF_MNW;

interface

uses Sysutils, ANE_LayerUnit, MFGenParam;

type
  TCustomPumpingParameter = class(T_ANE_LayerParam)
    function Units: string; override;
  end;

  TMNW_SiteParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TMNW_RadiusParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TMNW_SkinParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_CoefficientParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_StressParam = class(TCustomPumpingParameter)
    class function ANE_ParamName: string; override;
  end;

  TMNW_ActiveParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TMNW_LimitingElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW_WaterQualityParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_DrawdownFlagParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMNW_ReferenceElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW_GroupIndentifierParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMNW_InactivationPumpingRateParam = class(TCustomPumpingParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TMNW_ReactivationPumpingRateParam = class(TMNW_InactivationPumpingRateParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_AbsolutePumpingRatesParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TMNW_PumpingLimitsParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TMNW_OverriddenFirstParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMNW_OverriddenLastParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMNW_FirstElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_LastElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_FirstUnitParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
    function LinkedParameter: string; virtual;
  end;

  TMNW_LastUnitParam = class(TMNW_FirstUnitParam)
    class function ANE_ParamName: string; override;
    function LinkedParameter: string; override;
  end;

  TMNW_OutputFlag = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TMNW_IsPTOB_Observation = class(TIsObservationParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW_TimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TMNW_WaterQualityTimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TMNW_Layer = class(T_ANE_InfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

  TMNW_WaterQualityLayer = class(T_ANE_InfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

implementation

uses Variables, OptionsUnit, ModflowUnit;

resourcestring
  rsSite = 'Site';
  rsWellRadius = 'Well Radius';
  rsStress = 'Stress';
  rsActive = 'Active';
  rsWaterLevel = 'Limiting Water Level';
  rsWaterQuality = 'Water Quality';
  rsDrawdownFlag = 'Drawdown Flag';
  rsReferenceElevation = 'Reference Elevation';
  rsGroupIdentifier = 'Group Identifier';
  rsInactivation = 'Inactivation Pumping Rate';
  rsReactivation = 'Reactivation Pumping Rate';
  rsMultiNodeWell = 'Multinode Wells';
  rsSkin = 'Skin';
  rsCoefficient = 'Coefficient';
  rsTopOverriden = 'IsOverriddenFirst';
  rsBottomOverriden = 'IsOverriddenLast';
  rsFirst = 'First Elevation';
  rsLast = 'Last Elevation';
  rsFirstUnit = 'First Unit';
  rsLastUnit = 'Last Unit';
  rsMNWWaterQualityUnit = 'MNW Water Quality Unit';
  rsPumpLimitsSpecified = 'Pumping Limits Specified';
  rsAbsolutePumpingRates = 'Absolute Pumping Rates';
  rsIsParticleObservation = 'Is Particle Observation';
  rsOutputFlag = 'Output Flag';

  { TMNW_SiteParam }

class function TMNW_SiteParam.ANE_ParamName: string;
begin
  result := rsSite;
end;

constructor TMNW_SiteParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TMNW_SiteParam.Units: string;
begin
  result := '<= 32 Characters';
end;

function TMNW_SiteParam.Value: string;
begin
  result := '"Site_Name"';
end;

{ TMNW_RadiusParam }

class function TMNW_RadiusParam.ANE_ParamName: string;
begin
  result := rsWellRadius;
end;

function TMNW_RadiusParam.Units: string;
begin
  result := LengthUnit + ' or Conductance';
end;

function TMNW_RadiusParam.Value: string;
begin
  result := '1';
end;

{ TMNW_StressParam }

class function TMNW_StressParam.ANE_ParamName: string;
begin
  result := rsStress;
end;

{ TMNW_ActiveParam }

class function TMNW_ActiveParam.ANE_ParamName: string;
begin
  result := rsActive;
end;

constructor TMNW_ActiveParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TMNW_ActiveParam.Units: string;
begin
  result := 'True or False';
end;

function TMNW_ActiveParam.Value: string;
begin
  result := TMNW_StressParam.ANE_ParamName + WriteIndex + '!=' + kNa;
end;

{ TMNW_LimitingElevationParam }

class function TMNW_LimitingElevationParam.ANE_ParamName: string;
begin
  result := rsWaterLevel
end;

function TMNW_LimitingElevationParam.Units: string;
begin
  result := LengthUnit;
end;

{ TMNW_WaterQualityParam }

class function TMNW_WaterQualityParam.ANE_ParamName: string;
begin
  result := rsWaterQuality;
end;

{ TMNW_DrawdownFlagParam }

class function TMNW_DrawdownFlagParam.ANE_ParamName: string;
begin
  result := rsDrawdownFlag;
end;

constructor TMNW_DrawdownFlagParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  SetValue := True;
end;

function TMNW_DrawdownFlagParam.Units: string;
begin
  result := 'True or False';
end;

{ TMNW_ReferenceElevationParam }

class function TMNW_ReferenceElevationParam.ANE_ParamName: string;
begin
  result := rsReferenceElevation;
end;

function TMNW_ReferenceElevationParam.Units: string;
begin
  result := LengthUnit;
end;

{ TMNW_GroupIndentifierParam }

class function TMNW_GroupIndentifierParam.ANE_ParamName: string;
begin
  result := rsGroupIdentifier
end;

constructor TMNW_GroupIndentifierParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

{ TMNW_InactivationPumpingRateParam }

class function TMNW_InactivationPumpingRateParam.ANE_ParamName: string;
begin
  result := rsInactivation;
end;

function TMNW_InactivationPumpingRateParam.Value: string;
begin
  result := kNa;
end;

{ TCustomPumpingParameter }

function TCustomPumpingParameter.Units: string;
begin
  result := LengthUnit + '^3/' + TimeUnit;
end;

{ TMNW_ReactivationPumpingRateParam }

class function TMNW_ReactivationPumpingRateParam.ANE_ParamName: string;
begin
  result := rsReactivation;
end;

{ TMNW_TimeParamList }

constructor TMNW_TimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  AllSteady: boolean;
  ConcCount: integer;
begin
  inherited Create(AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_StressParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_ActiveParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_RadiusParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_SkinParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_CoefficientParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_LimitingElevationParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_DrawdownFlagParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_ReferenceElevationParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_GroupIndentifierParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_InactivationPumpingRateParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_ReactivationPumpingRateParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_AbsolutePumpingRatesParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_PumpingLimitsParamClassType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  AllSteady := frmModflow.comboMNW_Steady.ItemIndex = 0;
  ModflowTypes.GetMFMNW_StressParamClassType.Create(self, -1);
  ModflowTypes.GetMFMNW_ActiveParamClassType.Create(self, -1);
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwLimitingElevation)]
      then
  begin
    ModflowTypes.GetMFMNW_LimitingElevationParamClassType.Create(self, -1);
  end;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwDrawdownFlag)] then
  begin
    ModflowTypes.GetMFMNW_DrawdownFlagParamClassType.Create(self, -1);
  end;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwRefElev)] then
  begin
    ModflowTypes.GetMFMNW_ReferenceElevationParamClassType.Create(self, -1);
  end;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwGroupID)] then
  begin
    ModflowTypes.GetMFMNW_GroupIndentifierParamClassType.Create(self, -1);
  end;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwPumpingLimits)] then
  begin
    ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType.Create(self,
      -1);
    ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType.Create(self,
      -1);
    ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType.Create(self, -1);
    ModflowTypes.GetMFMNW_PumpingLimitsParamClassType.Create(self, -1);
  end;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwWellRadius)] then
  begin
    ModflowTypes.GetMFMNW_RadiusParamClassType.Create(self, -1);
  end;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwSkin)] then
  begin
    ModflowTypes.GetMFMNW_SkinParamClassType.Create(self, -1);
  end;
  if (frmModflow.combMNW_LossType.ItemIndex = 2) and not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwCoefficient)] then
  begin
    ModflowTypes.GetMFMNW_CoefficientParamClassType.Create(self, -1);
  end;

  if frmModflow.cbMT3D.Checked then
  begin
    ConcCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    if (ConcCount >= 1) and (not AllSteady and
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc1)]) then
    begin
      ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
    end;
    if (ConcCount >= 2) and (not AllSteady and
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc2)]) then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(self, -1);
    end;
    if (ConcCount >= 3) and (not AllSteady and
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc3)]) then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(self, -1);
    end;
    if (ConcCount >= 4) and (not AllSteady and
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc4)]) then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(self, -1);
    end;
    if (ConcCount >= 5) and (not AllSteady and
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc5)]) then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(self, -1);
    end;
  end;

end;

{ TMNW_Layer }

class function TMNW_Layer.ANE_LayerName: string;
begin
  result := rsMultiNodeWell;
end;

constructor TMNW_Layer.Create(ALayerList: T_ANE_LayerList; Index: Integer);
var
  TimeIndex: Integer;
  NumberOfTimes: integer;
  AllSteady: boolean;
  ConcCount: integer;
begin
  inherited;

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_SiteParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_FirstElevationParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_LastElevationParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_OverriddenFirstParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_OverriddenLastParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_FirstUnitParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_LastUnitParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_RadiusParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_SkinParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_CoefficientParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_LimitingElevationParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_DrawdownFlagParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_ReferenceElevationParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_GroupIndentifierParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_InactivationPumpingRateParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_ReactivationPumpingRateParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_AbsolutePumpingRatesParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_PumpingLimitsParamClassType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFIsObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_OutputFlagParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_IsPTOB_ObservationParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  AllSteady := frmModflow.comboMNW_Steady.ItemIndex = 0;
  ModflowTypes.GetMFMNW_SiteParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMNW_FirstElevationParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMNW_LastElevationParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMNW_OverriddenFirstParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMNW_OverriddenLastParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMNW_FirstUnitParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMNW_LastUnitParamClassType.Create(ParamList, -1);
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwLimitingElevation)]
      then
  begin
    ModflowTypes.GetMFMNW_LimitingElevationParamClassType.Create(ParamList, -1);
  end;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwDrawdownFlag)] then
  begin
    ModflowTypes.GetMFMNW_DrawdownFlagParamClassType.Create(ParamList, -1);
  end;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwRefElev)] then
  begin
    ModflowTypes.GetMFMNW_ReferenceElevationParamClassType.Create(ParamList,
      -1);
  end;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwGroupID)] then
  begin
    ModflowTypes.GetMFMNW_GroupIndentifierParamClassType.Create(ParamList, -1);
  end;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwPumpingLimits)] then
  begin
    ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType.Create(
      ParamList, -1);
    ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType.Create(
      ParamList, -1);
    ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType.Create(ParamList,
      -1);
    ModflowTypes.GetMFMNW_PumpingLimitsParamClassType.Create(ParamList, -1);
  end;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwWellRadius)] then
  begin
    ModflowTypes.GetMFMNW_RadiusParamClassType.Create(ParamList, -1);
  end;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwSkin)] then
  begin
    ModflowTypes.GetMFMNW_SkinParamClassType.Create(ParamList, -1);
  end;
  if (frmModflow.combMNW_LossType.ItemIndex = 2) and AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwCoefficient)] then
  begin
    ModflowTypes.GetMFMNW_CoefficientParamClassType.Create(ParamList, -1);
  end;

  if frmModflow.cbMOC3D.Checked and
    (frmModflow.comboMnwObservations.ItemIndex >= 1) then
  begin
    ModflowTypes.GetMFIsObservationParamType.Create(ParamList, -1);
  end;

{  if frmModflow.cbMOC3D.Checked and
    frmModflow.cbParticleObservations.Checked then
  begin
    ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType.Create(ParamList, -1);
  end;   }

  if frmModflow.cbMOC3D.Checked and
    (frmModflow.comboMnwObservations.ItemIndex = 1) then
  begin
    ModflowTypes.GetMFMNW_OutputFlagParamType.Create(ParamList, -1);
  end;

  if frmModflow.cbMT3D.Checked then
  begin
    ConcCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    if (ConcCount >= 1) and (AllSteady or not
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc1)]) then
    begin
      ModflowTypes.GetMT3DConcentrationParamClassType.Create(ParamList, -1);
    end;
    if (ConcCount >= 2) and (AllSteady or not
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc2)]) then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(ParamList, -1);
    end;
    if (ConcCount >= 3) and (AllSteady or not
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc3)]) then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(ParamList, -1);
    end;
    if (ConcCount >= 4) and (AllSteady or not
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc4)]) then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(ParamList, -1);
    end;
    if (ConcCount >= 5) and (AllSteady or not
      frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc5)]) then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(ParamList, -1);
    end;
  end;

  
  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  for TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMNW_TimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

{ TMNW_SkinParam }

class function TMNW_SkinParam.ANE_ParamName: string;
begin
  result := rsSkin;
end;

{ TMNW_CoefficientParam }

class function TMNW_CoefficientParam.ANE_ParamName: string;
begin
  result := rsCoefficient;
end;

{ TMNW_OverriddenFirstParam }

class function TMNW_OverriddenFirstParam.ANE_ParamName: string;
begin
  result := rsTopOverriden;
end;

constructor TMNW_OverriddenFirstParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TMNW_OverriddenFirstParam.Value: string;
begin
  result := 'IsOverriden('
    + ModflowTypes.GetMFMNW_FirstElevationParamClassType.ANE_ParamName
    + ')';
end;

{ TMNW_OverriddenLastParam }

class function TMNW_OverriddenLastParam.ANE_ParamName: string;
begin
  result := rsBottomOverriden;
end;

constructor TMNW_OverriddenLastParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TMNW_OverriddenLastParam.Value: string;
begin
  result := 'IsOverriden('
    + ModflowTypes.GetMFMNW_LastElevationParamClassType.ANE_ParamName
    + ')';
end;

{ TMNW_FirstElevationParam }

class function TMNW_FirstElevationParam.ANE_ParamName: string;
begin
  result := rsFirst;
end;

{ TMNW_LastElevationParam }

class function TMNW_LastElevationParam.ANE_ParamName: string;
begin
  result := rsLast;
end;

{ TMNW_FirstUnitParam }

class function TMNW_FirstUnitParam.ANE_ParamName: string;
begin
  result := rsFirstUnit
end;

constructor TMNW_FirstUnitParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TMNW_FirstUnitParam.LinkedParameter: string;
begin
  result := ModflowTypes.GetMFMNW_FirstElevationParamClassType.ANE_ParamName;
end;

function TMNW_FirstUnitParam.Value: string;
var
  NumUnits: integer;
  UnitIndex: integer;
  UnitString: string;
begin
  NumUnits := frmModflow.UnitCount;
  result := '0';
  for UnitIndex := NumUnits downto 1 do
  begin
    UnitString := IntToStr(UnitIndex);
    result := 'If('
      + LinkedParameter
      + '>='
      + ModflowTypes.GetBottomElevLayerType.ANE_LayerName
      + UnitString
      + '.'
      + ModflowTypes.GetMFBottomElevParamType.ANE_ParamName
      + UnitString
      + ','
      + UnitString
      + ','
      + result
      + ')'
  end;

  UnitString := IntToStr(NumUnits);
  result := 'If('
    + LinkedParameter
    + '<='
    + ModflowTypes.GetBottomElevLayerType.ANE_LayerName
    + UnitString
    + '.'
    + ModflowTypes.GetMFBottomElevParamType.ANE_ParamName
    + UnitString
    + ','
    + UnitString
    + ','
    + result
    + ')';

  UnitString := '1';
  result := 'If('
    + LinkedParameter
    + '>='
    + ModflowTypes.GetMFTopElevLayerType.ANE_LayerName
    + UnitString
    + '.'
    + ModflowTypes.GetMFTopElevParamType.ANE_ParamName
    + UnitString
    + ','
    + UnitString
    + ','
    + result
    + ')';

end;

{ TMNW_LastUnitParam }

class function TMNW_LastUnitParam.ANE_ParamName: string;
begin
  result := rsLastUnit;
end;

function TMNW_LastUnitParam.LinkedParameter: string;
begin
  result := ModflowTypes.GetMFMNW_LastElevationParamClassType.ANE_ParamName;
end;

{ TMNW_WaterQualityTimeParamList }

constructor TMNW_WaterQualityTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  AllSteady: boolean;
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.
    GetMFMNW_WaterQualityParamClassType.ANE_ParamName);
  AllSteady := frmModflow.comboMNW_Steady.ItemIndex = 0;
  if not AllSteady and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwWaterQuality)] then
  begin
    ModflowTypes.GetMFMNW_WaterQualityParamClassType.Create(self, -1);
  end;
end;

{ TMNW_WaterQualityLayer }

class function TMNW_WaterQualityLayer.ANE_LayerName: string;
begin
  result := rsMNWWaterQualityUnit;
end;

constructor TMNW_WaterQualityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex: Integer;
  NumberOfTimes: integer;
  AllSteady: boolean;
begin
  inherited;
  Interp := leQT_Nearest;

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_WaterQualityParamClassType.ANE_ParamName);

  AllSteady := frmModflow.comboMNW_Steady.ItemIndex = 0;
  if AllSteady or not
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwWaterQuality)] then
  begin
    ModflowTypes.GetMFMNW_WaterQualityParamClassType.Create(ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  for TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMNW_WaterQualityTimeParamListType.Create(IndexedParamList2,
      -1);
  end;
end;

{ TMNW_PumpingLimitsParam }

class function TMNW_PumpingLimitsParam.ANE_ParamName: string;
begin
  result := rsPumpLimitsSpecified;
end;

constructor TMNW_PumpingLimitsParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TMNW_PumpingLimitsParam.Value: string;
var
  Transient: boolean;
begin
  Transient := (frmModflow.comboMNW_Steady.ItemIndex <> 0) and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwPumpingLimits)];
  if Transient then
  begin
    result := '('
      + ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType.ANE_ParamName
      + WriteIndex
      + '!=$N/A)&('
      + ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType.ANE_ParamName
      + WriteIndex
      + '!=$N/A)&('
      + ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType.ANE_ParamName
      + WriteIndex
      + '!=$N/A)'
  end
  else
  begin
    result := '('
      + ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType.ANE_ParamName
      + '!=$N/A)&('
      + ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType.ANE_ParamName
      + '!=$N/A)&('
      + ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType.ANE_ParamName
      + '!=$N/A)'
  end;
end;

{ TMNW_AbsolutePumpingRatesParam }

class function TMNW_AbsolutePumpingRatesParam.ANE_ParamName: string;
begin
  result := rsAbsolutePumpingRates;
end;

constructor TMNW_AbsolutePumpingRatesParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TMNW_AbsolutePumpingRatesParam.Value: string;
begin
  result := kNa;
end;


{ TMNW_OutputFlag }

class function TMNW_OutputFlag.ANE_ParamName: string;
begin
  result := rsOutputFlag;
end;

constructor TMNW_OutputFlag.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TMNW_OutputFlag.Units: string;
begin
  result := '0 to 3';
end;

function TMNW_OutputFlag.Value: string;
begin
  result := '0';
end;

{ TMNW_IsPTOB_Observation }

class function TMNW_IsPTOB_Observation.ANE_ParamName: string;
begin
  result := rsIsParticleObservation;
end;

end.

