unit MF_GWM_StateVariables;

interface

uses
  ANE_LayerUnit, MFGenParam, SysUtils;

type
  TGwmNameParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TGwmElevationParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TGwmSegmentParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TGwmZoneNumberParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TGwmStressPeriodParam = class(T_ANE_LayerParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

  TGwmStressPeriodParamList = class(T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TCustomGwmStateLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  TGwmHeadStateLayer = Class(TCustomGwmStateLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TGwmStreamStateLayer = Class(TCustomGwmStateLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TGwmStorageStateLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses
  Variables, GetTypesUnit;

{ TGwmNameParam }

class function TGwmNameParam.ANE_ParamName: string;
begin
  result := 'State Variable Name';
end;

constructor TGwmNameParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TGwmNameParam.Units: string;
begin
  result := '<= 10 characters';
end;

function TGwmNameParam.Value: string;
begin
  result := '0';
end;

{ TGwmElevationParam }

class function TGwmElevationParam.ANE_ParamName: string;
begin
  result := 'Elevation';
end;

function TGwmElevationParam.Value: string;
var
  ParentIndex: string;
begin
  ParentIndex := GetParentLayer.WriteIndex;
  result := '(' +
    ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + ParentIndex
    + ' + ' +
    ModflowTypes.GetBottomElevLayerType.ANE_LayerName + ParentIndex
    + ') / 2';
end;

{ TGwmStressPeriodParam }

class function TGwmStressPeriodParam.ANE_ParamName: string;
begin
  result := 'Stress Period ID';
end;

constructor TGwmStressPeriodParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

{ TGwmStressPeriodParamList }

constructor TGwmStressPeriodParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create( AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMF_GwmNameParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMF_GwmStressPeriodParamType.ANE_ParamName);

  ModflowTypes.GetMF_GwmNameParamType.Create( self, -1);
  ModflowTypes.GetMF_GwmStressPeriodParamType.Create( self, -1);
end;

{ TGwmHeadStateLayer }

class function TGwmHeadStateLayer.ANE_LayerName: string;
begin
  result := 'Head State Variable Unit';
end;

constructor TGwmHeadStateLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMF_GwmElevationParamType.ANE_ParamName);

  ModflowTypes.GetMF_GwmElevationParamType.Create( ParamList, -1);

end;

{ TCustomGwmStateLayer }

constructor TCustomGwmStateLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  MaxVariables: Integer;
  VariableIndex: Integer;
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];



  MaxVariables := StrToInt(frmMODFLOW.rdeGwmStateTimeCount.Text);
  For VariableIndex := 1 to MaxVariables do
  begin
    ModflowTypes.GetMFGwmStressPeriodParamListType.Create(IndexedParamList0, -1);
  end;
end;

{ TGwmSegmentParam }

class function TGwmSegmentParam.ANE_ParamName: string;
begin
  result := 'Segment';
end;

constructor TGwmSegmentParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGwmSegmentParam.Units: string;
begin
  result := 'Stream segment number';
end;

{ TGwmStreamStateLayer }

class function TGwmStreamStateLayer.ANE_LayerName: string;
begin
  result := 'Stream State Variable Unit';
end;

constructor TGwmStreamStateLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create(ALayerList, Index);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMF_GwmSegmentParamType.ANE_ParamName);

  ModflowTypes.GetMF_GwmSegmentParamType.Create( ParamList, -1);
end;

{ TGwmZoneNumberParam }

class function TGwmZoneNumberParam.ANE_ParamName: string;
begin
  result := 'Zone Number';
end;

constructor TGwmZoneNumberParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

{ TGwmStorageStateLayer }

class function TGwmStorageStateLayer.ANE_LayerName: string;
begin
  result := 'Storage State Variable Unit';
end;

constructor TGwmStorageStateLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMF_GwmZoneNumberParamType.ANE_ParamName);

  ModflowTypes.GetMF_GwmZoneNumberParamType.Create( ParamList, -1);
end;

end.
