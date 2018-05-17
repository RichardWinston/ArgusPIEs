unit SLGeoUnit;

interface

Uses Sysutils, ANE_LayerUnit;

type
  TSutraGeoUnit = class(T_ANE_IndexedLayerList)
    constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
      Position: Integer = -1); override;
  end;

implementation

uses frmSutraUnit, SLMorphLayer, SLObservation, SLGroupLayers, SLPorosity,
  SLPermeability, SLDispersivity, SLUnsaturated, SLSourcesOfFluid,
  SLEnergySoluteSources, SLSpecifiedPressure, SLSpecConcOrTemp,
  SLInitialPressure, SLInitConcOrTemp, SLSutraMesh, SLFishnetMeshLayout,
  SLDomainDensity, SLThickness, SLSpecificHeat, SLThermalConductivity;

{ TSutraGeoUnit }

constructor TSutraGeoUnit.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
var
  selfPosition : integer;
begin
  inherited;
  selfPosition := Position;
  with frmSutra do
  begin
    LayerOrder.Add(TSutraUnitGroupLayer.ANE_LayerName);
    LayerOrder.Add(TSutraHydrogeologyGroupLayer.ANE_LayerName);
    LayerOrder.Add(TPorosityLayer.ANE_LayerName);
    {$IFDEF SutraIce}
    LayerOrder.Add(TSpecificHeatLayer.ANE_LayerName);
    LayerOrder.Add(TThermalConductivityLayer.ANE_LayerName);
    {$ENDIF}
    LayerOrder.Add(TPermeabilityLayer.ANE_LayerName);
    LayerOrder.Add(TDispersivityLayer.ANE_LayerName);
    LayerOrder.Add(TUnsaturatedLayer.ANE_LayerName);

    LayerOrder.Add(TSutraInitialConditionsGroupLayer.ANE_LayerName);
    LayerOrder.Add(TInitialPressureLayer.ANE_LayerName);
    LayerOrder.Add(TInitialPressureOverrideLayer.ANE_LayerName);
    LayerOrder.Add(TInitialConcTempLayer.ANE_LayerName);
    LayerOrder.Add(TInitialConcTempOverrideLayer.ANE_LayerName);

    LayerOrder.Add(TBottomGroupLayer.ANE_LayerName);
    LayerOrder.Add(TThicknessLayer.ANE_LayerName);
    LayerOrder.Add(TBottomFluidSourcesLayer.ANE_LayerName);
    LayerOrder.Add(TBottomSoluteEnergySourcesLayer.ANE_LayerName);
    LayerOrder.Add(TBottomSpecifiedPressureLayer.ANE_LayerName);
    LayerOrder.Add(TBottomSpecConcTempLayer.ANE_LayerName);
    LayerOrder.Add(TBottomObservationLayer.ANE_LayerName);

    TSutraUnitGroupLayer.Create(self,-1);

    if selfPosition <> StrToInt(adeVertDisc.Text) then
    begin
      TSutraHydrogeologyGroupLayer.Create(self, -1);
      TPorosityLayer.Create(self,-1);
      {$IFDEF SutraIce}
      if (rbFreezing.Checked or rbEnergy.Checked) then
      begin
        TSpecificHeatLayer.Create(self,-1);
        TThermalConductivityLayer.Create(self,-1);
      end;
      {$ENDIF}
      TPermeabilityLayer.Create(self,-1);
      TDispersivityLayer.Create(self,-1);
      if rbGeneral.Checked or rbFreezing.Checked or rbSatUnsat.Checked then
      begin
        TUnsaturatedLayer.Create(self, -1);
      end;

      TBottomGroupLayer.Create(self, -1);  {= bottom layer}
      TThicknessLayer.Create(self, -1);  {= bottom layer}

      TSutraInitialConditionsGroupLayer.Create(self, -1);
      TInitialPressureLayer.Create(self,-1);
      if cbPressureOverride.Enabled and cbPressureOverride.Checked then
      begin
        TInitialPressureOverrideLayer.Create(self,-1);
      end;
      TInitialConcTempLayer.Create(self,-1);
      if cbConcentrationOverride.Enabled and cbConcentrationOverride.Checked then
      begin
        TInitialConcTempOverrideLayer.Create(self,-1);
      end;
    end;
  end;
end;

end.
