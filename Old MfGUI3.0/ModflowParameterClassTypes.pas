unit ModflowParameterClassTypes;

interface

{ModflowParameterClassTypes defines meta-classes of classes of parameters. These
 metaclasses are used in GetTypesUnit.}

uses MFPrescribedHead, MFBottom, MFDomainOut,
     MFDrain, MFEvapo, MFGenHeadBound, MFGrid, MFGridDensity, MFHydraulicCond,
     MFInactive, MFInitialHead, MFMOCInitConc, MFMOCObsWell,
     MFMOCParticleRegen, MFMOCPorosity, MFRecharge, MFRechConc, MFRiver,
     MFSpecStor, MFSpecYield, MFTop, MFWells, MFWetting,
     MFStreamUnit, MFHorFlowBarrier, MFFlowAndHeadBound, MFMODPATHUnit,
     MFZoneBud, MFModPathZone, MFGenParam, MFModPathPost, MFMOCTransSubgrid,
     MFTransmissivity, MFVcont, MFConfStorage, MFMOCImPor, MFMOCLinExch,
     MFMOCDecay, MFMOCGrowth, MFMOCImInitConc, MFMOCRetardation, MFMOCDisDecay,
     MFMOCSorbDecay, MFMOCDisGrowth, MFMOCSorbGrowth;

type
  TMFBottomElevParamClass = class of TBottomElevParam;
  TMFDomDensityParamClass = class of TDomDensityParam;
  TMFDrainElevationParamClass = class of TDrainElevationParam;
  TMFDrainOnParamClass = class of TDrainOnParam;
  TMFETSurfaceParamClass = class of TETSurface;
  TMFETExtDepthParamClass = class of TETExtDepth;
  TMFETExtFluxParamClass = class of TETExtFlux;
  TMFFHBPointAreaHeadParamClass = class of TFHBPointAreaHeadParam;
  TMFFHBPointFluxParamClass = class of TFHBPointFluxParam;
  TMFFHBTopElevParamClass = class of TFHBTopElevParam;
  TMFFHBBotElevParamClass = class of TFHBBotElevParam;
  TMFHBHeadConcParamClass = class of TFHBHeadConcParam;
  TMFHBFluxConcParamClass = class of TFHBFluxConcParam;
  TMFHBLineHeadStartParamClass = class of TFHBLineHeadStartParam;
  TMFHBLineHeadEndParamClass = class of TFHBLineHeadEndParam;
  TMFHBLineFluxParamClass = class of TFHBLineFluxParam;
  TMFHBAreaFluxParamClass = class of TFHBAreaFluxParam;
  TMFGHBHeadParamClass = class of TGHBHeadParam;
  TMFConcentrationParamClass = class of TConcentration;
  TMFConductanceParamClass = class of TConductance;
  TMFIFACEParamClass = class of TIFACEParam;
  TMFGridETSurfParamClass = class of TGridETSurf;
  TMFGridRechElevParamClass = class of TGridRechElev;
  TMFIBoundGridParamClass = class of TIBoundGridParam;
  TMFGridTopElevParamClass = class of TGridTopElev;
  TMFGridBottomElevParamClass = class of TGridBottomElev;
  TMFGridThicknessParamClass = class of TGridThickness;
  TMFGridInitialHeadParamClass = class of TGridInitialHead;
  TMFGridKxParamClass = class of TGridKx;
  TMFGridKzParamClass = class of TGridKz;
  TMFGridSpecYieldParamClass = class of TGridSpecYield;
  TMFGridSpecStorParamClass = class of TGridSpecStor;
  TMFGridWettingParamClass = class of TGridWetting;
  TMFGridWellParamClass = class of TGridWell;
  TMFGridRiverParamClass = class of TGridRiver;
  TMFGridDrainParamClass = class of TGridDrain;
  TMFGridGHBParamClass = class of TGridGHB;
  TMFGridFHBParamClass = class of TGridFHB;
  TMGridHFBParamClass = class of TGridHFB;
  TMFGridStreamParamClass = class of TGridStream;
  TMFGridMOCInitConcParamClass = class of TGridMOCInitConc;
  TMFGridMOCSubGridParamClass = class of TGridMOCSubGrid;
  TMFGridMOCParticleRegenParamClass = class of TGridMOCParticleRegen;
  TMFGridMOCPorosityParamClass = class of TGridMOCPorosity;
  TMFGridZoneBudgetParamClass = class of TGridZoneBudget;
  TMFGridModpathZoneParamClass = class of TGridModpathZone;
  TMFDensityParamClass = class of TDensityParam;
  TMFHFBHydCondParamClass = class of THFBHydCondParam;
  TMFHFBBarrierThickParamClass = class of THFBBarrierThickParam;
  TMFKxParamClass = class of TKx;
  TMFKzParamClass = class of TKz;
  TMFInactiveParamClass = class of TInactiveParam;
  TMFInitialHeadParamClass = class of TInitialHeadParam;
  TMFMOCInitialConcParamClass = class of TMOCInitialConcParam;
  TMFMOCObsElevParamClass = class of TMOCObsElev;
  TMFMOCParticleRegenParamClass = class of TMOCParticleRegenParam;
  TMFMOCPorosityParamClass = class of TMOCPorosityParam;
{  TMFModpathTime1ParamClass = class of TModpathTime1Param;
  TMFModpathTime2ParamClass = class of TModpathTime2Param;
  TMFModpathTime3ParamClass = class of TModpathTime3Param;
  TMFModpathTime4ParamClass = class of TModpathTime4Param;
  TMFModpathTime5ParamClass = class of TModpathTime5Param; }
  TMFModpathZoneParamClass = class of TModpathZoneParam;
  TMFPrescribedHeadParamClass = class of TPrescribedHeadParam;
  TMFRechElevParamClass = class of TRechElevParam;
  TMFRechStressParamClass = class of TRechStressParam;
  TMFRechConcParamClass = class of TRechConcParam;
  TMFRiverBottomParamClass = class of TRiverBottomParam;
  TMFRiverStageParamClass = class of TRiverStageParam;
  TMFSpecStorageParamClass = class of TSpecStorageParam;
  TMFSpecYieldParamClass = class of TSpecYieldParam;
  TMFStreamSegNumParamClass = class of TStreamSegNum;
  TMFStreamDownSegNumParamClass = class of TStreamDownSegNum;
  TMFStreamDivSegNumParamClass = class of TStreamDivSegNum;
  TMFStreamHydCondParamClass = class of TStreamHydCondParam;
  TMFStreamFlowParamClass = class of TStreamFlow;
  TMFStreamUpStageParamClass = class of TStreamUpStage;
  TMFStreamDownStageParamClass = class of TStreamDownStage;
  TMFStreamUpBotElevParamClass = class of TStreamUpBotElev;
  TMFStreamDownBotElevParamClass = class of TStreamDownBotElev;
  TMFStreamUpTopElevParamClass = class of TStreamUpTopElev;
  TMFStreamDownTopElevParamClass = class of TStreamDownTopElev;
  TMFStreamUpWidthParamClass = class of TStreamUpWidthParam;
  TMFStreamDownWidthParamClass = class of TStreamDownWidthParam;
  TMFStreamSlopeParamClass = class of TStreamSlope;
  TMFStreamRoughParamClass = class of TStreamRough;
  TMFTopElevParamClass = class of TTopElevParam;
  TMFWellTopParamClass = class of TWellTopParam;
  TMFWellBottomParamClass = class of TWellBottomParam;
  TMFWellStressParamClass = class of TWellStressParam;
  TMFWettingThreshParamClass = class of TWettingThreshParam;
  TMFWettingFlagParamClass = class of TWettingFlagParam;
  TMFZoneBudZoneParamClass = class of TZoneBudZone;
  TMFMODPATH_XCountParamClass = class of TMODPATH_XCount_Param;
  TMFMODPATH_YCountParamClass = class of TMODPATH_YCount_Param;
  TMFMODPATH_ZCountParamClass = class of TMODPATH_ZCount_Param;
  TMFMODPATH_ReleaseTimeParamClass = class of TMODPATH_ReleaseTimeParam;
  TMFMODPATHPartIfaceParamClass = class of TMODPATHPartIface;
  TMFMODPATH_FirstLayerParamClass = class of TMODPATH_FirstLayerParam;
  TMFMODPATH_FirstTimeParamClass = class of TMODPATH_FirstTimeParam;
  TMFMODPATH_LastLayerParamClass = class of TMODPATH_LastLayerParam;
  TMFMODPATH_LastTimeParamClass = class of TMODPATH_LastTimeParam;
  TMFMOCTransSubGridParamClass = class of TMOCTransSubGridParam;
  TMFTransmisivityParamClass = class of TTransmisivityParam;
  TMFVcontParamClass = class of TVcontParam;
  TMFConfStorageParamClass = class of TConfStorageParam;
  TMFGridVContParamClass = class of TGridVCont;
  TMFGridConfStoreParamClass = class of TGridConfStor;
  TMFGridTransParamClass = class of TGridTrans;
  TMFModflowLayerParamClass = class of TModflowLayerParam;
  TMFGridRechLayerParamClass = class of TGridRechLayerParam;
  TMFGridETLayerParamClass = class of TGridETLayerParam;
  TMFMOCImPorosityParamClass = class of TMOCImPorosityParam;
  TMFMOCLinExchCoefParamClass = class of TMOCLinExchCoefParam;
  TMFMOCDecayCoefParamClass = class of TMOCDecayCoefParam;
  TMFMOCGrowthParamClass = class of TMOCGrowthParam;
  TMFMOCImInitConcParamClass = class of TMOCImInitConcParam;
  TMFMOCRetardationParamClass = class of TMOCRetardationParam;
  TMFMOCDisDecayCoefParamClass = class of TMOCDisDecayCoefParam;
  TMFMOCSorbDecayCoefParamClass = class of TMOCSorbDecayCoefParam;
  TMFMOCDisGrowthParamClass = class of TMOCDisGrowthParam;
  TMFMOCSorbGrowthParamClass = class of TMOCSorbGrowthParam;

  TMFMODPATH_StartingZoneParamClass = class of TMODPATH_StartingZoneParam;
  TMFMODPATH_EndingZoneParamClass = class of TMODPATH_EndingZoneParam;

implementation

end.
