unit MFGridDensity;

interface

uses ANE_LayerUnit;

{MFGridDensity defines the "MODFLOW Grid Refinement" layer
 and associated parameter.}


type
  TDensityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMFDensityLayer = Class(T_ANE_DensityLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
//  kMFGridDens = 'MODFLOW Grid Density';
//  kMFGridDens = 'MODFLOW Grid Cell Size';
  kMFGridDens = 'MODFLOW Grid Refinement';

class Function TDensityParam.ANE_ParamName : string ;
begin
  result := kMFGridDens;
end;

function TDensityParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
constructor TMFDensityLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  ModflowTypes.GetMFDensityParamType.Create(ParamList, -1);

end;

class Function TMFDensityLayer.ANE_LayerName : string ;
begin
  result := kMFGridDens;
end;

function TMFDensityLayer.Units : string;
begin
  result := 'L';
end;

end.

