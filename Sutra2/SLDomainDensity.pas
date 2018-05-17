unit SLDomainDensity;

interface

uses ANE_LayerUnit;

type
  TElementSizeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TSutraDomainOutline = class(T_ANE_DomainOutlineLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSutraMeshDensity = Class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;


implementation

ResourceString
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
  TElementSizeParam.Create(ParamList, -1);
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

end.
