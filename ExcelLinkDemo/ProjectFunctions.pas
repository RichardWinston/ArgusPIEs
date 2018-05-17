unit ProjectFunctions;

interface

uses AnePIE, Forms, sysutils, Controls, classes, Dialogs, ExcelLink, stdctrls;

function GProjectNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

function GEditForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;

procedure GClearForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;

procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;

var
  FormDataAsString : string;
  frmExcelLink : TfrmExcelLink;
  EditWindowOpen : boolean = False;

implementation

uses  ANECB, GetANEFunctionsUnit, ANE_LayerUnit  ;

function GProjectNew (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

var
  layerString : ANE_STR;
  ALayerStructure : TLayerStructure;
  DomainOutline : T_ANE_DomainOutlineLayer;
  Density : T_ANE_DensityLayer;
  GridLayer : T_ANE_GridLayer;
  InfoLayer : T_ANE_InfoLayer;
  DomainParam, DensityParam, InfoParam : T_ANE_LayerParam;
  GridParam : T_ANE_GridParam;

begin
  frmExcelLink := TfrmExcelLink.Create(Application);
  try
    begin

      if frmExcelLink.ShowModal = mrOK
      then
        begin
          ALayerStructure := TLayerStructure.Create;
          try
            DomainOutline := T_ANE_DomainOutlineLayer.Create(ALayerStructure.UnIndexedLayers, -1);
            Density := T_ANE_DensityLayer.Create(ALayerStructure.UnIndexedLayers, -1);
            GridLayer := T_ANE_GridLayer.Create(ALayerStructure.UnIndexedLayers, -1);
            InfoLayer := T_ANE_InfoLayer.Create(ALayerStructure.UnIndexedLayers, -1);

            DomainParam := T_ANE_LayerParam.Create(DomainOutline.ParamList, -1);
            DensityParam := T_ANE_LayerParam.Create(Density.ParamList, -1);
            GridParam := T_ANE_GridParam.Create(GridLayer.ParamList, -1);
            InfoParam := T_ANE_LayerParam.Create(InfoLayer.ParamList, -1);

            FormDataAsString := ALayerStructure.WriteLayers(Handle);
          finally
            ALayerStructure.Free;
          end;

          layerString := PChar(FormDataAsString);

          rPIEHandle^ := frmExcelLink;

          rLayerTemplate^ := layerString;
          result := true;
          frmExcelLink.Hide;
          ANE_ProcessEvents(Handle);
        end
      else
        begin
          frmExcelLink.Free;
          frmExcelLink := nil;
          result := false;
        end;
    end;
  except on Exception do
    begin
      frmExcelLink.Free;
      result := False;
    end;
  end;

end; { GSimpleExportTemplate }

function GEditForm (aneHandle : ANE_PTR ;
          PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;
begin
  if EditWindowOpen
  then
    begin
      Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 3
        begin
          try  // try 2
            begin
              frmExcelLink := PIEHandle;
              result := (frmExcelLink.ShowModal = mrOK);

            end; // try 2
          except on Exception do
            begin
                result := False;
            end;
          end  // try 2
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 3
    end; // if EditWindowOpen else

end; { GEditForm }



procedure GClearForm(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ); cdecl;
begin

    frmExcelLink := PIEHandle;
    frmExcelLink.Free;

end; { GClearForm }

procedure GSaveForm(aneHandle : ANE_PTR ; PIEHandle : ANE_PTR ;
   rSaveInfo : ANE_STR_PTR ); cdecl;
var
  AnANE_STR : ANE_STR;
  AStringList : TSTringList;
  Index : Integer;
  AnEdit : TEdit;
begin
  AnANE_STR := nil;
  frmExcelLink := PIEHandle;
  if frmExcelLink <> nil then
  begin
    AStringList := TSTringList.Create;
    try
      for Index := 0 to frmExcelLink.ComponentCount -1 do
      begin
        if frmExcelLink.Components[Index] is TEDit then
        begin
          AnEdit := TEDit(frmExcelLink.Components[Index]);
          AStringList.Add(AnEdit.Name);
          AStringList.Add(AnEdit.Text);
        end;
      end;
      FormDataAsString := AStringList.Text;
    finally
      AStringList.Free;
    end;

    AnANE_STR := PChar(FormDataAsString);
  end;
  rSaveInfo^ := AnANE_STR;
end;


procedure GLoadForm(aneHandle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
  const LoadInfo : ANE_STR ); cdecl;
var
  DataToRead : string;
  Developer : string;
  AStringList : TSTringList;
  Index : Integer;
  AnEdit : TEdit;
  AName, AString : string;
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
            frmExcelLink := TfrmExcelLink.Create(Application);
            rPIEHandle^ := frmExcelLink;

            DataToRead := String(LoadInfo);

            AStringList := TSTringList.Create;
            try
              AStringList.Text := DataToRead;
              for Index := 0 to (AStringList.Count div 2) -1 do
              begin
                AName := AStringList[Index*2];
                AString := AStringList[Index*2+1];
                AnEdit := frmExcelLink.FindComponent( AName ) as TEdit;
                AnEdit.Text :=  AString;
                if Assigned(AnEdit.OnChange) then
                begin
                  AnEdit.OnChange(AnEdit);
                end;
              end;
            finally
              AStringList.Free;
            end;
      end;
    except on Exception do
      begin
        Beep;
        MessageDlg('Error when reading File. ' +
          'Close this file without saving it. ' +
          'Contact PIE developer ' + Developer + ' for assistance.', mtError,
          [mbOK], 0);
      end;
    end;
  end;

end;


end.
