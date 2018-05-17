unit HST3DLayerStructureUnit;

interface

uses ANE_LayerUnit;

type
  THST3DLayerStructure = class(TLayerStructure)
    constructor Create;
  end;

implementation

uses HST3DDomainDensityLayers, HST3DGridLayer, HST3DWellLayers,
     HST3DRiverLayers, HST3DInitialWatTabLayers, HST3DGeologyLayerList,
     HST3DUnit, HST3D_PIE_Unit, HST3DGroupLayers, HST3DSpecifiedStateLayers,
     HST3DInitialPressureLayers, HST3DSpecifiedFluxLayers, HST3DBCFLOWUnit,
     HST3DObservationElevations, HST3DEvapotranspirationLayers;

constructor THST3DLayerStructure.Create;
var
  UnitIndex           : Integer;
begin
  inherited Create;
  UnIndexedLayers.LayerOrder.Add(TDomainOutlineLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TDensityLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(THST3DGridLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(THST3DNodeGridLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TMapGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T_ANE_MapsLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TUnindexedGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TObsSurfLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TObsPointsLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TWellLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TRiverLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TInitWatTabLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TBCFLOWLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(THorETLayer.ANE_LayerName);


  TDomainOutlineLayer.Create(UnIndexedLayers, -1) ;
  TDensityLayer.Create(UnIndexedLayers, -1) ;
  THST3DGridLayer.Create(UnIndexedLayers, -1) ;
  TMapGroupLayer.Create(UnIndexedLayers, -1) ;
  T_ANE_MapsLayer.Create(UnIndexedLayers, -1) ;
  TUnindexedGroupLayer.Create(UnIndexedLayers, -1) ;
  with PIE_Data do
  begin
    if HST3DForm.cbObsElev.Checked then
    begin
      THST3DNodeGridLayer.Create(UnIndexedLayers, -1) ;
      TObsSurfLayer.Create(UnIndexedLayers, -1) ;
      TObsPointsLayer.Create(UnIndexedLayers, -1) ;
    end;
    if HST3DForm.cbWells.Checked and (HST3DForm.rgCoord.ItemIndex = Ord(csCartesian)) then
    begin
      TWellLayer.Create(UnIndexedLayers, -1) ;
    end;
    if HST3DForm.cbRiver.Checked then
    begin
      TRiverLayer.Create(UnIndexedLayers, -1)  ;
    end;
    if HST3DForm.cbFreeSurf.Checked then
    begin
      TInitWatTabLayer.Create(UnIndexedLayers, -1) ;
    end;

    if HST3DForm.cbUseBCFLOW.Checked then
    begin
      TBCFLOWLayer.Create(UnIndexedLayers, -1) ;
    end;

    if HST3DForm.cbET.Checked then
    begin
      THorETLayer.Create(UnIndexedLayers, -1) ;
    end;

    for UnitIndex := 1 to HST3DForm.sgGeology.RowCount -1 do
    begin
      TGeologicUnit.Create(ListsOfIndexedLayers, -1);
    end;
    TLastGeologicUnit.Create(ListsOfIndexedLayers, -1);

    UpdateIndicies;
    UpdateOldIndicies;
  end;
  TPostProcessingGroupLayer.Create(PostProcessingLayers, -1) ;
end;

end.
