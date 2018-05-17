unit MF_GWM_Gradient;

interface

uses SysUtils, ANE_LayerUnit, MF_GWM_HeadConstraint;

type
  TGradientName = class(THeadConstraintName)
    class Function ANE_ParamName : string ; override;
  end;

  TGradientValue = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TGradientLength = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  TGradientStartElevation = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  TGradientEndElevation = class(TGradientStartElevation)
    class Function ANE_ParamName : string ; override;
  end;

  TGradientLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

resourcestring
  rsGradientName = 'Gradient Name';
  rsGradientValue = 'Gradient Value';
  rsGradientLength = 'Gradient Length';
  rsGradientUnit = 'Gradient Unit';
  rsGradientStart = 'Start Elevation';
  rsGradientEnd = 'End Elevation';

{ TGradientName }

class function TGradientName.ANE_ParamName: string;
begin
  result := rsGradientName;
end;

{ TGradientValue }

class function TGradientValue.ANE_ParamName: string;
begin
  result := rsGradientValue;
end;

{ TGradientLength }

class function TGradientLength.ANE_ParamName: string;
begin
  result := rsGradientLength;
end;

function TGradientLength.Units: string;
begin
  result := LengthUnit;
end;

function TGradientLength.Value: string;
begin
  result := 'ContourLength()';
end;

{ TGradientLayer }

class function TGradientLayer.ANE_LayerName: string;
begin
  result := rsGradientUnit;
end;

constructor TGradientLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFGradientNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFGradientValueParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFGradientLengthParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFFirstParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFGradientStartElevationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.
    GetMFGradientEndElevationParamType.ANE_ParamName);

  ModflowTypes.GetMFGradientNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGradientValueParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGradientLengthParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFirstParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGradientStartElevationParamType.Create( ParamList, -1);
  ModflowTypes.GetMFGradientEndElevationParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFGWM_TimeParamListType.Create(
      IndexedParamList2, -1);
  end;
end;

{ TGradientStartElevation }

class function TGradientStartElevation.ANE_ParamName: string;
begin
  result := rsGradientStart;
end;

function TGradientStartElevation.Units: string;
begin
  result := LengthUnit
end;

function TGradientStartElevation.Value: string;
begin
  result := '0';
end;

{ TGradientEndElevation }

class function TGradientEndElevation.ANE_ParamName: string;
begin
  result := rsGradientEnd;
end;

end.
