unit frmImportChoicesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, AnePIE;

type
  TfrmImportChoices = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    rgChoice: TRadioGroup;
    BitBtn1: TBitBtn;
    btnAbout: TButton;
    procedure rgChoiceClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure GImportChoicesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

var
  frmImportChoices: TfrmImportChoices;

implementation

uses frmAboutUnit, GridUnit, ImportPointsUnit, ImportContoursUnit, frmDEM_Unit,
  frmMeshLayerChoiceUnit, CheckVersionFunction, EditDatLayerUnit,
  frmSamplePoints_Unit, frmPasteContoursUnit, frmImportShapeUnit,
  frmImportRasterDataUnit;

{$R *.DFM}

procedure TfrmImportChoices.rgChoiceClick(Sender: TObject);
begin
  btnOK.Enabled := True;
end;

procedure TfrmImportChoices.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;
end;

procedure GImportChoicesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
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
           9: // Sample Data...
             begin
              GImportShapePIE(aneHandle,  fileName, layerHandle);
             end;
           10: // Raster data
             begin
               GImportRasterDataPIE(aneHandle,  fileName, layerHandle);
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
end;

end.
