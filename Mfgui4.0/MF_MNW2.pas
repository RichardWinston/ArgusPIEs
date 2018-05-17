unit MF_MNW2;

interface

uses Sysutils, Classes, CheckLst , ANE_LayerUnit, MFGenParam, MF_MNW;

type
  //WELLID
  TMNW2_WellIdParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  // NNODES
  TMNW2_NodeCountParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TMNW2_LossTypeParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TMNW2_WellRadiusParam = class(TMNW_RadiusParam)
    function Units: string; override;
  end;

  TMNW2_SkinRadiusParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_SkinKParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_BParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_CParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_PParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TMNW2_CellToWellConductanceParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_SpecifyPumpParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  // Qlimit
  TMNW2_ConstrainPumpingParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMNW2_PartialPenetrationFlagParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMNW2_PumpTypeParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TMNW2_PumpElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_PumpingLimitTypeParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
  end;

  TMNW2_LimitingWaterLevelParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_InactivationPumpingRateParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_ReactivationPumpingRateParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_DischargeElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TCustomWellScreen = class(T_ANE_LayerParam)
    function Value: string; override;
  end;

  TMNW2_TopWellScreenParam = class(TCustomWellScreen)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_BottomWellScreenParam = class(TCustomWellScreen)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_ActiveParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TMNW2_PumpingRateParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMNW2_HeadCapacityMultiplierParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TMNW2_OrderParam= class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
    function Units: string; override;
  end;

  TMNW2_UpperElevParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TMNW2_LowerElevParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TCustomMonitorWell = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMonitorWellFlowParam = class(TCustomMonitorWell)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMonitorExternalFlowParam = class(TCustomMonitorWell)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMonitorInternalFlowParam = class(TCustomMonitorWell)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TMonitorConcentrationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
  end;

  TMNW2_WellScreenParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TMNW2_TimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TCustomMnw2Layer = class(T_ANE_InfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
  end;

  TMNW2_VerticalWellLayer = class(TCustomMnw2Layer)
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

  TMNW2_GeneralWellLayer = class(TCustomMnw2Layer)
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

implementation

uses Variables, ModflowUnit;

const
  kWellId = 'Well_Id';
  kScreenCount = 'Number of Screens';
  kLossType = 'LossType';
  kSkinRadius = 'Skin Radius';
  kSkinK = 'Skin K';
  kB = 'B';
  kC = 'C';
  kP = 'P';
  kCWC = 'Cell to Well Conductance';
  kSpecifyPump = 'Specify Pump Intake Location';
  kConstrainPumping = 'Constrain Pumping';
  kPartialPenetrationFlag = 'Partial Penetration Flag';
  kPumpType = 'Pump Type';
  kPumpElevation = 'Pump Intake Elevation';
  kPumpingLimitType = 'Pumping Constraint Type';
  kLimitingWaterLevel = 'Limiting Water Level';
  kInactivation = 'Deactivation Pumping Rate';
  kReactivation = 'Reactivation Pumping Rate';
  kDischargeElevation = 'Discharge Elevation';
  kTopWellScreen = 'Top Well Screen';
  kBottomWellScreen = 'Bottom Well Screen';
  kActive = 'Active';
  kPumpingRate = 'Desired Pumping Rate';
  kHeadCapacityMultiplier = 'Head Capacity Multiplier';
  kVertMNW = 'Vertical Multi_Node Well_2';
  kOrder = 'Well Screen Order';
  kUpperElevation = 'Upper Elevation';
  kLowerElevation = 'Lower Elevation';
  kGeneralMNW = 'General Multi_Node Well_2';
  kMonitorWell = 'Monitor Well';
  kMonitorExternalFlows = 'Monitor External Flows';
  kMonitorInternalFlows = 'Monitor Internal Flows';
//  KMonitorConcentration = 'Monitor Concetration';
  KMonitorConcentration = 'Monitor Concentration';

{ TMNW2_WellIdParam }

class function TMNW2_WellIdParam.ANE_ParamName: string;
begin
  result := kWellId;
end;

constructor TMNW2_WellIdParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TMNW2_WellIdParam.Units: string;
begin
  result := 'Well name (<= 20 characters)';
end;

function TMNW2_WellIdParam.Value: string;
begin
  result := '0';
end;

{ TMNW2_NodeCountParam }

class function TMNW2_NodeCountParam.ANE_ParamName: string;
begin
  result := kScreenCount;
end;

constructor TMNW2_NodeCountParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TMNW2_NodeCountParam.Units: string;
begin
  result := 'NNODES'
end;

function TMNW2_NodeCountParam.Value: string;
begin
  result := '1';
end;

{ TMNW2_LossTypeParam }

class function TMNW2_LossTypeParam.ANE_ParamName: string;
begin
  result := kLossType;
end;

constructor TMNW2_LossTypeParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TMNW2_LossTypeParam.Units: string;
var
  Choices: TStringList;
  CheckList: TCheckListBox;
  Index: Integer;
begin
  CheckList := frmModflow.clbMnw2LossTypes;
  Choices := TStringList.Create;
  try
    Choices.Add('NONE');
    if CheckList.Checked[Ord(ltcThiem)] then
    begin
      Choices.Add('THIEM');
    end;
    if CheckList.Checked[Ord(ltcSkin)] then
    begin
      Choices.Add('SKIN');
    end;
    if CheckList.Checked[Ord(ltcGeneral)] then
    begin
      Choices.Add('GENERAL');
    end;
    if CheckList.Checked[Ord(ltcSpecify)] then
    begin
      Choices.Add('SPECIFYcwc');
    end;
    case Choices.Count of
      1:
        begin
          result := Choices[0];
        end;
      2:
        begin
          result := Choices[0] + ' or ' + Choices[1];
        end;
      3,4,5:
        begin
          result := '';
          for Index := 0 to Choices.Count - 2 do
          begin
            result := result + Choices[Index] + ', ';
          end;
          result := result + ' or ' + Choices[Choices.Count - 1]
        end;
      else
        Assert(False);
    end;
  finally
    Choices.Free;
  end;
  result := 'NONE, THIEM, SKIN, GENERAL, or SPECIFYcwc';
end;

function TMNW2_LossTypeParam.Value: string;
var
  CheckList: TCheckListBox;
begin
  CheckList := frmModflow.clbMnw2LossTypes;
  if CheckList.Checked[Ord(ltcThiem)] then
  begin
    result := '"THIEM"';
  end
  else if CheckList.Checked[Ord(ltcSkin)] then
  begin
    result := '"SKIN"';
  end
  else if CheckList.Checked[Ord(ltcGeneral)] then
  begin
    result := '"GENERAL"';
  end
  else if CheckList.Checked[Ord(ltcSpecify)] then
  begin
    result := '"SPECIFYcwc"';
  end
  else
  begin
    result := '"NONE"';
  end;
end;

{ TMNW2_WellRadiusParam }

function TMNW2_WellRadiusParam.Units: string;
begin
  result := 'THIEM, SKIN, GENERAL'
end;

{ TMNW2_SkinRadiusParam }

class function TMNW2_SkinRadiusParam.ANE_ParamName: string;
begin
  result := kSkinRadius;
end;

function TMNW2_SkinRadiusParam.Units: string;
begin
  result := 'LossType = SKIN';
end;

{ TMNW2_SkinKParam }

class function TMNW2_SkinKParam.ANE_ParamName: string;
begin
  result := kSkinK;
end;

function TMNW2_SkinKParam.Units: string;
begin
  result := 'LossType = SKIN';
end;

{ TMNW2_BParam }

class function TMNW2_BParam.ANE_ParamName: string;
begin
  result := kB;
end;

function TMNW2_BParam.Units: string;
begin
  result := 'LossType = GENERAL';
end;

{ TMNW2_CParam }

class function TMNW2_CParam.ANE_ParamName: string;
begin
  result := kC;
end;

function TMNW2_CParam.Units: string;
begin
  result := 'LossType = GENERAL';
end;

{ TMNW2_PParam }

class function TMNW2_PParam.ANE_ParamName: string;
begin
  result := kP;
end;

function TMNW2_PParam.Units: string;
begin
  result := 'LossType = GENERAL';
end;

function TMNW2_PParam.Value: string;
begin
  result := '2';
end;

{ TMNW2_CellToWellConductanceParam }

class function TMNW2_CellToWellConductanceParam.ANE_ParamName: string;
begin
  result := kCWC;
end;

function TMNW2_CellToWellConductanceParam.Units: string;
begin
  result := 'LossType = SPECIFYcwc';
end;

{ TMNW2_SpecifyPumpParam }

class function TMNW2_SpecifyPumpParam.ANE_ParamName: string;
begin
  result := kSpecifyPump;
end;

constructor TMNW2_SpecifyPumpParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TMNW2_SpecifyPumpParam.Units: string;
begin
  result := 'PUMPLOC';
end;

function TMNW2_SpecifyPumpParam.Value: string;
begin
  result := '1';
end;

{ TMNW2_ConstrainPumpingParam }

class function TMNW2_ConstrainPumpingParam.ANE_ParamName: string;
begin
  result := kConstrainPumping;
end;

constructor TMNW2_ConstrainPumpingParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TMNW2_ConstrainPumpingParam.Units: string;
begin
  result := 'Qlimit';
end;

{ TMNW2_PartialPenetrationFlagParam }

class function TMNW2_PartialPenetrationFlagParam.ANE_ParamName: string;
begin
  result := kPartialPenetrationFlag;
end;

constructor TMNW2_PartialPenetrationFlagParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TMNW2_PartialPenetrationFlagParam.Units: string;
begin
  result := 'PPFLAG';
end;

{ TMNW2_PumpTypeParam }

class function TMNW2_PumpTypeParam.ANE_ParamName: string;
begin
  result := kPumpType;
end;

constructor TMNW2_PumpTypeParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TMNW2_PumpTypeParam.Units: string;
begin
  result := 'Name from list (PUMPCAP)';
end;

function TMNW2_PumpTypeParam.Value: string;
begin
  result := kNA;
end;

{ TMNW2_PumpElevationParam }

class function TMNW2_PumpElevationParam.ANE_ParamName: string;
begin
  result := kPumpElevation;
end;

function TMNW2_PumpElevationParam.Units: string;
begin
  result := 'Zpump';
end;

{ TMNW2_PumpingLimitTypeParam }

class function TMNW2_PumpingLimitTypeParam.ANE_ParamName: string;
begin
  result := kPumpingLimitType;
end;

constructor TMNW2_PumpingLimitTypeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TMNW2_PumpingLimitTypeParam.Units: string;
begin
  result := 'QCUT (-1, 0, or 1)';
end;

{ TMNW2_LimitingWaterLevelParam }

class function TMNW2_LimitingWaterLevelParam.ANE_ParamName: string;
begin
  result := kLimitingWaterLevel;
end;

function TMNW2_LimitingWaterLevelParam.Units: string;
begin
  result := 'Hlim';
end;

{ TMNW2_InactivationPumpingRateParam }

class function TMNW2_InactivationPumpingRateParam.ANE_ParamName: string;
begin
  result := kInactivation;
end;

function TMNW2_InactivationPumpingRateParam.Units: string;
begin
  result := 'Qfrcmn';
end;

{ TMNW2_ReactivationPumpingRateParam }

class function TMNW2_ReactivationPumpingRateParam.ANE_ParamName: string;
begin
  result := kReactivation;
end;

function TMNW2_ReactivationPumpingRateParam.Units: string;
begin
  result := 'Qfrcmx';
end;

{ TMNW2_DischargeElevationParam }

class function TMNW2_DischargeElevationParam.ANE_ParamName: string;
begin
  result := kDischargeElevation;
end;

function TMNW2_DischargeElevationParam.Units: string;
begin
  result := 'Hlift';
end;

{ TMNW2_TopWellScreenParam }

class function TMNW2_TopWellScreenParam.ANE_ParamName: string;
begin
  result := kTopWellScreen;
end;

function TMNW2_TopWellScreenParam.Units: string;
begin
  result := 'Ztop';
end;

{ TMNW2_BottomWellScreenParam }

class function TMNW2_BottomWellScreenParam.ANE_ParamName: string;
begin
  result := kBottomWellScreen;
end;

function TMNW2_BottomWellScreenParam.Units: string;
begin
  result := 'Zbotm';
end;

{ TMNW2_ActiveParam }

class function TMNW2_ActiveParam.ANE_ParamName: string;
begin
  result := kActive;
end;

constructor TMNW2_ActiveParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TMNW2_ActiveParam.Units: string;
begin
  result := 'Well is active in indicated stress period';
end;

function TMNW2_ActiveParam.Value: string;
begin
  result := '1';
end;

{ TMNW2_PumpingRateParam }

class function TMNW2_PumpingRateParam.ANE_ParamName: string;
begin
  result := kPumpingRate;
end;

function TMNW2_PumpingRateParam.Units: string;
begin
  result := 'Qdes';
end;

{ TMNW2_HeadCapacityMultiplierParam }

class function TMNW2_HeadCapacityMultiplierParam.ANE_ParamName: string;
begin
  result := kHeadCapacityMultiplier;
end;

function TMNW2_HeadCapacityMultiplierParam.Units: string;
begin
  result := 'CapMult';
end;

function TMNW2_HeadCapacityMultiplierParam.Value: string;
begin
  result := '1';
end;

{ TMNW2_WellScreenParamList }

constructor TMNW2_WellScreenParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_TopWellScreenParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_BottomWellScreenParamType.ANE_ParamName);

  ModflowTypes.GetMF_MNW2_TopWellScreenParamType.Create(self, -1);
  ModflowTypes.GetMF_MNW2_BottomWellScreenParamType.Create(self, -1);

end;

{ TMNW2_TimeParamList }

constructor TMNW2_TimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_ActiveParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PumpingRateParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_HeadCapacityMultiplierParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_LimitingWaterLevelParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PumpingLimitTypeParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_InactivationPumpingRateParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_ReactivationPumpingRateParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.
    GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMF_MNW2_ActiveParamType.Create(self, -1);
  ModflowTypes.GetMF_MNW2_PumpingRateParamType.Create(self, -1);

  if frmModflow.cbMnw2Pumpcap.Checked then
  begin
    ModflowTypes.GetMF_MNW2_HeadCapacityMultiplierParamType.Create(self, -1);
  end;

  if frmModflow.cbMnw2Pumpcap.Checked
    and frmModflow.cbMnw2TimeVarying.Checked then
  begin
    ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType.Create(self, -1);
    ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType.Create(self, -1);
    ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType.Create(self, -1);
    ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType.Create(self, -1);
  end;

  if frmModflow.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create(self, -1);
  end;

  if frmModflow.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFIFACEParamType.Create(self, -1);
  end;

end;

{ TCustomWellScreen }

function TCustomWellScreen.Value: string;
begin
  result := 'If(' + WriteIndex + ' <= '
    + ModflowTypes.GetMF_MNW2_NodeCountParamType.WriteParamName
    + ', 0, ' + kNa + ')';

end;

{ TMNW2_VerticalWellLayer }

class function TMNW2_VerticalWellLayer.ANE_LayerName: string;
begin
  result := kVertMNW;
end;

constructor TMNW2_VerticalWellLayer.Create(ALayerList: T_ANE_LayerList; Index: Integer);
var
  MaxWellScreens: Integer;
  ScreenIndex: Integer;
begin
  inherited;
  // NNODES
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_NodeCountParamType.ANE_ParamName);
  // NNODES
  ModflowTypes.GetMF_MNW2_NodeCountParamType.Create(ParamList, -1);

  MaxWellScreens := StrToInt(frmMODFLOW.adeMnw2WellScreens.Text);
  for ScreenIndex := 0 to MaxWellScreens - 1 do
  begin
    ModflowTypes.GetMFMNW2_WellScreenParamListType.Create(IndexedParamList1, -1);
  end;
end;

{ TCustomMnw2Layer }

constructor TCustomMnw2Layer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  LossTypeChoices: TMnw2LossTypeSet;
  NumberOfTimes: Integer;
  TimeIndex: Integer;
begin
  inherited;
  // WELLID
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_WellIdParamType.ANE_ParamName);
  // Qlimit
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_ConstrainPumpingParamType.ANE_ParamName);
  // PPFLAG
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PartialPenetrationFlagParamType.ANE_ParamName);
  // PUMPLOC
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_SpecifyPumpParamType.ANE_ParamName);
  // Zpump
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PumpElevationParamType.ANE_ParamName);
  // Hlim
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_LimitingWaterLevelParamType.ANE_ParamName);
  // QCUT
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PumpingLimitTypeParamType.ANE_ParamName);
  // Qfrcmn
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_InactivationPumpingRateParamType.ANE_ParamName);
  // Qfrcmx
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_ReactivationPumpingRateParamType.ANE_ParamName);

  // LOSSTYPE
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_LossTypeParamType.ANE_ParamName);
  // Rw
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_WellRadiusParamType.ANE_ParamName);
  // Rskin
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_SkinRadiusParamType.ANE_ParamName);
  // Kskin
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_SkinKParamType.ANE_ParamName);
  // B
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_BParamType.ANE_ParamName);
  // C
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_CParamType.ANE_ParamName);
  // P
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PParamType.ANE_ParamName);
  // CWC
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_CellToWellConductanceParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_PumpTypeParamType.ANE_ParamName);
  // Hlift
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_DischargeElevationParamType.ANE_ParamName);

  // MNWI


  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_MonitorWellFlowParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_MonitorExternalFlowParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_MonitorInternalFlowParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMF_MNW2_MonitorConcentrationParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFMNW_IsPTOB_ObservationParamType.ANE_ParamName);

  // WELLID
  ModflowTypes.GetMF_MNW2_WellIdParamType.Create(ParamList, -1);
  // Qlimit
  ModflowTypes.GetMF_MNW2_ConstrainPumpingParamType.Create(ParamList, -1);
  // PPFLAG
  ModflowTypes.GetMF_MNW2_PartialPenetrationFlagParamType.Create(ParamList, -1);
  // PUMPLOC
  ModflowTypes.GetMF_MNW2_SpecifyPumpParamType.Create(ParamList, -1);
  // Zpump
  ModflowTypes.GetMF_MNW2_PumpElevationParamType.Create(ParamList, -1);
  if frmModflow.cbMnw2Pumpcap.Checked
    and not frmModflow.cbMnw2TimeVarying.Checked then
  begin
    // Hlim
    ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType.Create(ParamList, -1);
    // QCUT
    ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType.Create(ParamList, -1);
    // Qfrcmn
    ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType.Create(ParamList, -1);
    // Qfrcmx
    ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType.Create(ParamList, -1);
  end;

  LossTypeChoices := frmMODFLOW.Mnw2LossTypeChoices;
  if LossTypeChoices <> [] then
  begin
    // LOSSTYPE
    ModflowTypes.GetMF_MNW2_LossTypeParamType.Create(ParamList, -1);
    if ([ltcThiem, ltcSkin, ltcGeneral] * LossTypeChoices) <> [] then
    begin
      // Rw
      ModflowTypes.GetMF_MNW2_WellRadiusParamType.Create(ParamList, -1);
    end;
    if ltcSkin in LossTypeChoices then
    begin
      // Rskin
      ModflowTypes.GetMF_MNW2_SkinRadiusParamType.Create(ParamList, -1);
      // Kskin
      ModflowTypes.GetMF_MNW2_SkinKParamType.Create(ParamList, -1);
    end;
    if ltcGeneral in LossTypeChoices then
    begin
      // B
      ModflowTypes.GetMF_MNW2_BParamType.Create(ParamList, -1);
      // C
      ModflowTypes.GetMF_MNW2_CParamType.Create(ParamList, -1);
      // P
      ModflowTypes.GetMF_MNW2_PParamType.Create(ParamList, -1);
    end;
    if ltcSpecify in LossTypeChoices then
    begin
      // CWC
      ModflowTypes.GetMF_MNW2_CellToWellConductanceParamType.Create(ParamList, -1);
    end;
  end;
  if frmMODFLOW.cbMnw2Pumpcap.Checked then
  begin
    ModflowTypes.GetMF_MNW2_PumpTypeParamType.Create(ParamList, -1);
    // Hlift
    ModflowTypes.GetMF_MNW2_DischargeElevationParamType.Create(ParamList, -1);
  end;

  if frmMODFLOW.cbMnwi.Checked then
  begin
    ModflowTypes.GetMF_MNW2_MonitorWellFlowParamType.Create(ParamList, -1);
    ModflowTypes.GetMF_MNW2_MonitorExternalFlowParamType.Create(ParamList, -1);
    ModflowTypes.GetMF_MNW2_MonitorInternalFlowParamType.Create(ParamList, -1);
    if frmModflow.cbMOC3D.Checked then
    begin
      ModflowTypes.GetMF_MNW2_MonitorConcentrationParamType.Create(ParamList, -1);
    end;
  end;

  if frmModflow.cbMOC3D.Checked and
    frmModflow.cbParticleObservations.Checked then
  begin
    ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType.Create(ParamList, -1);
  end;


  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  for TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMNW2_TimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

{ TMNW2_OrderParam }

class function TMNW2_OrderParam.ANE_ParamName: string;
begin
  result := kOrder;
end;

constructor TMNW2_OrderParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TMNW2_OrderParam.Units: string;
begin
  result := 'Position of well screen';
end;

function TMNW2_OrderParam.Value: string;
begin
  result := '1';
end;

{ TMNW2_UpperElevParam }

class function TMNW2_UpperElevParam.ANE_ParamName: string;
begin
  result := kUpperElevation;
end;

{ TMNW2_LowerElevParam }

class function TMNW2_LowerElevParam.ANE_ParamName: string;
begin
  result := kLowerElevation;
end;

{ TMNW2_GeneralWellLayer }

class function TMNW2_GeneralWellLayer.ANE_LayerName: string;
begin
  result := kGeneralMNW;
end;

constructor TMNW2_GeneralWellLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(1, ModflowTypes.
    GetMF_MNW2_OrderParamType.ANE_ParamName);
  ParamList.ParameterOrder.Insert(2, ModflowTypes.
    GetMF_MNW2_UpperElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Insert(3, ModflowTypes.
    GetMF_MNW2_LowerElevParamType.ANE_ParamName);

  ModflowTypes.GetMF_MNW2_OrderParamType.Create(ParamList, -1);
  ModflowTypes.GetMF_MNW2_UpperElevParamType.Create(ParamList, -1);
  ModflowTypes.GetMF_MNW2_LowerElevParamType.Create(ParamList, -1);
end;

{ TCustomMonitorWell }

constructor TCustomMonitorWell.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

{ TMonitorExternalFlowParam }

class function TMonitorExternalFlowParam.ANE_ParamName: string;
begin
  result := kMonitorExternalFlows;
end;

function TMonitorExternalFlowParam.Units: string;
begin
  result := 'QNDflag'
end;

{ TMonitorInternalFlowParam }

class function TMonitorInternalFlowParam.ANE_ParamName: string;
begin
  result := kMonitorInternalFlows;
end;

function TMonitorInternalFlowParam.Units: string;
begin
  result := 'QBHflag';
end;

{ TMonitorConcentrationParam }

class function TMonitorConcentrationParam.ANE_ParamName: string;
begin
  result := KMonitorConcentration;
end;

constructor TMonitorConcentrationParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TMonitorConcentrationParam.Units: string;
begin
  result := '0-3, CONCflag';
end;

{ TMonitorWellFlowParam }

class function TMonitorWellFlowParam.ANE_ParamName: string;
begin
  result := kMonitorWell
end;

function TMonitorWellFlowParam.Units: string;
begin
  result := 'Activate MNWI';
end;

end.
