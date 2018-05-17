unit SLSourcesOfFluid;

interface

uses ANE_LayerUnit;

type
  TTotalFluidSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TSpecificFluidSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TConcTempSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
  end;

  TResultantFluidSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
  end;

  TQINUINParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFluidSourcesLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

uses SLGeneralParameters, frmSutraUnit;

ResourceString
  kTotalSource = 'total_source';
  kSpecificSource = 'specific_source';
  kConcTempSource = 'conc_or_temp_of_source';
  kResultant = 'RESULTANT_FLUID_SOURCE';
  kQINUIN = 'QINUIN';
  kSources = 'Sources of Fluid';

{ TTotalFluidSourceParam }

class function TTotalFluidSourceParam.ANE_ParamName: string;
begin
  result := kTotalSource;
end;

function TTotalFluidSourceParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        Result := 'M/s';
      end;
    svHead:
      begin
        result := 'L^3/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TTotalFluidSourceParam.Value: string;
begin
  result := kNa
end;

{ TSpecificFluidSourceParam }

class function TSpecificFluidSourceParam.ANE_ParamName: string;
begin
  result := kSpecificSource
end;

function TSpecificFluidSourceParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := '(M/s)/(L or L^2)'
      end;
    svHead:
      begin
        result := '(L^3/s)/(L or L^2)'
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TSpecificFluidSourceParam.Value: string;
begin
  result := kNa;
end;

{ TConcTempSourceParam }

class function TConcTempSourceParam.ANE_ParamName: string;
begin
  result := kConcTempSource;
end;

function TConcTempSourceParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or degC'
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

function TConcTempSourceParam.Value: string;
begin
  result := kNa;
end;

function TConcTempSourceParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TConcTempSourceParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'temperature_of_source';
      end;
    ttSolute:
      begin
        result := 'concentration_of_source';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;

{ TResultantFluidSourceParam }

class function TResultantFluidSourceParam.ANE_ParamName: string;
begin
  result := kResultant;
end;

constructor TResultantFluidSourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val];
//  SetValue := True;
end;

function TResultantFluidSourceParam.Units: string;
begin
  result := 'calculated';
end;

function TResultantFluidSourceParam.Value: string;
begin
  result := 'If(IsNumber('
    + TFluidSourcesLayer.ANE_LayerName + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ') | IsNumber('
    + TFluidSourcesLayer.ANE_LayerName + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '), index(ContourType()+1, '
    + TFluidSourcesLayer.ANE_LayerName + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.ANE_LayerName + '.' + TTotalFluidSourceParam.ANE_ParamName
    + ', If(IsNumber('
    + TFluidSourcesLayer.ANE_LayerName + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.ANE_LayerName + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.ANE_LayerName + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourLength()), If(IsNumber('
    + TFluidSourcesLayer.ANE_LayerName + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.ANE_LayerName + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.ANE_LayerName + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea())), $n/a)';
end;

{ TQINUINParam }

class function TQINUINParam.ANE_ParamName: string;
begin
  result := kQINUIN;
end;

constructor TQINUINParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val];
  SetValue := True;
end;

function TQINUINParam.Units: string;
begin
  result := 'calculated';
end;

function TQINUINParam.Value: string;
begin
  result := TResultantFluidSourceParam.ANE_ParamName
       + '*'
       + TConcTempSourceParam.WriteParamName;
end;

{ TFluidSourcesLayer }

class function TFluidSourcesLayer.ANE_LayerName: string;
begin
  result := kSources;
end;

constructor TFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  TTotalFluidSourceParam.Create(ParamList, -1);
  TSpecificFluidSourceParam.Create(ParamList, -1);
  TConcTempSourceParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  TResultantFluidSourceParam.Create(ParamList, -1);
  TQINUINParam.Create(ParamList, -1);
end;

end.
