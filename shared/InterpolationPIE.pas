unit InterpolationPIE;

//==============================================================================
//
//	File: InterpolationPIE.pas
//
//
//	Argus Numerical Environments - Plug In Extension, Release 1.0
//
//	Copyright © 1996 Argus Holdings Ltd.  All rights reserved.
//
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF Argus Holdings Ltd..
// The copyright notice above does not evidence any
// actual or intended publication of such source code
//==============================================================================*/

interface

uses AnePIE;

const INTERPOLATION_PIE_VERSION = 1;

type
    PIEInterpolationPreProc = procedure (aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

    PIEInterpolationEvalProc = procedure (aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

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
  preProc	:	    PIEInterpolationPreProc     ;
  evalProc:		    PIEInterpolationEvalProc    ;
  cleanProc	:	    PIEInterpolationClean       ;
  neededProject	:	    ANE_STR			;
end;


implementation

end.
