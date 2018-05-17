unit SLSutraMesh;

interface

uses SysUtils, ANE_LayerUnit;

type
  TSutraParentParameter = Class(T_ANE_MeshParam)
    function WriteParentIndex : string ;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TNodeParameter = Class(TSutraParentParameter)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TAlwaysNodeParameter = Class(TSutraParentParameter)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TCustomIsSourceParameter = class(TAlwaysNodeParameter)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TElevationNodeParameter = Class(TAlwaysNodeParameter)
    function Units : string; Override;
  end;

  TNREGParam = class(TNodeParameter)
  public
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TZParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    class function UsualValue : string;
  end;

  TPORParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    class function UsualValue : string;
  end;

  TLREGParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TPMAXParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TPMIDParam = class(TPMAXParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TPMINParam = class(TPMAXParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TANGLEXParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TANGLE1Param = class(TANGLEXParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    class Function WriteParamName : string; override;
  end;

  TANGLE2Param = class(TANGLE1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TANGLE3Param = class(TANGLE1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TALMAXParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TALMIDParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TALMINParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TAT1MAXParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    class function UsualValue : string;
  end;

  TAT1MIDParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TAT1MINParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    class function UsualValue : string;
  end;

  TAT2MAXParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TAT2MIDParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TAT2MINParam = class(TSutraParentParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TQINParam = class(TAlwaysNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TIsFluidSource = class(TCustomIsSourceParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TQINTopParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TQINBottomParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TUINParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TIsQUINSource = class(TCustomIsSourceParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TTimeDepFluidSourceParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TQUINParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TQUINTopParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TQUINBottomParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TTimeDepEnergySoluteSourceParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TPBCParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
  end;

  TIsPBCSource = class(TCustomIsSourceParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TPBCTopParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TPBCBottomParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TpUBCParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TTimeDepSpecHeadPresParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TUBCParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TIsUBCSource = class(TCustomIsSourceParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TUBCTopParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TUBCBottomParam = class(TElevationNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TTimeDepSpecConcTempParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TPVECParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TUVECParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TINOBParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TSutraNodeLayerParameters = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSutraMeshLayer = class(T_ANE_QuadMeshLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class Function ANE_LayerName : string ; override;
    function Units: string; override;
  end;

implementation

uses SLUnsaturated, SLThickness, SLPorosity, SLPermeability, SLDispersivity,
  SLSourcesOfFluid, SLGeneralParameters, SLEnergySoluteSources,
  SLSpecifiedPressure, SLSpecConcOrTemp, SLInitialPressure, SLInitConcOrTemp,
  SLObservation, SLDomainDensity, frmSutraUnit;

ResourceString
  kNREG = 'NREG';
//  kTHICK = 'THICK';
  kZ = 'Z';
  kPOR = 'POR';
  kLREG = 'LREG';
  kPMAX = 'PMAX';
  kPMID = 'PMID';
  kPMIN = 'PMIN';
  kANGLEX = 'ANGLEX';
  kANGLE1 = 'ANGLE1';
  kANGLE2 = 'ANGLE2';
  kANGLE3 = 'ANGLE3';
  kALMAX = 'ALMAX';
  kALMID = 'ALMID';
  kALMIN = 'ALMIN';
  kAT1MAX = 'AT1MAX';
  kAT1MID = 'AT1MID';
  kAT1MIN = 'AT1MIN';
  kAT2MAX = 'AT2MAX';
  kAT2MID = 'AT2MID';
  kAT2MIN = 'AT2MIN';
  kQIN = 'QIN';
  kIsFluidSource = 'IS_FLUID_SOURCE';
  kQINtop = 'QIN top';
  kQINbottom = 'QIN bottom';
  kUIN = 'UIN';
  kTimeDependentFluidSources = 'time_dependent_fluid_sources';
  kQUIN = 'QUIN';
  kIsQUINSource = 'IS_QUIN_SOURCE';
  kQUINtop = 'QUIN top';
  kQUINbottom = 'QUIN bottom';
  kTimeDependentEnergyOrSoluteSources
    = 'time_dependent_energy_or_solute_sources';
  kPBC = 'PBC';
  kIsPBCSource = 'IS_PBC_SOURCE';
  kPBCtop = 'PBC top';
  kPBCbottom = 'PBC bottom';
  kpUBC = 'pUBC';
  kTimeDependentSpecifiedHeadOrPressure
    = 'time_dependent_specified_head_or_pressure';
  kUBC = 'UBC';
  kIsUBCSource = 'IS_UBC_SOURCE';
  kUBCtop = 'UBC top';
  kUBCbottom = 'UBC bottom';
  kTimeDependentSpecifiedConcentrationOrTemperature
    = 'time_dependent_specified_concentration_or_temperature';
  kPVEC = 'PVEC';
  kUVEC = 'UVEC';
  kINOB = 'INOB';
  KSutraMesh = 'SUTRA Mesh';



{ TSutraParentParameter }

constructor TSutraParentParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  if frmSutra.rb3D_nva.Checked then
  begin
    ParameterType := mptLayer;
  end;
end;

function TSutraParentParameter.WriteParentIndex: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result :=  GetParentLayer.WriteIndex;
  end
  else
  begin
    result := inherited WriteIndex;
  end;

end;

{ TNodeParameter }

constructor TNodeParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  if not frmSutra.rb3D_nva.Checked then
  begin
    ParameterType := mptNode;
  end;
end;

{ TAlwaysNodeParameter }

constructor TAlwaysNodeParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

{ TElevationNodeParameter }

function TElevationNodeParameter.Units: string;
begin
  result := 'L';
end;

{ TNREGParam }

class function TNREGParam.ANE_ParamName: string;
begin
  result := kNREG;
end;

constructor TNREGParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TNREGParam.Value: string;
begin
  with frmSutra do
  begin
    if is3D and rbSatUnsat.Checked then
    begin
        result := TUnsaturatedLayer.WriteNewRoot + WriteParentIndex + '.'
          + TRegionParam.WriteParamName;
    end
    else
    begin
      result := '0';
    end;
  end;
end;

{ TTHICKParam }

class function TZParam.ANE_ParamName: string;
begin
  result := kZ;
end;


function TZParam.Units: string;
begin
  result := 'L';
end;

class function TZParam.UsualValue: string;
begin
  with frmSutra do
  begin
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked) then
    begin
      result := TThicknessLayer.WriteNewRoot + '.'
      + TThicknessParam.WriteParamName;
    end
    else
    begin
      result := 'If(X()>=0, ' + FloatToStr(Pi) + ', $n/a)';
    end;
  end;
end;

function TZParam.Value: string;
begin
  with frmSutra do
  begin
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked) then
    begin
      result := TThicknessLayer.WriteNewRoot + WriteParentIndex  + '.'
      + TThicknessParam.WriteParamName;
    end
    else
    begin
      result := 'If(X()>=0, ' + FloatToStr(2*Pi) + '*X(), $n/a)';
    end;
  end;
end;


{ TPORParam }

class function TPORParam.ANE_ParamName: string;
begin
  result := kPOR;
end;

function TPORParam.Units: string;
begin
  result := 'fraction';
end;

class function TPORParam.UsualValue: string;
begin
  result := TPorosityLayer.WriteNewRoot  + '.'
    + TPorosityParam.WriteParamName;

end;

function TPORParam.Value: string;
begin
  result := TPorosityLayer.WriteNewRoot + WriteParentIndex  + '.'
    + TPorosityParam.WriteParamName;
end;

{ TLREGParam }

class function TLREGParam.ANE_ParamName: string;
begin
  result := kLREG;
end;

constructor TLREGParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TLREGParam.Value: string;
begin
  with frmSutra do
  begin
    if is3D and rbSatUnsat.Checked then
    begin
      result := TUnsaturatedLayer.WriteNewRoot + WriteParentIndex
        + '.' + TRegionParam.WriteParamName;
    end
    else
    begin
      result := '0';
    end;
  end;
end;

{ TPMAXParam }

class function TPMAXParam.ANE_ParamName: string;
begin
  result := kPMAX;
end;

function TPMAXParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'L^2';
      end;
    svHead:
      begin
        result := 'L/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TPMAXParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxPermeabilityParam.WriteParamName;
end;

{ TPMIDParam }

class function TPMIDParam.ANE_ParamName: string;
begin
  result := kPMID;
end;

function TPMIDParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidPermeabilityParam.WriteParamName;
end;

{ TPMINParam }

class function TPMINParam.ANE_ParamName: string;
begin
  result := kPMIN;
end;

function TPMINParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinPermeabilityParam.WriteParamName;
end;

{ TANGLEXParam }

class function TANGLEXParam.ANE_ParamName: string;
begin
  result := kANGLEX;
end;

function TANGLEXParam.Units: string;
begin
  result := 'degrees';
end;

function TANGLEXParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TPermeabilityAngleParam.WriteParamName;
end;

{ TANGLE1Param }

class function TANGLE1Param.ANE_ParamName: string;
begin
  result := kANGLE1;
end;

function TANGLE1Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + THorizPermeabilityAngleParam.WriteParamName;
end;

class function TANGLE1Param.WriteParamName: string;
begin
  result := inherited WriteParamName;
  if frmSutra.rb3D_va.Checked then
  begin
    result := result + '_';
  end;
end;

{ TANGLE2Param }

class function TANGLE2Param.ANE_ParamName: string;
begin
  result := kANGLE2;
end;

function TANGLE2Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TVertPermeabilityAngleParam.WriteParamName;
end;

{ TANGLE3Param }

class function TANGLE3Param.ANE_ParamName: string;
begin
  result := kANGLE3;
end;

function TANGLE3Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TRotPermeabilityAngleParam.WriteParamName;
end;

{ TALMAXParam }

class function TALMAXParam.ANE_ParamName: string;
begin
  result := kALMAX;
end;

function TALMAXParam.Units: string;
begin
  result := 'L';
end;

function TALMAXParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxLongDispParam.WriteParamName;
end;

{ TALMIDParam }

class function TALMIDParam.ANE_ParamName: string;
begin
  result := kALMID;
end;

function TALMIDParam.Units: string;
begin
  result := 'L';
end;

function TALMIDParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidLongDispParam.WriteParamName;
end;

{ TALMINParam }

class function TALMINParam.ANE_ParamName: string;
begin
  result := kALMIN;
end;

function TALMINParam.Units: string;
begin
  result := 'L';
end;

function TALMINParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
      + TMinLongDispParam.WriteParamName;
end;

{ TAT1MAXParam }

class function TAT1MAXParam.ANE_ParamName: string;
begin
  result := kAT1MAX;
end;

function TAT1MAXParam.Units: string;
begin
  result := 'L';
end;

class function TAT1MAXParam.UsualValue: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.'
    + TMaxTransDisp1Param.WriteParamName;
end;

function TAT1MAXParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxTransDisp1Param.WriteParamName;
end;

{ TAT1MIDParam }

class function TAT1MIDParam.ANE_ParamName: string;
begin
  Result := kAT1MID;
end;

function TAT1MIDParam.Units: string;
begin
  result := 'L';
end;

function TAT1MIDParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidTransDisp1Param.WriteParamName;
end;

{ TAT1MINParam }

class function TAT1MINParam.ANE_ParamName: string;
begin
  result := kAT1MIN;
end;

function TAT1MINParam.Units: string;
begin
  result := 'L';
end;

class function TAT1MINParam.UsualValue: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.'
    + TMinTransDisp1Param.WriteParamName;
end;

function TAT1MINParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinTransDisp1Param.WriteParamName;
end;

{ TAT2MAXParam }

class function TAT2MAXParam.ANE_ParamName: string;
begin
  result := kAT2MAX;
end;

function TAT2MAXParam.Units: string;
begin
  result := 'L';
end;

function TAT2MAXParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxTransDisp2Param.WriteParamName;
end;

{ TAT2MIDParam }

class function TAT2MIDParam.ANE_ParamName: string;
begin
  result := kAT2MID;
end;

function TAT2MIDParam.Units: string;
begin
  result := 'L';
end;

function TAT2MIDParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidTransDisp2Param.WriteParamName;
end;

{ TAT2MINParam }

class function TAT2MINParam.ANE_ParamName: string;
begin
  result := kAT2MIN;
end;

function TAT2MINParam.Units: string;
begin
  result := 'L';
end;

function TAT2MINParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinTransDisp2Param.WriteParamName;
end;

{ TQINParam }

class function TQINParam.ANE_ParamName: string;
begin
  result := kQIN;
end;

function TQINParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svHead:
      begin
        result := 'L^3/s';
      end;
    svPressure:
      begin
        result := 'M/s';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;

class function TQINParam.UsualValue: string;
begin
  result := 'Index(NodeAboveCntr('
    + TFluidSourcesLayer.WriteNewRoot
    + ')+1, NodeEffectiveValue('
    + TFluidSourcesLayer.WriteNewRoot + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + '.'
      + TResultantFluidSourceParam.WriteParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + TFluidSourcesLayer.WriteNewRoot
    + '), NodeEffectiveValue('
    + TFluidSourcesLayer.WriteNewRoot + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + TFluidSourcesLayer.WriteNewRoot + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '))';
end;

function TQINParam.Value: string;
begin
  result := 'Index(NodeAboveCntr('
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex
    + ')+1, NodeEffectiveValue('
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex
    + '), NodeEffectiveValue('
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '))';
end;

{ TUINParam }

class function TUINParam.ANE_ParamName: string;
begin
  result := kUIN;
end;

constructor TUINParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TUINParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T';
      end;
    ttEnergy:
      begin
        result := 'degC';
      end;
    ttSolute:
      begin
        result := 'C';
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;

class function TUINParam.UsualValue: string;
begin
  result := 'If(NodeAboveCntr('
  + TFluidSourcesLayer.WriteNewRoot
  + ')=1 | NodeAboveCntr('
  + TFluidSourcesLayer.WriteNewRoot
  + ')=2, '
  + TFluidSourcesLayer.WriteNewRoot + '.'
    + TConcTempSourceParam.WriteParamName
  + ', NodeEffectiveValue('
  + TFluidSourcesLayer.WriteNewRoot + '.'
    + TQINUINParam.WriteParamName
  + ')/NodeEffectiveValue('
  + TFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
  + '))';
end;

function TUINParam.Value: string;
begin
  result := 'If(NodeAboveCntr('
  + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex
  + ')=1 | NodeAboveCntr('
  + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex
  + ')=2, '
  + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TConcTempSourceParam.WriteParamName
  + ', NodeEffectiveValue('
  + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TQINUINParam.WriteParamName
  + ')/NodeEffectiveValue('
  + TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TResultantFluidSourceParam.WriteParamName
  + '))';
end;

{ TTimeDepFluidSourceParam }

class function TTimeDepFluidSourceParam.ANE_ParamName: string;
begin
  result := kTimeDependentFluidSources;
end;

constructor TTimeDepFluidSourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TTimeDepFluidSourceParam.Value: string;
begin
  result := TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTimeDependanceParam.WriteParamName;
end;

{ TQUINParam }

class function TQUINParam.ANE_ParamName: string;
begin
  result := kQUIN;
end;

constructor TQUINParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TQUINParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := '(M or E)/s';
      end;
    ttEnergy:
      begin
        result := 'E/s';
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svHead:
            begin
              result := 'C*L^3)/s';
            end;
          svPressure:
            begin
              result := 'M/s';
            end;
          else
            begin
              Assert(False);
            end;
        end;

      end;
    else
      begin
        Assert(False);
      end;
  end;
//  result := '(M or E)/s';
end;

class function TQUINParam.UsualValue: string;
begin
  result := 'Index(NodeAboveCntr('
    + TSoluteEnergySourcesLayer.WriteNewRoot
    + ')+1, NodeEffectiveValue('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + ', '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + TSoluteEnergySourcesLayer.WriteNewRoot
    + '), NodeEffectiveValue('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '))';
end;

function TQUINParam.Value: string;
begin
  result := 'Index(NodeAboveCntr('
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex
    + ')+1, NodeEffectiveValue('
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + ', '
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex
    + '), NodeEffectiveValue('
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
    + '))';
end;

{ TTimeDepEnergySoluteSourceParam }

class function TTimeDepEnergySoluteSourceParam.ANE_ParamName: string;
begin
  result :=  kTimeDependentEnergyOrSoluteSources;
end;

constructor TTimeDepEnergySoluteSourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

class function TTimeDepEnergySoluteSourceParam.UsualValue: string;
begin
  result := TSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.WriteParamName;
end;

function TTimeDepEnergySoluteSourceParam.Value: string;
begin
  result := TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTimeDependanceParam.WriteParamName;
end;

{ TPBCParam }

class function TPBCParam.ANE_ParamName: string;
begin
  result := kPBC;
end;

constructor TPBCParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TPBCParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'M/(L s^2)'
      end;
    svHead:
      begin
        result := 'L';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TPBCParam.Value: string;
begin
  result := 'if(NodeAboveCntr('
    + TSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex
    + '),'
    + TSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
      + TSpecPressureParam.WriteParamName
    + ',$n/a)';
end;

{ TpUBCParam }

class function TpUBCParam.ANE_ParamName: string;
begin
  result := kpUBC;
end;

function TpUBCParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T'
      end;
    ttEnergy:
      begin
        result := 'degC'
      end;
    ttSolute:
      begin
        result := 'C';
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;

class function TpUBCParam.UsualValue: string;
begin
  result := TSpecifiedPressureLayer.WriteNewRoot + '.' +
    TConcOrTempParam.WriteParamName;
end;

function TpUBCParam.Value: string;
begin
  result := TSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.' +
    TConcOrTempParam.WriteParamName;
end;

{ TTimeDepSpecHeadPresParam }

class function TTimeDepSpecHeadPresParam.ANE_ParamName: string;
begin
  result := kTimeDependentSpecifiedHeadOrPressure;
end;

constructor TTimeDepSpecHeadPresParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TTimeDepSpecHeadPresParam.Value: string;
begin
  result := TSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTimeDependanceParam.WriteParamName;
end;

{ TUBCParam }

class function TUBCParam.ANE_ParamName: string;
begin
  result := kUBC;
end;

constructor TUBCParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TUBCParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T'
      end;
    ttEnergy:
      begin
        result := 'degC'
      end;
    ttSolute:
      begin
        result := 'C';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;

class function TUBCParam.UsualValue: string;
begin
  result := 'if(NodeAboveCntr('
    + TSpecConcTempLayer.WriteNewRoot
    + '),'
    + TSpecConcTempLayer.WriteNewRoot + '.'
    + TSpecConcTempParam.WriteParamName
    + ',$n/a)';
end;

function TUBCParam.Value: string;
begin
  result := 'if(NodeAboveCntr('
    + TSpecConcTempLayer.WriteNewRoot + WriteParentIndex
    + '),'
    + TSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TSpecConcTempParam.WriteParamName
    + ',$n/a)';
end;

{ TTimeDepSpecConcTempParam }

class function TTimeDepSpecConcTempParam.ANE_ParamName: string;
begin
  result := kTimeDependentSpecifiedConcentrationOrTemperature;
end;

constructor TTimeDepSpecConcTempParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

class function TTimeDepSpecConcTempParam.UsualValue: string;
begin
  result := TSpecConcTempLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.WriteParamName;
end;

function TTimeDepSpecConcTempParam.Value: string;
begin
  result := TSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTimeDependanceParam.WriteParamName;
end;

{ TPVECParam }

class function TPVECParam.ANE_ParamName: string;
begin
  result := kPVEC;
end;

function TPVECParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'M/(L s^2)';
      end;
    svHead:
      begin
        result := 'L';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TPVECParam.Value: string;
begin
  result := TInitialPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TInitialPressureParam.WriteParamName
end;

{ TUVECParam }

class function TUVECParam.ANE_ParamName: string;
begin
  result := kUVEC;
end;

function TUVECParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T'
      end;
    ttEnergy:
      begin
        result := 'degC'
      end;
    ttSolute:
      begin
        result := 'C';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;

class function TUVECParam.UsualValue: string;
begin
  result := TInitialConcTempLayer.WriteNewRoot + '.'
    + TInitialConcTempParam.WriteParamName;
end;

function TUVECParam.Value: string;
begin
  result := TInitialConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TInitialConcTempParam.WriteParamName;
end;

{ TINOBParam }

class function TINOBParam.ANE_ParamName: string;
begin
  result := kINOB;
end;

constructor TINOBParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  ParameterType := mptNode;
end;

function TINOBParam.Value: string;
begin
  result := 'If('
    + TObservationLayer.WriteNewRoot + WriteParentIndex + '.'
    + TIsObservedParam.WriteParamName
    + ',NodeNumber(),0)'
end;

{ TSutraNodeLayerParameters }

constructor TSutraNodeLayerParameters.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TNREGParam.ANE_ParamName);
  ParameterOrder.Add(TZParam.ANE_ParamName);
  ParameterOrder.Add(TPORParam.ANE_ParamName);
  ParameterOrder.Add(TLREGParam.ANE_ParamName);
  ParameterOrder.Add(TPMAXParam.ANE_ParamName);
  ParameterOrder.Add(TPMIDParam.ANE_ParamName);
  ParameterOrder.Add(TPMINParam.ANE_ParamName);
//  ParameterOrder.Add(TANGLEXParam.ANE_ParamName);
  ParameterOrder.Add(TANGLE1Param.ANE_ParamName);
  ParameterOrder.Add(TANGLE2Param.ANE_ParamName);
  ParameterOrder.Add(TANGLE3Param.ANE_ParamName);
  ParameterOrder.Add(TALMAXParam.ANE_ParamName);
  ParameterOrder.Add(TALMIDParam.ANE_ParamName);
  ParameterOrder.Add(TALMINParam.ANE_ParamName);
  ParameterOrder.Add(TAT1MAXParam.ANE_ParamName);
  ParameterOrder.Add(TAT1MIDParam.ANE_ParamName);
  ParameterOrder.Add(TAT1MINParam.ANE_ParamName);
  ParameterOrder.Add(TAT2MAXParam.ANE_ParamName);
  ParameterOrder.Add(TAT2MIDParam.ANE_ParamName);
  ParameterOrder.Add(TAT2MINParam.ANE_ParamName);
  ParameterOrder.Add(TQINParam.ANE_ParamName);
  ParameterOrder.Add(TIsFluidSource.ANE_ParamName);
  ParameterOrder.Add(TQINTopParam.ANE_ParamName);
  ParameterOrder.Add(TQINBottomParam.ANE_ParamName);
  ParameterOrder.Add(TUINParam.ANE_ParamName);
  ParameterOrder.Add(TTimeDepFluidSourceParam.ANE_ParamName);
  ParameterOrder.Add(TQUINParam.ANE_ParamName);
  ParameterOrder.Add(TIsQUINSource.ANE_ParamName);
  ParameterOrder.Add(TQUINTopParam.ANE_ParamName);
  ParameterOrder.Add(TQUINBottomParam.ANE_ParamName);
  ParameterOrder.Add(TTimeDepEnergySoluteSourceParam.ANE_ParamName);
  ParameterOrder.Add(TPBCParam.ANE_ParamName);
  ParameterOrder.Add(TIsPBCSource.ANE_ParamName);
  ParameterOrder.Add(TPBCTopParam.ANE_ParamName);
  ParameterOrder.Add(TPBCBottomParam.ANE_ParamName);
  ParameterOrder.Add(TpUBCParam.ANE_ParamName);
  ParameterOrder.Add(TTimeDepSpecHeadPresParam.ANE_ParamName);
  ParameterOrder.Add(TUBCParam.ANE_ParamName);
  ParameterOrder.Add(TIsUBCSource.ANE_ParamName);
  ParameterOrder.Add(TUBCTopParam.ANE_ParamName);
  ParameterOrder.Add(TUBCBottomParam.ANE_ParamName);
  ParameterOrder.Add(TTimeDepSpecConcTempParam.ANE_ParamName);
  ParameterOrder.Add(TPVECParam.ANE_ParamName);
  ParameterOrder.Add(TUVECParam.ANE_ParamName);
  ParameterOrder.Add(TINOBParam.ANE_ParamName);

  if frmSutra.rb3D_va.Checked then
  begin
    TNREGParam.Create(self, -1);
    TZParam.Create(self, -1);
    TPORParam.Create(self, -1);
    TLREGParam.Create(self, -1);
    TPMAXParam.Create(self, -1);
    TPMIDParam.Create(self, -1);
    TPMINParam.Create(self, -1);
    TANGLE1Param.Create(self, -1);
    TANGLE2Param.Create(self, -1);
    TANGLE3Param.Create(self, -1);
    TALMAXParam.Create(self, -1);
    TALMIDParam.Create(self, -1);
    TALMINParam.Create(self, -1);
    TAT1MAXParam.Create(self, -1);
    TAT1MIDParam.Create(self, -1);
    TAT1MINParam.Create(self, -1);
    TAT2MAXParam.Create(self, -1);
    TAT2MIDParam.Create(self, -1);
    TAT2MINParam.Create(self, -1);
    TQINParam.Create(self, -1);
    TIsFluidSource.Create(self, -1);
    TQINTopParam.Create(self, -1);
    TQINBottomParam.Create(self, -1);
    TUINParam.Create(self, -1);
    TTimeDepFluidSourceParam.Create(self, -1);
    TQUINParam.Create(self, -1);
    TIsQUINSource.Create(self, -1);
    TQUINTopParam.Create(self, -1);
    TQUINBottomParam.Create(self, -1);
    TTimeDepEnergySoluteSourceParam.Create(self, -1);
    TPBCParam.Create(self, -1);
    TIsPBCSource.Create(self, -1);
    TPBCTopParam.Create(self, -1);
    TPBCBottomParam.Create(self, -1);
    TpUBCParam.Create(self, -1);
    TTimeDepSpecHeadPresParam.Create(self, -1);
    TUBCParam.Create(self, -1);
    TIsUBCSource.Create(self, -1);
    TUBCTopParam.Create(self, -1);
    TUBCBottomParam.Create(self, -1);
    TTimeDepSpecConcTempParam.Create(self, -1);
    TPVECParam.Create(self, -1);
    TUVECParam.Create(self, -1);
    TINOBParam.Create(self, -1);
  end;

end;

{ TSutraMeshLayer }

class function TSutraMeshLayer.ANE_LayerName: string;
begin
  result := KSutraMesh;
end;

constructor TSutraMeshLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ParameterIndex : integer;
begin
  inherited;
  Visible := False;
  Template.Add('# editable SUTRA template goes here');

  DomainLayer := TSutraDomainOutline.ANE_LayerName {+ WriteIndex};
  DensityLayer := TSutraMeshDensity.ANE_LayerName {+ WriteIndex};

  ParamList.ParameterOrder.Add(TNREGParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TZParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPORParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TLREGParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLEXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLE1Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLE2Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLE3Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT1MAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT1MIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT1MINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT2MAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT2MIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT2MINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsFluidSource.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TQINTopParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUINParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TTimeDepFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQUINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsQUINSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepEnergySoluteSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsPBCSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TpUBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepSpecHeadPresParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsUBCSource.ANE_ParamName);

  ParamList.ParameterOrder.Add(TTimeDepSpecConcTempParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPVECParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUVECParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TINOBParam.ANE_ParamName);

  for ParameterIndex := 0 to StrToInt(frmSutra.adeVertDisc.Text) {-1} do
  begin
    TSutraNodeLayerParameters.Create(IndexedParamList1, -1);
  end;

  if not frmSutra.rb3D_va.Checked then
  begin
    TNREGParam.Create(ParamList, -1);
//    if not frmSutra.rb3D_nva.Checked then
//    begin
      TZParam.Create(ParamList, -1);
//    end;
    TPORParam.Create(ParamList, -1);
    TLREGParam.Create(ParamList, -1);
    TPMAXParam.Create(ParamList, -1);
    if frmSutra.rb3D_nva.Checked then
    begin
      TPMIDParam.Create(ParamList, -1);
    end;
    TPMINParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TANGLE1Param.Create(ParamList, -1);
      TANGLE2Param.Create(ParamList, -1);
      TANGLE3Param.Create(ParamList, -1);
    end
    else
    begin
      TANGLEXParam.Create(ParamList, -1);
    end;
    TALMAXParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TALMIDParam.Create(ParamList, -1);
    end;
    TALMINParam.Create(ParamList, -1);

    TAT1MAXParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TAT1MIDParam.Create(ParamList, -1);
    end;
    TAT1MINParam.Create(ParamList, -1);

    if frmSutra.Is3D then
    begin
      TAT2MAXParam.Create(ParamList, -1);
      TAT2MIDParam.Create(ParamList, -1);
      TAT2MINParam.Create(ParamList, -1);
    end;

    TQINParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TIsFluidSource.Create(ParamList, -1);
    end;
//    TQINTopParam.Create(ParamList, -1);
    TUINParam.Create(ParamList, -1);
    TTimeDepFluidSourceParam.Create(ParamList, -1);
    TQUINParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TIsQUINSource.Create(ParamList, -1);
    end;
    TTimeDepEnergySoluteSourceParam.Create(ParamList, -1);
    TPBCParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TIsPBCSource.Create(ParamList, -1);
    end;
    TpUBCParam.Create(ParamList, -1);
    TTimeDepSpecHeadPresParam.Create(ParamList, -1);
    TUBCParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TIsUBCSource.Create(ParamList, -1);
    end;

    TTimeDepSpecConcTempParam.Create(ParamList, -1);
    TPVECParam.Create(ParamList, -1);
    TUVECParam.Create(ParamList, -1);
    TINOBParam.Create(ParamList, -1);
  end;

end;

function TSutraMeshLayer.Units: string;
begin
  result := '';
end;

{ TQINTopParam }

class function TQINTopParam.ANE_ParamName: string;
begin
  result := kQINtop
end;

function TQINTopParam.Value: string;
begin
  result := TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TQINBottomParam }

class function TQINBottomParam.ANE_ParamName: string;
begin
  result := kQINbottom;
end;

function TQINBottomParam.Value: string;
begin
  result := TFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TQUINTopParam }

class function TQUINTopParam.ANE_ParamName: string;
begin
  result := kQUINtop;
end;

function TQUINTopParam.Value: string;
begin
  result := TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TQUINBottomParam }

class function TQUINBottomParam.ANE_ParamName: string;
begin
  result := kQUINbottom;
end;

function TQUINBottomParam.Value: string;
begin
  result := TSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TPBCTopParam }

class function TPBCTopParam.ANE_ParamName: string;
begin
  result := kPBCtop;
end;

function TPBCTopParam.Value: string;
begin
  result := TSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TPBCBottomParam }

class function TPBCBottomParam.ANE_ParamName: string;
begin
  result := kPBCbottom;
end;

function TPBCBottomParam.Value: string;
begin
  result := TSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TUBCTopParam }

class function TUBCTopParam.ANE_ParamName: string;
begin
  result := kUBCtop;
end;

function TUBCTopParam.Value: string;
begin
  result := TSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TUBCBottomParam }

class function TUBCBottomParam.ANE_ParamName: string;
begin
  result := kUBCbottom;
end;

function TUBCBottomParam.Value: string;
begin
  result := TSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TIsFluidSource }

class function TIsFluidSource.ANE_ParamName: string;
begin
  result := kIsFluidSource;
end;

function TIsFluidSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TQINParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TQINParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TIsQUINSource }

class function TIsQUINSource.ANE_ParamName: string;
begin
  result := kIsQUINSource;
end;

function TIsQUINSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TQUINParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TQUINParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TCustomIsSourceParameter }

constructor TCustomIsSourceParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDont_Override];
end;

function TCustomIsSourceParameter.Units: string;
begin
  result := 'Calculated';
end;

{ TIsPBCSource }

class function TIsPBCSource.ANE_ParamName: string;
begin
  result := kIsPBCSource;
end;

function TIsPBCSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TPBCParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TPBCParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TIsUBCSource }

class function TIsUBCSource.ANE_ParamName: string;
begin
  result := kIsUBCSource;
end;

function TIsUBCSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TUBCParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TUBCParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

end.
