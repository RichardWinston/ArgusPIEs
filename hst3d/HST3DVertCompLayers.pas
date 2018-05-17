unit HST3DVertCompLayers;

interface

uses ANE_LayerUnit;

type
TVertCompressParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function WriteName : string; override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TVertCompressLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kVertComp = 'Vertical Compressibility Element Layer';

implementation

uses HST3D_PIE_Unit;

{ TVertCompressParam }
class Function TVertCompressParam.ANE_ParamName : string ;
begin
  result := kVertComp;
end;

{constructor TVertCompressParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'Pa^-1 or psi^-1';
end;   }

function TVertCompressParam.Units : string;
begin
  result := 'Pa^-1 or psi^-1';
end;

function TVertCompressParam.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '1.0e-8'
    end
  else
    begin
      result := '6.894759086775e-5'
    end;
end;

function TVertCompressParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.ANE_LayerName + ParentLayer.WriteIndex;
end;

{ TVertCompressLayer }
constructor TVertCompressLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'Pa^-1 or psi^-1';
  TVertCompressParam.Create(ParamList, -1);
end;

function TVertCompressLayer.Units : string;
begin
  result := 'Pa^-1 or psi^-1';
end;

class Function TVertCompressLayer.ANE_LayerName : string ;
begin
  result := kVertComp;
end;

end.
