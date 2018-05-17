unit frmSutraUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ComCtrls, ExtCtrls, ArgusDataEntry, ANE_LayerUnit,
  Buttons, {VersInfo,} verslab;

type
  TTransportType = (ttGeneral, ttEnergy, ttSolute);
  TStateVariableType = (svPressure, svHead);

  TfrmSutra = class(TArgusForm)
    PageControl1: TPageControl;
    pnlBottom: TPanel;
    tabAbout: TTabSheet;
    pnlAuthors: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    tabConfiguration: TTabSheet;
    rbGeneral: TRadioButton;
    rbSpecific: TRadioButton;
    Label13: TLabel;
    rgMeshType: TRadioGroup;
    tabHeadings: TTabSheet;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    comboSIMULA: TComboBox;
    edTitle1: TEdit;
    edTitle2: TEdit;
    tabModes: TTabSheet;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    lblGNUP_Desc: TLabel;
    lblGNUU_Desc: TLabel;
    adeFracUpstreamWeight: TArgusDataEntry;
    adeGNUP: TArgusDataEntry;
    adeGNUU: TArgusDataEntry;
    comboIUNSAT: TComboBox;
    comboISSFLO: TComboBox;
    comboISSTRA: TComboBox;
    comboIREAD: TComboBox;
    tabTemporal: TTabSheet;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    lblNPCYC_Desc: TLabel;
    lblNUCYC_Desc: TLabel;
    Label45: TLabel;
    adeITMAX: TArgusDataEntry;
    adeDELT: TArgusDataEntry;
    adeTMAX: TArgusDataEntry;
    adeITCYC: TArgusDataEntry;
    adeDTMULT: TArgusDataEntry;
    adeDTMAX: TArgusDataEntry;
    adeNPCYC: TArgusDataEntry;
    adeNUCYC: TArgusDataEntry;
    adeTSART: TArgusDataEntry;
    tabOutput: TTabSheet;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    adeNPRINT: TArgusDataEntry;
    adeNOBCYC: TArgusDataEntry;
    adeISTORE: TArgusDataEntry;
    cbKNODAL: TCheckBox;
    cbKELMNT: TCheckBox;
    cbKINCID: TCheckBox;
    cbKVEL: TCheckBox;
    cbKBUDG: TCheckBox;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    tabIteration: TTabSheet;
    GroupBox18: TGroupBox;
    rbNonIterative: TRadioButton;
    rbIterative: TRadioButton;
    adeITRMAX: TArgusDataEntry;
    adeRPMAX: TArgusDataEntry;
    adeRUMAX: TArgusDataEntry;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    lblRPMAX_Desc: TLabel;
    Label62: TLabel;
    TabFluidProp: TTabSheet;
    GroupBox19: TGroupBox;
    GroupBox20: TGroupBox;
    GroupBox21: TGroupBox;
    adeCOMPFL: TArgusDataEntry;
    adeCW: TArgusDataEntry;
    adeSIGMAW: TArgusDataEntry;
    adeRHOW0: TArgusDataEntry;
    adeURHOW0: TArgusDataEntry;
    adeDRWDU: TArgusDataEntry;
    adeVISC0: TArgusDataEntry;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    lblRHOW0_Desc: TLabel;
    lblURHOW0_Desc: TLabel;
    lblDRWDU_Desc: TLabel;
    Label76: TLabel;
    lblVISC0_Desc: TLabel;
    tabMatrixAdsorption: TTabSheet;
    GroupBox22: TGroupBox;
    GroupBox23: TGroupBox;
    adeCOMPMA: TArgusDataEntry;
    adeCS: TArgusDataEntry;
    adeSIGMAS: TArgusDataEntry;
    adeRHOS: TArgusDataEntry;
    adeCHI1: TArgusDataEntry;
    adeCHI2: TArgusDataEntry;
    comboADSMOD: TComboBox;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    lblCHI1: TLabel;
    lblCHI2: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    lblCHI1Desc: TLabel;
    lblCHI2Desc: TLabel;
    tabProdGravity: TTabSheet;
    gbEnergySoluteProduction: TGroupBox;
    GroupBox25: TGroupBox;
    adePRODF0: TArgusDataEntry;
    adePRODS0: TArgusDataEntry;
    adePRODF1: TArgusDataEntry;
    adePRODS1: TArgusDataEntry;
    adeGRAVX: TArgusDataEntry;
    adeGRAVY: TArgusDataEntry;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    GroupBox26: TGroupBox;
    rbUserSpecifiedThickness: TRadioButton;
    rbCylindrical: TRadioButton;
    GroupBox27: TGroupBox;
    rbSoluteVarDens: TRadioButton;
    rbSoluteConstDens: TRadioButton;
    rbEnergy: TRadioButton;
    GroupBox28: TGroupBox;
    rbSat: TRadioButton;
    rbSatUnsat: TRadioButton;
    GroupBox29: TGroupBox;
    rbAreal: TRadioButton;
    rbCrossSection: TRadioButton;
    Label17: TLabel;
    lblVersion: TLabel;
    tabProblem: TTabSheet;
    reProblem: TRichEdit;
    Label83: TLabel;
    OpenDialog1: TOpenDialog;
    btnBrowse: TBitBtn;
    tabAdvancedOptions: TTabSheet;
    btnOpenVal: TBitBtn;
    btnSaveVal: TBitBtn;
    SaveDialog1: TSaveDialog;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    tabPrivate: TTabSheet;
    rgRunSutra: TRadioGroup;
    rgAlert: TRadioGroup;
    cbExternal: TCheckBox;
    adeNTOBS: TArgusDataEntry;
    Label84: TLabel;
    Label89: TLabel;
    edRunSutra: TEdit;
    VersionLabel1: TVersionLabel;
    procedure rbGeneralClick(Sender: TObject);
    procedure rbArealClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure rbSoluteVarDensClick(Sender: TObject);
    procedure rbSatUnsatClick(Sender: TObject);
    procedure comboISSTRAChange(Sender: TObject);
    procedure adeNPCYCExit(Sender: TObject);
    procedure adeNUCYCExit(Sender: TObject);
    procedure rbIterativeClick(Sender: TObject);
    procedure comboADSMODChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenValClick(Sender: TObject);
    procedure btnSaveValClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure rbUserSpecifiedThicknessClick(Sender: TObject);
    procedure rgMeshTypeClick(Sender: TObject);
    procedure comboISSFLOChange(Sender: TObject);
  private
    procedure SetISSTRA_Items;
    procedure SetlblGNUP_Desc_Caption;
    procedure SetlblGNUU_Desc_Caption;
    procedure SetlblNUCYC_Desc_Caption;
    procedure SetgbEnergySoluteProduction_Caption;
    procedure SetlblNPCYC_Desc_Caption;
    procedure SetcbKELMNT_Caption;
    procedure SetcbKBUDG_Caption;
    procedure SetlblRPMAX_Desc_Caption;
    procedure SetlblRHOW0_Desc_Caption;
    procedure SetlblURHOW0_Desc_Caption;
    procedure SetlblDRWDU_Desc_Caption;
    procedure SetlblVISC0_Desc_Caption;
    procedure SetPressureHeadCaptions;
    procedure SetSoluteHeatCaptions;
    procedure EnableTemporalControls;
    { Private declarations }
  public
    { Public declarations }
    SutraLayerStructure : TLayerStructure;
    OldModel : boolean;
    procedure LoadSutraForm(UnreadData: TStringlist; DataToRead: string;
      var VersionInString: string);
    procedure ModelComponentName(AStringList: TStringList); override;
    procedure ReadValFile(var VersionInString: string; Path: string);
    function StateVariableType: TStateVariableType;
    function TransportType : TTransportType;
    procedure AddOrRemoveLayers;
    procedure SetUnsaturatedExpressions;
    procedure SetPressureHeadExpressions;
    procedure SetSoluteEnergyExpressions;
    procedure SetThicknessExpressions;
  end;

var
  frmSutra: TfrmSutra;

implementation

{$R *.DFM}

uses UtilityFunctions, GlobalVariables, SLFishnetMeshLayout, SLThickness,
  SLUnsaturated, SLSutraMesh, SLEnergySoluteSources, SLSourcesOfFluid;


procedure TfrmSutra.SetThicknessExpressions;
begin
  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTHICKParam, TTHICKParam.ANE_ParamName, True);


end;

procedure TfrmSutra.SetPressureHeadExpressions;
begin
  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCParam, TPBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMAXParam, TPMAXParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMINParam, TPMINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLEXParam, TANGLEXParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecHeadPresParam,
     TTimeDepSpecHeadPresParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.SetSoluteEnergyExpressions;
begin
  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUBCParam, TUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TQUINParam, TQUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepEnergySoluteSourceParam,
     TTimeDepEnergySoluteSourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecConcTempParam,
     TTimeDepSpecConcTempParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUVECParam, TUVECParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSoluteEnergySourcesLayer, TResultantSoluteEnergySourceParam,
     TResultantSoluteEnergySourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TFluidSourcesLayer, TQINUINParam, TQINUINParam.ANE_ParamName, True);

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.SetUnsaturatedExpressions;
begin
  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TNREGParam, TNREGParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TLREGParam, TLREGParam.ANE_ParamName, True);

{  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True); }

  SutraLayerStructure.SetAllParamUnits;
end;


procedure TfrmSutra.AddOrRemoveLayers;
begin
  SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TFishnetMeshLayout,
    rbGeneral.Checked or (rbSpecific.Checked and (rgMeshType.ItemIndex = 0)));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TThicknessLayer,
    rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TUnsaturatedLayer,
    rbGeneral.Checked or
      (rbSpecific.Checked and rbCrossSection.Checked and rbSatUnsat.Checked));

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.rbGeneralClick(Sender: TObject);
begin
  inherited;
  rbAreal.Enabled := rbSpecific.Checked;
  rbCrossSection.Enabled := rbSpecific.Checked;
  rbSat.Enabled := rbSpecific.Checked;
  rbSoluteConstDens.Enabled := rbSpecific.Checked;
  rbUserSpecifiedThickness.Enabled := rbSpecific.Checked;
  adeCW.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeCS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeSIGMAS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adePRODF1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;
  adePRODS1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;
  rbArealClick(Sender);

  AddOrRemoveLayers;
  SetUnsaturatedExpressions;
  SetPressureHeadExpressions;
  SetSoluteEnergyExpressions;
  SetThicknessExpressions;

  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
end;

procedure TfrmSutra.rbArealClick(Sender: TObject);
begin
  inherited;
  rbSatUnsat.Enabled := rbSpecific.Checked and rbCrossSection.Checked;
  rbSoluteVarDens.Enabled := rbSpecific.Checked and rbCrossSection.Checked;
  rbEnergy.Enabled := rbSpecific.Checked and rbCrossSection.Checked;
  rbCylindrical.Enabled := rbSpecific.Checked and rbCrossSection.Checked;

  if rbSatUnsat.Checked and not rbSatUnsat.Enabled then
  begin
    rbSat.Checked := True;
  end;

  if rbSoluteVarDens.Checked and not rbSoluteVarDens.Enabled then
  begin
    rbSoluteConstDens.Checked := True;
  end;

  if rbEnergy.Checked and not rbEnergy.Enabled then
  begin
    rbSoluteConstDens.Checked := True;
  end;

  if rbCylindrical.Checked and not rbCylindrical.Enabled then
  begin
    rbUserSpecifiedThickness.Checked := True;
  end;

  AddOrRemoveLayers;
end;

procedure TfrmSutra.FormCreate(Sender: TObject);
begin
  inherited;
//  VersionInfo1.FileName := DLLName;
//  lblVersion.Caption := VersionInfo1.FileVersion;

  comboSIMULA.ItemIndex := 1;
  OldModel := False;

  EnableTemporalControls;

  PageControl1.ActivePage := tabConfiguration;
  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;

  comboIUNSAT.ItemIndex := 0;
  comboISSFLO.ItemIndex := 1;
  comboISSTRA.ItemIndex := 1;
  comboIREAD.ItemIndex := 0;
  comboADSMOD.ItemIndex := 0;
  EnableTemporalControls;

end;

procedure TfrmSutra.rbSoluteVarDensClick(Sender: TObject);
begin
  inherited;
  if rbEnergy.Checked then
  begin
    comboSIMULA.ItemIndex := 0;
  end
  else
  begin
    comboSIMULA.ItemIndex := 0;
  end;
  adeCW.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeCS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeSIGMAS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adePRODF1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;
  adePRODS1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;
  AddOrRemoveLayers;
  SetPressureHeadExpressions;
  SetSoluteEnergyExpressions;

  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
end;

procedure TfrmSutra.rbSatUnsatClick(Sender: TObject);
begin
  inherited;
  comboIUNSAT.Enabled := rbSatUnsat.Checked;
  if not comboIUNSAT.Enabled then
  begin
    comboIUNSAT.ItemIndex := 0;
  end;
  AddOrRemoveLayers;
  SetUnsaturatedExpressions;
end;

procedure TfrmSutra.EnableTemporalControls;
begin
  inherited;
  tabTemporal.TabVisible := (comboISSFLO.ItemIndex = 0) or (comboISSTRA.ItemIndex = 0);
end;


procedure TfrmSutra.comboISSTRAChange(Sender: TObject);
begin
  inherited;
  if comboISSTRA.ItemIndex = 0 then
  begin
    comboISSFLO.ItemIndex := 0;
  end;
  EnableTemporalControls;
end;

procedure TfrmSutra.adeNPCYCExit(Sender: TObject);
begin
  inherited;
  if adeNPCYC.Text <> '1' then
  begin
    adeNUCYC.Text := '1';
  end;
end;

procedure TfrmSutra.adeNUCYCExit(Sender: TObject);
begin
  inherited;
  if adeNUCYC.Text <> '1' then
  begin
    adeNPCYC.Text := '1';
  end;
end;

procedure TfrmSutra.rbIterativeClick(Sender: TObject);
begin
  inherited;
  adeITRMAX.Enabled := rbIterative.Checked;
  adeRPMAX.Enabled := rbIterative.Checked;
  adeRUMAX.Enabled := rbIterative.Checked;
  if rbNonIterative.Checked then
  begin
    adeITRMAX.Text := '1';
  end;
end;

procedure TfrmSutra.comboADSMODChange(Sender: TObject);
begin
  inherited;
  adeCHI1.Visible := (comboADSMOD.ItemIndex > 0);
  lblCHI1.Visible := adeCHI1.Visible;
  lblCHI1Desc.Visible := adeCHI1.Visible;

  adeCHI2.Visible := (comboADSMOD.ItemIndex > 1);
  lblCHI2.Visible := adeCHI2.Visible;
  lblCHI2Desc.Visible := adeCHI2.Visible;
end;

procedure TfrmSutra.ReadValFile(
   var VersionInString: string; Path : string);
var
  UnreadData: TStringlist;
  AStringList : TStringList;
  Developer : string;
begin
  // called by GProjectNewSutra
  AStringList := TStringList.Create;
  UnreadData := TStringList.Create;
  try
    begin
      AStringList.LoadFromFile(Path);

      LoadSutraForm(UnreadData, AStringList.Text , VersionInString );

      SutraLayerStructure.FreeByStatus(sDeleted);
      SutraLayerStructure.SetStatus(sNormal);
      SutraLayerStructure.UpdateIndicies;
      SutraLayerStructure.UpdateOldIndicies;

//      AssociateUnits;
//      AssociateTimes;
      reProblem.Lines.Assign(UnreadData);
      If reProblem.Lines.Count > 0 then
      begin
        Beep;
        Developer := PIEDeveloper;
        if Developer <> '' then
        begin
          Developer := ' (' + Developer + ')';
        end;
        MessageDlg('Unable to read some of the information in ' + Path
          + 'Contact PIE developer ' + Developer + ' for assistance.',
          mtWarning, [mbOK], 0);
      end;

    end;
  finally
    begin
      AStringList.Free;
      UnreadData.Free;
    end;
  end;

end;

procedure TfrmSutra.LoadSutraForm(UnreadData: TStringlist;
  DataToRead: string; var VersionInString: string);
begin
  // called by btnOpenValClick
  // called by ReadValFile
  // called by GLoadForm in Project Functions
  // in cases where ArgusDataEntries check maximum values, temporarily
  // disable the checks.
{  adeModpathBeginPeriod.CheckMax := False;
  adeModpathBeginStep.CheckMax := False;
  adeModpathEndPeriod.CheckMax := False;
  adeModpathEndStep.CheckMax := False;
  adeModpathEndStep.CheckMin := False;  }

  LoadForm(UnreadData, DataToRead, VersionInString, lblVersion);

  // in cases where ArgusDataEntries check maximum values,
  // re-enable the checks.
{  adeModpathBeginPeriod.CheckMax := True;
  adeModpathBeginStep.CheckMax := True;
  adeModpathEndPeriod.CheckMax := True;
  adeModpathEndStep.CheckMax := True;
  adeModpathEndStep.CheckMin := True;

  // make sure that the grid titles are correct
  InitializeGrids;   }

end;

procedure TfrmSutra.ModelComponentName(AStringList: TStringList);
begin
  AStringList.Add('edSutraPath');
end;

procedure TfrmSutra.btnBrowseClick(Sender: TObject);
begin
  inherited;
  OpenDialog1.Filter := 'Executables (*.exe)|*.exe|Batch Files (*.bat)|*.bat|All Files (*.*)|*.*';
  OpenDialog1.FileName := edRunSutra.Text;
  if OpenDialog1.Execute then
  begin
    edRunSutra.Text := ExtractShortPathName(OpenDialog1.FileName);
  end;
end;

procedure TfrmSutra.btnOpenValClick(Sender: TObject);
Var
  AStringList, UnreadData : TStringList;
  Path : string;
  VersionInString : string;
  Developer : string;
begin
  inherited;
  // first get the directory
  if not GetDllDirectory(DLLName, Path)
  then
    begin
      // show an error message in the event of an error
      Beep;
      MessageDlg('Unable to find ' + DLLName, mtError, [mbOK], 0);
    end
  else
    begin
      // set the default path name
      Path := Path + '\sutra.val';
      OpenDialog1.FileName := Path;
      // show the open file dialog box and get response.
      OpenDialog1.Filter := 'Val files (*.val)|*.val|All Files (*.*)|*.*';
      if OpenDialog1.Execute then
      begin
        // create two stringlists
        // AStringList will hold the data in the val file
        AStringList := TStringList.Create;
        // UnreadData will hold data that can't be read from the val file
        UnreadData := TStringlist.Create;
        try
          begin
            // read the val file from disk.
            AStringList.LoadFromFile(OpenDialog1.FileName);

            // test if this is an old val file. If so, show an error message.
            if Pos('@TITLE1@', AStringList.Text) <> 0 then
            begin
              BEEP;
              MessageDlg('This val file was created for a previous version of '
                + 'the MODFLOW/MOC3D PIE. It can not be read by the current '
                + 'version.', mtWarning, [mbOK], 0);
            end
            else
            begin
              // read the data from the file
              LoadSutraForm(UnreadData, AStringList.Text , VersionInString );

{              // create lists of geologic units and parameters
              AssociateUnits;
              // Associate lists of time-related parameters with
              // sgTime grid.
              AssociateTimes;   }
              // put any unread data in reProblem
              reProblem.Lines.Assign(UnreadData);
              // if there are any probles show a warning message
              If reProblem.Lines.Count > 0 then
              begin
                Beep;
                Developer := PIEDeveloper;
                if Developer <> '' then
                begin
                  Developer := ' (' + Developer + ')';
                end;
                MessageDlg('Unable to read some of the information in this model. '
                  + 'Contact PIE developer ' + Developer + ' for assistance.',
                  mtWarning, [mbOK], 0);
              end;
            end;

          end;
        finally
          begin
            // get rid of string lists.
            AStringList.Free;
            UnreadData.Free;
          end;
        end;
      end;
    end;

end;

procedure TfrmSutra.btnSaveValClick(Sender: TObject);
Var
  AStringList : TStringList;
  Path : string;
begin
  inherited;
  // save val file
  // first get the directory
  if not GetDllDirectory(DLLName, Path)
  then
    begin
      // show an error message in the event of an error
      Beep;
      MessageDlg('Unable to find ' + DLLName, mtError, [mbOK], 0);
    end
  else
    begin
      // set the default path name
      Path := Path + '\sutra.val';
      SaveDialog1.FileName := Path;
      // show save dialog box and get response
      if SaveDialog1.Execute then
      begin
        // create a stringList
        AStringList := TStringList.Create;
        try
          begin
            // Set the stringlist text using the data in the frmMODFLOW
            // dialog box.
            AStringList.Text := FormToString(lblVersion,
              IgnoreList, rsDeveloper);
            // save the stringlist to a file.
            AStringList.SaveToFile(SaveDialog1.FileName);
          end;
        finally
          begin
            // get rid of the stringlist.
            AStringList.Free;
          end;
        end;
      end;
    end;

end;

procedure TfrmSutra.FormDestroy(Sender: TObject);
begin
  SutraLayerStructure.Free;
  inherited;
end;

function TfrmSutra.TransportType: TTransportType;
begin
  if rbGeneral.Checked then
  begin
    if OldModel then
    begin
      result := ttGeneral;
    end
    else if comboSIMULA.ItemIndex = 0 then
    begin
      result := ttEnergy;
    end
    else
    begin
      result := ttSolute;
    end;
  end
  else if rbEnergy.Checked then
  begin
    result := ttEnergy;
  end
  else
  begin
    result := ttSolute;
  end;

end;

function TfrmSutra.StateVariableType: TStateVariableType;
begin
  if rbSpecific.Checked and rbSoluteConstDens.Checked then
  begin
    result := svHead;
  end
  else
  begin
    result := svPressure;
  end;
end;

procedure TfrmSutra.rbUserSpecifiedThicknessClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveLayers;
  SetThicknessExpressions;
end;

procedure TfrmSutra.rgMeshTypeClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveLayers;
end;

procedure TfrmSutra.SetISSTRA_Items;
var
  CurrentIndex : integer;
begin
  inherited;
  CurrentIndex := comboISSTRA.ItemIndex;
  case TransportType of
    ttGeneral:
      begin
        comboISSTRA.Items[0] := 'Transient energy or solute transport';
        comboISSTRA.Items[1] := 'Steady-state energy or solute transport';
      end;
    ttEnergy:
      begin
        comboISSTRA.Items[0] := 'Transient energy transport';
        comboISSTRA.Items[1] := 'Steady-state energy transport';
      end;
    ttSolute:
      begin
        comboISSTRA.Items[0] := 'Transient solute transport';
        comboISSTRA.Items[1] := 'Steady-state solute transport';
      end;
  else
      begin
        Assert(False);
      end;
  end;
  comboISSTRA.ItemIndex := CurrentIndex;
end;

procedure TfrmSutra.SetlblGNUP_Desc_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        lblGNUP_Desc.Caption := 'Pressure boundary-condition factor';
      end;
    svHead:
      begin
        lblGNUP_Desc.Caption := 'Hydraulic Head boundary-condition factor';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblGNUU_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblGNUU_Desc.Caption := 'Conc or Temp boundary-condition factor';
      end;
    ttEnergy:
      begin
        lblGNUU_Desc.Caption := 'Temperature boundary-condition factor';
      end;
    ttSolute:
      begin
        lblGNUU_Desc.Caption := 'Concentration boundary-condition factor';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblNPCYC_Desc_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        lblNPCYC_Desc.Caption := 'Number of time steps in Pressure solution cycle';
      end;
    svHead:
      begin
        lblNPCYC_Desc.Caption := 'Number of time steps in Hydraulic Head solution cycle';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblNUCYC_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblNUCYC_Desc.Caption := 'Number of time steps in Conc or Temp solution cycle';
      end;
    ttEnergy:
      begin
        lblNUCYC_Desc.Caption := 'Number of time steps in Temperature solution cycle';
      end;
    ttSolute:
      begin
        lblNUCYC_Desc.Caption := 'Number of time steps in Concentration solution cycle';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetgbEnergySoluteProduction_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        gbEnergySoluteProduction.Caption := 'Production of Energy or Solute -> dataset 12';
      end;
    ttEnergy:
      begin
        gbEnergySoluteProduction.Caption := 'Production of Energy -> dataset 12';
      end;
    ttSolute:
      begin
        gbEnergySoluteProduction.Caption := 'Production of Solute -> dataset 12';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetcbKELMNT_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        cbKELMNT.Caption := 'Print element permeabilities and dispersivities';
      end;
    svHead:
      begin
        cbKELMNT.Caption := 'Print element hydraulic conductivities and dispersivities';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetcbKBUDG_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        cbKBUDG.Caption := 'Print fluid mass and energy or solute budgets';
      end;
    ttEnergy:
      begin
        cbKBUDG.Caption := 'Print fluid mass and energy budgets';
      end;
    ttSolute:
      begin
        cbKBUDG.Caption := 'Print fluid mass and solute budgets';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblRPMAX_Desc_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        lblRPMAX_Desc.Caption := 'Absolute iteration convergence criterion for '
         + Chr(10) + Chr(13) + 'Pressure solution';
      end;
    svHead:
      begin
        lblRPMAX_Desc.Caption := 'Absolute iteration convergence criterion for '
         + Chr(10) + Chr(13) + 'Hydraulic head solution';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblRHOW0_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblRHOW0_Desc.Caption := 'Density of fluid at base Conc or Temp';
      end;
    ttEnergy:
      begin
        lblRHOW0_Desc.Caption := 'Density of fluid at base Temperature';
      end;
    ttSolute:
      begin
        lblRHOW0_Desc.Caption := 'Density of fluid at base Concentration';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblURHOW0_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblURHOW0_Desc.Caption := 'Base value of Conc or Temp';
      end;
    ttEnergy:
      begin
        lblURHOW0_Desc.Caption := 'Base value of Temperature';
      end;
    ttSolute:
      begin
        lblURHOW0_Desc.Caption := 'Base value of Concentration';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblDRWDU_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblDRWDU_Desc.Caption := 'Fluid coefficient of density change with Conc or Temp';
      end;
    ttEnergy:
      begin
        lblDRWDU_Desc.Caption := 'Fluid coefficient of density change with Temperature';
      end;
    ttSolute:
      begin
        lblDRWDU_Desc.Caption := 'Fluid coefficient of density change with Concentration';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetlblVISC0_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblVISC0_Desc.Caption := 'For Solute transport: Fluid Viscosity.'
          + Chr(10) + Chr(13) + 'For Energy transport: Viscosity units scaling factor.';
      end;
    ttEnergy:
      begin
        lblVISC0_Desc.Caption := 'Viscosity units scaling factor';
      end;
    ttSolute:
      begin
        lblVISC0_Desc.Caption := 'Fluid Viscosity';
      end;
  else
      begin
        Assert(False);
      end;
  end;
end;

procedure TfrmSutra.SetSoluteHeatCaptions;
begin
  SetISSTRA_Items;
  SetlblGNUU_Desc_Caption;
  SetlblNUCYC_Desc_Caption;
  SetgbEnergySoluteProduction_Caption;
  SetcbKBUDG_Caption;
  SetlblRHOW0_Desc_Caption;
  SetlblURHOW0_Desc_Caption;
  SetlblDRWDU_Desc_Caption;
  SetlblVISC0_Desc_Caption;
end;

procedure TfrmSutra.SetPressureHeadCaptions;
begin
  SetlblGNUP_Desc_Caption;
  SetlblNPCYC_Desc_Caption;
  SetcbKELMNT_Caption;
  SetlblRPMAX_Desc_Caption;
end;

procedure TfrmSutra.comboISSFLOChange(Sender: TObject);
begin
  inherited;
  EnableTemporalControls;
end;

end.
