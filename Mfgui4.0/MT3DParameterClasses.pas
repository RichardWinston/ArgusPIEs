unit MT3DParameterClasses;

interface

uses
    MFGrid, MT3DDomainOutline, MT3DGeneralParameters,
    MT3DInactiveLayer, MT3DInitConc, MFHydraulicCond, MFMOCImInitConc,
    MT3DObservations, MT3DTimeVaryConc, MT3DBulkDensity, MT3DSorption,
    MT3DReaction, MT3DMassFlux, Mt3dMolecularDiffusion;

type
//  TMT3DAreaConstantConcParamClass = class of TMT3DAreaConstantConcParam;
  TMT3DDomOutlineParamClass = class of TMT3DDomOutlineParam;
  TMT3DMassParamClass = class of TMT3DMassParam;
  TMT3DConcentrationParamClass = class of TMT3DConcentrationParam;
  TGridMT3DICBUNDParamClass           = class of TGridMT3DICBUND;
  TGridMT3DActiveCellParamClass       = class of TGridMT3DActiveCell;
  TGridMT3DInitConcCellParamClass     = class of TGridMT3DInitConcCell;
  TGridMT3DTimeVaryConcCellParamClass = class of TGridMT3DTimeVaryConcCell;
  TGridMT3DObsLocCellParamClass       = class of TGridMT3DObsLocCell;
  TGridMT3DLongDispCellParamClass     = class of TGridMT3DLongDispCell;

  TMT3DLongDispParamClass = class of TMT3DLongDisp;
  TMT3DInactiveAreaParamClass = class of TMT3DInactiveAreaParam;
  TMT3DInitConcParamClass = class of TMT3DInitConcParam;
  TMT3DObservationsParamClass = class of TMT3DObservationsParam;
  TMT3DTopElevParamClass = class of TMT3DTopElevParam;
  TMT3DBottomElevParamClass = class of TMT3DBottomElevParam;

  TMT3DConc2ParamClass = class of TMT3DConc2Param;
  TMT3DConc3ParamClass = class of TMT3DConc3Param;
  TMT3DConc4ParamClass = class of TMT3DConc4Param;
  TMT3DConc5ParamClass = class of TMT3DConc5Param;

  TGridMT3DInitConc2ParamClass = class of TGridMT3DInitConc2Cell;
  TGridMT3DInitConc3ParamClass = class of TGridMT3DInitConc3Cell;
  TGridMT3DInitConc4ParamClass = class of TGridMT3DInitConc4Cell;
  TGridMT3DInitConc5ParamClass = class of TGridMT3DInitConc5Cell;

  TMT3DMass2ParamClass = class of TMT3DMass2Param;
  TMT3DMass3ParamClass = class of TMT3DMass3Param;
  TMT3DMass4ParamClass = class of TMT3DMass4Param;
  TMT3DMass5ParamClass = class of TMT3DMass5Param;

  TMT3DInitConc2ParamClass = class of TMT3DInitConc2Param;
  TMT3DInitConc3ParamClass = class of TMT3DInitConc3Param;
  TMT3DInitConc4ParamClass = class of TMT3DInitConc4Param;
  TMT3DInitConc5ParamClass = class of TMT3DInitConc5Param;

{  TMT3DAreaConstantConc2ParamClass = class of TMT3DAreaConstantConc2Param;
  TMT3DAreaConstantConc3ParamClass = class of TMT3DAreaConstantConc3Param;
  TMT3DAreaConstantConc4ParamClass = class of TMT3DAreaConstantConc4Param;
  TMT3DAreaConstantConc5ParamClass = class of TMT3DAreaConstantConc5Param;  }

  TMT3DBulkDensityParamClass = class of TMT3DBulkDensityParam;

  TMT3DImInitConc2ParamClass = class of TMT3DImInitConc2Param;
  TMT3DImInitConc3ParamClass = class of TMT3DImInitConc3Param;
  TMT3DImInitConc4ParamClass = class of TMT3DImInitConc4Param;
  TMT3DImInitConc5ParamClass = class of TMT3DImInitConc5Param;

  TMT3DSP1AParamClass = class of TSP1AParam;
  TMT3DSP1BParamClass = class of TSP1BParam;
  TMT3DSP1CParamClass = class of TSP1CParam;
  TMT3DSP1DParamClass = class of TSP1DParam;
  TMT3DSP1EParamClass = class of TSP1EParam;

  TMT3DSP2AParamClass = class of TSP2AParam;
  TMT3DSP2BParamClass = class of TSP2BParam;
  TMT3DSP2CParamClass = class of TSP2CParam;
  TMT3DSP2DParamClass = class of TSP2DParam;
  TMT3DSP2EParamClass = class of TSP2EParam;

  TMT3DRC1AParamClass = class of TRC1AParam;
  TMT3DRC1BParamClass = class of TRC1BParam;
  TMT3DRC1CParamClass = class of TRC1CParam;
  TMT3DRC1DParamClass = class of TRC1DParam;
  TMT3DRC1EParamClass = class of TRC1EParam;

  TMT3DRC2AParamClass = class of TRC2AParam;
  TMT3DRC2BParamClass = class of TRC2BParam;
  TMT3DRC2CParamClass = class of TRC2CParam;
  TMT3DRC2DParamClass = class of TRC2DParam;
  TMT3DRC2EParamClass = class of TRC2EParam;

  TMT3DMassFluxAParamClass = class of TMassFluxAParam;
  TMT3DMassFluxBParamClass = class of TMassFluxBParam;
  TMT3DMassFluxCParamClass = class of TMassFluxCParam;
  TMT3DMassFluxDParamClass = class of TMassFluxDParam;
  TMT3DMassFluxEParamClass = class of TMassFluxEParam;

  TGridMT3DMassFluxParamClass = class of TGridMT3DMassFluxCell;

  TMT3DMolDiffAParamClass = class of TMolDiffAParam;
  TMT3DMolDiffBParamClass = class of TMolDiffBParam;
  TMT3DMolDiffCParamClass = class of TMolDiffCParam;
  TMT3DMolDiffDParamClass = class of TMolDiffDParam;
  TMT3DMolDiffEParamClass = class of TMolDiffEParam;

implementation

end.
