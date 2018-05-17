unit MF_DAFLOW;

interface

uses ANE_LayerUnit, SysUtils;

type
  TDaflowBedElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TDaflowBedThicknessParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowBedHydraulicConductivityParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowUpstreamJunctionParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowDownstreamJunctionParam = class(TDaflowUpstreamJunctionParam)
    class function ANE_ParamName: string; override;
  end;

  TDaflowUpstreamFlowFractionParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowInitialFlowParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowTortuosityParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowA0Param = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TDaflowA1Param = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TDaflowA2Param = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TDaflowBedSlopeParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TDaflowW1Param = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TDaflowW2Param = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TDaflowPrintParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TDaflowBoundaryFlowParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;

  TDaflowOverridenBedElevationParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TDaflowOverridenInitialFlowParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TDaflowIsNewBoundaryParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
  end;

  TDaflowTimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TDaflowLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables, OptionsUnit;

resourcestring
  rsBedElevation = 'Bed Elevation';
  rsBedThickness = 'Bed Thickness';
  rsHydraulicConductivity = 'Bed K';
  rsUpstreamJunction = 'Upstream Junction';
  rsDownstreamJunction = 'Downstream Junction';
  rsUpstreamFlowFraction = 'Upstream Flow Fraction';
  rsInitialFlow = 'Initial Flow';
  rsTortuosity = 'Tortuosity';
  rsA0 = 'A0';
  rsA1 = 'A1';
  rsA2 = 'A2';
  rsBedSlope = 'Bed Slope';
  rsW1 = 'W1';
  rsW2 = 'W2';
  rsPrint = 'Print';
  rsRefStressPeriod = 'Reference Stress Period';
  rsBoundaryFlow = 'Boundary Flow';
  rsOverridenBedElevation = 'OVERRIDDEN BED ELEVATION';
  rsOverridenInitialFlow = 'OVERRIDDEN INITIAL FLOW';
  rsIsNewBoundary = 'IS NEW BOUNDARY';
  rsDaflow = 'DAFLOW Unit';

  { TDaflowBedElevation }

class function TDaflowBedElevationParam.ANE_ParamName: string;
begin
  result := rsBedElevation;
end;

function TDaflowBedElevationParam.Units: string;
begin
  result := LengthUnit;
end;

{ TDaflowBedThicknessParam }

class function TDaflowBedThicknessParam.ANE_ParamName: string;
begin
  result := rsBedThickness;
end;

function TDaflowBedThicknessParam.Units: string;
begin
  result := LengthUnit;
end;

function TDaflowBedThicknessParam.Value: string;
begin
  result := '1';
end;

{ TDaflowBedHydraulicConductivityParam }

class function TDaflowBedHydraulicConductivityParam.ANE_ParamName: string;
begin
  result := rsHydraulicConductivity;
end;

function TDaflowBedHydraulicConductivityParam.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit;
end;

function TDaflowBedHydraulicConductivityParam.Value: string;
begin
  result := '100';
end;

{ TDaflowUpstreamJunctionParam }

class function TDaflowUpstreamJunctionParam.ANE_ParamName: string;
begin
  result := rsUpstreamJunction;
end;

constructor TDaflowUpstreamJunctionParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TDaflowUpstreamJunctionParam.Units: string;
begin
  result := '>=1';
end;

function TDaflowUpstreamJunctionParam.Value: string;
begin
  result := '1';
end;

{ TDaflowDownstreamJunctionParam }

class function TDaflowDownstreamJunctionParam.ANE_ParamName: string;
begin
  result := rsDownstreamJunction;
end;

{ TDaflowUpstreamFlowFractionParam }

class function TDaflowUpstreamFlowFractionParam.ANE_ParamName: string;
begin
  result := rsUpstreamFlowFraction;
end;

function TDaflowUpstreamFlowFractionParam.Units: string;
begin
  result := '<=1'
end;

function TDaflowUpstreamFlowFractionParam.Value: string;
begin
  result := '1';
end;

{ TDaflowInitialFlowParam }

class function TDaflowInitialFlowParam.ANE_ParamName: string;
begin
  result := rsInitialFlow;
end;

function TDaflowInitialFlowParam.Units: string;
begin
  result := LengthUnit + '^3/' + TimeUnit
end;

function TDaflowInitialFlowParam.Value: string;
begin
  result := '0';
end;

{ TDaflowTortuosityParam }

class function TDaflowTortuosityParam.ANE_ParamName: string;
begin
  result := rsTortuosity;
end;

function TDaflowTortuosityParam.Units: string;
begin
  result := '>=1';
end;

function TDaflowTortuosityParam.Value: string;
begin
  result := '1';
end;

{ TDaflowA0Param }

class function TDaflowA0Param.ANE_ParamName: string;
begin
  result := rsA0;
end;

function TDaflowA0Param.Units: string;
begin
  result := LengthUnit + '^2';
end;

{ TDaflowA1Param }

class function TDaflowA1Param.ANE_ParamName: string;
begin
  result := rsA1;
end;

function TDaflowA1Param.Value: string;
begin
  result := '1';
end;

{ TDaflowA2Param }

class function TDaflowA2Param.ANE_ParamName: string;
begin
  result := rsA2;
end;

function TDaflowA2Param.Value: string;
begin
  result := '0.66';
end;

{ TDaflowBedSlopeParam }

class function TDaflowBedSlopeParam.ANE_ParamName: string;
begin
  result := rsBedSlope;
end;

function TDaflowBedSlopeParam.Units: string;
begin
  result := LengthUnit + '/' + LengthUnit;
end;

function TDaflowBedSlopeParam.Value: string;
begin
  result := '0.002';
end;

{ TDaflowW1Param }

class function TDaflowW1Param.ANE_ParamName: string;
begin
  result := rsW1;
end;

function TDaflowW1Param.Value: string;
begin
  result := '1';
end;

{ TDaflowW2Param }

class function TDaflowW2Param.ANE_ParamName: string;
begin
  result := rsW2;
end;

function TDaflowW2Param.Value: string;
begin
  result := '0.26';
end;

{ TDaflowPrintParam }

class function TDaflowPrintParam.ANE_ParamName: string;
begin
  result := rsPrint;
end;

constructor TDaflowPrintParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

{ TDaflowBoundaryFlowParam }

class function TDaflowBoundaryFlowParam.ANE_ParamName: string;
begin
  result := rsBoundaryFlow;
end;

function TDaflowBoundaryFlowParam.Units: string;
begin
  result := LengthUnit + '^3/' + TimeUnit
end;

{ TDaflowOverridenBedElevationParam }

class function TDaflowOverridenBedElevationParam.ANE_ParamName: string;
begin
  result := rsOverridenBedElevation;
end;

constructor TDaflowOverridenBedElevationParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDont_Override, plDef_Val];
end;

function TDaflowOverridenBedElevationParam.Value: string;
begin
  result := 'IsOverriden('
    + ModflowTypes.GetMFDaflowBedElevationParamClassType.ANE_ParamName + ')'
end;

{ TDaflowIsNewBoundaryParam }

class function TDaflowIsNewBoundaryParam.ANE_ParamName: string;
begin
  result := rsIsNewBoundary
end;

constructor TDaflowIsNewBoundaryParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDont_Override, plDef_Val];
end;

function TDaflowIsNewBoundaryParam.Value: string;
begin
  if WriteIndex = '1' then
  begin
    result := ModflowTypes.GetMFDaflowBoundaryFlowParamClassType.ANE_ParamName + WriteIndex
      + '!=0';
  end
  else
  begin
    result := '(' + ModflowTypes.GetMFTimeParamType.ANE_ParamName + WriteIndex
      + '!=0)|('
      + ModflowTypes.GetMFReferenceStressPeriodParamClassType.ANE_ParamName
      + WriteIndex
      + '!=1)';
  end;
end;

{ TDaflowTimeParamList }

constructor TDaflowTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFTimeParamType.Create(self, -1);
  ModflowTypes.GetMFReferenceStressPeriodParamClassType.Create(self, -1);
  ModflowTypes.GetMFDaflowBoundaryFlowParamClassType.Create(self, -1);
  ModflowTypes.GetMFDaflowIsNewBoundaryParamClassType.Create(self, -1);
end;

{ TDaflowLayer }

class function TDaflowLayer.ANE_LayerName: string;
begin
  result :=rsDaflow;
end;

constructor TDaflowLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumberOfTimes : integer;
  TimeIndex: integer;
begin
  inherited;
  ModflowTypes.GetMFDaflowBedElevationParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowBedThicknessParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowBedSlopeParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowBedHydraulicConductivityParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowUpstreamJunctionParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowDownstreamJunctionParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowUpstreamFlowFractionParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowInitialFlowParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowTortuosityParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowA0ParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowA1ParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowA2ParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowW1ParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowW2ParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowPrintParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowOverridenBedElevationParamClassType.Create( ParamList, -1);
  ModflowTypes.GetMFDaflowOverrideInitialFlowParamClassType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmModflow.adeDAF_BoundaryTimes.Text);
  for TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFDaflowTimeParamListType.Create(IndexedParamList1, -1);
  end;
end;

{ TDaflowOverridenInitialFlowParam }

class function TDaflowOverridenInitialFlowParam.ANE_ParamName: string;
begin
  result := rsOverridenInitialFlow;
end;

constructor TDaflowOverridenInitialFlowParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDont_Override, plDef_Val];
end;

function TDaflowOverridenInitialFlowParam.Value: string;
begin
  result := 'IsOverriden('
    + ModflowTypes.GetMFDaflowInitialFlowParamClassType.ANE_ParamName + ')'
end;

end.

