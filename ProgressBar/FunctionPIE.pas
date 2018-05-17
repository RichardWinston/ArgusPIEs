unit FunctionPIE;

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

type
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
