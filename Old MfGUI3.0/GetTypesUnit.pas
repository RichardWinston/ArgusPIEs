unit GetTypesUnit;

interface

{GetTypesUnit defines the class TModflowTypesClass which is used in the
 creation of layers, parameters, and other classes during execution of the
 PIE. Because all of the methods are virtual, they can be overridden in a
 descendent class to provide additional functionality. Customized versions
 of the PIE should use this mechanism when changing layer or parameter
 characteristics.}

uses ModflowUnit, MFLayerStructureUnit, ModflowLayerClassTypes,
     ModflowParameterClassTypes,
     ModflowParameterListClassTypes,
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
     MFMOCSorbGrowth;

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

  end;


implementation

function TModflowTypesClass.GetModflowFormType : TModflowFormClass;
begin
  result := TfrmMODFLOW;
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

end.
