unit ModflowParameterListClassTypes;

interface

{ModflowLayerClassTypes defines meta-classes of classes of parameterlists. These
 metaclasses are used in GetTypesUnit.}

uses ModflowUnit,      MFLayerStructureUnit, ModflowLayerClassTypes,
     MFPrescribedHead, MFBottom, MFDomainOut,
     MFDrain, MFEvapo, MFGenHeadBound, MFGrid, MFGridDensity, MFHydraulicCond,
     MFInactive, MFInitialHead, MFMap, MFMOCInitConc, MFMOCObsWell,
     MFMOCParticleRegen, MFMOCPorosity, MFRecharge, MFRechConc, MFRiver,
     MFSpecStor, MFSpecYield, MFTop, MFWells, MFWetting, MFGroupLayerUnit,
     MFStreamUnit, MFHorFlowBarrier, MFFlowAndHeadBound, MFMODPATHUnit,
     MFZoneBud, MFModPathZone, MFMOCLinExch, MFMOCDecay, MFMOCGrowth,
     MFMOCDisDecay, MFMOCSorbDecay, MFMOCDisGrowth, MFMOCSorbGrowth;

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

implementation

end.
