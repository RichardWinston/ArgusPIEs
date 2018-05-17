unit SLEnergySoluteSources;

interface

uses ANE_LayerUnit, AnePIE;

type
  TTotalSoluteEnergySourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TSpecificSoluteEnergySourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TResultantSoluteEnergySourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    Class function WriteParamName : string ; override;
  end;

  TSoluteEnergySourcesLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses SLGeneralParameters, frmSutraUnit;

ResourceString
  kTotalSource = 'total_source';
  kSpecificSource = 'specific_source';
  kResultantEnergySolute = 'RESULTANT_ENERGY_OR_SOLUTE_SOURCES';
  kEnergySoluteSource = 'Sources of Energy or Solute';

{ TTotalSoluteEnergySourceParam }

class function TTotalSoluteEnergySourceParam.ANE_ParamName: string;
begin
  result := kTotalSource;
end;

function TTotalSoluteEnergySourceParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := '(M or E)/s';
      end;
    ttEnergy:
      begin
        result := 'E/s'
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := 'M/s';
            end;
          svHead:
            begin
              result := '(C*L^3)/s';
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

end;

function TTotalSoluteEnergySourceParam.Value: string;
begin
  result := kNa;
end;

{ TSpecificSoluteEnergySourceParam }

class function TSpecificSoluteEnergySourceParam.ANE_ParamName: string;
begin
  result := kSpecificSource;
end;

function TSpecificSoluteEnergySourceParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := '((M or E)/s)/(L or L^2)';
      end;
    ttEnergy:
      begin
        result := '(E/s)/(L or L^2)'
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := '(M/s)/(L or L^2)';
            end;
          svHead:
            begin
              result := '((C*L^3)/s)/(L or L^2)';
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

end;

function TSpecificSoluteEnergySourceParam.Value: string;
begin
  result := kNa;
end;

{ TResultantSoluteEnergySourceParam }

class function TResultantSoluteEnergySourceParam.ANE_ParamName: string;
begin
  result := kResultantEnergySolute
end;

constructor TResultantSoluteEnergySourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val];
  SetValue := True;
end;

function TResultantSoluteEnergySourceParam.Units: string;
begin
  result := 'calculated'
end;

function TResultantSoluteEnergySourceParam.Value: string;
begin
  result := 'If(IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ')|IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '), If(IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + '), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ', If(ContourType()=3, '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourArea(), If(ContourType()=2, '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourLength(), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '))), $n/a)';
end;

function TResultantSoluteEnergySourceParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TResultantSoluteEnergySourceParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TResultantSoluteEnergySourceParam.ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'RESULTANT_ENERGY_SOURCES';
      end;
    ttSolute:
      begin
        result := 'RESULTANT_SOLUTE_SOURCES';
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;

{ TSoluteEnergySourcesLayer }

class function TSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSource
end;

constructor TSoluteEnergySourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  TTotalSoluteEnergySourceParam.Create(ParamList, -1);
  TSpecificSoluteEnergySourceParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  TResultantSoluteEnergySourceParam.Create(ParamList, -1);
end;

class function TSoluteEnergySourcesLayer.WriteNewRoot: string;
begin

  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSoluteEnergySourcesLayer.ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute';
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;

end.
