unit ProjectFunctions;

interface

{ProjectFunctions defines the PIE functions for creating a new model,
 editing the non-spatial data of that model, saving and loading models,
 and freeing the model data when the model is closed. It has has a function
 to lock or unlock the recharge elevation as appropriate.  The latter may
 be incorporated into the classes defined in ANE_LayerUnit in the future.}

uses AnePIE, Forms, sysutils, Controls, classes, Dialogs, Stdctrls;

function GProjectNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

function GEditForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;

procedure GClearForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;

procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;

function EditForm : boolean;
Procedure LockRechargeElev ( aneHandle : ANE_PTR);

var
  FormDataAsString : string;

implementation

uses Variables, ModflowUnit, MFLayerStructureUnit, GetANEFunctionsUnit,
  ANE_LayerUnit, ReadOldUnit, ReadOldMT3D, ANECB, CheckVersionFunction,
  UtilityFunctions, ArgusDataEntry, ArgusFormUnit, FixMoreNamesUnit;

Procedure LockRechargeElev ( aneHandle : ANE_PTR);
var
  LayerHandle : ANE_PTR;
  ParameterIndex : ANE_INT32;
  AString : ANE_STR;
begin
  // Check if recharge option is selected
  if frmModflow.cbRCH.Checked then
  begin
    // get layer handle for the recharge layer.
    LayerHandle := ANE_LayerGetHandleByName(aneHandle,
      PChar(ModflowTypes.GetRechargeLayerType.ANE_LayerName));

    // get the parameter index for the recharge elevation parameter
    ParameterIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
      PChar(ModflowTypes.GetMFRechElevParamType.ANE_ParamName));

    // set the value of the parameter lock to change
    AString := 'Dont Override';

    // check if recharge elevation is used.
    if frmModflow.comboRchOpt.ItemIndex = 1 then
    begin
      // if recharge elevation is used,
      // allow the parameter value to be overridden.
      ANE_LayerParameterPropertySet(aneHandle,ParameterIndex, LayerHandle,
         '-Lock', kPIEString, AString);
    end
    else
    begin
      // if recharge elevation is not used,
      // prevent the parameter value from being overridden.
      ANE_LayerParameterPropertySet (aneHandle,ParameterIndex, LayerHandle,
         '+Lock', kPIEString, AString);
    end;

    // set the value of the parameter lock to change
    AString := 'Dont Eval Color';

    // check if recharge elevation is used.
    if frmModflow.comboRchOpt.ItemIndex = 1 then
    begin
      // if recharge elevation is used,
      // allow the parameter value to be overridden.
      ANE_LayerParameterPropertySet(aneHandle,ParameterIndex, LayerHandle,
         '-Lock', kPIEString, AString);
    end
    else
    begin
      // if recharge elevation is not used,
      // prevent the parameter value from being overridden.
      ANE_LayerParameterPropertySet (aneHandle,ParameterIndex, LayerHandle,
         '+Lock', kPIEString, AString);
    end;

    // set the value of the parameter lock to change
    AString := 'Lock Def Val';

    // check if recharge elevation is used.
    if frmModflow.comboRchOpt.ItemIndex = 1 then
    begin
      // if recharge elevation is used,
      // allow the parameter value to be overridden.
      ANE_LayerParameterPropertySet(aneHandle,ParameterIndex, LayerHandle,
         '-Lock', kPIEString, AString);
    end
    else
    begin
      // if recharge elevation is not used,
      // prevent the parameter value from being overridden.
      ANE_LayerParameterPropertySet (aneHandle,ParameterIndex, LayerHandle,
         '+Lock', kPIEString, AString);
    end;
  end;
end;


function EditForm : boolean;
var
  UnreadData : TStringlist;
  VersionInString : string;
begin
FormDataAsString := frmMODFLOW.FormToString(nil, nil,
  rsDeveloper);
if frmMODFLOW.ShowModal = mrOK
then
  begin
    frmMODFLOW.MFLayerStructure.OK(frmMODFLOW.CurrentModelHandle);
    if frmMODFLOW.NeedToUpdateMOC3DSubgrid then
    begin
      frmMODFLOW.UpdateMOC3DSubgrid;
      frmMODFLOW.NeedToUpdateMOC3DSubgrid := False;
    end;
    result := True;
    LockRechargeElev ( frmMODFLOW.CurrentModelHandle);
  end
else // if frmMODFLOW.ShowModal = mrOK else
  begin
    Screen.Cursor := crHourGlass;
    frmMODFLOW.Cancelling := True;
    try
      frmMODFLOW.MFLayerStructure.Cancel;
      UnreadData := TStringlist.Create;
      try  // try 1
        begin
          frmMODFLOW.StringToForm(FormDataAsString, UnreadData, nil,
            VersionInString, False, nil, nil, frmMODFLOW.PIEDeveloper);
        end
      finally
        begin
          UnreadData.Free;
        end;
      end;  // try 1
      frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
    finally
      Screen.Cursor := crDefault;
      frmMODFLOW.Cancelling := False;
      result := False;
    end;
  end; // if frmMODFLOW.ShowModal = mrOK else
end;

function IniFile : string;
begin
  GetDllDirectory(GetDLLName, result);
  result := result + '/modflow.ini.'
end;

function GProjectNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerString : ANE_STR;
  VersionInString : string;
  Path : string;
  ValFile : TStringList;
  Dummy: String;
begin
  if EditWindowOpen
  then
    begin
      MessageDlg('You can not create a new MODFLOW model while exporting a ' +
      ' project or if an edit box is open.', mtError, [mbOK], 0);
      Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 3
        begin
          frmMODFLOW := ModflowTypes.GetModflowFormType.Create(Application);
          frmMODFLOW.CurrentModelHandle := Handle;
          try
            begin
              frmMODFLOW.MFLayerStructure :=
                ModflowTypes.GetModflowLayerStructureType.Create;
              frmMODFLOW.NewModel := True;
              frmMODFLOW.AssociateUnits;
              frmMODFLOW.AssociateTimes;
              if not GetDllDirectory(DLLName, Path)
              then
                begin
                  Beep;
                  ShowMessage('Unable to find ' + DLLName);
                end
              else
                begin
                  Path := Path + '\modflow.val';
                  if FileExists(Path) then
                  begin
                    ValFile := TStringList.Create;
                    try
                      begin
                        ValFile.LoadFromFile(Path);
                        if Pos('@NPER@', ValFile.Text) = 0 then
                        begin
                          frmMODFLOW.ReadValFile(VersionInString, Path) ;
                        end
                        else
                        begin
                          BEEP;
                          MessageDlg('A val file from a previous version of the '
                            + 'MODFLOW/MOC3D PIE has been detected. It will be ignored. '
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
                    frmMODFLOW.ReadValFile(VersionInString, Path) ;
                  end;
                end;
              frmMODFLOW.Loading := False;
              if frmMODFLOW.ShowModal = mrOK
              then
                begin
                  FormDataAsString := frmMODFLOW.MFLayerStructure.WriteLayers(Handle);
                  layerString := PChar(FormDataAsString);

                  rPIEHandle^ := frmMODFLOW;

                  rLayerTemplate^ := layerString;
                  frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
                  result := true;
                  frmMODFLOW.Hide;
                  ANE_ProcessEvents(Handle);
                  if not CheckArgusVersion(Handle,4,2,0,'e', Dummy) then
                  begin
                    Beep;
                    ShowMessage('By convention, MODFLOW Grids are numbered from the '
                      + 'top down rather than from the bottom up. To set this '
                      + 'option, activate the MODFLOW FD Grid layer and select '
                      + '"Edit|Grid Direction|Negative Y". This option is set '
                      + 'automatically in Argus ONE 4.2.0e and later.');
                  end;
                end
              else
                begin
                  frmMODFLOW.Free;
                  frmMODFLOW := nil;
                  result := false;
                end;
            end;
          except on E: Exception do
            begin
              frmMODFLOW.Free;
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

function GEditForm (aneHandle : ANE_PTR ;
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
        frmMODFLOW := PIEHandle;
        frmMODFLOW.CurrentModelHandle := aneHandle;
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



procedure GClearForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;
begin

    frmMODFLOW := PIEHandle;
    if (frmMODFLOW <> nil) then
    begin
      frmMODFLOW.CurrentModelHandle := aneHandle;
    end;
    frmMODFLOW.Free;

end; { GClearForm }

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
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
      frmMODFLOW := PIEHandle;
      if frmMODFLOW <> nil then
      begin
        frmMODFLOW.CurrentModelHandle := aneHandle;
        // read the data on Form to a string
        FormDataAsString := frmMODFLOW.FormToString(frmMODFLOW.lblVersion,
          frmMODFLOW.IgnoreList, rsDeveloper);
        AnANE_STR := PChar(FormDataAsString);
        try  // try 2
        begin
          ModelPaths := TStringList.Create;
          try // try3
            frmMODFLOW.ModelPaths(ModelPaths, frmMODFLOW.lblVersion, rsDeveloper);
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

Procedure FixRiverAndDrainExpressions(aneHandle : ANE_PTR);
var
  LayerHandle : ANE_PTR;
  ParamIndex : ANE_INT32;
//  ParamName : string;
//  OldParamName, NewParamName : string;
  UnitIndex : integer;
  GridLayer : T_ANE_GridLayer;
  AParameterList : T_ANE_IndexedParameterList;
  AParam : T_ANE_Param;
  Expression : string;
begin
  LayerHandle := ANE_LayerGetHandleByName(aneHandle,
    PChar(ModflowTypes.GetGridLayerType.ANE_LayerName));
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat // ParamIndex = -1 do
    begin
      Inc(UnitIndex);


      // reset Grid Drain parameter expression.
      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        PChar(ModflowTypes.GetMFGridDrainParamType.ANE_ParamName +
          IntToStr(UnitIndex)));

      if ParamIndex > -1 then
      begin
        GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.GetLayerByName
          (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

        AParameterList := GridLayer.IndexedParamList1.
          GetNonDeletedIndParameterListByIndex(UnitIndex -1);

        AParam := AParameterList.GetParameterByName(ModflowTypes.
          GetMFGridDrainParamType.ANE_ParamName);

        Expression := AParam.Value;

        ANE_LayerSetParameterExpression(aneHandle, layerHandle, ParamIndex,
          PChar(Expression) );
      end;

    end;
    until ParamIndex = -1;
  END;

  LayerHandle := ANE_LayerGetHandleByName(aneHandle,
    PChar(ModflowTypes.GetGridLayerType.ANE_LayerName));
  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat // ParamIndex = -1 do
    begin
      Inc(UnitIndex);

      // reset Grid River parameter expression.
      ParamIndex := ANE_LayerGetParameterByName(aneHandle, LayerHandle,
        PChar(ModflowTypes.GetMFGridRiverParamType.ANE_ParamName +
          IntToStr(UnitIndex)));
      if ParamIndex > -1 then
      begin
        GridLayer := frmModflow.MFLayerStructure.UnIndexedLayers.GetLayerByName
          (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

        AParameterList := GridLayer.IndexedParamList1.
          GetNonDeletedIndParameterListByIndex(UnitIndex -1);

        AParam := AParameterList.GetParameterByName(ModflowTypes.
          GetMFGridRiverParamType.ANE_ParamName);

        Expression := AParam.Value;

        ANE_LayerSetParameterExpression(aneHandle, layerHandle, ParamIndex,
          PChar(Expression) );
      end;


    end;
    until ParamIndex = -1;
  END;


end;

Procedure FixOldNames(aneHandle : ANE_PTR);
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
  ShowMessage : boolean;
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
      FixMoreOldNames(aneHandle);

      ShowMessage := False;
      if frmMODFLOW.cbDRN.Checked then
      begin
        LayerHandle := ANE_LayerGetHandleByName(aneHandle,
          PChar(ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName + '1'));
        if LayerHandle = nil then
        begin
          ShowMessage := True;
        end;
      end;

      CheckForMoreNewLayers(aneHandle,ShowMessage);

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

//      frmMODFLOW.MFLayerStructure.OK(aneHandle);
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

end;

procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;
  procedure UpdateCombos;
  var
    Index : integer;
    AComboBox : TCombobox;
  begin
    for Index := 0 to frmMODFLOW.ComponentCount -1 do
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
  end;
var
  UnreadData : TStringlist;
  VersionInString : string ;
  DataToRead : string;
  Developer : string;
  ADE : TArgusDataEntry;
  Index : integer;
  Path : string;
//  NeedToUpdateMOC3DSubgrid : boolean;
  needToUpdateRiverOrDrain : boolean;
  NeedToUpdateMocPrescribedConc : boolean;
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
    needToUpdateRiverOrDrain := False;
    NeedToUpdateMocPrescribedConc := False;
    Developer := '';
    try
      begin
        UnreadData := TStringlist.Create;
        try
          begin
            frmMODFLOW := ModflowTypes.GetModflowFormType.Create(Application);
            frmMODFLOW.CurrentModelHandle := aneHandle;
            rPIEHandle^ := frmMODFLOW;
            frmMODFLOW.MFLayerStructure :=
              ModflowTypes.GetModflowLayerStructureType.Create;
            frmMODFLOW.AssociateUnits;
            frmMODFLOW.AssociateTimes;

            frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
            DataToRead := String(LoadInfo);
            if IsOldFile(DataToRead)
            then
              begin
                needToUpdateRiverOrDrain := frmMODFLOW.cbRIV.Checked or frmMODFLOW.cbDRN.Checked;
                NeedToUpdateMocPrescribedConc := frmMODFLOW.cbMOC3D.Checked;
                frmMODFLOW.NeedToUpdateMOC3DSubgrid := frmModflow.cbMOC3D.Checked;
                frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
                UpdateCombos;
              end
            else
              begin
                if IsOldMT3DFile(DataToRead)
                then
                  begin
                    needToUpdateRiverOrDrain := frmMODFLOW.cbRIV.Checked or frmMODFLOW.cbDRN.Checked;
                    NeedToUpdateMocPrescribedConc := frmMODFLOW.cbMOC3D.Checked;
                    frmMODFLOW.NeedToUpdateMOC3DSubgrid := frmModflow.cbMOC3D.Checked;;
                    frmMODFLOW.cbSpecifyFlowFiles.Checked := True;
                    UpdateCombos;
                  end
                else
                  begin
                    frmMODFLOW.LoadModflowForm(UnreadData, DataToRead ,
                      VersionInString );
                    frmMODFLOW.NeedToUpdateMOC3DSubgrid :=
                      not frmMODFLOW.PieIsEarlier(VersionInString, '2.0.13.0', False)
                      and frmModflow.cbMOC3D.Checked;
                    frmMODFLOW.cbSpecifyFlowFiles.Checked := not
                      frmMODFLOW.PieIsEarlier(VersionInString, '2.0.15.0',  False);
                    needToUpdateRiverOrDrain := (frmMODFLOW.cbRIV.Checked or frmMODFLOW.cbDRN.Checked) and
                      not frmMODFLOW.PieIsEarlier(VersionInString, '3.0.7.9',  False);
                    NeedToUpdateMocPrescribedConc := frmMODFLOW.cbMOC3D.Checked and
                      not frmMODFLOW.PieIsEarlier(VersionInString, '3.0.12.0',  False);
                  end;
              end;
            for Index := 0 to frmMODFLOW.ComponentCount -1 do
            begin
              if frmMODFLOW.Components[Index] is TArgusDataEntry then
              begin
                ADE := TArgusDataEntry(frmMODFLOW.Components[Index]);
                ADE.CheckRange;
              end;
            end;
            Path := IniFile;
            if FileExists(Path) then
            begin
              frmMODFLOW.ReadValFile(VersionInString, Path) ;
            end;
            if needToUpdateRiverOrDrain then
            begin
              FixRiverAndDrainExpressions(aneHandle)
            end;
            If frmMODFLOW.NeedToUpdateMOC3DSubgrid or needToUpdateRiverOrDrain
              or NeedToUpdateMocPrescribedConc then
            begin
              Beep;
              showMessage('You will need to select "PIEs|Edit Project Info" '
                + 'and then click on the OK button to update some information in '
                + 'this model. All needed changes will be made automatically '
                + 'when you do this.')
            end;

            frmMODFLOW.MFLayerStructure.FreeByStatus(sDeleted);
            frmMODFLOW.MFLayerStructure.SetStatus(sNormal);
            frmMODFLOW.MFLayerStructure.UpdateIndicies;
            frmMODFLOW.MFLayerStructure.UpdateOldIndicies;

            frmMODFLOW.AssociateUnits;
            frmMODFLOW.AssociateTimes;
            FixOldNames(aneHandle);
            frmMODFLOW.reProblem.Lines.Assign(UnreadData);
            If frmMODFLOW.reProblem.Lines.Count > 0 then
            begin
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
            frmMODFLOW.Loading := False;
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
