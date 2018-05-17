unit GetANEFunctionsUnit;

interface

uses
  Dialogs, ProjectPIE, AnePIE, Forms, SysUtils, Controls, Classes;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

const
  kMaxPIEDesc = 138;
  kMaxAdditionalPies = 0;

var
  gPIEDesc : Array [0..kMaxPIEDesc+kMaxAdditionalPies-1] of ^ANEPIEDesc;

implementation

uses SutraPIEFunctions, CustomizedSutraPieFunctions, ArgusFormUnit, hh,
  hh_funcs, UtilityFunctions;

const
  Project : ANE_Str = 'SUTRA';
  Vendor :  ANE_Str = 'Richard Winston';
  Product : ANE_Str = 'New SUTRA PIE' ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  GetSutraFunctions(Project, Vendor, Product, numNames);

  GetMoreFuctions(Project, Vendor, Product, numNames) ;

  descriptors := @gPIEDesc;

end;

var mHHelp: THookHelpSystem = nil;

function HelpFileFullPath(const FileName: string): string;
var
  DllDirectory : String;
begin
  result := '';
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      result := DllDirectory + '\' + FileName;
      if not FileExists(result) then
      begin
        Beep;
        ShowMessage(result + ' not found.');
      end;
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

Procedure InitializeHTMLHELP;
begin
  if mHHelp = nil then
  begin
    LoadHtmlHelp;
    mHHelp := THookHelpSystem.Create(HelpFileFullPath('Sutra GUI.chm'), '', htHHexe);
  end;
end;

initialization
  InitializeHTMLHELP;

finalization
  mHHelp.Free;
  mHHelp := nil;

end.
