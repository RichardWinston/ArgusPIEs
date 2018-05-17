unit InterpolationPIE;

interface

uses AnePIE;

const INTERPOLATION_PIE_VERSION = 1;

type
    PIEInterpolationPreProc = procedure (aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

    PIEInterpolationEvalProc = procedure (aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;

    PIEInterpolationClean = procedure (aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

const       kInterpolationIncremental = $1;
const	    kInterpolationCallPre = $2;
const	    kInterpolationShouldClean = $4;

type   EInterpolationFlags = integer;

InterpolationPIEDesc = record
version :		    ANE_INT32                   ;
name	:	            ANE_STR                     ;
interpolationFlags	:   EInterpolationFlags         ;
preProc	:	            PIEInterpolationPreProc     ;
evalProc:		    PIEInterpolationEvalProc    ;
cleanProc	:	    PIEInterpolationClean       ;
neededProject	:	    ANE_STR			;

end;


implementation

end.
