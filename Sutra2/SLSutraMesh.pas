unit SLSutraMesh;

interface

uses SysUtils, ANE_LayerUnit;

type
  TNodeParameter = Class(T_ANE_MeshParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TNREGParam = class(TNodeParameter)
  public
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TTHICKParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TPORParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TLREGParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TPMAXParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TPMINParam = class(TPMAXParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TANGLEXParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TALMAXParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TALMINParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TATMAXParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TATMINParam = class(T_ANE_MeshParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TQINParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TUINParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
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
    function Units : string; override;
    function Value : string; override;
  end;

  TTimeDepEnergySoluteSourceParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TPBCParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TpUBCParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
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
    function Units : string; override;
    function Value : string; override;
  end;

  TTimeDepSpecConcTempParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
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
  end;

  TINOBParam = class(TNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

  TSutraMeshLayer = class(T_ANE_QuadMeshLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses SLUnsaturated, SLThickness, SLPorosity, SLPermeability, SLDispersivity,
  SLSourcesOfFluid, SLGeneralParameters, SLEnergySoluteSources,
  SLSpecifiedPressure, SLSpecConcOrTemp, SLInitialPressure, SLInitConcOrTemp,
  SLObservation, SLDomainDensity, frmSutraUnit;

ResourceString
  kNREG = 'NREG';
  kTHICK = 'THICK';
  kPOR = 'POR';
  kLREG = 'LREG';
  kPMAX = 'PMAX';
  kPMIN = 'PMIN';
  kANGLEX = 'ANGLEX';
  kALMAX = 'ALMAX';
  kALMIN = 'ALMIN';
  kATMAX = 'ATMAX';
  kATMIN = 'ATMIN';
  kQIN = 'QIN';
  kUIN = 'UIN';
  kTimeDependentFluidSources = 'time_dependent_fluid_sources';
  kQUIN = 'QUIN';
  kTimeDependentEnergyOrSoluteSources
    = 'time_dependent_energy_or_solute_sources';
  kPBC = 'PBC';
  kpUBC = 'pUBC';
  kTimeDependentSpecifiedHeadOrPressure
    = 'time_dependent_specified_head_or_pressure';
  kUBC = 'UBC';
  kTimeDependentSpecifiedConcentrationOrTemperature
    = 'time_dependent_specified_concentration_or_temperature';
  kPVEC = 'PVEC';
  kUVEC = 'UVEC';
  kINOB = 'INOB';
  KSutraMesh = 'SUTRA Mesh';

{ TNodeParameter }

constructor TNodeParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
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
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbCrossSection.Checked and rbSatUnsat.Checked)
      then
    begin
      result := TUnsaturatedLayer.ANE_LayerName + '.' + TRegionParam.ANE_ParamName;
    end
    else
    begin
      result := '0';
    end;
  end;
end;

{ TTHICKParam }

class function TTHICKParam.ANE_ParamName: string;
begin
  result := kTHICK;
end;


function TTHICKParam.Units: string;
begin
  result := 'L';
end;

function TTHICKParam.Value: string;
begin
  with frmSutra do
  begin
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked) then
    begin
      result := TThicknessLayer.ANE_LayerName + '.' + TThicknessParam.ANE_ParamName;
    end
    else
    begin
      result := 'If(X()>=0, ' + FloatToStr(Pi) + ', $n/a)';
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

function TPORParam.Value: string;
begin
  result := TPorosityLayer.ANE_LayerName + '.' + TPorosityParam.ANE_ParamName;
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
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbCrossSection.Checked and rbSatUnsat.Checked)
      then
    begin
      result := TUnsaturatedLayer.ANE_LayerName + '.' + TRegionParam.ANE_ParamName;
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
  result := TPermeabilityLayer.WriteNewRoot + '.'
    + TMaxPermeabilityParam.ANE_ParamName;
end;

{ TPMINParam }

class function TPMINParam.ANE_ParamName: string;
begin
  result := kPMIN;
end;

function TPMINParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + '.'
    + TMinPermeabilityParam.ANE_ParamName;
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
  result := TPermeabilityLayer.WriteNewRoot + '.'
    + TPermeabilityAngleParam.ANE_ParamName;
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
  result := TDispersivityLayer.ANE_LayerName + '.'
    + TMaxLongDispParam.ANE_ParamName;
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
  result := TDispersivityLayer.ANE_LayerName + '.'
      + TMinLongDispParam.ANE_ParamName;
end;

{ TATMAXParam }

class function TATMAXParam.ANE_ParamName: string;
begin
  result := kATMAX;
end;

function TATMAXParam.Units: string;
begin
  result := 'L';
end;

function TATMAXParam.Value: string;
begin
  result := TDispersivityLayer.ANE_LayerName + '.'
    + TMaxTransDispParam.ANE_ParamName;
end;

{ TATMINParam }

class function TATMINParam.ANE_ParamName: string;
begin
  result := kATMIN;
end;

function TATMINParam.Units: string;
begin
  result := 'L';
end;

function TATMINParam.Value: string;
begin
  result := TDispersivityLayer.ANE_LayerName + '.'
    + TMinTransDispParam.ANE_ParamName;
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

function TQINParam.Value: string;
begin
  result := 'Index(NodeAboveCntr('
    + TFluidSourcesLayer.ANE_LayerName
    + ')+1, NodeEffectiveValue('
    + TFluidSourcesLayer.ANE_LayerName + '.'
      + TResultantFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.ANE_LayerName + '.'
      + TResultantFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.ANE_LayerName + '.'
      + TResultantFluidSourceParam.ANE_ParamName
    + '*NodeEffectiveLength('
    + TFluidSourcesLayer.ANE_LayerName
    + '), NodeEffectiveValue('
    + TFluidSourcesLayer.ANE_LayerName + '.'
      + TResultantFluidSourceParam.ANE_ParamName
    + '))';
end;

{ TUINParam }

class function TUINParam.ANE_ParamName: string;
begin
  result := kUIN;
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

function TUINParam.Value: string;
begin
  result := 'If(NodeAboveCntr('
  + TFluidSourcesLayer.ANE_LayerName
  + ')=1 | NodeAboveCntr('
  + TFluidSourcesLayer.ANE_LayerName
  + ')=2, '
  + TFluidSourcesLayer.ANE_LayerName + '.'
    + TConcTempSourceParam.WriteParamName
  + ', NodeEffectiveValue('
  + TFluidSourcesLayer.ANE_LayerName + '.'
    + TQINUINParam.ANE_ParamName
  + ')/NodeEffectiveValue('
  + TFluidSourcesLayer.ANE_LayerName + '.'
    + TResultantFluidSourceParam.ANE_ParamName
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
  result := TFluidSourcesLayer.ANE_LayerName + '.'
    + TTimeDependanceParam.ANE_ParamName;
end;

{ TQUINParam }

class function TQUINParam.ANE_ParamName: string;
begin
  result := kQUIN;
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

function TQUINParam.Value: string;
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

function TTimeDepEnergySoluteSourceParam.Value: string;
begin
  result := TSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.ANE_ParamName;
end;

{ TPBCParam }

class function TPBCParam.ANE_ParamName: string;
begin
  result := kPBC;
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
    + TSpecifiedPressureLayer.WriteNewRoot
    + '),'
    + TSpecifiedPressureLayer.WriteNewRoot + '.'
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

function TpUBCParam.Value: string;
begin
  result := TSpecifiedPressureLayer.WriteNewRoot + '.' +
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
  result := TSpecifiedPressureLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.ANE_ParamName;
end;

{ TUBCParam }

class function TUBCParam.ANE_ParamName: string;
begin
  result := kUBC;
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

function TUBCParam.Value: string;
begin
  result := 'if(NodeAboveCntr('
    + TSpecConcTempLayer.WriteNewRoot
    + '),'
    + TSpecConcTempLayer.WriteNewRoot + '.' + TSpecConcTempParam.WriteParamName
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

function TTimeDepSpecConcTempParam.Value: string;
begin
  result := TSpecConcTempLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.ANE_ParamName;
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
  result := TInitialPressureLayer.WriteNewRoot + '.'
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

function TUVECParam.Value: string;
begin
  result := TInitialConcTempLayer.WriteNewRoot + '.'
    + TInitialConcTempParam.ANE_ParamName;
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
end;

function TINOBParam.Value: string;
begin
  result := 'If('
    + TObservationLayer.ANE_LayerName + '.' + TIsObservedParam.ANE_ParamName
    + ',NodeNumber(),0)'
end;

{ TSutraMeshLayer }

class function TSutraMeshLayer.ANE_LayerName: string;
begin
  result := KSutraMesh;
end;

constructor TSutraMeshLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Template.Add('# editable SUTRA template goes here');

  DomainLayer := TSutraDomainOutline.ANE_LayerName;
  DensityLayer := TSutraMeshDensity.ANE_LayerName;

  ParamList.ParameterOrder.Add(TNREGParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTHICKParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPORParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TLREGParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLEXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TATMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TATMINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQUINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepEnergySoluteSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TpUBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepSpecHeadPresParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepSpecConcTempParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPVECParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUVECParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TINOBParam.ANE_ParamName);

  TNREGParam.Create(ParamList, -1);
  TTHICKParam.Create(ParamList, -1);
  TPORParam.Create(ParamList, -1);
  TLREGParam.Create(ParamList, -1);
  TPMAXParam.Create(ParamList, -1);
  TPMINParam.Create(ParamList, -1);
  TANGLEXParam.Create(ParamList, -1);
  TALMAXParam.Create(ParamList, -1);
  TALMINParam.Create(ParamList, -1);
  TQINParam.Create(ParamList, -1);
  TUINParam.Create(ParamList, -1);
  TTimeDepFluidSourceParam.Create(ParamList, -1);
  TQUINParam.Create(ParamList, -1);
  TTimeDepEnergySoluteSourceParam.Create(ParamList, -1);
  TPBCParam.Create(ParamList, -1);
  TpUBCParam.Create(ParamList, -1);
  TTimeDepSpecHeadPresParam.Create(ParamList, -1);
  TUBCParam.Create(ParamList, -1);
  TTimeDepSpecConcTempParam.Create(ParamList, -1);
  TPVECParam.Create(ParamList, -1);
  TUVECParam.Create(ParamList, -1);
  TINOBParam.Create(ParamList, -1);
  
end;

end.
