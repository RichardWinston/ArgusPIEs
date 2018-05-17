unit EditDatLayerUnit;

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

var
   gEditDataPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gEditDataImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gContour2DataPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gContour2DataImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor


procedure GEditDataLayerPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR; const Importing : boolean = False); cdecl;
   
procedure GContour2DataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

implementation

uses ANECB, OptionsUnit, frmDataEditUnit, frmDataLayerNameUnit, ChooseLayerUnit;

procedure GEditDataLayerPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR; const Importing : boolean = False); cdecl;
begin
  layerHandle := GetExistingLayer(aneHandle,
    [pieDataLayer]);

  if layerHandle = nil then
  begin
    MessageDlg('Canceling: no data layer exists.', mtInformation, [mbOK], 0);
  end
  else
  begin
    Application.CreateForm(TfrmDataEdit, frmDataEdit);
    try
      frmDataEdit.CurrentModelHandle := aneHandle;
      frmDataEdit.GetData(layerHandle, Importing);
      if Importing then
      begin
        frmDataEdit.pcMain.ActivePage := frmDataEdit.tabTable;
      end;
      if frmDataEdit.OK then
      begin
        frmDataEdit.ShowModal;
      end;
    finally
      FreeAndNil(frmDataEdit);
    end;
  end;
end;

procedure GContour2DataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
begin
  layerHandle := GetExistingLayerWithContours(aneHandle,
    [pieInformationLayer, pieDomainLayer]);

  if layerHandle <> nil then
  begin
    Application.CreateForm(TfrmDataLayerName, frmDataLayerName);
    try
      frmDataLayerName.CurrentModelHandle := aneHandle;
      frmDataLayerName.GetLayerNames;
//      frmDataLayerName.lblLayerName.Caption := 'Layer Name';
      if (frmDataLayerName.ShowModal = mrOK) and frmDataLayerName.OK then
      begin
        Application.CreateForm(TfrmDataEdit, frmDataEdit);
        try
          frmDataEdit.CurrentModelHandle := aneHandle;
          frmDataEdit.GetContourData(layerHandle);
          if frmDataEdit.OK then
          begin
            frmDataEdit.LayerHandle := frmDataLayerName.LayerHandle;
            frmDataEdit.btnOKClick(frmDataEdit.btnOK);
          end;
        finally
          frmDataEdit.Free;
        end;
      end;
    finally
      frmDataLayerName.Free;
    end;
  end;
end;

end.
