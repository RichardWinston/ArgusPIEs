unit MT3DParameterListClasses;

interface

uses
     MT3DPrescribedHead,  MT3DTimeVaryConc, 
     MFRBWLake, RunMT3DUnit, MFSeepage;

  // MT3D Parameter Lists
type
  TMT3DPrescribedHeadTimeParamListClass = class of TMT3DPrescribedHeadTimeParamList;
  TMT3DPointTimeVaryConcTimeParamListClass = class of TMT3DPointTimeVaryConcTimeParamList;
  TMT3DAreaTimeVaryConcTimeParamListClass = class of TMT3DAreaTimeVaryConcTimeParamList;
  TMFLakeStreamParamListClass = class of TLakeStreamParamList;
  TMFLakeTimeParamListClass = class of TLakeTimeParamList;
  TMFSeepageTimeParamListClass = class of TSeepageTimeParamList;

implementation

end.
