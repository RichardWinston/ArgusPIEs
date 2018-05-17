unit MF_GWM_DrawdownConstraint;

interface

uses SysUtils, ANE_LayerUnit, MF_GWM_HeadConstraint;

type
  TDrawdownConstraintName = class(THeadConstraintName)
    class Function ANE_ParamName : string ; override;
  end;

  TDrawdownConstraintType = class(THeadConstraintType)
    function Value : String; override;
  end;


  TDrawdownConstraintLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end; 


implementation

uses Variables;

resourcestring
  rsDrawdownConstraintName = 'Drawdown Constraint Name';
  rsDrawdownConstraintUnit = 'Drawdown Constraint Unit';

{ TDrawdownConstraintName }

class function TDrawdownConstraintName.ANE_ParamName: string;
begin
  result := rsDrawdownConstraintName;
end;

{ TDrawdownConstraintLayer }

class function TDrawdownConstraintLayer.ANE_LayerName: string;
begin
  result := rsDrawdownConstraintUnit;
end;

constructor TDrawdownConstraintLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFDrawdownConstraintNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFDrawdownConstraintTypeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadConstraintBoundaryParamType.ANE_ParamName);

  ModflowTypes.GetMFDrawdownConstraintNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFDrawdownConstraintTypeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHeadConstraintBoundaryParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;
end;

{ TDrawdownConstraintType }

function TDrawdownConstraintType.Value: String;
begin
  result := '"LE"';
end;

end.
