unit CheckPIEVersionFunction;

interface

{This unit provides a PIE function that can be used to check whether the
  correct version of the PIE is installed.}

uses Windows, Forms, Dialogs, AnePIE, FunctionPIE;

const   gpnFourDigit : array [0..4] of PChar = ('First_Digit', 'Second_Digit',
  'Third_Digit', 'Fourth_Digit', nil);
const   gFourIntegerTypes : array [0..4] of EPIENumberType = (kPIEInteger,
  kPIEInteger, kPIEInteger, kPIEInteger, 0);

var
  gPIECheckVersionDesc  : ANEPIEDesc;
  gPIECheckVersionFDesc : FunctionPIEDesc;

Procedure GPIECheckVersionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

// GPIECheckVersionMMFun can be used to check the installed version of a PIE.
// If the version number of the PIE (in the form I1.I2.I3.I4) is greater than
// or equal to the version passed as parameter arguements, the function returns
// True. Otherwise, it returns false. 

implementation

uses UtilityFunctions, {Forms,} SysUtils {, JvVersionInfo};

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

function GetPieVersion: string;
var
  VerInfoSize: DWORD;
  GetInfoSizeJunk: DWORD;
  VersionInfo: Pointer;
  VersionValue: string;
  Translation: Pointer;
  VersionInfoSize: UINT;
  InfoPointer: Pointer;
begin
  result := '';
//  VerInfoSize := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(GetDLLName), GetInfoSizeJunk);
  Assert(VerInfoSize > 0);
  GetMem(VersionInfo, VerInfoSize);
  try
    GetFileVersionInfo(PChar(GetDLLName), 0, VerInfoSize, VersionInfo);

    VerQueryValue(VersionInfo, PChar('\\VarFileInfo\\Translation'),
      Translation, VersionInfoSize);

    VersionValue := '\\StringFileInfo\\'
      + IntToHex(LoWord(LongInt(Translation^)),4)
      + IntToHex(HiWord(LongInt(Translation^)),4)
      + '\\';

    VerQueryValue(VersionInfo, PChar(VersionValue + 'FileVersion'),
      InfoPointer, VersionInfoSize);

    result := string(PChar(InfoPointer));
  finally
    FreeMem(VersionInfo);
  end;
end;

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
//  VersionInfo1: TJvVersionInfo;
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
//      VersionInfo1 := TJvVersionInfo.Create(GetDLLName);
      try
//        VersionInfo1.FileName := GetDLLName;
//        VersionString := VersionInfo1.FileVersion;
//        VersionString := '1.11.0.0';
        VersionString := GetPieVersion;
        currentDigit := StrToInt(Copy(VersionString,1,Pos('.',
          VersionString)-1));
        result := (currentDigit >= FirstDigit);
        if (currentDigit = FirstDigit) then
        begin
          VersionString := Copy(VersionString,Pos('.',VersionString)+1,
            Length(VersionString));
          currentDigit := StrToInt(Copy(VersionString,1,Pos('.',
            VersionString)-1));
          result := (currentDigit >= SecondDigit);
          if (currentDigit = SecondDigit) then
          begin
            VersionString := Copy(VersionString,Pos('.',VersionString)+1,
              Length(VersionString));
            currentDigit := StrToInt(Copy(VersionString,1,Pos('.',
              VersionString)-1));
            result := (currentDigit >= ThirdDigit);
            if (currentDigit = ThirdDigit) then
            begin
              VersionString := Copy(VersionString,Pos('.',VersionString)+1,
                Length(VersionString));
              currentDigit := StrToInt(VersionString);
              result := (currentDigit >= FouthDigit);
            end;
          end;
        end;
      finally
//        VersionInfo1.Free;
      end;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

{
	gPIECheckVersionFDesc.name := 'CheckVersion';	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := UsualOptions;

       	gPIECheckVersionDesc.name  := 'CheckVersion';		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names
}
//initialization
//  ShowMessage(GetPieVersion);

end.
