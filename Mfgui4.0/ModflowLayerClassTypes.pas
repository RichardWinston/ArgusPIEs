unit ModflowLayerClassTypes;

interface

{ModflowLayerClassTypes defines meta-classes of classes of layers. These
 metaclasses are used in GetTypesUnit.}

uses MFPrescribedHead, MFBottom, MFDomainOut, MFMOC_ParticleObservations,
     MFDrain, MFEvapo, MFGenHeadBound, MFGrid, MFGridDensity, MFHydraulicCond,
     MFInactive, MFInitialHead, MFMap, MFMOCInitConc, MFMOCObsWell,
     MFMOCParticleRegen, MFMOCPorosity, MFRecharge, MFRechConc, MFRiver,
     MFSpecStor, MFSpecYield, MFTop, MFWells, MFWetting, MFGroupLayerUnit,
     MFStreamUnit, MFHorFlowBarrier, MFFlowAndHeadBound, MFMODPATHUnit,
     MFZoneBud, MFModPathZone, MFModPathPost, MFMOCTransSubgrid,
     MFTransmissivity, MFVcont, MFConfStorage, MFMOCImPor, MFMOCLinExch,
     MFMOCDecay, MFMOCGrowth, MFMOCImInitConc, MFMOCRetardation, MFMOCDisDecay,
     MFMOCSorbDecay, MFMOCDisGrowth, MFMOCSorbGrowth, MFMultiplierUnit,
     MFZoneUnit, MFAnisotropy, MFHeadObservations, MFFluxObservationUnit,
     MFAdvectObservUnit, MFLakes, MFInterbedUnit, MFReservoir, MFSegEvap,
     MFDrainReturn, MF_HYDMOD_Unit, MFCHD, MF_HUF, MF_MNW, MF_DAFLOW,
     MF_HUF_RefSurf, MFSubsidence, MFDensity, MFMOCInitialParticles,
     MF_GWT_CBDY, MF_GWM_Flux, MF_GWM_HeadConstraint, MF_GWM_DrawdownConstraint,
     MF_GWM_HeadDifference, MF_GWM_Gradient, MF_GWM_StreamFlow,
     MF_GWM_StreamDepletion, MFUnsaturatedZoneFlow, MF_SWT, MF_SW_Viscosity,
     MfMt3dConcentrationObservationUnit, MF_MNW2, MF_GWM_StateVariables,
  MFMOCConstConc, MFMOC_VolumeBalancing;

type
  TMFGeolUnitGroupLayerClass = class of TMFGeolUnitGroupLayer;
  TBottomElevLayerClass = class of TBottomElevLayer;
  TMFDomainOutLayerClass = class of TMFDomainOut;
  TMFLineDrainLayerClass = class of TLineDrainLayer;
  TMFAreaDrainLayerClass = class of TAreaDrainLayer;
  TMFETLayerClass = class of TETLayer;
  TMFPointGHBLayerClass = class of TPointGHBLayer;
  TMFLineGHBLayerClass = class of TLineGHBLayer;
  TMFAreaGHBLayerClass = class of TAreaGHBLayer;
  TMFGridLayerClass = class of TMFGridLayer;
  TMFDensityLayerClass = class of TMFDensityLayer;
  TMFHydraulicCondLayerClass = class of THydraulicCondLayer;
  TMFInactiveLayerClass = class of TInactiveLayer;
  TMFInitialHeadLayerClass = class of TInitialHeadLayer;
  TMFMapLayerClass = class of TMFMapLayer;
  TMOCInitialConcLayerClass = class of TMOCInitialConcLayer;
  TMOCObsWellLayerClass = class of TMOCObsWellLayer;
  TMOCParticleRegenLayerClass = class of TMOCParticleRegenLayer;
  TMOCPorosityLayerClass = class of TMOCPorosityLayer;
  TMFPrescribedHeadLayerClass = class of TPrescribedHeadLayer;
  TMFRechargeLayerClass = class of TRechargeLayer;
  TMOCRechargeConcLayerClass = class of TMOCRechargeConcLayer;
  TMFLineRiverLayerClass = class of TLineRiverLayer;
  TMFAreaRiverLayerClass = class of TAreaRiverLayer;
  TMFSpecStorageLayerClass = class of TSpecStorageLayer;
  TMFSpecYieldLayerClass = class of TSpecYieldLayer;
  TMFTopElevLayerClass = class of TTopElevLayer;
  TMFWellLayerClass = class of TWellLayer;
  TMFWettingLayerClass = class of TWettingLayer;
  TMFStreamLayerClass = class of TStreamLayer;
  TMFHFBLayerClass = class of THFBLayer;
  TMFPointFHBLayerClass = class of TPointFHBLayer;
  TMFLineFHBLayerClass = class of TLineFHBLayer;
  TMFAreaFHBLayerClass = class of TAreaFHBLayer;
  TMODPATHLayerClass = class of TMODPATHLayer;
  TMODPATHZoneLayerClass = class of TModpathZoneLayer;
  TZoneBudLayerClass = class of TZoneBudLayer;
  TMODPATHPostLayerClass = class of TMODPATHPostLayer;
  TMOCTransSubGridLayerClass = class of TMOCTransSubGridLayer;
  TMFPostProcessingGroupLayerClass = class of TMFPostProcessingGroupLayer;
  TMFTransmisivityLayerClass = class of TTransmisivityLayer;
  TMFVcontLayerClass = class of TVcontLayer;
  TMFConfStorageLayerClass = class of TConfStorageLayer;
  TMFMOCImPorosityLayerClass = class of TMOCImPorosityLayer;
  TMFMOCLinExchCoefLayerClass = class of TMOCLinExchCoefLayer;
  TMFMOCDecayCoefLayerClass = class of TMOCDecayCoefLayer;
  TMFMOCGrowthLayerClass = class of TMOCGrowthLayer;
  TMFMOCImInitConcLayerClass = class of TMOCImInitConcLayer;
  TMFMOCRetardationLayerClass = class of TMOCRetardationLayer;
  TMFMOCDisDecayCoefLayerClass = class of TMOCDisDecayCoefLayer;
  TMFMOCSorbDecayCoefLayerClass = class of TMOCSorbDecayCoefLayer;
  TMFMOCDisGrowthLayerClass = class of TMOCDisGrowthLayer;
  TMFMOCSorbGrowthLayerClass = class of TMOCSorbGrowthLayer;
  TMFMODPATHPostEndLayerClass = class of TMODPATHPostEndLayer;
  TMFPointDrainLayerClass = class of TPointDrainLayer;
  TMFPointRiverLayerClass = class of TPointRiverLayer;
  TMFMultiplierLayerClass = class of TMultiplierLayer;
  TMFMultiplierGroupLayerClass = class of TMultiplierGroupLayer;
  TMFZoneLayerClass = class of TZoneLayer;
  TMFZoneGroupLayerClass = class of TZoneGroupLayer;
  TMFAnistropyLayerClass = class of TAnistropyLayer;
  TMFLineWellLayerClass = class of TLineWellLayer;
  TMFAreaWellLayerClass = class of TAreaWellLayer;
  TMFHeadObservationsLayerClass = class of THeadObservationsLayer;
  TMFWeightedHeadObservationsLayerClass = class of TWeightedHeadObservationsLayer;
  TMFObservationsGroupLayerClass = class of TObservationsGroupLayer;
  TMFCustomFluxObservationsLayerClass = class of TCustomFluxObservationsLayer;
  TMFGHBFluxObservationsLayerClass = class of TGHBFluxObservationsLayer;
  TMFDrainFluxObservationsLayerClass = class of TDrainFluxObservationsLayer;
  TMFRiverFluxObservationsLayerClass = class of TRiverFluxObservationsLayer;
  TMFSpecifiedHeadFluxObservationsLayerClass = class of TSpecifiedHeadFluxObservationsLayer;
  TMFAdvectionObservationsStartingLayerClass = class of TAdvectionObservationsStartingLayer;
  TMFAdvectionObservationsLayerClass = class of TAdvectionObservationsLayer;
  TMFLakeLayerClass = class of TLakeLayer;
  TMFLakeBottomLayerClass = class of TLakeBottomLayer;
  TMFLakeLeakanceLayerClass = class of TLakeLeakanceLayer;
  TMFIBSLayerClass = class of TIBSLayer;
  TMFReservoirLayerClass = class of TReservoirLayer;
  TMF2KCustomUnsatStreamLayerClass = class of TCustomUnsatStreamLayer;
  TMF2KCustomSatStreamLayerClass = class of TCustomSatStreamLayer;

  TMF2KSimpleStreamLayerClass = class of TMF2KSimpleStreamLayer;
  TMF2K8PointChannelStreamLayerClass = class of TMF2K8PointChannelStreamLayer;
  TMF2KFormulaStreamLayerClass = class of TMF2KFormulaStreamLayer;
  TMF2KTableStreamLayerClass = class of TMF2KTableStreamLayer;
  TMFSegmentedETLayerClass = class of TSegmentedETLayer;
  TMFLineDrainReturnLayerClass = class of TLineDrainReturnLayer;
  TMFAreaDrainReturnLayerClass = class of TAreaDrainReturnLayer;
  TMFPointDrainReturnLayerClass = class of TPointDrainReturnLayer;
  TMFDrainReturnLayerClass = class of TDrainReturnLayer;
  TMFDrainReturnFluxObservationsLayerClass = class of TDrainReturnFluxObservationsLayer;
  TMFHydmodLayerClass = class of THydmodLayer;
  TMFPointLineCHD_LayerClass = class of TPointLineCHD_Layer;
  TMFAreaCHD_LayerClass = class of TAreaCHD_Layer;
  TMFHUF_LayerClass = class of THUFLayer;
  TMFHufGroupLayerClass = class of TMFHufGroupLayer;
  TMFLakeGroupLayerClass = class of TLakeGroupLayer;
  TMFMNW_LayerClass = class of TMNW_Layer;
  TMFMNW_WaterQualityLayerClass = class of TMNW_WaterQualityLayer;
  TMFDaflowLayerClass = class of TDaflowLayer;
  TMFHUF_ReferenceSurfaceLayerClass = class of THUF_ReferenceSurfaceLayer;
  TMFNoDelaySubsidenceLayerClass = class of TNoDelaySubsidenceLayer;
  TMFDelaySubsidenceLayerClass = class of TDelaySubsidenceLayer;
  TMFFluidDensityLayerClass = class of TFluidDensityLayer;
  TMFMOCInitialParticlePlacementLayerClass = class of TMOCInitialParticlePlacementLayer;

  TMFMOCUpperBoundaryConcentrationLayerClass = class of TUpperBoundaryConcentrationLayer;
  TMFMOCLowerBoundaryConcentrationLayerClass = class of TLowerBoundaryConcentrationLayer;
  TMFFluxVariableLayerClass = class of TFluxVariableLayer;
  TMFHeadConstraintLayerClass = class of THeadConstraintLayer;
  TMFDrawdownConstraintLayerClass = class of TDrawdownConstraintLayer;
  TMFHeadDifferenceLayerClass = class of THeadDifferenceLayer;
  TMFGradientLayerClass = class of TGradientLayer;
  TMFStreamConstraintLayerClass = class of TStreamConstraintLayer;
  TMFStreamDepletionConstraintLayerClass = class of TStreamDepletionConstraintLayer;
  TMFMoc3dParticleObsLayerClass = class of TMoc3dParticleObsLayer;
  TMFLateralBoundaryConcentrationLayerClass = class of TLateralBoundaryConcentrationLayer;

  TMFUzfFlowLayerClass = class of TUzfFlowLayer;
  TMFUzfLayerLayerClass = class of TUzfLayer;
  TMFUzfStreamLakeLayerClass = class of TUzfStreamLakeLayer;
  TMFUzfOutputLayerClass = class of TUzfOutputLayer;
  TMFUzfGroupLayerClass = class of TUzfGroupLayer;

  TMFSWT_GroupLayerClass = class of T_SWT_Group;
  TMFGeostaticStressLayerClass = class of TGeostaticStressLayer;
  TMFSpecificGravityLayerClass = class of TSpecificGravityLayer;
  TMFSwtUnitLayerClass = class of TSwtUnitLayer;

  TMFWeightedConcentrationObservationsLayerClass = class of TWeightedConcentrationObservationsLayer;
  TMFViscosityLayerClass = class of TViscosityLayer;

  TMFMNW2_VerticalWellLayerClass = class of TMNW2_VerticalWellLayer;
  TMFMNW2_GeneralWellLayerClass = class of TMNW2_GeneralWellLayer;

  TMFGwmHeadStateLayerClass = class of TGwmHeadStateLayer;
  TMFGwmStreamStateLayerClass = class of TGwmStreamStateLayer;
  TMFGwmStorageStateLayerClass = class of TGwmStorageStateLayer;
  TGWT_TimeVaryConcLayerClass = class of TGWT_TimeVaryConcLayer;
  TGWT_VolumeBalancingLayerClass = class of TGWT_VolumeBalancingLayer;

implementation

end.
