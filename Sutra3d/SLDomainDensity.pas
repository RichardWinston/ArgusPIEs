unit SLDomainDensity;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TElementSizeParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

  TSutraDomainOutline = class(T_ANE_DomainOutlineLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TSutraMeshDensity = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

implementation

uses frmSutraUnit;

resourcestring
  kElement_size = 'element_size';
  kMeshDensity = 'Mesh Density';

  { TElementSizeParam }

class function TElementSizeParam.ANE_ParamName: string;
begin
  result := kElement_size;
end;

{ TSutraDomainOutline }

constructor TSutraDomainOutline.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Visible := False;
  TElementSizeParam.Create(ParamList, -1);
end;

class function TSutraDomainOutline.WriteNewRoot: string;
begin
  if frmSutra.rbFishnet.Checked then
  begin
    result := 'unused layer1';
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

{ TSutraMeshDensity }

class function TSutraMeshDensity.ANE_LayerName: string;
begin
  result := kMeshDensity;
end;

constructor TSutraMeshDensity.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TElementSizeParam.Create(ParamList, -1);
end;

class function TSutraMeshDensity.WriteNewRoot: string;
begin
  if frmSutra.rbFishnet.Checked then
  begin
    result := 'unused layer2';
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

end.

