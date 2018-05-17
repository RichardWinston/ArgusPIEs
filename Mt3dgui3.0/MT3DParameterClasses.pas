unit MT3DParameterClasses;

interface

uses
    MT3DConstantConcentration, MT3DDomainOutline, MT3DGeneralParameters,
    MT3DGrid, MT3DHydraulicCond, MT3DInactiveLayer, MT3DInitConc,
    MT3DObservations, MT3DPorosityUnit, MT3DTimeVaryConc, MFSeepage;

type
  TMT3DAreaConstantConcParamClass = class of TMT3DAreaConstantConcParam;
  TMT3DDomOutlineParamClass = class of TMT3DDomOutlineParam;
  TMT3DMassParamClass = class of TMT3DMassParam;
  TMT3DConcentrationParamClass = class of TMT3DConcentrationParam;
  TGridMT3DPorosityParamClass = class of TGridMT3DPorosity;
  TGridMT3DICBUNDParamClass           = class of TGridMT3DICBUND;
  TGridMFActiveCellParamClass         = class of TGridMFActiveCell;
  TGridMT3DActiveCellParamClass       = class of TGridMT3DActiveCell;
  TGridMT3DInitConcCellParamClass     = class of TGridMT3DInitConcCell;
  TGridMT3DTimeVaryConcCellParamClass = class of TGridMT3DTimeVaryConcCell;
  TGridMT3DObsLocCellParamClass       = class of TGridMT3DObsLocCell;
  TGridMT3DLongDispCellParamClass     = class of TGridMT3DLongDispCell;
  TGridMT3DLakeParamClass             = class of TGridLakeParam;
  TGridMT3DLakeToRightParamClass      = class of TGridLakeToRightParam;
  TGridMT3DLakeToLeftParamClass       = class of TGridLakeToLeftParam;
  TGridMT3DLakeToNorthParamClass      = class of TGridLakeToNorthParam;
  TGridMT3DLakeToSouthParamClass      = class of TGridLakeToSouthParam;
  TGridMT3DLakeAboveParamClass        = class of TGridLakeAboveParam;
  TGridMT3DLakebedBottomParamClass    = class of TGridLakebedBottomParam;
  TGridMT3DLakebedTopParamClass       = class of TGridLakebedTopParam;
  TGridMT3DLakebedKzParamClass        = class of TGridLakebedKzParam;

  TMT3DLongDispParamClass = class of TMT3DLongDisp;
  TMT3DInactiveAreaParamClass = class of TMT3DInactiveAreaParam;
  TMT3DInitConcParamClass = class of TMT3DInitConcParam;
  TMT3DObservationsParamClass = class of TMT3DObservationsParam;
  TMT3DPorosityParamClass = class of TMT3DPorosityParam;
  TMT3DTopElevParamClass = class of TMT3DTopElevParam;
  TMT3DBottomElevParamClass = class of TMT3DBottomElevParam;

  TMFLineSeepageElevationParamClass = class of TLineSeepageElevationParam;
  TMFAreaSeepageElevationParamClass = class of TAreaSeepageElevationParam;
  TMFSeepageOnParamClass = class of TSeepageOnParam;
  TGridSeepageParamClass = class of TGridSeepage;

implementation

end.
