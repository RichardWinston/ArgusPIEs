unit HST3DGeologyLayerList;

interface

uses
  ANE_LayerUnit;

type
  TLastGeologicUnit = class(T_ANE_IndexedLayerList)
     constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
       Index: Integer); override;
  end;

  TGeologicUnit = class(TLastGeologicUnit)
     constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
       Index: Integer); override;
  end;

implementation

uses
  HST3DUnit, HST3D_PIE_Unit, HST3DGroupLayers, HST3DSpecifiedStateLayers,
  HST3DInitialPressureLayers, HST3DInitialTemp, HST3DInitialMassFracLayers,
  HST3DHeatCondLayers, HST3DSpecifiedFluxLayers, HST3DAquifLeakageLayers,
  HST3DEvapotranspirationLayers, HST3DAquifInflLayers, HST3DActiveAreaLayers,
  HST3DPermeabilityLayers, HST3DPorosityLayers, HST3DVertCompLayers,
  HST3DHeatCapacityLayers, HST3DThermCondLayers, HST3DDispersivityLayers,
  HST3DDistCoefLayers;

constructor TLastGeologicUnit.Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
       Index: Integer);
begin
  inherited;// Create(Index, AnOwner );

  LayerOrder.Add(kNodeGroupLayer);
  LayerOrder.Add(kInitPres);
  LayerOrder.Add(kInitTemp);
  LayerOrder.Add(kInitMassFracLayer);
  LayerOrder.Add(kSpecStateLayer);
  LayerOrder.Add(kSpecFluxHorLay);
  LayerOrder.Add(kSpecFluxVerLay);
  LayerOrder.Add(KAqLeakHorLay);
  LayerOrder.Add(KAqLeakVerLay);
{  LayerOrder.Add(kETHorLay);
  LayerOrder.Add(kETVerLay); }
  LayerOrder.Add(kAqInflHorLayer);
  LayerOrder.Add(kAqInflVerLayer);
  LayerOrder.Add(kHeatCondHorLay);
  LayerOrder.Add(kHeatCondVerLay);

  TNodeLayer.Create(self, -1);

  With PIE_Data do
  begin
    if not HST3DForm.cbSpecInitPres.Checked and
      not HST3DForm.cbInitWatTable.Checked then
    begin
      TInitialPresLayer.Create(self, -1);
    end;

    if HST3DForm.cbHeat.Checked then
    begin
      TInitialTempLayer.Create(self, -1);
    end;

    if HST3DForm.cbSolute.Checked then
    begin
      TInitialMassFracLayer.Create(self, -1);
    end;

    if HST3DForm.cbSpecPres.Checked or HST3DForm.cbSpecTemp.Checked or
       HST3DForm.cbSpecMass.Checked then
    begin
      TSpecifiedStateLayer.Create(self, -1);
    end;

    if HST3DForm.cbHeatCond.Checked then
    begin
      THorHeatCondLayer.Create(self, -1);
      TVerHeatCondLayer.Create(self, -1);
    end;

    if HST3DForm.cbSpecFlow.Checked or HST3DForm.cbSpecHeat.Checked or
       HST3DForm.cbSpecSolute.Checked then
    begin
      THorSpecFluxLayer.Create(self, -1);
      TVerSpecFluxLayer.Create(self, -1);
    end;

    if HST3DForm.cbLeakage.Checked then
    begin
      THorAqLeakageLayer.Create(self, -1);
      TVerAqLeakageLayer.Create(self, -1);
    end;

{    if HST3DForm.cbET.Checked then
    begin
      THorETLayer.Create(self, -1);
//      TVerETLayer.Create(self, -1);
    end;  }

    if HST3DForm.cbAqInfl.Checked then
    begin
      THorAqInflLayer.Create(self, -1);
      TVerAqInflLayer.Create(self, -1);
    end;
  end;

end;

constructor TGeologicUnit.Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
       Index: Integer);
begin
  inherited;// Create(Index, AnOwner);

  LayerOrder.Add(kUnitGroupLayer);
  LayerOrder.Add(kActiveAreaUnit);
  LayerOrder.Add(kPermUnit);
  LayerOrder.Add(kPorosityUnit);
  LayerOrder.Add(kVertComp);
  LayerOrder.Add(kHeatCap);
  LayerOrder.Add(kThermLayer);
  LayerOrder.Add(kDispLayer);
  LayerOrder.Add(KDistCoef);

  TUnitLayer.Create(self, -1);
  TActiveAreaLayer.Create(self, -1);
  TPermLayer.Create(self, -1);
  TPorosityLayer.Create(self, -1);
  TVertCompressLayer.Create(self, -1);

  With PIE_Data do
  begin
    if HST3DForm.cbHeat.Checked then
    begin
      THeatCapLayer.Create(self, -1);
      TThermCondLayer.Create(self, -1);
    end;

    if HST3DForm.cbHeat.Checked or HST3DForm.cbSolute.Checked then
    begin
      TDispLayer.Create(self, -1);
    end;

    if HST3DForm.cbSolute.Checked then
    begin
      TDistCoefLayer.Create(self, -1);
    end;
  end;
end;

end.
