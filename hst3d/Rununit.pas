unit RunUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TRunForm = class(TForm)
    btnRun: TButton;
    rgRunChoice: TRadioGroup;
    BitBtn1: TBitBtn;
    btnBrowse: TButton;
    btnEdParam: TButton;
    edRunPath: TEdit;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    edBCFLOWPath: TEdit;
    btnBrowseBCFLOW: TButton;
    BitBtn2: TBitBtn;
    cbPauseDos: TCheckBox;
    procedure btnRunClick(Sender: TObject);
    procedure btnEdParamClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnBrowseClick(Sender: TObject);
    procedure edRunPathChange(Sender: TObject);
    procedure rgRunChoiceClick(Sender: TObject);
    procedure btnBrowseBCFLOWClick(Sender: TObject);
    procedure edBCFLOWPathChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cbPauseDosClick(Sender: TObject);
  private
    { Private declarations }
  public
    ExportTemplate : TStringList;
    { Public declarations }
  end;

{var
  RunForm: TRunForm;  }

implementation

{$R *.DFM}

uses ShellAPI, FileCtrl, ANECB, ANE_LayerUnit, HST3D_PIE_Unit, HST3DUnit,
     ShowHelpUnit;


procedure TRunForm.btnRunClick(Sender: TObject);
begin
  case rgRunChoice.ItemIndex of
    0, 1:
      begin
        if FileExists(edRunPath.Text)
        then
          begin
            ModalResult := mrOK;
          end
        else
          begin
            MessageDlg(edRunPath.Text + ' does not exist.', mtError,  [mbOK], 0)
          end;
      end;
    2, 3:
      begin
        if FileExists(edBCFLOWPath.Text)
        then
          begin
            ModalResult := mrOK;
          end
        else
          begin
            MessageDlg(edBCFLOWPath.Text + ' does not exist.', mtError,  [mbOK], 0)
          end;
      end;
  end;
end;

procedure TRunForm.btnEdParamClick(Sender: TObject);
begin
  With PIE_Data do
  begin
    if HST3DForm.ShowModal = mrOK
    then
      begin
        Screen.Cursor := crHourGlass;
        HST3DForm.LayerStructure.OK(PIE_Data.HST3DForm.CurrentModelHandle);
        Screen.Cursor := crDefault;
      end
    else
      begin
        Screen.Cursor := crHourGlass;
        HST3DForm.LayerStructure.Cancel;
        HST3DForm.StringToForm(FormDataAsString, HST3DForm);
        HST3DForm.LayerStructure.SetStatus(sNormal);
        Screen.Cursor := crDefault;
      end;
  end;
  ANE_ProcessEvents(PIE_Data.HST3DForm.CurrentModelHandle )
end;

procedure TRunForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ANE_ProcessEvents(PIE_Data.HST3DForm.CurrentModelHandle )

end;

procedure TRunForm.btnBrowseClick(Sender: TObject);
var
  path : string;
begin
  OpenDialog1.FileName := '';
  if FileExists(edRunPath.Text)
  then
    begin
      OpenDialog1.FileName := edRunPath.Text;
    end
  else
    begin
      if DirectoryExists(edRunPath.Text)
      then
        begin
          OpenDialog1.InitialDir := edRunPath.Text
        end
      else
        begin
          path := ExtractFilePath(edRunPath.Text);
          if DirectoryExists(path) then
          begin
            OpenDialog1.InitialDir := Path;
          end
        end;
    end;
//  OpenDialog1.FileName := edRunPath.Text;
  if OpenDialog1.Execute then
  begin
    edRunPath.Text := ExtractShortPathName(OpenDialog1.FileName);
  end;
end;

procedure TRunForm.edRunPathChange(Sender: TObject);
begin
  PIE_Data.HST3DForm.edPath.Text := edRunPath.Text;
end;

procedure TRunForm.rgRunChoiceClick(Sender: TObject);
begin
  PIE_Data.HST3DForm.rgExportDecision.ItemIndex := rgRunChoice.ItemIndex;

end;

procedure TRunForm.btnBrowseBCFLOWClick(Sender: TObject);
var
  path : string;
begin
  OpenDialog1.FileName := '';
  if FileExists(edBCFLOWPath.Text)
  then
    begin
      OpenDialog1.FileName := edBCFLOWPath.Text;
    end
  else
    begin
      if DirectoryExists(edBCFLOWPath.Text)
      then
        begin
          OpenDialog1.InitialDir := edBCFLOWPath.Text
        end
      else
        begin
          path := ExtractFilePath(edBCFLOWPath.Text);
          if DirectoryExists(path) then
          begin
            OpenDialog1.InitialDir := Path;
          end
        end;
    end;
//  OpenDialog1.FileName := edBCFLOWPath.Text;
  if OpenDialog1.Execute then
  begin
    edBCFLOWPath.Text := ExtractShortPathName(OpenDialog1.FileName);
  end;

end;

procedure TRunForm.edBCFLOWPathChange(Sender: TObject);
begin
  PIE_Data.HST3DForm.edBCFLOWPath.Text := edBCFLOWPath.Text;

end;

procedure TRunForm.FormShow(Sender: TObject);
begin
  rgRunChoice.Items.Clear;
  rgRunChoice.Items.Add('Create HST3D input files');
  rgRunChoice.Items.Add('Create HST3D input files and run HST3D');

  if PIE_Data.HST3DForm.cbUseBCFLOW.Checked
  then
    begin
      rgRunChoice.Items.Add('Create BCFLOW input files');
      rgRunChoice.Items.Add('Create BCFLOW input files and run BCFLOW');
    end;
  rgRunChoice.ItemIndex := 1;
{  if PIE_Data.HST3DForm.IsRegistered
    and (PIE_Data.HST3DForm.raRegister.User = 'Richard B. Winston') then
  begin
    cbUseUnencrypted.Visible := True;
  end;   }
end;

procedure TRunForm.FormCreate(Sender: TObject);
begin
  ExportTemplate := TStringList.Create;

end;

procedure TRunForm.FormDestroy(Sender: TObject);
begin
  ExportTemplate.Free;

end;

procedure TRunForm.BitBtn2Click(Sender: TObject);
begin

  ShowSpecificHTMLHelp('run.htm');
end;

procedure TRunForm.cbPauseDosClick(Sender: TObject);
begin
  PIE_Data.HST3DForm.cbPauseDos.Checked := cbPauseDos.Checked;

end;

end.
