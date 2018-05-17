unit MFMOCPorosity;

interface

{MFMOCPorosity defines the "Porosity Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit;

type
  TMOCPorosityParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMOCPorosityLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

Uses Variables;

ResourceString
  kMFMOCPorosity = 'Porosity Unit';

class Function TMOCPorosityParam.ANE_ParamName : string ;
begin
  result := kMFMOCPorosity;
end;

function TMOCPorosityParam.Value : string;
begin
  result := '0.2';
end;
//---------------------------
constructor TMOCPorosityLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFMOCPorosityParamType.Create(ParamList, -1);
end;

class Function TMOCPorosityLayer.ANE_LayerName : string ;
begin
  result := kMFMOCPorosity;
end;

function TMOCPorosityLayer.Units : string;
begin
  result := 'L^3/L^3';
end;

end.
 