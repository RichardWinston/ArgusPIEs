unit RunsutraUnit;

{$IFDEF SutraIce}
  {$DEFINE SUTRA22}
{$ENDIF}  
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE, addbtn95, ComCtrls;

type
  TfrmRun = class(TForm)
    PageControlMain: TPageControl;
    tabFirst: TTabSheet;
    tabSecond: TTabSheet;
    lblPath: TLabel;
    cbExternal: TCheckBox;
    rgAlert: TRadioGroup;
    rgRunSutra: TRadioGroup;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    btnEdit: TButton;
    edSutraPath: TEdit;
    BitBtn3: TBitBtn;
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
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    edRoot: TEdit;
    lblRoot: TLabel;
    gbPolyhedron: TGroupBox;
    rbMemory: TRadioButton95;
    rbStore: TRadioButton95;
    rbRead: TRadioButton95;
    rbCompute: TRadioButton95;
    btnAll: TButton;
    btnNone: TButton;
    cbSaveTempFiles: TCheckBox;
    Label19: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure edSutraPathChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure edRootChange(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure rgRunSutraClick(Sender: TObject);
  private
    procedure EnablePolyhedronChoice;
    function GetRoot: String;
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

uses FileCtrl, frmSutraUnit, ANE_LayerUnit, ArgusFormUnit, UtilityFunctions,
  ProjectFunctions, OptionsUnit, VirtualMeshFunctions;

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
                  frmRun.CurrentModelHandle := aneHandle;
                  if frmRun.ShowModal = mrOK then
                  begin
                      frmRun.Cursor := crHourGlass;
                      TemplateStringList := TStringList.Create;
                      try
                          case frmRun.rgRunSutra.ItemIndex of
                            0, 1, 2 {5}:
                              begin
                                {$IFDEF SUTRA22}
                                MetFileName := 'sutra22.met';
                                {$ELSE}
                                MetFileName := 'sutra.met';
                                {$ENDIF}
                              end;
//                            2:
//                              begin
//                                MetFileName := 'ExtractFile.met';
//                              end;
//                            3:
//                              begin
//                                MetFileName := 'PrepareFile.met';
//                              end;
//                            4:
//                              begin
//                                MetFileName := 'MainUcodeFile.met';
//                              end;
//                            6:
//                              begin
//                                MetFileName := 'UcodeBatchFile.met';
//                              end;
//                            7:
//                              begin
//                                MetFileName := 'ExportObservations.met';
//                              end;
                            3,4 {8,9}:
                              begin
                                MetFileName := 'UCode.met';
                              end;
                          else Assert(False);
                          end;


                          Template := frmSutra.ProcessTemplate(DLLName,
                            MetFileName, '', nil, TemplateStringList);
                          LastTemplatePath := DllAppDirectory(frmRun.Handle, DLLName);
                          if not DirectoryExists(LastTemplatePath) then
                          begin
                            CreateDirectoryAndParents(LastTemplatePath);
                          end;
//                          GetDllDirectory(DLLName, LastTemplatePath) ;
                          LastTemplatePath := LastTemplatePath + '\' + LastTemplate;
                          try
                          TemplateStringList.SaveToFile(LastTemplatePath);
                          except
                            // do nothing.
                          end;
                      finally
                        begin
                          frmRun.Cursor := crDefault;
                          TemplateStringList.Free;
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

function TfrmRun.GetRoot : String;
var
  ProjectOptions : TProjectOptions;
  DotPosition : integer;
begin
  if edRoot.Text = '' then
  begin
    ProjectOptions := TProjectOptions.Create;
    try
      result := ExtractFileName(ProjectOptions.ProjectName[CurrentModelHandle]);
    finally
      ProjectOptions.Free;
    end;
    DotPosition := Pos('.',result);
    if DotPosition > 0 then
    begin
      result := Copy(result,1,DotPosition-1)
    end;
  end
  else
  begin
    result := edRoot.Text;
  end;
end;

procedure TfrmRun.btnOKClick(Sender: TObject);
var
//  ProjectOptions : TProjectOptions;
  DotPosition : integer;
begin
  SaveDialog1.FileName := GetRoot;

  SaveDialog1.FileName := GetCurrentDir + '\' + SaveDialog1.FileName
    + '.' + SaveDialog1.DefaultExt;

  if SaveDialog1.Execute then
  begin
    frmSutra.rgRunSutra.ItemIndex := rgRunSutra.ItemIndex;
    frmSutra.rgAlert.ItemIndex := rgAlert.ItemIndex;
    frmSutra.cbExternal.Checked := cbExternal.Checked;
    frmSutra.edRunDirectory.Text :=  ExtractFilePath(SaveDialog1.FileName);

    edRoot.Text := ExtractFileName(SaveDialog1.FileName);
    DotPosition := Pos('.',edRoot.Text);
    if DotPosition > 0 then
    begin
      edRoot.Text := Copy(edRoot.Text,1,DotPosition-1)
    end;
    frmSutra.edRoot.Text := edRoot.Text;

    frmSutra.edRunSutra.Text := edSutraPath.Text;

    frmSutra.cbSaveTempFiles.Checked := cbSaveTempFiles.Checked;
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

    frmSutra.rbMemory.Checked := rbMemory.Checked;
    frmSutra.rbStore.Checked := rbStore.Checked;
    frmSutra.rbRead.Checked := rbRead.Checked;
    frmSutra.rbCompute.Checked := rbCompute.Checked;

    if rbMemory.Checked then
    begin
      PolyhedronChoice := poMemory
    end
    else if rbStore.Checked then
    begin
      PolyhedronChoice := poStoreAll
    end
    else if rbRead.Checked then
    begin
      PolyhedronChoice := poReadFromFile
    end
    else if rbCompute.Checked then
    begin
      PolyhedronChoice := poCompute
    end
    else Assert(False);
  end
  else
  begin
    ModalResult := mrNone;
  end;

end;

procedure TfrmRun.FormCreate(Sender: TObject);
begin
{$IFNDEF UCODE}
  While rgRunSutra.Items.Count > 2 do
  begin
    rgRunSutra.Items.Delete(rgRunSutra.Items.Count-1);
  end;
{$ENDIF}

  PageControlMain.ActivePage := tabFirst;

  rgRunSutra.ItemIndex := frmSutra.rgRunSutra.ItemIndex;
  rgAlert.ItemIndex := frmSutra.rgAlert.ItemIndex;
  cbExternal.Checked := frmSutra.cbExternal.Checked;
  edSutraPathChange(Sender);
  edSutraPath.Text :=  frmSutra.edRunSutra.Text ;
  edRoot.Text := frmSutra.edRoot.Text;

  cbSaveTempFiles.Checked := frmSutra.cbSaveTempFiles.Checked;
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

  rbMemory.Checked := frmSutra.rbMemory.Checked;
  rbStore.Checked := frmSutra.rbStore.Checked;
  rbRead.Checked := frmSutra.rbRead.Checked;
  rbCompute.Checked := frmSutra.rbCompute.Checked;

end;

procedure TfrmRun.btnEditClick(Sender: TObject);
begin
  EditForm;
{  if EditForm then
  begin
    FormCreate(Sender);
  end; }
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
    if FileExists (edSutraPath.Text) then
    begin
      OpenDialog1.FileName := edSutraPath.Text;
    end;
    if OpenDialog1.Execute then
    begin
      edSutraPath.Text := OpenDialog1.FileName;
    end;
  finally
    SetCurrentDir(Directory);
  end;

end;

procedure TfrmRun.EnablePolyhedronChoice;
var
  CurDir : string;
  BminBmaxFile : string;
  PolyhedronFile : string;
  Root : string;
begin
  Root := GetRoot;
  CurDir := GetCurrentDir + '\';
  BminBmaxFile := CurDir + Root +'PolyhedronBox.sut';
  PolyhedronFile := CurDir + Root +'Polyhedron.sut';
  if FileExists(BminBmaxFile) and FileExists(PolyhedronFile) then
  begin
    rbRead.Enabled := True;
{      UseOldNodePositions := not MessageDlg('Have the locations of any of the nodes changed '
      + 'since the node locations were last stored?', mtInformation,
      [mbYes, mbNo], 0) = mrYes; }
  end
  else
  begin
    rbRead.Enabled := False;
//      UseOldNodePositions := False;
  end;
end;


procedure TfrmRun.edRootChange(Sender: TObject);
begin
  EnablePolyhedronChoice;
end;

procedure TfrmRun.btnAllClick(Sender: TObject);
var
  ShouldBeChecked : boolean;
begin
  ShouldBeChecked := Sender = btnAll;
  cbExportNBI.Checked := ShouldBeChecked;
  cbExport8D.Checked := ShouldBeChecked;
  cbExport14B.Checked := ShouldBeChecked;
  cbExport15B.Checked := ShouldBeChecked;
  cbExport17.Checked := ShouldBeChecked;
  cbExport18.Checked := ShouldBeChecked;
  cbExport19.Checked := ShouldBeChecked;
  cbExport20.Checked := ShouldBeChecked;
  cbExport22.Checked := ShouldBeChecked;
  cbExportICS2.Checked := ShouldBeChecked;
  cbExportICS3.Checked := ShouldBeChecked;
end;

procedure TfrmRun.rgRunSutraClick(Sender: TObject);
begin
  gbExport.Enabled := True;
  btnAll.Enabled := True;
  btnNone.Enabled := True;
  case rgRunSutra.ItemIndex of
    0, 1 {8, 9}:
      begin
        SaveDialog1.Filter := 'input files (*.inp)|*.inp|All Files (*.*)|*.*';
        SaveDialog1.DefaultExt := 'inp';
      end;
//    2:
//      begin
//        SaveDialog1.Filter := 'extract files (*.ext)|*.ext|All Files (*.*)|*.*';
//        SaveDialog1.DefaultExt := 'ext';
//      end;
//    3:
//      begin
//        SaveDialog1.Filter := 'Prepare files (*.pre)|*.pre|All Files (*.*)|*.*';
//        SaveDialog1.DefaultExt := 'pre';
//      end;
//    4:
//      begin
//        SaveDialog1.Filter := 'Main files (*.uma)|*.uma|All Files (*.*)|*.*';
//        SaveDialog1.DefaultExt := 'uma';
//      end;
    2 {5}:
      begin
        SaveDialog1.Filter := 'Template files (*.utf)|*.utf|All Files (*.*)|*.*';
        SaveDialog1.DefaultExt := 'utf';
        btnAllClick(btnAll);
        gbExport.Enabled := False;
        btnAll.Enabled := False;
        btnNone.Enabled := False;
      end;
    3,4:
      begin
        SaveDialog1.Filter := 'UCODE files (*.uma)|*.uma|All Files (*.*)|*.*';
        SaveDialog1.DefaultExt := 'uma';
      end;
//    6:
//      begin
//        SaveDialog1.Filter := 'Batch files (*.bat)|*.bat|All Files (*.*)|*.*';
//        SaveDialog1.DefaultExt := 'bat';
//      end;
//    7:
//      begin
//        SaveDialog1.Filter := 'Observation files (*.uob)|*.uob|All Files (*.*)|*.*';
//        SaveDialog1.DefaultExt := 'uob';
//      end;
  else Assert(False);
  end;
end;

end.

