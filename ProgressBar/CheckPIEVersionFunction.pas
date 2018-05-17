unit CheckPIEVersionFunction;

interface

uses AnePIE, FunctionPIE;

const   gpnFourDigit : array [0..4] of PChar = ('First_Digit', 'Second_Digit', 'Third_Digit', 'Fourth_Digit', nil);
const   gFourIntegerTypes : array [0..4] of EPIENumberType = (kPIEInteger, kPIEInteger, kPIEInteger, kPIEInteger, 0);

var
  gPIECheckVersionDesc  : ANEPIEDesc;
  gPIECheckVersionFDesc : FunctionPIEDesc;

Procedure GPIECheckVersionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{procedure AddCheckVersionFunction(Var Desc: ANEPIEDesc; const ModelPrefix : string;
  const CurrentfunctionFlags : integer;
  const category, neededProject, vendor, product : ANE_STR);}


implementation

uses VersInfo, UtilityFunctions, Forms, SysUtils;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

Procedure GPIECheckVersionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  param4_ptr : ANE_INT32_PTR;
  FirstDigit, SecondDigit, ThirdDigit,FouthDigit : integer;
  result : ANE_BOOL;
  param : PParameter_array;
  VersionInfo1: TVersionInfo;
  VersionString : String;
  currentDigit : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      FirstDigit :=  param1_ptr^;
      param2_ptr :=  param^[1];
      SecondDigit :=  param2_ptr^;
      param3_ptr :=  param^[2];
      ThirdDigit :=  param3_ptr^;
      param4_ptr :=  param^[3];
      FouthDigit :=  param4_ptr^;
      VersionInfo1 := TVersionInfo.Create(Application);
      try
        VersionInfo1.FileName := GetDLLName;
        VersionString := VersionInfo1.FileVersion;
        currentDigit := StrToInt(Copy(VersionString,1,Pos('.',VersionString)-1));
        result := (currentDigit >= FirstDigit);
        if (currentDigit = FirstDigit) then
        begin
          VersionString := Copy(VersionString,Pos('.',VersionString)+1, Length(VersionString));
          currentDigit := StrToInt(Copy(VersionString,1,Pos('.',VersionString)-1));
          result := (currentDigit >= SecondDigit);
          if (currentDigit = SecondDigit) then
          begin
            VersionString := Copy(VersionString,Pos('.',VersionString)+1, Length(VersionString));
            currentDigit := StrToInt(Copy(VersionString,1,Pos('.',VersionString)-1));
            result := (currentDigit >= ThirdDigit);
            if (currentDigit = ThirdDigit) then
            begin
              VersionString := Copy(VersionString,Pos('.',VersionString)+1, Length(VersionString));
              currentDigit := StrToInt(VersionString);
              result := (currentDigit >= FouthDigit);
            end;
          end;
        end;
      finally
        VersionInfo1.Free;
      end;
    end;
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

{procedure AddCheckVersionFunction(Var Desc: ANEPIEDesc; const ModelPrefix : string;
  const CurrentfunctionFlags : integer;
  const category, neededProject, vendor, product : ANE_STR);
begin

	gPIECheckVersionFDesc.name := PChar(ModelPrefix + 'CheckVersion');	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := CurrentfunctionFlags;
        gPIECheckVersionFDesc.category := category;
        gPIECheckVersionFDesc.neededProject := neededProject;

       	gPIECheckVersionDesc.name  := PChar(ModelPrefix + 'CheckVersion');		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;
        gPIECheckVersionDesc.vendor := vendor;
        gPIECheckVersionDesc.product := product;

        Desc := gPIECheckVersionDesc;

//	Assert (numNames < MaxFunDesc) ;
//	Desc.Descriptors[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
//        Inc(numNames);	// increment number of names

end;   }

end.
