unit MF_GWM_HeadConstraint;

interface

uses SysUtils, ANE_LayerUnit;

type
  THeadConstraintName = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  THeadConstraintType = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  THeadConstraintBoundary = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
//    function Value : String; override;
  end;

  THeadConstraintLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end; 

implementation

uses Variables;

resourcestring
  rsHeadConstraintName = 'Head Constraint Name';
  rsHeadConstraintType = 'Constraint Type';
  rsBoundaryValue = 'Boundary Value';
  rsHeadConstraintUnit = 'Head Constraint Unit';

{ THeadConstraintName }

class function THeadConstraintName.ANE_ParamName: string;
begin
  result := rsHeadConstraintName;
end;

constructor THeadConstraintName.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function THeadConstraintName.Units: string;
var
  StressPeriods: integer;
  SP_String: string;
begin
  StressPeriods := frmModflow.dgTime.RowCount-1;
  SP_String := IntToStr(StressPeriods);
  result := '<= ' + IntToStr(9 - Length(SP_String)) + ' characters'
end;

function THeadConstraintName.Value: String;
begin
  result := '"A_Name"';
end;

{ THeadConstraintType }

class function THeadConstraintType.ANE_ParamName: string;
begin
  result := rsHeadConstraintType;
end;

constructor THeadConstraintType.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function THeadConstraintType.Units: string;
begin
  result := 'LE or GE';
end;

function THeadConstraintType.Value: String;
begin
  result := '"GE"';
end;

{ THeadConstraintBoundary }

class function THeadConstraintBoundary.ANE_ParamName: string;
begin
  result := rsBoundaryValue;
end;

function THeadConstraintBoundary.Units: string;
begin
  result := LengthUnit;
end;

{function THeadConstraintBoundary.Value: String;
begin
  result := '0';
end;}

{ THeadConstraintLayer }

class function THeadConstraintLayer.ANE_LayerName: string;
begin
  result := rsHeadConstraintUnit;
end;

constructor THeadConstraintLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadConstraintNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadConstraintTypeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFHeadConstraintBoundaryParamType.ANE_ParamName);

  ModflowTypes.GetMFHeadConstraintNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHeadConstraintTypeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHeadConstraintBoundaryParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;
end;

end.
