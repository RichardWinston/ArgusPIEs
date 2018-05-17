unit GetANEFunctionsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Clipbrd,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE, ExtCtrls, Buttons, ArgusDataEntry, WriteContourUnit,
     PointContourUnit ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses ANECB, NodeUnit, UtilityFunctions, ImportPointsUnit,
  ImportContoursUnit, MeshToContour, frmEditUnit, OptionsUnit;

const
  kMaxFunDesc = 7;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gEditContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gEditContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gReverseContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gReverseContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gData2ContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gData2ContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gImportPointsPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gImportPointsImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gImportContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gImportContoursImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gMeshToContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gMeshToContoursImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gElementsToContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gElementsToContoursImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

procedure GEditContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  InfoText : ANE_STR;
  InfoTextString : String;
  ImportText : string;
  AString : ANE_STR;
  Project : TProjectOptions;
  OldCopyDelimiter : char;
  OldCopyIcon : ANE_BOOL;
  OldCopyName : ANE_BOOL;
  OldCopyParameters : ANE_BOOL;
  OldExportDelimiter : char;
  OldExportTitles : ANE_BOOL;
begin
  try
    Project := TProjectOptions.Create;
    try
      OldCopyDelimiter := Project.CopyDelimiter[aneHandle];
      OldCopyIcon := Project.CopyIcon[aneHandle];
      OldCopyName := Project.CopyName[aneHandle];
      OldCopyParameters := Project.CopyParameters[aneHandle];
      OldExportDelimiter := Project.ExportDelimiter[aneHandle];
      OldExportTitles := Project.ExportTitles[aneHandle];

      Project.CopyDelimiter[aneHandle] := #9;
      Project.CopyIcon[aneHandle] := True;
      Project.CopyName[aneHandle] := True;
      Project.CopyParameters[aneHandle] := True;
      Project.ExportDelimiter[aneHandle] := #9;
      Project.ExportTitles[aneHandle] := True;

      ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @InfoText );
      InfoTextString := String(InfoText);

      Application.CreateForm(TfrmEditNew,frmEditNew);
      try
        frmEditNew.ReadArgusContours(InfoTextString, TLocalContour,
          TLocalPoint);
        frmEditNew.zbMain.GetMinMax;
        frmEditNew.zbMain.ZoomOut;
        if frmEditNew.ShowModal = mrOK then
        begin
          ImportText := frmEditNew.WriteContours;

          ANE_LayerClear(aneHandle , layerHandle, False );
          GetMem(AString, Length(ImportText) + 1);
          try
            StrPCopy(AString, ImportText);
            ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, AString);
          finally
            FreeMem(AString);
          end;
        end;
      finally
        Project.CopyDelimiter[aneHandle] := OldCopyDelimiter;
        Project.CopyIcon[aneHandle] := OldCopyIcon;
        Project.CopyName[aneHandle] := OldCopyName;
        Project.CopyParameters[aneHandle] := OldCopyParameters;
        Project.ExportDelimiter[aneHandle] := OldExportDelimiter;
        Project.ExportTitles[aneHandle] := OldExportTitles;
        FreeAndNil(frmEditNew);
      end;
    finally
      Project.free;
    end;
  except
    on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GReverseContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  InfoTextString : String;
  ImportText : string;
  AString : ANE_STR;
  Project : TProjectOptions;
  OldCopyDelimiter : char;
  OldCopyIcon : ANE_BOOL;
  OldCopyName : ANE_BOOL;
  OldCopyParameters : ANE_BOOL;
  OldExportDelimiter : char;
  OldExportTitles : ANE_BOOL;
begin
  try
    Project := TProjectOptions.Create;
    try
      OldCopyDelimiter := Project.CopyDelimiter[aneHandle];
      OldCopyIcon := Project.CopyIcon[aneHandle];
      OldCopyName := Project.CopyName[aneHandle];
      OldCopyParameters := Project.CopyParameters[aneHandle];
      OldExportDelimiter := Project.ExportDelimiter[aneHandle];
      OldExportTitles := Project.ExportTitles[aneHandle];

      try
        Project.CopyDelimiter[aneHandle] := #9;
        Project.CopyIcon[aneHandle] := True;
        Project.CopyName[aneHandle] := True;
        Project.CopyParameters[aneHandle] := True;
        Project.ExportDelimiter[aneHandle] := #9;
        Project.ExportTitles[aneHandle] := True;

        InfoTextString := Clipboard.AsText;

        Application.CreateForm(TfrmEditNew,frmEditNew);
        try
          frmEditNew.ReadArgusContours(InfoTextString, TLocalContour,
            TLocalPoint);
          frmEditNew.ReverseContours;
          ImportText := frmEditNew.WriteContours;
        finally
          FreeAndNil(frmEditNew);
        end;

        GetMem(AString, Length(ImportText) + 1);
        try
          StrPCopy(AString, ImportText);
          ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, AString);
        finally
          FreeMem(AString);
        end;
      finally
        Project.CopyDelimiter[aneHandle] := OldCopyDelimiter;
        Project.CopyIcon[aneHandle] := OldCopyIcon;
        Project.CopyName[aneHandle] := OldCopyName;
        Project.CopyParameters[aneHandle] := OldCopyParameters;
        Project.ExportDelimiter[aneHandle] := OldExportDelimiter;
        Project.ExportTitles[aneHandle] := OldExportTitles;
      end;
    finally
      Project.free;
    end;
  except
    on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GData2ContourPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  DataText : ANE_STR;
  DataTextString : String;
  ImportText : string;
  AString : ANE_STR;
  Layer : TLayerOptions;
  CurrentLayer : ANE_PTR;
begin
  try
    begin
      ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @DataText );
      DataTextString := String(DataText);
      Application.CreateForm(TfrmEditNew,frmEditNew);
      try
        frmEditNew.ReadArgusData(DataTextString, TLocalContour,
          TLocalPoint);

        Layer := TLayerOptions.Create(ANE_LayerGetCurrent(aneHandle));
        try
          if (Layer.NumObjects(aneHandle,pieContourObject) > 0)
            and (MessageDlg('The layer to which you are importing the data '
              + 'points already has some contours.  Do you want to erase them?',
              mtInformation, [mbYes, mbNo], 0) = mrYes) then
          begin
            Layer.ClearLayer(aneHandle, False);
          end;
        finally
          Layer.Free(aneHandle);
        end;  


        ImportText := frmEditNew.WriteContours;

        GetMem(AString, Length(ImportText) + 1);
        try
          StrPCopy(AString, ImportText);

          ANE_ImportTextToLayer(aneHandle, AString);
        finally
          FreeMem(AString);
        end;
      finally
        FreeAndNil(frmEditNew);
      end;
    end;
   except
     on Exception do
        begin
        end;
   end;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;
	gEditContoursPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gEditContoursPIEImportPIEDesc.name := 'Edit Contours';   // name of project
	gEditContoursPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gEditContoursPIEImportPIEDesc.fromLayerTypes :=
          kPIEInformationLayer or kPIEDomainLayer ;
 	gEditContoursPIEImportPIEDesc.toLayerTypes :=
          kPIEInformationLayer or kPIEDomainLayer  ;
 	gEditContoursPIEImportPIEDesc.doImportProc := @GEditContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Example Delphi PIE
	gEditContoursPIEDesc.name := 'Edit Contours';      // PIE name
	gEditContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gEditContoursPIEDesc.descriptor := @gEditContoursPIEImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gEditContoursPIEDesc;
        Inc(numNames);	// add descriptor to list

	gReverseContoursPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gReverseContoursPIEImportPIEDesc.name := 'Reverse Contours on Clipboard';   // name of project
	gReverseContoursPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gReverseContoursPIEImportPIEDesc.fromLayerTypes :=
          kPIEInformationLayer or kPIEDomainLayer ;
 	gReverseContoursPIEImportPIEDesc.toLayerTypes :=
          kPIEInformationLayer or kPIEDomainLayer  ;
 	gReverseContoursPIEImportPIEDesc.doImportProc := @GReverseContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Example Delphi PIE
	gReverseContoursPIEDesc.name := 'Reverse Contours on Clipboard';      // PIE name
	gReverseContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gReverseContoursPIEDesc.descriptor := @gReverseContoursPIEImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gReverseContoursPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Data to contours
	gData2ContoursPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gData2ContoursPIEImportPIEDesc.name := 'Data to Contours';   // name of project
	gData2ContoursPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gData2ContoursPIEImportPIEDesc.fromLayerTypes :=
          kPIEDataLayer ;
 	gData2ContoursPIEImportPIEDesc.toLayerTypes :=
          kPIEInformationLayer  ;
 	gData2ContoursPIEImportPIEDesc.doImportProc := @GData2ContourPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Example Delphi PIE
	gData2ContoursPIEDesc.name := 'Data to Contours';      // PIE name
	gData2ContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gData2ContoursPIEDesc.descriptor := @gData2ContoursPIEImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gData2ContoursPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Import Points
	gImportPointsImportPIEDesc.version := IMPORT_PIE_VERSION;
	gImportPointsImportPIEDesc.name := 'Import Points from Spreadsheet';   // name of project
	gImportPointsImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gImportPointsImportPIEDesc.fromLayerTypes := kPIEAnyLayer;
 	gImportPointsImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gImportPointsImportPIEDesc.doImportProc := @GImportPointsPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Import Points PIE
	gImportPointsPIEDesc.name := 'Import Points from Spreadsheet';      // PIE name
	gImportPointsPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gImportPointsPIEDesc.descriptor := @gImportPointsImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gImportPointsPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Import Contours
	gImportContoursImportPIEDesc.version := IMPORT_PIE_VERSION;
	gImportContoursImportPIEDesc.name := 'Import Contours from Spreadsheet';   // name of project
	gImportContoursImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gImportContoursImportPIEDesc.fromLayerTypes :=kPIEAnyLayer;
 	gImportContoursImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gImportContoursImportPIEDesc.doImportProc := @GImportContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Import Points PIE
	gImportContoursPIEDesc.name := 'Import Contours from Spreadsheet';      // PIE name
	gImportContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gImportContoursPIEDesc.descriptor := @gImportContoursImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gImportContoursPIEDesc;
        Inc(numNames);	// add descriptor to list


        // Import Contours
	gMeshToContoursImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMeshToContoursImportPIEDesc.name := 'Mesh Objects To Contours';   // name of project
	gMeshToContoursImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gMeshToContoursImportPIEDesc.fromLayerTypes :=kPIEAnyLayer;
 	gMeshToContoursImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gMeshToContoursImportPIEDesc.doImportProc := @GMeshToContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Import Points PIE
	gMeshToContoursPIEDesc.name := 'Mesh Objects To Contours';      // PIE name
	gMeshToContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gMeshToContoursPIEDesc.descriptor := @gMeshToContoursImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gMeshToContoursPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Import Contours
	gElementsToContoursImportPIEDesc.version := IMPORT_PIE_VERSION;
	gElementsToContoursImportPIEDesc.name := 'Mesh To Contours';   // name of project
	gElementsToContoursImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gElementsToContoursImportPIEDesc.fromLayerTypes :=kPIEAnyLayer;
 	gElementsToContoursImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gElementsToContoursImportPIEDesc.doImportProc := @GElementsToContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Import Points PIE
	gElementsToContoursPIEDesc.name := 'Mesh To Contours';      // PIE name
	gElementsToContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gElementsToContoursPIEDesc.descriptor := @gElementsToContoursImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gElementsToContoursPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;


end.
