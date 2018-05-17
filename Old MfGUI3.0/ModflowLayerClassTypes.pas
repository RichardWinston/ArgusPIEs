unit ModflowLayerClassTypes;

interface

{ModflowLayerClassTypes defines meta-classes of classes of layers. These
 metaclasses are used in GetTypesUnit.}

uses MFPrescribedHead, MFBottom, MFDomainOut,
     MFDrain, MFEvapo, MFGenHeadBound, MFGrid, MFGridDensity, MFHydraulicCond,
     MFInactive, MFInitialHead, MFMap, MFMOCInitConc, MFMOCObsWell,
     MFMOCParticleRegen, MFMOCPorosity, MFRecharge, MFRechConc, MFRiver,
     MFSpecStor, MFSpecYield, MFTop, MFWells, MFWetting, MFGroupLayerUnit,
     MFStreamUnit, MFHorFlowBarrier, MFFlowAndHeadBound, MFMODPATHUnit,
     MFZoneBud, MFModPathZone, MFModPathPost, MFMOCTransSubgrid,
     MFTransmissivity, MFVcont, MFConfStorage, MFMOCImPor, MFMOCLinExch,
     MFMOCDecay, MFMOCGrowth, MFMOCImInitConc, MFMOCRetardation, MFMOCDisDecay,
     MFMOCSorbDecay, MFMOCDisGrowth, MFMOCSorbGrowth;

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

implementation

end.
