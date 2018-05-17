unit HST3DHeatCondLayers;

interface

uses ANE_LayerUnit;

type
TThermDifParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TThermCondParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

THorHeatCondLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

TVerHeatCondLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kHeatCondDiff : string = 'Thermal Diffusivity';
  kHeatCondCond : string = 'Thermal Conductivity';
  kHeatCondHorLay : string = 'Horizontal Heat Conduction Boundary NL';
  kHeatCondVerLay : string = 'Vertical Heat Conduction Boundary NL';


implementation

uses HST3D_PIE_Unit;

{ TThermDifParam }
class Function TThermDifParam.ANE_ParamName : string ;
begin
  result := kHeatCondDiff;
end;

{constructor TThermDifParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'm^2/s or ft^2/d';
end;}

function TThermDifParam.Units : string;
begin
  result := 'm^2/s or ft^2/d';
end;

function TThermDifParam.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '2.e-6'
    end
  else
    begin
      result := '1.8600036'
    end;
end;

{ TThermCondParam }
class Function TThermCondParam.ANE_ParamName : string ;
begin
  result := kHeatCondCond;
end;

{constructor TThermCondParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'W/m-C or BTU/ft-h-F';
end;}

function TThermCondParam.Units : string;
begin
  result := 'W/m-C or BTU/ft-h-F';
end;

function TThermCondParam.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '3.'
    end
  else
    begin
      result := '41.60823'
    end;
end;

{ THorHeatCondLayer }
constructor THorHeatCondLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  Lock := Lock + [llEvalAlg];
  TThermDifParam.Create(ParamList, -1);
  TThermCondParam.Create(ParamList, -1);
end;

class Function THorHeatCondLayer.ANE_LayerName : string ;
begin
  result := kHeatCondHorLay;
end;

{ TVerHeatCondLayer }
constructor TVerHeatCondLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  TThermDifParam.Create(ParamList, -1);
  TThermCondParam.Create(ParamList, -1);
end;

class Function TVerHeatCondLayer.ANE_LayerName : string ;
begin
  result := kHeatCondVerLay;
end;

end.
