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

var
  FormDataAsString : string;
  EditWindowOpen : boolean;

resourceString
  rsDeveloper = 'Richard Winston';

implementation

uses {Variables, ModflowUnit, MFLayerStructureUnit, GetANEFunctionsUnit,}
  ANE_LayerUnit, {ReadOldUnit, ReadOldMT3D, ANECB, CheckVersionFunction,
  UtilityFunctions,} ArgusDataEntry, {ArgusFormUnit, FixMoreNamesUnit} frmProjectUnit;

{Procedure LockRechargeElev ( aneHandle : ANE_PTR);
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
}

function EditForm : boolean;
begin
FormDataAsString := frmProject.FormToString(nil, nil,
  rsDeveloper);
if frmProject.ShowModal = mrOK
then
  begin
    result := True;
  end
else // if frmMODFLOW.ShowModal = mrOK else
  begin
      result := False;
  end; // if frmMODFLOW.ShowModal = mrOK else
end;

function GProjectNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerString : ANE_STR;
  InfoLayer : T_ANE_InfoLayer;
begin
  if EditWindowOpen
  then
    begin
      MessageDlg('You can not create a new model while exporting a ' +
      ' project or if an edit box is open.', mtError, [mbOK], 0);
      Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 3
        begin
          frmProject := TfrmProject.Create(Application);
          try
            begin
              frmProject.CurrentModelHandle := Handle;
              frmProject.LayerStructure := TLayerStructure.Create;
              T_ANE_GridLayer.Create(frmProject.LayerStructure.UnIndexedLayers, -1);
              InfoLayer := T_ANE_InfoLayer.Create(frmProject.LayerStructure.UnIndexedLayers, -1);
              T_ANE_LayerParam.Create(InfoLayer.ParamList, -1);
              if frmProject.ShowModal = mrOK then
              begin
                  FormDataAsString := frmProject.LayerStructure.WriteLayers(Handle);
                  layerString := PChar(FormDataAsString);

                  rPIEHandle^ := frmProject;

                  rLayerTemplate^ := layerString;
                  frmProject.LayerStructure.SetStatus(sNormal);
                  result := true;
                  frmProject.Hide;
//                  ANE_ProcessEvents(Handle);
              end
              else
              begin
                  frmProject.Free;
                  frmProject := nil;
                  result := false;
              end;
            end;
          except on E: Exception do
            begin
              frmProject.Free;
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
        frmProject := PIEHandle;
        frmProject.CurrentModelHandle := aneHandle;
        frmProject.Width := 210;
        frmProject.Height := 121;
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

    frmProject := PIEHandle;
    if (frmProject <> nil) then
    begin
      frmProject.CurrentModelHandle := aneHandle;
    end;
    frmProject.Free;

end; { GClearForm }

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;
var
  AnANE_STR : ANE_STR;
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
      frmProject := PIEHandle;
      if frmProject <> nil then
      begin
        frmProject.CurrentModelHandle := aneHandle;
        // read the data on Form to a string
        FormDataAsString := frmProject.FormToString(nil,
          frmProject.IgnoreList, rsDeveloper);
        AnANE_STR := PChar(FormDataAsString);


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

procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;
  procedure UpdateCombos;
  var
    Index : integer;
    AComboBox : TCombobox;
  begin
    for Index := 0 to frmProject.ComponentCount -1 do
    begin
      if frmProject.Components[Index] is TComboBox then
      begin
        AComboBox := TComboBox(frmProject.Components[Index]);
        if Assigned(AComboBox.OnChange) then
        begin
          AComboBox.OnChange(AComboBox);
        end;
      end;
    end;
  end;
var
  UnreadData : TStringlist;
  DataToRead : string;
  Developer : string;
  ADE : TArgusDataEntry;
  Index : integer;
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
            frmProject := TfrmProject.Create(Application);
            frmProject.CurrentModelHandle := aneHandle;
            rPIEHandle^ := frmProject;
            frmProject.LayerStructure := TLayerStructure.Create;
            T_ANE_GridLayer.Create(frmProject.LayerStructure.UnIndexedLayers, -1);


            frmProject.LayerStructure.SetStatus(sNormal);
            DataToRead := String(LoadInfo);
            for Index := 0 to frmProject.ComponentCount -1 do
            begin
              if frmProject.Components[Index] is TArgusDataEntry then
              begin
                ADE := TArgusDataEntry(frmProject.Components[Index]);
                ADE.CheckRange;
              end;
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
