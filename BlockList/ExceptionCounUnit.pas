unit ExceptionCounUnit;

interface

uses AnePIE, BlockListUnit;

function GGetErrorCount : ANE_INT32 ;

procedure GGetErrorCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
implementation

function GGetErrorCount : ANE_INT32 ;
begin
  result := ErrorCount ;
end;

procedure GGetErrorCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32 ;
begin
  result := GGetErrorCount ;
  ANE_INT32_PTR(reply)^ := result;
end;


end.
