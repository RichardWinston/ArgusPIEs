unit MFMOCImPor;

interface

{MFMOCImPor defines the "Immobile Porosity Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit;

type
  TMOCImPorosityParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMOCImPorosityLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

Uses Variables;

ResourceString
  kMFMOCImPorosity = 'Immob Porosity Unit';

class Function TMOCImPorosityParam.ANE_ParamName : string ;
begin
  result := kMFMOCImPorosity;
end;

function TMOCImPorosityParam.Value : string;
begin
  result := '0.2';
end;
//---------------------------
constructor TMOCImPorosityLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFMOCImPorosityParamType.Create(ParamList, -1);
end;

class Function TMOCImPorosityLayer.ANE_LayerName : string ;
begin
  result := kMFMOCImPorosity;
end;

function TMOCImPorosityLayer.Units : string;
begin
  result := 'L^3/L^3';
end;

end.
