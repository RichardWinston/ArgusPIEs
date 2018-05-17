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

  TMT3DMass2Param = class(TMT3DMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DMass3Param = class(TMT3DMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DMass4Param = class(TMT3DMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DMass5Param = class(TMT3DMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DConcentrationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMT3DConc2Param = class(TMT3DConcentrationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DConc3Param = class(TMT3DConcentrationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DConc4Param = class(TMT3DConcentrationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DConc5Param = class(TMT3DConcentrationParam)
    class Function ANE_ParamName : string ; override;
  end;

implementation

uses Variables;

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
  result := MT3DMassUnit;
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
  result := {'M/L^3';}  MT3DMassUnit + '/' + LengthUnit + '^3';
end;

{ TMT3DConc2Param }

class function TMT3DConc2Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;

{ TMT3DConc3Param }

class function TMT3DConc3Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

{ TMT3DConc4Param }

class function TMT3DConc4Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

{ TMT3DConc5Param }

class function TMT3DConc5Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

{ TMT3DMass2Param }

class function TMT3DMass2Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;

{ TMT3DMass3Param }

class function TMT3DMass3Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

{ TMT3DMass4Param }

class function TMT3DMass4Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

{ TMT3DMass5Param }

class function TMT3DMass5Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

end.
