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
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnEdit: TButton;
    edSutraPath: TEdit;
    lblPath: TLabel;
    OpenDialog1: TOpenDialog;
    BitBtn3: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
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
  ProjectFunctions;

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
  {$IFDEF Argus5}
  ProjectOptions : TProjectOptions;
  {$ENDIF}
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
    {$IFDEF Argus5}
    ProjectOptions := TProjectOptions.Create(aneHandle);
    try
      ProjectOptions.ExportWrap := 0;
      ProjectOptions.ExportSeparator := ' ';
    finally
      ProjectOptions.Free;
    end;
    {$ENDIF}
    try  // try 1
      begin
        Try
          begin
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


procedure TfrmRun.BitBtn1Click(Sender: TObject);
begin
  frmSutra.rgRunSutra.ItemIndex := rgRunSutra.ItemIndex;
  frmSutra.rgAlert.ItemIndex := rgAlert.ItemIndex;
  frmSutra.cbExternal.Checked := cbExternal.Checked;
end;

procedure TfrmRun.FormCreate(Sender: TObject);
begin
  rgRunSutra.ItemIndex := frmSutra.rgRunSutra.ItemIndex;
  rgAlert.ItemIndex := frmSutra.rgAlert.ItemIndex;
  cbExternal.Checked := frmSutra.cbExternal.Checked;
  edSutraPathChange(Sender);
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
begin
  OpenDialog1.FileName := edSutraPath.Text;
  if OpenDialog1.Execute then
  begin
    edSutraPath.Text := OpenDialog1.FileName;
  end;

end;

end.
