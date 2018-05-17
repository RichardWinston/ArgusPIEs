unit exportUnit;

{Purpose: to illustrate an export PIE.}

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

// We need to use the appropriate units. In this example, we have an export
// PIE so we need to use ExportTemplatePIE.pas. All PIE's use AnePIE.
uses
  ExportTemplatePIE, AnePIE;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GSimpleExportTemplate( Handle : ANE_PTR;
  returnTemplate : ANE_STR_PTR); cdecl;
          
implementation

// Chr(13) is a carraige return
// Chr(10) is a line feed.
procedure GSimpleExportTemplate( Handle : ANE_PTR;
  returnTemplate : ANE_STR_PTR); cdecl;
var
  template : string;
begin
  Template :=
'Redirect output to: $BaseName$' + Chr(13) + Chr(10) +
'	Loop for: Elements' + Chr(13) + Chr(10) +
'		Start a new line' + Chr(13) + Chr(10) +
'			Export expression: "Triangle "' + Chr(13) + Chr(10) +
'			Export expression: NthNodeX(1); [F8.2]' + Chr(13) + Chr(10) +
'			Export expression: NthNodeY(1); [F8.2]' + Chr(13) + Chr(10) +
'			Export expression: NthNodeX(2); [F8.2]' + Chr(13) + Chr(10) +
'			Export expression: NthNodeY(2); [F8.2]' + Chr(13) + Chr(10) +
'			Export expression: NthNodeX(3); [F8.2]' + Chr(13) + Chr(10) +
'			Export expression: NthNodeY(3); [F8.2]' + Chr(13) + Chr(10) +
'		End line' + Chr(13) + Chr(10) +
'	End loop' + Chr(13) + Chr(10) +
'End file' + Chr(13) + Chr(10) + Chr(13) + Chr(10);

	returnTemplate^ := PChar(Template);
end;
 { GSimpleExportTemplate }

const
  kMaxFunDesc = 20;

var
gSimpleExportTemplateTDesc : ExportTemplatePIEDesc ;
gSimpleExportTemplateDesc : ANEPIEDesc ;

gPIEDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

name : PChar = 'Delphi Simple Export PIE';

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gSimpleExportTemplateTDesc.name := name;
	gSimpleExportTemplateTDesc.exportType := kPIETriMeshLayer;
	gSimpleExportTemplateTDesc.exportFlags := kExportDontShowParamDialog;
	gSimpleExportTemplateTDesc.getTemplateProc := GSimpleExportTemplate;

	gSimpleExportTemplateDesc.name  := name;
	gSimpleExportTemplateDesc.PieType :=  kExportTemplatePIE;
	gSimpleExportTemplateDesc.descriptor := @gSimpleExportTemplateTDesc;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gPIEDesc[numNames] := @gSimpleExportTemplateDesc;
        Inc(numNames);	// add descriptor to list

	//*numNames)++;

	descriptors := @gPIEDesc;
end;


end.
