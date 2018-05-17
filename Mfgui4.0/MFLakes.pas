unit MFLakes;

interface

uses ANE_LayerUnit, MFGenParam;

type
  TLakeNumberParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
  end;

  TLakeBottomElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeBottomParam = class(TLakeBottomElevParam)
    function Value : String; override;
    function Units : string; override;
  end;

  TGageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TGageOutputTypeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TCustomLakeUnitParameter = class(TCustomUnitParameter)
{$IFDEF ARGUS5}
    function UnitSimulated : boolean; override;
{$ENDIF}
  end;

  TLakeHydraulicCondParam = class(TCustomLakeUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLakeThicknessParam = class(TCustomLakeUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TCustomStageParam = class(T_ANE_LayerParam)
    function Units : string; override;
  end;

  TLakeInitialStageParam = class(TCustomStageParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeMinimumStageParam = class(TCustomStageParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeMaximumStageParam = class(TCustomStageParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TCustomConcParam = class(T_ANE_LayerParam)
    function Units : string; override;
  end;

  TLakeInitialConcParam = class(TCustomConcParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TCenterLakeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
  end;

  TLakeSillParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakePrecipParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeEvapParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeRunoffParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeWithdrawalsParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakePrecipConcParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeRunoffConcParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeAugmentationConcParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer); override;
    function IsSteadyStress : boolean; override;
  end;

  TLeakConductanceTimeList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer); override;
    function IsSteadyStress : boolean; override;
  end;

  TLakeLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLakeBottomLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLakeLeakanceLayer = Class(TIndexedInfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLakeLeakanceList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TLakeGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Sysutils, Variables;

resourcestring
  kLakeNumber = 'Lake Number';
  kLakeBottom = 'Lake Bottom';
  kGage = 'Gage';
  kGageOutputtype = 'Gage Output type';
  kHydraulicCond = 'Lakebed hydraulic conductivity';
  kThickness = 'Lakebed thickness';
  kInitStage = 'Initial Stage';
  kMinStage = 'Minimum Stage';
  kMaxStage = 'Maximum Stage';
  kInitConc = 'Initial Concentration';
  kCenterLake = 'Center Lake';
  kSill = 'Sill';
  kEvap = 'Evap';
  kPrecip = 'Precip';
  kRunoff = 'Runoff';
  kWithdrawals = 'Withdrawals';
  kPrecipConc ='Precip Conc';
  kRunoffConc ='Runoff Conc';
  kAugmentationConc ='Augmentation Conc';
  kLakeLayer = 'Lakes';
  kLakeBottomLayer = 'Lake Bottom';
  kLakeLeakance = 'Lake Leakance Unit';

{ TLakeNumberParam }

class function TLakeNumberParam.ANE_ParamName: string;
begin
  result := kLakeNumber;
end;

constructor TLakeNumberParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TLakeNumberParam.Units: string;
begin
  result := '(LKARR)';
end;

{ TGageParam }

class function TGageParam.ANE_ParamName: string;
begin
  result := kGage;
end;

constructor TGageParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TGageParam.Units: string;
begin
  result := '(LAKE or STREAM)';
end;

{ TLakeHydraulicCondParam }

class function TLakeHydraulicCondParam.ANE_ParamName: string;
begin
  result := kHydraulicCond;
end;

function TLakeHydraulicCondParam.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit + ' (BDLKNC)';
end;

function TLakeHydraulicCondParam.Value: string;
begin
  result := '100';
end;

{ TLakeThicknessParam }

class function TLakeThicknessParam.ANE_ParamName: string;
begin
  result := kThickness;
end;

function TLakeThicknessParam.Units: string;
begin
  result := LengthUnit + ' (BDLKNC)';
end;

function TLakeThicknessParam.Value: string;
begin
  result := '1';
end;

{ TCustomStageParam }

function TCustomStageParam.Units: string;
begin
  result := LengthUnit;
end;

{ TLakeInitialStageParam }

class function TLakeInitialStageParam.ANE_ParamName: string;
begin
  result := kInitStage;
end;

function TLakeInitialStageParam.Units: string;
begin
  result := inherited Units + ' (STAGES)';
end;

{ TLakeMinimumStageParam }

class function TLakeMinimumStageParam.ANE_ParamName: string;
begin
  result := kMinStage;
end;

function TLakeMinimumStageParam.Units: string;
begin
  result := inherited Units + ' (SSMN)';
end;

{ TLakeMaximumStageParam }

class function TLakeMaximumStageParam.ANE_ParamName: string;
begin
  result := kMaxStage;
end;

function TLakeMaximumStageParam.Units: string;
begin
  result := inherited Units + ' (SSMX)';
end;

{ TCustomConcParam }

function TCustomConcParam.Units: string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

{ TInitialConcParam }

class function TLakeInitialConcParam.ANE_ParamName: string;
begin
  result := kInitConc;
end;

{ TCenterLakeParam }

class function TCenterLakeParam.ANE_ParamName: string;
begin
  result := kCenterLake;
end;

constructor TCenterLakeParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TCenterLakeParam.Units: string;
begin
  result := '(IC, ISUB(i))';
end;

{ TLakeSillParam }

class function TLakeSillParam.ANE_ParamName: string;
begin
  result := kSill;
end;

function TLakeSillParam.Units: string;
begin
  result := LengthUnit + ' (SILLVT(i))';
end;

{ TLakePrecipParam }

class function TLakePrecipParam.ANE_ParamName: string;
begin
  result := kPrecip;
end;

function TLakePrecipParam.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit + ' (PRCPLK)';
end;

{ TLakeEvapParam }

class function TLakeEvapParam.ANE_ParamName: string;
begin
  result := kEvap;
end;

function TLakeEvapParam.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit + ' (EVAPLK)';
end;

{ TLakeRunoffParam }

class function TLakeRunoffParam.ANE_ParamName: string;
begin
  result := kRunoff;
end;

function TLakeRunoffParam.Units: string;
begin
  result := LengthUnit + '^3/' + TimeUnit + ' (RNF)';
end;

{ TLakeWithdrawalsParam }

class function TLakeWithdrawalsParam.ANE_ParamName: string;
begin
  result := kWithdrawals;
end;

function TLakeWithdrawalsParam.Units: string;
begin
  result := LengthUnit + '^3/' + TimeUnit + ' (WTHDRW)';
end;

{ TLakePrecipConcParam }

class function TLakePrecipConcParam.ANE_ParamName: string;
begin
  result := kPrecipConc;
end;

function TLakePrecipConcParam.Units: string;
begin
  result := 'M/' + LengthUnit + '^3' + ' (CCPT)';
end;

{ TLakeRunoffConcParam }

class function TLakeRunoffConcParam.ANE_ParamName: string;
begin
  result := kRunoffConc;
end;

function TLakeRunoffConcParam.Units: string;
begin
  result := 'M/' + LengthUnit + '^3' + ' (CRNF)';
end;

{ TLakeAugmentationConcParam }

class function TLakeAugmentationConcParam.ANE_ParamName: string;
begin
  result := kAugmentationConc;
end;

function TLakeAugmentationConcParam.Units: string;
begin
  result := 'M/' + LengthUnit + '^3' + ' (CAUG)';
end;

{ TLakeTimeParamList }

constructor TLakeTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFLakePrecipParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakeEvapParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakeRunoffParamParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakeWithdrawalsParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakePrecipConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakeRunoffConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakeAugmentationConcParamType.ANE_ParamName);

  ModflowTypes.GetMFLakePrecipParamType.Create( self, -1);
  ModflowTypes.GetMFLakeEvapParamType.Create( self, -1);
  ModflowTypes.GetMFLakeRunoffParamParamType.Create( self, -1);
  ModflowTypes.GetMFLakeWithdrawalsParamType.Create( self, -1);

  if frmModflow.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFLakePrecipConcParamType.Create( self, -1);
    ModflowTypes.GetMFLakeRunoffConcParamType.Create( self, -1);
    ModflowTypes.GetMFLakeAugmentationConcParamType.Create( self, -1);
  end;

end;

function TLakeTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboLakSteady.ItemIndex = 0;
end;

{ TLakeLayer }

class function TLakeLayer.ANE_LayerName: string;
begin
  result := kLakeLayer;
end;

constructor TLakeLayer.Create(ALayerList: T_ANE_LayerList; Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeNumberParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeBottomParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGageParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGageOutputTypeParamType.ANE_ParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeHydraulicCondParamType.ANE_ParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeThicknessParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeInitialStageParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeMinimumStageParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeMaximumStageParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFCenterLakeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeSillParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFLakeInitialConcParamType.ANE_ParamName);

  ModflowTypes.GetMFLakeNumberParamType.Create( ParamList, -1);
  ModflowTypes.GetMFLakeBottomParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGageParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGageOutputTypeParamType.Create( ParamList, -1);
//  ModflowTypes.GetMFLakeHydraulicCondParamType.Create( ParamList, -1);
//  ModflowTypes.GetMFLakeThicknessParamType.Create( ParamList, -1);
  ModflowTypes.GetMFLakeInitialStageParamType.Create( ParamList, -1);

  if frmModflow.IsAnySteady then
  begin
    ModflowTypes.GetMFLakeMinimumStageParamType.Create( ParamList, -1);
    ModflowTypes.GetMFLakeMaximumStageParamType.Create( ParamList, -1);
  end;

  if frmModflow.cbSubLakes.Checked then
  begin
    ModflowTypes.GetMFCenterLakeParamType.Create( ParamList, -1);
    ModflowTypes.GetMFLakeSillParamType.Create( ParamList, -1);
  end;

  if frmModflow.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFLakeInitialConcParamType.Create( ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFLakeTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

{ TLakeBottomParam }

function TLakeBottomParam.Units: string;
begin
  result := LengthUnit + ' (LKARR)';
end;

function TLakeBottomParam.Value: String;
begin
  result := ModflowTypes.GetMFLakeBottomLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFLakeBottomElevParamParamType.WriteParamName;
end;

{ TLakeBottomElevParam }

class function TLakeBottomElevParam.ANE_ParamName: string;
begin
  result := kLakeBottom;
end;

function TLakeBottomElevParam.Units: string;
begin
  result := LengthUnit + ' (LKARR)';
end;

{ TLakeBottomLayer }

class function TLakeBottomLayer.ANE_LayerName: string;
begin
  result := kLakeBottomLayer;
end;

constructor TLakeBottomLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := le624;
  ModflowTypes.GetMFLakeBottomElevParamParamType.Create( ParamList, -1);
end;

{ TLakeLeakanceLayer }

class function TLakeLeakanceLayer.ANE_LayerName: string;
begin
  result := kLakeLeakance;
end;

constructor TLakeLeakanceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumberOfTimes: Integer;
  TimeIndex: Integer;
begin
  inherited;
  if frmModflow.comboLakSteadyLeakance.ItemIndex = 0 then
  begin
    ModflowTypes.GetMFLakeHydraulicCondParamType.Create( ParamList, -1);
    ModflowTypes.GetMFLakeThicknessParamType.Create( ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFLeakConductanceParamListType.Create( IndexedParamList2, -1);
  end;

end;

{ TLakeLeakanceList }

constructor TLakeLeakanceList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  RenameAllLayers := True;
  if frmModflow.cbLak.Checked then
  begin
    for Index := 0 to StrToInt(frmMODFLOW.edNumUnits.Text)-1 do
    begin
      ModflowTypes.GetMFLakeLeakanceLayerType.Create(self, -1);
    end;
  end;

end;

{ TCustomLakeUnitParameter }

{$IFDEF ARGUS5}
function TCustomLakeUnitParameter.UnitSimulated: boolean;
var
  ParentLayer : T_ANE_Layer;
  UnitIndex : integer;
  Index : integer;
  ALayer : T_ANE_MapsLayer;
begin
  result := False;
  ParentLayer := GetParentLayer;
  UnitIndex := 0;
  for Index := 0 to ParentLayer.LayerList.Count -1 do
  begin
    ALayer := ParentLayer.LayerList.Items[Index];
    if ALayer.Status <> sDeleted then
    begin
      Inc(UnitIndex);
    end;
    if ALayer = ParentLayer then
    begin
      break;
    end;
  end;
  if UnitIndex > 0 then
  begin
    result := frmModflow.Simulated(UnitIndex);
  end;
end;
{$ENDIF}

{ TGageOutputTypeParam }

class function TGageOutputTypeParam.ANE_ParamName: string;
begin
  result := kGageOutputtype;
end;

constructor TGageOutputTypeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGageOutputTypeParam.Units: string;
begin
  result := '0 to 3 (OUTTYPE)';
end;

{ TLakeGroupLayer }

class function TLakeGroupLayer.ANE_LayerName: string;
begin
  result := 'Lake Layers';
end;

function TLakeInitialConcParam.Units: string;
begin
  result := inherited Units + ' (CLAKE)';
end;

{ TLeakConductanceTimeList }

constructor TLeakConductanceTimeList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFLakeHydraulicCondParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLakeThicknessParamType.ANE_ParamName);
  if not IsSteadyStress then
  begin
    ModflowTypes.GetMFLakeHydraulicCondParamType.Create( self, -1);
    ModflowTypes.GetMFLakeThicknessParamType.Create( self, -1);
  end;
end;

function TLeakConductanceTimeList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboLakSteadyLeakance.ItemIndex = 0;
end;

end.
