unit SLFishnetMeshLayout;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TElemInXParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TElemInYParam = class(TElemInXParam)
    class Function ANE_ParamName : string ; override;
  end;

  TFishnetMeshLayout = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;


implementation

ResourceString
  kElements_in_x = 'elements_in_x';
  kElements_in_y = 'elements_in_y';
  kFishNetMeshLayout = 'FishNet Mesh Layout';

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
  TElemInXParam.Create(ParamList, -1);
  TElemInYParam.Create(ParamList, -1);
end;

end.
