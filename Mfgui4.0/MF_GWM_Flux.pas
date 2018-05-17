unit MF_GWM_Flux;

interface

uses SysUtils, ANE_LayerUnit;

type
  TFluxVariableName = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  TFluxType = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  TFluxStat = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  TFluxVariableRatio = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : String; override;
  end;

  TFluxMinimum = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TFluxMaximum = class(TFluxMinimum)
    class Function ANE_ParamName : string ; override;
  end;

  TFluxReference = class(TFluxMinimum)
    class Function ANE_ParamName : string ; override;
  end;

  TFluxBase = class(TFluxMinimum)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TFluxVariableLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;



implementation

uses Variables;

resourcestring
  rsFluxVarName = 'Name';
  rsFluxType = 'Withdrawal or Injection';
  rsFluxStat = 'Use Variable';
  rsRatio = 'Ratio';
  rsMinimum = 'Minimum';
  rsMaximum = 'Maximum';
  rsReferenceFlux = 'Reference Flux';
  rsBaseFlux = 'Base Flux';
  rsFluxVariableUnit = 'Flux Decision Variable Unit';

{ TFluxVariableName }

class function TFluxVariableName.ANE_ParamName: string;
begin
  result := rsFluxVarName;
end;

constructor TFluxVariableName.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TFluxVariableName.Units: string;
begin
  result := '<= 10 characters'
end;

function TFluxVariableName.Value: String;
begin
  result := '"A_Name"';
end;

{ TFluxType }

class function TFluxType.ANE_ParamName: string;
begin
  result := rsFluxType;
end;

constructor TFluxType.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TFluxType.Units: string;
begin
  result := 'W or I';
end;

function TFluxType.Value: String;
begin
  result := '"W"';
end;

{ TFluxStat }

class function TFluxStat.ANE_ParamName: string;
begin
  result := rsFluxStat;
end;

constructor TFluxStat.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TFluxStat.Units: string;
begin
  result := 'Y or N';
end;

function TFluxStat.Value: String;
begin
  result := '"Y"';
end;

{ TFluxVariableLayer }

class function TFluxVariableLayer.ANE_LayerName: string;
begin
  result := rsFluxVariableUnit;
end;

constructor TFluxVariableLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxVariableNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxTypeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxStatParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxVariableRatioParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxMinimumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxMaximumParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxReferenceParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFluxBaseParamType.ANE_ParamName);


  ModflowTypes.GetMFFluxVariableNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFluxTypeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFluxStatParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFluxVariableRatioParamType.Create( ParamList, -1);

  ModflowTypes.GetMFFluxMinimumParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFluxMaximumParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFluxReferenceParamType.Create( ParamList, -1);
  if frmModflow.rgGWM_SolutionType.ItemIndex = 3 then
  begin
    ModflowTypes.GetMFFluxBaseParamType.Create( ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;

end;


{ TFluxVariableRatio }

class function TFluxVariableRatio.ANE_ParamName: string;
begin
  result := rsRatio;
end;

function TFluxVariableRatio.Units: string;
begin
  result := '>0, <=1';
end;

function TFluxVariableRatio.Value: String;
begin
  result := '1';
end;

{ TFluxMinimum }

class function TFluxMinimum.ANE_ParamName: string;
begin
  result := rsMinimum;
end;

function TFluxMinimum.Units: string;
begin
  result := LengthUnit + '^3/' + TimeUnit;
end;

{ TFluxReference }

class function TFluxReference.ANE_ParamName: string;
begin
  result := rsReferenceFlux;
end;

{ TFluxMaximum }

class function TFluxMaximum.ANE_ParamName: string;
begin
  result := rsMaximum;
end;

{ TFluxBase }

class function TFluxBase.ANE_ParamName: string;
begin
  result := rsBaseFlux;
end;

function TFluxBase.Value: string;
begin
  result := ModflowTypes.GetMFFluxVariableLayerType.ANE_LayerName
    + GetParentLayer.WriteIndex
    + '.' + ModflowTypes.GetMFFluxReferenceParamType.ANE_ParamName;
end;

end.
