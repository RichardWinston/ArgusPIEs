unit GetANEFunctonsUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Dialogs, Forms, Classes,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, FunctionPIE ;

var
   MeshNames : TStringList;

const
  NodeLinePrefix = 'N';
  ElemLinePrefix = 'E';
  ExportSeparator = #9;
  ExportDelimiter = #9;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

Procedure ClearMeshNames;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, {Unit1,} ParamNamesAndTypes, FreeMeshUnit, ReadMeshUnit,
  FreeAllMeshesUnit, ExportNodes, ExportElements, GetCounts, NodeValue;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const
  kMaxFunDesc = 11;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gReadMeshFunctionPIEDesc : FunctionPIEDesc;       // Function PIE descriptor
   gReadMeshPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gFreeMeshFunctionPIEDesc : FunctionPIEDesc;       // Function PIE descriptor
   gFreeMeshPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gFreeAllMeshFunctionPIEDesc : FunctionPIEDesc;    // Function PIE descriptor
   gFreeAllMeshPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gExportElementsFunctionPIEDesc : FunctionPIEDesc; // Function PIE descriptor
   gExportElementsPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gExportNodesFunctionPIEDesc : FunctionPIEDesc;    // Function PIE descriptor
   gExportNodesPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gNodesCountFunctionPIEDesc : FunctionPIEDesc;     // Function PIE descriptor
   gNodesCountPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gElementsCountFunctionPIEDesc : FunctionPIEDesc;     // Function PIE descriptor
   gElementsCountPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gNodeParameterCountFunctionPIEDesc : FunctionPIEDesc;     // Function PIE descriptor
   gNodeParameterCountPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gElementParameterCountFunctionPIEDesc : FunctionPIEDesc;     // Function PIE descriptor
   gElementParameterCountPIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gNodeValueFunctionPIEDesc : FunctionPIEDesc;     // Function PIE descriptor
   gNodeValuePIEDesc         : ANEPIEDesc;	     // PIE descriptor

   gElementValueFunctionPIEDesc : FunctionPIEDesc;     // Function PIE descriptor
   gElementValuePIEDesc         : ANEPIEDesc;	     // PIE descriptor

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
  Project = 'SUTRA';
var
  Options : EFunctionPIEFlags;
begin
//  Options := kFunctionNeedsProject or kFunctionIsHidden;
  Options := kFunctionNeedsProject;

  numNames := 0;

  gReadMeshFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gReadMeshFunctionPIEDesc.functionFlags := Options;
  gReadMeshFunctionPIEDesc.name := 'Read_QuadMesh';   // name of project
  gReadMeshFunctionPIEDesc.numParams := 1;   // name of project
  gReadMeshFunctionPIEDesc.numOptParams := 0;   // name of project
  gReadMeshFunctionPIEDesc.paramNames := @gpnElementLayerName;   // name of project
  gReadMeshFunctionPIEDesc.paramTypes := @gOneStringTypes;   // name of project
  gReadMeshFunctionPIEDesc.returnType := kPIEBoolean;   // name of project
  gReadMeshFunctionPIEDesc.address := @GReadMeshPIE;// address of Post Processing Function function
  gReadMeshFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  //
  // prepare PIE descriptor for Example Delphi PIE

  gReadMeshPIEDesc.name := 'Read_QuadMesh';      // PIE name
  gReadMeshPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gReadMeshPIEDesc.descriptor := @gReadMeshFunctionPIEDesc;	// pointer to descriptor

  {$ASSERTIONS ON}
  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gReadMeshPIEDesc;
  Inc(numNames);	// add descriptor to list

  gFreeMeshFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gFreeMeshFunctionPIEDesc.functionFlags := Options;
  gFreeMeshFunctionPIEDesc.name := 'Free_QuadMesh';   // name of project
  gFreeMeshFunctionPIEDesc.numParams := 1;   // name of project
  gFreeMeshFunctionPIEDesc.numOptParams := 0;   // name of project
  gFreeMeshFunctionPIEDesc.paramNames := @gpnElementLayerName;   // name of project
  gFreeMeshFunctionPIEDesc.paramTypes := @gOneStringTypes;   // name of project
  gFreeMeshFunctionPIEDesc.returnType := kPIEBoolean;   // name of project
  gFreeMeshFunctionPIEDesc.address := @GFreeMeshPIE;// address of Post Processing Function function
  gFreeMeshFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gFreeMeshPIEDesc.name := 'Free_QuadMesh';      // PIE name
  gFreeMeshPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gFreeMeshPIEDesc.descriptor := @gFreeMeshFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gFreeMeshPIEDesc;
  Inc(numNames);	// add descriptor to list


  // free all meshes
  gFreeAllMeshFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gFreeAllMeshFunctionPIEDesc.functionFlags := Options;
  gFreeAllMeshFunctionPIEDesc.name := 'Free_AllQuadMeshes';   // name of project
  gFreeAllMeshFunctionPIEDesc.numParams := 0;   // name of project
  gFreeAllMeshFunctionPIEDesc.numOptParams := 0;   // name of project
  gFreeAllMeshFunctionPIEDesc.paramNames := nil;   // name of project
  gFreeAllMeshFunctionPIEDesc.paramTypes := nil;   // name of project
  gFreeAllMeshFunctionPIEDesc.returnType := kPIEBoolean;   // name of project
  gFreeAllMeshFunctionPIEDesc.address := @GFreeAllMeshPIE;// address of Post Processing Function function
  gFreeAllMeshFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gFreeAllMeshPIEDesc.name := 'Free_AllQuadMeshes';      // PIE name
  gFreeAllMeshPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gFreeAllMeshPIEDesc.descriptor := @gFreeAllMeshFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gFreeAllMeshPIEDesc;
  Inc(numNames);	// add descriptor to list

  
  // export all nodes for a particular parameter
  gExportNodesFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gExportNodesFunctionPIEDesc.functionFlags := Options;
  gExportNodesFunctionPIEDesc.name := 'Export_Nodes';   // name of project
  gExportNodesFunctionPIEDesc.numParams := 3;   // name of project
  gExportNodesFunctionPIEDesc.numOptParams := 0;   // name of project
  gExportNodesFunctionPIEDesc.paramNames := @gpnLayerParam;   // name of project
  gExportNodesFunctionPIEDesc.paramTypes := @g3StringTypes;   // name of project
  gExportNodesFunctionPIEDesc.returnType := kPIEBoolean;   // name of project
  gExportNodesFunctionPIEDesc.address := @GExportNodesPIE;// address of Post Processing Function function
  gExportNodesFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gExportNodesPIEDesc.name := 'Export_Nodes';      // PIE name
  gExportNodesPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gExportNodesPIEDesc.descriptor := @gExportNodesFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gExportNodesPIEDesc;
  Inc(numNames);	// add descriptor to list

  // export all elements for a particular parameter
  gExportElementsFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gExportElementsFunctionPIEDesc.functionFlags := Options;
  gExportElementsFunctionPIEDesc.name := 'Export_Elements';   // name of project
  gExportElementsFunctionPIEDesc.numParams := 3;   // name of project
  gExportElementsFunctionPIEDesc.numOptParams := 0;   // name of project
  gExportElementsFunctionPIEDesc.paramNames := @gpnLayerParam;   // name of project
  gExportElementsFunctionPIEDesc.paramTypes := @g3StringTypes;   // name of project
  gExportElementsFunctionPIEDesc.returnType := kPIEBoolean;   // name of project
  gExportElementsFunctionPIEDesc.address := @GExportElementsPIE;// address of Post Processing Function function
  gExportElementsFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gExportElementsPIEDesc.name := 'Export_Elements';      // PIE name
  gExportElementsPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gExportElementsPIEDesc.descriptor := @gExportElementsFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gExportElementsPIEDesc;
  Inc(numNames);	// add descriptor to list

  gNodesCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gNodesCountFunctionPIEDesc.functionFlags := Options;
  gNodesCountFunctionPIEDesc.name := 'NodeCount';   // name of project
  gNodesCountFunctionPIEDesc.numParams := 1;   // name of project
  gNodesCountFunctionPIEDesc.numOptParams := 0;   // name of project
  gNodesCountFunctionPIEDesc.paramNames := @gpnElementLayerName;   // name of project
  gNodesCountFunctionPIEDesc.paramTypes := @gOneStringTypes;   // name of project
  gNodesCountFunctionPIEDesc.returnType := kPIEInteger;   // name of project
  gNodesCountFunctionPIEDesc.address := @GNumNodesPIE;// address of Post Processing Function function
  gNodesCountFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gNodesCountPIEDesc.name := 'NodeCount';      // PIE name
  gNodesCountPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gNodesCountPIEDesc.descriptor := @gNodesCountFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gNodesCountPIEDesc;
  Inc(numNames);	// add descriptor to list

  gElementsCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gElementsCountFunctionPIEDesc.functionFlags := Options;
  gElementsCountFunctionPIEDesc.name := 'ElementCount';   // name of project
  gElementsCountFunctionPIEDesc.numParams := 1;   // name of project
  gElementsCountFunctionPIEDesc.numOptParams := 0;   // name of project
  gElementsCountFunctionPIEDesc.paramNames := @gpnElementLayerName;   // name of project
  gElementsCountFunctionPIEDesc.paramTypes := @gOneStringTypes;   // name of project
  gElementsCountFunctionPIEDesc.returnType := kPIEInteger;   // name of project
  gElementsCountFunctionPIEDesc.address := @GNumElemPIE;// address of Post Processing Function function
  gElementsCountFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gElementsCountPIEDesc.name := 'ElementCount';      // PIE name
  gElementsCountPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gElementsCountPIEDesc.descriptor := @gElementsCountFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gElementsCountPIEDesc;
  Inc(numNames);	// add descriptor to list

  gNodeParameterCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gNodeParameterCountFunctionPIEDesc.functionFlags := Options;
  gNodeParameterCountFunctionPIEDesc.name := 'NodeParametersCount';   // name of project
  gNodeParameterCountFunctionPIEDesc.numParams := 1;   // name of project
  gNodeParameterCountFunctionPIEDesc.numOptParams := 0;   // name of project
  gNodeParameterCountFunctionPIEDesc.paramNames := @gpnElementLayerName;   // name of project
  gNodeParameterCountFunctionPIEDesc.paramTypes := @gOneStringTypes;   // name of project
  gNodeParameterCountFunctionPIEDesc.returnType := kPIEInteger;   // name of project
  gNodeParameterCountFunctionPIEDesc.address := @GNumNodeParamPIE;// address of Post Processing Function function
  gNodeParameterCountFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gNodeParameterCountPIEDesc.name := 'NodeParametersCount';      // PIE name
  gNodeParameterCountPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gNodeParameterCountPIEDesc.descriptor := @gNodeParameterCountFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gNodeParameterCountPIEDesc;
  Inc(numNames);	// add descriptor to list

  gElementParameterCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gElementParameterCountFunctionPIEDesc.functionFlags := Options;
  gElementParameterCountFunctionPIEDesc.name := 'ElementParametersCount';   // name of project
  gElementParameterCountFunctionPIEDesc.numParams := 1;   // name of project
  gElementParameterCountFunctionPIEDesc.numOptParams := 0;   // name of project
  gElementParameterCountFunctionPIEDesc.paramNames := @gpnElementLayerName;   // name of project
  gElementParameterCountFunctionPIEDesc.paramTypes := @gOneStringTypes;   // name of project
  gElementParameterCountFunctionPIEDesc.returnType := kPIEInteger;   // name of project
  gElementParameterCountFunctionPIEDesc.address := @GNumElemParamPIE;// address of Post Processing Function function
  gElementParameterCountFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gElementParameterCountPIEDesc.name := 'ElementParametersCount';      // PIE name
  gElementParameterCountPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gElementParameterCountPIEDesc.descriptor := @gElementParameterCountFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gElementParameterCountPIEDesc;
  Inc(numNames);	// add descriptor to list

  //
  gNodeValueFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gNodeValueFunctionPIEDesc.functionFlags := Options;
  gNodeValueFunctionPIEDesc.name := 'Node_Value';   // name of project
  gNodeValueFunctionPIEDesc.numParams := 3;   // name of project
  gNodeValueFunctionPIEDesc.numOptParams := 0;   // name of project
  gNodeValueFunctionPIEDesc.paramNames := @gpnLayerParamNode;   // name of project
  gNodeValueFunctionPIEDesc.paramTypes := @g2String2IntegerTypes;   // name of project
  gNodeValueFunctionPIEDesc.returnType := kPIEString;   // name of project
  gNodeValueFunctionPIEDesc.address := @GNodesValuePIE;// address of Post Processing Function function
  gNodeValueFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gNodeValuePIEDesc.name := 'Node_Value';      // PIE name
  gNodeValuePIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gNodeValuePIEDesc.descriptor := @gNodeValueFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gNodeValuePIEDesc;
  Inc(numNames);	// add descriptor to list

  //
  gElementValueFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
  gElementValueFunctionPIEDesc.functionFlags := Options;
  gElementValueFunctionPIEDesc.name := 'Element_Value';   // name of project
  gElementValueFunctionPIEDesc.numParams := 3;   // name of project
  gElementValueFunctionPIEDesc.numOptParams := 0;   // name of project
  gElementValueFunctionPIEDesc.paramNames := @gpnLayerParamElem;   // name of project
  gElementValueFunctionPIEDesc.paramTypes := @g2String2IntegerTypes;   // name of project
  gElementValueFunctionPIEDesc.returnType := kPIEString;   // name of project
  gElementValueFunctionPIEDesc.address := @GNodesValuePIE;// address of Post Processing Function function
  gElementValueFunctionPIEDesc.neededProject := Project;// address of Post Processing Function function

  gElementValuePIEDesc.name := 'Element_Value';      // PIE name
  gElementValuePIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
  gElementValuePIEDesc.descriptor := @gElementValueFunctionPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gElementValuePIEDesc;
  Inc(numNames);	// add descriptor to list




  descriptors := @gFunDesc;
end;

Procedure ClearMeshNames;
var
  Index : integer;
begin
  for Index := 0 to MeshNames.Count -1 do
  begin
    MeshNames.Objects[Index].Free;
  end;
  MeshNames.Clear;

end;

initialization
begin
  MeshNames := TStringList.create;
  MeshNames.Sort;
end;

finalization
begin
  ClearMeshNames;
  MeshNames.Free;
end;

end.
