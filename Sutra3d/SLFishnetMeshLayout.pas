unit SLFishnetMeshLayout;

interface

uses SysUtils, ANE_LayerUnit, SLCustomLayers;

type
  TElemInXParam = class(T_ANE_MeshParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TElemInYParam = class(TElemInXParam)
    class function ANE_ParamName: string; override;
  end;

  TFishnetMeshLayout = class(T_ANE_QuadMeshLayer) //T_ANE_QuadMeshLayer
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
    function WriteLayerRoot: string; override;
  end;

implementation

uses frmSutraUnit, OptionsUnit, SLSutraMesh;

resourcestring
  kElements_in_x = 'elements_in_x';
  kElements_in_y = 'elements_in_y';
  kFishNetMeshLayout = 'FishNet_Mesh_Layout';

  { TElemInXParam }

class function TElemInXParam.ANE_ParamName: string;
begin
  result := kElements_in_x;
end;

constructor TElemInXParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := Lock - [plDef_Val];
  SetValue := False;
end;

function TElemInXParam.Value: string;
begin
  result := kNa;
end;

{ TElemInYParam }

class function TElemInYParam.ANE_ParamName: string;
begin
  result := kElements_in_y;
end;

{ TFishnetMeshLayout }

class function TFishnetMeshLayout.ANE_LayerName: string;
begin
  result := kFishNetMeshLayout;
end;

constructor TFishnetMeshLayout.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Visible := False;
  TElemInXParam.Create(ParamList, -1);
  TElemInYParam.Create(ParamList, -1);
end;

function TFishnetMeshLayout.WriteIndex: string;
var
  Value: integer;
begin
  result := inherited WriteIndex;
  if result <> '' then
  begin
    Value := StrToInt(result) - 1;
    if Value = 0 then
    begin
      result := '';
    end
    else
    begin
      result := IntToStr(Value);
    end;
  end;
end;

function TFishnetMeshLayout.WriteLayerRoot: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    if WriteIndex = '' then
    begin
      result := inherited WriteLayerRoot + KTop;
    end
    else
    begin
      result := inherited WriteLayerRoot + KBottom;
    end;
  end
  else
  begin
    result := inherited WriteLayerRoot;
  end;
end;

function TFishnetMeshLayout.WriteOldIndex: string;
var
  Value: integer;
begin
  result := inherited WriteOldIndex;
  if result <> '' then
  begin
    Value := StrToInt(result) - 1;
    if Value = 0 then
    begin
      result := '';
    end
    else
    begin
      result := IntToStr(Value);
    end;
  end;
end;

end.

