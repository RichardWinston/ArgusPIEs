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
  LayerOrder.Add(ModflowTypes.GetMFAnistropyLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFTransmisivityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFVcontLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFSpecYieldLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFSpecStorageLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFConfStorageLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFWettingLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFWellLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineWellLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaWellLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetLineDrainLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetAreaDrainLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointDrainReturnLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineDrainReturnLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaDrainReturnLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetPointGHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetLineGHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetAreaGHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFDaflowLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFHFBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineFHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFIBSLayerType.ANE_LayerName);

  LayerOrder.Add(ModflowTypes.GetMFNoDelaySubsidenceLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFDelaySubsidenceLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName);

  LayerOrder.Add(ModflowTypes.GetMFHydmodLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFPointLineCHD_LayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaCHD_LayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMNW_WaterQualityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMODPATHZoneLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMODPATHLayerType.ANE_LayerName);

  LayerOrder.Add(ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMOCInitialParticlePlacementLayerType.ANE_LayerName);
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
  LayerOrder.Add(ModflowTypes.GetMFMoc3dParticleObsLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetGWT_TimeVaryConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetGWT_VolumeBalancingLayerClass.ANE_LayerName);

  // GWM
  LayerOrder.Add(ModflowTypes.GetZoneBudLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFFluxVariableLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFHeadConstraintLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFDrawdownConstraintLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFHeadDifferenceLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFGradientLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFStreamConstraintLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFStreamDepletionConstraintLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFGwmHeadStateLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFGwmStreamStateLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFGwmStorageStateLayerType.ANE_LayerName);

  // MT3D
  LayerOrder.Add(ModflowTypes.GetMT3DInactiveAreaLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DMassFluxLayerType.ANE_LayerName);

  LayerOrder.Add(ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DAreaInitConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DBulkDensityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DSorptionLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DReactionLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFMT3DMolecularDiffusionLayerType.ANE_LayerName);


  LayerOrder.Add(ModflowTypes.GetFluidDensityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFViscosityLayerType.ANE_LayerName);

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

  if frmModflow.AnisotropyUsed(Index) then
  begin
    ModflowTypes.GetMFAnistropyLayerType.Create( self, -1);
  end;
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
    ModflowTypes.GetMFLineWellLayerType.Create( self, -1);
    if frmModflow.cbUseAreaWells.Checked then
    begin
      ModflowTypes.GetMFAreaWellLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbRIV.Checked then
  begin
    ModflowTypes.GetMFPointRiverLayerType.Create( self, -1);
    ModflowTypes.GetMFLineRiverLayerType.Create( self, -1);
    if frmModflow.cbUseAreaRivers.Checked then
    begin
      ModflowTypes.GetMFAreaRiverLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbDRN.Checked then
  begin
    ModflowTypes.GetMFPointDrainLayerType.Create( self, -1);
    ModflowTypes.GetLineDrainLayerType.Create( self, -1);
    if frmMODFLOW.cbUseAreaDrains.Checked then
    begin
      ModflowTypes.GetAreaDrainLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbDRT.Checked then
  begin
    ModflowTypes.GetMFPointDrainReturnLayerType.Create( self, -1);
    ModflowTypes.GetMFLineDrainReturnLayerType.Create( self, -1);
    if frmModflow.cbUseAreaDrainReturns.Checked then
    begin
      ModflowTypes.GetMFAreaDrainReturnLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbGHB.Checked then
  begin
    ModflowTypes.GetPointGHBLayerType.Create( self, -1);
    ModflowTypes.GetLineGHBLayerType.Create( self, -1);
    if frmMODFLOW.cbUseAreaGHBs.Checked then
    begin
      ModflowTypes.GetAreaGHBLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbSTR.Checked then
  begin
    ModflowTypes.GetMFStreamLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbSFR.Checked then
  begin
    ModflowTypes.GetMF2KSimpleStreamLayerType.Create( self, -1);

    if frmMODFLOW.cbSFRCalcFlow.Checked then
    begin
      ModflowTypes.GetMF2K8PointChannelStreamLayerType.Create( self, -1);
      ModflowTypes.GetMF2KFormulaStreamLayerType.Create( self, -1);
      ModflowTypes.GetMF2KTableStreamLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbDAFLOW.Checked then
  begin
    ModflowTypes.GetMFDaflowLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbHFB.Checked then
  begin
    ModflowTypes.GetMFHFBLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbCHD.Checked then
  begin
    ModflowTypes.GetMFPointLineCHD_LayerType.Create( self, -1);
    if frmMODFLOW.cbUseAreaCHD.Checked then
    begin
      ModflowTypes.GetMFAreaCHD_LayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbFHB.Checked then
  begin
    ModflowTypes.GetMFPointFHBLayerType.Create( self, -1);
    ModflowTypes.GetMFLineFHBLayerType.Create( self, -1);
    if frmModflow.cbUseAreaFHBs.Checked then
    begin
      ModflowTypes.GetMFAreaFHBLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbIBS.Checked and frmModflow.UseIBS(Index) then
  begin
    ModflowTypes.GetMFIBSLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbSub.Checked then
  begin
    if frmMODFLOW.NoDelayInterbedCount(Index) > 0 then
    begin
      ModflowTypes.GetMFNoDelaySubsidenceLayerType.Create( self, -1);
    end;

    if frmMODFLOW.DelayInterbedCount(Index) > 0 then
    begin
      ModflowTypes.GetMFDelaySubsidenceLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbSwt.Checked then
  begin
    ModflowTypes.GetMFSwtUnitLayerType.Create( self, -1);
  end;


  if frmMODFLOW.cbHYD.Checked then
  begin
    ModflowTypes.GetMFHydmodLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMNW.Checked then
  begin
    ModflowTypes.GetMFMNW_WaterQualityLayerType.Create( self, -1);
  end;

  if frmMODFLOW.PorosityUsed then
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
  end;
  if frmMODFLOW.cbMOC3D.Checked and (frmModflow.rgMOC3DSolver.ItemIndex < 2) then
  begin
    ModflowTypes.GetMOCParticleRegenLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.WeightedParticlesUsed
    and (frmMODFLOW.comboSpecifyParticles.ItemIndex <> 0) then
  begin
    ModflowTypes.GetMOCInitialParticlePlacementLayerType.Create( self, -1);
  end;

  if (frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbDualPorosity.Checked)
    or (frmModflow.cbMT3D.Checked and frmModflow.cbRCT.Checked
     and frmModflow.cbMT3D_StartingConcentration.Checked
     and not frmModflow.cbMT3D_OneDArrays.Checked
     and (frmModflow.comboMT3DIsotherm.ItemIndex >= 4)) then
  begin
    ModflowTypes.GetMFMOCImInitConcLayerType.Create( self, -1);
  end;
  if (frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbDualPorosity.Checked)
    or (frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbRCT.Checked
      and (frmMODFLOW.comboMT3DIsotherm.ItemIndex >=5)
      and not frmMODFLOW.cbMT3D_OneDArrays.Checked) then
  begin
    ModflowTypes.GetMFMOCImPorosityLayerType.Create( self, -1);
  end;
  if frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbDualPorosity.Checked then
  begin
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

  if frmMODFLOW.cbMOC3D.Checked and
    frmMODFLOW.cbParticleObservations.Checked then
  begin
    ModflowTypes.GetMFMoc3dParticleObsLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked and
    frmMODFLOW.cbCCBD.Checked then
  begin
    ModflowTypes.GetGWT_TimeVaryConcLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked
    and (frmMODFLOW.rgMOC3DSolver.ItemIndex in [3,4])
    and frmMODFLOW.cbISRCFIX.Checked then
  begin
    ModflowTypes.GetGWT_VolumeBalancingLayerClass.Create( self, -1);
  end;

  if ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.Used then
  begin
    ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.Create( self, -1);
  end;
  
  if frmMODFLOW.cbZonebudget.Checked then
  begin
    ModflowTypes.GetZoneBudLayerType.Create( self, -1);
  end;

  if frmMODFLOW.cb_GWM.Checked then
  begin
    ModflowTypes.GetMFFluxVariableLayerType.Create( self, -1);
    ModflowTypes.GetMFHeadConstraintLayerType.Create( self, -1);
    ModflowTypes.GetMFDrawdownConstraintLayerType.Create( self, -1);
    ModflowTypes.GetMFHeadDifferenceLayerType.Create( self, -1);
    ModflowTypes.GetMFGradientLayerType.Create( self, -1);
    if frmMODFLOW.cbSTR.Checked or frmMODFLOW.cbSFR.Checked then
    begin
      ModflowTypes.GetMFStreamConstraintLayerType.Create( self, -1);
      ModflowTypes.GetMFStreamDepletionConstraintLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbGwmHeadVariables.Checked then
    begin
      ModflowTypes.GetMFGwmHeadStateLayerType.Create( self, -1);
    end;
    if frmMODFLOW.cbGwmStreamVariables.Checked
      and (frmMODFLOW.cbSTR.Checked or frmMODFLOW.cbSFR.Checked) then
    begin
      ModflowTypes.GetMFGwmStreamStateLayerType.Create( self, -1);
    end;
    if StrToInt(frmMODFLOW.rdeGwmStorageStateVarCount.Output) >= 1 then
    begin
      ModflowTypes.GetMFGwmStorageStateLayerType.Create( self, -1);
    end;
  end;

  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetMT3DInactiveAreaLayerType.Create(self, -1);
    ModflowTypes.GetMT3DObservationsLayerType.Create(self, -1);
    ModflowTypes.GetMT3DPointInitConcLayerType.Create(self, -1);
    ModflowTypes.GetMT3DAreaInitConcLayerType.Create(self, -1);
    if frmMODFLOW.cbSSM.Checked then
    begin
//      ModflowTypes.GetMT3DPointConstantConcLayerType.Create(self, -1);
//      ModflowTypes.GetMT3DAreaConstantConcLayerType.Create(self, -1);
      if frmMODFLOW.cbMT3D_TVC.Checked then
      begin
//        ModflowTypes.GetMT3DPointTimeVaryConcLayerType.Create(self, -1);
        ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.Create(self, -1);
      end;
      if frmMODFLOW.cbMT3DMassFlux.Checked then
      begin
        ModflowTypes.GetMT3DMassFluxLayerType.Create(self, -1);
      end;

    end;
    if frmMODFLOW.cbRCT.Checked then
    begin
      if (frmMODFLOW.comboMT3DIsotherm.ItemIndex > 0)
        and (frmMODFLOW.comboMT3DIsotherm.ItemIndex <> 5)
        and not frmMODFLOW.cbMT3D_OneDArrays.Checked then
      begin
        ModflowTypes.GetMT3DBulkDensityLayerType.Create(self, -1);
      end;
      if (frmMODFLOW.comboMT3DIsotherm.ItemIndex > 0)
        and not frmMODFLOW.cbMT3D_OneDArrays.Checked then
      begin
        ModflowTypes.GetMT3DSorptionLayerType.Create(self, -1);
      end;
      if (frmMODFLOW.comboMT3DIREACT.ItemIndex > 0)
        and not frmMODFLOW.cbMT3D_OneDArrays.Checked then
      begin
        ModflowTypes.GetMT3DReactionLayerType.Create(self, -1);
      end;
    end;
    if frmMODFLOW.cbDSP.Checked then
    begin
      if frmMODFLOW.cbMt3dMultiDiffusion.Checked then
      begin
        ModflowTypes.GetMFMT3DMolecularDiffusionLayerType.Create(self, -1);
      end;
    end;
  end;

  if ModflowTypes.GetFluidDensityLayerType.LayerUsed then
  begin
    ModflowTypes.GetFluidDensityLayerType.Create(self, -1);
  end;
  if ModflowTypes.GetMFViscosityLayerType.LayerUsed then
  begin
    ModflowTypes.GetMFViscosityLayerType.Create(self, -1);
  end;
end;



constructor TMFLayerStructure.Create;
var
  GeolUnitIndex : integer;
  NumberOfUnits : integer;
begin
  inherited Create;

  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFDomainOutType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMT3DDomOutlineLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetDensityLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetGridLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetRechargeLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCRechargeConcLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetETLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFSegmentedETLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFReservoirLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFMNW_LayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFMNW2_VerticalWellLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFMNW2_GeneralWellLayerType.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFDrainReturnLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFHUF_ReferenceSurfaceLayerClassType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCObsWellLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMapLayerType.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMF_SWT_GroupLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFGeostaticStressLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFSpecificGravityLayerType.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFUzfGroupLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFUzfLayerLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFUzfStreamLakeLayerType.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMFUzfOutputLayerType.ANE_LayerName);

  UnIndexedLayers3.LayerOrder.Add(ModflowTypes.GetMFLakeGroupLayerType.ANE_LayerName);
  UnIndexedLayers3.LayerOrder.Add(ModflowTypes.GetMFLakeLayerType.ANE_LayerName);
  UnIndexedLayers3.LayerOrder.Add(ModflowTypes.GetMFLakeBottomLayerType.ANE_LayerName);

  ModflowTypes.GetLakeLeakanceListType.Create(FirstListsOfIndexedLayers, -1); // 0
  ModflowTypes.GetMultiplierListType.Create(FirstListsOfIndexedLayers, -1); // 1
  ModflowTypes.GetZoneListType.Create(FirstListsOfIndexedLayers, -1); // 2
  ModflowTypes.GetObservationGroupListType.Create(FirstListsOfIndexedLayers, -1); // 3
  ModflowTypes.GetObservationListType.Create(FirstListsOfIndexedLayers, -1); // 4
  ModflowTypes.GetWeightedObservationListType.Create(FirstListsOfIndexedLayers, -1); // 5
  ModflowTypes.GetGHBFluxObsListType.Create(FirstListsOfIndexedLayers, -1); // 6
  ModflowTypes.GetDrainFluxObsListType.Create(FirstListsOfIndexedLayers, -1); // 7
  ModflowTypes.GetDrainReturnFluxObsListType.Create(FirstListsOfIndexedLayers, -1); // 8
  ModflowTypes.GetRiverFluxObsListType.Create(FirstListsOfIndexedLayers, -1); // 9
  ModflowTypes.GetSpecifiedHeadFluxObsListType.Create(FirstListsOfIndexedLayers, -1); // 10
  ModflowTypes.GetAdvectionStartingObsListType.Create(FirstListsOfIndexedLayers, -1); // 11
  ModflowTypes.GetAdvectionObservationListType.Create(FirstListsOfIndexedLayers, -1); // 12
  ModflowTypes.GetWeightedConcentrationListType.Create(FirstListsOfIndexedLayers, -1); // 12

  ModflowTypes.GetMFDomainOutType.Create(UnIndexedLayers, -1);
  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetMT3DDomOutlineLayerType.Create(UnIndexedLayers, -1);
  end;
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
  if frmMODFLOW.cbRCH.Checked and (frmMODFLOW.cbMOC3D.Checked or
    (frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked)) then
  begin
    ModflowTypes.GetMOCRechargeConcLayerType.Create( UnIndexedLayers, -1);
  end;
  if frmMODFLOW.cbEVT.Checked then
  begin
    ModflowTypes.GetETLayerType.Create( UnIndexedLayers, -1);
  end;
  if frmMODFLOW.cbETS.Checked then
  begin
    ModflowTypes.GetMFSegmentedETLayerType.Create( UnIndexedLayers, -1);
  end;

  if frmMODFLOW.cbRES.Checked then
  begin
    ModflowTypes.GetMFReservoirLayerType.Create( UnIndexedLayers, -1);
  end;

  if (frmMODFLOW.rgFlowPackage.ItemIndex = 2) and
    frmMODFLOW.cbHUF_ReferenceSurface.Checked then
  begin
    ModflowTypes.GetMFHUF_ReferenceSurfaceLayerClassType.Create( UnIndexedLayers, -1);
  end;

  if frmMODFLOW.cbSWT.Checked then
  begin
    ModflowTypes.GetMF_SWT_GroupLayerType.Create( UnIndexedLayers, -1);
    ModflowTypes.GetMFGeostaticStressLayerType.Create( UnIndexedLayers, -1);
    ModflowTypes.GetMFSpecificGravityLayerType.Create( UnIndexedLayers, -1);
  end;


  if frmMODFLOW.cbUZF.Checked then
  begin
    ModflowTypes.GetMFUzfGroupLayerType.Create( UnIndexedLayers, -1);
    ModflowTypes.GetMFUzfFlowLayerType.Create( UnIndexedLayers, -1);
    ModflowTypes.GetMFUzfLayerLayerType.Create( UnIndexedLayers, -1);
    if frmMODFLOW.cbUzfIRUNFLG.Checked and
      (frmMODFLOW.cbLAK.Checked or frmMODFLOW.cbSFR.Checked) then
    begin
      ModflowTypes.GetMFUzfStreamLakeLayerType.Create( UnIndexedLayers, -1);
    end;
    ModflowTypes.GetMFUzfOutputLayerType.Create( UnIndexedLayers, -1);
  end;


  if frmMODFLOW.cbLAK.Checked then
  begin
    ModflowTypes.GetMFLakeGroupLayerType.Create( UnIndexedLayers3, -1);
    ModflowTypes.GetMFLakeLayerType.Create( UnIndexedLayers3, -1);
    ModflowTypes.GetMFLakeBottomLayerType.Create( UnIndexedLayers3, -1);
  end;

  if frmMODFLOW.cbMNW.Checked then
  begin
    ModflowTypes.GetMFMNW_LayerType.Create( UnIndexedLayers, -1);
  end;

  if frmMODFLOW.cbMnw2.Checked  then
  begin
    if frmMODFLOW.rgMnw2WellType.ItemIndex in [0,2] then
    begin
      ModflowTypes.GetMFMNW2_VerticalWellLayerType.Create( UnIndexedLayers, -1);
    end;
    if frmMODFLOW.rgMnw2WellType.ItemIndex in [1,2] then
    begin
      ModflowTypes.GetMFMNW2_GeneralWellLayerType.Create( UnIndexedLayers, -1);
    end;
  end;

  if frmMODFLOW.cbDRT.Checked then
  begin
    ModflowTypes.GetMFDrainReturnLayerType.Create( UnIndexedLayers, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMOCObsWellLayerType.Create( UnIndexedLayers, -1);
  end;
  ModflowTypes.GetMapLayerType.Create( UnIndexedLayers, -1);

  if ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used then
  begin
    ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Create
      (UnIndexedLayers, -1);
  end;
  if ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used then
  begin
    ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Create
      (UnIndexedLayers, -1);
  end;

  if frmModflow.rgFlowPackage.ItemIndex = 2 then
  begin
    ModflowTypes.GetMFHUFGroupLayerType.Create( UnIndexedLayers2, -1);
  end;

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
