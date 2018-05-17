unit MF_GWM_HeadDifference;

interface

uses SysUtils, ANE_LayerUnit, MF_GWM_HeadConstraint;

type
  THeadDifferenceName = class(THeadConstraintName)
    class Function ANE_ParamName : string ; override;
  end;

  THeadDifferenceValue = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TFirst = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  THeadDifferenceLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

resourcestring
  rsHeadDifferenceName = 'Head Difference Name';
  rsHeadDifferenceValue = 'Head Difference Value';
  rsHeadDifferenceUnit = 'Head Difference Unit';
  rsFirstCell = 'First Cell';

{ THeadDifferenceName }

class function THeadDifferenceName.ANE_ParamName: string;
begin
  result := rsHeadDifferenceName;
end;

{ THeadDifferenceValue }

class function THeadDifferenceValue.ANE_ParamName: string;
begin
  result := rsHeadDifferenceValue;
end;

function THeadDifferenceValue.Units: string;
begin
  result := LengthUnit
end;

{ THeadDifferenceLayer }

class function THeadDifferenceLayer.ANE_LayerName: string;
begin
  result := rsHeadDifferenceUnit;
end;

constructor THeadDifferenceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadDifferenceNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadDifferenceValueParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFElevationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFirstParamType.ANE_ParamName);

  ModflowTypes.GetMFHeadDifferenceNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHeadDifferenceValueParamType.Create( ParamList, -1);
  ModflowTypes.GetMFElevationParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFirstParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;
end;

{ TFirst }

class function TFirst.ANE_ParamName: string;
begin
  result := rsFirstCell;
end;

constructor TFirst.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TFirst.Units: string;
begin
  result := '0 or 1';
end;

function TFirst.Value: String;
begin
  result := '1';
end;

end.
