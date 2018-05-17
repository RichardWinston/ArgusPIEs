unit GetDirectoryUnit;

interface

uses
  AnePIE, FunctionPie, Windows, SysUtils;

// GetANEFunctions is the only function exported by the dll.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  
implementation

// One PIE is exported
const
  kMaxFunDesc = 1;

var
  // declare an array of pointers to PIE descriptors.
  gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

  // declare a PIE descriptor record and a PIE function descriptor record
  gPIEGetDirDesc  :  ANEPIEDesc;
  gPIEGetDirFDesc :  FunctionPIEDesc;

// GetDLLName returns the name of the dll which contains GetDLLName function.
function GetDLLName : string;
var
  FileCheck: array[0..255] of char;
  // FileCheck is an array of characters that will hold the file name.
begin
  // HInstance is a global variable declared in SysInit.
  // It is the handle returned by Windows for this instance.

  // GetModuleFileName gets the full path and name of the module identified
  // by the handle passed to it; in this case HInstance.
  GetModuleFileName(HInstance, Filecheck, 255);

  // Convert the array to a string.
  result := String(Filecheck)
end;
{
// GetDllFullPath attempts to retrieve the full path of a dll given only it's
// file name.  It returns True if it suceeds and false if it fails.
// The path of the dll is returned through the variable FullPath.
function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  AHandle : HWND;
  ModuleFileName : array[0..255] of char;
begin
  FullPath := '';
  AHandle := GetModuleHandle(PChar(FileName))  ;
  if AHandle = 0 then
  begin
    Result := False;
  end
  else
  begin
    if (GetModuleFileName(AHandle, @ModuleFileName[0],
       SizeOf(ModuleFileName)) > 0) then
    begin
      FullPath := ModuleFileName;
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
  DllDirectory := ExtractFileDir(ExtractShortPathName(DllDirectory));
end; }

// GPIEGetDLLDirectoryMMFun is a PIEFunctionCall. (See FunctionPIE.pas.)
// It returns the directory containing the PIE.
procedure GPIEGetDLLDirectoryMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_STR;
  DllDirectory : String ;
begin
//  GetDllDirectory(GetDLLName, DllDirectory);
  DllDirectory := ExtractFileDir(ExtractShortPathName(GetDLLName)) + '\';
  result := PChar(DllDirectory);
  ANE_STR_PTR(reply)^ := result;
end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
var
  DllName : String ;
begin
  // Get the name of the DLL.
  DllName := ExtractFileName(GetDLLName);
  // strip the '.dll' from the name of the dll.
  DllName := Copy(DllName,1,Length(DllName) -4);

  // initialize the number of names
  numNames := 0;

  // set the values of the Function PIE descriptor fields.
  // the name of function is the name of the dll.
  gPIEGetDirFDesc.name := PChar(DllName);
  // The function address is GPIEGetDLLDirectoryMMFun
  gPIEGetDirFDesc.address := GPIEGetDLLDirectoryMMFun;
  // the function returns a string
  gPIEGetDirFDesc.returnType := kPIEString;
  // The number of parameters for the function is 0.
  gPIEGetDirFDesc.numParams :=  0;
  // The number of optional parameters for the function is 0.
  gPIEGetDirFDesc.numOptParams := 0;
  // pointer to parameter names list. Because there are no names, this is nil.
  gPIEGetDirFDesc.paramNames := nil;
  // pointer to parameters types list. Because there are no names, this is nil.
  gPIEGetDirFDesc.paramTypes := nil;

  // Set the values of the PIE descriptor fields
  // the name of PIE is the name of the dll.
  gPIEGetDirDesc.name  := PChar(DllName);
  // PIE type: PIE function
  gPIEGetDirDesc.PieType :=  kFunctionPIE;
  // pointer to function PIE descriptor
  gPIEGetDirDesc.descriptor := @gPIEGetDirFDesc;

  // allow assertions
  {$ASSERTIONS ON}
  // check that the maximum number of PIE descriptor has not been exceeded
  Assert (numNames < kMaxFunDesc) ;
  // add descriptor to list
  gFunDesc[numNames] := @gPIEGetDirDesc;
  // increment number of names
  Inc(numNames);

  // assign a pointer to the array of PIE descriptors to 'descriptors'.
  descriptors := @gFunDesc;

end;

end.
