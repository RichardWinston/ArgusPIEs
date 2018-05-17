unit HST3DInitialMassFracLayers;

interface

uses ANE_LayerUnit;



type
TInitialMassFracParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TInitialScaledMassFracParam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

TInitialMassFracLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kInitMassFrac : string = 'Initial Mass Fraction';
  kInitScMassFrac : string = 'Initial Scaled Mass Fraction';
  kInitMassFracLayer : string = 'Initial Mass Fraction NL';

implementation

uses
  HST3DUnit, HST3D_PIE_Unit, HST3DGridLayer;

class Function TInitialMassFracParam.ANE_ParamName : string ;
begin
  result := kInitMassFrac;
end;

function TInitialMassFracParam.Value : string;
begin
  result := kGridLayer + '.' + kW0;
end;

class Function TInitialScaledMassFracParam.ANE_ParamName : string ;
begin
  result := kInitScMassFrac;
end;

constructor TInitialMassFracLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  With PIE_Data do
  begin
    if (HST3DForm.rgMassFrac.ItemIndex = 0) then
    begin
      TInitialMassFracParam.Create(ParamList, -1);
    end;
    if (HST3DForm.rgMassFrac.ItemIndex = 1) then
    begin
      TInitialScaledMassFracParam.Create(ParamList, -1);
    end;
  end;
end;

class Function TInitialMassFracLayer.ANE_LayerName : string ;
begin
  result := KInitMassFracLayer;
end;

end.
