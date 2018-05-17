unit ImportUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Dialogs, Forms, Controls,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, Unit1;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gDelphiPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDelphiPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor


// This reads an integer from the begining of a string and returns
//the integer and the string with the integer removed.
// This procedure is untested.

// import data from a text file.
procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

var
  ObjectIndex : integer;
  ObjectCount : integer;
  LayerOptions : TLayerOptions;
  ContourObject : TContourObjectOptions;
  ParameterIndex : ANE_INT16;
begin
  Form1 := TForm1.Create(Application);
  try
    if Form1.ShowModal = mrOK then
    begin
      ParameterIndex := Form1.RadioGroup1.ItemIndex;
      LayerOptions := TLayerOptions.Create(layerHandle);
      try
        ObjectCount := LayerOptions.NumObjects(aneHandle, pieContourObject);
        for ObjectIndex := 0 to ObjectCount - 1 do
        begin
          ContourObject := TContourObjectOptions.Create
            (aneHandle, layerHandle, ObjectIndex);
          try
            ContourObject.SetFloatParameter(aneHandle,ParameterIndex,5);
          finally
            ContourObject.Free;
          end;

        end;

      finally
        LayerOptions.Free(aneHandle);
      end;
    end;

  finally
    Form1.Free;
  end;

end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gDelphiPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gDelphiPIEImportPIEDesc.name := 'Test_Pie';   // name of project
	gDelphiPIEImportPIEDesc.importFlags := kImportFromLayer;
        gDelphiPIEImportPIEDesc.fromLayerTypes := kPIEInformationLayer;
 	gDelphiPIEImportPIEDesc.toLayerTypes := kPIEInformationLayer {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.doImportProc := @GDelphiPIE;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gDelphiPIEDesc.name := 'Test_Pie';      // PIE name
	gDelphiPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gDelphiPIEDesc.descriptor := @gDelphiPIEImportPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gDelphiPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
 