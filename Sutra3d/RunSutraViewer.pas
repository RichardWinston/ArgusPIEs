unit RunSutraViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AnePIE, ShellAPI;

type
  TfrmRunSutraViewer = class(TForm)
    edFilePath: TEdit;
    edSutraViewerPath: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TBitBtn;
    btnNodePath: TButton;
    btnSutraViewerPath: TButton;
    OpenDialog1: TOpenDialog;
    btnOK: TBitBtn;
    procedure btnNodePathClick(Sender: TObject);
    procedure btnSutraViewerPathClick(Sender: TObject);
    procedure edSutraViewerPathChange(Sender: TObject);
    procedure edFilePathChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentModelHandle : ANE_PTR;
  end;

{procedure RunSutraViewerPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl; }
  
var
  frmRunSutraViewer: TfrmRunSutraViewer;

implementation

{$R *.DFM}

uses OptionsUnit, frmSutraUnit, ANE_LayerUnit, ArgusFormUnit;

var
  Template : ANE_STR;



procedure TfrmRunSutraViewer.btnNodePathClick(Sender: TObject);
begin
  OpenDialog1.FileName := edFilePath.Text;
  OpenDialog1.Filter := 'Node files (*.nod)|*.nod|All files (*.*)|*.*';
  if OpenDialog1.Execute then
  begin
    edFilePath.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmRunSutraViewer.btnSutraViewerPathClick(Sender: TObject);
var
  ADir : String;
begin
  ADir := GetCurrentDir;
  OpenDialog1.FileName := edSutraViewerPath.Text;
  OpenDialog1.Filter := 'Programs (*.exe)|*.exe|All files (*.*)|*.*';
  if OpenDialog1.Execute then
  begin
    edSutraViewerPath.Text := OpenDialog1.FileName;
  end;
  SetCurrentDir(ADir);
end;

procedure TfrmRunSutraViewer.edSutraViewerPathChange(Sender: TObject);
begin
  if FileExists(edSutraViewerPath.Text) then
  begin
    edSutraViewerPath.Color := clWindow;
  end
  else
  begin
    edSutraViewerPath.Color := clRed;
  end;
end;

procedure TfrmRunSutraViewer.edFilePathChange(Sender: TObject);
begin
  if FileExists(edFilePath.Text) then
  begin
    edFilePath.Color := clWindow;
  end
  else
  begin
    edFilePath.Color := clRed;
  end;

end;

procedure TfrmRunSutraViewer.FormCreate(Sender: TObject);
begin
  edSutraViewerPathChange(Sender);
  edFilePathChange(Sender);
end;

{procedure RunPIE(aneHandle : ANE_PTR) ; cdecl;
const
  Extension = '.nod';
var
  DotPosition : integer;
  ProjectOptions : TProjectOptions;
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
    try  // try 1
      begin
        Try
          begin
            frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
              as TfrmSutra;
            frmRunSutraViewer := TfrmRunSutraViewer.Create(application);
            frmRunSutraViewer.edSutraViewerPath.Text :=
              frmSutra.edSutraViewerPath.Text;
            try
              begin
                frmRunSutraViewer.CurrentModelHandle := aneHandle;
                ProjectOptions := TProjectOptions.Create;
                try
                  frmRunSutraViewer.edFilePath.Text := frmSutra.edRoot.Text;
                  if frmRunSutraViewer.edFilePath.Text = '' then
                  begin
                    frmRunSutraViewer.edFilePath.Text :=
                      ExtractFileName(ProjectOptions.ProjectName[aneHandle]);
                    DotPosition := Pos('.',frmRunSutraViewer.edFilePath.Text);
                    if DotPosition > 0 then
                    begin
                      frmRunSutraViewer.edFilePath.Text :=
                        Copy(frmRunSutraViewer.edFilePath.Text,1,DotPosition-1)
                    end;
                  end;
                  frmRunSutraViewer.edFilePath.Text :=
                    GetCurrentDir + '\' +
                    frmRunSutraViewer.edFilePath.Text + '.nod';

                finally
                  ProjectOptions.Free;
                end;
                if frmRunSutraViewer.ShowModal = mrOk then
                begin
                  frmSutra.edSutraViewerPath.Text :=
                    frmRunSutraViewer.edSutraViewerPath.Text;
                end;
              end;
            finally
              begin
                frmRunSutraViewer.Free
              end;
            end;

          end
        except on E: Exception do
          begin
            Beep;
            MessageDlg('The following error occured while attempting to start SutraViewer. "'
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
end;  }

{procedure RunSutraViewerPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
begin
  RunPIE(aneHandle);
  returnTemplate^ := Template;
end; }

procedure TfrmRunSutraViewer.btnOKClick(Sender: TObject);
begin
  ShellExecute(frmRunSutraViewer.Handle,
    nil,
    PChar(edSutraViewerPath.Text),
    PChar('"' + edFilePath.Text + '"'),
    PChar(ExtractFileDir(edFilePath.Text)),
    SW_SHOWNORMAL);
end;

end.
