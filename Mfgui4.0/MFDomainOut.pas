unit MFDomainOut;

interface

{MFDomainOut defines the "MODFLOW Domain Outline" layer and associated
 parameter.}

uses ANE_LayerUnit;

type
  TDomDensityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMFDomainOut = Class(T_ANE_DomainOutlineLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFDomOut = 'MODFLOW Domain Outline';
//  kDensityParam = 'Grid Density';
  kDensityParam = 'MODFLOW Grid Cell Size';

class Function TDomDensityParam.ANE_ParamName : string ;
begin
  result := kDensityParam;
end;

function TDomDensityParam.Units : string;
begin
  Result := LengthUnit;
end;

//---------------------------
constructor TMFDomainOut.Create( ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited Create( ALayerList, Index);
  ModflowTypes.GetMFDomDensityParamType.Create(ParamList, -1);
end;

class Function TMFDomainOut.ANE_LayerName : string ;
begin
  result := kMFDomOut;
end;

function TMFDomainOut.Units : string;
begin
  Result := LengthUnit;
end;

end.
