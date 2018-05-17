unit ModflowPIEFunctions;

interface

{ModflowPIEFunctions contains a function that adds PIE descriptors to the
 array of descriptors passed to Argus ONE.}

uses
  Windows, ProjectPIE, AnePIE, Forms, sysutils, Controls, classes, Dialogs;

procedure GetMODFLOWFunctions(const Project, Vendor, Product: ANE_STR; var
  numNames: ANE_INT32);

implementation

uses GetANEFunctionsUnit, MODFLOWPieDescriptors, ProjectFunctions,
  FunctionPIE, ImportPIE, MOC3DGridFunctions, ModflowTimeFunctions,
  ParamNamesAndTypes, ModflowLayerFunctions, MOC3DUnitFunctions,
  MOC3DParticleFunctions, ExportTemplatePIE, RunUnit, PostMODFLOWPieUnit,
  MODFLOW_FHBFunctions, MODPATHFunctionsUnit, HFBDisplay,
  ZoneBudgetFunctions, ModflowHelp, mpathplotUnit, WellDataUnit,
  CheckPIEVersionFunction, GetLayerUnit, PackageFunctions,
  WriteModflowFilesUnit, UnitNumbers, WriteGageUnit, LinkUnits,
  WriteMT3DUnit, frmContourImporterUnit, ModflowUnit, InternetConnection,
  VersInfo, UtilityFunctions, frmLinkStreamUnit;

procedure CheckInternetForNewerVersion(Handle: HWnd);
const
  VersionURL = 'http://water.usgs.gov/nrp/gwsoftware/mfgui4/Version.txt';
var
  Lines: TStringList;
  InternetVersion: string;
  VersionInPie: string;
  VersionInfo: TVersionInfo;
  IniFileName: string;
  TheIniFile: TStringList;
  Index: integer;
  DateString: string;
  FoundDate: boolean;
  DateIndex: integer;
  ShouldCheckInternet: boolean;
  FoundFrequency: boolean;
  FrequencyString: string;
  Frequency: integer;
begin
  // First read from the ini file when it was that you last
  // checked the version on the web.

  // Open the file.
  IniFileName := IniFile(Handle);
  if FileExists(IniFileName) then
  begin
    try
      TheIniFile := TStringList.Create;
      try
        FoundDate := False;
        FoundFrequency := False;
        DateString := '';
        DateIndex := -1;
        Frequency := -1;
        // Open the ini file.
        TheIniFile.LoadFromFile(IniFileName);
        for Index := 0 to TheIniFile.Count - 1 do
        begin
          if TheIniFile[Index] = 'edCheckDate' then
          begin
            // get the time when you last checked the internet.
            if Index + 1 < TheIniFile.Count then
            begin
              DateString := TheIniFile[Index + 1];
              DateIndex := Index + 1;
              FoundDate := True;
            end
            else
            begin
              // The program would only get here if a person
              // manually changed the .ini file.
              TheIniFile.Delete(Index);
            end;
            break;
          end;
          // Find out how frequently you should check the internet version.
          if TheIniFile[Index] = 'rgUpdateFrequency' then
          begin
            if Index + 1 < TheIniFile.Count then
            begin
              FrequencyString := TheIniFile[Index + 1];
              FoundFrequency := True;
              try
                Frequency := StrToInt(FrequencyString);
              except on EConvertError do
                begin
                  Frequency := -1;
                end;
              end;

              // Get the frequency (in days).
              case Frequency of
                0:
                  begin
                    Frequency := 1;
                  end;
                1:
                  begin
                    Frequency := 7;
                  end;
                2:
                  begin
                    Frequency := 30;
                  end;
                3:
                  begin
                    Frequency := -1;
                  end;
              else
                Frequency := -1;
              end;
            end
            else
            begin
              // The program would only get here if the .ini
              // file is changed manually.
              TheIniFile.Delete(Index);
            end;
          end;

        end;

        // If the data was not found, this is the first time that
        // the PIE has checked the internet date.  This must be a
        // new version on this computer so it is almost certainly
        // up-to-date.
        if not FoundDate then
        begin
          TheIniFile.Add('edCheckDate');
          TheIniFile.Add(FloatToStr(Now));
          try
            TheIniFile.SaveToFile(IniFileName);
          except
            // ignore
          end;
        end;

        // For some reason the date isn't stored so store it now.
        if FoundDate and (DateString = '') then
        begin
          TheIniFile[DateIndex] := FloatToStr(Now);
          try
            TheIniFile.SaveToFile(IniFileName);
          except
            // ignore
          end;
        end;

        // Figure out whether you should check the internet for a new version.
        try
          ShouldCheckInternet := FoundDate and (DateString <> '')
            and FoundFrequency and (Frequency > 0) and
            (Now - InternationalStrToFloat(DateString) > Frequency);
        except on EConvertError do
          begin
            ShouldCheckInternet := True;
            // ignore
          end;
        end;

        // Ask the user if the PIE should check the internet.
        if ShouldCheckInternet then
        begin
          Beep;
          if (MessageDlg('Would you like to check the Internet to see if '
            + 'an updated version of the MODFLOW GUI is available?',
            mtInformation, [mbYes, mbNo], 0) = mrYes) then
          begin
            // Get the version of the PIE.
            VersionInfo := TVersionInfo.Create(nil);
            try
              VersionInfo.FileName := GetDLLName;
              VersionInPie := VersionInfo.FileVersion;

              // Get the version on the internet.
              Lines := TStringList.Create;
              try
                if ReadInternetFile(VersionURL, Lines) then
                begin
                  if Lines.Count > 0 then
                  begin
                    InternetVersion := Lines[0];
                    // compare the PIE version number and internet version
                    // number.  Inform the user of the result.
                    if TfrmMODFLOW.PieIsEarlier(InternetVersion, VersionInPie,
                      False) then
                    begin
                      Beep;
                      MessageDlg('There is now a newer version of the '
                        + 'MODFLOW GUI available on the MODFLOW GUI web page.',
                        mtInformation, [mbOK], 0);
                    end
                    else
                    begin
                      Beep;
                      ShowMessage(
                        'Your version of the MODFLOW GUI is up-to-date');
                    end;
                  end;

                  // save the date that you checked the internet.
                  if FoundDate then
                  begin
                    TheIniFile[DateIndex] := FloatToStr(Now);
                    try
                      TheIniFile.SaveToFile(IniFileName);
                    except
                      // ignore
                    end;
                  end;
                end;
              finally
                Lines.Free;
              end;
            finally
              VersionInfo.Free;
            end;

          end;
        end;
      finally
        TheIniFile.Free;
      end;
    except on E: Exception do
      begin
        // generic error handling.
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  end;
end;

procedure GetMODFLOWFunctions(const Project, Vendor, Product: ANE_STR;
  var numNames: ANE_INT32);
var
  UsualOptions: EFunctionPIEFlags;
  Form: TForm;
begin
  Form := TForm.CreateNew(nil, 0);
  try
    CheckInternetForNewerVersion(Form.Handle);
  finally
    Form.Free;
  end;

//  CheckInternetForNewerVersion;

  UsualOptions := kFunctionNeedsProject or kFunctionIsHidden;
  //  UsualOptions := kFunctionNeedsProject;

  numNames := 0;

{$ASSERTIONS ON}
  {Assertions are a debugging tool. They can be turned off
  in the final version. See Delphi help for more information.}

  //MODFLOW Project
  gMODFLOWProjectPDesc.version := PROJECT_PIE_VERSION;
  gMODFLOWProjectPDesc.name := Project;
  gMODFLOWProjectPDesc.projectFlags := kProjectCanEdit or
    kProjectShouldClean or
    kProjectShouldSave;
  gMODFLOWProjectPDesc.createNewProc := GProjectNew;
  gMODFLOWProjectPDesc.editProjectProc := GEditForm;
  gMODFLOWProjectPDesc.cleanProjectProc := GClearForm;
  gMODFLOWProjectPDesc.saveProc := GSaveForm;
  gMODFLOWProjectPDesc.loadProc := GLoadForm;

  gMODFLOWPieDesc.name := '&New MODFLOW Project';
  gMODFLOWPieDesc.PieType := kProjectPIE;
  gMODFLOWPieDesc.descriptor := @gMODFLOWProjectPDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMODFLOWPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // MOCROW1 Pie descriptor
  gMocRow1FunctionDesc.version := FUNCTION_PIE_VERSION; // Function PIE verions
  gMocRow1FunctionDesc.functionFlags := UsualOptions; // Function options
  gMocRow1FunctionDesc.name := MOCROW1; // Function name
  gMocRow1FunctionDesc.address := GetMocRow1; // Function address
  gMocRow1FunctionDesc.returnType := kPIEInteger; // return type
  gMocRow1FunctionDesc.numParams := 0; // number of parameters;
  gMocRow1FunctionDesc.numOptParams := 2; // number of optional parameters;
  gMocRow1FunctionDesc.paramNames := @gpnColumnRow; // paramter names
  gMocRow1FunctionDesc.paramTypes := @gTwoIntegerTypes; // parameter types
  gMocRow1FunctionDesc.neededProject := Project; // needed project

  gMocRow1PieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMocRow1PieDesc.vendor := Vendor; // vendor
  gMocRow1PieDesc.product := Product; // product
  gMocRow1PieDesc.name := MOCROW1; // function name
  gMocRow1PieDesc.PieType := kFunctionPIE; // Pie type
  gMocRow1PieDesc.descriptor := @gMocRow1FunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMocRow1PieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // MOCROW2 Pie descriptor
  gMocRow2FunctionDesc.version := FUNCTION_PIE_VERSION; // Function PIE verions
  gMocRow2FunctionDesc.functionFlags := UsualOptions; // Function options
  gMocRow2FunctionDesc.name := MOCROW2; // Function name
  gMocRow2FunctionDesc.address := GetMocRow2; // Function address
  gMocRow2FunctionDesc.returnType := kPIEInteger; // return type
  gMocRow2FunctionDesc.numParams := 0; // number of parameters;
  gMocRow2FunctionDesc.numOptParams := 2; // number of optional parameters;
  gMocRow2FunctionDesc.paramNames := @gpnColumnRow; // paramter names
  gMocRow2FunctionDesc.paramTypes := @gTwoIntegerTypes; // parameter types
  gMocRow2FunctionDesc.neededProject := Project; // needed project

  gMocRow2PieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMocRow2PieDesc.vendor := Vendor; // vendor
  gMocRow2PieDesc.product := Product; // product
  gMocRow2PieDesc.name := MOCROW2; // function name
  gMocRow2PieDesc.PieType := kFunctionPIE; // Pie type
  gMocRow2PieDesc.descriptor := @gMocRow2FunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMocRow2PieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // MOCROW1 Pie descriptor
  gMocCol1FunctionDesc.version := FUNCTION_PIE_VERSION; // Function PIE verions
  gMocCol1FunctionDesc.functionFlags := UsualOptions; // Function options
  gMocCol1FunctionDesc.name := MOCCOL1; // Function name
  gMocCol1FunctionDesc.address := GetMocCol1; // Function address
  gMocCol1FunctionDesc.returnType := kPIEInteger; // return type
  gMocCol1FunctionDesc.numParams := 0; // number of parameters;
  gMocCol1FunctionDesc.numOptParams := 2; // number of optional parameters;
  gMocCol1FunctionDesc.paramNames := @gpnColumnRow; // paramter names
  gMocCol1FunctionDesc.paramTypes := @gTwoIntegerTypes; // parameter types
  gMocCol1FunctionDesc.neededProject := Project; // needed project

  gMocCol1PieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMocCol1PieDesc.vendor := Vendor; // vendor
  gMocCol1PieDesc.product := Product; // product
  gMocCol1PieDesc.name := MOCCOL1; // function name
  gMocCol1PieDesc.PieType := kFunctionPIE; // Pie type
  gMocCol1PieDesc.descriptor := @gMocCol1FunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMocCol1PieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // MOCROW2 Pie descriptor
  gMocCol2FunctionDesc.version := FUNCTION_PIE_VERSION; // Function PIE verions
  gMocCol2FunctionDesc.functionFlags := UsualOptions; // Function options
  gMocCol2FunctionDesc.name := MOCCOL2; // Function name
  gMocCol2FunctionDesc.address := GetMocCol2; // Function address
  gMocCol2FunctionDesc.returnType := kPIEInteger; // return type
  gMocCol2FunctionDesc.numParams := 0; // number of parameters;
  gMocCol2FunctionDesc.numOptParams := 2; // number of optional parameters;
  gMocCol2FunctionDesc.paramNames := @gpnColumnRow; // paramter names
  gMocCol2FunctionDesc.paramTypes := @gTwoIntegerTypes; // parameter types
  gMocCol2FunctionDesc.neededProject := Project; // needed project

  gMocCol2PieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMocCol2PieDesc.vendor := Vendor; // vendor
  gMocCol2PieDesc.product := Product; // product
  gMocCol2PieDesc.name := MOCCOL2; // function name
  gMocCol2PieDesc.PieType := kFunctionPIE; // Pie type
  gMocCol2PieDesc.descriptor := @gMocCol2FunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMocCol2PieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Number of periods Pie descriptor
  gMFGetNumPerFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetNumPerFunctionDesc.functionFlags := kFunctionNeedsProject;
  // Function options
  gMFGetNumPerFunctionDesc.name := 'MODFLOW_NPER'; // Function name
  gMFGetNumPerFunctionDesc.address := GetNumPer; // Function address
  gMFGetNumPerFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetNumPerFunctionDesc.numParams := 0; // number of parameters;
  gMFGetNumPerFunctionDesc.numOptParams := 0; // number of optional parameters;
  gMFGetNumPerFunctionDesc.paramNames := nil; // paramter names
  gMFGetNumPerFunctionDesc.paramTypes := nil; // parameter types
  gMFGetNumPerFunctionDesc.neededProject := Project; // needed project

  gMFGetNumPerPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetNumPerPieDesc.vendor := Vendor; // vendor
  gMFGetNumPerPieDesc.product := Product; // product
  gMFGetNumPerPieDesc.name := 'MODFLOW_NPER'; // function name
  gMFGetNumPerPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetNumPerPieDesc.descriptor := @gMFGetNumPerFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetNumPerPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Period length Pie descriptor
  gMFGetPerLengthFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetPerLengthFunctionDesc.functionFlags := UsualOptions; // Function options
  gMFGetPerLengthFunctionDesc.name := 'MODFLOW_PERLEN'; // Function name
  gMFGetPerLengthFunctionDesc.address := GetPerLength; // Function address
  gMFGetPerLengthFunctionDesc.returnType := kPIEFloat; // return type
  gMFGetPerLengthFunctionDesc.numParams := 1; // number of parameters;
  gMFGetPerLengthFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetPerLengthFunctionDesc.paramNames := @gpnPeriod; // paramter names
  gMFGetPerLengthFunctionDesc.paramTypes := @gOneIntegerTypes; // parameter types
  gMFGetPerLengthFunctionDesc.neededProject := Project; // needed project

  gMFGetPerLengthPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetPerLengthPieDesc.vendor := Vendor; // vendor
  gMFGetPerLengthPieDesc.product := Product; // product
  gMFGetPerLengthPieDesc.name := 'MODFLOW_PERLEN'; // function name
  gMFGetPerLengthPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetPerLengthPieDesc.descriptor := @gMFGetPerLengthFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetPerLengthPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // number of steps in Period Pie descriptor
  gMFGetPerStepsFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetPerStepsFunctionDesc.functionFlags := UsualOptions; // Function options
  gMFGetPerStepsFunctionDesc.name := 'MODFLOW_NSTP'; // Function name
  gMFGetPerStepsFunctionDesc.address := GetPerSteps; // Function address
  gMFGetPerStepsFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetPerStepsFunctionDesc.numParams := 1; // number of parameters;
  gMFGetPerStepsFunctionDesc.numOptParams := 0; // number of optional parameters;
  gMFGetPerStepsFunctionDesc.paramNames := @gpnPeriod; // paramter names
  gMFGetPerStepsFunctionDesc.paramTypes := @gOneIntegerTypes; // parameter types
  gMFGetPerStepsFunctionDesc.neededProject := Project; // needed project

  gMFGetPerStepsPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetPerStepsPieDesc.vendor := Vendor; // vendor
  gMFGetPerStepsPieDesc.product := Product; // product
  gMFGetPerStepsPieDesc.name := 'MODFLOW_NSTP'; // function name
  gMFGetPerStepsPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetPerStepsPieDesc.descriptor := @gMFGetPerStepsFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetPerStepsPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // time step multiplier Pie descriptor
  gMFGetTimeStepMultFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetTimeStepMultFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetTimeStepMultFunctionDesc.name := 'MODFLOW_TSMULT'; // Function name
  gMFGetTimeStepMultFunctionDesc.address := GetTimeStepMult; // Function address
  gMFGetTimeStepMultFunctionDesc.returnType := kPIEFloat; // return type
  gMFGetTimeStepMultFunctionDesc.numParams := 1; // number of parameters;
  gMFGetTimeStepMultFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetTimeStepMultFunctionDesc.paramNames := @gpnPeriod; // paramter names
  gMFGetTimeStepMultFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetTimeStepMultFunctionDesc.neededProject := Project; // needed project

  gMFGetTimeStepMultPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetTimeStepMultPieDesc.vendor := Vendor; // vendor
  gMFGetTimeStepMultPieDesc.product := Product; // product
  gMFGetTimeStepMultPieDesc.name := 'MODFLOW_TSMULT'; // function name
  gMFGetTimeStepMultPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetTimeStepMultPieDesc.descriptor := @gMFGetTimeStepMultFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetTimeStepMultPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // number of geologic units PIE descriptor
  gMFGetNumUnitsFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetNumUnitsFunctionDesc.functionFlags := kFunctionNeedsProject;
  // Function options
  gMFGetNumUnitsFunctionDesc.name := 'MODFLOW_NLAY'; // Function name
  gMFGetNumUnitsFunctionDesc.address := GetNumUnits; // Function address
  gMFGetNumUnitsFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetNumUnitsFunctionDesc.numParams := 0; // number of parameters;
  gMFGetNumUnitsFunctionDesc.numOptParams := 0; // number of optional parameters;
  gMFGetNumUnitsFunctionDesc.paramNames := nil; // paramter names
  gMFGetNumUnitsFunctionDesc.paramTypes := nil; // parameter types
  gMFGetNumUnitsFunctionDesc.neededProject := Project; // needed project

  gMFGetNumUnitsPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetNumUnitsPieDesc.vendor := Vendor; // vendor
  gMFGetNumUnitsPieDesc.product := Product; // product
  gMFGetNumUnitsPieDesc.name := 'MODFLOW_NLAY'; // function name
  gMFGetNumUnitsPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetNumUnitsPieDesc.descriptor := @gMFGetNumUnitsFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetNumUnitsPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // anisotropy Pie descriptor
  gMFGetAnisotropyFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetAnisotropyFunctionDesc.functionFlags := UsualOptions; // Function options
  gMFGetAnisotropyFunctionDesc.name := 'MODFLOW_TRPY'; // Function name
  gMFGetAnisotropyFunctionDesc.address := GetAnisotropy; // Function address
  gMFGetAnisotropyFunctionDesc.returnType := kPIEFloat; // return type
  gMFGetAnisotropyFunctionDesc.numParams := 1; // number of parameters;
  gMFGetAnisotropyFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetAnisotropyFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetAnisotropyFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetAnisotropyFunctionDesc.neededProject := Project; // needed project

  gMFGetAnisotropyPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetAnisotropyPieDesc.vendor := Vendor; // vendor
  gMFGetAnisotropyPieDesc.product := Product; // product
  gMFGetAnisotropyPieDesc.name := 'MODFLOW_TRPY'; // function name
  gMFGetAnisotropyPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetAnisotropyPieDesc.descriptor := @gMFGetAnisotropyFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetAnisotropyPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Unit Simulated Pie descriptor
  gMFGetUnitSimulatedFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetUnitSimulatedFunctionDesc.functionFlags := kFunctionNeedsProject;
  // Function options
  gMFGetUnitSimulatedFunctionDesc.name := 'MODFLOW_SIMUL'; // Function name
  gMFGetUnitSimulatedFunctionDesc.address := GetUnitSimulated;
  // Function address
  gMFGetUnitSimulatedFunctionDesc.returnType := kPIEBoolean; // return type
  gMFGetUnitSimulatedFunctionDesc.numParams := 1; // number of parameters;
  gMFGetUnitSimulatedFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetUnitSimulatedFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetUnitSimulatedFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetUnitSimulatedFunctionDesc.neededProject := Project; // needed project

  gMFGetUnitSimulatedPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetUnitSimulatedPieDesc.vendor := Vendor; // vendor
  gMFGetUnitSimulatedPieDesc.product := Product; // product
  gMFGetUnitSimulatedPieDesc.name := 'MODFLOW_SIMUL'; // function name
  gMFGetUnitSimulatedPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetUnitSimulatedPieDesc.descriptor := @gMFGetUnitSimulatedFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetUnitSimulatedPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get method of averaging transmissivity
  gMFGetUnitAvgMethFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetUnitAvgMethFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetUnitAvgMethFunctionDesc.name := 'MODFLOW_AVEMETHOD'; // Function name
  gMFGetUnitAvgMethFunctionDesc.address := GetLayerAveragingMethod;
  // Function address
  gMFGetUnitAvgMethFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetUnitAvgMethFunctionDesc.numParams := 1; // number of parameters;
  gMFGetUnitAvgMethFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetUnitAvgMethFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetUnitAvgMethFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetUnitAvgMethFunctionDesc.neededProject := Project; // needed project

  gMFGetUnitAvgMethPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetUnitAvgMethPieDesc.vendor := Vendor; // vendor
  gMFGetUnitAvgMethPieDesc.product := Product; // product
  gMFGetUnitAvgMethPieDesc.name := 'MODFLOW_AVEMETHOD'; // function name
  gMFGetUnitAvgMethPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetUnitAvgMethPieDesc.descriptor := @gMFGetUnitAvgMethFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetUnitAvgMethPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get layer type
  gMFGetLayerTypeFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetLayerTypeFunctionDesc.functionFlags := kFunctionNeedsProject;
  // Function options
  gMFGetLayerTypeFunctionDesc.name := 'MODFLOW_LAYCON'; // Function name
  gMFGetLayerTypeFunctionDesc.address := GetLayerType; // Function address
  gMFGetLayerTypeFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetLayerTypeFunctionDesc.numParams := 1; // number of parameters;
  gMFGetLayerTypeFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetLayerTypeFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetLayerTypeFunctionDesc.paramTypes := @gOneIntegerTypes; // parameter types
  gMFGetLayerTypeFunctionDesc.neededProject := Project; // needed project

  gMFGetLayerTypePieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetLayerTypePieDesc.vendor := Vendor; // vendor
  gMFGetLayerTypePieDesc.product := Product; // product
  gMFGetLayerTypePieDesc.name := 'MODFLOW_LAYCON'; // function name
  gMFGetLayerTypePieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetLayerTypePieDesc.descriptor := @gMFGetLayerTypeFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetLayerTypePieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get vertical discretization
  gMFGetVerticalDiscrFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetVerticalDiscrFunctionDesc.functionFlags := kFunctionNeedsProject;
  // Function options
  gMFGetVerticalDiscrFunctionDesc.name := 'MODFLOW_NDIV'; // Function name
  gMFGetVerticalDiscrFunctionDesc.address := GetLayerDiscretization;
  // Function address
  gMFGetVerticalDiscrFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetVerticalDiscrFunctionDesc.numParams := 1; // number of parameters;
  gMFGetVerticalDiscrFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetVerticalDiscrFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetVerticalDiscrFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetVerticalDiscrFunctionDesc.neededProject := Project; // needed project

  gMFGetVerticalDiscrPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetVerticalDiscrPieDesc.vendor := Vendor; // vendor
  gMFGetVerticalDiscrPieDesc.product := Product; // product
  gMFGetVerticalDiscrPieDesc.name := 'MODFLOW_NDIV'; // function name
  gMFGetVerticalDiscrPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetVerticalDiscrPieDesc.descriptor := @gMFGetVerticalDiscrFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetVerticalDiscrPieDesc; // add descriptor to list
  Inc(numNames);

  // Unit uses transmissivity Pie descriptor
  gMFGetUnitUsesTransFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetUnitUsesTransFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetUnitUsesTransFunctionDesc.name := 'MODFLOW_SpecTrans'; // Function name
  gMFGetUnitUsesTransFunctionDesc.address := GetUseTrans; // Function address
  gMFGetUnitUsesTransFunctionDesc.returnType := kPIEBoolean; // return type
  gMFGetUnitUsesTransFunctionDesc.numParams := 1; // number of parameters;
  gMFGetUnitUsesTransFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetUnitUsesTransFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetUnitUsesTransFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetUnitUsesTransFunctionDesc.neededProject := Project; // needed project

  gMFGetUnitUsesTransPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetUnitUsesTransPieDesc.vendor := Vendor; // vendor
  gMFGetUnitUsesTransPieDesc.product := Product; // product
  gMFGetUnitUsesTransPieDesc.name := 'MODFLOW_SpecTrans'; // function name
  gMFGetUnitUsesTransPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetUnitUsesTransPieDesc.descriptor := @gMFGetUnitUsesTransFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetUnitUsesTransPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Unit uses VCONT Pie descriptor
  gMFGetUnitUsesVcontFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetUnitUsesVcontFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetUnitUsesVcontFunctionDesc.name := 'MODFLOW_SpecVcont'; // Function name
  gMFGetUnitUsesVcontFunctionDesc.address := GetUseVcont; // Function address
  gMFGetUnitUsesVcontFunctionDesc.returnType := kPIEBoolean; // return type
  gMFGetUnitUsesVcontFunctionDesc.numParams := 1; // number of parameters;
  gMFGetUnitUsesVcontFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetUnitUsesVcontFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetUnitUsesVcontFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetUnitUsesVcontFunctionDesc.neededProject := Project; // needed project

  gMFGetUnitUsesVcontPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetUnitUsesVcontPieDesc.vendor := Vendor; // vendor
  gMFGetUnitUsesVcontPieDesc.product := Product; // product
  gMFGetUnitUsesVcontPieDesc.name := 'MODFLOW_SpecVcont'; // function name
  gMFGetUnitUsesVcontPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetUnitUsesVcontPieDesc.descriptor := @gMFGetUnitUsesVcontFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetUnitUsesVcontPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Unit uses SP1 Pie descriptor
  gMFGetUnitUsesSF1FunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetUnitUsesSF1FunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetUnitUsesSF1FunctionDesc.name := 'MODFLOW_SpecSF1'; // Function name
  gMFGetUnitUsesSF1FunctionDesc.address := GetUseSF1; // Function address
  gMFGetUnitUsesSF1FunctionDesc.returnType := kPIEBoolean; // return type
  gMFGetUnitUsesSF1FunctionDesc.numParams := 1; // number of parameters;
  gMFGetUnitUsesSF1FunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetUnitUsesSF1FunctionDesc.paramNames := @gpnUnit; // paramter names
  gMFGetUnitUsesSF1FunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetUnitUsesSF1FunctionDesc.neededProject := Project; // needed project

  gMFGetUnitUsesSF1PieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetUnitUsesSF1PieDesc.vendor := Vendor; // vendor
  gMFGetUnitUsesSF1PieDesc.product := Product; // product
  gMFGetUnitUsesSF1PieDesc.name := 'MODFLOW_SpecSF1'; // function name
  gMFGetUnitUsesSF1PieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetUnitUsesSF1PieDesc.descriptor := @gMFGetUnitUsesSF1FunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetUnitUsesSF1PieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // increment number of names

// get MODFLOW Layer
  gMFGetMODFLOWLayerFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetMODFLOWLayerFunctionDesc.functionFlags := kFunctionNeedsProject;
  // Function options
  gMFGetMODFLOWLayerFunctionDesc.name := 'MODFLOW_Layer'; // Function name
  gMFGetMODFLOWLayerFunctionDesc.address := GetModflowLayer; // Function address
  gMFGetMODFLOWLayerFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetMODFLOWLayerFunctionDesc.numParams := 4; // number of parameters;
  gMFGetMODFLOWLayerFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetMODFLOWLayerFunctionDesc.paramNames := @gpnModflowLayerNames;
  // paramter names
  gMFGetMODFLOWLayerFunctionDesc.paramTypes := @g1Integer3RealTypes;
  // parameter types
  gMFGetMODFLOWLayerFunctionDesc.neededProject := Project; // needed project

  gMFGetMODFLOWLayerPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetMODFLOWLayerPieDesc.vendor := Vendor; // vendor
  gMFGetMODFLOWLayerPieDesc.product := Product; // product
  gMFGetMODFLOWLayerPieDesc.name := 'MODFLOW_Layer'; // function name
  gMFGetMODFLOWLayerPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetMODFLOWLayerPieDesc.descriptor := @gMFGetMODFLOWLayerFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetMODFLOWLayerPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get MOC longitudingal dispersion
  gMOCGetLongDispFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetLongDispFunctionDesc.functionFlags := UsualOptions; // Function options
  gMOCGetLongDispFunctionDesc.name := 'MODFLOW_MOC_ALONG'; // Function name
  gMOCGetLongDispFunctionDesc.address := GetMOCLongDisp; // Function address
  gMOCGetLongDispFunctionDesc.returnType := kPIEFloat; // return type
  gMOCGetLongDispFunctionDesc.numParams := 1; // number of parameters;
  gMOCGetLongDispFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetLongDispFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMOCGetLongDispFunctionDesc.paramTypes := @gOneIntegerTypes; // parameter types
  gMOCGetLongDispFunctionDesc.neededProject := Project; // needed project

  gMOCGetLongDispPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMOCGetLongDispPieDesc.vendor := Vendor; // vendor
  gMOCGetLongDispPieDesc.product := Product; // product
  gMOCGetLongDispPieDesc.name := 'MODFLOW_MOC_ALONG'; // function name
  gMOCGetLongDispPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetLongDispPieDesc.descriptor := @gMOCGetLongDispFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetLongDispPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get MOC transverse horizontal dispersion
  gMOCGetTransHorDispFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetTransHorDispFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMOCGetTransHorDispFunctionDesc.name := 'MODFLOW_MOC_ATRANH'; // Function name
  gMOCGetTransHorDispFunctionDesc.address := GetMOCTransHorDisp;
  // Function address
  gMOCGetTransHorDispFunctionDesc.returnType := kPIEFloat; // return type
  gMOCGetTransHorDispFunctionDesc.numParams := 1; // number of parameters;
  gMOCGetTransHorDispFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetTransHorDispFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMOCGetTransHorDispFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMOCGetTransHorDispFunctionDesc.neededProject := Project; // needed project

  gMOCGetTransHorDispPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMOCGetTransHorDispPieDesc.vendor := Vendor; // vendor
  gMOCGetTransHorDispPieDesc.product := Product; // product
  gMOCGetTransHorDispPieDesc.name := 'MODFLOW_MOC_ATRANH'; // function name
  gMOCGetTransHorDispPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetTransHorDispPieDesc.descriptor := @gMOCGetTransHorDispFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetTransHorDispPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get MOC transverse horizontal dispersion
  gMOCGetTransVertDispFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetTransVertDispFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMOCGetTransVertDispFunctionDesc.name := 'MODFLOW_MOC_ATRANV'; // Function name
  gMOCGetTransVertDispFunctionDesc.address := GetMOCTransVerDisp;
  // Function address
  gMOCGetTransVertDispFunctionDesc.returnType := kPIEFloat; // return type
  gMOCGetTransVertDispFunctionDesc.numParams := 1; // number of parameters;
  gMOCGetTransVertDispFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetTransVertDispFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMOCGetTransVertDispFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMOCGetTransVertDispFunctionDesc.neededProject := Project; // needed project

  gMOCGetTransVertDispPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMOCGetTransVertDispPieDesc.vendor := Vendor; // vendor
  gMOCGetTransVertDispPieDesc.product := Product; // product
  gMOCGetTransVertDispPieDesc.name := 'MODFLOW_MOC_ATRANV'; // function name
  gMOCGetTransVertDispPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetTransVertDispPieDesc.descriptor := @gMOCGetTransVertDispFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetTransVertDispPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get MOC retardation factor
  gMOCGetRetardationFactorFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetRetardationFactorFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMOCGetRetardationFactorFunctionDesc.name := 'MODFLOW_MOC_RF'; // Function name
  gMOCGetRetardationFactorFunctionDesc.address := GetMOCRetardation;
  // Function address
  gMOCGetRetardationFactorFunctionDesc.returnType := kPIEFloat; // return type
  gMOCGetRetardationFactorFunctionDesc.numParams := 1; // number of parameters;
  gMOCGetRetardationFactorFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetRetardationFactorFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMOCGetRetardationFactorFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMOCGetRetardationFactorFunctionDesc.neededProject := Project;
  // needed project

  gMOCGetRetardationFactorPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMOCGetRetardationFactorPieDesc.vendor := Vendor; // vendor
  gMOCGetRetardationFactorPieDesc.product := Product; // product
  gMOCGetRetardationFactorPieDesc.name := 'MODFLOW_MOC_RF'; // function name
  gMOCGetRetardationFactorPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetRetardationFactorPieDesc.descriptor :=
    @gMOCGetRetardationFactorFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetRetardationFactorPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // get MOC C' Bound
  gMOCGetCBoundFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetCBoundFunctionDesc.functionFlags := UsualOptions; // Function options
  gMOCGetCBoundFunctionDesc.name := 'MODFLOW_MOC_CINFL'; // Function name
  gMOCGetCBoundFunctionDesc.address := GetMOCCBound; // Function address
  gMOCGetCBoundFunctionDesc.returnType := kPIEFloat; // return type
  gMOCGetCBoundFunctionDesc.numParams := 1; // number of parameters;
  gMOCGetCBoundFunctionDesc.numOptParams := 0; // number of optional parameters;
  gMOCGetCBoundFunctionDesc.paramNames := @gpnUnit; // paramter names
  gMOCGetCBoundFunctionDesc.paramTypes := @gOneIntegerTypes; // parameter types
  gMOCGetCBoundFunctionDesc.neededProject := Project; // needed project

  gMOCGetCBoundPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMOCGetCBoundPieDesc.vendor := Vendor; // vendor
  gMOCGetCBoundPieDesc.product := Product; // product
  gMOCGetCBoundPieDesc.name := 'MODFLOW_MOC_CINFL'; // function name
  gMOCGetCBoundPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetCBoundPieDesc.descriptor := @gMOCGetCBoundFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetCBoundPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // get Particle Layer Postion
  gMOCGetParticleLayerPositionFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetParticleLayerPositionFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMOCGetParticleLayerPositionFunctionDesc.name := 'MODFLOW_MOC_PNEWL';
  // Function name
  gMOCGetParticleLayerPositionFunctionDesc.address := GetParticleLayerPosition;
  // Function address
  gMOCGetParticleLayerPositionFunctionDesc.returnType := kPIEFloat;
  // return type
  gMOCGetParticleLayerPositionFunctionDesc.numParams := 1;
  // number of parameters;
  gMOCGetParticleLayerPositionFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetParticleLayerPositionFunctionDesc.paramNames := @gpnNumber;
  // paramter names
  gMOCGetParticleLayerPositionFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMOCGetParticleLayerPositionFunctionDesc.neededProject := Project;
  // needed project

  gMOCGetParticleLayerPositionPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMOCGetParticleLayerPositionPieDesc.vendor := Vendor; // vendor
  gMOCGetParticleLayerPositionPieDesc.product := Product; // product
  gMOCGetParticleLayerPositionPieDesc.name := 'MODFLOW_MOC_PNEWL';
  // function name
  gMOCGetParticleLayerPositionPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetParticleLayerPositionPieDesc.descriptor :=
    @gMOCGetParticleLayerPositionFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetParticleLayerPositionPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // get Particle Row Postion
  gMOCGetParticleRowPositionFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetParticleRowPositionFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMOCGetParticleRowPositionFunctionDesc.name := 'MODFLOW_MOC_PNEWR';
  // Function name
  gMOCGetParticleRowPositionFunctionDesc.address := GetParticleRowPosition;
  // Function address
  gMOCGetParticleRowPositionFunctionDesc.returnType := kPIEFloat; // return type
  gMOCGetParticleRowPositionFunctionDesc.numParams := 1; // number of parameters;
  gMOCGetParticleRowPositionFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetParticleRowPositionFunctionDesc.paramNames := @gpnNumber;
  // paramter names
  gMOCGetParticleRowPositionFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMOCGetParticleRowPositionFunctionDesc.neededProject := Project;
  // needed project

  gMOCGetParticleRowPositionPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMOCGetParticleRowPositionPieDesc.vendor := Vendor; // vendor
  gMOCGetParticleRowPositionPieDesc.product := Product; // product
  gMOCGetParticleRowPositionPieDesc.name := 'MODFLOW_MOC_PNEWR'; // function name
  gMOCGetParticleRowPositionPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetParticleRowPositionPieDesc.descriptor :=
    @gMOCGetParticleRowPositionFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetParticleRowPositionPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // get Particle Row Postion
  gMOCGetParticleColumnPositionFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMOCGetParticleColumnPositionFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMOCGetParticleColumnPositionFunctionDesc.name := 'MODFLOW_MOC_PNEWC';
  // Function name
  gMOCGetParticleColumnPositionFunctionDesc.address :=
    GetParticleColumnPosition;
  // Function address
  gMOCGetParticleColumnPositionFunctionDesc.returnType := kPIEFloat;
  // return type
  gMOCGetParticleColumnPositionFunctionDesc.numParams := 1;
  // number of parameters;
  gMOCGetParticleColumnPositionFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMOCGetParticleColumnPositionFunctionDesc.paramNames := @gpnNumber;
  // paramter names
  gMOCGetParticleColumnPositionFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMOCGetParticleColumnPositionFunctionDesc.neededProject := Project;
  // needed project

  gMOCGetParticleColumnPositionPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMOCGetParticleColumnPositionPieDesc.vendor := Vendor; // vendor
  gMOCGetParticleColumnPositionPieDesc.product := Product; // product
  gMOCGetParticleColumnPositionPieDesc.name := 'MODFLOW_MOC_PNEWC';
  // function name
  gMOCGetParticleColumnPositionPieDesc.PieType := kFunctionPIE; // Pie type
  gMOCGetParticleColumnPositionPieDesc.descriptor :=
    @gMOCGetParticleColumnPositionFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMOCGetParticleColumnPositionPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // Run Model
  gMFRunExportPIEDesc.name := 'Run &MODFLOW/Solute Transport...';
  gMFRunExportPIEDesc.exportType := kPIEGridLayer;
  gMFRunExportPIEDesc.exportFlags := kExportNeedsProject or
    kExportDontShowParamDialog or kExportDontShowFileDialog;
  gMFRunExportPIEDesc.getTemplateProc := RunModflowPIE;
  gMFRunExportPIEDesc.preExportProc := nil;
  gMFRunExportPIEDesc.postExportProc := nil;
  gMFRunExportPIEDesc.neededProject := Project;

  gMFRunPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFRunPIEDesc.vendor := Vendor; // vendor
  gMFRunPIEDesc.product := Product; // product
  gMFRunPIEDesc.name := 'Run &MODFLOW/Solute Transport...';
  gMFRunPIEDesc.PieType := kExportTemplatePIE;
  gMFRunPIEDesc.descriptor := @gMFRunExportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFRunPIEDesc;
  Inc(numNames); // add descriptor to list

  // Run MODPATH
  gMFRunMPATHExportPIEDesc.name := 'Run MOD&PATH...';
  gMFRunMPATHExportPIEDesc.exportType := kPIEGridLayer;
  gMFRunMPATHExportPIEDesc.exportFlags := kExportNeedsProject or
    kExportDontShowParamDialog or kExportDontShowFileDialog;
  gMFRunMPATHExportPIEDesc.getTemplateProc := RunModpathPIE;
  gMFRunMPATHExportPIEDesc.preExportProc := nil;
  gMFRunMPATHExportPIEDesc.postExportProc := nil;
  gMFRunMPATHExportPIEDesc.neededProject := Project;

  gMFRunMPATHPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFRunMPATHPIEDesc.vendor := Vendor; // vendor
  gMFRunMPATHPIEDesc.product := Product; // product
  gMFRunMPATHPIEDesc.name := 'Run MOD&PATH...';
  gMFRunMPATHPIEDesc.PieType := kExportTemplatePIE;
  gMFRunMPATHPIEDesc.descriptor := @gMFRunMPATHExportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFRunMPATHPIEDesc;
  Inc(numNames); // add descriptor to list

  // Run ZONEBUDGET
  gMFRunZonebdgtExportPIEDesc.name := 'Run &ZONEBUDGET...';
  gMFRunZonebdgtExportPIEDesc.exportType := kPIEGridLayer;
  gMFRunZonebdgtExportPIEDesc.exportFlags := kExportNeedsProject or
    kExportDontShowParamDialog or kExportDontShowFileDialog;
  gMFRunZonebdgtExportPIEDesc.getTemplateProc := RunZondbdgtPIE;
  gMFRunZonebdgtExportPIEDesc.preExportProc := nil;
  gMFRunZonebdgtExportPIEDesc.postExportProc := nil;
  gMFRunZonebdgtExportPIEDesc.neededProject := Project;

  gMFRunZonebdgtPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFRunZonebdgtPIEDesc.vendor := Vendor; // vendor
  gMFRunZonebdgtPIEDesc.product := Product; // product
  gMFRunZonebdgtPIEDesc.name := 'Run &ZONEBUDGET...';
  gMFRunZonebdgtPIEDesc.PieType := kExportTemplatePIE;
  gMFRunZonebdgtPIEDesc.descriptor := @gMFRunZonebdgtExportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFRunZonebdgtPIEDesc;
  Inc(numNames); // add descriptor to list

  // Run SEAWAT
  gMFRunSeawatExportPIEDesc.name := 'Run &SEAWAT...';
  gMFRunSeawatExportPIEDesc.exportType := kPIEGridLayer;
  gMFRunSeawatExportPIEDesc.exportFlags := kExportNeedsProject or
    kExportDontShowParamDialog or kExportDontShowFileDialog;
  gMFRunSeawatExportPIEDesc.getTemplateProc := RunSeawatPIE;
  gMFRunSeawatExportPIEDesc.preExportProc := nil;
  gMFRunSeawatExportPIEDesc.postExportProc := nil;
  gMFRunSeawatExportPIEDesc.neededProject := Project;

  gMFRunSeawatPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFRunSeawatPIEDesc.vendor := Vendor; // vendor
  gMFRunSeawatPIEDesc.product := Product; // product
  gMFRunSeawatPIEDesc.name := 'Run &SEAWAT...';
  gMFRunSeawatPIEDesc.PieType := kExportTemplatePIE;
  gMFRunSeawatPIEDesc.descriptor := @gMFRunSeawatExportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFRunSeawatPIEDesc;
  Inc(numNames); // add descriptor to list

  // Run SEAWAT
  gMFRunGWM_ExportPIEDesc.name := 'Run &GWM...';
  gMFRunGWM_ExportPIEDesc.exportType := kPIEGridLayer;
  gMFRunGWM_ExportPIEDesc.exportFlags := kExportNeedsProject or
    kExportDontShowParamDialog or kExportDontShowFileDialog;
  gMFRunGWM_ExportPIEDesc.getTemplateProc := RunGWM_PIE;
  gMFRunGWM_ExportPIEDesc.preExportProc := nil;
  gMFRunGWM_ExportPIEDesc.postExportProc := nil;
  gMFRunGWM_ExportPIEDesc.neededProject := Project;

  gMFRunGWM_PIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFRunGWM_PIEDesc.vendor := Vendor; // vendor
  gMFRunGWM_PIEDesc.product := Product; // product
  gMFRunGWM_PIEDesc.name := 'Run &GWM...';
  gMFRunGWM_PIEDesc.PieType := kExportTemplatePIE;
  gMFRunGWM_PIEDesc.descriptor := @gMFRunGWM_ExportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFRunGWM_PIEDesc;
  Inc(numNames); // add descriptor to list



  gMFPostImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFPostImportPIEDesc.name := 'MOD&FLOW/Solute-Transport Post-Processing...';
  gMFPostImportPIEDesc.importFlags := kImportAllwaysVisible or
    kImportNeedsProject;
  gMFPostImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFPostImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
  gMFPostImportPIEDesc.doImportProc := GPostProcessingPIE;
  gMFPostImportPIEDesc.neededProject := Project;

  gMFPostPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFPostPIEDesc.vendor := Vendor; // vendor
  gMFPostPIEDesc.product := Product; // product
  gMFPostPIEDesc.name := 'MOD&FLOW/Solute-Transport Post-Processing...';
  gMFPostPIEDesc.PieType := kImportPIE;
  gMFPostPIEDesc.descriptor := @gMFPostImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFPostPIEDesc;
  Inc(numNames); // add descriptor to list

  // Period length Pie descriptor
  gMFGetFHBTimeFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetFHBTimeFunctionDesc.functionFlags := UsualOptions; // Function options
  gMFGetFHBTimeFunctionDesc.name := 'MODFLOW_FHB_Time'; // Function name
  gMFGetFHBTimeFunctionDesc.address := GetMF_FHBTime; // Function address
  gMFGetFHBTimeFunctionDesc.returnType := kPIEFloat; // return type
  gMFGetFHBTimeFunctionDesc.numParams := 1; // number of parameters;
  gMFGetFHBTimeFunctionDesc.numOptParams := 0; // number of optional parameters;
  gMFGetFHBTimeFunctionDesc.paramNames := @gpnPeriod; // paramter names
  gMFGetFHBTimeFunctionDesc.paramTypes := @gOneIntegerTypes; // parameter types
  gMFGetFHBTimeFunctionDesc.neededProject := Project; // needed project

  gMFGetFHBTimePieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetFHBTimePieDesc.vendor := Vendor; // vendor
  gMFGetFHBTimePieDesc.product := Product; // product
  gMFGetFHBTimePieDesc.name := 'MODFLOW_FHB_Time'; // function name
  gMFGetFHBTimePieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetFHBTimePieDesc.descriptor := @gMFGetFHBTimeFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetFHBTimePieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // MODPATH Times
  gMFGetMODPATHTimeFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetMODPATHTimeFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetMODPATHTimeFunctionDesc.name := 'MODFLOW_ModpathTime'; // Function name
  gMFGetMODPATHTimeFunctionDesc.address := GetMODPATHTime; // Function address
  gMFGetMODPATHTimeFunctionDesc.returnType := kPIEFloat; // return type
  gMFGetMODPATHTimeFunctionDesc.numParams := 1; // number of parameters;
  gMFGetMODPATHTimeFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetMODPATHTimeFunctionDesc.paramNames := @gpnTimeIndex; // paramter names
  gMFGetMODPATHTimeFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetMODPATHTimeFunctionDesc.neededProject := Project; // needed project

  gMFGetMODPATHTimePieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFGetMODPATHTimePieDesc.vendor := Vendor; // vendor
  gMFGetMODPATHTimePieDesc.product := Product; // product
  gMFGetMODPATHTimePieDesc.name := 'MODFLOW_ModpathTime'; // function name
  gMFGetMODPATHTimePieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetMODPATHTimePieDesc.descriptor := @gMFGetMODPATHTimeFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetMODPATHTimePieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // display HFB
  gMFDisplayHFBImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFDisplayHFBImportPIEDesc.name := '&Display Horizontal Flow Barriers';
  gMFDisplayHFBImportPIEDesc.importFlags := kImportAllwaysVisible or
    kImportNeedsProject;
  gMFDisplayHFBImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFDisplayHFBImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
  gMFDisplayHFBImportPIEDesc.doImportProc := GDisplayHFBPIE;
  gMFDisplayHFBImportPIEDesc.neededProject := Project;

  gMFDisplayHFBPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFDisplayHFBPIEDesc.vendor := Vendor; // vendor
  gMFDisplayHFBPIEDesc.product := Product; // product
  gMFDisplayHFBPIEDesc.name := '&Display Horizontal Flow Barriers';
  gMFDisplayHFBPIEDesc.PieType := kImportPIE;
  gMFDisplayHFBPIEDesc.descriptor := @gMFDisplayHFBImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFDisplayHFBPIEDesc;
  Inc(numNames); // add descriptor to list

  // Zonebud Time Count
  gMFGetZonebudTimeCountFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetZonebudTimeCountFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetZonebudTimeCountFunctionDesc.name := 'MODFLOW_ZonebudTimeCount';
  // Function name
  gMFGetZonebudTimeCountFunctionDesc.address := GetZoneBudTimeCount;
  // Function address
  gMFGetZonebudTimeCountFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetZonebudTimeCountFunctionDesc.numParams := 0; // number of parameters;
  gMFGetZonebudTimeCountFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetZonebudTimeCountFunctionDesc.paramNames := nil; // paramter names
  gMFGetZonebudTimeCountFunctionDesc.paramTypes := nil; // parameter types
  gMFGetZonebudTimeCountFunctionDesc.neededProject := Project; // needed project

  gMFGetZonebudTimeCountPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMFGetZonebudTimeCountPieDesc.vendor := Vendor; // vendor
  gMFGetZonebudTimeCountPieDesc.product := Product; // product
  gMFGetZonebudTimeCountPieDesc.name := 'MODFLOW_ZonebudTimeCount';
  // function name
  gMFGetZonebudTimeCountPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetZonebudTimeCountPieDesc.descriptor :=
    @gMFGetZonebudTimeCountFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetZonebudTimeCountPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Zonebud Time Step
  gMFGetZonebudTimeStepFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetZonebudTimeStepFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetZonebudTimeStepFunctionDesc.name := 'MODFLOW_ZonebudTimeStep';
  // Function name
  gMFGetZonebudTimeStepFunctionDesc.address := GetZoneBudTimeStep;
  // Function address
  gMFGetZonebudTimeStepFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetZonebudTimeStepFunctionDesc.numParams := 1; // number of parameters;
  gMFGetZonebudTimeStepFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetZonebudTimeStepFunctionDesc.paramNames := @gpnTimeIndex;
  // paramter names
  gMFGetZonebudTimeStepFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetZonebudTimeStepFunctionDesc.neededProject := Project; // needed project

  gMFGetZonebudTimeStepPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMFGetZonebudTimeStepPieDesc.vendor := Vendor; // vendor
  gMFGetZonebudTimeStepPieDesc.product := Product; // product
  gMFGetZonebudTimeStepPieDesc.name := 'MODFLOW_ZonebudTimeStep';
  // function name
  gMFGetZonebudTimeStepPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetZonebudTimeStepPieDesc.descriptor := @gMFGetZonebudTimeStepFunctionDesc;
  // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetZonebudTimeStepPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Zonebud Stress Period
  gMFGetZonebudStessPeriodFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetZonebudStessPeriodFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetZonebudStessPeriodFunctionDesc.name := 'MODFLOW_ZonebudStessPeriod';
  // Function name
  gMFGetZonebudStessPeriodFunctionDesc.address := GetZoneBudStressPeriod;
  // Function address
  gMFGetZonebudStessPeriodFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetZonebudStessPeriodFunctionDesc.numParams := 1; // number of parameters;
  gMFGetZonebudStessPeriodFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetZonebudStessPeriodFunctionDesc.paramNames := @gpnTimeIndex;
  // paramter names
  gMFGetZonebudStessPeriodFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetZonebudStessPeriodFunctionDesc.neededProject := Project;
  // needed project

  gMFGetZonebudStessPeriodPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMFGetZonebudStessPeriodPieDesc.vendor := Vendor; // vendor
  gMFGetZonebudStessPeriodPieDesc.product := Product; // product
  gMFGetZonebudStessPeriodPieDesc.name := 'MODFLOW_ZonebudStessPeriod';
  // function name
  gMFGetZonebudStessPeriodPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetZonebudStessPeriodPieDesc.descriptor :=
    @gMFGetZonebudStessPeriodFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetZonebudStessPeriodPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // Zonebud Composite Zone
  gMFGetZonebudCompositeZoneFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetZonebudCompositeZoneFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetZonebudCompositeZoneFunctionDesc.name := 'MODFLOW_ZonebudCompositeZone';
  // Function name
  gMFGetZonebudCompositeZoneFunctionDesc.address := GetZoneBudCompositeZone;
  // Function address
  gMFGetZonebudCompositeZoneFunctionDesc.returnType := kPIEString; // return type
  gMFGetZonebudCompositeZoneFunctionDesc.numParams := 1; // number of parameters;
  gMFGetZonebudCompositeZoneFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetZonebudCompositeZoneFunctionDesc.paramNames := @gpnZone;
  // paramter names
  gMFGetZonebudCompositeZoneFunctionDesc.paramTypes := @gOneIntegerTypes;
  // parameter types
  gMFGetZonebudCompositeZoneFunctionDesc.neededProject := Project;
  // needed project

  gMFGetZonebudCompositeZonePieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMFGetZonebudCompositeZonePieDesc.vendor := Vendor; // vendor
  gMFGetZonebudCompositeZonePieDesc.product := Product; // product
  gMFGetZonebudCompositeZonePieDesc.name := 'MODFLOW_ZonebudCompositeZone';
  // function name
  gMFGetZonebudCompositeZonePieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetZonebudCompositeZonePieDesc.descriptor :=
    @gMFGetZonebudCompositeZoneFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetZonebudCompositeZonePieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // MODPATH post processing
  gMFModpathPostImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFModpathPostImportPIEDesc.name := 'M&ODPATH Post-Processing...';
  gMFModpathPostImportPIEDesc.importFlags := kImportAllwaysVisible or
    kImportNeedsProject;
  gMFModpathPostImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFModpathPostImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
  gMFModpathPostImportPIEDesc.doImportProc := ReadModpath;
  gMFModpathPostImportPIEDesc.neededProject := Project;

  gMFModpathPostPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFModpathPostPIEDesc.vendor := Vendor; // vendor
  gMFModpathPostPIEDesc.product := Product; // product
  gMFModpathPostPIEDesc.name := 'M&ODPATH Post-Processing...';
  gMFModpathPostPIEDesc.PieType := kImportPIE;
  gMFModpathPostPIEDesc.descriptor := @gMFModpathPostImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFModpathPostPIEDesc;
  Inc(numNames); // add descriptor to list

  // MODFLOW Help
  gMFHelpImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFHelpImportPIEDesc.name := 'MODFLOW &Help';
  gMFHelpImportPIEDesc.importFlags := kImportAllwaysVisible;
  gMFHelpImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFHelpImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
  gMFHelpImportPIEDesc.doImportProc := ShowModflowHelp;
  gMFHelpImportPIEDesc.neededProject := '';

  gMFHelpPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFHelpPIEDesc.vendor := Vendor; // vendor
  gMFHelpPIEDesc.product := Product; // product
  gMFHelpPIEDesc.name := 'MODFLOW &Help';
  gMFHelpPIEDesc.PieType := kImportPIE;
  gMFHelpPIEDesc.descriptor := @gMFHelpImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFHelpPIEDesc;
  Inc(numNames); // add descriptor to list

  // Import Well layer
  gMFImportWellsImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFImportWellsImportPIEDesc.name := 'Import Wells...';
  gMFImportWellsImportPIEDesc.importFlags := kImportNeedsProject or
    kImportAllwaysVisible;
  gMFImportWellsImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFImportWellsImportPIEDesc.fromLayerTypes := 0;
  gMFImportWellsImportPIEDesc.doImportProc := ImportWells;
  gMFImportWellsImportPIEDesc.neededProject := Project;

  gMFImportWellsPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFImportWellsPIEDesc.vendor := Vendor; // vendor
  gMFImportWellsPIEDesc.product := Product; // product
  gMFImportWellsPIEDesc.name := 'Import Wells...';
  gMFImportWellsPIEDesc.PieType := kImportPIE;
  gMFImportWellsPIEDesc.descriptor := @gMFImportWellsImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFImportWellsPIEDesc;
  Inc(numNames); // add descriptor to list

  gPIECheckVersionFDesc.name := 'MODFLOW_CheckVersion'; // name of function
  gPIECheckVersionFDesc.address := GPIECheckVersionMMFun; // function address
  gPIECheckVersionFDesc.returnType := kPIEBoolean; // return value type
  gPIECheckVersionFDesc.numParams := 4; // number of parameters
  gPIECheckVersionFDesc.numOptParams := 0; // number of optional parameters
  gPIECheckVersionFDesc.paramNames := @gpnFourDigit;
  // pointer to parameter names list
  gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;
  // pointer to parameters types list
  gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
  gPIECheckVersionFDesc.functionFlags := UsualOptions;
  gPIECheckVersionFDesc.neededProject := Project;

  gPIECheckVersionDesc.name := 'MODFLOW_CheckVersion'; // name of PIE
  gPIECheckVersionDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;
  // pointer to descriptor
  gPIECheckVersionDesc.version := ANE_PIE_VERSION;
  gPIECheckVersionDesc.vendor := vendor;
  gPIECheckVersionDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gPIECheckVersionDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFGetLayerFunctionDesc.name := 'MF_Layer'; // name of function
  gMFGetLayerFunctionDesc.address := GGetMODFLOWLayer; // function address
  gMFGetLayerFunctionDesc.returnType := kPIEInteger; // return value type
  gMFGetLayerFunctionDesc.numParams := 1; // number of parameters
  gMFGetLayerFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFGetLayerFunctionDesc.paramNames := @gpnElevation;
  // pointer to parameter names list
  gMFGetLayerFunctionDesc.paramTypes := @gOneDoubleTypes;
  // pointer to parameters types list
  gMFGetLayerFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFGetLayerFunctionDesc.functionFlags := kFunctionNeedsProject;
  gMFGetLayerFunctionDesc.neededProject := Project;

  gMFGetLayerPieDesc.name := 'MF_Layer'; // name of PIE
  gMFGetLayerPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFGetLayerPieDesc.descriptor := @gMFGetLayerFunctionDesc;
  // pointer to descriptor
  gMFGetLayerPieDesc.version := ANE_PIE_VERSION;
  gMFGetLayerPieDesc.vendor := vendor;
  gMFGetLayerPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetLayerPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFExportLakesFunctionDesc.name := 'MF_ExportLakes'; // name of function
  gMFExportLakesFunctionDesc.address := GExportLake; // function address
  gMFExportLakesFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFExportLakesFunctionDesc.numParams := 0; // number of parameters
  gMFExportLakesFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFExportLakesFunctionDesc.paramNames := nil;
  // pointer to parameter names list
  gMFExportLakesFunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFExportLakesFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFExportLakesFunctionDesc.functionFlags := UsualOptions;
  gMFExportLakesFunctionDesc.neededProject := Project;

  gMFExportLakesPieDesc.name := 'MF_ExportLakes'; // name of PIE
  gMFExportLakesPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFExportLakesPieDesc.descriptor := @gMFExportLakesFunctionDesc;
  // pointer to descriptor
  gMFExportLakesPieDesc.version := ANE_PIE_VERSION;
  gMFExportLakesPieDesc.vendor := vendor;
  gMFExportLakesPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFExportLakesPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFFreeBlockFunctionDesc.name := 'MF_FreeBlocks'; // name of function
  gMFFreeBlockFunctionDesc.address := GFreeBlock; // function address
  gMFFreeBlockFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFFreeBlockFunctionDesc.numParams := 0; // number of parameters
  gMFFreeBlockFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFFreeBlockFunctionDesc.paramNames := nil; // pointer to parameter names list
  gMFFreeBlockFunctionDesc.paramTypes := nil; // pointer to parameters types list
  gMFFreeBlockFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFFreeBlockFunctionDesc.functionFlags := UsualOptions;
  gMFFreeBlockFunctionDesc.neededProject := Project;

  gMFFreeBlockPieDesc.name := 'MF_FreeBlocks'; // name of PIE
  gMFFreeBlockPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFFreeBlockPieDesc.descriptor := @gMFFreeBlockFunctionDesc;
  // pointer to descriptor
  gMFFreeBlockPieDesc.version := ANE_PIE_VERSION;
  gMFFreeBlockPieDesc.vendor := vendor;
  gMFFreeBlockPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFFreeBlockPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFInitializeLakesFunctionDesc.name := 'MF_InitializeLakes';
  // name of function
  gMFInitializeLakesFunctionDesc.address := GInitializeLake; // function address
  gMFInitializeLakesFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFInitializeLakesFunctionDesc.numParams := 0; // number of parameters
  gMFInitializeLakesFunctionDesc.numOptParams := 0;
  // number of optional parameters
  gMFInitializeLakesFunctionDesc.paramNames := nil;
  // pointer to parameter names list
  gMFInitializeLakesFunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFInitializeLakesFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFInitializeLakesFunctionDesc.functionFlags := UsualOptions;
  gMFInitializeLakesFunctionDesc.neededProject := Project;

  gMFInitializeLakesPieDesc.name := 'MF_InitializeLakes'; // name of PIE
  gMFInitializeLakesPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFInitializeLakesPieDesc.descriptor := @gMFInitializeLakesFunctionDesc;
  // pointer to descriptor
  gMFInitializeLakesPieDesc.version := ANE_PIE_VERSION;
  gMFInitializeLakesPieDesc.vendor := vendor;
  gMFInitializeLakesPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFInitializeLakesPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFLakesNumberFunctionDesc.name := 'MF_LakeNumber'; // name of function
  gMFLakesNumberFunctionDesc.address := GLakeNumber; // function address
  gMFLakesNumberFunctionDesc.returnType := kPIEInteger; // return value type
  gMFLakesNumberFunctionDesc.numParams := 3; // number of parameters
  gMFLakesNumberFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFLakesNumberFunctionDesc.paramNames := @gpnColRowLayer;
  // pointer to parameter names list
  gMFLakesNumberFunctionDesc.paramTypes := @gThreeIntegerTypes;
  // pointer to parameters types list
  gMFLakesNumberFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFLakesNumberFunctionDesc.functionFlags := UsualOptions;
  gMFLakesNumberFunctionDesc.neededProject := Project;

  gMFLakesNumberPieDesc.name := 'MF_LakeNumber'; // name of PIE
  gMFLakesNumberPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFLakesNumberPieDesc.descriptor := @gMFLakesNumberFunctionDesc;
  // pointer to descriptor
  gMFLakesNumberPieDesc.version := ANE_PIE_VERSION;
  gMFLakesNumberPieDesc.vendor := vendor;
  gMFLakesNumberPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFLakesNumberPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFUseIBSFunctionDesc.name := 'MF_UseIBS'; // name of function
  gMFUseIBSFunctionDesc.address := GetUseIBS; // function address
  gMFUseIBSFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFUseIBSFunctionDesc.numParams := 1; // number of parameters
  gMFUseIBSFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFUseIBSFunctionDesc.paramNames := @gpnUnit;
  // pointer to parameter names list
  gMFUseIBSFunctionDesc.paramTypes := @gOneIntegerTypes;
  // pointer to parameters types list
  gMFUseIBSFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFUseIBSFunctionDesc.functionFlags := UsualOptions;
  gMFUseIBSFunctionDesc.neededProject := Project;

  gMFUseIBSPieDesc.name := 'MF_UseIBS'; // name of PIE
  gMFUseIBSPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFUseIBSPieDesc.descriptor := @gMFUseIBSFunctionDesc; // pointer to descriptor
  gMFUseIBSPieDesc.version := ANE_PIE_VERSION;
  gMFUseIBSPieDesc.vendor := vendor;
  gMFUseIBSPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFUseIBSPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFExportReservoirsFunctionDesc.name := 'MF_ExportReservoirs';
  // name of function
  gMFExportReservoirsFunctionDesc.address := GExportReservoir;
  // function address
  gMFExportReservoirsFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFExportReservoirsFunctionDesc.numParams := 0; // number of parameters
  gMFExportReservoirsFunctionDesc.numOptParams := 0;
  // number of optional parameters
  gMFExportReservoirsFunctionDesc.paramNames := nil;
  // pointer to parameter names list
  gMFExportReservoirsFunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFExportReservoirsFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFExportReservoirsFunctionDesc.functionFlags := UsualOptions;
  gMFExportReservoirsFunctionDesc.neededProject := Project;

  gMFExportReservoirsPieDesc.name := 'MF_ExportReservoirs'; // name of PIE
  gMFExportReservoirsPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFExportReservoirsPieDesc.descriptor := @gMFExportReservoirsFunctionDesc;
  // pointer to descriptor
  gMFExportReservoirsPieDesc.version := ANE_PIE_VERSION;
  gMFExportReservoirsPieDesc.vendor := vendor;
  gMFExportReservoirsPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFExportReservoirsPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFInitializeReservoirsFunctionDesc.name := 'MF_InitializeReservoirs';
  // name of function
  gMFInitializeReservoirsFunctionDesc.address := GInitializeReservoir;
  // function address
  gMFInitializeReservoirsFunctionDesc.returnType := kPIEBoolean;
  // return value type
  gMFInitializeReservoirsFunctionDesc.numParams := 0; // number of parameters
  gMFInitializeReservoirsFunctionDesc.numOptParams := 0;
  // number of optional parameters
  gMFInitializeReservoirsFunctionDesc.paramNames := nil;
  // pointer to parameter names list
  gMFInitializeReservoirsFunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFInitializeReservoirsFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFInitializeReservoirsFunctionDesc.functionFlags := UsualOptions;
  gMFInitializeReservoirsFunctionDesc.neededProject := Project;

  gMFInitializeReservoirsPieDesc.name := 'MF_InitializeReservoirs';
  // name of PIE
  gMFInitializeReservoirsPieDesc.PieType := kFunctionPIE;
  // PIE type: PIE function
  gMFInitializeReservoirsPieDesc.descriptor :=
    @gMFInitializeReservoirsFunctionDesc; // pointer to descriptor
  gMFInitializeReservoirsPieDesc.version := ANE_PIE_VERSION;
  gMFInitializeReservoirsPieDesc.vendor := vendor;
  gMFInitializeReservoirsPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFInitializeReservoirsPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  gMFReservoirsNumberFunctionDesc.name := 'MF_ReservoirNumber';
  // name of function
  gMFReservoirsNumberFunctionDesc.address := GReservoirNumber;
  // function address
  gMFReservoirsNumberFunctionDesc.returnType := kPIEInteger; // return value type
  gMFReservoirsNumberFunctionDesc.numParams := 2; // number of parameters
  gMFReservoirsNumberFunctionDesc.numOptParams := 0;
  // number of optional parameters
  gMFReservoirsNumberFunctionDesc.paramNames := @gpnColRowLayer;
  // pointer to parameter names list
  gMFReservoirsNumberFunctionDesc.paramTypes := @gThreeIntegerTypes;
  // pointer to parameters types list
  gMFReservoirsNumberFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFReservoirsNumberFunctionDesc.functionFlags := UsualOptions;
  gMFReservoirsNumberFunctionDesc.neededProject := Project;

  gMFReservoirsNumberPieDesc.name := 'MF_ReservoirNumber'; // name of PIE
  gMFReservoirsNumberPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFReservoirsNumberPieDesc.descriptor := @gMFReservoirsNumberFunctionDesc;
  // pointer to descriptor
  gMFReservoirsNumberPieDesc.version := ANE_PIE_VERSION;
  gMFReservoirsNumberPieDesc.vendor := vendor;
  gMFReservoirsNumberPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFReservoirsNumberPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFUseTLKFunctionDesc.name := 'MF_UseTLK'; // name of function
  gMFUseTLKFunctionDesc.address := GetUseTLK; // function address
  gMFUseTLKFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFUseTLKFunctionDesc.numParams := 1; // number of parameters
  gMFUseTLKFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFUseTLKFunctionDesc.paramNames := @gpnUnit;
  // pointer to parameter names list
  gMFUseTLKFunctionDesc.paramTypes := @gOneIntegerTypes;
  // pointer to parameters types list
  gMFUseTLKFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFUseTLKFunctionDesc.functionFlags := UsualOptions;
  gMFUseTLKFunctionDesc.neededProject := Project;

  gMFUseTLKPieDesc.name := 'MF_UseTLK'; // name of PIE
  gMFUseTLKPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFUseTLKPieDesc.descriptor := @gMFUseTLKFunctionDesc; // pointer to descriptor
  gMFUseTLKPieDesc.version := ANE_PIE_VERSION;
  gMFUseTLKPieDesc.vendor := vendor;
  gMFUseTLKPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFUseTLKPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFExport2000FunctionDesc.name := 'MF_ExportModflow2000'; // name of function
  gMFExport2000FunctionDesc.address := GWriteModflow2000; // function address
  gMFExport2000FunctionDesc.returnType := kPIEBoolean; // return value type
  gMFExport2000FunctionDesc.numParams := 0; // number of parameters
  gMFExport2000FunctionDesc.numOptParams := 0; // number of optional parameters
  gMFExport2000FunctionDesc.paramNames := nil; // pointer to parameter names list
  gMFExport2000FunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFExport2000FunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFExport2000FunctionDesc.functionFlags := UsualOptions;
  gMFExport2000FunctionDesc.neededProject := Project;

  gMFExport2000PieDesc.name := 'MF_ExportModflow2000'; // name of PIE
  gMFExport2000PieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFExport2000PieDesc.descriptor := @gMFExport2000FunctionDesc;
  // pointer to descriptor
  gMFExport2000PieDesc.version := ANE_PIE_VERSION;
  gMFExport2000PieDesc.vendor := vendor;
  gMFExport2000PieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFExport2000PieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFExportMT3DMSFunctionDesc.name := 'MF_MT3DMS'; // name of function
  gMFExportMT3DMSFunctionDesc.address := GWriteMT3DMS; // function address
  gMFExportMT3DMSFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFExportMT3DMSFunctionDesc.numParams := 0; // number of parameters
  gMFExportMT3DMSFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFExportMT3DMSFunctionDesc.paramNames := nil;
  // pointer to parameter names list
  gMFExportMT3DMSFunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFExportMT3DMSFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFExportMT3DMSFunctionDesc.functionFlags := UsualOptions;
  gMFExportMT3DMSFunctionDesc.neededProject := Project;

  gMFExportMT3DMSPieDesc.name := 'MF_MT3DMS'; // name of PIE
  gMFExportMT3DMSPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFExportMT3DMSPieDesc.descriptor := @gMFExportMT3DMSFunctionDesc;
  // pointer to descriptor
  gMFExportMT3DMSPieDesc.version := ANE_PIE_VERSION;
  gMFExportMT3DMSPieDesc.vendor := vendor;
  gMFExportMT3DMSPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFExportMT3DMSPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFResetGagesFunctionDesc.name := 'MF_ResetGages'; // name of function
  gMFResetGagesFunctionDesc.address := GResetGages; // function address
  gMFResetGagesFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFResetGagesFunctionDesc.numParams := 0; // number of parameters
  gMFResetGagesFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFResetGagesFunctionDesc.paramNames := nil; // pointer to parameter names list
  gMFResetGagesFunctionDesc.paramTypes := nil;
  // pointer to parameters types list
  gMFResetGagesFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFResetGagesFunctionDesc.functionFlags := UsualOptions;
  gMFResetGagesFunctionDesc.neededProject := Project;

  gMFResetGagesPieDesc.name := 'MF_ResetGages'; // name of PIE
  gMFResetGagesPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFResetGagesPieDesc.descriptor := @gMFResetGagesFunctionDesc;
  // pointer to descriptor
  gMFResetGagesPieDesc.version := ANE_PIE_VERSION;
  gMFResetGagesPieDesc.vendor := vendor;
  gMFResetGagesPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFResetGagesPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFGageCountFunctionDesc.name := 'MF_GageCount'; // name of function
  gMFGageCountFunctionDesc.address := GGageCount; // function address
  gMFGageCountFunctionDesc.returnType := kPIEInteger; // return value type
  gMFGageCountFunctionDesc.numParams := 0; // number of parameters
  gMFGageCountFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFGageCountFunctionDesc.paramNames := nil; // pointer to parameter names list
  gMFGageCountFunctionDesc.paramTypes := nil; // pointer to parameters types list
  gMFGageCountFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFGageCountFunctionDesc.functionFlags := UsualOptions;
  gMFGageCountFunctionDesc.neededProject := Project;

  gMFGageCountPieDesc.name := 'MF_GageCount'; // name of PIE
  gMFGageCountPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFGageCountPieDesc.descriptor := @gMFGageCountFunctionDesc;
  // pointer to descriptor
  gMFGageCountPieDesc.version := ANE_PIE_VERSION;
  gMFGageCountPieDesc.vendor := vendor;
  gMFGageCountPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGageCountPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFGageUnitNumberFunctionDesc.name := 'MF_GageUnitNumber'; // name of function
  gMFGageUnitNumberFunctionDesc.address := GGageUnitNumber; // function address
  gMFGageUnitNumberFunctionDesc.returnType := kPIEInteger; // return value type
  gMFGageUnitNumberFunctionDesc.numParams := 1; // number of parameters
  gMFGageUnitNumberFunctionDesc.numOptParams := 0;
  // number of optional parameters
  gMFGageUnitNumberFunctionDesc.paramNames := @gpnGageFile;
  // pointer to parameter names list
  gMFGageUnitNumberFunctionDesc.paramTypes := @gOneIntegerTypes;
  // pointer to parameters types list
  gMFGageUnitNumberFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFGageUnitNumberFunctionDesc.functionFlags := UsualOptions;
  gMFGageUnitNumberFunctionDesc.neededProject := Project;

  gMFGageUnitNumberPieDesc.name := 'MF_GageUnitNumber'; // name of PIE
  gMFGageUnitNumberPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFGageUnitNumberPieDesc.descriptor := @gMFGageUnitNumberFunctionDesc;
  // pointer to descriptor
  gMFGageUnitNumberPieDesc.version := ANE_PIE_VERSION;
  gMFGageUnitNumberPieDesc.vendor := vendor;
  gMFGageUnitNumberPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGageUnitNumberPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFGetUnitNumberFunctionDesc.name := 'MF_GetUnitNumber'; // name of function
  gMFGetUnitNumberFunctionDesc.address := GGetUnitNumber; // function address
  gMFGetUnitNumberFunctionDesc.returnType := kPIEInteger; // return value type
  gMFGetUnitNumberFunctionDesc.numParams := 1; // number of parameters
  gMFGetUnitNumberFunctionDesc.numOptParams := 0;
  // number of optional parameters
  gMFGetUnitNumberFunctionDesc.paramNames := @gpnFileType;
  // pointer to parameter names list
  gMFGetUnitNumberFunctionDesc.paramTypes := @gOneStringTypes;
  // pointer to parameters types list
  gMFGetUnitNumberFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFGetUnitNumberFunctionDesc.functionFlags := UsualOptions;
  gMFGetUnitNumberFunctionDesc.neededProject := Project;

  gMFGetUnitNumberPieDesc.name := 'MF_GetUnitNumber'; // name of PIE
  gMFGetUnitNumberPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFGetUnitNumberPieDesc.descriptor := @gMFGetUnitNumberFunctionDesc;
  // pointer to descriptor
  gMFGetUnitNumberPieDesc.version := ANE_PIE_VERSION;
  gMFGetUnitNumberPieDesc.vendor := vendor;
  gMFGetUnitNumberPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetUnitNumberPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  gMFWriteGagesFunctionDesc.name := 'MF_WriteGages'; // name of function
  gMFWriteGagesFunctionDesc.address := GWriteGages; // function address
  gMFWriteGagesFunctionDesc.returnType := kPIEBoolean; // return value type
  gMFWriteGagesFunctionDesc.numParams := 1; // number of parameters
  gMFWriteGagesFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFWriteGagesFunctionDesc.paramNames := @gpnRootType;
  // pointer to parameter names list
  gMFWriteGagesFunctionDesc.paramTypes := @gOneStringTypes;
  // pointer to parameters types list
  gMFWriteGagesFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFWriteGagesFunctionDesc.functionFlags := UsualOptions;
  gMFWriteGagesFunctionDesc.neededProject := Project;

  gMFWriteGagesPieDesc.name := 'MF_WriteGages'; // name of PIE
  gMFWriteGagesPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFWriteGagesPieDesc.descriptor := @gMFWriteGagesFunctionDesc;
  // pointer to descriptor
  gMFWriteGagesPieDesc.version := ANE_PIE_VERSION;
  gMFWriteGagesPieDesc.vendor := vendor;
  gMFWriteGagesPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFWriteGagesPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names

  // Link unit elevations
  gMFLinkUnitsImportPieDesc.version := IMPORT_PIE_VERSION;
  gMFLinkUnitsImportPieDesc.name := '&Link Elevations of Geologic Units';
  gMFLinkUnitsImportPieDesc.importFlags := kImportAllwaysVisible or
    kImportNeedsProject;
  gMFLinkUnitsImportPieDesc.toLayerTypes := kPIEAnyLayer;
  gMFLinkUnitsImportPieDesc.fromLayerTypes := kPIEAnyLayer;
  gMFLinkUnitsImportPieDesc.doImportProc := GLinkUnitsPIE;
  gMFLinkUnitsImportPieDesc.neededProject := Project;

  gMFLinkUnitsPieDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFLinkUnitsPieDesc.vendor := Vendor; // vendor
  gMFLinkUnitsPieDesc.product := Product; // product
  gMFLinkUnitsPieDesc.name := '&Link Elevations of Geologic Units';
  gMFLinkUnitsPieDesc.PieType := kImportPIE;
  gMFLinkUnitsPieDesc.descriptor := @gMFLinkUnitsImportPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFLinkUnitsPieDesc;
  Inc(numNames); // add descriptor to list

  // MODPATH Times
  gMFGetMODPATHSteadyStateFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetMODPATHSteadyStateFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetMODPATHSteadyStateFunctionDesc.name := 'MODFLOW_ModpathSteadyState';
  // Function name
  gMFGetMODPATHSteadyStateFunctionDesc.address := GetMODPATHSteadyState;
  // Function address
  gMFGetMODPATHSteadyStateFunctionDesc.returnType := kPIEInteger; // return type
  gMFGetMODPATHSteadyStateFunctionDesc.numParams := 0; // number of parameters;
  gMFGetMODPATHSteadyStateFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetMODPATHSteadyStateFunctionDesc.paramNames := nil; // paramter names
  gMFGetMODPATHSteadyStateFunctionDesc.paramTypes := nil; // parameter types
  gMFGetMODPATHSteadyStateFunctionDesc.neededProject := Project;
  // needed project

  gMFGetMODPATHSteadyStatePieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMFGetMODPATHSteadyStatePieDesc.vendor := Vendor; // vendor
  gMFGetMODPATHSteadyStatePieDesc.product := Product; // product
  gMFGetMODPATHSteadyStatePieDesc.name := 'MODFLOW_ModpathSteadyState';
  // function name
  gMFGetMODPATHSteadyStatePieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetMODPATHSteadyStatePieDesc.descriptor :=
    @gMFGetMODPATHSteadyStateFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetMODPATHSteadyStatePieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  // MODPATH Times
  gMFGetMODPATHTimeProblemFunctionDesc.version := FUNCTION_PIE_VERSION;
  // Function PIE verions
  gMFGetMODPATHTimeProblemFunctionDesc.functionFlags := UsualOptions;
  // Function options
  gMFGetMODPATHTimeProblemFunctionDesc.name := 'MODFLOW_ModpathTimeProblem';
  // Function name
  gMFGetMODPATHTimeProblemFunctionDesc.address := GetMODPATHTimeProblem;
  // Function address
  gMFGetMODPATHTimeProblemFunctionDesc.returnType := kPIEBoolean; // return type
  gMFGetMODPATHTimeProblemFunctionDesc.numParams := 0; // number of parameters;
  gMFGetMODPATHTimeProblemFunctionDesc.numOptParams := 0;
  // number of optional parameters;
  gMFGetMODPATHTimeProblemFunctionDesc.paramNames := nil; // paramter names
  gMFGetMODPATHTimeProblemFunctionDesc.paramTypes := nil; // parameter types
  gMFGetMODPATHTimeProblemFunctionDesc.neededProject := Project;
  // needed project

  gMFGetMODPATHTimeProblemPieDesc.version := ANE_PIE_VERSION;
  // Function Pie version
  gMFGetMODPATHTimeProblemPieDesc.vendor := Vendor; // vendor
  gMFGetMODPATHTimeProblemPieDesc.product := Product; // product
  gMFGetMODPATHTimeProblemPieDesc.name := 'MODFLOW_ModpathTimeProblem';
  // function name
  gMFGetMODPATHTimeProblemPieDesc.PieType := kFunctionPIE; // Pie type
  gMFGetMODPATHTimeProblemPieDesc.descriptor :=
    @gMFGetMODPATHTimeProblemFunctionDesc; // function PIE descriptor address

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetMODPATHTimeProblemPieDesc;
  // add descriptor to list
  Inc(numNames); // increment number of names

  gMFImportContoursImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFImportContoursImportPIEDesc.name :=
    'Import MODFLOW Contours from Spreadsheet...';
  gMFImportContoursImportPIEDesc.importFlags := kImportAllwaysVisible or
    kImportNeedsProject;
  gMFImportContoursImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFImportContoursImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
  gMFImportContoursImportPIEDesc.doImportProc := ImportModflowContours;
  gMFImportContoursImportPIEDesc.neededProject := Project;

  gMFImportContoursPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFImportContoursPIEDesc.vendor := Vendor; // vendor
  gMFImportContoursPIEDesc.product := Product; // product
  gMFImportContoursPIEDesc.name :=
    'Import MODFLOW Contours from Spreadsheet...';
  gMFImportContoursPIEDesc.PieType := kImportPIE;
  gMFImportContoursPIEDesc.descriptor := @gMFImportContoursImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFImportContoursPIEDesc;
  Inc(numNames); // add descriptor to list



  // link streams
  gMFLinkStreamsImportPIEDesc.version := IMPORT_PIE_VERSION;
  gMFLinkStreamsImportPIEDesc.name := 'Link Streams...';
  gMFLinkStreamsImportPIEDesc.importFlags := kImportAllwaysVisible or
    kImportNeedsProject;
  gMFLinkStreamsImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gMFLinkStreamsImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
  gMFLinkStreamsImportPIEDesc.doImportProc := LinkStreams;
  gMFLinkStreamsImportPIEDesc.neededProject := Project;

  gMFLinkStreamsPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFLinkStreamsPIEDesc.vendor := Vendor; // vendor
  gMFLinkStreamsPIEDesc.product := Product; // product
  gMFLinkStreamsPIEDesc.name := 'Link Streams...';
  gMFLinkStreamsPIEDesc.PieType := kImportPIE;
  gMFLinkStreamsPIEDesc.descriptor := @gMFLinkStreamsImportPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFLinkStreamsPIEDesc;
  Inc(numNames); // add descriptor to list




  // begin MT3D
  {
    gMT3DPostImportPIEDesc.version := IMPORT_PIE_VERSION;
    gMT3DPostImportPIEDesc.name := 'MT3D Post Processing';
    gMT3DPostImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
    gMT3DPostImportPIEDesc.toLayerTypes :=   kPIEAnyLayer;
    gMT3DPostImportPIEDesc.fromLayerTypes :=   kPIEAnyLayer;
    gMT3DPostImportPIEDesc.doImportProc := @GPostMT3DPIE;
    gMT3DPostImportPIEDesc.neededProject := Project;

    gMT3DPostPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
    gMT3DPostPIEDesc.vendor :=  Vendor;                           // vendor
    gMT3DPostPIEDesc.product := Product;                          // product
    gMT3DPostPIEDesc.name  := 'MT3D Post Processing';
    gMT3DPostPIEDesc.PieType :=  kImportPIE;
    gMT3DPostPIEDesc.descriptor := @gMT3DPostImportPIEDesc;

    Assert (numNames < kMaxPIEDesc) ;
    gPIEDesc[numNames] := @gMT3DPostPIEDesc;
    Inc(numNames);	// add descriptor to list   }

    // Run Model
  gMFRunExportMT3DPIEDesc.name := 'Run M&T3DMS...';
  gMFRunExportMT3DPIEDesc.exportType := kPIEGridLayer;
  gMFRunExportMT3DPIEDesc.exportFlags := kExportNeedsProject or
    kExportDontShowParamDialog or kExportDontShowFileDialog;
  gMFRunExportMT3DPIEDesc.getTemplateProc := RunMT3DPIE;
  gMFRunExportMT3DPIEDesc.preExportProc := nil;
  gMFRunExportMT3DPIEDesc.postExportProc := nil;
  gMFRunExportMT3DPIEDesc.neededProject := Project;

  gMFRunMT3DPIEDesc.version := ANE_PIE_VERSION; // Function Pie version
  gMFRunMT3DPIEDesc.vendor := Vendor; // vendor
  gMFRunMT3DPIEDesc.product := Product; // product
  gMFRunMT3DPIEDesc.name := 'Run M&T3DMS...';
  gMFRunMT3DPIEDesc.PieType := kExportTemplatePIE;
  gMFRunMT3DPIEDesc.descriptor := @gMFRunExportMT3DPIEDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFRunMT3DPIEDesc;
  Inc(numNames); // add descriptor to list

  // end MT3D

  {
    gMFInitializeLakeGagesFunctionDesc.name := 'MF_InitializeLakeGages';	        // name of function
    gMFInitializeLakeGagesFunctionDesc.address := GInitializeLakeGages;		// function address
    gMFInitializeLakeGagesFunctionDesc.returnType := kPIEBoolean;		// return value type
    gMFInitializeLakeGagesFunctionDesc.numParams :=  0;			// number of parameters
    gMFInitializeLakeGagesFunctionDesc.numOptParams := 0;			// number of optional parameters
    gMFInitializeLakeGagesFunctionDesc.paramNames := nil;		// pointer to parameter names list
    gMFInitializeLakeGagesFunctionDesc.paramTypes := nil;	// pointer to parameters types list
    gMFInitializeLakeGagesFunctionDesc.version := FUNCTION_PIE_VERSION;
    gMFInitializeLakeGagesFunctionDesc.functionFlags := UsualOptions;
    gMFInitializeLakeGagesFunctionDesc.neededProject := Project;

    gMFInitializeLakeGagesPieDesc.name  := 'MF_InitializeLakeGages';		// name of PIE
    gMFInitializeLakeGagesPieDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
    gMFInitializeLakeGagesPieDesc.descriptor := @gMFInitializeLakeGagesFunctionDesc;	// pointer to descriptor
    gMFInitializeLakeGagesPieDesc.version := ANE_PIE_VERSION;
    gMFInitializeLakeGagesPieDesc.vendor := vendor;
    gMFInitializeLakeGagesPieDesc.product := product;

    Assert (numNames < kMaxPIEDesc) ;
    gPIEDesc[numNames] := @gMFInitializeLakeGagesPieDesc;  // add descriptor to list
    Inc(numNames);	// increment number of names
  }

  gMFGetIboundFunctionDesc.name := 'MF_GetIbound'; // name of function
  gMFGetIboundFunctionDesc.address := GGetIbound; // function address
  gMFGetIboundFunctionDesc.returnType := kPIEInteger; // return value type
  gMFGetIboundFunctionDesc.numParams := 3; // number of parameters
  gMFGetIboundFunctionDesc.numOptParams := 0; // number of optional parameters
  gMFGetIboundFunctionDesc.paramNames := @gpnColRowLayer;
  // pointer to parameter names list
  gMFGetIboundFunctionDesc.paramTypes := @gThreeIntegerTypes;
  // pointer to parameters types list
  gMFGetIboundFunctionDesc.version := FUNCTION_PIE_VERSION;
  gMFGetIboundFunctionDesc.functionFlags := UsualOptions;
  gMFGetIboundFunctionDesc.neededProject := Project;

  gMFGetIboundPieDesc.name := 'MF_GetIbound'; // name of PIE
  gMFGetIboundPieDesc.PieType := kFunctionPIE; // PIE type: PIE function
  gMFGetIboundPieDesc.descriptor := @gMFGetIboundFunctionDesc;
  // pointer to descriptor
  gMFGetIboundPieDesc.version := ANE_PIE_VERSION;
  gMFGetIboundPieDesc.vendor := vendor;
  gMFGetIboundPieDesc.product := product;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gMFGetIboundPieDesc; // add descriptor to list
  Inc(numNames); // increment number of names



end;

end.

