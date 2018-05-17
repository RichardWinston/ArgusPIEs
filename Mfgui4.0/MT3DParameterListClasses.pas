unit MT3DParameterListClasses;

interface

uses
     MFPrescribedHead,  MT3DTimeVaryConc, MT3DMassFlux;

  // MT3D Parameter Lists
type
  TMT3DPrescribedHeadTimeParamListClass = class of TMT3DPrescribedHeadTimeParamList;
//  TMT3DPointTimeVaryConcTimeParamListClass = class of TMT3DPointTimeVaryConcTimeParamList;
  TMT3DTimeVaryConcTimeParamListClass = class of TMT3DTimeVaryConcTimeParamList;
  TMT3DMassFluxTimeParamListClass = class of TMT3DMassFluxTimeParamList;

implementation

end.
