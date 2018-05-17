unit MF_HYDMOD_Unit;

interface

uses SysUtils, ANE_LayerUnit, MFGenParam;

type

  THydmodElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodModflowLayerParam = class(TModflowLayerParam)
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TCustomHydmodParam = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  THydmodInterpolateParam = class(TCustomHydmodParam)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodHeadObservationParam = class(TCustomHydmodParam)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodDrawDownObservationParam = class(TCustomHydmodParam)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodPreconsolidationObservationParam = class(TCustomHydmodParam)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodCompactionObservationParam = class(TCustomHydmodParam)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodSubsidenceObservationParam = class(TCustomHydmodParam)
    class Function ANE_ParamName : string ; override;
  end;

  TCustomHydmodStreamObservation = class(TCustomHydmodParam)
    function Value : string; override;
  end;

  THydmodStreamStageObservationParam = class(TCustomHydmodStreamObservation)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodStreamFlowInObservationParam = class(TCustomHydmodStreamObservation)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodStreamFlowOutObservationParam = class(TCustomHydmodStreamObservation)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodStreamFlowIntoAquiferObservationParam = class(TCustomHydmodStreamObservation)
    class Function ANE_ParamName : string ; override;
  end;

  THydmodLabelParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
    function Units : string; override;
  end;

  THydmodLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
    // see T_ANE_MapsLayer
  end;

implementation

uses OptionsUnit, Variables;

resourcestring
  kHydmodHead = 'Is Head Observation';
  kHydmodDrawdown = 'Is Drawdown Observation';
  kHydmodPreHead = 'Is Preconsolidation Head Observation';
  kHydmodCompaction = 'Is Compaction Observation';
  kHydmodSubsidence = 'Is Subsidence Observation';
  kHydmodStage = 'Is Stage Observation';
  kHydmodFlowIn = 'Is Flow In Observation';
  kHydmodFlowOut = 'Is Flow Out Observation';
  kHydmodFlowIntoAquifer = 'Is Flow into Aquifer Observation';
  kHydmodLayer = 'HYDMOD Observations Unit';
  kInterpolateObservations = 'Interpolate Observation';
  kLabel = 'Hydmod Observation Label';
  kElevation = 'Elevation';

{ TCustomHydmodParam }

constructor TCustomHydmodParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

{ THydmodHeadObservationParam }

class function THydmodHeadObservationParam.ANE_ParamName: string;
begin
  result := kHydmodHead;
end;

{ THydmodDrawDownObservationParam }

class function THydmodDrawDownObservationParam.ANE_ParamName: string;
begin
  result := kHydmodDrawdown;
end;

{ THydmodPreconsolidationObservationParam }

class function THydmodPreconsolidationObservationParam.ANE_ParamName: string;
begin
  result := kHydmodPreHead;
end;

{ THydmodCompactionObservationParam }

class function THydmodCompactionObservationParam.ANE_ParamName: string;
begin
  result := kHydmodCompaction;
end;

{ THydmodSubsidenceObservationParam }

class function THydmodSubsidenceObservationParam.ANE_ParamName: string;
begin
  result := kHydmodSubsidence;
end;

{ THydmodStreamStageObservationParam }

class function THydmodStreamStageObservationParam.ANE_ParamName: string;
begin
  result := kHydmodStage;
end;

{ THydmodStreamFlowInObservationParam }

class function THydmodStreamFlowInObservationParam.ANE_ParamName: string;
begin
  result := kHydmodFlowIn
end;

{ THydmodStreamFlowOutObservationParam }

class function THydmodStreamFlowOutObservationParam.ANE_ParamName: string;
begin
  result := kHydmodFlowOut;
end;

{ THydmodStreamFlowIntoAquiferObservationParam }

class function THydmodStreamFlowIntoAquiferObservationParam.ANE_ParamName: string;
begin
  result := kHydmodFlowIntoAquifer;
end;

{ THydmodLayer }

class function THydmodLayer.ANE_LayerName: string;
begin
  result := KHydmodLayer;
end;

constructor THydmodLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodModflowLayerParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodInterpolateParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodHeadObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodDrawDownObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodPreconsolidationObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodCompactionObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodSubsidenceObservationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHydmodLabelParamType.ANE_ParamName);

  ModflowTypes.GetMFHydmodElevParamType.Create(ParamList, -1);
  ModflowTypes.GetMFHydmodModflowLayerParamType.Create(ParamList, -1);
  ModflowTypes.GetMFHydmodInterpolateParamType.Create(ParamList, -1);
  ModflowTypes.GetMFHydmodHeadObservationParamType.Create(ParamList, -1);
  ModflowTypes.GetMFHydmodDrawDownObservationParamType.Create(ParamList, -1);
  if frmModflow.cbIBS.Checked and frmModflow.UseIBS(StrToInt(WriteIndex)) then
  begin
    ModflowTypes.GetMFHydmodPreconsolidationObservationParamType.Create(ParamList, -1);
    ModflowTypes.GetMFHydmodCompactionObservationParamType.Create(ParamList, -1);
    ModflowTypes.GetMFHydmodSubsidenceObservationParamType.Create(ParamList, -1);
  end;
  ModflowTypes.GetMFHydmodLabelParamType.Create(ParamList, -1);

end;

{ THydmodInterpolateParam }

class function THydmodInterpolateParam.ANE_ParamName: string;
begin
  result := KInterpolateObservations;
end;

{ THydmodLabelParam }

class function THydmodLabelParam.ANE_ParamName: string;
begin
  result := KLabel;
end;

constructor THydmodLabelParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function THydmodLabelParam.Units: string;
begin
  result := '1-12 characters';
end;

function THydmodLabelParam.Value: string;
begin
  result := '"A Name"';
end;

{ THydmodElevParam }

class function THydmodElevParam.ANE_ParamName: string;
begin
  result := kElevation;
end;

{ THydmodModflowLayerParam }

constructor THydmodModflowLayerParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  SetValue := True;
  Lock := Lock + [plDef_Val, plDont_Override];
end;

function THydmodModflowLayerParam.Value: string;
begin
  result := 'MODFLOW_Layer(' + GetParentLayer.WriteIndex
    + ', ' + ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + GetParentLayer.WriteIndex
    + '.' + ModflowTypes.GetMFTopElevParamType.ANE_ParamName + GetParentLayer.WriteIndex

    + ', ' + ModflowTypes.GetBottomElevLayerType.ANE_LayerName + GetParentLayer.WriteIndex
    + '.' + ModflowTypes.GetMFBottomElevParamType.ANE_ParamName + GetParentLayer.WriteIndex

    + ', ' + ModflowTypes.GetMFHydmodElevParamType.ANE_ParamName
    + ')'

end;

{ TCustomHydmodStreamObservation }

function TCustomHydmodStreamObservation.Value: string;
begin
  result := '1';
end;

end.
