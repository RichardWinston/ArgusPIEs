unit RunMT3DUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RunUnit, Buttons, StdCtrls, ArgusDataEntry, ExtCtrls, ComCtrls, ANEPIE,
  ProgramToRunUnit;

type
  TfrmRunMT3D = class(TfrmRun)
    rbRunMT3D: TRadioButton;
    rbCreateMT3D: TRadioButton;
    cbExpLak: TCheckBox;
    lblLake: TLabel;
    adeMT3DPath: TArgusDataEntry;
    btnMT3D: TButton;
    gboxMT3DPackages: TGroupBox;
    lblMT3DBasic: TLabel;
    lblMT3DAdvec: TLabel;
    lblMT3DDisp: TLabel;
    lblSourceSink: TLabel;
    lblMT3DReact: TLabel;
    cbExportMT3DBTN: TCheckBox;
    cbExportMT3DADV: TCheckBox;
    cbExportMT3DDSP: TCheckBox;
    cbExportMT3DSSM: TCheckBox;
    cbExportMT3DRCT: TCheckBox;
    rgMODFLOWVersion: TRadioGroup;
    lblMT3DWarning2: TLabel;
    lblMT3DPath: TLabel;
    cbExpSPG: TCheckBox;
    lblExportSeepage: TLabel;
    procedure btOKClick(Sender: TObject); override;
    procedure FormCreate(Sender: TObject); override;
    procedure rgMODFLOWVersionClick(Sender: TObject); virtual;
    procedure btnMT3DClick(Sender: TObject); virtual;
    procedure btnEditClick(Sender: TObject); override;
    procedure ModelButtonClick(Sender: TObject); override;
    procedure adeModelPathChange(Sender: TObject); override;
  private
    { Private declarations }
  public
    function GetMetFileName: string; override;
    procedure SelectProgram; override;
    procedure Modflow88Warning; virtual;
    function GetProgramPath: string; override;
    { Public declarations }
  end;

var
  frmRunMT3D: TfrmRunMT3D;

procedure RunMT3DPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;

implementation

{$R *.DFM}

uses {MT3DFormUnit,} Variables;

procedure TfrmRunMT3D.btOKClick(Sender: TObject);
begin
  inherited;
  frmMODFLOW.rgMODFLOWVersion.ItemIndex := rgMODFLOWVersion.ItemIndex;

  frmMODFLOW.cbExportMT3DBTN.Checked :=  cbExportMT3DBTN.Checked      ;
  frmMODFLOW.cbExportMT3DADV.Checked :=  cbExportMT3DADV.Checked      ;
  frmMODFLOW.cbExportMT3DDSP.Checked :=  cbExportMT3DDSP.Checked      ;
  frmMODFLOW.cbExportMT3DSSM.Checked :=  cbExportMT3DSSM.Checked      ;
  frmMODFLOW.cbExportMT3DRCT.Checked :=  cbExportMT3DRCT.Checked      ;

//  frmMODFLOW.cbExpStr.Checked :=  cbExpStr.Checked      ;
  frmMODFLOW.cbExpLak.Checked :=  cbExpLak.Checked      ;
  frmMODFLOW.cbExpSPG.Checked :=  cbExpSPG.Checked      ;

  if ExtractShortPathName(adeMT3DPath.Text) <> '' then
  begin
    frmMODFLOW.adeMT3DPath.Text := ExtractShortPathName(adeMT3DPath.Text);
  end
  else
  begin
    frmMODFLOW.adeMT3DPath.Text := adeMT3DPath.Text;
  end;
                            
  frmMODFLOW.rbRunMT3D.Checked :=  rbRunMT3D.Checked      ;
  frmMODFLOW.rbCreateMT3D.Checked :=  rbCreateMT3D.Checked      ;

  if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
      if not FileExists(adeMT3DPath.Text) then
      begin
        if MessageDlg(adeMT3DPath.Text + ' does not exist. '
          + 'Do you still wish to export the MT3D input files?',
          mtWarning, [mbYes, mbNo], 0) = mrYes
          then ModalResult := mrOK else ModalResult := mrCancel
      end;
  end;
  Modflow88Warning;
end;

procedure TfrmRunMT3D.SelectProgram;
begin
  case aProgram of
    progMT3D:
      begin
        if not (rbRunMT3D.Checked or rbCreateMT3D.Checked) then
        begin
          rbRunMT3D.Checked := True;
        end;
      end;
    else
      begin
        inherited;
      end;
  end;

end;

function TfrmRunMT3D.GetProgramPath : string;
begin
  result := inherited GetProgramPath;
  if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    result := adeMT3DPath.Text;
  end;
end;


procedure TfrmRunMT3D.FormCreate(Sender: TObject);
begin
  inherited;
  rgMODFLOWVersion.ItemIndex := frmMODFLOW.rgMODFLOWVersion.ItemIndex;

  cbExportMT3DBTN.Checked :=  frmMODFLOW.cbExportMT3DBTN.Checked      ;
  cbExportMT3DADV.Checked :=  frmMODFLOW.cbExportMT3DADV.Checked      ;
  cbExportMT3DDSP.Checked :=  frmMODFLOW.cbExportMT3DDSP.Checked      ;
  cbExportMT3DSSM.Checked :=  frmMODFLOW.cbExportMT3DSSM.Checked      ;
  cbExportMT3DRCT.Checked :=  frmMODFLOW.cbExportMT3DRCT.Checked      ;

//  cbExpStr.Checked :=  frmMODFLOW.cbExpStr.Checked      ;
  cbExpLak.Checked :=  frmMODFLOW.cbExpLak.Checked      ;
  cbExpSPG.Checked :=  frmMODFLOW.cbExpSPG.Checked      ;

  adeMT3DPath.Text := frmMODFLOW.adeMT3DPath.Text;

  rbRunMT3D.Checked :=  frmMODFLOW.rbRunMT3D.Checked      ;
  rbCreateMT3D.Checked :=  frmMODFLOW.rbCreateMT3D.Checked      ;
  rbRunMT3D.enabled :=  frmMODFLOW.cbMT3D.Checked      ;
  rbCreateMT3D.enabled :=  frmMODFLOW.cbMT3D.Checked      ;
  adeMT3DPath.enabled :=  frmMODFLOW.cbMT3D.Checked      ;
  btnMT3D.enabled :=  frmMODFLOW.cbMT3D.Checked      ;
  
  cbExportMT3DBTN.Enabled :=  frmMODFLOW.cbMT3D.Checked       ;
  cbExportMT3DADV.Enabled :=  frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbADV.Checked      ;
  cbExportMT3DDSP.Enabled :=  frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbDSP.Checked      ;
  cbExportMT3DSSM.Enabled :=  frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked      ;
  cbExportMT3DRCT.Enabled :=  frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbRCT.Checked      ;

//  cbExpStr.Enabled :=  frmMODFLOW.cbSTR.Checked      ;
  cbExpLak.Enabled :=  frmMODFLOW.cbLAK.Checked      ;
  cbExpSPG.Enabled :=  frmMODFLOW.cbSPG.Checked and  frmMODFLOW.cbSPGRetain.Checked ;

  gboxMFOutputPackages.Enabled := rbRun.Checked or rbCreate.Checked;
//  gboxMT3DPackages.Enabled := rbRunMT3D.Checked or rbCreateMT3D.Checked;

  cbUseSolute.Enabled := (rbRun.Checked or rbCreate.Checked) and frmMODFLOW.cbMOC3D.Checked;
  if not cbUseSolute.Enabled then
  begin
    cbUseSolute.Checked := False;
  end;

  SelectProgram;

  if not rbRunMT3D.Enabled then
  begin
    rbRunMT3D.Checked := False;
  end;

  if not rbCreateMT3D.Enabled then
  begin
    rbCreateMT3D.Checked := False;
  end;
  ModelButtonClick(rbRun);
  adeModelPathChange(Sender);
end;

procedure TfrmRunMT3D.rgMODFLOWVersionClick(Sender: TObject);
begin
  inherited;
  cbUseSolute.Enabled := (rgMODFLOWVersion.ItemIndex = 1);
  if not cbUseSolute.Enabled then
  begin
    cbUseSolute.Checked := False;
  end;
  if (rgMODFLOWVersion.ItemIndex = 0) and frmModflow.cbFHB.Checked then
  begin
    Beep;
    MessageDlg('Warning: the Flow-and-Head Boundary Package does not occur '
      + 'in MODFLOW88. ', mtWarning, [mbOK], 0);
  end;
  if (rgMODFLOWVersion.ItemIndex = 0) and frmModflow.cbExpSPG.Checked then
  begin
    Beep;
    MessageDlg('Warning: the Seepage Package is not supported by this interface '
      + 'in MODFLOW88. ', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmRunMT3D.btnMT3DClick(Sender: TObject);
begin
  inherited;
  opendialGetPath.FileName := adeMT3DPath.Text;
  if opendialGetPath.Execute then
  begin
    adeMT3DPath.Text := opendialGetPath.FileName;
  end;

end;

procedure TfrmRunMT3D.btnEditClick(Sender: TObject);
begin
  inherited;
  FormCreate(Sender);
end;

procedure TfrmRunMT3D.ModelButtonClick(Sender: TObject);
begin
  inherited;
  rgMODFLOWVersion.visible := rbRun.Checked or rbCreate.Checked;
//  lblWarning1.Visible := gboxMFOutputPackages.Enabled;
{  lblWarning2.Visible := gboxMFOutputPackages.Enabled;
  lblWarning3.Visible := gboxMFOutputPackages.Enabled;
  lblWarning4.Visible := gboxMFOutputPackages.Enabled; }

  gboxMT3DPackages.visible := rbRunMT3D.Checked or rbCreateMT3D.Checked;
//  lblMT3DWarning1.Visible := gboxMT3DPackages.Enabled;
  lblMT3DWarning2.Visible := gboxMT3DPackages.Visible;

//  cbUseSolute.Enabled := (rbRun.Checked or rbCreate.Checked) and frmMODFLOW.cbMOC3D.Checked;
//  adeModelPathChange(Sender);

end;

function TfrmRunMT3D.GetMetFileName: string;
begin
  result := inherited GetMetFileName;
  if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    result := 'mt3d.met';
  end;
  if (rbRun.Checked or rbCreate.Checked) and (rgMODFLOWVersion.ItemIndex = 0) then
  begin
    result := 'modflow88.met';
  end;
end;

procedure RunMT3DPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
var
  WarningString : string;
begin
  Exporting := True;
  try
    WarningString := 'You can not run MT3D until you first select '
                  + '"Use MT3D" on the "MT3D BAS" tab of the Edit Project Info '
                  + 'dialog box.';
    aProgram := progMT3D;
    RunPIE(aneHandle, WarningString );
    returnTemplate^ := Template;
  finally
    Exporting := False;
  end;
end;

procedure TfrmRunMT3D.adeModelPathChange(Sender: TObject);
begin
//  inherited;
//  TheFileExists := True;
  adeMT3DPath.Color := clWindow;
  if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    if FileExists(adeMT3DPath.Text) then
    begin
      adeMT3DPath.Color := clWindow;
      sbModelStatus.SimpleText := '';
      PanelColor := clBtnFace;
    end
    else
    begin
      adeMT3DPath.Color := clRed;
      sbModelStatus.SimpleText := 'Warning: Executable file does not exist.';
      PanelColor := clRed;
    end;
    sbModelStatus.Repaint;
  end
  else
  begin
    inherited adeModelPathChange(Sender);
  end;

end;

procedure TfrmRunMT3D.Modflow88Warning;
begin
  if (rgMODFLOWVersion.ItemIndex = 0)
    and (rbRun.Checked or rbCreate.Checked) then
  begin
    if (cbExpFHB.Checked and cbExpFHB.Enabled)
      or (cbExpSPG.Checked and cbExpSPG.Enabled) then
    begin
      Beep;
      MessageDlg('Error: The Flow and Head Boundary (FHB) and Seepage (SPG) '
        + 'packages are not supported in the MODFLOW-88 export template.',
        mtError, [mbOK], 0);
      ModalResult := mrNone;
    end;
  end;
end;


end.
