unit RunUnit;

interface

{RunUnit defines the form displayed when a user wishes to run a model.
 It also defines the PIE functions used to display the form.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, Buttons, StdCtrls, ArgusDataEntry, AnePIE, ComCtrls,
  ProgramToRunUnit, ExtCtrls, ASLink {, ActivApp, appexec};

type
  TfrmRun = class(TArgusForm)
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
    tapPath: TTabSheet;
    lblMODFLOWPath: TLabel;
    lblMOC3DPath: TLabel;
    lblZoneBudPath: TLabel;
    lblMODPATH: TLabel;
    adeMODFLOWPath: TArgusDataEntry;
    adeMOC3DPath: TArgusDataEntry;
    btnMODFLOWBrowse: TButton;
    btnMOC3DBrowse: TButton;
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
    savedlgExportFiles: TSaveDialog;
    lblModflow2000Path: TLabel;
    adeModflow2000Path: TArgusDataEntry;
    btnModflow2000: TButton;
    adeResanPath: TArgusDataEntry;
    lblResanPath: TLabel;
    btnResan: TButton;
    cbResan: TCheckBox;
    lblYcintPath: TLabel;
    adeYcintPath: TArgusDataEntry;
    btnYcintPath: TButton;
    lblBealePath: TLabel;
    adeBealePath: TArgusDataEntry;
    btnBealePath: TButton;
    rbYcint: TRadioButton;
    rbBeale: TRadioButton;
    lblMODPATH41: TLabel;
    adeMODPATH41Path: TArgusDataEntry;
    btnMODPATH41: TButton;
    lblMF2K_GWTPath: TLabel;
    adeMF2K_GWTPath: TArgusDataEntry;
    btnMF2K_GWTBrowse: TButton;
    rgModflowVersion: TRadioGroup;
    comboDiscretization: TComboBox;
    lblDiscretization: TLabel;
    lblWarning2: TLabel;
    rbRunMT3D: TRadioButton;
    rbCreateMT3D: TRadioButton;
    lblMT3DPath: TLabel;
    adeMT3DPath: TArgusDataEntry;
    btnMT3D: TButton;
    lblMT3DWarning2: TLabel;
    cbUseMT3D: TCheckBox;
    ASLinkMF2K: TASLink;
    ASLinkmf96: TASLink;
    ASLinkMOC3D: TASLink;
    ASLinkMf2kGWT: TASLink;
    ASLinkMpath3: TASLink;
    ASLinkMpath4: TASLink;
    ASLinkZonebudget: TASLink;
    ASLinkResan: TASLink;
    ASLinkYcint: TASLink;
    ASLinkBeale: TASLink;
    ASLinkMT3D: TASLink;
    gboxMT3DPackages: TGroupBox;
    lblMT3DBasic: TLabel;
    lblMT3DAdvec: TLabel;
    lblMT3DDisp: TLabel;
    lblSourceSink: TLabel;
    lblMT3DReact: TLabel;
    lblExportMT3DGCG: TLabel;
    cbExportMT3DBTN: TCheckBox;
    cbExportMT3DADV: TCheckBox;
    cbExportMT3DDSP: TCheckBox;
    cbExportMT3DSSM: TCheckBox;
    cbExportMT3DRCT: TCheckBox;
    cbExportMT3DGCG: TCheckBox;
    gbMODPATH: TGroupBox;
    lblMPA: TLabel;
    lblPRT: TLabel;
    cbMPA: TCheckBox;
    cbPRT: TCheckBox;
    rbRunSeawat: TRadioButton;
    rbCreateSeaWat: TRadioButton;
    ASLinkSeaWat: TASLink;
    lblSeaWatPath: TLabel;
    adeSEAWAT: TArgusDataEntry;
    btnSEAWAT: TButton;
    pcCreateInputFor: TPageControl;
    tabGroup1: TTabSheet;
    tabGroup2: TTabSheet;
    tabGroup3: TTabSheet;
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
    lblStream: TLabel;
    lblDis: TLabel;
    lblLPF: TLabel;
    lblMult: TLabel;
    lblZONE: TLabel;
    lblExpSfr: TLabel;
    lblExpETS: TLabel;
    lblExpDRT: TLabel;
    lblExpHYD: TLabel;
    lblExpCHD: TLabel;
    lblExpHUF: TLabel;
    lblExpModelViewer: TLabel;
    cbBAS: TCheckBox;
    cbOC: TCheckBox;
    cbBCF: TCheckBox;
    cbRCH: TCheckBox;
    cbRIV: TCheckBox;
    cbWEL: TCheckBox;
    cbDRN: TCheckBox;
    cbGHB: TCheckBox;
    cbEVT: TCheckBox;
    cbSTR: TCheckBox;
    cbDIS: TCheckBox;
    cbLPF: TCheckBox;
    cbMULT: TCheckBox;
    cbZONE: TCheckBox;
    cbSfr: TCheckBox;
    cbExpETS: TCheckBox;
    cbExpDRT: TCheckBox;
    cbExpHYD: TCheckBox;
    cbExpCHD: TCheckBox;
    cbExpHUF: TCheckBox;
    cbExpModelViewer: TCheckBox;
    gboxMFOutputPackages2: TGroupBox;
    lblFHBExport: TLabel;
    lblExpSub: TLabel;
    lblExpGAG: TLabel;
    cbExpFHB: TCheckBox;
    cbExpSub: TCheckBox;
    cbExpGAG: TCheckBox;
    lblExpIBS: TLabel;
    lblExpLAK: TLabel;
    lblExpRES: TLabel;
    lblExpTLK: TLabel;
    lblHFT: TLabel;
    lblExpMNW: TLabel;
    lblExpDAFLOW: TLabel;
    lblExpVdf: TLabel;
    lblMatrix: TLabel;
    lblRVOB: TLabel;
    lblHOB: TLabel;
    lblDROB: TLabel;
    lblDTOB: TLabel;
    lblGBOB: TLabel;
    lblSTOB: TLabel;
    lblCHOB: TLabel;
    lblADOB: TLabel;
    cbADOB: TCheckBox;
    cbCHOB: TCheckBox;
    cbSTOB: TCheckBox;
    cbGBOB: TCheckBox;
    cbDTOB: TCheckBox;
    cbDROB: TCheckBox;
    cbHOB: TCheckBox;
    cbRVOB: TCheckBox;
    cbMatrix: TCheckBox;
    cbExpVdf: TCheckBox;
    cbExpDAFLOW: TCheckBox;
    cbExpMNW: TCheckBox;
    cbExpHFB: TCheckBox;
    cbExpTLK: TCheckBox;
    cbExpRES: TCheckBox;
    cbExpLAK: TCheckBox;
    cbExpIBS: TCheckBox;
    gboxMFOutputPackages3: TGroupBox;
    lblPESExport: TLabel;
    lblMOC3DSolute: TLabel;
    lblMOC3DObsWells: TLabel;
    lblExpIPDA: TLabel;
    lblExpBFLX: TLabel;
    lblExpCBDY: TLabel;
    lblFTI: TLabel;
    cbPESExport: TCheckBox;
    cbCONC: TCheckBox;
    cbOBS: TCheckBox;
    cbExpIPDA: TCheckBox;
    cbExpBFLX: TCheckBox;
    cbExpCBDY: TCheckBox;
    cbFTI: TCheckBox;
    lblGWM_DECVAR: TLabel;
    cbGWM_DECVAR: TCheckBox;
    lblGWM_OBJFNC: TLabel;
    cbGWM_OBJFNC: TCheckBox;
    lblGWM_VARCON: TLabel;
    cbGWM_VARCON: TCheckBox;
    lblGWM_SUMCON: TLabel;
    cbGWM_SUMCON: TCheckBox;
    lblGWM_HEDCON: TLabel;
    cbGWM_HEDCON: TCheckBox;
    cbGWM_STRMCON: TCheckBox;
    lblGWM_STRMCON: TLabel;
    lblGWM_SOLN: TLabel;
    cbGWM_SOLN: TCheckBox;
    lblGWM_Path: TLabel;
    adeGWM: TArgusDataEntry;
    ASLinkGWM: TASLink;
    btnGWM: TButton;
    rbRunGWM: TRadioButton;
    rbCreateGWM: TRadioButton;
    cbExpPTOB: TCheckBox;
    lblExpPTOB: TLabel;
    lblModflow2005Path: TLabel;
    adeModflow2005: TArgusDataEntry;
    ASLinkMF2005: TASLink;
    btnModflow2005: TButton;
    Label1: TLabel;
    cbExpUZF: TCheckBox;
    lblSEN: TLabel;
    cbSEN: TCheckBox;
    lblExpSwt: TLabel;
    cbExpSwt: TCheckBox;
    cbExpVsc: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    cbExpMnw2: TCheckBox;
    cbGWM_STAVAR: TCheckBox;
    lblGwmSTAVAR: TLabel;
    cbExpCCBD: TCheckBox;
    lblCCBD: TLabel;
    cbExpVBAL: TCheckBox;
    lbl1VBAL: TLabel;
    procedure FormCreate(Sender: TObject); override;
    procedure btOKClick(Sender: TObject); virtual;
    procedure BrowseClick(Sender: TObject); virtual;
    procedure btnEditClick(Sender: TObject); virtual;
    procedure ModelButtonClick(Sender: TObject); virtual;
    procedure adeModelPathChange(Sender: TObject); virtual;
    procedure sbModelStatusDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect); virtual;
    procedure adeFileNameExit(Sender: TObject); virtual;
    procedure cbProgressBarClick(Sender: TObject);
    procedure cbModflow2000Click(Sender: TObject);
    procedure pcRunChange(Sender: TObject);
    procedure adeFileNameEnter(Sender: TObject);
  private
    OldRoot: string;
    procedure ResetUnitNumbers;
    procedure EnableControls;
    procedure SetMaxFileNameLength;
    { Private declarations }
  public
    ExportTemplate: TStringList;
    PanelColor: TColor;
    function GetMetFileName: string; virtual;
    procedure ModelPathChange(Sender: TObject); virtual;
    procedure SelectProgram; virtual;
    function GetProgramPath: string; virtual;
    function ExportModflow2000: boolean;
    { Public declarations }
  end;

var
  Template: ANE_STR;
  aProgram: TProgramToRun;
  Exporting: boolean;
  UseSolute: boolean = False;

procedure RunModflowPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;

procedure RunModpathPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;

procedure RunZondbdgtPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;

procedure RunMT3DPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;

procedure RunSeawatPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;

procedure RunGWM_PIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;

procedure RunPIE(aneHandle: ANE_PTR; WarningMessage: string); cdecl;

implementation

{$R *.DFM}

uses FileCtrl, ANE_LayerUnit, ANECB, ModflowUnit,
  UtilityFunctions, ProjectFunctions, Variables, OptionsUnit,
  WriteModflowFilesUnit, ConserveResourcesUnit, WriteNameFileUnit;


// from http://www.delphi3000.com/articles/article_1628.asp?SK=
function GetLongPathName(const ShortName : string) : string;
var
  pcBuffer: PChar;
  iHandle, iLen : Integer;
  GetLongPathName: function (ShortPathName: PChar; LongPathName: PChar;
                             cchBuffer: Integer): Integer stdcall;
begin
  Result := ShortName;

  iHandle := GetModuleHandle('kernel32.dll');
  if (iHandle <> 0) then begin
    @GetLongPathName := GetProcAddress(iHandle, 'GetLongPathNameA');

    if Assigned(GetLongPathName) then begin
      pcBuffer := StrAlloc(MAX_PATH + 1);
      iLen := GetLongPathName(PChar(ShortName), pcBuffer, MAX_PATH);

      // if result = 0 : conversion failed
      // if result > MAX_PATH ==> conversion failed, buffer not large enough
      if (iLen > 0) and (iLen <= MAX_PATH) then begin
        Result := StrPas(pcBuffer);
      end;  // if (iLen <= MAX_PATH) then
      StrDispose(pcBuffer);
    end;  // if Assigned(GetLongPathName) then
    FreeLibrary(iHandle);
  end;  // if (iHandle <> 0) then
end;

{function LongFileName(AltName: string): string;
var
  temp: TWIN32FindData;
  searchHandle: THandle;
  OldDir, NewDir: string;
begin
  OldDir:= GetCurrentDir;
  try
    NewDir := ExtractFileDir(AltName);
    SetCurrentDir(NewDir);
    searchHandle:=FindFirstFile(PChar(AltName),temp) ;
    if searchHandle <> ERROR_INVALID_HANDLE then
      result := ExpandFileName(String(temp.cFileName))
    else
      result := '';
    Windows.FindClose(searchHandle) ;
  finally
    SetCurrentDir(OldDir);
  end;
end; }

procedure RunPIE(aneHandle: ANE_PTR; WarningMessage: string); cdecl;
const
  LastTemplate = 'LastTemplate.met';
var
  MetFileName: string;
  LastTemplatePath: string;
  TemplateStringList: TStringList;
  Path : string;
  VersionInString: string;
{$IFDEF Argus5} {This only works with Argus 5}
  ProjectOptions: TProjectOptions;
{$ENDIF}
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from openning because that would corrupt the data
  // for the other model.
  Template := nil;
  if EditWindowOpen then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    //    ShowMessage('Be sure to turn OFF "Special|Manual Calculation" before '
    //      + 'attempting to export data.');
        // make sure the project options used in exporting data are set correctly.
{$IFDEF Argus5} {This only works with Argus 5}
    ProjectOptions := TProjectOptions.Create;
    try
      ProjectOptions.ExportWrap[aneHandle] := 0;
      ProjectOptions.ExportSeparator[aneHandle] := ' ';
    finally
      ProjectOptions.Free;
    end;
{$ENDIF}
    try // try 1
      begin
        try
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
              Path := IniFile(frmMODFLOW.Handle);
              if FileExists(Path) then
              begin
                frmModflow.ReadValFile(VersionInString, Path);
              end;
              Application.CreateForm(ModflowTypes.GetRunModflowType, frmRun);
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
                        LastTemplatePath := DllAppDirectory(frmMODFLOW.Handle, DLLName);
                        if not DirectoryExists(LastTemplatePath) then
                        begin
                          CreateDirectoryAndParents(LastTemplatePath);
                        end;
//                        GetDllDirectory(DLLName, LastTemplatePath);
                        LastTemplatePath := LastTemplatePath + '\' +
                          LastTemplate;
                        try
                          TemplateStringList.SaveToFile(LastTemplatePath);
                        except
                          on E: EInOutError do
                          begin
                            // do nothing
                          end;
                          on E: Exception do
                          begin
                            MessageDlg(E.Message, MtError, [mbOK], 0);
                          end;
                        end
                      end;
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
                  frmRun.Free;
                  frmRun := nil;
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
    progMT3D:
      begin
        if not (rbRunMT3D.Checked or rbCreateMT3D.Checked) then
        begin
          rbRunMT3D.Checked := True;
        end;
      end;
    progSEAWAT:
      begin
        if not (rbRunSeawat.Checked or rbCreateSeaWat.Checked) then
        begin
          rbRunSeawat.Checked := True;
        end;
      end;
    progGWM:
      begin
        if not (rbRunGWM.Checked or rbCreateGWM.Checked) then
        begin
          rbRunGWM.Checked := True;
        end;
      end;
  end;
end;

function TfrmRun.GetProgramPath: string;
begin
  if rbRun.Checked or rbCreate.Checked then
  begin
    if rgModflowVersion.ItemIndex = 2 then
    begin
        result := adeModflow2005.Text;
    end
    else if rgModflowVersion.ItemIndex = 1 then
    begin
      if cbUseSolute.Checked then
      begin
        result := adeMF2K_GWTPath.Text;
      end
      else
      begin
        result := adeModflow2000Path.Text;
      end;
    end
    else if cbUseSolute.Checked then
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
    if rgModflowVersion.ItemIndex in [1,2] then
    begin
      result := adeMODPATH41Path.Text;
    end
    else
    begin
      result := adeMODPATHPath.Text;
    end;
  end
  else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
  begin
    result := adeZonebudgetPath.Text;
  end
  else if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    result := adeMT3DPath.Text;
  end
  else if rbRunSeawat.Checked or rbCreateSeaWat.Checked then
  begin
    result := adeSEAWAT.Text;
  end
  else if rbRunGWM.Checked or rbCreateGWM.Checked then
  begin
    result := adeGWM.Text;
  end
  else
  begin
    result := adeMODFLOWPath.Text;
  end;
end;

procedure TfrmRun.EnableControls;
Var
  Index: integer;
  CheckBox: TCheckBox;
  GroupBox: TGroupBox;
begin
  cbBAS.Enabled := True;
  cbDIS.Enabled := True;
  cbOC.Enabled := True;
  cbMatrix.Enabled := True;
  cbUseSolute.Enabled := frmMODFLOW.cbMOC3D.Checked;
  cbUseMT3D.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.rbMODFLOW2000.Checked;
  cbFTI.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.rbMODFLOW2000.Checked;
  rbRunSeawat.Enabled := frmMODFLOW.cbSeaWat.Checked;
  rbCreateSeaWat.Enabled := frmMODFLOW.cbSeaWat.Checked;
  rbRunGWM.Enabled := frmMODFLOW.cb_GWM.Checked;
  rbCreateGWM.Enabled := frmMODFLOW.cb_GWM.Checked;

  comboDiscretization.Enabled := rgModflowVersion.ItemIndex = 0;
  cbMULT.Enabled := rgModflowVersion.ItemIndex in [1,2];
  cbZONE.Enabled := rgModflowVersion.ItemIndex in [1,2];

  cbRCH.enabled := frmMODFLOW.cbRCH.Checked and frmMODFLOW.cbRCHRetain.Checked;
  cbRIV.enabled := frmMODFLOW.cbRIV.Checked and frmMODFLOW.cbRIVRetain.Checked;
  cbWEL.enabled := frmMODFLOW.cbWEL.Checked and frmMODFLOW.cbWELRetain.Checked;
  cbDRN.enabled := frmMODFLOW.cbDRN.Checked and frmMODFLOW.cbDRNRetain.Checked;
  cbExpDRT.enabled := frmMODFLOW.cbDRT.Checked and
    frmMODFLOW.cbDRTRetain.Checked;
  cbGHB.enabled := frmMODFLOW.cbGHB.Checked and frmMODFLOW.cbGHBRetain.Checked;
  cbEVT.enabled := frmMODFLOW.cbEVT.Checked and frmMODFLOW.cbEVTRetain.Checked;
  cbExpETS.enabled := frmMODFLOW.cbETS.Checked and
    frmMODFLOW.cbETSRetain.Checked;
  cbExpHFB.enabled := frmMODFLOW.cbHFB.Checked and
    frmMODFLOW.cbHFBRetain.Checked;
  cbExpFHB.enabled := frmMODFLOW.cbFHB.Checked and
    frmMODFLOW.cbFHBRetain.Checked;
  cbCONC.enabled := frmMODFLOW.cbMOC3D.Checked;
  cbOBS.enabled := frmMODFLOW.cbMOC3D.Checked;
  cbSTR.enabled := frmMODFLOW.cbSTR.Checked and frmMODFLOW.cbSTRRetain.Checked;
  cbSFR.enabled := frmMODFLOW.cbSFR.Checked and frmMODFLOW.cbSFRRetain.Checked;
  cbExpLAK.enabled := frmMODFLOW.cbLAK.Checked and
    frmMODFLOW.cbLAKRetain.Checked;
  cbExpHYD.Enabled := frmMODFLOW.cbHYD.Checked and
    frmMODFLOW.cbHYDRetain.Checked;
  cbExpMNW.enabled := frmMODFLOW.cbMNW.Checked and frmMODFLOW.cbMNW_Use.Checked;
  cbExpMnw2.enabled := frmMODFLOW.cbMnw2.Checked and frmMODFLOW.cbUseMnw2.Checked;
  cbExpDAFLOW.enabled := frmMODFLOW.cbDAFLOW.Checked and frmMODFLOW.cbUseDAFLOW.Checked;

  cbExpIBS.enabled := frmMODFLOW.cbIBS.Checked and frmMODFLOW.cbUseIBS.Checked;
  cbExpSUB.enabled := frmMODFLOW.cbSUB.Checked and frmMODFLOW.cbUseSUB.Checked;
  cbExpSWT.enabled := frmMODFLOW.cbSWT.Checked and frmMODFLOW.cbUseSWT.Checked;
  cbExpRES.enabled := frmMODFLOW.cbRES.Checked and
    frmMODFLOW.cbRESRetain.Checked;
  cbExpTLK.enabled := frmMODFLOW.cbTLK.Checked and
    frmMODFLOW.cbTLKRetain.Checked;

  cbExpHUF.Enabled := (frmModflow.rgFlowPackage.ItemIndex = 2)
    and (rgModflowVersion.ItemIndex in [1,2]);
  cbLPF.Enabled := (frmModflow.rgFlowPackage.ItemIndex = 1)
    and (rgModflowVersion.ItemIndex in [1,2]);
  cbBCF.Enabled := not cbLPF.Enabled and not cbExpHUF.Enabled;
  cbExpCHD.Enabled := frmMODFLOW.cbCHD.Checked and
    frmMODFLOW.cbCHDRetain.Checked;
  cbExpVdf.Enabled := frmModflow.cbSeaWat.Checked
    and frmModflow.cbSW_VDF.Checked and
    (rbRunSeawat.Checked or rbCreateSeaWat.Checked);

  cbHOB.Enabled := (frmMODFLOW.cbHeadObservations.Checked
    or frmMODFLOW.cbWeightedHeadObservations.Checked)
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbGBOB.Enabled := cbGHB.enabled and frmMODFLOW.cbGHBObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbDROB.Enabled := cbDRN.enabled and frmMODFLOW.cbDRNObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbDTOB.Enabled := cbExpDRT.enabled and frmMODFLOW.cbDRTObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbRVOB.Enabled := cbRIV.enabled and frmMODFLOW.cbRIVObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);

  cbSTOB.Enabled := cbSTR.enabled and frmMODFLOW.cbStreamObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);

  cbCHOB.Enabled := frmModflow.cbObservations.Checked
    and frmModflow.cbHeadFluxObservations.Checked
    and (rgModflowVersion.ItemIndex in [1,2]);
  cbADOB.Enabled := frmModflow.cbObservations.Checked
    and frmModflow.cbAdvObs.Checked and (rgModflowVersion.ItemIndex = 1);

  cbSEN.Enabled := frmMODFLOW.cbSensitivity.Checked
    and (rgModflowVersion.ItemIndex = 1);
  cbPESExport.Enabled := frmMODFLOW.cbParamEst.Checked
    and (rgModflowVersion.ItemIndex = 1);
  cbExpBFLX.Enabled := frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbBFLX.Checked;
  cbExpCBDY.Enabled := frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbCBDY.Checked;
  cbExpIPDA.Enabled := frmMODFLOW.cbMOC3D.Checked
    and frmMODFLOW.WeightedParticlesUsed
    and (frmModflow.comboSpecifyParticles.ItemIndex >= 1);
  if cbExpIPDA.Enabled and (frmModflow.comboSpecifyParticles.ItemIndex = 2) then
  begin
    cbExpIPDA.Caption := 'IDPL';
  end;
  cbExpPTOB.Enabled := frmMODFLOW.cbMOC3D.Checked and
    frmMODFLOW.cbParticleObservations.Checked;
  cbExpCCBD.Enabled := frmMODFLOW.cbMOC3D.Checked and
    frmMODFLOW.cbCCBD.Checked;
  cbExpVBAL.Enabled := frmMODFLOW.cbMOC3D.Checked and
    frmMODFLOW.cbVBAL.Checked;

  cbGWM_DECVAR.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  cbGWM_OBJFNC.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  cbGWM_VARCON.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  cbGWM_SUMCON.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  cbGWM_HEDCON.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  cbGWM_STRMCON.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked)
    and ((frmMODFLOW.cbSTR.Checked and frmMODFLOW.cbSTRRetain.Checked)
    or (frmMODFLOW.cbSFR.Checked and frmMODFLOW.cbSFRRetain.Checked));
  cbGWM_SOLN.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  cbGWM_STAVAR.Enabled := frmMODFLOW.cb_GWM.Checked and
    (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);


  cbExpUZF.Enabled := frmMODFLOW.cbUZF.Checked and
    frmMODFLOW.cbUzfRetain.Checked;

  cbResan.Enabled := cbPESExport.Enabled;
  rbYcint.Enabled := frmMODFLOW.cbYcint.Checked and frmMODFLOW.cbYcint.Enabled;
  rbBeale.Enabled := frmMODFLOW.cbBeale.Checked and frmMODFLOW.cbBeale.Enabled;

  rbRunMT3D.enabled := frmMODFLOW.cbMT3D.Checked;
  rbCreateMT3D.enabled := frmMODFLOW.cbMT3D.Checked;
  adeMT3DPath.enabled := frmMODFLOW.cbMT3D.Checked;
  btnMT3D.enabled := frmMODFLOW.cbMT3D.Checked;

  cbExportMT3DBTN.Enabled := frmMODFLOW.cbMT3D.Checked;
  cbExportMT3DADV.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.cbADV.Checked;
  cbExportMT3DDSP.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.cbDSP.Checked;
  cbExportMT3DSSM.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.cbSSM.Checked;
  cbExportMT3DRCT.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.cbRCT.Checked;
  cbExportMT3DGCG.Enabled := frmMODFLOW.cbMT3D.Checked and
    frmMODFLOW.cbGCG.Checked;
//  cbExpPTOB.Enabled := frmMODFLOW.cbMT3D.Checked and
//    frmMODFLOW.cbGCG.Checked;

  rbMPATHRun.Enabled := frmMODFLOW.cbMODPATH.Checked;

  rbMPATHCreate.Enabled := frmMODFLOW.cbMODPATH.Checked;

  rbRunZonebudget.Enabled := frmMODFLOW.cbZonebudget.Checked;
  rbCreateZonebudget.Enabled := frmMODFLOW.cbZonebudget.Checked;
  cbExpGAG.Enabled := MaybeUseGage;
  cbExpVsc.Enabled := UseViscosityPackage;

  if rbRun.Checked or rbCreate.Checked
    or rbRunSeawat.Checked or rbCreateSeaWat.Checked
    or rbRunGWM.Checked or rbCreateGWM.Checked then
  begin
    gboxMFOutputPackages.Enabled := True;
    comboDiscretization.Visible := True;
    lblDiscretization.Visible := True;
  end
  else
  begin
    gboxMFOutputPackages.Enabled := False;
    comboDiscretization.Visible := False;
    lblDiscretization.Visible := False;
  end;
  gboxMFOutputPackages2.Enabled := gboxMFOutputPackages.Enabled;
  gboxMFOutputPackages3.Enabled := gboxMFOutputPackages.Enabled;

  if rbRunMT3D.Checked or rbCreateMT3D.Checked
    or (rbRunMT3D.Enabled
    and (rbRunSeawat.Checked or rbCreateSeaWat.Checked)) then
  begin
    gboxMT3DPackages.Enabled := True;
    lblMT3DWarning2.Visible := True;
  end
  else
  begin
    gboxMT3DPackages.Enabled := False;
    lblMT3DWarning2.Visible := False;
  end;

  if rbMPATHRun.Checked or rbMPATHCreate.Checked then
  begin
    gbMODPATH.Enabled := True;
    cbMPA.Enabled := True;
    cbPRT.Enabled := True;
  end
  else
  begin
    gbMODPATH.Enabled := False;
  end;

  for Index := 0 to ComponentCount -1 do
  begin
    if Components[Index] is TCheckBox then
    begin
      CheckBox := TCheckBox(Components[Index]);
      if (CheckBox.Parent = gboxMFOutputPackages)
        or (CheckBox.Parent = gboxMT3DPackages)
        or (CheckBox.Parent = gbMODPATH) then
      begin
        GroupBox := CheckBox.Parent as TGroupBox;
        if not GroupBox.Enabled then
        begin
          CheckBox.Enabled := False;
        end;
      end;
    end;
  end;

  cbUseSolute.Enabled := (rbRun.Checked or rbCreate.Checked)
    and frmModflow.cbMOC3D.Checked;
  if not cbUseSolute.Enabled and (rbRun.Checked or rbCreate.Checked) then
  begin
    cbUseSolute.Checked := False;
  end;
  cbUseMT3D.Enabled := (rbRun.Checked or rbCreate.Checked or
    rbRunSeawat.Checked or rbCreateSeaWat.Checked)
    and frmModflow.cbMT3D.Checked;
  if not cbUseMT3D.Enabled and (rbRun.Checked or rbCreate.Checked or
    rbRunSeawat.Checked or rbCreateSeaWat.Checked) then
  begin
    cbUseMT3D.Checked := False;
  end;
  adeModelPathChange(nil);

  if cbUseSolute.Checked then
  begin
    cbExpModelViewer.Caption := 'TOP';
  end
  else
  begin
    cbExpModelViewer.Caption := 'ELEV';
  end;

end;

procedure TfrmRun.FormCreate(Sender: TObject);
begin
  // triggering event frmRun.OnCreate
  pcCreateInputFor.ActivePageIndex := 0;
  PanelColor := clBtnFace;
  pcRun.ActivePage := tabModelChoice;

  EnableControls;
  cbUseSolute.Checked := frmMODFLOW.cbUseSolute.Checked;
  if not cbUseSolute.Enabled and (rbRun.Checked or rbCreate.Checked) then
  begin
    cbUseSolute.Checked := False;
  end;
  cbUseMT3D.Checked := frmMODFLOW.cbUseMT3D.Checked;

  if not cbUseMT3D.Enabled and (rbRun.Checked or rbCreate.Checked or
    rbRunSeawat.Checked or rbCreateSeaWat.Checked) then
  begin
    cbUseMT3D.Checked := False;
  end;
  if frmModflow.rbModflow2005.Checked then
  begin
    rgModflowVersion.ItemIndex := 2;
  end
  else if frmMODFLOW.rbMODFLOW2000.Checked then
  begin
    rgModflowVersion.ItemIndex := 1;
  end
  else
  begin
    rgModflowVersion.ItemIndex := 0;
  end;
  SetMaxFileNameLength;

  adeFileName.Text := frmMODFLOW.adeFileName.Text;
  comboDiscretization.Items[0] := adeFileName.Text + '.dis';

  rbRun.Checked := frmMODFLOW.rbRun.Checked;
  rbCreate.Checked := frmMODFLOW.rbCreate.Checked;
  rbMPATHRun.Checked := frmMODFLOW.rbMPATHRun.Checked;
  rbMPATHCreate.Checked := frmMODFLOW.rbMPATHCreate.Checked;
  rbRunZonebudget.Checked := frmMODFLOW.rbRunZonebudget.Checked;
  rbCreateZonebudget.Checked := frmMODFLOW.rbCreateZonebudget.Checked;
  rbYcint.Checked := frmMODFLOW.rbYcint.Checked;
  rbBeale.Checked := frmMODFLOW.rbBeale.Checked;
  rbRunSeawat.Checked := frmMODFLOW.rbRunSeawat.Checked;
  rbCreateSeaWat.Checked := frmMODFLOW.rbCreateSeaWat.Checked;
  rbRunGWM.Checked := frmMODFLOW.rbRunGWM.Checked;
  rbCreateGWM.Checked := frmMODFLOW.rbCreateGWM.Checked;

  cbCalibrate.Checked := frmMODFLOW.cbCalibrate.Checked;
  cbShowWarnings.Checked := frmMODFLOW.cbShowWarnings.Checked;

  cbBAS.Checked := frmMODFLOW.cbExpBAS.Checked;
  cbDIS.Checked := frmMODFLOW.cbExpDIS.Checked;
  cbMULT.Checked := frmMODFLOW.cbExpMULT.Checked;
  cbZONE.Checked := frmMODFLOW.cbExpZONE.Checked;
  cbLPF.Checked := frmMODFLOW.cbExpLPF.Checked;
  cbOC.Checked := frmMODFLOW.cbExpOC.Checked;
  cbBCF.Checked := frmMODFLOW.cbExpBCF.Checked;
  cbRCH.Checked := frmMODFLOW.cbExpRCH.Checked;
  cbRIV.Checked := frmMODFLOW.cbExpRIV.Checked;
  cbWEL.Checked := frmMODFLOW.cbExpWEL.Checked;
  cbDRN.Checked := frmMODFLOW.cbExpDRN.Checked;
  cbGHB.Checked := frmMODFLOW.cbExpGHB.Checked;
  cbEVT.Checked := frmMODFLOW.cbExpEVT.Checked;
  cbExpHFB.Checked := frmMODFLOW.cbExpHFB.Checked;
  cbExpFHB.Checked := frmMODFLOW.cbExpFHB.Checked;
  cbMatrix.Checked := frmMODFLOW.cbExpMatrix.Checked;
  cbCONC.Checked := frmMODFLOW.cbExpCONC.Checked;
  cbOBS.Checked := frmMODFLOW.cbExpOBS.Checked;
  cbSTR.Checked := frmMODFLOW.cbExpSTR.Checked;
  cbSFR.Checked := frmMODFLOW.cbExpSFR.Checked;
  cbExpLAK.Checked := frmMODFLOW.cbExpLAK.Checked;
  cbExpSUB.Checked := frmMODFLOW.cbExpSUB.Checked;
  cbExpSWT.Checked := frmMODFLOW.cbExpSWT.Checked;
  cbExpIBS.Checked := frmMODFLOW.cbExpIBS.Checked;
  cbExpRES.Checked := frmMODFLOW.cbExpRES.Checked;
  cbExpTLK.Checked := frmMODFLOW.cbExpTLK.Checked;
  cbExpETS.Checked := frmMODFLOW.cbExpETS.Checked;
  cbExpDRT.Checked := frmMODFLOW.cbExpDRT.Checked;
  cbExpHYD.Checked := frmMODFLOW.cbExpHYD.Checked;
  cbExpHUF.Checked := frmMODFLOW.cbExpHUF.Checked;
  cbExpMNW.Checked := frmMODFLOW.cbExpMNW.Checked;
  cbExpMnw2.Checked := frmMODFLOW.cbExpMnw2.Checked;
  cbExpDAFLOW.Checked := frmMODFLOW.cbExpDAFLOW.Checked;
  cbExpBFLX.Checked := frmMODFLOW.cbExpBFLX.Checked;
  cbExpCBDY.Checked := frmMODFLOW.cbExpCBDY.Checked;
  cbExpModelViewer.Checked := frmMODFLOW.cbExpModelViewer.Checked;
  cbExpVdf.Checked := frmMODFLOW.cbExpVdf.Checked;
  cbExpIPDA.Checked := frmMODFLOW.cbExpIPDA.Checked;


  cbHOB.Checked := frmMODFLOW.cbHOB.Checked;
  cbGBOB.Checked := frmMODFLOW.cbGBOB.Checked;
  cbDROB.Checked := frmMODFLOW.cbDROB.Checked;
  cbDTOB.Checked := frmMODFLOW.cbDTOB.Checked;
  cbRVOB.Checked := frmMODFLOW.cbRVOB.Checked;
  cbCHOB.Checked := frmMODFLOW.cbCHOB.Checked;
  cbSEN.Checked := frmMODFLOW.cbSEN.Checked;
  cbSTOB.Checked := frmMODFLOW.cbSTOB.Checked;
  cbADOB.Checked := frmMODFLOW.cbADOB.Checked;
  cbPESExport.Checked := frmMODFLOW.cbPESExport.Checked;
  cbResan.Checked := frmMODFLOW.cbResan.Checked;
  cbExpCHD.Checked := frmMODFLOW.cbExpCHD.Checked;
  cbFTI.Checked := frmMODFLOW.cbFTI.Checked;
  cbExpGAG.Checked := frmMODFLOW.cbExpGAG.Checked;
  cbExpPTOB.Checked := frmMODFLOW.cbExpPTOB.Checked;
  cbExpCCBD.Checked := frmMODFLOW.cbExpCCBD.Checked;
  cbExpVBAL.Checked := frmMODFLOW.cbExpVBAL.Checked;

  cbExpVsc.Checked := frmMODFLOW.cbExpVsc.Checked;

  cbGWM_DECVAR.Checked := frmMODFLOW.cbGWM_DECVAR.Checked;
  cbGWM_OBJFNC.Checked := frmMODFLOW.cbGWM_OBJFNC.Checked;
  cbGWM_VARCON.Checked := frmMODFLOW.cbGWM_VARCON.Checked;
  cbGWM_SUMCON.Checked := frmMODFLOW.cbGWM_SUMCON.Checked;
  cbGWM_HEDCON.Checked := frmMODFLOW.cbGWM_HEDCON.Checked;
  cbGWM_STRMCON.Checked := frmMODFLOW.cbGWM_STRMCON.Checked;
  cbGWM_STAVAR.Checked := frmMODFLOW.cbGWM_STAVAR.Checked;
  cbGWM_SOLN.Checked := frmMODFLOW.cbGWM_SOLN.Checked;
  cbExpUZF.Checked := frmMODFLOW.cbExpUZF.Checked;



  cbMPA.Checked := frmMODFLOW.cbMPA.Checked;
  cbPRT.Checked := frmMODFLOW.cbPRT.Checked;

  cbProgressBar.Checked := frmMODFLOW.cbProgressBar.Checked;

  cbExportMT3DBTN.Checked := frmMODFLOW.cbExportMT3DBTN.Checked;
  cbExportMT3DADV.Checked := frmMODFLOW.cbExportMT3DADV.Checked;
  cbExportMT3DDSP.Checked := frmMODFLOW.cbExportMT3DDSP.Checked;
  cbExportMT3DSSM.Checked := frmMODFLOW.cbExportMT3DSSM.Checked;
  cbExportMT3DRCT.Checked := frmMODFLOW.cbExportMT3DRCT.Checked;
  cbExportMT3DGCG.Checked := frmMODFLOW.cbExportMT3DGCG.Checked;

  adeMT3DPath.Text := frmMODFLOW.adeMT3DPath.Text;

  rbRunMT3D.Checked := frmMODFLOW.rbRunMT3D.Checked;
  rbCreateMT3D.Checked := frmMODFLOW.rbCreateMT3D.Checked;

  case frmModflow.rgSolMeth.ItemIndex of
    0:
      begin
        cbMatrix.Caption := 'SIP';
      end;
    1:
      begin
        cbMatrix.Caption := 'DE4';
      end;
    2:
      begin
        cbMatrix.Caption := 'PCG2';
      end;
    3:
      begin
        cbMatrix.Caption := 'SOR';
      end;
    4:
      begin
        cbMatrix.Caption := 'LMG';
      end;
    5:
      begin
        cbMatrix.Caption := 'GMG';
      end;
    else
      begin
        Assert(False);
      end;
  end;

  adeModflow2000Path.Text := GetLongPathName(frmMODFLOW.adeModflow2000Path.Text);
  adeMODFLOWPath.Text := GetLongPathName(frmMODFLOW.adeMODFLOWPath.Text);
  adeMOC3DPath.Text := GetLongPathName(frmMODFLOW.adeMOC3DPath.Text);
  adeMF2K_GWTPath.Text := GetLongPathName(frmMODFLOW.adeMF2K_GWTPath.Text);
  adeZonebudgetPath.Text := GetLongPathName(frmMODFLOW.adeZonebudgetPath.Text);
  adeMODPATHPath.Text := GetLongPathName(frmMODFLOW.adeMODPATHPath.Text);
  adeMODPATH41Path.Text := GetLongPathName(frmMODFLOW.adeMODPATH41Path.Text);
  adeResanPath.Text := GetLongPathName(frmMODFLOW.adeResanPath.Text);
  adeYcintPath.Text := GetLongPathName(frmMODFLOW.adeYcintPath.Text);
  adeBealePath.Text := GetLongPathName(frmMODFLOW.adeBealePath.Text);
  adeSEAWAT.Text := GetLongPathName(frmMODFLOW.adeSEAWAT.Text);
  adeGWM.Text := GetLongPathName(frmMODFLOW.adeGWM.Text);
  adeModflow2005.Text := GetLongPathName(frmMODFLOW.adeModflow2005.Text);

//  ModelButtonClick(Sender);

  SelectProgram;

  if not rbRunMT3D.Enabled then
  begin
    rbRunMT3D.Checked := False;
  end;

  if not rbCreateMT3D.Enabled then
  begin
    rbCreateMT3D.Checked := False;
  end;

  if not rbMPATHRun.Enabled then
  begin
    rbMPATHRun.Checked := False;
  end;

  if not rbMPATHCreate.Enabled then
  begin
    rbMPATHCreate.Checked := False;
  end;

  if not rbRunZonebudget.Enabled then
  begin
    rbRunZonebudget.Checked := False;
  end;

  if not rbCreateZonebudget.Enabled then
  begin
    rbCreateZonebudget.Checked := False;
  end;
  comboDiscretization.Text := frmMODFLOW.edDiscretization.Text;
  cbModflow2000Click(Sender);
  FreeFormResources(self);

end;

procedure TfrmRun.ResetUnitNumbers;
var
  Index: integer;
  AComponent: TComponent;
  ACheckBox: TCheckBox;
begin
  for Index := 0 to ComponentCount - 1 do
  begin
    AComponent := Components[Index];
    if AComponent is TCheckBox then
    begin
      ACheckBox := AComponent as TCheckBox;
      if ACheckBox.Parent = gboxMFOutputPackages then
      begin
        if ACheckBox.Enabled and not ACheckBox.Checked then
        begin
          if not ((ACheckBox = cbDIS) and (rgModflowVersion.ItemIndex = 0)) then
          begin
            Exit;
          end;
        end;
      end;
    end;
  end;
  frmModflow.ClearUnitNumberStringList;

end;

procedure TfrmRun.btOKClick(Sender: TObject);
var
  dotPosition: integer;
  AName: string;
  FileName: string;
  ModelPaths : TStringList;
begin
  // triggering event: btOK.OnClick
  if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    frmModflow.MT3DWarning;
    frmModflow.Mt3dTransObsWarning
  end;

  UseSolute := cbUseSolute.Enabled and cbUseSolute.Checked;

  if cbUseSolute.Enabled then
  begin
    frmMODFLOW.cbUseSolute.Checked := cbUseSolute.Checked;
  end;
  if cbUseMT3D.Enabled then
  begin
    frmMODFLOW.cbUseMT3D.Checked := cbUseMT3D.Checked;
  end;
  if cbResan.Enabled then
  begin
    frmMODFLOW.cbResan.Checked := cbResan.Checked;
  end;

  frmMODFLOW.rbModflow2005.Checked := (rgModflowVersion.ItemIndex = 2);
  frmMODFLOW.rbMODFLOW2000.Checked := (rgModflowVersion.ItemIndex = 1);
  frmMODFLOW.rbMODFLOW96.Checked := (rgModflowVersion.ItemIndex = 0);
  frmMODFLOW.cbExpModelViewer.Checked := cbExpModelViewer.Checked;

  frmMODFLOW.rbRun.Checked := rbRun.Checked;
  frmMODFLOW.rbCreate.Checked := rbCreate.Checked;
  frmMODFLOW.rbRunZonebudget.Checked := rbRunZonebudget.Checked;
  frmMODFLOW.rbCreateZonebudget.Checked := rbCreateZonebudget.Checked;
  frmMODFLOW.rbMPATHRun.Checked := rbMPATHRun.Checked;
  frmMODFLOW.rbMPATHCreate.Checked := rbMPATHCreate.Checked;
  frmMODFLOW.rbYcint.Checked := rbYcint.Checked;
  frmMODFLOW.rbBeale.Checked := rbBeale.Checked;
  frmMODFLOW.rbRunSeawat.Checked := rbRunSeawat.Checked;
  frmMODFLOW.rbCreateSeaWat.Checked := rbCreateSeaWat.Checked;
  frmMODFLOW.rbRunGWM.Checked := rbRunGWM.Checked;
  frmMODFLOW.rbCreateGWM.Checked := rbCreateGWM.Checked;

  frmMODFLOW.cbCalibrate.Checked := cbCalibrate.Checked;
  frmMODFLOW.cbShowWarnings.Checked := cbShowWarnings.Checked;

  frmMODFLOW.cbExpBAS.Checked := cbBAS.Checked;
  frmMODFLOW.cbExpDIS.Checked := cbDIS.Checked;
  frmMODFLOW.cbExpMULT.Checked := cbMULT.Checked;
  frmMODFLOW.cbExpZONE.Checked := cbZONE.Checked;
  frmMODFLOW.cbExpLPF.Checked := cbLPF.Checked;
  frmMODFLOW.cbExpHUF.Checked := cbExpHUF.Checked;
  frmMODFLOW.cbExpOC.Checked := cbOC.Checked;
  frmMODFLOW.cbExpBCF.Checked := cbBCF.Checked;
  frmMODFLOW.cbExpRCH.Checked := cbRCH.Checked;
  frmMODFLOW.cbExpRIV.Checked := cbRIV.Checked;
  frmMODFLOW.cbExpWEL.Checked := cbWEL.Checked;
  frmMODFLOW.cbExpDRN.Checked := cbDRN.Checked;
  frmMODFLOW.cbExpDRT.Checked := cbExpDRT.Checked;
  frmMODFLOW.cbExpGHB.Checked := cbGHB.Checked;
  frmMODFLOW.cbExpEVT.Checked := cbEVT.Checked;
  frmMODFLOW.cbExpETS.Checked := cbExpETS.Checked;
  frmMODFLOW.cbExpHFB.Checked := cbExpHFB.Checked;
  frmMODFLOW.cbExpFHB.Checked := cbExpFHB.Checked;
  frmMODFLOW.cbExpMatrix.Checked := cbMatrix.Checked;
  frmMODFLOW.cbExpCONC.Checked := cbCONC.Checked;
  frmMODFLOW.cbExpOBS.Checked := cbOBS.Checked;
  frmMODFLOW.cbExpSTR.Checked := cbSTR.Checked;
  frmMODFLOW.cbExpSFR.Checked := cbSFR.Checked;
  frmMODFLOW.cbExpLAK.Checked := cbExpLAK.Checked;
  frmMODFLOW.cbExpSUB.Checked := cbExpSUB.Checked;
  frmMODFLOW.cbExpSWT.Checked := cbExpSWT.Checked;
  frmMODFLOW.cbExpIBS.Checked := cbExpIBS.Checked;
  frmMODFLOW.cbExpRES.Checked := cbExpRES.Checked;
  frmMODFLOW.cbExpTLK.Checked := cbExpTLK.Checked;
  frmMODFLOW.cbExpHYD.Checked := cbExpHYD.Checked;
  frmMODFLOW.cbExpCHD.Checked := cbExpCHD.Checked;
  frmMODFLOW.cbExpMNW.Checked := cbExpMNW.Checked;
  frmMODFLOW.cbExpMnw2.Checked := cbExpMnw2.Checked;
  frmMODFLOW.cbExpDAFLOW.Checked := cbExpDAFLOW.Checked;
  frmMODFLOW.cbExpVdf.Checked := cbExpVdf.Checked;

  frmMODFLOW.cbHOB.Checked := cbHOB.Checked;
  frmMODFLOW.cbGBOB.Checked := cbGBOB.Checked;
  frmMODFLOW.cbDROB.Checked := cbDROB.Checked;
  frmMODFLOW.cbDTOB.Checked := cbDTOB.Checked;
  frmMODFLOW.cbRVOB.Checked := cbRVOB.Checked;
  frmMODFLOW.cbCHOB.Checked := cbCHOB.Checked;
  frmMODFLOW.cbSTOB.Checked := cbSTOB.Checked;
  frmMODFLOW.cbADOB.Checked := cbADOB.Checked;
  frmMODFLOW.cbSEN.Checked := cbSEN.Checked;
  frmMODFLOW.cbPESExport.Checked := cbPESExport.Checked;
  frmMODFLOW.cbExpBFLX.Checked := cbExpBFLX.Checked;
  frmMODFLOW.cbExpCBDY.Checked := cbExpCBDY.Checked;
  frmMODFLOW.cbProgressBar.Checked := cbProgressBar.Checked;
  frmMODFLOW.cbFTI.Checked := cbFTI.Checked;

  frmMODFLOW.cbGWM_DECVAR.Checked := cbGWM_DECVAR.Checked;
  frmMODFLOW.cbGWM_OBJFNC.Checked := cbGWM_OBJFNC.Checked;
  frmMODFLOW.cbGWM_VARCON.Checked := cbGWM_VARCON.Checked;
  frmMODFLOW.cbGWM_SUMCON.Checked := cbGWM_SUMCON.Checked;
  frmMODFLOW.cbGWM_HEDCON.Checked := cbGWM_HEDCON.Checked;
  frmMODFLOW.cbGWM_STRMCON.Checked := cbGWM_STRMCON.Checked;
  frmMODFLOW.cbGWM_SOLN.Checked := cbGWM_SOLN.Checked;
  frmMODFLOW.cbGWM_STAVAR.Checked := cbGWM_STAVAR.Checked;
  frmMODFLOW.cbExpUZF.Checked := cbExpUZF.Checked;

  frmMODFLOW.cbMPA.Checked := cbMPA.Checked;
  frmMODFLOW.cbPRT.Checked := cbPRT.Checked;
  frmMODFLOW.cbExpGAG.Checked := cbExpGAG.Checked;
  frmMODFLOW.cbExpPTOB.Checked := cbExpPTOB.Checked;
  frmMODFLOW.cbExpCCBD.Checked := cbExpCCBD.Checked;
  frmMODFLOW.cbExpVBAL.Checked := cbExpVBAL.Checked;
  frmMODFLOW.cbExpVsc.Checked := cbExpVsc.Checked;

  frmMODFLOW.cbExportMT3DBTN.Checked := cbExportMT3DBTN.Checked;
  frmMODFLOW.cbExportMT3DADV.Checked := cbExportMT3DADV.Checked;
  frmMODFLOW.cbExportMT3DDSP.Checked := cbExportMT3DDSP.Checked;
  frmMODFLOW.cbExportMT3DSSM.Checked := cbExportMT3DSSM.Checked;
  frmMODFLOW.cbExportMT3DRCT.Checked := cbExportMT3DRCT.Checked;
  frmMODFLOW.cbExportMT3DGCG.Checked := cbExportMT3DGCG.Checked;

  frmMODFLOW.edDiscretization.Text := comboDiscretization.Text;

  frmMODFLOW.adeModflow2000Path.Text :=
    ExtractShortPathName(adeModflow2000Path.Text);
  if frmMODFLOW.adeModflow2000Path.Text = '' then
    frmMODFLOW.adeModflow2000Path.Text := adeModflow2000Path.Text;

  frmMODFLOW.adeMODFLOWPath.Text := ExtractShortPathName(adeMODFLOWPath.Text);
  if frmMODFLOW.adeMODFLOWPath.Text = '' then
    frmMODFLOW.adeMODFLOWPath.Text := adeMODFLOWPath.Text;

  frmMODFLOW.adeMOC3DPath.Text := ExtractShortPathName(adeMOC3DPath.Text);
  if frmMODFLOW.adeMOC3DPath.Text = '' then
    frmMODFLOW.adeMOC3DPath.Text := adeMOC3DPath.Text;

  frmMODFLOW.adeMF2K_GWTPath.Text := ExtractShortPathName(adeMF2K_GWTPath.Text);
  if frmMODFLOW.adeMF2K_GWTPath.Text = '' then
    frmMODFLOW.adeMF2K_GWTPath.Text := adeMF2K_GWTPath.Text;

  frmMODFLOW.adeZonebudgetPath.Text :=
    ExtractShortPathName(adeZonebudgetPath.Text);
  if frmMODFLOW.adeZonebudgetPath.Text = '' then
    frmMODFLOW.adeZonebudgetPath.Text := adeZonebudgetPath.Text;

  frmMODFLOW.adeMODPATHPath.Text := ExtractShortPathName(adeMODPATHPath.Text);
  if frmMODFLOW.adeMODPATHPath.Text = '' then
    frmMODFLOW.adeMODPATHPath.Text := adeMODPATHPath.Text;

  frmMODFLOW.adeMODPATH41Path.Text :=
    ExtractShortPathName(adeMODPATH41Path.Text);
  if frmMODFLOW.adeMODPATH41Path.Text = '' then
    frmMODFLOW.adeMODPATH41Path.Text := adeMODPATH41Path.Text;

  frmMODFLOW.adeResanPath.Text := ExtractShortPathName(adeResanPath.Text);
  if frmMODFLOW.adeResanPath.Text = '' then
    frmMODFLOW.adeResanPath.Text := adeResanPath.Text;

  frmMODFLOW.adeYcintPath.Text := ExtractShortPathName(adeYcintPath.Text);
  if frmMODFLOW.adeYcintPath.Text = '' then
    frmMODFLOW.adeYcintPath.Text := adeYcintPath.Text;

  frmMODFLOW.adeBealePath.Text := ExtractShortPathName(adeBealePath.Text);
  if frmMODFLOW.adeBealePath.Text = '' then
    frmMODFLOW.adeBealePath.Text := adeBealePath.Text;

  frmMODFLOW.adeSEAWAT.Text := ExtractShortPathName(adeSEAWAT.Text);
  if frmMODFLOW.adeSEAWAT.Text = '' then
    frmMODFLOW.adeSEAWAT.Text := adeSEAWAT.Text;

  frmMODFLOW.adeGWM.Text := ExtractShortPathName(adeGWM.Text);
  if frmMODFLOW.adeGWM.Text = '' then
    frmMODFLOW.adeGWM.Text := adeGWM.Text;

  frmMODFLOW.adeModflow2005.Text :=
    ExtractShortPathName(adeModflow2005.Text);
  if frmMODFLOW.adeModflow2005.Text = '' then
    frmMODFLOW.adeModflow2005.Text := adeModflow2005.Text;

  if ExtractShortPathName(adeMT3DPath.Text) <> '' then
  begin
    frmMODFLOW.adeMT3DPath.Text := ExtractShortPathName(adeMT3DPath.Text);
  end
  else
  begin
    frmMODFLOW.adeMT3DPath.Text := adeMT3DPath.Text;
  end;

  frmMODFLOW.rbRunMT3D.Checked := rbRunMT3D.Checked;
  frmMODFLOW.rbCreateMT3D.Checked := rbCreateMT3D.Checked;

  if rbRun.Checked or rbCreate.Checked then
  begin
    if rgModflowVersion.ItemIndex = 2 then
    begin
        if not FileExists(adeModflow2005.Text) then
        begin
          Beep;
          if (MessageDlg(adeModflow2005.Text + ' does not exist. '
            + 'Do you still wish to export the MODFLOW 2005 input files?',
            mtWarning, [mbYes, mbNo], 0) <> mrYes) then
            ModalResult := mrNone;
        end;
    end
    else if rgModflowVersion.ItemIndex = 1 then
    begin
      if cbUseSolute.Checked then
      begin
        if not FileExists(adeMF2K_GWTPath.Text) then
        begin
          Beep;
          if MessageDlg(adeMF2K_GWTPath.Text + ' does not exist. '
            + 'Do you still wish to export the MF2K_GWT input files?',
            mtWarning, [mbYes, mbNo], 0) <> mrYes then
            ModalResult := mrNone;
        end;
      end
      else
      begin
        if not FileExists(adeModflow2000Path.Text) then
        begin
          Beep;
          if (MessageDlg(adeModflow2000Path.Text + ' does not exist. '
            + 'Do you still wish to export the MODFLOW 2000 input files?',
            mtWarning, [mbYes, mbNo], 0) <> mrYes) then
            ModalResult := mrNone;
        end;
      end;
      if cbResan.Checked and cbResan.Enabled then
      begin
        if not FileExists(adeResanPath.Text) then
        begin
          Beep;
          if (MessageDlg(adeResanPath.Text + ' does not exist. '
            + 'Do you still wish to export the MODFLOW 2000 input files?',
            mtWarning, [mbYes, mbNo], 0) <> mrYes) then
            ModalResult := mrNone;
        end;
      end;
    end
    else if cbUseSolute.Checked then
    begin
      if rgModflowVersion.ItemIndex = 1 then
      begin
        if not FileExists(adeMF2K_GWTPath.Text) then
        begin
          Beep;
          if MessageDlg(adeMF2K_GWTPath.Text + ' does not exist. '
            + 'Do you still wish to export the MF2K_GWT input files?',
            mtWarning, [mbYes, mbNo], 0) <> mrYes then
            ModalResult := mrNone;
        end;
      end
      else
      begin
        if not FileExists(adeMOC3DPath.Text) then
        begin
          Beep;
          if MessageDlg(adeMOC3DPath.Text + ' does not exist. '
            + 'Do you still wish to export the MOC3D input files?',
            mtWarning, [mbYes, mbNo], 0) <> mrYes then
            ModalResult := mrNone;
        end;
      end;
    end
    else
    begin
      if not FileExists(adeMODFLOWPath.Text) then
      begin
        Beep;
        if MessageDlg(adeMODFLOWPath.Text + ' does not exist. '
          + 'Do you still wish to export the MODFLOW input files?',
          mtWarning, [mbYes, mbNo], 0) <> mrYes then
          ModalResult := mrNone;
      end;
    end;
  end
  else if rbMPATHRun.Checked or rbMPATHCreate.Checked then
  begin
    if rgModflowVersion.ItemIndex in [1,2] then
    begin
      FileName := adeMODPATH41Path.Text;
    end
    else
    begin
      FileName := adeMODPATHPath.Text;
    end;
    if not FileExists(FileName) then
    begin
      Beep;
      if MessageDlg(FileName + ' does not exist. '
        + 'Do you still wish to export the MODPATH input files?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end
  else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
  begin
    if not FileExists(adeZonebudgetPath.Text) then
    begin
      Beep;
      if MessageDlg(adeZonebudgetPath.Text + ' does not exist. '
        + 'Do you still wish to export the ZONEBUDGET input files?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end
  else if rbYcint.Checked then
  begin
    if not FileExists(adeYcintPath.Text) then
    begin
      Beep;
      if MessageDlg(adeYcintPath.Text + ' does not exist. '
        + 'Do you still wish to try run YCINT-2000?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end
  else if rbBeale.Checked then
  begin
    if not FileExists(adeBealePath.Text) then
    begin
      Beep;
      if MessageDlg(adeBealePath.Text + ' does not exist. '
        + 'Do you still wish to try run BEALE-2000?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end
  else if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    if not FileExists(adeMT3DPath.Text) then
    begin
      if MessageDlg(adeMT3DPath.Text + ' does not exist. '
        + 'Do you still wish to export the MT3DMS input files?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end
  else if rbRunSeawat.Checked or rbCreateSeaWat.Checked then
  begin
    if not FileExists(adeSEAWAT.Text) then
    begin
      if MessageDlg(adeSEAWAT.Text + ' does not exist. '
        + 'Do you still wish to export the SEAWAT input files?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end
  else if rbRunGWM.Checked or rbCreateGWM.Checked then
  begin
    if not FileExists(adeGWM.Text) then
    begin
      if MessageDlg(adeGWM.Text + ' does not exist. '
        + 'Do you still wish to export the GWM input files?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        ModalResult := mrNone;
    end;
  end;

  FileName := GetProgramPath;
  if (Pos('\n', FileName) > 0) or (Pos('\t', FileName) > 0) then
  begin
    Beep;
    if MessageDlg('"' + FileName + '" contains "\n" or "\t"'
      + 'which may not be exported correctly by Argus ONE. '
      + 'Do you still wish to export the input files?',
      mtWarning, [mbYes, mbNo], 0) <> mrYes then
      ModalResult := mrNone
  end;
  if Lowercase(adeFileName.Text) = 'dummy' then
  begin
    Beep;
    MessageDlg(adeFileName.Text + ' is an invalid name for the root. '
      + 'Please correct this problem and try again.', mtWarning, [mbOK], 0);
    ModalResult := mrNone;
  end;
  //  if ExportModflow2000 then
  begin
    if ModalResult = mrOK then
    begin
      savedlgExportFiles.FileName := adeFileName.Text;
      savedlgExportFiles.InitialDir := GetCurrentDir;
      if rbRun.Checked or rbCreate.Checked then
      begin
        savedlgExportFiles.DefaultExt := 'nam';
        savedlgExportFiles.Filter := 'Name Files (*.nam)|*.nam|All Files|*.*';
      end
      else if rbMPATHRun.Checked or rbMPATHCreate.Checked then
      begin
        savedlgExportFiles.DefaultExt := 'pnm';
        savedlgExportFiles.Filter :=
          'ModPath Name Files (*.pnm)|*.pnm|All Files|*.*';
      end
      else if rbRunZonebudget.Checked or rbCreateZonebudget.Checked then
      begin
        savedlgExportFiles.DefaultExt := 'zbi';
        savedlgExportFiles.Filter :=
          'ZoneBudget Input Files (*.zbi)|*.zbi|All Files|*.*';
      end
      else if rbRunMT3D.Checked or rbCreateMT3D.Checked then
      begin
        savedlgExportFiles.DefaultExt := 'mnm';
        savedlgExportFiles.Filter :=
          'MT3DMS Name Files (*.mnm)|*.mnm|All Files|*.*';
      end
      else
      begin
        savedlgExportFiles.DefaultExt := 'nam';
        savedlgExportFiles.Filter := 'Name Files (*.nam)|*.nam|All Files|*.*';
      end;

      if savedlgExportFiles.Execute then
      begin
        AName := ExtractFileName(savedlgExportFiles.FileName);
        dotPosition := Pos('.', AName);
        if dotPosition > 0 then
        begin
          AName := Trim(Copy(AName, 1, dotPosition - 1))
        end;
        if (rgModflowVersion.ItemIndex = 0) and (Length(AName) > 8) then
        begin
          AName := Trim(Copy(AName, 1, 8))
        end;
        if AName <> '' then
        begin
          adeFileName.Text := AName;
          ModalResult := mrOK;
        end
        else
        begin
          ModalResult := mrNone;
        end;
      end
      else
      begin
        ModalResult := mrNone;
      end;
    end;
  end;
  frmMODFLOW.adeFileName.Text := adeFileName.Text;
  if ModalResult = mrOK then
  begin
    ResetUnitNumbers;
    ModelPaths := TStringList.Create;
    try // try3
      frmMODFLOW.ModelPaths(ModelPaths, frmMODFLOW.lblVersion, rsDeveloper);
      try
        ModelPaths.SaveToFile(IniFile(self.Handle));
      except
      end;
    finally
      ModelPaths.Free;
    end;
  end;
end;

procedure TfrmRun.BrowseClick(Sender: TObject);
var
  APath: TArgusDataEntry;
  Dir: string;
begin
  // triggering event: btnMODFLOWBrowse.OnClick
  // triggering event: btMOC3DBrowse.OnClick
  // triggering event: btnZonebudget.OnClick
  // triggering event: btnMODPATH.OnClick
  Dir := GetCurrentDir;
  try
    APath := adeMODFLOWPath;
    if Sender = btnMODFLOWBrowse then
    begin
      APath := adeMODFLOWPath;
    end
    else if Sender = btnModflow2000 then
    begin
      APath := adeModflow2000Path;
    end
    else if Sender = btnMOC3DBrowse then
    begin
      APath := adeMOC3DPath;
    end
    else if Sender = btnMF2K_GWTBrowse then
    begin
      APath := adeMF2K_GWTPath;
    end
    else if Sender = btnMODPATH then
    begin
      APath := adeMODPATHPath;
    end
    else if Sender = btnMODPATH41 then
    begin
      APath := adeMODPATH41Path;
    end
    else if Sender = btnZonebudget then
    begin
      APath := adeZonebudgetPath;
    end
    else if Sender = btnResan then
    begin
      APath := adeResanPath;
    end
    else if Sender = btnYcintPath then
    begin
      APath := adeYcintPath;
    end
    else if Sender = btnBealePath then
    begin
      APath := adeBealePath;
    end
    else if Sender = btnMT3D then
    begin
      APath := adeMT3DPath;
    end
    else if Sender = btnSEAWAT then
    begin
      APath := adeSEAWAT;
    end
    else if Sender = btnGWM then
    begin
      APath := adeGWM;
    end
    else if Sender = btnModflow2005 then
    begin
      APath := adeModflow2005;
    end
    else
      Assert(False);

    opendialGetPath.FileName := APath.Text;
    if opendialGetPath.Execute then
    begin
      APath.Text := opendialGetPath.FileName;
    end;
  finally
    SetCurrentDir(Dir);
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
  EnableControls;
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
  else if (rbRun.Checked or rbCreate.Checked or rbYcint.Checked or
    rbBeale.Checked or rbRunSeawat.Checked or rbCreateSeaWat.Checked
    or rbRunGWM.Checked or rbCreateGWM.Checked)
    and (rgModflowVersion.ItemIndex in [1,2]) then
  begin
    result := 'MF_Modflow2000.met';
  end
  else if rbRunMT3D.Checked or rbCreateMT3D.Checked then
  begin
    result := 'MT3DMS.met';
  end
  else
  begin
    result := 'modflow.met';
  end;
end;

procedure TfrmRun.ModelPathChange(Sender: TObject);
var
  TheFileExists: boolean;
begin
  TheFileExists := True;
  adeMOC3DPath.EnabledColor := clWindow;
  adeMF2K_GWTPath.EnabledColor := clWindow;
  adeMODFLOWPath.EnabledColor := clWindow;
  adeModflow2000Path.EnabledColor := clWindow;
  adeMODPATHPath.EnabledColor := clWindow;
  adeMODPATH41Path.EnabledColor := clWindow;
  adeZonebudgetPath.EnabledColor := clWindow;
  adeResanPath.EnabledColor := clWindow;
  adeYcintPath.EnabledColor := clWindow;
  adeBealePath.EnabledColor := clWindow;
  adeSEAWAT.EnabledColor := clWindow;
  adeModflow2005.EnabledColor := clWindow;
  adeGWM.EnabledColor := clWindow;
  if rbRun.Checked or rbCreate.Checked then
  begin
    if rgModflowVersion.ItemIndex = 2 then
    begin
        if FileExists(adeModflow2005.Text) then
        begin
          adeModflow2005.EnabledColor := clWindow;
          TheFileExists := True;
        end
        else
        begin
          adeModflow2005.EnabledColor := clRed;
          TheFileExists := False;
        end;
    end
    else if rgModflowVersion.ItemIndex = 1 then
    begin
      if cbUseSolute.Checked then
      begin
        if FileExists(adeMF2K_GWTPath.Text) then
        begin
          adeMF2K_GWTPath.EnabledColor := clWindow;
          TheFileExists := True;
        end
        else
        begin
          adeMF2K_GWTPath.EnabledColor := clRed;
          TheFileExists := False;
        end;
      end
      else
      begin
        if FileExists(adeModflow2000Path.Text) then
        begin
          adeModflow2000Path.EnabledColor := clWindow;
          TheFileExists := True;
        end
        else
        begin
          adeModflow2000Path.EnabledColor := clRed;
          TheFileExists := False;
        end;
      end;
      if cbResan.Checked and cbResan.Enabled then
      begin
        if FileExists(adeResanPath.Text) then
        begin
          adeResanPath.EnabledColor := clWindow;
          //          TheFileExists := TheFileExists and True;
        end
        else
        begin
          adeResanPath.EnabledColor := clRed;
          TheFileExists := False;
        end;
      end;
    end
    else if cbUseSolute.Checked then
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
    if rgModflowVersion.ItemIndex in [1,2] then
    begin
      if FileExists(adeMODPATH41Path.Text) then
      begin
        adeMODPATH41Path.EnabledColor := clWindow;
        TheFileExists := True;
      end
      else
      begin
        adeMODPATH41Path.EnabledColor := clRed;
        TheFileExists := False;
      end;
    end
    else
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
  end
  else if rbYcint.Checked and rbYcint.Enabled then
  begin
    if FileExists(adeYcintPath.Text) then
    begin
      adeYcintPath.EnabledColor := clWindow;
      //          TheFileExists := TheFileExists and True;
    end
    else
    begin
      adeYcintPath.EnabledColor := clRed;
      TheFileExists := False;
    end;
  end
  else if rbBeale.Checked and rbBeale.Enabled then
  begin
    if FileExists(adeBealePath.Text) then
    begin
      adeBealePath.EnabledColor := clWindow;
      //          TheFileExists := TheFileExists and True;
    end
    else
    begin
      adeBealePath.EnabledColor := clRed;
      TheFileExists := False;
    end;
  end
  else if (rbRunMT3D.Checked or rbCreateMT3D.Checked) and rbRunMT3D.Enabled then
  begin
    if FileExists(adeMT3DPath.Text) then
    begin
      adeMT3DPath.EnabledColor := clWindow;
      TheFileExists := True;
    end
    else
    begin
      adeMT3DPath.EnabledColor := clRed;
      TheFileExists := False;
    end;
  end
  else if (rbRunSeawat.Checked or rbCreateSeaWat.Checked) and rbRunSeawat.Enabled then
  begin
    if FileExists(adeSEAWAT.Text) then
    begin
      adeSEAWAT.EnabledColor := clWindow;
      TheFileExists := True;
    end
    else
    begin
      adeSEAWAT.EnabledColor := clRed;
      TheFileExists := False;
    end;
  end
  else if (rbRunGWM.Checked or rbCreateGWM.Checked) and rbRunGWM.Enabled then
  begin
    if FileExists(adeGWM.Text) then
    begin
      adeGWM.EnabledColor := clWindow;
      TheFileExists := True;
    end
    else
    begin
      adeGWM.EnabledColor := clRed;
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
    sbModelStatus.SimpleText := 'Warning: Executable file not found. '
      + 'Check Model Paths tab';
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

procedure RunModflowPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;
begin
  Exporting := True;
  try
    try
      aProgram := progMODFLOW;
      RunPIE(aneHandle, '');
      returnTemplate^ := Template;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Exporting := False;
  end;
end;

procedure RunModpathPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;
var
  WarningString: string;
begin
  Exporting := True;
  try
    try
      aProgram := progMODPATH;
      WarningString := 'You can not run MODPATH until you first select '
        + '"MODPATH" on the "Project" tab of the Edit Project Info '
        + 'dialog box.';
      RunPIE(aneHandle, WarningString);
      returnTemplate^ := Template;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Exporting := False;
  end;

end;

procedure RunZondbdgtPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;
var
  WarningString: string;
begin
  Exporting := True;
  try
    try
      WarningString := 'You can not run ZONEBUDGET until you first select '
        + '"ZONEBUDGET" on the "Project" tab of the Edit Project Info '
        + 'dialog box.';
      aProgram := progZONEBDGT;
      RunPIE(aneHandle, WarningString);
      returnTemplate^ := Template;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Exporting := False;
  end;
end;

procedure RunMT3DPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;
var
  WarningString: string;
begin
  Exporting := True;
  try
    try
      WarningString := 'You can not run MT3DMS until you first select '
        + 'the "MT3DMS" checkbox and the MODFLOW-2000 radio button '
        + 'on the "Project" tab of the '
        + '"Edit Project Info..." '
        + 'dialog box.';
      aProgram := progMT3D;
      RunPIE(aneHandle, WarningString);
      returnTemplate^ := Template;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Exporting := False;
  end;
end;

procedure RunSeawatPIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;
var
  WarningString: string;
begin
  Exporting := True;
  try
    try
      WarningString := 'You can not run SEAWAT until you first select '
        + '"SEAWAT" on the "Project" tab of the Edit Project Info '
        + 'dialog box.';
      aProgram := progSEAWAT;
      RunPIE(aneHandle, WarningString);
      returnTemplate^ := Template;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Exporting := False;
  end;
end;

procedure RunGWM_PIE(aneHandle: ANE_PTR;
  returnTemplate: ANE_STR_PTR); cdecl;
var
  WarningString: string;
begin
  Exporting := True;
  try
    try
      WarningString := 'You can not run GWM until you first select '
        + '"GWM" on the "Project" tab of the Edit Project Info '
        + 'dialog box.';
      aProgram := progGWM;
      RunPIE(aneHandle, WarningString);
      returnTemplate^ := Template;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Exporting := False;
  end;
end;


procedure TfrmRun.sbModelStatusDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  sbModelStatus.Canvas.Brush.Color := PanelColor;
  sbModelStatus.Canvas.FillRect(Rect);
  sbModelStatus.Canvas.TextRect(Rect, Rect.Left, Rect.Top,
    sbModelStatus.SimpleText);
end;

procedure TfrmRun.adeFileNameExit(Sender: TObject);
var
  Index: integer;
  OldName, NewName: string;
begin

  // convert the root name of the simulation file to lowercase.
  // This makes it easier to run the MODFLOW simulation on UNIX.
  // Also elimnate blank spaces.
//  adeFileName.Text := Trim(Lowercase(adeFileName.Text));

  // lower case conversion dropped.
  adeFileName.Text := Trim(adeFileName.Text);
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

  OldName := OldRoot + '.dis';
  NewName := adeFileName.Text + '.dis';
  comboDiscretization.Items[0] := NewName;
  if comboDiscretization.Text = OldName then
  begin
    comboDiscretization.Text := NewName;
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

function TfrmRun.ExportModflow2000: boolean;
begin
  result := (rbRun.Checked or rbCreate.Checked)
    and (rgModflowVersion.ItemIndex = 1);
end;

procedure TfrmRun.SetMaxFileNameLength;
begin
  if rgModflowVersion.ItemIndex = 0 then
  begin
    adeFileName.MaxLength := 8;
  end
  else
  begin
    adeFileName.MaxLength := 0;
  end;
end;

procedure TfrmRun.cbModflow2000Click(Sender: TObject);
begin
  SetMaxFileNameLength;
  if rgModflowVersion.ItemIndex >= 1 then
  begin
    lblMOC3DObsWells.Caption := 'GWT Observation Wells:';
    rbRun.Caption := '&Create input files and run MODFLOW';
    cbUseSolute.Caption := '&Simulate solute transport';
    rbCreate.Caption := 'Create MODFLOW and/or solute transport';
  end
  else
  begin
    lblMOC3DObsWells.Caption := 'MOC3D Observation Wells:';
    rbRun.Caption := '&Create input files and run MODFLOW or MOC3D';
    cbUseSolute.Caption := '&Include MOC3D to simulate solute transport';
    rbCreate.Caption := 'Create MODFLOW and/or MOC3D';
  end;

  cbUseSolute.Enabled := rgModflowVersion.ItemIndex <= 1;
  cbUseMT3D.Enabled := rgModflowVersion.ItemIndex <= 1;

  ModelPathChange(Sender);
  comboDiscretization.Enabled := rgModflowVersion.ItemIndex = 0;
  if rgModflowVersion.ItemIndex = 0 then
  begin
    cbDis.Checked := False;
  end;

  cbExpModelViewer.Enabled := rgModflowVersion.ItemIndex = 0;
  cbMULT.Enabled := rgModflowVersion.ItemIndex in [1,2];
  cbZONE.Enabled := rgModflowVersion.ItemIndex in [1,2];

  cbExpHUF.Enabled := (frmModflow.rgFlowPackage.ItemIndex = 2)
    and (rgModflowVersion.ItemIndex in [1,2]);
  cbLPF.Enabled := (frmModflow.rgFlowPackage.ItemIndex = 1)
    and (rgModflowVersion.ItemIndex in [1,2]);
  cbBCF.Enabled := not cbLPF.Enabled and not cbExpHUF.Enabled;

  cbHOB.Enabled := (frmMODFLOW.cbHeadObservations.Checked
    or frmMODFLOW.cbWeightedHeadObservations.Checked)
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbGBOB.Enabled := cbGHB.enabled and frmMODFLOW.cbGHBObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbDROB.Enabled := cbDRN.enabled and frmMODFLOW.cbDRNObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbDTOB.Enabled := cbExpDRT.enabled and frmMODFLOW.cbDRTObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbRVOB.Enabled := cbRIV.enabled and frmMODFLOW.cbRIVObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbSTOB.Enabled := cbSTR.enabled and frmMODFLOW.cbStreamObservations.Checked
    and frmModflow.cbObservations.Checked and (rgModflowVersion.ItemIndex in [1,2]);
  cbCHOB.Enabled := frmModflow.cbObservations.Checked
    and frmModflow.cbHeadFluxObservations.Checked
    and (rgModflowVersion.ItemIndex in [1,2]);
  cbADOB.Enabled := frmModflow.cbObservations.Checked
    and frmModflow.cbAdvObs.Checked and (rgModflowVersion.ItemIndex = 1);

  cbSEN.Enabled := frmMODFLOW.cbSensitivity.Checked
    and (rgModflowVersion.ItemIndex = 1);
  cbPESExport.Enabled := frmMODFLOW.cbParamEst.Checked
    and (rgModflowVersion.ItemIndex = 1);
  cbResan.Enabled := cbPESExport.Enabled and (rgModflowVersion.ItemIndex <= 1);
  if not cbResan.Enabled then
  begin
    cbResan.Checked := False;
  end;

end;

procedure TfrmRun.pcRunChange(Sender: TObject);
begin
  FreePageControlResources(pcRun, Handle);
end;

procedure TfrmRun.adeFileNameEnter(Sender: TObject);
begin
  OldRoot := adeFileName.Text;
end;

end.

