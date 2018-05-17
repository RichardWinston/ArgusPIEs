unit ModflowParameterListClassTypes;

interface

{ModflowLayerClassTypes defines meta-classes of classes of parameterlists. These
 metaclasses are used in GetTypesUnit.}

uses ModflowUnit, MFLayerStructureUnit, ModflowLayerClassTypes,
     MFPrescribedHead, MFBottom, MFDomainOut,
     MFDrain, MFEvapo, MFGenHeadBound, MFGrid, MFGridDensity, MFHydraulicCond,
     MFInactive, MFInitialHead, MFMap, MFMOCInitConc, MFMOCObsWell,
     MFMOCParticleRegen, MFMOCPorosity, MFRecharge, MFRechConc, MFRiver,
     MFSpecStor, MFSpecYield, MFTop, MFWells, MFWetting, MFGroupLayerUnit,
     MFStreamUnit, MFHorFlowBarrier, MFFlowAndHeadBound, MFMODPATHUnit,
     MFZoneBud, MFModPathZone, MFMOCLinExch, MFMOCDecay, MFMOCGrowth,
     MFMOCDisDecay, MFMOCSorbDecay, MFMOCDisGrowth, MFMOCSorbGrowth,
     MFHeadObservations, MFFluxObservationUnit, MFLakes, MFReservoir, MFSegEvap,
     MFDrainReturn, MFCHD, MF_MNW, MF_DAFLOW, MFSubsidence, MFDensity,
     MF_GWM_Flux, MFGenParam, MFUnsaturatedZoneFlow, MF_SWT,
     MfMt3dConcentrationObservationUnit, MF_SW_Viscosity, MF_MNW2,
  MF_GWM_StateVariables, MFMOCConstConc;

type
  TMFDrainTimeParamListClass = class of TDrainTimeParamList;
  TMFETTimeParamListClass = class of TETTimeParamList;
  TMFGHBTimeParamListClass = class of TGHBTimeParamList;
  TMFGeologicUnitParametersClass = class of TGeologicUnitParameters;
  TMOCElevParamListClass = class of TMOCElevParamList;
  TMFRechargeTimeParamListClass = class of TRechargeTimeParamList;
  TMOCRechargeConcTimeParamListClass = class of TRechargeConcTimeParamList;
  TMFRiverTimeParamListClass = class of TRiverTimeParamList;
  TMFWellTimeParamListClass = class of TWellTimeParamList;
  TMFStreamTimeParamListClass = class of TStreamTimeParamList;
  TMFFHBPointTimeParamListClass = class of TFHBPointTimeParamList;
  TMFFHBLineTimeParamListClass = class of TFHBLineTimeParamList;
  TMFFHBAreaTimeParamListClass = class of TFHBAreaTimeParamList;
  TMFMODPATHTimeParamListClass = class of TMODPATHTimeParamList;
  TMFMOCLinExchCoefTimeParamListClass = class of TMOCLinExchCoefParamList;
  TMFMOCDecayCoefTimeParamListClass = class of TMOCDecayCoefParamList;
  TMFMOCGrowthTimeParamListClass = class of TMOCGrowthParamList;
  TMFMOCDisDecayCoefTimeParamListClass = class of TMOCDisDecayCoefParamList;
  TMFMOCSorbDecayCoefTimeParamListClass = class of TMOCSorbDecayCoefParamList;
  TMFMOCDisGrowthTimeParamListClass = class of TMOCDisGrowthParamList;
  TMFMOCSorbGrowthTimeParamListClass = class of TMOCSorbGrowthParamList;
  TMFMultiplierParamListClass = class of TMultiplierParameters;
  TMFZoneParamListClass = class of TZoneParameters;
  TMFLineAreaWellTimeParamListClass = class of TLineAreaWellTimeParamList;
  TMFHeadObservationParamListClass = class of THeadObservationParamList;
  TMFWeightParamListClass = class of TWeightParamList;
  TMFGHBFluxObservationParamListClass = class of TGHBFluxObservationParamList;
  TMFDrainFluxObservationParamListClass = class of TDrainFluxObservationParamList;
  TMFRiverFluxObservationParamListClass = class of TRiverFluxObservationParamList;
  TMFSpecifiedHeadFluxObservationParamListClass = class of TSpecifiedHeadFluxObservationParamList;
  TMFLakeTimeParamListClass = class of TLakeTimeParamList;
  TMFReservoirTimeParamListClass = class of TReservoirTimeParamList;
  TMF2KSimpleStreamTimeParamListClass = class of TMF2KSimpleStreamTimeParamList;
  TMF2K8PointChannelStreamTimeParamListClass = class of TMF2K8PointChannelStreamTimeParamList;
  TMF2KTableStreamTimeParamListClass = class of TMF2KTableStreamTimeParamList;
  TMF2KStreamCrossSectionParamListClass = class of TMF2KStreamCrossSectionParamList;
  TMF2KStreamTableParamListClass = class of TMF2KStreamTableParamList;
  TMF2KStreamFormulaTimeParamListClass = class of TMF2KStreamFormulaTimeParamList;
  TMFStreamObservationParamListClass = class of TStreamObservationParamList;
  TMFSegET_IntermediateDepthsParamListClass = class of TSegET_IntermediateDepthsParamList;
  TMFSegETTimeParamListClass = class of TSegETTimeParamList;
  TMFDrainReturnTimeParamListClass = class of TDrainReturnTimeParamList;
  TMFDrainReturnFluxObservationParamListClass = class of TDrainReturnFluxObservationParamList;
  TMFCHD_TimeParamListClass = class of TCHD_TimeParamList;
  TMFFHBMT3DConcTimeParamListClass = class of TFHBMT3DConcTimeParamList;
  TMFMNW_TimeParamListClass = class of TMNW_TimeParamList;
  TMFMNW_WaterQualityTimeParamListClass = class of TMNW_WaterQualityTimeParamList;
  TMFDaflowTimeParamListClass = class of TDaflowTimeParamList;
  TMFNoDelayIndexedParamListClass = class of TNoDelayIndexedParamList;
  TMFDelayIndexedParamListClass = class of TDelayIndexedParamList;
  TMFFluidDensityTimeParamListClass = class of TFluidDensityTimeParamList;

  TMFGWM_TimeParamListClass = class of TGWM_TimeParamList;
  TMFUzfTimeParamListClass = class of TUzfTimeParamList;
  TMFSwtIndexedParamListClass = class of TSwtIndexedParamList;

  TMFConcentrationObservationParamListClass = class of TConcentrationObservationParamList;
  TMFConcWeightParamListClass = class of TConcWeightParamList;
  TMFViscosityParamListClass = class of TViscosityParamList;

  TMFMNW2_WellScreenParamListClass = class of TMNW2_WellScreenParamList;
  TMFMNW2_TimeParamListClass = class of TMNW2_TimeParamList;

  TMFLeakConductanceParamListClass = class of TLeakConductanceTimeList;

  TMFGwmStressPeriodParamListClass = class of TGwmStressPeriodParamList;
  TGWT_TimeVaryConcTimeParamListClass = class of TGWT_TimeVaryConcTimeParamList;

implementation

end.
