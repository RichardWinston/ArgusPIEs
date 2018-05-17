unit GetMT3DTypes;

interface

uses
     MT3DFormUnit,
     MT3DPrescribedHead, MT3DRecharge, MT3DEvaporation,
     MT3DHydraulicCond, MT3DWells, MT3DDrain, MT3DRiver, MT3DGenHeadBoundary,
     MT3DInactiveLayer, MT3DPorosityUnit, MT3DObservations,
     MT3DConstantConcentration, MT3DTimeVaryConc, MT3DInitConc,
     MT3DDomainOutline, MT3DLayerStructureUnit, MT3DGrid, MFGroupLayerUnit,
     MFRBWLake, {MFRBWStreamUnit,} RunMT3DUnit,

     GetTypesUnit, ModflowLayerClassTypes, ModflowParameterClassTypes,
     ModflowParameterListClassTypes, MT3DLayerClasses, MT3DParameterListClasses,
     MT3DParameterClasses, MT3DGeneralParameters, MT3DStream, MFSeepage,
     MT3DPostProc, WellMt3dData;


type
  TMT3DFormClass = class of TfrmMT3D;
  TRunMT3DClass = class of TfrmRunMT3D;
  TfrmMT3DWellDataClass = class of TfrmMT3DWellData;
  TMT3DLayerStructureClass = class of TMT3DLayerStructure;



  TMT3DTypesClass = Class(TModflowTypesClass)
    // forms
    function GetModflowFormType : TMT3DFormClass;   //override;
    function GetRunModflowType : TRunMT3DClass;
    function GetWellDataFormType : TfrmMT3DWellDataClass;// override;
    function GetModflowLayerStructureType : TMT3DLayerStructureClass;// override;

    // MT3D Layer lists
    function GetMT3DGeologicUnitType : TMT3DGeologicUnitClass; virtual;

    // MT3D Layers
    function GetMT3DDomOutlineLayerType : TMT3DDomOutlineLayerClass; virtual;
    function GetMT3DInactiveAreaLayerType : TMT3DInactiveAreaLayerClass; virtual;
    function GetMT3DPorosityLayerType : TMT3DPorosityLayerClass; virtual;
    function GetMT3DObservationsLayerType : TMT3DObservationsLayerClass; virtual;
    function GetMT3DPointConstantConcLayerType : TMT3DPointConstantConcLayerClass; virtual;
    function GetMT3DAreaConstantConcLayerType : TMT3DAreaConstantConcLayerClass; virtual;
    function GetMT3DPointTimeVaryConcLayerType : TMT3DPointTimeVaryConcLayerClass; virtual;
    function GetMT3DAreaTimeVaryConcLayerType : TMT3DAreaTimeVaryConcLayerClass; virtual;
    function GetMT3DPointInitConcLayerType : TMT3DPointInitConcLayerClass; virtual;
    function GetMT3DAreaInitConcLayerType : TMT3DAreaInitConcLayerClass; virtual;
    function GetMFLineSeepageLayerType : TMFLineSeepageLayerClass ; virtual;
    function GetMFAreaSeepageLayerType : TMFAreaSeepageLayerClass ; virtual;
    function GetMFLakeLayerType : TMFLakeLayerClass ; virtual;
    function GetMT3DDataLayerType : TMT3DDataLayerClass ; virtual;
    function GetMT3DPostProcessChartLayerType : TMT3DPostProcessChartLayerClass ; virtual;

    // MT3D parameter lists
    function GetMT3DPrescribedHeadTimeParamListType : TMT3DPrescribedHeadTimeParamListClass; virtual;
    function GetMT3DPointTimeVaryConcTimeParamListType : TMT3DPointTimeVaryConcTimeParamListClass; virtual;
    function GetMT3DAreaTimeVaryConcTimeParamListType : TMT3DAreaTimeVaryConcTimeParamListClass; virtual;
    function GetMFLakeStreamParamListType : TMFLakeStreamParamListClass ;  virtual;
    function GetMFLakeTimeParamListType : TMFLakeTimeParamListClass; virtual;
    function GetMFSeepageTimeParamListType : TMFSeepageTimeParamListClass; virtual;

    // MT3D Parameters
    function GetMT3DAreaConstantConcParamClassType : TMT3DAreaConstantConcParamClass; virtual;
    function GetMT3DDomOutlineParamClassType : TMT3DDomOutlineParamClass; virtual;
    function GetMT3DMassParamClassType : TMT3DMassParamClass; virtual;
    function GetMT3DConcentrationParamClassType : TMT3DConcentrationParamClass; virtual;
    function GetGridMT3DPorosityParamClassType : TGridMT3DPorosityParamClass; virtual;

    function GetGridMT3DICBUNDParamClassType : TGridMT3DICBUNDParamClass           ; virtual;
    function GetGridMFActiveCellParamClassType : TGridMFActiveCellParamClass         ; virtual;
    function GetGridMT3DActiveCellParamClassType : TGridMT3DActiveCellParamClass       ; virtual;
    function GetGridMT3DInitConcCellParamClassType : TGridMT3DInitConcCellParamClass     ; virtual;
    function GetGridMT3DTimeVaryConcCellParamClassType : TGridMT3DTimeVaryConcCellParamClass ; virtual;
    function GetGridMT3DObsLocCellParamClassType : TGridMT3DObsLocCellParamClass       ; virtual;
    function GetGridMT3DLongDispCellParamClassType : TGridMT3DLongDispCellParamClass     ; virtual;
    function GetGridMT3DLakeParamClassType : TGridMT3DLakeParamClass             ; virtual;
    function GetGridMT3DLakeToRightParamClassType : TGridMT3DLakeToRightParamClass      ; virtual;
    function GetGridMT3DLakeToLeftParamClassType : TGridMT3DLakeToLeftParamClass       ; virtual;
    function GetGridMT3DLakeToNorthParamClassType : TGridMT3DLakeToNorthParamClass      ; virtual;
    function GetGridMT3DLakeToSouthParamClassType : TGridMT3DLakeToSouthParamClass      ; virtual;
    function GetGridMT3DLakeAboveParamClassType : TGridMT3DLakeAboveParamClass        ; virtual;
    function GetGridMT3DLakebedBottomParamClassType : TGridMT3DLakebedBottomParamClass    ; virtual;
    function GetGridMT3DLakebedTopParamClassType : TGridMT3DLakebedTopParamClass       ; virtual;
    function GetGridMT3DLakebedKzParamClassType : TGridMT3DLakebedKzParamClass        ; virtual;

    function GetMT3DLongDispParamClassType : TMT3DLongDispParamClass        ; virtual;
    function GetMT3DInactiveAreaParamClassType : TMT3DInactiveAreaParamClass        ; virtual;
    function GetMT3DInitConcParamClassType : TMT3DInitConcParamClass        ; virtual;
    function GetMT3DObservationsParamClassType : TMT3DObservationsParamClass        ; virtual;
    function GetMT3DPorosityParamClassType : TMT3DPorosityParamClass        ; virtual;
    function GetMT3DTopElevParamClassType : TMT3DTopElevParamClass        ; virtual;
    function GetMT3DBottomElevParamClassType : TMT3DBottomElevParamClass        ; virtual;

    function GetMFLineSeepageElevationParamClassType : TMFLineSeepageElevationParamClass        ; virtual;
    function GetMFAreaSeepageElevationParamClassType : TMFAreaSeepageElevationParamClass        ; virtual;
    function GetMFSeepageOnParamClassType : TMFSeepageOnParamClass        ; virtual;
    function GetGridSeepageParamClassType : TGridSeepageParamClass        ; virtual;

    // MODFLOW Layer Lists
    function GetGeologicUnitType : TMFGeologicUnitClass; override;

    // MODFLOW Layers
    function GetHydraulicCondLayerType : TMFHydraulicCondLayerClass; override;
    function GetPrescribedHeadLayerType : TMFPrescribedHeadLayerClass; override;

    function GetMFDrainTimeParamListType : TMFDrainTimeParamListClass; override;
    function GetETTimeParamListType : TMFETTimeParamListClass; override;
    function GetMFRechElevParamListType : TMFRechargeTimeParamListClass; override;
    function GetGHBTimeParamListType : TMFGHBTimeParamListClass; override;
    function GetMFRiverTimeParamListType : TMFRiverTimeParamListClass; override;
    function GetMFWellTimeParamListType : TMFWellTimeParamListClass; override;
    function GetMFStreamTimeParamListType : TMFStreamTimeParamListClass; override;
    function GetMFGeologicUnitParametersType : TMFGeologicUnitParametersClass; override;

    // MODFLOW Parameters
    function GetMFIBoundGridParamType: TMFIBoundGridParamClass; override;
  end;

implementation

function TMT3DTypesClass.GetRunModflowType : TRunMT3DClass;   // modified for MT3D
begin
  result := TfrmRunMT3D;  // modified for MT3D
end;

function TMT3DTypesClass.GetModflowFormType : TMT3DFormClass;
begin
  result := TfrmMT3D;  // modified for MT3D
end;

function TMT3DTypesClass.GetModflowLayerStructureType : TMT3DLayerStructureClass;
begin
  result := TMT3DLayerStructure;
end;

function TMT3DTypesClass.GetGeologicUnitType : TMFGeologicUnitClass;
begin
  result := TMT3DGeologicUnit;
end;

function TMT3DTypesClass.GetMT3DGeologicUnitType : TMT3DGeologicUnitClass;
begin
  result := TMT3DGeologicUnit;
end;

//MODFLOW Layer functions

{function TMT3DTypesClass.GetMFGeolUnitGroupLayerType : TMFGeolUnitGroupLayerClass ;
begin
  result := TMFGeolUnitGroupLayer;
end; }

function TMT3DTypesClass.GetHydraulicCondLayerType : TMFHydraulicCondLayerClass;
begin
  result := TMT3DHydraulicCondLayer;
end;

function TMT3DTypesClass.GetPrescribedHeadLayerType : TMFPrescribedHeadLayerClass;
begin
  result := TMT3DPrescribedHeadLayer; // Modified for MT3D
end;

// MODFLOW parameter list functions

function TMT3DTypesClass.GetMFDrainTimeParamListType : TMFDrainTimeParamListClass;
begin
  result := TMT3DDrainTimeParamList;
end;

function TMT3DTypesClass.GetETTimeParamListType : TMFETTimeParamListClass;
begin
  result := TMT3DEvaporationTimeParamList; // Modified for MT3D
end;

function TMT3DTypesClass.GetGHBTimeParamListType : TMFGHBTimeParamListClass;
begin
  result := TMT3DGHBTimeParamList;
end;

function TMT3DTypesClass.GetMFRechElevParamListType : TMFRechargeTimeParamListClass;
begin
  result := TMT3DRechargeTimeParamList; // Modified for MT3D;
end;

function TMT3DTypesClass.GetMFRiverTimeParamListType : TMFRiverTimeParamListClass;
begin
  result := TMT3DRiverTimeParamList;  // Modified for MT3D;
end;

function TMT3DTypesClass.GetMFWellTimeParamListType : TMFWellTimeParamListClass;
begin
  result := TMT3DWellTimeParamList;  // Modified for MT3D;
end;

function TMT3DTypesClass.GetMFGeologicUnitParametersType : TMFGeologicUnitParametersClass;
begin
  result := TMT3DGeologicUnitParameters;  // Modified for MT3D;
end;

// MT3D Layer functions
function TMT3DTypesClass.GetMT3DDomOutlineLayerType : TMT3DDomOutlineLayerClass;
begin
  result := TMT3DDomOutlineLayer;
end;

function TMT3DTypesClass.GetMT3DInactiveAreaLayerType : TMT3DInactiveAreaLayerClass;
begin
  result := TMT3DInactiveAreaLayer;
end;

function TMT3DTypesClass.GetMT3DPorosityLayerType : TMT3DPorosityLayerClass;
begin
  result := TMT3DPorosityLayer;
end;

function TMT3DTypesClass.GetMT3DObservationsLayerType : TMT3DObservationsLayerClass;
begin
  result := TMT3DObservationsLayer;
end;

function TMT3DTypesClass.GetMT3DPointConstantConcLayerType : TMT3DPointConstantConcLayerClass;
begin
  result := TMT3DPointConstantConcLayer;
end;

function TMT3DTypesClass.GetMT3DAreaConstantConcLayerType : TMT3DAreaConstantConcLayerClass;
begin
  result := TMT3DAreaConstantConcLayer;
end;

function TMT3DTypesClass.GetMT3DPointTimeVaryConcLayerType : TMT3DPointTimeVaryConcLayerClass;
begin
  result := TMT3DPointTimeVaryConcLayer;
end;

function TMT3DTypesClass.GetMT3DAreaTimeVaryConcLayerType : TMT3DAreaTimeVaryConcLayerClass;
begin
  result := TMT3DAreaTimeVaryConcLayer;
end;

function TMT3DTypesClass.GetMT3DPointInitConcLayerType : TMT3DPointInitConcLayerClass;
begin
  result := TMT3DPointInitConcLayer;
end;

function TMT3DTypesClass.GetMT3DAreaInitConcLayerType : TMT3DAreaInitConcLayerClass;
begin
  result := TMT3DAreaInitConcLayer;
end;

function TMT3DTypesClass.GetMFLakeLayerType : TMFLakeLayerClass ;
begin
  result := TLakeLayer;
end;

// MT3D parameter list functions

function TMT3DTypesClass.GetMT3DPrescribedHeadTimeParamListType : TMT3DPrescribedHeadTimeParamListClass;
begin
  result := TMT3DPrescribedHeadTimeParamList;
end;

function TMT3DTypesClass.GetMT3DPointTimeVaryConcTimeParamListType : TMT3DPointTimeVaryConcTimeParamListClass;
begin
  result := TMT3DPointTimeVaryConcTimeParamList;
end;

function TMT3DTypesClass.GetMT3DAreaTimeVaryConcTimeParamListType : TMT3DAreaTimeVaryConcTimeParamListClass;
begin
  result := TMT3DAreaTimeVaryConcTimeParamList;
end;

function TMT3DTypesClass.GetMFLakeStreamParamListType : TMFLakeStreamParamListClass ;
begin
  result := TLakeStreamParamList;
end;

function TMT3DTypesClass.GetMFLakeTimeParamListType : TMFLakeTimeParamListClass;
begin
  result := TLakeTimeParamList;
end;

{function TMT3DTypesClass.GetMFRBWStreamTimeParamListType : TMFRBWStreamTimeParamListClass;
begin
  result := TRBWStreamTimeParamList;
end;}


{// MODFLOW
function TMT3DTypesClass.GetBottomElevLayerType : TBottomElevLayerClass;
begin
  result := TBottomElevLayer;
end;

function TMT3DTypesClass.GetMFDomainOutType : TMFDomainOutLayerClass;
begin
  result := TMFDomainOut;
end;

function TMT3DTypesClass.GetLineDrainLayerType : TMFLineDrainLayerClass;
begin
  result := TLineDrainLayer;
end;

function TMT3DTypesClass.GetAreaDrainLayerType : TMFAreaDrainLayerClass;
begin
  result := TAreaDrainLayer;
end;

function TMT3DTypesClass.GetETLayerType : TMFETLayerClass;
begin
  result := TETLayer;
end;

function TMT3DTypesClass.GetPointGHBLayerType : TMFPointGHBLayerClass;
begin
  result := TPointGHBLayer;
end;

function TMT3DTypesClass.GetLineGHBLayerType : TMFLineGHBLayerClass;
begin
  result := TLineGHBLayer;
end;

function TMT3DTypesClass.GetAreaGHBLayerType : TMFAreaGHBLayerClass;
begin
  result := TAreaGHBLayer;
end;

function TMT3DTypesClass.GetGridLayerType : TMFGridLayerClass;
begin
  result := TMFGridLayer;
end;

function TMT3DTypesClass.GetDensityLayerType : TMFDensityLayerClass;
begin
  result := TMFDensityLayer;
end;

function TMT3DTypesClass.GetInactiveLayerType : TMFInactiveLayerClass;
begin
  result := TInactiveLayer;
end;

function TMT3DTypesClass.GetInitialHeadLayerType : TMFInitialHeadLayerClass;
begin
  result := TInitialHeadLayer;
end;

function TMT3DTypesClass.GetMapLayerType : TMFMapLayerClass;
begin
  result := TMFMapLayer;
end;

function TMT3DTypesClass.GetMOCInitialConcLayerType : TMOCInitialConcLayerClass;
begin
  result := TMOCInitialConcLayer;
end;

function TMT3DTypesClass.GetMOCObsWellLayerType : TMOCObsWellLayerClass;
begin
  result := TMOCObsWellLayer;
end;

function TMT3DTypesClass.GetMOCParticleRegenLayerType : TMOCParticleRegenLayerClass;
begin
  result := TMOCParticleRegenLayer;
end;

function TMT3DTypesClass.GetMOCPorosityLayerType : TMOCPorosityLayerClass;
begin
  result := TMOCPorosityLayer;
end;

function TMT3DTypesClass.GetRechargeLayerType : TMFRechargeLayerClass;
begin
  result := TRechargeLayer;
end;

function TMT3DTypesClass.GetMOCRechargeConcLayerType : TMOCRechargeConcLayerClass;
begin
  result := TMOCRechargeConcLayer;
end;

function TMT3DTypesClass.GetMFLineRiverLayerType : TMFLineRiverLayerClass;
begin
  result := TLineRiverLayer;
end;

function TMT3DTypesClass.GetMFAreaRiverLayerType : TMFAreaRiverLayerClass;
begin
  result := TAreaRiverLayer;
end;

function TMT3DTypesClass.GetMFSpecStorageLayerType : TMFSpecStorageLayerClass;
begin
  result := TSpecStorageLayer;
end;

function TMT3DTypesClass.GetMFSpecYieldLayerType : TMFSpecYieldLayerClass;
begin
  result := TSpecYieldLayer;
end;

function TMT3DTypesClass.GetMFTopElevLayerType : TMFTopElevLayerClass;
begin
  result := TTopElevLayer;
end;

function TMT3DTypesClass.GetMFWellLayerType : TMFWellLayerClass;
begin
  result := TWellLayer;
end;

function TMT3DTypesClass.GetMFWettingLayerType : TMFWettingLayerClass;
begin
  result := TWettingLayer;
end;  }

{function TMT3DTypesClass.GetMFRBWStreamLayerType : TMFRBWStreamLayerClass ;
begin
  result := TRBWStreamLayer;
end;}






{function TMT3DTypesClass.GetMOCElevParamListType : TMOCElevParamListClass;
begin
  result := TMOCElevParamList;
end;

function TMT3DTypesClass.GetMOCRechargeConcTimeParamListType : TMOCRechargeConcTimeParamListClass;
begin
  result := TRechargeConcTimeParamList;
end;  }


function TMT3DTypesClass.GetMT3DAreaConstantConcParamClassType: TMT3DAreaConstantConcParamClass;
begin
  result := TMT3DAreaConstantConcParam;
end;

function TMT3DTypesClass.GetMT3DDomOutlineParamClassType: TMT3DDomOutlineParamClass;
begin
  result := TMT3DDomOutlineParam;
end;

function TMT3DTypesClass.GetMT3DMassParamClassType: TMT3DMassParamClass;
begin
  result := TMT3DMassParam;
end;

function TMT3DTypesClass.GetMT3DConcentrationParamClassType: TMT3DConcentrationParamClass;
begin
  result := TMT3DConcentrationParam;
end;

function TMT3DTypesClass.GetGridMT3DPorosityParamClassType: TGridMT3DPorosityParamClass;
begin
  result := TGridMT3DPorosity;
end;

function TMT3DTypesClass.GetGridMFActiveCellParamClassType: TGridMFActiveCellParamClass;
begin
  result := TGridMFActiveCell;
end;

function TMT3DTypesClass.GetGridMT3DActiveCellParamClassType: TGridMT3DActiveCellParamClass;
begin
  result := TGridMT3DActiveCell;
end;

function TMT3DTypesClass.GetGridMT3DICBUNDParamClassType: TGridMT3DICBUNDParamClass;
begin
  result := TGridMT3DICBUND;
end;

function TMT3DTypesClass.GetGridMT3DInitConcCellParamClassType: TGridMT3DInitConcCellParamClass;
begin
  result := TGridMT3DInitConcCell;
end;

function TMT3DTypesClass.GetGridMT3DLakeAboveParamClassType: TGridMT3DLakeAboveParamClass;
begin
  result := TGridLakeAboveParam;
end;

function TMT3DTypesClass.GetGridMT3DLakebedBottomParamClassType: TGridMT3DLakebedBottomParamClass;
begin
  result := TGridLakebedBottomParam;
end;

function TMT3DTypesClass.GetGridMT3DLakebedKzParamClassType: TGridMT3DLakebedKzParamClass;
begin
  result := TGridLakebedKzParam;
end;

function TMT3DTypesClass.GetGridMT3DLakebedTopParamClassType: TGridMT3DLakebedTopParamClass;
begin
  result := TGridLakebedTopParam;
end;

function TMT3DTypesClass.GetGridMT3DLakeParamClassType: TGridMT3DLakeParamClass;
begin
  result := TGridLakeParam;
end;

function TMT3DTypesClass.GetGridMT3DLakeToLeftParamClassType: TGridMT3DLakeToLeftParamClass;
begin
  result := TGridLakeToLeftParam;
end;

function TMT3DTypesClass.GetGridMT3DLakeToNorthParamClassType: TGridMT3DLakeToNorthParamClass;
begin
  result := TGridLakeToNorthParam;
end;

function TMT3DTypesClass.GetGridMT3DLakeToRightParamClassType: TGridMT3DLakeToRightParamClass;
begin
  result := TGridLakeToRightParam;
end;

function TMT3DTypesClass.GetGridMT3DLakeToSouthParamClassType: TGridMT3DLakeToSouthParamClass;
begin
  result := TGridLakeToSouthParam;
end;

function TMT3DTypesClass.GetGridMT3DLongDispCellParamClassType: TGridMT3DLongDispCellParamClass;
begin
  result := TGridMT3DLongDispCell;
end;

function TMT3DTypesClass.GetGridMT3DObsLocCellParamClassType: TGridMT3DObsLocCellParamClass;
begin
  result := TGridMT3DObsLocCell;
end;

function TMT3DTypesClass.GetGridMT3DTimeVaryConcCellParamClassType: TGridMT3DTimeVaryConcCellParamClass;
begin
  result := TGridMT3DTimeVaryConcCell;
end;

function TMT3DTypesClass.GetMT3DLongDispParamClassType: TMT3DLongDispParamClass;
begin
  result := TMT3DLongDisp;
end;

function TMT3DTypesClass.GetMT3DInactiveAreaParamClassType: TMT3DInactiveAreaParamClass;
begin
  result := TMT3DInactiveAreaParam;
end;

function TMT3DTypesClass.GetMT3DInitConcParamClassType: TMT3DInitConcParamClass;
begin
  result := TMT3DInitConcParam;
end;

function TMT3DTypesClass.GetMT3DObservationsParamClassType: TMT3DObservationsParamClass;
begin
  result := TMT3DObservationsParam;
end;

function TMT3DTypesClass.GetMT3DPorosityParamClassType: TMT3DPorosityParamClass;
begin
  result := TMT3DPorosityParam;
end;

function TMT3DTypesClass.GetMT3DTopElevParamClassType: TMT3DTopElevParamClass;
begin
  result := TMT3DTopElevParam;
end;

function TMT3DTypesClass.GetMT3DBottomElevParamClassType: TMT3DBottomElevParamClass;
begin
  result := TMT3DBottomElevParam;
end;

function TMT3DTypesClass.GetMFIBoundGridParamType: TMFIBoundGridParamClass;
begin
  result := TMT3DIBoundGridParam
end;

function TMT3DTypesClass.GetMFStreamTimeParamListType: TMFStreamTimeParamListClass;
begin
  result := TMT3DStreamTimeParamList;
end;

function TMT3DTypesClass.GetMFAreaSeepageLayerType: TMFAreaSeepageLayerClass;
begin
  result := TAreaSeepageLayer;
end;

function TMT3DTypesClass.GetMFLineSeepageLayerType: TMFLineSeepageLayerClass;
begin
  result := TLineSeepageLayer;
end;

function TMT3DTypesClass.GetMFLineSeepageElevationParamClassType: TMFLineSeepageElevationParamClass;
begin
  result := TLineSeepageElevationParam;
end;

function TMT3DTypesClass.GetMFAreaSeepageElevationParamClassType: TMFAreaSeepageElevationParamClass;
begin
  result := TAreaSeepageElevationParam;
end;

function TMT3DTypesClass.GetMFSeepageOnParamClassType: TMFSeepageOnParamClass;
begin
  result := TSeepageOnParam;
end;

function TMT3DTypesClass.GetMFSeepageTimeParamListType: TMFSeepageTimeParamListClass;
begin
  result := TSeepageTimeParamList;
end;

function TMT3DTypesClass.GetGridSeepageParamClassType: TGridSeepageParamClass;
begin
  result := TGridSeepage;
end;

function TMT3DTypesClass.GetMT3DDataLayerType: TMT3DDataLayerClass;
begin
  result := TMT3DDataLayer;
end;

function TMT3DTypesClass.GetMT3DPostProcessChartLayerType: TMT3DPostProcessChartLayerClass;
begin
  result := TMT3DPostProcessChartLayer;
end;

function TMT3DTypesClass.GetWellDataFormType: TfrmMT3DWellDataClass;
begin
  result := TfrmMT3DWellData;
end;

end.
