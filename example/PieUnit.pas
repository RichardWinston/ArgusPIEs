unit PieUnit;

interface

uses Controls, ParamArrayUnit, AnePIE, ImportPIE, FunctionPIE, InterpolationPIE;

{
ANEPIEDesc is defined in AnePIE.pas.
FunctionPIEDesc is defined in FunctionPIE.pas.
InterpolationPIEDesc is defined in InterpolationPIE.pas.
ImportPIEDesc is defined in ImportPIE.pas.
}

// These records define the PIEs that Argus ONE will use.
var
  g_E_PIEDesc : ANEPIEDesc;
  g_E_FDesc   : FunctionPIEDesc;

  g_Average_PIEDesc    : ANEPIEDesc;
  g_Average_InterpDesc : InterpolationPIEDesc;

  g_SimpleImport_PIEDesc  : ANEPIEDesc;
  g_SimpleImport_IDesc    : ImportPIEDesc;


// GetANEFunctions is how Argus ONE finds out what PIEs the dll has.
// GetANEFunctions is called when Argus ONE starts up. GetANEFunctions
// most be "exported" to make it available to programs that call the
// dll.  It is exported in the project source (Example.dpr).
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses ImportExample, ANECB, ParamNamesAndTypes;

// GetE is the procedure called by Argus ONE to evaluate the 'Ex' PIE function.
// The procedure has to match the arguements of a PIEFunctionCall as defined
// in FunctionPIE.

// refPtX and refPtY are pointers to the coordinates of the location where
// the function is being evaluated.
// numParams is the number of parameters that are being passed to the procedure.
// parameters is a pointer to an array of pointers to the parameters.
// funHandle is a pointer to the current Argus ONE project.
// When the procedure is finished, reply should point to the result.

procedure GetE(const refPtX : ANE_DOUBLE_PTR; const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16; const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  // The function has one parameter. Get it.
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  // Evaluate the function.
  result := Exp(param1);
  // Tell Argus ONE what the result is.
  ANE_DOUBLE_PTR(reply)^ := result;
end;

{
Use a TAverageRecord to store the average of all the data points.
PAverageRecord is a pointer to a TAverageRecord.

Usually, the record used to store data would be more complicated than this.
It might, for example, store the locations and values of all the data points.
}
type
  TAverageRecord = record
    Average : double;
  end;
  PAverageRecord = ^TAverageRecord;

// InitializeAverage is called when the 'Average' method is being used and
// the data on the layer has changed.

// In this case, we just compute and store the average.
// aneHandle is the current Argus ONE project.
// rPIEHandle is a pointer to the PIE information for this method.
// numPoints is the number of data points.
// xCoords, yCoords are pointers to ann array of X and Y coordinates of the
// data points.
// values is a pointer to the data values associated with each data point.
// Note that because 'values' is a pointer to an array of ANE_DOUBLEs,
// PIE Interpolation methods only work with real numbers, not with integers,
// booleans or strings.
procedure InitializeAverage(aneHandle : ANE_PTR; var rPIEHandle: ANE_PTR_PTR;
  numPoints : ANE_INT32; xCoords, yCoords, values : ANE_DOUBLE_PTR); cdecl;
var
  Index: integer;
  AverageRecord: PAverageRecord;
begin
  // Create a new TAverageRecord and get a pointer to it.
  GetMem(AverageRecord, SizeOf(TAverageRecord));

  // Compute the average.
  AverageRecord^.Average := 0;
  for Index := 0 to numPoints -1 do
  begin
    AverageRecord^.Average := Values^ + AverageRecord^.Average;
    Inc(Values);
  end;
  if numPoints > 0 then
  begin
    AverageRecord^.Average := AverageRecord^.Average/numPoints;
  end;

  // Tell Argus ONE where the data is stored.
  rPIEHandle := Pointer(AverageRecord);
  // Another way to do this is
  // rPIEHandle := @AverageRecord^;
end;

// EvaluateAverage is used to tell Argus ONE what the value of the
// interpolation method should be at a particular place.

// aneHandle is the current Argus ONE project.
// rPIEHandle is a pointer to the PIE information for this method.
// x and y are the location where the interpolation is being performed.
// When the procedure is done, The location that rResult is pointing at should
// contain the result.
procedure EvaluateAverage(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x, y :ANE_DOUBLE; rResult: ANE_DOUBLE_PTR); cdecl;
var
  AverageRecord: PAverageRecord;
begin
  // first we get the pointer to the TAverageRecord.
  AverageRecord := pieHandle;
  // Then we tell Argus ONE the result.
  rResult^ := AverageRecord^.Average;
end;

// FreeAverage is called when the 'Average' method has been deselected or the
// data has changed.  It is used to free up memory.

// aneHandle is the current Argus ONE project.
// rPIEHandle is a pointer to the Project PIE information if this project.
// uses a project PIE and this interpolation method applies only to that PIE.
procedure FreeAverage(aneHandle : ANE_PTR; pieHandle : ANE_PTR); cdecl;
var
  AverageRecord: PAverageRecord;
begin
  // First we get the pointer to the TAverageRecord.
  AverageRecord := pieHandle;
  // Then we release the memory associated with it.
  FreeMem(AverageRecord);
end;

// This procedure imports Argus ONE contours into Information, Domain Outline,
// or Maps layers.
procedure G_SimpleImport(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  ImportText: string;
  Index: integer;
  // TfrmImportExample is defined in ImportExample.pas.
  frmImportExample: TfrmImportExample;
begin
  // First we create a form that will hold the data we are attempting to import.
  frmImportExample:= TfrmImportExample.Create(nil);
  try
    // We set the frmImportExample.CurrentModelHandle so that Argus ONE can
    // respond to the form being moved by repainting.
    frmImportExample.CurrentModelHandle := aneHandle;
    // We show the form and if the user presses the OK button,
    // attempt to import the data.
    if frmImportExample.ShowModal = mrOK then
    begin
      // Get a string containing the contours to import.
      ImportText := frmImportExample.Memo1.Lines.Text;

      // Argus ONE doesn't like the carriage return key (#13) when separating
      // individual lines within the text that is imported.  Therefore,
      // get rid of them.
      for Index := Length(ImportText) downto 1 do
      begin
        if ImportText[Index] = #13 then
        begin
          Delete(ImportText, Index, 1);
        end;
      end;

      // Import text into Argus ONE.
      // ANE_ImportTextToLayerByHandle is defined in ANECB.pas.
      ANE_ImportTextToLayerByHandle(aneHandle,layerHandle, PChar(ImportText));
    end;
  finally
    // Clean up be getting rid of the form.
    frmImportExample.Free;
  end;
end;

// There are 3 PIEs in this dll.
const
  kMaxFunDesc = 3;   
  
// Create an array of ANEPIEDescPtr.  This array will be pased to Argus ONE
// in GetANEFunctions after it has been filled.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  // initialize the number of PIEs.
  numNames := 0;

  g_E_FDesc.name := 'Ex';	        // name of function
  g_E_FDesc.address := @GetE;		// function address
  g_E_FDesc.returnType := kPIEFloat;		// return value type
  g_E_FDesc.numParams :=  1;			// number of parameters
  g_E_FDesc.numOptParams := 0;			// number of optional parameters
  g_E_FDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  g_E_FDesc.paramTypes := @gOneDoubleTypes;	// pointer to parameters types list
  g_E_FDesc.version := FUNCTION_PIE_VERSION; // A constant.
  g_E_FDesc.functionFlags := 0; // No function flags in this case.

  g_E_PIEDesc.name  := 'Ex';		// name of PIE
  g_E_PIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  g_E_PIEDesc.descriptor := @g_E_FDesc;	// pointer to descriptor
  // version, vendor, and product can be ignored.

  Assert (numNames < kMaxFunDesc); // Make sure the number of PIEs isn't too high.
  gFunDesc[numNames] := @g_E_PIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of PIEs
  
  g_Average_InterpDesc.version := INTERPOLATION_PIE_VERSION; // A constant
  g_Average_InterpDesc.name := 'Average'; // the name of the interpolation method.
  g_Average_InterpDesc.interpolationFlags :=
    kInterpolationCallPre or kInterpolationShouldClean; // Tell Argus ONE that we are using preProc and cleanProc
  g_Average_InterpDesc.preProc := @InitializeAverage;		// procedure address of the initialization procedure.
  g_Average_InterpDesc.evalProc := @EvaluateAverage;		// procedure address of the evaluation procedure.
  g_Average_InterpDesc.cleanProc :=  @FreeAverage;			// procedure address of the clean up procedure.
  g_Average_InterpDesc.neededProject := nil;	// If this method is only available in one type of project, give its name.

  g_Average_PIEDesc.name  := 'Average';		// name of PIE
  g_Average_PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: Interpolation
  g_Average_PIEDesc.descriptor := @g_Average_InterpDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc); // Make sure the number of PIEs isn't too high.
  gFunDesc[numNames] := @g_Average_PIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of PIEs

  // We do one thing a little weird here.  We have the user select a layer
  // and import contours into it.  However, the layer into which the contours
  // are imported is the "from" layer instead of the "to" layer.
  g_SimpleImport_IDesc.version := IMPORT_PIE_VERSION; // a constant.
  g_SimpleImport_IDesc.name := 'Simple Import...';   // name of import method
  g_SimpleImport_IDesc.importFlags := kImportFromLayer; // Have the user select a layer into which the data will be imported.
  g_SimpleImport_IDesc.fromLayerTypes := kPIEInformationLayer or kPIEMapsLayer or kPIEDomainLayer;
  g_SimpleImport_IDesc.toLayerTypes := kPIEAnyLayer;
  g_SimpleImport_IDesc.doImportProc := @G_SimpleImport;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  g_SimpleImport_PIEDesc.name := 'Simple Import...';  // PIE name
  g_SimpleImport_PIEDesc.PieType := kImportPIE;       // PIE type: Import PIE
  g_SimpleImport_PIEDesc.descriptor := @g_SimpleImport_IDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc); // Make sure the number of PIEs isn't too high.
  gFunDesc[numNames] := @g_SimpleImport_PIEDesc; // add descriptor to list
  Inc(numNames);	// increment number of PIEs

  // Tell Argus ONE what the PIE functions are.
  descriptors := @gFunDesc;
end;

end.
