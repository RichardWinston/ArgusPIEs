unit functionUnit;

interface

uses 

  AnePIE, FunctionPie;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  
procedure GPIEAbsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

const
  kMaxFunDesc = 20;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEAbsDesc : ANEPIEDesc;
        gPIEAbsFDesc :  FunctionPIEDesc;

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gOneFloatTypes : array [0..1] of EPIENumberType = (kPIEFloat, 0);

function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  Index : integer;
   buf : PChar ;
   bufLen : Integer;
   AString : string;
   AHandle : HWND;
begin
      FullPath := '';
      AHandle := GetModuleHandle(PChar(FileName))  ;
      if AHandle = 0
      then
        begin
          Result := False;
        end
      else
        begin
          AString := '1';
          For Index := 1 to 10 do
          begin
            AString := AString + AString;
          end;
          buf := PChar(AString);
          bufLen := Length(AString);
          if (GetModuleFileName(AHandle, buf, bufLen) > 0)
          then
            begin
              FullPath := String(buf);
              Result := True;
            end
          else
            begin
              Result := False;
            end;
        end;

end;

function GetDllDirectory(FileName :string ;
  var DllDirectory : String) : boolean ;
begin
  result :=  GetDllFullPath(FileName ,  DllDirectory );
  DllDirectory := ExtractFileDir(DllDirectory);
end;

function GetDLLName : string;
var
    FileCheck: array[0..255] of char;
begin
          GetModuleFileName(HInstance, Filecheck, 255);
          result := String(Filecheck)
end;



procedure GPIEAbsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := Abs(param1);  // you could just have result := Abs(param1_ptr^)
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gPIEAbsFDesc.name := 'Delphi_PIE_Abs';	        // name of function
	gPIEAbsFDesc.address := GPIEAbsMMFun;		// function address
	gPIEAbsFDesc.returnType := kPIEFloat;		// return value type
	gPIEAbsFDesc.numParams :=  1;			// number of parameters
	gPIEAbsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAbsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEAbsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEAbsDesc.name  := 'Delphi_PIE_Abs';		// name of PIE
	gPIEAbsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAbsDesc.descriptor := @gPIEAbsFDesc;	// pointer to descriptor
	
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAbsDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gFunDesc;

end;

end.
