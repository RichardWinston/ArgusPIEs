unit MT3DLayerClasses;

interface

uses
     MT3DDomainOutline, MT3DInactiveLayer, MT3DObservations,
     MT3DTimeVaryConc, MT3DInitConc, MT3DPostProc, MT3DBulkDensity,
     MT3DSorption, MT3DReaction, MT3DMassFlux, Mt3dMolecularDiffusion;

type


  // MT3D Layers
  TMT3DDomOutlineLayerClass = class of TMT3DDomOutlineLayer;
  TMT3DInactiveAreaLayerClass = class of TMT3DInactiveAreaLayer;
  TMT3DObservationsLayerClass = class of TMT3DObservationsLayer;
//  TMT3DPointConstantConcLayerClass = class of TMT3DPointConstantConcLayer;
//  TMT3DAreaConstantConcLayerClass = class of TMT3DAreaConstantConcLayer;
//  TMT3DPointTimeVaryConcLayerClass = class of TMT3DPointTimeVaryConcLayer;
  TMT3DAreaTimeVaryConcLayerClass = class of TMT3DAreaTimeVaryConcLayer;
  TMT3DPointInitConcLayerClass = class of TMT3DPointInitConcLayer;
  TMT3DAreaInitConcLayerClass = class of TMT3DAreaInitConcLayer;
  TMT3DDataLayerClass = class of TMT3DDataLayer;
  TMT3DPostProcessChartLayerClass = class of TMT3DPostProcessChartLayer;
  TMT3DBulkDensityLayerClass = class of TMT3DBulkDensityLayer;
  TMT3DSorptionLayerClass = class of TMT3DSorptionLayer;
  TMT3DReactionLayerClass = class of TMT3DReactionLayer;
  TMT3DMassFluxLayerClass = class of TMT3DMassFluxLayer;
  TMT3DMolecularDiffusionLayerClass = class of TMT3DMolecularDiffusionLayer;

implementation

end.
