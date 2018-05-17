unit MFLayerStructure;

interface

uses ANE_LayerUnit, SysUtils;

type
  TMFGeologicUnit = Class(T_ANE_IndexedLayerList)
    constructor Create(Index: Integer; AnOwner : T_ANE_ListOfIndexedLayerLists);
  end;

  TMFLayerStructure = class (TLayerStructure)
    constructor Create;
  end;

implementation

uses ModflowUnit, MFDomainOut, MFGridDensity, MFGrid, MFMap, MFTop, MFBottom,
     MFInactive, MFPrescribedHead, MFInitialHead, MFHydraulicCond, MFSpecYield,
     MFSpecStor, MFWetting, MFRecharge, MFRechConc, MFEvapo, MFMOCObsWell,
     MFRiver, MFDrain, MFGenHeadBound, MFMOCInitConc, MFMOCParticleRegen,
     MFMOCPorosity, MFWells;

constructor TMFGeologicUnit.Create(Index: Integer;
  AnOwner : T_ANE_ListOfIndexedLayerLists);
begin
  inherited Create(Index, AnOwner);

  LayerOrder.Add(TTopElevLayer.ANE_Name);
  LayerOrder.Add(TBottomElevLayer.ANE_Name);
  LayerOrder.Add(TInactiveLayer.ANE_Name);
  LayerOrder.Add(TPrescribedHeadLayer.ANE_Name);
  LayerOrder.Add(TInitialHeadLayer.ANE_Name);
  LayerOrder.Add(THydraulicCondLayer.ANE_Name);
  LayerOrder.Add(TSpecYieldLayer.ANE_Name);
  LayerOrder.Add(TSpecStorageLayer.ANE_Name);
  LayerOrder.Add(TWettingLayer.ANE_Name);

  LayerOrder.Add(TWellLayer.ANE_Name);
  LayerOrder.Add(TLineRiverLayer.ANE_Name);
  LayerOrder.Add(TAreaRiverLayer.ANE_Name);
  LayerOrder.Add(TLineDrainLayer.ANE_Name);
  LayerOrder.Add(TAreaDrainLayer.ANE_Name);
  LayerOrder.Add(TPointGHBLayer.ANE_Name);
  LayerOrder.Add(TLineGHBLayer.ANE_Name);
  LayerOrder.Add(TAreaGHBLayer.ANE_Name);
  LayerOrder.Add(TMOCInitialConcLayer.ANE_Name);
  LayerOrder.Add(TMOCParticleRegenLayer.ANE_Name);
  LayerOrder.Add(TMOCPorosityLayer.ANE_Name);

  TTopElevLayer.Create(-1, self);
  TBottomElevLayer.Create(-1, self);
  TInactiveLayer.Create(-1, self);
  TPrescribedHeadLayer.Create(-1, self);
  TInitialHeadLayer.Create(-1, self);
  THydraulicCondLayer.Create(-1, self);
  TSpecYieldLayer.Create(-1, self);
  TSpecStorageLayer.Create(-1, self);
  TWettingLayer.Create(-1, self);

  if frmMODFLOW.cbWel.Checked then
  begin
    TWellLayer.Create(-1, self);
  end;

  if frmMODFLOW.cbRIV.Checked then
  begin
    TLineRiverLayer.Create(-1, self);
    TAreaRiverLayer.Create(-1, self);
  end;

  if frmMODFLOW.cbDRN.Checked then
  begin
    TLineDrainLayer.Create(-1, self);
    TAreaDrainLayer.Create(-1, self);
  end;

  if frmMODFLOW.cbGHB.Checked then
  begin
    TPointGHBLayer.Create(-1, self);
    TLineGHBLayer.Create(-1, self);
    TAreaGHBLayer.Create(-1, self);
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    TMOCInitialConcLayer.Create(-1, self);
    TMOCParticleRegenLayer.Create(-1, self);
    TMOCPorosityLayer.Create(-1, self);
  end;

end;



constructor TMFLayerStructure.Create;
var
  GeolUnitIndex : integer;
begin
  inherited Create;

  UnIndexedLayers.LayerOrder.Add(TMFDomainOut.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TMFDensityLayer.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TMFGridLayer.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TRechargeLayer.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TMOCRechargeConcLayer.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TETLayer.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TMOCObsWellLayer.ANE_Name);
  UnIndexedLayers.LayerOrder.Add(TMFMapLayer.ANE_Name);

  TMFDomainOut.Create(-1, UnIndexedLayers);
  TMFDensityLayer.Create(-1, UnIndexedLayers);
  TMFGridLayer.Create(-1, UnIndexedLayers);
  if frmMODFLOW.cbRCH.Checked then
  begin
    TRechargeLayer.Create(-1, UnIndexedLayers);
  end;
  if frmMODFLOW.cbRCH.Checked and frmMODFLOW.cbMOC3D.Checked then
  begin
    TMOCRechargeConcLayer.Create(-1, UnIndexedLayers);
  end;
  if frmMODFLOW.cbEVT.Checked then
  begin
    TETLayer.Create(-1, UnIndexedLayers);
  end;
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    TMOCObsWellLayer.Create(-1, UnIndexedLayers);
  end;
  TMFMapLayer.Create(-1, UnIndexedLayers);

  for GeolUnitIndex := 1 to StrToInt(frmMODFLOW.edNumUnits.Text) do
  begin
    TMFGeologicUnit.Create(-1, ListsOfIndexedLayers);
  end;
end;

end.
