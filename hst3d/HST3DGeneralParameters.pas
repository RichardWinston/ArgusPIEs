unit HST3DGeneralParameters;

interface

uses ANE_LayerUnit;

type

TTime = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TMassFraction = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TEndMassFraction = Class(TMassFraction)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TScaledMassFraction = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

TEndScaledMassFraction = Class(TScaledMassFraction)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

TTemperature = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndTemperature = Class(TTemperature)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TViscosity = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndViscosity = Class(TViscosity)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TDensityLayerParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndDensityLayerParam = Class(TDensityLayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

const
  kGenParTime : string = 'Time';
  kGenParMassFrac : string = 'Mass Fraction';
  kGenParScMassFrac : string = 'Scaled Mass Fraction';
  kGenParTemp : string = 'Temperature';
  kGenParVisc : string = 'Viscosity';
  kGenParDens : string = 'Density';
  kGenParEndMassFrac : string = 'End Mass Fraction';
  kGenParEndScMassFrac : string = 'End Scaled Mass Fraction';
  kGenParEndTemp : string = 'End Temperature';
  kGenParEndVisc : string = 'End Viscosity';
  kGenParEndDens : string = 'End Density';


//----------------------------------------------------------------------------

implementation

uses HST3DGridLayer, HST3D_PIE_Unit;

{ TTime }
class Function TTime.ANE_ParamName : string ;
begin
  result := kGenParTime;
end;

{constructor TTime.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 't';
end; }

function TTime.Units : string;
begin
  result := 't';
end;

function TTime.Value : string;
begin
  If WriteIndex = '1'
  then
    begin
      result := '0';
    end
  else
    begin
      result := '$N/A';
    end;
end;

{ TMassFraction }
class Function TMassFraction.ANE_ParamName : string ;
begin
  result := kGenParMassFrac;
end;

function TMassFraction.Value : string;
begin
  result := kGridLayer + '.' + kW0;
end;

{ TEndMassFraction }
class Function TEndMassFraction.ANE_ParamName : string ;
begin
  result := kGenParEndMassFrac;
end;

function TEndMassFraction.Value : string;
begin
  result := '$N/A';
end;

{ TScaledMassFraction }
class Function TScaledMassFraction.ANE_ParamName : string ;
begin
  result := kGenParScMassFrac;
end;

{ TEndScaledMassFraction }
function TEndScaledMassFraction.Value : string;
begin
  result := '$N/A';
end;

class Function TEndScaledMassFraction.ANE_ParamName : string ;
begin
  result := kGenParEndScMassFrac;
end;

{ TTemperature }
class Function TTemperature.ANE_ParamName : string ;
begin
  result := kGenParTemp;
end;

{constructor TTemperature.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'C or F';
end; }

function TTemperature.Units : string;
begin
  result := 'C or F';
end;

function TTemperature.Value : string;
begin
  result := kGridLayer + '.' + kT0;
end;

{ TEndTemperature }
class Function TEndTemperature.ANE_ParamName : string ;
begin
  result := kGenParEndTemp;
end;

function TEndTemperature.Value : string;
begin
  result := '$N/A';
end;

{ TViscosity }
class Function TViscosity.ANE_ParamName : string ;
begin
  result := kGenParVisc;
end;

{constructor TViscosity.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'Pa-s or cP';
end; }

function TViscosity.Units : string;
begin
  result := 'Pa-s or cP';
end;

function TViscosity.Value : string ;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '0.001002'
    end
  else
    begin
      result := '1.002'
    end;
end;

{ TEndViscosity }
class Function TEndViscosity.ANE_ParamName : string ;
begin
  result := kGenParEndVisc;
end;

function TEndViscosity.Value : string ;
begin
  result := '$N/A';
end;

{ TDensityLayerParam }
class Function TDensityLayerParam.ANE_ParamName : string ;
begin
  result := kGenParDens;
end;

{constructor TDensityLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'kg/m^3 or lb/ft^3';
end;}

function TDensityLayerParam.Units : string;
begin
  result := 'kg/m^3 or lb/ft^3';
end;

function TDensityLayerParam.Value : string ;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '998.23'
    end
  else
    begin
      result := '62.317'
    end;
end;

{ TEndDensityLayerParam }
class Function TEndDensityLayerParam.ANE_ParamName : string ;
begin
  result := kGenParEndDens;
end;

function TEndDensityLayerParam.Value : string ;
begin
  result := '$N/A';
end;

//----------------------------------------------------------------------------

end.
