unit ModflowUnit;

interface

{ModflowUnit defines the form displayed when "PIEs|Edit Project Info" is
 selected.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, Grids, StdCtrls, ArgusDataEntry, ComCtrls, Buttons,
  MFLayerStructureUnit, OleCtrls, ASLink,  DataGrid, ExtCtrls, ANE_LayerUnit,
  VersInfo;

type
  TfrmMODFLOW = class(TArgusForm)
    pnlBottom: TPanel;
    pageControlMain: TPageControl;
    pnlOkButton: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
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
    pnlGeolUnitTop: TPanel;
    lblNumGeolUnits: TLabel;
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
    sgTime: TStringGrid;
    pnlTimeBottom: TPanel;
    pnlTimeButtons: TPanel;
    btnInsertTime: TButton;
    comboSteady: TComboBox;
    comboTimeUnits: TComboBox;
    lblTrans: TLabel;
    lblTimeUnits: TLabel;
    lblStressPer: TLabel;
    lblISS: TLabel;
    lblITMUNI: TLabel;
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
    pnlMOC3DOutputTop: TPanel;
    comboMOC3DConcFileType: TComboBox;
    lblMOC3DConc: TLabel;
    comboMOC3DVelFileType: TComboBox;
    lblMOC3DVelocity: TLabel;
    lblMOC3DDispCoef: TLabel;
    comboMOC3DPartFileType: TComboBox;
    lblMOC3DParticlLoc: TLabel;
    comboMOC3DConcFreq: TComboBox;
    comboMOC3DVelFreq: TComboBox;
    comboMOC3DDispFreq: TComboBox;
    comboMOC3DPartFreq: TComboBox;
    lblMOC3DConcN: TLabel;
    lblMOC3DVelocityN: TLabel;
    lblMOC3DDispCoefN: TLabel;
    lblMOC3DParticlLocN: TLabel;
    adeMOC3DPartFreq: TArgusDataEntry;
    adeMOC3DDispFreq: TArgusDataEntry;
    adeMOC3DVelFreq: TArgusDataEntry;
    adeMOC3DConcFreq: TArgusDataEntry;
    sgMOC3DTransParam: TStringGrid;
    edNumUnits: TEdit;
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
    lblExportBAS: TLabel;
    lblExportOC: TLabel;
    lblExportBCF: TLabel;
    lblExportRCH: TLabel;
    lblExportRIV: TLabel;
    lblExportWEL: TLabel;
    lblExportDRN: TLabel;
    lblExportGHB: TLabel;
    lblExportEVT: TLabel;
    lblExportMatrix: TLabel;
    lblExportMOC3DSoluteTransport: TLabel;
    lblExportMOC3DObsWell: TLabel;
    cbExpBAS: TCheckBox;
    cbExpOC: TCheckBox;
    cbExpBCF: TCheckBox;
    cbExpRCH: TCheckBox;
    cbExpRIV: TCheckBox;
    cbExpWEL: TCheckBox;
    cfExpDRN: TCheckBox;
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
    pnlMOC3DParticleButtons: TPanel;
    btnMOC3DParticleDelete: TButton;
    btnMOC3DParticleAdd: TButton;
    adeMOCNumLayers: TArgusDataEntry;
    lblNumMOC3DGeolUnits: TLabel;
    lblNumMOC3DLay: TLabel;
    tabCustomize: TTabSheet;
    comboCustomize: TComboBox;
    lblInitHeadFormula: TLabel;
    tabStream: TTabSheet;
    tabMoreStresses: TTabSheet;
    gbMoreStresses: TGroupBox;
    cbExpHFB: TCheckBox;
    lblHFT: TLabel;
    cbExpFHB: TCheckBox;
    lblFHBExport: TLabel;
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
    comboMODPATH_RechargeITOP: TComboBox;
    comboMODPATH_EvapITOP: TComboBox;
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
    lblMODPATH_RechargeITOP: TLabel;
    lblMODPATH_EvapITOP: TLabel;
    lblNVALUES: TLabel;
    pnlMODPATH1: TPanel;
    pnlMODPATHTitle: TPanel;
    sgMODPATHOutputTimes: TStringGrid;
    adeZonebudgetPath: TArgusDataEntry;
    rbRunZonebudget: TRadioButton;
    rbCreateZonebudget: TRadioButton;
    tabAbout: TTabSheet;
    Image1: TImage;
    lblTitle: TLabel;
    lblAuthors: TLabel;
    lblPrev: TLabel;
    memoReferences: TMemo;
    rbMPATHCreate: TRadioButton;
    rbMPATHRun: TRadioButton;
    adeMODPATHPath: TArgusDataEntry;
    tabMODPATHOptions: TTabSheet;
    aslMail: TASLink;
    aslURL: TASLink;
    dgGeol: TDataGrid;
    tabProblem: TTabSheet;
    reProblem: TRichEdit;
    pnlProblem: TPanel;
    btnDeveloper: TButton;
    BitBtnHelp: TBitBtn;
    pnlFHB1: TPanel;
    pnlFHB2: TPanel;
    lblFHB: TLabel;
    sgFHBTimes: TStringGrid;
    cbExpStr: TCheckBox;
    lblExpSTR: TLabel;
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
    cbZonebudget: TCheckBox;
    cbMODPATH: TCheckBox;
    cbMOC3D: TCheckBox;
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
    cbCHTOCH: TCheckBox;
    cbStrPrintFlows: TCheckBox;
    cbMOC3DNoDisp: TCheckBox;
    lblMOC3DNODISP: TLabel;
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
    cbMPathCheck: TCheckBox;
    cbMPathSummarize: TCheckBox;
    lblMPathErrorTolerance: TLabel;
    lblVersion: TLabel;
    lblFileVersionCaption: TLabel;
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
    cbAltRiv: TCheckBox;
    rgMOC3DConcFormat: TRadioGroup;
    cbActiveBoundary: TCheckBox;
    cbAltDrn: TCheckBox;
    cbAltGHB: TCheckBox;
    cbRechLayer: TCheckBox;
    cbETLayer: TCheckBox;
    lblSupport: TLabel;
    cbCalibrate: TCheckBox;
    cbShowWarnings: TCheckBox;
    tabAgeDpDk: TTabSheet;
    gbAge: TGroupBox;
    cbAge: TCheckBox;
    adeAge: TArgusDataEntry;
    lblAge: TLabel;
    gbDualPorosity: TGroupBox;
    cbDualPorosity: TCheckBox;
    cbIDPFO: TCheckBox;
    cbIDPZO: TCheckBox;
    lblDualPOutOption: TLabel;
    comboDualPOutOption: TComboBox;
    gbSimpleReactions: TGroupBox;
    cbIDKRF: TCheckBox;
    cbIDKFO: TCheckBox;
    cbIDKFS: TCheckBox;
    cbIDKZO: TCheckBox;
    cbIDKZS: TCheckBox;
    cbSimpleReactions: TCheckBox;
    gbFlowPackages: TGroupBox;
    lblHorFlowBar: TLabel;
    cbHFB: TCheckBox;
    cbHFBRetain: TCheckBox;
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
    VersionInfo1: TVersionInfo;
    lblAgeWarning: TLabel;
    cbIDPTIM_Decay: TCheckBox;
    cbIDPTIM_Growth: TCheckBox;
    cbIDKTIM_DisDecay: TCheckBox;
    cbIDKTIM_SorbDecay: TCheckBox;
    cbIDKTIM_DisGrowth: TCheckBox;
    cbIDKTIM_SorbGrowth: TCheckBox;
    GroupBox1: TGroupBox;
    cbInitial: TCheckBox;
    edInitial: TEdit;
    btnInitialSelect: TBitBtn;
    lblInitialHeads: TLabel;
    cbProgressBar: TCheckBox;
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
    procedure edNumPerExit(Sender: TObject);  virtual;
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
      const Value: String); virtual;
    procedure sgMOC3DParticlesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String); virtual;
    procedure sgMOC3DParticlesExit(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); override;
    procedure comboMOC3DPartFreqChange(Sender: TObject); virtual;
    procedure FormShow(Sender: TObject); virtual;
    procedure btnAddUnitClick(Sender: TObject); virtual;
    procedure btnAddTimeClick(Sender: TObject); virtual;
    procedure edMOC3DInitParticlesEnter(Sender: TObject); virtual;
    procedure edMOC3DInitParticlesExit(Sender: TObject); virtual;
    procedure sgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer); virtual;
    procedure adeMOC3DLayerExit(Sender: TObject); virtual;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; virtual;
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
      const Value: String); virtual;
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
      ARow: Integer; const Value: String); virtual;
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
      const Value: String); virtual;
    procedure dgGeolSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgZondbudTimesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean); virtual;
    procedure sgZondbudTimesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);virtual;
    procedure sgZondbudTimesExit(Sender: TObject); virtual;
    procedure sgMOC3DTransParamSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String); virtual;
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
  published
    function SetColumns(AStringGrid: TStringGrid): boolean; override;
  private
//    procedure SimCheckboxClick(Sender: TObject);
  public
    MFLayerStructure : TLayerStructure;
    PrevNumPeriods : integer;
    PrevNumUnits : integer;
    PrevNumParticles : Integer;
    PreviousFHBTimes : integer;
    LastGeologyText : string;
    LastTimeText : string;
    PreviousParticleText : string;
    PreviousFHBTimeText : string;
    PreviousMODPATHReleaseTimesText : string;
    FirstList :TStringList;
    RecalculateSubgrid : boolean ;
    GeologicUnitsList : TList;
    GeologicUnitParametersList : TList;
    PreviousMODPATHTimeText : string;
    PrevCompZoneText: string;
    PrevCompZoneCount: string;
//    PIEDeveloper : string;
    PrevZoneBudTime: string;
    PrevMOC3DTransParam: string;
//    NewModel : boolean;
    NeedToUpdateMOC3DSubgrid : boolean;
    LeftMOC3DSubGridDistance : double;
    RightMOC3DSubGridDistance : double;
    TopMOC3DSubGridDistance : double;
    BottomMOC3DSubGridDistance : double;
//    Cancelling : boolean;
    procedure InitializeGrids; virtual;
    procedure InitialHeadsWarning; virtual;
    Function CBoundNeeded (GeolUnit : Integer) : boolean; virtual;
    Procedure AssociateUnits; virtual;
    Procedure AssociateTimes; virtual;
    Procedure InsertTimeParameters (Position : Integer) ; virtual;
    procedure DeleteTimeParameters (Position : Integer); virtual;
//    procedure UpdateGeoGrid;
    procedure CreateGeologicLayer(Position : integer); virtual;
    procedure DeleteGeologicLayer(Position : integer); virtual;
//    function GetMFLayerStructure : TMFLayerStructure; virtual;
    procedure AssignHelpFile(FileName : string) ; virtual;
    function MODFLOWLayerCount : integer; virtual;
    function MOC3DLayerCount : integer; virtual;
    function GetCompositeZone(const Zone: Integer): string; virtual;
    function GetZonebudTimesCount: integer; virtual;
    function GetZoneBudTimeStep(ATime: integer): Integer; virtual;
    function GetZoneBudStressPeriod(ATime: integer): Integer; virtual;
    function RowNeeded(Row: integer): boolean;  virtual;
    function GetPIEVersion(AControl: Tcontrol): string; virtual;
    function PieIsEarlier(VersionInString, VersionInPIE : string ;
      ShowError : boolean): boolean; virtual;
    procedure ReadOldGeoData(var LineIndex : integer; FirstList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadOldIDIREC(var LineIndex : integer; FirstList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadEPSSLV(var LineIndex : integer; FirstList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadCTOCH(var LineIndex : integer; FirstList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure LoadModflowForm(UnreadData : TStringlist; DataToRead : string;
          var VersionInString : string ) ; virtual;
    Procedure ReadValFile(var VersionInString : string; Path : string ) ;
    Procedure UpdateMOC3DSubgrid ; virtual;
    procedure StreamWarning; virtual;
    procedure Moc3dWetWarning; virtual;
    procedure Moc3dTimeWarning; virtual;
    procedure SetComboColor(ACombo: TComboBox); virtual;
    procedure ModelComponentName(AStringList: TStringList); override;
    procedure LabelUnits(AStringGrid: TStringGrid); virtual;
    procedure ReadOld_IDPTIM(var LineIndex: integer; FirstList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOld_IDKTIM(var LineIndex: integer; FirstList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    { Public declarations }
  end;

type timeData = (tdN, tdLength, tdNumSteps, tdMult, tdFirstStep);
//  timeData is used to access data columns in sgTime by name

//type unitData = (uiName, uiSim, uiTrans, uiType, uiAnis, uiVertDisc);
//  unitData is used to access data columns in dtabGeol by name

type NewUnitData = (nuiN, nuiName, nuiSim, nuiTrans, nuiType, nuiAnis,
                 nuiVertDisc, nuiSpecT, nuiSpecVCONT, nuiSpecSF1);
//  unitData is used to access data columns in dgGeol by name

type MOC3DparticleData = (pdN, pdLayer, pdRow, pdColumn);
//  unitData is used to access data columns in sgMOC3DParticles by name

type MOC3DtransData = (trdN, trdLong, trdTranHor, trdTranVer,
                       trdRetard, trdConc);
//  unitData is used to access data columns in sgMOC3DTransParam by name


ResourceString
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
{$IFDEF MathUnitPresent}
     Math,
{$ELSE}
     Powers,
{$ENDIF}
    MFMOCObsWell, AnePIE, ANECB, UtilityFunctions, Variables,
    ContourListUnit, MOC3DGridFunctions;

function TfrmMODFLOW.MODFLOWLayerCount : integer;
var
  UnitIndex : integer;
begin
  // called by btnOpenDataSetClick in PostMODFLOW.
  // called by btnOKClick
  // This function returns the number of MODFLOW layers in a model.

  // Initialize result
  result := 0;

  // loop over geologic units
  for UnitIndex := 1 to dgGeol.RowCount-1 do
  begin
    // if a geologic unit is simulated, add the vertical discretization of
    // that unit to the total.
    if dgGeol.Cells[Ord(nuiSim),UnitIndex]
      = 'Yes' then
    begin
      result := result + StrToInt(dgGeol.Cells
        [Ord(nuiVertDisc),UnitIndex]);
    end;
  end;
end;

procedure TfrmMODFLOW.AssignHelpFile(FileName : string) ;
var
    DllDirectory : String;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + FileName;// MODFLOW.hlp';
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


procedure TfrmMODFLOW.DeleteTimeParameters (Position : Integer);
var
  ListOfParameterLists : TList;
  AParameterList : T_ANE_IndexedParameterList ;
  ParameterListIndex : integer;
begin
  // called by edNumPerExit
  // called by btnDeleteTimeClick

  // a list of time-related parameter lists is stored in the objects
  // property of the first column of the sgTime grid.
  // Calling this function, causes all those parameter lists and the
  // parameters they hold them to have their status set
  // to sDeleted.
  // This procedure may be overriden in descendents.

  // Get the list of parameter lists for the appropriate time step.
  ListOfParameterLists := sgTime.Objects[0, Position] as TList;

  // loop over all the parameter lists and delete them.
  for ParameterListIndex := ListOfParameterLists.Count -1 downto 0 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    AParameterList.DeleteSelf;
  end;

  // Free the list of parameter lists.
  ListOfParameterLists.Free;

  // reset the objects property of the appropriate cell to nil.
  sgTime.Objects[0, Position] := nil;
end;

procedure TfrmMODFLOW.CreateGeologicLayer(Position : integer);
var
  AMFGridLayer : T_ANE_GridLayer;
begin
  // called by edNumUnitsExit;
  // called by btnInsertUnitClick;

  // create the information layers for a new geologic unit at the
  // appropriate position.
  ModflowTypes.GetGeologicUnitType.Create
    (MFLayerStructure.ListsOfIndexedLayers, Position);

  // get the grid layer.
  AMFGridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
    (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;

  // create grid parameters for a new geologic unit in the grid layer at the
  // appropriate position.
  ModflowTypes.GetMFGeologicUnitParametersType.Create
    ((AMFGridLayer as ModflowTypes.GetGridLayerType).IndexedParamList1,
     Position);
end;

procedure TfrmMODFLOW.DeleteGeologicLayer(Position : integer);
var
  UnitParamIndex : integer;
  AGeologicUnitParameters : T_ANE_IndexedParameterList;
  AGeologicUnit : T_ANE_IndexedLayerList;
  AUnitParamList : TList;
begin
  // called by edNumUnitsExit;
  // called by btnDeleteUnitClick

  // get the geologic unit.
  AGeologicUnit := GeologicUnitsList.Items[Position];

  // set the status of the geologic unit and all it's layers to sDeleted.
  (AGeologicUnit as ModflowTypes.GetGeologicUnitType).DeleteSelf;

  // get the list of parameterslists related to geologic units
  AUnitParamList := GeologicUnitParametersList.Items[Position];

  // loop over the lists of parameter lists and set the status of
  // the parameterlists and the parameters they contain to sDeleted.
  for UnitParamIndex := AUnitParamList.Count -1 downto 0 do
  begin
    AGeologicUnitParameters := AUnitParamList.Items[UnitParamIndex];
    (AGeologicUnitParameters as ModflowTypes.GetMFGeologicUnitParametersType).
      DeleteSelf;
  end;
end;



procedure TfrmMODFLOW.InitializeGrids;
var
  RowIndex : integer;
  ColIndex : integer;
begin
  // called by FormCreate
  // called by GLoadForm

  // Initialize the titles of sgTime
  sgTime.Cells[Ord(tdN),0] := rsN;
  sgTime.Cells[Ord(tdLength),0] := rsLength;
  sgTime.Cells[Ord(tdNumSteps),0] := rsNumSteps;
  sgTime.Cells[Ord(tdMult),0] := rsMult;
  sgTime.Cells[Ord(tdFirstStep),0] := rsFirstStep;
  for RowIndex := 1 to sgTime.RowCount - 1 do
  begin
    sgTime.Cells[Ord(tdN),RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgMOC3DParticles
  sgMOC3DParticles.Cells[Ord(pdN),0] := rsN;
  sgMOC3DParticles.Cells[Ord(pdLayer),0] := rsLayer;
  sgMOC3DParticles.Cells[Ord(pdRow),0] := rsRow;
  sgMOC3DParticles.Cells[Ord(pdColumn),0] := rsColumn;
  for RowIndex := 1 to sgMOC3DParticles.RowCount - 1 do
  begin
    sgMOC3DParticles.Cells[Ord(pdN),RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgMOC3DTransParam
  sgMOC3DTransParam.Cells[Ord(trdN),0] := rsN;
  sgMOC3DTransParam.Cells[Ord(trdLong),0] := rsLongDisp;
  sgMOC3DTransParam.Cells[Ord(trdTranHor),0] := rsTransHorDisp;
  sgMOC3DTransParam.Cells[Ord(trdTranVer),0] := rsTransVerDisp;
  sgMOC3DTransParam.Cells[Ord(trdRetard),0] := rsRetard;
  sgMOC3DTransParam.Cells[Ord(trdConc),0] := rsConc;
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    sgMOC3DTransParam.Cells[Ord(trdN),RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgFHBTimes
  sgFHBTimes.Cells[1,0] := 'Time';
  sgFHBTimes.Cells[1,1] := '0';
  for RowIndex := 1 to sgFHBTimes.RowCount - 1 do
  begin
    sgFHBTimes.Cells[0,RowIndex] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgZoneBudCompZones
  For RowIndex := 1 to sgZoneBudCompZones.RowCount do
  begin
    sgZoneBudCompZones.Cells[0,RowIndex-1] := IntToStr(RowIndex);
  end;

  // Initialize the titles of sgZondbudTimes
  sgZondbudTimes.ColCount := 3;
  For RowIndex := 1 to sgZondbudTimes.RowCount-1 do
  begin
    sgZondbudTimes.Cells[0,RowIndex] := IntToStr(RowIndex);
  end;
  sgZondbudTimes.Cells[0,0] := rsN;
  sgZondbudTimes.Cells[1,0] := rsStressPeriod;
  sgZondbudTimes.Cells[2,0] := rsTimeStep;

  // Initialize the titles of sgMODPATHOutputTimes
  For RowIndex := 1 to sgMODPATHOutputTimes.RowCount -1 do
  begin
    sgMODPATHOutputTimes.Cells[0,RowIndex] := IntToStr(RowIndex);
  end;
  sgMODPATHOutputTimes.Cells[1,0] := rsTime;
  sgMODPATHOutputTimes.Cells[0,0] := rsN;

  // Initialize the titles of dgGeol
  For RowIndex := 1 to dgGeol.RowCount -1 do
  begin
    dgGeol.Cells[0,RowIndex] := IntToStr(RowIndex);
  end;
  For ColIndex := 0 to dgGeol.ColCount -1 do
  begin
    dgGeol.Cells[ColIndex,0] := dgGeol.Columns[ColIndex].Title.Caption;
  end;
end;

Function TfrmMODFLOW.CBoundNeeded (GeolUnit : Integer) : boolean;
var
  GridLayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE;
//  SubGridHandle : ANE_PTR;
  SubGridLayer : T_ANE_MapsLayer;
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
        GetGrid(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
          GridLayerHandle,  NRow, NCol,
          MinX, MaxX, MinY, MaxY, GridAngle);

        result := ((GeolUnit = StrToInt(adeMOC3DLay1.Text) -1)  or
                    ((GeolUnit = StrToInt(adeMOC3DLay2.Text) +1)
                     and not (StrToInt(adeMOC3DLay2.Text) = -1)) or
                     not ((fMOCROW1(CurrentModelHandle, GridLayerHandle, NRow) = 1) and
                          (fMOCROW2(CurrentModelHandle, GridLayerHandle, NRow) = NRow) and
                          (fMOCCOL1(CurrentModelHandle, GridLayerHandle, NCol) = 1) and
                          (fMOCCOL2(CurrentModelHandle, GridLayerHandle, NCol) = NCol)) );
      end;
    end;
  end;
end;

Procedure TfrmMODFLOW.AssociateUnits;
var
  GeolUnitIndex : Integer;
  AGeologicUnit : T_ANE_IndexedLayerList;
  AParameterList : TList;
  ParameterListIndex, ParameterIndex : integer;
  AParamList : T_ANE_IndexedParameterList;
begin
  // called by edNumUnitsExit;
  // called by btnInsertUnitClick
  // called by btnDeleteUnitClick
  // called by GProjectNew in ProjectFunctions
  // called by GLoadForm in ProjectFunctions
  // called by btnOpenValClick

  // Free the list of layer-lists and the list of parameter-lists
  GeologicUnitsList.Free;
  GeologicUnitParametersList.Free;

  // create a new list of layer-lists
  GeologicUnitsList := TList.Create;

  // Add geologic units whose status is not sDeleted to te list of layer-lists
  for GeolUnitIndex := 0 to StrToInt(edNumUnits.Text) -1 do
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
  for ParameterListIndex := 0 to GeologicUnitParametersList.Count -1 do
  begin
    AParameterList := GeologicUnitParametersList.Items[ParameterListIndex];

    if (ParameterListIndex < MaxObsWellLayers) then
    begin
      for ParameterIndex := AParameterList.Count -1 downto 0 do
      begin
        AParamList := AParameterList.Items[ParameterIndex];
        if (AParamList is ModflowTypes.GetMOCElevParamListType) or
           (AParamList is ModflowTypes.GetMFFHBPointTimeParamListType) or
           (AParamList is ModflowTypes.GetMFFHBLineTimeParamListType) or
           (AParamList is ModflowTypes.GetMFFHBAreaTimeParamListType) or
           (AParamList is ModflowTypes.GetMFMODPATHTimeParamListType)
        then
        begin
          AParameterList.Delete(ParameterIndex);
        end;
      end;
    end;
  end;
end;

Procedure TfrmMODFLOW.AssociateTimes;
Var
  ListOfParameterLists  : TList;
  AParameterList : TList ;
  ParameterListIndex : integer;
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
  // sgTime grid.

  // First get rid of all the existing lists of parameter lists.
  for ParameterListIndex := 1 to sgTime.RowCount -1 do
  begin
    AParameterList := sgTime.Objects[0, ParameterListIndex] as TList;
    AParameterList.Free;
    sgTime.Objects[0, ParameterListIndex] := nil;
  end;

  // create new lists of parameter-lists.
  ListOfParameterLists
    := MFLayerStructure.MakeParameter2Lists(StrToInt(edNumPer.Text));

  // put those lists in the objects property of sgTime
  for ParameterListIndex := 0 to ListOfParameterLists.Count -1 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    sgTime.Objects[0, ParameterListIndex + 1] := AParameterList;
  end;

  // get rid of the list of parameter-lists.
  ListOfParameterLists.Free;
end;

Procedure TfrmMODFLOW.InsertTimeParameters (Position : integer) ;
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
    if cbRCH.Checked and cbMOC3D.Checked then
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

    // create the time parameters at Position for the
    // well layers
    if cbWEL.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFWellLayerType,
        ModflowTypes.GetMFWellTimeParamListType, Position);
    end;

    // create the time parameters at Position for the
    // river layers
    if cbRIV.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFLineRiverLayerType,
        ModflowTypes.GetMFRiverTimeParamListType, Position);

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaRiverLayerType,
        ModflowTypes.GetMFRiverTimeParamListType, Position);
    end;

    // create the time parameters at Position for the
    // drain layers
    if cbDRN.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetLineDrainLayerType,
        ModflowTypes.GetMFDrainTimeParamListType, Position);

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetAreaDrainLayerType,
        ModflowTypes.GetMFDrainTimeParamListType, Position);
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

      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetAreaGHBLayerType,
        ModflowTypes.GetGHBTimeParamListType, Position);
    end;


    // create the time parameters at Position for the
    // stream layers
    if cbSTR.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFStreamLayerType,
        ModflowTypes.GetMFStreamTimeParamListType, Position);
    end;

{    if cbMOC3D.Checked and cbDualPorosity.Checked and (cbIDPTIM_Decay.Checked or cbIDPTIM_Growth.Checked) then
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
    end;    }
{    if cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKTIM.Checked then
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

    end;  }

end;

procedure TfrmMODFLOW.FormCreate(Sender: TObject);
var
  RowIndex, ColIndex : integer;
  fileName : string;
  OldGeolGrid : TSpecialHandlingObject;
  OldIDIREC : TSpecialHandlingObject;
  EPSSLV : TSpecialHandlingObject;
  CTHOCH : TSpecialHandlingObject;
  TimeVarDoublePorosity, TimeVarReactions : TSpecialHandlingObject;
//  FullPath : string;
//  AnInt : NewUnitData;
//  newDataGrid : TSpecialHandlingObject;
begin
  // triggering events: frmMODFLOW.OnCreate;
  inherited;
//  AnInt := ;
  Loading := True;

  PIEDeveloper := 'Richard B. Winston, rbwinst@usgs.gov';

  VersionInfo1.FileName := DllName;
  lblVersion.Caption := VersionInfo1.FileVersion;

  OldVersionControlName.Add('verLabel');


  NewModel := False;
  NeedToUpdateMOC3DSubgrid := False;

  SpecialHandlingList := TSpecialHandlingList.Create;

  OldGeolGrid := TSpecialHandlingObject.Create('dtabGeol',ReadOldGeoData);
  SpecialHandlingList.Add(OldGeolGrid);

  OldIDIREC := TSpecialHandlingObject.Create('adeMOCDirInd',ReadOldIDIREC);
  SpecialHandlingList.Add(OldIDIREC);

  EPSSLV := TSpecialHandlingObject.Create('adeMOCTolerance',ReadEPSSLV);
  SpecialHandlingList.Add(EPSSLV);

  CTHOCH :=  TSpecialHandlingObject.Create('adeMiscOption',ReadCTOCH);
  SpecialHandlingList.Add(CTHOCH);

  TimeVarDoublePorosity :=  TSpecialHandlingObject.Create('cbIDPTIM',ReadOld_IDPTIM);
  SpecialHandlingList.Add(TimeVarDoublePorosity);

  TimeVarReactions :=  TSpecialHandlingObject.Create('cbIDKTIM',ReadOld_IDKTIM);
  SpecialHandlingList.Add(TimeVarReactions);

  // assign the function used to get the version of the PIE.
  GetVersion := GetPIEVersion ;

  // assign the function used to determine whether the file that is
  // being read was created by a newer version of the PIE than the
  // PIE that is reading it.
  EarlierVersionInPIE := PieIsEarlier ;

  // Check that the DLL name is found.
  if not GetDllFullPath(DLLName, fileName) then
  begin
    Beep;
    MessageDlg(fileName + ' not found.',mtError, [mbOK], 0);
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
  IgnoreList.Add('cbExpRCH');
  IgnoreList.Add('cbExpRIV');
  IgnoreList.Add('cbExpWEL');
  IgnoreList.Add('cfExpDRN');
  IgnoreList.Add('cbExpGHB');
  IgnoreList.Add('cbExpEVT');
  IgnoreList.Add('cbExpHFB');
  IgnoreList.Add('cbExpFHB');
  IgnoreList.Add('cbExpMatrix');
  IgnoreList.Add('cbExpCONC');
  IgnoreList.Add('cbExpOBS');
  IgnoreList.Add('cbExpStr');
  IgnoreList.Add('cbShowWarnings');
  IgnoreList.Add('cbProgressBar');

  // Also the list of references on the About tab is not saved.
  IgnoreList.Add('memoReferences');

  // When reading a file, those controls whos names are on FirstList will
  // be read first. This is done because in a few cases, the order in which
  // data is read is important.
  FirstList := TStringList.Create;
  FirstList.Add('edNumUnits');
  FirstList.Add('edNumPer');
  FirstList.Add('edMOC3DInitParticles');
  FirstList.Add('adeFHBNumTimes');

  // Initialize data in dgGeol

  dgGeol.Cells[Ord(nuiName),1] := 'Top Aquifer';
  dgGeol.Cells[Ord(nuiName),2] := 'Aquitard';
  dgGeol.Cells[Ord(nuiName),3] := 'Bottom Aquifer';

  dgGeol.Cells[Ord(nuiSim),1] := 'Yes';
  dgGeol.Cells[Ord(nuiSim),2] := 'No';
  dgGeol.Cells[Ord(nuiSim),3] := 'Yes';

  dgGeol.Cells[Ord(nuiTrans),1] := 'Harmonic mean (0)';
  dgGeol.Cells[Ord(nuiTrans),2] := 'Harmonic mean (0)';
  dgGeol.Cells[Ord(nuiTrans),3] := 'Harmonic mean (0)';

  dgGeol.Cells[Ord(nuiType),1] := 'Confined (0)';
  dgGeol.Cells[Ord(nuiType),2] := 'Confined (0)';
  dgGeol.Cells[Ord(nuiType),3] := 'Confined (0)';

  dgGeol.Cells[Ord(nuiAnis),1] := '1';
  dgGeol.Cells[Ord(nuiAnis),2] := '1';
  dgGeol.Cells[Ord(nuiAnis),3] := '1';

  dgGeol.Cells[Ord(nuiVertDisc),1] := '1';
  dgGeol.Cells[Ord(nuiVertDisc),2] := '1';
  dgGeol.Cells[Ord(nuiVertDisc),3] := '1';

  // initialize data in sgTime
  for ColIndex := 1 to sgTime.ColCount - 1 do
  begin
    sgTime.Cells[ColIndex,1] := '1';
  end;

  // initialize data in sgMOC3DParticles
  for ColIndex := 1 to sgMOC3DParticles.ColCount - 1 do
  begin
    sgMOC3DParticles.Cells[ColIndex,1] := '0';
  end;

  // initialize data in sgMOC3DTransParam
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    for ColIndex := 1 to sgMOC3DTransParam.ColCount - 1 do
    begin
      sgMOC3DTransParam.Cells[ColIndex,RowIndex] := '0';
    end;
  end;

  // initialize data in sgMOC3DTransParam
  for RowIndex := 1 to sgMOC3DTransParam.RowCount - 1 do
  begin
    sgMOC3DTransParam.Cells[Ord(trdRetard),RowIndex] := '1';
  end;

  // initialize data in sgFHBTimes
  for RowIndex := 1 to sgFHBTimes.RowCount - 1 do
  begin
    sgFHBTimes.Cells[1,RowIndex] := '0';
  end;

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
  comboGhbSteady.ItemIndex := 1;
  comboEvtSteady.ItemIndex := 1;
  comboEvtOption.ItemIndex := 0;

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

  comboFHBSteadyStateOption.ItemIndex := 1;

  comboMODPATH_RechargeITOP.ItemIndex := 1;
  comboMODPATH_EvapITOP.ItemIndex := 1;

  comboMPATHStartTimeMethod.ItemIndex := 1;
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

  comboSteadyChange(Sender);

  // initialize data in sgMODPATHOutputTimes
  for RowIndex := 1 to sgMODPATHOutputTimes.RowCount - 1 do
  begin
    sgMODPATHOutputTimes.Cells[1,RowIndex] := '0';
  end;

  // initialize the maximum allowable values of the MOC3D subgrid layers.
  adeMOC3DLay1.Max := StrToInt(edNumUnits.Text);
  adeMOC3DLay2.Max := adeMOC3DLay1.Max ;

  rgSolMethClick(Sender);
  // Make sure that IAPART is set properly.
  dgGeolExit(nil);
  // Initialize the titles of all the grids.
  InitializeGrids;

end;

procedure TfrmMODFLOW.comboWetCapChange(Sender: TObject);
var
  WettingActive : boolean;
begin
  // triggering event: comboWetCap.OnChange;
  inherited;

  // Show a warning if the rewetting option and MOC3D are both selected.
  Moc3dWetWarning;
  // enable or disable other controls depending on whether or not
  // the wetting capability is active.
  WettingActive := (comboWetCap.ItemIndex = 1);
  adeWettingFact.Enabled := WettingActive; // wetting factor
  adeWetIterations.Enabled := WettingActive;  // wetting iterations
  comboWetEq.Enabled := WettingActive;  // wetting equation.
  SetComboColor(comboWetEq);
end;

procedure TfrmMODFLOW.cbRCHClick(Sender: TObject);
begin
  // triggering event: cbRCH.OnClick;
  inherited;

  // enable or disable other controls depending on whether recharge is active.
  comboRchSteady.Enabled := cbRCH.Checked; // steady recharge
  SetComboColor(comboRchSteady);

  comboRchOpt.Enabled := cbRCH.Checked;  // recharge option
  SetComboColor(comboRchOpt);

  cbRCHRetain.Enabled := cbRCH.Checked;  // recharge option
  cbRechLayer.Enabled := cbRCH.Checked and (comboRchOpt.ItemIndex = 1);

  // cell-by-cell flows related to recharge
  cbFlowRCH.Enabled := cbRCH.Checked;

  // read or reuse recharge concentrations in MOC3D.
  comboMOC3DReadRech.Enabled := cbRCH.Checked and cbMOC3D.Checked;
  SetComboColor(comboMOC3DReadRech);

  // location of MODPATH particles for recharge
  comboMODPATH_RechargeITOP.Enabled := cbRCH.Checked and cbMODPATH.Checked;
  SetComboColor(comboMODPATH_RechargeITOP);

  // add or remove the recharge layer depending on whether recharge
  // is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetRechargeLayerType, cbRCH.Checked);

  // add or remove the recharge concentration layer depending on whether
  // recharge and MOC3D are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCRechargeConcLayerType, cbRCH.Checked
     and cbMOC3D.Checked);

  // add or remove the recharge elevation parameter from the grid layer
  // depending on whether recharge is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRechElevParamType,
     cbRCH.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbRIVClick(Sender: TObject);
begin
  // triggering event: cbRIV.OnClick;
  inherited;

  // enable or disable other controls depending on whether recharge is active.
  comboRivSteady.Enabled := cbRIV.Checked; // steady stress
  SetComboColor(comboRivSteady);

  cbRIVRetain.Enabled := cbRIV.Checked; // steady stress

  cbAltRiv.Enabled := cbRIV.Checked;

  // cell-by-cell flows related to rivers
  cbFlowRiv.Enabled := cbRIV.Checked;

  // add or remove the line river layer
  // depending on whether rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineRiverLayerType, cbRIV.Checked);

  // add or remove the area river layers
  // depending on whether rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaRiverLayerType, cbRIV.Checked);

  // add or remove the river grid-layer parameters
  // depending on whether rivers are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRiverParamType,
     cbRIV.Checked);

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
     cbMOC3D.Checked and cbRiv.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbWELClick(Sender: TObject);
begin
  // triggering event: cbWEL.OnClick;
  inherited;

  // enable or disable other controls depending on whether wells are active.
  comboWelSteady.Enabled := cbWEL.Checked;  // steady stress
  SetComboColor(comboWelSteady);

  cbWELRetain.Enabled := cbWEL.Checked;  // steady stress

  // cell-by-cell flows related to wells
  cbFlowWel.Enabled := cbWEL.Checked;

  // add or remove well layers
  // depending on whether wells are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFWellLayerType, cbWEL.Checked);

  // add or remove grid well parameter from the grid layer
  // depending on whether wells are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridWellParamType,
     cbWEL.Checked);

  // add or remove concentration parameter from the well layer
  // depending on whether wells and MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbWel.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbDRNClick(Sender: TObject);
begin
  // triggering event: cbDRN.OnClick;
  inherited;

  // enable or disable other controls depending on whether drains are active.
  comboDrnSteady.Enabled := cbDRN.Checked;   // steady stress
  SetComboColor(comboDrnSteady);

  cbDRNRetain.Enabled := cbDRN.Checked;
  cbAltDrn.Enabled := cbDRN.Checked;

  // cell-by-cell flows related to drains
  cbFlowDrn.Enabled := cbDRN.Checked;

  // add or remove drain layers
  // depending on whether wells are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetLineDrainLayerType, cbDRN.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetAreaDrainLayerType, cbDRN.Checked);

  // add or remove grid drain parameter from the grid layer
  // depending on whether wells are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridDrainParamType,
     cbDRN.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbGHBClick(Sender: TObject);
begin
  // triggering event: cbGHB.OnClick;
  inherited;

  // enable or disable other controls depending on whether
  // general-head boundaries are active.
  comboGhbSteady.Enabled := cbGHB.Checked;    // steady stress
  SetComboColor(comboGhbSteady);

  cbGHBRetain.Enabled := cbGHB.Checked;
  cbAltGHB.Enabled := cbGHB.Checked;

  // cell-by-cell flows related to general-head boundaries
  cbFlowGHB.Enabled := cbGHB.Checked;

  // add or remove general-head boundary layers
  // depending on whether general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetPointGHBLayerType, cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetLineGHBLayerType, cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetAreaGHBLayerType, cbGHB.Checked);

  // add or remove grid general-head boundary parameters from the grid layer
  // depending on whether general-head boundaries are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridGHBParamType,
     cbGHB.Checked);

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
     cbMOC3D.Checked and cbGHB.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbEVTClick(Sender: TObject);
begin
  // triggering event: cbEVT.OnClick;
  inherited;

  // enable or disable other controls depending on whether
  // evapotranspiration is active.
  comboEvtSteady.Enabled := cbEVT.Checked; // steady stress
  SetComboColor(comboEvtSteady);

  comboEvtOption.Enabled := cbEVT.Checked ; // evapotranspiration option
  SetComboColor(comboEvtOption);

  cbEVTRetain.Enabled := cbEVT.Checked ; // evapotranspiration option
  cbETLayer.Enabled := cbEVT.Checked and (comboEvtOption.ItemIndex = 1);

  // cell-by-cell flows related to evapotranspiration
  cbFlowEVT.Enabled := cbEVT.Checked;

  // location of MODPATH particles for evapotranspiration
  comboMODPATH_EvapITOP.Enabled := cbEVT.Checked and cbMODPATH.Checked;
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

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.comboExportHeadChange(Sender: TObject);
begin
  // triggering event: comboExportHead.OnChange;
  inherited;

  // if you are going to export the head, you can pick the frequency
  // at which it is exported. Otherwise, you can't pick the frequency.
  comboHeadExportFreq.Enabled := not (comboExportHead.ItemIndex = 0);
  SetComboColor(comboHeadExportFreq);

  comboHeadExportFreqChange(Sender);

  // If you are goint to export heads every N'th time step, you
  // can specify N.
  comboHeadPrintFreq.Enabled := not (comboExportHead.ItemIndex = 0);
  SetComboColor(comboHeadPrintFreq);

  comboHeadPrintFreqChange(Sender);

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
    (cbFlowBCF.Checked
    or (cbFlowRCH.Checked and cbRCH.Checked)
    or (cbFlowDrn.Checked and cbDRN.Checked)
    or (cbFlowGHB.Checked and cbGHB.Checked)
    or (cbFlowRiv.Checked and cbRIV.Checked)
    or (cbFlowWel.Checked and cbWEL.Checked)
    or (cbFlowEVT.Checked and cbEVT.Checked)
    or (cbFlowFHB.Checked and cbFHB.Checked)
    or (cbFlowSTR.Checked and cbSTR.Checked)
    or (cbFlowSTR2.Checked and cbSTR.Checked));

  if cbMODPATH.Checked or cbZonebudget.Checked then
  begin
    if not Loading and ((comboBudExportFreq.ItemIndex <> 1)
      or (adeBudExportFreq.Text <> '1')) then
    begin
      Beep;
      MessageDlg('You will need to re-run MODFLOW before running MODPATH or'
        + ' ZONEBDGT.', mtInformation, [mbOK], 0);
    end;
    comboBudExportFreq.ItemIndex := 1;
    adeBudExportFreq.Text := '1';
  end;

  SetComboColor(comboBudExportFreq);

  // If you are goint to export flows every N'th time step, you
  // can specify N.
  adeBudExportFreq.Enabled := (comboBudExportFreq.ItemIndex = 1)
    and comboBudExportFreq.Enabled;

  if cbFlowSTR.Checked then
  begin
    cbStrPrintFlows.Checked := False;
  end;

end;

procedure TfrmMODFLOW.rgSolMethClick(Sender: TObject);
begin
  // triggering event: rgSolMeth.OnClick;
  inherited;

  // make the tab visible that corresponds to the selected solution method.
  // hide all the other tabs.
{  tabSip.TabVisible := (rgSolMeth.ItemIndex = 0);
  tabDE4.TabVisible := (rgSolMeth.ItemIndex = 1);
  tabPCG2.TabVisible := (rgSolMeth.ItemIndex = 2);
  tabSOR.TabVisible := (rgSolMeth.ItemIndex = 3);  }

  case rgSolMeth.ItemIndex of
    0:
      begin
        PageControlSolvers.ActivePage := tabSip;
      end;
    1:
      begin
        PageControlSolvers.ActivePage := tabDE4;
      end;
    2:
      begin
        PageControlSolvers.ActivePage := tabPCG2;
      end;
    3:
      begin
        PageControlSolvers.ActivePage := tabSOR;
      end;
  end;
end;

procedure TfrmMODFLOW.comboHeadPrintFreqChange(Sender: TObject);
begin
  // triggering events: comboHeadPrintFreq.OnChange;
  inherited;

  // if you are going to print heads every N'th time step,
  // you can specify N.
  adeHeadPrintFreq.Enabled := (comboHeadPrintFreq.ItemIndex = 1)
    and comboHeadPrintFreq.Enabled;

  comboHeadPrintStyle.Enabled := (comboHeadPrintFreq.ItemIndex > 0)
    and comboHeadPrintFreq.Enabled;
  SetComboColor(comboHeadPrintStyle);

  comboHeadPrintFormat.Enabled := comboHeadPrintStyle.Enabled;
  SetComboColor(comboHeadPrintFormat);

end;

procedure TfrmMODFLOW.comboDrawdownPrintFreqChange(Sender: TObject);
begin
  // triggering events: comboDrawdownPrintFreq.OnChange;
  inherited;

  // if you are going to print drawdown every N'th time step,
  // you can specify N.
  adeDrawdownPrintFreq.Enabled := (comboDrawdownPrintFreq.ItemIndex = 1)
    and comboDrawdownPrintFreq.Enabled;

  comboDrawdownPrintStyle.Enabled := (comboDrawdownPrintFreq.ItemIndex > 0)
    and comboDrawdownPrintFreq.Enabled;
  SetComboColor(comboDrawdownPrintStyle);

  comboDrawdownPrintFormat.Enabled := comboDrawdownPrintStyle.Enabled;
  SetComboColor(comboDrawdownPrintFormat);
end;

procedure TfrmMODFLOW.comboBudPrintFreqChange(Sender: TObject);
begin
  // triggering events: comboBudPrintFreq.OnChange;
  inherited;

  // if you are going to print the volumetric budget every N'th time step,
  // you can specify N.
  adeBudPrintFreq.Enabled := (comboBudPrintFreq.ItemIndex = 1);

end;

procedure TfrmMODFLOW.comboHeadExportFreqChange(Sender: TObject);
begin
  // triggering events: comboHeadExportFreq.OnChange;
  inherited;

  // if you are going to exaport heads every N'th time step,
  // you can specify N.
  adeHeadExportFreq.Enabled := (comboHeadExportFreq.ItemIndex = 1)
    and comboHeadExportFreq.Enabled;
end;

procedure TfrmMODFLOW.comboDrawdownExportFreqChange(Sender: TObject);
begin
  // triggering events: comboDrawdownExportFreq.OnChange;
  inherited;

  // if you are going to exaport drawdown every N'th time step,
  // you can specify N.
  adeDrawdownExportFreq.Enabled := (comboDrawdownExportFreq.ItemIndex = 1)
    and comboDrawdownExportFreq.Enabled;

end;

procedure TfrmMODFLOW.comboBudExportFreqChange(Sender: TObject);
begin
  // triggering events: comboBudExportFreq.OnChange;
  inherited;

  // if you are going to exaport flows every N'th time step,
  // you can specify N.
  adeBudExportFreq.Enabled := (comboBudExportFreq.ItemIndex = 1)
    and comboBudExportFreq.Enabled;

end;

procedure TfrmMODFLOW.cbMOC3DClick(Sender: TObject);
begin
  // triggering event: cbMOC3D.OnClick;
  inherited;
  // Show a warning if the rewetting option and MOC3D are both selected.
  Moc3dWetWarning;

  // Show a warning if the stream and MOC3D are both selected.
  StreamWarning;
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

  // Make the MOC3D tabs visible or hidden
  // depending on whether MOC3D is selected.

  tabMOC3DParticles.TabVisible := cbMOC3D.Checked;
  tabMOC3DOut.TabVisible := cbMOC3D.Checked;

//  The following line will need to be activated for some yet unpublished
//  packages.
//  tabAgeDpDk.TabVisible := cbMOC3D.Checked;

  adeMOC3DLay1.Enabled := cbMOC3D.Checked;
  adeMOC3DLay2.Enabled := cbMOC3D.Checked;
  cbMOC3DNoDisp.Enabled := cbMOC3D.Checked;
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

  // allow the user to assign weight to concentrations in the FHB
  // package if both it and MOC3D are selected.
  adeFHBHeadConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;
  adeFHBFluxConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;

  rgMOC3DSolver.Enabled := cbMOC3D.Checked;
  rgMOC3DSolverClick(Sender);

  // add or remove the observation wells layer depending on
  // whether MOC3D are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCTransSubGridLayerType, cbMOC3D.Checked);

  // add or remove the recharge concentration layer depending on
  // whether MOC3D and Recharge are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCRechargeConcLayerType,
     cbRCH.Checked and cbMOC3D.Checked);

  // add or remove the observation wells layer depending on
  // whether MOC3D are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCObsWellLayerType, cbMOC3D.Checked);

  // add or remove the initial concentration layers depending on
  // whether MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCInitialConcLayerType, cbMOC3D.Checked);

  // add or remove the particle regenerations layers depending on
  // whether MOC3D are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCParticleRegenLayerType, cbMOC3D.Checked);

  // add or remove the porosity layers depending on
  // whether MOC3D or MODPATH are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMOCPorosityLayerType,
     cbMOC3D.Checked or cbMODPATH.Checked);

  // add or remove the initial concentration parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCInitConcParamType,
     cbMOC3D.Checked);

  // add or remove the MOC3D subgrid parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCSubGridParamType,
     cbMOC3D.Checked);

  // add or remove the MOC3D particle regeneration parameters on the grid layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetMFGridMOCParticleRegenParamType, cbMOC3D.Checked);

  // add or remove the MOC3D porosity parameters on the grid layer
  // depending on whether MOC3D or MODPAHT are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCPorosityParamType,
     cbMOC3D.Checked or cbMODPATH.Checked);

  // add or remove the concentration parameters on the prescribed layer
  // depending on whether MOC3D is selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetPrescribedHeadLayerType,
     ModflowTypes.GetMFConcentrationParamType, cbMOC3D.Checked);

  // add or remove the concentration parameters on the well layer
  // depending on whether MOC3D and wells are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbWel.Checked);

  // add or remove the concentration parameters on the line river layer
  // depending on whether MOC3D and rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
     ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbRiv.Checked);

  // add or remove the concentration parameters on the area river layer
  // depending on whether MOC3D and rivers are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
     ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbRiv.Checked);

  // add or remove the concentration parameters on the
  // point general-head boundary layers
  // depending on whether MOC3D and general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
     ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbGHB.Checked);

  // add or remove the concentration parameters on the
  // line general-head boundary layers
  // depending on whether MOC3D and general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
     ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbGHB.Checked);

  // add or remove the concentration parameters on the
  // area general-head boundary layers
  // depending on whether MOC3D and general-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
     ModflowTypes.GetMFConcentrationParamType,
     cbMOC3D.Checked and cbGHB.Checked);

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
     cbMOC3D.Checked and cbFHB.Checked);

  // add or remove the flux concentration parameters on the
  // area flow-and-head boundary layers
  // depending on whether MOC3D and flow-and-head boundaries are selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetMFAreaFHBLayerType,
     ModflowTypes.GetMFFHBFluxConcParamType,
     cbMOC3D.Checked and cbFHB.Checked);

  cbDualPorosityClick(Sender);
  cbSimpleReactionsClick(Sender);

  // associates lists of time-related parameters with sgTime grid.
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

  rgMOC3DConcFormat.Enabled := not (comboMOC3DConcFileType.ItemIndex = 0);

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
  comboMOC3DPartFreq.Enabled := not (comboMOC3DPartFileType.ItemIndex = 0);
  SetComboColor(comboMOC3DPartFreq);

  // Determine whether you can set N.
  comboMOC3DPartFreqChange(Sender);
end;

procedure TfrmMODFLOW.sgMOC3DTransParamSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  // triggering events: sgMOC3DTransParam.OnSelectCell;
  inherited;
   PrevMOC3DTransParam := sgMOC3DTransParam.Cells[Col,Row];
  // Determine which cells will be editable.
  // The first row and column need no special treatment.
  if (Row > 0) and (Col > 0) then
  begin
    // If this is the concentration column and you don't need CBOUND
    // then don't allow editting.
    if (Col = Ord(trdConc)) and not CBoundNeeded(Row)
    then
      begin
        sgMOC3DTransParam.Options := sgMOC3DTransParam.Options - [goEditing];
//        CanSelect := False;
      end
    else if ((Col = Ord(trdLong)) or (Col = Ord(trdTranHor)) or (Col = Ord(trdTranVer)))
             and cbMOC3DNoDisp.Checked then
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
    if (Col = Ord(trdConc)) and not CBoundNeeded(Row)
    then
      begin
        sgMOC3DTransParam.Canvas.Brush.Color := clBtnFace;
      end
    else if ((Col = Ord(trdLong)) or (Col = Ord(trdTranHor)) or (Col = Ord(trdTranVer)))
             and cbMOC3DNoDisp.Checked then
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
          if (Row = sgMOC3DTransParam.Selection.Top)
          then
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
          if (Col = Ord(trdConc)) and CBoundNeeded(Row)
          then
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
      (Rect,Rect.Left,Rect.Top,sgMOC3DTransParam.Cells[Col,Row]);
    // draw the right and lower cell boundaries in black.
    sgMOC3DTransParam.Canvas.Pen.Color := clBlack;
    sgMOC3DTransParam.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgMOC3DTransParam.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgMOC3DTransParam.Canvas.LineTo(Rect.Left,Rect.Bottom);
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
  NewNumUnits : integer;
  RowIndex, ColIndex : integer;
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
      adeMOC3DLay2.Max := adeMOC3DLay1.Max ;

      // update the number of units used by MOC3D.
      adeMOC3DLayerExit(Sender);

      // If the new number of units is > 0 proceed, otherwise
      // handle the error.
      if NewNumUnits >0
      then
        begin
          // change the number of rows in sgMOC3DTransParam to reflect the
          // new number of units
          sgMOC3DTransParam.RowCount := NewNumUnits + 1;

          // If the new number of units is greater than the previous number
          // of units, add more units, otherwise, delete some units.
          If NewNumUnits > PrevNumUnits
          then
            begin
              // increase the number of rows in dtabGeol to reflect the new
              // number of units.
//              dtabGeol.RowSet.Count := NewNumUnits ;
              dgGeol.RowCount := NewNumUnits + 1;

              // Copy data into the new cells in dtabGeol.
              For RowIndex := PrevNumUnits  to NewNumUnits -1 do
              begin
{                For ColIndex := 0 to dtabGeol.ColumnSet.Count -1 do
                begin
                  dtabGeol.CellSet.Item[RowIndex,ColIndex].Value
                    := dtabGeol.CellSet.Item[RowIndex-1,ColIndex].Value;
                end; }

                dgGeol.Cells[Ord(nuiN),RowIndex + 1] := IntToStr(RowIndex + 1);
                For ColIndex := 1 to dgGeol.ColCount -1 do
                begin
                  dgGeol.Cells[ColIndex,RowIndex + 1]
                    := dgGeol.Cells[ColIndex,RowIndex];
                end;


                // for each row of new cells, create a new geologic unit
                // at the end of the layer structure.
                if not (Sender = btnInsertUnit) then
                begin
                  CreateGeologicLayer(-1)
                end;

              end;

              // Copy data into the new cells in sgMOC3DTransParam.
              For RowIndex := PrevNumUnits + 1
                to sgMOC3DTransParam.RowCount -1 do
              begin
                sgMOC3DTransParam.Cells[Ord(trdN),RowIndex]
                  := IntToStr(RowIndex);
                For ColIndex := 1 to sgMOC3DTransParam.ColCount -1 do
                begin
                  sgMOC3DTransParam.Cells[ColIndex,RowIndex]
                    := sgMOC3DTransParam.Cells[ColIndex,RowIndex-1];
                end;
              end;
            end
          else // If NewNumUnits > PrevNumUnits
            begin
              // delete geologic units
              For RowIndex := PrevNumUnits  downto NewNumUnits +1  do
              begin
                  if not (Sender = btnDeleteUnit) then
                  begin
                    DeleteGeologicLayer(RowIndex-1);
                  end;
              end;
              // delete rows in dtabGeol.
//              dtabGeol.RowSet.Count := NewNumUnits ;
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
    end;
    LabelUnits(dgGeol);

  except on EConvertError do
    begin
      // check to make sure there is no conversion error. If there is one,
      // fix it.
      edNumUnits.Text := IntToStr(PrevNumUnits);
    end;
  end;
end;

procedure TfrmMODFLOW.edNumPerExit(Sender: TObject);
var
  NewNumPeriods : integer;
  RowIndex, ColIndex : integer;
begin
  // triggering event: edNumPer.OnExit;
  // called by btnInsertTimeClick
  // called by btnAddTimeClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;
  try
    begin
      // get the new number of periods
      NewNumPeriods := StrToInt(edNumPer.Text);
      if (PrevNumPeriods = 1) and (NewNumPeriods > 1) and not Loading
        and (comboSteady.ItemIndex = 1) then
      begin
        Beep;
        if MessageDlg('Do you wish to switch to a transient model?',
          mtInformation, [mbYes, mbNo], 0) = mrYes then
        begin
          comboSteady.ItemIndex := 0;
        end;
      end;

      // Check that the new number of periods is valid.
      if NewNumPeriods >0
      then
        begin
          // The maximum period that can be specified for MODPATH is
          // the new number of periods.
          adeModpathBeginPeriod.Max := NewNumPeriods;
          adeModpathEndPeriod.Max := NewNumPeriods;
          adeMPATHRefPeriod.Max := NewNumPeriods;

          // check if number of periods is greater than before.
          If NewNumPeriods > PrevNumPeriods
          then
            begin
              // set the number of rows in the time grid to the proper number.
              sgTime.RowCount := NewNumPeriods + 1;

              // copy data into the new rows.
              For RowIndex := PrevNumPeriods + 1 to sgTime.RowCount -1 do
              begin
                // label the first column of the new row
                sgTime.Cells[Ord(tdN),RowIndex] := IntToStr(RowIndex);

                // copy data from earlier row.
                For ColIndex := 1 to sgTime.ColCount -1 do
                begin
                  sgTime.Cells[ColIndex,RowIndex]
                    := sgTime.Cells[ColIndex,RowIndex-1];
                end;

                // unless you are inserting a new time step
                // add new time parameters.
                if not (Sender = btnInsertTime) then
                begin
                  InsertTimeParameters (-1);
                end;
              end;
            end
          else
            begin
              // The number of periods has declined.
              if not (Sender = btnDeleteTime) then
              begin
                // unless you are deleting a specific time step
                // delete the time parameters for the rows that are
                // being deleted
                For RowIndex := sgTime.RowCount -1 downto PrevNumPeriods + 1 do
                begin
                  DeleteTimeParameters (RowIndex);
                end;
              end;

              // set the number of rows to the correct number.
              sgTime.RowCount := NewNumPeriods + 1;
            end;
        end
      else
        begin
          // if the new number of periods is invalid, go back to
          // the previous number.
          edNumPer.Text := IntToStr(PrevNumPeriods);
          Beep;
        end;

      // if there are 2 or more time periods, you can delete time periods.
      btnDeleteTime.Enabled := (sgTime.RowCount > 2);

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
           and (sgTime.RowCount > 2);

      SetComboColor(comboFHBSteadyStateOption);
    end;
    LabelUnits(sgTime);
  except on EConvertError do
    begin
      // if the user enters a non-number, go back to the old version.
      edNumPer.Text := IntToStr(PrevNumPeriods);
      Beep;
    end;
  end;

end;

procedure TfrmMODFLOW.LabelUnits(AStringGrid : TStringGrid);
var
  RowIndex : integer;
begin
  for RowIndex := 1 to AStringGrid.RowCount -1 do
  begin
    AStringGrid.Cells[0,RowIndex] := IntToStr(RowIndex);
  end;
end;

procedure TfrmMODFLOW.sgTimeDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // triggering event: sgTime.OnDrawCell;
  inherited;

  // You only need to draw the cell if it is a call that is not in a
  // fixed row or column
  if (Row > 0) and (Col > 0) then
  begin
    // The cell that displays the length of the first step is always gray.
    if Col = Ord(tdFirstStep)
    then
      begin
        sgTime.Canvas.Brush.Color := clBtnFace;
      end
    // if the cell is selected make it aqua
    // otherwise make it gray.
    else if (Row = sgTime.Selection.Top)
    then
      begin
        sgTime.Canvas.Brush.Color := clAqua;
      end
    else
      begin
        sgTime.Canvas.Brush.Color := clWindow;
      end;
    // set the font color
    sgTime.Canvas.Font.Color := clBlack;
    // draw the text
    sgTime.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgTime.Cells[Col,Row]);
    // draw the right and lower cell boundaries in black.
    sgTime.Canvas.Pen.Color := clBlack;
    sgTime.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgTime.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgTime.Canvas.LineTo(Rect.Left,Rect.Bottom);
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
  // triggering event: sgTime.OnSelectCell;
  inherited;

  // if the cell displays the length of the first time step,
  // don't allow editting. Otherwise, allow editting.
  if Col = Ord(tdFirstStep)
  then
    begin
//      sgTime.Options := sgTime.Options - [goEditing]
      CanSelect := False;
    end
  else
    begin
//      sgTime.Options := sgTime.Options + [goEditing]
      CanSelect := True;
    end;

  // redraw the grid to show the currently selected row.
  sgTime.Invalidate;

  // save the contents of the current cell so you can restore it if needed.
  LastTimeText := sgTime.Cells[Col, Row];
end;

procedure TfrmMODFLOW.btnMOC3DParticleAddClick(Sender: TObject);
begin
  // triggering events: btnMOC3DParticleAdd.OnClick;
  inherited;

  // Add new particles the same way a user would.

  // enter the edit box that has the current number.
  edMOC3DInitParticlesEnter(Sender);

  // increase the number in that box by 1.
  edMOC3DInitParticles.Text := IntToStr(StrToInt(edMOC3DInitParticles.Text)+1);

  // leave the edit box.
  edMOC3DInitParticlesExit(Sender);
end;

procedure TfrmMODFLOW.cbCustomParticleClick(Sender: TObject);
begin
  // triggering events: edMOC3DInitParticles.OnClick;
  inherited;

  // if the user chooses custom particle placement, enable
  // the appropriate grid.
  sgMOC3DParticles.Enabled := cbCustomParticle.Checked;
  // set the color the custom particle placement grid
  // depending on whether or not it is enabled.
  if sgMOC3DParticles.Enabled
  then
    begin
      sgMOC3DParticles.Color := clWindow;
    end
  else
    begin
      sgMOC3DParticles.Color := clInactiveBorder;
    end;
  // enable the add particle button when custom particle placement
  // is selected.
  btnMOC3DParticleAdd.Enabled := cbCustomParticle.Checked;

  // enable the delete particle button when custom particle placement
  // is selected and there is more than one particle.
  btnMOC3DParticleDelete.Enabled := cbCustomParticle.Checked
    and (sgMOC3DParticles.RowCount > 2);

  // make sure the custom particle grid contains all valid numbers.
  sgMOC3DParticlesExit(Sender);

  edMOC3DInitParticlesExit(Sender);
end;

procedure TfrmMODFLOW.btnMOC3DParticleDeleteClick(Sender: TObject);
Var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
begin
  // triggering events: btnMOC3DParticleDelete.OnClick;
  inherited;

  // confirm that the user wishes to delete the particle.
  Beep;
  if MessageDlg('Are you sure you wish to delete this particle?',
     mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
  begin
    // get the currently selected row.
    CurrentRow := sgMOC3DParticles.Selection.Top;

    // move data from later in the grid over the row containing
    // the data for the particle to be deleted
    for RowIndex := CurrentRow +1 to sgMOC3DParticles.RowCount -1 do
    begin
      For ColIndex := 1 to sgMOC3DParticles.ColCount -1 do
      begin
        sgMOC3DParticles.Cells[ColIndex,RowIndex-1]
          := sgMOC3DParticles.Cells[ColIndex,RowIndex];
      end;
    end;

    // decrease the number of rows in the particle grid by 1.
    sgMOC3DParticles.RowCount := sgMOC3DParticles.RowCount -1;

    // check that all cells contain valid numbers.
    sgMOC3DParticlesExit(Sender);

    // enable the delete particle button if there are more than 1 particle
    // and custon particle placement has been seledcted.
    btnMOC3DParticleDelete.Enabled := cbCustomParticle.Checked
      and (sgMOC3DParticles.RowCount > 2);

    // reduce the number of particles by 1.
    edMOC3DInitParticles.Text :=
      IntToStr(StrToInt(edMOC3DInitParticles.Text)-1);

  end;
end;

procedure TfrmMODFLOW.btnInsertUnitClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  PositionToInsert : integer;

  AGeologicUnit : T_ANE_IndexedLayerList;
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

  CurrentRow := dgGeol.Selection.Top;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  for RowIndex := dgGeol.RowCount -2 downto CurrentRow do
  begin
    // number the first column
    dgGeol.Cells[0,RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to dgGeol.ColCount -1 do
    begin
      dgGeol.Cells[ColIndex,RowIndex +1] := dgGeol.Cells[ColIndex,RowIndex];
    end;
    if (RowIndex +1 > 1) then
    begin
      if dgGeol.Cells[Ord(nuiType),RowIndex +1] = dgGeol.Columns[Ord(nuiType)].PickList[1] then
      begin
        dgGeol.Cells[Ord(nuiType),RowIndex +1] := dgGeol.Columns[Ord(nuiType)].PickList[3]
      end;
    end;
  end;



  //3. Determine where in the layer structure the new unit should be inserted.
  if CurrentRow = 0
  then
    begin
      PositionToInsert := 0;
    end
  else
    begin
      AGeologicUnit := GeologicUnitsList.Items[CurrentRow-1];
      PositionToInsert := MFLayerStructure.ListsOfIndexedLayers.
        IndexOf(AGeologicUnit as ModflowTypes.GetGeologicUnitType);
    end;

  //4. Create a new geologic unit at the correct position.
  CreateGeologicLayer(PositionToInsert);

  //5. Copy data in sgMOC3DTransParam that will follow the newly inserted
  // geologic unit to their new positions.
  for RowIndex := sgMOC3DTransParam.RowCount -2 downto CurrentRow do
  begin
    sgMOC3DTransParam.Cells[0,RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgMOC3DTransParam.ColCount -1 do
    begin
      sgMOC3DTransParam.Cells[ColIndex,RowIndex +1]
        := sgMOC3DTransParam.Cells[ColIndex,RowIndex];
    end;
  end;

  //6. make lists of the current geologic units.
  // This re-creates the GeologicUnitsList used in step 3.
  AssociateUnits;
end;

procedure TfrmMODFLOW.btnInsertTimeClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  PostionToInsert : integer;
  ListOfParameterLists  : TList;
  AnIndexedParameterList : T_ANE_IndexedParameterList;
begin
  // triggering event: btnInsertTime.OnClick;
  inherited;

  // first increase the number of periods by 1.
  edNumPerEnter(Sender);
  edNumPer.Text := IntToStr(StrToInt(edNumPer.Text) + 1);
  edNumPerExit(Sender);

  // get the current row.
  CurrentRow := sgTime.Selection.Top;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  for RowIndex := sgTime.RowCount -2 downto CurrentRow do
  begin
    // number the first column
    sgTime.Cells[0,RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to sgTime.ColCount -1 do
    begin
      sgTime.Cells[ColIndex,RowIndex +1] := sgTime.Cells[ColIndex,RowIndex];
    end;
  end;

  // enable delete button if there are at least two time periods.
  btnDeleteTime.Enabled := (sgTime.RowCount > 2);

  // get the list of time-related parameters for the currently selected
  // row.
  ListOfParameterLists := sgTime.Objects[0, CurrentRow] as TList;

  // determine where new time-related parameters should be inserted into
  // the layer structure.
  if ListOfParameterLists.Count > 0 then
  begin
    // for the first row, insert time related parameters at the beginning
    if CurrentRow = 1
    then
      begin
        PostionToInsert := 0
      end
    else
      begin
        // for other rows, get an indexed parameter list associated with
        // the current time step and
        // insert the new parameters after that one.
        AnIndexedParameterList := ListOfParameterLists.Items[0] ;
        PostionToInsert := AnIndexedParameterList.GetIndex +1;
      end;
    // create new time-related parameters at the position indicated by
    // PostionToInsert
    InsertTimeParameters (PostionToInsert);
  end;

  // associate all the time-related parameters with the object properties
  // of the first cell in each row of the time grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.btnDeleteUnitClick(Sender: TObject);
Var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  AGridRect : TGridRect;
begin
  // triggering event: btnDeleteUnit.OnClick;
  inherited;
  // Get the currently selected row in dtabGeol.
//  CurrentRow := dtabGeol.RowSet.GetSelect(-1);

  // get the currently selected fow.
  CurrentRow := dgGeol.Selection.Top;


  // If a row is selected in dtabGeol, proceed
  if CurrentRow >= 0 then
  begin
    // remove the currently selected row from dtabGeol
//    dtabGeol.RowSet.Remove(CurrentRow);

    // copy data from later time steps over the data for the time
    // step to be deleted.
{    for RowIndex := CurrentRow +1 to dgGeol.RowCount -1 do
    begin
      For ColIndex := 1 to dgGeol.ColCount -1 do
      begin
        dgGeol.Cells[ColIndex,RowIndex-1] := dgGeol.Cells[ColIndex,RowIndex];
      end;
    end; }
//    dgGeol.RowCount := dgGeol.RowCount -1;

    for RowIndex := 1 to dgGeol.RowCount -1 do
    begin
        dgGeol.Cells[0,RowIndex] := IntToStr(RowIndex);
    end;

    dgGeol.DeleteRow(CurrentRow);
    
    // Delete the geologic unit associated with the row that was just removed.
    DeleteGeologicLayer(CurrentRow-1);

    // Copy data in sgMOC3DTransParam to their new positions.
    for RowIndex := CurrentRow +1 to sgMOC3DTransParam.RowCount -1 do
    begin
      For ColIndex := 1 to sgMOC3DTransParam.ColCount -1 do
      begin
        sgMOC3DTransParam.Cells[ColIndex,RowIndex-1]
          := sgMOC3DTransParam.Cells[ColIndex,RowIndex];
      end;
    end;

    // decrease the number of rows in sgMOC3DTransParam to the correct number.
    sgMOC3DTransParam.RowCount := sgMOC3DTransParam.RowCount -1;

    // Change the number of units to the correct number.
//    edNumUnits.Text := IntToStr(dtabGeol.RowSet.Count);
    edNumUnits.Text := IntToStr(dgGeol.RowCount -1);

    // Disable the delete button if there is only one geologic unit left.
    // Otherwise, enable it.
//    btnDeleteUnit.Enabled := (dtabGeol.RowSet.Count > 1);
    btnDeleteUnit.Enabled := (dgGeol.RowCount > 2);

    //6. make lists of the current geologic units.
    AssociateUnits;
    if dgGeol.Selection.Top > dgGeol.RowCount-1 then
    begin
      AGridRect := dgGeol.Selection;
      AGridRect.Top := dgGeol.RowCount-1;
      dgGeol.Selection := AGridRect;
    end;
  end;
  LabelUnits(dgGeol);

end;

procedure TfrmMODFLOW.btnDeleteTimeClick(Sender: TObject);
Var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  NewNumPeriods : Integer;
begin
  // triggering event: btnDeleteTime.OnClick;
  inherited;

  // get the currently selected fow.
  CurrentRow := sgTime.Selection.Top;

  // copy data from later time steps over the data for the time
  // step to be deleted.
  for RowIndex := CurrentRow +1 to sgTime.RowCount -1 do
  begin
    For ColIndex := 1 to sgTime.ColCount -1 do
    begin
      sgTime.Cells[ColIndex,RowIndex-1] := sgTime.Cells[ColIndex,RowIndex];
    end;
  end;

  // get the new number of periods
  NewNumPeriods := StrToInt(edNumPer.Text) -1;

  // the maximum allowed period for MODPATH must be updated.
  adeModpathBeginPeriod.Max := NewNumPeriods;
  adeModpathEndPeriod.Max := NewNumPeriods;
  adeMPATHRefPeriod.Max := NewNumPeriods;

  // store the new number of periods
  edNumPer.Text := IntToStr(NewNumPeriods);

  // decrease the number of rows in the time grid by one.
  sgTime.RowCount := sgTime.RowCount -1;

  // enable the delete button if there are at least two time periods.
  btnDeleteTime.Enabled := (sgTime.RowCount > 2);

  // delete the time-related parameters for the current time step
  // from the layer structure
  DeleteTimeParameters (CurrentRow);

  // If you are using Flow-and-head boundaries, and you have multiple
  // steady state models, you can choose whether or not to interpolate
  // flow-and-head boundaries.
  comboFHBSteadyStateOption.Enabled
    := (comboSteady.ItemIndex = 1) and cbFHB.Checked
       and (sgTime.RowCount > 2);

  SetComboColor(comboFHBSteadyStateOption);

  LabelUnits(sgTime);

  // associate all the time-related parameters with the object properties
  // of the first cell in each row of the time grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.sgTimeSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
    PERLEN : double;
    TSMULT : double;
    NSTP : Integer;
//    FirstTimeStep : single;
begin
  // triggering event: sgTime.OnSetEditText;
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  inherited;
  try
    begin

      if (ACol > 0) and (ARow > 0) then
      begin
        // determine the length of the first time step and display it.
        PERLEN := StrToFloat( sgTime.Cells[Ord(tdLength), ARow]);
        TSMULT := StrToFloat( sgTime.Cells[Ord(tdMult), ARow]);
        NSTP := StrToInt( sgTime.Cells[Ord(tdNumSteps), ARow]);
        if TSMULT = 1
        then
          begin
            sgTime.Cells[Ord(tdFirstStep), ARow] := FloatToStrF(PERLEN/NSTP,
              ffGeneral, 7, 0 )
          end
        else
          begin
    //        FirstTimeStep := PERLEN*(TSMULT-1)/(IntPower(TSMULT,NSTP)-1);
            sgTime.Cells[Ord(tdFirstStep), ARow]
              := FloatToStrF(PERLEN*(TSMULT-1)/(IntPower(TSMULT,NSTP)-1),
                 ffGeneral, 7, 0 );
          end;
        LastTimeText := sgTime.Cells[ACol, ARow];
      end;
    end;
  except on EConvertError do
    begin
      // if the user enters bad data, revert to the old data.
      if not (sgTime.Cells[ACol, ARow] = '') then
      begin
        sgTime.Cells[ACol, ARow] := LastTimeText;
        Beep;
      end;
    end;
  end;

end;

procedure TfrmMODFLOW.sgMOC3DParticlesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  Position : double;
begin
  // triggering events: sgMOC3DParticles.OnSetEditText;
  inherited;

  // check that custom particle positions for MOC3D are valid.
  try
    begin
      if (ACol > 0) and (ARow > 0) then begin
        if not (Value = '') and not (Value = '-') then
        begin
          Position := StrToFloat(Value);
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
  Except On EConvertError do
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
  NewSelection : TGridRect;
  RowIndex, ColIndex : integer;
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
  NewSelection.Right := sgMOC3DParticles.ColCount -1;
  sgMOC3DParticles.Selection := NewSelection;
  // check that all data in the grid is valid, if any isn't valid
  // fix it.
  For RowIndex := 1 to sgMOC3DParticles.RowCount -1 do
  begin
    For ColIndex := 1 to sgMOC3DParticles.ColCount -1 do
    begin
      try
        begin
          StrToFloat(sgMOC3DParticles.Cells[ColIndex, RowIndex]);
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

procedure TfrmMODFLOW.FormDestroy(Sender: TObject);
var
  RowIndex : integer;
begin
  // triggering events: frmMODFLOW.OnDestroy;
  inherited;
  // destroy the layer structure
  MFLayerStructure.Free;


  // destroy the list of geologic units
  GeologicUnitsList.Free;
  GeologicUnitParametersList.Free;

  // destroy the lists of parameter lists.
  for RowIndex := 1 to sgTime.RowCount -1 do
  begin
    (sgTime.Objects[0, RowIndex] as TList).Free;
  end;

  SpecialHandlingList.Free;
end;

procedure TfrmMODFLOW.comboMOC3DPartFreqChange(Sender: TObject);
begin
  // triggering events: comboMOC3DPartFreq.OnChange;
  inherited;

  // if you are going to print a particle locations output file, then you can
  // specify how frequently you can print data to it.
  adeMOC3DPartFreq.Enabled := (comboMOC3DPartFreq.ItemIndex = 3)
    and (comboMOC3DPartFileType.ItemIndex > 0);

end;

procedure TfrmMODFLOW.FormShow(Sender: TObject);
var
  layerHandle : ANE_PTR;
  NumRows: ANE_INT32;
  NumColumns: ANE_INT32;
  StringtoEvaluate : string;
  RowPosition: ANE_DOUBLE;
  ColPositon: ANE_DOUBLE;
  EdgeOfGrid: ANE_DOUBLE;
begin
  // triggering events: frmMODFLOW.OnShow;
  inherited;

  // make the project tab the active tab.
  if reProblem.Lines.Count = 0 then
  begin
    pageControlMain.ActivePage := tabProject;
  end
  else
  begin
    pageControlMain.ActivePage := TabProblem;
    TabProblem.TabVisible := True;
    BitBtnHelp.HelpContext := 1430;
  end;

  // if you have just loaded a MOC3D model from the old version of the PIE
  // you must update the MOC3D subgrid
  if RecalculateSubgrid then
  begin
    // once the subgrid has been updated it doesn't need to be updated again
    // so set  RecalculateSubgrid to false.
    RecalculateSubgrid := False;

    // get the layer handle for the grid layer
    layerHandle := ANE_LayerGetHandleByName(CurrentModelHandle,
       PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

    // get the number of rows
    ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
       kPIEInteger, 'NumRows()', @NumRows );

    // get the number of columns
    ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
       kPIEInteger, 'NumColumns()', @NumColumns );

    // set the value of the distance to the first row
    if (StrToInt(adeMOC3DRow1.Text) = 1) or (NumRows = 0)
    then
      begin
        // if the default value is used or the grid does not exist, use 0.
        adeMOC3DRow1.Text := '0'
      end
    else
      begin
        // get the position of the first row.
        StringtoEvaluate := 'NthRowPos(' + IntToStr(0) + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

        EdgeOfGrid := RowPosition;

        // get the position of the row the user specified.
        StringtoEvaluate := 'NthRowPos(' +
          IntToStr(StrToInt(adeMOC3DRow1.Text) -1) + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

        // set the correct distance
        adeMOC3DRow1.Text := FloatToStr(Abs(RowPosition- EdgeOfGrid));
      end;

    // set the value of the distance to the last row
    if (StrToInt(adeMOC3DRow2.Text) = -1) or (NumRows = 0)
    then
      begin
        // if the default value is used or the grid does not exist, use 0.
        adeMOC3DRow2.Text := '0'
      end
    else
      begin
        // get the position of the last row.
        StringtoEvaluate := 'NthRowPos(' + IntToStr(NumRows) + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

        EdgeOfGrid := RowPosition;

        // get the position of the row the user specified.
        StringtoEvaluate := 'NthRowPos(' + adeMOC3DRow2.Text + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

        // set the correct distance
        adeMOC3DRow2.Text := FloatToStr(Abs(EdgeOfGrid - RowPosition));
      end;

    // set the value of the distance to the first column
    if (StrToInt(adeMOC3DCol1.Text) = 1) or (NumColumns = 0)
    then
      begin
        // if the default value is used or the grid does not exist, use 0.
        adeMOC3DCol1.Text := '0'
      end
    else
      begin
        // get the position of the first column.
        StringtoEvaluate := 'NthColumnPos(' + IntToStr(0) + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

        EdgeOfGrid := RowPosition;

        // get the position of the column the user specified.
        StringtoEvaluate := 'NthColumnPos('
          + IntToStr(StrToInt(adeMOC3DCol1.Text) -1) + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @ColPositon );

        // set the correct distance
        adeMOC3DCol1.Text := FloatToStr(Abs(ColPositon - EdgeOfGrid));
      end;

    // set the value of the distance to the last column
    if (StrToInt(adeMOC3DCol2.Text) = -1) or (NumColumns = 0)
    then
      begin
        // if the default value is used or the grid does not exist, use 0.
        adeMOC3DCol2.Text := '0'
      end
    else
      begin
        // get the position of the last column.
        StringtoEvaluate := 'NthColumnPos(' + IntToStr(NumColumns) + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

        EdgeOfGrid := RowPosition;

        // get the position of the column the user specified.
        StringtoEvaluate := 'NthColumnPos(' + adeMOC3DCol2.Text + ')' ;

        ANE_EvaluateStringAtLayer(CurrentModelHandle, layerHandle ,
                kPIEFloat, PChar(StringtoEvaluate), @ColPositon );

        // set the correct distance
        adeMOC3DCol2.Text := FloatToStr(Abs(EdgeOfGrid - ColPositon));
      end;
    BottomMOC3DSubGridDistance := StrToFloat(adeMOC3DRow1.Text);
    TopMOC3DSubGridDistance := StrToFloat(adeMOC3DRow2.Text);
    LeftMOC3DSubGridDistance := StrToFloat(adeMOC3DCol1.Text);
    RightMOC3DSubGridDistance := StrToFloat(adeMOC3DCol2.Text);


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

procedure TfrmMODFLOW.edMOC3DInitParticlesEnter(Sender: TObject);
begin
  // triggering events: edMOC3DInitParticles.OnEnter;
  // called by btnMOC3DParticleAddClick
  // called by GLoadForm in ProjectFunctions
  inherited;

  // when the user starts to edit the initial number of MOC3D Particles,
  // store the value that is there already in case you have to restore it.
//  PrevNumParticles := StrToInt(edMOC3DInitParticles.Text);
end;

procedure TfrmMODFLOW.edMOC3DInitParticlesExit(Sender: TObject);
var
  NewNumParticles : integer;
  RowIndex, ColIndex : integer;
begin
  // triggering events: edMOC3DInitParticles.OnExit;
  // called by btnMOC3DParticleAddClick;
  // called by GLoadForm/
  inherited;
  try
    begin
      if cbCustomParticle.Checked then
      begin
        PrevNumParticles := sgMOC3DParticles.RowCount -1;
        // determine the new number of MOC3D particles
        NewNumParticles := StrToInt(edMOC3DInitParticles.Text);

        // change the number of rows in the particle grid to reflect the new
        // number of particles
        sgMOC3DParticles.RowCount := NewNumParticles + 1;

        // if the number of particles has increased, copy data from previous rows
        if NewNumParticles > PrevNumParticles then
        begin
          For RowIndex := PrevNumParticles + 1 to sgMOC3DParticles.RowCount -1 do
          begin
            sgMOC3DParticles.Cells[0, RowIndex] := IntToStr(RowIndex);
            for ColIndex := 1 to sgMOC3DParticles.ColCount -1 do
            begin
              sgMOC3DParticles.Cells[ColIndex, RowIndex]
                := sgMOC3DParticles.Cells[ColIndex, RowIndex-1];
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
Var
  AStringGrid : TStringGrid;
  ACol, ARow: Longint;
begin
  // triggering event: sgTime.OnMouseMove;
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
      if (ACol > -1) and (ACol < AStringGrid.ColCount ) then
      begin
        // display the full title of the current column in the status bar
        statbarMain.SimpleText := AStringGrid.Cells[ACol, 0];
      end;
    end;
  Except on EListError do
    begin
      // if the mouse moves outside of the grid, do nothing
    end;
  end;
end;

procedure TfrmMODFLOW.adeMOC3DLayerExit(Sender: TObject);
var
  FirstLayer, LastLayer : integer;
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

  // update the number of units used by MOC3D.
  adeMOCNumLayers.Text := IntToStr(LastLayer - FirstLayer + 1);
end;

function TfrmMODFLOW.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  // triggering events: frmMODFLOW.OnHelp;
  inherited;

  // This assigns the help file every time Help is called from frmMODFLOW.
  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmMODFLOW.
  AssignHelpFile('MODFLOW.hlp');
  result := True;
end;

procedure TfrmMODFLOW.adeFileNameExit(Sender: TObject);
begin
  // triggering event: adeFileName.OnExit;
  inherited;

  // convert the root name of the simulation file to lowercase.
  // This makes it easier to run the MODFLOW simulation on UNIX.
  adeFileName.Text := Lowercase(adeFileName.Text);
end;

procedure TfrmMODFLOW.cbSTRClick(Sender: TObject);
begin
  // triggering event: cbSTR.OnClick;
  inherited;
  // Show a warning if the stream and MOC3D are both displayed.
  StreamWarning;

  // enable or disable options related to streams depending on
  // whether or not streams will be used in the simulation.
  comboStreamOption.Enabled := cbSTR.Checked;
  SetComboColor(comboStreamOption);

  cbSTRRetain.Enabled := cbSTR.Checked;
  lblStrPrintFlows.Enabled := cbSTR.Checked;

  cbStreamCalcFlow.Enabled := cbSTR.Checked;
  cbStreamTrib.Enabled := cbSTR.Checked;
  cbStreamDiversions.Enabled := cbSTR.Checked;
  cbFlowSTR.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbStr.Checked;
  cbFlowSTR2.Enabled := cbStr.Checked;

  // enable the user to specify the model units if both streams and selected
  // and stream flow will be calculated
  comboModelUnits.Enabled := cbSTR.Checked and cbStreamCalcFlow.Checked;
  SetComboColor(comboModelUnits);

  cbStrPrintFlows.Enabled := cbSTR.Checked;

  // add or remove the stream layers from the layer structure depending
  // on whether or not streams will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFStreamLayerType, cbSTR.Checked);

  // add or remove grid stream parameter from the grid layer
  // depending on whether streams are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridStreamParamType,
     cbSTR.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbStreamCalcFlowClick(Sender: TObject);
begin
  // triggering event: cbStreamCalcFlow.OnClick;
  inherited;

  // enable the user to specify the model units if both streams and selected
  // and stream flow will be calculated
  comboModelUnits.Enabled := cbSTR.Checked and cbStreamCalcFlow.Checked;
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
    (ModflowTypes.GetMFStreamLayerType, ModflowTypes.GetMFStreamRoughParamType,
     cbStreamCalcFlow.Checked and cbSTR.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;
end;

procedure TfrmMODFLOW.cbStreamTribClick(Sender: TObject);
begin
  // triggering event: cbStreamTrib.OnClick;
  inherited;

  // add or remove the stream downstream segment number parameters from the
  // stream layers
  // depending on whether or not tributaries will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMFStreamDownSegNumParamType,
     cbStreamTrib.Checked and cbSTR.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.cbStreamDiversionsClick(Sender: TObject);
begin
  // triggering event: cbStreamDiversions.OnClick;
  inherited;

  // add or remove the stream diversion segment number parameters from the
  // stream layers
  // depending on whether or not diversions will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMFStreamDivSegNumParamType,
     cbStreamDiversions.Checked and cbSTR.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;

end;

procedure TfrmMODFLOW.cbHFBClick(Sender: TObject);
begin
  // triggering event: cbHFB.OnClick;
  inherited;
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

  // If you are using Flow-and-head boundaries, and you have multiple steady
  // state models, you can choose whether or not to interpolate flow-and-head
  // boundaries
  comboFHBSteadyStateOption.Enabled
    := (comboSteady.ItemIndex = 1) and cbFHB.Checked and (sgTime.RowCount > 2);
  SetComboColor(comboFHBSteadyStateOption);

  // if you are using flow-and-head boundaries and MOC3D, you can choose
  // the weight used in interpolating concencentrations.
  adeFHBHeadConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;
  adeFHBFluxConcWeight.Enabled := cbMOC3D.Checked and cbFHB.Checked;

  cbFlowFHB.Enabled := cbFHB.Checked;

  // add or remove the flow-and-head boundaries layers from
  // the layer structure depending
  // on whether or not flow-and-head boundaries will be used.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFPointFHBLayerType, cbFHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineFHBLayerType, cbFHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaFHBLayerType, cbFHB.Checked);

  // add or remove grid flow-and-head boundary parameter from the grid layer
  // depending on whether flow-and-head boundaries are selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridFHBParamType,
     cbFHB.Checked);

end;

procedure TfrmMODFLOW.comboSteadyChange(Sender: TObject);
begin
  // triggering event: comboSteady.OnChange;
  // called by FormCreate;
  // called by GLoadForm in ProjectFunction;

  inherited;
  // If you are using Flow-and-head boundaries, and you have multiple steady
  // state models, you can choose whether or not to interpolate flow-and-head
  // boundaries
  comboFHBSteadyStateOption.Enabled
    := (comboSteady.ItemIndex = 1) and cbFHB.Checked and (sgTime.RowCount > 2);
  SetComboColor(comboFHBSteadyStateOption);

  // If you have a steady state
  // model, you can specify the stop time for MODPATH.
  cbMPATHStopTime.Enabled := (comboSteady.ItemIndex = 1);

  // If you can't specify the stop time for MODPATH.
  // model, you don't specify the stop time for MODPATH.
  if not cbMPATHStopTime.Enabled then
  begin
    cbMPATHStopTime.Checked := False;
  end;

  // enable or disable other controls depending on the value of
  // cbMPATHStopTime;
  cbMPATHStopTimeClick(Sender);

  // enable or disable the MODPATH starting time method
  // depending on whether or not you have a steady state model.
  comboMPATHStartTimeMethod.Enabled := (comboSteady.ItemIndex = 0);
  SetComboColor(comboMPATHStartTimeMethod);

  // enable or disable controls related to the MODPATH starting time method.
  comboMPATHStartTimeMethodChange(Sender);

  // enable or disable the MODPATH tracking time option and it's
  // lable depending on whether or not you have a steady state model.
  cbMPATHTrackStop.Enabled := (comboSteady.ItemIndex = 0);
  lblMPATHTrackStop.Enabled := cbMPATHTrackStop.Enabled;

  // enable or disable controls related to the MODPATH tracking time option.
  cbMPATHTrackStopClick(Sender);
end;

procedure TfrmMODFLOW.adeFHBNumTimesExit(Sender: TObject);
var
  RowIndex : integer;
  TimeIndex : integer;
  LayerIndex : integer;
  NewFHBTimes : integer;
  AnIndexedLayerList : T_ANE_IndexedLayerList;
  APointFHBLayer : T_ANE_InfoLayer ;
  ALineFHBLayer : T_ANE_InfoLayer ;
  AnAreaFHBLayer : T_ANE_InfoLayer ;
  NumberOfUnits :integer;
begin
  // triggering event: adeFHBNumTimes.OnExit;
  inherited;

  // determine the new number of flow-and-head boundary times.
  NewFHBTimes := StrToInt(adeFHBNumTimes.Text);

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
  for RowIndex := sgFHBTimes.FixedRows to sgFHBTimes.RowCount -1 do
  begin
    if sgFHBTimes.Cells[1,RowIndex] = '' then
    begin
      sgFHBTimes.Cells[1,RowIndex] := '0';
    end;
    if sgFHBTimes.Cells[0,RowIndex] = '' then
    begin
      sgFHBTimes.Cells[0,RowIndex] := IntToStr(RowIndex);
    end;
  end;

  // don't try to do this if you aren't using the FHB package
  // cbFHB.Checked may be false when this method is called
  // when openning a file.
  if cbFHB.Checked then
  begin
    // add or remove time-related parameters as required
    if NewFHBTimes > PreviousFHBTimes
    then
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

          MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
            ModflowTypes.GetMFAreaFHBLayerType,
            ModflowTypes.GetMFFHBAreaTimeParamListType, -1);
        end;
      end
    else
      begin
        // First get the number of units
        NumberOfUnits := StrToInt(edNumUnits.Text);

        // loop over all the units.
        for LayerIndex := 0 to NumberOfUnits-1 do
        begin
          // get each geologic unit
          AnIndexedLayerList := MFLayerStructure.ListsOfIndexedLayers.
            GetNonDeletedIndLayerListByIndex(LayerIndex);

          // get the point FHB layer
          APointFHBLayer := AnIndexedLayerList.GetLayerByName
            (ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName)
            as T_ANE_InfoLayer;

          // delete FHB time parameters from the point FHB layer
          for TimeIndex := PreviousFHBTimes-1 downto NewFHBTimes  do
          begin
            (APointFHBLayer as ModflowTypes.GetMFPointFHBLayerType).
              IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(TimeIndex).DeleteSelf;
          end;

          // get the line FHB layer
          ALineFHBLayer := AnIndexedLayerList.GetLayerByName
            (ModflowTypes.GetMFLineFHBLayerType.ANE_LayerName)
            as T_ANE_InfoLayer;

          // delete FHB time parameters from the line FHB layer
          for TimeIndex := PreviousFHBTimes-1 downto NewFHBTimes  do
          begin
            (ALineFHBLayer as  ModflowTypes.GetMFLineFHBLayerType).
              IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(TimeIndex).DeleteSelf;
          end;

          AnAreaFHBLayer := AnIndexedLayerList.GetLayerByName
            (ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName)
            as T_ANE_InfoLayer;

          for TimeIndex := PreviousFHBTimes-1 downto NewFHBTimes do
          begin
            (AnAreaFHBLayer as ModflowTypes.GetMFAreaFHBLayerType).
              IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(TimeIndex).DeleteSelf;
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
  PreviousFHBTimeText := sgFHBTimes.Cells[Col,Row];
end;

procedure TfrmMODFLOW.sgFHBTimesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  // triggering event: sgFHBTimes.OnSetEditText;
  inherited;

  // if the user enters invalid data in the FHB time grid, restore
  // the previous data
  try
    begin
      if (ARow > 0) and (ACol > 0) then
      begin
        if not (sgFHBTimes.Cells[ACol,ARow] = '') then
        begin
          StrToFloat(sgFHBTimes.Cells[ACol,ARow]);
          PreviousFHBTimeText := sgFHBTimes.Cells[ACol,ARow];
        end;
      end;
    end;
  except on EConvertError do
    begin
      sgFHBTimes.Cells[ACol,ARow] := PreviousFHBTimeText;
      Beep;
    end;
  end;
end;

procedure TfrmMODFLOW.btnOKClick(Sender: TObject);
var
  RowIndex : integer;
  firstSimulatedFound : boolean;
  FirstLayer, LastLayer : integer;
begin
  // triggering event: btnOK.OnClick;
  inherited;

  // Show a warning if the rewetting option and MOC3D are both selected.
  Moc3dWetWarning;
  // Show a warning if the stream and MOC3D are both selected.
  StreamWarning;
  Moc3dTimeWarning;

  // finish editting the current cell in dtabGeol if the user has not
  // done so already.
//  dtabGeol.CurCell.EndEdit;

  // Check that every time used in the FHB backage is greater than
  // its predecessor. Display a warning message if any such errors
  // are found.
  if sgFHBTimes.Enabled then
  begin
    For RowIndex := 1 to sgFHBTimes.RowCount -2 do
    begin
      if StrToFloat(sgFHBTimes.Cells[1,RowIndex])
        > StrToFloat(sgFHBTimes.Cells[1,RowIndex+1]) then
      begin
        Beep;
        MessageDlg('Each time specified for the FHB package '
          + 'must be greater than or equal to it''s predecessor. '
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
  For RowIndex := 1 to StrToInt(edNumUnits.Text)  do
  begin
   if dgGeol.Cells[Ord(nuiSim),RowIndex] = 'Yes' then
   begin
     firstSimulatedFound := True;
   end;

   if (RowIndex  > 1) and firstSimulatedFound and
      (dgGeol.Cells[Ord(nuiType),RowIndex]
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
    For RowIndex := FirstLayer to LastLayer do
    begin
//     if dtabGeol.CellSet.Item[RowIndex,Ord(uiSim)].Value = 'No' then
     if dgGeol.Cells[Ord(nuiSim),RowIndex] = 'No' then
     begin
          Beep;
          MessageDlg('All layers used by MOC3D must be simulated.'
           + ' You should fix this before attempting to run MOC3D.', mtWarning,
            [mbOK], 0);
          break;
     end;
    end;
  end;
  
  // Check if the time units have been specified properly for the stream package
  if cbSTR.Checked and cbStreamCalcFlow.Checked
    and (comboTimeUnits.ItemIndex = 0) then
  begin
    Beep;
    MessageDlg('You will need to specify the time units for your model '
     + 'if you wish to calculate stream stage.'
     + ' You should fix this before attempting to run MODFLOW.', mtWarning,
      [mbOK], 0);
  end;

  if cbZonebudget.Checked and (rgZonebudTimesChoice.ItemIndex = 1) then
  begin
    sgZondbudTimesExit(Sender);
  end;

  sgMOC3DParticlesExit(Sender);

  if MODFLOWLayerCount > 200 then
  begin
    Beep;
    MessageDlg('MODFLOW has a maximum of 200 layers. '
     + 'You have specified a larger value.'
     + ' To use more than 200 layers you must modify and recompile MODFLOW.',
     mtWarning, [mbOK], 0);
  end;

  InitialHeadsWarning; 

end;

procedure TfrmMODFLOW.adeFHBNumTimesEnter(Sender: TObject);
begin
  // triggering event: adeFHBNumTimes.OnEnter;
  inherited;

  // store the previous number of FHB times in case it needs to be
  // restored later.
  PreviousFHBTimes := StrToInt(adeFHBNumTimes.Text);
end;

procedure TfrmMODFLOW.cbMODPATHClick(Sender: TObject);
begin
  // triggering event: cbMODPATH.OnClick;
  inherited;

  // make the MODPATH  tabs visible when appropriate.

  // the MODPATH and MODPATH-options tabs should be visible whenever
  // MODPATH is used
//  tabMODPATH.TabVisible := cbMODPATH.Checked;
  tabMODPATHOptions.TabVisible := cbMODPATH.Checked;
  cbModpathCOMPACT.Enabled := cbMODPATH.Checked;
  cbModpathBINARY.Enabled := cbMODPATH.Checked;
  adeMODPATHMaxReleaseTime.Enabled := cbMODPATH.Checked;
  adeModpathMAXSIZ.Enabled := cbMODPATH.Checked;
  adeModpathNPART.Enabled := cbMODPATH.Checked;
  adeModpathTBEGIN.Enabled := cbMODPATH.Checked;
  adeModpathBeginPeriod.Enabled := cbMODPATH.Checked;
  adeModpathBeginStep.Enabled := cbMODPATH.Checked;
  adeModpathEndPeriod.Enabled := cbMODPATH.Checked;
  adeModpathEndStep.Enabled := cbMODPATH.Checked;

  comboMODPATH_RechargeITOP.Enabled := cbMODPATH.Checked and cbRCH.Checked;
  SetComboColor(comboMODPATH_RechargeITOP);

  comboMODPATH_EvapITOP.Enabled := cbMODPATH.Checked and cbEVT.Checked;;
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

  if cbMODPATH.Checked or cbZonebudget.Checked  then
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
    if not cbSTR.Checked and not cbStrPrintFlows.Checked then
    begin
      cbFlowSTR.Checked := True;
    end;
  end;
  cbOneFlowFile.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked;
  cbFlowBCF.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked;
  cbFlowRCH.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbRch.Checked;
  cbFlowDrn.Enabled := not cbMODPATH.Checked and not cbZonebudget.Checked
    and cbDrn.Checked;
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
    (ModflowTypes.GetMOCPorosityLayerType,
     cbMOC3D.Checked or cbMODPATH.Checked);

  if cbMODPATH.Checked then
  begin
    MFLayerStructure.PostProcessingLayers.AddOrRemoveLayer
      (ModflowTypes.GetMODPATHPostLayerType, cbMODPATH.Checked);
  end;

  // add or remove the porosity parameters from the grid layer
  // depending or whether or not you are using MODPATH or MOC3D.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridMOCPorosityParamType,
     cbMOC3D.Checked  or cbMODPATH.Checked);

  // add or remove the MODPATH zone parameters from the grid layer
  // depending or whether or not you are using MODPATH.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridModpathZoneParamType,
     cbMODPATH.Checked);

  // add or remove the MODPATH IFACE parameters from the well layers
  // depending or whether or not you are using MODPATH and wells.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbWel.Checked);

  // add or remove the MODPATH IFACE parameters from the river layers
  // depending or whether or not you are using MODPATH and rivers.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbRiv.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbRiv.Checked);

  // add or remove the MODPATH IFACE parameters from the drain layers
  // depending or whether or not you are using MODPATH and drains.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineDrainLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbDRN.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaDrainLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbDRN.Checked);

  // add or remove the MODPATH IFACE parameters from the
  // general-head boundary layers
  // depending or whether or not you are using MODPATH and
  // general-head boundaries.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbGHB.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbGHB.Checked);

  // add or remove the MODPATH IFACE parameters from the stream layers
  // depending or whether or not you are using MODPATH and streams.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType, ModflowTypes.GetMFIFACEParamType,
     cbMODPATH.Checked and cbSTR.Checked);

  // associates lists of time-related parameters with sgTime grid.
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
  PreviousTimes, NewTimes : integer;
  Index : integer;
  ListOfParameterLists : TList;
  AList : TList;
  InnerIndex : integer;
begin
  // triggering events: adeMODPATHMaxReleaseTime.OnExit;
  inherited;
  try
    begin
      // get the new number of Maximum release times and the previous
      // number of maximum release times.
      NewTimes := StrToInt(adeMODPATHMaxReleaseTime.Text);
      PreviousTimes := StrToInt(PreviousMODPATHReleaseTimesText);
      If NewTimes > PreviousTimes
      then
        begin
          // add new release time parameters
          For Index := PreviousTimes + 1 to NewTimes do
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
              For Index := PreviousTimes -1 downto NewTimes do
              begin
                // get a list of parameter lists
                AList := ListOfParameterLists.Items[Index];
                // loop over the paramters lists
                For InnerIndex := AList.Count -1 downto 0 do
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
              For Index := ListOfParameterLists.Count -1 downto 0 do
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
  RowIndex : integer;
begin
  // triggering events: sgMODPATHOutputTimes.OnExit;
  // called by GLoadForm in ProjectFunctions
  inherited;

  // check that all data in the MODPATH Times grid is valid
  For RowIndex := 1 to sgMODPATHOutputTimes.RowCount -1 do
  begin
    try
      StrToFloat(sgMODPATHOutputTimes.Cells[1,RowIndex]);
    except on EConvertError do
      sgMODPATHOutputTimes.Cells[1,RowIndex] := '0';
    end;

  end;
end;

procedure TfrmMODFLOW.sgTimeExit(Sender: TObject);
var
  RowIndex : integer;
begin
  // triggering event: sgTime.OnExit;
  // called by GLoadForm in ProjectFunctions
  inherited;

  For RowIndex := 1 to sgTime.RowCount -1 do
  begin
    try
      begin
        StrToFloat(sgTime.Cells[Ord(tdLength), RowIndex]);
      end;
    except on EConvertError do
      begin
        sgTime.Cells[Ord(tdLength), RowIndex] := '1';
      end;
    end;

    try
      begin
        StrToInt(sgTime.Cells[Ord(tdNumSteps), RowIndex]);
      end;
    except on EConvertError do
      begin
        sgTime.Cells[Ord(tdNumSteps), RowIndex] := '1';
      end;
    end;

    try
      begin
        StrToFloat(sgTime.Cells[Ord(tdMult), RowIndex]);
      end;
    except on EConvertError do
      begin
        sgTime.Cells[Ord(tdLength), RowIndex] := '1';
      end;
    end;
  end;


  // set the maximum step numbers to appropriate values.
  adeModpathBeginStep.Max := StrToInt(sgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeModpathBeginPeriod.Text)]);

  adeModpathBeginStepExit(nil);

  adeModpathEndStep.Max := StrToInt(sgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeModpathEndPeriod.Text)]);

  adeMPATHRefStep.Max := StrToInt(sgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeMPATHRefPeriod.Text)]);
end;

procedure TfrmMODFLOW.adeModpathBeginPeriodExit(Sender: TObject);
begin
  // triggering events: adeModpathBeginPeriod.OnExit;
  // called by GLoadForm;
  inherited;

  // set the maximum allowed value for the beginning step to the maximum
  // number of steps for the stress period
  adeModpathBeginStep.Max := StrToInt(sgTime.Cells[Ord(tdNumSteps),
        StrToInt(adeModpathBeginPeriod.Text)]);
  adeModpathBeginStepExit(nil);
  // set the minimum ending period to the beginning period
  adeModpathEndPeriod.Min := StrToInt(adeModpathBeginPeriod.Text);
  adeModpathBeginStepExit(nil);

  // set other maximum or minimums according to adeModpathBeginStep
  adeModpathBeginStepExit(nil);
end;

procedure TfrmMODFLOW.adeModpathBeginStepExit(Sender: TObject);
begin
  // triggering events: adeModpathBeginStep.OnExit;
  // triggering events: adeModpathEndPeriod.OnExit;
  // called by adeModpathBeginPeriodExit;
  inherited;
{  adeModpathBeginStep.Max := StrToInt(sgTime.Cells[Ord(tdNumSteps),
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
      // if they are different, the minimum ending step is 1.
      adeModpathEndStep.Min := 1;
    end;
end;


procedure TfrmMODFLOW.adeZoneBudCompZoneCountChange(Sender: TObject);
var
  NumOfZones : integer;
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
  ARow: Integer; const Value: String);
begin
  // triggering events: sgZoneBudCompZones.OnSetEditText;
  inherited;

  // check that only valid data are entered in the composite zones grid
  if (ACol > 0)then
  begin
    if not (Value = '') then
    begin
      try
        begin
          StrToInt(Value);
        end;
      except On EConvertError do
        begin
          // restore the previous value if the data is invalid.
          sgZoneBudCompZones.Cells[ACol,ARow] := PrevCompZoneText;
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
  PrevCompZoneText := sgZoneBudCompZones.Cells[ACol,ARow];
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
//  tabZoneBudget.TabVisible := cbZonebudget.Checked;
  adeZonebudgetTitle.Enabled := cbZonebudget.Checked;
  adeZoneBudCompZoneCount.Enabled := cbZonebudget.Checked;

  rgZonebudTimesChoice.Enabled := cbZonebudget.Checked;

  adeZoneBudCompZoneCountExit(Sender);

  rgZonebudTimesChoiceClick(Sender);

  // Zonebudget can't read compact budget files so disable the compact
  // budget file option and uncheck it if it is checked.
  cbFlowBudget.enabled := not cbZonebudget.Checked;
  if not cbFlowBudget.enabled then
  begin
    cbFlowBudget.Checked := False;
  end;

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
  function PadZoneNumber (ZoneNumber: string) : string;
  begin
    // convert a zone number string to a string with exactly 4 spaces
    // This is done because Zonebdgt requires that the zones making up
    // the composite zone be in I4 format.
    result := Copy(ZoneNumber, 1, 4);
    While Length(Result) < 4 do
    begin
      Result := ' ' + Result;
    end;
  end;
var
  Row : integer;
  ColumnIndex : integer;
begin
  // called by GetZoneBudCompositeZone

  // get the row for the composite zone.
  Row := Zone - 1;

  // initialize the result.
  result := '';

  // loop over the columns and add the zones in each column to
  // the string that represents the composite zones.
  For ColumnIndex := 1 to 10 do
  begin
    Result := Result + PadZoneNumber(Trim
      (sgZoneBudCompZones.Cells[ColumnIndex,Row]));
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
  RowIndex : integer;
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
          := StrToInt(adeMODPATHOutputTimeCount.Text)+1;

        // update the grid and make sure there are now blank spaces in it.
        For RowIndex := 1 to sgMODPATHOutputTimes.RowCount -1 do
        begin
          sgMODPATHOutputTimes.Cells[0,RowIndex] := IntToStr(RowIndex);
          if sgMODPATHOutputTimes.Cells[1,RowIndex] = '' then
          begin
            sgMODPATHOutputTimes.Cells[1,RowIndex] := '0';
          end;
        end;
      end;
    end;
  Except on EConvertError do
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

  // when a user begins to edit the Number of ZONEBDGT Composite zones,
  // store the existing value in case it has to be restored.
  PrevCompZoneCount := adeZoneBudCompZoneCount.Text;
end;

procedure TfrmMODFLOW.adeZoneBudCompZoneCountExit(Sender: TObject);
var
  NumZones : integer;
  Index : integer;
begin
  // triggering events: adeZoneBudCompZoneCount.OnExit;
  inherited;
  try
    begin
      // get the number of Number of ZONEBDGT Composite zones
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
      For Index := 1 to sgZoneBudCompZones.RowCount do
      begin
        sgZoneBudCompZones.Cells[0,Index-1] := IntToStr(Index);
      end;
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
  RowIndex : integer;
begin
  // called by GetZoneBudTimeCount in ZoneBudgetFunctions.

  // initialize the result
  result := 0;

  // check that values have been entered for at least the first column
  // Increment the result for each composite zone for which data has been
  // entered. Quit when you encounter the first row for which no data has
  // been entered.
  For RowIndex := 1 to sgZondbudTimes.RowCount -1 do
  begin
    if Trim(sgZondbudTimes.Cells[1,RowIndex]) <> ''
    then
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
    Result := StrToInt(sgZondbudTimes.Cells[2,ATime]);
  except On E: Exception do
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
    Result := StrToInt(sgZondbudTimes.Cells[1,ATime]);
  except On E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := 1;
    end;
  end;
end;

procedure TfrmMODFLOW.pageControlMainChange(Sender: TObject);
var
  ControlIndex : integer;
//  ATwinControl : TWinControl;
  APageControl : TPageControl;
begin
  // triggering event: pageControlMain.OnChange;
  inherited;
  // The following "for" loop ensures that everything gets displayed properly.

//  frmMODFLOW.Height := frmMODFLOW.Height + 1;
//  frmMODFLOW.Height := frmMODFLOW.Height - 1;


  for ControlIndex := 0 to ControlCount -1 do
  begin
    if Controls[ControlIndex] is TWinControl then
    begin
      TWinControl(Controls[ControlIndex]).Handle;
    end;
  end;

  statbarMain.SimpleText := '';

  APageControl := Sender as TPageControl;

  // change the help context of the Help button to the correct number for the
  // current tab.
  if (APageControl.ActivePage = tabAbout) then
  begin
    BitBtnHelp.HelpContext := 1440;
  end;
  if (APageControl.ActivePage = tabProject) then
  begin
    BitBtnHelp.HelpContext := 30;
  end;
  if APageControl.ActivePage = tabGeology then
  begin
    BitBtnHelp.HelpContext := 40;
  end;
  if APageControl.ActivePage = tabMisc then
  begin
    BitBtnHelp.HelpContext := 80;
  end;
  if APageControl.ActivePage = tabStress then
  begin
    BitBtnHelp.HelpContext := 180;
  end;
  if APageControl.ActivePage = tabTime then
  begin
    BitBtnHelp.HelpContext := 250;
  end;
  if APageControl.ActivePage = tabOutputFiles then
  begin
    BitBtnHelp.HelpContext := 320;
  end;
  if APageControl.ActivePage = tabOutputCtrl then
  begin
    BitBtnHelp.HelpContext := 1450;
  end;
{  if APageControl.ActivePage = tabSIP then
  begin
    BitBtnHelp.HelpContext := 390;
  end;
  if APageControl.ActivePage = tabSOR then
  begin
    BitBtnHelp.HelpContext := 470;
  end;
  if APageControl.ActivePage = tabPCG2 then
  begin
    BitBtnHelp.HelpContext := 520;
  end;
  if APageControl.ActivePage = tabDE4 then
  begin
    BitBtnHelp.HelpContext := 630;
  end; }
  if APageControl.ActivePage = tabMOC3DSubGrid then
  begin
    BitBtnHelp.HelpContext := 730;
  end;
  if APageControl.ActivePage = tabMOC3DParticles then
  begin
    BitBtnHelp.HelpContext := 830;
  end;
  if APageControl.ActivePage = tabMOC3DOut then
  begin
    BitBtnHelp.HelpContext := 890;
  end;
  if APageControl.ActivePage = tabMoreStresses then
  begin
    BitBtnHelp.HelpContext := 920;
  end;
  if APageControl.ActivePage = tabMODPATH then
  begin
    BitBtnHelp.HelpContext := 1000;
  end;
  if APageControl.ActivePage = tabMODPATHOptions then
  begin
    BitBtnHelp.HelpContext := 1140;
  end;
  if APageControl.ActivePage = tabModpathTimes then
  begin
    BitBtnHelp.HelpContext := 1100;
  end;
  if APageControl.ActivePage = tabCustomize then
  begin
    BitBtnHelp.HelpContext := 1120;
  end;
  if APageControl.ActivePage = tabZoneBudget then
  begin
    BitBtnHelp.HelpContext := 1370;
  end;
  if APageControl.ActivePage = tabProblem then
  begin
    BitBtnHelp.HelpContext := 1430;
  end;
  if APageControl.ActivePage = tabStream then
  begin
    BitBtnHelp.HelpContext := 360;
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
    and (comboSteady.ItemIndex = 1) and cbMODPATH.Checked;

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
    and (comboSteady.ItemIndex = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

  adeMPATHRefStep.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 0)
    and (comboSteady.ItemIndex = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

  adeMPATHRefTimeInStep.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 0)
    and (comboSteady.ItemIndex = 0) and cbMODPATH.Checked
    and comboMPATHStartTimeMethod.Enabled;

  adeMPATHRefTime.Enabled := (comboMPATHStartTimeMethod.ItemIndex = 1)
    and (comboSteady.ItemIndex = 0) and cbMODPATH.Checked
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
    and (comboSteady.ItemIndex = 0) and cbMODPATH.Checked;

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
begin
  // triggering events: comboMPATHTimeMethod.OnChange;
  // called by cbMODPATHClick;
  // called by cbMPATHComputeLocClick;
  inherited;
  tabModpathTimes.TabVisible := cbMODPATH.Checked
    and cbMPATHComputeLoc.Checked and (comboMPATHTimeMethod.ItemIndex = 1)
    and comboMPATHTimeMethod.Enabled ;

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
    firstRow, LastRow : integer;
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

function TfrmMODFLOW.PieIsEarlier(VersionInString,
  VersionInPIE: string; ShowError : boolean): boolean;
var
  PieString  : string;
  FileString : string;
  DotPosition : integer;
  Index : integer;
begin
  // called by FormCreate;

  // this function returns True if the Version number in VersionInString is
  // later than the version number in VersionInPIE. It is used to test
  // whether a model that is being opened was created by a later version of the
  // PIE.
  result := false;

  // extract the version number from VersionInString
  if Pos('File Version:',VersionInString) > 0 then
  begin
    VersionInString := Copy(VersionInString, Length('File Version:')+1,
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
      PieString := Copy(VersionInPIE,1, DotPosition -1);
      VersionInPIE := Copy(VersionInPIE, DotPosition + 1,
        Length(VersionInPIE));
    end;

    // extract a number from VersionInString
    DotPosition := Pos('.', VersionInString);
    if DotPosition > 0 then
    begin
      FileString := Copy(VersionInString,1, DotPosition -1);
      VersionInString := Copy(VersionInString, DotPosition + 1,
        Length(VersionInString));
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
          + CHR(13) + 'Version in PIE = VersionInPIE' , mtWarning, [mbOK], 0);
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
  adeMPATHRefStep.Max := StrToInt(sgTime.Cells[Ord(tdNumSteps),
    StrToInt(adeMPATHRefPeriod.Text)]);
end;

procedure TfrmMODFLOW.ReadOld_IDPTIM(var LineIndex : integer; FirstList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
var
  Line : integer;
begin
  Line := LineIndex;
  ReadCheckBox(LineIndex, FirstList, cbIDPTIM_Decay, DataToRead, VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, cbIDPTIM_Growth, DataToRead, VersionControl);
end;

procedure TfrmMODFLOW.ReadOld_IDKTIM(var LineIndex : integer; FirstList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
var
  Line : integer;
begin
  Line := LineIndex;
  ReadCheckBox(LineIndex, FirstList, cbIDKTIM_DisDecay, DataToRead, VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, cbIDKTIM_SorbDecay, DataToRead, VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, cbIDKTIM_DisGrowth, DataToRead, VersionControl);
  LineIndex := Line;
  ReadCheckBox(LineIndex, FirstList, cbIDKTIM_SorbGrowth, DataToRead, VersionControl);
end;

procedure TfrmMODFLOW.ReadOldGeoData(var LineIndex : integer; FirstList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
var
  ColIndex,RowIndex : Integer;
  AText : string;
  ColLimit : integer;
begin
  // called when loading an old file that used a different control instead
  // of dgGeol
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  dgGeol.RowCount := StrToInt(AText) + 1;
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ColLimit := StrToInt(AText);

  For ColIndex := 1 to ColLimit do
  begin
    For RowIndex := 1 to dgGeol.RowCount -1 do
    begin
      AText := DataToRead[LineIndex];
      Inc(LineIndex);
      if (ColIndex = Ord(nuiSim)) or (ColIndex = Ord(nuiTrans))
        or (ColIndex = Ord(nuiType)) then
      begin
        try
          dgGeol.Cells[ColIndex,RowIndex] :=
            dgGeol.Columns[ColIndex].Picklist.Strings[StrToInt(AText)];
        except on EConvertError do
          begin
            dgGeol.Cells[ColIndex,RowIndex] := AText;
          end;
        end;
      end
      else
      begin
            dgGeol.Cells[ColIndex,RowIndex] := AText;
      end;
    end;
  end;
  dgGeolExit(dgGeol);
end;

procedure TfrmMODFLOW.ReadOldIDIREC(var LineIndex : integer; FirstList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
var
  AText : string;
  AnInteger : integer;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AnInteger := StrToInt(AText);
  if AnInteger > 0 then
  begin
    comboMOC3D_IDIREC.ItemIndex := AnInteger -1;
  end
  else
  begin
    comboMOC3D_IDIREC.ItemIndex := 0;
  end;

end;

procedure TfrmMODFLOW.ReadEPSSLV(var LineIndex : integer; FirstList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
var
  AText : string;
  AFloat : double;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AFloat := StrToFloat(AText);
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
  ARow: Integer; const Value: String);
var
  AGeologicUnit : T_ANE_IndexedLayerList;
  GridLayer : T_ANE_GridLayer;
  AParameterList : T_ANE_IndexedParameterList;
  LayerType : integer;
begin
  // triggering event dgGeol.OnSetEditText
  inherited;
  // check that vertical discretization is an integer.
  if (ACol > 0) and (ARow > 0) then
  begin
    if ACol = Ord(nuiVertDisc) then
    begin
      try
        begin
          if dgGeol.Cells[ACol,ARow] <> '' then
          begin
            StrToInt(dgGeol.Cells[ACol,ARow]);
            LastGeologyText := dgGeol.Cells[ACol,ARow];
          end;
        end;
      except on EConvertError do
        begin
          dgGeol.Cells[ACol,ARow] := LastGeologyText;
          Beep;
        end;
      end;
    end;
    if (ACol = Ord(nuiSpecT)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow-1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFTransmisivityLayerType,
        dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1]);

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow-1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridTransParamType,
        ModflowTypes.GetMFGridTransParamType.Ane_ParamName,
        dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1]);

    end;
    if (ACol = Ord(nuiSpecVCONT)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow-1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFVcontLayerType,
        dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1]);

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow-1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridVContParamType,
        ModflowTypes.GetMFGridVContParamType.Ane_ParamName,
        dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1]);
    end;
    if (ACol = Ord(nuiSpecSF1)) and (ARow > 0) then
    begin
      AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.
        GetNonDeletedIndLayerListByIndex(ARow-1);
      AGeologicUnit.AddOrRemoveLayer(ModflowTypes.GetMFConfStorageLayerType,
        dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1]);

      GridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
        (ModflowTypes.GetGridLayerType.ANE_LayerName) as T_ANE_GridLayer;
      AParameterList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(ARow-1);
      AParameterList.AddOrRemoveParameter(ModflowTypes.GetMFGridConfStoreParamType,
        ModflowTypes.GetMFGridConfStoreParamType.Ane_ParamName,
        dgGeol.Cells[ACol, ARow] = dgGeol.Columns[ACol].Picklist.Strings[1]);
    end;
    if ACol = Ord(nuiType) then
    begin
      LayerType := dgGeol.Columns[Ord(nuiType)].Picklist.
        IndexOf(dgGeol.Cells[Ord(nuiType),ARow]);
      if (ACol = Ord(nuiType)) and (ARow > 1) then
      begin
        if dgGeol.Cells[Ord(nuiType),ARow] = dgGeol.Columns[Ord(nuiType)].Picklist[1] then
        begin
          dgGeol.Cells[Ord(nuiType),ARow] := dgGeol.Columns[Ord(nuiType)].Picklist[3];
          LayerType := 3;
        end;
      end;
      if not ((LayerType = 0) or (LayerType = 2)) then
      begin
        dgGeol.Cells[Ord(nuiSpecT),ARow] := dgGeol.Columns[Ord(nuiSpecT)].Picklist[0];
      end;
    end;
  end;

end;

procedure TfrmMODFLOW.dgGeolSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  ArithmeticAndLogarithmicUsed : boolean;
  RowIndex : integer;
  LayerType : integer;
begin
  inherited;
  // save contents of cell in case it needs to be restored.
  LastGeologyText := dgGeol.Cells[ACol,ARow];

  // Set IAPART if needed.
  ArithmeticAndLogarithmicUsed := false;
  For RowIndex := 1 to dgGeol.RowCount -1 do
  begin
    if dgGeol.Cells[Ord(nuiTrans),RowIndex]
      = dgGeol.Columns[Ord(nuiTrans)].Picklist.Strings[3] then
    begin
      ArithmeticAndLogarithmicUsed := True;
      break;
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
      IndexOf(dgGeol.Cells[Ord(nuiType),ARow]);
    if not((LayerType = 0) or (LayerType = 2)) then
    begin
      CanSelect := False;
    end;
  end;
  if (ACol > Ord(nuiSim)) and (dgGeol.Columns[Ord(nuiSim)].Picklist.
    IndexOf(dgGeol.Cells[Ord(nuiSim),ARow]) = 0) then
  begin
    CanSelect := False;
  end;
  dgGeol.Invalidate;

end;

procedure TfrmMODFLOW.sgZondbudTimesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  // save contents of cell in case it needs to be restored.
  PrevZoneBudTime := sgZondbudTimes.Cells[ACol,ARow];

end;

procedure TfrmMODFLOW.sgZondbudTimesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inherited;
  // check that stress periods and time steps for Zonebudget specified
  // times are all integers.
  try
    begin
      if (ACol > 0) and (ARow > 0) then
      begin
        if sgZondbudTimes.Cells[ACol,ARow] <> '' then
        begin
          StrToInt(sgZondbudTimes.Cells[ACol,ARow]);
          PrevZoneBudTime := sgZondbudTimes.Cells[ACol,ARow];
        end;
      end;
    end;
  except on EConvertError do
    begin
      Beep;
      sgZondbudTimes.Cells[ACol,ARow] := PrevZoneBudTime;
    end;
  end;
end;

procedure TfrmMODFLOW.sgZondbudTimesExit(Sender: TObject);
var
  RowIndex : integer;
  StressPeriod, TimeStep : integer;
  OK : boolean;
//  AMessage : string;
begin
  // triggering event sgZondbudTimes.OnExit
  inherited;

  // called by btnOKClick;

  // check that stress periods and time steps for Zonebudget specified
  // times are all valid.
  OK := True;
  for RowIndex := 1 to sgZondbudTimes.RowCount -1 do
  begin
    if sgZondbudTimes.Cells[1,RowIndex] = '' then
    begin
      if RowIndex = 1 then
      begin
        sgZondbudTimes.Cells[1,RowIndex] := '1';
      end;
    end
    else
    begin
      try
        begin
          StressPeriod := StrToInt(sgZondbudTimes.Cells[1,RowIndex]);
          if StressPeriod > sgTime.RowCount -1 then
          begin
            OK := False
          end
          else
          begin
            if sgZondbudTimes.Cells[2,RowIndex] = '' then
            begin
              sgZondbudTimes.Cells[2,RowIndex] := '1';
            end;
            TimeStep := StrToInt(sgZondbudTimes.Cells[2,RowIndex]);
            if TimeStep > StrToInt(sgTime.Cells[Ord(tdNumSteps),StressPeriod]) then
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
    if sgZondbudTimes.Cells[2,1] = '' then
    begin
      sgZondbudTimes.Cells[2,1] := '1';
    end
  end;
  If not OK then
  begin
    Beep;
    MessageDLG('You have entered invalid stress or time period data for the '
      + 'ZONEBDGT Specified output times. The last stress period is '
      + IntToStr(sgTime.RowCount -1)
      + '. The last timestep for the '
      + 'last stress period is '
      + sgTime.Cells[sgTime.RowCount -1,Ord(tdNumSteps)], mtError, [mbOK], 0);
    sgZondbudTimes.SetFocus;
  end;
end;

procedure TfrmMODFLOW.sgMOC3DTransParamSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
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
          StrToFloat(sgMOC3DTransParam.Cells[ACol, ARow]);
          PrevMOC3DTransParam := sgMOC3DTransParam.Cells[ACol, ARow];
        end;
      end;
    end;
  except On EConvertError do
    begin
      sgMOC3DTransParam.Cells[ACol, ARow] := PrevMOC3DTransParam;
    end;

  end;

end;

procedure TfrmMODFLOW.sgMOC3DTransParamExit(Sender: TObject);
var
  RowIndex, ColIndex : integer;
begin
  // triggering events sgMOC3DTransParam.OnExit

  // check that no cells have invalid values. Convert Invalid values to '0'.
  inherited;
  For RowIndex := 1 to sgMOC3DTransParam.RowCount -1 do
  begin
    For ColIndex := 1 to sgMOC3DTransParam.ColCount -1 do
    begin
      try
        begin
          StrToFloat(sgMOC3DTransParam.Cells[ColIndex, RowIndex]);
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
  RowIndex, ColIndex : integer;
  ArithmeticAndLogarithmicUsed : boolean;
begin
  // triggering events dgGeol.OnExit
  inherited;
  // make sure the number of columns is correct.
  dgGeol.ColCount := Ord(High(NewUnitData))+1;
  // make sure that vertical discretizations are all integers
  For RowIndex := 1 to dgGeol.RowCount -1 do
  begin
    try
      begin
        if (RowIndex > 1) then
        begin
          if dgGeol.Cells[Ord(nuiType),RowIndex] = dgGeol.Columns[Ord(nuiType)].Picklist[1] then
          begin
            dgGeol.Cells[Ord(nuiType),RowIndex] := dgGeol.Columns[Ord(nuiType)].Picklist[3];
          end;
        end;
        StrToInt(dgGeol.Cells[Ord(nuiVertDisc),RowIndex])
      end;
    except on EConvertError do
      begin
        dgGeol.Cells[Ord(nuiVertDisc),RowIndex] := '1';
      end;
    end;
  end;
  // Convert old data values to new form.
  For RowIndex := 1 to dgGeol.RowCount -1 do
  begin
    if dgGeol.Cells[Ord(nuiType),RowIndex]
      = 'Convertible (3)' then
    begin
      dgGeol.Cells[Ord(nuiType),RowIndex] :=
        dgGeol.Columns[Ord(nuiType)].Picklist.Strings[3]
    end;
    for ColIndex := Ord(nuiSpecT) to Ord(nuiSpecSF1) do
    begin
      if dgGeol.Cells[ColIndex,RowIndex] = '' then
      begin
        dgGeol.Cells[ColIndex,RowIndex]
          := dgGeol.Columns[ColIndex].PickList.Strings[0];
      end;
    end;
  end;

  // Set IAPART if needed.
  ArithmeticAndLogarithmicUsed := false;
  For RowIndex := 1 to dgGeol.RowCount -1 do
  begin
    if dgGeol.Cells[Ord(nuiTrans),RowIndex]
      = dgGeol.Columns[Ord(nuiTrans)].Picklist.Strings[3] then
    begin
      ArithmeticAndLogarithmicUsed := True;
      break;
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
end;

procedure TfrmMODFLOW.rgMOC3DSolverClick(Sender: TObject);
begin
  inherited;
  // make the solver tab visible when appropriate
  tabMOCIMP.TabVisible := (rgMOC3DSolver.ItemIndex = 1) and cbMOC3D.Checked;
  cbMOC3DNoDisp.Enabled := (rgMOC3DSolver.ItemIndex > 0) and cbMOC3D.Checked;
  if not cbMOC3DNoDisp.Enabled then
  begin
    cbMOC3DNoDisp.Checked := False;
  end;
end;

procedure TfrmMODFLOW.btnSaveValClick(Sender: TObject);
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
    end;

end;

procedure TfrmMODFLOW.btnOpenValClick(Sender: TObject);
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
                + 'the MODFLOW/MOC3D PIE. It can not be read by the current '
                + 'version.', mtWarning, [mbOK], 0);
            end
            else
            begin
              // read the data from the file
              LoadModflowForm(UnreadData, AStringList.Text , VersionInString );

              // create lists of geologic units and parameters
              AssociateUnits;
              // Associate lists of time-related parameters with
              // sgTime grid.
              AssociateTimes;
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

  // make sure that the grid titles are correct
  InitializeGrids;

  cbFlowClick(nil);

end;

procedure TfrmMODFLOW.ReadValFile(
   var VersionInString: string; Path : string);
var
  UnreadData: TStringlist;
  AStringList : TStringList;
  Developer : string;
begin
  // called by GProjectNew
  AStringList := TStringList.Create;
  UnreadData := TStringList.Create;
  try
    begin
      AStringList.LoadFromFile(Path);

      LoadModflowForm(UnreadData, AStringList.Text , VersionInString );

      MFLayerStructure.FreeByStatus(sDeleted);
      MFLayerStructure.SetStatus(sNormal);
      MFLayerStructure.UpdateIndicies;
      MFLayerStructure.UpdateOldIndicies;

      AssociateUnits;
      AssociateTimes;
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

procedure TfrmMODFLOW.UpdateMOC3DSubgrid;
var
  GridLayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE ;
  LayerHandle : ANE_PTR;
  AContourList : TContourList;
  AContour : TContour;
  APoint : TZoomPoint;
  X,Y : double;
  AString : string;
  procedure StartContour;
  begin
    AContour := TContour.Create(AContourList);
    AContourList.Add(AContour);
    AContour.Heading.Add('## Name:');
    AContour.Heading.Add('## Icon:0');
    AContour.Heading.Add('# Points Count' + Chr(9) +  'Value');
    AContour.Heading.Add('1');
    APoint := TZoomPoint.Create(AContourList,AContour);
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
    LayerHandle := ANE_LayerGetHandleByName(CurrentModelHandle,
      PChar(ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName));

    // put the contour information on that layer.
    ANE_ImportTextToLayerByHandle(CurrentModelHandle,
      LayerHandle, PChar(AString));
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
    end;
    cbFlowSTR2.Checked := True;
  end; 
end;

procedure TfrmMODFLOW.ReadCTOCH (var LineIndex : integer; FirstList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl);

var
  AText : string;
begin
  // read CTOCH from an old file.
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  cbCHTOCH.Checked := (Pos('CHTOCH',AText)>0);
end;


function TfrmMODFLOW.MOC3DLayerCount: integer;
var
  UnitIndex : integer;
  StartUnit, EndUnit : integer;
begin
  // This function returns the number of MOC3D layers in a model.

  // Initialize result
  result := 0;

  // initialize starting and ending positions of loop
  StartUnit := StrToInt(adeMOC3DLay1.Text);
  EndUnit := StrToInt(adeMOC3DLay2.Text);
  if EndUnit < 0 then
  begin
    EndUnit := dgGeol.RowCount-1
  end;

  // loop over geologic units
  for UnitIndex := StartUnit to EndUnit do
  begin
    // if a geologic unit is simulated, add the vertical discretization of
    // that unit to the total.
    if dgGeol.Cells[Ord(nuiSim),UnitIndex]
      = 'Yes' then
    begin
      result := result + StrToInt(dgGeol.Cells
        [Ord(nuiVertDisc),UnitIndex]);
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
    cbSpecifyFlowFiles.Checked := True;
    cbSpecifyFlowFilesClick(Sender);
  end;
end;

procedure TfrmMODFLOW.comboISTRTChange(Sender: TObject);
begin
  inherited;
  // if initial heads aren't saved, you can't compute drawdown.
  comboDrawdownPrintFreq.Enabled := not (comboExportDrawdown.ItemIndex = 0)
    and (comboISTRT.ItemIndex = 1);

  SetComboColor(comboDrawdownPrintFreq);

  comboDrawdownPrintFreqChange(Sender);

  comboDrawdownExportFreq.Enabled := not (comboExportDrawdown.ItemIndex = 0)
    and (comboISTRT.ItemIndex = 1);

  SetComboColor(comboDrawdownExportFreq);

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
  // if the stringgrid is dgGeol then you should not set the number
  // of columns when reading an old data file.
  if AStringGrid = dgGeol then
  begin
    result := False;
  end;
end;

procedure TfrmMODFLOW.dgGeolDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  LayerType : integer;  
begin
  inherited;
  if (ARow > 0) and (ACol > 0) then
  begin
    // get the type of modflow layer
    LayerType := dgGeol.Columns[Ord(nuiType)].Picklist.
      IndexOf(dgGeol.Cells[Ord(nuiType),ARow]);
    // if the layer type is such that you can not specify T directly,
    // show the cell as disabled.
    if (ACol = Ord(nuiSpecT)) and not ((LayerType = 0) or (LayerType = 2))
    then
      begin
        dgGeol.Canvas.Brush.Color := clBtnFace;
      end
    // show cells as gray for non-simulated units
    else if (ACol > Ord(nuiSim)) and (dgGeol.Columns[Ord(nuiSim)].Picklist.
      IndexOf(dgGeol.Cells[Ord(nuiSim),ARow]) = 0) then
    begin
        dgGeol.Canvas.Brush.Color := clBtnFace;
    end
    // if the cell is in the selected row, make it aqua
    // otherwise make it white.
    else if (ARow = dgGeol.Selection.Top)
    then
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
    dgGeol.Canvas.TextRect(Rect,Rect.Left,Rect.Top,dgGeol.Cells[ACol,ARow]);
    // draw the right and lower cell boundaries in black.
    dgGeol.Canvas.Pen.Color := clBlack;
    dgGeol.Canvas.MoveTo(Rect.Right,Rect.Top);
    dgGeol.Canvas.LineTo(Rect.Right,Rect.Bottom);
    dgGeol.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

procedure TfrmMODFLOW.StreamWarning;
begin
  // warn about incompatibilities between the stream package and MOC3D
  if cbMOC3D.Checked and cbSTR.Checked and not Loading then
  begin
    Beep;
    MessageDlg('Warning: MOC3D and the current version of the '
      + 'Stream Package are incompatible.', mtWarning, [mbOK], 0);
  end
end;

procedure TfrmMODFLOW.rgMOC3DConcFormatClick(Sender: TObject);
begin
  inherited;
  // warn about problems with post processing of binary files.
  if not Loading and not Cancelling and (rgMOC3DConcFormat.ItemIndex = 1) then
  begin
    Beep;
    MessageDlg('The MODFLOW GUI can not currently use this format '
      + 'for post-processing.',mtWarning, [mbOK],0);
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

procedure TfrmMODFLOW.cbAltRivClick(Sender: TObject);
begin
  inherited;
  // set expression for river locations
  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetMFGridRiverParamType,
     ModflowTypes.GetMFGridRiverParamType.ANE_ParamName, True);
end;

procedure TfrmMODFLOW.cbAltDrnClick(Sender: TObject);
begin
  inherited;
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
    (ModflowTypes.GetRechargeLayerType ,
     ModflowTypes.GetMFModflowLayerParamType ,
     cbRechLayer.Checked and cbRCH.Checked and (comboRchOpt.ItemIndex = 1));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType ,
     ModflowTypes.GetMFGridRechLayerParamType ,
     cbRechLayer.Checked and cbRCH.Checked and (comboRchOpt.ItemIndex = 1));
end;

procedure TfrmMODFLOW.comboRchOptChange(Sender: TObject);
var
  RechargeLayer : T_ANE_InfoLayer;
  RechargeElevParam : T_ANE_Param;
begin
  inherited;
  // change the locked values of the recharge elevation parameter.

  cbRechLayer.Enabled := cbRCH.Checked and (comboRchOpt.ItemIndex = 1);
  cbRechLayerClick(Sender);

  if cbRCH.Checked then
  begin
    RechargeLayer := self.MFLayerStructure.UnIndexedLayers.GetLayerByName
      (ModflowTypes.GetRechargeLayerType.ANE_LayerName) as T_ANE_InfoLayer;

    RechargeElevParam := RechargeLayer.ParamList.GetParameterByName
      (ModflowTypes.GetMFRechElevParamType.ANE_ParamName);

    if comboRchOpt.ItemIndex = 1 then
    begin
      RechargeElevParam.Lock := RechargeElevParam.Lock -
        [plDont_Override, plDef_Val, plDontEvalColor];
    end
    else
    begin
      RechargeElevParam.Lock := RechargeElevParam.Lock +
        [plDont_Override, plDef_Val, plDontEvalColor];
    end;
  end;


end;

procedure TfrmMODFLOW.cbETLayerClick(Sender: TObject);
begin
  inherited;
  // add or remove layer and parameter used to explicitely set the
  // layer for evapotranspiration
  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetETLayerType ,
     ModflowTypes.GetMFModflowLayerParamType ,
     cbETLayer.Checked and cbEVT.Checked and (comboEvtOption.ItemIndex = 1));

  MFLayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetGridLayerType ,
     ModflowTypes.GetMFGridETLayerParamType ,
     cbETLayer.Checked and cbEVT.Checked and (comboEvtOption.ItemIndex = 1));

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
    MessageDlg('Warning: The current version of MOC3D and the  '
      + 'Rewetting option are incompatible.', mtWarning, [mbOK], 0);
  end
end;

procedure TfrmMODFLOW.Moc3dTimeWarning;
begin
  // warn about time units and MOC3D
  if cbMOC3D.Checked and (comboTimeUnits.ItemIndex = 0) and not Loading then
  begin
    Beep;
    MessageDlg('Warning: You must specify time units with MOC3D.',
      mtWarning, [mbOK], 0);
  end
end;

procedure TfrmMODFLOW.comboTimeUnitsChange(Sender: TObject);
begin
  inherited;
  // warn about time units and MOC3D
  Moc3dTimeWarning
end;

procedure TfrmMODFLOW.ModelComponentName(AStringList : TStringList);
begin
  AStringList.Add(adeMODFLOWPath.Name);
  AStringList.Add(adeMOC3DPath.Name);
  AStringList.Add(adeZonebudgetPath.Name);
  AStringList.Add(adeMODPATHPath.Name);
end;


procedure TfrmMODFLOW.SetComboColor(ACombo : TComboBox);
begin
  // set the color of combo boxes when they change from enabled to disabled
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
  // all the user to set the age if the MOC3D Age package is used.
  adeAge.Enabled := cbAge.Checked;
end;

procedure TfrmMODFLOW.cbDualPorosityClick(Sender: TObject);
begin
  inherited;
  // enable or disable controls related to the MOC3D Double Porosity package.
{  cbIDPFO.Enabled := cbDualPorosity.Checked;
  cbIDPZO.Enabled := cbDualPorosity.Checked;
  cbIDPTIM.Enabled := cbDualPorosity.Checked;

  // add or remove layers related to the MOC3D Double Porosity package.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCImInitConcLayerType,
     cbMOC3D.Checked and cbDualPorosity.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCImPorosityLayerType,
     cbMOC3D.Checked and cbDualPorosity.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCLinExchCoefLayerType,
     cbMOC3D.Checked and cbDualPorosity.Checked);

  // add or remove parameters related to the Double Porosity package
  cbIDPTIM_DecayClick(Sender);
  cbIDPTIM_GrowthClick(Sender);
//  cbIDPTIMClick(Sender);    }

end;

procedure TfrmMODFLOW.cbSimpleReactionsClick(Sender: TObject);
begin
  inherited;
  // enable or disable controls related to the Simple reactions package
{  cbIDKRF.Enabled := cbSimpleReactions.Checked;
  cbIDKTIM.Enabled := cbSimpleReactions.Checked;
  cbIDKFO.Enabled := cbSimpleReactions.Checked;
  cbIDKFS.Enabled := cbSimpleReactions.Checked;
  cbIDKZO.Enabled := cbSimpleReactions.Checked;
  cbIDKZS.Enabled := cbSimpleReactions.Checked;

  cbIDKRFClick(Sender);

//  cbIDKTIMClick(Sender);
  cbIDKTIM_DisDecayClick(Sender);
  cbIDKTIM_SorbDecayClick(Sender);
  cbIDKTIM_DisGrowthClick(Sender);
  cbIDKTIM_SorbGrowthClick(Sender); }
end;

procedure TfrmMODFLOW.cbIDPFOClick(Sender: TObject);
begin
  inherited;
  // add or remove layers related to the Double porosity package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCDecayCoefLayerType,
     cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPFO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDPZOClick(Sender: TObject);
begin
  inherited;
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
  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
     cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKFO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKFSClick(Sender: TObject);
begin
  inherited;
  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
     cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKFS.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKZOClick(Sender: TObject);
begin
  inherited;
  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
     cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKZO.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDKZSClick(Sender: TObject);
begin
  inherited;
  // add or remove layers related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
     cbMOC3D.Checked and cbSimpleReactions.Checked and cbIDKZS.Checked);

  AssociateTimes;

end;

procedure TfrmMODFLOW.cbIDPTIM_DecayClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

  // enable or disable controls related to the MOC3D Double Porosity package.
{  cbIDPFOClick(Sender);
  cbIDPZOClick(Sender);

  // add or remove parameters related to the Double Porosity package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCLinExchCoefLayerType,
     ModflowTypes.GetMFMOCLinExchCoefParamType,
     cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPTIM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDecayCoefLayerType,
     ModflowTypes.GetMFMOCDecayCoefParamType,
     cbMOC3D.Checked and cbDualPorosity.Checked
     and cbIDPTIM.Checked and cbIDPFO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCGrowthLayerType,
     ModflowTypes.GetMFMOCGrowthParamType,
     cbMOC3D.Checked and cbDualPorosity.Checked
     and cbIDPTIM.Checked and cbIDPZO.Checked);

  AssociateTimes; }

end;

procedure TfrmMODFLOW.cbIDPTIM_GrowthClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

  // enable or disable controls related to the MOC3D Double Porosity package.
{  cbIDPFOClick(Sender);
  cbIDPZOClick(Sender);

  // add or remove parameters related to the Double Porosity package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCLinExchCoefLayerType,
     ModflowTypes.GetMFMOCLinExchCoefParamType,
     cbMOC3D.Checked and cbDualPorosity.Checked and cbIDPTIM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDecayCoefLayerType,
     ModflowTypes.GetMFMOCDecayCoefParamType,
     cbMOC3D.Checked and cbDualPorosity.Checked
     and cbIDPTIM.Checked and cbIDPFO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCGrowthLayerType,
     ModflowTypes.GetMFMOCGrowthParamType,
     cbMOC3D.Checked and cbDualPorosity.Checked
     and cbIDPTIM.Checked and cbIDPZO.Checked);

  AssociateTimes; }

end;

procedure TfrmMODFLOW.cbIDKTIM_DisDecayClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

{  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  // add or remove parameters related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
     ModflowTypes.GetMFMOCDisDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
     ModflowTypes.GetMFMOCSorbDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFS.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
     ModflowTypes.GetMFMOCDisGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
     ModflowTypes.GetMFMOCSorbGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZS.Checked);

  AssociateTimes; }

end;

procedure TfrmMODFLOW.cbIDKTIM_SorbDecayClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

{  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  // add or remove parameters related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
     ModflowTypes.GetMFMOCDisDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
     ModflowTypes.GetMFMOCSorbDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFS.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
     ModflowTypes.GetMFMOCDisGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
     ModflowTypes.GetMFMOCSorbGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZS.Checked);

  AssociateTimes;  }

end;

procedure TfrmMODFLOW.cbIDKTIM_DisGrowthClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

{  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  // add or remove parameters related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
     ModflowTypes.GetMFMOCDisDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
     ModflowTypes.GetMFMOCSorbDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFS.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
     ModflowTypes.GetMFMOCDisGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
     ModflowTypes.GetMFMOCSorbGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZS.Checked);

  AssociateTimes;   }

end;

procedure TfrmMODFLOW.cbIDKTIM_SorbGrowthClick(Sender: TObject);
begin
  inherited;
  // This code will need to change.

{  cbIDKFOClick(Sender);
  cbIDKFSClick(Sender);
  cbIDKZOClick(Sender);
  cbIDKZSClick(Sender);

  // add or remove parameters related to the simple reactions package
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisDecayCoefLayerType,
     ModflowTypes.GetMFMOCDisDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbDecayCoefLayerType,
     ModflowTypes.GetMFMOCSorbDecayCoefParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKFS.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCDisGrowthLayerType,
     ModflowTypes.GetMFMOCDisGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZO.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFMOCSorbGrowthLayerType,
     ModflowTypes.GetMFMOCSorbGrowthParamType,
     cbMOC3D.Checked and cbSimpleReactions.Checked
       and cbIDKTIM.Checked and cbIDKZS.Checked);

  AssociateTimes;  }

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
//  Extension : string;
//  WarningMessage : String;
  rootName : string;
  DotPosition : integer;
begin
  inherited;
  OpenDialog1.Filter := 'binary head files (*.bhd)|*.bhd|All Files (*.*)|*.*';
  if OpenDialog1.Execute then
  begin
    rootName := ExtractFileName(OpenDialog1.FileName);
    edInitial.Text := rootName;
    DotPosition := Pos('.', rootName);
    if DotPosition > 0 then
    begin
      rootName := Copy(rootName, 1, DotPosition-1);
    end;
{    Extension := LowerCase(ExtractFileExt(OpenDialog1.FileName));
    if ((Extension = '.fhd') and rbInitialBinary.Checked) or
       ((Extension = '.bhd') and rbInitialFormatted.Checked) then
    begin

      WarningMessage := 'The extension of your file (' + Extension
        + ') appears to indicate that it is a ';
      if (Extension = '.bhd') then
      begin
        WarningMessage := WarningMessage + 'binary ';
      end
      else
      begin
        WarningMessage := WarningMessage + 'formatted ';
      end;
      WarningMessage := WarningMessage + 'head file. Is that correct?';

      Beep;
      if MessageDlg(WarningMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        if rbInitialBinary.Checked then
        begin
          rbInitialFormatted.Checked := True;
        end
        else
        begin
          rbInitialBinary.Checked := True;
        end;
      end;
    end
    else if not ((Extension = '.fhd') or (Extension = '.bhd')) then
    begin
      Beep;
      MessageDlg('Don''t forget to set the file type to binary or formatted.',
        mtInformation, [mbOK], 0);
    end;}
    if LowerCase(rootName) = LowerCase(adeFileName.Text) then
    begin
      Beep;
      MessageDlg('Error: The rootname for MODFLOW simulation files (' +
        adeFileName.Text + ') has the same root as the file you have choosen ('
        + edInitial.Text + '). You should correct this before running MODFLOW.',
        mtError, [mbOK],0);
    end;
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
end;



end.
