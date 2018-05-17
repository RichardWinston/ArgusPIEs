unit SLSutraMeshGeoUnit;

interface

uses Sysutils, ANE_LayerUnit;

type
  TSutraMeshGeoUnit = class(T_ANE_IndexedLayerList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
      Position: Integer = -1); override;
  end;

implementation

uses frmSutraUnit, SLSutraMesh, SLFishnetMeshLayout;

{ TSutraMeshGeoUnit }

constructor TSutraMeshGeoUnit.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
begin
  inherited;
  if frmSutra.MorphedMesh then
  begin
    LayerOrder.Add(TSutraMeshLayer.ANE_LayerName);
    LayerOrder.Add(TFishnetMeshLayout.ANE_LayerName);
    TSutraMeshLayer.Create(self, -1);
    TFishnetMeshLayout.Create(self, -1);
  end;
end;

end.

