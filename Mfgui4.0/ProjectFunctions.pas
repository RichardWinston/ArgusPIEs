unit ProjectFunctions;

interface

{ProjectFunctions defines the PIE functions for creating a new model,
 editing the non-spatial data of that model, saving and loading models,
 and freeing the model data when the model is closed. It has has a function
 to lock or unlock the recharge elevation as appropriate.  The latter may
 be incorporated into the classes defined in ANE_LayerUnit in the future.}

uses Windows, AnePIE, Forms, sysutils, Controls, classes, Dialogs, Stdctrls;

function GProjectNew(Handle: ANE_PTR; rPIEHandle: ANE_PTR_PTR;
  rLayerTemplate: ANE_STR_PTR): ANE_BOOL; cdecl;

function GEditForm(aneHandle: ANE_PTR;
  PIEHandle: ANE_PTR): ANE_BOOL; cdecl;

procedure GClearForm(aneHandle: ANE_PTR; PIEHandle: ANE_PTR); cdecl;

procedure GSaveForm(aneHandle: ANE_PTR; PIEHandle: ANE_PTR;
  rSaveInfo: ANE_STR_PTR); cdecl;

procedure GLoadForm(aneHandle: ANE_PTR; rPIEHandle: ANE_PTR_PTR;
  const LoadInfo: ANE_STR); cdecl;

function EditForm: boolean;

function IniFile(Handle: HWnd): string;

var
  FormDataAsString: string;
  LayerStructureString: string;
  AnANE_STR: ANE_STR = nil;

implementation

uses
{$IFDEF Debug}
  DebugUnit,
{$ENDIF}
  Variables, ModflowUnit, MFLayerStructureUnit, GetANEFunctionsUnit,
  ANE_LayerUnit, ReadOldUnit, ReadOldMT3D, ANECB, CheckVersionFunction,
  UtilityFunctions, ArgusDataEntry, ArgusFormUnit, FixMoreNamesUnit,
  OptionsUnit, mpathplotUnit, SelectPostFile, ModflowImport, MFGenParam;

var
  VersionChecked: boolean = False;

procedure CheckVersion(const aneHandle: ANE_PTR);
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion: string;
  FormatString: string;
begin
  if not VersionChecked and not CheckArgusVersion(aneHandle,
    MajorVersion, MinorVersion, Update, version, ArgusVersion) then
  begin
    Beep;
    if CheckArgusVersion(aneHandle, MajorVersion, MinorVersion, Update, 'q',
      ArgusVersion) then
    begin
      FormatString := 'Unless you are using the student version of Argus ONE, '
        + 'you are not using the most recent version of Argus ONE.  '
        + 'Although, the MODFLOW GUI will work '
        + 'with this version, a more recent version is available for those '
        + 'who have a full license for Argus ONE.';
    end
    else
    begin
      FormatString := 'You are not using the most recent version of Argus ONE.  '
        + 'You are using version "%s".  The MODFLOW GUI has been most '
        + 'extensively tested with version %d.%d.%.d%s but it may work with '
        + 'some earlier versions of Argus ONE, too.  It would be a good idea '
        + 'to get the current version.';
    end;

    MessageDlg(Format(FormatString,
      [ArgusVersion, MajorVersion, MinorVersion, Update, version]),
      mtWarning, [mbOK], 0);
  end;
  VersionChecked := True;
end;

function EditForm: boolean;
var
  UnreadData: TStringlist;
  VersionInString: string;
begin
  frmMODFLOW.memoDescription.HandleNeeded;
  frmMODFLOW.memoReferences.HandleNeeded;
  FormDataAsString := frmMODFLOW.FormToString(nil, nil,
    rsDeveloper);
  frmMODFLOW.UpdateCaptions;
  if frmMODFLOW.ShowModal = mrOK then
  begin
    frmMODFLOW.MFLayerStructure.OK(frmMODFLOW.CurrentModelHandle);
    if frmMODFLOW.NeedToUpdateMOC3DSubgrid then
    begin
      frmMODFLOW.UpdateMOC3DSubgrid;
      frmMODFLOW.NeedToUpdateMOC3DSubgrid := False;
    end;
    result := True;
  end
  else // if frmMODFLOW.ShowModal = mrOK else
  begin
    Screen.Cursor := crHourGlass;
    frmMODFLOW.Cancelling := True;
    try
      UnreadData := TStringlist.Create;
      try // try 1
        frmMODFLOW.memoDescription.HandleNeeded;
        frmMODFLOW.memoReferences.HandleNeeded;

        frmMODFLOW.LoadModflowForm(UnreadData,
          FormDataAsString, VersionInString);
        frmMODFLOW.SetSubsidenceLayers;
        frmMODFLOW.SetSwtLayers;
      finally
        UnreadData.Free;
      end; // try 1
      frmMODFLOW.MFLayerStructure.Cancel;
      frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
    finally
      Screen.Cursor := crDefault;
      frmMODFLOW.Cancelling := False;
      result := False;
    end;
  end; // if frmMODFLOW.ShowModal = mrOK else
end;

function IniFile(Handle: HWnd): string;
begin
  result := DllAppDirectory(Handle, GetDLLName);
  if not DirectoryExists(result) then
  begin
    CreateDirectoryAndParents(result);
  end;
  result := result + '\modflow.ini.'
//  GetDllDirectory(GetDLLName, result);
end;

function GProjectNew(Handle: ANE_PTR; rPIEHandle: ANE_PTR_PTR;
  rLayerTemplate: ANE_STR_PTR): ANE_BOOL; cdecl;
var
  VersionInString: string;
  Path: string;
  ValFile: TStringList;
  Dummy: string;
begin
  CheckVersion(Handle);
{$IFDEF Debug}
  WriteDebugOutput('Enter GProjectNew');
{$ENDIF}
  if EditWindowOpen then
  begin
    MessageDlg('You can not create a new MODFLOW model while exporting a ' +
      ' project or if an edit box is open.', mtError, [mbOK], 0);
    Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
{$IFDEF Debug}
    WriteDebugOutput('EditWindowOpen := True');
{$ENDIF}
    try // try 1
      frmMODFLOW := nil;
{$IFDEF Debug}
      WriteDebugOutput('frmMODFLOW := nil');
      WriteDebugOutput('no move');
{$ENDIF}
      Application.CreateForm(ModflowTypes.GetModflowFormType, frmMODFLOW);
{$IFDEF Debug}
      WriteDebugOutput('Application.CreateForm(ModflowTypes...');
{$ENDIF}
      frmMODFLOW.CurrentModelHandle := Handle;
      frmMODFLOW.NewModel := True;
{$IFDEF Debug}
      WriteDebugOutput('frmMODFLOW.CurrentModelHandle := Handle');
{$ENDIF}
      try // try 3
        frmMODFLOW.MFLayerStructure :=
          ModflowTypes.GetModflowLayerStructureType.Create;
{$IFDEF Debug}
        WriteDebugOutput('frmMODFLOW.MFLayerStructure :=');
{$ENDIF}
        frmMODFLOW.AssociateUnits;
        frmMODFLOW.AssociateTimes;
        frmMODFLOW.rgFlowPackage.ItemIndex := 1;
        frmMODFLOW.rbMODFLOW2000.Checked := True;
        frmMODFLOW.cbMT3D_OneDArrays.Checked := False;
{$IFDEF Debug}
        WriteDebugOutput('frmMODFLOW.rbMODFLOW2000.Checked := True');
{$ENDIF}
//        if not GetDllDirectory(DLLName, Path) then
//        begin
//          Beep;
//          ShowMessage('Unable to find ' + DLLName);
//        end
//        else
//        begin
          Path := DllAppDirectory(frmMODFLOW.handle, DLLName);

          Path := Path + '\modflow.val';
{$IFDEF Debug}
          WriteDebugOutput('Path := Path + ''\modflow.val');
{$ENDIF}
          if FileExists(Path) then
          begin
            ValFile := TStringList.Create;
{$IFDEF Debug}
            WriteDebugOutput('ValFile := TStringList.Create');
{$ENDIF}
            try // try 4
              ValFile.LoadFromFile(Path);
{$IFDEF Debug}
              WriteDebugOutput('ValFile.LoadFromFile(Path)');
{$ENDIF}
              if Pos('@NPER@', ValFile.Text) = 0 then
              begin
                frmMODFLOW.ReadValFile(VersionInString, Path);
{$IFDEF Debug}
                WriteDebugOutput(
                  'frmMODFLOW.ReadValFile(VersionInString, Path)');
{$ENDIF}
              end
              else
              begin
                BEEP;
                MessageDlg('A val file from a previous version of the '
                  + 'MODFLOW PIE has been detected. It will be ignored. '
                  + 'You should either replace it with a new version '
                  + 'or delete it. It is now much easier to create new '
                  + 'val files. To find out more about val files, go to '
                  + 'The "Advanced Options" tab of the "Edit Project Info" '
                  + 'dialog box and read the online help for the "Save Val '
                  + 'File" button.', mtWarning, [mbOK], 0);
              end;
            finally // try 4
{$IFDEF Debug}
              WriteDebugOutput('ValFile.Free');
{$ENDIF}
              ValFile.Free;
            end;
          end;
{$IFDEF Debug}
          WriteDebugOutput('Path := IniFile');
{$ENDIF}
          Path := IniFile(frmMODFLOW.Handle);
          if FileExists(Path) then
          begin
{$IFDEF Debug}
            WriteDebugOutput('frmMODFLOW.ReadValFile(VersionInString, Path)');
{$ENDIF}
            frmMODFLOW.ReadValFile(VersionInString, Path);
          end;
//        end;
        comboMPATHOutModeHelpContext
          := frmMODFLOW.comboMPATHOutMode.HelpContext;
        comboSensFormatHelpContext
          := frmMODFLOW.comboSensFormat.HelpContext;
        btnModflowImportHelpContext
          := frmMODFLOW.btnModflowImport.HelpContext;
        frmMODFLOW.Loading := False;
{$IFDEF Debug}
        WriteDebugOutput('frmMODFLOW.Loading := False');
{$ENDIF}
        if frmMODFLOW.ShowModal = mrOK then
        begin
          frmMODFLOW.NewModel := False;

          LayerStructureString :=
            frmMODFLOW.MFLayerStructure.WriteLayers(Handle);
          if AnANE_STR <> nil then
          begin
            FreeMem(AnANE_STR);
          end;
          GetMem(AnANE_STR, Length(LayerStructureString) + 1);
          StrPCopy(AnANE_STR, LayerStructureString);

          rLayerTemplate^ := AnANE_STR;
          frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
          result := true;
          frmMODFLOW.Hide;
          ANE_ProcessEvents(Handle);
          if not CheckArgusVersion(Handle, 4, 2, 0, 'e', Dummy) then
          begin
            Beep;
            ShowMessage('By convention, MODFLOW Grids are numbered from the '
              + 'top down rather than from the bottom up. To set this '
              + 'option, activate the MODFLOW FD Grid layer and select '
              + '"Edit|Grid Direction|Negative Y". This option is set '
              + 'automatically in Argus ONE 4.2.0e and later.');
          end;
          rPIEHandle^ := frmMODFLOW;
          frmMODFLOW.CurrentModelHandle := nil;
          frmMODFLOW := nil;
        end
        else
        begin
          frmMODFLOW.Free;
          frmMODFLOW := nil;
          result := false;
        end;
      except on E: Exception do // try a3
        begin
          frmMODFLOW.Free;
          result := False;
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    finally // try 1
      EditWindowOpen := False;
    end; // try 3
  end; // if EditWindowOpen else
end; { GSimpleExportTemplate }

function GEditForm(aneHandle: ANE_PTR;
  PIEHandle: ANE_PTR): ANE_BOOL; cdecl;
begin
  if EditWindowOpen then
  begin
    Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    try // try 1
      try // try 2

        frmMODFLOW := PIEHandle;
        frmMODFLOW.CurrentModelHandle := aneHandle;
        frmMODFLOW.NewModel := False;
        frmMODFLOW.SetCBoundNeeded;
        result := EditForm;
      except on E: Exception do // try 2
        begin
          result := False;
          Beep;
          MessageDlg(E.Message, MtError, [mbOK], 0);
        end;
      end // try 2
    finally
      EditWindowOpen := False;
    end; // try 1
  end; // if EditWindowOpen else
end; { GEditForm }

procedure GClearForm(aneHandle: ANE_PTR; PIEHandle: ANE_PTR); cdecl;
begin
  try
    frmMODFLOW := PIEHandle;
    if (frmMODFLOW <> nil) then
    begin
      frmMODFLOW.CurrentModelHandle := aneHandle;
    end;
    try
      frmMODFLOW.Free;
    finally
      frmMODFLOW := nil;
      if AnANE_STR <> nil then
      begin
        FreeMem(AnANE_STR);
        AnANE_STR := nil;
      end;
    end;
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end
  end;
end; { GClearForm }

procedure GSaveForm(aneHandle: ANE_PTR; PIEHandle: ANE_PTR;
  rSaveInfo: ANE_STR_PTR); cdecl;
var
  ModelPaths: TStringList;
  Warning: string;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not save a file while exporting a ' +
      ' project or if an edit box is open. Save this file again after'
      + ' correcting these problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    try // try 1
      frmMODFLOW := PIEHandle;
      if frmMODFLOW <> nil then
      begin
        frmMODFLOW.CurrentModelHandle := aneHandle;
        // read the data on Form to a string
        frmMODFLOW.NeedToSaveUnitNumbers := True;
        frmMODFLOW.memoDescription.HandleNeeded;
        FormDataAsString := frmMODFLOW.FormToString(frmMODFLOW.lblVersion,
          frmMODFLOW.IgnoreList, rsDeveloper);
        frmMODFLOW.NeedToSaveUnitNumbers := False;
        if AnANE_STR <> nil then
        begin
          FreeMem(AnANE_STR);
        end;
        GetMem(AnANE_STR, Length(FormDataAsString) + 1);
        StrPCopy(AnANE_STR, FormDataAsString);
        try // try 2
          ModelPaths := TStringList.Create;
          try // try3
            frmMODFLOW.ModelPaths(ModelPaths, frmMODFLOW.lblVersion,
              rsDeveloper);
            try
              ModelPaths.SaveToFile(IniFile(frmMODFLOW.Handle));
            except
            end;
          finally
            ModelPaths.Free;
          end; // try 3
        except on E: Exception do
          begin
            Warning := 'The following error occured while saving model. "'
              + E.Message + '" Contact PIE '
              + 'Developer';
            if rsDeveloper <> '' then
            begin
              Warning := Warning + ' (' + rsDeveloper + ')';
            end;
            Warning := Warning + ' for assistance.';
            Beep;
            MessageDlg(Warning, mtError, [mbOK], 0);
          end;
        end; // try 2
      end;
    finally
      EditWindowOpen := False;
    end; // try 1
  end; // if EditWindowOpen else
  rSaveInfo^ := AnANE_STR;
end;

procedure FixGHBExpressions(aneHandle: ANE_PTR);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  UnitIndex: integer;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  LayerName: string;
begin
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);

        // reset Grid Drain parameter expression.
        ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
          ModflowTypes.GetMFGridGHBParamType.ANE_ParamName +
          IntToStr(UnitIndex));

        if ParamIndex > -1 then
        begin
          GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.
            GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
            as T_ANE_GridLayer;

          AParameterList := GridLayer.IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

          AParam := AParameterList.GetParameterByName(ModflowTypes.
            GetMFGridGHBParamType.ANE_ParamName);

          Expression := AParam.Value;

          USetParameterExpression(aneHandle, layerHandle, ParamIndex,
            Expression);
        end;
      end;
    until ParamIndex = -1;
  end;
end;

procedure FixGridGHB_Expressions(aneHandle: ANE_PTR);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  UnitIndex: integer;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  LayerName: string;
begin
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);

        // reset Grid Drain parameter expression.
        ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
          ModflowTypes.GetMFGridGHBParamType.ANE_ParamName +
          IntToStr(UnitIndex));

        if ParamIndex > -1 then
        begin
          GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.
            GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
            as T_ANE_GridLayer;

          AParameterList := GridLayer.IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

          AParam := AParameterList.GetParameterByName(ModflowTypes.
            GetMFGridGHBParamType.ANE_ParamName);

          Expression := AParam.Value;

          USetParameterExpression(aneHandle, layerHandle, ParamIndex,
            Expression);
        end;
      end;
    until ParamIndex = -1;
  end;
end;

procedure FixRiverAndDrainExpressions(aneHandle: ANE_PTR);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  UnitIndex: integer;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  LayerName: string;
begin
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);

        // reset Grid Drain parameter expression.
        ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
          ModflowTypes.GetMFGridDrainParamType.ANE_ParamName +
          IntToStr(UnitIndex));

        if ParamIndex > -1 then
        begin
          GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.
            GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
            as T_ANE_GridLayer;

          AParameterList := GridLayer.IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

          AParam := AParameterList.GetParameterByName(ModflowTypes.
            GetMFGridDrainParamType.ANE_ParamName);

          Expression := AParam.Value;

          USetParameterExpression(aneHandle, layerHandle, ParamIndex,
            Expression);
        end;
      end;
    until ParamIndex = -1;
  end;

  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);

        // reset Grid River parameter expression.
        ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
          ModflowTypes.GetMFGridRiverParamType.ANE_ParamName +
          IntToStr(UnitIndex));
        if ParamIndex > -1 then
        begin
          GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.
            GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
            as T_ANE_GridLayer;

          AParameterList := GridLayer.IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

          AParam := AParameterList.GetParameterByName(ModflowTypes.
            GetMFGridRiverParamType.ANE_ParamName);

          Expression := AParam.Value;

          USetParameterExpression(aneHandle, layerHandle, ParamIndex,
            Expression);
        end;
      end;
    until ParamIndex = -1;
  end;
end;

procedure FixMonitorConcentrationParameters(aneHandle: ANE_PTR);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  LayOptions: TLayerOptions;
  ParamName: string;
  ParamIndex: ANE_INT32;
  OldParamName: string;
  Param: TParameterOptions;
  NewName: String;
  procedure ChangeParamName;
  begin
    LayerHandle := GetLayerHandle(aneHandle, LayerName);
    if LayerHandle <> nil then
    begin
      LayOptions := TLayerOptions.Create(LayerHandle);
      try
        ParamName := NewName;
        ParamIndex := LayOptions.GetParameterIndex(aneHandle,ParamName);
        if ParamIndex < 0 then
        begin
          OldParamName := 'Monitor Concetration';
          ParamIndex := LayOptions.GetParameterIndex(aneHandle,OldParamName);
          if ParamIndex >= 0 then
          begin
            Param := TParameterOptions.Create(LayerHandle, ParamIndex);
            try
              Param.Name[aneHandle] := ParamName;
            finally
              Param.Free;
            end;
          end;
        end;
      finally
        LayOptions.Free(aneHandle);
      end;
    end;
  end;
begin
  NewName := ModflowTypes.
    GetMF_MNW2_MonitorConcentrationParamType.ANE_ParamName;
  LayerName := ModflowTypes.GetMFMNW2_VerticalWellLayerType.ANE_LayerName;
  ChangeParamName;
  LayerName := ModflowTypes.GetMFMNW2_GeneralWellLayerType.ANE_LayerName;
  ChangeParamName;
end;

procedure FixSwtParameters(aneHandle: ANE_PTR);
var
  Index: Integer;
  LayerName: string;
  LayerHandle: ANE_PTR;
  LayOptions: TLayerOptions;
  ParamName: string;
  ParamIndex: ANE_INT32;
  OldParamName: string;
  Param: TParameterOptions;
  ParamNames: TStringList;
  PIndex: Integer;
begin
  ParamNames := TStringList.Create;
  try
    ParamNames.Add(ModflowTypes.
      GetMFInitialEffectiveStressOffsetParamType.ANE_ParamName);
    ParamNames.Add(ModflowTypes.
      GetMFInitialPreconsolidationStressParamType.ANE_ParamName);
    for Index := 1 to frmModflow.UnitCount do
    begin
      LayerName := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName
        + IntToStr(Index);
      LayerHandle := GetLayerHandle(aneHandle, LayerName);
      if LayerHandle <> nil then
      begin
        LayOptions := TLayerOptions.Create(LayerHandle);
        try
          for PIndex := 0 to ParamNames.Count - 1 do
          begin
            ParamName := ParamNames[PIndex];
            ParamIndex := LayOptions.GetParameterIndex(aneHandle,ParamName);
            if ParamIndex < 0 then
            begin
              OldParamName := ParamName + '1';
              ParamIndex := LayOptions.GetParameterIndex(aneHandle,OldParamName);
              if ParamIndex >= 0 then
              begin
                Param := TParameterOptions.Create(LayerHandle, ParamIndex);
                try
                  Param.Name[aneHandle] := ParamName;
                finally
                  Param.Free;
                end;
              end;
            end;
          end;
        finally
          LayOptions.Free(aneHandle);
        end;
      end;
    end;
  finally
    ParamNames.Free;
  end;

end;

procedure FixOldMT3D(aneHandle: ANE_PTR);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  UnitIndex: integer;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  LayerName: string;
  ParameterRoots, OldRoots, NewRoots, OldLayers: TStringList;
  NewLayers, ConcentrationLayers: TStringList;
  Index: integer;
  ParameterName: string;
  OldName, NewName: string;
  OtherLayerHandle: ANE_PTR;
  NewConcentration: string;
  ConcentrationLayerName: string;
  TimeIndex: integer;
const
  OldConcentration = 'MT3D Concentration';
begin
  NewConcentration := ModflowTypes.GetMFConcentrationParamType.ANE_ParamName;
  ParameterRoots := TStringList.Create;
  OldRoots := TStringList.Create;
  NewRoots := TStringList.Create;
  OldLayers := TStringList.Create;
  NewLayers := TStringList.Create;
  ConcentrationLayers := TStringList.Create;
  try
    ConcentrationLayers.Add(ModflowTypes.GetMFWellLayerType.ANE_LayerName);
    ConcentrationLayers.Add(ModflowTypes.
      GetMFPointRiverLayerType.ANE_LayerName);
    ConcentrationLayers.Add(ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName);
    ConcentrationLayers.Add(ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName);
    ConcentrationLayers.Add(ModflowTypes.GetPointGHBLayerType.ANE_LayerName);
    ConcentrationLayers.Add(ModflowTypes.GetLineGHBLayerType.ANE_LayerName);
    ConcentrationLayers.Add(ModflowTypes.GetAreaGHBLayerType.ANE_LayerName);

    OldLayers.Add('MT3D Porosity Unit');
    NewLayers.Add(ModflowTypes.GetMOCPorosityLayerType.ANE_LayerName);

    OldRoots.Add('MT3D Porosity Unit');
    NewRoots.Add(ModflowTypes.GetMFGridMOCPorosityParamType.ANE_ParamName);

    ParameterRoots.Add(ModflowTypes.
      GetMFGridMOCPorosityParamType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.
      GetGridMT3DICBUNDParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.
      GetGridMT3DActiveCellParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.
      GetGridMT3DInitConcCellParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.
      GetGridMT3DObsLocCellParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.
      GetGridMT3DLongDispCellParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.
      GetGridMT3DTimeVaryConcCellParamClassType.ANE_ParamName);

    LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
    LayerHandle := GetLayerHandle(aneHandle, LayerName);
    if LayerHandle <> nil then
    begin
      GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

      UnitIndex := 0;
      repeat // ParamIndex = -1 do
        begin
          Inc(UnitIndex);

          AParameterList := GridLayer.IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(UnitIndex - 1);
          if AParameterList = nil then
            break;

          for Index := 0 to ConcentrationLayers.Count - 1 do
          begin
            ConcentrationLayerName := ConcentrationLayers[Index] +
              IntToStr(UnitIndex);
            OtherLayerHandle := GetLayerHandle(aneHandle,
              ConcentrationLayerName);
            if OtherLayerHandle <> nil then
            begin
              TimeIndex := 0;
              repeat
                Inc(TimeIndex);
                OldName := OldConcentration + IntToStr(TimeIndex);
                ParamIndex := UGetParameterIndex(aneHandle, OtherLayerHandle,
                  OldName);
                if ParamIndex > -1 then
                begin
                  NewName := NewConcentration + IntToStr(TimeIndex);
                  URenameParameter(aneHandle, OtherLayerHandle, ParamIndex,
                    NewName);
                end;
              until ParamIndex < 0;
            end;
          end;

          for Index := 0 to OldLayers.Count - 1 do
          begin
            OldName := OldLayers[Index] + IntToStr(UnitIndex);
            NewName := NewLayers[Index] + IntToStr(UnitIndex);
            OtherLayerHandle := GetLayerHandle(aneHandle, OldName);
            if OtherLayerHandle <> nil then
            begin
              if ULayerRename(aneHandle, OtherLayerHandle, NewName) then
              begin
                ParamIndex := UGetParameterIndex(aneHandle, OtherLayerHandle,
                  OldName);
                if ParamIndex > -1 then
                begin
                  URenameParameter(aneHandle, OtherLayerHandle, ParamIndex,
                    NewName);
                end;
              end;
            end;
          end;

          for Index := 0 to OldRoots.Count - 1 do
          begin
            OldName := OldRoots[Index] + IntToStr(UnitIndex);
            NewName := NewRoots[Index] + IntToStr(UnitIndex);
            ParamIndex := UGetParameterIndex(aneHandle, LayerHandle, OldName);
            if ParamIndex > -1 then
            begin
              URenameParameter(aneHandle, LayerHandle, ParamIndex, NewName);
            end;
          end;

          for Index := 0 to ParameterRoots.Count - 1 do
          begin
            ParameterName := ParameterRoots[Index] + IntToStr(UnitIndex);

            // reset Grid parameter expression.
            ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
              ParameterName);

            if ParamIndex > -1 then
            begin
              AParam :=
                AParameterList.GetParameterByName(ParameterRoots[Index]);

              if AParam <> nil then
              begin
                Expression := AParam.Value;

                USetParameterExpression(aneHandle, layerHandle, ParamIndex,
                  Expression);
              end;
            end;
          end;
        end;
      until AParameterList = nil;
    end;
  finally
    ParameterRoots.Free;
    OldRoots.Free;
    NewRoots.Free;
    OldLayers.Free;
    NewLayers.Free;
    ConcentrationLayers.Free;
  end;
end;

procedure RemoveBadLayers(aneHandle: ANE_PTR);
var
  UnitIndex: integer;
  LayerRoot: string;
  LayerName: string;
  LayerHandle: ANE_PTR;
  GridLayerHandle: ANE_PTR;
  ParameterRoot: string;
  ParameterName: string;
  ParamIndex: integer;
begin
  if frmModflow.cbMOC3D.Checked and (frmModflow.rgMOC3DSolver.ItemIndex = 2)
    then
  begin
    LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
    GridLayerHandle := GetLayerHandle(aneHandle, LayerName);

    UnitIndex := 1;
    ParameterRoot :=
      ModflowTypes.GetMFGridMOCParticleRegenParamType.ANE_ParamName;
    ParameterName := ParameterRoot + '1';
    ParamIndex := ANE_LayerGetParameterByName(aneHandle, GridLayerHandle,
      PChar(ParameterName));
    while ParamIndex >= 0 do
    begin
      ANE_LayerRemoveParameter(aneHandle, GridLayerHandle, ParamIndex, True);
      Inc(UnitIndex);
      ParameterName := ParameterRoot + IntToStr(UnitIndex);
      ParamIndex := ANE_LayerGetParameterByName(aneHandle, GridLayerHandle,
        PChar(ParameterName));
    end;
    ANE_ProcessEvents(aneHandle);

    UnitIndex := 1;
    LayerRoot := ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName;
    LayerName := LayerRoot + '1';
    LayerHandle := GetLayerHandle(aneHandle, PChar(LayerName));
    while LayerHandle <> nil do
    begin
      ANE_LayerRemove(aneHandle, LayerHandle, True);
      Inc(UnitIndex);
      LayerName := LayerRoot + IntToStr(UnitIndex);
      LayerHandle := GetLayerHandle(aneHandle, PChar(LayerName));
    end;
  end;
end;

procedure FixMT3DMSExpressions(aneHandle: ANE_PTR);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  UnitIndex: integer;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  LayerName: string;
  ParamRoots: TStringList;
  Root: string;
  RootIndex: integer;
begin
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    ParamRoots := TStringList.Create;
    try

      ParamRoots.Add(ModflowTypes.GetGridMT3DInitConcCellParamClassType.ANE_ParamName);
      ParamRoots.Add(ModflowTypes.GetGridMT3DInitConc2ParamClassType.ANE_ParamName);
      ParamRoots.Add(ModflowTypes.GetGridMT3DInitConc3ParamClassType.ANE_ParamName);
      ParamRoots.Add(ModflowTypes.GetGridMT3DInitConc4ParamClassType.ANE_ParamName);
      ParamRoots.Add(ModflowTypes.GetGridMT3DInitConc5ParamClassType.ANE_ParamName);

      for RootIndex := 0 to ParamRoots.Count -1 do
      begin
        Root := ParamRoots[RootIndex];
        UnitIndex := 0;

        repeat
          begin
            Inc(UnitIndex);

            // reset parameter expression.
            ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
              Root + IntToStr(UnitIndex));

            if ParamIndex > -1 then
            begin
              GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.
                GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
                as T_ANE_GridLayer;

              AParameterList := GridLayer.IndexedParamList1.
                GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

              AParam := AParameterList.GetParameterByName(Root);

              If AParam <> nil then
              begin
                Expression := AParam.Value;

                USetParameterExpression(aneHandle, layerHandle, ParamIndex,
                  Expression);
              end;
            end;
          end;
        until ParamIndex = -1;
      end;
    finally
      ParamRoots.Free;
    end;
  end;
end;


procedure FixMOC3DExpressions(aneHandle: ANE_PTR);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  UnitIndex: integer;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  LayerName: string;
begin
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat // ParamIndex = -1 do
      begin
        Inc(UnitIndex);

        // reset parameter expression.
        ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
          ModflowTypes.GetMFGridMOCParticleRegenParamType.ANE_ParamName +
          IntToStr(UnitIndex));

        if ParamIndex > -1 then
        begin
          GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.
            GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
            as T_ANE_GridLayer;

          AParameterList := GridLayer.IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

          AParam := AParameterList.GetParameterByName(ModflowTypes.
            GetMFGridMOCParticleRegenParamType.ANE_ParamName);

          If AParam <> nil then
          begin
            Expression := AParam.Value;

            USetParameterExpression(aneHandle, layerHandle, ParamIndex,
              Expression);
          end;
        end;
      end;
    until ParamIndex = -1;
  end;
end;

procedure FixParameterExpressions(aneHandle: ANE_PTR);
var
  NUnits: integer;
  UnitIndex: integer;
  LayerList: T_ANE_IndexedLayerList;
  ALayer: T_ANE_InfoLayer;
  AParam: T_ANE_Param;
  ParameterOptions: TParameterOptions;
  LayerHandle: ANE_PTR;
  ParameterIndex: ANE_INT32;
  procedure UpdateExpression;
  begin
    if ALayer <> nil then
    begin
      LayerHandle := ALayer.GetLayerHandle(aneHandle);
      if LayerHandle <> nil then
      begin
        AParam := ALayer.ParamList.GetParameterByName
          (ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
        if AParam <> nil then
        begin
          ParameterIndex := AParam.GetParameterIndex
            (aneHandle, False, LayerHandle);
          if ParameterIndex >= 0 then
          begin
            ParameterOptions := TParameterOptions.Create(LayerHandle,
              ParameterIndex);
            try
              ParameterOptions.Expr[aneHandle] := AParam.Value;
            finally
              ParameterOptions.Free;
            end;
          end;
        end;
      end;
    end;
  end;
begin
  NUnits := frmModflow.UnitCount;
  for UnitIndex := 0 to NUnits - 1 do
  begin
    LayerList := frmModflow.MFLayerStructure.
      ListsOfIndexedLayers.GetNonDeletedIndLayerListByIndex(UnitIndex);
    if LayerList <> nil then
    begin
      if frmModflow.cbWEL.Checked then
      begin
        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFWellLayerType.ANE_LayerName) as T_ANE_InfoLayer;
        UpdateExpression;

        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFLineWellLayerType.ANE_LayerName) as
          T_ANE_InfoLayer;
        UpdateExpression;

        if frmModflow.cbUseAreaWells.Checked then
        begin
          ALayer := LayerList.GetLayerByName
            (ModflowTypes.GetMFAreaWellLayerType.ANE_LayerName) as
            T_ANE_InfoLayer;
          UpdateExpression;
        end;
      end;

      if frmModflow.cbRIV.Checked then
      begin
        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName) as
          T_ANE_InfoLayer;
        UpdateExpression;

        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName) as
          T_ANE_InfoLayer;
        UpdateExpression;

        if frmModflow.cbUseAreaRivers.Checked then
        begin
          ALayer := LayerList.GetLayerByName
            (ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName) as
            T_ANE_InfoLayer;
          UpdateExpression;
        end;
      end;

      if frmModflow.cbDRN.Checked then
      begin
        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName) as
          T_ANE_InfoLayer;
        UpdateExpression;

        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetLineDrainLayerType.ANE_LayerName) as T_ANE_InfoLayer;
        UpdateExpression;

        if frmMODFLOW.cbUseAreaDrains.Checked then
        begin
          ALayer := LayerList.GetLayerByName
            (ModflowTypes.GetAreaDrainLayerType.ANE_LayerName) as
            T_ANE_InfoLayer;
          UpdateExpression;
        end;
      end;

      if frmModflow.cbGHB.Checked then
      begin
        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetPointGHBLayerType.ANE_LayerName) as T_ANE_InfoLayer;
        UpdateExpression;

        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetLineGHBLayerType.ANE_LayerName) as T_ANE_InfoLayer;
        UpdateExpression;

        if frmMODFLOW.cbUseAreaGHBs.Checked then
        begin
          ALayer := LayerList.GetLayerByName
            (ModflowTypes.GetAreaGHBLayerType.ANE_LayerName) as T_ANE_InfoLayer;
          UpdateExpression;
        end;
      end;

      if frmModflow.cbHFB.Checked then
      begin
        ALayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFHFBLayerType.ANE_LayerName) as T_ANE_InfoLayer;
        UpdateExpression;
      end;
    end;
  end;
end;

procedure FixOldNames(aneHandle: ANE_PTR; const VersionInString: string);
var
  LayerHandle: ANE_PTR;
  ParamIndex: ANE_INT32;
  OldParamName, NewParamName: string;
  UnitIndex: integer;
  LayerName: string;
  OldLayerName, NewLayerName: string;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  AParam: T_ANE_Param;
  Expression: string;
  ShowMessage: boolean;
  NeedToUpdateConductances: boolean;
  ConductanceLayers: TStringList;
  ConductanceIndex: integer;
begin
  Application.CreateForm(ModflowTypes.GetWarningsFormType, frmWarnings);
  try
    frmWarnings.CurrentModelHandle := aneHandle;

    if frmModflow.rbMODFLOW2000.Checked and frmModflow.cbMOC3D.Checked then
    begin
      LayerName := ModflowTypes.GetMOCTransSubGridLayerType.WriteNewRoot;
      LayerHandle := GetLayerHandle(aneHandle, LayerName);
      if LayerHandle = nil then
      begin
        LayerName := ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName;
        LayerHandle := GetLayerHandle(aneHandle, LayerName);
        if LayerHandle <> nil then
        begin
          ULayerRename(aneHandle, layerHandle,
            ModflowTypes.GetMOCTransSubGridLayerType.WriteNewRoot);

          frmWarnings.memoWarnings.Lines.Add('The layer "'
            + ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName
            + '" has been changed to "'
            + ModflowTypes.GetMOCTransSubGridLayerType.WriteNewRoot + '".');
        end;
      end;
      if LayerHandle <> nil then
      begin
        ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
          ModflowTypes.GetMFMOCTransSubGridParamType.WriteParamName);
        if ParamIndex < 0 then
        begin
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            ModflowTypes.GetMFMOCTransSubGridParamType.ANE_ParamName);
          if ParamIndex > -1 then
          begin
            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              ModflowTypes.GetMFMOCTransSubGridParamType.WriteParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + ModflowTypes.GetMOCTransSubGridLayerType.WriteNewRoot
              + '", the parameter "'
              + ModflowTypes.GetMFMOCTransSubGridParamType.ANE_ParamName
              + '" has been changed to "'
              + ModflowTypes.GetMFMOCTransSubGridParamType.WriteParamName +
              '".');
          end;
        end;
      end;

      LayerName := ModflowTypes.GetMOCObsWellLayerType.WriteNewRoot;
      LayerHandle := GetLayerHandle(aneHandle, LayerName);
      if LayerHandle = nil then
      begin
        LayerName := ModflowTypes.GetMOCObsWellLayerType.ANE_LayerName;
        LayerHandle := GetLayerHandle(aneHandle, LayerName);
        if LayerHandle <> nil then
        begin
          ULayerRename(aneHandle, layerHandle,
            ModflowTypes.GetMOCObsWellLayerType.WriteNewRoot);

          frmWarnings.memoWarnings.Lines.Add('The layer "'
            + ModflowTypes.GetMOCObsWellLayerType.ANE_LayerName
            + '" has been changed to "'
            + ModflowTypes.GetMOCObsWellLayerType.WriteNewRoot + '".');
        end;
      end;
    end;

    LayerHandle := ANE_LayerGetHandleByName(aneHandle,
      'MODFLOW Grid Density');
    if LayerHandle <> nil then
    begin
      ULayerRename(aneHandle, layerHandle,
        ModflowTypes.GetDensityLayerType.ANE_LayerName);

      frmWarnings.memoWarnings.Lines.Add('The layer "MODFLOW Grid Density" '
        + 'has been changed to "'
        + ModflowTypes.GetDensityLayerType.ANE_LayerName + '".');

      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        'Density');
      if ParamIndex > -1 then
      begin
        URenameParameter(aneHandle, LayerHandle, ParamIndex,
          ModflowTypes.GetMFDensityParamType.ANE_ParamName);

        frmWarnings.memoWarnings.Lines.Add('On the layer "'
          + ModflowTypes.GetDensityLayerType.ANE_LayerName
          + '", the parameter "Density" has been changed to "'
          + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');
      end;

      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        'MODFLOW Grid Density');
      if ParamIndex > -1 then
      begin
        URenameParameter(aneHandle, LayerHandle, ParamIndex,
          ModflowTypes.GetMFDensityParamType.ANE_ParamName);

        frmWarnings.memoWarnings.Lines.Add('On the layer "'
          + ModflowTypes.GetDensityLayerType.ANE_LayerName
          + '", the parameter "MODFLOW Grid Density" has been changed to "'
          + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');
      end;
    end;

    LayerHandle := ANE_LayerGetHandleByName(aneHandle,
      'MODFLOW Grid Cell Size');
    if LayerHandle <> nil then
    begin
      ULayerRename(aneHandle, layerHandle,
        ModflowTypes.GetDensityLayerType.ANE_LayerName);

      frmWarnings.memoWarnings.Lines.Add('The layer "MODFLOW Cell Size" '
        + 'has been changed to "'
        + ModflowTypes.GetDensityLayerType.ANE_LayerName + '".');

      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        'MODFLOW Grid Cell Size');
      if ParamIndex > -1 then
      begin
        URenameParameter(aneHandle, LayerHandle, ParamIndex,
          ModflowTypes.GetMFDensityParamType.ANE_ParamName);

        frmWarnings.memoWarnings.Lines.Add('On the layer "'
          + ModflowTypes.GetDensityLayerType.ANE_LayerName
          + '", the parameter "MODFLOW Grid Cell Size" has been changed to "'
          + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');
      end;

      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        'MODFLOW Grid Density');
      if ParamIndex > -1 then
      begin
        URenameParameter(aneHandle, LayerHandle, ParamIndex,
          ModflowTypes.GetMFDensityParamType.ANE_ParamName);

        frmWarnings.memoWarnings.Lines.Add('On the layer "'
          + ModflowTypes.GetDensityLayerType.ANE_LayerName
          + '", the parameter "MODFLOW Grid Density" has been changed to "'
          + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');
      end;
    end;

    LayerName := ModflowTypes.GetMFDomainOutType.ANE_LayerName;
    LayerHandle := GetLayerHandle(aneHandle, LayerName);
    if LayerHandle <> nil then
    begin

      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        'Density');
      if ParamIndex > -1 then
      begin
        URenameParameter(aneHandle, LayerHandle, ParamIndex,
          ModflowTypes.GetMFDomDensityParamType.ANE_ParamName);

        frmWarnings.memoWarnings.Lines.Add('On the layer "'
          + ModflowTypes.GetMFDomainOutType.ANE_LayerName
          + '", the parameter "Density" has been changed to "'
          + ModflowTypes.GetMFDomDensityParamType.ANE_ParamName + '".');
      end;

      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        'MODFLOW Grid Density');
      if ParamIndex > -1 then
      begin
        URenameParameter(aneHandle, LayerHandle, ParamIndex,
          ModflowTypes.GetMFDomDensityParamType.ANE_ParamName);

        frmWarnings.memoWarnings.Lines.Add('On the layer "'
          + ModflowTypes.GetMFDomainOutType.ANE_LayerName
          + '", the parameter "MODFLOW Grid Density" has been changed to "'
          + ModflowTypes.GetMFDomDensityParamType.ANE_ParamName + '".');
      end;
    end;

    LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
    LayerHandle := GetLayerHandle(aneHandle, LayerName);
    if LayerHandle <> nil then
    begin
      UnitIndex := 0;
      repeat // ParamIndex = -1 do
        begin
          Inc(UnitIndex);

          OldParamName := 'Prescribed Concentration Unit' +
            IntToStr(UnitIndex);
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName :=
              ModflowTypes.GetMFGridMOCPrescribedConcParamType.ANE_ParamName +
              IntToStr(UnitIndex);

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + ModflowTypes.GetGridLayerType.ANE_LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');
          end;

          OldParamName := 'ZoneBudget Zone Unit' + IntToStr(UnitIndex);
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName :=
              ModflowTypes.GetMFGridZoneBudgetParamType.ANE_ParamName +
              IntToStr(UnitIndex);

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + ModflowTypes.GetGridLayerType.ANE_LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');

            GridLayer :=
              frmModflow.MFLayerStructure.UnIndexedLayers.GetLayerByName
              (ModflowTypes.GetGridLayerType.ANE_LayerName) as
              T_ANE_GridLayer;

            AParameterList := GridLayer.IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(UnitIndex - 1);

            AParam := AParameterList.GetParameterByName(ModflowTypes.
              GetMFGridZoneBudgetParamType.ANE_ParamName);

            Expression := AParam.Value;

            USetParameterExpression(aneHandle, layerHandle, ParamIndex,
              Expression);
          end;
        end;
      until ParamIndex = -1;
    end;

    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);
        OldLayerName := 'ZoneBudget Unit' + IntToStr(UnitIndex);
        LayerHandle := GetLayerHandle(aneHandle, OldLayerName);
        if LayerHandle <> nil then
        begin
          NewLayerName := ModflowTypes.GetZoneBudLayerType.ANE_LayerName +
            IntToStr(UnitIndex);
          ULayerRename(aneHandle, layerHandle, NewLayerName);

          frmWarnings.memoWarnings.Lines.Add('The layer "' + OldLayerName + '" '
            + 'has been changed to "'
            + NewLayerName + '".');
        end;
      end;
    until LayerHandle = nil;

    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);
        LayerName := ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName +
          IntToStr(UnitIndex);
        LayerHandle := GetLayerHandle(aneHandle, LayerName);
        if LayerHandle <> nil then
        begin
          OldParamName := 'Bottom';
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName :=
              ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName;

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');
          end;
        end;
      end;
    until LayerHandle = nil;

    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);
        LayerName := ModflowTypes.GetMFDaflowLayerType.ANE_LayerName +
          IntToStr(UnitIndex);
        LayerHandle := GetLayerHandle(aneHandle, LayerName);
        if LayerHandle <> nil then
        begin
          OldParamName := 'OVERRIDEN INITIAL FLOW';
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName := ModflowTypes.
              GetMFDaflowOverrideInitialFlowParamClassType.ANE_ParamName;

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');
          end;

          OldParamName := 'OVERRIDEN BED ELEVATION';
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName := ModflowTypes.
              GetMFDaflowOverridenBedElevationParamClassType.ANE_ParamName;

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');
          end;
        end;
      end;
    until LayerHandle = nil;

    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);
        LayerName := ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName +
          IntToStr(UnitIndex);
        LayerHandle := GetLayerHandle(aneHandle, LayerName);
        if LayerHandle <> nil then
        begin
          OldParamName := 'Bottom';
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName :=
              ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName;

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');
          end;
        end;
      end;
    until LayerHandle = nil;

    UnitIndex := 0;
    repeat
      begin
        Inc(UnitIndex);
        LayerName :=
          ModflowTypes.GetMFAdvectionObservationsLayerType.WriteNewRoot +
          IntToStr(UnitIndex);
        LayerHandle := GetLayerHandle(aneHandle, LayerName);
        if LayerHandle <> nil then
        begin
          OldParamName := 'Observation Number';
          ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
            OldParamName);

          if ParamIndex > -1 then
          begin
            NewParamName :=
              ModflowTypes.GetMFXObsNumberParamType.WriteParamName;

            URenameParameter(aneHandle, LayerHandle, ParamIndex,
              NewParamName);

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');
          end;
        end;
      end;
    until LayerHandle = nil;

    NeedToUpdateConductances := not frmMODFLOW.PieIsEarlier(VersionInString,
      '4.18.0.1', False);
    if NeedToUpdateConductances then
    begin
      ConductanceLayers := TStringList.Create;
      try
        ConductanceLayers.Add(ModflowTypes.GetLineDrainLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.GetAreaDrainLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.
          GetMFLineRiverLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.
          GetMFAreaRiverLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.GetLineGHBLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.GetAreaGHBLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.
          GetMFLineDrainReturnLayerType.WriteNewRoot);
        ConductanceLayers.Add(ModflowTypes.
          GetMFAreaDrainReturnLayerType.WriteNewRoot);

        for ConductanceIndex := 0 to ConductanceLayers.Count - 1 do
        begin
          UnitIndex := 0;
          repeat
            begin
              Inc(UnitIndex);
              LayerName := ConductanceLayers[ConductanceIndex] +
                IntToStr(UnitIndex);
              LayerHandle := GetLayerHandle(aneHandle, LayerName);
              if LayerHandle <> nil then
              begin
                OldParamName := kMFConductance;
                ParamIndex := UGetParameterIndex(aneHandle, LayerHandle,
                  OldParamName);

                if ParamIndex > -1 then
                begin
                  NewParamName := kMFConductanceFactor;

                  URenameParameter(aneHandle, LayerHandle, ParamIndex,
                    NewParamName);

                  frmWarnings.memoWarnings.Lines.Add('On the layer "'
                    + LayerName
                    + '", the parameter "' + OldParamName +
                    '" has been changed to "'
                    + NewParamName + '".');
                end;
              end;
            end;
          until LayerHandle = nil;
        end;
      finally
        ConductanceLayers.Free;
      end;
    end;

    FixMoreOldNames(aneHandle);

    ShowMessage := False;
    if frmMODFLOW.cbDRN.Checked then
    begin
      LayerName := ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName + '1';
      LayerHandle := GetLayerHandle(aneHandle, LayerName);
      if LayerHandle = nil then
      begin
        ShowMessage := True;
      end;
    end;

    CheckForMoreNewLayers(aneHandle, ShowMessage);

    if ShowMessage then
    begin
      Beep;
      MessageDlg('The PIE needs to add some new layers or parameters. '
        + 'This can not be done '
        + 'while a file is being loaded. As soon as the file is finished '
        + 'loading, please select "PIEs|Edit Project Info" and then click '
        + 'the "OK" button. This will add the needed layers.', mtInformation,
        [mbOK], 0);
    end;

    if frmWarnings.memoWarnings.Lines.Count > 0 then
    begin
      Beep;
      frmWarnings.ShowModal;
    end;
  finally
    frmWarnings.Free;
  end;
end;

procedure GLoadForm(aneHandle: ANE_PTR; rPIEHandle: ANE_PTR_PTR;
  const LoadInfo: ANE_STR); cdecl;
  procedure UpdateCombos;
  var
    Index: integer;
    AComboBox: TCombobox;
  begin
{$IFDEF Debug}
    try
      WriteDebugOutput('Enter GLoadForm -- UpdateCombos');
{$ENDIF}
      for Index := 0 to frmMODFLOW.ComponentCount - 1 do
      begin
        if frmMODFLOW.Components[Index] is TComboBox then
        begin
          AComboBox := TComboBox(frmMODFLOW.Components[Index]);
          if Assigned(AComboBox.OnChange) then
          begin
            AComboBox.OnChange(AComboBox);
          end;
        end;
      end;
{$IFDEF Debug}
    finally
      WriteDebugOutput('Exit GLoadForm -- UpdateCombos');
    end;
{$ENDIF}
  end;
var
  UnreadData: TStringlist;
  VersionInString: string;
  DummyString: string;
  DataToRead: string;
  Developer: string;
  ADE: TArgusDataEntry;
  Index: integer;
  Path: string;
  needToUpdateRiverOrDrain: boolean;
  NeedToUpdateMocPrescribedConc: boolean;
  NeedToUpdateModel: boolean;
  NeedToUpdateMOC3d: boolean;
  NeedToUpdateIsParamExpression: boolean;
  NeedToUpdateHFB: boolean;
  NeedToUpdateStream: boolean;
  NeedToUpdateADVObs: boolean;
  NeedToUpdateMT3D: boolean;
  NeedToUpdateLake: boolean;
  NeedToUpdateObservations: boolean;
  LMG_UsedInOldModel: boolean;
  NeedToUpdateGHB: boolean;
  NeedToUpdateMT3DExpressions: boolean;
  NeedToUpdateGridGHBExpression: boolean;
  NeedToUpdateMNW: boolean;
  NeedToUpdateMt3dModel: boolean;
  NeedToUpdateHeadObsLayerParameters: boolean;
  NeedToUpdateSWT: boolean;
  NeedToUpdateMnwPtob: Boolean;
  NeedToUpdateMonitorConcentration: Boolean;
begin
  CheckVersion(aneHandle);
{$IFDEF Debug}
  try
    WriteDebugOutput('Enter GLoadForm');
    WriteDebugOutput('Argus Version = ' + GetArgusVersion(aneHandle));
    WriteDebugOutput('aneHandle ' + IntToStr(Integer(aneHandle)));
    WriteDebugOutput('rPIEHandle ' + IntToStr(Integer(rPIEHandle)));
    WriteDebugOutput('LoadInfo ' + string(LoadInfo));
{$ENDIF}
    if EditWindowOpen then
    begin
{$IFDEF Debug}
      WriteDebugOutput('EditWindowOpen True');
{$ENDIF}
      Beep;
      MessageDlg('Error: You must close all dialog boxes before attempting '
        + 'to open another file! Close the dialog box in the other model. '
        + 'Then close this file WITHOUT saving it. '
        + 'Then you will be able to open this file.'
        , mtError, [mbOK], 0);
      rPIEHandle^ := nil;
    end
    else
    begin
{$IFDEF Debug}
      WriteDebugOutput('EditWindowOpen False');
{$ENDIF}
//      needToUpdateRiverOrDrain := False;
//      NeedToUpdateMocPrescribedConc := False;
      NeedToUpdateIsParamExpression := False;
      NeedToUpdateADVObs := False;
//      NeedToUpdateHFB := False;
//      NeedToUpdateStream := True;
      NeedToUpdateMT3D := False;
      NeedToUpdateLake := False;
      NeedToUpdateObservations := False;
//      NeedToUpdateGHB := False;
      NeedToUpdateMT3DExpressions := False;
//      NeedToUpdateGridGHBExpression := False;
      NeedToUpdateMNW := False;
      NeedToUpdateMt3dModel := False;
      NeedToUpdateHeadObsLayerParameters := False;
      NeedToUpdateSWT := False;
      NeedToUpdateMnwPtob := False;
      NeedToUpdateMonitorConcentration := False;
      Developer := '';
      LMG_UsedInOldModel := False;
      try
        UnreadData := TStringlist.Create;
        try
{$IFDEF Debug}
          WriteDebugOutput('before frmMODFLOW creation');
{$ENDIF}
          frmMODFLOW := ModflowTypes.GetModflowFormType.Create(nil);
{$IFDEF Debug}
          WriteDebugOutput('after frmMODFLOW creation');
{$ENDIF}
          frmMODFLOW.CurrentModelHandle := aneHandle;
          rPIEHandle^ := frmMODFLOW;
{$IFDEF Debug}
          WriteDebugOutput('before MFLayerStructure creation');
{$ENDIF}
          frmMODFLOW.cbAreaWellContour.Checked := False;
          frmMODFLOW.cbAreaRiverContour.Checked := False;
          frmMODFLOW.cbAreaDrainContour.Checked := False;
          frmMODFLOW.cbAreaDrainRetrunContour.Checked := False;

          frmMODFLOW.MFLayerStructure :=
            ModflowTypes.GetModflowLayerStructureType.Create;

{$IFDEF Debug}
          WriteDebugOutput('after MFLayerStructure creation');
{$ENDIF}
          frmMODFLOW.AssociateUnits;
          frmMODFLOW.AssociateTimes;
{$IFDEF Debug}
          WriteDebugOutput('after frmMODFLOW.AssociateTimes');
{$ENDIF}

          frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
{$IFDEF Debug}
          WriteDebugOutput(
            'after frmMODFLOW.MFLayerStructure.SetStatus(sNormal)');
{$ENDIF}
          DataToRead := string(LoadInfo);
          if IsOldFile(DataToRead) then
          begin
{$IFDEF Debug}
            WriteDebugOutput('IsOldFile(DataToRead) True');
{$ENDIF}
            frmMODFLOW.lblDebugVersion.Caption := 'Old MODFLOW File';
            needToUpdateRiverOrDrain := frmMODFLOW.cbRIV.Checked
              or frmMODFLOW.cbDRN.Checked;
            NeedToUpdateGHB := frmMODFLOW.cbGHB.Checked;
            NeedToUpdateMocPrescribedConc := frmMODFLOW.cbMOC3D.Checked;
            NeedToUpdateHFB := frmMODFLOW.cbHFB.Checked;
            NeedToUpdateMOC3d := frmMODFLOW.cbMOC3D.Checked;
            frmMODFLOW.NeedToUpdateMOC3DSubgrid := frmModflow.cbMOC3D.Checked;
            frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
            frmMODFLOW.cbExpDIS.Checked := False;
            UpdateCombos;
            NeedToUpdateStream := frmMODFLOW.cbSTR.Checked;
            NeedToUpdateModel := True;
            NeedToUpdateGridGHBExpression := frmModflow.cbGHB.Checked;
          end
          else
          begin
{$IFDEF Debug}
            WriteDebugOutput('IsOldFile(DataToRead) False');
{$ENDIF}
            if IsOldMT3DFile(DataToRead) then
            begin
{$IFDEF Debug}
              WriteDebugOutput('IsOldMT3DFile(DataToRead) True');
{$ENDIF}
              frmMODFLOW.lblDebugVersion.Caption := 'Old MT3D File';
              needToUpdateRiverOrDrain := frmMODFLOW.cbRIV.Checked
                or frmMODFLOW.cbDRN.Checked;
              NeedToUpdateGHB := frmMODFLOW.cbGHB.Checked;
              NeedToUpdateMocPrescribedConc := frmMODFLOW.cbMOC3D.Checked;
              NeedToUpdateMOC3d := frmMODFLOW.cbMOC3D.Checked;
              NeedToUpdateHFB := frmMODFLOW.cbHFB.Checked;
              frmMODFLOW.NeedToUpdateMOC3DSubgrid :=
                frmModflow.cbMOC3D.Checked;
              frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
              NeedToUpdateStream := frmMODFLOW.cbSTR.Checked;
              frmMODFLOW.cbExpDIS.Checked := False;
              UpdateCombos;
              NeedToUpdateModel := True;
              NeedToUpdateMT3D := True;
              NeedToUpdateMT3DExpressions := frmMODFLOW.cbMT3D.Checked;
              NeedToUpdateGridGHBExpression := frmModflow.cbGHB.Checked;
            end
            else
            begin
{$IFDEF Debug}
              WriteDebugOutput('IsOldMT3DFile(DataToRead) False');
{$ENDIF}
              frmMODFLOW.LoadModflowForm(UnreadData, DataToRead,
                VersionInString);
              frmMODFLOW.SetMaxFileNameLength;
              frmMODFLOW.cbExpDIS.Checked := frmMODFLOW.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked;
              // update zonebudget captions
              // They used to be numbers instead of letters
              frmMODFLOW.SetZoneBudgetCompositeZoneTitles;
              frmMODFLOW.FixMOC3D;
              frmMODFLOW.lblDebugVersion.Caption := VersionInString;
              try
                frmMODFLOW.NewModel := True;
                frmMODFLOW.UpdateHUF_Units;
              finally
                frmMODFLOW.NewModel := False;
              end;
              frmMODFLOW.SetSubsidenceLayers;
              frmMODFLOW.SetSwtLayers;
              if frmMODFLOW.cb_GWM.Checked then
              begin
                frmMODFLOW.btnImportFlowVar1Click(nil);
              end;

{$IFDEF Debug}
              WriteDebugOutput('after frmMODFLOW.LoadModflowForm');
{$ENDIF}
              frmMODFLOW.NeedToUpdateMOC3DSubgrid :=
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '2.0.13.0', False)
                and frmModflow.cbMOC3D.Checked;
              if not frmMODFLOW.PieIsEarlier(VersionInString,
                '2.0.15.0', False) then
              begin
                frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
              end;
              needToUpdateRiverOrDrain := (frmMODFLOW.cbRIV.Checked
                or frmMODFLOW.cbDRN.Checked) and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.19.0.7', False);
              NeedToUpdateGHB := (frmMODFLOW.cbRIV.Checked
                or frmMODFLOW.cbDRN.Checked) and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.20.0.3', False);
              NeedToUpdateMocPrescribedConc := frmMODFLOW.cbMOC3D.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '3.0.12.0', False);
              NeedToUpdateModel := not frmMODFLOW.PieIsEarlier
                (VersionInString, '3.9.7.0', False);
              NeedToUpdateMOC3d := frmMODFLOW.cbMOC3D.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.0.12.0', False);
              NeedToUpdateIsParamExpression :=
                frmMODFLOW.PieIsEarlier(VersionInString,
                '3.9.9.9', False)
                and not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.0.5.0', False);
              NeedToUpdateHFB := frmMODFLOW.cbHFB.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.4.1.2', False);
              NeedToUpdateStream := frmMODFLOW.cbSTR.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.7.5.0', False);
              NeedToUpdateADVObs := frmMODFLOW.rbMODFLOW2000.Checked and
                frmMODFLOW.cbObservations.Checked and
                frmMODFLOW.cbAdvObs.Checked and
                frmMODFLOW.cbSpecifyAdvCovariances.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.4.1.5', False);
              NeedToUpdateMT3D := frmMODFLOW.cbMT3D.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.6.9.0', False);
              NeedToUpdateLake := frmMODFLOW.cbLAK.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.7.4.1', False);
              NeedToUpdateObservations := frmMODFLOW.cbObservations.Checked
                and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.10.2.0', False);
              LMG_UsedInOldModel := (frmMODFLOW.rgSolMeth.ItemIndex = 4) and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.11.0.1', False);
              NeedToUpdateMT3DExpressions := frmMODFLOW.cbMT3D.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.20.1.10', False);
              NeedToUpdateGridGHBExpression := frmModflow.cbGHB.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.20.2.2', False);
              NeedToUpdateMNW := frmModflow.cbMNW.Checked and
                not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.25.0.3', False);
              NeedToUpdateMt3dModel := frmModflow.cbMT3D.Checked
                and not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.24.0.4', False);
              NeedToUpdateHeadObsLayerParameters :=
                frmModflow.cbObservations.Checked
                and (frmModflow.cbHeadObservations.Checked
                or frmModflow.cbWeightedHeadObservations.Checked
                or frmModflow.cbAdvObs.Checked
                or frmModflow.cbHeadFluxObservations.Checked
                or frmModflow.cbGHBObservations.Checked
                or frmModflow.cbDRNObservations.Checked
                or frmModflow.cbRIVObservations.Checked
                or frmModflow.cbDRTObservations.Checked
                )
                and not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.28.2.2', False);
              NeedToUpdateSWT := frmModflow.cbSWT.Checked
                and not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.32.0.6', False);
              NeedToUpdateMnwPtob := frmModflow.cbMOC3D.Checked
                and frmModflow.cbMnw2.Checked
                and frmModflow.cbParticleObservations.Checked
                and not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.35.0.1', False);
              NeedToUpdateMonitorConcentration := frmModflow.cbMOC3D.Checked
                and frmModflow.cbMnw2.Checked
                and frmModflow.cbMnwi.Checked
                and not frmMODFLOW.PieIsEarlier(VersionInString,
                '4.35.0.1', False);
            end;
          end;
{$IFDEF Debug}
          WriteDebugOutput(
            'before for Index := 0 to frmMODFLOW.ComponentCount -1 do');
{$ENDIF}
          for Index := 0 to frmMODFLOW.ComponentCount - 1 do
          begin
{$IFDEF Debug}
            WriteDebugOutput('Index ' + IntToStr(Index));
{$ENDIF}
            if frmMODFLOW.Components[Index] is TArgusDataEntry then
            begin
              ADE := TArgusDataEntry(frmMODFLOW.Components[Index]);
{$IFDEF Debug}
              WriteDebugOutput('ADE.Name ' + ADE.Name);
{$ENDIF}
              ADE.CheckRange;
            end;
          end;
          Path := IniFile(frmMODFLOW.Handle);
{$IFDEF Debug}
          WriteDebugOutput('Path ' + Path);
{$ENDIF}
          if FileExists(Path) then
          begin
{$IFDEF Debug}
            WriteDebugOutput('FileExists(Path) True');
{$ENDIF}
            frmMODFLOW.ReadValFile(DummyString, Path);
{$IFDEF Debug}
            WriteDebugOutput(
              'after frmMODFLOW.ReadValFile(VersionInString, Path)');
{$ENDIF}
          end;
          if needToUpdateRiverOrDrain then
          begin
{$IFDEF Debug}
            WriteDebugOutput('needToUpdateRiverOrDrain True');
{$ENDIF}
            FixRiverAndDrainExpressions(aneHandle);
{$IFDEF Debug}
            WriteDebugOutput('after FixRiverAndDrainExpressions');
{$ENDIF}
          end;
          if NeedToUpdateGHB then
          begin
            FixGHBExpressions(aneHandle);
          end;

          if NeedToUpdateMOC3d then
          begin
{$IFDEF Debug}
            WriteDebugOutput('NeedToUpdateMOC3d True');
{$ENDIF}
            FixMOC3DExpressions(aneHandle);
{$IFDEF Debug}
            WriteDebugOutput('after FixMOC3DExpressions');
{$ENDIF}
          end;
          if NeedToUpdateMT3D then
          begin
            FixOldMT3D(aneHandle);
          end;

          if NeedToUpdateMT3DExpressions then
          begin
            FixMT3DMSExpressions(aneHandle);
          end;

          if NeedToUpdateGridGHBExpression then
          begin
            FixGridGHB_Expressions(aneHandle);
          end;

          if NeedToUpdateSWT then
          begin
            FixSwtParameters(aneHandle);
          end;

          if NeedToUpdateMonitorConcentration then
          begin
            FixMonitorConcentrationParameters(aneHandle);
          end;            

          if frmMODFLOW.NeedToUpdateMOC3DSubgrid or needToUpdateRiverOrDrain
            or NeedToUpdateMocPrescribedConc or NeedToUpdateModel
            or NeedToUpdateHFB or NeedToUpdateStream or NeedToUpdateADVObs
            or NeedToUpdateMT3D or NeedToUpdateLake or NeedToUpdateObservations
            or NeedToUpdateGHB or NeedToUpdateMNW or NeedToUpdateMt3dModel
            or NeedToUpdateHeadObsLayerParameters or NeedToUpdateSWT
            or NeedToUpdateMnwPtob or NeedToUpdateMonitorConcentration then
          begin
{$IFDEF Debug}
            WriteDebugOutput(
              'frmMODFLOW.NeedToUpdateMOC3DSubgrid, etc. = True');
{$ENDIF}
            Beep;
            showMessage('You will need to select "PIEs|Edit Project Info" '
              + 'and then click on the OK button to update some information in '
              + 'this model. All needed changes will be made automatically '
              + 'when you do this.')
          end;
          if NeedToUpdateStream then
          begin
            Beep;
            ShowMessage('The stream package is supported in this version '
              + 'of the MODFLOW GUI but you may need to make some '
              + 'adjustments to your model to use it.  Please read the '
              + 'special instructions for the stream package with '
              + 'MODFLOW-2000 in the Help for the MODFLOW GUI.');
          end;
          if NeedToUpdateIsParamExpression then
          begin
            FixParameterExpressions(aneHandle);
          end;

          if LMG_UsedInOldModel then
          begin
            Beep;
            MessageDlg('This model uses the LMG solver which can no longer '
              + 'be distributed.  Unless you have a version of MODFLOW '
              + 'that includes the LMG solver, you should chooser a '
              + 'different solver before trying to run MODFLOW.',
              mtInformation, [mbOK], 0);
          end;

          RemoveBadLayers(aneHandle);
{$IFDEF Debug}
          WriteDebugOutput(
            'before frmMODFLOW.MFLayerStructure.FreeByStatus(sDeleted)');
{$ENDIF}
          frmMODFLOW.MFLayerStructure.FreeByStatus(sDeleted);
{$IFDEF Debug}
          WriteDebugOutput(
            'after frmMODFLOW.MFLayerStructure.FreeByStatus(sDeleted)');
{$ENDIF}
          frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
{$IFDEF Debug}
          WriteDebugOutput(
            'after frmMODFLOW.MFLayerStructure.SetStatus(sNormal)');
{$ENDIF}
          frmMODFLOW.MFLayerStructure.UpdateIndicies;
{$IFDEF Debug}
          WriteDebugOutput('after frmMODFLOW.MFLayerStructure.UpdateIndicies');
{$ENDIF}
          frmMODFLOW.MFLayerStructure.UpdateOldIndicies;
{$IFDEF Debug}
          WriteDebugOutput(
            'after frmMODFLOW.MFLayerStructure.UpdateOldIndicies');
{$ENDIF}

          frmMODFLOW.AssociateUnits;
          frmMODFLOW.AssociateTimes;
{$IFDEF Debug}
          WriteDebugOutput('after frmMODFLOW.AssociateTimes');
{$ENDIF}
          FixOldNames(aneHandle, VersionInString);
{$IFDEF Debug}
          WriteDebugOutput('after FixOldNames(aneHandle)');
{$ENDIF}
          frmMODFLOW.reProblem.Lines.Assign(UnreadData);
{$IFDEF Debug}
          WriteDebugOutput(
            'after frmMODFLOW.reProblem.Lines.Assign(UnreadData)');
{$ENDIF}
          if frmMODFLOW.reProblem.Lines.Count > 0 then
          begin
{$IFDEF Debug}
            WriteDebugOutput('frmMODFLOW.reProblem.Lines.Count > 0');
{$ENDIF}
            Beep;
            Developer := frmMODFLOW.PIEDeveloper;
            if Developer <> '' then
            begin
              Developer := ' (' + Developer + ')';
            end;
            MessageDlg('Unable to read some of the information in this model. '
              + 'Contact PIE developer ' + Developer + ' for assistance.',
              mtWarning, [mbOK], 0);
          end;

          comboMPATHOutModeHelpContext
            := frmMODFLOW.comboMPATHOutMode.HelpContext;
          comboSensFormatHelpContext
            := frmMODFLOW.comboSensFormat.HelpContext;
          btnModflowImportHelpContext
            := frmMODFLOW.btnModflowImport.HelpContext;

          frmMODFLOW.Loading := False;
        finally;
{$IFDEF Debug}
          WriteDebugOutput('before UnreadData.Free;');
{$ENDIF}
          UnreadData.Free;
{$IFDEF Debug}
          WriteDebugOutput('after UnreadData.Free;');
{$ENDIF}
        end;
      except on E: Exception do
        begin
{$IFDEF Debug}
          WriteDebugOutput('E.message = ' + E.Message);
{$ENDIF}
          Beep;
          MessageDlg('The following error occured while reading File. "' +
            E.Message +
            '" Close this file WITHOUT saving it. ' +
            'Contact PIE developer ' + Developer + ' for assistance.', mtError,
            [mbOK], 0);
        end;
      end;
    end;
{$IFDEF Debug}
  finally
    WriteDebugOutput('Exit GLoadForm');
  end;
{$ENDIF}
end;

initialization
  AnANE_STR := nil;

finalization
  if AnANE_STR <> nil then
  begin
    FreeMem(AnANE_STR);
  end;
end.

