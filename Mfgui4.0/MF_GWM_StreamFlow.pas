unit MF_GWM_StreamFlow;

interface

uses SysUtils, ANE_LayerUnit, MF_GWM_HeadConstraint;

type
  TStreamFlowName = class(THeadConstraintName)
    class Function ANE_ParamName : string ; override;
  end;

  TStreamflowValue = class(THeadConstraintBoundary)
    class Function ANE_ParamName : string ; override;
  end;

  TStreamConstraintLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end; 

implementation

uses Variables;

resourcestring
  rsStreamflowConstraintName = 'Streamflow Constraint Name';
  rsStreamflowConstraintValue = 'Streamflow Constraint Value';
  rsStreamflowConstraintUnit = 'Streamflow Constraint Unit';

{ TStreamFlowName }

class function TStreamFlowName.ANE_ParamName: string;
begin
  result := rsStreamflowConstraintName;
end;

{ TStreamflowValue }

class function TStreamflowValue.ANE_ParamName: string;
begin
  result := rsStreamflowConstraintValue;
end;

{ TStreamConstraintLayer }

class function TStreamConstraintLayer.ANE_LayerName: string;
begin
  result := rsStreamflowConstraintUnit;
end;

constructor TStreamConstraintLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFStreamFlowNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadConstraintTypeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFStreamflowValueParamType.ANE_ParamName);

  ModflowTypes.GetMFStreamFlowNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHeadConstraintTypeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStreamflowValueParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;
end;

end.
