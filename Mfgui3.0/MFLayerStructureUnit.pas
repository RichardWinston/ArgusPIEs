unit MFLayerStructureUnit;

interface

{MFLayerStructureUnit defines two important classes: TMFGeologicUnit
 and TMFLayerStructure. The former is a list of layers associated with
 a geologic unit. The latter contains a representation of the entire
 Argus ONE layer structure controlled by the PIE. (It does not contain
 representations of layers or parameters created manually.)}

uses ANE_LayerUnit, SysUtils;

type
  TMFGeologicUnit = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TMFLayerStructure = class (TLayerStructure)
    constructor Create;
  end;

implementation

uses Variables, ModflowUnit;

constructor TMFGeologicUnit.Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer);
begin
  inherited Create(AnOwner, Position);

  LayerOrder.Add(ModflowTypes.GetMFGeolUnitGroupLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFTopElevLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetBottomElevLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetInactiveLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetInitialHeadLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFTransmisivityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFVcontLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFSpecYieldLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFSpecStorageLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFConfStorageLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFWettingLayerType.ANE_LayerName);

  LayerOrder.Add(ModflowTypes.GetMFWellLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName);

  LayerOrder.Add(ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetLineDrainLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetAreaDrainLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetPointGHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetLineGHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetAreaGHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFHFBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineFHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMODPATHZoneLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMODPATHLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMOCInitialConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMOCPorosityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCRetardationLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCDisDecayCoefLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCDisGrowthLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCSorbDecayCoefLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCSorbGrowthLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCImInitConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCImPorosityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCLinExchCoefLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCDecayCoefLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMOCGrowthLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetZoneBudLayerType.ANE_LayerName);

  ModflowTypes.GetMFGeolUnitGroupLayerType.Create(self, -1);
  ModflowTypes.GetMFTopElevLayerType.Create( self, -1);
  ModflowTypes.GetBottomElevLayerType.Create( self, -1);
  ModflowTypes.GetInactiveLayerType.Create( self, -1);
  ModflowTypes.GetPrescribedHeadLayerType.Create( self, -1);
  ModflowTypes.GetInitialHeadLayerType.Create( self, -1);
  ModflowTypes.GetHydraulicCondLayerType.Create( self, -1);

{  if Index = -1 then
  begin
    Layer := frmModflow.dgGeol.RowCount-1;
  end
  else
  begin
    Layer := frmModflow.dgGeol.Selection.Top
  end;   }

  if frmModflow.dgGeol.Cells[Ord(nuiSpecT),Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecT)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFTransmisivityLayerType.Create( self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT),Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFVcontLayerType.Create( self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecSF1),Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecSF1)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFConfStorageLayerType.Create( self, -1);
  end;

  ModflowTypes.GetMFSpecYieldLayerType.Create( self, -1);
  ModflowTypes.GetMFSpecStorageLayerType.Create( self, -1);
  ModflowTypes.GetMFWettingLayerType.Create( self, -1);

  if frmMODFLOW.cbWel.Checked then
  begin
    ModflowTypes.GetMFWellLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbRIV.Checked then
  begin
    ModflowTypes.GetMFPointRiverLayerType.Create( self, -1);
    ModflowTypes.GetMFLineRiverLayerType.Create( self, -1);
    ModflowTypes.GetMFAreaRiverLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbDRN.Checked then
  begin
    ModflowTypes.GetMFPointDrainLayerType.Create( self, -1);
    ModflowTypes.GetLineDrainLayerType.Create( self, -1);
    ModflowTypes.GetAreaDrainLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbGHB.Checked then
  begin
    ModflowTypes.GetPointGHBLayerType.Create( self, -1);
    ModflowTypes.GetLineGHBLayerType.Create( self, -1);
    ModflowTypes.GetAreaGHBLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbSTR.Checked then
  begin
    ModflowTypes.GetMFStreamLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbHFB.Checked then
  begin
    ModflowTypes.GetMFHFBLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbFHB.Checked then
  begin
    ModflowTypes.GetMFPointFHBLayerType.Create( self, -1);
    ModflowTypes.GetMFLineFHBLayerType.Create( self, -1);
    ModflowTypes.GetMFAreaFHBLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMODPATH.Checked or frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMOCPorosityLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMODPATHLayerType.Create(self, -1);
    ModflowTypes.GetMODPATHZoneLayerType.Create(self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMOCInitialConcLayerType.Create( self, -1);
    ModflowTypes.GetMOCParticleRegenLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbDualPorosity.Checked then
  begin
    ModflowTypes.GetMFMOCImInitConcLayerType.Create( self, -1);
    ModflowTypes.GetMFMOCImPorosityLayerType.Create( self, -1);
    ModflowTypes.GetMFMOCLinExchCoefLayerType.Create( self, -1);
    if frmMODFLOW.cbIDPFO.Checked then
    begin
      ModflowTypes.GetMFMOCDecayCoefLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbIDPZO.Checked then
    begin
      ModflowTypes.GetMFMOCGrowthLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbSimpleReactions.Checked then
  begin
    if frmMODFLOW.cbIDKRF.Checked then
    begin
      ModflowTypes.GetMFMOCRetardationLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbIDKFO.Checked then
    begin
      ModflowTypes.GetMFMOCDisDecayCoefLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbIDKFS.Checked then
    begin
      ModflowTypes.GetMFMOCSorbDecayCoefLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbIDKZO.Checked then
    begin
      ModflowTypes.GetMFMOCDisGrowthLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbIDKZS.Checked then
    begin
      ModflowTypes.GetMFMOCSorbGrowthLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbZonebudget.Checked then
  begin
    ModflowTypes.GetZoneBudLayerType.Create( self, -1);
  end;

end;



constructor TMFLayerStructure.Create;
var
  GeolUnitIndex : integer;
  NumberOfUnits : integer;
begin
  inherited Create;

  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFDomainOutType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetDensityLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetGridLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetRechargeLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCRechargeConcLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetETLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCObsWellLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMapLayerType.ANE_LayerName);

  ModflowTypes.GetMFDomainOutType.Create(UnIndexedLayers, -1);
  ModflowTypes.GetDensityLayerType.Create( UnIndexedLayers, -1);
  ModflowTypes.GetGridLayerType.Create( UnIndexedLayers, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMOCTransSubGridLayerType.Create( UnIndexedLayers, -1);
  end;
  if frmMODFLOW.cbRCH.Checked then
  begin
    ModflowTypes.GetRechargeLayerType.Create( UnIndexedLayers, -1);
  end;
  if frmMODFLOW.cbRCH.Checked and frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMOCRechargeConcLayerType.Create( UnIndexedLayers, -1);
  end;
  if frmMODFLOW.cbEVT.Checked then
  begin
    ModflowTypes.GetETLayerType.Create( UnIndexedLayers, -1);
  end;
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMOCObsWellLayerType.Create( UnIndexedLayers, -1);
  end;
  ModflowTypes.GetMapLayerType.Create( UnIndexedLayers, -1);

  NumberOfUnits := StrToInt(frmMODFLOW.edNumUnits.Text);
  for GeolUnitIndex := 1 to NumberOfUnits do
  begin
    ModflowTypes.GetGeologicUnitType.Create(ListsOfIndexedLayers,  -1);
  end;

  ModflowTypes.GetMFPostProcessingGroupLayerType.Create(PostProcessingLayers, -1);
{  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMODPATHPostLayerType.Create(PostProcessingLayers, -1);
  end; }

end;

end.
