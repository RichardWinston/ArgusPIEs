unit HST3DPermeabilityLayers;

interface

uses ANE_LayerUnit;

type
TKxLayerParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TKyLayerParam = Class(TKxLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string ; override;
  end;

TKZLayerParam = Class(TKxLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string ; override;
  end;

TPermLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kPermKx = 'kx';
  kPermKy = 'ky';
  kPermKz = 'kz';
  kPermUnit = 'Permeability Element Layer';

implementation

uses HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit;

{ TKxLayerParam }
class Function TKxLayerParam.ANE_ParamName : string ;
begin
  result := kPermKx;
end;

{constructor TKxLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'm^2 or ft^2';
end;}

function TKxLayerParam.Units : string;
begin
  result := 'm^2 or ft^2';
end;

function TKxLayerParam.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '1.0e-10';
    end
  else
    begin
      result := '1.076391041671e-9'
    end;
end;

{ TKyLayerParam }
class Function TKyLayerParam.ANE_ParamName : string ;
begin
  result := kPermKy;
end;

function TKyLayerParam.Value : string;
begin
  result := kPermKx;
end;

{ TKzLayerParam }
class Function TKzLayerParam.ANE_ParamName : string ;
begin
  result := kPermKz;
end;

function TKzLayerParam.Value : string;
begin
  result := kPermKx + '/10';
end;

{ TPermLayer }
constructor TPermLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'm^2 or ft^2';
  TKxLayerParam.Create(ParamList, -1);
  TKyLayerParam.Create(ParamList, -1);
  TKzLayerParam.Create(ParamList, -1);
end;

function TPermLayer.Units : string;
begin
  result := 'm^2 or ft^2';
end;

class Function TPermLayer.ANE_LayerName : string ;
begin
  result := kPermUnit;
end;

end.
