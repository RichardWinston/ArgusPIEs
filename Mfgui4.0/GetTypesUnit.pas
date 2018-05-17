unit GetTypesUnit;

interface

{GetTypesUnit defines the class TModflowTypesClass which is used in the
 creation of layers, parameters, and other classes during execution of the
 PIE. Because all of the methods are virtual, they can be overridden in a
 descendent class to provide additional functionality. Customized versions
 of the PIE should use this mechanism when changing layer or parameter
 characteristics.}

uses ModflowLayerClassTypes, ModflowParameterClassTypes,
     ModflowParameterListClassTypes, ModflowUnit, MFLayerStructureUnit,
     MFPrescribedHead, MFBottom, MFDomainOut,
     MFDrain, MFEvapo, MFGenHeadBound, MFGrid, MFGridDensity, MFHydraulicCond,
     MFInactive, MFInitialHead, MFMap, MFMOCInitConc, MFMOCObsWell,
     MFMOCParticleRegen, MFMOCPorosity, MFRecharge, MFRechConc, MFRiver,
     MFSpecStor, MFSpecYield, MFTop, MFWells, MFWetting, MFGroupLayerUnit,
     MFStreamUnit, MFHorFlowBarrier, MFFlowAndHeadBound, MFMODPATHUnit,
     MFZoneBud, MFModPathZone, MFGenParam,
     RunUnit, PostMODFLOW, MFModPathPost, MFMOCTransSubgrid, SelectPostFile,
     MFTransmissivity, MFVcont, MFConfStorage, WellDataUnit, WarningsUnit,
     MFMOCImPor, MFMOCLinExch, MFMOCDecay, MFMOCGrowth, MFMOCImInitConc,
     MFMOCRetardation, MFMOCDisDecay, MFMOCSorbDecay, MFMOCDisGrowth,
     MFMOCSorbGrowth, MFMultiplierUnit, MFZoneUnit, MFAnisotropy,
     MFHeadObservations, MFFluxObservationUnit, MFAdvectObservUnit, MFLakes,
     MFInterbedUnit, MFReservoir, MFSegEvap, MFDrainReturn, MF_HYDMOD_Unit,
     MFCHD, MF_HUF, MT3DLayerClasses, MT3DParameterClasses, MT3DDomainOutline,
     MT3DInactiveLayer, MT3DObservations, MFMOC_ParticleObservations,
     MT3DTimeVaryConc, MT3DInitConc, MT3DPostProc,
     MT3DGeneralParameters, MT3DParameterListClasses, MT3DBulkDensity,
     MT3DSorption, MT3DReaction, MT3DMassFlux, MF_MNW, MF_DAFLOW,
     MF_HUF_RefSurf, MFSubsidence, MFDensity, MFMOCInitialParticles,
     MF_GWT_CBDY, MF_GWM_Flux, MF_GWM_HeadConstraint, MF_GWM_DrawdownConstraint,
     MF_GWM_HeadDifference, MF_GWM_Gradient, MF_GWM_StreamFlow,
     MF_GWM_StreamDepletion, MFUnsaturatedZoneFlow, Mt3dMolecularDiffusion,
     MF_SWT, MfMt3dConcentrationObservationUnit, MF_SW_Viscosity, MF_MNW2,
  MF_GWM_StateVariables, MFMOCConstConc, MFMOC_VolumeBalancing;

type
  TModflowFormClass = class of TfrmMODFLOW;
  TRunModflowClass = class of TfrmRun;
  TPostModflowClass = class of TfrmMODFLOWPostProcessing;
  TSelectPostFileClass = class of TfrmSelectPostFile;
  TWellDataFormClass = class of TfrmWellData;
  TWarningsFormClass = class of TfrmWarnings;

type
  TModflowLayerStructureClass = class of TMFLayerStructure;
  TMFGeologicUnitClass = class of TMFGeologicUnit;
  TMultiplierListClass = class of TMultiplierList;
  TZoneListClass = class of TZoneList;
  TObservationGroupListClass = class of TObservationGroupList;
  TObservationListClass = class of TObservationList;
  TWeightedObservationListClass = class of TWeightedObservationList;
  TGHBFluxObsListClass = class of TGHBFluxObsList;
  TDrainFluxObsListClass = class of TDrainFluxObsList;
  TDrainReturnFluxObsListClass = class of TDrainReturnFluxObsList;
  TRiverFluxObsListClass = class of TRiverFluxObsList;
  TSpecifiedHeadFluxObsListClass = class of TSpecifiedHeadFluxObsList;
  TAdvectionStartingObsListClass = class of TAdvectionStartingList;
  TAdvectionObservationListClass = class of TAdvectionObservationList;
  TLakeLeakanceListClass = class of TLakeLeakanceList;
  TWeightedConcentrationClass = class of TWeightedConcentrationList;

  // TModflowTypesClass is a class used to return class types used in creating
  // forms, layers, parameters, layerlists, etc. This gives it a central role
  // in the MODFLOW PIE. These functions may be overriden or replaced in
  // customized versions of the PIE. Overriding these functions is the best
  // way to replace a class with a descendent of that class in a customized
  // version of the PIE.
  TModflowTypesClass = Class(Tobject)
    // form types
    function GetModflowFormType : TModflowFormClass; virtual;
    function GetRunModflowType : TRunModflowClass; virtual;
    function GetPostModflowType : TPostModflowClass; virtual;
    function GetSelectPostFileType : TSelectPostFileClass; virtual;
    function GetWellDataFormType : TWellDataFormClass; virtual;
    function GetWarningsFormType : TWarningsFormClass; virtual;
    // misc
    function GetModflowLayerStructureType : TModflowLayerStructureClass;  virtual;
    function GetGeologicUnitType : TMFGeologicUnitClass; virtual;
    function GetMultiplierListType : TMultiplierListClass; virtual;
    function GetZoneListType : TZoneListClass; virtual;
    function GetObservationGroupListType : TObservationGroupListClass; virtual;
    function GetObservationListType : TObservationListClass; virtual;
    function GetWeightedObservationListType : TWeightedObservationListClass; virtual;
    function GetGHBFluxObsListType : TGHBFluxObsListClass; virtual;
    function GetDrainFluxObsListType : TDrainFluxObsListClass; virtual;
    function GetRiverFluxObsListType : TRiverFluxObsListClass; virtual;
    function GetSpecifiedHeadFluxObsListType : TSpecifiedHeadFluxObsListClass; virtual;
    function GetAdvectionStartingObsListType : TAdvectionStartingObsListClass; virtual;
    function GetAdvectionObservationListType : TAdvectionObservationListClass; virtual;
    function GetLakeLeakanceListType : TLakeLeakanceListClass; virtual;
    function GetWeightedConcentrationListType : TWeightedConcentrationClass; virtual;


    function GetDrainReturnFluxObsListType : TDrainReturnFluxObsListClass; virtual;
    // Layer types
    function GetMFGeolUnitGroupLayerType : TMFGeolUnitGroupLayerClass ;   virtual;
    function GetBottomElevLayerType : TBottomElevLayerClass;              virtual;
    function GetMFDomainOutType : TMFDomainOutLayerClass;                 virtual;
    function GetLineDrainLayerType : TMFLineDrainLayerClass;              virtual;
    function GetAreaDrainLayerType : TMFAreaDrainLayerClass;              virtual;
    function GetETLayerType : TMFETLayerClass;                            virtual;
    function GetPointGHBLayerType : TMFPointGHBLayerClass;                virtual;
    function GetLineGHBLayerType : TMFLineGHBLayerClass;                  virtual;
    function GetAreaGHBLayerType : TMFAreaGHBLayerClass;                  virtual;
    function GetGridLayerType : TMFGridLayerClass;                        virtual;
    function GetDensityLayerType : TMFDensityLayerClass;                  virtual;
    function GetHydraulicCondLayerType : TMFHydraulicCondLayerClass;      virtual;
    function GetInactiveLayerType : TMFInactiveLayerClass;                virtual;
    function GetInitialHeadLayerType : TMFInitialHeadLayerClass;          virtual;
    function GetMapLayerType : TMFMapLayerClass;                          virtual;
    function GetMOCInitialConcLayerType : TMOCInitialConcLayerClass;      virtual;
    function GetMOCObsWellLayerType : TMOCObsWellLayerClass;              virtual;
    function GetMOCParticleRegenLayerType : TMOCParticleRegenLayerClass;  virtual;
    function GetMOCPorosityLayerType : TMOCPorosityLayerClass;            virtual;
    function GetPrescribedHeadLayerType : TMFPrescribedHeadLayerClass;    virtual;
    function GetRechargeLayerType : TMFRechargeLayerClass;                virtual;
    function GetMOCRechargeConcLayerType : TMOCRechargeConcLayerClass;    virtual;
    function GetMFLineRiverLayerType : TMFLineRiverLayerClass;            virtual;
    function GetMFAreaRiverLayerType : TMFAreaRiverLayerClass;            virtual;
    function GetMFSpecStorageLayerType : TMFSpecStorageLayerClass;        virtual;
    function GetMFSpecYieldLayerType : TMFSpecYieldLayerClass;            virtual;
    function GetMFTopElevLayerType : TMFTopElevLayerClass;                virtual;
    function GetMFWellLayerType : TMFWellLayerClass;                      virtual;
    function GetMFWettingLayerType : TMFWettingLayerClass;                virtual;
    function GetMFStreamLayerType : TMFStreamLayerClass;                  virtual;
    function GetMFHFBLayerType : TMFHFBLayerClass;                        virtual;
    function GetMFPointFHBLayerType : TMFPointFHBLayerClass;              virtual;
    function GetMFLineFHBLayerType : TMFLineFHBLayerClass;                virtual;
    function GetMFAreaFHBLayerType : TMFAreaFHBLayerClass;                virtual;
    function GetMODPATHLayerType : TMODPATHLayerClass;                    virtual;
    function GetZoneBudLayerType: TZoneBudLayerClass;                     virtual;
    function GetMODPATHZoneLayerType: TMODPATHZoneLayerClass;             virtual;
    function GetMODPATHPostLayerType: TMODPATHPostLayerClass;             virtual;
    function GetMOCTransSubGridLayerType: TMOCTransSubGridLayerClass;     virtual;
    function GetMFPostProcessingGroupLayerType: TMFPostProcessingGroupLayerClass;     virtual;
    function GetMFTransmisivityLayerType: TMFTransmisivityLayerClass;     virtual;
    function GetMFVcontLayerType: TMFVcontLayerClass;     virtual;
    function GetMFConfStorageLayerType: TMFConfStorageLayerClass;     virtual;
    function GetMFMOCImPorosityLayerType: TMFMOCImPorosityLayerClass;     virtual;
    function GetMFMOCLinExchCoefLayerType: TMFMOCLinExchCoefLayerClass;     virtual;
    function GetMFMOCDecayCoefLayerType: TMFMOCDecayCoefLayerClass;     virtual;
    function GetMFMOCGrowthLayerType: TMFMOCGrowthLayerClass;     virtual;
    function GetMFMOCImInitConcLayerType: TMFMOCImInitConcLayerClass;     virtual;
    function GetMFMOCRetardationLayerType: TMFMOCRetardationLayerClass;     virtual;
    function GetMFMOCDisDecayCoefLayerType: TMFMOCDisDecayCoefLayerClass;     virtual;
    function GetMFMOCSorbDecayCoefLayerType: TMFMOCSorbDecayCoefLayerClass;     virtual;
    function GetMFMOCDisGrowthLayerType: TMFMOCDisGrowthLayerClass;     virtual;
    function GetMFMOCSorbGrowthLayerType: TMFMOCSorbGrowthLayerClass;     virtual;
    function GetMFMODPATHPostEndLayerType: TMFMODPATHPostEndLayerClass;     virtual;
    function GetMFPointDrainLayerType: TMFPointDrainLayerClass;     virtual;
    function GetMFPointRiverLayerType: TMFPointRiverLayerClass;     virtual;
    function GetMFMultiplierLayerType: TMFMultiplierLayerClass;     virtual;
    function GetMFMultiplierGroupLayerType: TMFMultiplierGroupLayerClass;     virtual;
    function GetMFZoneLayerType: TMFZoneLayerClass;     virtual;
    function GetMFZoneGroupLayerType: TMFZoneGroupLayerClass;     virtual;
    function GetMFAnistropyLayerType: TMFAnistropyLayerClass;     virtual;
    function GetMFLineWellLayerType : TMFLineWellLayerClass;                      virtual;
    function GetMFAreaWellLayerType : TMFAreaWellLayerClass;                      virtual;
    function GetMFHeadObservationsLayerType : TMFHeadObservationsLayerClass;                      virtual;
    function GetMFWeightedHeadObservationsLayerType : TMFWeightedHeadObservationsLayerClass;                      virtual;
    function GetMFObservationsGroupLayerType : TMFObservationsGroupLayerClass;                      virtual;
    function GetMFCustomFluxObservationsLayerType : TMFCustomFluxObservationsLayerClass;                      virtual;
    function GetMFGHBFluxObservationsLayerType : TMFGHBFluxObservationsLayerClass;                      virtual;
    function GetMFDrainFluxObservationsLayerType : TMFDrainFluxObservationsLayerClass;                      virtual;
    function GetMFRiverFluxObservationsLayerType : TMFRiverFluxObservationsLayerClass;                      virtual;
    function GetMFSpecifiedHeadFluxObservationsLayerType : TMFSpecifiedHeadFluxObservationsLayerClass;                      virtual;
    function GetMFAdvectionObservationsStartingLayerType : TMFAdvectionObservationsStartingLayerClass;                      virtual;
    function GetMFAdvectionObservationsLayerType : TMFAdvectionObservationsLayerClass;                      virtual;
    function GetMFLakeLayerType : TMFLakeLayerClass;                      virtual;
    function GetMFLakeBottomLayerType : TMFLakeBottomLayerClass;                      virtual;
    function GetMFLakeLeakanceLayerType : TMFLakeLeakanceLayerClass;                      virtual;
    function GetMFIBSLayerType : TMFIBSLayerClass;                      virtual;
    function GetMFReservoirLayerType : TMFReservoirLayerClass;                      virtual;
    function GetMF2KSimpleStreamLayerType : TMF2KSimpleStreamLayerClass; virtual;
    function GetMF2K8PointChannelStreamLayerType : TMF2K8PointChannelStreamLayerClass; virtual;
    function GetMF2KFormulaStreamLayerType : TMF2KFormulaStreamLayerClass; virtual;
    function GetMF2KTableStreamLayerType : TMF2KTableStreamLayerClass; virtual;
    function GetMFSegmentedETLayerType : TMFSegmentedETLayerClass; virtual;
    function GetMFLineDrainReturnLayerType : TMFLineDrainReturnLayerClass; virtual;
    function GetMFAreaDrainReturnLayerType : TMFAreaDrainReturnLayerClass; virtual;
    function GetMFPointDrainReturnLayerType : TMFPointDrainReturnLayerClass; virtual;
    function GetMFDrainReturnLayerType : TMFDrainReturnLayerClass; virtual;
    function GetMFDrainReturnFluxObservationsLayerType : TMFDrainReturnFluxObservationsLayerClass; virtual;
    function GetMFHydmodLayerType : TMFHydmodLayerClass; virtual;
    function GetMFPointLineCHD_LayerType : TMFPointLineCHD_LayerClass; virtual;
    function GetMFAreaCHD_LayerType : TMFAreaCHD_LayerClass; virtual;
    function GetMFHUF_LayerType : TMFHUF_LayerClass; virtual;
    function GetMFHUFGroupLayerType : TMFHufGroupLayerClass; virtual;
    function GetMFLakeGroupLayerType : TMFLakeGroupLayerClass; virtual;
    function GetMFMNW_LayerType : TMFMNW_LayerClass; virtual;
    function GetMFMNW_WaterQualityLayerType : TMFMNW_WaterQualityLayerClass; virtual;
    function GetMFDaflowLayerType : TMFDaflowLayerClass; virtual;
    function GetMFHUF_ReferenceSurfaceLayerClassType : TMFHUF_ReferenceSurfaceLayerClass; virtual;
    function GetMFNoDelaySubsidenceLayerType : TMFNoDelaySubsidenceLayerClass ; virtual;
    function GetMFDelaySubsidenceLayerType : TMFDelaySubsidenceLayerClass ; virtual;
    function GetFluidDensityLayerType : TMFFluidDensityLayerClass ; virtual;
    function GetMOCInitialParticlePlacementLayerType : TMFMOCInitialParticlePlacementLayerClass ; virtual;
    function GetMOCUpperBoundaryConcentrationLayerType : TMFMOCUpperBoundaryConcentrationLayerClass ; virtual;
    function GetMOCLowerBoundaryConcentrationLayerType : TMFMOCLowerBoundaryConcentrationLayerClass ; virtual;
    function GetMOCLateralBoundaryConcentrationLayerType : TMFLateralBoundaryConcentrationLayerClass ; virtual;

    function GetMF_SWT_GroupLayerType : TMFSWT_GroupLayerClass ; virtual;
    function GetMFGeostaticStressLayerType : TMFGeostaticStressLayerClass ; virtual;
    function GetMFSpecificGravityLayerType : TMFSpecificGravityLayerClass ; virtual;
    function GetMFSwtUnitLayerType : TMFSwtUnitLayerClass ; virtual;
    function GetGWT_TimeVaryConcLayerType : TGWT_TimeVaryConcLayerClass ; virtual;
    function GetGWT_VolumeBalancingLayerClass: TGWT_VolumeBalancingLayerClass;

// begin MT3D
    // MT3D Layers
    function GetMT3DDomOutlineLayerType : TMT3DDomOutlineLayerClass; virtual;
    function GetMT3DInactiveAreaLayerType : TMT3DInactiveAreaLayerClass; virtual;
    function GetMT3DObservationsLayerType : TMT3DObservationsLayerClass; virtual;
    function GetMT3DAreaTimeVaryConcLayerType : TMT3DAreaTimeVaryConcLayerClass; virtual;
    function GetMT3DPointInitConcLayerType : TMT3DPointInitConcLayerClass; virtual;
    function GetMT3DAreaInitConcLayerType : TMT3DAreaInitConcLayerClass; virtual;
    function GetMT3DDataLayerType : TMT3DDataLayerClass ; virtual;
    function GetMT3DPostProcessChartLayerType : TMT3DPostProcessChartLayerClass ; virtual;
    function GetMT3DBulkDensityLayerType : TMT3DBulkDensityLayerClass ; virtual;
    function GetMT3DSorptionLayerType : TMT3DSorptionLayerClass ; virtual;
    function GetMT3DReactionLayerType : TMT3DReactionLayerClass ; virtual;
    function GetMT3DMassFluxLayerType : TMT3DMassFluxLayerClass ; virtual;
    function GetMT3DWeightedConcentrationObservationsLayerType : TMFWeightedConcentrationObservationsLayerClass ; virtual;


// end MT3D
    function GetMFFluxVariableLayerType : TMFFluxVariableLayerClass ; virtual;
    function GetMFHeadConstraintLayerType : TMFHeadConstraintLayerClass ; virtual;
    function GetMFDrawdownConstraintLayerType : TMFDrawdownConstraintLayerClass ; virtual;
    function GetMFHeadDifferenceLayerType : TMFHeadDifferenceLayerClass ; virtual;
    function GetMFGradientLayerType : TMFGradientLayerClass ; virtual;
    function GetMFStreamConstraintLayerType : TMFStreamConstraintLayerClass ; virtual;
    function GetMFStreamDepletionConstraintLayerType : TMFStreamDepletionConstraintLayerClass ; virtual;
    function GetMFMoc3dParticleObsLayerType : TMFMoc3dParticleObsLayerClass ; virtual;

    function GetMFUzfFlowLayerType : TMFUzfFlowLayerClass ; virtual;
    function GetMFUzfLayerLayerType : TMFUzfLayerLayerClass ; virtual;
    function GetMFUzfStreamLakeLayerType : TMFUzfStreamLakeLayerClass ; virtual;
    function GetMFUzfOutputLayerType : TMFUzfOutputLayerClass ; virtual;
    function GetMFUzfGroupLayerType : TMFUzfGroupLayerClass ; virtual;
    function GetMFMT3DMolecularDiffusionLayerType : TMT3DMolecularDiffusionLayerClass ; virtual;
    function GetMFViscosityLayerType : TMFViscosityLayerClass ; virtual;
    function GetMFMNW2_VerticalWellLayerType : TMFMNW2_VerticalWellLayerClass ; virtual;
    function GetMFMNW2_GeneralWellLayerType : TMFMNW2_GeneralWellLayerClass ; virtual;

    function GetMFGwmHeadStateLayerType : TMFGwmHeadStateLayerClass ; virtual;
    function GetMFGwmStreamStateLayerType : TMFGwmStreamStateLayerClass ; virtual;
    function GetMFGwmStorageStateLayerType : TMFGwmStorageStateLayerClass ; virtual;

    // Parameter List types
    function GetMFDrainTimeParamListType : TMFDrainTimeParamListClass;                  virtual;
    function GetETTimeParamListType : TMFETTimeParamListClass;                          virtual;
    function GetGHBTimeParamListType : TMFGHBTimeParamListClass;                        virtual;
    function GetMFGeologicUnitParametersType : TMFGeologicUnitParametersClass;          virtual;
    function GetMOCElevParamListType : TMOCElevParamListClass;                          virtual;
    function GetMFRechElevParamListType : TMFRechargeTimeParamListClass;                virtual;
    function GetMOCRechargeConcTimeParamListType : TMOCRechargeConcTimeParamListClass;  virtual;
    function GetMFRiverTimeParamListType : TMFRiverTimeParamListClass;                  virtual;
    function GetMFWellTimeParamListType : TMFWellTimeParamListClass;                    virtual;
    function GetMFStreamTimeParamListType : TMFStreamTimeParamListClass;                virtual;
    function GetMFFHBPointTimeParamListType : TMFFHBPointTimeParamListClass;            virtual;
    function GetMFFHBLineTimeParamListType : TMFFHBLineTimeParamListClass;              virtual;
    function GetMFFHBAreaTimeParamListType : TMFFHBAreaTimeParamListClass;              virtual;
    function GetMFMODPATHTimeParamListType : TMFMODPATHTimeParamListClass;              virtual;
    function GetMFMOCLinExchCoefTimeParamListType : TMFMOCLinExchCoefTimeParamListClass;              virtual;
    function GetMFMOCDecayCoefTimeParamListType : TMFMOCDecayCoefTimeParamListClass;              virtual;
    function GetMFMOCGrowthTimeParamListType : TMFMOCGrowthTimeParamListClass;              virtual;
    function GetMFMOCDisDecayCoefTimeParamListType : TMFMOCDisDecayCoefTimeParamListClass;              virtual;
    function GetMFMOCSorbDecayCoefTimeParamListType : TMFMOCSorbDecayCoefTimeParamListClass;              virtual;
    function GetMFMOCDisGrowthTimeParamListType : TMFMOCDisGrowthTimeParamListClass;              virtual;
    function GetMFMOCSorbGrowthTimeParamListType : TMFMOCSorbGrowthTimeParamListClass;              virtual;
    function GetMFMultiplierParamListType : TMFMultiplierParamListClass;              virtual;
    function GetMFZoneParamListType : TMFZoneParamListClass;              virtual;
    function GetMFLineAreaWellTimeParamListType : TMFLineAreaWellTimeParamListClass;              virtual;
    function GetMFHeadObservationParamListType : TMFHeadObservationParamListClass;              virtual;
    function GetMFWeightParamListType : TMFWeightParamListClass;              virtual;
    function GetMFGHBFluxObservationParamListType : TMFGHBFluxObservationParamListClass;              virtual;
    function GetMFDrainFluxObservationParamListType : TMFDrainFluxObservationParamListClass;              virtual;
    function GetMFRiverFluxObservationParamListType : TMFRiverFluxObservationParamListClass;              virtual;
    function GetMFSpecifiedHeadFluxObservationParamListType : TMFSpecifiedHeadFluxObservationParamListClass;              virtual;
    function GetMFLakeTimeParamListType : TMFLakeTimeParamListClass;              virtual;
    function GetMFReservoirTimeParamListType : TMFReservoirTimeParamListClass;              virtual;
    function GetMF2KSimpleStreamTimeParamListType : TMF2KSimpleStreamTimeParamListClass;              virtual;
    function GetMF2K8PointChannelStreamTimeParamListType : TMF2K8PointChannelStreamTimeParamListClass;              virtual;
    function GetMF2KTableStreamTimeParamListType : TMF2KTableStreamTimeParamListClass;              virtual;
    function GetMF2KStreamCrossSectionParamListType : TMF2KStreamCrossSectionParamListClass;              virtual;
    function GetMF2KStreamTableParamListType : TMF2KStreamTableParamListClass;              virtual;
    function GetMF2KStreamFormulaTimeParamListType : TMF2KStreamFormulaTimeParamListClass;              virtual;
    function GetMFStreamObservationParamListType : TMFStreamObservationParamListClass;              virtual;
    function GetMFSegET_IntermediateDepthsParamListType : TMFSegET_IntermediateDepthsParamListClass;              virtual;
    function GetMFSegETTimeParamListType : TMFSegETTimeParamListClass;              virtual;
    function GetMFDrainReturnTimeParamListType : TMFDrainReturnTimeParamListClass;              virtual;
    function GetMFDrainReturnFluxObservationParamListType : TMFDrainReturnFluxObservationParamListClass;              virtual;
    function GetMFCHD_TimeParamListType : TMFCHD_TimeParamListClass;              virtual;
    function GetMFMNW_TimeParamListType : TMFMNW_TimeParamListClass;              virtual;
    function GetMFMNW_WaterQualityTimeParamListType : TMFMNW_WaterQualityTimeParamListClass;              virtual;
    function GetMFDaflowTimeParamListType : TMFDaflowTimeParamListClass;              virtual;
    function GetMFNoDelayIndexedParamListType : TMFNoDelayIndexedParamListClass;              virtual;
    function GetMFDelayIndexedParamListType : TMFDelayIndexedParamListClass;              virtual;
    function GetMFFluidDensityTimeParamListType : TMFFluidDensityTimeParamListClass;              virtual;
    function GetMFGWM_TimeParamListType : TMFGWM_TimeParamListClass;              virtual;
    function GetMFUzfTimeParamListType : TMFUzfTimeParamListClass;              virtual;
    function GetMFSwtIndexedParamListType : TMFSwtIndexedParamListClass; virtual;
    function GetMFConcentrationObservationParamListType : TMFConcentrationObservationParamListClass; virtual;
    function GetMFConcWeightParamListType : TMFConcWeightParamListClass; virtual;
    function GetMFViscosityParamListType : TMFViscosityParamListClass; virtual;
    function GetMFMNW2_WellScreenParamListType : TMFMNW2_WellScreenParamListClass; virtual;
    function GetMFMNW2_TimeParamListType : TMFMNW2_TimeParamListClass; virtual;
    function GetMFLeakConductanceParamListType : TMFLeakConductanceParamListClass; virtual;
    function GetMFGwmStressPeriodParamListType : TMFGwmStressPeriodParamListClass; virtual;
    function GetGWT_TimeVaryConcTimeParamList : TGWT_TimeVaryConcTimeParamListClass; virtual;



// begin MT3D
    // MT3D parameter lists
    function GetMT3DPrescribedHeadTimeParamListType : TMT3DPrescribedHeadTimeParamListClass; virtual;
//    function GetMT3DPointTimeVaryConcTimeParamListType : TMT3DPointTimeVaryConcTimeParamListClass; virtual;
    function GetMT3DTimeVaryConcTimeParamListType : TMT3DTimeVaryConcTimeParamListClass; virtual;
    function GetMFFHBMT3DConcTimeParamListType : TMFFHBMT3DConcTimeParamListClass; virtual;
    function GetMT3DMassFluxTimeParamListType : TMT3DMassFluxTimeParamListClass; virtual;    
// end MT3D

    // Parameter types
    function GetMFBottomElevParamType : TMFBottomElevParamClass;                 virtual;
    function GetMFDomDensityParamType : TMFDomDensityParamClass;                 virtual;
    function GetMFDrainElevationParamType : TMFDrainElevationParamClass;         virtual;
    function GetMFDrainOnParamType : TMFDrainOnParamClass;                       virtual;
    function GetMFETSurfaceParamType : TMFETSurfaceParamClass;                   virtual;
    function GetMFETExtDepthParamType : TMFETExtDepthParamClass;                 virtual;
    function GetMFETExtFluxParamType : TMFETExtFluxParamClass;                   virtual;
    function GetMFFHBPointAreaHeadParamType : TMFFHBPointAreaHeadParamClass;     virtual;
    function GetMFFHBPointFluxParamType : TMFFHBPointFluxParamClass;             virtual;
    function GetMFFHBTopElevParamType : TMFFHBTopElevParamClass;                 virtual;
    function GetMFFHBBotElevParamType : TMFFHBBotElevParamClass;                 virtual;
    function GetMFFHBHeadConcParamType : TMFHBHeadConcParamClass;                virtual;
    function GetMFFHBFluxConcParamType : TMFHBFluxConcParamClass;                virtual;
    function GetMFFHBLineHeadStartParamType : TMFHBLineHeadStartParamClass;      virtual;
    function GetMFFHBLineHeadEndParamType : TMFHBLineHeadEndParamClass;          virtual;
    function GetMFFHBLineFluxParamType : TMFHBLineFluxParamClass;                virtual;
    function GetMFFHBAreaFluxParamType : TMFHBAreaFluxParamClass;                virtual;
    function GetMFGHBHeadParamType : TMFGHBHeadParamClass;                       virtual;
    function GetMFConcentrationParamType : TMFConcentrationParamClass;           virtual;
    function GetMFConductanceParamType : TMFConductanceParamClass;               virtual;
    function GetMFIFACEParamType : TMFIFACEParamClass;                           virtual;
    function GetMFGridETSurfParamType : TMFGridETSurfParamClass;                 virtual;
    function GetMFGridRechElevParamType : TMFGridRechElevParamClass;             virtual;
    function GetMFIBoundGridParamType : TMFIBoundGridParamClass;                 virtual;
    function GetMFGridTopElevParamType : TMFGridTopElevParamClass;               virtual;
    function GetMFGridBottomElevParamType : TMFGridBottomElevParamClass;         virtual;
    function GetMFGridThicknessParamType : TMFGridThicknessParamClass;           virtual;
    function GetMFGridInitialHeadParamType : TMFGridInitialHeadParamClass;       virtual;
    function GetMFGridKxParamType : TMFGridKxParamClass;                         virtual;
    function GetMFGridKzParamType : TMFGridKzParamClass;                         virtual;
    function GetMFGridSpecYieldParamType : TMFGridSpecYieldParamClass;           virtual;
    function GetMFGridSpecStorParamType : TMFGridSpecStorParamClass;             virtual;
    function GetMFGridWettingParamType : TMFGridWettingParamClass;               virtual;
    function GetMFGridWellParamType : TMFGridWellParamClass;                     virtual;
    function GetMFGridRiverParamType : TMFGridRiverParamClass;                   virtual;
    function GetMFGridDrainParamType : TMFGridDrainParamClass;                   virtual;
    function GetMFGridGHBParamType : TMFGridGHBParamClass;                       virtual;
    function GetMFGridFHBParamType : TMFGridFHBParamClass;                            virtual;
    function GetMFGridHFBParamType : TMGridHFBParamClass;                             virtual;
    function GetMFGridStreamParamType : TMFGridStreamParamClass;                      virtual;
    function GetMFGridMOCInitConcParamType : TMFGridMOCInitConcParamClass;            virtual;
    function GetMFGridMOCSubGridParamType : TMFGridMOCSubGridParamClass;              virtual;
    function GetMFGridMOCParticleRegenParamType : TMFGridMOCParticleRegenParamClass;  virtual;
    function GetMFGridMOCPorosityParamType : TMFGridMOCPorosityParamClass;            virtual;
    function GetMFGridZoneBudgetParamType : TMFGridZoneBudgetParamClass;              virtual;
    function GetMFGridModpathZoneParamType : TMFGridModpathZoneParamClass;            virtual;
    function GetMFDensityParamType : TMFDensityParamClass;                            virtual;
    function GetMFHFBHydCondParamType : TMFHFBHydCondParamClass;                      virtual;
    function GetMFHFBBarrierThickParamType : TMFHFBBarrierThickParamClass;            virtual;
    function GetMFKxParamType : TMFKxParamClass;                                      virtual;
    function GetMFKzParamType : TMFKzParamClass;                                      virtual;
    function GetMFInactiveParamType : TMFInactiveParamClass;                          virtual;
    function GetMFInitialHeadParamType : TMFInitialHeadParamClass;                    virtual;
    function GetMFMOCInitialConcParamType : TMFMOCInitialConcParamClass;              virtual;
    function GetMFMOCObsElevParamType : TMFMOCObsElevParamClass;                      virtual;
    function GetMFMOCParticleRegenParamType : TMFMOCParticleRegenParamClass;          virtual;
    function GetMFMOCPorosityParamType : TMFMOCPorosityParamClass;                    virtual;
    function GetMFModpathZoneParamType : TMFModpathZoneParamClass;                    virtual;
    function GetMFPrescribedHeadParamType : TMFPrescribedHeadParamClass;              virtual;
    function GetMFRechElevParamType : TMFRechElevParamClass;                          virtual;
    function GetMFRechStressParamType : TMFRechStressParamClass;                      virtual;
    function GetMFRechConcParamType : TMFRechConcParamClass;                          virtual;
    function GetMFRiverBottomParamType : TMFRiverBottomParamClass;                    virtual;
    function GetMFRiverStageParamType : TMFRiverStageParamClass;                      virtual;
    function GetMFSpecStorageParamType : TMFSpecStorageParamClass;                    virtual;
    function GetMFSpecYieldParamType : TMFSpecYieldParamClass;                        virtual;
    function GetMFStreamSegNumParamType : TMFStreamSegNumParamClass;                  virtual;
    function GetMFStreamDownSegNumParamType : TMFStreamDownSegNumParamClass;          virtual;
    function GetMFStreamDivSegNumParamType : TMFStreamDivSegNumParamClass;            virtual;
    function GetMFStreamHydCondParamType : TMFStreamHydCondParamClass;                virtual;
    function GetMFStreamFlowParamType : TMFStreamFlowParamClass;                      virtual;
    function GetMFStreamUpStageParamType : TMFStreamUpStageParamClass;                virtual;
    function GetMFStreamDownStageParamType : TMFStreamDownStageParamClass;            virtual;
    function GetMFStreamUpBotElevParamType : TMFStreamUpBotElevParamClass;            virtual;
    function GetMFStreamDownBotElevParamType : TMFStreamDownBotElevParamClass;        virtual;
    function GetMFStreamUpTopElevParamType : TMFStreamUpTopElevParamClass;            virtual;
    function GetMFStreamDownTopElevParamType : TMFStreamDownTopElevParamClass;        virtual;
    function GetMFStreamUpWidthParamType : TMFStreamUpWidthParamClass;                virtual;
    function GetMFStreamDownWidthParamType : TMFStreamDownWidthParamClass;            virtual;
    function GetMFStreamSlopeParamType : TMFStreamSlopeParamClass;                    virtual;
    function GetMFStreamRoughParamType : TMFStreamRoughParamClass;                    virtual;
    function GetMFTopElevParamType : TMFTopElevParamClass;                            virtual;
    function GetMFWellTopParamType : TMFWellTopParamClass;                            virtual;
    function GetMFWellBottomParamType : TMFWellBottomParamClass;                      virtual;
    function GetMFWellStressParamType : TMFWellStressParamClass;                      virtual;
    function GetMFWettingThreshParamType : TMFWettingThreshParamClass;                virtual;
    function GetMFWettingFlagParamType : TMFWettingFlagParamClass;                    virtual;
    function GetMFZoneBudZoneParamType : TMFZoneBudZoneParamClass;                    virtual;
    function GetMFMODPATH_XCountParamType : TMFMODPATH_XCountParamClass;              virtual;
    function GetMFMODPATH_YCountParamType : TMFMODPATH_YCountParamClass;              virtual;
    function GetMFMODPATH_ZCountParamType : TMFMODPATH_ZCountParamClass;              virtual;
    function GetMFMODPATH_ReleaseTimeParamType : TMFMODPATH_ReleaseTimeParamClass;    virtual;
    function GetMFMODPATHPartIfaceParamType : TMFMODPATHPartIfaceParamClass;          virtual;
    function GetMFMODPATH_FirstLayerParamType : TMFMODPATH_FirstLayerParamClass;      virtual;
    function GetMFMODPATH_FirstTimeParamType  : TMFMODPATH_FirstTimeParamClass;       virtual;
    function GetMFMODPATH_LastLayerParamType  : TMFMODPATH_LastLayerParamClass;       virtual;
    function GetMFMODPATH_LastTimeParamType   : TMFMODPATH_LastTimeParamClass;        virtual;
    function GetMFMOCTransSubGridParamType   : TMFMOCTransSubGridParamClass;        virtual;
    function GetMFTransmisivityParamType   : TMFTransmisivityParamClass;        virtual;
    function GetMFVcontParamType   : TMFVcontParamClass;        virtual;
    function GetMFConfStorageParamType   : TMFConfStorageParamClass;        virtual;
    function GetMFGridVContParamType   : TMFGridVContParamClass;        virtual;
    function GetMFGridConfStoreParamType   : TMFGridConfStoreParamClass;        virtual;
    function GetMFGridTransParamType   : TMFGridTransParamClass;        virtual;
    function GetMFModflowLayerParamType   : TMFModflowLayerParamClass;        virtual;
    function GetMFGridRechLayerParamType   : TMFGridRechLayerParamClass;        virtual;
    function GetMFGridETLayerParamType   : TMFGridETLayerParamClass;        virtual;
    function GetMFMOCImPorosityParamType   : TMFMOCImPorosityParamClass;        virtual;
    function GetMFMOCLinExchCoefParamType   : TMFMOCLinExchCoefParamClass;        virtual;
    function GetMFMOCDecayCoefParamType   : TMFMOCDecayCoefParamClass;        virtual;
    function GetMFMOCGrowthParamType   : TMFMOCGrowthParamClass;        virtual;
    function GetMFMOCImInitConcParamType   : TMFMOCImInitConcParamClass;        virtual;
    function GetMFMOCRetardationParamType   : TMFMOCRetardationParamClass;        virtual;
    function GetMFMOCDisDecayCoefParamType   : TMFMOCDisDecayCoefParamClass;        virtual;
    function GetMFMOCSorbDecayCoefParamType   : TMFMOCSorbDecayCoefParamClass;        virtual;
    function GetMFMOCDisGrowthParamType   : TMFMOCDisGrowthParamClass;        virtual;
    function GetMFMOCSorbGrowthParamType   : TMFMOCSorbGrowthParamClass;        virtual;
    function GetMFMODPATH_StartingZoneParamType   : TMFMODPATH_StartingZoneParamClass;        virtual;
    function GetMFMODPATH_EndingZoneParamType   : TMFMODPATH_EndingZoneParamClass;        virtual;
    function GetMFGridMOCPrescribedConcParamType   : TMFGridMOCPrescribedConcParamClass;        virtual;
    function GetMFMultiplierParamType   : TMFMultiplierParamClass;        virtual;
    function GetMFZoneParamType   : TMFZoneParamClass;        virtual;
    function GetMFGridMultiplierParamType   : TMFGridMultiplierParamClass;        virtual;
    function GetMFGridZoneParamType   : TMFGridZoneParamClass;        virtual;
    function GetMFModflowParameterNameParamType   : TMFModflowParameterNameParamClass;        virtual;
    function GetMFIsParameterParamType   : TMFIsParameterParamClass;        virtual;
    function GetMFAnistropyParamType   : TMFAnistropyParamClass;        virtual;
    function GetMFGridAnisoParamType   : TMFGridAnisoParamClass;        virtual;
    function GetMFGridETExtinctionDepthParamType: TMFGridETExtinctionDepthParamClass; virtual;
    function GetMFOnOffParamType: TMFOnOffParamClass; virtual;
    function GetMFTotalWellStressParamType: TMFTotalWellStressParamClass; virtual;
    function GetMFWellStressIndicatorParamType: TMFWellStressIndicatorParamClass; virtual;
    function GetMFFHBPointBoundaryTypeParamType: TMFFHBPointBoundaryTypeParamClass; virtual;
    function GetMFFHBLineBoundaryTypeParamType: TMFFHBLineBoundaryTypeParamClass; virtual;
    function GetMFFHBAreaBoundaryTypeParamType: TMFFHBAreaBoundaryTypeParamClass; virtual;
    function GetMFFHBEndHeadUsedParamType: TMFFHBEndHeadUsedParamClass; virtual;
    function GetMFTopObsElevParamType: TMFTopObsElevParamClass; virtual;
    function GetMFBottomObsElevParamType: TMFBottomObsElevParamClass; virtual;
    function GetMFObservationNameParamType: TMFObservationNameParamClass; virtual;
    function GetMFStatisticParamType: TMFStatisticParamClass; virtual;
    function GetMFStatFlagParamType: TMFStatFlagParamClass; virtual;
    function GetMFPlotSymbolParamType: TMFPlotSymbolParamClass; virtual;
    function GetMFTopLayerParamType: TMFTopLayerParamClass; virtual;
    function GetMFBottomLayerParamType: TMFBottomLayerParamClass; virtual;
    function GetMFTimeParamType: TMFTimeParamClass; virtual;
    function GetMFIttParamType: TMFIttParamClass; virtual;
    function GetMFObservedHeadParamType: TMFObservedHeadParamClass; virtual;
    function GetMFStathParamType: TMFStathParamClass; virtual;
    function GetMFStatddParamType: TMFStatddParamClass; virtual;
    function GetMFWeightParamType: TMFWeightParamClass; virtual;
    function GetMFFactorParamType: TMFFactorParamClass; virtual;
    function GetMFLossParamType: TMFLossParamClass; virtual;
    function GetMFObservationNumberParamType: TMFObservationNumberParamClass; virtual;
    function GetMFObservationGroupNumberParamType: TMFObservationGroupNumberParamClass; virtual;
    function GetMFAdvObsElevParamType: TMFAdvObsElevParamClass; virtual;
    function GetMFAdvObsGroupNumberParamType: TMFAdvObsGroupNumberParamClass; virtual;
    function GetMFAdvObsLayerParamType: TMFAdvObsLayerParamClass; virtual;
    function GetMFAdvObsNameParamType: TMFAdvObsNameParamClass; virtual;
    function GetMFAdvXStatisticParamType: TMFAdvObsXStatisticParamClass; virtual;
    function GetMFAdvYStatisticParamType: TMFAdvObsYStatisticParamClass; virtual;
    function GetMFAdvZStatisticParamType: TMFAdvObsZStatisticParamClass; virtual;
    function GetMFAdvObsXStatFlagParamType: TMFAdvObsXStatFlagParamClass; virtual;
    function GetMFAdvObsYStatFlagParamType: TMFAdvObsYStatFlagParamClass; virtual;
    function GetMFAdvObsZStatFlagParamType: TMFAdvObsZStatFlagParamClass; virtual;
    function GetMFLakeNumberParamType: TMFLakeNumberParamClass; virtual;
    function GetMFGageParamType: TMFGageParamClass; virtual;
    function GetMFLakeHydraulicCondParamType: TMFLakeHydraulicCondParamClass; virtual;
    function GetMFLakeThicknessParamType: TMFLakeThicknessParamClass; virtual;
    function GetMFLakeInitialStageParamType: TMFLakeInitialStageParamClass; virtual;
    function GetMFLakeMinimumStageParamType: TMFLakeMinimumStageParamClass; virtual;
    function GetMFLakeMaximumStageParamType: TMFLakeMaximumStageParamClass; virtual;
    function GetMFLakeInitialConcParamType: TMFLakeInitialConcParamClass; virtual;
    function GetMFCenterLakeParamType: TMFCenterLakeParamClass; virtual;
    function GetMFLakeSillParamType: TMFLakeSillParamClass; virtual;
    function GetMFLakePrecipParamType: TMFLakePrecipParamClass; virtual;
    function GetMFLakeEvapParamType: TMFLakeEvapParamClass; virtual;
    function GetMFLakeRunoffParamParamType: TMFLakeRunoffParamClass; virtual;
    function GetMFLakeWithdrawalsParamType: TMFLakeWithdrawalsParamClass; virtual;
    function GetMFLakePrecipConcParamType: TMFLakePrecipConcParamClass; virtual;
    function GetMFLakeRunoffConcParamType: TMFLakeRunoffConcParamClass; virtual;
    function GetMFLakeAugmentationConcParamType: TMFLakeAugmentationConcParamClass; virtual;
    function GetMFGridLakeLocationParamType: TMFGridLakeLocationParamClass; virtual;
    function GetMFLakeBottomElevParamParamType: TMFLakeBottomElevParamClass; virtual;
    function GetMFLakeBottomParamType: TMFLakeBottomParamClass; virtual;
    function GetMFPreconsolidationHeadParamType: TMFPreconsolidationHeadParamClass; virtual;
    function GetMFElasticStorageFactorParamType: TMFElasticStorageFactorParamClass; virtual;
    function GetMFInelasticStorageFactorParamType: TMFInelasticStorageFactorParamClass; virtual;
    function GetMFStartingCompactionParamType: TMFStartingCompactionParamClass; virtual;
    function GetMFGridIbsPreconsolidationHeadParamType: TMFGridIbsPreconsolidationHeadParamClass; virtual;
    function GetMFGridIbsElasticStorageParamType: TMFGridIbsElasticStorageParamClass; virtual;
    function GetMGridIbsInelasticStorageParamType: TMFGridIbsInelasticStorageParamClass; virtual;
    function GetMFGridIbsStartingCompactionParamType: TMFGridIbsStartingCompactionParamClass; virtual;
    function GetMFReservoirLandSurfaceParamType: TMFReservoirLandSurfaceParamClass; virtual;
    function GetMFReservoirKzParamType: TMFReservoirKzParamClass; virtual;
    function GetMFReservoirBedThicknessParamType: TMFReservoirBedThicknessParamClass; virtual;
    function GetMFReservoirStartingStageParamType: TMFReservoirStartingStageParamClass; virtual;
    function GetMFReservoirEndingStageParamType: TMFReservoirEndingStageParamClass; virtual;
    function GetMFMODPATH_StartingRowParamType: TMFMODPATH_StartingRowParamClass; virtual;
    function GetMFMODPATH_StartingColumnParamType: TMFMODPATH_StartingColumnParamClass; virtual;
    function GetMFGridResElevParamType: TMFGridResElevParamClass; virtual;
    function GetMFGridResKzParamType: TMFGridResKzParamClass; virtual;
    function GetMFGridResThicknessParamType: TMFGridResThicknessParamClass; virtual;
    function GetMFIsObservationParamType: TMFIsObservationParamClass; virtual;
    function GetMFIsPredictionParamType: TMFIsPredictionParamClass; virtual;
    function GetMFMOC_IsObservationParamType: TMFMOC_IsObservationParamClass; virtual;
    function GetMF2KUpstreamKParamType: TMF2KUpstreamKParamClass; virtual;
    function GetMF2KDownstreamKParamType: TMF2KDownstreamKParamClass; virtual;
    function GetMF2KStreamPriorityParamType: TMF2KStreamPriorityParamClass; virtual;
    function GetMF2KUpsteamDepthParamType: TMF2KUpsteamDepthParamClass; virtual;
    function GetMF2KDownstreamDepthParamType: TMF2KDownstreamDepthParamClass; virtual;
    function GetMF2KStreamDownWidthParamType: TMF2KStreamDownWidthParamClass; virtual;
    function GetMF2KChanelRoughnessParamType: TMF2KChanelRoughnessParamClass; virtual;
    function GetMF2KBankRoughnessParamType: TMF2KBankRoughnessParamClass; virtual;
    function GetMF2KPrecipitationParamType: TMF2KPrecipitationParamClass; virtual;
    function GetMF2KDownstreamTopElevationParamType: TMF2KDownstreamTopElevationParamClass; virtual;
    function GetMF2KUpstreamBedThicknessParamType: TMF2KUpstreamBedThicknessParamClass; virtual;
    function GetMF2KDownstreamBedThicknessParamType: TMF2KDownstreamBedThicknessParamClass; virtual;
    function GetMF2KCrossSectionXParamType: TMF2KCrossSectionXParamClass; virtual;
    function GetMF2KCrossSectionZParamType: TMF2KCrossSectionZParamClass; virtual;
    function GetMF2KTableWidthParamType: TMF2KTableWidthParamClass; virtual;
    function GetMF2KTableDepthParamType: TMF2KTableDepthParamClass; virtual;
    function GetMF2KTableFlowParamType: TMF2KTableFlowParamClass; virtual;
    function GetMF2KWidthExponentParamType: TMF2KWidthExponentParamClass; virtual;
    function GetMF2KDepthExponentParamType: TMF2KDepthExponentParamClass; virtual;
    function GetMF2KWidthCoefficientParamType: TMF2KWidthCoefficientParamClass; virtual;
    function GetMF2KDepthCoefficientParamType: TMF2KDepthCoefficientParamClass; virtual;
    function GetMF2K_ICALC_ParamType: TMF2K_ICALC_ParamClass; virtual;
    function GetMF2KFlowConcentrationParamType: TMF2KFlowConcentrationParamClass; virtual;
    function GetMF2KRunoffConcentrationParamType: TMF2KRunoffConcentrationParamClass; virtual;
    function GetMF2KPrecipitationConcentrationParamType: TMF2KPrecipitationConcentrationParamClass; virtual;
    function GetMF2KRunoffParamType: TMF2KRunoffParamClass; virtual;
    function GetMF2KStreamEvapParamType: TMF2KStreamEvapParamClass; virtual;
    function GetMFGridSFRParamType: TMFGridSFRParamClass; virtual;
    function GetMF2KStreamDivSegNumParamType: TMF2KStreamDivSegNumParamClass; virtual;
    function GetMF2KStreamUpTopElevParamType: TMF2KStreamUpTopElevParamClass; virtual;
    function GetAdjustForAngleParamType: TAdjustForAngleParamClass; virtual;
    function GetSegETSurfaceParamType: TSegETSurfaceParamClass; virtual;
    function GetSegETExtDepthParamType: TSegETExtDepthParamClass; virtual;
    function GetSegET_MaxFluxParamType: TSegET_MaxFluxParamClass; virtual;
    function GetSegET_IntermediateDepthParamType: TSegET_IntermediateDepthParamClass; virtual;
    function GetSegET_IntermediateProportionParamType: TSegET_IntermediateProportionParamClass; virtual;
    function GetGridETS_SurfaceParamType: TGridETS_SurfaceParamClass; virtual;
    function GetGridETS_ExtinctDepthParamType: TGridETS_ExtinctDepthParamClass; virtual;
    function GetGridETS_LayerParamType: TGridETS_LayerParamClass; virtual;
    function GetDrainReturnIndexParamType: TDrainReturnIndexParamClass; virtual;
    function GetDrainReturnFractionParamType: TDrainReturnFractionParamClass; virtual;
    function GetGridDrainReturnParamType: TGridDrainReturnParamClass; virtual;
    function GetMFHydmodHeadObservationParamType: TMFHydmodHeadObservationParamClass; virtual;
    function GetMFHydmodDrawDownObservationParamType: TMFHydmodDrawDownObservationParamClass; virtual;
    function GetMFHydmodPreconsolidationObservationParamType: TMFHydmodPreconsolidationObservationParamClass; virtual;
    function GetMFHydmodCompactionObservationParamType: TMFHydmodCompactionObservationParamClass; virtual;
    function GetMFHydmodSubsidenceObservationParamType: TMFHydmodSubsidenceObservationParamClass; virtual;
    function GetMFHydmodStreamStageObservationParamType: TMFHydmodStreamStageObservationParamClass; virtual;
    function GetMFHydmodStreamFlowInObservationParamType: TMFHydmodStreamFlowInObservationParamClass; virtual;
    function GetMFHydmodStreamFlowOutObservationParamType: TMFHydmodStreamFlowOutObservationParamClass; virtual;
    function GetMFHydmodStreamFlowIntoAquiferObservationParamType: TMFHydmodStreamFlowIntoAquiferObservationParamClass; virtual;
    function GetMFHydmodInterpolateParamType: TMFHydmodInterpolateParamClass; virtual;
    function GetMFHydmodLabelParamType: TMFHydmodLabelParamClass; virtual;
    function GetMFHydmodElevParamType: TMFHydmodElevParamClass; virtual;
    function GetMFHydmodModflowLayerParamType: TMFHydmodModflowLayerParamClass; virtual;
    function GetMFCHD_ElevationParamType: TMFCHD_ElevationParamClass; virtual;
    function GetMFCHD_StartHeadParamType: TMFCHD_StartHeadParamClass; virtual;

    function GetMFHFBLongDispParamType: TMFHFBLongDispParamClass; virtual;
    function GetMFHFBHorzTransDispParamType: TMFHFBHorzTransDispParamClass; virtual;
    function GetMFHFBVertTransDispParamType: TMFHFBVertTransDispParamClass; virtual;
    function GetMFHFBDiffusionCoefParamType: TMFHFBDiffusionCoefParamClass; virtual;
    function GetMFGridCHDParamType: TMFGridCHDParamClass; virtual;
    function GetMFCHD_EndHeadParamType: TMFCHD_EndHeadParamClass; virtual;
    function GetMFXObsNumberParamType: TMFXObsNumberParamClass; virtual;
    function GetMFYObsNumberParamType: TMFYObsNumberParamClass; virtual;
    function GetMFZObsNumberParamType: TMFZObsNumberParamClass; virtual;
    function GetMFHUFTopParamType: TMFHUFTopParamClass; virtual;
    function GetMFHUFThicknessParamType: TMFHUFThicknessParamClass; virtual;
    function GetMFElevationParamType : TMFElevationParamClass; virtual;
    function GetMFGageOutputTypeParamType: TMFGageOutputTypeParamClass; virtual;

    function GetGWT_TopElevParam: TGWT_TopElevParamClass; virtual;
    function GetGWT_BottomElevParam: TGWT_BottomElevParamClass; virtual;
    function GetGWT_ConcentrationUsedParamType: TGWT_ConcentrationUsedClass; virtual;
    function GetGwt_ConcBoundaryClass: TGwt_ConcBoundaryClass; virtual;

// begin MT3D
    // MT3D Parameters
//    function GetMT3DAreaConstantConcParamClassType : TMT3DAreaConstantConcParamClass; virtual;
    function GetMT3DDomOutlineParamClassType : TMT3DDomOutlineParamClass; virtual;
    function GetMT3DMassParamClassType : TMT3DMassParamClass; virtual;
    function GetMT3DConcentrationParamClassType : TMT3DConcentrationParamClass; virtual;

    function GetGridMT3DICBUNDParamClassType : TGridMT3DICBUNDParamClass           ; virtual;
    function GetGridMT3DActiveCellParamClassType : TGridMT3DActiveCellParamClass       ; virtual;
    function GetGridMT3DInitConcCellParamClassType : TGridMT3DInitConcCellParamClass     ; virtual;
    function GetGridMT3DTimeVaryConcCellParamClassType : TGridMT3DTimeVaryConcCellParamClass ; virtual;
    function GetGridMT3DObsLocCellParamClassType : TGridMT3DObsLocCellParamClass       ; virtual;
    function GetGridMT3DLongDispCellParamClassType : TGridMT3DLongDispCellParamClass     ; virtual;
    function GetMT3DLongDispParamClassType : TMT3DLongDispParamClass        ; virtual;
    function GetMT3DInactiveAreaParamClassType : TMT3DInactiveAreaParamClass        ; virtual;
    function GetMT3DInitConcParamClassType : TMT3DInitConcParamClass        ; virtual;
    function GetMT3DObservationsParamClassType : TMT3DObservationsParamClass        ; virtual;
    function GetMT3DTopElevParamClassType : TMT3DTopElevParamClass        ; virtual;
    function GetMT3DBottomElevParamClassType : TMT3DBottomElevParamClass        ; virtual;

    function GetMT3DConc2ParamClassType : TMT3DConc2ParamClass; virtual;
    function GetMT3DConc3ParamClassType : TMT3DConc3ParamClass; virtual;
    function GetMT3DConc4ParamClassType : TMT3DConc4ParamClass; virtual;
    function GetMT3DConc5ParamClassType : TMT3DConc5ParamClass; virtual;

    function GetGridMT3DInitConc2ParamClassType : TGridMT3DInitConc2ParamClass; virtual;
    function GetGridMT3DInitConc3ParamClassType : TGridMT3DInitConc3ParamClass; virtual;
    function GetGridMT3DInitConc4ParamClassType : TGridMT3DInitConc4ParamClass; virtual;
    function GetGridMT3DInitConc5ParamClassType : TGridMT3DInitConc5ParamClass; virtual;

    function GetMT3DMass2ParamClassType : TMT3DMass2ParamClass; virtual;
    function GetMT3DMass3ParamClassType : TMT3DMass3ParamClass; virtual;
    function GetMT3DMass4ParamClassType : TMT3DMass4ParamClass; virtual;
    function GetMT3DMass5ParamClassType : TMT3DMass5ParamClass; virtual;

    function GetMT3DInitConc2ParamClassType : TMT3DInitConc2ParamClass; virtual;
    function GetMT3DInitConc3ParamClassType : TMT3DInitConc3ParamClass; virtual;
    function GetMT3DInitConc4ParamClassType : TMT3DInitConc4ParamClass; virtual;
    function GetMT3DInitConc5ParamClassType : TMT3DInitConc5ParamClass; virtual;

{    function GetMT3DAreaConstantConc2ParamClassType : TMT3DAreaConstantConc2ParamClass; virtual;
    function GetMT3DAreaConstantConc3ParamClassType : TMT3DAreaConstantConc3ParamClass; virtual;
    function GetMT3DAreaConstantConc4ParamClassType : TMT3DAreaConstantConc4ParamClass; virtual;
    function GetMT3DAreaConstantConc5ParamClassType : TMT3DAreaConstantConc5ParamClass; virtual;}

    function GetMT3DBulkDensityParamClassType : TMT3DBulkDensityParamClass; virtual;

    function GetMT3DImInitConc2ParamClassType : TMT3DImInitConc2ParamClass; virtual;
    function GetMT3DImInitConc3ParamClassType : TMT3DImInitConc3ParamClass; virtual;
    function GetMT3DImInitConc4ParamClassType : TMT3DImInitConc4ParamClass; virtual;
    function GetMT3DImInitConc5ParamClassType : TMT3DImInitConc5ParamClass; virtual;

    function GetMT3DSP1AParamClassType : TMT3DSP1AParamClass; virtual;
    function GetMT3DSP1BParamClassType : TMT3DSP1BParamClass; virtual;
    function GetMT3DSP1CParamClassType : TMT3DSP1CParamClass; virtual;
    function GetMT3DSP1DParamClassType : TMT3DSP1DParamClass; virtual;
    function GetMT3DSP1EParamClassType : TMT3DSP1EParamClass; virtual;

    function GetMT3DSP2AParamClassType : TMT3DSP2AParamClass; virtual;
    function GetMT3DSP2BParamClassType : TMT3DSP2BParamClass; virtual;
    function GetMT3DSP2CParamClassType : TMT3DSP2CParamClass; virtual;
    function GetMT3DSP2DParamClassType : TMT3DSP2DParamClass; virtual;
    function GetMT3DSP2EParamClassType : TMT3DSP2EParamClass; virtual;

    function GetMT3DRC1AParamClassType : TMT3DRC1AParamClass; virtual;
    function GetMT3DRC1BParamClassType : TMT3DRC1BParamClass; virtual;
    function GetMT3DRC1CParamClassType : TMT3DRC1CParamClass; virtual;
    function GetMT3DRC1DParamClassType : TMT3DRC1DParamClass; virtual;
    function GetMT3DRC1EParamClassType : TMT3DRC1EParamClass; virtual;

    function GetMT3DRC2AParamClassType : TMT3DRC2AParamClass; virtual;
    function GetMT3DRC2BParamClassType : TMT3DRC2BParamClass; virtual;
    function GetMT3DRC2CParamClassType : TMT3DRC2CParamClass; virtual;
    function GetMT3DRC2DParamClassType : TMT3DRC2DParamClass; virtual;
    function GetMT3DRC2EParamClassType : TMT3DRC2EParamClass; virtual;

    function GetMT3DMassFluxAParamClassType : TMT3DMassFluxAParamClass; virtual;
    function GetMT3DMassFluxBParamClassType : TMT3DMassFluxBParamClass; virtual;
    function GetMT3DMassFluxCParamClassType : TMT3DMassFluxCParamClass; virtual;
    function GetMT3DMassFluxDParamClassType : TMT3DMassFluxDParamClass; virtual;
    function GetMT3DMassFluxEParamClassType : TMT3DMassFluxEParamClass; virtual;

    function GetMT3DMolDiffAParamClassType : TMT3DMolDiffAParamClass; virtual;
    function GetMT3DMolDiffBParamClassType : TMT3DMolDiffBParamClass; virtual;
    function GetMT3DMolDiffCParamClassType : TMT3DMolDiffCParamClass; virtual;
    function GetMT3DMolDiffDParamClassType : TMT3DMolDiffDParamClass; virtual;
    function GetMT3DMolDiffEParamClassType : TMT3DMolDiffEParamClass; virtual;

    function GetGridMT3DMassFluxParamClassType : TGridMT3DMassFluxParamClass; virtual;

{    function GetMT3DSorbInitConcParamClassType : TMT3DSorbInitConcParamClass; virtual;
    function GetMT3DSorbInitConc2ParamClassType : TMT3DSorbInitConc2ParamClass; virtual;
    function GetMT3DSorbInitConc3ParamClassType : TMT3DSorbInitConc3ParamClass; virtual;
    function GetMT3DSorbInitConc4ParamClassType : TMT3DSorbInitConc4ParamClass; virtual;
    function GetMT3DSorbInitConc5ParamClassType : TMT3DSorbInitConc5ParamClass; virtual;

    function GetMT3DSorbMassParamClassType : TMT3DSorbMassParamClass; virtual;
    function GetMT3DSorbMass2ParamClassType : TMT3DSorbMass2ParamClass; virtual;
    function GetMT3DSorbMass3ParamClassType : TMT3DSorbMass3ParamClass; virtual;
    function GetMT3DSorbMass4ParamClassType : TMT3DSorbMass4ParamClass; virtual;
    function GetMT3DSorbMass5ParamClassType : TMT3DSorbMass5ParamClass; virtual; }
// end MT3D

    function GetMFMODPATH_StartXParamClassType : TMFMODPATH_StartXParamClass; virtual;
    function GetMFMODPATH_StartYParamClassType : TMFMODPATH_StartYParamClass; virtual;
    function GetMFMODPATH_StartZParamClassType : TMFMODPATH_StartZParamClass; virtual;
    function GetMFMODPATH_EndXParamClassType : TMFMODPATH_EndXParamClass; virtual;
    function GetMFMODPATH_EndYParamClassType : TMFMODPATH_EndYParamClass; virtual;
    function GetMFMODPATH_EndZParamClassType : TMFMODPATH_EndZParamClass; virtual;

    function GetMFReferenceStressPeriodParamClassType : TMFReferenceStressPeriodParamClass; virtual;

    function GetMFMNW_SiteParamClassType : TMFMNW_SiteParamClass; virtual;
    function GetMFMNW_RadiusParamClassType : TMFMNW_RadiusParamClass; virtual;
    function GetMFMNW_StressParamClassType : TMFMNW_StressParamClass; virtual;
    function GetMFMNW_ActiveParamClassType : TMFMNW_ActiveParamClass; virtual;
    function GetMFMNW_WaterQualityParamClassType : TMFMNW_WaterQualityParamClass; virtual;
    function GetMFMNW_LimitingElevationParamClassType : TMFMNW_LimitingElevationParamClass; virtual;
    function GetMFMNW_DrawdownFlagParamClassType : TMFMNW_DrawdownFlagParamClass; virtual;
    function GetMFMNW_ReferenceElevationParamClassType : TMFMNW_ReferenceElevationParamClass; virtual;
    function GetMFMNW_GroupIndentifierParamClassType : TMFMNW_GroupIndentifierParamClass; virtual;
    function GetMFMNW_InactivationPumpingRateParamClassType : TMFMNW_InactivationPumpingRateParamClass; virtual;
    function GetMFMNW_ReactivationPumpingRateParamClassType : TMFMNW_ReactivationPumpingRateParamClass; virtual;
    function GetMFMNW_SkinParamClassType : TMFMNW_SkinParamClass; virtual;
    function GetMFMNW_CoefficientParamClassType : TMFMNW_CoefficientParamClass; virtual;
    function GetMFMNW_OverriddenFirstParamClassType : TMFMNW_OverriddenFirstParamClass; virtual;
    function GetMFMNW_OverriddenLastParamClassType : TMFMNW_OverriddenLastParamClass; virtual;
    function GetMFMNW_FirstElevationParamClassType : TMFMNW_FirstElevationParamClass; virtual;
    function GetMFMNW_LastElevationParamClassType : TMFMNW_LastElevationParamClass; virtual;
    function GetMFGridMNW_LocationParamClassType : TMFGridMNW_LocationParamClass; virtual;
    function GetMFMNW_FirstUnitParamClassType : TMFMNW_FirstUnitParamClass; virtual;
    function GetMFMNW_LastUnitParamClassType : TMFMNW_LastUnitParamClass; virtual;
    function GetMFMNW_PumpingLimitsParamClassType : TMFMNW_PumpingLimitsParamClass; virtual;
    function GetMFMNW_AbsolutePumpingRatesParamClassType : TMFMNW_AbsolutePumpingRatesParamClass; virtual;
    function GetMFDaflowBedElevationParamClassType : TMFDaflowBedElevationParamClass; virtual;
    function GetMFDaflowBedThicknessParamClassType : TMFDaflowBedThicknessParamClass; virtual;
    function GetMFDaflowBedSlopeParamClassType: TMFDaflowBedSlopeParamClass;
    function GetMFDaflowBedHydraulicConductivityParamClassType : TMFDaflowBedHydraulicConductivityParamClass; virtual;
    function GetMFDaflowUpstreamJunctionParamClassType : TMFDaflowUpstreamJunctionParamClass; virtual;
    function GetMFDaflowDownstreamJunctionParamClassType : TMFDaflowDownstreamJunctionParamClass; virtual;
    function GetMFDaflowUpstreamFlowFractionParamClassType : TMFDaflowUpstreamFlowFractionParamClass; virtual;
    function GetMFDaflowInitialFlowParamClassType : TMFDaflowInitialFlowParamClass; virtual;
    function GetMFDaflowTortuosityParamClassType : TMFDaflowTortuosityParamClass; virtual;
    function GetMFDaflowA0ParamClassType : TMFDaflowA0ParamClass; virtual;
    function GetMFDaflowA1ParamClassType : TMFDaflowA1ParamClass; virtual;
    function GetMFDaflowA2ParamClassType : TMFDaflowA2ParamClass; virtual;
    function GetMFDaflowW1ParamClassType : TMFDaflowW1ParamClass; virtual;
    function GetMFDaflowW2ParamClassType : TMFDaflowW2ParamClass; virtual;
    function GetMFDaflowPrintParamClassType : TMFDaflowPrintParamClass; virtual;
    function GetMFDaflowBoundaryFlowParamClassType : TMFDaflowBoundaryFlowParamClass; virtual;
    function GetMFDaflowOverridenBedElevationParamClassType : TMFDaflowOverridenBedElevationParamClass; virtual;
    function GetMFDaflowOverrideInitialFlowParamClassType : TMFDaflowOverridenInitialFlowParamClass; virtual;
    function GetMFDaflowIsNewBoundaryParamClassType : TMFDaflowIsNewBoundaryParamClass; virtual;
    function GetMFObjectObservationNameParamClassType : TMFObjectObservationNameParamClass; virtual;
    function GetMFHUF_ReferenceSurfaceParamClassType : TMFHUF_ReferenceSurfaceParamClass; virtual;

    function GetMFElasticStorageCoefficientParamType : TMFElasticStorageCoefficientParamClass; virtual;
    function GetMFInelasticStorageCoefficientParamType : TMFInelasticStorageCoefficientParamClass; virtual;

    function GetMFStartingHeadParamType : TMFStartingHeadParamClass; virtual;
    function GetMFVerticalHydraulicConductivityParamType : TMFVerticalHydraulicConductivityParamClass; virtual;
    function GetMFEquivalentThicknessParamType : TMFEquivalentThicknessParamClass; virtual;
    function GetMFEquivalentNumberParamType : TMFEquivalentNumberParamClass; virtual;
    function GetMFElasticSpecificStorageParamType : TMFElasticSpecificStorageParamClass; virtual;
    function GetMFInelasticSpecificStorageParamType : TMFInelasticSpecificStorageParamClass; virtual;
    function GetMFStreamGageOutputTypeParamType : TMFStreamGageOutputTypeParamClass; virtual;
    function GetMFSKStreamUpWidthParamType : TMFSKStreamUpWidthTypeParamClass; virtual;

    function GetMFDrainConductanceParamType : TMFDrainConductanceParamClass; virtual;
    function GetMFDrainReturnConductanceParamType : TMFDrainReturnConductanceParamClass; virtual;
    function GetMFGhbConductanceParamType : TMFGhbConductanceParamClass; virtual;
    function GetMFRiverConductanceParamType : TMFRiverConductanceParamClass; virtual;
    function GetMFFluidDensityParamType : TMFFluidDensityParamClass; virtual;
    function GetMFBoundaryDensityParamType : TMFBoundaryDensityParamClass; virtual;
    function GetMFDrainBottomElevParamType : TMFDrainBottomElevParamClass; virtual;
    function GetMFRiverBedThicknessParamType : TMFRiverBedThicknessParamClass; virtual;
    function GetMFLayerCountParamType : TMFLayerCountParamClass; virtual;
    function GetMFRowCountParamType : TMFRowCountParamClass; virtual;
    function GetMFColumnCountParamType : TMFColumnCountParamClass; virtual;
    function GetMFGridMOCParticleLayerCountParamType : TMFGridMOCParticleLayerCountParamClass; virtual;
    function GetMFGridMOCParticleRowCountParamType : TMFGridMOCParticleRowCountParamClass; virtual;
    function GetMFGridMOCParticleColumnCountParamType : TMFGridMOCParticleColumnCountParamClass; virtual;
    function GetMFGridMocParticleLocationParamType : TMFGridMocParticleLocationParamClass; virtual;
    function GetMFUpperBoundaryConcentrationParamType : TMFUpperBoundaryConcentrationParamClass; virtual;
    function GetMFLowerBoundaryConcentrationParamType : TMFLowerBoundaryConcentrationParamClass; virtual;
    function GetMFGridGwtUppBoundConcParamType : TMFGridGwtUppBoundConcParamClass; virtual;
    function GetMFGridGwtLowBoundConcParamType : TMFGridGwtLowBoundConcParamClass; virtual;
    function GetMFFluxVariableNameParamType : TMFFluxVariableNameParamClass; virtual;
    function GetMFFluxTypeParamType : TMFFluxTypeParamClass; virtual;
    function GetMFFluxStatParamType : TMFFluxStatParamClass; virtual;
    function GetMFFluxVariableRatioParamType : TMFFluxVariableRatioParamClass; virtual;
    function GetMFGWM_UseInPeriodParamType : TMFGWM_UseInPeriodParamClass; virtual;

    function GetMFHeadConstraintNameParamType : TMFHeadConstraintNameParamClass; virtual;
    function GetMFHeadConstraintTypeParamType : TMFHeadConstraintTypeParamClass; virtual;
    function GetMFHeadConstraintBoundaryParamType : TMFHeadConstraintBoundaryParamClass; virtual;
    function GetMFDrawdownConstraintNameParamType : TMFDrawdownConstraintNameParamClass; virtual;
    function GetMFDrawdownConstraintTypeParamType : TMFDrawdownConstraintTypeParamClass; virtual;
    function GetMFHeadDifferenceNameParamType : TMFHeadDifferenceNameParamClass; virtual;
    function GetMFHeadDifferenceValueParamType : TMFHeadDifferenceValueParamClass; virtual;
    function GetMFFirstParamType : TMFFirstParamClass; virtual;
    function GetMFGradientNameParamType : TMFGradientNameParamClass; virtual;
    function GetMFGradientValueParamType : TMFGradientValueParamClass; virtual;
    function GetMFGradientLengthParamType : TMFGradientLengthParamClass; virtual;
    function GetMFStreamFlowNameParamType : TMFStreamFlowNameParamClass; virtual;
    function GetMFStreamflowValueParamType : TMFStreamflowValueParamClass; virtual;
    function GetMFStreamDepletionNameParamType : TMFStreamDepletionNameParamClass; virtual;
    function GetMFStreamDepletionValueParamType : TMFStreamDepletionValueParamClass; virtual;
    function GetMFFluxMinimumParamType : TMFFluxMinimumParamClass; virtual;
    function GetMFFluxMaximumParamType : TMFFluxMaximumParamClass; virtual;
    function GetMFFluxReferenceParamType : TMFFluxReferenceParamClass; virtual;
    function GetMFFluxBaseParamType : TMFFluxBaseParamClass; virtual;
    function GetMFGradientStartElevationParamType : TMFGradientStartElevationParamClass; virtual;
    function GetMFGradientEndElevationParamType : TMFGradientEndElevationParamClass; virtual;

    function GetMFSfr2StreambedTopElevParamType : TMFSfr2StreambedTopElevParamClass; virtual;
    function GetMFSfr2StreambedThicknessParamType : TMFSfr2StreambedThicknessParamClass; virtual;
    function GetMFSfr2SaturatedWaterContentParamType : TMFSfr2SaturatedWaterContentParamClass; virtual;
    function GetMFSfr2InitialWaterContentParamType : TMFSfr2InitialWaterContentParamClass; virtual;
    function GetMFSfr2BrooksCoreyExponentParamType : TMFSfr2BrooksCoreyExponentParamClass; virtual;
    function GetMFSfr2UnsatZoneHydraulicConductivityParamType : TMFSfr2UnsatZoneHydraulicConductivityParamClass; virtual;
    function GetMFSfr2UpstreamSaturatedWaterContentParamType :          TMFSfr2UpstreamSaturatedWaterContentParamClass; virtual;
    function GetMFSfr2UpstreamInitialWaterContentParamType :            TMFSfr2UpstreamInitialWaterContentParamClass; virtual;
    function GetMFSfr2UpstreamBrooksCoreyExponentParamType :            TMFSfr2UpstreamBrooksCoreyExponentParamClass; virtual;
    function GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType : TMFSfr2UpstreamUnsatZoneHydraulicConductivityParamClass; virtual;
    function GetMFSfr2DownstreamSaturatedWaterContentParamType :          TMFSfr2DownstreamSaturatedWaterContentParamClass; virtual;
    function GetMFSfr2DownstreamInitialWaterContentParamType :            TMFSfr2DownstreamInitialWaterContentParamClass; virtual;
    function GetMFSfr2DownstreamBrooksCoreyExponentParamType :            TMFSfr2DownstreamBrooksCoreyExponentParamClass; virtual;
    function GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType : TMFSfr2DownstreamUnsatZoneHydraulicConductivityParamClass; virtual;

    function GetMFGageDiversioParamType : TMFGageDiversionParamClass; virtual;
    function GetMFUnsatGageParamType : TMFUnsatGageParamClass; virtual;
    function GetMFUnsatProfileGageParamType : TMFUnsatProfileGageParamClass; virtual;
    function GetMFMoc3dParticleObsParamType : TMFMoc3dParticleObsParamClass; virtual;
    function GetMFGridMocParticleObservationParamType : TMFGridMocParticleObservationParamClass; virtual;
    function GetMFMNW_OutputFlagParamType : TMFMNW_OutputFlagParamClass; virtual;
    function GetMFLateralBoundaryConcentrationParamType : TMFLateralBoundaryConcentrationParamClass; virtual;
    function GetMFGridGwtLateralBoundConcParamType : TMFGridGwtLateralBoundConcParamClass; virtual;

    function GetMFUpperMpathElevationParamType : TMFUpperMpathElevationParamClass; virtual;
    function GetMFLowerMpathElevationParamType : TMFLowerMpathElevationParamClass; virtual;
    function GetMFMNW_IsPTOB_ObservationParamType : TMFMNW_IsPTOB_ObservationParamClass; virtual;

    function GetMFUzfSaturatedKzParamType : TMFUzfSaturatedKzParamClass; virtual;
    function GetMFUzfBrooksCoreyEpsilonParamType : TMFUzfBrooksCoreyEpsilonParamClass; virtual;
    function GetMFUzfSaturatedWaterContentParamType : TMFUzfSaturatedWaterContentParamClass; virtual;
    function GetMFUzfInitialWaterContentParamType : TMFUzfInitialWaterContentParamClass; virtual;
    function GetMFUzfExtinctionDepthParamType : TMFUzfExtinctionDepthParamClass; virtual;
    function GetMFUzfExtinctionWaterContentParamType : TMFUzfExtinctionWaterContentParamClass; virtual;
    function GetMFUzfInfiltrationRateParamType : TMFUzfInfiltrationRateParamClass; virtual;
    function GetMFUzfPotentialEvapotranspirationParamType : TMFUzfPotentialEvapotranspirationParamClass; virtual;
    function GetMFUzfLayerParamType : TMFUzfLayerParamClass; virtual;
    function GetMFUzfStreamLakeParamType : TMFUzfStreamLakeParamClass; virtual;
    function GetMFUzfOutputParamType : TMFUzfOutputParamClass; virtual;

    function GetMFGridUzfSaturatedKzParamType : TMFGridUzfSaturatedKzParamClass; virtual;
    function GetMFGridUzfBrooksCoreyEpsilonParamType : TMFGridUzfBrooksCoreyEpsilonParamClass; virtual;
    function GetMFGridUzfSaturatedWaterContentParamType : TMFGridUzfSaturatedWaterContentParamClass; virtual;
    function GetMFGridUzfInitialWaterContentParamType : TMFGridUzfInitialWaterContentParamClass; virtual;
    function GetMFGridUzfExtinctionDepthParamType : TMFGridUzfExtinctionDepthParamClass; virtual;
    function GetMFGridUzfExtinctionWaterContentParamType : TMFGridUzfExtinctionWaterContentParamClass; virtual;
    function GetMFGridUzfModflowLayerParamType : TMFGridUzfModflowLayerParamClass; virtual;
    function GetMFGridUzfDownstreamStreamOrLakeParamType : TMFGridUzfDownstreamStreamOrLakeParamClass; virtual;
    function GetMFGridUzfOutputChoiceParamType : TMFGridUzfOutputChoiceParamClass; virtual;
    function GetMFGeostaticStressParamType : TMFGeostaticStressParamClass; virtual;
    function GetMFUnsaturatedSpecificGravityParamType : TMFUnsaturatedSpecificGravityParamClass; virtual;
    function GetMFSaturatedSpecificGravityParamType : TMFSaturatedSpecificGravityParamClass; virtual;

    function GetMFSwtThicknessParamType : TMFSwtThicknessParamClass; virtual;
    function GetMFInitialElasticSpecificStorageParamType : TMFInitialElasticSpecificStorageParamClass; virtual;
    function GetMFInitialInelasticSpecificStorageParamType : TMFInitialInelasticSpecificStorageParamClass; virtual;
    function GetMFCompressionIndexParamType : TMFCompressionIndexParamClass; virtual;
    function GetMFRecompressionIndexParamType : TMFRecompressionIndexParamClass; virtual;
    function GetMFInitialVoidRatioParamType : TMFInitialVoidRatioParamClass; virtual;
    function GetMFInitialCompactionParamType : TMFInitialCompactionParamClass; virtual;
    function GetMFInitialEffectiveStressOffsetParamType : TMFInitialEffectiveStressOffsetParamClass; virtual;
    function GetMFInitialPreconsolidationStressParamType : TMFInitialPreconsolidationStressParamClass; virtual;

    function GetMFConcObsParamType : TMFConcObsParamClass; virtual;
    function GetMFSpeciesParamType : TMFSpeciesParamClass; virtual;
    function GetMFConcWeightParamType : TMFConcWeightParamClass; virtual;
    function GetMFObservationWeightParamType : TMFObservationWeightParamClass; virtual;
    function GetMFViscosityParamType : TMFViscosityParamClass; virtual;
    function GetMFChdFluidDensityParamType : TMFChdFluidDensityParamClass; virtual;
    function GetMFSeawatDensityOptionParamType : TMFSeawatDensityOptionParamClass; virtual;

    function GetMF_MNW2_WellIdParamType : TMF_MNW2_WellIdParamClass; virtual;
    function GetMF_MNW2_NodeCountParamType : TMF_MNW2_NodeCountParamClass; virtual;
    function GetMF_MNW2_LossTypeParamType : TMF_MNW2_LossTypeParamClass; virtual;
    function GetMF_MNW2_WellRadiusParamType : TMF_MNW2_WellRadiusParamClass; virtual;
    function GetMF_MNW2_SkinRadiusParamType : TMF_MNW2_SkinRadiusParamClass; virtual;
    function GetMF_MNW2_SkinKParamType : TMF_MNW2_SkinKParamClass; virtual;
    function GetMF_MNW2_BParamType : TMF_MNW2_BParamClass; virtual;
    function GetMF_MNW2_CParamType : TMF_MNW2_CParamClass; virtual;
    function GetMF_MNW2_PParamType : TMF_MNW2_PParamClass; virtual;
    function GetMF_MNW2_CellToWellConductanceParamType : TMF_MNW2_CellToWellConductanceParamClass; virtual;
    function GetMF_MNW2_SpecifyPumpParamType : TMF_MNW2_SpecifyPumpParamClass; virtual;
    function GetMF_MNW2_ConstrainPumpingParamType : TMF_MNW2_ConstrainPumpingParamClass; virtual;
    function GetMF_MNW2_PartialPenetrationFlagParamType : TMF_MNW2_PartialPenetrationFlagParamClass; virtual;
    function GetMF_MNW2_PumpTypeParamType : TMF_MNW2_PumpTypeParamClass; virtual;
    function GetMF_MNW2_PumpElevationParamType : TMF_MNW2_PumpElevationParamClass; virtual;
    function GetMF_MNW2_PumpingLimitTypeParamType : TMF_MNW2_PumpingLimitTypeParamClass; virtual;
    function GetMF_MNW2_LimitingWaterLevelParamType : TMF_MNW2_LimitingWaterLevelParamClass; virtual;
    function GetMF_MNW2_InactivationPumpingRateParamType : TMF_MNW2_InactivationPumpingRateParamClass; virtual;
    function GetMF_MNW2_ReactivationPumpingRateParamType : TMF_MNW2_ReactivationPumpingRateParamClass; virtual;
    function GetMF_MNW2_DischargeElevationParamType : TMF_MNW2_DischargeElevationParamClass; virtual;
    function GetMF_MNW2_TopWellScreenParamType : TMF_MNW2_TopWellScreenParamClass; virtual;
    function GetMF_MNW2_BottomWellScreenParamType : TMF_MNW2_BottomWellScreenParamClass; virtual;
    function GetMF_MNW2_ActiveParamType : TMF_MNW2_ActiveClass; virtual;
    function GetMF_MNW2_PumpingRateParamType : TMF_MNW2_PumpingRateParamClass; virtual;
    function GetMF_MNW2_HeadCapacityMultiplierParamType : TMF_MNW2_HeadCapacityMultiplierParamClass; virtual;
    function GetMF_MNW2_OrderParamType : TMF_MNW2_OrderParamClass; virtual;
    function GetMF_MNW2_UpperElevParamType : TMF_MNW2_UpperElevParamClass; virtual;
    function GetMF_MNW2_LowerElevParamType : TMF_MNW2_LowerElevParamClass; virtual;
    function GetMF_MNW2_MonitorWellFlowParamType : TMF_MNW2_MonitorWellParamClass; virtual;
    function GetMF_MNW2_MonitorExternalFlowParamType : TMF_MNW2_MonitorExternalFlowParamClass; virtual;
    function GetMF_MNW2_MonitorInternalFlowParamType : TMF_MNW2_MonitorInternalFlowParamClass; virtual;
    function GetMF_MNW2_MonitorConcentrationParamType : TMF_MNW2_MonitorConcentrationParamClass; virtual;

    function GetMF_GwmNameParamType : TMF_GwmNameParamClass; virtual;
    function GetMF_GwmElevationParamType : TMF_GwmElevationParamClass; virtual;
    function GetMF_GwmSegmentParamType : TMF_GwmSegmentParamClass; virtual;
    function GetMF_GwmZoneNumberParamType : TMF_GwmZoneNumberParamClass; virtual;
    function GetMF_GwmStressPeriodParamType : TMF_GwmStressPeriodParamClass; virtual;

    function GetMF_GridGwmZoneParamType : TMF_GridGwmZoneParamClass; virtual;
  end;


implementation

{$IFDEF Debug}
uses DebugUnit;
{$ENDIF}


function TModflowTypesClass.GetModflowFormType : TModflowFormClass;
begin
  result := TfrmMODFLOW;
    {$IFDEF Debug}
      WriteDebugOutput('TModflowTypesClass.GetModflowFormType, result := TfrmMODFLOW;');
    {$ENDIF}
end;

function TModflowTypesClass.GetModflowLayerStructureType : TModflowLayerStructureClass;
begin
  result := TMFLayerStructure;
end;

function TModflowTypesClass.GetGeologicUnitType : TMFGeologicUnitClass;
begin
  result := TMFGeologicUnit;
end;

function TModflowTypesClass.GetMFGeolUnitGroupLayerType : TMFGeolUnitGroupLayerClass ;
begin
  result := TMFGeolUnitGroupLayer;
end;

function TModflowTypesClass.GetBottomElevLayerType : TBottomElevLayerClass;
begin
  result := TBottomElevLayer;
end;

function TModflowTypesClass.GetMFDomainOutType : TMFDomainOutLayerClass;
begin
  result := TMFDomainOut;
end;

function TModflowTypesClass.GetLineDrainLayerType : TMFLineDrainLayerClass;
begin
  result := TLineDrainLayer;
end;

function TModflowTypesClass.GetAreaDrainLayerType : TMFAreaDrainLayerClass;
begin
  result := TAreaDrainLayer;
end;

function TModflowTypesClass.GetETLayerType : TMFETLayerClass;
begin
  result := TETLayer;
end;

function TModflowTypesClass.GetPointGHBLayerType : TMFPointGHBLayerClass;
begin
  result := TPointGHBLayer;
end;

function TModflowTypesClass.GetLineGHBLayerType : TMFLineGHBLayerClass;
begin
  result := TLineGHBLayer;
end;

function TModflowTypesClass.GetAreaGHBLayerType : TMFAreaGHBLayerClass;
begin
  result := TAreaGHBLayer;
end;

function TModflowTypesClass.GetGridLayerType : TMFGridLayerClass;
begin
  result := TMFGridLayer;
end;

function TModflowTypesClass.GetDensityLayerType : TMFDensityLayerClass;
begin
  result := TMFDensityLayer;
end;

function TModflowTypesClass.GetHydraulicCondLayerType : TMFHydraulicCondLayerClass;
begin
  result := THydraulicCondLayer;
end;

function TModflowTypesClass.GetInactiveLayerType : TMFInactiveLayerClass;
begin
  result := TInactiveLayer;
end;

function TModflowTypesClass.GetInitialHeadLayerType : TMFInitialHeadLayerClass;
begin
  result := TInitialHeadLayer;
end;

function TModflowTypesClass.GetMapLayerType : TMFMapLayerClass;
begin
  result := TMFMapLayer;
end;

function TModflowTypesClass.GetMOCInitialConcLayerType : TMOCInitialConcLayerClass;
begin
  result := TMOCInitialConcLayer;
end;

function TModflowTypesClass.GetMOCObsWellLayerType : TMOCObsWellLayerClass;
begin
  result := TMOCObsWellLayer;
end;

function TModflowTypesClass.GetMOCParticleRegenLayerType : TMOCParticleRegenLayerClass;
begin
  result := TMOCParticleRegenLayer;
end;

function TModflowTypesClass.GetMOCPorosityLayerType : TMOCPorosityLayerClass;
begin
  result := TMOCPorosityLayer;
end;

function TModflowTypesClass.GetPrescribedHeadLayerType : TMFPrescribedHeadLayerClass;
begin
  result := TPrescribedHeadLayer;
end;

function TModflowTypesClass.GetRechargeLayerType : TMFRechargeLayerClass;
begin
  result := TRechargeLayer;
end;

function TModflowTypesClass.GetMOCRechargeConcLayerType : TMOCRechargeConcLayerClass;
begin
  result := TMOCRechargeConcLayer;
end;

function TModflowTypesClass.GetMFLineRiverLayerType : TMFLineRiverLayerClass;
begin
  result := TLineRiverLayer;
end;

function TModflowTypesClass.GetMFAreaRiverLayerType : TMFAreaRiverLayerClass;
begin
  result := TAreaRiverLayer;
end;

function TModflowTypesClass.GetMFSpecStorageLayerType : TMFSpecStorageLayerClass;
begin
  result := TSpecStorageLayer;
end;

function TModflowTypesClass.GetMFSpecYieldLayerType : TMFSpecYieldLayerClass;
begin
  result := TSpecYieldLayer;
end;

function TModflowTypesClass.GetMFTopElevLayerType : TMFTopElevLayerClass;
begin
  result := TTopElevLayer;
end;

function TModflowTypesClass.GetMFWellLayerType : TMFWellLayerClass;
begin
  result := TWellLayer;
end;

function TModflowTypesClass.GetMFWettingLayerType : TMFWettingLayerClass;
begin
  result := TWettingLayer;
end;

function TModflowTypesClass.GetMFStreamLayerType : TMFStreamLayerClass;
begin
  result := TStreamLayer;
end;

function TModflowTypesClass.GetMFHFBLayerType : TMFHFBLayerClass;
begin
  result := THFBLayer;
end;

function TModflowTypesClass.GetMFPointFHBLayerType : TMFPointFHBLayerClass;
begin
  result := TPointFHBLayer;
end;

function TModflowTypesClass.GetMFLineFHBLayerType : TMFLineFHBLayerClass;
begin
  result := TLineFHBLayer;
end;

function TModflowTypesClass.GetMFAreaFHBLayerType : TMFAreaFHBLayerClass;
begin
  result := TAreaFHBLayer;
end;

function TModflowTypesClass.GetMODPATHLayerType : TMODPATHLayerClass;
begin
  result := TMODPATHLayer;
end;

function TModflowTypesClass.GetZoneBudLayerType: TZoneBudLayerClass;
begin
  result := TZoneBudLayer;
end;

function TModflowTypesClass.GetMODPATHZoneLayerType: TMODPATHZoneLayerClass;
begin
  result := TModpathZoneLayer;
end;






function TModflowTypesClass.GetMFDrainTimeParamListType : TMFDrainTimeParamListClass;
begin
  result := TDrainTimeParamList;
end;

function TModflowTypesClass.GetETTimeParamListType : TMFETTimeParamListClass;
begin
  result := TETTimeParamList;
end;

function TModflowTypesClass.GetGHBTimeParamListType : TMFGHBTimeParamListClass;
begin
  result := TGHBTimeParamList;
end;

function TModflowTypesClass.GetMFGeologicUnitParametersType : TMFGeologicUnitParametersClass;
begin
  result := TGeologicUnitParameters;
end;

function TModflowTypesClass.GetMOCElevParamListType : TMOCElevParamListClass;
begin
  result := TMOCElevParamList;
end;

function TModflowTypesClass.GetMFRechElevParamListType : TMFRechargeTimeParamListClass;
begin
  result := TRechargeTimeParamList;
end;

function TModflowTypesClass.GetMOCRechargeConcTimeParamListType : TMOCRechargeConcTimeParamListClass;
begin
  result := TRechargeConcTimeParamList;
end;

function TModflowTypesClass.GetMFRiverTimeParamListType : TMFRiverTimeParamListClass;
begin
  result := TRiverTimeParamList;
end;

function TModflowTypesClass.GetMFWellTimeParamListType : TMFWellTimeParamListClass;
begin
  result := TWellTimeParamList;
end;

function TModflowTypesClass.GetMFStreamTimeParamListType : TMFStreamTimeParamListClass;
begin
  result := TStreamTimeParamList;
end;

function TModflowTypesClass.GetMFFHBPointTimeParamListType : TMFFHBPointTimeParamListClass;
begin
  result := TFHBPointTimeParamList;
end;

function TModflowTypesClass.GetMFFHBLineTimeParamListType : TMFFHBLineTimeParamListClass;
begin
  result := TFHBLineTimeParamList;
end;

function TModflowTypesClass.GetMFFHBAreaTimeParamListType : TMFFHBAreaTimeParamListClass;
begin
  result := TFHBAreaTimeParamList;
end;

function TModflowTypesClass.GetMFMODPATHTimeParamListType : TMFMODPATHTimeParamListClass;
begin
  result := TMODPATHTimeParamList;
end;

// parameter types

function TModflowTypesClass.GetMFBottomElevParamType: TMFBottomElevParamClass;
begin
  result := TBottomElevParam
end;

function TModflowTypesClass.GetMFConcentrationParamType: TMFConcentrationParamClass;
begin
  result := TConcentration
end;

function TModflowTypesClass.GetMFConductanceParamType: TMFConductanceParamClass;
begin
  result := TConductance
end;

function TModflowTypesClass.GetMFDensityParamType: TMFDensityParamClass;
begin
  result := TDensityParam
end;

function TModflowTypesClass.GetMFDomDensityParamType: TMFDomDensityParamClass;
begin
  result := TDomDensityParam
end;

function TModflowTypesClass.GetMFDrainElevationParamType: TMFDrainElevationParamClass;
begin
  result := TDrainElevationParam
end;

function TModflowTypesClass.GetMFDrainOnParamType: TMFDrainOnParamClass;
begin
  result := TDrainOnParam
end;

function TModflowTypesClass.GetMFETExtDepthParamType: TMFETExtDepthParamClass;
begin
  result := TETExtDepth
end;

function TModflowTypesClass.GetMFETExtFluxParamType: TMFETExtFluxParamClass;
begin
  result := TETExtFlux
end;

function TModflowTypesClass.GetMFETSurfaceParamType: TMFETSurfaceParamClass;
begin
  result := TETSurface
end;

function TModflowTypesClass.GetMFFHBBotElevParamType: TMFFHBBotElevParamClass;
begin
  result := TFHBBotElevParam
end;

function TModflowTypesClass.GetMFFHBAreaFluxParamType: TMFHBAreaFluxParamClass;
begin
  result := TFHBAreaFluxParam
end;

function TModflowTypesClass.GetMFFHBFluxConcParamType: TMFHBFluxConcParamClass;
begin
  result := TFHBFluxConcParam
end;

function TModflowTypesClass.GetMFFHBHeadConcParamType: TMFHBHeadConcParamClass;
begin
  result := TFHBHeadConcParam
end;

function TModflowTypesClass.GetMFFHBLineFluxParamType: TMFHBLineFluxParamClass;
begin
  result := TFHBLineFluxParam
end;

function TModflowTypesClass.GetMFFHBLineHeadEndParamType: TMFHBLineHeadEndParamClass;
begin
  result := TFHBLineHeadEndParam
end;

function TModflowTypesClass.GetMFFHBLineHeadStartParamType: TMFHBLineHeadStartParamClass;
begin
  result := TFHBLineHeadStartParam
end;

function TModflowTypesClass.GetMFFHBPointAreaHeadParamType: TMFFHBPointAreaHeadParamClass;
begin
  result := TFHBPointAreaHeadParam
end;

function TModflowTypesClass.GetMFFHBPointFluxParamType: TMFFHBPointFluxParamClass;
begin
  result := TFHBPointFluxParam
end;

function TModflowTypesClass.GetMFFHBTopElevParamType: TMFFHBTopElevParamClass;
begin
  result := TFHBTopElevParam
end;

function TModflowTypesClass.GetMFGHBHeadParamType: TMFGHBHeadParamClass;
begin
  result := TGHBHeadParam
end;

function TModflowTypesClass.GetMFGridBottomElevParamType: TMFGridBottomElevParamClass;
begin
  result := TGridBottomElev
end;

function TModflowTypesClass.GetMFGridDrainParamType: TMFGridDrainParamClass;
begin
  result := TGridDrain
end;

function TModflowTypesClass.GetMFGridETSurfParamType: TMFGridETSurfParamClass;
begin
  result := TGridETSurf
end;

function TModflowTypesClass.GetMFGridETExtinctionDepthParamType: TMFGridETExtinctionDepthParamClass;
begin
  result := TGridETExtinctionDepth
end;

function TModflowTypesClass.GetMFGridFHBParamType: TMFGridFHBParamClass;
begin
  result := TGridFHB
end;

function TModflowTypesClass.GetMFGridGHBParamType: TMFGridGHBParamClass;
begin
  result := TGridGHB
end;

function TModflowTypesClass.GetMFGridHFBParamType: TMGridHFBParamClass;
begin
  result := TGridHFB
end;

function TModflowTypesClass.GetMFGridInitialHeadParamType: TMFGridInitialHeadParamClass;
begin
  result := TGridInitialHead
end;

function TModflowTypesClass.GetMFGridKxParamType: TMFGridKxParamClass;
begin
  result := TGridKx
end;

function TModflowTypesClass.GetMFGridKzParamType: TMFGridKzParamClass;
begin
  result := TGridKz
end;

function TModflowTypesClass.GetMFGridMOCInitConcParamType: TMFGridMOCInitConcParamClass;
begin
  result := TGridMOCInitConc
end;

function TModflowTypesClass.GetMFGridMOCParticleRegenParamType: TMFGridMOCParticleRegenParamClass;
begin
  result := TGridMOCParticleRegen
end;

function TModflowTypesClass.GetMFGridMOCPorosityParamType: TMFGridMOCPorosityParamClass;
begin
  result := TGridMOCPorosity
end;

function TModflowTypesClass.GetMFGridMOCSubGridParamType: TMFGridMOCSubGridParamClass;
begin
  result := TGridMOCSubGrid
end;

function TModflowTypesClass.GetMFGridModpathZoneParamType: TMFGridModpathZoneParamClass;
begin
  result := TGridModpathZone
end;

function TModflowTypesClass.GetMFGridRechElevParamType: TMFGridRechElevParamClass;
begin
  result := TGridRechElev
end;

function TModflowTypesClass.GetMFGridRiverParamType: TMFGridRiverParamClass;
begin
  result := TGridRiver
end;

function TModflowTypesClass.GetMFGridSpecStorParamType: TMFGridSpecStorParamClass;
begin
  result := TGridSpecStor
end;

function TModflowTypesClass.GetMFGridSpecYieldParamType: TMFGridSpecYieldParamClass;
begin
  result := TGridSpecYield
end;

function TModflowTypesClass.GetMFGridStreamParamType: TMFGridStreamParamClass;
begin
  result := TGridStream
end;

function TModflowTypesClass.GetMFGridThicknessParamType: TMFGridThicknessParamClass;
begin
  result := TGridThickness
end;

function TModflowTypesClass.GetMFGridTopElevParamType: TMFGridTopElevParamClass;
begin
  result := TGridTopElev
end;

function TModflowTypesClass.GetMFGridWellParamType: TMFGridWellParamClass;
begin
  result := TGridWell
end;

function TModflowTypesClass.GetMFGridWettingParamType: TMFGridWettingParamClass;
begin
  result := TGridWetting
end;

function TModflowTypesClass.GetMFGridZoneBudgetParamType: TMFGridZoneBudgetParamClass;
begin
  result := TGridZoneBudget
end;

function TModflowTypesClass.GetMFHFBBarrierThickParamType: TMFHFBBarrierThickParamClass;
begin
  result := THFBBarrierThickParam
end;

function TModflowTypesClass.GetMFHFBHydCondParamType: TMFHFBHydCondParamClass;
begin
  result := THFBHydCondParam
end;

function TModflowTypesClass.GetMFIBoundGridParamType: TMFIBoundGridParamClass;
begin
  result := TIBoundGridParam
end;

function TModflowTypesClass.GetMFIFACEParamType: TMFIFACEParamClass;
begin
  result := TIFACEParam
end;

function TModflowTypesClass.GetMFInactiveParamType: TMFInactiveParamClass;
begin
  result := TInactiveParam
end;

function TModflowTypesClass.GetMFInitialHeadParamType: TMFInitialHeadParamClass;
begin
  result := TInitialHeadParam
end;

function TModflowTypesClass.GetMFKxParamType: TMFKxParamClass;
begin
  result := TKx
end;

function TModflowTypesClass.GetMFKzParamType: TMFKzParamClass;
begin
  result := TKz
end;

function TModflowTypesClass.GetMFMOCInitialConcParamType: TMFMOCInitialConcParamClass;
begin
  result := TMOCInitialConcParam
end;

function TModflowTypesClass.GetMFMOCObsElevParamType: TMFMOCObsElevParamClass;
begin
  result := TMOCObsElev
end;

function TModflowTypesClass.GetMFMOCParticleRegenParamType: TMFMOCParticleRegenParamClass;
begin
  result := TMOCParticleRegenParam
end;

function TModflowTypesClass.GetMFMOCPorosityParamType: TMFMOCPorosityParamClass;
begin
  result := TMOCPorosityParam
end;

function TModflowTypesClass.GetMFMODPATH_ReleaseTimeParamType: TMFMODPATH_ReleaseTimeParamClass;
begin
  result := TMODPATH_ReleaseTimeParam
end;

function TModflowTypesClass.GetMFMODPATH_XCountParamType: TMFMODPATH_XCountParamClass;
begin
  result := TMODPATH_XCount_Param
end;

function TModflowTypesClass.GetMFMODPATH_YCountParamType: TMFMODPATH_YCountParamClass;
begin
  result := TMODPATH_YCount_Param
end;

function TModflowTypesClass.GetMFMODPATH_ZCountParamType: TMFMODPATH_ZCountParamClass;
begin
  result := TMODPATH_ZCount_Param
end;

function TModflowTypesClass.GetMFMODPATHPartIfaceParamType: TMFMODPATHPartIfaceParamClass;
begin
  result := TMODPATHPartIface
end;

{function TModflowTypesClass.GetMFModpathTime1ParamType: TMFModpathTime1ParamClass;
begin
  result := TModpathTime1Param
end;

function TModflowTypesClass.GetMFModpathTime2ParamType: TMFModpathTime2ParamClass;
begin
  result := TModpathTime2Param
end;

function TModflowTypesClass.GetMFModpathTime3ParamType: TMFModpathTime3ParamClass;
begin
  result := TModpathTime3Param
end;

function TModflowTypesClass.GetMFModpathTime4ParamType: TMFModpathTime4ParamClass;
begin
  result := TModpathTime4Param
end;

function TModflowTypesClass.GetMFModpathTime5ParamType: TMFModpathTime5ParamClass;
begin
  result := TModpathTime5Param
end; }

function TModflowTypesClass.GetMFModpathZoneParamType: TMFModpathZoneParamClass;
begin
  result := TModpathZoneParam
end;

function TModflowTypesClass.GetMFPrescribedHeadParamType: TMFPrescribedHeadParamClass;
begin
  result := TPrescribedHeadParam
end;

function TModflowTypesClass.GetMFRechConcParamType: TMFRechConcParamClass;
begin
  result := TRechConcParam
end;

function TModflowTypesClass.GetMFRechElevParamType: TMFRechElevParamClass;
begin
  result := TRechElevParam
end;

function TModflowTypesClass.GetMFRechStressParamType: TMFRechStressParamClass;
begin
  result := TRechStressParam
end;

function TModflowTypesClass.GetMFRiverBottomParamType: TMFRiverBottomParamClass;
begin
  result := TRiverBottomParam
end;

function TModflowTypesClass.GetMFRiverStageParamType: TMFRiverStageParamClass;
begin
  result := TRiverStageParam
end;

function TModflowTypesClass.GetMFSpecStorageParamType: TMFSpecStorageParamClass;
begin
  result := TSpecStorageParam
end;

function TModflowTypesClass.GetMFSpecYieldParamType: TMFSpecYieldParamClass;
begin
  result := TSpecYieldParam
end;

function TModflowTypesClass.GetMFStreamDivSegNumParamType: TMFStreamDivSegNumParamClass;
begin
  result := TStreamDivSegNum
end;

function TModflowTypesClass.GetMFStreamDownBotElevParamType: TMFStreamDownBotElevParamClass;
begin
  result := TStreamDownBotElev
end;

function TModflowTypesClass.GetMFStreamDownSegNumParamType: TMFStreamDownSegNumParamClass;
begin
  result := TStreamDownSegNum
end;

function TModflowTypesClass.GetMFStreamDownStageParamType: TMFStreamDownStageParamClass;
begin
  result := TStreamDownStage
end;

function TModflowTypesClass.GetMFStreamDownTopElevParamType: TMFStreamDownTopElevParamClass;
begin
  result := TStreamDownTopElev
end;

function TModflowTypesClass.GetMFStreamDownWidthParamType: TMFStreamDownWidthParamClass;
begin
  result := TStreamDownWidthParam
end;

function TModflowTypesClass.GetMFStreamFlowParamType: TMFStreamFlowParamClass;
begin
  result := TStreamFlow
end;

function TModflowTypesClass.GetMFStreamHydCondParamType: TMFStreamHydCondParamClass;
begin
  result := TStreamHydCondParam
end;

function TModflowTypesClass.GetMFStreamRoughParamType: TMFStreamRoughParamClass;
begin
  result := TStreamRough
end;

function TModflowTypesClass.GetMFStreamSegNumParamType: TMFStreamSegNumParamClass;
begin
  result := TStreamSegNum
end;

function TModflowTypesClass.GetMFStreamSlopeParamType: TMFStreamSlopeParamClass;
begin
  result := TStreamSlope
end;

function TModflowTypesClass.GetMFStreamUpBotElevParamType: TMFStreamUpBotElevParamClass;
begin
  result := TStreamUpBotElev
end;

function TModflowTypesClass.GetMFStreamUpStageParamType: TMFStreamUpStageParamClass;
begin
  result := TStreamUpStage
end;

function TModflowTypesClass.GetMFStreamUpTopElevParamType: TMFStreamUpTopElevParamClass;
begin
  result := TStreamUpTopElev
end;

function TModflowTypesClass.GetMFStreamUpWidthParamType: TMFStreamUpWidthParamClass;
begin
  result := TStreamUpWidthParam
end;

function TModflowTypesClass.GetMFTopElevParamType: TMFTopElevParamClass;
begin
  result := TTopElevParam
end;

function TModflowTypesClass.GetMFWellBottomParamType: TMFWellBottomParamClass;
begin
  result := TWellBottomParam
end;

function TModflowTypesClass.GetMFWellStressParamType: TMFWellStressParamClass;
begin
  result := TWellStressParam
end;

function TModflowTypesClass.GetMFWellTopParamType: TMFWellTopParamClass;
begin
  result := TWellTopParam
end;

function TModflowTypesClass.GetMFWettingFlagParamType: TMFWettingFlagParamClass;
begin
  result := TWettingFlagParam
end;

function TModflowTypesClass.GetMFWettingThreshParamType: TMFWettingThreshParamClass;
begin
  result := TWettingThreshParam
end;

function TModflowTypesClass.GetMFZoneBudZoneParamType: TMFZoneBudZoneParamClass;
begin
  result := TZoneBudZone
end;

function TModflowTypesClass.GetRunModflowType: TRunModflowClass;
begin
  result := TfrmRun;
end;

function TModflowTypesClass.GetPostModflowType: TPostModflowClass;
begin
  result := TfrmMODFLOWPostProcessing;
end;

function TModflowTypesClass.GetMFMODPATH_FirstLayerParamType: TMFMODPATH_FirstLayerParamClass;
begin
  result := TMODPATH_FirstLayerParam;
end;

function TModflowTypesClass.GetMFMODPATH_FirstTimeParamType: TMFMODPATH_FirstTimeParamClass;
begin
  result := TMODPATH_FirstTimeParam;
end;

function TModflowTypesClass.GetMFMODPATH_LastLayerParamType: TMFMODPATH_LastLayerParamClass;
begin
  result := TMODPATH_LastLayerParam;
end;

function TModflowTypesClass.GetMFMODPATH_LastTimeParamType: TMFMODPATH_LastTimeParamClass;
begin
  result := TMODPATH_LastTimeParam;
end;

function TModflowTypesClass.GetMODPATHPostLayerType: TMODPATHPostLayerClass;
begin
  result := TMODPATHPostLayer;
end;

function TModflowTypesClass.GetMOCTransSubGridLayerType: TMOCTransSubGridLayerClass;
begin
  result := TMOCTransSubGridLayer;
end;

function TModflowTypesClass.GetMFMOCTransSubGridParamType: TMFMOCTransSubGridParamClass;
begin
  result := TMOCTransSubGridParam
end;

function TModflowTypesClass.GetMFPostProcessingGroupLayerType: TMFPostProcessingGroupLayerClass;
begin
  result := TMFPostProcessingGroupLayer;
end;

function TModflowTypesClass.GetSelectPostFileType: TSelectPostFileClass;
begin
  result := TfrmSelectPostFile;
end;

function TModflowTypesClass.GetMFTransmisivityLayerType: TMFTransmisivityLayerClass;
begin
  result := TTransmisivityLayer;
end;

function TModflowTypesClass.GetMFTransmisivityParamType: TMFTransmisivityParamClass;
begin
  result := TTransmisivityParam;
end;

function TModflowTypesClass.GetMFVcontLayerType: TMFVcontLayerClass;
begin
  result := TVcontLayer;
end;

function TModflowTypesClass.GetMFVcontParamType: TMFVcontParamClass;
begin
  result := TVcontParam;
end;

function TModflowTypesClass.GetMFConfStorageLayerType: TMFConfStorageLayerClass;
begin
  result := TConfStorageLayer;
end;

function TModflowTypesClass.GetMFConfStorageParamType: TMFConfStorageParamClass;
begin
  result := TConfStorageParam;
end;

function TModflowTypesClass.GetMFGridConfStoreParamType: TMFGridConfStoreParamClass;
begin
  result := TGridConfStor;
end;

function TModflowTypesClass.GetMFGridTransParamType: TMFGridTransParamClass;
begin
  result := TGridTrans;
end;

function TModflowTypesClass.GetMFGridVContParamType: TMFGridVContParamClass;
begin
  result := TGridVCont;
end;

function TModflowTypesClass.GetWellDataFormType: TWellDataFormClass;
begin
  result := TfrmWellData;
end;

function TModflowTypesClass.GetMFModflowLayerParamType: TMFModflowLayerParamClass;
begin
  result := TModflowLayerParam;
end;

function TModflowTypesClass.GetMFGridRechLayerParamType: TMFGridRechLayerParamClass;
begin
  result := TGridRechLayerParam;
end;

function TModflowTypesClass.GetMFGridETLayerParamType: TMFGridETLayerParamClass;
begin
  result := TGridETLayerParam;
end;

function TModflowTypesClass.GetWarningsFormType: TWarningsFormClass;
begin
  result := TfrmWarnings;
end;

function TModflowTypesClass.GetMFMOCImPorosityLayerType: TMFMOCImPorosityLayerClass;
begin
  result := TMOCImPorosityLayer;
end;

function TModflowTypesClass.GetMFMOCImPorosityParamType: TMFMOCImPorosityParamClass;
begin
  result := TMOCImPorosityParam;
end;

function TModflowTypesClass.GetMFMOCLinExchCoefLayerType: TMFMOCLinExchCoefLayerClass;
begin
  result := TMOCLinExchCoefLayer;
end;

function TModflowTypesClass.GetMFMOCLinExchCoefParamType: TMFMOCLinExchCoefParamClass;
begin
  result := TMOCLinExchCoefParam;
end;

function TModflowTypesClass.GetMFMOCLinExchCoefTimeParamListType: TMFMOCLinExchCoefTimeParamListClass;
begin
  result := TMOCLinExchCoefParamList;
end;

function TModflowTypesClass.GetMFMOCDecayCoefLayerType: TMFMOCDecayCoefLayerClass;
begin
  result := TMOCDecayCoefLayer;
end;

function TModflowTypesClass.GetMFMOCDecayCoefParamType: TMFMOCDecayCoefParamClass;
begin
  result := TMOCDecayCoefParam;
end;

function TModflowTypesClass.GetMFMOCDecayCoefTimeParamListType: TMFMOCDecayCoefTimeParamListClass;
begin
  result := TMOCDecayCoefParamList;
end;

function TModflowTypesClass.GetMFMOCGrowthLayerType: TMFMOCGrowthLayerClass;
begin
  result := TMOCGrowthLayer;
end;

function TModflowTypesClass.GetMFMOCGrowthParamType: TMFMOCGrowthParamClass;
begin
  result := TMOCGrowthParam;
end;

function TModflowTypesClass.GetMFMOCGrowthTimeParamListType: TMFMOCGrowthTimeParamListClass;
begin
  result := TMOCGrowthParamList;
end;

function TModflowTypesClass.GetMFMOCImInitConcLayerType: TMFMOCImInitConcLayerClass;
begin
  result := TMOCImInitConcLayer;
end;

function TModflowTypesClass.GetMFMOCImInitConcParamType: TMFMOCImInitConcParamClass;
begin
  result := TMOCImInitConcParam;
end;

function TModflowTypesClass.GetMFMOCRetardationLayerType: TMFMOCRetardationLayerClass;
begin
  result := TMOCRetardationLayer;
end;

function TModflowTypesClass.GetMFMOCRetardationParamType: TMFMOCRetardationParamClass;
begin
  result := TMOCRetardationParam;
end;

function TModflowTypesClass.GetMFMOCDisDecayCoefLayerType: TMFMOCDisDecayCoefLayerClass;
begin
  result := TMOCDisDecayCoefLayer;
end;

function TModflowTypesClass.GetMFMOCDisDecayCoefParamType: TMFMOCDisDecayCoefParamClass;
begin
  result := TMOCDisDecayCoefParam;
end;

function TModflowTypesClass.GetMFMOCDisDecayCoefTimeParamListType: TMFMOCDisDecayCoefTimeParamListClass;
begin
  result := TMOCDisDecayCoefParamList;
end;

function TModflowTypesClass.GetMFMOCSorbDecayCoefLayerType: TMFMOCSorbDecayCoefLayerClass;
begin
  result := TMOCSorbDecayCoefLayer;
end;

function TModflowTypesClass.GetMFMOCSorbDecayCoefParamType: TMFMOCSorbDecayCoefParamClass;
begin
  result := TMOCSorbDecayCoefParam;
end;

function TModflowTypesClass.GetMFMOCSorbDecayCoefTimeParamListType: TMFMOCSorbDecayCoefTimeParamListClass;
begin
  result := TMOCSorbDecayCoefParamList;
end;

function TModflowTypesClass.GetMFMOCDisGrowthLayerType: TMFMOCDisGrowthLayerClass;
begin
  result := TMOCDisGrowthLayer;
end;

function TModflowTypesClass.GetMFMOCDisGrowthParamType: TMFMOCDisGrowthParamClass;
begin
  result := TMOCDisGrowthParam;
end;

function TModflowTypesClass.GetMFMOCDisGrowthTimeParamListType: TMFMOCDisGrowthTimeParamListClass;
begin
  result := TMOCDisGrowthParamList;
end;

function TModflowTypesClass.GetMFMOCSorbGrowthLayerType: TMFMOCSorbGrowthLayerClass;
begin
  result := TMOCSorbGrowthLayer;
end;

function TModflowTypesClass.GetMFMOCSorbGrowthParamType: TMFMOCSorbGrowthParamClass;
begin
  result := TMOCSorbGrowthParam;
end;

function TModflowTypesClass.GetMFMOCSorbGrowthTimeParamListType: TMFMOCSorbGrowthTimeParamListClass;
begin
  result := TMOCSorbGrowthParamList;
end;

function TModflowTypesClass.GetMFMODPATH_EndingZoneParamType: TMFMODPATH_EndingZoneParamClass;
begin
  result := TMODPATH_EndingZoneParam;
end;

function TModflowTypesClass.GetMFMODPATH_StartingZoneParamType: TMFMODPATH_StartingZoneParamClass;
begin
  result := TMODPATH_StartingZoneParam;
end;

function TModflowTypesClass.GetMFMODPATHPostEndLayerType: TMFMODPATHPostEndLayerClass;
begin
  result := TMODPATHPostEndLayer;
end;

function TModflowTypesClass.GetMFPointDrainLayerType: TMFPointDrainLayerClass;
begin
  result := TPointDrainLayer;
end;

function TModflowTypesClass.GetMFPointRiverLayerType: TMFPointRiverLayerClass;
begin
  result := TPointRiverLayer;
end;

function TModflowTypesClass.GetMFGridMOCPrescribedConcParamType: TMFGridMOCPrescribedConcParamClass;
begin
  result := TGridMOCPrescribedConcParam;
end;

function TModflowTypesClass.GetMultiplierListType: TMultiplierListClass;
begin
  result := TMultiplierList;
end;

function TModflowTypesClass.GetMFMultiplierLayerType: TMFMultiplierLayerClass;
begin
  result := TMultiplierLayer;
end;

function TModflowTypesClass.GetMFMultiplierParamType: TMFMultiplierParamClass;
begin
  result := TMultiplierParam;
end;

function TModflowTypesClass.GetMFMultiplierGroupLayerType: TMFMultiplierGroupLayerClass;
begin
  result := TMultiplierGroupLayer;
end;

function TModflowTypesClass.GetZoneListType: TZoneListClass;
begin
  result := TZoneList;
end;

function TModflowTypesClass.GetMFZoneGroupLayerType: TMFZoneGroupLayerClass;
begin
  result := TZoneGroupLayer;
end;

function TModflowTypesClass.GetMFZoneLayerType: TMFZoneLayerClass;
begin
  result := TZoneLayer;
end;

function TModflowTypesClass.GetMFZoneParamType: TMFZoneParamClass;
begin
  result := TZoneParam;
end;

function TModflowTypesClass.GetMFGridMultiplierParamType: TMFGridMultiplierParamClass;
begin
  result := TGridMultiplier;
end;

function TModflowTypesClass.GetMFGridZoneParamType: TMFGridZoneParamClass;
begin
  result := TGridZone;
end;

function TModflowTypesClass.GetMFGwmHeadStateLayerType: TMFGwmHeadStateLayerClass;
begin
  result := TGwmHeadStateLayer;
end;

function TModflowTypesClass.GetMFGwmStorageStateLayerType: TMFGwmStorageStateLayerClass;
begin
  result := TGwmStorageStateLayer;
end;

function TModflowTypesClass.GetMFGwmStreamStateLayerType: TMFGwmStreamStateLayerClass;
begin
  result := TGwmStreamStateLayer;
end;

function TModflowTypesClass.GetMFGwmStressPeriodParamListType: TMFGwmStressPeriodParamListClass;
begin
  result := TGwmStressPeriodParamList;
end;

function TModflowTypesClass.GetMFMultiplierParamListType: TMFMultiplierParamListClass;
begin
  result := TMultiplierParameters;
end;

function TModflowTypesClass.GetMFZoneParamListType: TMFZoneParamListClass;
begin
  result := TZoneParameters;
end;

function TModflowTypesClass.GetMFModflowParameterNameParamType: TMFModflowParameterNameParamClass;
begin
  result := TModflowParameterNameParam;
end;

function TModflowTypesClass.GetMFIsParameterParamType: TMFIsParameterParamClass;
begin
  result := TIsParameterParam;
end;

function TModflowTypesClass.GetMFAnistropyParamType: TMFAnistropyParamClass;
begin
  result := TAnistropyParam;
end;

function TModflowTypesClass.GetMFAnistropyLayerType: TMFAnistropyLayerClass;
begin
  result := TAnistropyLayer;
end;

function TModflowTypesClass.GetMFGridAnisoParamType: TMFGridAnisoParamClass;
begin
  result := TGridAniso;
end;


function TModflowTypesClass.GetMFOnOffParamType: TMFOnOffParamClass;
begin
  result := TOnOffParam;
end;

function TModflowTypesClass.GetMFAreaWellLayerType: TMFAreaWellLayerClass;
begin
  result := TAreaWellLayer;
end;

function TModflowTypesClass.GetMFLineWellLayerType: TMFLineWellLayerClass;
begin
  result := TLineWellLayer;
end;

function TModflowTypesClass.GetMFTotalWellStressParamType: TMFTotalWellStressParamClass;
begin
  result := TTotalWellStressParam;
end;

function TModflowTypesClass.GetMFLineAreaWellTimeParamListType: TMFLineAreaWellTimeParamListClass;
begin
  result := TLineAreaWellTimeParamList;
end;

function TModflowTypesClass.GetMFWellStressIndicatorParamType: TMFWellStressIndicatorParamClass;
begin
  result := TWellStressIndicatorParam;
end;

function TModflowTypesClass.GetMFFHBAreaBoundaryTypeParamType: TMFFHBAreaBoundaryTypeParamClass;
begin
  result := TFHBAreaBoundaryTypeParam;
end;

function TModflowTypesClass.GetMFFHBLineBoundaryTypeParamType: TMFFHBLineBoundaryTypeParamClass;
begin
  result := TFHBLineBoundaryTypeParam;
end;

function TModflowTypesClass.GetMFFHBPointBoundaryTypeParamType: TMFFHBPointBoundaryTypeParamClass;
begin
  result := TFHBPointBoundaryTypeParam;
end;

function TModflowTypesClass.GetMFFHBEndHeadUsedParamType: TMFFHBEndHeadUsedParamClass;
begin
  result := TFHBEndHeadUsedParam;
end;

function TModflowTypesClass.GetMFBottomObsElevParamType: TMFBottomObsElevParamClass;
begin
  result := TBottomObsElevParam;
end;

function TModflowTypesClass.GetMFTopObsElevParamType: TMFTopObsElevParamClass;
begin
  result := TTopObsElevParam;
end;

function TModflowTypesClass.GetMFBottomLayerParamType: TMFBottomLayerParamClass;
begin
  result := TBottomLayerParam;
end;

function TModflowTypesClass.GetMFIttParamType: TMFIttParamClass;
begin
  result := TIttParam;
end;

function TModflowTypesClass.GetMFObservationNameParamType: TMFObservationNameParamClass;
begin
  result := TObservationNameParam;
end;

function TModflowTypesClass.GetMFObservedHeadParamType: TMFObservedHeadParamClass;
begin
  result := TObservedHeadParam;
end;

function TModflowTypesClass.GetMFStatddParamType: TMFStatddParamClass;
begin
  result := TStatddParam;
end;

function TModflowTypesClass.GetMFStatFlagParamType: TMFStatFlagParamClass;
begin
  result := TStatFlagParam;
end;

function TModflowTypesClass.GetMFStathParamType: TMFStathParamClass;
begin
  result := TStathParam;
end;

function TModflowTypesClass.GetMFStatisticParamType: TMFStatisticParamClass;
begin
  result := TStatisticParam;
end;

function TModflowTypesClass.GetMFTimeParamType: TMFTimeParamClass;
begin
  result := TTimeParam;
end;

function TModflowTypesClass.GetMFTopLayerParamType: TMFTopLayerParamClass;
begin
  result := TTopLayerParam;
end;

function TModflowTypesClass.GetMFPlotSymbolParamType: TMFPlotSymbolParamClass;
begin
  result := TPlotSymbolParam;
end;

function TModflowTypesClass.GetMFHeadObservationParamListType: TMFHeadObservationParamListClass;
begin
  result := THeadObservationParamList;
end;

function TModflowTypesClass.GetMFWeightParamType: TMFWeightParamClass;
begin
  result := TWeightParam;
end;

function TModflowTypesClass.GetMFWeightParamListType: TMFWeightParamListClass;
begin
  result := TWeightParamList;
end;

function TModflowTypesClass.GetMFHeadObservationsLayerType: TMFHeadObservationsLayerClass;
begin
  result := THeadObservationsLayer;
end;

function TModflowTypesClass.GetMFObservationsGroupLayerType: TMFObservationsGroupLayerClass;
begin
  result := TObservationsGroupLayer;
end;

function TModflowTypesClass.GetMFWeightedHeadObservationsLayerType: TMFWeightedHeadObservationsLayerClass;
begin
  result := TWeightedHeadObservationsLayer;
end;

function TModflowTypesClass.GetObservationGroupListType: TObservationGroupListClass;
begin
  result := TObservationGroupList;
end;

function TModflowTypesClass.GetObservationListType: TObservationListClass;
begin
  result := TObservationList;
end;

function TModflowTypesClass.GetWeightedObservationListType: TWeightedObservationListClass;
begin
  result := TWeightedObservationList;
end;

function TModflowTypesClass.GetMFFactorParamType: TMFFactorParamClass;
begin
  result := TFactorParam;
end;

function TModflowTypesClass.GetMFLossParamType: TMFLossParamClass;
begin
  result := TLossParam;
end;

function TModflowTypesClass.GetMFCustomFluxObservationsLayerType: TMFCustomFluxObservationsLayerClass;
begin
  result := TCustomFluxObservationsLayer;
end;

function TModflowTypesClass.GetMFDrainFluxObservationsLayerType: TMFDrainFluxObservationsLayerClass;
begin
  result := TDrainFluxObservationsLayer;
end;

function TModflowTypesClass.GetMFGHBFluxObservationsLayerType: TMFGHBFluxObservationsLayerClass;
begin
  result := TGHBFluxObservationsLayer;
end;

function TModflowTypesClass.GetMFRiverFluxObservationsLayerType: TMFRiverFluxObservationsLayerClass;
begin
  result := TRiverFluxObservationsLayer;
end;

function TModflowTypesClass.GetDrainFluxObsListType: TDrainFluxObsListClass;
begin
  result := TDrainFluxObsList;
end;

function TModflowTypesClass.GetGHBFluxObsListType: TGHBFluxObsListClass;
begin
  result := TGHBFluxObsList;
end;

function TModflowTypesClass.GetRiverFluxObsListType: TRiverFluxObsListClass;
begin
  result := TRiverFluxObsList;
end;

function TModflowTypesClass.GetMFSpecifiedHeadFluxObservationsLayerType: TMFSpecifiedHeadFluxObservationsLayerClass;
begin
  result := TSpecifiedHeadFluxObservationsLayer;
end;

function TModflowTypesClass.GetSpecifiedHeadFluxObsListType: TSpecifiedHeadFluxObsListClass;
begin
  result := TSpecifiedHeadFluxObsList;
end;

function TModflowTypesClass.GetMFObservationNumberParamType: TMFObservationNumberParamClass;
begin
  result := TObservationNumberParam;
end;

function TModflowTypesClass.GetMFDrainFluxObservationParamListType: TMFDrainFluxObservationParamListClass;
begin
  result := TDrainFluxObservationParamList;
end;

function TModflowTypesClass.GetMFGHBFluxObservationParamListType: TMFGHBFluxObservationParamListClass;
begin
  result := TGHBFluxObservationParamList;
end;

function TModflowTypesClass.GetMFRiverFluxObservationParamListType: TMFRiverFluxObservationParamListClass;
begin
  result := TRiverFluxObservationParamList;
end;

function TModflowTypesClass.GetMFSpecifiedHeadFluxObservationParamListType: TMFSpecifiedHeadFluxObservationParamListClass;
begin
  result := TSpecifiedHeadFluxObservationParamList;
end;

function TModflowTypesClass.GetMFObservationGroupNumberParamType: TMFObservationGroupNumberParamClass;
begin
  result := TObservationGroupNumberParam;
end;

function TModflowTypesClass.GetMFAdvObsElevParamType: TMFAdvObsElevParamClass;
begin
  result := TAdvObsElevParam;
end;

function TModflowTypesClass.GetMFAdvObsGroupNumberParamType: TMFAdvObsGroupNumberParamClass;
begin
  result := TAdvObsGroupNumberParam;
end;

function TModflowTypesClass.GetMFAdvObsLayerParamType: TMFAdvObsLayerParamClass;
begin
  result := TAdvObsLayerParam;
end;

function TModflowTypesClass.GetMFAdvObsNameParamType: TMFAdvObsNameParamClass;
begin
  result := TAdvObsNameParam;
end;

function TModflowTypesClass.GetMFAdvObsXStatFlagParamType: TMFAdvObsXStatFlagParamClass;
begin
  result := TXStatFlagParam;
end;

function TModflowTypesClass.GetMFAdvObsYStatFlagParamType: TMFAdvObsYStatFlagParamClass;
begin
  result := TYStatFlagParam;
end;

function TModflowTypesClass.GetMFAdvObsZStatFlagParamType: TMFAdvObsZStatFlagParamClass;
begin
  result := TZStatFlagParam;
end;

function TModflowTypesClass.GetMFAdvXStatisticParamType: TMFAdvObsXStatisticParamClass;
begin
  result := TXStatisticParam;
end;

function TModflowTypesClass.GetMFAdvYStatisticParamType: TMFAdvObsYStatisticParamClass;
begin
  result := TYStatisticParam;
end;

function TModflowTypesClass.GetMFAdvZStatisticParamType: TMFAdvObsZStatisticParamClass;
begin
  result := TZStatisticParam;
end;

function TModflowTypesClass.GetMFAdvectionObservationsLayerType: TMFAdvectionObservationsLayerClass;
begin
  result := TAdvectionObservationsLayer;
end;

function TModflowTypesClass.GetMFAdvectionObservationsStartingLayerType: TMFAdvectionObservationsStartingLayerClass;
begin
  result := TAdvectionObservationsStartingLayer;
end;

function TModflowTypesClass.GetAdvectionObservationListType: TAdvectionObservationListClass;
begin
  result := TAdvectionObservationList;
end;

function TModflowTypesClass.GetAdvectionStartingObsListType: TAdvectionStartingObsListClass;
begin
  result := TAdvectionStartingList;
end;

function TModflowTypesClass.GetMFCenterLakeParamType: TMFCenterLakeParamClass;
begin
  result := TCenterLakeParam;
end;

function TModflowTypesClass.GetMFGageParamType: TMFGageParamClass;
begin
  result := TGageParam;
end;

function TModflowTypesClass.GetMFLakeInitialConcParamType: TMFLakeInitialConcParamClass;
begin
  result := TLakeInitialConcParam;
end;

function TModflowTypesClass.GetMFLakeAugmentationConcParamType: TMFLakeAugmentationConcParamClass;
begin
  result := TLakeAugmentationConcParam;
end;

function TModflowTypesClass.GetMFLakeEvapParamType: TMFLakeEvapParamClass;
begin
  result := TLakeEvapParam;
end;

function TModflowTypesClass.GetMFLakeHydraulicCondParamType: TMFLakeHydraulicCondParamClass;
begin
  result := TLakeHydraulicCondParam;
end;

function TModflowTypesClass.GetMFLakeInitialStageParamType: TMFLakeInitialStageParamClass;
begin
  result := TLakeInitialStageParam;
end;

function TModflowTypesClass.GetMFLakeMaximumStageParamType: TMFLakeMaximumStageParamClass;
begin
  result := TLakeMaximumStageParam;
end;

function TModflowTypesClass.GetMFLakeMinimumStageParamType: TMFLakeMinimumStageParamClass;
begin
  result := TLakeMinimumStageParam;
end;

function TModflowTypesClass.GetMFLakeNumberParamType: TMFLakeNumberParamClass;
begin
  result := TLakeNumberParam;
end;

function TModflowTypesClass.GetMFLakePrecipConcParamType: TMFLakePrecipConcParamClass;
begin
  result := TLakePrecipConcParam;
end;

function TModflowTypesClass.GetMFLakePrecipParamType: TMFLakePrecipParamClass;
begin
  result := TLakePrecipParam;
end;

function TModflowTypesClass.GetMFLakeRunoffConcParamType: TMFLakeRunoffConcParamClass;
begin
  result := TLakeRunoffConcParam;
end;

function TModflowTypesClass.GetMFLakeRunoffParamParamType: TMFLakeRunoffParamClass;
begin
  result := TLakeRunoffParam;
end;

function TModflowTypesClass.GetMFLakeSillParamType: TMFLakeSillParamClass;
begin
  result := TLakeSillParam;
end;

function TModflowTypesClass.GetMFLakeThicknessParamType: TMFLakeThicknessParamClass;
begin
  result := TLakeThicknessParam;
end;

function TModflowTypesClass.GetMFLakeWithdrawalsParamType: TMFLakeWithdrawalsParamClass;
begin
  result := TLakeWithdrawalsParam;
end;

function TModflowTypesClass.GetMFLakeTimeParamListType: TMFLakeTimeParamListClass;
begin
  result := TLakeTimeParamList;
end;

function TModflowTypesClass.GetMFLakeLayerType: TMFLakeLayerClass;
begin
  result := TLakeLayer;
end;

function TModflowTypesClass.GetMFGridLakeLocationParamType: TMFGridLakeLocationParamClass;
begin
  result := TGridLakeLocation;
end;

function TModflowTypesClass.GetMFLakeBottomElevParamParamType: TMFLakeBottomElevParamClass;
begin
  result := TLakeBottomElevParam;
end;

function TModflowTypesClass.GetMFLakeBottomParamType: TMFLakeBottomParamClass;
begin
  result := TLakeBottomParam;
end;

function TModflowTypesClass.GetMFLakeBottomLayerType: TMFLakeBottomLayerClass;
begin
  result := TLakeBottomLayer;
end;

function TModflowTypesClass.GetMFLakeLeakanceLayerType: TMFLakeLeakanceLayerClass;
begin
  result := TLakeLeakanceLayer;
end;

function TModflowTypesClass.GetLakeLeakanceListType: TLakeLeakanceListClass;
begin
  result := TLakeLeakanceList;
end;

function TModflowTypesClass.GetMFElasticStorageFactorParamType: TMFElasticStorageFactorParamClass;
begin
  result := TElasticStorageFactorParam;
end;

function TModflowTypesClass.GetMFInelasticStorageFactorParamType: TMFInelasticStorageFactorParamClass;
begin
  result := TInelasticStorageFactorParam;
end;

function TModflowTypesClass.GetMFPreconsolidationHeadParamType: TMFPreconsolidationHeadParamClass;
begin
  result := TPreconsolidationHeadParam;
end;

function TModflowTypesClass.GetMFStartingCompactionParamType: TMFStartingCompactionParamClass;
begin
  result := TStartingCompactionParam;
end;

function TModflowTypesClass.GetMFIBSLayerType: TMFIBSLayerClass;
begin
  result := TIBSLayer;
end;

function TModflowTypesClass.GetMFGridIbsElasticStorageParamType: TMFGridIbsElasticStorageParamClass;
begin
  result := TGridIbsElasticStorage;
end;

function TModflowTypesClass.GetMFGridIbsPreconsolidationHeadParamType: TMFGridIbsPreconsolidationHeadParamClass;
begin
  result := TGridIbsPreconsolidationHead;
end;

function TModflowTypesClass.GetMFGridIbsStartingCompactionParamType: TMFGridIbsStartingCompactionParamClass;
begin
  result := TGridIbsStartingCompaction;
end;

function TModflowTypesClass.GetMGridIbsInelasticStorageParamType: TMFGridIbsInelasticStorageParamClass;
begin
  result := TGridIbsInelasticStorage;
end;

function TModflowTypesClass.GetMFReservoirBedThicknessParamType: TMFReservoirBedThicknessParamClass;
begin
  result := TReservoirBedThicknessParam;
end;

function TModflowTypesClass.GetMFReservoirEndingStageParamType: TMFReservoirEndingStageParamClass;
begin
  result := TReservoirEndingStageParam;
end;

function TModflowTypesClass.GetMFReservoirKzParamType: TMFReservoirKzParamClass;
begin
  result := TReservoirKzParam;
end;

function TModflowTypesClass.GetMFReservoirLandSurfaceParamType: TMFReservoirLandSurfaceParamClass;
begin
  result := TReservoirLandSurfaceParam;
end;

{function TModflowTypesClass.GetMFReservoirNumberParamType: TMFReservoirNumberParamClass;
begin
  result := TReservoirNumberParam;
end;  }

function TModflowTypesClass.GetMFReservoirStartingStageParamType: TMFReservoirStartingStageParamClass;
begin
  result := TReservoirStartingStageParam;
end;

function TModflowTypesClass.GetMFReservoirTimeParamListType: TMFReservoirTimeParamListClass;
begin
  result := TReservoirTimeParamList;
end;

function TModflowTypesClass.GetMFReservoirLayerType: TMFReservoirLayerClass;
begin
  result := TReservoirLayer;
end;

function TModflowTypesClass.GetMFMODPATH_StartingColumnParamType: TMFMODPATH_StartingColumnParamClass;
begin
  result := TMODPATH_StartingColumnParam;
end;

function TModflowTypesClass.GetMFMODPATH_StartingRowParamType: TMFMODPATH_StartingRowParamClass;
begin
  result := TMODPATH_StartingRowParam;
end;

function TModflowTypesClass.GetMFGridResElevParamType: TMFGridResElevParamClass;
begin
  result := TGridResElev;
end;

function TModflowTypesClass.GetMFGridResKzParamType: TMFGridResKzParamClass;
begin
  result := TGridResKz;
end;

function TModflowTypesClass.GetMFGridResThicknessParamType: TMFGridResThicknessParamClass;
begin
  result := TGridResThickness;
end;

function TModflowTypesClass.GetMFIsObservationParamType: TMFIsObservationParamClass;
begin
  result := TIsObservationParam;
end;

function TModflowTypesClass.GetMFIsPredictionParamType: TMFIsPredictionParamClass;
begin
  result := TIsPredictionParam;
end;

function TModflowTypesClass.GetMFMOC_IsObservationParamType: TMFMOC_IsObservationParamClass;
begin
  result := TMOC_IsObservation;
end;

function TModflowTypesClass.GetMF2KBankRoughnessParamType: TMF2KBankRoughnessParamClass;
begin
  result := TMF2KBankRoughnessParam;
end;

function TModflowTypesClass.GetMF2KChanelRoughnessParamType: TMF2KChanelRoughnessParamClass;
begin
  result := TMF2KChanelRoughnessParam;
end;

function TModflowTypesClass.GetMF2KCrossSectionXParamType: TMF2KCrossSectionXParamClass;
begin
  result := TMF2KCrossSectionXParam;
end;

function TModflowTypesClass.GetMF2KCrossSectionZParamType: TMF2KCrossSectionZParamClass;
begin
  result := TMF2KCrossSectionZParam;
end;

function TModflowTypesClass.GetMF2KDepthCoefficientParamType: TMF2KDepthCoefficientParamClass;
begin
  result := TMF2KDepthCoefficientParam;
end;

function TModflowTypesClass.GetMF2KDepthExponentParamType: TMF2KDepthExponentParamClass;
begin
  result := TMF2KDepthExponentParam;
end;

function TModflowTypesClass.GetMF2KDownstreamBedThicknessParamType: TMF2KDownstreamBedThicknessParamClass;
begin
  result := TMF2KDownstreamBedThicknessParam;
end;

function TModflowTypesClass.GetMF2KDownstreamDepthParamType: TMF2KDownstreamDepthParamClass;
begin
  result := TMF2KDownstreamDepth;
end;

function TModflowTypesClass.GetMF2KDownstreamKParamType: TMF2KDownstreamKParamClass;
begin
  result := TMF2KDownstreamK;
end;

function TModflowTypesClass.GetMF2KDownstreamTopElevationParamType: TMF2KDownstreamTopElevationParamClass;
begin
  result := TMF2KDownstreamTopElevationParam;
end;

function TModflowTypesClass.GetMF2KPrecipitationParamType: TMF2KPrecipitationParamClass;
begin
  result := TMF2KPrecipitationParam;
end;

function TModflowTypesClass.GetMF2KStreamDownWidthParamType: TMF2KStreamDownWidthParamClass;
begin
  result := TMF2KStreamDownWidthParam;
end;

function TModflowTypesClass.GetMF2KStreamPriorityParamType: TMF2KStreamPriorityParamClass;
begin
  result := TMF2KStreamPriority;
end;

function TModflowTypesClass.GetMF2KTableDepthParamType: TMF2KTableDepthParamClass;
begin
  result := TMF2KTableDepthParam;
end;

function TModflowTypesClass.GetMF2KTableFlowParamType: TMF2KTableFlowParamClass;
begin
  result := TMF2KTableFlowParam;
end;

function TModflowTypesClass.GetMF2KTableWidthParamType: TMF2KTableWidthParamClass;
begin
  result := TMF2KTableWidthParam;
end;

function TModflowTypesClass.GetMF2KUpsteamDepthParamType: TMF2KUpsteamDepthParamClass;
begin
  result := TMF2KUpsteamDepth;
end;

function TModflowTypesClass.GetMF2KUpstreamBedThicknessParamType: TMF2KUpstreamBedThicknessParamClass;
begin
  result := TMF2KUpstreamBedThicknessParam;
end;

function TModflowTypesClass.GetMF2KUpstreamKParamType: TMF2KUpstreamKParamClass;
begin
  result := TMF2KUpstreamK;
end;

function TModflowTypesClass.GetMF2KWidthCoefficientParamType: TMF2KWidthCoefficientParamClass;
begin
  result := TMF2KWidthCoefficientParam;
end;

function TModflowTypesClass.GetMF2KWidthExponentParamType: TMF2KWidthExponentParamClass;
begin
  result := TMF2KWidthExponentParam;
end;

function TModflowTypesClass.GetMF2K_ICALC_ParamType: TMF2K_ICALC_ParamClass;
begin
  result := TMF2K_ICALC_Param;
end;

function TModflowTypesClass.GetMF2K8PointChannelStreamTimeParamListType: TMF2K8PointChannelStreamTimeParamListClass;
begin
  result := TMF2K8PointChannelStreamTimeParamList;
end;

function TModflowTypesClass.GetMF2KSimpleStreamTimeParamListType: TMF2KSimpleStreamTimeParamListClass;
begin
  result := TMF2KSimpleStreamTimeParamList;
end;

function TModflowTypesClass.GetMF2KStreamCrossSectionParamListType: TMF2KStreamCrossSectionParamListClass;
begin
  result := TMF2KStreamCrossSectionParamList;
end;

function TModflowTypesClass.GetMF2KStreamTableParamListType: TMF2KStreamTableParamListClass;
begin
  result := TMF2KStreamTableParamList;
end;

function TModflowTypesClass.GetMF2KTableStreamTimeParamListType: TMF2KTableStreamTimeParamListClass;
begin
  result := TMF2KTableStreamTimeParamList;
end;

function TModflowTypesClass.GetMF2KStreamFormulaTimeParamListType: TMF2KStreamFormulaTimeParamListClass;
begin
  result := TMF2KStreamFormulaTimeParamList;
end;

function TModflowTypesClass.GetMF2K8PointChannelStreamLayerType: TMF2K8PointChannelStreamLayerClass;
begin
  result := TMF2K8PointChannelStreamLayer;
end;

function TModflowTypesClass.GetMF2KFormulaStreamLayerType: TMF2KFormulaStreamLayerClass;
begin
  result := TMF2KFormulaStreamLayer;
end;

function TModflowTypesClass.GetMF2KSimpleStreamLayerType: TMF2KSimpleStreamLayerClass;
begin
  result := TMF2KSimpleStreamLayer;
end;

function TModflowTypesClass.GetMF2KTableStreamLayerType: TMF2KTableStreamLayerClass;
begin
  result := TMF2KTableStreamLayer;
end;

function TModflowTypesClass.GetMF2KFlowConcentrationParamType: TMF2KFlowConcentrationParamClass;
begin
  result := TFlowConcentration;
end;

function TModflowTypesClass.GetMF2KPrecipitationConcentrationParamType: TMF2KPrecipitationConcentrationParamClass;
begin
  result := TPrecipitationConcentration;
end;

function TModflowTypesClass.GetMF2KRunoffConcentrationParamType: TMF2KRunoffConcentrationParamClass;
begin
  result := TRunoffConcentration;
end;

function TModflowTypesClass.GetMF2KRunoffParamType: TMF2KRunoffParamClass;
begin
  result := TMF2KRunoffParam;
end;

function TModflowTypesClass.GetMF2KStreamEvapParamType: TMF2KStreamEvapParamClass;
begin
  result := TMF2KStreamEvap;
end;

function TModflowTypesClass.GetMFGridSFRParamType: TMFGridSFRParamClass;
begin
  result := TGridSFR;
end;

function TModflowTypesClass.GetMF2KStreamDivSegNumParamType: TMF2KStreamDivSegNumParamClass;
begin
  result := TMF2KStreamDivSegNum;
end;

function TModflowTypesClass.GetMF2KStreamUpTopElevParamType: TMF2KStreamUpTopElevParamClass;
begin
  result := TMF2KStreamUpTopElev;
end;

function TModflowTypesClass.GetAdjustForAngleParamType: TAdjustForAngleParamClass;
begin
  result := TAdjustForAngle;
end;

function TModflowTypesClass.GetMFStreamObservationParamListType: TMFStreamObservationParamListClass;
begin
  result := TStreamObservationParamList;
end;

function TModflowTypesClass.GetSegET_IntermediateDepthParamType: TSegET_IntermediateDepthParamClass;
begin
  result := TSegET_IntermediateDepth;
end;

function TModflowTypesClass.GetSegET_IntermediateProportionParamType: TSegET_IntermediateProportionParamClass;
begin
  result := TSegET_IntermediateProportion;
end;

function TModflowTypesClass.GetSegET_MaxFluxParamType: TSegET_MaxFluxParamClass;
begin
  result := TSegET_MaxFlux;
end;

function TModflowTypesClass.GetSegETExtDepthParamType: TSegETExtDepthParamClass;
begin
  result := TSegETExtDepth;
end;

function TModflowTypesClass.GetSegETSurfaceParamType: TSegETSurfaceParamClass;
begin
  result := TSegETSurface;
end;

function TModflowTypesClass.GetMFSegET_IntermediateDepthsParamListType: TMFSegET_IntermediateDepthsParamListClass;
begin
  result := TSegET_IntermediateDepthsParamList;
end;

function TModflowTypesClass.GetMFSegETTimeParamListType: TMFSegETTimeParamListClass;
begin
  result := TSegETTimeParamList;
end;

function TModflowTypesClass.GetMFSegmentedETLayerType: TMFSegmentedETLayerClass;
begin
  result := TSegmentedETLayer;
end;

function TModflowTypesClass.GetGridETS_ExtinctDepthParamType: TGridETS_ExtinctDepthParamClass;
begin
  result := TGridETS_ExtinctDepth;
end;

function TModflowTypesClass.GetGridETS_LayerParamType: TGridETS_LayerParamClass;
begin
  result := TGridETS_Layer;
end;

function TModflowTypesClass.GetGridETS_SurfaceParamType: TGridETS_SurfaceParamClass;
begin
  result := TGridETS_Surface;
end;

function TModflowTypesClass.GetDrainReturnFractionParamType: TDrainReturnFractionParamClass;
begin
  result := TDrainReturnFractionParam;
end;

function TModflowTypesClass.GetDrainReturnIndexParamType: TDrainReturnIndexParamClass;
begin
  result := TDrainReturnIndexParam;
end;

function TModflowTypesClass.GetMFDrainReturnTimeParamListType: TMFDrainReturnTimeParamListClass;
begin
  result := TDrainReturnTimeParamList;
end;

function TModflowTypesClass.GetMFAreaDrainReturnLayerType: TMFAreaDrainReturnLayerClass;
begin
  result := TAreaDrainReturnLayer;
end;

function TModflowTypesClass.GetMFLineDrainReturnLayerType: TMFLineDrainReturnLayerClass;
begin
  result := TLineDrainReturnLayer;
end;

function TModflowTypesClass.GetMFPointDrainReturnLayerType: TMFPointDrainReturnLayerClass;
begin
  result := TPointDrainReturnLayer;
end;

function TModflowTypesClass.GetMFDrainReturnLayerType: TMFDrainReturnLayerClass;
begin
  result := TDrainReturnLayer;
end;

function TModflowTypesClass.GetMFDrainReturnFluxObservationParamListType: TMFDrainReturnFluxObservationParamListClass;
begin
  result := TDrainReturnFluxObservationParamList;
end;

function TModflowTypesClass.GetMFDrainReturnFluxObservationsLayerType: TMFDrainReturnFluxObservationsLayerClass;
begin
  result := TDrainReturnFluxObservationsLayer
end;

function TModflowTypesClass.GetDrainReturnFluxObsListType: TDrainReturnFluxObsListClass;
begin
  result := TDrainReturnFluxObsList;
end;

function TModflowTypesClass.GetGridDrainReturnParamType: TGridDrainReturnParamClass;
begin
  result := TGridDrainReturn;
end;

function TModflowTypesClass.GetMFHydmodCompactionObservationParamType: TMFHydmodCompactionObservationParamClass;
begin
  result := THydmodCompactionObservationParam;
end;

function TModflowTypesClass.GetMFHydmodDrawDownObservationParamType: TMFHydmodDrawDownObservationParamClass;
begin
  result := THydmodDrawDownObservationParam;
end;

function TModflowTypesClass.GetMFHydmodHeadObservationParamType: TMFHydmodHeadObservationParamClass;
begin
  result := THydmodHeadObservationParam;
end;

function TModflowTypesClass.GetMFHydmodPreconsolidationObservationParamType: TMFHydmodPreconsolidationObservationParamClass;
begin
  result := THydmodPreconsolidationObservationParam;
end;

function TModflowTypesClass.GetMFHydmodStreamFlowInObservationParamType: TMFHydmodStreamFlowInObservationParamClass;
begin
  result := THydmodStreamFlowInObservationParam;
end;

function TModflowTypesClass.GetMFHydmodStreamFlowIntoAquiferObservationParamType: TMFHydmodStreamFlowIntoAquiferObservationParamClass;
begin
  result := THydmodStreamFlowIntoAquiferObservationParam;
end;

function TModflowTypesClass.GetMFHydmodStreamFlowOutObservationParamType: TMFHydmodStreamFlowOutObservationParamClass;
begin
  result := THydmodStreamFlowOutObservationParam;
end;

function TModflowTypesClass.GetMFHydmodStreamStageObservationParamType: TMFHydmodStreamStageObservationParamClass;
begin
  result := THydmodStreamStageObservationParam;
end;

function TModflowTypesClass.GetMFHydmodSubsidenceObservationParamType: TMFHydmodSubsidenceObservationParamClass;
begin
  result := THydmodSubsidenceObservationParam;
end;

function TModflowTypesClass.GetMFHydmodLayerType: TMFHydmodLayerClass;
begin
  result := THydmodLayer;
end;

function TModflowTypesClass.GetMFHydmodInterpolateParamType: TMFHydmodInterpolateParamClass;
begin
  result := THydmodInterpolateParam;
end;

function TModflowTypesClass.GetMFHydmodLabelParamType: TMFHydmodLabelParamClass;
begin
  result := THydmodLabelParam;
end;

function TModflowTypesClass.GetMFHydmodElevParamType: TMFHydmodElevParamClass;
begin
  result := THydmodElevParam;
end;

function TModflowTypesClass.GetMFHydmodModflowLayerParamType: TMFHydmodModflowLayerParamClass;
begin
  result := THydmodModflowLayerParam;
end;

function TModflowTypesClass.GetMFCHD_ElevationParamType: TMFCHD_ElevationParamClass;
begin
  result := TCHD_ElevationParam;
end;

function TModflowTypesClass.GetMFCHD_StartHeadParamType: TMFCHD_StartHeadParamClass;
begin
  result := TCHD_StartHeadParam;
end;

function TModflowTypesClass.GetMFHFBDiffusionCoefParamType: TMFHFBDiffusionCoefParamClass;
begin
  result := THFBDiffusionCoefParam;
end;

function TModflowTypesClass.GetMFHFBHorzTransDispParamType: TMFHFBHorzTransDispParamClass;
begin
  result := THFBHorzTransDispParam;
end;

function TModflowTypesClass.GetMFHFBLongDispParamType: TMFHFBLongDispParamClass;
begin
  result := THFBLongDispParam;
end;

function TModflowTypesClass.GetMFHFBVertTransDispParamType: TMFHFBVertTransDispParamClass;
begin
  result := THFBVertTransDispParam;
end;

function TModflowTypesClass.GetMFCHD_TimeParamListType: TMFCHD_TimeParamListClass;
begin
  result := TCHD_TimeParamList;
end;

function TModflowTypesClass.GetMFAreaCHD_LayerType: TMFAreaCHD_LayerClass;
begin
  result := TAreaCHD_Layer;
end;

function TModflowTypesClass.GetMFPointLineCHD_LayerType: TMFPointLineCHD_LayerClass;
begin
  result := TPointLineCHD_Layer;
end;

function TModflowTypesClass.GetMFGridCHDParamType: TMFGridCHDParamClass;
begin
  result := TGridCHD;
end;

function TModflowTypesClass.GetMFCHD_EndHeadParamType: TMFCHD_EndHeadParamClass;
begin
  result := TCHD_EndHeadParam;
end;

function TModflowTypesClass.GetMFXObsNumberParamType: TMFXObsNumberParamClass;
begin
  result := TXObsNumber;
end;

function TModflowTypesClass.GetMFYObsNumberParamType: TMFYObsNumberParamClass;
begin
  result := TYObsNumber;
end;

function TModflowTypesClass.GetMFZObsNumberParamType: TMFZObsNumberParamClass;
begin
  result := TZObsNumber;
end;

function TModflowTypesClass.GetMFHUFThicknessParamType: TMFHUFThicknessParamClass;
begin
  result := THUFThicknessParameter;
end;

function TModflowTypesClass.GetMFHUFTopParamType: TMFHUFTopParamClass;
begin
  result := THUFTopParameter;
end;

function TModflowTypesClass.GetMFHUF_LayerType: TMFHUF_LayerClass;
begin
  result := THUFLayer;
end;

function TModflowTypesClass.GetMFHUFGroupLayerType: TMFHufGroupLayerClass;
begin
  result := TMFHufGroupLayer;
end;

function TModflowTypesClass.GetMT3DDomOutlineLayerType : TMT3DDomOutlineLayerClass;
begin
  result := TMT3DDomOutlineLayer;
end;

function TModflowTypesClass.GetMT3DInactiveAreaLayerType : TMT3DInactiveAreaLayerClass;
begin
  result := TMT3DInactiveAreaLayer;
end;

function TModflowTypesClass.GetMT3DObservationsLayerType : TMT3DObservationsLayerClass;
begin
  result := TMT3DObservationsLayer;
end;

{function TModflowTypesClass.GetMT3DPointConstantConcLayerType : TMT3DPointConstantConcLayerClass;
begin
  result := TMT3DPointConstantConcLayer;
end;

function TModflowTypesClass.GetMT3DAreaConstantConcLayerType : TMT3DAreaConstantConcLayerClass;
begin
  result := TMT3DAreaConstantConcLayer;
end;

{
function TModflowTypesClass.GetMT3DPointTimeVaryConcLayerType : TMT3DPointTimeVaryConcLayerClass;
begin
  result := TMT3DPointTimeVaryConcLayer;
end;
}

function TModflowTypesClass.GetMT3DAreaTimeVaryConcLayerType : TMT3DAreaTimeVaryConcLayerClass;
begin
  result := TMT3DAreaTimeVaryConcLayer;
end;

function TModflowTypesClass.GetMT3DPointInitConcLayerType : TMT3DPointInitConcLayerClass;
begin
  result := TMT3DPointInitConcLayer;
end;

function TModflowTypesClass.GetMT3DAreaInitConcLayerType : TMT3DAreaInitConcLayerClass;
begin
  result := TMT3DAreaInitConcLayer;
end;

function TModflowTypesClass.GetMT3DPrescribedHeadTimeParamListType : TMT3DPrescribedHeadTimeParamListClass;
begin
  result := TMT3DPrescribedHeadTimeParamList;
end;

{function TModflowTypesClass.GetMT3DPointTimeVaryConcTimeParamListType : TMT3DPointTimeVaryConcTimeParamListClass;
begin
  result := TMT3DPointTimeVaryConcTimeParamList;
end; }

function TModflowTypesClass.GetMT3DTimeVaryConcTimeParamListType : TMT3DTimeVaryConcTimeParamListClass;
begin
  result := TMT3DTimeVaryConcTimeParamList;
end;

{function TModflowTypesClass.GetMT3DAreaConstantConcParamClassType: TMT3DAreaConstantConcParamClass;
begin
  result := TMT3DAreaConstantConcParam;
end;    }

function TModflowTypesClass.GetMT3DDomOutlineParamClassType: TMT3DDomOutlineParamClass;
begin
  result := TMT3DDomOutlineParam;
end;

function TModflowTypesClass.GetMT3DMassParamClassType: TMT3DMassParamClass;
begin
  result := TMT3DMassParam;
end;

function TModflowTypesClass.GetMT3DConcentrationParamClassType: TMT3DConcentrationParamClass;
begin
  result := TMT3DConcentrationParam;
end;

function TModflowTypesClass.GetGridMT3DActiveCellParamClassType: TGridMT3DActiveCellParamClass;
begin
  result := TGridMT3DActiveCell;
end;

function TModflowTypesClass.GetGridMT3DICBUNDParamClassType: TGridMT3DICBUNDParamClass;
begin
  result := TGridMT3DICBUND;
end;

function TModflowTypesClass.GetGridMT3DInitConcCellParamClassType: TGridMT3DInitConcCellParamClass;
begin
  result := TGridMT3DInitConcCell;
end;

function TModflowTypesClass.GetGridMT3DLongDispCellParamClassType: TGridMT3DLongDispCellParamClass;
begin
  result := TGridMT3DLongDispCell;
end;

function TModflowTypesClass.GetGridMT3DObsLocCellParamClassType: TGridMT3DObsLocCellParamClass;
begin
  result := TGridMT3DObsLocCell;
end;

function TModflowTypesClass.GetGridMT3DTimeVaryConcCellParamClassType: TGridMT3DTimeVaryConcCellParamClass;
begin
  result := TGridMT3DTimeVaryConcCell;
end;

function TModflowTypesClass.GetGWT_BottomElevParam: TGWT_BottomElevParamClass;
begin
  result := TGWT_BottomElevParam;
end;

function TModflowTypesClass.GetGwt_ConcBoundaryClass: TGwt_ConcBoundaryClass;
begin
  result := TGwtConcBoundary
end;

function TModflowTypesClass.GetGWT_ConcentrationUsedParamType: TGWT_ConcentrationUsedClass;
begin
  result := TConcentrationUsed
end;

function TModflowTypesClass.GetGWT_TimeVaryConcLayerType: TGWT_TimeVaryConcLayerClass;
begin
  result := TGWT_TimeVaryConcLayer;
end;

function TModflowTypesClass.GetGWT_TimeVaryConcTimeParamList: TGWT_TimeVaryConcTimeParamListClass;
begin
  result := TGWT_TimeVaryConcTimeParamList;
end;

function TModflowTypesClass.GetGWT_TopElevParam: TGWT_TopElevParamClass;
begin
  result := TGWT_TopElevParam;
end;

function TModflowTypesClass.GetGWT_VolumeBalancingLayerClass: TGWT_VolumeBalancingLayerClass;
begin
  result := TGWT_VolumeBalancingLayer;
end;

function TModflowTypesClass.GetMT3DLongDispParamClassType: TMT3DLongDispParamClass;
begin
  result := TMT3DLongDisp;
end;

function TModflowTypesClass.GetMT3DInactiveAreaParamClassType: TMT3DInactiveAreaParamClass;
begin
  result := TMT3DInactiveAreaParam;
end;

function TModflowTypesClass.GetMT3DInitConcParamClassType: TMT3DInitConcParamClass;
begin
  result := TMT3DInitConcParam;
end;

function TModflowTypesClass.GetMT3DObservationsParamClassType: TMT3DObservationsParamClass;
begin
  result := TMT3DObservationsParam;
end;

function TModflowTypesClass.GetMT3DTopElevParamClassType: TMT3DTopElevParamClass;
begin
  result := TMT3DTopElevParam;
end;

function TModflowTypesClass.GetMT3DBottomElevParamClassType: TMT3DBottomElevParamClass;
begin
  result := TMT3DBottomElevParam;
end;

function TModflowTypesClass.GetMT3DDataLayerType: TMT3DDataLayerClass;
begin
  result := TMT3DDataLayer;
end;

function TModflowTypesClass.GetMT3DPostProcessChartLayerType: TMT3DPostProcessChartLayerClass;
begin
  result := TMT3DPostProcessChartLayer;
end;

function TModflowTypesClass.GetMT3DConc2ParamClassType: TMT3DConc2ParamClass;
begin
  result := TMT3DConc2Param;
end;

function TModflowTypesClass.GetMT3DConc3ParamClassType: TMT3DConc3ParamClass;
begin
  result := TMT3DConc3Param;
end;

function TModflowTypesClass.GetMT3DConc4ParamClassType: TMT3DConc4ParamClass;
begin
  result := TMT3DConc4Param;
end;

function TModflowTypesClass.GetMT3DConc5ParamClassType: TMT3DConc5ParamClass;
begin
  result := TMT3DConc5Param;
end;

function TModflowTypesClass.GetMFFHBMT3DConcTimeParamListType: TMFFHBMT3DConcTimeParamListClass;
begin
  result := TFHBMT3DConcTimeParamList;
end;

function TModflowTypesClass.GetGridMT3DInitConc2ParamClassType: TGridMT3DInitConc2ParamClass;
begin
  result := TGridMT3DInitConc2Cell;
end;

function TModflowTypesClass.GetGridMT3DInitConc3ParamClassType: TGridMT3DInitConc3ParamClass;
begin
  result := TGridMT3DInitConc3Cell;
end;

function TModflowTypesClass.GetGridMT3DInitConc4ParamClassType: TGridMT3DInitConc4ParamClass;
begin
  result := TGridMT3DInitConc4Cell;
end;

function TModflowTypesClass.GetGridMT3DInitConc5ParamClassType: TGridMT3DInitConc5ParamClass;
begin
  result := TGridMT3DInitConc5Cell;
end;

function TModflowTypesClass.GetMT3DMass2ParamClassType: TMT3DMass2ParamClass;
begin
  result := TMT3DMass2Param;
end;

function TModflowTypesClass.GetMT3DMass3ParamClassType: TMT3DMass3ParamClass;
begin
  result := TMT3DMass3Param;
end;

function TModflowTypesClass.GetMT3DMass4ParamClassType: TMT3DMass4ParamClass;
begin
  result := TMT3DMass4Param;
end;

function TModflowTypesClass.GetMT3DMass5ParamClassType: TMT3DMass5ParamClass;
begin
  result := TMT3DMass5Param;
end;

function TModflowTypesClass.GetMT3DInitConc2ParamClassType: TMT3DInitConc2ParamClass;
begin
  result := TMT3DInitConc2Param;
end;

function TModflowTypesClass.GetMT3DInitConc3ParamClassType: TMT3DInitConc3ParamClass;
begin
  result := TMT3DInitConc3Param;
end;

function TModflowTypesClass.GetMT3DInitConc4ParamClassType: TMT3DInitConc4ParamClass;
begin
  result := TMT3DInitConc4Param;
end;

function TModflowTypesClass.GetMT3DInitConc5ParamClassType: TMT3DInitConc5ParamClass;
begin
  result := TMT3DInitConc5Param;
end;

{function TModflowTypesClass.GetMT3DAreaConstantConc2ParamClassType: TMT3DAreaConstantConc2ParamClass;
begin
  result := TMT3DAreaConstantConc2Param;
end;

function TModflowTypesClass.GetMT3DAreaConstantConc3ParamClassType: TMT3DAreaConstantConc3ParamClass;
begin
  result := TMT3DAreaConstantConc3Param;
end;

function TModflowTypesClass.GetMT3DAreaConstantConc4ParamClassType: TMT3DAreaConstantConc4ParamClass;
begin
  result := TMT3DAreaConstantConc4Param;
end;

function TModflowTypesClass.GetMT3DAreaConstantConc5ParamClassType: TMT3DAreaConstantConc5ParamClass;
begin
  result := TMT3DAreaConstantConc5Param;
end;   }

function TModflowTypesClass.GetMT3DBulkDensityParamClassType: TMT3DBulkDensityParamClass;
begin
  result := TMT3DBulkDensityParam;
end;

function TModflowTypesClass.GetMT3DBulkDensityLayerType: TMT3DBulkDensityLayerClass;
begin
  result := TMT3DBulkDensityLayer;
end;

function TModflowTypesClass.GetMT3DImInitConc2ParamClassType: TMT3DImInitConc2ParamClass;
begin
  result := TMT3DImInitConc2Param;
end;

function TModflowTypesClass.GetMT3DImInitConc3ParamClassType: TMT3DImInitConc3ParamClass;
begin
  result := TMT3DImInitConc3Param;
end;

function TModflowTypesClass.GetMT3DImInitConc4ParamClassType: TMT3DImInitConc4ParamClass;
begin
  result := TMT3DImInitConc4Param;
end;

function TModflowTypesClass.GetMT3DImInitConc5ParamClassType: TMT3DImInitConc5ParamClass;
begin
  result := TMT3DImInitConc5Param;
end;

function TModflowTypesClass.GetMT3DSP1AParamClassType: TMT3DSP1AParamClass;
begin
  result := TSP1AParam;
end;

function TModflowTypesClass.GetMT3DSP1BParamClassType: TMT3DSP1BParamClass;
begin
  result := TSP1BParam;
end;

function TModflowTypesClass.GetMT3DSP1CParamClassType: TMT3DSP1CParamClass;
begin
  result := TSP1CParam;
end;

function TModflowTypesClass.GetMT3DSP1DParamClassType: TMT3DSP1DParamClass;
begin
  result := TSP1DParam;
end;

function TModflowTypesClass.GetMT3DSP1EParamClassType: TMT3DSP1EParamClass;
begin
  result := TSP1EParam;
end;

function TModflowTypesClass.GetMT3DSP2AParamClassType: TMT3DSP2AParamClass;
begin
  result := TSP2AParam;
end;

function TModflowTypesClass.GetMT3DSP2BParamClassType: TMT3DSP2BParamClass;
begin
  result := TSP2BParam;
end;

function TModflowTypesClass.GetMT3DSP2CParamClassType: TMT3DSP2CParamClass;
begin
  result := TSP2CParam;
end;

function TModflowTypesClass.GetMT3DSP2DParamClassType: TMT3DSP2DParamClass;
begin
  result := TSP2DParam;
end;

function TModflowTypesClass.GetMT3DSP2EParamClassType: TMT3DSP2EParamClass;
begin
  result := TSP2EParam;
end;

{function TModflowTypesClass.GetMT3DSorbInitConc2ParamClassType: TMT3DSorbInitConc2ParamClass;
begin
  result := TMT3DSorbInitConc2Param;
end;

function TModflowTypesClass.GetMT3DSorbInitConc3ParamClassType: TMT3DSorbInitConc3ParamClass;
begin
  result := TMT3DSorbInitConc3Param;
end;

function TModflowTypesClass.GetMT3DSorbInitConc4ParamClassType: TMT3DSorbInitConc4ParamClass;
begin
  result := TMT3DSorbInitConc4Param;
end;

function TModflowTypesClass.GetMT3DSorbInitConc5ParamClassType: TMT3DSorbInitConc5ParamClass;
begin
  result := TMT3DSorbInitConc5Param;
end;

function TModflowTypesClass.GetMT3DSorbInitConcParamClassType: TMT3DSorbInitConcParamClass;
begin
  result := TMT3DSorbInitConcParam;
end;

function TModflowTypesClass.GetMT3DSorbMass2ParamClassType: TMT3DSorbMass2ParamClass;
begin
  result := TMT3DSorbMass2Param;
end;

function TModflowTypesClass.GetMT3DSorbMass3ParamClassType: TMT3DSorbMass3ParamClass;
begin
  result := TMT3DSorbMass3Param;
end;

function TModflowTypesClass.GetMT3DSorbMass4ParamClassType: TMT3DSorbMass4ParamClass;
begin
  result := TMT3DSorbMass4Param;
end;

function TModflowTypesClass.GetMT3DSorbMass5ParamClassType: TMT3DSorbMass5ParamClass;
begin
  result := TMT3DSorbMass5Param;
end;

function TModflowTypesClass.GetMT3DSorbMassParamClassType: TMT3DSorbMassParamClass;
begin
  result := TMT3DSorbMassParam;
end;   }

function TModflowTypesClass.GetMT3DSorptionLayerType: TMT3DSorptionLayerClass;
begin
  result := TMT3DSorptionLayer;
end;

function TModflowTypesClass.GetMT3DRC1AParamClassType: TMT3DRC1AParamClass;
begin
  result := TRC1AParam;
end;

function TModflowTypesClass.GetMT3DRC1BParamClassType: TMT3DRC1BParamClass;
begin
  result := TRC1BParam;
end;

function TModflowTypesClass.GetMT3DRC1CParamClassType: TMT3DRC1CParamClass;
begin
  result := TRC1CParam;
end;

function TModflowTypesClass.GetMT3DRC1DParamClassType: TMT3DRC1DParamClass;
begin
  result := TRC1DParam;
end;

function TModflowTypesClass.GetMT3DRC1EParamClassType: TMT3DRC1EParamClass;
begin
  result := TRC1EParam;
end;

function TModflowTypesClass.GetMT3DRC2AParamClassType: TMT3DRC2AParamClass;
begin
  result := TRC2AParam;
end;

function TModflowTypesClass.GetMT3DRC2BParamClassType: TMT3DRC2BParamClass;
begin
  result := TRC2BParam;
end;

function TModflowTypesClass.GetMT3DRC2CParamClassType: TMT3DRC2CParamClass;
begin
  result := TRC2CParam;
end;

function TModflowTypesClass.GetMT3DRC2DParamClassType: TMT3DRC2DParamClass;
begin
  result := TRC2DParam;
end;

function TModflowTypesClass.GetMT3DRC2EParamClassType: TMT3DRC2EParamClass;
begin
  result := TRC2EParam;
end;

function TModflowTypesClass.GetMT3DReactionLayerType: TMT3DReactionLayerClass;
begin
  result := TMT3DReactionLayer
end;

function TModflowTypesClass.GetMT3DMassFluxAParamClassType: TMT3DMassFluxAParamClass;
begin
  result := TMassFluxAParam;
end;

function TModflowTypesClass.GetMT3DMassFluxBParamClassType: TMT3DMassFluxBParamClass;
begin
  result := TMassFluxBParam;
end;

function TModflowTypesClass.GetMT3DMassFluxCParamClassType: TMT3DMassFluxCParamClass;
begin
  result := TMassFluxCParam;
end;

function TModflowTypesClass.GetMT3DMassFluxDParamClassType: TMT3DMassFluxDParamClass;
begin
  result := TMassFluxDParam;
end;

function TModflowTypesClass.GetMT3DMassFluxEParamClassType: TMT3DMassFluxEParamClass;
begin
  result := TMassFluxEParam;
end;

function TModflowTypesClass.GetMFElevationParamType: TMFElevationParamClass;
begin
  result := TElevationParam;
end;

function TModflowTypesClass.GetMT3DMassFluxTimeParamListType: TMT3DMassFluxTimeParamListClass;
begin
  result := TMT3DMassFluxTimeParamList;
end;

function TModflowTypesClass.GetMT3DMassFluxLayerType: TMT3DMassFluxLayerClass;
begin
  result := TMT3DMassFluxLayer;
end;

function TModflowTypesClass.GetGridMT3DMassFluxParamClassType: TGridMT3DMassFluxParamClass;
begin
  result := TGridMT3DMassFluxCell;
end;

function TModflowTypesClass.GetMFGageOutputTypeParamType: TMFGageOutputTypeParamClass;
begin
  result := TGageOutputTypeParam;
end;

function TModflowTypesClass.GetMFLakeGroupLayerType: TMFLakeGroupLayerClass;
begin
  result := TLakeGroupLayer;
end;

function TModflowTypesClass.GetMFMODPATH_EndXParamClassType: TMFMODPATH_EndXParamClass;
begin
  result := TMODPATH_EndX
end;

function TModflowTypesClass.GetMFMODPATH_EndYParamClassType: TMFMODPATH_EndYParamClass;
begin
  result := TMODPATH_EndY
end;

function TModflowTypesClass.GetMFMODPATH_EndZParamClassType: TMFMODPATH_EndZParamClass;
begin
  result := TMODPATH_EndZ
end;

function TModflowTypesClass.GetMFMODPATH_StartXParamClassType: TMFMODPATH_StartXParamClass;
begin
  result := TMODPATH_StartX;
end;

function TModflowTypesClass.GetMFMODPATH_StartYParamClassType: TMFMODPATH_StartYParamClass;
begin
  result := TMODPATH_StartY;
end;

function TModflowTypesClass.GetMFMODPATH_StartZParamClassType: TMFMODPATH_StartZParamClass;
begin
  result := TMODPATH_StartZ;
end;

function TModflowTypesClass.GetMFReferenceStressPeriodParamClassType: TMFReferenceStressPeriodParamClass;
begin
  result := TReferenceStressPeriodParam;
end;

function TModflowTypesClass.GetMFMNW_ActiveParamClassType: TMFMNW_ActiveParamClass;
begin
  result := TMNW_ActiveParam;
end;

function TModflowTypesClass.GetMFMNW_DrawdownFlagParamClassType: TMFMNW_DrawdownFlagParamClass;
begin
  result := TMNW_DrawdownFlagParam;
end;

function TModflowTypesClass.GetMFMNW_GroupIndentifierParamClassType: TMFMNW_GroupIndentifierParamClass;
begin
  result := TMNW_GroupIndentifierParam;
end;

function TModflowTypesClass.GetMFMNW_InactivationPumpingRateParamClassType: TMFMNW_InactivationPumpingRateParamClass;
begin
  result := TMNW_InactivationPumpingRateParam;
end;

function TModflowTypesClass.GetMFMNW_LimitingElevationParamClassType: TMFMNW_LimitingElevationParamClass;
begin
  result := TMNW_LimitingElevationParam;
end;

function TModflowTypesClass.GetMFMNW_RadiusParamClassType: TMFMNW_RadiusParamClass;
begin
  result := TMNW_RadiusParam;
end;

function TModflowTypesClass.GetMFMNW_ReactivationPumpingRateParamClassType: TMFMNW_ReactivationPumpingRateParamClass;
begin
  result := TMNW_ReactivationPumpingRateParam;
end;

function TModflowTypesClass.GetMFMNW_ReferenceElevationParamClassType: TMFMNW_ReferenceElevationParamClass;
begin
  result := TMNW_ReferenceElevationParam;
end;

function TModflowTypesClass.GetMFMNW_SiteParamClassType: TMFMNW_SiteParamClass;
begin
  result := TMNW_SiteParam;
end;

function TModflowTypesClass.GetMFMNW_StressParamClassType: TMFMNW_StressParamClass;
begin
  result := TMNW_StressParam;
end;

function TModflowTypesClass.GetMFMNW_WaterQualityParamClassType: TMFMNW_WaterQualityParamClass;
begin
  result := TMNW_WaterQualityParam;
end;

function TModflowTypesClass.GetMFMNW_TimeParamListType: TMFMNW_TimeParamListClass;
begin
  result := TMNW_TimeParamList;
end;

function TModflowTypesClass.GetMFMNW_LayerType: TMFMNW_LayerClass;
begin
  result := TMNW_Layer;
end;

function TModflowTypesClass.GetMFMNW_SkinParamClassType: TMFMNW_SkinParamClass;
begin
  result := TMNW_SkinParam;
end;

function TModflowTypesClass.GetMFMNW_CoefficientParamClassType: TMFMNW_CoefficientParamClass;
begin
  result := TMNW_CoefficientParam;
end;

function TModflowTypesClass.GetMFMNW_OverriddenLastParamClassType: TMFMNW_OverriddenLastParamClass;
begin
  result := TMNW_OverriddenLastParam;
end;

function TModflowTypesClass.GetMFMNW_OverriddenFirstParamClassType: TMFMNW_OverriddenFirstParamClass;
begin
  result := TMNW_OverriddenFirstParam;
end;

function TModflowTypesClass.GetMFMNW_FirstElevationParamClassType: TMFMNW_FirstElevationParamClass;
begin
  result := TMNW_FirstElevationParam;
end;

function TModflowTypesClass.GetMFMNW_LastElevationParamClassType: TMFMNW_LastElevationParamClass;
begin
  result := TMNW_LastElevationParam;
end;

function TModflowTypesClass.GetMFGridMNW_LocationParamClassType: TMFGridMNW_LocationParamClass;
begin
  result := TGridMNW_Location;
end;

function TModflowTypesClass.GetMFMNW_FirstUnitParamClassType: TMFMNW_FirstUnitParamClass;
begin
  result := TMNW_FirstUnitParam;
end;

function TModflowTypesClass.GetMFMNW_LastUnitParamClassType: TMFMNW_LastUnitParamClass;
begin
  result := TMNW_LastUnitParam;
end;

function TModflowTypesClass.GetMFMNW_WaterQualityTimeParamListType: TMFMNW_WaterQualityTimeParamListClass;
begin
  result := TMNW_WaterQualityTimeParamList;
end;

function TModflowTypesClass.GetMFMNW_WaterQualityLayerType: TMFMNW_WaterQualityLayerClass;
begin
  result := TMNW_WaterQualityLayer;
end;

function TModflowTypesClass.GetMFMNW_PumpingLimitsParamClassType: TMFMNW_PumpingLimitsParamClass;
begin
  result := TMNW_PumpingLimitsParam;
end;

function TModflowTypesClass.GetMFMNW2_GeneralWellLayerType: TMFMNW2_GeneralWellLayerClass;
begin
  result := TMNW2_GeneralWellLayer;
end;

function TModflowTypesClass.GetMFMNW2_TimeParamListType: TMFMNW2_TimeParamListClass;
begin
  result := TMNW2_TimeParamList;
end;

function TModflowTypesClass.GetMFMNW2_VerticalWellLayerType: TMFMNW2_VerticalWellLayerClass;
begin
  result := TMNW2_VerticalWellLayer;
end;

function TModflowTypesClass.GetMFMNW2_WellScreenParamListType: TMFMNW2_WellScreenParamListClass;
begin
  result := TMNW2_WellScreenParamList;
end;

function TModflowTypesClass.GetMFMNW_AbsolutePumpingRatesParamClassType: TMFMNW_AbsolutePumpingRatesParamClass;
begin
  result := TMNW_AbsolutePumpingRatesParam;
end;

function TModflowTypesClass.GetMFDaflowA0ParamClassType: TMFDaflowA0ParamClass;
begin
  result := TDaflowA0Param;
end;

function TModflowTypesClass.GetMFDaflowA1ParamClassType: TMFDaflowA1ParamClass;
begin
  result := TDaflowA1Param;
end;

function TModflowTypesClass.GetMFDaflowA2ParamClassType: TMFDaflowA2ParamClass;
begin
  result := TDaflowA2Param;
end;

function TModflowTypesClass.GetMFDaflowBedElevationParamClassType: TMFDaflowBedElevationParamClass;
begin
  result := TDaflowBedElevationParam;
end;

function TModflowTypesClass.GetMFDaflowBedHydraulicConductivityParamClassType: TMFDaflowBedHydraulicConductivityParamClass;
begin
  result := TDaflowBedHydraulicConductivityParam;
end;

function TModflowTypesClass.GetMFDaflowBedSlopeParamClassType: TMFDaflowBedSlopeParamClass;
begin
  result := TDaflowBedSlopeParam;
end;

function TModflowTypesClass.GetMFDaflowBedThicknessParamClassType: TMFDaflowBedThicknessParamClass;
begin
  result := TDaflowBedThicknessParam;
end;

function TModflowTypesClass.GetMFDaflowBoundaryFlowParamClassType: TMFDaflowBoundaryFlowParamClass;
begin
  result := TDaflowBoundaryFlowParam;
end;

function TModflowTypesClass.GetMFDaflowDownstreamJunctionParamClassType: TMFDaflowDownstreamJunctionParamClass;
begin
  result := TDaflowDownstreamJunctionParam;
end;

function TModflowTypesClass.GetMFDaflowInitialFlowParamClassType: TMFDaflowInitialFlowParamClass;
begin
  result := TDaflowInitialFlowParam;
end;

function TModflowTypesClass.GetMFDaflowPrintParamClassType: TMFDaflowPrintParamClass;
begin
  result := TDaflowPrintParam;
end;

function TModflowTypesClass.GetMFDaflowTortuosityParamClassType: TMFDaflowTortuosityParamClass;
begin
  result := TDaflowTortuosityParam;
end;

function TModflowTypesClass.GetMFDaflowUpstreamFlowFractionParamClassType: TMFDaflowUpstreamFlowFractionParamClass;
begin
  result := TDaflowUpstreamFlowFractionParam;
end;

function TModflowTypesClass.GetMFDaflowUpstreamJunctionParamClassType: TMFDaflowUpstreamJunctionParamClass;
begin
  result := TDaflowUpstreamJunctionParam;
end;

function TModflowTypesClass.GetMFDaflowW1ParamClassType: TMFDaflowW1ParamClass;
begin
  result := TDaflowW1Param;
end;

function TModflowTypesClass.GetMFDaflowW2ParamClassType: TMFDaflowW2ParamClass;
begin
  result := TDaflowW2Param;
end;

function TModflowTypesClass.GetMFDaflowIsNewBoundaryParamClassType: TMFDaflowIsNewBoundaryParamClass;
begin
  result := TDaflowIsNewBoundaryParam;
end;

function TModflowTypesClass.GetMFDaflowOverridenBedElevationParamClassType: TMFDaflowOverridenBedElevationParamClass;
begin
  result := TDaflowOverridenBedElevationParam;
end;

function TModflowTypesClass.GetMFDaflowTimeParamListType: TMFDaflowTimeParamListClass;
begin
  result := TDaflowTimeParamList;
end;

function TModflowTypesClass.GetMFDaflowLayerType: TMFDaflowLayerClass;
begin
  result := TDaflowLayer;
end;

function TModflowTypesClass.GetMFDaflowOverrideInitialFlowParamClassType: TMFDaflowOverridenInitialFlowParamClass;
begin
  result := TDaflowOverridenInitialFlowParam;
end;

function TModflowTypesClass.GetMFObjectObservationNameParamClassType: TMFObjectObservationNameParamClass;
begin
  result := TObjectObservationNameParam;
end;

function TModflowTypesClass.GetMFHUF_ReferenceSurfaceLayerClassType: TMFHUF_ReferenceSurfaceLayerClass;
begin
  result := THUF_ReferenceSurfaceLayer;
end;

function TModflowTypesClass.GetMFHUF_ReferenceSurfaceParamClassType: TMFHUF_ReferenceSurfaceParamClass;
begin
  result := THUF_ReferenceSurfaceParameter;
end;

function TModflowTypesClass.GetMFNoDelayIndexedParamListType: TMFNoDelayIndexedParamListClass;
begin
  result := TNoDelayIndexedParamList
end;

function TModflowTypesClass.GetMFElasticStorageCoefficientParamType: TMFElasticStorageCoefficientParamClass;
begin
  result := TElasticStorageCoefficientParam;
end;

function TModflowTypesClass.GetMFInelasticStorageCoefficientParamType: TMFInelasticStorageCoefficientParamClass;
begin
  result := TInelasticStorageCoefficientParam;
end;

function TModflowTypesClass.GetMFEquivalentNumberParamType: TMFEquivalentNumberParamClass;
begin
  result := TEquivalentNumberParam;
end;

function TModflowTypesClass.GetMFEquivalentThicknessParamType: TMFEquivalentThicknessParamClass;
begin
  result := TEquivalentThicknessParam;
end;

function TModflowTypesClass.GetMFStartingHeadParamType: TMFStartingHeadParamClass;
begin
  result := TStartingHeadParam;
end;

function TModflowTypesClass.GetMFVerticalHydraulicConductivityParamType: TMFVerticalHydraulicConductivityParamClass;
begin
  result := TVerticalHydraulicConductivityParam;
end;

function TModflowTypesClass.GetMFDelayIndexedParamListType: TMFDelayIndexedParamListClass;
begin
  result := TDelayIndexedParamList;
end;

function TModflowTypesClass.GetMFDelaySubsidenceLayerType: TMFDelaySubsidenceLayerClass;
begin
  result := TDelaySubsidenceLayer;
end;

function TModflowTypesClass.GetMFNoDelaySubsidenceLayerType: TMFNoDelaySubsidenceLayerClass;
begin
  result := TNoDelaySubsidenceLayer;
end;

function TModflowTypesClass.GetMFElasticSpecificStorageParamType: TMFElasticSpecificStorageParamClass;
begin
  result := TElasticSpecificStorageParam;
end;

function TModflowTypesClass.GetMFInelasticSpecificStorageParamType: TMFInelasticSpecificStorageParamClass;
begin
  result := TInelasticSpecificStorageParam;
end;

function TModflowTypesClass.GetMFStreamGageOutputTypeParamType: TMFStreamGageOutputTypeParamClass;
begin
  result := TStreamGageOutputTypeParam;
end;

function TModflowTypesClass.GetMFSKStreamUpWidthParamType: TMFSKStreamUpWidthTypeParamClass;
begin
  result := TMFSKStreamUpWidthParam;
end;

function TModflowTypesClass.GetMFDrainConductanceParamType: TMFDrainConductanceParamClass;
begin
  result := TDrainConductanceParam;
end;

function TModflowTypesClass.GetMFDrainReturnConductanceParamType: TMFDrainReturnConductanceParamClass;
begin
  result := TDrainReturnConductanceParam;
end;

function TModflowTypesClass.GetMFGhbConductanceParamType: TMFGhbConductanceParamClass;
begin
  result := TGhbConductanceParam;
end;

function TModflowTypesClass.GetMFRiverConductanceParamType: TMFRiverConductanceParamClass;
begin
  result := TRiverConductanceParam;
end;

function TModflowTypesClass.GetMFFluidDensityParamType: TMFFluidDensityParamClass;
begin
  result := TFluidDensityParam;
end;

function TModflowTypesClass.GetMFFluidDensityTimeParamListType: TMFFluidDensityTimeParamListClass;
begin
  result := TFluidDensityTimeParamList;
end;

function TModflowTypesClass.GetFluidDensityLayerType: TMFFluidDensityLayerClass;
begin
  result := TFluidDensityLayer;
end;

function TModflowTypesClass.GetMFBoundaryDensityParamType: TMFBoundaryDensityParamClass;
begin
  result := TBoundaryDensityParam;
end;

function TModflowTypesClass.GetMFDrainBottomElevParamType: TMFDrainBottomElevParamClass;
begin
  result := TDrainBottomElevParam;
end;

function TModflowTypesClass.GetMFRiverBedThicknessParamType: TMFRiverBedThicknessParamClass;
begin
  result := TRiverBedThicknessParam;
end;

function TModflowTypesClass.GetMFColumnCountParamType: TMFColumnCountParamClass;
begin
  result := TColumnCountParam;
end;

function TModflowTypesClass.GetMFLayerCountParamType: TMFLayerCountParamClass;
begin
  result := TLayerCountParam;
end;

function TModflowTypesClass.GetMFLeakConductanceParamListType: TMFLeakConductanceParamListClass;
begin
  result := TLeakConductanceTimeList;
end;

function TModflowTypesClass.GetMFRowCountParamType: TMFRowCountParamClass;
begin
  result := TRowCountParam;
end;

function TModflowTypesClass.GetMOCInitialParticlePlacementLayerType: TMFMOCInitialParticlePlacementLayerClass;
begin
  result := TMOCInitialParticlePlacementLayer;
end;

function TModflowTypesClass.GetMFGridMOCParticleColumnCountParamType: TMFGridMOCParticleColumnCountParamClass;
begin
  result := TGridMOCParticleColumnCount;
end;

function TModflowTypesClass.GetMFGridMOCParticleLayerCountParamType: TMFGridMOCParticleLayerCountParamClass;
begin
  result := TGridMOCParticleLayerCount;
end;

function TModflowTypesClass.GetMFGridMOCParticleRowCountParamType: TMFGridMOCParticleRowCountParamClass;
begin
  result := TGridMOCParticleRowCount;
end;

function TModflowTypesClass.GetMFGridMocParticleLocationParamType: TMFGridMocParticleLocationParamClass;
begin
  result := TGridMocParticleLocation;
end;

function TModflowTypesClass.GetMFLowerBoundaryConcentrationParamType: TMFLowerBoundaryConcentrationParamClass;
begin
  result := TLowerBoundaryConcentrationParam;
end;

function TModflowTypesClass.GetMFUpperBoundaryConcentrationParamType: TMFUpperBoundaryConcentrationParamClass;
begin
  result := TUpperBoundaryConcentrationParam;
end;

function TModflowTypesClass.GetMOCLowerBoundaryConcentrationLayerType: TMFMOCLowerBoundaryConcentrationLayerClass;
begin
  result := TLowerBoundaryConcentrationLayer;
end;

function TModflowTypesClass.GetMOCUpperBoundaryConcentrationLayerType: TMFMOCUpperBoundaryConcentrationLayerClass;
begin
  result := TUpperBoundaryConcentrationLayer;
end;

function TModflowTypesClass.GetMFGridGwtLowBoundConcParamType: TMFGridGwtLowBoundConcParamClass;
begin
  result := TGridGwtLowBoundConc;
end;

function TModflowTypesClass.GetMFGridGwtUppBoundConcParamType: TMFGridGwtUppBoundConcParamClass;
begin
  result := TGridGwtUppBoundConc;
end;

function TModflowTypesClass.GetMFFluxStatParamType: TMFFluxStatParamClass;
begin
  result := TFluxStat;
end;

function TModflowTypesClass.GetMFFluxTypeParamType: TMFFluxTypeParamClass;
begin
  result := TFluxType;
end;

function TModflowTypesClass.GetMFFluxVariableNameParamType: TMFFluxVariableNameParamClass;
begin
  result := TFluxVariableName;
end;

function TModflowTypesClass.GetMFGWM_UseInPeriodParamType: TMFGWM_UseInPeriodParamClass;
begin
  result := TGWM_UseInPeriod;
end;

function TModflowTypesClass.GetMFGWM_TimeParamListType: TMFGWM_TimeParamListClass;
begin
  result := TGWM_TimeParamList;
end;

function TModflowTypesClass.GetMFFluxVariableLayerType: TMFFluxVariableLayerClass;
begin
  result := TFluxVariableLayer;
end;

function TModflowTypesClass.GetMFFluxVariableRatioParamType: TMFFluxVariableRatioParamClass;
begin
  result := TFluxVariableRatio;
end;

function TModflowTypesClass.GetMFHeadConstraintBoundaryParamType: TMFHeadConstraintBoundaryParamClass;
begin
  result := THeadConstraintBoundary;
end;

function TModflowTypesClass.GetMFHeadConstraintNameParamType: TMFHeadConstraintNameParamClass;
begin
  result := THeadConstraintName;
end;

function TModflowTypesClass.GetMFHeadConstraintTypeParamType: TMFHeadConstraintTypeParamClass;
begin
  result := THeadConstraintType;
end;

function TModflowTypesClass.GetMFHeadConstraintLayerType: TMFHeadConstraintLayerClass;
begin
  result := THeadConstraintLayer;
end;

function TModflowTypesClass.GetMFDrawdownConstraintNameParamType: TMFDrawdownConstraintNameParamClass;
begin
  result := TDrawdownConstraintName;
end;

function TModflowTypesClass.GetMFDrawdownConstraintLayerType: TMFDrawdownConstraintLayerClass;
begin
  result := TDrawdownConstraintLayer;
end;

function TModflowTypesClass.GetMFDrawdownConstraintTypeParamType: TMFDrawdownConstraintTypeParamClass;
begin
  result := TDrawdownConstraintType;
end;

function TModflowTypesClass.GetMFHeadDifferenceNameParamType: TMFHeadDifferenceNameParamClass;
begin
  result := THeadDifferenceName;
end;

function TModflowTypesClass.GetMFHeadDifferenceValueParamType: TMFHeadDifferenceValueParamClass;
begin
  result := THeadDifferenceValue;
end;

function TModflowTypesClass.GetMFHeadDifferenceLayerType: TMFHeadDifferenceLayerClass;
begin
  result := THeadDifferenceLayer;
end;

function TModflowTypesClass.GetMFFirstParamType: TMFFirstParamClass;
begin
  result := TFirst;
end;

function TModflowTypesClass.GetMFGradientLengthParamType: TMFGradientLengthParamClass;
begin
  result := TGradientLength;
end;

function TModflowTypesClass.GetMFGradientNameParamType: TMFGradientNameParamClass;
begin
  result := TGradientName;
end;

function TModflowTypesClass.GetMFGradientValueParamType: TMFGradientValueParamClass;
begin
  result := TGradientValue;
end;

function TModflowTypesClass.GetMFGradientLayerType: TMFGradientLayerClass;
begin
  result := TGradientLayer;
end;

function TModflowTypesClass.GetMFStreamFlowNameParamType: TMFStreamFlowNameParamClass;
begin
  result := TStreamFlowName;
end;

function TModflowTypesClass.GetMFStreamflowValueParamType: TMFStreamflowValueParamClass;
begin
  result := TStreamflowValue;
end;

function TModflowTypesClass.GetMFStreamConstraintLayerType: TMFStreamConstraintLayerClass;
begin
  result := TStreamConstraintLayer;
end;

function TModflowTypesClass.GetMFStreamDepletionNameParamType: TMFStreamDepletionNameParamClass;
begin
  result := TStreamDepletionName;
end;

function TModflowTypesClass.GetMFStreamDepletionValueParamType: TMFStreamDepletionValueParamClass;
begin
  result := TStreamDepletionValue;
end;

function TModflowTypesClass.GetMFStreamDepletionConstraintLayerType: TMFStreamDepletionConstraintLayerClass;
begin
  result := TStreamDepletionConstraintLayer;
end;

function TModflowTypesClass.GetMFFluxMaximumParamType: TMFFluxMaximumParamClass;
begin
  result := TFluxMaximum;
end;

function TModflowTypesClass.GetMFFluxMinimumParamType: TMFFluxMinimumParamClass;
begin
  result := TFluxMinimum;
end;

function TModflowTypesClass.GetMFFluxReferenceParamType: TMFFluxReferenceParamClass;
begin
  result := TFluxReference;
end;

function TModflowTypesClass.GetMFFluxBaseParamType: TMFFluxBaseParamClass;
begin
  result := TFluxBase;
end;

function TModflowTypesClass.GetMFGradientEndElevationParamType: TMFGradientEndElevationParamClass;
begin
  result := TGradientEndElevation;
end;

function TModflowTypesClass.GetMFGradientStartElevationParamType: TMFGradientStartElevationParamClass;
begin
  result := TGradientStartElevation;
end;

function TModflowTypesClass.GetMFSfr2BrooksCoreyExponentParamType: TMFSfr2BrooksCoreyExponentParamClass;
begin
  result := TSfr2BrooksCoreyExponent;
end;

function TModflowTypesClass.GetMFSfr2InitialWaterContentParamType: TMFSfr2InitialWaterContentParamClass;
begin
  result := TSfr2InitialWaterContent;
end;

function TModflowTypesClass.GetMFSfr2SaturatedWaterContentParamType: TMFSfr2SaturatedWaterContentParamClass;
begin
  result := TSfr2SaturatedWaterContent;
end;

function TModflowTypesClass.GetMFSfr2StreambedThicknessParamType: TMFSfr2StreambedThicknessParamClass;
begin
  result := TSfr2StreambedThickness;
end;

function TModflowTypesClass.GetMFSfr2StreambedTopElevParamType: TMFSfr2StreambedTopElevParamClass;
begin
  result := TSfr2StreambedTopElev;
end;

function TModflowTypesClass.GetMFSfr2UnsatZoneHydraulicConductivityParamType: TMFSfr2UnsatZoneHydraulicConductivityParamClass;
begin
  result := TSfr2UnsatZoneHydraulicConductivity;
end;

function TModflowTypesClass.GetMFSfr2DownstreamBrooksCoreyExponentParamType: TMFSfr2DownstreamBrooksCoreyExponentParamClass;
begin
  result := TSfr2DownstreamBrooksCoreyExponent
end;

function TModflowTypesClass.GetMFSfr2DownstreamInitialWaterContentParamType: TMFSfr2DownstreamInitialWaterContentParamClass;
begin
  result := TSfr2DownstreamInitialWaterContent
end;

function TModflowTypesClass.GetMFSfr2DownstreamSaturatedWaterContentParamType: TMFSfr2DownstreamSaturatedWaterContentParamClass;
begin
  result := TSfr2DownstreamSaturatedWaterContent
end;

function TModflowTypesClass.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType: TMFSfr2DownstreamUnsatZoneHydraulicConductivityParamClass;
begin
  result := TSfr2DownstreamUnsatZoneHydraulicConductivity
end;

function TModflowTypesClass.GetMFSfr2UpstreamBrooksCoreyExponentParamType: TMFSfr2UpstreamBrooksCoreyExponentParamClass;
begin
  result := TSfr2UpstreamBrooksCoreyExponent
end;

function TModflowTypesClass.GetMFSfr2UpstreamInitialWaterContentParamType: TMFSfr2UpstreamInitialWaterContentParamClass;
begin
  result := TSfr2UpstreamInitialWaterContent
end;

function TModflowTypesClass.GetMFSfr2UpstreamSaturatedWaterContentParamType: TMFSfr2UpstreamSaturatedWaterContentParamClass;
begin
  result := TSfr2UpstreamSaturatedWaterContent
end;

function TModflowTypesClass.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType: TMFSfr2UpstreamUnsatZoneHydraulicConductivityParamClass;
begin
  result := TSfr2UpstreamUnsatZoneHydraulicConductivity
end;


function TModflowTypesClass.GetMFGageDiversioParamType: TMFGageDiversionParamClass;
begin
  result := TGageDiversionParam;
end;

function TModflowTypesClass.GetMFUnsatGageParamType: TMFUnsatGageParamClass;
begin
  result := TUnsatGageParam;
end;

function TModflowTypesClass.GetMFUnsatProfileGageParamType: TMFUnsatProfileGageParamClass;
begin
  result := TUnsatProfileGageParam;
end;

function TModflowTypesClass.GetMFMoc3dParticleObsParamType: TMFMoc3dParticleObsParamClass;
begin
  result := TMoc3dParticleObsParam
end;

function TModflowTypesClass.GetMFMoc3dParticleObsLayerType: TMFMoc3dParticleObsLayerClass;
begin
  result := TMoc3dParticleObsLayer;
end;

function TModflowTypesClass.GetMFGridMocParticleObservationParamType: TMFGridMocParticleObservationParamClass;
begin
  result := TGridMocParticleObservation
end;

function TModflowTypesClass.GetMFMNW_OutputFlagParamType: TMFMNW_OutputFlagParamClass;
begin
  result := TMNW_OutputFlag;
end;

function TModflowTypesClass.GetMFLateralBoundaryConcentrationParamType: TMFLateralBoundaryConcentrationParamClass;
begin
  result := TLateralBoundaryConcentrationParam
end;

function TModflowTypesClass.GetMOCLateralBoundaryConcentrationLayerType: TMFLateralBoundaryConcentrationLayerClass;
begin
  result := TLateralBoundaryConcentrationLayer;
end;

function TModflowTypesClass.GetMFGridGwtLateralBoundConcParamType: TMFGridGwtLateralBoundConcParamClass;
begin
  result := TGridGwtLateralBoundConc;
end;

function TModflowTypesClass.GetMFLowerMpathElevationParamType: TMFLowerMpathElevationParamClass;
begin
  result := TLowerMpathElevation;
end;

function TModflowTypesClass.GetMFUpperMpathElevationParamType: TMFUpperMpathElevationParamClass;
begin
  result := TUpperMpathElevation;
end;

function TModflowTypesClass.GetMFMNW_IsPTOB_ObservationParamType: TMFMNW_IsPTOB_ObservationParamClass;
begin
  result := TMNW_IsPTOB_Observation;
end;

function TModflowTypesClass.GetMFUzfBrooksCoreyEpsilonParamType: TMFUzfBrooksCoreyEpsilonParamClass;
begin
  result := TUzfBrooksCoreyEpsilon;
end;

function TModflowTypesClass.GetMFUzfExtinctionDepthParamType: TMFUzfExtinctionDepthParamClass;
begin
  result := TUzfExtinctionDepth;
end;

function TModflowTypesClass.GetMFUzfExtinctionWaterContentParamType: TMFUzfExtinctionWaterContentParamClass;
begin
  result := TUzfExtinctionWaterContent;
end;

function TModflowTypesClass.GetMFUzfInfiltrationRateParamType: TMFUzfInfiltrationRateParamClass;
begin
  result := TUzfInfiltrationRate;
end;

function TModflowTypesClass.GetMFUzfInitialWaterContentParamType: TMFUzfInitialWaterContentParamClass;
begin
  result := TUzfInitialWaterContent;
end;

function TModflowTypesClass.GetMFUzfPotentialEvapotranspirationParamType: TMFUzfPotentialEvapotranspirationParamClass;
begin
  result := TUzfPotentialEvapotranspiration;
end;

function TModflowTypesClass.GetMFUzfSaturatedKzParamType: TMFUzfSaturatedKzParamClass;
begin
  result := TUzfSaturatedKz;
end;

function TModflowTypesClass.GetMFUzfSaturatedWaterContentParamType: TMFUzfSaturatedWaterContentParamClass;
begin
  result := TUzfSaturatedWaterContent;
end;

function TModflowTypesClass.GetMFUzfTimeParamListType: TMFUzfTimeParamListClass;
begin
  result := TUzfTimeParamList;
end;

function TModflowTypesClass.GetMFUzfLayerParamType: TMFUzfLayerParamClass;
begin
  result := TUzfLayerParam;
end;

function TModflowTypesClass.GetMFUzfStreamLakeParamType: TMFUzfStreamLakeParamClass;
begin
  result := TUzfStreamLakeParam;
end;

function TModflowTypesClass.GetMFUzfOutputParamType: TMFUzfOutputParamClass;
begin
  result := TUzfOutputParam;
end;

function TModflowTypesClass.GetMFUzfFlowLayerType: TMFUzfFlowLayerClass;
begin
  result := TUzfFlowLayer;
end;

function TModflowTypesClass.GetMFUzfGroupLayerType: TMFUzfGroupLayerClass;
begin
  result := TUzfGroupLayer;
end;

function TModflowTypesClass.GetMFUzfLayerLayerType: TMFUzfLayerLayerClass;
begin
  result := TUzfLayer;
end;

function TModflowTypesClass.GetMFUzfOutputLayerType: TMFUzfOutputLayerClass;
begin
  result := TUzfOutputLayer;
end;

function TModflowTypesClass.GetMFUzfStreamLakeLayerType: TMFUzfStreamLakeLayerClass;
begin
  result := TUzfStreamLakeLayer;
end;

function TModflowTypesClass.GetMFGridUzfBrooksCoreyEpsilonParamType: TMFGridUzfBrooksCoreyEpsilonParamClass;
begin
  result := TGridUzfBrooksCoreyEpsilon;
end;

function TModflowTypesClass.GetMFGridUzfDownstreamStreamOrLakeParamType: TMFGridUzfDownstreamStreamOrLakeParamClass;
begin
  result := TGridUzfDownstreamStreamOrLake;
end;

function TModflowTypesClass.GetMFGridUzfExtinctionDepthParamType: TMFGridUzfExtinctionDepthParamClass;
begin
  result := TGridUzfExtinctionDepth;
end;

function TModflowTypesClass.GetMFGridUzfExtinctionWaterContentParamType: TMFGridUzfExtinctionWaterContentParamClass;
begin
  result := TGridUzfExtinctionWaterContent;
end;

function TModflowTypesClass.GetMFGridUzfInitialWaterContentParamType: TMFGridUzfInitialWaterContentParamClass;
begin
  result := TGridUzfInitialWaterContent;
end;

function TModflowTypesClass.GetMFGridUzfModflowLayerParamType: TMFGridUzfModflowLayerParamClass;
begin
  result := TGridUzfModflowLayerParam;
end;

function TModflowTypesClass.GetMFGridUzfOutputChoiceParamType: TMFGridUzfOutputChoiceParamClass;
begin
  result := TGridUzfOutputChoice;
end;

function TModflowTypesClass.GetMFGridUzfSaturatedKzParamType: TMFGridUzfSaturatedKzParamClass;
begin
  result := TGridUzfSaturatedKz;
end;

function TModflowTypesClass.GetMFGridUzfSaturatedWaterContentParamType: TMFGridUzfSaturatedWaterContentParamClass;
begin
  result := TGridUzfSaturatedWaterContent;
end;

function TModflowTypesClass.GetMT3DMolDiffAParamClassType: TMT3DMolDiffAParamClass;
begin
  result := TMolDiffAParam;
end;

function TModflowTypesClass.GetMT3DMolDiffBParamClassType: TMT3DMolDiffBParamClass;
begin
  result := TMolDiffBParam;
end;

function TModflowTypesClass.GetMT3DMolDiffCParamClassType: TMT3DMolDiffCParamClass;
begin
  result := TMolDiffCParam;
end;

function TModflowTypesClass.GetMT3DMolDiffDParamClassType: TMT3DMolDiffDParamClass;
begin
  result := TMolDiffDParam;
end;

function TModflowTypesClass.GetMT3DMolDiffEParamClassType: TMT3DMolDiffEParamClass;
begin
  result := TMolDiffEParam;
end;

function TModflowTypesClass.GetMFMT3DMolecularDiffusionLayerType: TMT3DMolecularDiffusionLayerClass;
begin
  result := TMT3DMolecularDiffusionLayer;
end;

function TModflowTypesClass.GetMFGeostaticStressParamType: TMFGeostaticStressParamClass;
begin
  result := TGeostaticStressParam;
end;

function TModflowTypesClass.GetMFSaturatedSpecificGravityParamType: TMFSaturatedSpecificGravityParamClass;
begin
  result := TSaturatedSpecificGravityParam;
end;

function TModflowTypesClass.GetMFUnsaturatedSpecificGravityParamType: TMFUnsaturatedSpecificGravityParamClass;
begin
  result := TUnsaturatedSpecificGravityParam;
end;

function TModflowTypesClass.GetMFCompressionIndexParamType: TMFCompressionIndexParamClass;
begin
  result := TCompressionIndexParam;
end;

function TModflowTypesClass.GetMFInitialCompactionParamType: TMFInitialCompactionParamClass;
begin
  result := TInitialCompactionParam;
end;

function TModflowTypesClass.GetMFInitialEffectiveStressOffsetParamType: TMFInitialEffectiveStressOffsetParamClass;
begin
  result := TInitialEffectiveStressOffsetParam;
end;

function TModflowTypesClass.GetMFInitialElasticSpecificStorageParamType: TMFInitialElasticSpecificStorageParamClass;
begin
  result := TInitialElasticSpecificStorageParam;
end;

function TModflowTypesClass.GetMFInitialInelasticSpecificStorageParamType: TMFInitialInelasticSpecificStorageParamClass;
begin
  result := TInitialInelasticSpecificStorageParam;
end;

function TModflowTypesClass.GetMFInitialPreconsolidationStressParamType: TMFInitialPreconsolidationStressParamClass;
begin
  result := TInitialPreconsolidationStressParam;
end;

function TModflowTypesClass.GetMFInitialVoidRatioParamType: TMFInitialVoidRatioParamClass;
begin
  result := TInitialVoidRatioParam;
end;

function TModflowTypesClass.GetMFRecompressionIndexParamType: TMFRecompressionIndexParamClass;
begin
  result := TRecompressionIndexParam;
end;

function TModflowTypesClass.GetMFSwtThicknessParamType: TMFSwtThicknessParamClass;
begin
  result := TSwtThicknessParam;
end;

function TModflowTypesClass.GetMFSwtIndexedParamListType: TMFSwtIndexedParamListClass;
begin
  result := TSwtIndexedParamList;
end;

function TModflowTypesClass.GetMF_GridGwmZoneParamType: TMF_GridGwmZoneParamClass;
begin
  result := TGridGwmZone;
end;

function TModflowTypesClass.GetMF_GwmElevationParamType: TMF_GwmElevationParamClass;
begin
  result := TGwmElevationParam;
end;

function TModflowTypesClass.GetMF_GwmNameParamType: TMF_GwmNameParamClass;
begin
  result := TGwmNameParam;
end;

function TModflowTypesClass.GetMF_GwmSegmentParamType: TMF_GwmSegmentParamClass;
begin
  result := TGwmSegmentParam;
end;

function TModflowTypesClass.GetMF_GwmStressPeriodParamType: TMF_GwmStressPeriodParamClass;
begin
  result := TGwmStressPeriodParam;
end;

function TModflowTypesClass.GetMF_GwmZoneNumberParamType: TMF_GwmZoneNumberParamClass;
begin
  result := TGwmZoneNumberParam;
end;

function TModflowTypesClass.GetMF_MNW2_ActiveParamType: TMF_MNW2_ActiveClass;
begin
  result := TMNW2_ActiveParam;
end;

function TModflowTypesClass.GetMF_MNW2_BottomWellScreenParamType: TMF_MNW2_BottomWellScreenParamClass;
begin
  result := TMNW2_BottomWellScreenParam;
end;

function TModflowTypesClass.GetMF_MNW2_BParamType: TMF_MNW2_BParamClass;
begin
  result := TMNW2_BParam;
end;

function TModflowTypesClass.GetMF_MNW2_CellToWellConductanceParamType: TMF_MNW2_CellToWellConductanceParamClass;
begin
  result := TMNW2_CellToWellConductanceParam;
end;

function TModflowTypesClass.GetMF_MNW2_ConstrainPumpingParamType: TMF_MNW2_ConstrainPumpingParamClass;
begin
  result := TMNW2_ConstrainPumpingParam;
end;

function TModflowTypesClass.GetMF_MNW2_CParamType: TMF_MNW2_CParamClass;
begin
  result := TMNW2_CParam;
end;

function TModflowTypesClass.GetMF_MNW2_DischargeElevationParamType: TMF_MNW2_DischargeElevationParamClass;
begin
  result := TMNW2_DischargeElevationParam;
end;

function TModflowTypesClass.GetMF_MNW2_HeadCapacityMultiplierParamType: TMF_MNW2_HeadCapacityMultiplierParamClass;
begin
  result := TMNW2_HeadCapacityMultiplierParam;
end;

function TModflowTypesClass.GetMF_MNW2_InactivationPumpingRateParamType: TMF_MNW2_InactivationPumpingRateParamClass;
begin
  result := TMNW2_InactivationPumpingRateParam;
end;

function TModflowTypesClass.GetMF_MNW2_LimitingWaterLevelParamType: TMF_MNW2_LimitingWaterLevelParamClass;
begin
  result := TMNW2_LimitingWaterLevelParam;
end;

function TModflowTypesClass.GetMF_MNW2_LossTypeParamType: TMF_MNW2_LossTypeParamClass;
begin
  result := TMNW2_LossTypeParam;
end;

function TModflowTypesClass.GetMF_MNW2_LowerElevParamType: TMF_MNW2_LowerElevParamClass;
begin
  result := TMNW2_LowerElevParam
end;

function TModflowTypesClass.GetMF_MNW2_MonitorConcentrationParamType: TMF_MNW2_MonitorConcentrationParamClass;
begin
  result := TMonitorConcentrationParam;
end;

function TModflowTypesClass.GetMF_MNW2_MonitorExternalFlowParamType: TMF_MNW2_MonitorExternalFlowParamClass;
begin
  result := TMonitorExternalFlowParam;
end;

function TModflowTypesClass.GetMF_MNW2_MonitorInternalFlowParamType: TMF_MNW2_MonitorInternalFlowParamClass;
begin
  result := TMonitorInternalFlowParam;
end;

function TModflowTypesClass.GetMF_MNW2_MonitorWellFlowParamType: TMF_MNW2_MonitorWellParamClass;
begin
  result := TMonitorWellFlowParam;
end;

function TModflowTypesClass.GetMF_MNW2_NodeCountParamType: TMF_MNW2_NodeCountParamClass;
begin
  result := TMNW2_NodeCountParam;
end;

function TModflowTypesClass.GetMF_MNW2_OrderParamType: TMF_MNW2_OrderParamClass;
begin
  result := TMNW2_OrderParam
end;

function TModflowTypesClass.GetMF_MNW2_PartialPenetrationFlagParamType: TMF_MNW2_PartialPenetrationFlagParamClass;
begin
  result := TMNW2_PartialPenetrationFlagParam;
end;

function TModflowTypesClass.GetMF_MNW2_PParamType: TMF_MNW2_PParamClass;
begin
  result := TMNW2_PParam;
end;

function TModflowTypesClass.GetMF_MNW2_PumpElevationParamType: TMF_MNW2_PumpElevationParamClass;
begin
  result := TMNW2_PumpElevationParam;
end;

function TModflowTypesClass.GetMF_MNW2_PumpingLimitTypeParamType: TMF_MNW2_PumpingLimitTypeParamClass;
begin
  result := TMNW2_PumpingLimitTypeParam;
end;

function TModflowTypesClass.GetMF_MNW2_PumpingRateParamType: TMF_MNW2_PumpingRateParamClass;
begin
  result := TMNW2_PumpingRateParam;
end;

function TModflowTypesClass.GetMF_MNW2_PumpTypeParamType: TMF_MNW2_PumpTypeParamClass;
begin
  result := TMNW2_PumpTypeParam;
end;

function TModflowTypesClass.GetMF_MNW2_ReactivationPumpingRateParamType: TMF_MNW2_ReactivationPumpingRateParamClass;
begin
  result := TMNW2_ReactivationPumpingRateParam;
end;

function TModflowTypesClass.GetMF_MNW2_SkinKParamType: TMF_MNW2_SkinKParamClass;
begin
  result := TMNW2_SkinKParam;
end;

function TModflowTypesClass.GetMF_MNW2_SkinRadiusParamType: TMF_MNW2_SkinRadiusParamClass;
begin
  result := TMNW2_SkinRadiusParam;
end;

function TModflowTypesClass.GetMF_MNW2_SpecifyPumpParamType: TMF_MNW2_SpecifyPumpParamClass;
begin
  result := TMNW2_SpecifyPumpParam;
end;

function TModflowTypesClass.GetMF_MNW2_TopWellScreenParamType: TMF_MNW2_TopWellScreenParamClass;
begin
  result := TMNW2_TopWellScreenParam;
end;

function TModflowTypesClass.GetMF_MNW2_UpperElevParamType: TMF_MNW2_UpperElevParamClass;
begin
  result := TMNW2_UpperElevParam;
end;

function TModflowTypesClass.GetMF_MNW2_WellIdParamType: TMF_MNW2_WellIdParamClass;
begin
  result := TMNW2_WellIdParam;
end;

function TModflowTypesClass.GetMF_MNW2_WellRadiusParamType: TMF_MNW2_WellRadiusParamClass;
begin
  result := TMNW2_WellRadiusParam;
end;

function TModflowTypesClass.GetMF_SWT_GroupLayerType: TMFSWT_GroupLayerClass;
begin
  result := T_SWT_Group;
end;

function TModflowTypesClass.GetMFGeostaticStressLayerType: TMFGeostaticStressLayerClass;
begin
  result := TGeostaticStressLayer;
end;

function TModflowTypesClass.GetMFSpecificGravityLayerType: TMFSpecificGravityLayerClass;
begin
  result := TSpecificGravityLayer;
end;

function TModflowTypesClass.GetMFSwtUnitLayerType: TMFSwtUnitLayerClass;
begin
  result := TSwtUnitLayer;
end;

function TModflowTypesClass.GetMFConcObsParamType: TMFConcObsParamClass;
begin
  result := TConcObsParam;
end;

function TModflowTypesClass.GetMFSpeciesParamType: TMFSpeciesParamClass;
begin
  result := TSpeciesParam;
end;

function TModflowTypesClass.GetMFConcentrationObservationParamListType: TMFConcentrationObservationParamListClass;
begin
  result := TConcentrationObservationParamList;
end;

function TModflowTypesClass.GetMT3DWeightedConcentrationObservationsLayerType: TMFWeightedConcentrationObservationsLayerClass;
begin
  result := TWeightedConcentrationObservationsLayer;
end;

function TModflowTypesClass.GetWeightedConcentrationListType: TWeightedConcentrationClass;
begin
  result := TWeightedConcentrationList;
end;

function TModflowTypesClass.GetMFConcWeightParamType: TMFConcWeightParamClass;
begin
  result := TConcWeightParam;
end;

function TModflowTypesClass.GetMFConcWeightParamListType: TMFConcWeightParamListClass;
begin
  result := TConcWeightParamList;
end;

function TModflowTypesClass.GetMFObservationWeightParamType: TMFObservationWeightParamClass;
begin
  result := TObservationWeightParam;
end;

function TModflowTypesClass.GetMFViscosityParamType: TMFViscosityParamClass;
begin
  result := TViscosityParam;
end;

function TModflowTypesClass.GetMFViscosityParamListType: TMFViscosityParamListClass;
begin
  result := TViscosityParamList;
end;

function TModflowTypesClass.GetMFViscosityLayerType: TMFViscosityLayerClass;
begin
  result := TViscosityLayer;
end;

function TModflowTypesClass.GetMFSeawatDensityOptionParamType: TMFSeawatDensityOptionParamClass;
begin
  result := TSeawatDensityOption;
end;

function TModflowTypesClass.GetMFChdFluidDensityParamType: TMFChdFluidDensityParamClass;
begin
  result := TChdFluidDensity;
end;

end.
