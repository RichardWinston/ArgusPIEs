unit frmSutraUnit;

interface

{$IFDEF SUTRA22}
  {$DEFINE SUTRA22Input}
{$ENDIF}
{$IFDEF SutraIce}
  {$DEFINE SUTRA22Input}
{$ENDIF}


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ComCtrls, ExtCtrls, ArgusDataEntry, ANE_LayerUnit,
  Buttons, Grids, AnePIE, VirtualMeshUnit, VersInfo, RealListUnit, Contnrs,
  ASLink, Strset, DefaultValueFrame, DataGrid, addbtn95,
  Get3DElementValue, framFilePathUnit, siComboBox, frmParameterValuesUnit,
  Menus, RbwDataGrid2, RbwDataGrid, frmSutraPriorEquationEditorUnit,
  FusedTrctrls, Mask, JvExMask, JvToolEdit, CheckLst,
  RbwDataGrid4, JvPageList, JvExControls, RbwParser, ImgList, RbwCheckTreeView,
  frameRegionParamsUnit;

type
  TFactorColumns = (fcN, fcName, fcLayer);

  TTransportType = (ttGeneral, ttEnergy, ttSolute);
  TStateVariableType = (svPressure, svHead);
  TGeologyHeaders = (ghNumber, ghName, ghDiscretization, ghGrowthRate, ghGrowthType);
  TSutraDimensionality = (sd2D, sd3D);
  TBoundaryTypeIndex = (btiNone, btiFluidSource, btiSoluteSource,
    btiSpecPressure, btiSpecConc, btiObservations);
  TObjectTypeIndex = (otiNone, otiPoints, otiLines,
    otiVerticalSheets, otiSlantedSheets, otiSolids);
  TBoundaryType = (btSourcesOfFluid, btSourcesOfSolute, btSpecPres, btSpecConc,
    btObservation);
  TUcodeColumns = (ucN, ucParameter, ucEstimate, ucInitialValue, ucMin, ucMax,
    ucPerturbation, ucLog, ucConstrain, ucLowerConstraint, ucUpperConstraint,
    ucExpression, ucDescription);

  TPriorInfoColumns = (picName, picUseEquation, picEquation,
    picValue, picStatistic, picStatFlag);

  TPaneOrder = (poAbout, poModelConfig, poHeadings, poStructZ, po3D,
    poModes, poTemporal, poInitial, poOutput, poIterations, poSolver,
    poFluidProp, poSolidMatrix, poProduction, poGuiConfig, poInverse,
    poSutraIce, poFreezing, poProblem);

  TFunctionColumn = (fcRegionNumber, fcUnsaturated, fcPermeability, fcFreezing);

//  TUcodeDerivedParameterColumns = (ucdpN, ucdpDerivedParameterName,
//    ucdpDerivedParameterEquation, ucdpDescription);

  TAllowableObjectTypes = Set of byte;

//  TLayerRecord = record
//    LayerName: string;
//    LayerClass: T_ANE_MapsLayerClass;
//  end;
//  PLayerRecord = ^TLayerRecord;

  TSubConstant = class(TRealVariable)
    function Decompile: string; override;
  end;

  TArgusFactorRecord = record
    Name: string;
    LayerHandle : ANE_PTR;
    Value: double;
    ValueHasBeenSet: boolean;
    Variable: TSubConstant;
  end;

  TArgusFactors = array of TArgusFactorRecord;

  TUcodeParamRecord = record
    Name: string;
    Formula: string;
    DecompiledFormula: string;
    VariablesUsed: array of string;
    DependsOnXY: boolean;
    Expression: TExpression;
  end;

  TUcodeParameters = array of TUcodeParamRecord;

  TfrmSutra = class(TArgusForm)
    pgcontrlMain: TPageControl;
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
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    tabConfiguration: TTabSheet;
    rbGeneral: TRadioButton;
    rbSpecific: TRadioButton;
    tabHeadings: TTabSheet;
    tabModes: TTabSheet;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
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
    comboIREAD: TComboBox;
    tabTemporal: TTabSheet;
    GroupBox8: TGroupBox;
    GroupBox12: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    lblNPCYC_Desc: TLabel;
    lblNUCYC_Desc: TLabel;
    adeNPCYC: TArgusDataEntry;
    adeNUCYC: TArgusDataEntry;
    tabOutput: TTabSheet;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    adeISTORE: TArgusDataEntry;
    cbCNODAL: TCheckBox;
    cbCELMNT: TCheckBox;
    cbCINCID: TCheckBox;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label52: TLabel;
    Label55: TLabel;
    tabIterationsForNonLinearity: TTabSheet;
    GroupBox18: TGroupBox;
    rbNonIterative: TRadioButton;
    rbIterative: TRadioButton;
    adeITRMAX: TArgusDataEntry;
    adeRPMAX: TArgusDataEntry;
    adeRUMAX: TArgusDataEntry;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    lblITRMAX: TLabel;
    lblRPMAX_Desc: TLabel;
    lblRUMAX_Desc: TLabel;
    tabFluidProp: TTabSheet;
    GroupBox19: TGroupBox;
    gbBaseProperties: TGroupBox;
    gbDensityDependence: TGroupBox;
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
    lblCOMPFLCaption: TLabel;
    lblCW: TLabel;
    lblSigmawDesc: TLabel;
    lblRHOW0_Desc: TLabel;
    lblURHOW0_Desc: TLabel;
    lblDRWDU_Desc: TLabel;
    lblVISC0_Desc: TLabel;
    tabSolidMatrixAdsorption: TTabSheet;
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
    lblCOMPMACaption: TLabel;
    lblCS: TLabel;
    lblSIGMAS: TLabel;
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
    lblGRAVXCaption: TLabel;
    lblGRAVYCaption: TLabel;
    GroupBox26: TGroupBox;
    rbUserSpecifiedThickness: TRadioButton;
    rbCylindrical: TRadioButton;
    GroupBox27: TGroupBox;
    rbSoluteVarDens: TRadioButton;
    rbSoluteConstDens: TRadioButton;
    rbEnergy: TRadioButton;
    gbOrientation: TGroupBox;
    rbAreal: TRadioButton;
    rbCrossSection: TRadioButton;
    Label17: TLabel;
    lblVersion: TLabel;
    tabProblem: TTabSheet;
    reProblem: TRichEdit;
    OpenDialog1: TOpenDialog;
    tabInitialConditionControls: TTabSheet;
    SaveDialog1: TSaveDialog;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    tabPrivate: TTabSheet;
    rgRunSutra: TRadioGroup;
    rgAlert: TRadioGroup;
    cbExternal: TCheckBox;
    tabSolverControls: TTabSheet;
    rgPressureSolverNew: TRadioGroup;
    rgTransportSolver: TRadioGroup;
    Label26: TLabel;
    Label43: TLabel;
    Label61: TLabel;
    Label74: TLabel;
    Label77: TLabel;
    Label103: TLabel;
    lblITRMXU_Desc: TLabel;
    lblTOLU_Desc: TLabel;
    adeITRMXP: TArgusDataEntry;
    adeTOLP: TArgusDataEntry;
    adeITRMXU: TArgusDataEntry;
    adeTOLU: TArgusDataEntry;
    cbCVEL: TCheckBox;
    Label50: TLabel;
    Label51: TLabel;
    cbCBUDG: TCheckBox;
    Label112: TLabel;
    Label110: TLabel;
    Label54: TLabel;
    adeNPRINT: TArgusDataEntry;
    adeNCOLPR: TArgusDataEntry;
    adeLCOLPR: TArgusDataEntry;
    Label111: TLabel;
    Label109: TLabel;
    Label46: TLabel;
    Label53: TLabel;
    adeNOBCYC: TArgusDataEntry;
    Label56: TLabel;
    lblGRAVZ: TLabel;
    adeGRAVZ: TArgusDataEntry;
    lblGRAVZCaption: TLabel;
    tabStructureInZ: TTabSheet;
    rb3D_va: TRadioButton;
    rb3D_nva: TRadioButton;
    VersionInfo1: TVersionInfo;
    Label116: TLabel;
    ASLink1: TASLink;
    Label117: TLabel;
    ASLink2: TASLink;
    memoDoc: TMemo;
    memoSutraDoc: TMemo;
    Panel3: TPanel;
    Label8: TLabel;
    StrSetDoc1: TStrSet;
    StrSetDoc2: TStrSet;
    rgDimensions: TRadioGroup;
    cbNodeElementNumbers: TCheckBox;
    Label12: TLabel;
    Label84: TLabel;
    GroupBox15: TGroupBox;
    rbFishnet: TRadioButton;
    rbIrregular: TRadioButton;
    sbGeology: TStatusBar;
    btnHelp: TBitBtn;
    rgInitialValues: TRadioGroup;
    edRestartFile: TEdit;
    btnRestartFile: TBitBtn;
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
    Panel5: TPanel;
    Panel2: TPanel;
    btnInsert: TButton;
    btnAdd: TButton;
    btnDelete: TButton;
    Panel1: TPanel;
    Label114: TLabel;
    adeVertDisc: TArgusDataEntry;
    cbUseConstantValues: TCheckBox;
    edRoot: TEdit;
    lblRoot: TLabel;
    Label13: TLabel;
    btnPRODF1: TButton;
    btnPRODS1: TButton;
    gbPolyhedron: TGroupBox;
    rbMemory: TRadioButton95;
    rbStore: TRadioButton95;
    rbRead: TRadioButton95;
    rbCompute: TRadioButton95;
    lblFileVersion: TLabel;
    tabBoundaryConditionControls: TTabSheet;
    cbStartTime: TCheckBox;
    rgInterpolateInitialValues: TRadioGroup;
    OpenDialog2: TOpenDialog;
    Image1: TImage;
    framWarmRestart: TframFilePath;
    Panel6: TPanel;
    lvChoices: TListView;
    edRunDirectory: TEdit;
    GroupBox21: TGroupBox;
    dgBoundaryCountsNew: TDataGrid;
    Label18: TLabel;
    sicomboCSSFLO_and_CSSTRA: TsiComboBox;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    edTitle1: TEdit;
    edTitle2: TEdit;
    memoNotes: TMemo;
    Label14: TLabel;
    Panel7: TPanel;
    Label76: TLabel;
    Panel8: TPanel;
    Label72: TLabel;
    tabSutraGuiConfig: TTabSheet;
    Label83: TLabel;
    edRunSutra: TEdit;
    btnBrowse: TBitBtn;
    GroupBox17: TGroupBox;
    btnOpenVal: TBitBtn;
    btnSaveVal: TBitBtn;
    cbSaveTempFiles: TCheckBox;
    GroupBox28: TGroupBox;
    rbSat: TRadioButton;
    rbSatUnsat: TRadioButton;
    Label19: TLabel;
    cbNPRINT_FirstStep: TCheckBox;
    Label20: TLabel;
    cbSCRN: TCheckBox;
    Label62: TLabel;
    cbCPAUSE: TCheckBox;
    btnParamValuesQuickSet: TButton;
    GroupBox5: TGroupBox;
    FramDMaxHydCond: TFrmDefaultValue;
    FramDMinHydCond: TFrmDefaultValue;
    FramLongDispMax: TFrmDefaultValue;
    FramLongDispMin: TFrmDefaultValue;
    FramTransvDispMax: TFrmDefaultValue;
    FramTransvDispMin: TFrmDefaultValue;
    FramPor: TFrmDefaultValue;
    FramInitTempConc: TFrmDefaultValue;
    FramPermAngleXY: TFrmDefaultValue;
    FramInitPres: TFrmDefaultValue;
    Panel4: TPanel;
    Label123: TLabel;
    adeThickness: TArgusDataEntry;
    btnSetThicknessValue: TButton;
    FramDMidHydCond: TFrmDefaultValue;
    FramPermAngleRotational: TFrmDefaultValue;
    FramPermAngleVertical: TFrmDefaultValue;
    FramLongDispMid: TFrmDefaultValue;
    FramTransvDisp1Mid: TFrmDefaultValue;
    tabInverseModel: TTabSheet;
    pcInverseModel: TPageControl;
    tabRegression: TTabSheet;
    tabParameters: TTabSheet;
    sbMain: TStatusBar;
    tabPriorInformation: TTabSheet;
    dgPriorEquations: TRbwDataGrid2;
    Panel10: TPanel;
    adePriorInfoEquationCount: TArgusDataEntry;
    lblPriorInfoEquationCount: TLabel;
    btnDeletePriorInformation: TButton;
    edExtension: TEdit;
    tabControl: TTabSheet;
    GroupBox3: TGroupBox;
    cbIrreg: TCheckBox;
    sgGeology: TRbwDataGrid2;
    edModelName: TEdit;
    lblModelName: TLabel;
    rgPhase: TFusedRadioGroup;
    cbPerfectData: TCheckBox95;
    Label60: TLabel;
    jvfnUcode: TJvFilenameEdit;
    Label70: TLabel;
    tabInvPrint: TTabSheet;
    rgUcodeOutputOptions: TRadioGroup;
    GroupBox20: TGroupBox;
    cbStartRes: TCheckBox;
    cbIntermedRes: TCheckBox;
    cbFinalRes: TCheckBox;
    GroupBox24: TGroupBox;
    comboStartSens: TComboBox;
    Label71: TLabel;
    Label85: TLabel;
    comboIntermedSens: TComboBox;
    Label86: TLabel;
    comboFinalSens: TComboBox;
    cbDataExchange: TCheckBox95;
    GroupBox29: TGroupBox;
    adeUcodeTolerance: TArgusDataEntry;
    Label27: TLabel;
    Label44: TLabel;
    adeUcodeSOSC: TArgusDataEntry;
    adeUcodeMaxiter: TArgusDataEntry;
    Label87: TLabel;
    GroupBox30: TGroupBox;
    adeUcodeMaxChange: TArgusDataEntry;
    Label75: TLabel;
    comboMaxChangeRealm: TComboBox;
    Label73: TLabel;
    GroupBox16: TGroupBox;
    GroupBox31: TGroupBox;
    cbQuasiNewton: TCheckBox;
    adeQNIter: TArgusDataEntry;
    Label90: TLabel;
    adeQNsosr: TArgusDataEntry;
    Label101: TLabel;
    GroupBox32: TGroupBox;
    Label102: TLabel;
    Label106: TLabel;
    cbTrustRegion: TCheckBox;
    adeUcodeMaxStep: TArgusDataEntry;
    adeUcodeConsecMax: TArgusDataEntry;
    edMarkerDelimiter: TEdit;
    Label105: TLabel;
    comboScheduleType: TComboBox;
    jvplTemporal: TJvPageList;
    jvspTimeCycle: TJvStandardPage;
    jvspTimeList: TJvStandardPage;
    GroupBox10: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label37: TLabel;
    lblDELT_Desc: TLabel;
    lblTMAX_Desc: TLabel;
    adeITMAX: TArgusDataEntry;
    adeDELT: TArgusDataEntry;
    adeTMAX: TArgusDataEntry;
    GroupBox11: TGroupBox;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    lblDTMAX_Desc: TLabel;
    adeITCYC: TArgusDataEntry;
    adeDTMULT: TArgusDataEntry;
    adeDTMAX: TArgusDataEntry;
    gbInverse: TGroupBox;
    cbInverse: TCheckBox;
    cbPreserveInverseModelParameters: TCheckBox;
    Label11: TLabel;
    adeObservationTimes: TArgusDataEntry;
    Label104: TLabel;
    ASLink3: TASLink;
    UcodeParser: TRbwParser;
    Label108: TLabel;
    adeNOBLIN: TArgusDataEntry;
    Label113: TLabel;
    Label115: TLabel;
    adeTCMIN: TArgusDataEntry;
    lblTCMIN_Desc: TLabel;
    Label119: TLabel;
    GroupBox9: TGroupBox;
    Label36: TLabel;
    lblTSART_Desc: TLabel;
    adeTSART: TArgusDataEntry;
    rgMannerOfTimeSpecification: TRadioGroup;
    GroupBox33: TGroupBox;
    comboTimeUnits: TComboBox;
    Label120: TLabel;
    GroupBox34: TGroupBox;
    Panel11: TPanel;
    Label107: TLabel;
    rdeNumTimes: TRbwDataEntry;
    rdgTimeSeries: TRbwDataGrid4;
    Panel12: TPanel;
    Panel9: TPanel;
    Label89: TLabel;
    adeParameterCount: TArgusDataEntry;
    btnRefreshNames: TButton;
    btnDeleteParameter: TButton;
    dgEstimate: TRbwDataGrid4;
    Splitter1: TSplitter;
    Panel13: TPanel;
    Panel14: TPanel;
    rdeFactorCount: TArgusDataEntry;
    Label38: TLabel;
    rdeFactorLayerCount: TArgusDataEntry;
    Label39: TLabel;
    btnDeleteFactor: TButton;
    rdgFactorGrid: TRbwDataGrid4;
    tabFreezingUnsat: TTabSheet;
    ilCheckImages: TImageList;
    rctreeBoundaries: TRbwCheckTreeView;
    cbCCORT: TCheckBox;
    cbCPANDS: TCheckBox;
    Label122: TLabel;
    Label124: TLabel;
    adeNBCFPR: TArgusDataEntry;
    Label42: TLabel;
    adeNBCSPR: TArgusDataEntry;
    Label45: TLabel;
    adeNBCPPR: TArgusDataEntry;
    Label118: TLabel;
    adeNBCUPR: TArgusDataEntry;
    Label121: TLabel;
    cbCINACT: TCheckBox;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    rbFreezing: TRadioButton;
    lblNUIREG: TLabel;
    adeNUIREG: TArgusDataEntry;
    Label130: TLabel;
    rdgFreezingEq: TRbwDataGrid4;
    jvplRegionEquations: TJvPageList;
    tabFreezing: TTabSheet;
    lblCI: TLabel;
    adeCI: TArgusDataEntry;
    lblRHOICE: TLabel;
    adeRHOICE: TArgusDataEntry;
    adeHTLAT: TArgusDataEntry;
    lblHTLAT: TLabel;
    adeSIGMAI: TArgusDataEntry;
    lblSIGMAI: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    cbSutra3: TCheckBox;
    procedure rbGeneralClick(Sender: TObject);
    procedure rbArealClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure rbSoluteVarDensClick(Sender: TObject);
    procedure rbSatUnsatClick(Sender: TObject);
    procedure adeNPCYCExit(Sender: TObject);
    procedure adeNUCYCExit(Sender: TObject);
    procedure rbIterativeClick(Sender: TObject);
    procedure comboADSMODChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenValClick(Sender: TObject);
    procedure btnSaveValClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure rbUserSpecifiedThicknessClick(Sender: TObject);
    procedure rgPressureSolverNewClick(Sender: TObject);
    procedure rgTransportSolverClick(Sender: TObject);
    procedure adeVertDiscExit(Sender: TObject);
    procedure sgGeologySetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure adeVertDiscEnter(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure rb3D_nvaClick(Sender: TObject);
    procedure sgGeologyExit(Sender: TObject);
    procedure edRunSutraChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgDimensionsClick(Sender: TObject);
    procedure FixRealsOnExit(Sender: TObject);
    procedure cbNodeElementNumbersClick(Sender: TObject);
    procedure rbFishnetClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbUseConstantValuesClick(Sender: TObject);
    procedure btnRestartFileClick(Sender: TObject);
    procedure rgInitialValuesClick(Sender: TObject);
    procedure dgBoundaryCountsNewSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure pgcontrlMainChange(Sender: TObject);
    procedure btnPRODF1Click(Sender: TObject);
    procedure btnPRODS1Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure cbStartTimeClick(Sender: TObject);
    procedure rgInterpolateInitialValuesClick(Sender: TObject);
    procedure adeDELTExit(Sender: TObject);
    procedure comboIREADChange(Sender: TObject);
    procedure framWarmRestartedFilePathChange(Sender: TObject);
    procedure lvChoicesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvChoicesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure sicomboCSSFLO_and_CSSTRAChange(Sender: TObject);
    procedure lvChoicesKeyPress(Sender: TObject; var Key: Char);
    procedure cbSCRNClick(Sender: TObject);
    procedure btnParamValuesQuickSetClick(Sender: TObject);
    procedure FramTransvDispMinadePropertyChange(Sender: TObject);
    procedure adeThicknessChange(Sender: TObject);
    procedure cbInverseClick(Sender: TObject);
    procedure adeObservationTimesExit(Sender: TObject);
    procedure cbPreserveInverseModelParametersClick(Sender: TObject);
    procedure adeParameterCountExit(Sender: TObject);
    procedure adeParameterCountChange(Sender: TObject);
    procedure dgEstimateDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgEstimateSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnRefreshNamesClick(Sender: TObject);
    procedure btnDeleteParameterClick(Sender: TObject);
    procedure dgPriorEquationsButtonClick(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure adePriorInfoEquationCountChange(Sender: TObject);
    procedure adePriorInfoEquationCountExit(Sender: TObject);
    procedure btnDeletePriorInformationClick(Sender: TObject);
    procedure dgPriorEquationsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure rgRunSutraClick(Sender: TObject);
    procedure dgEstimateSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure edRestartFileChange(Sender: TObject);
    procedure rgDimensionsEnter(Sender: TObject);
    procedure sgGeologySelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure jvfnUcodeChange(Sender: TObject);
    procedure cbQuasiNewtonClick(Sender: TObject);
    procedure cbTrustRegionClick(Sender: TObject);
    procedure dgEstimateBeforeDrawCell(Sender: TObject; ACol,
      ARow: Integer);
    procedure rdeNumTimesExit(Sender: TObject);
    procedure rdgTimeSeriesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure comboScheduleTypeChange(Sender: TObject);
    procedure dgEstimateExit(Sender: TObject);
    procedure dgEstimateRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure dgEstimateButtonClick(Sender: TObject; ACol, ARow: Integer);
    procedure dgPriorEquationsSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure rdgTimeSeriesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure comboTimeUnitsChange(Sender: TObject);
    procedure rgMannerOfTimeSpecificationClick(Sender: TObject);
    procedure adeTSARTChange(Sender: TObject);
    procedure rdeFactorLayerCountExit(Sender: TObject);
    procedure rdeFactorCountExit(Sender: TObject);
    procedure btnDeleteFactorClick(Sender: TObject);
    procedure rdeFactorCountChange(Sender: TObject);
    procedure rdgFactorGridExit(Sender: TObject);
    procedure cbSutraIceClick(Sender: TObject);
    procedure rctreeBoundariesChange(Sender: TObject; Node: TTreeNode);
    procedure rdgFreezingEqSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure adeNUIREGExit(Sender: TObject);
    procedure rdgFreezingEqSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
  private
    ShouldAskY, ShouldAskZ: boolean;
    SimulationTimes: TRealList;
    FCreatingExpressions: boolean;
    FCreatingParameters: boolean;
    FJustStartedProject: boolean;
    FEquationFrameList: TObjectList;
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
    procedure SetGeoGridHeaders;
    procedure InitializeGeoGrid;
    procedure AddOrRemoveParameters;
    procedure EnableGravControls;
    procedure AdjustInitPerm;
    procedure ReadOldFishnet(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure EnableTransportConditionControls;
    procedure SetDefaults;
    procedure EnableComp;
    function GetUnitName(ProposedName: string;
      CurrentRow: integer): string;
    function TestUnitName(ProposedName: string;
      CurrentRow: integer): boolean;
    procedure GetNodeAndElementCounts;
    procedure SetNewProject(AValue: boolean);
    procedure SetTitles;
    procedure SetSourcesOfFluidExpressions;
    procedure UpdateExpressions;
    procedure ReadOldNPCYC(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure ReadOldNUCYC(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure AddOrRemoveMeshParameters;
    procedure SetlblSigmawDesc_Caption;
    procedure UpdateTreeNodeText;
    procedure AddOrRemoveBoundaryParameters(BoundaryType: TBoundaryType;
      IsTop: boolean; UnitIndex: integer; ShouldBePresent: boolean);
    procedure RefreshBoundaries;
    procedure ReadInitialValues(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure ReadRzctNodeBoundaries(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure SetlblRUMAX_Desc_Caption;
    procedure ReadOldCSOLVP(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure SetrgTransportSolver_Caption;
    procedure SetlblITRMXU_Desc_Caption;
    procedure SetlblTOLU_Desc_Caption;
    procedure SetFramInitTempConcLabelCaption;
    procedure SetrgInitialValuesItems;
    procedure SetrgInterpolateInitialValuesItems;
    procedure SetgbDensityDependence_Caption;
    procedure ReadOlddgBoundaryCounts(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure AdjustDropDownWidth(const siCombo: TsiComboBox);
    procedure SetSicomboCSSFLO_and_CSSTRA_Items;
    procedure ReadOldcomboISSFLO(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure ReadOldcomboISSTRA(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure ReadOldcomboSIMULA(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure EnableCREAD;
    procedure EnableConstDensity;
    procedure SetMeshDomainNames;
    procedure EnableSolverControls;
    procedure SetPredefinedInversionParameters;
    procedure UpdateEstimateHints(ARow: integer);
    procedure InitializeEquationEditor(Editor: TfrmSutraPriorEquationEditor);
    procedure SetlblSIGMAS_Caption;
    procedure InitializeTree;
    procedure AddNodeToTree(RowIndex: integer; var ANode: TTreeNode);
    procedure DeleteNodesFromTree(CurrentRow: integer);
    procedure InsertNodeInTree(CurrentRow: integer);
    procedure UncheckAllNodesInTree;
    procedure ReadRzctNodeBoundaries2(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure CreateExpressions;
    procedure ReadOldFileNameFrame(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure SetTimeCaptions;
    procedure SetStartingTime;
    procedure CreateUcodeFactorLayers;
    procedure FixUcodeFactorName(ARow: integer);
    procedure EnableSutraIceTab;
    procedure ReadvstNodeBoundaries2(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    function EnergyUsed: boolean;
    procedure ReadcbSutraIce(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure SetFunctionGridLabels;
        { Private declarations }
  public
    SutraLayerStructure: TLayerStructure;
    OldModel: boolean;
    FNewProject: boolean;

    OldVertDiscretization: string;
    OldGrowthRate: string;
    OldNumberOfUnits: integer;
    dimensions: TSutraDimensionality;
    MorphMesh: T3DMorphMesh;
    VirtualMesh: TVirtual3DMesh;
    BoundaryLayerCount: integer;
    ElementCount: integer; // number of elements on a single layer in a 3d model
    NodeCount: integer; // number of nodes on a single layer in a 3d model
    ElementInterp: TElementInterpComponent;
    frmParameterValues: TfrmParameterValues;
    EnteredControl: TObject;
    ArgusFactors: TArgusFactors;
    UcodeParameters: TUcodeParameters;
    UcodeCompiler : TRbwParser;
    XVar: TRealVariable;
    YVar: TRealVariable;
    SpecialVariables: TList;
    procedure ReleaseMemory; override;
    procedure UpdateVariables(funHandle : ANE_PTR);
    property NewProject: boolean read FNewProject write SetNewProject;
    property JustStartedProject: boolean read FJustStartedProject
      write FJustStartedProject;
    procedure LoadSutraForm(UnreadData: TStringlist; DataToRead: string;
      var VersionInString: string);
    procedure ModelComponentName(AStringList: TStringList); override;
    procedure ReadValFile(var VersionInString: string; Path: string);
    function StateVariableType: TStateVariableType;
    function TransportType: TTransportType;
    procedure AddOrRemoveLayers;
    procedure SetUnsaturatedExpressions;
    procedure SetPressureHeadExpressions;
    procedure SetSoluteEnergyExpressions;
    procedure SetThicknessExpressions;
    function MakeVirtualMesh: boolean;
    function FreeVirtualMesh: boolean;
    function ParsePorosity: boolean;
{$IFDEF SutraIce}
    function ParseCs1: boolean;
{$ENDIF}
    function GetMorphedNodeValue(NodeIndex: integer; Expression: string):
      ANE_DOUBLE;
    function ParseInitialPressure: boolean;
    function ParseInitialConcentration: boolean;
    function ParsePermMaximum: boolean;
    function ParsePermMinimum: boolean;
    function ParsePermMiddle: boolean;
    function ParseFloatExpression(Expression: string): boolean;
    function GetMorphedElementValue(ElementIndex: integer;
      Expression: string): ANE_DOUBLE;
    function GetMorphedElementAngleValue(ElementIndex: integer;
      Expression: string): ANE_DOUBLE;
    function GetLayerCount: Integer;
    function GetXValue(NodeIndex: integer): ANE_DOUBLE;
    function GetYValue(NodeIndex: integer): ANE_DOUBLE;
    function GetZValue(NodeIndex: integer): ANE_DOUBLE;
    function GetN(var MultipleUnits: Boolean): string;
    function GetPIEVersion(AControl: Tcontrol): string;
    procedure AssignHelpFile(FileName: string); virtual;
    function Is3D: boolean;
    function MorphedMesh: boolean;
    function VerticallyAlignedMesh: boolean;
    procedure GetLayerNodeAndElementCounts;
    function SetAllBoundaryCounts: boolean;
    function GetBoundaryCount(ACol, ARow: integer): integer;
    function PieIsEarlier(VersionInString, VersionInPIE: string;
      ShowError: boolean): boolean;
    procedure EnableTemporalControls;
    function ArgusBoundaryLayerUsed(BoundaryType: TBoundaryType;
      UnitIndex: integer; IsTop: boolean): boolean;
    procedure WriteSpecial(ComponentData: TStringList;
      const IgnoreList: TStringlist; OwningComponent: TComponent); override;
    function GetCountOfAUnit(const UnitIndex: integer): Integer;
    { Public declarations }
    function InitializeSimulationTimeSteps: integer;
    function TimeToTimeStep(const Time: double): integer;
    function PriorInfoEquation(const ARow: integer): string;
    function SetColumns(AStringGrid: TStringGrid): boolean; override;
    function ElapsedSimulationTime(const TimeIndex: integer): double;
    function ConvertTime(Input: double): double;
  end;

type
  TMyWinControl = class(TWinControl);

var
  frmSutra: TfrmSutra;
  UseConstantValue: boolean = True;

Const
  KFactorLayer = 'Factor Layer';

procedure GetTimeSeriesItem (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet11B (const refPtX : ANE_DOUBLE_PTR ;
			   const refPtY : ANE_DOUBLE_PTR  ;
			   numParams : ANE_INT16          ;
			   const parameters : ANE_PTR_PTR ;
			   funHandle : ANE_PTR            ;
			   reply : ANE_PTR		  ); cdecl;

implementation

{$R *.DFM}

uses FileCtrl, UtilityFunctions, GlobalVariables, SLMorphLayer, SLObservation,
  SLGroupLayers, SLPorosity,
  SLPermeability, SLDispersivity, SLUnsaturated, SLSourcesOfFluid,
  SLEnergySoluteSources, SLSpecifiedPressure, SLSpecConcOrTemp,
  SLInitialPressure, SLInitConcOrTemp, SLSutraMesh, SLFishnetMeshLayout,
  SLDomainDensity, SLThickness, SLMap, SLDataLayer, SLGeoUnit,
  IntListUnit, SLGeneralParameters, OptionsUnit, ZFunction,
  ANECB, DecayConstCalculator, SLSutraMeshGeoUnit, FixNameUnit,
  frmChangeValuesUnit, ParamArrayUnit, UcodeParser, frmEquationEditorUnit, 
  SLUcodeFactors, SLSpecificHeat, SLThermalConductivity, framePermUnit;

const
  kPressure = 'pressure';
  kHead = 'hydraulic head';
  kTemperature = 'temperature';
  kConcentration = 'concentration';
  KConcTemp = kConcentration + '/' + kTemperature;
  kConcOrTemp = 'conc. or temp.';
  kEnergy = 'energy';
  kSolute = 'solute';
  KEnergyOrSolute = kEnergy + ' or ' + kSolute;
  kHeat = 'heat';
  kPermeabilities = 'permeabilities';
  kHydraulicConductivities = 'hydraulic conductivities';

procedure GetTimeSeriesItem (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
//  param1 : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
  Row: integer;
  param1_ptr : ANE_INT32_PTR;
begin
  if EditWindowOpen then
  begin
    Beep;
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;
      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      if Row = 0 then
      begin
        result := 0;
      end
      else
      begin
        try
          result := StrToFloat(frmSutra.rdgTimeSeries.Cells[0,Row]);
          case frmSutra.comboTimeUnits.ItemIndex of
            0:
              begin
                // do nothing
              end;
            1:
              begin
                // minutes
                result := result * 60;
              end;
            2:
              begin
                // hours
                result := result * 3600;
              end;
            3:
              begin
                // days
                result := result * 3600 * 24;
              end;
            4:
              begin
                // months
                result := result * 3600 * 24 * 365.25 / 12;
              end;
            5:
              begin
                // years
                result := result * 3600 * 24 * 365.25;
              end;
          else Assert(False);
          end;

        except
          result := 0;
        end;
      end;

      ANE_DOUBLE_PTR(reply)^ := result;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ExportDataSet11B (const refPtX : ANE_DOUBLE_PTR ;
			   const refPtY : ANE_DOUBLE_PTR  ;
			   numParams : ANE_INT16          ;
			   const parameters : ANE_PTR_PTR ;
			   funHandle : ANE_PTR            ;
			   reply : ANE_PTR		  ); cdecl;
var
//  param1 : ANE_STR;
  result : ANE_BOOL;
//  param : PParameter_array;
  Index: integer;
  FileName: string;
  AFile: TextFile;
  NUIREG : integer;
  ItemIndex : integer;
  AFrame: TframeRegionParams;
  SWRES: double;
  VN: double;
  PENT: double;
  RLAMB: double;
  ParIndex: integer;
  RKRES: double;
  OMPOR: double;
  NRKPAR: integer;
  RKPAR: double;
  AA: double;
  NSWPAR: integer;
  PSWRES: double;
  SWPAR: double;
  SWRESI: double;
  W: double;
  TSWRESI: double;
  NSIPAR: integer;
  SIPAR: double;
begin
  if EditWindowOpen then
  begin
    Beep;
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;
//      param := @parameters^;
//      param1 :=  param^[0];
//      FileName := string(param1);
      FileName := IncludeTrailingPathDelimiter(GetCurrentDir) + frmSutra.edRoot.Text
          + '.' + frmSutra.edExtension.Text + '11B';

      AssignFile(AFile, FileName);
      try
        Rewrite(AFile);
        Writeln(AFile, '#Start_inp11B');
        if frmSutra.rbSatUnsat.Checked or frmSutra.rbFreezing.Checked then
        begin
          NUIREG := StrToIntDef(frmSutra.adeNUIREG.Text, 0);
          Writeln(AFile, NUIREG, ' ''Number of Regions''');
          for Index := 0 to NUIREG -1 do
          begin
            AFrame := frmSutra.FEquationFrameList[Index] as TframeRegionParams;

            // write line for unsaturated region
            ItemIndex := frmSutra.rdgFreezingEq.ItemIndex[Ord(fcUnsaturated),Index+1];
            if (ItemIndex < 0) or not frmSutra.rbSatUnsat.Checked then
            begin
              ItemIndex := 0;
            end;

            case ItemIndex of
              0:
                begin

                  WriteLn(AFile, '''NONE''');
                end;
              1:
                begin
                  SWRES := StrToFloatDef(AFrame.frameUnsat.ade1SWRES.Text, 0);
                  AA := StrToFloatDef(AFrame.frameUnsat.ade1AA.Text, 0);
                  VN := StrToFloatDef(AFrame.frameUnsat.ade1VN.Text, 0);
                  WriteLn(AFile, '''VGEN'' ', SWRES, ' ', AA, ' ', VN);
                end;
              2:
                begin
                  SWRES := StrToFloatDef(AFrame.frameUnsat.ade2SWRES.Text, 0);
                  PENT := StrToFloatDef(AFrame.frameUnsat.ade2PENT.Text, 0);
                  RLAMB := StrToFloatDef(AFrame.frameUnsat.ade2RLAMB.Text, 0);
                  WriteLn(AFile, '''BCOR'' ', SWRES, ' ', PENT, ' ', RLAMB);
                end;
              3:
                begin
                  SWRES := StrToFloatDef(AFrame.frameUnsat.ade3SWRES.Text, 0);
                  PENT := StrToFloatDef(AFrame.frameUnsat.ade3PENT.Text, 0);
                  PSWRES := StrToFloatDef(AFrame.frameUnsat.ade3PSWRES.Text, 0);
                  WriteLn(AFile, '''PLIN'' ', SWRES, ' ', PENT, ' ', PSWRES);
                end;
              4:
                begin
                  NSWPAR := StrToIntDef(AFrame.frameUnsat.ade4NSWPAR.Text, 0);
                  Write(AFile, '''UDEF'' ', NSWPAR, ' ');
                  for ParIndex := 0 to NSWPAR -1 do
                  begin
                    SWPAR := StrToFloatDef(AFrame.frameUnsat.rdg4SWPAR.Cells[ParIndex,0], 0);
                    Write(AFile, SWPAR, ' ');
                  end;
                  WriteLn(AFile);
                end;
            else Assert(False);
            end;

            // write line for permeability region
            ItemIndex := frmSutra.rdgFreezingEq.ItemIndex[Ord(fcPermeability),Index+1];
            if ItemIndex < 0 then
            begin
              ItemIndex := 0;
            end;

            case ItemIndex of
              0:
                begin

                  WriteLn(AFile, '''NONE''');
                end;
              1:
                begin
                  SWRES := StrToFloatDef(AFrame.frameRelativePermeability.ade1SWRES.Text, 0);
                  VN := StrToFloatDef(AFrame.frameRelativePermeability.ade1VN.Text, 0);
                  WriteLn(AFile, '''VGEN'' ', SWRES, ' ', VN);
                end;
              2:
                begin
                  PENT := StrToFloatDef(AFrame.frameRelativePermeability.ade2PENT.Text, 0);
                  RLAMB := StrToFloatDef(AFrame.frameRelativePermeability.ade2RLAMB.Text, 0);
                  WriteLn(AFile, '''BCOR'' ', PENT, ' ', RLAMB);
                end;
              3:
                begin
                  SWRES := StrToFloatDef(AFrame.frameRelativePermeability.ade3SWRES.Text, 0);
                  RKRES := StrToFloatDef(AFrame.frameRelativePermeability.ade3RKRES.Text, 0);
                  WriteLn(AFile, '''PLIN'' ', SWRES, ' ', RKRES);
                end;
              4:
                begin
                  OMPOR := StrToFloatDef(AFrame.frameRelativePermeability.ade4OMPOR.Text, 0);
                  RKRES := StrToFloatDef(AFrame.frameRelativePermeability.ade4RKRES.Text, 0);
                  WriteLn(AFile, '''IMPE'' ', OMPOR, ' ', RKRES);
                end;
              5:
                begin
                  NRKPAR := StrToIntDef(AFrame.frameRelativePermeability.ade5NRKPAR.Text, 0);
                  Write(AFile, '''UDEF'' ', NRKPAR, ' ');
                  for ParIndex := 0 to NRKPAR -1 do
                  begin
                    RKPAR := StrToFloatDef(AFrame.frameRelativePermeability.rdg5RKPAR.Cells[ParIndex,0], 0);
                    Write(AFile, RKPAR, ' ');
                  end;
                  WriteLn(AFile);
                end;
            else Assert(False);
            end;

            // write line for ice-saturation region
            ItemIndex := frmSutra.rdgFreezingEq.ItemIndex[Ord(fcFreezing),Index+1];
            if (ItemIndex < 0) or not frmSutra.rbFreezing.Checked then
            begin
              ItemIndex := 0;
            end;

            case ItemIndex of
              0:
                begin
                  WriteLn(AFile, '''NONE''');
                end;
              1:
                begin
                  SWRESI := StrToFloatDef(AFrame.frameIceSat.ade1SWRESI.Text, 0);
                  W := StrToFloatDef(AFrame.frameIceSat.ade1W.Text, 0);
                  WriteLn(AFile, '''EXPO'' ', SWRESI, ' ', W);
                end;
              2:
                begin
                  SWRESI := StrToFloatDef(AFrame.frameIceSat.ade2SWRESI.Text, 0);
                  TSWRESI := StrToFloatDef(AFrame.frameIceSat.ade2TSWRESI.Text, 0);
                  WriteLn(AFile, '''PLIN'' ', SWRESI, ' ', TSWRESI);
                end;
              3:
                begin
                  NSIPAR := StrToIntDef(AFrame.frameIceSat.ade3NSIPAR.Text, 0);
                  Write(AFile, '''UDEF'' ', NSIPAR, ' ');
                  for ParIndex := 0 to NSIPAR -1 do
                  begin
                    SIPAR := StrToFloatDef(AFrame.frameIceSat.rdg3SIPAR.Cells[ParIndex,0], 0);
                    Write(AFile, SIPAR, ' ');
                  end;
                  WriteLn(AFile);
                end;
            else Assert(False);
            end;



          end;

        end
        else
        begin
          Writeln(AFile, '0 ''Number of Regions''');
        end;

      finally
        CloseFile(AFile);
      end;


      result := True;
      ANE_BOOL_PTR(reply)^ := result;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;


function ListPosition(const Strings: TStrings; const Item: string): Integer;
begin
  for Result := 0 to Strings.Count - 1 do
    if Strings[result] = Item then Exit;
  Result := -1;
end;

function CapitalizeFirst(AString: string): string;
var
  NewString: string;
begin
  result := AString;
  if Length(result) > 0 then
  begin
    NewString := UpperCase(result[1]);
    result[1] := NewString[1];
  end;
end;

procedure TfrmSutra.SetThicknessExpressions;
begin
  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TZParam, TZParam.ANE_ParamName, True);
end;

procedure TfrmSutra.UpdateExpressions;
begin
  SetSourcesOfFluidExpressions;

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TBottomSoluteEnergySourcesLayer, TResultantSoluteEnergySourceParam,
    TResultantSoluteEnergySourceParam.ANE_ParamName, True);
end;

procedure TfrmSutra.SetPressureHeadExpressions;
begin
  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCParam, TPBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMAXParam, TPMAXParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMINParam, TPMINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE1Param, TANGLE1Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecHeadPresParam,
    TTimeDepSpecHeadPresParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);







//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionPUBC_Param, TInvNodeFunctionPUBC_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodePUBC_Param, TInvNodePUBC_Param.ANE_ParamName, True);

//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionPBC_Param, TInvNodeFunctionPBC_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodePBC_Param, TInvNodePBC_Param.ANE_ParamName, True);

//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionANGLE1_Param, TInvNodeFunctionANGLE1_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodeANGLE1_Param, TInvNodeANGLE1_Param.ANE_ParamName, True);

//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionPMIN_Param, TInvNodeFunctionPMIN_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodePMIN_Param, TInvNodePMIN_Param.ANE_ParamName, True);

//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionPMAX_Param, TInvNodeFunctionPMAX_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodePMAX_Param, TInvNodePMAX_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBC_CommentParam, TPBC_CommentParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvHeadObsName_Param, TInvHeadObsName_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvFluxObsName_Param, TInvFluxObsName_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvSoluteFluxObsName_Param, TInvSoluteFluxObsName_Param.ANE_ParamName, True);



  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPBCParam, TPBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPBCTopParam, TPBCTopParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPBCBottomParam, TPBCBottomParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPMAXParam, TPMAXParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPMIDParam, TPMIDParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPMINParam, TPMINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLE1Param, TANGLE1Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLE2Param, TANGLE2Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLE3Param, TANGLE3Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TTimeDepSpecHeadPresParam,
    TTimeDepSpecHeadPresParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCParam, TPBCParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCTopParam, TPBCTopParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCBottomParam, TPBCBottomParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMAXParam, TPMAXParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMIDParam, TPMIDParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMINParam, TPMINParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE1Param, TANGLE1Param.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE2Param, TANGLE2Param.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE3Param, TANGLE3Param.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecHeadPresParam,
    TTimeDepSpecHeadPresParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.SetSoluteEnergyExpressions;
begin
  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUBCParam, TUBCParam.ANE_ParamName, True);

  {$IFDEF OldSutraIce}
  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TGNUU0Param, TGNUU0Param.ANE_ParamName, True);
  {$ENDIF}

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TQUINParam, TQUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepEnergySoluteSourceParam,
    TTimeDepEnergySoluteSourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecConcTempParam,
    TTimeDepSpecConcTempParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUVECParam, TUVECParam.ANE_ParamName, True);





//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionUBC_Param,
//    TInvNodeFunctionUBC_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodeUBC_Param,
    TInvNodeUBC_Param.ANE_ParamName, True);

//  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
//    (TSutraMeshLayer, TInvNodeFunctionQUIN_Param,
//    TInvNodeFunctionQUIN_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvNodeQUIN_Param,
    TInvNodeQUIN_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvConcentrationObsName_Param,
    TInvConcentrationObsName_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvFluxObsName_Param, TInvFluxObsName_Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TInvSoluteFluxObsName_Param, TInvSoluteFluxObsName_Param.ANE_ParamName, True);

    

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (T2DSoluteEnergySourcesLayer, TResultantSoluteEnergySourceParam,
    TResultantSoluteEnergySourceParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (T2DSoluteEnergySourcesLayer, TResultantSoluteEnergySourceParam,
    TResultantSoluteEnergySourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (T2DFluidSourcesLayer, TQINUINParam, TQINUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TUBCParam, TUBCParam.ANE_ParamName, True);

  {$IFDEF OldSutraIce}
  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TGNUU0Param, TGNUU0Param.ANE_ParamName, True);
  {$ENDIF}

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TQUINParam, TQUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TTimeDepEnergySoluteSourceParam,
    TTimeDepEnergySoluteSourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TTimeDepSpecConcTempParam,
    TTimeDepSpecConcTempParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TUVECParam, TUVECParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUBCParam, TUBCParam.ANE_ParamName, True);

  {$IFDEF OldSutraIce}
  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TGNUU0Param, TGNUU0Param.ANE_ParamName, True);
  {$ENDIF}

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TQUINParam, TQUINParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepEnergySoluteSourceParam,
    TTimeDepEnergySoluteSourceParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecConcTempParam,
    TTimeDepSpecConcTempParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUVECParam, TUVECParam.ANE_ParamName, True);

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.SetSourcesOfFluidExpressions;
begin
  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TBottomFluidSourcesLayer, TResultantFluidSourceParam,
    TResultantFluidSourceParam.ANE_ParamName, True);
end;

procedure TfrmSutra.SetUnsaturatedExpressions;
begin
  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TNREGParam, TNREGParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TLREGParam, TLREGParam.ANE_ParamName, True);
    

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TNREGParam, TNREGParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers0.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TLREGParam, TLREGParam.ANE_ParamName, True);


  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TNREGParam, TNREGParam.ANE_ParamName, True);

  SutraLayerStructure.ZerothListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TLREGParam, TLREGParam.ANE_ParamName, True);

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.AddOrRemoveParameters;
var
  MeshLayer: T_ANE_QuadMeshLayer;
  {$IFDEF SutraIce}
  BottomNodes : TList;
  Node, TopNode: TTreeNode;
  LayerClass: T_ANE_MapsLayerClass;
  UnitIndex: integer;
  GeoUnit: T_ANE_IndexedLayerList;
  RowIndex, ColIndex: integer;
  LayerList: T_TypedIndexedLayerList;
  {$ENDIF}
begin

  if not cancelling then
  begin
    MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;
    if MeshLayer <> nil then
    begin
      MeshLayer.AddOrRemoveUnIndexedParameter(TNREGParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TZParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPORParam,
        not Is3D);
      {$IFDEF SutraIce}
      MeshLayer.AddOrRemoveUnIndexedParameter(TCS1Parameter,
        not Is3D and (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}
      MeshLayer.AddOrRemoveUnIndexedParameter(TLREGParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPMAXParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPMINParam,
        not Is3D);
      {$IFDEF SutraIce}
      MeshLayer.AddOrRemoveUnIndexedParameter(TSIGS,
        not Is3D and (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}
      MeshLayer.AddOrRemoveUnIndexedParameter(TANGLE1Param,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TALMAXParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TALMINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TQINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TUINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepFluidSourceParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TQUINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepEnergySoluteSourceParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPBCParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPBC_CommentParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TpUBCParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepSpecHeadPresParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TUBCParam,
        not Is3D);
      {$IFDEF OldSutraIce}
      MeshLayer.AddOrRemoveUnIndexedParameter(TGNUU0Param,
        not Is3D);
      {$ENDIF}
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepSpecConcTempParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPVECParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TUVECParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TINOBParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TINOBTypeParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TAT1MAXParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TAT1MINParam,
        not Is3D);

      MeshLayer.AddOrRemoveIndexedParameter1(TNREGParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TZParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPORParam,
        VerticallyAlignedMesh);
      {$IFDEF SutraIce}
      MeshLayer.AddOrRemoveIndexedParameter1(TCS1Parameter,
        VerticallyAlignedMesh and (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}
      MeshLayer.AddOrRemoveIndexedParameter1(TLREGParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPMAXParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPMIDParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPMINParam,
        VerticallyAlignedMesh);
      {$IFDEF SutraIce}
      MeshLayer.AddOrRemoveIndexedParameter1(TSIGS,
        VerticallyAlignedMesh and (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}

      MeshLayer.AddOrRemoveIndexedParameter1(TANGLE1Param,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TANGLE2Param,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TANGLE3Param,
        VerticallyAlignedMesh);

      MeshLayer.AddOrRemoveIndexedParameter1(TALMAXParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TALMIDParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TALMINParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPVECParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TUVECParam,
        VerticallyAlignedMesh);

      MeshLayer.AddOrRemoveIndexedParameter1(TAT1MAXParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT1MIDParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT1MINParam,
        VerticallyAlignedMesh);
    end;

    {$IFDEF SutraIce}
    {$IFDEF OldSutraIce}
    SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
      (T2DSpecConcTempLayer, TConductance,
      rbFreezing.Checked and not Is3D);
    {$ENDIF}

    if Is3D then
    begin
      BottomNodes := TList.Create;
      try
        TopNode := nil;
        Node := rctreeBoundaries.Items.GetFirstNode;
//        Node := vstNodeBoundaries2.GetFirst;
        while Node <> nil do
        begin
          LayerClass := Node.Data;
//          LayerRecord := vstNodeBoundaries2.GetNodeData(Node);
//          LayerClass := LayerRecord.LayerClass;
          if LayerClass = TTopSpecConcTempLayer then
          begin
            TopNode := Node
          end
          else if LayerClass = TBottomSpecConcTempLayer then
          begin
            BottomNodes.Add(Node);
          end;
//          Node := vstNodeBoundaries2.GetNext(Node);
          Node := Node.GetNext;
        end;

//        SutraLayerStructure.IntermediateUnIndexedLayers.AddOrRemoveUnIndexedParameter
//          (TTopSpecConcTempLayer, TConductance,
//          cbSutraIce.Checked and Is3D and (TopNode.CheckState
//            in [csCheckedNormal, csCheckedPressed]));
    {$IFDEF OldSutraIce}
        SutraLayerStructure.IntermediateUnIndexedLayers.AddOrRemoveUnIndexedParameter
          (TTopSpecConcTempLayer, TConductance,
          rbFreezing.Checked and Is3D and (TopNode.StateIndex = 2));
    {$ENDIF}

        for UnitIndex := 0 to BottomNodes.Count -1 do
        begin
          Node := BottomNodes[UnitIndex];
          GeoUnit := SutraLayerStructure.ListsOfIndexedLayers.
            GetNonDeletedIndLayerListByIndex(UnitIndex);
          {$IFDEF OldSutraIce}
          if GeoUnit <> nil then
          begin
            GeoUnit.AddOrRemoveUnIndexedParameter
              (TBottomSpecConcTempLayer, TConductance,
              rbFreezing.Checked and Is3D and (Node.StateIndex = 2));
          end;
          {$ENDIF}
        end;
      finally
        BottomNodes.Free;
      end;

      RowIndex := Ord(btiSpecConc);
      for ColIndex := 1 to dgBoundaryCountsNew.ColCount - 1 do
      begin
        LayerList := dgBoundaryCountsNew.Objects[ColIndex, RowIndex]
          as T_TypedIndexedLayerList;
        if (LayerList <> nil) and (LayerList.TypedCount > 0) then
        begin
    {$IFDEF OldSutraIce}

          LayerList.AddOrRemoveUnIndexedParameter(
            T_ANE_LayerClass(LayerList.LayerType),
            TConductance, rbFreezing.Checked);
    {$ENDIF}
        end;
      end;
    end;
    {$ENDIF}
  end;
end;

procedure TfrmSutra.AddOrRemoveLayers;
begin
  if not cancelling then
  begin
    SutraLayerStructure.IntermediateUnIndexedLayers.AddOrRemoveLayer(
      TSutraTopGroupLayer, Is3D);
    SutraLayerStructure.IntermediateUnIndexedLayers.AddOrRemoveLayer(
      TTopElevLayer, Is3D);

    SutraLayerStructure.UnIndexedLayers0.AddOrRemoveLayer(TSutraMeshLayer,
      not MorphedMesh);

    SutraLayerStructure.UnIndexedLayers0.AddOrRemoveLayer(TFishnetMeshLayout,
      rbFishnet.Checked and not MorphedMesh);

    SutraLayerStructure.ZerothListsOfIndexedLayers.AddOrRemoveLayer(TFishnetMeshLayout,
      rbFishnet.Checked and MorphedMesh);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2DObservationLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2dUcodeHeadObservationLayer,
      not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2dUcodeConcentrationObservationLayer,
      not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2dUcodeSaturationObservationLayer,
      not Is3D and rbSatUnsat.Checked
      and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2dUcodeFluxObservationLayer,
      not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2dUcodeSoluteFluxObservationLayer,
      not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));



    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraHydrogeologyGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TThicknessLayer,
      (not Is3D and rbUserSpecifiedThickness.Checked));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TPorosityLayer,
      not Is3D);

    {$IFDEF SutraIce}
    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSpecificHeatLayer,
      not Is3D and (rbFreezing.Checked or rbEnergy.Checked));
    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TThermalConductivityLayer,
      not Is3D and (rbFreezing.Checked or rbEnergy.Checked));
    {$ENDIF}

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TPermeabilityLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TDispersivityLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TUnsaturatedLayer,
      (not Is3D and (rbCrossSection.Checked or rbGeneral.Checked)
      and (rbSatUnsat.Checked or rbFreezing.Checked or rbGeneral.Checked)));

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TUnsaturatedLayer,
      (Is3D and (rbSatUnsat.Checked or rbFreezing.Checked or rbGeneral.Checked)));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraHydroSourcesGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2DFluidSourcesLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2DSoluteEnergySourcesLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraHydroBoundariesGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2DSpecifiedPressureLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(T2DSpecConcTempLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraInitialConditionsGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TInitialPressureLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TInitialConcTempLayer,
      not Is3D);
  end;

  SutraLayerStructure.SetAllParamUnits;
//  AddOrRemoveUcodeObservationParameters;
end;

{procedure TfrmSutra.AddOrRemoveUcodeObservationParameters;
begin
  // Head observations.
  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeHeadObservationLayer, TCombineObs,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeHeadObservationLayer, TCustomStatFlag,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeHeadObservationLayer, TValue,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeHeadObservationLayer, TStatistic,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  // concentration observations
  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeConcentrationObservationLayer, TCombineObs,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeConcentrationObservationLayer, TCustomStatFlag,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeConcentrationObservationLayer, TValue,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeConcentrationObservationLayer, TStatistic,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  // saturation observations
  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeSaturationObservationLayer, TCombineObs,
    not Is3D and rbSatUnsat.Checked
    and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeSaturationObservationLayer, TCustomStatFlag,
    not Is3D and rbSatUnsat.Checked
    and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeSaturationObservationLayer, TValue,
    not Is3D and rbSatUnsat.Checked
    and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeSaturationObservationLayer, TStatistic,
    not Is3D and rbSatUnsat.Checked
    and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  // flux observations observations
  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeFluxObservationLayer, TCombineObs,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeFluxObservationLayer, TCustomStatFlag,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeFluxObservationLayer, TFluxValue,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeFluxObservationLayer, TStatistic,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));


  // Solute flux observations observations
  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeSoluteFluxObservationLayer, TCombineObs,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    T2dUcodeSoluteFluxObservationLayer, TCustomStatFlag,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeSoluteFluxObservationLayer, TSoluteFluxValue,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));

  SutraLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter0(
    T2dUcodeSoluteFluxObservationLayer, TStatistic,
    not Is3D and (cbInverse.Checked or cbPreserveInverseModelParameters.Checked));
end;   }

function TfrmSutra.EnergyUsed: boolean;
begin
  result := rbFreezing.Checked or rbEnergy.Checked;
end;

procedure TfrmSutra.rbGeneralClick(Sender: TObject);
begin
  inherited;
  AdjustInitPerm;
  rgDimensionsClick(Sender);

  EnableGravControls;
  if Is3D then
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 0;
    end;
  end
  else
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 1;
    end;
  end;
  if (lvChoices.Items[Ord(poStructZ)] <> nil)
    and (lvChoices.Items[Ord(po3D)] <> nil) then
  begin
    lvChoices.Items[Ord(po3D)].ImageIndex :=
      lvChoices.Items[Ord(poStructZ)].ImageIndex;
  end;

  rbAreal.Enabled := rbSpecific.Checked and not Is3D;
  rbCrossSection.Enabled := rbSpecific.Checked and not Is3D;
  rb3D_va.Enabled := Is3D;
  rb3D_nva.Enabled := Is3D;

  EnableTransportConditionControls;

  EnableConstDensity;

  rbUserSpecifiedThickness.Enabled := rbSpecific.Checked;
  adeCW.Enabled := EnergyUsed or rbGeneral.Checked;
  {$IFNDEF SutraIce}
  adeCS.Enabled := EnergyUsed or rbGeneral.Checked;
  adeSIGMAS.Enabled := EnergyUsed or rbGeneral.Checked;
  {$ENDIF}
  adePRODF1.Enabled := not EnergyUsed or rbGeneral.Checked;
  btnPRODF1.Enabled := adePRODF1.Enabled;
  adePRODS1.Enabled := not EnergyUsed or rbGeneral.Checked;
  btnPRODS1.Enabled := adePRODS1.Enabled;
  SetPredefinedInversionParameters;

  if rbGeneral.Checked and not Loading and not Cancelling then
  begin
    rbSatUnsat.Checked := True;
    rbSatUnsatClick(Sender);
  end;

  rbArealClick(Sender);

  AddOrRemoveLayers;
  SetUnsaturatedExpressions;
  SetPressureHeadExpressions;
  SetSoluteEnergyExpressions;
  SetThicknessExpressions;

  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
  AddOrRemoveMeshParameters;
  if (EnteredControl = rbGeneral) or (EnteredControl = rbSpecific) then
  begin
    SetDefaults;
  end;
end;

procedure TfrmSutra.EnableGravControls;
var
  ShouldEnable: boolean;
begin
  ShouldEnable := (Is3D or rbCrossSection.Checked or rbGeneral.Checked)
    and not rbSoluteConstDens.Checked;
  adeGRAVX.Enabled := ShouldEnable;
  if not adeGRAVX.Enabled and not Loading and not Cancelling then
  begin
    adeGRAVX.Text := '0';
  end;

  if not adeGRAVY.Enabled and ShouldEnable and not Loading and not Cancelling
    then
  begin
    if rbCrossSection.Checked then
    begin
      adeGRAVY.Text := '-9.81'
    end;
  end;
  adeGRAVY.Enabled := ShouldEnable;
  if not adeGRAVY.Enabled then
  begin
    adeGRAVY.Text := '0';
  end;

  adeGRAVZ.Enabled := ShouldEnable;
  if not adeGRAVZ.Enabled then
  begin
    adeGRAVZ.Text := '0';
  end;
end;

procedure TfrmSutra.rbArealClick(Sender: TObject);
var
  Index: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  inherited;

  AdjustInitPerm;
  if (Sender <> rbGeneral) and (Sender <> rbSpecific) then
  begin
    EnableGravControls;
  end;
  if Is3D then
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 0;
    end;
  end
  else
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 1;
    end;
  end;
  if (lvChoices.Items[Ord(poStructZ)] <> nil)
    and (lvChoices.Items[Ord(po3D)] <> nil) then
  begin
    lvChoices.Items[Ord(po3D)].ImageIndex :=
      lvChoices.Items[Ord(poStructZ)].ImageIndex;
  end;

//  rbIrregular.Enabled := not Is3d {$IFDEF Irreg3D_Meshes} or True {$ENDIF};
  rbIrregular.Enabled := True;
  if not rbIrregular.Enabled then
  begin
    rbFishnet.Checked;
  end;

  rbSatUnsat.Enabled := Is3D or (rbSpecific.Checked
    and not rbAreal.Checked) or rbGeneral.Checked;
  if not rbSatUnsat.Enabled and not Loading and not Cancelling then
  begin
    rbSat.Checked := True;
  end;

  EnableTransportConditionControls;

  rbCylindrical.Enabled := rbSpecific.Checked and rbCrossSection.Checked;

  if rbSatUnsat.Checked and not rbSatUnsat.Enabled
    and not Loading and not Cancelling then
  begin
    rbSat.Checked := True;
  end;
  rbSatUnsatClick(Sender);

  if rbCylindrical.Checked and not rbCylindrical.Enabled
    and not Loading and not Cancelling then
  begin
    rbUserSpecifiedThickness.Checked := True;
  end;

  AddOrRemoveLayers;
  AddOrRemoveParameters;
  if not is3D then
  begin
    for Index := 0 to SutraLayerStructure.ListsOfIndexedLayers.Count - 1 do
    begin
      ALayerList := SutraLayerStructure.ListsOfIndexedLayers.Items[Index];
      ALayerList.DeleteSelf
    end;
    for Index := 0 to SutraLayerStructure.ZerothListsOfIndexedLayers.Count - 1
      do
    begin
      ALayerList := SutraLayerStructure.ZerothListsOfIndexedLayers.Items[Index];
      ALayerList.DeleteSelf
    end;
  end;

  dimensions := sd2d;
  if (EnteredControl = rbAreal) or (EnteredControl = rbCrossSection) then
  begin
    SetDefaults;
  end;
end;

procedure TfrmSutra.ReadcbSutraIce(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist; DataToRead: TStringList; const VersionControl:
    TControl);
//var
//  AText: string;
//  ARadioButton: TRadioButton;
begin
  ReadRadioButton( LineIndex, FirstList, IgnoreList, rbFreezing, DataToRead, VersionControl);
//  AText := DataToRead[LineIndex];
//  Inc(LineIndex);
//  ARadioButton := rbFreezing;
//  if not (ARadioButton = VersionControl) and
//    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
//    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
//  then
//  begin
//    if Assigned(ARadioButton.OnEnter) then
//    begin
//      ARadioButton.OnEnter(ARadioButton);
//    end;
//    if AText = '0'
//    then
//        begin
//          ARadioButton.State := cbUnchecked;
//        end
//    else if AText = '1'
//    then
//        begin
//          ARadioButton.State := cbChecked;
//        end
//    else if AText = '2'
//    then
//        begin
//          ARadioButton.State := cbGrayed;
//        end;
//    if Assigned(ARadioButton.OnClick) then
//    begin
//      ARadioButton.OnClick(ARadioButton);
//    end;
//    if Assigned(ARadioButton.OnExit) then
//    begin
//      ARadioButton.OnExit(ARadioButton);
//    end;
//  end;
end;


procedure TfrmSutra.ReadInitialValues(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist; DataToRead: TStringList; const VersionControl:
    TControl);
begin
  ElementInterp.Read(DataToRead, LineIndex);
end;

procedure TfrmSutra.ReadOldCSOLVP(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  NewValue: integer;
begin
  NewValue := StrToInt(DataToRead[LineIndex]);
  if NewValue > 1 then
  begin
    Dec(NewValue);
    DataToRead[LineIndex] := IntToStr(NewValue);
  end;
  ReadRadioGroup(LineIndex, FirstList, IgnoreList, rgPressureSolverNew,
    DataToRead, VersionControl);
end;

procedure TfrmSutra.InitializeTree;
var
  AName: string;
  ParentCheckNode: TTreeNode;
  ChildCheckNode: TTreeNode;
begin
  ParentCheckNode := rctreeBoundaries.Items.AddChild(nil, 'Unit1');
  ParentCheckNode.Data := nil;
  ParentCheckNode.StateIndex := 1;

  AName := TTopFluidSourcesLayer.WriteNewRoot ;
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TTopFluidSourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TTopSoluteEnergySourcesLayer.WriteNewRoot ;
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TTopSoluteEnergySourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TTopSpecifiedPressureLayer.WriteNewRoot ;
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TTopSpecifiedPressureLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TTopSpecConcTempLayer.WriteNewRoot ;
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TTopSpecConcTempLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TTopObservationLayer.WriteNewRoot ;
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TTopObservationLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomFluidSourcesLayer.WriteNewRoot + IntToStr(1);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomFluidSourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSoluteEnergySourcesLayer.WriteNewRoot + IntToStr(1);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSoluteEnergySourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSpecifiedPressureLayer.WriteNewRoot + IntToStr(1);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSpecifiedPressureLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSpecConcTempLayer.WriteNewRoot + IntToStr(1);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSpecConcTempLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomObservationLayer.WriteNewRoot + IntToStr(1);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomObservationLayer;
  ChildCheckNode.StateIndex := 1;
end;

procedure TfrmSutra.SetFunctionGridLabels;
begin
  rdgFreezingEq.Cells[Ord(fcRegionNumber),0] := 'Region number';
  rdgFreezingEq.Cells[Ord(fcPermeability),0] := 'Relative Permeability Function';
  rdgFreezingEq.Cells[Ord(fcUnsaturated),0] := 'Unsaturated Function';
  rdgFreezingEq.Cells[Ord(fcFreezing),0] := 'Freezing  Function';
end;

procedure TfrmSutra.FormCreate(Sender: TObject);
var
  ColIndex, RowIndex: integer;
  CompIndex, PageIndex: integer;
  AComponent: TComponent;
  Index: integer;
begin
  inherited;
{$IFDEF SutraIce}
  cbSutra3.Checked := True;
{$ENDIF}
  FEquationFrameList := TObjectList.Create;
  FCreatingExpressions := false;
  SimulationTimes := TRealList.Create;
  frmParameterValues := TfrmParameterValues.Create(self);

//{$IFDEF Irreg3D_Meshes}
  cbIrreg.Checked := True;
//{$ENDIF}

//{$IFNDEF SUTRA21}
//  comboTimeUnits.Enabled := False;
//  comboScheduleType.Enabled := False;
//{$ENDIF}

{$IFNDEF UCODE}
  cbInverse.Enabled := False;
  cbPreserveInverseModelParameters.Enabled := False;
  gbInverse.Visible := False;
{$ENDIF}

{$IFDEF Sutra2d}
  rgDimensions.Enabled := False;
  rb3D_va.Enabled := False;
  rb3D_nva.Enabled := False;
{$ENDIF}

{$IFDEF OldSutraIce}
  adeGNUU.Enabled := False;
{$ENDIF}
{$IFDEF SutraIce}
  adeCS.Enabled := False;
  adeSIGMAS.Enabled := False;
{$ELSE}
  rbFreezing.Enabled := False;
{$ENDIF}


  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;

  SpecialHandlingList := TSpecialHandlingList.Create;

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('ElementInterp', ReadInitialValues));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('rgPressureSolver', ReadOldCSOLVP));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('cbSutraIce', ReadcbSutraIce));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('comboISSFLO', ReadOldcomboISSFLO));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('comboISSTRA', ReadOldcomboISSTRA));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('comboSIMULA', ReadOldcomboSIMULA));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('adeBoundLayerCount', ReadOldcomboSIMULA));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('ffpPerl', ReadOldFileNameFrame));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('ffpPlFile', ReadOldFileNameFrame));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create
    ('vstNodeBoundaries2', ReadvstNodeBoundaries2));

  ElementInterp := nil;

  InitializeTree;

  rdgFactorGrid.Cells[Ord(fcN),0] := 'N';
  rdgFactorGrid.Cells[Ord(fcName),0] := 'Factor Name';
  rdgFactorGrid.Cells[Ord(fcLayer),0] := 'Layer Number';

  dgBoundaryCountsNew.Cells[0, Ord(btiFluidSource)] := 'Sources of Fluid';
  dgBoundaryCountsNew.Cells[0, Ord(btiSoluteSource)] := 'Sources of Solute';
  dgBoundaryCountsNew.Cells[0, Ord(btiSpecPressure)] := 'Specified Head';
  dgBoundaryCountsNew.Cells[0, Ord(btiSpecConc)] := 'Specified Concentration';
  dgBoundaryCountsNew.Cells[0, Ord(btiObservations)] := 'Observations';
  for ColIndex := 1 to dgBoundaryCountsNew.ColCount - 1 do
  begin
    for RowIndex := 1 to dgBoundaryCountsNew.RowCount - 1 do
    begin
      if ColIndex = dgBoundaryCountsNew.ColCount - 1 then
      begin
        dgBoundaryCountsNew.Cells[ColIndex, RowIndex] := '1';
      end
      else
      begin
        dgBoundaryCountsNew.Cells[ColIndex, RowIndex] := '0';
      end;
    end;
  end;

  SetFunctionGridLabels;

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('rgMeshType',
    ReadOldFishnet));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('adeNPCYC',
    ReadOldNPCYC));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('adeNUCYC',
    ReadOldNUCYC));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('rzctNodeBoundaries2',
    ReadRzctNodeBoundaries2));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('rzctNodeBoundaries',
    ReadRzctNodeBoundaries));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgBoundaryCounts',
    ReadOlddgBoundaryCounts));

  Cancelling := False;
  GetVersion := GetPIEVersion;

  memoSutraDoc.Lines := StrSetDoc1.Strings;
  memoDoc.Lines := StrSetDoc2.Strings;

  VersionInfo1.FileName := DLLName;
  lblVersion.Caption := VersionInfo1.FileVersion;
  dimensions := sd2D;

  OldModel := False;

  EnableTemporalControls;

  pgcontrlMain.ActivePage := tabConfiguration;
  pcInverseModel.ActivePageIndex := 0;
  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
  edRunSutraChange(edRunSutra);

  sicomboCSSFLO_and_CSSTRA.ItemIndex := 0;
  sicomboCSSFLO_and_CSSTRAChange(nil);

  comboIREAD.ItemIndex := 0;
  comboADSMOD.ItemIndex := 0;

  EnableTemporalControls;

  InitializeGeoGrid;
  IgnoreList.Add('rgRunSutra');
  IgnoreList.Add('rgAlert');
  IgnoreList.Add('memoDoc');
  IgnoreList.Add('memoSutraDoc');

  IgnoreList.Add('cbExportNBI');
  IgnoreList.Add('cbExport8D');
  IgnoreList.Add('cbExport14B');
  IgnoreList.Add('cbExport15B');
  IgnoreList.Add('cbExport17');
  IgnoreList.Add('cbExport18');
  IgnoreList.Add('cbExport19');
  IgnoreList.Add('cbExport20');
  IgnoreList.Add('cbExport22');
  IgnoreList.Add('cbExportICS2');
  IgnoreList.Add('cbExportICS3');

  IgnoreList.Add('rbMemory');
  IgnoreList.Add('rbStore');
  IgnoreList.Add('rbRead');
  IgnoreList.Add('rbCompute');
  IgnoreList.Add('edRunDirectory');
  IgnoreList.Add('adeTSTART');
  IgnoreList.Add('edSutraViewerPath');
  IgnoreList.Add('adeITOLP');
  IgnoreList.Add('adeNSAVEP');
  IgnoreList.Add('adeITOLU');
  IgnoreList.Add('adeNSAVEU');
  IgnoreList.Add('comboIUNSAT');

{$IFNDEF UCODE}
  IgnoreList.Add('cbInverse');
  IgnoreList.Add('cbPreserveInverseModelParameters');

  IgnoreList.Add('adeObservationTimes');
  IgnoreList.Add('rgPhase');
  IgnoreList.Add('rgDifferencing');
  IgnoreList.Add('rgNOPT');
  IgnoreList.Add('adeUcodeTolerance');
  IgnoreList.Add('adeUcodeSOSR');
  IgnoreList.Add('adeUcodeMaxiter');
  IgnoreList.Add('adeUcodeMaxChange');
  IgnoreList.Add('rgScaleSensitivities');
  IgnoreList.Add('cbPrintIntermediate');
  IgnoreList.Add('cbPrintGraph');
  IgnoreList.Add('adeUcodeSets');
  IgnoreList.Add('ffpInversion');

  IgnoreList.Add('adeParameterCount');
  IgnoreList.Add('dgEstimate');
  IgnoreList.Add('ffpPerl.edFilePath');
  IgnoreList.Add('ffpPlFile.edFilePath');
  IgnoreList.Add('cbPauseUcode');

  IgnoreList.Add('cbCheckObservationNames');
  IgnoreList.Add('cbAlternateWeighting');
  IgnoreList.Add('adeAltWeightingConstant');
  IgnoreList.Add('adeAltWeightingThreshold');
  IgnoreList.Add('cbAlternatePrintFiles');
  IgnoreList.Add('cbPrintGraphFileHeader');
  IgnoreList.Add('cbGroupStatisticsReporting');
  IgnoreList.Add('cbRestart');
  IgnoreList.Add('cbPerfectProblem');
{$ENDIF}

  {$IFNDEF SUTRA22Input}
  IgnoreList.Add('rbFreezing');
  IgnoreList.Add('cbSutraIce');
  IgnoreList.Add('cbCPANDS');
  IgnoreList.Add('cbCCORT');
  IgnoreList.Add('adeNBCFPR');
  IgnoreList.Add('adeNBCSPR');
  IgnoreList.Add('adeNBCPPR');
  IgnoreList.Add('adeNBCUPR');
  IgnoreList.Add('cbCINACT');
  {$ENDIF}
  {$IFNDEF SutraIce}
  IgnoreList.Add('cbSutra3');

  {$ENDIF}


  // When Irreg3D_Meshes is no longer needed,
  // the following line should be deleted.
//  IgnoreList.Add(cbIrreg.Name);

  FirstList.Add('rbGeneral');
  FirstList.Add('rbSpecific');
  FirstList.Add('rbAreal');
  FirstList.Add('rbCrossSection');
  FirstList.Add('rb3D_va');
  FirstList.Add('rb3D_nva');
  FirstList.Add('adeBoundLayerCount');
  FirstList.Add('rgDimensions');
  FirstList.Add('adeVertDisc');
  FirstList.Add('rgInterpolateInitialValues');

  SetTitles;

  dgEstimate.Cells[Ord(ucN),0]            := 'N';
  dgEstimate.Cells[Ord(ucParameter),0]    := 'Parameter Name';
  dgEstimate.Cells[Ord(ucEstimate),0]     := 'Estimate';
  dgEstimate.Cells[Ord(ucInitialValue),0] := 'Starting Value';
  dgEstimate.Cells[Ord(ucMin),0]          := 'Lower Reasonable Value';
  dgEstimate.Cells[Ord(ucMax),0]          := 'Upper Reasonable Value';
  dgEstimate.Cells[Ord(ucPerturbation),0] := 'Parameter Perturbation';
  dgEstimate.Cells[Ord(ucLog),0]          := 'Log10 Transform';
  dgEstimate.Cells[Ord(ucConstrain),0] := 'Constrain';
  dgEstimate.Cells[Ord(ucLowerConstraint),0] := 'Lower Constraint';
  dgEstimate.Cells[Ord(ucUpperConstraint),0] := 'Upper Constraint';
  dgEstimate.Cells[Ord(ucExpression),0]  := 'Expression';
  dgEstimate.Cells[Ord(ucDescription),0]  := 'Description';

  dgEstimate.Cells[Ord(ucN),1]            := '1';
  dgEstimate.Cells[Ord(ucParameter),1]    := 'Parameter1';
  dgEstimate.Cells[Ord(ucInitialValue),1] := '1';
  dgEstimate.Cells[Ord(ucMin),1]          := '0.1';
  dgEstimate.Cells[Ord(ucMax),1]          := '10';
  dgEstimate.Cells[Ord(ucPerturbation),1] := '0.01';
  dgEstimate.Cells[Ord(ucLowerConstraint),1] := '0.1';
  dgEstimate.Cells[Ord(ucUpperConstraint),1] := '10';

//  dgEstimate.ColWidths[Ord(ucParameter)] :=  dgEstimate.DefaultColWidth + 30;
//  dgEstimate.ColWidths[Ord(ucPerturbation)] :=  dgEstimate.DefaultColWidth + 10;

  dgPriorEquations.Cells[Ord(picName), 0] := 'Prior Information Name';
  dgPriorEquations.Cells[Ord(picUseEquation), 0] := 'Use Equation?';
  dgPriorEquations.Cells[Ord(picEquation), 0] := 'Equation Expression';
  dgPriorEquations.Cells[Ord(picValue), 0] := 'Equation Value';
  dgPriorEquations.Cells[Ord(picStatistic), 0] := 'Statistic Value';
  dgPriorEquations.Cells[Ord(picStatFlag), 0] := 'Statistic Type';

  pgcontrlMainChange(Sender);

  for CompIndex := 0 to ComponentCount - 1 do
  begin
    AComponent := Components[CompIndex];
    if AComponent is TPageControl then
    begin
      LockWindowUpdate(Handle);
      with AComponent as TPageControl do
      begin
        for PageIndex := 0 to PageCount - 1 do
        begin
          // DestroyHandle is protected so a typecast is required
          // to expose it.
          // The handles will be automatically recreated when needed.
          if (Pages[PageIndex] <> ActivePage) and (Pages[PageIndex] <>
            tabBoundaryConditionControls) then
            TMyWinControl(Pages[PageIndex]).DestroyHandle;
        end;
      end;
      {Release the Lock on the Form so any Form drawing can work}
      LockWindowUpdate(0);
    end;
  end;
  EnableSolverControls;
  SetPredefinedInversionParameters;
  jvfnUcodeChange(nil);

  comboStartSens.ItemIndex := 1;
  comboIntermedSens.ItemIndex := 0;
  comboFinalSens.ItemIndex := 1;
  comboMaxChangeRealm.ItemIndex := 0;
  comboScheduleType.ItemIndex := 0;

  rdgTimeSeries.Cells[0,0] := 'Time Step';
  rdgTimeSeries.Cells[1,0] := 'Elapsed Time';
  rdgTimeSeries.Cells[1,1] := '0.0';
  for Index := 1 to rdgTimeSeries.RowCount  -1 do
  begin
    rdgTimeSeries.Cells[0,Index] := IntToStr(Index-1);
  end;
  rdgTimeSeries.Row := 2;

  comboScheduleTypeChange(nil);
  comboTimeUnits.ItemIndex := 0;

  AdaptParserForUcode(UcodeParser);
  SpecialVariables:= TObjectList.Create;
end;

procedure TfrmSutra.EnableSutraIceTab;
var
  OldEnabled: integer;
  AValue: integer;
  Dummy: boolean;
begin
  {$IFDEF SutraIce}
  if lvChoices.Items[Ord(poSutraIce)] <> nil then
  begin
    OldEnabled := lvChoices.Items[Ord(poSutraIce)].ImageIndex;
    if EnergyUsed or rbSatUnsat.Checked then
    begin
      lvChoices.Items[Ord(poSutraIce)].ImageIndex := 0;
      if OldEnabled = 1 then
      begin
        if not Loading and Not Cancelling then
        begin
          if TryStrToInt(adeNUIREG.Text, AValue) then
          begin
            if AValue = 0 then
            begin
              adeNUIREG.Text := '1';
              adeNUIREGExit(nil);
              rdgFreezingEqSelectCell(nil, 1, 1, Dummy);
            end;
          end;
        end;
      end;
    end
    else
    begin
      lvChoices.Items[Ord(poSutraIce)].ImageIndex := 1;
    end;
  end;
  if lvChoices.Items[Ord(poFreezing)] <> nil then
  begin
    if rbFreezing.Checked then
    begin
      lvChoices.Items[Ord(poFreezing)].ImageIndex := 0;
    end
    else
    begin
      lvChoices.Items[Ord(poFreezing)].ImageIndex := 1;
    end;
  end;
  {$ELSE}
  if lvChoices.Items[Ord(poSutraIce)] <> nil then
  begin
    lvChoices.Items[Ord(poSutraIce)].ImageIndex := 1;
  end;
  if lvChoices.Items[Ord(poFreezing)] <> nil then
  begin
    lvChoices.Items[Ord(poFreezing)].ImageIndex := 1;
  end;
  {$ENDIF}
end;

procedure TfrmSutra.rbSoluteVarDensClick(Sender: TObject);
var
  Layer: T_ANE_InfoLayer;
begin
  inherited;

  {$IFDEF SutraIce}
    {$IFNDEF SUTRA22}
  cbCPANDS.Enabled := rbFreezing.Checked;
  cbCCORT.Enabled := rbFreezing.Checked;
  adeNBCFPR.Enabled := rbFreezing.Checked;
  adeNBCSPR.Enabled := rbFreezing.Checked;
  adeNBCPPR.Enabled := rbFreezing.Checked;
  adeNBCUPR.Enabled := rbFreezing.Checked;
  cbCINACT.Enabled := rbFreezing.Checked;

  adeCI.Enabled := rbFreezing.Checked;
  adeSIGMAI.Enabled := rbFreezing.Checked;
  adeRHOICE.Enabled := rbFreezing.Checked;
  adeHTLAT.Enabled := rbFreezing.Checked;
    {$ENDIF}
  {$ENDIF}

  EnableSutraIceTab;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2dUcodeConcentrationObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.RenameAllParameters := True;
  end;

  EnableGravControls;
  EnableComp;
  if rbSoluteVarDens.Checked then
  begin
    dgBoundaryCountsNew.Cells[0, 2] := 'Sources of Solute';
    dgBoundaryCountsNew.Cells[0, 3] := 'Specified Pressure';
    dgBoundaryCountsNew.Cells[0, 4] := 'Specified Concentration';
    frmParameterValues.FramInitPres.lblParameterName.Caption := 'Initial pressure';
    comboADSMOD.Enabled := True;
  end
  else if rbSoluteConstDens.Checked then
  begin
    dgBoundaryCountsNew.Cells[0, 2] := 'Sources of Solute';
    dgBoundaryCountsNew.Cells[0, 3] := 'Specified Head';
    dgBoundaryCountsNew.Cells[0, 4] := 'Specified Concentration';
    frmParameterValues.FramInitPres.lblParameterName.Caption := 'Initial head';
    comboADSMOD.Enabled := True;
  end
  else if EnergyUsed then
  begin
    dgBoundaryCountsNew.Cells[0, 2] := 'Sources of Energy';
    dgBoundaryCountsNew.Cells[0, 3] := 'Specified Pressure';
    dgBoundaryCountsNew.Cells[0, 4] := 'Specified Temperature';
    frmParameterValues.FramInitPres.lblParameterName.Caption := 'Initial pressure';
    comboADSMOD.ItemIndex := 0;
    comboADSMODChange(nil);
    comboADSMOD.Enabled := False;
  end;

  AdjustInitPerm;
  adeCW.Enabled := EnergyUsed or rbGeneral.Checked;
  {$IFNDEF SutraIce}
  adeCS.Enabled := EnergyUsed or rbGeneral.Checked;
  adeSIGMAS.Enabled := EnergyUsed or rbGeneral.Checked;
  {$ENDIF}
  adePRODF1.Enabled := not EnergyUsed or rbGeneral.Checked;
  btnPRODF1.Enabled := adePRODF1.Enabled;
  adePRODS1.Enabled := not EnergyUsed or rbGeneral.Checked;
  btnPRODS1.Enabled := adePRODS1.Enabled;
  SetPredefinedInversionParameters;

  adeRHOW0.Enabled := not rbSoluteConstDens.Checked;
  if not adeRHOW0.Enabled then
  begin
    adeRHOW0.Text := '1'
  end;

  adeURHOW0.Enabled := not rbSoluteConstDens.Checked;
  if not adeURHOW0.Enabled then
  begin
    adeURHOW0.Text := '0'
  end;

  adeDRWDU.Enabled := not rbSoluteConstDens.Checked;
  if not adeDRWDU.Enabled then
  begin
    adeDRWDU.Text := '0'
  end;

  {if not loading and not cancelling then
  begin
    case TransportType of
      ttGeneral:
        begin
          adeVISC0.Text := '1';
        end;
      ttEnergy:
        begin
          adeVISC0.Text := '1';
        end;
      ttSolute:
        begin
          if rbSoluteConstDens.Checked then
          begin
            adeVISC0.Text := '1';
          end
          else
          begin
            adeVISC0.Text := '0.001';
          end;
        end;
    end;
  end;  }

  adeVISC0.Enabled := not rbSoluteConstDens.Checked;

  adeCW.Enabled := EnergyUsed or rbGeneral.Checked;;
  if not adeCW.Enabled then
  begin
    adeCW.Text := '1'
  end;

  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
  SetTitles;
  
  if (EnteredControl = rbSoluteVarDens) or (EnteredControl = rbSoluteConstDens)
    or (EnteredControl = rbEnergy) or (EnteredControl = rbFreezing) then
  begin
    SetDefaults;
  end;
  AddOrRemoveLayers;
  SetPressureHeadExpressions;
  SetSoluteEnergyExpressions;

  AddOrRemoveParameters;
  AddOrRemoveMeshParameters;
  RefreshBoundaries;

  UpdateTreeNodeText;
  SetPredefinedInversionParameters;
  SetUnsaturatedExpressions;

{  if not loading and not cancelling then
  begin
    MessageDlg('Be sure to check all values related to fluid properties, '
      + 'solid matrix adsorption, production, and gravity to make sure '
      + 'all values are appropriate.', mtInformation, [mbOK], 0);
  end;   }
end;

procedure TfrmSutra.EnableConstDensity;
begin
  rbSoluteConstDens.enabled := rbSat.Checked and rbSpecific.Checked;
  if rbSoluteConstDens.Checked and not rbSoluteConstDens.enabled 
    and not Loading and not Cancelling then
  begin
        rbSoluteVarDens.Checked := True;
  end;
end;

procedure TfrmSutra.rbSatUnsatClick(Sender: TObject);
begin
  inherited;
  EnableConstDensity;
  EnableSutraIceTab;

  cbPreserveInverseModelParametersClick(nil);
  SetUnsaturatedExpressions;
  AddOrRemoveMeshParameters;

  cbPreserveInverseModelParametersClick(nil);
  adeObservationTimesExit(nil);
  if sicomboCSSFLO_and_CSSTRA.Enabled then
  begin
    {"You can't solve directly for unsaturated, steady-state flow in
    SUTRA because it's a nonlinear problem, and you can't use nonlinearity
    iterations on steady-state problems in SUTRA.
    You have to approach steady state using a transient simulation.
    (In a way, it amounts to the same sort of thing.)"

    Alden Provost Sept. 21, 2005
    }
    sicomboCSSFLO_and_CSSTRA.Enabled := rbSat.Checked;
    if not sicomboCSSFLO_and_CSSTRA.Enabled then
    begin
      // If unsaturated flow is simulated, only allow transient models.
      sicomboCSSFLO_and_CSSTRA.ItemIndex := 2;
      sicomboCSSFLO_and_CSSTRAChange(nil);
    end;
  end;


  if (EnteredControl = rbSatUnsat) or (EnteredControl = rbSat) then
  begin
    SetDefaults;
  end;
end;

procedure TfrmSutra.EnableTemporalControls;
begin
  inherited;
  if lvChoices.Items[Ord(poTemporal)] <> nil then
  begin
    if sicomboCSSFLO_and_CSSTRA.ItemIndex > 0 then
    begin
      lvChoices.Items[Ord(poTemporal)].ImageIndex := 0;
    end
    else
    begin
      lvChoices.Items[Ord(poTemporal)].ImageIndex := 1;
    end;
  end;

  if not loading and not cancelling then
  begin
    if sicomboCSSFLO_and_CSSTRA.ItemIndex = 2 then
    begin
      // transient flow
      adeNPCYC.Text := '1';
    end;
    if sicomboCSSFLO_and_CSSTRA.ItemIndex >= 1 then
    begin
      // transient transport
      adeNUCYC.Text := '1';
    end;
  end;

end;

procedure TfrmSutra.adeNPCYCExit(Sender: TObject);
begin
  inherited;
  if (adeNPCYC.Text <> '1') and not loading and not cancelling then
  begin
    adeNUCYC.Text := '1';
  end;
end;

procedure TfrmSutra.adeNUCYCExit(Sender: TObject);
begin
  inherited;
  if (adeNUCYC.Text <> '1') and not loading and not cancelling then
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
  adeCHI1.Enabled := (comboADSMOD.ItemIndex > 0);
  lblCHI1.Enabled := adeCHI1.Enabled;
  lblCHI1Desc.Enabled := adeCHI1.Enabled;

  adeCHI2.Enabled := (comboADSMOD.ItemIndex > 1);
  lblCHI2.Enabled := adeCHI2.Enabled;
  lblCHI2Desc.Enabled := adeCHI2.Enabled;

  SetPredefinedInversionParameters;
end;

procedure TfrmSutra.ReadValFile(
  var VersionInString: string; Path: string);
var
  UnreadData: TStringlist;
  AStringList: TStringList;
  Developer: string;
begin
  // called by GProjectNewSutra
  AStringList := TStringList.Create;
  UnreadData := TStringList.Create;
  try
    begin
      AStringList.LoadFromFile(Path);

      LoadSutraForm(UnreadData, AStringList.Text, VersionInString);

      SutraLayerStructure.FreeByStatus(sDeleted);
      SutraLayerStructure.SetStatus(sNormal);
      SutraLayerStructure.UpdateIndicies;
      SutraLayerStructure.UpdateOldIndicies;

      reProblem.Lines.Assign(UnreadData);
      if reProblem.Lines.Count > 0 then
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

  LoadForm(UnreadData, DataToRead, VersionInString, lblVersion);
  CreateUcodeFactorLayers;
  SetFunctionGridLabels;

  // in cases where ArgusDataEntries check maximum values,
  // re-enable the checks.
//  adeBoundLayerCount.CheckMin := True;
end;

procedure TfrmSutra.ModelComponentName(AStringList: TStringList);
begin
  AStringList.Add(edRunSutra.Name);
//  AStringList.Add(edSutraViewerPath.Name);
end;

procedure TfrmSutra.btnBrowseClick(Sender: TObject);
var
  CurrentDir: string;
begin
  inherited;
  CurrentDir := GetCurrentDir;
  try
    OpenDialog1.Filter :=
      'Executables (*.exe)|*.exe|Batch Files (*.bat)|*.bat|All Files (*.*)|*.*';
    if Sender = btnBrowse then
    begin
      OpenDialog1.FileName := edRunSutra.Text;
      if OpenDialog1.Execute then
      begin
        edRunSutra.Text := OpenDialog1.FileName;
      end;
    end
    else
    begin
      Assert(False);
    end;

  finally
    SetCurrentDir(CurrentDir);
  end;

end;

procedure TfrmSutra.btnOpenValClick(Sender: TObject);
var
  AStringList, UnreadData: TStringList;
  Path: string;
  VersionInString: string;
  Developer: string;
  DefaultDir: string;
begin
  inherited;
  DefaultDir := GetCurrentDir;

  try
    // first get the directory
    Path := DllAppDirectory(self.Handle, DLLName);
    if not DirectoryExists(Path) then
    begin
      CreateDirectoryAndParents(Path);
    end;

//  if not GetDllDirectory(DLLName, Path) then
//  begin
    // show an error message in the event of an error
//    Beep;
//    MessageDlg('Unable to find ' + DLLName, mtError, [mbOK], 0);
//  end
//  else
//  begin
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
              + 'the SUTRA PIE. It can not be read by the current '
              + 'version.', mtWarning, [mbOK], 0);
          end
          else
          begin
            // read the data from the file
            Loading := True;
            try
              LoadSutraForm(UnreadData, AStringList.Text, VersionInString);
            finally
              Loading := False;
            end;

            // put any unread data in reProblem
            reProblem.Lines.Assign(UnreadData);
            // if there are any probles show a warning message
            if reProblem.Lines.Count > 0 then
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
  finally
    SetCurrentDir(DefaultDir);
  end;
end;

procedure TfrmSutra.btnSaveValClick(Sender: TObject);
var
  AStringList: TStringList;
  Path: string;
  DefaultDir: string;
begin
  inherited;
  DefaultDir := GetCurrentDir;

  try
    // save val file
    // first get the directory
    Path := DllAppDirectory(self.Handle, DLLName);
    if not DirectoryExists(Path) then
    begin
      CreateDirectoryAndParents(Path);
    end;
//  if not GetDllDirectory(DLLName, Path) then
//  begin
    // show an error message in the event of an error
//    Beep;
//    MessageDlg('Unable to find ' + DLLName, mtError, [mbOK], 0);
//  end
//  else
//  begin
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
          // Set the stringlist text using the data in the frmSutra
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
//  end;
  finally
    SetCurrentDir(DefaultDir);
  end;
end;

procedure TfrmSutra.ReleaseMemory;
begin
  FreeAndNil(SpecialHandlingList);
  FreeVirtualMesh;
  FreeAndNil(SutraLayerStructure);
  FreeAndNil(SimulationTimes);
  FreeAndNil(XVar);
  FreeAndNil(YVar);
  FreeAndNil(SpecialVariables);
  FreeAndNil(UcodeCompiler);
  FreeAndNil(FEquationFrameList);
  inherited;
end;

procedure TfrmSutra.FormDestroy(Sender: TObject);
begin
  ReleaseMemory;
  inherited;
end;

function TfrmSutra.TransportType: TTransportType;
begin
  if rbGeneral = nil then
  begin
    result := ttSolute;
  end
  else if rbGeneral.Checked and OldModel then
  begin
    result := ttGeneral;
  end
  else if EnergyUsed then
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
  if (rbSpecific = nil) or (rbSoluteConstDens = nil) then
  begin
    result := svHead;
  end
  else if rbSpecific.Checked and rbSoluteConstDens.Checked then
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

procedure TfrmSutra.SetlblGNUP_Desc_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        lblGNUP_Desc.Caption := kPressure;
      end;
    svHead:
      begin
        lblGNUP_Desc.Caption := kHead;
      end;
  else
    begin
      Assert(False);
    end;
  end;
  lblGNUP_Desc.Caption := CapitalizeFirst(lblGNUP_Desc.Caption)
    + ' boundary-condition factor';
end;

procedure TfrmSutra.SetlblGNUU_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblGNUU_Desc.Caption := kConcOrTemp
      end;
    ttEnergy:
      begin
        lblGNUU_Desc.Caption := kTemperature;
      end;
    ttSolute:
      begin
        lblGNUU_Desc.Caption := kConcentration;
      end;
  else
    begin
      Assert(False);
    end;
  end;
  lblGNUU_Desc.Caption := CapitalizeFirst(lblGNUU_Desc.Caption)
    + ' boundary-condition factor';
end;

procedure TfrmSutra.SetlblNPCYC_Desc_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        lblNPCYC_Desc.Caption := 'Number of time steps in ' + kPressure +
          ' solution cycle';
      end;
    svHead:
      begin
        lblNPCYC_Desc.Caption := 'Number of time steps in ' + kHead +
          ' solution cycle';
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
        lblNUCYC_Desc.Caption := 'Number of time steps in ' + kConcOrTemp
          + ' solution cycle';
      end;
    ttEnergy:
      begin
        lblNUCYC_Desc.Caption := 'Number of time steps in ' + kTemperature
          + ' solution cycle';
      end;
    ttSolute:
      begin
        lblNUCYC_Desc.Caption := 'Number of time steps in ' + kConcentration
          + ' solution cycle';
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
        gbEnergySoluteProduction.Caption := 'Production of ' + KEnergyOrSolute
          + ' -> dataset 12';
      end;
    ttEnergy:
      begin
        gbEnergySoluteProduction.Caption := 'Production of ' + kEnergy
          + ' -> dataset 12';
      end;
    ttSolute:
      begin
        gbEnergySoluteProduction.Caption := 'Production of ' + kSolute
          + ' -> dataset 12';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

procedure TfrmSutra.SetrgInitialValuesItems;
var
  Value1, Value2, Value3, Value4: string;
begin
  case StateVariableType of
    svPressure:
      begin
        Value1 := 'read neither the ' + kPressure + ' nor the ';
        Value2 := 'read the ' + kPressure + ' from the restart file';
        Value4 := 'read both the ' + kPressure + ' and the '
      end;
    svHead:
      begin
        Value1 := 'read neither the ' + kHead + ' nor the ';
        Value2 := 'read the ' + kHead + ' from the restart file';
        Value4 := 'read both the ' + kHead + ' and the '
      end;
  else
    begin
      Assert(False);
    end;
  end;

  case TransportType of
    ttGeneral:
      begin
        Value1 := Value1 + KConcTemp + ' from the restart file';
        Value3 := 'read the ' + KConcTemp + ' from the restart file';
        Value4 := Value4 + KConcTemp + ' from the restart file';
      end;
    ttEnergy:
      begin
        Value1 := Value1 + kTemperature + ' from the restart file';
        Value3 := 'read the ' + kTemperature + ' from the restart file';
        Value4 := Value4 + kTemperature + ' from the restart file';
      end;
    ttSolute:
      begin
        Value1 := Value1 + kConcentration + ' from the restart file';
        Value3 := 'read the ' + kConcentration + ' from the restart file';
        Value4 := Value4 + kConcentration + ' from the restart file';
      end;
  else
    begin
      Assert(False);
    end;
  end;
  rgInitialValues.Items[0] := Value1;
  rgInitialValues.Items[1] := Value2;
  rgInitialValues.Items[2] := Value3;
  rgInitialValues.Items[3] := Value4;
end;

procedure TfrmSutra.SetrgInterpolateInitialValuesItems;
var
  Value1, Value2, Value3, Value4: string;
begin
  case StateVariableType of
    svPressure:
      begin
        Value1 := 'interpolate neither the ' + kPressure + ' nor the ';
        Value2 := 'interpolate the ' + kPressure + ' from the restart file';
        Value4 := 'interpolate both the ' + kPressure + ' and the '
      end;
    svHead:
      begin
        Value1 := 'interpolate neither the ' + kHead + ' nor the ';
        Value2 := 'interpolate the ' + kHead + ' from the restart file';
        Value4 := 'interpolate both the ' + kHead + ' and the '
      end;
  else
    begin
      Assert(False);
    end;
  end;

  case TransportType of
    ttGeneral:
      begin
        Value1 := Value1 + KConcTemp + ' from the restart file';
        Value3 := 'interpolate the ' + KConcTemp + ' from the restart file';
        Value4 := Value4 + KConcTemp + ' from the restart file';
      end;
    ttEnergy:
      begin
        Value1 := Value1 + kTemperature + ' from the restart file';
        Value3 := 'interpolate the ' + kTemperature + ' from the restart file';
        Value4 := Value4 + kTemperature + ' from the restart file';
      end;
    ttSolute:
      begin
        Value1 := Value1 + kConcentration + ' from the restart file';
        Value3 := 'interpolate the ' + kConcentration +
          ' from the restart file';
        Value4 := Value4 + kConcentration + ' from the restart file';
      end;
  else
    begin
      Assert(False);
    end;
  end;
  rgInterpolateInitialValues.Items[0] := Value1;
  rgInterpolateInitialValues.Items[1] := Value2;
  rgInterpolateInitialValues.Items[2] := Value3;
  rgInterpolateInitialValues.Items[3] := Value4;
end;

procedure TfrmSutra.SetcbKELMNT_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        cbCELMNT.Caption := 'Print element ' + kPermeabilities +
          ' and dispersivities';
      end;
    svHead:
      begin
        cbCELMNT.Caption := 'Print element ' + kHydraulicConductivities +
          ' and dispersivities';
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
        cbCBUDG.Caption := 'Print fluid mass and ' + KEnergyOrSolute +
          ' budgets';
      end;
    ttEnergy:
      begin
        cbCBUDG.Caption := 'Print fluid mass and ' + kEnergy + ' budgets';
      end;
    ttSolute:
      begin
        cbCBUDG.Caption := 'Print fluid mass and ' + kSolute + ' budgets';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

procedure TfrmSutra.SetlblRUMAX_Desc_Caption;
begin
  inherited;
  case TransportType of
    ttGeneral:
      begin
        lblRUMAX_Desc.Caption :=
          'Absolute iteration convergence criterion for transport solution'
      end;
    ttEnergy:
      begin
        lblRUMAX_Desc.Caption := 'Absolute iteration convergence criterion for '
          + kHeat + ' solution'
      end;
    ttSolute:
      begin
        lblRUMAX_Desc.Caption := 'Absolute iteration convergence criterion for '
          + kSolute + ' solution'
      end;
  else
    Assert(False);
  end;

end;

procedure TfrmSutra.SetlblRPMAX_Desc_Caption;
begin
  inherited;
  case StateVariableType of
    svPressure:
      begin
        lblRPMAX_Desc.Caption := 'Absolute iteration convergence criterion for '
          + kPressure + ' solution';
      end;
    svHead:
      begin
        lblRPMAX_Desc.Caption := 'Absolute iteration convergence criterion for '
          + kHead + ' solution';
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
        lblRHOW0_Desc.Caption := 'Density of fluid at base ' + kConcOrTemp;
      end;
    ttEnergy:
      begin
        lblRHOW0_Desc.Caption := 'Density of fluid at base ' + kTemperature;
      end;
    ttSolute:
      begin
        lblRHOW0_Desc.Caption := 'Density of fluid at base ' + kConcentration;
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
        lblURHOW0_Desc.Caption := 'Base value of ' + kConcOrTemp;
      end;
    ttEnergy:
      begin
        lblURHOW0_Desc.Caption := 'Base value of ' + kTemperature;
      end;
    ttSolute:
      begin
        lblURHOW0_Desc.Caption := 'Base value of ' + kConcentration;
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
        lblDRWDU_Desc.Caption := 'Fluid coefficient of density change with '
          + kConcOrTemp;
      end;
    ttEnergy:
      begin
        lblDRWDU_Desc.Caption := 'Fluid coefficient of density change with '
          + kTemperature;
      end;
    ttSolute:
      begin
        lblDRWDU_Desc.Caption := 'Fluid coefficient of density change with '
          + kConcentration;
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
  lblVISC0_Desc.Width := 313;
  case TransportType of
    ttGeneral:
      begin
        lblVISC0_Desc.Caption := 'For solute transport: Fluid viscosity.'
          + Chr(10) + Chr(13) +
          'For energy transport: Viscosity units scaling factor.';
      end;
    ttEnergy:
      begin
        lblVISC0_Desc.Caption := 'Viscosity units scaling factor';
      end;
    ttSolute:
      begin
        lblVISC0_Desc.Caption := 'Fluid viscosity';
      end;
  else
    begin
      Assert(False);
    end;
  end;
  lblVISC0_Desc.Top := adeVISC0.Top +
    (adeVISC0.Height - lblVISC0_Desc.Height) div 2
end;

procedure TfrmSutra.SetlblSigmawDesc_Caption;
begin
  inherited;
  lblSigmawDesc.Width := gbBaseProperties.Width - lblSigmawDesc.Left - 8;
  case TransportType of
    ttGeneral:
      begin
        lblSigmawDesc.Caption :=
          'For solute transport: Apparent diffusivity (diffusion coefficient) of solute in fluid'
//          Diffusivity of solute in fluid'
          + Chr(10) + Chr(13) +
          'For energy transport: Thermal conductivity of fluid';
      end;
    ttEnergy:
      begin
        lblSigmawDesc.Caption := 'Thermal conductivity of fluid';
      end;
    ttSolute:
      begin
        lblSigmawDesc.Caption := 'Apparent diffusivity (diffusion coefficient) of solute in fluid';
        //'Diffusivity of solute in fluid';
      end;
  else
    begin
      Assert(False);
    end;
  end;
  lblSigmawDesc.Top := adeSIGMAW.Top +
    (adeSIGMAW.Height - lblSigmawDesc.Height) div 2
end;

procedure TfrmSutra.SetrgTransportSolver_Caption;
begin
  case TransportType of
    ttGeneral:
      begin
        rgTransportSolver.Caption :=
          'Transport solution solver: CSOLVU -> dataset 7C'
      end;
    ttEnergy:
      begin
        rgTransportSolver.Caption := CapitalizeFirst(kHeat) +
          ' solution solver: CSOLVU -> dataset 7C'
      end;
    ttSolute:
      begin
        rgTransportSolver.Caption := CapitalizeFirst(kSolute) +
          ' solution solver: CSOLVU -> dataset 7C'
      end;
  else
    Assert(False);
  end;
end;

procedure TfrmSutra.SetlblITRMXU_Desc_Caption;
begin
  case TransportType of
    ttGeneral:
      begin
        lblITRMXU_Desc.Caption :=
          'Maximum number of solver iterations during transport solution';
      end;
    ttEnergy:
      begin
        lblITRMXU_Desc.Caption := 'Maximum number of solver iterations during '
          + kTemperature + ' solution';
      end;
    ttSolute:
      begin
        lblITRMXU_Desc.Caption := 'Maximum number of solver iterations during '
          + kConcentration + ' solution';
      end;
  else
    Assert(False);
  end;
end;

procedure TfrmSutra.SetlblTOLU_Desc_Caption;
begin
  case TransportType of
    ttGeneral:
      begin
        lblTOLU_Desc.Caption := 'Convergence tolerance for solver iterations '
          + 'during transport solution';
      end;
    ttEnergy:
      begin
        lblTOLU_Desc.Caption := 'Convergence tolerance for solver iterations '
          + 'during ' + kTemperature + ' solution';
      end;
    ttSolute:
      begin
        lblTOLU_Desc.Caption := 'Convergence tolerance for solver iterations '
          + 'during ' + kConcentration + ' solution';
      end;
  else
    Assert(False);
  end;
end;

procedure TfrmSutra.SetgbDensityDependence_Caption;
begin
  case TransportType of
    ttGeneral:
      begin
        gbDensityDependence.Caption := 'Properties controlling dependence of '
          + 'density on concentration or temperature';
      end;
    ttEnergy:
      begin
        gbDensityDependence.Caption := 'Properties controlling dependence of '
          + 'density on ' + kTemperature;
      end;
    ttSolute:
      begin
        gbDensityDependence.Caption := 'Properties controlling dependence of '
          + 'density on ' + kConcentration;
      end;
  else
    Assert(False);
  end;
end;

procedure TfrmSutra.SetlblSIGMAS_Caption;
begin
  case TransportType of
    ttGeneral:
      begin
        lblSIGMAS.Caption := 'Solid grain diffusivity or thermal conductivity'
      end;
    ttEnergy:
      begin
        lblSIGMAS.Caption := 'Solid grain thermal conductivity';
      end;
    ttSolute:
      begin
        lblSIGMAS.Caption := 'Solid grain diffusivity';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

procedure TfrmSutra.SetSoluteHeatCaptions;
begin
  SetlblGNUU_Desc_Caption;
  SetlblNUCYC_Desc_Caption;
  SetgbEnergySoluteProduction_Caption;
  SetcbKBUDG_Caption;
  SetlblRHOW0_Desc_Caption;
  SetlblURHOW0_Desc_Caption;
  SetlblDRWDU_Desc_Caption;
  SetlblVISC0_Desc_Caption;
  SetlblSigmawDesc_Caption;
  SetlblRUMAX_Desc_Caption;
  SetrgTransportSolver_Caption;
  SetlblITRMXU_Desc_Caption;
  SetlblTOLU_Desc_Caption;
  SetFramInitTempConcLabelCaption;
  SetrgInitialValuesItems;
  SetrgInterpolateInitialValuesItems;
  SetgbDensityDependence_Caption;
  SetSicomboCSSFLO_and_CSSTRA_Items;
  SetlblSIGMAS_Caption;
end;

procedure TfrmSutra.SetPressureHeadCaptions;
begin
  SetlblGNUP_Desc_Caption;
  SetlblNPCYC_Desc_Caption;
  SetcbKELMNT_Caption;
  SetlblRPMAX_Desc_Caption;
  SetrgInitialValuesItems;
  SetrgInterpolateInitialValuesItems;
end;

procedure TfrmSutra.SetFramInitTempConcLabelCaption;
begin
  case TransportType of
    ttGeneral:
      begin
        frmParameterValues.FramInitTempConc.lblParameterName.Caption :=
          'Initial concentration or temperature';
      end;
    ttEnergy:
      begin
        frmParameterValues.FramInitTempConc.lblParameterName.Caption := 'Initial ' + kTemperature;
      end;
    ttSolute:
      begin
        frmParameterValues.FramInitTempConc.lblParameterName.Caption := 'Initial ' +
          kConcentration;
      end;
  else
    Assert(False);
  end;
end;

procedure TfrmSutra.rgPressureSolverNewClick(Sender: TObject);
begin
  inherited;
  if rgPressureSolverNew.ItemIndex = 0 then
  begin
    rgTransportSolver.ItemIndex := 0;
  end
  else if rgTransportSolver.ItemIndex = 0 then
  begin
    rgTransportSolver.ItemIndex := 1;
  end;
  adeITRMXP.Enabled := rgPressureSolverNew.ItemIndex > 0;
  adeTOLP.Enabled := rgPressureSolverNew.ItemIndex > 0;
  adeFracUpstreamWeight.Enabled := rgPressureSolverNew.ItemIndex <> 1;
  if not Loading and Not Cancelling and not adeFracUpstreamWeight.Enabled then
  begin
    try
      if StrToFloat(adeFracUpstreamWeight.Text) <> 0 then
      begin
        Beep;
        MessageDlg('Upstream weighting has been set to 0 as required by the '
          + 'CG solver', mtInformation, [mbOK], 0);
      end;
      adeFracUpstreamWeight.Text := '0';
    except on EConvertError do
      begin
        adeFracUpstreamWeight.Text := '0';
      end;
    end;
  end;

end;

procedure TfrmSutra.rgTransportSolverClick(Sender: TObject);
begin
  inherited;
  if rgTransportSolver.ItemIndex = 0 then
  begin
    rgPressureSolverNew.ItemIndex := 0;
  end
  else if rgPressureSolverNew.ItemIndex = 0 then
  begin
    rgPressureSolverNew.ItemIndex := rgPressureSolverNew.ItemIndex + 1;
  end;
  adeITRMXU.Enabled := rgTransportSolver.ItemIndex > 0;
//  adeITOLU.Enabled := rgTransportSolver.ItemIndex > 0;
  adeTOLU.Enabled := rgTransportSolver.ItemIndex > 0;
//  adeNSAVEU.Enabled := rgTransportSolver.ItemIndex > 0;
end;

procedure TfrmSutra.SetGeoGridHeaders;
var
  Index: integer;
begin
  inherited;
  sgGeology.Cells[0, 0] := 'Unit Number';
  sgGeology.Cells[1, 0] := 'Name';
  sgGeology.Cells[2, 0] := 'Z Discretization (number of elements)';
  sgGeology.Cells[3, 0] := 'Element growth rate';
  sgGeology.Cells[4, 0] := 'Growth type';
  for Index := 1 to sgGeology.RowCount - 1 do
  begin
    sgGeology.Cells[0, Index] := FloatToStr(Index);
  end;

end;

procedure TfrmSutra.InitializeGeoGrid;
var
  Index: integer;
begin
  inherited;
  SetGeoGridHeaders;
  for Index := 1 to sgGeology.RowCount - 1 do
  begin
    sgGeology.Cells[1, Index] := 'Unit' + FloatToStr(Index);
    sgGeology.Cells[2, Index] := '1';
    sgGeology.Cells[3, Index] := '1';
    sgGeology.Cells[4, Index] := sgGeology.Columns[4].PickList[1];
  end;

end;

procedure TfrmSutra.AddNodeToTree(RowIndex: integer; var ANode: TTreeNode);
  // add a node as the last node in the tree.
var
  AName: string;
  ParentCheckNode, ChildCheckNode: TTreeNode;
begin
  ParentCheckNode := rctreeBoundaries.Items.AddChild(nil, 'Unit ' + IntToStr(RowIndex));
  ParentCheckNode.Data := nil;
  ParentCheckNode.StateIndex := 1;

  AName := TBottomFluidSourcesLayer.WriteNewRoot + IntToStr(RowIndex);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomFluidSourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSoluteEnergySourcesLayer.WriteNewRoot + IntToStr(RowIndex);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSoluteEnergySourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSpecifiedPressureLayer.WriteNewRoot + IntToStr(RowIndex);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSpecifiedPressureLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSpecConcTempLayer.WriteNewRoot + IntToStr(RowIndex);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSpecConcTempLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomObservationLayer.WriteNewRoot + IntToStr(RowIndex);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomObservationLayer;
  ChildCheckNode.StateIndex := 1;
end;

procedure TfrmSutra.adeVertDiscExit(Sender: TObject);
var
  NewNumberOfUnits: integer;
  RowIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
  MeshLayer: T_ANE_QuadMeshLayer;
  AParameterList: T_ANE_IndexedParameterList;
  ANode: TTreeNode;
begin
  inherited;
  if is3D then
  begin

    if Loading then
    begin
      OldNumberOfUnits := 0;
    end;
    NewNumberOfUnits := StrToInt(adeVertDisc.Text);

    MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

    if OldNumberOfUnits > NewNumberOfUnits then
    begin
      sgGeology.RowCount := NewNumberOfUnits + 1;
      if Sender <> btnDelete then
      begin
        for RowIndex := OldNumberOfUnits {-1} downto NewNumberOfUnits + 1 do
        begin
          ALayerList := SutraLayerStructure.ListsOfIndexedLayers.
            GetNonDeletedIndLayerListByIndex(RowIndex);
          if ALayerList <> nil then
          begin
            ALayerList.DeleteSelf;
          end;
          if MeshLayer <> nil then
          begin
            AParameterList := MeshLayer.IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(RowIndex);
            if AParameterList <> nil then
            begin
              AParameterList.DeleteSelf;
            end;
          end;
        end;
      end;
    end
    else if OldNumberOfUnits < NewNumberOfUnits then
    begin
      sgGeology.RowCount := NewNumberOfUnits + 1;
      ANode := nil;
      for RowIndex := OldNumberOfUnits + 1 to NewNumberOfUnits do
      begin
        if not Loading and not cancelling then
        begin
          sgGeology.Cells[1, RowIndex] := GetUnitName(
            'Unit' + IntToStr(RowIndex), RowIndex);
          sgGeology.Cells[2, RowIndex] := '1';
          sgGeology.Cells[3, RowIndex] := '1';
        end;
        if sgGeology.Cells[3, RowIndex] = '' then
        begin
          sgGeology.Cells[3, RowIndex] := '1';
        end;
        if sgGeology.Cells[4, RowIndex] = '' then
        begin
          if RowIndex > 1 then
          begin
            sgGeology.Cells[4, RowIndex] := sgGeology.Cells[4, RowIndex-1];
          end
          else
          begin
            sgGeology.Cells[4, RowIndex] := sgGeology.Columns[4].PickList[1];;
          end;
        end;

        if (Sender <> btnInsert) and
          ((not Loading and not Cancelling) or
            (RowIndex <> OldNumberOfUnits + 1))
          and (rctreeBoundaries.Items.Count < NewNumberOfUnits * 6 + 5) then
        begin
          AddNodeToTree(RowIndex, ANode);
        end;
      end;

      for RowIndex := OldNumberOfUnits + 1 to NewNumberOfUnits + 1 do
      begin
        if Sender <> btnInsert then
        begin
          if SutraLayerStructure.ListsOfIndexedLayers.Count > RowIndex then
          begin
            ALayerList :=
              SutraLayerStructure.ListsOfIndexedLayers.Items[RowIndex];
            ALayerList.UnDeleteSelf;
          end
          else
          begin
          end;
          if MeshLayer <> nil then
          begin
            if MeshLayer.IndexedParamList1.Count > RowIndex then
            begin
              AParameterList := MeshLayer.IndexedParamList1.Items[RowIndex];
              AParameterList.UnDeleteSelf;
            end
            else
            begin
            end;
          end;
        end;
      end;
    end;
    // Other stuff here

    SetGeoGridHeaders;
    btnDelete.Enabled := NewNumberOfUnits > 1;

    sgGeologySetEditText(Sender, Ord(ghDiscretization), sgGeology.RowCount - 1,
      sgGeology.Cells[Ord(ghDiscretization), sgGeology.RowCount - 1]);

    GetNodeAndElementCounts;
    sgGeology.Invalidate;
  end;
  if Sender <> btnInsert then
  begin
    AddOrRemoveMeshParameters;
  end;
end;

procedure TfrmSutra.AddOrRemoveMeshParameters;
var
  MeshLayer: T_ANE_QuadMeshLayer;
  Index: integer;
  Limit: integer;
  ParamList: T_ANE_ParameterList;
  LayerList: T_ANE_IndexedLayerList;
  MeshLayerList: T_ANE_IndexedLayerList;
begin
  if Is3D then
  begin
    MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

    Limit := StrToInt(adeVertDisc.Text);
    for Index := 0 to Limit-1 do
    begin
      LayerList := SutraLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(Index);

      if (LayerList = nil) then
      begin
        LayerList := TSutraGeoUnit.Create(SutraLayerStructure.
          ListsOfIndexedLayers, -1);
      end;

      LayerList.AddOrRemoveLayer(TSutraUnitGroupLayer, True);
      LayerList.AddOrRemoveLayer(TSutraHydrogeologyGroupLayer, True);
      LayerList.AddOrRemoveLayer(TBottomGroupLayer, True);
      LayerList.AddOrRemoveLayer(TThicknessLayer, True);
      LayerList.AddOrRemoveLayer(TPorosityLayer, True);
      {$IFDEF SutraIce}
      LayerList.AddOrRemoveLayer(TSpecificHeatLayer,
        (rbFreezing.Checked or rbEnergy.Checked));
      LayerList.AddOrRemoveLayer(TThermalConductivityLayer,
        (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}

      LayerList.AddOrRemoveLayer(TPermeabilityLayer, True);
      LayerList.AddOrRemoveLayer(TDispersivityLayer, True);
      LayerList.AddOrRemoveLayer(TUnsaturatedLayer,
        (rbGeneral.Checked or rbFreezing.Checked or rbSatUnsat.Checked));

      LayerList.AddOrRemoveLayer(TSutraInitialConditionsGroupLayer, True);
      LayerList.AddOrRemoveLayer(TInitialPressureLayer, True);
      LayerList.AddOrRemoveLayer(TInitialConcTempLayer, True);

    end;
    for Index := 0 to Limit do
    begin
      MeshLayerList := SutraLayerStructure.ZerothListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(Index);

      if MeshLayerList = nil then
      begin
        MeshLayerList := TSutraMeshGeoUnit.Create(SutraLayerStructure.
          ZerothListsOfIndexedLayers, -1);
      end;

      MeshLayerList.AddOrRemoveLayer(TSutraMeshLayer, frmSutra.MorphedMesh);
      MeshLayerList.AddOrRemoveLayer(TFishnetMeshLayout, frmSutra.MorphedMesh
        and (rbGeneral.Checked or rbFishnet.Checked));

      if rb3D_nva.Checked then
      begin
        MeshLayer := MeshLayerList.GetLayerByName
          (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;
        ParamList := MeshLayer.ParamList;
      end
      else
      begin
        ParamList := MeshLayer.IndexedParamList1.
          GetNonDeletedIndParameterListByIndex(Index);
        if ParamList = nil then
        begin
          ParamList := TSutraNodeLayerParameters.Create(
            MeshLayer.IndexedParamList1, Index);
        end;
      end;

      ParamList.AddOrRemoveParameter(TNREGParam, TNREGParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TPORParam, TPORParam.ANE_ParamName,
        Index <> Limit);
      {$IFDEF SutraIce}
      ParamList.AddOrRemoveParameter(TCS1Parameter, TCS1Parameter.ANE_ParamName,
        (Index <> Limit) and (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}
      ParamList.AddOrRemoveParameter(TLREGParam, TLREGParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TPMAXParam, TPMAXParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TPMIDParam, TPMIDParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TPMINParam, TPMINParam.ANE_ParamName,
        Index <> Limit);
      {$IFDEF SutraIce}
      ParamList.AddOrRemoveParameter(TSIGS, TSIGS.ANE_ParamName,
        (Index <> Limit) and (rbFreezing.Checked or rbEnergy.Checked));
      {$ENDIF}

      ParamList.AddOrRemoveParameter(TANGLE1Param, TANGLE1Param.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TANGLE2Param, TANGLE2Param.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TANGLE3Param, TANGLE3Param.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TALMAXParam, TALMAXParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TALMIDParam, TALMIDParam.ANE_ParamName,
        Index <> Limit);

      ParamList.AddOrRemoveParameter(TALMINParam, TALMINParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TAT1MAXParam, TAT1MAXParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TAT1MIDParam, TAT1MIDParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TAT1MINParam, TAT1MINParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TPVECParam, TPVECParam.ANE_ParamName,
        Index <> Limit);
      ParamList.AddOrRemoveParameter(TUVECParam, TUVECParam.ANE_ParamName,
        Index <> Limit);
    end;
  end;
end;

procedure TfrmSutra.sgGeologySetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  CellValue: integer;
  GrowthRate: double;
begin
  inherited;
  if (ACol = Ord(ghDiscretization)) and (ARow >= sgGeology.FixedRows) then
  begin
    try
      if sgGeology.Cells[ACol, ARow] <> '' then
      begin
        CellValue := StrToInt(sgGeology.Cells[ACol, ARow]);
        if CellValue < 1 then
        begin
          if not loading and not cancelling then
          begin
            Beep;
          end;
          sgGeology.Cells[ACol, ARow] := '1';
        end;
        GetNodeAndElementCounts;
      end;
    except on EConvertError do
      begin
        if not loading and not cancelling then
        begin
          Beep;
        end;
        sgGeology.Cells[ACol, ARow] := OldVertDiscretization;
      end;
    end;
  end;
  if (ACol = Ord(ghGrowthRate)) and (ARow >= sgGeology.FixedRows) then
  begin
    try
      if sgGeology.Cells[ACol, ARow] <> '' then
      begin
        GrowthRate := InternationalStrToFloat(sgGeology.Cells[ACol, ARow]);
        if GrowthRate <= 0 then
        begin
          if not loading and not cancelling then
          begin
            Beep;
          end;
          sgGeology.Cells[ACol, ARow] := '1';
        end;
      end;
    except on EConvertError do
      begin
        if not loading and not cancelling then
        begin
          Beep;
        end;
        sgGeology.Cells[ACol, ARow] := OldGrowthRate;
      end;
    end;
  end;
end;

procedure TfrmSutra.adeVertDiscEnter(Sender: TObject);
begin
  inherited;
  OldNumberOfUnits := StrToInt(adeVertDisc.Text);
end;

procedure TfrmSutra.btnAddClick(Sender: TObject);
begin
  inherited;
  adeVertDiscEnter(Sender);
  adeVertDisc.Text := IntToStr(1 + StrToInt(adeVertDisc.Text));
  adeVertDiscExit(Sender);
end;

procedure TfrmSutra.DeleteNodesFromTree(CurrentRow: integer);
const
  FirstOffset = 5;
var
  Index: integer;
  ParentCheckNode: TTreeNode;
  NextParentCheckNode: TTreeNode;
  FirstUnitCheckChild, NextUnitCheckChild: TTreeNode;
  StateIndex: integer;
begin
  ParentCheckNode := rctreeBoundaries.Items.GetFirstNode;

  if CurrentRow = 1 then
  begin
    NextParentCheckNode := ParentCheckNode.GetNextSibling;
    FirstUnitCheckChild := ParentCheckNode.GetFirstChild;
    for Index := 0 to FirstOffset-1 do
    begin
      FirstUnitCheckChild := FirstUnitCheckChild.GetNextSibling;
    end;

    NextUnitCheckChild := NextParentCheckNode.GetFirstChild;
    FirstUnitCheckChild.StateIndex := NextUnitCheckChild.StateIndex;

    for Index := 1 to 4 do
    begin
      FirstUnitCheckChild := FirstUnitCheckChild.GetNextSibling;
      NextUnitCheckChild := NextUnitCheckChild.GetNextSibling;
      FirstUnitCheckChild.StateIndex := NextUnitCheckChild.StateIndex;
    end;

    FirstUnitCheckChild := ParentCheckNode.GetFirstChild;
    StateIndex := FirstUnitCheckChild.StateIndex;
    FirstUnitCheckChild := FirstUnitCheckChild.GetNextSibling;
    while FirstUnitCheckChild <> nil do
    begin
      if StateIndex <> FirstUnitCheckChild.StateIndex then
      begin
        StateIndex := 3;
      end;
      FirstUnitCheckChild := FirstUnitCheckChild.GetNextSibling;
    end;
    ParentCheckNode.StateIndex := StateIndex;

    ParentCheckNode := NextParentCheckNode;
  end
  else
  begin
    for Index := 1 to CurrentRow - 1 do
    begin
      ParentCheckNode := ParentCheckNode.GetNextSibling
    end;
  end;
  rctreeBoundaries.Items.Delete(ParentCheckNode);
end;

procedure TfrmSutra.btnDeleteClick(Sender: TObject);
const
  FirstOffset = 5;
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
  MeshLayer: T_ANE_QuadMeshLayer;
  AParameterList: T_ANE_IndexedParameterList;
begin
  inherited;
  // get the currently selected fow.
  CurrentRow := sgGeology.Selection.Top;

  ALayerList := SutraLayerStructure.ListsOfIndexedLayers.
    GetNonDeletedIndLayerListByIndex(CurrentRow - 1);
  ALayerList.DeleteSelf;

  MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
    (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

  if MeshLayer <> nil then
  begin
    AParameterList := MeshLayer.IndexedParamList1.
      GetNonDeletedIndParameterListByIndex(CurrentRow - 1);
    if AParameterList <> nil then
    begin
      AParameterList.DeleteSelf;
    end;
  end;

  // If a row is selected in dtabGeol, proceed
  if CurrentRow >= 0 then
  begin
    // Copy data in sgMOC3DTransParam to their new positions.
    for RowIndex := CurrentRow + 1 to sgGeology.RowCount - 1 do
    begin
      for ColIndex := 1 to sgGeology.ColCount - 1 do
      begin
        sgGeology.Cells[ColIndex, RowIndex - 1]
          := sgGeology.Cells[ColIndex, RowIndex];
      end;
    end;
  end;
  adeVertDiscEnter(Sender);
  adeVertDisc.Text := IntToStr(StrToInt(adeVertDisc.Text) - 1);
  adeVertDiscExit(Sender);

  DeleteNodesFromTree(CurrentRow);

  UpdateTreeNodeText;

  sgGeology.Invalidate;
end;

procedure TfrmSutra.InsertNodeInTree(CurrentRow: integer);
const
  FirstOffset = 6;
var
  Index: integer;
  AName: string;
  ParentCheckNode: TTreeNode;
  ChildCheckNode: TTreeNode;
  NextUnitParentCheckNode: TTreeNode;
  NextUnitChildCheckNode: TTreeNode;
  StateIndex: integer;
begin
  ParentCheckNode := rctreeBoundaries.Items.GetFirstNode;
  if CurrentRow <> 1 then
  begin
    for Index := 1 to CurrentRow - 2 do
    begin
      ParentCheckNode := ParentCheckNode.getNextSibling;
    end;
  end;

  ParentCheckNode := ParentCheckNode.getNextSibling;
  if ParentCheckNode = nil then
  begin
    ParentCheckNode := rctreeBoundaries.Items.AddChild(nil, 'Unit ' + IntToStr(CurrentRow));
  end
  else
  begin
    ParentCheckNode := rctreeBoundaries.Items.Insert(ParentCheckNode,'Unit ' + IntToStr(CurrentRow));
  end;
  ParentCheckNode.Data := nil;
  ParentCheckNode.StateIndex := 1;

  AName := TBottomFluidSourcesLayer.WriteNewRoot + IntToStr(CurrentRow);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomFluidSourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSoluteEnergySourcesLayer.WriteNewRoot + IntToStr(CurrentRow);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSoluteEnergySourcesLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSpecifiedPressureLayer.WriteNewRoot + IntToStr(CurrentRow);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSpecifiedPressureLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomSpecConcTempLayer.WriteNewRoot + IntToStr(CurrentRow);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomSpecConcTempLayer;
  ChildCheckNode.StateIndex := 1;

  AName := TBottomObservationLayer.WriteNewRoot + IntToStr(CurrentRow);
  ChildCheckNode := rctreeBoundaries.Items.AddChild(ParentCheckNode, AName);
  ChildCheckNode.Data := TBottomObservationLayer;
  ChildCheckNode.StateIndex := 1;

  if CurrentRow = 1 then
  begin
    ParentCheckNode := rctreeBoundaries.Items.GetFirstNode;
    NextUnitParentCheckNode := ParentCheckNode.getNextSibling;

    ChildCheckNode := ParentCheckNode.GetNext;

    for Index := 1 to 5 do
    begin
      ChildCheckNode := ChildCheckNode.GetNext;
    end;

    NextUnitChildCheckNode := NextUnitParentCheckNode.GetNext;
    NextUnitChildCheckNode.StateIndex := ChildCheckNode.StateIndex;
    ChildCheckNode.StateIndex := 1;

    StateIndex := NextUnitChildCheckNode.StateIndex;
    for Index := 1 to 4 do
    begin
      ChildCheckNode := ChildCheckNode.GetNext;
      NextUnitChildCheckNode := NextUnitChildCheckNode.GetNext;
      NextUnitChildCheckNode.StateIndex := ChildCheckNode.StateIndex;
      ChildCheckNode.StateIndex := 1;
      if StateIndex <> NextUnitChildCheckNode.StateIndex then
      begin
        StateIndex := 3;
      end;
    end;
    NextUnitParentCheckNode.StateIndex := StateIndex;

    ChildCheckNode := ParentCheckNode.getFirstChild;
    StateIndex := ChildCheckNode.StateIndex;
    ChildCheckNode := ChildCheckNode.getNextSibling;
    while ChildCheckNode <> nil do
    begin
      if StateIndex <> ChildCheckNode.StateIndex then
      begin
        StateIndex := 3;
        break;
      end;
      ChildCheckNode := ChildCheckNode.getNextSibling;
    end;
    ParentCheckNode.StateIndex := StateIndex;
  end;
end;

procedure TfrmSutra.btnInsertClick(Sender: TObject);
const
  FirstOffset = 5;
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
  PositionToInsert: integer;
  ALayerList: T_ANE_IndexedLayerList;
  MeshLayer: T_ANE_QuadMeshLayer;
begin
  inherited;
  btnAddClick(Sender);
  CurrentRow := sgGeology.Selection.Top;

  ALayerList := SutraLayerStructure.ListsOfIndexedLayers.
    GetNonDeletedIndLayerListByIndex(CurrentRow - 1);
  PositionToInsert := SutraLayerStructure.ListsOfIndexedLayers.
    IndexOf(ALayerList);
  TSutraGeoUnit.Create(SutraLayerStructure.ListsOfIndexedLayers,
    PositionToInsert);

  MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
    (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

  if MeshLayer <> nil then
  begin
    TSutraNodeLayerParameters.Create(MeshLayer.IndexedParamList1,
      PositionToInsert)
  end;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  if CurrentRow >= 0 then
  begin
    for RowIndex := sgGeology.RowCount - 2 downto CurrentRow do
    begin
      // number the first column
      sgGeology.Cells[0, RowIndex] := IntToStr(RowIndex);
      // copy data to latter row.
      for ColIndex := 1 to sgGeology.ColCount - 1 do
      begin
        sgGeology.Cells[ColIndex, RowIndex + 1] := sgGeology.Cells[ColIndex,
          RowIndex];
      end;
    end;
  end;
  sgGeology.Cells[1, CurrentRow] := GetUnitName('Unit' + IntToStr(CurrentRow),
    CurrentRow);

  InsertNodeInTree(CurrentRow);

  UpdateTreeNodeText;

  sgGeology.Cells[2, CurrentRow] := '1';
  sgGeology.Invalidate;
  AddOrRemoveMeshParameters;
end;

procedure TfrmSutra.rb3D_nvaClick(Sender: TObject);
var
  Index: integer;
  ALayerList: T_ANE_IndexedLayerList;
  ShouldEnable: boolean;
  Count: integer;
  Limit: integer;
begin
  inherited;

  if (Sender <> rbGeneral) and (Sender <> rbSpecific) then
  begin
    EnableGravControls;
  end;

  ShouldEnable := Is3D or rbGeneral.Checked
    or (rbSpecific.Checked and not rbAreal.Checked);

  EnableTransportConditionControls;

//  rbIrregular.Enabled := not Is3d {$IFDEF Irreg3D_Meshes} or True {$ENDIF};
  rbIrregular.Enabled := True;
  if not rbIrregular.Enabled then
  begin
    rbFishnet.Checked;
  end;

  if Is3D then
  begin
    rbSatUnsat.Enabled := ShouldEnable;
  end;

  if (dimensions = sd2d) and not Loading and not cancelling and Is3D then
  begin
    for Index := 0 to StrToInt(adeVertDisc.Text) - 1 do
    begin
      if SutraLayerStructure.ListsOfIndexedLayers.Count > Index then
      begin
        ALayerList := SutraLayerStructure.ListsOfIndexedLayers.Items[Index];
        ALayerList.UnDeleteSelf
      end
      else
      begin
        TSutraGeoUnit.Create(SutraLayerStructure.ListsOfIndexedLayers, -1);
      end;
      if SutraLayerStructure.ZerothListsOfIndexedLayers.Count > Index then
      begin
        ALayerList := SutraLayerStructure.ZerothListsOfIndexedLayers.
          Items[Index];
        ALayerList.UnDeleteSelf
      end
      else
      begin
        TSutraMeshGeoUnit.Create(SutraLayerStructure.
          ZerothListsOfIndexedLayers, -1);
      end;
    end;
  end;

  dimensions := sd3d;
  if Is3D then
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 0;
    end;
  end
  else
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 1;
    end;
  end;
  if (lvChoices.Items[Ord(poStructZ)] <> nil)
    and (lvChoices.Items[Ord(po3D)] <> nil) then
  begin
    lvChoices.Items[Ord(po3D)].ImageIndex :=
      lvChoices.Items[Ord(poStructZ)].ImageIndex;
  end;

  if not cancelling then
  begin
    SutraLayerStructure.ZerothListsOfIndexedLayers.AddOrRemoveLayer
      (TSutraMeshLayer, MorphedMesh);
    SutraLayerStructure.ZerothListsOfIndexedLayers.AddOrRemoveLayer
      (TFishnetMeshLayout, rbGeneral.Checked
      or rbFishnet.Checked);

    Limit := StrToInt(adeVertDisc.Text);

    Count := -1;
    for Index := 0 to SutraLayerStructure.ListsOfIndexedLayers.Count - 1 do
    begin
      ALayerList := SutraLayerStructure.ListsOfIndexedLayers.Items[Index];
      if ALayerList.Status <> sDeleted then
      begin
        Inc(Count);
        ALayerList.AddOrRemoveUnIndexedParameter
          (TPermeabilityLayer, TMidPermeabilityParam, Is3D
          and (Count <> Limit));
        ALayerList.AddOrRemoveUnIndexedParameter
          (TPermeabilityLayer, THorizPermeabilityAngleParam, Is3D
          and (Count <> Limit));
        ALayerList.AddOrRemoveUnIndexedParameter
          (TPermeabilityLayer, TVertPermeabilityAngleParam, Is3D
          and (Count <> Limit));
        ALayerList.AddOrRemoveUnIndexedParameter
          (TPermeabilityLayer, TRotPermeabilityAngleParam, Is3D
          and (Count <> Limit));
        ALayerList.AddOrRemoveUnIndexedParameter
          (TDispersivityLayer, TMidLongDispParam, Is3D
          and (Count <> Limit));
        ALayerList.AddOrRemoveUnIndexedParameter
          (TDispersivityLayer, TMidTransDisp1Param, Is3D
          and (Count <> Limit));
      end;
    end;
  end;

  AddOrRemoveLayers;
  AddOrRemoveParameters;

  AddOrRemoveMeshParameters;

  RefreshBoundaries;
  if (EnteredControl = rb3D_nva) or (EnteredControl = rb3D_va) then
  begin
    SetDefaults;
  end;
end;

function TfrmSutra.MakeVirtualMesh: boolean;
var
  Discretization: TIntegerList;
  GrowthRates: TRealList;
  Index: integer;
  GrowthTypes: TGrowthTypeArray;
  GrowthTypeIndex: integer;
begin
  result := True;
  try
    Discretization := TIntegerList.Create;
    GrowthRates := TRealList.Create;
    try
      SetLength(GrowthTypes, sgGeology.RowCount);
      for Index := 1 to sgGeology.RowCount - 1 do
      begin
        Discretization.Add(StrToInt(sgGeology.Cells
          [Ord(ghDiscretization), Index]));
        { TODO : Specify growth rates and types here. }
        GrowthRates.Add(InternationalStrToFloat(sgGeology.Cells
          [Ord(ghGrowthRate), Index]));
        GrowthTypeIndex := sgGeology.Columns[Ord(ghGrowthType)].PickList.
          IndexOf(sgGeology.Cells[Ord(ghGrowthType), Index]);
        if (GrowthTypeIndex >= 0) and (GrowthTypeIndex <= Ord(High(TGrowthType))) then
        begin
          GrowthTypes[Index-1] := TGrowthType(GrowthTypeIndex);
        end
        else
        begin
          GrowthTypes[Index-1] := gtNone;
        end;
      end;
      Discretization.Add(1);
      GrowthRates.Add(1);
      GrowthTypes[sgGeology.RowCount-1] := gtNone;

      MorphMesh := nil;

      VirtualMesh := TVirtual3DMesh.Create(CurrentModelHandle, Discretization,
        GrowthRates, GrowthTypes, MorphMesh);
    finally
      Discretization.Free;
      GrowthRates.Free;
    end;
  except
    on E: Exception do
    begin
      Beep;
      result := False;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.FreeVirtualMesh: boolean;
begin
  result := True;
  try
    try
      MorphMesh.Free(CurrentModelHandle);
      MorphMesh := nil;
    except on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
        result := False;
      end;
    end;
  finally
    try
      VirtualMesh.Free(CurrentModelHandle);
      VirtualMesh := nil;
    except on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
        result := False;
      end;
    end;
  end;

end;

function TfrmSutra.ParsePorosity: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPORParam.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

{$IFDEF SutraIce}
function TfrmSutra.ParseCs1: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TCS1Parameter.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;
{$ENDIF}

function TfrmSutra.GetMorphedNodeValue(NodeIndex: integer; Expression: string):
  ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetMorphedNodeValue(CurrentModelHandle, NodeIndex,
      Expression);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.ParseInitialPressure: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPVECParam.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.ParseInitialConcentration: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TUVECParam.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.ParseFloatExpression(Expression: string): boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, Expression, pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.ParsePermMaximum: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPMAXParam.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.ParsePermMinimum: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPMINParam.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.ParsePermMiddle: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPMIDParam.WriteParamName,
      pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.GetMorphedElementValue(ElementIndex: integer;
  Expression: string): ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetMorphedElementValue(CurrentModelHandle,
      ElementIndex, Expression);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetMorphedElementAngleValue(ElementIndex: integer;
  Expression: string): ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetMorphedElementAngleValue(CurrentModelHandle,
      ElementIndex, Expression);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetCountOfAUnit(const UnitIndex: integer): Integer;
begin
  Assert(UnitIndex < sgGeology.RowCount);
  result := StrToInt(sgGeology.Cells[Ord(ghDiscretization), UnitIndex]);
end;

function TfrmSutra.GetLayerCount: Integer;
var
  Index: integer;
begin
  try
    if dimensions = sd2d then
    begin
      result := 1;
    end
    else
    begin
      result := 0;
      for Index := 1 to sgGeology.RowCount - 1 do
      begin
        if sgGeology.Cells[Ord(ghDiscretization), Index] <> '' then
        begin
          result := result + GetCountOfAUnit(Index);
        end;
      end;
      Inc(Result);
    end;
  except on E: Exception do
    begin
      result := 0;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetXValue(NodeIndex: integer): ANE_DOUBLE;
begin
  result := 0;
  try
    CurrentVertex := VirtualMesh.VirtualNodes[NodeIndex];
    result := CurrentVertex.X;
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetYValue(NodeIndex: integer): ANE_DOUBLE;
begin
  result := 0;
  try
    CurrentVertex := VirtualMesh.VirtualNodes[NodeIndex];
    result := CurrentVertex.Y;
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetZValue(NodeIndex: integer): ANE_DOUBLE;
begin
  result := 0;
  try
    CurrentVertex := VirtualMesh.VirtualNodes[NodeIndex];
    result := CurrentVertex.Z;
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmSutra.sgGeologyExit(Sender: TObject);
var
  DisCol: integer;
  GrowthCol: integer;
  ARow: integer;
  CellValue: integer;
  GrowthRate: double;
begin
  inherited;
  DisCol := Ord(ghDiscretization);
  GrowthCol := Ord(ghGrowthRate);
  for ARow := sgGeology.FixedRows to sgGeology.RowCount - 1 do
  begin
    try
      begin
        if Trim(sgGeology.Cells[DisCol, ARow]) = '' then
        begin
          sgGeology.Cells[DisCol, ARow] := '1';
        end
        else
        begin
          CellValue := StrToInt(sgGeology.Cells[DisCol, ARow]);
          if CellValue < 1 then
          begin
            sgGeology.Cells[DisCol, ARow] := '1';
          end;
        end;
      end;
    except on EConvertError do
      begin
        sgGeology.Cells[DisCol, ARow] := OldVertDiscretization;
      end;
    end;

    try
      begin
        if Trim(sgGeology.Cells[GrowthCol, ARow]) = '' then
        begin
          sgGeology.Cells[GrowthCol, ARow] := '1';
        end
        else
        begin
          GrowthRate := InternationalStrToFloat(sgGeology.Cells[GrowthCol, ARow]);
          if GrowthRate <= 0 then
          begin
            sgGeology.Cells[GrowthCol, ARow] := '1';
          end;
        end;
      end;
    except on EConvertError do
      begin
        sgGeology.Cells[GrowthCol, ARow] := OldGrowthRate;
      end;
    end;


  end;

end;

function TfrmSutra.GetN(var MultipleUnits: Boolean): string;
begin
  if not Is3D then
  begin
    result := '';
    MultipleUnits := False;
  end
  else
  begin
    if VerticallyAlignedMesh then
    begin
      result := IntToStr(StrToInt(adeVertDisc.Text));
    end
    else
    begin
      result := '0';
    end;
    MultipleUnits := True;
  end;
end;

procedure TfrmSutra.edRunSutraChange(Sender: TObject);
var
  AnEdit: TEdit;
begin
  inherited;
  if Sender is TEdit then
  begin
    AnEdit := Sender as TEdit;
    if FileExists(AnEdit.Text) then
    begin
      AnEdit.Color := clWindow;
    end
    else
    begin
      AnEdit.Color := clRed;
    end;
  end
  else
  begin
    ShowMessage('problem');
  end;
end;

function TfrmSutra.GetPIEVersion(AControl: Tcontrol): string;
begin
  // called by FormCreate

  // this function extracts to PIE version number from the TVersionLabel

  result := TLabel(AControl).Caption;
end;

procedure TfrmSutra.AssignHelpFile(FileName: string);
var
  DllDirectory: string;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + FileName;
    if not FileExists(HelpFile) then
    begin
      Beep;
      ShowMessage(HelpFile + ' not found.');
    end;
  end
  else
  begin
    Beep;
    ShowMessage(DLLName + ' not found.');
  end;
end;


procedure TfrmSutra.FormShow(Sender: TObject);
begin
  inherited;
  EnableSutraIceTab;

  ShouldAskY := True;
  ShouldAskZ := True;
  cbInverseClick(nil);
  if reProblem.Lines.Count > 0 then
  begin
    if lvChoices.Items[Ord(poProblem)] <> nil then
    begin
      lvChoices.Items[Ord(poProblem)].ImageIndex := 0;
    end;
    pgcontrlMain.ActivePage := tabProblem;
  end;

  if Is3D then
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 0;
    end;
  end
  else
  begin
    if lvChoices.Items[Ord(poStructZ)] <> nil then
    begin
      lvChoices.Items[Ord(poStructZ)].ImageIndex := 1;
    end;
  end;
  if (lvChoices.Items[Ord(poStructZ)] <> nil)
    and (lvChoices.Items[Ord(po3D)] <> nil) then
  begin
    lvChoices.Items[Ord(po3D)].ImageIndex :=
      lvChoices.Items[Ord(poStructZ)].ImageIndex;
  end;

  if lvChoices.Items[Ord(poTemporal)] <> nil then
  begin
    if (sicomboCSSFLO_and_CSSTRA.ItemIndex >= 1) then
    begin
      // transient flow or tranport
      lvChoices.Items[Ord(poTemporal)].ImageIndex := 0;
    end
    else
    begin
      lvChoices.Items[Ord(poTemporal)].ImageIndex := 1;
    end;
  end;

  if (lvChoices.Items.Count > pgcontrlMain.ActivePageIndex)
    and (pgcontrlMain.ActivePageIndex >= 0) then
  begin
    if not lvChoices.Items[pgcontrlMain.ActivePageIndex].Selected then
    begin
      lvChoices.Items[pgcontrlMain.ActivePageIndex].Selected := True;
    end;
  end;
  FocusControl(lvChoices);
end;

procedure TfrmSutra.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if ModalResult <> mrOK then
  begin
    Cancelling := True;
  end;
end;

function TfrmSutra.Is3D: boolean;
begin
  result := (rgDimensions <> nil) and (rgDimensions.ItemIndex = 1);
end;

function TfrmSutra.MorphedMesh: boolean;
begin
  result := Is3D and rb3D_nva.Checked;
end;

function TfrmSutra.VerticallyAlignedMesh: boolean;
begin
  result := Is3D and rb3D_va.Checked;
end;

procedure TfrmSutra.UncheckAllNodesInTree;
var
  CheckNode: TTreeNode;
begin
  CheckNode := rctreeBoundaries.Items.GetFirstNode;
  while CheckNode <> nil do
  begin
    CheckNode.StateIndex := 1;
    CheckNode := CheckNode.GetNext;
  end;
end;

procedure TfrmSutra.rgDimensionsClick(Sender: TObject);
var
  ThisIs3D: boolean;
begin
  inherited;
  ThisIs3D := Is3D;
  if not Loading and not Cancelling and ThisIs3D then
  begin
    rb3D_va.Checked := True;
  end;

  frmParameterValues.adeThickness.Enabled := rgDimensions.ItemIndex = 0;
  frmParameterValues.btnSetThicknessValue.Enabled := not NewProject and frmParameterValues.adeThickness.Enabled;

{$IFNDEF Sutra2d}
  rbAreal.Enabled := rbSpecific.Checked and not ThisIs3D;
  rbCrossSection.Enabled := rbSpecific.Checked and not ThisIs3D;
  rb3D_va.Enabled := ThisIs3D;
  rb3D_nva.Enabled := ThisIs3D;
{$ENDIF}

  if (rgDimensions.ItemIndex = 1) then
  begin // 3D

    rbFishnet.Caption := 'FISHNET (a deformable grid of hexahedrals)';
    rbUserSpecifiedThickness.Enabled := False;
    rbCylindrical.Enabled := False;
//    {$IFDEF Irreg3D_Meshes}
      rbIrregular.Enabled := True;
//    {$ELSE}
//      rbIrregular.Enabled := False;
//    {$ENDIF}
    lblGRAVZ.Visible := True;
    adeGRAVZ.Visible := True;
    lblGRAVZCaption.Visible := True;
    rgInterpolateInitialValues.Enabled := True;
    frmParameterValues.FramLongDispMid.Enabled := True;
    frmParameterValues.FramTransvDisp1Mid.Enabled := True;
  end
  else
  begin // 2D
    rbFishnet.Caption := 'FISHNET (a deformable grid of quadrilaterals)';
    rbUserSpecifiedThickness.Enabled := True;
    rbCylindrical.Enabled := True;
    rbIrregular.Enabled := True;
    lblGRAVZ.Visible := False;
    adeGRAVZ.Visible := False;
    lblGRAVZCaption.Visible := False;
    rgInterpolateInitialValues.Enabled := False;
    frmParameterValues.FramLongDispMid.Enabled := False;
    frmParameterValues.FramTransvDisp1Mid.Enabled := False;
  end;

  EnableTransportConditionControls;

  if not rbIrregular.Enabled and rbIrregular.Checked
    and not Loading and not Cancelling then
  begin
    rbFishnet.Checked := True;
  end;

  if (rgDimensions.ItemIndex = 1) and not Loading and not Cancelling then
  begin
    rbAreal.Checked := False;
    rbCrossSection.Checked := False;
  end
  else
  begin
    if not Loading and not Cancelling then
    begin
      rb3D_va.Checked := False;
      rb3D_nva.Checked := False;
    end;
  end;

  if (rgDimensions.ItemIndex = 1) then
  begin
    rb3D_nvaClick(Sender);
  end
  else
  begin
    rbArealClick(Sender);
  end;

  frmParameterValues.FramDMidHydCond.Enabled := ThisIs3D;
  frmParameterValues.FramDMidHydCond.btnSetValue.Enabled := frmParameterValues.FramDMidHydCond.Enabled and not
    NewProject;

  frmParameterValues.FramPermAngleVertical.Enabled := frmParameterValues.FramDMidHydCond.Enabled;
  frmParameterValues.FramPermAngleVertical.btnSetValue.Enabled := frmParameterValues.FramPermAngleVertical.Enabled and
    not NewProject;

  frmParameterValues.FramPermAngleRotational.Enabled := frmParameterValues.FramDMidHydCond.Enabled;
  frmParameterValues.FramPermAngleRotational.btnSetValue.Enabled := frmParameterValues.FramPermAngleRotational.Enabled
    and not NewProject;

  frmParameterValues.FramLongDispMid.Enabled := frmParameterValues.FramDMidHydCond.Enabled;
  frmParameterValues.FramLongDispMid.btnSetValue.Enabled := frmParameterValues.FramLongDispMid.Enabled and not
    NewProject;

  frmParameterValues.FramTransvDisp1Mid.Enabled := frmParameterValues.FramDMidHydCond.Enabled;
  frmParameterValues.FramTransvDisp1Mid.btnSetValue.Enabled := frmParameterValues.FramTransvDisp1Mid.Enabled and not
    NewProject;

  if (EnteredControl = rgDimensions) then
  begin
    SetDefaults;
  end;
  SetTitles;
  SetAllBoundaryCounts;
  AddOrRemoveMeshParameters;

  if (rgDimensions.ItemIndex = 0) and not Loading and not Cancelling then
  begin

    UncheckAllNodesInTree;
  end;
end;

procedure TfrmSutra.SetTitles;
var
  ThisIs3D: boolean;
  LabelWidth: integer;
begin                                
  LabelWidth := frmParameterValues.FramPor.Width - frmParameterValues.FramPor.lblParameterName.Left - 4;
  ThisIs3D := Is3D;
  if ThisIs3D then
  begin
    if StateVariableType = svPressure then
    begin
      frmParameterValues.FramTransvDispMax.lblParameterName.Caption :=
        'Transverse dispersivity in maximum permeability direction';
      frmParameterValues.FramTransvDispMax.lblParameterName.Width := LabelWidth;

      frmParameterValues.FramTransvDispMin.lblParameterName.Caption :=
        'Transverse dispersivity in minimum permeability direction';
      frmParameterValues.FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end
    else
    begin
      frmParameterValues.FramTransvDispMax.lblParameterName.Caption :=
        'Transverse dispersivity in maximum hydraulic conductivity direction';
      frmParameterValues.FramTransvDispMax.lblParameterName.Width := LabelWidth;

      frmParameterValues.FramTransvDispMin.lblParameterName.Caption :=
        'Transverse dispersivity in minimum  hydraulic conductivity direction';
      frmParameterValues.FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end;
  end
  else
  begin
    if StateVariableType = svPressure then
    begin
      frmParameterValues.FramTransvDispMax.lblParameterName.Caption :=
        'Transverse dispersivity in maximum permeability direction';
      frmParameterValues.FramTransvDispMax.lblParameterName.Width := LabelWidth;

      frmParameterValues.FramTransvDispMin.lblParameterName.Caption :=
        'Transverse dispersivity in minimum permeability direction';
      frmParameterValues.FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end
    else
    begin
      frmParameterValues.FramTransvDispMax.lblParameterName.Caption :=
        'Transverse dispersivity in maximum hydraulic conductivity direction';
      frmParameterValues.FramTransvDispMax.lblParameterName.Width := LabelWidth;

      frmParameterValues.FramTransvDispMin.lblParameterName.Caption :=
        'Transverse dispersivity in minimum hydraulic conductivity direction';
      frmParameterValues.FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end;
  end;
  if StateVariableType = svPressure then
  begin
    frmParameterValues.FramDMaxHydCond.lblParameterName.Caption := 'Maximum permeability';
    frmParameterValues.FramDMaxHydCond.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramDMinHydCond.lblParameterName.Caption := 'Minimum permeability';
    frmParameterValues.FramDMinHydCond.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramPermAngleXY.lblParameterName.Caption := 'Permeability angle';
    frmParameterValues.FramPermAngleXY.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramPermAngleVertical.lblParameterName.Caption :=
      'Vertical permeability angle';
    frmParameterValues.FramPermAngleVertical.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramPermAngleRotational.lblParameterName.Caption :=
      'Rotational permeability angle';
    frmParameterValues.FramPermAngleRotational.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramDMidHydCond.lblParameterName.Caption := 'Middle permeability';
    frmParameterValues.FramDMidHydCond.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramLongDispMax.lblParameterName.Caption :=
      'Longitudinal dispersivity in maximum permeability direction';
    frmParameterValues.FramLongDispMax.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramLongDispMin.lblParameterName.Caption :=
      'Longitudinal dispersivity in minimum permeability direction';
    frmParameterValues.FramLongDispMin.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramLongDispMid.lblParameterName.Caption :=
      'Longitudinal dispersivity in middle permeability direction';
    frmParameterValues.FramLongDispMid.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramTransvDisp1Mid.lblParameterName.Caption :=
      'Transverse dispersivity in middle permeability direction';
    frmParameterValues.FramTransvDisp1Mid.lblParameterName.Width := LabelWidth;
  end
  else
  begin
    frmParameterValues.FramDMaxHydCond.lblParameterName.Caption :=
      'Maximum hydraulic conductivity';
    frmParameterValues.FramDMaxHydCond.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramDMinHydCond.lblParameterName.Caption :=
      'Minimum hydraulic conductivity';
    frmParameterValues.FramDMinHydCond.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramPermAngleXY.lblParameterName.Caption := 'Hydraulic conductivity angle';
    frmParameterValues.FramPermAngleXY.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramPermAngleVertical.lblParameterName.Caption :=
      'Vertical hydraulic conductivity angle';
    frmParameterValues.FramPermAngleVertical.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramPermAngleRotational.lblParameterName.Caption :=
      'Rotational hydraulic conductivity angle';
    frmParameterValues.FramPermAngleRotational.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramDMidHydCond.lblParameterName.Caption := 'Middle hydraulic conductivity';
    frmParameterValues.FramDMidHydCond.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramLongDispMax.lblParameterName.Caption :=
      'Longitudinal dispersivity in maximum hydraulic conductivity direction';
    frmParameterValues.FramLongDispMax.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramLongDispMin.lblParameterName.Caption :=
      'Longitudinal dispersivity in minimum hydraulic conductivity direction';
    frmParameterValues.FramLongDispMin.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramLongDispMid.lblParameterName.Caption :=
      'Longitudinal dispersivity in middle hydraulic conductivity direction';
    frmParameterValues.FramLongDispMid.lblParameterName.Width := LabelWidth;

    frmParameterValues.FramTransvDisp1Mid.lblParameterName.Caption :=
      'Transverse dispersivity in middle hydraulic conductivity direction';
    frmParameterValues.FramTransvDisp1Mid.lblParameterName.Width := LabelWidth;
  end;

end;

procedure TfrmSutra.FixRealsOnExit(Sender: TObject);
var
  AnArgusDataEntry: TArgusDataEntry;
begin
  inherited;
  AnArgusDataEntry := Sender as TArgusDataEntry;
  if (Pos(DecimalSeparator, AnArgusDataEntry.Text) = 0) and
    (Pos('e', AnArgusDataEntry.Text) = 0) and
    (Pos('E', AnArgusDataEntry.Text) = 0) then
  begin
    AnArgusDataEntry.Text := AnArgusDataEntry.Text + DecimalSeparator;
  end;
end;

procedure TfrmSutra.cbNodeElementNumbersClick(Sender: TObject);
begin
  inherited;
  if cbNodeElementNumbers.Checked then
  begin
    MessageDlg('Note: Model Viewer requires that node and element numbers NOT '
      + 'be printed in the .nod and .ele files.', mtInformation, [mbOK], 0);
  end;
end;

procedure TfrmSutra.AdjustInitPerm;
begin
  SetTitles;
  if StateVariableType = svPressure then
  begin
    if frmParameterValues.FramDMaxHydCond.adeProperty.Text = '1.0E-3' then
    begin
      frmParameterValues.FramDMaxHydCond.adeProperty.Text := '1.0E-10'
    end;
    if frmParameterValues.FramDMinHydCond.adeProperty.Text = '1.0E-3' then
    begin
      frmParameterValues.FramDMinHydCond.adeProperty.Text := '1.0E-10'
    end;
    if frmParameterValues.FramDMidHydCond.adeProperty.Text = '1.0E-3' then
    begin
      frmParameterValues.FramDMidHydCond.adeProperty.Text := '1.0E-10'
    end;
  end
  else
  begin
    if frmParameterValues.FramDMaxHydCond.adeProperty.Text = '1.0E-10' then
    begin
      frmParameterValues.FramDMaxHydCond.adeProperty.Text := '1.0E-3'
    end;
    if frmParameterValues.FramDMinHydCond.adeProperty.Text = '1.0E-10' then
    begin
      frmParameterValues.FramDMinHydCond.adeProperty.Text := '1.0E-3'
    end;
    if frmParameterValues.FramDMidHydCond.adeProperty.Text = '1.0E-10' then
    begin
      frmParameterValues.FramDMidHydCond.adeProperty.Text := '1.0E-3'
    end;
  end;
end;

procedure TfrmSutra.SetMeshDomainNames;
var
  MeshLayer: T_ANE_QuadMeshLayer;
  Index: integer;
  MeshLayerList : T_ANE_IndexedLayerList;
begin
  MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
    (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;
  if MeshLayer <> nil then
  begin
    MeshLayer.DomainLayer := TSutraDomainOutline.WriteNewRoot;
    MeshLayer.DensityLayer := TSutraMeshDensity.WriteNewRoot;
  end;
  for Index := 0 to SutraLayerStructure.ZerothListsOfIndexedLayers.Count - 1 do
  begin
    MeshLayerList := SutraLayerStructure.ZerothListsOfIndexedLayers.Items[Index];
    MeshLayer := MeshLayerList.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;
    if MeshLayer <> nil then
    begin
      MeshLayer.DomainLayer := TSutraDomainOutline.WriteNewRoot;
      MeshLayer.DensityLayer := TSutraMeshDensity.WriteNewRoot;
    end;
  end;

end;

procedure TfrmSutra.EnableSolverControls;
//var
//  Index: integer;
begin
  {for Index := 1 to rgPressureSolverNew.ComponentCount -1 do
  begin
    (rgPressureSolverNew.Components[Index] as TRadioButton).Enabled :=
      rbFishnet.Checked;
  end;}
  {for Index := 1 to rgTransportSolver.ComponentCount -1 do
  begin
    (rgTransportSolver.Components[Index] as TRadioButton).Enabled :=
      rbFishnet.Checked;
  end;}

  {if not Loading and not Cancelling then
  begin
    if not rbFishnet.Checked then
    begin
      rgPressureSolverNew.ItemIndex := 0;
      rgTransportSolver.ItemIndex := 0;
    end;
  end;   }
end;

procedure TfrmSutra.rbFishnetClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveLayers;
  AddOrRemoveMeshParameters;
  SetMeshDomainNames;
  EnableSolverControls;
end;

procedure TfrmSutra.ReadOldNPCYC(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  DataToRead[LineIndex] := IntToStr(Round(StrToFloat(DataToRead[LineIndex])));
  ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, adeNPCYC, DataToRead,
    VersionControl)
end;

procedure TfrmSutra.ReadOldNUCYC(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  DataToRead[LineIndex] := IntToStr(Round(StrToFloat(DataToRead[LineIndex])));
  ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, adeNUCYC, DataToRead,
    VersionControl)
end;

procedure TfrmSutra.ReadOldFishnet(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  ARadioButton: TRadioButton;
  AText: string;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ARadioButton := rbIrregular;
  if not (ARadioButton = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(ARadioButton.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(ARadioButton.Name) = -1)) then
  begin
    if Assigned(ARadioButton.OnEnter) then
    begin
      ARadioButton.OnEnter(ARadioButton);
    end;
    if AText = '0' then
    begin
      ARadioButton.Checked := False;
    end
    else
    begin
      ARadioButton.Checked := True;
    end;
    rbFishnet.Checked := not ARadioButton.Checked;
    if Assigned(ARadioButton.OnClick) then
    begin
      ARadioButton.OnClick(ARadioButton);
    end;
    if Assigned(ARadioButton.OnExit) then
    begin
      ARadioButton.OnExit(ARadioButton);
    end;
  end;

end;

procedure TfrmSutra.EnableTransportConditionControls;
begin
  if not rbSoluteConstDens.Enabled and rbSoluteConstDens.Checked
    and not Loading and not Cancelling then
  begin
    rbSoluteVarDens.Checked := True;
  end;

  rbSoluteVarDens.Enabled := Is3D or rbGeneral.Checked or
    (rbSpecific.Checked and not rbAreal.Checked);
  if not rbSoluteVarDens.Enabled and rbSoluteVarDens.Checked
    and not Loading and not Cancelling then
  begin
    rbSoluteConstDens.Checked := True;
  end;

  rbEnergy.Enabled := Is3D or rbGeneral.Checked or
    (rbSpecific.Checked and not rbAreal.Checked);
{$IFDEF SutraIce}
  rbFreezing.Enabled := rbEnergy.Enabled;
{$ENDIF}
  if not rbEnergy.Enabled and (rbEnergy.Checked or rbFreezing.Checked)
    and not Loading and not Cancelling then
  begin
    if rbSoluteVarDens.Enabled then
    begin
      rbSoluteVarDens.Checked := True;
    end
    else
    begin
      rbSoluteConstDens.Checked := True;
    end;
  end;

end;

procedure TfrmSutra.btnOKClick(Sender: TObject);
begin
  inherited;

  if rbSpecific.Checked and not (rbAreal.Checked or rbCrossSection.Checked
    or rb3D_va.Checked or rb3D_nva.Checked) then
  begin
    Beep;
    pgcontrlMain.ActivePage := tabConfiguration;
    MessageDlg('You forgot to choose the orientation of the model. You need '
      + 'to make a choice before closing this dialog box.', mtWarning, [mbOK],
      0);

    ModalResult := mrNone;
    Exit;
  end;
  JustStartedProject := False;
  SetAllBoundaryCounts;
  UpdateExpressions;

  if rgInterpolateInitialValues.ItemIndex = 0 then
  begin
    FreeAndNil(ElementInterp);
  end;
  CreateUcodeFactorLayers;
  SetLength(ArgusFactors, 0);
  SetLength(UcodeParameters, 0);
end;

procedure TfrmSutra.SetDefaults;
var
  NewValue: string;
begin
  if not Loading and not Cancelling then
  begin
    frmChangeValues := TfrmChangeValues.Create(Application);
    try

      if rbGeneral.Checked then
      begin
        if rbSoluteVarDens.Checked then
        begin
          NewValue := '1.0e-9';
        end
        else if EnergyUsed then
        begin
          NewValue := '0.6';
        end;
        frmChangeValues.AddValueToChange(adeSIGMAW, lblSigmawDesc, NewValue);
        if adeCOMPFL.Enabled then
        begin
          frmChangeValues.AddValueToChange(adeCOMPFL, lblCOMPFLCaption, '4.47e-10');
        end
        else
        begin
          adeCOMPFL.Text := '4.47e-10'
        end;

        if adeCOMPMA.Enabled then
        begin
          frmChangeValues.AddValueToChange(adeCOMPMA, lblCOMPMACaption, '1.e-8');
        end
        else
        begin
          adeCOMPMA.Text := '1.e-8'
        end;
      end
      else
      begin
        case TransportType of
          ttGeneral:
            begin
              NewValue := '1';
            end;
          ttEnergy:
            begin
              NewValue := '1';
            end;
          ttSolute:
            begin
              if rbSoluteConstDens.Checked then
              begin
                NewValue := '1';
              end
              else
              begin
                NewValue := '0.001';
              end;
            end;
        end;
        frmChangeValues.AddValueToChange(adeVISC0, lblVISC0_Desc, NewValue);

        if rbSoluteVarDens.Checked then
        begin
          frmChangeValues.AddValueToChange(adeSIGMAW, lblSigmawDesc, '1.0e-9');
          frmChangeValues.AddValueToChange(adeRHOW0, lblRHOW0_Desc, '1000');
          frmChangeValues.AddValueToChange(adeDRWDU, lblDRWDU_Desc, '700');
          frmChangeValues.AddValueToChange(adeURHOW0, lblURHOW0_Desc, '0');

          if Is3D then
          begin
            frmChangeValues.AddValueToChange(adeGRAVY, lblGRAVYCaption, '0');
            frmChangeValues.AddValueToChange(adeGRAVZ, lblGRAVZCaption, '-9.81');
          end
          else
          begin
            frmChangeValues.AddValueToChange(adeGRAVY, lblGRAVYCaption, '-9.81');
          end;

          if adeCOMPFL.Enabled then
          begin
            frmChangeValues.AddValueToChange(adeCOMPFL, lblCOMPFLCaption, '4.47e-10');
          end
          else
          begin
            adeCOMPFL.Text := '4.47e-10'
          end;

          if adeCOMPMA.Enabled then
          begin
            frmChangeValues.AddValueToChange(adeCOMPMA, lblCOMPMACaption, '1.e-8');
          end
          else
          begin
            adeCOMPMA.Text := '1.e-8'
          end;


        end
        else if rbSoluteConstDens.Checked then
        begin
          frmChangeValues.AddValueToChange(adeSIGMAW, lblSigmawDesc, '1.0e-9');
          frmChangeValues.AddValueToChange(adeRHOW0, lblRHOW0_Desc, '1');
          frmChangeValues.AddValueToChange(adeGRAVX, lblGRAVXCaption, '0');
          frmChangeValues.AddValueToChange(adeGRAVY, lblGRAVYCaption, '0');
          frmChangeValues.AddValueToChange(adeGRAVZ, lblGRAVZCaption, '0');
          if adeCOMPFL.Enabled then
          begin
            frmChangeValues.AddValueToChange(adeCOMPFL, lblCOMPFLCaption, '4.39e-6');
          end
          else
          begin
            adeCOMPFL.Text := '4.39e-6';
          end;

          if adeCOMPMA.Enabled then
          begin
            frmChangeValues.AddValueToChange(adeCOMPMA, lblCOMPMACaption, '9.81e-5');
          end
          else
          begin
            adeCOMPMA.Text := '9.81e-5'
          end;

        end
        else if EnergyUsed then
        begin
          frmChangeValues.AddValueToChange(adeCW, lblCW, '4182');
          frmChangeValues.AddValueToChange(adeSIGMAW, lblSigmawDesc, '0.6');
          frmChangeValues.AddValueToChange(adeRHOW0, lblRHOW0_Desc, '1000');
          frmChangeValues.AddValueToChange(adeURHOW0, lblURHOW0_Desc, '20');
          frmChangeValues.AddValueToChange(adeDRWDU, lblDRWDU_Desc, '-0.375');
          frmChangeValues.AddValueToChange(adeCS, lblCS, '840');
          frmChangeValues.AddValueToChange(adeSIGMAS, lblSIGMAS, '3.5');

          if Is3D then
          begin
            frmChangeValues.AddValueToChange(adeGRAVY, lblGRAVYCaption, '0');
            frmChangeValues.AddValueToChange(adeGRAVZ, lblGRAVZCaption, '-9.81');
          end
          else
          begin
            frmChangeValues.AddValueToChange(adeGRAVY, lblGRAVYCaption, '-9.81');
          end;
          if adeCOMPFL.Enabled then
          begin
            frmChangeValues.AddValueToChange(adeCOMPFL, lblCOMPFLCaption, '4.47e-10');
          end
          else
          begin
            adeCOMPFL.Text := '4.47e-10'
          end;

          if adeCOMPMA.Enabled then
          begin
            frmChangeValues.AddValueToChange(adeCOMPMA, lblCOMPMACaption, '1.e-8');
          end
          else
          begin
            adeCOMPMA.Text := '1.e-8'
          end;

        end;
        if rbSatUnsat.Checked then
        begin
          sicomboCSSFLO_and_CSSTRA.ItemIndex := 2;
          sicomboCSSFLO_and_CSSTRAChange(nil);

          frmChangeValues.AddValueToChange(adeITRMAX, lblITRMAX, '2');
          EnableTemporalControls;
        end
      end;
      if frmChangeValues.ShouldShow then
      begin
        if self.JustStartedProject then
        begin
          frmChangeValues.btnOKClick(nil);
        end
        else
        begin
          frmChangeValues.ShowModal;
        end;

      end;
    finally
      frmChangeValues.Free;
    end;
  end;
end;

procedure TfrmSutra.EnableComp;
var
  ShouldEnable: boolean;
begin
  ShouldEnable := (sicomboCSSFLO_and_CSSTRA.ItemIndex = 2);
  adeCOMPFL.Enabled := ShouldEnable;
  adeCOMPMA.Enabled := ShouldEnable;
  SetPredefinedInversionParameters;
end;

function TfrmSutra.TestUnitName(ProposedName: string;
  CurrentRow: integer): boolean;
var
  RowIndex: integer;
begin
  result := True;
  for RowIndex := 1 to sgGeology.RowCount - 1 do
  begin
    if (RowIndex <> CurrentRow) and
      (sgGeology.Cells[1, RowIndex] = ProposedName) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TfrmSutra.GetUnitName(ProposedName: string;
  CurrentRow: integer): string;
var
  AChar: Char;
begin
  if TestUnitName(ProposedName, CurrentRow) then
  begin
    result := ProposedName;
    Exit;
  end
  else
  begin
    for AChar := 'a' to 'z' do
    begin
      if TestUnitName(ProposedName + AChar, CurrentRow) then
      begin
        result := ProposedName + AChar;
        Exit;
      end
    end;

    for AChar := 'A' to 'Z' do
    begin
      if TestUnitName(ProposedName + AChar, CurrentRow) then
      begin
        result := ProposedName + AChar;
        Exit;
      end
    end;
    result := ProposedName;
  end;
end;

procedure TfrmSutra.GetLayerNodeAndElementCounts;
var
  SutraMeshLayer: T_ANE_MapsLayer;
  MeshLayerHandle: ANE_PTR;
  LayerOptions: TLayerOptions;
begin
  if SutraLayerStructure <> nil then
  begin
    SutraMeshLayer := nil;
    if VerticallyAlignedMesh then
    begin
      SutraMeshLayer := SutraLayerStructure.UnIndexedLayers0.
        GetLayerByName(TSutraMeshLayer.ANE_LayerName);
    end
    else if MorphedMesh
      and (SutraLayerStructure.ZerothListsOfIndexedLayers.Count > 0) then
    begin
      SutraMeshLayer := SutraLayerStructure.ZerothListsOfIndexedLayers.
        Items[0].GetLayerByName(TSutraMeshLayer.ANE_LayerName);
    end;
    if SutraMeshLayer <> nil then
    begin
      MeshLayerHandle := SutraMeshLayer.GetLayerHandle(CurrentModelHandle);
      if MeshLayerHandle = nil then
      begin
        ElementCount := 0;
        NodeCount := 0;
      end
      else
      begin
        LayerOptions := TLayerOptions.Create(MeshLayerHandle);
        try
          ElementCount := LayerOptions.NumObjects(CurrentModelHandle,
            pieElementObject);
          NodeCount := LayerOptions.NumObjects(CurrentModelHandle, pieNodeObject);
        finally
          LayerOptions.Free(CurrentModelHandle);
        end;
      end;

      GetNodeAndElementCounts;
    end;
  end;

end;

procedure TfrmSutra.GetNodeAndElementCounts;
var
  LayerCount: integer;
  ElementN, NodeN: integer;
begin
  LayerCount := GetLayerCount;
  ElementN := (LayerCount - 1) * ElementCount;
  NodeN := LayerCount * NodeCount;
  sbGeology.Panels[0].Text := 'Nodes: ' + IntToStr(NodeN);
  sbGeology.Panels[1].Text := 'Elements: ' + IntToStr(ElementN);
end;

procedure TfrmSutra.cbUseConstantValuesClick(Sender: TObject);
begin
  inherited;
  UseConstantValue := cbUseConstantValues.Checked;
end;

procedure TfrmSutra.SetNewProject(AValue: boolean);
var
  Index: integer;
  AFrmDefaultValue: TFrmDefaultValue;
begin
  FNewProject := AValue;
  for Index := 0 to ComponentCount - 1 do
  begin
    if Components[Index] is TFrmDefaultValue then
    begin
      AFrmDefaultValue := Components[Index] as TFrmDefaultValue;
      AFrmDefaultValue.btnSetValue.Enabled := not AValue and
        AFrmDefaultValue.Enabled;
    end;
  end;
  frmParameterValues.btnSetThicknessValue.Enabled := not AValue
    and frmParameterValues.adeThickness.Enabled;
end;

procedure TfrmSutra.btnRestartFileClick(Sender: TObject);
begin
  inherited;
  OpenDialog1.Filter := 'restart files (*.rst)|*.rst|All Files (*.*)|*.*';
  OpenDialog1.FileName := edRestartFile.Text;
  if OpenDialog1.Execute then
  begin
    edRestartFile.Text := OpenDialog1.FileName;
  end
  else
  begin
    edRestartFileChange(nil);
  end;
end;

procedure TfrmSutra.rgInitialValuesClick(Sender: TObject);
begin
  inherited;
  edRestartFile.Enabled := rgInitialValues.ItemIndex > 0;
  cbStartTime.Enabled := edRestartFile.Enabled;
  if not cbStartTime.Enabled then
  begin
    if not loading and not Cancelling then
    begin
      cbStartTime.Checked := False;
    end;
  end;
  btnRestartFile.Enabled := edRestartFile.Enabled;
  if not Loading and not Cancelling then
  begin
    if btnRestartFile.Enabled and not FileExists(edRestartFile.Text) then
    begin
      btnRestartFileClick(Sender);
    end;
    if (rgInitialValues.ItemIndex > 0)
      and (rgInterpolateInitialValues.ItemIndex > 0)
      and rgInterpolateInitialValues.Enabled then
    begin
      case rgInitialValues.ItemIndex of
        1:
          begin
            case rgInterpolateInitialValues.ItemIndex of
              1:
                begin
                  rgInterpolateInitialValues.ItemIndex := 0;
                end;
              3:
                begin
                  rgInterpolateInitialValues.ItemIndex := 2;
                end;
            end;
          end;
        2:
          begin
            case rgInterpolateInitialValues.ItemIndex of
              2:
                begin
                  rgInterpolateInitialValues.ItemIndex := 0;
                end;
              3:
                begin
                  rgInterpolateInitialValues.ItemIndex := 1;
                end;
            end;
          end;
        3:
          begin
            rgInterpolateInitialValues.ItemIndex := 0;
          end;
      else
        Assert(False);
      end;
    end;
  end;
  EnableCREAD;
end;

function TfrmSutra.SetAllBoundaryCounts: boolean;
var
  ColIndex, RowIndex: integer;
  LayerList: T_TypedIndexedLayerList;
  ShouldBePresent: Boolean;
  MainGroupShouldBePresent: Boolean;
begin
  MainGroupShouldBePresent := False;
  LayerList := dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiFluidSource)]
    as T_TypedIndexedLayerList;
  if LayerList <> nil then
  begin
    ShouldBePresent := False;
    if Is3D then
    begin
      for RowIndex := Ord(btiFluidSource) to Ord(btiSoluteSource) do
      begin
        for ColIndex := Ord(Succ(Low(TObjectTypeIndex))) to
          dgBoundaryCountsNew.ColCount - 1 do
        begin
          if StrToInt(dgBoundaryCountsNew.Cells[ColIndex, RowIndex]) > 0 then
          begin
            ShouldBePresent := True;
            MainGroupShouldBePresent := True;
            break;
          end;
        end;
        if ShouldBePresent then
          break;
      end;
    end;

    LayerList.AddOrRemoveLayer(TSutraHydroSourcesGroupLayer, ShouldBePresent);
  end;

  LayerList := dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiSpecPressure)]
    as T_TypedIndexedLayerList;
  if LayerList <> nil then
  begin
    ShouldBePresent := False;
    if rgDimensions.ItemIndex = 1 then
    begin
      for RowIndex := Ord(btiSpecPressure) to Ord(btiSpecConc) do
      begin
        for ColIndex := Ord(Succ(Low(TObjectTypeIndex))) to
          dgBoundaryCountsNew.ColCount - 1 do
        begin
          if StrToInt(dgBoundaryCountsNew.Cells[ColIndex, Ord(btiSpecPressure)])
          > 0 then
          begin
            ShouldBePresent := True;
            MainGroupShouldBePresent := True;
            break;
          end;
        end;
        if ShouldBePresent then
          break;
      end;
    end;
    LayerList.AddOrRemoveLayer(TSutraHydroBoundariesGroupLayer,
      ShouldBePresent);
  end;

  LayerList := dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiObservations)]
    as T_TypedIndexedLayerList;
  if LayerList <> nil then
  begin
    ShouldBePresent := False;
    if rgDimensions.ItemIndex = 1 then
    begin
      for ColIndex := Ord(Succ(Low(TObjectTypeIndex))) to
        dgBoundaryCountsNew.ColCount - 1 do
      begin
        if StrToInt(dgBoundaryCountsNew.Cells[ColIndex, Ord(btiObservations)]) >
        0 then
        begin
          ShouldBePresent := True;
          MainGroupShouldBePresent := True;
          break;
        end;
      end;
    end;
    LayerList.AddOrRemoveLayer(TSutraObservationsGroupLayer, ShouldBePresent);
  end;

  for ColIndex := 1 to dgBoundaryCountsNew.ColCount - 1 do
  begin
    for RowIndex := 1 to dgBoundaryCountsNew.RowCount - 1 do
    begin
      LayerList := dgBoundaryCountsNew.Objects[ColIndex, RowIndex]
        as T_TypedIndexedLayerList;
      if LayerList <> nil then
      begin
        if not Is3D then
        begin
          LayerList.TypedCount := 0;
        end
        else
        begin
          LayerList.TypedCount :=
            StrToInt(dgBoundaryCountsNew.Cells[ColIndex, RowIndex]);
        end;
      end;
    end;
  end;
  result := MainGroupShouldBePresent;
  if SutraLayerStructure <> nil then
  begin
    SutraLayerStructure.UnIndexedLayers3.AddOrRemoveLayer(T3DObjectsGroupLayer,

      MainGroupShouldBePresent);
  end;
end;

procedure TfrmSutra.dgBoundaryCountsNewSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  IntValue: integer;
begin
  inherited;
  if (ACol > 0) and (ARow > 0) and (Value <> '') then
  begin
    try
      IntValue := StrToInt(Value);
    except on EConvertError do
      begin
        try
          IntValue := Round(StrToFloat(Value));
        except on EConvertError do
          begin
            IntValue := 0;
          end;
        end;
      end;
    end;
    if IntValue < 0 then
    begin
      IntValue := 0;
    end;
    if IntToStr(IntValue) <> Value then
    begin
      dgBoundaryCountsNew.Cells[ACol, ARow] := IntToStr(IntValue);
    end;
    SetAllBoundaryCounts;
  end;
end;

function TfrmSutra.GetBoundaryCount(ACol, ARow: integer): integer;
begin
  Assert((ACol >= 1) and (ACol < dgBoundaryCountsNew.ColCount)
    and (ARow >= 1) and (ARow < dgBoundaryCountsNew.RowCount));
  result := StrToInt(dgBoundaryCountsNew.Cells[ACol, ARow]);
end;

function TfrmSutra.PieIsEarlier(VersionInString,
  VersionInPIE: string; ShowError: boolean): boolean;
var
  PieString: string;
  FileString: string;
  DotPosition: integer;
  Index: integer;
begin
  // called by FormCreate;

  // this function returns True if the Version number in VersionInString is
  // later than the version number in VersionInPIE. It is used to test
  // whether a model that is being opened was created by a later version of the
  // PIE.
  result := false;

  // extract the version number from VersionInString
  if Pos('File Version:', VersionInString) > 0 then
  begin
    VersionInString := Copy(VersionInString, Length('File Version:') + 1,
      Length(VersionInString));
  end;

  // test the number in each position of the version to find out whether
  // VersionInString is later than VersionInPIE
  for Index := 1 to 4 do
  begin
    // extract a number from VersionInPIE
    DotPosition := Pos('.', VersionInPIE);
    if DotPosition > 0 then
    begin
      PieString := Copy(VersionInPIE, 1, DotPosition - 1);
      VersionInPIE := Copy(VersionInPIE, DotPosition + 1,
        Length(VersionInPIE));
    end
    else
    begin
      PieString := VersionInPIE;
    end;

    // extract a number from VersionInString
    DotPosition := Pos('.', VersionInString);
    if DotPosition > 0 then
    begin
      FileString := Copy(VersionInString, 1, DotPosition - 1);
      VersionInString := Copy(VersionInString, DotPosition + 1,
        Length(VersionInString));
    end
    else
    begin
      FileString := VersionInString;
    end;

    // compare the numbers
    try
      begin
        if (FileString <> '') then
        begin
          if (StrToInt(PieString) < StrToInt(FileString)) then
          begin
            result := True;
            break;
          end
          else if (StrToInt(PieString) <> StrToInt(FileString)) then
          begin
            break;
          end;
        end;

      end
    except
      on EConvertError do
      begin
        if ShowError then
        begin
          Beep;
          MessageDlg('Unable to read version information. '
            + CHR(13) + 'Version in file = VersionInString'
            + CHR(13) + 'Version in PIE = VersionInPIE', mtWarning, [mbOK], 0);
        end;
        result := True;
      end;
    end;
  end;

end;

procedure TfrmSutra.pgcontrlMainChange(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  btnHelp.HelpContext := pgcontrlMain.ActivePage.HelpContext;
  LockWindowUpdate(Handle);
  with pgcontrlMain do
  begin
    for Index := 0 to PageCount - 1 do
    begin
      // DestroyHandle is protected so a typecast is required
      // to expose it.
      // The handles will be automatically recreated when needed.
      if (Pages[Index] <> ActivePage) and (Pages[Index] <>
        tabBoundaryConditionControls) then
        TMyWinControl(Pages[Index]).DestroyHandle;
    end;
  end;
  {Release the Lock on the Form so any Form drawing can work}
  LockWindowUpdate(0);
end;

{procedure TfrmSutra.btnSetThicknessValueClick(Sender: TObject);
var
  LayerStructure: TLayerStructure;
  AMapLayer: T_ANE_MapsLayer;
  ALayer: T_ANE_Layer;
  ClassName, ParameterName, ArgusParamName: string;
  AParam: T_ANE_Param;
  LayerHandle: ANE_PTR;
  ModelHandle: ANE_PTR;
  ParamOptions: TParameterOptions;
  LayerOptions: TLayerOptions;
  ArgusParamIndex: ANE_INT32;
  procedure SetThisValue;
  begin
    if (AMapLayer <> nil) and (AMapLayer is T_ANE_Layer) and (AMapLayer.Status
      <> sNew) then
    begin
      ALayer := AMapLayer as T_ANE_Layer;
      LayerHandle := ALayer.GetLayerHandle(ModelHandle);
      LayerOptions := TLayerOptions.Create(LayerHandle);
      ;
      try
        AParam := ALayer.ParamList.GetParameterByName(ParameterName);
        if AParam <> nil then
        begin
          ArgusParamName := AParam.OldName;
          ArgusParamIndex := LayerOptions.GetParameterIndex(ModelHandle,
            ArgusParamName);
          ParamOptions := TParameterOptions.Create(LayerHandle,
            ArgusParamIndex);
          try
            ParamOptions.Expr[ModelHandle] := adeThickness.Output;
          finally
            ParamOptions.Free;
          end;
        end;
      finally
        LayerOptions.Free(ModelHandle);
      end;
    end;
  end;
begin
  inherited;
  ClassName := TThicknessLayer.ANE_LayerName;
  ParameterName := TThicknessParam.ANE_ParamName;
  ModelHandle := CurrentModelHandle;
  if (ClassName <> '') and (ParameterName <> '') and (ModelHandle <> nil) then
  begin
    LayerStructure := SutraLayerStructure;
    if LayerStructure <> nil then
    begin
      AMapLayer := LayerStructure.UnIndexedLayers.GetLayerByName(ClassName);
      SetThisValue;
    end;
  end;
  if not (csLoading in frmSutra.ComponentState) then
  begin
    btnSetThicknessValue.Font.Style := btnSetThicknessValue.Font.Style -
      [fsBold];
  end;
end; }

{procedure TfrmSutra.adeThicknessChange(Sender: TObject);
begin
  inherited;
  if not (csLoading in ComponentState) and (frmSutra <> nil)
    and not (csLoading in frmSutra.ComponentState) then
  begin
    if not frmSutra.NewProject then
    begin
      btnSetThicknessValue.Font.Style := btnSetThicknessValue.Font.Style +
        [fsBold];
    end;
  end;
end; }

procedure TfrmSutra.btnPRODF1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmDecayConstCalculator, frmDecayConstCalculator);
  try
    frmDecayConstCalculator.GetData(StrToFloat(adePRODF1.Text));
    if frmDecayConstCalculator.ShowModal = mrOK then
    begin
      adePRODF1.Text := frmDecayConstCalculator.adeProductionTerm.Text;
    end;
  finally
    frmDecayConstCalculator.Free;
  end;

end;

procedure TfrmSutra.btnPRODS1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmDecayConstCalculator, frmDecayConstCalculator);
  try
    frmDecayConstCalculator.GetData(StrToFloat(adePRODS1.Text));
    if frmDecayConstCalculator.ShowModal = mrOK then
    begin
      adePRODS1.Text := frmDecayConstCalculator.adeProductionTerm.Text;
    end;
  finally
    frmDecayConstCalculator.Free;
  end;
end;

procedure TfrmSutra.Label11Click(Sender: TObject);
begin
  inherited;
  lblFileVersion.Visible := not lblFileVersion.Visible;
end;

procedure TfrmSutra.UpdateTreeNodeText;
var
  UnitIndex: integer;
  LayerClass: T_ANE_MapsLayerClass;
  Text: String;
  CheckNode: TTreeNode;
begin
  UnitIndex := 0;
  CheckNode := rctreeBoundaries.Items.GetFirstNode;
  while CheckNode <> nil do
  begin

    if CheckNode.Data = nil then
    begin
      Inc(UnitIndex);
      CheckNode.Text := 'Unit ' + IntToStr(UnitIndex);
    end
    else
    begin
      LayerClass := CheckNode.Data;
      Text := LayerClass.WriteNewRoot;
      if Pos('Bottom', Text) > 0 then
      begin
        Text := Text +  IntToStr(UnitIndex);
      end;
      CheckNode.Text := Text;
    end;
    CheckNode := CheckNode.GetNext;
  end;
end;

procedure TfrmSutra.AddOrRemoveBoundaryParameters(BoundaryType: TBoundaryType;
  IsTop: boolean; UnitIndex: integer; ShouldBePresent: boolean);
var
  MeshGeoUnit: T_ANE_LayerList;
  MeshLayer: T_ANE_QuadMeshLayer;
  ParamList: T_ANE_ParameterList;
begin
  if not Is3D then
    Exit;
  if rb3D_va.Checked then
  begin
    MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;
    if IsTop then
    begin
      ParamList := MeshLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(UnitIndex);
    end
    else
    begin
      ParamList := MeshLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(UnitIndex + 1);
    end;
    if ParamList <> nil then
    begin
      case BoundaryType of
        btSourcesOfFluid:
          begin
            ParamList.AddOrRemoveParameter(TQINParam,
              TQINParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TUINParam,
              TUINParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TIsFluidSource,
              TIsFluidSource.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TTimeDepFluidSourceParam,
              TTimeDepFluidSourceParam.ANE_ParamName, ShouldBePresent);
          end;
        btSourcesOfSolute:
          begin
            ParamList.AddOrRemoveParameter(TQUINParam,
              TQUINParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TIsQUINSource,
              TIsQUINSource.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TTimeDepEnergySoluteSourceParam,
              TTimeDepEnergySoluteSourceParam.ANE_ParamName, ShouldBePresent);
          end;
        btSpecPres:
          begin
            ParamList.AddOrRemoveParameter(TPBCParam,
              TPBCParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TpUBCParam,
              TpUBCParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TIsPBCSource,
              TIsPBCSource.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TTimeDepSpecHeadPresParam,
              TTimeDepSpecHeadPresParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TPBC_CommentParam,
              TPBC_CommentParam.ANE_ParamName, ShouldBePresent);
          end;
        btSpecConc:
          begin
            ParamList.AddOrRemoveParameter(TUBCParam,
              TUBCParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TIsUBCSource,
              TIsUBCSource.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TTimeDepSpecConcTempParam,
              TTimeDepSpecConcTempParam.ANE_ParamName, ShouldBePresent);
            {$IFDEF OldSutraIce}
            ParamList.AddOrRemoveParameter(TGNUU0Param,
              TGNUU0Param.ANE_ParamName, ShouldBePresent);
            {$ENDIF}
          end;
        btObservation:
          begin
            ParamList.AddOrRemoveParameter(TINOBParam,
              TINOBParam.ANE_ParamName, ShouldBePresent);
            ParamList.AddOrRemoveParameter(TINOBTypeParam,
              TINOBTypeParam.ANE_ParamName, ShouldBePresent);
          end;
      else
        Assert(False);
      end;
    end;
  end
  else
  begin
    if not IsTop then
    begin
      Inc(UnitIndex);
    end;
    MeshGeoUnit := SutraLayerStructure.ZerothListsOfIndexedLayers.
      GetNonDeletedIndLayerListByIndex(UnitIndex);
    if MeshGeoUnit <> nil then
    begin
      MeshLayer := MeshGeoUnit.GetLayerByName
        (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

      if MeshLayer <> nil then
      begin
        case BoundaryType of
          btSourcesOfFluid:
            begin
              MeshLayer.ParamList.AddOrRemoveParameter(TQINParam,
                TQINParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TUINParam,
                TUINParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TIsFluidSource,
                TIsFluidSource.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TTimeDepFluidSourceParam,
                TTimeDepFluidSourceParam.ANE_ParamName, ShouldBePresent);
            end;
          btSourcesOfSolute:
            begin
              MeshLayer.ParamList.AddOrRemoveParameter(TQUINParam,
                TQUINParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TIsQUINSource,
                TIsQUINSource.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TTimeDepEnergySoluteSourceParam,
                TTimeDepEnergySoluteSourceParam.ANE_ParamName, ShouldBePresent);
            end;
          btSpecPres:
            begin
              MeshLayer.ParamList.AddOrRemoveParameter(TPBCParam,
                TPBCParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TpUBCParam,
                TpUBCParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TIsPBCSource,
                TIsPBCSource.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TTimeDepSpecHeadPresParam,
                TTimeDepSpecHeadPresParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TPBC_CommentParam,
                TPBC_CommentParam.ANE_ParamName, ShouldBePresent);
            end;
          btSpecConc:
            begin
              MeshLayer.ParamList.AddOrRemoveParameter(TUBCParam,
                TUBCParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TIsUBCSource,
                TIsUBCSource.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TTimeDepSpecConcTempParam,
                TTimeDepSpecConcTempParam.ANE_ParamName, ShouldBePresent);
              {$IFDEF OldSutraIce}
              MeshLayer.ParamList.AddOrRemoveParameter(TGNUU0Param,
                TGNUU0Param.ANE_ParamName, ShouldBePresent);
              {$ENDIF}
            end;
          btObservation:
            begin
              MeshLayer.ParamList.AddOrRemoveParameter(TINOBParam,
                TINOBParam.ANE_ParamName, ShouldBePresent);
              MeshLayer.ParamList.AddOrRemoveParameter(TINOBTypeParam,
                TINOBTypeParam.ANE_ParamName, ShouldBePresent);
            end;
        else
          Assert(False);
        end;
      end;
    end;
  end;
end;

procedure TfrmSutra.RefreshBoundaries;
var
  LayerClass: T_ANE_MapsLayerClass;
  BoundaryType: TBoundaryType;
  IsTop: boolean;
  UnitIndex: integer;
  ACheckNode: TTreeNode;
begin
  UnitIndex := 0;
  ACheckNode := rctreeBoundaries.Items.GetFirstNode;
  while ACheckNode <> nil do
  begin
    if ACheckNode.Data = nil then
    begin
      Inc(UnitIndex);
    end;
   if ACheckNode.Data <> nil then
   begin
      LayerClass := ACheckNode.Data;
      IsTop := False;
      if LayerClass = TTopFluidSourcesLayer then
      begin
        BoundaryType := btSourcesOfFluid;
        IsTop := True;
      end
      else if LayerClass = TTopSoluteEnergySourcesLayer then
      begin
        BoundaryType := btSourcesOfSolute;
        IsTop := True;
      end
      else if LayerClass = TTopSpecifiedPressureLayer then
      begin
        BoundaryType := btSpecPres;
        IsTop := True;
      end
      else if LayerClass = TTopSpecConcTempLayer then
      begin
        BoundaryType := btSpecConc;
        IsTop := True;
      end
      else if LayerClass = TTopObservationLayer then
      begin
        BoundaryType := btObservation;
        IsTop := True;
      end
      else if LayerClass = TBottomFluidSourcesLayer then
      begin
        BoundaryType := btSourcesOfFluid;
      end
      else if LayerClass = TBottomSoluteEnergySourcesLayer then
      begin
        BoundaryType := btSourcesOfSolute;
      end
      else if LayerClass = TBottomSpecifiedPressureLayer then
      begin
        BoundaryType := btSpecPres;
      end
      else if LayerClass = TBottomSpecConcTempLayer then
      begin
        BoundaryType := btSpecConc;
      end
      else if LayerClass = TBottomObservationLayer then
      begin
        BoundaryType := btObservation;
      end
      else
      begin
        Assert(False);
      end;
      AddOrRemoveBoundaryParameters(BoundaryType, IsTop, UnitIndex,
        Is3D and (ACheckNode.StateIndex = 2));
    end;
    ACheckNode := ACheckNode.GetNext;
  end;
end;

function TfrmSutra.ArgusBoundaryLayerUsed(BoundaryType: TBoundaryType;
  UnitIndex: integer; IsTop: boolean): boolean;
var
  NodeIndex: integer;
  Index: integer;
  CheckNode: TTreeNode;
begin
  CheckNode := nil;
  for Index := 0 to UnitIndex do
  begin
    if Index = 0 then
    begin
      CheckNode := rctreeBoundaries.Items.GetFirstNode;
    end
    else
    begin
      CheckNode := CheckNode.GetNextSibling;
    end;
  end;
  NodeIndex := Ord(BoundaryType);
  if not IsTop and (UnitIndex = 0) then
  begin
    NodeIndex := NodeIndex + 5;
  end;
  for Index := 0 to NodeIndex do
  begin
    CheckNode := CheckNode.GetNext;
  end;
  result := CheckNode.StateIndex = 2;
end;

procedure TfrmSutra.cbStartTimeClick(Sender: TObject);
begin
  inherited;
  adeTSART.Enabled := not cbStartTime.Checked;
end;

procedure TfrmSutra.rgInterpolateInitialValuesClick(Sender: TObject);
var
  InputFileName: string;
  RestartFileName: string;
begin
  inherited;
  { TODO : Allow for irregular meshes. }
  if not Loading and not Cancelling then
  begin
    if (rgInitialValues.ItemIndex > 0)
      and (rgInterpolateInitialValues.ItemIndex > 0)
      and rgInterpolateInitialValues.Enabled then
    begin
      case rgInterpolateInitialValues.ItemIndex of
        1:
          begin
            case rgInitialValues.ItemIndex of
              1:
                begin
                  rgInitialValues.ItemIndex := 0;
                end;
              3:
                begin
                  rgInitialValues.ItemIndex := 2;
                end;
            end;
          end;
        2:
          begin
            case rgInitialValues.ItemIndex of
              2:
                begin
                  rgInitialValues.ItemIndex := 0;
                end;
              3:
                begin
                  rgInitialValues.ItemIndex := 1;
                end;
            end;
          end;
        3:
          begin
            rgInitialValues.ItemIndex := 0;
          end;
      else
        Assert(False);
      end;
    end;
  end;
  if Loading then
  begin
    if (rgInterpolateInitialValues.ItemIndex > 0) and (ElementInterp = nil) then
    begin
      ElementInterp := TElementInterpComponent.Create(self);
      ElementInterp.Name := 'ElementInterp';
    end;
  end
  else if not Cancelling then
  begin
    if (rgInterpolateInitialValues.ItemIndex > 0) and (ElementInterp = nil) then
    begin
      OpenDialog2.FileName := '';
      OpenDialog2.Title := 'Choose input file';
      OpenDialog2.Filter := 'Input files (*.inp)|*.inp|All files (*.*)|*.*';
      if OpenDialog2.Execute then
      begin
        InputFileName := OpenDialog2.FileName;
        OpenDialog2.FileName := '';
        OpenDialog2.Title := 'Choose restart file';
        OpenDialog2.Filter := 'Restart files (*.rst)|*.rst|All files (*.*)|*.*';
        if OpenDialog2.Execute then
        begin
          Screen.Cursor := crHourglass;
          try
            RestartFileName := OpenDialog2.FileName;
            ElementInterp := TElementInterpComponent.Create(self);
            try
              ElementInterp.Name := 'ElementInterp';
              ElementInterp.ReadDataFromExternalFiles(InputFileName,
                RestartFileName);
            except on E: Exception do
              begin
                ElementInterp.Free;
                ElementInterp := nil;
                rgInterpolateInitialValues.ItemIndex := 0;
                raise;
              end
            end;
          finally
            Screen.Cursor := crDefault;
          end;
        end
        else
        begin
          rgInterpolateInitialValues.ItemIndex := 0;
        end;
      end
      else
      begin
        rgInterpolateInitialValues.ItemIndex := 0;
      end;
    end;
  end;
  EnableCREAD;
end;

procedure TfrmSutra.WriteSpecial(ComponentData: TStringList;
  const IgnoreList: TStringlist; OwningComponent: TComponent);
begin
  if ElementInterp <> nil then
  begin
    if ((IgnoreList = nil) or (IgnoreList.IndexOf(ElementInterp.Name) = -1))
      then
    begin
      ElementInterp.Write(ComponentData);
    end;
  end;
end;

procedure TfrmSutra.adeDELTExit(Sender: TObject);
var
  DELT, DTMAX: double;
begin
  inherited;
  FixRealsOnExit(Sender);
  DELT := InternationalStrToFloat(adeDELT.Text);
  DTMAX := InternationalStrToFloat(adeDTMAX.Text);
  if DTMAX < DELT then
  begin
    adeDELT.EnabledColor := clRed;
    adeDTMAX.EnabledColor := clRed;
    if not Loading and not Cancelling then
    begin
      Beep;
      MessageDlg('Warning: DTMAX must be greater than or equal to DELT.',
        mtWarning, [mbOK], 0);
    end;
  end
  else
  begin
    adeDELT.EnabledColor := clWindow;
    adeDTMAX.EnabledColor := clWindow;
  end;
end;

procedure TfrmSutra.ReadRzctNodeBoundaries(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText: string;
  Count, NewCount, NodeIndex: integer;
  Index: integer;
  ReadData: boolean;
  CheckNode, NextCheckNode: TTreeNode;
  PriorCheckNode: TTreeNode;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ReadData := not (rctreeBoundaries = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(rctreeBoundaries.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(rctreeBoundaries.Name) = -1));
  if ReadData then
  begin
    if Assigned(rctreeBoundaries.OnEnter) then
    begin
      rctreeBoundaries.OnEnter(rctreeBoundaries);
    end;
  end;
  Count := StrToInt(AText);
  if ReadData then
  begin
    NewCount := ((Count - 4) div 5) * 6 + 5;

    NodeIndex := 0;
    CheckNode := rctreeBoundaries.Items.GetFirstNode;

    while CheckNode <> nil do
    begin
      if NodeIndex >= NewCount then
      begin
        PriorCheckNode := CheckNode;
        NextCheckNode := CheckNode.GetNext;
        rctreeBoundaries.Items.Delete(CheckNode);
        CheckNode := NextCheckNode;
      end
      else
      begin
        CheckNode := CheckNode.GetNext;
      end;
      Inc(NodeIndex);
    end;
  end;

  CheckNode := rctreeBoundaries.Items.GetFirstNode;   
  for Index := 0 to Count - 1 do
  begin
    if ReadData then
    begin
      AText := DataToRead[LineIndex];
      if Index < rctreeBoundaries.Items.Count then
      begin
        CheckNode.StateIndex := StrToInt(AText);
      end;
    end;
    Inc(LineIndex);
    if ReadData then
    begin
      if (Index = 4) or ((Index >= 8) and ((Index - 8) mod 5 = 0)) then
      begin
        CheckNode := CheckNode.GetNext;
        CheckNode.StateIndex := 1;
      end;
    end;
    CheckNode := CheckNode.GetNext;
  end;

  if ReadData then
  begin
    if Assigned(rctreeBoundaries.OnExit) then
    begin
      rctreeBoundaries.OnExit(rctreeBoundaries);
    end;
  end;
end;

procedure TfrmSutra.ReadRzctNodeBoundaries2(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText: string;
  Count: integer;
  Index: integer;
  ReadData: boolean;
  CheckNode: TTreeNode;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ReadData := not (rctreeBoundaries = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(rctreeBoundaries.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(rctreeBoundaries.Name) = -1));
  if ReadData then
  begin
    if Assigned(rctreeBoundaries.OnEnter) then
    begin
      rctreeBoundaries.OnEnter(rctreeBoundaries);
    end;
  end;
  Count := StrToInt(AText);

  CheckNode := rctreeBoundaries.Items.GetFirstNode;
  for Index := 0 to Count - 1 do
  begin
    if ReadData then
    begin
      AText := DataToRead[LineIndex];
      if Index < rctreeBoundaries.Items.Count then
      begin
        CheckNode.StateIndex := StrToInt(AText);
      end;
    end;
    Inc(LineIndex);
    CheckNode := CheckNode.GetNext;
  end;

  if ReadData then
  begin
    if Assigned(rctreeBoundaries.OnExit) then
    begin
      rctreeBoundaries.OnExit(rctreeBoundaries);
    end;
  end;
end;

procedure TfrmSutra.comboIREADChange(Sender: TObject);
begin
  inherited;
  framWarmRestart.Visible := comboIREAD.ItemIndex = 1;
  if not Loading and not Cancelling and framWarmRestart.Visible then
  begin
    framWarmRestart.btnBrowse.OnClick(nil);
  end;
end;

procedure TfrmSutra.framWarmRestartedFilePathChange(Sender: TObject);
begin
  inherited;
  framWarmRestart.edFilePathChange(Sender);
  framWarmRestart.edFilePath.Text :=
    ExtractFileName(framWarmRestart.edFilePath.Text);
end;

procedure TfrmSutra.lvChoicesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  ARect: TRect;
begin
  inherited;
  DefaultDraw := False;
  ARect := Item.DisplayRect(drLabel);

  if Item.ImageIndex = 1 then
  begin
    lvChoices.Canvas.Brush.Color := clWindow;
    lvChoices.Canvas.Font.Color := clGray;
  end
  else if (cdsFocused in State) or Item.Selected then
  begin
    lvChoices.Canvas.Brush.Color := clHighlight;
    lvChoices.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    lvChoices.Canvas.Brush.Color := clWindow;
    lvChoices.Canvas.Font.Color := clBlack;
  end;
  lvChoices.Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top, Item.Caption);

end;

procedure TfrmSutra.lvChoicesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  inherited;
  if Item.ImageIndex = 1 then
  begin
    if not lvChoices.Items[pgcontrlMain.ActivePageIndex].selected then
    begin
      lvChoices.Items[pgcontrlMain.ActivePageIndex].selected := True;
    end;
  end
  else
  begin
    pgcontrlMain.ActivePageIndex := lvChoices.Items.IndexOf(Item);
    pgcontrlMainChange(Sender);
  end;
end;

procedure TfrmSutra.ReadOlddgBoundaryCounts(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
const
  OldName = 'dgBoundaryCounts';
var
  AText: string;
  AStringGrid: TStringGrid;
  RowLimit, ColLimit: integer;
  ColIndex, RowIndex: integer;
  CanSelect: boolean;
  ACol: integer;
begin
  AStringGrid := dgBoundaryCountsNew;

  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  RowLimit := StrToInt(AText);
  if (AStringGrid <> nil) and (AStringGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(OldName) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(OldName) = -1)) then
  begin
    if Assigned(AStringGrid.OnEnter) then
    begin
      AStringGrid.OnEnter(AStringGrid);
    end;
    if SetRows(AStringGrid) then
    begin
      AStringGrid.RowCount := RowLimit;
    end;
  end;
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ColLimit := StrToInt(AText);
  if (AStringGrid <> nil) and (AStringGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(OldName) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(OldName) = -1)) then
  begin
    if SetColumns(AStringGrid) then
    begin
      AStringGrid.ColCount := ColLimit;
    end;
  end;
  for RowIndex := 0 to RowLimit - 1 do
  begin
    for ColIndex := 0 to ColLimit - 1 do
    begin
      ACol := ColIndex - 1;
      if ColIndex = 0 then
      begin
        ACol := 0;
      end
      else if ColIndex = 1 then
      begin
        ACol := ColLimit - 1;
      end;

      AText := DataToRead[LineIndex];
      Inc(LineIndex);
      if (AStringGrid <> nil) and (AStringGrid <> VersionControl) and
        ((FirstList = nil) or (FirstList.IndexOf(OldName) > -1)) and
        ((IgnoreList = nil) or (IgnoreList.IndexOf(OldName) = -1)) then
      begin
        if Assigned(AStringGrid.OnSelectCell) then
        begin
          CanSelect := True;
          AStringGrid.OnSelectCell(AStringGrid, ACol, RowIndex, CanSelect);
        end;
        AStringGrid.Cells[ACol, RowIndex] := AText;
        if Assigned(AStringGrid.OnSetEditText) then
        begin
          AStringGrid.OnSetEditText(AStringGrid, ACol, RowIndex, AText);
        end;
      end;
    end;
  end;
  if (AStringGrid <> nil) and (AStringGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(OldName) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(OldName) = -1)) then
  begin
    if Assigned(AStringGrid.OnExit) then
    begin
      AStringGrid.OnExit(AStringGrid);
    end;
  end;

end;

procedure TfrmSutra.SetSicomboCSSFLO_and_CSSTRA_Items;
var
  Item1: string;
  Item2: string;
  Item3: string;
  Middle: string;
  ItemIndex: integer;
begin
  {
  Steady-state ground-water flow: Steady-state @energy or solute@ transport
  Steady-state ground-water flow: Transient @energy or solute@ transport
  Transient ground-water flow: Transient @energy or solute@ transport
  }
  Item1 := 'Steady-state ground-water flow: Steady-state ';
  Item2 := 'Steady-state ground-water flow: Transient ';
  Item3 := 'Transient ground-water flow: Transient ';
  case TransportType of
    ttGeneral:
      begin
        Middle := KEnergyOrSolute;
      end;
    ttEnergy:
      begin
        Middle := kEnergy;
      end;
    ttSolute:
      begin
        Middle := kSolute;
      end;
  else
    begin
      Assert(False);
    end;
  end;
  Item1 := Item1 + middle + ' transport';
  Item2 := Item2 + middle + ' transport';
  Item3 := Item3 + middle + ' transport';

  ItemIndex := sicomboCSSFLO_and_CSSTRA.ItemIndex;

  sicomboCSSFLO_and_CSSTRA.Items.Clear;
  sicomboCSSFLO_and_CSSTRA.Items.Add(Item1);
  sicomboCSSFLO_and_CSSTRA.Items.Add(Item2);
  sicomboCSSFLO_and_CSSTRA.Items.Add(Item3);

  sicomboCSSFLO_and_CSSTRA.ItemIndex := ItemIndex;
  sicomboCSSFLO_and_CSSTRAChange(nil);

  AdjustDropDownWidth(sicomboCSSFLO_and_CSSTRA);
end;

procedure TfrmSutra.AdjustDropDownWidth(const siCombo: TsiComboBox);
var
  NewWidth, TestWidth: integer;
  Index: integer;
begin
  NewWidth := siCombo.Width;
  for Index := 0 to siCombo.Items.Count - 1 do
  begin
    TestWidth := Canvas.TextWidth(siCombo.Items[Index]) + 10;
    if TestWidth > NewWidth then
    begin
      NewWidth := TestWidth;
    end;
  end;
  if NewWidth > siCombo.Width then
  begin
    siCombo.CWX := NewWidth - siCombo.Width;
  end
  else
  begin
    siCombo.CWX := 0;
  end;
end;

procedure TfrmSutra.sicomboCSSFLO_and_CSSTRAChange(Sender: TObject);
begin
  inherited;
  EnableTemporalControls;
  EnableComp;
end;

procedure TfrmSutra.ReadOldcomboISSFLO(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  AText: string;
  AComboBox: TComboBox;
  Value: integer;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AComboBox := sicomboCSSFLO_and_CSSTRA;
  if not (AComboBox = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComboBox.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComboBox.Name) = -1)) then
  begin
    if Assigned(AComboBox.OnEnter) then
    begin
      AComboBox.OnEnter(AComboBox);
    end;
    Value := StrToInt(AText);
    if Value = 0 then
    begin
      // transient flow
      AComboBox.ItemIndex := 2;
    end
    else
    begin
      // steady flow
      if AComboBox.ItemIndex <> 1 then
      begin
        AComboBox.ItemIndex := 0;
      end;
    end;
    if Assigned(AComboBox.OnChange) then
    begin
      AComboBox.OnChange(AComboBox);
    end;
    if Assigned(AComboBox.OnExit) then
    begin
      AComboBox.OnExit(AComboBox);
    end;
  end;

end;

procedure TfrmSutra.ReadOldcomboISSTRA(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  AText: string;
  AComboBox: TComboBox;
  Value: integer;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AComboBox := sicomboCSSFLO_and_CSSTRA;
  if not (AComboBox = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComboBox.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComboBox.Name) = -1)) then
  begin
    if Assigned(AComboBox.OnEnter) then
    begin
      AComboBox.OnEnter(AComboBox);
    end;
    Value := StrToInt(AText);
    if Value = 0 then
    begin
      // transient transport
      if AComboBox.ItemIndex = 0 then
      begin
        // steady flow transient transport
        AComboBox.ItemIndex := 1;
      end;
    end
    else
    begin
      // steady transport (requires steady flow too.)
      AComboBox.ItemIndex := 0;
    end;
    if Assigned(AComboBox.OnChange) then
    begin
      AComboBox.OnChange(AComboBox);
    end;
    if Assigned(AComboBox.OnExit) then
    begin
      AComboBox.OnExit(AComboBox);
    end;
  end;

end;

procedure TfrmSutra.ReadvstNodeBoundaries2(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  AText : String;
  Count : integer;
  Index : integer;
  ReadData : boolean;
  CheckTree: TRbwCheckTreeView;
  ACheckNode: TTreeNode;
  CheckState: integer;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  CheckTree := rctreeBoundaries;
  ReadData := not (CheckTree = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf('rctreeBoundaries') > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf('rctreeBoundaries') = -1));
  if ReadData then
  begin
    if Assigned(CheckTree.OnEnter) then
    begin
      CheckTree.OnEnter(CheckTree);
    end;
  end;
  Count := StrToInt(AText);
  ACheckNode := nil;
  for Index := 0 to Count -1 do
  begin
    if ReadData then
    begin
      AText := DataToRead[LineIndex];
      if Index = 0 then
      begin
        ACheckNode := CheckTree.Items.GetFirstNode;
      end
      else
      begin
        ACheckNode := ACheckNode.GetNext;
      end;
      Assert(ACheckNode <> nil);

      CheckState := StrToInt(AText);
      case CheckState of
        0,1:
          begin
            ACheckNode.StateIndex := 1;
          end;
        2,3:
          begin
            ACheckNode.StateIndex := 2;
          end;
        4,5:
          begin
            ACheckNode.StateIndex := 3;
          end;
      else Assert(False);
      end;
    end;
    Inc(LineIndex);
  end;
  if ReadData then
  begin
    if Assigned(CheckTree.OnExit) then
    begin
      CheckTree.OnExit(CheckTree);
    end;
  end;
end;

procedure TfrmSutra.ReadOldFileNameFrame(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  // Skip this control; it isn't used any more.
  Inc(LineIndex, 3);
end;

procedure TfrmSutra.ReadOldcomboSIMULA(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  // Skip this control; it isn't used any more.
  Inc(LineIndex);
end;

procedure TfrmSutra.EnableCREAD;
begin
  comboIREAD.Enabled := (rgInitialValues.ItemIndex = 0)
    and (rgInterpolateInitialValues.ItemIndex = 0);
  if not Loading and not Cancelling and not comboIREAD.Enabled then
  begin
    comboIREAD.ItemIndex := 0;
  end;
end;

procedure TfrmSutra.lvChoicesKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #9 then
  begin
    SetFocusedControl(pgcontrlMain.ActivePage);
  end;
end;

procedure TfrmSutra.cbSCRNClick(Sender: TObject);
begin
  inherited;
  cbCPAUSE.Enabled := cbSCRN.Checked;
end;

procedure TfrmSutra.btnParamValuesQuickSetClick(Sender: TObject);
begin
  inherited;
  frmParameterValues.SaveCurrentValues;
  frmParameterValues.ShowModal;
end;

procedure TfrmSutra.FramTransvDispMinadePropertyChange(Sender: TObject);
var
  Frame, OtherFrame: TFrmDefaultValue;
begin
  inherited;
  if not (csLoading in ComponentState) and not Cancelling then
  begin
    Frame := (Sender as TControl).Parent as TFrmDefaultValue;
    OtherFrame := frmParameterValues.FindComponent(Frame.Name) as TFrmDefaultValue;
    OtherFrame.adeProperty.Text := Frame.adeProperty.Text;
  end;
end;

procedure TfrmSutra.adeThicknessChange(Sender: TObject);
begin
  inherited;
  if not (csLoading in ComponentState) and not Cancelling then
  begin
    frmParameterValues.adeThickness.Text := adeThickness.Text;
  end;
end;

procedure TfrmSutra.cbInverseClick(Sender: TObject);
begin
  inherited;
  if cbInverse.Checked then
  begin
    if not Loading and not Cancelling then
    begin
      lvChoices.Items[Ord(poInverse)].ImageIndex := 0;
    end;
    cbPreserveInverseModelParameters.Checked := True;
    cbPreserveInverseModelParameters.Enabled := False;
  end
  else
  begin
    if not Loading and not Cancelling then
    begin
      lvChoices.Items[Ord(poInverse)].ImageIndex := 1;
    end;
    {$IFDEF UCODE}
    cbPreserveInverseModelParameters.Enabled := True;
    {$ENDIF}
  end;
  AddOrRemoveLayers;
end;

function TfrmSutra.ConvertTime(Input: double): double;
begin
  case comboTimeUnits.ItemIndex of
    0: // sec
      begin
        result := Input;
      end;
    1: // min
      begin
        result := Input*60;
      end;
    2: // hours
      begin
        result := Input*3600;
      end;
    3: // days
      begin
        result := Input*3600*24;
      end;
    4: // months
      begin
        result := Input*3600*24*365.25/12;
      end;
    5: // years
      begin
        result := Input*3600*24*365.25;
      end;
  else Assert(False);
  end;
end;

function TfrmSutra.InitializeSimulationTimeSteps: integer;
var
  ITMAX: integer; // MAX time steps
  DELT: double; // duration of initial time step
  TMAX: double; // MAX simulation time
  ITCYC: integer; // Number of time steps in time step change cycle.
                  // A new time step size is begun at time steps numbered: 1+ n (ITCYC).
  DTMULT: double; // Multiplier for time step change cycle. New time step size is: (DELT) (DTMULT).
  DTMAX: double;  // Maximum allowed size of time step.
  DTMIN: double;  // Minimum allowed size of time step.
  Index: integer;
  TimeStepSize: double;
  ElapsedTime: double;
  Text: string;
begin
  SimulationTimes.Clear;
  if comboScheduleType.ItemIndex = 0 then
  begin
    ITMAX := StrToInt(adeITMAX.Text);
    ITCYC := StrToInt(adeITCYC.Text);
    DELT := ConvertTime(StrToFloat(adeDELT.Text));
    TMAX := ConvertTime(StrToFloat(adeTMAX.Text));
    DTMULT := StrToFloat(adeDTMULT.Text);
    DTMAX := ConvertTime(StrToFloat(adeDTMAX.Text));
    DTMIN := ConvertTime(StrToFloat(adeTCMIN.Text));

    ElapsedTime := 0;
    SimulationTimes.Add(0);
    TimeStepSize := DELT;
    for Index := 1 to ITMAX do
    begin
      if (Index > 1) and (((Index -1) mod ITCYC) = 0) then
      begin
        TimeStepSize := TimeStepSize * DTMULT;
        if TimeStepSize > DTMAX then
        begin
          TimeStepSize := DTMAX;
        end;
        if TimeStepSize < DTMIN then
        begin
          TimeStepSize := DTMIN;
        end;
      end;
      ElapsedTime := ElapsedTime + TimeStepSize;
      if ElapsedTime > TMAX then
      begin
        ElapsedTime := TMAX;
      end;
      SimulationTimes.Add(ElapsedTime);
      if ElapsedTime = TMAX then
      begin
        break;
      end;
    end;
  end
  else
  begin
    for Index := 1 to rdgTimeSeries.RowCount -1 do
    begin
      Text := rdgTimeSeries.Cells[1, Index];
      if Text <> '' then
      begin
        try
          ElapsedTime := ConvertTime(StrToFloat(Text));
          SimulationTimes.Add(ElapsedTime);
        except on EConvertError do
          begin
            // ignore
          end;
        end;
      end;
    end;
  end;
  SimulationTimes.Sorted := True;
  result := SimulationTimes.Count -1;
end;

function TfrmSutra.TimeToTimeStep(const Time: double): integer;
begin
  result := SimulationTimes.IndexOfClosest(Time);
end;

function TfrmSutra.ElapsedSimulationTime(const TimeIndex: integer): double;
begin
  result := SimulationTimes[TimeIndex];
end;

procedure TfrmSutra.adeObservationTimesExit(Sender: TObject);
var
  Count: integer;
  Layer: T_ANE_InfoLayer;
  Index: integer;
  AParameterList: T_ANE_IndexedParameterList;
begin
  inherited;
  Count := StrToInt(adeObservationTimes.Text);
{  if not frmSutra.cbInverse.Checked
    and not cbPreserveInverseModelParameters.Checked then
  begin
    Count := 0;
  end;         }
  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2dUcodeHeadObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    for Index := Layer.IndexedParamList0.Count - 1 downto Count do
    begin
      AParameterList := Layer.IndexedParamList0.GetNonDeletedIndParameterListByIndex(Index);
      if AParameterList <> nil then
      begin
        AParameterList.DeleteSelf;
      end;
    end;
    for Index := 0 to Count -1 do
    begin
      if Index >= Layer.IndexedParamList0.Count then
      begin
        TPressureObsTimeList.Create(Layer.IndexedParamList0, Index);
      end
      else
      begin
        AParameterList := Layer.IndexedParamList0.Items[Index];
        AParameterList.UnDeleteSelf;
      end;
    end;
  end;
  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2dUcodeConcentrationObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    for Index := Layer.IndexedParamList0.Count - 1 downto Count do
    begin
      AParameterList := Layer.IndexedParamList0.GetNonDeletedIndParameterListByIndex(Index);
      if AParameterList <> nil then
      begin
        AParameterList.DeleteSelf;
      end;
    end;
    for Index := 0 to Count -1 do
    begin
      if Index >= Layer.IndexedParamList0.Count then
      begin
        TConcentrationObsTimeList.Create(Layer.IndexedParamList0, Index);
      end
      else
      begin
        AParameterList := Layer.IndexedParamList0.Items[Index];
        AParameterList.UnDeleteSelf;
      end;
    end;
  end;
  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2dUcodeSaturationObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    for Index := Layer.IndexedParamList0.Count - 1 downto Count do
    begin
      AParameterList := Layer.IndexedParamList0.GetNonDeletedIndParameterListByIndex(Index);
      if AParameterList <> nil then
      begin
        AParameterList.DeleteSelf;
      end;
    end;
    for Index := 0 to Count -1 do
    begin
      if Index >= Layer.IndexedParamList0.Count then
      begin
        TSaturationObsTimeList.Create(Layer.IndexedParamList0, Index);
      end
      else
      begin
        AParameterList := Layer.IndexedParamList0.Items[Index];
        AParameterList.UnDeleteSelf;
      end;
    end;
  end;
  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2dUcodeFluxObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    for Index := Layer.IndexedParamList0.Count - 1 downto Count do
    begin
      AParameterList := Layer.IndexedParamList0.GetNonDeletedIndParameterListByIndex(Index);
      if AParameterList <> nil then
      begin
        AParameterList.DeleteSelf;
      end;
    end;
    for Index := 0 to Count -1 do
    begin
      if Index >= Layer.IndexedParamList0.Count then
      begin
        TFluxObsTimeList.Create(Layer.IndexedParamList0, Index);
      end
      else
      begin
        AParameterList := Layer.IndexedParamList0.Items[Index];
        AParameterList.UnDeleteSelf;
      end;
    end;
  end;
  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2dUcodeSoluteFluxObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    for Index := Layer.IndexedParamList0.Count - 1 downto Count do
    begin
      AParameterList := Layer.IndexedParamList0.GetNonDeletedIndParameterListByIndex(Index);
      if AParameterList <> nil then
      begin
        AParameterList.DeleteSelf;
      end;
    end;
    for Index := 0 to Count -1 do
    begin
      if Index >= Layer.IndexedParamList0.Count then
      begin
        TSoluteFluxObsTimeList.Create(Layer.IndexedParamList0, Index);
      end
      else
      begin
        AParameterList := Layer.IndexedParamList0.Items[Index];
        AParameterList.UnDeleteSelf;
      end;
    end;
  end;


{  for Index := Layer.IndexedParamList1.Count - 1 downto Count do
  begin
    AParameterList := Layer.IndexedParamList1.GetNonDeletedIndParameterListByIndex(Index);
    if AParameterList <> nil then
    begin
      AParameterList.DeleteSelf;
    end;
  end;
  for Index := Layer.IndexedParamList0.Count - 1 downto Count do
  begin
    AParameterList := Layer.IndexedParamList0.GetNonDeletedIndParameterListByIndex(Index);
    if AParameterList <> nil then
    begin
      AParameterList.DeleteSelf;
    end;
  end;
  for Index := 0 to Count -1 do
  begin
    if Index >= Layer.IndexedParamList1.Count then
    begin
      TPressureObsTimeList.Create(Layer.IndexedParamList0, Index);
      TConcentrationObsTimeList.Create(Layer.IndexedParamList1, Index);
    end
    else
    begin
      AParameterList := Layer.IndexedParamList0.Items[Index];
      AParameterList.UnDeleteSelf;
      AParameterList := Layer.IndexedParamList1.Items[Index];
      AParameterList.UnDeleteSelf;
    end;
    if (Index >= Layer.IndexedParamList2.Count) and rbSatUnsat.Checked then
    begin
      TSaturationObsTimeList.Create(Layer.IndexedParamList2, Index);
    end
    else
    begin
      if Index < Layer.IndexedParamList2.Count then
      begin
        AParameterList := Layer.IndexedParamList2.Items[Index];
        AParameterList.UnDeleteSelf;
      end;
    end;
  end;   }
end;

procedure TfrmSutra.cbPreserveInverseModelParametersClick(Sender: TObject);
var
  Layer: T_ANE_InfoLayer;
  MeshLayer: T_ANE_Layer;
begin
  inherited;
  AddOrRemoveLayers;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (TThicknessLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInvThicknessParam,
      TInvThicknessParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);

//    Layer.ParamList.AddOrRemoveParameter(TInvPorosityFunctionParam,
//      TInvPorosityFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;


  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (TPorosityLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInvPorosityParam,
      TInvPorosityParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);

//    Layer.ParamList.AddOrRemoveParameter(TInvPorosityFunctionParam,
//      TInvPorosityFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (TPermeabilityLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInvMaxPermeabilityParam,
      TInvMaxPermeabilityParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInvMaxPermeabilityFunctionParam,
//      TInvMaxPermeabilityFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);


    Layer.ParamList.AddOrRemoveParameter(TInvMinPermeabilityParam,
      TInvMinPermeabilityParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInvMinPermeabilityFunctionParam,
//      TInvMinPermeabilityFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);

    Layer.ParamList.AddOrRemoveParameter(TInvPermeabilityAngleParam,
      TInvPermeabilityAngleParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked
      and not frmSutra.Is3D);
//    Layer.ParamList.AddOrRemoveParameter(TInvPermeabilityAngleFunctionParam,
//      TInvPermeabilityAngleFunctionParam.ANE_ParamName,
//      frmSutra.cbInverse.Checked or cbPreserveInverseModelParameters.Checked
//      and not frmSutra.Is3D);
  end;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (TDispersivityLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInverseLongDispMaxParam,
      TInverseLongDispMaxParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseLongDispMaxFunctionParam,
//      TInverseLongDispMaxFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);

    Layer.ParamList.AddOrRemoveParameter(TInverseLongDispMinParam,
      TInverseLongDispMinParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseLongDispMinFunctionParam,
//      TInverseLongDispMinFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);

    Layer.ParamList.AddOrRemoveParameter(TInverseTranDispMaxParam,
      TInverseTranDispMaxParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseTranDispMaxFunctionParam,
//      TInverseTranDispMaxFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);

    Layer.ParamList.AddOrRemoveParameter(TInverseTranDispMinParam,
      TInverseTranDispMinParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseTranDispMinFunctionParam,
//      TInverseTranDispMinFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2DFluidSourcesLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInverseSourceParam,
      TInverseSourceParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseSourceFunctionParam,
//      TInverseSourceFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TInverseSourceConcentrationParam,
      TInverseSourceConcentrationParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseSourceConcentrationFunctionParam,
//      TInverseSourceConcentrationFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2DSoluteEnergySourcesLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInverseSpecifiedSoluteOrEnergySource,
      TInverseSpecifiedSoluteOrEnergySource.ANE_ParamName,
      frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInverseSpecifiedSoluteOrEnergySourceFunction,
//      TInverseSpecifiedSoluteOrEnergySourceFunction.ANE_ParamName,
//      frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2DSpecifiedPressureLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInvSpecPresParam,
      TInvSpecPresParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInvSpecPresFunctionParam,
//      TInvSpecPresFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TInvSpecPresEnergyConcParam,
      TInvSpecPresEnergyConcParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInvSpecPresEnergyConcFunctionParam,
//      TInvSpecPresEnergyConcFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;

  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2DSpecConcTempLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TInvSpecConcParam,
      TInvSpecConcParam.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    Layer.ParamList.AddOrRemoveParameter(TInvSpecConcFunctionParam,
//      TInvSpecConcFunctionParam.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
  end;

  MeshLayer := SutraLayerStructure.UnIndexedLayers0.GetLayerByName
    (TSutraMeshLayer.ANE_LayerName) as T_ANE_Layer;
  if MeshLayer <> nil then
  begin
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeThickness_Param,
      TInvNodeThickness_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodePOR_Param,
      TInvNodePOR_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionPOR_Param,
//      TInvNodeFunctionPOR_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodePMAX_Param,
      TInvNodePMAX_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionPMAX_Param,
//      TInvNodeFunctionPMAX_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodePMIN_Param,
      TInvNodePMIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionPMIN_Param,
//      TInvNodeFunctionPMIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeANGLE1_Param,
      TInvNodeANGLE1_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionANGLE1_Param,
//      TInvNodeFunctionANGLE1_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeALMAX_Param,
      TInvNodeALMAX_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionALMAX_Param,
//      TInvNodeFunctionALMAX_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeALMIN_Param,
      TInvNodeALMIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionALMIN_Param,
//      TInvNodeFunctionALMIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeATMAX_Param,
      TInvNodeATMAX_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionATMAX_Param,
//      TInvNodeFunctionATMAX_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeATMIN_Param,
      TInvNodeATMIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionATMIN_Param,
//      TInvNodeFunctionATMIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeQIN_Param,
      TInvNodeQIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionQIN_Param,
//      TInvNodeFunctionQIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeUIN_Param,
      TInvNodeUIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionUIN_Param,
//      TInvNodeFunctionUIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeQUIN_Param,
      TInvNodeQUIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionQUIN_Param,
//      TInvNodeFunctionQUIN_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodePBC_Param,
      TInvNodePBC_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionPBC_Param,
//      TInvNodeFunctionPBC_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodePUBC_Param,
      TInvNodePUBC_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionPUBC_Param,
//      TInvNodeFunctionPUBC_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeUBC_Param,
      TInvNodeUBC_Param.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
//    MeshLayer.ParamList.AddOrRemoveParameter(TInvNodeFunctionUBC_Param,
//      TInvNodeFunctionUBC_Param.ANE_ParamName, frmSutra.cbInverse.Checked
//      or cbPreserveInverseModelParameters.Checked);
    MeshLayer.ParamList.AddOrRemoveParameter(TInvHeadObsName_Param,
      TInvHeadObsName_Param.ANE_ParamName, not Is3D and (cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked));
    MeshLayer.ParamList.AddOrRemoveParameter(TInvConcentrationObsName_Param,
      TInvConcentrationObsName_Param.ANE_ParamName, not Is3D and (cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked));
    MeshLayer.ParamList.AddOrRemoveParameter(TInvSaturationObsName_Param,
      TInvSaturationObsName_Param.ANE_ParamName, rbSatUnsat.Checked and not Is3D and (cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked));
    MeshLayer.ParamList.AddOrRemoveParameter(TInvFluxObsName_Param,
      TInvFluxObsName_Param.ANE_ParamName, not Is3D and (cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked));
    MeshLayer.ParamList.AddOrRemoveParameter(TInvSoluteFluxObsName_Param,
      TInvSoluteFluxObsName_Param.ANE_ParamName, not Is3D and (cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked));
  end;

{  Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (T2DObservationLayer.ANE_LayerName) as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Layer.ParamList.AddOrRemoveParameter(TMoveObs,
      TMoveObs.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TObservationName,
      TObservationName.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TPressureHeadStatFlag,
      TPressureHeadStatFlag.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TConcentrationTemperatureStatFlag,
      TConcentrationTemperatureStatFlag.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TSaturationStatFlag,
      TSaturationStatFlag.ANE_ParamName, (frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked) and rbSatUnsat.Checked);

    Layer.ParamList.AddOrRemoveParameter(TPressureHeadPlotSymbol,
      TPressureHeadPlotSymbol.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TConcentrationTemperaturePlotSymbol,
      TConcentrationTemperaturePlotSymbol.ANE_ParamName, frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked);
    Layer.ParamList.AddOrRemoveParameter(TSaturationPlotSymbol,
      TSaturationPlotSymbol.ANE_ParamName, (frmSutra.cbInverse.Checked
      or cbPreserveInverseModelParameters.Checked) and rbSatUnsat.Checked);
  end;    }

  adeObservationTimesExit(nil);

end;

procedure TfrmSutra.adeParameterCountExit(Sender: TObject);
var
  Count, Index, OldCount: integer;
  NewName: string;
  Prefix: string;
begin
  inherited;
  FCreatingParameters := True;
  try
    Count := StrToInt(adeParameterCount.Text);
    dgEstimate.Enabled := Count > 0;
    OldCount := dgEstimate.RowCount -1;
    if Count = 0 then
    begin
      dgEstimate.RowCount := 2;
      dgEstimate.Enabled := False;
      dgEstimate.ColorSelectedRow := False;
    end
    else
    begin
      dgEstimate.RowCount := Count + 1;
      dgEstimate.Enabled := True;
      dgEstimate.ColorSelectedRow := True;
    end;
    for Index := 1 to Count do
    begin
      dgEstimate.Cells[Ord(ucN),Index] := IntToStr(Index);
      if (dgEstimate.Cells[Ord(ucParameter),Index] = '') or (Index > OldCount) then
      begin
        Prefix := 'Parameter';
        NewName := IntToStr(Index);
        While (Length(Prefix) + Length(NewName) > 12) and
          (Length(Prefix) > 0) do
        begin
          Delete(Prefix, Length(Prefix), 1);
        end;
        NewName := Prefix + NewName;

        dgEstimate.Cells[Ord(ucParameter),Index] := NewName;
      end;
      if (dgEstimate.Cells[Ord(ucInitialValue),Index] = '') or (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucInitialValue),Index] := '1';
      end;
      if (dgEstimate.Cells[Ord(ucMin),Index] = '') or (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucMin),Index] := '0.1';
      end;
      if (dgEstimate.Cells[Ord(ucMax),Index] = '') or (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucMax),Index] := '10';
      end;
      if (dgEstimate.Cells[Ord(ucPerturbation),Index] = '') or (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucPerturbation),Index] := '0.01';
      end;
      if (dgEstimate.Cells[Ord(ucLowerConstraint),Index] = '') or (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucLowerConstraint),Index] := '0.1';
      end;
      if (dgEstimate.Cells[Ord(ucUpperConstraint),Index] = '') or (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucUpperConstraint),Index] := '10';
      end;
      if (Index > OldCount) then
      begin
        dgEstimate.Cells[Ord(ucDescription),Index] := '';
      end;
    end;
  finally
    FCreatingParameters := false;
  end;
end;

procedure TfrmSutra.adeParameterCountChange(Sender: TObject);
var
  Count : integer;
begin
  inherited;
  if adeParameterCount = nil then
  begin
    Exit;
  end;
  try
    if adeParameterCount.Text <> '' then
    begin
      Count := StrToInt(adeParameterCount.Text);
      if dgEstimate <> nil then
      begin
        dgEstimate.Enabled := Count > 0;
      end;
      if btnDeleteParameter <> nil then
        btnDeleteParameter.Enabled := Count > 0;
    end;
  Except on EConvertError do
    begin
    end;
  end;

end;

procedure TfrmSutra.dgEstimateDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  FirstInstance, Index: integer;
  Column: TStringList;
begin
  inherited;
  if (ARow >= dgEstimate.FixedRows) and (ACol = Ord(ucParameter)) then
  begin
    Column := TStringList.Create;
    try
      Column.Assign(dgEstimate.Cols[ACol]);
      for Index := 1 to dgEstimate.FixedRows do
      begin
        Column.Delete(0);
      end;
      FirstInstance := ListPosition(Column, dgEstimate.Cells[ACol, ARow])
        + dgEstimate.FixedRows;


      if FirstInstance <> ARow then
      begin
        dgEstimate.Canvas.Brush.Color := clRed;
        dgEstimate.Canvas.FillRect(Rect);
        dgEstimate.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
          dgEstimate.Cells[ACol, ARow]);
      end;
    finally
      Column.Free;
    end;
  end;
end;

procedure TfrmSutra.dgEstimateSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  GlobalParamIndex: integer;
  StringValue: string;
  FloatValue: double;
begin
  inherited;
  if ACol = Ord(ucParameter) then
  begin
    if Pos(' ', Value) > 0 then
    begin
      dgEstimate.Cells[ACol,ARow] := StringReplace(Value, ' ', '_', [rfReplaceAll]);
    end;
    if not Loading and not Cancelling then
    begin
      GlobalParamIndex := dgEstimate.Columns[Ord(ucParameter)].PickList.
        IndexOf(dgEstimate.Cells[ACol,ARow]);
      if GlobalParamIndex >= 0 then
      begin
        if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CHI1' then
        begin
          StringValue := adeCHI1.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CHI2' then
        begin
          StringValue := adeCHI2.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'COMPFL' then
        begin
          StringValue := adeCOMPFL.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'COMPMA' then
        begin
          StringValue := adeCOMPMA.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODF0' then
        begin
          StringValue := adePRODF0.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODF1' then
        begin
          StringValue := adePRODF1.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODS0' then
        begin
          StringValue := adePRODS0.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODS1' then
        begin
          StringValue := adePRODS1.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'SIGMAW' then
        begin
          StringValue := adeSIGMAW.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CS' then
        begin
          StringValue := adeCS.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'SIGMAS' then
        begin
          StringValue := adeSIGMAS.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'RHOS' then
        begin
          StringValue := adeRHOS.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CW' then
        begin
          StringValue := adeCW.Text;
        end
        else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'VISC0' then
        begin
          StringValue := adeVISC0.Text;
        end
        else
        begin
          Assert(False);
        end;

        dgEstimate.Cells[Ord(ucInitialValue),ARow] := StringValue;
        FloatValue := InternationalStrToFloat(StringValue);
        dgEstimate.Cells[Ord(ucMin),ARow] := FloatToStr(FloatValue/10);
        dgEstimate.Cells[Ord(ucMax),ARow] := FloatToStr(FloatValue*10);
      end;
    end;
  end;
  UpdateEstimateHints(ARow);
  CreateExpressions;
end;

procedure TfrmSutra.SetPredefinedInversionParameters;
var
  Parameters: TStringList;
begin
  Parameters := TStringList.Create;
  try
    if (comboADSMOD.ItemIndex > 0) then
    begin
      Parameters.Add('CHI1');
      Parameters.Add('CHI2');
    end;
    if (sicomboCSSFLO_and_CSSTRA.ItemIndex = 2) then
    begin
      Parameters.Add('COMPFL');
      Parameters.Add('COMPMA');
    end;
    Parameters.Add('PRODF0');
    if not EnergyUsed or rbGeneral.Checked then
    begin
      Parameters.Add('PRODF1');
    end;
    Parameters.Add('PRODS0');
    if not EnergyUsed or rbGeneral.Checked then
    begin
      Parameters.Add('PRODS1');
    end;
    Parameters.Add('SIGMAW');
    if adeCS.Enabled then
    begin
      Parameters.Add('CS');
    end;
    if adeSIGMAS.Enabled then
    begin
      Parameters.Add('SIGMAS');
    end;
    if adeRHOS.Enabled then
    begin
      Parameters.Add('RHOS');
    end;
    if adeCW.Enabled then
    begin
      Parameters.Add('CW');
    end;
    if adeVISC0.Enabled then
    begin
      Parameters.Add('VISC0');
    end;

    dgEstimate.Columns[Ord(ucParameter)].PickList.Assign(Parameters);
  finally
    Parameters.Free;
  end;

end;

procedure TfrmSutra.UpdateEstimateHints(ARow: integer);
begin
  if ARow >= 1 then
  begin
    if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CHI1' then
    begin
      sbMain.SimpleText := 'CHI1 = Value of linear, Freundlich or Langmuir distribution coefficient, depending on sorption model chosen in ADSMOD';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Value of linear, Freundlich or Langmuir distribution coefficient'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CHI2' then
    begin
      sbMain.SimpleText := 'CHI2 = Value of Freundlich or Langmuir coefficient, depending on sorption model chosen in ADSMOD';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Value of Freundlich or Langmuir coefficient'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'COMPFL' then
    begin
      sbMain.SimpleText := 'COMPFL = Fluid compressibility';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Fluid compressibility'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'COMPMA' then
    begin
      sbMain.SimpleText := 'COMPMA = Solid matrix compressibility';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Solid matrix compressibility'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODF0' then
    begin
      case TransportType of
        ttEnergy:
          begin
            sbMain.SimpleText := 'PRODF0 = Zero-order rate of energy production in the fluid';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Zero-order rate of energy production in the fluid'
          end;
        ttSolute:
          begin
            sbMain.SimpleText := 'PRODF0 = Zero-order rate of solute mass production in the fluid';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Zero-order rate of solute mass production in the fluid'
          end;
      else Assert(False);
      end;
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODF1' then
    begin
      sbMain.SimpleText := 'PRODF1 = Rate of first-order production of adsorbate mass in the fluid mass';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Rate of first-order production of adsorbate mass in the fluid mass'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODS0' then
    begin
      case TransportType of
        ttEnergy:
          begin
            sbMain.SimpleText := 'PRODS0 = Zero-order rate of energy production in the immobile phase';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Zero-order rate of energy production in the immobile phase'
          end;
        ttSolute:
          begin
            sbMain.SimpleText := 'PRODS0 = Zero-order rate of adsorbate mass production in the immobile phase';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Zero-order rate of adsorbate mass production in the immobile phase'
          end;
      else Assert(False);
      end;
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'PRODS1' then
    begin
      sbMain.SimpleText := 'PRODS1 = Rate of first order production of solute mass in the immobile phase';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Rate of first order production of solute mass in the immobile phase'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'SIGMAW' then
    begin
      case TransportType of
        ttEnergy:
          begin
            sbMain.SimpleText := 'SIGMAW = Fluid thermal conductivity';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Fluid thermal conductivity'
          end;
        ttSolute:
          begin
            sbMain.SimpleText := 'SIGMAW = Molecular diffusivity of solute in fluid';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Molecular diffusivity of solute in fluid'
          end;
      else Assert(False);
      end;
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CS' then
    begin
      sbMain.SimpleText := 'CS = Solid grain specific heat capacity';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Solid grain specific heat capacity'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'SIGMAS' then
    begin
      sbMain.SimpleText := 'SIGMAS = Solid grain thermal conductivity';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Solid grain thermal conductivity'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'RHOS' then
    begin
      sbMain.SimpleText := 'RHOS = Density of a solid grain in the solid matrix';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Density of a solid grain in the solid matrix'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'CW' then
    begin
      sbMain.SimpleText := 'CW = Fluid specific heat capacity';
      dgEstimate.Cells[Ord(ucDescription),ARow] := 'Fluid specific heat capacity'
    end
    else if dgEstimate.Cells[Ord(ucParameter),ARow] = 'VISC0' then
    begin
      case TransportType of
        ttEnergy:
          begin
            sbMain.SimpleText := 'VISC0 = Scale factor for fluid viscosity';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Scale factor for fluid viscosity'
          end;
        ttSolute:
          begin
            sbMain.SimpleText := 'VISC0 = Fluid viscosity';
            dgEstimate.Cells[Ord(ucDescription),ARow] := 'Fluid viscosity'
          end;
      else Assert(False);
      end;
    end
    else
    begin
      sbMain.SimpleText := '';
    end;
  end;
end;

procedure TfrmSutra.btnRefreshNamesClick(Sender: TObject);
var
  Layer: T_ANE_InfoLayer;
  LayerOptions: TLayerOptions;
  ParamIndex: ANE_INT32;
  UCodeString: string;
  UCodeItems: TStringList;
  UpperCaseUcodeNames: TStringList;
  ContourIndex: ANE_INT32;
  Contour: TContourObjectOptions;
  Names: TStringList;
  NameIndex: integer;
  Count: integer;
  LayerList, ParameterList: TStringList;
  LayerIndex: integer;
  Param: T_ANE_Param;
  ParamName: string;
  LayerHandle: ANE_PTR;
  RowsToDelete: TIntegerList;
  RowIndex: integer;
  ParametersToDelete: string;
  LongNames: TStringList;
  TempUpperCaseNames: TStringList;
  IllegalDuplicateNames: TStringList;
  Index: integer;
  Values: TStringList;
  DefaultValues: TStringList;
  DomainParamNames: TStringList;
begin
  inherited;
  RowsToDelete := TIntegerList.Create;
  UpperCaseUcodeNames := TStringList.Create;
  UCodeItems := TStringList.Create;
  LayerList := TStringList.Create;
  ParameterList := TStringList.Create;
  LongNames := TStringList.Create;
  TempUpperCaseNames := TStringList.Create;
  IllegalDuplicateNames := TStringList.Create;
  Values := TStringList.Create;
  DefaultValues := TStringList.Create;
  DomainParamNames := TStringList.Create;
  try
    for Index := 0 to dgEstimate.Columns[Ord(ucParameter)].PickList.Count -1 do
    begin
      DomainParamNames.Add(dgEstimate.Columns[Ord(ucParameter)].PickList[Index]);
    end;

    LayerList.Add(TThicknessLayer.ANE_LayerName);
    ParameterList.Add(TInvThicknessParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.adeThickness.Output);

    LayerList.Add(TPorosityLayer.ANE_LayerName);
    ParameterList.Add(TInvPorosityParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramPor.adeProperty.Output);

    LayerList.Add(TPermeabilityLayer.ANE_LayerName);
    ParameterList.Add(TInvMaxPermeabilityParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramDMaxHydCond.adeProperty.Output);

    LayerList.Add(TPermeabilityLayer.ANE_LayerName);
    ParameterList.Add(TInvMinPermeabilityParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramDMinHydCond.adeProperty.Output);

    LayerList.Add(TPermeabilityLayer.ANE_LayerName);
    ParameterList.Add(TInvPermeabilityAngleParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramPermAngleXY.adeProperty.Output);

    LayerList.Add(TDispersivityLayer.ANE_LayerName);
    ParameterList.Add(TInverseLongDispMaxParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramLongDispMax.adeProperty.Output);

    LayerList.Add(TDispersivityLayer.ANE_LayerName);
    ParameterList.Add(TInverseLongDispMinParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramLongDispMin.adeProperty.Output);

    LayerList.Add(TDispersivityLayer.ANE_LayerName);
    ParameterList.Add(TInverseTranDispMaxParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramTransvDispMax.adeProperty.Output);

    LayerList.Add(TDispersivityLayer.ANE_LayerName);
    ParameterList.Add(TInverseTranDispMinParam.ANE_ParamName);
    DefaultValues.Add(frmSutra.frmParameterValues.FramTransvDispMin.adeProperty.Output);

    LayerList.Add(T2DFluidSourcesLayer.ANE_LayerName);
    ParameterList.Add(TInverseSourceParam.ANE_ParamName);
    DefaultValues.Add('0');

    LayerList.Add(T2DFluidSourcesLayer.ANE_LayerName);
    ParameterList.Add(TInverseSourceConcentrationParam.ANE_ParamName);
    DefaultValues.Add('0');

    LayerList.Add(T2DSoluteEnergySourcesLayer.ANE_LayerName);
    ParameterList.Add(TInverseSpecifiedSoluteOrEnergySource.ANE_ParamName);
    DefaultValues.Add('0');

    LayerList.Add(T2DSpecifiedPressureLayer.ANE_LayerName);
    ParameterList.Add(TInvSpecPresParam.ANE_ParamName);
    DefaultValues.Add('0');

    LayerList.Add(T2DSpecifiedPressureLayer.ANE_LayerName);
    ParameterList.Add(TInvSpecPresEnergyConcParam.ANE_ParamName);
    DefaultValues.Add('0');

    LayerList.Add(T2DSpecConcTempLayer.ANE_LayerName);
    ParameterList.Add(TInvSpecConcParam.ANE_ParamName);
    DefaultValues.Add('0');

    for LayerIndex := 0 to LayerList.Count -1 do
    begin
      TempUpperCaseNames.AddStrings(UpperCaseUcodeNames);
      Layer := SutraLayerStructure.UnIndexedLayers.GetLayerByName(
        LayerList[LayerIndex]) as T_ANE_InfoLayer;
      if Layer <> nil then
      begin
        Param := Layer.ParamList.GetParameterByName(ParameterList[LayerIndex]);
        if Param <> nil then
        begin
          ParamName := Param.OldName;

          LayerHandle := Layer.GetOldLayerHandle(CurrentModelHandle);
          if LayerHandle <> nil then
          begin
            LayerOptions := TLayerOptions.Create(LayerHandle);
            try
              ParamIndex := LayerOptions.GetParameterIndex(CurrentModelHandle,
                ParamName);
              if ParamIndex >= 0 then
              begin
                for ContourIndex := 0 to LayerOptions.NumObjects(
                  CurrentModelHandle, pieContourObject) -1 do
                begin
                  Contour := TContourObjectOptions.Create(CurrentModelHandle,
                    LayerOptions.LayerHandle, ContourIndex);
                  try
                    UCodeString := Contour.GetStringParameter(
                      CurrentModelHandle, ParamIndex);
                    if Length(UCodeString) >12  then
                    begin
                      if LongNames.IndexOf(UCodeString) < 0 then
                      begin
                        LongNames.Add(UCodeString);
                      end;

                      SetLength(UCodeString, 12);
                    end;
                    if TempUpperCaseNames.IndexOf(UpperCase(UCodeString)) >= 0 then
                    begin
                      if IllegalDuplicateNames.IndexOf(UCodeString) < 0 then
                      begin
                        IllegalDuplicateNames.Add(UCodeString);
                      end;
                    end;

                    if (UCodeString <> '') and
                      (UpperCaseUcodeNames.IndexOf(UpperCase(UCodeString)) < 0)
                      then
                    begin
                      UCodeItems.Add(UCodeString);
                      UpperCaseUcodeNames.Add(UpperCase(UCodeString));
                      Values.Add(DefaultValues[LayerIndex]);
                    end;
                  finally
                    Contour.Free;
                  end;
                end;
              end;
            finally
              LayerOptions.Free(CurrentModelHandle);
            end;
          end;
        end;
      end;
    end;

    UCodeItems.Duplicates := dupAccept;
    UCodeItems.Sort;

    UpperCaseUcodeNames.Duplicates := dupAccept;
    UpperCaseUcodeNames.Sort;

    Names := TStringList.Create;
    try
      Count := StrToInt(adeParameterCount.Text);
      if Count > 0 then
      begin
        Names.Assign(dgEstimate.Cols[Ord(ucParameter)]);
        Names.Delete(0);
        while Names.Count > Count do
        begin
          Names.Delete(Names.Count -1);
        end;
      end;

      ParametersToDelete := '';
      for RowIndex := 1 to Count do
      begin
        if (UpperCaseUcodeNames.IndexOf(
          UpperCase(dgEstimate.Cells[Ord(ucParameter),RowIndex])) < 0)
          and (DomainParamNames.IndexOf(dgEstimate.Cells[Ord(ucParameter),RowIndex]) < 0)
          then
        begin
          RowsToDelete.Add(RowIndex);
          if ParametersToDelete <> '' then
          begin
            ParametersToDelete := ParametersToDelete  + ', ';
          end;
          ParametersToDelete := ParametersToDelete
            + dgEstimate.Cells[Ord(ucParameter),RowIndex];
        end;
      end;

      for NameIndex := 0 to Names.Count -1 do
      begin
        Names[NameIndex] := UpperCase(Names[NameIndex]);
      end;

      for NameIndex := 0 to UCodeItems.Count -1 do
      begin
        if Names.IndexOf(UpperCaseUcodeNames[NameIndex]) < 0 then
//        if (ListPosition(Names, UCodeItems[NameIndex]) < 0) then
        begin
          Names.Add(UCodeItems[NameIndex]);
          Inc(Count);
          adeParameterCount.Text := IntToStr(Count);
          adeParameterCountChange(nil);
          adeParameterCountExit(nil);
          dgEstimate.Cells[Ord(ucParameter), dgEstimate.RowCount -1] :=
            UCodeItems[NameIndex];
          dgEstimate.Cells[Ord(ucInitialValue), dgEstimate.RowCount -1] :=
            Values[NameIndex];
          if Values[NameIndex] = '0' then
          begin
            dgEstimate.Cells[Ord(ucMin), dgEstimate.RowCount -1] := '-1';
            dgEstimate.Cells[Ord(ucMax), dgEstimate.RowCount -1] := '1';
          end
          else
          begin
            dgEstimate.Cells[Ord(ucMin), dgEstimate.RowCount -1] :=
              FloatToStr(InternationalStrToFloat(Values[NameIndex])/10);
            dgEstimate.Cells[Ord(ucMax), dgEstimate.RowCount -1] :=
              FloatToStr(InternationalStrToFloat(Values[NameIndex])*10);
          end;
          dgEstimate.Cells[Ord(ucLowerConstraint), dgEstimate.RowCount -1] :=
            dgEstimate.Cells[Ord(ucMin), dgEstimate.RowCount -1];
          dgEstimate.Cells[Ord(ucUpperConstraint), dgEstimate.RowCount -1] :=
            dgEstimate.Cells[Ord(ucMax), dgEstimate.RowCount -1];
        end;
      end;
    finally
      Names.Free;
    end;

    if LongNames.Count > 0 then
    begin
      Beep;
      MessageDlg('The names of the following parameters were longer than '
        + '12 characters.  They have been shortened to 12 characters.'#13#10
        + LongNames.Text, mtWarning, [mbOK], 0);
    end;

    if IllegalDuplicateNames.Count > 0 then
    begin
      Beep;
      MessageDlg('The names of the following parameters were used '
        + 'in more than one layer.'#13#10
        + IllegalDuplicateNames.Text, mtWarning, [mbOK], 0);
    end;

    if RowsToDelete.Count > 0 then
    begin
      if RowsToDelete.Count = 1 then
      begin
        ParametersToDelete := 'The following parameter is unused.  '
          + 'Do you want to delete it?'#13#10
          + ParametersToDelete + '.';
      end
      else
      begin
        ParametersToDelete := 'The following parameters are unused.  '
          + 'Do you want to delete them?'#13#10
          + ParametersToDelete + '.';
      end;
      Beep;
      if MessageDlg(ParametersToDelete, mtInformation,
        [mbYes, mbNo], 0) = mrYes then
      begin
        for RowIndex := RowsToDelete.Count -1 downto 0 do
        begin
          if dgEstimate.RowCount > 2 then
          begin
            dgEstimate.DeleteRow(RowsToDelete[RowIndex]);
          end;
          if Names.Count > 0 then
          begin
            Names.Delete(RowsToDelete[RowIndex]-1);
          end;
        end;
        Count := Count - RowsToDelete.Count;
        adeParameterCount.Text := IntToStr(Count);
        adeParameterCountChange(nil);
        adeParameterCountExit(nil);
      end;
    end;
  finally
    UCodeItems.Free;
    LayerList.Free;
    ParameterList.Free;
    UpperCaseUcodeNames.Free;
    RowsToDelete.Free;
    LongNames.Free;
    TempUpperCaseNames.Free;
    IllegalDuplicateNames.Free;
    Values.Free;
    DefaultValues.Free;
    DomainParamNames.Free;
  end;
  if dgEstimate.Row >=dgEstimate.RowCount  then
  begin
    dgEstimate.Row := dgEstimate.RowCount-1;
  end;

  dgEstimate.Col := 2;
end;

procedure TfrmSutra.btnDeleteParameterClick(Sender: TObject);
var
  Row: integer;
begin
  inherited;
  Row := dgEstimate.SelectedRow;
  if Row < dgEstimate.FixedRows then
  begin
    Row := dgEstimate.FixedRows
  end;
  if dgEstimate.RowCount > 2 then
  begin
    dgEstimate.DeleteRow(Row);
    adeParameterCount.Text := IntToStr(dgEstimate.RowCount -1);
  end
  else
  begin
    adeParameterCount.Text := '0';
  end;
  adeParameterCountChange(nil);
  adeParameterCountExit(nil);
  CreateExpressions;
  UpdateEstimateHints(dgEstimate.SelectedRow);
end;

procedure TfrmSutra.dgPriorEquationsButtonClick(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  inherited;
  if dgPriorEquations.Col = Ord(picEquation) then
  begin
    Application.CreateForm(TfrmSutraPriorEquationEditor, frmSutraPriorEquationEditor);
    try
      InitializeEquationEditor(frmSutraPriorEquationEditor);

      frmSutraPriorEquationEditor.EquationParser(Value);

      if frmSutraPriorEquationEditor.ShowModal = mrOK then
      begin
        Value := frmSutraPriorEquationEditor.Equation;
      end;

    finally
      frmSutraPriorEquationEditor.Free;
    end;
  end;
end;

procedure TfrmSutra.InitializeEquationEditor(Editor: TfrmSutraPriorEquationEditor);
var
  AStringList: TStringList;
begin
  inherited;
  Editor.CurrentModelHandle := CurrentModelHandle;
  AStringList := TStringList.Create;
  try
    AStringList.Assign(dgEstimate.Cols[Ord(ucParameter)]);
    while AStringList.Count > dgEstimate.RowCount do
    begin
      AStringList.Delete(AStringList.Count -1);
    end;
    AStringList.Delete(0);

    Editor.dgEquationParts.Columns[1].PickList.Assign(AStringList);
    Editor.Intitialize;

  finally
    AStringList.Free;
  end;

end;


procedure TfrmSutra.adePriorInfoEquationCountChange(Sender: TObject);
var
  Count : integer;
begin
  inherited;
  try
    if adePriorInfoEquationCount.Text <> '' then
    begin
      Count := StrToInt(adePriorInfoEquationCount.Text);
      dgPriorEquations.Enabled := Count > 0;
      if btnDeletePriorInformation <> nil then
        btnDeletePriorInformation.Enabled := Count > 0;
    end;
  Except on EConvertError do
    begin
    end;
  end;
end;

procedure TfrmSutra.adePriorInfoEquationCountExit(Sender: TObject);
var
  Count, Index: integer;
begin
  inherited;
  Count := StrToInt(adePriorInfoEquationCount.Text);
  dgPriorEquations.Enabled := Count > 0;
  if Count = 0 then
  begin
    dgPriorEquations.RowCount := 2;
    dgPriorEquations.Enabled := False;
    dgPriorEquations.ColorSelectedRow := False;
  end
  else
  begin
    dgPriorEquations.RowCount := Count + 1;
    dgPriorEquations.Enabled := True;
    dgPriorEquations.ColorSelectedRow := True;
  end;
  for Index := 1 to Count do
  begin
    if dgPriorEquations.Cells[Ord(picValue),Index] = '' then
    begin
      dgPriorEquations.Cells[Ord(picValue),Index] := '0';
    end;
    if dgPriorEquations.Cells[Ord(picEquation),Index] = '' then
    begin
      dgPriorEquations.Cells[Ord(picEquation),Index] := '1 * '
        + dgEstimate.Cells[Ord(ucParameter), 1];
    end;
    if dgPriorEquations.Cells[Ord(picStatistic),Index] = '' then
    begin
      dgPriorEquations.Cells[Ord(picStatistic),Index] := '0';
    end;
    if dgPriorEquations.Cells[Ord(picStatFlag),Index] = '' then
    begin
      dgPriorEquations.Cells[Ord(picStatFlag),Index] :=
        dgPriorEquations.Columns[Ord(picStatFlag)].PickList[1];
    end;
  end;
end;

procedure TfrmSutra.btnDeletePriorInformationClick(Sender: TObject);
var
  Row: integer;
begin
  inherited;
  Row := dgPriorEquations.SelectedRow;
  if Row < dgPriorEquations.FixedRows then
  begin
    Row := dgPriorEquations.FixedRows
  end;
  if dgPriorEquations.RowCount > 2 then
  begin
    dgPriorEquations.DeleteRow(Row);
    adePriorInfoEquationCount.Text := IntToStr(dgPriorEquations.RowCount -1);
  end
  else
  begin
    adePriorInfoEquationCount.Text := '0';
  end;
  adePriorInfoEquationCountChange(nil);
  adePriorInfoEquationCountExit(nil);
end;

function TfrmSutra.PriorInfoEquation(const ARow: integer): string;
begin
  result := '';
  if (ARow <= 0) or (ARow >= dgPriorEquations.RowCount) then Exit;

  result := 'P ' + dgPriorEquations.Cells[Ord(picValue), ARow] + ' = '
    + dgPriorEquations.Cells[Ord(picEquation), ARow]
    + ' stat ' + dgPriorEquations.Cells[Ord(picStatistic), ARow]
    + ' flag ' + IntToStr(dgPriorEquations.Columns[Ord(picStatFlag)].PickList.IndexOf(
      (dgPriorEquations.Cells[Ord(picStatFlag), ARow])));
end;

procedure TfrmSutra.dgPriorEquationsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
begin
  inherited;
  if not dgPriorEquations.Enabled then Exit;
  dgPriorEquations.MouseToCell(X, Y, ACol, ARow);
  sbMain.SimpleText := PriorInfoEquation(ARow);
end;

procedure TfrmSutra.rgRunSutraClick(Sender: TObject);
begin
  inherited;
  if rgRunSutra.ItemIndex = 2 then
  begin
    edExtension.Text := 'utf'
  end
  else
  begin
    edExtension.Text := 'inp'
  end;
end;

procedure TfrmSutra.CreateExpressions;
  function FixName(const Name: string): string;
  var
    Index: integer;
  begin
    result := Trim(Name);
    if Length(result) > 0 then
    begin
      if not (result[1] in ['A'..'Z', 'a'..'z']) then
      begin
        result[1] := '_';
      end;
      for Index := 2 to Length(result) do
      begin
        if not (result[Index] in ['A'..'Z', 'a'..'z', '0'..'9']) then
        begin
          result[Index] := '_';
        end;
      end;
    end;
  end;
var
  ParamName: string;
  Names: TStringList;
  Value: double;
  Formula: string;
  RowIndex: integer;
begin
  if dgEstimate.Drawing or FCreatingExpressions then
  begin
    Exit;
  end;

  FCreatingExpressions := True;
  try
    UcodeParser.ClearExpressions;
    UcodeParser.ClearVariables;
    if StrToInt(adeParameterCount.Output) > 0 then
    begin
      {$IFDEF UseXY}
      UcodeParser.CreateVariable('X', '', 0.0);
      UcodeParser.CreateVariable('Y', '', 0.0);
      for RowIndex := 1 to rdgFactorGrid.RowCount -1 do
      begin
        if (rdgFactorGrid.Cells[Ord(fcName), RowIndex] <> '')
          and (rdgFactorGrid.Cells[Ord(fcLayer), RowIndex] <> '') then
        begin
          UcodeParser.CreateVariable(rdgFactorGrid.Cells[Ord(fcName), RowIndex], '', 0.0);
        end;
      end;
      {$ENDIF}
      Names := TStringList.Create;
      try
        for RowIndex := 1 to dgEstimate.RowCount -1 do
        begin
          dgEstimate.Objects[Ord(ucExpression), RowIndex] := nil;
          if dgEstimate.Cells[Ord(ucExpression), RowIndex] = '' then
          begin
            ParamName := FixName(dgEstimate.Cells[Ord(ucParameter), RowIndex]);
            if dgEstimate.Cells[Ord(ucParameter), RowIndex] <> ParamName then
            begin
              dgEstimate.Cells[Ord(ucParameter), RowIndex] := ParamName;
            end;
            if (Names.IndexOf(UpperCase(ParamName)) < 0) and (ParamName <> '') then
            begin
              Value := StrToFloat(dgEstimate.Cells[Ord(ucInitialValue), RowIndex]);
              UcodeParser.CreateVariable(ParamName, '', Value);
              Names.Add(UpperCase(ParamName));
            end
            else
            begin
              // duplicate name.
            end;
          end;
        end;
        for RowIndex := 1 to dgEstimate.RowCount -1 do
        begin
          if dgEstimate.Cells[Ord(ucExpression), RowIndex] <> '' then
          begin
            ParamName := FixName(dgEstimate.Cells[Ord(ucParameter), RowIndex]);
            if dgEstimate.Cells[Ord(ucParameter), RowIndex] <> ParamName then
            begin
              dgEstimate.Cells[Ord(ucParameter), RowIndex] := ParamName;
            end;
            if (Names.IndexOf(UpperCase(ParamName)) < 0) and (ParamName <> '') then
            begin
              Value := StrToFloat(dgEstimate.Cells[Ord(ucInitialValue), RowIndex]);
              Formula := dgEstimate.Cells[Ord(ucExpression), RowIndex];
              try
                UcodeParser.Compile(Formula);
                dgEstimate.Objects[Ord(ucExpression), RowIndex] := UcodeParser.CurrentExpression;
              except on ErbwParserError do
                begin
                  // Do nothing
                end;
              end;
              UcodeParser.CreateVariable(ParamName, '', Value);
              Names.Add(UpperCase(ParamName));
            end
            else
            begin
              // duplicate name.
            end;
          end;
        end
      finally
        Names.Free;
      end;
      dgEstimate.Invalidate;
    end;
  finally
    FCreatingExpressions := False;
  end;
end;

procedure TfrmSutra.dgEstimateSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  RowIndex: integer;  
begin
  inherited;
  if FCreatingParameters then
  begin
    Exit;
  end;

  if (ARow > 0) and (ACol = Ord(ucDescription)) then
  begin
    if dgEstimate.Columns[Ord(ucParameter)].PickList.IndexOf(dgEstimate.Cells[Ord(ucParameter), ARow]) >= 0 then
    begin
      CanSelect := False;
    end;
  end;
  if (ARow > 0) and (ACol in [Ord(ucEstimate)..Ord(ucUpperConstraint)]) then
  begin
    CanSelect := dgEstimate.Cells[Ord(ucExpression), ARow] = '';
  end;
  if StrToInt(adeParameterCount.Output) = 0 then
  begin
    CanSelect := False;
  end;
  if (CanSelect or (ACol = Ord(ucDescription))) and not dgEstimate.Drawing then
  begin
    for RowIndex := 1 to dgEstimate.RowCount -1 do
    begin
      if ARow = RowIndex then
      begin
        dgEstimate.AdjustRowHeights(RowIndex)
      end
      else
      begin
        dgEstimate.RowHeights[RowIndex] := dgEstimate.DefaultRowHeight;
      end;
    end;
  end;
  CreateExpressions;
end;

procedure TfrmSutra.edRestartFileChange(Sender: TObject);
begin
  inherited;
  if not edRestartFile.Enabled or FileExists(edRestartFile.Text) then
  begin
    edRestartFile.Color := clWindow;
  end
  else
  begin
    edRestartFile.Color := clRed;
  end;
end;

procedure TfrmSutra.rgDimensionsEnter(Sender: TObject);
begin
  inherited;
  EnteredControl := Sender;
end;

function TfrmSutra.SetColumns(AStringGrid: TStringGrid): boolean;
begin
  if AStringGrid = sgGeology then
  begin
    result := False;
  end
  else
  begin
    result := inherited SetColumns(AStringGrid)
  end;
end;

procedure TfrmSutra.sgGeologySelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if (ACol = Ord(ghDiscretization)) and (ARow >= sgGeology.FixedRows) then
  begin
    OldVertDiscretization := sgGeology.Cells[ACol, ARow];
  end;
  if (ACol = Ord(ghGrowthRate)) and (ARow >= sgGeology.FixedRows) then
  begin
    OldGrowthRate := sgGeology.Cells[ACol, ARow];
  end;
end;

procedure TfrmSutra.jvfnUcodeChange(Sender: TObject);
var
  FileName: string;
begin
  inherited;
  FileName := jvfnUcode.Text;
  if (Length(FileName)> 1)
    and (((FileName[1] = '"') and (FileName[Length(FileName)] = '"'))
    or ((FileName[1] = '''') and (FileName[Length(FileName)] = ''''))) then
  begin
    FileName := Copy(FileName, 2, Length(FileName)-2);
  end;

  if FileExists(FileName) then
  begin
    jvfnUcode.Color := clWindow;
    if jvfnUcode.Text <> FileName then
    begin
      jvfnUcode.Text := FileName;
    end;
  end
  else
  begin
    jvfnUcode.Color := clRed;
  end;
end;

procedure TfrmSutra.cbQuasiNewtonClick(Sender: TObject);
begin
  inherited;
  adeQNIter.Enabled := cbQuasiNewton.Checked;
  adeQNsosr.Enabled := cbQuasiNewton.Checked;
end;

procedure TfrmSutra.cbTrustRegionClick(Sender: TObject);
begin
  inherited;
  adeUcodeMaxStep.Enabled := cbTrustRegion.Checked;
  adeUcodeConsecMax.Enabled := cbTrustRegion.Checked;
end;

procedure TfrmSutra.dgEstimateBeforeDrawCell(Sender: TObject; ACol,
  ARow: Integer);
var
  FirstInstance, Index: integer;
  Column: TStringList;
begin
  inherited;
  if (ARow >= dgEstimate.FixedRows)
    and (StrToInt(adeParameterCount.Output) > 0) then
  begin
    if (ACol = Ord(ucParameter)) then
    begin
      Column := TStringList.Create;
      try
        Column.Assign(dgEstimate.Cols[ACol]);
        for Index := 1 to dgEstimate.FixedRows do
        begin
          Column.Delete(0);
        end;
        for Index := 0 to Column.Count -1 do
        begin
          Column[Index] := UpperCase(Column[Index]);
        end;

        FirstInstance := ListPosition(Column,
          UpperCase(dgEstimate.Cells[ACol, ARow]))
          + dgEstimate.FixedRows;


        if FirstInstance <> ARow then
        begin
          dgEstimate.Canvas.Brush.Color := clRed;
        end;

        Column.Assign(rdgFactorGrid.Cols[Ord(fcName)]);
        Column.Delete(0);
        for Index := 0 to Column.Count -1 do
        begin
          Column[Index] := UpperCase(Column[Index]);
        end;
        if Column.IndexOf(UpperCase(dgEstimate.Cells[ACol, ARow])) >= 0 then
        begin
          dgEstimate.Canvas.Brush.Color := clRed;
        end;
      finally
        Column.Free;
      end;
    end
    else if (ACol = Ord(ucExpression)) then
    begin
      if (dgEstimate.Cells[ACol, ARow] <> '')
        and (dgEstimate.Objects[ACol, ARow] = nil) then
      begin
        dgEstimate.Canvas.Brush.Color := clRed;
      end;
    end;
  end;
end;

procedure TfrmSutra.rdeNumTimesExit(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  try
    rdgTimeSeries.RowCount := StrToInt(rdeNumTimes.Text) + 2;
    for Index := 1 to rdgTimeSeries.RowCount  -1 do
    begin
      rdgTimeSeries.Cells[0,Index] := IntToStr(Index-1);
    end;

  except on EConvertError do
    begin
      // do nothing
    end;
  end;
end;

procedure TfrmSutra.rdgTimeSeriesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inherited;
  try
    if rdgTimeSeries.RowCount <> StrToInt(rdeNumTimes.Text) + 1 then
    begin
      rdeNumTimes.Text := IntToStr(rdgTimeSeries.RowCount-2);
      rdeNumTimes.OnExit(nil);
    end;
  except on EConvertError do
    begin
      // do nothing
    end;
  end;
end;

procedure TfrmSutra.comboScheduleTypeChange(Sender: TObject);
begin
  inherited;
  jvplTemporal.ActivePageIndex := comboScheduleType.ItemIndex;
end;

procedure TfrmSutra.dgEstimateExit(Sender: TObject);
begin
  inherited;
  CreateExpressions;
end;

procedure TfrmSutra.dgEstimateRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  CreateExpressions;
end;

procedure TfrmSutra.dgEstimateButtonClick(Sender: TObject; ACol,
  ARow: Integer);
var
  VariableName: string;
  RowIndex: integer;
begin
  inherited;
  Application.CreateForm(TfrmEquationEditor, frmEquationEditor);
  try
    frmEquationEditor.CurrentModelHandle := CurrentModelHandle;
    frmEquationEditor.rbFormulaParser.CreateVariable('X',
      'Argus ONE Functions', 0.0);
    frmEquationEditor.rbFormulaParser.CreateVariable('Y',
      'Argus ONE Functions', 0.0);
    for RowIndex := 1 to rdgFactorGrid.RowCount -1 do
    begin
      if (rdgFactorGrid.Cells[Ord(fcName),RowIndex] <> '')
        and (rdgFactorGrid.Cells[Ord(fcLayer),RowIndex] <> '') then
      begin
        frmEquationEditor.rbFormulaParser.CreateVariable(
          rdgFactorGrid.Cells[Ord(fcName),RowIndex],
          'Argus ONE Factors', 0.0);
      end;

    end;

    for RowIndex := 1 to dgEstimate.RowCount -1 do
    begin
      if (RowIndex < ARow) or
        ((RowIndex <> ARow)
        and (dgEstimate.Cells[Ord(ucExpression), RowIndex] = '')) then
      begin
        VariableName := dgEstimate.Cells[Ord(ucParameter), RowIndex];
        frmEquationEditor.rbFormulaParser.CreateVariable(VariableName,
          'Parameters', 0.0);
      end;
    end;
    frmEquationEditor.UpdateTreeList;
    frmEquationEditor.Formula := dgEstimate.Cells[ACol, ARow];
    frmEquationEditor.ShowModal;
    if frmEquationEditor.ResultSet then
    begin
      dgEstimate.Cells[ACol, ARow] := frmEquationEditor.Formula;
      CreateExpressions;
    end;

  finally
    frmEquationEditor.Free;
  end;

end;

procedure TfrmSutra.dgPriorEquationsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if StrToInt(adePriorInfoEquationCount.Output) = 0 then
  begin
    CanSelect := false;
  end;

end;

procedure TfrmSutra.rdgTimeSeriesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  CanSelect := ARow > 1;
end;

Procedure TfrmSutra.SetTimeCaptions;
var
  TimeUnits: string;
  TimeMode: string;
begin
  TimeUnits := LowerCase(comboTimeUnits.Text);
  case rgMannerOfTimeSpecification.ItemIndex of
    0: TimeMode := 'absolute';
    1: TimeMode := 'elapsed';
  else Assert(False);
  end;
  lblTSART_Desc.Caption :=
    'Simulation clock time at which the initial conditions are given ['
    + TimeUnits +']';
  lblTSART_Desc.Width := 237;

  lblDELT_Desc.Caption := 'Duration of initial time step ['
    + TimeUnits + ']';

  lblTMAX_Desc.Caption := 'Maximum allowed '
    + TimeMode + ' simulation time ['
    + TimeUnits + ']';
  lblTMAX_Desc.Width := 249;

  lblTCMIN_Desc.Caption := 'Minimum allowed time step size when using TCMULT ['
    + TimeUnits +']';

  lblDTMAX_Desc.Caption := 'Maximum allowed time step size when using TCMULT ['
    + TimeUnits +']';

  TimeMode[1] := UpperCase(TimeMode)[1];

  frmSutra.rdgTimeSeries.Cells[1,0] := TimeMode + ' Time ['
     + TimeUnits +']';
end;

procedure TfrmSutra.comboTimeUnitsChange(Sender: TObject);
begin
  inherited;
  SetTimeCaptions;
  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.SetStartingTime;
begin
  if rdgTimeSeries.ColCount = 1 then
  begin
    rdgTimeSeries.ColCount := 2;
    rdgTimeSeries.FixedCols := 1;
    rdgTimeSeries.ColWidths[1] := 179;
    rdgTimeSeries.Cells[0,0] := 'Time Step';
    rdgTimeSeries.Cells[1,0] := 'Elapsed Time';
  end;

  case rgMannerOfTimeSpecification.ItemIndex of
    0: rdgTimeSeries.Cells[1,1] := adeTSART.Text;
    1: rdgTimeSeries.Cells[1,1] := '0.0';
  else Assert(False);
  end;
end;

procedure TfrmSutra.rgMannerOfTimeSpecificationClick(Sender: TObject);
begin
  inherited;
  SetTimeCaptions;
  SetStartingTime;
end;

procedure TfrmSutra.adeTSARTChange(Sender: TObject);
begin
  inherited;
  SetStartingTime;
end;

procedure TfrmSutra.rdeFactorLayerCountExit(Sender: TObject);
var
  Count: Integer;
  Index: integer;
begin
  inherited;
  Count := StrToInt(rdeFactorLayerCount.Text);
  rdgFactorGrid.Columns[Ord(fcLayer)].PickList.Clear;
  for Index := 1 to Count do
  begin
    rdgFactorGrid.Columns[Ord(fcLayer)].PickList.add(IntToStr(Index));
  end;
  if Count > 0 then
  begin
    for Index := 1 to rdgFactorGrid.RowCount -1 do
    begin
      if rdgFactorGrid.Cells[Ord(fcLayer), Index] <> '' then
      begin
        if StrToInt(rdgFactorGrid.Cells[Ord(fcLayer), Index]) > Count then
        begin
          rdgFactorGrid.Cells[Ord(fcLayer), Index] := IntToStr(Count);
        end;
      end;
    end;
  end;
end;

procedure TfrmSutra.CreateUcodeFactorLayers;
var
  Count : integer;
  Index : integer;
  ALayer: T_ANE_MapsLayer;
  InfoLayer: T_ANE_NamedInfoLayer;
  ParamIndex: integer;
  AParam: T_ANE_Param;
  RowIndex, LayerIndex: integer;
  ParamName: string;
  ParamFound: boolean;
begin
  Count := StrToInt(rdeFactorLayerCount.Text);
  if Count = 0 then
  begin
    for Index := SutraLayerStructure.UnIndexedLayers2.Count -1 downto 0 do
    begin
      ALayer := SutraLayerStructure.UnIndexedLayers2.Items[Index];
      ALayer.Delete
    end;
  end
  else
  begin
    if SutraLayerStructure.UnIndexedLayers2.Count = 0 then
    begin
      // create group layer
      TUcodeFactorGroup.Create(SutraLayerStructure.UnIndexedLayers2);
    end;
    // restore deleted layers, if any.
    for Index := SutraLayerStructure.UnIndexedLayers2.Count -1 downto 0 do
    begin
      ALayer := SutraLayerStructure.UnIndexedLayers2.Items[Index];
      if Index > Count then
      begin
        ALayer.Delete
      end
      else
      begin
        ALayer.UnDelete;
      end;
    end;
    // create new layers.
    for Index := SutraLayerStructure.UnIndexedLayers2.Count to Count do
    begin
      InfoLayer := T_ANE_NamedInfoLayer.Create(KFactorLayer + IntToStr(Index),
        SutraLayerStructure.UnIndexedLayers2);
    end;
    // delete all parameters.
    for Index := 1 to SutraLayerStructure.UnIndexedLayers2.Count -1 do
    begin
      InfoLayer := SutraLayerStructure.UnIndexedLayers2.Items[Index]
        as T_ANE_NamedInfoLayer;
      for ParamIndex := InfoLayer.ParamList.Count-1 downto 0 do
      begin
        AParam :=InfoLayer.ParamList[ParamIndex];
        AParam.Delete;
      end;
    end;
    for RowIndex := 1 to rdgFactorGrid.RowCount -1 do
    begin
      ParamName := rdgFactorGrid.Cells[Ord(fcName), RowIndex];
      if (ParamName <> '')
        and (rdgFactorGrid.Cells[Ord(fcLayer), RowIndex] <> '') then
      begin
        LayerIndex := StrToInt(rdgFactorGrid.Cells[Ord(fcLayer), RowIndex]);
        InfoLayer := SutraLayerStructure.UnIndexedLayers2.Items[LayerIndex]
          as T_ANE_NamedInfoLayer;
        ParamFound := False;
        for ParamIndex := 0 to InfoLayer.ParamList.Count-1 do
        begin
          AParam :=InfoLayer.ParamList[ParamIndex];
          if AParam.WriteName = ParamName then
          begin
            AParam.UnDelete;
            ParamFound := True;
            break;
          end;
        end;
        if not ParamFound then
        begin
          AParam := T_ANE_NamedLayerParam.Create(ParamName, InfoLayer.ParamList);
        end;
      end;
    end;
  end;
end;

procedure TfrmSutra.FixUcodeFactorName(ARow: integer);
const
  ValidCharacters = ['A'..'Z', 'a'..'z', '0'..'9', '_'];
var
  NewText: string;
  Index: integer;
  Changed: boolean;
begin
  // Ensure that only valid names can be entered for the variables.
  NewText := rdgFactorGrid.Cells[Ord(fcName), ARow];
  if (NewText <> '') and (ARow >= 1) then
  begin
    Changed := False;
    if not (NewText[1] in ['A'..'Z', 'a'..'z', '_']) then
      begin
        NewText[1] := '_';
        Changed := True;
      end;
    for Index := 2 to Length(NewText) do
    begin
      if not (NewText[Index] in ValidCharacters) then
      begin
        NewText[Index] := '_';
        Changed := True;
      end;
    end;
    if Changed then
    begin
      rdgFactorGrid.Cells[Ord(fcName), ARow] := NewText;
    end;
  end;
end;

procedure TfrmSutra.rdeFactorCountExit(Sender: TObject);
var
  FactorCount: integer;
  LayerCount: integer;
  Index: integer;
begin
  inherited;
  FactorCount := StrToInt(rdeFactorCount.Text);
  if FactorCount > 0 then
  begin
    rdgFactorGrid.Enabled := True;
    rdgFactorGrid.RowCount := FactorCount + 1;
    rdgFactorGrid.Color := clWindow;
    btnDeleteFactor.Enabled := True;
    for Index := 1 to rdgFactorGrid.RowCount -1 do
    begin
      if rdgFactorGrid.Cells[Ord(fcLayer),Index] = '' then
      begin
        rdgFactorGrid.Cells[Ord(fcLayer),Index] := '1';
      end;
    end;

  end
  else
  begin
    rdgFactorGrid.Enabled := False;
    rdgFactorGrid.RowCount := 2;
    rdgFactorGrid.Color := clBtnFace;
    btnDeleteFactor.Enabled := False;
  end;


  if FactorCount = 0 then
  begin
    rdeFactorLayerCount.Enabled := False;
    rdeFactorLayerCount.Min := 0;
    rdeFactorLayerCount.Text := '0';
    rdeFactorLayerCountExit(nil);
  end
  else
  begin
    rdeFactorLayerCount.Enabled := True;
    LayerCount := StrToInt(rdeFactorLayerCount.Text);
    if LayerCount = 0 then
    begin
      rdeFactorLayerCount.Text := '1';
      rdeFactorLayerCount.Min := 1;
      rdeFactorLayerCountExit(nil);
    end;
  end;

  for Index := 1 to rdgFactorGrid.RowCount -1 do
  begin
    rdgFactorGrid.Cells[Ord(fcN), Index] := IntToStr(Index);
  end;
end;

procedure TfrmSutra.btnDeleteFactorClick(Sender: TObject);
var
  Row: integer;
begin
  Row := rdgFactorGrid.SelectedRow;
  if Row < rdgFactorGrid.FixedRows then
  begin
    Row := rdgFactorGrid.FixedRows
  end;
  if rdgFactorGrid.RowCount > 2 then
  begin
    rdgFactorGrid.DeleteRow(Row);
    rdeFactorCount.Text := IntToStr(rdgFactorGrid.RowCount -1);
  end
  else
  begin
    rdeFactorCount.Text := '0';
  end;

  rdeFactorCountExit(nil);

end;

procedure TfrmSutra.rdeFactorCountChange(Sender: TObject);
var
  FactorCount: integer;
begin
  inherited;
  if rdeFactorCount.Text <> '' then
  begin
    FactorCount := StrToInt(rdeFactorCount.Text);
    if FactorCount > 0 then
    begin
      rdgFactorGrid.Enabled := True;
    end;
  end;
end;

procedure TfrmSutra.rdgFactorGridExit(Sender: TObject);
var
  Index: integer;
  Names: TStringList;
  Count: integer;
begin
  inherited;
  for Index := 1 to rdgFactorGrid.RowCount -1 do
  begin
    FixUcodeFactorName(Index);
  end;
  Names := TStringList.Create;
  try
    for Index := 1 to rdgFactorGrid.RowCount -1 do
    begin
      Name := rdgFactorGrid.Cells[Ord(fcName), Index];
      Count := 0;
      While Names.IndexOf(Name) >= 0 do
      begin
        Inc(Count);
        Name := Name + IntToStr(Count);
      end;
      rdgFactorGrid.Cells[Ord(fcName), Index] := Name;
      Names.Add(Name);
    end;
  finally
    Names.Free;
  end;
end;

procedure TfrmSutra.UpdateVariables;
var
  Variables: TStringList;
  UcodeParameterNames: TStringList;
  Project: TProjectOptions;
  NewLength: integer;
  Index: integer;
  PName: string;
  LayerName: string;
  RowIndex: integer;
  Formula: string;
  Expression: TExpression;
  UseList: TStringList;
  VarIndex: integer;
  DependsOnXY: boolean;
  ParamIndex: integer;
  SpecialVariable: TSubConstant;
  function FixName(const Name: string): string;
  var
    Index: integer;
  begin
    result := Trim(Name);
    if Length(result) > 0 then
    begin
      if not (result[1] in ['A'..'Z', 'a'..'z', '_']) then
      begin
        result[1] := '_';
      end;
      for Index := 2 to Length(result) do
      begin
        if not (result[Index] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
        begin
          result[Index] := '_';
        end;
      end;
    end;
  end;
begin
  Variables := TStringList.Create;
  UcodeParameterNames := TStringList.Create;
  Project:= TProjectOptions.Create;
  try
    frmSutra.UcodeCompiler.ClearExpressions;
    frmSutra.UcodeCompiler.ClearVariables;
    frmSutra.UcodeCompiler.CreateVariable('X', '', 0.0);
    frmSutra.UcodeCompiler.CreateVariable('Y', '', 0.0);

    NewLength := 0;
    for Index := 1 to StrToInt(frmSutra.rdeFactorCount.Text) do
    begin
      if (frmSutra.rdgFactorGrid.Cells[Ord(fcName), Index] <> '')
        and (frmSutra.rdgFactorGrid.Cells[Ord(fcLayer), Index] <> '') then
      begin
        Inc(NewLength);
      end;
    end;
    if NewLength > 0 then
    begin
      SetLength(frmSutra.ArgusFactors, NewLength);
      NewLength := 0;
      for Index := 1 to StrToInt(frmSutra.rdeFactorCount.Text) do
      begin
        if (frmSutra.rdgFactorGrid.Cells[Ord(fcName), Index] <> '')
          and (frmSutra.rdgFactorGrid.Cells[Ord(fcLayer), Index] <> '') then
        begin
          PName :=
            frmSutra.rdgFactorGrid.Cells[Ord(fcName), Index];
          Variables.Add(PName);
          frmSutra.ArgusFactors[NewLength].Name := PName;
          LayerName := KFactorLayer +
            Trim(frmSutra.rdgFactorGrid.Cells[Ord(fcLayer), Index]);

          frmSutra.ArgusFactors[NewLength].LayerHandle :=
            Project.GetLayerByName(funHandle, LayerName);

          Inc(NewLength);
          frmSutra.UcodeCompiler.CreateVariable(PName, '', 0.0);
        end;
      end;
    end;
    NewLength := StrToInt(frmSutra.adeParameterCount.Text);
    SetLength(frmSutra.UcodeParameters, NewLength);
    for RowIndex := 1 to StrToInt(frmSutra.adeParameterCount.Text) do
    begin
      PName :=
        FixName(frmSutra.dgEstimate.Cells[Ord(ucParameter), RowIndex]);
      UcodeParameterNames.Add(PName);
      frmSutra.UcodeParameters[RowIndex-1].Name := PName;
      Formula := Trim(frmSutra.dgEstimate.Cells[Ord(ucExpression),RowIndex]);
      frmSutra.UcodeParameters[RowIndex-1].Formula := Formula;
      frmSutra.UcodeParameters[RowIndex-1].DependsOnXY := False;
      frmSutra.UcodeCompiler.CreateVariable(PName, '', 0.0);
    end;
    for Index := 0 to Length(frmSutra.UcodeParameters) -1 do
    begin
      Formula := frmSutra.UcodeParameters[Index].Formula;
      if Formula = '' then
      begin
        SetLength(frmSutra.UcodeParameters[Index].VariablesUsed, 0);
        frmSutra.UcodeParameters[Index].DecompiledFormula := '';
      end
      else
      begin
        frmSutra.UcodeCompiler.Compile(Formula);
        Expression := frmSutra.UcodeCompiler.CurrentExpression;

        UseList := Expression.VariablesUsed;
        SetLength(frmSutra.UcodeParameters[Index].VariablesUsed,
          UseList.Count);
        frmSutra.UcodeParameters[Index].DecompiledFormula := Formula;
        for VarIndex := 0 to UseList.Count -1 do
        begin
          frmSutra.UcodeParameters[Index].VariablesUsed[VarIndex] :=
            UseList[VarIndex];
        end;
        DependsOnXY := (UseList.IndexOf('X') >= 0)
          or (UseList.IndexOf('Y') >= 0);;
        if not DependsOnXY then
        begin
          for VarIndex := 0 to Variables.Count -1 do
          begin
            DependsOnXY := UseList.IndexOf(Variables[VarIndex]) >= 0;
            if DependsOnXY then
            begin
              break;
            end;
          end;
        end;
        if not DependsOnXY then
        begin
          for VarIndex := 0 to UseList.Count -1 do
          begin
            ParamIndex := UcodeParameterNames.IndexOf(UseList[VarIndex]);
            if ParamIndex >= 0 then
            begin
              DependsOnXY :=
                frmSutra.UcodeParameters[ParamIndex].DependsOnXY;
              if DependsOnXY then
              begin
                break;
              end;
            end;
          end;
        end;
        frmSutra.UcodeParameters[Index].DependsOnXY := DependsOnXY;
      end;
    end;
    frmSutra.UcodeCompiler.ClearExpressions;
    frmSutra.UcodeCompiler.ClearVariables;

    if frmSutra.XVar = nil then
    begin
      frmSutra.XVar := TSubConstant.Create('X');
    end;
    if frmSutra.YVar = nil then
    begin
      frmSutra.YVar := TSubConstant.Create('Y');
    end;
    frmSutra.UcodeCompiler.RegisterVariable(frmSutra.XVar);
    frmSutra.UcodeCompiler.RegisterVariable(frmSutra.YVar);


    NewLength := Length(frmSutra.ArgusFactors);
    if NewLength > 0 then
    begin
      NewLength := 0;
      for Index := 1 to StrToInt(frmSutra.rdeFactorCount.Text) do
      begin
        if (frmSutra.rdgFactorGrid.Cells[Ord(fcName), Index] <> '')
          and (frmSutra.rdgFactorGrid.Cells[Ord(fcLayer), Index] <> '') then
        begin
          PName :=
            frmSutra.rdgFactorGrid.Cells[Ord(fcName), Index];

          SpecialVariable:= TSubConstant.Create(PName);
          frmSutra.ArgusFactors[NewLength].Variable := SpecialVariable;
          Inc(NewLength);
          frmSutra.UcodeCompiler.RegisterVariable(SpecialVariable);
        end;
      end;
    end;
    NewLength := StrToInt(frmSutra.adeParameterCount.Text);
    SetLength(frmSutra.UcodeParameters, NewLength);
    for RowIndex := 1 to StrToInt(frmSutra.adeParameterCount.Text) do
    begin
      PName :=
        FixName(frmSutra.dgEstimate.Cells[Ord(ucParameter), RowIndex]);
      frmSutra.UcodeCompiler.CreateVariable(PName, '', 0.0);
    end;
    for Index := 0 to Length(frmSutra.UcodeParameters) -1 do
    begin
      Formula := frmSutra.UcodeParameters[Index].Formula;
      if Formula = '' then
      begin
        SetLength(frmSutra.UcodeParameters[Index].VariablesUsed, 0);
        frmSutra.UcodeParameters[Index].DecompiledFormula := '';
        frmSutra.UcodeParameters[Index].Expression := nil;
      end
      else
      begin
        frmSutra.UcodeCompiler.Compile(Formula);
        Expression := frmSutra.UcodeCompiler.CurrentExpression;
        frmSutra.UcodeParameters[Index].Expression := Expression;
      end;
    end;

  finally
    Project.Free;
    Variables.Free;
    UcodeParameterNames.Free;
  end;
end;

{ TSubConstant }

function TSubConstant.Decompile: string;
begin
  result := FloatToStr(Value);
end;

procedure TfrmSutra.cbSutraIceClick(Sender: TObject);
begin
  inherited;
  {$IFDEF SutraIce}
    {$IFNDEF SUTRA22}
//  cbCPANDS.Enabled := cbSutraIce.Checked;
//  cbCCORT.Enabled := cbSutraIce.Checked;
//  adeNBCFPR.Enabled := cbSutraIce.Checked;
//  adeNBCSPR.Enabled := cbSutraIce.Checked;
//  adeNBCPPR.Enabled := cbSutraIce.Checked;
//  adeNBCUPR.Enabled := cbSutraIce.Checked;
//  cbCINACT.Enabled := cbSutraIce.Checked;
    {$ENDIF}
  {$ENDIF}

  AddOrRemoveLayers;
  AddOrRemoveParameters;
  AddOrRemoveMeshParameters;
  RefreshBoundaries;
end;

procedure TfrmSutra.rctreeBoundariesChange(Sender: TObject;
  Node: TTreeNode);
var
  ParentNode, TestNode : TTreeNode;
  UnitIndex: integer;
  LayerClass: T_ANE_MapsLayerClass;
  GeoUnit: T_ANE_LayerList;
  BoundaryType: TBoundaryType;
  IsTop: boolean;
begin
  inherited;
  ParentNode := Node.Parent;

  UnitIndex := 0;
  TestNode := rctreeBoundaries.Items.GetFirstNode;
  while TestNode <> nil do
  begin
    if ParentNode = TestNode then
    begin
      break;
    end;
    Inc(UnitIndex);
    TestNode := TestNode.getNextSibling;
  end;

  if UnitIndex >= 0 then
  begin
    LayerClass := Node.Data;
    if (LayerClass <> nil) and Is3D then
    begin
      IsTop := False;
      if LayerClass = TTopFluidSourcesLayer then
      begin
        BoundaryType := btSourcesOfFluid;
        IsTop := True;
      end
      else if LayerClass = TTopSoluteEnergySourcesLayer then
      begin
        BoundaryType := btSourcesOfSolute;
        IsTop := True;
      end
      else if LayerClass = TTopSpecifiedPressureLayer then
      begin
        BoundaryType := btSpecPres;
        IsTop := True;
      end
      else if LayerClass = TTopSpecConcTempLayer then
      begin
        BoundaryType := btSpecConc;
        IsTop := True;
      end
      else if LayerClass = TTopObservationLayer then
      begin
        BoundaryType := btObservation;
        IsTop := True;
      end
      else if LayerClass = TBottomFluidSourcesLayer then
      begin
        BoundaryType := btSourcesOfFluid;
      end
      else if LayerClass = TBottomSoluteEnergySourcesLayer then
      begin
        BoundaryType := btSourcesOfSolute;
      end
      else if LayerClass = TBottomSpecifiedPressureLayer then
      begin
        BoundaryType := btSpecPres;
      end
      else if LayerClass = TBottomSpecConcTempLayer then
      begin
        BoundaryType := btSpecConc;
      end
      else if LayerClass = TBottomObservationLayer then
      begin
        BoundaryType := btObservation;
      end
      else
      begin
        Assert(False);
      end;
      if IsTop then
      begin
        GeoUnit := SutraLayerStructure.IntermediateUnIndexedLayers;
      end
      else
      begin
        GeoUnit := SutraLayerStructure.ListsOfIndexedLayers.
          GetNonDeletedIndLayerListByIndex(UnitIndex);
      end;
      GeoUnit.AddOrRemoveLayer(LayerClass, (Node.StateIndex = 2));

      AddOrRemoveBoundaryParameters(BoundaryType, IsTop, UnitIndex,
        (Node.StateIndex = 2) and Is3D);
    end;
  end;
end;

procedure TfrmSutra.rdgFreezingEqSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  CanSelect := (StrToInt(adeNUIREG.Text) > 0)
    and (ACol >= rdgFreezingEq.FixedCols);
  if not rdgFreezingEq.Drawing then
  begin
    jvplRegionEquations.ActivePageIndex := ARow-1;
  end;
  if CanSelect then
  begin
    if ACol = Ord(fcPermeability) then
    begin
      CanSelect := rbSatUnsat.Checked or rbFreezing.Checked;
    end
    else if ACol = Ord(fcUnsaturated) then
    begin
      CanSelect := rbSatUnsat.Checked
    end
    else if ACol = Ord(fcFreezing) then
    begin
      CanSelect := rbFreezing.Checked
    end;
  end;

end;

procedure TfrmSutra.adeNUIREGExit(Sender: TObject);
var
  AValue: integer;
  Index: integer;
  APage: TJvStandardPage;
  AFrame: TframeRegionParams;
  ColIndex, RowIndex: integer;
begin
  inherited;
  if TryStrToInt(adeNUIREG.Text, AValue) then
  begin
    if AValue > 0 then
    begin
      rdgFreezingEq.RowCount := AValue + 1;
    end;

    if FEquationFrameList.Count > AValue then
    begin
      FEquationFrameList.Count := AValue;
      while jvplRegionEquations.PageCount > AValue do
      begin
        jvplRegionEquations.Pages[jvplRegionEquations.PageCount-1].Free;
      end;
    end;
    for Index := FEquationFrameList.Count to AValue -1 do
    begin
      APage := TJvStandardPage.Create(jvplRegionEquations);
      APage.PageList := jvplRegionEquations;
      APage.PageIndex := jvplRegionEquations.PageCount -1;
      AFrame := TframeRegionParams.Create(self);
      FEquationFrameList.Add(AFrame);
      AFrame.Name := 'frameRegionParams' + IntToStr(Index);
      AFrame.Parent := APage;
      AFrame.Align := alClient;
      AFrame.pnlCaption.Caption := 'Region: ' + IntToStr(Index+1);
      AFrame.frameRelativePermeability.JvPageListMain.ActivePageIndex := 0;
      AFrame.frameUnsat.JvPageListMain.ActivePageIndex := 0;
      AFrame.frameIceSat.JvPageListMain.ActivePageIndex := 0;
    end;
    for RowIndex := 1 to rdgFreezingEq.RowCount -1  do
    begin
      rdgFreezingEq.Cells[Ord(fcRegionNumber), RowIndex] := IntToStr(RowIndex);
      for ColIndex := 1 to rdgFreezingEq.ColCount -1 do
      begin
        if rdgFreezingEq.Cells[ColIndex, RowIndex] = '' then
        begin
          rdgFreezingEq.ItemIndex[ColIndex, RowIndex] := 0;
        end;
      end;
    end;
  end;
end;

procedure TfrmSutra.rdgFreezingEqSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  AFrame : TframeRegionParams;
  FuncCol: TFunctionColumn;
  APageIndex: integer;
begin
  inherited;
  if (ARow >= 1) and (StrToIntDef(adeNUIREG.Text, 0) > 0) then
  begin
    if (ACol >= 0) and (ACol < rdgFreezingEq.ColCount) then
    begin
      AFrame := FEquationFrameList[ARow-1] as TframeRegionParams;
      FuncCol := TFunctionColumn(ACol);
      case FuncCol of
        fcRegionNumber:
          begin
          end;
        fcPermeability:
          begin
            APageIndex := rdgFreezingEq.ItemIndex[ACol,ARow];
            AFrame.frameRelativePermeability.JvPageListMain.ActivePageIndex := APageIndex;
          end;
        fcUnsaturated:
          begin
            APageIndex := rdgFreezingEq.ItemIndex[ACol,ARow];
            AFrame.frameUnsat.JvPageListMain.ActivePageIndex := APageIndex;
          end;
        fcFreezing:
          begin
            APageIndex := rdgFreezingEq.ItemIndex[ACol,ARow];
            AFrame.frameIceSat.JvPageListMain.ActivePageIndex := APageIndex;
          end;
      else Assert(False);
      end;
    end;
  end;
end;

end.

