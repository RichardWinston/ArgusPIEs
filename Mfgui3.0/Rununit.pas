unit RunUnit;

interface

{RunUnit defines the form displayed when a user wishes to run a model.
 It also defines the PIE functions used to display the form.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ArgusDataEntry, AnePIE, ComCtrls, ProgramToRunUnit,
  ExtCtrls;

type
  TfrmRun = class(TForm)
    sbModelStatus: TStatusBar;
    pcRun: TPageControl;
    tabModelChoice: TTabSheet;
    gboxRunOption: TGroupBox;
    lblMODFLOWCreate: TLabel;
    rbRun: TRadioButton;
    cbUseSolute: TCheckBox;
    rbCreate: TRadioButton;
    rbRunZonebudget: TRadioButton;
    rbCreateZonebudget: TRadioButton;
    rbMPATHRun: TRadioButton;
    rbMPATHCreate: TRadioButton;
    gboxMFOutputPackages: TGroupBox;
    lblBAS: TLabel;
    lblOC: TLabel;
    lblBCF: TLabel;
    lblRCH: TLabel;
    lblRIV: TLabel;
    lblWEL: TLabel;
    lblDRN: TLabel;
    lblGHB: TLabel;
    lblEVT: TLabel;
    lblMatrix: TLabel;
    lblMOC3DSolute: TLabel;
    lblMOC3DObsWells: TLabel;
    lblHFT: TLabel;
    lblFHBExport: TLabel;
    lblStream: TLabel;
    cbBAS: TCheckBox;
    cbOC: TCheckBox;
    cbBCF: TCheckBox;
    cbRCH: TCheckBox;
    cbRIV: TCheckBox;
    cbWEL: TCheckBox;
    cbDRN: TCheckBox;
    cbGHB: TCheckBox;
    cbEVT: TCheckBox;
    cbMatrix: TCheckBox;
    cbCONC: TCheckBox;
    cbOBS: TCheckBox;
    cbExpHFB: TCheckBox;
    cbExpFHB: TCheckBox;
    cbSTR: TCheckBox;
    tapPath: TTabSheet;
    lblMODFLOWPath: TLabel;
    lblMOC3DPath: TLabel;
    lblZoneBudPath: TLabel;
    lblMODPATH: TLabel;
    adeMODFLOWPath: TArgusDataEntry;
    adeMOC3DPath: TArgusDataEntry;
    btnMODFLOWBrowse: TButton;
    btMOC3DBrowse: TButton;
    adeZonebudgetPath: TArgusDataEntry;
    btnZonebudget: TButton;
    adeMODPATHPath: TArgusDataEntry;
    btnMODPATH: TButton;
    pnlTop: TPanel;
    opendialGetPath: TOpenDialog;
    btnEdit: TButton;
    btOK: TBitBtn;
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    lblWarning1: TLabel;
    cbCalibrate: TCheckBox;
    cbShowWarnings: TCheckBox;
    lblRootname: TLabel;
    adeFileName: TArgusDataEntry;
    cbProgressBar: TCheckBox;
    procedure FormCreate(Sender: TObject); virtual;
    procedure btOKClick(Sender: TObject); virtual;
    procedure BrowseClick(Sender: TObject); virtual;
    procedure btnEditClick(Sender: TObject); virtual;
    procedure ModelButtonClick(Sender: TObject); virtual;
    procedure adeModelPathChange(Sender: TObject); virtual;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; virtual;
    procedure sbModelStatusDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect); virtual;
    procedure adeFileNameExit(Sender: TObject); virtual;
    procedure cbProgressBarClick(Sender: TObject);
  private
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    ExportTemplate : TStringList;
    PanelColor : TColor;
    function GetMetFileName: string; virtual;
    procedure AssignHelpFile(FileName : string) ; virtual;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    procedure ModelPathChange(Sender: TObject); virtual;
    procedure SelectProgram; virtual;
    function GetProgramPath: string; virtual;
    { Public declarations }
  end;

var
  Template : ANE_STR;
  aProgram: ProgramToRun;
  Exporting : boolean;

procedure RunModflowPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;

procedure RunModpathPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;

procedure RunZondbdgtPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;

procedure RunPIE(aneHandle : ANE_PTR;  WarningMessage : string) ; cdecl;
   
implementation

{$R *.DFM}

Uses ANE_LayerUnit, ANECB, ModflowUnit, ArgusFormUnit,
  UtilityFunctions, ProjectFunctions, Variables, OptionsUnit;

procedure RunPIE(aneHandle : ANE_PTR;  WarningMessage : string) ; cdecl;
const
  LastTemplate = 'LastTemplate.met';
var
  MetFileName : string;
  TemplateStringList : TStringList;
  LastTemplatePath : string;
  {$IFDEF Argus5} {This only works with Argus 5}
  ProjectOptions : TProjectOptions;
  {$ENDIF}
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from opening because that would corrupt the data
  // for the other model.
  Template := $0;
  if EditWindowOpen
  then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    // make sure the project options used in exporting data are set correctly.
    {$IFDEF Argus5} {This only works with Argus 5}
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
            frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
              as ModflowTypes.GetModflowFormType;
            if not okToRun(AProgram) then
            begin
              Beep;
              MessageDlg(WarningMessage, mtWarning, [mbOK], 0);
            end
            else
            begin
              frmRun := ModflowTypes.GetRunModflowType.Create(application);
              try
                begin
                  frmRun.CurrentModelHandle := aneHandle;
                  if frmRun.ShowModal = mrOK then
                  begin
                      frmRun.Cursor := crHourGlass;
                      TemplateStringList := TStringList.Create;
                      try
                        begin
                          MetFileName := frmRun.GetMetFileName;
                          Template := frmMODFLOW.ProcessTemplate(DLLName,
                            MetFileName, '', nil, TemplateStringList);
                          GetDllDirectory(DLLName, LastTemplatePath) ;
                          LastTemplatePath := LastTemplatePath + '\' + LastTemplate;
                          try
                            TemplateStringList.SaveToFile(LastTemplatePath);
                          Except
                            on E : EInOutError do
                            begin
                              MessageDlg('Error saving ' + LastTemplate
                                + ' because "' + SysErrorMessage(E.ErrorCode)
                                + '". ' + LastTemplate
                                + 'is used only for debugging so this is not a '
                                + 'fatal error.',
                                mtWarning, [mbOK], 0);
                            end;
                            On E : Exception do
                            begin
                                MessageDlg(E.Message, mtError, [mbOK], 0);
                            end;
                          end
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
            end;

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

procedure TfrmRun.SelectProgram;
begin
  case aProgram of
    progMODFLOW:
      begin
        if not (rbRun.Checked or rbCreate.Checked) then
        begin
          rbRun.Checked := True;
        end;
      end;
    progMODPATH:
      begin
        if not (rbMPATHRun.Checked or rbMPATHCreate.Checked) then
        begin
          rbMPATHRun.Checked := True;
        end;
      end;
    progZONEBDGT:
      begin
        if not (rbRunZonebudget.Checked or rbCreateZonebudget.Checked) then
        begin
          rbRunZonebudget.Checked := True;
        end;
      end;
  end;
end;

function TfrmRun.GetProgramPath : string;
begin
  if rbRun.Checked or rbCreate.Checked then
  begin
    if cbUseSolute.Checked then
    begin
      result := adeMOC3DPath.Text;
    end
    else
    begin
      result := adeMODFLOWPath.Text;
    end;
  end
  else if rbMPATHRun.Checked or rbMPATHCreate.Checked then
  begin
    result := adeMODPATHPath.Text;
  end
  else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
  begin
    result := adeZonebudgetPath.Text;
  end
  else
  begin
    result := adeMODFLOWPath.Text;
  end;
end;

procedure TfrmRun.FormCreate(Sender: TObject);
begin
  // triggering event frmRun.OnCreate
  PanelColor := clBtnFace;
  pcRun.ActivePage := tabModelChoice;

  cbUseSolute.Enabled :=  frmMODFLOW.cbMOC3D.Checked      ;
  cbUseSolute.Checked :=  frmMODFLOW.cbUseSolute.Checked      ;
  if not cbUseSolute.Enabled then
  begin
    cbUseSolute.Checked := False;
  end;

  adeFileName.Text := frmMODFLOW.adeFileName.Text;

  rbRun.Checked := frmMODFLOW.rbRun.Checked;
  rbCreate.Checked := frmMODFLOW.rbCreate.Checked ;
  rbMPATHRun.Checked := frmMODFLOW.rbMPATHRun.Checked;
  rbMPATHCreate.Checked := frmMODFLOW.rbMPATHCreate.Checked ;
  rbRunZonebudget.Checked := frmMODFLOW.rbRunZonebudget.Checked;
  rbCreateZonebudget.Checked := frmMODFLOW.rbCreateZonebudget.Checked ;

  cbCalibrate.Checked :=  frmMODFLOW.cbCalibrate.Checked ;
  cbShowWarnings.Checked :=  frmMODFLOW.cbShowWarnings.Checked ;

  cbBAS.Checked := frmMODFLOW.cbExpBAS.Checked;
  cbOC.Checked := frmMODFLOW.cbExpOC.Checked;
  cbBCF.Checked := frmMODFLOW.cbExpBCF.Checked;
  cbRCH.Checked := frmMODFLOW.cbExpRCH.Checked;
  cbRIV.Checked := frmMODFLOW.cbExpRIV.Checked;
  cbWEL.Checked := frmMODFLOW.cbExpWEL.Checked;
  cbDRN.Checked := frmMODFLOW.cfExpDRN.Checked;
  cbGHB.Checked := frmMODFLOW.cbExpGHB.Checked;
  cbEVT.Checked := frmMODFLOW.cbExpEVT.Checked;
  cbExpHFB.Checked := frmMODFLOW.cbExpHFB.Checked;
  cbExpFHB.Checked := frmMODFLOW.cbExpFHB.Checked;
  cbMatrix.Checked := frmMODFLOW.cbExpMatrix.Checked;
  cbCONC.Checked := frmMODFLOW.cbExpCONC.Checked;
  cbOBS.Checked := frmMODFLOW.cbExpOBS.Checked;
  cbSTR.Checked := frmMODFLOW.cbExpSTR.Checked;
  cbProgressBar.Checked := frmMODFLOW.cbProgressBar.Checked;

  cbRCH.enabled := frmMODFLOW.cbRCH.Checked and frmMODFLOW.cbRCHRetain.Checked;
  cbRIV.enabled := frmMODFLOW.cbRIV.Checked and frmMODFLOW.cbRIVRetain.Checked;
  cbWEL.enabled := frmMODFLOW.cbWEL.Checked and frmMODFLOW.cbWELRetain.Checked;
  cbDRN.enabled := frmMODFLOW.cbDRN.Checked and frmMODFLOW.cbDRNRetain.Checked;
  cbGHB.enabled := frmMODFLOW.cbGHB.Checked and frmMODFLOW.cbGHBRetain.Checked;
  cbEVT.enabled := frmMODFLOW.cbEVT.Checked and frmMODFLOW.cbEVTRetain.Checked;
  cbExpHFB.enabled := frmMODFLOW.cbHFB.Checked and frmMODFLOW.cbHFBRetain.Checked;
  cbExpFHB.enabled := frmMODFLOW.cbFHB.Checked and frmMODFLOW.cbFHBRetain.Checked;
  cbCONC.enabled := frmMODFLOW.cbMOC3D.Checked;
  cbOBS.enabled := frmMODFLOW.cbMOC3D.Checked;
  cbSTR.enabled := frmMODFLOW.cbSTR.Checked and frmMODFLOW.cbSTRRetain.Checked;

  adeMODFLOWPath.Text := frmMODFLOW.adeMODFLOWPath.Text;
  adeMOC3DPath.Text := frmMODFLOW.adeMOC3DPath.Text;
  adeZonebudgetPath.Text := frmMODFLOW.adeZonebudgetPath.Text;
  adeMODPATHPath.Text := frmMODFLOW.adeMODPATHPath.Text;

  ModelButtonClick(Sender);

  SelectProgram;

  rbMPATHRun.Enabled := frmMODFLOW.cbMODPATH.Checked;
  if not rbMPATHRun.Enabled then
  begin
    rbMPATHRun.Checked := False;
  end;
  rbMPATHCreate.Enabled := frmMODFLOW.cbMODPATH.Checked;
  if not rbMPATHCreate.Enabled then
  begin
    rbMPATHCreate.Checked := False;
  end;

  rbRunZonebudget.Enabled := frmMODFLOW.cbZonebudget.Checked;
  if not rbRunZonebudget.Enabled then
  begin
    rbRunZonebudget.Checked := False;
  end;
  rbCreateZonebudget.Enabled := frmMODFLOW.cbZonebudget.Checked;
  if not rbCreateZonebudget.Enabled then
  begin
    rbCreateZonebudget.Checked := False;
  end;

end;

procedure TfrmRun.btOKClick(Sender: TObject);
begin
  // triggering event: btOK.OnClick
{  if cbUseSolute.Enabled and not cbUseSolute.Checked and
   (rbRun.Checked or rbCreate.Checked) and
   (cbCONC.Checked or cbOBS.Checked) then
  begin
    if MessageDlg('MODFLOW will not use the Solute '
      + 'Transport or MOC3D Observation Wells. Do you still want to '
      + 'Create them?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    begin
      cbCONC.Checked := False;
      cbOBS.Checked := False;
    end;
  end;  }
  frmMODFLOW.adeFileName.Text := adeFileName.Text;

  frmMODFLOW.cbUseSolute.Checked :=  cbUseSolute.Checked      ;

  frmMODFLOW.rbRun.Checked       :=  rbRun.Checked      ;
  frmMODFLOW.rbCreate.Checked    :=  rbCreate.Checked   ;
  frmMODFLOW.rbRunZonebudget.Checked := rbRunZonebudget.Checked;
  frmMODFLOW.rbCreateZonebudget.Checked := rbCreateZonebudget.Checked ;
  frmMODFLOW.rbMPATHRun.Checked := rbMPATHRun.Checked;
  frmMODFLOW.rbMPATHCreate.Checked := rbMPATHCreate.Checked ;

  frmMODFLOW.cbCalibrate.Checked := cbCalibrate.Checked ;
  frmMODFLOW.cbShowWarnings.Checked := cbShowWarnings.Checked ;

  frmMODFLOW.cbExpBAS.Checked    :=  cbBAS.Checked      ;
  frmMODFLOW.cbExpOC.Checked     :=  cbOC.Checked       ;
  frmMODFLOW.cbExpBCF.Checked    :=  cbBCF.Checked      ;
  frmMODFLOW.cbExpRCH.Checked    :=  cbRCH.Checked      ;
  frmMODFLOW.cbExpRIV.Checked    :=  cbRIV.Checked      ;
  frmMODFLOW.cbExpWEL.Checked    :=  cbWEL.Checked      ;
  frmMODFLOW.cfExpDRN.Checked    :=  cbDRN.Checked      ;
  frmMODFLOW.cbExpGHB.Checked    :=  cbGHB.Checked      ;
  frmMODFLOW.cbExpEVT.Checked    :=  cbEVT.Checked      ;
  frmMODFLOW.cbExpHFB.Checked := cbExpHFB.Checked;
  frmMODFLOW.cbExpFHB.Checked := cbExpFHB.Checked;
  frmMODFLOW.cbExpMatrix.Checked :=  cbMatrix.Checked   ;
  frmMODFLOW.cbExpCONC.Checked   :=  cbCONC.Checked     ;
  frmMODFLOW.cbExpOBS.Checked    :=  cbOBS.Checked      ;
  frmMODFLOW.cbExpSTR.Checked    :=  cbSTR.Checked;
  frmMODFLOW.cbProgressBar.Checked := cbProgressBar.Checked;

  frmMODFLOW.adeMODFLOWPath.Text := ExtractShortPathName(adeMODFLOWPath.Text);
  frmMODFLOW.adeMOC3DPath.Text := ExtractShortPathName(adeMOC3DPath.Text);
  frmMODFLOW.adeZonebudgetPath.Text := ExtractShortPathName(adeZonebudgetPath.Text);
  frmMODFLOW.adeMODPATHPath.Text := ExtractShortPathName(adeMODPATHPath.Text);

  if rbRun.Checked or rbCreate.Checked
  then
  begin
    if cbUseSolute.Checked then
    begin
      if not FileExists(adeMOC3DPath.Text) then
      begin
        Beep;
        if MessageDlg(adeMOC3DPath.Text + ' does not exist. '
          + 'Do you still wish to export the MOC3D input files?',
          mtWarning, [mbYes, mbNo], 0) = mrYes
          then ModalResult := mrOK else ModalResult := mrNone
      end;
    end
    else
    begin
      if not FileExists(adeMODFLOWPath.Text) then
      begin
        Beep;
        if MessageDlg(adeMODFLOWPath.Text + ' does not exist. '
          + 'Do you still wish to export the MODFLOW input files?',
          mtWarning, [mbYes, mbNo], 0) = mrYes
          then ModalResult := mrOK else ModalResult := mrNone
      end;
    end;
  end
  else if rbMPATHRun.Checked or rbMPATHCreate.Checked then
  begin
      if not FileExists(adeMODPATHPath.Text) then
      begin
        Beep;
        if MessageDlg(adeMODPATHPath.Text + ' does not exist. '
          + 'Do you still wish to export the MODPATH input files?',
          mtWarning, [mbYes, mbNo], 0) = mrYes
          then ModalResult := mrOK else ModalResult := mrNone
      end;
  end
  else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
  begin
      if not FileExists(adeZonebudgetPath.Text) then
      begin
        Beep;
        if MessageDlg(adeZonebudgetPath.Text + ' does not exist. '
          + 'Do you still wish to export the ZONEBDGT input files?',
          mtWarning, [mbYes, mbNo], 0) = mrYes
          then ModalResult := mrOK else ModalResult := mrNone
      end;
  end;
  if Lowercase(adeFileName.Text) = 'dummy' then
  begin
    Beep;
    MessageDlg(adeFileName.Text + ' is an invalid name for the root. '
      + 'Please correct this problem and try again.', mtWarning, [mbOK], 0);
    ModalResult := mrNone;
  end;
  if (Pos('\n',GetProgramPath)>0) or (Pos('\t',GetProgramPath)>0) then
  begin
    Beep;
    if MessageDlg('"' + GetProgramPath + '" contains "\n" or "\t"'
      + 'which may not be exported correctly by Argus ONE. '
      + 'Do you still wish to export the input files?',
      mtWarning, [mbYes, mbNo], 0) = mrYes
      then ModalResult := mrOK else ModalResult := mrNone
  end;
end;

procedure TfrmRun.BrowseClick(Sender: TObject);
var
  APath : TArgusDataEntry;
begin
  // triggering event: btnMODFLOWBrowse.OnClick
  // triggering event: btMOC3DBrowse.OnClick
  // triggering event: btnZonebudget.OnClick
  // triggering event: btnMODPATH.OnClick
  APath := adeMODFLOWPath;
  if Sender = btMOC3DBrowse then
  begin
    APath := adeMOC3DPath;
  end
  else if Sender = btnMODPATH then
  begin
    APath := adeMODPATHPath;
  end
  else if Sender = btnZonebudget then
  begin
    APath := adeZonebudgetPath;
  end;

  opendialGetPath.FileName := APath.Text;
  if opendialGetPath.Execute then
  begin
    APath.Text := opendialGetPath.FileName;
  end;
end;

procedure TfrmRun.btnEditClick(Sender: TObject);
begin
  // triggering event: btnEdit.OnClick
  EditForm;
  FormCreate(Sender);
//  frmMODFLOW.ShowModal;
  ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
end;

procedure TfrmRun.ModelButtonClick(Sender: TObject);
begin
  // triggering event rbRun.OnClick
  // triggering event cbUseSolute.OnClick
  // triggering event rbCreate.OnClick
  // triggering event rbMPATHRun.OnClick
  // triggering event rbMPATHCreate.OnClick
  // triggering event rbRunZonebudget.OnClick
  // triggering event rbCreateZonebudget.OnClick

  gboxMFOutputPackages.Visible := (rbRun.Checked or rbCreate.Checked);
  cbUseSolute.Enabled := (rbRun.Checked or rbCreate.Checked)
    and frmModflow.cbMOC3D.Checked;
  adeModelPathChange(Sender);
end;

function TfrmRun.GetMetFileName: string;
begin
  result := 'modflow.met';
  if rbMPATHRun.Checked or rbMPATHCreate.Checked then
    begin
      result := 'modpath.met';
    end
  else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
    begin
      result := 'ZoneBud.met';
    end
  else
  begin
    result := 'modflow.met';
  end;

end;

procedure TfrmRun.ModelPathChange(Sender: TObject);
Var
  TheFileExists : boolean;
begin
  TheFileExists := True;
  adeMOC3DPath.EnabledColor := clWindow;
  adeMODFLOWPath.EnabledColor := clWindow;
  adeMODPATHPath.EnabledColor := clWindow;
  adeZonebudgetPath.EnabledColor := clWindow;
  if rbRun.Checked or rbCreate.Checked
  then
  begin
    if cbUseSolute.Checked then
    begin
      if FileExists(adeMOC3DPath.Text) then
      begin
        adeMOC3DPath.EnabledColor := clWindow;
        TheFileExists := True;
      end
      else
      begin
        adeMOC3DPath.EnabledColor := clRed;
        TheFileExists := False;
      end;
    end
    else
    begin
      if FileExists(adeMODFLOWPath.Text) then
      begin
        adeMODFLOWPath.EnabledColor := clWindow;
        TheFileExists := True;
      end
      else
      begin
        adeMODFLOWPath.EnabledColor := clRed;
        TheFileExists := False;
      end;
    end;
  end
  else if rbMPATHRun.Checked or rbMPATHCreate.Checked then
  begin
      if FileExists(adeMODPATHPath.Text) then
      begin
        adeMODPATHPath.EnabledColor := clWindow;
        TheFileExists := True;
      end
      else
      begin
        adeMODPATHPath.EnabledColor := clRed;
        TheFileExists := False;
      end;
  end
  else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
  begin
      if FileExists(adeZonebudgetPath.Text) then
      begin
        adeZonebudgetPath.EnabledColor := clWindow;
        TheFileExists := True;
      end
      else
      begin
//        btOK.Enabled := False;
        adeZonebudgetPath.EnabledColor := clRed;
        TheFileExists := False;
      end;
  end;
  if TheFileExists then
  begin
    PanelColor := clBtnFace;
    sbModelStatus.SimpleText := '';
  end
  else
  begin
    PanelColor := clRed;
    sbModelStatus.SimpleText := 'Warning: Executable file does not exist.';
  end;
  sbModelStatus.Repaint;
end;

procedure TfrmRun.adeModelPathChange(Sender: TObject);
begin
  // triggering event: adeMODFLOWPath.OnChange
  // triggering event: adeMOC3DPath.OnChange
  // triggering event: adeMODPATHPath.OnChange
  // triggering event: adeZonebudgetPath.OnChange
  ModelPathChange(Sender);
end;

function TfrmRun.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  // triggering events: frmRun.OnHelp;

  // This assigns the help file every time Help is called from frmMODFLOW.
  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmMODFLOW.
  AssignHelpFile('MODFLOW.hlp');
  result := True;

end;

procedure TfrmRun.AssignHelpFile(FileName : string);
var
    DllDirectory : String;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + FileName; // MODFLOW.hlp';
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

procedure RunModflowPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
begin
  Exporting := True;
  try
    aProgram := progMODFLOW;
    RunPIE(aneHandle, '');
    returnTemplate^ := Template;
  finally
    Exporting := False;
  end;
end;

procedure RunModpathPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
var
  WarningString : string;
begin
  Exporting := True;
  try
    aProgram := progMODPATH;
    WarningString := 'You can not run MODPATH until you first select '
                  + '"Use MODPATH" on the "MODPATH" tab of the Edit Project Info '
                  + 'dialog box.';
    RunPIE(aneHandle, WarningString);
    returnTemplate^ := Template;;
  finally
    Exporting := False;
  end;

end;

procedure RunZondbdgtPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
var
  WarningString : string;
begin
  Exporting := True;
  try
    WarningString := 'You can not run ZONEBDGT until you first select '
                  + '"Use ZONEBDGT" on the "ZONEBDGT" tab of the Edit Project Info '
                  + 'dialog box.';
    aProgram := progZONEBDGT;
    RunPIE(aneHandle, WarningString );
    returnTemplate^ := Template;
  finally
    Exporting := False;
  end;
end;

procedure TfrmRun.sbModelStatusDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  sbModelStatus.Canvas.Brush.Color := PanelColor;
  sbModelStatus.Canvas.FillRect(Rect);
  sbModelStatus.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sbModelStatus.SimpleText);
end;

procedure TfrmRun.adeFileNameExit(Sender: TObject);
var
  Index : integer;
begin

  // convert the root name of the simulation file to lowercase.
  // This makes it easier to run the MODFLOW simulation on UNIX.
  // Also elimnate blank spaces.
  adeFileName.Text := Trim(Lowercase(adeFileName.Text));
  for Index := 1 to Length(adeFileName.Text) do
  begin
    if adeFileName.Text = ' ' then
    begin
      Beep;
      MessageDlg('You can not have a space in the root name for your model',
        MtError, [mbOK], 0);
      Break;
    end;

  end;

end;

procedure TfrmRun.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmRun.cbProgressBarClick(Sender: TObject);
begin
  cbShowWarnings.Enabled := cbProgressBar.Checked;
  if not cbShowWarnings.Enabled then
  begin
    cbShowWarnings.Checked := False;
  end;
end;

end.
