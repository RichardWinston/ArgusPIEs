unit SLGeoUnit;

interface

Uses ANE_LayerUnit;

type
  TSutraGeoUnit = class(T_ANE_IndexedLayerList)
    constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
      Position: Integer {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

uses frmSutraUnit, SLMorphLayer, SLObservation, SLGroupLayers, SLPorosity,
  SLPermeability, SLDispersivity, SLUnsaturated, SLSourcesOfFluid,
  SLEnergySoluteSources, SLSpecifiedPressure, SLSpecConcOrTemp,
  SLInitialPressure, SLInitConcOrTemp, SLSutraMesh, SLFishnetMeshLayout,
  SLDomainDensity,SLThickness;

{ TSutraGeoUnit }

constructor TSutraGeoUnit.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
begin
  inherited;
  with frmSutra do
  begin
    LayerOrder.Add(TSutraNodeSurfaceGroupLayer.ANE_LayerName);
    LayerOrder.Add(TSutraMorphMeshLayer.ANE_LayerName);
    LayerOrder.Add(TSutraMeshLayer.ANE_LayerName);
    LayerOrder.Add(TFishnetMeshLayout.ANE_LayerName);
    LayerOrder.Add(TSutraDomainOutline.ANE_LayerName);
    LayerOrder.Add(TSutraMeshDensity.ANE_LayerName);
    LayerOrder.Add(TObservationLayer.ANE_LayerName);

    LayerOrder.Add(TThicknessLayer.ANE_LayerName);

    LayerOrder.Add(TPorosityLayer.ANE_LayerName);
    LayerOrder.Add(TPermeabilityLayer.ANE_LayerName);
    LayerOrder.Add(TDispersivityLayer.ANE_LayerName);
    LayerOrder.Add(TUnsaturatedLayer.ANE_LayerName);
    LayerOrder.Add(TFluidSourcesLayer.ANE_LayerName);
    LayerOrder.Add(TSoluteEnergySourcesLayer.ANE_LayerName);
    LayerOrder.Add(TSpecifiedPressureLayer.ANE_LayerName);
    LayerOrder.Add(TSpecConcTempLayer.ANE_LayerName);
    LayerOrder.Add(TInitialPressureLayer.ANE_LayerName);
    LayerOrder.Add(TInitialConcTempLayer.ANE_LayerName);

    TSutraNodeSurfaceGroupLayer.Create(self,-1);
    if frmSutra.MorphedMesh then
    begin
      TSutraMorphMeshLayer.Create(self,-1);
      TSutraMeshLayer.Create(self,-1);
        if rbGeneral.Checked or rbFishnet.Checked then
        begin
          TFishnetMeshLayout.Create(self, -1);
        end;
//      TSutraDomainOutline.Create(self,-1);
//      TSutraMeshDensity.Create(self,-1);
    end;
    TObservationLayer.Create(self, -1);

//    if rb3D_va.Checked then
//    begin
      TThicknessLayer.Create(self, -1);
//    end;

    TPorosityLayer.Create(self,-1);
    TPermeabilityLayer.Create(self,-1);
    TDispersivityLayer.Create(self,-1);
    if rbGeneral.Checked or rbSatUnsat.Checked
      then
    begin
      TUnsaturatedLayer.Create(self, -1);
    end;
    TFluidSourcesLayer.Create(self,-1);
    TSoluteEnergySourcesLayer.Create(self,-1);
    TSpecifiedPressureLayer.Create(self,-1);
    TSpecConcTempLayer.Create(self,-1);
    TInitialPressureLayer.Create(self,-1);
    TInitialConcTempLayer.Create(self,-1);
  end;

end;

end.
