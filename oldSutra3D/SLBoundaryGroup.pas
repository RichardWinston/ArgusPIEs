unit SLBoundaryGroup;

interface

Uses ANE_LayerUnit;

type
  TBoundaryList = class(T_ANE_IndexedLayerList)
    constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
      Position: Integer {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

uses SLSourcesOfFluid, SLEnergySoluteSources, SLSpecifiedPressure,
  SLSpecConcOrTemp;

{ TBoundaryList }

constructor TBoundaryList.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
begin
  inherited;
  TVolFluidSourcesLayer.Create(self,-1);
  TSurfaceFluidSourcesLayer.Create(self,-1);
  TVolSoluteEnergySourcesLayer.Create(self,-1);
  TSurfaceSoluteEnergySourcesLayer.Create(self,-1);
  TVolSpecifiedPressureLayer.Create(self,-1);
  TSpecifiedPressureSurfaceLayer.Create(self,-1);
  TVolSpecConcTempLayer.Create(self,-1);
  TSurfaceSpecConcTempLayer.Create(self,-1);
end;


end.
