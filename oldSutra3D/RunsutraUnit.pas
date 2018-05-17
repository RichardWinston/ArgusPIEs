unit RunsutraUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE;

type
  TfrmRun = class(TForm)
    cbExternal: TCheckBox;
    rgAlert: TRadioGroup;
    rgRunSutra: TRadioGroup;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    btnEdit: TButton;
    edSutraPath: TEdit;
    lblPath: TLabel;
    BitBtn3: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    gbExport: TGroupBox;
    cbExport14B: TCheckBox;
    cbExport15B: TCheckBox;
    cbExport17: TCheckBox;
    cbExport18: TCheckBox;
    cbExport19: TCheckBox;
    cbExport20: TCheckBox;
    cbExport22: TCheckBox;
    cbExport8D: TCheckBox;
    cbExportICS2: TCheckBox;
    cbExportICS3: TCheckBox;
    cbExportNBI: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure edSutraPathChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentModelHandle : ANE_PTR;
  end;

var
  frmRun: TfrmRun;

procedure RunSutraPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;

implementation

uses frmSutraUnit, ANE_LayerUnit, ArgusFormUnit, UtilityFunctions,
  ProjectFunctions, OptionsUnit;

{$R *.DFM}

var
  Template : ANE_STR;

procedure RunPIE(aneHandle : ANE_PTR{;  WarningMessage : string}) ; cdecl;
const
  LastTemplate = 'LastTemplate.met';
var
  MetFileName : string;
  TemplateStringList : TStringList;
  LastTemplatePath : string;
//  ProjectOptions : TProjectOptions;
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from openning because that would corrupt the data
  // for the other model.
  Template := nil;
  if EditWindowOpen
  then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    // make sure the project options used in exporting data are set correctly.
    try  // try 1
      begin
        Try
          begin
            {$IFDEF Argus5}
            ProjectOptions := TProjectOptions.Create;
            try
              ProjectOptions.ExportWrap[aneHandle] := 0;
              ProjectOptions.ExportSeparator[aneHandle] := ' ';
            finally
              ProjectOptions.Free;
            end;
            {$ENDIF}
            frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
              as TfrmSutra;
{            if not okToRun(AProgram) then
            begin
              Beep;
              MessageDlg(WarningMessage, mtWarning, [mbOK], 0);
            end
            else
            begin  }
              frmRun := TfrmRun.Create(application);
              try
                begin
                  frmRun.CurrentModelHandle := aneHandle;
                  if frmRun.ShowModal = mrOK then
                  begin
                      frmRun.Cursor := crHourGlass;
                      TemplateStringList := TStringList.Create;
                      try
                        begin
                          MetFileName := 'sutra.met';
                          Template := frmSutra.ProcessTemplate(DLLName,
                            MetFileName, '', nil, TemplateStringList);
                          GetDllDirectory(DLLName, LastTemplatePath) ;
                          LastTemplatePath := LastTemplatePath + '\' + LastTemplate;
                          TemplateStringList.SaveToFile(LastTemplatePath);
                        end
                      finally
                        begin
                          frmRun.Cursor := crDefault;
                          TemplateStringList.Free;
                        end;
                      end;
                  end;
                end;
              finally
                begin
                  frmRun.Free
                end;
              end;
//            end;

          end
        except on E: Exception do
          begin
            Beep;
            MessageDlg('The following error occured while processing export template. "'
             + E.Message + '"', mtError, [mbOK], 0);
            Template := nil;
          end;
        end;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
//  returnTemplate^ := Template;
end;

procedure RunSutraPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
begin
//  aProgram := progMODFLOW;
  RunPIE(aneHandle);
  returnTemplate^ := Template;
end;


procedure TfrmRun.btnOKClick(Sender: TObject);
var
  ProjectOptions : TProjectOptions;
  DotPosition : integer;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    SaveDialog1.FileName := ExtractFileName(ProjectOptions.ProjectName[CurrentModelHandle]);
    DotPosition := Pos('.',SaveDialog1.FileName);
    if DotPosition > 0 then
    begin
      SaveDialog1.FileName := Copy(SaveDialog1.FileName,1,DotPosition-1)
    end;
    SaveDialog1.FileName := SaveDialog1.FileName + '.' + SaveDialog1.DefaultExt;
  finally
    ProjectOptions.Free;
  end;
  if SaveDialog1.Execute then
  begin
    frmSutra.rgRunSutra.ItemIndex := rgRunSutra.ItemIndex;
    frmSutra.rgAlert.ItemIndex := rgAlert.ItemIndex;
    frmSutra.cbExternal.Checked := cbExternal.Checked;
    frmSutra.edRoot.Text := ExtractFileName(SaveDialog1.FileName);
    DotPosition := Pos('.',frmSutra.edRoot.Text);
    if DotPosition > 0 then
    begin
      frmSutra.edRoot.Text := Copy(frmSutra.edRoot.Text,1,DotPosition-1)
    end;

    frmSutra.edRunSutra.Text := edSutraPath.Text;

    frmSutra.cbExportNBI.Checked := cbExportNBI.Checked;
    frmSutra.cbExport8D.Checked := cbExport8D.Checked;
    frmSutra.cbExport14B.Checked := cbExport14B.Checked;
    frmSutra.cbExport15B.Checked := cbExport15B.Checked;
    frmSutra.cbExport17.Checked := cbExport17.Checked;
    frmSutra.cbExport18.Checked := cbExport18.Checked;
    frmSutra.cbExport19.Checked := cbExport19.Checked;
    frmSutra.cbExport20.Checked := cbExport20.Checked;
    frmSutra.cbExport22.Checked := cbExport22.Checked;
    frmSutra.cbExportICS2.Checked := cbExportICS2.Checked;
    frmSutra.cbExportICS3.Checked := cbExportICS3.Checked;

  end
  else
  begin
    ModalResult := mrNone;
  end;

end;

procedure TfrmRun.FormCreate(Sender: TObject);
begin
  rgRunSutra.ItemIndex := frmSutra.rgRunSutra.ItemIndex;
  rgAlert.ItemIndex := frmSutra.rgAlert.ItemIndex;
  cbExternal.Checked := frmSutra.cbExternal.Checked;
  edSutraPathChange(Sender);
  edSutraPath.Text :=  frmSutra.edRunSutra.Text ;

  cbExportNBI.Checked := frmSutra.cbExportNBI.Checked;
  cbExport8D.Checked := frmSutra.cbExport8D.Checked;
  cbExport14B.Checked := frmSutra.cbExport14B.Checked;
  cbExport15B.Checked := frmSutra.cbExport15B.Checked;
  cbExport17.Checked := frmSutra.cbExport17.Checked;
  cbExport18.Checked := frmSutra.cbExport18.Checked;
  cbExport19.Checked := frmSutra.cbExport19.Checked;
  cbExport20.Checked := frmSutra.cbExport20.Checked;
  cbExport22.Checked := frmSutra.cbExport22.Checked;
  cbExportICS2.Checked := frmSutra.cbExportICS2.Checked;
  cbExportICS3.Checked := frmSutra.cbExportICS3.Checked;
end;

procedure TfrmRun.btnEditClick(Sender: TObject);
begin
  if EditForm then
  begin
    FormCreate(Sender);
  end;
end;

procedure TfrmRun.edSutraPathChange(Sender: TObject);
begin
  if FileExists(edSutraPath.Text) then
  begin
    edSutraPath.Color := clWindow;
  end
  else
  begin
    edSutraPath.Color := clRed;
  end;
end;

procedure TfrmRun.btnBrowseClick(Sender: TObject);
var
  Directory : string;
begin
  Directory := GetCurrentDir;
  try
    OpenDialog1.FileName := edSutraPath.Text;
    if OpenDialog1.Execute then
    begin
        edSutraPath.Text := OpenDialog1.FileName;
    end;
  finally
    SetCurrentDir(Directory);
  end;

end;

end.
