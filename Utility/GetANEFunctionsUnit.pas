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

uses ANECB, FunctionPIE, NodeUnit, UtilityFunctions, ImportPointsUnit,
  ImportContoursUnit, MeshToContour, frmEditUnit, OptionsUnit,
  EditDatLayerUnit, EditGridFunctions, GridUnit, JoinUnit, DeclutterUnit,
  frmLayerNameUnit, frmDEM_Unit, TreeUnit, frmAddParametersUnit,
  frmSetParamLockUnit, frmDeleteLayerUnit, conversionFunctionUnit,
  EvalAtFunctionUnit, CheckPIEVersionFunction, RotatedCellsFunctionUnit,
  ChooseLayerUnit, InterpolationPIE, QT_Nearest, frmEditChoices,
  frmImportChoicesUnit, frmConvertChoicesUnit, frmMeshLayerChoiceUnit,
  frmMoveUnit, frmPasteContoursUnit, ExportProgressUnit, CheckVersionFunction,
  frmDependsOnUnit, icnorm, frmSamplePoints_Unit, ShepardInterpolation,
  frmImportShapeUnit, hh, hh_funcs, ArgusFormUnit, TriangleInterpolate;

const
  kMaxFunDesc = 115;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

{   gEditContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
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

   gGriddedDataDesc  : ANEPIEDesc;	                   // PIE descriptor
   gGriddedDataImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gCopyTriMeshPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gCopyTriMeshImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gCopyQuadMeshPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gCopyQuadMeshImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gImportDEM_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gImportDEM_ImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gParamImportPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gParamImportImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gSetParamImportPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gSetParamImportImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor
}
   gSetParamLockPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gSetParamLockImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gDeleteLayerPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDeleteLayerImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gQT_NearestPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_NearestInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5AvgPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5AvgInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20AvgPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20AvgInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5InvDistSqPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5InvDistSqInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20InvDistSqPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20InvDistSqInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   // anisotropy = 10
{   gQT_NearestA10PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_NearestA10InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5AvgA10PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5AvgA10InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20AvgA10PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20AvgA10InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5InvDistSqA10PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5InvDistSqA10InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20InvDistSqA10PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20InvDistSqA10InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   // anisotropy = 30
   gQT_NearestA30PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_NearestA30InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5AvgA30PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5AvgA30InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20AvgA30PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20AvgA30InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5InvDistSqA30PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5InvDistSqA30InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20InvDistSqA30PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20InvDistSqA30InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor
}
   // anisotropy = 100
   gQT_NearestA100PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_NearestA100InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5AvgA100PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5AvgA100InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20AvgA100PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20AvgA100InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest5InvDistSqA100PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest5InvDistSqA100InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gQT_Nearest20InvDistSqA100PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gQT_Nearest20InvDistSqA100InterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gModifiedShepardPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gModifiedShepardInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gTriangleInterpPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gTriangleInterpInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor

   gEditChoicesPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gEditChoicesImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gImportChoicesPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gImportChoicesImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gConvertChoicesPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gConvertChoicesImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gFlipPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gFlipImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gPIERandomDesc     : ANEPIEDesc;
   gPIERandomFuncDesc :  FunctionPIEDesc;

   gPIERandomNormalDesc     : ANEPIEDesc;
   gPIERandomNormalFuncDesc :  FunctionPIEDesc;

   gShowLayerDependenciesPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gShowLayerDependenciesImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gImportShapesPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gImportShapesImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor


{procedure GCopyMeshPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  CurrentLayerHandle : ANE_PTR;
  CurrentLayerOptions, FromLayerOptions : TLayerOptions;
begin
  CurrentLayerHandle := ANE_LayerGetCurrent(aneHandle);
  CurrentLayerOptions := TLayerOptions.Create(CurrentLayerHandle);
  FromLayerOptions := TLayerOptions.Create(layerHandle);
  try
    CurrentLayerOptions.Text[aneHandle] := FromLayerOptions.Text[aneHandle];
  finally
    CurrentLayerOptions.Free(aneHandle);
    FromLayerOptions.Free(aneHandle);
  end;
end; }

procedure GU_Random (const refPtX : ANE_DOUBLE_PTR      ;
			   	const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
begin
  result := Random;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GU_RandomNormal (const refPtX : ANE_DOUBLE_PTR      ;
			   	const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param : PParameter_array;
  param1_ptr : ANE_DOUBLE_PTR;
  param2_ptr : ANE_DOUBLE_PTR;
  Mean: double;
  StdDev: double;
begin
  try
    result := invCumNorm(Random);
    param := @parameters^;
    if numParams >= 1 then
    begin
      param1_ptr :=  param^[0];
      Mean := param1_ptr^;
    end
    else
    begin
      Mean := 0;
    end;
    if numParams >= 2 then
    begin
      param2_ptr :=  param^[1];
      StdDev := param2_ptr^;
    end
    else
    begin
      StdDev := 1;
    end;
    if StdDev <= 0 then
    begin
      StdDev := 1;
    end;

    result := result*StdDev + Mean;

    ANE_DOUBLE_PTR(reply)^ := result;
  except on E: Exception do
    begin
      Beep;
      MessageDlg('Error evaluating "URandNormal"" ' + E.Message, mtError,
        [mbOK], 0);
    end;
  end;
{

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
  VersionInfo1: TVersionInfo;
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
}
end;


procedure GEditContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
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
  ALayer : TLayerOptions;
  ShouldRestoreValues: boolean;
begin
  layerHandle := GetExistingLayerWithContours(aneHandle,
    [pieInformationLayer, pieDomainLayer]);

  if layerHandle <> nil then
  begin
    try

      ShouldRestoreValues := CheckArgusVersion(aneHandle, MajorVersion,
        MinorVersion, Update, version, ArgusVersion);

      Project := TProjectOptions.Create;
      try
        if ShouldRestoreValues then
        begin
          OldCopyDelimiter := Project.CopyDelimiter[aneHandle];
          OldCopyIcon := Project.CopyIcon[aneHandle];
          OldCopyName := Project.CopyName[aneHandle];
          OldCopyParameters := Project.CopyParameters[aneHandle];
          OldExportDelimiter := Project.ExportDelimiter[aneHandle];
          OldExportTitles := Project.ExportTitles[aneHandle];

          if OldCopyDelimiter <> #9 then
          begin
            Project.CopyDelimiter[aneHandle] := #9;
          end;
          Project.CopyIcon[aneHandle] := True;
          Project.CopyName[aneHandle] := True;
          Project.CopyParameters[aneHandle] := True;
          if OldExportDelimiter <> #9 then
          begin
            Project.ExportDelimiter[aneHandle] := #9;
          end;
          Project.ExportTitles[aneHandle] := True;
        end;

        ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @InfoText );
        InfoTextString := String(InfoText);

        Application.CreateForm(TfrmEditNew,frmEditNew);
        try
          frmEditNew.ReadArgusContours(InfoTextString, TLocalContour,
            TLocalPoint, #9);

          ALayer := TLayerOptions.Create(layerHandle);
          try
            if ShouldRestoreValues then
            begin
              frmEditNew.zbMain.VerticalExaggeration := ALayer.CoordXYRatio[aneHandle];
            end;
          finally
            ALayer.Free(aneHandle);
          end;

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
          if ShouldRestoreValues then
          begin
            if OldCopyDelimiter <> #9 then
            begin
              Project.CopyDelimiter[aneHandle] := OldCopyDelimiter;
            end;
            Project.CopyIcon[aneHandle] := OldCopyIcon;
            Project.CopyName[aneHandle] := OldCopyName;
            Project.CopyParameters[aneHandle] := OldCopyParameters;
            if OldExportDelimiter <> #9 then
            begin
              Project.ExportDelimiter[aneHandle] := OldExportDelimiter;
            end;
            Project.ExportTitles[aneHandle] := OldExportTitles;
          end;
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
end;

procedure GReverseContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
  OK_Version: boolean;
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
  layerHandle := GetExistingLayer(aneHandle,
    [pieInformationLayer, pieDomainLayer]);

  if layerHandle <> nil then
  begin
    try
      Project := TProjectOptions.Create;
      try
        OK_Version := CheckArgusVersion(aneHandle, MajorVersion,
            MinorVersion, Update, version, ArgusVersion);

        if OK_Version then
        begin
          OldCopyDelimiter := Project.CopyDelimiter[aneHandle];
          OldCopyIcon := Project.CopyIcon[aneHandle];
          OldCopyName := Project.CopyName[aneHandle];
          OldCopyParameters := Project.CopyParameters[aneHandle];
          OldExportDelimiter := Project.ExportDelimiter[aneHandle];
          OldExportTitles := Project.ExportTitles[aneHandle];
        end;

        try
          if OK_Version then
          begin
            if OldCopyDelimiter <> #9 then
            begin
              Project.CopyDelimiter[aneHandle] := #9;
            end;
            Project.CopyIcon[aneHandle] := True;
            Project.CopyName[aneHandle] := True;
            Project.CopyParameters[aneHandle] := True;
            if OldExportDelimiter <> #9 then
            begin
              Project.ExportDelimiter[aneHandle] := #9;
            end;
            Project.ExportTitles[aneHandle] := True;
          end;

          InfoTextString := Clipboard.AsText;

          Application.CreateForm(TfrmEditNew,frmEditNew);
          try
            frmEditNew.ReadArgusContours(InfoTextString, TLocalContour,
              TLocalPoint, #9);
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
          if OK_Version then
          begin
            if OldCopyDelimiter <> #9 then
            begin
              Project.CopyDelimiter[aneHandle] := OldCopyDelimiter;
            end;
            Project.CopyIcon[aneHandle] := OldCopyIcon;
            Project.CopyName[aneHandle] := OldCopyName;
            Project.CopyParameters[aneHandle] := OldCopyParameters;
            if OldExportDelimiter <> #9 then
            begin
              Project.ExportDelimiter[aneHandle] := OldExportDelimiter;
            end;
            Project.ExportTitles[aneHandle] := OldExportTitles;
          end;
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
end;

procedure GData2ContourPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
const
  MaxContours = 500;
var
  DataText : ANE_STR;
  DataTextString : String;
  ImportText : string;
  AString : ANE_STR;
  Layer : TLayerOptions;
  ProjectOptions : TProjectOptions;
  Separator : char;
  ImportLayerHandle : ANE_PTR;
  TurnOnAllowIntersection : boolean;
  EraseContours : boolean;
  LayerType : EPIELayerType;
  NumDataPoints : integer;
begin
  try
    begin
      layerHandle := GetExistingLayer(aneHandle,
        [pieDataLayer]);
      if layerHandle <> nil then
      begin
        ImportLayerHandle := GetExistingLayer(aneHandle,
          [pieInformationLayer, pieMapsLayer, pieDomainLayer]);

        if ImportLayerHandle <> nil then
        begin
          LayerType := ANE_LayerGetType(aneHandle,ImportLayerHandle);
          ProjectOptions := TProjectOptions.Create;
          try
            Separator := ProjectOptions.CopyDelimiter[aneHandle]
          finally
            ProjectOptions.Free;
          end;

          Layer := TLayerOptions.Create(layerHandle);
          try
            NumDataPoints := Layer.NumObjects(aneHandle, pieDataPointObject);
          finally
            Layer.Free(aneHandle);
          end;

          TurnOnAllowIntersection := False;
          if NumDataPoints > MaxContours then
          begin
            TurnOnAllowIntersection := (LayerType = kPIEInformationLayer);
            if TurnOnAllowIntersection then
            begin
              Layer := TLayerOptions.Create(ImportLayerHandle);
              try
                TurnOnAllowIntersection := not Layer.AllowIntersection[aneHandle];
              finally
                Layer.Free(aneHandle);
              end;
              if TurnOnAllowIntersection then
              begin
                Beep;
                TurnOnAllowIntersection := (MessageDlg(
                  'This operation will finish more quickly if '
                  + '"Allow Intersection" is turned on.  Do you want to '
                  + 'turn "Allow Intersection" on?', mtInformation,
                  [mbYes, mbNo], 0) = mrYes);
              end;
            end;
          end;

          EraseContours := False;
          Layer := TLayerOptions.Create(ImportLayerHandle);
          try
            if (Layer.NumObjects(aneHandle,pieContourObject) > 0)
              and (MessageDlg('The layer to which you are importing the data '
                + 'points already has some contours.  Do you want to erase them?',
                mtInformation, [mbYes, mbNo], 0) = mrYes) then
            begin
              EraseContours := True;;
            end;
          finally
            Layer.Free(aneHandle);
          end;

          Screen.Cursor := crHourGlass;
          ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @DataText );
          DataTextString := String(DataText);
          Application.CreateForm(TfrmEditNew,frmEditNew);
          Application.CreateForm(TfrmExportProgress,frmExportProgress);
          try
            frmExportProgress.CurrentModelHandle := aneHandle;
            frmEditNew.ReadArgusData(DataTextString, TLocalContour,
              TLocalPoint, Separator);

            if frmEditNew.ContourList.Count > MaxContours then
            begin
              frmExportProgress.Caption := 'Processing data points';
              frmExportProgress.ProgressBar1.Max :=
                frmEditNew.ContourList.Count div MaxContours + 1;
              frmExportProgress.Cursor := crHourGlass;
              frmExportProgress.Show;
            end;

            if EraseContours or TurnOnAllowIntersection then
            begin
              Layer := TLayerOptions.Create(ImportLayerHandle);
              try
                if TurnOnAllowIntersection then
                begin
                  Layer.AllowIntersection[aneHandle] := True;
                end;

                if EraseContours then
                begin
                  Layer.ClearLayer(aneHandle, False);
                end;
              finally
                Layer.Free(aneHandle);
              end;
            end;

            while frmEditNew.ContourList.Count > 0 do
            begin
              ImportText := frmEditNew.WriteContours(MaxContours);
              GetMem(AString, Length(ImportText) + 1);
              try
                StrPCopy(AString, ImportText);
                ANE_ImportTextToLayerByHandle(aneHandle,ImportLayerHandle, AString);
              finally
                FreeMem(AString);
              end;
              frmExportProgress.ProgressBar1.StepIt;
            end;
          finally
            FreeAndNil(frmEditNew);
            FreeAndNil(frmExportProgress);
            Screen.Cursor := crDefault;
          end;
        end;
      end;
    end;
  except
    on Exception do
       begin
       end;
  end;
end;

procedure ImportMultipleParameters(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmAddParameters, frmAddParameters);
  try
    frmAddParameters.CurrentModelHandle := aneHandle;
    frmAddParameters.GetLayers;
    frmAddParameters.ShowModal;
  finally
    frmAddParameters.Free;
  end;

end;

procedure SetMultipleParameters(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmTree, frmTree);
  try
    frmTree.CurrentModelHandle := aneHandle;
    frmTree.GetData;
    frmTree.ShowModal;
  finally
    frmTree.Free;
  end;
end;

procedure SetMultipleParameterLocks(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
  OK_Version: boolean;
begin
  OK_Version := CheckArgusVersion(aneHandle, MajorVersion,
      MinorVersion, Update, version, ArgusVersion);
  if not OK_Version then
  begin
    Beep;
    MessageDlg('Sorry: This command is not compatible with your version of '
      + 'Argus ONE.', mtInformation, [mbOK], 0);
    Exit;
  end;

  Application.CreateForm(TfrmSetParamLock, frmSetParamLock);
  try
    frmSetParamLock.CurrentModelHandle := aneHandle;
    frmSetParamLock.GetData;
    frmSetParamLock.ShowModal;
  finally
    frmSetParamLock.Free;
  end;
end;

procedure GDeleteLayers(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmDeleteLayer, frmDeleteLayer);
  try
    frmDeleteLayer.CurrentModelHandle := aneHandle;
    frmDeleteLayer.GetLayers;
    frmDeleteLayer.ShowModal;
  finally
    frmDeleteLayer.Free;
  end;

end;

procedure GEditChoicesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
  OK_Version: boolean;
  RadioButton: TRadioButton;
begin
  try
    OK_Version := CheckArgusVersion(aneHandle, MajorVersion,
        MinorVersion, Update, version, ArgusVersion);
    Application.CreateForm(TfrmEdit, frmEdit);
    try
      if not OK_Version then
      begin
        RadioButton := frmEdit.rgChoice.Controls[3] as TRadioButton;
        RadioButton.Enabled := False;
        RadioButton := frmEdit.rgChoice.Controls[6] as TRadioButton;
        RadioButton.Enabled := False;
        RadioButton := frmEdit.rgChoice.Controls[7] as TRadioButton;
        RadioButton.Enabled := False;
      end;
      if frmEdit.ShowModal = mrOK then
      begin
        case frmEdit.rgChoice.ItemIndex of
          0:  // Edit Contours
            begin
              GEditContoursPIE(aneHandle,  fileName, layerHandle);
            end;
          1: // Declutter Contours
            begin
              GDeclutterContoursPIE(aneHandle,  fileName, layerHandle);
            end;
          2:  // Join Contours
            begin
              GJoinContoursPIE(aneHandle,  fileName, layerHandle);
            end;
          3: // Edit Grid
            begin
              GEditGridPIE(aneHandle,  fileName, layerHandle);
            end;
          4: // Edit Data
            begin
              GEditDataLayerPIE(aneHandle,  fileName, layerHandle);
            end;
          5: // Create Parameters in Multiple Layers
            begin
              ImportMultipleParameters(aneHandle,  fileName, layerHandle);
            end;
          6: // Set Multiple Parameters
            begin
              SetMultipleParameters(aneHandle,  fileName, layerHandle);
            end;
          7: // Move
            begin
              GMovePIE(aneHandle,  fileName, layerHandle);
            end;
        else Assert(False);
        end;
      end;
    finally
      frmEdit.Free;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

{procedure GPasteToMultipleLayers(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
begin
  Application.CreateForm(TfrmPasteContours, frmPasteContours);
  try
    frmPasteContours.CurrentModelHandle := aneHandle;
    frmPasteContours.GetLayers;
    frmPasteContours.ShowModal;
  finally
    frmPasteContours.Free;
  end;
end;  }

{procedure GImportChoicesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
  OK_Version: boolean;
  RadioButton: TRadioButton;
begin
  try
    Application.CreateForm(TfrmImportChoices, frmImportChoices);
    try
      OK_Version := CheckArgusVersion(aneHandle, MajorVersion,
          MinorVersion, Update, version, ArgusVersion);
      if not OK_Version then
      begin
        RadioButton := frmImportChoices.rgChoice.Controls[1] as TRadioButton;
        RadioButton.Enabled := False;
        RadioButton := frmImportChoices.rgChoice.Controls[2] as TRadioButton;
        RadioButton.Enabled := False;
      end;
      if frmImportChoices.ShowModal = mrOK then
      begin
        case frmImportChoices.rgChoice.ItemIndex of
          0:  // Import Gridded data
            begin
              GGridDataPIE(aneHandle,  fileName, layerHandle);
            end;
          1: // Import Points from Spreadsheet
            begin
              GImportPointsPIE(aneHandle,  fileName, layerHandle);
            end;
          2:  // Import Contours from Spreadsheet
            begin
              GImportContoursPIE(aneHandle,  fileName, layerHandle);
            end;
          3: // Sample DEM data
            begin
              GImportDEM(aneHandle,  fileName, layerHandle);
            end;
          4: // Copy Tri Mesh
            begin
              GCopyTriQuadMeshPIE(aneHandle,  fileName, layerHandle, True);
            end;
          5: // Copy Quad Mesh
            begin
              GCopyTriQuadMeshPIE(aneHandle,  fileName, layerHandle, False);
            end;
          6 : // Paste Contours on Clipboard to Multiple Layers...
            begin
              GPasteToMultipleLayers(aneHandle,  fileName, layerHandle);
            end;
           7: // Import Data...
             begin
              GEditDataLayerPIE(aneHandle,  fileName, layerHandle, True);
             end;
           8: // Sample Data...
             begin
              GSamplePoints(aneHandle,  fileName, layerHandle);
             end;
        else Assert(False);
        end;
      end;
    finally
      frmImportChoices.Free;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;  }

procedure GConvertChoicesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
  OK_Version: boolean;
  RadioButton: TRadioButton;
begin
  try
    Application.CreateForm(TfrmConvertChoices, frmConvertChoices);
    try
      OK_Version := CheckArgusVersion(aneHandle, MajorVersion,
          MinorVersion, Update, version, ArgusVersion);
      if not OK_Version then
      begin
        RadioButton := frmConvertChoices.rgChoice.Controls[1] as TRadioButton;
        RadioButton.Enabled := False;
        RadioButton := frmConvertChoices.rgChoice.Controls[3] as TRadioButton;
        RadioButton.Enabled := False;
        RadioButton := frmConvertChoices.rgChoice.Controls[4] as TRadioButton;
        RadioButton.Enabled := False;
      end;
      if frmConvertChoices.ShowModal = mrOK then
      begin
        case frmConvertChoices.rgChoice.ItemIndex of
          0:  // Contours to Data
            begin
              GContour2DataPIE(aneHandle,  fileName, layerHandle);
            end;
          1: // Data to Contours
            begin
              GData2ContourPIE(aneHandle,  fileName, layerHandle);
            end;
          2:  // Reverse Contours
            begin
              GReverseContoursPIE(aneHandle,  fileName, layerHandle);
            end;
          3: // Mesh Objects to Contours
            begin
              GMeshToContoursPIE(aneHandle,  fileName, layerHandle);
            end;
          4: // Mesh to Contours
            begin
              GElementsToContoursPIE(aneHandle,  fileName, layerHandle);
            end;
        else Assert(False);
        end;
      end;
    finally
      frmConvertChoices.Free;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
var
  UsualOptions : EFunctionPIEFlags;
  FileName : string;
begin
  {$ASSERTIONS ON}
  {Assertions are a debugging tool. They should be turned off
  in the final version. They are useful for "Just-in-time" debugging
  with Turbo-Debugger 32. See Delphi help for more information.}

  UsualOptions := 0;

  numNames := 0;
{$IFNDEF FLIP}

  FileName := GetDLLName;
  GetDllDirectory(FileName, FileName);
  FileName := FileName + '\Utility.chm';
  Application.HelpFile := FileName;

  gPIEEvalRealFuncDesc.name := 'EvalRealAtXY';	        // name of function
  gPIEEvalRealFuncDesc.address := @GPIEEvalRealAtXYMMFun;		// function address
  gPIEEvalRealFuncDesc.returnType := kPIEFloat;		// return value type
  gPIEEvalRealFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalRealFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalRealFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalRealFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalRealFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalRealFuncDesc.functionFlags := UsualOptions;

  gPIEEvalRealDesc.name  := 'EvalRealAtXY';		// name of PIE
  gPIEEvalRealDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalRealDesc.descriptor := @gPIEEvalRealFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalRealDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEEvalIntFuncDesc.name := 'EvalIntegerAtXY';	        // name of function
  gPIEEvalIntFuncDesc.address := @GPIEEvalIntAtXYMMFun;		// function address
  gPIEEvalIntFuncDesc.returnType := kPIEInteger;		// return value type
  gPIEEvalIntFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalIntFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalIntFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalIntFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalIntFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalIntFuncDesc.functionFlags := UsualOptions;

  gPIEEvalIntDesc.name  := 'EvalIntegerAtXY';		// name of PIE
  gPIEEvalIntDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalIntDesc.descriptor := @gPIEEvalIntFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalIntDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEEvalBoolFuncDesc.name := 'EvalBooleanAtXY';	        // name of function
  gPIEEvalBoolFuncDesc.address := @GPIEEvalBoolAtXYMMFun;		// function address
  gPIEEvalBoolFuncDesc.returnType := kPIEBoolean;		// return value type
  gPIEEvalBoolFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalBoolFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalBoolFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalBoolFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalBoolFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalBoolFuncDesc.functionFlags := UsualOptions;

  gPIEEvalBoolDesc.name  := 'EvalBooleanAtXY';		// name of PIE
  gPIEEvalBoolDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalBoolDesc.descriptor := @gPIEEvalBoolFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalBoolDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEEvalStringFuncDesc.name := 'EvalStringAtXY';	        // name of function
  gPIEEvalStringFuncDesc.address := @GPIEEvalStringAtXYMMFun;		// function address
  gPIEEvalStringFuncDesc.returnType := kPIEString;		// return value type
  gPIEEvalStringFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalStringFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalStringFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalStringFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalStringFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalStringFuncDesc.functionFlags := UsualOptions;

  gPIEEvalStringDesc.name  := 'EvalStringAtXY';		// name of PIE
  gPIEEvalStringDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalStringDesc.descriptor := @gPIEEvalStringFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalStringDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIECheckVersionFDesc.name := 'Utility_CheckVersion';	        // name of function
  gPIECheckVersionFDesc.address := @GPIECheckVersionMMFun;		// function address
  gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
  gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
  gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
  gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
  gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
  gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
  gPIECheckVersionFDesc.functionFlags := UsualOptions;

  gPIECheckVersionDesc.name  := 'Utility_CheckVersion';		// name of PIE
  gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
  gPIECheckVersionDesc.version := ANE_PIE_VERSION;

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIERotatedXFDesc.name := 'Rotated X';	        // name of function
  gPIERotatedXFDesc.address := @GPIERotatedXFun;		// function address
  gPIERotatedXFDesc.returnType := kPIEFloat;		// return value type
  gPIERotatedXFDesc.numParams :=  3;			// number of parameters
  gPIERotatedXFDesc.numOptParams := 0;			// number of optional parameters
  gPIERotatedXFDesc.paramNames := @gpnXYAngle;		// pointer to parameter names list
  gPIERotatedXFDesc.paramTypes := @g3FloatTypes;	// pointer to parameters types list

  gPIERotatedXDesc.name  := 'Rotated X';		// name of PIE
  gPIERotatedXDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIERotatedXDesc.descriptor := @gPIERotatedXFDesc;	// pointer to descriptor

  {$ASSERTIONS ON}
  {Assertions are a debugging tool. They should be turned off
  in the final version. They are useful for "Just-in-time" debugging
  with Turbo-Debugger 32. See Delphi help for more information.}
  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIERotatedXDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIERotatedYFDesc.name := 'Rotated Y';	        // name of function
  gPIERotatedYFDesc.address := @GPIERotatedYFun;		// function address
  gPIERotatedYFDesc.returnType := kPIEFloat;		// return value type
  gPIERotatedYFDesc.numParams :=  3;			// number of parameters
  gPIERotatedYFDesc.numOptParams := 0;			// number of optional parameters
  gPIERotatedYFDesc.paramNames := @gpnXYAngle;		// pointer to parameter names list
  gPIERotatedYFDesc.paramTypes := @g3FloatTypes;	// pointer to parameters types list

  gPIERotatedYDesc.name  := 'Rotated Y';		// name of PIE
  gPIERotatedYDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIERotatedYDesc.descriptor := @gPIERotatedYFDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIERotatedYDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIESec2DayFDesc.name := 'Sec2Day';	        // name of function
  gPIESec2DayFDesc.address := @GPIESec2DayMMFun;		// function address
  gPIESec2DayFDesc.returnType := kPIEFloat;		// return value type
  gPIESec2DayFDesc.numParams :=  1;			// number of parameters
  gPIESec2DayFDesc.numOptParams := 0;			// number of optional parameters
  gPIESec2DayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIESec2DayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIESec2DayPIEDesc.name  := 'Sec2Day';		// name of PIE
  gPIESec2DayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIESec2DayPIEDesc.descriptor := @gPIESec2DayFDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIESec2DayPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEDay2SecFDesc.name := 'Day2Sec';	        // name of function
  gPIEDay2SecFDesc.address := @GPIEDay2SecMMFun;		// function address
  gPIEDay2SecFDesc.returnType := kPIEFloat;		// return value type
  gPIEDay2SecFDesc.numParams :=  1;			// number of parameters
  gPIEDay2SecFDesc.numOptParams := 0;			// number of optional parameters
  gPIEDay2SecFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEDay2SecFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEDay2SecPIEDesc.name  := 'Day2Sec';		// name of PIE
  gPIEDay2SecPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEDay2SecPIEDesc.descriptor := @gPIEDay2SecFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEDay2SecPIEDesc ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEK2FFDesc.name := 'K2F';	        // name of function
  gPIEK2FFDesc.address := @GPIEK2FMMFun;		// function address
  gPIEK2FFDesc.returnType := kPIEFloat;		// return value type
  gPIEK2FFDesc.numParams :=  1;			// number of parameters
  gPIEK2FFDesc.numOptParams := 0;			// number of optional parameters
  gPIEK2FFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEK2FFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEK2FPIEDesc.name  := 'K2F';		// name of PIE
  gPIEK2FPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEK2FPIEDesc.descriptor := @gPIEK2FFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEK2FPIEDesc ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEF2KFDesc.name := 'F2K';	        // name of function
  gPIEF2KFDesc.address := @GPIEF2KMMFun;		// function address
  gPIEF2KFDesc.returnType := kPIEFloat;		// return value type
  gPIEF2KFDesc.numParams :=  1;			// number of parameters
  gPIEF2KFDesc.numOptParams := 0;			// number of optional parameters
  gPIEF2KFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEF2KFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEF2KPIEDesc.name  := 'F2K';		// name of PIE
  gPIEF2KPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEF2KPIEDesc.descriptor := @gPIEF2KFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEF2KPIEDesc ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEJ2BTUFDesc.name := 'J2BTU';	        // name of function
  gPIEJ2BTUFDesc.address := @GPIEJ2BTUMMFun;		// function address
  gPIEJ2BTUFDesc.returnType := kPIEFloat;		// return value type
  gPIEJ2BTUFDesc.numParams :=  1;			// number of parameters
  gPIEJ2BTUFDesc.numOptParams := 0;			// number of optional parameters
  gPIEJ2BTUFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEJ2BTUFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEJ2BTUPIEDesc.name  := 'J2BTU';		// name of PIE
  gPIEJ2BTUPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEJ2BTUPIEDesc.descriptor := @gPIEJ2BTUFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEJ2BTUPIEDesc ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTU2JFDesc.name := 'BTU2J';	        // name of function
  gPIEBTU2JFDesc.address := @GPIEBTU2JMMFun;		// function address
  gPIEBTU2JFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTU2JFDesc.numParams :=  1;			// number of parameters
  gPIEBTU2JFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTU2JFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTU2JFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTU2JPIEDesc.name  := 'BTU2J';		// name of PIE
  gPIEBTU2JPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTU2JPIEDesc.descriptor := @gPIEBTU2JFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTU2JPIEDesc ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIESqm2sqftFDesc.name := 'sq_m2sq_ft';	        // name of function
  gPIESqm2sqftFDesc.address := @GPIESqm2sqftMMFun ;		// function address
  gPIESqm2sqftFDesc.returnType := kPIEFloat;		// return value type
  gPIESqm2sqftFDesc.numParams :=  1;			// number of parameters
  gPIESqm2sqftFDesc.numOptParams := 0;			// number of optional parameters
  gPIESqm2sqftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIESqm2sqftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIESqm2sqftPIEDesc.name  := 'sq_m2sq_ft';		// name of PIE
  gPIESqm2sqftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIESqm2sqftPIEDesc.descriptor := @gPIESqm2sqftFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIESqm2sqftPIEDesc ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIESqft2sqmFDesc.name := 'sq_ft2sq_m';	        // name of function
  gPIESqft2sqmFDesc.address := @GPIESqft2sqmMMFun;		// function address
  gPIESqft2sqmFDesc.returnType := kPIEFloat;		// return value type
  gPIESqft2sqmFDesc.numParams :=  1;			// number of parameters
  gPIESqft2sqmFDesc.numOptParams := 0;			// number of optional parameters
  gPIESqft2sqmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIESqft2sqmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIESqft2sqmPIEDesc.name  := 'sq_ft2sq_m';		// name of PIE
  gPIESqft2sqmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIESqft2sqmPIEDesc.descriptor := @gPIESqft2sqmFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIESqft2sqmPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIECum2CuftFDesc.name := 'cu_m2cu_ft';	        // name of function
  gPIECum2CuftFDesc.address := @GPIECum2CuftMMFun;		// function address
  gPIECum2CuftFDesc.returnType := kPIEFloat;		// return value type
  gPIECum2CuftFDesc.numParams :=  1;			// number of parameters
  gPIECum2CuftFDesc.numOptParams := 0;			// number of optional parameters
  gPIECum2CuftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIECum2CuftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIECum2CuftPIEDesc.name  := 'cu_m2cu_ft';		// name of PIE
  gPIECum2CuftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIECum2CuftPIEDesc.descriptor := @gPIECum2CuftFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIECum2CuftPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIECuft2CumFDesc.name := 'cu_ft2cu_m';	        // name of function
  gPIECuft2CumFDesc.address := @GPIECuft2CumMMFun;		// function address
  gPIECuft2CumFDesc.returnType := kPIEFloat;		// return value type
  gPIECuft2CumFDesc.numParams :=  1;			// number of parameters
  gPIECuft2CumFDesc.numOptParams := 0;			// number of optional parameters
  gPIECuft2CumFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIECuft2CumFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIECuft2CumPIEDesc.name  := 'cu_ft2cu_m';		// name of PIE
  gPIECuft2CumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIECuft2CumPIEDesc.descriptor := @gPIECuft2CumFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIECuft2CumPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEms2footdayFDesc.name := 'm_s2ft_day';	        // name of function
  gPIEms2footdayFDesc.address := @GPIEms2footdayMMFun;		// function address
  gPIEms2footdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEms2footdayFDesc.numParams :=  1;			// number of parameters
  gPIEms2footdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEms2footdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEms2footdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEms2footdayPIEDesc.name  := 'm_s2ft_day';		// name of PIE
  gPIEms2footdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEms2footdayPIEDesc.descriptor := @gPIEms2footdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEms2footdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEfootday2msFDesc.name := 'ft_day2m_s';	        // name of function
  gPIEfootday2msFDesc.address := @GPIEfootday2msMMFun;		// function address
  gPIEfootday2msFDesc.returnType := kPIEFloat;		// return value type
  gPIEfootday2msFDesc.numParams :=  1;			// number of parameters
  gPIEfootday2msFDesc.numOptParams := 0;			// number of optional parameters
  gPIEfootday2msFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEfootday2msFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEfootday2msPIEDesc.name  := 'ft_day2m_s';		// name of PIE
  gPIEfootday2msPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEfootday2msPIEDesc.descriptor := @gPIEfootday2msFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEfootday2msPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEPa2psiFDesc.name := 'Pa2psi';	        // name of function
  gPIEPa2psiFDesc.address := @GPIEPa2psiMMFun;		// function address
  gPIEPa2psiFDesc.returnType := kPIEFloat;		// return value type
  gPIEPa2psiFDesc.numParams :=  1;			// number of parameters
  gPIEPa2psiFDesc.numOptParams := 0;			// number of optional parameters
  gPIEPa2psiFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEPa2psiFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEPa2psiPIEDesc.name  := 'Pa2psi';		// name of PIE
  gPIEPa2psiPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEPa2psiPIEDesc.descriptor := @gPIEPa2psiFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEPa2psiPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEpsi2PaFDesc.name := 'psi2Pa';	        // name of function
  gPIEpsi2PaFDesc.address := @GPIEpsi2PaMMFun;		// function address
  gPIEpsi2PaFDesc.returnType := kPIEFloat;		// return value type
  gPIEpsi2PaFDesc.numParams :=  1;			// number of parameters
  gPIEpsi2PaFDesc.numOptParams := 0;			// number of optional parameters
  gPIEpsi2PaFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEpsi2PaFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEpsi2PaPIEDesc.name  := 'psi2Pa';		// name of PIE
  gPIEpsi2PaPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEpsi2PaPIEDesc.descriptor := @gPIEpsi2PaFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEpsi2PaPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEmpers2ftperdayFDesc.name := 'm_per_s2ft_per_day';	        // name of function
  gPIEmpers2ftperdayFDesc.address := @GPIEmpers2ftperdayMMFun;		// function address
  gPIEmpers2ftperdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEmpers2ftperdayFDesc.numParams :=  1;			// number of parameters
  gPIEmpers2ftperdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEmpers2ftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEmpers2ftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEmpers2ftperdayPIEDesc.name  := 'm_per_s2ft_per_day';		// name of PIE
  gPIEmpers2ftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEmpers2ftperdayPIEDesc.descriptor := @gPIEmpers2ftperdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEmpers2ftperdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEftperday2mpersFDesc.name := 'ft_per_day2m_per_s';	        // name of function
  gPIEftperday2mpersFDesc.address := @GPIEftperday2mpersMMFun;		// function address
  gPIEftperday2mpersFDesc.returnType := kPIEFloat;		// return value type
  gPIEftperday2mpersFDesc.numParams :=  1;			// number of parameters
  gPIEftperday2mpersFDesc.numOptParams := 0;			// number of optional parameters
  gPIEftperday2mpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEftperday2mpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEftperday2mpersPIEDesc.name  := 'ft_per_day2m_per_s';		// name of PIE
  gPIEftperday2mpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEftperday2mpersPIEDesc.descriptor := @gPIEftperday2mpersFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEftperday2mpersPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEsqmpers2sqftperdayFDesc.name := 'sq_m_per_s2sq_ft_per_day';	        // name of function
  gPIEsqmpers2sqftperdayFDesc.address := @GPIEsqmpers2sqftperdayMMFun;		// function address
  gPIEsqmpers2sqftperdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEsqmpers2sqftperdayFDesc.numParams :=  1;			// number of parameters
  gPIEsqmpers2sqftperdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEsqmpers2sqftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEsqmpers2sqftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEsqmpers2sqftperdayPIEDesc.name  := 'sq_m_per_s2sq_ft_per_day';		// name of PIE
  gPIEsqmpers2sqftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEsqmpers2sqftperdayPIEDesc.descriptor := @gPIEsqmpers2sqftperdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEsqmpers2sqftperdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEsqftperday2sqmpersFDesc.name := 'sq_ft_per_day2sq_m_per_s';	        // name of function
  gPIEsqftperday2sqmpersFDesc.address := @GPIEsqftperday2sqmpersMMFun;		// function address
  gPIEsqftperday2sqmpersFDesc.returnType := kPIEFloat;		// return value type
  gPIEsqftperday2sqmpersFDesc.numParams :=  1;			// number of parameters
  gPIEsqftperday2sqmpersFDesc.numOptParams := 0;			// number of optional parameters
  gPIEsqftperday2sqmpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEsqftperday2sqmpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEsqftperday2sqmpersPIEDesc.name  := 'sq_ft_per_day2sq_m_per_s';		// name of PIE
  gPIEsqftperday2sqmpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEsqftperday2sqmpersPIEDesc.descriptor := @gPIEsqftperday2sqmpersFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEsqftperday2sqmpersPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcumpers2cuftperdayFDesc.name := 'cu_m_per_s2cu_ft_per_day';	        // name of function
  gPIEcumpers2cuftperdayFDesc.address := @GPIEcumpers2cuftperdayMMFun;		// function address
  gPIEcumpers2cuftperdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEcumpers2cuftperdayFDesc.numParams :=  1;			// number of parameters
  gPIEcumpers2cuftperdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcumpers2cuftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcumpers2cuftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcumpers2cuftperdayPIEDesc.name  := 'cu_m_per_s2cu_ft_per_day';		// name of PIE
  gPIEcumpers2cuftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcumpers2cuftperdayPIEDesc.descriptor := @gPIEcumpers2cuftperdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcumpers2cuftperdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcuftperday2cumpersFDesc.name := 'cu_ft_per_day2cu_m_per_s';	        // name of function
  gPIEcuftperday2cumpersFDesc.address := @GPIEcuftperday2cumpersMMFun;		// function address
  gPIEcuftperday2cumpersFDesc.returnType := kPIEFloat;		// return value type
  gPIEcuftperday2cumpersFDesc.numParams :=  1;			// number of parameters
  gPIEcuftperday2cumpersFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcuftperday2cumpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcuftperday2cumpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcuftperday2cumpersPIEDesc.name  := 'cu_ft_per_day2cu_m_per_s';		// name of PIE
  gPIEcuftperday2cumpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcuftperday2cumpersPIEDesc.descriptor := @gPIEcuftperday2cumpersFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcuftperday2cumpersPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIElpers2cuftperdayFDesc.name := 'l_per_s2cu_ft_per_day';	        // name of function
  gPIElpers2cuftperdayFDesc.address := @GPIElpers2cuftperdayMMFun;		// function address
  gPIElpers2cuftperdayFDesc.returnType := kPIEFloat;		// return value type
  gPIElpers2cuftperdayFDesc.numParams :=  1;			// number of parameters
  gPIElpers2cuftperdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIElpers2cuftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIElpers2cuftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIElpers2cuftperdayPIEDesc.name  := 'l_per_s2cu_ft_per_day';		// name of PIE
  gPIElpers2cuftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIElpers2cuftperdayPIEDesc.descriptor := @gPIElpers2cuftperdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIElpers2cuftperdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcuftperday2lpersFDesc.name := 'cu_ft_per_day2l_per_s';	        // name of function
  gPIEcuftperday2lpersFDesc.address := @GPIEcuftperday2lpersMMFun;		// function address
  gPIEcuftperday2lpersFDesc.returnType := kPIEFloat;		// return value type
  gPIEcuftperday2lpersFDesc.numParams :=  1;			// number of parameters
  gPIEcuftperday2lpersFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcuftperday2lpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcuftperday2lpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcuftperday2lpersPIEDesc.name  := 'cu_ft_per_day2l_per_s';		// name of PIE
  gPIEcuftperday2lpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcuftperday2lpersPIEDesc.descriptor := @gPIEcuftperday2lpersFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcuftperday2lpersPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEkgpers2lbperdayFDesc.name := 'kg_per_s2lb_per_day';	        // name of function
  gPIEkgpers2lbperdayFDesc.address := @GPIEkgpers2lbperdayMMFun;		// function address
  gPIEkgpers2lbperdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEkgpers2lbperdayFDesc.numParams :=  1;			// number of parameters
  gPIEkgpers2lbperdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEkgpers2lbperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEkgpers2lbperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEkgpers2lbperdayPIEDesc.name  := 'kg_per_s2lb_per_day';		// name of PIE
  gPIEkgpers2lbperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEkgpers2lbperdayPIEDesc.descriptor := @gPIEkgpers2lbperdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEkgpers2lbperdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIElbperday2kgpersFDesc.name := 'lb_per_day2kg_per_s';	        // name of function
  gPIElbperday2kgpersFDesc.address := @GPIElbperday2kgpersMMFun;		// function address
  gPIElbperday2kgpersFDesc.returnType := kPIEFloat;		// return value type
  gPIElbperday2kgpersFDesc.numParams :=  1;			// number of parameters
  gPIElbperday2kgpersFDesc.numOptParams := 0;			// number of optional parameters
  gPIElbperday2kgpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIElbperday2kgpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIElbperday2kgpersPIEDesc.name  := 'lb_per_day2kg_per_s';		// name of PIE
  gPIElbperday2kgpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIElbperday2kgpersPIEDesc.descriptor := @gPIElbperday2kgpersFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIElbperday2kgpersPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEPapers2psiperdayFDesc.name := 'Pa_per_s2psi_per_day';	        // name of function
  gPIEPapers2psiperdayFDesc.address := @GPIEPapers2psiperdayMMFun;		// function address
  gPIEPapers2psiperdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEPapers2psiperdayFDesc.numParams :=  1;			// number of parameters
  gPIEPapers2psiperdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEPapers2psiperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEPapers2psiperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEPapers2psiperdayPIEDesc.name  := 'Pa_per_s2psi_per_day';		// name of PIE
  gPIEPapers2psiperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEPapers2psiperdayPIEDesc.descriptor := @gPIEPapers2psiperdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEPapers2psiperdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEpsiperday2PapersFDesc.name := 'psi_per_day2Pa_per_s';	        // name of function
  gPIEpsiperday2PapersFDesc.address := @GPIEpsiperday2PapersMMFun;		// function address
  gPIEpsiperday2PapersFDesc.returnType := kPIEFloat;		// return value type
  gPIEpsiperday2PapersFDesc.numParams :=  1;			// number of parameters
  gPIEpsiperday2PapersFDesc.numOptParams := 0;			// number of optional parameters
  gPIEpsiperday2PapersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEpsiperday2PapersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEpsiperday2PapersPIEDesc.name  := 'psi_per_day2Pa_per_s';		// name of PIE
  gPIEpsiperday2PapersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEpsiperday2PapersPIEDesc.descriptor := @gPIEpsiperday2PapersFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEpsiperday2PapersPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEkgpercum2lbpercuftFDesc.name := 'kg_per_cu_m2lb_per_cu_ft';	        // name of function
  gPIEkgpercum2lbpercuftFDesc.address := @GPIEkgpercum2lbpercuftMMFun;		// function address
  gPIEkgpercum2lbpercuftFDesc.returnType := kPIEFloat;		// return value type
  gPIEkgpercum2lbpercuftFDesc.numParams :=  1;			// number of parameters
  gPIEkgpercum2lbpercuftFDesc.numOptParams := 0;			// number of optional parameters
  gPIEkgpercum2lbpercuftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEkgpercum2lbpercuftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEkgpercum2lbpercuftPIEDesc.name  := 'kg_per_cu_m2lb_per_cu_ft';		// name of PIE
  gPIEkgpercum2lbpercuftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEkgpercum2lbpercuftPIEDesc.descriptor := @gPIEkgpercum2lbpercuftFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEkgpercum2lbpercuftPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIElbpercuft2kgpercumFDesc.name := 'lb_per_cu_ft2kg_per_cu_m';	        // name of function
  gPIElbpercuft2kgpercumFDesc.address := @GPIElbpercuft2kgpercumMMFun;		// function address
  gPIElbpercuft2kgpercumFDesc.returnType := kPIEFloat;		// return value type
  gPIElbpercuft2kgpercumFDesc.numParams :=  1;			// number of parameters
  gPIElbpercuft2kgpercumFDesc.numOptParams := 0;			// number of optional parameters
  gPIElbpercuft2kgpercumFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIElbpercuft2kgpercumFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIElbpercuft2kgpercumPIEDesc.name  := 'lb_per_cu_ft2kg_per_cu_m';		// name of PIE
  gPIElbpercuft2kgpercumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIElbpercuft2kgpercumPIEDesc.descriptor := @gPIElbpercuft2kgpercumFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIElbpercuft2kgpercumPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEWpercum2BTUperHcuftFDesc.name := 'W_per_cu_m2BTU_per_hr_cu_ft';	        // name of function
  gPIEWpercum2BTUperHcuftFDesc.address := @GPIEWpercum2BTUperHcuftMMFun;		// function address
  gPIEWpercum2BTUperHcuftFDesc.returnType := kPIEFloat;		// return value type
  gPIEWpercum2BTUperHcuftFDesc.numParams :=  1;			// number of parameters
  gPIEWpercum2BTUperHcuftFDesc.numOptParams := 0;			// number of optional parameters
  gPIEWpercum2BTUperHcuftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEWpercum2BTUperHcuftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEWpercum2BTUperHcuftPIEDesc.name  := 'W_per_cu_m2BTU_per_hr_cu_ft';		// name of PIE
  gPIEWpercum2BTUperHcuftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEWpercum2BTUperHcuftPIEDesc.descriptor := @gPIEWpercum2BTUperHcuftFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEWpercum2BTUperHcuftPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperHcuft2WpercumFDesc.name := 'BTU_per_hr_cu_ft2W_per_cu_m';	        // name of function
  gPIEBTUperHcuft2WpercumFDesc.address := @GPIEBTUperHcuft2WpercumMMFun;		// function address
  gPIEBTUperHcuft2WpercumFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperHcuft2WpercumFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperHcuft2WpercumFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperHcuft2WpercumFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperHcuft2WpercumFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperHcuft2WpercumPIEDesc.name  := 'BTU_per_hr_cu_ft2W_per_cu_m';		// name of PIE
  gPIEBTUperHcuft2WpercumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperHcuft2WpercumPIEDesc.descriptor := @gPIEBTUperHcuft2WpercumFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperHcuft2WpercumPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEJperkg2BTUperlbFDesc.name := 'J_per_kg2BTU_per_lb';	        // name of function
  gPIEJperkg2BTUperlbFDesc.address := @GPIEJperkg2BTUperlbMMFun;		// function address
  gPIEJperkg2BTUperlbFDesc.returnType := kPIEFloat;		// return value type
  gPIEJperkg2BTUperlbFDesc.numParams :=  1;			// number of parameters
  gPIEJperkg2BTUperlbFDesc.numOptParams := 0;			// number of optional parameters
  gPIEJperkg2BTUperlbFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEJperkg2BTUperlbFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEJperkg2BTUperlbPIEDesc.name  := 'J_per_kg2BTU_per_lb';		// name of PIE
  gPIEJperkg2BTUperlbPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEJperkg2BTUperlbPIEDesc.descriptor := @gPIEJperkg2BTUperlbFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEJperkg2BTUperlbPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperlb2JperkgFDesc.name := 'BTU_per_lb2J_per_kg';	        // name of function
  gPIEBTUperlb2JperkgFDesc.address := @GPIEBTUperlb2JperkgMMFun;		// function address
  gPIEBTUperlb2JperkgFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperlb2JperkgFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperlb2JperkgFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperlb2JperkgFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperlb2JperkgFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperlb2JperkgPIEDesc.name  := 'BTU_per_lb2J_per_kg';		// name of PIE
  gPIEBTUperlb2JperkgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperlb2JperkgPIEDesc.descriptor := @gPIEBTUperlb2JperkgFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperlb2JperkgPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEJperkg2ftlbfperlbmFDesc.name := 'J_per_kg2ft_lb_f_per_lb_m';	        // name of function
  gPIEJperkg2ftlbfperlbmFDesc.address := @GPIEJperkg2ftlbfperlbmMMFun;		// function address
  gPIEJperkg2ftlbfperlbmFDesc.returnType := kPIEFloat;		// return value type
  gPIEJperkg2ftlbfperlbmFDesc.numParams :=  1;			// number of parameters
  gPIEJperkg2ftlbfperlbmFDesc.numOptParams := 0;			// number of optional parameters
  gPIEJperkg2ftlbfperlbmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEJperkg2ftlbfperlbmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEJperkg2ftlbfperlbmPIEDesc.name  := 'J_per_kg2ft_lb_f_per_lb_m';		// name of PIE
  gPIEJperkg2ftlbfperlbmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEJperkg2ftlbfperlbmPIEDesc.descriptor := @gPIEJperkg2ftlbfperlbmFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEJperkg2ftlbfperlbmPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEftlbfperlbm2JperkgFDesc.name := 'ft_lb_f_per_lb_m2J_per_kg';	        // name of function
  gPIEftlbfperlbm2JperkgFDesc.address := @GPIEftlbfperlbm2JperkgMMFun;		// function address
  gPIEftlbfperlbm2JperkgFDesc.returnType := kPIEFloat;		// return value type
  gPIEftlbfperlbm2JperkgFDesc.numParams :=  1;			// number of parameters
  gPIEftlbfperlbm2JperkgFDesc.numOptParams := 0;			// number of optional parameters
  gPIEftlbfperlbm2JperkgFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEftlbfperlbm2JperkgFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEftlbfperlbm2JperkgPIEDesc.name  := 'ft_lb_f_per_lb_m2J_per_kg';		// name of PIE
  gPIEftlbfperlbm2JperkgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEftlbfperlbm2JperkgPIEDesc.descriptor := @gPIEftlbfperlbm2JperkgFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEftlbfperlbm2JperkgPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcumperkg2cuftperlbFDesc.name := 'cu_m_per_kg2cu_ft_per_lb';	        // name of function
  gPIEcumperkg2cuftperlbFDesc.address := @GPIEcumperkg2cuftperlbMMFun;		// function address
  gPIEcumperkg2cuftperlbFDesc.returnType := kPIEFloat;		// return value type
  gPIEcumperkg2cuftperlbFDesc.numParams :=  1;			// number of parameters
  gPIEcumperkg2cuftperlbFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcumperkg2cuftperlbFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcumperkg2cuftperlbFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcumperkg2cuftperlbPIEDesc.name  := 'cu_m_per_kg2cu_ft_per_lb';		// name of PIE
  gPIEcumperkg2cuftperlbPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcumperkg2cuftperlbPIEDesc.descriptor := @gPIEcumperkg2cuftperlbFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcumperkg2cuftperlbPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcuftperlb2cumperkgFDesc.name := 'cu_ft_per_lb2cu_m_per_kg';	        // name of function
  gPIEcuftperlb2cumperkgFDesc.address := @GPIEcuftperlb2cumperkgMMFun;		// function address
  gPIEcuftperlb2cumperkgFDesc.returnType := kPIEFloat;		// return value type
  gPIEcuftperlb2cumperkgFDesc.numParams :=  1;			// number of parameters
  gPIEcuftperlb2cumperkgFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcuftperlb2cumperkgFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcuftperlb2cumperkgFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcuftperlb2cumperkgPIEDesc.name  := 'cu_ft_per_lb2cu_m_per_kg';		// name of PIE
  gPIEcuftperlb2cumperkgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcuftperlb2cumperkgPIEDesc.descriptor := @gPIEcuftperlb2cumperkgFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcuftperlb2cumperkgPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcumpersqms2cuftpersqftdayFDesc.name := 'cu_m_per_sq_m_s2cu_ft_per_sq_ft_day';	        // name of function
  gPIEcumpersqms2cuftpersqftdayFDesc.address := @GPIEcumpersqms2cuftpersqftdayMMFun;		// function address
  gPIEcumpersqms2cuftpersqftdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEcumpersqms2cuftpersqftdayFDesc.numParams :=  1;			// number of parameters
  gPIEcumpersqms2cuftpersqftdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcumpersqms2cuftpersqftdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcumpersqms2cuftpersqftdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcumpersqms2cuftpersqftdayPIEDesc.name  := 'cu_m_per_sq_m_s2cu_ft_per_sq_ft_day';		// name of PIE
  gPIEcumpersqms2cuftpersqftdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcumpersqms2cuftpersqftdayPIEDesc.descriptor := @gPIEcumpersqms2cuftpersqftdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcumpersqms2cuftpersqftdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcuftpersqftday2cumpersqmsFDesc.name := 'cu_ft_per_sq_ft_day2cu_m_per_sq_m_s';	        // name of function
  gPIEcuftpersqftday2cumpersqmsFDesc.address := @GPIEcuftpersqftday2cumpersqmsMMFun;		// function address
  gPIEcuftpersqftday2cumpersqmsFDesc.returnType := kPIEFloat;		// return value type
  gPIEcuftpersqftday2cumpersqmsFDesc.numParams :=  1;			// number of parameters
  gPIEcuftpersqftday2cumpersqmsFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcuftpersqftday2cumpersqmsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcuftpersqftday2cumpersqmsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcuftpersqftday2cumpersqmsPIEDesc.name  := 'cu_ft_per_sq_ft_day2cu_m_per_sq_m_s';		// name of PIE
  gPIEcuftpersqftday2cumpersqmsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcuftpersqftday2cumpersqmsPIEDesc.descriptor := @gPIEcuftpersqftday2cumpersqmsFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcuftpersqftday2cumpersqmsPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEWpersqm2BTUperHRsqftFDesc.name := 'W_per_sq_m2BTU_per_hr_sq_ft';	        // name of function
  gPIEWpersqm2BTUperHRsqftFDesc.address := @GPIEWpersqm2BTUperHRsqftMMFun;		// function address
  gPIEWpersqm2BTUperHRsqftFDesc.returnType := kPIEFloat;		// return value type
  gPIEWpersqm2BTUperHRsqftFDesc.numParams :=  1;			// number of parameters
  gPIEWpersqm2BTUperHRsqftFDesc.numOptParams := 0;			// number of optional parameters
  gPIEWpersqm2BTUperHRsqftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEWpersqm2BTUperHRsqftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEWpersqm2BTUperHRsqftPIEDesc.name  := 'W_per_sq_m2BTU_per_hr_sq_ft';		// name of PIE
  gPIEWpersqm2BTUperHRsqftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEWpersqm2BTUperHRsqftPIEDesc.descriptor := @gPIEWpersqm2BTUperHRsqftFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEWpersqm2BTUperHRsqftPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperHRsqft2WpersqmFDesc.name := 'BTU_per_hr_sq_ft2W_per_sq_m';	        // name of function
  gPIEBTUperHRsqft2WpersqmFDesc.address := @GPIEBTUperHRsqft2WpersqmMMFun;		// function address
  gPIEBTUperHRsqft2WpersqmFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperHRsqft2WpersqmFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperHRsqft2WpersqmFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperHRsqft2WpersqmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperHRsqft2WpersqmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperHRsqft2WpersqmPIEDesc.name  := 'BTU_per_hr_sq_ft2W_per_sq_m';		// name of PIE
  gPIEBTUperHRsqft2WpersqmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperHRsqft2WpersqmPIEDesc.descriptor := @gPIEBTUperHRsqft2WpersqmFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperHRsqft2WpersqmPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEkgpersqms2lbpersqftdayFDesc.name := 'kg_per_sq_m_s2lb_per_sq_ft_day';	        // name of function
  gPIEkgpersqms2lbpersqftdayFDesc.address := @GPIEkgpersqms2lbpersqftdayMMFun ;		// function address
  gPIEkgpersqms2lbpersqftdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEkgpersqms2lbpersqftdayFDesc.numParams :=  1;			// number of parameters
  gPIEkgpersqms2lbpersqftdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEkgpersqms2lbpersqftdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEkgpersqms2lbpersqftdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEkgpersqms2lbpersqftdayPIEDesc.name  := 'kg_per_sq_m_s2lb_per_sq_ft_day';		// name of PIE
  gPIEkgpersqms2lbpersqftdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEkgpersqms2lbpersqftdayPIEDesc.descriptor := @gPIEkgpersqms2lbpersqftdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEkgpersqms2lbpersqftdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIElbpersqftday2kgpersqmsFDesc.name := 'lb_per_sq_ft_day2kg_per_sq_m_s';	        // name of function
  gPIElbpersqftday2kgpersqmsFDesc.address := @GPIElbpersqftday2kgpersqmsMMFun ;		// function address
  gPIElbpersqftday2kgpersqmsFDesc.returnType := kPIEFloat;		// return value type
  gPIElbpersqftday2kgpersqmsFDesc.numParams :=  1;			// number of parameters
  gPIElbpersqftday2kgpersqmsFDesc.numOptParams := 0;			// number of optional parameters
  gPIElbpersqftday2kgpersqmsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIElbpersqftday2kgpersqmsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIElbpersqftday2kgpersqmsPIEDesc.name  := 'lb_per_sq_ft_day2kg_per_sq_m_s';		// name of PIE
  gPIElbpersqftday2kgpersqmsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIElbpersqftday2kgpersqmsPIEDesc.descriptor := @gPIElbpersqftday2kgpersqmsFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIElbpersqftday2kgpersqmsPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEkgperms2cPFDesc.name := 'kg_per_m_s2cP';	        // name of function
  gPIEkgperms2cPFDesc.address := @GPIEkgperms2cPMMFun ;		// function address
  gPIEkgperms2cPFDesc.returnType := kPIEFloat;		// return value type
  gPIEkgperms2cPFDesc.numParams :=  1;			// number of parameters
  gPIEkgperms2cPFDesc.numOptParams := 0;			// number of optional parameters
  gPIEkgperms2cPFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEkgperms2cPFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEkgperms2cPPIEDesc.name  := 'kg_per_m_s2cP';		// name of PIE
  gPIEkgperms2cPPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEkgperms2cPPIEDesc.descriptor := @gPIEkgperms2cPFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEkgperms2cPPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcP2kgpermsFDesc.name := 'cP2kg_per_m_s';	        // name of function
  gPIEcP2kgpermsFDesc.address := @GPIEcP2kgpermsMMFun ;		// function address
  gPIEcP2kgpermsFDesc.returnType := kPIEFloat;		// return value type
  gPIEcP2kgpermsFDesc.numParams :=  1;			// number of parameters
  gPIEcP2kgpermsFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcP2kgpermsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcP2kgpermsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcP2kgpermsPIEDesc.name  := 'cP2kg_per_m_s';		// name of PIE
  gPIEcP2kgpermsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcP2kgpermsPIEDesc.descriptor := @gPIEcP2kgpermsFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcP2kgpermsPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEJperkgm2BTUperlbftFDesc.name := 'J_per_kg_m2BTU_per_lb_ft';	        // name of function
  gPIEJperkgm2BTUperlbftFDesc.address := @GPIEJperkgm2BTUperlbftMMFun ;		// function address
  gPIEJperkgm2BTUperlbftFDesc.returnType := kPIEFloat;		// return value type
  gPIEJperkgm2BTUperlbftFDesc.numParams :=  1;			// number of parameters
  gPIEJperkgm2BTUperlbftFDesc.numOptParams := 0;			// number of optional parameters
  gPIEJperkgm2BTUperlbftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEJperkgm2BTUperlbftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEJperkgm2BTUperlbftPIEDesc.name  := 'J_per_kg_m2BTU_per_lb_ft';		// name of PIE
  gPIEJperkgm2BTUperlbftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEJperkgm2BTUperlbftPIEDesc.descriptor := @gPIEJperkgm2BTUperlbftFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEJperkgm2BTUperlbftPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperlbft2JperkgmFDesc.name := 'BTU_per_lb_ft2J_per_kg_m';	        // name of function
  gPIEBTUperlbft2JperkgmFDesc.address := @GPIEBTUperlbft2JperkgmMMFun ;		// function address
  gPIEBTUperlbft2JperkgmFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperlbft2JperkgmFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperlbft2JperkgmFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperlbft2JperkgmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperlbft2JperkgmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperlbft2JperkgmPIEDesc.name  := 'BTU_per_lb_ft2J_per_kg_m';		// name of PIE
  gPIEBTUperlbft2JperkgmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperlbft2JperkgmPIEDesc.descriptor := @gPIEBTUperlbft2JperkgmFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperlbft2JperkgmPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEWpermdegC2BTUperlbfthrdgFFDesc.name := 'W_per_m_deg_C2BTU_per_ft_hr_deg_F';	        // name of function
  gPIEWpermdegC2BTUperlbfthrdgFFDesc.address := @GPIEWpermdegC2BTUperfthrdgFMMFun ;		// function address
  gPIEWpermdegC2BTUperlbfthrdgFFDesc.returnType := kPIEFloat;		// return value type
  gPIEWpermdegC2BTUperlbfthrdgFFDesc.numParams :=  1;			// number of parameters
  gPIEWpermdegC2BTUperlbfthrdgFFDesc.numOptParams := 0;			// number of optional parameters
  gPIEWpermdegC2BTUperlbfthrdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEWpermdegC2BTUperlbfthrdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEWpermdegC2BTUperlbfthrdgFPIEDesc.name  := 'W_per_m_deg_C2BTU_per_ft_hr_deg_F';		// name of PIE
  gPIEWpermdegC2BTUperlbfthrdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEWpermdegC2BTUperlbfthrdgFPIEDesc.descriptor := @gPIEWpermdegC2BTUperlbfthrdgFFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEWpermdegC2BTUperlbfthrdgFPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperlbfthrdgF2WpermdegCFDesc.name := 'BTU_per_ft_hr_deg_F2W_per_m_deg_C';	        // name of function
  gPIEBTUperlbfthrdgF2WpermdegCFDesc.address := @GPIEBTUperfthrdgF2WpermdegCMMFun ;		// function address
  gPIEBTUperlbfthrdgF2WpermdegCFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperlbfthrdgF2WpermdegCFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperlbfthrdgF2WpermdegCFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperlbfthrdgF2WpermdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperlbfthrdgF2WpermdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperlbfthrdgF2WpermdegCPIEDesc.name  := 'BTU_per_ft_hr_deg_F2W_per_m_deg_C';		// name of PIE
  gPIEBTUperlbfthrdgF2WpermdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperlbfthrdgF2WpermdegCPIEDesc.descriptor := @gPIEBTUperlbfthrdgF2WpermdegCFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperlbfthrdgF2WpermdegCPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.name := 'W_per_sq_m_deg_C2BTU_per_hr_sq_ft_deg_F';	        // name of function
  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.address := @GPIEWpersqmdegC2BTUperhrsqftdgFMMFun ;		// function address
  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.returnType := kPIEFloat;		// return value type
  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.numParams :=  1;			// number of parameters
  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.numOptParams := 0;			// number of optional parameters
  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc.name  := 'W_per_sq_m_deg_C2BTU_per_lb_sq_ft_hr_deg_F';		// name of PIE
  gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc.descriptor := @gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.name := 'BTU_per_hr_sq_ft_deg_F2W_per_sq_m_deg_C';	        // name of function
  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.address := @GPIEBTUperhrsqftdgF2WpersqmdegCMMFun ;		// function address
  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc.name  := 'BTU_per_lb_sq_ft_hr_deg_F2W_per_sq_m_deg_C';		// name of PIE
  gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc.descriptor := @gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEJperkgdegC2BTUperlbdgFFDesc.name := 'J_per_kg_deg_C2BTU_per_lb_deg_F';	        // name of function
  gPIEJperkgdegC2BTUperlbdgFFDesc.address := @GPIEJperkgdegC2BTUperlbdgFMMFun ;		// function address
  gPIEJperkgdegC2BTUperlbdgFFDesc.returnType := kPIEFloat;		// return value type
  gPIEJperkgdegC2BTUperlbdgFFDesc.numParams :=  1;			// number of parameters
  gPIEJperkgdegC2BTUperlbdgFFDesc.numOptParams := 0;			// number of optional parameters
  gPIEJperkgdegC2BTUperlbdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEJperkgdegC2BTUperlbdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEJperkgdegC2BTUperlbdgFPIEDesc.name  := 'J_per_kg_deg_C2BTU_per_lb_deg_F';		// name of PIE
  gPIEJperkgdegC2BTUperlbdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEJperkgdegC2BTUperlbdgFPIEDesc.descriptor := @gPIEJperkgdegC2BTUperlbdgFFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEJperkgdegC2BTUperlbdgFPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUperlbdgF2JperkgdegCFDesc.name := 'BTU_per_lb_deg_F2J_per_kg_deg_C';	        // name of function
  gPIEBTUperlbdgF2JperkgdegCFDesc.address := @GPIEBTUperlbdgF2JperkgdegCMMFun ;		// function address
  gPIEBTUperlbdgF2JperkgdegCFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUperlbdgF2JperkgdegCFDesc.numParams :=  1;			// number of parameters
  gPIEBTUperlbdgF2JperkgdegCFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUperlbdgF2JperkgdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUperlbdgF2JperkgdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUperlbdgF2JperkgdegCPIEDesc.name  := 'BTU_per_lb_deg_F2J_per_kg_deg_C';		// name of PIE
  gPIEBTUperlbdgF2JperkgdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUperlbdgF2JperkgdegCPIEDesc.descriptor := @gPIEBTUperlbdgF2JperkgdegCFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUperlbdgF2JperkgdegCPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEJpercumdegC2BTUpercuftdgFFDesc.name := 'J_per_cu_m_deg_C2BTU_per_cu_ft_deg_F';	        // name of function
  gPIEJpercumdegC2BTUpercuftdgFFDesc.address := @GPIEJpercumdegC2BTUpercuftdgFMMFun ;		// function address
  gPIEJpercumdegC2BTUpercuftdgFFDesc.returnType := kPIEFloat;		// return value type
  gPIEJpercumdegC2BTUpercuftdgFFDesc.numParams :=  1;			// number of parameters
  gPIEJpercumdegC2BTUpercuftdgFFDesc.numOptParams := 0;			// number of optional parameters
  gPIEJpercumdegC2BTUpercuftdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEJpercumdegC2BTUpercuftdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEJpercumdegC2BTUpercuftdgFPIEDesc.name  := 'J_per_cu_m_deg_C2BTU_per_cu_ft_deg_F';		// name of PIE
  gPIEJpercumdegC2BTUpercuftdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEJpercumdegC2BTUpercuftdgFPIEDesc.descriptor := @gPIEJpercumdegC2BTUpercuftdgFFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEJpercumdegC2BTUpercuftdgFPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEBTUpercuftdgF2JpercumdegCFDesc.name := 'BTU_per_cu_ft_deg_F2J_per_cu_m_deg_C';	        // name of function
  gPIEBTUpercuftdgF2JpercumdegCFDesc.address := @GPIEBTUpercuftdgF2JpercumdegCMMFun ;		// function address
  gPIEBTUpercuftdgF2JpercumdegCFDesc.returnType := kPIEFloat;		// return value type
  gPIEBTUpercuftdgF2JpercumdegCFDesc.numParams :=  1;			// number of parameters
  gPIEBTUpercuftdgF2JpercumdegCFDesc.numOptParams := 0;			// number of optional parameters
  gPIEBTUpercuftdgF2JpercumdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEBTUpercuftdgF2JpercumdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEBTUpercuftdgF2JpercumdegCPIEDesc.name  := 'BTU_per_cu_ft_deg_F2J_per_cu_m_deg_C';		// name of PIE
  gPIEBTUpercuftdgF2JpercumdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEBTUpercuftdgF2JpercumdegCPIEDesc.descriptor := @gPIEBTUpercuftdgF2JpercumdegCFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEBTUpercuftdgF2JpercumdegCPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcumpersmPa2cuftperdaylbsqinFDesc.name := 'cu_m_per_s_m_Pa2cu_ft_per_day_lb_sq_in';	        // name of function
  gPIEcumpersmPa2cuftperdaylbsqinFDesc.address := @GPIEcumpersmPa2cuftperdaylbsqinMMFun ;		// function address
  gPIEcumpersmPa2cuftperdaylbsqinFDesc.returnType := kPIEFloat;		// return value type
  gPIEcumpersmPa2cuftperdaylbsqinFDesc.numParams :=  1;			// number of parameters
  gPIEcumpersmPa2cuftperdaylbsqinFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcumpersmPa2cuftperdaylbsqinFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcumpersmPa2cuftperdaylbsqinFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcumpersmPa2cuftperdaylbsqinPIEDesc.name  := 'cu_m_per_s_m_Pa2cu_ft_per_day_lb_sq_in';		// name of PIE
  gPIEcumpersmPa2cuftperdaylbsqinPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcumpersmPa2cuftperdaylbsqinPIEDesc.descriptor := @gPIEcumpersmPa2cuftperdaylbsqinFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcumpersmPa2cuftperdaylbsqinPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEcuftperdaylbsqin2cumpersmPaFDesc.name := 'cu_ft_per_day_lb_sq_in2cu_m_per_s_m_Pa';	        // name of function
  gPIEcuftperdaylbsqin2cumpersmPaFDesc.address := @GPIEcuftperdaylbsqin2cumpersmPaMMFun ;		// function address
  gPIEcuftperdaylbsqin2cumpersmPaFDesc.returnType := kPIEFloat;		// return value type
  gPIEcuftperdaylbsqin2cumpersmPaFDesc.numParams :=  1;			// number of parameters
  gPIEcuftperdaylbsqin2cumpersmPaFDesc.numOptParams := 0;			// number of optional parameters
  gPIEcuftperdaylbsqin2cumpersmPaFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEcuftperdaylbsqin2cumpersmPaFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEcuftperdaylbsqin2cumpersmPaPIEDesc.name  := 'cu_ft_per_day_lb_sq_in2cu_m_per_s_m_Pa';		// name of PIE
  gPIEcuftperdaylbsqin2cumpersmPaPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEcuftperdaylbsqin2cumpersmPaPIEDesc.descriptor := @gPIEcuftperdaylbsqin2cumpersmPaFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEcuftperdaylbsqin2cumpersmPaPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEm_per_sq_sec2ft_per_sqdayFDesc.name := 'm_per_sq_sec2ft_per_sq_day';	        // name of function
  gPIEm_per_sq_sec2ft_per_sqdayFDesc.address := @GPIEm_per_sq_sec2ft_per_sq_DayMMFun  ;		// function address
  gPIEm_per_sq_sec2ft_per_sqdayFDesc.returnType := kPIEFloat;		// return value type
  gPIEm_per_sq_sec2ft_per_sqdayFDesc.numParams :=  1;			// number of parameters
  gPIEm_per_sq_sec2ft_per_sqdayFDesc.numOptParams := 0;			// number of optional parameters
  gPIEm_per_sq_sec2ft_per_sqdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEm_per_sq_sec2ft_per_sqdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEm_per_sq_sec2ft_per_sqdayPIEDesc.name  := 'm_per_sq_sec2ft_per_sq_day';		// name of PIE
  gPIEm_per_sq_sec2ft_per_sqdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEm_per_sq_sec2ft_per_sqdayPIEDesc.descriptor := @gPIEm_per_sq_sec2ft_per_sqdayFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEm_per_sq_sec2ft_per_sqdayPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEft_per_sqday2m_per_sq_secFDesc.name := 'ft_per_sq_day2m_per_sq_sec';	        // name of function
  gPIEft_per_sqday2m_per_sq_secFDesc.address := @GPIEft_per_sq_Day2m_per_sq_secMMFun ;		// function address
  gPIEft_per_sqday2m_per_sq_secFDesc.returnType := kPIEFloat;		// return value type
  gPIEft_per_sqday2m_per_sq_secFDesc.numParams :=  1;			// number of parameters
  gPIEft_per_sqday2m_per_sq_secFDesc.numOptParams := 0;			// number of optional parameters
  gPIEft_per_sqday2m_per_sq_secFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIEft_per_sqday2m_per_sq_secFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIEft_per_sqday2m_per_sq_secPIEDesc.name  := 'ft_per_sq_day2m_per_sq_sec';		// name of PIE
  gPIEft_per_sqday2m_per_sq_secPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEft_per_sqday2m_per_sq_secPIEDesc.descriptor := @gPIEft_per_sqday2m_per_sq_secFDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEft_per_sqday2m_per_sq_secPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_NearestInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_NearestInterpolatePIEDesc.name := 'QT_Nearest';
  gQT_NearestInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_NearestInterpolatePIEDesc.preProc := @InitializeQT;//InitializeQTN5;		// function address
  gQT_NearestInterpolatePIEDesc.evalProc := @EvaluateQT_Nearest;		// return value type
  gQT_NearestInterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_NearestInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_NearestPIEDesc.name  := 'QT_Nearest';		// name of PIE
  gQT_NearestPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_NearestPIEDesc.descriptor := @gQT_NearestInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_NearestPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5AvgInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5AvgInterpolatePIEDesc.name := 'QT_Mean of 5 Nearest';
  gQT_Nearest5AvgInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5AvgInterpolatePIEDesc.preProc := @InitializeQT;		// function address
  gQT_Nearest5AvgInterpolatePIEDesc.evalProc := @EvaluateQT_5Avg;		// return value type
  gQT_Nearest5AvgInterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest5AvgInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5AvgPIEDesc.name  := 'QT_Mean of 5 Nearest';		// name of PIE
  gQT_Nearest5AvgPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5AvgPIEDesc.descriptor := @gQT_Nearest5AvgInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5AvgPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20AvgInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20AvgInterpolatePIEDesc.name := 'QT_Mean of 20 Nearest';
  gQT_Nearest20AvgInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20AvgInterpolatePIEDesc.preProc := @InitializeQT;		// function address
  gQT_Nearest20AvgInterpolatePIEDesc.evalProc := @EvaluateQT_20Avg;		// return value type
  gQT_Nearest20AvgInterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest20AvgInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20AvgPIEDesc.name  := 'QT_Mean of 20 Nearest';		// name of PIE
  gQT_Nearest20AvgPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20AvgPIEDesc.descriptor := @gQT_Nearest20AvgInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20AvgPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5InvDistSqInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5InvDistSqInterpolatePIEDesc.name := 'QT_Inv Dist Sq of 5 Nearest';
  gQT_Nearest5InvDistSqInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5InvDistSqInterpolatePIEDesc.preProc := @InitializeQT;		// function address
  gQT_Nearest5InvDistSqInterpolatePIEDesc.evalProc := @EvaluateQT_5InvDistSq;		// return value type
  gQT_Nearest5InvDistSqInterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest5InvDistSqInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5InvDistSqPIEDesc.name  := 'QT_Inv Dist Sq of 5 Nearest';		// name of PIE
  gQT_Nearest5InvDistSqPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5InvDistSqPIEDesc.descriptor := @gQT_Nearest5InvDistSqInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5InvDistSqPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20InvDistSqInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20InvDistSqInterpolatePIEDesc.name := 'QT_Inv Dist Sq of 20 Nearest';
  gQT_Nearest20InvDistSqInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20InvDistSqInterpolatePIEDesc.preProc := @InitializeQT;		// function address
  gQT_Nearest20InvDistSqInterpolatePIEDesc.evalProc := @EvaluateQT_20InvDistSq;		// return value type
  gQT_Nearest20InvDistSqInterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest20InvDistSqInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20InvDistSqPIEDesc.name  := 'QT_Inv Dist Sq of 20 Nearest';		// name of PIE
  gQT_Nearest20InvDistSqPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20InvDistSqPIEDesc.descriptor := @gQT_Nearest20InvDistSqInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20InvDistSqPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

{
  // anisotropy = 10
  gQT_NearestA10InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_NearestA10InterpolatePIEDesc.name := 'QT_Nearest (Anis = 10)';
  gQT_NearestA10InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_NearestA10InterpolatePIEDesc.preProc := InitializeAnisotropicQT10;		// function address
  gQT_NearestA10InterpolatePIEDesc.evalProc := EvaluateQT_Nearest;		// return value type
  gQT_NearestA10InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_NearestA10InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_NearestA10PIEDesc.name  := 'QT_Nearest (Anis = 10)';		// name of PIE
  gQT_NearestA10PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_NearestA10PIEDesc.descriptor := @gQT_NearestA10InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_NearestA10PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5AvgA10InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5AvgA10InterpolatePIEDesc.name := 'QT_Mean of 5 Nearest (Anis = 10)';
  gQT_Nearest5AvgA10InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5AvgA10InterpolatePIEDesc.preProc := InitializeAnisotropicQT10;		// function address
  gQT_Nearest5AvgA10InterpolatePIEDesc.evalProc := EvaluateQT_5Avg;		// return value type
  gQT_Nearest5AvgA10InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest5AvgA10InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5AvgA10PIEDesc.name  := 'QT_Mean of 5 Nearest (Anis = 10)';		// name of PIE
  gQT_Nearest5AvgA10PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5AvgA10PIEDesc.descriptor := @gQT_Nearest5AvgA10InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5AvgA10PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20AvgA10InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20AvgA10InterpolatePIEDesc.name := 'QT_Mean of 20 Nearest (Anis = 10)';
  gQT_Nearest20AvgA10InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20AvgA10InterpolatePIEDesc.preProc := InitializeAnisotropicQT10;		// function address
  gQT_Nearest20AvgA10InterpolatePIEDesc.evalProc := EvaluateQT_20Avg;		// return value type
  gQT_Nearest20AvgA10InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest20AvgA10InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20AvgA10PIEDesc.name  := 'QT_Mean of 20 Nearest (Anis = 10)';		// name of PIE
  gQT_Nearest20AvgA10PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20AvgA10PIEDesc.descriptor := @gQT_Nearest20AvgA10InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20AvgA10PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.name := 'QT_Inv Dist Sq of 5 Nearest (Anis = 10)';
  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.preProc := InitializeAnisotropicQT10;		// function address
  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.evalProc := EvaluateQT_5InvDistSq;		// return value type
  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest5InvDistSqA10InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5InvDistSqA10PIEDesc.name  := 'QT_Inv Dist Sq of 5 Nearest (Anis = 10)';		// name of PIE
  gQT_Nearest5InvDistSqA10PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5InvDistSqA10PIEDesc.descriptor := @gQT_Nearest5InvDistSqA10InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5InvDistSqA10PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.name := 'QT_Inv Dist Sq of 20 Nearest (Anis = 10)';
  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.preProc := InitializeAnisotropicQT10;		// function address
  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.evalProc := EvaluateQT_20InvDistSq;		// return value type
  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest20InvDistSqA10InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20InvDistSqA10PIEDesc.name  := 'QT_Inv Dist Sq of 20 Nearest (Anis = 10)';		// name of PIE
  gQT_Nearest20InvDistSqA10PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20InvDistSqA10PIEDesc.descriptor := @gQT_Nearest20InvDistSqA10InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20InvDistSqA10PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names
}
{
  // anisotropy = 30
  gQT_NearestA30InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_NearestA30InterpolatePIEDesc.name := 'QT_Nearest (Anis = 30)';
  gQT_NearestA30InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_NearestA30InterpolatePIEDesc.preProc := InitializeAnisotropicQT30;		// function address
  gQT_NearestA30InterpolatePIEDesc.evalProc := EvaluateQT_Nearest;		// return value type
  gQT_NearestA30InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_NearestA30InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_NearestA30PIEDesc.name  := 'QT_Nearest (Anis = 30)';		// name of PIE
  gQT_NearestA30PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_NearestA30PIEDesc.descriptor := @gQT_NearestA30InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_NearestA30PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5AvgA30InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5AvgA30InterpolatePIEDesc.name := 'QT_Mean of 5 Nearest (Anis = 30)';
  gQT_Nearest5AvgA30InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5AvgA30InterpolatePIEDesc.preProc := InitializeAnisotropicQT30;		// function address
  gQT_Nearest5AvgA30InterpolatePIEDesc.evalProc := EvaluateQT_5Avg;		// return value type
  gQT_Nearest5AvgA30InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest5AvgA30InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5AvgA30PIEDesc.name  := 'QT_Mean of 5 Nearest (Anis = 30)';		// name of PIE
  gQT_Nearest5AvgA30PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5AvgA30PIEDesc.descriptor := @gQT_Nearest5AvgA30InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5AvgA30PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20AvgA30InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20AvgA30InterpolatePIEDesc.name := 'QT_Mean of 20 Nearest (Anis = 30)';
  gQT_Nearest20AvgA30InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20AvgA30InterpolatePIEDesc.preProc := InitializeAnisotropicQT30;		// function address
  gQT_Nearest20AvgA30InterpolatePIEDesc.evalProc := EvaluateQT_20Avg;		// return value type
  gQT_Nearest20AvgA30InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest20AvgA30InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20AvgA30PIEDesc.name  := 'QT_Mean of 20 Nearest (Anis = 30)';		// name of PIE
  gQT_Nearest20AvgA30PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20AvgA30PIEDesc.descriptor := @gQT_Nearest20AvgA30InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20AvgA30PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.name := 'QT_Inv Dist Sq of 5 Nearest (Anis = 30)';
  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.preProc := InitializeAnisotropicQT30;		// function address
  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.evalProc := EvaluateQT_5InvDistSq;		// return value type
  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest5InvDistSqA30InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5InvDistSqA30PIEDesc.name  := 'QT_Inv Dist Sq of 5 Nearest (Anis = 30)';		// name of PIE
  gQT_Nearest5InvDistSqA30PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5InvDistSqA30PIEDesc.descriptor := @gQT_Nearest5InvDistSqA30InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5InvDistSqA30PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.name := 'QT_Inv Dist Sq of 20 Nearest (Anis = 30)';
  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.preProc := InitializeAnisotropicQT30;		// function address
  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.evalProc := EvaluateQT_20InvDistSq;		// return value type
  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.cleanProc :=  FreeQT;			// number of parameters
  gQT_Nearest20InvDistSqA30InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20InvDistSqA30PIEDesc.name  := 'QT_Inv Dist Sq of 20 Nearest (Anis = 30)';		// name of PIE
  gQT_Nearest20InvDistSqA30PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20InvDistSqA30PIEDesc.descriptor := @gQT_Nearest20InvDistSqA30InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20InvDistSqA30PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names
}

  // anisotropy = 100
  gQT_NearestA100InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_NearestA100InterpolatePIEDesc.name := 'QT_Nearest (Anis = 100)';
  gQT_NearestA100InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_NearestA100InterpolatePIEDesc.preProc := @InitializeAnisotropicQT100;		// function address
  gQT_NearestA100InterpolatePIEDesc.evalProc := @EvaluateQT_Nearest;		// return value type
  gQT_NearestA100InterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_NearestA100InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_NearestA100PIEDesc.name  := 'QT_Nearest (Anis = 100)';		// name of PIE
  gQT_NearestA100PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_NearestA100PIEDesc.descriptor := @gQT_NearestA100InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_NearestA100PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5AvgA100InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5AvgA100InterpolatePIEDesc.name := 'QT_Mean of 5 Nearest (Anis = 100)';
  gQT_Nearest5AvgA100InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5AvgA100InterpolatePIEDesc.preProc := @InitializeAnisotropicQT100;		// function address
  gQT_Nearest5AvgA100InterpolatePIEDesc.evalProc := @EvaluateQT_5Avg;		// return value type
  gQT_Nearest5AvgA100InterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest5AvgA100InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5AvgA100PIEDesc.name  := 'QT_Mean of 5 Nearest (Anis = 100)';		// name of PIE
  gQT_Nearest5AvgA100PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5AvgA100PIEDesc.descriptor := @gQT_Nearest5AvgA100InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5AvgA100PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20AvgA100InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20AvgA100InterpolatePIEDesc.name := 'QT_Mean of 20 Nearest (Anis = 100)';
  gQT_Nearest20AvgA100InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20AvgA100InterpolatePIEDesc.preProc := @InitializeAnisotropicQT100;		// function address
  gQT_Nearest20AvgA100InterpolatePIEDesc.evalProc := @EvaluateQT_20Avg;		// return value type
  gQT_Nearest20AvgA100InterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest20AvgA100InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20AvgA100PIEDesc.name  := 'QT_Mean of 20 Nearest (Anis = 100)';		// name of PIE
  gQT_Nearest20AvgA100PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20AvgA100PIEDesc.descriptor := @gQT_Nearest20AvgA100InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20AvgA100PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.name := 'QT_Inv Dist Sq of 5 Nearest (Anis = 100)';
  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.preProc := @InitializeAnisotropicQT100;		// function address
  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.evalProc := @EvaluateQT_5InvDistSq;		// return value type
  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest5InvDistSqA100InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest5InvDistSqA100PIEDesc.name  := 'QT_Inv Dist Sq of 5 Nearest (Anis = 100)';		// name of PIE
  gQT_Nearest5InvDistSqA100PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest5InvDistSqA100PIEDesc.descriptor := @gQT_Nearest5InvDistSqA100InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest5InvDistSqA100PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.name := 'QT_Inv Dist Sq of 20 Nearest (Anis = 100)';
  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.preProc := @InitializeAnisotropicQT100;		// function address
  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.evalProc := @EvaluateQT_20InvDistSq;		// return value type
  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.cleanProc :=  @FreeQT;			// number of parameters
  gQT_Nearest20InvDistSqA100InterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gQT_Nearest20InvDistSqA100PIEDesc.name  := 'QT_Inv Dist Sq of 20 Nearest (Anis = 100)';		// name of PIE
  gQT_Nearest20InvDistSqA100PIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gQT_Nearest20InvDistSqA100PIEDesc.descriptor := @gQT_Nearest20InvDistSqA100InterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gQT_Nearest20InvDistSqA100PIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names



  gModifiedShepardInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gModifiedShepardInterpolatePIEDesc.name := 'Modified Shepard';
  gModifiedShepardInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gModifiedShepardInterpolatePIEDesc.preProc := @InitializeShepard;		// function address
  gModifiedShepardInterpolatePIEDesc.evalProc := @EvaluateShepard;		// return value type
  gModifiedShepardInterpolatePIEDesc.cleanProc :=  @FreeShepard;			// number of parameters
  gModifiedShepardInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gModifiedShepardPIEDesc.name  := 'Modified Shepard';		// name of PIE
  gModifiedShepardPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gModifiedShepardPIEDesc.descriptor := @gModifiedShepardInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gModifiedShepardPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names



  gTriangleInterpInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gTriangleInterpInterpolatePIEDesc.name := 'Triangle Interpolation';
  gTriangleInterpInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gTriangleInterpInterpolatePIEDesc.preProc := @InitializeTriangeInterpolate;		// function address
  gTriangleInterpInterpolatePIEDesc.evalProc := @EvaluateTriangeInterpolate;		// return value type
  gTriangleInterpInterpolatePIEDesc.cleanProc :=  @FreeTriangeInterpolate;			// number of parameters
  gTriangleInterpInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gTriangleInterpPIEDesc.name  := 'Triangle Interpolation';		// name of PIE
  gTriangleInterpPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gTriangleInterpPIEDesc.descriptor := @gTriangleInterpInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gTriangleInterpPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names


  gEditChoicesImportPIEDesc.version := IMPORT_PIE_VERSION;
  gEditChoicesImportPIEDesc.name := 'Edit...';   // name of project
  gEditChoicesImportPIEDesc.importFlags := kImportAllwaysVisible;
  gEditChoicesImportPIEDesc.fromLayerTypes := kPIEAnyLayer  ;
  gEditChoicesImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gEditChoicesImportPIEDesc.doImportProc := @GEditChoicesPIE;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  gEditChoicesPIEDesc.name := 'Edit...';      // PIE name
  gEditChoicesPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gEditChoicesPIEDesc.descriptor := @gEditChoicesImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gEditChoicesPIEDesc;
  Inc(numNames);	// add descriptor to list

  gImportChoicesImportPIEDesc.version := IMPORT_PIE_VERSION;
  gImportChoicesImportPIEDesc.name := 'Import...';   // name of project
  gImportChoicesImportPIEDesc.importFlags := kImportAllwaysVisible;
  gImportChoicesImportPIEDesc.fromLayerTypes := kPIEAnyLayer  ;
  gImportChoicesImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gImportChoicesImportPIEDesc.doImportProc := @GImportChoicesPIE;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  gImportChoicesPIEDesc.name := 'Import...';      // PIE name
  gImportChoicesPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gImportChoicesPIEDesc.descriptor := @gImportChoicesImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gImportChoicesPIEDesc;
  Inc(numNames);	// add descriptor to list

  gConvertChoicesImportPIEDesc.version := IMPORT_PIE_VERSION;
  gConvertChoicesImportPIEDesc.name := 'Convert...';   // name of project
  gConvertChoicesImportPIEDesc.importFlags := kImportAllwaysVisible;
  gConvertChoicesImportPIEDesc.fromLayerTypes := kPIEAnyLayer  ;
  gConvertChoicesImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gConvertChoicesImportPIEDesc.doImportProc := @GConvertChoicesPIE;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  gConvertChoicesPIEDesc.name := 'Convert...';      // PIE name
  gConvertChoicesPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gConvertChoicesPIEDesc.descriptor := @gConvertChoicesImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gConvertChoicesPIEDesc;
  Inc(numNames);	// add descriptor to list   

  gPIERandomFuncDesc.name := 'U_Rand';	        // name of function
  gPIERandomFuncDesc.address := @GU_Random;		// function address
  gPIERandomFuncDesc.returnType := kPIEFloat;		// return value type
  gPIERandomFuncDesc.numParams :=  0;			// number of parameters
  gPIERandomFuncDesc.numOptParams := 0;			// number of optional parameters
  gPIERandomFuncDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIERandomFuncDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

  gPIERandomDesc.name  := 'U_Rand';		// name of PIE
  gPIERandomDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIERandomDesc.descriptor := @gPIERandomFuncDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIERandomDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIERandomNormalFuncDesc.name := 'U_RandNormal';	        // name of function
  gPIERandomNormalFuncDesc.address := @GU_RandomNormal;		// function address
  gPIERandomNormalFuncDesc.returnType := kPIEFloat;		// return value type
  gPIERandomNormalFuncDesc.numParams :=  0;			// number of parameters
  gPIERandomNormalFuncDesc.numOptParams := 2;			// number of optional parameters
  gPIERandomNormalFuncDesc.paramNames := @gpnNumber;		// pointer to parameter names list
  gPIERandomNormalFuncDesc.paramTypes := @g3FloatTypes;	// pointer to parameters types list

  gPIERandomNormalDesc.name  := 'U_RandNormal';		// name of PIE
  gPIERandomNormalDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIERandomNormalDesc.descriptor := @gPIERandomNormalFuncDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIERandomNormalDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gShowLayerDependenciesImportPIEDesc.version := IMPORT_PIE_VERSION;
  gShowLayerDependenciesImportPIEDesc.name := 'Show Layer Dependencies...';   // name of project
  gShowLayerDependenciesImportPIEDesc.importFlags := kImportAllwaysVisible;
  gShowLayerDependenciesImportPIEDesc.fromLayerTypes := kPIEAnyLayer ;
  gShowLayerDependenciesImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gShowLayerDependenciesImportPIEDesc.doImportProc := @GShowLayerDependecy;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  gShowLayerDependenciesPIEDesc.name := 'Show Layer Dependencies...';      // PIE name
  gShowLayerDependenciesPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gShowLayerDependenciesPIEDesc.descriptor := @gShowLayerDependenciesImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gShowLayerDependenciesPIEDesc;
  Inc(numNames);	// add descriptor to list  }

  gImportShapesImportPIEDesc.version := IMPORT_PIE_VERSION;
  gImportShapesImportPIEDesc.name := 'Import Shapefile (with additional options)...';   // name of project
  gImportShapesImportPIEDesc.importFlags := 0;
  gImportShapesImportPIEDesc.fromLayerTypes := kPIEAnyLayer ;
  gImportShapesImportPIEDesc.toLayerTypes := kPIEAnyLayer ;
//    kPIEInformationLayer or kPIEMapsLayer or kPIEDataLayer;
  gImportShapesImportPIEDesc.doImportProc := @GImportShapePIE;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  gImportShapesPIEDesc.name := 'Import Shapefile (with additional options)...';      // PIE name
  gImportShapesPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gImportShapesPIEDesc.descriptor := @gImportShapesImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gImportShapesPIEDesc;
  Inc(numNames);	// add descriptor to list

  if ShowHiddenFunctions then
  begin
    gSetParamLockImportPIEDesc.version := IMPORT_PIE_VERSION;
    gSetParamLockImportPIEDesc.name := 'Set Parameter Locks';   // name of project
    gSetParamLockImportPIEDesc.importFlags := kImportAllwaysVisible;
    gSetParamLockImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
    gSetParamLockImportPIEDesc.toLayerTypes := kPIEAnyLayer;
    gSetParamLockImportPIEDesc.doImportProc := @SetMultipleParameterLocks;// address of Post Processing Function function

    gSetParamLockPIEDesc.name := 'Set Parameter Locks';      // PIE name
    gSetParamLockPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
    gSetParamLockPIEDesc.descriptor := @gSetParamLockImportPIEDesc;	// pointer to descriptor

    Assert (numNames < kMaxFunDesc) ;
    gFunDesc[numNames] := @gSetParamLockPIEDesc;
    Inc(numNames);	// add descriptor to list

    gDeleteLayerImportPIEDesc.version := IMPORT_PIE_VERSION;
    gDeleteLayerImportPIEDesc.name := 'Delete Multiple Layers';   // name of project
    gDeleteLayerImportPIEDesc.importFlags := kImportAllwaysVisible;
    gDeleteLayerImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
    gDeleteLayerImportPIEDesc.toLayerTypes := kPIEAnyLayer;
    gDeleteLayerImportPIEDesc.doImportProc := @GDeleteLayers;// address of Post Processing Function function

    // prepare PIE descriptor for Example Delphi PIE
    gDeleteLayerPIEDesc.name := 'Delete Multiple Layers';      // PIE name
    gDeleteLayerPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
    gDeleteLayerPIEDesc.descriptor := @gDeleteLayerImportPIEDesc;	// pointer to descriptor

    Assert (numNames < kMaxFunDesc) ;
    gFunDesc[numNames] := @gDeleteLayerPIEDesc;
    Inc(numNames);	// add descriptor to list
  end;
{$ELSE}
//   The Flip model command is disabled.
    gFlipImportPIEDesc.version := IMPORT_PIE_VERSION;
    gFlipImportPIEDesc.name := 'Flip Model';   // name of project
    gFlipImportPIEDesc.importFlags := kImportAllwaysVisible;
    gFlipImportPIEDesc.fromLayerTypes := kPIEAnyLayer ;
    gFlipImportPIEDesc.toLayerTypes := kPIEAnyLayer;
    gFlipImportPIEDesc.doImportProc := @GFlipPIE;// address of Post Processing Function function

    // prepare PIE descriptor for Example Delphi PIE
    gFlipPIEDesc.name := 'Flip Model';      // PIE name
    gFlipPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
    gFlipPIEDesc.descriptor := @gFlipImportPIEDesc;	// pointer to descriptor

    Assert (numNames < kMaxFunDesc) ;
    gFunDesc[numNames] := @gFlipPIEDesc;
    Inc(numNames);	// add descriptor to list  }
{$ENDIF}

  descriptors := @gFunDesc;

//  Application.HelpFile
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
    mHHelp := THookHelpSystem.Create(HelpFileFullPath('Utility.chm'), '', htHHexe);
  end;
end;

Initialization
  Randomize;
  InitializeHTMLHELP;

finalization
  mHHelp.Free;
  mHHelp := nil;


end.
