unit frmSutraUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ComCtrls, ExtCtrls, ArgusDataEntry, ANE_LayerUnit,
  Buttons, {VersInfo,} verslab, Grids, AnePIE, VirtualMeshUnit, VersInfo,
  ASLink, Strset, DefaultValueFrame, Mask, DBCtrls;

type
  TTransportType = (ttGeneral, ttEnergy, ttSolute);
  TStateVariableType = (svPressure, svHead);
  TGeologyHeaders = (ghNumber, ghName, ghDiscretization);
  TSutraDimensionality = (sd2D, sd3D);

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
    adeISTORE: TArgusDataEntry;
    cbCNODAL: TCheckBox;
    cbCELMNT: TCheckBox;
    cbCINCID: TCheckBox;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label52: TLabel;
    Label55: TLabel;
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
    gbOrientation: TGroupBox;
    rbAreal: TRadioButton;
    rbCrossSection: TRadioButton;
    Label17: TLabel;
    lblVersion: TLabel;
    tabProblem: TTabSheet;
    reProblem: TRichEdit;
    OpenDialog1: TOpenDialog;
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
    tabInnerIteration: TTabSheet;
    rgPressureSolver: TRadioGroup;
    rgTransportSolver: TRadioGroup;
    Label26: TLabel;
    Label27: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label61: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label77: TLabel;
    Label90: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    adeITRMXP: TArgusDataEntry;
    adeITOLP: TArgusDataEntry;
    adeTOLP: TArgusDataEntry;
    adeNSAVEP: TArgusDataEntry;
    adeITRMXU: TArgusDataEntry;
    adeITOLU: TArgusDataEntry;
    adeTOLU: TArgusDataEntry;
    adeNSAVEU: TArgusDataEntry;
    Label83: TLabel;
    edRunSutra: TEdit;
    btnBrowse: TBitBtn;
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
    tabVertDisc: TTabSheet;
    sgGeology: TStringGrid;
    Panel1: TPanel;
    adeVertDisc: TArgusDataEntry;
    Label114: TLabel;
    Panel2: TPanel;
    btnInsert: TButton;
    btnAdd: TButton;
    btnDelete: TButton;
    rb3D_va: TRadioButton;
    rb3D_nva: TRadioButton;
    edRoot: TEdit;
    adeBoundLayerCount: TArgusDataEntry;
    Label115: TLabel;
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
    Label11: TLabel;
    cbNodeElementNumbers: TCheckBox;
    Label12: TLabel;
    Label84: TLabel;
    Label125: TLabel;
    edSutraViewerPath: TEdit;
    btnBrowseSutraViewer: TBitBtn;
    GroupBox15: TGroupBox;
    rbFishnet: TRadioButton;
    rbIrregular: TRadioButton;
    sbGeology: TStatusBar;
    cbUseConstantValues: TCheckBox;
    tabInitialValues: TTabSheet;
    pageCtrlInitialValues: TPageControl;
    tabInitial2D3D: TTabSheet;
    GroupBox5: TGroupBox;
    tabInitial3D: TTabSheet;
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
    FramDMidHydCond: TFrmDefaultValue;
    FramPermAngleRotational: TFrmDefaultValue;
    FramPermAngleVertical: TFrmDefaultValue;
    FramLongDispMid: TFrmDefaultValue;
    FramTransvDisp1Mid: TFrmDefaultValue;
    FramTransvDisp2Max: TFrmDefaultValue;
    FramTransvDisp2Mid: TFrmDefaultValue;
    FramTransvDisp2Min: TFrmDefaultValue;
    Panel4: TPanel;
    adeThickness: TArgusDataEntry;
    Label123: TLabel;
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
    procedure comboISSFLOChange(Sender: TObject);
    procedure rgPressureSolverClick(Sender: TObject);
    procedure rgTransportSolverClick(Sender: TObject);
    procedure adeVertDiscExit(Sender: TObject);
    procedure sgGeologySetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure adeVertDiscEnter(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure sgGeologyDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure rb3D_nvaClick(Sender: TObject);
    procedure adeBoundLayerCountEnter(Sender: TObject);
    procedure adeBoundLayerCountExit(Sender: TObject);
    procedure sgGeologyExit(Sender: TObject);
    procedure edRunSutraChange(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure FormShow(Sender: TObject);
    procedure comboSIMULAChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgDimensionsClick(Sender: TObject);
    procedure FixRealsOnExit(Sender: TObject);
    procedure cbNodeElementNumbersClick(Sender: TObject);
    procedure sgGeologySelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure rbFishnetClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure comboIUNSATChange(Sender: TObject);
    procedure cbUseConstantValuesClick(Sender: TObject);
    procedure FramPorbtnSetValueClick(Sender: TObject);
    procedure btnRestartFileClick(Sender: TObject);
    procedure rgInitialValuesClick(Sender: TObject);
  private
    Cancelling : boolean;
    ShouldAskY, ShouldAskZ : boolean;
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
    procedure SetGeoGridHeaders;
    procedure InitializeGeoGrid;
    procedure AddOrRemoveParameters;
    procedure EnableGravControls;
    procedure AdjustInitPerm;
    procedure ReadOldFishnet(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure EnableTransportConditionControls;
    procedure UpdateBoundaryLayerCount(Sender: TObject);
    procedure SetDefaults;
    procedure EnableComp;
    function GetUnitName(ProposedName: string;
      CurrentRow: integer): String;
    function TestUnitName(ProposedName: string;
      CurrentRow: integer): boolean;
    procedure GetNodeAndElementCounts;
    procedure SetNewProject(AValue : boolean);
    procedure SetTitles;
    procedure SetSourcesOfFluidExpressions;
    procedure UpdateExpressions;
    procedure ReadOldNPCYC(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    procedure ReadOldNUCYC(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl);
    { Private declarations }
  public
    SutraLayerStructure : TLayerStructure;
    OldModel : boolean;
    FNewProject : boolean;
    OldVertDiscretization : string;
    OldNumberOfUnits : integer;
    dimensions : TSutraDimensionality;
    MorphMesh : T3DMorphMesh;
    VirtualMesh : TVirtual3DMesh;
    BoundaryLayerCount : integer;
    ElementCount : integer; // number of elements on a single layer in a 3d model
    NodeCount : integer; // number of nodes on a single layer in a 3d model
    property NewProject : boolean read FNewProject Write SetNewProject;
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
    function MakeVirtualMesh : boolean;
    function FreeVirtualMesh: boolean;
    function ParsePorosity: boolean;
    function GetMorphedNodeValue(NodeIndex: integer; Expression : string): ANE_DOUBLE;
    function ParseInitialPressure : boolean;
    function ParseInitialConcentration: boolean;
    function ParsePermMaximum : boolean;
    function ParsePermMinimum: boolean;
    function ParsePermMiddle: boolean;
    function ParseFloatExpression(Expression: string): boolean;
    function GetMorphedElementValue(ElementIndex: integer;
      Expression : string): ANE_DOUBLE;
    function GetMorphedElementAngleValue(ElementIndex: integer;
      Expression: string): ANE_DOUBLE;
    function GetLayerCount: Integer;
    function GetXValue(NodeIndex: integer): ANE_DOUBLE;
    function GetYValue(NodeIndex: integer): ANE_DOUBLE;
    function GetZValue(NodeIndex: integer): ANE_DOUBLE;
    function N(var MultipleUnits : Boolean; var MeshN : String): string;
    function GetN(var MultipleUnits : Boolean): string;
    function GetPIEVersion(AControl: Tcontrol): string;
    procedure AssignHelpFile(FileName: string); virtual;
    function Is3D: boolean;
    function MorphedMesh: boolean;
    function VerticallyAlignedMesh: boolean;
    procedure GetLayerNodeAndElementCounts;
    { Public declarations }
  end;

var
  frmSutra: TfrmSutra;
  UseConstantValue : boolean = True;

implementation

{$R *.DFM}

uses UtilityFunctions, GlobalVariables, SLMorphLayer, SLObservation,
  SLGroupLayers, SLPorosity,
  SLPermeability, SLDispersivity, SLUnsaturated, SLSourcesOfFluid,
  SLEnergySoluteSources, SLSpecifiedPressure, SLSpecConcOrTemp,
  SLInitialPressure, SLInitConcOrTemp, SLSutraMesh, SLFishnetMeshLayout,
  SLDomainDensity, SLThickness, SLMap, SLDataLayer, SLGeoUnit,
  IntListUnit, SLGeneralParameters, OptionsUnit, SLBoundaryGroup, ZFunction,
  frmUnitN;


procedure TfrmSutra.SetThicknessExpressions;
begin
  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TZParam, TZParam.ANE_ParamName, True);
end;

procedure TfrmSutra.UpdateExpressions;
begin
  SetSourcesOfFluidExpressions;

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSoluteEnergySourcesLayer, TResultantSoluteEnergySourceParam,
     TResultantSoluteEnergySourceParam.ANE_ParamName, True);
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



  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPBCParam, TPBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPBCTopParam, TPBCTopParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPBCBottomParam, TPBCBottomParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPMAXParam, TPMAXParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPMIDParam, TPMIDParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPMINParam, TPMINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLEXParam, TANGLEXParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLE1Param, TANGLE1Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLE2Param, TANGLE2Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TANGLE3Param, TANGLE3Param.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TTimeDepSpecHeadPresParam,
     TTimeDepSpecHeadPresParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);






  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCParam, TPBCParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCTopParam, TPBCTopParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPBCBottomParam, TPBCBottomParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPVECParam, TPVECParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMAXParam, TPMAXParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMIDParam, TPMIDParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TPMINParam, TPMINParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLEXParam, TANGLEXParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE1Param, TANGLE1Param.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE2Param, TANGLE2Param.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TANGLE3Param, TANGLE3Param.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecHeadPresParam,
     TTimeDepSpecHeadPresParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
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

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSoluteEnergySourcesLayer, TResultantSoluteEnergySourceParam,
     TResultantSoluteEnergySourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TFluidSourcesLayer, TQINUINParam, TQINUINParam.ANE_ParamName, True);



  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TUBCParam, TUBCParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TQUINParam, TQUINParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TTimeDepEnergySoluteSourceParam,
     TTimeDepEnergySoluteSourceParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TTimeDepSpecConcTempParam,
     TTimeDepSpecConcTempParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (TSutraMeshLayer, TUVECParam, TUVECParam.ANE_ParamName, True);







  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TpUBCParam, TpUBCParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUBCParam, TUBCParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TQUINParam, TQUINParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepEnergySoluteSourceParam,
     TTimeDepEnergySoluteSourceParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TTimeDepSpecConcTempParam,
     TTimeDepSpecConcTempParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUVECParam, TUVECParam.ANE_ParamName, True);




  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.SetSourcesOfFluidExpressions;
begin
  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TFluidSourcesLayer, TResultantFluidSourceParam,
     TResultantFluidSourceParam.ANE_ParamName, True);
end;

procedure TfrmSutra.SetUnsaturatedExpressions;
begin
  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TNREGParam, TNREGParam.ANE_ParamName, True);

  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TLREGParam, TLREGParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TNREGParam, TNREGParam.ANE_ParamName, True);

  SutraLayerStructure.ListsOfIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TLREGParam, TLREGParam.ANE_ParamName, True);

{  SutraLayerStructure.UnIndexedLayers.SetUnIndexedExpressionNow
    (TSutraMeshLayer, TUINParam, TUINParam.ANE_ParamName, True); }

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.AddOrRemoveParameters;
var
  MeshLayer : T_ANE_QuadMeshLayer;
begin

  if not cancelling then
  begin
    MeshLayer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;
    if MeshLayer <> nil then
    begin
      MeshLayer.AddOrRemoveUnIndexedParameter(TNREGParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TZParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPORParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TLREGParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPMAXParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPMINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TANGLEXParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TALMAXParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TALMINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TQINParam,
        not Is3D);
  //    MeshLayer.AddOrRemoveUnIndexedParameter(TIsFluidSource,
  //      rbAreal.Checked or rbCrossSection.Checked);
      MeshLayer.AddOrRemoveUnIndexedParameter(TUINParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepFluidSourceParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TQUINParam,
        not Is3D);
  //    MeshLayer.AddOrRemoveUnIndexedParameter(TIsQUINSource,
  //      rbAreal.Checked or rbCrossSection.Checked);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepEnergySoluteSourceParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPBCParam,
        not Is3D);
  //    MeshLayer.AddOrRemoveUnIndexedParameter(TIsPBCSource,
  //      rbAreal.Checked or rbCrossSection.Checked);
      MeshLayer.AddOrRemoveUnIndexedParameter(TpUBCParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepSpecHeadPresParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TUBCParam,
        not Is3D);
  //    MeshLayer.AddOrRemoveUnIndexedParameter(TIsUBCSource,
  //      rbAreal.Checked or rbCrossSection.Checked);
      MeshLayer.AddOrRemoveUnIndexedParameter(TTimeDepSpecConcTempParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TPVECParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TUVECParam,
        not Is3D);
      MeshLayer.AddOrRemoveUnIndexedParameter(TINOBParam,
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
      MeshLayer.AddOrRemoveIndexedParameter1(TLREGParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPMAXParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPMIDParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPMINParam,
        VerticallyAlignedMesh);

  //    MeshLayer.AddOrRemoveIndexedParameter1(TANGLEXParam,
  //      rb3D_va.Checked);
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
      MeshLayer.AddOrRemoveIndexedParameter1(TQINParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TIsFluidSource,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TUINParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TTimeDepFluidSourceParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TQUINParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TIsQUINSource,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TTimeDepEnergySoluteSourceParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPBCParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TIsPBCSource,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TpUBCParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TTimeDepSpecHeadPresParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TUBCParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TIsUBCSource,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TTimeDepSpecConcTempParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPVECParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TUVECParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TINOBParam,
        VerticallyAlignedMesh);

      MeshLayer.AddOrRemoveIndexedParameter1(TAT1MAXParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT1MIDParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT1MINParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT2MAXParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT2MIDParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TAT2MINParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TQINTopParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TQINBottomParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TQUINTopParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TQUINBottomParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPBCTopParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TPBCBottomParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TUBCTopParam,
        VerticallyAlignedMesh);
      MeshLayer.AddOrRemoveIndexedParameter1(TUBCBottomParam,
        VerticallyAlignedMesh);


    end;
  end;
end;

procedure TfrmSutra.AddOrRemoveLayers;
begin
  if not cancelling then
  begin
    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraMeshLayer,
      not MorphedMesh );

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TFishnetMeshLayout,
      rbFishnet.Checked and not MorphedMesh);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TFishnetMeshLayout,
      rbFishnet.Checked and MorphedMesh);

  {  SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraDomainOutline,
      not MorphedMesh);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraMeshDensity,
      not MorphedMesh); }

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TObservationLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraHydrogeologyGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TThicknessLayer,
      (not Is3D and rbUserSpecifiedThickness.Checked) );

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TPorosityLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TPermeabilityLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TDispersivityLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TUnsaturatedLayer,
      (not Is3D and rbCrossSection.Checked and rbSatUnsat.Checked));

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TUnsaturatedLayer,
      (Is3D and rbSatUnsat.Checked));

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraHydroSourcesGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TFluidSourcesLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSoluteEnergySourcesLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraHydroBoundariesGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSpecifiedPressureLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSpecConcTempLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraInitialConditionsGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TInitialPressureLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TInitialConcTempLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraMapPointGroupLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraMapLayer,
      not Is3D);

    SutraLayerStructure.UnIndexedLayers.AddOrRemoveLayer(TSutraDataLayer,
      not Is3D);

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TVolFluidSourcesLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TSurfaceFluidSourcesLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TVolSoluteEnergySourcesLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TSurfaceSoluteEnergySourcesLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TVolSpecifiedPressureLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TSpecifiedPressureSurfaceLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TVolSpecConcTempLayer, Is3D );

    SutraLayerStructure.FirstListsOfIndexedLayers.AddOrRemoveLayer
      (TSurfaceSpecConcTempLayer, Is3D );
  end;

  SutraLayerStructure.SetAllParamUnits;
end;

procedure TfrmSutra.rbGeneralClick(Sender: TObject);
begin
  inherited;
  {$IFNDEF Sutra2d}
//  rgDimensions.Enabled := rbGeneral.Checked;
{  if not Loading and not cancelling then
  begin
    if rbAreal.Checked or rbCrossSection.Checked then
    begin
      rgDimensions.ItemIndex := 0;
    end
    else
    begin
      rgDimensions.ItemIndex := 1;
    end;
  end;   }
  {$ENDIF}

  AdjustInitPerm;
  rgDimensionsClick(Sender);

  EnableGravControls;
  tabVertDisc.TabVisible := Is3D;

  rbAreal.Enabled := rbSpecific.Checked and not Is3D;
  rbCrossSection.Enabled := rbSpecific.Checked and not Is3D;
  rb3D_va.Enabled := Is3D;
  rb3D_nva.Enabled := Is3D;

  rbSat.Enabled := rbSpecific.Checked;
  if not rbSat.Enabled then
  begin
    rbSatUnsat.Checked := True;
    rbSatUnsatClick(Sender);
  end;

  EnableTransportConditionControls;

  rbSoluteConstDens.Enabled := {not Is3D and rbSpecific.Checked and rbAreal.Checked;} rbSpecific.Checked;
  if not rbSoluteConstDens.Enabled and rbSoluteConstDens.Checked then
  begin
    rbSoluteVarDens.Checked := True;
  end;

  rbUserSpecifiedThickness.Enabled := rbSpecific.Checked;
  adeCW.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeCS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeSIGMAS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adePRODF1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;
  adePRODS1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;

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
  SetDefaults;
end;

procedure TfrmSutra.EnableGravControls;
var
  ShouldEnable : boolean;
begin
  ShouldEnable :=  (Is3D or rbCrossSection.Checked)
    and not rbSoluteConstDens.Checked;
  adeGRAVX.Enabled := ShouldEnable;
  if not adeGRAVX.Enabled and not Loading and not Cancelling then
  begin
    adeGRAVX.Text := '0';
  end;

  if not adeGRAVY.Enabled and ShouldEnable and not Loading and not Cancelling then
  begin
    if rbCrossSection.Checked then
    begin
      adeGRAVY.Text := '-9.81'
    end;
  end;
  adeGRAVY.Enabled := ShouldEnable;
  if adeGRAVY.Enabled then
  begin
{    if not Loading and not Cancelling
      and (StrToFloat(adeGRAVY.Text) = 0) and not Is3D
      and not rbSoluteConstDens.Checked then
    begin
      If ShouldAskY then
      begin
        Beep;
        if (MessageDlg('Do you wish to change the Y-Component of gravity to -9.81 m/s?',
          mtInformation, [mbYes, mbNo], 0) = mrYes) then
        begin
          adeGRAVY.Text := '-9.81';
        end;
        ShouldAskY := False;
      end;
    end  }
  end
  else
  begin
    adeGRAVY.Text := '0';
  end;

  adeGRAVZ.Enabled := ShouldEnable;
  if adeGRAVZ.Enabled then
  begin
{    if not Loading and not Cancelling
      and (StrToFloat(adeGRAVY.Text) = 0) and Is3D
      and not rbSoluteConstDens.Checked then
    begin
      if ShouldAskZ then
      begin
        Beep;
        if MessageDlg('Do you wish to change the Z-Component of gravity to -9.81 m/s?',
          mtInformation, [mbYes, mbNo], 0) = mrYes then
        begin
          adeGRAVZ.Text := '-9.81';
        end;
        ShouldAskZ := False;
      end;
    end  }
  end
  else
  begin
    adeGRAVZ.Text := '0';
  end;

end;

procedure TfrmSutra.rbArealClick(Sender: TObject);
var
  Index : integer;
  ALayerList : T_ANE_IndexedLayerList;
begin
  inherited;

  {$IFNDEF Sutra2d}
{  if not Loading and not cancelling then
  begin
    if rbAreal.Checked or rbCrossSection.Checked then
    begin
      rgDimensions.ItemIndex := 0;
    end
    else
    begin
      rgDimensions.ItemIndex := 1;
    end;
  end;  }
  {$ENDIF}

  AdjustInitPerm;
  if (Sender <> rbGeneral) and (Sender <> rbSpecific) then
  begin
    EnableGravControls;
  end;
  tabVertDisc.TabVisible := Is3D;


  rbIrregular.Enabled := not Is3d;
  if not rbIrregular.Enabled then
  begin
    rbFishnet.Checked;
  end;

{  rgMeshType.Enabled := rbGeneral.Checked or (rbSpecific.Checked
    and (rbCrossSection.Checked or rbAreal.Checked));
  if not rgMeshType.Enabled then
  begin
    rgMeshType.ItemIndex := 0;
  end;  }
  rbSatUnsat.Enabled := Is3D or (rbSpecific.Checked
    and not rbAreal.Checked) or rbGeneral.Checked;
  if not rbSatUnsat.Enabled and not Loading and not Cancelling then
  begin
    rbSat.Checked := True;
  end;

  EnableTransportConditionControls;

{  rbEnergy.Enabled := rbGeneral.Checked or (rbSpecific.Checked
    and rbCrossSection.Checked);
}
  rbCylindrical.Enabled := rbSpecific.Checked and rbCrossSection.Checked;
{  adeBoundLayerCount.Enabled := False;

  if not Is3D then
  begin
    adeBoundLayerCountEnter(Sender);
    adeBoundLayerCount.Min := 0;
    adeBoundLayerCount.Text := '0';
    adeBoundLayerCountExit(Sender);
  end;   }

  if rbSatUnsat.Checked and not rbSatUnsat.Enabled
    and not Loading and not Cancelling then
  begin
    rbSat.Checked := True;
  end;
  rbSatUnsatClick(Sender);

{  if rbSoluteVarDens.Checked and not rbSoluteVarDens.Enabled
    and not Loading and not Cancelling then
  begin
    rbSoluteConstDens.Checked := True;
  end;

  if rbEnergy.Checked and not rbEnergy.Enabled
    and not Loading and not Cancelling then
  begin
    rbSoluteConstDens.Checked := True;
  end;
}

  if rbCylindrical.Checked and not rbCylindrical.Enabled
    and not Loading and not Cancelling then
  begin
    rbUserSpecifiedThickness.Checked := True;
  end;

  AddOrRemoveLayers;
  AddOrRemoveParameters;
  if not is3D then
  begin
    for Index := 0 to SutraLayerStructure.ListsOfIndexedLayers.Count -1 do
    begin
        ALayerList := SutraLayerStructure.ListsOfIndexedLayers.Items[Index];
        ALayerList.DeleteSelf
    end;
  end;

  dimensions := sd2d;
  SetDefaults;
end;

procedure TfrmSutra.FormCreate(Sender: TObject);
begin
  inherited;
  {$IFDEF Sutra2d}
  rgDimensions.Enabled := False;
  rb3D_va.Enabled := False;
  rb3D_nva.Enabled := False;
  {$ENDIF}

  SpecialHandlingList := TSpecialHandlingList.Create;
  SpecialHandlingList.Add(TSpecialHandlingObject.Create('rgMeshType',
    ReadOldFishnet));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('adeNPCYC',
    ReadOldNPCYC));

  SpecialHandlingList.Add(TSpecialHandlingObject.Create('adeNUCYC',
    ReadOldNUCYC));

  Cancelling := False;
  GetVersion := GetPIEVersion;

  memoSutraDoc.Lines := StrSetDoc1.Strings;
  memoDoc.Lines := StrSetDoc2.Strings;

  VersionInfo1.FileName := DLLName;
  lblVersion.Caption := VersionInfo1.FileVersion;
  dimensions := sd2D;

  comboSIMULA.ItemIndex := 1;
  OldModel := False;

  EnableTemporalControls;

  pgcontrlMain.ActivePage := tabConfiguration;
  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
  edRunSutraChange(edRunSutra);

  comboIUNSAT.ItemIndex := 0;
  comboISSFLO.ItemIndex := 1;
  comboISSTRA.ItemIndex := 1;
  comboIREAD.ItemIndex := 0;
  comboADSMOD.ItemIndex := 0;
  EnableTemporalControls;

  pageCtrlInitialValues.ActivePageIndex := 0;

  InitializeGeoGrid;
  IgnoreList.Add('rgRunSutra');
  IgnoreList.Add('rgAlert');
  IgnoreList.Add('cbExternal');
  IgnoreList.Add('edRoot');
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
//  IgnoreList.Add('edRunSutra');
//  IgnoreList.Add('edSutraViewerPath');

  FirstList.Add('rbGeneral');
  FirstList.Add('rbSpecific');
  FirstList.Add('rbAreal');
  FirstList.Add('rbCrossSection');
  FirstList.Add('rb3D_va');
  FirstList.Add('rb3D_nva');
  FirstList.Add('adeBoundLayerCount');
  FirstList.Add('rgDimensions');
  FirstList.Add('adeVertDisc');

  SetTitles;
end;

procedure TfrmSutra.rbSoluteVarDensClick(Sender: TObject);
begin
  inherited;
  EnableGravControls;
  EnableComp;
{  if rbSoluteConstDens.Checked then
  begin
    adeGRAVX.Enabled := False;
    adeGRAVY.Enabled := False;
    adeGRAVZ.Enabled := False;
    adeGRAVX.Text := '0';
    adeGRAVY.Text := '0';
    adeGRAVZ.Text := '0';
  end;  }
  if rbEnergy.Checked then
  begin
    comboSIMULA.ItemIndex := 0;
  end
  else
  begin
    comboSIMULA.ItemIndex := 1;
  end;
  AdjustInitPerm;
  adeCW.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeCS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adeSIGMAS.Enabled := rbEnergy.Checked or rbGeneral.Checked;
  adePRODF1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;
  adePRODS1.Enabled := not rbEnergy.Checked or rbGeneral.Checked;

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

  adeVISC0.Enabled := not rbSoluteConstDens.Checked;
  if not adeVISC0.Enabled then
  begin
    adeVISC0.Text := '1'
  end;

  adeCW.Enabled := (rbGeneral.Checked and (comboSIMULA.ItemIndex = 0))
    or (rbSpecific.Checked and rbEnergy.Checked);
  if not adeCW.Enabled then
  begin
    adeCW.Text := '1'
  end;

  SetDefaults;
  AddOrRemoveLayers;
  SetPressureHeadExpressions;
  SetSoluteEnergyExpressions;

  SetSoluteHeatCaptions;
  SetPressureHeadCaptions;
  SetTitles;
end;

procedure TfrmSutra.rbSatUnsatClick(Sender: TObject);
begin
  inherited;
  comboIUNSAT.Enabled := rbSatUnsat.Enabled and rbSat.Enabled;
{  if not comboIUNSAT.Enabled then
  begin
    comboIUNSAT.ItemIndex := 0;
  end; }
  If not loading and not cancelling then
  begin
    if rbSat.Checked then
    begin
      comboIUNSAT.ItemIndex := 0
    end
    else if rbSatUnsat.Checked then
    begin
      comboIUNSAT.ItemIndex := 1
    end;
  end;

  AddOrRemoveLayers;
  SetUnsaturatedExpressions;
  SetDefaults;
end;

procedure TfrmSutra.EnableTemporalControls;
begin
  inherited;
  tabTemporal.TabVisible := (comboISSFLO.ItemIndex = 0) or (comboISSTRA.ItemIndex = 0);
end;


procedure TfrmSutra.comboISSTRAChange(Sender: TObject);
begin
  inherited;
  EnableTemporalControls;
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
  adeBoundLayerCount.CheckMin := False;

  LoadForm(UnreadData, DataToRead, VersionInString, lblVersion);

  // in cases where ArgusDataEntries check maximum values,
  // re-enable the checks.
  adeBoundLayerCount.CheckMin := True;

  // make sure that the grid titles are correct
{  InitializeGrids;   }

end;

procedure TfrmSutra.ModelComponentName(AStringList: TStringList);
begin
  AStringList.Add(edRunSutra.Name);
  AStringList.Add(edSutraViewerPath.Name);
end;

procedure TfrmSutra.btnBrowseClick(Sender: TObject);
var
  CurrentDir : string;
begin
  inherited;
  CurrentDir := GetCurrentDir;
  try
    OpenDialog1.Filter := 'Executables (*.exe)|*.exe|Batch Files (*.bat)|*.bat|All Files (*.*)|*.*';
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
      OpenDialog1.FileName := edSutraViewerPath.Text;
      if OpenDialog1.Execute then
      begin
        edSutraViewerPath.Text := OpenDialog1.FileName;
      end;
    end;

  finally
    SetCurrentDir(CurrentDir);
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
              Loading := True;
              try
                LoadSutraForm(UnreadData, AStringList.Text , VersionInString );
              finally
                Loading := False;
              end;


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
  FreeVirtualMesh;
  SutraLayerStructure.Free;
  SpecialHandlingList.Free;
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
        cbCELMNT.Caption := 'Print element permeabilities and dispersivities';
      end;
    svHead:
      begin
        cbCELMNT.Caption := 'Print element hydraulic conductivities and dispersivities';
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
        cbCBUDG.Caption := 'Print fluid mass and energy or solute budgets';
      end;
    ttEnergy:
      begin
        cbCBUDG.Caption := 'Print fluid mass and energy budgets';
      end;
    ttSolute:
      begin
        cbCBUDG.Caption := 'Print fluid mass and solute budgets';
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
  if comboISSFLO.ItemIndex = 0 then
  begin
    comboISSTRA.ItemIndex := 0;
  end;
  EnableTemporalControls;
  EnableComp;
end;

procedure TfrmSutra.rgPressureSolverClick(Sender: TObject);
begin
  inherited;
  if rgPressureSolver.ItemIndex = 0 then
  begin
    rgTransportSolver.ItemIndex := 0;
  end
  else if rgTransportSolver.ItemIndex = 0 then
  begin
    rgTransportSolver.ItemIndex := 1;
  end;
  adeITRMXP.Enabled := rgPressureSolver.ItemIndex > 0;
  adeITOLP.Enabled := rgPressureSolver.ItemIndex > 0;
  adeTOLP.Enabled := rgPressureSolver.ItemIndex > 0;
  adeNSAVEP.Enabled := rgPressureSolver.ItemIndex > 1;
end;

procedure TfrmSutra.rgTransportSolverClick(Sender: TObject);
begin
  inherited;
  if rgTransportSolver.ItemIndex = 0 then
  begin
    rgPressureSolver.ItemIndex := 0;
  end
  else if rgPressureSolver.ItemIndex = 0 then
  begin
    rgPressureSolver.ItemIndex := 1;
  end;
  adeITRMXU.Enabled := rgTransportSolver.ItemIndex > 0;
  adeITOLU.Enabled := rgTransportSolver.ItemIndex > 0;
  adeTOLU.Enabled := rgTransportSolver.ItemIndex > 0;
  adeNSAVEU.Enabled := rgTransportSolver.ItemIndex > 0;
end;

procedure TfrmSutra.SetGeoGridHeaders;
var
  Index : integer;
begin
  inherited;
  sgGeology.Cells[0,0] := 'Unit number';
  sgGeology.Cells[1,0] := 'Name';
  sgGeology.Cells[2,0] := 'Discretization';
  for Index := 1 to sgGeology.RowCount -1 do
  begin
    sgGeology.Cells[0,Index] := FloatToStr(Index);
  end;

end;

procedure TfrmSutra.InitializeGeoGrid;
var
  Index : integer;
begin
  inherited;
  SetGeoGridHeaders;
  for Index := 1 to sgGeology.RowCount -1 do
  begin
    sgGeology.Cells[1,Index] := 'Unit' + FloatToStr(Index);
    sgGeology.Cells[2,Index] := '1';
  end;

end;

procedure TfrmSutra.adeVertDiscExit(Sender: TObject);
var
  NewNumberOfUnits : integer;
  RowIndex{, {ColIndex, RowIndex2} : integer;
  ALayerList : T_ANE_IndexedLayerList;
  MeshLayer : T_ANE_QuadMeshLayer;
  AParameterList : T_ANE_IndexedParameterList;
begin
  inherited;
  if is3D then
  begin
    if Loading then
    begin
      OldNumberOfUnits := 0;
    end;
    NewNumberOfUnits := StrToInt(adeVertDisc.Text);

    MeshLayer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
      (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

    if OldNumberOfUnits > NewNumberOfUnits then
    begin
      sgGeology.RowCount := NewNumberOfUnits + 1;
      if Sender <> btnDelete then
      begin
        for RowIndex := OldNumberOfUnits-1 downto NewNumberOfUnits do
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
      for RowIndex := OldNumberOfUnits + 1 to NewNumberOfUnits do
      begin
{        if RowIndex = 1 then
        begin
          RowIndex2 := 1;
        end
        else
        begin
          RowIndex2 := RowIndex-1;
        end;  }
        if not Loading and not cancelling then
        begin
{          for ColIndex := 2 to sgGeology.ColCount -1 do
          begin
            sgGeology.Cells[ColIndex, RowIndex]
              := sgGeology.Cells[ColIndex, RowIndex2]
          end;  }
          sgGeology.Cells[1, RowIndex] := GetUnitName(
            'Unit' + IntToStr(RowIndex),RowIndex);
          sgGeology.Cells[2, RowIndex] := '1';
        end;
      end;

      for RowIndex := OldNumberOfUnits to NewNumberOfUnits  do
      begin
        if Sender <> btnInsert then
        begin
          if SutraLayerStructure.ListsOfIndexedLayers.Count > RowIndex then
          begin
            ALayerList := SutraLayerStructure.ListsOfIndexedLayers.Items[RowIndex];
            ALayerList.UnDeleteSelf;
          end
          else
          begin
            TSutraGeoUnit.Create(SutraLayerStructure.ListsOfIndexedLayers, -1 );
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
              TSutraNodeLayerParameters.Create(MeshLayer.IndexedParamList1, -1 )
            end;
          end;
        end;
      end;
    end;
    // Other stuff here

    SetGeoGridHeaders;
    btnDelete.Enabled := NewNumberOfUnits > 1;

    sgGeologySetEditText(Sender, Ord(ghDiscretization), sgGeology.RowCount -1,
      sgGeology.Cells[Ord(ghDiscretization), sgGeology.RowCount -1]);

    GetNodeAndElementCounts;
    sgGeology.Invalidate;
  end;

end;

procedure TfrmSutra.sgGeologySetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  CellValue : integer;
begin
  inherited;
  if (ACol = Ord(ghDiscretization)) and (ARow >= sgGeology.FixedRows) then
  begin
    try
      if sgGeology.Cells[ACol, ARow] <> '' then
      begin
        CellValue := StrToInt(sgGeology.Cells[ACol, ARow]);
        {if (ARow = sgGeology.RowCount -1) and (CellValue <> 1) then
        begin
          if not loading and not cancelling  then
          begin
            Beep;
          end;
          sgGeology.Cells[ACol, ARow] := '1';
        end
        else }
        if CellValue < 1 then
        begin
          if not loading and not cancelling  then
          begin
            Beep;
          end;
          sgGeology.Cells[ACol, ARow] := '1';
        end;
        GetNodeAndElementCounts;
      end;
    except on EConvertError Do
      begin
        if not loading and not cancelling then
        begin
          Beep;
        end;
        sgGeology.Cells[ACol, ARow] := OldVertDiscretization;
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
  adeVertDisc.Text := IntToStr(1+StrToInt(adeVertDisc.Text));
  adeVertDiscExit(Sender);
end;

procedure TfrmSutra.sgGeologyDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if (ARow > 0) and (ACol > 0) then
  begin
    if (ARow = sgGeology.Selection.Top)then
    begin
      sgGeology.Canvas.Brush.Color := clAqua;
    end
    else
    begin
      sgGeology.Canvas.Brush.Color := clWindow;
    end;
    // set the font color
    sgGeology.Canvas.Font.Color := clBlack;
    // draw the text
    sgGeology.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgGeology.Cells[ACol,ARow]);
    // draw the right and lower cell boundaries in black.
    sgGeology.Canvas.Pen.Color := clBlack;
    sgGeology.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgGeology.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgGeology.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

procedure TfrmSutra.btnDeleteClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  ALayerList : T_ANE_IndexedLayerList;
  MeshLayer : T_ANE_QuadMeshLayer;
  AParameterList : T_ANE_IndexedParameterList;
begin
  inherited;
  // get the currently selected fow.
  CurrentRow := sgGeology.Selection.Top;

  ALayerList := SutraLayerStructure.ListsOfIndexedLayers.
    GetNonDeletedIndLayerListByIndex(CurrentRow-1);
  ALayerList.DeleteSelf;

  MeshLayer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
    (TSutraMeshLayer.ANE_LayerName) as T_ANE_QuadMeshLayer;

  if MeshLayer <> nil then
  begin
    AParameterList := MeshLayer.IndexedParamList1.
      GetNonDeletedIndParameterListByIndex(CurrentRow-1);
    if AParameterList <> nil then
    begin
      AParameterList.DeleteSelf;
    end;
  end;


  // If a row is selected in dtabGeol, proceed
  if CurrentRow >= 0 then
  begin


    // Delete the geologic unit associated with the row that was just removed.
  //    DeleteGeologicLayer(CurrentRow-1);

    // Copy data in sgMOC3DTransParam to their new positions.
    for RowIndex := CurrentRow +1 to sgGeology.RowCount -1 do
    begin
      For ColIndex := 1 to sgGeology.ColCount -1 do
      begin
        sgGeology.Cells[ColIndex,RowIndex-1]
          := sgGeology.Cells[ColIndex,RowIndex];
      end;
    end;
  end;
  adeVertDiscEnter(Sender);
  adeVertDisc.Text := IntToStr(StrToInt(adeVertDisc.Text)-1);
  adeVertDiscExit(Sender);
  sgGeology.Invalidate;
end;

procedure TfrmSutra.btnInsertClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  PositionToInsert : integer;
  ALayerList : T_ANE_IndexedLayerList;
  MeshLayer : T_ANE_QuadMeshLayer;
//  UnitName : String;
//  AChar : Char;
//  NameSet : boolean;
begin
  inherited;
  btnAddClick(Sender);
  CurrentRow := sgGeology.Selection.Top;

  ALayerList := SutraLayerStructure.ListsOfIndexedLayers.
    GetNonDeletedIndLayerListByIndex(CurrentRow-1);
  PositionToInsert := SutraLayerStructure.ListsOfIndexedLayers.
    IndexOf(ALayerList);
  TSutraGeoUnit.Create(SutraLayerStructure.ListsOfIndexedLayers,
    PositionToInsert);

  MeshLayer := SutraLayerStructure.UnIndexedLayers.GetLayerByName
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
    for RowIndex := sgGeology.RowCount -2 downto CurrentRow do
    begin
      // number the first column
      sgGeology.Cells[0,RowIndex] := IntToStr(RowIndex);
      // copy data to latter row.
      for ColIndex := 1 to sgGeology.ColCount -1 do
      begin
        sgGeology.Cells[ColIndex,RowIndex +1] := sgGeology.Cells[ColIndex,RowIndex];
      end;
    end;
  end;
  sgGeology.Cells[1,CurrentRow] := GetUnitName('Unit' + IntToStr(CurrentRow),CurrentRow);
{  if TestUnitName(UnitName,CurrentRow) then
  begin
    sgGeology.Cells[1,CurrentRow] := UnitName;
  end
  else
  begin
    NameSet := False;
    for AChar := 'a' to 'z' do
    begin
      if TestUnitName(UnitName+AChar,CurrentRow) then
      begin
        sgGeology.Cells[1,CurrentRow] := UnitName+AChar;
        NameSet := True;
        Break;
      end
    end;
    if not NameSet then
    begin
      for AChar := 'A' to 'Z' do
      begin
        if TestUnitName(UnitName+AChar,CurrentRow) then
        begin
          sgGeology.Cells[1,CurrentRow] := UnitName+AChar;
          NameSet := True;
          Break;
        end
      end;
    end;
    if not NameSet then
    begin
      sgGeology.Cells[1,CurrentRow] := UnitName;
    end;
  end;  }

  sgGeology.Cells[2,CurrentRow] := '1';
  sgGeology.Invalidate;
end;

procedure TfrmSutra.rb3D_nvaClick(Sender: TObject);
var
  Index : integer;
  ALayerList : T_ANE_IndexedLayerList;
  ShouldEnable : boolean;
begin
  inherited;
  {$IFNDEF Sutra2d}
{  if not Loading and not Cancelling then
  begin
    if rbAreal.Checked or rbCrossSection.Checked then
    begin
      rgDimensions.ItemIndex := 0;
    end
    else
    begin
      rgDimensions.ItemIndex := 1;
    end;
  end;     }
  {$ENDIF}

  if (Sender <> rbGeneral) and (Sender <> rbSpecific) then
  begin
    EnableGravControls;
  end;

  ShouldEnable :=  Is3D or rbGeneral.Checked
    or (rbSpecific.Checked and not rbAreal.Checked);

  EnableTransportConditionControls;

{  rbEnergy.Enabled := ShouldEnable;

  if rbEnergy.Checked and not rbEnergy.Enabled and not Loading and not Cancelling then
  begin
    rbSoluteConstDens.Checked := True;
  end;  }

  rbIrregular.Enabled := not Is3d;
  if not rbIrregular.Enabled then
  begin
    rbFishnet.Checked;
  end;

{  rgMeshType.Enabled := rbGeneral.Checked or (rbSpecific.Checked
    and (rbCrossSection.Checked or rbAreal.Checked));
  if not rgMeshType.Enabled and not Loading and not Cancelling then
  begin
    rgMeshType.ItemIndex := 0;
  end;  }

  if Is3D then
  begin
//    adeBoundLayerCount.Enabled := True;
    rbSatUnsat.Enabled := ShouldEnable;

{    if StrToInt(adeBoundLayerCount.Text) <= 0 then
    begin
      adeBoundLayerCountEnter(Sender);
      adeBoundLayerCount.Text := '1';
      adeBoundLayerCountExit(Sender);
    end;
    adeBoundLayerCount.Min := 1; }
  end;


  if (dimensions = sd2d) and not Loading and not cancelling and Is3D then
  begin
    for Index := 0 to StrToInt(adeVertDisc.Text) do
    begin
      if SutraLayerStructure.ListsOfIndexedLayers.Count > Index then
      begin
        ALayerList := SutraLayerStructure.ListsOfIndexedLayers.Items[Index];
        ALayerList.UnDeleteSelf
      end
      else
      begin
        TSutraGeoUnit.Create(SutraLayerStructure.ListsOfIndexedLayers,-1);
      end; 
    end;
  end;

  dimensions := sd3d;
  tabVertDisc.TabVisible := Is3D;

  if not cancelling then
  begin
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
      (TSutraMorphMeshLayer, MorphedMesh);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
      (TSutraMeshLayer, MorphedMesh);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
      (TFishnetMeshLayout, rbGeneral.Checked
        or rbFishnet.Checked);
  {  SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
      (TSutraDomainOutline, MorphedMesh);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
      (TSutraMeshDensity, MorphedMesh);  }



  {  SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TFluidSourcesLayer, TTopElevaParam, Is3D);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TFluidSourcesLayer, TBottomElevaParam, Is3D);
  {  SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TFluidSourcesLayer, TIs3DSurfaceParam, rbGeneral.Checked or
        (rbSpecific.Checked and
        (rb3D_va.Checked or rb3D_nva.Checked)));}

  {  SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSoluteEnergySourcesLayer, TTopElevaParam, Is3D);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSoluteEnergySourcesLayer, TBottomElevaParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSpecConcTempLayer, TTopElevaParam, Is3D);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSpecConcTempLayer, TBottomElevaParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSpecifiedPressureLayer, TTopElevaParam, Is3D);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSpecifiedPressureLayer, TBottomElevaParam, Is3D);  }

  {  SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSpecConcTempLayer, TTopElevaParam, Is3D);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TSpecConcTempLayer, TBottomElevaParam, Is3D); }

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TObservationLayer, TTopElevaParam, Is3D);
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TObservationLayer, TBottomElevaParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TPermeabilityLayer, TMidPermeabilityParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TPermeabilityLayer, THorizPermeabilityAngleParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TPermeabilityLayer, TVertPermeabilityAngleParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TPermeabilityLayer, TRotPermeabilityAngleParam, Is3D);

  {
    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TPermeabilityLayer, TPermeabilityAngleParam, not Is3D);
  }


    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TDispersivityLayer, TMidLongDispParam, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TDispersivityLayer, TMidTransDisp1Param, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TDispersivityLayer, TMaxTransDisp2Param, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TDispersivityLayer, TMidTransDisp2Param, Is3D);

    SutraLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
      (TDispersivityLayer, TMinTransDisp2Param, Is3D);
  end;

  AddOrRemoveLayers;
  AddOrRemoveParameters;

  SetDefaults;
end;

function TfrmSutra.MakeVirtualMesh : boolean;
var
  Discretization: TIntegerList;
  Index : integer;
begin
  result := True;
  try
    Discretization := TIntegerList.Create;
    try
      for Index := 1 to sgGeology.RowCount -1 do
      begin
        Discretization.Add(StrToInt(sgGeology.Cells
          [Ord(ghDiscretization),Index]));
      end;
      Discretization.Add(1);

      if rbGeneral.Checked or MorphedMesh then
      begin
        MorphMesh := T3DMorphMesh.Create(CurrentModelHandle,
          StrToInt(adeVertDisc.Text)+1);
      end
      else
      begin
        MorphMesh := nil;
      end;

      VirtualMesh := TVirtual3DMesh.Create(CurrentModelHandle,Discretization,
        MorphMesh);
    finally
      Discretization.Free;
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

function TfrmSutra.FreeVirtualMesh : boolean;
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

function TfrmSutra.ParsePorosity : boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPORParam.WriteParamName,pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.GetMorphedNodeValue(NodeIndex : integer; Expression : string) : ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetMorphedNodeValue(CurrentModelHandle, NodeIndex, Expression);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.ParseInitialPressure : boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TPVECParam.WriteParamName,pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

function TfrmSutra.ParseInitialConcentration : boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, TUVECParam.WriteParamName,pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

{function TfrmSutra.GetInitialPressure(NodeIndex : integer) : ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetValue(NodeIndex);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end; }

function TfrmSutra.ParseFloatExpression(Expression : string): boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(CurrentModelHandle, Expression,pnFloat);
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
    VirtualMesh.ParseExpression(CurrentModelHandle, TPMAXParam.WriteParamName,pnFloat);
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
    VirtualMesh.ParseExpression(CurrentModelHandle, TPMINParam.WriteParamName,pnFloat);
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
    VirtualMesh.ParseExpression(CurrentModelHandle, TPMIDParam.WriteParamName,pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end;

{function TfrmSutra.ParseAngleX: boolean;
begin
  result := True;
  try
    VirtualMesh.ParseExpression(TPMINParam.WriteParamName,pnFloat);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
    end;
  end;
end; }

function TfrmSutra.GetMorphedElementValue(ElementIndex: integer;
  Expression : string): ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetMorphedElementValue(CurrentModelHandle, ElementIndex, Expression);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetMorphedElementAngleValue(ElementIndex: integer;
  Expression : string): ANE_DOUBLE;
begin
  result := 0;
  try
    result := VirtualMesh.GetMorphedElementAngleValue(CurrentModelHandle, ElementIndex, Expression);
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TfrmSutra.GetLayerCount: Integer;
var
  Index : integer;
begin
  try
    if dimensions = sd2d then
    begin
      result := 1;
    end
    else
    begin
      result := 0;
      for Index := 1 to sgGeology.RowCount -1 do
      begin
        if sgGeology.Cells[Ord(ghDiscretization),Index] <> '' then
        begin
          result := result + StrToInt(sgGeology.Cells[Ord(ghDiscretization),Index]);
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

function TfrmSutra.GetXValue(NodeIndex : integer) : ANE_DOUBLE;
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

function TfrmSutra.GetYValue(NodeIndex : integer) : ANE_DOUBLE;
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

function TfrmSutra.GetZValue(NodeIndex : integer) : ANE_DOUBLE;
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

procedure TfrmSutra.adeBoundLayerCountEnter(Sender: TObject);
begin
  inherited;
  BoundaryLayerCount := StrToInt(adeBoundLayerCount.Text);
end;

procedure TfrmSutra.adeBoundLayerCountExit(Sender: TObject);
var
  NewBoundaryLayerCount : integer;
  Index : integer;
  ALayerList : T_ANE_IndexedLayerList;
begin
  inherited;
  if is3D or loading or cancelling then
  begin
    NewBoundaryLayerCount := StrToInt(adeBoundLayerCount.Text);

    if NewBoundaryLayerCount > BoundaryLayerCount then
    begin
      for Index := BoundaryLayerCount + 1 to NewBoundaryLayerCount do
      begin
        if Index-1 < frmSutra.SutraLayerStructure.
          FirstListsOfIndexedLayers.Count  then
        begin
          ALayerList := frmSutra.SutraLayerStructure.
            FirstListsOfIndexedLayers.Items[Index-1];
          ALayerList.UnDeleteSelf;
        end
        else
        begin
          TBoundaryList.Create(frmSutra.SutraLayerStructure.
            FirstListsOfIndexedLayers, -1 )
        end;
      end;

    end
    else // if NewBoundaryLayerCount > BoundaryLayerCount then
    begin
      for  Index:= BoundaryLayerCount downto NewBoundaryLayerCount + 1 do
      begin
        if Index-1 < frmSutra.SutraLayerStructure.
          FirstListsOfIndexedLayers.Count then
        begin
          ALayerList := frmSutra.SutraLayerStructure.
            FirstListsOfIndexedLayers.Items[Index-1];
          ALayerList.DeleteSelf;
        end;
      end;

    end; // if NewBoundaryLayerCount > BoundaryLayerCount then else
  end; // if is3D then
end;

procedure TfrmSutra.sgGeologyExit(Sender: TObject);
var
  ACol : integer;
  ARow : integer;
  CellValue : integer;
begin
  inherited;
  ACol := Ord(ghDiscretization);
  for ARow := sgGeology.FixedRows to sgGeology.RowCount -1 do
  begin
    try
      begin
        CellValue := StrToInt(sgGeology.Cells[ACol, ARow]);
        if CellValue < 1 then
        begin
          sgGeology.Cells[ACol, ARow] := '1';
        end;
      end;
    except on EConvertError Do
      begin
        sgGeology.Cells[ACol, ARow] := OldVertDiscretization;
      end;
    end;
  end;

end;

function TfrmSutra.N(var MultipleUnits: Boolean; var MeshN : String): string;
begin
  if not Is3D then
  begin
    result := '';
    MultipleUnits := False;
    MeshN := ''
  end
  else
  begin
    if VerticallyAlignedMesh then
    begin
      MultipleUnits := True;
      result := IntToStr(StrToInt(adeVertDisc.Text)+1);
      MeshN := '';
    end
    else
    begin
      MultipleUnits := False;
      frmUnitNumber := TfrmUnitNumber.Create(Application);
      try
        frmUnitNumber.ShowModal;
        result := frmUnitNumber.N;
        MeshN := result;
      finally
        frmUnitNumber.Free;
      end;
    end;

  end;

end;

function TfrmSutra.GetN(var MultipleUnits : Boolean): string;
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
      result := IntToStr(StrToInt(adeVertDisc.Text) + 1);
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
  AnEdit : TEdit;
begin
  inherited;
  if Sender is TEdit then
  begin
    AnEdit := Sender as TEdit;
//    AnEdit.Text := '\"' + AnEdit.Text + '\"';
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

  // this fucntion extracts to PIE version number from the TVersionLabel
{  result := TVersionLabel(AControl).InfoString;
  Result := Copy(result, Length(verLabel.infoPrefix)+1,Length(result)); }

  result := TLabel(AControl).Caption;
end;

procedure TfrmSutra.AssignHelpFile(FileName : string) ;
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

function TfrmSutra.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  // triggering events: frmSutra.OnHelp;
  inherited;

  // This assigns the help file every time Help is called from frmSutra.
  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmSutra.
  AssignHelpFile('SUTRA GUI.hlp');
  if (Command = HELP_CONTEXTPOPUP) {and (Data = dgGeol.HelpContext)} then
  begin
    CallHelp := False;
    Application.HelpCommand(HELP_CONTEXT, Data);
  end ;
  result := True;
end;

procedure TfrmSutra.FormShow(Sender: TObject);
begin
  inherited;
  ShouldAskY := True;
  ShouldAskZ := True;
  if reProblem.Lines.Count > 0 then
  begin
    tabProblem.TabVisible := True;
    pgcontrlMain.ActivePage := tabProblem;
  end;
end;

procedure TfrmSutra.comboSIMULAChange(Sender: TObject);
begin
  inherited;
  SetSoluteHeatCaptions
end;

procedure TfrmSutra.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if frmSutra.ModalResult <> mrOK then
  begin
    Cancelling := True;
  end;
end;

function TfrmSutra.Is3D : boolean;
begin
  result := {(rbGeneral.Checked and} (rgDimensions.ItemIndex = 1){)
    or (rbSpecific.Checked and (rb3D_va.Checked or rb3D_nva.Checked))};
end;

function TfrmSutra.MorphedMesh : boolean;
begin
  result := Is3D and rb3D_nva.Checked;
end;

function TfrmSutra.VerticallyAlignedMesh : boolean;
begin
  result := Is3D and rb3D_va.Checked;
end;

procedure TfrmSutra.rgDimensionsClick(Sender: TObject);
var
//  Index : integer;
//  AComponent : TComponent;
  ThisIs3D : boolean;
begin
  inherited;
  ThisIs3D := Is3D;
{  for Index := 0 to ComponentCount -1 do
  begin
    AComponent := Components[Index];
    if AComponent is TFrmDefaultValue then
    begin
      TFrmDefaultValue(AComponent).btnSetValue.Enabled := ThisIs3D;
    end;
  end;  }

  adeThickness.Enabled := rgDimensions.ItemIndex = 0;
  {$IFNDEF Sutra2d}
  rbAreal.Enabled := rbSpecific.Checked and not ThisIs3D;
  rbCrossSection.Enabled := rbSpecific.Checked and not ThisIs3D;
  rb3D_va.Enabled := ThisIs3D;
  rb3D_nva.Enabled := ThisIs3D;
  {$ENDIF}

  if (rgDimensions.ItemIndex = 1 ) then
  begin // 3D
    rbFishnet.Caption := 'FISHNET (a deformable grid of hexahedrals)';
    rbUserSpecifiedThickness.Enabled := False;
    rbCylindrical.Enabled := False;
    rbIrregular.Enabled := False;
    lblGRAVZ.Visible := True;
    adeGRAVZ.Visible := True;
    lblGRAVZCaption.Visible := True;
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
  end;

  UpdateBoundaryLayerCount(Sender);

  EnableTransportConditionControls;

{  rbSoluteConstDens.Enabled := rbSpecific.Checked and rbAreal.Checked
    and (rgDimensions.ItemIndex = 0);

  if not rbSoluteConstDens.Enabled and rbSoluteConstDens.Checked
    and not Loading and not Cancelling then
  begin
    rbSoluteVarDens.Checked := True;
  end;

  rbSoluteVarDens.Enabled := Is3D or (rbSpecific.Checked and rbCrossSection.Checked);
  if not rbSoluteVarDens.Enabled and rbSoluteVarDens.Checked
    and not Loading and not Cancelling then
  begin
    rbSoluteConstDens.Checked := True;
  end;

  rbEnergy.Enabled := Is3D or (rbSpecific.Checked and rbCrossSection.Checked);
  if not rbEnergy.Enabled and rbEnergy.Checked
    and not Loading and not Cancelling then
  begin
    rbSoluteConstDens.Checked := True;
  end;    }

  if not rbIrregular.Enabled and rbIrregular.Checked
    and not Loading and not Cancelling then
  begin
    rbFishnet.Checked := True;
  end;

{  if (rgDimensions.ItemIndex = 1 )
    and not rb3D_va.Checked and not rb3D_nva.Checked then
  begin
    if not Loading and not Cancelling then
    begin
      rb3D_va.Checked := True;
    end;
  end
  else
  begin
    rb3D_nvaClick(Sender);
    if (rgDimensions.ItemIndex = 0 ) and
      (not (rbAreal.Checked or rbCrossSection.Checked)) then
    begin
      if not Loading and not Cancelling then
      begin
        rbAreal.Checked := True;
      end;
    end;
  end;   }
  if (rgDimensions.ItemIndex = 1 ) and not Loading and not Cancelling then
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


  if (rgDimensions.ItemIndex = 1 ) then
  begin
    rb3D_nvaClick(Sender);
  end
  else
  begin
    rbArealClick(Sender);
  end;

  tabInitial3D.TabVisible := ThisIs3D;

  SetDefaults;
  SetTitles;
end;

procedure TfrmSutra.SetTitles;
const
  LabelWidth = 353;
var
  ThisIs3D : boolean;
begin
  ThisIs3D := Is3D;
  if ThisIs3D then
  begin
    if StateVariableType = svPressure then
    begin
      FramTransvDispMax.lblParameterName.Caption :=
        'Transverse Dispersivity 1 in maximum permeabilty direction';
      FramTransvDispMax.lblParameterName.Width := LabelWidth;

      FramTransvDispMin.lblParameterName.Caption :=
        'Transverse Dispersivity 1 in minimum permeabilty direction';
      FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end
    else
    begin
      FramTransvDispMax.lblParameterName.Caption :=
        'Transverse Dispersivity 1 in maximum hydraulic conductivity direction';
      FramTransvDispMax.lblParameterName.Width := LabelWidth;

      FramTransvDispMin.lblParameterName.Caption :=
        'Transverse Dispersivity 1 in minimum  hydraulic conductivity direction';
      FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end;
  end
  else
  begin
    if StateVariableType = svPressure then
    begin
      FramTransvDispMax.lblParameterName.Caption :=
        'Transverse Dispersivity in maximum permeabilty direction';
      FramTransvDispMax.lblParameterName.Width := LabelWidth;

      FramTransvDispMin.lblParameterName.Caption :=
        'Transverse Dispersivity in minimum permeabilty direction';
      FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end
    else
    begin
      FramTransvDispMax.lblParameterName.Caption :=
        'Transverse Dispersivity in maximum hydraulic conductivity direction';
      FramTransvDispMax.lblParameterName.Width := LabelWidth;

      FramTransvDispMin.lblParameterName.Caption :=
        'Transverse Dispersivity in minimum hydraulic conductivity direction';
      FramTransvDispMin.lblParameterName.Width := LabelWidth;
    end;
  end;
  if StateVariableType = svPressure then
  begin
    FramDMaxHydCond.lblParameterName.Caption := 'Maximum Permeability';
    FramDMaxHydCond.lblParameterName.Width := LabelWidth;

    FramDMinHydCond.lblParameterName.Caption := 'Minimum Permeability';
    FramDMinHydCond.lblParameterName.Width := LabelWidth;

    FramPermAngleXY.lblParameterName.Caption := 'Permeability Angle';
    FramPermAngleXY.lblParameterName.Width := LabelWidth;

    FramPermAngleVertical.lblParameterName.Caption := 'Vertical Permeability Angle';
    FramPermAngleVertical.lblParameterName.Width := LabelWidth;

    FramPermAngleRotational.lblParameterName.Caption := 'Rotational Permeability Angle';
    FramPermAngleRotational.lblParameterName.Width := LabelWidth;

    FramDMidHydCond.lblParameterName.Caption := 'Middle Permeability';
    FramDMidHydCond.lblParameterName.Width := LabelWidth;

    FramLongDispMax.lblParameterName.Caption :=
      'Longitudinal Dispersivity in maximum permeabilty direction';
    FramLongDispMax.lblParameterName.Width := LabelWidth;

    FramLongDispMin.lblParameterName.Caption :=
      'Longitudinal Dispersivity in minimum permeabilty direction';
    FramLongDispMin.lblParameterName.Width := LabelWidth;

    FramLongDispMid.lblParameterName.Caption :=
      'Longitudinal Dispersivity in middle permeabilty direction';
    FramLongDispMid.lblParameterName.Width := LabelWidth;

    FramTransvDisp1Mid.lblParameterName.Caption :=
      'Transverse Dispersivity 1 in middle permeabilty direction';
    FramTransvDisp1Mid.lblParameterName.Width := LabelWidth;

    FramTransvDisp2Max.lblParameterName.Caption :=
      'Transverse Dispersivity 2 in maximum permeabilty direction';
    FramTransvDisp2Max.lblParameterName.Width := LabelWidth;

    FramTransvDisp2Mid.lblParameterName.Caption :=
      'Transverse Dispersivity 2 in middle permeabilty direction';
    FramTransvDisp2Mid.lblParameterName.Width := LabelWidth;

    FramTransvDisp2Min.lblParameterName.Caption :=
      'Transverse Dispersivity 2 in minimum permeabilty direction';
    FramTransvDisp2Min.lblParameterName.Width := LabelWidth;
  end
  else
  begin
    FramDMaxHydCond.lblParameterName.Caption := 'Maximum Hydraulic Conductivity';
    FramDMaxHydCond.lblParameterName.Width := LabelWidth;

    FramDMinHydCond.lblParameterName.Caption := 'Minimum Hydraulic Conductivity';
    FramDMinHydCond.lblParameterName.Width := LabelWidth;

    FramPermAngleXY.lblParameterName.Caption := 'Hydraulic Conductivity Angle';
    FramPermAngleXY.lblParameterName.Width := LabelWidth;

    FramPermAngleVertical.lblParameterName.Caption := 'Vertical Hydraulic Conductivity Angle';
    FramPermAngleVertical.lblParameterName.Width := LabelWidth;

    FramPermAngleRotational.lblParameterName.Caption := 'Rotational Hydraulic Conductivity Angle';
    FramPermAngleRotational.lblParameterName.Width := LabelWidth;

    FramDMidHydCond.lblParameterName.Caption := 'Middle Hydraulic Conductivity';
    FramDMidHydCond.lblParameterName.Width := LabelWidth;

    FramLongDispMax.lblParameterName.Caption :=
      'Longitudinal Dispersivity in maximum hydraulic conductivity direction';
    FramLongDispMax.lblParameterName.Width := LabelWidth;

    FramLongDispMin.lblParameterName.Caption :=
      'Longitudinal Dispersivity in minimum hydraulic conductivity direction';
    FramLongDispMin.lblParameterName.Width := LabelWidth;

    FramLongDispMid.lblParameterName.Caption :=
      'Longitudinal Dispersivity in middle hydraulic conductivity direction';
    FramLongDispMid.lblParameterName.Width := LabelWidth;

    FramTransvDisp1Mid.lblParameterName.Caption :=
      'Transverse Dispersivity 1 in middle hydraulic conductivity direction';
    FramTransvDisp1Mid.lblParameterName.Width := LabelWidth;

    FramTransvDisp2Max.lblParameterName.Caption :=
      'Transverse Dispersivity 2 in maximum hydraulic conductivity direction';
    FramTransvDisp2Max.lblParameterName.Width := LabelWidth;

    FramTransvDisp2Mid.lblParameterName.Caption :=
      'Transverse Dispersivity 2 in middle hydraulic conductivity direction';
    FramTransvDisp2Mid.lblParameterName.Width := LabelWidth;

    FramTransvDisp2Min.lblParameterName.Caption :=
      'Transverse Dispersivity 2 in minimum hydraulic conductivity direction';
    FramTransvDisp2Min.lblParameterName.Width := LabelWidth;
  end;

end;

procedure TfrmSutra.FixRealsOnExit(Sender: TObject);
var
  AnArgusDataEntry : TArgusDataEntry;
begin
  inherited;
  AnArgusDataEntry := Sender as TArgusDataEntry;
  if (Pos('.',AnArgusDataEntry.Text) = 0) and
     (Pos('e',AnArgusDataEntry.Text) = 0) and
     (Pos('E',AnArgusDataEntry.Text) = 0) then
  begin
    AnArgusDataEntry.Text := AnArgusDataEntry.Text + '.';
  end;
end;

procedure TfrmSutra.cbNodeElementNumbersClick(Sender: TObject);
begin
  inherited;
  if cbNodeElementNumbers.Checked then
  begin
    MessageDlg('Note: SutraViewer requires that node and element numbers NOT '
      + 'be printed in the .nod and .ele files.', mtInformation, [mbOK], 0);
  end;
end;

procedure TfrmSutra.AdjustInitPerm;
begin
  SetTitles;
  if StateVariableType = svPressure then
  begin
    if FramDMaxHydCond.adeProperty.Text = '1.0E-3' then
    begin
      FramDMaxHydCond.adeProperty.Text := '1.0E-10'
    end;
    if FramDMinHydCond.adeProperty.Text = '1.0E-3' then
    begin
      FramDMinHydCond.adeProperty.Text := '1.0E-10'
    end;
  end
  else
  begin
    if FramDMaxHydCond.adeProperty.Text = '1.0E-10' then
    begin
      FramDMaxHydCond.adeProperty.Text := '1.0E-3'
    end;
    if FramDMinHydCond.adeProperty.Text = '1.0E-10' then
    begin
      FramDMinHydCond.adeProperty.Text := '1.0E-3'
    end;
  end;
end;


procedure TfrmSutra.sgGeologySelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  sgGeology.Invalidate;
end;

procedure TfrmSutra.rbFishnetClick(Sender: TObject);
begin
  inherited;
  AddOrRemoveLayers;
end;

procedure TfrmSutra.ReadOldNPCYC(var LineIndex : integer; FirstList,
    IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  DataToRead[LineIndex] := IntToStr(Round(StrToFloat(DataToRead[LineIndex])));
  ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, adeNPCYC, DataToRead,
    VersionControl)
end;

procedure TfrmSutra.ReadOldNUCYC(var LineIndex : integer; FirstList,
    IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  DataToRead[LineIndex] := IntToStr(Round(StrToFloat(DataToRead[LineIndex])));
  ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, adeNUCYC, DataToRead,
    VersionControl)
end;

procedure TfrmSutra.ReadOldFishnet(var LineIndex : integer; FirstList,
    IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
var
  ARadioButton : TRadioButton;
  AText : string;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ARadioButton := rbIrregular;
  if not (ARadioButton = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(ARadioButton.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(ARadioButton.Name) = -1))
  then
  begin
    if Assigned(ARadioButton.OnEnter) then
    begin
      ARadioButton.OnEnter(ARadioButton);
    end;
    if AText = '0'
    then
        begin
          ARadioButton.Checked := False;
        end
    else
        begin
          ARadioButton.Checked := True;
        end ;
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
//  rbSoluteConstDens.Enabled := not Is3D and rbSpecific.Checked and rbAreal.Checked;
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
  if not rbEnergy.Enabled and rbEnergy.Checked
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

procedure TfrmSutra.UpdateBoundaryLayerCount(Sender : TObject);
begin
  if (rgDimensions.ItemIndex = 1 ) then
  begin // 3D
    adeBoundLayerCount.Enabled := True;
    if StrToInt(adeBoundLayerCount.Text) < 1 then
    begin
      adeBoundLayerCountEnter(Sender);
      adeBoundLayerCount.Text := '1';
      adeBoundLayerCountExit(Sender);
    end;
    adeBoundLayerCount.Min := 1;
  end
  else
  begin // 2D
    adeBoundLayerCount.Min := 0;
    adeBoundLayerCount.Enabled := False;
    if StrToInt(adeBoundLayerCount.Text) <> 0 then
    begin
      adeBoundLayerCountEnter(Sender);
      adeBoundLayerCount.Text := '0';
      adeBoundLayerCountExit(Sender);
    end;
  end;
end;

procedure TfrmSutra.btnOKClick(Sender: TObject);
begin
  inherited;
  UpdateExpressions;
  if rbSpecific.Checked and not (rbAreal.Checked or rbCrossSection.Checked
    or rb3D_va.Checked or rb3D_nva.Checked) then
  begin
    Beep;
    pgcontrlMain.ActivePage := tabConfiguration;
    MessageDlg('You forgot to choose the orientation of the model. You need '
      + 'to make a choice before closing this dialog box.', mtWarning, [mbOK], 0);

    ModalResult := mrNone;
  end;
end;

procedure TfrmSutra.SetDefaults;
begin
  if not Loading and not Cancelling then
  begin
    if rbGeneral.Checked then
    begin

    end
    else
    begin
      if rbSoluteVarDens.Checked then
      begin
        adeSIGMAW.Text := '1.0e-9';
        adeRHOW0.Text := '1000';
        adeDRWDU.Text := '700';
        adeVISC0.Text := '0.001';
        if Is3D then
        begin
          adeGRAVZ.Text := '-9.81';
          adeGRAVY.Text := '0';
        end
        else
        begin
          adeGRAVY.Text := '-9.81';
        end;
      end
      else if rbSoluteConstDens.Checked then
      begin
        adeSIGMAW.Text := '1.0e-9';
        adeRHOW0.Text := '1';
        adeGRAVX.Text := '0';
        adeGRAVY.Text := '0';
        adeGRAVZ.Text := '0';
      end
      else if rbEnergy.Checked then
      begin
        adeCW.Text := '4182';
        adeSIGMAW.Text := '0';
        adeSIGMAW.Text := '0';
        adeRHOW0.Text := '1000';
        adeURHOW0.Text := '20';
        adeDRWDU.Text := '-0.375';
        adeCS.Text := '840';
        adeSIGMAS.Text := '3.5';
        if Is3D then
        begin
          adeGRAVY.Text := '0';
          adeGRAVZ.Text := '-9.81';
        end
        else
        begin
          adeGRAVY.Text := '-9.81';
        end;
      end;
      if rbSatUnsat.Checked then
      begin
        comboIUNSAT.ItemIndex := 1;
        comboISSFLO.ItemIndex := 0;
        comboISSFLO.ItemIndex := 0;
        adeITRMAX.Text := '2';
      end
      else if rbSat.Checked then
      begin
        comboIUNSAT.ItemIndex := 0;
      end;
    end;
  end;
end;

procedure TfrmSutra.comboIUNSATChange(Sender: TObject);
begin
  inherited;
  if not loading and not cancelling then
  begin
    if comboIUNSAT.ItemIndex = 0 then
    begin
      if not rbSat.Checked then
      begin
        rbSat.Checked := True;
        rbSatUnsatClick(Sender);
      end;
    end
    else
    begin
      if not rbSatUnsat.Checked then
      begin
        rbSatUnsat.Checked := True;
        rbSatUnsatClick(Sender);
      end;
    end;
  end;
end;

procedure TfrmSutra.EnableComp;
var
  ShouldEnable : boolean;
begin
  ShouldEnable := (comboISSFLO.ItemIndex = 0);
  adeCOMPFL.Enabled := ShouldEnable;
  adeCOMPMA.Enabled := ShouldEnable;
end;

function TfrmSutra.TestUnitName(ProposedName : string;
  CurrentRow : integer) : boolean;
var
  RowIndex : integer;
begin
  result := True;
  for RowIndex := 1 to sgGeology.RowCount -1 do
  begin
    if (RowIndex <> CurrentRow) and
      (sgGeology.Cells[1,RowIndex] = ProposedName) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TfrmSutra.GetUnitName(ProposedName : string;
  CurrentRow : integer) : String;
var
//  NameSet : boolean;
  AChar : Char;
begin
  if TestUnitName(ProposedName,CurrentRow) then
  begin
    result := ProposedName;
    Exit;
  end
  else
  begin
    for AChar := 'a' to 'z' do
    begin
      if TestUnitName(ProposedName+AChar,CurrentRow) then
      begin
        result := ProposedName+AChar;
        Exit;
      end
    end;

    for AChar := 'A' to 'Z' do
    begin
      if TestUnitName(ProposedName+AChar,CurrentRow) then
      begin
        result := ProposedName+AChar;
        Exit;
      end
    end;
    result := ProposedName;
  end;
end;

procedure TfrmSutra.GetLayerNodeAndElementCounts;
var
  SutraMeshLayer : T_ANE_MapsLayer;
  MeshLayerHandle : ANE_PTR;
  LayerOptions: TLayerOptions;
begin
  if SutraLayerStructure <> nil then
  begin
    SutraMeshLayer := nil;
    if VerticallyAlignedMesh then
    begin
      SutraMeshLayer := SutraLayerStructure.UnIndexedLayers.
        GetLayerByName(TSutraMeshLayer.ANE_LayerName);
    end
    else if MorphedMesh
      and (SutraLayerStructure.ListsOfIndexedLayers.Count > 0) then
    begin
      SutraMeshLayer := SutraLayerStructure.ListsOfIndexedLayers.
        Items[0].GetLayerByName(TSutraMeshLayer.ANE_LayerName);
    end;
    if SutraMeshLayer <> nil then
    begin
      MeshLayerHandle := SutraMeshLayer.GetLayerHandle(CurrentModelHandle);
      LayerOptions := TLayerOptions.Create(MeshLayerHandle);
      try
        ElementCount := LayerOptions.NumObjects(CurrentModelHandle,pieElementObject);
        NodeCount := LayerOptions.NumObjects(CurrentModelHandle,pieNodeObject);
      finally
        LayerOptions.Free(CurrentModelHandle);
      end;
      GetNodeAndElementCounts;
    end;
  end;

end;

procedure TfrmSutra.GetNodeAndElementCounts;
var
  LayerCount : integer;
  ElementN, NodeN : integer;
begin
  LayerCount:= GetLayerCount;
  ElementN := (LayerCount-1)*ElementCount;
  NodeN := LayerCount*NodeCount;
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
  Index : integer;
  AFrmDefaultValue : TFrmDefaultValue;
begin
  FNewProject := AValue;
  for Index := 0 to ComponentCount -1 do
  begin
    if Components[Index] is TFrmDefaultValue then
    begin
      AFrmDefaultValue := Components[Index] as TFrmDefaultValue;
      AFrmDefaultValue.btnSetValue.Enabled := not AValue;
    end;
  end;

end;

procedure TfrmSutra.FramPorbtnSetValueClick(Sender: TObject);
begin
  inherited;
  FramPor.btnSetValueClick(Sender);

end;

procedure TfrmSutra.btnRestartFileClick(Sender: TObject);
begin
  inherited;
  OpenDialog1.Filter := 'restart files (*.rst)|*.rst|All Files (*.*)|*.*';
  OpenDialog1.FileName := edRestartFile.Text;
  if OpenDialog1.Execute then
  begin
    edRestartFile.Text := OpenDialog1.FileName;
  end;

end;

procedure TfrmSutra.rgInitialValuesClick(Sender: TObject);
begin
  inherited;
  edRestartFile.Enabled := rgInitialValues.ItemIndex > 0;
  btnRestartFile.Enabled := edRestartFile.Enabled;
  if not Loading and not Cancelling then
  begin
    if btnRestartFile.Enabled and not FileExists(edRestartFile.Text) then
    begin
      btnRestartFileClick(Sender);
    end;
  end;
end;

end.
