unit RotatedCellsFunctionUnit;

interface

uses AnePIE, FunctionPie;

var
        gPIERotatedXFDesc :  FunctionPIEDesc;
        gPIERotatedXDesc : ANEPIEDesc;

        gPIERotatedYFDesc :  FunctionPIEDesc;
        gPIERotatedYDesc : ANEPIEDesc;

const   gpnXYAngle : array [0..3] of PChar = ('X', 'Y', 'GridAngle', nil);
const   g3FloatTypes : array [0..3] of EPIENumberType = (kPIEFloat, kPIEFloat, kPIEFloat, 0);

procedure GPIERotatedXFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIERotatedYFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                                
implementation

uses UtilityFunctions, ParamArrayUnit;

procedure GPIERotatedXFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param : PParameter_array;
//  StringtoEvaluate :ANE_STR;
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  X : ANE_DOUBLE;
  param2_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Y : ANE_DOUBLE;
  param3_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Angle : ANE_DOUBLE;
//  result : ANE_DOUBLE;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  X :=  param1_ptr^;
  param2_ptr :=  param^[1];
  Y :=  param2_ptr^;
  param3_ptr :=  param^[2];
  Angle :=  param3_ptr^;

  RotatePointsFromGrid(X, Y, Angle);

  ANE_DOUBLE_PTR(reply)^ := X;
end;

procedure GPIERotatedYFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param : PParameter_array;
//  StringtoEvaluate :ANE_STR;
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  X : ANE_DOUBLE;
  param2_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Y : ANE_DOUBLE;
  param3_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Angle : ANE_DOUBLE;
//  result : ANE_DOUBLE;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  X :=  param1_ptr^;
  param2_ptr :=  param^[1];
  Y :=  param2_ptr^;
  param3_ptr :=  param^[2];
  Angle :=  param3_ptr^;

  RotatePointsFromGrid(X, Y, Angle);

  ANE_DOUBLE_PTR(reply)^ := Y;
end;


end.
