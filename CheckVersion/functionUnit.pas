unit functionUnit;

interface

uses 

  AnePIE, FunctionPie, Dialogs, SysUtils;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  
procedure GPIECheckVersionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses ANECB;

const
  kMaxFunDesc = 20;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIECheckVersionDesc : ANEPIEDesc;
        gPIECheckVersionFDesc :  FunctionPIEDesc;

const   gpnVersionNames : array [0..4] of PChar
  = ('Major','Minor','Update', 'Version',  nil);
const   gVersionTypes : array [0..4] of EPIENumberType
  = (kPIEInteger,kPIEInteger, kPIEInteger,kPIEString, 0);

function CheckArgusVersion(const aneHandle : ANE_PTR;
  const MajorToCheck, MinorToCheck, UpdateToCheck : ANE_INT32;
  const VersionToCheck :ANE_STR) : Boolean;
const StringLength = 50;
var
  ActualMajor : ANE_INT32;
  ActualMinor : ANE_INT32;
  ActualUpdate : ANE_INT32;
  ActualVersion : array[1..StringLength] of Char;
//  StringLength : ANE_INT32;
begin
//  StringLength := 50;
  ANE_GetVersion(aneHandle, Addr(ActualMajor) , Addr(ActualMinor),
    Addr(ActualUpdate), @ActualVersion, StringLength );
  result := False;
  if (MajorToCheck < ActualMajor) then
  begin
    Result := True;
  end
  else if MajorToCheck = ActualMajor then
  begin
    if MinorToCheck*10 + UpdateToCheck < ActualMinor then
    begin
      Result := True;
    end
    else if MinorToCheck*10 + UpdateToCheck = ActualMinor then
    begin
      if Ord(UpperCase(String(VersionToCheck))[1]) - Ord('A') + 1 <= ActualUpdate  then
      begin
        Result := True;
        ShowMessage(IntToStr(Ord(UpperCase(string(VersionToCheck))[1]) - Ord('A') + 1));
      end;
    end
  end;
end;

procedure GPIECheckVersionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  MajorToCheck : ANE_INT32;
  ActualMajor : ANE_INT32;
  param2_ptr : ANE_INT32_PTR;
  MinorToCheck : ANE_INT32;
  ActualMinor : ANE_INT32;
  param3_ptr : ANE_INT32_PTR;
  UpdateToCheck : ANE_INT32;
  ActualUpdate : ANE_INT32;
  VersionToCheck : ANE_STR;
  ActualVersion : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  StringLength : ANE_INT32;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  MajorToCheck :=  param1_ptr^;
  param2_ptr :=  param^[1];
  MinorToCheck :=  param2_ptr^;
  param3_ptr :=  param^[2];
  UpdateToCheck :=  param3_ptr^;
  VersionToCheck :=  param^[3];
  StringLength := 1;
  result := CheckArgusVersion(myHandle, MajorToCheck, MinorToCheck,
    UpdateToCheck, VersionToCheck);
{  ANE_GetVersion(myHandle, Addr(ActualMajor) , Addr(ActualMinor),
    Addr(ActualUpdate), ActualVersion, StringLength );
{  result := False;
  if (MajorToCheck > ActualMajor) then
  begin
    Result := True;
  end
  else if MajorToCheck = ActualMajor then
  begin
    if MinorToCheck*10 + UpdateToCheck > ActualMinor then
    begin
      Result := True;
    end
    else if MinorToCheck*10 + UpdateToCheck = ActualMinor then
    begin
      if Ord(String(VersionToCheck)[1]) >= ActualUpdate then
      begin
        Result := True;
      end;
    end
  end;    }
  ANE_BOOL_PTR(reply)^ := result;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gPIECheckVersionFDesc.name := 'CheckVersion';	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnVersionNames;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gVersionTypes;	// pointer to parameters types list

       	gPIECheckVersionDesc.name  := 'CheckVersion';		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
	
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gFunDesc;

end;

end.
