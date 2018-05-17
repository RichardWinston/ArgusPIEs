unit MT3DConstantConcentration;

interface

uses ANE_LayerUnit;

const
  kMT3DPointConstantConc = 'MT3D Point Constant Concentration Unit';
  kMT3DAreaConstantConc = 'MT3D Area Constant Concentration Unit';

type
  TMT3DAreaConstantConcParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DPointConstantConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TMT3DAreaConstantConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MT3DGeneralParameters, Variables;

class Function TMT3DAreaConstantConcParam.ANE_ParamName : string ;
begin
  result := kMT3DAreaConstantConc;
end;

function TMT3DAreaConstantConcParam.Value : string;
begin
  result := kNA;
end;

//---------------------------

constructor TMT3DPointConstantConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leInterpolate;
  Lock := Lock + [llEvalAlg, llType];
  ModflowTypes.GetMT3DMassParamClassType.Create(ParamList, -1 );
end;

class Function TMT3DPointConstantConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DPointConstantConc;
end;

function TMT3DPointConstantConcLayer.Units : string;
begin
  result := 'M';
end;

//---------------------------

constructor TMT3DAreaConstantConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  ModflowTypes.GetMT3DAreaConstantConcParamClassType.Create(ParamList, -1);
end;

class Function TMT3DAreaConstantConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DAreaConstantConc;
end;

function TMT3DAreaConstantConcLayer.Units : string;
begin
  result := 'M/L^3';
end;

end.
