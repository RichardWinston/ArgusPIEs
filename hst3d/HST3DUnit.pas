unit HST3DUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math,
  StdCtrls, Buttons, ComCtrls, ArgusDataEntry, ExtCtrls,
  OleCtrls, {isp3,} Grids, ProjectPIE, AnePIE, ANECB, ANE_LayerUnit,
  HST3DLayerStructureUnit, Menus, RotationCalculator,
   ASLink, {z_label,} Strset {, RegisterApp};

type
  THST3DForm = class(TForm)
    PageControl1: TPageControl;
    tabProject: TTabSheet;
    edTitleLine1: TEdit;                       //1.1 Title line 1
    edTitleLine2: TEdit;                       //1.2 Title line 2
    cbRestart: TCheckBox;                      //1.3 RESTRT
    lblTime: TLabel;                           //1.4 SOLUTE
    tabBound: TTabSheet;
    rgUnits: TRadioGroup;                      //1.4 SCALMF
    rgTimeUnits: TRadioGroup;                  //1.5 TMUNIT
    cbTiltCoord: TCheckBox;                    //2.3.1 TILT
    lblThetxz: TLabel;
    lblThetyz: TLabel;
    lblThetzz: TLabel;
    adeTime: TArgusDataEntry;                  //1.3 TIMRST
    adeThetxz: TArgusDataEntry;                //2.3.2 THETXZ
    adeThetyz: TArgusDataEntry;                //2.3.2 THETYZ
    adeThetzz: TArgusDataEntry;                //2.3.2 THETZZ
    tabFluidProp: TTabSheet;
    adeCompress: TArgusDataEntry;
    adeRefPres: TArgusDataEntry;               //2.4.2 P0
    adeRefTemp: TArgusDataEntry;               //2.4.2 T0
    adeRefMassFrac: TArgusDataEntry;           //2.4.2 W0
    adeFluidDensity: TArgusDataEntry;          //2.4.2 DENF0
    adeMaxMassFrac: TArgusDataEntry;           //2.4.3 W1
    adeFluidDenseMax: TArgusDataEntry;
    Label3: TLabel;
    Label4: TLabel;
    lblMaxMassFrac: TLabel;
    adeVisMultFact: TArgusDataEntry;           //2.4.4 VISFAC if VISFAC is positive
    adeViscosity: TArgusDataEntry;             //2.4.4 VISFAC if VISFAC is negative
    lblVisMultFact: TLabel;
    lblViscosity: TLabel;
    rgViscMeth: TRadioGroup;                   //2.4.4 determines whether VISFAC is positive or negative
    tabRefTherm: TTabSheet;
    adeAtmPres: TArgusDataEntry;               //2.5.1 PAATM
    adeRefPresEnth: TArgusDataEntry;           //2.5.2 P0H
    adeRefTempEnth: TArgusDataEntry;           //2.5.2 T0H
    adeFluidHeatCap: TArgusDataEntry;          //2.6 CPF
    adeFluidThermCond: TArgusDataEntry;        //2.6 KHTF
    adeFluidCoefExp: TArgusDataEntry;
    Label10: TLabel;
    lblFluidHeatCap: TLabel;
    lblFluidThermCond: TLabel;
    adeEffMolDiff: TArgusDataEntry;            //2.7 DM
    adeSolDecConst: TArgusDataEntry;           //2.7 DECLAM
    lblEffMolDiff: TLabel;
    lblSolDecConst: TLabel;
    tabWellRiser: TTabSheet;
    adeMaxIterWell: TArgusDataEntry;           //2.13.7 MXITQW
    adeTolWell: TArgusDataEntry;               //2.13.7 TOLDPW
    adeTolFracPresWell: TArgusDataEntry;       //2.13.7 TOLFPW
    adeTolFracFlowWell: TArgusDataEntry;       //2.13.7 TOLFQW
    adeDampWell: TArgusDataEntry;              //2.13.7 DAMWRC
    adeMinStepWell: TArgusDataEntry;           //2.13.7 DZMIN
    adeFracTolIntWell: TArgusDataEntry;
    lblMaxIterWell: TLabel;
    lblTolWell: TLabel;
    lblTolFracPresWell: TLabel;
    lblTolFracFlowWell: TLabel;
    lblDampWell: TLabel;
    lblMinStepWell: TLabel;
    lblFracTolIntWell: TLabel;
    tabAqInfl: TTabSheet;
    rgAqInflChoice: TRadioGroup;               //2.18.3 IAIF
    adeBulkCompOut: TArgusDataEntry;           //2.18.4A and 2.18.4B ABOAR
    adePorOut: TArgusDataEntry;                //2.18.4A and 2.18.4B POROAR
    adeVolOut: TArgusDataEntry;                //2.18.4A VOAR
    adePermOut: TArgusDataEntry;               //2.18.4B KOAR
    adeViscOut: TArgusDataEntry;               //2.18.4B VISOAR
    adeThickOut: TArgusDataEntry;              //2.18.4B BOAR
    adeRadius: TArgusDataEntry;                //2.18.4B RIOAR
    adeAngInflOut: TArgusDataEntry;            //2.18.4B ANGOAR
    lblBulkCompOut: TLabel;
    lblPorOut: TLabel;
    lblVolOut: TLabel;
    lblPermOut: TLabel;
    lblViscOut: TLabel;
    lblThickOut: TLabel;
    lblRadius: TLabel;
    lblAngInflOut: TLabel;
    tabInitCond: TTabSheet;                     //2.20 FRESUR
    cbSpecInitPres: TCheckBox;                 //2.21.1 ICHYDP
    cbInitWatTable: TCheckBox;                 //2.21.2 ICHWT
    adeElevInitPres: TArgusDataEntry;          //2.21.3A ZPINIT
    adeInitPres: TArgusDataEntry;              //2.21.3A PINIT
    lblElevInitPres: TLabel;
    lblInitPres: TLabel;
    tabSolver: TTabSheet;
    adeSpatDiscFac: TArgusDataEntry;           //2.22.1 FDSMTH
    adeTempDiscFact: TArgusDataEntry;          //2.22.1 FDTMTH
    adeTolFracDens: TArgusDataEntry;           //2.22.2 TOLDEN
    adeMaxIter: TArgusDataEntry;               //2.22.2 MAXITN
    adeNumTime: TArgusDataEntry;               //2.22.3 NTSOPT
    adeTolerance: TArgusDataEntry;             //2.22.3 and 2.22.4 EPSSLV
    adeTolerance2: TArgusDataEntry;            //2.22.3 EPSOMG
    adeMaxIt1: TArgusDataEntry;                //2.22.3 MAXIT1
    adeMaxIt2: TArgusDataEntry;                //2.22.3 and 2.22.4 MAXIT2
    adeNumSteps: TArgusDataEntry;              //2.22.4 NSDR
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    lblNumTime: TLabel;
    lblTolerance: TLabel;
    lblTolerance2: TLabel;
    lblMaxIt1: TLabel;
    lblMaxIt2: TLabel;
    lblRenumDir: TLabel;
    lblIORDER: TLabel;
    lblNumSteps: TLabel;
    comboRenumDir: TComboBox;                   //2.22.4 IDIR
    comboIORDER: TComboBox;
    tabOutput: TTabSheet;
    cbPriPorous: TCheckBox;                     //2.23.1 PRTPMP
    cbPrFluidProp: TCheckBox;                   //2.23.1 PRTFP
    cbPrInit: TCheckBox;                        //2.23.1 PRTIC
    cbPrStat: TCheckBox;                        //2.23.1 PRTBC
    cbPrSolMeth: TCheckBox;                     //2.23.1 PRTSLM
    cbPrStatWell: TCheckBox;                    //2.23.1 PRTWEL
    cbPrDensVisc: TCheckBox;                    //2.23.1 PRTDV
    comboPrPres: TComboBox;                     //2.23.2 IRPTC, first digit
    comboPrTemp: TComboBox;                     //2.23.2 IRPTC, second digit
    comboPrMassFr: TComboBox;                   //2.23.2 IRPTC, third digit
    lblPrPres: TLabel;
    lblPrTemp: TLabel;
    lblPrMassFr: TLabel;
    comboPrOrientation: TComboBox;              //2.23.3 OPENPR
    lblPrOrientation: TLabel;
    cbPrPorZone: TCheckBox;                     //2.23.4 PLTZON
    cbPrPostProc: TCheckBox;
    tabTime: TTabSheet;
    sgSolver: TStringGrid;
    rgSolutionMethod: TRadioGroup;              //1.8 SLMETH
    tabAbout: TTabSheet;
    Label21: TLabel;
    lblDevName: TLabel;
    Label26: TLabel;
    lblAdress: TLabel;
    lblCity: TLabel;
    lblTelephone: TLabel;
    lblVersion: TLabel;
    EdVersion: TEdit;
    lblAquiferInflZoneW: TLabel;
    comboAquiferInflZoneW: TComboBox;
    tabHeat: TTabSheet;
    rgCoord: TRadioGroup;
    rgMassFrac: TRadioGroup;
    tabProblem: TTabSheet;
    memoUnreadData: TMemo;
    tabGeology: TTabSheet;
    sgGeology: TStringGrid;
    GroupBox1: TGroupBox;
    cbHeat: TCheckBox;
    cbSolute: TCheckBox;
    GroupBox2: TGroupBox;
    cbSpecPres: TCheckBox;
    cbSpecTemp: TCheckBox;
    cbSpecMass: TCheckBox;
    cbSpecFlow: TCheckBox;
    cbSpecHeat: TCheckBox;
    cbSpecSolute: TCheckBox;
    cbLeakage: TCheckBox;
    cbET: TCheckBox;
    cbAqInfl: TCheckBox;
    cbHeatCond: TCheckBox;
    cbWells: TCheckBox;
    cbFreeSurf: TCheckBox;
    pnlInitialHeatCondBoundNodeN: TPanel;
    sgHeatCondBoundInitialCond: TStringGrid;
    pnlHeatCondBoundNodeN: TPanel;
    sgHeatCondBoundNodeSpacing: TStringGrid;
    Panel1: TPanel;
    Panel3: TPanel;
    edMaxTimes: TEdit;
    lblMaxTimes: TLabel;
    btnAddTime: TButton;
    btnDelTime: TButton;
    btnInsertTime: TButton;
    Panel4: TPanel;
    btnAddLayer: TButton;
    btnDeleteLayer: TButton;
    btnInsertLayer: TButton;
    edNumLayers: TEdit;
    lblNumLayers: TLabel;
    Panel2: TPanel;
    lblHeatCondBoundNodeN: TLabel;
    edHeatCondBoundNodeN: TEdit;
    Panel5: TPanel;
    lblInitialHeatCondBoundNodeN: TLabel;
    edInitialHeatCondBoundNodeN: TEdit;
    cbRiver: TCheckBox;
    Label6: TLabel;
    edExtension: TEdit;
    Label14: TLabel;
    edInput: TEdit;
    Label15: TLabel;
    edPath: TEdit;
    Label20: TLabel;
    btnBrowseHST3D: TButton;
    rgExportDecision: TRadioGroup;
    cbWellRiser: TCheckBox;
    Panel6: TPanel;
    btnLoad: TButton;
    btnSaveDefault: TButton;
    BitBtnCancel: TBitBtn;
    BitBtnOK: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    tabInterpolation: TTabSheet;
    cbSpecFlowInterp: TCheckBox;
    cbSpecHeatInterp: TCheckBox;
    cbSpecSoluteInterp: TCheckBox;
    cbLeakageInterp: TCheckBox;
    cbRiverInterp: TCheckBox;
    cbETInterp: TCheckBox;
    cbAqInflInterp: TCheckBox;
    cbHeatCondInterp: TCheckBox;
    cbSpecPresInterp: TCheckBox;
    cbSpecTempInterp: TCheckBox;
    cbSpecMassInterp: TCheckBox;
    lblInterpAqLeak: TLabel;
    lblInterpRiver: TLabel;
    lblInterpAqInfl: TLabel;
    lblInterpET: TLabel;
    lblInterpHeatCond: TLabel;
    gbInterpSpecPres: TGroupBox;
    cbInterpSpecPres: TCheckBox;
    cbInterpTempSpecPres: TCheckBox;
    cbInterpMassSpecPress: TCheckBox;
    cbInterpScMassFracSpecPres: TCheckBox;
    Label23: TLabel;
    cbHeatInterpInit: TCheckBox;
    cbSoluteInterpInitial: TCheckBox;
    cbWatTableInitialInterp: TCheckBox;
    cbInitPresInterp: TCheckBox;
    bitbtnHelp: TBitBtn;
    Label7: TLabel;
    tabBCFLOW: TTabSheet;
    cbUseBCFLOW: TCheckBox;
    Label12: TLabel;
    cbBCFLOWUseSpecState: TCheckBox;
    cbBCFLOWUseSpecFlux: TCheckBox;
    cbBCFLOWUseLeakage: TCheckBox;
    cbBCFLOWUseAqInfl: TCheckBox;
    cbBCFLOWUseHeatCond: TCheckBox;
    cbBCFLOWUseET: TCheckBox;
    edBCFLOWPath: TEdit;
    Label13: TLabel;
    btnBrowseBCFLOW: TButton;
    adeBCFLOWTitle1: TArgusDataEntry;
    adeBCFLOWTitle2: TArgusDataEntry;
    lblBCFLOWTitle1: TLabel;
    lblBCFLOWTitle2: TLabel;
    rgAngleChoice: TRadioGroup;
    gbInterpSpecFlux: TGroupBox;
    cbFluidFluxInterp: TCheckBox;
    cbFluxDensityInterp: TCheckBox;
    cbFluxTempInterp: TCheckBox;
    cbFluxScMassFracInterp: TCheckBox;
    cbFluxMassFracInterp: TCheckBox;
    cbPauseDos: TCheckBox;
    StatusBar1: TStatusBar;
    Label11: TLabel;
    Splitter1: TSplitter;
    tabWells: TTabSheet;
    Panel7: TPanel;
    Panel8: TPanel;
    sgWellTime: TStringGrid;
    Splitter2: TSplitter;
    sgWellCompletion: TStringGrid;
    adeWellTop: TArgusDataEntry;
    adeWellBottom: TArgusDataEntry;
    adeWellOD: TArgusDataEntry;
    adeWellMethod: TArgusDataEntry;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    edWellElements: TEdit;
    adeWellLength: TArgusDataEntry;
    adeWellRiseID: TArgusDataEntry;
    adeWellRough: TArgusDataEntry;
    adeWellAngle: TArgusDataEntry;
    adeHeatTransf: TArgusDataEntry;
    adeWellRiseDiff: TArgusDataEntry;
    adeWellRiseCondMedium: TArgusDataEntry;
    adeWellRiseCondPipe: TArgusDataEntry;
    adeWellBotTemp: TArgusDataEntry;
    adeWellTopTemp: TArgusDataEntry;
    lblWellLength: TLabel;
    lblWellRiseID: TLabel;
    lblWellRough: TLabel;
    lblWellAngle: TLabel;
    lblHeatTransf: TLabel;
    lblWellRiseDiff: TLabel;
    lblWellRiseCondMedium: TLabel;
    lblWellRiseCondPipe: TLabel;
    lblWellBotTemp: TLabel;
    lblWellTopTemp: TLabel;
    PopupMenu1: TPopupMenu;
    Help1: TMenuItem;
    Label24: TLabel;
    ASLinkWinston: TASLink;
    lblIntDev: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    ASLinkKipp: TASLink;
    ASLinkFAQ: TASLink;
    lblGuiFaq: TLabel;
    lblFluidCoefExp: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblFluidDenseMax: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cbObsElev: TCheckBox;
    StrSet1: TStrSet;
    Label43: TLabel;
    ASLink2: TASLink;
    procedure cbRestartClick(Sender: TObject);
    procedure cbTiltCoordClick(Sender: TObject);
    procedure rgCoordClick(Sender: TObject);
    procedure cbSoluteClick(Sender: TObject);
    procedure rgViscMethClick(Sender: TObject);
    procedure cbHeatClick(Sender: TObject);
    procedure cbWellsClick(Sender: TObject);
    procedure cbAqInflClick(Sender: TObject);
    procedure rgAqInflChoiceClick(Sender: TObject);
    procedure cbFreeSurfClick(Sender: TObject);
    procedure cbSpecInitPresClick(Sender: TObject);
    procedure rgSolutionMethodClick(Sender: TObject);
    procedure cbPrInitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddTimeClick(Sender: TObject);
    procedure sgSolverSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure sgSolverSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnDelTimeClick(Sender: TObject);
    procedure btnInsertTimeClick(Sender: TObject);
    procedure sgSolverDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure edTitleLinesChange(Sender: TObject);
    procedure cbHeatCondClick(Sender: TObject);
    procedure edHeatCondBoundNodeNChange(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure sgHeatCondBoundNodeSpacingSelectCell(Sender: TObject; Col,
      Row: Integer; var CanSelect: Boolean);
    procedure sgHeatCondBoundNodeSpacingSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure sgHeatCondBoundNodeSpacingDrawCell(Sender: TObject; Col,
      Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure btnSaveDefaultClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sgGeologySelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure sgGeologySetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnAddLayerClick(Sender: TObject);
    procedure btnDeleteLayerClick(Sender: TObject);
    procedure btnInsertLayerClick(Sender: TObject);
    procedure edNumLayersChange(Sender: TObject);
    procedure sgGeologyDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbWellRiserClick(Sender: TObject);
    procedure sgHeatCondBoundInitialCondDrawCell(Sender: TObject;
  Col, Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgHeatCondBoundInitialCondSelectCell(Sender: TObject;
  Col, Row: Integer; var CanSelect: Boolean);
    procedure sgHeatCondBoundInitialCondSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: String);
    procedure edInitialHeatCondBoundNodeNChange(Sender: TObject);
    procedure edHeatCondBoundNodeNExit(Sender: TObject);
    procedure edInitialHeatCondBoundNodeNExit(Sender: TObject);
    procedure sgSolverExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbSpecPresClick(Sender: TObject);
    procedure cbSpecFlowClick(Sender: TObject);
    procedure cbLeakageClick(Sender: TObject);
    procedure cbRiverClick(Sender: TObject);
    procedure cbETClick(Sender: TObject);
    procedure sgGeologyExit(Sender: TObject);
    procedure cbInitWatTableClick(Sender: TObject);
    procedure rgMassFracClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure comboAquiferInflZoneWChange(Sender: TObject);
    procedure edExtensionChange(Sender: TObject);
    procedure edExtensionExit(Sender: TObject);
    procedure edInputExit(Sender: TObject);
    procedure btnBrowseHST3DClick(Sender: TObject);
    procedure edPathChange(Sender: TObject);
    procedure cbSpecPresInterpClick(Sender: TObject);
    procedure cbInterpSpecPresClick(Sender: TObject);
    procedure cbInterpTempSpecPresClick(Sender: TObject);
    procedure cbInterpMassSpecPressClick(Sender: TObject);
    procedure cbInterpScMassFracSpecPresClick(Sender: TObject);
    procedure cbSpecTempInterpClick(Sender: TObject);
    procedure cbSpecMassInterpClick(Sender: TObject);
    procedure cbInitPresInterpClick(Sender: TObject);
    procedure bitbtnHelpClick(Sender: TObject);
    procedure adeRefTempExit(Sender: TObject);
    procedure sgHeatCondBoundInitialCondExit(Sender: TObject);
    procedure btnBrowseBCFLOWClick(Sender: TObject);
    procedure cbUseBCFLOWClick(Sender: TObject);
    procedure edBCFLOWPathChange(Sender: TObject);
    procedure cbBCFLOWParameterClick(Sender: TObject);
    procedure rgAngleChoiceClick(Sender: TObject);
    procedure adeThetExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbWatTableInitialInterpClick(Sender: TObject);
    procedure cbSpecFlowInterpClick(Sender: TObject);
    procedure cbFluidFluxInterpClick(Sender: TObject);
    procedure cbFluxDensityInterpClick(Sender: TObject);
    procedure cbFluxTempInterpClick(Sender: TObject);
    procedure cbFluxMassFracInterpClick(Sender: TObject);
    procedure cbFluxScMassFracInterpClick(Sender: TObject);
    procedure cbPauseDosClick(Sender: TObject);
    procedure sgSolverMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure rgUnitsClick(Sender: TObject);
    procedure edMaxTimesEnter(Sender: TObject);
    procedure edMaxTimesExit(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ASLinkWinstonClick(Sender: TObject);
    procedure ASLinkKippClick(Sender: TObject);
    procedure cbObsElevClick(Sender: TObject);
  private
    procedure W01Warning;
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    strLastTime : String;
    PreviousTimeColumn, PreviousTimeRow : Integer;
    CurrentTimeCellText : String;
    PrevNumHeatNodes : string;
    PrevNumInitHeatNodes : string;
    CurrentHeatNodeDistance : string;
    LastGeologyText : string;
//    CurrentGeologyRow : integer;
    PreviousNumberLayersText : string;
    LayerStructure : THST3DLayerStructure;
    LastGeologyButton : TButton;
    FormHeight : integer;
    FormTop : integer;
    frmRotation : TfrmRotation;

    function Autots(Column : Integer) : boolean;
    function Deltim(Column : Integer) : double;
    function Dptas(Column : Integer) : double;
    function Dttas(Column : Integer) : double;
    function Dctas(Column : Integer) : double;
    function Dtimmn(Column : Integer) : double;
    function Dtimmx(Column : Integer) : double;
    function Timchg(Column : Integer) : double;
    function MaxSolverTimes : integer;

    function fPrislm(Column : Integer) : integer;
    function fPrikd(Column : Integer) : integer;
    function fPriptc(Column : Integer) : integer;
    function fPridv(Column : Integer) : integer;
    function fPrivel(Column : Integer) : integer;
    function fPrigfb(Column : Integer) : integer;
    function fPribcf(Column : Integer) : integer;
    function fPriwel(Column : Integer) : integer;
    function fIprptc(Column : Integer) : integer;
    function fChkptd(Column : Integer) : boolean;
    function fPricpd(Column : Integer) : integer;
    function fSavldo(Column : Integer) : boolean;
    function fCntmap(Column : Integer) : boolean;
    function fVecmap(Column : Integer) : boolean;
    function fPrimap(Column : Integer) : integer;

    function TopElevation(AUnit : Integer) : double;
    function BottomElevation(AUnit : Integer) : double;
    function CellTopElevation(ANodeLayer : Integer) : double;
    function CellBottomElevation(ANodeLayer : Integer) : double;
    function HeatBoundNodeLocation(ANode : Integer) : double;
    function InitialHeatBoundNodeLocation(ANode : Integer) : double;
    function InitialHeatBoundNodeTemperature(ANode : Integer) : double;
    function FormToString(Sender: THST3DForm) : string;
    function ReplaceValues(Sender: THST3DForm; AStringList : TStringList)
      : string;
    procedure StringToForm(AString : String; Sender: THST3DForm);
    procedure MakeNamesUnique;
    procedure AddSpecStatSoluteParameters;
    procedure AddSpecFluxSoluteParameters;
    procedure AddGridSoluteParameters;
    procedure AddGridHeatOrSoluteParameters;
    procedure AddAquifLeakSoluteParameters;
    procedure AddAquifInflSoluteParameters;
    procedure AddDistCoefSoluteLayers;
    procedure AddDispHeatSoluteLayers;
    procedure AddInitMassFracSoluteLayers;
    procedure AddWellRiserHeatParameters;
    procedure AddGridHeatParameters;
    procedure AddSpecStatHeatParameters;
    procedure AddSpecFluxHeatParameters;
    procedure AddAquifLeakHeatParameters;
    procedure AddAquifInflHeatParameters;
    procedure AddInitTempHeatLayers;
    procedure AddHeatCapThermCondHeatLayers;
    procedure AddWellRiserTimeHeatParameters;
    procedure AddWellRiserParameters;
    procedure AddSpecStatPresParameters;
    procedure AddSpecFluxParameters;
    procedure AddInitPressLayer;
    procedure AddInitWatTable;
    procedure AddSpecFluxMassFracPar;
    procedure AddMassFracPar;
    procedure AddInitMassFracPar;
    procedure AddWellTimeSoluteParameters;
    function GetZ(Row : Integer) : double;
    procedure Load(FormString : string; Sender: TObject);
    procedure AddRiverMassFracPar;
    procedure IntializeGrids;
    procedure ActivateWellParam;
    procedure ActivateWellHeatParam;
    function IsRegistered: boolean;
    { Public declarations }
  end;

type THeatBoundLocation = Class(TObject)
  Text : String;
  Value : Double;
  end;

type SelectedRow = ( StartTime, Duration,
     EndTime, Automatic, TimeStepLength, MaxChangePres,
     MaxChangeTemp, MaxChangeMassFrac, MinTimeStep, MaxTimeStep,
     PrISolMeth, PrICondDisp, PrIPresTempMass, PrIFlDens, PrIVel, PrIFlowBal,
     PrISpecValFlow, PrIWell, IPRPTCn1, IPRPTCn2, IPRPTCn3, CheckPointDump,
     PrICheckPointDump, SavLastDump, ContourMap, VelocityVectorMap, PriMaps);

type GeologyData = (gdUnitNum, gdName, gdTopElev, gdBotElev);
type CoordinateSystem = (csCartesian, csCylindrical);
type WellElementParam = (weNum, weName, weCompletion, weSkinfactor);
type WellTimeParam = (wtTime, wtFlow, wtSurfPres, wtDatumPres, wtTemp, wtMassFrac);

{var
  HST3DForm: THST3DForm; }

implementation

{$R *.DFM}

uses ShellAPI, FileCtrl, CoordUnit, HST3D_PIE_Unit, runUnit, ProgressUnit,
  HST3DWellLayers, HST3DSpecifiedStateLayers, HST3DGeologyLayerList,
  HST3DSpecifiedFluxLayers, HST3DAquifLeakageLayers, HST3DRiverLayers,
  HST3DEvapotranspirationLayers, HST3DAquifInflLayers, HST3DHeatCondLayers,
  HST3DInitialWatTabLayers, HST3DGeneralParameters, HST3DGridLayer,
  HST3DDistCoefLayers, HST3DDispersivityLayers, HST3DInitialMassFracLayers,
  HST3DInitialTemp, HST3DHeatCapacityLayers, HST3DThermCondLayers,
  HST3DInitialPressureLayers, HST3DBCFLOWUnit, UtilityFunctions, ShowHelpUnit,
  conversionsUnit, HST3DObservationElevations, ConserveResourcesUnit;


type PrintPresChoice = (ppcNone, ppcPressure, ppcPressureAndHead);
type PrintTempChoice = (ptcNone, ptcTemperature, ptcTemperatureAndEnthalpy);
type PrintMassFracChoice = (pmfcNone, pmfcMassFraction);
type OrientationChoice = (ocHorizontal, ocVertical);
type RenumberingDirection = (xyz, xzy, yxz, yzx, zxy, zyx);
type PreconditioningChoice = (pcStandard, pcModified);
type ModelUnits = (muMetric, muCustomary);
type MassFraction = (csUnscaled, csScaled);
type AquifInfChoice = (aiPot, aiTrans);
type AquifInfZoneWeighting = (aizwDefault, aizwUser);


procedure THST3DForm.ActivateWellParam;
begin
//  Activate well parameters for cylindrical coordinates
end;

procedure THST3DForm.ActivateWellHeatParam;
begin
//  Activate well parameters for cylindrical coordinates
end;

procedure THST3DForm.rgUnitsClick(Sender: TObject);
var
  RowIndex, ColIndex : integer;
begin
  self.LayerStructure.SetAllParamUnits;
  if rgUnits.ItemIndex = 0
  then // US customary to metric
    begin
      for RowIndex := 1 to sgGeology.RowCount -1 do
      begin
        sgGeology.Cells[Ord(gdTopElev),RowIndex]
          := FloatToStr(ft2m(LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),RowIndex])));
        sgGeology.Cells[Ord(gdBotElev),RowIndex]
          := FloatToStr(ft2m(LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev),RowIndex])));
      end;
      adeCompress.Text := FloatToStr(Invpsi2InvPa(LocalStrToFloat(adeCompress.Text)));
      adeRefPres.Text := FloatToStr(psi2Pa(LocalStrToFloat(adeRefPres.Text)));
      adeRefTemp.Text := FloatToStr(F2C(LocalStrToFloat(adeRefTemp.Text)));
      adeFluidDensity.Text := FloatToStr(lb_per_cuft_2_kg_per_cum(LocalStrToFloat(adeFluidDensity.Text)));
      adeFluidDenseMax.Text := FloatToStr(lb_per_cuft_2_kg_per_cum(LocalStrToFloat(adeFluidDenseMax.Text)));
      adeViscosity.Text := FloatToStr(cP2Pas(LocalStrToFloat(adeViscosity.Text)));
      adeAtmPres.Text := FloatToStr(psi2Pa(LocalStrToFloat(adeAtmPres.Text)));
      adeRefPresEnth.Text := FloatToStr(psi2Pa(LocalStrToFloat(adeRefPresEnth.Text)));
      adeRefTempEnth.Text := FloatToStr(F2C(LocalStrToFloat(adeRefTempEnth.Text)));
      adeFluidHeatCap.Text := FloatToStr(BTU_per_lbF_2_J_per_kgC(LocalStrToFloat(adeFluidHeatCap.Text)));
      adeFluidThermCond.Text := FloatToStr(BTU_per_fthrF_2_W_per_mC(LocalStrToFloat(adeFluidThermCond.Text)));
      adeFluidCoefExp.Text := FloatToStr(InvF2InvC(LocalStrToFloat(adeFluidCoefExp.Text)));
      adeElevInitPres.Text := FloatToStr(ft2m(LocalStrToFloat(adeElevInitPres.Text)));
      adeInitPres.Text := FloatToStr(ft2m(LocalStrToFloat(adeInitPres.Text)));
      for ColIndex := 1 to sgSolver.ColCount -1 do
      begin
        sgSolver.Cells[ColIndex, Ord(MaxChangePres)]
          := FloatToStr(psi2Pa(LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(MaxChangePres)])));
        sgSolver.Cells[ColIndex, Ord(MaxChangeTemp)]
          := FloatToStr(LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(MaxChangeTemp)])*5/9);
      end;
      for RowIndex := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
      begin
        sgHeatCondBoundNodeSpacing.Cells[1,RowIndex]
          := FloatToStr(ft2m(LocalStrToFloat(sgHeatCondBoundNodeSpacing.Cells[1,RowIndex])));
      end;
      for RowIndex := 1 to sgHeatCondBoundInitialCond.RowCount -1 do
      begin
        sgHeatCondBoundInitialCond.Cells[1,RowIndex]
          := FloatToStr(ft2m(LocalStrToFloat(sgHeatCondBoundInitialCond.Cells[1,RowIndex])));
        sgHeatCondBoundInitialCond.Cells[2,RowIndex]
          := FloatToStr(F2C(LocalStrToFloat(sgHeatCondBoundInitialCond.Cells[2,RowIndex])));
      end;
      adeTolWell.Text := FloatToStr(psi2Pa(LocalStrToFloat(adeTolWell.Text)));
      adeMinStepWell.Text := FloatToStr(ft2m(LocalStrToFloat(adeMinStepWell.Text)));
    end
  else // metric to US customary
    begin
      for RowIndex := 1 to sgGeology.RowCount -1 do
      begin
        sgGeology.Cells[Ord(gdTopElev),RowIndex]
          := FloatToStr(m2Ft(LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),RowIndex])));
        sgGeology.Cells[Ord(gdBotElev),RowIndex]
          := FloatToStr(m2Ft(LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev),RowIndex])));
      end;
      adeCompress.Text := FloatToStr(InvPa2Invpsi(LocalStrToFloat(adeCompress.Text)));
      adeRefPres.Text := FloatToStr(Pa2psi(LocalStrToFloat(adeRefPres.Text)));
      adeRefTemp.Text := FloatToStr(C2F(LocalStrToFloat(adeRefTemp.Text)));
      adeFluidDensity.Text := FloatToStr(kg_per_cum_2_lb_per_cuft(LocalStrToFloat(adeFluidDensity.Text)));
      adeFluidDenseMax.Text := FloatToStr(kg_per_cum_2_lb_per_cuft(LocalStrToFloat(adeFluidDenseMax.Text)));
      adeViscosity.Text := FloatToStr(Pas2cP(LocalStrToFloat(adeViscosity.Text)));
      adeAtmPres.Text := FloatToStr(Pa2psi(LocalStrToFloat(adeAtmPres.Text)));
      adeRefPresEnth.Text := FloatToStr(Pa2psi(LocalStrToFloat(adeRefPresEnth.Text)));
      adeRefTempEnth.Text := FloatToStr(C2F(LocalStrToFloat(adeRefTempEnth.Text)));
      adeFluidHeatCap.Text := FloatToStr(J_per_kgC_2_BTU_per_lbF(LocalStrToFloat(adeFluidHeatCap.Text)));
      adeFluidThermCond.Text := FloatToStr(W_per_mC_2_BTU_per_fthrF(LocalStrToFloat(adeFluidThermCond.Text)));
      adeFluidCoefExp.Text := FloatToStr(InvC2InvF(LocalStrToFloat(adeFluidCoefExp.Text)));
      adeElevInitPres.Text := FloatToStr(m2Ft(LocalStrToFloat(adeElevInitPres.Text)));
      adeInitPres.Text := FloatToStr(m2Ft(LocalStrToFloat(adeInitPres.Text)));
      for ColIndex := 1 to sgSolver.ColCount -1 do
      begin
        sgSolver.Cells[ColIndex, Ord(MaxChangePres)]
          := FloatToStr(Pa2psi(LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(MaxChangePres)])));
        sgSolver.Cells[ColIndex, Ord(MaxChangeTemp)]
          := FloatToStr(LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(MaxChangeTemp)])*9/5);
      end;
      for RowIndex := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
      begin
        sgHeatCondBoundNodeSpacing.Cells[1,RowIndex]
          := FloatToStr(ft2m(LocalStrToFloat(sgHeatCondBoundNodeSpacing.Cells[1,RowIndex])));
      end;
      for RowIndex := 1 to sgHeatCondBoundInitialCond.RowCount -1 do
      begin
        sgHeatCondBoundInitialCond.Cells[1,RowIndex]
          := FloatToStr(m2Ft(LocalStrToFloat(sgHeatCondBoundInitialCond.Cells[1,RowIndex])));
        sgHeatCondBoundInitialCond.Cells[2,RowIndex]
          := FloatToStr(C2F(LocalStrToFloat(sgHeatCondBoundInitialCond.Cells[2,RowIndex])));
      end;
      adeTolWell.Text := FloatToStr(Pa2psi(LocalStrToFloat(adeTolWell.Text)));
      adeMinStepWell.Text := FloatToStr(m2Ft(LocalStrToFloat(adeMinStepWell.Text)));
    end;

//
end;

function THST3DForm.Autots(Column : Integer) : boolean;
begin
  result := (sgSolver.Cells[Column,Ord(Automatic)] = 'Yes');
end;

function THST3DForm.Deltim(Column : Integer) : double;
begin
  result := LocalStrToFloat(sgSolver.Cells[Column,Ord(TimeStepLength)]);
end;

function THST3DForm.Dptas(Column : Integer) : double;
begin
  result := LocalStrToFloat(sgSolver.Cells[Column,Ord(MaxChangePres)]);
end;

function THST3DForm.Dttas(Column : Integer) : double;
begin
  result := LocalStrToFloat(sgSolver.Cells[Column,Ord(MaxChangeTemp)]);
end;

function THST3DForm.Dctas(Column : Integer) : double;
begin
  result := LocalStrToFloat(sgSolver.Cells[Column,Ord(MaxChangeMassFrac)]);
end;

function THST3DForm.Dtimmn(Column : Integer) : double;
begin
  result := LocalStrToFloat(sgSolver.Cells[Column,Ord(MinTimeStep)]);
end;

function THST3DForm.Dtimmx(Column : Integer) : double;
begin
  result := LocalStrToFloat(sgSolver.Cells[Column,Ord(MaxTimeStep)]);
end;

function THST3DForm.Timchg(Column : Integer) : double;
begin
  if Column < sgSolver.ColCount
  then
    begin
      result := LocalStrToFloat(sgSolver.Cells[Column,Ord(StartTime)]);
    end
  else
    begin
      result := LocalStrToFloat(sgSolver.Cells[Column-1,Ord(EndTime)]);
    end;
end;

function THST3DForm.MaxSolverTimes : integer;
var
  ColumnIndex : integer;
begin
  result := 0;
  For ColumnIndex := 1 to sgSolver.ColCount -1 do
  begin
    if (LocalStrToFloat(sgSolver.Cells[ColumnIndex,Ord(Duration)]) = 0)
    then
      begin
        break;
      end
    else
      begin
        Inc(Result);
      end;
  end;
end;

function THST3DForm.fPrislm(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrISolMeth)]);
end;

function THST3DForm.fPrikd(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrICondDisp)]);
end;

function THST3DForm.fPriptc(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrIPresTempMass)]);
end;

function THST3DForm.fPridv(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrIFlDens)]);
end;

function THST3DForm.fPrivel(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrIVel)]);
end;

function THST3DForm.fPrigfb(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrIFlowBal)]);
end;

function THST3DForm.fPribcf(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrISpecValFlow)]);
end;

function THST3DForm.fPriwel(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrIWell)]);
end;

function THST3DForm.fIprptc(Column : Integer) : integer;
var
  FirstDigit, SecondDigit, ThirdDigit : string;
begin
  if sgSolver.Cells[Column,Ord(IPRPTCn1)] = 'No'
  then
    begin
      FirstDigit := '0';
    end
  else if sgSolver.Cells[Column,Ord(IPRPTCn1)] = 'Pressure'
  then
    begin
      FirstDigit := '1';
    end
  else
    begin
      FirstDigit := '2';
    end;
  if sgSolver.Cells[Column,Ord(IPRPTCn2)] = 'No'
  then
    begin
      SecondDigit := '0';
    end
  else if sgSolver.Cells[Column,Ord(IPRPTCn2)] = 'Temp.'
  then
    begin
      SecondDigit := '1';
    end
  else
    begin
      SecondDigit := '2';
    end;
  if sgSolver.Cells[Column,Ord(IPRPTCn3)] = 'No'
  then
    begin
      ThirdDigit := '0';
    end
  else
    begin
      ThirdDigit := '1';
    end;
  result := StrToInt(FirstDigit + SecondDigit + ThirdDigit);
end;

function THST3DForm.fChkptd(Column : Integer) : boolean;
begin
  result := (sgSolver.Cells[Column,Ord(CheckPointDump)] = 'Yes');
end;

function THST3DForm.fPricpd(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PrICheckPointDump)]);
end;

function THST3DForm.fSavldo(Column : Integer) : boolean;
begin
  result := (sgSolver.Cells[Column,Ord(SavLastDump)] = 'Yes');
end;

function THST3DForm.fCntmap(Column : Integer) : boolean;
begin
  result := (sgSolver.Cells[Column,Ord(ContourMap)] = 'Yes');
end;

function THST3DForm.fVecmap(Column : Integer) : boolean;
begin
  result := (sgSolver.Cells[Column,Ord(VelocityVectorMap)] = 'Yes');
end;

function THST3DForm.fPrimap(Column : Integer) : integer;
begin
  result := StrToInt(sgSolver.Cells[Column,Ord(PriMaps)]);
end;



function THST3DForm.TopElevation(AUnit : Integer) : double;
begin
  if AUnit < 1 then
  begin
    AUnit := 1;
  end;
  if AUnit > sgGeology.RowCount -1 then
  begin
    AUnit := sgGeology.RowCount -1;
  end;
  result := LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev), AUnit]);
end;

function THST3DForm.BottomElevation(AUnit : Integer) : double;
begin
  if AUnit < 1
  then
    begin
      AUnit := 1;
    end
  else if AUnit > sgGeology.RowCount -1
  then
    begin
      AUnit := sgGeology.RowCount -1;
    end;
  result := LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev), AUnit]);
end;

function THST3DForm.CellTopElevation(ANodeLayer : Integer) : double;
begin
  if ANodeLayer > sgGeology.RowCount -1
  then
    begin
      result := (TopElevation(ANodeLayer) + BottomElevation(ANodeLayer))/2;
    end
  else
    begin
      result := (TopElevation(ANodeLayer-1) + TopElevation(ANodeLayer))/2;
    end
end;

function THST3DForm.CellBottomElevation(ANodeLayer : Integer) : double;
begin
  if ANodeLayer > sgGeology.RowCount -1
  then
    begin
      result := BottomElevation(ANodeLayer);
    end
  else
    begin
      result := (TopElevation(ANodeLayer) + BottomElevation(ANodeLayer))/2;
    end
end;

function THST3DForm.HeatBoundNodeLocation(ANode : Integer) : double;
begin
  if ANode < 1
  then
    begin
      ANode := 1;
    end
  else if ANode > sgHeatCondBoundNodeSpacing.RowCount -1
  then
    begin
      ANode := sgHeatCondBoundNodeSpacing.RowCount -1;
    end;
  result := LocalStrToFloat(sgHeatCondBoundNodeSpacing.Cells[1, ANode]);
end;

function THST3DForm.InitialHeatBoundNodeLocation(ANode : Integer) : double;
begin
  if ANode < 1
  then
    begin
      ANode := 1;
    end
  else if ANode > sgHeatCondBoundInitialCond.RowCount -1
  then
    begin
      ANode := sgHeatCondBoundInitialCond.RowCount -1;
    end;
  result := LocalStrToFloat(sgHeatCondBoundInitialCond.Cells[1, ANode]);
end;

function THST3DForm.InitialHeatBoundNodeTemperature(ANode : Integer) : double;
begin
  if ANode < 1
  then
    begin
      ANode := 1;
    end
  else if ANode > sgHeatCondBoundInitialCond.RowCount -1
  then
    begin
      ANode := sgHeatCondBoundInitialCond.RowCount -1;
    end;
  result := LocalStrToFloat(sgHeatCondBoundInitialCond.Cells[2, ANode]);
end;


// This function reads data from Sender and adds it to a string.
function THST3DForm.FormToString(Sender: THST3DForm) : string;
var
  i : integer;
  AnEdit : TEdit;
  AnArgusDataEntry : TArgusDataEntry;
  ARadioGroup : TRadioGroup;
  ACheckBox : TCheckBox;
  AComboBox : TComboBox;
  AStringGrid : TStringGrid;
  RowIndex, ColIndex : integer;
begin
  result := '';
  With Sender do
  begin
    AnEdit := FindComponent('EdVersion') as TEdit;
    result := result + AnEdit.Name + Chr(13) + Chr(10)  + AnEdit.Text
      + Chr(13) + Chr(10) ;
    for i := 0 to ComponentCount -1 do
    begin
      if (Components[i] is TEdit) then
          begin
            AnEdit := FindComponent(Components[i].Name) as TEdit;
            if not (AnEdit.Name = 'EdVersion') then
            begin
              result := result + AnEdit.Name + Chr(13) + Chr(10)  + AnEdit.Text
                + Chr(13) + Chr(10) ;
            end;
          end
      else if (Components[i] is TArgusDataEntry) then
          begin
            AnArgusDataEntry := FindComponent(Components[i].Name)
              as TArgusDataEntry;

            result := result + AnArgusDataEntry.Name + Chr(13) + Chr(10)  +
              AnArgusDataEntry.Text + Chr(13) + Chr(10) ;
          end
      else if (Components[i] is TRadioGroup) then
          begin
            ARadioGroup := FindComponent(Components[i].Name) as TRadioGroup;
            result := result + ARadioGroup.Name + Chr(13) + Chr(10)
              + IntToStr(ARadioGroup.ItemIndex) + Chr(13) + Chr(10) ;
          end
      else if (Components[i] is TCheckBox) then
          begin
            ACheckBox := FindComponent(Components[i].Name) as TCheckBox;
            result := result + ACheckBox.Name + Chr(13) + Chr(10)
              + IntToStr(Ord(ACheckBox.Checked)) + Chr(13) + Chr(10) ;
          end
      else if (Components[i] is TComboBox) then
          begin
            AComboBox := FindComponent(Components[i].Name) as TComboBox;
            result := result + AComboBox.Name + Chr(13) + Chr(10)
              + IntToStr(AComboBox.ItemIndex) + Chr(13) + Chr(10) ;
          end
      else if (Components[i] is TStringGrid) then
          begin
            AStringGrid := FindComponent(Components[i].Name) as TStringGrid;
            result := result + AStringGrid.Name + Chr(13) + Chr(10)  +
                   IntToStr(AStringGrid.RowCount) + Chr(13) + Chr(10)  +
                   IntToStr(AStringGrid.ColCount) + Chr(13) + Chr(10) ;
            For RowIndex := 0 to AStringGrid.RowCount -1 do
            begin
              For ColIndex := 0 to AStringGrid.ColCount -1 do
              begin
                result := result +AStringGrid.Cells[ColIndex,RowIndex]
                  + Chr(13) + Chr(10) ;
              end;
            end;
          end
    end;
  end;

end;

// This function reads data from Sender and adds it to a string.
function THST3DForm.ReplaceValues(Sender: THST3DForm; AStringList : TStringList)
   : string;
var
  i : integer;
  AnEdit : TEdit;
  AnArgusDataEntry : TArgusDataEntry;
  ARadioGroup : TRadioGroup;
  ACheckBox : TCheckBox;
  AComboBox : TComboBox;
  CurrentName : String;
  StringListIndex : integer;
  AString : String;
  Start : integer;
begin
  result := '';
  With Sender do
  begin
    PIE_Data.ProgressForm.ProgressBar1.Max := ComponentCount ;
    PIE_Data.ProgressForm.Caption := 'Processing export template: Phase 1';
    PIE_Data.ProgressForm.Show;
    for i := 0 to ComponentCount -1 do
    begin
      PIE_Data.ProgressForm.ProgressBar1.StepIt;
      if (Components[i] is TEdit) then
          begin
            AnEdit := FindComponent(Components[i].Name) as TEdit;
            CurrentName := '@' + AnEdit.Name + '@';
            if not (AnEdit.Name = 'EdVersion') then
            begin
              for StringListIndex := 0 to AStringList.Count - 1 do
              begin
                ANE_ProcessEvents(CurrentModelHandle);
                AString := AStringList.Strings[StringListIndex];
                Start := Pos(CurrentName, AString);
                if Start > 0 then
                begin
                  AString := Copy(AString, 1, Start -1) + AnEdit.Text
                    + Copy(AString, Start + Length(CurrentName),
                      Length(AString));

                  AStringList.Strings[StringListIndex] := AString;
                end;
              end;
            end;
          end
      else if (Components[i] is TArgusDataEntry) then
          begin
            AnArgusDataEntry := FindComponent(Components[i].Name)
              as TArgusDataEntry;

            CurrentName := '@' + AnArgusDataEntry.Name + '@';
            for StringListIndex := 0 to AStringList.Count - 1 do
            begin
              ANE_ProcessEvents(CurrentModelHandle);
              AString := AStringList.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              if Start > 0 then
              begin
                AString := Copy(AString, 1, Start -1) + AnArgusDataEntry.Output
                  + Copy(AString, Start + Length(CurrentName), Length(AString));
                AStringList.Strings[StringListIndex] := AString;
                break;
              end;
            end;
          end
      else if (Components[i] is TRadioGroup) then
          begin
            ARadioGroup := FindComponent(Components[i].Name) as TRadioGroup;
            CurrentName := '@' + ARadioGroup.Name + '@';
            for StringListIndex := 0 to AStringList.Count - 1 do
            begin
              ANE_ProcessEvents(CurrentModelHandle);
              AString := AStringList.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              if Start > 0 then
              begin
                AString := Copy(AString, 1, Start -1)
                  + IntToStr(ARadioGroup.ItemIndex) + Copy(AString, Start
                  + Length(CurrentName), Length(AString));

                AStringList.Strings[StringListIndex] := AString;
                break;
              end;
            end;
          end
      else if (Components[i] is TCheckBox) then
          begin
            ACheckBox := FindComponent(Components[i].Name) as TCheckBox;
            CurrentName := '@' + ACheckBox.Name + '@';
            for StringListIndex := 0 to AStringList.Count - 1 do
            begin
              ANE_ProcessEvents(CurrentModelHandle);
              AString := AStringList.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              if Start > 0 then
              begin
                AString := Copy(AString, 1, Start -1)
                  + IntToStr(Ord(ACheckBox.Checked)) + Copy(AString, Start
                  + Length(CurrentName), Length(AString));

                AStringList.Strings[StringListIndex] := AString;
                break;
              end;
            end;
          end
      else if (Components[i] is TComboBox) and
               not ((Components[i] is TArgusDataEntry)) then
          begin
            AComboBox := FindComponent(Components[i].Name) as TComboBox;
            CurrentName := '@' + AComboBox.Name + '@';
            for StringListIndex := 0 to AStringList.Count - 1 do
            begin
              ANE_ProcessEvents(CurrentModelHandle);
              AString := AStringList.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              if Start > 0 then
              begin
                AString := Copy(AString, 1, Start -1)
                  + IntToStr(AComboBox.ItemIndex) + Copy(AString,
                    Start + Length(CurrentName), Length(AString));

                AStringList.Strings[StringListIndex] := AString;
                break;
              end;
            end;
          end;
{      else if (Components[i] is TStringGrid) then
          begin
            AStringGrid := FindComponent(Components[i].Name) as TStringGrid;
            result := result + AStringGrid.Name + Chr(13) + Chr(10)  +
                   IntToStr(AStringGrid.RowCount) + Chr(13) + Chr(10)  +
                   IntToStr(AStringGrid.ColCount) + Chr(13) + Chr(10) ;
            For RowIndex := 0 to AStringGrid.RowCount -1 do
            begin
              For ColIndex := 0 to AStringGrid.ColCount -1 do
              begin
                memoUnreadData.Lines.Add(AStringGrid.Cells[ColIndex,RowIndex]);
                result := result +AStringGrid.Cells[ColIndex,RowIndex] + Chr(13) + Chr(10) ;
              end;
            end;
            memoUnreadData.Lines.Add('');
          end   }
    end;
    PIE_Data.ProgressForm.Hide;

    result := AStringList.Text;

  end;

end;

// This function reads data from a string created by THST3DForm.FormToString
// and updates Sender with the data.
procedure THST3DForm.StringToForm(AString : String; Sender: THST3DForm);
var
  AnEdit : TEdit;
  AnArgusDataEntry : TArgusDataEntry;
  ARadioGroup : TRadioGroup;
  ACheckBox : TCheckBox;
  AComboBox : TComboBox;
  AStringGrid : TStringGrid;
  RowIndex, ColIndex : integer;
  AName : string;
  AText : string;
  AComponent : TComponent;
begin
  { For some unknown reason, this doesn't work properly if an updown is
  associated with a TEdit. The text of the TEdit doesn't get altered. }
  AName := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
  AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2, Length(AString));
  AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
  AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2, Length(AString));

  With Sender do
  begin
    memoUnreadData.Lines.Clear;
    AnEdit := FindComponent(AName) as TEdit;
    If LocalStrToFloat(AnEdit.Text) < LocalStrToFloat(AText) then
    begin
      ShowMessage('Attempting to read data from '
         + 'a later version of the HST3D PIE.');
    end;
    While Length(AString) >0 do
    begin
      AName := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
      AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
        Length(AString));
      AComponent := FindComponent(AName);
      if (AComponent = nil) and not (AName = '')
      then
        begin
          if AName = 'cbWatTableInitial'
          then
            begin
              AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
                Length(AString));
            end
          else
            begin
              memoUnreadData.Lines.Add(AName);
            end;
        end
      else if AComponent is TEdit
      then
        begin
          AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
          AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
            Length(AString));
          AnEdit := FindComponent(AName) as TEdit;
          if AnEdit.Name = 'edMaxTimes' then
          begin
            edMaxTimesEnter(Sender);
          end;
          if not (AnEdit.Name = 'EdVersion') then
          begin
            AnEdit.Text := AText;
          end;
          if AnEdit.Name = 'edMaxTimes' then
          begin
            edMaxTimesExit(Sender);
          end;
        end
      else if AComponent is TArgusDataEntry then
          begin
            AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
            AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
              Length(AString));
            AnArgusDataEntry := FindComponent(AName) as TArgusDataEntry;
            AnArgusDataEntry.Text := AText;
          end
      else if (AComponent is TRadioGroup) then
          begin
            AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
            AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
              Length(AString));
            ARadioGroup := FindComponent(AName) as TRadioGroup;
            ARadioGroup.ItemIndex := StrToInt(AText);
          end
      else if (AComponent is TCheckBox) then
          begin
            AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
            AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
              Length(AString));
            ACheckBox := FindComponent(AName) as TCheckBox;
            if AText = '0'
            then
                begin
                  ACheckBox.Checked := False;
                end
            else if AText = '1'
            then
                begin
                  ACheckBox.Checked := True;
                end;
            if Assigned(ACheckBox.OnClick) then
            begin
              ACheckBox.OnClick(ACheckBox);
            end;
          end
      else if (AComponent is TComboBox) then
          begin
            AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
            AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
              Length(AString));
            AComboBox := FindComponent(AName) as TComboBox;
            AComboBox.ItemIndex := StrToInt(AText);
          end
      else if (AComponent is TStringGrid) then
          begin
            AStringGrid := FindComponent(AName) as TStringGrid;
            AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
            AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
              Length(AString));
            AStringGrid.RowCount := StrToInt(AText);
            AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
            AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
              Length(AString));
            AStringGrid.ColCount := StrToInt(AText);
            if AStringGrid.Name = 'sgSolver'
            then
              begin
                edMaxTimesEnter(edMaxTimes);
                edMaxTimes.Text := IntToStr(StrToInt(AText) -1);
                edMaxTimesExit(edMaxTimes);
              end;   
            For RowIndex := 0 to AStringGrid.RowCount -1 do
            begin
              For ColIndex := 0 to AStringGrid.ColCount -1 do
              begin
                AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
                AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
                  Length(AString));
                AStringGrid.Cells[ColIndex,RowIndex] := AText;
              end;
            end;
          end
    end;
  end;
  if memoUnreadData.Lines.Count > 0 then
  begin
    tabProblem.TabVisible := True;
    PageControl1.ActivePage := tabProblem;
    Beep;
    MessageDlg('Unable to read some data from this file. ' +
    'If you save this file, the extra data will be lost. ' +
    'Contact PIE developer for assistance.', mtWarning, [mbOK], 0);
  end;

end;


procedure THST3DForm.cbRestartClick(Sender: TObject);
begin
  // if this is a restart of a previous run, enable the
  // edit box that allows you to enter the restart time and it's label.
  adeTime.Enabled := cbRestart.Checked;
  lblTime.Enabled := cbRestart.Checked;

end;

procedure THST3DForm.cbTiltCoordClick(Sender: TObject);
begin
  // if this model has a tilted coordinate system, enable the edit boxes that
  // allow you to enter the angles with the vertical and their labels.
  rgAngleChoice.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian));

  lblThetxz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 0);

  lblThetyz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 1);

  lblThetzz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 2);

  adeThetxz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 0);

  adeThetyz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 1);

  adeThetzz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 2);

  // You are not allowed to have a free surface with a tilted coordinate system.
  cbFreeSurf.Enabled := not cbTiltCoord.Checked and not cbHeat.Checked;

  if not cbFreeSurf.Enabled and cbFreeSurf.Checked then
  begin
     if MessageDlg('Free Surface Boundary Conditions are not allowed with ' +
       'tilted coordinate systems. Are you sure you want to use ' +
       'a tilted coordinate system?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes
     then
       begin
         cbFreeSurf.Checked := False;
       end
     else
       begin
         cbTiltCoord.Checked := False;
       end;

  end;

  // You are not allowed to have leakage boundaries with a tilted coordinate system
  cbLeakage.Enabled := not cbTiltCoord.Checked;
  if not cbLeakage.Enabled then
  begin
    cbLeakage.Checked := False;
  end;

  cbRiver.Enabled := not cbTiltCoord.Checked;
  if not cbRiver.Enabled then
  begin
    cbRiver.Checked := False;
  end;

end;

// Enable or disable the ability to choose a tilted coordinate system
// depending on whether or not the coordinate system is cylindrical
// or Cartesian
procedure THST3DForm.rgCoordClick(Sender: TObject);
begin
   cbTiltCoord.Enabled :=  not cbFreeSurf.Checked and not cbLeakage.Checked
    and not cbRiver.Checked and (rgCoord.ItemIndex = Ord(csCartesian));
   if not cbTiltCoord.Enabled then
   begin
     cbTiltCoord.Checked := False;
   end;
   comboPrOrientation.Enabled := (rgCoord.ItemIndex = Ord(csCartesian));
   lblPrOrientation.Enabled := (rgCoord.ItemIndex = Ord(csCartesian));
   
   ActivateWellParam;
   ActivateWellHeatParam;

   tabWells.TabVisible := cbWells.Checked and (rgCoord.ItemIndex = Ord(csCylindrical));

end;

// Enable or disable fields related to solute transport
// depending on whether or not solute transport will be simulated.
procedure THST3DForm.cbSoluteClick(Sender: TObject);
begin
   adeMaxMassFrac.Enabled := cbSolute.Checked;
   adeFluidDenseMax.Enabled := cbSolute.Checked;
   lblMaxMassFrac.Enabled := cbSolute.Checked;
   lblFluidDenseMax.Enabled := cbSolute.Checked;

   adeEffMolDiff.Enabled := cbSolute.Checked;
   adeSolDecConst.Enabled := cbSolute.Checked;
   lblEffMolDiff.Enabled := cbSolute.Checked;
   lblSolDecConst.Enabled := cbSolute.Checked;
   cbSpecMass.Enabled := cbSolute.Checked;
   cbSpecSolute.Enabled := cbSolute.Checked;
   if not cbSolute.Checked then
   begin
     cbSpecMass.Checked := False;
     cbSpecSolute.Checked := False;
   end;

   cbSpecMassInterp.Enabled := cbSpecMass.Checked and cbSolute.Checked;
   if not (cbSpecMass.Checked and cbSolute.Checked) then
   begin
     cbSpecMassInterp.Checked := False;
   end;

   cbInterpMassSpecPress.Enabled := cbSpecPres.Checked and cbSolute.Checked and
     cbSpecPresInterp.Checked;

   cbInterpScMassFracSpecPres.Enabled := cbSpecPres.Checked and
     cbSolute.Checked and cbSpecPresInterp.Checked;

   if not cbSpecPres.Checked or not cbSolute.Checked or
     not cbSpecPresInterp.Checked then
   begin
     cbInterpMassSpecPress.Checked := False;
     cbInterpScMassFracSpecPres.Checked := False;
   end;

  cbFluxMassFracInterp.Enabled := cbSolute.Checked;
  if not cbFluxMassFracInterp.Enabled then
  begin
    cbFluxMassFracInterp.Checked := False;
  end;

  cbFluxScMassFracInterp.Enabled := cbSolute.Checked;
  if not cbFluxScMassFracInterp.Enabled then
  begin
    cbFluxScMassFracInterp.Checked := False;
  end;

   AddSpecStatSoluteParameters;
   AddSpecFluxSoluteParameters;
   AddGridSoluteParameters;
   AddGridHeatOrSoluteParameters;
   AddAquifLeakSoluteParameters;
   AddAquifInflSoluteParameters;
   AddDistCoefSoluteLayers;
   AddDispHeatSoluteLayers;
   AddInitMassFracSoluteLayers;
   AddWellTimeSoluteParameters;
   AddRiverMassFracPar;

   cbInterpMassSpecPressClick(Sender);
   cbInterpScMassFracSpecPresClick(Sender);
   cbSpecMassInterpClick(Sender);

end;

// Enable the fields related to choosen method of specifying viscosity.
procedure THST3DForm.rgViscMethClick(Sender: TObject);
type ViscosityMethod = (vmMultipier, vmViscosity);
begin
  adeVisMultFact.Enabled := (rgViscMeth.ItemIndex = Ord(vmMultipier));
  lblVisMultFact.Enabled := (rgViscMeth.ItemIndex = Ord(vmMultipier));
  adeViscosity.Enabled := (rgViscMeth.ItemIndex = Ord(vmViscosity));
  lblViscosity.Enabled := (rgViscMeth.ItemIndex = Ord(vmViscosity));
end;

// enable or disable fields related to heat transport depending on whether
// or not heat transport is simulated. If heat transport is not simulated,
// uncheck checkboxes related to heat transport.
procedure THST3DForm.cbHeatClick(Sender: TObject);
begin
  adeFluidHeatCap.Enabled := cbHeat.Checked;
  adeFluidThermCond.Enabled := cbHeat.Checked;
  adeFluidCoefExp.Enabled := cbHeat.Checked;
  lblFluidHeatCap.Enabled := cbHeat.Checked;
  lblFluidThermCond.Enabled := cbHeat.Checked;
  lblFluidCoefExp.Enabled := cbHeat.Checked;
  cbSpecTemp.Enabled := cbHeat.Checked;
  cbSpecHeat.Enabled := cbHeat.Checked;
  cbHeatCond.Enabled := cbHeat.Checked;
   if not cbHeat.Checked then
   begin
     cbSpecTemp.Checked := False;
     cbInterpTempSpecPres.Checked := False;
     cbSpecHeat.Checked := False;
     cbHeatCond.Checked := False;
   end;
   cbInterpTempSpecPres.Enabled :=  cbSpecPres.Checked and cbHeat.Checked and
     cbSpecPresInterp.Checked;

   cbSpecTempInterp.Enabled := cbHeat.Checked and cbSpecTemp.Checked;

   if not cbSpecTemp.Checked or not cbHeat.Checked or
     not cbSpecPresInterp.Checked then
   begin
     cbInterpTempSpecPres.Checked := False;
   end;

   cbSpecTempInterp.Enabled := cbSpecTemp.Checked and cbHeat.Checked;
   if not (cbSpecTemp.Checked and cbHeat.Checked) then
   begin
     cbSpecTempInterp.Checked := False;
   end;

  cbFluxTempInterp.Enabled := cbHeat.Checked;
  if not cbFluxTempInterp.Enabled then
  begin
    cbFluxTempInterp.Checked := False;
  end;

  ActivateWellHeatParam;

  AddGridHeatOrSoluteParameters;
  AddGridHeatParameters;
  AddSpecStatHeatParameters;
  AddSpecFluxHeatParameters;
  AddAquifLeakHeatParameters;
  AddAquifInflHeatParameters;
  AddInitTempHeatLayers;
  AddHeatCapThermCondHeatLayers;
  AddDispHeatSoluteLayers;
  AddWellRiserTimeHeatParameters;
  AddWellRiserHeatParameters;

  cbFreeSurf.Enabled := not cbTiltCoord.Checked and not cbHeat.Checked;

  cbInterpTempSpecPresClick(Sender);

  cbSpecTempInterpClick(Sender);

end;

// show the well tab if wells will be simulated
procedure THST3DForm.cbWellsClick(Sender: TObject);
begin
   cbWellRiser.Enabled := cbWells.Checked;
   if not cbWells.Checked then
   begin
     cbWellRiser.Checked := False;
   end;
   ActivateWellParam;
   ActivateWellHeatParam;

   tabWells.TabVisible := cbWells.Checked and (rgCoord.ItemIndex = Ord(csCylindrical));

   LayerStructure.UnIndexedLayers.AddOrRemoveLayer
     (TWellLayer, cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));
end;

// Show the aquifer influence tab if the aquifer influence boundary condition
// will be used.
procedure THST3DForm.cbAqInflClick(Sender: TObject);
begin
   cbUseBCFLOWClick(Sender);
   cbAqInflInterp.Enabled := cbAqInfl.Checked;
   if not cbAqInfl.Checked then
   begin
     cbAqInflInterp.Checked := False;
   end;

  tabAqInfl.TabVisible := cbAqInfl.Checked;

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(THorAqInflLayer,
      cbAqInfl.Checked);


   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TVerAqInflLayer,
      cbAqInfl.Checked);

end;

// enable or disable fields relating to your choice of
// aquifer influence function.
procedure THST3DForm.rgAqInflChoiceClick(Sender: TObject);
begin
        adeVolOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiPot));
        lblVolOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiPot));

        adePermOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        adeViscOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        adeThickOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        adeRadius.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        adeAngInflOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));

        lblPermOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        lblViscOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        lblThickOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        lblRadius.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
        lblAngInflOut.Enabled := (rgAqInflChoice.ItemIndex = Ord(aiTrans));
end;

// if a free surface will be simulated enable the user to specify a water table.
procedure THST3DForm.cbFreeSurfClick(Sender: TObject);
begin
  cbInitWatTable.Enabled := cbFreeSurf.Checked and not cbSpecInitPres.Checked;
  if not cbInitWatTable.Enabled then
  begin
    cbInitWatTable.Checked := False;
  end;


  cbHeat.Enabled := not cbFreeSurf.Checked;
  cbTiltCoord.Enabled := not cbFreeSurf.Checked and not cbLeakage.Checked
    and not cbRiver.Checked and (rgCoord.ItemIndex = Ord(csCartesian));
  if not cbTiltCoord.Enabled then
  begin
    cbTiltCoord.Checked := False;
  end;

  cbWatTableInitialInterp.Enabled := (not cbSpecInitPres.Checked and
                               cbInitWatTable.Checked and cbFreeSurf.Checked);
  if not cbWatTableInitialInterp.Enabled then
  begin
    cbWatTableInitialInterp.Checked := False;
  end;

  AddInitWatTable;

end;


// Allow the user to specity an intial pressure
procedure THST3DForm.cbSpecInitPresClick(Sender: TObject);
begin
  adeElevInitPres.Enabled := (cbSpecInitPres.Checked and
    not cbInitWatTable.Checked);

  adeInitPres.Enabled := (cbSpecInitPres.Checked and
    not cbInitWatTable.Checked);

  lblElevInitPres.Enabled := (cbSpecInitPres.Checked and
    not cbInitWatTable.Checked);

  lblInitPres.Enabled := (cbSpecInitPres.Checked and
    not cbInitWatTable.Checked);

  cbInitPresInterp.Enabled := not cbSpecInitPres.Checked
    and not cbInitWatTable.Checked ;
  if not cbInitPresInterp.Enabled then
  begin
    cbInitPresInterp.Checked := False;
  end;

  cbWatTableInitialInterp.Enabled := (cbSpecInitPres.Checked and
                               cbInitWatTable.Checked and cbFreeSurf.Checked);
  if not cbWatTableInitialInterp.Enabled then
  begin
    cbWatTableInitialInterp.Checked := False;
  end;

  cbInitWatTable.Enabled := cbFreeSurf.Checked and not cbSpecInitPres.Checked;
  if not cbInitWatTable.Enabled then
  begin
    cbInitWatTable.Checked := False;
  end;

  AddInitPressLayer;
  AddInitWatTable;

end;

// respond to changes in solution method
procedure THST3DForm.rgSolutionMethodClick(Sender: TObject);
type SolutionMethod = (smTriangular, smTwoLine, smGenRedBlack, smGenZigZag);
begin
  // change the capiton for the Tolerance depending on the choice
  // of solution method.
  case rgSolutionMethod.ItemIndex of
    Ord(smTriangular) :
      begin
        lblTolerance.Caption := 'Tolerance';
      end;
    Ord(smTwoLine) :
      begin
        lblTolerance.Caption := 'Tolerance: maximum fraction change in any '
          + 'of the dependent-variable values (EPSSLV).';
        lblTolerance.Width := 417;
        lblTolerance.Height := 25;
      end;
    Ord(smGenRedBlack) :
      begin
        lblTolerance.Caption := 'Tolerance: maximum Euclidean norm of '
          + 'changes in the vector of dependent-variable values (EPSSLV).';
        lblTolerance.Width := 417;
        lblTolerance.Height := 25;
      end;
    Ord(smGenZigZag) :
      begin
        lblTolerance.Caption := 'Tolerance: maximum Euclidean norm of '
          + 'changes in the vector of dependent-variable values (EPSSLV).';
        lblTolerance.Width := 417;
        lblTolerance.Height := 25;
      end;
  end;

  // enable or disable fields as appropiate so that only the fields that
  // will be used are enabled.
  adeNumTime.Enabled := (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  adeTolerance.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  adeTolerance2.Enabled := (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  adeMaxIt1.Enabled := (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  adeMaxIt2.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smTwoLine));

  comboRenumDir.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack));
  comboIORDER.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack));
  adeNumSteps.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack));

  lblNumTime.Enabled := (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  lblTolerance.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  lblTolerance2.Enabled := (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  lblMaxIt1.Enabled := (rgSolutionMethod.ItemIndex = Ord(smTwoLine));
  lblMaxIt2.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smTwoLine));

  lblRenumDir.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack));
  lblIORDER.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack));
  lblNumSteps.Enabled := (rgSolutionMethod.ItemIndex = Ord(smGenZigZag)) or
                          (rgSolutionMethod.ItemIndex = Ord(smGenRedBlack));

end;

// enable or disable fields relating to printing initial information
procedure THST3DForm.cbPrInitClick(Sender: TObject);
begin
  cbPrDensVisc.Enabled := cbPrInit.Checked;
  comboPrPres.Enabled := cbPrInit.Checked;
  comboPrTemp.Enabled := cbPrInit.Checked;
  comboPrMassFr.Enabled := cbPrInit.Checked;
  lblPrPres.Enabled := cbPrInit.Checked;
  lblPrTemp.Enabled := cbPrInit.Checked;
  lblPrMassFr.Enabled := cbPrInit.Checked;
end;

function THST3DForm.IsRegistered : boolean;
var
  registered : boolean;
  AppCompany, AppName, AppVersion : shortstring;
begin
  registered := True;
{  registered := False;
  AppCompany := raRegister.AppCompany;
  AppName := raRegister.AppName;
  AppVersion := raRegister.AppVersion;
  if raRegister.IsRegistered then
  begin
    registered := True;
  end
  else
  begin
    raRegister.AppCompany := '';
    raRegister.AppName := '';
    raRegister.AppVersion := '';
    if raRegister.IsRegisteredOld then
    begin
      registered := True;
    end
  end;
  if not registered then
  begin
    raRegister.AppCompany := AppCompany;
    raRegister.AppName := AppName;
    raRegister.AppVersion := AppVersion;
  end; }
//  result := registered;
  result := True;
end;

// Initialize variables
procedure THST3DForm.FormCreate(Sender: TObject);
var
  RowIndex : integer;
//  DirectoryName : String;
  registered : boolean;
//  AppCompany, AppName, AppVersion : shortstring;
begin
  registered := IsRegistered;
{  if registered then
  begin
    lblUserName.Caption := raRegister.User;
    lblCompanyName.Caption := raRegister.License;
  end; }

  {$IFDEF SSG}
{  if not IsRegistered then
  begin
    lblIntDev.Caption := ' Authorized HST3D GUI reseller';
    lblDevName.Caption := ' Scientific Software Group';
    lblAdress.Caption := ' P.O. Box 23041';
    lblCity.Caption := ' Washington, DC  20026-3041';
    lblTelephone.Caption := ' (703) 620-9214';
    ASLinkWinston.Caption := 'info@scisoftware.com';
    lblGuiFaq.Caption := 'The HST3D GUI FAQ (URL hidden in demo version)';
    ASLinkFAQ.Visible := False;
  end; }
  {$ENDIF}

  FormHeight := Height;
  FormTop := Top;
  // initialize titles in sgSolver and sgGeology
  IntializeGrids;
  // initialize the text displayed in the Solver Grid.

  sgSolver.Cells[1,Ord(StartTime)]         := '0';
  sgSolver.Cells[1,Ord(Automatic)]         := 'Yes';
  sgSolver.Cells[1,Ord(TimeStepLength)]    := '1';
  sgSolver.Cells[1,Ord(MaxChangePres)]     := '5000';
  sgSolver.Cells[1,Ord(MaxChangeTemp)]     := '5';
  sgSolver.Cells[1,Ord(MaxChangeMassFrac)] := '0.25';
  sgSolver.Cells[1,Ord(MinTimeStep)]       := '10000';
  sgSolver.Cells[1,Ord(MaxTimeStep)]       := '10000000';
  sgSolver.Cells[1,Ord(Duration)]          := '0';
  sgSolver.Cells[1,Ord(EndTime)]           := '0';

  sgSolver.Cells[1,Ord(PrISolMeth)]        := '1';
  sgSolver.Cells[1,Ord(PrICondDisp)]       := '0';
  sgSolver.Cells[1,Ord(PrIPresTempMass)]   := '0';
  sgSolver.Cells[1,Ord(PrIFlDens)]         := '0';
  sgSolver.Cells[1,Ord(PrIVel)]            := '0';
  sgSolver.Cells[1,Ord(PrIFlowBal)]        := '0';
  sgSolver.Cells[1,Ord(PrISpecValFlow)]    := '0';
  sgSolver.Cells[1,Ord(PrIWell)]           := '0';
  sgSolver.Cells[1,Ord(IPRPTCn1)]          := 'No';
  sgSolver.Cells[1,Ord(IPRPTCn2)]          := 'No';
  sgSolver.Cells[1,Ord(IPRPTCn3)]          := 'No';
  sgSolver.Cells[1,Ord(CheckPointDump)]    := 'No';
  sgSolver.Cells[1,Ord(PrICheckPointDump)] := '0';
  sgSolver.Cells[1,Ord(SavLastDump)]       := 'No';
  sgSolver.Cells[1,Ord(ContourMap)]        := 'Yes';
  sgSolver.Cells[1,Ord(VelocityVectorMap)] := 'Yes';
  sgSolver.Cells[1,Ord(PriMaps)]           := '0';

  sgSolver.ColCount := StrToInt(edMaxTimes.Text) + 1;
  // set the value of strLastTime to the current maximum number of time periods.
  // This is used in responses to changes to edMaxTimes.
  strLastTime := edMaxTimes.Text;
  // Initialized the selection in combo boxes
  comboPrPres.ItemIndex := Ord(ppcNone);
  comboPrTemp.ItemIndex := Ord(ptcNone);
  comboPrMassFr.ItemIndex := Ord(pmfcNone);
  comboPrOrientation.ItemIndex := Ord(ocHorizontal);
  comboRenumDir.ItemIndex := Ord(xyz);
  comboIORDER.ItemIndex := Ord(pcModified);
  comboAquiferInflZoneW.ItemIndex := Ord(aizwDefault);
  // initialize value of currently selected time period
  sgSolver.Col := 1;
  // Show the current verion number on the about tab.
  lblVersion.Caption := lblVersion.Caption + ' ' + edVersion.Text;
  // initialize the previous number of heat nodes to it's current value.
  // this is used in error checking.
  PrevNumHeatNodes := '3';
  PrevNumInitHeatNodes := '3';
  // initialize the string grid showing the heat conduction boundary data
  sgHeatCondBoundNodeSpacing.Cells[1,0] := 'Nodal Locations (ZHCBC) (L)';
  sgHeatCondBoundNodeSpacing.Cells[0,1] := 'Node 1';
  sgHeatCondBoundNodeSpacing.Cells[0,2] := 'Node 2';
  sgHeatCondBoundNodeSpacing.Cells[0,3] := 'Node 3';
  For RowIndex := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    sgHeatCondBoundNodeSpacing.Cells[1,RowIndex] := FloatToStr(RowIndex-1);
  end;
  sgHeatCondBoundInitialCond.Cells[1,0] := 'Nodal Locations (ZTHC) (L)';
  sgHeatCondBoundInitialCond.Cells[2,0] := 'Initial Temperature (TVZHC) (T)';
  sgHeatCondBoundInitialCond.Cells[0,1] := 'Node 1';
  sgHeatCondBoundInitialCond.Cells[0,2] := 'Node 2';
  sgHeatCondBoundInitialCond.Cells[0,3] := 'Node 3';
  For RowIndex := 1 to sgHeatCondBoundInitialCond.RowCount -1 do
  begin
    sgHeatCondBoundInitialCond.Cells[1,RowIndex] := FloatToStr(RowIndex-1);
    sgHeatCondBoundInitialCond.Cells[2,RowIndex] := '20';
  end;
  // Initialize  CurrentHeatNodeDistance. It is used in error checking
  CurrentHeatNodeDistance := '0';
  // Initialize geology string grid
  sgGeology.Cells[Ord(gdName),1] := 'Element Layer1';
  sgGeology.Cells[Ord(gdTopElev),1] := '1';
  sgGeology.Cells[Ord(gdBotElev),1] := '0';
  LastGeologyText := 'Element Layer1';
  sgGeology.Row := 1;
  PreviousNumberLayersText := edNumLayers.Text;

  sgWellCompletion.Cells[Ord(weCompletion),1] := '0';
  sgWellCompletion.Cells[Ord(weSkinfactor),1] := '0';

  sgWellTime.Cells[Ord(wtTime),1] := '0';
  sgWellTime.Cells[Ord(wtFlow),1] := '0';
  sgWellTime.Cells[Ord(wtSurfPres),1] := '0';
  sgWellTime.Cells[Ord(wtDatumPres),1] := '0';
  sgWellTime.Cells[Ord(wtTemp),1] := '20';
  sgWellTime.Cells[Ord(wtMassFrac),1] := '0';

  pnlInitialHeatCondBoundNodeN.Height := Round(tabHeat.Height/2);
  sgWellTime.Height := Round(tabWells.Height/2);

// The layer structure must only be created after the form has
// been filled with valid data
//  LayerStructure := THST3DLayerStructure.Create;
end;

// Increase the maximum number of times. This causes an OnChange
// event in edMaxTimes
procedure THST3DForm.btnAddTimeClick(Sender: TObject);
begin
  edMaxTimesEnter(Sender);
  edMaxTimes.Text := IntToStr(StrToInt(edMaxTimes.Text) + 1);
  edMaxTimesExit(Sender);
end;

// respond to the selection of a cell in the solver grid.
procedure THST3DForm.sgSolverSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
var
  ColIndex : integer;
begin
  // if the user entered a blank, "-" or "-0" when editing
  // a previous cell, convert it to a 0.
  if (sgSolver.Cells[PreviousTimeColumn,PreviousTimeRow] = '') or
     (sgSolver.Cells[PreviousTimeColumn,PreviousTimeRow] = '-') or
     (sgSolver.Cells[PreviousTimeColumn,PreviousTimeRow] = '-0') then
  begin
    sgSolver.Cells[PreviousTimeColumn,PreviousTimeRow] := '0'
  end;
  // update values
  PreviousTimeColumn := Col;
  PreviousTimeRow := Row;
  CurrentTimeCellText := sgSolver.Cells[Col,Row];
      if (Col > 1) and
         (
           (sgSolver.Cells[Col-1,Ord(Duration)] = '0') or
           (sgSolver.Cells[Col-1,Ord(Duration)] = '') or
           (sgSolver.Cells[Col-1,Ord(Duration)] = '-') or
           (LocalStrToFloat(sgSolver.Cells[Col-1,Ord(Duration)]) = 0) or
           ( not (Row = Ord(Duration)) and
             (
               (sgSolver.Cells[Col,Ord(Duration)] = '0') or
               (sgSolver.Cells[Col,Ord(Duration)] = '') or
               (sgSolver.Cells[Col,Ord(Duration)] = '-') or
               (LocalStrToFloat(sgSolver.Cells[Col,Ord(Duration)]) = 0)
             )

           )
         )
  then
    begin
            sgSolver.Options := sgSolver.Options - [goEditing];
    end
  else
    begin
      case Row of
        Ord(Automatic),
        Ord(CheckPointDump),
        Ord(SavLastDump),
        Ord(ContourMap),
        Ord(VelocityVectorMap):
          begin
            // If the user selected the row in which "Automatic" is edited,
            // toggle it from yes to no or back.
            sgSolver.Options := sgSolver.Options - [goEditing];
            if sgSolver.Cells[Col,Row] = 'Yes'
            then
              begin
                sgSolver.Cells[Col,Row] := 'No';
              end
            else
              begin
                sgSolver.Cells[Col,Row] := 'Yes';
              end;
          end;
        Ord(TimeStepLength):
          begin
            // allow or disallow editing as appropriate.
            if sgSolver.Cells[Col,Ord(Automatic)] = 'No'
            then
              begin
                sgSolver.Options := sgSolver.Options + [goEditing];
              end
            else
              begin
                sgSolver.Options := sgSolver.Options - [goEditing];
              end;
          end;
        Ord(MaxChangePres),
        Ord(MaxChangeTemp),
        Ord(MaxChangeMassFrac),
        Ord(MinTimeStep),
        Ord(MaxTimeStep):
          begin
            // allow or disallow editing as appropriate.
            if sgSolver.Cells[Col,Ord(Automatic)] = 'Yes'
            then
              begin
                sgSolver.Options := sgSolver.Options + [goEditing];
              end
            else
              begin
                sgSolver.Options := sgSolver.Options - [goEditing];
              end;
          end;
        Ord(Duration):
          begin
            // allow editing.
            sgSolver.Options := sgSolver.Options + [goEditing];
          end;
        Ord(EndTime):
          begin
            // allow editing.
            sgSolver.Options := sgSolver.Options - [goEditing];
          end;
        Ord(IPRPTCn1):
          begin
            sgSolver.Options := sgSolver.Options - [goEditing];
            if not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '0') and
               not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '') and
               not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '-') and
               not (StrToInt(sgSolver.Cells[Col,Ord(PrIPresTempMass)]) = 0)
            then
            begin
              if sgSolver.Cells[Col,Row] = 'No'
              then
                begin
                  sgSolver.Cells[Col,Row] := 'Pressure';
                end
              else if sgSolver.Cells[Col,Row] = 'Pressure'
              then
                begin
                  sgSolver.Cells[Col,Row] := 'Pres & Head';
                end
              else
                begin
                  sgSolver.Cells[Col,Row] := 'No';
                end;
            end;
          end;
        Ord(IPRPTCn2):
          begin
            sgSolver.Options := sgSolver.Options - [goEditing];
            if not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '0') and
               not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '') and
               not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '-0') and
               not (StrToInt(sgSolver.Cells[Col,Ord(PrIPresTempMass)]) = 0)
            then
            begin
              if sgSolver.Cells[Col,Row] = 'No'
              then
                begin
                  sgSolver.Cells[Col,Row] := 'Temp.';
                end
              else if sgSolver.Cells[Col,Row] = 'Temp.'
              then
                begin
                  sgSolver.Cells[Col,Row] := 'Temp. & Enthalpy';
                end
              else
                begin
                  sgSolver.Cells[Col,Row] := 'No';
                end;
            end;
          end;
        Ord(IPRPTCn3):
          begin
            sgSolver.Options := sgSolver.Options - [goEditing];
            if not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '0') and
               not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '') and
               not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '-0') and
               not (StrToInt(sgSolver.Cells[Col,Ord(PrIPresTempMass)]) = 0)
            then
            begin
              if sgSolver.Cells[Col,Row] = 'No'
              then
                begin
                  sgSolver.Cells[Col,Row] := 'Yes';
                end
              else
                begin
                  sgSolver.Cells[Col,Row] := 'No';
                end;
            end;
          end;
        Ord(PrISolMeth),
        Ord(PrICondDisp),
        Ord(PrIPresTempMass),
        Ord(PrIFlDens),
        Ord(PrIVel),
        Ord(PrIFlowBal),
        Ord(PrISpecValFlow),
        Ord(PrIWell),
        Ord(PrICheckPointDump),
        Ord(PriMaps):
          begin
            sgSolver.Options := sgSolver.Options + [goEditing];
          end


      end;
    end;

  // Change the row labels to 'not used' if they aren't used.
  // This is done by first changing them all to 'not used'
  // and then switching them back if appropriate.
  sgSolver.Cells[0,Ord(TimeStepLength)]    := 'Not used';
  sgSolver.Cells[0,Ord(MaxChangePres)]     := 'Not used';
  sgSolver.Cells[0,Ord(MaxChangeTemp)]     := 'Not used';
  sgSolver.Cells[0,Ord(MaxChangeMassFrac)] := 'Not used';
  sgSolver.Cells[0,Ord(MinTimeStep)]       := 'Not used';
  sgSolver.Cells[0,Ord(MaxTimeStep)]       := 'Not used';
  for ColIndex := 1 to sgSolver.ColCount -1 do
  begin
    if sgSolver.Cells[ColIndex,Ord(Automatic)] = 'No' then
    begin
       sgSolver.Cells[0,Ord(TimeStepLength)]    := 'Time step length (DELTIM) (t)';
    end;
    if sgSolver.Cells[ColIndex,Ord(Automatic)] = 'Yes' then
    begin
       sgSolver.Cells[0,Ord(MaxChangePres)]     :=
         'Max change in pres. (DPTAS) (F/L^2)';
       sgSolver.Cells[0,Ord(MaxChangeTemp)]     :=
         'Max change in temp. (DTTAS) (T)';
       sgSolver.Cells[0,Ord(MaxChangeMassFrac)] :=
         'Max change in mass frac. (DCTAS)';
       sgSolver.Cells[0,Ord(MinTimeStep)]       :=
         'Min time step (DTIMMN) (t)';
       sgSolver.Cells[0,Ord(MaxTimeStep)]       :=
         'Max time step (DTIMMX) (t)';
    end;

  end;
  // for the stringgrid to be repainted to reflect changes in the data.
  sgSolver.Invalidate;

end;

// perform error checking on values entered in the string grid to ensure
// that only valid data are entered.
procedure THST3DForm.sgSolverSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  ColIndex : integer;
  AValue : double;
begin

  case ARow of
    Ord(TimeStepLength),
    Ord(MaxChangePres),
    Ord(MaxChangeTemp),
    Ord(MaxChangeMassFrac),
    Ord(MinTimeStep),
    Ord(MaxTimeStep):
      begin
        try
          begin
            If not (sgSolver.Cells[ACol,ARow] = '') then
              begin
                LocalStrToFloat(sgSolver.Cells[ACol,ARow]);
                CurrentTimeCellText := sgSolver.Cells[ACol,ARow];
              end;
          end;
        except on EConvertError do
          begin
                Beep;
                sgSolver.Cells[ACol,ARow] := CurrentTimeCellText;
          end;
        end;
      end;
    Ord(Duration):
      begin
        for ColIndex := ACol to sgSolver.ColCount -1 do
        begin
          try
            if not (sgSolver.Cells[ColIndex, Ord(Duration)] = '') then
            begin
              sgSolver.Cells[ColIndex , Ord(EndTime)] :=
                 FloatToStr( LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(Duration)])
                   + LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(StartTime  )]));
              if ColIndex < sgSolver.ColCount -1 then
              begin
                sgSolver.Cells[ColIndex +1, Ord(StartTime)] :=
                   sgSolver.Cells[ColIndex , Ord(EndTime)];
              end;
            end;
          except
            On EConvertError do
              begin
                sgSolver.Cells[ColIndex, Ord(Duration)] := '0';
              end;
          end
        end;
        if (Copy(sgSolver.Cells[ACol, Ord(Duration)],1,1) = '0') and
            not (Copy(sgSolver.Cells[ACol, Ord(Duration)],2,1) = '.') and
            not  (sgSolver.Cells[ACol, Ord(Duration)] = '0')
             then
        begin
          sgSolver.Cells[ACol, Ord(Duration)] :=
            Copy(sgSolver.Cells[ACol, Ord(Duration)],  2,
               Length(sgSolver.Cells[ACol, Ord(Duration)]));
        end;
        try
          begin
            AValue := LocalStrToFloat(sgSolver.Cells[ACol,ARow]);
            if AValue < 0
            then
              begin
                Beep;
                sgSolver.Cells[ACol,ARow] := CurrentTimeCellText;
              end
            else
              begin
                CurrentTimeCellText := sgSolver.Cells[ACol,ARow];
              end;
          end;
        except
          On EConvertError do
            begin
            end;
        end

      end;
    Ord(PrISolMeth),
    Ord(PrICondDisp),
    Ord(PrIPresTempMass),
    Ord(PrIFlDens),
    Ord(PrIVel),
    Ord(PrIFlowBal),
    Ord(PrISpecValFlow),
    Ord(PrIWell),
    Ord(PrICheckPointDump),
    Ord(PriMaps):
      begin
        try
          begin
            If not (sgSolver.Cells[ACol,ARow] = '') and
               not (sgSolver.Cells[ACol,ARow] = '-') then
              begin
                StrToInt(sgSolver.Cells[ACol,ARow]);
                CurrentTimeCellText := sgSolver.Cells[ACol,ARow];
              end;
          end;
        except on EConvertError do
          begin
                Beep;
                sgSolver.Cells[ACol,ARow] := CurrentTimeCellText;
          end;
        end;
      end;
  end;


end;

// delete the currently selected time period by copying data from later
// time periods over top of it.
procedure THST3DForm.btnDelTimeClick(Sender: TObject);
var
  ColIndex, RowIndex : integer;
begin
  if MessageDlg( 'Are you sure you want to delete this time period?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
  begin
    for ColIndex := sgSolver.Col+1 to sgSolver.ColCount -1 do
    begin
      For RowIndex := 1 to sgSolver.RowCount -1 do
      begin
        sgSolver.Cells[ColIndex-1,RowIndex]
          := sgSolver.Cells[ColIndex,RowIndex];
      end;
    end;
    sgSolver.Cells[sgSolver.ColCount-1,sgSolver.RowCount -1] := '0';
    for ColIndex := sgSolver.Col to sgSolver.ColCount -1 do
    begin
        sgSolver.Cells[ColIndex , Ord(EndTime)] :=
           FloatToStr( LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(Duration)]) +
                       LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(StartTime)]));
        if ColIndex < sgSolver.ColCount -1 then
        begin
          sgSolver.Cells[ColIndex +1, Ord(StartTime)] :=
             sgSolver.Cells[ColIndex , Ord(EndTime)];
        end;
    end;
  end;
  If not (sgSolver.Col = 1)
  then
    begin
      sgSolver.Col := sgSolver.Col -1;
    end;
  sgSolver.Invalidate;
end;

// Insert a new time period by copying the time periods over later time periods.
procedure THST3DForm.btnInsertTimeClick(Sender: TObject);
var
  ColIndex, RowIndex : integer;
begin
    if not (sgSolver.Cells[sgSolver.ColCount-1,Ord(Duration)] = '0') then
    begin
      btnAddTimeClick(Sender);
    end;
    for ColIndex := sgSolver.ColCount -2 downto sgSolver.Col do
    begin
      For RowIndex := 1 to sgSolver.RowCount -1 do
      begin
        sgSolver.Cells[ColIndex+1,RowIndex]
          := sgSolver.Cells[ColIndex,RowIndex];
      end;
    end;
    for ColIndex := sgSolver.Col to sgSolver.ColCount -2 do
    begin
        sgSolver.Cells[ColIndex, Ord(EndTime)] :=
           FloatToStr( LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(Duration)]) +
                       LocalStrToFloat(sgSolver.Cells[ColIndex, Ord(StartTime)]));
        if ColIndex < sgSolver.ColCount -1 then
        begin
          sgSolver.Cells[ColIndex +1, Ord(StartTime)] :=
             sgSolver.Cells[ColIndex , Ord(EndTime)];
        end;
    end;

end;

// Custum drawing of each cell.
procedure THST3DForm.sgSolverDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if not (Row = 0) and (Col > 0) then
  begin
    if (Col = 0)
    then
      begin
        // use a bold font for the row labels of all rows in which the currently
        // selected time period can be editted.
        // use a normal font for the rest.
        if (sgSolver.Col > 1) and
           (
           (sgSolver.Cells[sgSolver.Col-1,Ord(Duration)] = '0') or
           (sgSolver.Cells[sgSolver.Col-1,Ord(Duration)] = '') or
           (sgSolver.Cells[sgSolver.Col-1,Ord(Duration)] = '-') or
           (LocalStrToFloat(sgSolver.Cells[sgSolver.Col-1,Ord(Duration)]) = 0)
           )
        then
          begin
            sgSolver.Canvas.Font.Style := sgSolver.Canvas.Font.Style - [fsBold];
          end
        else
          begin
            case Row of
              Ord(StartTime),
              Ord(Automatic),
              Ord(Duration),
              Ord(PrISolMeth),
              Ord(PrICondDisp),
              Ord(PrIPresTempMass),
              Ord(PrIFlDens),
              Ord(PrIVel),
              Ord(PrIFlowBal),
              Ord(PrISpecValFlow),
              Ord(PrIWell),
              Ord(PrICheckPointDump),
              Ord(PriMaps),
              Ord(CheckPointDump),
              Ord(SavLastDump),
              Ord(ContourMap),
              Ord(VelocityVectorMap):
                begin
                  sgSolver.Canvas.Font.Style :=
                    sgSolver.Canvas.Font.Style + [fsBold];
                end;
              Ord(TimeStepLength) :
                begin
                  if (sgSolver.Cells[sgSolver.Col,Ord(Automatic)] = 'No')
                  then
                    begin
                      sgSolver.Canvas.Font.Style :=
                        sgSolver.Canvas.Font.Style + [fsBold];
                    end
                  else
                    begin
                      sgSolver.Canvas.Font.Style :=
                        sgSolver.Canvas.Font.Style - [fsBold];
                    end;
                end;
              Ord(MaxChangePres),
              Ord(MaxChangeTemp),
              Ord(MaxChangeMassFrac),
              Ord(MinTimeStep),
              Ord(MaxTimeStep) :
                begin
                  if (sgSolver.Cells[sgSolver.Col,Ord(Automatic)] = 'Yes')
                  then
                    begin
                      sgSolver.Canvas.Font.Style :=
                        sgSolver.Canvas.Font.Style + [fsBold];
                    end
                  else
                    begin
                      sgSolver.Canvas.Font.Style :=
                        sgSolver.Canvas.Font.Style - [fsBold];
                    end;
                end;
              Ord(EndTime) :
                begin
                  sgSolver.Canvas.Font.Style :=
                    sgSolver.Canvas.Font.Style - [fsBold];
                end;
              Ord(IPRPTCn1),
              Ord(IPRPTCn2),
              Ord(IPRPTCn3):
                begin
                  if not (sgSolver.Cells[sgSolver.Col,
                            Ord(PrIPresTempMass)] = '0') and
                     not (sgSolver.Cells[sgSolver.Col,
                            Ord(PrIPresTempMass)] = '') and
                     not (sgSolver.Cells[sgSolver.Col,
                            Ord(PrIPresTempMass)] = '-') and
                     not (StrToInt(sgSolver.Cells[sgSolver.Col,
                            Ord(PrIPresTempMass)]) = 0)
                  then
                    begin
                      sgSolver.Canvas.Font.Style :=
                        sgSolver.Canvas.Font.Style + [fsBold];
                    end
                  else
                    begin
                      sgSolver.Canvas.Font.Style :=
                        sgSolver.Canvas.Font.Style - [fsBold];
                    end;
                end;
            end;
          end;
        // write the text to the cell.
        sgSolver.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgSolver.Cells[Col,Row]);
      end
    else
      begin
        // don't use bold font for any of the cells other than those with the
        // row labels.
        sgSolver.Canvas.Font.Style := sgSolver.Canvas.Font.Style - [fsBold];
        // set the background color to Aqua for editable fields in the currently
        // selected time period
        // set it to clWindow for editable fields in other time periods
        // set it to clBtnFace for non-editable fields.
        if (Col > 1) and
           (
             (sgSolver.Cells[Col-1,Ord(Duration)] = '0') or
             (sgSolver.Cells[Col-1,Ord(Duration)] = '') or
             (sgSolver.Cells[Col-1,Ord(Duration)] = '-') or
             (LocalStrToFloat(sgSolver.Cells[Col-1,Ord(Duration)]) = 0) or
             ( not (Row = Ord(Duration)) and
               (
                 (sgSolver.Cells[Col,Ord(Duration)] = '0') or
                 (sgSolver.Cells[Col,Ord(Duration)] = '') or
                 (sgSolver.Cells[Col,Ord(Duration)] = '-') or
                 (LocalStrToFloat(sgSolver.Cells[Col,Ord(Duration)]) = 0)
               )

             )
           )
        then
          begin
            sgSolver.Canvas.Brush.Color := clBtnFace;;
          end
        else
          begin
            case Row of
              Ord(Automatic),
              Ord(Duration),
              Ord(PrISolMeth),
              Ord(PrICondDisp),
              Ord(PrIPresTempMass),
              Ord(PrIFlDens),
              Ord(PrIVel),
              Ord(PrIFlowBal),
              Ord(PrISpecValFlow),
              Ord(PrIWell),
              Ord(PrICheckPointDump),
              Ord(PriMaps),
              Ord(CheckPointDump),
              Ord(SavLastDump),
              Ord(ContourMap),
              Ord(VelocityVectorMap):
                begin
                  if (sgSolver.Col = Col)
                  then
                    begin
                      sgSolver.Canvas.Brush.Color := clAqua;
                    end
                  else
                    begin
                      sgSolver.Canvas.Brush.Color := clWindow;
                    end;
                end;
              Ord(TimeStepLength):
                begin
                  if (sgSolver.Cells[Col,Ord(Automatic)] = 'No')
                  then
                    begin
                      if (sgSolver.Col = Col)
                      then
                        begin
                          sgSolver.Canvas.Brush.Color := clAqua;
                        end
                      else
                        begin
                          sgSolver.Canvas.Brush.Color := clWindow;
                        end;
                    end
                  else
                    begin
                      sgSolver.Canvas.Brush.Color := clBtnFace;
                    end;
                end;
              Ord(MaxChangePres),
              Ord(MaxChangeTemp),
              Ord(MaxChangeMassFrac),
              Ord(MinTimeStep),
              Ord(MaxTimeStep) :
                begin
                  if (sgSolver.Cells[Col,Ord(Automatic)] = 'Yes')
                  then
                    begin
                      if (sgSolver.Col = Col)
                      then
                        begin
                          sgSolver.Canvas.Brush.Color := clAqua;
                        end
                      else
                        begin
                          sgSolver.Canvas.Brush.Color := clWindow;
                        end;
                    end
                  else
                    begin
                      sgSolver.Canvas.Brush.Color := clBtnFace;
                    end;
                end;
              Ord(EndTime) :
                begin
                      sgSolver.Canvas.Brush.Color := clBtnFace;
                end;
              Ord(IPRPTCn1),
              Ord(IPRPTCn2),
              Ord(IPRPTCn3):
                begin
                  if not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '0') and
                     not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '') and
                     not (sgSolver.Cells[Col,Ord(PrIPresTempMass)] = '-') and
                     not (StrToInt(sgSolver.Cells[Col,Ord(PrIPresTempMass)]) = 0)
                  then
                    begin
                      if (sgSolver.Col = Col)
                      then
                        begin
                          sgSolver.Canvas.Brush.Color := clAqua;
                        end
                      else
                        begin
                          sgSolver.Canvas.Brush.Color := clWindow;
                        end;
                    end
                  else
                    begin
                      sgSolver.Canvas.Brush.Color := clBtnFace;
                    end;
                end;
            end;
          end;
        // change the font color to black
        sgSolver.Canvas.Font.Color := clBlack;
        // draw the text
        sgSolver.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgSolver.Cells[Col,Row]);
        // draw the right and lower cell boundaries in black.
        sgSolver.Canvas.Pen.Color := clBlack;
        sgSolver.Canvas.MoveTo(Rect.Right,Rect.Top);
        sgSolver.Canvas.LineTo(Rect.Right,Rect.Bottom);
        sgSolver.Canvas.LineTo(Rect.Left,Rect.Bottom);
      end;
  end;
end;

// restrict the length of the title lines to 80 characters.
procedure THST3DForm.edTitleLinesChange(Sender: TObject);
begin
  If Length(TEdit(Sender).Text) > 79 then
  begin
    Beep;
    TEdit(Sender).Text := Copy(TEdit(Sender).Text, 1, 79);
  end;
end;

// show the Heat Boundary tab if a heat boundary is used.
procedure THST3DForm.cbHeatCondClick(Sender: TObject);
begin
   cbUseBCFLOWClick(Sender);
   cbHeatCondInterp.Enabled := cbHeatCond.Checked;
   if not cbHeatCond.Checked then
   begin
     cbHeatCondInterp.Checked := False;
   end;

  tabHeat.TabVisible := cbHeatCond.Checked;

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(THorHeatCondLayer,
     cbHeatCond.Checked);


   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TVerHeatCondLayer,
      cbHeatCond.Checked);

end;

procedure THST3DForm.edHeatCondBoundNodeNChange(Sender: TObject);
var
  NumHeatNodes, Index : integer;
  RowIndex : integer;
begin
  //error checking for changes in the number of heat nodes.
  // the limts are 2 to 10
  try
    begin
      NumHeatNodes := StrToInt(edHeatCondBoundNodeN.Text);
      if (NumHeatNodes < 1) or (NumHeatNodes > 10)
      then
        begin
          Beep;
          edHeatCondBoundNodeN.Text := PrevNumHeatNodes ;
        end
      else
        begin
          // increase the number of rows in the node spacing grid to match the number of nodes.
          sgHeatCondBoundNodeSpacing.RowCount := NumHeatNodes + 1;
        end;
    end;
  except
    on EConvertError do
    begin
      Beep;
      edHeatCondBoundNodeN.Text := PrevNumHeatNodes;
    end;
  end;

  // update the row titles
  For Index := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    sgHeatCondBoundNodeSpacing.Cells[0,Index] := 'Node ' + IntToStr(Index);
  end;
  // update the row contents
  For RowIndex := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    If sgHeatCondBoundNodeSpacing.Cells[1,RowIndex] = '' then
      begin
        sgHeatCondBoundNodeSpacing.Cells[1,RowIndex] :=
          sgHeatCondBoundNodeSpacing.Cells[1,RowIndex-1];
      end;
  end;
  sgHeatCondBoundNodeSpacing.Cells[1,sgHeatCondBoundNodeSpacing.RowCount -1] :=
      sgHeatCondBoundInitialCond.Cells[1,
         sgHeatCondBoundInitialCond.RowCount -1];

end;

// This is the function used by the sort method of the heat value list.
function CompareHeatValues  (Item1, Item2: Pointer): Integer;
var
  FirstHeat, SecondHeat : THeatBoundLocation;
begin
    FirstHeat := Item1 ;
    SecondHeat := Item2 ;
    if FirstHeat.Value < SecondHeat.Value
    then result := -1
    else if FirstHeat.Value = SecondHeat.Value then result := 0
    else result := 1;
end;

procedure THST3DForm.W01Warning;
var
  W0: double;
  W1: double;
begin
  if adeRefMassFrac.Enabled and adeMaxMassFrac.Enabled then
  begin
    try
      W0 := StrToFloat(adeRefMassFrac.Text);
      W1 := StrToFloat(adeMaxMassFrac.Text);
      if W1 <= W0 then
      begin
        Beep;
        MessageDlg('Error: on the Fluid Properties tab, W1 is less than or '
          + 'equal to  W0.  You will need to fix this before you run HST3D.',
          mtWarning, [mbOK], 0);
      end;
    except on EConvertError do
      begin
      end;
    end;
  end;
end;

// Sort the Heat List and close the form.
procedure THST3DForm.BitBtnOKClick(Sender: TObject);
var
  HeatBoundLocationList : TList;
  HeatBoundLocation : THeatBoundLocation;
  HeatBoundInitialLocation : THeatBoundLocation;
  Index : Integer;
  InvalidLocation : boolean;
  InvalidInitialLocation : boolean;
  InvalidElement : boolean;
begin
  W01Warning;
  HeatBoundLocationList := TList.Create;
  InvalidLocation := False;
  InvalidInitialLocation := False;
  InvalidElement := False;
  try
    begin
      For Index := 1 to StrToInt(edHeatCondBoundNodeN.Text) do
      begin
        HeatBoundLocation := THeatBoundLocation.Create;
        HeatBoundLocation.Text := sgHeatCondBoundNodeSpacing.Cells[1,Index];
        HeatBoundLocation.Value := LocalStrToFloat(HeatBoundLocation.Text);
        HeatBoundLocationList.Add(HeatBoundLocation);
      end;
      HeatBoundLocationList.Sort(CompareHeatValues);
      For Index := 0 to HeatBoundLocationList.Count-1 do
      begin
        HeatBoundLocation := HeatBoundLocationList.Items[Index];
        if not (sgHeatCondBoundNodeSpacing.Cells[1,Index+1] =
          HeatBoundLocation.Text)
        then
          begin
            InvalidLocation := True;
          end;
      end;
      For Index := HeatBoundLocationList.Count-1 downto 0 do
      begin
        HeatBoundLocation := HeatBoundLocationList.Items[Index];
        HeatBoundLocation.Free;
      end;
      HeatBoundLocationList.Clear;

      For Index := 1 to StrToInt(edInitialHeatCondBoundNodeN.Text) do
      begin
        HeatBoundInitialLocation := THeatBoundLocation.Create;
        HeatBoundInitialLocation.Text
          := sgHeatCondBoundInitialCond.Cells[1,Index];
        HeatBoundInitialLocation.Value
          := LocalStrToFloat(HeatBoundInitialLocation.Text);
        HeatBoundLocationList.Add(HeatBoundInitialLocation);
      end;
      HeatBoundLocationList.Sort(CompareHeatValues);
      For Index := 0 to HeatBoundLocationList.Count-1 do
      begin
        HeatBoundInitialLocation := HeatBoundLocationList.Items[Index];
        if not (sgHeatCondBoundInitialCond.Cells[1,Index+1]
          = HeatBoundInitialLocation.Text)
        then
          begin
            InvalidInitialLocation := True;
          end;
      end;
      For Index := HeatBoundLocationList.Count-1 downto 0 do
      begin
        HeatBoundInitialLocation := HeatBoundLocationList.Items[Index];
        HeatBoundInitialLocation.Free;
      end;
    end;
  finally
    begin
      HeatBoundLocationList.Free;
    end;
  end;
  for Index := 1 to sgGeology.RowCount -1 do
  begin
    if not (LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),Index]) >
            LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev),Index])) then
    begin
      InvalidElement := True;
    end;
  end;
  for Index := 1 to sgGeology.RowCount -2 do
  begin
    if not (LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),Index+1]) =
            LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev),Index])) then
    begin
      InvalidElement := True;
    end;
  end;
  if InvalidLocation and cbHeatCond.Checked then
  begin
    MessageDlg('Your heat conduction boundary locations are invalid',
      mtWarning, [mbOK], 0);
  end;
  if InvalidInitialLocation and cbHeatCond.Checked then
  begin
    MessageDlg('Your initial heat conduction boundary locations are invalid',
      mtWarning, [mbOK], 0);
  end;
  if InvalidElement then
  begin
    MessageDlg('Your top and bottom elevations are invalid',
      mtWarning, [mbOK], 0);
  end;
  LayerStructure.UnIndexedLayers.SetIndexed2ExpressionNow(THST3DGridLayer,
    TLayerElevationParameter, TLayerElevationParameter.ANE_ParamName, True);
  LayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow(THST3DGridLayer,
    TT0Parameter, TT0Parameter.ANE_ParamName, True);
  LayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow(THST3DGridLayer,
    TW0Parameter, TW0Parameter.ANE_ParamName, True);
  inherited;
end;

// Don't allow editing of the first nodal distance because it must always be 0.
procedure THST3DForm.sgHeatCondBoundNodeSpacingSelectCell(Sender: TObject;
  Col, Row: Integer; var CanSelect: Boolean);
begin
  if (Col = 1) and (Row = 1)
  then
    begin
      sgHeatCondBoundNodeSpacing.Options
        := sgHeatCondBoundNodeSpacing.Options - [goEditing];
    end
  else
    begin
      sgHeatCondBoundNodeSpacing.Options
        := sgHeatCondBoundNodeSpacing.Options + [goEditing];
    end;
  CurrentHeatNodeDistance := sgHeatCondBoundNodeSpacing.Cells[Col, Row];
end;

// Check that only valid values are entered in the heat node grid
procedure THST3DForm.sgHeatCondBoundNodeSpacingSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: String);
var
  ADouble : Double;
begin
  if not (Value = '') then
  begin
    try
      begin
        ADouble := LocalStrToFloat(Value);
        If (ACol = 1) and (ADouble < 0) then
        begin
          Beep;
          sgHeatCondBoundNodeSpacing.Cells[ACol, ARow]
            := CurrentHeatNodeDistance;
        end;
      end;
    except
      on EConvertError do
      begin
        Beep;
        sgHeatCondBoundNodeSpacing.Cells[ACol, ARow]
          := CurrentHeatNodeDistance;
      end;
    end;
  end;
  if (ARow = sgHeatCondBoundNodeSpacing.RowCount -1) then
  begin
    sgHeatCondBoundInitialCond.Cells[1,sgHeatCondBoundInitialCond.RowCount -1]
      := sgHeatCondBoundNodeSpacing.Cells[ACol, ARow];
  end;
end;

// draw cells in the heat boundary grid.
procedure THST3DForm.sgHeatCondBoundNodeSpacingDrawCell(Sender: TObject;
  Col, Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (Col > 0) and (Row > 0 ) then
  begin
    // use clBtnFace on Column 1, Row 1, to show that it can't be editted
    If (Col = 1) and (Row = 1)
    then
      begin
        sgHeatCondBoundNodeSpacing.Canvas.Brush.Color := clBtnFace;
      end
    else
      begin
        sgHeatCondBoundNodeSpacing.Canvas.Brush.Color := clWindow;
      end;
    // draw the text with a black font.
    sgHeatCondBoundNodeSpacing.Canvas.Font.Color := clBlack;
    sgHeatCondBoundNodeSpacing.Canvas.TextRect(Rect,Rect.Left,Rect.Top,
      sgHeatCondBoundNodeSpacing.Cells[Col,Row]);

    // draw the lower and right edges of the cell with a black line.
    sgHeatCondBoundNodeSpacing.Canvas.Pen.Color := clBlack;
    sgHeatCondBoundNodeSpacing.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgHeatCondBoundNodeSpacing.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgHeatCondBoundNodeSpacing.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

// Save the data in a form to a Val file.
procedure THST3DForm.btnSaveDefaultClick(Sender: TObject);
var
  AString : String ;
  AText : string;
  AStingList : TStringList;
  Path : string;
begin
  AStingList := TStringList.Create;
  GetDllDirectory(DLLName, Path);
  SaveDialog1.FileName := Path + '\Hst3d';

  if rgCoord.ItemIndex = 0
  then
    begin
      SaveDialog1.FileName := SaveDialog1.FileName + 'Cartesian.val';
    end
  else
    begin
      SaveDialog1.FileName := SaveDialog1.FileName + 'Cylindrical.val';
    end;
  if SaveDialog1.Execute then
  begin
    AString :=   FormToString(PIE_Data.HST3DForm);
    While Length(AString) >0 do
    begin

      AText := Copy(AString, 1, Pos(Chr(13) + Chr(10) , AString)-1);
      AString := Copy(AString, Pos(Chr(13) + Chr(10) ,AString)+2,
        Length(AString));
      AStingList.Add(AText);
    end;
    AStingList.SaveToFile(SaveDialog1.Filename);
    AStingList.Free;
  end;
end;

// Load the data from a Val file to a form.
procedure THST3DForm.btnLoadClick(Sender: TObject);
var
  FormString : string;
  AStingList : TStringList;
  Index : integer;

begin
  if OpenDialog1.Execute then
  begin
    AStingList := TStringList.Create;
    AStingList.LoadFromFile(OpenDialog1.Filename);
    FormString := '';
    for Index := 0 to AStingList.Count -1 do
    begin
      FormString := FormString + AStingList.Strings[Index] + Chr(13) + Chr(10);
    end;
    AStingList.Free;

    Load(FormString,  Sender);

  end;
end;

// repaint Argus ONE so it doesn't look bad.
procedure THST3DForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle )
  end;
end;

// update CurrentGeologyRow and CurrentGeologyRow and change the selection
// so that the selected row is painted in a different color.
procedure THST3DForm.sgGeologySelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
//  sgGeology.Row := Row;
  sgGeology.Selection
    := TGridRect(Rect(1,sgGeology.Row,1,sgGeology.Row));
  LastGeologyText := sgGeology.Cells[Col,Row];
  sgGeology.Invalidate;
end;

// Check for the validity of the data entered into sgGeology.
// Update the top or bottom elevation when the user enters data for the other
// so that the data does not need to be entered twice.
procedure THST3DForm.sgGeologySetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
//    The illegal chars are: ()[]+-*=/\.&|'",;~:<>?
  if (ACol = 1) and
   (
     (Pos('(', Value) > 1) or (Pos(')', Value) > 1) or (Pos('[', Value) > 1) or
     (Pos(']', Value) > 1) or (Pos('+', Value) > 1) or (Pos('-', Value) > 1) or
     (Pos('*', Value) > 1) or (Pos('=', Value) > 1) or (Pos('/', Value) > 1) or
     (Pos('\', Value) > 1) or (Pos('.', Value) > 1) or (Pos('&', Value) > 1) or
     (Pos('|', Value) > 1) or (Pos('''', Value) > 1) or (Pos('"', Value) > 1) or
     (Pos(',', Value) > 1) or (Pos(';', Value) > 1) or (Pos('~', Value) > 1) or
     (Pos(':', Value) > 1) or (Pos('<', Value) > 1) or (Pos('>', Value) > 1) or
     (Pos('?', Value) > 1) or
     (Pos('0', Value) = 1) or (Pos('1', Value) = 1) or (Pos('2', Value) = 1) or
     (Pos('3', Value) = 1) or (Pos('4', Value) = 1) or (Pos('5', Value) = 1) or
     (Pos('6', Value) = 1) or (Pos('7', Value) = 1) or (Pos('8', Value) = 1) or
     (Pos('9', Value) = 1)

   )
  then
    begin
      Beep;
      sgGeology.Cells[ACol,ARow] := LastGeologyText;
    end
  else
    begin
      LastGeologyText := sgGeology.Cells[ACol,ARow]
    end;
  if (ACol = Ord(gdTopElev)) or (ACol = Ord(gdBotElev)) then
  begin
    try
      begin
        LocalStrToFloat(sgGeology.Cells[ACol,ARow])
      end;
    except on EConvertError do
      begin
        if (Copy(sgGeology.Cells[ACol, ARow],1,1) = '0') and
            not (Copy(sgGeology.Cells[ACol, ARow],2,1) = '.') and
            not  (sgGeology.Cells[ACol, ARow] = '0')
             then
        begin
          sgGeology.Cells[ACol, ARow] :=
            Copy(sgGeology.Cells[ACol, ARow],  2,
               Length(sgGeology.Cells[ACol, ARow]));
        end;
        if (sgGeology.Cells[ACol,ARow] = '')
        then
          begin
          end
        else if not (sgGeology.Cells[ACol,ARow] = '-') then
          begin
            Beep;
            sgGeology.Cells[ACol,ARow] := LastGeologyText;
          end;
      end;
    end;
        if (Copy(sgGeology.Cells[ACol, ARow],1,1) = '0') and
            not (Copy(sgGeology.Cells[ACol, ARow],2,1) = '.') and
            not  (sgGeology.Cells[ACol, ARow] = '0')
             then
        begin
          sgGeology.Cells[ACol, ARow] :=
            Copy(sgGeology.Cells[ACol, ARow],  2,
               Length(sgGeology.Cells[ACol, ARow]));
        end;

  end;
  if (ACol = Ord(gdTopElev)) and not (ARow = 1) then
  begin
    sgGeology.Cells[Ord(gdBotElev),ARow-1] := sgGeology.Cells[ACol,ARow];
  end;
  if (ACol = Ord(gdBotElev)) and not (ARow = StrToInt(edNumLayers.Text)) then
  begin
    sgGeology.Cells[Ord(gdTopElev),ARow+1] := sgGeology.Cells[ACol,ARow];
  end;
//  sgGeology.Row := ARow;
  sgGeology.Invalidate;

end;

// Make sure that all element layer names are unique.
Procedure THST3DForm.MakeNamesUnique;
var
  AllNamesUnique : Boolean;
  RowIndex1, RowIndex2 : integer;
begin
  repeat
    begin
      AllNamesUnique := True;
      For RowIndex1 := 1 to sgGeology.RowCount -2 do
      begin
        For RowIndex2 := RowIndex1 + 1 to sgGeology.RowCount -1 do
        begin
          if sgGeology.Cells[Ord(gdName),RowIndex1]
            = sgGeology.Cells[Ord(gdName),RowIndex2] then
          begin
            sgGeology.Cells[Ord(gdName),RowIndex2]
              := sgGeology.Cells[Ord(gdName),RowIndex2] + '1';
            AllNamesUnique := False;
          end;
        end;
      end;
    end;
  until AllNamesUnique;

end;

// add a new element layer and node layer and the associated
// grid and well parameters
procedure THST3DForm.btnAddLayerClick(Sender: TObject);
var
  LocationToAddLayer, LocationToAddParameter : integer;
  AWellLayer : TWellLayer;
  AnHST3DGridLayer : THST3DGridLayer;
begin
  edNumLayers.Text := IntToStr(StrToInt(edNumLayers.Text) + 1);
  sgGeology.Selection
    := TGridRect(Rect(1,sgGeology.Row,1,sgGeology.Row));
  sgGeology.Invalidate;
  if (Sender = btnInsertLayer)
  then
    begin
      LastGeologyButton := btnInsertLayer;
      LocationToAddLayer :=
        LayerStructure.ListsOfIndexedLayers.GetNonDeletedIndLayerListIndexByIndex
        (sgGeology.Row-1);
    end
  else
    begin
      LastGeologyButton := btnAddLayer;
      LocationToAddLayer := LayerStructure.ListsOfIndexedLayers.Count-1;
    end;
  TGeologicUnit.Create(LayerStructure.ListsOfIndexedLayers, LocationToAddLayer);

  AnHST3DGridLayer :=
    LayerStructure.UnIndexedLayers.GetLayerByName(kGridLayer)
      as THST3DGridLayer;
  if (Sender = btnInsertLayer)
  then
    begin
      LocationToAddParameter :=
        AnHST3DGridLayer.IndexedParamList1.GetNonDeletedIndParameterListIndexByIndex
        (sgGeology.Row-1);
    end
  else
    begin
      LocationToAddParameter := AnHST3DGridLayer.IndexedParamList1.Count;
    end;
  TGridUnitParameters.Create(AnHST3DGridLayer.IndexedParamList1,
    LocationToAddParameter);

  if (Sender = btnInsertLayer)
  then
    begin
      LocationToAddParameter :=
        AnHST3DGridLayer.IndexedParamList2.GetNonDeletedIndParameterListIndexByIndex
        (sgGeology.Row-1);
    end
  else
    begin
      LocationToAddParameter := AnHST3DGridLayer.IndexedParamList2.Count;
    end;
  TGridNLParameters.Create(AnHST3DGridLayer.IndexedParamList2, LocationToAddParameter);

  if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
  begin
    AWellLayer :=
      LayerStructure.UnIndexedLayers.GetLayerByName(kWellLayerName)
      as TWellLayer;
    if (Sender = btnInsertLayer)
    then
      begin
        LocationToAddParameter :=
          AWellLayer.IndexedParamList1.GetNonDeletedIndParameterListIndexByIndex
          (sgGeology.Row-1);
      end
    else
      begin
        LocationToAddParameter := AWellLayer.IndexedParamList1.Count;
      end;
    TWellUnitParameters.Create(AWellLayer.IndexedParamList1, LocationToAddParameter);
  end;

end;

// delete an element layer and node layer and the associated grid and well parameters
procedure THST3DForm.btnDeleteLayerClick(Sender: TObject);
var
  RowIndex : integer;
  ColumnIndex : integer;
  AGeologicUnit : TGeologicUnit;
  AWellLayer : TWellLayer;
  AWellUnitParameters : TWellUnitParameters;
  AnHST3DGridLayer : THST3DGridLayer;
  AGridUnitParameters : TGridUnitParameters;
  SelectedRow : integer;
  AGridNLParameters : TGridNLParameters;
begin
  SelectedRow :=  sgGeology.Row;
  LastGeologyButton := btnDeleteLayer;
  sgGeology.Selection
    := TGridRect(Rect(1,sgGeology.Row,1,sgGeology.Row));
  if (MessageDlg('Are you sure you wish to delete this layer?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes) then
  begin
    For RowIndex := sgGeology.Row to sgGeology.RowCount -2 do
    begin
      for ColumnIndex := Ord(gdName) to sgGeology.ColCount -1 do
      begin
        sgGeology.Cells[ColumnIndex,RowIndex]
          := sgGeology.Cells[ColumnIndex,RowIndex + 1]
      end;
    end;
    sgGeology.Cells[Ord(gdName),sgGeology.RowCount -1] := '';
    edNumLayers.Text := IntToStr(StrToInt(edNumLayers.Text) - 1);
    sgGeology.Selection:= TGridRect(Rect(1,SelectedRow,1,SelectedRow));
    sgGeology.Invalidate;

    AGeologicUnit :=
       LayerStructure.ListsOfIndexedLayers.GetNonDeletedIndLayerListByIndex
       (SelectedRow -1) as TGeologicUnit;
    AGeologicUnit.DeleteSelf;

    AnHST3DGridLayer :=
        LayerStructure.UnIndexedLayers.GetLayerByName(kGridLayer)
        as THST3DGridLayer;
    AGridUnitParameters :=
        AnHST3DGridLayer.IndexedParamList1.GetNonDeletedIndParameterListByIndex
        (SelectedRow -1 ) as TGridUnitParameters;
    AGridUnitParameters.DeleteSelf;
    AGridNLParameters :=
        AnHST3DGridLayer.IndexedParamList2.GetNonDeletedIndParameterListByIndex
        (SelectedRow -1 ) as TGridNLParameters;
    AGridNLParameters.DeleteSelf;

    if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
    begin
      AWellLayer :=
          LayerStructure.UnIndexedLayers.GetLayerByName(kWellLayerName)
          as TWellLayer;
      AWellUnitParameters :=
          AWellLayer.IndexedParamList1.GetNonDeletedIndParameterListByIndex
          (SelectedRow -1 ) as TWellUnitParameters;
      AWellUnitParameters.DeleteSelf;
    end;
    if SelectedRow > 1
    then
      begin
        sgGeology.Row := SelectedRow -1;
      end
    else
      begin
        sgGeology.Row := 1;
      end;
  end;


end;

// insert an element layer and node layer and the associated grid and well parameters
procedure THST3DForm.btnInsertLayerClick(Sender: TObject);
var
  RowIndex1 : integer;
begin
  btnAddLayerClick(Sender);
  For RowIndex1 := 1 to sgGeology.RowCount -1 do
  begin
    sgGeology.Cells[Ord(gdUnitNum),RowIndex1] := IntToStr(RowIndex1);
  end;
  For RowIndex1 := sgGeology.RowCount -2 downto sgGeology.Row -1 do
  begin
    if RowIndex1 > 0 then
    begin
      sgGeology.Cells[Ord(gdName),RowIndex1+1]
        := sgGeology.Cells[Ord(gdName),RowIndex1];
      sgGeology.Cells[Ord(gdTopElev),RowIndex1+1]
        := sgGeology.Cells[Ord(gdTopElev),RowIndex1];
      sgGeology.Cells[Ord(gdBotElev),RowIndex1+1]
        := sgGeology.Cells[Ord(gdBotElev),RowIndex1];
    end;
  end;
  sgGeology.Cells[Ord(gdName),sgGeology.Row] :=
    'Element Layer' + sgGeology.Cells[Ord(gdUnitNum),sgGeology.Row];
  MakeNamesUnique;
  sgGeology.Selection
    := TGridRect(Rect(1,sgGeology.Row,1,sgGeology.Row));
  sgGeology.Invalidate;

end;

// change the number of layers.
procedure THST3DForm.edNumLayersChange(Sender: TObject);
var
  PrevNumLayers : integer;
  RowIndex1 : integer;
  NewNumLayer : integer;
begin
  try
    begin
      NewNumLayer := StrToInt(edNumLayers.Text);
      if NewNumLayer < 1
      then
        begin
          Beep;
          edNumLayers.Text := PreviousNumberLayersText;
        end
      else
        begin
          PrevNumLayers := sgGeology.RowCount-1;
          sgGeology.RowCount := NewNumLayer + 1;
            For RowIndex1 := PrevNumLayers+1  to sgGeology.RowCount -1 do
            begin
              sgGeology.Cells[Ord(gdUnitNum),RowIndex1] := IntToStr(RowIndex1);
              sgGeology.Cells[Ord(gdName),RowIndex1]
                := 'Element Layer' + sgGeology.Cells[Ord(gdUnitNum),RowIndex1];
              sgGeology.Cells[Ord(gdTopElev),RowIndex1]
                := sgGeology.Cells[Ord(gdBotElev),RowIndex1-1];
              sgGeology.Cells[Ord(gdBotElev),RowIndex1]
                := FloatToStr(LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),
                   RowIndex1])-1);
            end;
          MakeNamesUnique;
          btnDeleteLayer.Enabled := (StrToInt(edNumLayers.Text) > 1);
          sgGeology.Selection
            := TGridRect(Rect(1,sgGeology.Row,1,sgGeology.Row));
          sgGeology.Invalidate;

        end;
    end;
  except on EConvertError do
    begin
      Beep;
      edNumLayers.Text := PreviousNumberLayersText;
    end
  end;

end;

// draw the grid of element layer elevations.
procedure THST3DForm.sgGeologyDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (Col > Ord(gdUnitNum)) and (Row > 0)
  then
    begin
      // set the background color to Aqua for editable fields in the currently
      // selected time period
      // set it to clWindow for editable fields in other time periods
      // set it to clBtnFace for non-editable fields.
//      if (sgGeology.Row = Row)
      if (sgGeology.Row = Row)
      then
        begin
          sgGeology.Canvas.Brush.Color := clAqua;
        end
      else
        begin
          sgGeology.Canvas.Brush.Color := clWindow;
        end;
      if (Col = Ord(gdTopElev)) and not (Row = 1) then
      begin
        if not (sgGeology.Cells[Ord(gdBotElev),Row-1]
                = sgGeology.Cells[Col,Row]) then
        begin
          sgGeology.Canvas.Brush.Color := clRed;
        end;
      end;
      if (Col = Ord(gdBotElev)) and not (Row = StrToInt(edNumLayers.Text)) then
      begin
        if not (sgGeology.Cells[Ord(gdTopElev),Row+1]
          = sgGeology.Cells[Col,Row]) then
        begin
          sgGeology.Canvas.Brush.Color := clRed;
        end;
      end;
      if (Col = Ord(gdTopElev)) or (Col = Ord(gdBotElev)) then
      begin
        try
          begin
            if (sgGeology.Cells[Ord(gdTopElev),Row] = '-')
                or (sgGeology.Cells[Ord(gdBotElev),Row] = '-')
                or (sgGeology.Cells[Ord(gdTopElev),Row] = '')
                or (sgGeology.Cells[Ord(gdBotElev),Row] = '')
            then
              begin
                sgGeology.Canvas.Brush.Color := clRed;
              end
            else if not (LocalStrToFloat( sgGeology.Cells[Ord(gdTopElev),Row])
              > LocalStrToFloat( sgGeology.Cells[Ord(gdBotElev),Row]))
            then
              begin
                sgGeology.Canvas.Brush.Color := clRed;
              end
          end;
        except on EConvertError do
          begin
              sgGeology.Canvas.Brush.Color := clRed;
          end;
        end;
      end;
      // change the font color to black
      sgGeology.Canvas.Font.Color := clBlack;
      // draw the text
      sgGeology.Canvas.TextRect(Rect,Rect.Left,Rect.Top,
        sgGeology.Cells[Col,Row]);
      // draw the right and lower cell boundaries in black.
      sgGeology.Canvas.Pen.Color := clBlack;
      sgGeology.Canvas.MoveTo(Rect.Right,Rect.Top);
      sgGeology.Canvas.LineTo(Rect.Right,Rect.Bottom);
      sgGeology.Canvas.LineTo(Rect.Left,Rect.Bottom);
    end;

end;

procedure THST3DForm.cbWellRiserClick(Sender: TObject);
begin
  tabWellRiser.TabVisible := cbWellRiser.Checked;
  adeMaxIterWell.Enabled := cbWellRiser.Checked;
  adeTolWell.Enabled := cbWellRiser.Checked;
  adeTolFracPresWell.Enabled := cbWellRiser.Checked;
  adeTolFracFlowWell.Enabled := cbWellRiser.Checked;
  adeDampWell.Enabled := cbWellRiser.Checked;
  adeMinStepWell.Enabled := cbWellRiser.Checked;
  adeFracTolIntWell.Enabled := cbWellRiser.Checked;
  lblMaxIterWell.Enabled := cbWellRiser.Checked;
  lblTolWell.Enabled := cbWellRiser.Checked;
  lblTolFracPresWell.Enabled := cbWellRiser.Checked;
  lblTolFracFlowWell.Enabled := cbWellRiser.Checked;
  lblDampWell.Enabled := cbWellRiser.Checked;
  lblMinStepWell.Enabled := cbWellRiser.Checked;
  lblFracTolIntWell.Enabled := cbWellRiser.Checked;

   ActivateWellParam;
   ActivateWellHeatParam;

  
     AddWellRiserTimeHeatParameters;
     AddWellRiserHeatParameters;
     AddWellRiserParameters

end;

procedure THST3DForm.sgHeatCondBoundInitialCondDrawCell(Sender: TObject;
  Col, Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (Col > 0) and (Row > 0 ) then
  begin
    // use clBtnFace on Column 1, Row 1, to show that it can't be editted
    If (Col = 1) and (Row = 1)
    then
      begin
        sgHeatCondBoundInitialCond.Canvas.Brush.Color := clBtnFace;
      end
    else
      begin
        sgHeatCondBoundInitialCond.Canvas.Brush.Color := clWindow;
      end;
    // draw the text with a black font.
    sgHeatCondBoundInitialCond.Canvas.Font.Color := clBlack;
    sgHeatCondBoundInitialCond.Canvas.TextRect(Rect,Rect.Left,Rect.Top,
      sgHeatCondBoundInitialCond.Cells[Col,Row]);
    // draw the lower and right edges of the cell with a black line.
    sgHeatCondBoundInitialCond.Canvas.Pen.Color := clBlack;
    sgHeatCondBoundInitialCond.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgHeatCondBoundInitialCond.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgHeatCondBoundInitialCond.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

procedure THST3DForm.sgHeatCondBoundInitialCondSelectCell(Sender: TObject;
  Col, Row: Integer; var CanSelect: Boolean);
begin
  if (Col = 1) and (Row = 1)
  then
    begin
      sgHeatCondBoundInitialCond.Options
        := sgHeatCondBoundInitialCond.Options - [goEditing];
    end
  else
    begin
      sgHeatCondBoundInitialCond.Options
        := sgHeatCondBoundInitialCond.Options + [goEditing];
    end;
  CurrentHeatNodeDistance := sgHeatCondBoundInitialCond.Cells[Col, Row];
end;

procedure THST3DForm.sgHeatCondBoundInitialCondSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: String);
var
  ADouble : Double;
begin
  if not (Value = '') then
  begin
    try
      begin
        ADouble := LocalStrToFloat(Value);
        If (ACol = 1) and (ADouble < 0) then
        begin
          Beep;
          sgHeatCondBoundInitialCond.Cells[ACol, ARow]
            := CurrentHeatNodeDistance;
        end;
      end;
    except
      on EConvertError do
      begin
        Beep;
        sgHeatCondBoundInitialCond.Cells[ACol, ARow]
          := CurrentHeatNodeDistance;
      end;
    end;
  end;
  if (ARow = sgHeatCondBoundInitialCond.RowCount -1) then
  begin
    sgHeatCondBoundNodeSpacing.Cells[1,sgHeatCondBoundNodeSpacing.RowCount -1]
      := sgHeatCondBoundInitialCond.Cells[ACol, ARow];
  end;
end;

procedure THST3DForm.edInitialHeatCondBoundNodeNChange(Sender: TObject);
var
  NumHeatNodes, Index : integer;
  RowIndex, ColumnIndex : integer;
begin
  //error checking for changes in the number of heat nodes.
  // the limts are 2 to 10
  try
    begin
      NumHeatNodes := StrToInt(edInitialHeatCondBoundNodeN.Text);
      if (NumHeatNodes < 1) or (NumHeatNodes > 10)
      then
        begin
          Beep;
          edInitialHeatCondBoundNodeN.Text := PrevNumInitHeatNodes ;
        end
      else
        begin
          // increase the number of rows in the node spacing grid
          // to match the number of nodes.
          sgHeatCondBoundInitialCond.RowCount := NumHeatNodes + 1;
        end;
    end;
  except
    on EConvertError do
    begin
      Beep;
      edHeatCondBoundNodeN.Text := PrevNumInitHeatNodes;
    end;
  end;

  // update the row titles
  For Index := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    sgHeatCondBoundInitialCond.Cells[0,Index] := 'Node ' + IntToStr(Index);
  end;
  // update the row contents
  For RowIndex := 1 to sgHeatCondBoundInitialCond.RowCount -1 do
  begin
    For ColumnIndex := 1 to sgHeatCondBoundInitialCond.ColCount -1 do
    begin
      If sgHeatCondBoundInitialCond.Cells[ColumnIndex,RowIndex] = '' then
          sgHeatCondBoundInitialCond.Cells[ColumnIndex,RowIndex]
          := sgHeatCondBoundInitialCond.Cells[ColumnIndex,RowIndex-1];
    end;
  end;

  sgHeatCondBoundInitialCond.Cells[1,sgHeatCondBoundInitialCond.RowCount -1] :=
      sgHeatCondBoundNodeSpacing.Cells[1,
      sgHeatCondBoundNodeSpacing.RowCount -1];

end;

procedure THST3DForm.edHeatCondBoundNodeNExit(Sender: TObject);
var
  NumHeatNodes, Index : integer;
  RowIndex, ColumnIndex : integer;
begin
  //error checking for changes in the number of heat nodes.
  // the limts are 2 to 10
  try
    begin
      NumHeatNodes := StrToInt(edHeatCondBoundNodeN.Text);
      if (NumHeatNodes < 2) or (NumHeatNodes > 10)
      then
        begin
          Beep;
          edHeatCondBoundNodeN.Text := PrevNumHeatNodes ;
          edHeatCondBoundNodeN.SetFocus;
        end
      else
        begin
          // increase the number of rows in the node spacing grid
          // to match the number of nodes.
          sgHeatCondBoundNodeSpacing.RowCount := NumHeatNodes + 1;
          PrevNumHeatNodes := edHeatCondBoundNodeN.Text;
        end;
    end;
  except
    on EConvertError do
    begin
      Beep;
      edHeatCondBoundNodeN.Text := PrevNumHeatNodes;
      edHeatCondBoundNodeN.SetFocus;
    end;
  end;

  // update the row titles
  For Index := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    sgHeatCondBoundNodeSpacing.Cells[0,Index] := 'Node ' + IntToStr(Index);
  end;
  // update the row contents
  For RowIndex := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    For ColumnIndex := 1 to sgHeatCondBoundNodeSpacing.ColCount -1 do
    begin
      If sgHeatCondBoundNodeSpacing.Cells[ColumnIndex,RowIndex] = '' then
          sgHeatCondBoundNodeSpacing.Cells[ColumnIndex,RowIndex] := '0';
    end;
  end;

end;

procedure THST3DForm.edInitialHeatCondBoundNodeNExit(Sender: TObject);
var
  NumHeatNodes, Index : integer;
  RowIndex, ColumnIndex : integer;
begin
  //error checking for changes in the number of heat nodes.
  // the limts are 2 to 10
  try
    begin
      NumHeatNodes := StrToInt(edInitialHeatCondBoundNodeN.Text);
      if (NumHeatNodes < 2) or (NumHeatNodes > 10)
      then
        begin
          Beep;
          edInitialHeatCondBoundNodeN.Text := PrevNumInitHeatNodes ;
          edInitialHeatCondBoundNodeN.SetFocus;
        end
      else
        begin
          // increase the number of rows in the node spacing grid
          // to match the number of nodes.
          sgHeatCondBoundInitialCond.RowCount := NumHeatNodes + 1;
          PrevNumInitHeatNodes := edInitialHeatCondBoundNodeN.Text;
        end;
    end;
  except
    on EConvertError do
    begin
      Beep;
      edHeatCondBoundNodeN.Text := PrevNumInitHeatNodes;
      edInitialHeatCondBoundNodeN.SetFocus;
    end;
  end;

  // update the row titles
  For Index := 1 to sgHeatCondBoundNodeSpacing.RowCount -1 do
  begin
    sgHeatCondBoundInitialCond.Cells[0,Index] := 'Node ' + IntToStr(Index);
  end;
  // update the row contents
  For RowIndex := 1 to sgHeatCondBoundInitialCond.RowCount -1 do
  begin
    For ColumnIndex := 1 to sgHeatCondBoundInitialCond.ColCount -1 do
    begin
      If sgHeatCondBoundInitialCond.Cells[ColumnIndex,RowIndex] = '' then
          sgHeatCondBoundInitialCond.Cells[ColumnIndex,RowIndex] := '0';
    end;
  end;

end;

// make sure that the time grid has valid values.
procedure THST3DForm.sgSolverExit(Sender: TObject);
var
  ColIndex : integer;
begin
  with sgSolver do
  begin
    for ColIndex := 1 to ColCount -1 do
    begin
      if (Cells[ColIndex,Ord(PrISolMeth)] = '') or
         (Cells[ColIndex,Ord(PrISolMeth)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrISolMeth)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrISolMeth)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrICondDisp)] = '') or
         (Cells[ColIndex,Ord(PrICondDisp)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrICondDisp)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrICondDisp)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrIPresTempMass)] = '') or
         (Cells[ColIndex,Ord(PrIPresTempMass)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrIPresTempMass)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrIPresTempMass)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrIFlDens)] = '') or
         (Cells[ColIndex,Ord(PrIFlDens)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrIFlDens)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrIFlDens)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrIVel)] = '') or
         (Cells[ColIndex,Ord(PrIVel)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrIVel)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrIVel)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrIFlowBal)] = '') or
         (Cells[ColIndex,Ord(PrIFlowBal)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrIFlowBal)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrIFlowBal)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrISpecValFlow)] = '') or
         (Cells[ColIndex,Ord(PrISpecValFlow)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrISpecValFlow)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrISpecValFlow)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrIWell)] = '') or
         (Cells[ColIndex,Ord(PrIWell)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrIWell)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrIWell)] := '0'
      end;

      if (Cells[ColIndex,Ord(PrICheckPointDump)] = '') or
         (Cells[ColIndex,Ord(PrICheckPointDump)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PrICheckPointDump)]) = 0) then
      begin
        Cells[ColIndex,Ord(PrICheckPointDump)] := '0'
      end;

      if (Cells[ColIndex,Ord(PriMaps)] = '') or
         (Cells[ColIndex,Ord(PriMaps)] = '-') or
         (StrToInt(Cells[ColIndex,Ord(PriMaps)]) = 0) then
      begin
        Cells[ColIndex,Ord(PriMaps)] := '0'
      end;

    end;
  end;
end;

// resize the panels containing the two heat conduction grids
// so that each panel is the same size as the other.
// This is also called by PageControl1.
procedure THST3DForm.FormResize(Sender: TObject);
begin
  FreePageControlResources(PageControl1, Handle);
  pnlInitialHeatCondBoundNodeN.Height := Round(tabHeat.Height/2);
  sgWellTime.Height := Round(tabWells.Height/2);
end;

// This is called by any of the three specified state check boxes when they
// are checked.
procedure THST3DForm.cbSpecPresClick(Sender: TObject);
begin
   // update BCFLOW-related paramters.
   cbUseBCFLOWClick(Sender);

   // enable or disable related check boxes and set them
   // to unchecked if appropriate
   cbSpecPresInterp.Enabled := cbSpecPres.Checked;
   if not cbSpecPres.Checked then
   begin
     cbSpecPresInterp.Checked := False;
   end;

   cbSpecMassInterp.Enabled := cbSpecMass.Checked and cbSolute.Checked;
   if not (cbSpecMass.Checked and cbSolute.Checked) then
   begin
     cbSpecMassInterp.Checked := False;
   end;

   cbSpecTempInterp.Enabled := cbSpecTemp.Checked and cbHeat.Checked;
   if not (cbSpecTemp.Checked and cbHeat.Checked) then
   begin
     cbSpecTempInterp.Checked := False;
   end;

   cbInterpMassSpecPress.Enabled := cbSpecPres.Checked and
     cbSolute.Checked and cbSpecPresInterp.Checked;

   cbInterpScMassFracSpecPres.Enabled := cbSpecPres.Checked
     and cbSolute.Checked and cbSpecPresInterp.Checked;

   if not cbSpecPres.Checked or not cbSolute.Checked
      or not cbSpecPresInterp.Checked then
   begin
     cbInterpMassSpecPress.Checked := False;
     cbInterpScMassFracSpecPres.Checked := False;
   end;

   // add or remove the specified state layer if required.
   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TSpecifiedStateLayer,
      cbSpecPres.Checked or cbSpecTemp.Checked
     or cbSpecMass.Checked);

   // add or remove specified state parameters.
   AddSpecStatPresParameters;
   AddSpecStatSoluteParameters;
   AddSpecStatHeatParameters;

   // add or remove interpolation-related parameters.
   // these need to be called here because during loading, the interpolations
   // check boxes might be checked before the specified state ones are.
   cbInterpSpecPresClick(Sender);
   cbInterpTempSpecPresClick(Sender);
   cbInterpMassSpecPressClick(Sender);
   cbInterpScMassFracSpecPresClick(Sender);
   cbSpecMassInterpClick(Sender);

end;

// This is called by any of the three specified flow check boxes when they
// are checked.
procedure THST3DForm.cbSpecFlowClick(Sender: TObject);
begin
   // update BCFLOW-related paramters.
   cbUseBCFLOWClick(Sender);

   // enable or disable related check boxes and set them
   // to unchecked if appropriate
   cbSpecFlowInterp.Enabled := cbSpecFlow.Checked;
   if not cbSpecFlow.Checked then
   begin
     cbSpecFlowInterp.Checked := False;
   end;

   cbSpecHeatInterp.Enabled := cbSpecHeat.Checked;
   if not cbSpecHeat.Checked then
   begin
     cbSpecHeatInterp.Checked := False;
   end;

   cbSpecSoluteInterp.Enabled := cbSpecSolute.Checked;
   if not cbSpecSolute.Checked then
   begin
     cbSpecSoluteInterp.Checked := False;
   end;

   // add or remove the specified flow layers if required.
   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(THorSpecFluxLayer,
     cbSpecFlow.Checked or cbSpecHeat.Checked or cbSpecSolute.Checked);

   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TVerSpecFluxLayer,
     cbSpecFlow.Checked or cbSpecHeat.Checked or cbSpecSolute.Checked);

   AddSpecFluxParameters;
   AddSpecFluxHeatParameters;
   AddSpecFluxSoluteParameters;

   cbFluidFluxInterpClick(Sender);
   cbFluxDensityInterpClick(Sender);
   cbFluxTempInterpClick(Sender);
   cbFluxMassFracInterpClick(Sender);
   cbFluxScMassFracInterpClick(Sender);
end;

procedure THST3DForm.cbLeakageClick(Sender: TObject);
begin
   cbUseBCFLOWClick(Sender);
   cbLeakageInterp.Enabled := cbLeakage.Checked;
   if not cbLeakage.Checked then
   begin
     cbLeakageInterp.Checked := False;
   end;

   // You are not allowed to have a tilted coordinate system
   // with leakage boundaries
   cbTiltCoord.Enabled := not cbFreeSurf.Checked and not cbLeakage.Checked
      and not cbRiver.Checked and (rgCoord.ItemIndex = Ord(csCartesian));
   if not cbTiltCoord.Enabled then
   begin
     cbTiltCoord.Checked := False;
   end;

   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(
     THorAqLeakageLayer,  cbLeakage.Checked);

   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(
     TVerAqLeakageLayer,  cbLeakage.Checked);

end;

procedure THST3DForm.cbRiverClick(Sender: TObject);
begin
   cbUseBCFLOWClick(Sender);
   cbRiverInterp.Enabled := cbRiver.Checked;
   if not cbRiver.Checked then
   begin
     cbRiverInterp.Checked := False;
   end;

  cbTiltCoord.Enabled := not cbFreeSurf.Checked and not cbLeakage.Checked
     and not cbRiver.Checked and (rgCoord.ItemIndex = Ord(csCartesian));
  if not cbTiltCoord.Enabled then
  begin
    cbTiltCoord.Checked := False;
  end;

  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(TRiverLayer,
     cbRiver.Checked);

end;

procedure THST3DForm.cbETClick(Sender: TObject);
begin
   cbUseBCFLOWClick(Sender);
   cbETInterp.Enabled := cbET.Checked;
   if not cbET.Checked then
   begin
     cbETInterp.Checked := False;
   end;

   LayerStructure.UnIndexedLayers.AddOrRemoveLayer(THorETLayer,
      cbET.Checked);

{   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TVerETLayer,
      cbET.Checked);  }

end;

procedure THST3DForm.AddSpecStatSoluteParameters;
begin
   //-----------------------------------
   if cbSpecPres.Checked or cbSpecTemp.Checked or cbSpecMass.Checked then
   begin

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TMassFracAtSpecifiedPresParam,
              cbSolute.Checked and cbSpecPres.Checked
              and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TScaledMassFracAtSpecifiedPresParam,
              cbSolute.Checked and cbSpecPres.Checked
              and (rgMassFrac.ItemIndex = 1));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TSpecifiedMassFracParam,
              cbSolute.Checked and cbSpecMass.Checked
              and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TSpecifiedStateScMassFracParam,
              cbSolute.Checked and cbSpecMass.Checked
              and (rgMassFrac.ItemIndex = 1));

   end; // if cbSpecPres.Checked or cbSpecTemp.Checked
        // or cbSpecMass.Checked then

end;

procedure THST3DForm.AddSpecFluxSoluteParameters;
begin
   if cbSpecFlow.Checked or cbSpecHeat.Checked or cbSpecSolute.Checked then
   begin
     AddSpecFluxMassFracPar;

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TUpSoluteFluxParam,
        cbSolute.Checked and cbSpecSolute.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TSoluteFluxParam,
        cbSolute.Checked and cbSpecSolute.Checked);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddGridSoluteParameters;
begin
   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     TDistCoefParameter,
       cbSolute.Checked);
end;

procedure THST3DForm.AddGridHeatOrSoluteParameters;
begin
   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     TLongDispParameter,
     cbSolute.Checked or cbHeat.Checked);

   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     TTransDispParameter,
     cbSolute.Checked or cbHeat.Checked);

end;

procedure THST3DForm.AddAquifLeakSoluteParameters;
begin
   if cbLeakage.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorAqLeakageLayer, TMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorAqLeakageLayer, TScaledMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 1));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerAqLeakageLayer, TMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerAqLeakageLayer, TScaledMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 1));

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddAquifInflSoluteParameters;
begin
   if cbAqInfl.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorAqInflLayer, TMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorAqInflLayer, TScaledMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 1));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerAqInflLayer, TMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerAqInflLayer, TScaledMassFraction,
       cbSolute.Checked and (rgMassFrac.ItemIndex = 1));

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddDistCoefSoluteLayers;
var
  Index : integer;
  AGeologicUnit : TGeologicUnit;
begin
  for Index := 0 to LayerStructure.ListsOfIndexedLayers.Count -2 do
  begin
    AGeologicUnit := LayerStructure.ListsOfIndexedLayers.Items[Index] as TGeologicUnit;

    AGeologicUnit.AddOrRemoveLayer(TDistCoefLayer,
      cbSolute.Checked);
  end;
//   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TDistCoefLayer,
//     KDistCoef, cbSolute.Checked);
end;

procedure THST3DForm.AddDispHeatSoluteLayers;
var
  Index : integer;
  AGeologicUnit : TGeologicUnit;
begin
  for Index := 0 to LayerStructure.ListsOfIndexedLayers.Count -2 do
  begin
    AGeologicUnit := LayerStructure.ListsOfIndexedLayers.Items[Index] as TGeologicUnit;

    AGeologicUnit.AddOrRemoveLayer(TDispLayer,
      cbSolute.Checked or cbHeat.Checked);
  end;
//   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TDispLayer,
//     kDispLayer, cbSolute.Checked or cbHeat.Checked);
end;

procedure THST3DForm.AddInitMassFracSoluteLayers;
begin
   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(
     TInitialMassFracLayer,
      cbSolute.Checked );
end;

procedure THST3DForm.AddWellRiserHeatParameters;
begin
  if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
  begin
    LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
      TWellHeatTransCoef,
      cbWells.Checked and cbHeat.Checked and cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

    LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
      TWellThermDif,
      cbWells.Checked and cbHeat.Checked and cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

    LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
      TWellMediumThermCond,
      cbWells.Checked and cbHeat.Checked and cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

    LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
      TWellPipeThermCond,
      cbWells.Checked and cbHeat.Checked and cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

    LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
      TWellBottomTemp,
      cbWells.Checked and cbHeat.Checked and cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

    LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
      TWellTopTemp,
      cbWells.Checked and cbHeat.Checked and cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));
  end;

end;

procedure THST3DForm.AddGridHeatParameters;
begin
   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     THeatCapacityParameter,   cbHeat.Checked);

   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     TXConductivityParameter,   cbHeat.Checked);

   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     TYConductivityParameter,   cbHeat.Checked);

   LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1(THST3DGridLayer,
     TZConductivityParameter,   cbHeat.Checked);

end;

procedure THST3DForm.AddSpecStatHeatParameters;
begin
   if cbSpecPres.Checked or cbSpecTemp.Checked or cbSpecMass.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
        (TSpecifiedStateLayer, TTempAtSpecifiedPresParam,
         cbHeat.Checked and cbSpecPres.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
        (TSpecifiedStateLayer, TSpecifiedTempParam,
         cbHeat.Checked and cbSpecTemp.Checked);

   end; // if cbSpecPres.Checked or cbSpecTemp.Checked
        // or cbSpecMass.Checked then

end;

procedure THST3DForm.AddSpecFluxHeatParameters;
begin
   if cbSpecFlow.Checked or cbSpecHeat.Checked or cbSpecSolute.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TUpHeatFluxParam,
        cbHeat.Checked and cbSpecHeat.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, THeatFluxParam,
        cbHeat.Checked and cbSpecHeat.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TTemperature,
        cbSpecFlow.Checked and cbHeat.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TTemperature,
        cbSpecFlow.Checked and cbHeat.Checked);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddAquifLeakHeatParameters;
begin
   if cbLeakage.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorAqLeakageLayer, TTemperature,
        cbHeat.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerAqLeakageLayer, TTemperature,
        cbHeat.Checked);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddAquifInflHeatParameters;
begin
   if cbAqInfl.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorAqInflLayer, TTemperature,
        cbHeat.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerAqInflLayer, TTemperature,
        cbHeat.Checked);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddInitTempHeatLayers;
begin
   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TInitialTempLayer,
      cbHeat.Checked);

   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(THorHeatCondLayer,
      cbHeat.Checked and cbHeatCond.Checked);

   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TVerHeatCondLayer,
      cbHeat.Checked and cbHeatCond.Checked);

end;

procedure THST3DForm.AddHeatCapThermCondHeatLayers;
var
  Index : integer;
  AGeologicUnit : TGeologicUnit;
begin
  for Index := 0 to LayerStructure.ListsOfIndexedLayers.Count -2 do
  begin
    AGeologicUnit := LayerStructure.ListsOfIndexedLayers.Items[Index] as TGeologicUnit;

    AGeologicUnit.AddOrRemoveLayer(THeatCapLayer,
      cbHeat.Checked);

    AGeologicUnit.AddOrRemoveLayer(TThermCondLayer,
      cbHeat.Checked);
  end;
{   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TThermCondLayer,
     kThermLayer, cbHeat.Checked);

   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TThermCondLayer,
     kThermLayer, cbHeat.Checked);  }

end;

procedure THST3DForm.AddWellRiserTimeHeatParameters;
begin
   if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
   begin
       LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(TWellLayer,
         TWellLandSurfPres,
         cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)))
   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddWellRiserParameters;
begin
   if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
   begin
     LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
       TWellRiserPipeLength,
       cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

     LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
       TWellRiserPipeInsideDiam,
       cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

     LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
       TWellRiserPipeRoughness,
       cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

     LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter(TWellLayer,
       TWellRiserPipeAngle,
       cbWellRiser.Checked and (rgCoord.ItemIndex = Ord(csCartesian)));

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddSpecStatPresParameters;
begin
   if cbSpecPres.Checked or cbSpecTemp.Checked or cbSpecMass.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TSpecifiedPresParam,
        cbSpecPres.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TTempAtSpecifiedPresParam,
        cbHeat.Checked and cbSpecPres.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TMassFracAtSpecifiedPresParam,
        cbSolute.Checked and cbSpecPres.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TSpecifiedStateLayer, TScaledMassFracAtSpecifiedPresParam,
        cbSolute.Checked and cbSpecPres.Checked);

   end; // if cbSpecPres.Checked or cbSpecTemp.Checked
        // or cbSpecMass.Checked then

end;

procedure THST3DForm.AddSpecFluxParameters;
begin
   if cbSpecFlow.Checked or cbSpecHeat.Checked or cbSpecSolute.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TUpFluidFluxParam,
        cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TDensityLayerParam,
        cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TTemperature,
        cbSpecFlow.Checked and cbHeat.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TFluidFluxParam,
        cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TDensityLayerParam,
        cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TTemperature,
        cbSpecFlow.Checked and cbHeat.Checked);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.sgGeologyExit(Sender: TObject);
var
  RowIndex : integer;
begin
  for RowIndex := 1 to sgGeology.RowCount -1 do
  begin
    if Trim(sgGeology.Cells[Ord(gdName),RowIndex]) = '' then
    begin
      sgGeology.Cells[Ord(gdName),RowIndex] := 'Element Layer' + IntToStr(RowIndex);
    end;
    try
      begin
        LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),RowIndex]);
      end;
    except
      on EConvertError do
      begin
        sgGeology.Cells[Ord(gdTopElev),RowIndex] := '0';
      end;
    end;
    try
      begin
        LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev),RowIndex]);
      end;
    except
      on EConvertError do
      begin
        sgGeology.Cells[Ord(gdBotElev),RowIndex] := '0';
      end;
    end;
  end;
  MakeNamesUnique;
end;

procedure THST3DForm.AddInitPressLayer;
begin
   LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TInitialPresLayer,
      not cbSpecInitPres.Checked and not cbInitWatTable.Checked);

end;

procedure THST3DForm.AddInitWatTable;
begin
  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(TInitWatTabLayer,
     cbFreeSurf.Checked and cbInitWatTable.Checked);

end;

procedure THST3DForm.cbInitWatTableClick(Sender: TObject);
begin
  adeElevInitPres.Enabled := (cbSpecInitPres.Checked
    and not cbInitWatTable.Checked);

  adeInitPres.Enabled := (cbSpecInitPres.Checked
    and not cbInitWatTable.Checked);

  lblElevInitPres.Enabled := (cbSpecInitPres.Checked
    and not cbInitWatTable.Checked);

  lblInitPres.Enabled := (cbSpecInitPres.Checked
    and not cbInitWatTable.Checked);

  cbWatTableInitialInterp.Enabled := (not cbSpecInitPres.Checked and
                               cbInitWatTable.Checked and cbFreeSurf.Checked);
  if not cbWatTableInitialInterp.Enabled then
  begin
    cbWatTableInitialInterp.Checked := False;
  end;

  cbInitPresInterp.Enabled := not cbSpecInitPres.Checked
    and not cbInitWatTable.Checked ;
  if not cbInitPresInterp.Enabled then
  begin
    cbInitPresInterp.Checked := False;
  end;

  cbSpecInitPres.Enabled := not cbInitWatTable.Checked;
  if not cbSpecInitPres.Enabled then
  begin
    cbSpecInitPres.Checked := False;
  end;

  AddInitWatTable;
  AddInitPressLayer;

end;

procedure THST3DForm.AddSpecFluxMassFracPar;
begin
   if cbSpecFlow.Checked or cbSpecHeat.Checked or cbSpecSolute.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TMassFraction,
        cbSolute.Checked and (rgMassFrac.ItemIndex = 0) and cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (THorSpecFluxLayer, TScaledMassFraction,
        cbSolute.Checked and (rgMassFrac.ItemIndex = 1) and cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TMassFraction,
        cbSolute.Checked and (rgMassFrac.ItemIndex = 0) and cbSpecFlow.Checked);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
       (TVerSpecFluxLayer, TScaledMassFraction,
        cbSolute.Checked and (rgMassFrac.ItemIndex = 1) and cbSpecFlow.Checked);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddInitMassFracPar;
begin
   if cbSolute.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
       (TInitialMassFracLayer, TInitialMassFracParam,
        cbSolute.Checked
          and (rgMassFrac.ItemIndex = 0));

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
       (TInitialMassFracLayer, TInitialScaledMassFracParam,
        cbSolute.Checked
        and (rgMassFrac.ItemIndex = 1));

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        //  or cbSpecSolute.Checked then

end;

procedure THST3DForm.AddWellTimeSoluteParameters;
begin
   if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
   begin
       LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2( TWellLayer,
         TMassFraction,
         cbSolute.Checked and (rgMassFrac.ItemIndex = 0) and (rgCoord.ItemIndex = Ord(csCartesian)));

       LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2( TWellLayer,
         TScaledMassFraction,
         cbSolute.Checked and (rgMassFrac.ItemIndex = 1) and (rgCoord.ItemIndex = Ord(csCartesian)));

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then
end;

procedure THST3DForm.AddMassFracPar;
begin
  AddSpecFluxMassFracPar;
  AddAquifLeakSoluteParameters;
  AddAquifInflSoluteParameters;
  AddSpecStatSoluteParameters;
  AddInitMassFracPar;
  AddWellTimeSoluteParameters;
  AddRiverMassFracPar;
end;

procedure THST3DForm.rgMassFracClick(Sender: TObject);
begin
  if rgMassFrac.ItemIndex = 0
  then
    begin
      sgWellTime.Cells[Ord(wtMassFrac),0] := kGenParMassFrac;
    end
  else
    begin
      sgWellTime.Cells[Ord(wtMassFrac),0] := kGenParScMassFrac;
    end;


  AddMassFracPar;

  cbInterpMassSpecPressClick(Sender);
  cbInterpScMassFracSpecPresClick(Sender);
  cbSpecMassInterpClick(Sender);
  cbFluxMassFracInterpClick(Sender);
  cbFluxScMassFracInterpClick(Sender);

end;

function THST3DForm.GetZ(Row : Integer) : double;
begin
  if Row < sgGeology.RowCount
  then
    begin
      result := LocalStrToFloat(sgGeology.Cells[Ord(gdTopElev),Row]);
    end
  else
    begin
      result := LocalStrToFloat(sgGeology.Cells[Ord(gdBotElev),Row-1]);
    end;
end;

procedure THST3DForm.FormDestroy(Sender: TObject);
begin
    LayerStructure.Free;

end;

procedure THST3DForm.Load(FormString : string; Sender: TObject);
var
  PrevNumLayers : integer;
  NewNumLayer : integer;
  LayerIndex : integer;
  AGeologicUnit : TGeologicUnit;
  AnHST3DGridLayer : THST3DGridLayer;
  AGridUnitParameters : TGridUnitParameters;
  AGridNLParameters : TGridNLParameters;
  AWellLayer : TWellLayer;
  AWellUnitParameters : TWellUnitParameters;
  LocationToAddLayer, LocationToAddParameter : integer;
begin
    PrevNumLayers := StrToInt(edNumLayers.Text);
//    edMaxTimesEnter(nil);
    StringToForm(FormString, PIE_Data.HST3DForm);
    NewNumLayer := StrToInt(edNumLayers.Text);
//    edMaxTimesExit(nil);

    if PrevNumLayers > NewNumLayer
              then
                begin
                  for LayerIndex := PrevNumLayers downto NewNumLayer + 1 do
                  begin
                    AGeologicUnit :=
                       LayerStructure.ListsOfIndexedLayers.GetNonDeletedIndLayerListByIndex
                       (LayerIndex ) as TGeologicUnit;
                    AGeologicUnit.DeleteSelf;

                    AnHST3DGridLayer :=
                        LayerStructure.UnIndexedLayers.GetLayerByName
                        (kGridLayer) as THST3DGridLayer;
                    AGridUnitParameters :=
                        AnHST3DGridLayer.IndexedParamList1.GetNonDeletedIndParameterListByIndex
                        (LayerIndex ) as TGridUnitParameters;
                    AGridUnitParameters.DeleteSelf;
                    AGridNLParameters :=
                        AnHST3DGridLayer.IndexedParamList2.GetNonDeletedIndParameterListByIndex
                        (LayerIndex ) as TGridNLParameters;
                    AGridNLParameters.DeleteSelf;

                    if cbWells.Checked then
                    begin
                      AWellLayer :=
                          LayerStructure.UnIndexedLayers.GetLayerByName
                          (kWellLayerName) as TWellLayer;
                      AWellUnitParameters :=
                          AWellLayer.IndexedParamList1.GetNonDeletedIndParameterListByIndex
                          (LayerIndex ) as TWellUnitParameters;
                      AWellUnitParameters.DeleteSelf;
                    end;
                  end;
                end
              else
                begin
                  for LayerIndex := PrevNumLayers to NewNumLayer - 1 do
                  begin
                    LocationToAddLayer
                      := LayerStructure.ListsOfIndexedLayers.Count-1;
                    TGeologicUnit.Create(LayerStructure.ListsOfIndexedLayers,
                      LocationToAddLayer);
                    AnHST3DGridLayer :=
                      LayerStructure.UnIndexedLayers.GetLayerByName(kGridLayer)
                      as THST3DGridLayer;
                    if (Sender = btnInsertLayer)
                    then
                      begin
                        LocationToAddParameter :=
                          AnHST3DGridLayer.IndexedParamList1.GetNonDeletedIndParameterListIndexByIndex
                          (sgGeology.Row-1);
                      end
                    else
                      begin
                        LocationToAddParameter
                          := AnHST3DGridLayer.IndexedParamList1.Count;
                      end;
                   TGridUnitParameters.Create(AnHST3DGridLayer.IndexedParamList1,
                     LocationToAddParameter);
                    if (Sender = btnInsertLayer)
                    then
                      begin
                        LocationToAddParameter :=
                          AnHST3DGridLayer.IndexedParamList2.GetNonDeletedIndParameterListIndexByIndex
                          (sgGeology.Row-1);
                      end
                    else
                      begin
                        LocationToAddParameter
                          := AnHST3DGridLayer.IndexedParamList2.Count;
                      end;
                   TGridNLParameters.Create(AnHST3DGridLayer.IndexedParamList2,
                     LocationToAddParameter);

                    if cbWells.Checked and (rgCoord.ItemIndex = Ord(csCartesian)) then
                    begin
                      AWellLayer :=
                        LayerStructure.UnIndexedLayers.GetLayerByName
                        (kWellLayerName) as TWellLayer;
                      if (Sender = btnInsertLayer)
                      then
                        begin
                          LocationToAddParameter :=
                            AWellLayer.IndexedParamList1.GetNonDeletedIndParameterListIndexByIndex
                            (sgGeology.Row-1);
                        end
                      else
                        begin
                          LocationToAddParameter
                            := AWellLayer.IndexedParamList1.Count;
                        end;
                      if AWellLayer.IndexedParamList1.Count
                        < StrToInt(edNumLayers.text) then
                      begin
                        TWellUnitParameters.Create(AWellLayer.IndexedParamList1,
                          LocationToAddParameter);
                      end;
                    end;
                  end;
                end;
    LayerStructure.UpdateIndicies;

    IntializeGrids;

end;

procedure THST3DForm.AddRiverMassFracPar;
begin
   if cbRiver.Checked then
   begin
      LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(TRiverLayer,
        TMassFraction,
        (rgMassFrac.ItemIndex = 0));

      LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2(TRiverLayer,
        TScaledMassFraction,
        (rgMassFrac.ItemIndex = 1));

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then

end;

procedure THST3DForm.comboAquiferInflZoneWChange(Sender: TObject);
begin
   if cbAqInfl.Checked then
   begin
     LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
       (THorAqInflLayer, TWeightFacParam,
        comboAquiferInflZoneW.ItemIndex = 1);

     LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
       (TVerAqInflLayer, TWeightFacParam,
        comboAquiferInflZoneW.ItemIndex = 1);

   end; // if cbSpecFlow.Checked or cbSpecHeat.Checked
        // or cbSpecSolute.Checked then
end;

procedure THST3DForm.edExtensionChange(Sender: TObject);
begin
  if Length(edExtension.Text) > 14 then
  begin
    Beep;
    edExtension.Text := Copy(edExtension.Text, 1, 14);
  end;
end;

procedure THST3DForm.edExtensionExit(Sender: TObject);
begin
  edExtension.Text := Trim(edExtension.Text);
  if (edExtension.Text = '') then
  begin
    Beep;
    ShowMessage('Please enter an extension for output files');
    edExtension.SetFocus;
  end;
end;

procedure THST3DForm.edInputExit(Sender: TObject);
begin
  edInput.Text := Trim(edInput.Text);
  if (edInput.Text = '') then
  begin
    Beep;
    ShowMessage('Please enter a name for the HST3D input file.');
    edInput.SetFocus;
  end;

end;

procedure THST3DForm.btnBrowseHST3DClick(Sender: TObject);
var
  Filter : string;
  path : string;
begin
  Filter := OpenDialog1.Filter;
  OpenDialog1.Filter
    := 'Executable files (*.exe, *.bat)|*.exe;*.bat|All Files (*.*)|*.*';
  OpenDialog1.FileName := '';
  if FileExists(edPath.Text)
  then
    begin
      OpenDialog1.FileName := edPath.Text;
    end
  else
    begin
      if DirectoryExists(edPath.Text)
      then
        begin
          OpenDialog1.InitialDir := edPath.Text
        end
      else
        begin
          path := ExtractFilePath(edPath.Text);
          if DirectoryExists(path) then
          begin
            OpenDialog1.InitialDir := Path;
          end
        end;
    end;
  if OpenDialog1.Execute then
  begin
    edPath.Text := OpenDialog1.FileName;
  end;
  OpenDialog1.Filter := Filter;
end;

procedure THST3DForm.edPathChange(Sender: TObject);
begin
  PIE_Data.RunForm.edRunPath.Text :=  edPath.Text;
end;

procedure THST3DForm.cbSpecPresInterpClick(Sender: TObject);
begin
  gbInterpSpecPres.Enabled := cbSpecPresInterp.Checked;

  cbInterpSpecPres.Enabled := cbSpecPres.Checked;

  cbInterpTempSpecPres.Enabled := cbSpecPres.Checked and cbHeat.Checked;
  cbInterpMassSpecPress.Enabled := cbSpecPres.Checked and cbSolute.Checked;
  cbInterpScMassFracSpecPres.Enabled := cbSpecPres.Checked and cbSolute.Checked;
  if not gbInterpSpecPres.Enabled then
  begin
    cbInterpSpecPres.Checked := False;
    cbInterpTempSpecPres.Checked := False;
    cbInterpMassSpecPress.Checked := False;
    cbInterpScMassFracSpecPres.Checked := False;
  end;

  cbInterpSpecPresClick(Sender);
  cbInterpTempSpecPresClick(Sender);
  cbInterpMassSpecPressClick(Sender);
  cbInterpScMassFracSpecPresClick(Sender);

end;

procedure THST3DForm.cbInterpSpecPresClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (TSpecifiedStateLayer, TEndSpecifiedPresParam,
       cbInterpSpecPres.Checked and
       cbSpecPresInterp.Checked and
       cbSpecPres.Checked);

end;

procedure THST3DForm.cbInterpTempSpecPresClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
   (TSpecifiedStateLayer, TEndTempAtSpecifiedPresParam,
       cbInterpTempSpecPres.Checked and
       cbSpecPresInterp.Checked and
       cbSpecPres.Checked and
       cbHeat.Checked);

end;

procedure THST3DForm.cbInterpMassSpecPressClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TSpecifiedStateLayer, TEndMassFracAtSpecifiedPresParam,
     cbInterpMassSpecPress.Checked and cbSpecPresInterp.Checked and
     cbSpecPres.Checked and cbSolute.Checked and
     (rgMassFrac.ItemIndex = 0));
end;

procedure THST3DForm.cbInterpScMassFracSpecPresClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TSpecifiedStateLayer, TEndScaledMassFracAtSpecifiedPresParam,
     cbInterpScMassFracSpecPres.Checked and cbSpecPresInterp.Checked and
     cbSpecPres.Checked and cbSolute.Checked and
     (rgMassFrac.ItemIndex = 1));
end;

procedure THST3DForm.cbSpecTempInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TSpecifiedStateLayer, TEndSpecifiedTempParam,
     cbSpecTempInterp.Checked and cbSpecTemp.Checked and cbHeat.Checked);

end;

procedure THST3DForm.cbSpecMassInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TSpecifiedStateLayer, TEndSpecifiedMassFracParam,
     cbSpecMassInterp.Checked and cbSpecMass.Checked and
     cbSolute.Checked and (rgMassFrac.ItemIndex = 0));

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TSpecifiedStateLayer, TEndSpecifiedStateScMassFracParam,
     cbSpecMassInterp.Checked and cbSpecMass.Checked and
     cbSolute.Checked and (rgMassFrac.ItemIndex = 1));

end;

procedure THST3DForm.cbInitPresInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (TInitialPresLayer, TEndInitialPresParam,
     cbInitPresInterp.Checked);

end;

procedure THST3DForm.bitbtnHelpClick(Sender: TObject);
var
  HtmlPage : string;
begin
      If (PageControl1.ActivePage = tabAbout) then
         begin
           HtmlPage := 'about.htm';
         end
      else if (PageControl1.ActivePage = tabProject) then
         begin
           HtmlPage := 'project.htm';
         end
      else if (PageControl1.ActivePage = tabAqInfl) then
         begin
           HtmlPage := 'aquifinfltab.htm';
         end
      else if (PageControl1.ActivePage = tabBound) then
         begin
           HtmlPage := 'processes.htm';
         end
      else if (PageControl1.ActivePage = tabFluidProp) then
         begin
           HtmlPage := 'fluidprop.htm';
         end
      else if (PageControl1.ActivePage = tabGeology) then
         begin
           HtmlPage := 'elements.htm';
         end
      else if (PageControl1.ActivePage = tabHeat) then
         begin
           HtmlPage := 'heatcondtab.htm';
         end
      else if (PageControl1.ActivePage = tabInitCond) then
         begin
           HtmlPage := 'initcond.htm';
         end
      else if (PageControl1.ActivePage = tabInterpolation) then
         begin
           HtmlPage := 'interpolationtab.htm';
         end
      else if (PageControl1.ActivePage = tabOutput) then
         begin
           HtmlPage := 'outputtab.htm';
         end
      else if (PageControl1.ActivePage = tabProblem) then
         begin
           HtmlPage := 'problem.htm';
         end
      else if (PageControl1.ActivePage = tabRefTherm) then
         begin
           HtmlPage := 'refcond.htm';
         end
      else if (PageControl1.ActivePage = tabSolver) then
         begin
           HtmlPage := 'solver.htm';
         end
      else if (PageControl1.ActivePage = tabTime) then
         begin
           HtmlPage := 'timetab.htm';
         end
      else if (PageControl1.ActivePage = tabWellRiser) then
         begin
           HtmlPage := 'wellriser.htm';
         end
      else if (PageControl1.ActivePage = tabBCFLOW) then
         begin
           HtmlPage := 'bcflowtab.htm';
         end
      else
        begin
           HtmlPage := 'project.htm';
           ShowMessage('Error displaying help');
        end;

      ShowSpecificHTMLHelp(HtmlPage);
end;

procedure THST3DForm.adeRefTempExit(Sender: TObject);
begin
  With PIE_Data do
  begin
    if HST3DForm.Visible and not (HST3DForm.adeRefTemp.Text =
      HST3DForm.sgHeatCondBoundInitialCond.Cells[2,1]) then
    begin
      if HST3DForm.cbHeatCond.Checked
      then
        begin
          if MessageDlg('Do you wish to change the temperature associated with '
              + 'the first heat-conduction boundary '
              + 'node for initial conditions '
              + 'to match reference temperature for density?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
             HST3DForm.sgHeatCondBoundInitialCond.Cells[2,1] :=
                HST3DForm.adeRefTemp.Text
          end;
        end
      else
        begin
             HST3DForm.sgHeatCondBoundInitialCond.Cells[2,1] :=
                HST3DForm.adeRefTemp.Text
        end;
    end;
  end;

end;

procedure THST3DForm.sgHeatCondBoundInitialCondExit(Sender: TObject);
begin
  With PIE_Data do
  begin
    if HST3DForm.Visible and not (HST3DForm.adeRefTemp.Text =
      HST3DForm.sgHeatCondBoundInitialCond.Cells[2,1]) then
    begin
      if HST3DForm.cbHeatCond.Checked
      then
        begin
          if MessageDlg('Do you wish to change the reference '
              + 'temperature for density (T0) '
              + 'to match the temperature associated with '
              + 'the first heat-conduction boundary node '
              + 'for initial conditions?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
             HST3DForm.adeRefTemp.Text  :=
                HST3DForm.sgHeatCondBoundInitialCond.Cells[2,1];
          end;
        end
      else
        begin
             HST3DForm.adeRefTemp.Text  :=
                HST3DForm.sgHeatCondBoundInitialCond.Cells[2,1];
        end;
    end;
  end;

end;

procedure THST3DForm.btnBrowseBCFLOWClick(Sender: TObject);
var
  Filter : string;
begin
  Filter := OpenDialog1.Filter;
  OpenDialog1.Filter
    := 'Executable files (*.exe, *.bat)|*.exe;*.bat|All Files (*.*)|*.*';
  OpenDialog1.FileName := edBCFLOWPath.Text;
  if OpenDialog1.Execute then
  begin
    edBCFLOWPath.Text := OpenDialog1.FileName;
  end;
  OpenDialog1.Filter := Filter;

end;

procedure THST3DForm.cbUseBCFLOWClick(Sender: TObject);
begin
  cbBCFLOWUseSpecState.Enabled :=  (cbSpecPres.Checked or cbSpecTemp.Checked
                               or cbSpecMass.Checked) and cbUseBCFLOW.Checked;
  if not cbBCFLOWUseSpecState.Enabled then
  begin
    cbBCFLOWUseSpecState.Checked := False;
  end;

  cbBCFLOWUseSpecFlux.Enabled :=  (cbSpecFlow.Checked or cbSpecHeat.Checked
                               or cbSpecSolute.Checked) and cbUseBCFLOW.Checked;
  if not cbBCFLOWUseSpecFlux.Enabled then
  begin
    cbBCFLOWUseSpecFlux.Checked := False;
  end;

  cbBCFLOWUseLeakage.Enabled :=  (cbLeakage.Checked or cbRiver.Checked )
                                 and cbUseBCFLOW.Checked;
  if not cbBCFLOWUseLeakage.Enabled then
  begin
    cbBCFLOWUseLeakage.Checked := False;
  end;

  cbBCFLOWUseAqInfl.Enabled :=  cbAqInfl.Checked and cbUseBCFLOW.Checked;
  if not cbBCFLOWUseAqInfl.Enabled then
  begin
    cbBCFLOWUseAqInfl.Checked := False;
  end;

  cbBCFLOWUseHeatCond.Enabled :=  cbHeatCond.Checked and cbUseBCFLOW.Checked;
  if not cbBCFLOWUseHeatCond.Enabled then
  begin
    cbBCFLOWUseHeatCond.Checked := False;
  end;

  cbBCFLOWUseET.Enabled :=  cbET.Checked and cbUseBCFLOW.Checked;
  if not cbBCFLOWUseET.Enabled then
  begin
    cbBCFLOWUseET.Checked := False;
  end;

  adeBCFLOWTitle1.Enabled := cbUseBCFLOW.Checked;
  adeBCFLOWTitle2.Enabled := cbUseBCFLOW.Checked;
  lblBCFLOWTitle1.Enabled := cbUseBCFLOW.Checked;
  lblBCFLOWTitle2.Enabled := cbUseBCFLOW.Checked;

  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(TBCFLOWLayer,
      cbUseBCFLOW.Checked);

end;

procedure THST3DForm.edBCFLOWPathChange(Sender: TObject);
begin
  PIE_Data.RunForm.edBCFLOWPath.Text :=  edBCFLOWPath.Text;

end;

procedure THST3DForm.cbBCFLOWParameterClick(Sender: TObject);
var
  ABCFLOWLayer : TBCFLOWLayer;
begin
  ABCFLOWLayer :=
    LayerStructure.UnIndexedLayers.GetLayerByName(KBCFLOWLayer)
    as TBCFLOWLayer;
  if not (ABCFLOWLayer = nil) then
  begin
    if (Sender = cbBCFLOWUseSpecState) then
      begin
        ABCFLOWLayer.AddOrRemoveUnIndexedParameter(TBCFLOWSpecStateParam,
          cbBCFLOWUseSpecState.Checked);
      end
    else if (Sender = cbBCFLOWUseSpecFlux) then
      begin
        ABCFLOWLayer.AddOrRemoveUnIndexedParameter(TBCFLOWSpecFluxParam,
          cbBCFLOWUseSpecFlux.Checked);
      end
    else if (Sender = cbBCFLOWUseLeakage) then
      begin
        ABCFLOWLayer.AddOrRemoveUnIndexedParameter(TBCFLOWLeakageParam,
          cbBCFLOWUseLeakage.Checked);
      end
    else if (Sender = cbBCFLOWUseAqInfl) then
      begin
        ABCFLOWLayer.AddOrRemoveUnIndexedParameter(TBCFLOWAqInflParam,
          cbBCFLOWUseAqInfl.Checked);
      end
    else if (Sender = cbBCFLOWUseHeatCond) then
      begin
        ABCFLOWLayer.AddOrRemoveUnIndexedParameter(TBCFLOWHeatCondParam,
          cbBCFLOWUseHeatCond.Checked);
      end
    else if (Sender = cbBCFLOWUseET) then
      begin
        ABCFLOWLayer.AddOrRemoveUnIndexedParameter
          (TBCFLOWEvapotranspirationParam,
           cbBCFLOWUseET.Checked);
      end
    else
      begin
        Assert(False);
      end;
  end;

end;

procedure THST3DForm.rgAngleChoiceClick(Sender: TObject);
begin
  lblThetxz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 0);

  lblThetyz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 1);

  lblThetzz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 2);

  adeThetxz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 0);

  adeThetyz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 1);

  adeThetzz.Enabled := cbTiltCoord.Checked and
    (rgCoord.ItemIndex = Ord(csCartesian)) and
    not (rgAngleChoice.ItemIndex = 2);
end;

procedure THST3DForm.adeThetExit(Sender: TObject);
var
  Ax, Az, Bx, By, Bz, Cz : double;
  AngleA, AngleB, AngleC, AngleCdegrees : double ;
  temp : double;
begin
  AngleA := 0;
  AngleB := 0;
  case rgAngleChoice.ItemIndex of
    0:
      begin
        AngleA := LocalStrToFloat(adeThetyz.Text)* Pi / 180;
        AngleB := LocalStrToFloat(adeThetzz.Text)* Pi / 180;
      end;
    1:
      begin
        AngleA := LocalStrToFloat(adeThetxz.Text)* Pi / 180;
        AngleB := LocalStrToFloat(adeThetzz.Text)* Pi / 180;
      end;
    2:
      begin
        AngleA := LocalStrToFloat(adeThetxz.Text)* Pi / 180;
        AngleB := LocalStrToFloat(adeThetyz.Text)* Pi / 180;
      end;
  end;
  if AngleA + AngleB < Pi/2
  then
    begin
      case rgAngleChoice.ItemIndex of
        0:
          begin
            if Sender = adeThetyz
            then
              begin
                AngleB := Pi/2 - AngleA;
                adeThetzz.Text := FloatToStr(AngleB * 180 / Pi );
              end
            else
              begin
                AngleA := Pi/2 - AngleB;
                adeThetyz.Text := FloatToStr(AngleA * 180 / Pi );
              end;
          end;
        1:
          begin
            if Sender = adeThetxz
            then
              begin
                AngleB := Pi/2 - AngleA;
                adeThetzz.Text := FloatToStr(AngleB * 180 / Pi );
              end
            else
              begin
                AngleA := Pi/2 - AngleB;
                adeThetxz.Text := FloatToStr(AngleA * 180 / Pi );
              end;
          end;
        2:
          begin
            if Sender = adeThetxz
            then
              begin
                AngleB := Pi/2 - AngleA;
                adeThetyz.Text := FloatToStr(AngleB * 180 / Pi );
              end
            else
              begin
                AngleA := Pi/2 - AngleB;
                adeThetxz.Text := FloatToStr(AngleA * 180 / Pi );
              end;
          end;
      end;
    end;

    begin
      if (AngleA = 0)
      then
        begin
          AngleC := Pi/2;
        end
      else if (AngleB = 0)
      then
        begin
          AngleC := Pi/2;
        end
      else if (AngleA = Pi/2)
      then
        begin
          AngleC := Pi - AngleB;
        end
      else if (AngleB = Pi/2)
      then
        begin
          AngleC := Pi - AngleA;
        end
      else
        begin
          Ax := Sin(AngleA);
          Az := Cos(AngleA);
          Bx := -Cos(AngleB)/tan(AngleA);
          Bz := Cos(AngleB);
          if Bz = 0
          then
            begin
              Cz := 0
            end
          else
            begin
              temp := 1 - Sqr(Bx) - Sqr(Bz);
              if temp < 0
              then
                begin
                  By := 0;
                end
              else
                begin
                  By := Sqrt(temp);
                end;
              if (By = 0) or (Ax = 0) or (Bx = 0)
              then
                begin
                  Cz := 0;
                end
              else
                begin
                  Cz := Sqrt(1/( Sqr((Bx/By)*(Az/Ax - Bz/Bx))
                     + (1 + Sqr(Az/Ax))));
                end;
            end;
          AngleC := ArcCos(Cz);
        end;
    end;
  AngleCdegrees := AngleC * 180 / Pi ;
  If AngleCdegrees < 1e-8 then
  begin
    AngleCdegrees := 0
  end;
  if 90 - AngleCdegrees < 1e-8 then
  begin
    AngleCdegrees := 90
  end;
  case rgAngleChoice.ItemIndex of
    0:
      begin
        adeThetxz.Text := FloatToStr(AngleCdegrees);
      end;
    1:
      begin
        adeThetyz.Text := FloatToStr(AngleCdegrees);
      end;
    2:
      begin
        adeThetzz.Text := FloatToStr(AngleCdegrees);
      end;
  end;

end;

procedure THST3DForm.IntializeGrids;
var
  index : integer;
begin
  sgSolver.Cells[0,Ord(StartTime)]         := 'Start Time (TIMCHG) (t)';
  sgSolver.Cells[0,Ord(Automatic)]         := 'Automatic time step (AUTOTS)';
  sgSolver.Cells[0,Ord(TimeStepLength)]    := 'Time step length (DELTIM) (t)';
  sgSolver.Cells[0,Ord(MaxChangePres)]     := 'Max change in pres. (DPTAS) (F/L^2)';
  sgSolver.Cells[0,Ord(MaxChangeTemp)]     := 'Max change in temp. (DTTAS) (T)';
  sgSolver.Cells[0,Ord(MaxChangeMassFrac)] := 'Max change in mass frac. (DCTAS)';
  sgSolver.Cells[0,Ord(MinTimeStep)]       := 'Min time step (DTIMMN) (t)';
  sgSolver.Cells[0,Ord(MaxTimeStep)]       := 'Max time step (DTIMMX) (t)';
  sgSolver.Cells[0,Ord(Duration)]          := 'Duration (t)';
  sgSolver.Cells[0,Ord(EndTime)]           := 'End of Period (TIMCHG) (t)';

  sgSolver.Cells[0,Ord(PrISolMeth)]        := 'Solution Method Printout Interval (PRISLM)';
  sgSolver.Cells[0,Ord(PrICondDisp)]       := 'Conductance/Dispersion Printout Interval (PRIKD)';
  sgSolver.Cells[0,Ord(PrIPresTempMass)]   := 'Pres/Temp/Mass Frac Printout Interval (PRIPTC)';
  sgSolver.Cells[0,Ord(PrIFlDens)]         := 'Density/Viscosity Printout Interval (PRIDV)';
  sgSolver.Cells[0,Ord(PrIVel)]            := 'Velocity Printout Interval (PRIVEL)';
  sgSolver.Cells[0,Ord(PrIFlowBal)]        := 'Flow-,Heat, and Solute-Balance Printout Interval (PRIGFB)';
  sgSolver.Cells[0,Ord(PrISpecValFlow)]    := 'Boundary Flow Printout Interval (PRIBCF)';
  sgSolver.Cells[0,Ord(PrIWell)]           := 'Well Printout Interval (PRIWEL)';
  sgSolver.Cells[0,Ord(IPRPTCn1)]          := 'Print Pressure (IPRPTC n1)';
  sgSolver.Cells[0,Ord(IPRPTCn2)]          := 'Print Temperature (IPRPTC n2)';
  sgSolver.Cells[0,Ord(IPRPTCn3)]          := 'Print Mass Fraction (IPRPTC n3)';
  sgSolver.Cells[0,Ord(CheckPointDump)]    := 'Print Checkpoint Dumps (CHKPTD)';
  sgSolver.Cells[0,Ord(PrICheckPointDump)] := 'Checkpoint Dump Printout Interval (PRICPD)';
  sgSolver.Cells[0,Ord(SavLastDump)]       := 'Save Only Last Checkpoint Dump (SAVLDO)';
  sgSolver.Cells[0,Ord(ContourMap)]        := 'Print Contour Map Data (CNTMAP)';
  sgSolver.Cells[0,Ord(VelocityVectorMap)] := 'Print Velocity Vector Map Data (VECMAP)';
  sgSolver.Cells[0,Ord(PriMaps)]           := 'Map Printout Interval (PRIMAP)';

  sgGeology.Cells[Ord(gdUnitNum),0] := 'Element Layer Number';
  sgGeology.Cells[Ord(gdName),0] := 'Element Layer Name';
  sgGeology.Cells[Ord(gdTopElev),0] := 'Top Elevation';
  sgGeology.Cells[Ord(gdBotElev),0] := 'Bottom Elevation';
  for Index := 1 to sgGeology.RowCount -1 do
  begin
    sgGeology.Cells[Ord(gdUnitNum),Index] := IntToStr(Index);
  end;

  LastGeologyText := sgGeology.Cells[Ord(gdName),1];
  sgGeology.Row := 1;


end;

procedure THST3DForm.FormShow(Sender: TObject);
begin
  Height := FormHeight;
  Top   :=  FormTop  ;
  sgSolver.TopRow := 1;
  if tabProblem.TabVisible
  then
    begin
      PageControl1.ActivePage := tabProblem;
    end
  else
    begin
      PageControl1.ActivePage := tabProject;
    end;
end;

procedure THST3DForm.cbWatTableInitialInterpClick(Sender: TObject);
var
  AnInitWatTabLayer : TInitWatTabLayer;
begin
  AnInitWatTabLayer :=
    LayerStructure.UnIndexedLayers.GetLayerByName(kInitWat)
    as TInitWatTabLayer;

  if not (AnInitWatTabLayer = nil) then
  begin
    AnInitWatTabLayer.AddOrRemoveUnIndexedParameter(TEndInitWatTabParam,
      cbWatTableInitialInterp.Checked);
  end;
end;

procedure THST3DForm.cbSpecFlowInterpClick(Sender: TObject);
begin
  gbInterpSpecFlux.Enabled := cbSpecFlowInterp.Checked;
  if not gbInterpSpecFlux.Enabled then
  begin
    cbFluidFluxInterp.Checked := False;
    cbFluxDensityInterp.Checked := False;
    cbFluxTempInterp.Checked := False;
    cbFluxMassFracInterp.Checked := False;
    cbFluxScMassFracInterp.Checked := False;
  end;

  cbFluxTempInterp.Enabled := cbHeat.Checked;
  if not cbFluxTempInterp.Enabled then
  begin
    cbFluxTempInterp.Checked := False;
  end;

  cbFluxMassFracInterp.Enabled := cbSolute.Checked;
  if not cbFluxMassFracInterp.Enabled then
  begin
    cbFluxMassFracInterp.Checked := False;
  end;

  cbFluxScMassFracInterp.Enabled := cbSolute.Checked;
  if not cbFluxScMassFracInterp.Enabled then
  begin
    cbFluxScMassFracInterp.Checked := False;
  end;

end;

procedure THST3DForm.cbFluidFluxInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TVerSpecFluxLayer,  TEndFluidFluxParam,
   cbFluidFluxInterp.Checked);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (THorSpecFluxLayer,  TEndUpFluidFluxParam,
   cbFluidFluxInterp.Checked);

end;

procedure THST3DForm.cbFluxDensityInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TVerSpecFluxLayer,  TEndDensityLayerParam,
   cbFluxDensityInterp.Checked);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (THorSpecFluxLayer,  TEndDensityLayerParam,
   cbFluxDensityInterp.Checked);

end;

procedure THST3DForm.cbFluxTempInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TVerSpecFluxLayer,  TEndTemperature,
   cbFluxTempInterp.Checked);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (THorSpecFluxLayer,  TEndTemperature,
   cbFluxTempInterp.Checked);

end;

procedure THST3DForm.cbFluxMassFracInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TVerSpecFluxLayer,  TEndMassFraction,
   (cbFluxMassFracInterp.Checked and (rgMassFrac.ItemIndex = 0)));

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (THorSpecFluxLayer,  TEndMassFraction,
   (cbFluxMassFracInterp.Checked and (rgMassFrac.ItemIndex = 0)));

end;

procedure THST3DForm.cbFluxScMassFracInterpClick(Sender: TObject);
begin
  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (TVerSpecFluxLayer,  TEndScaledMassFraction,
   (cbFluxScMassFracInterp.Checked and (rgMassFrac.ItemIndex = 1)));

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
  (THorSpecFluxLayer,  TEndScaledMassFraction,
   (cbFluxScMassFracInterp.Checked and (rgMassFrac.ItemIndex = 1)));

end;

procedure THST3DForm.cbPauseDosClick(Sender: TObject);
begin
  PIE_Data.RunForm.cbPauseDos.Checked := cbPauseDos.Checked;

end;

procedure THST3DForm.sgSolverMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  ARow, ACol : integer;
  AHint : string;
begin
  sgSolver.MouseToCell(X, Y, ACol, ARow);
  Case ARow of
     Ord(StartTime) :
       begin
         AHint := '3.8.4, TIMCHG';
       end;
     Ord(Duration) :
       begin
         AHint := ' controls 3.8.4, TIMCHG';
       end;
     Ord(EndTime) :
       begin
         AHint := '3.8.4, TIMCHG';
       end;
     Ord(Automatic) :
       begin
         AHint := '3.8.2, AUTOTS';
       end;
     Ord(TimeStepLength) :
       begin
         AHint := '3.8.3A, DELTIM';
       end;
     Ord(MaxChangePres) :
       begin
         AHint := '3.8.3B, DPTAS';
       end;
     Ord(MaxChangeTemp) :
       begin
         AHint := '3.8.3B, DTTAS';
       end;
     Ord(MaxChangeMassFrac) :
       begin
         AHint := '3.8.3B, DCTAS';
       end;
     Ord(MinTimeStep) :
       begin
         AHint := '3.8.3B, DTIMMN';
       end;
     Ord(MaxTimeStep) :
       begin
         AHint := '3.8.3B, DTIMMX';
       end;
     Ord(PrISolMeth) :
       begin
         AHint := '3.9.1, PRISLM; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrICondDisp) :
       begin
         AHint := '3.9.1, PRIKD; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrIPresTempMass) :
       begin
         AHint := '3.9.1, PRIPTC; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrIFlDens) :
       begin
         AHint := '3.9.1, PRIDV; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrIVel) :
       begin
         AHint := '3.9.1, PRIVEL; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrIFlowBal) :
       begin
         AHint := '3.9.1, PRIGFB; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrISpecValFlow) :
       begin
         AHint := '3.9.1, PRIBCF; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(PrIWell) :
       begin
         AHint := '3.9.1, PRIWEL; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(IPRPTCn1) :
       begin
         AHint := '3.9.2, IPRPTC, first digit';
       end;
     Ord(IPRPTCn2) :
       begin
         AHint := '3.9.2, IPRPTC, second digit';
       end;
     Ord(IPRPTCn3) :
       begin
         AHint := '3.9.2, IPRPTC, third digit';
       end;
     Ord(CheckPointDump) :
       begin
         AHint := '3.9.3, CHKPTD';
       end;
     Ord(PrICheckPointDump) :
       begin
         AHint := '3.9.3, PRICPD; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     Ord(SavLastDump) :
       begin
         AHint := '3.9.3, SAVLDO';
       end;
     Ord(ContourMap) :
       begin
         AHint := '3.10.1, CNTMAP';
       end;
     Ord(VelocityVectorMap) :
       begin
         AHint := '3.10.1, VECMAP';
       end;
     Ord(PriMaps) :
       begin
         AHint := '3.10.1, PRIMAP; 0: no printout; +n: printout every n''th time step; -n: printout every n time units';
       end;
     else
       begin
         AHint := '';
       end;
  end;

  StatusBar1.SimpleText := AHint;
end;

procedure THST3DForm.edMaxTimesEnter(Sender: TObject);
begin
          strLastTime := edMaxTimes.Text;
end;

procedure THST3DForm.edMaxTimesExit(Sender: TObject);
var
  TimePeriods, PreviousTimePeriods, TimeIndex :integer;
  RowIndex : integer;
  ALayer : T_ANE_Layer;
  LayerIndex : integer;
  AParameterList : T_ANE_ParameterList;
  ParameterListIndex : integer;
  AMapLayer : T_ANE_MapsLayer;
  LayerListIndex : integer;
  ALayerList : T_ANE_LayerList ;
begin
  try
    begin
      TimePeriods := StrToInt(edMaxTimes.Text);
      // Error checking, there must be at least one time period.
      if TimePeriods <1
      then
        begin
          // the the user attempts to reduce the number of time periods below 1,
          // restore the previous value.
          Beep;
          edMaxTimes.Text := strLastTime;
        end
      else // if TimePeriods <1
        begin
          // change the number of tabs in the solver grid to match the number of time periods
          sgSolver.ColCount := StrToInt(edMaxTimes.Text) + 1;
          // determine how many time periods there were before the change
          PreviousTimePeriods := StrToInt(strLastTime);
          // You can't delete a time period if there is only 1 of them.
          btnDelTime.Enabled := not (strLastTime = '1');
          If TimePeriods > PreviousTimePeriods then
          begin
            // if there are more time periods than previously, copy data from the
            // last time period to fill up the solver grid.
            for TimeIndex := PreviousTimePeriods to TimePeriods -1 do
            begin
              with sgSolver do
              begin
                Cells[TimeIndex +1, Ord(StartTime)] :=
                 { FloatToStr(LocalStrToFloat(Cells[TimeIndex, 0]) +
                             LocalStrToFloat(}Cells[TimeIndex, Ord(EndTime)]{))} ;
                Cells[TimeIndex +1, Ord(Duration)] := '0';
                Cells[TimeIndex +1, Ord(EndTime)] :=  FloatToStr(LocalStrToFloat(Cells[TimeIndex + 1, 0]) +
                             LocalStrToFloat(Cells[TimeIndex+1, Ord(Duration)])) ;
                for RowIndex := Ord(Automatic) to RowCount -1 do
                begin
                  Cells[TimeIndex +1, RowIndex] := Cells[TimeIndex, RowIndex];
                end;
              end;
            end;
          end;
          sgSolver.Invalidate;
          If TimePeriods > PreviousTimePeriods
          then
            begin
              for LayerIndex := 0 to LayerStructure.UnIndexedLayers.Count -1 do
              begin
                AMapLayer := LayerStructure.UnIndexedLayers.Items[LayerIndex];
                for TimeIndex := PreviousTimePeriods to TimePeriods -1 do
                  begin
                    AMapLayer.CreateParamterList2;
                  end;
//                if (AMapLayer is T_ANE_Layer) then
//                begin
{                  ALayer := LayerStructure.UnIndexedLayers.Items[LayerIndex];
                  for TimeIndex := PreviousTimePeriods downto TimePeriods +1 do
                  begin
                     for ParameterListIndex :=
                        ALayer.IndexedParamList2.Count -1 downto 0 do
                     begin
                       AParameterList := ALayer.IndexedParamList2.Items[ParameterListIndex];
                       if not (AParameterList.Status = sDeleted) then
                       begin
                         AParameterList.Delete;
                         break;
                       end;  // if not (AParameterList.Status = sDeleted) then
                     end; //for ParameterListIndex := ALayer.IndexedParamList2.Count -1 downto 0 do
                  end; //for TimeIndex := PreviousTimePeriods to TimePeriods -1 do }
//                end;  // if (AMapLayer is T_ANE_Layer) then
              end;  // for LayerIndex := 0 to LayerStructure.UnIndexedLayers.Count -1 do
              For LayerListIndex := 0 to LayerStructure.ListsOfIndexedLayers.Count - 1 do
              begin
                ALayerList := LayerStructure.ListsOfIndexedLayers.Items[LayerListIndex];
                for LayerIndex := 0 to ALayerList.Count -1 do
                begin
                  AMapLayer := ALayerList.Items[LayerIndex];
                  for TimeIndex := PreviousTimePeriods to TimePeriods -1 do
                    begin
                      AMapLayer.CreateParamterList2;
                    end;
//                  if (AMapLayer is T_ANE_Layer) then
//                  begin
{                    ALayer := ALayerList.Items[LayerIndex];

                    for TimeIndex := PreviousTimePeriods to TimePeriods -1 do
                    begin
                       for ParameterListIndex :=
                          ALayer.IndexedParamList2.Count -1 downto 0 do
                       begin
                         AParameterList := ALayer.IndexedParamList2.Items[ParameterListIndex];
                         if not (AParameterList.Status = sDeleted) then
                         begin
                           AParameterList.Delete;
                           break;
                         end;  // if not (AParameterList.Status = sDeleted) then
                       end; //for ParameterListIndex := ALayer.IndexedParamList2.Count -1 downto 0 do
                    end; //for TimeIndex := PreviousTimePeriods to TimePeriods -1 do }
//                  end;  // if (AMapLayer is T_ANE_Layer) then
                end;  // for LayerIndex := 0 to LayerStructure.UnIndexedLayers.Count -1 do
              end; // For LayerListIndex := 0 to LayerStructure.ListsOfIndexedLayers.Count - 1 do



            end
          else // If TimePeriods > PreviousTimePeriods
            begin
              for LayerIndex := 0 to LayerStructure.UnIndexedLayers.Count -1 do
              begin
                AMapLayer := LayerStructure.UnIndexedLayers.Items[LayerIndex];
                if (AMapLayer is T_ANE_Layer) then
                begin
                  ALayer := LayerStructure.UnIndexedLayers.Items[LayerIndex] as T_ANE_Layer;
                  for TimeIndex := PreviousTimePeriods downto TimePeriods +1 do
                  begin
                     for ParameterListIndex :=
                        ALayer.IndexedParamList2.Count -1 downto 0 do
                     begin
                       AParameterList := ALayer.IndexedParamList2.Items[ParameterListIndex];
                       if not (AParameterList.Status = sDeleted) then
                       begin
                         AParameterList.DeleteSelf;
                         break;
                       end;  // if not (AParameterList.Status = sDeleted) then
                     end; {for ParameterListIndex :=
                        ALayer.IndexedParamList2.Count -1 downto 0 do}
                  end; //for TimeIndex := PreviousTimePeriods to TimePeriods -1 do
                end;  // if (AMapLayer is T_ANE_Layer) then
              end;  // for LayerIndex := 0 to LayerStructure.UnIndexedLayers.Count -1 do
              For LayerListIndex := 0 to LayerStructure.ListsOfIndexedLayers.Count - 1 do
              begin
                ALayerList := LayerStructure.ListsOfIndexedLayers.Items[LayerListIndex];
                for LayerIndex := 0 to ALayerList.Count -1 do
                begin
                  AMapLayer := ALayerList.Items[LayerIndex];
                  if (AMapLayer is T_ANE_Layer) then
                  begin
                    ALayer := ALayerList.Items[LayerIndex] as T_ANE_Layer;

                    for TimeIndex := PreviousTimePeriods downto TimePeriods +1 do
                    begin
                       for ParameterListIndex :=
                          ALayer.IndexedParamList2.Count -1 downto 0 do
                       begin
                         AParameterList := ALayer.IndexedParamList2.Items[ParameterListIndex];
                         if not (AParameterList.Status = sDeleted) then
                         begin
                           AParameterList.DeleteSelf;
                           break;
                         end;  // if not (AParameterList.Status = sDeleted) then
                       end; {for ParameterListIndex :=
                          ALayer.IndexedParamList2.Count -1 downto 0 do}
                    end; //for TimeIndex := PreviousTimePeriods to TimePeriods -1 do
                  end;  // if (AMapLayer is T_ANE_Layer) then
                end;  // for LayerIndex := 0 to LayerStructure.UnIndexedLayers.Count -1 do
              end; // For LayerListIndex := 0 to LayerStructure.ListsOfIndexedLayers.Count - 1 do
            end;  // If TimePeriods > PreviousTimePeriods else
        end; // if TimePeriods <1 else
    end; // try
  except
    // If the user enters a value that can't be converted to an integer,
    // restore the previous value.
    On EConvertError do
      begin
          Beep;
          edMaxTimes.Text := strLastTime;
      end;
  end;

end;
procedure THST3DForm.Help1Click(Sender: TObject);
var
  HtmlPage : string;
begin
      if PopupMenu1.PopupComponent = BitBtnOK then
        begin
          HtmlPage := 'project.htm#ok';
        end
      else if PopupMenu1.PopupComponent = BitBtnCancel then
        begin
          HtmlPage := 'project.htm#cancel';
        end
      else if PopupMenu1.PopupComponent = bitbtnHelp then
        begin
          HtmlPage := 'project.htm#help';
        end
      else if (PopupMenu1.PopupComponent = btnSaveDefault) or
        (PopupMenu1.PopupComponent = btnLoad) then
        begin
          HtmlPage := 'default.htm';
        end
      else if (PageControl1.ActivePage = tabAbout) then
         begin
           HtmlPage := 'about.htm';
{           if PopupMenu1.PopupComponent = btnRegister then
             begin
               HtmlPage :=  HtmlPage + '#register';
             end
           else} if PopupMenu1.PopupComponent = ASLinkWinston then
             begin
               HtmlPage :=  HtmlPage + '#winston';
             end
           else if PopupMenu1.PopupComponent = ASLinkKipp then
             begin
               HtmlPage :=  HtmlPage + '#kipp';
             end;
         end
      else if (PageControl1.ActivePage = tabProject) then
         begin
           HtmlPage := 'project.htm';
           if (PopupMenu1.PopupComponent = edTitleLine1) or
             (PopupMenu1.PopupComponent = edTitleLine2) then
             begin
               HtmlPage :=  HtmlPage + '#title';
             end
           else if PopupMenu1.PopupComponent = rgUnits then
             begin
               HtmlPage :=  HtmlPage + '#eeunit';
             end
           else if PopupMenu1.PopupComponent = rgTimeUnits then
             begin
               HtmlPage :=  HtmlPage + '#tmunit';
             end
           else if PopupMenu1.PopupComponent = cbRestart then
             begin
               HtmlPage :=  HtmlPage + '#restrt';
             end
           else if PopupMenu1.PopupComponent = adeTime then
             begin
               HtmlPage :=  HtmlPage + '#timrst';
             end
           else if PopupMenu1.PopupComponent = rgCoord then
             begin
               HtmlPage :=  HtmlPage + '#cylind';
             end
           else if PopupMenu1.PopupComponent = rgMassFrac then
             begin
               HtmlPage :=  HtmlPage + '#scalmf';
             end
           else if PopupMenu1.PopupComponent = cbTiltCoord then
             begin
               HtmlPage :=  HtmlPage + '#tilt';
             end
           else if PopupMenu1.PopupComponent = adeThetxz then
             begin
               HtmlPage :=  HtmlPage + '#thetxz';
             end
           else if PopupMenu1.PopupComponent = adeThetyz then
             begin
               HtmlPage :=  HtmlPage + '#thetyz';
             end
           else if PopupMenu1.PopupComponent = adeThetzz then
             begin
               HtmlPage :=  HtmlPage + '#thetzz';
             end
           else if PopupMenu1.PopupComponent = rgAngleChoice then
             begin
               HtmlPage :=  HtmlPage + '#dependent';
             end
         end
      else if (PageControl1.ActivePage = tabAqInfl) then
         begin
           HtmlPage := 'aquifinfltab.htm';
           if PopupMenu1.PopupComponent = rgAqInflChoice then
             begin
               HtmlPage :=  HtmlPage + '#iaif';
             end
           else if PopupMenu1.PopupComponent = adeBulkCompOut then
             begin
               HtmlPage :=  HtmlPage + '#aboar';
             end
           else if PopupMenu1.PopupComponent = adePorOut then
             begin
               HtmlPage :=  HtmlPage + '#poroar';
             end
           else if PopupMenu1.PopupComponent = adeVolOut then
             begin
               HtmlPage :=  HtmlPage + '#voar';
             end
           else if PopupMenu1.PopupComponent = adePermOut then
             begin
               HtmlPage :=  HtmlPage + '#koar';
             end
           else if PopupMenu1.PopupComponent = adeViscOut then
             begin
               HtmlPage :=  HtmlPage + '#visoar';
             end
           else if PopupMenu1.PopupComponent = adeThickOut then
             begin
               HtmlPage :=  HtmlPage + '#boar';
             end
           else if PopupMenu1.PopupComponent = adeRadius then
             begin
               HtmlPage :=  HtmlPage + '#rioar';
             end
           else if PopupMenu1.PopupComponent = adeAngInflOut then
             begin
               HtmlPage :=  HtmlPage + '#angoar';
             end
           else if PopupMenu1.PopupComponent = comboAquiferInflZoneW then
             begin
               HtmlPage :=  HtmlPage + '#uvaifc';
             end
         end
      else if (PageControl1.ActivePage = tabBound) then
         begin
           HtmlPage := 'processes.htm';
           if PopupMenu1.PopupComponent = cbHeat then
             begin
               HtmlPage :=  HtmlPage + '#heat';
             end
           else if PopupMenu1.PopupComponent = cbSolute then
             begin
               HtmlPage :=  HtmlPage + '#solute';
             end
           else if PopupMenu1.PopupComponent = cbFreeSurf then
             begin
               HtmlPage :=  HtmlPage + '#free';
             end
           else if PopupMenu1.PopupComponent = cbSpecPres then
             begin
               HtmlPage :=  HtmlPage + '#specpres';
             end
           else if PopupMenu1.PopupComponent = cbSpecTemp then
             begin
               HtmlPage :=  HtmlPage + '#spectemp';
             end
           else if PopupMenu1.PopupComponent = cbSpecMass then
             begin
               HtmlPage :=  HtmlPage + '#specmass';
             end
           else if PopupMenu1.PopupComponent = cbSpecFlow then
             begin
               HtmlPage :=  HtmlPage + '#specfluid';
             end
           else if PopupMenu1.PopupComponent = cbSpecHeat then
             begin
               HtmlPage :=  HtmlPage + '#specheat';
             end
           else if PopupMenu1.PopupComponent = cbSpecSolute then
             begin
               HtmlPage :=  HtmlPage + '#specsolute';
             end
           else if PopupMenu1.PopupComponent = cbLeakage then
             begin
               HtmlPage :=  HtmlPage + '#leakage';
             end
           else if PopupMenu1.PopupComponent = cbRiver then
             begin
               HtmlPage :=  HtmlPage + '#river';
             end
           else if PopupMenu1.PopupComponent = cbET then
             begin
               HtmlPage :=  HtmlPage + '#evapotranspiration';
             end
           else if PopupMenu1.PopupComponent = cbAqInfl then
             begin
               HtmlPage :=  HtmlPage + '#influence';
             end
           else if PopupMenu1.PopupComponent = cbHeatCond then
             begin
               HtmlPage :=  HtmlPage + '#conduction';
             end
           else if PopupMenu1.PopupComponent = cbWells then
             begin
               HtmlPage :=  HtmlPage + '#wells';
             end
           else if PopupMenu1.PopupComponent = cbWellRiser then
             begin
               HtmlPage :=  HtmlPage + '#wellriser';
             end
           else if PopupMenu1.PopupComponent = cbSpecPresInterp then
             begin
               HtmlPage :=  HtmlPage + '#interpspecpres';
             end
           else if PopupMenu1.PopupComponent = cbSpecTempInterp then
             begin
               HtmlPage :=  HtmlPage + '#interpspectemp';
             end
           else if PopupMenu1.PopupComponent = cbSpecMassInterp then
             begin
               HtmlPage :=  HtmlPage + '#interpspecmass';
             end
           else if PopupMenu1.PopupComponent = cbSpecFlowInterp then
             begin
               HtmlPage :=  HtmlPage + '#interpspecflux';
             end
         end
      else if (PageControl1.ActivePage = tabFluidProp) then
         begin
           HtmlPage := 'fluidprop.htm';
           if PopupMenu1.PopupComponent = adeCompress then
             begin
               HtmlPage :=  HtmlPage + '#bp';
             end
           else if PopupMenu1.PopupComponent = adeRefPres then
             begin
               HtmlPage :=  HtmlPage + '#p0';
             end
           else if PopupMenu1.PopupComponent = adeRefTemp then
             begin
               HtmlPage :=  HtmlPage + '#t0';
             end
           else if PopupMenu1.PopupComponent = adeRefMassFrac then
             begin
               HtmlPage :=  HtmlPage + '#w0';
             end
           else if PopupMenu1.PopupComponent = adeFluidDensity then
             begin
               HtmlPage :=  HtmlPage + '#denf0';
             end
           else if PopupMenu1.PopupComponent = adeMaxMassFrac then
             begin
               HtmlPage :=  HtmlPage + '#w1';
             end
           else if PopupMenu1.PopupComponent = adeFluidDenseMax then
             begin
               HtmlPage :=  HtmlPage + '#denf1';
             end
           else if (PopupMenu1.PopupComponent = adeVisMultFact) or
             (PopupMenu1.PopupComponent = adeViscosity) or
             (PopupMenu1.PopupComponent = rgViscMeth) then
             begin
               HtmlPage :=  HtmlPage + '#visfac';
             end
         end
      else if (PageControl1.ActivePage = tabGeology) then
         begin
           HtmlPage := 'elements.htm';
           if PopupMenu1.PopupComponent = btnAddLayer then
             begin
               HtmlPage :=  HtmlPage + '#add';
             end
           else if PopupMenu1.PopupComponent = btnInsertLayer then
             begin
               HtmlPage :=  HtmlPage + '#insert';
             end
           else if PopupMenu1.PopupComponent = btnDeleteLayer then
             begin
               HtmlPage :=  HtmlPage + '#delete';
             end
           else if PopupMenu1.PopupComponent = edNumLayers then
             begin
               HtmlPage :=  HtmlPage + '#numelem';
             end
         end
      else if (PageControl1.ActivePage = tabHeat) then
         begin
           HtmlPage := 'heatcondtab.htm';
           if PopupMenu1.PopupComponent = edHeatCondBoundNodeN then
             begin
               HtmlPage :=  HtmlPage + '#nhcn';
             end
           else if PopupMenu1.PopupComponent = sgHeatCondBoundNodeSpacing then
             begin
               HtmlPage :=  HtmlPage + '#zhcbc';
             end
           else if PopupMenu1.PopupComponent = edInitialHeatCondBoundNodeN then
             begin
               HtmlPage :=  HtmlPage + '#nztphc';
             end
           else if PopupMenu1.PopupComponent = sgHeatCondBoundInitialCond then
             begin
               HtmlPage :=  HtmlPage + '#zthc';
             end
         end
      else if (PageControl1.ActivePage = tabInitCond) then
         begin
           HtmlPage := 'initcond.htm';
           if PopupMenu1.PopupComponent = cbSpecInitPres then
             begin
               HtmlPage :=  HtmlPage + '#ichydp';
             end
           else if PopupMenu1.PopupComponent = cbInitWatTable then
             begin
               HtmlPage :=  HtmlPage + '#ichwt';
             end
           else if PopupMenu1.PopupComponent = adeElevInitPres then
             begin
               HtmlPage :=  HtmlPage + '#zpinit';
             end
           else if PopupMenu1.PopupComponent = adeInitPres then
             begin
               HtmlPage :=  HtmlPage + '#pinit';
             end
           else if PopupMenu1.PopupComponent = cbInitPresInterp then
             begin
               HtmlPage :=  HtmlPage + '#interpinit';
             end
           else if PopupMenu1.PopupComponent = cbWatTableInitialInterp then
             begin
               HtmlPage :=  HtmlPage + '#interpinitwt';
             end
         end
      else if (PageControl1.ActivePage = tabInterpolation) then
         begin
           HtmlPage := 'interpolationtab.htm';
           if PopupMenu1.PopupComponent = cbInterpSpecPres then
             begin
               HtmlPage :=  HtmlPage + '#specified';
             end
           else if PopupMenu1.PopupComponent = cbInterpTempSpecPres then
             begin
               HtmlPage :=  HtmlPage + '#temp';
             end
           else if PopupMenu1.PopupComponent = cbInterpMassSpecPress then
             begin
               HtmlPage :=  HtmlPage + '#mass';
             end
           else if PopupMenu1.PopupComponent = cbInterpScMassFracSpecPres then
             begin
               HtmlPage :=  HtmlPage + '#scaled';
             end
           else if PopupMenu1.PopupComponent = cbFluidFluxInterp then
             begin
               HtmlPage :=  HtmlPage + '#fluxfluid';
             end
           else if PopupMenu1.PopupComponent = cbFluxDensityInterp then
             begin
               HtmlPage :=  HtmlPage + '#fluxdensity';
             end
           else if PopupMenu1.PopupComponent = cbFluxTempInterp then
             begin
               HtmlPage :=  HtmlPage + '#fluxtemperature';
             end
           else if PopupMenu1.PopupComponent = cbFluxMassFracInterp then
             begin
               HtmlPage :=  HtmlPage + '#fluxmass';
             end
           else if PopupMenu1.PopupComponent = cbFluxScMassFracInterp then
             begin
               HtmlPage :=  HtmlPage + '#fluxscmass';
             end
         end
      else if (PageControl1.ActivePage = tabOutput) then
         begin
           HtmlPage := 'outputtab.htm';
           if PopupMenu1.PopupComponent = cbPriPorous then
             begin
               HtmlPage :=  HtmlPage + '#prtpmp';
             end
           else if PopupMenu1.PopupComponent = cbPrFluidProp then
             begin
               HtmlPage :=  HtmlPage + '#prtfp';
             end
           else if PopupMenu1.PopupComponent = cbPrInit then
             begin
               HtmlPage :=  HtmlPage + '#prtic';
             end
           else if PopupMenu1.PopupComponent = cbPrStat then
             begin
               HtmlPage :=  HtmlPage + '#prtbc';
             end
           else if PopupMenu1.PopupComponent = cbPrSolMeth then
             begin
               HtmlPage :=  HtmlPage + '#prtslm';
             end
           else if PopupMenu1.PopupComponent = cbPrStatWell then
             begin
               HtmlPage :=  HtmlPage + '#prtwel';
             end
           else if PopupMenu1.PopupComponent = cbPrPorZone then
             begin
               HtmlPage :=  HtmlPage + '#pltzon';
             end
           else if PopupMenu1.PopupComponent = cbPrPostProc then
             begin
               HtmlPage :=  HtmlPage + '#plttem';
             end
           else if PopupMenu1.PopupComponent = comboPrOrientation then
             begin
               HtmlPage :=  HtmlPage + '#openpr';
             end
           else if PopupMenu1.PopupComponent = cbPrDensVisc then
             begin
               HtmlPage :=  HtmlPage + '#prtdv';
             end
           else if PopupMenu1.PopupComponent = comboPrPres then
             begin
               HtmlPage :=  HtmlPage + '#iprptc1';
             end
           else if PopupMenu1.PopupComponent = comboPrTemp then
             begin
               HtmlPage :=  HtmlPage + '#iprptc2';
             end
           else if PopupMenu1.PopupComponent = comboPrMassFr then
             begin
               HtmlPage :=  HtmlPage + '#iprptc3';
             end
           else if (PopupMenu1.PopupComponent = edPath) or
             (PopupMenu1.PopupComponent = btnBrowseHST3D) then
             begin
               HtmlPage :=  HtmlPage + '#path';
             end
           else if PopupMenu1.PopupComponent = edInput then
             begin
               HtmlPage :=  HtmlPage + '#input';
             end
           else if PopupMenu1.PopupComponent = edExtension then
             begin
               HtmlPage :=  HtmlPage + '#extension';
             end
         end
      else if (PageControl1.ActivePage = tabProblem) then
         begin
           HtmlPage := 'problem.htm';
         end
      else if (PageControl1.ActivePage = tabRefTherm) then
         begin
           HtmlPage := 'refcond.htm';
           if PopupMenu1.PopupComponent = adeAtmPres then
             begin
               HtmlPage :=  HtmlPage + '#paatm';
             end
           else if PopupMenu1.PopupComponent = adeRefPresEnth then
             begin
               HtmlPage :=  HtmlPage + '#p0h';
             end
           else if PopupMenu1.PopupComponent = adeRefTempEnth then
             begin
               HtmlPage :=  HtmlPage + '#t0h';
             end
           else if PopupMenu1.PopupComponent = adeFluidHeatCap then
             begin
               HtmlPage :=  HtmlPage + '#cpf';
             end
           else if PopupMenu1.PopupComponent = adeFluidThermCond then
             begin
               HtmlPage :=  HtmlPage + '#kthf';
             end
           else if PopupMenu1.PopupComponent = adeFluidCoefExp then
             begin
               HtmlPage :=  HtmlPage + '#bt';
             end
           else if PopupMenu1.PopupComponent = adeEffMolDiff then
             begin
               HtmlPage :=  HtmlPage + '#dm';
             end
           else if PopupMenu1.PopupComponent = adeSolDecConst then
             begin
               HtmlPage :=  HtmlPage + '#declam';
             end
         end
      else if (PageControl1.ActivePage = tabSolver) then
         begin
           HtmlPage := 'solver.htm';
           if PopupMenu1.PopupComponent = adeSpatDiscFac then
             begin
               HtmlPage :=  HtmlPage + '#fdsmth';
             end
           else if PopupMenu1.PopupComponent = adeTempDiscFact then
             begin
               HtmlPage :=  HtmlPage + '#fdtmth';
             end
           else if PopupMenu1.PopupComponent = adeTolFracDens then
             begin
               HtmlPage :=  HtmlPage + '#tolden';
             end
           else if PopupMenu1.PopupComponent = adeMaxIter then
             begin
               HtmlPage :=  HtmlPage + '#maxitn';
             end
           else if PopupMenu1.PopupComponent = rgSolutionMethod then
             begin
               HtmlPage :=  HtmlPage + '#slmeth';
             end
           else if PopupMenu1.PopupComponent = adeNumTime then
             begin
               HtmlPage :=  HtmlPage + '#ntsopt';
             end
           else if PopupMenu1.PopupComponent = adeTolerance then
             begin
               HtmlPage :=  HtmlPage + '#epsslv';
             end
           else if PopupMenu1.PopupComponent = adeTolerance2 then
             begin
               HtmlPage :=  HtmlPage + '#epsomg';
             end
           else if PopupMenu1.PopupComponent = adeMaxIt1 then
             begin
               HtmlPage :=  HtmlPage + '#maxit1';
             end
           else if PopupMenu1.PopupComponent = adeMaxIt2 then
             begin
               HtmlPage :=  HtmlPage + '#maxit2';
             end
           else if PopupMenu1.PopupComponent = comboRenumDir then
             begin
               HtmlPage :=  HtmlPage + '#idir';
             end
           else if PopupMenu1.PopupComponent = adeNumSteps then
             begin
               HtmlPage :=  HtmlPage + '#nsdr';
             end
           else if PopupMenu1.PopupComponent = comboIORDER then
             begin
               HtmlPage :=  HtmlPage + '#iorder';
             end
         end
      else if (PageControl1.ActivePage = tabTime) then
         begin
           HtmlPage := 'timetab.htm';
           if PopupMenu1.PopupComponent = edMaxTimes then
             begin
               HtmlPage :=  HtmlPage + '#maximum';
             end
           else if PopupMenu1.PopupComponent = btnAddTime then
             begin
               HtmlPage :=  HtmlPage + '#add';
             end
           else if PopupMenu1.PopupComponent = btnDelTime then
             begin
               HtmlPage :=  HtmlPage + '#delete';
             end
           else if PopupMenu1.PopupComponent = btnInsertTime then
             begin
               HtmlPage :=  HtmlPage + '#insert';
             end
         end
      else if (PageControl1.ActivePage = tabWellRiser) then
         begin
           HtmlPage := 'wellriser.htm';
           if PopupMenu1.PopupComponent = adeMaxIterWell then
             begin
               HtmlPage :=  HtmlPage + '#mxitqw';
             end
           else if PopupMenu1.PopupComponent = adeTolWell then
             begin
               HtmlPage :=  HtmlPage + '#toldpw';
             end
           else if PopupMenu1.PopupComponent = adeTolFracPresWell then
             begin
               HtmlPage :=  HtmlPage + '#tolfpw';
             end
           else if PopupMenu1.PopupComponent = adeTolFracFlowWell then
             begin
               HtmlPage :=  HtmlPage + '#tolfqw';
             end
           else if PopupMenu1.PopupComponent = adeDampWell then
             begin
               HtmlPage :=  HtmlPage + '#damwrc';
             end
           else if PopupMenu1.PopupComponent = adeMinStepWell then
             begin
               HtmlPage :=  HtmlPage + '#dzmin';
             end
           else if PopupMenu1.PopupComponent = adeFracTolIntWell then
             begin
               HtmlPage :=  HtmlPage + '#epswr';
             end
           else if PopupMenu1.PopupComponent = adeFracTolIntWell then
             begin
               HtmlPage :=  HtmlPage + '#epswr';
             end
         end
      else if (PageControl1.ActivePage = tabBCFLOW) then
         begin
           HtmlPage := 'bcflowtab.htm';
           if PopupMenu1.PopupComponent = cbUseBCFLOW then
             begin
               HtmlPage :=  HtmlPage + '#bcflow';
             end
           else if PopupMenu1.PopupComponent = cbBCFLOWUseSpecState then
             begin
               HtmlPage :=  HtmlPage + '#value';
             end
           else if PopupMenu1.PopupComponent = cbBCFLOWUseSpecFlux then
             begin
               HtmlPage :=  HtmlPage + '#flux';
             end
           else if PopupMenu1.PopupComponent = cbBCFLOWUseLeakage then
             begin
               HtmlPage :=  HtmlPage + '#leakage';
             end
           else if PopupMenu1.PopupComponent = cbBCFLOWUseAqInfl then
             begin
               HtmlPage :=  HtmlPage + '#aquifer';
             end
           else if PopupMenu1.PopupComponent = cbBCFLOWUseHeatCond then
             begin
               HtmlPage :=  HtmlPage + '#heat';
             end
           else if PopupMenu1.PopupComponent = cbBCFLOWUseET then
             begin
               HtmlPage :=  HtmlPage + '#evapotranspiration';
             end
           else if (PopupMenu1.PopupComponent = edBCFLOWPath) or
             (PopupMenu1.PopupComponent = btnBrowseBCFLOW) then
             begin
               HtmlPage :=  HtmlPage + '#path';
             end
           else if (PopupMenu1.PopupComponent = adeBCFLOWTitle1) or
             (PopupMenu1.PopupComponent = adeBCFLOWTitle2) then
             begin
               HtmlPage :=  HtmlPage + '#title';
             end
         end
      else
        begin
           HtmlPage := 'project.htm';
           ShowMessage('Error displaying help');
        end;

      ShowSpecificHTMLHelp(HtmlPage);
end;

procedure THST3DForm.ASLinkWinstonClick(Sender: TObject);
begin
//  ASLinkWinston.Execute;
end;


procedure THST3DForm.ASLinkKippClick(Sender: TObject);
begin
//  ASLinkKipp.Execute;
end;

procedure THST3DForm.cbObsElevClick(Sender: TObject);
begin
  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(THST3DNodeGridLayer,
    cbObsElev.Checked);
  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(TObsSurfLayer,
    cbObsElev.Checked);
  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(TObsPointsLayer,
    cbObsElev.Checked);
end;

end.


