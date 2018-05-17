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
// Procedure LockRechargeElev ( aneHandle : ANE_PTR);

var
  FormDataAsString : string;

implementation

uses
  ANE_LayerUnit, ANECB, CheckVersionFunction, UtilityFunctions, ArgusDataEntry,
  ArgusFormUnit, MainForm, MainLayerStructure;

ResourceString
  rsDeveloper = 'Developer''s name';

function EditForm : boolean;
var
  UnreadData : TStringlist;
  VersionInString : string;
begin
  FormDataAsString := frmMain.FormToString(nil, nil,
    rsDeveloper);
  if frmMain.ShowModal = mrOK then
  begin
    frmMain.LayerStructure.OK(frmMain.CurrentModelHandle);
    result := True;
    end
  else // if ShowModal.ShowModal = mrOK else
  begin
    Screen.Cursor := crHourGlass;
    frmMain.Cancelling := True;
    try
      frmMain.LayerStructure.Cancel;
      UnreadData := TStringlist.Create;
      try  // try 1
        begin
          frmMain.StringToForm(FormDataAsString, UnreadData, nil,
            VersionInString, False, nil, nil, frmMain.PIEDeveloper);
        end
      finally
        begin
          UnreadData.Free;
        end;
      end;  // try 1
      frmMain.LayerStructure.SetStatus(sNormal);
    finally
      Screen.Cursor := crDefault;
      frmMain.Cancelling := False;
      result := False;
    end;
  end; // if ShowModal.ShowModal = mrOK else
end;

function GProjectNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerString : ANE_STR;
//  VersionInString : string;
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
          frmMain := TfrmMain.Create(Application);
          frmMain.CurrentModelHandle := Handle;
          try
            begin
              frmMain.LayerStructure := TMyLayerStructure.Create;
              frmMain.NewModel := True;
              frmMain.AssociateUnits;
              frmMain.AssociateTimes;
              frmMain.Loading := False;
              if frmMain.ShowModal = mrOK
              then
                begin
                  FormDataAsString := frmMain.LayerStructure.WriteLayers(Handle);
                  layerString := PChar(FormDataAsString);

                  rPIEHandle^ := frmMain;

                  rLayerTemplate^ := layerString;
                  frmMain.LayerStructure.SetStatus(sNormal);
                  result := true;
                  frmMain.Hide;
                  ANE_ProcessEvents(Handle);
                end
              else
                begin
                  frmMain.Free;
                  frmMain := nil;
                  result := false;
                end;
            end;
          except on E: Exception do
            begin
              frmMain.Free;
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
        frmMain := PIEHandle;
        frmMain.CurrentModelHandle := aneHandle;
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
  frmMain := PIEHandle;
  if (frmMain <> nil) then
  begin
    frmMain.CurrentModelHandle := aneHandle;
  end;
  frmMain.Free;
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
      frmMain := PIEHandle;
      if frmMain <> nil then
      begin
        frmMain.CurrentModelHandle := aneHandle;
        // read the data on Form to a string
        FormDataAsString := frmMain.FormToString(frmMain.lblVersion,
          frmMain.IgnoreList, rsDeveloper);
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
    for Index := 0 to frmMain.ComponentCount -1 do
    begin
      if frmMain.Components[Index] is TComboBox then
      begin
        AComboBox := TComboBox(frmMain.Components[Index]);
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
            frmMain := TfrmMain.Create(Application);
            frmMain.CurrentModelHandle := aneHandle;
            rPIEHandle^ := frmMain;
            frmMain.LayerStructure := TMyLayerStructure.Create;
            frmMain.AssociateUnits;
            frmMain.AssociateTimes;

            frmMain.LayerStructure.SetStatus(sNormal);
            DataToRead := String(LoadInfo);
            frmMain.LoadMyForm(UnreadData, DataToRead ,
              VersionInString );

            for Index := 0 to frmMain.ComponentCount -1 do
            begin
              if frmMain.Components[Index] is TArgusDataEntry then
              begin
                ADE := TArgusDataEntry(frmMain.Components[Index]);
                ADE.CheckRange;
              end;
            end;
            frmMain.LayerStructure.FreeByStatus(sDeleted);
            frmMain.LayerStructure.SetStatus(sNormal);
            frmMain.LayerStructure.UpdateIndicies;
            frmMain.LayerStructure.UpdateOldIndicies;

            frmMain.AssociateUnits;
            frmMain.AssociateTimes;
            frmMain.reProblem.Lines.Assign(UnreadData);
            If frmMain.reProblem.Lines.Count > 0 then
            begin
              Beep;
              Developer := frmMain.PIEDeveloper;
              if Developer <> '' then
              begin
                Developer := ' (' + Developer + ')';
              end;
              MessageDlg('Unable to read some of the information in this model. '
                + 'Contact PIE developer ' + Developer + ' for assistance.',
                mtWarning, [mbOK], 0);
            end;
            frmMain.Loading := False;
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
