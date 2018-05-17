unit ProjectUnit;

interface

uses
  
  ProjectPIE, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

function GSimpleExportNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

implementation

const
  kMaxPIEDesc = 20;

var
gSimpleProjectPDesc : ProjectPIEDesc ;
gSimpleProjectDesc : ANEPIEDesc ;

gPIEDesc : Array [0..kMaxPIEDesc-1] of ^ANEPIEDesc;



function GSimpleExportNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerStructure : ANE_STR;
begin
{
Chr(9) is a tab character.

Chr(10) is the new-line character.

\t represents the tab character in C++ and thus is interpreted
as a tab in the template.
}
  layerStructure :=  PChar(
'Layer:' + Chr(10) + 
'{' + Chr(10) + 
Chr(9) + 'Name: "Simple Domain"' + Chr(10) +
Chr(9) + 'Units: "Density"' + Chr(10) +
Chr(9) + 'Type: "Domain"' + Chr(10) + 
Chr(9) + 'Visible: Yes' + Chr(10) + 
Chr(9) + 'Interpretation Method: Nearest' + Chr(10) + 
Chr(9) + '' + Chr(10) +
Chr(9) + 'Parameter: ' + Chr(10) + 
Chr(9) + '{' + Chr(10) +
Chr(9) + Chr(9) + 'Name: "Density"' + Chr(10) +
Chr(9) + Chr(9) + 'Units: "Units"' + Chr(10) + 
Chr(9) + Chr(9) + 'Value Type: Real' + Chr(10) + 
Chr(9) + Chr(9) + 'Value: "0"' + Chr(10) + 
Chr(9) + Chr(9) + 'Parameter Type: Layer' + Chr(10) + 
Chr(9) + '}' + Chr(10) +
'}' + Chr(10) +
'Layer:' + Chr(10) +
'{' + Chr(10) +
Chr(9) + 'Name: "Simple Density"' + Chr(10) +
Chr(9) + 'Units: "Units"' + Chr(10) +
Chr(9) + 'Type: "Information"' + Chr(10) +
Chr(9) + 'Visible: Yes' + Chr(10) +
Chr(9) + 'Interpretation Method: Nearest' + Chr(10) +
Chr(9) + '' + Chr(10) +
Chr(9) + 'Parameter: ' + Chr(10) +
Chr(9) + '{' + Chr(10) +
Chr(9) + Chr(9) + 'Name: "Simple Density"' + Chr(10) +
Chr(9) + Chr(9) + 'Units: "Units"' + Chr(10) +
Chr(9) + Chr(9) + 'Value Type: Real' + Chr(10) +
Chr(9) + Chr(9) + 'Value: "0"' + Chr(10) +
Chr(9) + Chr(9) + 'Parameter Type: Layer' + Chr(10) +
Chr(9) + '}' + Chr(10) +
'}' + Chr(10) +
'Layer:' + Chr(10) +
'{' + Chr(10) +
Chr(9) + 'Name: "SimpleGrid"' + Chr(10) +
Chr(9) + 'Units: "Units"' + Chr(10) +
Chr(9) + 'Type: "Grid"' + Chr(10) +
Chr(9) + 'Visible: Yes' + Chr(10) +
Chr(9) + 'Domain Layer: "Simple Domain"' + Chr(10) +
Chr(9) + 'Density Layer: "Simple Density"' + Chr(10) +
Chr(9) + '' + Chr(10) +
Chr(9) + 'Template: ' + Chr(10) +
Chr(9) + '{' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "File: $BaseName$"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NumRows(); [I8]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NumColumns(); [I8]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NumBlockParameters()+1 [I8]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLoop: Rows"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NthRowPos($Row$) [F8.2]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd loop"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLoop: Columns"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: NthColumnPos($Column$) [F8.2]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd loop"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tMatrix: BlockIsActive() [I1]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLoop: Block Parameters"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tLine"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tExpr: \"# $Parameter$\""' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd line"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tMatrix: $Parameter$ [F8.2]"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd loop"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: "\tEnd file"' + Chr(10) +
Chr(9) + Chr(9) + 'Line: ""' + Chr(10) +
Chr(9) + '}' + Chr(10) +
'}'+ Chr(10) + Chr(10) );

	rLayerTemplate^ := layerStructure;

	result := True;

end; { GSimpleExportTemplate }

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gSimpleProjectPDesc.version := PROJECT_PIE_VERSION;
	gSimpleProjectPDesc.name := 'Simple Delphi Project';
	gSimpleProjectPDesc.projectFlags := 0;
	gSimpleProjectPDesc.createNewProc := GSimpleExportNew;
	gSimpleProjectPDesc.editProjectProc := nil;
	gSimpleProjectPDesc.cleanProjectProc := nil;
	gSimpleProjectPDesc.saveProc := nil;
	gSimpleProjectPDesc.loadProc := nil;

	gSimpleProjectDesc.name  := 'Simple Delphi Project';
	gSimpleProjectDesc.PieType :=  kProjectPIE;
	gSimpleProjectDesc.descriptor := @gSimpleProjectPDesc;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gSimpleProjectDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gPIEDesc;

end;

end.
