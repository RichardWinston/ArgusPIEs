unit ModflowUnit;

interface

{ModflowUnit defines the form displayed when "PIEs|Edit Project Info" is
 selected.}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, Grids, StdCtrls, ArgusDataEntry, ComCtrls, Buttons,
  MFLayerStructureUnit, OleCtrls, ASLink, DataGrid, ExtCtrls, ANE_LayerUnit,
  StringGrid3d, ModflowLayerClassTypes, frmPriorEquationEditorUnit,
  CheckLst, ALSTDlg, addbtn95, framHUF_Unit, RbwDataGrid, Strset,
  framFilePathUnit, frameFormatDescriptor, frameOutputControlUnit,
  frameGWM_Unit, RbwDataGrid2, HH, HH_FUNCS, RbwDataGrid4, JvExCheckLst,
  JvCheckListBox, JvExStdCtrls, JvCombobox, JvListComb, Rbw95Button,
  JvExControls, JvPageList, frameMnw2PumpUnit, Mask, JvExMask, JvSpin,
  JvDBSpinEdit;

var mHHelp: THookHelpSystem = nil;

function HelpFileFullPath(const FileName: string): string;
procedure InitializeHTMLHELP;

type
  lpfParameterType = (lpfHK, lpfVK, lpfVANI, lpfSS, lpfSY, lpfVKCB, lfpHani);
  hufParameterType = (hufHK, hufHani, hufVK, hufVANI, hufSS, hufSY, hufKDEP,
    hufSYTP, hufLVDA);
  THufParameterTypes = set of hufParameterType;
  TAdvParameterType = (advPRST, advPRCB);

  MT3DTimeData = (tdmN, tdmLength, tdmStepSize, tdmMaxSteps, tdmCalculated,
    tdmMult, tdmMax);
  MT3DDispersionData = (ddmN, ddmName, ddmHorDisp, ddmVertDisp, ddmMolDiffCoef);
  MT3DReactionData = (rdmN, rdmName, rdmBulkDensity, rdmSorpConst1,
    rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp, rdmDualPorosity,
    rdmStartingConcentration);
  MT3DPrintoutTimes = (ptmN, ptmTime);
  TGWM_ExternalColumns = (gecName, gecType, gecMin, gecMax, gecSP1);
  TGWM_BinaryColumns = (gbcName, gbcCount);
  TGWM_SummationConstraints = (gscName, gscCount, gscType, gscRightHandSide);
  TMnw2LossTypeChoices = (ltcThiem, ltcSkin, ltcGeneral, ltcSpecify);
  TMnw2LossTypeSet = set of TMnw2LossTypeChoices;
  TGwmStorageCol = (gwscName, gscStartSP, gscEndsSp, gscZoneChoice, gscZoneNumber);


  TfrmMODFLOW = class(TArgusForm)
    pnlBottom: TPanel;
    pageControlMain: TPageControl;
    tabProject: TTabSheet;
    gboxMFProjectInfo: TGroupBox;
    edProjectName: TEdit;
    edDate: TEdit;
    memoDescription: TMemo;
    adeTitle1: TArgusDataEntry;
    adeTitle2: TArgusDataEntry;
    lblProjectName: TLabel;
    lblDate: TLabel;
    lblDesc: TLabel;
    lblProjectTitle: TLabel;
    lblExported: TLabel;
    tabGeology: TTabSheet;
    gboxGeologicUnits: TGroupBox;
    pnlGeolUnitBottom: TPanel;
    tabMisc: TTabSheet;
    gboxRewetting: TGroupBox;
    comboWetCap: TComboBox;
    comboWetEq: TComboBox;
    adeHDRY: TArgusDataEntry;
    adeWettingFact: TArgusDataEntry;
    adeWetIterations: TArgusDataEntry;
    lblWetFlg: TLabel;
    lblDryCell: TLabel;
    lblWetFact: TLabel;
    lblCheckDry: TLabel;
    lblWetEq: TLabel;
    lblIWDFLG: TLabel;
    lblHDRY: TLabel;
    lblWETFCT: TLabel;
    lblIWETIT: TLabel;
    lblIHDWET: TLabel;
    tabStress: TTabSheet;
    tabTime: TTabSheet;
    gboxTime: TGroupBox;
    pnlTimeTop: TPanel;
    pnlTimeBottom: TPanel;
    pnlTimeButtons: TPanel;
    btnInsertTime: TButton;
    comboSteady: TComboBox;
    lblTrans: TLabel;
    lblStressPer: TLabel;
    lblISS: TLabel;
    lblNPER: TLabel;
    tabOutputFiles: TTabSheet;
    gboxOutputFiles: TGroupBox;
    pnlOutputFilesTop: TPanel;
    adeFileName: TArgusDataEntry;
    lblRootname: TLabel;
    pnlOutLeft: TPanel;
    pnlOutRight: TPanel;
    pnlOutputMain: TPanel;
    gboxHeadDrawdown: TGroupBox;
    lblExportHead: TLabel;
    lblExportDrawdown: TLabel;
    comboExportHead: TComboBox;
    comboExportDrawdown: TComboBox;
    gboxCellFlow: TGroupBox;
    pnlOutputBottom: TPanel;
    cbOneFlowFile: TCheckBox;
    cbFlowBudget: TCheckBox;
    tabOutputCtrl: TTabSheet;
    tabMOC3DSubGrid: TTabSheet;
    gboxMOC3DSubGrid: TGroupBox;
    adeMOC3DLay1: TArgusDataEntry;
    adeMOC3DLay2: TArgusDataEntry;
    adeMOC3DDecay: TArgusDataEntry;
    adeMOC3DDiffus: TArgusDataEntry;
    adeMOC3DCnoflow: TArgusDataEntry;
    comboMOC3DInterp: TComboBox;
    comboMOC3DReadRech: TComboBox;
    comboMOC3DSaveWell: TComboBox;
    lblMOC3DFirstUnit: TLabel;
    lblMOC3DLastUnit: TLabel;
    lblMOC3DDecayRate: TLabel;
    lblMOC3DMolDiffCoef: TLabel;
    lblMOC3DInterpScheme: TLabel;
    lblMOC3DConcInactive: TLabel;
    lblMOC3DReuseRechConc: TLabel;
    lblMOC3DSaveObsWell: TLabel;
    lblMOC3DISLAY1: TLabel;
    lblMOC3DISLAY2: TLabel;
    lblMOC3DDECAY: TLabel;
    lblMOC3DDIFFUS: TLabel;
    lblMOC3DINTRPL: TLabel;
    lblMOC3DCNOFLO: TLabel;
    lblMOC3DINCRCH: TLabel;
    lblMOC3DIOBSFL: TLabel;
    tabMOC3DParticles: TTabSheet;
    gboxMOC3DParticle: TGroupBox;
    pnlMOC3DParticleTop: TPanel;
    adeMOC3DMaxParticles: TArgusDataEntry;
    adeMOC3DMaxFrac: TArgusDataEntry;
    adeMOC3DLimitActiveCells: TArgusDataEntry;
    sgMOC3DParticles: TStringGrid;
    cbCustomParticle: TCheckBox;
    lblMOC3DMaxParticles: TLabel;
    lblMOC3DMaxFrac: TLabel;
    lblMOC3DMaxActiveVoid: TLabel;
    lblMOC3DInitParticles: TLabel;
    lblMOC3DNPMAX: TLabel;
    lblMOC3DCELDIS: TLabel;
    lblMOC3DFZERO: TLabel;
    lblMOC3DNPTPND: TLabel;
    tabMOC3DOut: TTabSheet;
    pnlMOC3DParticleBottom: TPanel;
    gboxOutput: TGroupBox;
    edNumPer: TEdit;
    btnDeleteTime: TButton;
    btnAddTime: TButton;
    tabPrivate: TTabSheet;
    gboxMFRun: TGroupBox;
    lblCreateOnly: TLabel;
    rbRun: TRadioButton;
    cbUseSolute: TCheckBox;
    rbCreate: TRadioButton;
    gboxOutputPackages: TGroupBox;
    cbExpBAS: TCheckBox;
    cbExpOC: TCheckBox;
    cbExpBCF: TCheckBox;
    cbExpRCH: TCheckBox;
    cbExpRIV: TCheckBox;
    cbExpWEL: TCheckBox;
    cbExpDRN: TCheckBox;
    cbExpGHB: TCheckBox;
    cbExpEVT: TCheckBox;
    cbExpMatrix: TCheckBox;
    cbExpCONC: TCheckBox;
    cbExpOBS: TCheckBox;
    adeMODFLOWPath: TArgusDataEntry;
    adeMOC3DPath: TArgusDataEntry;
    tabMOCIMP: TTabSheet;
    edMOC3DInitParticles: TEdit;
    gboxMOCIMP: TGroupBox;
    lblMOCIMPWeight: TLabel;
    lblMOCIMPNumIter: TLabel;
    lblMOCIMPDirection: TLabel;
    lblMOCIMPTolerance: TLabel;
    lblMOCIMPMaxIter: TLabel;
    lblMOCIMPFDTMTH: TLabel;
    lblMOCIMPNCXIT: TLabel;
    lblMOCIMPIDIREC: TLabel;
    lblMOCIMPEPSSLV: TLabel;
    lblMOCIMPMAXIT: TLabel;
    adeMOCWeightFactor: TArgusDataEntry;
    adeMOCNumIter: TArgusDataEntry;
    adeMOCTolerance: TArgusDataEntry;
    adeMOCMaxIter: TArgusDataEntry;
    statbarMain: TStatusBar;
    tabCustomize: TTabSheet;
    comboCustomize: TComboBox;
    lblInitHeadFormula: TLabel;
    tabStream: TTabSheet;
    tabMoreStresses: TTabSheet;
    gbMoreStresses: TGroupBox;
    cbExpHFB: TCheckBox;
    cbExpFHB: TCheckBox;
    gbFHBPackage: TGroupBox;
    cbFHB: TCheckBox;
    lblFHBNumTimes: TLabel;
    adeFHBNumTimes: TArgusDataEntry;
    lblNBDTIM: TLabel;
    lblIFHBSS: TLabel;
    comboFHBSteadyStateOption: TComboBox;
    lblFHBSteadyStateOption: TLabel;
    lblFHBHeadConcWeight: TLabel;
    adeFHBHeadConcWeight: TArgusDataEntry;
    lblHeadWeight: TLabel;
    lblFluxWeight: TLabel;
    adeFHBFluxConcWeight: TArgusDataEntry;
    lblFHBFluxConcWeight: TLabel;
    tabMODPATH: TTabSheet;
    adeModpathMAXSIZ: TArgusDataEntry;
    lblModpathMAXSIZ: TLabel;
    adeModpathNPART: TArgusDataEntry;
    lblModpathNPART: TLabel;
    cbModpathCOMPACT: TCheckBox;
    cbModpathBINARY: TCheckBox;
    adeModpathTBEGIN: TArgusDataEntry;
    lblModpathTBEGIN: TLabel;
    adeModpathBeginPeriod: TArgusDataEntry;
    lblModpathBeginPeriod: TLabel;
    adeModpathBeginStep: TArgusDataEntry;
    adeModpathEndPeriod: TArgusDataEntry;
    adeModpathEndStep: TArgusDataEntry;
    lblModpathBeginStep: TLabel;
    lblModpathEndPeriod: TLabel;
    lblModpathEndStep: TLabel;
    adeMODPATHMaxReleaseTime: TArgusDataEntry;
    lblMODPATHMaxReleaseTime: TLabel;
    tabModpathTimes: TTabSheet;
    lblMODPATHOutputTimeCount: TLabel;
    tabZoneBudget: TTabSheet;
    pnlZoneBud1: TPanel;
    adeZonebudgetTitle: TArgusDataEntry;
    sgZoneBudCompZones: TStringGrid;
    lblZonebudgetTitle: TLabel;
    lblZoneBudCompZones: TLabel;
    adeZoneBudCompZoneCount: TArgusDataEntry;
    lblZoneBudCompZoneCount: TLabel;
    sgZondbudTimes: TStringGrid;
    rgZonebudTimesChoice: TRadioGroup;
    adeMODPATHOutputTimeCount: TArgusDataEntry;
    lblZonebudSpecTime: TLabel;
    lblNVALUES: TLabel;
    pnlMODPATH1: TPanel;
    pnlMODPATHTitle: TPanel;
    sgMODPATHOutputTimes: TStringGrid;
    adeZonebudgetPath: TArgusDataEntry;
    rbRunZonebudget: TRadioButton;
    rbCreateZonebudget: TRadioButton;
    tabAbout: TTabSheet;
    rbMPATHCreate: TRadioButton;
    rbMPATHRun: TRadioButton;
    adeMODPATHPath: TArgusDataEntry;
    tabMODPATHOptions: TTabSheet;
    tabProblem: TTabSheet;
    reProblem: TRichEdit;
    pnlProblem: TPanel;
    btnDeveloper: TButton;
    pnlFHB1: TPanel;
    pnlFHB2: TPanel;
    lblFHB: TLabel;
    sgFHBTimes: TStringGrid;
    cbExpStr: TCheckBox;
    comboMOC3D_IDIREC: TComboBox;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    tabPrivate2: TTabSheet;
    lblMOC3DFirstRow: TLabel;
    adeMOC3DRow1: TArgusDataEntry;
    lblMOC3DISROW1: TLabel;
    lblMOC3DLastRow: TLabel;
    adeMOC3DRow2: TArgusDataEntry;
    lblMOC3DISROW2: TLabel;
    lblMOC3DFirstColumn: TLabel;
    adeMOC3DCol1: TArgusDataEntry;
    lblMOC3DISCOL1: TLabel;
    lblMOC3DLastColumn: TLabel;
    adeMOC3DCol2: TArgusDataEntry;
    lblMOC3DISCOL2: TLabel;
    lblMOC3DSubgridInfo: TLabel;
    rgMOC3DSolver: TRadioGroup;
    btnOpenVal: TBitBtn;
    btnSaveVal: TBitBtn;
    gboxStressPackages: TGroupBox;
    lblRech: TLabel;
    lblRechOpt: TLabel;
    lblRiver: TLabel;
    lblWell: TLabel;
    lblDrain: TLabel;
    lblGenHeadBound: TLabel;
    lblEvap: TLabel;
    lblEvapOpt: TLabel;
    lblNRCHOP: TLabel;
    cbRCH: TCheckBox;
    cbRIV: TCheckBox;
    cbWEL: TCheckBox;
    cbDRN: TCheckBox;
    cbGHB: TCheckBox;
    cbEVT: TCheckBox;
    comboRchSteady: TComboBox;
    comboRivSteady: TComboBox;
    comboWelSteady: TComboBox;
    comboDrnSteady: TComboBox;
    comboGhbSteady: TComboBox;
    comboEvtSteady: TComboBox;
    comboRchOpt: TComboBox;
    comboEvtOption: TComboBox;
    gbStream: TGroupBox;
    lblStream: TLabel;
    cbSTR: TCheckBox;
    comboStreamOption: TComboBox;
    comboModelUnits: TComboBox;
    cbStreamCalcFlow: TCheckBox;
    cbStreamTrib: TCheckBox;
    cbStreamDiversions: TCheckBox;
    lblStreamModelUnits: TLabel;
    rgSolMeth: TRadioGroup;
    gboxMFListing: TGroupBox;
    lblPrintHead: TLabel;
    lblPrintDrawdown: TLabel;
    lblPrintBudget: TLabel;
    lblHeadPrintN: TLabel;
    lblDrawdownPrintN: TLabel;
    lblBudgetPrintN: TLabel;
    comboHeadPrintFreq: TComboBox;
    comboDrawdownPrintFreq: TComboBox;
    comboBudPrintFreq: TComboBox;
    adeHeadPrintFreq: TArgusDataEntry;
    adeDrawdownPrintFreq: TArgusDataEntry;
    adeBudPrintFreq: TArgusDataEntry;
    gboxOutputExternal: TGroupBox;
    lblHeadExpFreq: TLabel;
    lblDrawdownExpFreq: TLabel;
    lblFlowExpFreq: TLabel;
    lblFlowExportN: TLabel;
    lblDrawdownExportN: TLabel;
    lblExportHeadN: TLabel;
    comboHeadExportFreq: TComboBox;
    comboDrawdownExportFreq: TComboBox;
    comboBudExportFreq: TComboBox;
    adeHeadExportFreq: TArgusDataEntry;
    adeDrawdownExportFreq: TArgusDataEntry;
    adeBudExportFreq: TArgusDataEntry;
    lblExpBCFFlow: TLabel;
    lblExpRCHFlow: TLabel;
    lblExpDRNFlow: TLabel;
    lblExpGHBFlow: TLabel;
    cbFlowBCF: TCheckBox;
    cbFlowRCH: TCheckBox;
    cbFlowDrn: TCheckBox;
    cbFlowGHB: TCheckBox;
    lblExpRIVFlow: TLabel;
    lblExpWELFlow: TLabel;
    lblExpEVTFlow: TLabel;
    lblExpFHBFlow: TLabel;
    lblExpSTRFlow: TLabel;
    cbFlowSTR: TCheckBox;
    cbFlowFHB: TCheckBox;
    cbFlowEVT: TCheckBox;
    cbFlowWel: TCheckBox;
    cbFlowRiv: TCheckBox;
    cbSpecifyFlowFiles: TCheckBox;
    lblMatrixStorage: TLabel;
    comboIAPART: TComboBox;
    lblIAPART: TLabel;
    gboxMisc: TGroupBox;
    lblISTRT: TLabel;
    lblKeepInitHeads: TLabel;
    lblHeadValue: TLabel;
    lblHNOFLOW: TLabel;
    comboISTRT: TComboBox;
    adeHNOFLO: TArgusDataEntry;
    cbStrPrintFlows: TCheckBox;
    lblExpSTRFlow2: TLabel;
    cbFlowSTR2: TCheckBox;
    lblExpSTRFlow1A: TLabel;
    lblStrPrintFlows: TLabel;
    lblNEVTOP: TLabel;
    pnlGeoButtons: TPanel;
    pnlGeolUnitsButtons: TPanel;
    btnInsertUnit: TButton;
    btnDeleteUnit: TButton;
    btnAdd: TButton;
    gbMPATHReftime: TGroupBox;
    lblMPATHStartTimeMethod: TLabel;
    comboMPATHStartTimeMethod: TComboBox;
    lblMPATHRefPeriod: TLabel;
    adeMPATHRefPeriod: TArgusDataEntry;
    lblMPATHRefStep: TLabel;
    adeMPATHRefStep: TArgusDataEntry;
    lblMPATHRefTimeInStep: TLabel;
    adeMPATHRefTimeInStep: TArgusDataEntry;
    lblMPATHRefTime: TLabel;
    adeMPATHRefTime: TArgusDataEntry;
    gbMPATHStop: TGroupBox;
    cbMPATHStopTime: TCheckBox;
    adeMODPATHStopTime: TArgusDataEntry;
    cbMPATHTrackStop: TCheckBox;
    adeMPATHMaxTrack: TArgusDataEntry;
    lblMODPATHStopTime: TLabel;
    lblMPATHMaxTrack: TLabel;
    lblMPATHTrackStop: TLabel;
    gbMPATHOutputTime: TGroupBox;
    adeMPATHMaxTimes: TArgusDataEntry;
    lblMPATHMaxTimes: TLabel;
    adeMPATHTimeInt: TArgusDataEntry;
    lblMPATHTimeInt: TLabel;
    comboMPATHTimeMethod: TComboBox;
    lblMPATHTimeMethod: TLabel;
    gbMPATHMode: TGroupBox;
    comboMPATHOutMode: TComboBox;
    lblMPATHOutMode: TLabel;
    cbMPATHComputeLoc: TCheckBox;
    lblMPATHComputeLoc: TLabel;
    lblMPATHStopZone: TLabel;
    adeMPATHStopZone: TArgusDataEntry;
    cbMPATHStop: TCheckBox;
    lblMPATHStop: TLabel;
    comboMPATHWhichParticles: TComboBox;
    gbMPATHMisc: TGroupBox;
    lblMPATHDirection: TLabel;
    comboMPATHDirection: TComboBox;
    cbMPathBudget: TCheckBox;
    adeMPathErrorTolerance: TArgusDataEntry;
    lblMPATHSinkTreatment: TLabel;
    comboMPATHSinkTreatment: TComboBox;
    lblMPATHSinkStrength: TLabel;
    adeMPATHSinkStrength: TArgusDataEntry;
    cbMPathSummarize: TCheckBox;
    lblMPathErrorTolerance: TLabel;
    cbRCHRetain: TCheckBox;
    cbRIVRetain: TCheckBox;
    cbWELRetain: TCheckBox;
    cbDRNRetain: TCheckBox;
    cbGHBRetain: TCheckBox;
    cbEVTRetain: TCheckBox;
    cbSTRRetain: TCheckBox;
    cbFHBRetain: TCheckBox;
    comboHeadPrintStyle: TComboBox;
    comboHeadPrintFormat: TComboBox;
    comboDrawdownPrintStyle: TComboBox;
    comboDrawdownPrintFormat: TComboBox;
    cbActiveBoundary: TCheckBox;
    cbCalibrate: TCheckBox;
    cbShowWarnings: TCheckBox;
    tabAgeDpDk: TTabSheet;
    gbAge: TGroupBox;
    cbAge: TCheckBox;
    adeAge: TArgusDataEntry;
    lblAge: TLabel;
    gbDualPorosity: TGroupBox;
    cbDualPorosity: TCheckBox;
    lblDualPOutOption: TLabel;
    comboDualPOutOption: TComboBox;
    gbSimpleReactions: TGroupBox;
    cbIDKRF: TCheckBox;
    cbIDKFO: TCheckBox;
    cbIDKFS: TCheckBox;
    cbSimpleReactions: TCheckBox;
    PageControlSolvers: TPageControl;
    tabSIP: TTabSheet;
    tabDE4: TTabSheet;
    tabPCG2: TTabSheet;
    tabSOR: TTabSheet;
    gboxSIP: TGroupBox;
    lblSIPMaxIter: TLabel;
    lblSIPNumParam: TLabel;
    lblSIPAcclParam: TLabel;
    lblSIPConv: TLabel;
    lblSIPIterSeedChoice: TLabel;
    lblSIPIterSeed: TLabel;
    lblSIPPrintInt: TLabel;
    lblSIPMXITER: TLabel;
    lblSIPNPARM: TLabel;
    lblSIPACCL: TLabel;
    lblSIPHCLOSE: TLabel;
    lblSIPIPCALC: TLabel;
    lblSIPWSEED: TLabel;
    lblSIPIPRSIP: TLabel;
    adeSIPMaxIter: TArgusDataEntry;
    adeSIPNumParam: TArgusDataEntry;
    adeSIPAcclParam: TArgusDataEntry;
    adeSIPConv: TArgusDataEntry;
    adeSIPIterSeed: TArgusDataEntry;
    adeSIPPrint: TArgusDataEntry;
    comboSIPIterSeed: TComboBox;
    gboxDE4: TGroupBox;
    lblDE4MaxIt: TLabel;
    lblDE4MaxEqU: TLabel;
    lblDE4MaxEqL: TLabel;
    lblDE4MaxBand: TLabel;
    lblDE4Freq: TLabel;
    lblDE4Print: TLabel;
    lblDE4Acceleration: TLabel;
    lblDE4Conv: TLabel;
    lblDE4Time: TLabel;
    lblDE4ITMX: TLabel;
    lblDE4MXUP: TLabel;
    lblDE4MXLOW: TLabel;
    lblDE4MXBW: TLabel;
    lblDE4IFREQ: TLabel;
    lblDE4MUTD4: TLabel;
    lblDE4ACCL: TLabel;
    lblDE4HCLOSE: TLabel;
    lblDE4IPRD4: TLabel;
    adeDE4MaxIter: TArgusDataEntry;
    adeDE4MaxUp: TArgusDataEntry;
    adeDE4MaxLow: TArgusDataEntry;
    adeDE4Band: TArgusDataEntry;
    adeDE4Accl: TArgusDataEntry;
    adeDE4Conv: TArgusDataEntry;
    adeDE4TimeStep: TArgusDataEntry;
    comboDE4Freq: TComboBox;
    comboDE4Print: TComboBox;
    gboxPCG2: TGroupBox;
    lblPCGMaxOuter: TLabel;
    lblPCGMaxInner: TLabel;
    lblPCGMethod: TLabel;
    lblPCGMaxChangeHead: TLabel;
    lblPCGMaxResidual: TLabel;
    lblPCGRelaxation: TLabel;
    lblPCGMaxEigen: TLabel;
    lblPCGPrintInterval: TLabel;
    lblPCGPrintControl: TLabel;
    lblPCGDampingFactor: TLabel;
    lblPCGMXITER: TLabel;
    lblPCGITER1: TLabel;
    lblPCGNPCOND: TLabel;
    lblPCGHCLOSE: TLabel;
    lblPCGRCLOSE: TLabel;
    lblPCGRELAX: TLabel;
    lblPCGNBPOL: TLabel;
    lblPCGIPRPCG: TLabel;
    lblPCGMUTPCG: TLabel;
    lblPCGDAMP: TLabel;
    adePCGMaxOuter: TArgusDataEntry;
    adePCGMaxInner: TArgusDataEntry;
    comboPCGPrecondMeth: TComboBox;
    adePCGMaxHeadChange: TArgusDataEntry;
    adePCGMaxResChange: TArgusDataEntry;
    adePCGRelax: TArgusDataEntry;
    comboPCGEigenValue: TComboBox;
    adePCGPrintInt: TArgusDataEntry;
    comboPCGPrint: TComboBox;
    adePCGDamp: TArgusDataEntry;
    gboxSOR: TGroupBox;
    lblSORMaxIterations: TLabel;
    lblSORAcceleration: TLabel;
    lblSORConvergence: TLabel;
    lblSORPrintInterval: TLabel;
    lblSORMXITER: TLabel;
    lblSORACCL: TLabel;
    lblSORHCLOSE: TLabel;
    lblSORIPRSOR: TLabel;
    adeSORMaxIter: TArgusDataEntry;
    adeSORAccl: TArgusDataEntry;
    adeSORConv: TArgusDataEntry;
    adeSORPri: TArgusDataEntry;
    lblAgeWarning: TLabel;
    cbIDPTIM_Decay: TCheckBox;
    cbIDPTIM_Growth: TCheckBox;
    cbIDKTIM_DisDecay: TCheckBox;
    cbIDKTIM_SorbDecay: TCheckBox;
    cbIDKTIM_DisGrowth: TCheckBox;
    cbIDKTIM_SorbGrowth: TCheckBox;
    gbInitialHeads: TGroupBox;
    cbInitial: TCheckBox;
    edInitial: TEdit;
    btnInitialSelect: TBitBtn;
    lblInitialHeads: TLabel;
    cbProgressBar: TCheckBox;
    cbIDPTIM_LinExch: TCheckBox;
    tabParameters: TTabSheet;
    PageControlParameters: TPageControl;
    tabLayerProperty: TTabSheet;
    dgLPFParameters: TDataGrid;
    tabMultZone: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    dg3dLPFParameterClusters: TRBWDataGrid3d;
    Panel1: TPanel;
    adeLPFParamCount: TArgusDataEntry;
    lblLPFParamCount: TLabel;
    tabRechargeParam: TTabSheet;
    Panel2: TPanel;
    lblRCHParamCount: TLabel;
    adeRCHParamCount: TArgusDataEntry;
    dgRCHParametersN: TDataGrid;
    Splitter3: TSplitter;
    tabEvapParam: TTabSheet;
    Panel3: TPanel;
    lblEVTParamCount: TLabel;
    adeEVTParamCount: TArgusDataEntry;
    dgEVTParametersN: TDataGrid;
    Splitter4: TSplitter;
    dgTime: TDataGrid;
    lblExpLPFFlow: TLabel;
    cbFlowLPF: TCheckBox;
    tabRivParam: TTabSheet;
    dgRIVParametersN: TDataGrid;
    Panel4: TPanel;
    lblRIVParamCount: TLabel;
    adeRIVParamCount: TArgusDataEntry;
    tabWelParam: TTabSheet;
    dgWELParametersN: TDataGrid;
    Panel5: TPanel;
    lblWELParamCount: TLabel;
    adeWELParamCount: TArgusDataEntry;
    cbUseSimpleReactions: TCheckBox;
    cbUseDualPorosity: TCheckBox;
    lblAgeWarning2: TLabel;
    tabDrnParam: TTabSheet;
    dgDRNParametersN: TDataGrid;
    Panel6: TPanel;
    lblDRNParamCount: TLabel;
    adeDRNParamCount: TArgusDataEntry;
    tabGhbParam: TTabSheet;
    dgGHBParametersN: TDataGrid;
    Panel7: TPanel;
    lblGHBParamCount: TLabel;
    adeGHBParamCount: TArgusDataEntry;
    tabHFBParam: TTabSheet;
    dgHFBParameters: TDataGrid;
    Panel8: TPanel;
    lblHFBParamCount: TLabel;
    adeHFBParamCount: TArgusDataEntry;
    cbExpDIS: TCheckBox;
    cbExpLPF: TCheckBox;
    cbExpMULT: TCheckBox;
    cbExpZONE: TCheckBox;
    tabObservations: TTabSheet;
    PageControlObservations: TPageControl;
    tabGHBObservations: TTabSheet;
    tabDrainObservations: TTabSheet;
    tabRiverObservations: TTabSheet;
    tabHeadFluxObservations: TTabSheet;
    cbGBOB: TCheckBox;
    cbDROB: TCheckBox;
    cbRVOB: TCheckBox;
    cbCHOB: TCheckBox;
    tabHeadObservations: TTabSheet;
    gbHeadObs: TGroupBox;
    lblObsHeadCount: TLabel;
    lblWeightedHeadObsLayerCount: TLabel;
    lblHeadObsLayerCount: TLabel;
    lblHeadObsErrMult: TLabel;
    cbHeadObservations: TCheckBox;
    cbWeightedHeadObservations: TCheckBox;
    adeHeadObsLayerCount: TArgusDataEntry;
    adeWeightedHeadObsLayerCount: TArgusDataEntry;
    adeObsHeadCount: TArgusDataEntry;
    adeHeadObsErrMult: TArgusDataEntry;
    gbObservationsOutput: TGroupBox;
    cbCreateObsOutput: TCheckBox;
    comboObservationScaling: TComboBox;
    tabSensitivity: TTabSheet;
    panelSensitivity: TPanel;
    adeSensitivityCount: TArgusDataEntry;
    lblSensitivityCount: TLabel;
    dgSensitivity: TDataGrid;
    comboSensEst: TComboBox;
    comboSensMemory: TComboBox;
    rgSensPrint: TRadioGroup;
    cbSensBinary: TCheckBox;
    comboSensFormat: TComboBox;
    lblSensFormat: TLabel;
    cbSensPrint: TCheckBox;
    lblSensEst: TLabel;
    lblSensMemory: TLabel;
    cbHOB: TCheckBox;
    cbSEN: TCheckBox;
    tabParamEst: TTabSheet;
    pagecontrolParamEst: TPageControl;
    tabParamEstCov: TTabSheet;
    tabPriorInfoEstEquations: TTabSheet;
    tabParamEstControlParam: TTabSheet;
    gbParamEst: TGroupBox;
    lblMaxParamEstIterations: TLabel;
    lblMaxParamChange: TLabel;
    lblParamEstTol: TLabel;
    lblParamEstSecClosCrit: TLabel;
    adeMaxParamEstIterations: TArgusDataEntry;
    adeMaxParamChange: TArgusDataEntry;
    adeParamEstTol: TArgusDataEntry;
    adeParamEstSecClosCrit: TArgusDataEntry;
    gbParamOccasional: TGroupBox;
    lblBealeInput: TLabel;
    lblYcintInput: TLabel;
    lblParamEstRMatrixIterations: TLabel;
    lblParamEstRMatrixCriterion: TLabel;
    comboBealeInput: TComboBox;
    comboYcintInput: TComboBox;
    cbParamEstScreenPrint: TCheckBox;
    cbParamEstRMatrix: TCheckBox;
    adeParamEstRMatrixIterations: TArgusDataEntry;
    adeParamEstRMatrixCriterion: TArgusDataEntry;
    tabMiscParamEstOptions: TTabSheet;
    gbParamEstPrintControl: TGroupBox;
    lblParamEstVarPrintFormat: TLabel;
    lblParamEstStatisticsPrint: TLabel;
    comboParamEstVarPrintFormat: TComboBox;
    comboParamEstStatisticsPrint: TComboBox;
    cbParamEstEigenvectorPrint: TCheckBox;
    gbRarelyModified: TGroupBox;
    lblParamEstSearchDirection: TLabel;
    lblParamEstCoarseConvCrit: TLabel;
    adeParamEstSearchDirection: TArgusDataEntry;
    adeParamEstCoarseConvCrit: TArgusDataEntry;
    comboLastx: TComboBox;
    Panel14: TPanel;
    Panel15: TPanel;
    adeParamEstCovNameCount: TArgusDataEntry;
    lblParamEstCovNameCount: TLabel;
    dgParamEstCovNames: TDataGrid;
    dgParamEstCovariance: TDataGrid;
    Panel16: TPanel;
    adePriorInfoEquationCount: TArgusDataEntry;
    lblLastx: TLabel;
    dgPriorEquations: TDataGrid;
    cbPESExport: TCheckBox;
    lblObservationScaling: TLabel;
    lblCreateObsOutput: TLabel;
    adeModflow2000Path: TArgusDataEntry;
    gbHeadFluxObservations: TGroupBox;
    lblHeadFluxObsLayerCount: TLabel;
    lblObsHeadFluxTimeCount: TLabel;
    lblHeadFluxObsPrintFormats: TLabel;
    lblHeadFluxObsErrMult: TLabel;
    lblHeadFluxObsBoundCount: TLabel;
    adeHeadFluxObsLayerCount: TArgusDataEntry;
    adeObsHeadFluxTimeCount: TArgusDataEntry;
    comboHeadFluxObsPrintFormats: TComboBox;
    adeHeadFluxObsErrMult: TArgusDataEntry;
    adeHeadFluxObsBoundCount: TArgusDataEntry;
    gbGHBObservations: TGroupBox;
    lblObsGHBTimeCount: TLabel;
    lblGHBObsLayerCount: TLabel;
    lblGHBObsPrintFormats: TLabel;
    lblGHBObsErrMult: TLabel;
    lblGHBObsBoundCount: TLabel;
    cbGHBObservations: TCheckBox;
    cbSpecifyGHBCovariances: TCheckBox;
    adeGHBObsLayerCount: TArgusDataEntry;
    adeObsGHBTimeCount: TArgusDataEntry;
    comboGHBObsPrintFormats: TComboBox;
    adeGHBObsErrMult: TArgusDataEntry;
    adeGHBObsBoundCount: TArgusDataEntry;
    gbDrainObservations: TGroupBox;
    lblDRNObsLayerCount: TLabel;
    lblObsDRNTimeCount: TLabel;
    lblDrainObsPrintFormats: TLabel;
    lblDrnObsErrMult: TLabel;
    lblDRNObsBoundCount: TLabel;
    cbDRNObservations: TCheckBox;
    cbSpecifyDRNCovariances: TCheckBox;
    adeDRNObsLayerCount: TArgusDataEntry;
    adeObsDRNTimeCount: TArgusDataEntry;
    comboDrainObsPrintFormats: TComboBox;
    adeDrnObsErrMult: TArgusDataEntry;
    adeDRNObsBoundCount: TArgusDataEntry;
    gbRiverObservations: TGroupBox;
    lblRIVObsLayerCount: TLabel;
    lblObsRIVTimeCount: TLabel;
    lblRiverObsPrintFormats: TLabel;
    lblRivObsErrMult: TLabel;
    lblRIVObsBoundCount: TLabel;
    cbRIVObservations: TCheckBox;
    cbSpecifyRiverCovariances: TCheckBox;
    adeRIVObsLayerCount: TArgusDataEntry;
    adeObsRIVTimeCount: TArgusDataEntry;
    comboRiverObsPrintFormats: TComboBox;
    adeRivObsErrMult: TArgusDataEntry;
    adeRIVObsBoundCount: TArgusDataEntry;
    Panel9: TPanel;
    dgNegParam: TDataGrid;
    Panel10: TPanel;
    Splitter5: TSplitter;
    lblParamEstCovNames: TLabel;
    lblPriorInfoEquationCount: TLabel;
    lblPriorEquations: TLabel;
    gbProcesses: TGroupBox;
    cbObservations: TCheckBox;
    cbSensitivity: TCheckBox;
    cbParamEst: TCheckBox;
    cbMOC3D: TCheckBox;
    cbMODPATH: TCheckBox;
    cbZonebudget: TCheckBox;
    lblMOC3DParticlLoc: TLabel;
    comboMOC3DPartFileType: TComboBox;
    lblMOC3DDispCoef: TLabel;
    comboMOC3DVelFileType: TComboBox;
    comboMOC3DConcFileType: TComboBox;
    lblMOC3DConc: TLabel;
    lblMOC3DVelocity: TLabel;
    comboMOC3DPartFreq: TComboBox;
    comboMOC3DDispFreq: TComboBox;
    comboMOC3DVelFreq: TComboBox;
    comboMOC3DConcFreq: TComboBox;
    lblMOC3DConcN: TLabel;
    lblMOC3DVelocityN: TLabel;
    lblMOC3DDispCoefN: TLabel;
    lblMOC3DParticlLocN: TLabel;
    adeMOC3DPartFreq: TArgusDataEntry;
    adeMOC3DDispFreq: TArgusDataEntry;
    adeMOC3DVelFreq: TArgusDataEntry;
    adeMOC3DConcFreq: TArgusDataEntry;
    rgMOC3DConcFormat: TRadioGroup;
    Panel11: TPanel;
    sgMOC3DTransParam: TStringGrid;
    Panel12: TPanel;
    lblNumMOC3DGeolUnits: TLabel;
    adeMOCNumLayers: TArgusDataEntry;
    lblNumMOC3DLay: TLabel;
    cbMOC3DNoDisp: TCheckBox;
    tabAdvectionObservations: TTabSheet;
    gbAdvObservations: TGroupBox;
    lblAdvectObsLayerCount: TLabel;
    lblAdvectObsStartLayerCount: TLabel;
    lblAdvObsPrintFormats: TLabel;
    lblAdvObsBoundCount: TLabel;
    cbSpecifyAdvCovariances: TCheckBox;
    adeAdvectObsLayerCount: TArgusDataEntry;
    adeAdvectObsStartLayerCount: TArgusDataEntry;
    comboAdvObsPrintFormats: TComboBox;
    adeAdvObsBoundCount: TArgusDataEntry;
    cbAdvObs: TCheckBox;
    rgAdvObsDisplacementOption: TRadioGroup;
    adeAdvstp: TArgusDataEntry;
    lblAdvstp: TLabel;
    rgPartDisp: TRadioGroup;
    cbADOB: TCheckBox;
    lblFlowLak: TLabel;
    cbFlowLak: TCheckBox;
    cbExpLAK: TCheckBox;
    lblRchSteady: TLabel;
    lblRivSteady: TLabel;
    lblWelSteady: TLabel;
    lblDrnSteady: TLabel;
    lblGhbSteady: TLabel;
    lblEvtSteady: TLabel;
    lblStreamOption: TLabel;
    tabPackages: TTabSheet;
    pageControlPackages: TPageControl;
    tabFlowPackages: TTabSheet;
    gbIBS: TGroupBox;
    lblIBS: TLabel;
    cbIBS: TCheckBox;
    cbUseIBS: TCheckBox;
    lblIBSPrintFrequency: TLabel;
    comboIBSPrintFrequency: TComboBox;
    lblIBSPrintFrequencyN: TLabel;
    adeIBSPrintFrequency: TArgusDataEntry;
    comboIBSPrintFormat: TComboBox;
    comboIBSPrintStyle: TComboBox;
    lblIBSSaveFrequency: TLabel;
    comboIBSSaveFrequency: TComboBox;
    lblIBSSaveFrequencyN: TLabel;
    adeIBSSaveFrequency: TArgusDataEntry;
    lblFlowIBS: TLabel;
    cbFlowIBS: TCheckBox;
    cbExpIBS: TCheckBox;
    cbTips: TCheckBox;
    lblFlowRES: TLabel;
    cbFlowRES: TCheckBox;
    cbExpRES: TCheckBox;
    gbEllam: TGroupBox;
    lblEllamColumnExp: TLabel;
    lblEllamRowExp: TLabel;
    lblEllamLayerExp: TLabel;
    lblEllamTimeExp: TLabel;
    adeEllamColumnExp: TArgusDataEntry;
    adeEllamRowExp: TArgusDataEntry;
    adeEllamLayerExp: TArgusDataEntry;
    adeEllamTimeExp: TArgusDataEntry;
    lblNSCEXP: TLabel;
    lblNSREXP: TLabel;
    lblNSLEXP: TLabel;
    lblNTEXP: TLabel;
    tabMOC3D: TTabSheet;
    PageControlMOC3D: TPageControl;
    BitBtnHelp: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    gbTransientLeakage: TGroupBox;
    dgIBS: TDataGrid;
    cbTLK: TCheckBox;
    cbTLKRetain: TCheckBox;
    lblTLK: TLabel;
    adeTLKNumberOfTerms: TArgusDataEntry;
    lblTLKNumberOfTerms: TLabel;
    cbTLKSaveRestartFile: TCheckBox;
    cbTLKStartFromRestart: TCheckBox;
    lblTLKRestartFile: TLabel;
    edTLKRestartFile: TEdit;
    btnTLKRestartFile: TBitBtn;
    lblFlowTLK: TLabel;
    cbFlowTLK: TCheckBox;
    cbExpTLK: TCheckBox;
    rbModflow96: TRadioButton;
    rbMODFLOW2000: TRadioButton;
    lblLengthUnits: TLabel;
    comboLengthUnits: TComboBox;
    comboTimeUnits: TComboBox;
    lblITMUNI: TLabel;
    rgMode: TRadioGroup;
    Panel13: TPanel;
    lblHorFlowBar: TLabel;
    cbHFB: TCheckBox;
    cbHFBRetain: TCheckBox;
    rgFlowPackage: TRadioGroup;
    adeRMAR: TArgusDataEntry;
    adeRMARM: TArgusDataEntry;
    lblRMAR: TLabel;
    lblRMARM: TLabel;
    lblDiffusUnits: TLabel;
    lblHdryUnits: TLabel;
    lblLakeOutput: TLabel;
    btnShowTip: TButton;
    tabModpathGroup: TTabSheet;
    pageControlModpath: TPageControl;
    adeResanPath: TArgusDataEntry;
    btnImport: TButton;
    adeYcintPath: TArgusDataEntry;
    adeBealePath: TArgusDataEntry;
    cbResan: TCheckBox;
    cbYcint: TCheckBox;
    cbBeale: TCheckBox;
    cbIAP: TCheckBox;
    adeMODPATH41Path: TArgusDataEntry;
    rgPriorInfoDataType: TRadioGroup;
    btnModflowImport: TButton;
    tabSFR_Parameters: TTabSheet;
    dgSFRParametersN: TDataGrid;
    Panel17: TPanel;
    lblSFRParamCount: TLabel;
    adeSFRParamCount: TArgusDataEntry;
    gbStreamFlowRouting: TGroupBox;
    lblSFR: TLabel;
    lblSFRPrintFlows: TLabel;
    lblSFROption: TLabel;
    lblStreamTolerance: TLabel;
    lblStreamTableEntriesCount: TLabel;
    cbSFR: TCheckBox;
    comboSFROption: TComboBox;
    cbSFRCalcFlow: TCheckBox;
    cbSFRTrib: TCheckBox;
    cbSFRDiversions: TCheckBox;
    cbSFRPrintFlows: TCheckBox;
    cbSFRRetain: TCheckBox;
    adeStreamTolerance: TArgusDataEntry;
    adeStreamTableEntriesCount: TArgusDataEntry;
    cbFlowSFR: TCheckBox;
    lblFlowSFR: TLabel;
    lblExpSFRFlow1A: TLabel;
    cbFlowSFR2: TCheckBox;
    lblFlowSFR2: TLabel;
    cbExpSfr: TCheckBox;
    adeMF2K_GWTPath: TArgusDataEntry;
    adeAdvObsDischargeLimit: TArgusDataEntry;
    lblAdvObsDischargeLimit: TLabel;
    gbBasicOptions: TGroupBox;
    cbCHTOCH: TCheckBox;
    btnCalculateDecay: TButton;
    tabSTR_Parameters: TTabSheet;
    dgSTRParametersN: TDataGrid;
    Panel18: TPanel;
    lblSTRParamCount: TLabel;
    adeSTRParamCount: TArgusDataEntry;
    tabStreamObservations: TTabSheet;
    dgSTRObsBoundCovariances: TDataGrid;
    lblWTQ_Stream: TLabel;
    gbStreamObservations: TGroupBox;
    lblObsSTRTimeCount: TLabel;
    lblStreamObsPrintFormats: TLabel;
    lblStrObsErrMult: TLabel;
    lblSTRObsBoundCount: TLabel;
    cbStreamObservations: TCheckBox;
    cbSpecifyStreamCovariances: TCheckBox;
    adeObsSTRTimeCount: TArgusDataEntry;
    comboStreamObsPrintFormats: TComboBox;
    adeStrObsErrMult: TArgusDataEntry;
    adeSTRObsBoundCount: TArgusDataEntry;
    cbSTOB: TCheckBox;
    tabETSParameters: TTabSheet;
    dgETSParametersN: TDataGrid;
    Panel19: TPanel;
    lblETSParamCount: TLabel;
    adeETSParamCount: TArgusDataEntry;
    Splitter6: TSplitter;
    cbFlowETS: TCheckBox;
    lblFlowETS: TLabel;
    cbExpETS: TCheckBox;
    tabStress3: TTabSheet;
    lblDRT: TLabel;
    cbDRT: TCheckBox;
    cbDRTRetain: TCheckBox;
    comboDrtSteady: TComboBox;
    lblDrtSteady: TLabel;
    tabDrtParam: TTabSheet;
    dgDRTParametersN: TDataGrid;
    Panel20: TPanel;
    lblDRTParamCount: TLabel;
    adeDRTParamCount: TArgusDataEntry;
    tabDrtObservations: TTabSheet;
    gbDrainReturnObservations: TGroupBox;
    lblDRTObsLayerCount: TLabel;
    lblObsDRTTimeCount: TLabel;
    lblDrainReturnObsPrintFormats: TLabel;
    lblDrtObsErrMult: TLabel;
    lblDRTObsBoundCount: TLabel;
    cbDRTObservations: TCheckBox;
    cbSpecifyDRTCovariances: TCheckBox;
    adeDRTObsLayerCount: TArgusDataEntry;
    adeObsDRTTimeCount: TArgusDataEntry;
    comboDrainReturnObsPrintFormats: TComboBox;
    adeDrtObsErrMult: TArgusDataEntry;
    adeDRTObsBoundCount: TArgusDataEntry;
    cbFlowDrt: TCheckBox;
    lblFlowDrt: TLabel;
    cbExpDRT: TCheckBox;
    cbDTOB: TCheckBox;
    tabLinkAMG: TTabSheet;
    gbLinkAMG: TGroupBox;
    adeAMG_Stor1: TArgusDataEntry;
    lblAMG_Stor1: TLabel;
    adeAMG_Stor2: TArgusDataEntry;
    lblAMG_Stor2: TLabel;
    adeAMG_Stor3: TArgusDataEntry;
    lblAMG_Stor3: TLabel;
    cbAMG_ICG: TCheckBox;
    ade_AMG_MXITER: TArgusDataEntry;
    lbl_AMG_MXITER: TLabel;
    ade_AMG_MXCYC: TArgusDataEntry;
    lbl_AMG_MXCYC: TLabel;
    ade_AMG_BCLOSE: TArgusDataEntry;
    lbl_AMG_BCLOSE: TLabel;
    ade_AMG_DAMP: TArgusDataEntry;
    lbl_AMG_DampingMethod: TLabel;
    ade_AMG_DUP: TArgusDataEntry;
    lbl_AMG_DUP: TLabel;
    ade_AMG_DLOW: TArgusDataEntry;
    lbl_AMG_DLOW: TLabel;
    combo_AMG_DampingMethod: TComboBox;
    lbl_AMG_DampingMethodCaption: TLabel;
    lbl_AMG_DAMP: TLabel;
    lblAMG_Stor1Caption: TLabel;
    lblAMG_Stor2Caption: TLabel;
    lblAMG_Stor3Caption: TLabel;
    lbl_AMG_MXITERCaption: TLabel;
    lbl_AMG_MXCYCCaption: TLabel;
    lbl_AMG_BCLOSECaption: TLabel;
    lbl_AMG_DAMPCaption: TLabel;
    lbl_AMG_DUPCaption: TLabel;
    lbl_AMG_DLOWCaption: TLabel;
    lblAMG_ICG: TLabel;
    GroupBox1: TGroupBox;
    rb_AMG_IOUTAMG_0: TRadioButton95;
    rb_AMG_IOUTAMG_1: TRadioButton95;
    rb_AMG_IOUTAMG_2: TRadioButton95;
    rb_AMG_IOUTAMG_3: TRadioButton95;
    edDiscretization: TEdit;
    lblHYD: TLabel;
    cbHYD: TCheckBox;
    cbHYDRetain: TCheckBox;
    adeHydInactive: TArgusDataEntry;
    lblHydInactive: TLabel;
    cbExpHYD: TCheckBox;
    cbUseAreaRivers: TCheckBox;
    cbUseAreaWells: TCheckBox;
    cbUseAreaDrains: TCheckBox;
    cbUseAreaGHBs: TCheckBox;
    cbUseAreaFHBs: TCheckBox;
    cbUseAreaDrainReturns: TCheckBox;
    rbYcint: TRadioButton;
    rbBeale: TRadioButton;
    Panel21: TPanel;
    Image1: TImage;
    lblDebug: TLabel;
    lblDebugVersion: TLabel;
    lblVersion: TLabel;
    lblFileVersionCaption: TLabel;
    lblTitle: TLabel;
    lblAuthors: TLabel;
    lblSupport: TLabel;
    aslMail: TASLink;
    aslRbwinst: TASLink;
    lblTel: TLabel;
    aslMfGUI: TASLink;
    lblArgus: TLabel;
    aslArgusemail: TASLink;
    aslArgusWeb: TASLink;
    cbLargeMPATH_Budget: TCheckBox95;
    lblLargeMPATH_Budget: TLabel;
    Splitter7: TSplitter;
    sg3dWelParamInstances: TRBWStringGrid3d;
    sg3dDRNParamInstances: TRBWStringGrid3d;
    Splitter8: TSplitter;
    Splitter9: TSplitter;
    sg3dDRTParamInstances: TRBWStringGrid3d;
    Panel22: TPanel;
    dg3dETSParameterClusters: TRBWDataGrid3d;
    Panel23: TPanel;
    dg3dEVTParameterClusters: TRBWDataGrid3d;
    sg3dETSParamInstances: TRBWStringGrid3d;
    Splitter10: TSplitter;
    sg3dEVTParamInstances: TRBWStringGrid3d;
    Splitter11: TSplitter;
    Splitter12: TSplitter;
    sg3dGHBParamInstances: TRBWStringGrid3d;
    Panel24: TPanel;
    dg3dRCHParameterClusters: TRBWDataGrid3d;
    sg3dRCHParamInstances: TRBWStringGrid3d;
    Splitter13: TSplitter;
    Splitter14: TSplitter;
    sg3dRIVParamInstances: TRBWStringGrid3d;
    Splitter15: TSplitter;
    sg3dSFRParamInstances: TRBWStringGrid3d;
    Splitter16: TSplitter;
    sg3dSTRParamInstances: TRBWStringGrid3d;
    btnDistributeParticles: TButton;
    lblCHD: TLabel;
    cbCHD: TCheckBox;
    cbCHDRetain: TCheckBox;
    cbUseAreaCHD: TCheckBox;
    tabCHDParameters: TTabSheet;
    dgCHDParameters: TDataGrid;
    Splitter18: TSplitter;
    Panel26: TPanel;
    lblCHDParamCount: TLabel;
    adeCHDParamCount: TArgusDataEntry;
    sg3dCHDParamInstances: TRBWStringGrid3d;
    alstdTips: TALSTipDlg;
    cbExpCHD: TCheckBox;
    gbLakes: TGroupBox;
    lblLakeConvCriterion: TLabel;
    lblLakIterations: TLabel;
    lblLakTheta: TLabel;
    lblLakSteady: TLabel;
    adeLakTheta: TArgusDataEntry;
    cbSubLakes: TCheckBox;
    adeLakIterations: TArgusDataEntry;
    cbLakePrint: TCheckBox;
    adeLakeConvCriterion: TArgusDataEntry;
    cbLAK: TCheckBox;
    cbLAKRetain: TCheckBox;
    comboLakSteady: TComboBox;
    pnlGeolUnitTop: TPanel;
    lblNumGeolUnits: TLabel;
    edNumUnits: TEdit;
    dgGeol: TDataGrid;
    framHUF1: TframHUF;
    tabHufParam: TTabSheet;
    dgHUFParameters: TDataGrid;
    Splitter19: TSplitter;
    dg3dHUFParameterClusters: TRBWDataGrid3d;
    Panel25: TPanel;
    lblHUFParamCount: TLabel;
    adeHUFParamCount: TArgusDataEntry;
    cbFlowHUF: TCheckBox;
    lblFlowHUF: TLabel;
    cbExpHUF: TCheckBox;
    Splitter17: TSplitter;
    tabMT3D: TTabSheet;
    PageControlMT3D: TPageControl;
    tabMT3DBas: TTabSheet;
    tabMT3DAdv1: TTabSheet;
    lblMT3DAdvSolMethod: TLabel;
    lblMT3DParticleTracking: TLabel;
    lblMT3DNumCellsParticle: TLabel;
    lblMT3DMaxParticlesCount: TLabel;
    lblMT3DConcWeight: TLabel;
    lblMT3DNegConcGrad: TLabel;
    lblMT3DInitParticlesSmall: TLabel;
    lblMT3DInitParticlesLarge: TLabel;
    lblMT3DMIXELM: TLabel;
    lblMT3DITRACK: TLabel;
    lblMT3DPERCEL: TLabel;
    lblMT3DMXPART: TLabel;
    lblMT3DWD: TLabel;
    lblMT3DDCEPS: TLabel;
    lblMT3DNPL: TLabel;
    lblMT3DNPH: TLabel;
    tabMT3DAdv2: TTabSheet;
    lblMT3DInitParticlePlacement: TLabel;
    lblMT3DInitParticlePlanes: TLabel;
    lblMT3DMinParticles: TLabel;
    lblMT3DMaxParticles: TLabel;
    lblMT3DInterpMeth: TLabel;
    lblMT3DSinkParticlePlacement: TLabel;
    lblMT3DSinParticlePlanes: TLabel;
    lblMT3DSinkParticleN: TLabel;
    lblMT3DCritConcGrad: TLabel;
    lblMT3DNPLANE: TLabel;
    lblMT3DNPMIN: TLabel;
    lblMT3DNPMAX: TLabel;
    lblMT3DINTERP: TLabel;
    lblMT3DNLSINK: TLabel;
    lblMT3DNPSINK: TLabel;
    lblMT3DDCHMOC: TLabel;
    tabMT3DChem: TTabSheet;
    gboxMT3DChemReact: TGroupBox;
    lblMT3DSorptionType: TLabel;
    lblMT3DFirstOrderReaction: TLabel;
    lblMT3DISOTHM: TLabel;
    lblMT3DIREACT: TLabel;
    grBoxMT3DReaction: TGroupBox;
    comboMT3DAdvSolScheme: TComboBox;
    comboMT3DParticleTrackingAlg: TComboBox;
    adeMT3DMaxParticleMovement: TArgusDataEntry;
    adeMT3DMaxParticleCount: TArgusDataEntry;
    adeMT3DConcWeight: TArgusDataEntry;
    adeMT3DNeglSize: TArgusDataEntry;
    adeMT3DInitPartSmall: TArgusDataEntry;
    adeMT3DInitPartLarge: TArgusDataEntry;
    comboMT3DInitPartPlace: TComboBox;
    adeMT3DParticlePlaneCount: TArgusDataEntry;
    adeMT3DMinPartPerCell: TArgusDataEntry;
    adeMT3DMaxPartPerCell: TArgusDataEntry;
    comboMT3DInterpMeth: TComboBox;
    comboMT3DInitPartSinkChoice: TComboBox;
    adeMT3DSinkParticlePlaneCount: TArgusDataEntry;
    adeMT3DSinkParticleCount: TArgusDataEntry;
    adeMT3DCritRelConcGrad: TArgusDataEntry;
    comboMT3DIsotherm: TComboBox;
    comboMT3DIREACT: TComboBox;
    tabMT3DOut: TTabSheet;
    lblMT3DPrintFormat: TLabel;
    comboPrintoutFormat: TComboBox;
    lblMT3DPrintConc: TLabel;
    lblMT3DPrintRetard: TLabel;
    lblMT3DPrintDisp: TLabel;
    lblMT3DPrintParticle: TLabel;
    lblMT3DPrintMassBal: TLabel;
    cbPrintConc: TCheckBox;
    cbPrintRetardation: TCheckBox;
    cbPrintDispCoef: TCheckBox;
    cbPrintNumParticles: TCheckBox;
    cbCheckMass: TCheckBox;
    comboConcentrationFormat: TComboBox;
    lblMT3DFormat: TLabel;
    comboRetardationFormat: TComboBox;
    comboDispersionFormat: TComboBox;
    comboParticlePrintFormat: TComboBox;
    lblMT3DSaveCond: TLabel;
    cbSaveConcAndDisc: TCheckBox;
    lblMT3DResultPrint: TLabel;
    comboResultsPrinted: TComboBox;
    lblMT3D_NPRS_N: TLabel;
    adeResultsPrintedN: TArgusDataEntry;
    lblMT3D_TIMPRS: TLabel;
    btmDeleteMT3DPrintTime: TButton;
    btmInsertMT3DPrintTime: TButton;
    btmAddMT3DPrintTime: TButton;
    tabMT3DDisp: TTabSheet;
    gboxMT3DDispersion: TGroupBox;
    gboxMT3DBasic: TGroupBox;
    lblMT3DHeading1: TLabel;
    lblMT3DHeading2: TLabel;
    lblMT3DInactiveConc: TLabel;
    lblMT3DMassUnit: TLabel;
    lblMT3DAdvOpt: TLabel;
    lblMT3DDispOpt: TLabel;
    lblMT3DSourceSink: TLabel;
    lblMT3DChemReact: TLabel;
    lblMT3D_CINACT: TLabel;
    lblMT3D_MUNIT: TLabel;
    adeMT3DHeading1: TArgusDataEntry;
    adeMT3DHeading2: TArgusDataEntry;
    adeMT3DInactive: TArgusDataEntry;
    edMT3DMass: TEdit;
    cbADV: TCheckBox;
    cbDSP: TCheckBox;
    cbSSM: TCheckBox;
    cbRCT: TCheckBox;
    cbMT3D_TVC: TCheckBox;
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
    rbRunMT3D: TRadioButton;
    rbCreateMT3D: TRadioButton;
    adeMT3DPath: TArgusDataEntry;
    cbMT3D: TCheckBox;
    adeMT3DNCOMP: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    adeMT3DMCOMP: TArgusDataEntry;
    Label4: TLabel;
    tabMt3dGCG: TTabSheet;
    cbGCG: TCheckBox;
    Label5: TLabel;
    sgMT3DTime: TRbwDataGrid;
    sgPrintoutTimes: TRbwDataGrid;
    sgReaction: TRbwDataGrid;
    sgDispersion: TRbwDataGrid;
    Label6: TLabel;
    adeMT3D_MinimumThickness: TArgusDataEntry;
    Label7: TLabel;
    adeMT3D_ObservationPrintoutFrequency: TArgusDataEntry;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    adeMT3DMassBudPrintFrequency: TArgusDataEntry;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    comboMT3DAdvWeightingScheme: TComboBox;
    Label14: TLabel;
    Label15: TLabel;
    cbExpModelViewer: TCheckBox;
    cbMT3D_OneDArrays: TCheckBox;
    cbMT3D_StartingConcentration: TCheckBox;
    lblMT3D_MaxIterations: TLabel;
    lblMT3D_MaxInnerIterations: TLabel;
    lblMT3D_Preconditioner: TLabel;
    lblMT3D_Relax: TLabel;
    lblMT3D_Converge: TLabel;
    lblMT3D_PrintOut: TLabel;
    adeMT3D_MaxIterations: TArgusDataEntry;
    adeMT3D_MaxInnerIterations: TArgusDataEntry;
    comboMT3D_Preconditioner: TComboBox;
    cbMT3D_Tensor: TCheckBox;
    adeMT3D_Relax: TArgusDataEntry;
    adeMT3D_Converge: TArgusDataEntry;
    adeMT3D_PrintOut: TArgusDataEntry;
    lblMT3D_MXITER: TLabel;
    lblMT3D_ITER1: TLabel;
    lblMT3D_ISOLVE: TLabel;
    lblMT3D_ACCL: TLabel;
    lblMT3D_CCLOSE: TLabel;
    lblMT3D_IPRGCG: TLabel;
    lblExportMT3DGCG: TLabel;
    cbExportMT3DGCG: TCheckBox;
    comboMt3dFlowFormat: TComboBox;
    cbFTI: TCheckBox;
    cbUseMT3D: TCheckBox;
    cbMT3DMassFlux: TCheckBox;
    Label16: TLabel;
    cbPrintCellLists: TCheckBox;
    cbAdvObsPartDischarge: TCheckBox95;
    cbIDPZO: TCheckBox95;
    cbIDPFO: TCheckBox95;
    cbIDKZS: TCheckBox95;
    cbIDKZO: TCheckBox95;
    cbSpecifyHeadFluxCovariances: TCheckBox95;
    cbHeadFluxObservations: TCheckBox95;
    btnDeleteLPF_Parameter: TButton;
    btnDeleteHUF_Parameter: TButton;
    btnDeleteRCH_Parameter: TButton;
    btnDeleteEVT_Parameter: TButton;
    btnDeleteRIV_Parameter: TButton;
    btnDeleteWEL_Parameter: TButton;
    btnDeleteDRN_Parameter: TButton;
    btnDeleteDRT_Parameter: TButton;
    btnDeleteSFR_Parameter: TButton;
    btnDeleteSTR_Parameter: TButton;
    btnDeleteETS_Parameter: TButton;
    btnDeleteCHD_Parameter: TButton;
    btnDeleteHFB_Parameter: TButton;
    btnDeleteGHB_Parameter: TButton;
    Panel27: TPanel;
    btnDeleteParamEstCovNames: TButton;
    Panel28: TPanel;
    btnRemoveSenParameter: TButton;
    cbShowProgress: TCheckBox;
    GroupBox2: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    cbMNW: TCheckBox;
    cbMNW_Use: TCheckBox;
    comboMNW_Steady: TComboBox;
    adeMNW_RefStressPer: TArgusDataEntry;
    combMNW_LossType: TComboBox;
    cbMNW_WellOutput: TCheckBox;
    cbMNW_WriteFlows: TCheckBox;
    cbMNW_TotalFlow: TCheckBox;
    cbMNW_Alltime: TCheckBox;
    clbMNW_TimeVaryingParameters: TCheckListBox;
    Label22: TLabel;
    cbFlowMNW: TCheckBox;
    Label23: TLabel;
    cbMNW_PrintFlows: TCheckBox95;
    adeMNW_PLoss: TArgusDataEntry;
    Label24: TLabel;
    cbExpMNW: TCheckBox;
    StrSetDocs: TStrSet;
    gbMODPATH: TGroupBox;
    cbMPA: TCheckBox;
    cbPRT: TCheckBox;
    tabStresses4: TTabSheet;
    GroupBox3: TGroupBox;
    cbDAFLOW: TCheckBox;
    cbUseDAFLOW: TCheckBox;
    lblDAFLOW_Title: TLabel;
    adeDAF_PrintoutInterval: TArgusDataEntry;
    lblDAF_PrintoutInterval: TLabel;
    adeDAF_PeakDischarge: TArgusDataEntry;
    lblDAF_PeakDischarge: TLabel;
    adeDAF_TimeStepSize: TArgusDataEntry;
    lblDAF_TimeStepSize: TLabel;
    comboDAF_TimeStepUnits: TComboBox;
    adeDAF_StartTime: TArgusDataEntry;
    lblDAF_StartTime: TLabel;
    lblDAF_BoundaryTimes: TLabel;
    adeDAF_BoundaryTimes: TArgusDataEntry;
    cbDAF_CentralDifferencing: TCheckBox;
    cbDAF_Debug: TCheckBox;
    lblDAF_TimeStepUnits: TLabel;
    adeDAFLOW_Title: TArgusDataEntry;
    Label25: TLabel;
    adeDAF_EndTime: TArgusDataEntry;
    Label26: TLabel;
    cbFlowDaflow: TCheckBox;
    Label27: TLabel;
    cbExpDAFLOW: TCheckBox;
    edCheckDate: TEdit;
    rgUpdateFrequency: TRadioGroup;
    cbBFLX: TCheckBox;
    gbReservoirs: TGroupBox;
    lblResOption: TLabel;
    lblResPointsCount: TLabel;
    lblNRESOP: TLabel;
    cbRES: TCheckBox;
    cbRESRetain: TCheckBox;
    comboResSteady: TComboBox;
    comboResOption: TComboBox;
    cb95PrintRes: TCheckBox95;
    adeResPointsCount: TArgusDataEntry;
    lblETS: TLabel;
    cbETS: TCheckBox;
    cbETSRetain: TCheckBox;
    comboEtsSteady: TComboBox;
    lblEtsSteady: TLabel;
    comboEtsOption: TComboBox;
    lblNETSOP: TLabel;
    lblEtsOption: TLabel;
    lblIntElev: TLabel;
    adeIntElev: TArgusDataEntry;
    lblNETSEG: TLabel;
    comboMODPATH_RechargeITOP: TComboBox;
    lblMODPATH_RechargeITOP: TLabel;
    comboMODPATH_EvapITOP: TComboBox;
    lblMODPATH_EvapITOP: TLabel;
    cbExpBFLX: TCheckBox;
    cbSaveHufFlows: TCheckBox;
    Label28: TLabel;
    cbHUF_ReferenceSurface: TCheckBox;
    tabADVParameters: TTabSheet;
    dgADVParameters: TDataGrid;
    Splitter20: TSplitter;
    dg3dADVParameterClusters: TRBWDataGrid3d;
    Panel29: TPanel;
    Label29: TLabel;
    adeADVParamCount: TArgusDataEntry;
    btnDeleteADV_Parameter: TButton;
    tabSubsidence: TTabSheet;
    gbSub: TGroupBox;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    cbSub: TCheckBox;
    cbUseSUB: TCheckBox;
    rdgSub: TRbwDataGrid;
    adeSubNN: TArgusDataEntry;
    adeSUB_AC1: TArgusDataEntry;
    adeSUB_AC2: TArgusDataEntry;
    adeSUB_ITMIN: TArgusDataEntry;
    Label34: TLabel;
    adeSubISUBOC: TArgusDataEntry;
    Label35: TLabel;
    Label36: TLabel;
    cbFlowSub: TCheckBox;
    Label37: TLabel;
    cbSubSaveRestart: TCheckBox;
    cbSubUseRestart: TCheckBox;
    framSubRestartFile: TframFilePath;
    dgSubOutput: TDataGrid;
    dgSubOutFormat: TDataGrid;
    cbExpSub: TCheckBox;
    Label38: TLabel;
    Label39: TLabel;
    gbUseOnlyContours: TGroupBox;
    cbAreaWellContour: TCheckBox;
    cbAreaRiverContour: TCheckBox;
    cbAreaDrainContour: TCheckBox;
    Label40: TLabel;
    GroupBox4: TGroupBox;
    cbAltWel: TCheckBox;
    cbAltRiv: TCheckBox;
    cbAltDrn: TCheckBox;
    cbAltDrt: TCheckBox;
    cbAltGHB: TCheckBox;
    cbAltCHD: TCheckBox;
    cbAltSTR: TCheckBox;
    GroupBox5: TGroupBox;
    cbRechLayer: TCheckBox;
    cbETLayer: TCheckBox;
    cbRESLayer: TCheckBox;
    cbETSLayer: TCheckBox95;
    cbAreaDrainRetrunContour: TCheckBox;
    cbAreaGHBContour: TCheckBox;
    cbAreaCHDContour: TCheckBox;
    Panel30: TPanel;
    dgMultiplier: TDataGrid;
    Panel31: TPanel;
    adeMultCount: TArgusDataEntry;
    lblMultCount: TLabel;
    Panel32: TPanel;
    sgZoneArrays: TStringGrid;
    pnlMultZone: TPanel;
    lblZoneCount: TLabel;
    adeZoneCount: TArgusDataEntry;
    btnDeleteMulitplier: TButton;
    btnDeleteZone: TButton;
    GroupBox6: TGroupBox;
    cbCondDrn: TCheckBox;
    cbCondRiv: TCheckBox;
    cbCondDrnRtn: TCheckBox;
    cbCondGhb: TCheckBox;
    cbSeaWat: TCheckBox;
    tabSeaWat: TTabSheet;
    cbExpVdf: TCheckBox;
    rbCreateSeaWat: TRadioButton;
    rbRunSeawat: TRadioButton;
    adeSEAWAT: TArgusDataEntry;
    tabGMG: TTabSheet;
    GroupBox7: TGroupBox;
    Label61: TLabel;
    Label62: TLabel;
    Label64: TLabel;
    Label66: TLabel;
    Label68: TLabel;
    Label70: TLabel;
    Label72: TLabel;
    Label74: TLabel;
    Label76: TLabel;
    Label78: TLabel;
    adeGmgRelax: TArgusDataEntry;
    comboGmgIsc: TComboBox;
    comboGmgIsm: TComboBox;
    comboGmgIoutgmg: TComboBox;
    comboGmgIadamp: TComboBox;
    adeGmgDamp: TArgusDataEntry;
    adeGmgMxiter: TArgusDataEntry;
    adeGmgHclose: TArgusDataEntry;
    adeGmgIiter: TArgusDataEntry;
    adeGmgRclose: TArgusDataEntry;
    Label59: TLabel;
    Label63: TLabel;
    Label65: TLabel;
    Label67: TLabel;
    Label69: TLabel;
    Label71: TLabel;
    Label73: TLabel;
    Label75: TLabel;
    Label77: TLabel;
    Label79: TLabel;
    clbObservationLayers: TCheckListBox;
    Label80: TLabel;
    Label81: TLabel;
    clbWeightedObservationLayers: TCheckListBox;
    Panel33: TPanel;
    Label82: TLabel;
    clbPrescribeHeadFlux: TCheckListBox;
    Panel34: TPanel;
    lblWTQ_HeadFlux: TLabel;
    dgHeadFluxObsBoundCovariances: TDataGrid;
    Panel35: TPanel;
    Label83: TLabel;
    dgAdvObsBoundCovariances: TDataGrid;
    Panel36: TPanel;
    Label84: TLabel;
    clbAdvObsStartPoints: TCheckListBox;
    Panel37: TPanel;
    Label85: TLabel;
    clbAdvObs: TCheckListBox;
    Panel38: TPanel;
    lblWTQ_GHB: TLabel;
    dgGHBObsBoundCovariances: TDataGrid;
    Panel39: TPanel;
    Label86: TLabel;
    clbGHB_Observations: TCheckListBox;
    Panel40: TPanel;
    lblDrnWTQ: TLabel;
    dgDRNObsBoundCovariances: TDataGrid;
    Panel41: TPanel;
    Label87: TLabel;
    clbDrainObservations: TCheckListBox;
    Panel42: TPanel;
    lblWTQ_River: TLabel;
    dgRIVObsBoundCovariances: TDataGrid;
    Panel43: TPanel;
    Label88: TLabel;
    clbRiverObservations: TCheckListBox;
    Panel44: TPanel;
    lblDrtWTQ: TLabel;
    dgDRTObsBoundCovariances: TDataGrid;
    Panel45: TPanel;
    Label89: TLabel;
    clbDrainReturnObservations: TCheckListBox;
    rgModpathPeriodStepMethod: TRadioGroup;
    adeModpathBegin: TArgusDataEntry;
    Label90: TLabel;
    adeModpathEnd: TArgusDataEntry;
    Label91: TLabel;
    btnMOC3DParticleAdd: TButton;
    btnMOC3DParticleDelete: TButton;
    cbExpIPDA: TCheckBox;
    comboSpecifyParticles: TComboBox;
    Label98: TLabel;
    Label99: TLabel;
    adeNPTLAY: TArgusDataEntry;
    Label100: TLabel;
    Label101: TLabel;
    adeNPTROW: TArgusDataEntry;
    Label102: TLabel;
    Label103: TLabel;
    adeNPTCOL: TArgusDataEntry;
    Label104: TLabel;
    cbExpGAG: TCheckBox;
    Label92: TLabel;
    adeREMCRIT: TArgusDataEntry;
    Label93: TLabel;
    Label95: TLabel;
    adeGENCRIT: TArgusDataEntry;
    Label94: TLabel;
    Label96: TLabel;
    comboIRAND: TComboBox;
    Label97: TLabel;
    frameHeadFormat: TframeFormat;
    frameDrawdownFormat: TframeFormat;
    Label105: TLabel;
    Label106: TLabel;
    adeIRAND: TArgusDataEntry;
    Label107: TLabel;
    cbCBDY: TCheckBox95;
    cbExpCBDY: TCheckBox;
    cbDeactivateIbound: TCheckBox95;
    Label108: TLabel;
    cbPrintTime: TCheckBox;
    GroupBox8: TGroupBox;
    cbOpenOutputInNotepad: TCheckBox;
    cbPrintArrays: TCheckBox;
    tabOutputControl: TTabSheet;
    PageControl1: TPageControl;
    tabPrintHead: TTabSheet;
    tabPrintDrawdown: TTabSheet;
    tabPrintBudget: TTabSheet;
    tabSaveHead: TTabSheet;
    tabSaveDrawdown: TTabSheet;
    tabSaveCellByCellFlows: TTabSheet;
    frameOC_PrintHead: TframeOutputControl;
    frameOC_PrintDrawdown: TframeOutputControl;
    frameOC_PrintBudget: TframeOutputControl;
    frameOC_SaveHead: TframeOutputControl;
    frameOC_SaveDrawdown: TframeOutputControl;
    frameOC_SaveFlows: TframeOutputControl;
    cb_GWM: TCheckBox;
    tab_GWM: TTabSheet;
    pcGWM: TPageControl;
    tabGWM_ExternalDecision: TTabSheet;
    tabGWM_BinaryDecision: TTabSheet;
    tabGWM_Objective: TTabSheet;
    tabGWM_Constraints: TTabSheet;
    tabGWM_Solution: TTabSheet;
    frameGWM_External: TframeGWM;
    frameGWM_Binary: TframeGWM;
    Splitter21: TSplitter;
    dg3dGWM_BinaryDecVar: TRBWDataGrid3d;
    Panel46: TPanel;
    comboGWM_Objective: TComboBox;
    frameGWM_BinaryObjective: TframeGWM;
    Splitter22: TSplitter;
    Splitter23: TSplitter;
    frameGWM_ExternalObjective: TframeGWM;
    dg3dCombinedConstraints: TRBWDataGrid3d;
    Splitter24: TSplitter;
    frameGWM_CombinedConstraints: TframeGWM;
    pcGWM_Solution: TPageControl;
    tabGWM_LP: TTabSheet;
    tabGWM_SLP: TTabSheet;
    rgGWM_ResponseMatrix: TRadioGroup;
    framFilePathGWM_ResponseMatrix: TframFilePath;
    cbGWM_Range: TCheckBox;
    cbGWM_BBITPRT: TCheckBox;
    adeGWM_BBITMAX: TArgusDataEntry;
    adeGWM_LPITMAX: TArgusDataEntry;
    adeGWM_PGFACT: TArgusDataEntry;
    adeGWM_NPGNMX: TArgusDataEntry;
    adeGWM_NSIGDIG: TArgusDataEntry;
    adeGWM_Delta: TArgusDataEntry;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    adeGWM_NINFMX: TArgusDataEntry;
    adeGWM_AFACT: TArgusDataEntry;
    adeGWM_DSC: TArgusDataEntry;
    adeGWM_DMIN: TArgusDataEntry;
    adeGWM_DINIT: TArgusDataEntry;
    adeGWM_SLPZCRIT: TArgusDataEntry;
    adeGWM_SLPVCRIT: TArgusDataEntry;
    adeGWM_SLPITMAX: TArgusDataEntry;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    cbGWM_DECVAR: TCheckBox;
    cbGWM_OBJFNC: TCheckBox;
    cbGWM_VARCON: TCheckBox;
    cbGWM_SUMCON: TCheckBox;
    cbGWM_HEDCON: TCheckBox;
    cbGWM_STRMCON: TCheckBox;
    cbGWM_SOLN: TCheckBox;
    adeGWM: TArgusDataEntry;
    rbCreateGWM: TRadioButton;
    rbRunGWM: TRadioButton;
    btnImportFlowVar1: TButton;
    btnImportFlowVar2: TButton;
    btnImportFlowVar3: TButton;
    cbSaveHufHeads: TCheckBox;
    cbSfrLpfHydraulicCond: TCheckBox;
    adeSfrTrailigWaveIncrements: TArgusDataEntry;
    lblSfrTrailigWaveIncrements: TLabel;
    lblSfrMaxUnsatCells: TLabel;
    adeSfrMaxUnsatCells: TArgusDataEntry;
    adeSfrMaxTrailingWaves: TArgusDataEntry;
    lblSfrMaxTrailingWaves: TLabel;
    cbSfrUnsatflow: TCheckBox95;
    gbSfr2ISFROPT: TGroupBox;
    rbSfr2ByEndpoints: TRadioButton95;
    rbSfr2ByReach: TRadioButton95;
    cbParticleObservations: TCheckBox;
    cbExpPTOB: TCheckBox;
    adeStartTransportStressPeriod: TArgusDataEntry;
    Label124: TLabel;
    Label125: TLabel;
    cbAdjustParticleLocations: TCheckBox;
    cbMpathElevations: TCheckBox;
    cbGWM_PrintResponseMatrix: TCheckBox95;
    framFilePathGWM_ResponseMatrixAscii: TframFilePath;
    comboGWM_SLPITPRT: TComboBox;
    Label126: TLabel;
    Panel47: TPanel;
    rgGWM_SolutionType: TRadioGroup;
    cbGWMWFILE: TCheckBox;
    Label127: TLabel;
    cbGMG_IUNITMHC: TCheckBox;
    Label128: TLabel;
    adeGMG_DUP: TArgusDataEntry;
    Label129: TLabel;
    Label130: TLabel;
    adeGMG_DLOW: TArgusDataEntry;
    Label131: TLabel;
    Label132: TLabel;
    adeGMG_CHGLIMIT: TArgusDataEntry;
    Label133: TLabel;
    cbUseStreamObservations: TCheckBox;
    cbISRCFIX: TCheckBox;
    gbUZF: TGroupBox;
    lblUZF: TLabel;
    cbUZF: TCheckBox;
    comboUzfNUZTOP: TComboBox;
    cbUzfIUZFOPT: TCheckBox;
    cbUzfIRUNFLG: TCheckBox;
    cbUzfIETFLG: TCheckBox;
    Label135: TLabel;
    Label136: TLabel;
    Label134: TLabel;
    adeUzfNTRAIL2: TArgusDataEntry;
    adeUzfNSETS2: TArgusDataEntry;
    cbUzfRetain: TCheckBox;
    comboUzfTransient: TComboBox;
    Label137: TLabel;
    cbUzrOutput: TCheckBox;
    cbFlowUZF: TCheckBox;
    Label138: TLabel;
    rbModflow2005: TRadioButton;
    cbExpUZF: TCheckBox;
    adeModflow2005: TArgusDataEntry;
    cbMt3dMultiDiffusion: TCheckBox;
    cbMt3dMultinodeWellOutput: TCheckBox;
    tabSWT: TTabSheet;
    gbSWT: TGroupBox;
    cbSWT: TCheckBox;
    cbUseSWT: TCheckBox;
    rdgSwt: TRbwDataGrid;
    comboSwtITHK: TComboBox;
    lblSwtITHK: TLabel;
    Label139: TLabel;
    comboSwtIVOID: TComboBox;
    Label140: TLabel;
    comboSwtISTPCS: TComboBox;
    Label141: TLabel;
    comboSwtICRCC: TComboBox;
    adeSwtISWTOC: TArgusDataEntry;
    Label142: TLabel;
    comboSwtFormat: TComboBox;
    Label143: TLabel;
    rdgSwtOutput: TRbwDataGrid4;
    jclbPrintInitialDataSets: TJvCheckListBox;
    Label144: TLabel;
    cbFlowSwt: TCheckBox;
    Label145: TLabel;
    cbExpSwt: TCheckBox;
    Label146: TLabel;
    Label147: TLabel;
    cbIncreaseUnitNumbers: TCheckBox;
    adeIncreaseUnitNumbers: TArgusDataEntry;
    comboVertCond: TComboBox;
    Label148: TLabel;
    cbVertCondCorrection: TCheckBox;
    lblTOB: TLabel;
    cbTOB: TCheckBox;
    tabTransportObservations: TTabSheet;
    cb_inConcObs: TCheckBox;
    cb_inFluxObs: TCheckBox;
    cb_inSaveObs: TCheckBox;
    adeCScale: TArgusDataEntry;
    lblCScale: TLabel;
    combo_iOutCobs: TComboBox;
    lbl_iOutCobs: TLabel;
    cb_iConcLOG: TCheckBox;
    cb_iConcINTP: TCheckBox;
    adeConcObsTimeCount: TArgusDataEntry;
    Label149: TLabel;
    adeConcObsLayerCount: TArgusDataEntry;
    lblConcObsLayerCount: TLabel;
    pcSeawat: TPageControl;
    tabVariableDensity: TTabSheet;
    tabViscosity: TTabSheet;
    cbSW_MT3D: TCheckBox;
    cbSW_VDF: TCheckBox;
    cbSW_Coupled: TCheckBox;
    Label150: TLabel;
    comboDensityChoice: TComboBox;
    Label151: TLabel;
    Label41: TLabel;
    adeSW_ComponentChoice: TArgusDataEntry;
    Label43: TLabel;
    Label42: TLabel;
    comboSW_InternodalDensity: TComboBox;
    Label44: TLabel;
    Label45: TLabel;
    adeSW_MaxIt: TArgusDataEntry;
    Label46: TLabel;
    cbSW_WaterTableCorrections: TCheckBox;
    Label47: TLabel;
    adeSW_MinDens: TArgusDataEntry;
    Label48: TLabel;
    Label49: TLabel;
    adeSW_MaxDens: TArgusDataEntry;
    Label50: TLabel;
    Label51: TLabel;
    adeSW_DenConvCrit: TArgusDataEntry;
    Label52: TLabel;
    Label53: TLabel;
    adeRefFluidDens: TArgusDataEntry;
    Label54: TLabel;
    Label55: TLabel;
    adeSW_DenseSlope: TArgusDataEntry;
    Label56: TLabel;
    Label152: TLabel;
    adeSW_SlopePresHead: TArgusDataEntry;
    Label153: TLabel;
    Label154: TLabel;
    adeSWRefHead: TArgusDataEntry;
    Label155: TLabel;
    Label57: TLabel;
    adeSW_FirstTimeStepLength: TArgusDataEntry;
    Label58: TLabel;
    lblSW_DensitySpecificationMethod: TLabel;
    comboSW_DensitySpecificationMethod: TComboBox;
    Label60: TLabel;
    Label156: TLabel;
    adeSWDensCompCount: TArgusDataEntry;
    Label157: TLabel;
    rdgSWDensTable: TRbwDataGrid4;
    cbSW_GHB_FluidDensity: TCheckBox95;
    cbSW_GHB_Elevation: TCheckBox95;
    cbSW_RiverFluidDensity: TCheckBox95;
    cbSW_RiverbedThickness: TCheckBox95;
    cbSW_DrainElevation: TCheckBox95;
    cbSW_WellFluidDensity: TCheckBox95;
    cbSeawatViscosity: TCheckBox;
    comboSW_ViscosityMethod: TComboBox;
    Label158: TLabel;
    Label159: TLabel;
    adeSW_ViscMin: TArgusDataEntry;
    Label160: TLabel;
    Label161: TLabel;
    adeSW_ViscMax: TArgusDataEntry;
    Label162: TLabel;
    Label163: TLabel;
    adeSW_RefVisc: TArgusDataEntry;
    Label164: TLabel;
    Label165: TLabel;
    adeSW_ViscositySlope: TArgusDataEntry;
    Label166: TLabel;
    Label167: TLabel;
    adeSW_RefViscConc: TArgusDataEntry;
    Label168: TLabel;
    Label169: TLabel;
    adeSW_ViscEquationCount: TArgusDataEntry;
    Label170: TLabel;
    comboSW_ViscEquation: TComboBox;
    Label171: TLabel;
    rdgSW_ViscEq: TRbwDataGrid4;
    rdgSW_ViscEqTemp: TRbwDataGrid4;
    Label172: TLabel;
    adeSwViscSpecies: TArgusDataEntry;
    Label173: TLabel;
    comboSW_TimeVaryingViscosity: TComboBox;
    Label174: TLabel;
    btnSW_ViscEqTermDefaults: TRbw95Button;
    cbExpVsc: TCheckBox;
    Label175: TLabel;
    adeSurfDep: TArgusDataEntry;
    Label176: TLabel;
    cbKinematicRouting: TCheckBox;
    adeSfrKinematicTimeSteps: TArgusDataEntry;
    lblSfrKinematicTimeSteps: TLabel;
    adeSfrTimeWeightingFactor: TArgusDataEntry;
    lblSfrTimeWeightingFactor: TLabel;
    adeSfrToleranceForConvergence: TArgusDataEntry;
    lblSfrToleranceForConvergence: TLabel;
    tabMNW2: TTabSheet;
    GroupBox9: TGroupBox;
    Label177: TLabel;
    Label179: TLabel;
    Label180: TLabel;
    cbMnw2: TCheckBox;
    clbMnw2LossTypes: TCheckListBox;
    GroupBox10: TGroupBox;
    Label181: TLabel;
    tvMnw2Pumps: TTreeView;
    btnMnw2AddPump: TButton;
    btnDeletePump: TButton;
    cbMnw2Pumpcap: TCheckBox;
    cbMnw2TimeVarying: TCheckBox;
    rgMnw2WellType: TRadioGroup;
    plMnwPumps: TJvPageList;
    cbUseMnw2: TCheckBox;
    comboMnw2SteadyState: TComboBox;
    adeMnw2WellScreens: TArgusDataEntry;
    Label178: TLabel;
    comboMnw2Output: TComboBox;
    cbFlowMnw2: TCheckBox;
    Label182: TLabel;
    cbMnw2_PrintFlows: TCheckBox95;
    cbExpMnw2: TCheckBox;
    lblModpathBackwardsWarning: TLabel;
    GroupBox11: TGroupBox;
    Label183: TLabel;
    cbMnwi: TCheckBox;
    cbUseMnwi: TCheckBox;
    cbMnwiWel1flag: TCheckBox;
    cbMnwiQsumFlag: TCheckBox;
    cbMnwiByNdFlag: TCheckBox;
    Label184: TLabel;
    comboBinaryInitialHeadChoice: TComboBox;
    adeModflowBinaryStressPeriod: TArgusDataEntry;
    Label185: TLabel;
    adeModflowBinaryTimeStepChoice: TArgusDataEntry;
    Label186: TLabel;
    odMt3dBinaryFileName: TOpenDialog;
    GroupBox12: TGroupBox;
    rdgMt3dBinaryInitialConcFiles: TRbwDataGrid4;
    Label187: TLabel;
    adeMt3dmsBinaryStressPeriod: TArgusDataEntry;
    Label188: TLabel;
    adeMt3dmsBinaryTimeStepChoice: TArgusDataEntry;
    Label189: TLabel;
    adeMt3dmsBinaryTransportStepChoice: TArgusDataEntry;
    comboLakSteadyLeakance: TComboBox;
    lblLakSteadyLeakance: TLabel;
    tabGWM_State: TTabSheet;
    cbGwmHeadVariables: TCheckBox;
    cbGwmStreamVariables: TCheckBox;
    Label190: TLabel;
    rdeGwmStorageStateVarCount: TRbwDataEntry;
    rdgGwmStorageVariables: TRbwDataGrid4;
    btnDeleteGwmStorageStateVar: TButton;
    btnInsertGwmStorageStateVar: TButton;
    btnAddGwmStorageStateVar: TButton;
    rdeGwmStateTimeCount: TRbwDataEntry;
    Label191: TLabel;
    cbGWM_STAVAR: TCheckBox;
    Panel48: TPanel;
    frameGWM_FlowObjective: TframeGWM;
    Splitter25: TSplitter;
    frameGWM_StateObjective: TframeGWM;
    comboGWM_ObjectiveType: TComboBox;
    Label192: TLabel;
    tabGWM_LP2: TTabSheet;
    rgCritMFC: TRadioGroup;
    rdeCritMFC: TRbwDataEntry;
    lblCritMFC: TLabel;
    rdeZoneCount: TRbwDataEntry;
    Label193: TLabel;
    adeSurfDepth: TArgusDataEntry;
    lblSurfDepth: TLabel;
    cbMBRP: TCheckBox;
    cbMBIT: TCheckBox;
    cbCCBD: TCheckBox;
    cbExpCCBD: TCheckBox;
    cbVBAL: TCheckBox;
    cbExpVBAL: TCheckBox;
    comboMnwObservations: TComboBox;
    pgcAbout: TPageControl;
    tabDocumentation: TTabSheet;
    memoReferences: TMemo;
    tabDisclaimer: TTabSheet;
    memoDisclaimer: TMemo;
    StrSetDisclaimer: TStrSet;
    procedure FormCreate(Sender: TObject); override;
    procedure comboWetCapChange(Sender: TObject); virtual;
    procedure cbRCHClick(Sender: TObject); virtual;
    procedure cbRIVClick(Sender: TObject); virtual;
    procedure cbWELClick(Sender: TObject); virtual;
    procedure cbDRNClick(Sender: TObject); virtual;
    procedure cbGHBClick(Sender: TObject); virtual;
    procedure cbEVTClick(Sender: TObject); virtual;
    procedure comboExportHeadChange(Sender: TObject); virtual;
    procedure cbFlowClick(Sender: TObject); virtual;
    procedure rgSolMethClick(Sender: TObject); virtual;
    procedure comboHeadPrintFreqChange(Sender: TObject); virtual;
    procedure comboDrawdownPrintFreqChange(Sender: TObject); virtual;
    procedure comboBudPrintFreqChange(Sender: TObject); virtual;
    procedure comboHeadExportFreqChange(Sender: TObject); virtual;
    procedure comboDrawdownExportFreqChange(Sender: TObject); virtual;
    procedure comboBudExportFreqChange(Sender: TObject); virtual;
    procedure cbMOC3DClick(Sender: TObject); virtual;
    procedure comboMOC3DConcFreqChange(Sender: TObject); virtual;
    procedure comboMOC3DConcFileTypeChange(Sender: TObject); virtual;
    procedure comboMOC3DVelFreqChange(Sender: TObject); virtual;
    procedure comboMOC3DVelFileTypeChange(Sender: TObject); virtual;
    procedure comboMOC3DDispFreqChange(Sender: TObject); virtual;
    procedure comboMOC3DPartFileTypeChange(Sender: TObject); virtual;
    procedure sgMOC3DTransParamSelectCell(Sender: TObject; Col,
      Row: Integer; var CanSelect: Boolean); virtual;
    procedure sgMOC3DTransParamDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure edNumPerEnter(Sender: TObject); virtual;
    procedure edNumUnitsEnter(Sender: TObject); virtual;
    procedure edNumUnitsExit(Sender: TObject); virtual;
    procedure edNumPerExit(Sender: TObject); virtual;
    procedure sgTimeDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure sgMOC3DParticlesSelectCell(Sender: TObject; Col,
      Row: Integer; var CanSelect: Boolean); virtual;
    procedure sgTimeSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure btnMOC3DParticleAddClick(Sender: TObject); virtual;
    procedure cbCustomParticleClick(Sender: TObject); virtual;
    procedure btnMOC3DParticleDeleteClick(Sender: TObject); virtual;
    procedure btnInsertUnitClick(Sender: TObject); virtual;
    procedure btnInsertTimeClick(Sender: TObject); virtual;
    procedure btnDeleteUnitClick(Sender: TObject); virtual;
    procedure btnDeleteTimeClick(Sender: TObject); virtual;
    procedure sgTimeSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string); virtual;
    procedure sgMOC3DParticlesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string); virtual;
    procedure sgMOC3DParticlesExit(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); override;
    procedure comboMOC3DPartFreqChange(Sender: TObject); virtual;
    procedure FormShow(Sender: TObject); virtual;
    procedure btnAddUnitClick(Sender: TObject); virtual;
    procedure btnAddTimeClick(Sender: TObject); virtual;
    procedure edMOC3DInitParticlesExit(Sender: TObject); virtual;
    procedure sgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer); virtual;
    procedure adeMOC3DLayerExit(Sender: TObject); virtual;
    procedure adeFileNameExit(Sender: TObject); virtual;
    procedure cbSTRClick(Sender: TObject); virtual;
    procedure cbStreamCalcFlowClick(Sender: TObject); virtual;
    procedure cbStreamTribClick(Sender: TObject); virtual;
    procedure cbStreamDiversionsClick(Sender: TObject); virtual;
    procedure cbHFBClick(Sender: TObject); virtual;
    procedure cbFHBClick(Sender: TObject); virtual;
    procedure comboSteadyChange(Sender: TObject); virtual;
    procedure adeFHBNumTimesExit(Sender: TObject); virtual;
    procedure sgFHBTimesSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgFHBTimesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string); virtual;
    procedure btnOKClick(Sender: TObject); virtual;
    procedure adeFHBNumTimesEnter(Sender: TObject); virtual;
    procedure cbMODPATHClick(Sender: TObject); virtual;
    procedure adeMODPATHMaxReleaseTimeEnter(Sender: TObject); virtual;
    procedure adeMODPATHMaxReleaseTimeExit(Sender: TObject); virtual;
    procedure sgMODPATHOutputTimesExit(Sender: TObject); virtual;
    procedure sgTimeExit(Sender: TObject); virtual;
    procedure adeModpathBeginPeriodExit(Sender: TObject); virtual;
    procedure adeModpathBeginStepExit(Sender: TObject); virtual;
    procedure adeZoneBudCompZoneCountChange(Sender: TObject); virtual;
    procedure sgZoneBudCompZonesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string); virtual;
    procedure sgZoneBudCompZonesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean); virtual;
    procedure rgZonebudTimesChoiceClick(Sender: TObject); virtual;
    procedure cbZonebudgetClick(Sender: TObject); virtual;
    procedure comboSIPIterSeedChange(Sender: TObject); virtual;
    procedure adeMODPATHOutputTimeCountEnter(Sender: TObject); virtual;
    procedure adeMODPATHOutputTimeCountExit(Sender: TObject); virtual;
    procedure adeZoneBudCompZoneCountEnter(Sender: TObject); virtual;
    procedure adeZoneBudCompZoneCountExit(Sender: TObject); virtual;
    procedure pageControlMainChange(Sender: TObject); virtual;
    procedure cbMPATHStopTimeClick(Sender: TObject); virtual;
    procedure comboMPATHStartTimeMethodChange(Sender: TObject); virtual;
    procedure cbMPATHTrackStopClick(Sender: TObject); virtual;
    procedure comboMPATHOutModeChange(Sender: TObject); virtual;
    procedure cbMPATHComputeLocClick(Sender: TObject); virtual;
    procedure comboMPATHTimeMethodChange(Sender: TObject); virtual;
    procedure comboMPATHSinkTreatmentChange(Sender: TObject); virtual;
    procedure cbMPATHStopClick(Sender: TObject); virtual;
    procedure adeMPATHRefPeriodExit(Sender: TObject); virtual;
    procedure btnDeveloperClick(Sender: TObject); virtual;
    procedure dgGeolSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string); virtual;
    procedure dgGeolSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgZondbudTimesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean); virtual;
    procedure sgZondbudTimesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string); virtual;
    procedure sgZondbudTimesExit(Sender: TObject); virtual;
    procedure sgMOC3DTransParamSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string); virtual;
    procedure sgMOC3DTransParamExit(Sender: TObject); virtual;
    procedure dgGeolExit(Sender: TObject); virtual;
    procedure rgMOC3DSolverClick(Sender: TObject); virtual;
    procedure btnSaveValClick(Sender: TObject); virtual;
    procedure btnOpenValClick(Sender: TObject); virtual;
    procedure cbSpecifyFlowFilesClick(Sender: TObject); virtual;
    procedure cbStrPrintFlowsClick(Sender: TObject); virtual;
    procedure comboISTRTChange(Sender: TObject); virtual;
    procedure cbMOC3DNoDispClick(Sender: TObject); virtual;
    procedure comboExportDrawdownChange(Sender: TObject); virtual;
    procedure cbMPathBudgetClick(Sender: TObject); virtual;
    procedure dgGeolDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure rgMOC3DConcFormatClick(Sender: TObject); virtual;
    procedure comboCustomizeChange(Sender: TObject); virtual;
    procedure cbActiveBoundaryClick(Sender: TObject); virtual;
    procedure cbAltRivClick(Sender: TObject); virtual;
    procedure cbAltDrnClick(Sender: TObject); virtual;
    procedure cbRechLayerClick(Sender: TObject); virtual;
    procedure comboRchOptChange(Sender: TObject); virtual;
    procedure cbETLayerClick(Sender: TObject); virtual;
    procedure comboEvtOptionChange(Sender: TObject); virtual;
    procedure comboTimeUnitsChange(Sender: TObject); virtual;
    procedure cbAgeClick(Sender: TObject); virtual;
    procedure cbDualPorosityClick(Sender: TObject); virtual;
    procedure cbSimpleReactionsClick(Sender: TObject); virtual;
    procedure cbIDPFOClick(Sender: TObject); virtual;
    procedure cbIDPZOClick(Sender: TObject); virtual;
    procedure cbIDKRFClick(Sender: TObject); virtual;
    procedure cbIDKFOClick(Sender: TObject); virtual;
    procedure cbIDKFSClick(Sender: TObject); virtual;
    procedure cbIDKZOClick(Sender: TObject); virtual;
    procedure cbIDKZSClick(Sender: TObject); virtual;
    procedure cbIDPTIM_DecayClick(Sender: TObject);
    procedure cbIDPTIM_GrowthClick(Sender: TObject);
    procedure cbIDKTIM_DisDecayClick(Sender: TObject);
    procedure cbIDKTIM_SorbDecayClick(Sender: TObject);
    procedure cbIDKTIM_DisGrowthClick(Sender: TObject);
    procedure cbIDKTIM_SorbGrowthClick(Sender: TObject);
    procedure btnInitialSelectClick(Sender: TObject);
    procedure cbInitialClick(Sender: TObject);
    procedure cbIDPTIM_LinExchClick(Sender: TObject);
    procedure dgMultiplierEditButtonClick(Sender: TObject);
    procedure adeLPFParamCountExit(Sender: TObject);
    procedure adeMultCountExit(Sender: TObject);
    procedure adeZoneCountExit(Sender: TObject);
    procedure dgMultiplierSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure dgMultiplierSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure sgZoneArraysSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure dgParametersSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure dgMultiplierEnter(Sender: TObject);
    procedure adeRCHParamCountExit(Sender: TObject);
    procedure adeEVTParamCountExit(Sender: TObject);
    procedure adeMultCountEnter(Sender: TObject);
    procedure adeRIVParamCountExit(Sender: TObject);
    procedure adeWELParamCountExit(Sender: TObject);
    procedure cbAltWelClick(Sender: TObject);
    procedure adeDRNParamCountExit(Sender: TObject);
    procedure adeGHBParamCountExit(Sender: TObject);
    procedure adeHFBParamCountExit(Sender: TObject);
    procedure dgParameterNamesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure cbHeadObservationsClick(Sender: TObject);
    procedure cbWeightedHeadObservationsClick(Sender: TObject);
    procedure adeHeadObsLayerCountExit(Sender: TObject);
    procedure adeWeightedHeadObsLayerCountExit(Sender: TObject);
    procedure adeObsHeadCountExit(Sender: TObject);
    procedure adeObsHeadCountEnter(Sender: TObject);
    procedure adeGHBObsLayerCountExit(Sender: TObject);
    procedure adeDRNObsLayerCountExit(Sender: TObject);
    procedure adeRIVObsLayerCountExit(Sender: TObject);
    procedure adeObsGHBTimeCountEnter(Sender: TObject);
    procedure adeObsDRNTimeCountEnter(Sender: TObject);
    procedure adeObsRIVTimeCountEnter(Sender: TObject);
    procedure adeObsGHBTimeCountExit(Sender: TObject);
    procedure adeObsDRNTimeCountExit(Sender: TObject);
    procedure adeObsRIVTimeCountExit(Sender: TObject);
    procedure cbGHBObservationsClick(Sender: TObject);
    procedure cbDRNObservationsClick(Sender: TObject);
    procedure cbRIVObservationsClick(Sender: TObject);
    procedure adeHeadFluxObsLayerCountExit(Sender: TObject);
    procedure adeObsHeadFluxTimeCountEnter(Sender: TObject);
    procedure adeObsHeadFluxTimeCountExit(Sender: TObject);
    procedure cbHeadFluxObservationsClick(Sender: TObject);
    procedure adeGHBObsBoundCountExit(Sender: TObject);
    procedure dgGHBObsBoundCovariancesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure adeDRNObsBoundCountExit(Sender: TObject);
    procedure adeRIVObsBoundCountExit(Sender: TObject);
    procedure adeHeadFluxObsBoundCountExit(Sender: TObject);
    procedure cbSpecifyGHBCovariancesClick(Sender: TObject);
    procedure cbSpecifyDRNCovariancesClick(Sender: TObject);
    procedure cbSpecifyRiverCovariancesClick(Sender: TObject);
    procedure cbSpecifyHeadFluxCovariancesClick(Sender: TObject);
    procedure cbObservationsClick(Sender: TObject);
    procedure adeSensitivityCountExit(Sender: TObject);
    procedure cbSensitivityClick(Sender: TObject);
    procedure dgParametersSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure cbSensPrintClick(Sender: TObject);
    procedure dgParamEstCovNamesSetEditText(Sender: TObject; ACol, ARow:
      Integer;
      const Value: string);
    procedure adeParamEstCovNameCountExit(Sender: TObject);
    procedure dgParamEstCovarianceSetEditText(Sender: TObject; ACol, ARow:
      Integer;
      const Value: string);
    procedure dgExit(Sender: TObject);
    procedure dgPriorEquationsEditButtonClick(Sender: TObject);
    procedure adePriorInfoEquationCountExit(Sender: TObject);
    procedure dgPriorEquationsSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure cbParamEstClick(Sender: TObject);
    procedure dgMultiplierExit(Sender: TObject);
    procedure cbParamEstRMatrixClick(Sender: TObject);
    procedure dgSensitivityExit(Sender: TObject);
    procedure dgParametersDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbRetainClick(Sender: TObject);
    procedure dg3dLPFParameterClustersSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure dg3dLPFParameterClustersSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure rgAdvObsDisplacementOptionClick(Sender: TObject);
    procedure cbAdvObsClick(Sender: TObject);
    procedure adeAdvectObsLayerCountExit(Sender: TObject);
    procedure adeAdvectObsStartLayerCountExit(Sender: TObject);
    procedure cbSpecifyAdvCovariancesClick(Sender: TObject);
    procedure adeAdvObsBoundCountExit(Sender: TObject);
    procedure cbLAKClick(Sender: TObject);
    procedure cbSubLakesClick(Sender: TObject);
    procedure comboIBSPrintFrequencyChange(Sender: TObject);
    procedure comboIBSSaveFrequencyChange(Sender: TObject);
    procedure cbIBSClick(Sender: TObject);
    procedure dgIBSSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure dgIBSExit(Sender: TObject);
    procedure dgIBSSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure dgIBSDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbTipsClick(Sender: TObject);
    procedure pageControlPackagesChange(Sender: TObject);
    procedure cbRESClick(Sender: TObject);
    procedure cbRESLayerClick(Sender: TObject);
    procedure comboResOptionChange(Sender: TObject);
    procedure PageControlMOC3DChange(Sender: TObject);
    procedure cbTLKClick(Sender: TObject);
    procedure cbTLKStartFromRestartClick(Sender: TObject);
    procedure comboLengthUnitsChange(Sender: TObject);
    procedure rbModflow96Click(Sender: TObject);
    procedure rbMODFLOW2000Click(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure comboSensEstChange(Sender: TObject);
    procedure adeMaxParamEstIterationsChange(Sender: TObject);
    procedure rgFlowPackageClick(Sender: TObject);
    procedure dgNegParamExit(Sender: TObject);
    procedure dgSensitivitySetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure dgPriorEquationsDblClick(Sender: TObject);
    procedure btnTLKRestartFileClick(Sender: TObject);
    procedure dgParametersEnter(Sender: TObject);
    procedure adeLPFParamCountEnter(Sender: TObject);
    procedure adeRCHParamCountEnter(Sender: TObject);
    procedure adeEVTParamCountEnter(Sender: TObject);
    procedure btnShowTipClick(Sender: TObject);
    procedure comboYcintInputChange(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure WrapBtn1Click(Sender: TObject);
    procedure btnModflowImportClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure adeStreamTableEntriesCountEnter(Sender: TObject);
    procedure adeStreamTableEntriesCountExit(Sender: TObject);
    procedure adeSFRParamCountExit(Sender: TObject);
    procedure cbSFRClick(Sender: TObject);
    procedure cbSFRCalcFlowClick(Sender: TObject);
    procedure cbSFRTribClick(Sender: TObject);
    procedure cbSFRDiversionsClick(Sender: TObject);
    procedure cbSFRPrintFlowsClick(Sender: TObject);
    procedure cbAdvObsPartDischargeClick(Sender: TObject);
    procedure adeHDRYExit(Sender: TObject);
    procedure adeHNOFLOExit(Sender: TObject);
    procedure PageControlSolversChange(Sender: TObject);
    procedure dg3dChange(Sender: TObject);
    procedure btnCalculateDecayClick(Sender: TObject);
    procedure dgMultiplierRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure adeSTRParamCountExit(Sender: TObject);
    procedure cbSpecifyStreamCovariancesClick(Sender: TObject);
    procedure adeSTRObsBoundCountExit(Sender: TObject);
    procedure adeObsSTRTimeCountEnter(Sender: TObject);
    procedure adeObsSTRTimeCountExit(Sender: TObject);
    procedure cbStreamObservationsClick(Sender: TObject);
    procedure cbETSClick(Sender: TObject);
    procedure cbETSLayerClick(Sender: TObject);
    procedure comboEtsOptionChange(Sender: TObject);
    procedure adeIntElevExit(Sender: TObject);
    procedure adeETSParamCountEnter(Sender: TObject);
    procedure adeETSParamCountExit(Sender: TObject);
    procedure adeDRTParamCountExit(Sender: TObject);
    procedure cbDRTClick(Sender: TObject);
    procedure cbDRTObservationsClick(Sender: TObject);
    procedure cbSpecifyDRTCovariancesClick(Sender: TObject);
    procedure adeDRTObsBoundCountExit(Sender: TObject);
    procedure adeDRTObsLayerCountExit(Sender: TObject);
    procedure adeObsDRTTimeCountEnter(Sender: TObject);
    procedure adeObsDRTTimeCountExit(Sender: TObject);
    procedure combo_AMG_DampingMethodChange(Sender: TObject);
    procedure adeFileNameEnter(Sender: TObject);
    procedure cbHYDClick(Sender: TObject);
    procedure cbUseAreaRiversClick(Sender: TObject);
    procedure cbUseAreaWellsClick(Sender: TObject);
    procedure cbUseAreaDrainsClick(Sender: TObject);
    procedure cbUseAreaGHBsClick(Sender: TObject);
    procedure cbUseAreaFHBsClick(Sender: TObject);
    procedure cbUseAreaDrainReturnsClick(Sender: TObject);
    procedure sg3dWelParamInstancesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure comboPkgSteadyChange(Sender: TObject);
    procedure sg3dParamInstancesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure btnDistributeParticlesClick(Sender: TObject);
    procedure cbCHDClick(Sender: TObject);
    procedure cbUseAreaCHDClick(Sender: TObject);
    procedure adeCHDParamCountExit(Sender: TObject);
    procedure cbAltCHDClick(Sender: TObject);
    procedure cbFlowBudgetClick(Sender: TObject);
    procedure adeHUFParamCountEnter(Sender: TObject);
    procedure adeHUFParamCountExit(Sender: TObject);
    procedure framHUF1dgHufUnitsEnter(Sender: TObject);
    procedure framHUF1btnInsertUnitClick(Sender: TObject);
    procedure framHUF1btnAddClick(Sender: TObject);
    procedure framHUF1adeHufUnitCountExit(Sender: TObject);
    procedure framHUF1btnDeleteUnitClick(Sender: TObject);
    procedure framHUF1dgHufUnitsExit(Sender: TObject);
    procedure sgMT3DTimeSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure comboMT3DAdvSolSchemeChange(Sender: TObject); virtual;
    procedure comboMT3DInitPartPlaceChange(Sender: TObject); virtual;
    procedure comboMT3DInitPartSinkChoiceChange(Sender: TObject); virtual;
    procedure cbMT3DClick(Sender: TObject); virtual;
    procedure cbADVClick(Sender: TObject); virtual;
    procedure cbDSPClick(Sender: TObject); virtual;
    procedure comboResultsPrintedChange(Sender: TObject); virtual;
    procedure cbPrintConcClick(Sender: TObject); virtual;
    procedure cbPrintRetardationClick(Sender: TObject); virtual;
    procedure cbPrintDispCoefClick(Sender: TObject); virtual;
    procedure cbPrintNumParticlesClick(Sender: TObject); virtual;
    procedure sgReactionSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure comboMT3DIsothermChange(Sender: TObject); virtual;
    procedure comboMT3DIREACTChange(Sender: TObject); virtual;
    procedure cbRCTClick(Sender: TObject); virtual;
    procedure sgMT3DTimeExit(Sender: TObject); virtual;
    procedure sgDispersionOldSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean); virtual;
    procedure btmAddMT3DPrintTimeClick(Sender: TObject); virtual;
    procedure btmDeleteMT3DPrintTimeClick(Sender: TObject); virtual;
    procedure sgDispersionExit(Sender: TObject); virtual;
    procedure sgPrintoutTimesExit(Sender: TObject);
    procedure cbSSMClick(Sender: TObject); virtual;
    procedure cbMT3D_TVCClick(Sender: TObject); virtual;
    procedure sgReactionExit(Sender: TObject); virtual;
    procedure btmInsertMT3DPrintTimeClick(Sender: TObject); virtual;
    procedure adeMT3DNCOMPExit(Sender: TObject);
    procedure cbGCGClick(Sender: TObject);
    procedure sgDispersionSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbMT3D_OneDArraysClick(Sender: TObject);
    procedure cbMT3D_StartingConcentrationClick(Sender: TObject);
    procedure PageControlMT3DChange(Sender: TObject);
    procedure edMT3DMassChange(Sender: TObject);
    procedure cbMT3DMassFluxClick(Sender: TObject);
    procedure adeMT3DNCOMPExceedingBounds(Sender: TObject);
    procedure btnDeleteLPF_ParameterClick(Sender: TObject);
    procedure btnDeleteHUF_ParameterClick(Sender: TObject);
    procedure btnDeleteRCH_ParameterClick(Sender: TObject);
    procedure btnDeleteEVT_ParameterClick(Sender: TObject);
    procedure btnDeleteRIV_ParameterClick(Sender: TObject);
    procedure btnDeleteWEL_ParameterClick(Sender: TObject);
    procedure btnDeleteDRN_ParameterClick(Sender: TObject);
    procedure btnDeleteDRT_ParameterClick(Sender: TObject);
    procedure btnDeleteSFR_ParameterClick(Sender: TObject);
    procedure btnDeleteSTR_ParameterClick(Sender: TObject);
    procedure btnDeleteETS_ParameterClick(Sender: TObject);
    procedure btnDeleteCHD_ParameterClick(Sender: TObject);
    procedure btnDeleteHFB_ParameterClick(Sender: TObject);
    procedure btnDeleteGHB_ParameterClick(Sender: TObject);
    procedure btnDeleteParamEstCovNamesClick(Sender: TObject);
    procedure btnRemoveSenParameterClick(Sender: TObject);
    procedure cbMNWClick(Sender: TObject);
    procedure cbMNW_WriteFlowsClick(Sender: TObject);
    procedure cbMNW_TotalFlowClick(Sender: TObject);
    procedure comboMNW_SteadyChange(Sender: TObject);
    procedure clbMNW_TimeVaryingParametersClickCheck(Sender: TObject);
    procedure combMNW_LossTypeChange(Sender: TObject);
    procedure cbMNW_PrintFlowsClick(Sender: TObject);
    procedure cbMNW_UseClick(Sender: TObject);
    procedure cbDAFLOWClick(Sender: TObject);
    procedure adeDAF_BoundaryTimesEnter(Sender: TObject);
    procedure adeDAF_BoundaryTimesExit(Sender: TObject);
    procedure cbBFLXClick(Sender: TObject);
    procedure cbHUF_ReferenceSurfaceClick(Sender: TObject);
    procedure adeADVParamCountEnter(Sender: TObject);
    procedure adeADVParamCountExit(Sender: TObject);
    procedure btnDeleteADV_ParameterClick(Sender: TObject);
    procedure cbSubClick(Sender: TObject);
    procedure adeSubISUBOCExit(Sender: TObject);
    procedure rdgSubDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure rdgSubSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbSubUseRestartClick(Sender: TObject);
    procedure dgSubOutputSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure dgSubOutputSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure dgSubOutputExit(Sender: TObject);
    procedure cbSFRRetainClick(Sender: TObject);
    procedure cbAreaWellContourClick(Sender: TObject);
    procedure cbAreaRiverContourClick(Sender: TObject);
    procedure cbAreaDrainContourClick(Sender: TObject);
    procedure cbAltDrtClick(Sender: TObject);
    procedure cbAltGHBClick(Sender: TObject);
    procedure cbAreaDrainRetrunContourClick(Sender: TObject);
    procedure cbAreaGHBContourClick(Sender: TObject);
    procedure cbAreaCHDContourClick(Sender: TObject);
    procedure btnDeleteMulitplierClick(Sender: TObject);
    procedure dgMultiplierDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnDeleteZoneClick(Sender: TObject);
    procedure sgZoneArraysDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbCondRivClick(Sender: TObject);
    procedure cbCondDrnClick(Sender: TObject);
    procedure cbCondDrnRtnClick(Sender: TObject);
    procedure cbCondGhbClick(Sender: TObject);
    procedure cbSeaWatClick(Sender: TObject);
    procedure cbSW_MT3DClick(Sender: TObject);
    procedure cbSW_VDFClick(Sender: TObject);
    procedure cbSW_CoupledClick(Sender: TObject);
    procedure comboSW_DensitySpecificationMethodChange(Sender: TObject);
    procedure adeSW_MaxItExit(Sender: TObject);
    procedure cbSW_WellFluidDensityClick(Sender: TObject);
    procedure cbSW_RiverFluidDensityClick(Sender: TObject);
    procedure cbSW_GHB_FluidDensityClick(Sender: TObject);
    procedure cbSW_DrainElevationClick(Sender: TObject);
    procedure cbSW_RiverbedThicknessClick(Sender: TObject);
    procedure cbSW_GHB_ElevationClick(Sender: TObject);
    procedure comboGmgIscChange(Sender: TObject);
    procedure adeModpathBeginExit(Sender: TObject);
    procedure adeModpathEndExit(Sender: TObject);
    procedure rgModpathPeriodStepMethodClick(Sender: TObject);
    procedure comboSpecifyParticlesChange(Sender: TObject);
    procedure comboIRANDChange(Sender: TObject);
    procedure cbCBDYClick(Sender: TObject);
    procedure cb_GWMClick(Sender: TObject);
    procedure frameGWM_BinaryadeDecisionVariableCountExit(Sender: TObject);
    procedure frameGWM_BinarybtnAddClick(Sender: TObject);
    procedure frameGWM_BinarybtnDeleteClick(Sender: TObject);
    procedure frameGWM_BinarybtnInsertClick(Sender: TObject);
    procedure frameGWM_BinarydgVariablesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure frameGWM_BinarydgVariablesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure frameGWM_CombinedConstraintsadeDecisionVariableCountExit(
      Sender: TObject);
    procedure frameGWM_CombinedConstraintsbtnAddClick(Sender: TObject);
    procedure frameGWM_CombinedConstraintsbtnInsertClick(Sender: TObject);
    procedure frameGWM_CombinedConstraintsbtnDeleteClick(Sender: TObject);
    procedure frameGWM_CombinedConstraintsdgVariablesSelectCell(
      Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure frameGWM_CombinedConstraintsdgVariablesSetEditText(
      Sender: TObject; ACol, ARow: Integer; const Value: String);
    procedure rgGWM_SolutionTypeClick(Sender: TObject);
    procedure rgGWM_ResponseMatrixClick(Sender: TObject);
    procedure frameGWM_ExternalbtnAddClick(Sender: TObject);
    procedure frameGWM_ExternaladeDecisionVariableCountExit(
      Sender: TObject);
    procedure frameGWM_ExternalbtnInsertClick(Sender: TObject);
    procedure btnImportFlowVar1Click(Sender: TObject);
    procedure frameGWM_ExternaldgVariablesExit(Sender: TObject);
    procedure frameGWM_ExternalbtnDeleteClick(Sender: TObject);
    procedure frameGWM_BinarydgVariablesExit(Sender: TObject);
    procedure frameGWM_FlowObjectivebtnAddClick(Sender: TObject);
    procedure frameGWM_FlowObjectivebtnInsertClick(Sender: TObject);
    procedure frameGWM_FlowObjectiveadeDecisionVariableCountExit(
      Sender: TObject);
    procedure frameGWM_ExternalObjectivebtnAddClick(Sender: TObject);
    procedure frameGWM_ExternalObjectivebtnInsertClick(Sender: TObject);
    procedure frameGWM_ExternalObjectiveadeDecisionVariableCountExit(
      Sender: TObject);
    procedure frameGWM_BinaryObjectivebtnAddClick(Sender: TObject);
    procedure frameGWM_BinaryObjectivebtnInsertClick(Sender: TObject);
    procedure frameGWM_BinaryObjectiveadeDecisionVariableCountExit(
      Sender: TObject);
    procedure pcGWMChange(Sender: TObject);
    procedure comboMnwObservationsChange(Sender: TObject);
    procedure cbSfrUnsatflowClick(Sender: TObject);
    procedure cbSfrLpfHydraulicCondClick(Sender: TObject);
    procedure cbSfrTimeVaryingPropertiesClick(Sender: TObject);
    procedure rbSfr2ByEndpointsClick(Sender: TObject);
    procedure cbParticleObservationsClick(Sender: TObject);
    procedure cbMpathElevationsClick(Sender: TObject);
    procedure cbGWM_PrintResponseMatrixClick(Sender: TObject);
    procedure comboGmgIadampChange(Sender: TObject);
    procedure adeGWM_DINITExit(Sender: TObject);
    procedure cbUZFClick(Sender: TObject);
    procedure cbUzfIUZFOPTClick(Sender: TObject);
    procedure cbUzfIETFLGClick(Sender: TObject);
    procedure cbUzfIRUNFLGClick(Sender: TObject);
    procedure cbMt3dMultiDiffusionClick(Sender: TObject);
    procedure cbSWTClick(Sender: TObject);
    procedure adeSwtISWTOCExit(Sender: TObject);
    procedure adeSwtISWTOCEnter(Sender: TObject);
    procedure rdgSwtOutputSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbIncreaseUnitNumbersClick(Sender: TObject);
    procedure cbTOBClick(Sender: TObject);
    procedure adeConcObsLayerCountExit(Sender: TObject);
    procedure adeConcObsTimeCountExit(Sender: TObject);
    procedure adeConcObsTimeCountEnter(Sender: TObject);
    procedure cb_inConcObsClick(Sender: TObject);
    procedure comboDensityChoiceChange(Sender: TObject);
    procedure adeSWDensCompCountExit(Sender: TObject);
    procedure rdgSWDensTableBeforeDrawCell(Sender: TObject; ACol,
      ARow: Integer);
    procedure cbSeawatViscosityClick(Sender: TObject);
    procedure comboSW_ViscosityMethodChange(Sender: TObject);
    procedure comboSW_ViscEquationChange(Sender: TObject);
    procedure comboSW_TimeVaryingViscosityChange(Sender: TObject);
    procedure adeSW_ViscEquationCountExit(Sender: TObject);
    procedure btnSW_ViscEqTermDefaultsClick(Sender: TObject);
    procedure cbKinematicRoutingClick(Sender: TObject);
    procedure btnMnw2AddPumpClick(Sender: TObject);
    procedure tvMnw2PumpsChange(Sender: TObject; Node: TTreeNode);
    procedure btnDeletePumpClick(Sender: TObject);
    procedure tvMnw2PumpsAddition(Sender: TObject; Node: TTreeNode);
    procedure tvMnw2PumpsDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvMnw2PumpsEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure cbMnw2Click(Sender: TObject);
    procedure cbMnw2PumpcapClick(Sender: TObject);
    procedure rgMnw2WellTypeClick(Sender: TObject);
    procedure clbMnw2LossTypesClickCheck(Sender: TObject);
    procedure cbMnw2TimeVaryingClick(Sender: TObject);
    procedure adeMnw2WellScreensExit(Sender: TObject);
    procedure comboMPATHDirectionChange(Sender: TObject);
    procedure cbMnwiClick(Sender: TObject);
    procedure comboBinaryInitialHeadChoiceChange(Sender: TObject);
    procedure rdgMt3dBinaryInitialConcFilesButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure rdgMt3dBinaryInitialConcFilesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure comboLakSteadyLeakanceChange(Sender: TObject);
    procedure dg3dGwmStorageZonesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure rdeGwmStorageStateVarCountExit(Sender: TObject);
    procedure btnAddGwmStorageStateVarClick(Sender: TObject);
    procedure rdeGwmStorageStateVarCountEnter(Sender: TObject);
    procedure btnDeleteGwmStorageStateVarClick(Sender: TObject);
    procedure btnInsertGwmStorageStateVarClick(Sender: TObject);
    procedure rdgGwmStorageVariablesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure cbGwmHeadVariablesClick(Sender: TObject);
    procedure cbGwmStreamVariablesClick(Sender: TObject);
    procedure rdeGwmStateTimeCountExit(Sender: TObject);
    procedure rdeGwmStateTimeCountEnter(Sender: TObject);
    procedure rgCritMFCClick(Sender: TObject);
    procedure framFilePathGWM_ResponseMatrixedFilePathChange(Sender: TObject);
    procedure framFilePathGWM_ResponseMatrixAsciiedFilePathChange(
      Sender: TObject);
    procedure rdeZoneCountExit(Sender: TObject);
    procedure cbCCBDClick(Sender: TObject);
    procedure cbISRCFIXClick(Sender: TObject);
    procedure cbVBALClick(Sender: TObject);
  published
    function SetColumns(AStringGrid: TStringGrid): boolean; override;
    procedure WriteSpecial(ComponentData: TStringList;
      const IgnoreList: TStringlist; OwningComponent: TComponent); override;
  private
    OldRoot: string;
    NextUnitNumber: integer;
    FormHeight, FormWidth: integer;
    OldHufNames, NewHufNames: TStringList;
    HufLVDA_Units: TStringList;
    LmgWarningShown: boolean;
    dgSubOutputCellText: string;
    PriorISWTOC: integer;
    FPriorGwmStateStoreCount: Integer;
    FChangingGwmStateRow: Boolean;
    FPriorStateTimeCount: Integer;
    procedure addParamPage(const A3DDataGrid: TRBWDataGrid3d);
    procedure UpdateLCFMultiplier(Position: integer; OldMultiplierName,
      NewMultiplierName: string); overload;
    //    procedure UpdateLCFZone(OldZoneName, NewZoneName: string);
    procedure InitializeParamPage(ADataGrid: TDataGrid);
    procedure InitializeMultiplierGrid;
    procedure InitializeZoneGrid;
    procedure InitializeMultParamPickLists(A3DDataGrid: TRBWDataGrid3d);
    procedure UpdateLCFZone(Position: integer; OldZoneName,
      NewZoneName: string);
    procedure InitializeZoneParamPickLists(A3DDataGrid: TRBWDataGrid3d);
    procedure FixMultiplierNames;
    procedure FixZoneNames;
    procedure InitializeDataGrid(ADataGrid: TDataGrid; ParameterCount: integer);
    procedure FixParameterNames;
    function GetMultiplierCount: integer;
    procedure ReadOldTimeData(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure AddHeadObsTimes(NewHeadObsTimeCount: integer;
      ObservationList: T_ANE_IndexedLayerList);
    procedure DeleteHeadObsWeights(UnitIndex: integer);
    procedure InsertHeadObsWeights(UnitIndex: integer);
    procedure AddFluxLayers(NewLayerCount: integer;
      FluxList: T_ANE_IndexedLayerList;
      FluxLayerClass: TIndexedInfoLayerClass);
    procedure AddFluxObsTimes(NewFluxObsTimeCount,
      OldFluxObsTimeCount: integer;
      ObservationList: T_ANE_IndexedLayerList;
      ParameterListClass: T_ANE_IndexedParameterListClass);
    procedure ChangeObservationVarianceGridSize(Limit: integer;
      DataGrid: TDataGrid);
    procedure RemoveOldParameters(ADataGrid: TDataGrid;
      ParameterCount: integer);
    procedure AddNewParameters(ADataGrid: TDataGrid;
      OldNameCount: integer);
    procedure InitializeEquationEditor(Editor: TfrmPriorEquationEditor);
    function CanSelectCell(ACol, ARow: Integer; AName: string): boolean;
    procedure ActivateParametersTab;
    procedure UpdateMultiplier(Position: integer; OldMultiplierName,
      NewMultiplierName: string; ADataGrid: TDataGrid);
    procedure UpdateZone(Position: integer; OldZoneName,
      NewZoneName: string; ADataGrid: TDataGrid);
    procedure SetLakesSteady;
    procedure FixPriorEstimates;
    procedure ReadOldProgramChoice(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure Modflow96Warnings;
    procedure Modflow2000Warnings;
    procedure EnableObsSenParameter;
    procedure SetMode;
    procedure SortParamNames;
    procedure SetUnits;
    procedure MODPATHWarnings;
    procedure SaveUnitNumbers(AStringList: TStringList);
    function ReadUnitNumbers(AStringList: TStringList;
      Start: integer): integer;
    procedure LoadUnitNumbers(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    function EvaluateLPFParameter(const Row: integer): lpfParameterType;
    procedure SensitivityWarning;
    function EvaluateZones(const AGrid: TStringGrid;
      const ZoneName: string; const RowIndex: integer): string;
    procedure SetMF2K_GWTCaptions;
    procedure ReadOldCheckDataCheckBox(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure ModPathHNOFLO_Warning;
    procedure SetModPathTimeOptions;
    procedure SpecifyLayerWarning;
    procedure DRTWarning;
    procedure ETSWarning;
    procedure LmgWarning;
    procedure HydmodWarning;
    function GetParmInstanceGrid(const Sender: TObject): TRBWStringGrid3d;
    function GetParamDataGrid(const Sender: TObject): TDataGrid;
    procedure CheckInstances;
    function StartTimeColumns(const DataGrid: TDataGrid): integer;
    function GetParmClusterGrid(const Sender: TObject): TRBWDataGrid3d;
    procedure FixInstanceCounts;
    function GetInstanceArrayCount(const ParameterCount: integer;
      const DataGrid: TDataGrid): integer;
    procedure SetClusterTabCaptions(const ParamGrid: TDataGrid;
      const InstanceGrid: TRBWStringGrid3d;
      const ClusterGrid: TRBWDataGrid3d);
    function GetPreviousInstances(const ARow: integer;
      const DataGrid: TDataGrid): integer;
    procedure ZoneBudgetWarning;
    procedure CHDWarning;
    procedure SetUpMt3dReactionGrid(const NCOMP: integer);
    procedure AddOrRemoveMT3D_ReactionLayers;
    procedure HUF_ParameterWarning;
    procedure ReadOldedMT3DLength(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure InitializeFormats(const DG3D: TRBWDataGrid3d);
    procedure CheckValidZoneNumbers;
    procedure DeleteParameterAndInstances(const ParamGrid: TStringGrid;
      const InstanceGrid: TRbwStringGrid3d;
      const ParamCountEdit: TArgusDataEntry);
    procedure DeleteParameterInstancesAndClusters(
      const ParamGrid: TDataGrid; const InstanceGrid: TRbwStringGrid3d;
      const ClusterGrid: TRBWDataGrid3d;
      const ParamCountEdit: TArgusDataEntry);
    procedure ModpathTimeWarning;
    procedure RemoveSensitivityParameter(const Row: integer);
    procedure Activate_cbMNW_Alltime;
    procedure ActivateMNWTimeVaryingParameters;
    procedure EnableMNW_Coefficient;
    procedure Activate_adeMNW_PLoss;
    procedure MNW_Warning;
    procedure ShowDaflowWarning;
    procedure UpdateIFACE;
    procedure UpdateHufLVDA_Units;
    procedure HUF_HFB_Warning;
    procedure UpdateHufSYTP;
    procedure AdvObsWarning;
    function EvaluateADVParameter(const Row: integer): TAdvParameterType;
    procedure HUF_SensitivityWarning;
    procedure SubsidenceWarnings;
    function IsSteadyStateStress(const ARow: integer): boolean;
    procedure SFR_Warning;
    procedure SetCompactOption;
    procedure TestHeadExport(Sender: TObject);
    procedure EnablecbAreaWellContour;
    procedure EnableAreaRiverContour;
    procedure EnableAreaDrainContour;
    procedure EnableAreaDrainReturnContour;
    procedure EnableAreaGHBContour;
    procedure EnableAreaCHDContour;
    procedure DeleteZoneGridParameters(const GridLayer: T_ANE_GridLayer;
      const NewZoneCount: integer);
    procedure EnableCoupledFlowAndTransport;
    procedure AddOrRemoveSeaWatLayersAndParameters;
    procedure StreamToleranceWarning;
    procedure UpdateUseObsList(const ListBox: TCheckListBox;
      const OldLayerCount, NewLayerCount: integer);
    function GetPeriodAndStepFromTime(const ATime: double; out Period,
      Step: integer; const GetFirst: boolean; out RemainingTime: double): boolean;
    function ModpathStartingTimeProblem: boolean;
    procedure EnableSpecifiedOutputControls;
    procedure AddOrRemoveGWM_STRLayers;
    procedure AdjustGWM_TimeDataGrids;
    procedure AddGWM_BinaryGrid;
    procedure AddGWM_CombinedGrid;
    procedure AddOrRemoveGWM_SLP_Parameters;
    procedure Update_frameGWM_External_dgVariables;
    procedure Update_frameGWM_Binary_dgVariables;
    procedure UpdateExternalVariables;
    procedure UpdateBinaryVariables;
    procedure UpdateCombinedConstraintNames;
    procedure UpdateObjectiveGrid(const Frame: TframeGWM);
    procedure Update_dg3dGWM_BinaryDecVar;
    procedure ActivateComboMnwObservations;
    procedure AddOrRemoveMnwObservations;
    procedure GmgWarning;
    procedure AddOrRemoveMT3D_MNW_Parameters;
    procedure OnSfr2IsfroptChange;
    procedure AddOrRemoveUnsatStreamParams;
    procedure UnsatflowWarning;
    procedure Enable_cbCBDY;
    procedure AdvectionObservationWarning;
    function ConvertDAF_TimeToSeconds(ATime: double): double;
    function ConvertSimulation_TimeToSeconds(ATime: double): double;
    procedure ReadOldGWM_SLPITPRT(var LineIndex: integer; FirstList,
      IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
    procedure EnableSfrUnsatFlowControls;
    procedure ReadOldTheta(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure EnablecbUzfIRUNFLG;
    procedure UpdatedUzfLayersAndParameters;
    procedure Modflow2005Warning;
    procedure TlkWarning;
    procedure DaflowWarning;
    procedure SorWarning;
    procedure EnableMf2005LpfOptions;
    procedure UpdateConcObsWeights;
    procedure EnableMinAndMaxSeawatDensity;
    procedure EnableSeawatDenConvCrit;
    procedure EnableMultipCompControls;
    procedure EnableSeawatViscSpecies;
    procedure EnableSeawatViscTerms;
    procedure EnableSeawatMultViscEq;
    procedure EnableSW_TempCorrectionTerms;
    procedure EnableSW_TimeVaryingViscosity;
    procedure SetViscEqDefaults(const SetAll: boolean);
    function frameMnw2PumpName(Value: integer): string;
    procedure DeleteMnw2PumpNode(Node: TTreeNode);
    procedure Mnw2PumpNameChanged(Sender: TObject);
    procedure AddOrRemoveMnw2LayersAndParameters;
    procedure Mnw2Warning;
    procedure EnableReleaseTimeCount;
    procedure SetVersionCaption;
    procedure TwoMnwWarning;
    procedure EnableBinaryStressPeriodAndTimeStep;
    procedure EnableMt3dBinaryConcFiles;
//    procedure UpdateGwmStateGrids(RowIndex: Integer);
    procedure UpdateGwmStateSP_Limits;
    procedure EnableGwmStreamVariables;
    procedure GWM_Warning;
    procedure EnableMBRP_and_MBIT;
    procedure EnableCCBD;
    procedure EnableVBAL;
//    function HelpFileFullPath(const FileName: string): string;
    //    procedure SetZoneBudgetCompositeZoneTitles;
  public
    //    ThisCount : integer;
    MFLayerStructure: TLayerStructure;
    PrevNumPeriods: integer;
    PrevNumUnits: integer;
    PreviousFHBTimes: integer;
    LastGeologyText: string;
    LastTimeText: string;
    PreviousParticleText: string;
    PreviousFHBTimeText: string;
    PreviousMODPATHReleaseTimesText: string;
    //    FirstList :TStringList;
    RecalculateSubgrid: boolean;
    GeologicUnitsList: TList;
    GeologicUnitParametersList: TList;
    PreviousMODPATHTimeText: string;
    PrevCompZoneText: string;
    PrevCompZoneCount: string;
    PrevZoneBudTime: string;
    PrevMOC3DTransParam: string;
    NeedToUpdateMOC3DSubgrid: boolean;
    LeftMOC3DSubGridDistance: double;
    RightMOC3DSubGridDistance: double;
    TopMOC3DSubGridDistance: double;
    BottomMOC3DSubGridDistance: double;
    OldMultiplierNames: TStringList;
    OldZoneNames: TStringList;
    OldMultiplierCount: integer;
    OldHeadObsTimeCount: integer;
    OldConcObsTimeCount: integer;
    OldGHBObsTimeCount: integer;
    OldRiverObsTimeCount: integer;
    OldStreamObsTimeCount: integer;
    OldDrainObsTimeCount: integer;
    OldDrainReturnObsTimeCount: integer;
    OldHeadFluxObsTimeCount: integer;
    OldParamNames: TStringList;
    SensitivityNames: TStringList;
    OldZoneNumber: string;
    SettingMode: boolean;
    GeologyRow: integer;
    UnitNumberStringList: TStringList;
    NeedToSaveUnitNumbers: boolean;
    PreviousNumberOfStreamTableEntries: integer;
    CBNeeded: boolean;
    LastInstanceCountStringList: TStringList;
    PreviousLakeStreamsText: string;
    PreviousDaflowTimes: integer;
    Importing: boolean;
    LengthUnit: string;
    TimeUnit : string;
    MT3DMassUnit : string;
    MultiNodeWellNames: TStringList;
    MonitoringWellNameFileLines: TStringList;
    procedure Mt3dTransObsWarning;
    function IsAnyTransient: boolean;
    procedure SetMaxFileNameLength;
    function Mnw2LossTypeChoices: TMnw2LossTypeSet;
    function FixModflowName(AString: string): string;
    procedure InitializeGrids; virtual;
    procedure InitialHeadsWarning; virtual;
    function CBoundNeeded(GeolUnit: Integer): boolean; virtual;
    procedure AssociateUnits; virtual;
    procedure AssociateTimes; virtual;
    procedure InsertTimeParameters(Position: Integer); virtual;
    procedure DeleteTimeParameters(Position: Integer); virtual;
    procedure CreateGeologicLayer(Position: integer); virtual;
    procedure DeleteGeologicLayer(Position: integer); virtual;
    //    procedure AssignHelpFile(FileName : string) ; virtual;
    function MODFLOWLayerCount: integer; virtual;
    function MOC3DLayerCount: integer; virtual;
    function GetCompositeZone(const Zone: Integer): string; virtual;
    function GetZonebudTimesCount: integer; virtual;
    function GetZoneBudTimeStep(ATime: integer): Integer; virtual;
    function GetZoneBudStressPeriod(ATime: integer): Integer; virtual;
    function RowNeeded(Row: integer): boolean; virtual;
    function GetPIEVersion(AControl: Tcontrol): string; virtual;
    class function PieIsEarlier(VersionInString, VersionInPIE: string;
      ShowError: boolean): boolean; virtual;
    procedure ReadOldGeoData(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldIDIREC(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadEPSSLV(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadCTOCH(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure LoadModflowForm(UnreadData: TStringlist; DataToRead: string;
      var VersionInString: string); virtual;
    procedure ReadValFile(var VersionInString: string; Path: string);
    procedure UpdateMOC3DSubgrid; virtual;
    procedure StreamWarning; virtual;
    procedure Moc3dWetWarning; virtual;
    procedure Moc3dTimeWarning; virtual;
    procedure SetComboColor(ACombo: TComboBox); virtual;
    procedure ModelComponentName(AStringList: TStringList); override;
    procedure LabelUnits(AStringGrid: TStringGrid); virtual;
    procedure ReadOld_IDPTIM(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOld_IDKTIM(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    function AnisotropyUsed(UnitNumber: integer): boolean;
    function MODFLOWLayersAboveCount(UnitNumber: integer): integer;
    function ModflowLayerToUnit(Layer: integer): integer;
    function DiscretizationCount(UnitNumber: integer): integer;
    function ModflowLayerType(UnitNumber: integer): integer;
    procedure AddHeadObsWeights(NewUnitCount: integer);
    function ModflowLayer(const AUnit: integer; const TopElev, BotElev,
      Elev: double): integer;
    function Simulated(const UnitIndex: integer): boolean;
    function GetUnitIndex(LayerIndex: integer): integer;
    function GetDiscretizationIndex(UnitIndex,
      LayerIndex: integer): integer;
    function UnitCount: Integer;
    function PriorEquation(RowIndex: integer): string;
    function PorosityUsed: boolean;
    //    function IsAllSteady: boolean;
    function IsAnySteady: boolean;
    function IsSteady(const StressPeriod: integer): boolean;
    function UseIBS(UnitNumber: integer): boolean;
    { Public declarations }
    procedure Tip;
    function UseTLK(UnitNumber: integer): boolean;
    procedure ClearUnitNumberStringList;
    function GetNUnitNumbers(FileName: string; Count: integer): integer;
    function GetNextNUnitNumber(Count: integer): integer;
    function GetNextUnitNumber: integer;
    function GetUnitNumber(FileID: string): integer;
    function UsePredictions: boolean;
    function IBSLayerCount: integer;
    procedure SetZoneBudgetCompositeZoneTitles;
    procedure FixMOC3D;
    function FractionForLayer(TopElevGeoUnit, BottomElevGeoUnit,
      TopElevContour, BottomElevContour: double; GeoUnitNumber,
      ModflowLayer: integer): double;
    function LpfParameter(const AType: lpfParameterType; const UnitIndex:
      integer): string;
    function LpfParameterUsed(const AType: lpfParameterType): boolean;
    procedure SetCBoundNeeded;
    function ModPathSteady: integer;
    function LpfHaniParametersUsed: boolean;
    function HufHaniParametersUsed: boolean;
    procedure ReadOldParamGrids(var LineIndex: integer; FirstList,
      IgnoreList: TStringlist; DataToRead: TStringList;
      const VersionControl: TControl);
    procedure UpdateCaptions;
    procedure AddRemoveCHFBParameters;
    procedure SetHFB_Caption;
    function UpdateHUF_Units: boolean;
    function HufParameter(const AType: hufParameterType; const UnitIndex:
      integer): string;
    function HufParameterUsed(const AType: hufParameterType): boolean;
    function ModflowLayerWet(UnitNumber: integer): integer;
    procedure EnableSSM; virtual;
    procedure ReadOldStream(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldStreamDiv(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldStreamICALC(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldStreamModelUnits(var LineIndex: integer; FirstList,
      IgnoreList: TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldStreamSteady(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldStreamTrib(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldStreamPrint(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldLakeGeoData(var LineIndex: integer; FirstList, IgnoreList:
      TStringlist;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure LakeWarning; virtual;
    procedure MT3DWarning;
    function ModPathTimeProblem: boolean;
    function ModPathReferenceTimeProblem: boolean;
    procedure GeologyWarning;
    procedure DaflowWarnings(const Messages: TStringList);
    function EvaluateHUFParameter(const Row: integer): hufParameterType;
    function ADVParameterUsed(const AType: TAdvParameterType): boolean;
    function AdvParameter(const AType: TAdvParameterType;
      const UnitIndex: integer): string;
    function NoDelayInterbedCount(const UnitIndex: integer): integer;
    function DelayInterbedCount(const UnitIndex: integer): integer;
    function SubNDB: integer;
    function SubNNDB: integer;
    procedure SetSubsidenceLayers;
    procedure SetSwtLayers;
    function GetSensitivityValue(const ParameterName: string;
      var Value: string): boolean;
    function WeightedParticlesUsed: boolean;
    function ISFROPT: integer;
    procedure ClearMultiNodeWellNames;
    function AdvectionObservationsDefined: boolean;
    function DaflowFirstTimeError: string;
    function DaflowLastTimeError: string;
    function SwtInterbedCount(const UnitIndex: integer): integer;
    function NSYSTM: integer;
{$IFDEF Debug}
    constructor Create(AOwner: TComponent); override;
{$ENDIF}
  end;

type
  timeData = (tdN, tdLength, tdNumSteps, tdMult, tdSsTr, tdFirstStep,
    tdRefStrPeriod);
  //  timeData is used to access data columns in dgTime by name

  //type unitData = (uiName, uiSim, uiTrans, uiType, uiAnis, uiVertDisc);
  //  unitData is used to access data columns in dtabGeol by name

  NewUnitData = (nuiN, nuiName, nuiSim, nuiTrans, nuiType, nuiAnis,
    nuiVertDisc, nuiSpecT, nuiSpecVCONT, nuiSpecSF1, nuiSpecAnis,
    nuiWettingActive);
  //  unitData is used to access data columns in dgGeol by name

  MOC3DparticleData = (pdN, pdLayer, pdRow, pdColumn);
  //  unitData is used to access data columns in sgMOC3DParticles by name

  MOC3DtransData = (trdN, trdLong, trdTranHor, trdTranVer,
    trdRetard, trdConc);
  //  unitData is used to access data columns in sgMOC3DTransParam by name

  LayerPropertyParameter = (lppName, lppType, lppInitialValue, lppClusterCount,
    lppInstances);

  GeneralPropertyParameter = (gppName, gppInitialValue, gppClusterCount);

  SolverChoice = (scSIP, scDE4, scPCG2, scSOR, scLMG, scGMG);

  LayerGroups = (lgLakeLeakance, lgMultipliers, lgZones, lgObservationGroups,
    lgHeadObservations, lgWeightedHeadObservations, lgGHBFlux, lgDrainFlux,
    lgDrainReturnFlux, lgRiverFlux, lgSpecifiedHead, lgAdvectionStart,
    lgAdvectionObservation, lgMt3dConcentrationObservations);

  MultiNodeWellTransientParameters = (mnwWellRadius, mnwGroupID,
    mnwDrawdownFlag, mnwRefElev, mnwLimitingElevation, mnwPumpingLimits,
    mnwWaterQuality, mnwSkin, mnwCoefficient, mnwMt3dConc1, mnwMt3dConc2,
    mnwMt3dConc3, mnwMt3dConc4, mnwMt3dConc5);

  TMt3dBinaryFlowFileColumns = (mbffNone, mbffFileName);

resourcestring
  rsN = 'N';
  rsName = 'Name';
  rsSim = 'Simulated';
  rsTrans = 'Interblock Transmissivity';
  rsType = 'Aquifer type';
  rsAnis = 'Anisotropy';
  rsVertDisc = 'V. Discretization';
  rsLength = 'Length (PERLEN)';
  rsNumSteps = 'No. of steps (NSTP)';
  rsMult = 'Multiplier (TSMULT)';
  rsFirstStep = 'Length of first step';
  rsLayer = 'Position in Layer';
  rsRow = 'Position in Row';
  rsColumn = 'Position in Column';
  rsLongDisp = 'Long. Dispersivity';
  rsTransHorDisp = 'Trans. Hor. Dispersivity';
  rsTransVerDisp = 'Trans. Ver. Dispersivity';
  rsRetard = 'Retardation';
  rsConc = 'C'' boundary';
  rsTime = 'Time';
  rsStressPeriod = 'Stress Period';
  rsTimeStep = 'Time Step';

resourcestring
  rsTransStep = 'Transport step size (DT0)';
  rsMaxTransStep = 'Max. no. of transport steps (MXSTRN)';
  rsTranCalculated = 'Transport step size calculated (DT0)';
  rsTimeStepMultiplier = 'Time step multiplier (TTSMULT)';
  rsTimeStepMax = 'Maximum time step size (TTSMAX)';

  rsHorzDispRatio = 'Horz. Dispersivity Ratio (TRPT)';
  rsVertDispRatio = 'Vert. Dispersivity Ratio (TRPV)';
  rsMolDifCoef = 'Molecular Diffusion Coef. (DMCOEF)';
  rsBulkDensity = 'Bulk Density (RHOB)';
  rsSorpConst1 = '1''st Sorption Const. (SP1)';
  rsSorpConst2 = '2''nd Sorption Const. (SP2)';
  rsRateConstDis = 'Rate Const. Dissolved (RC1)';
  rsRateConstSorb = 'Rate Const. Sorbed (RC2)';
  rsDualDomainPorosity = 'Porosity of Immobile Domain (PRSITY2)';
  rsStartingConcentration = 'Immobile Initial Concentration (SRCONC)';

implementation

{$R *.DFM}

{To compile with a version of Delphi in which the math unit is not present,
(such as the standard version) the following DEFINE should be commented out
or deleted and a unit should be provided named Powers.pas that provides an
"IntPower" function. The function should be declared as

function IntPower(Base: Extended; Expon: LongInt): Extended;

The IntPower function should take Base and raise it the power indicated by
Expon and return the result.
A suitable function is presented on p 435-436 of Rubenking, Neil, 1996. Delphi
Programming Problem Solver. IDG Books, Foster City, California, 604 p.}

{$DEFINE MathUnitPresent}

uses
  FileCtrl, 
{$IFDEF Debug}
  DebugUnit,
{$ENDIF}
{$IFDEF MathUnitPresent}
  Math,
{$ELSE}
  Powers,
{$ENDIF}
  MFMOCObsWell, AnePIE, ANECB, UtilityFunctions, Variables,
  ContourListUnit, MOC3DGridFunctions, frmMultiplierEditUnit, FixNameUnit,
  frmMultValueUnit, UnitNumbers, WriteSensitivityUnit, OptionsUnit,
  ModflowImport, WriteModflowDiscretization, ConserveResourcesUnit,
  DecayCalculator, frmDistributeParticlesUnit, MF_HUF,
  MFGrid, MT3DGeneralParameters, MFSubsidence, RealListUnit, IntListUnit,
  MF_SWT, MFFluxObservationUnit;

function TfrmMODFLOW.ModflowLayerType(UnitNumber: integer): integer;
begin
  result := dgGeol.Columns[Ord(nuiType)].Picklist.IndexOf
    (dgGeol.Cells[Ord(nuiType), UnitNumber]);
end;

function TfrmMODFLOW.ModflowLayerWet(UnitNumber: integer): integer;
begin
  if (ModflowLayerType(UnitNumber) = 0) or (comboWetCap.ItemIndex = 0) or
    (dgGeol.Columns[Ord(nuiWettingActive)].PickList.IndexOf
    (dgGeol.Cells[Ord(nuiWettingActive), UnitNumber]) = 0) then
  begin
    result := 0;
  end
  else
  begin
    result := 1;
  end;
end;

function TfrmMODFLOW.DiscretizationCount(UnitNumber: integer): integer;
begin
  result := StrToInt(dgGeol.Cells[Ord(nuiVertDisc), UnitNumber]);
end;

function TfrmMODFLOW.GetDiscretizationIndex
  (UnitIndex, LayerIndex: integer): integer;
begin
  result := LayerIndex - MODFLOWLayersAboveCount(UnitIndex);
  Assert((result > 0) and (result <= DiscretizationCount(UnitIndex)));
end;

function TfrmMODFLOW.GetUnitIndex(LayerIndex: integer): integer;
var
  Index: integer;
  Total: integer;
begin
  Total := 0;
  for Index := 1 to dgGeol.RowCount - 1 do
  begin
    if Simulated(Index) then
    begin
      Total := Total + DiscretizationCount(Index);
      if Total >= LayerIndex then
      begin
        result := Index;
        Exit;
      end;
    end;
  end;
  result := dgGeol.RowCount - 1;
end;

function TfrmMODFLOW.ModflowLayer(const AUnit: integer;
  const TopElev, BotElev, Elev: double): integer;
var
  FloatResult: double;
//  temp: integer;
begin
  result := MODFLOWLayersAboveCount(AUnit);
  if (Elev > TopElev) then
  begin
    result := result + 1;
  end
  else if (Elev <= BotElev) or (TopElev = BotElev) then
  begin
    result := result + DiscretizationCount(AUnit);
  end
  else
  begin
    FloatResult := ((TopElev - Elev) * DiscretizationCount(AUnit))
      / (TopElev - BotElev);
    if FloatResult <> 0 then
    begin
      // Int(0) can raise an exception in Delphi 5.
      // This might not be the case in later versions of Delphi.
      FloatResult := Int(FloatResult);
    end;
    result := result + Round(FloatResult) + 1;
  end;
end;

function TfrmMODFLOW.MODFLOWLayersAboveCount(UnitNumber: integer): integer;
var
  UnitIndex: integer;
begin
  // called by btnOpenDataSetClick in PostMODFLOW.
  // called by btnOKClick
  // This function returns the number of MODFLOW layers in a model above the
  // unit specified by UnitNumber.

  // Initialize result
  result := 0;

  // loop over geologic units
  for UnitIndex := 1 to UnitNumber - 1 do
  begin
    // if a geologic unit is simulated, add the vertical discretization of
    // that unit to the total.

    { TODO : Consider replacing if conditions with Simulated }
    if dgGeol.Cells[Ord(nuiSim), UnitIndex]
      = dgGeol.Columns[Ord(nuiSim)].PickList[1] then
    begin
      result := result + DiscretizationCount(UnitIndex);
    end;
  end;
end;

function TfrmMODFLOW.ModflowLayerToUnit(Layer: integer): integer;
var
  Index: integer;
  LayerCount: integer;
begin
  result := -1;
  Assert(Layer >= 1);
  LayerCount := 0;
  for Index := 1 to dgGeol.RowCount -1 do
  begin
    if Simulated(Index) then
    begin
      LayerCount := LayerCount + DiscretizationCount(Index);
      if LayerCount >= Layer then
      begin
        result := Index;
        Exit;
      end;
    end;
  end;
  Assert(False);
end;

function TfrmMODFLOW.Simulated(const UnitIndex: integer): boolean;
begin
  result := dgGeol.Cells[Ord(nuiSim), UnitIndex]
    = dgGeol.Columns[Ord(nuiSim)].PickList[1];
end;

function TfrmMODFLOW.UnitCount: Integer;
begin
  result := dgGeol.RowCount - 1;
end;

function TfrmMODFLOW.IBSLayerCount: integer;
var
  UnitIndex: integer;
begin
  // called by btnOpenDataSetClick in PostMODFLOW.
  // called by btnOKClick
  // This function returns the number of MODFLOW layers in a model.

  // Initialize result
  result := 0;

  // loop over geologic units
  for UnitIndex := 1 to dgGeol.RowCount - 1 do
  begin
    // if a geologic unit is simulated, add the vertical discretization of
    // that unit to the total.
    if Simulated(UnitIndex) and (dgIBS.Columns[1].Picklist.IndexOf
      (dgIBS.Cells[1, UnitIndex]) = 1) then
    begin
      result := result + StrToInt(dgGeol.Cells
        [Ord(nuiVertDisc), UnitIndex]);
    end;
  end;
end;

function TfrmMODFLOW.MODFLOWLayerCount: integer;
var
  UnitIndex: integer;
begin
  // called by btnOpenDataSetClick in PostMODFLOW.
  // called by btnOKClick
  // This function returns the number of MODFLOW layers in a model.

  // Initialize result
  result := 0;

  // loop over geologic units
  for UnitIndex := 1 to dgGeol.RowCount - 1 do
  begin
    // if a geologic unit is simulated, add the vertical discretization of
    // that unit to the total.
    if Simulated(UnitIndex) then
    begin
      result := result + StrToInt(dgGeol.Cells
        [Ord(nuiVertDisc), UnitIndex]);
    end;
  end;
end;

{function TfrmMODFLOW.GetMFLayerStructure : TMFLayerStructure;
begin
  // called by CreateGeologicLayer;
  // called by AssociateUnits
  // called by AssociateTimes
  // called by InsertTimeParameters
  // called by cbRCHClick
  // called by cbRIVClick
  // called by cbWELClick
  // called by cbDRNClick
  // called by cbGHBClick
  // called by cbEVTClick
  // called by cbMOC3DClick
  // called by btnInsertUnitClick
  // called by FormDestroy
  // called by cbSTRClick
  // called by cbStreamCalcFlowClick
  // called by cbStreamTribClick
  // called by cbStreamDiversionsClick
  // called by cbHFBClick
  // called by cbFHBClick
  // called by adeFHBNumTimesExit
  // called by adeMODPATHMaxReleaseTimeExit
  // called by cbZonebudgetClick

  // This virtual function returns the layer structure of the model.
  // It may be overriden in descendents.
  result := MFLayerStructure;
end; }

procedure TfrmMODFLOW.DeleteTimeParameters(Position: Integer);
var
  ListOfParameterLists: TList;
  AParameterList: T_ANE_IndexedParameterList;
  ParameterListIndex: integer;
begin
  // called by edNumPerExit
  // called by btnDeleteTimeClick

  // a list of time-related parameter lists is stored in the objects
  // property of the first column of the dgTime grid.
  // Calling this function, causes all those parameter lists and the
  // parameters they hold them to have their status set
  // to sDeleted.
  // This procedure may be overriden in descendents.

  // Get the list of parameter lists for the appropriate time step.
  ListOfParameterLists := dgTime.Objects[0, Position] as TList;

  // loop over all the parameter lists and delete them.
  for ParameterListIndex := ListOfParameterLists.Count - 1 downto 0 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    if AParameterList <> nil then
    begin
      AParameterList.DeleteSelf;
    end;
  end;

  // Free the list of parameter lists.
  ListOfParameterLists.Free;

  // reset the objects property of the appropriate cell to nil.
  dgTime.Objects[0, Position] := nil;
end;

procedure TfrmMODFLOW.CreateGeologicLayer(Position: integer);
var
  AMFGridLayer: T_ANE_GridLayer;
  ALayerList: T_ANE_LayerList;
begin
  // called by edNumUnitsExit;
  // called by btnInsertUnitClick;

  // create the information layers for a new geologic unit at the
  // appropriate position.

  ModflowTypes.GetGeologicUnitType.Create
    (MFLayerStructure.ListsOfIndexedLayers, Position);

  if cbLak.Checked then
  begin
    ALayerList := MFLayerStructure.FirstListsOfIndexedLayers.
      Items[Ord(lgLakeLeakance)];

    ModflowTypes.GetMFLakeLeakanceLayerType.Create
      (ALayerList, Position);
  end;

  // get the grid layer.
  AMFGridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
    (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

  // create grid parameters for a new geologic unit in the grid layer at the
  // appropriate position.
  ModflowTypes.GetMFGeologicUnitParametersType.Create
    ((AMFGridLayer as ModflowTypes.GetGridLayerType).IndexedParamList1,
    Position);
end;

procedure TfrmMODFLOW.DeleteGeologicLayer(Position: integer);
var
  UnitParamIndex: integer;
  AGeologicUnitParameters: T_ANE_IndexedParameterList;
  AGeologicUnit: T_ANE_IndexedLayerList;
  AUnitParamList: TList;
  ALayerList: T_ANE_LayerList;
  ALeakanceLayer: T_ANE_MapsLayer;
begin
  // called by edNumUnitsExit;
  // called by btnDeleteUnitClick

  // get the geologic unit.
  AGeologicUnit := GeologicUnitsList.Items[Position];

  // set the status of the geologic unit and all its layers to sDeleted.
  (AGeologicUnit as ModflowTypes.GetGeologicUnitType).DeleteSelf;

  if cbLAK.Checked then
  begin
    ALayerList := MFLayerStructure.FirstListsOfIndexedLayers.
      Items[Ord(lgLakeLeakance)];

    ALeakanceLayer := ALayerList.GetNonDeletedLayerByIndex(Position);
    ALeakanceLayer.Delete;
  end;

  // get the list of parameterslists related to geologic units
  AUnitParamList := GeologicUnitParametersList.Items[Position];

  // loop over the lists of parameter lists and set the status of
  // the parameterlists and the parameters they contain to sDeleted.
  for UnitParamIndex := AUnitParamList.Count - 1 downto 0 do
  begin
    AGeologicUnitParameters := AUnitParamList.Items[UnitParamIndex];
    if (AGeologicUnitParameters <> nil)
      {and (AGeologicUnitParameters is ModflowTypes.GetMFGeologicUnitParametersType)}then
    begin
      (AGeologicUnitParameters as ModflowTypes.GetMFGeologicUnitParametersType).
        DeleteSelf;
    end;
  end;
end;

procedure TfrmMODFLOW.InitializeGrids;
var
  RowIndex: integer;
  ColIndex: integer;
begin
  // called by FormCreate
  // called by GLoadForm

  // Initialize the titles of dgTime
  dgTime.Cells[Ord(tdN), 0] := rsN;
  dgTime.Cells[Ord(tdLength), 0] := rsLength;
  dgTime.Cells[Ord(tdNumSteps), 0] := rsNumSteps;
  dgTime.Cells[Ord(tdMult), 0] := rsMult;
  dgTime.Cells[Ord(tdFirstStep), 0] := rsFirstStep;
  for RowIndex := 1 to dgTime.RowCount - 1 do
  begin
    dgTime.Cells[Ord(tdN), RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgMOC3DParticles
  sgMOC3DParticles.Cells[Ord(pdN), 0] := rsN;
  sgMOC3DParticles.Cells[Ord(pdLayer), 0] := rsLayer;
  sgMOC3DParticles.Cells[Ord(pdRow), 0] := rsRow;
  sgMOC3DParticles.Cells[Ord(pdColumn), 0] := rsColumn;
  for RowIndex := 1 to sgMOC3DParticles.RowCount - 1 do
  begin
    sgMOC3DParticles.Cells[Ord(pdN), RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgMOC3DTransParam
  sgMOC3DTransParam.Cells[Ord(trdN), 0] := rsN;
  sgMOC3DTransParam.Cells[Ord(trdLong), 0] := rsLongDisp;
  sgMOC3DTransParam.Cells[Ord(trdTranHor), 0] := rsTransHorDisp;
  sgMOC3DTransParam.Cells[Ord(trdTranVer), 0] := rsTransVerDisp;
  sgMOC3DTransParam.Cells[Ord(trdRetard), 0] := rsRetard;
  sgMOC3DTransParam.Cells[Ord(trdConc), 0] := rsConc;
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    sgMOC3DTransParam.Cells[Ord(trdN), RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgFHBTimes
  sgFHBTimes.Cells[1, 0] := 'Time';
  sgFHBTimes.Cells[1, 1] := '0';
  for RowIndex := 1 to sgFHBTimes.RowCount - 1 do
  begin
    sgFHBTimes.Cells[0, RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgZoneBudCompZones
  for RowIndex := 1 to sgZoneBudCompZones.RowCount do
  begin
    sgZoneBudCompZones.Cells[0, RowIndex - 1] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgZondbudTimes
  sgZondbudTimes.ColCount := 3;
  for RowIndex := 1 to sgZondbudTimes.RowCount - 1 do
  begin
    sgZondbudTimes.Cells[0, RowIndex] := IntToStr(RowIndex);
  end;
  sgZondbudTimes.Cells[0, 0] := rsN;
  sgZondbudTimes.Cells[1, 0] := rsStressPeriod;
  sgZondbudTimes.Cells[2, 0] := rsTimeStep;

  // Initialize the titles of sgMODPATHOutputTimes
  for RowIndex := 1 to sgMODPATHOutputTimes.RowCount - 1 do
  begin
    sgMODPATHOutputTimes.Cells[0, RowIndex] := IntToStr(RowIndex);
  end;
  sgMODPATHOutputTimes.Cells[1, 0] := rsTime;
  sgMODPATHOutputTimes.Cells[0, 0] := rsN;

  // Initialize the titles of dgGeol
  for RowIndex := 1 to dgGeol.RowCount - 1 do
  begin
    dgGeol.Cells[0, RowIndex] := IntToStr(RowIndex);
  end;
  for ColIndex := 0 to dgGeol.ColCount - 1 do
  begin
    dgGeol.Cells[ColIndex, 0] := dgGeol.Columns[ColIndex].Title.Caption;
  end;

  adeGHBObsBoundCountExit(adeGHBObsBoundCount);

  // MT3D
  sgMT3DTime.Cells[Ord(tdmN), 0] := rsN;
  sgMT3DTime.Cells[Ord(tdmLength), 0] := rsLength;
  sgMT3DTime.Cells[Ord(tdmStepSize), 0] := rsTransStep;
  sgMT3DTime.Cells[Ord(tdmMaxSteps), 0] := rsMaxTransStep;
  sgMT3DTime.Cells[Ord(tdmCalculated), 0] := rsTranCalculated;
  sgMT3DTime.Cells[Ord(tdmMult), 0] := rsTimeStepMultiplier;
  sgMT3DTime.Cells[Ord(tdmMax), 0] := rsTimeStepMax;

  for RowIndex := 1 to sgMT3DTime.RowCount - 1 do
  begin
    sgMT3DTime.Cells[Ord(tdmN), RowIndex] := IntToStr(RowIndex);
  end;

  sgDispersion.RowCount := dgGeol.RowCount;
  sgReaction.RowCount := dgGeol.RowCount;

  sgDispersion.Cells[Ord(ddmN), 0] := rsN;
  sgDispersion.Cells[Ord(ddmName), 0] := rsName;
  sgDispersion.Cells[Ord(ddmHorDisp), 0] := rsHorzDispRatio;
  sgDispersion.Cells[Ord(ddmVertDisp), 0] := rsVertDispRatio;
  sgDispersion.Cells[Ord(ddmMolDiffCoef), 0] := rsMolDifCoef;

  for RowIndex := 1 to sgDispersion.RowCount - 1 do
  begin
    sgDispersion.Cells[Ord(ddmN), RowIndex] := IntToStr(RowIndex);
    sgDispersion.Cells[Ord(ddmName), RowIndex] := dgGeol.Cells[Ord(nuiName),
      RowIndex]
  end;

  sgReaction.Cells[Ord(rdmN), 0] := rsN;
  sgReaction.Cells[Ord(ddmName), 0] := rsName;
  sgReaction.Cells[Ord(rdmBulkDensity), 0] := rsBulkDensity;
  sgReaction.Cells[Ord(rdmSorpConst1), 0] := rsSorpConst1;
  sgReaction.Cells[Ord(rdmSorpConst2), 0] := rsSorpConst2;
  sgReaction.Cells[Ord(rdmRateConstDiss), 0] := rsRateConstDis;
  sgReaction.Cells[Ord(rdmRateConstSorp), 0] := rsRateConstSorb;
  sgReaction.Cells[Ord(rdmDualPorosity), 0] := rsDualDomainPorosity;
  sgReaction.Cells[Ord(rdmStartingConcentration), 0] := rsStartingConcentration;

  for RowIndex := 1 to sgReaction.RowCount - 1 do
  begin
    sgReaction.Cells[Ord(rdmN), RowIndex] := IntToStr(RowIndex);
    sgReaction.Cells[Ord(rdmName), RowIndex] := dgGeol.Cells[Ord(nuiName),
      RowIndex]
  end;

  sgPrintoutTimes.Cells[Ord(ptmN), 0] := rsN;
  sgPrintoutTimes.Cells[Ord(ptmTime), 0] := rsTime;
  for RowIndex := 1 to sgPrintoutTimes.RowCount - 1 do
  begin
    sgPrintoutTimes.Cells[Ord(ptmN), RowIndex] := IntToStr(RowIndex);
  end;

end;

procedure TfrmMODFLOW.SetCBoundNeeded;
var
  GridLayerHandle: ANE_PTR;
  NRow, NCol: ANE_INT32;
  MinX, MaxX, MinY, MaxY, GridAngle: ANE_DOUBLE;
  //  SubGridHandle : ANE_PTR;
  SubGridLayer: T_ANE_MapsLayer;
begin
  // called by sgMOC3DTransParamSelectCell;
  // called by sgMOC3DTransParamDrawCell;
  if NewModel then
  begin
    CBNeeded := False;
  end
  else
  begin
    // return true if CBOUND is needed for a particular geologic unit.
    SubGridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName);

    if SubGridLayer = nil then
    begin
      CBNeeded := False;
    end
    else
    begin
      SubGridLayer.FixLayer(CurrentModelHandle);

      if SubGridLayer.Status = sNew then
      begin
        CBNeeded := False;
      end
      else
      begin
        GetGrid(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
          GridLayerHandle, NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);

        if GridLayerHandle = nil then
        begin
          CBNeeded := False;
        end
        else
        begin
          CBNeeded := (fMOCROW1(CurrentModelHandle, GridLayerHandle, NRow) <> 1)
            or (fMOCROW2(CurrentModelHandle, GridLayerHandle, NRow) <> NRow)
            or (fMOCCOL1(CurrentModelHandle, GridLayerHandle, NCol) <> 1)
            or (fMOCCOL2(CurrentModelHandle, GridLayerHandle, NCol) <> NCol);
        end;
      end;
    end;
  end;
  Enable_cbCBDY;
end;

function TfrmMODFLOW.CBoundNeeded(GeolUnit: Integer): boolean;
var
//  GridLayerHandle: ANE_PTR;
//  NRow, NCol: ANE_INT32;
//  MinX, MaxX, MinY, MaxY, GridAngle: ANE_DOUBLE;
  //  SubGridHandle : ANE_PTR;
  SubGridLayer: T_ANE_MapsLayer;
  LastUnit: integer;
begin
  // called by sgMOC3DTransParamSelectCell;
  // called by sgMOC3DTransParamDrawCell;

  result := not NewModel;
  if result then
  begin
    // return true if CBOUND is needed for a particular geologic unit.
    SubGridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName);

    if SubGridLayer = nil then
    begin
      result := False;
    end
    else
    begin
      SubGridLayer.FixLayer(CurrentModelHandle);

      if SubGridLayer.Status = sNew then
      begin
        result := False;
      end
      else
      begin
//        GetGrid(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
//          GridLayerHandle, NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);

        result := CBNeeded and not cbCBDY.Checked;
        if result then
        begin

          if result then
          begin
            LastUnit := StrToInt(adeMOC3DLay2.Text);
            if LastUnit = -1 then Exit;
              result := (GeolUnit <= LastUnit + 1);
          end;
        end
        else
        begin
          result := not cbCBDY.Checked;
          if result then
          begin
            result := (GeolUnit = StrToInt(adeMOC3DLay1.Text) - 1);
            if not result then
            begin
              LastUnit := StrToInt(adeMOC3DLay2.Text);
              if LastUnit = -1 then
                Exit;
              result := (GeolUnit = LastUnit + 1);
            end;
          end;
        end;
      end;
    end;
  end
  else
  begin
    result := not cbCBDY.Checked and
      ((GeolUnit = StrToInt(adeMOC3DLay1.Text) - 1)
      or (GeolUnit = StrToInt(adeMOC3DLay2.Text) + 1));
  end;
end;

procedure TfrmMODFLOW.AssociateUnits;
var
  GeolUnitIndex: Integer;
  AGeologicUnit: T_ANE_IndexedLayerList;
  AParameterList: TList;
  ParameterListIndex, ParameterIndex: integer;
  AParamList: T_ANE_IndexedParameterList;
  Index: integer;
begin
  // called by edNumUnitsExit;
  // called by btnInsertUnitClick
  // called by btnDeleteUnitClick
  // called by GProjectNew in ProjectFunctions
  // called by GLoadForm in ProjectFunctions
  // called by btnOpenValClick

  // Free the list of layer-lists and the list of parameter-lists
  GeologicUnitsList.Free;

  if GeologicUnitParametersList <> nil then
  begin
    for Index := 0 to GeologicUnitParametersList.Count - 1 do
    begin
      AParameterList := GeologicUnitParametersList[Index];
      AParameterList.Free;
    end;
  end;

  GeologicUnitParametersList.Free;

  // create a new list of layer-lists
  GeologicUnitsList := TList.Create;

  // Add geologic units whose status is not sDeleted to te list of layer-lists
  for GeolUnitIndex := 0 to StrToInt(edNumUnits.Text) - 1 do
  begin
    AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
      GetNonDeletedIndLayerListByIndex(GeolUnitIndex)
      as ModflowTypes.GetGeologicUnitType;

    GeologicUnitsList.Add(AGeologicUnit);
  end;

  // create a new list of parameter-lists that are related to a geologic unit.
  // By convention, ParameterList1 is used for parameter lists related to
  // geologic units
  GeologicUnitParametersList
    := MFLayerStructure.MakeParameter1Lists(StrToInt(edNumUnits.Text));

  // certain other parameterlist types are also in ParameterList1 and
  // must be removed.
  for ParameterListIndex := 0 to GeologicUnitParametersList.Count - 1 do
  begin
    AParameterList := GeologicUnitParametersList.Items[ParameterListIndex];

    //    if (ParameterListIndex < MaxObsWellParameters) then
    begin
      for ParameterIndex := AParameterList.Count - 1 downto 0 do
      begin
        AParamList := AParameterList.Items[ParameterIndex];
        if (AParamList is ModflowTypes.GetMOCElevParamListType) or
          (AParamList is ModflowTypes.GetMFFHBPointTimeParamListType) or
          (AParamList is ModflowTypes.GetMFFHBLineTimeParamListType) or
          (AParamList is ModflowTypes.GetMFFHBAreaTimeParamListType) or
          (AParamList is ModflowTypes.GetMFMODPATHTimeParamListType) or
          (AParamList is ModflowTypes.GetMOCElevParamListType) or
          (AParamList is ModflowTypes.GetMF2KStreamCrossSectionParamListType) or
          (AParamList is ModflowTypes.GetMF2KStreamTableParamListType) or
          (AParamList is ModflowTypes.GetMFMODPATHTimeParamListType) or
          (AParamList is ModflowTypes.GetMFHeadObservationParamListType) then
        begin
          AParameterList.Delete(ParameterIndex);
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.AssociateTimes;
var
  ListOfParameterLists: TList;
  AParameterList: TList;
  ParameterListIndex: integer;
begin
  // called by cbRCHClick
  // called by cbRIVClick
  // called by cbWELClick
  // called by cbDRNClick
  // called by cbGHBClick
  // called by cbEVTClick
  // called by cbMOC3DClick
  // called by edNumPerExit
  // called by btnInsertTimeClick
  // called by btnDeleteTimeClick
  // called by cbSTRClick
  // called by cbStreamCalcFlowClick
  // called by cbStreamTribClick
  // called by cbStreamDiversionsClick
  // called by cbMODPATHClick
  // called by btnOpenValClick
  // called by GProjectNew in ProjectFunctions
  // called by GLoadForm in ProjectFunctions
  // called by GLoadForm in ProjectFunctions

  // This procedure associates lists of time-related parameters with
  // dgTime grid.

  // First get rid of all the existing lists of parameter lists.
  for ParameterListIndex := 1 to dgTime.RowCount - 1 do
  begin
    AParameterList := dgTime.Objects[0, ParameterListIndex] as TList;
    AParameterList.Free;
    dgTime.Objects[0, ParameterListIndex] := nil;
  end;

  // create new lists of parameter-lists.
  ListOfParameterLists
    := MFLayerStructure.MakeParameter2Lists(dgTime.RowCount - 1);

  // put those lists in the objects property of dgTime
  for ParameterListIndex := 0 to ListOfParameterLists.Count - 1 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    dgTime.Objects[0, ParameterListIndex + 1] := AParameterList;
  end;

  // get rid of the list of parameter-lists.
  ListOfParameterLists.Free;
end;

procedure TfrmMODFLOW.InsertTimeParameters(Position: integer);
var
  ALayerList: T_ANE_IndexedLayerList;
  Index: Integer;
  ALeakanceLayer: T_ANE_Layer;
begin
  // called by edNumPerExit
  // called by btnInsertTimeClick

  // create the time parameters at Position for the recharge layer
  if cbRCH.Checked then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetRechargeLayerType,
      ModflowTypes.GetMFRechElevParamListType, Position);
  end;

  // create the time parameters at Position for the
  // recharge concentration layer
  if cbRCH.Checked and (cbMOC3D.Checked or
    (cbMT3D.Checked and cbSSM.Checked)) then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMOCRechargeConcLayerType,
      ModflowTypes.GetMOCRechargeConcTimeParamListType, Position);
  end;

  // create the time parameters at Position for the
  // evapotranspiration layer
  if cbEVT.Checked then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetETLayerType,
      ModflowTypes.GetETTimeParamListType, Position);
  end;

  if cbETS.Checked then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFSegmentedETLayerType,
      ModflowTypes.GetMFSegETTimeParamListType, Position);
  end;

  if cbRES.Checked then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFReservoirLayerType,
      ModflowTypes.GetMFReservoirTimeParamListType, Position);
  end;

  // create the time parameters at Position for the
  // well layers
  if cbWEL.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFWellLayerType,
      ModflowTypes.GetMFWellTimeParamListType, Position);
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFLineWellLayerType,
      ModflowTypes.GetMFLineAreaWellTimeParamListType, Position);
    if cbUseAreaWells.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaWellLayerType,
        ModflowTypes.GetMFLineAreaWellTimeParamListType, Position);
    end;
  end;

  // create the time parameters at Position for the
  // river layers
  if cbRIV.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFPointRiverLayerType,
      ModflowTypes.GetMFRiverTimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFLineRiverLayerType,
      ModflowTypes.GetMFRiverTimeParamListType, Position);

    if cbUseAreaRivers.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaRiverLayerType,
        ModflowTypes.GetMFRiverTimeParamListType, Position);
    end;
  end;

  // create the time parameters at Position for the
  // drain layers
  if cbDRN.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFPointDrainLayerType,
      ModflowTypes.GetMFDrainTimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetLineDrainLayerType,
      ModflowTypes.GetMFDrainTimeParamListType, Position);

    if cbUseAreaDrains.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetAreaDrainLayerType,
        ModflowTypes.GetMFDrainTimeParamListType, Position);
    end;
  end;

  if cbDRT.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFPointDrainReturnLayerType,
      ModflowTypes.GetMFDrainReturnTimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFLineDrainReturnLayerType,
      ModflowTypes.GetMFDrainReturnTimeParamListType, Position);

    if cbUseAreaDrainReturns.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaDrainReturnLayerType,
        ModflowTypes.GetMFDrainReturnTimeParamListType, Position);
    end;
  end;

  // create the time parameters at Position for the
  // general-head boundary layers
  if cbGHB.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetPointGHBLayerType,
      ModflowTypes.GetGHBTimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetLineGHBLayerType,
      ModflowTypes.GetGHBTimeParamListType, Position);

    if cbUseAreaGHBs.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetAreaGHBLayerType,
        ModflowTypes.GetGHBTimeParamListType, Position);
    end;
  end;

  // create the time parameters at Position for the
  // general-head boundary layers
  if cbFHB.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFPointFHBLayerType,
      ModflowTypes.GetMFFHBMT3DConcTimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFLineFHBLayerType,
      ModflowTypes.GetMFFHBMT3DConcTimeParamListType, Position);

    if cbUseAreaFHBs.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaFHBLayerType,
        ModflowTypes.GetMFFHBMT3DConcTimeParamListType, Position);
    end;
  end;

  // create the time parameters at Position for the
  // stream layers
  if cbSTR.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFStreamLayerType,
      ModflowTypes.GetMFStreamTimeParamListType, Position);
  end;

  if cbSFR.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMF2KSimpleStreamLayerType,
      ModflowTypes.GetMF2KSimpleStreamTimeParamListType, Position);

    if cbSFRCalcFlow.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMF2K8PointChannelStreamLayerType,
        ModflowTypes.GetMF2K8PointChannelStreamTimeParamListType, Position);

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMF2KFormulaStreamLayerType,
        ModflowTypes.GetMF2KStreamFormulaTimeParamListType, Position);

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMF2KTableStreamLayerType,
        ModflowTypes.GetMF2KTableStreamTimeParamListType, Position);
    end;
  end;

  if cbUZF.Checked then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFUzfFlowLayerType,
      ModflowTypes.GetMFUzfTimeParamListType, Position);
  end;

  // create the time parameters at Position for the
  // lake layers
  if cbLAK.Checked then
  begin
    MFLayerStructure.UnIndexedLayers3.MakeIndexedList2(
      ModflowTypes.GetMFLakeLayerType,
      ModflowTypes.GetMFLakeTimeParamListType, Position);

    if comboLakSteadyLeakance.ItemIndex = 1 then
    begin
      ALayerList := MFLayerStructure.FirstListsOfIndexedLayers.
        Items[Ord(lgLakeLeakance)];

      for Index := 0 to StrToInt(edNumUnits.Text) - 1 do
      begin
        if Index < ALayerList.Count then
        begin
          ALeakanceLayer := ALayerList.Items[Index] as T_ANE_Layer;
          ModflowTypes.GetMFLeakConductanceParamListType.Create(
            ALeakanceLayer.IndexedParamList2, Position);
        end;
      end;
//
//      ALayerList.MakeIndexedList2(
//        ModflowTypes.GetMFLakeLeakanceLayerType,
//        ModflowTypes.GetMFLeakConductanceParamListType, Position);
    end;
  end;

  if cbCHD.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFPointLineCHD_LayerType,
      ModflowTypes.GetMFCHD_TimeParamListType, Position);
    if cbUseAreaCHD.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaCHD_LayerType,
        ModflowTypes.GetMFCHD_TimeParamListType, Position);
    end;
  end;

  if cbMOC3D.Checked and cbDualPorosity.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFMOCLinExchCoefLayerType,
      ModflowTypes.GetMFMOCLinExchCoefTimeParamListType, Position);

    if cbIDPFO.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMOCDecayCoefLayerType,
        ModflowTypes.GetMFMOCDecayCoefTimeParamListType, Position);

    end;

    if cbIDPZO.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMOCGrowthLayerType,
        ModflowTypes.GetMFMOCGrowthTimeParamListType, Position);

    end;
  end;
  if cbMOC3D.Checked and cbSimpleReactions.Checked then
  begin
    if cbIDKFO.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMOCDisDecayCoefLayerType,
        ModflowTypes.GetMFMOCDisDecayCoefTimeParamListType, Position);
    end;

    if cbIDKFS.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
        ModflowTypes.GetMFMOCSorbDecayCoefTimeParamListType, Position);
    end;

    if cbIDKZO.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMOCDisGrowthLayerType,
        ModflowTypes.GetMFMOCDisGrowthTimeParamListType, Position);
    end;

    if cbIDKZS.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMOCSorbGrowthLayerType,
        ModflowTypes.GetMFMOCSorbGrowthTimeParamListType, Position);
    end;

  end;

//  if cbMT3D.Checked and cbSSM.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetPrescribedHeadLayerType,
      ModflowTypes.GetMT3DPrescribedHeadTimeParamListType, Position);
    if cbMT3D.Checked and cbSSM.Checked and cbMT3D_TVC.Checked then
    begin
      {
            MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
              ModflowTypes.GetMT3DPointTimeVaryConcLayerType,
              ModflowTypes.GetMT3DTimeVaryConcTimeParamListType, Position);
      }
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMT3DAreaTimeVaryConcLayerType,
        ModflowTypes.GetMT3DTimeVaryConcTimeParamListType, Position);
    end;
    if cbMT3D.Checked and cbSSM.Checked and cbMT3DMassFlux.Checked then
    begin

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMT3DMassFluxLayerType,
        ModflowTypes.GetMT3DMassFluxTimeParamListType, Position);
    end;
  end;

  if cbMNW.Checked then
  begin
    MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFMNW_LayerType,
      ModflowTypes.GetMFMNW_TimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFMNW_WaterQualityLayerType,
      ModflowTypes.GetMFMNW_WaterQualityTimeParamListType, Position);
  end;

  if cbMnw2.Checked then
  begin
    if rgMnw2WellType.ItemIndex in [0,2] then
    begin
      MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMNW2_VerticalWellLayerType,
        ModflowTypes.GetMFMNW2_TimeParamListType, Position);
    end;

    if rgMnw2WellType.ItemIndex in [1,2] then
    begin
      MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFMNW2_GeneralWellLayerType,
        ModflowTypes.GetMFMNW2_TimeParamListType, Position);
    end;
  end;

  if ModflowTypes.GetFluidDensityLayerType.LayerUsed then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetFluidDensityLayerType,
      ModflowTypes.GetMFFluidDensityTimeParamListType, Position);
  end;

  if ModflowTypes.GetMFViscosityLayerType.LayerUsed then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFViscosityLayerType,
      ModflowTypes.GetMFViscosityParamListType, Position);
  end;

  if cb_GWM.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFFluxVariableLayerType,
      ModflowTypes.GetMFGWM_TimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFHeadConstraintLayerType,
      ModflowTypes.GetMFGWM_TimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFDrawdownConstraintLayerType,
      ModflowTypes.GetMFGWM_TimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFHeadDifferenceLayerType,
      ModflowTypes.GetMFGWM_TimeParamListType, Position);

    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetMFGradientLayerType,
      ModflowTypes.GetMFGWM_TimeParamListType, Position);

    if cbSTR.Checked or cbSFR.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFStreamConstraintLayerType,
        ModflowTypes.GetMFGWM_TimeParamListType, Position);

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFStreamDepletionConstraintLayerType,
        ModflowTypes.GetMFGWM_TimeParamListType, Position);
    end;
  end;

  if cbMOC3D.Checked and cbCCBD.Checked then
  begin
    MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
      ModflowTypes.GetGWT_TimeVaryConcLayerType,
      ModflowTypes.GetGWT_TimeVaryConcTimeParamList, Position);
  end;
end;

function HelpFileFullPath(const FileName: string): string;
var
  DllDirectory : String;
begin
  result := '';
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      result := DllDirectory + '\' + FileName;
      if not FileExists(result) then
      begin
        Beep;
        ShowMessage(result + ' not found.');
      end;
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

Procedure InitializeHTMLHELP;
begin
  if mHHelp = nil then
  begin
    LoadHtmlHelp;
    mHHelp := THookHelpSystem.Create(HelpFileFullPath('MODFLOW.chm'), '', htHHexe);
  end;
end;

procedure TfrmMODFLOW.ReadOldTheta(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
var
  AText: string;
  AFloat: double;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AFloat := InternationalStrToFloat(AText);
  if AFloat < 0.5 then
  begin
    adeLakTheta.Text := '0.5';
  end
  else
  begin
    adeLakTheta.Text := AText;
  end
end;

procedure TfrmMODFLOW.SetVersionCaption;
begin
  lblVersion.Caption := FileVersion(DllName);
end;

procedure TfrmMODFLOW.FormCreate(Sender: TObject);
var
  RowIndex, ColIndex: integer;
  TimeColIndex: timeData;
  fileName: string;
  OldGeolGrid: TSpecialHandlingObject;
  OldIDIREC: TSpecialHandlingObject;
  EPSSLV: TSpecialHandlingObject;
  CTHOCH: TSpecialHandlingObject;
  sgTimeGrid: TSpecialHandlingObject;
  OldProgramChoice: TSpecialHandlingObject;
  OldCheckModPathData: TSpecialHandlingObject;
  TimeVarDoublePorosity, TimeVarReactions: TSpecialHandlingObject;
  AString: string;
  //  FullPath : string;
  //  AnInt : NewUnitData;
  //  newDataGrid : TSpecialHandlingObject;
  OldGeolContGrid: TSpecialHandlingObject;

  OldStream: TSpecialHandlingObject;
  OldStreamDiv: TSpecialHandlingObject;
  OldStreamICALC: TSpecialHandlingObject;
  OldStreamModelUnits: TSpecialHandlingObject;
  OldStreamSteady: TSpecialHandlingObject;
  OldStreamTrib: TSpecialHandlingObject;
  OldStreamPrintFlows: TSpecialHandlingObject;

  SubFormat: string;
  AChar: Char;

begin
  MonitoringWellNameFileLines := TStringList.Create;
  InitializeHTMLHELP;

  Application.HintHidePause := 5000;
  pgcAbout.ActivePageIndex := 0;

//  AssignHelpFile('MODFLOW.chm');

  MultiNodeWellNames := TStringList.Create;
  MultiNodeWellNames.Sorted := True;
  MultiNodeWellNames.Duplicates := dupIgnore;

  btnImportFlowVar1.Parent := frameGWM_Binary.pnlBottom;
  btnImportFlowVar1.Top := frameGWM_Binary.btnDelete.Top;

  btnImportFlowVar3.Parent := frameGWM_CombinedConstraints.pnlBottom;
  btnImportFlowVar3.Top := frameGWM_CombinedConstraints.btnDelete.Top;
  btnImportFlowVar3.Left := frameGWM_CombinedConstraints.btnDelete.Left
    + frameGWM_CombinedConstraints.btnDelete.Width + 8;

  LengthUnit := 'L';
  TimeUnit := 'T';
  MT3DMassUnit := 'kg';
{$IFDEF Debug}
  WriteDebugOutput('Enter: procedure TfrmMODFLOW.FormCreate');
{$ENDIF}
  // triggering events: frmMODFLOW.OnCreate;
  inherited;
  sgMT3DTime.Col := 3;
  sgReaction.Col := 2;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  NextUnitNumber := 7; // 1-4 used by SEAWAT, 5-6 are standard input and output.
    // MT3D reserves units 1 to 20.
  framHUF1.InitializeGrid;
  FreeFormResources(self);
  FormHeight := Height;
  FormWidth := Width;
  NewModel := False;
  OldHufNames := TStringList.Create;
  NewHufNames := TStringList.Create;
  HufLVDA_Units := TStringList.Create;
  //  AnInt := ;
  //  Assert(False);
  UnitNumberStringList := TStringList.Create;
  OldParamNames := TStringList.Create;
  GeologyRow := 1;
  SettingMode := False;
  SensitivityNames := TStringList.Create;
  LastInstanceCountStringList := TStringList.Create;
  Loading := True;

  PIEDeveloper := 'Richard B. Winston, rbwinst@usgs.gov';

  SetVersionCaption;
//  VersionInfo1.FileName := DllName;
//  lblVersion.Caption := VersionInfo1.FileVersion;

  OldVersionControlName.Add('verLabel');

  //  NewModel := False;
  NeedToUpdateMOC3DSubgrid := False;

  OldMultiplierNames := TStringList.Create;
  OldZoneNames := TStringList.Create;

  SpecialHandlingList := TSpecialHandlingList.Create;

  OldGeolGrid := TSpecialHandlingObject.Create('dtabGeol', ReadOldGeoData);
  SpecialHandlingList.Add(OldGeolGrid);

  OldIDIREC := TSpecialHandlingObject.Create('adeMOCDirInd', ReadOldIDIREC);
  SpecialHandlingList.Add(OldIDIREC);

  EPSSLV := TSpecialHandlingObject.Create('adeMOCTolerance', ReadEPSSLV);
  SpecialHandlingList.Add(EPSSLV);

  CTHOCH := TSpecialHandlingObject.Create('adeMiscOption', ReadCTOCH);
  SpecialHandlingList.Add(CTHOCH);

  sgTimeGrid := TSpecialHandlingObject.Create('sgTime', ReadOldTimeData);
  SpecialHandlingList.Add(sgTimeGrid);

  TimeVarDoublePorosity := TSpecialHandlingObject.Create('cbIDPTIM',
    ReadOld_IDPTIM);
  SpecialHandlingList.Add(TimeVarDoublePorosity);

  TimeVarReactions := TSpecialHandlingObject.Create('cbIDKTIM', ReadOld_IDKTIM);
  SpecialHandlingList.Add(TimeVarReactions);

  OldProgramChoice := TSpecialHandlingObject.Create('cbModflow2000',
    ReadOldProgramChoice);
  SpecialHandlingList.Add(OldProgramChoice);

  OldCheckModPathData := TSpecialHandlingObject.Create('cbMPathCheck',
    ReadOldCheckDataCheckBox);
  SpecialHandlingList.Add(OldCheckModPathData);

//  SpecialHandlingList.Add(TSpecialHandlingObject.Create('cbExpGAG',
//    ReadOldCheckDataCheckBox));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('cbWeightedParticles',
    ReadOldCheckDataCheckBox));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgRIVParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgWELParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgGHBParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgDRNParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgDRTParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgSTRParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgSFRParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgRCHParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgEVTParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('dgETSParameters',
    ReadOldParamGrids));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('edMT3DLength',
    ReadOldedMT3DLength));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('adeMT3DParticleMult',
    ReadOldedMT3DLength));
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('cbPrintLinkFile',
    ReadOldedMT3DLength));
  SpecialHandlingList.Add (TSpecialHandlingObject.Create('adeLakTheta',
    ReadOldTheta));

  SpecialHandlingList.Add
    (TSpecialHandlingObject.Create('UnitNumbers', LoadUnitNumbers));

  // assign the function used to get the version of the PIE.
  GetVersion := GetPIEVersion;

  // assign the function used to determine whether the file that is
  // being read was created by a newer version of the PIE than the
  // PIE that is reading it.
  EarlierVersionInPIE := PieIsEarlier;

  // Check that the DLL name is found.
  if not GetDllFullPath(DLLName, fileName) then
  begin
    Beep;
    MessageDlg(fileName + ' not found.', mtError, [mbOK], 0);
  end;

  // If you read an old MOC3D model, you have to recalculate the
  // subgrid because the old version used row and column numbers rather
  // than distance. You don't need to do that for a new model.
  RecalculateSubgrid := False;

  // any controls whose Name's are in IgnoreList will not have their
  // properties saved when saving a file. The controls on Ignore list
  // are those that determine which model and package will be exported.
  // Thus those values are reset to their defaults when you open a file.
  IgnoreList.Add('rbRun');
  IgnoreList.Add('rbCreate');
  IgnoreList.Add('rbRunZonebudget');
  IgnoreList.Add('rbCreateZonebudget');
  IgnoreList.Add('rbMPATHRun');
  IgnoreList.Add('rbMPATHCreate');

  IgnoreList.Add('cbExpBAS');
  IgnoreList.Add('cbExpOC');
  IgnoreList.Add('cbExpBCF');
  IgnoreList.Add('cbExpLPF');
  IgnoreList.Add('cbExpRCH');
  IgnoreList.Add('cbExpRIV');
  IgnoreList.Add('cbExpWEL');
  IgnoreList.Add('cbExpDRN');
  IgnoreList.Add('cbExpGHB');
  IgnoreList.Add('cbExpEVT');
  IgnoreList.Add('cbExpHFB');
  IgnoreList.Add('cbExpFHB');
  IgnoreList.Add('cbExpStr');
  IgnoreList.Add('cbExpMatrix');
  IgnoreList.Add('cbExpCONC');
  IgnoreList.Add('cbExpOBS');
  IgnoreList.Add('cbExpDIS');
  IgnoreList.Add('cbExpMULT');
  IgnoreList.Add('cbExpZONE');
  IgnoreList.Add('cbHOB');
  IgnoreList.Add('cbGBOB');
  IgnoreList.Add('cbDROB');
  IgnoreList.Add('cbDTOB');
  IgnoreList.Add('cbRVOB');
  IgnoreList.Add('cbCHOB');
  IgnoreList.Add('cbADOB');
  IgnoreList.Add('cbSTOB');
  IgnoreList.Add('cbSEN');
  IgnoreList.Add('cbPESExport');
  IgnoreList.Add('cbShowWarnings');
  IgnoreList.Add('cbProgressBar');
  IgnoreList.Add('cbExpLAK');
  IgnoreList.Add('cbExpIBS');
  IgnoreList.Add('cbTips');
  IgnoreList.Add('cbExpETS');
  IgnoreList.Add('cbExpDRT');
  IgnoreList.Add('cbExpHYD');
  IgnoreList.Add('cbExpCHD');
  IgnoreList.Add('cbExpSfr');
  IgnoreList.Add('cbExpHUF');
  IgnoreList.Add('cbExpModelViewer');
  IgnoreList.Add('cbUseMT3D');
  IgnoreList.Add('cbFTI');
  IgnoreList.Add('cbExpMNW');
  IgnoreList.Add('cbExpMnw2');
  IgnoreList.Add('cbExpDAFLOW');
  IgnoreList.Add('cbExpBFLX');
  IgnoreList.Add('cbExpSub');
  IgnoreList.Add('cbExpSwt');
  IgnoreList.Add('cbExpVdf');
  IgnoreList.Add('rbRunSeawat');
  IgnoreList.Add('cbExpGAG');
  IgnoreList.Add('rbCreateSeaWat');
  IgnoreList.Add('cbExpIPDA');
  IgnoreList.Add('cbExpCBDY');
  IgnoreList.Add('cbGWM_DECVAR');
  IgnoreList.Add('cbGWM_OBJFNC');
  IgnoreList.Add('cbGWM_VARCON');
  IgnoreList.Add('cbGWM_SUMCON');
  IgnoreList.Add('cbGWM_HEDCON');
  IgnoreList.Add('cbGWM_STRMCON');
  IgnoreList.Add('cbGWM_SOLN');
  IgnoreList.Add('cbExpUZF');
  IgnoreList.Add('rbRunGWM');
  IgnoreList.Add('rbCreateGWM');
  IgnoreList.Add('cbExpVsc');
  IgnoreList.Add('cbExpSTAVAR');


  // GCG is now required for all MT3DMS models.
  IgnoreList.Add('cbGCG');

//  IgnoreList.Add('edCheckDate');
//  IgnoreList.Add('rgUpdateFrequency');

  // Also the list of references on the About tab is not saved.
  IgnoreList.Add('memoReferences');
  IgnoreList.Add('memoDisclaimer');

  // When reading a file, those controls whos names are on FirstList will
  // be read first. This is done because in a few cases, the order in which
  // data is read is important.
//  FirstList := TStringList.Create;
  FirstList.Add('edNumUnits');
  FirstList.Add('edNumPer');
  FirstList.Add('edMOC3DInitParticles');
  FirstList.Add('adeFHBNumTimes');

  FirstList.Add('adeLPFParamCount');
  FirstList.Add('adeHUFParamCount');
  FirstList.Add('adeMultCount');
  FirstList.Add('adeZoneCount');
  FirstList.Add('comboSteady');
  FirstList.Add('adeSensitivityCount');
  FirstList.Add('adeHufUnitCount');
  {$IFDEF GWM_State}
  FirstList.Add('rdeGwmStorageStateVarCount');
  FirstList.Add('rdeZoneCount');
  {$ENDIF}

  PageControlParameters.ActivePageIndex := 0;
  pageControlPackages.ActivePageIndex := 0;
  PageControlObservations.ActivePageIndex := 0;
  PageControlMOC3D.ActivePageIndex := 0;
  pagecontrolParamEst.ActivePageIndex := 0;
  PageControlSolvers.ActivePage := tabPCG2;
  pageControlModpath.ActivePageIndex := 0;
  PageControlMT3D.ActivePageIndex := 0;
  pcGWM.ActivePageIndex := 0;
  pcGWM_Solution.ActivePageIndex := 0;
  pcSeawat.ActivePageIndex := 0;

  // Initialize data in dgGeol

  dgGeol.Cells[Ord(nuiName), 1] := 'Top Aquifer';
  dgGeol.Cells[Ord(nuiName), 2] := 'Aquitard';
  dgGeol.Cells[Ord(nuiName), 3] := 'Bottom Aquifer';

  dgGeol.Cells[Ord(nuiSim), 1] := 'Yes';
  dgGeol.Cells[Ord(nuiSim), 2] := 'No';
  dgGeol.Cells[Ord(nuiSim), 3] := 'Yes';

  dgGeol.Cells[Ord(nuiTrans), 1] := 'Harmonic mean (0)';
  dgGeol.Cells[Ord(nuiTrans), 2] := 'Harmonic mean (0)';
  dgGeol.Cells[Ord(nuiTrans), 3] := 'Harmonic mean (0)';

  dgGeol.Cells[Ord(nuiType), 1] := 'Confined (0)';
  dgGeol.Cells[Ord(nuiType), 2] := 'Confined (0)';
  dgGeol.Cells[Ord(nuiType), 3] := 'Confined (0)';

  dgGeol.Cells[Ord(nuiAnis), 1] := '1';
  dgGeol.Cells[Ord(nuiAnis), 2] := '1';
  dgGeol.Cells[Ord(nuiAnis), 3] := '1';

  dgGeol.Cells[Ord(nuiVertDisc), 1] := '1';
  dgGeol.Cells[Ord(nuiVertDisc), 2] := '1';
  dgGeol.Cells[Ord(nuiVertDisc), 3] := '1';

  AString := dgGeol.Columns[Ord(nuiSpecT)].PickList[0];
  dgGeol.Cells[Ord(nuiSpecT), 1] := AString;
  dgGeol.Cells[Ord(nuiSpecT), 2] := AString;
  dgGeol.Cells[Ord(nuiSpecT), 3] := AString;

  AString := dgGeol.Columns[Ord(nuiSpecVCONT)].PickList[0];
  dgGeol.Cells[Ord(nuiSpecVCONT), 1] := AString;
  dgGeol.Cells[Ord(nuiSpecVCONT), 2] := AString;
  dgGeol.Cells[Ord(nuiSpecVCONT), 3] := AString;

  AString := dgGeol.Columns[Ord(nuiSpecSF1)].PickList[0];
  dgGeol.Cells[Ord(nuiSpecSF1), 1] := AString;
  dgGeol.Cells[Ord(nuiSpecSF1), 2] := AString;
  dgGeol.Cells[Ord(nuiSpecSF1), 3] := AString;

  AString := dgGeol.Columns[Ord(nuiSpecAnis)].PickList[0];
  dgGeol.Cells[Ord(nuiSpecAnis), 1] := AString;
  dgGeol.Cells[Ord(nuiSpecAnis), 2] := AString;
  dgGeol.Cells[Ord(nuiSpecAnis), 3] := AString;

  AString := dgGeol.Columns[Ord(nuiWettingActive)].PickList[1];
  dgGeol.Cells[Ord(nuiWettingActive), 1] := AString;
  dgGeol.Cells[Ord(nuiWettingActive), 2] := AString;
  dgGeol.Cells[Ord(nuiWettingActive), 3] := AString;

  rdgMt3dBinaryInitialConcFiles.BeginUpdate;
  try
    rdgMt3dBinaryInitialConcFiles.Cells[Ord(mbffFileName), 0] := 'MT3DMS Concentration File Name';
    AChar := 'A';
    for RowIndex := 1 to rdgMt3dBinaryInitialConcFiles.RowCount - 1 do
    begin
      rdgMt3dBinaryInitialConcFiles.Cells[Ord(mbffNone), RowIndex] := AChar;
      Inc(AChar);
    end;
    rdgMt3dBinaryInitialConcFiles.RowCount := 2;
  finally
    rdgMt3dBinaryInitialConcFiles.EndUpdate;
  end;

  rdgSWDensTable.ColWidths[0] := 10;
  rdgSWDensTable.ColWidths[1] := 90;
  rdgSWDensTable.ColWidths[3] := 130;
  rdgSWDensTable.Cells[0,0] := 'N';
  rdgSWDensTable.Cells[1,0] := 'MT3DMS species number';
  rdgSWDensTable.Cells[2,0] := 'Reference concentration';
  rdgSWDensTable.Cells[3,0] := 'Slope: fluid density to solute concentration';
  rdgSWDensTable.Cells[0,1] := '1';
  rdgSWDensTable.Cells[1,1] := '1';
  rdgSWDensTable.Cells[2,1] := '0.7143';
  rdgSWDensTable.Cells[3,1] := '0';

  rdgSub.Cells[0,0] := 'Unit';
  rdgSub.Cells[1,0] := 'Number of no-delay interbeds';
  rdgSub.Cells[2,0] := 'Number of delay interbeds';
  LabelUnits(rdgSub);
  for RowIndex := 1 to rdgSub.RowCount -1 do
  begin
    for ColIndex := 1 to rdgSub.ColCount -1 do
    begin
      rdgSub.Cells[ColIndex,RowIndex] := '0';
    end;
  end;

  rdgSwt.Cells[0,0] := 'Unit';
  rdgSwt.Cells[1,0] := 'Number of interbeds';
  LabelUnits(rdgSwt);
  for RowIndex := 1 to rdgSwt.RowCount -1 do
  begin
    for ColIndex := 1 to rdgSwt.ColCount -1 do
    begin
      rdgSwt.Cells[ColIndex,RowIndex] := '0';
    end;
  end;

  dgSubOutFormat.Cells[0,0] := 'Item';
  dgSubOutFormat.Cells[1,0] := 'Format';
  dgSubOutFormat.Cells[0,1] := 'Subsidence';
  dgSubOutFormat.Cells[0,2] := 'Compaction by model layer';
  dgSubOutFormat.Cells[0,3] := 'Compaction by interbed system';
  dgSubOutFormat.Cells[0,4] := 'Vertical displacement by model layer';
  dgSubOutFormat.Cells[0,5] := 'Critical head for no-delay interbeds';
  dgSubOutFormat.Cells[0,6] := 'Critical head for delay interbeds';

  rdgGwmStorageVariables.Cells[Ord(gwscName), 0] := 'Name';
  rdgGwmStorageVariables.Cells[Ord(gscStartSP), 0] := 'Starting Stress Period';
  rdgGwmStorageVariables.Cells[Ord(gscEndsSp), 0] := 'Ending Stress Period';
  rdgGwmStorageVariables.Cells[Ord(gscZoneChoice), 0] := 'Zone Choice';
  rdgGwmStorageVariables.Cells[Ord(gscZoneNumber), 0] := 'Zone Number 1';


  SubFormat := dgSubOutFormat.Columns[1].Picklist[0];
  for RowIndex := 1 to dgSubOutFormat.RowCount -1 do
  begin
    dgSubOutFormat.Cells[1,RowIndex] := SubFormat;
  end;


  for ColIndex := 0 to 3 do
  begin
    dgSubOutput.Cells[ColIndex,1] := '1';
  end;
  for ColIndex := 4 to dgSubOutput.ColCount -1 do
  begin
    dgSubOutput.Cells[ColIndex,1] := dgSubOutput.Columns[ColIndex].PickList[0];
  end;
  dgSubOutputCellText := '1';

  // initialize data in dgTime
  for TimeColIndex := Low(timeData) to High(timeData) do
  begin
    if TimeColIndex = tdSsTr then
    begin
      dgTime.Cells[Ord(TimeColIndex), 1] :=
        dgTime.Columns[Ord(TimeColIndex)].Picklist[1];
    end
    else if TimeColIndex = tdRefStrPeriod then
    begin
      dgTime.Cells[Ord(TimeColIndex), 1] :=
        dgTime.Columns[Ord(TimeColIndex)].Picklist[0];
    end
    else
    begin
      dgTime.Cells[Ord(TimeColIndex), 1] := '1';
    end;
  end;

  // initialize data in sgMOC3DParticles
  for ColIndex := 1 to sgMOC3DParticles.ColCount - 1 do
  begin
    sgMOC3DParticles.Cells[ColIndex, 1] := '0';
  end;

  // initialize data in sgMOC3DTransParam
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
    begin
      sgMOC3DTransParam.Cells[ColIndex, RowIndex] := '0';
    end;
  end;

  // initialize data in sgMOC3DTransParam
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    sgMOC3DTransParam.Cells[Ord(trdRetard), RowIndex] := '1';
  end;

  // initialize data in sgFHBTimes
  for RowIndex := 1 to sgFHBTimes.RowCount - 1 do
  begin
    sgFHBTimes.Cells[1, RowIndex] := '0';
  end;

  // initialize data in dgIBS
  for RowIndex := 1 to dgIBS.RowCount - 1 do
  begin
    dgIBS.Cells[0, RowIndex] := IntToStr(RowIndex);
    dgIBS.Cells[1, RowIndex] := dgIBS.Columns[1].Picklist[0];
    dgIBS.Cells[2, RowIndex] := dgIBS.Columns[2].Picklist[0];
  end;

  rdgSW_ViscEqTemp.ColWidths[0] := 100;
  rdgSW_ViscEqTemp.Cells[0,0] := 'Species used for temperature (MTMUTEMPSPEC)';
  rdgSW_ViscEqTemp.Cells[1,0] := 'A1 (AMUCOEFF[1])';
  rdgSW_ViscEqTemp.Cells[2,0] := 'A2 (AMUCOEFF[2])';

  rdgSW_ViscEq.ColWidths[2] := rdgSW_ViscEq.DefaultColWidth*2; 
  rdgSW_ViscEq.Cells[0,0] := 'N';
  rdgSW_ViscEq.Cells[1,0] := 'Species (MTMUSPEC)';
  rdgSW_ViscEq.Cells[2,0] := 'Slope: fluid viscosity to solute concentration (DMUDC)';
  rdgSW_ViscEq.Cells[3,0] := 'Reference Concentration (CMUREF)';
  rdgSW_ViscEq.Cells[0,1] := '1';

  // initialize data in the various combos.
  comboIAPART.ItemIndex := 0;
  comboISTRT.ItemIndex := 1;
  //  adeMiscOption.ItemIndex := 0;
  comboWetCap.ItemIndex := 0;
  comboWetEq.ItemIndex := 1;

  comboRchSteady.ItemIndex := 1;
  comboRchOpt.ItemIndex := 0;
  comboRivSteady.ItemIndex := 1;
  comboWelSteady.ItemIndex := 1;
  comboDrnSteady.ItemIndex := 1;
  comboDrtSteady.ItemIndex := 1;
  comboGhbSteady.ItemIndex := 1;
  comboEvtSteady.ItemIndex := 1;
  comboEvtOption.ItemIndex := 0;
  comboEtsSteady.ItemIndex := 1;
  comboEtsOption.ItemIndex := 0;

  comboSteady.ItemIndex := 1;
  comboTimeUnits.ItemIndex := 0;

  comboExportHead.ItemIndex := 1;
  comboExportDrawdown.ItemIndex := 1;

  comboHeadPrintFreq.ItemIndex := 1;
  comboDrawdownPrintFreq.ItemIndex := 1;
  comboBudPrintFreq.ItemIndex := 2;
  comboHeadExportFreq.ItemIndex := 1;
  comboDrawdownExportFreq.ItemIndex := 1;
  comboBudExportFreq.ItemIndex := 2;

  comboPCGPrecondMeth.ItemIndex := 0;
  comboPCGEigenValue.ItemIndex := 1;
  comboPCGPrint.ItemIndex := 1;

  comboDE4Freq.ItemIndex := 2;
  comboDE4Print.ItemIndex := 0;

  comboSIPIterSeed.ItemIndex := 1;

  comboMOC3DInterp.ItemIndex := 0;
  comboMOC3DReadRech.ItemIndex := 0;
  comboMOC3DSaveWell.ItemIndex := 1;

  comboMOC3DConcFileType.ItemIndex := 1;
  comboMOC3DVelFileType.ItemIndex := 1;
  comboMOC3DPartFileType.ItemIndex := 0;

  comboMOC3DConcFreq.ItemIndex := 1;
  comboMOC3DVelFreq.ItemIndex := 0;
  comboMOC3DDispFreq.ItemIndex := 2;
  comboMOC3DPartFreq.ItemIndex := 0;

  comboCustomize.ItemIndex := 2;

  comboStreamOption.ItemIndex := 1;
  comboModelUnits.ItemIndex := 0;

  comboSFROption.ItemIndex := 1;

  comboFHBSteadyStateOption.ItemIndex := 1;

  comboMODPATH_RechargeITOP.ItemIndex := 1;
  comboMODPATH_EvapITOP.ItemIndex := 1;

{$IFDEF Debug}
  WriteDebugOutput('before: comboMPATHStartTimeMethod.ItemIndex := 1;');
{$ENDIF}
  comboMPATHStartTimeMethod.ItemIndex := 1;
{$IFDEF Debug}
  WriteDebugOutput('after: comboMPATHStartTimeMethod.ItemIndex := 1;');
{$ENDIF}
  comboMPATHOutMode.ItemIndex := 1;
  comboMPATHTimeMethod.ItemIndex := 0;
  comboMPATHDirection.ItemIndex := 0;
  comboMPATHSinkTreatment.ItemIndex := 0;
  comboMPATHWhichParticles.ItemIndex := 0;

  comboMOC3D_IDIREC.ItemIndex := 0;

  comboHeadPrintStyle.ItemIndex := 0;
  comboDrawdownPrintStyle.ItemIndex := 0;
  comboHeadPrintFormat.ItemIndex := 11;
  comboDrawdownPrintFormat.ItemIndex := 11;
  comboDualPOutOption.ItemIndex := 2;
  comboLengthUnits.ItemIndex := 0;
  comboHeadFluxObsPrintFormats.ItemIndex := 0;
  SetComboColor(comboHeadFluxObsPrintFormats);

  comboSensEst.ItemIndex := 1;
  comboSensMemory.ItemIndex := 0;
  comboSensFormat.ItemIndex := 0;
  comboStreamObsPrintFormats.ItemIndex := 0;

  comboSteadyChange(Sender);

  comboObservationScaling.ItemIndex := 2;
  comboIRAND.ItemIndex := 1;
  comboSpecifyParticles.ItemIndex := 0;

  comboMnwObservations.ItemIndex := 0;
  comboDensityChoice.ItemIndex := 0;
  combo_iOutCobs.ItemIndex := 1;
  comboSW_ViscosityMethod.ItemIndex := 2;
  comboSW_TimeVaryingViscosity.ItemIndex := 0;
  comboSW_ViscEquation.ItemIndex := 0;

  // initialize data in sgMODPATHOutputTimes
  for RowIndex := 1 to sgMODPATHOutputTimes.RowCount - 1 do
  begin
    sgMODPATHOutputTimes.Cells[1, RowIndex] := '0';
  end;

  sgZoneArrays.Cells[1, 0] := 'Zone Array name';

  // initialize the maximum allowable values of the MOC3D subgrid layers.
  adeMOC3DLay1.Max := StrToInt(edNumUnits.Text);
  adeMOC3DLay2.Max := adeMOC3DLay1.Max;

  comboBealeInput.ItemIndex := 0;
  comboYcintInput.ItemIndex := 0;
  comboLastx.ItemIndex := 0;
  comboParamEstVarPrintFormat.ItemIndex := 1;
  comboParamEstStatisticsPrint.ItemIndex := 0;
  comboGHBObsPrintFormats.ItemIndex := 0;
  comboDrainObsPrintFormats.ItemIndex := 0;
  comboRiverObsPrintFormats.ItemIndex := 0;
  comboAdvObsPrintFormats.ItemIndex := 0;
  comboLakSteady.ItemIndex := 1;

  comboIBSPrintFrequency.ItemIndex := 2;
  comboIBSPrintStyle.ItemIndex := 0;
  comboIBSPrintFormat.ItemIndex := 12;
  comboIBSSaveFrequency.ItemIndex := 2;
  comboResSteady.ItemIndex := 1;
  comboResOption.ItemIndex := 0;

  comboDrainReturnObsPrintFormats.ItemIndex := 0;
  combo_AMG_DampingMethod.ItemIndex := 0;
  comboMT3D_Preconditioner.ItemIndex := 2;
  comboMt3dFlowFormat.ItemIndex := 0;
  //  comboIBSSaveStyle.ItemIndex := 0;
  //  comboIBSSaveFormat.ItemIndex := 11;
  comboMNW_Steady.ItemIndex := 1;
  combMNW_LossType.ItemIndex := 0;
  comboDAF_TimeStepUnits.ItemIndex := 0;

  comboSW_InternodalDensity.ItemIndex := 1;
  comboSW_DensitySpecificationMethod.ItemIndex := 4;

  SetComboColor(comboSW_InternodalDensity);
  SetComboColor(comboSW_DensitySpecificationMethod);

  comboGmgIadamp.ItemIndex := 0;
  comboGmgIoutgmg.ItemIndex := 1;
  comboGmgIsm.ItemIndex := 0;
  comboGmgIsc.ItemIndex := 1;

  comboGWM_Objective.ItemIndex := 0;
  comboGWM_SLPITPRT.ItemIndex := 0;

  comboUzfNUZTOP.ItemIndex := 0;
  comboUzfTransient.ItemIndex := 1;
  comboVertCond.ItemIndex := 0;

  frameGWM_External.dgVariables.Cells[Ord(gecMin),0] := 'Minimum';
  frameGWM_External.dgVariables.Cells[Ord(gecMax),0] := 'Maximum';
  frameGWM_External.dgVariables.Cells[Ord(gecSP1),0] := 'SP 1';
  frameGWM_Binary.dgVariables.Cells[Ord(gbcCount),0] := 'Number of variables';
  frameGWM_FlowObjective.dgVariables.Cells[0,0] := 'Name';
  frameGWM_FlowObjective.dgVariables.Cells[1,0] := 'Coefficient';
  frameGWM_ExternalObjective.dgVariables.Cells[0,0] := 'Name';
  frameGWM_ExternalObjective.dgVariables.Cells[1,0] := 'Coefficient';

  frameGWM_StateObjective.dgVariables.Cells[0,0] := 'Name';
  frameGWM_StateObjective.dgVariables.Cells[1,0] := 'Coefficient';

  frameGWM_BinaryObjective.dgVariables.Cells[Ord(gbcName),0] := 'Name';
  frameGWM_BinaryObjective.dgVariables.Cells[Ord(gbcCount),0] := 'Coefficient';
  frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscName),0] := 'Name';
  frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscCount),0] := 'Number of terms';
  frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscType),0] := 'Type';
  frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscRightHandSide),0] := 'Right-hand side';

  rgSolMethClick(Sender);
  // Make sure that IAPART is set properly.
  dgGeolExit(nil);
  // Initialize the titles of all the grids.
  InitializeGrids;

  // begin MT3D
  OldGeolContGrid := TSpecialHandlingObject.Create('sgcUnits',
    ReadOldLakeGeoData);
  SpecialHandlingList.Add(OldGeolContGrid);

  OldStream := TSpecialHandlingObject.Create('cbRBWSTR', ReadOldStream);
  SpecialHandlingList.Add(OldStream);

  OldStreamDiv := TSpecialHandlingObject.Create('cbRBWUseDiversions',
    ReadOldStreamDiv);
  SpecialHandlingList.Add(OldStreamDiv);

  OldStreamICALC := TSpecialHandlingObject.Create('cbRBWCalculateStage',
    ReadOldStreamICALC);
  SpecialHandlingList.Add(OldStreamICALC);

  OldStreamModelUnits :=
    TSpecialHandlingObject.Create('comboRBWStreamModelLength',
    ReadOldStreamModelUnits);
  SpecialHandlingList.Add(OldStreamModelUnits);

  OldStreamSteady := TSpecialHandlingObject.Create('comboRBWSTRSteady',
    ReadOldStreamSteady);
  SpecialHandlingList.Add(OldStreamSteady);

  OldStreamTrib := TSpecialHandlingObject.Create('cbRBWUseTributaries',
    ReadOldStreamTrib);
  SpecialHandlingList.Add(OldStreamTrib);

  OldStreamPrintFlows := TSpecialHandlingObject.Create('cbExpStrFlow',
    ReadOldStreamPrint);
  SpecialHandlingList.Add(OldStreamPrintFlows);

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('cbGWM_SLPITPRT',
    ReadOldGWM_SLPITPRT));


  IgnoreList.Add('rbRunMT3D');
  IgnoreList.Add('rbCreateMT3D');
  IgnoreList.Add('cbExportMT3DBTN');
  IgnoreList.Add('cbExportMT3DADV');
  IgnoreList.Add('cbExportMT3DDSP');
  IgnoreList.Add('cbExportMT3DSSM');
  IgnoreList.Add('cbExportMT3DRCT');
  IgnoreList.Add('cbExportMT3DGCG');

  {$IFNDEF GWM_State}
  IgnoreList.Add('cbGwmHeadVariables');
  IgnoreList.Add('cbGwmStreamVariables');
  IgnoreList.Add('rdeGwmStorageStateVarCount');
  IgnoreList.Add('rdgGwmStorageVariables');
  IgnoreList.Add('rdeGwmStateTimeCount');
  tabGWM_State.TabVisible := False;
  {$ENDIF}

  for RowIndex := 1 to sgMT3DTime.RowCount - 1 do
  begin
    sgMT3DTime.Cells[Ord(tdmLength), RowIndex]
      := dgTime.Cells[Ord(tdLength), RowIndex];
    sgMT3DTime.Cells[Ord(tdmStepSize), RowIndex] := '1';
    sgMT3DTime.Cells[Ord(tdmMaxSteps), RowIndex] := '1000';
    sgMT3DTime.Cells[Ord(tdmCalculated), RowIndex] := 'Yes';
    sgMT3DTime.Cells[Ord(tdmMult), RowIndex] := '1';
    sgMT3DTime.Cells[Ord(tdmMax), RowIndex] := '1000';
  end;

  for RowIndex := 1 to sgReaction.RowCount - 1 do
  begin
    sgReaction.Cells[Ord(rdmBulkDensity), RowIndex] := '0.3';
    sgReaction.Cells[Ord(rdmSorpConst1), RowIndex] := '1';
    sgReaction.Cells[Ord(rdmSorpConst2), RowIndex] := '1';
    sgReaction.Cells[Ord(rdmRateConstDiss), RowIndex] := '1e-006';
    sgReaction.Cells[Ord(rdmRateConstSorp), RowIndex] := '1e-006';
    sgReaction.Cells[Ord(rdmDualPorosity), RowIndex] := '0.2';
    sgReaction.Cells[Ord(rdmStartingConcentration), RowIndex] := '0';
  end;
  for RowIndex := 1 to sgDispersion.RowCount - 1 do
  begin
    sgDispersion.Cells[Ord(ddmHorDisp), RowIndex] := '0.1';
    sgDispersion.Cells[Ord(ddmVertDisp), RowIndex] := '0.01';
    sgDispersion.Cells[Ord(ddmMolDiffCoef), RowIndex] := '0';
  end;
  for RowIndex := 1 to sgPrintoutTimes.RowCount - 1 do
  begin
    sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex] := '0';
  end;
  comboMT3DAdvSolScheme.ItemIndex := 3;
  comboMT3DParticleTrackingAlg.ItemIndex := 2;
  comboMT3DInitPartPlace.ItemIndex := 0;
  comboMT3DInitPartSinkChoice.ItemIndex := 0;
  comboMT3DIsotherm.ItemIndex := 1;
  comboMT3DIREACT.ItemIndex := 0;
  comboPrintoutFormat.ItemIndex := 1;
  comboConcentrationFormat.ItemIndex := 0;
  comboRetardationFormat.ItemIndex := 0;
  comboDispersionFormat.ItemIndex := 0;
  comboParticlePrintFormat.ItemIndex := 1;
  comboResultsPrinted.ItemIndex := 1;
  comboMT3DAdvWeightingScheme.ItemIndex := 1;
  // end MT3D
{
  rdgSwtPrintInitialValues.Cells[0,0] := 'Print Initial Data Set';
//  rdgSwtPrintInitialValues.Cells[1,0] := 'Print';
  rdgSwtPrintInitialValues.Cells[0,1] := 'Layer-center elevation';
  rdgSwtPrintInitialValues.Cells[0,2] := 'Geostatic stress';
  rdgSwtPrintInitialValues.Cells[0,3] := 'Effective stress';
  rdgSwtPrintInitialValues.Cells[0,4] := 'Preconsolidation stress';
  rdgSwtPrintInitialValues.Cells[0,5] := 'Equivalent storage properties';  }
  comboSwtITHK.ItemIndex := 0;
  comboSwtIVOID.ItemIndex := 0;
  comboSwtISTPCS.ItemIndex := 0;
  comboSwtICRCC.ItemIndex := 0;
  comboSwtFormat.ItemIndex := 0;

  rdgSwtOutput.Cells[0,0] := 'Starting stress period';
  rdgSwtOutput.Cells[1,0] := 'Ending stress period';
  rdgSwtOutput.Cells[2,0] := 'Starting time step';
  rdgSwtOutput.Cells[3,0] := 'Ending time step';
  rdgSwtOutput.Cells[4,0] := 'Print items';
  rdgSwtOutput.Cells[5,0] := 'Save items';

  rdgSwtOutput.Cells[6,0] := 'Subsidence';
  rdgSwtOutput.Cells[7,0] := 'Compaction by layer';
  rdgSwtOutput.Cells[8,0] := 'Compaction by interbed system';
  rdgSwtOutput.Cells[9,0] := 'Vertical displacement';
  rdgSwtOutput.Cells[10,0] := 'Preconsolidation stress';
  rdgSwtOutput.Cells[11,0] := 'Change in preconsolidation stress';
  rdgSwtOutput.Cells[12,0] := 'Geostatic stress';
  rdgSwtOutput.Cells[13,0] := 'Change in geostatic stress';
  rdgSwtOutput.Cells[14,0] := 'Effective stress';
  rdgSwtOutput.Cells[15,0] := 'Change in effective stress';
  rdgSwtOutput.Cells[16,0] := 'Void ratio';
  rdgSwtOutput.Cells[17,0] := 'Compressible bed thickness';
  rdgSwtOutput.Cells[18,0] := 'Layer-center elevation';

  rdgSwtOutput.Cells[0,1] := '1';
  rdgSwtOutput.Cells[1,1] := '1';
  rdgSwtOutput.Cells[2,1] := '1';
  rdgSwtOutput.Cells[3,1] := '1';
  rdgSwtOutput.Checked[4,1] := True;
  rdgSwtOutput.Checked[5,1] := True;

  clbMnw2LossTypes.Checked[0] := True;

  UpdateGwmStateSP_Limits;

  Tip;
{$IFDEF Debug}
  WriteDebugOutput('Exit: procedure TfrmMODFLOW.FormCreate');
{$ENDIF}
end;

procedure TfrmMODFLOW.comboWetCapChange(Sender: TObject);
var
  WettingActive: boolean;
begin
  // triggering event: comboWetCap.OnChange;
  inherited;

  // Show a warning if the rewetting option and MOC3D are both selected.
  Moc3dWetWarning;
  // enable or disable other controls depending on whether or not
  // the wetting capability is active.
  WettingActive := (comboWetCap.ItemIndex = 1);
  adeWettingFact.Enabled := WettingActive; // wetting factor
  adeWetIterations.Enabled := WettingActive; // wetting iterations
  comboWetEq.Enabled := WettingActive; // wetting equation.
  SetComboColor(comboWetEq);
end;

procedure TfrmMODFLOW.cbRCHClick(Sender: TObject);
begin
  // triggering event: cbRCH.OnClick;
  inherited;
  ActivateParametersTab;
  if cbRCH.Checked then
  begin
    AddNewParameters(dgRCHParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgRCHParametersN, 0);
  end;

  // enable or disable other controls depending on whether recharge is active.
  comboRchSteady.Enabled := cbRCH.Checked; // steady recharge
  SetComboColor(comboRchSteady);

  comboRchOpt.Enabled := cbRCH.Checked; // recharge option
  SetComboColor(comboRchOpt);

  cbRCHRetain.Enabled := cbRCH.Checked; // recharge option
  cbRechLayer.Enabled := cbRCH.Checked and (comboRchOpt.ItemIndex = 1);

  // cell-by-cell flows related to recharge
  cbFlowRCH.Enabled := cbRCH.Checked;

  // read or reuse recharge concentrations in MOC3D.
  comboMOC3DReadRech.Enabled := cbRCH.Checked and cbMOC3D.Checked;
  SetComboColor(comboMOC3DReadRech);

  // location of MODPATH particles for recharge
  comboMODPATH_RechargeITOP.Enabled := cbRCH.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked));
  SetComboColor(comboMODPATH_RechargeITOP);

  // add or remove the recharge layer depending on whether recharge
  // is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetRechargeLayerType, cbRCH.Checked);

  // add or remove the recharge concentration layer depending on whether
  // recharge and MOC3D are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCRechargeConcLayerType, cbRCH.Checked
    and (cbMOC3D.Checked or
    (cbMT3D.Checked and cbSSM.Checked)));

  // add or remove the recharge elevation parameter from the grid layer
  // depending on whether recharge is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRechElevParamType,
    cbRCH.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

  EnableSSM;
end;

procedure TfrmMODFLOW.cbRIVClick(Sender: TObject);
begin
  // triggering event: cbRIV.OnClick;
  inherited;
  EnableAreaRiverContour;
  ActivateParametersTab;

  if cbRIV.Checked then
  begin
    AddNewParameters(dgRIVParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgRIVParametersN, 0);
  end;

  // enable or disable other controls depending on whether recharge is active.
  comboRivSteady.Enabled := cbRIV.Checked; // steady stress
  SetComboColor(comboRivSteady);

  cbObservationsClick(Sender);

  cbRIVObservations.Enabled := cbRIV.Checked;
  cbRIVObservationsClick(Sender);
  cbRIVRetain.Enabled := cbRIV.Checked; // steady stress
  cbUseAreaRivers.Enabled := cbRIV.Checked;

  cbAltRiv.Enabled := cbRIV.Checked;
  cbCondRiv.Enabled := cbRIV.Checked;

  // cell-by-cell flows related to rivers
  cbFlowRiv.Enabled := cbRIV.Checked;

  cbSW_RiverbedThickness.Enabled := cbRIV.Checked and cbSW_VDF.Checked;
  cbSW_RiverFluidDensity.Enabled := cbRIV.Checked and cbSW_VDF.Checked;

  // add or remove the point river layer
  // depending on whether rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFPointRiverLayerType, cbRIV.Checked);

  // add or remove the line river layer
  // depending on whether rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineRiverLayerType, cbRIV.Checked);

  // add or remove the river grid-layer parameters
  // depending on whether rivers are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRiverParamType,
    cbRIV.Checked);

  cbUseAreaRiversClick(Sender);

  // add or remove concentration parameter from the point river layer
  // depending on whether rivers and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbRiv.Checked);

  // add or remove concentration parameter from the line river layer
  // depending on whether rivers and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbRiv.Checked);

  // add or remove concentration parameter from the area river layer
  // depending on whether rivers and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbRiv.Checked and cbUseAreaRivers.Checked);

  cbSW_RiverFluidDensityClick(nil);
  cbSW_RiverbedThicknessClick(nil);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

  EnableSSM;
  //  StreamWarning;

end;

procedure TfrmMODFLOW.cbWELClick(Sender: TObject);
begin
  // triggering event: cbWEL.OnClick;
  inherited;
  EnablecbAreaWellContour;
  ActivateParametersTab;

  if cbWEL.Checked then
  begin
    AddNewParameters(dgWELParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgWELParametersN, 0);
  end;

  // enable or disable other controls depending on whether wells are active.
  comboWelSteady.Enabled := cbWEL.Checked; // steady stress
  SetComboColor(comboWelSteady);

  cbWELRetain.Enabled := cbWEL.Checked; // steady stress

  // cell-by-cell flows related to wells
  cbFlowWel.Enabled := cbWEL.Checked;

  cbAltWel.Enabled := cbWEL.Checked;
  cbUseAreaWells.Enabled := cbWEL.Checked;
  cbSW_WellFluidDensity.Enabled := cbWEL.Checked and cbSW_VDF.Checked;

  // add or remove well layers
  // depending on whether wells are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFWellLayerType, cbWEL.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineWellLayerType, cbWEL.Checked);

  // add or remove grid well parameter from the grid layer
  // depending on whether wells are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridWellParamType,
    cbWEL.Checked);

  cbUseAreaWellsClick(Sender);

  // add or remove concentration parameter from the well layer
  // depending on whether wells and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbWel.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbWel.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbWel.Checked and cbUseAreaWells.Checked);

  cbSW_WellFluidDensityClick(nil);
    
  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  EnableSSM;
end;

procedure TfrmMODFLOW.cbDRNClick(Sender: TObject);
begin
  // triggering event: cbDRN.OnClick;
  inherited;
  EnableAreaDrainContour;
  ActivateParametersTab;

  if cbDRN.Checked then
  begin
    AddNewParameters(dgDRNParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgDRNParametersN, 0);
  end;

  // enable or disable other controls depending on whether drains are active.
  comboDrnSteady.Enabled := cbDRN.Checked; // steady stress
  SetComboColor(comboDrnSteady);

  cbObservationsClick(Sender);

  cbDRNObservations.Enabled := cbDRN.Checked;
  cbDRNObservationsClick(Sender);
  cbDRNRetain.Enabled := cbDRN.Checked;
  cbAltDrn.Enabled := cbDRN.Checked;
  cbCondDrn.Enabled := cbDRN.Checked;

  // cell-by-cell flows related to drains
  cbFlowDrn.Enabled := cbDRN.Checked;
  cbUseAreaDrains.Enabled := cbDRN.Checked;
  cbSW_DrainElevation.Enabled := cbDRN.Checked and cbSW_VDF.Checked;

  // add or remove drain layers
  // depending on whether drains are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFPointDrainLayerType, cbDRN.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetLineDrainLayerType, cbDRN.Checked);

  // add or remove grid drain parameter from the grid layer
  // depending on whether drains are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridDrainParamType,
    cbDRN.Checked);

  cbUseAreaDrainsClick(Sender);
  cbSW_DrainElevationClick(nil);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  EnableSSM;
end;

procedure TfrmMODFLOW.cbGHBClick(Sender: TObject);
begin
  // triggering event: cbGHB.OnClick;
  inherited;
  EnableAreaGHBContour;
  ActivateParametersTab;

  if cbGHB.Checked then
  begin
    AddNewParameters(dgGHBParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgGHBParametersN, 0);
  end;

  cbCondGhb.Enabled := cbGHB.Checked; 

  // enable or disable other controls depending on whether
  // general-head boundaries are active.
  comboGhbSteady.Enabled := cbGHB.Checked; // steady stress
  SetComboColor(comboGhbSteady);

  cbObservationsClick(Sender);

  cbGHBObservations.Enabled := cbGHB.Checked;
  cbGHBObservationsClick(Sender);
  cbGHBRetain.Enabled := cbGHB.Checked;
  cbAltGHB.Enabled := cbGHB.Checked;

  // cell-by-cell flows related to general-head boundaries
  cbFlowGHB.Enabled := cbGHB.Checked;
  cbUseAreaGHBs.Enabled := cbGHB.Checked;
  cbSW_GHB_FluidDensity.Enabled := cbGHB.Checked and cbSW_VDF.Checked;
  cbSW_GHB_Elevation.Enabled := cbGHB.Checked and cbSW_VDF.Checked;

  // add or remove general-head boundary layers
  // depending on whether general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetPointGHBLayerType, cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetLineGHBLayerType, cbGHB.Checked);

  // add or remove grid general-head boundary parameters from the grid layer
  // depending on whether general-head boundaries are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridGHBParamType,
    cbGHB.Checked);

  cbUseAreaGHBsClick(Sender);
  cbSW_GHB_ElevationClick(nil);

  // add or remove concentration parameters from the general-head boundary
  // layers
  // depending on whether general-head boundaries and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType, ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType, ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbGHB.Checked and cbUseAreaGHBs.Checked);

  cbSW_GHB_FluidDensityClick(nil);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  EnableSSM;
end;

procedure TfrmMODFLOW.cbEVTClick(Sender: TObject);
begin
  // triggering event: cbEVT.OnClick;
  inherited;
  ActivateParametersTab;

  if cbEVT.Checked then
  begin
    AddNewParameters(dgEVTParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgEVTParametersN, 0);
  end;

  // enable or disable other controls depending on whether
  // evapotranspiration is active.
  comboEvtSteady.Enabled := cbEVT.Checked; // steady stress
  SetComboColor(comboEvtSteady);

  comboEvtOption.Enabled := cbEVT.Checked; // evapotranspiration option
  SetComboColor(comboEvtOption);

  cbEVTRetain.Enabled := cbEVT.Checked;
  cbETLayer.Enabled := cbEVT.Checked and (comboEvtOption.ItemIndex = 1);

  // cell-by-cell flows related to evapotranspiration
  cbFlowEVT.Enabled := cbEVT.Checked;

  // location of MODPATH particles for evapotranspiration
  comboMODPATH_EvapITOP.Enabled := (cbEVT.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked)))
    or (cbETS.Checked and cbMOC3D.Checked and cbBFLX.Checked);
  SetComboColor(comboMODPATH_EvapITOP);

  // add or remove evapotranspiration layer
  // depending on whether evapotranspiration is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetETLayerType, cbEVT.Checked);

  // add or remove grid evapotranspiration parameters from the grid layer
  // depending on whether evapotranspiration is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridETSurfParamType,
    cbEVT.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridETExtinctionDepthParamType,
    cbEVT.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  EnableSSM;
end;

procedure TfrmMODFLOW.TestHeadExport(Sender: TObject);
var
  HeadsUsed: boolean;
  UnitIndex: integer;
begin
  HeadsUsed := False;
  if cbMODPATH.Checked then
  begin
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if Simulated(UnitIndex) and (ModflowLayerType(UnitIndex) > 0) then
      begin
        HeadsUsed := True;
        Break;
      end;
    end;
    if not Loading and not Cancelling and HeadsUsed
      and (comboExportHead.ItemIndex = 0) then
    begin
      if Sender = comboExportHead then
      begin
        Beep;
        MessageDlg('Sorry: MODPATH requires that heads be saved.', mtInformation,
          [mbOK], 0);
      end;
      comboExportHead.ItemIndex := 1;
    end;
    if not Loading and not Cancelling and HeadsUsed then
    begin
      comboHeadExportFreq.ItemIndex := 1;
      adeHeadExportFreq.Text := '1';
    end;
  end;

  // if you are going to export the head, you can pick the frequency
  // at which it is exported. Otherwise, you can't pick the frequency.
  comboHeadExportFreq.Enabled := not (comboExportHead.ItemIndex = 0) and not HeadsUsed;
  SetComboColor(comboHeadExportFreq);
  frameHeadFormat.Enabled := comboHeadExportFreq.Enabled
    and (comboExportHead.ItemIndex = 1);
  if (comboExportHead.ItemIndex = 0) and not loading and not cancelling then
  begin
    comboHeadExportFreq.ItemIndex := 0;
  end;

  comboHeadExportFreqChange(Sender);

end;

procedure TfrmMODFLOW.comboExportHeadChange(Sender: TObject);
begin
  // triggering event: comboExportHead.OnChange;
  inherited;
  TestHeadExport(Sender);


  // If you are goint to export heads every N'th time step, you
  // can specify N.
{  comboHeadPrintFreq.Enabled := not (comboExportHead.ItemIndex = 0);
  SetComboColor(comboHeadPrintFreq);

  comboHeadPrintFreqChange(Sender); }

end;

procedure TfrmMODFLOW.cbFlowClick(Sender: TObject);
begin
  // triggering events: cbFlowBCF.OnClick;
  // triggering events: cbFlowRCH.OnClick;
  // triggering events: cbFlowDrn.OnClick;
  // triggering events: cbFlowGHB.OnClick;
  // triggering events: cbFlowRiv.OnClick;
  // triggering events: cbFlowWel.OnClick;
  // triggering events: cbFlowEVT.OnClick;
  // triggering events: cbFlowFHB.OnClick;
  // triggering events: cbFlowSTR.OnClick;
  // triggering events: cbFlowSTR2.OnClick;
  inherited;

  // If you are going to export flows for any package, you can choose
  // the frequency at which it is exported.
  comboBudExportFreq.Enabled := not cbMODPATH.Checked and
    ((cbFlowBCF.Checked and (rgFlowPackage.ItemIndex = 0))
    or (cbFlowRCH.Checked and cbRCH.Checked)
    or (cbFlowDrn.Checked and cbDRN.Checked)
    or (cbFlowDrt.Checked and cbDRT.Checked)
    or (cbFlowGHB.Checked and cbGHB.Checked)
    or (cbFlowRiv.Checked and cbRIV.Checked)
    or (cbFlowWel.Checked and cbWEL.Checked)
    or (cbFlowEVT.Checked and cbEVT.Checked)
    or (cbFlowFHB.Checked and cbFHB.Checked)
    or (cbFlowSTR.Checked and cbSTR.Checked)
    or (cbFlowSTR2.Checked and cbSTR.Checked)
    or (cbFlowSFR.Checked and cbSFR.Checked)
    or (cbFlowSFR2.Checked and cbSFR.Checked)
    or (cbFlowETS.Checked and cbETS.Checked)
    or (cbFlowLPF.Checked and (rgFlowPackage.ItemIndex = 1))
    or (cbFlowIBS.Checked and cbIBS.Checked)
    or (cbFlowRES.Checked and cbRes.Checked)
    or (cbFlowTLK.Checked and cbTLK.Checked)
    or (cbFlowHUF.Checked and (rgFlowPackage.ItemIndex = 2))
    or (cbFlowMNW.Checked and cbMNW.Checked)
    or (cbFlowDaflow.Checked and cbDAFLOW.Checked)
    or (cbFlowSub.Checked and cbSUB.Checked)
    or (cbFlowSwt.Checked and cbSWT.Checked)
    or (cbFlowUZF.Checked and cbUZF.Checked)
    );
  if not Loading and not cancelling then
  begin
    if cbMODPATH.Checked or cbZonebudget.Checked then
    begin
      if ((comboBudExportFreq.ItemIndex <> 1)
        or (adeBudExportFreq.Text <> '1')) then
      begin
        Beep;
        MessageDlg('You will need to re-run MODFLOW before running MODPATH or'
          + ' ZONEBUDGET.', mtInformation, [mbOK], 0);
      end;
      comboBudExportFreq.ItemIndex := 1;
      adeBudExportFreq.Text := '1';
    end;
  end;

  SetComboColor(comboBudExportFreq);

  // If you are goint to export flows every N'th time step, you
  // can specify N.
  adeBudExportFreq.Enabled := (comboBudExportFreq.ItemIndex in [1, 3])
    and comboBudExportFreq.Enabled and not cbMODPATH.Checked;

  if cbFlowSTR.Checked then
  begin
    cbStrPrintFlows.Checked := False;
  end;

  if cbFlowSFR.Checked then
  begin
    cbSFRPrintFlows.Checked := False;
  end;

  if cbFlowMNW.Checked then
  begin
    cbMNW_PrintFlows.Checked := False;
  end;
end;

procedure TfrmMODFLOW.SorWarning;
begin
  if not Loading and not Cancelling then
  begin
    if (rgSolMeth.ItemIndex = 3) and rbModflow2005.Checked then
    begin
      Beep;
      MessageDlg('The SOR solver is not supported in MODFLOW-2005.',
        mtWarning, [mbOK], 0);
    end;

  end;
end;

procedure TfrmMODFLOW.rgSolMethClick(Sender: TObject);
begin
  // triggering event: rgSolMeth.OnClick;
  inherited;
  SorWarning;
  StreamToleranceWarning;
  PageControlSolvers.ActivePageIndex := rgSolMeth.ItemIndex;
  PageControlSolvers.HelpContext := PageControlSolvers.ActivePage.HelpContext;
  TabStream.HelpContext := PageControlSolvers.ActivePage.HelpContext;
  BitBtnHelp.HelpContext := PageControlSolvers.ActivePage.HelpContext;
  LmgWarning;
  GmgWarning;
end;

procedure TfrmMODFLOW.comboHeadPrintFreqChange(Sender: TObject);
begin
  // triggering events: comboHeadPrintFreq.OnChange;
  inherited;

  if not Loading and not Cancelling then
  begin
    if (comboHeadPrintFreq.ItemIndex >= 3) and rbModflow96.Checked then
    begin
      if (Sender <> rbModflow96) then
      begin
        Beep;
        MessageDlg('Sorry, that option is not allowed with MODFLOW-96',
          mtInformation, [mbOK], 0);
      end;
      comboHeadPrintFreq.ItemIndex := 2;
    end;
  end;

  // if you are going to print heads every N'th time step,
  // you can specify N.
  adeHeadPrintFreq.Enabled := (comboHeadPrintFreq.ItemIndex in [1, 3])
    and comboHeadPrintFreq.Enabled;

  comboHeadPrintStyle.Enabled := (comboHeadPrintFreq.ItemIndex > 0)
    and comboHeadPrintFreq.Enabled;
  SetComboColor(comboHeadPrintStyle);

  comboHeadPrintFormat.Enabled := comboHeadPrintStyle.Enabled;
  SetComboColor(comboHeadPrintFormat);

  EnableSpecifiedOutputControls;
end;

procedure TfrmMODFLOW.comboDrawdownPrintFreqChange(Sender: TObject);
begin
  // triggering events: comboDrawdownPrintFreq.OnChange;
  inherited;

  if not Loading and not Cancelling then
  begin
    if (comboDrawdownPrintFreq.ItemIndex >= 3) and rbModflow96.Checked then
    begin
      if (Sender <> rbModflow96) then
      begin
        Beep;
        MessageDlg('Sorry, that option is not allowed with MODFLOW-96',
          mtInformation, [mbOK], 0);
      end;
      comboDrawdownPrintFreq.ItemIndex := 2;
    end;
  end;

  // if you are going to print drawdown every N'th time step,
  // you can specify N.
  adeDrawdownPrintFreq.Enabled := (comboDrawdownPrintFreq.ItemIndex in [1, 3])
    and comboDrawdownPrintFreq.Enabled;

  comboDrawdownPrintStyle.Enabled := (comboDrawdownPrintFreq.ItemIndex > 0)
    and comboDrawdownPrintFreq.Enabled;
  SetComboColor(comboDrawdownPrintStyle);

  comboDrawdownPrintFormat.Enabled := comboDrawdownPrintStyle.Enabled;
  SetComboColor(comboDrawdownPrintFormat);

  EnableSpecifiedOutputControls;
end;

procedure TfrmMODFLOW.comboBudPrintFreqChange(Sender: TObject);
begin
  // triggering events: comboBudPrintFreq.OnChange;
  inherited;

  if not Loading and not Cancelling then
  begin
    if (comboBudPrintFreq.ItemIndex >= 3) and rbModflow96.Checked then
    begin
      if (Sender <> rbModflow96) then
      begin
        Beep;
        MessageDlg('Sorry, that option is not allowed with MODFLOW-96',
          mtInformation, [mbOK], 0);
      end;
      comboBudPrintFreq.ItemIndex := 2;
    end;
  end;

  // if you are going to print the volumetric budget every N'th time step,
  // you can specify N.
  adeBudPrintFreq.Enabled := (comboBudPrintFreq.ItemIndex in [1, 3]);

  EnableSpecifiedOutputControls;
end;

procedure TfrmMODFLOW.comboHeadExportFreqChange(Sender: TObject);
begin
  // triggering events: comboHeadExportFreq.OnChange;
  inherited;

  if not Loading and not Cancelling then
  begin
    if (comboHeadExportFreq.ItemIndex >= 3) and rbModflow96.Checked then
    begin
      if (Sender <> rbModflow96) then
      begin
        Beep;
        MessageDlg('Sorry, that option is not allowed with MODFLOW-96',
          mtInformation, [mbOK], 0);
      end;
      comboHeadExportFreq.ItemIndex := 2;
    end;
  end;

  // if you are going to exaport heads every N'th time step,
  // you can specify N.
  adeHeadExportFreq.Enabled := (comboHeadExportFreq.ItemIndex in [1,3])
    and comboHeadExportFreq.Enabled;

  EnableSpecifiedOutputControls;
end;

procedure TfrmMODFLOW.comboDrawdownExportFreqChange(Sender: TObject);
begin
  // triggering events: comboDrawdownExportFreq.OnChange;
  inherited;

  if not Loading and not Cancelling then
  begin
    if (comboDrawdownExportFreq.ItemIndex >= 3) and rbModflow96.Checked then
    begin
      if (Sender <> rbModflow96) then
      begin
        Beep;
        MessageDlg('Sorry, that option is not allowed with MODFLOW-96',
          mtInformation, [mbOK], 0);
      end;
      comboDrawdownExportFreq.ItemIndex := 2;
    end;
  end;

  // if you are going to exaport drawdown every N'th time step,
  // you can specify N.
  adeDrawdownExportFreq.Enabled := (comboDrawdownExportFreq.ItemIndex in [1, 3])
    and comboDrawdownExportFreq.Enabled;

  EnableSpecifiedOutputControls;
end;

procedure TfrmMODFLOW.comboBinaryInitialHeadChoiceChange(Sender: TObject);
begin
  inherited;
  EnableBinaryStressPeriodAndTimeStep;
end;

procedure TfrmMODFLOW.comboBudExportFreqChange(Sender: TObject);
begin
  // triggering events: comboBudExportFreq.OnChange;
  inherited;

  if not Loading and not Cancelling then
  begin
    if (comboBudExportFreq.ItemIndex >= 3) and rbModflow96.Checked then
    begin
      if Sender <> rbModflow96 then
      begin
        Beep;
        MessageDlg('Sorry, that option is not allowed with MODFLOW-96',
          mtInformation, [mbOK], 0);
      end;
      comboBudExportFreq.ItemIndex := 2;
    end;
  end;

  // if you are going to exaport flows every N'th time step,
  // you can specify N.
  adeBudExportFreq.Enabled := (comboBudExportFreq.ItemIndex in [1, 3])
    and comboBudExportFreq.Enabled and not cbMODPATH.Checked;

  EnableSpecifiedOutputControls;
end;

procedure TfrmMODFLOW.cbMOC3DClick(Sender: TObject);
var
  MocMessage: string;
begin
  // triggering event: cbMOC3D.OnClick;
  inherited;
  if not Loading and not Cancelling and cbMOC3D.Checked then
  begin
    cbShowProgress.Checked := False;
  end;
  {  if cbMOC3D.Checked and rbMODFLOW2000.Checked and not loading
      and not cancelling then
    begin
      Beep;
      MessageDlg('Warning; The MOC3D interface for MODFLOW-2000 is still being '
        + 'tested. You probably should use MODFLOW-96 instead of MODFLOW-2000.',
        mtWarning, [mbOK], 0);
    end;   }
  {
    rbMODFLOW2000.Enabled := not cbMOC3D.Checked;
    if cbMOC3D.Checked and not loading and not cancelling then
    begin
      rbModflow96.Checked := True;
      Beep;
      MessageDlg('Warning; MOC3D only works with MODFLOW-96 so your model type '
        + 'has been changed to MODFLOW-96', mtWarning, [mbOK], 0);
    end;
  }
  tabMOC3D.TabVisible := cbMOC3D.Checked;
  SetHFB_Caption;
  // Show a warning if the rewetting option and MOC3D are both selected.
  Moc3dWetWarning;

  // Show a warning if the stream and MOC3D are both selected.
  StreamWarning;

  ActivateComboMnwObservations;
  AddOrRemoveMnwObservations;

  // by default, export model with solute transport with MOC3D is selected.
  cbUseSolute.Checked := cbMOC3D.Checked;

  if comboTimeUnits.ItemIndex = 0 then
  begin
    comboTimeUnits.ItemIndex := 1;
  end;
  // if MOC3D and recharge are both selected, you can decide whether to
  // reuse recharge concentrations.
  comboMOC3DReadRech.Enabled := cbRCH.Checked and cbMOC3D.Checked;
  SetComboColor(comboMOC3DReadRech);

  comboMODPATH_RechargeITOP.Enabled := cbRCH.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked));
  SetComboColor(comboMODPATH_RechargeITOP);

  comboMODPATH_EvapITOP.Enabled := (cbEVT.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked)))
    or (cbETS.Checked and cbMOC3D.Checked and cbBFLX.Checked);
  SetComboColor(comboMODPATH_EvapITOP);
  
  adeMOC3DLay1.Enabled := cbMOC3D.Checked;
  adeMOC3DLay2.Enabled := cbMOC3D.Checked;
  cbMOC3DNoDisp.Enabled := (rgMOC3DSolver.ItemIndex in [1,2,4])
    and cbMOC3D.Checked;
  if not cbMOC3DNoDisp.Enabled and not loading and not cancelling then
  begin
    cbMOC3DNoDisp.Checked := False;
  end;
  adeMOC3DDecay.Enabled := cbMOC3D.Checked;
  adeMOC3DDiffus.Enabled := cbMOC3D.Checked;
  comboMOC3DInterp.Enabled := cbMOC3D.Checked;
  adeMOC3DCnoflow.Enabled := cbMOC3D.Checked;
  comboMOC3DSaveWell.Enabled := cbMOC3D.Checked;

  SetComboColor(comboMOC3DInterp);
  SetComboColor(comboMOC3DSaveWell);

  comboMOC3DReadRech.Enabled := cbMOC3D.Checked and cbRCH.Checked;
  SetComboColor(comboMOC3DReadRech);

  // calculate flows between adjacent cells if MOC3D is selected.
  if cbMOC3D.Checked then
  begin
    cbCHTOCH.Checked := True;
  end;

  // prevent the user from not calculating flows
  // between adjacent cells if MOC3D is selected.
  cbCHTOCH.Enabled := not cbMOC3D.Checked;
  if not cbMOC3D.Checked and cbCHTOCH.Checked
    and not Loading and not Cancelling then
  begin
    if rbMODFLOW2000.Checked or rbModflow2005.Checked then
    begin
      MocMessage := 'You have turned off the GWT process.  '
        + 'The GWT process requires that the CHTOCH flag be turned on.   '
        + '(The CHTOCH flag causes MODFLOW-2000 to calculate flow '
        + 'between adjacent constant-head cells.)  Now that you aren''t '
        + 'using the GWT process, using this option is not required.  '
        + 'Do you still want the CHTOCH flag turned on?';
    end
    else
    begin
      MocMessage := 'You have turned off MOC3D.  '
        + 'MOC3D requires that the CHTOCH flag be turned on.  '
        + '(The CHTOCH flag causes MOC3D or MODFLOW to calculate flow '
        + 'between adjacent constant head cells.)  Now that you aren''t '
        + 'using the MOC3D, using this option is not required.  '
        + 'Do you still want the CHTOCH flag turned on?';
    end;
    Beep;
    if MessageDlg(MocMessage, mtInformation, [mbYes, mbNo, mbHelp],
      cbCHTOCH.HelpContext) = mrNo then
    begin
      cbCHTOCH.Checked := False;
    end;
  end;

  // allow the user to assign weight to concentrations in the FHB
  // package if both it and MOC3D are selected.
  adeFHBHeadConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;
  adeFHBFluxConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;

  rgMOC3DSolver.Enabled := cbMOC3D.Checked;
  rgMOC3DSolverClick(Sender);
  EnableMBRP_and_MBIT;
  EnableCCBD;
  EnableVBAL;;

  // add or remove the observation wells layer depending on
  // whether MOC3D are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCTransSubGridLayerType, cbMOC3D.Checked);

  // add or remove the recharge concentration layer depending on
  // whether MOC3D and Recharge are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCRechargeConcLayerType,
    cbRCH.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  // add or remove the observation wells layer depending on
  // whether MOC3D are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCObsWellLayerType, cbMOC3D.Checked);

  // add or remove the initial concentration layers depending on
  // whether MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCInitialConcLayerType, cbMOC3D.Checked);

  // add or remove the porosity layers depending on
  // whether MOC3D or MODPATH are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCPorosityLayerType, PorosityUsed);

  // add or remove the initial concentration parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCInitConcParamType,
    cbMOC3D.Checked);

  // add or remove the prescribed concentration parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCPrescribedConcParamType,
    cbMOC3D.Checked);

  // add or remove the MOC3D subgrid parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCSubGridParamType,
    cbMOC3D.Checked);

  // add or remove the MOC3D porosity parameters on the grid layer
  // depending on whether MOC3D or MODPAHT are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCPorosityParamType,
    PorosityUsed);

  // add or remove the concentration parameters on the prescribed layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMFConcentrationParamType, cbMOC3D.Checked);

  // add or remove the concentration parameters on the well layer
  // depending on whether MOC3D and wells are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbWel.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbWel.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbWel.Checked and
    cbUseAreaWells.Checked);

  // add or remove the concentration parameters on the point river layer
  // depending on whether MOC3D and rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbRiv.Checked);

  // add or remove the concentration parameters on the line river layer
  // depending on whether MOC3D and rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbRiv.Checked);

  // add or remove the concentration parameters on the area river layer
  // depending on whether MOC3D and rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbRiv.Checked and
    cbUseAreaRivers.Checked);

  // add or remove the concentration parameters on the
  // point general-head boundary layers
  // depending on whether MOC3D and general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbGHB.Checked);

  // add or remove the concentration parameters on the
  // line general-head boundary layers
  // depending on whether MOC3D and general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbGHB.Checked);

  // add or remove the concentration parameters on the
  // area general-head boundary layers
  // depending on whether MOC3D and general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbGHB.Checked and
    cbUseAreaGHBs.Checked);

  // add or remove the head concentration parameters on the
  // point flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMFFHBHeadConcParamType,
    cbMOC3D.Checked and cbFHB.Checked);

  // add or remove the flux concentration parameters on the
  // point flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMFFHBFluxConcParamType,
    cbMOC3D.Checked and cbFHB.Checked);

  // add or remove the head concentration parameters on the
  // line flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMFFHBHeadConcParamType,
    cbMOC3D.Checked and cbFHB.Checked);

  // add or remove the flux concentration parameters on the
  // line flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMFFHBFluxConcParamType,
    cbMOC3D.Checked and cbFHB.Checked);

  // add or remove the head concentration parameters on the
  // area flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMFFHBHeadConcParamType,
    cbMOC3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked);

  // add or remove the flux concentration parameters on the
  // area flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMFFHBFluxConcParamType,
    cbMOC3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked);

  // add or remove concentration parameters from the lake
  // layers
  // depending on whether lake boundaries and MOC3D are selected.
  MFLayerStructure.UnIndexedLayers3.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakePrecipConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakeRunoffConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakeAugmentationConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakeInitialConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  // add or remove concentration parameters from the stream
  // layers
  // depending on whether stream boundaries and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2KFlowConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2KPrecipitationConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2KRunoffConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMF2KFlowConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMF2KPrecipitationConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMF2KRunoffConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KFlowConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KPrecipitationConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KRunoffConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KFlowConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KPrecipitationConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KRunoffConcentrationParamType,
    cbMOC3D.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  // add or remove the concentration parameters on the CHD layer
  // depending on whether MOC3D and CHD are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbCHD.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMFConcentrationParamType,
    (cbMOC3D.Checked or cbMT3D.Checked) and cbCHD.Checked and
    cbUseAreaCHD.Checked);

  rgMOC3DSolverClick(nil);

  AddRemoveCHFBParameters;
  AddOrRemoveMnw2LayersAndParameters;

  cbDualPorosityClick(Sender);
  cbSimpleReactionsClick(Sender);
  cbCBDYClick(Sender);
  cbCCBDClick(Sender);

  // update IFACE parameters.
  UpdateIFACE;

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.comboMOC3DConcFreqChange(Sender: TObject);
begin
  // triggering events: comboMOC3DConcFreq.OnChange;
  inherited;

  // If you want to print concentrations Every N'th particle move and
  // you are printing concentrations, then you can set N.
  adeMOC3DConcFreq.Enabled := (comboMOC3DConcFreq.ItemIndex = 3) and
    not (comboMOC3DConcFileType.ItemIndex = 0);

end;

procedure TfrmMODFLOW.comboMOC3DConcFileTypeChange(Sender: TObject);
begin
  // triggering events: comboMOC3DConcFileType.OnChange;
  inherited;

  // if you are going to print a concentration output file, then you can
  // specify how frequently you can print data to it.
  comboMOC3DConcFreq.Enabled := not (comboMOC3DConcFileType.ItemIndex = 0);
  SetComboColor(comboMOC3DConcFreq);

  rgMOC3DConcFormat.Enabled := (comboMOC3DConcFileType.ItemIndex in [1,3]);

  // Determine whether you can set N.
  comboMOC3DConcFreqChange(Sender);
end;

procedure TfrmMODFLOW.comboMOC3DVelFreqChange(Sender: TObject);
begin
  // triggering events: comboMOC3DVelFreq.OnChange;
  inherited;

  // If you want to print velocities Every N'th particle move and
  // you are printing velocities, then you can set N.
  adeMOC3DVelFreq.Enabled := (comboMOC3DVelFreq.ItemIndex = 2) and
    not (comboMOC3DVelFileType.ItemIndex = 0);

end;

procedure TfrmMODFLOW.comboMOC3DVelFileTypeChange(Sender: TObject);
begin
  // triggering events: comboMOC3DVelFileType.OnChange;
  inherited;

  // if you are going to print a velocity output file, then you can
  // specify how frequently you can print data to it.
  comboMOC3DVelFreq.Enabled := not (comboMOC3DVelFileType.ItemIndex = 0);
  SetComboColor(comboMOC3DVelFreq);

  // Determine whether you can set N.
  comboMOC3DVelFreqChange(Sender);
end;

procedure TfrmMODFLOW.comboMOC3DDispFreqChange(Sender: TObject);
begin
  // triggering events: comboMOC3DDispFreq.OnChange;
  inherited;

  // If you want to print dispersion Every N'th particle move,
  // then you can set N.
  adeMOC3DDispFreq.Enabled := (comboMOC3DDispFreq.ItemIndex = 3);

end;

procedure TfrmMODFLOW.comboMOC3DPartFileTypeChange(Sender: TObject);
begin
  // triggering events: comboMOC3DPartFileType.OnChange;
  inherited;

  // if you are going to print a particle locations output file, then you can
  // specify how frequently you can print data to it.
  comboMOC3DPartFreq.Enabled := comboMOC3DPartFileType.Enabled and not
    (comboMOC3DPartFileType.ItemIndex = 0);
  SetComboColor(comboMOC3DPartFreq);

  cbAdjustParticleLocations.Enabled := comboMOC3DPartFreq.Enabled;

  // Determine whether you can set N.
  comboMOC3DPartFreqChange(Sender);
end;

procedure TfrmMODFLOW.sgMOC3DTransParamSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  // triggering events: sgMOC3DTransParam.OnSelectCell;
  inherited;
  PrevMOC3DTransParam := sgMOC3DTransParam.Cells[Col, Row];
  // Determine which cells will be editable.
  // The first row and column need no special treatment.
  if (Row > 0) and (Col > 0) then
  begin
    // If this is the concentration column and you don't need CBOUND
    // then don't allow editting.
    if (Col = Ord(trdConc)) and not CBoundNeeded(Row) then
    begin
      sgMOC3DTransParam.Options := sgMOC3DTransParam.Options - [goEditing];
      //        CanSelect := False;
    end
    else if ((Col = Ord(trdLong)) or (Col = Ord(trdTranHor)) or (Col =
      Ord(trdTranVer)))
      and cbMOC3DNoDisp.Checked then
    begin
      sgMOC3DTransParam.Options := sgMOC3DTransParam.Options - [goEditing];
    end
    else if (Col = Ord(trdRetard)) and cbSimpleReactions.Checked and
      cbUseSimpleReactions.Checked and cbIDKRF.Checked then
    begin
      sgMOC3DTransParam.Options := sgMOC3DTransParam.Options - [goEditing];
    end
    else
    begin
      // Check if the row is inside the transport subgrid
      // check if column is a concentration column and concentration
      // is needed for that row.
      if RowNeeded(Row) or ((Col = Ord(trdConc)) and CBoundNeeded(Row)) then
      begin
        // allow editting
        sgMOC3DTransParam.Options := sgMOC3DTransParam.Options + [goEditing];
        //          CanSelect := True;
      end
      else
      begin
        // don't allow editting.
        sgMOC3DTransParam.Options := sgMOC3DTransParam.Options - [goEditing];
        //          CanSelect := False;
      end;
    end;
  end;

  // refresh the MOC3D tranport parameters grid.
  sgMOC3DTransParam.Invalidate;
end;

procedure TfrmMODFLOW.sgMOC3DTransParamDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  // triggering events: sgMOC3DTransParam.OnDrawCell;
  inherited;

  // set the color of the cells.

  // only change the color of the non-fixed cells.
  if (Row > 0) and (Col > 0) then
  begin
    // set the color to gray if this is a concentration cell
    // and concentration will not be used for it.
    if (Col = Ord(trdConc)) and not CBoundNeeded(Row) then
    begin
      sgMOC3DTransParam.Canvas.Brush.Color := clBtnFace;
    end
    else if ((Col = Ord(trdLong)) or (Col = Ord(trdTranHor)) or (Col =
      Ord(trdTranVer)))
      and cbMOC3DNoDisp.Checked then
    begin
      sgMOC3DTransParam.Canvas.Brush.Color := clBtnFace;
    end
    else if (Col = Ord(trdRetard)) and cbSimpleReactions.Checked and
      cbUseSimpleReactions.Checked and cbIDKRF.Checked then
    begin
      sgMOC3DTransParam.Canvas.Brush.Color := clBtnFace;
    end
    else
    begin
      // check if the row is within the MOC3D subgrid
      if RowNeeded(Row) then
      begin
        // make the color of the cells in the selected row
        // Aqua. Make the rest white.
        if (Row = sgMOC3DTransParam.Row) then
        begin
          sgMOC3DTransParam.Canvas.Brush.Color := clAqua;
        end
        else
        begin
          sgMOC3DTransParam.Canvas.Brush.Color := clWindow;
        end;
      end
      else
      begin
        // for cells outsid the transport subgrid
        // if this is a concentration cell and concentration
        // for it will be used, make the cell white. Otherwise
        // make it gray.
        if (Col = Ord(trdConc)) and CBoundNeeded(Row) then
        begin
          sgMOC3DTransParam.Canvas.Brush.Color := clWindow;
        end
        else
        begin
          sgMOC3DTransParam.Canvas.Brush.Color := clBtnFace;
        end;
      end;
    end;
    // Make the font black
    sgMOC3DTransParam.Canvas.Font.Color := clBlack;
    // draw the text
    sgMOC3DTransParam.Canvas.TextRect
      (Rect, Rect.Left, Rect.Top, sgMOC3DTransParam.Cells[Col, Row]);
    // draw the right and lower cell boundaries in black.
    sgMOC3DTransParam.Canvas.Pen.Color := clBlack;
    sgMOC3DTransParam.Canvas.MoveTo(Rect.Right, Rect.Top);
    sgMOC3DTransParam.Canvas.LineTo(Rect.Right, Rect.Bottom);
    sgMOC3DTransParam.Canvas.LineTo(Rect.Left, Rect.Bottom);
  end;

end;

procedure TfrmMODFLOW.edNumPerEnter(Sender: TObject);
begin
  // triggering event: edNumPer.OnEnter;
  // called by btnInsertTimeClick
  // called by btnAddTimeClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;

  // save the value of the number of periods whenever the user begins
  // to edit it.
  PrevNumPeriods := StrToInt(edNumPer.Text);
end;

procedure TfrmMODFLOW.edNumUnitsEnter(Sender: TObject);
begin
  // triggering event: edNumUnits.OnEnter;
  // called by btnInsertUnitClick
  // called by btnAddUnitClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;
  // store the number of units that were present when the user begins
  // to edit it.
  PrevNumUnits := StrToInt(edNumUnits.Text);
end;

procedure TfrmMODFLOW.edNumUnitsExit(Sender: TObject);
var
  NewNumUnits: integer;
  RowIndex, ColIndex: integer;
begin
  // triggering event: edNumUnits.OnExit;
  // called by btnInsertUnitClick
  // called by btnAddUnitClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;
  try
    begin
      // determine the new number of units.
      NewNumUnits := StrToInt(edNumUnits.Text);

      // update the upper limits on units allowed for the MOC3D subgrid.
      adeMOC3DLay1.Max := StrToInt(edNumUnits.Text);
      adeMOC3DLay2.Max := adeMOC3DLay1.Max;

      // update the number of units used by MOC3D.
      adeMOC3DLayerExit(Sender);

      // If the new number of units is > 0 proceed, otherwise
      // handle the error.
      if NewNumUnits > 0 then
      begin
        // change the number of rows in sgMOC3DTransParam to reflect the
        // new number of units
        
        sgMOC3DTransParam.RowCount := NewNumUnits + 1;
        dgIBS.RowCount := NewNumUnits + 1;

        // If the new number of units is greater than the previous number
        // of units, add more units, otherwise, delete some units.
        if NewNumUnits > PrevNumUnits then
        begin
          // increase the number of rows in dtabGeol to reflect the new
          // number of units.
          dgGeol.RowCount := NewNumUnits + 1;
          rdgSub.HandleNeeded;
          rdgSub.RowCount := dgGeol.RowCount;

          rdgSwt.HandleNeeded;
          rdgSwt.RowCount := dgGeol.RowCount;

          // Copy data into the new cells in dtabGeol.
          for RowIndex := PrevNumUnits to NewNumUnits - 1 do
          begin
            dgGeol.Cells[Ord(nuiN), RowIndex + 1] := IntToStr(RowIndex + 1);
            for ColIndex := 1 to dgGeol.ColCount - 1 do
            begin
              dgGeol.Cells[ColIndex, RowIndex + 1]
                := dgGeol.Cells[ColIndex, RowIndex];
            end;

            rdgSub.Cells[0, RowIndex + 1] := IntToStr(RowIndex + 1);
            for ColIndex := 1 to rdgSub.ColCount - 1 do
            begin
              rdgSub.Cells[ColIndex, RowIndex + 1] := '0';
            end;

            rdgSwt.Cells[0, RowIndex + 1] := IntToStr(RowIndex + 1);
            for ColIndex := 1 to rdgSwt.ColCount - 1 do
            begin
              rdgSwt.Cells[ColIndex, RowIndex + 1] := '0';
            end;

            // for each row of new cells, create a new geologic unit
            // at the end of the layer structure.
            if (Sender <> btnInsertUnit) and not Cancelling then
            begin
              CreateGeologicLayer(-1)
            end;

          end;

          // Copy data into the new cells in sgMOC3DTransParam.
          for RowIndex := PrevNumUnits + 1
            to sgMOC3DTransParam.RowCount - 1 do
          begin
            sgMOC3DTransParam.Cells[Ord(trdN), RowIndex]
              := IntToStr(RowIndex);
            for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
            begin
              sgMOC3DTransParam.Cells[ColIndex, RowIndex]
                := sgMOC3DTransParam.Cells[ColIndex, RowIndex - 1];
            end;
          end;
          // Copy data into the new cells in dgIBS.
          for RowIndex := PrevNumUnits + 1
            to dgIBS.RowCount - 1 do
          begin
            dgIBS.Cells[0, RowIndex] := IntToStr(RowIndex);
            dgIBS.Cells[1, RowIndex] := dgIBS.Columns[1].PickList[0];
            dgIBS.Cells[2, RowIndex] := dgIBS.Columns[2].PickList[0];
            if (Sender <> btnInsertUnit) and not Cancelling then
            begin
              dgIBSSetEditText(dgIBS, 1, RowIndex,
                dgIBS.Columns[1].PickList[0]);
            end;
          end;
        end
        else // If NewNumUnits > PrevNumUnits
        begin
          // delete geologic units
          for RowIndex := PrevNumUnits downto NewNumUnits + 1 do
          begin
            if (Sender <> btnDeleteUnit) and not Cancelling then
            begin
              DeleteGeologicLayer(RowIndex - 1);
            end;
          end;
          dgGeol.RowCount := NewNumUnits + 1;
        end;

      end
      else // if NewNumUnits >0
      begin
        // prevent the number of units from being less than 1.
        Beep;
        edNumUnits.Text := IntToStr(PrevNumUnits);
      end;
      // enable delete button if the new number of units > 1
      btnDeleteUnit.Enabled := (StrToInt(edNumUnits.Text) > 1);
      if not (Sender = btnDeleteUnit) and not (Sender = btnInsertUnit) then
      begin
        // make lists of the current geologic units.
        // This re-creates the GeologicUnitsList used in step 3.
        AssociateUnits;
      end;

      if (Sender <> btnDeleteUnit) and (Sender <> btnInsertUnit) then
      begin
        AddHeadObsWeights(NewNumUnits);
      end;
    end;
    LabelUnits(dgGeol);
    // begin MT3D
    if NewNumUnits > PrevNumUnits then
    begin
      sgReaction.RowCount := NewNumUnits + 1;
      for RowIndex := PrevNumUnits + 1 to sgReaction.RowCount - 1 do
      begin
        sgReaction.Cells[Ord(rdmN), RowIndex] := IntToStr(RowIndex);
        sgReaction.Cells[Ord(rdmName), RowIndex] := dgGeol.Cells[Ord(nuiName),
          RowIndex];
        for ColIndex := 2 to sgReaction.ColCount - 1 do
        begin
          sgReaction.Cells[ColIndex, RowIndex]
            := sgReaction.Cells[ColIndex, RowIndex - 1];
        end;
      end;

      sgDispersion.RowCount := NewNumUnits + 1;
      for RowIndex := PrevNumUnits + 1 to sgDispersion.RowCount - 1 do
      begin
        sgDispersion.Cells[Ord(ddmN), RowIndex] := IntToStr(RowIndex);
        sgDispersion.Cells[Ord(ddmName), RowIndex] := dgGeol.Cells[Ord(nuiName),
          RowIndex];
        for ColIndex := 2 to sgReaction.ColCount - 1 do
        begin
          sgDispersion.Cells[ColIndex, RowIndex]
            := sgDispersion.Cells[ColIndex, RowIndex - 1];
        end;
      end;

    end
    else
    begin
      if Sender <> btnDeleteUnit then
      begin
        sgReaction.RowCount := NewNumUnits + 1;
        sgDispersion.RowCount := NewNumUnits + 1;
      end;
    end;
    // end MT3D
  except on EConvertError do
    begin
      // check to make sure there is no conversion error. If there is one,
      // fix it.
      edNumUnits.Text := IntToStr(PrevNumUnits);
    end;
  end;

  UpdateHufLVDA_Units;
  UpdateConcObsWeights;

  MFLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow(
    ModflowTypes.GetMFHydmodLayerType,
    ModflowTypes.GetMFHydmodModflowLayerParamType,
    ModflowTypes.GetMFHydmodModflowLayerParamType.ANE_ParamName,
    True);
end;

procedure TfrmMODFLOW.FixInstanceCounts;
var
  dgList: TList;
  DGIndex, RowIndex: integer;
  ADataGrid: TDataGrid;
  CanSelect: Boolean;
begin
  if not Loading and not cancelling then
  begin
    dgList := TList.Create;
    try
      dgList.Add(dgRCHParametersN);
      dgList.Add(dgEVTParametersN);
      dgList.Add(dgETSParametersN);
      for DGIndex := 0 to dgList.Count - 1 do
      begin
        ADataGrid := dgList[DGIndex];
        if Assigned(ADataGrid.OnSetEditText) then
        begin
          for RowIndex := 1 to ADataGrid.RowCount - 1 do
          begin
            if Assigned(ADataGrid.OnSelectCell) then
            begin
              ADataGrid.OnSelectCell(ADataGrid, 4, RowIndex, CanSelect);
            end;

            ADataGrid.OnSetEditText(ADataGrid, 4, RowIndex, ADataGrid.Cells[4,
              RowIndex]);
          end;
        end;
      end;

      dgList.Clear;
      dgList.Add(dgRIVParametersN);
      dgList.Add(dgWELParametersN);
      dgList.Add(dgDRNParametersN);
      dgList.Add(dgGHBParametersN);
      dgList.Add(dgSFRParametersN);
      dgList.Add(dgSTRParametersN);
      dgList.Add(dgDRTParametersN);
      dgList.Add(dgCHDParameters);
      for DGIndex := 0 to dgList.Count - 1 do
      begin
        ADataGrid := dgList[DGIndex];
        if Assigned(ADataGrid.OnSetEditText) then
        begin
          for RowIndex := 1 to ADataGrid.RowCount - 1 do
          begin
            ADataGrid.OnSetEditText(ADataGrid, 3, RowIndex, ADataGrid.Cells[3,
              RowIndex]);
          end;
        end;
      end;
    finally
      dgList.Free;
    end;
  end;
end;

procedure TfrmMODFLOW.edNumPerExit(Sender: TObject);
var
  RowIndex: integer;
  procedure AddStressPeriodParamChoice(ADataGrid: TDataGrid;
    ParamColIndex, SP1_Column: integer);
  var
    ParamRowIndex: integer;
  begin
    ADataGrid.Columns[ParamColIndex].Title.Caption
      := 'S. Per. ' + IntToStr(RowIndex);
    ADataGrid.Columns[ParamColIndex].PickList :=
      ADataGrid.Columns[SP1_Column].PickList;
    ADataGrid.Columns[ParamColIndex].LimitToList := True;
    for ParamRowIndex := 1 to ADataGrid.RowCount - 1 do
    begin
      if not loading and not cancelling then
      begin
        ADataGrid.Cells[ParamColIndex, ParamRowIndex]
          := ADataGrid.Columns[ParamColIndex].PickList[1];
      end;
    end;

  end;
var
  NewNumPeriods: integer;
  ColIndex: integer;
  ParamColIndex: integer;
begin
  // triggering event: edNumPer.OnExit;
  // called by btnInsertTimeClick
  // called by btnAddTimeClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;
  UpdateGwmStateSP_Limits;
  AssociateTimes;
  try
    // get the new number of periods
    NewNumPeriods := StrToInt(edNumPer.Text);
    if (PrevNumPeriods = 1) and (NewNumPeriods > 1) and not Loading
      and not Importing
      and (comboSteady.ItemIndex = 1) then
    begin
      Beep;
      if MessageDlg('Do you wish to switch to a transient model?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        comboSteady.ItemIndex := 0;
        comboSteadyChange(comboSteady);
      end;
    end;

    // Check that the new number of periods is valid.
    if NewNumPeriods > 0 then
    begin
      // The maximum period that can be specified for MODPATH is
      // the new number of periods.
      adeModpathBeginPeriod.Max := NewNumPeriods;
      adeModpathEndPeriod.Max := NewNumPeriods;
      adeMPATHRefPeriod.Max := NewNumPeriods;
      adeStartTransportStressPeriod.Max := NewNumPeriods;

      // check if number of periods is greater than before.
      if NewNumPeriods > PrevNumPeriods then
      begin
        // set the number of rows in the time grid to the proper number.
        dgTime.RowCount := NewNumPeriods + 1;
        dgRCHParametersN.ColCount := NewNumPeriods + 5;
        dgEVTParametersN.ColCount := NewNumPeriods + 5;
        dgETSParametersN.ColCount := NewNumPeriods + 5;
        dgRIVParametersN.ColCount := NewNumPeriods + 4;
        dgWELParametersN.ColCount := NewNumPeriods + 4;
        dgDRNParametersN.ColCount := NewNumPeriods + 4;
        dgGHBParametersN.ColCount := NewNumPeriods + 4;
        dgSFRParametersN.ColCount := NewNumPeriods + 4;
        dgSTRParametersN.ColCount := NewNumPeriods + 4;
        dgDRTParametersN.ColCount := NewNumPeriods + 4;
        dgCHDParameters.ColCount := NewNumPeriods + 4;

        // copy data into the new rows.
        for RowIndex := PrevNumPeriods + 1 to dgTime.RowCount - 1 do
        begin
          // label the first column of the new row
          dgTime.Cells[Ord(tdN), RowIndex] := IntToStr(RowIndex);

          // copy data from earlier row.
          for ColIndex := 1 to dgTime.ColCount - 1 do
          begin
            if (ColIndex <> Ord(tdRefStrPeriod))
              or (Sender = btnInsertTime) then
            begin
              dgTime.Cells[ColIndex, RowIndex]
                := dgTime.Cells[ColIndex, RowIndex - 1];
            end
            else
            begin
              dgTime.Cells[ColIndex, RowIndex]
                := dgTime.Columns[ColIndex].PickList[0];
            end;
          end;

          // unless you are inserting a new time step
          // add new time parameters.
          if not (Sender = btnInsertTime) then
          begin
            InsertTimeParameters(-1);
          end;

          ParamColIndex := RowIndex + 4;

          AddStressPeriodParamChoice(dgRCHParametersN, ParamColIndex, 5);
          AddStressPeriodParamChoice(dgEVTParametersN, ParamColIndex, 5);
          AddStressPeriodParamChoice(dgETSParametersN, ParamColIndex, 5);
          ParamColIndex := RowIndex + 3;
          AddStressPeriodParamChoice(dgRIVParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgWELParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgDRNParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgGHBParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgSFRParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgSTRParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgDRTParametersN, ParamColIndex, 4);
          AddStressPeriodParamChoice(dgCHDParameters, ParamColIndex, 4);

        end;
        MFLayerStructure.SetAllParamUnits;
      end
      else if NewNumPeriods < PrevNumPeriods then
      begin
        // The number of periods has declined.
        dgRCHParametersN.ColCount := NewNumPeriods + 5;
        dgEVTParametersN.ColCount := NewNumPeriods + 5;
        dgETSParametersN.ColCount := NewNumPeriods + 5;
        dgRIVParametersN.ColCount := NewNumPeriods + 4;
        dgWELParametersN.ColCount := NewNumPeriods + 4;
        dgDRNParametersN.ColCount := NewNumPeriods + 4;
        dgGHBParametersN.ColCount := NewNumPeriods + 4;
        dgSFRParametersN.ColCount := NewNumPeriods + 4;
        dgSTRParametersN.ColCount := NewNumPeriods + 4;
        dgDRTParametersN.ColCount := NewNumPeriods + 4;
        dgCHDParameters.ColCount := NewNumPeriods + 4;

        if not (Sender = btnDeleteTime) then
        begin
          // unless you are deleting a specific time step
          // delete the time parameters for the rows that are
          // being deleted
          for RowIndex := dgTime.RowCount - 1 downto NewNumPeriods + 1 do
          begin
            DeleteTimeParameters(RowIndex);
          end;
        end;

        // set the number of rows to the correct number.
        dgTime.RowCount := NewNumPeriods + 1;
        MFLayerStructure.SetAllParamUnits;
      end;
    end
    else // if NewNumPeriods >0
    begin
      // if the new number of periods is invalid, go back to
      // the previous number.
      edNumPer.Text := IntToStr(PrevNumPeriods);
      Beep;
    end;

    // if there are 2 or more time periods, you can delete time periods.
    btnDeleteTime.Enabled := (dgTime.RowCount > 2);

    // if you have added or deleted time parameters make new lists of
    // time parameters.
    if not (Sender = btnInsertTime) and not (Sender = btnDeleteTime) then
    begin
      AssociateTimes;
    end;

    // If you are using Flow-and-head boundaries, and you have multiple
    // steady state models, you can choose whether or not to interpolate
    // flow-and-head boundaries.
    comboFHBSteadyStateOption.Enabled
      := (comboSteady.ItemIndex = 1) and cbFHB.Checked
      and (dgTime.RowCount > 2);

    SetComboColor(comboFHBSteadyStateOption);
    LabelUnits(dgTime);

    FixInstanceCounts;

    // begin MT3D
    if NewNumPeriods > PrevNumPeriods then
    begin
      sgMT3DTime.RowCount := NewNumPeriods + 1;
      for RowIndex := PrevNumPeriods + 1 to sgMT3DTime.RowCount - 1 do
      begin
        sgMT3DTime.Cells[Ord(tdN), RowIndex] := IntToStr(RowIndex);
        for ColIndex := 1 to sgMT3DTime.ColCount - 1 do
        begin
          sgMT3DTime.Cells[ColIndex, RowIndex]
            := sgMT3DTime.Cells[ColIndex, RowIndex - 1];
        end;
      end;
    end
    else
    begin
      sgMT3DTime.RowCount := NewNumPeriods + 1;
    end;

    // end MT3D

    AdjustGWM_TimeDataGrids;
  except on EConvertError do
    begin
      // if the user enters a non-number, go back to the old version.
      edNumPer.Text := IntToStr(PrevNumPeriods);
      Beep;
    end;
  end;
end;

procedure TfrmMODFLOW.AdjustGWM_TimeDataGrids;
Const
  FirstStressPeriodCol = 4;
var
  NewNumPeriods: integer;
  RowIndex: integer;
  ColIndex: integer;
begin
  NewNumPeriods := StrToInt(edNumPer.Text);
  frameGWM_External.dgVariables.ColCount :=
    FirstStressPeriodCol + NewNumPeriods;
  for ColIndex := PrevNumPeriods + FirstStressPeriodCol to
    frameGWM_External.dgVariables.ColCount -1 do
  begin
    frameGWM_External.dgVariables.Columns[ColIndex].Format := rcf2Boolean;
    frameGWM_External.dgVariables.ColWidths[ColIndex] :=
      frameGWM_External.dgVariables.ColWidths[Ord(gecSP1)];
    frameGWM_External.dgVariables.Cells[ColIndex, 0] := 'SP ' +
      IntToStr(ColIndex - FirstStressPeriodCol + 1);
  end;
  for RowIndex := 1 to frameGWM_External.dgVariables.RowCount -1 do
  begin
    for ColIndex := PrevNumPeriods + FirstStressPeriodCol to
      frameGWM_External.dgVariables.ColCount -1  do
    begin
      frameGWM_External.dgVariables.CheckState[ColIndex,RowIndex] :=
        frameGWM_External.dgVariables.CheckState[ColIndex-1,RowIndex];
    end;
  end;
end;

procedure TfrmMODFLOW.LabelUnits(AStringGrid: TStringGrid);
var
  RowIndex: integer;
begin
  for RowIndex := 1 to AStringGrid.RowCount - 1 do
  begin
    AStringGrid.Cells[0, RowIndex] := IntToStr(RowIndex);
  end;
end;

procedure TfrmMODFLOW.sgTimeDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // triggering event: dgTime.OnDrawCell;
  inherited;

  // You only need to draw the cell if it is a call that is not in a
  // fixed row or column
  if (Row > 0) and (Col > 0) then
  begin
    // The cell that displays the length of the first step is always gray.
    if (Col = Ord(tdFirstStep))
      or ((Col in [Ord(tdSsTr), Ord(tdRefStrPeriod)]) and rbModflow96.Checked) then
    begin
      dgTime.Canvas.Brush.Color := clBtnFace;
    end
      // if the cell is selected make it aqua
      // otherwise make it gray.
    else if (Row = dgTime.Row) then
    begin
      dgTime.Canvas.Brush.Color := clAqua;
    end
    else
    begin
      dgTime.Canvas.Brush.Color := clWindow;
    end;
    // set the font color
    dgTime.Canvas.Font.Color := clBlack;
    // draw the text
    dgTime.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, dgTime.Cells[Col,
      Row]);
    // draw the right and lower cell boundaries in black.
    dgTime.Canvas.Pen.Color := clBlack;
    dgTime.Canvas.MoveTo(Rect.Right, Rect.Top);
    dgTime.Canvas.LineTo(Rect.Right, Rect.Bottom);
    dgTime.Canvas.LineTo(Rect.Left, Rect.Bottom);
  end;

end;

procedure TfrmMODFLOW.sgMOC3DParticlesSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  // triggering events: sgMOC3DParticles.OnSelectCell;
  inherited;

  // save the current text of the cell so you can restore it if needed
  PreviousParticleText := sgMOC3DParticles.Cells[Col, Row];

  // redraw the grid to show the selected row.
  sgMOC3DParticles.Invalidate;
end;

procedure TfrmMODFLOW.sgTimeSelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
begin
  // triggering event: dgTime.OnSelectCell;
  inherited;

  // if the cell displays the length of the first time step,
  // don't allow editting. Otherwise, allow editting.
  if (Col = Ord(tdFirstStep))
    or ((Col in [Ord(tdSsTr), Ord(tdRefStrPeriod)]) and rbModflow96.Checked) then
  begin
    CanSelect := False;
  end
  else
  begin
    CanSelect := True;
  end;

  // redraw the grid to show the currently selected row.
  dgTime.Invalidate;

  // save the contents of the current cell so you can restore it if needed.
  LastTimeText := dgTime.Cells[Col, Row];
end;

procedure TfrmMODFLOW.btnMOC3DParticleAddClick(Sender: TObject);
begin
  // triggering events: btnMOC3DParticleAdd.OnClick;
  inherited;

  // Add new particles the same way a user would.

  // increase the number in that box by 1.
  edMOC3DInitParticles.Text := IntToStr(StrToInt(edMOC3DInitParticles.Text) +
    1);

  // leave the edit box.
  edMOC3DInitParticlesExit(Sender);
end;

procedure TfrmMODFLOW.cbCustomParticleClick(Sender: TObject);
begin
  // triggering events: edMOC3DInitParticles.OnClick;
  inherited;

  // if the user chooses custom particle placement, enable
  // the appropriate grid.
  sgMOC3DParticles.Enabled := cbCustomParticle.Enabled and cbCustomParticle.Checked;
  btnDistributeParticles.Enabled := cbCustomParticle.Enabled and cbCustomParticle.Checked;
  // set the color the custom particle placement grid
  // depending on whether or not it is enabled.
  if sgMOC3DParticles.Enabled then
  begin
    sgMOC3DParticles.Color := clWindow;
  end
  else
  begin
    sgMOC3DParticles.Color := clInactiveBorder;
  end;
  // enable the add particle button when custom particle placement
  // is selected.
  btnMOC3DParticleAdd.Enabled := cbCustomParticle.Enabled and cbCustomParticle.Checked;

  // enable the delete particle button when custom particle placement
  // is selected and there is more than one particle.
  btnMOC3DParticleDelete.Enabled := cbCustomParticle.Enabled and cbCustomParticle.Checked
    and (sgMOC3DParticles.RowCount > 2);

  // make sure the custom particle grid contains all valid numbers.
  sgMOC3DParticlesExit(Sender);

  edMOC3DInitParticlesExit(Sender);
end;

procedure TfrmMODFLOW.btnMOC3DParticleDeleteClick(Sender: TObject);
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
begin
  // triggering events: btnMOC3DParticleDelete.OnClick;
  inherited;

  // confirm that the user wishes to delete the particle.
  Beep;
  if MessageDlg('Are you sure you wish to delete this particle?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
  begin
    // get the currently selected row.
    CurrentRow := sgMOC3DParticles.Row;

    // move data from later in the grid over the row containing
    // the data for the particle to be deleted
    for RowIndex := CurrentRow + 1 to sgMOC3DParticles.RowCount - 1 do
    begin
      for ColIndex := 1 to sgMOC3DParticles.ColCount - 1 do
      begin
        sgMOC3DParticles.Cells[ColIndex, RowIndex - 1]
          := sgMOC3DParticles.Cells[ColIndex, RowIndex];
      end;
    end;

    // decrease the number of rows in the particle grid by 1.
    sgMOC3DParticles.RowCount := sgMOC3DParticles.RowCount - 1;

    // check that all cells contain valid numbers.
    sgMOC3DParticlesExit(Sender);

    // enable the delete particle button if there are more than 1 particle
    // and custon particle placement has been seledcted.
    btnMOC3DParticleDelete.Enabled := cbCustomParticle.Checked
      and (sgMOC3DParticles.RowCount > 2);

    // reduce the number of particles by 1.
    edMOC3DInitParticles.Text :=
      IntToStr(StrToInt(edMOC3DInitParticles.Text) - 1);

  end;
end;

procedure TfrmMODFLOW.btnInsertUnitClick(Sender: TObject);
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
  PositionToInsert: integer;

  AGeologicUnit: T_ANE_IndexedLayerList;
begin
  // triggering event: btnInsertUnit.OnClick;
  inherited;

  //1. first add another line to the grid displaying the geologic units.
  edNumUnitsEnter(Sender);
  edNumUnits.Text := IntToStr(StrToInt(edNumUnits.Text) + 1);
  edNumUnitsExit(Sender);

  //2. Copy data in dtabGeol that will follow the newly inserted geologic unit
  // to their new positions.
{  CurrentRow := dtabGeol.RowSet.GetSelect(-1);
  for RowIndex := dtabGeol.RowSet.Count -2 downto CurrentRow do
  begin
    for ColIndex := 0 to dtabGeol.ColumnSet.Count -1 do
    begin
      dtabGeol.CellSet.Item[RowIndex +1,ColIndex].Value :=
         dtabGeol.CellSet.Item[RowIndex,ColIndex].Value;
    end;
  end;  }

  CurrentRow := GeologyRow;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  for RowIndex := dgGeol.RowCount - 2 downto CurrentRow do
  begin
    // number the first column
    dgGeol.Cells[0, RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to dgGeol.ColCount - 1 do
    begin
      dgGeol.Cells[ColIndex, RowIndex + 1] := dgGeol.Cells[ColIndex, RowIndex];
    end;
    if (RowIndex + 1 > 1) then
    begin
      if dgGeol.Cells[Ord(nuiType), RowIndex + 1] =
        dgGeol.Columns[Ord(nuiType)].PickList[1] then
      begin
        dgGeol.Cells[Ord(nuiType), RowIndex + 1] :=
          dgGeol.Columns[Ord(nuiType)].PickList[3]
      end;
    end;
  end;

  for RowIndex := rdgSub.RowCount - 2 downto CurrentRow do
  begin
    // number the first column
    rdgSub.Cells[0, RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to rdgSub.ColCount - 1 do
    begin
      rdgSub.Cells[ColIndex, RowIndex + 1] := rdgSub.Cells[ColIndex, RowIndex];
    end;
  end;
  rdgSub.Cells[1, CurrentRow] := '0';
  rdgSub.Cells[2, CurrentRow] := '0';

  for RowIndex := rdgSwt.RowCount - 2 downto CurrentRow do
  begin
    // number the first column
    rdgSwt.Cells[0, RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to rdgSwt.ColCount - 1 do
    begin
      rdgSwt.Cells[ColIndex, RowIndex + 1] := rdgSwt.Cells[ColIndex, RowIndex];
    end;
  end;
  rdgSwt.Cells[1, CurrentRow] := '0';

  //3. Determine where in the layer structure the new unit should be inserted.
  if CurrentRow = 0 then
  begin
    PositionToInsert := 0;
  end
  else
  begin
    AGeologicUnit := GeologicUnitsList.Items[CurrentRow - 1];
    PositionToInsert := MFLayerStructure.ListsOfIndexedLayers.
      IndexOf(AGeologicUnit as ModflowTypes.GetGeologicUnitType);
  end;

  //4. Create a new geologic unit at the correct position.
  CreateGeologicLayer(PositionToInsert);

  //5. Copy data in sgMOC3DTransParam that will follow the newly inserted
  // geologic unit to their new positions.
  for RowIndex := sgMOC3DTransParam.RowCount - 2 downto CurrentRow do
  begin
    sgMOC3DTransParam.Cells[0, RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
    begin
      sgMOC3DTransParam.Cells[ColIndex, RowIndex + 1]
        := sgMOC3DTransParam.Cells[ColIndex, RowIndex];
    end;
  end;
  //5. Copy data in dgIBS that will follow the newly inserted
  // geologic unit to their new positions.

  for RowIndex := dgIBS.RowCount - 2 downto CurrentRow do
  begin
    dgIBS.Cells[0, RowIndex] := IntToStr(RowIndex);
    dgIBS.Cells[1, RowIndex + 1] := dgIBS.Cells[1, RowIndex];
    dgIBS.Cells[2, RowIndex + 1] := dgIBS.Cells[2, RowIndex];
    dgIBSSetEditText(dgIBS, 1, RowIndex + 1, dgIBS.Cells[1, RowIndex + 1]);
  end;
  dgIBS.Cells[1, CurrentRow] := dgIBS.Columns[1].PickList[0];
  dgIBS.Cells[2, CurrentRow] := dgIBS.Columns[2].PickList[0];
  dgIBSSetEditText(dgIBS, 1, CurrentRow, dgIBS.Cells[1, CurrentRow]);

  InsertHeadObsWeights(CurrentRow);

  //6. make lists of the current geologic units.
  // This re-creates the GeologicUnitsList used in step 3.
  AssociateUnits;

  // begin MT3D
  CurrentRow := dgGeol.Selection.Top;

  for RowIndex := sgReaction.RowCount - 2 downto CurrentRow do
  begin
    sgReaction.Cells[0, RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgReaction.ColCount - 1 do
    begin
      sgReaction.Cells[ColIndex, RowIndex + 1] := sgReaction.Cells[ColIndex,
        RowIndex];
    end;
  end;

  for RowIndex := sgDispersion.RowCount - 2 downto CurrentRow do
  begin
    sgDispersion.Cells[0, RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgDispersion.ColCount - 1 do
    begin
      sgDispersion.Cells[ColIndex, RowIndex + 1] := sgDispersion.Cells[ColIndex,
        RowIndex];
    end;
  end;
  UpdateConcObsWeights;
  // end MT3D

end;

procedure TfrmMODFLOW.btnInsertGwmStorageStateVarClick(Sender: TObject);
begin
  inherited;
  if rdgGwmStorageVariables.SelectedRow >= 1 then
  begin
    rdeGwmStorageStateVarCountEnter(nil);
    FChangingGwmStateRow := True;
    try
      rdgGwmStorageVariables.InsertRow(rdgGwmStorageVariables.SelectedRow);
    finally
      FChangingGwmStateRow := False;
    end;
    rdeGwmStorageStateVarCount.Text :=
      IntToStr(StrToInt(rdeGwmStorageStateVarCount.Output)+1);
    rdeGwmStorageStateVarCountExit(nil);
  end;
end;

procedure TfrmMODFLOW.btnInsertTimeClick(Sender: TObject);
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
  PostionToInsert: integer;
  ListOfParameterLists: TList;
  AnIndexedParameterList: T_ANE_IndexedParameterList;
begin
  // triggering event: btnInsertTime.OnClick;
  inherited;
  AssociateTimes;

  // first increase the number of periods by 1.
  edNumPerEnter(Sender);
  edNumPer.Text := IntToStr(StrToInt(edNumPer.Text) + 1);
  edNumPerExit(Sender);

  // get the current row.
  CurrentRow := dgTime.Row;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  for RowIndex := dgTime.RowCount - 2 downto CurrentRow do
  begin
    // number the first column
    dgTime.Cells[0, RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to dgTime.ColCount - 1 do
    begin
      dgTime.Cells[ColIndex, RowIndex + 1] := dgTime.Cells[ColIndex, RowIndex];
    end;
  end;
  dgTime.Cells[Ord(tdRefStrPeriod), CurrentRow] :=
    dgTime.Columns[Ord(tdRefStrPeriod)].PickList[0];

  // enable delete button if there are at least two time periods.
  btnDeleteTime.Enabled := (dgTime.RowCount > 2);

  // get the list of time-related parameters for the currently selected
  // row.
  ListOfParameterLists := dgTime.Objects[0, CurrentRow] as TList;

  // determine where new time-related parameters should be inserted into
  // the layer structure.
  if ListOfParameterLists.Count > 0 then
  begin
    // for the first row, insert time related parameters at the beginning
    if CurrentRow = 1 then
    begin
      PostionToInsert := 0
    end
    else
    begin
      // for other rows, get an indexed parameter list associated with
      // the current time step and
      // insert the new parameters before that one.
      AnIndexedParameterList := ListOfParameterLists.Items[0];
      PostionToInsert := AnIndexedParameterList.GetIndex;
    end;
    // create new time-related parameters at the position indicated by
    // PostionToInsert
    InsertTimeParameters(PostionToInsert);
  end;

  // associate all the time-related parameters with the object properties
  // of the first cell in each row of the time grid.
  AssociateTimes;

  // begin MT3D
  //  CurrentRow := dgTime.Selection.Top;
  for RowIndex := sgMT3DTime.RowCount - 2 downto CurrentRow do
  begin
    sgMT3DTime.Cells[0, RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgMT3DTime.ColCount - 1 do
    begin
      sgMT3DTime.Cells[ColIndex, RowIndex + 1] := sgMT3DTime.Cells[ColIndex,
        RowIndex];
    end;
  end;
  // end MT3D
end;

procedure TfrmMODFLOW.btnDeleteUnitClick(Sender: TObject);
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
begin
  // triggering event: btnDeleteUnit.OnClick;
  inherited;
  // Get the currently selected row in dtabGeol.
//  CurrentRow := dtabGeol.RowSet.GetSelect(-1);

  // get the currently selected row.
  CurrentRow := GeologyRow;
  if CurrentRow > dgGeol.RowCount - 1 then
  begin
    CurrentRow := dgGeol.RowCount - 1
  end;

  // If a row is selected in dtabGeol, proceed
  if CurrentRow >= 0 then
  begin
    // remove the currently selected row from dgGeol and rdgSub.
    dgGeol.DeleteRow(CurrentRow);
    rdgSub.DeleteRow(CurrentRow);
    rdgSwt.DeleteRow(CurrentRow);

    // Delete the geologic unit associated with the row that was just removed.
    DeleteGeologicLayer(CurrentRow - 1);

    // Copy data in sgMOC3DTransParam to their new positions.
    for RowIndex := CurrentRow + 1 to sgMOC3DTransParam.RowCount - 1 do
    begin
      for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
      begin
        sgMOC3DTransParam.Cells[ColIndex, RowIndex - 1]
          := sgMOC3DTransParam.Cells[ColIndex, RowIndex];
      end;
    end;
    // decrease the number of rows in sgMOC3DTransParam to the correct number.
    sgMOC3DTransParam.RowCount := sgMOC3DTransParam.RowCount - 1;

    for RowIndex := CurrentRow + 1 to dgIBS.RowCount - 1 do
    begin
      for ColIndex := 1 to dgIBS.ColCount - 1 do
      begin
        dgIBS.Cells[ColIndex, RowIndex - 1]
          := dgIBS.Cells[ColIndex, RowIndex];
      end;
    end;
    dgIBS.RowCount := dgIBS.RowCount - 1;

    // Change the number of units to the correct number.
    edNumUnits.Text := IntToStr(dgGeol.RowCount - 1);

    // Disable the delete button if there is only one geologic unit left.
    // Otherwise, enable it.
    btnDeleteUnit.Enabled := (dgGeol.RowCount > 2);

    DeleteHeadObsWeights(CurrentRow);

    //6. make lists of the current geologic units.
    AssociateUnits;

    // make sure a valid row is selected.
    if dgGeol.Row > dgGeol.RowCount - 1 then
    begin
      dgGeol.Row := dgGeol.RowCount - 1;
    end;
  end;
    // fix the titles for the geologic units after the
    // geologic unit to be deleted.
  LabelUnits(dgGeol);
  LabelUnits(rdgSub);
  LabelUnits(rdgSwt);

  CurrentRow := dgGeol.Selection.Top;

  for RowIndex := CurrentRow + 1 to sgReaction.RowCount - 1 do
  begin
    for ColIndex := 1 to sgReaction.ColCount - 1 do
    begin
      sgReaction.Cells[ColIndex, RowIndex - 1] := sgReaction.Cells[ColIndex,
        RowIndex];
    end;
  end;
  sgReaction.RowCount := sgReaction.RowCount - 1;

  for RowIndex := CurrentRow + 1 to sgDispersion.RowCount - 1 do
  begin
    for ColIndex := 1 to sgDispersion.ColCount - 1 do
    begin
      sgDispersion.Cells[ColIndex, RowIndex - 1] := sgDispersion.Cells[ColIndex,
        RowIndex];
    end;
  end;
  sgDispersion.RowCount := sgDispersion.RowCount - 1;
  UpdateConcObsWeights;
end;

procedure TfrmMODFLOW.btnDeleteTimeClick(Sender: TObject);
var
  CurrentRow: integer;
  RowIndex, ColIndex: integer;
  NewNumPeriods: Integer;
begin
  // triggering event: btnDeleteTime.OnClick;
  inherited;
  AssociateTimes;

  // get the currently selected fow.
  CurrentRow := dgTime.Row;

  // copy data from later time steps over the data for the time
  // step to be deleted.
  for RowIndex := CurrentRow + 1 to dgTime.RowCount - 1 do
  begin
    for ColIndex := 1 to dgTime.ColCount - 1 do
    begin
      dgTime.Cells[ColIndex, RowIndex - 1] := dgTime.Cells[ColIndex, RowIndex];
    end;
  end;

  // get the new number of periods
  NewNumPeriods := StrToInt(edNumPer.Text) - 1;

  // the maximum allowed period for MODPATH must be updated.
  adeModpathBeginPeriod.Max := NewNumPeriods;
  adeModpathEndPeriod.Max := NewNumPeriods;
  adeMPATHRefPeriod.Max := NewNumPeriods;

  // store the new number of periods
  edNumPer.Text := IntToStr(NewNumPeriods);
  dgRCHParametersN.ColCount := NewNumPeriods + 5;
  dgEVTParametersN.ColCount := NewNumPeriods + 5;
  dgETSParametersN.ColCount := NewNumPeriods + 5;
  dgRIVParametersN.ColCount := NewNumPeriods + 4;
  dgWELParametersN.ColCount := NewNumPeriods + 4;
  dgDRNParametersN.ColCount := NewNumPeriods + 4;
  dgGHBParametersN.ColCount := NewNumPeriods + 4;
  dgSFRParametersN.ColCount := NewNumPeriods + 4;
  dgSTRParametersN.ColCount := NewNumPeriods + 4;
  dgDRTParametersN.ColCount := NewNumPeriods + 4;
  dgCHDParameters.ColCount := NewNumPeriods + 4;

  // decrease the number of rows in the time grid by one.
  dgTime.RowCount := dgTime.RowCount - 1;

  // enable the delete button if there are at least two time periods.
  btnDeleteTime.Enabled := (dgTime.RowCount > 2);

  // delete the time-related parameters for the current time step
  // from the layer structure
  DeleteTimeParameters(CurrentRow);

  // If you are using Flow-and-head boundaries, and you have multiple
  // steady state models, you can choose whether or not to interpolate
  // flow-and-head boundaries.
  comboFHBSteadyStateOption.Enabled
    := (comboSteady.ItemIndex = 1) and cbFHB.Checked
    and (dgTime.RowCount > 2);

  SetComboColor(comboFHBSteadyStateOption);

  LabelUnits(dgTime);

  // associate all the time-related parameters with the object properties
  // of the first cell in each row of the time grid.
  AssociateTimes;
  FixInstanceCounts;
  //  comboRchSteadyChange(Sender);

  // begin MT3D
  //  CurrentRow := dgTime.Selection.Top;
  for RowIndex := CurrentRow + 1 to sgMT3DTime.RowCount - 1 do
  begin
    for ColIndex := 1 to sgMT3DTime.ColCount - 1 do
    begin
      sgMT3DTime.Cells[ColIndex, RowIndex - 1] := sgMT3DTime.Cells[ColIndex,
        RowIndex];
    end;
  end;
  sgMT3DTime.RowCount := sgMT3DTime.RowCount - 1;
  // end MT3D
  UpdateGwmStateSP_Limits;
end;

function PartialNumberString(const AString: string): boolean;
const
  NumChar = ['+', '-', '.', 'e', 'E', '0'..'9'];
var
  CharIndex: Integer;
begin
  result := AString = '';
  if not result then
  begin
    result := True;
    for CharIndex := 1 to Length(AString) do
    begin
      result := AString[CharIndex] in NumChar;
      if not result then
      begin
        Exit;
      end;
    end;
  end;
end;

function PartialIntString(const AString: string): boolean;
const
  NumChar = ['+', '-', '0'..'9'];
var
  CharIndex: Integer;
begin
  result := AString = '';
  if not result then
  begin
    result := True;
    for CharIndex := 1 to Length(AString) do
    begin
      result := AString[CharIndex] in NumChar;
      if not result then
      begin
        Exit;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.sgTimeSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  PERLEN: double;
  TSMULT: double;
  NSTP: Integer;
begin
  // triggering event: dgTime.OnSetEditText;
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  inherited;
  try
    if (ACol > 0) and (ARow > 0) and (Value <> '') then
    begin
      // determine the length of the first time step and display it.
      if (dgTime.Cells[Ord(tdLength), ARow] = '')
        or (dgTime.Cells[Ord(tdMult), ARow] = '')
        or (dgTime.Cells[Ord(tdNumSteps), ARow] = '') then
      begin
        Exit;
      end;
      try
        PERLEN := InternationalStrToFloat(dgTime.Cells[Ord(tdLength), ARow]);
      except on EConvertError do
        if ACol = Ord(tdLength) then
        begin
          PERLEN := InternationalStrToFloat('1' + dgTime.Cells[Ord(tdLength), ARow]);
        end
        else if not PartialNumberString(dgTime.Cells[Ord(tdLength), ARow]) then
        begin
          raise;
        end
        else
        begin
          Exit;
        end;
      end;
      try
        TSMULT := InternationalStrToFloat(dgTime.Cells[Ord(tdMult), ARow]);
      except on EConvertError do
        if ACol = Ord(tdMult) then
        begin
          TSMULT := InternationalStrToFloat('1' + dgTime.Cells[Ord(tdMult), ARow]);
        end
        else if not PartialNumberString(dgTime.Cells[Ord(tdMult), ARow]) then
        begin
          raise;
        end
        else
        begin
          Exit;
        end;
      end;
      try
      NSTP := StrToInt(dgTime.Cells[Ord(tdNumSteps), ARow]);
      except on EConvertError do
        if not PartialIntString(dgTime.Cells[Ord(tdNumSteps), ARow]) then
        begin
          raise;
        end
        else
        begin
          Exit;
        end;
      end;
      if TSMULT = 1 then
      begin
        dgTime.Cells[Ord(tdFirstStep), ARow] := FloatToStrF(PERLEN / NSTP,
          ffGeneral, 7, 0)
      end
      else
      begin
        //        FirstTimeStep := PERLEN*(TSMULT-1)/(IntPower(TSMULT,NSTP)-1);
        dgTime.Cells[Ord(tdFirstStep), ARow]
          := FloatToStrF(PERLEN * (TSMULT - 1) / (IntPower(TSMULT, NSTP) - 1),
          ffGeneral, 7, 0);
      end;
      LastTimeText := dgTime.Cells[ACol, ARow];
      if (ACol = 4) then
      begin
        SetLakesSteady;
        SetModPathTimeOptions;
      end;

    end;
    if Ord(tdLength) = ACol then
    begin
      sgMT3DTime.Cells[ACol, ARow] := dgTime.Cells[Ord(tdmLength), ARow];
    end;
  except on EConvertError do
    begin
      // if the user enters bad data, revert to the old data.
      if not (dgTime.Cells[ACol, ARow] = '') then
      begin
        dgTime.Cells[ACol, ARow] := LastTimeText;
        Beep;
      end;
    end;
  end;
  adeModpathBeginExit(nil);
  adeModpathEndExit(nil);

end;

procedure TfrmMODFLOW.sgMOC3DParticlesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  Position: double;
begin
  // triggering events: sgMOC3DParticles.OnSetEditText;
  inherited;

  // check that custom particle positions for MOC3D are valid.
  try
    begin
      if (ACol > 0) and (ARow > 0) then
      begin
        if not (Value = '') and not (Value = '-') then
        begin
          Position := InternationalStrToFloat(Value);
          if (Position > 0.5) or (Position < -0.5) then
          begin
            sgMOC3DParticles.Cells[ACol, ARow] := PreviousParticleText;
            Beep;
            ShowMessage('Please Enter a value between -0.5 and +0.5');
          end
          else
          begin
            PreviousParticleText := sgMOC3DParticles.Cells[ACol, ARow];
          end;
        end;
      end;
    end;
  except on EConvertError do
    begin
      // if the user enters data that is not a number, then revert to the old
      // data.
      sgMOC3DParticles.Cells[ACol, ARow] := PreviousParticleText;
      Beep;
    end;
  end;

end;

procedure TfrmMODFLOW.sgMOC3DParticlesExit(Sender: TObject);
var
  NewSelection: TGridRect;
  RowIndex, ColIndex: integer;
begin
  // triggering events: sgMOC3DParticles.OnExit;
  // Called by edMOC3DInitParticlesExit;
  // Called by btnMOC3DParticleAddClick;
  // Called by btnMOC3DParticleDeleteClick;
  // Called by cbCustomParticleClick
  // Called by btnOKClick
  inherited;
  // set the selection to be equal to the entire grid outside the
  // fixed columns
  NewSelection := sgMOC3DParticles.Selection;
  NewSelection.Left := sgMOC3DParticles.FixedCols;
  NewSelection.Right := sgMOC3DParticles.ColCount - 1;
  sgMOC3DParticles.Selection := NewSelection;
  // check that all data in the grid is valid, if any isn't valid
  // fix it.
  for RowIndex := 1 to sgMOC3DParticles.RowCount - 1 do
  begin
    for ColIndex := 1 to sgMOC3DParticles.ColCount - 1 do
    begin
      try
        begin
          InternationalStrToFloat(sgMOC3DParticles.Cells[ColIndex, RowIndex]);
        end;
      except on EConvertError do
        begin
          sgMOC3DParticles.Cells[ColIndex, RowIndex] := '0';
        end;
      end;
    end;
  end;
  sgMOC3DParticles.Invalidate;
end;

procedure TfrmMODFLOW.ClearMultiNodeWellNames;
var
  Index: integer;
begin
  for Index := 0 to MultiNodeWellNames.Count -1 do
  begin
    MultiNodeWellNames.Objects[Index].Free;
  end;
  MultiNodeWellNames.Clear;
end;

procedure TfrmMODFLOW.FormDestroy(Sender: TObject);
var
  RowIndex: integer;
  Index: integer;
  AParameterList: TList;
begin
  // triggering events: frmMODFLOW.OnDestroy;
  inherited;
  ClearMultiNodeWellNames;
  MultiNodeWellNames.Free;
  // destroy the layer structure
  OldHufNames.Free;
  NewHufNames.Free;
  OldParamNames.Free;
  HufLVDA_Units.Free;
  SensitivityNames.Free;
  MFLayerStructure.Free;

  OldMultiplierNames.Free;
  OldZoneNames.Free;
  LastInstanceCountStringList.Free;

  // destroy the list of geologic units
  GeologicUnitsList.Free;
  if GeologicUnitParametersList <> nil then
  begin
    for Index := 0 to GeologicUnitParametersList.Count - 1 do
    begin
      AParameterList := GeologicUnitParametersList[Index];
      AParameterList.Free;
    end;
  end;

  GeologicUnitParametersList.Free;

  // destroy the lists of parameter lists.
  for RowIndex := 1 to dgTime.RowCount - 1 do
  begin
    (dgTime.Objects[0, RowIndex] as TList).Free;
  end;

  SpecialHandlingList.Free;
  ClearUnitNumberStringList;
  UnitNumberStringList.Free;
  MonitoringWellNameFileLines.Free;
  //  FirstList.Free;

end;

procedure TfrmMODFLOW.comboMOC3DPartFreqChange(Sender: TObject);
begin
  // triggering events: comboMOC3DPartFreq.OnChange;
  inherited;

  // if you are going to print a particle locations output file, then you can
  // specify how frequently you can print data to it.
  adeMOC3DPartFreq.Enabled := comboMOC3DPartFileType.Enabled
    and (comboMOC3DPartFreq.ItemIndex = 3)
    and (comboMOC3DPartFileType.ItemIndex > 0);

end;

procedure TfrmMODFLOW.FormShow(Sender: TObject);
var
  layerHandle: ANE_PTR;
  NumRows: ANE_INT32;
  NumColumns: ANE_INT32;
  StringtoEvaluate: string;
  RowPosition: ANE_DOUBLE;
  ColPositon: ANE_DOUBLE;
  EdgeOfGrid: ANE_DOUBLE;
  STR: ANE_STR;
  LayerName: string;
begin
  // triggering events: frmMODFLOW.OnShow;
  inherited;

  Height := FormHeight;
  Width := FormWidth;

  // make the project tab the active tab.
  if reProblem.Lines.Count = 0 then
  begin
    pageControlMain.ActivePage := tabProject;
    //    BitBtnHelp.HelpContext := tabProject.HelpContext;
  end
  else
  begin
    pageControlMain.ActivePage := TabProblem;
    TabProblem.TabVisible := True;
    //    BitBtnHelp.HelpContext := TabProblem.HelpContext;
  end;
  pageControlMainChange(pageControlMain);

  // if you have just loaded a MOC3D model from the old version of the PIE
  // you must update the MOC3D subgrid
  if RecalculateSubgrid then
  begin
    // once the subgrid has been updated it doesn't need to be updated again
    // so set  RecalculateSubgrid to false.
    RecalculateSubgrid := False;

    // get the layer handle for the grid layer
    LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
    layerHandle := GetLayerHandle(CurrentModelHandle, LayerName);

    // get the number of rows
    ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
      kPIEInteger, 'NumRows()', @NumRows);

    // get the number of columns
    ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
      kPIEInteger, 'NumColumns()', @NumColumns);

    // set the value of the distance to the first row
    if (StrToInt(adeMOC3DRow1.Text) = 1) or (NumRows = 0) then
    begin
      // if the default value is used or the grid does not exist, use 0.
      adeMOC3DRow1.Text := '0'
    end
    else
    begin
      // get the position of the first row.
      StringtoEvaluate := 'NthRowPos(' + IntToStr(0) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @RowPosition);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      EdgeOfGrid := RowPosition;

      // get the position of the row the user specified.
      StringtoEvaluate := 'NthRowPos(' +
        IntToStr(StrToInt(adeMOC3DRow1.Text) - 1) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @RowPosition);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      // set the correct distance
      adeMOC3DRow1.Text := FloatToStr(Abs(RowPosition - EdgeOfGrid));
    end;

    // set the value of the distance to the last row
    if (StrToInt(adeMOC3DRow2.Text) = -1) or (NumRows = 0) then
    begin
      // if the default value is used or the grid does not exist, use 0.
      adeMOC3DRow2.Text := '0'
    end
    else
    begin
      // get the position of the last row.
      StringtoEvaluate := 'NthRowPos(' + IntToStr(NumRows) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @RowPosition);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      EdgeOfGrid := RowPosition;

      // get the position of the row the user specified.
      StringtoEvaluate := 'NthRowPos(' + adeMOC3DRow2.Text + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @RowPosition);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      // set the correct distance
      adeMOC3DRow2.Text := FloatToStr(Abs(EdgeOfGrid - RowPosition));
    end;

    // set the value of the distance to the first column
    if (StrToInt(adeMOC3DCol1.Text) = 1) or (NumColumns = 0) then
    begin
      // if the default value is used or the grid does not exist, use 0.
      adeMOC3DCol1.Text := '0'
    end
    else
    begin
      // get the position of the first column.
      StringtoEvaluate := 'NthColumnPos(' + IntToStr(0) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @RowPosition);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      EdgeOfGrid := RowPosition;

      // get the position of the column the user specified.
      StringtoEvaluate := 'NthColumnPos('
        + IntToStr(StrToInt(adeMOC3DCol1.Text) - 1) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @ColPositon);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      // set the correct distance
      adeMOC3DCol1.Text := FloatToStr(Abs(ColPositon - EdgeOfGrid));
    end;

    // set the value of the distance to the last column
    if (StrToInt(adeMOC3DCol2.Text) = -1) or (NumColumns = 0) then
    begin
      // if the default value is used or the grid does not exist, use 0.
      adeMOC3DCol2.Text := '0'
    end
    else
    begin
      // get the position of the last column.
      StringtoEvaluate := 'NthColumnPos(' + IntToStr(NumColumns) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @RowPosition);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      EdgeOfGrid := RowPosition;

      // get the position of the column the user specified.
      StringtoEvaluate := 'NthColumnPos(' + adeMOC3DCol2.Text + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR, StringToEvaluate);
        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle,
          kPIEFloat, STR, @ColPositon);
        ANE_ProcessEvents(CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      // set the correct distance
      adeMOC3DCol2.Text := FloatToStr(Abs(EdgeOfGrid - ColPositon));
    end;
    BottomMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DRow1.Text);
    TopMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DRow2.Text);
    LeftMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DCol1.Text);
    RightMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DCol2.Text);

  end;

end;

procedure TfrmMODFLOW.btnAddUnitClick(Sender: TObject);
begin
  // triggering event: btnAdd.OnClick;
  inherited;

  // Add a geologic unit at the end of the list of geologic units in
  // the same way that a user would.
  edNumUnitsEnter(Sender);
  edNumUnits.Text := IntToStr(StrToInt(edNumUnits.Text) + 1);
  edNumUnitsExit(Sender);

end;

procedure TfrmMODFLOW.btnAddGwmStorageStateVarClick(Sender: TObject);
begin
  inherited;
  rdeGwmStorageStateVarCountEnter(nil);
  rdeGwmStorageStateVarCount.Text :=
    IntToStr(StrToInt(rdeGwmStorageStateVarCount.Output)+1);
  rdeGwmStorageStateVarCountExit(nil);
end;

procedure TfrmMODFLOW.btnAddTimeClick(Sender: TObject);
begin
  // triggering event: btnAddTime.OnClick;
  inherited;

  // add a new stress period at the end of the list of stress periods in
  // the same way that a user would.
  edNumPerEnter(Sender);
  edNumPer.Text := IntToStr(StrToInt(edNumPer.Text) + 1);
  edNumPerExit(Sender);

end;

procedure TfrmMODFLOW.edMOC3DInitParticlesExit(Sender: TObject);
var
  NewNumParticles: integer;
  RowIndex, ColIndex: integer;
  PrevNumParticles: Integer;
begin
  // triggering events: edMOC3DInitParticles.OnExit;
  // called by btnMOC3DParticleAddClick;
  // called by GLoadForm/
  inherited;
  PrevNumParticles := sgMOC3DParticles.RowCount - 1;
  try
    begin
      // determine the new number of MOC3D particles
      NewNumParticles := StrToInt(edMOC3DInitParticles.Text);
      if cbCustomParticle.Checked then
      begin

        // change the number of rows in the particle grid to reflect the new
        // number of particles
        sgMOC3DParticles.RowCount := NewNumParticles + 1;

        // if the number of particles has increased, copy data from previous rows
        if NewNumParticles > PrevNumParticles then
        begin
          for RowIndex := PrevNumParticles + 1 to sgMOC3DParticles.RowCount - 1
            do
          begin
            sgMOC3DParticles.Cells[0, RowIndex] := IntToStr(RowIndex);
            for ColIndex := 1 to sgMOC3DParticles.ColCount - 1 do
            begin
              sgMOC3DParticles.Cells[ColIndex, RowIndex]
                := sgMOC3DParticles.Cells[ColIndex, RowIndex - 1];
            end;
          end;
        end;

        // enable the delete button when the number of particles
        // is greater than 2 and the user has choosen to use custom particles
        btnMOC3DParticleDelete.Enabled := cbCustomParticle.Checked
          and (sgMOC3DParticles.RowCount > 2);

        // check that all the cells contain valid data
        sgMOC3DParticlesExit(Sender);
      end;
    end;
  except on EConvertError do
    begin
      // if the user enters an illegal value, revert to the
      // previous value.
      edMOC3DInitParticles.Text := IntToStr(PrevNumParticles);
      Beep;
    end;
  end;
end;

procedure TfrmMODFLOW.sgMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  AStringGrid: TStringGrid;
  ACol, ARow: Longint;
begin
  // triggering event: dgTime.OnMouseMove;
  // triggering events: sgMOC3DParticles.OnMouseMove;
  // triggering events: sgMOC3DTransParam.OnMouseMove;
  // triggering events: dgGeol.OnMouseMove;
  inherited;

  // cast the Sender to a string grid
  AStringGrid := Sender as TStringGrid;
  try
    begin
      // determine the cell over which the mouse is positioned.
      AStringGrid.MouseToCell(X, Y, ACol, ARow);
      if (ACol > -1) and (ACol < AStringGrid.ColCount) then
      begin
        // display the full title of the current column in the status bar
        statbarMain.SimpleText := AStringGrid.Cells[ACol, 0];
      end;
    end;
  except on EListError do
    begin
      // if the mouse moves outside of the grid, do nothing
    end;
  end;
end;

procedure TfrmMODFLOW.Enable_cbCBDY;
var
  FirstLayer, LastLayer: integer;
begin
  // determine the first layer used by MOC3D
  FirstLayer := StrToInt(adeMOC3DLay1.Text);

  // determine the last layer used by MOC3D
  LastLayer := StrToInt(adeMOC3DLay2.Text);
  if LastLayer < 1 then
  begin
    LastLayer := StrToInt(edNumUnits.Text);
  end;

  cbCBDY.Enabled := (FirstLayer > 1) or (LastLayer < UnitCount) or CBNeeded;
  if not Loading and not Cancelling then
  begin
    if not cbCBDY.Enabled then
    begin
      cbCBDY.Checked := False;
    end;
  end;
end;

procedure TfrmMODFLOW.adeMOC3DLayerExit(Sender: TObject);
var
  FirstLayer, LastLayer: integer;
begin
  // triggering events: adeMOC3DLay1.OnExit;
  // triggering events: adeMOC3DLay2.OnExit;
  // called by edNumUnitsExit;
  inherited;

  // determine the first layer used by MOC3D
  FirstLayer := StrToInt(adeMOC3DLay1.Text);

  // determine the last layer used by MOC3D
  LastLayer := StrToInt(adeMOC3DLay2.Text);
  if LastLayer < 1 then
  begin
    LastLayer := StrToInt(edNumUnits.Text);
  end;

  // check that a legal value is in adeMOC3DLay2
  if LastLayer = 0 then
  begin
    adeMOC3DLay2.Text := '-1';
  end;

  Enable_cbCBDY;


  // update the number of units used by MOC3D.
  adeMOCNumLayers.Text := IntToStr(LastLayer - FirstLayer + 1);
  AddRemoveCHFBParameters;
  cbCBDYClick(Sender);
end;

procedure TfrmMODFLOW.adeFileNameExit(Sender: TObject);
var
  Index: integer;
  NewName, OldName: string;
begin
  // triggering event: adeFileName.OnExit;
  inherited;

  // convert the root name of the simulation file to lowercase.
  // This makes it easier to run the MODFLOW simulation on UNIX.
  // Also elimnate blank spaces.
//  adeFileName.Text := Trim(Lowercase(adeFileName.Text));
  // lowercase conversion dropped.
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
  if not Loading and not Cancelling then
  begin
    if edDiscretization.Text = OldName then
    begin
      edDiscretization.Text := NewName;
    end;
  end;

end;

procedure TfrmMODFLOW.cbSTRClick(Sender: TObject);
begin
  // triggering event: cbSTR.OnClick;
  inherited;
  // Show a warning if the stream and MOC3D are both displayed.
  StreamWarning;

  Modflow2000Warnings;
  EnableGwmStreamVariables;

  ActivateParametersTab;
  if cbSTR.Checked then
  begin
    AddNewParameters(dgSTRParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgSTRParametersN, 0);
  end;

  // enable or disable options related to streams depending on
  // whether or not streams will be used in the simulation.
  cbStreamCalcFlow.Enabled := cbSTR.Checked;
  cbAltSTR.Enabled := cbSTR.Checked;

  comboStreamOption.Enabled := cbSTR.Checked;
  SetComboColor(comboStreamOption);

  cbObservationsClick(Sender);

  cbSTRRetain.Enabled := cbSTR.Checked;
  lblStrPrintFlows.Enabled := cbSTR.Checked;

  cbStreamTrib.Enabled := cbSTR.Checked;
  cbStreamDiversions.Enabled := cbSTR.Checked;
  cbFlowSTR.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbStr.Checked;
  cbFlowSTR2.Enabled := cbStr.Checked;

  // enable the user to specify the model units if both streams and selected
  // and stream flow will be calculated
  comboModelUnits.Enabled := cbSTR.Checked and cbStreamCalcFlow.Checked
    and rbModflow96.Checked;
  SetComboColor(comboModelUnits);

  cbStrPrintFlows.Enabled := cbSTR.Checked;

  // add or remove the stream layers from the layer structure depending
  // on whether or not streams will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFStreamLayerType, cbSTR.Checked);

  AddOrRemoveGWM_STRLayers;

  //  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
  //    (ModflowTypes.GetMF2KSimpleStreamLayerType, cbSTR.Checked);

    // add or remove grid stream parameter from the grid layer
    // depending on whether streams are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridStreamParamType,
    cbSTR.Checked);

  cbStreamCalcFlowClick(Sender);

  cbStreamObservations.Enabled := cbSTR.Checked;
  cbStreamObservationsClick(Sender);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  EnableSSM;
end;

procedure TfrmMODFLOW.cbStreamCalcFlowClick(Sender: TObject);
begin
  // triggering event: cbStreamCalcFlow.OnClick;
  inherited;
  // enable the user to specify the model units if both streams and selected
  // and stream flow will be calculated
  comboModelUnits.Enabled := cbSTR.Checked and cbStreamCalcFlow.Checked
    and rbModflow96.Checked;
  SetComboColor(comboModelUnits);


    // add or remove the stream slope parameters from the stream layers
    // depending on whether or not streams will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFStreamSlopeParamType,
    cbStreamCalcFlow.Checked and cbSTR.Checked);

  // add or remove the stream roughness parameters from the stream layers
  // depending on whether or not streams will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFStreamRoughParamType,
    cbStreamCalcFlow.Checked and cbSTR.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbStreamTribClick(Sender: TObject);
begin
  // triggering event: cbStreamTrib.OnClick;
  inherited;

  if not Loading and not Cancelling and not cbStreamTrib.Checked then
  begin
    cbStreamDiversions.Checked := False;
  end;

  // add or remove the stream downstream segment number parameters from the
  // stream layers
  // depending on whether or not tributaries will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFStreamDownSegNumParamType,
    cbStreamTrib.Checked and cbSTR.Checked);

// associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.cbStreamDiversionsClick(Sender: TObject);
begin
  // triggering event: cbStreamDiversions.OnClick;
  inherited;

  if not Loading and not Cancelling and cbStreamDiversions.Checked then
  begin
    cbStreamTrib.Checked := True;
  end;

  // add or remove the stream diversion segment number parameters from the
  // stream layers
  // depending on whether or not diversions will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFStreamDivSegNumParamType,
    cbStreamDiversions.Checked and cbSTR.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.cbHFBClick(Sender: TObject);
begin
  // triggering event: cbHFB.OnClick;
  inherited;
  HUF_HFB_Warning;
  ActivateParametersTab;
  if cbHFB.Checked then
  begin
    AddNewParameters(dgHFBParameters, 0);
  end
  else
  begin
    RemoveOldParameters(dgHFBParameters, 0);
  end;

  cbHFBRetain.Enabled := cbHFB.Checked;

  // add or remove the horizontal flow barrier layers from
  // the layer structure depending
  // on whether or not horizontal flow barriers will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFHFBLayerType, cbHFB.Checked);

  // add or remove grid horizontal flow barrier parameter from the grid layer
  // depending on whether horizontal flow barriers are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridHFBParamType,
    cbHFB.Checked);

  AddRemoveCHFBParameters;
end;

procedure TfrmMODFLOW.cbFHBClick(Sender: TObject);
begin
  // triggering event: cbFHB.OnClick;
  inherited;

  // allow the user to specify Flow-and-head boundary data as appropriate

  // If you are using Flow-and-head boundaries, you can specify the number
  // of Flow-and-head boundary times
  adeFHBNumTimes.Enabled := cbFHB.Checked;
  cbFHBRetain.Enabled := cbFHB.Checked;

  // If you are using Flow-and-head boundaries, and the number of
  // flow and head boundaries is greater than one you can specify the
  // Flow-and-head boundary times
  sgFHBTimes.Enabled := cbFHB.Checked and (StrToInt(adeFHBNumTimes.Text) > 1);
  if sgFHBTimes.Enabled then
  begin
    sgFHBTimes.Color := clWindow;
  end
  else
  begin
    sgFHBTimes.Color := clBtnFace;
  end;

  if cbFHB.Checked and (StrToInt(adeFHBNumTimes.Text) > 1) then
  begin
    sgFHBTimes.Options := sgFHBTimes.Options + [goEditing];
  end
  else
  begin
    sgFHBTimes.Options := sgFHBTimes.Options - [goEditing];
  end;

  // If you are using Flow-and-head boundaries, and you have multiple steady
  // state models, you can choose whether or not to interpolate flow-and-head
  // boundaries
  comboFHBSteadyStateOption.Enabled
    := (comboSteady.ItemIndex = 1) and cbFHB.Checked and (dgTime.RowCount > 2);
  SetComboColor(comboFHBSteadyStateOption);

  // if you are using flow-and-head boundaries and MOC3D, you can choose
  // the weight used in interpolating concencentrations.
  adeFHBHeadConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;
  adeFHBFluxConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;

  cbFlowFHB.Enabled := cbFHB.Checked;
  cbUseAreaFHBs.Enabled := cbFHB.Checked;

  // add or remove the flow-and-head boundaries layers from
  // the layer structure depending
  // on whether or not flow-and-head boundaries will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFPointFHBLayerType, cbFHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineFHBLayerType, cbFHB.Checked);

  // add or remove grid flow-and-head boundary parameter from the grid layer
  // depending on whether flow-and-head boundaries are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridFHBParamType,
    cbFHB.Checked);

  cbUseAreaFHBsClick(Sender);
  EnableSSM;

  UpdateIFACE;

end;

procedure TfrmMODFLOW.SetModPathTimeOptions;
begin
  cbMPATHStopTime.Enabled := (ModPathSteady = 1);

  // If you can't specify the stop time for MODPATH.
  // model, you don't specify the stop time for MODPATH.
  if not cbMPATHStopTime.Enabled and not Loading and not Cancelling then
  begin
    cbMPATHStopTime.Checked := False;
  end;

  // enable or disable other controls depending on the value of
  // cbMPATHStopTime;
  cbMPATHStopTimeClick(nil);

  // enable or disable the MODPATH starting time method
  // depending on whether or not you have a steady state model.
  comboMPATHStartTimeMethod.Enabled := (ModPathSteady = 0);
  SetComboColor(comboMPATHStartTimeMethod);

  // enable or disable controls related to the MODPATH starting time method.
  comboMPATHStartTimeMethodChange(nil);

  // enable or disable the MODPATH tracking time option and its
  // lable depending on whether or not you have a steady state model.
  cbMPATHTrackStop.Enabled := (ModPathSteady = 0);
  lblMPATHTrackStop.Enabled := cbMPATHTrackStop.Enabled;

  // enable or disable controls related to the MODPATH tracking time option.
  cbMPATHTrackStopClick(nil);

end;

procedure TfrmMODFLOW.comboSteadyChange(Sender: TObject);
var
  RowIndex: integer;
begin
  // triggering event: comboSteady.OnChange;
  // called by FormCreate;
  // called by GLoadForm in ProjectFunction;

  inherited;
  // If you are using Flow-and-head boundaries, and you have multiple steady
  // state models, you can choose whether or not to interpolate flow-and-head
  // boundaries

  cbTLK.Enabled := comboSteady.ItemIndex = 0;
  if not cbTLK.Enabled and not Loading and not Cancelling then
  begin
    cbTLK.Checked := False;
  end;

  if not Loading and not Cancelling then
  begin
    for RowIndex := 1 to dgTime.RowCount - 1 do
    begin
      dgTime.Cells[Ord(tdSsTr), RowIndex]
        := dgTime.Columns[Ord(tdSsTr)].PickList[comboSteady.ItemIndex];
    end;
  end;

  comboFHBSteadyStateOption.Enabled
    := (comboSteady.ItemIndex = 1) and cbFHB.Checked and (dgTime.RowCount > 2);
  SetComboColor(comboFHBSteadyStateOption);

  // If you have a steady state
  // model, you can specify the stop time for MODPATH.
  SetModPathTimeOptions;

  SetLakesSteady

end;

procedure TfrmMODFLOW.adeFHBNumTimesExit(Sender: TObject);
var
  RowIndex: integer;
  TimeIndex: integer;
  LayerIndex: integer;
  NewFHBTimes: integer;
  AnIndexedLayerList: T_ANE_IndexedLayerList;
  APointFHBLayer: T_ANE_InfoLayer;
  ALineFHBLayer: T_ANE_InfoLayer;
  AnAreaFHBLayer: T_ANE_InfoLayer;
  NumberOfUnits: integer;
  ParamList: T_ANE_IndexedParameterList;
begin
  // triggering event: adeFHBNumTimes.OnExit;
  inherited;

  // determine the new number of flow-and-head boundary times.
  NewFHBTimes := StrToInt(adeFHBNumTimes.Text);

  sgFHBTimes.Enabled := cbFHB.Checked and (NewFHBTimes > 1);
  if sgFHBTimes.Enabled then
  begin
    sgFHBTimes.Color := clWindow;
  end
  else
  begin
    sgFHBTimes.Color := clBtnFace;
  end;

  // set the number of rows in the flow-and-head boundary times grid
  // dending on the number of times specified.
  sgFHBTimes.RowCount := NewFHBTimes + 1;

  // enable editting of the flow-and-head boundary times grid
  // if you are using flow-and-head boundaries and the number of flow-and-head
  // times is greater than 1.
  sgFHBTimes.Enabled := cbFHB.Checked;

  if cbFHB.Checked and (StrToInt(adeFHBNumTimes.Text) > 1) then
  begin
    sgFHBTimes.Options := sgFHBTimes.Options + [goEditing];
  end
  else
  begin
    sgFHBTimes.Options := sgFHBTimes.Options - [goEditing];
  end;
  // make sure that the number of fixed rows is correct.
  // This is needed because the number of fixed rows is set to 1 by
  // TStringGrid when the number of rows is set to 2.
  if sgFHBTimes.RowCount > 2 then
  begin
    sgFHBTimes.FixedRows := 2;
  end;

  // check that all data that has been entered is valid. Fix it if it
  // isn't valid.
  for RowIndex := sgFHBTimes.FixedRows to sgFHBTimes.RowCount - 1 do
  begin
    if sgFHBTimes.Cells[1, RowIndex] = '' then
    begin
      sgFHBTimes.Cells[1, RowIndex] := '0';
    end;
    if sgFHBTimes.Cells[0, RowIndex] = '' then
    begin
      sgFHBTimes.Cells[0, RowIndex] := IntToStr(RowIndex);
    end;
  end;

  // don't try to do this if you aren't using the FHB package
  // cbFHB.Checked may be false when this method is called
  // when openning a file.
  if cbFHB.Checked then
  begin
    // add or remove time-related parameters as required
    if NewFHBTimes > PreviousFHBTimes then
    begin
      // add time-related parameters as required
      for TimeIndex := PreviousFHBTimes + 1 to NewFHBTimes do
      begin
        // add time-related parameters to the point, line, and area
        // FHB layers.
        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
          ModflowTypes.GetMFPointFHBLayerType,
          ModflowTypes.GetMFFHBPointTimeParamListType, -1);

        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
          ModflowTypes.GetMFLineFHBLayerType,
          ModflowTypes.GetMFFHBLineTimeParamListType, -1);

        if cbUseAreaFHBs.Checked then
        begin
          MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
            ModflowTypes.GetMFAreaFHBLayerType,
            ModflowTypes.GetMFFHBAreaTimeParamListType, -1);
        end;
      end;
    end
    else
    begin
      // First get the number of units
      NumberOfUnits := StrToInt(edNumUnits.Text);

      // loop over all the units.
      for LayerIndex := 0 to NumberOfUnits - 1 do
      begin
        // get each geologic unit
        AnIndexedLayerList := MFLayerStructure.ListsOfIndexedLayers.
          GetNonDeletedIndLayerListByIndex(LayerIndex);

        // get the point FHB layer
        APointFHBLayer := AnIndexedLayerList.GetLayerByName
          (ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName)
          as T_ANE_InfoLayer;

        // delete FHB time parameters from the point FHB layer
        for TimeIndex := PreviousFHBTimes - 1 downto NewFHBTimes do
        begin
          ParamList := (APointFHBLayer as ModflowTypes.GetMFPointFHBLayerType).
            IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(TimeIndex);
          if ParamList <> nil then
          begin
            ParamList.DeleteSelf;
          end;
        end;

        // get the line FHB layer
        ALineFHBLayer := AnIndexedLayerList.GetLayerByName
          (ModflowTypes.GetMFLineFHBLayerType.ANE_LayerName)
          as T_ANE_InfoLayer;

        // delete FHB time parameters from the line FHB layer
        for TimeIndex := PreviousFHBTimes - 1 downto NewFHBTimes do
        begin
          ParamList := (ALineFHBLayer as ModflowTypes.GetMFLineFHBLayerType).
            IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(TimeIndex);
          if ParamList <> nil then
          begin
            ParamList.DeleteSelf;  
          end;
          //            (ALineFHBLayer as  ModflowTypes.GetMFLineFHBLayerType).
          //              IndexedParamList1.
          //              GetNonDeletedIndParameterListByIndex(TimeIndex).DeleteSelf;
        end;

        if cbUseAreaFHBs.Checked then
        begin
          AnAreaFHBLayer := AnIndexedLayerList.GetLayerByName
            (ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName)
            as T_ANE_InfoLayer;

          for TimeIndex := PreviousFHBTimes - 1 downto NewFHBTimes do
          begin
            ParamList := (AnAreaFHBLayer as ModflowTypes.GetMFAreaFHBLayerType).
              IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(TimeIndex);
            if ParamList <> nil then
            begin
              ParamList.DeleteSelf;
            end;
            //              (AnAreaFHBLayer as ModflowTypes.GetMFAreaFHBLayerType).
            //                IndexedParamList1.
            //                GetNonDeletedIndParameterListByIndex(TimeIndex).DeleteSelf;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.sgFHBTimesSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  // triggering event: sgFHBTimes.OnSelectCell;
  inherited;

  // when the user starts editting an FHB time cell, save the previous contents
  // of the cell in case it needs to be restored later.
  PreviousFHBTimeText := sgFHBTimes.Cells[Col, Row];
end;

procedure TfrmMODFLOW.sgFHBTimesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  // triggering event: sgFHBTimes.OnSetEditText;
  inherited;

  // if the user enters invalid data in the FHB time grid, restore
  // the previous data
  try
    begin
      if (ARow > 0) and (ACol > 0) then
      begin
        if not (sgFHBTimes.Cells[ACol, ARow] = '') then
        begin
          InternationalStrToFloat(sgFHBTimes.Cells[ACol, ARow]);
          PreviousFHBTimeText := sgFHBTimes.Cells[ACol, ARow];
        end;
      end;
    end;
  except on EConvertError do
    begin
      sgFHBTimes.Cells[ACol, ARow] := PreviousFHBTimeText;
      Beep;
    end;
  end;
end;

procedure TfrmMODFLOW.AdvObsWarning;
var
  SSIndex: integer;
  TimeIndex: integer;
  AdvError: boolean;
begin
  if not Loading and not cancelling and cbAdvObs.Checked and
    cbObservations.Checked then
  begin
    AdvError := False;
    SSIndex := dgTime.Columns[Ord(tdSsTr)].PickList.IndexOf(
      dgTime.Cells[Ord(tdSsTr),1]);
    if SSIndex <> 1 then
    begin
      AdvError := True;
    end;
    for TimeIndex := 2 to dgTime.RowCount -1 do
    begin
      if IsSteadyStateStress(TimeIndex) then
      begin
        AdvError := True;
      end;
    end;

    if AdvError then
    begin
      Beep;
      MessageDlg('The Advection Observations package requires that the '
        + 'first stress period in a model be a steady-state stress period '
        + 'and that no other stress period in the model be a steady-state '
        + 'stress period.  You should correct this before trying to run '
        + 'MODFLOW.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.HUF_SensitivityWarning;
var
  UnitIndex, LTHUF: integer;
begin
  if not Loading and not Cancelling then
  begin
    if cbSensitivity.Checked and (rgFlowPackage.ItemIndex = 2)
      and HufParameterUsed(hufLVDA) then
    begin
      for UnitIndex := 1 to UnitCount do
      begin
        if Simulated(UnitIndex) then
        begin
          LTHUF := ModflowLayerType(UnitIndex);
          if LTHUF <> 0 then
          begin
            Beep;
            MessageDlg('The HUF package does not allow the sensitivity process '
              + 'to be used when layers are convertible and LVDA parameters '
              + 'are used.  You should fix this '
              + 'before attempting to run MODFLOW.', mtWarning, [mbOK], 0);
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.StreamToleranceWarning;
var
  DLEAK: double;
  HeadTolerance: double;
begin
  if not Loading and not Cancelling and cbSFR.Checked and cbSFRRetain.Checked then
  begin
    HeadTolerance := 0;
    DLEAK := InternationalStrToFloat(adeStreamTolerance.Text);
    case SolverChoice(rgSolMeth.ItemIndex) of
      scSIP:
        begin
          HeadTolerance := InternationalStrToFloat(adeSIPConv.Text);
        end;
      scDE4:
        begin
          HeadTolerance := InternationalStrToFloat(adeDE4Conv.Text);
        end;
      scPCG2:
        begin
          HeadTolerance := InternationalStrToFloat(adePCGMaxHeadChange.Text);
        end;
      scSOR:
        begin
          HeadTolerance := InternationalStrToFloat(adeSORConv.Text);
        end;
      scLMG:
        begin
          HeadTolerance := -1;
        end;
      scGMG:
        begin
          HeadTolerance := InternationalStrToFloat(adeGmgHclose.Text);
        end;
    else Assert(False);
    end;
    if (HeadTolerance >= 0) and (HeadTolerance < DLEAK) then
    begin
      MessageDlg('The Tolerance (DLEAK) in the SFR package should be less '
        + 'than or equal to the head closure criterion (HCLOSE) in the solver.'
        + '  You should fix this before trying to run MODFLOW.',
        mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.Mnw2Warning;
var
  Index: Integer;
  AnyLossTypeUsed: Boolean;
begin
  if cbMnw2.Checked and cbUseMnw2.Checked then
  begin
    AnyLossTypeUsed := False;
    for Index := Ord(Low(TMnw2LossTypeChoices)) to Ord(High(TMnw2LossTypeChoices)) do
    begin
      if clbMnw2LossTypes.Checked[Index] then
      begin
        AnyLossTypeUsed := True;
        break;
      end;
    end;
    if not AnyLossTypeUsed then
    begin
      Beep;
      MessageDlg('For multi-node wells in the MNW2 package '
        + 'that intersect more than one cell, '
        + 'LOSSTYPE must be set to a value other than "NONE".',
        mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.Mt3dTransObsWarning;
begin
  if cbMT3D.Checked and cbTOB.Checked
    and not (cb_inConcObs.Checked or cb_inFluxObs.Checked)  then
  begin
      Beep;
      MessageDlg('The Transport observation package in MT3DMS is selected '
        + 'but neither concentration nor mass flux observations are selected '
        + 'so no transport observations will be defined. You should fix this '
        + 'before attempting to run MT3DMS',
        mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.btnOKClick(Sender: TObject);
var
  RowIndex: integer;
  firstSimulatedFound: boolean;
  FirstLayer, LastLayer: integer;
  GroupIndex: integer;
  LayerIndex: integer;
  Group: T_ANE_IndexedLayerList;
  Layer: T_ANE_MapsLayer;
begin
  // triggering event: btnOK.OnClick;
  inherited;
  StreamToleranceWarning;
  AdvObsWarning;
  MNW_Warning;
  GeologyWarning;
  LakeWarning;
  HUF_ParameterWarning;
  HUF_SensitivityWarning;
  ModpathTimeWarning;
  ShowDaflowWarning;
  FixMultiplierNames;
  FixZoneNames;
  FixParameterNames;
  FixPriorEstimates;
  SubsidenceWarnings;
  UnsatflowWarning;
  AdvectionObservationWarning;
  Mnw2Warning;
  Modflow2005Warning;
  GWM_Warning;

  // Show a warning if the rewetting option and MOC3D are both selected.
  Moc3dWetWarning;
  // Show a warning if the stream and MOC3D are both selected.
  StreamWarning;
  Moc3dTimeWarning;
  MODPATHWarnings;
  SensitivityWarning;
  ModPathHNOFLO_Warning;
  HydmodWarning;
  Mt3dTransObsWarning;
  CheckInstances;
  ZoneBudgetWarning;
  CheckValidZoneNumbers;

  adeModpathBeginExit(nil);
  adeModpathEndExit(nil);

  // finish editting the current cell in dtabGeol if the user has not
  // done so already.
//  dtabGeol.CurCell.EndEdit;

  // Check that every time used in the FHB backage is greater than
  // its predecessor. Display a warning message if any such errors
  // are found.
  if sgFHBTimes.Enabled then
  begin
    for RowIndex := 1 to sgFHBTimes.RowCount - 2 do
    begin
      if InternationalStrToFloat(sgFHBTimes.Cells[1, RowIndex])
        > InternationalStrToFloat(sgFHBTimes.Cells[1, RowIndex + 1]) then
      begin
        Beep;
        MessageDlg('Each time specified for the FHB package '
          + 'must be greater than or equal to its predecessor. '
          + 'You will need to '
          + 'fix this problem before running the FHB package.', mtWarning,
          [mbOK], 0);
        break;
      end;
    end;
  end;

  // check that only the uppermost simulated unit is unconfined.
  // Display a warning message if any errors are found.
  firstSimulatedFound := False;
  for RowIndex := 1 to StrToInt(edNumUnits.Text) do
  begin
    if dgGeol.Cells[Ord(nuiSim), RowIndex] = 'Yes' then
    begin
      firstSimulatedFound := True;
    end;

    if (RowIndex > 1) and firstSimulatedFound and
      (dgGeol.Cells[Ord(nuiType), RowIndex]
      = 'Unconfined (1)') then
    begin
      Beep;
      MessageDlg('Only the uppermost unit may be unconfined.'
        + ' You should fix this before attempting to run MODFLOW.', mtWarning,
        [mbOK], 0);
      break;
    end;
  end;

  // If this is a MOC3D model, check that all units in the MOC3D subgrid are
  // simulated units. Display a warning message if any errors are found.
  if cbMOC3D.Checked then
  begin
    FirstLayer := StrToInt(adeMOC3DLay1.Text);
    LastLayer := StrToInt(adeMOC3DLay2.Text);
    if LastLayer = -1 then
    begin
      LastLayer := StrToInt(edNumUnits.Text);
    end;
    for RowIndex := FirstLayer to LastLayer do
    begin
      //     if dtabGeol.CellSet.Item[RowIndex,Ord(uiSim)].Value = 'No' then
      if dgGeol.Cells[Ord(nuiSim), RowIndex] = 'No' then
      begin
        Beep;
        if rbMODFLOW2000.Checked or rbModflow2005.Checked then
        begin
          MessageDlg('All layers used by MF2K-GWT must be simulated.'
            + ' You should fix this before attempting to run MF2K-GWT.',
            mtWarning,
            [mbOK], 0);
        end
        else
        begin
          MessageDlg('All layers used by MOC3D must be simulated.'
            + ' You should fix this before attempting to run MOC3D.', mtWarning,
            [mbOK], 0);
        end;

        break;
      end;
    end;
  end;

  // Check if the time units have been specified properly for the stream package
  if ((cbSTR.Checked and cbStreamCalcFlow.Checked)
    or (cbSFR.Checked and cbSFRCalcFlow.Checked))
    and (comboTimeUnits.ItemIndex = 0) then
  begin
    AssignHelpFile('MODFLOW.chm');
    Beep;
    MessageDlg('You will need to specify the time units for your model '
      + 'if you wish to calculate stream stage.'
      + ' You should fix this before attempting to run MODFLOW.', mtWarning,
      [mbOK, mbHelp], comboTimeUnits.HelpContext);
  end;

  if cbZonebudget.Checked and (rgZonebudTimesChoice.ItemIndex = 1) then
  begin
    sgZondbudTimesExit(Sender);
  end;

  sgMOC3DParticlesExit(Sender);

  if MODFLOWLayerCount > 999 then
  begin
    Beep;
    MessageDlg('MODFLOW has a maximum of 999 layers. '
      + 'You have specified a larger value.'
      + ' To use more than 999 layers you must modify and recompile MODFLOW.',
      mtWarning, [mbOK], 0);
  end;

  SetSubsidenceLayers;
  SetSwtLayers;

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridKxParamType,
    ModflowTypes.GetMFGridKxParamType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridKzParamType,
    ModflowTypes.GetMFGridKzParamType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCPorosityParamType,
    ModflowTypes.GetMFGridMOCPorosityParamType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridSpecYieldParamType,
    ModflowTypes.GetMFGridSpecYieldParamType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridSpecStorParamType,
    ModflowTypes.GetMFGridSpecStorParamType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_FirstUnitParamClassType,
    ModflowTypes.GetMFMNW_FirstUnitParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_LastUnitParamClassType,
    ModflowTypes.GetMFMNW_LastUnitParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_PumpingLimitsParamClassType,
    ModflowTypes.GetMFMNW_PumpingLimitsParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed2ExpressionNow(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_PumpingLimitsParamClassType,
    ModflowTypes.GetMFMNW_PumpingLimitsParamClassType.ANE_ParamName, True);

  MFLayerStructure.ListsOfIndexedLayers.SetIndexed2ExpressionNow(
    ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMFWellStressIndicatorParamType,
    ModflowTypes.GetMFWellStressIndicatorParamType.ANE_ParamName, True);

  for GroupIndex := 0 to MFLayerStructure.FirstListsOfIndexedLayers.Count -1 do
  begin
    Group := MFLayerStructure.FirstListsOfIndexedLayers.Items[GroupIndex];
    for LayerIndex := 0 to Group.Count -1 do
    begin
      Layer := Group.Items[LayerIndex];
      if (Layer is ModflowTypes.GetMFHeadObservationsLayerType)
        or (Layer is TBaseFluxObservationsLayer) then
      begin
        T_ANE_Layer(Layer).SetUnIndexedExpressionNow(
          ModflowTypes.GetMFTopLayerParamType,
          ModflowTypes.GetMFTopLayerParamType.ANE_ParamName, True);

        T_ANE_Layer(Layer).SetUnIndexedExpressionNow(
          ModflowTypes.GetMFBottomLayerParamType,
          ModflowTypes.GetMFBottomLayerParamType.ANE_ParamName, True);
      end;
      if (Layer is ModflowTypes.GetMFAdvectionObservationsStartingLayerType) then
      begin
        T_ANE_Layer(Layer).SetUnIndexedExpressionNow(
          ModflowTypes.GetMFAdvObsLayerParamType,
          ModflowTypes.GetMFAdvObsLayerParamType.ANE_ParamName, True);
      end;
      if (Layer is ModflowTypes.GetMFAdvectionObservationsLayerType) then
      begin
        T_ANE_Layer(Layer).SetUnIndexedExpressionNow(
          ModflowTypes.GetMFAdvObsLayerParamType,
          ModflowTypes.GetMFAdvObsLayerParamType.ANE_ParamName, True);
      end;

    end;
  end;

  InitialHeadsWarning;
  Modflow96Warnings;
  Modflow2000Warnings;

  frameOC_PrintHead.Sort;
  frameOC_PrintDrawdown.Sort;
  frameOC_PrintBudget.Sort;
  frameOC_SaveHead.Sort;
  frameOC_SaveDrawdown.Sort;
  frameOC_SaveFlows.Sort;
  
  if not UpdateHUF_Units then
  begin
    ModalResult := mrNone;
  end;

end;

procedure TfrmMODFLOW.adeFHBNumTimesEnter(Sender: TObject);
begin
  // triggering event: adeFHBNumTimes.OnEnter;
  inherited;

  // store the previous number of FHB times in case it needs to be
  // restored later.
  PreviousFHBTimes := StrToInt(adeFHBNumTimes.Text);
end;

procedure TfrmMODFLOW.MODPATHWarnings;
begin
  if not loading and not cancelling and cbMODPATH.Checked and cbTLK.Checked then
  begin
    Beep;
    MessageDlg('Warning: MODPATH and the current version of the '
      + 'Transient Leakage Package are incompatible.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.UpdateIFACE;
begin
  // add or remove the MODPATH IFACE parameters from the well layers
  // depending or whether or not you are using MODPATH and wells.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFWellLayerType.UseIFACE and cbWel.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFLineWellLayerType.UseIFACE and cbWel.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFAreaWellLayerType.UseIFACE and cbWel.Checked and cbUseAreaWells.Checked);

  // add or remove the MODPATH IFACE parameters from the river layers
  // depending or whether or not you are using MODPATH and rivers.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFPointRiverLayerType.UseIFACE and cbRiv.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFLineRiverLayerType.UseIFACE and cbRiv.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFAreaRiverLayerType.UseIFACE and cbRiv.Checked and cbUseAreaRivers.Checked);

  // add or remove the MODPATH IFACE parameters from the drain layers
  // depending or whether or not you are using MODPATH and drains.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointDrainLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFPointDrainLayerType.UseIFACE and cbDRN.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineDrainLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetLineDrainLayerType.UseIFACE and cbDRN.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaDrainLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetAreaDrainLayerType.UseIFACE and cbDRN.Checked and cbUseAreaDrains.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointDrainReturnLayerType,
    ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFPointDrainReturnLayerType.UseIFACE and cbDRT.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineDrainReturnLayerType,
    ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE and cbDRT.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaDrainReturnLayerType,
    ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE and cbDRT.Checked and cbUseAreaDrainReturns.Checked);

  // add or remove the MODPATH IFACE parameters from the
  // general-head boundary layers
  // depending or whether or not you are using MODPATH and
  // general-head boundaries.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetPointGHBLayerType.UseIFACE and cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetLineGHBLayerType.UseIFACE and cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetAreaGHBLayerType.UseIFACE and cbGHB.Checked and cbUseAreaGHBs.Checked);

  // add or remove the MODPATH IFACE parameters from the stream layers
  // depending or whether or not you are using MODPATH and streams.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFStreamLayerType.UseIFACE and cbSTR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMFIFACEParamType,
    cbMODPATH.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMFIFACEParamType,
    cbMODPATH.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFIFACEParamType,
    cbMODPATH.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType, ModflowTypes.GetMFIFACEParamType,
    cbMODPATH.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  // add or remove the MODPATH IFACE parameters from the well layers
  // depending or whether or not you are using MODPATH and CHD.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE and cbCHD.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE
    and cbCHD.Checked and cbUseAreaCHD.Checked);

  // add or remove the MODPATH IFACE parameters from the FHB layers
  // depending or whether or not you are using boundary flux package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFPointFHBLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFPointFHBLayerType.UseIFACE and cbFHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLineFHBLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFLineFHBLayerType.UseIFACE and cbFHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAreaFHBLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetMFAreaFHBLayerType.UseIFACE and cbFHB.Checked
    and cbUseAreaFHBs.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetPrescribedHeadLayerType, ModflowTypes.GetMFIFACEParamType,
    ModflowTypes.GetPrescribedHeadLayerType.UseIFACE);

end;

procedure TfrmMODFLOW.SetCompactOption;
begin
  if cbMODPATH.Checked or cbZonebudget.Checked then
  begin
    if rbMODFLOW2000.Checked or rbModflow2005.Checked then
    begin
      cbFlowBudget.Checked := True;
    end
    else
    begin
      cbFlowBudget.Checked := False;
    end;
    cbFlowBudget.Enabled := False;
  end
  else
  begin
    cbFlowBudget.Enabled := True;
  end;
end;

procedure TfrmMODFLOW.cbMODPATHClick(Sender: TObject);
begin
  // triggering event: cbMODPATH.OnClick;
  inherited;
  TestHeadExport(Sender);
  MODPATHWarnings;
  ModPathHNOFLO_Warning;
  // make the MODPATH  tabs visible when appropriate.
  // the MODPATH and MODPATH-options tabs should be visible whenever
  // MODPATH is used
  tabModpathGroup.TabVisible := cbMODPATH.Checked;

  cbModpathCOMPACT.Enabled := cbMODPATH.Checked;
  cbModpathBINARY.Enabled := cbMODPATH.Checked;
  EnableReleaseTimeCount;
  adeModpathMAXSIZ.Enabled := cbMODPATH.Checked;
  adeModpathNPART.Enabled := cbMODPATH.Checked;
  adeModpathTBEGIN.Enabled := cbMODPATH.Checked;

  comboMODPATH_RechargeITOP.Enabled := cbRCH.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked));
  SetComboColor(comboMODPATH_RechargeITOP);

  comboMODPATH_EvapITOP.Enabled := (cbEVT.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked)))
    or (cbETS.Checked and cbMOC3D.Checked and cbBFLX.Checked);
  SetComboColor(comboMODPATH_EvapITOP);

  // enable or disable other controls using existing methods.
  cbMPATHStopTimeClick(Sender);
  comboMPATHStartTimeMethodChange(Sender);
  cbMPATHTrackStopClick(Sender);
  comboMPATHOutModeChange(Sender);
  cbMPATHComputeLocClick(Sender);
  cbMPATHStopClick(Sender);
  comboMPATHTimeMethodChange(Sender);
  comboMPATHSinkTreatmentChange(Sender);
  cbFlowClick(Sender);
  SetCompactOption;

  if cbMODPATH.Checked or cbZonebudget.Checked then
  begin
    cbOneFlowFile.Checked := True;
    cbFlowBCF.Checked := True;
    cbFlowRCH.Checked := True;
    cbFlowDrn.Checked := True;
    cbFlowGHB.Checked := True;
    cbFlowRiv.Checked := True;
    cbFlowWel.Checked := True;
    cbFlowEVT.Checked := True;
    cbFlowFHB.Checked := True;
    cbFlowLPF.Checked := True;
    cbFlowHUF.Checked := True;
    if not cbSTR.Checked and not cbStrPrintFlows.Checked then
    begin
      cbFlowSTR.Checked := True;
    end;
    if not cbSFR.Checked and not cbSFRPrintFlows.Checked then
    begin
      cbFlowSFR.Checked := True;
    end;
  end;
  cbOneFlowFile.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked;
  cbFlowBCF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and (rgFlowPackage.ItemIndex = 0);
  cbFlowLPF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and (rgFlowPackage.ItemIndex = 1);
  cbFlowHUF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and (rgFlowPackage.ItemIndex = 2);
  cbFlowRCH.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbRch.Checked;
  cbFlowDrn.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbDrn.Checked;
  cbFlowDrt.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbDrt.Checked;
  cbFlowGHB.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbGHB.Checked;
  cbFlowRiv.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbRiv.Checked;
  cbFlowWel.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbWel.Checked;
  cbFlowEVT.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbEVT.Checked;
  cbFlowFHB.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbFHB.Checked;
  cbFlowSTR.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbStr.Checked;
  cbFlowSTR2.Enabled := cbStr.Checked;
  cbFlowSFR.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbSfr.Checked;
  cbFlowSFR2.Enabled := cbSfr.Checked;

  // add or remove the MODPATH zone layers from the layer structure
  // depending or whether or not you are using MODPATH.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMODPATHZoneLayerType, cbMODPATH.Checked);

  // add or remove the MODPATH layers from the layer structure
  // depending or whether or not you are using MODPATH.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMODPATHLayerType, cbMODPATH.Checked);

  // add or remove the porosity layers from the layer structure
  // depending or whether or not you are using MODPATH or MOC3D.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCPorosityLayerType, PorosityUsed);

  if cbMODPATH.Checked then
  begin
    MFLayerStructure.PostProcessingLayers.AddOrRemoveLayer
      (ModflowTypes.GetMODPATHPostLayerType, cbMODPATH.Checked);
  end;

  // add or remove the porosity parameters from the grid layer
  // depending or whether or not you are using MODPATH or MOC3D.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCPorosityParamType,
    PorosityUsed);

  // add or remove the MODPATH zone parameters from the grid layer
  // depending or whether or not you are using MODPATH.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridModpathZoneParamType,
    cbMODPATH.Checked);

  // update IFACE parameters.
  AddOrRemoveMnw2LayersAndParameters;
  UpdateIFACE;

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.adeMODPATHMaxReleaseTimeEnter(Sender: TObject);
begin
  // triggering events: adeMODPATHMaxReleaseTime.OnEnter;
  inherited;

  // when the user starts to edit the maximum number of MODPATH
  // release times, store the existing value in case it needs to
  // be restored latter.
  PreviousMODPATHReleaseTimesText := adeMODPATHMaxReleaseTime.Text;
end;

procedure TfrmMODFLOW.adeMODPATHMaxReleaseTimeExit(Sender: TObject);
var
  PreviousTimes, NewTimes: integer;
  Index: integer;
  ListOfParameterLists: TList;
  AList: TList;
  InnerIndex: integer;
begin
  // triggering events: adeMODPATHMaxReleaseTime.OnExit;
  inherited;
  try
    begin
      // get the new number of Maximum release times and the previous
      // number of maximum release times.
      NewTimes := StrToInt(adeMODPATHMaxReleaseTime.Text);
      PreviousTimes := StrToInt(PreviousMODPATHReleaseTimesText);
      if NewTimes > PreviousTimes then
      begin
        // add new release time parameters
        for Index := PreviousTimes + 1 to NewTimes do
        begin
          MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
            ModflowTypes.GetMODPATHLayerType,
            ModflowTypes.GetMFMODPATHTimeParamListType, -1);
        end;
      end
      else
      begin
        // delete release time parameters

        // get a list of the parameter lists in IndexedParamList1
        // of all layers
        ListOfParameterLists := MFLayerStructure.
          MakeParameter1Lists(PreviousTimes);
        try
          begin
            // loop over the times to be deleted
            for Index := PreviousTimes - 1 downto NewTimes do
            begin
              // get a list of parameter lists
              AList := ListOfParameterLists.Items[Index];
              // loop over the paramters lists
              for InnerIndex := AList.Count - 1 downto 0 do
              begin
                // check if the current item in the list of parameter
                // lists is a MODPATH time parameter list. If so delete it.
                if TObject(AList.Items[InnerIndex])
                  is ModflowTypes.GetMFMODPATHTimeParamListType then
                begin
                  (TObject(AList.Items[InnerIndex])
                    as ModflowTypes.GetMFMODPATHTimeParamListType).DeleteSelf;
                end;
              end;
            end;
          end;
        finally
          begin
            // free the objects created by
            // ListOfParameterLists := GetMFLayerStructure.
            //    MakeParameter1Lists(PreviousTimes);
            for Index := ListOfParameterLists.Count - 1 downto 0 do
            begin
              AList := ListOfParameterLists.Items[Index];
              AList.Free;
            end;
            ListOfParameterLists.Free
          end;
        end;
      end;
    end
  except on EConvertError do
    begin
      // if the user enters an invalid value, restore the previous value.
      adeMODPATHMaxReleaseTime.Text :=
        PreviousMODPATHReleaseTimesText;
      Beep;
    end;
  end;
end;

procedure TfrmMODFLOW.sgMODPATHOutputTimesExit(Sender: TObject);
var
  RowIndex: integer;
begin
  // triggering events: sgMODPATHOutputTimes.OnExit;
  // called by GLoadForm in ProjectFunctions
  inherited;

  // check that all data in the MODPATH Times grid is valid
  for RowIndex := 1 to sgMODPATHOutputTimes.RowCount - 1 do
  begin
    try
      InternationalStrToFloat(sgMODPATHOutputTimes.Cells[1, RowIndex]);
    except on EConvertError do
        sgMODPATHOutputTimes.Cells[1, RowIndex] := '0';
    end;

  end;
end;

procedure TfrmMODFLOW.sgTimeExit(Sender: TObject);
var
  RowIndex: integer;
  Period: Integer;
  VarCount: Integer;
begin
  // triggering event: dgTime.OnExit;
  // called by GLoadForm in ProjectFunctions
  inherited;

  for RowIndex := 1 to dgTime.RowCount - 1 do
  begin
    try
      begin
        InternationalStrToFloat(dgTime.Cells[Ord(tdLength), RowIndex]);
      end;
    except on EConvertError do
      begin
        dgTime.Cells[Ord(tdLength), RowIndex] := '1';
      end;
    end;

    try
      begin
        StrToInt(dgTime.Cells[Ord(tdNumSteps), RowIndex]);
      end;
    except on EConvertError do
      begin
        dgTime.Cells[Ord(tdNumSteps), RowIndex] := '1';
      end;
    end;

    try
      begin
        InternationalStrToFloat(dgTime.Cells[Ord(tdMult), RowIndex]);
      end;
    except on EConvertError do
      begin
        dgTime.Cells[Ord(tdMult), RowIndex] := '1';
      end;
    end;
  end;

  // set the maximum step numbers to appropriate values.
  adeModpathBeginStep.Max := StrToInt(dgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeModpathBeginPeriod.Text)]);

  adeModpathBeginStepExit(nil);

  Period := StrToInt(adeModpathEndPeriod.Text);
  if Period = 0 then
  begin
    Period := dgTime.RowCount - 1;
  end;
  adeModpathEndStep.Max := StrToInt(dgTime.Cells[Ord(tdNumSteps), Period]);

  adeMPATHRefStep.Max := StrToInt(dgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeMPATHRefPeriod.Text)]);

  SetLakesSteady;

  rdeGwmStorageStateVarCount.Enabled := IsAnyTransient;
  btnAddGwmStorageStateVar.Enabled := rdeGwmStorageStateVarCount.Enabled;
  btnInsertGwmStorageStateVar.Enabled := rdeGwmStorageStateVarCount.Enabled;
  rdeZoneCount.Enabled := rdeGwmStorageStateVarCount.Enabled;
  VarCount := StrToInt(rdeGwmStorageStateVarCount.Output);
  rdgGwmStorageVariables.Enabled := rdeGwmStorageStateVarCount.Enabled and (VarCount > 0);
  btnInsertGwmStorageStateVar.Enabled := rdeGwmStorageStateVarCount.Enabled;
  btnAddGwmStorageStateVar.Enabled := rdeGwmStorageStateVarCount.Enabled;
  btnDeleteGwmStorageStateVar.Enabled := rdeGwmStorageStateVarCount.Enabled
    and (VarCount > 0);
end;

procedure TfrmMODFLOW.adeModpathBeginPeriodExit(Sender: TObject);
begin
  // triggering events: adeModpathBeginPeriod.OnExit;
  // called by GLoadForm;
  inherited;

  // set the maximum allowed value for the beginning step to the maximum
  // number of steps for the stress period
  adeModpathBeginStep.Max := StrToInt(dgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeModpathBeginPeriod.Text)]);
  adeModpathBeginStepExit(nil);
  // set the minimum ending period to the beginning period
//  adeModpathEndPeriod.Min := StrToInt(adeModpathBeginPeriod.Text);
//  adeModpathBeginStepExit(nil);

  // set other maximum or minimums according to adeModpathBeginStep
  adeModpathBeginStepExit(nil);
end;

procedure TfrmMODFLOW.adeModpathBeginStepExit(Sender: TObject);
begin
  // triggering events: adeModpathBeginStep.OnExit;
  // triggering events: adeModpathEndPeriod.OnExit;
  // called by adeModpathBeginPeriodExit;
  inherited;
  {  adeModpathBeginStep.Max := StrToInt(dgTime.Cells[Ord(tdNumSteps),
          StrToInt(adeModpathBeginPeriod.Text)]);   }
    // check if the MODPATH beginning period is the same as the MODPATH
    // ending period
  if StrToInt(adeModpathBeginPeriod.Text) = StrToInt(adeModpathEndPeriod.Text)
    then
  begin
    // if they are the same, the minimum ending step is the beginning step.
    adeModpathEndStep.Min := StrToInt(adeModpathBeginStep.Text);
  end
  else
  begin
    // if they are different, the minimum ending step is 0.
    adeModpathEndStep.Min := 0;
  end;
end;

procedure TfrmMODFLOW.adeZoneBudCompZoneCountChange(Sender: TObject);
var
  NumOfZones: integer;
begin
  inherited;
  // get the number of zonebuget compositie zones.
  NumOfZones := StrToInt(adeZoneBudCompZoneCount.Text);
  // set the number of rows in the composite zones grid to the number
  // of composite zones
  sgZoneBudCompZones.RowCount := NumOfZones;

  // all the composite zone grid to be editted if there will be composite
  // zones.
  if NumOfZones > 0 then
  begin
    sgZoneBudCompZones.Options := sgZoneBudCompZones.Options + [goEditing];
  end
  else
  begin
    sgZoneBudCompZones.Options := sgZoneBudCompZones.Options - [goEditing];
  end;
end;

procedure TfrmMODFLOW.sgZoneBudCompZonesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  // triggering events: sgZoneBudCompZones.OnSetEditText;
  inherited;

  // check that only valid data are entered in the composite zones grid
  if (ACol > 0) then
  begin
    if not (Value = '') then
    begin
      try
        begin
          StrToInt(Value);
        end;
      except on EConvertError do
        begin
          // restore the previous value if the data is invalid.
          sgZoneBudCompZones.Cells[ACol, ARow] := PrevCompZoneText;
          Beep;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.sgZoneBudCompZonesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  // triggering events: sgZoneBudCompZones.OnSelectCell;
  inherited;

  // when the user begins to edit a value in the Zonebudget composite
  // zones grid, store it in case it needs to be restored later.
  PrevCompZoneText := sgZoneBudCompZones.Cells[ACol, ARow];
end;

procedure TfrmMODFLOW.rgZonebudTimesChoiceClick(Sender: TObject);
begin
  // triggering events: rgZonebudTimesChoice.OnClick;
  inherited;
  // if the user chooses to use specified output time for ZONEBUDGET
  // allow them to specify those times.
  sgZondbudTimes.Enabled := (rgZonebudTimesChoice.ItemIndex = 1);
  if sgZondbudTimes.Enabled then
  begin
    sgZondbudTimes.Color := clWindow;
  end
  else
  begin
    sgZondbudTimes.Color := clBtnFace;
  end;

end;

procedure TfrmMODFLOW.cbZonebudgetClick(Sender: TObject);
begin
  // triggering event: cbZonebudget.OnClick;
  inherited;
  // if the user chooses zonebuget, make the zonebudget tab visible.
  tabZoneBudget.TabVisible := cbZonebudget.Checked;
  adeZonebudgetTitle.Enabled := cbZonebudget.Checked;
  adeZoneBudCompZoneCount.Enabled := cbZonebudget.Checked;

  rgZonebudTimesChoice.Enabled := cbZonebudget.Checked;

  adeZoneBudCompZoneCountExit(Sender);

  rgZonebudTimesChoiceClick(Sender);

  // Zonebudget can't read compact budget files so disable the compact
  // budget file option and uncheck it if it is checked.

{  cbFlowBudget.enabled := not cbZonebudget.Checked;
  if not cbFlowBudget.enabled then
  begin
    cbFlowBudget.Checked := False;
  end;
 }

  // Version 2 of Zonebudget does read compact budget files and needs
  // them to be in the compact format in some circumstances
//  cbFlowBudget.Checked := cbZonebudget.Checked;

  cbMODPATHClick(Sender);

  // add or remove zonebudget layers from the layer structure
  // depending on whether or not zonebudget will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetZoneBudLayerType, cbZonebudget.Checked);

  // add or remove zonebudget parameters from the grid layer
  // depending on whether or not zonebudget will be used.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridZoneBudgetParamType,
    cbZonebudget.Checked);

end;

function TfrmMODFLOW.GetCompositeZone(const Zone: Integer): string;
  function PadZoneNumber(ZoneNumber: string): string;
  begin
    // convert a zone number string to a string with exactly 4 spaces
    // This is done because ZONEBUDGET requires that the zones making up
    // the composite zone be in I4 format.
    result := Copy(ZoneNumber, 1, 4);
    while Length(Result) < 4 do
    begin
      Result := ' ' + Result;
    end;
  end;
var
  Row: integer;
  ColumnIndex: integer;
begin
  // called by GetZoneBudCompositeZone

  // get the row for the composite zone.
  Row := Zone - 1;

  // initialize the result.
  result := '';

  // loop over the columns and add the zones in each column to
  // the string that represents the composite zones.
  for ColumnIndex := 1 to 10 do
  begin
    Result := Result + PadZoneNumber(Trim
      (sgZoneBudCompZones.Cells[ColumnIndex, Row]));
  end;
end;

procedure TfrmMODFLOW.comboSIPIterSeedChange(Sender: TObject);
begin
  // triggering events: comboSIPIterSeed.OnChange;
  inherited;

  // only allow the user to enter the SIP iteration seed if
  // it will be used.
  adeSIPIterSeed.Enabled := (comboSIPIterSeed.ItemIndex = 0);

end;

procedure TfrmMODFLOW.adeMODPATHOutputTimeCountEnter(Sender: TObject);
begin
  // triggering events: adeMODPATHOutputTimeCount.OnEnter;
  inherited;

  // when the user begins editting the number of times at which output from
  // MODPATH is desired, store the existing value in case it needs to
  // be restored.
  PreviousMODPATHTimeText := adeMODPATHOutputTimeCount.Text;

end;

procedure TfrmMODFLOW.adeMODPATHOutputTimeCountExit(Sender: TObject);
var
  RowIndex: integer;
begin
  // triggering events: adeMODPATHOutputTimeCount.OnExit;
  inherited;

  // check for valid data in the "number of times at which output from
  // MODPATH is desired" edit box. update the grid with the new number.
  try
    begin
      if not (adeMODPATHOutputTimeCount.Text = '') then
      begin
        // update the number of rows in the grid
        sgMODPATHOutputTimes.RowCount
          := StrToInt(adeMODPATHOutputTimeCount.Text) + 1;

        // update the grid and make sure there are now blank spaces in it.
        for RowIndex := 1 to sgMODPATHOutputTimes.RowCount - 1 do
        begin
          sgMODPATHOutputTimes.Cells[0, RowIndex] := IntToStr(RowIndex);
          if sgMODPATHOutputTimes.Cells[1, RowIndex] = '' then
          begin
            sgMODPATHOutputTimes.Cells[1, RowIndex] := '0';
          end;
        end;
      end;
    end;
  except on EConvertError do
    begin
      // if the user enters invalid data, restore the old value.
      if not (adeMODPATHOutputTimeCount.Text = '') then
      begin
        adeMODPATHOutputTimeCount.Text := PreviousMODPATHTimeText;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeZoneBudCompZoneCountEnter(Sender: TObject);
begin
  // triggering events: adeZoneBudCompZoneCount.OnEnter;
  inherited;

  // when a user begins to edit the Number of ZONEBUDGET Composite zones,
  // store the existing value in case it has to be restored.
  PrevCompZoneCount := adeZoneBudCompZoneCount.Text;
end;

procedure TfrmMODFLOW.SetZoneBudgetCompositeZoneTitles;
var
  AChar: Char;
  Index: integer;
begin
  AChar := 'A';
  for Index := 0 to sgZoneBudCompZones.RowCount - 1 do
  begin
    sgZoneBudCompZones.Cells[0, Index] := AChar;
    if AChar = 'Z' then
    begin
      AChar := 'A';
    end
    else
    begin
      Inc(AChar);
    end;
  end;
end;

procedure TfrmMODFLOW.adeZoneBudCompZoneCountExit(Sender: TObject);
var
  NumZones: integer;
  //  Index : integer;
  //  AChar : Char;
begin
  // triggering events: adeZoneBudCompZoneCount.OnExit;
  inherited;
  try
    begin
      // get the number of Number of ZONEBUDGET Composite zones
      NumZones := StrToInt(adeZoneBudCompZoneCount.Text);

      // set the number of rows in the composite zones grid to the number
      // of composite zones.
      sgZoneBudCompZones.RowCount := NumZones;

      // if there will be at least one composite zone, allow the user
      // to edit the composite zones.
//      sgZoneBudCompZones.Enabled := (NumZones > 0);

      if (NumZones > 0) then
      begin
        sgZoneBudCompZones.Options := sgZoneBudCompZones.Options + [goEditing];
        sgZoneBudCompZones.Color := clWindow;
      end
      else
      begin
        sgZoneBudCompZones.Options := sgZoneBudCompZones.Options - [goEditing];
        sgZoneBudCompZones.Color := clBtnFace;
      end;

      // write zone numbers in the first column of the composite
      // zones grid.
      SetZoneBudgetCompositeZoneTitles;
    end;
  except on EConvertError do
    begin
      // if the user enter bad data, restore the previous value.
      adeZoneBudCompZoneCount.Text := PrevCompZoneCount;
      Beep;
    end;
  end;

end;

function TfrmMODFLOW.GetZonebudTimesCount: integer;
var
  RowIndex: integer;
begin
  // called by GetZoneBudTimeCount in ZoneBudgetFunctions.

  // initialize the result
  result := 0;

  // check that values have been entered for at least the first column
  // Increment the result for each composite zone for which data has been
  // entered. Quit when you encounter the first row for which no data has
  // been entered.
  for RowIndex := 1 to sgZondbudTimes.RowCount - 1 do
  begin
    if Trim(sgZondbudTimes.Cells[1, RowIndex]) <> '' then
    begin
      Inc(result);
    end
    else
    begin
      break;
    end;
  end;
end;

function TfrmMODFLOW.GetZoneBudTimeStep(ATime: integer): integer;
begin
  // called by GetZoneBudTimeStep in ZoneBudgetFunctions

  // returns the time step for a particular specified time in Zonebudget
  try
    Result := StrToInt(sgZondbudTimes.Cells[2, ATime]);
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := 1;
    end;
  end;
end;

function TfrmMODFLOW.GetZoneBudStressPeriod(ATime: integer): Integer;
begin
  // called by GetZoneBudStressPeriod in Zonebudget functions

  // returns the stress period for a particular specified time in Zonebudget
  try
    Result := StrToInt(sgZondbudTimes.Cells[1, ATime]);
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := 1;
    end;
  end;
end;

procedure TfrmMODFLOW.pageControlMainChange(Sender: TObject);
var
  //  ControlIndex : integer;
  APageControl: TPageControl;
begin
  // triggering event: pageControlMain.OnChange;
  inherited;
  if Sender is TPageControl then
  begin
    FreePageControlResources(TPageControl(Sender), Handle);
  end;

  // The following "for" loop ensures that everything gets displayed properly.
{  for ControlIndex := 0 to ControlCount -1 do
  begin
    if Controls[ControlIndex] is TWinControl then
    begin
      TWinControl(Controls[ControlIndex]).Handle;
    end;
  end; }

  statbarMain.SimpleText := '';

  APageControl := Sender as TPageControl;
  tabModpathGroup.HelpContext := pageControlModpath.ActivePage.HelpContext;

  // change the help context of the Help button to the correct number for the
  // current tab.
  BitBtnHelp.HelpContext := APageControl.ActivePage.HelpContext;

  if pageControlMain.ActivePage = tabAbout then
  begin
    memoReferences.Lines.Assign(StrSetDocs.Strings);
    memoDisclaimer.Lines.Assign(StrSetDisclaimer.Strings);
  end;
end;

procedure TfrmMODFLOW.cbMPATHStopTimeClick(Sender: TObject);
begin
  // triggering events: cbMPATHStopTime.OnClick;
  // called by comboSteadyChange;
  // called by cbMODPATHClick;
  inherited;

  // when the "Stop computing paths after a specified time" checkbox is
  // and you have a steady state model and you are using MODPATH
  // allow the use to enter the stopping time.
  adeMODPATHStopTime.Enabled := cbMPATHStopTime.Checked
    and (ModPathSteady = 1) and cbMODPATH.Checked;

end;

procedure TfrmMODFLOW.comboMPATHStartTimeMethodChange(Sender: TObject);
begin
  // triggering events: comboMPATHStartTimeMethod.OnChange;
  // called by comboSteadyChange;
  // called by cbMODPATHClick;
  inherited;

  // enable or disable the controls for specifying reference times
  // disable them for transient models, or if MODPATH is not used or
  // if the combo used for specifying the method has been disabled.
  // Also check what method is used for determining which should
  // be enabled or disabled.
  adeMPATHRefPeriod.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 0)
    and (ModPathSteady = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

  adeMPATHRefStep.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 0)
    and (ModPathSteady = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

  adeMPATHRefTimeInStep.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 0)
    and (ModPathSteady = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

  adeMPATHRefTime.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 1)
    and (ModPathSteady = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

end;

procedure TfrmMODFLOW.cbMPATHTrackStopClick(Sender: TObject);
begin
  // triggering events: cbMPATHTrackStop.OnClick;
  // called by comboSteadyChange;
  // called by cbMODPATHClick;
  inherited;

  // allow the user to specify the maximum tracking time for MODPATH
  // if they have chosen to specify a maximum tracking time.
  adeMPATHMaxTrack.Enabled := cbMPATHTrackStop.Checked
    and (ModPathSteady = 0) and cbMODPATH.Checked;

end;

procedure TfrmMODFLOW.comboMPATHDirectionChange(Sender: TObject);
begin
  inherited;
  EnableReleaseTimeCount;
  lblModpathBackwardsWarning.Visible := comboMPATHDirection.ItemIndex = 1;
end;

procedure TfrmMODFLOW.comboMPATHOutModeChange(Sender: TObject);
begin
  // triggering events: comboMPATHOutMode.OnChange;
  // called by cbMODPATHClick;
  inherited;
  // if you are computing pathlines for MODPATH, allow the user to
  // decide whether to compute locations at specific times.
  cbMPATHComputeLoc.Enabled := (comboMPATHOutMode.ItemIndex = 1)
    and cbMODPATH.Checked;
  lblMPATHComputeLoc.Enabled := cbMPATHComputeLoc.Enabled;
  cbMPATHComputeLocClick(Sender);

  // if the user is specifying a time series, require the user to compute
  // locations at specified times.
  if (comboMPATHOutMode.ItemIndex = 2) then
  begin
    cbMPATHComputeLoc.Checked := True;
  end;

  // allow the user to decide if particles will stop if they enter a
  // particular zone if the user is computing endpoints.
  comboMPATHWhichParticles.Enabled := cbMPATHStop.Checked and
    (comboMPATHOutMode.ItemIndex = 0) and cbMODPATH.Checked;
  SetComboColor(comboMPATHWhichParticles);

end;

procedure TfrmMODFLOW.cbMPATHComputeLocClick(Sender: TObject);
begin
  // triggering events: cbMPATHComputeLoc.OnClick;
  // called by cbMODPATHClick;
  inherited;
  // If you are computing output at specified times, allow the user to
  // choose the "Method of specifying times for output"
  comboMPATHTimeMethod.Enabled := cbMPATHComputeLoc.Checked
    and cbMODPATH.Checked
    and (cbMPATHComputeLoc.Enabled or (comboMPATHOutMode.ItemIndex = 2));

  SetComboColor(comboMPATHTimeMethod);

  // make other controls visible depending on how the user is specifying times.
  comboMPATHTimeMethodChange(Sender)

end;

procedure TfrmMODFLOW.comboMPATHTimeMethodChange(Sender: TObject);
var
  Index: integer;
begin
  // triggering events: comboMPATHTimeMethod.OnChange;
  // called by cbMODPATHClick;
  // called by cbMPATHComputeLocClick;
  inherited;
  if tabModpathGroup.TabVisible then
  begin
    for Index := 0 to pageControlModpath.PageCount - 1 do
    begin
      pageControlModpath.Pages[Index].HandleNeeded;
    end;
    tabModpathTimes.TabVisible := cbMPATHComputeLoc.Checked
      and (comboMPATHTimeMethod.ItemIndex = 1)
      and comboMPATHTimeMethod.Enabled;
    FreePageControlResources(pageControlModpath, Handle);
  end;

  // if you are specifying times using a time interval, enable the edit boxes
  // for the time interval and the maximum number of time points
  adeMPATHTimeInt.Enabled := cbMODPATH.Checked
    and cbMPATHComputeLoc.Checked and (comboMPATHTimeMethod.ItemIndex = 0)
    and comboMPATHTimeMethod.Enabled;

  adeMPATHMaxTimes.Enabled := cbMODPATH.Checked
    and cbMPATHComputeLoc.Checked and (comboMPATHTimeMethod.ItemIndex = 0)
    and comboMPATHTimeMethod.Enabled;

end;

procedure TfrmMODFLOW.comboMPATHSinkTreatmentChange(Sender: TObject);
begin
  // triggering events: comboMPATHSinkTreatment.OnChange;
  // called by cbMODPATHClick;
  inherited;

  // if particles stop at weak sink cells that exceed a specified strength,
  // allow the user to specify the strength that will cause particles to stop.
  adeMPATHSinkStrength.Enabled := (comboMPATHSinkTreatment.ItemIndex = 2)
    and cbMODPATH.Checked;
end;

procedure TfrmMODFLOW.cbMPATHStopClick(Sender: TObject);
begin
  // triggering events: cbMPATHStop.OnClick;
  // called by cbMODPATHClick
  inherited;

  // if particles will stop in a particular zone, allow the user to specify
  // which zone they will stop in.
  adeMPATHStopZone.Enabled := cbMPATHStop.Checked and cbMODPATH.Checked;

  // allow the user to choose whether to record endpoint data for all
  // particles or only those that stop in a particular zone.
  comboMPATHWhichParticles.Enabled := cbMPATHStop.Checked and
    (comboMPATHOutMode.ItemIndex = 0) and cbMODPATH.Checked;

  SetComboColor(comboMPATHWhichParticles);

end;

function TfrmMODFLOW.RowNeeded(Row: integer): boolean;
var
  firstRow, LastRow: integer;
begin
  // called by sgMOC3DTransParamSelectCell
  // called by sgMOC3DTransParamDrawCell

     // this function returns True if a particular geologic unit is within
     // the MOC3D subgrid.
  firstRow := StrToInt(adeMOC3DLay1.Text);
  LastRow := StrToInt(adeMOC3DLay2.Text);
  if LastRow = -1 then
  begin
    LastRow := StrToInt(edNumUnits.Text);
  end;
  result := not ((Row < firstRow) or (Row > LastRow))
end;

function TfrmMODFLOW.GetPIEVersion(AControl: Tcontrol): string;
begin
  // called by FormCreate

  // this fucntion extracts to PIE version number from the TVersionLabel
{  result := TVersionLabel(AControl).InfoString;
  Result := Copy(result, Length(verLabel.infoPrefix)+1,Length(result)); }

  result := TLabel(AControl).Caption;
end;

class function TfrmMODFLOW.PieIsEarlier(VersionInString,
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

procedure TfrmMODFLOW.adeMPATHRefPeriodExit(Sender: TObject);
begin
  // triggering events: adeMPATHRefPeriod.OnExit;
  inherited;

  // after changing the reference time period, update the maximum step number
  // for the reference time step.
  adeMPATHRefStep.Max := StrToInt(dgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeMPATHRefPeriod.Text)]);
end;

procedure TfrmMODFLOW.ReadOld_IDPTIM(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  Line: integer;
begin
  Line := LineIndex;
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbIDPTIM_Decay, DataToRead,
    VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbIDPTIM_Growth, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOld_IDKTIM(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  Line: integer;
begin
  Line := LineIndex;
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbIDKTIM_DisDecay, DataToRead,
    VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbIDKTIM_SorbDecay, DataToRead,
    VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbIDKTIM_DisGrowth, DataToRead,
    VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbIDKTIM_SorbGrowth,
    DataToRead, VersionControl);
end;

procedure TfrmMODFLOW.ReadOldTimeData(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  RowIndex: integer;
begin
  ReadStringGrid(LineIndex, FirstList, IgnoreList, dgTime, DataToRead,
    VersionControl);
  dgTime.ColCount := Ord(High(timeData))+1;
  for RowIndex := 1 to dgTime.RowCount - 1 do
  begin
    dgTime.Cells[Ord(tdSsTr), RowIndex]
      := dgTime.Columns[Ord(tdSsTr)].PickList[comboSteady.ItemIndex];
    sgTimeSetEditText(dgTime, 1, RowIndex, dgTime.Cells[1, RowIndex]);
  end;

end;

procedure TfrmMODFLOW.ReadOldProgramChoice(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  AnInteger: integer;
  AText: string;

begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AnInteger := StrToInt(AText);
  if AnInteger > 0 then
  begin
    rbMODFLOW2000.Checked := True;
  end
  else
  begin
    rbModflow96.Checked := True;
  end;

end;

procedure TfrmMODFLOW.ReadOldGeoData(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
var
  ColIndex, RowIndex: Integer;
  AText: string;
  ColLimit: integer;
begin
  // called when loading an old file that used a different control instead
  // of dgGeol
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  dgGeol.RowCount := StrToInt(AText) + 1;
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ColLimit := StrToInt(AText);

  for ColIndex := 1 to ColLimit do
  begin
    for RowIndex := 1 to dgGeol.RowCount - 1 do
    begin
      AText := DataToRead[LineIndex];
      Inc(LineIndex);
      if (ColIndex = Ord(nuiSim)) or (ColIndex = Ord(nuiTrans))
        or (ColIndex = Ord(nuiType)) then
      begin
        try
          dgGeol.Cells[ColIndex, RowIndex] :=
            dgGeol.Columns[ColIndex].Picklist.Strings[StrToInt(AText)];
        except on EConvertError do
          begin
            dgGeol.Cells[ColIndex, RowIndex] := AText;
          end;
        end;
      end
      else
      begin
        dgGeol.Cells[ColIndex, RowIndex] := AText;
      end;
    end;
  end;
  dgGeolExit(dgGeol);
end;

procedure TfrmMODFLOW.ReadOldIDIREC(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  AText: string;
  AnInteger: integer;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AnInteger := StrToInt(AText);
  if AnInteger > 0 then
  begin
    comboMOC3D_IDIREC.ItemIndex := AnInteger - 1;
  end
  else
  begin
    comboMOC3D_IDIREC.ItemIndex := 0;
  end;

end;

procedure TfrmMODFLOW.ReadOldedMT3DLength(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  Inc(LineIndex);
  // skip reading length unit for
  //MT3D because it now comes from MODFLOW.
//  edMT3DLength
end;

procedure TfrmMODFLOW.ReadEPSSLV(var LineIndex: integer; FirstList, IgnoreList:
  TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
var
  AText: string;
  AFloat: double;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AFloat := InternationalStrToFloat(AText);
  if AFloat <> 0 then
  begin
    adeMOCTolerance.Text := AText;
  end
end;

procedure TfrmMODFLOW.btnDeveloperClick(Sender: TObject);
begin
  // triggering event btnDeveloper.OnClick
  inherited;
  ShowMessage(PIEDeveloper);
end;

procedure TfrmMODFLOW.dgGeolSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  AGeologicUnit: T_ANE_IndexedLayerList;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
  LayerType: integer;
begin
  // triggering event dgGeol.OnSetEditText
  inherited;
  TestHeadExport(Sender);
  // check that vertical discretization is an integer.
  if (ACol > 0) and (ARow > 0) then
  begin
    if ACol = Ord(nuiSim) then
    begin
      if ((ARow = 1) or (ARow = dgGeol.RowCount - 1)) and not loading and
        not cancelling then
      begin
        if Value = dgGeol.Columns[Ord(nuiSim)].PickList[0] then
        begin
          Beep;
          MessageDlg('Non-simulated units are not allowed for the top and bottom '
            + 'geologic units.', mtError, [mbOK], 0);
          dgGeol.Cells[ACol, ARow] := dgGeol.Columns[Ord(nuiSim)].PickList[1];
        end;
      end;
      if dgGeol.Cells[ACol, ARow] = dgGeol.Columns[Ord(nuiSim)].PickList[0] then
      begin
        dgGeol.Cells[Ord(nuiVertDisc), ARow] := '1';
      end;
      dgGeol.Invalidate;
    end;
    if ACol = Ord(nuiVertDisc) then
    begin
      try
        begin
          if dgGeol.Cells[ACol, ARow] <> '' then
          begin
            StrToInt(dgGeol.Cells[ACol, ARow]);
            LastGeologyText := dgGeol.Cells[ACol, ARow];
          end;
          if not Loading and not Cancelling then
          begin
            GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
              (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
            AParameterList := GridLayer.IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(ARow - 1);
            AParameterList.SetExpressionNow(ModflowTypes.
              GetMFGridLakeLocationParamType, ModflowTypes.
              GetMFGridLakeLocationParamType.ANE_ParamName, True);
          end;
        end;
      except on EConvertError do
        begin
          dgGeol.Cells[ACol, ARow] := LastGeologyText;
          Beep;
        end;
      end;
    end;
    if (ACol = Ord(nuiSpecT)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow - 1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFTransmisivityLayerType,
        (dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1])
        and (rgFlowPackage.ItemIndex = 0));

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow - 1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridTransParamType,
        ModflowTypes.GetMFGridTransParamType.Ane_ParamName,
        (dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1])
        and (rgFlowPackage.ItemIndex = 0));

    end;
    if (ACol = Ord(nuiSpecVCONT)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow - 1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFVcontLayerType,
        (dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1])
        and (rgFlowPackage.ItemIndex = 0));

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow - 1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridVContParamType,
        ModflowTypes.GetMFGridVContParamType.Ane_ParamName,
        (dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1])
        and (rgFlowPackage.ItemIndex = 0));
    end;
    if (ACol = Ord(nuiSpecSF1)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow - 1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFConfStorageLayerType,
        (dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1])
        and (rgFlowPackage.ItemIndex = 0));

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow - 1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridConfStoreParamType,
        ModflowTypes.GetMFGridConfStoreParamType.Ane_ParamName,
        (dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1])
        and (rgFlowPackage.ItemIndex = 0));
    end;
    if (ACol = Ord(nuiSpecAnis)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow - 1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFAnistropyLayerType,
        AnisotropyUsed(ARow));

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow - 1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridAnisoParamType,
        ModflowTypes.GetMFGridAnisoParamType.Ane_ParamName,
        AnisotropyUsed(ARow));
      dgGeol.Invalidate;
    end;
    if ACol = Ord(nuiType) then
    begin
      LayerType := dgGeol.Columns[Ord(nuiType)].Picklist.
        IndexOf(dgGeol.Cells[Ord(nuiType), ARow]);
      if (ACol = Ord(nuiType)) and (ARow > 1) then
      begin
        if (rgFlowPackage.ItemIndex = 0) and
          (dgGeol.Cells[Ord(nuiType), ARow] =
          dgGeol.Columns[Ord(nuiType)].Picklist[1]) then
        begin
          dgGeol.Cells[Ord(nuiType), ARow] :=
            dgGeol.Columns[Ord(nuiType)].Picklist[3];
          LayerType := 3;
        end;
      end;
      if not ((LayerType = 0) or (LayerType = 2)) then
      begin
        dgGeol.Cells[Ord(nuiSpecT), ARow] :=
          dgGeol.Columns[Ord(nuiSpecT)].Picklist[0];
      end;
    end;
  end;
  // begin MT3D
  if Ord(nuiName) = ACol then
  begin
    sgReaction.Cells[Ord(rdmName), ARow] := dgGeol.Cells[Ord(nuiName), ARow];
    sgDispersion.Cells[Ord(ddmName), ARow] := dgGeol.Cells[Ord(nuiName), ARow];
  end;
  // end MT3D

end;

procedure TfrmMODFLOW.dgGeolSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  ArithmeticAndLogarithmicUsed: boolean;
  RowIndex: integer;
  LayerType: integer;
begin
  inherited;
  // save contents of cell in case it needs to be restored.
  LastGeologyText := dgGeol.Cells[ACol, ARow];

  // Set IAPART if needed.
  ArithmeticAndLogarithmicUsed := false;
  for RowIndex := 1 to dgGeol.RowCount - 1 do
  begin
    if rgFlowPackage.ItemIndex = 0 then
    begin
      if dgGeol.Cells[Ord(nuiTrans), RowIndex]
        = dgGeol.Columns[Ord(nuiTrans)].Picklist.Strings[3] then
      begin
        ArithmeticAndLogarithmicUsed := True;
        break;
      end;
    end
    else
    begin
      with dgGeol do
      begin
        if (Columns[Ord(nuiTrans)].Picklist.Count > 1) and
        (Cells[Ord(nuiTrans), RowIndex]
          = Columns[Ord(nuiTrans)].Picklist.Strings[2]) then
        begin
          ArithmeticAndLogarithmicUsed := True;
          break;
        end;
      end;
    end;
  end;
  comboIAPART.Enabled := not ArithmeticAndLogarithmicUsed;
  SetComboColor(comboIAPART);

  if not comboIAPART.Enabled then
  begin
    comboIAPART.ItemIndex := 1;
  end;

  if (ACol = Ord(nuiSpecT)) then
  begin
    LayerType := dgGeol.Columns[Ord(nuiType)].Picklist.
      IndexOf(dgGeol.Cells[Ord(nuiType), ARow]);
    if not ((LayerType = 0) or (LayerType = 2)) then
    begin
      CanSelect := False;
    end;
  end;
  if (ACol > Ord(nuiSim)) and (dgGeol.Columns[Ord(nuiSim)].Picklist.
    IndexOf(dgGeol.Cells[Ord(nuiSim), ARow]) = 0) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiAnis)) and (dgGeol.Columns[Ord(nuiSpecAnis)].Picklist.
    IndexOf(dgGeol.Cells[Ord(nuiSpecAnis), ARow]) = 1)
  and (rgFlowPackage.ItemIndex = 1) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiAnis))
    and (rgFlowPackage.ItemIndex = 2) then
  begin
    CanSelect := False;
  end;
  // show cell as disabled if LPF is not chosen
  if (ACol = Ord(nuiSpecAnis))
    and (rgFlowPackage.ItemIndex <> 1) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiWettingActive)) and ((comboWetCap.ItemIndex = 0)
    or (rgFlowPackage.ItemIndex = 0)) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiWettingActive)) then
  begin
    LayerType := dgGeol.Columns[Ord(nuiType)].Picklist.
      IndexOf(dgGeol.Cells[Ord(nuiType), ARow]);
    if (LayerType = 0) then
    begin
      CanSelect := False;
    end;
  end;

  if ((ACol = Ord(nuiSpecT)) or (ACol = Ord(nuiSpecVCONT))
    or (ACol = Ord(nuiSpecSF1)))
    and (rgFlowPackage.ItemIndex <> 0) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiSpecSF1))
    and (rgFlowPackage.ItemIndex = 0)
    and (comboSteady.ItemIndex = 1) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiSpecAnis)) and lpfHaniParametersUsed then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(nuiSim)) and (rgFlowPackage.ItemIndex = 2) then
  begin
    CanSelect := False;
  end;
  if (Sender = dgGeol) and (GeologyRow <> ARow) then
  begin
    GeologyRow := ARow;
    dgGeol.Invalidate;
  end;

end;

procedure TfrmMODFLOW.sgZondbudTimesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  // save contents of cell in case it needs to be restored.
  PrevZoneBudTime := sgZondbudTimes.Cells[ACol, ARow];

end;

procedure TfrmMODFLOW.sgZondbudTimesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  // check that stress periods and time steps for Zonebudget specified
  // times are all integers.
  try
    begin
      if (ACol > 0) and (ARow > 0) then
      begin
        if sgZondbudTimes.Cells[ACol, ARow] <> '' then
        begin
          StrToInt(sgZondbudTimes.Cells[ACol, ARow]);
          PrevZoneBudTime := sgZondbudTimes.Cells[ACol, ARow];
        end;
      end;
    end;
  except on EConvertError do
    begin
      Beep;
      sgZondbudTimes.Cells[ACol, ARow] := PrevZoneBudTime;
    end;
  end;
end;

procedure TfrmMODFLOW.sgZondbudTimesExit(Sender: TObject);
var
  RowIndex: integer;
  StressPeriod, TimeStep: integer;
  OK: boolean;
  //  AMessage : string;
begin
  // triggering event sgZondbudTimes.OnExit
  inherited;

  // called by btnOKClick;

  // check that stress periods and time steps for Zonebudget specified
  // times are all valid.
  OK := True;
  if not cbZonebudget.Checked or (rgZonebudTimesChoice.ItemIndex = 0) then
  begin
    Exit;
  end;
  for RowIndex := 1 to sgZondbudTimes.RowCount - 1 do
  begin
    if sgZondbudTimes.Cells[1, RowIndex] = '' then
    begin
      if RowIndex = 1 then
      begin
        sgZondbudTimes.Cells[1, RowIndex] := '1';
      end;
    end
    else
    begin
      try
        begin
          StressPeriod := StrToInt(sgZondbudTimes.Cells[1, RowIndex]);
          if StressPeriod > dgTime.RowCount - 1 then
          begin
            OK := False
          end
          else
          begin
            if sgZondbudTimes.Cells[2, RowIndex] = '' then
            begin
              sgZondbudTimes.Cells[2, RowIndex] := '1';
            end;
            TimeStep := StrToInt(sgZondbudTimes.Cells[2, RowIndex]);
            if TimeStep > StrToInt(dgTime.Cells[Ord(tdNumSteps), StressPeriod])
              then
            begin
              OK := False;
            end;
          end;
        end;
      except on EConvertError do
        begin
          OK := False;
        end;
      end;
    end;
    if sgZondbudTimes.Cells[2, 1] = '' then
    begin
      sgZondbudTimes.Cells[2, 1] := '1';
    end
  end;
  if not OK then
  begin
    Beep;
    MessageDLG('You have entered invalid stress or time period data for the '
      + 'ZONEBUDGET Specified output times. The last stress period is '
      + IntToStr(dgTime.RowCount - 1)
      + '. The last timestep for the '
      + 'last stress period is '
      + dgTime.Cells[Ord(tdNumSteps), dgTime.RowCount - 1], mtError, [mbOK], 0);
    pageControlMain.ActivePage := tabZoneBudget;
    sgZondbudTimes.SetFocus;
    ModalResult := mrNone;
  end;
end;

procedure TfrmMODFLOW.sgMOC3DTransParamSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  // check that stress periods and time steps for Zonebudget specified
  // times are all real numbers.
  try
    begin
      if (ACol > 0) and (ARow > 0) then
      begin
        if sgMOC3DTransParam.Cells[ACol, ARow] <> '' then
        begin
          InternationalStrToFloat(sgMOC3DTransParam.Cells[ACol, ARow]);
          PrevMOC3DTransParam := sgMOC3DTransParam.Cells[ACol, ARow];
        end;
      end;
    end;
  except on EConvertError do
    begin
      sgMOC3DTransParam.Cells[ACol, ARow] := PrevMOC3DTransParam;
    end;

  end;

end;

procedure TfrmMODFLOW.sgMOC3DTransParamExit(Sender: TObject);
var
  RowIndex, ColIndex: integer;
begin
  // triggering events sgMOC3DTransParam.OnExit

  // check that no cells have invalid values. Convert Invalid values to '0'.
  inherited;
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
    begin
      try
        begin
          InternationalStrToFloat(sgMOC3DTransParam.Cells[ColIndex, RowIndex]);
        end;
      except on EConvertError do
        begin
          sgMOC3DTransParam.Cells[ColIndex, RowIndex] := '0';
        end;
      end;
    end;
  end;

end;

procedure TfrmMODFLOW.dgGeolExit(Sender: TObject);
var
  RowIndex, ColIndex: integer;
  ArithmeticAndLogarithmicUsed: boolean;
begin
  // triggering events dgGeol.OnExit
  inherited;
  TestHeadExport(Sender);
  // make sure the number of columns is correct.
  dgGeol.ColCount := Ord(High(NewUnitData)) + 1;
  // make sure that vertical discretizations are all integers
  for RowIndex := 1 to dgGeol.RowCount - 1 do
  begin
    try
      begin
        if (RowIndex > 1) then
        begin
          if (rgFlowPackage.ItemIndex = 0) and
            (dgGeol.Cells[Ord(nuiType), RowIndex] =
            dgGeol.Columns[Ord(nuiType)].Picklist[1]) then
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] :=
              dgGeol.Columns[Ord(nuiType)].Picklist[3];
          end;
        end;
        StrToInt(dgGeol.Cells[Ord(nuiVertDisc), RowIndex])
      end;
    except on EConvertError do
      begin
        dgGeol.Cells[Ord(nuiVertDisc), RowIndex] := '1';
      end;
    end;
  end;
  // Convert old data values to new form.
  for RowIndex := 1 to dgGeol.RowCount - 1 do
  begin
    if dgGeol.Cells[Ord(nuiType), RowIndex]
      = 'Convertible (3)' then
    begin
      dgGeol.Cells[Ord(nuiType), RowIndex] :=
        dgGeol.Columns[Ord(nuiType)].Picklist.Strings[3]
    end;
    for ColIndex := Ord(nuiSpecT) to Ord(nuiSpecAnis) do
    begin
      if dgGeol.Cells[ColIndex, RowIndex] = '' then
      begin
        dgGeol.Cells[ColIndex, RowIndex]
          := dgGeol.Columns[ColIndex].PickList.Strings[0];
      end;
    end;
    if dgGeol.Cells[Ord(nuiWettingActive), RowIndex] = '' then
    begin
      dgGeol.Cells[Ord(nuiWettingActive), RowIndex]
        :=
        dgGeol.Columns[Ord(nuiWettingActive)].PickList.Strings[comboWetCap.ItemIndex];
    end;
  end;

  // Set IAPART if needed.
  ArithmeticAndLogarithmicUsed := false;
  for RowIndex := 1 to dgGeol.RowCount - 1 do
  begin
    if rgFlowPackage.ItemIndex = 0 then
    begin
      if dgGeol.Cells[Ord(nuiTrans), RowIndex]
        = dgGeol.Columns[Ord(nuiTrans)].Picklist.Strings[3] then
      begin
        ArithmeticAndLogarithmicUsed := True;
        break;
      end;
    end
    else
    begin
      with dgGeol do
      begin
        if (Columns[Ord(nuiTrans)].Picklist.Count > 1)
        and (Cells[Ord(nuiTrans), RowIndex]
          = Columns[Ord(nuiTrans)].Picklist.Strings[2]) then
        begin
          ArithmeticAndLogarithmicUsed := True;
          break;
        end;
      end;
    end;
  end;

  // disable IAPART when appropriate
  comboIAPART.Enabled := not ArithmeticAndLogarithmicUsed;
  SetComboColor(comboIAPART);

  // set IAPART to the correct value when appropriate
  if not comboIAPART.Enabled then
  begin
    comboIAPART.ItemIndex := 1;
  end;
  SensitivityWarning;
end;

procedure TfrmMODFLOW.EnableVBAL;
begin
  cbVBAL.Enabled := cbMOC3D.Checked and (rgMOC3DSolver.ItemIndex in [3,4])
    and cbISRCFIX.Checked;
  if not Loading and not Cancelling then
  begin
    if not cbVBAL.Enabled then
    begin
      cbVBAL.Checked := False;
    end;
  end;
  cbVBALClick(nil);
end;

procedure TfrmMODFLOW.rgMOC3DSolverClick(Sender: TObject);
var
  MOCIMP_Used, ELLAM_Used, Particles_Used, Weights_Used: boolean;
  Index: integer;
begin
  inherited;

  // make the solver tab visible when appropriate
  if cbMOC3D.Checked then
  begin
    for Index := 0 to PageControlMOC3D.PageCount - 1 do
    begin
      PageControlMOC3D.Pages[Index].HandleNeeded;
    end;

    tabMOCIMP.TabVisible := (rgMOC3DSolver.ItemIndex in [1,2,4]);
    FreePageControlResources(PageControlMOC3D, Handle);
  end;
  cbMOC3DNoDisp.Enabled := (rgMOC3DSolver.ItemIndex in [1,2,4]) and cbMOC3D.Checked;
  if not cbMOC3DNoDisp.Enabled and not loading and not cancelling then
  begin
    cbMOC3DNoDisp.Checked := False;
  end;

  comboMOC3DPartFileType.Enabled := rgMOC3DSolver.ItemIndex <> 2;

  MOCIMP_Used := (rgMOC3DSolver.ItemIndex in [1,4]) and cbMOC3D.Checked;
  ELLAM_Used := (rgMOC3DSolver.ItemIndex = 2) and cbMOC3D.Checked;
  Particles_Used := (rgMOC3DSolver.ItemIndex <> 2) and cbMOC3D.Checked;
  Weights_Used := (rgMOC3DSolver.ItemIndex in [3,4]) and cbMOC3D.Checked;

  adeMOCWeightFactor.Enabled := MOCIMP_Used;
  adeMOCNumIter.Enabled := MOCIMP_Used;
  comboMOC3D_IDIREC.Enabled := MOCIMP_Used;
  adeMOCTolerance.Enabled := MOCIMP_Used;
  adeMOCMaxIter.Enabled := MOCIMP_Used;
  SetComboColor(comboMOC3D_IDIREC);

  adeEllamColumnExp.Enabled := ELLAM_Used;
  adeEllamRowExp.Enabled := ELLAM_Used;
  adeEllamLayerExp.Enabled := ELLAM_Used;
  adeEllamTimeExp.Enabled := ELLAM_Used;

  adeMOC3DMaxParticles.Enabled := Particles_Used;
{  edMOC3DInitParticles.Enabled := Particles_Used;
  if edMOC3DInitParticles.Enabled then
  begin
    edMOC3DInitParticles.Color := clWindow;
  end
  else
  begin
    edMOC3DInitParticles.Color := clBtnFace;
  end;     }
//  cbCustomParticle.Enabled := Particles_Used;
  adeMOC3DLimitActiveCells.Enabled := Particles_Used;
  comboMOC3DInterp.Enabled := Particles_Used;

  adeREMCRIT.Enabled := WeightedParticlesUsed;
  adeGENCRIT.Enabled := WeightedParticlesUsed;
  comboIRAND.Enabled := WeightedParticlesUsed;
  SetComboColor(comboIRAND);
  comboIRANDChange(nil);

  comboSpecifyParticles.Enabled := WeightedParticlesUsed;
  SetComboColor(comboSpecifyParticles);

  if not loading and not cancelling then
  begin
    adeMOC3DMaxFrac.CheckMax := (rgMOC3DSolver.ItemIndex <> 2);
  end;
  if ELLAM_Used and not loading and not cancelling then
  begin
    if cbDualPorosity.Checked or cbSimpleReactions.Checked then
    begin
      MessageDlg('The Age, Double Porosity, and Simple reactions packages '
        + 'can not be used with the ELLAM solver. They have been deactivated.',
        mtWarning, [mbOK], 0);
      cbDualPorosity.Checked := False;
      cbSimpleReactions.Checked := False;
    end;
  end;
  cbDualPorosity.Enabled := not ELLAM_Used;
  cbSimpleReactions.Enabled := not ELLAM_Used;
  
  // add or remove the particle regenerations layers depending on
  // whether MOC3D is selected and ELLAM isn't selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCParticleRegenLayerType, cbMOC3D.Checked
    and (rgMOC3DSolver.ItemIndex < 2));

  // add or remove the MOC3D particle regeneration parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCParticleRegenParamType, cbMOC3D.Checked
    and (rgMOC3DSolver.ItemIndex < 2));

  comboSpecifyParticlesChange(nil);

  cbParticleObservations.Enabled := Particles_Used;
  if not cbParticleObservations.Enabled and not Loading and not Cancelling then
  begin
    cbParticleObservations.Checked := False;
  end;
  cbISRCFIX.Enabled := Weights_Used;
  cbCustomParticleClick(nil);
  EnableMBRP_and_MBIT;
  EnableCCBD;
  EnableVBAL;
end;

procedure TfrmMODFLOW.btnSaveValClick(Sender: TObject);
var
  AStringList: TStringList;
  Path: string;
begin
  inherited;
  // save val file
  // first get the directory
  Path := DllAppDirectory(Self.handle, DLLName);
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
    Path := Path + '\modflow.val';
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
//  end;

end;

procedure TfrmMODFLOW.btnOpenValClick(Sender: TObject);
var
  AStringList, UnreadData: TStringList;
  Path: string;
  VersionInString: string;
  Developer: string;
begin
  inherited;
  // first get the directory
  Path := DllAppDirectory(Self.handle, DLLName);
  if not DirectoryExists(Path) then
  begin
    CreateDirectoryAndParents(Path);
  end;
//  if not GetDllDirectory(DLLName, Path) then
//  begin
//    // show an error message in the event of an error
//    Beep;
//    MessageDlg('Unable to find ' + DLLName, mtError, [mbOK], 0);
//  end
//  else
//  begin
    // set the default path name
    Path := Path + '\modflow.val';
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
          if Pos('@NPER@', AStringList.Text) <> 0 then
          begin
            BEEP;
            MessageDlg('This val file was created for a previous version of '
              + 'the MODFLOW PIE. It can not be read by the current '
              + 'version.', mtWarning, [mbOK], 0);
          end
          else
          begin
            // read the data from the file
            LoadModflowForm(UnreadData, AStringList.Text, VersionInString);

            // create lists of geologic units and parameters
            AssociateUnits;
            // Associate lists of time-related parameters with
            // dgTime grid.
            AssociateTimes;
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
//  end;

end;

procedure TfrmMODFLOW.LoadModflowForm(UnreadData: TStringlist;
  DataToRead: string; var VersionInString: string);
begin
  // called by btnOpenValClick
  // called by ReadValFile
  // called by GLoadForm in Project Functions
  // in cases where ArgusDataEntries check maximum values, temporarily
  // disable the checks.
  adeModpathBeginPeriod.CheckMax := False;
  adeModpathBeginStep.CheckMax := False;
  adeModpathEndPeriod.CheckMax := False;
  adeModpathEndStep.CheckMax := False;
  adeModpathEndStep.CheckMin := False;
  adeMOC3DMaxFrac.CheckMax := False;

  //  clipboard.AsText := DataToRead;
  LoadForm(UnreadData, DataToRead, VersionInString, lblVersion);

  {  // read the data that has to be read first
    StringToForm(DataToRead, UnreadData,
         lblVersion, VersionInString, False,
         FirstList, PIEDeveloper);

    // read all other data.
    StringToForm(DataToRead, UnreadData,
         lblVersion, VersionInString, True, nil,
         PIEDeveloper);  }

    // in cases where ArgusDataEntries check maximum values,
    // re-enable the checks.
  adeModpathBeginPeriod.CheckMax := True;
  adeModpathBeginStep.CheckMax := True;
  adeModpathEndPeriod.CheckMax := True;
  adeModpathEndStep.CheckMax := True;
  adeModpathEndStep.CheckMin := True;
  adeMOC3DMaxFrac.CheckMax := (rgMOC3DSolver.ItemIndex <> 2);

  // make sure that the grid titles are correct
  InitializeGrids;

  cbFlowClick(nil);
end;

procedure TfrmMODFLOW.ReadValFile(
  var VersionInString: string; Path: string);
var
  UnreadData: TStringlist;
  AStringList: TStringList;
  Developer: string;
begin
  try
    // called by GProjectNew
    AStringList := TStringList.Create;
    UnreadData := TStringList.Create;
    try
      begin
        AStringList.LoadFromFile(Path);

        LoadModflowForm(UnreadData, AStringList.Text, VersionInString);

        MFLayerStructure.FreeByStatus(sDeleted);
        MFLayerStructure.SetStatus(sNormal);
        MFLayerStructure.UpdateIndicies;
        MFLayerStructure.UpdateOldIndicies;

        AssociateUnits;
        AssociateTimes;
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
  except on E: Exception do
    begin
      MessageDlg(E.message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.UpdateMOC3DSubgrid;
var
  GridLayerHandle: ANE_PTR;
  NRow, NCol: ANE_INT32;
  MinX, MaxX, MinY, MaxY, GridAngle: ANE_DOUBLE;
  LayerHandle: ANE_PTR;
  AContourList: TContourList;
  AContour: TContour;
  APoint: TZoomPoint;
  X, Y: double;
  AString: string;
  ANE_String: ANE_STR;
  LayerName: string;
  procedure StartContour;
  begin
    AContour := TContour.Create(AContourList);
    AContourList.Add(AContour);
    AContour.Heading.Add('## Name:');
    AContour.Heading.Add('## Icon:0');
    AContour.Heading.Add('# Points Count' + Chr(9) + 'Value');
    AContour.Heading.Add('1');
    APoint := TZoomPoint.Create(AContourList, AContour);
  end;
  procedure FinishContour;
  begin
    RotatePointsFromGrid(X, Y, GridAngle);
    APoint.X := X;
    APoint.Y := Y;
    AContour.Add(APoint);
  end;
begin
  // create a new MOC3D Transport Subgrid layer and put some contours on it

  // called by EditForm

  // get the grid dimensions, grid layer handle, etc
  GetGrid(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
    GridLayerHandle, NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);

  // create a string list to hold contours for the transport subgrid layer.
  AContourList := TContourList.Create;
  try
    // create a contour
    // add header lines to contour
    // create a vertex on the contour
    StartContour;
    // get the x coordinate of the vertex in the first contour
    if MinX < MaxX then
    begin
      X := MinX + LeftMOC3DSubGridDistance;
    end
    else
    begin
      X := MinX - LeftMOC3DSubGridDistance;
    end;
    // get the y coordinate of the vertex in the first contour
    if MinY < MaxY then
    begin
      Y := MinY + BottomMOC3DSubGridDistance;
    end
    else
    begin
      Y := MinY - BottomMOC3DSubGridDistance;
    end;

    // set the X and Y values of the point and add it to the contour.
    FinishContour;

    // create a contour
    // add header lines to contour
    // create a vertex on the contour
    StartContour;
    // get the x coordinate of the vertex in the second contour
    if MinX < MaxX then
    begin
      X := MaxX - RightMOC3DSubGridDistance;
    end
    else
    begin
      X := MaxX + RightMOC3DSubGridDistance;
    end;
    // get the y coordinate of the vertex in the second contour
    if MinY < MaxY then
    begin
      Y := MaxY - TopMOC3DSubGridDistance;
    end
    else
    begin
      Y := MaxY + TopMOC3DSubGridDistance;
    end;
    // set the X and Y values of the point and add it to the contour.
    FinishContour;

    // write the contour information to a string;
    AString := AContourList.WriteContours;

    // get the handle of the MOC3D Transport Subgrid layer
    LayerName := ModflowTypes.GetMOCTransSubGridLayerType.WriteNewRoot;
    LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);

    // put the contour information on that layer.
    GetMem(ANE_String, Length(AString) + 1);
    try
      StrPCopy(ANE_String, AString);
      ANE_ImportTextToLayerByHandle(CurrentModelHandle,
        LayerHandle, ANE_String);
      ANE_ProcessEvents(CurrentModelHandle);
    finally
      FreeMem(ANE_String);
    end;
  finally
    // get rid of AContourList
    AContourList.Free;
  end;

end;

procedure TfrmMODFLOW.cbSpecifyFlowFilesClick(Sender: TObject);
begin
  inherited;
  // make the tab with the check boxes for saving individual flows
  // visible or not as appropriate.
  tabOutputCtrl.TabVisible := cbSpecifyFlowFiles.Checked;
  // if it isn't visible, then save all flows
  if not tabOutputCtrl.TabVisible then
  begin
    cbFlowBCF.Checked := True;
    cbFlowLPF.Checked := True;
    cbFlowHUF.Checked := True;
    cbFlowRCH.Checked := True;
    cbFlowDrn.Checked := True;
    cbFlowGHB.Checked := True;
    cbFlowRiv.Checked := True;
    cbFlowWel.Checked := True;
    cbFlowEVT.Checked := True;
    cbFlowFHB.Checked := True;
    if cbStrPrintFlows.Checked then
    begin
      cbFlowSTR.Checked := False;
    end
    else
    begin
      cbFlowSTR.Checked := True;
    end;
    cbFlowSTR2.Checked := True;
    if cbSfrPrintFlows.Checked then
    begin
      cbFlowSFR.Checked := False;
    end
    else
    begin
      cbFlowSFR.Checked := True;
    end;
    cbFlowSFR2.Checked := True;
    cbFlowLak.Checked := True;
    cbFlowIBS.Checked := True;
    cbFlowRES.Checked := True;
    cbFlowTLK.Checked := True;
    cbFlowETS.Checked := True;
    cbFlowDrt.Checked := True;
    cbFlowHUF.Checked := True;
    cbFlowDaflow.Checked := True;
    if cbMNW_PrintFlows.Checked then
    begin
      cbFlowMNW.Checked := False;
    end
    else
    begin
      cbFlowMNW.Checked := True
    end;
    
  end;
end;

procedure TfrmMODFLOW.ReadCTOCH(var LineIndex: integer; FirstList, IgnoreList:
  TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);

var
  AText: string;
begin
  // read CTOCH from an old file.
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  cbCHTOCH.Checked := (Pos('CHTOCH', AText) > 0);
end;

function TfrmMODFLOW.MOC3DLayerCount: integer;
var
  UnitIndex: integer;
  StartUnit, EndUnit: integer;
begin
  // This function returns the number of MOC3D layers in a model.

  // Initialize result
  result := 0;

  // initialize starting and ending positions of loop
  StartUnit := StrToInt(adeMOC3DLay1.Text);
  EndUnit := StrToInt(adeMOC3DLay2.Text);
  if EndUnit < 0 then
  begin
    EndUnit := dgGeol.RowCount - 1
  end;

  // loop over geologic units
  for UnitIndex := StartUnit to EndUnit do
  begin
    // if a geologic unit is simulated, add the vertical discretization of
    // that unit to the total.
    if dgGeol.Cells[Ord(nuiSim), UnitIndex]
      = 'Yes' then
    begin
      result := result + StrToInt(dgGeol.Cells
        [Ord(nuiVertDisc), UnitIndex]);
    end;
  end;
end;

procedure TfrmMODFLOW.cbStrPrintFlowsClick(Sender: TObject);
begin
  inherited;
  // The stream package doesn't allow you to both print and save
  // flows simultaneously so act accordingly
  cbFlowSTR.Checked := not cbStrPrintFlows.Checked;
  cbFlowClick(Sender);
  if not cbFlowSTR.Checked and cbSTR.Checked then
  begin
    if not Loading and not Cancelling then
    begin
      cbSpecifyFlowFiles.Checked := True;
      cbSpecifyFlowFilesClick(Sender);
    end;
  end;
end;

procedure TfrmMODFLOW.comboISTRTChange(Sender: TObject);
begin
  inherited;
  // if initial heads aren't saved, you can't compute drawdown.
{  comboDrawdownPrintFreq.Enabled := not (comboExportDrawdown.ItemIndex = 0)
    and (comboISTRT.ItemIndex = 1);

  SetComboColor(comboDrawdownPrintFreq);  }

  comboDrawdownPrintFreqChange(Sender);

  comboDrawdownExportFreq.Enabled := not (comboExportDrawdown.ItemIndex = 0)
    and (comboISTRT.ItemIndex = 1);

  SetComboColor(comboDrawdownExportFreq);
  frameDrawdownFormat.Enabled := comboDrawdownExportFreq.Enabled
    and (comboExportDrawdown.ItemIndex = 1);
  if not comboDrawdownExportFreq.Enabled and not loading and not cancelling then
  begin
    comboDrawdownExportFreq.ItemIndex := 0;
  end;

  comboDrawdownPrintFreq.Enabled := (comboISTRT.ItemIndex = 1);
  SetComboColor(comboDrawdownPrintFreq);
  if not comboDrawdownPrintFreq.Enabled and not loading and not cancelling then
  begin
    comboDrawdownPrintFreq.ItemIndex := 0;
  end;

  comboDrawdownPrintFreqChange(Sender);
  comboDrawdownExportFreqChange(Sender);

end;

procedure TfrmMODFLOW.cbMOC3DNoDispClick(Sender: TObject);
begin
  inherited;
  // redraw sgMOC3DTransParam
  sgMOC3DTransParam.Invalidate;
end;

procedure TfrmMODFLOW.comboExportDrawdownChange(Sender: TObject);
begin
  inherited;
  // you must save initial heads if your are going to compute drawdowns
  if comboExportDrawdown.ItemIndex > 0 then
  begin
    comboISTRT.ItemIndex := 1;
    comboISTRTChange(Sender);
  end;

  comboDrawdownExportFreq.Enabled := not (comboExportDrawdown.ItemIndex = 0)
    and (comboISTRT.ItemIndex = 1);
  SetComboColor(comboDrawdownExportFreq);
  frameDrawdownFormat.Enabled := comboDrawdownExportFreq.Enabled
    and (comboExportDrawdown.ItemIndex = 1);

  if not comboDrawdownExportFreq.Enabled and not loading and not cancelling then
  begin
    comboDrawdownExportFreq.ItemIndex := 0;
  end;

  comboDrawdownPrintFreq.Enabled := (comboISTRT.ItemIndex = 1);
  SetComboColor(comboDrawdownPrintFreq);
  if not comboDrawdownPrintFreq.Enabled and not loading and not cancelling then
  begin
    comboDrawdownPrintFreq.ItemIndex := 0;
  end;

  comboDrawdownPrintFreqChange(Sender);
  comboDrawdownExportFreqChange(Sender);

end;

procedure TfrmMODFLOW.cbMPathBudgetClick(Sender: TObject);
begin
  inherited;
  // if you are going to compute the budget, you must specify a tolerance
  adeMPathErrorTolerance.Enabled := cbMPathBudget.Checked;
end;

function TfrmMODFLOW.SetColumns(AStringGrid: TStringGrid): boolean;
begin
  result := inherited SetColumns(AStringGrid);
  // if the stringgrid is dgGeol or dgParamEstCovNames then
  // you should not set the number
  // of columns when reading an old data file.
  if (AStringGrid = dgGeol) or (AStringGrid = dgParamEstCovNames)
    or (AStringGrid = dgIBS) or (AStringGrid = dgSensitivity)
    or (AStringGrid = dgTime) then
  begin
    result := False;
  end;
end;

procedure TfrmMODFLOW.dgGeolDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  CanSelect: Boolean;
begin
  inherited;
  if (ARow > 0) and (ACol > 0) then
  begin
    //   dgGeol.Canvas.Brush.Color := clWindow;
    CanSelect := True;
    dgGeolSelectCell(nil, ACol, ARow, CanSelect);
    if not CanSelect then
    begin
      dgGeol.Canvas.Brush.Color := clBtnFace;
    end
    else if (ARow = GeologyRow) then
    begin
      dgGeol.Canvas.Brush.Color := clAqua;
    end
    else
    begin
      dgGeol.Canvas.Brush.Color := clWindow;
    end;
    // set the font color
    dgGeol.Canvas.Font.Color := clBlack;
    // draw the text
    dgGeol.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, dgGeol.Cells[ACol,
      ARow]);
    // draw the right and lower cell boundaries in black.
    dgGeol.Canvas.Pen.Color := clBlack;
    dgGeol.Canvas.MoveTo(Rect.Right, Rect.Top);
    dgGeol.Canvas.LineTo(Rect.Right, Rect.Bottom);
    dgGeol.Canvas.LineTo(Rect.Left, Rect.Bottom);
  end;
end;

procedure TfrmMODFLOW.StreamWarning;
begin
  // warn about incompatibilities between the stream package and MOC3D
  if not Loading and not cancelling then
  begin
    if cbMOC3D.Checked and cbSTR.Checked and rbModflow96.Checked then
    begin
      Beep;
      MessageDlg('Warning: MOC3D and the current version of the '
        + 'Stream Package are incompatible in MODFLOW-96.', mtWarning, [mbOK],
        0);
    end;
    if cbMOC3D.Checked and cbIBS.Checked then
    begin
      Beep;
      if rbMODFLOW2000.Checked or rbModflow2005.Checked then
      begin
        MessageDlg('Warning: MF2K-GWT and the current version of the '
          + 'Interbed Storage Package are incompatible.', mtWarning, [mbOK], 0);
      end
      else
      begin
        MessageDlg('Warning: MOC3D and the current version of the '
          + 'Interbed Storage Package are incompatible.', mtWarning, [mbOK], 0);
      end;

    end;
    if cbMOC3D.Checked and cbTLK.Checked then
    begin
      Beep;
      if rbMODFLOW2000.Checked or rbModflow2005.Checked then
      begin
        MessageDlg('Warning: MF2K-GWT and the current version of the '
          + 'Transient Leakage Package are incompatible.', mtWarning, [mbOK],
          0);
      end
      else
      begin
        MessageDlg('Warning: MOC3D and the current version of the '
          + 'Transient Leakage Package are incompatible.', mtWarning, [mbOK],
          0);
      end;
    end;
  end
end;

procedure TfrmMODFLOW.rgMnw2WellTypeClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.rgMOC3DConcFormatClick(Sender: TObject);
begin
  inherited;
  // warn about problems with post processing of binary files.
  if not Loading and not Cancelling and (rgMOC3DConcFormat.ItemIndex = 1) then
  begin
    Beep;
    MessageDlg('The MODFLOW GUI can not currently use this format '
      + 'for post-processing.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.comboCustomizeChange(Sender: TObject);
begin
  inherited;

  cbActiveBoundary.Enabled := comboCustomize.ItemIndex > 0;

  // set expressions for initial head and ibound parameters
  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridInitialHeadParamType,
    ModflowTypes.GetMFGridInitialHeadParamType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFIBoundGridParamType,
    ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.cbActiveBoundaryClick(Sender: TObject);
begin
  inherited;
  // set expression for IBOUND parameter
  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFIBoundGridParamType,
    ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.EnableAreaRiverContour;
begin
  cbAreaRiverContour.Enabled := not cbAltRiv.Checked and cbRIV.Checked
    and cbUseAreaRivers.Checked;
  if cbAltRiv.Enabled and cbAltRiv.Checked and not Loading
    and not Cancelling then
  begin
    cbAreaRiverContour.Checked := False;
  end;
end;

procedure TfrmMODFLOW.cbAltRivClick(Sender: TObject);
begin
  inherited;
  EnableAreaRiverContour;
  if cbAreaRiverContour.Enabled and not Loading and not Cancelling then
  begin
    cbAreaRiverContour.Checked := True;
  end;

  // set expression for river locations
  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRiverParamType,
    ModflowTypes.GetMFGridRiverParamType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.EnableAreaDrainContour;
begin
  cbAreaDrainContour.Enabled := not cbAltDrn.Checked and cbDRN.Checked
    and cbUseAreaDrains.Checked;
  if cbAltDrn.Enabled and cbAltDrn.Checked and not Loading
    and not Cancelling then
  begin
    cbAreaDrainContour.Checked := False;
  end;
end;

procedure TfrmMODFLOW.cbAltDrnClick(Sender: TObject);
begin
  inherited;
  EnableAreaDrainContour;
  if cbAreaDrainContour.Enabled and not Loading and not Cancelling then
  begin
    cbAreaDrainContour.Checked := True;
  end;
  // set expression for drain locations
  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridDrainParamType,
    ModflowTypes.GetMFGridDrainParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.cbRechLayerClick(Sender: TObject);
begin
  inherited;
  // add or remove layer and parameter used to explicitly set the recharge layer
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetRechargeLayerType,
    ModflowTypes.GetMFModflowLayerParamType,
    cbRechLayer.Checked and cbRCH.Checked and (comboRchOpt.ItemIndex = 1));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridRechLayerParamType,
    cbRechLayer.Checked and cbRCH.Checked and (comboRchOpt.ItemIndex = 1));
  if cbRechLayer.Checked then
  begin
    SpecifyLayerWarning
  end;

end;

procedure TfrmMODFLOW.comboRchOptChange(Sender: TObject);
begin
  inherited;
  // change the locked values of the recharge elevation parameter.

  cbRechLayer.Enabled := cbRCH.Checked and (comboRchOpt.ItemIndex = 1);
  cbRechLayerClick(Sender);
end;

procedure TfrmMODFLOW.cbETLayerClick(Sender: TObject);
begin
  inherited;
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMFModflowLayerParamType,
    cbETLayer.Checked and cbEVT.Checked and (comboEvtOption.ItemIndex = 1));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridETLayerParamType,
    cbETLayer.Checked and cbEVT.Checked and (comboEvtOption.ItemIndex = 1));

  if cbETLayer.Checked then
  begin
    SpecifyLayerWarning
  end;
end;

procedure TfrmMODFLOW.comboEvtOptionChange(Sender: TObject);
begin
  inherited;
  cbETLayer.Enabled := cbEVT.Checked and (comboEvtOption.ItemIndex = 1);
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  cbETLayerClick(Sender);

end;

procedure TfrmMODFLOW.Moc3dWetWarning;
begin
  // warn about rewetting option and MOC3D
  if cbMOC3D.Checked and (comboWetCap.ItemIndex = 1) and not Loading then
  begin
    Beep;
    if rbMODFLOW2000.Checked or rbModflow2005.Checked then
    begin
      MessageDlg('Warning: The current version of MF2K-GWT and the  '
        + 'Rewetting option are incompatible.', mtWarning, [mbOK], 0);
    end
    else
    begin
      MessageDlg('Warning: The current version of MOC3D and the  '
        + 'Rewetting option are incompatible.', mtWarning, [mbOK], 0);
    end;
  end
end;

procedure TfrmMODFLOW.Moc3dTimeWarning;
begin
  // warn about time units and MOC3D
  if cbMOC3D.Checked and (comboTimeUnits.ItemIndex = 0) and not Loading then
  begin
    Beep;
    if rbMODFLOW2000.Checked or rbModflow2005.Checked then
    begin
      MessageDlg('Warning: You must specify time units with MF2K-GWT.',
        mtWarning, [mbOK], 0);
    end
    else
    begin
      MessageDlg('Warning: You must specify time units with MOC3D.',
        mtWarning, [mbOK], 0);
    end;
  end
end;

procedure TfrmMODFLOW.comboTimeUnitsChange(Sender: TObject);
begin
  inherited;
  // warn about time units and MOC3D
  Moc3dTimeWarning;
  case comboTimeUnits.ItemIndex of
    0:
      begin
        TimeUnit := 'T';
      end;
    1:
      begin
        TimeUnit := 's';
      end;
    2:
      begin
        TimeUnit := 'min';
      end;
    3:
      begin
        TimeUnit := 'hr';
      end;
    4:
      begin
        TimeUnit := 'd';
      end;
    5:
      begin
        TimeUnit := 'yr';
      end;
  else
    begin
      TimeUnit := 'T';
    end;
  end;
  SetUnits;
  MFLayerStructure.SetAllParamUnits;
  if not Loading and not Cancelling and
    cbStreamCalcFlow.Checked and (comboTimeUnits.ItemIndex = 0) then
  begin
    ShowMessage('You must specify a time unit if stream stage will be calculated.');
  end;

end;

procedure TfrmMODFLOW.ModelComponentName(AStringList: TStringList);
begin
  AStringList.Add(adeModflow2000Path.Name);
  AStringList.Add(adeMODFLOWPath.Name);
  AStringList.Add(adeMOC3DPath.Name);
  AStringList.Add(adeMF2K_GWTPath.Name);
  AStringList.Add(adeZonebudgetPath.Name);
  AStringList.Add(adeMODPATHPath.Name);
  AStringList.Add(adeResanPath.Name);
  AStringList.Add(adeYcintPath.Name);
  AStringList.Add(adeBealePath.Name);
  AStringList.Add(adeMT3DPath.Name);
  AStringList.Add(edCheckDate.Name);
  AStringList.Add(rgUpdateFrequency.Name);
  AStringList.Add(adeMODPATH41Path.Name);
  AStringList.Add(adeSEAWAT.Name);
  AStringList.Add(adeGWM.Name);
  AStringList.Add(adeModflow2005.Name);
end;

procedure TfrmMODFLOW.SetComboColor(ACombo: TComboBox);
begin
  // set the color of controls when they change from enabled to disabled
  // or back.
  if ACombo.Enabled then
  begin
    ACombo.Color := clWindow;
  end
  else
  begin
    ACombo.Color := clBtnFace;
  end;
end;

procedure TfrmMODFLOW.cbAgeClick(Sender: TObject);
begin
  inherited;
  // allow the user to set the age if the MOC3D Age package is used.
  adeAge.Enabled := cbAge.Checked;
end;

procedure TfrmMODFLOW.cbDualPorosityClick(Sender: TObject);
begin
  inherited;
  // enable or disable controls related to the MOC3D Double Porosity package.
  cbUseDualPorosity.Enabled := cbDualPorosity.Checked;
  cbIDPFO.Enabled := cbDualPorosity.Checked;
  cbIDPZO.Enabled := cbDualPorosity.Checked;
  cbIDPTIM_LinExch.Enabled := cbDualPorosity.Checked;
  comboDualPOutOption.Enabled := cbDualPorosity.Checked;
  SetComboColor(comboDualPOutOption);
  cbIDPTIM_Decay.Enabled := cbDualPorosity.Checked and cbIDPFO.Checked;
  cbIDPTIM_Growth.Enabled := cbDualPorosity.Checked and cbIDPZO.Checked;

  // add or remove layers related to the MOC3D Double Porosity package.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCImInitConcLayerType,
    (cbMOC3D.Checked and cbDualPorosity.Checked)
    or (cbMT3D.Checked and cbRCT.Checked and cbMT3D_StartingConcentration.Checked
    and not cbMT3D_OneDArrays.Checked
    and (comboMT3DIsotherm.ItemIndex >= 4)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCImPorosityLayerType,
    (cbMOC3D.Checked and cbDualPorosity.Checked)
    or (cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex >= 5)
    and not cbMT3D_OneDArrays.Checked));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCLinExchCoefLayerType,
    cbMOC3D.Checked and cbDualPorosity.Checked);

  // add or remove parameters related to the Double Porosity package
  cbIDPTIM_DecayClick(Sender);
  cbIDPTIM_GrowthClick(Sender);
  cbIDPTIM_LinExchClick(Sender);

end;

procedure TfrmMODFLOW.cbSimpleReactionsClick(Sender: TObject);
begin
  inherited;
  // enable or disable controls related to the Simple reactions package
  cbUseSimpleReactions.Enabled := cbSimpleReactions.Checked;
  cbIDKRF.Enabled := cbSimpleReactions.Checked;
  cbIDKFO.Enabled := cbSimpleReactions.Checked;
  cbIDKFS.Enabled := cbSimpleReactions.Checked;
  cbIDKZO.Enabled := cbSimpleReactions.Checked;
  cbIDKZS.Enabled := cbSimpleReactions.Checked;

  cbIDKTIM_DisDecay.Enabled := cbSimpleReactions.Checked and cbIDKFO.Checked;
  cbIDKTIM_SorbDecay.Enabled := cbSimpleReactions.Checked and cbIDKFS.Checked;
  cbIDKTIM_DisGrowth.Enabled := cbSimpleReactions.Checked and cbIDKZO.Checked;
  cbIDKTIM_SorbGrowth.Enabled := cbSimpleReactions.Checked and cbIDKZS.Checked;

  cbIDKRFClick(Sender);

  //  cbIDKTIMClick(Sender);
  cbIDKTIM_DisDecayClick(Sender);
  cbIDKTIM_SorbDecayClick(Sender);
  cbIDKTIM_DisGrowthClick(Sender);
  cbIDKTIM_SorbGrowthClick(Sender);
end;

procedure TfrmMODFLOW.cbIDPFOClick(Sender: TObject);
begin
  inherited;
  cbIDPTIM_Decay.Enabled := cbDualPorosity.Checked and cbIDPFO.Checked;

  // add or remove layers related to the Double porosity package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCDecayCoefLayerType,
    cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPFO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDPZOClick(Sender: TObject);
begin
  inherited;
  cbIDPTIM_Growth.Enabled := cbDualPorosity.Checked and cbIDPZO.Checked;

  // add or remove layers related to the Double porosity package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCGrowthLayerType,
    cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPZO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKRFClick(Sender: TObject);
begin
  inherited;
  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCRetardationLayerType,
    cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKRF.Checked);

end;

procedure TfrmMODFLOW.cbIDKFOClick(Sender: TObject);
begin
  inherited;
  cbIDKTIM_DisDecay.Enabled := cbSimpleReactions.Checked and cbIDKFO.Checked;

  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
    cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKFO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKFSClick(Sender: TObject);
begin
  inherited;
  cbIDKTIM_SorbDecay.Enabled := cbSimpleReactions.Checked and cbIDKFS.Checked;

  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
    cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKFS.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKZOClick(Sender: TObject);
begin
  inherited;
  cbIDKTIM_DisGrowth.Enabled := cbSimpleReactions.Checked and cbIDKZO.Checked;

  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
    cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKZO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKZSClick(Sender: TObject);
begin
  inherited;
  cbIDKTIM_SorbGrowth.Enabled := cbSimpleReactions.Checked and cbIDKZS.Checked;

  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
    cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKZS.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDPTIM_DecayClick(Sender: TObject);
begin
  inherited;

  // enable or disable controls related to the MOC3D Double Porosity package.
  cbIDPFOClick(Sender);
  cbIDPZOClick(Sender);

  if cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPFO.Checked then
  begin
    if cbIDPTIM_Decay.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCDecayCoefParamType,
        ModflowTypes.GetMFMOCDecayCoefLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCDecayCoefParamType,
        ModflowTypes.GetMFMOCDecayCoefLayerType);
    end;
  end;
  // add or remove parameters related to the Double Porosity package

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDecayCoefLayerType,
    ModflowTypes.GetMFMOCDecayCoefParamType,
    cbMOC3D.Checked and cbDualPorosity.Checked
    and cbIDPTIM_Decay.Checked and cbIDPFO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDPTIM_GrowthClick(Sender: TObject);
begin
  inherited;

  // enable or disable controls related to the MOC3D Double Porosity package.
  cbIDPFOClick(Sender);
  cbIDPZOClick(Sender);

  if cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPZO.Checked then
  begin
    if cbIDPTIM_Growth.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCGrowthParamType,
        ModflowTypes.GetMFMOCGrowthLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCGrowthParamType,
        ModflowTypes.GetMFMOCGrowthLayerType);
    end;
  end;

  // add or remove parameters related to the Double Porosity package

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCGrowthLayerType,
    ModflowTypes.GetMFMOCGrowthParamType,
    cbMOC3D.Checked and cbDualPorosity.Checked
    and cbIDPTIM_Growth.Checked and cbIDPZO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKTIM_DisDecayClick(Sender: TObject);
begin
  inherited;

  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  if cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKFO.Checked then
  begin
    if cbIDKTIM_DisDecay.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCDisDecayCoefParamType,
        ModflowTypes.GetMFMOCDisDecayCoefLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCDisDecayCoefParamType,
        ModflowTypes.GetMFMOCDisDecayCoefLayerType);
    end;
  end;

  // add or remove parameters related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
    ModflowTypes.GetMFMOCDisDecayCoefParamType,
    cbMOC3D.Checked and cbSimpleReactions.Checked
    and cbIDKTIM_DisDecay.Checked and cbIDKFO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKTIM_SorbDecayClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  if cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKFS.Checked then
  begin
    if cbIDKTIM_SorbDecay.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCSorbDecayCoefParamType,
        ModflowTypes.GetMFMOCSorbDecayCoefLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCSorbDecayCoefParamType,
        ModflowTypes.GetMFMOCSorbDecayCoefLayerType);
    end;
  end;

  // add or remove parameters related to the simple reactions package

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
    ModflowTypes.GetMFMOCSorbDecayCoefParamType,
    cbMOC3D.Checked and cbSimpleReactions.Checked
    and cbIDKTIM_SorbDecay.Checked and cbIDKFS.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKTIM_DisGrowthClick(Sender: TObject);
begin
  inherited;

  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  if cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKZO.Checked then
  begin
    if cbIDKTIM_DisGrowth.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCDisGrowthParamType,
        ModflowTypes.GetMFMOCDisGrowthLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCDisGrowthParamType,
        ModflowTypes.GetMFMOCDisGrowthLayerType);
    end;
  end;

  // add or remove parameters related to the simple reactions package

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
    ModflowTypes.GetMFMOCDisGrowthParamType,
    cbMOC3D.Checked and cbSimpleReactions.Checked
    and cbIDKTIM_DisGrowth.Checked and cbIDKZO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKTIM_SorbGrowthClick(Sender: TObject);
begin
  inherited;

  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  if cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKZS.Checked then
  begin
    if cbIDKTIM_SorbGrowth.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCSorbGrowthParamType,
        ModflowTypes.GetMFMOCSorbGrowthLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCSorbGrowthParamType,
        ModflowTypes.GetMFMOCSorbGrowthLayerType);
    end;
  end;

  // add or remove parameters related to the simple reactions package

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
    ModflowTypes.GetMFMOCSorbGrowthParamType,
    cbMOC3D.Checked and cbSimpleReactions.Checked
    and cbIDKTIM_SorbGrowth.Checked and cbIDKZS.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.InitialHeadsWarning;
begin
  if cbInitial.Checked and (edInitial.Text = '') then
  begin
    MessageDlg('You will need to specify the name of the initial heads file '
      + 'before running this model.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.btnInitialSelectClick(Sender: TObject);
var
  rootName: string;
  DotPosition: integer;
  OldFilter: string;
begin
  inherited;
  OldFilter := OpenDialog1.Filter;
  try
    OpenDialog1.InitialDir := GetCurrentDir;
    OpenDialog1.Filter :=
      'Binary Head files  (*.bhd)|*.bhd|All Files (*.*)|*.*';
    if OpenDialog1.Execute then
    begin
      rootName := ExtractFileName(OpenDialog1.FileName);
      edInitial.Text := rootName;
      DotPosition := Pos('.', rootName);
      if DotPosition > 0 then
      begin
        rootName := Copy(rootName, 1, DotPosition - 1);
      end;
      if LowerCase(rootName) = LowerCase(adeFileName.Text) then
      begin
        Beep;
        MessageDlg('Error: The rootname for MODFLOW simulation files (' +
          adeFileName.Text + ') has the same root as the file you have choosen ('
          + edInitial.Text +
          '). You should correct this before running MODFLOW.',
          mtError, [mbOK], 0);
      end;
    end;
  finally
    OpenDialog1.Filter := OldFilter;
  end;
end;

procedure TfrmMODFLOW.cbInitialClick(Sender: TObject);
begin
  inherited;
  if cbInitial.Checked and not Loading and (edInitial.Text = '') then
  begin
    btnInitialSelectClick(Sender);
  end;
  btnInitialSelect.Enabled := cbInitial.Checked;
  edInitial.Enabled := cbInitial.Checked;
  if edInitial.Enabled then
  begin
    edInitial.Color := clWindow;
  end
  else
  begin
    edInitial.Color := clBtnFace;
  end;
  comboBinaryInitialHeadChoice.Enabled := cbInitial.Checked
    and (rbMODFLOW2000.Checked or rbMODFLOW2005.Checked);
  SetComboColor(comboBinaryInitialHeadChoice);
  EnableBinaryStressPeriodAndTimeStep;
end;

procedure TfrmMODFLOW.cbISRCFIXClick(Sender: TObject);
begin
  inherited;
  EnableVBAL;
end;

procedure TfrmMODFLOW.cbKinematicRoutingClick(Sender: TObject);
begin
  inherited;
  adeSfrKinematicTimeSteps.Enabled := cbSFR.Checked
    and cbKinematicRouting.Checked;
  adeSfrTimeWeightingFactor.Enabled := cbSFR.Checked
    and cbKinematicRouting.Checked;
  adeSfrToleranceForConvergence.Enabled := cbSFR.Checked
    and cbKinematicRouting.Checked;
end;

procedure TfrmMODFLOW.cbIDPTIM_LinExchClick(Sender: TObject);
begin
  inherited;
  // enable or disable controls related to the MOC3D Double Porosity package.
  cbIDPFOClick(Sender);
  cbIDPZOClick(Sender);

  if cbMOC3D.Checked and cbDualPorosity.Checked then
  begin
    if cbIDPTIM_LinExch.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFMOCLinExchCoefParamType,
        ModflowTypes.GetMFMOCLinExchCoefLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFMOCLinExchCoefParamType,
        ModflowTypes.GetMFMOCLinExchCoefLayerType);
    end;
  end;

  // add or remove parameters related to the Double Porosity package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCLinExchCoefLayerType,
    ModflowTypes.GetMFMOCLinExchCoefParamType,
    cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPTIM_LinExch.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.InitializeMultParamPickLists(A3DDataGrid: TRBWDataGrid3d);
var
  RowIndex: integer;
  ADataGrid: TDataGrid;
  GridIndex: integer;
begin
  if A3DDataGrid.PageCount > 0 then
  begin
    OldMultiplierNames.Clear;
    OldMultiplierNames.Add('NONE');
    for RowIndex := 1 to dgMultiplier.RowCount - 1 do
    begin
      OldMultiplierNames.Add(dgMultiplier.Cells[1, RowIndex]);
    end;
    for GridIndex := 0 to A3DDataGrid.PageCount - 1 do
    begin
      ADataGrid := A3DDataGrid.Grids[GridIndex];
      ADataGrid.Columns[1].PickList := OldMultiplierNames;
      for RowIndex := 1 to ADataGrid.RowCount - 1 do
      begin
        if OldMultiplierNames.IndexOf(ADataGrid.Cells[1, RowIndex]) = -1 then
        begin
          if OldMultiplierNames.Count > 0 then
          begin
            ADataGrid.Cells[1, RowIndex] := OldMultiplierNames[0];
          end
          else
          begin
            ADataGrid.Cells[1, RowIndex] := '';
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.InitializeZoneParamPickLists(A3DDataGrid: TRBWDataGrid3d);
var
  RowIndex: integer;
  ADataGrid: TDataGrid;
  GridIndex: integer;
begin
  if A3DDataGrid.PageCount > 0 then
  begin
    OldZoneNames.Clear;
    OldZoneNames.Add('ALL');
    for RowIndex := 1 to sgZoneArrays.RowCount - 1 do
    begin
      OldZoneNames.Add(sgZoneArrays.Cells[1, RowIndex]);
    end;
    for GridIndex := 0 to A3DDataGrid.PageCount - 1 do
    begin
      ADataGrid := A3DDataGrid.Grids[GridIndex];
      ADataGrid.Columns[2].PickList := OldZoneNames;
      for RowIndex := 1 to ADataGrid.RowCount - 1 do
      begin
        if OldZoneNames.IndexOf(ADataGrid.Cells[2, RowIndex]) = -1 then
        begin
          if OldZoneNames.Count > 0 then
          begin
            ADataGrid.Cells[2, RowIndex] := OldZoneNames[0];
          end
          else
          begin
            ADataGrid.Cells[2, RowIndex] := '';
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.InitializeParamPage(ADataGrid: TDataGrid);
var
  Index: integer;
begin

  for Index := 1 to ADataGrid.RowCount - 1 do
  begin
    if ADataGrid.Cells[0, Index] = '' then
    begin
      if ADataGrid.Columns[0].Format = cfNumber then
      begin
        ADataGrid.Cells[0, Index] := '1';
      end
      else
      begin
        if ADataGrid.Columns[0].Picklist.Count > 0 then
        begin
          ADataGrid.Cells[0, Index] := ADataGrid.Columns[0].Picklist[0];
        end;
      end;
    end;
    if (ADataGrid.Cells[1, Index] = '') and (ADataGrid.Columns[1].PickList.Count
      > 0) then
    begin
      ADataGrid.Cells[1, Index] := ADataGrid.Columns[1].PickList[0];
    end;
    if (ADataGrid.Cells[2, Index] = '') and (ADataGrid.Columns[2].PickList.Count
      > 0) then
    begin
      ADataGrid.Cells[2, Index] := ADataGrid.Columns[2].PickList[0];
    end;
  end;
end;

procedure TfrmMODFLOW.addParamPage(const A3DDataGrid: TRBWDataGrid3d);
var
  GridIndex: Integer;
  ADataGrid: TDataGrid;
  ATabSheet: TTabSheet;
  Index: integer;
  Root: string;
  NameIndex: integer;
begin
  GridIndex := A3DDataGrid.AddGrid;
  ADataGrid := A3DDataGrid.Grids[GridIndex];
  ADataGrid.ColCount := 13;
  ADataGrid.RowCount := 2;
  ATabSheet := A3DDataGrid.Pages[GridIndex];
  if A3DDataGrid = dg3dLPFParameterClusters then
  begin
    Root := 'LPF';
    ADataGrid.Cells[0, 0] := 'Unit';
    //    ADataGrid.Columns[0].Format := cfNumber;
  end
  else if A3DDataGrid = dg3dHUFParameterClusters then
  begin
    Root := 'HPF';
    ADataGrid.Cells[0, 0] := 'HUF Unit';
    ADataGrid.Columns[0].LimitToList := True;
  end
  else if A3DDataGrid = dg3dRCHParameterClusters then
  begin
    Root := 'RCH';
  end
  else if A3DDataGrid = dg3dEVTParameterClusters then
  begin
    Root := 'EVT';
  end
  else if A3DDataGrid = dg3dETSParameterClusters then
  begin
    Root := 'ETS';
  end
  else if A3DDataGrid = dg3dADVParameterClusters then
  begin
    Root := 'ADV';
    ADataGrid.Cells[0, 0] := 'Unit';
  end
  else
  begin
    Assert(False);
  end;
  ATabSheet.Caption := Root + '_Par' + IntToStr(GridIndex + 1);
  ADataGrid.Options := ADataGrid.Options + [goEditing, goColSizing];
  ADataGrid.Cells[1, 0] := 'Multiplier Array';
  ADataGrid.Cells[2, 0] := 'Zone Array';
  for Index := 3 to 12 do
  begin
    ADataGrid.Cells[Index, 0] := 'Zone no.';
  end;
  for Index := 0 to ADataGrid.ColCount - 1 do
  begin
    ADataGrid.Columns[Index].Title.Caption := ADataGrid.Cells[Index, 0];
    ADataGrid.ColWidths[Index]
      := ADataGrid.Canvas.TextWidth(ADataGrid.Columns[Index].Title.Caption) + 10
  end;

  ADataGrid.Columns[1].PickList.Add('NONE');
  for Index := 1 to dgMultiplier.RowCount - 1 do
  begin
    ADataGrid.Columns[1].PickList.Add(dgMultiplier.Cells[1, Index]);
  end;
  ADataGrid.Columns[1].LimitToList := True;

  ADataGrid.Columns[2].PickList.Add('ALL');
  for Index := 1 to sgZoneArrays.RowCount - 1 do
  begin
    ADataGrid.Columns[2].PickList.Add(sgZoneArrays.Cells[1, Index]);
  end;
  ADataGrid.Columns[2].LimitToList := True;

  for Index := 3 to 12 do
  begin
    ADataGrid.Columns[Index].Format := cfNumber;
  end;
  if A3DDataGrid <> dg3dHUFParameterClusters then
  begin
    ADataGrid.Columns[0].Format := cfNumber;
  end
  else
  begin
    ADataGrid.Columns[0].Format := cfString;
    ADataGrid.Columns[0].Picklist.Clear;
    for NameIndex := 1 to framHUF1.dgHufUnits.RowCount - 1 do
    begin
      ADataGrid.Columns[0].Picklist.Add(framHUF1.dgHufUnits.Cells[0,
        NameIndex]);
    end;
    ADataGrid.Columns[0].LimitToList := True;
  end;

  InitializeParamPage(ADataGrid)

end;

procedure TfrmMODFLOW.adeLPFParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
begin
  inherited;
  dg3dLPFParameterClusters.Enabled := True;
  ParameterCount := StrToInt(adeLPFParamCount.Text);
  btnDeleteLPF_Parameter.Enabled := ParameterCount > 0;

  if ParameterCount > dg3dLPFParameterClusters.PageCount then
  begin
    for Index := dg3dLPFParameterClusters.PageCount + 1 to ParameterCount do
    begin
      addParamPage(dg3dLPFParameterClusters);
    end;
  end
  else if ParameterCount < dg3dLPFParameterClusters.PageCount then
  begin
    for Index := dg3dLPFParameterClusters.PageCount - 1 downto ParameterCount do
    begin
      dg3dLPFParameterClusters.RemoveGrid(Index);
    end;
  end
  else
  begin
    InitializeFormats(dg3dLPFParameterClusters);
  end;

  //  dgParametersEnter(dgLPFParameters);
  InitializeDataGrid(dgLPFParameters, ParameterCount);

  InitializeMultParamPickLists(dg3dLPFParameterClusters);
  InitializeZoneParamPickLists(dg3dLPFParameterClusters);

end;

procedure TfrmMODFLOW.dgMultiplierEditButtonClick(Sender: TObject);
var
  LastdefinedParameter: Integer;
  Index: integer;
begin
  inherited;
  LastdefinedParameter := dgMultiplier.Row - 1;
  if (dgMultiplier.Cells[2, LastdefinedParameter + 1]
    = dgMultiplier.columns[2].Picklist[1]) then
  begin
    if (LastdefinedParameter > 0) then
    begin
      Application.CreateForm(TfrmMultiplierEditor, frmMultiplierEditor);
      //      frmMultiplierEditor:= TfrmMultiplierEditor.Create(Application);
      try

        frmMultiplierEditor.sgDefinedArrays.RowCount := LastdefinedParameter;
        for Index := 1 to LastdefinedParameter do
        begin
          frmMultiplierEditor.sgDefinedArrays.Cells[0, Index - 1] :=
            dgMultiplier.Cells[1, Index];
        end;
        frmMultiplierEditor.memoFunction.Text :=
          dgMultiplier.Cells[3, LastdefinedParameter + 1];
        if frmMultiplierEditor.ShowModal = mrOK then
        begin
          dgMultiplier.Cells[3, LastdefinedParameter + 1] :=
            frmMultiplierEditor.Formula;
        end;
      finally
        frmMultiplierEditor.Free;
      end;
    end;
  end
  else {if (dgMultiplier.Cells[2,LastdefinedParameter+1]
    = dgMultiplier.columns[2].Picklist[2]) then }
  begin
    Application.CreateForm(TfrmMultValue, frmMultValue);
    //    frmMultValue:= TfrmMultValue.Create(Application);
    try
      frmMultValue.adeValue.Text := dgMultiplier.Cells[3, dgMultiplier.Row];
      if frmMultValue.ShowModal = mrOK then
      begin
        dgMultiplier.Cells[3, dgMultiplier.Row] :=
          frmMultValue.adeValue.Text;
      end;
    finally
      frmMultValue.Free;
    end;
  end

end;

procedure TfrmMODFLOW.InitializeMultiplierGrid;
var
  RowIndex: integer;
  MultIndex: integer;
  MultName: string;
  Names: TStringList;
begin
  for RowIndex := 1 to dgMultiplier.RowCount - 1 do
  begin
    if dgMultiplier.Cells[1, RowIndex] = '' then
    begin
      MultIndex := RowIndex;
      MultName := 'Mult' + IntToStr(MultIndex);
      Names := TStringList.Create;
      try
        Names.Assign(dgMultiplier.Cols[1]);
        Names.Delete(0);
        while Names.IndexOf(MultName) >= 0 do
        begin
          Inc(MultIndex);
          MultName := 'Mult' + IntToStr(MultIndex);
        end;

      finally
        Names.Free;
      end;
      dgMultiplier.Cells[1, RowIndex] := MultName;
    end;
    if dgMultiplier.Cells[2, RowIndex] = '' then
    begin
      dgMultiplier.Cells[2, RowIndex] := dgMultiplier.Columns[2].Picklist[0];
    end;
    if dgMultiplier.Cells[3, RowIndex] = '' then
    begin
      dgMultiplier.Cells[3, RowIndex] := '1';
    end;
  end;
  OldMultiplierNames.Clear;
  OldMultiplierNames.Add('NONE');
  for RowIndex := 1 to dgMultiplier.RowCount - 1 do
  begin
    OldMultiplierNames.Add(dgMultiplier.Cells[1, RowIndex]);
  end;
end;

procedure TfrmMODFLOW.adeMultCountExit(Sender: TObject);
var
  NewMultiplierCount: integer;
  MultiplierList: T_ANE_IndexedLayerList;
  MultiplierParameterList: T_ANE_IndexedParameterList;
  Index: integer;
  ALayer: T_ANE_MapsLayer;
  GridLayer: T_ANE_GridLayer;
  LayersPresent: integer;
  //  AParameter : T_ANE_Param;
  //  ParamIndex : integer;
  MultiplierCount: integer;
  LayersToDelete: TList;
begin
  inherited;
  MultiplierCount := StrToInt(adeMultCount.Text);
  if MultiplierCount > 500 then
  begin
    adeMultCount.EnabledColor := clRed;
  end
  else
  begin
    adeMultCount.EnabledColor := clWindow;
  end;

  dgMultiplier.RowCount := MultiplierCount + 1;
  if dgMultiplier.RowCount > 1 then
  begin
    dgMultiplier.FixedRows := 1;
    dgMultiplier.Options := dgMultiplier.Options + [GoEditing];
    InitializeMultiplierGrid;
  end
  else
  begin
    dgMultiplier.Options := dgMultiplier.Options - [GoEditing];
  end;

  InitializeMultParamPickLists(dg3dLPFParameterClusters);
  InitializeMultParamPickLists(dg3dHUFParameterClusters);
  InitializeMultParamPickLists(dg3dRCHParameterClusters);
  InitializeMultParamPickLists(dg3dEVTParameterClusters);
  InitializeMultParamPickLists(dg3dETSParameterClusters);

  NewMultiplierCount := GetMultiplierCount;
  LayersPresent := 0;
  if NewMultiplierCount <> OldMultiplierCount then
  begin
    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    MultiplierList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgMultipliers)];
    LayersToDelete := TList.Create;
    try
      for Index := 1 to MultiplierList.Count - 1 do
      begin
        ALayer := MultiplierList.Items[Index];
        if LayersPresent < NewMultiplierCount then
        begin
          if (ALayer.Status <> sDeleted) and
            (ALayer is ModflowTypes.GetMFMultiplierLayerType) then
          begin
            Inc(LayersPresent);
            //ALayer.UnDelete
          end;
        end
        else
        begin
          LayersToDelete.Add(ALayer);
        end;
      end;
      for Index := 0 to LayersToDelete.Count -1 do
      begin
        ALayer := LayersToDelete[Index];
        ALayer.Delete;
      end;
    finally
      LayersToDelete.Free;
    end;
    if NewMultiplierCount > OldMultiplierCount then
    begin
      for Index := 0 to GridLayer.IndexedParamListNeg1.Count - 1 do
      begin
        MultiplierParameterList := GridLayer.IndexedParamListNeg1.Items[Index];
        if Index < NewMultiplierCount + 1 then
        begin
          MultiplierParameterList.UnDeleteSelf;
          MultiplierParameterList.SetExpressionNow
            (ModflowTypes.GetMFGridMultiplierParamType,
            ModflowTypes.GetMFGridMultiplierParamType.ANE_ParamName, True);
        end
        else
        begin
          MultiplierParameterList.DeleteSelf;
        end;
      end;
    end
    else
    begin
      for Index := GridLayer.IndexedParamListNeg1.Count - 1 downto 0 do
      begin
        MultiplierParameterList := GridLayer.IndexedParamListNeg1.Items[Index];
        if Index < NewMultiplierCount then
        begin
          MultiplierParameterList.UnDeleteSelf;
          MultiplierParameterList.SetExpressionNow
            (ModflowTypes.GetMFGridMultiplierParamType,
            ModflowTypes.GetMFGridMultiplierParamType.ANE_ParamName, True);
        end
        else
        begin
          MultiplierParameterList.DeleteSelf;
        end;
      end;
    end;

    for Index := LayersPresent to NewMultiplierCount - 1 do
    begin
      ModflowTypes.GetMFMultiplierLayerType.Create(MultiplierList, -1);
    end;
    for Index := GridLayer.IndexedParamListNeg1.Count to NewMultiplierCount - 1 do
    begin
      ModflowTypes.GetMFMultiplierParamListType.Create(GridLayer.IndexedParamListNeg1, -1);
    end;
  end;
end;

procedure TfrmMODFLOW.InitializeZoneGrid;
var
  RowIndex: integer;
begin
  for RowIndex := 1 to sgZoneArrays.RowCount - 1 do
  begin
    if sgZoneArrays.Cells[1, RowIndex] = '' then
    begin
      sgZoneArrays.Cells[1, RowIndex] := 'ZonAr' + IntToStr(RowIndex);
    end;
  end;
  OldZoneNames.Clear;
  OldZoneNames.Add('ALL');
  for RowIndex := 1 to sgZoneArrays.RowCount - 1 do
  begin
    OldZoneNames.Add(sgZoneArrays.Cells[1, RowIndex]);
  end;
end;

procedure TfrmMODFLOW.DeleteZoneGridParameters(const GridLayer: T_ANE_GridLayer;
  const NewZoneCount: integer);
var
  Index : integer;
  ZoneParameterList: T_ANE_IndexedParameterList;
  ParamIndex: integer;
  AParameter: T_ANE_Param;
begin
  for Index := GridLayer.IndexedParamList0.Count - 1 downto 0 do
  begin
    ZoneParameterList := GridLayer.IndexedParamList0.Items[Index];
    if Index < NewZoneCount then
    begin
      for ParamIndex := 0 to ZoneParameterList.Count - 1 do
      begin
        AParameter := ZoneParameterList.Items[ParamIndex];
        AParameter.UnDelete;
      end;
      ZoneParameterList.UnDeleteSelf;
    end
    else
    begin
      for ParamIndex := 0 to ZoneParameterList.Count - 1 do
      begin
        AParameter := ZoneParameterList.Items[ParamIndex];
        AParameter.Delete;
      end;
      ZoneParameterList.DeleteSelf;
    end;
  end;
end;

procedure TfrmMODFLOW.adeZoneCountExit(Sender: TObject);
var
  OldZoneCount, NewZoneCount: integer;
  ZoneList: T_ANE_IndexedLayerList;
  ZoneParameterList: T_ANE_IndexedParameterList;
  Index: integer;
  ALayer: T_ANE_MapsLayer;
  GridLayer: T_ANE_GridLayer;
  AParameter: T_ANE_Param;
  ParamIndex: integer;
  LayersToDelete: TList;
  LayerCount: integer;
begin
  inherited;
  OldZoneCount := sgZoneArrays.RowCount - 1;
  NewZoneCount := StrToInt(adeZoneCount.Text);

  if NewZoneCount > 500 then
  begin
    adeZoneCount.EnabledColor := clRed;
  end
  else
  begin
    adeZoneCount.EnabledColor := clWindow;
  end;

  sgZoneArrays.RowCount := NewZoneCount + 1;
  if sgZoneArrays.RowCount > 1 then
  begin
    sgZoneArrays.FixedRows := 1;
    sgZoneArrays.Options := sgZoneArrays.Options + [GoEditing];
    InitializeZoneGrid;
  end
  else
  begin
    sgZoneArrays.Options := sgZoneArrays.Options - [GoEditing];
  end;
  InitializeZoneParamPickLists(dg3dLPFParameterClusters);
  InitializeZoneParamPickLists(dg3dHUFParameterClusters);
  InitializeZoneParamPickLists(dg3dRCHParameterClusters);
  InitializeZoneParamPickLists(dg3dEVTParameterClusters);
  InitializeZoneParamPickLists(dg3dETSParameterClusters);

  if NewZoneCount <> OldZoneCount then
  begin
    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    ZoneList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgZones)];
    LayersToDelete := TList.Create;
    try
      LayerCount := 0;
      for Index := 1 to ZoneList.Count - 1 do
      begin
        ALayer := ZoneList.Items[Index];
        if (LayerCount < NewZoneCount) then
        begin
          if (ALayer.Status <> sDeleted)
            and (ALayer is ModflowTypes.GetMFZoneLayerType) then
          begin
            Inc(LayerCount);
          end
        end
        else
        begin
          LayersToDelete.Add(ALayer);
        end;
      end;
      for Index := 0 to LayersToDelete.Count -1 do
      begin
        ALayer := LayersToDelete[Index];
        ALayer.Delete;
      end;
    finally
      LayersToDelete.Free;
    end;

    if NewZoneCount > OldZoneCount then
    begin
      {for Index := 1 to ZoneList.Count - 1 do
      begin
        ALayer := ZoneList.Items[Index];
        if Index < NewZoneCount + 1 then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;   }
      for Index := 0 to GridLayer.IndexedParamList0.Count - 1 do
      begin
        ZoneParameterList := GridLayer.IndexedParamList0.Items[Index];
        if Index < NewZoneCount + 1 then
        begin
          for ParamIndex := 0 to ZoneParameterList.Count - 1 do
          begin
            AParameter := ZoneParameterList.Items[ParamIndex];
            AParameter.UnDelete;
            AParameter.SetExpressionNow := True;
          end;
          ZoneParameterList.UnDeleteSelf;
        end
        else
        begin
          for ParamIndex := 0 to ZoneParameterList.Count - 1 do
          begin
            AParameter := ZoneParameterList.Items[ParamIndex];
            AParameter.Delete;
          end;
          ZoneParameterList.DeleteSelf;
        end;
      end;
    end
    else
    begin
      {for Index := ZoneList.Count - 1 downto 1 do
      begin
        ALayer := ZoneList.Items[Index];
        if Index < NewZoneCount + 1 then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;}

      DeleteZoneGridParameters(GridLayer, NewZoneCount);
{      for Index := GridLayer.IndexedParamList0.Count - 1 downto 0 do
      begin
        ZoneParameterList := GridLayer.IndexedParamList0.Items[Index];
        if Index < NewZoneCount then
        begin
          for ParamIndex := 0 to ZoneParameterList.Count - 1 do
          begin
            AParameter := ZoneParameterList.Items[ParamIndex];
            AParameter.UnDelete;
          end;
          ZoneParameterList.UnDeleteSelf;
        end
        else
        begin
          for ParamIndex := 0 to ZoneParameterList.Count - 1 do
          begin
            AParameter := ZoneParameterList.Items[ParamIndex];
            AParameter.Delete;
          end;
          ZoneParameterList.DeleteSelf;
        end;
      end;}
    end;

    for Index := OldZoneCount to NewZoneCount - 1 do
    begin
      ModflowTypes.GetMFZoneLayerType.Create(ZoneList, -1);
      ModflowTypes.GetMFZoneParamListType.Create(GridLayer.IndexedParamList0,
        -1);
    end;
  end;
end;

procedure TfrmMODFLOW.dgMultiplierSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  {  if (ACol = 3)
      and (dgMultiplier.Cells[2, ARow] = dgMultiplier.Columns[2].PickList[0]) then
    begin
      CanSelect := False;
    end;  }
  if (ACol = 2) then
  begin
    OldMultiplierCount := GetMultiplierCount;
  end;
  dgMultiplier.Invalidate;
end;

procedure TfrmMODFLOW.dgMultiplierSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  NewValue: string;
  GridLayer: T_ANE_GridLayer;
  MultiplierParameterList: T_ANE_IndexedParameterList;
  Index: integer;
  //  AMultParam : T_ANE_GridParam;
  RowIndex: integer;
begin
  inherited;
  NewValue := Value;
  if ARow > 0 then
  begin
    if (ACol = 1) then
    begin
      if dgMultiplier.Cells[2, ARow] = dgMultiplier.Columns[2].PickList[0] then
      begin
        GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
          (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

        Index := -1;
        for RowIndex := 1 to ARow do
        begin
          if dgMultiplier.Cells[2, RowIndex]
            = dgMultiplier.Columns[2].PickList[0] then
          begin
            Inc(Index);
          end;
        end;

        //        Index := ARow-1;

        MultiplierParameterList := GridLayer.IndexedParamListNeg1.
          GetNonDeletedIndParameterListByIndex(Index);
        MultiplierParameterList.SetExpressionNow
          (ModflowTypes.GetMFGridMultiplierParamType,
          ModflowTypes.GetMFGridMultiplierParamType.ANE_ParamName, True);
      end;

      if Length(Value) > 10 then
      begin
        NewValue := Copy(Value, 1, 10);
        Beep;
        dgMultiplier.Cells[ACol, ARow] := NewValue;
      end;
      if not Loading and (OldMultiplierNames[ARow] <> NewValue)
        and (Trim(NewValue) <> '') then
      begin
        UpdateLCFMultiplier(ARow, OldMultiplierNames[ARow], NewValue);
      end;
    end;
    if (ACol = 2) and (ARow = 1) and
      (NewValue = dgMultiplier.Columns[2].PickList[1]) then
    begin
      dgMultiplier.Cells[ACol, ARow] := dgMultiplier.Columns[2].PickList[0]
    end;
    if not Loading and (Trim(NewValue) <> '') then
    begin
      OldMultiplierNames[ARow] := NewValue;
    end;
    if (ACol = 2) then
    begin
      adeMultCountExit(Sender);
      if (NewValue = dgMultiplier.Columns[2].PickList[1])
        {and (dgMultiplier.Cells[3, ARow] = '')}then
      begin
        if ARow <> 1 then
        begin
          dgMultiplier.Cells[3, ARow] := dgMultiplier.Cells[1, 1];
        end;
      end
      else
        {if (NewValue = dgMultiplier.Columns[2].PickList[2])
          and (dgMultiplier.Cells[3, ARow] = '') then }
      begin
        try
          if not loading and not cancelling then
          begin
            if dgMultiplier.Cells[3, ARow] = '' then
            begin
              dgMultiplier.Cells[3, ARow] := '1';
            end;
            InternationalStrToFloat(dgMultiplier.Cells[3, ARow]);
          end;
        except on EConvertError do
          begin
            dgMultiplier.Cells[3, ARow] := '1';
          end;
        end;
        //        dgMultiplier.Cells[3, ARow] := '1';
      end
    end;
    if (ACol = 3) and ((dgMultiplier.Cells[2, ARow]
      = dgMultiplier.Columns[2].PickList[2]) or (dgMultiplier.Cells[2, ARow]
      = dgMultiplier.Columns[2].PickList[0])) then
    begin
      if NewValue <> '' then
      begin
        try
          InternationalStrToFloat(NewValue);
        except on EConvertError do
          begin
            Beep;
            if not Loading and not cancelling then
            begin
              dgMultiplier.Cells[3, ARow] := '1';
            end
            else
            begin
              MessageDlg('The constant for the multiplier array "'
                + dgMultiplier.Cells[1, ARow] + '" is listed as "'
                + NewValue + '".  This should be a number instead.  '
                + 'Please correct it.',
                mtError, [mbOK], 0);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.sgZoneArraysSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  NewValue: string;
  ZoneParameterList: T_ANE_IndexedParameterList;
  Index: integer;
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  if ARow > 0 then
  begin
    NewValue := Value;

    if (ACol = 1) then
    begin
      if Length(Value) > 10 then
      begin
        NewValue := Copy(Value, 1, 10);
        Beep;
        sgZoneArrays.Cells[ACol, ARow] := NewValue;
      end;
      if (OldZoneNames[ARow - 1] <> NewValue) and (Trim(NewValue) <> '') then
      begin
        UpdateLCFZone(ARow, OldZoneNames[ARow], NewValue);
      end;

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      Index := ARow - 1;
      ZoneParameterList := GridLayer.IndexedParamList0.Items[Index];
      ZoneParameterList.SetExpressionNow
        (ModflowTypes.GetMFGridZoneParamType,
        ModflowTypes.GetMFGridZoneParamType.ANE_ParamName, True);

    end;
    if Trim(NewValue) <> '' then
    begin
      OldZoneNames[ARow] := NewValue;
    end;
  end;
end;

function TfrmMODFLOW.GetPreviousInstances(const ARow: integer;
  const DataGrid: TDataGrid): integer;
var
  RowIndex: integer;
  TempInstanceCountString: string;
  TempInstanceCount: integer;
begin
  result := 0;
  TempInstanceCount := 1;
  for RowIndex := 1 to ARow - 1 do
  begin
    TempInstanceCountString := DataGrid.Cells[4, RowIndex];
    if TempInstanceCountString = '' then
    begin
      TempInstanceCount := 1;
    end
    else
    begin
      try
        TempInstanceCount := StrToInt(TempInstanceCountString);
      except on EConvertError do
        begin
          TempInstanceCount := 1;
        end;
      end;
    end;
    if TempInstanceCount = 0 then
    begin
      TempInstanceCount := 1;
    end;
    result := result + TempInstanceCount;
  end;
end;

procedure TfrmMODFLOW.dgParametersSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
const
  InstanceColumn = 4;
var
  ClusterCount: Integer;
  ClusterIndex, ClusterStart, ClusterEnd: integer;
  ADataGrid: TDataGrid;
  ATabSheet: TTabSheet;
  NewValue: string;
  Position: integer;
  RowIndex: integer;
  Instances: TRBWStringGrid3d;
  InstanceCount, Code: integer;
  AdjustCount: boolean;
  AStringGrid: TStringGrid;
  PreviousInstanceCount: integer;
  SumPreviousInstances: integer;
  InstanceIndex: integer;
  ClusterGrid: TRBWDataGrid3D;
  LastInstanceCountString: string;
  InstanceCountString: string;
  ParameterGrid: TDataGrid;
  ClusterCountRowIndex: Integer;
  NewTabCaption: string;
  InstanceRow: integer;
begin
  inherited;
  if ARow > 0 then
  begin
    if (Sender <> dgLPFParameters) and (Sender <> dgHUFParameters)
      and (Sender <> dgADVParameters) then
    begin
      Instances := GetParmInstanceGrid(Sender);
    end
    else
    begin
      Instances := nil;
    end;
    NewValue := Value;
    ParameterGrid := Sender as TDataGrid;
    case ACol of
      0: // Parameter Name
        begin
          if Length(NewValue) > 10 then
          begin
            NewValue := Copy(NewValue, 1, 10);
            Beep;
            ParameterGrid.Cells[ACol, ARow] := NewValue;
          end;
          if Instances <> nil then
          begin
            if Instances.GridCount < ARow then
            begin
              Instances.GridCount := ARow;
            end;
            Instances.Pages[ARow - 1].Caption := NewValue;
          end;

          ClusterIndex := ARow - 1;
          NewTabCaption := NewValue;

          if Instances <> nil then
          begin
            ClusterIndex := 0;
            for ClusterCountRowIndex := 1 to ARow - 1 do
            begin
              InstanceCount := StrToIntDef(ParameterGrid.Cells[InstanceColumn,
                ClusterCountRowIndex], 1);
              if InstanceCount < 1 then
              begin
                InstanceCount := 1;
              end;
              ClusterIndex := ClusterIndex + InstanceCount;
            end;
            if StrToIntDef(ParameterGrid.Cells[InstanceColumn,
                ARow],1) > 1 then
            begin
              InstanceRow := Instances.Grids[ARow - 1].Row;
              if InstanceRow < 1 then
              begin
                InstanceRow := 1;
              end;
              NewTabCaption := NewTabCaption + '.'
                + Instances.Grids[ARow - 1].Cells[0,InstanceRow];
              ClusterIndex := ClusterIndex + InstanceRow -1;
            end;
          end;

          Assert((Sender = dgLPFParameters)
            or (Sender = dgHUFParameters)
            or (Sender = dgRCHParametersN)
            or (Sender = dgEVTParametersN)
            or (Sender = dgETSParametersN)
            or (Sender = dgADVParameters));
          ATabSheet := nil;
          //          if not Loading then
          begin
            if Sender = dgLPFParameters then
            begin
              ATabSheet := dg3dLPFParameterClusters.Pages[ClusterIndex];
            end
            else if Sender = dgHUFParameters then
            begin
              ATabSheet := dg3dHUFParameterClusters.Pages[ClusterIndex];
            end
            else if Sender = dgRCHParametersN then
            begin
              ATabSheet := dg3dRCHParameterClusters.Pages[ClusterIndex];
            end
            else if Sender = dgEVTParametersN then
            begin
              ATabSheet := dg3dEVTParameterClusters.Pages[ClusterIndex];
            end
            else if Sender = dgETSParametersN then
            begin
              ATabSheet := dg3dETSParameterClusters.Pages[ClusterIndex];
            end
            else if Sender = dgADVParameters then
            begin
              ATabSheet := dg3dADVParameterClusters.Pages[ClusterIndex];
            end;
          end;

          if ATabSheet <> nil then
          begin
            ATabSheet.Caption := NewTabCaption;
          end;

          Position :=
            dgSensitivity.Columns[1].PickList.IndexOf(OldParamNames[ARow]);
          if Position > -1 then
          begin
            dgSensitivity.Columns[1].PickList[Position] := NewValue;
          end
          else
          begin
            if dgSensitivity.Columns[1].PickList.IndexOf(NewValue) < 0 then
            begin

              dgSensitivity.Columns[1].PickList.Add(NewValue);
            end;
          end;

          SortParamNames;

          if not loading and not cancelling and (OldParamNames[ARow] <> NewValue)
            then
          begin
            for RowIndex := 1 to dgSensitivity.RowCount - 1 do
            begin
              if dgSensitivity.Cells[1, RowIndex] = OldParamNames[ARow] then
              begin
                dgSensitivity.Cells[1, RowIndex] := NewValue;
              end;
            end;
          end;

          Position :=
            dgParamEstCovNames.Columns[0].PickList.IndexOf(OldParamNames[ARow]);
          if Position > -1 then
          begin
            dgParamEstCovNames.Columns[0].PickList[Position] := NewValue;
          end
          else
          begin
            if dgParamEstCovNames.Columns[0].PickList.IndexOf(NewValue) < 0 then
            begin
              dgParamEstCovNames.Columns[0].PickList.Add(NewValue);
            end;
          end;
          if not loading and not cancelling then
          begin
            for RowIndex := 1 to dgParamEstCovNames.RowCount - 1 do
            begin
              if dgParamEstCovNames.Cells[0, RowIndex] = OldParamNames[ARow]
                then
              begin
                dgParamEstCovNames.Cells[0, RowIndex] := NewValue;
              end;
            end;
          end;

          if (Sender = dgLPFParameters)
            or (Sender = dgHUFParameters)
            or (Sender = dgEVTParametersN)
            or (Sender = dgETSParametersN)
            or (Sender = dgADVParameters) then
          begin
            if (OldParamNames[ARow] <> NewValue) then
            begin
              for RowIndex := 1 to dgNegParam.RowCount - 1 do
              begin
                if dgNegParam.Cells[0, RowIndex] = OldParamNames[ARow] then
                begin
                  if not loading and not cancelling then
                  begin
                    dgNegParam.Cells[0, RowIndex] := NewValue;
                    break;
                  end;
                end;
              end;
            end;
          end;

          if not loading and not cancelling then
          begin
            OldParamNames[ARow] := NewValue;
          end;
        end;
      1: // Parameter type
        begin
          if (Sender = dgLPFParameters)
            and (Value = 'horizontal to vertical anisotropy (VANI)') then
          begin
            dgLPFParameters.Cells[ACol, ARow]
              := dgLPFParameters.Columns[1].Picklist[2];
          end
          else if Sender = dgHUFParameters then
          begin
            UpdateHufLVDA_Units;
            UpdateHufSYTP;
            framHUF1dgHufUnitsEnter(nil);
            framHUF1dgHufUnitsExit(nil);
            HUF_HFB_Warning;
          end;
        end;
      2: // Value
        begin
        end;
      3: // number of clusters
        begin
          if (Sender = dgLPFParameters)
            or (Sender = dgHUFParameters)
            or (Sender = dgRCHParametersN)
            or (Sender = dgEVTParametersN)
            or (Sender = dgETSParametersN)
            or (Sender = dgADVParameters) then
          begin
            try
              if Value = '' then
              begin
                  ClusterCount := 0;
              end
              else
              begin
                try
                  ClusterCount := StrToInt(Value);
                except on EConvertError do
                  // do nothing
                  ClusterCount := 0;
                end;
              end;
              if ClusterCount > 0 then
              begin
                if (Sender = dgLPFParameters)
                  or (Sender = dgHUFParameters)
                  or (Sender = dgADVParameters) then
                begin
                  ClusterStart := ARow - 1;
                  ClusterEnd := ClusterStart;
                end
                else
                begin
                  SumPreviousInstances := GetPreviousInstances(ARow, (Sender as
                    TDataGrid));
                  InstanceCountString := (Sender as TDataGrid).Cells[4, ARow];
                  if InstanceCountString = '' then
                  begin
                    InstanceCount := 1;
                  end
                  else
                  begin
                    InstanceCount := StrToInt(InstanceCountString);
                  end;
                  if InstanceCount = 0 then
                  begin
                    InstanceCount := 1;
                  end;
                  ClusterStart := SumPreviousInstances;
                  ClusterEnd := SumPreviousInstances + InstanceCount - 1;
                end;
                for ClusterIndex := ClusterStart to ClusterEnd do
                begin
                  if Sender = dgLPFParameters then
                  begin
                    ADataGrid := dg3dLPFParameterClusters.Grids[ClusterIndex];
                  end
                  else if Sender = dgHUFParameters then
                  begin
                    ADataGrid := dg3dHUFParameterClusters.Grids[ClusterIndex];
                  end
                  else if Sender = dgRCHParametersN then
                  begin
                    ADataGrid := dg3dRCHParameterClusters.Grids[ClusterIndex];
                  end
                  else if Sender = dgEVTParametersN then
                  begin
                    ADataGrid := dg3dEVTParameterClusters.Grids[ClusterIndex];
                  end
                  else if Sender = dgETSParametersN then
                  begin
                    ADataGrid := dg3dETSParameterClusters.Grids[ClusterIndex];
                  end
                  else if Sender = dgADVParameters then
                  begin
                    ADataGrid := dg3dADVParameterClusters.Grids[ClusterIndex];
                  end
                  else
                  begin
                    ADataGrid := nil;
                    Assert(False);
                  end;
                  ADataGrid.RowCount := ClusterCount + 1;
                  InitializeParamPage(ADataGrid);
                end;
              end;
            except
              on EconvertError do
              begin
              end;
            end;
          end;
        end;
      4: //Instances - this column is not present for dgLPFParameters or dgHUFParameters
        begin
          if Trim(NewValue) <> '' then
          begin
            Val(NewValue, InstanceCount, Code);
            if Code > 0 then
            begin
              NewValue := Copy(NewValue, 1, Code - 1);
              ADataGrid := Sender as TDataGrid;
              ADataGrid.Cells[ACol, ARow] := NewValue;
              dgParametersSetEditText(Sender, ACol, Arow, NewValue);
              Exit;
            end;
            if InstanceCount < 0 then
            begin
              NewValue := '0';
              ADataGrid := Sender as TDataGrid;
              ADataGrid.Cells[ACol, ARow] := NewValue;
              dgParametersSetEditText(Sender, ACol, Arow, NewValue);
              Exit;
            end;

            if (InstanceCount > dgTime.RowCount - 1) and not loading and not
              cancelling then
            begin
              NewValue := IntToStr(dgTime.RowCount - 1);
              ADataGrid := Sender as TDataGrid;
              ADataGrid.Cells[ACol, ARow] := NewValue;
              dgParametersSetEditText(Sender, ACol, Arow, NewValue);
              Exit;
            end;

            if InstanceCount > 1 then
            begin
              AdjustCount := False;
              if Sender = dgRCHParametersN then
              begin
                if comboRchSteady.ItemIndex = 0 then
                begin
                  AdjustCount := True;
                end;
              end
              else if Sender = dgETSParametersN then
              begin
                if comboEtsSteady.ItemIndex = 0 then
                begin
                  AdjustCount := True;
                end;
              end
              else if Sender = dgEVTParametersN then
              begin
                if comboEvtSteady.ItemIndex = 0 then
                begin
                  AdjustCount := True;
                end;
              end
              else
              begin
                Assert(False);
              end;
              if AdjustCount then
              begin
                NewValue := '1';
                ADataGrid := Sender as TDataGrid;
                ADataGrid.Cells[ACol, ARow] := NewValue;
                dgParametersSetEditText(Sender, ACol, Arow, NewValue);
                Exit;
              end;
            end;

            if ARow < LastInstanceCountStringList.Count then
            begin
              LastInstanceCountString := LastInstanceCountStringList[ARow];
            end
            else
            begin
              LastInstanceCountString := '';
            end;
            if LastInstanceCountString = '' then
            begin
              PreviousInstanceCount := 1;
            end
            else
            begin
              try
                PreviousInstanceCount := StrToInt(LastInstanceCountString);
              except on EConvertError do
                begin
                  PreviousInstanceCount := 1;
                end;
              end;
            end;
            if PreviousInstanceCount = 0 then
            begin
              PreviousInstanceCount := 1;
            end;

            if InstanceCount = 0 then
            begin
              InstanceCount := 1;
            end;

            SumPreviousInstances := GetPreviousInstances(ARow, (Sender as
              TDataGrid));

            ClusterGrid := GetParmClusterGrid(Sender);
            if InstanceCount > PreviousInstanceCount then
            begin
              for InstanceIndex := SumPreviousInstances + PreviousInstanceCount
                to SumPreviousInstances + InstanceCount - 1 do
              begin
                addParamPage(ClusterGrid);
                ClusterGrid.MovePage(ClusterGrid.PageCount - 1, InstanceIndex)
              end;
            end
            else if InstanceCount < PreviousInstanceCount then
            begin
              for InstanceIndex := SumPreviousInstances + PreviousInstanceCount
                - 1
                downto SumPreviousInstances + InstanceCount do
              begin
                ClusterGrid.RemoveGrid(InstanceIndex);
              end;
            end;

            AStringGrid := Instances.Grids[ARow - 1];

            if InstanceCount <= 1 then
            begin
              AStringGrid.RowCount := 0;
            end
            else
            begin
              AStringGrid.RowCount := InstanceCount + 1;
              if AStringGrid.RowCount > 1 then
              begin
                AStringGrid.FixedRows := 1;
                AStringGrid.Cells[0, 0] := 'Instance Name';
              end;
            end;
            for RowIndex := 1 to AStringGrid.RowCount - 1 do
            begin
              if AStringGrid.Cells[0, RowIndex] = '' then
              begin
                AStringGrid.Cells[0, RowIndex] := 'Inst' + IntToStr(RowIndex);
              end;
            end;
            if Assigned(AStringGrid.OnSetEditText) then
            begin
              AStringGrid.OnSetEditText(AStringGrid, 0, AStringGrid.RowCount -
                1,
                AStringGrid.Cells[0, AStringGrid.RowCount - 1])
            end;

            LastInstanceCountString := IntToStr(InstanceCount);
            LastInstanceCountStringList[ARow] := LastInstanceCountString;
            dgParametersSetEditText(Sender, 3, ARow, (Sender as
              TDataGrid).Cells[3, ARow]);
          end;
        end;
    else
      begin
        //          Assert(False);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.dgMultiplierEnter(Sender: TObject);
var
  CanSelect: Boolean;
begin
  inherited;
  CanSelect := True;
  dgMultiplierSelectCell(Sender, dgMultiplier.Col, dgMultiplier.Row, CanSelect);
end;

procedure TfrmMODFLOW.UpdateMultiplier(Position: integer;
  OldMultiplierName, NewMultiplierName: string; ADataGrid: TDataGrid);
var
  RowIndex: integer;
begin
  if (Position > -1) and (ADataGrid.Columns[1].PickList.Count > Position) then
  begin
    ADataGrid.Columns[1].PickList[Position] := NewMultiplierName;
  end
  else
  begin
    if ADataGrid.Columns[1].PickList.IndexOf(NewMultiplierName) = -1 then
    begin
      ADataGrid.Columns[1].PickList.Add(NewMultiplierName);
    end;
  end;
  if Trim(NewMultiplierName) <> '' then
  begin
    for RowIndex := 1 to ADataGrid.RowCount - 1 do
    begin
      if ADataGrid.Cells[1, RowIndex] = OldMultiplierName then
      begin
        ADataGrid.Cells[1, RowIndex] := NewMultiplierName;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.UpdateLCFMultiplier(Position: integer;
  OldMultiplierName, NewMultiplierName: string);
var
  GridIndex: integer;
  ADataGrid: TDataGrid;
  //  RowIndex : integer;
begin
  for GridIndex := 0 to dg3dLPFParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dLPFParameterClusters.Grids[GridIndex];
    UpdateMultiplier(Position, OldMultiplierName, NewMultiplierName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dHUFParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dHUFParameterClusters.Grids[GridIndex];
    UpdateMultiplier(Position, OldMultiplierName, NewMultiplierName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dEVTParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dEVTParameterClusters.Grids[GridIndex];
    UpdateMultiplier(Position, OldMultiplierName, NewMultiplierName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dETSParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dETSParameterClusters.Grids[GridIndex];
    UpdateMultiplier(Position, OldMultiplierName, NewMultiplierName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dRCHParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dRCHParameterClusters.Grids[GridIndex];
    UpdateMultiplier(Position, OldMultiplierName, NewMultiplierName, ADataGrid);
  end;
end;

procedure TfrmMODFLOW.UpdateZone(Position: integer;
  OldZoneName, NewZoneName: string; ADataGrid: TDataGrid);
var
  RowIndex: integer;
begin
  if (Position > -1) and (ADataGrid.Columns[2].PickList.Count > Position) then
  begin
    ADataGrid.Columns[2].PickList[Position] := NewZoneName;
  end
  else
  begin
    if ADataGrid.Columns[2].PickList.IndexOf(NewZoneName) = -1 then
    begin
      ADataGrid.Columns[2].PickList.Add(NewZoneName);
    end;
  end;
  if Trim(NewZoneName) <> '' then
  begin
    for RowIndex := 1 to ADataGrid.RowCount - 1 do
    begin
      if ADataGrid.Cells[2, RowIndex] = OldZoneName then
      begin
        ADataGrid.Cells[2, RowIndex] := NewZoneName;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.UpdateLCFZone(Position: integer;
  OldZoneName, NewZoneName: string);
var
  GridIndex: integer;
  ADataGrid: TDataGrid;
  //  RowIndex : integer;
begin
  for GridIndex := 0 to dg3dLPFParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dLPFParameterClusters.Grids[GridIndex];
    UpdateZone(Position, OldZoneName, NewZoneName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dHUFParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dHUFParameterClusters.Grids[GridIndex];
    UpdateZone(Position, OldZoneName, NewZoneName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dEVTParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dEVTParameterClusters.Grids[GridIndex];
    UpdateZone(Position, OldZoneName, NewZoneName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dETSParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dETSParameterClusters.Grids[GridIndex];
    UpdateZone(Position, OldZoneName, NewZoneName, ADataGrid);
  end;
  for GridIndex := 0 to dg3dRCHParameterClusters.PageCount - 1 do
  begin
    ADataGrid := dg3dRCHParameterClusters.Grids[GridIndex];
    UpdateZone(Position, OldZoneName, NewZoneName, ADataGrid);
  end;
end;

procedure TfrmMODFLOW.FixMultiplierNames;
var
  Index: integer;
  Problem: boolean;
begin
  for Index := 1 to dgMultiplier.RowCount - 1 do
  begin
    dgMultiplier.Cells[1, Index] := FixModflowName(dgMultiplier.Cells[1,
      Index]);
    dgMultiplierSetEditText(dgMultiplier, 1, Index,
      dgMultiplier.Cells[1, Index]);
  end;

  repeat
    Problem := False;
    for Index := 1 to dgMultiplier.RowCount - 1 do
    begin
      if OldMultiplierNames.IndexOf(dgMultiplier.Cells[1, Index]) <> Index then
      begin
        dgMultiplier.Cells[1, Index] := dgMultiplier.Cells[1, Index] + '1';
        dgMultiplierSetEditText(dgMultiplier, 1, Index,
          dgMultiplier.Cells[1, Index]);
        Problem := True;
      end;
    end;
  until not Problem;

end;

procedure TfrmMODFLOW.FixZoneNames;
var
  Index: integer;
  Problem: boolean;
begin
  for Index := 1 to sgZoneArrays.RowCount - 1 do
  begin
    sgZoneArrays.Cells[1, Index] := FixModflowName(sgZoneArrays.Cells[1,
      Index]);
    sgZoneArraysSetEditText(sgZoneArrays, 1, Index,
      sgZoneArrays.Cells[1, Index]);
  end;

  repeat
    Problem := False;
    for Index := 1 to sgZoneArrays.RowCount - 1 do
    begin
      if OldZoneNames.IndexOf(sgZoneArrays.Cells[1, Index]) <> Index then
      begin
        sgZoneArrays.Cells[1, Index] := sgZoneArrays.Cells[1, Index] + '1';
        sgZoneArraysSetEditText(sgZoneArrays, 1, Index,
          sgZoneArrays.Cells[1, Index]);
        Problem := True;
      end;
    end;
  until not Problem;

end;

{procedure TfrmMODFLOW.InitializeDataGrid(ADataGrid : TDataGrid; ParameterCount : integer);
var
  RowIndex : integer;
  ColIndex : GeneralPropertyParameter;
begin
  ADataGrid.RowCount := ParameterCount + 1;
  if ADataGrid.RowCount > 1 then
  begin
    ADataGrid.FixedRows := 1;
  end;
  for RowIndex := 1 to ADataGrid.RowCount -1 do
  begin
    for ColIndex := Low(GeneralPropertyParameter) to High(GeneralPropertyParameter) do
    begin
      case ColIndex of
        gppName :
          if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
          begin
            ADataGrid.Cells[Ord(ColIndex), RowIndex] := 'Parameter'
              + IntToStr(RowIndex);
          end;
        gppInitialValue :
          if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
          begin
            ADataGrid.Cells[Ord(ColIndex), RowIndex] := '0';
          end;
        gppClusterCount :
          if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
          begin
            ADataGrid.Cells[Ord(ColIndex), RowIndex] := '1';
          end;
      else ;
        Assert(False);
      end;

    end;
  end;
end;  }

procedure TfrmMODFLOW.RemoveOldParameters(ADataGrid: TDataGrid;
  ParameterCount: integer);
var
  OldName: string;
  OldNameCount: integer;
  Position: integer;
  RowIndex: integer;
  InnerRowIndex: integer;
begin
  OldNameCount := ADataGrid.RowCount - 1;
  if OldNameCount > ParameterCount then
  begin
    for RowIndex := ParameterCount + 1 to ADataGrid.RowCount - 1 do
    begin
      OldName := ADataGrid.Cells[0, RowIndex];
      Position := dgSensitivity.Columns[1].PickList.IndexOf(OldName);
      if Position > -1 then
      begin
        dgSensitivity.Columns[1].PickList.Delete(Position);
      end;
      if not loading and not cancelling then
      begin
        for InnerRowIndex := dgSensitivity.RowCount - 1 downto 1 do
        begin
          if dgSensitivity.Cells[1, InnerRowIndex] = OldName then
          begin
            RemoveSensitivityParameter(InnerRowIndex);
            {            if dgSensitivity.Columns[1].PickList.Count > 0 then
                        begin
                          dgSensitivity.Cells[1,InnerRowIndex] :=
                            dgSensitivity.Columns[1].PickList[0];
                        end
                        else
                        begin
                          dgSensitivity.Cells[1,InnerRowIndex] := '';
                        end;
                        dgSensitivity.Cells[2,InnerRowIndex] :=
                          dgSensitivity.Columns[2].PickList[0]; }
          end;
        end;
      end;
      Position := dgParamEstCovNames.Columns[0].PickList.IndexOf(OldName);
      if Position > -1 then
      begin
        dgParamEstCovNames.Columns[0].PickList.Delete(Position);
      end;
      if not loading and not cancelling then
      begin
        for InnerRowIndex := 1 to dgParamEstCovNames.RowCount - 1 do
        begin
          if dgParamEstCovNames.Cells[0, InnerRowIndex] = OldName then
          begin
            if dgParamEstCovNames.Columns[0].PickList.Count > 0 then
            begin
              dgParamEstCovNames.Cells[0, InnerRowIndex] :=
                dgParamEstCovNames.Columns[0].PickList[0];
            end
            else
            begin
              dgParamEstCovNames.Cells[0, InnerRowIndex] := '';
            end;
            dgParamEstCovNamesSetEditText(nil, 0, InnerRowIndex,
              dgParamEstCovNames.Cells[0, InnerRowIndex]);
          end;
        end;
      end;

    end;
    if not loading and not cancelling
      and ((ADataGrid = dgLPFParameters)
      or (ADataGrid = dgHUFParameters)
      or (ADataGrid = dgEVTParametersN)
      or (ADataGrid = dgETSParametersN)) then
    begin
      for RowIndex := ParameterCount + 1 to ADataGrid.RowCount - 1 do
      begin
        OldName := ADataGrid.Cells[0, RowIndex];
        for InnerRowIndex := dgNegParam.RowCount - 1 downto 1 do
        begin
          if dgNegParam.Cells[0, InnerRowIndex] = OldName then
          begin
            dgNegParam.DeleteRow(InnerRowIndex);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.AddNewParameters(ADataGrid: TDataGrid;
  OldNameCount: integer);
var
  NewName: string;
  Position: integer;
  RowIndex: integer;
  Found: boolean;
  ParameterName: string;
  InnerRowIndex: integer;
begin
  if OldNameCount < ADataGrid.RowCount - 1 then
  begin
    for RowIndex := OldNameCount + 1 to ADataGrid.RowCount - 1 do
    begin
      NewName := ADataGrid.Cells[0, RowIndex];
      Position := dgSensitivity.Columns[1].PickList.IndexOf(NewName);
      if Position < 0 then
      begin
        // sensitivity analysis and parameter estimation
        // are not allowed with SFR parameters.
        if ADataGrid <> dgSFRParametersN then
        begin
          dgSensitivity.Columns[1].PickList.Add(NewName);
        end;
      end;
    end;
    SortParamNames;
  end;
  if (ADataGrid = dgLPFParameters)
    or (ADataGrid = dgHUFParameters)
    or (ADataGrid = dgEVTParametersN)
    or (ADataGrid = dgETSParametersN)
    or (ADataGrid = dgADVParameters) then
  begin
    for RowIndex := 1 to ADataGrid.RowCount - 1 do
    begin
      ParameterName := ADataGrid.Cells[0, RowIndex];
      Found := False;
      for InnerRowIndex := 1 to dgNegParam.RowCount - 1 do
      begin
        if dgNegParam.Cells[0, InnerRowIndex] = ParameterName then
        begin
          Found := True;
          break;
        end;
      end;
      if not Found then
      begin
        // sensitivity analysis and parameter estimation
        // are not allowed with SFR parameters.
        if ADataGrid <> dgSFRParametersN then
        begin
          dgNegParam.RowCount := dgNegParam.RowCount + 1;
          dgNegParam.Cells[0, dgNegParam.RowCount - 1] := ParameterName;
          dgNegParam.Cells[1, dgNegParam.RowCount - 1] :=
            dgNegParam.Columns[1].Picklist[0];
        end;
      end;
    end;
    if dgNegParam.RowCount > 1 then
    begin
      dgNegParam.FixedRows := 1;
    end;
  end;
end;

procedure TfrmMODFLOW.InitializeDataGrid(ADataGrid: TDataGrid;
  ParameterCount: integer);
var
  RowIndex, InnerRowIndex: integer;
  ColIndex, StartCol, EndCol: LayerPropertyParameter;

  ColIndex2: integer;
  NewName: string;
  Position: integer;
  Found: boolean;
  Instances: TRBWStringGrid3D;
  Dummy: Boolean;
begin
  if (ADataGrid <> dgLPFParameters)
    and (ADataGrid <> dgHFBParameters)
    and (ADataGrid <> dgHUFParameters)
    and (ADataGrid <> dgADVParameters) then
  begin
    Instances := GetParmInstanceGrid(ADataGrid);
  end
  else
  begin
    Instances := nil;
  end;

  RemoveOldParameters(ADataGrid, ParameterCount);
  ADataGrid.RowCount := ParameterCount + 1;
  dgParametersEnter(ADataGrid);
  if ADataGrid.RowCount > 1 then
  begin
    ADataGrid.FixedRows := 1;
  end;
  StartCol := Low(LayerPropertyParameter);
  EndCol := High(LayerPropertyParameter);
  if not ((ADataGrid = dgRCHParametersN)
    or (ADataGrid = dgEVTParametersN)
    or (ADataGrid = dgETSParametersN)
{    or (ADataGrid = dgHUFParameters)
    or (ADataGrid = dgLPFParameters)
    or (ADataGrid = dgADVParameters)}) then
  begin
    Dec(EndCol);
  end;
  if ADataGrid = dgHFBParameters then
  begin
    Dec(EndCol);
  end;

  for RowIndex := 1 to ADataGrid.RowCount - 1 do
  begin
    for ColIndex := StartCol to EndCol do
    begin
      case ColIndex of
        lppName:
          begin
            Dummy:= True;
            if Assigned(ADataGrid.OnSelectCell) then
            begin
              ADataGrid.OnSelectCell(ADataGrid, Ord(ColIndex), RowIndex,
                Dummy);
            end;
            if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
            begin
              Assert((ADataGrid = dgLPFParameters)
                or (ADataGrid = dgRCHParametersN)
                or (ADataGrid = dgEVTParametersN)
                or (ADataGrid = dgRIVParametersN)
                or (ADataGrid = dgWELParametersN)
                or (ADataGrid = dgRIVParametersN)
                or (ADataGrid = dgGHBParametersN)
                or (ADataGrid = dgHFBParameters)
                or (ADataGrid = dgSFRParametersN)
                or (ADataGrid = dgSTRParametersN)
                or (ADataGrid = dgETSParametersN)
                or (ADataGrid = dgDRTParametersN)
                or (ADataGrid = dgDRNParametersN)
                or (ADataGrid = dgCHDParameters)
                or (ADataGrid = dgHUFParameters)
                or (ADataGrid = dgADVParameters));
              if ADataGrid = dgLPFParameters then
              begin
                NewName := 'LPF_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgHUFParameters then
              begin
                NewName := 'HUF_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgRCHParametersN then
              begin
                NewName := 'RCH_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgEVTParametersN then
              begin
                NewName := 'EVT_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgRIVParametersN then
              begin
                NewName := 'RIV_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgWELParametersN then
              begin
                NewName := 'Q_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgDRNParametersN then
              begin
                NewName := 'DRN_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgGHBParametersN then
              begin
                NewName := 'GHB_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgHFBParameters then
              begin
                NewName := 'HFB_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgSFRParametersN then
              begin
                NewName := 'SFR_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgSTRParametersN then
              begin
                NewName := 'STR_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgETSParametersN then
              begin
                NewName := 'ETS_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgDRTParametersN then
              begin
                NewName := 'DRT_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgCHDParameters then
              begin
                NewName := 'CHD_Par' + IntToStr(RowIndex);
              end
              else if ADataGrid = dgADVParameters then
              begin
                NewName := 'ADV_Par' + IntToStr(RowIndex);
              end
              else
              begin
                Assert(False);
              end;
              ADataGrid.Cells[Ord(ColIndex), RowIndex] := NewName;
              if Instances <> nil then
              begin
                Instances.Pages[RowIndex - 1].Caption := NewName;
              end;

              Position :=
                dgSensitivity.Columns[1].PickList.IndexOf(OldParamNames[RowIndex]);
              if Position > -1 then
              begin
                dgSensitivity.Columns[1].PickList[Position] := NewName;
              end
              else
              begin
                if (dgSensitivity.Columns[1].PickList.IndexOf(NewName) < 0) then
                begin
                  // sensitivity analysis and parameter estimation
                  // are not allowed with SFR parameters.
                  if (ADataGrid <> dgSFRParametersN) then
                  begin
                    dgSensitivity.Columns[1].PickList.Add(NewName);
                  end;
                end;
              end;

              SortParamNames;

              Position :=
                dgParamEstCovNames.Columns[0].PickList.IndexOf(NewName);
              if (Position < 0) then
              begin
                  // sensitivity analysis and parameter estimation
                  // are not allowed with SFR parameters.
                if (ADataGrid <> dgSFRParametersN) then
                begin
                  dgParamEstCovNames.Columns[0].PickList.Add(NewName);
                end;
              end;

            end;
            NewName := ADataGrid.Cells[Ord(ColIndex), RowIndex];
            if (ADataGrid = dgLPFParameters)
              or (ADataGrid = dgHUFParameters)
              or (ADataGrid = dgEVTParametersN)
              or (ADataGrid = dgETSParametersN)
              or (ADataGrid = dgADVParameters) then
            begin
              Found := False;
              for InnerRowIndex := 1 to dgNegParam.RowCount - 1 do
              begin
                if NewName = dgNegParam.Cells[0, InnerRowIndex] then
                begin
                  Found := True;
                  break;
                end;
              end;
              if not Found then
              begin
                dgNegParam.RowCount := dgNegParam.RowCount + 1;
                if dgNegParam.RowCount > 1 then
                begin
                  dgNegParam.FixedRows := 1;
                end;
                dgNegParam.Cells[0, dgNegParam.RowCount - 1] := NewName;
                dgNegParam.Cells[1, dgNegParam.RowCount - 1] :=
                  dgNegParam.Columns[1].PickList[0];
              end;
            end;
            if Assigned(ADataGrid.OnSetEditText) then
            begin
              ADataGrid.OnSetEditText(ADataGrid, Ord(ColIndex), RowIndex,
                ADataGrid.Cells[Ord(ColIndex), RowIndex]);
            end;
          end;
        lppType:
          begin
            Dummy:= True;
            if Assigned(ADataGrid.OnSelectCell) then
            begin
              ADataGrid.OnSelectCell(ADataGrid, Ord(ColIndex), RowIndex,
                Dummy);
            end;
            if (ADataGrid.Cells[Ord(ColIndex), RowIndex] = '') then
            begin
              ADataGrid.Cells[Ord(ColIndex), RowIndex] :=
                ADataGrid.Columns[Ord(lppType)].PickList[0];
            end;
            if Assigned(ADataGrid.OnSetEditText) then
            begin
              ADataGrid.OnSetEditText(ADataGrid, Ord(ColIndex), RowIndex,
                ADataGrid.Cells[Ord(ColIndex), RowIndex]);
            end;
          end;
        lppInitialValue:
          begin
            Dummy:= True;
            if Assigned(ADataGrid.OnSelectCell) then
            begin
              ADataGrid.OnSelectCell(ADataGrid, Ord(ColIndex), RowIndex,
                Dummy);
            end;
            if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
            begin
              ADataGrid.Cells[Ord(ColIndex), RowIndex] := '0';
            end;
            if Assigned(ADataGrid.OnSetEditText) then
            begin
              ADataGrid.OnSetEditText(ADataGrid, Ord(ColIndex), RowIndex,
                ADataGrid.Cells[Ord(ColIndex), RowIndex]);
            end;
          end;
        lppClusterCount:
          begin
            Dummy:= True;
            if Assigned(ADataGrid.OnSelectCell) then
            begin
              ADataGrid.OnSelectCell(ADataGrid, Ord(ColIndex), RowIndex,
                Dummy);
            end;
            if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
            begin
              if ((ADataGrid = dgRCHParametersN)
                or (ADataGrid = dgEVTParametersN)
                or (ADataGrid = dgETSParametersN)
                or (ADataGrid = dgHUFParameters)
                or (ADataGrid = dgLPFParameters)
                or (ADataGrid = dgADVParameters)) then
              begin
                ADataGrid.Cells[Ord(ColIndex), RowIndex] := '1';
              end
              else
              begin
                ADataGrid.Cells[Ord(ColIndex), RowIndex] := '0';
              end;
            end;
            if Assigned(ADataGrid.OnSetEditText) then
            begin
              ADataGrid.OnSetEditText(ADataGrid, Ord(ColIndex), RowIndex,
                ADataGrid.Cells[Ord(ColIndex), RowIndex]);
            end;
          end;
        lppInstances:
          begin
            if Ord(ColIndex) < ADataGrid.Colcount then
            begin
              Dummy:= True;
              if Assigned(ADataGrid.OnSelectCell) then
              begin
                ADataGrid.OnSelectCell(ADataGrid, Ord(ColIndex), RowIndex,
                  Dummy);
              end;
              if ADataGrid.Cells[Ord(ColIndex), RowIndex] = '' then
              begin
                ADataGrid.Cells[Ord(ColIndex), RowIndex] := '0';
              end;
              if Assigned(ADataGrid.OnSetEditText) then
              begin
                ADataGrid.OnSetEditText(ADataGrid, Ord(ColIndex), RowIndex,
                  ADataGrid.Cells[Ord(ColIndex), RowIndex]);
              end;
            end;
          end;
      else
        Assert(False);
      end;
    end;
    for ColIndex2 := Ord(EndCol) + 1 to ADataGrid.ColCount - 1 do
    begin
      if ADataGrid.Cells[ColIndex2, RowIndex] = '' then
      begin
        ADataGrid.Cells[ColIndex2, RowIndex] :=
          ADataGrid.Columns[ColIndex2].PickList[1];
      end;
    end;
  end;
end;

function TfrmMODFLOW.GetInstanceArrayCount(const ParameterCount: integer;
  const DataGrid: TDataGrid): integer;
var
  RowLimit: integer;
  RowIndex: integer;
  InstanceCount: integer;
  Supplement: integer;
begin
  result := 0;
  RowLimit := Min(ParameterCount, DataGrid.RowCount - 1);
  InstanceCount := 1;
  for RowIndex := 1 to RowLimit do
  begin
    try
      if DataGrid.Cells[4, RowIndex] = '' then
      begin
        InstanceCount := 1;
      end
      else
      begin
        InstanceCount := StrToInt(DataGrid.Cells[4, RowIndex]);
      end;
      if InstanceCount = 0 then
      begin
        InstanceCount := 1;
      end;
    except on EConvertError do
      begin
        InstanceCount := 1;
      end;
    end;
    result := result + InstanceCount;
  end;
  Supplement := (ParameterCount - (DataGrid.RowCount - 1));
  if Supplement > 0 then
  begin
    result := result + Supplement;
  end
end;

procedure TfrmMODFLOW.adeRCHParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
  ParamInstanceCount: integer;
begin
  inherited;
  dg3dRCHParameterClusters.Enabled := True;
  ParameterCount := StrToInt(adeRCHParamCount.Text);
  btnDeleteRCH_Parameter.Enabled := ParameterCount > 0;

  ParamInstanceCount := GetInstanceArrayCount(ParameterCount, dgRCHParametersN);
  sg3dRCHParamInstances.GridCount := ParameterCount;
  if ParamInstanceCount > dg3dRCHParameterClusters.PageCount then
  begin
    for Index := dg3dRCHParameterClusters.PageCount + 1 to ParamInstanceCount do
    begin
      addParamPage(dg3dRCHParameterClusters);
    end;
  end
  else if ParamInstanceCount < dg3dRCHParameterClusters.PageCount then
  begin
    for Index := dg3dRCHParameterClusters.PageCount - 1 downto ParamInstanceCount
      do
    begin
      dg3dRCHParameterClusters.RemoveGrid(Index);
    end;
  end;

  InitializeDataGrid(dgRCHParametersN, ParameterCount);

  InitializeMultParamPickLists(dg3dRCHParameterClusters);
  InitializeZoneParamPickLists(dg3dRCHParameterClusters);

end;

procedure TfrmMODFLOW.adeEVTParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
  ParamInstanceCount: integer;
begin
  inherited;
  dg3dEVTParameterClusters.Enabled := True;
  ParameterCount := StrToInt(adeEVTParamCount.Text);
  btnDeleteEVT_Parameter.Enabled := ParameterCount > 0;

  ParamInstanceCount := GetInstanceArrayCount(ParameterCount, dgEVTParametersN);
  sg3dEVTParamInstances.GridCount := ParameterCount;

  if ParamInstanceCount > dg3dEVTParameterClusters.PageCount then
  begin
    for Index := dg3dEVTParameterClusters.PageCount + 1 to ParamInstanceCount do
    begin
      addParamPage(dg3dEVTParameterClusters);
    end;
  end
  else if ParamInstanceCount < dg3dEVTParameterClusters.PageCount then
  begin
    for Index := dg3dEVTParameterClusters.PageCount - 1 downto ParamInstanceCount
      do
    begin
      dg3dEVTParameterClusters.RemoveGrid(Index);
    end;
  end;

  InitializeDataGrid(dgEVTParametersN, ParameterCount);

  InitializeMultParamPickLists(dg3dEVTParameterClusters);
  InitializeZoneParamPickLists(dg3dEVTParameterClusters);

end;

procedure TfrmMODFLOW.FixParameterNames;
var
  Index: integer;
  ParamNames: TStringList;
  CanSelect: Boolean;
  ParameterDataGridList: TList;
  dgIndex: integer;
  ADataGrid: TDataGrid;
begin
  ParameterDataGridList := TList.Create;
  try
    ParameterDataGridList.Add(dgLPFParameters);
    ParameterDataGridList.Add(dgHUFParameters);
    ParameterDataGridList.Add(dgRCHParametersN);
    ParameterDataGridList.Add(dgEVTParametersN);
    ParameterDataGridList.Add(dgETSParametersN);
    ParameterDataGridList.Add(dgRIVParametersN);
    ParameterDataGridList.Add(dgWELParametersN);
    ParameterDataGridList.Add(dgDRNParametersN);
    ParameterDataGridList.Add(dgDRTParametersN);
    ParameterDataGridList.Add(dgGHBParametersN);
    ParameterDataGridList.Add(dgHFBParameters);
    ParameterDataGridList.Add(dgSFRParametersN);
    ParameterDataGridList.Add(dgSTRParametersN);
    ParameterDataGridList.Add(dgCHDParameters);
    for dgIndex := 0 to ParameterDataGridList.Count - 1 do
    begin
      ADataGrid := ParameterDataGridList[dgIndex];
      for Index := 1 to ADataGrid.RowCount - 1 do
      begin
        if Assigned(ADataGrid.OnSelectCell) then
        begin
          ADataGrid.OnSelectCell(ADataGrid, 0, Index, CanSelect);
        end;
        ADataGrid.Cells[0, Index] := FixModflowName(ADataGrid.Cells[0, Index]);
        if Assigned(ADataGrid.OnSetEditText) then
        begin
          ADataGrid.OnSetEditText(ADataGrid, 0, Index, ADataGrid.Cells[0,
            Index]);
        end;
      end;
    end;

    ParamNames := TStringList.Create;
    try
      for dgIndex := 0 to ParameterDataGridList.Count - 1 do
      begin
        ADataGrid := ParameterDataGridList[dgIndex];
        for Index := 1 to ADataGrid.RowCount - 1 do
        begin
          while ParamNames.IndexOf(UpperCase(ADataGrid.Cells[0, Index])) > -1 do
          begin
            if Assigned(ADataGrid.OnSelectCell) then
            begin
              ADataGrid.OnSelectCell(ADataGrid, 0, Index, CanSelect);
            end;
            ADataGrid.Cells[0, Index] := ADataGrid.Cells[0, Index] + '1';
            if Assigned(ADataGrid.OnSetEditText) then
            begin
              ADataGrid.OnSetEditText(ADataGrid, 0, Index, ADataGrid.Cells[0,
                Index]);
            end;
          end;
          ParamNames.Add(UpperCase(ADataGrid.Cells[0, Index]));
          if Assigned(ADataGrid.OnSelectCell) then
          begin
            ADataGrid.OnSelectCell(ADataGrid, 0, Index, CanSelect);
          end;
          ADataGrid.Cells[0, Index] := FixModflowName(ADataGrid.Cells[0,
            Index]);
          if Assigned(ADataGrid.OnSetEditText) then
          begin
            ADataGrid.OnSetEditText(ADataGrid, 0, Index, ADataGrid.Cells[0,
              Index]);
          end;
        end;
      end;

    finally
      ParamNames.Free;
    end;
  finally
    ParameterDataGridList.Free;
  end;

end;

function TfrmMODFLOW.GetMultiplierCount: integer;
var
  Index: integer;
begin
  inherited;
  result := 0;
  for Index := 1 to dgMultiplier.RowCount - 1 do
  begin
    if dgMultiplier.Cells[2, Index] = dgMultiplier.Columns[2].PickList[0] then
    begin
      inc(result);
    end;
  end;
end;

procedure TfrmMODFLOW.adeMultCountEnter(Sender: TObject);
begin
  inherited;
  OldMultiplierCount := GetMultiplierCount;
end;

function TfrmMODFLOW.AnisotropyUsed(UnitNumber: integer): boolean;
begin
  inherited;
  result := (dgGeol.Cells[Ord(nuiSpecAnis), UnitNumber]
    = dgGeol.Columns[Ord(nuiSpecAnis)].Picklist.Strings[1])
  and (rgFlowPackage.ItemIndex = 1);
end;

procedure TfrmMODFLOW.adeRIVParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeRIVParamCount.Text);
  btnDeleteRIV_Parameter.Enabled := ParameterCount > 0;

  sg3dRIVParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgRIVParametersN, ParameterCount);

end;

procedure TfrmMODFLOW.adeWELParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeWELParamCount.Text);
  btnDeleteWEL_Parameter.Enabled := ParameterCount > 0;

  sg3dWelParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgWELParametersN, ParameterCount);

end;

procedure TfrmMODFLOW.EnablecbAreaWellContour;
begin
  cbAreaWellContour.Enabled := not cbAltWel.Checked and cbWEL.Checked and cbUseAreaWells.Checked;
  if cbAltWel.Enabled and cbAltWel.Checked and not Loading and not Cancelling then
  begin
    cbAreaWellContour.Checked := False;
  end;
end;

procedure TfrmMODFLOW.cbAltWelClick(Sender: TObject);
begin
  inherited;
  EnablecbAreaWellContour;
  if cbAreaWellContour.Enabled and not Loading and not Cancelling then
  begin
    cbAreaWellContour.Checked := True;
  end;


  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridWellParamType,
    ModflowTypes.GetMFGridWellParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.adeDRNParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeDRNParamCount.Text);
  btnDeleteDRN_Parameter.Enabled := ParameterCount > 0;

  sg3dDRNParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgDRNParametersN, ParameterCount);

end;

procedure TfrmMODFLOW.adeGHBParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeGHBParamCount.Text);
  btnDeleteGHB_Parameter.Enabled := ParameterCount > 0;
  sg3dGHBParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgGHBParametersN, ParameterCount);

end;

procedure TfrmMODFLOW.adeHFBParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeHFBParamCount.Text);
  btnDeleteHFB_Parameter.Enabled := ParameterCount > 0;

  InitializeDataGrid(dgHFBParameters, ParameterCount);
end;

procedure TfrmMODFLOW.dgParameterNamesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  NewValue: string;
  Position, RowIndex: integer;
  InstanceCount: integer;
  Code: integer;
  ADataGrid: TDataGrid;
  Instances: TRBWStringGrid3d;
  AStringGrid: TStringGrid;
  AdjustCount: Boolean;
begin
  inherited;
  if ARow > 0 then
  begin
    NewValue := Value;
    if (Sender <> dgHFBParameters) then
    begin
      Instances := GetParmInstanceGrid(Sender);
    end
    else
    begin
      Instances := nil;
    end;
    if (ACol = 0) then
    begin
      // The user has editted the parameter name.
      if Length(NewValue) > 10 then
      begin
        //Test of the name is too long.
        // Shorten it if it is too long.
        NewValue := Copy(NewValue, 1, 10);
        Beep;
        (Sender as TDataGrid).Cells[ACol, ARow] := NewValue;
      end;

      // make sure there are enough pages in the Instance grid.
      if Instances <> nil then
      begin
        if Instances.GridCount < ARow then
        begin
          Instances.GridCount := ARow;
        end;
        Instances.Pages[ARow - 1].Caption := NewValue;
      end;

      // see if the old parameter name was in the Sensitivity
      // grid.  If so, update it. If not, add it.
      Position :=
        dgSensitivity.Columns[1].PickList.IndexOf(OldParamNames[ARow]);
      if Position > -1 then
      begin
        dgSensitivity.Columns[1].PickList[Position] := NewValue;
      end
      else
      begin
        if dgSensitivity.Columns[1].PickList.IndexOf(NewValue) < 0 then
        begin
          // sensitivity analysis and parameter estimation
          // are not allowed with SFR parameters.
          if Sender <> dgSFRParametersN then
          begin
            dgSensitivity.Columns[1].PickList.Add(NewValue);
          end;
        end;
      end;
      SortParamNames;
      if not loading and not cancelling and (OldParamNames[ARow] <> NewValue)
        then
      begin
        for RowIndex := 1 to dgSensitivity.RowCount - 1 do
        begin
          if dgSensitivity.Cells[1, RowIndex] = OldParamNames[ARow] then
          begin
            dgSensitivity.Cells[1, RowIndex] := NewValue;
          end;
        end;
      end;

      Position :=
        dgParamEstCovNames.Columns[0].PickList.IndexOf(OldParamNames[ARow]);
      if Position > -1 then
      begin
        dgParamEstCovNames.Columns[0].PickList[Position] := NewValue;
      end
      else
      begin
        if dgParamEstCovNames.Columns[0].PickList.IndexOf(NewValue) < 0 then
        begin
          // sensitivity analysis and parameter estimation
          // are not allowed with SFR parameters.
          if Sender <> dgSFRParametersN then
          begin
            dgParamEstCovNames.Columns[0].PickList.Add(NewValue);
          end;
        end;
      end;
      if not loading and not cancelling and (OldParamNames[ARow] <> NewValue)
        then
      begin
        for RowIndex := 1 to dgParamEstCovNames.RowCount - 1 do
        begin
          if dgParamEstCovNames.Cells[0, RowIndex] = OldParamNames[ARow] then
          begin
            dgParamEstCovNames.Cells[0, RowIndex] := NewValue;
          end;
        end;
      end;

      if not loading and not cancelling and (OldParamNames[ARow] <> NewValue)
        and ((Sender = dgLPFParameters)
        or (Sender = dgHUFParameters)
        or (Sender = dgEVTParametersN)
        or (Sender = dgETSParametersN)) then
      begin
        for RowIndex := 1 to dgNegParam.RowCount - 1 do
        begin
          if dgNegParam.Cells[0, RowIndex] = OldParamNames[ARow] then
          begin
            dgNegParam.Cells[0, RowIndex] := NewValue;
          end;
        end;
      end;
    end
    else if (ACol = 3) then // Column 3 not present for dgHFBParameters
    begin
      Assert(Sender <> dgHFBParameters);

      if Trim(NewValue) <> '' then
      begin
        Val(NewValue, InstanceCount, Code);
        // check for errors and fix
        if Code > 0 then
        begin
          NewValue := Copy(NewValue, 1, Code - 1);
          ADataGrid := Sender as TDataGrid;
          ADataGrid.Cells[ACol, ARow] := NewValue;
          dgParameterNamesSetEditText(Sender, ACol, Arow, NewValue);
          Exit;
        end;

        if InstanceCount < 0 then
        begin
          NewValue := '0';
          ADataGrid := Sender as TDataGrid;
          ADataGrid.Cells[ACol, ARow] := NewValue;
          dgParameterNamesSetEditText(Sender, ACol, Arow, NewValue);
          Exit;
        end;
        if (InstanceCount > dgTime.RowCount - 1) and not loading
          and not cancelling then
        begin
          NewValue := IntToStr(dgTime.RowCount - 1);
          ADataGrid := Sender as TDataGrid;
          ADataGrid.Cells[ACol, ARow] := NewValue;
          dgParameterNamesSetEditText(Sender, ACol, Arow, NewValue);
          Exit;
        end;
        if InstanceCount > 1 then
        begin
          AdjustCount := False;
          if Sender = dgDRNParametersN then
          begin
            if comboDrnSteady.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgDRTParametersN then
          begin
            if comboDrtSteady.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgGHBParametersN then
          begin
            if comboGhbSteady.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgRIVParametersN then
          begin
            if comboRivSteady.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgSFRParametersN then
          begin
            if comboSFROption.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgSTRParametersN then
          begin
            if comboStreamOption.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgWELParametersN then
          begin
            if comboWelSteady.ItemIndex = 0 then
            begin
              AdjustCount := True;
            end;
          end
          else if Sender = dgCHDParameters then
          begin
            AdjustCount := False;
          end
          else
          begin
            Assert(False);
          end;
          if AdjustCount then
          begin
            NewValue := '1';
            ADataGrid := Sender as TDataGrid;
            ADataGrid.Cells[ACol, ARow] := NewValue;
            dgParameterNamesSetEditText(Sender, ACol, Arow, NewValue);
            Exit;
          end;
        end;

        AStringGrid := Instances.Grids[ARow - 1];

        if InstanceCount <= 1 then
        begin
          AStringGrid.RowCount := 0;
        end
        else
        begin
          AStringGrid.RowCount := InstanceCount + 1;
        end;
        if AStringGrid.RowCount > 1 then
        begin
          AStringGrid.FixedRows := 1;
          AStringGrid.Cells[0, 0] := 'Instance Name';
        end;
        for RowIndex := 1 to AStringGrid.RowCount - 1 do
        begin
          if AStringGrid.Cells[0, RowIndex] = '' then
          begin
            AStringGrid.Cells[0, RowIndex] := 'Inst' + IntToStr(RowIndex);
          end;
        end;
        if Assigned(AStringGrid.OnSetEditText) and (AStringGrid.RowCount > 1)
          then
        begin
          AStringGrid.OnSetEditText(AStringGrid, 0, AStringGrid.RowCount - 1,
            AStringGrid.Cells[0, AStringGrid.RowCount - 1])
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.cbHeadObservationsClick(Sender: TObject);
begin
  inherited;
  adeHeadObsLayerCount.Enabled := cbHeadObservations.Checked;
  adeHeadObsErrMult.Enabled := cbHeadObservations.Checked
    or cbWeightedHeadObservations.Checked;
  adeObsHeadCount.Enabled := cbHeadObservations.Checked
    or cbWeightedHeadObservations.Checked;
  if cbHeadObservations.Checked then
  begin
    if StrToInt(adeHeadObsLayerCount.Text) = 0 then
    begin
      adeHeadObsLayerCount.Text := '1';
      adeHeadObsLayerCountExit(Sender);
      adeHeadObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeHeadObsLayerCount.Min := 0;
    adeHeadObsLayerCount.Text := '0';
    adeHeadObsLayerCountExit(Sender);
  end;
end;

procedure TfrmMODFLOW.cbWeightedHeadObservationsClick(Sender: TObject);
begin
  inherited;
  adeWeightedHeadObsLayerCount.Enabled := cbWeightedHeadObservations.Checked;
  adeHeadObsErrMult.Enabled := cbHeadObservations.Checked
    or cbWeightedHeadObservations.Checked;
  adeObsHeadCount.Enabled := cbHeadObservations.Checked
    or cbWeightedHeadObservations.Checked;
  if cbWeightedHeadObservations.Checked then
  begin
    if StrToInt(adeWeightedHeadObsLayerCount.Text) = 0 then
    begin
      adeWeightedHeadObsLayerCount.Text := '1';
      adeWeightedHeadObsLayerCountExit(Sender);
      adeWeightedHeadObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeWeightedHeadObsLayerCount.Min := 0;
    adeWeightedHeadObsLayerCount.Text := '0';
    adeWeightedHeadObsLayerCountExit(Sender);
  end;

end;

procedure TfrmMODFLOW.adeHeadObsLayerCountExit(Sender: TObject);
var
  ObservationList: T_ANE_IndexedLayerList;
  OldObservationLayerCount, NewObservationLayerCount: integer;
  ALayer: T_ANE_MapsLayer;
  Index: integer;
begin
  inherited;
  ObservationList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgHeadObservations)];
  OldObservationLayerCount := ObservationList.NonDeletedLayerCount;
  NewObservationLayerCount := StrToInt(adeHeadObsLayerCount.Text);
  if NewObservationLayerCount <> OldObservationLayerCount then
  begin
    if NewObservationLayerCount > OldObservationLayerCount then
    begin
      for Index := 0 to ObservationList.Count - 1 do
      begin
        ALayer := ObservationList.Items[Index];
        if Index < NewObservationLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end
    else
    begin
      for Index := ObservationList.Count - 1 downto 0 do
      begin
        ALayer := ObservationList.Items[Index];
        if Index < NewObservationLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end;

    for Index := OldObservationLayerCount to NewObservationLayerCount - 1 do
    begin
      ModflowTypes.GetMFHeadObservationsLayerType.Create(ObservationList, -1);
    end;

    UpdateUseObsList(clbObservationLayers, OldObservationLayerCount, NewObservationLayerCount);
  end;

end;

procedure TfrmMODFLOW.adeWeightedHeadObsLayerCountExit(Sender: TObject);
var
  WeightedObservationList: T_ANE_IndexedLayerList;
  OldObservationLayerCount, NewObservationLayerCount: integer;
  ALayer: T_ANE_MapsLayer;
  Index: integer;
begin
  inherited;
  WeightedObservationList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgWeightedHeadObservations)];
  OldObservationLayerCount := WeightedObservationList.NonDeletedLayerCount;
  NewObservationLayerCount := StrToInt(adeWeightedHeadObsLayerCount.Text);
  if NewObservationLayerCount <> OldObservationLayerCount then
  begin
    if NewObservationLayerCount > OldObservationLayerCount then
    begin
      for Index := 0 to WeightedObservationList.Count - 1 do
      begin
        ALayer := WeightedObservationList.Items[Index];
        if Index < NewObservationLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end
    else
    begin
      for Index := WeightedObservationList.Count - 1 downto 0 do
      begin
        ALayer := WeightedObservationList.Items[Index];
        if Index < NewObservationLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end;

    for Index := OldObservationLayerCount to NewObservationLayerCount - 1 do
    begin
      ModflowTypes.GetMFWeightedHeadObservationsLayerType.Create(WeightedObservationList, -1);
    end;
    
    UpdateUseObsList(clbWeightedObservationLayers, OldObservationLayerCount, NewObservationLayerCount);
  end;

end;

procedure TfrmMODFLOW.AddHeadObsTimes(NewHeadObsTimeCount: integer;
  ObservationList: T_ANE_IndexedLayerList);
var
  ALayer: TIndexedInfoLayer;
  LayerIndex, ParamIndex: integer;
  ParameterList: T_ANE_IndexedParameterList;
begin
  for LayerIndex := 0 to ObservationList.Count - 1 do
  begin
    ALayer := ObservationList.Items[LayerIndex] as TIndexedInfoLayer;
    if NewHeadObsTimeCount > OldHeadObsTimeCount then
    begin
      for ParamIndex := 0 to ALayer.IndexedParamList1.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamList1.Items[ParamIndex];
        if ParamIndex < NewHeadObsTimeCount + 1 then
        begin
          ParameterList.UnDeleteSelf;
        end
        else
        begin
          ParameterList.DeleteSelf;
        end;
      end;
    end
    else
    begin
      for ParamIndex := ALayer.IndexedParamList1.Count - 1 downto 0 do
      begin
        ParameterList := ALayer.IndexedParamList1.Items[ParamIndex];
        if ParamIndex < NewHeadObsTimeCount then
        begin
          ParameterList.UnDeleteSelf;
        end
        else
        begin
          ParameterList.DeleteSelf;
        end;
      end;
    end;

    for ParamIndex := OldHeadObsTimeCount to NewHeadObsTimeCount - 1 do
    begin
      ModflowTypes.GetMFHeadObservationParamListType.Create(ALayer.IndexedParamList1, -1);
    end;
  end;
end;

procedure TfrmMODFLOW.adeObsHeadCountExit(Sender: TObject);
var
  NewHeadObsTimeCount: integer;
  WeightedObservationList: T_ANE_IndexedLayerList;
  ObservationList: T_ANE_IndexedLayerList;
begin
  inherited;
  NewHeadObsTimeCount := StrToInt(adeObsHeadCount.Text);

  if NewHeadObsTimeCount <> OldHeadObsTimeCount then
  begin
    ObservationList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgHeadObservations)];
    AddHeadObsTimes(NewHeadObsTimeCount, ObservationList);

    WeightedObservationList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgWeightedHeadObservations)];
    AddHeadObsTimes(NewHeadObsTimeCount, WeightedObservationList);

  end;
end;

procedure TfrmMODFLOW.adeObsHeadCountEnter(Sender: TObject);
begin
  inherited;
  OldHeadObsTimeCount := StrToInt(adeObsHeadCount.Text);
end;

procedure TfrmMODFLOW.AddHeadObsWeights(NewUnitCount: integer);
var
  ALayer: TIndexedInfoLayer;
  LayerIndex, ParamIndex: integer;
  ParameterList: T_ANE_IndexedParameterList;
  WeightedObservationList: T_ANE_IndexedLayerList;
begin
  WeightedObservationList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgWeightedHeadObservations)];
  for LayerIndex := 0 to WeightedObservationList.Count - 1 do
  begin
    ALayer := WeightedObservationList.Items[LayerIndex] as TIndexedInfoLayer;
    if NewUnitCount > PrevNumUnits then
    begin
      for ParamIndex := 0 to ALayer.IndexedParamList0.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamList0.Items[ParamIndex];
        if ParamIndex < NewUnitCount + 1 then
        begin
          ParameterList.UnDeleteSelf;
        end
        else
        begin
          ParameterList.DeleteSelf;
        end;
      end;
    end
    else
    begin
      for ParamIndex := ALayer.IndexedParamList0.Count - 1 downto 0 do
      begin
        ParameterList := ALayer.IndexedParamList0.Items[ParamIndex];
        if ParamIndex < NewUnitCount then
        begin
          ParameterList.UnDeleteSelf;
        end
        else
        begin
          ParameterList.DeleteSelf;
        end;
      end;
    end;

    for ParamIndex := PrevNumUnits to NewUnitCount - 1 do
    begin
      ModflowTypes.GetMFWeightParamListType.Create(ALayer.IndexedParamList0,
        -1);
    end;
  end;
end;

procedure TfrmMODFLOW.DeleteHeadObsWeights(UnitIndex: integer);
var
  ALayer: TIndexedInfoLayer;
  LayerIndex: integer;
  ParameterList: T_ANE_IndexedParameterList;
  WeightedObservationList: T_ANE_IndexedLayerList;
begin
  WeightedObservationList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgWeightedHeadObservations)];
  for LayerIndex := 0 to WeightedObservationList.Count - 1 do
  begin
    ALayer := WeightedObservationList.Items[LayerIndex] as TIndexedInfoLayer;
    ParameterList := ALayer.IndexedParamList0.
      GetNonDeletedIndParameterListByIndex(UnitIndex - 1);
    if ParameterList <> nil then
    begin
      ParameterList.DeleteSelf;
    end;
  end;
end;

procedure TfrmMODFLOW.InsertHeadObsWeights(UnitIndex: integer);
var
  ALayer: TIndexedInfoLayer;
  LayerIndex: integer;
  WeightedObservationList: T_ANE_IndexedLayerList;
  Position: integer;
begin
  WeightedObservationList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgWeightedHeadObservations)];
  for LayerIndex := 0 to WeightedObservationList.Count - 1 do
  begin
    ALayer := WeightedObservationList.Items[LayerIndex] as TIndexedInfoLayer;
    Position := ALayer.IndexedParamList0.
      GetNonDeletedIndParameterListIndexByIndex(UnitIndex - 1);
    ModflowTypes.GetMFWeightParamListType.Create(ALayer.IndexedParamList0,
      Position);
  end;
end;

procedure TfrmMODFLOW.AddFluxLayers(NewLayerCount: integer;
  FluxList: T_ANE_IndexedLayerList;
  FluxLayerClass: TIndexedInfoLayerClass);
var
  OldLayerCount: integer;
  ALayer: T_ANE_MapsLayer;
  Index: integer;
begin
  inherited;
  OldLayerCount := FluxList.NonDeletedLayerCount;
  if NewLayerCount <> OldLayerCount then
  begin
    if NewLayerCount > OldLayerCount then
    begin
      for Index := 0 to FluxList.Count - 1 do
      begin
        ALayer := FluxList.Items[Index];
        if Index < NewLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end
    else
    begin
      for Index := FluxList.Count - 1 downto 0 do
      begin
        ALayer := FluxList.Items[Index];
        if Index < NewLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end;

    for Index := OldLayerCount to NewLayerCount - 1 do
    begin
      FluxLayerClass.Create(FluxList, -1);
    end;
  end;

end;

procedure TfrmMODFLOW.adeGHBObsLayerCountExit(Sender: TObject);
var
  GHBFluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  GHBFluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgGHBFlux)];
  NewLayerCount := StrToInt(adeGHBObsLayerCount.Text);
  OldLayerCount := GHBFluxList.NonDeletedLayerCount;
  AddFluxLayers(NewLayerCount, GHBFluxList,
    ModflowTypes.GetMFGHBFluxObservationsLayerType);
  UpdateUseObsList(clbGHB_Observations, OldLayerCount, NewLayerCount);
end;

procedure TfrmMODFLOW.adeDRNObsLayerCountExit(Sender: TObject);
var
  DrainFluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  DrainFluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgDrainFlux)];
  NewLayerCount := StrToInt(adeDRNObsLayerCount.Text);
  OldLayerCount := DrainFluxList.NonDeletedLayerCount;
  AddFluxLayers(NewLayerCount, DrainFluxList,
    ModflowTypes.GetMFDrainFluxObservationsLayerType);
  UpdateUseObsList(clbDrainObservations, OldLayerCount, NewLayerCount);
end;

procedure TfrmMODFLOW.adeRIVObsLayerCountExit(Sender: TObject);
var
  RiverFluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  RiverFluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgRiverFlux)];
  NewLayerCount := StrToInt(adeRIVObsLayerCount.Text);
  OldLayerCount := RiverFluxList.NonDeletedLayerCount;
  AddFluxLayers(NewLayerCount, RiverFluxList,
    ModflowTypes.GetMFRiverFluxObservationsLayerType);
  UpdateUseObsList(clbRiverObservations, OldLayerCount, NewLayerCount);
end;

procedure TfrmMODFLOW.AddFluxObsTimes(NewFluxObsTimeCount, OldFluxObsTimeCount
  : integer; ObservationList: T_ANE_IndexedLayerList;
  ParameterListClass: T_ANE_IndexedParameterListClass);
var
  ALayer: TIndexedInfoLayer;
  LayerIndex, ParamIndex: integer;
  ParameterList: T_ANE_IndexedParameterList;
begin
  for LayerIndex := 0 to ObservationList.Count - 1 do
  begin
    ALayer := ObservationList.Items[LayerIndex] as TIndexedInfoLayer;
    if NewFluxObsTimeCount > OldFluxObsTimeCount then
    begin
      for ParamIndex := 0 to ALayer.IndexedParamList1.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamList1.Items[ParamIndex];
        if ParamIndex < NewFluxObsTimeCount + 1 then
        begin
          ParameterList.UnDeleteSelf;
        end
        else
        begin
          ParameterList.DeleteSelf;
        end;
      end;
    end
    else
    begin
      for ParamIndex := ALayer.IndexedParamList1.Count - 1 downto 0 do
      begin
        ParameterList := ALayer.IndexedParamList1.Items[ParamIndex];
        if ParamIndex < NewFluxObsTimeCount then
        begin
          ParameterList.UnDeleteSelf;
        end
        else
        begin
          ParameterList.DeleteSelf;
        end;
      end;
    end;

    for ParamIndex := OldFluxObsTimeCount to NewFluxObsTimeCount - 1 do
    begin
      ParameterListClass.Create(ALayer.IndexedParamList1, -1);
    end;
  end;
end;

procedure TfrmMODFLOW.adeObsGHBTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldGHBObsTimeCount := StrToInt(adeObsGHBTimeCount.Text);
end;

procedure TfrmMODFLOW.adeObsDRNTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldDrainObsTimeCount := StrToInt(adeObsDRNTimeCount.Text);

end;

procedure TfrmMODFLOW.adeObsRIVTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldRiverObsTimeCount := StrToInt(adeObsRIVTimeCount.Text);

end;

procedure TfrmMODFLOW.adeObsGHBTimeCountExit(Sender: TObject);
var
  NewFluxTimeCount: integer;
  FluxList: T_ANE_IndexedLayerList;
begin
  inherited;
  NewFluxTimeCount := StrToInt(adeObsGHBTimeCount.Text);
  if NewFluxTimeCount <> OldGHBObsTimeCount then
  begin
    FluxList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgGHBFlux)];
    AddFluxObsTimes(NewFluxTimeCount, OldGHBObsTimeCount, FluxList,
      ModflowTypes.GetMFGHBFluxObservationParamListType);
  end;
end;

procedure TfrmMODFLOW.adeObsDRNTimeCountExit(Sender: TObject);
var
  NewFluxTimeCount: integer;
  FluxList: T_ANE_IndexedLayerList;
begin
  inherited;
  NewFluxTimeCount := StrToInt(adeObsDRNTimeCount.Text);
  if NewFluxTimeCount <> OldDrainObsTimeCount then
  begin
    FluxList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgDrainFlux)];
    AddFluxObsTimes(NewFluxTimeCount, OldDrainObsTimeCount, FluxList,
      ModflowTypes.GetMFDrainFluxObservationParamListType);
  end;
end;

procedure TfrmMODFLOW.adeObsRIVTimeCountExit(Sender: TObject);
var
  NewFluxTimeCount: integer;
  FluxList: T_ANE_IndexedLayerList;
begin
  inherited;
  NewFluxTimeCount := StrToInt(adeObsRIVTimeCount.Text);
  if NewFluxTimeCount <> OldRiverObsTimeCount then
  begin
    FluxList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgRiverFlux)];
    AddFluxObsTimes(NewFluxTimeCount, OldRiverObsTimeCount, FluxList,
      ModflowTypes.GetMFRiverFluxObservationParamListType);
  end;
end;

procedure TfrmMODFLOW.cbGHBObservationsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbGHBObservations.Checked and cbGHB.Checked;
  adeGHBObsErrMult.Enabled := ShouldEnable;
  adeGHBObsLayerCount.Enabled := ShouldEnable;
  adeObsGHBTimeCount.Enabled := ShouldEnable;
  cbSpecifyGHBCovariances.Enabled := ShouldEnable;
  if ShouldEnable then
  begin
    if StrToInt(adeGHBObsLayerCount.Text) = 0 then
    begin
      adeGHBObsLayerCount.Text := '1';
      adeGHBObsLayerCountExit(Sender);
      adeGHBObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeGHBObsLayerCount.Min := 0;
    adeGHBObsLayerCount.Text := '0';
    adeGHBObsLayerCountExit(Sender);
  end;
  cbSpecifyGHBCovariancesClick(Sender);
end;

procedure TfrmMODFLOW.cbGwmHeadVariablesClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFGwmHeadStateLayerType, cb_GWM.Checked
    and cbGwmHeadVariables.Checked);
end;

procedure TfrmMODFLOW.cbGwmStreamVariablesClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFGwmStreamStateLayerType, cb_GWM.Checked
    and cbGwmStreamVariables.Checked and (cbSTR.Checked or cbSFR.Checked));
end;

procedure TfrmMODFLOW.cbDRNObservationsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbDRNObservations.Checked and cbDRN.Checked;
  adeDrnObsErrMult.Enabled := ShouldEnable;
  adeDRNObsLayerCount.Enabled := ShouldEnable;
  adeObsDRNTimeCount.Enabled := ShouldEnable;
  cbSpecifyDRNCovariances.Enabled := ShouldEnable;
  if ShouldEnable then
  begin
    if StrToInt(adeDRNObsLayerCount.Text) = 0 then
    begin
      adeDRNObsLayerCount.Text := '1';
      adeDRNObsLayerCountExit(Sender);
      adeDRNObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeDRNObsLayerCount.Min := 0;
    adeDRNObsLayerCount.Text := '0';
    adeDRNObsLayerCountExit(Sender);
  end;
  cbSpecifyDRNCovariancesClick(Sender);
end;

procedure TfrmMODFLOW.cbRIVObservationsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbRIVObservations.Checked and cbRIV.Checked;
  adeRivObsErrMult.Enabled := ShouldEnable;
  adeRIVObsLayerCount.Enabled := ShouldEnable;
  adeObsRIVTimeCount.Enabled := ShouldEnable;
  cbSpecifyRiverCovariances.Enabled := ShouldEnable;
  if ShouldEnable then
  begin
    if StrToInt(adeRIVObsLayerCount.Text) = 0 then
    begin
      adeRIVObsLayerCount.Text := '1';
      adeRIVObsLayerCountExit(Sender);
      adeRIVObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeRIVObsLayerCount.Min := 0;
    adeRIVObsLayerCount.Text := '0';
    adeRIVObsLayerCountExit(Sender);
  end;
  cbSpecifyRiverCovariancesClick(Sender);
end;

procedure TfrmMODFLOW.adeHeadFluxObsLayerCountExit(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgSpecifiedHead)];
  OldLayerCount := FluxList.NonDeletedLayerCount;
  NewLayerCount := StrToInt(adeHeadFluxObsLayerCount.Text);
  AddFluxLayers(NewLayerCount, FluxList,
    ModflowTypes.GetMFSpecifiedHeadFluxObservationsLayerType);

  UpdateUseObsList(clbPrescribeHeadFlux, OldLayerCount, NewLayerCount);

end;

procedure TfrmMODFLOW.adeObsHeadFluxTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldHeadFluxObsTimeCount := StrToInt(adeObsHeadFluxTimeCount.Text);
end;

procedure TfrmMODFLOW.adeObsHeadFluxTimeCountExit(Sender: TObject);
var
  NewFluxTimeCount: integer;
  FluxList: T_ANE_IndexedLayerList;
begin
  inherited;
  NewFluxTimeCount := StrToInt(adeObsHeadFluxTimeCount.Text);
  if NewFluxTimeCount <> OldHeadFluxObsTimeCount then
  begin
    FluxList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgSpecifiedHead)];
    AddFluxObsTimes(NewFluxTimeCount, OldHeadFluxObsTimeCount, FluxList,
      ModflowTypes.GetMFSpecifiedHeadFluxObservationParamListType);
  end;
end;

procedure TfrmMODFLOW.cbHeadFluxObservationsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbHeadFluxObservations.Checked;
  adeHeadFluxObsErrMult.Enabled := ShouldEnable;
  adeHeadFluxObsLayerCount.Enabled := ShouldEnable;
  adeObsHeadFluxTimeCount.Enabled := ShouldEnable;
  cbSpecifyHeadFluxCovariances.Enabled := ShouldEnable;
  if ShouldEnable then
  begin
    if StrToInt(adeHeadFluxObsLayerCount.Text) = 0 then
    begin
      adeHeadFluxObsLayerCount.Text := '1';
      adeHeadFluxObsLayerCountExit(Sender);
      adeHeadFluxObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeHeadFluxObsLayerCount.Min := 0;
    adeHeadFluxObsLayerCount.Text := '0';
    adeHeadFluxObsLayerCountExit(Sender);
  end;
  cbSpecifyHeadFluxCovariancesClick(Sender);
end;

procedure TfrmMODFLOW.ChangeObservationVarianceGridSize(Limit: integer;
  DataGrid: TDataGrid);
var
  RowIndex, ColIndex: integer;
  AColumn: TColumn;
begin
  inherited;
  DataGrid.RowCount := Limit;
  DataGrid.ColCount := Limit;
  for ColIndex := 1 to Limit - 1 do
  begin
    AColumn := DataGrid.Columns[ColIndex];
    AColumn.Format := cfNumber;
    AColumn.Title.Caption := IntToStr(ColIndex);
  end;
  for RowIndex := 1 to Limit - 1 do
  begin
    DataGrid.Cells[0, RowIndex] := IntToStr(RowIndex);
  end;
  for ColIndex := 1 to Limit - 1 do
  begin
    for RowIndex := 1 to Limit - 1 do
    begin
      if DataGrid.Cells[ColIndex, RowIndex] = '' then
      begin
        if ColIndex = RowIndex then
        begin
          DataGrid.Cells[ColIndex, RowIndex] := '1';
        end
        else
        begin
          DataGrid.Cells[ColIndex, RowIndex] := '0';
        end;
      end;
    end;

  end;
end;

procedure TfrmMODFLOW.adeGHBObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeGHBObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgGHBObsBoundCovariances);
end;

procedure TfrmMODFLOW.dgGHBObsBoundCovariancesSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  ADataGrid: TDataGrid;
begin
  inherited;
  ADataGrid := Sender as TDataGrid;
  if (ACol > 0) and (ARow > 0) and (ACol <> ARow) then
  begin
    ADataGrid.Cells[ARow, ACol] := Value;
  end;
end;

procedure TfrmMODFLOW.adeDRNObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeDRNObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgDRNObsBoundCovariances);
end;

procedure TfrmMODFLOW.adeRIVObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeRIVObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgRIVObsBoundCovariances);
end;

procedure TfrmMODFLOW.adeHeadFluxObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeHeadFluxObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgHeadFluxObsBoundCovariances);
end;

procedure TfrmMODFLOW.cbSpecifyGHBCovariancesClick(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbSpecifyGHBCovariances.Checked and cbGHB.Checked
    and cbGHBObservations.Checked;
  comboGHBObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboGHBObsPrintFormats);
  adeGHBObsBoundCount.Enabled := ShouldEnable;
  dgGHBObsBoundCovariances.Enabled := ShouldEnable;

  FluxList := MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgGHBFlux)];
  FluxList.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFGHBFluxObservationsLayerType,
    ModflowTypes.GetMFObservationNumberParamType,
    cbSpecifyGHBCovariances.Checked and cbGHB.Checked
    and cbGHBObservations.Checked);
end;

procedure TfrmMODFLOW.cbSpecifyDRNCovariancesClick(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbSpecifyDRNCovariances.Checked and cbDRN.Checked
    and cbDRNObservations.Checked;
  comboDrainObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboDrainObsPrintFormats);

  adeDRNObsBoundCount.Enabled := ShouldEnable;
  dgDRNObsBoundCovariances.Enabled := ShouldEnable;

  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgDrainFlux)];
  FluxList.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFDrainFluxObservationsLayerType,
    ModflowTypes.GetMFObservationNumberParamType,
    cbSpecifyDRNCovariances.Checked and cbDRN.Checked
    and cbDRNObservations.Checked);
end;

procedure TfrmMODFLOW.cbSpecifyRiverCovariancesClick(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbSpecifyRiverCovariances.Checked and cbRIV.Checked
    and cbRIVObservations.Checked;
  comboRiverObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboRiverObsPrintFormats);

  adeRIVObsBoundCount.Enabled := ShouldEnable;
  dgRIVObsBoundCovariances.Enabled := ShouldEnable;

  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgRiverFlux)];
  FluxList.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFRiverFluxObservationsLayerType,
    ModflowTypes.GetMFObservationNumberParamType,
    cbSpecifyRiverCovariances.Checked and cbRIV.Checked
    and cbRIVObservations.Checked);
end;

procedure TfrmMODFLOW.cbSpecifyHeadFluxCovariancesClick(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbSpecifyHeadFluxCovariances.Checked and
    cbHeadFluxObservations.Checked;
  comboHeadFluxObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboHeadFluxObsPrintFormats);

  adeHeadFluxObsBoundCount.Enabled := ShouldEnable;
  dgHeadFluxObsBoundCovariances.Enabled := ShouldEnable;

  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgSpecifiedHead)];
  FluxList.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFSpecifiedHeadFluxObservationsLayerType,
    ModflowTypes.GetMFObservationNumberParamType,
    cbSpecifyHeadFluxCovariances.Checked and cbHeadFluxObservations.Checked);
end;

procedure TfrmMODFLOW.cbObservationsClick(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  ActivateParametersTab;
  tabObservations.TabVisible := cbObservations.Checked;
  cbHeadObservations.Enabled := cbObservations.Checked;
  cbCreateObsOutput.Enabled := cbObservations.Checked;
  comboObservationScaling.Enabled := cbObservations.Checked;
  cbHeadObservations.Enabled := cbObservations.Checked;
  cbWeightedHeadObservations.Enabled := cbObservations.Checked;
  if tabObservations.TabVisible then
  begin
    for Index := 0 to PageControlObservations.PageCount - 1 do
    begin
      PageControlObservations.Pages[Index].HandleNeeded;
    end;

    tabRiverObservations.TabVisible := cbRIV.Checked;
    tabDrainObservations.TabVisible := cbDRN.Checked;

    tabDrtObservations.TabVisible := cbDRT.Checked;

    tabGHBObservations.TabVisible := cbGHB.Checked;
    tabStreamObservations.TabVisible := cbSTR.Checked;
    FreePageControlResources(PageControlObservations, Handle);
  end;

  cbHeadObservationsClick(Sender);
  cbWeightedHeadObservationsClick(Sender);
  if not cbObservations.Checked and not loading and not cancelling then
  begin
    cbParamEst.Checked := False;
    //    cbSensitivity.Checked := False;
  end;
  SetMode;

  // add or remove the porosity layers depending on
  // whether MOC3D or MODPATH are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCPorosityLayerType, PorosityUsed);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCPorosityParamType,
    PorosityUsed);

end;

procedure TfrmMODFLOW.adeSensitivityCountExit(Sender: TObject);
var
  OldCount, NewCount: integer;
  RowIndex, ColIndex: integer;
begin
  inherited;
  OldCount := dgSensitivity.RowCount - 1;
  NewCount := StrToInt(adeSensitivityCount.Text);
  btnRemoveSenParameter.Enabled := NewCount > 0;
  dgSensitivity.RowCount := NewCount + 1;
  if dgSensitivity.RowCount > 1 then
  begin
    dgSensitivity.FixedRows := 1;
  end;
  if not loading and not cancelling then
  begin
    for RowIndex := OldCount + 1 to dgSensitivity.RowCount - 1 do
    begin
      if RowIndex > 1 then
      begin
        // copy the prior row
        for ColIndex := 1 to dgSensitivity.ColCount - 1 do
        begin
          dgSensitivity.Cells[ColIndex, RowIndex] :=
            dgSensitivity.Cells[ColIndex, RowIndex - 1];
        end;
      end
      else
      begin
        // initialize the first row
        if dgSensitivity.Columns[1].PickList.Count > 0 then
        begin
          dgSensitivity.Cells[1, 1] := dgSensitivity.Columns[1].PickList[0];
          // parameter name
        end;
        dgSensitivity.Cells[2, 1] := dgSensitivity.Columns[2].PickList[1];
        // estimate parameter
        dgSensitivity.Cells[3, 1] := dgSensitivity.Columns[3].PickList[0];
        // log transform
        dgSensitivity.Cells[4, 1] := '0.5'; // starting value
        dgSensitivity.Cells[5, 1] := '0.0'; // lower reasonable limit
        dgSensitivity.Cells[6, 1] := '1.0'; // upper reasonable limit
        dgSensitivity.Cells[7, 1] := '1.0e-10'; // alternate scaling factor
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.SensitivityWarning;
var
  UnitIndex: integer;
  TransmisivityMethod: integer;
begin
  if rbMODFLOW2000.Checked and cbSensitivity.Checked
    and (rgFlowPackage.ItemIndex = 1) then
  begin
    for UnitIndex := 1 to dgGeol.RowCount - 1 do
    begin
      if dgGeol.Cells[Ord(nuiSim), UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        TransmisivityMethod := dgGeol.Columns[Ord(nuiTrans)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiTrans), UnitIndex]);
        if TransmisivityMethod <> 0 then
        begin
          Beep;
          MessageDlg('In the Sensitivity package, only harmonic averaging '
            + 'method can be used for calculating the interblock transmisvities. '
            + ' In geologic unit ' + IntToStr(UnitIndex) +
            ' you use a different '
            + 'method. You need to change this on the "Geology" tab.',
            mtError, [mbOK], 0);
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.SFR_Warning;
begin
  if not Loading and not Cancelling then
  begin
    if cbSensitivity.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked
      and cbSFRRetain.Checked then
    begin
      Beep;
      MessageDlg('Warning: When performing sensitivity analysis while the '
        + 'SFR package is active, you can not have any streams on any of the '
        + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
        + '[i], '
        + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
        + '[i], or '
        + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
        + '[i] layers.', mtInformation, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbSensitivityClick(Sender: TObject);
begin
  inherited;
  SubsidenceWarnings;
  SFR_Warning;
  tabSensitivity.TabVisible := cbSensitivity.Checked;
  adeSensitivityCount.Enabled := cbSensitivity.Checked;
  comboSensEst.Enabled := cbSensitivity.Checked;
  comboSensMemory.Enabled := cbSensitivity.Checked;
  rgSensPrint.Enabled := cbSensitivity.Checked and not cbParamEst.Checked;
  cbSensBinary.Enabled := cbSensitivity.Checked and not cbParamEst.Checked;
  cbSensPrint.Enabled := cbSensitivity.Checked and not cbParamEst.Checked;
  comboSensFormat.Enabled := cbSensitivity.Checked and cbSensPrint.Checked;
  dgSensitivity.Enabled := cbSensitivity.Checked;
  if not cbSensitivity.Checked and not loading and not cancelling then
  begin
    cbParamEst.Checked := False
  end;
  {  if cbSensitivity.Checked  and not loading and not cancelling then
    begin
      cbObservations.Checked := True;
    end; }
  dgSensitivityExit(Sender);
  SetMode;
  SensitivityWarning;
end;

function TfrmMODFLOW.CanSelectCell(ACol, ARow: Integer; AName: string): boolean;
begin
  result := not ((ACol = 2) and (ARow > 0) and cbSensitivity.Checked
    and (SensitivityNames.IndexOf(AName) > -1));
end;

function TfrmMODFLOW.GetParmInstanceGrid(const Sender: TObject):
  TRBWStringGrid3d;
begin
  if Sender = dgWELParametersN then
  begin
    result := sg3dWelParamInstances;
  end
  else if Sender = dgDRNParametersN then
  begin
    result := sg3dDRNParamInstances;
  end
  else if Sender = dgDRTParametersN then
  begin
    result := sg3dDRTParamInstances;
  end
  else if Sender = dgETSParametersN then
  begin
    result := sg3dETSParamInstances;
  end
  else if Sender = dgEVTParametersN then
  begin
    result := sg3dEVTParamInstances;
  end
  else if Sender = dgGHBParametersN then
  begin
    result := sg3dGHBParamInstances;
  end
  else if Sender = dgRCHParametersN then
  begin
    result := sg3dRCHParamInstances;
  end
  else if Sender = dgRIVParametersN then
  begin
    result := sg3dRIVParamInstances;
  end
  else if Sender = dgSFRParametersN then
  begin
    result := sg3dSFRParamInstances;
  end
  else if Sender = dgSTRParametersN then
  begin
    result := sg3dSTRParamInstances;
  end
  else if Sender = dgCHDParameters then
  begin
    result := sg3dCHDParamInstances;
  end

  else
  begin
    result := nil;
    Assert(False);
  end;
end;

function TfrmMODFLOW.GetParmClusterGrid(const Sender: TObject): TRBWDataGrid3d;
begin
  if Sender = dgETSParametersN then
  begin
    result := dg3dETSParameterClusters;
  end
  else if Sender = dgEVTParametersN then
  begin
    result := dg3dEVTParameterClusters;
  end
  else if Sender = dgRCHParametersN then
  begin
    result := dg3dRCHParameterClusters;
  end
  else if Sender = dgLPFParameters then
  begin
    result := dg3dLPFParameterClusters;
  end
  else if Sender = dgHUFParameters then
  begin
    result := dg3dHUFParameterClusters;
  end
  else if Sender = dgADVParameters then
  begin
    result := dg3dADVParameterClusters;
  end
  else
  begin
    result := nil;
  end;
end;

procedure TfrmMODFLOW.dgParametersSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  Instances: TRBWStringGrid3d;
  Clusters: TRBWDataGrid3d;
begin
  inherited;
  if ACol = 4 then
  begin
    LastInstanceCountStringList.Assign((Sender as TDataGrid).Cols[ACol]);
  end;
  CanSelect := (ARow > 0);
  if ACol = 0 then
  begin
    dgParametersEnter(Sender);
  end
  else if (ACol = 2) and (ARow > 0) and cbSensitivity.Checked then
  begin
    CanSelect := CanSelectCell(ACol, ARow, (Sender as TDataGrid).Cells[0,
      ARow]);
  end;

  if CanSelect
    and (Sender <> dgLPFParameters)
    and (Sender <> dgHUFParameters)
    and (Sender <> dgHFBParameters)
    and (Sender <> dgADVParameters) then
  begin
    Instances := GetParmInstanceGrid(Sender);
    if not Loading and not Cancelling then
    begin
      Instances.ActivePageIndex := ARow - 1;
    end;
  end;
  if CanSelect then
  begin
    Clusters := GetParmClusterGrid(Sender);
    if (Clusters <> nil) and not Loading and not Cancelling then
    begin
      if (Clusters = dg3dLPFParameterClusters)
        or (Clusters = dg3dHUFParameterClusters)
        or (Clusters = dg3dADVParameterClusters) then
      begin
        Clusters.ActivePageIndex := ARow - 1;
      end
      else
      begin
        Clusters.ActivePageIndex := GetPreviousInstances(ARow, (Sender as
          TDataGrid))
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.cbSensPrintClick(Sender: TObject);
begin
  inherited;
  comboSensFormat.Enabled := cbSensitivity.Checked and cbSensPrint.Checked and
    not cbParamEst.Checked;
  ;
  if not Loading and not Cancelling and (comboHeadPrintFreq.ItemIndex = 0) then
  begin
    Beep;
    MessageDlg('Sensitivity arrays are only printed when the heads are printed.  '
      + 'You have chosen to never print the heads.  This is being changed to '
      + 'printing the heads at the end of each stress period.',
      mtInformation, [mbOK], 0);
    comboHeadPrintFreq.ItemIndex := 2;
  end;

end;

procedure TfrmMODFLOW.dgParamEstCovNamesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  FloatValue: double;
  ADataGrid: TDataGrid;
begin
  inherited;
  if ACol = 0 then
  begin
    dgParamEstCovariance.Cells[0, ARow] := Value;
    dgParamEstCovariance.Columns[ARow].Title.Caption := Value;
  end
  else if ACol = 1 then
  begin
    if trim(Value) <> '' then
    begin
      FloatValue := InternationalStrToFloat(Value);
      if Round(FloatValue) <> FloatValue then
      begin
        ADataGrid := Sender as TDataGrid;
        ADataGrid.Cells[ACol, ARow] := IntToStr(Round(FloatValue));
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeParamEstCovNameCountExit(Sender: TObject);
var
  AColumn: TColumn;
  Index: integer;
  RowIndex, ColIndex: integer;
  ParamIndex: integer;
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeParamEstCovNameCount.Text);
  btnDeleteParamEstCovNames.Enabled := ParameterCount > 0;
  rgPriorInfoDataType.Enabled := ParameterCount > 0;

  if cbParamEst.Checked then
  begin
    for Index := 0 to pagecontrolParamEst.PageCount - 1 do
    begin
      pagecontrolParamEst.Pages[Index].HandleNeeded;
    end;

    tabParamEstCov.TabVisible := (ParameterCount > 0);
    FreePageControlResources(pagecontrolParamEst, Handle);
  end;

  dgParamEstCovNames.RowCount := ParameterCount + 1;
  for Index := 1 to dgParamEstCovNames.RowCount - 1 do
  begin
    if Trim(dgParamEstCovNames.Cells[1, Index]) = '' then
    begin
      dgParamEstCovNames.Cells[1, Index] := '1';
    end;
    if Trim(dgParamEstCovNames.Cells[2, Index]) = '' then
    begin
      dgParamEstCovNames.Cells[2, Index] := '1';
    end;
    ParamIndex := dgParamEstCovNames.Columns[0].PickList.
      IndexOf(dgParamEstCovNames.Cells[0, Index]);
    if (ParamIndex < 0) or (dgParamEstCovNames.Cells[0, Index] = '') then
    begin
      if Index - 1 < dgParamEstCovNames.Columns[0].PickList.Count then
      begin
        dgParamEstCovNames.Cells[0, Index]
          := dgParamEstCovNames.Columns[0].PickList[Index - 1];
      end
      else
      begin
        dgParamEstCovNames.Cells[0, Index] := '';
      end;
    end;
  end;

  if dgParamEstCovNames.RowCount > 1 then
  begin
    dgParamEstCovNames.FixedRows := 1;
  end;

  dgParamEstCovariance.RowCount := dgParamEstCovNames.RowCount;
  dgParamEstCovariance.ColCount := dgParamEstCovariance.RowCount;

  if dgParamEstCovariance.ColCount > 1 then
  begin
    dgParamEstCovariance.FixedCols := 1;
  end;

  if dgParamEstCovariance.RowCount > 1 then
  begin
    dgParamEstCovariance.FixedRows := 1;
  end;

  for Index := 1 to dgParamEstCovNames.RowCount - 1 do
  begin
    dgParamEstCovariance.Cells[0, Index] := dgParamEstCovNames.Cells[0, Index];
    AColumn := dgParamEstCovariance.Columns[Index];
    AColumn.Format := cfNumber;
    AColumn.Title.Caption := dgParamEstCovNames.Cells[0, Index];
  end;

  for Index := 1 to dgParamEstCovariance.ColCount - 1 do
  begin
    AColumn := dgParamEstCovariance.Columns[Index];
    AColumn.Format := cfNumber;
  end;

  for RowIndex := 1 to dgParamEstCovariance.RowCount - 1 do
  begin
    for ColIndex := 1 to dgParamEstCovariance.ColCount - 1 do
    begin
      if RowIndex = ColIndex then
      begin
        dgParamEstCovariance.Cells[ColIndex, RowIndex] := '1';
      end
      else
      begin
        dgParamEstCovariance.Cells[ColIndex, RowIndex] := '0';
      end;

    end;

  end;

end;

procedure TfrmMODFLOW.dgParamEstCovarianceSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  dgParamEstCovariance.Cells[ARow, ACol] := Value
end;

procedure TfrmMODFLOW.dgExit(Sender: TObject);
var
  ADataGrid: TDataGrid;
  Col, Row: integer;
begin
  inherited;
  if Sender is TDataGrid then
  begin
    ADataGrid := Sender as TDataGrid;
    if Assigned(ADataGrid.OnSetEditText) then
    begin
      Col := ADataGrid.Col;
      Row := ADataGrid.Row;
      ADataGrid.OnSetEditText(Sender, Col, Row, ADataGrid.Cells[Col, Row]);
    end;

    if (ADataGrid = dgLPFParameters) or (ADataGrid = dgEVTParametersN)
      or (ADataGrid = dgDRNParametersN) or (ADataGrid = dgGHBParametersN)
      or (ADataGrid = dgHFBParameters) or (ADataGrid = dgRCHParametersN)
      or (ADataGrid = dgRIVParametersN) or (ADataGrid = dgWELParametersN)
      or (ADataGrid = dgSFRParametersN) or (ADataGrid = dgSTRParametersN)
      or (ADataGrid = dgETSParametersN) or (ADataGrid = dgDRTParametersN)
      or (ADataGrid = dgCHDParameters) or (ADataGrid = dgHUFParameters)
      or (ADataGrid = dgADVParameters)  then
    begin
      AddNewParameters(ADataGrid, 0);
    end;
  end;

end;

procedure TfrmMODFLOW.InitializeEquationEditor(Editor: TfrmPriorEquationEditor);
var
  Index: integer;
  AStringList: TStringList;
  Position: integer;
begin
  inherited;
  Editor.CurrentModelHandle := CurrentModelHandle;
  AStringList := TStringList.Create;
  try

    if cbRCH.Checked then
    begin
      for Index := 1 to dgRCHParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgRCHParametersN.Cells[0, Index]);
      end;
    end;
    if cbRIV.Checked then
    begin
      for Index := 1 to dgRIVParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgRIVParametersN.Cells[0, Index]);
      end;
    end;
    if cbWEL.Checked then
    begin
      for Index := 1 to dgWELParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgWELParametersN.Cells[0, Index]);
      end;
    end;
    if cbDRN.Checked then
    begin
      for Index := 1 to dgDRNParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgDRNParametersN.Cells[0, Index]);
      end;
    end;
    if cbDRT.Checked then
    begin
      for Index := 1 to dgDRTParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgDRTParametersN.Cells[0, Index]);
      end;
    end;
    if cbGHB.Checked then
    begin
      for Index := 1 to dgGHBParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgGHBParametersN.Cells[0, Index]);
      end;
    end;
    if cbSFR.Checked then
    begin
      for Index := 1 to dgSFRParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgSFRParametersN.Cells[0, Index]);
      end;
    end;
    if cbSTR.Checked then
    begin
      for Index := 1 to dgSTRParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgSTRParametersN.Cells[0, Index]);
      end;
    end;
    if cbEVT.Checked then
    begin
      for Index := 1 to dgEVTParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgEVTParametersN.Cells[0, Index]);
      end;
    end;
    if cbETS.Checked then
    begin
      for Index := 1 to dgETSParametersN.RowCount - 1 do
      begin
        AStringList.Add(dgETSParametersN.Cells[0, Index]);
      end;
    end;
    if cbHFB.Checked then
    begin
      for Index := 1 to dgHFBParameters.RowCount - 1 do
      begin
        AStringList.Add(dgHFBParameters.Cells[0, Index]);
      end;
    end;
    if cbCHD.Checked then
    begin
      for Index := 1 to dgCHDParameters.RowCount - 1 do
      begin
        AStringList.Add(dgCHDParameters.Cells[0, Index]);
      end;
    end;
    if (rgFlowPackage.ItemIndex = 1) then
    begin
      for Index := 1 to dgLPFParameters.RowCount - 1 do
      begin
        AStringList.Add(dgLPFParameters.Cells[0, Index]);
      end;
    end;
    if (rgFlowPackage.ItemIndex = 2) then
    begin
      for Index := 1 to dgHUFParameters.RowCount - 1 do
      begin
        AStringList.Add(dgHUFParameters.Cells[0, Index]);
      end;
    end;

    for Index := 1 to dgParamEstCovNames.RowCount - 1 do
    begin
      Position := AStringList.IndexOf(dgParamEstCovNames.Cells[0, Index]);
      if Position > -1 then
      begin
        AStringList.Delete(Position);
      end;
    end;

    Editor.dgEquationParts.Columns[2].PickList.Assign(AStringList);
    Editor.Intitialize;

  finally
    AStringList.Free;
  end;

end;

procedure TfrmMODFLOW.dgPriorEquationsEditButtonClick(Sender: TObject);
begin
  inherited;
  if dgPriorEquations.Col = 2 then
  begin
    Application.CreateForm(TfrmPriorEquationEditor, frmPriorEquationEditor);
    //    frmPriorEquationEditor := TfrmPriorEquationEditor.Create(Application);
    try
      InitializeEquationEditor(frmPriorEquationEditor);

      frmPriorEquationEditor.EquationParser(dgPriorEquations.Cells[
        dgPriorEquations.Col, dgPriorEquations.Row]);

      if frmPriorEquationEditor.ShowModal = mrOK then
      begin
        dgPriorEquations.Cells[dgPriorEquations.Col, dgPriorEquations.Row]
          := frmPriorEquationEditor.Equation;
      end;

    finally
      frmPriorEquationEditor.Free;
    end;
  end;

end;

procedure TfrmMODFLOW.adePriorInfoEquationCountExit(Sender: TObject);
var
  OldRowCount: integer;
  RowIndex: integer;
  Equation: string;
begin
  inherited;

  Equation := '';
  Application.CreateForm(TfrmPriorEquationEditor, frmPriorEquationEditor);
  //  frmPriorEquationEditor := TfrmPriorEquationEditor.Create(Application);
  try
    InitializeEquationEditor(frmPriorEquationEditor);

    if frmPriorEquationEditor.EquationParser(Equation) then
    begin
      Equation := frmPriorEquationEditor.Equation;
    end;
  finally
    frmPriorEquationEditor.Free;
  end;

  OldRowCount := dgPriorEquations.RowCount;
  dgPriorEquations.RowCount := StrToInt(adePriorInfoEquationCount.Text) + 1;
  if dgPriorEquations.RowCount > 1 then
  begin
    dgPriorEquations.FixedRows := 1;
  end;
  for RowIndex := OldRowCount to dgPriorEquations.RowCount - 1 do
  begin
    dgPriorEquations.Cells[0, RowIndex] := 'EQ' + IntToStr(RowIndex);
    dgPriorEquations.Cells[1, RowIndex] := '1';
    dgPriorEquations.Cells[2, RowIndex] := Equation;
    dgPriorEquations.Cells[3, RowIndex] := '1';
    dgPriorEquations.Cells[4, RowIndex] :=
      dgPriorEquations.Columns[4].Picklist[0];
    dgPriorEquations.Cells[5, RowIndex] := '1';

  end;

end;

procedure TfrmMODFLOW.dgPriorEquationsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  NewValue: string;
begin
  inherited;
  if ACol = 0 then
  begin
    NewValue := Value;
    if Length(Value) > 10 then
    begin
      NewValue := Copy(Value, 1, 10);
    end;

    NewValue := FixArgusName(NewValue);

    if Value <> NewValue then
    begin
      Beep;
      dgPriorEquations.Cells[ACol, ARow] := NewValue;
    end;
  end;
  if (ARow > 0) and not loading and not Cancelling then
  begin
    if Length(PriorEquation(ARow)) > 200 then
    begin
      MessageDlg('This prior information will take up more than 200 '
        + 'characters. MODFLOW requires that it take up 200 or fewer '
        + 'characters.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbParamEstClick(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
begin
  inherited;
  tabParamEst.TabVisible := cbParamEst.Checked;

  ParameterCount := StrToInt(adeParamEstCovNameCount.Text);
  if cbParamEst.Checked then
  begin
    for Index := 0 to pagecontrolParamEst.PageCount - 1 do
    begin
      pagecontrolParamEst.Pages[Index].HandleNeeded;
    end;

    tabParamEstCov.TabVisible := (ParameterCount > 0);
    FreePageControlResources(pagecontrolParamEst, Handle);
  end;

  adeMaxParamEstIterations.Enabled := cbParamEst.Checked;
  adeMaxParamChange.Enabled := cbParamEst.Checked;

  adeParamEstTol.Enabled := cbParamEst.Checked;
  adeParamEstSecClosCrit.Enabled := cbParamEst.Checked;
  comboBealeInput.Enabled := cbParamEst.Checked;
  comboYcintInput.Enabled := cbParamEst.Checked;
  cbParamEstScreenPrint.Enabled := cbParamEst.Checked;
  cbParamEstRMatrix.Enabled := cbParamEst.Checked;
  //  adeParamEstRMatrixIterations.Enabled := cbParamEst.Checked;
  //  adeParamEstRMatrixCriterion.Enabled := cbParamEst.Checked;
  adeParamEstSearchDirection.Enabled := cbParamEst.Checked;
  adeParamEstCoarseConvCrit.Enabled := cbParamEst.Checked;
  adeRMAR.Enabled := cbParamEst.Checked;
  adeRMARM.Enabled := cbParamEst.Checked;
  comboLastx.Enabled := cbParamEst.Checked;
  cbResan.Enabled := cbParamEst.Checked;
  cbYcint.Enabled := cbParamEst.Checked;
  cbBeale.Enabled := cbParamEst.Checked;

  cbParamEstRMatrixClick(Sender);

  SetComboColor(comboBealeInput);
  SetComboColor(comboYcintInput);
  SetComboColor(comboLastx);

  if cbParamEst.Checked and not loading and not cancelling then
  begin
    cbObservations.Checked := True;
    cbSensitivity.Checked := True;
  end;

  // disable controls for printing sensitivity
  rgSensPrint.Enabled := cbSensitivity.Checked and not cbParamEst.Checked;
  cbSensBinary.Enabled := cbSensitivity.Checked and not cbParamEst.Checked;
  cbSensPrint.Enabled := cbSensitivity.Checked and not cbParamEst.Checked;
  cbSensPrintClick(Sender);
  adeParamEstCovNameCountExit(Sender);
  SetMode;
end;

function TfrmMODFLOW.PriorEquation(RowIndex: integer): string;
var
  EQNAM: string;
  PRM: double;
  Equation: string;
  STATP: DOUBLE;
  StatFlag, PlotSymbol: integer;
  AFormatString: string;
begin
  with dgPriorEquations do
  begin
    EQNAM := Cells[0, RowIndex];
    try
      PRM := InternationalStrToFloat(Cells[1, RowIndex]);
    except on EConvertError do
      begin
        PRM := 1;
      end;
    end;
    Equation := Cells[2, RowIndex];
    try
      STATP := InternationalStrToFloat(Cells[3, RowIndex]);
    except on EConvertError do
      begin
        STATP := 1;
      end;
    end;
    StatFlag := Columns[4].PickList.IndexOf(Cells[4, RowIndex]);
    if StatFlag > 2 then
    begin
      StatFlag := StatFlag + 7;
    end;
    try
      PlotSymbol := StrToInt(Cells[5, RowIndex]);
    except on EConvertError do
      begin
        PlotSymbol := 1;
      end;
    end;
    AFormatString := '%s '
      + TModflowWriter.FreeFormattedReal(PRM)
      + '= %s STAT '
      + TModflowWriter.FreeFormattedReal(STATP)
      + '%u %u';
    result := Format(AFormatString,
      [EQNAM, Equation, StatFlag, PlotSymbol]);
  end;
end;

function TfrmMODFLOW.FixModflowName(AString: string): string;
var
  SpacePos: integer;
begin
  AString := FixArgusName(AString);
  SpacePos := Pos(' ', AString);
  while SpacePos > 0 do
  begin
    AString[SpacePos] := '_';
    SpacePos := Pos(' ', AString);
  end;
  result := AString;
end;

procedure TfrmMODFLOW.dgMultiplierExit(Sender: TObject);
begin
  inherited;
  dgExit(Sender);
  OldMultiplierCount := GetMultiplierCount;

end;

procedure TfrmMODFLOW.cbParamEstRMatrixClick(Sender: TObject);
begin
  inherited;
  adeParamEstRMatrixIterations.Enabled := cbParamEstRMatrix.Checked and
    cbParamEst.Checked;
  adeParamEstRMatrixCriterion.Enabled := adeParamEstRMatrixIterations.Enabled;
end;

procedure TfrmMODFLOW.dgSensitivityExit(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  SensitivityNames.Clear;
  {  if cbSensitivity.Checked then
    begin
      for Index := 1 to dgSensitivity.RowCount -1 do
      begin
        SensitivityNames.Add(dgSensitivity.Cells[1,Index]);
      end;
    end;   }
  for Index := 1 to dgSensitivity.RowCount - 1 do
  begin
    if cbSensitivity.Checked then
    begin
      SensitivityNames.Add(dgSensitivity.Cells[1, Index]);
    end;
    if dgSensitivity.Cells[7, Index] = '' then
    begin
      dgSensitivity.Cells[7, Index] := '1.0E-10';
    end;
  end;

end;

procedure TfrmMODFLOW.dgParametersDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  ADataGrid: TDataGrid;
  AName: string;
  //  MyRect : TRect;
begin
  inherited;
  if Sender is TDataGrid then
  begin
    ADataGrid := Sender as TDataGrid;
    AName := ADataGrid.Cells[0, ARow];

    if not CanSelectCell(ACol, ARow, AName) then
    begin
      ADataGrid.Canvas.Brush.Color := clBtnFace;
      ADataGrid.Canvas.Font.Color := clBlack;
      // draw the text

      ADataGrid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
        ' set by Sensitivity package');

      // draw the right and lower cell boundaries in black.
      ADataGrid.Canvas.Pen.Color := clBlack;
      ADataGrid.Canvas.MoveTo(Rect.Right, Rect.Top);
      ADataGrid.Canvas.LineTo(Rect.Right, Rect.Bottom);
      ADataGrid.Canvas.LineTo(Rect.Left, Rect.Bottom);
      ADataGrid.Canvas.LineTo(Rect.Left, Rect.Top);
      ADataGrid.Canvas.LineTo(Rect.Right, Rect.Top);
    end;
  end;
end;

procedure TfrmMODFLOW.ActivateParametersTab;
var
  Index: integer;
begin
  tabParameters.TabVisible := (cbRCH.Checked and cbRCHRetain.Checked)
    or (cbRIV.Checked and cbRIVRetain.Checked)
    or (cbWEL.Checked and cbWELRetain.Checked)
    or (cbDRN.Checked and cbDRNRetain.Checked)
    or (cbDRT.Checked and cbDRTRetain.Checked)
    or (cbGHB.Checked and cbGHBRetain.Checked)
    or (cbEVT.Checked and cbEVTRetain.Checked)
    or (cbHFB.Checked and cbHFBRetain.Checked)
    or (cbSTR.Checked and cbSTRRetain.Checked)
    or (cbSFR.Checked and cbSFRRetain.Checked)
    or (cbETS.Checked and cbETSRetain.Checked)
    or (cbCHD.Checked and cbCHDRetain.Checked)
    or (cbAdvObs.Checked and cbObservations.Checked)
    or (rgFlowPackage.ItemIndex >= 1);
  if tabParameters.TabVisible then
  begin
    for Index := 0 to PageControlParameters.PageCount - 1 do
    begin
      PageControlParameters.Pages[Index].HandleNeeded;
    end;

    tabRechargeParam.TabVisible := cbRCH.Checked;
    tabRivParam.TabVisible := cbRIV.Checked;
    tabWelParam.TabVisible := cbWEL.Checked;
    tabDrnParam.TabVisible := cbDRN.Checked;
    tabDrtParam.TabVisible := cbDRT.Checked;
    tabGHBParam.TabVisible := cbGHB.Checked;
    TabEvapParam.TabVisible := cbEVT.Checked;
    TabEvapParam.TabVisible := cbEVT.Checked;
    tabHFBParam.TabVisible := cbHFB.Checked;
    tabSFR_Parameters.TabVisible := cbSFR.Checked;
    tabSTR_Parameters.TabVisible := cbSTR.Checked;
    tabETSParameters.TabVisible := cbETS.Checked;
    tabCHDParameters.TabVisible := cbCHD.Checked;
    tabADVParameters.TabVisible := cbAdvObs.Checked and cbObservations.Checked;
    tabLayerProperty.TabVisible := (rgFlowPackage.ItemIndex = 1);
    tabHufParam.TabVisible := (rgFlowPackage.ItemIndex = 2);

    FreePageControlResources(PageControlParameters, Handle);
  end;
end;

procedure TfrmMODFLOW.cbRetainClick(Sender: TObject);
begin
  inherited;
  ActivateParametersTab;
  CHDWarning;
end;

procedure TfrmMODFLOW.dg3dLPFParameterClustersSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  AStringGrid: TStringGrid;
  AnInteger: integer;
  procedure Fix;
  begin
    if not loading and not cancelling then
    begin
      Beep;
      AStringGrid := Sender as TStringGrid;
      AStringGrid.Cells[ACol, ARow] := OldZoneNumber
    end
    else
    begin
      AStringGrid := Sender as TStringGrid;
      AStringGrid.Cells[ACol, ARow] := ''
    end;
  end;
begin
  inherited;
  if (ARow > 0) and (ACol > 2) and (Value <> '') then
  begin
    try
      AnInteger := StrToInt(Value);
      if AnInteger = 0 then
      begin
        Fix;
      end
      else
      begin
        OldZoneNumber := Value;
      end;
    except
      Fix;
    end;
  end;
end;

procedure TfrmMODFLOW.dg3dLPFParameterClustersSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
var
  AStringGrid: TStringGrid;
begin
  inherited;
  AStringGrid := Sender as TStringGrid;
  OldZoneNumber := AStringGrid.Cells[ACol, ARow];
end;

procedure TfrmMODFLOW.rgAdvObsDisplacementOptionClick(Sender: TObject);
begin
  inherited;
  adeAdvstp.Enabled := cbAdvObs.Checked
    and (rgAdvObsDisplacementOption.ItemIndex > 0);
end;

procedure TfrmMODFLOW.rgCritMFCClick(Sender: TObject);
begin
  inherited;
  rdeCritMFC.Enabled := (rgCritMFC.ItemIndex = 1);
end;

procedure TfrmMODFLOW.cbAdvObsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbAdvObs.Checked;
  ActivateParametersTab;
  adeAdvectObsLayerCount.Enabled := ShouldEnable;
  adeAdvectObsStartLayerCount.Enabled := ShouldEnable;
  cbSpecifyAdvCovariances.Enabled := ShouldEnable;
  cbAdvObsPartDischarge.Enabled := ShouldEnable;
  cbAdvObsPartDischargeClick(Sender);
  if ShouldEnable then
  begin
    if StrToInt(adeAdvectObsLayerCount.Text) = 0 then
    begin
      adeAdvectObsLayerCount.Text := '1';
      adeAdvectObsLayerCountExit(Sender);
      adeAdvectObsLayerCount.Min := 1;
    end;
    if StrToInt(adeAdvectObsStartLayerCount.Text) = 0 then
    begin
      adeAdvectObsStartLayerCount.Text := '1';
      adeAdvectObsStartLayerCountExit(Sender);
      adeAdvectObsStartLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeAdvectObsLayerCount.Min := 0;
    adeAdvectObsLayerCount.Text := '0';
    adeAdvectObsLayerCountExit(Sender);

    adeAdvectObsStartLayerCount.Min := 0;
    adeAdvectObsStartLayerCount.Text := '0';
    adeAdvectObsStartLayerCountExit(Sender);
  end;
  cbSpecifyAdvCovariancesClick(Sender);

  rgAdvObsDisplacementOption.Enabled := cbAdvObs.Checked;
  rgPartDisp.Enabled := cbAdvObs.Checked;
  rgAdvObsDisplacementOptionClick(Sender);

  // add or remove the porosity layers depending on
  // whether MOC3D or MODPATH are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCPorosityLayerType, PorosityUsed);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCPorosityParamType,
    PorosityUsed);

end;

function TfrmMODFLOW.PorosityUsed: boolean;
begin
  result := cbMOC3D.Checked or cbMODPATH.Checked or
    (cbObservations.Checked and cbAdvObs.Checked) or cbMT3D.Checked;
end;

procedure TfrmMODFLOW.UpdateUseObsList(const ListBox: TCheckListBox;
  const OldLayerCount, NewLayerCount: integer);
var
  Index: integer;
begin
  for Index := OldLayerCount to NewLayerCount - 1 do
  begin
    if ListBox.Items.Count < NewLayerCount then
    begin
      ListBox.Items.Add(IntToStr(Index+1));
      ListBox.State[Index] := cbChecked;
    end;
  end;
  for Index := OldLayerCount - 1 downto NewLayerCount do
  begin
    if ListBox.Items.Count > Index then
    begin
      ListBox.Items.Delete(Index);
    end;
  end;
end;

procedure TfrmMODFLOW.adeAdvectObsLayerCountExit(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgAdvectionObservation)];
  NewLayerCount := StrToInt(adeAdvectObsLayerCount.Text);
  OldLayerCount := FluxList.NonDeletedLayerCount;
  AddFluxLayers(NewLayerCount, FluxList,
    ModflowTypes.GetMFAdvectionObservationsLayerType);

  UpdateUseObsList(clbAdvObs, OldLayerCount, NewLayerCount);

end;

procedure TfrmMODFLOW.adeAdvectObsStartLayerCountExit(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgAdvectionStart)];
  NewLayerCount := StrToInt(adeAdvectObsStartLayerCount.Text);
  OldLayerCount := FluxList.NonDeletedLayerCount;
  AddFluxLayers(NewLayerCount, FluxList,
    ModflowTypes.GetMFAdvectionObservationsStartingLayerType);

  UpdateUseObsList(clbAdvObsStartPoints, OldLayerCount, NewLayerCount);
end;

procedure TfrmMODFLOW.cbSpecifyAdvCovariancesClick(Sender: TObject);
var
  ShouldEnable: boolean;
  FluxList: T_ANE_IndexedLayerList;
begin
  inherited;
  ShouldEnable := cbSpecifyAdvCovariances.Checked
    and cbAdvObs.Checked;
  comboAdvObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboAdvObsPrintFormats);
  adeAdvObsBoundCount.Enabled := ShouldEnable;
  dgAdvObsBoundCovariances.Enabled := ShouldEnable;

  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgAdvectionObservation)];
  FluxList.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAdvectionObservationsLayerType,
    ModflowTypes.GetMFXObsNumberParamType,
    cbSpecifyAdvCovariances.Checked
    and cbAdvObs.Checked and cbObservations.Checked);
  FluxList.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAdvectionObservationsLayerType,
    ModflowTypes.GetMFYObsNumberParamType,
    cbSpecifyAdvCovariances.Checked
    and cbAdvObs.Checked and cbObservations.Checked);
  FluxList.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAdvectionObservationsLayerType,
    ModflowTypes.GetMFZObsNumberParamType,
    cbSpecifyAdvCovariances.Checked
    and cbAdvObs.Checked and cbObservations.Checked);
end;

procedure TfrmMODFLOW.adeAdvObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeAdvObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgAdvObsBoundCovariances);
end;

procedure TfrmMODFLOW.cbLAKClick(Sender: TObject);
var
  Index: integer;
  ALayerList: T_ANE_LayerList;
  ALeakanceLayer: T_ANE_MapsLayer;
begin
  inherited;
  EnablecbUzfIRUNFLG;

  adeSurfDepth.Enabled := cbLAK.Checked;
  lblSurfDepth.Enabled := cbLAK.Checked;

  lblLakeOutput.Enabled := cbLAK.Checked;
  comboLakSteady.Enabled := cbLAK.Checked; // steady stress
  SetComboColor(comboLakSteady);

  comboLakSteadyLeakance.Enabled := cbLAK.Checked;
  SetComboColor(comboLakSteadyLeakance);
  lblLakSteadyLeakance.Enabled := cbLAK.Checked;

  cbLAKRetain.Enabled := cbLAK.Checked;
  cbFlowLak.Enabled := cbLAK.Checked;
  adeLakTheta.Enabled := cbLAK.Checked;
  cbSubLakes.Enabled := cbLAK.Checked and IsAnyTransient;
  if cbLAK.Checked and not cbSubLakes.Enabled then
  begin
    cbSubLakes.Checked := False;
  end;
  cbLakePrint.Enabled := cbLAK.Checked;

  if cbLAK.Checked and not Loading and not Cancelling then
  begin
    Beep;
    ShowMessage('Please note that the MODFLOW GUI does not support redefining '
      + 'the locations of lakes after the first stress period');
  end;

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveLayer
    (ModflowTypes.GetMFLakeGroupLayerType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveLayer
    (ModflowTypes.GetMFLakeLayerType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveLayer
    (ModflowTypes.GetMFLakeBottomLayerType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridLakeLocationParamType,
    cbLAK.Checked);

  // add or remove concentration parameters from the lake
  // layers
  // depending on whether lake boundaries and MOC3D are selected.
  MFLayerStructure.UnIndexedLayers3.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakePrecipConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakeRunoffConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakeAugmentationConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLakeLayerType,
    ModflowTypes.GetMFLakeInitialConcParamType,
    cbMOC3D.Checked and cbLAK.Checked);

  SetLakesSteady;
  cbSubLakesClick(Sender);

  ALayerList := MFLayerStructure.FirstListsOfIndexedLayers.
    Items[Ord(lgLakeLeakance)];

  if cbLak.Checked then
  begin
    for Index := 0 to StrToInt(edNumUnits.Text) - 1 do
    begin
      if Index < ALayerList.Count then
      begin
        ALeakanceLayer := ALayerList.Items[Index];
        ALeakanceLayer.UnDelete;
      end
      else
      begin
        ModflowTypes.GetMFLakeLeakanceLayerType.Create(ALayerList, -1);
      end;
    end;
  end
  else
  begin
    for Index := ALayerList.Count - 1 downto 0 do
    begin
      ALeakanceLayer := ALayerList.Items[Index];
      ALeakanceLayer.Delete;
    end;
  end;

  UpdatedUzfLayersAndParameters;

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
end;

{function TfrmMODFLOW.IsAllSteady : boolean;
var
  RowIndex : integer;
begin
  result := False;
  for RowIndex := 1 to dgTime.RowCount -1 do
  begin
    if dgTime.Columns[Ord(tdSsTr)].PickList.IndexOf
      (dgTime.Cells[Ord(tdSsTr),RowIndex]) = 1 then
    begin
      result := True;
      Exit;
    end;
  end;
end;   }

function TfrmMODFLOW.IsAnySteady: boolean;
var
  RowIndex: integer;
begin
  result := False;
  for RowIndex := 1 to dgTime.RowCount - 1 do
  begin
    if IsSteady(RowIndex) then
    begin
      result := True;
      Exit;
    end;
  end;
end;

function TfrmMODFLOW.IsSteady(const StressPeriod: integer): boolean;
begin
  result := dgTime.Columns[Ord(tdSsTr)].PickList.IndexOf
    (dgTime.Cells[Ord(tdSsTr), StressPeriod]) = 1;
end;

function TfrmMODFLOW.IsAnyTransient: boolean;
var
  RowIndex: integer;
begin
  result := False;
  for RowIndex := 1 to dgTime.RowCount - 1 do
  begin
    if not IsSteady(RowIndex) then
    begin
      result := True;
      Exit;
    end;
  end;
end;

procedure TfrmMODFLOW.cbSubLakesClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.UnIndexedLayers3.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLakeLayerType, ModflowTypes.GetMFCenterLakeParamType,
    cbLAK.Checked and cbSubLakes.Checked);

  MFLayerStructure.UnIndexedLayers3.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLakeLayerType, ModflowTypes.GetMFLakeSillParamType,
    cbLAK.Checked and cbSubLakes.Checked);
end;

procedure TfrmMODFLOW.SetLakesSteady;
var
  Steady: boolean;
begin
  Steady := IsAnySteady;
  adeLakIterations.Enabled := cbLAK.Checked {and Steady};
  adeLakeConvCriterion.Enabled := cbLAK.Checked {and Steady};

  cbSubLakes.Enabled := cbLAK.Checked and IsAnyTransient;
  if cbLAK.Checked and not cbSubLakes.Enabled then
  begin
    cbSubLakes.Checked := False;
  end;

  if MFLayerStructure <> nil then
  begin
    MFLayerStructure.UnIndexedLayers3.AddOrRemoveUnIndexedParameter
      (ModflowTypes.GetMFLakeLayerType,
      ModflowTypes.GetMFLakeMinimumStageParamType,
      cbLAK.Checked and Steady);

    MFLayerStructure.UnIndexedLayers3.AddOrRemoveUnIndexedParameter
      (ModflowTypes.GetMFLakeLayerType,
      ModflowTypes.GetMFLakeMaximumStageParamType,
      cbLAK.Checked and Steady);
  end;
end;

procedure TfrmMODFLOW.FixPriorEstimates;
var
  Index: integer;
begin
  for Index := 1 to dgParamEstCovNames.RowCount - 1 do
  begin
    if Trim(dgParamEstCovNames.Cells[2, Index]) = '' then
    begin
      dgParamEstCovNames.Cells[2, Index] := '1';
    end;
  end;
end;

procedure TfrmMODFLOW.comboIBSPrintFrequencyChange(Sender: TObject);
begin
  inherited;
  adeIBSPrintFrequency.Enabled := (comboIBSPrintFrequency.ItemIndex = 1)
    and comboIBSPrintFrequency.Enabled;

  comboIBSPrintStyle.Enabled := (comboIBSPrintFrequency.ItemIndex > 0)
    and comboIBSPrintFrequency.Enabled;
  SetComboColor(comboIBSPrintStyle);

  comboIBSPrintFormat.Enabled := comboIBSPrintStyle.Enabled;
  SetComboColor(comboIBSPrintFormat);

end;

procedure TfrmMODFLOW.comboIBSSaveFrequencyChange(Sender: TObject);
begin
  inherited;
  adeIBSSaveFrequency.Enabled := (comboIBSSaveFrequency.ItemIndex = 1)
    and comboIBSSaveFrequency.Enabled;

  {  comboIBSSaveStyle.Enabled := (comboIBSSaveFrequency.ItemIndex > 0)
      and comboIBSSaveFrequency.Enabled;
    SetComboColor(comboIBSSaveStyle);

    comboIBSSaveFormat.Enabled := comboIBSSaveStyle.Enabled;
    SetComboColor(comboIBSSaveFormat);  }
end;

procedure TfrmMODFLOW.cbIBSClick(Sender: TObject);
var
  UnitIndex: integer;
begin
  inherited;
  StreamWarning;
  Modflow2000Warnings;
  SubsidenceWarnings;
  cbUseIBS.Enabled := cbIBS.Checked;
  cbUseIBS.Enabled := cbIBS.Checked;
  cbFlowIBS.Enabled := cbIBS.Checked;
  dgIBS.Enabled := cbIBS.Checked or cbTLK.Checked;

  if dgIBS.Enabled then
  begin
    dgIBS.Color := clWindow;
  end
  else
  begin
    dgIBS.Color := clBtnFace;
  end;
  dgIBS.Invalidate;

  comboIBSPrintFrequency.Enabled := cbIBS.Checked;
  SetComboColor(comboIBSPrintFrequency);
  comboIBSPrintFrequencyChange(Sender);

  comboIBSSaveFrequency.Enabled := cbIBS.Checked;
  SetComboColor(comboIBSSaveFrequency);
  comboIBSSaveFrequencyChange(Sender);

  for UnitIndex := 1 to dgIBS.RowCount - 1 do
  begin
    dgIBSSetEditText(Sender, 1, UnitIndex, dgIBS.Cells[1, UnitIndex]);
  end;

end;

function TfrmMODFLOW.UseIBS(UnitNumber: integer): boolean;
begin
  result := dgIBS.Cells[1, UnitNumber] = dgIBS.Columns[1].PickList[1];
end;

procedure TfrmMODFLOW.dgIBSSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  AGeologicUnit: T_ANE_IndexedLayerList;
  GridLayer: T_ANE_GridLayer;
  AParameterList: T_ANE_IndexedParameterList;
begin
  inherited;
  if (ACol = 1) and (ARow > 0) then
  begin
    AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
      GetNonDeletedIndLayerListByIndex(ARow - 1);
    if AGeologicUnit <> nil then
    begin
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFIBSLayerType,
        UseIBS(ARow) and cbIBS.Checked);

      AGeologicUnit.AddOrRemoveUnIndexedParameter(
        ModflowTypes.GetMFHydmodLayerType,
        ModflowTypes.GetMFHydmodPreconsolidationObservationParamType,
        UseIBS(ARow) and cbIBS.Checked and cbHYD.Checked);

      AGeologicUnit.AddOrRemoveUnIndexedParameter(
        ModflowTypes.GetMFHydmodLayerType,
        ModflowTypes.GetMFHydmodCompactionObservationParamType,
        UseIBS(ARow) and cbIBS.Checked and cbHYD.Checked);

      AGeologicUnit.AddOrRemoveUnIndexedParameter(
        ModflowTypes.GetMFHydmodLayerType,
        ModflowTypes.GetMFHydmodSubsidenceObservationParamType,
        UseIBS(ARow) and cbIBS.Checked and cbHYD.Checked);
    end;

    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    AParameterList := GridLayer.IndexedParamList1.
      GetNonDeletedIndParameterListByIndex(ARow - 1);
    if AParameterList <> nil then
    begin
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridIbsPreconsolidationHeadParamType,
        ModflowTypes.GetMFGridIbsPreconsolidationHeadParamType.Ane_ParamName,
        UseIBS(ARow) and cbIBS.Checked);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridIbsElasticStorageParamType,
        ModflowTypes.GetMFGridIbsElasticStorageParamType.Ane_ParamName,
        UseIBS(ARow) and cbIBS.Checked);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMGridIbsInelasticStorageParamType,
        ModflowTypes.GetMGridIbsInelasticStorageParamType.Ane_ParamName,
        UseIBS(ARow) and cbIBS.Checked);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridIbsStartingCompactionParamType,
        ModflowTypes.GetMFGridIbsStartingCompactionParamType.Ane_ParamName,
        UseIBS(ARow) and cbIBS.Checked);
    end;

  end;

end;

procedure TfrmMODFLOW.dgIBSExit(Sender: TObject);
begin
  inherited;
  with dgIBS do
  begin
    dgIBSSetEditText(Sender, Col, Row, Cells[Col, Row]);
  end;
end;

procedure TfrmMODFLOW.dgIBSSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  inherited;
  if ARow > 0 then
  begin
    if ACol = 1 then
    begin
      CanSelect := cbIBS.Checked and Simulated(ARow);
    end
    else if ACol = 2 then
    begin
      CanSelect := cbTLK.Checked and not Simulated(ARow);
    end;
  end;
end;

procedure TfrmMODFLOW.dgIBSDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  CanSelect: Boolean;
begin
  inherited;
  if dgIBS.Enabled and (ACol > 0) and (ARow > 0) then
  begin
    dgIBSSelectCell(Sender, ACol, ARow, CanSelect);
    with dgIBS do
    begin
      if CanSelect then
      begin
        Canvas.Brush.Color := clWindow;
      end
      else
      begin
        Canvas.Brush.Color := clBtnFace;
      end;
      Canvas.Font.Color := clBlack;
      // draw the text
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
      // draw the right and lower cell boundaries in black.
      Canvas.Pen.Color := clBlack;
      Canvas.MoveTo(Rect.Right, Rect.Top);
      Canvas.LineTo(Rect.Right, Rect.Bottom);
      Canvas.LineTo(Rect.Left, Rect.Bottom);
    end;
  end;

end;

procedure TfrmMODFLOW.Tip;
var
  ShowTip: boolean;
  ShowTipFileName: string;
  TipStringList: TStringList;
  AString: string;
  CanSave: boolean;
begin
  ShowTip := True;
  ShowTipFileName := DllAppDirectory(Self.handle, DLLName);
  if not DirectoryExists(ShowTipFileName) then
  begin
    CreateDirectoryAndParents(ShowTipFileName);
  end;
  ShowTipFileName := ShowTipFileName + '\ShowTip.txt';
  TipStringList := TStringList.Create;
  try
    CanSave := True;
    if FileExists(ShowTipFileName) then
    begin
      TipStringList.LoadFromFile(ShowTipFileName);
      CanSave := True;
      try
        TipStringList.SaveToFile(ShowTipFileName);
      except
        CanSave := False;
      end;

      if TipStringList.Count > 0 then
      begin
        AString := Trim(LowerCase(TipStringList[0]));
        if AString <> 'true' then
        begin
          ShowTip := False;
        end;
      end;
      if ShowTip and (TipStringList.Count > 1) then
      begin
        AString := Trim(LowerCase(TipStringList[1]));
        try
          alstdTips.CurrentTip := StrToInt(AString) + 1;
          if not CanSave then
          begin
            Randomize;
            alstdTips.CurrentTip := Random(alstdTips.Tips.Count);
          end;
        except on EConvertError do
          begin
          end;
        end;
      end;
    end;
    if ShowTip then
    begin
      ShowTip := alstdTips.Execute;
    end;
    TipStringList.Clear;
    if ShowTip then
    begin
      TipStringList.Add('true');
    end
    else
    begin
      TipStringList.Add('false');
    end;
    TipStringList.Add(IntToStr(alstdTips.CurrentTip));
    if CanSave then
    begin
      TipStringList.SaveToFile(ShowTipFileName);
    end;
  finally
    TipStringList.Free;
  end;
  cbTips.Checked := ShowTip;
end;

procedure TfrmMODFLOW.cbTipsClick(Sender: TObject);
var
  ShowTipFileName: string;
  TipStringList: TStringList;
begin
  inherited;
  btnShowTip.Enabled := cbTips.Checked;
  if not loading and not cancelling then
  begin
    ShowTipFileName := DllAppDirectory(Self.handle, DLLName);
    if not DirectoryExists(ShowTipFileName) then
    begin
      CreateDirectoryAndParents(ShowTipFileName);
    end;
//    if GetDllDirectory(GetDLLName, ShowTipFileName) then
//    begin
      ShowTipFileName := ShowTipFileName + '\ShowTip.txt';
      TipStringList := TStringList.Create;
      try
        if cbTips.Checked then
        begin
          TipStringList.Add('True');
        end
        else
        begin
          TipStringList.Add('False');
        end;
        TipStringList.Add(IntToStr(alstdTips.CurrentTip));
        TipStringList.SaveToFile(ShowTipFileName);
      finally
        TipStringList.Free;
      end;
//    end;
  end;
end;

procedure TfrmMODFLOW.pageControlPackagesChange(Sender: TObject);
begin
  inherited;
  FreePageControlResources(pageControlPackages, Handle);
  pageControlPackages.HelpContext := pageControlPackages.ActivePage.HelpContext;
  BitBtnHelp.HelpContext := pageControlPackages.HelpContext;
  tabPackages.HelpContext := pageControlPackages.HelpContext;
end;

procedure TfrmMODFLOW.cbRESClick(Sender: TObject);
begin
  inherited;
  comboResSteady.Enabled := cbRES.Checked; // steady stress
  SetComboColor(comboResSteady);

  comboResOption.Enabled := cbRES.Checked; // evapotranspiration option
  SetComboColor(comboResOption);

  cbRESRetain.Enabled := cbRES.Checked;
  cbRESLayer.Enabled := cbRES.Checked and (comboResOption.ItemIndex = 1);

  // cell-by-cell flows related to evapotranspiration
  cbFlowRES.Enabled := cbRES.Checked;

  cb95PrintRes.Enabled := cbRES.Checked;
  adeResPointsCount.Enabled := cbRES.Checked;

  // add or remove Reservoir layer
  // depending on whether Reservoir is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFReservoirLayerType, cbRES.Checked);

  // add or remove grid general-head boundary parameters from the grid layer
  // depending on whether general-head boundaries are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridResElevParamType,
    cbRes.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridResKzParamType,
    cbRes.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridResThicknessParamType,
    cbRes.Checked);

  comboResOptionChange(Sender);
  EnableSSM;
end;

procedure TfrmMODFLOW.cbRESLayerClick(Sender: TObject);
begin
  inherited;
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMFModflowLayerParamType,
    cbRESLayer.Checked and cbRES.Checked and (comboResOption.ItemIndex = 1));

  if cbRESLayer.Checked then
  begin
    SpecifyLayerWarning
  end;

end;

procedure TfrmMODFLOW.comboResOptionChange(Sender: TObject);
begin
  inherited;
  cbRESLayer.Enabled := cbRES.Checked and (comboResOption.ItemIndex = 1);
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  cbRESLayerClick(Sender);

end;

procedure TfrmMODFLOW.PageControlMOC3DChange(Sender: TObject);
begin
  inherited;
  FreePageControlResources(PageControlMOC3D, Handle);
  PageControlMOC3D.HelpContext := PageControlMOC3D.ActivePage.HelpContext;
  BitBtnHelp.HelpContext := PageControlMOC3D.HelpContext;
  tabMOC3D.HelpContext := PageControlMOC3D.HelpContext;
end;

procedure TfrmMODFLOW.cbTLKClick(Sender: TObject);
begin
  inherited;
  StreamWarning;
  Modflow2000Warnings;
  MODPATHWarnings;
  dgIBS.Enabled := cbIBS.Checked or cbTLK.Checked;
  if dgIBS.Enabled then
  begin
    dgIBS.Color := clWindow;
  end
  else
  begin
    dgIBS.Color := clBtnFace;
  end;
  dgIBS.Invalidate;

  cbFlowTLK.Enabled := cbTLK.Checked;
  cbTLKRetain.Enabled := cbTLK.Checked;
  adeTLKNumberOfTerms.Enabled := cbTLK.Checked;
  cbTLKSaveRestartFile.Enabled := cbTLK.Checked;
  cbTLKStartFromRestart.Enabled := cbTLK.Checked;
  cbTLKStartFromRestartClick(Sender);
end;

function TfrmMODFLOW.UseTLK(UnitNumber: integer): boolean;
begin
  result := dgIBS.Cells[2, UnitNumber] = dgIBS.Columns[2].PickList[1];
end;

procedure TfrmMODFLOW.cbTLKStartFromRestartClick(Sender: TObject);
begin
  inherited;
  edTLKRestartFile.Enabled := cbTLKStartFromRestart.Checked and cbTLK.Checked;
  btnTLKRestartFile.Enabled := edTLKRestartFile.Enabled;
  if edTLKRestartFile.Enabled then
  begin
    edTLKRestartFile.Color := clWindow;
  end
  else
  begin
    edTLKRestartFile.Color := clBtnFace;
  end;
  if cbTLKStartFromRestart.Checked and cbTLK.Checked and not Loading
    and not cancelling and (edTLKRestartFile.Text = '') then
  begin
    btnTLKRestartFileClick(Sender);
  end;
end;

procedure TfrmMODFLOW.SetUnits;
begin
  lblDiffusUnits.Caption := '1/' + TimeUnit;
  lblHdryUnits.Caption := LengthUnit;
end;

procedure TfrmMODFLOW.comboLakSteadyLeakanceChange(Sender: TObject);
var
  ALayerList: T_ANE_IndexedLayerList;
  Index: Integer;
  ALeakanceLayer: T_ANE_Layer;
begin
  inherited;
  if cbLAK.Checked then
  begin
    ALayerList := MFLayerStructure.FirstListsOfIndexedLayers.
      Items[Ord(lgLakeLeakance)];
    for Index := 0 to StrToInt(edNumUnits.Text) - 1 do
    begin
      if Index < ALayerList.Count then
      begin
        ALeakanceLayer := ALayerList.Items[Index] as T_ANE_Layer;
        if comboLakSteadyLeakance.ItemIndex = 1 then
        begin
          ALeakanceLayer.MoveParamToIndParam2
            (ModflowTypes.GetMFLakeHydraulicCondParamType);

          ALeakanceLayer.MoveParamToIndParam2
            (ModflowTypes.GetMFLakeThicknessParamType);
        end
        else
        begin
          ALeakanceLayer.MoveIndParam2ToParam
            (ModflowTypes.GetMFLakeHydraulicCondParamType);

          ALeakanceLayer.MoveIndParam2ToParam
            (ModflowTypes.GetMFLakeThicknessParamType);
        end;

        ALeakanceLayer.AddOrRemoveIndexedParameter2
          (
          ModflowTypes.GetMFLakeHydraulicCondParamType,
          cbLAK.Checked and (comboLakSteadyLeakance.ItemIndex = 1));

        ALeakanceLayer.AddOrRemoveIndexedParameter2
          (
          ModflowTypes.GetMFLakeThicknessParamType,
          cbLAK.Checked and (comboLakSteadyLeakance.ItemIndex = 1));
      end;
    end;

  end;

  AssociateTimes;
end;

procedure TfrmMODFLOW.comboLengthUnitsChange(Sender: TObject);
  procedure ShowWarning;
  begin
    if not Importing then
    begin
      Beep;
      MessageDlg('After after you finish editing the Project Information, '
        + 'you may wish to select '
        + '"Special|Scale and Units" to set the length unit shown by Argus ONE '
        + 'to match the length unit of the model. However, the units displayed '
        + 'by Argus ONE do not actually affect the model calculations.',
        mtInformation, [mbOK], 0);
    end;
  end;
{$IFDEF ARGUS5}
var
  GridLayer: TLayerOptions;
  ModelLengthUnit: string;
{$ENDIF}
begin
  inherited;
  case comboLengthUnits.ItemIndex of
    0:
      begin
        LengthUnit := 'L'
      end;
    1:
      begin
        LengthUnit := 'ft'
      end;
    2:
      begin
        LengthUnit := 'm'
      end;
    3:
      begin
        LengthUnit := 'cm'
      end;
  else
    begin
      LengthUnit := 'L'
    end;
  end;
  SetUnits;
  MFLayerStructure.SetAllParamUnits;
  if not loading and not cancelling then
  begin
    if NewModel then
    begin
      if (comboLengthUnits.ItemIndex <> 3) then
      begin
        ShowWarning;
      end;
    end
    else
    begin
{$IFDEF ARGUS5}
      GridLayer := TLayerOptions.CreateWithName(ModflowTypes.GetGridLayerType.
        WriteNewRoot, CurrentModelHandle);
      try
        ModelLengthUnit := GridLayer.CoordUnits[CurrentModelHandle];
        try
          case comboLengthUnits.ItemIndex of
            1:
              begin
                if ModelLengthUnit <> 'feet' then
                begin
                  ShowWarning;
                  //                GridLayer.CoordUnits[CurrentModelHandle] := 'feet';
                end;
              end;
            2:
              begin
                if ModelLengthUnit <> 'meter' then
                begin
                  ShowWarning;
                  //                GridLayer.CoordUnits[CurrentModelHandle] := 'meter';
                end;
              end;
            3:
              begin
                if ModelLengthUnit <> 'cm' then
                begin
                  ShowWarning;
                  //                GridLayer.CoordUnits[CurrentModelHandle] := 'cm';
                end;
              end;
          else
            begin
              ShowWarning;
            end;
          end;
        except on EArgusPropertyError do
          begin
            ShowWarning;
          end;
        end;

      finally
        GridLayer.Free(CurrentModelHandle);
      end;
{$ELSE}
      if (comboLengthUnits.ItemIndex <> 3)
        and (comboLengthUnits.ItemIndex <> 1) then
      begin
        ShowWarning;
      end;
{$ENDIF}
    end;
  end;
end;

procedure TfrmMODFLOW.SetMaxFileNameLength;
begin
  if not Loading and not Cancelling then
  begin
    if rbModflow96.Checked then
    begin
      adeFileName.MaxLength := 8;
    end
    else
    begin
      adeFileName.MaxLength := 0;
    end;
  end;
end;

procedure TfrmMODFLOW.rbModflow96Click(Sender: TObject);
begin
  inherited;
  SetMaxFileNameLength;
  EnableMf2005LpfOptions;
  if not rbModflow2005.Checked then
  begin
    rbMODFLOW2000.Checked := not rbModflow96.Checked;
  end;
  Modflow2005Warning;

  cbMT3D.Enabled := rbMODFLOW2000.Checked;
  if not cbMT3D.Enabled and not Loading and not Cancelling then
  begin
    cbMT3D.Checked := False;
  end;
  cbSeaWat.Enabled := not rbModflow96.Checked;
  if not cbSeaWat.Enabled and not Loading and not Cancelling then
  begin
    cbSeaWat.Checked := False;
  end;
  SetCompactOption;
  SetMF2K_GWTCaptions;
  comboModelUnits.Enabled := cbSTR.Checked and cbStreamCalcFlow.Checked
    and rbModflow96.Checked;
  SetComboColor(comboModelUnits);
  adeStreamTolerance.Enabled := cbSFR.Checked;
  adeStreamTableEntriesCount.Enabled := cbSFR.Checked
    and not rbModflow96.Checked and cbSFRCalcFlow.Checked;

  if rbModflow96.Checked and not loading and not cancelling and (rgFlowPackage.ItemIndex <> 0) then
  begin
    Beep;
    MessageDlg('MODFLOW-96 only supports the BCF flow package so the flow '
      + 'package has been changed to the BCF package.', mtWarning, [mbOK], 0);
  end;
  if rbModflow96.Checked and not loading and not cancelling then
  begin
    rgFlowPackage.ItemIndex := 0;
    cbExpDIS.Checked := False;
  end;
  EnableObsSenParameter;
  Modflow96Warnings;
  ZoneBudgetWarning;
  CHDWarning;
  MNW_Warning;
  comboHeadPrintFreqChange(Sender);
  comboDrawdownPrintFreqChange(Sender);
  comboBudPrintFreqChange(Sender);
  comboHeadExportFreqChange(Sender);
  comboDrawdownExportFreqChange(Sender);
  comboBudExportFreqChange(Sender);
end;

procedure TfrmMODFLOW.Modflow96Warnings;
begin
  inherited;
  if not loading and not cancelling and rbModflow96.Checked
    and (rgFlowPackage.ItemIndex > 0) then
  begin
    Beep;
    MessageDlg('The Layer Property Flow Package can only be used with'
      + ' MODFLOW-2000.', mtError, [mbOK], 0);
  end;
  LmgWarning;
  GmgWarning;
  ETSWarning;
  DRTWarning;
end;

procedure TfrmMODFLOW.TlkWarning;
var
  AMessage: string;
begin
  inherited;
  if not loading and not cancelling then
  begin
    if rbModflow2000.Checked or rbModflow2005.Checked then
    begin
      if cbTLK.Checked then
      begin
        AMessage := 'The Transient-Leakage package is' +
          ' not currently supported in MODFLOW-2000 and MODFLOW-2005.';
        Beep;
        MessageDlg(AMessage, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

function TfrmMODFLOW.Mnw2LossTypeChoices: TMnw2LossTypeSet;
var
  Index: TMnw2LossTypeChoices;
begin
  result := [];
  for Index := Low(TMnw2LossTypeChoices) to High(TMnw2LossTypeChoices) do
  begin
    if clbMnw2LossTypes.Checked[Ord(Index)] then
    begin
      include(result, Index);
    end;
  end;
end;

procedure TfrmMODFLOW.Mnw2PumpNameChanged(Sender: TObject);
var
  Page: TWinControl;
  Node: TTreeNode;
  Frame: TframeMnw2Pump;
begin
  Frame := Sender as TframeMnw2Pump;
  Page := Frame.Parent;
  Node := tvMnw2Pumps.Items.GetFirstNode;
  while Node <> nil do
  begin
    if Node.Data = Page then
    begin
      if Node.Text <> Frame.edPumpName.Text then
      begin
        Node.Text := Frame.edPumpName.Text
      end;
      break;
    end;
    Node := Node.GetNext;
  end;
end;

procedure TfrmMODFLOW.tvMnw2PumpsAddition(Sender: TObject; Node: TTreeNode);
var
  PumpName: string;
  Page: TJvStandardPage;
  frameMnw2Pump: TframeMnw2Pump;
  ControlName: string;
begin
  inherited;
  PumpName := 'Pump' + IntToStr(tvMnw2Pumps.Items.Count);
  Page := TJvStandardPage.Create(self);
  Node.Data := Page;
  Page.PageList := plMnwPumps;

  frameMnw2Pump := TframeMnw2Pump.Create(self);
  ControlName := frameMnw2PumpName(tvMnw2Pumps.Items.Count+1);
  frameMnw2Pump.Name := ControlName;
  frameMnw2Pump.Parent := Page;
  frameMnw2Pump.edPumpName.Text := PumpName;
  frameMnw2Pump.OnPumpNameChanged := Mnw2PumpNameChanged;

  plMnwPumps.ActivePage := Page;

end;

procedure TfrmMODFLOW.tvMnw2PumpsChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  if tvMnw2Pumps.Selected <> nil then
  begin
    plMnwPumps.ActivePage := tvMnw2Pumps.Selected.Data;
  end;

end;

procedure TfrmMODFLOW.tvMnw2PumpsDeletion(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  DeleteMnw2PumpNode(Node);

end;

procedure TfrmMODFLOW.tvMnw2PumpsEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  Page: TJvStandardPage;
  frameMnw2Pump: TframeMnw2Pump;
begin
  inherited;
  Page := Node.Data;
  frameMnw2Pump := Page.Controls[0] as TframeMnw2Pump;
  if frameMnw2Pump.edPumpName.Text <> S then
  begin
    frameMnw2Pump.edPumpName.Text := S;
  end;

end;

procedure TfrmMODFLOW.Modflow2000Warnings;
begin
  inherited;
  TlkWarning;
end;

procedure TfrmMODFLOW.rbMODFLOW2000Click(Sender: TObject);
begin
  inherited;
  SetMaxFileNameLength;
  EnableMf2005LpfOptions;
  // Fix problem with reading old models.
  dgTime.ColCount := Ord(High(timeData))+1;

  rbModflow96.Checked := not rbMODFLOW2000.Checked and not rbModflow2005.Checked ;
  Modflow2005Warning;

  cbMT3D.Enabled := rbMODFLOW2000.Checked;
  if not cbMT3D.Enabled and not Loading and not Cancelling then
  begin
    cbMT3D.Checked := False;
  end;
  cbSeaWat.Enabled := rbMODFLOW2000.Checked;
  if not cbSeaWat.Enabled and not Loading and not Cancelling then
  begin
    cbSeaWat.Checked := False;
  end;
  SetCompactOption;
  SetMF2K_GWTCaptions;
//  cbStreamCalcFlow.Enabled := cbSTR.Checked and rbModflow96.Checked;
  comboModelUnits.Enabled := cbSTR.Checked and cbStreamCalcFlow.Checked
    and rbModflow96.Checked;
  SetComboColor(comboModelUnits);
  adeStreamTolerance.Enabled := cbSFR.Checked and
    (rbMODFLOW2000.Checked or rbModflow2005.Checked);
  adeStreamTableEntriesCount.Enabled := cbSFR.Checked
    and (rbMODFLOW2000.Checked or rbModflow2005.Checked) and cbSFRCalcFlow.Checked;

  {  if cbMOC3D.Checked and rbMODFLOW2000.Checked and not loading
      and not cancelling then
    begin
      Beep;
      MessageDlg('Warning; The MOC3D interface for MODFLOW-2000 is still being '
        + 'tested. You probably should use MODFLOW-96 instead of MODFLOW-2000.',
        mtWarning, [mbOK], 0);
    end;  }
  SetModPathTimeOptions;
  Modflow2000Warnings;
  EnableObsSenParameter;
  SetMode;
  SensitivityWarning;
  if (rbMODFLOW2000.Checked or rbModflow2005.Checked) and not Loading and not cancelling then
  begin
    cbExpDIS.Checked := True;
  end;
  ZoneBudgetWarning;
  MNW_Warning;


end;

procedure TfrmMODFLOW.EnableObsSenParameter;
begin

  cbObservations.Enabled := rbMODFLOW2000.Checked or rbModflow2005.Checked;
  if not cbObservations.Enabled and not loading and not cancelling then
  begin
    cbObservations.Checked := False;
  end;

  cbSensitivity.Enabled := rbMODFLOW2000.Checked;
  if not cbSensitivity.Enabled and not loading and not cancelling then
  begin
    cbSensitivity.Checked := False;
  end;

  cbParamEst.Enabled := rbMODFLOW2000.Checked;
  if not cbParamEst.Enabled and not loading and not cancelling then
  begin
    cbParamEst.Checked := False;
  end;

  rgMode.Enabled := rbMODFLOW2000.Checked;

end;

procedure TfrmMODFLOW.rgModeClick(Sender: TObject);
begin
  inherited;
  if rbMODFLOW2000.Checked and not loading and not cancelling
    and (Sender = rgMode) then
  begin
    SettingMode := True;
    try
      case rgMode.ItemIndex of
        0: //Forward
          begin
            cbObservations.Checked := False;
            cbSensitivity.Checked := False;
            cbParamEst.Checked := False;
          end;
        1: // Forward with Observations
          begin
            cbObservations.Checked := True;
            cbSensitivity.Checked := False;
            cbParamEst.Checked := False;
          end;
        2: // Forward with Parameter-Value Substitution
          begin
            comboSensEst.ItemIndex := 0;
            cbObservations.Checked := False;
            cbSensitivity.Checked := True;
            cbParamEst.Checked := False;
          end;
        3: // Forward with Observations and Parameter-Value Substitution
          begin
            comboSensEst.ItemIndex := 0;
            cbObservations.Checked := True;
            cbSensitivity.Checked := True;
            //          cbParamEst.Checked := False;
          end;
        4: // Parameter Sensitivity
          begin
            if comboSensEst.ItemIndex = 0 then
            begin
              comboSensEst.ItemIndex := 1;
            end;
            cbObservations.Checked := False;
            cbSensitivity.Checked := True;
            cbParamEst.Checked := False;
          end;
        5: // Parameter Sensitivity with Observations
          begin
            if comboSensEst.ItemIndex = 0 then
            begin
              comboSensEst.ItemIndex := 1;
            end;
            cbObservations.Checked := True;
            cbSensitivity.Checked := True;
            cbParamEst.Checked := False;
          end;
        6: // Sensitivity Analysis
          begin
            if comboSensEst.ItemIndex = 0 then
            begin
              comboSensEst.ItemIndex := 1;
            end;
            adeMaxParamEstIterations.Text := '0';
            cbObservations.Checked := True;
            cbSensitivity.Checked := True;
            cbParamEst.Checked := True;
          end;
        7: // Parameter Estimation
          begin
            if comboSensEst.ItemIndex = 0 then
            begin
              comboSensEst.ItemIndex := 1;
            end;
            if StrToInt(adeMaxParamEstIterations.Text) = 0 then
            begin
              adeMaxParamEstIterations.Text := '1';
            end;
            cbObservations.Checked := True;
            cbSensitivity.Checked := True;
            cbParamEst.Checked := True;
          end;
      end;
    finally
      SettingMode := False;
    end;
  end;
end;

procedure TfrmMODFLOW.SetMode;
var
  Mode: integer;
begin
  //  if not loading and not cancelling then
  //  begin
  if rbMODFLOW2000.Checked and not SettingMode then
  begin
    // 0..7
    if cbObservations.Checked then
    begin
      // 1, 3, 5, 6, 7
      if cbSensitivity.Checked then
      begin
        // 3, 5, 6, 7
        if comboSensEst.ItemIndex = 0 then
        begin
          Mode := 3;
        end
        else
        begin
          // 5, 6, 7
          if cbParamEst.Checked then
          begin
            // 6, 7
            if StrToInt(adeMaxParamEstIterations.Text) = 0 then
            begin
              Mode := 6;
            end
            else
            begin
              Mode := 7;
            end;
          end
          else
          begin
            Mode := 5;
          end;
        end;
      end
      else
      begin
        // 1
        if cbParamEst.Checked then
        begin
          Mode := -1;
        end
        else
        begin
          Mode := 1;
        end;
      end;
    end
    else
    begin
      // 0, 2, 4
      if cbSensitivity.Checked then
      begin
        // 2, 4
        if comboSensEst.ItemIndex = 0 then
        begin
          Mode := 2;
        end
        else
        begin
          Mode := 4;
        end;
        if cbParamEst.Checked then
        begin
          Mode := -1;
        end
      end
      else
      begin
        // 0;
        if cbParamEst.Checked then
        begin
          Mode := -1;
        end
        else
        begin
          Mode := 0;
        end;
      end;
    end;
    rgMode.ItemIndex := Mode;
  end;
  //  end;
end;

procedure TfrmMODFLOW.comboSensEstChange(Sender: TObject);
begin
  inherited;
  SetMode;
end;

procedure TfrmMODFLOW.adeMaxParamEstIterationsChange(Sender: TObject);
begin
  inherited;
  SetMode;
  if not loading and not cancelling then
  begin
    if (comboYcintInput <> nil) and (comboYcintInput.ItemIndex > 0)
      and (StrToInt(adeMaxParamEstIterations.Text) <> 0) then
    begin
      comboYcintInput.ItemIndex := 0
    end;
  end;
end;

procedure TfrmMODFLOW.adeMnw2WellScreensExit(Sender: TObject);
begin
  inherited;
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.rgFlowPackageClick(Sender: TObject);
var
  NewChoices: TStringList;
  RowIndex: integer;
  OldChoice: Integer;
  OldChoices: TStringList;
  SimString: string;
begin
  inherited;

  EnableMf2005LpfOptions;
  HUF_HFB_Warning;
  UnsatflowWarning;
  cbSaveHufFlows.Enabled := rgFlowPackage.ItemIndex = 2;
  cbSaveHufHeads.Enabled := rgFlowPackage.ItemIndex = 2;
  cbHUF_ReferenceSurface.Enabled := rgFlowPackage.ItemIndex = 2;
//  cbUZF.Enabled := rgFlowPackage.ItemIndex in [0,1];
  cbUZFClick(Sender);
  OnSfr2IsfroptChange;
  if not cbHUF_ReferenceSurface.Enabled and not Loading and not Cancelling then
  begin
    cbHUF_ReferenceSurface.Checked := False;
  end;

  {  if not Loading and not Cancelling and (rgFlowPackage.ItemIndex <> 0)
      and cbLAK.Checked then
    begin
      Beep;
      if MessageDlg('The current version of the Lake package can only be used '
        + 'with the BCF package.' + #13#10
        + 'Do you want to switch to the BCF package?',
        mtError, [mbYes, mbNo], 0) = mrYes then
      begin
        rgFlowPackage.ItemIndex := 0;
  //      rgFlowPackage.OnClick(rgFlowPackage);
      end;
    end;  }
  tabAdvectionObservations.HandleNeeded;
  tabAdvectionObservations.TabVisible := rgFlowPackage.ItemIndex >= 1;
  if not tabAdvectionObservations.TabVisible and cbAdvObs.Checked then
  begin
    if not Loading and not Cancelling then
    begin
      cbAdvObs.Checked := False;
      Beep;
      MessageDlg('The Advection Observations Package has been turned off '
        + 'because it is incompatible with the BCF package.', mtWarning,
        [mbOK], 0);
    end;
  end;

  framHUF1.Enab := rgFlowPackage.ItemIndex = 2;
  Modflow96Warnings;
  ActivateParametersTab;
  NewChoices := TStringList.Create;
  OldChoices := TStringList.Create;
  try
    OldChoices.Assign(dgGeol.Columns[Ord(nuiType)].PickList);
    if (rgFlowPackage.ItemIndex = 1) then
    begin
      cbFlowBCF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 0);
      cbFlowLPF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 1);
      cbFlowHUF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 2);

      RemoveOldParameters(dgHUFParameters, 0);
      AddNewParameters(dgLPFParameters, 0);
      NewChoices.Add('Confined (0)');
      NewChoices.Add('Convertible (1)');
      if not loading and not cancelling then
      begin
        for RowIndex := 1 to dgGeol.RowCount - 1 do
        begin
          OldChoice := OldChoices.IndexOf(dgGeol.Cells[Ord(nuiType), RowIndex]);
          if OldChoice = 0 then
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] := NewChoices[0];
          end
          else
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] := NewChoices[1];
          end;
        end;
      end;
      dgGeol.Columns[Ord(nuiType)].PickList.Assign(NewChoices);

      OldChoices.Assign(dgGeol.Columns[Ord(nuiTrans)].PickList);
      NewChoices.Clear;
      NewChoices.Add('Harmonic mean (0)');
      NewChoices.Add('Logarithmic mean (1)');
      NewChoices.Add('Arithmetic & Logarithmic (2)');

      if not loading and not cancelling then
      begin
        for RowIndex := 1 to dgGeol.RowCount - 1 do
        begin
          OldChoice := OldChoices.IndexOf(dgGeol.Cells[Ord(nuiTrans),
            RowIndex]);
          if OldChoice = 1 then
          begin
            OldChoice := 2;
          end
          else if OldChoice > 0 then
          begin
            Dec(OldChoice);
          end;
          dgGeol.Cells[Ord(nuiTrans), RowIndex] := NewChoices[OldChoice];
        end;
      end;
    end
    else if (rgFlowPackage.ItemIndex = 2) then
    begin
      cbFlowBCF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 0);
      cbFlowLPF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 1);
      cbFlowHUF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 2);
      RemoveOldParameters(dgLPFParameters, 0);
      AddNewParameters(dgHUFParameters, 0);
      NewChoices.Add('Confined (0)');
      NewChoices.Add('Convertible (1)');
      if not loading and not cancelling then
      begin
        for RowIndex := 1 to dgGeol.RowCount - 1 do
        begin
          OldChoice := OldChoices.IndexOf(dgGeol.Cells[Ord(nuiType), RowIndex]);
          if OldChoice = 0 then
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] := NewChoices[0];
          end
          else
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] := NewChoices[1];
          end;
        end;
      end;
      dgGeol.Columns[Ord(nuiType)].PickList.Assign(NewChoices);

      OldChoices.Assign(dgGeol.Columns[Ord(nuiTrans)].PickList);
      NewChoices.Clear;
      NewChoices.Add('Harmonic mean (0)');

      SimString := dgGeol.Columns[Ord(nuiSim)].Picklist[1];
      if not loading and not cancelling then
      begin
        for RowIndex := 1 to dgGeol.RowCount - 1 do
        begin
          dgGeol.Cells[Ord(nuiTrans), RowIndex] := NewChoices[0];
          dgGeol.Cells[Ord(nuiSim), RowIndex] := SimString;
        end;
      end;
    end
    else
    begin
      cbFlowBCF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 0);
      cbFlowLPF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 1);
      cbFlowHUF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
        and (rgFlowPackage.ItemIndex = 2);
      RemoveOldParameters(dgLPFParameters, 0);
      RemoveOldParameters(dgHUFParameters, 0);
      NewChoices.Add('Confined (0)');
      NewChoices.Add('Unconfined (1)');
      NewChoices.Add('Convertible: const. T (2)');
      NewChoices.Add('Convertible: var. T (3)');
      if not loading and not cancelling then
      begin
        for RowIndex := 1 to dgGeol.RowCount - 1 do
        begin
          OldChoice := OldChoices.IndexOf(dgGeol.Cells[Ord(nuiType), RowIndex]);
          if OldChoice = 0 then
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] := NewChoices[0];
          end
          else
          begin
            dgGeol.Cells[Ord(nuiType), RowIndex] := NewChoices[3];
          end;
        end;
      end;
      dgGeol.Columns[Ord(nuiType)].PickList.Assign(NewChoices);

      OldChoices.Assign(dgGeol.Columns[Ord(nuiTrans)].PickList);
      NewChoices.Clear;
      NewChoices.Add('Harmonic mean (0)');
      NewChoices.Add('Arithmetic mean (1)');
      NewChoices.Add('Logarithmic mean (2)');
      NewChoices.Add('Arithmetic & Logarithmic (3)');

      if not loading and not cancelling then
      begin
        for RowIndex := 1 to dgGeol.RowCount - 1 do
        begin
          OldChoice := OldChoices.IndexOf(dgGeol.Cells[Ord(nuiTrans),
            RowIndex]);
          if OldChoice > 0 then
          begin
            Inc(OldChoice);
          end;
          dgGeol.Cells[Ord(nuiTrans), RowIndex] := NewChoices[OldChoice];
        end;
      end;

    end;
    dgGeol.Columns[Ord(nuiTrans)].PickList.Assign(NewChoices);
  finally
    NewChoices.Free;
    OldChoices.Free;
  end;

  MFLayerStructure.UnIndexedLayers2.AddOrRemoveLayer(
    ModflowTypes.GetMFHUFGroupLayerType,
    rgFlowPackage.ItemIndex = 2);

  ActivateParametersTab;
  SensitivityWarning;
end;

procedure TfrmMODFLOW.SortParamNames;
var
  AStringList: TStringList;
begin
  AStringList := TStringList.Create;
  try
    AStringList.Assign(dgSensitivity.Columns[1].PickList);
    AStringList.Sort;
    dgSensitivity.Columns[1].PickList.Assign(AStringList);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmMODFLOW.dgNegParamExit(Sender: TObject);
var
  Index: integer;
  AStringList: TStringList;
begin
  inherited;
  AddNewParameters(dgLPFParameters, 0);
  AddNewParameters(dgHUFParameters, 0);
  AddNewParameters(dgEVTParametersN, 0);
  AddNewParameters(dgETSParametersN, 0);
  AStringList := TStringList.Create;
  try
    for Index := 1 to dgNegParam.RowCount - 1 do
    begin
      AStringList.Add(dgNegParam.Cells[0, Index]);
    end;
    for Index := dgNegParam.RowCount - 1 downto 1 do
    begin
      if AStringList.IndexOf(dgNegParam.Cells[0, Index]) <> Index - 1 then
      begin
        dgNegParam.DeleteRow(Index);
      end;
    end;
  finally
    AStringList.Free;
  end;

end;

procedure TfrmMODFLOW.dgSensitivitySetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  if (ARow > 0) and (ACol = 7) then
  begin
    try
      if (Value <> '') and (InternationalStrToFloat(Value) <= 0) then
      begin
        Beep;
        MessageDlg('The alternate scaling factor must be greater than 0.)',
          mtError, [mbOK], 0);
        dgSensitivity.Cells[ACol, ARow] := '1.eE-10';
      end;
    except on EConvertError do
      begin
        dgSensitivity.Cells[ACol, ARow] := '1.eE-10';
      end;
    end;

  end;
end;

procedure TfrmMODFLOW.dgPriorEquationsDblClick(Sender: TObject);
begin
  inherited;
  dgPriorEquationsEditButtonClick(Sender);
end;

procedure TfrmMODFLOW.btnTLKRestartFileClick(Sender: TObject);
var
  rootName: string;
  DotPosition: integer;
  OldFilter: string;
begin
  inherited;
  OpenDialog1.InitialDir := GetCurrentDir;
  OldFilter := OpenDialog1.Filter;
  try
    OpenDialog1.Filter := 'TLK restart files (*.tks)|*.tks|All Files (*.*)|*.*';
    if OpenDialog1.Execute then
    begin
      rootName := ExtractFileName(OpenDialog1.FileName);
      edInitial.Text := rootName;
      DotPosition := Pos('.', rootName);
      if DotPosition > 0 then
      begin
        rootName := Copy(rootName, 1, DotPosition - 1);
      end;
      if LowerCase(rootName) = LowerCase(adeFileName.Text) then
      begin
        Beep;
        MessageDlg('Error: The rootname for MODFLOW simulation files (' +
          adeFileName.Text + ') has the same root as the file you have choosen ('
          + edInitial.Text +
          '). You should correct this before running MODFLOW.',
          mtError, [mbOK], 0);
      end;
    end;
  finally
    OpenDialog1.Filter := OldFilter;
  end;
end;

procedure TfrmMODFLOW.btnDeletePumpClick(Sender: TObject);
var
  Page: TJvStandardPage;
  frameMnw2Pump: TControl;
  Node: TTreeNode;
  Index: integer;
begin
  inherited;
  if tvMnw2Pumps.Selected <> nil then
  begin
    tvMnw2Pumps.Items.Delete(tvMnw2Pumps.Selected);
  end;
  Node := tvMnw2Pumps.Items.GetFirstNode;
  for Index := 0 to tvMnw2Pumps.Items.Count - 1 do
  begin
    Page := Node.Data;
    frameMnw2Pump := Page.Controls[0];
    frameMnw2Pump.Name := frameMnw2PumpName(Index+1);
    Node := Node.GetNext;
  end;
end;

function TfrmMODFLOW.frameMnw2PumpName(Value: integer): string;
begin
  result := 'frameMnw2Pump' + IntToStr(Value);
end;

procedure TfrmMODFLOW.framFilePathGWM_ResponseMatrixAsciiedFilePathChange(
  Sender: TObject);
begin
  if not Enabled then
  begin
    framFilePathGWM_ResponseMatrixAscii.edFilePath.Color := clBtnFace;
  end
  else
  begin
    framFilePathGWM_ResponseMatrixAscii.edFilePath.Color := clWindow;
  end
end;

procedure TfrmMODFLOW.framFilePathGWM_ResponseMatrixedFilePathChange(
  Sender: TObject);
begin
  if not Enabled then
  begin
    framFilePathGWM_ResponseMatrix.edFilePath.Color := clBtnFace;
  end
  else
  begin
    if (rgGWM_ResponseMatrix.ItemIndex = 0)
      and not FileExists(framFilePathGWM_ResponseMatrix.edFilePath.Text) then
    begin
      framFilePathGWM_ResponseMatrix.edFilePath.Color := clRed;
    end
    else
    begin
      framFilePathGWM_ResponseMatrix.edFilePath.Color := clWindow;
    end;
  end
end;

procedure TfrmMODFLOW.btnMnw2AddPumpClick(Sender: TObject);
var
  PumpName: string;
begin
  inherited;
  PumpName := 'Pump' + IntToStr(tvMnw2Pumps.Items.Count+1);
  tvMnw2Pumps.Items.Add(nil, PumpName);
end;

procedure TfrmMODFLOW.dgParametersEnter(Sender: TObject);
var
  ADataGrid: TDataGrid;
begin
  inherited;
  ADataGrid := Sender as TDataGrid;
  OldParamNames.Assign(ADataGrid.Cols[0]);
end;

procedure TfrmMODFLOW.adeLPFParamCountEnter(Sender: TObject);
begin
  inherited;
  dg3dLPFParameterClusters.Enabled := False;
end;

procedure TfrmMODFLOW.adeRCHParamCountEnter(Sender: TObject);
begin
  inherited;
  dg3dRCHParameterClusters.Enabled := False;
end;

procedure TfrmMODFLOW.adeEVTParamCountEnter(Sender: TObject);
begin
  inherited;
  dg3dEVTParameterClusters.Enabled := False;

end;

procedure TfrmMODFLOW.ClearUnitNumberStringList;
var
  Index: integer;
begin
  for Index := 0 to UnitNumberStringList.Count - 1 do
  begin
    UnitNumberStringList.Objects[Index].Free;
  end;
  UnitNumberStringList.Clear;
  NextUnitNumber := 7;
end;

function TfrmMODFLOW.GetUnitNumber(FileID: string): integer;
var
  Index: integer;
  GetUnit: TGetUnit;
  Delta: integer;
begin
  Index := UnitNumberStringList.IndexOf(FileID);
  if Index < 0 then
  begin
    GetUnit := TGetUnit.Create;
    UnitNumberStringList.AddObject(FileID, GetUnit);
  end
  else
  begin
    GetUnit := UnitNumberStringList.Objects[Index] as TGetUnit;
  end;
  result := GetUnit.GetUnit;
  if cbIncreaseUnitNumbers.Checked then
  begin
    Delta := StrToInt(adeIncreaseUnitNumbers.Text);
    result := result + Delta;
  end;
end;

function TfrmMODFLOW.GetNUnitNumbers(FileName: string; Count: integer): integer;
var
  Index: integer;
  GetUnit: TGetUnit;
begin
  Index := UnitNumberStringList.IndexOf(FileName);
  if Index < 0 then
  begin
    GetUnit := TGetUnit.Create;
    UnitNumberStringList.AddObject(FileName, GetUnit);
  end
  else
  begin
    GetUnit := UnitNumberStringList.Objects[Index] as TGetUnit;
  end;
  result := GetUnit.GetUnits(Count);
end;

procedure TfrmMODFLOW.SaveUnitNumbers(AStringList: TStringList);
var
  Index: integer;
  GetUnit: TGetUnit;
begin
  if NeedToSaveUnitNumbers then
  begin
    AStringList.Add('UnitNumbers');
    AStringList.Add(IntToStr(UnitNumberStringList.count));
    for Index := 0 to UnitNumberStringList.Count - 1 do
    begin
      GetUnit := UnitNumberStringList.Objects[Index] as TGetUnit;
      AStringList.Add(UnitNumberStringList[Index]);
      AStringList.Add(IntToStr(GetUnit.GetUnit));

    end;
    AStringList.Add(IntToStr(NextUnitNumber));
  end;
end;

function TfrmMODFLOW.ReadUnitNumbers(AStringList: TStringList; Start: integer):
  integer;
var
  Index: integer;
  GetUnit: TGetUnit;
  Count: integer;
  AString: string;
  UnitNumber: integer;
begin
  Assert(AStringList[Start] = 'UnitNumbers');
  Inc(Start);
  Count := StrToInt(AStringList[Start]);
  //  Inc(Start);
  for Index := 0 to Count - 1 do
  begin
    Inc(Start);
    AString := AStringList[Start];
    Inc(Start);
    UnitNumber := StrToInt(AStringList[Start]);
    if UnitNumberStringList.IndexOf(AString) < 0 then
    begin
      GetUnit := TGetUnit.CreateWithUnitNumber(UnitNumber);
      UnitNumberStringList.AddObject(AString, GetUnit);
    end;
  end;
  Inc(Start);
  NextUnitNumber := StrToInt(AStringList[Start]);

  result := Start + 1;
end;

function TfrmMODFLOW.GetNextUnitNumber: integer;
begin
  result := NextUnitNumber;
  Inc(NextUnitNumber);
  if NextUnitNumber in [5,6] then
  begin
    //Units 5 and 6 are standard input and output.
    NextUnitNumber := 7;
  end;
  if NextUnitNumber in [8,9,10] then
  begin
    //Units 8-10 are used by SEAWAT
    NextUnitNumber := 11;
  end;
  if NextUnitNumber in [16,17] then
  begin
    //Units 16 and 17 are used by SEAWAT
    NextUnitNumber := 18;
  end;
  if NextUnitNumber in [95,96,97,98,99,100,101,102,103] then
  begin
    // 95 is used by SEAWAT
    // 96-99 are used by MODFLOW-2000
    // 100 - 103 have special values in MT3DMS and SEAWAT.
    NextUnitNumber := 104;
  end;
  // 199 is used by SEAWAT but this is not considered here.
end;

function TfrmMODFLOW.GetNextNUnitNumber(Count: integer): integer;
begin
  if (NextUnitNumber < 5) and ((NextUnitNumber + Count - 1) >= 5) then
  begin
    NextUnitNumber := 7
  end;
  if (NextUnitNumber < 8) and ((NextUnitNumber + Count - 1) >= 8) then
  begin
    NextUnitNumber := 11;
  end;
  if (NextUnitNumber < 16) and ((NextUnitNumber + Count - 1) >= 16) then
  begin
    NextUnitNumber := 18;
  end;
  if (NextUnitNumber < 95) and ((NextUnitNumber + Count - 1) >= 95) then
  begin
    NextUnitNumber := 104;
  end;
  result := NextUnitNumber;
  Inc(NextUnitNumber, Count);
  if NextUnitNumber in [5,6] then
  begin
    //Units 5 and 6 are standard input and output.
    NextUnitNumber := 7;
  end;
  if NextUnitNumber in [8,9,10] then
  begin
    //Units 8-10 are used by SEAWAT
    NextUnitNumber := 11;
  end;
  if NextUnitNumber in [16,17] then
  begin
    //Units 16 and 17 are used by SEAWAT
    NextUnitNumber := 18;
  end;
  if NextUnitNumber in [95,96,97,98,99,100,101,102,103] then
  begin
    // 95 is used by SEAWAT
    // 96-99 are used by MODFLOW-2000
    // 100 - 103 have special values in MT3DMS and SEAWAT.
    NextUnitNumber := 104;
  end;
end;

procedure TfrmMODFLOW.WriteSpecial(ComponentData: TStringList;
  const IgnoreList: TStringlist; OwningComponent: TComponent);
begin
  SaveUnitNumbers(ComponentData);
end;

procedure TfrmMODFLOW.LoadUnitNumbers(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  LineIndex := ReadUnitNumbers(DataToRead, LineIndex - 1);
end;

procedure TfrmMODFLOW.btnShowTipClick(Sender: TObject);
begin
  inherited;
  Tip;
end;

function TfrmMODFLOW.UsePredictions: boolean;
begin
  result := (comboYcintInput.ItemIndex > 0) and cbParamEst.Checked;
end;

procedure TfrmMODFLOW.comboYcintInputChange(Sender: TObject);
begin
  inherited;
  if not loading and not cancelling then
  begin
    if (comboYcintInput.ItemIndex = 1) and (comboBealeInput.ItemIndex = 2) then
    begin
      comboBealeInput.ItemIndex := 0;
    end;
    if comboYcintInput.ItemIndex > 0 then
    begin
      adeMaxParamEstIterations.Text := '0';
    end;
  end;
end;

procedure TfrmMODFLOW.btnImportClick(Sender: TObject);
var
  OldDefaultExt: string;
  OldFilter: string;
  SensList: TSensList;
  Sens: TSensRecord;
  Index: integer;
  BFile: TStringList;
  ASensObject: TSensObject;
  function ParseLine(ALine: string): boolean;
  begin
    //    result := True;
    result := not (Pos('PARAMETER-VALUE SET', ALine) > 0)
      and not (Pos('FINAL PARAMETER ESTIMATES', ALine) > 0);
    if not result then
      Exit;
    try
      Sens.Name := Trim(Copy(ALine, 1, 10));
      Sens.ISENS := StrToInt(Trim(Copy(ALine, 13, 3)));
      Sens.LN := StrToInt(Trim(Copy(ALine, 18, 3)));
      Sens.B := InternationalStrToFloat(Trim(Copy(ALine, 23, 13)));
      Sens.BL := InternationalStrToFloat(Trim(Copy(ALine, 38, 13)));
      Sens.BU := InternationalStrToFloat(Trim(Copy(ALine, 53, 13)));
      Sens.BSCAL := InternationalStrToFloat(Trim(Copy(ALine, 68, 13)));
    except on EConvertError do
      begin
        result := False;
      end;
    end;
  end;
  function SensListIndexOfName(AName: string): TSensObject;
  var
    Index: integer;
    SensObject: TSensObject;
  begin
    result := nil;
    for Index := 0 to SensList.Count - 1 do
    begin
      SensObject := SensList.Items[Index] as TSensObject;
      if SensObject.Sens.Name = AName then
      begin
        result := SensObject;
        Exit;
      end;
    end;

  end;
begin
  inherited;
  OldDefaultExt := OpenDialog1.DefaultExt;
  OldFilter := OpenDialog1.Filter;
  try
    OpenDialog1.FileName := '';
    OpenDialog1.DefaultExt := '_b';
    OpenDialog1.Filter := '_b files (*._b)|*._b';
    OpenDialog1.InitialDir := GetCurrentDir;
    if OpenDialog1.Execute then
    begin
      BFile := TStringList.Create;
      SensList := TSensList.Create;
      try
        BFile.LoadFromFile(OpenDialog1.FileName);
        for Index := 0 to BFile.Count - 1 do
        begin
          if ParseLine(BFile[Index]) then
          begin
            ASensObject := SensListIndexOfName(Sens.Name);
            if ASensObject = nil then
            begin
              SensList.Add(Sens);
            end
            else
            begin
              ASensObject.Sens := Sens;
            end;
          end;
        end;
        adeSensitivityCount.Text := IntToStr(SensList.Count);
        adeSensitivityCountExit(adeSensitivityCount);
        for Index := 0 to SensList.Count - 1 do
        begin
          ASensObject := SensList.Items[Index] as TSensObject;
          if dgSensitivity.Columns[1].
            PickList.IndexOf(ASensObject.Sens.Name) < 0 then
          begin
            Beep;
            MessageDlg(ASensObject.Sens.Name + ' is not a valid parameter name',
              mtError, [mbOK], 0);
            break;
          end;

          dgSensitivity.Cells[1, Index + 1] := ASensObject.Sens.Name;
          if ASensObject.Sens.ISENS = 0 then
          begin
            dgSensitivity.Cells[2, Index + 1] :=
              dgSensitivity.Columns[2].Picklist[0];
          end
          else
          begin
            dgSensitivity.Cells[2, Index + 1] :=
              dgSensitivity.Columns[2].Picklist[1];
          end;
          if ASensObject.Sens.LN = 0 then
          begin
            dgSensitivity.Cells[3, Index + 1] :=
              dgSensitivity.Columns[3].Picklist[0];
          end
          else
          begin
            dgSensitivity.Cells[3, Index + 1] :=
              dgSensitivity.Columns[3].Picklist[1];
          end;
          dgSensitivity.Cells[4, Index + 1] := FloatToStr(ASensObject.Sens.B);
          dgSensitivity.Cells[5, Index + 1] := FloatToStr(ASensObject.Sens.BL);
          dgSensitivity.Cells[6, Index + 1] := FloatToStr(ASensObject.Sens.BU);
          dgSensitivity.Cells[7, Index + 1] :=
            FloatToStr(ASensObject.Sens.BSCAL);
        end;

      finally
        BFile.Free;
        SensList.Free;
      end;

    end;

  finally
    OpenDialog1.DefaultExt := OldDefaultExt;
    OpenDialog1.Filter := OldFilter;
  end;

end;

procedure TfrmMODFLOW.WrapBtn1Click(Sender: TObject);
begin
  inherited;

end;

// TfrmMODFLOW.FixMOC3D fixes a problem where some old files did not have the
// number of rows in sgMOC3DTransParam set to the correct number.

procedure TfrmMODFLOW.FixMOC3D;
var
  RowIndex, ColIndex, PrevNumUnits: integer;
begin
  inherited;
  if dgGeol.RowCount <> sgMOC3DTransParam.RowCount then
  begin
    PrevNumUnits := sgMOC3DTransParam.RowCount - 1;
    adeMOCNumLayers.Text := IntToStr(dgGeol.RowCount);
    sgMOC3DTransParam.RowCount := dgGeol.RowCount;
    for RowIndex := PrevNumUnits + 1
      to sgMOC3DTransParam.RowCount - 1 do
    begin
      sgMOC3DTransParam.Cells[Ord(trdN), RowIndex]
        := IntToStr(RowIndex);
      for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
      begin
        sgMOC3DTransParam.Cells[ColIndex, RowIndex]
          := sgMOC3DTransParam.Cells[ColIndex, RowIndex - 1];
      end;
    end;
  end;

end;

procedure TfrmMODFLOW.btnModflowImportClick(Sender: TObject);
var
  Done: boolean;
begin
  inherited;
  if NewModel then
  begin
    Beep;
    MessageDlg('Sorry, you can''t import a model yet.  You must first click '
      + 'on the OK button and then select "PIEs|Edit Project Info..." before '
      + 'trying again.', mtInformation, [mbOK], 0);
  end
  else
  begin
    frmModflowImport := nil;   
    try
      Application.CreateForm(TfrmModflowImport, frmModflowImport);
      frmModflowImport.CurrentModelHandle := CurrentModelHandle;
      btnOK.ModalResult := mrNone;
      try
        try
          Hide;
          Done := frmModflowImport.ShowModal = mrOk;
          FreeAndNil(frmModflowImport)
        finally
          Show;
        end;
        //        btnModflowImport.SetFocus;
      finally
        btnOK.ModalResult := mrOK;
      end;

    finally
      frmModflowImport.Free;
      frmModflowImport := nil;
      //      FreeAndNil(frmModflowImport);
    end;
    if Done then
    begin
      btnOKClick(btnOK);
      ModalResult := mrOK;
    end;
  end;

end;

procedure TfrmMODFLOW.Image1DblClick(Sender: TObject);
begin
  inherited;
  lblDebug.Visible := not lblDebug.Visible;
  lblDebugVersion.Visible := not lblDebugVersion.Visible;
end;

function TfrmMODFLOW.FractionForLayer(TopElevGeoUnit, BottomElevGeoUnit,
  TopElevContour, BottomElevContour: double; GeoUnitNumber,
  ModflowLayer: integer): double;
var
  LayersAbove: integer;
  DiscretizationCount: integer;
  LayerTop, LayerBottom: double;
  DiscretizationIndex: integer;
  ContourThickness: double;
begin
  if TopElevContour > TopElevGeoUnit then
  begin
    TopElevContour := TopElevGeoUnit;
  end;
  if BottomElevContour < BottomElevGeoUnit then
  begin
    BottomElevContour := BottomElevGeoUnit;
  end;
  ContourThickness := TopElevContour - BottomElevContour;
  if ContourThickness <= 0 then
  begin
    result := 0;
    Exit;
  end;
  LayersAbove := self.MODFLOWLayersAboveCount(GeoUnitNumber);
  Assert(ModflowLayer > LayersAbove);
  DiscretizationCount := self.DiscretizationCount(GeoUnitNumber);
  Assert(ModflowLayer <= LayersAbove + DiscretizationCount);
  if DiscretizationCount = 1 then
  begin
    result := 1;
  end
  else
  begin
    DiscretizationIndex := ModflowLayer - LayersAbove;
    LayerTop := TopElevGeoUnit -
      ((DiscretizationIndex - 1) / DiscretizationCount
      * (TopElevGeoUnit - BottomElevGeoUnit));
    LayerBottom := TopElevGeoUnit -
      (DiscretizationIndex / DiscretizationCount
      * (TopElevGeoUnit - BottomElevGeoUnit));
    if (BottomElevContour >= LayerTop) or (TopElevContour <= LayerBottom) then
    begin
      result := 0;
      Exit;
    end;
    if TopElevContour > LayerTop then
    begin
      TopElevContour := LayerTop;
    end;
    if BottomElevContour < LayerBottom then
    begin
      BottomElevContour := LayerBottom;
    end;
    result := (TopElevContour - BottomElevContour) / ContourThickness;
  end;
end;

procedure TfrmMODFLOW.adeStreamTableEntriesCountEnter(Sender: TObject);
begin
  inherited;
  PreviousNumberOfStreamTableEntries :=
    StrToInt(adeStreamTableEntriesCount.Text);
end;

procedure TfrmMODFLOW.adeStreamTableEntriesCountExit(Sender: TObject);
var
  AStreamTableLayer: T_ANE_InfoLayer;
  LayerList: T_ANE_IndexedLayerList;
  LayerIndex, ParameterListIndex: integer;
  NewNumberOfStreamTableEntries: integer;
  ParameterList: T_ANE_IndexedParameterList;
begin
  inherited;
  NewNumberOfStreamTableEntries := StrToInt(adeStreamTableEntriesCount.Text);
  for LayerIndex := 0 to MFLayerStructure.ListsOfIndexedLayers.Count - 1 do
  begin
    LayerList := MFLayerStructure.ListsOfIndexedLayers.Items[LayerIndex];
    AStreamTableLayer := LayerList.GetLayerByName(ModflowTypes.
      GetMF2KTableStreamLayerType.ANE_LayerName) as T_ANE_InfoLayer;
    if AStreamTableLayer <> nil then
    begin
      if NewNumberOfStreamTableEntries > PreviousNumberOfStreamTableEntries then
      begin
        for ParameterListIndex := 0 to PreviousNumberOfStreamTableEntries - 1 do
        begin
          if ParameterListIndex < AStreamTableLayer.IndexedParamList1.Count then
          begin
            ParameterList := AStreamTableLayer.IndexedParamList1.Items
              [ParameterListIndex];
            ParameterList.UnDeleteSelf;
          end;
        end;
        for ParameterListIndex := PreviousNumberOfStreamTableEntries to
          NewNumberOfStreamTableEntries - 1 do
        begin
          ModflowTypes.GetMF2KStreamTableParamListType.Create
            (AStreamTableLayer.IndexedParamList1, -1);
        end;
      end
      else
      begin
        for ParameterListIndex := 0 to AStreamTableLayer.IndexedParamList1.Count
          - 1 do
        begin
          ParameterList := AStreamTableLayer.IndexedParamList1.Items
            [ParameterListIndex];
          if ParameterListIndex < NewNumberOfStreamTableEntries then
          begin
            ParameterList.UnDeleteSelf;
          end
          else
          begin
            ParameterList.DeleteSelf;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeSFRParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeSFRParamCount.Text);
  btnDeleteSFR_Parameter.Enabled := ParameterCount > 0;

  sg3dSFRParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgSFRParametersN, ParameterCount);
end;

procedure TfrmMODFLOW.EnableSfrUnsatFlowControls;
begin
  adeSfrTrailigWaveIncrements.Enabled := cbSFR.Checked and cbSfrUnsatflow.Checked;
  adeSfrMaxTrailingWaves.Enabled := cbSFR.Checked and cbSfrUnsatflow.Checked;
  adeSfrMaxUnsatCells.Enabled := cbSFR.Checked and cbSfrUnsatflow.Checked;
end;

procedure TfrmMODFLOW.cbSFRClick(Sender: TObject);
begin
  inherited;
  // Show a warning if the stream and MOC3D are both displayed.
  StreamToleranceWarning;
  StreamWarning;
  Modflow2000Warnings;
//  SFR_Warning;

  EnableGwmStreamVariables;
  ActivateParametersTab;

  EnablecbUzfIRUNFLG;
  cbSfrUnsatflow.Enabled := cbSFR.Checked;
  gbSfr2ISFROPT.Enabled := cbSFR.Checked;
  rbSfr2ByEndpoints.Enabled := cbSFR.Checked;
  rbSfr2ByReach.Enabled := cbSFR.Checked;
  EnableSfrUnsatFlowControls;

  if cbSFR.Checked then
  begin
    AddNewParameters(dgSFRParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgSFRParametersN, 0);
  end;

  // enable or disable options related to streams depending on
  // whether or not streams will be used in the simulation.
  cbSFRCalcFlow.Enabled := cbSFR.Checked;

  comboSFROption.Enabled := cbSFR.Checked;
  SetComboColor(comboSFROption);

  cbSFRRetain.Enabled := cbSFR.Checked;
  lblSFRPrintFlows.Enabled := cbSFR.Checked;

  adeStreamTolerance.Enabled := cbSFR.Checked and not rbModflow96.Checked;
  adeStreamTableEntriesCount.Enabled := cbSFR.Checked
    and not rbModflow96.Checked and cbSFRCalcFlow.Checked;
  cbSFRTrib.Enabled := cbSFR.Checked;
  cbSFRDiversions.Enabled := cbSFR.Checked;
  cbFlowSFR.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbSFR.Checked;
  cbFlowSFR2.Enabled := cbSFR.Checked;

  cbSFRPrintFlows.Enabled := cbSFR.Checked;
  cbKinematicRouting.Enabled := cbSFR.Checked;
  cbKinematicRoutingClick(nil);

  // add or remove the stream layers from the layer structure depending
  // on whether or not streams will be used.
//  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
//    (ModflowTypes.GetMFStreamLayerType, cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMF2KSimpleStreamLayerType, cbSFR.Checked);

  // add or remove grid stream parameter from the grid layer
  // depending on whether streams are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridSFRParamType,
    cbSFR.Checked);

  cbGwmStreamVariablesClick(Sender);
  AddOrRemoveGWM_STRLayers;
  UpdatedUzfLayersAndParameters;

  OnSfr2IsfroptChange;

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

  // add additonal layers, if needed.
  cbSFRCalcFlowClick(Sender);
end;

procedure TfrmMODFLOW.cbSFRCalcFlowClick(Sender: TObject);
begin
  inherited;
  SFR_Warning;

  // enable the user to specify the model units if both streams and selected
  // and stream flow will be calculated
  adeStreamTableEntriesCount.Enabled := cbSFR.Checked
    and not rbModflow96.Checked and cbSFRCalcFlow.Checked;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2K_ICALC_ParamType,
    cbSFRCalcFlow.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2KChanelRoughnessParamType,
    cbSFRCalcFlow.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMF2KTableStreamLayerType,
    cbSFR.Checked and cbSFRCalcFlow.Checked);


  // add or remove the stream slope parameters from the stream layers
  // depending on whether or not streams will be used.
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFStreamSlopeParamType,
     cbStreamCalcFlow.Checked and cbSTR.Checked);   }

  // add or remove the stream roughness parameters from the stream layers
  // depending on whether or not streams will be used.
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMFStreamRoughParamType,
     cbStreamCalcFlow.Checked and cbSTR.Checked);  }

  // associates lists of time-related parameters with dgTime grid.

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridSFRParamType,
    ModflowTypes.GetMFGridSFRParamType.ANE_ParamName, True);

  OnSfr2IsfroptChange;

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbSFRTribClick(Sender: TObject);
begin
  inherited;

  if not Loading and not Cancelling and not cbSFRTrib.Checked then
  begin
    cbSFRDiversions.Checked := False;
  end;

  // add or remove the stream downstream segment number parameters from the
  // stream layers
  // depending on whether or not tributaries will be used.
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMFStreamDownSegNumParamType,
     cbSFRTrib.Checked and cbSFR.Checked); }

    // MF2K
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMFStreamDownSegNumParamType,
    cbSFRTrib.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMFStreamDownSegNumParamType,
    cbSFRTrib.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFStreamDownSegNumParamType,
    cbSFRTrib.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFStreamDownSegNumParamType,
    cbSFRTrib.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.cbSFRDiversionsClick(Sender: TObject);
begin
  inherited;

  if not Loading and not Cancelling and cbSFRDiversions.Checked then
  begin
    cbSFRTrib.Checked := True;
  end;

  // add or remove the stream diversion segment number parameters from the
  // stream layers
  // depending on whether or not diversions will be used.
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMFStreamDivSegNumParamType,
     cbStreamDiversions.Checked and cbSTR.Checked);   }

  // MF2K
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2KStreamDivSegNumParamType,
    cbSFRDiversions.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMF2KStreamDivSegNumParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KStreamDivSegNumParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KStreamDivSegNumParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMF2KStreamPriorityParamType,
    cbSFRDiversions.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMF2KStreamPriorityParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KStreamPriorityParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KStreamPriorityParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KSimpleStreamLayerType,
    ModflowTypes.GetMFGageDiversioParamType,
    cbSFRDiversions.Checked and cbSFR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2K8PointChannelStreamLayerType,
    ModflowTypes.GetMFGageDiversioParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFGageDiversioParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFGageDiversioParamType,
    cbSFRDiversions.Checked and cbSFR.Checked and cbSFRCalcFlow.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.cbSFRPrintFlowsClick(Sender: TObject);
begin
  inherited;
  // The stream package doesn't allow you to both print and save
  // flows simultaneously so act accordingly
  cbFlowSFR.Checked := not cbSFRPrintFlows.Checked;
  cbFlowClick(Sender);
  if not cbFlowSFR.Checked and cbSFR.Checked then
  begin
    if not Loading and not Cancelling then
    begin
      cbSpecifyFlowFiles.Checked := True;
      cbSpecifyFlowFilesClick(Sender);
    end;
  end;
end;

function TfrmMODFLOW.EvaluateADVParameter(const Row: integer): TAdvParameterType;
var
  Position: integer;
begin
  Position := dgADVParameters.Columns[Ord(lppType)].Picklist.
    IndexOf(dgADVParameters.Cells[Ord(lppType), Row]);
  Assert(Position > -1);
  result := TAdvParameterType(Position);
end;

function TfrmMODFLOW.EvaluateHUFParameter(const Row: integer): hufParameterType;
var
  Position: integer;
begin
  Position := dgHUFParameters.Columns[Ord(lppType)].Picklist.
    IndexOf(dgHUFParameters.Cells[Ord(lppType), Row]);
  Assert(Position > -1);
  result := hufParameterType(Position);
end;

function TfrmMODFLOW.EvaluateLPFParameter(const Row: integer): lpfParameterType;
var
  Position: integer;
begin
  Position := dgLPFParameters.Columns[Ord(lppType)].Picklist.
    IndexOf(dgLPFParameters.Cells[Ord(lppType), Row]);
  Assert(Position > -1);
  result := lpfParameterType(Position);
end;

function TfrmMODFLOW.EvaluateZones(const AGrid: TStringGrid;
  const ZoneName: string; const RowIndex: integer): string;
var
  Zones: TStringList;
  ZoneIndex: integer;
  AZone: string;
begin
  Zones := TStringList.Create;
  try

    for ZoneIndex := 3 to AGrid.ColCount - 1 do
    begin
      AZone := Trim(AGrid.Cells[ZoneIndex, RowIndex]);
      if AZone <> '' then
      begin
        Zones.Add(AZone);
      end;
    end;
    if Zones.Count > 0 then
    begin
      result := '';
      for ZoneIndex := 0 to Zones.Count - 1 do
      begin
        if ZoneIndex > 0 then
        begin
          result := result + '|';
        end;
        result := result + '(' + ZoneName + ' Layer' + '=' + Zones[ZoneIndex] +
          ')'
      end;
    end
    else
    begin
      result := '0'
    end;
  finally
    Zones.Free;
  end;

end;

function TfrmMODFLOW.LpfParameter(const AType: lpfParameterType;
  const UnitIndex: integer): string;
var
  RowIndex: integer;
  AGrid: TDataGrid;
  dg3dRowIndex: integer;
  ZoneName, MultName: string;
  UseZone, UseMult: boolean;
  Value: string;
  Entries: TStringList;
  TempValue: string;
  Condition: string;
  EntryIndex: integer;
begin
  Entries := TStringList.Create;
  try
    for RowIndex := 1 to dgLPFParameters.RowCount - 1 do
    begin
      if EvaluateLPFParameter(RowIndex) = AType then
      begin
        if not GetSensitivityValue(dgLPFParameters.Cells[0, RowIndex], Value)
          then
        begin
          Value := dgLPFParameters.Cells[2, RowIndex];
        end;
        AGrid := dg3dLPFParameterClusters.Grids[RowIndex - 1];
        for dg3dRowIndex := 1 to AGrid.RowCount - 1 do
        begin
          if StrToInt(AGrid.Cells[0, dg3dRowIndex]) = UnitIndex then
          begin
            ZoneName := AGrid.Cells[2, dg3dRowIndex];
            MultName := AGrid.Cells[1, dg3dRowIndex];
            UseZone := AGrid.Columns[2].Picklist.IndexOf(ZoneName) > 0;
            UseMult := AGrid.Columns[1].Picklist.IndexOf(MultName) > 0;
            TempValue := Value;
            if UseMult then
            begin
              Application.CreateForm(TfrmMultiplierEditor, frmMultiplierEditor);
              try
                TempValue := '(' + frmMultiplierEditor.ArgusFormula(MultName) +
                  ' * ' + TempValue + ')';
              finally
                frmMultiplierEditor.Free;
                frmMultiplierEditor := nil;
              end;
            end;
            if UseZone then
            begin
              Condition := EvaluateZones(AGrid, ZoneName, dg3dRowIndex);
              TempValue := 'If(' + Condition + ',' + TempValue + ',0)';
            end;
            Entries.Add(TempValue);
          end;
        end;
      end;
    end;
    if Entries.Count = 0 then
    begin
      result := '0';
    end
    else
    begin
      result := '';
      for EntryIndex := 0 to Entries.Count - 1 do
      begin
        if EntryIndex > 0 then
        begin
          result := result + ' + ';
        end;
        result := result + Entries[EntryIndex];
      end;
    end;
  finally
    Entries.Free;
  end;
end;

function TfrmMODFLOW.AdvParameter(const AType: TAdvParameterType;
  const UnitIndex: integer): string;
var
  RowIndex: integer;
  AGrid: TDataGrid;
  dg3dRowIndex: integer;
  ZoneName, MultName: string;
  UseZone, UseMult: boolean;
  Value: string;
  Entries: TStringList;
  TempValue: string;
  Condition: string;
  EntryIndex: integer;
begin
  Entries := TStringList.Create;
  try
    for RowIndex := 1 to dgADVParameters.RowCount - 1 do
    begin
      if EvaluateADVParameter(RowIndex) = AType then
      begin
        if not GetSensitivityValue(dgADVParameters.Cells[0, RowIndex], Value)
          then
        begin
          Value := dgADVParameters.Cells[2, RowIndex];
        end;
        AGrid := dg3dADVParameterClusters.Grids[RowIndex - 1];
        for dg3dRowIndex := 1 to AGrid.RowCount - 1 do
        begin
          if StrToInt(AGrid.Cells[0, dg3dRowIndex]) = UnitIndex then
          begin
            ZoneName := AGrid.Cells[2, dg3dRowIndex];
            MultName := AGrid.Cells[1, dg3dRowIndex];
            UseZone := AGrid.Columns[2].Picklist.IndexOf(ZoneName) > 0;
            UseMult := AGrid.Columns[1].Picklist.IndexOf(MultName) > 0;
            TempValue := Value;
            if UseMult then
            begin
              Application.CreateForm(TfrmMultiplierEditor, frmMultiplierEditor);
              try
                TempValue := '(' + frmMultiplierEditor.ArgusFormula(MultName) +
                  ' * ' + TempValue + ')';
              finally
                frmMultiplierEditor.Free;
                frmMultiplierEditor := nil;
              end;
            end;
            if UseZone then
            begin
              Condition := EvaluateZones(AGrid, ZoneName, dg3dRowIndex);
              TempValue := 'If(' + Condition + ',' + TempValue + ',0)';
            end;
            Entries.Add(TempValue);
          end;
        end;
      end;
    end;
    if Entries.Count = 0 then
    begin
      result := '0';
    end
    else
    begin
      result := '';
      for EntryIndex := 0 to Entries.Count - 1 do
      begin
        if EntryIndex > 0 then
        begin
          result := result + ' + ';
        end;
        result := result + Entries[EntryIndex];
      end;
    end;
  finally
    Entries.Free;
  end;
end;

function TfrmMODFLOW.HufParameter(const AType: hufParameterType;
  const UnitIndex: integer): string;
var
  RowIndex: integer;
  AGrid: TDataGrid;
  dg3dRowIndex: integer;
  ZoneName, MultName: string;
  UseZone, UseMult: boolean;
  Value: string;
  Entries: TStringList;
  TempValue: string;
  Condition: string;
  EntryIndex: integer;
begin
  Entries := TStringList.Create;
  try
    for RowIndex := 1 to dgHUFParameters.RowCount - 1 do
    begin
      if (Loading or Cancelling) and
        (dgHUFParameters.Cells[Ord(lppType), RowIndex] = '') then
      begin
        Continue;
      end;
      if EvaluateHUFParameter(RowIndex) = AType then
      begin
        if not GetSensitivityValue(dgHUFParameters.Cells[0, RowIndex], Value)
          then
        begin
          Value := dgHUFParameters.Cells[2, RowIndex];
        end;
        AGrid := dg3dHUFParameterClusters.Grids[RowIndex - 1];
        for dg3dRowIndex := 1 to AGrid.RowCount - 1 do
        begin
          if StrToInt(AGrid.Cells[0, dg3dRowIndex]) = UnitIndex then
          begin
            ZoneName := AGrid.Cells[2, dg3dRowIndex];
            MultName := AGrid.Cells[1, dg3dRowIndex];
            UseZone := AGrid.Columns[2].Picklist.IndexOf(ZoneName) > 0;
            UseMult := AGrid.Columns[1].Picklist.IndexOf(MultName) > 0;
            TempValue := Value;
            if UseMult then
            begin
              Application.CreateForm(TfrmMultiplierEditor, frmMultiplierEditor);
              try
                TempValue := '(' + frmMultiplierEditor.ArgusFormula(MultName) +
                  ' * ' + TempValue + ')';
              finally
                frmMultiplierEditor.Free;
                frmMultiplierEditor := nil;
              end;
            end;
            if UseZone then
            begin
              Condition := EvaluateZones(AGrid, ZoneName, dg3dRowIndex);
              TempValue := 'If(' + Condition + ',' + TempValue + ',0)';
            end;
            Entries.Add(TempValue);
          end;
        end;
      end;
    end;
    if Entries.Count = 0 then
    begin
      result := '0';
    end
    else
    begin
      result := '';
      for EntryIndex := 0 to Entries.Count - 1 do
      begin
        if EntryIndex > 0 then
        begin
          result := result + ' + ';
        end;
        result := result + Entries[EntryIndex];
      end;
    end;
  finally
    Entries.Free;
  end;

end;

function TfrmMODFLOW.LpfParameterUsed(const AType: lpfParameterType): boolean;
var
  RowIndex: integer;
begin
  result := False;
  if rgFlowPackage.ItemIndex = 1 then
  begin
    for RowIndex := 1 to dgLPFParameters.RowCount - 1 do
    begin
      if EvaluateLPFParameter(RowIndex) = AType then
      begin
        result := True;
        Exit;
      end;
    end;
  end;

end;

function TfrmMODFLOW.HufParameterUsed(
  const AType: hufParameterType): boolean;
var
  RowIndex: integer;
begin
  result := False;
  if rgFlowPackage.ItemIndex = 2 then
  begin
    for RowIndex := 1 to dgHUFParameters.RowCount - 1 do
    begin
      if (Loading or Cancelling) and
        (dgHUFParameters.Cells[Ord(lppType), RowIndex] = '') then
      begin
        Continue;
      end;
      if EvaluateHUFParameter(RowIndex) = AType then
      begin
        result := True;
        Exit;
      end;
    end;
  end;
end;

function TfrmMODFLOW.ADVParameterUsed(
  const AType: TAdvParameterType): boolean;
var
  RowIndex: integer;
begin
  result := False;
  if rgFlowPackage.ItemIndex >= 1 then
  begin
    for RowIndex := 1 to dgADVParameters.RowCount - 1 do
    begin
      if EvaluateADVParameter(RowIndex) = AType then
      begin
        result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.SetMF2K_GWTCaptions;
begin
  if rbModflow96.Checked then
  begin
    cbMOC3D.Caption := 'MOC3D';
    cbMOC3D.Hint := 'MOC3D is used for solute transport';
    tabMOC3D.Caption := 'MOC3D';
    gboxMOC3DSubGrid.Caption := 'MOC3D';
    rgMOC3DSolver.Caption := 'MOC3D Solver';
    gboxMOC3DParticle.Caption := 'MOC3D - Particle information';
    gboxOutput.Caption := 'MOC3D Output';
    lblMOC3DSubgridInfo.Width := 371;
    lblMOC3DSubgridInfo.Caption :=
      'Place contours on the MOC3D Transport Subgrid Layer to define the areal extent of the transport subgrid.';
  end
  else
  begin
    cbMOC3D.Caption := 'Ground-Water Transport (GWT)';
    cbMOC3D.Hint := 'GWT is used for solute transport';
    tabMOC3D.Caption := 'GWT';
    gboxMOC3DSubGrid.Caption := 'GWT';
    rgMOC3DSolver.Caption := 'GWT Solver';
    gboxMOC3DParticle.Caption := 'GWT - Particle information';
    gboxOutput.Caption := 'GWT Output';
    lblMOC3DSubgridInfo.Caption :=
      'Place contours on the GWT Transport Subgrid Layer to define the areal extent of the transport subgrid.';
  end;
  SetHFB_Caption;
  MFLayerStructure.RenameAllLayers := True;

end;

procedure TfrmMODFLOW.cbAdvObsPartDischargeClick(Sender: TObject);
begin
  inherited;
  adeAdvObsDischargeLimit.Enabled := not cbAdvObsPartDischarge.Checked
    and cbAdvObs.Checked;
end;

procedure TfrmMODFLOW.ReadOldCheckDataCheckBox(var LineIndex: integer;
  FirstList,
  IgnoreList: TStringlist;
  DataToRead: TStringList; const VersionControl: TControl);
begin
  Inc(LineIndex);
end;

procedure TfrmMODFLOW.ModPathHNOFLO_Warning;
var
  HNOFLO_Message: string;
  HDry_Message: string;
begin
  if not Loading and not Cancelling then
  begin
    if cbMODPATH.Checked then
    begin
      HNOFLO_Message := '';
      if InternationalStrToFloat(adeHNOFLO.Text) = 0 then
      begin
        HNOFLO_Message := 'Warning HNOFLO (Output tab) = 0.';
      end;
      HDry_Message := '';
      if InternationalStrToFloat(adeHDRY.Text) = 0 then
      begin
        HDry_Message := 'Warning HDRY (Wetting tab) = 0.';
      end;
      if (HNOFLO_Message <> '') or (HDry_Message <> '') then
      begin
        Beep;
        MessageDlg(HNOFLO_Message + #10#13 + HDry_Message + #10#13
          + 'This can cause problems with MODPATH.', mtWarning, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeHDRYExit(Sender: TObject);
begin
  inherited;
  ModPathHNOFLO_Warning;
end;

procedure TfrmMODFLOW.adeHNOFLOExit(Sender: TObject);
begin
  inherited;
  ModPathHNOFLO_Warning;
end;

function TfrmMODFLOW.ModPathReferenceTimeProblem: boolean;
var
  BeginPeriod: integer;
  BeginStep: integer;
  EndPeriod: integer;
  EndStep: integer;
  RefPeriod: integer;
  RefStep: integer;
  RefTime: double;
  PeriodIndex: integer;
  ElapsedTime: double;
  PeriodLength: double;
  StepIndex: integer;
  StepLength: double;
  Multiplier: double;
begin
  result := False;
  if not comboMPATHStartTimeMethod.Enabled then
    Exit;
  BeginPeriod := StrToInt(adeModpathBeginPeriod.Text);
  BeginStep := StrToInt(adeModpathBeginStep.Text);
  EndPeriod := StrToInt(adeModpathEndPeriod.Text);
  EndStep := StrToInt(adeModpathEndStep.Text);
  if (BeginPeriod = 1) and (BeginStep = 1)
    and (EndPeriod = 0) and (EndStep = 0) then
  begin
    Exit;
  end;

  if EndPeriod = 0 then
  begin
    EndPeriod := dgTime.RowCount - 1;
  end;
//  if EndStep = 0 then
//  begin
//    EndStep := StrToInt(dgTime.Cells[Ord(tdNumSteps), EndPeriod]);
//  end;

  RefPeriod := 0;
  RefStep := 0;
  case comboMPATHStartTimeMethod.ItemIndex of
    0: // Stress period and time step (1)
      begin

        RefPeriod := StrToInt(adeMPATHRefPeriod.Text);
        RefStep := StrToInt(adeMPATHRefStep.Text);
      end;
    1: // Simulation time (2)
      begin
        RefTime := InternationalStrToFloat(adeMPATHRefTime.Text);
        ElapsedTime := 0;
        RefPeriod := 0;
        for PeriodIndex := 1 to dgTime.RowCount - 1 do
        begin
          RefPeriod := PeriodIndex;
          PeriodLength := InternationalStrToFloat(dgTime.Cells[Ord(tdLength), RefPeriod]);
          if ElapsedTime + PeriodLength > RefTime then
          begin
            break;
          end;
          ElapsedTime := ElapsedTime + PeriodLength;
        end;

        StepLength := InternationalStrToFloat(dgTime.Cells[Ord(tdFirstStep), RefPeriod]);
        Multiplier := InternationalStrToFloat(dgTime.Cells[Ord(tdMult), RefPeriod]);
        for StepIndex := 1 to StrToInt(dgTime.Cells[Ord(tdNumSteps), RefPeriod])
          do
        begin
          RefStep := StepIndex;
          if StepIndex > 1 then
          begin
            StepLength := StepLength * Multiplier;
          end;
          if ElapsedTime + StepLength > RefTime then
          begin
            break;
          end;
          ElapsedTime := ElapsedTime + StepLength;
        end;
      end;
  else
    Assert(False);
  end;

  if (RefPeriod >= BeginPeriod) and (RefPeriod <= EndPeriod) then
  begin
    result := RefStep > StrToInt(dgTime.Cells[Ord(tdNumSteps), RefPeriod]);
  end
  else
  begin
    result := True;
  end;

end;

function TfrmMODFLOW.ModPathTimeProblem: boolean;
var
  RowIndex: integer;
  TransientPresent, SteadyPresent: boolean;
  FirstRow, LastRow: integer;
begin
  if rbModflow96.Checked then
  begin
    result := False;
  end
  else
  begin
    TransientPresent := False;
    SteadyPresent := False;

    FirstRow := StrToInt(adeModpathBeginPeriod.Text);
    LastRow := StrToInt(adeModpathEndPeriod.Text);
    if LastRow = 0 then
    begin
      LastRow := dgTime.RowCount - 1;
    end;

    for RowIndex := FirstRow to LastRow do
    begin
      if dgTime.Columns[Ord(tdSsTr)].PickList.IndexOf
        (dgTime.Cells[Ord(tdSsTr), RowIndex]) = 0 then
      begin
        TransientPresent := True;
      end
      else
      begin
        SteadyPresent := True;
      end;
    end;

    result := TransientPresent and SteadyPresent;
  end;
end;

function TfrmMODFLOW.ModpathStartingTimeProblem: boolean;
var
  BeginningPeriod: integer;
  BeginningStep: integer;
//  BeginningTime: double;
  EndingPeriod: integer;
  EndingStep: integer;
  EndingTime: double;
  Time: double;
  StartingMovingPeriod: integer;
  StartingMovingStep: integer;
  StartMovingTime: double;
  RemainingTime: double;
begin
  result := false;
  if cbMODPATH.Checked then
  begin
    case rgModpathPeriodStepMethod.ItemIndex of
      0: // period and time steps
        begin
          BeginningPeriod := StrToInt(adeModpathBeginPeriod.Text);
          BeginningStep := StrToInt(adeModpathBeginStep.Text);
          if BeginningStep = 0 then
          begin
            BeginningStep := 1;
          end;

          EndingPeriod := StrToInt(adeModpathEndPeriod.Text);
          if EndingPeriod = 0 then
          begin
            EndingPeriod := dgTime.RowCount -1;
          end;

          EndingStep := StrToInt(adeModpathEndStep.Text);
          if EndingStep = 0 then
          begin
            EndingStep := StrToInt(dgTime.Cells[Ord(tdNumSteps), EndingPeriod]);
          end;

        end;
      1: // absolute times
        begin
          Time := StrToFloat(adeModpathBegin.Text);
          if GetPeriodAndStepFromTime(Time, BeginningPeriod, BeginningStep, True,
            RemainingTime) then
          begin
            Time := StrToFloat(adeModpathEnd.Text);
            if not GetPeriodAndStepFromTime(Time, EndingPeriod, EndingStep, False,
              RemainingTime) then
            begin
              // if the period and step are not found from the time, the last
              // stress period and step will be used.
              Exit;
            end;
          end
          else
          begin
            Exit;
          end;
        end;
    else Assert(False);
    end;
//    BeginningTime := 0;
    EndingTime := StrToFloat(dgTime.Cells[Ord(tdLength), EndingPeriod]);

    case comboMPATHStartTimeMethod.ItemIndex of
      0: // Stress period, time step and time
        begin
          StartingMovingPeriod := StrToInt(adeMPATHRefPeriod.Text);
          StartingMovingStep := StrToInt(adeMPATHRefStep.Text);
          StartMovingTime := StrToFloat(adeMPATHRefTimeInStep.Text);
        end;
      1: // time
        begin
          Time := StrToFloat(adeMPATHRefTime.Text);
          if not GetPeriodAndStepFromTime(Time, StartingMovingPeriod,
            StartingMovingStep, True, StartMovingTime) then
          begin
            Exit;
          end;
        end;
    else Assert(false);
    end;

    case comboMPATHDirection.ItemIndex of
      0: // Forward
        begin
          result := StartingMovingPeriod > EndingPeriod;
          if StartingMovingPeriod = EndingPeriod then
          begin
            result := StartingMovingStep > EndingStep;
            if StartingMovingStep = EndingStep then
            begin
              result := StartMovingTime >= EndingTime;
            end;
          end;
        end;
      1: // backward
        begin
          // With backwards particle tracking, the particle release time is
          // always reset to 0 by MODPATH.  See MODPATH manual p. 3-17.
          result := False;

{          result := StartingMovingPeriod < BeginningPeriod;
          if StartingMovingPeriod = BeginningPeriod then
          begin
            result := StartingMovingStep < BeginningStep;
            if StartingMovingStep = BeginningStep then
            begin
              result := StartMovingTime <= BeginningTime;
            end;
          end;  }
        end;
    else Assert(False);
    end;
  end;
end;

procedure TfrmMODFLOW.ModpathTimeWarning;
begin
  if cbMODPATH.Checked then
  begin
    if ModPathTimeProblem then
    begin
      Beep;
      MessageDlg('Error: Some stress periods between BeginPeriod and EndPeriod '
        + 'are steady-state and others are transient.  If any stress periods '
        + 'in the model are transient only the transient stress periods can be '
        + 'used with MODPATH.  You should adjust BeginPeriod '
        + 'and/or EndPeriod on the "MODPATH" tab to resolve this problem '
        + 'before attempting to run MODPATH.', mtError, [mbOK], 0);
    end;
    if ModPathReferenceTimeProblem then
    begin
      Beep;
      case comboMPATHStartTimeMethod.ItemIndex of
        0: // Stress period and time step (1)
          begin
            MessageDlg('Error: The reference stress period and time step for '
              + 'MODPATH must be between BeginPeriod/BeginStep and '
              + 'EndPeriod/EndStep.  You should adjust the Reference Stess '
              + 'and Reference Time Step on the "MODPATH|Options" tab to '
              + 'resolve this problem '
              + 'before attempting to run MODPATH.', mtError, [mbOK], 0);
          end;
        1: // Simulation time (2)
          begin
            MessageDlg('Error: The Reference Time for '
              + 'MODPATH must be between the times defined by '
              + 'BeginPeriod/BeginStep and '
              + 'EndPeriod/EndStep.  You should adjust the Reference Time '
              + 'on the "MODPATH|Options" tab to '
              + 'resolve this problem '
              + 'before attempting to run MODPATH.', mtError, [mbOK], 0);
          end;
      else
        Assert(False);
      end;
    end;
    if ModpathStartingTimeProblem then
    begin
      Beep;
      case comboMPATHDirection.ItemIndex of
        0: // Forward
          begin
            MessageDlg('The time for releasing particles in MODPATH needs '
              + 'to be before the end of the simulation for the particles to '
              +  'move when forward tracking is used.', mtError, [mbOK], 0);
          end;
        1: // backward
          begin
            MessageDlg('The time for releasing particles in MODPATH needs '
              + 'to be after the beginning of the simulation for the '
              + 'particles to move when backwards tracking is used.',
              mtError, [mbOK], 0);
          end;
      else
        begin
          Assert(False);
        end;
      end;

    end;

  end;
end;

function TfrmMODFLOW.ModPathSteady: integer;
begin
  if rbModflow96.Checked then
  begin
    result := comboSteady.ItemIndex;
  end
  else
  begin
    if IsAnyTransient then
    begin
      result := 0;
    end
    else
    begin
      result := 1;
    end;
  end;
end;

{$IFDEF Debug}

constructor TfrmMODFLOW.Create(AOwner: TComponent);
begin
  WriteDebugOutput('begin TfrmMODFLOW.Create');
  inherited;
  WriteDebugOutput('end TfrmMODFLOW.Create');

end;
{$ENDIF}

procedure TfrmMODFLOW.PageControlSolversChange(Sender: TObject);
begin
  inherited;
  FreePageControlResources(PageControlSolvers, Handle);

end;

procedure TfrmMODFLOW.dg3dChange(Sender: TObject);
begin
  inherited;
  if Sender is TPageControl then
  begin
    FreePageControlResources(TPageControl(Sender), Handle);
  end;

end;

procedure TfrmMODFLOW.dg3dGwmStorageZonesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  AValue: Extended;
begin
  inherited;
  if (ARow > 0) and (ACol = 0) then
  begin
    if Value <> '' then
    begin
      if TryStrToFloat(Value, AValue) then
      begin
        if AValue <> Trunc(AValue) then
        begin
          (Sender as TStringGrid).Cells[ACol,ARow] := IntToStr(Trunc(AValue));
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.btnCalculateDecayClick(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmDecayCalculator, frmDecayCalculator);
  try
    frmDecayCalculator.CurrentModelHandle := CurrentModelHandle;
    frmDecayCalculator.GetData;
    if frmDecayCalculator.ShowModal = mrOK then
    begin
      adeMOC3DDecay.Text := frmDecayCalculator.adeProductionTerm.Text
    end;
  finally
    frmDecayCalculator.Free;
  end;

end;

procedure TfrmMODFLOW.dgMultiplierRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  if (dgMultiplier.RowCount >= 2) and (dgMultiplier.ColCount >= 3) then
  begin
    if dgMultiplier.Cells[2, 1] = dgMultiplier.Columns[2].PickList[1] then
    begin
      dgMultiplier.Cells[2, 1] := dgMultiplier.Columns[2].PickList[0];
      if dgMultiplier.ColCount >= 4 then
      begin
        dgMultiplier.Cells[3, 1] := '1';
      end;
    end;
  end;
  if (dgMultiplier.RowCount >= 2) and (dgMultiplier.ColCount >= 4) then
  begin
    try
      StrToInt(dgMultiplier.Cells[3, 1]);
    except on EConvertError do
      begin
        dgMultiplier.Cells[3, 1] := '1';
      end;
    end;
  end;

end;

function TfrmMODFLOW.GetSensitivityValue(const ParameterName: string;
  var Value: string): boolean;
var
  Index: integer;
begin
  result := False;
  if cbSensitivity.Checked then
  begin
    for Index := 1 to dgSensitivity.RowCount - 1 do
    begin
      if dgSensitivity.Cells[1, Index] = ParameterName then
      begin
        result := True;
        Value := dgSensitivity.Cells[4, Index];
        Exit;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeSTRParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeSTRParamCount.Text);
  btnDeleteSTR_Parameter.Enabled := ParameterCount > 0;
  sg3dSTRParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgSTRParametersN, ParameterCount);
end;

procedure TfrmMODFLOW.cbSpecifyStreamCovariancesClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbSpecifyStreamCovariances.Checked and cbSTR.Checked
    and cbStreamObservations.Checked;
  comboStreamObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboStreamObsPrintFormats);

  adeSTRObsBoundCount.Enabled := ShouldEnable;
  dgSTRObsBoundCovariances.Enabled := ShouldEnable;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter0
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFObservationNumberParamType, ShouldEnable);
end;

procedure TfrmMODFLOW.adeSTRObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeSTRObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgSTRObsBoundCovariances);
end;

procedure TfrmMODFLOW.adeObsSTRTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldStreamObsTimeCount := StrToInt(adeObsSTRTimeCount.Text);
end;

procedure TfrmMODFLOW.adeObsSTRTimeCountExit(Sender: TObject);
var
  NewFluxTimeCount: integer;
  //  FluxList : T_ANE_IndexedLayerList;
  TimeIndex: integer;
  LayerIndex: integer;
  StreamLayer: T_ANE_InfoLayer;
  ParamList: T_ANE_IndexedParameterList;
begin
  inherited;
  NewFluxTimeCount := StrToInt(adeObsSTRTimeCount.Text);
  if NewFluxTimeCount <> OldStreamObsTimeCount then
  begin
    if NewFluxTimeCount > OldStreamObsTimeCount then
    begin
      for TimeIndex := OldStreamObsTimeCount to NewFluxTimeCount - 1 do
      begin
        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList0(
          ModflowTypes.GetMFStreamLayerType,
          ModflowTypes.GetMFStreamObservationParamListType, -1);
      end;
    end
    else
    begin
      for LayerIndex := 0 to UnitCount - 1 do
      begin
        StreamLayer := MFLayerStructure.ListsOfIndexedLayers.Items[LayerIndex].
          GetLayerByName(ModflowTypes.GetMFStreamLayerType.ANE_LayerName) as
          T_ANE_InfoLayer;
        if StreamLayer <> nil then
        begin
          for TimeIndex := OldStreamObsTimeCount - 1 downto NewFluxTimeCount do
          begin
            ParamList := StreamLayer.IndexedParamList0.
              GetNonDeletedIndParameterListByIndex(TimeIndex);
            ParamList.DeleteSelf;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.cbStreamObservationsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbStreamObservations.Checked and cbSTR.Checked;
  adeStrObsErrMult.Enabled := ShouldEnable;
  adeObsSTRTimeCount.Enabled := ShouldEnable;
  cbSpecifyStreamCovariances.Enabled := ShouldEnable;
  adeObsSTRTimeCountEnter(Sender);
  if ShouldEnable then
  begin
    if StrToInt(adeObsSTRTimeCount.Text) = 0 then
    begin
      adeObsSTRTimeCount.Text := '1';
      adeObsSTRTimeCountExit(Sender);
      adeObsSTRTimeCount.Min := 1;
    end;
  end
  else
  begin
    adeObsSTRTimeCount.Min := 0;
    adeObsSTRTimeCount.Text := '0';
    adeObsSTRTimeCountExit(Sender);
  end;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFObjectObservationNameParamClassType, ShouldEnable);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFStatFlagParamType, ShouldEnable);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFPlotSymbolParamType, ShouldEnable);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter0
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFReferenceStressPeriodParamClassType, ShouldEnable);

  cbSpecifyStreamCovariancesClick(Sender);
end;

procedure TfrmMODFLOW.cbETSClick(Sender: TObject);
begin
  inherited;
  ActivateParametersTab;

  if cbETS.Checked then
  begin
    AddNewParameters(dgETSParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgETSParametersN, 0);
  end;

  // enable or disable other controls depending on whether
  // evapotranspiration is active.
  adeIntElev.Enabled := cbETS.Checked;

  comboEtsSteady.Enabled := cbETS.Checked; // steady stress
  SetComboColor(comboEtsSteady);

  comboEtsOption.Enabled := cbETS.Checked; // evapotranspiration option
  SetComboColor(comboEtsOption);

  cbETSRetain.Enabled := cbETS.Checked;
  cbETSLayer.Enabled := cbETS.Checked and (comboEtsOption.ItemIndex = 1);

  // cell-by-cell flows related to evapotranspiration
  cbFlowETS.Enabled := cbETS.Checked;

  // location of MODPATH particles for evapotranspiration
  comboMODPATH_EvapITOP.Enabled := (cbEVT.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked)))
    or (cbETS.Checked and cbMOC3D.Checked and cbBFLX.Checked);
  SetComboColor(comboMODPATH_EvapITOP);

  // add or remove evapotranspiration layer
  // depending on whether evapotranspiration is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFSegmentedETLayerType, cbETS.Checked);

  // add or remove grid evapotranspiration parameters from the grid layer
  // depending on whether evapotranspiration is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridETS_SurfaceParamType,
    cbETS.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridETS_ExtinctDepthParamType,
    cbETS.Checked);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  ETSWarning;
end;

procedure TfrmMODFLOW.cbETSLayerClick(Sender: TObject);
begin
  inherited;
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFSegmentedETLayerType,
    ModflowTypes.GetMFModflowLayerParamType,
    cbETSLayer.Checked and cbETS.Checked and (comboEtsOption.ItemIndex = 1));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridETS_LayerParamType,
    cbETSLayer.Checked and cbETS.Checked and (comboEtsOption.ItemIndex = 1));

  if cbETSLayer.Checked then
  begin
    SpecifyLayerWarning
  end;

end;

procedure TfrmMODFLOW.comboEtsOptionChange(Sender: TObject);
begin
  inherited;
  cbETSLayer.Enabled := cbETS.Checked and (comboEtsOption.ItemIndex = 1);
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  cbETSLayerClick(Sender);

end;

procedure TfrmMODFLOW.adeIntElevExit(Sender: TObject);
var
  NewNumber: integer;
  Index: integer;
  SegEvapLayer: T_ANE_InfoLayer;
begin
  inherited;
  try
    if (adeIntElev.Text <> '') and (MFLayerStructure <> nil) then
    begin
      NewNumber := StrToInt(adeIntElev.Text);
      SegEvapLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetMFSegmentedETLayerType.ANE_LayerName)
        as T_ANE_InfoLayer;
      if SegEvapLayer <> nil then
      begin
        for Index := 0 to NewNumber - 1 do
        begin
          if Index < SegEvapLayer.IndexedParamList0.Count then
          begin
            SegEvapLayer.IndexedParamList0.Items[Index].UnDeleteSelf;
          end
          else
          begin
            ModflowTypes.GetMFSegET_IntermediateDepthsParamListType.Create
              (SegEvapLayer.IndexedParamList0, -1)
          end;
        end;
        for Index := SegEvapLayer.IndexedParamList0.Count - 1 downto NewNumber
          do
        begin
          SegEvapLayer.IndexedParamList0.Items[Index].DeleteSelf;
        end;
      end;
    end;
  except on EConvertError do
    begin
    end;
  end;

end;

procedure TfrmMODFLOW.adeETSParamCountEnter(Sender: TObject);
begin
  inherited;
  dg3dETSParameterClusters.Enabled := False;
end;

procedure TfrmMODFLOW.adeETSParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
  ParamInstanceCount: integer;
begin
  inherited;
  dg3dETSParameterClusters.Enabled := True;
  ParameterCount := StrToInt(adeETSParamCount.Text);
  btnDeleteETS_Parameter.Enabled := ParameterCount > 0;

  ParamInstanceCount := GetInstanceArrayCount(ParameterCount, dgETSParametersN);
  sg3dETSParamInstances.GridCount := ParameterCount;
  if ParamInstanceCount > dg3dETSParameterClusters.PageCount then
  begin
    for Index := dg3dETSParameterClusters.PageCount + 1 to ParamInstanceCount do
    begin
      addParamPage(dg3dETSParameterClusters);
    end;
  end
  else if ParamInstanceCount < dg3dETSParameterClusters.PageCount then
  begin
    for Index := dg3dETSParameterClusters.PageCount - 1 downto ParamInstanceCount
      do
    begin
      dg3dETSParameterClusters.RemoveGrid(Index);
    end;
  end;

  InitializeDataGrid(dgETSParametersN, ParameterCount);

  InitializeMultParamPickLists(dg3dETSParameterClusters);
  InitializeZoneParamPickLists(dg3dETSParameterClusters);

end;

procedure TfrmMODFLOW.SpecifyLayerWarning;
begin
  if not loading and not cancelling then
  begin
    Beep;
    MessageDlg('Be sure to use the "Exact" interpretation method on the '
      + 'layer or layers for which you are specifying the Modflow layer.',
      mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.adeDRTParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
begin
  inherited;
  ParameterCount := StrToInt(adeDRTParamCount.Text);
  btnDeleteDRT_Parameter.Enabled := ParameterCount > 0;

  sg3dDRTParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgDRTParametersN, ParameterCount);
end;

procedure TfrmMODFLOW.cbDRTClick(Sender: TObject);
begin
  inherited;
  EnableAreaDrainReturnContour;
  ActivateParametersTab;

  if cbDRT.Checked then
  begin
    AddNewParameters(dgDRTParametersN, 0);
  end
  else
  begin
    RemoveOldParameters(dgDRTParametersN, 0);
  end;

  cbCondDrnRtn.Enabled := cbDRT.Checked;
  comboDrtSteady.Enabled := cbDRT.Checked; // steady stress
  SetComboColor(comboDrtSteady);

  cbObservationsClick(Sender);

  cbDRTObservations.Enabled := cbDRT.Checked;
  cbDRTObservationsClick(Sender);
  cbDRTRetain.Enabled := cbDRT.Checked;
  cbAltDrt.Enabled := cbDRT.Checked;

  // cell-by-cell flows related to drains
  cbFlowDrt.Enabled := cbDRT.Checked;
  cbUseAreaDrainReturns.Enabled := cbDRT.Checked;

  // add or remove drain return layers
  // depending on whether drain returns are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFPointDrainReturnLayerType, cbDRT.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineDrainReturnLayerType, cbDRT.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFDrainReturnLayerType, cbDRT.Checked);

  // add or remove grid drain return parameter from the grid layer
  // depending on whether drain returns are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridDrainReturnParamType,
    cbDRT.Checked);

  cbUseAreaDrainReturnsClick(Sender);

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  DRTWarning;
end;

procedure TfrmMODFLOW.cbDRTObservationsClick(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbDRTObservations.Checked and cbDRT.Checked;
  adeDrtObsErrMult.Enabled := ShouldEnable;
  adeDRTObsLayerCount.Enabled := ShouldEnable;
  adeObsDRTTimeCount.Enabled := ShouldEnable;
  cbSpecifyDRTCovariances.Enabled := ShouldEnable;
  if ShouldEnable then
  begin
    if StrToInt(adeDRTObsLayerCount.Text) = 0 then
    begin
      adeDRTObsLayerCount.Text := '1';
      adeDRTObsLayerCountExit(Sender);
      adeDRTObsLayerCount.Min := 1;
    end;
  end
  else
  begin
    adeDRTObsLayerCount.Min := 0;
    adeDRTObsLayerCount.Text := '0';
    adeDRTObsLayerCountExit(Sender);
  end;
  cbSpecifyDRTCovariancesClick(Sender);
end;

procedure TfrmMODFLOW.cbSpecifyDRTCovariancesClick(Sender: TObject);
var
  FluxList: T_ANE_IndexedLayerList;
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := cbSpecifyDRTCovariances.Checked and cbDRT.Checked
    and cbDRTObservations.Checked;
  comboDrainReturnObsPrintFormats.Enabled := ShouldEnable;
  SetComboColor(comboDrainReturnObsPrintFormats);

  adeDRTObsBoundCount.Enabled := ShouldEnable;
  dgDRTObsBoundCovariances.Enabled := ShouldEnable;

  FluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgDrainReturnFlux)];
  FluxList.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFDrainReturnFluxObservationsLayerType,
    ModflowTypes.GetMFObservationNumberParamType,
    cbSpecifyDRTCovariances.Checked and cbDRT.Checked
    and cbDRTObservations.Checked);
end;

procedure TfrmMODFLOW.adeDRTObsBoundCountExit(Sender: TObject);
var
  Limit: integer;
begin
  inherited;
  Limit := StrToInt(adeDRTObsBoundCount.Text) + 1;
  ChangeObservationVarianceGridSize(Limit, dgDRTObsBoundCovariances);
end;

procedure TfrmMODFLOW.adeDRTObsLayerCountExit(Sender: TObject);
var
  DrainReturnFluxList: T_ANE_IndexedLayerList;
  NewLayerCount, OldLayerCount: integer;
begin
  inherited;
  DrainReturnFluxList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgDrainReturnFlux)];
  NewLayerCount := StrToInt(adeDRTObsLayerCount.Text);
  OldLayerCount := DrainReturnFluxList.NonDeletedLayerCount;
  AddFluxLayers(NewLayerCount, DrainReturnFluxList,
    ModflowTypes.GetMFDrainReturnFluxObservationsLayerType);
  UpdateUseObsList(clbDrainReturnObservations, OldLayerCount, NewLayerCount);
end;

procedure TfrmMODFLOW.adeObsDRTTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldDrainReturnObsTimeCount := StrToInt(adeObsDRTTimeCount.Text);

end;

procedure TfrmMODFLOW.adeObsDRTTimeCountExit(Sender: TObject);
var
  NewFluxTimeCount: integer;
  FluxList: T_ANE_IndexedLayerList;
begin
  inherited;
  NewFluxTimeCount := StrToInt(adeObsDRTTimeCount.Text);
  if NewFluxTimeCount <> OldDrainReturnObsTimeCount then
  begin
    FluxList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgDrainReturnFlux)];
    AddFluxObsTimes(NewFluxTimeCount, OldDrainReturnObsTimeCount, FluxList,
      ModflowTypes.GetMFDrainReturnFluxObservationParamListType);
  end;
end;

procedure TfrmMODFLOW.combo_AMG_DampingMethodChange(Sender: TObject);
begin
  inherited;
  ade_AMG_DAMP.Enabled := combo_AMG_DampingMethod.ItemIndex = 0;
  ade_AMG_DUP.Enabled := combo_AMG_DampingMethod.ItemIndex = 2;
  ade_AMG_DLOW.Enabled := combo_AMG_DampingMethod.ItemIndex = 2;
end;

procedure TfrmMODFLOW.LmgWarning;
begin
  if not Loading and not Cancelling and not Importing then
  begin
    if rbModflow96.Checked and (rgSolMeth.ItemIndex = 4) then
    begin
      Beep;
      MessageDlg('Warning: The Link-AMG solver is not supported in '
        + 'MODFLOW-96.  You should correct this problem before attempting '
        + 'to run your model.', mtWarning, [mbOK], 0);
    end;
    if (rgSolMeth.ItemIndex = 4) and not LmgWarningShown then
    begin
      LmgWarningShown := True;
      Beep;
      MessageDlg('The GMD - German National Research Center for Information '
        + 'Technology - must be acknowledged in publications for which results '
        + 'were produced using the algebraic multigrid solver.'
        + #13#10#13#10
        + 'In addition, as of version 1.12 of MODFLOW-2000, LMG / AMG '
        + 'can no longer be distributed.  If you do not have a version of '
        + 'MODFLOW that includes LMG / AMG, you should choose another solver.  '
        + 'See the MODFLOW-2000 web page for more details.',
        mtInformation, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.GmgWarning;
begin
  if not Loading and not Cancelling and not Importing then
  begin
    if rbModflow96.Checked and (rgSolMeth.ItemIndex = 5) then
    begin
      Beep;
      MessageDlg('Warning: The GMG solver is not supported in '
        + 'MODFLOW-96.  You should correct this problem before attempting '
        + 'to run your model.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.ETSWarning;
begin
  if not Loading and not Cancelling then
  begin
    if (rbModflow96.Checked) and cbETS.Checked then
    begin
      Beep;
      MessageDlg('Warning: The ETS package is not supported in '
        + 'MODFLOW-96.  You should '
        + 'correct this problem before attempting '
        + 'to run your model.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.DRTWarning;
begin
  if not Loading and not Cancelling then
  begin
    if (rbModflow96.Checked) and cbDRT.Checked then
    begin
      Beep;
      MessageDlg('Warning: The DRT package is not supported in '
        + 'MODFLOW-96.  You should '
        + 'correct this problem before attempting '
        + 'to run your model.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.adeFileNameEnter(Sender: TObject);
begin
  inherited;
  OldRoot := adeFileName.Text;
end;

procedure TfrmMODFLOW.HydmodWarning;
begin
  if cbHYD.Checked and rbModflow96.Checked then
  begin
    Beep;
    MessageDlg('At present the MODFLOW GUI only supports HYDMOD with '
      + 'MODLFOW-2000 and MODFLOW-2005.  '
      + 'You should switch to MODFLOW-2000 or MODFLOW-2005 to use '
      + 'HYDMOD.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.cbHYDClick(Sender: TObject);
begin
  inherited;
  HydmodWarning;
  cbHYDRetain.Enabled := cbHYD.Checked;
  adeHydInactive.Enabled := cbHYD.Checked;

  // add or remove drain layers
  // depending on whether drains are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFHydmodLayerType, cbHYD.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFHydmodStreamStageObservationParamType,
    cbHYD.Checked and cbSTR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFHydmodStreamFlowInObservationParamType,
    cbHYD.Checked and cbSTR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFHydmodStreamFlowOutObservationParamType,
    cbHYD.Checked and cbSTR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFHydmodStreamFlowIntoAquiferObservationParamType,
    cbHYD.Checked and cbSTR.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMFHydmodLabelParamType,
    cbHYD.Checked and cbSTR.Checked);

end;

function TfrmMODFLOW.LpfHaniParametersUsed: boolean;
var
  Index: integer;
begin
  result := False;
  if rgFlowPackage.ItemIndex = 1 then
  begin
    for Index := 1 to dgLPFParameters.RowCount - 1 do
    begin
      if dgLPFParameters.Cells[1, Index] =
        dgLPFParameters.Columns[1].Picklist[6] then
      begin
        result := True;
        Exit;
      end;
    end;
  end;
end;

function TfrmMODFLOW.HufHaniParametersUsed: boolean;
var
  Index: integer;
begin
  result := False;
  if rgFlowPackage.ItemIndex = 2 then
  begin
    for Index := 1 to dgHUFParameters.RowCount - 1 do
    begin
      if dgHUFParameters.Cells[1, Index] =
        dgHUFParameters.Columns[1].Picklist[2] then
      begin
        result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.cbUseAreaRiversClick(Sender: TObject);
begin
  inherited;
  EnableAreaRiverContour;
  // add or remove the area river layers
  // depending on whether rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaRiverLayerType, cbRIV.Checked
    and cbUseAreaRivers.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRiverParamType,
    ModflowTypes.GetMFGridRiverParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.cbUseAreaWellsClick(Sender: TObject);
begin
  inherited;
  EnablecbAreaWellContour;
  // add or remove the area well layers
  // depending on whether wells are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaWellLayerType, cbWEL.Checked
    and cbUseAreaWells.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridWellParamType,
    ModflowTypes.GetMFGridWellParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.cbUseAreaDrainsClick(Sender: TObject);
begin
  inherited;
  EnableAreaDrainContour;
  // add or remove the area drain layers
  // depending on whether drain are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetAreaDrainLayerType, cbDRN.Checked
    and cbUseAreaDrains.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridDrainParamType,
    ModflowTypes.GetMFGridDrainParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.cbUseAreaGHBsClick(Sender: TObject);
begin
  inherited;
  EnableAreaGHBContour;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetAreaGHBLayerType, cbGHB.Checked
    and cbUseAreaGHBs.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridGHBParamType,
    ModflowTypes.GetMFGridGHBParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.cbUseAreaFHBsClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaFHBLayerType, cbFHB.Checked
    and cbUseAreaFHBs.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridFHBParamType,
    ModflowTypes.GetMFGridFHBParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.cbUseAreaDrainReturnsClick(Sender: TObject);
begin
  inherited;
  EnableAreaDrainReturnContour;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaDrainReturnLayerType, cbDRT.Checked
    and cbUseAreaDrainReturns.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridDrainReturnParamType,
    ModflowTypes.GetGridDrainReturnParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.ReadOldParamGrids(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
var
  OldComponentName: string;
  DataGrid: TDataGrid;
  AText: string;
  RowLimit, ColLimit: integer;
  ColIndex, RowIndex: integer;
  CanSelect: boolean;
  FirstStressPeriodColumn: integer;
  NewColumnIndex: integer;
  // FirstStressPeriodColumn is the location of first column
  // with stress period information.
begin
  OldComponentName := DataToRead[LineIndex - 1];
  DataGrid := nil;
  FirstStressPeriodColumn := -1;
  if OldComponentName = 'dgDRNParameters' then
  begin
    DataGrid := dgDRNParametersN;
    FirstStressPeriodColumn := 4;
  end
  else if OldComponentName = 'dgDRTParameters' then
  begin
    DataGrid := dgDRTParametersN;
    FirstStressPeriodColumn := 4;
  end
  else if OldComponentName = 'dgETSParameters' then
  begin
    DataGrid := dgETSParametersN;
    FirstStressPeriodColumn := 5;
  end
  else if OldComponentName = 'dgEVTParameters' then
  begin
    DataGrid := dgEVTParametersN;
    FirstStressPeriodColumn := 5;
  end
  else if OldComponentName = 'dgGHBParameters' then
  begin
    DataGrid := dgGHBParametersN;
    FirstStressPeriodColumn := 4;
  end
  else if OldComponentName = 'dgRCHParameters' then
  begin
    DataGrid := dgRCHParametersN;
    FirstStressPeriodColumn := 5;
  end
  else if OldComponentName = 'dgRIVParameters' then
  begin
    DataGrid := dgRIVParametersN;
    FirstStressPeriodColumn := 4;
  end
  else if OldComponentName = 'dgSFRParameters' then
  begin
    DataGrid := dgSFRParametersN;
    FirstStressPeriodColumn := 4;
  end
  else if OldComponentName = 'dgSTRParameters' then
  begin
    DataGrid := dgSTRParametersN;
    FirstStressPeriodColumn := 4;
  end
  else if OldComponentName = 'dgWELParameters' then
  begin
    DataGrid := dgWELParametersN;
    FirstStressPeriodColumn := 4;
  end
  else
  begin
    Assert(False);
  end;

  Assert(DataGrid <> nil);
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  RowLimit := StrToInt(AText);
  if (DataGrid <> nil) and (DataGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(DataGrid.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(DataGrid.Name) = -1)) then
  begin
    if Assigned(DataGrid.OnEnter) then
    begin
      DataGrid.OnEnter(DataGrid);
    end;
    if SetRows(DataGrid) then
    begin
      DataGrid.RowCount := RowLimit;
    end;
  end;
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ColLimit := StrToInt(AText);
  if (DataGrid <> nil) and (DataGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(DataGrid.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(DataGrid.Name) = -1)) then
  begin
    if SetColumns(DataGrid) then
    begin
      // add an extra column for number of instances of parameters.
      if (DataGrid = dgDRTParametersN) then
      begin
        DataGrid.ColCount := dgTime.RowCount - 1 + 4;
      end
      else
      begin
        DataGrid.ColCount := ColLimit + 1;
      end;
    end;
    for RowIndex := 1 to RowLimit - 1 do
    begin
      DataGrid.Cells[FirstStressPeriodColumn - 1, RowIndex] := '0';
    end;

  end;
  for RowIndex := 0 to RowLimit - 1 do
  begin
    for ColIndex := 0 to ColLimit - 1 do
    begin
      AText := DataToRead[LineIndex];
      Inc(LineIndex);
      if (DataGrid <> nil) and (DataGrid <> VersionControl) and
        ((FirstList = nil) or (FirstList.IndexOf(DataGrid.Name) > -1)) and
        ((IgnoreList = nil) or (IgnoreList.IndexOf(DataGrid.Name) = -1)) then
      begin

        // If this is stress period information, it belongs
        // one column to the right of its former postion.
        if ColIndex >= FirstStressPeriodColumn - 1 then
        begin
          NewColumnIndex := ColIndex + 1;
        end
        else
        begin
          NewColumnIndex := ColIndex;
        end;

        if Assigned(DataGrid.OnSelectCell) then
        begin
          CanSelect := True;
          DataGrid.OnSelectCell(DataGrid, NewColumnIndex, RowIndex, CanSelect);
        end;

        DataGrid.Cells[NewColumnIndex, RowIndex] := AText;

        if Assigned(DataGrid.OnSetEditText) then
        begin
          DataGrid.OnSetEditText(DataGrid, NewColumnIndex, RowIndex, AText);
        end;
      end;
    end;
  end;
  if (DataGrid <> nil) and (DataGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(DataGrid.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(DataGrid.Name) = -1)) then
  begin
    if Assigned(DataGrid.OnExit) then
    begin
      DataGrid.OnExit(DataGrid);
    end;
  end;

end;

function TfrmMODFLOW.GetParamDataGrid(const Sender: TObject):
  TDataGrid;
begin
  if Sender = sg3dWelParamInstances then
  begin
    result := dgWELParametersN;
  end
  else if Sender = sg3dDRNParamInstances then
  begin
    result := dgDRNParametersN;
  end
  else if Sender = sg3dDRTParamInstances then
  begin
    result := dgDRTParametersN;
  end
  else if Sender = sg3dETSParamInstances then
  begin
    result := dgETSParametersN;
  end
  else if Sender = sg3dEVTParamInstances then
  begin
    result := dgEVTParametersN;
  end
  else if Sender = sg3dGHBParamInstances then
  begin
    result := dgGHBParametersN;
  end
  else if Sender = sg3dRCHParamInstances then
  begin
    result := dgRCHParametersN;
  end
  else if Sender = sg3dRIVParamInstances then
  begin
    result := dgRIVParametersN;
  end
  else if Sender = sg3dSFRParamInstances then
  begin
    result := dgSFRParametersN;
  end
  else if Sender = sg3dSTRParamInstances then
  begin
    result := dgSTRParametersN;
  end
  else if Sender = sg3dCHDParamInstances then
  begin
    result := dgCHDParameters;
  end

  else
  begin
    result := nil;
    Assert(False);
  end;
end;

function TfrmMODFLOW.StartTimeColumns(const DataGrid: TDataGrid): integer;
begin
  if (DataGrid = dgWELParametersN) or
    (DataGrid = dgDRNParametersN) or
    (DataGrid = dgDRTParametersN) or
    //    (DataGrid = dgEVTParametersN) or
  (DataGrid = dgGHBParametersN) or
    (DataGrid = dgRIVParametersN) or
    (DataGrid = dgSFRParametersN) or
    (DataGrid = dgSTRParametersN) or
    (DataGrid = dgCHDParameters) then
  begin
    result := 4;
  end
  else if (DataGrid = dgETSParametersN) or
    (DataGrid = dgEVTParametersN) or
    (DataGrid = dgRCHParametersN) then
  begin
    result := 5;
  end
  else
  begin
    result := 0;
    Assert(False);
  end;
end;

procedure TfrmMODFLOW.SetClusterTabCaptions(const ParamGrid: TDataGrid;
  const InstanceGrid: TRBWStringGrid3d; const ClusterGrid: TRBWDataGrid3d);
var
  ParamIndex, InstanceIndex, PageIndex: integer;
  ParamName, InstanceName: string;
  AStringGrid: TStringGrid;
begin
  PageIndex := 0;
  for ParamIndex := 1 to ParamGrid.RowCount - 1 do
  begin
    ParamName := ParamGrid.Cells[0, ParamIndex];
    AStringGrid := InstanceGrid.Grids[ParamIndex - 1];
    if AStringGrid.RowCount > 1 then
    begin
      for InstanceIndex := 1 to AStringGrid.RowCount - 1 do
      begin
        InstanceName := AStringGrid.Cells[0, InstanceIndex];
        if PageIndex < ClusterGrid.PageCount then
        begin
          ClusterGrid.Pages[PageIndex].Caption := ParamName + '.' +
            InstanceName;
        end;
        Inc(PageIndex);
      end;
    end
    else
    begin
      if PageIndex < ClusterGrid.PageCount then
      begin
        ClusterGrid.Pages[PageIndex].Caption := ParamName;
      end;
      Inc(PageIndex);
    end;

  end;

end;

procedure TfrmMODFLOW.sg3dWelParamInstancesSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  DataGrid: TDataGrid;
  NewInstances, UpperCaseInstances: TStringList;
  NewInstance: string;
  AStringGrid: TStringGrid;
  SG3D: TRBWStringGrid3d;
  SGIndex, RowIndex, ColumnIndex, Index: integer;
  InstanceName: string;
  StartColumn: integer;
  ClusterGrid: TRBWDataGrid3D;
begin
  inherited;
  if ARow > 0 then
  begin
    NewInstance := Value;
    if Length(NewInstance) > 10 then
    begin
      NewInstance := Copy(Value, 1, 10);
      (Sender as TStringGrid).Cells[ACol, ARow] := NewInstance;
    end;

    if Pos(' ', NewInstance) > 0 then
    begin
      for Index := 1 to Length(NewInstance) do
      begin
        if NewInstance[Index] = ' ' then
        begin
          NewInstance[Index] := '_';
        end
      end;
      (Sender as TStringGrid).Cells[ACol, ARow] := NewInstance;
    end;

    SG3D := (Sender as TStringGrid).Owner as TRBWStringGrid3d;
    DataGrid := GetParamDataGrid(SG3D);
    ClusterGrid := GetParmClusterGrid(DataGrid);

    NewInstances := TStringList.Create;
    UpperCaseInstances := TStringList.Create;
    try
      NewInstances.Add('No');
      NewInstances.Add('Yes');
      UpperCaseInstances.ADD('NO');
      UpperCaseInstances.ADD('Yes');
      for SGIndex := 0 to SG3D.GridCount - 1 do
      begin
        AStringGrid := SG3D.Grids[SGIndex];
        for RowIndex := 1 to AStringGrid.RowCount - 1 do
        begin
          InstanceName := AStringGrid.Cells[0, RowIndex];
          if UpperCaseInstances.IndexOf(UpperCase(InstanceName)) < 0 then
          begin
            UpperCaseInstances.Add(UpperCase(InstanceName));
            NewInstances.Add(InstanceName);
          end;
        end;
      end;

      StartColumn := StartTimeColumns(DataGrid);

      for ColumnIndex := StartColumn to DataGrid.ColCount - 1 do
      begin
        DataGrid.Columns[ColumnIndex].PickList.Assign(NewInstances);
      end;
    finally
      NewInstances.Free;
      UpperCaseInstances.Free;
    end;

    if ClusterGrid <> nil then
    begin
      SetClusterTabCaptions(DataGrid, SG3D, ClusterGrid);
    end;
  end;
end;

procedure TfrmMODFLOW.CheckInstances;
var
  dataGridList: TList;
  sg3DList: TList;
  GridIndex, ColumnIndex, RowIndex, StartColumn, NameIndex: integer;
  ADataGrid: TDataGrid;
  AParamInstanceGrid: TRBWStringGrid3d;
  AStringGrid: TStringGrid;
  ValidNames: TStringList;
  InstanceCount: integer;
  AName: string;
  PackageNames: TStringList;
  ErrorMessage: string;
begin
  if Importing then Exit;
  dataGridList := TList.Create;
  sg3DList := TList.Create;
  PackageNames := TStringList.Create;
  ValidNames := TStringList.Create;
  try
    if cbDRN.checked and cbDRNRetain.Checked then
    begin
      dataGridList.Add(dgDRNParametersN);
      sg3DList.Add(sg3dDRNParamInstances);
      PackageNames.Add('Drain');
    end;

    if cbDRT.checked and cbDRTRetain.Checked then
    begin
      dataGridList.Add(dgDRTParametersN);
      sg3DList.Add(sg3dDRTParamInstances);
      PackageNames.Add('Drain with Return Flow');
    end;

    if cbETS.checked and cbETSRetain.Checked then
    begin
      dataGridList.Add(dgETSParametersN);
      sg3DList.Add(sg3dETSParamInstances);
      PackageNames.Add('Evapotranspiration Segments');
    end;

    if cbEVT.checked and cbEVTRetain.Checked then
    begin
      dataGridList.Add(dgEVTParametersN);
      sg3DList.Add(sg3dEVTParamInstances);
      PackageNames.Add('Evapotranspiration');
    end;

    if cbGHB.checked and cbGHBRetain.Checked then
    begin
      dataGridList.Add(dgGHBParametersN);
      sg3DList.Add(sg3dGHBParamInstances);
      PackageNames.Add('General Head Boundary');
    end;

    if cbRCH.checked and cbRCHRetain.Checked then
    begin
      dataGridList.Add(dgRCHParametersN);
      sg3DList.Add(sg3dRCHParamInstances);
      PackageNames.Add('Recharge');
    end;

    if cbRIV.checked and cbRIVRetain.Checked then
    begin
      dataGridList.Add(dgRIVParametersN);
      sg3DList.Add(sg3dRIVParamInstances);
      PackageNames.Add('River');
    end;

    if cbSFR.checked and cbSFRRetain.Checked then
    begin
      dataGridList.Add(dgSFRParametersN);
      sg3DList.Add(sg3dSFRParamInstances);
      PackageNames.Add('Streamflow Routing (SFR)');
    end;

    if cbSTR.checked and cbSTRRetain.Checked then
    begin
      dataGridList.Add(dgSTRParametersN);
      sg3DList.Add(sg3dSTRParamInstances);
      PackageNames.Add('Stream (STR)');
    end;

    if cbWEL.checked and cbWELRetain.Checked then
    begin
      dataGridList.Add(dgWELParametersN);
      sg3DList.Add(sg3dWelParamInstances);
      PackageNames.Add('Well');
    end;

    if cbCHD.checked and cbCHDRetain.Checked then
    begin
      dataGridList.Add(dgCHDParameters);
      sg3DList.Add(sg3dCHDParamInstances);
      PackageNames.Add('CHD');
    end;

    for GridIndex := 0 to dataGridList.Count - 1 do
    begin
      ADataGrid := dataGridList[GridIndex];
      AParamInstanceGrid := sg3DList[GridIndex];
      StartColumn := StartTimeColumns(ADataGrid);
      for RowIndex := 1 to ADataGrid.RowCount - 1 do
      begin
        ValidNames.Clear;
        ValidNames.Add('No');
        InstanceCount := StrToInt(ADataGrid.Cells[StartColumn - 1, RowIndex]);
        if InstanceCount <= 1 then
        begin
          ValidNames.Add('Yes');
        end
        else
        begin
          AStringGrid := AParamInstanceGrid.Grids[RowIndex - 1];
          for NameIndex := 1 to AStringGrid.RowCount - 1 do
          begin
            ValidNames.Add(UpperCase(AStringGrid.Cells[0, NameIndex]));
          end;
        end;
        for ColumnIndex := StartColumn to ADataGrid.ColCount - 1 do
        begin
          AName := ADataGrid.Cells[ColumnIndex, RowIndex];
          if ValidNames.IndexOf(UpperCase(AName)) < 0 then
          begin
            ErrorMessage := 'In the "' + PackageNames[GridIndex]
              + '" package, a parameter instance is defined incorrectly '
              + 'for one or more stress periods.  You need to fix this '
              + 'problem before running the model.  The first error recognized '
              + 'is for parameter number ' + IntToStr(RowIndex) + ' ('
              + ADataGrid.Cells[0, RowIndex] + ') in stress period number '
              + IntToStr(ColumnIndex - StartColumn + 1) + '.';
            Beep;
            MessageDlg(ErrorMessage, mtError, [mbOK], 0);
            Exit;
          end;
        end;
      end;
    end;
  finally
    dataGridList.Free;
    sg3DList.Free;
    PackageNames.Free;
    ValidNames.Free;
  end;
end;

procedure TfrmMODFLOW.comboPkgSteadyChange(Sender: TObject);
begin
  inherited;
  FixInstanceCounts;
end;

procedure TfrmMODFLOW.UpdateCaptions;
begin
  SetClusterTabCaptions(dgRCHParametersN, sg3dRCHParamInstances,
    dg3dRCHParameterClusters);
  SetClusterTabCaptions(dgEVTParametersN, sg3dEVTParamInstances,
    dg3dEVTParameterClusters);
  SetClusterTabCaptions(dgETSParametersN, sg3dETSParamInstances,
    dg3dETSParameterClusters);
end;

procedure TfrmMODFLOW.sg3dParamInstancesSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
var
  SG3D: TRBWStringGrid3d;
  DataGrid: TDataGrid;
  ClusterGrid: TRBWDataGrid3D;
begin
  inherited;
  SG3D := (Sender as TStringGrid).Owner as TRBWStringGrid3d;
  DataGrid := GetParamDataGrid(SG3D);
  ClusterGrid := GetParmClusterGrid(DataGrid);
  ClusterGrid.ActivePageIndex := GetPreviousInstances(SG3D.ActivePageIndex + 1,
    DataGrid) + ARow - 1;
end;

procedure TfrmMODFLOW.AddRemoveCHFBParameters;
var
  Index: integer;
  LayerList: T_ANE_IndexedLayerList;
  FirstUnit, LastUnit, UnitNumber: integer;
  ParamShouldBePresent: boolean;
begin

  FirstUnit := StrToInt(adeMOC3DLay1.Text);
  if FirstUnit < 1 then
  begin
    FirstUnit := 1;
  end;
  LastUnit := StrToInt(adeMOC3DLay2.Text);
  if LastUnit < 1 then
  begin
    LastUnit := StrToInt(edNumUnits.Text)
  end;
  for Index := 0 to StrToInt(edNumUnits.Text) - 1 do
  begin
    if Index < MFLayerStructure.ListsOfIndexedLayers.Count then
    begin
      LayerList := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(Index);
      if LayerList <> nil then
      begin
        UnitNumber := Index + 1;
        ParamShouldBePresent := cbHFB.Checked and cbMOC3D.Checked
          and (FirstUnit <= UnitNumber) and (UnitNumber <= LastUnit);

        LayerList.AddOrRemoveUnIndexedParameter(
          ModflowTypes.GetMFHFBLayerType,
          ModflowTypes.GetMFHFBLongDispParamType,
          ParamShouldBePresent);

        LayerList.AddOrRemoveUnIndexedParameter(
          ModflowTypes.GetMFHFBLayerType,
          ModflowTypes.GetMFHFBHorzTransDispParamType,
          ParamShouldBePresent);

        LayerList.AddOrRemoveUnIndexedParameter(
          ModflowTypes.GetMFHFBLayerType,
          ModflowTypes.GetMFHFBVertTransDispParamType,
          ParamShouldBePresent);

        LayerList.AddOrRemoveUnIndexedParameter(
          ModflowTypes.GetMFHFBLayerType,
          ModflowTypes.GetMFHFBDiffusionCoefParamType,
          ParamShouldBePresent);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.SetHFB_Caption;
begin
  if (rbMODFLOW2000.Checked or rbModflow2005.Checked) and cbMOC3D.Checked then
  begin
    cbHFB.Caption := 'HFB and CHFB'
  end
  else
  begin
    cbHFB.Caption := 'HFB'
  end;
end;

procedure TfrmMODFLOW.btnDistributeParticlesClick(Sender: TObject);
var
  Rows, Columns, Layers: integer;
  RowIndex, ColumnIndex, LayerIndex, ParticleIndex: integer;
  DeltaX, DeltaY, DeltaZ: double;
  X, Y, Z: double;
  Xs, Ys, Zs: string;
begin
  inherited;

  Application.CreateForm(TfrmDistributeParticles, frmDistributeParticles);
  try
    frmDistributeParticles.CurrentModelHandle := CurrentModelHandle;
    with frmDistributeParticles do
    begin
      if ShowModal = mrOK then
      begin
        Rows := StrToInt(adeRows.Text);
        Columns := StrToInt(adeCols.Text);
        Layers := StrToInt(adeLayers.Text);

        edMOC3DInitParticles.Text := IntToStr(Rows * Columns * Layers);
        edMOC3DInitParticlesExit(Sender);

        DeltaX := 1 / Columns;
        DeltaY := 1 / Rows;
        DeltaZ := 1 / Layers;

        ParticleIndex := 0;
        for LayerIndex := 1 to Layers do
        begin
          Z := (LayerIndex - 0.5) * DeltaZ - 0.5;
          if Abs(Z) < 1E-6 then
          begin
            Z := 0;
          end;
          Zs := FloatToStr(Z);
          for RowIndex := 1 to Rows do
          begin
            Y := (RowIndex - 0.5) * DeltaY - 0.5;
            if Abs(Y) < 1E-6 then
            begin
              Y := 0;
            end;
            Ys := FloatToStr(Y);
            for ColumnIndex := 1 to Columns do
            begin
              X := (ColumnIndex - 0.5) * DeltaX - 0.5;
              if Abs(X) < 1E-6 then
              begin
                X := 0;
              end;
              Xs := FloatToStr(X);
              Inc(ParticleIndex);
              sgMOC3DParticles.Cells[1, ParticleIndex] := Zs;
              sgMOC3DParticles.Cells[2, ParticleIndex] := Ys;
              sgMOC3DParticles.Cells[3, ParticleIndex] := Xs;
            end;
          end;
        end;
      end;
    end;
  finally
    frmDistributeParticles.Free;
  end;

end;

procedure TfrmMODFLOW.cbCHDClick(Sender: TObject);
begin
  inherited;
  EnableAreaCHDContour;

  CHDWarning;
  ActivateParametersTab;

  if cbCHD.Checked then
  begin
    AddNewParameters(dgCHDParameters, 0);
  end
  else
  begin
    RemoveOldParameters(dgCHDParameters, 0);
  end;

  // enable or disable other controls depending on whether CHD's are active.

  cbCHDRetain.Enabled := cbCHD.Checked;

  cbAltCHD.Enabled := cbCHD.Checked;
  cbUseAreaCHD.Enabled := cbCHD.Checked;

  // add or remove CHD layers
  // depending on whether CHD's are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFPointLineCHD_LayerType, cbCHD.Checked);

  // add or remove grid CHD parameter from the grid layer
  // depending on whether CHD's are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridCHDParamType,
    cbCHD.Checked);

  cbUseAreaCHDClick(Sender);

  // add or remove IFACE parameter from the CHD layer
  // depending on whether CHD and MODPATH are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType, ModflowTypes.GetMFIFACEParamType,
    cbMODPATH.Checked and cbCHD.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType, ModflowTypes.GetMFIFACEParamType,
    cbMODPATH.Checked and cbCHD.Checked and cbUseAreaCHD.Checked);

  // add or remove concentration parameter from the CHD layer
  // depending on whether CHD and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbCHD.Checked);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbMOC3D.Checked and cbCHD.Checked and cbUseAreaCHD.Checked);

  AddOrRemoveSeaWatLayersAndParameters;
  UpdateIFACE;

  // associates lists of time-related parameters with dgTime grid.
  AssociateTimes;
  EnableSSM;
end;

procedure TfrmMODFLOW.cbUseAreaCHDClick(Sender: TObject);
begin
  inherited;
  EnableAreaCHDContour;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaCHD_LayerType, cbCHD.Checked
    and cbUseAreaCHD.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridCHDParamType,
    ModflowTypes.GetMFGridCHDParamType.ANE_ParamName, True);

  AddOrRemoveSeaWatLayersAndParameters;

end;

procedure TfrmMODFLOW.adeCHDParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  //  Index : integer;
  //  ParamInstanceCount : integer;
begin
  inherited;
  ParameterCount := StrToInt(adeCHDParamCount.Text);
  btnDeleteCHD_Parameter.Enabled := ParameterCount > 0;
  sg3dCHDParamInstances.GridCount := ParameterCount;
  InitializeDataGrid(dgCHDParameters, ParameterCount);
end;

procedure TfrmMODFLOW.EnableAreaCHDContour;
begin
  cbAreaCHDContour.Enabled := not cbAltCHD.Checked and cbCHD.Checked
    and cbUseAreaCHD.Checked;
  if cbAltCHD.Enabled and cbAltCHD.Checked and not Loading
    and not Cancelling then
  begin
    cbAreaCHDContour.Checked := False;
  end;
end;


procedure TfrmMODFLOW.cbAltCHDClick(Sender: TObject);
begin
  inherited;
  EnableAreaCHDContour;
  if cbAreaCHDContour.Enabled and not Loading and not Cancelling then
  begin
    cbAreaCHDContour.Checked := True;
  end;

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridCHDParamType,
    ModflowTypes.GetMFGridCHDParamType.ANE_ParamName, True);

end;

procedure TfrmMODFLOW.ZoneBudgetWarning;
begin
  if not loading and not cancelling and (cbZonebudget.Checked or cbMODPATH.Checked) then
  begin
    if rbModflow96.Checked then
    begin
      if cbFlowBudget.Checked then
      begin
        Beep;
        if MessageDlg('You must not use the Compact Budget Option on the '
          + 'Output Files tab when using ZoneBudget version 1 with MODFLOW-96.  '
          + 'Do you want to turn this option off?',
          mtError, [mbYes, mbNo], 0) = mrYes then
        begin
          cbFlowBudget.Checked := False;
        end;
      end;
    end
    else
    begin
      if not cbFlowBudget.Checked then
      begin
        Beep;
        if MessageDlg('You should probably use the Compact Budget Option on the '
          + 'Output Files tab when using ZoneBudget with MODFLOW-2000.  '
          + 'Do you want to turn this option on?',
          mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
          cbFlowBudget.Checked := True;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.cbFlowBudgetClick(Sender: TObject);
begin
  inherited;
  ZoneBudgetWarning;
end;

procedure TfrmMODFLOW.CHDWarning;
begin
  if not Loading and not cancelling and cbCHD.Checked
    and cbCHDRetain.Checked and rbModflow96.Checked then
  begin
    Beep;
    MessageDlg('The Constant-Head Boundary package is not supported by the '
      + 'MODFLOW-GUI for MODFLOW-96.  '
      + 'Try using a MODFLOW-2000 model instead.', mtWarning, [mbOK], 0);
  end;
end;

function TfrmMODFLOW.UpdateHUF_Units: boolean;
var
  Index: integer;
  AName: string;
  Layer: THUFLayer;
  HufUsed: boolean;
  Project: TProjectOptions;
  LayerPointer: ANE_PTR;
  BadLayers: TStringList;
  //  DataGrid : TDataGrid;
begin
  result := True;
  Project := TProjectOptions.Create;
  BadLayers := TStringList.Create;
  try
    HufUsed := rgFlowPackage.ItemIndex = 2;
    for Index := 1 to framHUF1.dgHufUnits.RowCount - 1 do
    begin
      AName := framHUF1.dgHufUnits.Cells[0, Index];
      Layer := framHUF1.dgHufUnits.Objects[0, Index] as THUFLayer;
      LayerPointer := nil;
      if HufUsed then
      begin
        if Layer <> nil then
        begin
          if not NewModel and not (Layer.Status = sNew)
            and (AName <> Layer.WriteOldRoot) then
          begin
            LayerPointer := Project.GetLayerByName(CurrentModelHandle, AName);
          end;
          if LayerPointer = nil then
          begin
            Layer.Rename(AName);
          end
          else
          begin
            result := False;
            BadLayers.Add(AName);
          end;
        end
        else
        begin
          if not NewModel then
          begin
            LayerPointer := Project.GetLayerByName(CurrentModelHandle, AName);
          end;
          if LayerPointer = nil then
          begin
            Layer := ModflowTypes.GetMFHUF_LayerType.Create(AName,
              MFLayerStructure.UnIndexedLayers2, -1);
            framHUF1.dgHufUnits.Objects[0, Index] := Layer;
          end
          else
          begin
            result := False;
            BadLayers.Add(AName);
          end;
        end;
      end
      else
      begin
        if Layer <> nil then
        begin
          Layer.Delete;
          framHUF1.dgHufUnits.Objects[0, Index] := nil;
        end;
      end;
    end;
    if not result then
    begin
      Beep;
      MessageDlg('Error: The following names for geologic units in the '
        + 'HUF package are invalid.  You must correct them.' + #13#10
        + BadLayers.Text, mtError, [mbOK], 0);
    end;
  finally
    Project.Free;
    BadLayers.Free;
  end;
end;

procedure TfrmMODFLOW.adeHUFParamCountEnter(Sender: TObject);
begin
  inherited;
  dg3dHUFParameterClusters.Enabled := False;
end;

procedure TfrmMODFLOW.adeHUFParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
begin
  inherited;
  dg3dHUFParameterClusters.Enabled := True;
  ParameterCount := StrToInt(adeHUFParamCount.Text);
  btnDeleteHUF_Parameter.Enabled := ParameterCount > 0;

  if ParameterCount > dg3dHUFParameterClusters.PageCount then
  begin
    for Index := dg3dHUFParameterClusters.PageCount + 1 to ParameterCount do
    begin
      addParamPage(dg3dHUFParameterClusters);
    end;
  end
  else if ParameterCount < dg3dHUFParameterClusters.PageCount then
  begin
    for Index := dg3dHUFParameterClusters.PageCount - 1 downto ParameterCount do
    begin
      dg3dHUFParameterClusters.RemoveGrid(Index);
    end;
  end;

  InitializeDataGrid(dgHUFParameters, ParameterCount);

  InitializeMultParamPickLists(dg3dHUFParameterClusters);
  InitializeZoneParamPickLists(dg3dHUFParameterClusters);
end;

procedure TfrmMODFLOW.framHUF1dgHufUnitsEnter(Sender: TObject);
begin
  inherited;
  OldHufNames.Assign(framHUF1.dgHufUnits.Cols[0]);
end;

procedure TfrmMODFLOW.framHUF1btnInsertUnitClick(Sender: TObject);
begin
  inherited;
  framHUF1dgHufUnitsEnter(Sender);
  framHUF1.btnInsertUnitClick(Sender);
  OldHufNames.Insert(framHUF1.GeologyRow, framHUF1.dgHufUnits.Cells[0,
    framHUF1.GeologyRow]);
  framHUF1dgHufUnitsExit(Sender);
end;

procedure TfrmMODFLOW.framHUF1btnAddClick(Sender: TObject);
begin
  inherited;
  framHUF1dgHufUnitsEnter(Sender);
  framHUF1.btnAddClick(Sender);
  OldHufNames.Add(framHUF1.dgHufUnits.Cells[0, framHUF1.dgHufUnits.RowCount -
    1]);
  framHUF1dgHufUnitsExit(Sender);
end;

procedure TfrmMODFLOW.framHUF1adeHufUnitCountExit(Sender: TObject);
begin
  inherited;
  framHUF1dgHufUnitsEnter(Sender);
  framHUF1.adeHufUnitCountExit(Sender);
  OldHufNames.Assign(framHUF1.dgHufUnits.Cols[0]);
  //  OldHufNames.Add(framHUF1.dgHufUnits.Cells[0,framHUF1.dgHufUnits.RowCount-1]);
  framHUF1dgHufUnitsExit(Sender);
end;

procedure TfrmMODFLOW.framHUF1btnDeleteUnitClick(Sender: TObject);
begin
  inherited;
  framHUF1dgHufUnitsEnter(Sender);
  framHUF1.btnDeleteUnitClick(Sender);
  OldHufNames.Delete(framHUF1.GeologyRow);
  framHUF1dgHufUnitsExit(Sender);
end;

procedure TfrmMODFLOW.UpdateHufSYTP;
var
  RowIndex: integer;
  GridIndex: integer;
  Grid: TDataGrid;
begin
  for GridIndex := 0 to dg3dHUFParameterClusters.GridCount - 1 do
  begin
    if (Loading or Cancelling) and
      (dgHUFParameters.Cells[Ord(lppType), GridIndex+1] = '') then
    begin
      Continue;
    end;

    Grid := dg3dHUFParameterClusters.Grids[GridIndex];
    if EvaluateHUFParameter(GridIndex+1) <> hufSYTP then
    begin
      Grid.FixedCols := 0;
      Continue;
    end;

    Grid.FixedCols := 1;
    if not loading and not cancelling then
    begin
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        if Grid.Cells[0, RowIndex] <> 'SYTP'then
        begin
          Grid.Cells[0, RowIndex] := 'SYTP';
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.UpdateHufLVDA_Units;
var
  RowIndex: integer;
  GridIndex: integer;
  Grid: TDataGrid;
  NameIndex: integer;
begin
  HufLVDA_Units.Clear;
  for RowIndex := 1 to dgGeol.RowCount -1 do
  begin
    if Simulated(RowIndex) then
    begin
      HufLVDA_Units.Add(IntToStr(RowIndex));
    end;
  end;

  if not loading and not cancelling then
  begin
    for GridIndex := 0 to dg3dHUFParameterClusters.GridCount - 1 do
    begin
      if (Loading or Cancelling) and
        (dgHUFParameters.Cells[Ord(lppType), GridIndex+1] = '') then
      begin
        Continue;
      end;
      if (dgHUFParameters.Cells[Ord(lppType), GridIndex+1] = '') then
      begin
        dgHUFParameters.Cells[Ord(lppType), GridIndex+1] :=
          dgHUFParameters.Columns[Ord(lppType)].PickList[0];
      end;
      if EvaluateHUFParameter(GridIndex+1) <> hufLVDA then
      begin
        Continue;
      end;

      Grid := dg3dHUFParameterClusters.Grids[GridIndex];
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        NameIndex := HufLVDA_Units.IndexOf(Grid.Cells[0, RowIndex]);
        if NameIndex < 0 then
        begin
          Grid.Cells[0, RowIndex] := '1';
        end;
      end;
    end;
  end;

  for GridIndex := 0 to dg3dHUFParameterClusters.GridCount - 1 do
  begin
    if (Loading or cancelling) and
      (dgHUFParameters.Cells[Ord(lppType), GridIndex+1] = '') then
    begin
      Continue;
    end;
    if EvaluateHUFParameter(GridIndex+1) <> hufLVDA then
    begin
      Continue;
    end;
    Grid := dg3dHUFParameterClusters.Grids[GridIndex];
    Grid.Columns[0].Title.Caption := 'Geo Unit';
    Grid.Columns[0].Picklist := HufLVDA_Units;
    if not loading and not cancelling then
    begin
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        NameIndex := NewHufNames.IndexOf(Grid.Cells[0, RowIndex]);
        if NameIndex < 0 then
        begin
          Grid.Cells[0, RowIndex] := '1';
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.framHUF1dgHufUnitsExit(Sender: TObject);
var
  NameIndex: integer;
  GridIndex: integer;
  RowIndex: integer;
  Grid: TDataGrid;
  FirstName: string;
  ParamType: hufParameterType;
begin
  inherited;
  framHUF1.dgHufUnitsExit(Sender);
  NewHufNames.Assign(framHUF1.dgHufUnits.Cols[0]);
  NewHufNames.Delete(0);
  OldHufNames.Delete(0);
  Assert(NewHufNames.Count = OldHufNames.Count);
  for NameIndex := NewHufNames.Count - 1 downto 0 do
  begin
    if NewHufNames[NameIndex] = OldHufNames[NameIndex] then
    begin
      NewHufNames.Delete(NameIndex);
      OldHufNames.Delete(NameIndex);
    end;
  end;
  if (OldHufNames.Count > 0) and not loading and not cancelling then
  begin
    for GridIndex := 0 to dg3dHUFParameterClusters.GridCount - 1 do
    begin
      if (Loading or cancelling) and
        (dgHUFParameters.Cells[Ord(lppType), GridIndex+1] = '') then
      begin
        Continue;
      end;
      ParamType := EvaluateHUFParameter(GridIndex+1);
      if ParamType in [hufSYTP, hufLVDA] then
      begin
        Continue;
      end;

      Grid := dg3dHUFParameterClusters.Grids[GridIndex];
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        NameIndex := OldHufNames.IndexOf(Grid.Cells[0, RowIndex]);
        if NameIndex >= 0 then
        begin
          Grid.Cells[0, RowIndex] := NewHufNames[NameIndex];
        end;
      end;
    end;
  end;

  NewHufNames.Assign(framHUF1.dgHufUnits.Cols[0]);
  NewHufNames.Delete(0);
  if NewHufNames.Count > 0 then
  begin
    FirstName := NewHufNames[0];
  end
  else
  begin
    FirstName := '';
  end;

  for GridIndex := 0 to dg3dHUFParameterClusters.GridCount - 1 do
  begin
    if (Loading or cancelling) and
      (dgHUFParameters.Cells[Ord(lppType), GridIndex+1] = '') then
    begin
      Continue;
    end;
    ParamType := EvaluateHUFParameter(GridIndex+1);
    if ParamType = hufLVDA then
    begin
      Continue;
    end;
    Grid := dg3dHUFParameterClusters.Grids[GridIndex];
    Grid.Columns[0].Title.Caption := 'HUF Unit';
    Grid.Columns[0].Picklist := NewHufNames;
    if not loading and not cancelling and not Importing and (ParamType <> hufSYTP) then
    begin
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        NameIndex := NewHufNames.IndexOf(Grid.Cells[0, RowIndex]);
        if NameIndex < 0 then
        begin
          Grid.Cells[0, RowIndex] := FirstName;
        end;
      end;
    end;
  end;
  framHUF1dgHufUnitsEnter(Sender);
end;

procedure TfrmMODFLOW.EnableSSM;
begin
  if cbRCH.Checked or cbRIV.Checked or cbWEL.Checked or cbDRN.Checked
    or cbGHB.Checked or cbEVT.Checked or cbSTR.Checked or cbRes.Checked
    or cbFHB.Checked or cbCHD.Checked then
  begin
    cbSSM.Checked := True;
    cbSSM.Enabled := False;
  end
  else
  begin
    cbSSM.Enabled := True;
  end;
  if Assigned(cbSSM.OnClick) then
  begin
    cbSSM.OnClick(cbSSM);
  end;
end;

procedure TfrmMODFLOW.sgMT3DTimeSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  inherited;
  if Col = Ord(tdmLength) then
  begin
    CanSelect := False;
  end
  else if Col = Ord(tdmStepSize) then
  begin
    CanSelect := sgMT3DTime.Cells[Ord(tdmCalculated), Row] <> 'Yes';
  end
  else if (Col = Ord(tdmMult)) or (Col = Ord(tdmMax)) then
  begin
    CanSelect := cbGCG.Checked;
  end;
end;

procedure TfrmMODFLOW.comboMT3DAdvSolSchemeChange(Sender: TObject);
begin
  inherited;
  comboMT3DAdvWeightingScheme.Enabled := comboMT3DAdvSolScheme.ItemIndex = 0;
  SetComboColor(comboMT3DAdvWeightingScheme);
  case comboMT3DAdvSolScheme.ItemIndex of
    0:
      begin
        comboMT3DParticleTrackingAlg.Enabled := False;
        adeMT3DConcWeight.Enabled := False;
        adeMT3DMaxParticleCount.Enabled := False;
        adeMT3DNeglSize.Enabled := False;
        adeMT3DInitPartSmall.Enabled := False;
        adeMT3DInitPartLarge.Enabled := False;

        comboMT3DInitPartPlace.Enabled := False;
        adeMT3DParticlePlaneCount.Enabled := False;
        adeMT3DMinPartPerCell.Enabled := False;
        adeMT3DMaxPartPerCell.Enabled := False;
        comboMT3DInitPartSinkChoice.Enabled := False;
        adeMT3DSinkParticlePlaneCount.Enabled := False;
        adeMT3DSinkParticleCount.Enabled := False;
        adeMT3DCritRelConcGrad.Enabled := False;
      end;
    1:
      begin
        comboMT3DParticleTrackingAlg.Enabled := True;
        adeMT3DConcWeight.Enabled := True;
        adeMT3DMaxParticleCount.Enabled := True;
        adeMT3DNeglSize.Enabled := True;
        adeMT3DInitPartSmall.Enabled := True;
        adeMT3DInitPartLarge.Enabled := True;

        comboMT3DInitPartPlace.Enabled := True;
        adeMT3DParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex =
          1);
        adeMT3DMinPartPerCell.Enabled := True;
        adeMT3DMaxPartPerCell.Enabled := True;
        comboMT3DInitPartSinkChoice.Enabled := False;
        adeMT3DSinkParticlePlaneCount.Enabled := False;
        adeMT3DSinkParticleCount.Enabled := False;
        adeMT3DCritRelConcGrad.Enabled := False;
      end;
    2:
      begin
        comboMT3DParticleTrackingAlg.Enabled := True;
        adeMT3DConcWeight.Enabled := True;
        adeMT3DMaxParticleCount.Enabled := False;
        adeMT3DNeglSize.Enabled := False;
        adeMT3DInitPartSmall.Enabled := False;
        adeMT3DInitPartLarge.Enabled := False;

        comboMT3DInitPartPlace.Enabled := False;
        adeMT3DParticlePlaneCount.Enabled := False;
        adeMT3DMinPartPerCell.Enabled := False;
        adeMT3DMaxPartPerCell.Enabled := False;
        comboMT3DInitPartSinkChoice.Enabled := False;
        adeMT3DSinkParticlePlaneCount.Enabled :=
          (comboMT3DInitPartPlace.ItemIndex = 1);
        adeMT3DSinkParticleCount.Enabled := False;
        adeMT3DCritRelConcGrad.Enabled := False;
      end;
    3:
      begin
        comboMT3DParticleTrackingAlg.Enabled := True;
        adeMT3DConcWeight.Enabled := True;
        adeMT3DMaxParticleCount.Enabled := True;
        adeMT3DNeglSize.Enabled := True;
        adeMT3DInitPartSmall.Enabled := True;
        adeMT3DInitPartLarge.Enabled := True;

        comboMT3DInitPartPlace.Enabled := False;
        adeMT3DParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex =
          1);
        adeMT3DMinPartPerCell.Enabled := False;
        adeMT3DMaxPartPerCell.Enabled := False;
        comboMT3DInitPartSinkChoice.Enabled := False;
        adeMT3DSinkParticlePlaneCount.Enabled :=
          (comboMT3DInitPartPlace.ItemIndex = 1);
        adeMT3DSinkParticleCount.Enabled := False;
        adeMT3DCritRelConcGrad.Enabled := False;
      end;
    4:
      begin
        comboMT3DParticleTrackingAlg.Enabled := False; // ITRACK
        adeMT3DConcWeight.Enabled := False; // WD
        adeMT3DMaxParticleCount.Enabled := False; //MXPART
        adeMT3DNeglSize.Enabled := False; // DCEPS
        adeMT3DInitPartSmall.Enabled := False; // NPL
        adeMT3DInitPartLarge.Enabled := False; // NPH

        comboMT3DInitPartPlace.Enabled := False; // NPLANE
        adeMT3DParticlePlaneCount.Enabled := False; // NPLANE
        adeMT3DMinPartPerCell.Enabled := False; // NPMIN
        adeMT3DMaxPartPerCell.Enabled := False; // NPMAX
        comboMT3DInitPartSinkChoice.Enabled := False; // NLSINK
        adeMT3DSinkParticlePlaneCount.Enabled := False;  // NLSINK
        adeMT3DSinkParticleCount.Enabled := False; // NPSINK
        adeMT3DCritRelConcGrad.Enabled := False;  // DCHMOC
      end;
    else Assert(False);
  end;
  SetComboColor(comboMT3DParticleTrackingAlg);
  SetComboColor(comboMT3DInitPartPlace);
  SetComboColor(comboMT3DInitPartSinkChoice);
end;

procedure TfrmMODFLOW.comboMT3DInitPartPlaceChange(Sender: TObject);
begin
  inherited;
  adeMT3DParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);
end;

procedure TfrmMODFLOW.comboMT3DInitPartSinkChoiceChange(Sender: TObject);
begin
  inherited;
  adeMT3DSinkParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex =
    1);
end;

procedure TfrmMODFLOW.MT3DWarning;
begin
  if not Loading and not Cancelling and cbMT3D.Checked then
  begin
    Beep;
    MessageDlg('MT3DMS is not a USGS program; it was developed by Chunmiao '
      + 'Zheng and Patrick Wang at the University of Alabama.  All MT3DMS '
      + 'related questions should be directed to Chunmiao Zheng (czheng@ua.edu).',
      mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.cbMT3DClick(Sender: TObject);
begin
  MT3DWarning;
  tabMT3D.TabVisible := cbMT3D.Checked;

  cbRCTClick(Sender);
  cbSW_MT3D.Enabled := cbMT3D.Checked;
  if not cbSW_MT3D.Enabled then
  begin
    cbSW_MT3D.Checked := False;
  end;
  EnableMt3dBinaryConcFiles;

  ActivateMNWTimeVaryingParameters;

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DDomOutlineLayerType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCRechargeConcLayerType,
    cbRCH.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DInactiveAreaLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCPorosityLayerType, PorosityUsed);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DObservationsLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointInitConcLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaInitConcLayerType, cbMT3D.Checked);

  // parameters

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCPorosityParamType,
    PorosityUsed);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DICBUNDParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DActiveCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DInitConcCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DObsLocCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DLongDispCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetHydraulicCondLayerType,
    ModflowTypes.GetMT3DLongDispParamClassType, cbMT3D.Checked);

  AssociateTimes;
  EnableSSM;
  AddOrRemoveMT3D_ReactionLayers;
  ActivateMNWTimeVaryingParameters;
  AddOrRemoveMT3D_MNW_Parameters;
  cbMt3dMultiDiffusionClick(nil);

  adeConcObsLayerCountExit(Sender);
end;

procedure TfrmMODFLOW.AddOrRemoveMT3D_MNW_Parameters;
var
  ConcCount: integer;
  AllSteady: boolean;
begin
  ConcCount := StrToInt(adeMT3DNCOMP.Text);
  AllSteady := comboMNW_Steady.ItemIndex = 0;

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 1) and
    (AllSteady or not clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc1)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 2) and
    (AllSteady or not clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc2)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 3) and
    (AllSteady or not clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc3)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 4) and
    (AllSteady or not clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc4)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 5) and
    (AllSteady or not clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc4)]));


  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 1) and
    (not AllSteady and clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc1)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 2) and
    (not AllSteady and clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc2)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 3) and
    (not AllSteady and clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc3)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 4) and
    (not AllSteady and clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc4)]));
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbMNW.Checked and (ConcCount >= 5) and
    (not AllSteady and clbMNW_TimeVaryingParameters.Checked[Ord(mnwMt3dConc4)]));
end;

procedure TfrmMODFLOW.cbADVClick(Sender: TObject);
begin
  tabMT3DAdv1.TabVisible := cbADV.Checked;
  tabMT3DAdv2.TabVisible := cbADV.Checked;

end;

procedure TfrmMODFLOW.cbDSPClick(Sender: TObject);
begin
  inherited;
  tabMT3DDisp.TabVisible := cbDSP.Checked;
  cbMt3dMultiDiffusionClick(nil);
end;

procedure TfrmMODFLOW.comboResultsPrintedChange(Sender: TObject);
begin
  inherited;
  adeResultsPrintedN.Enabled := (comboResultsPrinted.ItemIndex = 1);
  sgPrintoutTimes.Enabled := (comboResultsPrinted.ItemIndex = 2);
  if sgPrintoutTimes.Enabled then
  begin
    sgPrintoutTimes.Color := clWindow;
  end
  else
  begin
    sgPrintoutTimes.Color := clInactiveBorder;
  end;
  btmAddMT3DPrintTime.Enabled := sgPrintoutTimes.Enabled;
  btmInsertMT3DPrintTime.Enabled := sgPrintoutTimes.Enabled;
  btmDeleteMT3DPrintTime.Enabled
    := sgPrintoutTimes.Enabled and (sgPrintoutTimes.RowCount > 2);
end;

procedure TfrmMODFLOW.cbPrintConcClick(Sender: TObject);
begin
  inherited;
  comboConcentrationFormat.Enabled := cbPrintConc.Checked;
  SetComboColor(comboConcentrationFormat);
end;

procedure TfrmMODFLOW.cbPrintRetardationClick(Sender: TObject);
begin
  inherited;
  comboRetardationFormat.Enabled := cbPrintRetardation.Checked;
  SetComboColor(comboRetardationFormat);
end;

procedure TfrmMODFLOW.cbPrintDispCoefClick(Sender: TObject);
begin
  inherited;
  comboDispersionFormat.Enabled := cbPrintDispCoef.Checked;
  SetComboColor(comboDispersionFormat);
end;

procedure TfrmMODFLOW.cbPrintNumParticlesClick(Sender: TObject);
begin
  inherited;
  comboParticlePrintFormat.Enabled := cbPrintNumParticles.Checked;
  SetComboColor(comboParticlePrintFormat);
end;

procedure TfrmMODFLOW.sgReactionSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  inherited;
  {
    MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
      rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp, rdmDualPorosity,
      rdmStartingConcentration);
  }
  if not cbMT3D_OneDArrays.Checked then
  begin
    CanSelect := False;
    Exit;
  end;

  if Col >= 9 then
  begin
    while Col >= 9 do
    begin
      Col := Col - 5;
    end;
    if Col = 4 then
    begin
      Col := Ord(rdmSorpConst1);
    end
    else if Col = 5 then
    begin
      Col := Ord(rdmSorpConst2);
    end
    else if Col = 6 then
    begin
      Col := Ord(rdmRateConstDiss);
    end
    else if Col = 7 then
    begin
      Col := Ord(rdmRateConstSorp);
    end
    else if Col = 8 then
    begin
      Col := Ord(rdmStartingConcentration);
    end
  end;

  if Col = Ord(rdmName) then
  begin
    CanSelect := False;
  end
  else if Col = Ord(rdmBulkDensity) then
  begin
    CanSelect := (comboMT3DIsotherm.ItemIndex > 0)
      and (comboMT3DIsotherm.ItemIndex <> 5);
  end
  else if Col = Ord(rdmSorpConst1) then
  begin
    CanSelect := comboMT3DIsotherm.ItemIndex > 0;
  end
  else if Col = Ord(rdmSorpConst2) then
  begin
    // SP2 is read but not used if ISOTHM = 1;
    CanSelect := comboMT3DIsotherm.ItemIndex > 1;
  end
  else if (Col = Ord(rdmRateConstDiss)) or (Col = Ord(rdmRateConstSorp)) then
  begin
    CanSelect := comboMT3DIREACT.ItemIndex > 0;
  end
  else if Col = Ord(rdmDualPorosity) then
  begin
    CanSelect := comboMT3DIsotherm.ItemIndex >= 5;
  end
  else if Col = Ord(rdmStartingConcentration) then
  begin
    // for ISOTHM <= 3, always set IGETSC to 1.
    CanSelect := cbMT3D_StartingConcentration.Checked
      and (comboMT3DIsotherm.ItemIndex >= 4);
  end
end;

procedure TfrmMODFLOW.comboMT3DIsothermChange(Sender: TObject);
begin
  inherited;

  cbMT3D_StartingConcentration.Enabled := comboMT3DIsotherm.ItemIndex >= 4;
  if not cbMT3D_StartingConcentration.Enabled then
  begin
    cbMT3D_StartingConcentration.Checked := False;
  end;

  AddOrRemoveMT3D_ReactionLayers;

  sgReaction.Invalidate;
end;

procedure TfrmMODFLOW.comboMT3DIREACTChange(Sender: TObject);
begin
  inherited;
  sgReaction.Invalidate;
  AddOrRemoveMT3D_ReactionLayers;
end;

procedure TfrmMODFLOW.cbRCTClick(Sender: TObject);
begin
  inherited;
  tabMT3DChem.TabVisible := cbRCT.Checked;
  AddOrRemoveMT3D_ReactionLayers;
end;

procedure TfrmMODFLOW.sgMT3DTimeExit(Sender: TObject);
var
  RowIndex, ColIndex: integer;
begin
  inherited;
  for RowIndex := sgMT3DTime.FixedRows to sgMT3DTime.RowCount - 1 do
  begin
    for ColIndex := sgMT3DTime.FixedCols to sgMT3DTime.ColCount - 1 do
    begin
      if sgMT3DTime.Cells[ColIndex, RowIndex] = '' then
      begin
        sgMT3DTime.Cells[ColIndex, RowIndex] := '0';
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.sgDispersionOldSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  {  if (ACol > 1) and (ARow > 0) then
    begin
      if not (sgDispersion.Cells[ACol,ARow] = '') then
      begin
        try
          begin
            StrToFloat(sgDispersion.Cells[ACol,ARow]) ;
          end;
        except on EConvertError do
          begin
              sgDispersion.Cells[ACol,ARow] := PreviousMT3DDispText;
          end;
        end;
      end;
    end;   }

end;

procedure TfrmMODFLOW.btmAddMT3DPrintTimeClick(Sender: TObject);
{var
  CurrentRow : Integer;
  RowIndex, ColIndex : integer;   }
begin
  inherited;
  sgPrintoutTimes.RowCount := sgPrintoutTimes.RowCount + 1;
  sgPrintoutTimes.Cells[Ord(ptmN), sgPrintoutTimes.RowCount - 1]
    := IntToStr(sgPrintoutTimes.RowCount - 1);
  sgPrintoutTimes.Cells[Ord(ptmTime), sgPrintoutTimes.RowCount - 1]
    := sgPrintoutTimes.Cells[1, sgPrintoutTimes.RowCount - 2];
  btmDeleteMT3DPrintTime.Enabled
    := sgPrintoutTimes.Enabled and (sgPrintoutTimes.RowCount > 2);
  {  btmAddMT3DPrintTimeClick(Sender);
    CurrentRow := sgPrintoutTimes.Selection.Top;

    for RowIndex := sgReaction.RowCount -2 downto CurrentRow do
    begin
      sgPrintoutTimes.Cells[Ord(ptmN),RowIndex] := IntToStr(RowIndex);
      for ColIndex := 1 to sgPrintoutTimes.ColCount -1 do
      begin
        sgPrintoutTimes.Cells[ColIndex,RowIndex +1] := sgPrintoutTimes.Cells[ColIndex,RowIndex];
      end;
    end;}
end;

procedure TfrmMODFLOW.btmDeleteMT3DPrintTimeClick(Sender: TObject);
var
  CurrentRow: Integer;
  RowIndex, ColIndex: integer;
begin
  inherited;
  CurrentRow := sgPrintoutTimes.Selection.Top;

  for RowIndex := CurrentRow + 1 to sgPrintoutTimes.RowCount - 1 do
  begin
    for ColIndex := 1 to sgPrintoutTimes.ColCount - 1 do
    begin
      sgPrintoutTimes.Cells[ColIndex, RowIndex - 1] :=
        sgPrintoutTimes.Cells[ColIndex, RowIndex];
    end;
  end;
  sgPrintoutTimes.RowCount := sgPrintoutTimes.RowCount - 1;
  btmDeleteMT3DPrintTime.Enabled
    := sgPrintoutTimes.Enabled and (sgPrintoutTimes.RowCount > 2);
end;

procedure TfrmMODFLOW.sgDispersionExit(Sender: TObject);
var
  RowIndex, ColIndex: integer;
begin
  inherited;
  for RowIndex := sgDispersion.FixedRows to sgDispersion.RowCount - 1 do
  begin
    for ColIndex := Ord(ddmHorDisp) to sgDispersion.ColCount - 1 do
    begin
      if sgDispersion.Cells[ColIndex, RowIndex] = '' then
      begin
        sgDispersion.Cells[ColIndex, RowIndex] := '0';
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.sgPrintoutTimesExit(Sender: TObject);
var
  RowIndex, ColIndex, RowIndex2: integer;
  TempString: string;
begin
  inherited;
  for RowIndex := sgPrintoutTimes.FixedRows to sgPrintoutTimes.RowCount - 1 do
  begin
    for ColIndex := sgPrintoutTimes.FixedCols to sgPrintoutTimes.ColCount - 1 do
    begin
      if sgPrintoutTimes.Cells[ColIndex, RowIndex] = '' then
      begin
        sgPrintoutTimes.Cells[ColIndex, RowIndex] := '0';
      end;
    end;
  end;
  for RowIndex := sgPrintoutTimes.FixedRows to sgPrintoutTimes.RowCount - 2 do
  begin
    for RowIndex2 := RowIndex + 1 to sgPrintoutTimes.RowCount - 1 do
    begin
      if InternationalStrToFloat(sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex]) >
      InternationalStrToFloat(sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex2]) then
      begin
        TempString := sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex];
        sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex]
          := sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex2];
        sgPrintoutTimes.Cells[Ord(ptmTime), RowIndex2] := TempString;
      end;
    end
  end;
end;

procedure TfrmMODFLOW.ReadOldStream(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
begin
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbSTR, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldStreamDiv(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
begin
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbStreamDiversions, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldStreamICALC(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
begin
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbStreamCalcFlow, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldStreamModelUnits(var LineIndex: integer;
  FirstList, IgnoreList, DataToRead: TStringList;
  const VersionControl: TControl);
begin
  ReadComboBox(LineIndex, FirstList, IgnoreList, comboModelUnits, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldGWM_SLPITPRT(var LineIndex: integer;
  FirstList, IgnoreList, DataToRead: TStringList;
  const VersionControl: TControl);
begin
  ReadComboBox(LineIndex, FirstList, IgnoreList, comboGWM_SLPITPRT, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldStreamSteady(var LineIndex: integer;
  FirstList, IgnoreList, DataToRead: TStringList;
  const VersionControl: TControl);
begin
  ReadComboBox(LineIndex, FirstList, IgnoreList, comboStreamOption, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldStreamTrib(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
begin
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbStreamTrib, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldStreamPrint(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
begin
  ReadCheckBox(LineIndex, FirstList, IgnoreList, cbStrPrintFlows, DataToRead,
    VersionControl);
end;

procedure TfrmMODFLOW.ReadOldLakeGeoData(var LineIndex: integer; FirstList,
  IgnoreList, DataToRead: TStringList; const VersionControl: TControl);
begin
  ReadStringGrid(LineIndex, FirstList, IgnoreList, dgGeol, DataToRead,
    VersionControl)
end;

procedure TfrmMODFLOW.cbSSMClick(Sender: TObject);
var
  NCOMP: integer;
  MobileComponents: integer;
begin
  inherited;
  cbMT3D_TVC.Enabled := cbSSM.Checked;
  cbMT3DMassFlux.Enabled := cbSSM.Checked;
  NCOMP := StrToInt(adeMT3DNCOMP.Text);
  MobileComponents := StrToInt(adeMT3DMCOMP.Text);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCRechargeConcLayerType,
    cbRCH.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DMassFluxLayerType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3DMassFlux.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DSorptionLayerType, cbMT3D.Checked
    and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DMassFluxParamClassType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3DMassFlux.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbGHB.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbGHB.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbGHB.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbGHB.Checked and cbUseAreaGHBs.Checked and (cbMOC3D.Checked or
    (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbGHB.Checked and cbUseAreaGHBs.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbGHB.Checked and cbUseAreaGHBs.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbGHB.Checked and cbUseAreaGHBs.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbGHB.Checked and cbUseAreaGHBs.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbRIV.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbRIV.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbRIV.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbRIV.Checked and cbUseAreaRivers.Checked and (cbMOC3D.Checked or
    (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbRIV.Checked and cbUseAreaRivers.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbRIV.Checked and cbUseAreaRivers.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbRIV.Checked and cbUseAreaRivers.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbRIV.Checked and cbUseAreaRivers.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbWEL.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbWEL.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineWellLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbWEL.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbWEL.Checked and cbUseAreaWells.Checked and (cbMOC3D.Checked or
    (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbWEL.Checked and cbUseAreaWells.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbWEL.Checked and cbUseAreaWells.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbWEL.Checked and cbUseAreaWells.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbWEL.Checked and cbUseAreaWells.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked and
    cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbCHD.Checked and (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbCHD.Checked and cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbCHD.Checked and cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbCHD.Checked and cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbCHD.Checked and cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMFConcentrationParamType,
    cbCHD.Checked and cbUseAreaCHD.Checked and
    (cbMOC3D.Checked or (cbMT3D.Checked and cbSSM.Checked)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbCHD.Checked and cbUseAreaCHD.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbCHD.Checked and cbUseAreaCHD.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbCHD.Checked and cbUseAreaCHD.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbCHD.Checked and cbUseAreaCHD.Checked and
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConcentrationParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMOCRechargeConcLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbRCH.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMOCRechargeConcLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbRCH.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMOCRechargeConcLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbRCH.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMOCRechargeConcLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbRCH.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFReservoirLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbRES.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointFHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineFHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaFHBLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbFHB.Checked and cbUseAreaFHBs.Checked
    and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked and (NCOMP >= 5));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DInitConc2ParamClassType,
    cbMT3D.Checked and (NCOMP >= 2));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DInitConc3ParamClassType,
    cbMT3D.Checked and (NCOMP >= 3));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DInitConc4ParamClassType,
    cbMT3D.Checked and (NCOMP >= 4));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DInitConc5ParamClassType,
    cbMT3D.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointInitConcLayerType,
    ModflowTypes.GetMT3DInitConc2ParamClassType,
    cbMT3D.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointInitConcLayerType,
    ModflowTypes.GetMT3DInitConc3ParamClassType,
    cbMT3D.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointInitConcLayerType,
    ModflowTypes.GetMT3DInitConc4ParamClassType,
    cbMT3D.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointInitConcLayerType,
    ModflowTypes.GetMT3DInitConc5ParamClassType,
    cbMT3D.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaInitConcLayerType,
    ModflowTypes.GetMT3DInitConc2ParamClassType,
    cbMT3D.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaInitConcLayerType,
    ModflowTypes.GetMT3DInitConc3ParamClassType,
    cbMT3D.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaInitConcLayerType,
    ModflowTypes.GetMT3DInitConc4ParamClassType,
    cbMT3D.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaInitConcLayerType,
    ModflowTypes.GetMT3DInitConc5ParamClassType,
    cbMT3D.Checked and (NCOMP >= 5));

{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointConstantConcLayerType,
    ModflowTypes.GetMT3DMass2ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointConstantConcLayerType,
    ModflowTypes.GetMT3DMass3ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointConstantConcLayerType,
    ModflowTypes.GetMT3DMass4ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DPointConstantConcLayerType,
    ModflowTypes.GetMT3DMass5ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5));  }

{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaConstantConcLayerType,
    ModflowTypes.GetMT3DAreaConstantConc2ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaConstantConcLayerType,
    ModflowTypes.GetMT3DAreaConstantConc3ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaConstantConcLayerType,
    ModflowTypes.GetMT3DAreaConstantConc4ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMT3DAreaConstantConcLayerType,
    ModflowTypes.GetMT3DAreaConstantConc5ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and (NCOMP >= 5)); }

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType,
    ModflowTypes.GetMT3DConc2ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3D_TVC.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType,
    ModflowTypes.GetMT3DConc3ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3D_TVC.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType,
    ModflowTypes.GetMT3DConc4ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3D_TVC.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType,
    ModflowTypes.GetMT3DConc5ParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3D_TVC.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DMassFluxLayerType,
    ModflowTypes.GetMT3DMassFluxBParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3DMassFlux.Checked and (NCOMP >=
    2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DMassFluxLayerType,
    ModflowTypes.GetMT3DMassFluxCParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3DMassFlux.Checked and (NCOMP >=
    3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DMassFluxLayerType,
    ModflowTypes.GetMT3DMassFluxDParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3DMassFlux.Checked and (NCOMP >=
    4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMT3DMassFluxLayerType,
    ModflowTypes.GetMT3DMassFluxEParamClassType,
    cbMT3D.Checked and cbSSM.Checked and cbMT3DMassFlux.Checked and (NCOMP >=
    5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCImInitConcLayerType,
    (cbMOC3D.Checked and cbDualPorosity.Checked)
    or (cbMT3D.Checked and cbRCT.Checked and cbMT3D_StartingConcentration.Checked
    and not cbMT3D_OneDArrays.Checked
    and (comboMT3DIsotherm.ItemIndex >= 4)));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCImInitConcLayerType,
    ModflowTypes.GetMT3DImInitConc2ParamClassType,
    cbMT3D.Checked and cbRCT.Checked and cbMT3D_StartingConcentration.Checked
    and not cbMT3D_OneDArrays.Checked
    and (comboMT3DIsotherm.ItemIndex >= 4)
    and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCImInitConcLayerType,
    ModflowTypes.GetMT3DImInitConc3ParamClassType,
    cbMT3D.Checked and cbRCT.Checked and cbMT3D_StartingConcentration.Checked
    and not cbMT3D_OneDArrays.Checked
    and (comboMT3DIsotherm.ItemIndex >= 4)
    and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCImInitConcLayerType,
    ModflowTypes.GetMT3DImInitConc4ParamClassType,
    cbMT3D.Checked and cbRCT.Checked and cbMT3D_StartingConcentration.Checked
    and not cbMT3D_OneDArrays.Checked
    and (comboMT3DIsotherm.ItemIndex >= 4)
    and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCImInitConcLayerType,
    ModflowTypes.GetMT3DImInitConc5ParamClassType,
    cbMT3D.Checked and cbRCT.Checked and cbMT3D_StartingConcentration.Checked
    and not cbMT3D_OneDArrays.Checked
    and (comboMT3DIsotherm.ItemIndex >= 4)
    and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC1BParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC1CParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC1DParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC1EParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC2AParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (comboMT3DIsotherm.ItemIndex <> 5)
    and (comboMT3DIsotherm.ItemIndex > 0));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC2BParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (comboMT3DIsotherm.ItemIndex <> 5)
    and (comboMT3DIsotherm.ItemIndex > 0) and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC2CParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (comboMT3DIsotherm.ItemIndex <> 5)
    and (comboMT3DIsotherm.ItemIndex > 0) and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC2DParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (comboMT3DIsotherm.ItemIndex <> 5)
    and (comboMT3DIsotherm.ItemIndex > 0) and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DReactionLayerType,
    ModflowTypes.GetMT3DRC2EParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (comboMT3DIsotherm.ItemIndex <> 5)
    and (comboMT3DIsotherm.ItemIndex > 0) and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP1BParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP1CParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP1DParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP1EParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 5));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP2BParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP2CParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP2DParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMT3DSorptionLayerType,
    ModflowTypes.GetMT3DSP2EParamClassType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked and (NCOMP >= 5));

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DICBUNDParamClassType,
    ModflowTypes.GetGridMT3DICBUNDParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConcCellParamClassType,
    ModflowTypes.GetGridMT3DInitConcCellParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc2ParamClassType,
    ModflowTypes.GetGridMT3DInitConc2ParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc3ParamClassType,
    ModflowTypes.GetGridMT3DInitConc3ParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc4ParamClassType,
    ModflowTypes.GetGridMT3DInitConc4ParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc5ParamClassType,
    ModflowTypes.GetGridMT3DInitConc5ParamClassType.ANE_ParamName, True);

    //  MOLECULAR DIFFUSION
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMT3DMolecularDiffusionLayerType,
    ModflowTypes.GetMT3DMolDiffBParamClassType,
    cbMT3D.Checked and cbDSP.Checked and cbMt3dMultiDiffusion.Checked
    and (MobileComponents >= 2));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMT3DMolecularDiffusionLayerType,
    ModflowTypes.GetMT3DMolDiffCParamClassType,
    cbMT3D.Checked and cbDSP.Checked and cbMt3dMultiDiffusion.Checked
    and (MobileComponents >= 3));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMT3DMolecularDiffusionLayerType,
    ModflowTypes.GetMT3DMolDiffDParamClassType,
    cbMT3D.Checked and cbDSP.Checked and cbMt3dMultiDiffusion.Checked
    and (MobileComponents >= 4));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMT3DMolecularDiffusionLayerType,
    ModflowTypes.GetMT3DMolDiffEParamClassType,
    cbMT3D.Checked and cbDSP.Checked and cbMt3dMultiDiffusion.Checked
    and (MobileComponents >= 5));

end;

procedure TfrmMODFLOW.LakeWarning;
begin
  if not Loading and not cancelling
    and cbLAK.Checked and cbLAKRetain.Checked then
  begin
    if cbMT3D.Checked then
    begin
      Beep;
      MessageDlg('The current version of MT3D is incompatible with the '
        + 'Lake Package.', mtWarning, [mbOK], 0);
    end;
  end;

end;

procedure TfrmMODFLOW.cbMT3D_TVCClick(Sender: TObject);
begin
  inherited;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DICBUNDParamClassType,
    ModflowTypes.GetGridMT3DICBUNDParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConcCellParamClassType,
    ModflowTypes.GetGridMT3DInitConcCellParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc2ParamClassType,
    ModflowTypes.GetGridMT3DInitConc2ParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc3ParamClassType,
    ModflowTypes.GetGridMT3DInitConc3ParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc4ParamClassType,
    ModflowTypes.GetGridMT3DInitConc4ParamClassType.ANE_ParamName, True);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DInitConc5ParamClassType,
    ModflowTypes.GetGridMT3DInitConc5ParamClassType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.sgReactionExit(Sender: TObject);
var
  RowIndex, ColIndex: integer;
  CellText: string;
begin
  inherited;
  for RowIndex := sgReaction.FixedRows to sgReaction.RowCount - 1 do
  begin
    for ColIndex := Ord(rdmBulkDensity) to sgReaction.ColCount - 1 do
    begin
      CellText := sgReaction.Cells[ColIndex, RowIndex];
      if CellText = '' then
      begin
        sgReaction.Cells[ColIndex, RowIndex] := '0';
      end
      else if CellText[1] = '.' then
      begin
        sgReaction.Cells[ColIndex, RowIndex] := '0' + CellText;
      end
    end;
  end;
end;

procedure TfrmMODFLOW.btmInsertMT3DPrintTimeClick(Sender: TObject);
var
  CurrentRow: Integer;
  RowIndex, ColIndex: integer;
begin
  inherited;
  btmAddMT3DPrintTimeClick(Sender);
  CurrentRow := sgPrintoutTimes.Selection.Top;

  for RowIndex := sgReaction.RowCount - 2 downto CurrentRow do
  begin
    sgPrintoutTimes.Cells[Ord(ptmN), RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgPrintoutTimes.ColCount - 1 do
    begin
      sgPrintoutTimes.Cells[ColIndex, RowIndex + 1] :=
        sgPrintoutTimes.Cells[ColIndex, RowIndex];
    end;
  end;
end;

procedure TfrmMODFLOW.SetUpMt3dReactionGrid(const NCOMP: integer);
const
  Titles: array[0..4] of string = (rsSorpConst1, rsSorpConst2, rsRateConstDis,
    rsRateConstSorb, rsStartingConcentration);
  DefaultValues: array[0..4] of string = ('1', '1', '1e-006', '1e-006', '0');
var
  ColIndex: integer;
  SpeciesIndex: integer;
  VariableIndex: integer;
  RowIndex: integer;
  Widths: array[0..4] of integer;
begin
  Widths[0] := sgReaction.ColWidths[Ord(rdmSorpConst1)];
  Widths[1] := sgReaction.ColWidths[Ord(rdmSorpConst2)];
  Widths[2] := sgReaction.ColWidths[Ord(rdmRateConstDiss)];
  Widths[3] := sgReaction.ColWidths[Ord(rdmRateConstSorp)];
  Widths[4] := sgReaction.ColWidths[Ord(rdmStartingConcentration)];

  sgReaction.ColCount := 9 + (NCOMP - 1) * 5;
  for SpeciesIndex := 2 to NCOMP do
  begin
    for VariableIndex := 0 to 4 do
    begin
      ColIndex := 9 + (SpeciesIndex - 2) * 5 + VariableIndex;
      sgReaction.ColWidths[ColIndex] := Widths[VariableIndex] + 40;
      sgReaction.Columns[ColIndex].Format := rcfReal;
      sgReaction.Columns[ColIndex].CheckMin := True;
      sgReaction.Cells[ColIndex, 0] := Titles[VariableIndex] + ' Species ' +
        IntToStr(SpeciesIndex);
      for RowIndex := 1 to sgReaction.RowCount - 1 do
      begin
        if sgReaction.Cells[ColIndex, RowIndex] = '' then
        begin
          sgReaction.Cells[ColIndex, RowIndex] := DefaultValues[VariableIndex];
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeMT3DNCOMPExit(Sender: TObject);
var
  NCOMP: integer;
  RowIndex: Integer;
  AChar: Char;
begin
  inherited;
  ActivateMNWTimeVaryingParameters;

  NCOMP := StrToInt(adeMT3DNCOMP.Text);
  adeMT3DMCOMP.Max := NCOMP;

  SetUpMt3dReactionGrid(NCOMP);
  AddOrRemoveMT3D_MNW_Parameters;
  cbSSMClick(Sender);

  adeSW_ViscEquationCount.Max := NCOMP;
  rdgSWDensTable.Columns[1].Max := NCOMP;
  rdgSW_ViscEq.Columns[1].Max := NCOMP;
  rdgSW_ViscEqTemp.Columns[0].Max := NCOMP;

  AChar := 'A';
  rdgMt3dBinaryInitialConcFiles.RowCount := NCOMP + 1;
  for RowIndex := 1 to rdgMt3dBinaryInitialConcFiles.RowCount - 1 do
  begin
    rdgMt3dBinaryInitialConcFiles.Cells[0, RowIndex] := AChar;
    Inc(AChar);
  end;

end;

procedure TfrmMODFLOW.cbGCGClick(Sender: TObject);
begin
  inherited;
  tabMt3dGCG.TabVisible := cbGCG.Checked;
end;

procedure TfrmMODFLOW.sgDispersionSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if ACol = Ord(ddmName) then
  begin
    CanSelect := False;
  end;
  if (ACol = Ord(ddmMolDiffCoef)) and cbMt3dMultiDiffusion.Checked then
  begin
    CanSelect := False;
  end;
end;

procedure TfrmMODFLOW.cbMT3D_OneDArraysClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveMT3D_ReactionLayers;
  sgReaction.Invalidate;
end;

procedure TfrmMODFLOW.cbMT3D_StartingConcentrationClick(Sender: TObject);
begin
  inherited;
  sgReaction.Invalidate;
  AddOrRemoveMT3D_ReactionLayers;
end;

procedure TfrmMODFLOW.PageControlMT3DChange(Sender: TObject);
begin
  inherited;
  if Sender is TPageControl then
  begin
    FreePageControlResources(TPageControl(Sender), Handle);
  end;
end;

procedure TfrmMODFLOW.edMT3DMassChange(Sender: TObject);
begin
  inherited;
  MT3DMassUnit := edMT3DMass.Text;

end;

procedure TfrmMODFLOW.AddOrRemoveMT3D_ReactionLayers;
begin
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMT3DBulkDensityLayerType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex > 0)
    and (comboMT3DIsotherm.ItemIndex <> 5) and not cbMT3D_OneDArrays.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCImPorosityLayerType,
    (cbMOC3D.Checked and cbDualPorosity.Checked)
    or (cbMT3D.Checked and cbRCT.Checked and (comboMT3DIsotherm.ItemIndex >= 5)
    and not cbMT3D_OneDArrays.Checked));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DReactionLayerType,
    cbMT3D.Checked and cbRCT.Checked and (comboMT3DIREACT.ItemIndex > 0)
    and not cbMT3D_OneDArrays.Checked);

  cbSSMClick(nil);
end;

procedure TfrmMODFLOW.HUF_ParameterWarning;
var
  UnitIndex, ParameterIndex, ClusterIndex: integer;
  HGUVANI, HGUHANI: double;
  ParamType: integer;
  UnitName: string;
  ClusterGrid: TDataGrid;
  ErrorMessage: string;
  FoundVKParameter, FoundOneOrMoreVKParameter, FoundHANIParameter: boolean;
begin
  if not Loading and not cancelling and (rgFlowPackage.ItemIndex = 2) then
  begin
    FoundOneOrMoreVKParameter := False;
    for UnitIndex := 1 to framHUF1.dgHufUnits.RowCount - 1 do
    begin
      UnitName := framHUF1.dgHufUnits.Cells[0, UnitIndex];
      HGUVANI := InternationalStrToFloat(framHUF1.dgHufUnits.Cells[2,
        UnitIndex]);
      if HGUVANI = 0 then
      begin
        FoundVKParameter := False;
        for ParameterIndex := 1 to dgHUFParameters.RowCount - 1 do
        begin
          ParamType := dgHUFParameters.Columns[1].PickList.IndexOf(
            dgHUFParameters.Cells[1, ParameterIndex]);
          if ParamType = 3 then // VANI
          begin
            // illegal parameter type for this unit.  Check if used with this unit.
            ClusterGrid := dg3dHUFParameterClusters.Grids[ParameterIndex - 1];
            for ClusterIndex := 1 to ClusterGrid.RowCount - 1 do
            begin
              if UpperCase(ClusterGrid.Cells[0, ClusterIndex]) = UpperCase(UnitName) then
              begin
                ErrorMessage := 'VANI parameters can not be used with the HUF '
                  + 'package when the Vertical Anisotropy flag is set to a '
                  + 'value equal to 0.  You need to correct this before '
                  + 'running the model either by changing the Vertical '
                  + 'Anisotropy flag on the "Geology" tab for the HUF Geologic '
                  + 'Unit named ' + UnitName
                  + ' or the parameter '
                  + 'type on the "Parameters" tab named '
                  + dgHUFParameters.Cells[0, ParameterIndex]
                  + '.';
                Beep;
                MessageDlg(ErrorMessage, mtError, [mbOK], 0);
                Exit;
              end;
            end;
          end
          else if ParamType = 2 then //VK
          begin
            // you must define the vertical hydraulic conductivity of the unit.
            ClusterGrid := dg3dHUFParameterClusters.Grids[ParameterIndex - 1];
            for ClusterIndex := 1 to ClusterGrid.RowCount - 1 do
            begin
              if UpperCase(ClusterGrid.Cells[0, ClusterIndex]) = UpperCase(UnitName) then
              begin
                FoundVKParameter := True;
                break;
              end;
            end;
          end;
        end;
        if not FoundVKParameter then
        begin
          ErrorMessage := 'If the Vertical Anisotropy flag is set to 0 in the '
            + 'HUF package, you must use VK parameters to define the '
            + 'Vertical Hydraulic conductivity.  '
            + 'You need to correct this before '
            + 'running the model either by changing the Vertical '
            + 'Anisotropy flag on the "Geology" tab for the HUF Geologic '
            + 'Unit named ' + UnitName
            + ' or defining a VK parameter for it '
            + 'on the "Parameters" tab.';
          Beep;
          MessageDlg(ErrorMessage, mtError, [mbOK], 0);
          Exit;
        end;

      end
      else
      begin
        for ParameterIndex := 1 to dgHUFParameters.RowCount - 1 do
        begin
          ParamType := dgHUFParameters.Columns[1].PickList.IndexOf(
            dgHUFParameters.Cells[1, ParameterIndex]);
          if ParamType = 2 then //VK
          begin
            // you must define the vertical hydraulic conductivity of the unit.
            ClusterGrid := dg3dHUFParameterClusters.Grids[ParameterIndex - 1];
            for ClusterIndex := 1 to ClusterGrid.RowCount - 1 do
            begin
              if UpperCase(ClusterGrid.Cells[0, ClusterIndex]) = UpperCase(UnitName) then
              begin
                FoundOneOrMoreVKParameter := True;
                break;
              end;
            end;
          end;
        end;

      end;

      HGUHANI := InternationalStrToFloat(framHUF1.dgHufUnits.Cells[1,
        UnitIndex]);
      if HGUHANI = 0 then
      begin
        FoundHANIParameter := False;
        for ParameterIndex := 1 to dgHUFParameters.RowCount - 1 do
        begin
          ParamType := dgHUFParameters.Columns[1].PickList.IndexOf(
            dgHUFParameters.Cells[1, ParameterIndex]);
          if ParamType = 1 then
          begin
            ClusterGrid := dg3dHUFParameterClusters.Grids[ParameterIndex - 1];
            for ClusterIndex := 1 to ClusterGrid.RowCount - 1 do
            begin
              if UpperCase(ClusterGrid.Cells[0, ClusterIndex]) = UpperCase(UnitName) then
              begin
                FoundHANIParameter := True;
                break;
              end;
            end;
          end;
        end;
        if not FoundHANIParameter then
        begin
          ErrorMessage := 'If the Horizontal Anisotropy flag is set to 0 in the '
            + 'HUF package, you must use HANI parameters to define the '
            + 'horizontal anisotropy.  '
            + 'You need to correct this before '
            + 'running the model either by changing the Horizontal '
            + 'Anisotropy flag on the "Geology" tab for the HUF Geologic '
            + 'Unit named ' + UnitName
            + ' or defining a HANI parameter for it '
            + 'on the "Parameters" tab.';
          Beep;
          MessageDlg(ErrorMessage, mtError, [mbOK], 0);
          Exit;
        end;
      end;

    end;
    if FoundOneOrMoreVKParameter then
    begin
      ErrorMessage := 'If the Vertical Anisotropy flag is set to a value '
        + 'greater than 0 in the '
        + 'HUF package, any VK parameters will be interpreted as vertical '
        + 'anisotropy instead of  '
        + 'vertical hydraulic conductivity.  '
        + 'You may wish to change this before '
        + 'running the model either by changing the Vertical '
        + 'Anisotropy flag on the "Geology" tab '
        + 'or by changing VK parameters to VANI parameters '
        + 'on the "Parameters" tab.';
      Beep;
      MessageDlg(ErrorMessage, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbMT3DMassFluxClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DMassFluxLayerType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3DMassFlux.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetGridMT3DMassFluxParamClassType, cbMT3D.Checked
    and cbSSM.Checked and cbMT3DMassFlux.Checked);

end;

procedure TfrmMODFLOW.adeMT3DNCOMPExceedingBounds(Sender: TObject);
var
  NumSpecies: integer;
begin
  inherited;
  if not Loading and not Cancelling then
  begin
    try
      NumSpecies := StrToInt(adeMT3DNCOMP.Text);
      if NumSpecies > adeMT3DNCOMP.Max then
      begin
        Beep;
        MessageDlg('The MODFLOW GUI currently limits the number of species to '
          + IntToStr(Trunc(adeMT3DNCOMP.Max))
          + '.  Contact the PIE developer if you '
          + 'need a larger number', mtInformation, [mbOK], 0);
      end;
    except on EConvertError do
      begin
      end;
    end;
  end;

end;

procedure TfrmMODFLOW.InitializeFormats(const DG3D: TRBWDataGrid3d);
var
  Index: integer;
  DG: TDataGrid;
begin
  Assert(DG3D = dg3dLPFParameterClusters);
  for Index := 0 to dg3dLPFParameterClusters.PageCount - 1 do
  begin
    DG := dg3dLPFParameterClusters.Grids[Index];
    DG.Columns[0].Format := cfNumber;
  end;
end;

procedure TfrmMODFLOW.CheckValidZoneNumbers;
const
  ZoneArrayIndex = 2;
  FirstZoneIndex = 3;
  procedure ShowWarning(const PackageName, ParameterName: string);
  begin
    Beep;
    MessageDlg('In the ' + PackageName + ' package.  One or more parameters '
      + 'have not been completely defined.  The first problematic parameter is '
      + '"' + ParameterName + '".  You need to specify the zone number to '
      + 'which this and possibly other parameters apply before you try to run '
      + 'the model.', mtWarning, [mbOK], 0);
  end;
  function CheckZones(const PackageName: string;
    const dg3D: TRBWDataGrid3d): boolean;
  var
    GridIndex: integer;
    ADataGrid: TDataGrid;
    RowIndex: integer;
  begin
    result := False;
    for GridIndex := 0 to dg3D.PageCount - 1 do
    begin
      ADataGrid := dg3D.Grids[GridIndex];
      for RowIndex := 1 to ADataGrid.RowCount - 1 do
      begin
        if (ADataGrid.Cells[ZoneArrayIndex, RowIndex]
          <> ADataGrid.Columns[ZoneArrayIndex].Picklist[0])
          and (Trim(ADataGrid.Cells[FirstZoneIndex, RowIndex]) = '') then
        begin
          ShowWarning(PackageName,
            dg3D.Pages[GridIndex].Caption);
          result := True;
          Exit;
        end;
      end;
    end;
  end;
begin
  if not loading and not cancelling then
  begin
    if rbMODFLOW2000.Checked or rbModflow2005.Checked then
    begin
      if rgFlowPackage.ItemIndex = 2 then
      begin
        if CheckZones('HUF', dg3dHUFParameterClusters) then
        begin
          Exit;
        end;
      end;
      if rgFlowPackage.ItemIndex = 1 then
      begin
        if CheckZones('LPF', dg3dLPFParameterClusters) then
        begin
          Exit;
        end;
      end;
      if cbRCH.Checked and cbRCHRetain.Checked then
      begin
        if CheckZones('RCH', dg3dRCHParameterClusters) then
        begin
          Exit;
        end;
      end;
      if cbEVT.Checked and cbEVTRetain.Checked then
      begin
        if CheckZones('EVT', dg3dEVTParameterClusters) then
        begin
          Exit;
        end;
      end;
      if cbETS.Checked and cbETSRetain.Checked then
      begin
        if CheckZones('ETS', dg3dETSParameterClusters) then
        begin
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.DeleteParameterAndInstances(const ParamGrid: TStringGrid;
  const InstanceGrid: TRbwStringGrid3d; const ParamCountEdit: TArgusDataEntry);
var
  GridIndex: integer;
  FirstGrid, SecondGrid: TStringGrid;
  ARow: TStringList;
begin
  inherited;
  if (ParamGrid.Row > 0)
    and (ParamGrid.Row < ParamGrid.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      ARow.Assign(ParamGrid.Rows[ParamGrid.Row]);

      for GridIndex := ParamGrid.Row to ParamGrid.RowCount - 2 do
      begin
        ParamGrid.Rows[GridIndex] := ParamGrid.Rows[GridIndex + 1];
        FirstGrid := InstanceGrid.Grids[GridIndex - 1];
        SecondGrid := InstanceGrid.Grids[GridIndex];
        FirstGrid.RowCount := SecondGrid.RowCount;
        FirstGrid.Cols[0] := SecondGrid.Cols[0];
        FirstGrid.FixedCols := SecondGrid.FixedCols;
        if (FirstGrid is TDataGrid) and (SecondGrid is TDataGrid) then
        begin
          TDataGrid(FirstGrid).Columns[0].PickList :=
            TDataGrid(SecondGrid).Columns[0].PickList;
          TDataGrid(FirstGrid).Columns[0].Title.Caption :=
            TDataGrid(SecondGrid).Columns[0].Title.Caption;
        end;

        if FirstGrid.RowCount > 1 then
        begin
          FirstGrid.FixedRows := 1;
        end;
        InstanceGrid.Pages[GridIndex - 1].Caption
          := InstanceGrid.Pages[GridIndex].Caption;
      end;
      ParamGrid.Rows[ParamGrid.RowCount - 1].Assign(ARow);

    finally
      ARow.Free;
    end;
    ParamCountEdit.Text := IntToStr(StrToInt(ParamCountEdit.Text) - 1);
    ParamCountEdit.OnExit(ParamCountEdit);
  end;
end;

procedure TfrmMODFLOW.btnDeleteLPF_ParameterClick(Sender: TObject);
var
  RowIndex, GridIndex: integer;
  FirstGrid, SecondGrid: TStringGrid;
  ARow: TStringList;
begin
  inherited;
  if (dgLPFParameters.Row > 0)
    and (dgLPFParameters.Row < dgLPFParameters.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      ARow.Assign(dgLPFParameters.Rows[dgLPFParameters.Row]);

      for GridIndex := dgLPFParameters.Row to dgLPFParameters.RowCount - 2 do
      begin
        dgLPFParameters.Rows[GridIndex] := dgLPFParameters.Rows[GridIndex + 1];
        FirstGrid := dg3dLPFParameterClusters.Grids[GridIndex - 1];
        SecondGrid := dg3dLPFParameterClusters.Grids[GridIndex];
        FirstGrid.RowCount := SecondGrid.RowCount;
        for RowIndex := 1 to FirstGrid.RowCount - 1 do
        begin
          FirstGrid.Rows[RowIndex] := SecondGrid.Rows[RowIndex];
        end;
        dg3dLPFParameterClusters.Pages[GridIndex - 1].Caption :=
          dg3dLPFParameterClusters.Pages[GridIndex].Caption
      end;
      dgLPFParameters.Rows[dgLPFParameters.RowCount - 1].Assign(ARow);
    finally
      ARow.Free;
    end;
    adeLPFParamCount.Text := IntToStr(StrToInt(adeLPFParamCount.Text) - 1);
    adeLPFParamCountExit(Sender);
  end;
end;

procedure TfrmMODFLOW.btnDeleteHUF_ParameterClick(Sender: TObject);
var
  RowIndex, GridIndex: integer;
  FirstGrid, SecondGrid: TDataGrid;
  ARow: TStringList;
begin
  inherited;
  if (dgHUFParameters.Row > 0)
    and (dgHUFParameters.Row < dgHUFParameters.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      ARow.Assign(dgHUFParameters.Rows[dgHUFParameters.Row]);

      for GridIndex := dgHUFParameters.Row to dgHUFParameters.RowCount - 2 do
      begin
        dgHUFParameters.Rows[GridIndex] := dgHUFParameters.Rows[GridIndex + 1];
        FirstGrid := dg3dHUFParameterClusters.Grids[GridIndex - 1];
        SecondGrid := dg3dHUFParameterClusters.Grids[GridIndex];
        FirstGrid.RowCount := SecondGrid.RowCount;
        for RowIndex := 1 to FirstGrid.RowCount - 1 do
        begin
          FirstGrid.Rows[RowIndex] := SecondGrid.Rows[RowIndex];
        end;
        dg3dHUFParameterClusters.Pages[GridIndex - 1].Caption :=
          dg3dHUFParameterClusters.Pages[GridIndex].Caption;
        FirstGrid.FixedCols := SecondGrid.FixedCols;
        FirstGrid.Columns[0].PickList := SecondGrid.Columns[0].PickList;
        FirstGrid.Columns[0].Title.Caption := SecondGrid.Columns[0].Title.Caption
      end;
      dgHUFParameters.Rows[dgHUFParameters.RowCount - 1].Assign(ARow);
    finally
      ARow.Free;
    end;
    adeHUFParamCount.Text := IntToStr(StrToInt(adeHUFParamCount.Text) - 1);
    adeHUFParamCountExit(Sender);
  end;
end;

procedure TfrmMODFLOW.DeleteParameterInstancesAndClusters(
  const ParamGrid: TDataGrid; const InstanceGrid: TRbwStringGrid3d;
  const ClusterGrid: TRBWDataGrid3d; const ParamCountEdit: TArgusDataEntry);
var
  RowIndex, GridIndex: integer;
  FirstGrid, SecondGrid: TStringGrid;
  ARow: TStringList;
  SumPreviousInstances: integer;
  InstanceCountString: string;
  InstanceCount: integer;
  ClusterStart: integer;
begin
  inherited;
  if (ParamGrid.Row > 0)
    and (ParamGrid.Row < ParamGrid.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      SumPreviousInstances := GetPreviousInstances(ParamGrid.Row, ParamGrid);
      InstanceCountString := ParamGrid.Cells[4, ParamGrid.Row];
      if InstanceCountString = '' then
      begin
        InstanceCount := 1;
      end
      else
      begin
        InstanceCount := StrToInt(InstanceCountString);
      end;
      if InstanceCount = 0 then
      begin
        InstanceCount := 1;
      end;
      ClusterStart := SumPreviousInstances;

      ARow.Assign(ParamGrid.Rows[ParamGrid.Row]);

      for GridIndex := ParamGrid.Row to ParamGrid.RowCount - 2 do
      begin
        ParamGrid.Rows[GridIndex] := ParamGrid.Rows[GridIndex + 1];
        FirstGrid := InstanceGrid.Grids[GridIndex - 1];
        SecondGrid := InstanceGrid.Grids[GridIndex];
        FirstGrid.RowCount := SecondGrid.RowCount;
        FirstGrid.Cols[0] := SecondGrid.Cols[0];
        if FirstGrid.RowCount > 1 then
        begin
          FirstGrid.FixedRows := 1;
        end;
        InstanceGrid.Pages[GridIndex - 1].Caption
          := InstanceGrid.Pages[GridIndex].Caption;
      end;
      ParamGrid.Rows[ParamGrid.RowCount - 1].Assign(ARow);

      for GridIndex := ClusterStart to ClusterGrid.PageCount - 1 - InstanceCount
        do
      begin
        FirstGrid := ClusterGrid.Grids[GridIndex];
        SecondGrid := ClusterGrid.Grids[GridIndex + InstanceCount];
        FirstGrid.RowCount := SecondGrid.RowCount;
        for RowIndex := 1 to FirstGrid.RowCount - 1 do
        begin
          FirstGrid.Rows[RowIndex] := SecondGrid.Rows[RowIndex];
        end;
        ClusterGrid.Pages[GridIndex].Caption :=
          ClusterGrid.Pages[GridIndex + InstanceCount].Caption
      end;
    finally
      ARow.Free;
    end;
    ParamCountEdit.Text := IntToStr(StrToInt(ParamCountEdit.Text) - 1);
    ParamCountEdit.OnExit(ParamCountEdit);
  end;
end;

procedure TfrmMODFLOW.btnDeleteRCH_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterInstancesAndClusters(dgRCHParametersN, sg3dRCHParamInstances,
    dg3dRCHParameterClusters, adeRCHParamCount);
end;

procedure TfrmMODFLOW.btnDeleteEVT_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterInstancesAndClusters(dgEVTParametersN, sg3dEVTParamInstances,
    dg3dEVTParameterClusters, adeEVTParamCount);
end;

procedure TfrmMODFLOW.btnDeleteRIV_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgRIVParametersN, sg3dRIVParamInstances,
    adeRIVParamCount);
end;

procedure TfrmMODFLOW.btnDeleteWEL_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgWELParametersN, sg3dWelParamInstances,
    adeWELParamCount);
end;

procedure TfrmMODFLOW.btnDeleteDRN_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgDRNParametersN, sg3dDRNParamInstances,
    adeDRNParamCount);
end;

procedure TfrmMODFLOW.btnDeleteDRT_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgDRTParametersN, sg3dDRTParamInstances,
    adeDRTParamCount);
end;

procedure TfrmMODFLOW.btnDeleteSFR_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgSFRParametersN, sg3dSFRParamInstances,
    adeSFRParamCount);
end;

procedure TfrmMODFLOW.btnDeleteSTR_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgSTRParametersN, sg3dSTRParamInstances,
    adeSTRParamCount);
end;

procedure TfrmMODFLOW.btnDeleteETS_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterInstancesAndClusters(dgETSParametersN, sg3dETSParamInstances,
    dg3dETSParameterClusters, adeETSParamCount);
end;

procedure TfrmMODFLOW.btnDeleteCHD_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgCHDParameters, sg3dCHDParamInstances,
    adeCHDParamCount);
end;

procedure TfrmMODFLOW.btnDeleteHFB_ParameterClick(Sender: TObject);
var
  GridIndex: integer;
  ARow: TStringList;
begin
  inherited;
  if (dgHFBParameters.Row > 0)
    and (dgHFBParameters.Row < dgHFBParameters.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      ARow.Assign(dgHFBParameters.Rows[dgHFBParameters.Row]);

      for GridIndex := dgHFBParameters.Row to dgHFBParameters.RowCount - 2 do
      begin
        dgHFBParameters.Rows[GridIndex] := dgHFBParameters.Rows[GridIndex + 1];
      end;
      dgHFBParameters.Rows[dgHFBParameters.RowCount - 1].Assign(ARow);

    finally
      ARow.Free;
    end;
    adeHFBParamCount.Text := IntToStr(StrToInt(adeHFBParamCount.Text) - 1);
    adeHFBParamCount.OnExit(adeHFBParamCount);
  end;
end;

procedure TfrmMODFLOW.btnDeleteGHB_ParameterClick(Sender: TObject);
begin
  inherited;
  DeleteParameterAndInstances(dgGHBParametersN, sg3dGHBParamInstances,
    adeGHBParamCount);
end;

procedure TfrmMODFLOW.btnDeleteGwmStorageStateVarClick(Sender: TObject);
var
  ColIndex: Integer;
begin
  inherited;

  if rdgGwmStorageVariables.SelectedRow >= 1 then
  begin
    FChangingGwmStateRow := True;
    try
      if rdgGwmStorageVariables.RowCount > 2 then
      begin
        rdgGwmStorageVariables.DeleteRow(rdgGwmStorageVariables.SelectedRow);
      end
      else
      begin
        for ColIndex := 0 to rdgGwmStorageVariables.ColCount - 1 do
        begin
          rdgGwmStorageVariables.Cells[ColIndex, 1] := '';
        end;
      end;
    finally
      FChangingGwmStateRow := False;
    end;

    rdeGwmStorageStateVarCount.Text :=
      IntToStr(StrToInt(rdeGwmStorageStateVarCount.Output)-1);
  end;

end;

procedure TfrmMODFLOW.btnDeleteParamEstCovNamesClick(Sender: TObject);
var
  ARow: TStringList;
  RowIndex: integer;
begin
  inherited;
  if (dgParamEstCovNames.Row > 0)
    and (dgParamEstCovNames.Row < dgParamEstCovNames.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      ARow.Assign(dgParamEstCovNames.Rows[dgParamEstCovNames.Row]);
      for RowIndex := dgParamEstCovNames.Row to dgParamEstCovNames.RowCount - 2
        do
      begin
        dgParamEstCovNames.Rows[RowIndex] := dgParamEstCovNames.Rows[RowIndex +
          1];
      end;
      dgParamEstCovNames.Rows[dgParamEstCovNames.RowCount - 1] := ARow;
    finally
      ARow.Free;
    end;
    adeParamEstCovNameCount.Text
      := IntToStr(StrToInt(adeParamEstCovNameCount.Text) - 1);
    adeParamEstCovNameCountExit(adeParamEstCovNameCount);
  end;

end;

procedure TfrmMODFLOW.btnRemoveSenParameterClick(Sender: TObject);
var
  RowIndex: integer;
begin
  inherited;
  RowIndex := dgSensitivity.Row;
  if RowIndex > 0 then
  begin
    RemoveSensitivityParameter(RowIndex);
  end;
end;

procedure TfrmMODFLOW.RemoveSensitivityParameter(const Row: integer);
var
  NewCount: integer;
begin
  Assert(Row > 0);
  Assert(Row < dgSensitivity.RowCount);
  dgSensitivity.DeleteRow(Row);
  NewCount := StrToInt(adeSensitivityCount.Text) - 1;
  dgSensitivity.RowCount := NewCount + 1;
  adeSensitivityCount.Text := IntToStr(NewCount);
  btnRemoveSenParameter.Enabled := NewCount > 0;
  dgSensitivityExit(dgSensitivity);
end;

procedure TfrmMODFLOW.Activate_cbMNW_Alltime;
begin
  cbMNW_Alltime.Enabled := cbMNW.Checked
    and (cbMNW_WriteFlows.Checked or cbMNW_TotalFlow.Checked);
end;

procedure TfrmMODFLOW.Activate_adeMNW_PLoss;
begin
  adeMNW_PLoss.Enabled := cbMNW.Checked and (combMNW_LossType.ItemIndex = 2);
end;

procedure TfrmMODFLOW.ActivateComboMnwObservations;
begin
  comboMnwObservations.Enabled := cbMNW.Checked and cbMOC3D.Checked;
  SetComboColor(comboMnwObservations);
end;

procedure TfrmMODFLOW.AddOrRemoveMnwObservations;
begin
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFIsObservationParamType,
    cbMNW.Checked and cbMOC3D.Checked
    and (comboMnwObservations.ItemIndex >= 1));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_OutputFlagParamType,
    cbMNW.Checked and cbMOC3D.Checked
    and (comboMnwObservations.ItemIndex = 1));

{  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType, cbMNW.Checked and
    cbMOC3D.Checked and cbParticleObservations.Checked); }

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType, cbMNW2.Checked and
    cbMOC3D.Checked and cbParticleObservations.Checked and (rgMnw2WellType.ItemIndex in [0,2]));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType, cbMNW2.Checked and
    cbMOC3D.Checked and cbParticleObservations.Checked and (rgMnw2WellType.ItemIndex in [1,2]));
end;

procedure TfrmMODFLOW.AddOrRemoveMnw2LayersAndParameters;
var
  VerticalWellPresent: boolean;
  LossTypeChoices: TMnw2LossTypeSet;
  LossTypeNeeded: boolean;
  WellRadiusNeeded: Boolean;
  SkinNeeded: Boolean;
  GeneralParametersNeeded: Boolean;
  SpecifyParametersNeeded: Boolean;
  PumpLimitations: Boolean;
  TimeVaryingPumpLimitations: Boolean;
  GWT_Used: Boolean;
  Mnw2VertLayer: T_ANE_InfoLayer;
  MaxScreens: Integer;
  ScreenIndex: Integer;
  ParamList: T_ANE_IndexedParameterList;
  GeneralWellPresent: boolean;
  MFWI_Used: Boolean;
begin
  VerticalWellPresent := cbMnw2.Checked
    and (rgMnw2WellType.ItemIndex in [0,2]);
  GeneralWellPresent := cbMnw2.Checked
    and (rgMnw2WellType.ItemIndex in [1,2]);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType, VerticalWellPresent);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType, GeneralWellPresent);

  LossTypeChoices := frmMODFLOW.Mnw2LossTypeChoices;
  LossTypeNeeded := LossTypeChoices <> [];

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_LossTypeParamType,
    VerticalWellPresent and LossTypeNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_LossTypeParamType,
    GeneralWellPresent and LossTypeNeeded);

  WellRadiusNeeded := ([ltcThiem, ltcSkin, ltcGeneral] * LossTypeChoices) <> [];
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_WellRadiusParamType,
    VerticalWellPresent and WellRadiusNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_WellRadiusParamType,
    GeneralWellPresent and WellRadiusNeeded);

  SkinNeeded := ltcSkin in LossTypeChoices;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_SkinRadiusParamType,
    VerticalWellPresent and SkinNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_SkinKParamType,
    VerticalWellPresent and SkinNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_SkinRadiusParamType,
    GeneralWellPresent and SkinNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_SkinKParamType,
    GeneralWellPresent and SkinNeeded);

  GeneralParametersNeeded := ltcGeneral in LossTypeChoices;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_BParamType,
    VerticalWellPresent and GeneralParametersNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_CParamType,
    VerticalWellPresent and GeneralParametersNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_PParamType,
    VerticalWellPresent and GeneralParametersNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_BParamType,
    GeneralWellPresent and GeneralParametersNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_CParamType,
    GeneralWellPresent and GeneralParametersNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_PParamType,
    GeneralWellPresent and GeneralParametersNeeded);

  SpecifyParametersNeeded := ltcSpecify in LossTypeChoices;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_CellToWellConductanceParamType,
    VerticalWellPresent and SpecifyParametersNeeded);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_CellToWellConductanceParamType,
    GeneralWellPresent and SpecifyParametersNeeded);

  MFWI_Used := cbMnw2.Checked and cbMnwi.Checked;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorWellFlowParamType,
    VerticalWellPresent and MFWI_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorExternalFlowParamType,
    VerticalWellPresent and MFWI_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorWellFlowParamType,
    GeneralWellPresent and MFWI_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorExternalFlowParamType,
    GeneralWellPresent and MFWI_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorInternalFlowParamType,
    VerticalWellPresent and MFWI_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorInternalFlowParamType,
    GeneralWellPresent and MFWI_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorConcentrationParamType,
    VerticalWellPresent and MFWI_Used and cbMOC3D.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_MonitorConcentrationParamType,
    GeneralWellPresent and MFWI_Used and cbMOC3D.Checked);

  PumpLimitations := cbMnw2Pumpcap.Checked;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_PumpTypeParamType,
    VerticalWellPresent and PumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_DischargeElevationParamType,
    VerticalWellPresent and PumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_PumpTypeParamType,
    GeneralWellPresent and PumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_DischargeElevationParamType,
    GeneralWellPresent and PumpLimitations);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_HeadCapacityMultiplierParamType,
    VerticalWellPresent and PumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_HeadCapacityMultiplierParamType,
    GeneralWellPresent and PumpLimitations);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMFIFACEParamType,
    VerticalWellPresent and cbMODPATH.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMFIFACEParamType,
    GeneralWellPresent and cbMODPATH.Checked);

  TimeVaryingPumpLimitations := cbMnw2Pumpcap.Checked
    and cbMnw2TimeVarying.Checked;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType,
    VerticalWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType,
    VerticalWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType,
    VerticalWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType,
    VerticalWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType,
    GeneralWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType,
    GeneralWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType,
    GeneralWellPresent and not TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType,
    GeneralWellPresent and not TimeVaryingPumpLimitations);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType,
    VerticalWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType,
    VerticalWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType,
    VerticalWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType,
    VerticalWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType,
    GeneralWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType,
    GeneralWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType,
    GeneralWellPresent and TimeVaryingPumpLimitations);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType,
    GeneralWellPresent and TimeVaryingPumpLimitations);

  GWT_Used := cbMOC3D.Checked;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_VerticalWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    VerticalWellPresent and GWT_Used);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW2_GeneralWellLayerType,
    ModflowTypes.GetMFConcentrationParamType,
    GeneralWellPresent and GWT_Used);

  if VerticalWellPresent then
  begin
    Mnw2VertLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName(
      ModflowTypes.GetMFMNW2_VerticalWellLayerType.ANE_LayerName)
      as T_ANE_InfoLayer;
    MaxScreens := StrToInt(adeMnw2WellScreens.Text);
    for ScreenIndex := Mnw2VertLayer.IndexedParamList1.Count - 1 downto 0 do
    begin
      ParamList := Mnw2VertLayer.IndexedParamList1[ScreenIndex];
      if ScreenIndex < MaxScreens then
      begin
        ParamList.UnDeleteSelf;
      end
      else
      begin
        ParamList.DeleteSelf;
      end;
    end;
    while Mnw2VertLayer.IndexedParamList1.Count < MaxScreens do
    begin
      ModflowTypes.GetMFMNW2_WellScreenParamListType.Create(
        Mnw2VertLayer.IndexedParamList1, -1);
    end;
  end;
end;

procedure TfrmMODFLOW.cbMnw2Click(Sender: TObject);
begin
  inherited;
  TwoMnwWarning;
  comboMnw2SteadyState.Enabled := cbMnw2.Checked;
  SetComboColor(comboMnw2SteadyState);
  cbUseMnw2.Enabled := cbMnw2.Checked;
  adeMnw2WellScreens.Enabled := cbMnw2.Checked;
  rgMnw2WellType.Enabled := cbMnw2.Checked;
  clbMnw2LossTypes.Enabled := cbMnw2.Checked;
  cbMnw2Pumpcap.Enabled := cbMnw2.Checked;
  cbMnw2_PrintFlows.Enabled := cbMnw2.Checked;
  cbMnwi.Enabled := cbMnw2.Checked;
  cbMnw2PumpcapClick(Sender);
  cbMnwiClick(Sender);
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.cbMnw2PumpcapClick(Sender: TObject);
var
  ShouldEnable: Boolean;
  Index: Integer;
  Node: TTreeNode;
  Page: TWinControl;
  frameMnw2Pump: TframeMnw2Pump;
begin
  inherited;
  ShouldEnable := cbMnw2Pumpcap.Checked and cbMnw2.Checked;
  cbMnw2TimeVarying.Enabled := ShouldEnable and (comboMnw2SteadyState.ItemIndex = 1);
  if not cbMnw2TimeVarying.Enabled and not Loading and not Cancelling then
  begin
    cbMnw2TimeVarying.Checked := False;
  end;
  tvMnw2Pumps.Enabled := ShouldEnable;
  btnMnw2AddPump.Enabled := ShouldEnable;
  btnDeletePump.Enabled := ShouldEnable;
  Node := tvMnw2Pumps.Items.GetFirstNode;
  for Index := 0 to tvMnw2Pumps.Items.Count - 1 do
  begin
    Page := Node.Data;
    frameMnw2Pump := Page.Controls[0] as TframeMnw2Pump;
    frameMnw2Pump.Enabled := ShouldEnable;
    Node := Node.GetNext;
  end;
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.cbMnw2TimeVaryingClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.TwoMnwWarning;
begin
  if not Loading and not Cancelling then
  begin
    if cbMNW.Checked and cbMNW_Use.Checked
      and cbMnw2.Checked and cbUseMnw2.Checked then
    begin
      Beep;
      MessageDlg('Versions 1 and 2 of the Multi-Node Well package '
        + 'can not both be used in the same model.  '
        + 'You should correct this problem before '
        + 'attempting to run MODFLOW.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbMNWClick(Sender: TObject);
begin
  inherited;
  MNW_Warning;
  comboMNW_Steady.Enabled := cbMNW.Checked;
  SetComboColor(comboMNW_Steady);
  combMNW_LossType.Enabled := cbMNW.Checked;
  SetComboColor(combMNW_LossType);
  adeMNW_RefStressPer.Enabled := cbMNW.Checked;
  cbMNW_WellOutput.Enabled := cbMNW.Checked;
  cbMNW_WriteFlows.Enabled := cbMNW.Checked;
  cbMNW_TotalFlow.Enabled := cbMNW.Checked;
  cbMNW_PrintFlows.Enabled := cbMNW.Checked;
  cbFlowMNW.Enabled := cbMNW.Checked;
  cbMNW_Use.Enabled := cbMNW.Checked;
  cbMt3dMultinodeWellOutput.Enabled := cbMNW.Checked;
  if not Loading and not Cancelling and not cbMt3dMultinodeWellOutput.Enabled then
  begin
    cbMt3dMultinodeWellOutput.Checked := False;
  end;

  Activate_cbMNW_Alltime;
  ActivateMNWTimeVaryingParameters;
  EnableMNW_Coefficient;
  Activate_adeMNW_PLoss;
  ActivateComboMnwObservations;

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMNW_LayerType, cbMNW.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMNW_WaterQualityLayerType, cbMNW.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMNW_LocationParamClassType, cbMNW.Checked);

  AddOrRemoveMnwObservations;

  AddOrRemoveMT3D_MNW_Parameters;

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbMnwiClick(Sender: TObject);
var
  ShouldEnable: Boolean;
begin
  inherited;
  ShouldEnable := cbMnwi.Checked and cbMnw2.Checked;
  cbUseMnwi.Enabled := ShouldEnable;
  cbMnwiWel1flag.Enabled := ShouldEnable;
  cbMnwiQsumFlag.Enabled := ShouldEnable;
  cbMnwiByNdFlag.Enabled := ShouldEnable;
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.cbMNW_WriteFlowsClick(Sender: TObject);
begin
  inherited;
  Activate_cbMNW_Alltime;
  if cbMNW_WriteFlows.Checked and not Loading and not Cancelling
    and not cbMNW_PrintFlows.Checked then
  begin
    Beep;
    if MessageDlg('You will need to check the "Print Flows" checkbox '
      + 'too to get the data to be written to the output file.  Do you want '
      + 'to have it be checked now?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      cbMNW_PrintFlows.Checked := True;
    end;

  end;

end;

procedure TfrmMODFLOW.cbMNW_TotalFlowClick(Sender: TObject);
begin
  inherited;
  Activate_cbMNW_Alltime;
end;

procedure TfrmMODFLOW.ActivateMNWTimeVaryingParameters;
var
  Index: integer;
  ConcIndex: integer;
  CompCount: integer;
begin
  clbMNW_TimeVaryingParameters.Enabled := cbMNW.Checked and
    (comboMNW_Steady.ItemIndex = 1);
  if not clbMNW_TimeVaryingParameters.Enabled then
  begin
    for Index := 0 to clbMNW_TimeVaryingParameters.Items.Count -1 do
    begin
      clbMNW_TimeVaryingParameters.State[Index] := cbUnchecked;
    end;
    clbMNW_TimeVaryingParametersClickCheck(clbMNW_TimeVaryingParameters);
  end;
  if clbMNW_TimeVaryingParameters.Enabled  then
  begin
    CompCount := StrToInt(adeMT3DNCOMP.Text);
    for Index := Ord(mnwMt3dConc1) to Ord(mnwMt3dConc5) do
    begin
      ConcIndex := Index - Ord(mnwMt3dConc1) +1;
      clbMNW_TimeVaryingParameters.ItemEnabled[Index] := cbMT3D.Checked and
        (ConcIndex <= CompCount);
    end;
  end;
end;

procedure TfrmMODFLOW.comboMNW_SteadyChange(Sender: TObject);
begin
  inherited;
  ActivateMNWTimeVaryingParameters;
  AddOrRemoveMT3D_MNW_Parameters;
end;

procedure TfrmMODFLOW.clbMnw2LossTypesClickCheck(Sender: TObject);
begin
  inherited;
  AddOrRemoveMnw2LayersAndParameters;
end;

procedure TfrmMODFLOW.clbMNW_TimeVaryingParametersClickCheck(
  Sender: TObject);
var
  Index: MultiNodeWellTransientParameters;
  ParamClass : T_ANE_ParamClass;
  ParamClasses :array of T_ANE_ParamClass;
  ParamIndex: integer;
begin
  inherited;
  if cbMNW.Checked then
  begin
    for Index := Low(MultiNodeWellTransientParameters) to
      High(MultiNodeWellTransientParameters) do
    begin
      case Index of
        mnwWaterQuality:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMFMNW_WaterQualityParamClassType;
          end;
        mnwLimitingElevation:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMFMNW_LimitingElevationParamClassType;
          end;
        mnwDrawdownFlag:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMFMNW_DrawdownFlagParamClassType;
          end;
        mnwRefElev:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] :=
              ModflowTypes.GetMFMNW_ReferenceElevationParamClassType;
          end;
        mnwGroupID:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] :=
              ModflowTypes.GetMFMNW_GroupIndentifierParamClassType;
          end;
        mnwPumpingLimits:
          begin
            SetLength(ParamClasses, 4);
            ParamClasses[0] :=
              ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType;
            ParamClasses[1] :=
              ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType;
            ParamClasses[2] :=
              ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType;
            ParamClasses[3] :=
              ModflowTypes.GetMFMNW_PumpingLimitsParamClassType;
          end;
        mnwWellRadius:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMFMNW_RadiusParamClassType;
          end;
        mnwSkin:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMFMNW_SkinParamClassType;
          end;
        mnwCoefficient:
          begin
            if combMNW_LossType.ItemIndex = 2 then
            begin
              SetLength(ParamClasses, 1);
              ParamClasses[0] :=
                ModflowTypes.GetMFMNW_CoefficientParamClassType;
            end
            else
            begin
              SetLength(ParamClasses, 0);
//              ParamClasses[0] := nil;
            end;
          end;
        mnwMt3dConc1:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMT3DConcentrationParamClassType;
          end;
        mnwMt3dConc2:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMT3DConc2ParamClassType;
          end;
        mnwMt3dConc3:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMT3DConc3ParamClassType;
          end;
        mnwMt3dConc4:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMT3DConc4ParamClassType;
          end;
        mnwMt3dConc5:
          begin
            SetLength(ParamClasses, 1);
            ParamClasses[0] := ModflowTypes.GetMT3DConc5ParamClassType;
          end;
      else Assert(False);
      end;
      for ParamIndex := 0 to Length(ParamClasses)-1 do
      begin
        ParamClass := ParamClasses[ParamIndex];

        if clbMNW_TimeVaryingParameters.Checked[Integer(Index)] then
        begin
          if Index = mnwWaterQuality then
          begin
            MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
              (ParamClass, ModflowTypes.GetMFMNW_WaterQualityLayerType);
          end
          else
          begin
            MFLayerStructure.UnIndexedLayers.MoveParamToIndParam2
              (ParamClass, ModflowTypes.GetMFMNW_LayerType);
          end;
        end
        else
        begin
          if Index = mnwWaterQuality then
          begin
            MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
              (ParamClass, ModflowTypes.GetMFMNW_WaterQualityLayerType);
          end
          else
          begin
            MFLayerStructure.UnIndexedLayers.MoveIndParam2ToParam
              (ParamClass, ModflowTypes.GetMFMNW_LayerType);
          end;

        end;
        if Index = mnwWaterQuality then
        begin
          MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2(
            ModflowTypes.GetMFMNW_WaterQualityLayerType, ParamClass,
            clbMNW_TimeVaryingParameters.Checked[Integer(Index)]);
        end
        else
        begin
          MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
            ModflowTypes.GetMFMNW_LayerType, ParamClass,
            clbMNW_TimeVaryingParameters.Checked[Integer(Index)]);
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.EnableMNW_Coefficient;
begin
  clbMNW_TimeVaryingParameters.ItemEnabled[Ord(mnwCoefficient)] :=
    cbMNW.Checked and (combMNW_LossType.ItemIndex = 2);

  // required to make the text for the newly enabled item
  // be in black instead of gray.
  clbMNW_TimeVaryingParameters.Invalidate;
end;

procedure TfrmMODFLOW.combMNW_LossTypeChange(Sender: TObject);
begin
  inherited;
  EnableMNW_Coefficient;
  Activate_adeMNW_PLoss;

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_CoefficientParamClassType,
    (combMNW_LossType.ItemIndex = 2) and not
    clbMNW_TimeVaryingParameters.Checked[Ord(mnwCoefficient)]);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFMNW_LayerType,
    ModflowTypes.GetMFMNW_CoefficientParamClassType,
    (combMNW_LossType.ItemIndex = 2) and 
    clbMNW_TimeVaryingParameters.Checked[Ord(mnwCoefficient)]);
end;

procedure TfrmMODFLOW.cbMNW_PrintFlowsClick(Sender: TObject);
begin
  inherited;
  if cbMNW_PrintFlows.Checked then
  begin
    cbFlowMNW.Checked := False;
  end;
end;

procedure TfrmMODFLOW.GeologyWarning;
begin
  if not Loading and not cancelling then
  begin
    if not Simulated(1) or not Simulated(dgGeol.RowCount -1) then
    begin
      Beep;
      MessageDlg('Warning: The uppermost and lowermost geologic units must be '
        + 'simulated.  If you don''t need one of those units to be simulated, '
        + 'you should delete it.  You must fix this problem before attemping '
        + 'to run MODFLOW.', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.MNW_Warning;
begin
  if not Loading and not Cancelling then
  begin
    if rbModflow96.Checked and cbMNW.Checked and cbMNW_Use.Checked then
    begin
      Beep;
      MessageDlg('The Multi-Node Well package is only supported in the MODFLOW '
        + 'GUI with MODFLOW-2000.  You should correct this problem before '
        + 'attempting to run MODFLOW.', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbMNW_UseClick(Sender: TObject);
begin
  inherited;
  MNW_Warning;
end;

procedure TfrmMODFLOW.DaflowWarning;
begin
  if not Loading and not cancelling then
  begin
    if cbDAFLOW.Checked and not rbMODFLOW2000.Checked then
    begin
      Beep;
      MessageDlg('DAFLOW is only supported in MODFLOW-2000.', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbDAFLOWClick(Sender: TObject);
begin
  inherited;
  DaflowWarning;
  cbUseDAFLOW.Enabled := cbDAFLOW.Checked;
  adeDAFLOW_Title.Enabled := cbDAFLOW.Checked;
  adeDAF_PrintoutInterval.Enabled := cbDAFLOW.Checked;
  adeDAF_PeakDischarge.Enabled := cbDAFLOW.Checked;
  adeDAF_TimeStepSize.Enabled := cbDAFLOW.Checked;
  comboDAF_TimeStepUnits.Enabled := cbDAFLOW.Checked;
  adeDAF_StartTime.Enabled := cbDAFLOW.Checked;
  adeDAF_EndTime.Enabled := cbDAFLOW.Checked;
  adeDAF_BoundaryTimes.Enabled := cbDAFLOW.Checked;
  cbDAF_Debug.Enabled := cbDAFLOW.Checked;
  cbDAF_CentralDifferencing.Enabled := cbDAFLOW.Checked;
  cbFlowDaflow.Enabled := cbDAFLOW.Checked;
  SetComboColor(comboDAF_TimeStepUnits);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFDaflowLayerType, cbDAFLOW.Checked);

end;

procedure TfrmMODFLOW.adeDAF_BoundaryTimesEnter(Sender: TObject);
begin
  inherited;
  PreviousDaflowTimes := StrToInt(adeDAF_BoundaryTimes.Text);
end;

procedure TfrmMODFLOW.adeDAF_BoundaryTimesExit(Sender: TObject);
var
  NewDaflowTimes: integer;
  ADaflowLayer: T_ANE_InfoLayer;
  TimeIndex: integer;
  LayerIndex: integer;
  AnIndexedLayerList: T_ANE_IndexedLayerList;
  NumberOfUnits: integer;
  ParamList: T_ANE_IndexedParameterList;
begin
  // triggering event: adeFHBNumTimes.OnExit;
  inherited;

  // determine the new number of flow-and-head boundary times.
  NewDaflowTimes := StrToInt(adeDAF_BoundaryTimes.Text);

  // don't try to do this if you aren't using the FHB package
  // cbFHB.Checked may be false when this method is called
  // when openning a file.
  if cbDAFLOW.Checked then
  begin
    // add or remove time-related parameters as required
    if NewDaflowTimes > PreviousDaflowTimes then
    begin
      // add time-related parameters as required
      for TimeIndex := PreviousDaflowTimes + 1 to NewDaflowTimes do
      begin
        // add time-related parameters to the Daflow layers.
        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
          ModflowTypes.GetMFDaflowLayerType,
          ModflowTypes.GetMFDaflowTimeParamListType, -1);
      end;
    end
    else
    begin
      // First get the number of units
      NumberOfUnits := StrToInt(edNumUnits.Text);

      // loop over all the units.
      for LayerIndex := 0 to NumberOfUnits - 1 do
      begin
        // get each geologic unit
        AnIndexedLayerList := MFLayerStructure.ListsOfIndexedLayers.
          GetNonDeletedIndLayerListByIndex(LayerIndex);

        // get the point FHB layer
        ADaflowLayer := AnIndexedLayerList.GetLayerByName
          (ModflowTypes.GetMFDaflowLayerType.ANE_LayerName)
          as T_ANE_InfoLayer;

        // delete FHB time parameters from the point FHB layer
        for TimeIndex := PreviousDaflowTimes - 1 downto NewDaflowTimes do
        begin
          ParamList := (ADaflowLayer as ModflowTypes.GetMFDaflowLayerType).
            IndexedParamList1.
            GetNonDeletedIndParameterListByIndex(TimeIndex);
          if ParamList <> nil then
          begin
            ParamList.DeleteSelf;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.DaflowWarnings(Const Messages: TStringList);
var
  TimeIndex: integer;
  WarningMessage: string;
begin
  if not Loading and not Cancelling and cbDAFLOW.Checked
    and cbUseDAFLOW.Checked then
  begin
    Messages.Clear;
    if comboTimeUnits.ItemIndex = 0 then
    begin
      Messages.Add('You must specify the time units on the Project tab '
        + 'when using DAFLOW.');
    end;
    if comboLengthUnits.ItemIndex in [0,3] then
    begin
      Messages.Add('You must specify the length units on the Project tab '
        + 'as either meters or feet when using DAFLOW.');
    end;
    for TimeIndex := 1 to dgTime.RowCount -1 do
    begin
      if StrToFloat(dgTime.Cells[Ord(tdMult) , TimeIndex]) <> 1 then
      begin
        Messages.Add('Usually the time step multipliers on the Time tab should '
          + 'be set to 1 when using DAFLOW because the ground-water time steps '
          + 'must be evenly divisible by the surface-water time steps.');
        break;
      end;
    end;
    if StrToFloat(adeDAF_TimeStepSize.Text) <= 0 then
    begin
      Messages.Add('The DAFLOW surface-water time step size must be greater '
        + 'than or equal to 0.');
    end;
    WarningMessage := DaflowFirstTimeError;
    if WarningMessage <> '' then
    begin
      Messages.Add(WarningMessage);
    end;
    WarningMessage := DaflowLastTimeError;
    if WarningMessage <> '' then
    begin
      Messages.Add(WarningMessage);
    end;
  end;
end;

procedure TfrmMODFLOW.ShowDaflowWarning;
var
  Warnings: TStringList;
  AWord: string;
begin
  Warnings := TStringList.Create;
  try
    DaflowWarnings(Warnings);
    if Warnings.Count > 0 then
    begin
      if Warnings.Count = 1 then
      begin
        AWord := 'this';
      end
      else
      begin
        AWord := 'these';
      end;

      Warnings.Add('');
      Warnings.Add('You should fix ' + AWord + ' problems before trying to '
        + 'run MODFLOW.');
      Beep;
      MessageDlg(Warnings.Text, mtWarning, [mbOK], 0);
    end;

  finally
    Warnings.Free;
  end;

end;

procedure TfrmMODFLOW.cbBFLXClick(Sender: TObject);
begin
  inherited;
  comboMODPATH_RechargeITOP.Enabled := cbRCH.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked));
  SetComboColor(comboMODPATH_RechargeITOP);

  comboMODPATH_EvapITOP.Enabled := (cbEVT.Checked
    and (cbMODPATH.Checked or (cbMOC3D.Checked and cbBFLX.Checked)))
    or (cbETS.Checked and cbMOC3D.Checked and cbBFLX.Checked);
  SetComboColor(comboMODPATH_EvapITOP);

  // update IFACE parameters.
  UpdateIFACE;
end;

procedure TfrmMODFLOW.HUF_HFB_Warning;
begin
  if not Loading and not Cancelling then
  begin
    if (rgFlowPackage.ItemIndex = 2) and HufParameterUsed(hufLVDA)
      and cbHFB.Checked and cbHFBRetain.Checked then
    begin
      Beep;
      MessageDlg('The Horizontal Flow Barrier package should not be used '
        + 'with the LVDA capability of the HUF package.', mtWarning,
        [mbOK], 0);
    end;
  end;
end;

procedure TfrmMODFLOW.cbHUF_ReferenceSurfaceClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMFHUF_ReferenceSurfaceLayerClassType,
    (rgFlowPackage.ItemIndex = 2) and cbHUF_ReferenceSurface.Checked);
end;

procedure TfrmMODFLOW.adeADVParamCountEnter(Sender: TObject);
begin
  inherited;
  dg3dADVParameterClusters.Enabled := False;

end;

procedure TfrmMODFLOW.adeADVParamCountExit(Sender: TObject);
var
  ParameterCount: integer;
  Index: integer;
begin
  inherited;
  dg3dADVParameterClusters.Enabled := True;
  ParameterCount := StrToInt(adeADVParamCount.Text);
  btnDeleteADV_Parameter.Enabled := ParameterCount > 0;

  if ParameterCount > dg3dADVParameterClusters.PageCount then
  begin
    for Index := dg3dADVParameterClusters.PageCount + 1 to ParameterCount do
    begin
      addParamPage(dg3dADVParameterClusters);
    end;
  end
  else if ParameterCount < dg3dADVParameterClusters.PageCount then
  begin
    for Index := dg3dADVParameterClusters.PageCount - 1 downto ParameterCount do
    begin
      dg3dADVParameterClusters.RemoveGrid(Index);
    end;
  end;

  InitializeDataGrid(dgADVParameters, ParameterCount);

  InitializeMultParamPickLists(dg3dADVParameterClusters);
  InitializeZoneParamPickLists(dg3dADVParameterClusters);
end;

procedure TfrmMODFLOW.btnDeleteADV_ParameterClick(Sender: TObject);
var
  RowIndex, GridIndex: integer;
  FirstGrid, SecondGrid: TStringGrid;
  ARow: TStringList;
begin
  inherited;
  if (dgADVParameters.Row > 0)
    and (dgADVParameters.Row < dgADVParameters.RowCount) then
  begin
    ARow := TStringList.Create;
    try
      ARow.Assign(dgADVParameters.Rows[dgADVParameters.Row]);

      for GridIndex := dgADVParameters.Row to dgADVParameters.RowCount - 2 do
      begin
        dgADVParameters.Rows[GridIndex] := dgADVParameters.Rows[GridIndex + 1];
        FirstGrid := dg3dADVParameterClusters.Grids[GridIndex - 1];
        SecondGrid := dg3dADVParameterClusters.Grids[GridIndex];
        FirstGrid.RowCount := SecondGrid.RowCount;
        for RowIndex := 1 to FirstGrid.RowCount - 1 do
        begin
          FirstGrid.Rows[RowIndex] := SecondGrid.Rows[RowIndex];
        end;
        dg3dADVParameterClusters.Pages[GridIndex - 1].Caption :=
          dg3dADVParameterClusters.Pages[GridIndex].Caption
      end;
      dgADVParameters.Rows[dgADVParameters.RowCount - 1].Assign(ARow);
    finally
      ARow.Free;
    end;
    adeADVParamCount.Text := IntToStr(StrToInt(adeADVParamCount.Text) - 1);
    adeADVParamCountExit(Sender);
  end;
end;

procedure TfrmMODFLOW.cbSubClick(Sender: TObject);
begin
  inherited;
  SubsidenceWarnings;
  cbFlowSub.Enabled := cbSub.Checked;
  cbUseSUB.Enabled := cbSub.Checked;
  rdgSub.Enabled := cbSub.Checked;
  adeSubNN.Enabled := cbSub.Checked;
  adeSUB_AC1.Enabled := cbSub.Checked;
  adeSUB_AC2.Enabled := cbSub.Checked;
  adeSUB_ITMIN.Enabled := cbSub.Checked;
  adeSubISUBOC.Enabled := cbSub.Checked;
  cbSubSaveRestart.Enabled := cbSub.Checked;
  cbSubUseRestart.Enabled := cbSub.Checked;
  if rdgSub.Enabled then
  begin
    rdgSub.Color := clWindow;
  end
  else
  begin
    rdgSub.Color := clBtnFace;
  end;
  adeSubISUBOCExit(nil);
  cbSubUseRestartClick(nil);
end;

procedure TfrmMODFLOW.adeSubISUBOCExit(Sender: TObject);
var
  IBSUBOC: integer;
  RowIndex, ColIndex: integer;
  DefaultString: string;
begin
  inherited;
  IBSUBOC := StrToInt(adeSubISUBOC.Text);
  if (IBSUBOC <= 0) or not cbSub.Checked then
  begin
    dgSubOutput.Enabled := False;
    dgSubOutFormat.Enabled := False;
    dgSubOutput.Color := clBtnFace;
    dgSubOutFormat.Color := clBtnFace;
    Exit;
  end
  else
  begin
    dgSubOutput.Enabled := True;
    dgSubOutFormat.Enabled := True;
    dgSubOutput.Color := clWindow;
    dgSubOutFormat.Color := clWindow;
  end;
  dgSubOutput.RowCount := IBSUBOC + 1;
  DefaultString := dgSubOutput.Columns[4].PickList[0];
  for RowIndex := 2 to dgSubOutput.RowCount -1 do
  begin
    for ColIndex := 0 to 3 do
    begin
      if dgSubOutput.Cells[ColIndex,RowIndex] = '' then
      begin
        dgSubOutput.Cells[ColIndex,RowIndex]
          := dgSubOutput.Cells[ColIndex,RowIndex-1];
      end;
    end;
    for ColIndex := 4 to dgSubOutput.ColCount -1 do
    begin
      if dgSubOutput.Cells[ColIndex,RowIndex] = '' then
      begin
        dgSubOutput.Cells[ColIndex,RowIndex] := DefaultString;
      end;
    end;
  end;
end;

function TfrmMODFLOW.NoDelayInterbedCount(const UnitIndex: integer): integer;
begin
  if Simulated(UnitIndex) and cbSub.Checked then
  begin
    result := StrToInt(rdgSub.Cells[1,UnitIndex]);
  end
  else
  begin
    result := 0;
  end;
end;

function TfrmMODFLOW.NSYSTM: integer;
var
  Index: Integer;
begin
  result := 0;
  for Index := 1 to rdgSwt.RowCount -1 do
  begin
    result := result + SwtInterbedCount(Index) * DiscretizationCount(Index);
  end;
end;

procedure TfrmMODFLOW.EnableGwmStreamVariables;
begin
  cbGwmStreamVariables.Enabled := cb_GWM.Checked
    and (cbSTR.Checked or cbSFR.Checked);
  if not Loading and not Cancelling
    and not cbGwmStreamVariables.Enabled then
  begin
    cbGwmStreamVariables.Checked := False;
  end;
end;

procedure TfrmMODFLOW.UpdateGwmStateSP_Limits;
var
  AColumn: TRbwColumn4;
  NumPer: Integer;
begin
  NumPer := StrToInt(edNumPer.Text);
  AColumn := rdgGwmStorageVariables.Columns[Ord(gscStartSP)];
  AColumn.Max := NumPer;
  AColumn := rdgGwmStorageVariables.Columns[Ord(gscEndsSp)];
  AColumn.Max := NumPer;
end;

function TfrmMODFLOW.SwtInterbedCount(const UnitIndex: integer): integer;
begin
  if Simulated(UnitIndex) and cbSWT.Checked then
  begin
    result := StrToInt(rdgSwt.Cells[1,UnitIndex]);
  end
  else
  begin
    result := 0;
  end;
end;

procedure TfrmMODFLOW.EnableMt3dBinaryConcFiles;
begin
  rdgMt3dBinaryInitialConcFiles.Enabled := cbMT3D.Checked or cbSeaWat.Checked;
  adeMt3dmsBinaryStressPeriod.Enabled := rdgMt3dBinaryInitialConcFiles.Enabled;
  adeMt3dmsBinaryTimeStepChoice.Enabled := rdgMt3dBinaryInitialConcFiles.Enabled;
  adeMt3dmsBinaryTransportStepChoice.Enabled := rdgMt3dBinaryInitialConcFiles.Enabled;
end;

procedure TfrmMODFLOW.EnableBinaryStressPeriodAndTimeStep;
begin
  adeModflowBinaryStressPeriod.Enabled := cbInitial.Checked
    and (rbMODFLOW2000.Checked or rbMODFLOW2005.Checked)
    and (comboBinaryInitialHeadChoice.ItemIndex = 1);
  adeModflowBinaryTimeStepChoice.Enabled := adeModflowBinaryStressPeriod.Enabled;
end;

procedure TfrmMODFLOW.EnableReleaseTimeCount;
begin
  adeMODPATHMaxReleaseTime.Enabled := cbMODPATH.Checked
    and (comboMPATHDirection.ItemIndex = 0);
end;

procedure TfrmMODFLOW.DeleteMnw2PumpNode(Node: TTreeNode);
var
  Page: TJvStandardPage;
  frameMnw2Pump: TControl;
begin
  Page := Node.Data;
  frameMnw2Pump := Page.Controls[0];
  frameMnw2Pump.Free;
  Page.Free;
end;

function TfrmMODFLOW.DelayInterbedCount(const UnitIndex: integer): integer;
begin
  if Simulated(UnitIndex) and cbSub.Checked then
  begin
    result := StrToInt(rdgSub.Cells[2,UnitIndex]);
  end
  else
  begin
    result := 0;
  end;
end;

procedure TfrmMODFLOW.rdeGwmStateTimeCountEnter(Sender: TObject);
begin
  inherited;
  FPriorStateTimeCount := StrToInt(rdeGwmStateTimeCount.Output);
end;

procedure TfrmMODFLOW.rdeGwmStateTimeCountExit(Sender: TObject);
var
  NumTimes: Integer;
  TimeIndex: Integer;
  NumberOfUnits: Integer;
  LayerIndex: Integer;
  LayerList: T_ANE_IndexedLayerList;
  HeadStateLayer: T_ANE_InfoLayer;
  ParamList: T_ANE_IndexedParameterList;
  StreamStateLayer: T_ANE_InfoLayer;
begin
  inherited;
  NumTimes := StrToInt(rdeGwmStateTimeCount.Output);
  if cb_GWM.Checked then
  begin
    if NumTimes > FPriorStateTimeCount then
    begin
      for TimeIndex := FPriorStateTimeCount + 1 to NumTimes do
      begin
        // add time-related parameters to the point, line, and area
        // FHB layers.
        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList0(
          ModflowTypes.GetMFGwmHeadStateLayerType,
          ModflowTypes.GetMFGwmStressPeriodParamListType, -1);

        if cbGwmStreamVariables.Checked and (cbSTR.Checked or cbSFR.Checked) then
        begin

          MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList0(
            ModflowTypes.GetMFGwmStreamStateLayerType,
            ModflowTypes.GetMFGwmStressPeriodParamListType, -1);
        end;
      end;
    end
    else
    begin
      NumberOfUnits := StrToInt(edNumUnits.Text);
      for LayerIndex := 0 to NumberOfUnits - 1 do
      begin
        // get each geologic unit
        LayerList := MFLayerStructure.ListsOfIndexedLayers.
          GetNonDeletedIndLayerListByIndex(LayerIndex);

        // get the Head State layer
        HeadStateLayer := LayerList.GetLayerByName
          (ModflowTypes.GetMFGwmHeadStateLayerType.ANE_LayerName)
          as T_ANE_InfoLayer;

        // delete time parameters from the layer
        for TimeIndex := FPriorStateTimeCount - 1 downto NumTimes do
        begin
          ParamList := (HeadStateLayer as ModflowTypes.GetMFGwmHeadStateLayerType).
            IndexedParamList0.
            GetNonDeletedIndParameterListByIndex(TimeIndex);
          if ParamList <> nil then
          begin
            ParamList.DeleteSelf;
          end;
        end;

        if cbGwmStreamVariables.Checked and (cbSTR.Checked or cbSFR.Checked) then
        begin
          // get the stream State layer
          StreamStateLayer := LayerList.GetLayerByName
            (ModflowTypes.GetMFGwmStreamStateLayerType.ANE_LayerName)
            as T_ANE_InfoLayer;

          // delete time parameters from the layer
          for TimeIndex := FPriorStateTimeCount - 1 downto NumTimes do
          begin
            ParamList := (StreamStateLayer as ModflowTypes.GetMFGwmStreamStateLayerType).
              IndexedParamList0.
              GetNonDeletedIndParameterListByIndex(TimeIndex);
            if ParamList <> nil then
            begin
              ParamList.DeleteSelf;
            end;
          end;
        end;
      end;
    end;
  end;end;

procedure TfrmMODFLOW.rdeGwmStorageStateVarCountEnter(Sender: TObject);
begin
  inherited;
  FPriorGwmStateStoreCount := StrToInt(rdeGwmStorageStateVarCount.Output);
end;

procedure TfrmMODFLOW.rdeGwmStorageStateVarCountExit(Sender: TObject);
var
  NumberOfRows: integer;
  ColIndex: Integer;
  RowIndex: Integer;
  NumVariables: Integer;
  VarNames: TStringList;
  NewName: string;
  NameIndex: Integer;
  StorageUsed: Boolean;
begin
  inherited;
  ActivateParametersTab;
  NumVariables := StrToInt(rdeGwmStorageStateVarCount.Output);
  btnDeleteGwmStorageStateVar.Enabled := (NumVariables > 0) and IsAnyTransient;
  NumberOfRows := Max(2, NumVariables + 1);
  rdgGwmStorageVariables.RowCount := NumberOfRows;
  if (NumVariables = 0) or not IsAnyTransient then
  begin
    if not Loading and not Cancelling then
    begin
      for ColIndex := 0 to rdgGwmStorageVariables.ColCount - 1 do
      begin
        rdgGwmStorageVariables.Cells[ColIndex, 1] := '';
      end;
    end;
    rdgGwmStorageVariables.Enabled := False;
  end
  else
  begin
    rdgGwmStorageVariables.Enabled := True;

    VarNames := TStringList.Create;
    try
      VarNames.Assign(rdgGwmStorageVariables.Cols[Ord(gscName)]);
      while VarNames.Count > rdgGwmStorageVariables.RowCount do
      begin
        VarNames.Delete(VarNames.Count-1);
      end;
      VarNames.Delete(0);

      for RowIndex := 1 to rdgGwmStorageVariables.RowCount - 1 do
      begin
        if rdgGwmStorageVariables.Cells[Ord(gscName), RowIndex] = '' then
        begin
          NewName :=  'Stor' + IntToStr(RowIndex);
          if VarNames.IndexOf(NewName) >= 0 then
          begin
            for NameIndex  := RowIndex+1 to MAXINT - 1 do
            begin
              NewName :=  'Stor' + IntToStr(NameIndex);
              if VarNames.IndexOf(NewName) < 0 then
              begin
                break;
              end;
            end;
          end;
          rdgGwmStorageVariables.Cells[Ord(gscName), RowIndex] := NewName;
        end;
        if rdgGwmStorageVariables.Cells[Ord(gscStartSP), RowIndex] = '' then
        begin
          rdgGwmStorageVariables.Cells[Ord(gscStartSP), RowIndex] := '1';
        end;
        if rdgGwmStorageVariables.Cells[Ord(gscEndsSp), RowIndex] = '' then
        begin
          rdgGwmStorageVariables.Cells[Ord(gscEndsSp), RowIndex] := '1';
        end;
        if rdgGwmStorageVariables.ItemIndex[Ord(gscZoneChoice), RowIndex] < 0 then
        begin
          rdgGwmStorageVariables.ItemIndex[Ord(gscZoneChoice), RowIndex] := 0;
        end;
        if rdgGwmStorageVariables.Cells[Ord(gscZoneNumber), RowIndex] = '' then
        begin
          rdgGwmStorageVariables.Cells[Ord(gscZoneNumber), RowIndex] := IntToStr(RowIndex);
        end;
      end;
    finally
      VarNames.Free;
    end;
  end;

  StorageUsed := cb_GWM.Checked 
    and (StrToInt(rdeGwmStorageStateVarCount.Output) >= 1);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFGwmStorageStateLayerType, StorageUsed);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMF_GridGwmZoneParamType,
    StorageUsed);

end;

procedure TfrmMODFLOW.rdgGwmStorageVariablesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if (ARow >= 1) and (ACol >= Ord(gscZoneNumber))
    and (rdgGwmStorageVariables.ItemIndex[Ord(gscZoneChoice), ARow] <> 1) then
  begin
    CanSelect := False;
  end;
end;

procedure TfrmMODFLOW.rdgMt3dBinaryInitialConcFilesButtonClick(Sender: TObject;
  ACol, ARow: Integer);
var
  rootName: string;
  DotPosition: Integer;
  AChar: Char;
  RowIndex: Integer;
begin
  inherited;
  if odMt3dBinaryFileName.Execute then
  begin

    rootName := ExtractFileName(odMt3dBinaryFileName.FileName);
    rdgMt3dBinaryInitialConcFiles.Cells[ACol, ARow] := rootName;
    DotPosition := Pos('.', rootName);
    if DotPosition > 0 then
    begin
      rootName := Copy(rootName, 1, DotPosition - 1);
    end;
    AChar := 'A';
    for RowIndex := 1 to rdgMt3dBinaryInitialConcFiles.RowCount - 1 do
    begin
      if LowerCase(rootName + AChar) = LowerCase(adeFileName.Text) then
      begin
        Beep;
        MessageDlg('Error: The rootname for MODFLOW simulation files (' +
          rdgMt3dBinaryInitialConcFiles.Cells[ACol, ARow]
          + ') has the same root as the file you have choosen ('
          + edInitial.Text +
          '). You should correct this before running MODFLOW.',
          mtError, [mbOK], 0);
        break;
      end;
      Inc(AChar);
    end;

  end;
end;

procedure TfrmMODFLOW.rdgMt3dBinaryInitialConcFilesSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  CanSelect := rdgMt3dBinaryInitialConcFiles.Enabled;
  if not rdgMt3dBinaryInitialConcFiles.Drawing and (ACol >= 1) and (ARow >= 1) then
  begin
    odMt3dBinaryFileName.FileName := rdgMt3dBinaryInitialConcFiles.Cells[ACol, ARow];
  end;

end;

procedure TfrmMODFLOW.rdgSubDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  CanSelect: boolean;
  Grid: TRbwDataGrid;
begin
  inherited;
  Grid := Sender as TRbwDataGrid;
  if (ACol >= Grid.FixedCols) and (ARow >= Grid.FixedRows)
    and Grid.Enabled then
  begin
    CanSelect := True;
    rdgSubSelectCell(Sender, ACol, ARow, CanSelect);
    if not CanSelect then
    begin
      Grid.Canvas.Brush.Color := clBtnFace;
      Grid.Canvas.Font.Color := clBlack;
      // draw the text
      Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
        Grid.Cells[ACol, ARow]);
      Grid.Canvas.Pen.Color := clBlack;
      Grid.Canvas.MoveTo(Rect.Right, Rect.Top);
      Grid.Canvas.LineTo(Rect.Right, Rect.Bottom);
      Grid.Canvas.LineTo(Rect.Left, Rect.Bottom);
      Grid.Canvas.LineTo(Rect.Left, Rect.Top);
      Grid.Canvas.LineTo(Rect.Right, Rect.Top);
    end;
  end;
end;

procedure TfrmMODFLOW.rdgSubSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  Grid: TRbwDataGrid;
begin
  inherited;
  Grid := Sender as TRbwDataGrid;
  if (ACol >= Grid.FixedCols) and (ARow >= Grid.FixedRows) then
  begin
    CanSelect := Simulated(ARow);
  end;
end;

procedure TfrmMODFLOW.SetSubsidenceLayers;
var
  UnitIndex: integer;
  GeoUnit: T_ANE_IndexedLayerList;
  SubLayer: TCustomSubsidenceLayer;
begin
  for UnitIndex := 1 to dgGeol.RowCount -1 do
  begin
    GeoUnit := MFLayerStructure.ListsOfIndexedLayers.
      GetNonDeletedIndLayerListByIndex(UnitIndex-1);
    if GeoUnit <> nil then
    begin
      GeoUnit.AddOrRemoveLayer(ModflowTypes.GetMFNoDelaySubsidenceLayerType,
        NoDelayInterbedCount(UnitIndex) > 0);
      GeoUnit.AddOrRemoveLayer(ModflowTypes.GetMFDelaySubsidenceLayerType,
        DelayInterbedCount(UnitIndex) > 0);
      if NoDelayInterbedCount(UnitIndex) > 0 then
      begin
        SubLayer :=GeoUnit.GetLayerByName(ModflowTypes.
          GetMFNoDelaySubsidenceLayerType.ANE_LayerName)
          as TCustomSubsidenceLayer;
        SubLayer.Count := NoDelayInterbedCount(UnitIndex);
      end;
      if DelayInterbedCount(UnitIndex) > 0 then
      begin
        SubLayer :=GeoUnit.GetLayerByName(ModflowTypes.
          GetMFDelaySubsidenceLayerType.ANE_LayerName)
          as TCustomSubsidenceLayer;
        SubLayer.Count := DelayInterbedCount(UnitIndex);
      end;
    end;
  end;
end;

function TfrmMODFLOW.IsSteadyStateStress(const ARow: integer): boolean;
begin
  result := dgTime.Cells[Ord(tdSsTr), ARow]
    = dgTime.Columns[Ord(tdSsTr)].PickList[1];
end;

procedure TfrmMODFLOW.SubsidenceWarnings;
var
  Index: integer;
begin
  if ((cbSub.Checked and cbUseSUB.Checked)
    or (cbSWT.Checked and cbUseSWT.Checked))
    and not Loading then
  begin
    if cbIBS.Checked and cbUseIBS.Checked then
    begin
      Beep;
      MessageDlg('MODFLOW does not allow the Interbed Storage package and '
        + 'the Subsidence or SWT packages to be used in the same model.  You should '
        + 'fix this before trying to run MODFLOW.', mtWarning, [mbOK], 0);
    end;
    if cbSensitivity.Checked then
    begin
      Beep;
      MessageDlg('MODFLOW does not allow the Sensitivity process and '
        + 'the Subsidence and SWT packages to be used in the same model.  You should '
        + 'fix this before trying to run MODFLOW.', mtWarning, [mbOK], 0);
    end;
    for Index := 2 to dgTime.RowCount -1 do
    begin
      if IsSteadyStateStress(Index) then
      begin
        Beep;
        MessageDlg('Only the first stress period can be a steady-state '
          + 'stress period when the Subsidence or SWT package to be used.  You should '
          + 'fix this before trying to run MODFLOW.', mtWarning, [mbOK], 0);
        Break;
      end;
    end;
    if (cbSWT.Checked and cbUseSWT.Checked) then
    begin
      for Index := 1 to UnitCount do
      begin
        if not Simulated(Index) then
        begin
          Beep;
          MessageDlg('Quasi-3D models are not allowed with the SWT package.  '
            + 'You should fix this before trying to run MODFLOW.',
            mtWarning, [mbOK], 0);
          break;
        end;
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.cbSubUseRestartClick(Sender: TObject);
begin
  inherited;
  framSubRestartFile.Enabled := cbSubUseRestart.Checked and cbSub.Checked;;
end;

procedure TfrmMODFLOW.dgSubOutputSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  AValue: integer;
begin
  inherited;
  if (ACol <= 3) and (ARow >= 0) and (Value <> '') then
  begin
    try
      AValue := StrToInt(Value);
      if AValue <1 then
      begin
        Beep;
        dgSubOutput.Cells[ACol,ARow] := dgSubOutputCellText
      end
      else
      begin
        dgSubOutputCellText := Value
      end;
    except On EConvertError do
      begin
        Beep;
        dgSubOutput.Cells[ACol,ARow] := dgSubOutputCellText
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.dgSubOutputSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  dgSubOutputCellText := dgSubOutput.Cells[ACol,ARow];
end;

procedure TfrmMODFLOW.dgSubOutputExit(Sender: TObject);
var
  ColIndex, RowIndex: integer;
begin
  inherited;
  for RowIndex := 1 to dgSubOutput.RowCount -1 do
  begin
    for ColIndex := 0 to 3 do
    begin
      if dgSubOutput.Cells[ColIndex,RowIndex] = '' then
      begin
        dgSubOutput.Cells[ColIndex,RowIndex] := '1';
      end;
    end;
  end;
end;

function TfrmMODFLOW.SubNNDB: integer;
var
  Index: integer;
begin
  result := 0;
  for Index := 1 to rdgSub.RowCount -1 do
  begin
    result := result + NoDelayInterbedCount(Index)*DiscretizationCount(Index);
  end;
end;

function TfrmMODFLOW.SubNDB: integer;
var
  Index: integer;
begin
  result := 0;
  for Index := 1 to rdgSub.RowCount -1 do
  begin
    result := result + DelayInterbedCount(Index)*DiscretizationCount(Index);
  end;
end;

procedure TfrmMODFLOW.cbSFRRetainClick(Sender: TObject);
begin
  inherited;
  SFR_Warning
end;

procedure TfrmMODFLOW.cbAreaWellContourClick(Sender: TObject);
begin
  inherited;

  if not Loading then
  begin
    MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
      (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridWellParamType,
      ModflowTypes.GetMFGridWellParamType.ANE_ParamName, True);
  end;
end;

procedure TfrmMODFLOW.cbAreaRiverContourClick(Sender: TObject);
begin
  inherited;
  if not Loading then
  begin
    MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
      (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRiverParamType,
      ModflowTypes.GetMFGridRiverParamType.ANE_ParamName, True);
  end;
end;

procedure TfrmMODFLOW.cbAreaDrainContourClick(Sender: TObject);
begin
  inherited;
  if not Loading then
  begin
    MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
      (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridDrainParamType,
      ModflowTypes.GetMFGridDrainParamType.ANE_ParamName, True);
  end;
end;

procedure TfrmMODFLOW.EnableAreaDrainReturnContour;
begin
  cbAreaDrainRetrunContour.Enabled := not cbAltDrt.Checked and cbDRT.Checked
    and cbUseAreaDrainReturns.Checked;
  if cbAltDrt.Enabled and cbAltDrt.Checked and not Loading
    and not Cancelling then
  begin
    cbAreaDrainRetrunContour.Checked := False;
  end;
end;


procedure TfrmMODFLOW.cbAltDrtClick(Sender: TObject);
begin
  inherited;
  EnableAreaDrainReturnContour;
  if cbAreaDrainRetrunContour.Enabled and not Loading and not Cancelling then
  begin
    cbAreaDrainRetrunContour.Checked := True;
  end;

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridDrainReturnParamType,
    ModflowTypes.GetGridDrainReturnParamType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.EnableAreaGHBContour;
begin
  cbAreaGHBContour.Enabled := not cbAltGHB.Checked and cbGHB.Checked
    and cbUseAreaGHBs.Checked;
  if cbAltGHB.Enabled and cbAltGHB.Checked and not Loading
    and not Cancelling then
  begin
    cbAreaGHBContour.Checked := False;
  end;
end;

procedure TfrmMODFLOW.cbAltGHBClick(Sender: TObject);
begin
  inherited;
  EnableAreaGHBContour;
  if cbAreaGHBContour.Enabled and not Loading and not Cancelling then
  begin
    cbAreaGHBContour.Checked := True;
  end;

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridGHBParamType,
    ModflowTypes.GetMFGridGHBParamType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.cbAreaDrainRetrunContourClick(Sender: TObject);
begin
  inherited;
  if not Loading then
  begin
    MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
      (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridDrainReturnParamType,
      ModflowTypes.GetGridDrainReturnParamType.ANE_ParamName, True);
  end;
end;

procedure TfrmMODFLOW.cbAreaGHBContourClick(Sender: TObject);
begin
  inherited;
  if not Loading then
  begin
    MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
      (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridGHBParamType,
      ModflowTypes.GetMFGridGHBParamType.ANE_ParamName, True);
  end;
end;

procedure TfrmMODFLOW.cbAreaCHDContourClick(Sender: TObject);
begin
  inherited;
  if not Loading then
  begin
    MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
      (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridCHDParamType,
      ModflowTypes.GetMFGridCHDParamType.ANE_ParamName, True);
  end;
end;

procedure TfrmMODFLOW.btnDeleteMulitplierClick(Sender: TObject);
var
//  GridLayer: T_ANE_GridLayer;
  MultiplierList: T_ANE_IndexedLayerList;
  LayerIndex, Index: integer;
  Layer: T_ANE_MapsLayer;
begin
  inherited;
  if dgMultiplier.Row > 0 then
  begin
    InitializeMultParamPickLists(dg3dLPFParameterClusters);
    InitializeMultParamPickLists(dg3dHUFParameterClusters);
    InitializeMultParamPickLists(dg3dRCHParameterClusters);
    InitializeMultParamPickLists(dg3dEVTParameterClusters);
    InitializeMultParamPickLists(dg3dETSParameterClusters);

//    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
//      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    MultiplierList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgMultipliers)];

    LayerIndex := 0;
    for Index := 1 to dgMultiplier.Row do
    begin
      if dgMultiplier.Cells[2, Index] = dgMultiplier.Columns[2].PickList[0] then
      begin
        inc(LayerIndex);
      end;
    end;
    if dgMultiplier.Cells[2, dgMultiplier.Row] = dgMultiplier.Columns[2].PickList[0] then
    begin
      Layer := MultiplierList.GetNonDeletedLayerByIndex(LayerIndex);
      Layer.Delete;
    end;
    adeMultCountEnter(adeMultCount);
    dgMultiplier.DeleteRow(dgMultiplier.Row);
    adeMultCount.Text := IntToStr(StrToInt(adeMultCount.Text) -1);
    adeMultCountExit(btnDeleteMulitplier);
  end;


end;

procedure TfrmMODFLOW.dgMultiplierDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if (dgMultiplier.Row = ARow) and (ACol > 0) and (ARow > 0) then
  begin
    dgMultiplier.Canvas.Brush.Color := clAqua;
    dgMultiplier.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
      dgMultiplier.Cells[ACol, ARow]);
  end;
end;

Type
  TMyStringGrid = class(TStringGrid);

procedure TfrmMODFLOW.btnDeleteZoneClick(Sender: TObject);
var
  ZoneList: T_ANE_IndexedLayerList;
  LayerIndex: integer;
  Layer: T_ANE_MapsLayer;
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  if sgZoneArrays.Row > 0 then
  begin
    LayerIndex := sgZoneArrays.Row;
    ZoneList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgZones)];
    Layer := ZoneList.GetNonDeletedLayerByIndex(LayerIndex);
    Layer.Delete;
    TMyStringGrid(sgZoneArrays).DeleteRow(sgZoneArrays.Row);
    adeZoneCount.Text := IntToStr(StrToInt(adeZoneCount.Text) -1);
    adeZoneCountExit(btnDeleteZone);
    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    DeleteZoneGridParameters(GridLayer, sgZoneArrays.RowCount - 1);
  end;
end;

procedure TfrmMODFLOW.sgZoneArraysDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if (sgZoneArrays.Row = ARow) and (ACol > 0) and (ARow > 0) then
  begin
    sgZoneArrays.Canvas.Brush.Color := clAqua;
    sgZoneArrays.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
      sgZoneArrays.Cells[ACol, ARow]);
  end;

end;

procedure TfrmMODFLOW.cbCondRivClick(Sender: TObject);
var
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  if not Loading and not Cancelling then
  begin
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetMFLineRiverLayerType,
      ModflowTypes.GetMFRiverConductanceParamType);
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetMFAreaRiverLayerType,
      ModflowTypes.GetMFRiverConductanceParamType);

    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    GridLayer.SetIndexed1ExpressionNow(ModflowTypes.GetMFGridRiverParamType,
      ModflowTypes.GetMFGridRiverParamType.ANE_ParamName, True);

    MFLayerStructure.SetAllParamUnits;
  end;
end;

procedure TfrmMODFLOW.cbCondDrnClick(Sender: TObject);
var
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  if not Loading and not Cancelling then
  begin
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetLineDrainLayerType,
      ModflowTypes.GetMFDrainConductanceParamType);
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetAreaDrainLayerType,
      ModflowTypes.GetMFDrainConductanceParamType);

    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    GridLayer.SetIndexed1ExpressionNow(ModflowTypes.GetMFGridDrainParamType,
      ModflowTypes.GetMFGridDrainParamType.ANE_ParamName, True);

    MFLayerStructure.SetAllParamUnits;
  end;
end;

procedure TfrmMODFLOW.cbCondDrnRtnClick(Sender: TObject);
var
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  if not Loading and not Cancelling then
  begin
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetMFLineDrainReturnLayerType,
      ModflowTypes.GetMFDrainReturnConductanceParamType);
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetMFAreaDrainReturnLayerType,
      ModflowTypes.GetMFDrainReturnConductanceParamType);

    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    GridLayer.SetIndexed1ExpressionNow(ModflowTypes.GetGridDrainReturnParamType,
      ModflowTypes.GetGridDrainReturnParamType.ANE_ParamName, True);

    MFLayerStructure.SetAllParamUnits;
  end;
end;

procedure TfrmMODFLOW.cbCondGhbClick(Sender: TObject);
var
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  if not Loading and not Cancelling then
  begin
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetLineGHBLayerType,
      ModflowTypes.GetMFGhbConductanceParamType);
    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetAreaGHBLayerType,
      ModflowTypes.GetMFGhbConductanceParamType);

    GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
    GridLayer.SetIndexed1ExpressionNow(ModflowTypes.GetMFGridGHBParamType,
      ModflowTypes.GetMFGridGHBParamType.ANE_ParamName, True);

    MFLayerStructure.SetAllParamUnits;
  end;
end;

procedure TfrmMODFLOW.cbSeaWatClick(Sender: TObject);
begin
  inherited;
  if cbSeaWat.Checked then
  begin
    rbMODFLOW2000.Checked := True;
  end;
  tabSeaWat.TabVisible := cbSeaWat.Checked;
  EnableMt3dBinaryConcFiles;

  AddOrRemoveSeaWatLayersAndParameters;

  cbSW_WellFluidDensityClick(nil);
  cbSW_RiverFluidDensityClick(nil);
  cbSW_GHB_FluidDensityClick(nil);
  cbSW_DrainElevationClick(nil);
  cbSW_RiverbedThicknessClick(nil);
  cbSW_GHB_ElevationClick(nil);
end;

procedure TfrmMODFLOW.EnableCoupledFlowAndTransport;
begin
  cbSW_Coupled.Enabled := cbSW_MT3D.Checked and cbSW_VDF.Checked;
  if not cbSW_Coupled.Enabled then
  begin
    cbSW_Coupled.Checked := False;
  end;
end;

procedure TfrmMODFLOW.cbSW_MT3DClick(Sender: TObject);
begin
  inherited;
  EnableCoupledFlowAndTransport;
end;

procedure TfrmMODFLOW.EnableMinAndMaxSeawatDensity;
var
  ShouldEnable: boolean;
//  NSWTCPL: integer;
begin
  ShouldEnable := cbSW_VDF.Checked;
  adeSW_MinDens.Enabled := ShouldEnable;
  adeSW_MaxDens.Enabled := ShouldEnable;
end;

procedure TfrmMODFLOW.EnableSeawatDenConvCrit;
begin
  adeSW_DenConvCrit.Enabled := cbSW_VDF.Checked
    and ((StrToInt(adeSW_MaxIt.Text) > 1) or (StrToInt(adeSW_MaxIt.Text) = -1));
end;

procedure TfrmMODFLOW.cbSW_VDFClick(Sender: TObject);
begin
  inherited;
  EnableCoupledFlowAndTransport;
  comboSW_InternodalDensity.Enabled := cbSW_VDF.Checked;
  adeSW_MaxIt.Enabled := cbSW_VDF.Checked;
  EnableMinAndMaxSeawatDensity;
  EnableSeawatDenConvCrit;
  EnableMultipCompControls;

  cbSW_WaterTableCorrections.Enabled := cbSW_VDF.Checked;
  adeRefFluidDens.Enabled := cbSW_VDF.Checked;
  adeSW_DenseSlope.Enabled := cbSW_VDF.Checked;
  adeSW_FirstTimeStepLength.Enabled := cbSW_VDF.Checked;
  comboSW_DensitySpecificationMethod.Enabled := cbSW_VDF.Checked and
    not cbSW_Coupled.Checked;
  SetComboColor(comboSW_InternodalDensity);
  SetComboColor(comboSW_DensitySpecificationMethod);

  cbSW_GHB_FluidDensity.Enabled := cbGHB.Checked and cbSW_VDF.Checked;
  cbSW_GHB_Elevation.Enabled := cbGHB.Checked and cbSW_VDF.Checked;
  cbSW_RiverbedThickness.Enabled := cbRIV.Checked and cbSW_VDF.Checked;
  cbSW_RiverFluidDensity.Enabled := cbRIV.Checked and cbSW_VDF.Checked;
  cbSW_WellFluidDensity.Enabled := cbWEL.Checked and cbSW_VDF.Checked;
  cbSW_DrainElevation.Enabled := cbDRN.Checked and cbSW_VDF.Checked;
  
  cbSW_WellFluidDensityClick(nil);
  cbSW_DrainElevationClick(nil);
  cbSW_RiverbedThicknessClick(nil);
  cbSW_RiverFluidDensityClick(nil);
  cbSW_GHB_FluidDensityClick(nil);
  cbSW_GHB_ElevationClick(nil);

  cbSeawatViscosity.Enabled := cbSW_VDF.Checked;
  if not Loading and not Cancelling then
  begin
    if not cbSeawatViscosity.Enabled then
    begin
      cbSeawatViscosity.Checked := False;
    end;
  end;

  AddOrRemoveSeaWatLayersAndParameters;
end;

procedure TfrmMODFLOW.EnableMultipCompControls;
var
  ShouldEnable: boolean;
begin
  ShouldEnable := frmModflow.cbSW_VDF.Checked
    and frmModflow.cbSW_Coupled.Checked
    and (frmModflow.comboDensityChoice.ItemIndex <> 0);
  adeSW_SlopePresHead.Enabled := ShouldEnable;
  adeSWRefHead.Enabled := ShouldEnable;
  adeSWDensCompCount.Enabled := ShouldEnable;
  rdgSWDensTable.Enabled := ShouldEnable;
  rdgSWDensTable.Invalidate;
end;


procedure TfrmMODFLOW.cbSW_CoupledClick(Sender: TObject);
begin
  inherited;
  EnableMultipCompControls;
  comboDensityChoice.Enabled := cbSW_Coupled.Checked;
  adeSW_ComponentChoice.Enabled := cbSW_Coupled.Checked
    and (comboDensityChoice.ItemIndex = 0);
  comboSW_DensitySpecificationMethod.Enabled := cbSW_VDF.Checked and
    not cbSW_Coupled.Checked;
  SetComboColor(comboSW_DensitySpecificationMethod);

  AddOrRemoveSeaWatLayersAndParameters;
end;

procedure TfrmMODFLOW.AddOrRemoveSeaWatLayersAndParameters;
var
  LayerShouldBePresent: boolean;
  ParamShouldBePresent: boolean;
begin
  LayerShouldBePresent := ModflowTypes.GetFluidDensityLayerType.LayerUsed;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetFluidDensityLayerType, LayerShouldBePresent);

  if LayerShouldBePresent then
  begin
    if ModflowTypes.GetMFFluidDensityParamType.TimeVarying then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFFluidDensityParamType,
        ModflowTypes.GetFluidDensityLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFFluidDensityParamType,
        ModflowTypes.GetFluidDensityLayerType);
    end;

    // add or remove parameters related to the simple reactions package
    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (ModflowTypes.GetFluidDensityLayerType,
      ModflowTypes.GetMFFluidDensityParamType,
      LayerShouldBePresent and
      ModflowTypes.GetMFFluidDensityParamType.TimeVarying);
  end;

  LayerShouldBePresent := ModflowTypes.GetMFViscosityLayerType.LayerUsed;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFViscosityLayerType, LayerShouldBePresent);

  if LayerShouldBePresent then
  begin
    if ModflowTypes.GetMFViscosityParamType.TimeVarying then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
        (ModflowTypes.GetMFViscosityParamType,
        ModflowTypes.GetMFViscosityLayerType);
    end
    else
    begin
      MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
        (ModflowTypes.GetMFViscosityParamType,
        ModflowTypes.GetMFViscosityLayerType);
    end;

    // add or remove parameters related to the simple reactions package
    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (ModflowTypes.GetMFViscosityLayerType,
      ModflowTypes.GetMFViscosityParamType,
      LayerShouldBePresent and
      ModflowTypes.GetMFViscosityParamType.TimeVarying);

    MFLayerStructure.ListsOfIndexedLayers.UpdateUnIndexedParamName(
      ModflowTypes.GetMFViscosityLayerType,
      ModflowTypes.GetMFViscosityParamType);
      
    MFLayerStructure.ListsOfIndexedLayers.UpdateIndexedParameter2ParamName(
      ModflowTypes.GetMFViscosityLayerType,
      ModflowTypes.GetMFViscosityParamType);
  end;

  ParamShouldBePresent := cbSeaWat.Checked and cbCHD.Checked;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMFSeawatDensityOptionParamType, ParamShouldBePresent);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointLineCHD_LayerType,
    ModflowTypes.GetMFChdFluidDensityParamType, ParamShouldBePresent);

  ParamShouldBePresent := cbSeaWat.Checked and cbCHD.Checked
    and cbUseAreaCHD.Checked;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMFSeawatDensityOptionParamType, ParamShouldBePresent);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaCHD_LayerType,
    ModflowTypes.GetMFChdFluidDensityParamType, ParamShouldBePresent);


end;

procedure TfrmMODFLOW.comboSW_DensitySpecificationMethodChange(
  Sender: TObject);
begin
  inherited;
  AddOrRemoveSeaWatLayersAndParameters;
end;

procedure TfrmMODFLOW.adeSW_MaxItExit(Sender: TObject);
begin
  inherited;
  EnableSeawatDenConvCrit;
end;

procedure TfrmMODFLOW.cbSW_WellFluidDensityClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInWells);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLineWellLayerType, ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInWells);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAreaWellLayerType,
    ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInWells
    and cbUseAreaWells.Checked);
end;

procedure TfrmMODFLOW.cbSW_RiverFluidDensityClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFPointRiverLayerType, ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLineRiverLayerType, ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAreaRiverLayerType,
    ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers
    and cbUseAreaRivers.Checked);
end;

procedure TfrmMODFLOW.cbSW_GHB_FluidDensityClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetPointGHBLayerType, ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetLineGHBLayerType, ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetAreaGHBLayerType,
    ModflowTypes.GetMFBoundaryDensityParamType,
    ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB
    and cbUseAreaGHBs.Checked);
end;

procedure TfrmMODFLOW.cbSW_DrainElevationClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetLineDrainLayerType, ModflowTypes.GetMFDrainBottomElevParamType,
    ModflowTypes.GetMFDrainBottomElevParamType.UseParameter);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetAreaDrainLayerType, ModflowTypes.GetMFDrainBottomElevParamType,
    ModflowTypes.GetMFDrainBottomElevParamType.UseParameter);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFPointDrainLayerType,
    ModflowTypes.GetMFDrainBottomElevParamType,
    ModflowTypes.GetMFDrainBottomElevParamType.UseParameter
    and cbUseAreaDrains.Checked);
end;

procedure TfrmMODFLOW.cbSW_RiverbedThicknessClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFPointRiverLayerType, ModflowTypes.GetMFRiverBedThicknessParamType,
    ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFLineRiverLayerType, ModflowTypes.GetMFRiverBedThicknessParamType,
    ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFAreaRiverLayerType, ModflowTypes.GetMFRiverBedThicknessParamType,
    ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter);
end;

procedure TfrmMODFLOW.cbSW_GHB_ElevationClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetPointGHBLayerType, ModflowTypes.GetMFElevationParamType,
    ModflowTypes.GetMFElevationParamType.UseInGHB);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetLineGHBLayerType, ModflowTypes.GetMFElevationParamType,
    ModflowTypes.GetMFElevationParamType.UseInGHB);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetAreaGHBLayerType, ModflowTypes.GetMFElevationParamType,
    ModflowTypes.GetMFElevationParamType.UseInGHB);

end;

procedure TfrmMODFLOW.comboGmgIscChange(Sender: TObject);
begin
  inherited;
  adeGmgRelax.Enabled := comboGmgIsc.ItemIndex = 4;
end;

function TfrmMODFLOW.GetPeriodAndStepFromTime(const ATime: double;
  out Period, Step: integer; const GetFirst: boolean;
  out RemainingTime: double): boolean;
var
  PeriodIndex: integer;
  StepIndex: integer;
  Time: double;
  FirstStepLength: double;
  NStep: integer;
  Mult: double;
  StepLength: double;
  PeriodLength: double;
  EndTime: double;
  ElapsedTime: double;
begin
  result := False;
  try
  Time := 0;
  Period := 0;
  Step := 0;
  ElapsedTime := 0;
  try
    for PeriodIndex := 1 to dgTime.RowCount -1 do
    begin
      PeriodLength := InternationalStrToFloat(dgTime.Cells[Ord(tdLength), PeriodIndex]);
      EndTime := Time + PeriodLength;
      If ATime > EndTime then
      begin
        Time := EndTime;
        ElapsedTime := ElapsedTime + PeriodLength;
        Continue;
      end;

      FirstStepLength := InternationalStrToFloat(dgTime.Cells[Ord(tdFirstStep), PeriodIndex]);
      NStep := StrToInt(dgTime.Cells[Ord(tdNumSteps), PeriodIndex]);
      Mult := InternationalStrToFloat(dgTime.Cells[Ord(tdMult), PeriodIndex]);
      StepLength := 0;
      for StepIndex := 1 to NStep do
      begin
        if StepIndex = 1 then
        begin
          StepLength := FirstStepLength;
        end
        else
        begin
          StepLength := StepLength * Mult;
        end;
        ElapsedTime := ElapsedTime + StepLength;
        if GetFirst then
        begin
          If Time >= ATime then
          begin
            Period := PeriodIndex;
            Step := StepIndex;
            if Time > ATime then
            begin
              if Step > 1 then
              begin
                Dec(Step);
              end
              else if Period > 1 then
              begin
                Dec(Period);
                Step := StrToInt(dgTime.Cells[Ord(tdNumSteps), Period]);
              end
            end;
            ElapsedTime := ElapsedTime - StepLength;
            result := True;
            Exit;
          end;
          Time := Time + StepLength;
        end
        else
        begin
          Time := Time + StepLength;
          If Time >= ATime then
          begin
            Period := PeriodIndex;
            Step := StepIndex;
            If Time > ATime then
            begin
              if Step < NStep then
              begin
                Inc(Step);
              {end
              else if Period < dgTime.RowCount -1 then
              begin
                Inc(Period);
                Step := 1; }
              end;
            end;
            ElapsedTime := ElapsedTime - StepLength;
            result := True;
            Exit;
          end;
        end;
      end;
    end;
  finally
    RemainingTime := ATime - ElapsedTime;
  end;
  except on EConvertError do
    begin
      result := False;
    end;

  end;
end;

procedure TfrmMODFLOW.adeModpathBeginExit(Sender: TObject);
var
  ATime: double;
  Period: integer;
  Step: integer;
  Dummy: double;
begin
  inherited;
  if (rgModpathPeriodStepMethod.ItemIndex = 1) and cbMODPATH.Checked
    and not Loading and not Cancelling then
  begin
    ATime := StrToFloat(adeModpathBegin.Text);
    if GetPeriodAndStepFromTime(ATime, Period, Step, True, Dummy) then
    begin
      adeModpathBeginPeriod.Text := IntToStr(Period);
      adeModpathBeginStep.Text := IntToStr(Step);
    end;
  end;
end;

procedure TfrmMODFLOW.adeModpathEndExit(Sender: TObject);
var
  ATime: double;
  Period: integer;
  Step: integer;
  Dummy: double;
begin
  inherited;
  if (rgModpathPeriodStepMethod.ItemIndex = 1) and cbMODPATH.Checked
    and not Loading and not Cancelling then
  begin
    ATime := StrToFloat(adeModpathEnd.Text);
    if GetPeriodAndStepFromTime(ATime, Period, Step, False, Dummy) then
    begin
      adeModpathEndPeriod.Text := IntToStr(Period);
      adeModpathEndStep.Text := IntToStr(Step);
    end;
  end;
end;

procedure TfrmMODFLOW.rgModpathPeriodStepMethodClick(Sender: TObject);
begin
  inherited;
  adeModpathBeginPeriod.Enabled := rgModpathPeriodStepMethod.ItemIndex = 0;
  adeModpathBeginStep.Enabled := adeModpathBeginPeriod.Enabled;
  adeModpathEndPeriod.Enabled := adeModpathBeginPeriod.Enabled;
  adeModpathEndStep.Enabled := adeModpathBeginPeriod.Enabled;

  adeModpathBegin.Enabled := rgModpathPeriodStepMethod.ItemIndex = 1;
  adeModpathEnd.Enabled := adeModpathBegin.Enabled;
end;

procedure TfrmMODFLOW.comboSpecifyParticlesChange(Sender: TObject);
var
  ShouldEnable: boolean;
begin
  inherited;
  ShouldEnable := ((comboSpecifyParticles.ItemIndex = 0)
    or not comboSpecifyParticles.Enabled) and (rgMOC3DSolver.ItemIndex <> 2);
  edMOC3DInitParticles.Enabled := ShouldEnable;
  SetControlColor(edMOC3DInitParticles);
  btnDistributeParticles.Enabled := ShouldEnable;
  cbCustomParticle.Enabled := ShouldEnable;

  ShouldEnable := (comboSpecifyParticles.ItemIndex = 2)
    and comboSpecifyParticles.Enabled;
      
  adeNPTLAY.Enabled := ShouldEnable;
  adeNPTROW.Enabled := ShouldEnable;
  adeNPTCOL.Enabled := ShouldEnable;

  if not cbCustomParticle.Enabled then
  begin
    cbCustomParticle.Checked := False;
  end;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCInitialParticlePlacementLayerType,
    WeightedParticlesUsed and (comboSpecifyParticles.ItemIndex <> 0)
    and cbMOC3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCParticleColumnCountParamType,
    WeightedParticlesUsed and (comboSpecifyParticles.ItemIndex = 1)
    and cbMOC3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCParticleRowCountParamType,
    WeightedParticlesUsed and (comboSpecifyParticles.ItemIndex = 1)
    and cbMOC3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMOCParticleLayerCountParamType,
    WeightedParticlesUsed and (comboSpecifyParticles.ItemIndex = 1)
    and cbMOC3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMocParticleLocationParamType,
    WeightedParticlesUsed and (comboSpecifyParticles.ItemIndex = 2)
    and cbMOC3D.Checked);

  MFLayerStructure.SetAllParamUnits;
end;

function TfrmMODFLOW.WeightedParticlesUsed: boolean;
begin
  result := rgMOC3DSolver.ItemIndex >= 3;
end;

procedure TfrmMODFLOW.comboIRANDChange(Sender: TObject);
begin
  inherited;
  adeIRAND.Enabled := comboIRAND.Enabled and (comboIRAND.ItemIndex = 2);
end;

procedure TfrmMODFLOW.cbCBDYClick(Sender: TObject);
var
  GridLayer: T_ANE_GridLayer;
begin
  inherited;
  sgMOC3DTransParam.Invalidate;

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType,
    ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType,
    ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType,
    ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.Used);

  GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
    (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

  GridLayer.ParamList.AddOrRemoveParameter(
    ModflowTypes.GetMFGridGwtUppBoundConcParamType,
    ModflowTypes.GetMFGridGwtUppBoundConcParamType.ANE_ParamName,
    ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used);

  GridLayer.ParamList.AddOrRemoveParameter(
    ModflowTypes.GetMFGridGwtLowBoundConcParamType,
    ModflowTypes.GetMFGridGwtLowBoundConcParamType.ANE_ParamName,
    ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used);

  GridLayer.AddOrRemoveIndexedParameter1(
    ModflowTypes.GetMFGridGwtLateralBoundConcParamType,
    ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.Used);
end;

procedure TfrmMODFLOW.cbCCBDClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetGWT_TimeVaryConcLayerType,
    cbMOC3D.Checked and cbCCBD.Checked);
end;

procedure TfrmMODFLOW.EnableCCBD;
begin
  cbCCBD.Enabled := cbMOC3D.Checked and (rgMOC3DSolver.ItemIndex in [3,4]);
  if not Loading and not Cancelling then
  begin
    if not cbCCBD.Enabled then
    begin
      cbCCBD.Checked := False;
    end;
  end;
end;

procedure TfrmMODFLOW.EnableSpecifiedOutputControls;
begin
  tabPrintHead.TabVisible           := comboHeadPrintFreq.ItemIndex = 4;
  tabPrintDrawdown.TabVisible       := comboDrawdownPrintFreq.ItemIndex = 4;
  tabPrintBudget.TabVisible         := comboBudPrintFreq.ItemIndex = 4;
  tabSaveHead.TabVisible            := comboHeadExportFreq.ItemIndex = 4;
  tabSaveDrawdown.TabVisible        := comboDrawdownExportFreq.ItemIndex = 4;
  tabSaveCellByCellFlows.TabVisible := comboBudExportFreq.ItemIndex = 4;

  tabOutputControl.TabVisible :=
    tabPrintHead.TabVisible or
    tabPrintDrawdown.TabVisible or
    tabPrintBudget.TabVisible or
    tabSaveHead.TabVisible or
    tabSaveDrawdown.TabVisible or
    tabSaveCellByCellFlows.TabVisible;
end;

procedure TfrmMODFLOW.cb_GWMClick(Sender: TObject);
begin
  inherited;
  GWM_Warning;
  tab_GWM.TabVisible := cb_GWM.Checked;
  ActivateParametersTab;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFFluxVariableLayerType, cb_GWM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFHeadConstraintLayerType, cb_GWM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFDrawdownConstraintLayerType, cb_GWM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFHeadDifferenceLayerType, cb_GWM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFGradientLayerType, cb_GWM.Checked);

  AddOrRemoveGWM_STRLayers;

  AddOrRemoveGWM_SLP_Parameters;

  cbGwmHeadVariablesClick(Sender);
  cbGwmStreamVariablesClick(Sender);
  rdeGwmStorageStateVarCountExit(Sender);
  EnableGwmStreamVariables;

  AssociateTimes;
end;

procedure TfrmMODFLOW.AddOrRemoveGWM_STRLayers;
begin
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFStreamConstraintLayerType,
    cb_GWM.Checked and (cbSTR.Checked or cbSFR.Checked));

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFStreamDepletionConstraintLayerType,
    cb_GWM.Checked and (cbSTR.Checked or cbSFR.Checked));

  cbGwmStreamVariablesClick(nil);

end;

procedure TfrmMODFLOW.AddGWM_BinaryGrid;
var
  GridIndex: integer;
  Grid: TDataGrid;
begin
  dg3dGWM_BinaryDecVar.GridCount := StrToInt(
    frameGWM_Binary.adeDecisionVariableCount.Text);

  for GridIndex := 0 to dg3dGWM_BinaryDecVar.GridCount -1 do
  begin
    dg3dGWM_BinaryDecVar.Pages[GridIndex].Caption :=
      frameGWM_Binary.dgVariables.Cells[0,GridIndex+1];
    Grid := dg3dGWM_BinaryDecVar.Grids[GridIndex];
    if Grid.Cells[0,0] = '' then
    begin
      Grid.Cells[0,0] := 'Name';
    end;
    Grid.Columns[0].LimitToList := True;
  end;
end;

procedure TfrmMODFLOW.frameGWM_BinaryadeDecisionVariableCountExit(
  Sender: TObject);
begin
  inherited;
  frameGWM_Binary.adeDecisionVariableCountExit(Sender);

  AddGWM_BinaryGrid;
  Update_frameGWM_Binary_dgVariables;
  UpdateBinaryVariables;
  Update_dg3dGWM_BinaryDecVar;
end;

procedure TfrmMODFLOW.frameGWM_BinarybtnAddClick(Sender: TObject);
begin
  inherited;
  frameGWM_Binary.btnAddClick(Sender);

  AddGWM_BinaryGrid;
  Update_frameGWM_Binary_dgVariables;
  Update_dg3dGWM_BinaryDecVar;
end;

procedure TfrmMODFLOW.frameGWM_BinarybtnDeleteClick(Sender: TObject);
var
  GridToDelete: integer;
begin
  inherited;
  GridToDelete := frameGWM_Binary.dgVariables.SelectedRow -1;
  frameGWM_Binary.btnDeleteClick(Sender);

  if GridToDelete >= 0 then
  begin
    dg3dGWM_BinaryDecVar.RemoveGrid(GridToDelete);
  end;
  UpdateBinaryVariables;
  Update_dg3dGWM_BinaryDecVar;
end;

procedure TfrmMODFLOW.frameGWM_BinarybtnInsertClick(Sender: TObject);
var
  GridToInsert: integer;
  Grid: TDataGrid;
begin
  inherited;
  GridToInsert := frameGWM_Binary.dgVariables.SelectedRow -1;
  frameGWM_Binary.btnInsertClick(Sender);

  if GridToInsert >= 0 then
  begin
    dg3dGWM_BinaryDecVar.InsertGrid(GridToInsert);

    dg3dGWM_BinaryDecVar.Pages[GridToInsert].Caption :=
      frameGWM_Binary.dgVariables.Cells[0,GridToInsert+1];
    Grid := dg3dGWM_BinaryDecVar.Grids[GridToInsert];
    if Grid.Cells[0,0] = '' then
    begin
      Grid.Cells[0,0] := 'Name';
    end;
  end;
  Update_frameGWM_Binary_dgVariables;
  UpdateBinaryVariables;
  Update_dg3dGWM_BinaryDecVar;
end;

procedure TfrmMODFLOW.frameGWM_BinarydgVariablesSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: String);
begin
  inherited;
  if (ACol = Ord(gbcName)) and (ARow >= 1) and frameGWM_Binary.dgVariables.enabled then
  begin
    dg3dGWM_BinaryDecVar.Pages[ARow -1].Caption :=
      frameGWM_Binary.dgVariables.Cells[0,ARow];
  end;
  if (ACol = Ord(gbcCount)) and (ARow >= 1) and frameGWM_Binary.dgVariables.enabled then
  begin
    if frameGWM_Binary.dgVariables.Cells[Ord(gbcCount),ARow] <> '' then
    begin
      try
        dg3dGWM_BinaryDecVar.Grids[ARow -1].RowCount :=
          StrToInt(frameGWM_Binary.dgVariables.Cells[Ord(gbcCount),ARow]) + 1;
      except on EConvertError do
        begin
          Beep;
        end
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.frameGWM_BinarydgVariablesSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if not frameGWM_Binary.dgVariables.Drawing then
  begin
    dg3dGWM_BinaryDecVar.ActivePageIndex := ARow -1;
  end;
end;

procedure TfrmMODFLOW.AddGWM_CombinedGrid;
var
  GridIndex: integer;
  Grid: TDataGrid;
begin
  dg3dCombinedConstraints.GridCount := StrToInt(
    frameGWM_CombinedConstraints.adeDecisionVariableCount.Text);

  for GridIndex := 0 to dg3dCombinedConstraints.GridCount -1 do
  begin

    dg3dCombinedConstraints.Pages[GridIndex].Caption :=
      frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscName),GridIndex+1];
    Grid := dg3dCombinedConstraints.Grids[GridIndex];
    Grid.Columns[0].LimitToList := True;
    if Grid.Cells[0,0] = '' then
    begin
      Grid.Cells[0,0] := 'Name';
      Grid.Cells[1,0] := 'Coefficient';
    end;
  end;
  UpdateBinaryVariables

end;

procedure TfrmMODFLOW.frameGWM_CombinedConstraintsadeDecisionVariableCountExit(
  Sender: TObject);
begin
  inherited;
  frameGWM_CombinedConstraints.adeDecisionVariableCountExit(Sender);

  AddGWM_CombinedGrid;
end;

procedure TfrmMODFLOW.frameGWM_CombinedConstraintsbtnAddClick(
  Sender: TObject);
begin
  inherited;
  frameGWM_CombinedConstraints.btnAddClick(Sender);

  AddGWM_CombinedGrid;
end;

procedure TfrmMODFLOW.frameGWM_CombinedConstraintsbtnInsertClick(
  Sender: TObject);
var
  GridToInsert: integer;
  Grid: TDataGrid;
begin
  inherited;
  GridToInsert := frameGWM_CombinedConstraints.dgVariables.SelectedRow -1;
  frameGWM_CombinedConstraints.btnInsertClick(Sender);

  if GridToInsert >= 0 then
  begin
    dg3dCombinedConstraints.InsertGrid(GridToInsert);

    dg3dCombinedConstraints.Pages[GridToInsert].Caption :=
      frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscName),GridToInsert+1];
    Grid := dg3dCombinedConstraints.Grids[GridToInsert];
    if Grid.Cells[0,0] = '' then
    begin
      Grid.Cells[0,0] := 'Name';
      Grid.Cells[1,0] := 'Coefficient';
    end;
  end;
end;

procedure TfrmMODFLOW.frameGWM_CombinedConstraintsbtnDeleteClick(
  Sender: TObject);
var
  GridToDelete: integer;
begin
  inherited;
  GridToDelete := frameGWM_CombinedConstraints.dgVariables.SelectedRow -1;
  frameGWM_CombinedConstraints.btnDeleteClick(Sender);

  if GridToDelete >= 0 then
  begin
    dg3dCombinedConstraints.RemoveGrid(GridToDelete);
  end;
end;

procedure TfrmMODFLOW.frameGWM_CombinedConstraintsdgVariablesSelectCell(
  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if not frameGWM_CombinedConstraints.dgVariables.Drawing then
  begin
    dg3dCombinedConstraints.ActivePageIndex := ARow -1;
  end;

end;

procedure TfrmMODFLOW.frameGWM_CombinedConstraintsdgVariablesSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: String);
var
  Grid: TDataGrid;
  RowIndex: integer;
begin
  inherited;
  if (ACol = 0) and (ARow >= 1)
    and frameGWM_CombinedConstraints.dgVariables.Enabled then
  begin
    dg3dCombinedConstraints.Pages[ARow -1].Caption :=
      frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscName),ARow];
  end;
  if (ACol = 1) and (ARow >= 1)
    and frameGWM_CombinedConstraints.dgVariables.Enabled then
  begin
    if frameGWM_CombinedConstraints.dgVariables.Cells[Ord(gscCount),ARow] <> '' then
    begin
      try
        Grid := dg3dCombinedConstraints.Grids[ARow -1];
        Grid.RowCount := StrToInt(frameGWM_CombinedConstraints.
          dgVariables.Cells[Ord(gscCount),ARow]) + 1;
        for RowIndex := 1 to Grid.RowCount -1 do
        begin
          if (Grid.Cells[0,RowIndex] = '') and
            (Grid.Columns[0].PickList.Count > 0) then
          begin
            Grid.Cells[0,RowIndex] := Grid.Columns[0].PickList[0]
          end;
          if (Grid.Cells[1,RowIndex] = '') then
          begin
            Grid.Cells[1,RowIndex] := '1';
          end;
        end;
      except on EConvertError do
        begin
          Beep;
        end
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.rgGWM_SolutionTypeClick(Sender: TObject);
begin
  inherited;
  if rgGWM_SolutionType.ItemIndex = 3 then
  begin
    tabGWM_SLP.TabVisible := True;
  end
  else
  begin
    if pcGWM_Solution.ActivePage = tabGWM_SLP then
    begin
      pcGWM_Solution.ActivePageIndex := 0;
    end;
    tabGWM_SLP.TabVisible := False;
  end;
  rgGWM_ResponseMatrix.Enabled := rgGWM_SolutionType.ItemIndex = 2;
  rgGWM_ResponseMatrixClick(nil);
  cbGWM_PrintResponseMatrix.Enabled := rgGWM_SolutionType.ItemIndex = 2;
  cbGWM_PrintResponseMatrixClick(nil);

  adeGWM_LPITMAX.Enabled := rgGWM_SolutionType.ItemIndex in [2,3];
  adeGWM_BBITMAX.Enabled := rgGWM_SolutionType.ItemIndex in [2,3];
  cbGWM_BBITPRT.Enabled := rgGWM_SolutionType.ItemIndex in [2,3];
  cbGWM_Range.Enabled := rgGWM_SolutionType.ItemIndex in [2,3];

  AddOrRemoveGWM_SLP_Parameters;
end;

procedure TfrmMODFLOW.AddOrRemoveGWM_SLP_Parameters;
begin
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFFluxVariableLayerType,
    ModflowTypes.GetMFFluxBaseParamType,
    cb_GWM.Checked and (rgGWM_SolutionType.ItemIndex = 3));
end;

procedure TfrmMODFLOW.rgGWM_ResponseMatrixClick(Sender: TObject);
begin
  inherited;
  framFilePathGWM_ResponseMatrix.Enabled := rgGWM_ResponseMatrix.Enabled and
    (rgGWM_ResponseMatrix.ItemIndex in [0,1]);
  if not Loading and not Cancelling and
    (framFilePathGWM_ResponseMatrix.edFilePath.Text = 'File Path') then
  begin
    framFilePathGWM_ResponseMatrix.btnBrowse.OnClick(nil);
  end;
end;

procedure TfrmMODFLOW.frameGWM_ExternalbtnAddClick(Sender: TObject);
begin
  inherited;
  frameGWM_External.btnAddClick(Sender);
  Update_frameGWM_External_dgVariables;

  with frameGWM_External.dgVariables do
  begin
    Cells[0,RowCount -1] := 'Ext' + IntToStr(RowCount -1);
  end;
  UpdateExternalVariables;
end;

procedure TfrmMODFLOW.Update_frameGWM_External_dgVariables;
Var
  RowIndex: integer;
  ColIndex: integer;
  GridRect: TGridRect;
begin
  with frameGWM_External.dgVariables do
  begin
    GridRect := Selection;
    if (GridRect.Left = 1) and (GridRect.Top = 1) then
    begin
      GridRect.Left := 0;
      GridRect.Right := 0;
      Selection := GridRect;
    end;

    for RowIndex := 1 to RowCount -1 do
    begin
      if Cells[0,RowIndex] = '' then
      begin
        Cells[0,RowIndex] := 'Ext' + IntToStr(RowIndex);
        for ColIndex := 4 to ColCount -1 do
        begin
          Checked[ColIndex,RowIndex] := True;
        end;
      end;
      if Cells[1,RowIndex] = '' then
      begin
        Cells[1,RowIndex] := Columns[1].PickList[0];
      end;
      if Cells[2,RowIndex] = '' then
      begin
        Cells[2,RowIndex] := '0';
      end;
      if Cells[3,RowIndex] = '' then
      begin
        Cells[3,RowIndex] := '0';
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.frameGWM_ExternaladeDecisionVariableCountExit(
  Sender: TObject);
begin
  inherited;
  frameGWM_External.adeDecisionVariableCountExit(Sender);
  Update_frameGWM_External_dgVariables;
end;

procedure TfrmMODFLOW.frameGWM_ExternalbtnInsertClick(Sender: TObject);
begin
  inherited;
  frameGWM_External.btnInsertClick(Sender);

  Update_frameGWM_External_dgVariables;
  with frameGWM_External.dgVariables do
  begin
    Cells[0,SelectedRow] := 'Ext' + IntToStr(RowCount -1);
  end;
  UpdateExternalVariables;
end;

procedure TfrmMODFLOW.Update_frameGWM_Binary_dgVariables;
Var
  RowIndex: integer;
  AString: string;
begin
  with frameGWM_Binary.dgVariables do
  begin
    for RowIndex := 1 to RowCount -1 do
    begin
      if Cells[0,RowIndex] = '' then
      begin
        Cells[0,RowIndex] := 'Bin' + IntToStr(RowIndex);
      end;
      if Cells[1,RowIndex] = '' then
      begin
        AString := '1';
        Cells[1,RowIndex] := AString;
        frameGWM_BinarydgVariablesSetEditText(frameGWM_Binary.dgVariables,
          1, RowIndex, AString);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.btnImportFlowVar1Click(Sender: TObject);
var
  Contour: TContourObjectOptions;
  AName: string;
  VariableNameIndex: ANE_INT16;
  LayerHandle : ANE_PTR;
  ContourIndex: integer;
  LayerName: string;
  UnitIndex: integer;
  ProjectOptions: TProjectOptions;
  FluxLayer : TLayerOptions;
  ContourCount: integer;
  FlowVariableNames: TStringList;
  StateVariableNames: TStringList;
  ParamName: string;
  StateLayer: TLayerOptions;
  ParamIndices: TIntegerList;
  NameRoot: string;
  TimeCount: Integer;
  TimeIndex: Integer;
  RowIndex: Integer;
begin
  inherited;
  if NewModel then
  begin
    Beep;
    MessageDlg('Sorry, you can''t import flow variables until '
      + 'you click the OK button.', mtError, [mbOK], 0);
  end
  else
  begin
    StateVariableNames := TStringList.Create;
    FlowVariableNames := TStringList.Create;
    ProjectOptions := TProjectOptions.Create;
    try
      FlowVariableNames.Sorted := True;
      StateVariableNames.Sorted := True;
      for UnitIndex := 1 to dgGeol.RowCount -1 do
      begin
        if Simulated(UnitIndex) then
        begin
          LayerName := ModflowTypes.GetMFFluxVariableLayerType.WriteNewRoot +
            IntToStr(UnitIndex);
          LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
          FluxLayer   := TLayerOptions.Create(LayerHandle);
          try
            ParamName := ModflowTypes.GetMFFluxVariableNameParamType.ANE_ParamName;
            VariableNameIndex := FluxLayer.GetParameterIndex(
              CurrentModelHandle, ParamName);
            Assert(VariableNameIndex >= 0);
            ContourCount := FluxLayer.NumObjects(CurrentModelHandle, pieContourObject);
            for ContourIndex := 0 to ContourCount -1 do
            begin
              Contour   := TContourObjectOptions.Create
                (CurrentModelHandle, LayerHandle, ContourIndex);
              try
                AName := Contour.GetStringParameter(CurrentModelHandle,
                  VariableNameIndex);
                FlowVariableNames.Add(AName);
              finally
                Contour.Free;
              end;
            end;
          finally
            FluxLayer.Free(CurrentModelHandle);
          end;

          if cbGwmHeadVariables.Checked then
          begin
            LayerName := ModflowTypes.GetMFGwmHeadStateLayerType.WriteNewRoot +
              IntToStr(UnitIndex);
            StateLayer   := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
            try
              ParamIndices := TIntegerList.Create;
              try
                NameRoot := ModflowTypes.GetMF_GwmNameParamType.ANE_ParamName;
                TimeCount := StrToInt(frmModflow.rdeGwmStateTimeCount.Output);
                for TimeIndex := 1 to TimeCount do
                begin
                  AName := NameRoot + IntToStr(TimeIndex);
                  ParamIndices.Add( StateLayer.GetParameterIndex(
                    CurrentModelHandle, AName));
                end;
                ContourCount := StateLayer.NumObjects(CurrentModelHandle, pieContourObject);
                for ContourIndex := 0 to ContourCount -1 do
                begin
                  Contour   := TContourObjectOptions.Create
                    (CurrentModelHandle, StateLayer.LayerHandle, ContourIndex);
                  try
                    for TimeIndex := 0 to ParamIndices.Count - 1 do
                    begin
                      AName := Contour.GetStringParameter(CurrentModelHandle,
                        ParamIndices[TimeIndex]);
                      StateVariableNames.Add(AName);
                    end;
                  finally
                    Contour.Free;
                  end;
                end;

              finally
                ParamIndices.Free;
              end;
            finally
              StateLayer.Free(CurrentModelHandle);
            end;
          end;
          if cbGwmStreamVariables.Checked then
          begin
            LayerName := ModflowTypes.GetMFGwmStreamStateLayerType.WriteNewRoot +
              IntToStr(UnitIndex);
            StateLayer   := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
            try
              ParamIndices := TIntegerList.Create;
              try
                NameRoot := ModflowTypes.GetMF_GwmNameParamType.ANE_ParamName;
                TimeCount := StrToInt(frmModflow.rdeGwmStateTimeCount.Output);
                for TimeIndex := 1 to TimeCount do
                begin
                  AName := NameRoot + IntToStr(TimeIndex);
                  ParamIndices.Add( StateLayer.GetParameterIndex(
                    CurrentModelHandle, AName));
                end;
                ContourCount := StateLayer.NumObjects(CurrentModelHandle, pieContourObject);
                for ContourIndex := 0 to ContourCount -1 do
                begin
                  Contour   := TContourObjectOptions.Create
                    (CurrentModelHandle, StateLayer.LayerHandle, ContourIndex);
                  try
                    for TimeIndex := 0 to ParamIndices.Count - 1 do
                    begin
                      AName := Contour.GetStringParameter(CurrentModelHandle,
                        ParamIndices[TimeIndex]);
                      StateVariableNames.Add(AName);
                    end;
                  finally
                    Contour.Free;
                  end;
                end;

              finally
                ParamIndices.Free;
              end;
            finally
              StateLayer.Free(CurrentModelHandle);
            end;
          end;
          if IsAnyTransient and (StrToInt(rdeGwmStorageStateVarCount.Output) > 0) then
          begin
            for RowIndex := 1 to rdgGwmStorageVariables.RowCount - 1 do
            begin
              StateVariableNames.Add(rdgGwmStorageVariables.Cells[Ord(gwscName), RowIndex])

            end;
          end;

        end;
      end;
      frameGWM_FlowObjective.dgVariables.Columns[0].PickList := FlowVariableNames;
      frameGWM_StateObjective.dgVariables.Columns[0].PickList := StateVariableNames;

    finally
      ProjectOptions.Free;
      FlowVariableNames.Free;
      StateVariableNames.Free;
    end;
    Update_dg3dGWM_BinaryDecVar;
    UpdateCombinedConstraintNames;
  end;
end;

procedure TfrmMODFLOW.Update_dg3dGWM_BinaryDecVar;
var
  Names: TStringList;
  LineIndex: integer;
  GridIndex: integer;
  Grid: TDataGrid;
begin
  Names := TStringList.Create;
  try
    Names.AddStrings(frameGWM_FlowObjective.dgVariables.Columns[0].PickList);

    for LineIndex := 1 to StrToInt(frameGWM_External.adeDecisionVariableCount.Text) do
    begin
      Names.Add(frameGWM_External.dgVariables.Cells[0,LineIndex]);
    end;
    for GridIndex := 0 to dg3dGWM_BinaryDecVar.PageCount -1 do
    begin
      Grid := dg3dGWM_BinaryDecVar.Grids[GridIndex];
      Grid.Columns[0].PickList := Names;
      Grid.Columns[0].LimitToList := True;
    end;
  finally
    Names.Free;
  end;
end;

procedure TfrmMODFLOW.UpdateExternalVariables;
var
  Names: TStringList;
  Index: integer;
begin
  Names := TStringList.Create;
  try
    with frameGWM_External do
    begin
      for Index := 1 to StrToInt(adeDecisionVariableCount.Text) do
      begin
        if Names.IndexOf(dgVariables.Cells[0,Index]) < 0 then
        begin
          Names.Add(dgVariables.Cells[0,Index]);
        end;
      end;
    end;
    frameGWM_ExternalObjective.dgVariables.Columns[0].PickList := Names;
  finally
    Names.Free;
  end;
  UpdateCombinedConstraintNames;
  Update_dg3dGWM_BinaryDecVar;
end;

procedure TfrmMODFLOW.frameGWM_ExternaldgVariablesExit(Sender: TObject);
begin
  inherited;
  UpdateExternalVariables;
end;

procedure TfrmMODFLOW.frameGWM_ExternalbtnDeleteClick(Sender: TObject);
begin
  inherited;
  frameGWM_External.btnDeleteClick(Sender);
  UpdateExternalVariables;
end;

procedure TfrmMODFLOW.UpdateBinaryVariables;
var
  Names: TStringList;
  Index: integer;
begin
  Names := TStringList.Create;
  try
    with frameGWM_Binary do
    begin
      for Index := 1 to StrToInt(adeDecisionVariableCount.Text) do
      begin
        if Names.IndexOf(dgVariables.Cells[0,Index]) < 0 then
        begin
          Names.Add(dgVariables.Cells[0,Index]);
        end;
      end;
    end;
    frameGWM_BinaryObjective.dgVariables.Columns[0].PickList := Names;
  finally
    Names.Free;
  end;
  UpdateCombinedConstraintNames;

end;



procedure TfrmMODFLOW.frameGWM_BinarydgVariablesExit(Sender: TObject);
begin
  inherited;
  UpdateBinaryVariables;
end;

procedure TfrmMODFLOW.UpdateCombinedConstraintNames;
var
  Names: TStringList;
  Index: integer;
  Grid: TDataGrid;
begin
  Names := TStringList.Create;
  try
    Names.AddStrings(frameGWM_FlowObjective.dgVariables.Columns[0].PickList);
    Names.AddStrings(frameGWM_ExternalObjective.dgVariables.Columns[0].PickList);
    Names.AddStrings(frameGWM_BinaryObjective.dgVariables.Columns[0].PickList);
    Names.AddStrings(frameGWM_StateObjective.dgVariables.Columns[0].PickList);

    for Index := 0 to dg3dCombinedConstraints.PageCount -1 do
    begin
      Grid := dg3dCombinedConstraints.Grids[Index];
      Grid.Columns[0].PickList := Names;
    end;
  finally
    Names.Free;
  end;
end;

procedure TfrmMODFLOW.UpdateObjectiveGrid(const Frame : TframeGWM);
var
  Index: integer;
  NewName: string;
begin
  if Frame.dgVariables.Columns[0].PickList.Count > 0 then
  begin
    NewName := Frame.dgVariables.Columns[0].PickList[0];
  end
  else
  begin
    NewName := 'Variable'
  end;
  with Frame.dgVariables do
  begin
    for Index := 1 to RowCount -1 do
    begin
      if Cells[0,Index] = '' then
      begin
        Cells[0,Index] := NewName;
      end;
      if Cells[1,Index] = '' then
      begin
        Cells[1,Index] := '1';
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.frameGWM_FlowObjectivebtnAddClick(Sender: TObject);
begin
  inherited;
  frameGWM_FlowObjective.btnAddClick(Sender);
  UpdateObjectiveGrid(frameGWM_FlowObjective);
end;

procedure TfrmMODFLOW.frameGWM_FlowObjectivebtnInsertClick(
  Sender: TObject);
begin
  inherited;
  frameGWM_FlowObjective.btnInsertClick(Sender);
  UpdateObjectiveGrid(frameGWM_FlowObjective);
end;

procedure TfrmMODFLOW.frameGWM_FlowObjectiveadeDecisionVariableCountExit(
  Sender: TObject);
begin
  inherited;
  frameGWM_FlowObjective.adeDecisionVariableCountExit(Sender);
  UpdateObjectiveGrid(frameGWM_FlowObjective);
end;

procedure TfrmMODFLOW.frameGWM_ExternalObjectivebtnAddClick(
  Sender: TObject);
begin
  inherited;
  frameGWM_ExternalObjective.btnAddClick(Sender);
  UpdateObjectiveGrid(frameGWM_ExternalObjective);
end;

procedure TfrmMODFLOW.frameGWM_ExternalObjectivebtnInsertClick(
  Sender: TObject);
begin
  inherited;
  frameGWM_ExternalObjective.btnInsertClick(Sender);
  UpdateObjectiveGrid(frameGWM_ExternalObjective);
end;

procedure TfrmMODFLOW.frameGWM_ExternalObjectiveadeDecisionVariableCountExit(
  Sender: TObject);
begin
  inherited;
  frameGWM_ExternalObjective.adeDecisionVariableCountExit(Sender);
  UpdateObjectiveGrid(frameGWM_ExternalObjective);
end;

procedure TfrmMODFLOW.frameGWM_BinaryObjectivebtnAddClick(Sender: TObject);
begin
  inherited;
  frameGWM_BinaryObjective.btnAddClick(Sender);
  UpdateObjectiveGrid(frameGWM_BinaryObjective);
end;

procedure TfrmMODFLOW.frameGWM_BinaryObjectivebtnInsertClick(
  Sender: TObject);
begin
  inherited;
  frameGWM_BinaryObjective.btnInsertClick(Sender);
  UpdateObjectiveGrid(frameGWM_BinaryObjective);
end;

procedure TfrmMODFLOW.frameGWM_BinaryObjectiveadeDecisionVariableCountExit(
  Sender: TObject);
begin
  inherited;
  frameGWM_BinaryObjective.adeDecisionVariableCountExit(Sender);
  UpdateObjectiveGrid(frameGWM_BinaryObjective);
end;

procedure TfrmMODFLOW.pcGWMChange(Sender: TObject);
begin
  inherited;
  FreePageControlResources(pcGWM, Handle);
  pcGWM.HelpContext := pcGWM.ActivePage.HelpContext;
  BitBtnHelp.HelpContext := pcGWM.HelpContext;
  tab_GWM.HelpContext := pcGWM.HelpContext;
end;

procedure TfrmMODFLOW.comboMnwObservationsChange(Sender: TObject);
begin
  inherited;
  AddOrRemoveMnwObservations;
end;

procedure TfrmMODFLOW.AddOrRemoveUnsatStreamParams;
var
  IsfroptValue: integer;
  LayerTypes: array[0..1] of TMF2KCustomUnsatStreamLayerClass;
  LayerShouldBePresent: array[0..1] of boolean;
  Index: integer;
  LayerType: TMF2KCustomUnsatStreamLayerClass;
  ShouldBePresent: boolean;
  AppropriateISFROPT: boolean;
begin
  IsfroptValue := ISFROPT;

  ShouldBePresent := cbSFR.Checked;
  if (IsfroptValue in [0,4,5]) and ShouldBePresent then
  begin
    // upstream top elevation should be read in each stress period if
    // 1. ISFROPT is not read (= 0), or
    // 2. ISFROPT = 4 or 5 and ICALC <= 0 (simple stream layer), or
    // 3. ISFROPT = 4 or 5 and ICALC >= 3 (table or formula stream layer)

    // upstream top elevation should be read in just the first stress period if
    // 1. ISFROPT = 4 or 5 and ICALC = 1 or 2 simple stream, 8-point channel stream

{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType); }
  end
  else if ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2KSimpleStreamLayerType);}
  end;

  ShouldBePresent := cbSFR.Checked and cbSFRCalcFlow.Checked;
  if (IsfroptValue = 0) and ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType); }
  end
  else if ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2K8PointChannelStreamLayerType); }
  end;

  if (IsfroptValue in [0,4,5]) and ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType); }
  end
  else if (IsfroptValue in [1,2,3]) and ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2KFormulaStreamLayerType); }
  end;

  if (IsfroptValue in [0,4,5]) and ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2KTableStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2KTableStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2KTableStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveParamToIndParam2
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2KTableStreamLayerType); }
  end
  else if (IsfroptValue in [1,2,3]) and ShouldBePresent then
  begin
{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KStreamUpTopElevParamType,
      ModflowTypes.GetMF2KTableStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      ModflowTypes.GetMF2KTableStreamLayerType);

{    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      ModflowTypes.GetMF2KTableStreamLayerType);

    MFLayerStructure.ListsOfIndexedLayers.MoveIndParam2ToParam
      (ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      ModflowTypes.GetMF2KTableStreamLayerType); }
  end;

  LayerTypes[0] := ModflowTypes.GetMF2KSimpleStreamLayerType;
  LayerTypes[1] := ModflowTypes.GetMF2K8PointChannelStreamLayerType;
  LayerShouldBePresent[0] := cbSFR.Checked;
  LayerShouldBePresent[1] := cbSFR.Checked and cbSFRCalcFlow.Checked;

  for Index := 0 to Length(LayerTypes) -1 do
  begin
    LayerType := LayerTypes[Index];
    ShouldBePresent := LayerShouldBePresent[Index];

{    if Index = 1 then
    begin
      AppropriateISFROPT := False;
    end
    else
    begin      }
      AppropriateISFROPT := (IsfroptValue in [0,4,5]);
//    end;


    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFUnsatGageParamType,
      (IsfroptValue in [2,3,4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFUnsatProfileGageParamType,
      (IsfroptValue in [2,3,4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2StreambedTopElevParamType,
      (IsfroptValue in [1,2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFStreamSlopeParamType,
      (IsfroptValue in [1,2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2StreambedThicknessParamType,
      (IsfroptValue in [1,2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFStreamHydCondParamType,
      (IsfroptValue in [1,2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2SaturatedWaterContentParamType,
      (IsfroptValue in [2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2InitialWaterContentParamType,
      (IsfroptValue in [2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2BrooksCoreyExponentParamType,
      (IsfroptValue in [2,3]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2UnsatZoneHydraulicConductivityParamType,
      (IsfroptValue = 3) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMF2KUpstreamKParamType,
      (IsfroptValue in [0,4,5]) and ShouldBePresent);
//      (IsfroptValue in [0,4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMF2KDownstreamKParamType,
      (IsfroptValue in [0,4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (LayerType,
      ModflowTypes.GetMF2KStreamUpTopElevParamType,
      AppropriateISFROPT and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (LayerType,
      ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      AppropriateISFROPT and ShouldBePresent);
//      (IsfroptValue in [0,4,5]) and ShouldBePresent);

{    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMF2KStreamUpTopElevParamType,
      (not AppropriateISFROPT) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMF2KDownstreamTopElevationParamType,
      (not AppropriateISFROPT) and ShouldBePresent);  }

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (LayerType,
      ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      (AppropriateISFROPT) and ShouldBePresent);
//      (IsfroptValue in [0,4,5]) and ShouldBePresent);

{    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
      (not AppropriateISFROPT) and ShouldBePresent); }

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (LayerType,
      ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      (AppropriateISFROPT) and ShouldBePresent);
//      (IsfroptValue in [0,4,5]) and ShouldBePresent);

{    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
      (not AppropriateISFROPT) and ShouldBePresent); }

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2UpstreamSaturatedWaterContentParamType,
      (IsfroptValue in [4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2DownstreamSaturatedWaterContentParamType,
      (IsfroptValue in [4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2UpstreamInitialWaterContentParamType,
      (IsfroptValue in [4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2DownstreamInitialWaterContentParamType,
      (IsfroptValue in [4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2UpstreamBrooksCoreyExponentParamType,
      (IsfroptValue in [4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2DownstreamBrooksCoreyExponentParamType,
      (IsfroptValue in [4,5]) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2UpstreamUnsatZoneHydraulicConductivityParamType,
      (IsfroptValue = 5) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (LayerType,
      ModflowTypes.GetMFSfr2DownstreamUnsatZoneHydraulicConductivityParamType,
      (IsfroptValue = 5) and ShouldBePresent);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
      (LayerType,
      ModflowTypes.GetMFOnOffParamType,
      (IsfroptValue in [0,4,5]) and ShouldBePresent);
  end;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFOnOffParamType,
    (IsfroptValue in [0,4,5]) and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFOnOffParamType,
    (IsfroptValue in [0,4,5]) and ShouldBePresent);


  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFSfr2StreambedTopElevParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFSfr2StreambedTopElevParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);



  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFStreamSlopeParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFStreamSlopeParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);



  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFSfr2StreambedThicknessParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFSfr2StreambedThicknessParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);




  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMFStreamHydCondParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMFStreamHydCondParamType,
    (IsfroptValue in [1,2,3]) and ShouldBePresent);


  AppropriateISFROPT := (IsfroptValue in [0,4,5]);
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KStreamUpTopElevParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KStreamUpTopElevParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KDownstreamTopElevationParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KDownstreamTopElevationParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KUpstreamBedThicknessParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KFormulaStreamLayerType,
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
    AppropriateISFROPT and ShouldBePresent);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMF2KTableStreamLayerType,
    ModflowTypes.GetMF2KDownstreamBedThicknessParamType,
    AppropriateISFROPT and ShouldBePresent);

end;

procedure TfrmMODFLOW.OnSfr2IsfroptChange;
begin
  cbSfrLpfHydraulicCond.Enabled := (rgFlowPackage.ItemIndex = 1)
    and cbSFR.Checked and cbSfrUnsatflow.Checked;

  adeSFRParamCount.Enabled := (ISFROPT = 0);
  if not Loading and not Cancelling then
  begin
    if not adeSFRParamCount.Enabled
      and (StrToInt(adeSFRParamCount.Text) <> 0) then
    begin
      adeSFRParamCount.Text := '0';
      adeSFRParamCountExit(adeSFRParamCount);
      Beep;
      MessageDlg('Stream Parameters are not allowed when this option '
        + 'is selected. The number of stream parameters has been set to zero.',
        mtInformation, [mbOK], 0);
    end;
  end;

  adeStreamTableEntriesCount.Enabled := cbSFR.Checked
    and not rbModflow96.Checked and cbSFRCalcFlow.Checked;

  AddOrRemoveUnsatStreamParams;

end;

procedure TfrmMODFLOW.UnsatflowWarning;
begin
  if not Loading and not Cancelling then
  begin
    if cbSFR.Checked and cbSFRRetain.Checked and cbSfrUnsatflow.Checked
      and not (rgFlowPackage.ItemIndex in [0,1]) then
    begin
      Beep;
      MessageDlg('Unsaturated flow in the SFR package is incompatible '
        +'with the HUF package.  You should fix this before trying '
        + 'to run MODFLOW.', mtError, [mbOK], 0);
    end;

  end;
end;

procedure TfrmMODFLOW.cbSfrUnsatflowClick(Sender: TObject);
begin
  inherited;
  EnableSfrUnsatFlowControls;
  UnsatflowWarning;
  OnSfr2IsfroptChange;
end;

function TfrmMODFLOW.ISFROPT: integer;
begin
  // Calculate the ISFROPT parameter for the SFR2 input.

  if cbSfrUnsatflow.Checked then
  begin
    if rbSfr2ByEndpoints.Checked then
    begin
      if cbSfrLpfHydraulicCond.Checked then
      begin
        result := 4
      end
      else
      begin
        result := 5
      end;
    end
    else
    begin
      if cbSfrLpfHydraulicCond.Checked then
      begin
        result := 2
      end
      else
      begin
        result := 3
      end;
    end;
  end
  else
  begin
    if rbSfr2ByEndpoints.Checked then
    begin
      result := 0
    end
    else
    begin
      result := 1
    end;
  end;
end;

procedure TfrmMODFLOW.cbSfrLpfHydraulicCondClick(Sender: TObject);
begin
  inherited;
  OnSfr2IsfroptChange;
end;

procedure TfrmMODFLOW.cbSfrTimeVaryingPropertiesClick(Sender: TObject);
begin
  inherited;
  OnSfr2IsfroptChange;
end;

procedure TfrmMODFLOW.rbSfr2ByEndpointsClick(Sender: TObject);
begin
  inherited;
  OnSfr2IsfroptChange;
end;

procedure TfrmMODFLOW.rdeZoneCountExit(Sender: TObject);
var
  ColIndex: Integer;
  ZoneIndex: Integer;
  Column: TRbwColumn4;
begin
  inherited;
  rdgGwmStorageVariables.ColCount := Ord(gscZoneNumber)
    + StrToInt(rdeZoneCount.Output);
  ZoneIndex := 1;
  for ColIndex := Ord(gscZoneNumber) to rdgGwmStorageVariables.ColCount - 1 do
  begin
    Column := rdgGwmStorageVariables.Columns[ColIndex];
    Column.Format := rcf4Integer;
    Column.WordWrapCaptions := True;
    Column.AutoAdjustRowHeights := True;
    rdgGwmStorageVariables.Cells[ColIndex, 0] :=
      'Zone Number ' + IntToStr(ZoneIndex);
    Inc(ZoneIndex);
  end;
end;

procedure TfrmMODFLOW.cbParticleObservationsClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMoc3dParticleObsLayerType,
    cbMOC3D.Checked and cbParticleObservations.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
    ModflowTypes.GetMFGridMocParticleObservationParamType,
    cbMOC3D.Checked and cbParticleObservations.Checked);

  AddOrRemoveMnwObservations;
end;

procedure TfrmMODFLOW.cbMpathElevationsClick(Sender: TObject);
begin
  inherited;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMODPATHLayerType,
    ModflowTypes.GetMFUpperMpathElevationParamType,
    cbMODPATH.Checked and cbMpathElevations.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMODPATHLayerType,
    ModflowTypes.GetMFLowerMpathElevationParamType,
    cbMODPATH.Checked and cbMpathElevations.Checked);
end;

function TfrmMODFLOW.AdvectionObservationsDefined: boolean;
var
  Index: integer;
  StartPointsUsed, ObsUsed: boolean;
begin
  ObsUsed := False;
  for Index := 0 to frmMODFLOW.clbAdvObs.Items.Count -1 do
  begin
    if frmMODFLOW.clbAdvObs.State[Index] = cbChecked then
    begin
      ObsUsed := True;
      break;
    end;
  end;
  StartPointsUsed := False;
  for Index := 0 to frmMODFLOW.clbAdvObsStartPoints.Items.Count -1 do
  begin
    if frmMODFLOW.clbAdvObsStartPoints.State[Index] = cbChecked then
    begin
      StartPointsUsed := True;
      break;
    end;
  end;
  result := ObsUsed and StartPointsUsed;
end;

procedure TfrmMODFLOW.AdvectionObservationWarning;
begin
  if cbObservations.Checked and cbAdvObs.Checked then
  begin
    if not AdvectionObservationsDefined then
    begin
      Beep;
      MessageDlg('Error: for the advection observation package '
        + 'to be used, both starting points and ending points for the '
        + 'advection observations must be defined.  You should fix this '
        + 'before attempting to run MODFLOW.', mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmMODFLOW.ConvertDAF_TimeToSeconds(ATime: double): double;
begin
  result := 0;
  case comboDAF_TimeStepUnits.ItemIndex of
    0: // seconds
      begin
        result := ATime;
        // do nothing
      end;
    1: // minutes
      begin
        result := ATime*60;
      end;
    2: // hours
      begin
        result := ATime*3600;
      end;
    3: // days
      begin
        result := ATime*3600*24;
      end;
    4: // years
      begin
        result := ATime*3600*24*365;
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

function TfrmMODFLOW.ConvertSimulation_TimeToSeconds(ATime: double): double;
begin
  result := 0;
  case comboTimeUnits.ItemIndex of
    1: // seconds
      begin
        result := ATime;
        // do nothing
      end;
    2: // minutes
      begin
        result := ATime*60;
      end;
    3: // hours
      begin
        result := ATime*3600;
      end;
    4: // days
      begin
        result := ATime*3600*24;
      end;
    5: // years
      begin
        result := ATime*3600*24*365;
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

function TfrmMODFLOW.DaflowFirstTimeError: string;
var
  FirstTimeInSeconds: double;
  SimulationTimeFirstStressPeriod: double;
begin
  result := '';
  FirstTimeInSeconds := InternationalStrToFloat(adeDAF_StartTime.Text);
  FirstTimeInSeconds := ConvertDAF_TimeToSeconds(FirstTimeInSeconds);
  SimulationTimeFirstStressPeriod :=
    InternationalStrToFloat(dgTime.Cells[Ord(tdLength), 1]);
  SimulationTimeFirstStressPeriod :=
    ConvertSimulation_TimeToSeconds(SimulationTimeFirstStressPeriod);
  if FirstTimeInSeconds > SimulationTimeFirstStressPeriod then
  begin
    result := 'Error: The DAFLOW model must start within the first '
      + 'stress period of the model.';
  end;
end;

function TfrmMODFLOW.DaflowLastTimeError: string;
var
  LastTimeInSeconds: double;
  SimulationTimeAllButLastStressPeriod: double;
  Index: integer;
begin
  result := '';
  LastTimeInSeconds := InternationalStrToFloat(adeDAF_EndTime.Text);
  LastTimeInSeconds := ConvertDAF_TimeToSeconds(LastTimeInSeconds);
  SimulationTimeAllButLastStressPeriod := 0;
  for Index := 1 to dgTime.RowCount -2 do
  begin
    SimulationTimeAllButLastStressPeriod := SimulationTimeAllButLastStressPeriod +
      InternationalStrToFloat(dgTime.Cells[Ord(tdLength), Index]);
  end;
  SimulationTimeAllButLastStressPeriod :=
    ConvertSimulation_TimeToSeconds(SimulationTimeAllButLastStressPeriod);
  if LastTimeInSeconds <= SimulationTimeAllButLastStressPeriod then
  begin
    result := 'Error: The DAFLOW model must end within the last '
      + 'stress period of the model.';
  end;
end;

procedure TfrmMODFLOW.cbGWM_PrintResponseMatrixClick(Sender: TObject);
begin
  inherited;
  framFilePathGWM_ResponseMatrixAscii.Enabled :=
    cbGWM_PrintResponseMatrix.Enabled and
    cbGWM_PrintResponseMatrix.Checked;
  if not Loading and not Cancelling and
    (framFilePathGWM_ResponseMatrixAscii.edFilePath.Text = 'File Path') then
  begin
    framFilePathGWM_ResponseMatrixAscii.btnBrowse.OnClick(nil);
  end;
end;

procedure TfrmMODFLOW.comboGmgIadampChange(Sender: TObject);
begin
  inherited;
  adeGMG_DUP.Enabled := (comboGmgIadamp.ItemIndex = 2);
  adeGMG_DLOW.Enabled := (comboGmgIadamp.ItemIndex = 2);
  adeGMG_CHGLIMIT.Enabled := (comboGmgIadamp.ItemIndex = 2);
end;

procedure TfrmMODFLOW.adeGWM_DINITExit(Sender: TObject);
var
  DINIT, DMIN: double;
begin
  inherited;
  DINIT := StrToFloat(adeGWM_DINIT.Text);
  DMIN := StrToFloat(adeGWM_DMIN.Text);
  if DMIN < DINIT then
  begin
    adeGWM_DINIT.EnabledColor := clWindow;
    adeGWM_DMIN.EnabledColor := clWindow;
  end
  else
  begin
    adeGWM_DINIT.EnabledColor := clRed;
    adeGWM_DMIN.EnabledColor := clRed;
  end;
end;

procedure TfrmMODFLOW.EnablecbUzfIRUNFLG;
begin
  cbUzfIRUNFLG.Enabled := cbUZF.Checked and (cbSFR.Checked or cbLAK.Checked);
end;

procedure TfrmMODFLOW.GWM_Warning;
begin
  if not Loading and not Cancelling and cb_GWM.Checked and not rbModflow2005.Checked then
  begin
    Beep;
    MessageDlg('To use the most recent version of GWM, you should make your model a MODFLOW-2005 model.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMODFLOW.Modflow2005Warning;
var
  InvalidLayerTypes: boolean;
  UnitIndex: integer;
begin
  if not Loading and not Cancelling then
  begin
    if not rbModflow2005.Checked and cbUZF.Checked then
    begin
      Beep;
      MessageDlg(
        'The UZF package is not supported in MODFLOW-96 and MODFLOW-2000.',
        mtWarning, [mbOK], 0);
    end;

    if cbUZF.Checked  then
    begin
      if (comboTimeUnits.ItemIndex = 0) then
      begin
        Beep;
        MessageDlg('Time units should be defined when using the UZF package.',
          mtWarning, [mbOK], 0);
      end;
      if (comboLengthUnits.ItemIndex = 0) then
      begin
        Beep;
        MessageDlg('Length units should be defined when using the UZF package.',
          mtWarning, [mbOK], 0);
      end;
      InvalidLayerTypes := False;
      if cbUzfIUZFOPT.Checked then
      begin
        for UnitIndex := 1 to dgGeol.RowCount -1 do
        begin
          if Simulated(UnitIndex) and (ModflowLayerType(UnitIndex) = 0) then
          begin
            InvalidLayerTypes := true;
            break;
          end;
        end;
      end;
       if InvalidLayerTypes then
      begin
        Beep;
        MessageDlg('All units should be convertible if the UZF package is used '
          + 'and the hydraulic conductivity is to come from the flow package.',
          mtWarning, [mbOK], 0);
      end;

    end;

  end;
  TlkWarning;
  HydmodWarning;
  DaflowWarning;
  SorWarning;
end;

procedure TfrmMODFLOW.cbUZFClick(Sender: TObject);
begin
  inherited;
  Modflow2005Warning;
  if not Loading and not Cancelling then
  begin
    if not cbUZF.Enabled then
    begin
      cbUZF.Checked := False;
    end;
  end;
  // enable or disable other UZF controls.
  cbUzfRetain.Enabled := cbUZF.Checked;
  cbUzfIUZFOPT.Enabled := cbUZF.Checked;
  cbUzfIETFLG.Enabled := cbUZF.Checked;
  cbUzrOutput.Enabled := cbUZF.Checked;
  EnablecbUzfIRUNFLG;

  adeUzfNTRAIL2.Enabled := cbUZF.Checked;
  adeUzfNSETS2.Enabled := cbUZF.Checked;

  comboUzfNUZTOP.Enabled := cbUZF.Checked;
  SetComboColor(comboUzfNUZTOP);
  comboUzfTransient.Enabled := cbUZF.Checked;
  SetComboColor(comboUzfTransient);

  adeSurfDep.Enabled := cbUZF.Checked;

  UpdatedUzfLayersAndParameters;
end;

procedure TfrmMODFLOW.UpdatedUzfLayersAndParameters;
begin
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFUzfGroupLayerType, cbUZF.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFUzfFlowLayerType, cbUZF.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFUzfLayerLayerType, cbUZF.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFUzfStreamLakeLayerType, cbUZF.Checked
      and cbUzfIRUNFLG.Checked and (cbLAK.Checked or cbSFR.Checked));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFUzfOutputLayerType, cbUZF.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFUzfFlowLayerType,
    ModflowTypes.GetMFUzfSaturatedKzParamType,
    cbUZF.Checked and not cbUzfIUZFOPT.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFUzfFlowLayerType,
    ModflowTypes.GetMFUzfExtinctionDepthParamType,
    cbUZF.Checked and cbUzfIETFLG.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(
    ModflowTypes.GetMFUzfFlowLayerType,
    ModflowTypes.GetMFUzfExtinctionWaterContentParamType,
    cbUZF.Checked and cbUzfIETFLG.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(
    ModflowTypes.GetMFUzfFlowLayerType,
    ModflowTypes.GetMFUzfPotentialEvapotranspirationParamType,
    cbUZF.Checked and cbUzfIETFLG.Checked);


  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfSaturatedKzParamType,
    cbUZF.Checked and not cbUzfIUZFOPT.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfBrooksCoreyEpsilonParamType,
    cbUZF.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfSaturatedWaterContentParamType,
    cbUZF.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfInitialWaterContentParamType,
    cbUZF.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfExtinctionDepthParamType,
    cbUZF.Checked and cbUzfIETFLG.Checked );
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfExtinctionWaterContentParamType,
    cbUZF.Checked and cbUzfIETFLG.Checked );

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfModflowLayerParamType,
    cbUZF.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfDownstreamStreamOrLakeParamType,
    cbUZF.Checked and cbUzfIRUNFLG.Checked and
      (cbLAK.Checked or cbSFR.Checked));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridUzfOutputChoiceParamType,
    cbUZF.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbUzfIUZFOPTClick(Sender: TObject);
begin
  inherited;
  UpdatedUzfLayersAndParameters;
end;

procedure TfrmMODFLOW.cbVBALClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetGWT_VolumeBalancingLayerClass,
    cbMOC3D.Checked and cbVBAL.Checked);
end;

procedure TfrmMODFLOW.cbUzfIETFLGClick(Sender: TObject);
begin
  inherited;
  UpdatedUzfLayersAndParameters;
end;

procedure TfrmMODFLOW.cbUzfIRUNFLGClick(Sender: TObject);
begin
  inherited;
  UpdatedUzfLayersAndParameters;
end;

procedure TfrmMODFLOW.cbMt3dMultiDiffusionClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMT3DMolecularDiffusionLayerType, cbMT3D.Checked
    and cbDSP.Checked and cbMt3dMultiDiffusion.Checked);
  sgDispersion.Invalidate;
end;

procedure TfrmMODFLOW.cbSWTClick(Sender: TObject);
begin
  inherited;
  cbFlowSwt.Enabled := cbSWT.Checked;
  cbUseSWT.Enabled := cbSWT.Checked;
  rdgSwt.Enabled := cbSWT.Checked;
  if rdgSwt.Enabled then
  begin
    rdgSwt.Color := clWindow;
  end
  else
  begin
    rdgSwt.Color := clBtnFace;
  end;
  jclbPrintInitialDataSets.Enabled := cbSWT.Checked;
  if jclbPrintInitialDataSets.Enabled then
  begin
    jclbPrintInitialDataSets.Color := clWindow;
  end
  else
  begin
    jclbPrintInitialDataSets.Color := clBtnFace;
  end;
  comboSwtITHK.Enabled := cbSWT.Checked;
  SetComboColor(comboSwtITHK);
  comboSwtIVOID.Enabled := cbSWT.Checked;
  SetComboColor(comboSwtIVOID);
  comboSwtISTPCS.Enabled := cbSWT.Checked;
  SetComboColor(comboSwtISTPCS);
  comboSwtICRCC.Enabled := cbSWT.Checked;
  SetComboColor(comboSwtICRCC);
  comboSwtFormat.Enabled := cbSWT.Checked;
  SetComboColor(comboSwtFormat);
  rdgSwtOutput.Enabled := cbSWT.Checked;
  adeSwtISWTOC.Enabled := cbSWT.Checked;
  adeSwtISWTOCEnter(nil);
  adeSwtISWTOCExit(nil);
end;

procedure TfrmMODFLOW.adeSwtISWTOCExit(Sender: TObject);
var
  ISWTOC: integer;
  RowIndex, ColIndex: integer;
begin
  inherited;
  ISWTOC := StrToInt(adeSwtISWTOC.Text);
  if (ISWTOC <= 0) or not cbSWT.Checked then
  begin
    rdgSwtOutput.Enabled := False;
    rdgSwtOutput.Color := clBtnFace;
    Exit;
  end
  else
  begin
    rdgSwtOutput.Enabled := True;
    rdgSwtOutput.Color := clWindow;
  end;
  rdgSwtOutput.RowCount := ISWTOC + 1;
  if PriorISWTOC = 0 then
  begin
    PriorISWTOC := 1;
  end;
  for RowIndex := PriorISWTOC+1 to rdgSwtOutput.RowCount -1 do
  begin
    for ColIndex := 0 to 3 do
    begin
      rdgSwtOutput.Cells[ColIndex,RowIndex] :=
        rdgSwtOutput.Cells[ColIndex,RowIndex-1];
    end;

    for ColIndex := 4 to rdgSwtOutput.ColCount -1 do
    begin
      rdgSwtOutput.Checked[ColIndex,RowIndex] :=
        rdgSwtOutput.Checked[ColIndex,RowIndex-1];
    end;
  end;
end;

procedure TfrmMODFLOW.adeSwtISWTOCEnter(Sender: TObject);
begin
  inherited;
  PriorISWTOC := StrToInt(adeSwtISWTOC.Text);

end;

procedure TfrmMODFLOW.SetSwtLayers;
var
  UnitIndex: integer;
  GeoUnit: T_ANE_IndexedLayerList;
  SubLayer: TSwtUnitLayer;
  RowIndex, ColIndex: integer;
  GeoUnitRequired: Boolean;
begin
  for RowIndex := 1 to rdgSwtOutput.RowCount -1 do
  begin
    for ColIndex := 0 to 3 do
    begin
      if rdgSwtOutput.Cells[ColIndex, RowIndex] = '' then
      begin
        rdgSwtOutput.Cells[ColIndex, RowIndex] := '1'
      end;
    end;
  end;

  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMF_SWT_GroupLayerType, cbSWT.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMFGeostaticStressLayerType, cbSWT.Checked);
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer(
    ModflowTypes.GetMFSpecificGravityLayerType, cbSWT.Checked);

  for UnitIndex := 1 to dgGeol.RowCount -1 do
  begin
    GeoUnit := MFLayerStructure.ListsOfIndexedLayers.
      GetNonDeletedIndLayerListByIndex(UnitIndex-1);
    if GeoUnit <> nil then
    begin
      GeoUnitRequired := Simulated(UnitIndex) and cbSWT.Checked;
      GeoUnit.AddOrRemoveLayer(ModflowTypes.GetMFSwtUnitLayerType,
        GeoUnitRequired);
      if GeoUnitRequired then
      begin
        SubLayer :=GeoUnit.GetLayerByName(ModflowTypes.
          GetMFSwtUnitLayerType.ANE_LayerName)
          as TSwtUnitLayer;
        SubLayer.Count := SwtInterbedCount(UnitIndex);

        SubLayer.AddOrRemoveUnIndexedParameter(
          ModflowTypes.GetMFInitialPreconsolidationStressParamType,
          comboSwtISTPCS.ItemIndex = 0);
        SubLayer.AddOrRemoveUnIndexedParameter(
          ModflowTypes.GetMFInitialEffectiveStressOffsetParamType,
          comboSwtISTPCS.ItemIndex = 1);

        SubLayer.AddOrRemoveIndexedParameter0(
          ModflowTypes.GetMFCompressionIndexParamType,
          comboSwtICRCC.ItemIndex = 0);
        SubLayer.AddOrRemoveIndexedParameter0(
          ModflowTypes.GetMFRecompressionIndexParamType,
          comboSwtICRCC.ItemIndex = 0);
        SubLayer.AddOrRemoveIndexedParameter0(
          ModflowTypes.GetMFInitialElasticSpecificStorageParamType,
          comboSwtICRCC.ItemIndex <> 0);
        SubLayer.AddOrRemoveIndexedParameter0(
          ModflowTypes.GetMFInitialInelasticSpecificStorageParamType,
          comboSwtICRCC.ItemIndex <> 0);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.rdgSwtOutputSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if (ARow > 0) and (ACol > 5) then
  begin
    CanSelect := rdgSwtOutput.Checked[4,ARow] or rdgSwtOutput.Checked[5,ARow]
  end;

end;

procedure TfrmMODFLOW.cbIncreaseUnitNumbersClick(Sender: TObject);
begin
  inherited;
  adeIncreaseUnitNumbers.Enabled := cbIncreaseUnitNumbers.Checked;
end;

procedure TfrmMODFLOW.EnableMBRP_and_MBIT;
var
  ShouldEnable: Boolean;
begin
  ShouldEnable := cbMOC3D.Checked and (rgMOC3DSolver.ItemIndex in [3,4]);
  cbMBRP.Enabled := ShouldEnable;
  cbMBIT.Enabled := ShouldEnable;
end;

procedure TfrmMODFLOW.EnableMf2005LpfOptions;
begin
  comboVertCond.Enabled := (rgFlowPackage.ItemIndex = 1)
    and rbModflow2005.Checked;
  cbVertCondCorrection.Enabled := comboVertCond.Enabled;
end;

procedure TfrmMODFLOW.cbTOBClick(Sender: TObject);
begin
  inherited;
  tabTransportObservations.TabVisible := cbTOB.Checked;
  adeConcObsLayerCountExit(Sender);
end;

procedure TfrmMODFLOW.adeConcObsLayerCountExit(Sender: TObject);
var
  ObservationList: T_ANE_IndexedLayerList;
  OldObservationLayerCount, NewObservationLayerCount: integer;
  ALayer: T_ANE_MapsLayer;
  Index: integer;
begin
  inherited;
  ObservationList :=
    MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgMt3dConcentrationObservations)];
  OldObservationLayerCount := ObservationList.NonDeletedLayerCount;
  NewObservationLayerCount := StrToInt(adeConcObsLayerCount.Text);
  if not cbMT3D.Checked or not cbTOB.Checked or not cb_inConcObs.Checked then
  begin
    NewObservationLayerCount := 0;
  end;

  if NewObservationLayerCount <> OldObservationLayerCount then
  begin
    if NewObservationLayerCount > OldObservationLayerCount then
    begin
      for Index := 0 to ObservationList.Count - 1 do
      begin
        ALayer := ObservationList.Items[Index];
        if Index < NewObservationLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end
    else
    begin
      for Index := ObservationList.Count - 1 downto 0 do
      begin
        ALayer := ObservationList.Items[Index];
        if Index < NewObservationLayerCount {+1} then
        begin
          ALayer.UnDelete
        end
        else
        begin
          ALayer.Delete;
        end;
      end;
    end;

    for Index := OldObservationLayerCount to NewObservationLayerCount - 1 do
    begin
      ModflowTypes.GetMT3DWeightedConcentrationObservationsLayerType.Create(ObservationList, -1);
    end;
  end;
end;

procedure TfrmMODFLOW.adeConcObsTimeCountExit(Sender: TObject);
var
  NewConcObsTimeCount: integer;
  ObservationList: T_ANE_IndexedLayerList;
  ALayer: TIndexedInfoLayer;
  LayerIndex, ParamIndex: integer;
  ParameterList: T_ANE_IndexedParameterList;
begin
  inherited;
  NewConcObsTimeCount := StrToInt(adeConcObsTimeCount.Text);

  if NewConcObsTimeCount <> OldConcObsTimeCount then
  begin
    ObservationList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[Ord(lgMt3dConcentrationObservations)];
    for LayerIndex := 0 to ObservationList.Count - 1 do
    begin
      ALayer := ObservationList.Items[LayerIndex] as TIndexedInfoLayer;
      if NewConcObsTimeCount > OldConcObsTimeCount then
      begin
        for ParamIndex := 0 to ALayer.IndexedParamList1.Count - 1 do
        begin
          ParameterList := ALayer.IndexedParamList1.Items[ParamIndex];
          if ParamIndex < NewConcObsTimeCount + 1 then
          begin
            ParameterList.UnDeleteSelf;
          end
          else
          begin
            ParameterList.DeleteSelf;
          end;
        end;
      end
      else
      begin
        for ParamIndex := ALayer.IndexedParamList1.Count - 1 downto 0 do
        begin
          ParameterList := ALayer.IndexedParamList1.Items[ParamIndex];
          if ParamIndex < NewConcObsTimeCount then
          begin
            ParameterList.UnDeleteSelf;
          end
          else
          begin
            ParameterList.DeleteSelf;
          end;
        end;
      end;

      for ParamIndex := OldConcObsTimeCount to NewConcObsTimeCount - 1 do
      begin
        ModflowTypes.GetMFConcentrationObservationParamListType.Create(
          ALayer.IndexedParamList1, -1);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.UpdateConcObsWeights;
var
  NewNumberOfUnits: integer;
  ObservationList: T_ANE_IndexedLayerList;
  ALayer: TIndexedInfoLayer;
  LayerIndex, ParamIndex: integer;
  ParameterList: T_ANE_IndexedParameterList;
begin
  inherited;
  NewNumberOfUnits := StrToInt(edNumUnits.Text);

  if NewNumberOfUnits <> PrevNumUnits then
  begin
    ObservationList :=
      MFLayerStructure.FirstListsOfIndexedLayers.Items[
        Ord(lgMt3dConcentrationObservations)];
    for LayerIndex := 0 to ObservationList.Count - 1 do
    begin
      ALayer := ObservationList.Items[LayerIndex] as TIndexedInfoLayer;
      if NewNumberOfUnits > PrevNumUnits then
      begin
        for ParamIndex := 0 to ALayer.IndexedParamList0.Count - 1 do
        begin
          ParameterList := ALayer.IndexedParamList0.Items[ParamIndex];
          if ParamIndex < NewNumberOfUnits + 1 then
          begin
            ParameterList.UnDeleteSelf;
          end
          else
          begin
            ParameterList.DeleteSelf;
          end;
        end;
      end
      else
      begin
        for ParamIndex := ALayer.IndexedParamList0.Count - 1 downto 0 do
        begin
          ParameterList := ALayer.IndexedParamList0.Items[ParamIndex];
          if ParamIndex < NewNumberOfUnits then
          begin
            ParameterList.UnDeleteSelf;
          end
          else
          begin
            ParameterList.DeleteSelf;
          end;
        end;
      end;

      for ParamIndex := PrevNumUnits to NewNumberOfUnits - 1 do
      begin
        ModflowTypes.GetMFConcWeightParamListType.Create(
          ALayer.IndexedParamList0, -1);
      end;
    end;
  end;
end;

procedure TfrmMODFLOW.adeConcObsTimeCountEnter(Sender: TObject);
begin
  inherited;
  OldConcObsTimeCount := StrToInt(adeConcObsTimeCount.Text);
end;

procedure TfrmMODFLOW.cb_inConcObsClick(Sender: TObject);
begin
  inherited;
  adeConcObsLayerCountExit(Sender);
end;

procedure TfrmMODFLOW.comboDensityChoiceChange(Sender: TObject);
begin
  inherited;
  adeSW_ComponentChoice.Enabled := cbSW_Coupled.Checked
    and (comboDensityChoice.ItemIndex = 0);
  EnableMultipCompControls;
end;

procedure TfrmMODFLOW.adeSWDensCompCountExit(Sender: TObject);
var
  RowIndex: integer;
begin
  inherited;
  rdgSWDensTable.RowCount := StrToInt(adeSWDensCompCount.Text)+1;
  for RowIndex := 1 to rdgSWDensTable.RowCount -1 do
  begin
    if rdgSWDensTable.Cells[0,RowIndex] = '' then
    begin
      rdgSWDensTable.Cells[0,RowIndex] := IntToStr(RowIndex);
    end;
    if rdgSWDensTable.Cells[1,RowIndex] = '' then
    begin
      rdgSWDensTable.Cells[1,RowIndex] := '1';
    end;
    if rdgSWDensTable.Cells[2,RowIndex] = '' then
    begin
      rdgSWDensTable.Cells[2,RowIndex] := '0.7143';
    end;
    if rdgSWDensTable.Cells[3,RowIndex] = '' then
    begin
      rdgSWDensTable.Cells[3,RowIndex] := '0';
    end;

  end;

end;

procedure TfrmMODFLOW.rdgSWDensTableBeforeDrawCell(Sender: TObject; ACol,
  ARow: Integer);
var
  Grid: TRbwDataGrid4;
begin
  inherited;
  Grid := Sender as TRbwDataGrid4;
  if not Grid.Enabled then
  begin
    Grid.Canvas.Brush.Color := clBtnFace;
  end;
end;

procedure TfrmMODFLOW.EnableSeawatViscSpecies;
begin
  adeSwViscSpecies.Enabled := cbSeawatViscosity.Checked
    and (comboSW_ViscosityMethod.ItemIndex = 2);
end;

procedure TfrmMODFLOW.SetViscEqDefaults(const SetAll: boolean);
begin
  if rdgSW_ViscEqTemp.Enabled then
  begin
    case comboSW_ViscEquation.ItemIndex of
      1:
        begin
          if SetAll or (rdgSW_ViscEqTemp.Cells[0,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[0,1] := '1';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[1,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[1,1] := '2.394e-5';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[2,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[2,1] := '10';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[3,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[3,1] := '248.37';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[4,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[4,1] := '133.15';
          end;
        end;
      2:
        begin
          if SetAll or (rdgSW_ViscEqTemp.Cells[0,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[0,1] := '1';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[1,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[1,1] := '1e-3';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[2,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[2,1] := '1';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[3,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[3,1] := '1.5512e-2';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[4,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[4,1] := '-20';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[5,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[5,1] := '-1.572';
          end;
        end;
      3:
        begin
          if SetAll or (rdgSW_ViscEqTemp.Cells[0,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[0,1] := '1';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[1,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[1,1] := '0.168';
          end;
          if SetAll or (rdgSW_ViscEqTemp.Cells[2,1] = '') then
          begin
            rdgSW_ViscEqTemp.Cells[2,1] := '-1.0868';
          end;
        end;
    else Assert(False);
    end;
  end;
end;

procedure TfrmMODFLOW.EnableSW_TempCorrectionTerms;
begin
  rdgSW_ViscEqTemp.Enabled := cbSeawatViscosity.Checked
    and (comboSW_ViscosityMethod.ItemIndex = 0)
    and (comboSW_ViscEquation.ItemIndex > 0);
  rdgSW_ViscEqTemp.Invalidate;

end;

procedure TfrmMODFLOW.cbSeawatViscosityClick(Sender: TObject);
begin
  inherited;
  comboSW_ViscosityMethod.Enabled := cbSeawatViscosity.Checked;
  SetComboColor(comboSW_ViscosityMethod);
  EnableSeawatViscSpecies;

  adeSW_RefVisc.Enabled := cbSeawatViscosity.Checked;
  adeSW_ViscMin.Enabled := cbSeawatViscosity.Checked;
  adeSW_ViscMax.Enabled := cbSeawatViscosity.Checked;

  EnableSeawatViscTerms;
  EnableSW_TempCorrectionTerms;
  EnableSW_TimeVaryingViscosity;

  AddOrRemoveSeaWatLayersAndParameters;
end;

procedure TfrmMODFLOW.EnableSeawatViscTerms;
var
  ShouldEnable: boolean;
begin
  ShouldEnable := cbSeawatViscosity.Checked
    and (comboSW_ViscosityMethod.ItemIndex >= 1);
  adeSW_ViscositySlope.Enabled := ShouldEnable;
  adeSW_RefViscConc.Enabled := ShouldEnable;
end;

procedure TfrmMODFLOW.EnableSeawatMultViscEq;
var
  ShouldEnable: boolean;
begin
  ShouldEnable := cbSeawatViscosity.Checked
    and (comboSW_ViscosityMethod.ItemIndex = 0);
  comboSW_ViscEquation.Enabled := ShouldEnable;
  SetComboColor(comboSW_ViscEquation);
  adeSW_ViscEquationCount.Enabled := ShouldEnable;

  rdgSW_ViscEq.Enabled := ShouldEnable;
  rdgSW_ViscEq.Invalidate;
end;

procedure TfrmMODFLOW.EnableSW_TimeVaryingViscosity;
begin
  comboSW_TimeVaryingViscosity.Enabled := cbSeawatViscosity.Checked
    and (comboSW_ViscosityMethod.ItemIndex = 1);
  SetComboColor(comboSW_TimeVaryingViscosity);
end;

procedure TfrmMODFLOW.comboSW_ViscosityMethodChange(Sender: TObject);
begin
  inherited;
  EnableSeawatViscSpecies;
  EnableSeawatViscTerms;
  EnableSeawatMultViscEq;
  EnableSW_TempCorrectionTerms;
  EnableSW_TimeVaryingViscosity;
  AddOrRemoveSeaWatLayersAndParameters;
end;

procedure TfrmMODFLOW.comboSW_ViscEquationChange(Sender: TObject);
begin
  inherited;
  EnableSW_TempCorrectionTerms;
  case comboSW_ViscEquation.ItemIndex of
    0:
      begin
        // do nothing
      end;
    1:
      begin
        rdgSW_ViscEqTemp.ColCount := 5;
        rdgSW_ViscEqTemp.Columns[3].WordWrapCaptions := True;
        rdgSW_ViscEqTemp.Columns[4].WordWrapCaptions := True;
        rdgSW_ViscEqTemp.Columns[3].AutoAdjustRowHeights := True;
        rdgSW_ViscEqTemp.Columns[4].AutoAdjustRowHeights := True;
        rdgSW_ViscEqTemp.Columns[3].AutoAdjustColWidths := True;
        rdgSW_ViscEqTemp.Columns[4].AutoAdjustColWidths := True;
        rdgSW_ViscEqTemp.Cells[3,0] := 'A3 (AMUCOEFF[3])';
        rdgSW_ViscEqTemp.Cells[4,0] := 'A4 (AMUCOEFF[4])';
        rdgSW_ViscEqTemp.Columns[3].Format := rcf4Real;
        rdgSW_ViscEqTemp.Columns[4].Format := rcf4Real;
      end;
    2:
      begin
        rdgSW_ViscEqTemp.ColCount := 6;
        rdgSW_ViscEqTemp.Columns[3].WordWrapCaptions := True;
        rdgSW_ViscEqTemp.Columns[4].WordWrapCaptions := True;
        rdgSW_ViscEqTemp.Columns[5].WordWrapCaptions := True;
        rdgSW_ViscEqTemp.Columns[3].AutoAdjustRowHeights := True;
        rdgSW_ViscEqTemp.Columns[4].AutoAdjustRowHeights := True;
        rdgSW_ViscEqTemp.Columns[5].AutoAdjustRowHeights := True;
        rdgSW_ViscEqTemp.Columns[3].AutoAdjustColWidths := True;
        rdgSW_ViscEqTemp.Columns[4].AutoAdjustColWidths := True;
        rdgSW_ViscEqTemp.Columns[5].AutoAdjustColWidths := True;
        rdgSW_ViscEqTemp.Cells[3,0] := 'A3 (AMUCOEFF[3])';
        rdgSW_ViscEqTemp.Cells[4,0] := 'A4 (AMUCOEFF[4])';
        rdgSW_ViscEqTemp.Cells[5,0] := 'A5 (AMUCOEFF[5])';
        rdgSW_ViscEqTemp.Columns[3].Format := rcf4Real;
        rdgSW_ViscEqTemp.Columns[4].Format := rcf4Real;
        rdgSW_ViscEqTemp.Columns[5].Format := rcf4Real;
      end;
    3:
      begin
        rdgSW_ViscEqTemp.ColCount := 3;
      end;
  else Assert(False);
  end;
  SetViscEqDefaults(False);

end;

procedure TfrmMODFLOW.comboSW_TimeVaryingViscosityChange(Sender: TObject);
begin
  inherited;
  AddOrRemoveSeaWatLayersAndParameters;
end;

procedure TfrmMODFLOW.adeSW_ViscEquationCountExit(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  rdgSW_ViscEq.RowCount := StrToInt(adeSW_ViscEquationCount.Text) + 1;
  for Index := 1 to rdgSW_ViscEq.RowCount-1 do
  begin
    rdgSW_ViscEq.Cells[0,Index] := IntToStr(Index);
  end;

end;

procedure TfrmMODFLOW.btnSW_ViscEqTermDefaultsClick(Sender: TObject);
begin
  inherited;
  SetViscEqDefaults(True);
end;

initialization

finalization
  mHHelp.Free;
  mHHelp := nil;
//  HHCloseAll;

end.

