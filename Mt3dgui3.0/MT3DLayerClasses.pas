unit MT3DLayerClasses;

interface

uses
     MT3DLayerStructureUnit, MT3DDomainOutline, MT3DInactiveLayer,
     MT3DPorosityUnit, MT3DObservations, MT3DConstantConcentration,
     MT3DTimeVaryConc, MT3DInitConc, MFRBWLake, MFSeepage, MT3DPostProc;

type

  // MT3D Layer lists
  TMT3DGeologicUnitClass = class of TMT3DGeologicUnit;

  // MT3D Layers
  TMT3DDomOutlineLayerClass = class of TMT3DDomOutlineLayer;
  TMT3DInactiveAreaLayerClass = class of TMT3DInactiveAreaLayer;
  TMT3DPorosityLayerClass = class of TMT3DPorosityLayer;
  TMT3DObservationsLayerClass = class of TMT3DObservationsLayer;
  TMT3DPointConstantConcLayerClass = class of TMT3DPointConstantConcLayer;
  TMT3DAreaConstantConcLayerClass = class of TMT3DAreaConstantConcLayer;
  TMT3DPointTimeVaryConcLayerClass = class of TMT3DPointTimeVaryConcLayer;
  TMT3DAreaTimeVaryConcLayerClass = class of TMT3DAreaTimeVaryConcLayer;
  TMT3DPointInitConcLayerClass = class of TMT3DPointInitConcLayer;
  TMT3DAreaInitConcLayerClass = class of TMT3DAreaInitConcLayer;
  TMFLakeLayerClass = class of TLakeLayer;
  TMFLineSeepageLayerClass = class of TLineSeepageLayer;
  TMFAreaSeepageLayerClass = class of TAreaSeepageLayer;
  TMT3DDataLayerClass = class of TMT3DDataLayer;
  TMT3DPostProcessChartLayerClass = class of TMT3DPostProcessChartLayer;

implementation

end.
