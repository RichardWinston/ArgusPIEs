unit ProjectFunctions;

interface

uses Forms, sysutils, Controls, classes, Dialogs, Stdctrls, AnePIE;

function GProjectNewSutra (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

function GEditSutraForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;

procedure GClearSutraForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;

procedure GSaveSutraForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;

procedure GLoadSutraForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;

function EditForm : boolean;

var
  FormDataAsString : string;

implementation

uses ANECB, frmSutraUnit, GlobalVariables, ANE_LayerUnit, UtilityFunctions,
     ArgusFormUnit, ArgusDataEntry, ReadOldSutra, SLLayerStructure,
     WarningsUnit;

function EditForm : boolean;
var
  UnreadData : TStringlist;
  VersionInString : string;
begin
FormDataAsString := frmSutra.FormToString(nil, nil,
  rsDeveloper);
  if frmSutra.ShowModal = mrOK
  then
  begin
    frmSutra.SutraLayerStructure.OK(frmSutra.CurrentModelHandle);
    result := True;
  end
  else // if frmMODFLOW.ShowModal = mrOK else
  begin
    Screen.Cursor := crHourGlass;
    frmSutra.Cancelling := True;
    try
      frmSutra.SutraLayerStructure.Cancel;
      UnreadData := TStringlist.Create;
      try  // try 1
        begin
          frmSutra.StringToForm(FormDataAsString, UnreadData, nil,
            VersionInString, False, nil, frmSutra.PIEDeveloper);
        end
      finally
        begin
          UnreadData.Free;
        end;
      end;  // try 1
      frmSutra.SutraLayerStructure.SetStatus(sNormal);
    finally
      Screen.Cursor := crDefault;
      frmSutra.Cancelling := False;
      result := False;
    end;
  end; // if frmMODFLOW.ShowModal = mrOK else
end;

function IniFile : string;
begin
  GetDllDirectory(GetDLLName, result);
  result := result + '/sutra.ini.'
end;

function GProjectNewSutra (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerString : ANE_STR;
  VersionInString : string;
  Path : string;
  ValFile : TStringList;

begin
  if EditWindowOpen
  then
    begin
      MessageDlg('You can not create a new SUTRA model while exporting a ' +
      ' project or if an edit box is open.', mtError, [mbOK], 0);
      Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 3
        begin
          frmSutra := TfrmSutra.Create(Application);
          frmSutra.CurrentModelHandle := Handle;
          try
            begin
              frmSutra.SutraLayerStructure :=
                TSutraLayerStructure.Create;
              frmSutra.NewModel := True;
//              frmMODFLOW.AssociateUnits;
//              frmMODFLOW.AssociateTimes;
              if not GetDllDirectory(DLLName, Path)
              then
                begin
                  Beep;
                  ShowMessage('Unable to find ' + DLLName);
                end
              else
                begin
                  Path := Path + '\sutra.val';
                  if FileExists(Path) then
                  begin
                    ValFile := TStringList.Create;
                    try
                      begin
                        ValFile.LoadFromFile(Path);
                        if Pos('@TITLE1@', ValFile.Text) = 0 then
                        begin
                          frmSutra.ReadValFile(VersionInString, Path) ;
                        end
                        else
                        begin
                          BEEP;
                          MessageDlg('A val file from a previous version of the '
                            + 'SUTRA PIE has been detected. It will be ignored. '
                            + 'You should either replace it with a new version '
                            + 'or delete it. It is now much easier to create new '
                            + 'val files. To find out more about val files, go to '
                            + 'The "Advanced Options" tab of the "Edit Project Info" '
                            + 'dialog box and read the online help for the "Save Val '
                            + 'File" button.', mtWarning, [mbOK], 0);
                        end;
                      end;
                    finally
                      ValFile.Free;
                    end;


                  end;
                  Path := IniFile;
                  if FileExists(Path) then
                  begin
                    frmSutra.ReadValFile(VersionInString, Path) ;
                  end;
                end;
              frmSutra.Loading := False;
              if frmSutra.ShowModal = mrOK
              then
                begin
                  FormDataAsString := frmSutra.SutraLayerStructure.
                    WriteLayers(Handle);
                  layerString := PChar(FormDataAsString);

                  rPIEHandle^ := frmSutra;

                  rLayerTemplate^ := layerString;
                  frmSutra.SutraLayerStructure.SetStatus(sNormal);
                  result := true;
                  frmSutra.Hide;
                  ANE_ProcessEvents(Handle);
{                  if not CheckArgusVersion(Handle,4,2,0,'e') then
                  begin
                    Beep;
                    ShowMessage('By convention, MODFLOW Grids are numbered from the '
                      + 'top down rather than from the bottom up. To set this '
                      + 'option, activate the MODFLOW FD Grid layer and select '
                      + '"Edit|Grid Direction|Negative Y". This option is set '
                      + 'automatically in Argus ONE 4.2.0e and later.');
                  end; }
                end
              else
                begin
                  frmSutra.Free;
                  frmSutra := nil;
                  result := false;
                end;  
            end;
          except on E: Exception do
            begin
              frmSutra.Free;
              result := False;
              Beep;
              MessageDlg(E.Message, mtError, [mbOK], 0);
            end;
          end;
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 3
    end; // if EditWindowOpen else

end; { GSimpleExportTemplate }

function GEditSutraForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;
//  Developer : string;
begin
  if EditWindowOpen then
  begin
    Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try  // try 2
      begin
        frmSutra := PIEHandle;
        frmSutra.CurrentModelHandle := aneHandle;
        result := EditForm;

      end; // try 2
      except on E: Exception do
        begin
            result := False;
            Beep;
            MessageDlg(E.Message, MtError, [mbOK], 0);
        end;
      end  // try 2
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else

end; { GEditForm }



procedure GClearSutraForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;
begin

    frmSutra := PIEHandle;
    if (frmSutra <> nil) then
    begin
      frmSutra.CurrentModelHandle := aneHandle;
    end;
    frmSutra.Free;

end; { GClearForm }

procedure GSaveSutraForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;
var
  AnANE_STR : ANE_STR;
  ModelPaths : TStringList;
  Warning : string;
begin
  AnANE_STR := nil;
  if EditWindowOpen then
  begin
    MessageDlg('You can not save a file while exporting a ' +
    ' project or if an edit box is open. Save this file again after'
    + ' correcting these problems.', mtError, [mbOK], 0);

  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      frmSutra := PIEHandle;
      if frmSutra <> nil then
      begin
        frmSutra.CurrentModelHandle := aneHandle;
        // read the data on Form to a string
        FormDataAsString := frmSutra.FormToString(frmSutra.lblVersion,
          frmSutra.IgnoreList, rsDeveloper);
        AnANE_STR := PChar(FormDataAsString);
        try  // try 2
        begin
          ModelPaths := TStringList.Create;
          try // try3
            frmSutra.ModelPaths(ModelPaths, frmSutra.lblVersion, rsDeveloper);
            ModelPaths.SaveToFile(IniFile);
          finally
            ModelPaths.Free;
          end;
        end; // try 3
        except On E: Exception do
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
        end;  // try 2


      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  rSaveInfo^ := AnANE_STR;

end;

{Procedure FixOldNames(aneHandle : ANE_PTR);
var
  LayerHandle : ANE_PTR;
  ParamIndex : ANE_INT32;
//  ParamName : string;
  OldParamName, NewParamName : string;
  UnitIndex : integer;
  LayerName : string;
  OldLayerName, NewLayerName : String;
  GridLayer : T_ANE_GridLayer;
  AParameterList : T_ANE_IndexedParameterList;
  AParam : T_ANE_Param;
  Expression : string;
begin
  frmWarnings := ModflowTypes.GetWarningsFormType.Create(Application);
  try
    begin
      frmWarnings.CurrentModelHandle := aneHandle;
      LayerHandle := ANE_LayerGetHandleByName(aneHandle,
        'MODFLOW Grid Density');
      if LayerHandle <> nil then
      begin
        ANE_LayerRename(aneHandle, layerHandle,
          PChar(ModflowTypes.GetDensityLayerType.ANE_LayerName));

        frmWarnings.memoWarnings.Lines.Add('The layer "MODFLOW Grid Density" '
          + 'has been changed to "'
          + ModflowTypes.GetDensityLayerType.ANE_LayerName + '".');

        ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
          'Density');
        if ParamIndex > -1 then
        begin
          ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
            PChar(ModflowTypes.GetMFDensityParamType.ANE_ParamName));

          frmWarnings.memoWarnings.Lines.Add('On the layer "'
            + ModflowTypes.GetDensityLayerType.ANE_LayerName
            + '", the parameter "Density" has been changed to "'
            + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');

        end;

        ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
          'MODFLOW Grid Density');
        if ParamIndex > -1 then
        begin
          ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
            PChar(ModflowTypes.GetMFDensityParamType.ANE_ParamName));

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
        ANE_LayerRename(aneHandle, layerHandle,
          PChar(ModflowTypes.GetDensityLayerType.ANE_LayerName));

        frmWarnings.memoWarnings.Lines.Add('The layer "MODFLOW Cell Size" '
          + 'has been changed to "'
          + ModflowTypes.GetDensityLayerType.ANE_LayerName + '".');

        ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
          'MODFLOW Grid Cell Size');
        if ParamIndex > -1 then
        begin
          ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
            PChar(ModflowTypes.GetMFDensityParamType.ANE_ParamName));

          frmWarnings.memoWarnings.Lines.Add('On the layer "'
            + ModflowTypes.GetDensityLayerType.ANE_LayerName
            + '", the parameter "MODFLOW Grid Cell Size" has been changed to "'
            + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');

        end;

        ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
          'MODFLOW Grid Density');
        if ParamIndex > -1 then
        begin
          ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
            PChar(ModflowTypes.GetMFDensityParamType.ANE_ParamName));

          frmWarnings.memoWarnings.Lines.Add('On the layer "'
            + ModflowTypes.GetDensityLayerType.ANE_LayerName
            + '", the parameter "MODFLOW Grid Density" has been changed to "'
            + ModflowTypes.GetMFDensityParamType.ANE_ParamName + '".');

        end;
      end;

      LayerHandle := ANE_LayerGetHandleByName(aneHandle,
        PChar(ModflowTypes.GetMFDomainOutType.ANE_LayerName));
      if LayerHandle <> nil then
      begin

        ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
          'Density');
        if ParamIndex > -1 then
        begin
          ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
            PChar(ModflowTypes.GetMFDomDensityParamType.ANE_ParamName));

          frmWarnings.memoWarnings.Lines.Add('On the layer "'
            + ModflowTypes.GetMFDomainOutType.ANE_LayerName
            + '", the parameter "Density" has been changed to "'
            + ModflowTypes.GetMFDomDensityParamType.ANE_ParamName + '".');

        end;

        ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
          'MODFLOW Grid Density');
        if ParamIndex > -1 then
        begin
          ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
            PChar(ModflowTypes.GetMFDomDensityParamType.ANE_ParamName));

          frmWarnings.memoWarnings.Lines.Add('On the layer "'
            + ModflowTypes.GetMFDomainOutType.ANE_LayerName
            + '", the parameter "MODFLOW Grid Density" has been changed to "'
            + ModflowTypes.GetMFDomDensityParamType.ANE_ParamName + '".');

        end;
      end;

      LayerHandle := ANE_LayerGetHandleByName(aneHandle,
        PChar(ModflowTypes.GetGridLayerType.ANE_LayerName));
      if LayerHandle <> nil then
      begin
        UnitIndex := 0;
        repeat // ParamIndex = -1 do
        begin
          Inc(UnitIndex);
          OldParamName  := 'ZoneBudget Zone Unit' + IntToStr(UnitIndex);
          ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
            PChar(OldParamName));

          if ParamIndex > -1 then
          begin
            NewParamName := ModflowTypes.GetMFGridZoneBudgetParamType.ANE_ParamName +
              IntToStr(UnitIndex);

            ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
              PChar(NewParamName));


            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + ModflowTypes.GetGridLayerType.ANE_LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');


            GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.GetLayerByName
              (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

            AParameterList := GridLayer.IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(UnitIndex -1);

            AParam := AParameterList.GetParameterByName(ModflowTypes.
              GetMFGridZoneBudgetParamType.ANE_ParamName);

            Expression := AParam.Value;

            ANE_LayerSetParameterExpression(aneHandle, layerHandle, ParamIndex,
              PChar(Expression) );
          end;
        end;
        until ParamIndex = -1;
      END;

      UnitIndex := 0;
      repeat
      begin
        Inc(UnitIndex);
        OldLayerName := 'ZoneBudget Unit' + IntToStr(UnitIndex);
        LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(OldLayerName));
        if LayerHandle <> nil then
        begin
          NewLayerName := ModflowTypes.GetZoneBudLayerType.ANE_LayerName + IntToStr(UnitIndex);
          ANE_LayerRename(aneHandle, layerHandle, PChar(NewLayerName));

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
        LayerName := ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName + IntToStr(UnitIndex);
        LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(LayerName));
        if LayerHandle <> nil then
        begin

          OldParamName  := 'Bottom';
          ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
            PChar(OldParamName));

          if ParamIndex > -1 then
          begin
            NewParamName := ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName;

            ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
              PChar(NewParamName));

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
        LayerName := ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName + IntToStr(UnitIndex);
        LayerHandle := ANE_LayerGetHandleByName(aneHandle, PChar(LayerName));
        if LayerHandle <> nil then
        begin

          OldParamName  := 'Bottom';
          ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
            PChar(OldParamName));

          if ParamIndex > -1 then
          begin
            NewParamName := ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName;

            ANE_LayerRenameParameter(aneHandle, LayerHandle, ParamIndex,
              PChar(NewParamName));

            frmWarnings.memoWarnings.Lines.Add('On the layer "'
              + LayerName
              + '", the parameter "' + OldParamName + '" has been changed to "'
              + NewParamName + '".');

          end;
        end;
      end;
      until LayerHandle = nil;

    end;
    if frmWarnings.memoWarnings.Lines.Count > 0 then
    begin
      Beep;
      frmWarnings.ShowModal;
    end;
  finally
    begin
      frmWarnings.Free;
    end;
  end;

end;   }

procedure GLoadSutraForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;
  procedure UpdateCombos;
  var
    Index : integer;
    AComboBox : TCombobox;
  begin
    for Index := 0 to frmSutra.ComponentCount -1 do
    begin
      if frmSutra.Components[Index] is TComboBox then
      begin
        AComboBox := TComboBox(frmSutra.Components[Index]);
        if Assigned(AComboBox.OnChange) then
        begin
          AComboBox.OnChange(AComboBox);
        end;
      end;
    end;
  end;
var
  OldFile : boolean;
  UnreadData : TStringlist;
  VersionInString : string ;
  DataToRead : string;
  Developer : string;
  ADE : TArgusDataEntry;
  Index : integer;
  Path : string;
//  NeedToUpdateMOC3DSubgrid : boolean;
begin
  if EditWindowOpen then
  begin
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
    Developer := '';
    try
      begin
        UnreadData := TStringlist.Create;
        try
          begin
            frmSutra := TfrmSutra.Create(Application);
            frmSutra.CurrentModelHandle := aneHandle;
            rPIEHandle^ := frmSutra;
            frmSutra.SutraLayerStructure :=
              TSutraLayerStructure.Create;
{            frmSutra.AssociateUnits;
            frmMODFLOW.AssociateTimes;  }

            frmSutra.SutraLayerStructure.SetStatus(sNormal);
            frmWarnings := TfrmWarnings.Create(Application);
            try
              DataToRead := String(LoadInfo);
              OldFile := False;
              if IsOldFile(DataToRead)
              then
                begin
  //                frmSutra.NeedToUpdateMOC3DSubgrid := frmModflow.cbMOC3D.Checked;
  //                frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
                  UpdateCombos;
                  OldFile := True;
                end
              else
                begin
  {                if IsOldMT3DFile(DataToRead)
                  then
                    begin
                      frmMODFLOW.NeedToUpdateMOC3DSubgrid := frmModflow.cbMOC3D.Checked;;
                      frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
                      UpdateCombos;
                    end
                  else  }
                    begin
                      frmSutra.LoadSutraForm(UnreadData, DataToRead ,
                        VersionInString );
  {                    frmMODFLOW.NeedToUpdateMOC3DSubgrid :=
                        not frmMODFLOW.PieIsEarlier(VersionInString, '2.0.13.0', False)
                        and frmModflow.cbMOC3D.Checked; }
  {                    frmMODFLOW.cbSpecifyFlowFiles.Checked := not
                        frmMODFLOW.PieIsEarlier(VersionInString, '2.0.15.0',  False);}
                    end;
                end;
              for Index := 0 to frmSutra.ComponentCount -1 do
              begin
                if frmSutra.Components[Index] is TArgusDataEntry then
                begin
                  ADE := TArgusDataEntry(frmSutra.Components[Index]);
                  ADE.CheckRange;
                end;
              end;
              Path := IniFile;
              if FileExists(Path) then
              begin
                frmSutra.ReadValFile(VersionInString, Path) ;
              end;

  {            If frmMODFLOW.NeedToUpdateMOC3DSubgrid then
              begin
                Beep;
                showMessage('You will need to select "PIEs|Edit Project Info" '
                  + 'and then click on the OK button to update some information in '
                  + 'this model. All needed changes will be made automatically '
                  + 'when you do this.')
              end;  }

              frmSutra.SutraLayerStructure.FreeByStatus(sDeleted);
              frmSutra.SutraLayerStructure.SetStatus(sNormal);
              frmSutra.SutraLayerStructure.UpdateIndicies;
              frmSutra.SutraLayerStructure.UpdateOldIndicies;

              if OldFile and frmSutra.rbGeneral.Checked then
              begin
                with frmSutra.SutraLayerStructure as TSutraLayerStructure do
                begin
                  UpdateOldLayersAndParameters;
                  UpdateExpressions;
                  SetExpressions(aneHandle);
                  if frmWarnings.memoWarnings.Lines.Count > 0 then
                  begin
                    Beep;
                    frmWarnings.ShowModal;
                  end;
                end;
              end;

  {            frmMODFLOW.AssociateUnits;
              frmMODFLOW.AssociateTimes;
              FixOldNames(aneHandle);  }
              frmSutra.reProblem.Lines.Assign(UnreadData);
              If frmSutra.reProblem.Lines.Count > 0 then
              begin
                Beep;
                Developer := frmSutra.PIEDeveloper;
                if Developer <> '' then
                begin
                  Developer := ' (' + Developer + ')';
                end;
                MessageDlg('Unable to read some of the information in this model. '
                  + 'Contact PIE developer ' + Developer + ' for assistance.',
                  mtWarning, [mbOK], 0);
              end;
              frmSutra.Loading := False;
            finally
              frmWarnings.Free;
            end;
          end;
        finally;
          begin
            UnreadData.Free;
          end;
        end;
      end;
    except on E: Exception do
      begin
        Beep;
        MessageDlg('The following error occured while reading File. "' + E.Message +
          '" Close this file WITHOUT saving it. ' +
          'Contact PIE developer ' + Developer + ' for assistance.', mtError,
          [mbOK], 0);
      end;
    end;
  end;

end;


end.
