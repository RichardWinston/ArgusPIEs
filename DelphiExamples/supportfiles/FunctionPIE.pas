unit FunctionPIE;

//==============================================================================
//
//	File: FunctionPIE.pas
//
//
//	Argus Numerical Environments - Plug In Extension, Release 1.0
//
//	Copyright © 1996 Argus Holdings Ltd.  All rights reserved.
//
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF Argus Holdings Ltd..
// The copyright notice above does not evidence any
// actual or intended publication of such source code
//===============================================================================
// Version information:
//	1 - Original version
//	2 - Sept 96 - allow hidden functions
//===============================================================================*/

interface

uses AnePIE;

const FUNCTION_PIE_VERSION = 2;

type
  PIEFunctionCall = procedure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

const	 kFunctionNeedsProject		  	= $1  ;
const	 kFunctionHasCategory		  	= $2  ;
const	 kFunctionDisplaysDialogWhenDeclared	= $4  ;
const	 kFunctionIsHidden		  	= $8  ;		{ only since version 2 }

type EFunctionPIEFlags = integer;

FunctionPIEDesc = record
     version          :		ANE_INT32		       ;
     functionFlags    :		EFunctionPIEFlags	       ;
     name             :		ANE_STR			       ;
     address          :		PIEFunctionCall		       ;
     returnType       :		EPIENumberType	               ;
     numParams        :		ANE_INT16		       ;
     numOptParams     :		ANE_INT16		       ;
     paramNames       :		ANE_STR_PTR		       ;
     paramTypes       :		EPIENumberType_PTR             ;
     functionHandle   :		ANE_PTR			       ;
     category         :		ANE_STR			       ;
     neededProject    :		ANE_STR			       ;
end;

implementation

end.
