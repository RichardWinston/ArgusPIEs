unit MF_GWM_StreamDepletion;

interface

uses SysUtils, ANE_LayerUnit, MF_GWM_HeadConstraint;

type
  TStreamDepletionName = class(THeadConstraintName)
    class Function ANE_ParamName : string ; override;
  end;

  TStreamDepletionValue = class(THeadConstraintBoundary)
    class Function ANE_ParamName : string ; override;
  end;

  TStreamDepletionConstraintLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end; 

implementation

uses Variables;

resourcestring
  rsStreamflowDepletionName = 'Streamflow Depletion Name';
  rsStreamflowDepletionValue = 'Streamflow Depletion Value';
  rsStreamflowDepletionUnit = 'Streamflow Depletion Unit';

{ TStreamDepletionName }

class function TStreamDepletionName.ANE_ParamName: string;
begin
  result := rsStreamflowDepletionName;
end;

{ TStreamDepletionValue }

class function TStreamDepletionValue.ANE_ParamName: string;
begin
  result := rsStreamflowDepletionValue;
end;

{ TStreamDepletionConstraintLayer }

class function TStreamDepletionConstraintLayer.ANE_LayerName: string;
begin
  result := rsStreamflowDepletionUnit;
end;

constructor TStreamDepletionConstraintLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFStreamDepletionNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFDrawdownConstraintTypeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFStreamDepletionValueParamType.ANE_ParamName);

  ModflowTypes.GetMFStreamDepletionNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFDrawdownConstraintTypeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStreamDepletionValueParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;
end;

end.
