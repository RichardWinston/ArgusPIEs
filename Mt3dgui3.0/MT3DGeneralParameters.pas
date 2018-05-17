unit MT3DGeneralParameters;

interface

uses ANE_LayerUnit;

const
  kMT3DMass = 'Mass';
  kMT3DConcentration = 'MT3D Concentration';

type
  TMT3DMassParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMT3DConcentrationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

implementation

class Function TMT3DMassParam.ANE_ParamName : string ;
begin
  result := kMT3DMass;
end;

function TMT3DMassParam.Value : string;
begin
  result := kNA;
end;

function TMT3DMassParam.Units : string;
begin
  result := 'M';
end;

//---------------------------

class Function TMT3DConcentrationParam.ANE_ParamName : string ;
begin
  result := kMT3DConcentration;
end;

function TMT3DConcentrationParam.Value : string;
begin
  result := kNA;
end;

function TMT3DConcentrationParam.Units : string;
begin
  result := 'M/L^3';
end;

end.
