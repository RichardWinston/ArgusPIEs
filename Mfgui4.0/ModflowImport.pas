unit ModflowImport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, DataGrid, ArgusDataEntry,
  IntListUnit, addbtn95, Contnrs, Import, Math, AnePIE,
  ArgusFormUnit, Variables, ANE_LayerUnit, clipbrd, MF2K_Importer;

type
  TDoubleArray = array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;
  TLocation = record
    X: double;
    Y: double;
  end;
  TPackageTypes = (ptList, ptDATA, ptDataBinary, ptBAS, ptBCF, ptWEL, ptDRN,
    ptRIV, ptEVT, ptTLK, ptGHB, ptRCH, ptSIP, ptDE4, ptSOR, ptOC, ptPCG, ptGFD,
    ptHFB, ptRES, ptSTR, ptIBS, ptCHD, ptFHB);
  TImportMethod = (imPointContours, imZones, imDomainOutline, imDataLayer);
  TBoundaryType = (btWell, btRiver, btDrain, btGHB, btFHBFlux, btFHBHead,
    btStream, btHFB, btMF2K_Well, btMF2K_Drain, btMF2K_GHB, btMF2K_River,
    btMF2K_FHB, btMF2K_CHD, btMF2K_HFB);

  TImportLayer = class(TObject)
    LayerIndex: integer;
    GridDensity: double;
    LayerName: string;
    FunctionList: T3DFunctionList;
    LinkedLayerList: TList;
    LinkedParameterList: TList;
    ExtraExpressionList: TStringList;
    ExtraEndExpressionList: TStringList;
    TimeFunctionList: T3DFunctionList;
    UseFunctionList: TUse3DFunctionList;
    ImportMethod: TImportMethod;
    ParameterNames: TStringList;
    ParameterTypes: array of TParameterValueType;
    constructor Create;
    destructor Destroy; override;
  private
    procedure MakePointContours;
    procedure MakeDataLayer;
    procedure MakeZoneData(const Offset: double);
    procedure ExportData(const Offset: double);
    procedure SetExpressions;
  end;

  TTypedBoundaryList = class(TList)
  private
    FBoundaryType: TBoundaryType;
    FLayer: integer;
    function GetType(Boundary: TCustomBoundary): TBoundaryType;
  public
    function Add(Item: Pointer): Integer;
    property BoundaryType: TBoundaryType read FBoundaryType;
    property Layer: integer read FLayer;
  end;

  TtypedEditContours = class(TEditContours)
  private
    function GetLayer: integer;
  public
    FBoundaryType: TBoundaryType;
    FLayer: integer;
    ParameterNames: TStringList;
    ParameterIndicies: TIntegerList;
    MaxValue: integer;
    function PieLayer: T_ANE_InfoLayer;
    function ArgusLayerHandle: ANE_PTR;
    constructor Create(AnOriginX, AnOriginY, AGridAngle: double;
      ABoundaryType: TBoundaryType; ALayer: integer);
    destructor Destroy; override;
    procedure GetParameterIndicies;
    property Layer: integer read GetLayer;
    procedure SetMaxValue;
    property BoundaryType: TBoundaryType read FBoundaryType;
  end;

  TBoundaryContour = class(TContour2)
    Values: TStringList;
    EditContours: TtypedEditContours;
    procedure SetAValue(const ParameterName: string; AValue: string);
    procedure SetValue;
    constructor Create(AnEditContours: TtypedEditContours);
    destructor Destroy; override;
    procedure SetParamName;
    function GetAValue(const ParameterName: string): string;
  end;

  TFHBContour = class(TBoundaryContour)
    Col, Row, Layer: integer;
    FlowValues: array of single;
    HeadValues: array of single;
    procedure Update;
    procedure WriteContour(OriginX, OriginY, GridAngle,
      Perturbation: double; RowDirectionPositive, ColumnDirectionPositive:
      boolean; ContourStringList: TStringList); override;
  end;

  THFB_Storage = class(TObject)
    Layer: integer;
    Row1: integer;
    Col1: integer;
    Row2: integer;
    Col2: integer;
    HYDCHR: single;
    ParamName: string;
  end;

  TMLayer = class(TObject)
    Layer: longint;
    Proportion: single;
  end;

  THeadObservationTime = class(TObject)
    OBSNAM: String;
    IREFSP: longint;
    TOFFSET, HOBS, STATh, STATdd: single;
    STATFLAG, PLOTSYMBOL: longint;
  end;

  THeadObservation = class(TObject)
  public
    OBSNAM: String;
    LAYER, ROW, COLUMN, IREFSP: longint;
    TOFFSET, ROFF, COFF, HOBS, STATISTIC: single;
    STATFLAG, PLOTSYMBOL: longint;
    ITT: longint;
    ProportionList: TObjectList;
    TimeList: TObjectList;
    Constructor Create;
    Destructor Destroy; override;
    function ParmeterValues: string;
    Procedure Coordinates(out X, Y: double);
  end;

  TfrmModflowImport = class(TArgusForm)
    pcMain: TPageControl;
    Panel1: TPanel;
    btnNext: TBitBtn;
    btnBack: TBitBtn;
    btnCancel: TBitBtn;
    tabModelChoice: TTabSheet;
    rgModelType: TRadioGroup;
    tabInitial: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    tabNameFile: TTabSheet;
    rgPreprocessor: TRadioGroup;
    Label3: TLabel;
    tabIUNIT: TTabSheet;
    dgIUNIT: TDataGrid;
    Label4: TLabel;
    Label5: TLabel;
    tabCreateNameFile: TTabSheet;
    OpenDialog1: TOpenDialog;
    dgNameFile: TDataGrid;
    btnNameFileCreate: TButton;
    adeNFiles: TArgusDataEntry;
    lblNFiles: TLabel;
    Label6: TLabel;
    edName: TEdit;
    Label7: TLabel;
    tabSelectNameFile: TTabSheet;
    Label8: TLabel;
    EdNameDuplicate: TEdit;
    btnSelectNameFile: TButton;
    tabModelProperties: TTabSheet;
    adeGridAngle: TArgusDataEntry;
    Label9: TLabel;
    adeOrX: TArgusDataEntry;
    Label10: TLabel;
    adeOrY: TArgusDataEntry;
    Label11: TLabel;
    cbRowsPositive: TCheckBox95;
    cbColumnsPositive: TCheckBox95;
    Label12: TLabel;
    BitBtn1: TBitBtn;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Panel2: TPanel;
    SaveDialog1: TSaveDialog;
    Panel3: TPanel;
    Label15: TLabel;
    Label18: TLabel;
    tabWarning2: TTabSheet;
    tabConvert: TTabSheet;
    OpenDialog2: TOpenDialog;
    Button1: TButton;
    Label20: TLabel;
    Panel4: TPanel;
    Label19: TLabel;
    Panel5: TPanel;
    Label21: TLabel;
    Panel6: TPanel;
    Label22: TLabel;
    Panel7: TPanel;
    Label23: TLabel;
    procedure btnNameFileCreateClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure btnBackClick(Sender: TObject);
    procedure btnSelectNameFileClick(Sender: TObject);
    procedure EdNameDuplicateChange(Sender: TObject);
    procedure rgPreprocessorClick(Sender: TObject);
    procedure dgNameFileEditButtonClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure tabCreateNameFileShow(Sender: TObject);
    procedure tabModelPropertiesShow(Sender: TObject);
    procedure adeNFilesChange(Sender: TObject);
    procedure dgNameFileSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure pcMainChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    ImportLayerList: TObjectList;
    EditContoursList: TObjectList;
    GetValue: TGetValue;
    SolverFound: boolean;
    MF2K_HfbList: TObjectList;
    function BlockIndex(RowIndex, ColIndex: integer): integer;
    procedure SetValues;
    procedure GetPackages;
    procedure SetStressPeriodValues(Period: integer;
      PeriodInfo: TPeriodInfo);
    function GetTRPY(Layer: Integer): Single;
    function GetSHead(Col, Row, Layer: Integer): Single;
//    function IsInactiveCell(Col, Row, Layer: Integer): boolean;
    function IsPrescribedHeadCell(Col, Row, Layer: Integer): boolean;
    function IsActiveCell(Col, Row, Layer: Integer): boolean;
    function GetHY(Col, Row, Layer: Integer): Single;
    function GetKB(Layer: Integer): Integer;
    function GetKT(Layer: Integer): Integer;
    function GetSC1(Col, Row, Layer: Integer): Single;
    function GetSC2(Col, Row, Layer: Integer): Single;
    function GetTrans(Col, Row, Layer: Integer): Single;
    function GetBOT(Col, Row, Layer: Integer): Single;
    function GetTOP(Col, Row, Layer: Integer): Single;
    function GetVCONT(Col, Row, Layer: Integer): Single;
    function GetWETDRY(Col, Row, Layer: Integer): Single;
    function GetWETDRYFlag(Col, Row, Layer: Integer): Single;
    function GetWETDRYThreshhold(Col, Row, Layer: Integer): Single;
    procedure MakeWellBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure ExportBoundaries;
    Procedure ExportHeadObservations;
    procedure MakeRiverBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure MakeDrainBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure MakeGHBBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure ShowInstructions;
    //    procedure AssignHelpFile(FileName: string);
    procedure MakeGroupLayer;
    procedure CreateNameFile;
    function GetIboundSign(Col, Row, Layer: Integer): Single;
    function IsCell(Col, Row, Layer: Integer): boolean;
    procedure ImportModflow2000;
    procedure CreateBatchFile;
    procedure ReadSteadyMF2K;
    procedure AssignMF2K_Packages;
    procedure SetUpGeoUnits;
    procedure SetUpStressPeriods;
    procedure SetUpMiscOptions;
    procedure ReadParameters;
    procedure SetMultiplierNames;
    procedure SetZoneNames;
    procedure CreateMf2kGridStructure;
    procedure AssignEvapArrays(const StressPeriodIndex: integer);
    procedure ReadStressPeriod(const StressPeriodIndex: integer);
    procedure AssignRechargeArrays(const StressPeriodIndex: integer);
    procedure SetActiveParameters(const StressPeriodIndex,
      CurrentNameCount: Integer);
    procedure SetMf2K_DataItems;
    function GetHK(Col, Row, Layer: Integer): Single;
    function GetHANI(Col, Row, Layer: Integer): Single;
    function GetVKA(Col, Row, Layer: Integer): Single;
//    function IsActiveLayer(Col, Row, Layer: Integer): boolean;
    function GetVKCB(Col, Row, Layer: Integer): Single;
    function GetIZONE(Col, Row, Layer: Integer): Single;
    function GetRMLT(Col, Row, Layer: Integer): Single;
    procedure MakeMF2KBoundaries;
    procedure MakeMF2K_WellBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure MakeMF2K_DrainBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure MakeMF2K_GHB_Boundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure MakeMF2K_RiverBoundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    procedure MakeMF2K_CHD_Boundaries(BoundaryList: TTypedBoundaryList;
      APoint: TPoint);
    function GetHUFTOP(Col, Row, Layer: Integer): Single;
    function GetHUFThickness(Col, Row, Layer: Integer): Single;
    procedure SetUpHufUnits;
    procedure SetParametersInactive(const StressPeriodIndex: Integer);
    procedure AssignETS_Arrays(const StressPeriodIndex: integer);
    function GetIETS(Col, Row: Integer): Single; overload;
    function GetIETS(Col, Row, Dummy: Integer): Single; overload;
    function GetETSR(Col, Row: Integer): Single;  overload;
    function GetETSR(Col, Row, StressPeriod: Integer): Single; overload;
    function GetETSS(Col, Row: Integer): Single; overload;
    function GetETSS(Col, Row, Dummy: Integer): Single; overload;
    function GetETSX(Col, Row: Integer): Single; overload;
    function GetETSX(Col, Row, Dummy: Integer): Single; overload;
    function GetPETM(Col, Row, Seg: Integer): Single;
    function GetPXDP(Col, Row, Seg: Integer): Single;
    function GetETS_IntermediateDepth(Col, Row, Segment: Integer): Single;
    function GetETS_IntermediateRate(Col, Row, Segment: Integer): Single;
    procedure MakeHFBBoundaries(BoundaryList: TTypedBoundaryList);
    procedure MakeMF2K_HFBBoundaries;
    procedure ChangeHOB_Expressions;
    procedure SetExpressionsForNonSimulatedLayers;
  public //private
    IAPART: longint; // Basic package; sets whether BUFFER and RHS share space
    ICHFLG: longint; // Basic package; flag for flow between constant head cells
    ISTRT: longint; // Basic package; flag to save or not save starting heads
    ISUM: longint; // lowest unallocated element in X array
    ITMUNI: longint; // Basic package; code for time units
    LCIBOU: longint; // Basic package; start of IBOUND
    LCSTRT: longint; // Basic package; start of STRT
    NCOL: longint; // Basic package; number of columns
    NLAY: longint; // Basic package; number of layers
    NPER: longint; // Basic package; number of stress periods
    NROW: longint; // Basic package; number of rows
    NSTP: longint;
      // Basic package; number of time steps in current stress period
    DELT: single; // Basic package; length of first time step in stress period.
    ISS: longint; // Block-centered flow package; steady-state flag
    HDRY: single; // Block-centered flow package; head of cells converted to dry
    IHDWET: longint; // Block-centered flow package; flag for wetting equation
    IWDFLG: longint;
      // Block-centered flow package; flag for whether wetting is active
    IWETIT: longint;
      // Block-centered flow package; iteration interval for wetting cells
    LCBOT: longint; // Block-centered flow package; start of BOT
    LCCC: longint; // Basic package; start of CC (transmissivity)
    LCCV: longint; // Basic package; start of CV
    LCDELC: longint; // Basic package; start of DELC
    LCDELR: longint; // Basic package; start of DELR
    LCHY: longint; // Block-centered flow package; start of HY
    LCSC1: longint; // Block-centered flow package; start of SC1
    LCSC2: longint; // Block-centered flow package; start of SC2
    LCTOP: longint; // Block-centered flow package; start of TOP
    LCTRPY: longint; // Block-centered flow package; start of TRPY
    LCWETD: longint; // Block-centered flow package; start of WETDRY
    IWELAL: longint;
      // Well package; flag for allocation of memory to return cell-by-cell flows
    LCWELL: longint; // Well package; start of WELL
    MXWELL: longint; // Well package; maximum number of wells active at one time
    NWELVL: longint;
      // Well package; the size of the first dimension of the well array
    NWELLS: longint; // Well package; number of wells active in a stress period
    IDRNAL: longint;
      // Drain package; flag for allocation of memory to return cell-by-cell flows
    LCDRAI: longint; // Drain package; start of DRAI
    MXDRN: longint; // Drain package; maximum number of drains active at one time
    NDRAIN: longint;
      // Drain package; number of drains active in current stress period
    NDRNVL: longint;
      // Drain package; the size of the first dimension of the DRAI array
    LCRIVR: longint; // River package; start of RIVR
    MXRIVR: longint; // River package; maximum number of river reaches
    NRIVER: longint; // River package; number of river reaches in stress period
    NRIVVL: longint;
      // River package; the size of the first dimension of the RIVR array
    IRIVAL: longint;
      // River package; flag for allocation of memory to return cell-by-cell flows
    LCIEVT: longint; // evapotranspiration package; start of IEVT
    LCEVTR: longint; // evapotranspiration package; start of EVTR
    LCEXDP: longint; // evapotranspiration package; start of EXDP
    LCSURF: longint; // evapotranspiration package; start of SURF
    NEVTOP: longint; // evapotranspiration package; evapotranspiration option
    LCBNDS: longint; // general-head boundary package; start of BNDS
    NBOUND: longint;
      // general-head boundary package; number of general-head boundaries in current stress period
    MXBND: longint;
      // general-head boundary package; maximum number of general-head boundaries at any one time
    NGHBVL: longint;
      // general-head boundary package; the size of the first dimension of the BNDS array
    IGHBAL: longint;
      // general-head boundary package; flag for allocation of memory to return cell-by-cell flows
    LCIRCH: longint; // Recharge package; start of IRCH
    LCRECH: longint; // Recharge package; start of RECH
    NRCHOP: longint; // Recharge package; recharge option
    MXITER: longint; // SIP, SOR, PCG2 package; maximum number of iterations
    NPARM: longint; // SIP package; number of iteration parameters
    IPCALC: longint; // SIP package; flag
    IPRSIP: longint; // SIP package; printout frequency
    MXUP: longint; // DE4 package; maximum number of equations in upper part of A
    MXLOW: longint;
      // DE4 package; maximum number of equations in lower part of A
    MXBW: longint; // DE4 package; maximum allowed value of the bandwidth plus 1
    ITMX: longint; // DE4 package; maximun number of iterations for one time step
    IFREQ: longint; // DE4 package; flag indicating frequency at which A changes
    IPRD4: longint; // DE4 package; time step interval for printing
    MUTD4: longint; // DE4 package; flag indicating information to be printed
    IPRSOR: longint; // SOR package; printout frequency
    ITER1: longint; // PCG2 package; maximum number of inner iterations
    NPCOND: longint; // PCG2 package; preconditioner choice
    NBPOL: longint;
      // PCG2 package; flag to indicate whether eigenvalue calculated
    IPRPCG: longint; // PCG2 package; printout interval
    MUTPCG: longint; // PCG2 package; printing control
    ///   INBAS: longint;   // basic package; unit number for basic package input
    NRESOP: longint; // reservoir package; reservoir option flag
    IFHBCB: longint; // FHB package; flag and unit number
    IFHBD3: longint;
      // FHB package; dimension for storing specified flow values and auxiliary variables associated with specified flow cells.  First dimension of FLWRAT
    IFHBD4: longint;
      // FHB package; dimension for interpolated specified flow values and interpolated auxiliary variables associated with specified flow cells.  first dimension of BDFV
    IFHBD5: longint;
      // FHB package; dimension for storing auxiliary variables associated with specified head cells.  first dimension of SBHED
    IFHBSS: longint; // FHB package; option for steady state simulations
    LCFLLC: longint; // FHB package; location of IFLLOC(4,NFLW) flow locations
    LCBDTM: longint; // FHB package; location of BDTM(NBDTIM)
    LCFLRT: longint;
      // FHB package; location of flwrat(NBDTIM,NFLW) specified flows
    LCHDLC: longint; // FHB package; location of IHDLOC(4,NHED) head locations
    LCSBHD: longint;
      // FHB package; location of SBHED(NBDTIM,NHED) specified heads
    NBDTIM: longint; // FHB package; NUMBER OF TIMES
    NFHBX1: longint;
      // FHB package; number of auxilliary variables associated with specified flow cells
    NFHBX2: longint;
      // FHB package; number of auxilliary variables associated with specified head cells
    NFLW: longint; // FHB package; number of specified flow cells
    NHED: longint; // FHB package; number of specified head cells
    LCHFBR: longint; // HFB package; start of HFBR
    NHFB: longint; // HFB package; number of flow barriers
    MXSTRM: longint; // stream package; maximum number of stream reaches
    NSTREM: longint;
      // stream package; number of stream reaches in current stress period
    ISTCB1: longint;
      // stream package; flag and unit number of leakage between stream and aquifer
    ISTCB2: longint; // stream package; flag for flows among reaches
    NSS: longint; // stream package; maximum number of segments in simulation
    NTRIB: longint; // stream package; maximum tributaries in a simulation
    NDIV: longint; // stream package; flag to use diversions
    ICALC: longint; // stream package; flag to calculate stream stage
    LCSTRM: longint; // stream package; location of STRM(11,MXTRM)
    LCTBAR: longint; // stream package; location of ITRBAR(NSS,NTRIB)
    LCTRIB: longint; // stream package; location of ARTRIB
    LCIVAR: longint; // stream package; location of IDIVAR(NSS)
    ICSTRM: longint; // stream package; location of ISTRM(5,MXTRM)
    WETFCT: single; // Block-centered flow package; wetting factor
    TSMULT: single; // Basic package; time step multiplier
    ACCL: single;
      // SIP package, DE4 package; SOR package; acceleration parameter
    HCLOSE: single; // all solvers; head close criterion
    RCLOSE: single; // PCG2 package; residual close criterion
    RELAX: single; // PCG2 package; relaxation parameter
    DAMP: single; // PCG2 package; damping factor
    WSEED: single; // SIP package; seed
    StrCONST: single;
      // Stream package; CONST; (name changed to avoid conflict with reserved word "const"

    HNOFLO: double; // basic package; no flow head

    LAYCOX: Iarray200; // LAYCON
    LAYAVGX: Iarray200; // LAYCON
    IUNITX: Iarray40; // IUNIT

    HEADX1, HEADX2: string81; // the title lines
    MaxWidth: single;

    Pages: TIntegerList;
    TimeInfoList: TObjectList;
    AGrid: T2DBlockCenteredGrid;
    ModflowArrayNames: TStringList;
    CellCenters: array of array of TLocation;
    MFHandle: THandle;
    MF2K_Importer: TMF2K_Importer;
    CurrentHeadObservation: THeadObservation;
    HeadObservationList: TObjectList;
    CurrentStressPeriod: integer;
    function CreateNewHeadObservation: THeadObservation;
    function SaveNameFile: boolean;
    procedure InitializeModflow;
    procedure CallInit(StressPeriod: integer; Init: TInit);
    function GetDELC(Row: Integer): Single;
    function GetDELR(Col: Integer): Single;
    function GetEVTR(Col, Row: Integer): Single; overload;
    function GetEVTR(Col, Row, StressPeriodIndex: Integer): Single; overload;
    function GetEXDP(Col, Row: Integer): Single; overload;
    function GetEXDP(Col, Row, StressPeriodIndex: Integer): Single; overload;
    function GetIEVT(Col, Row: Integer): Single; overload;
    function GetIEVT(Col, Row, StressPeriodIndex: Integer): Single; overload;
    function GetSURF(Col, Row: Integer): Single; overload;
    function GetSURF(Col, Row, StressPeriodIndex: Integer): Single; overload;
    function GetIRCH(Col, Row: Integer): Single; overload;
    function GetIRCH(Col, Row, StressPeriodIndex: Integer): Single; overload;
    function GetRECH(Col, Row: Integer): Single; overload;
    function GetRECH(Col, Row, StressPeriodIndex: Integer): Single; overload;
    function NumberOfDrains: integer;
    function NumberOfBarriers: integer;
    function CalculateStreamStage: boolean;
    function NumberOfFHBFlows: integer;
    function NumberOfFHBHeads: integer;
    function NumberOfFHBTimes: integer;
    function NumberOfGHBBoundaries: integer;
    function NumberOfRivers: integer;
    function NumberOfStreamCells: integer;
    function NumberOfWells: integer;
    function NumStreamTributaries: integer;
    function UseCell(Col, Row, Layer: integer): boolean;
    function UseStreamDiversions: Boolean;
    function UseStreamTributaries: Boolean;
    function GetHFBR(hfbCell: Integer; hfbValue: THFBLocations): Single;
      overload;
    function GetHFBR(hfbCell, hfbValue: Integer): Single; overload;
    function GetDrain(DrainCell, DrainValue: Integer): Single; overload;
    function GetDrain(DrainCell: Integer; DrainValue: TDrainValues): Single;
      overload;
    function GetFlowLoc(fhbCell: Integer; fhbValue: TFHBLocations): Single;
      overload;
    function GetFlowLoc(fhbCell, fhbValue: Integer): Single; overload;
    function GetHeadLoc(fhbCell: Integer; fhbValue: TFHBLocations): Single;
      overload;
    function GetHeadLoc(fhbCell, fhbValue: Integer): Single; overload;
    function GetGHB(ghbCell, ghbValue: Integer): Single; overload;
    function GetGHB(ghbCell: Integer; ghbValue: TGHBValues): Single; overload;
    function GetIbound(Col, Row, Layer: Integer): Single;
    function GetRIVR(RiverCell, RiverValue: Integer): Single; overload;
    function GetRIVR(RiverCell: Integer; RiverValue: TRiverValues): Single;
      overload;
    function GetICSTRM(strCell: Integer;
      strValue: TStreamIntValues): Single; overload;
    function GetICSTRM(strCell, strValue: Integer): Single; overload;
    function GetWELL(WellCell, WellValue: Integer): Single; overload;
    function GetWELL(WellCell: Integer; WellValue: TWellValues): Single;
      overload;
    function GetSTRM(strCell: Integer;
      strValue: TStreamRealValues): Single; overload;
    function GetSTRM(strCell, strValue: Integer): Single; overload;
    function GetITRBAR(strSegment, Tributary: Integer): Single;
    function GetIDIVAR(strSegment: Integer): Single;
    function GetFLWRAT(fhbCell, fhbTime: Integer): Single;
    function GetSBHED(fhbCell, fhbTime: Integer): Single;
    function GetActiveCell(Col, Row, Layer: Integer): Single;
    function GetATypedEditContours(BoundaryType: TBoundaryType;
      Layer: integer): TtypedEditContours;
    function IsActiveCellOnAnyLayer(Col, Row, Layer: Integer): boolean;
    procedure SetDataItems;
    procedure ExportGrid;
    procedure ImportText(Strings: TStringList; layerHandle: ANE_PTR);
    procedure MakeGridDensity;
    procedure MakeDataLayer(DataValues: TObjectList;
      ParameterNames: TStringList; LayerHandle: ANE_PTR);
    { Private declarations }
    procedure SetCellCenters(GridLayerHandle: ANE_PTR);
    procedure MakeBoundaries;
  public
    MF2K_HfbNamesList: TStringList;
    procedure StoreMF2K_HFBBoundary(const Layer, Row1, Col1, Row2, Col2: integer;
      const Hydchr: single; const ParamName: string);
    function GetXX(IXINDEX: integer): single;
    property XX[IXINDEX: integer]: single read GetXX;
    { Public declarations }
  end;

var
  frmModflowImport: TfrmModflowImport;
  btnModflowImportHelpContext: integer;

implementation

{$R *.DFM}

uses RealListUnit, frmDataValuesUnit, ANECB, LayerNamePrompt, UtilityFunctions,
  OptionsUnit, ModflowUnit, ConserveResourcesUnit, mf2kInterface, StringGrid3d,
  MFGenParam;

function StressPeriodBoundarySort(Item1, Item2: Pointer): Integer;
var
  Boundary1, Boundary2: TCustomBoundary;
begin
  Boundary1 := Item1;
  Boundary2 := Item2;
  result := Boundary1.StressPeriod - Boundary2.StressPeriod;
end;

procedure TfrmModflowImport.btnNameFileCreateClick(Sender: TObject);
begin
  SaveDialog1.Filter := 'Name Files (*.nam)|*.nam|All Files (*.*)|*.*';
  SaveDialog1.Title := 'Select name file';
  SaveDialog1.FileName := edName.Text;
  SaveDialog1.InitialDir := GetCurrentDir;
  if SaveDialog1.Execute then
  begin
    edName.Text := SaveDialog1.FileName;
  end;
end;

procedure TfrmModflowImport.GetPackages;
const
  Packages: array[Low(TPackageTypes)..High(TPackageTypes)] of string =
  ('LIST', 'DATA', 'DATA(BINARY)', 'BAS', 'BCF', 'WEL', 'DRN', 'RIV', 'EVT',
    'TLK', 'GHB',
    'RCH', 'SIP', 'DE4', 'SOR', 'OC', 'PCG', 'GFD',
    'HFB', 'RES', 'STR', 'IBS', 'CHD', 'FHB');
var
  AStringList: TStringlist;
  Index: integer;
  ALine: string;
  SpacePos: integer;
  PackageType: TPackageTypes;
  Found: boolean;
begin
  SolverFound := False;
  frmModflow.rbModflow96.Checked := (rgModelType.ItemIndex < 2);
  Assert(frmModflow.rgSolMeth.Items.Count >= 4);
  AStringList := TStringlist.Create;
  try
    AStringList.LoadFromFile(edName.Text);
    for Index := 0 to AStringList.Count - 1 do
    begin
      ALine := AStringList[Index];
      if (Length(ALine) > 0) and (ALine[1] <> '#') then
      begin
        ALine := Trim(ALine);
        SpacePos := Pos(' ', ALine);
        if SpacePos > 0 then
        begin
          SetLength(ALine, SpacePos - 1);
        end;
        ALine := UpperCase(ALine);
        Found := False;
        for PackageType := Low(TPackageTypes) to High(TPackageTypes) do
        begin
          if Pos(Packages[PackageType], ALine) > 0 then
          begin
            Found := True;
            with frmModflow do
            begin
              case PackageType of
                ptList, ptDATA, ptDataBinary, ptBAS:
                  begin
                  end;
                ptBCF:
                  begin
                    rgFlowPackage.ItemIndex := 0;
                    rgFlowPackageClick(rgFlowPackage);
                  end;
                ptWEL:
                  begin
                    cbWEL.Checked := True;
                  end;
                ptDRN:
                  begin
                    cbDRN.Checked := True;
                  end;
                ptRIV:
                  begin
                    cbRIV.Checked := True;
                  end;
                ptEVT:
                  begin
                    cbEVT.Checked := True;
                  end;
                ptTLK:
                  begin
                    cbTLK.Checked := True;
                  end;
                ptGHB:
                  begin
                    cbGHB.Checked := True;
                  end;
                ptRCH:
                  begin
                    cbRCH.Checked := True;
                  end;
                ptSIP:
                  begin
                    rgSolMeth.ItemIndex := 0;
                    SolverFound := True;
                    rgSolMethClick(rgSolMeth);
                  end;
                ptDE4:
                  begin
                    rgSolMeth.ItemIndex := 1;
                    SolverFound := True;
                    rgSolMethClick(rgSolMeth);
                  end;
                ptSOR:
                  begin
                    rgSolMeth.ItemIndex := 3;
                    SolverFound := True;
                    rgSolMethClick(rgSolMeth);
                  end;
                ptOC:
                  begin
                  end;
                ptPCG:
                  begin
                    rgSolMeth.ItemIndex := 2;
                    SolverFound := True;
                    rgSolMethClick(rgSolMeth);
                  end;
                ptGFD:
                  begin
                  end;
                ptHFB:
                  begin
                    cbHFB.Checked := True;
                  end;
                ptRES:
                  begin
                    cbRES.Checked := True;
                  end;
                ptSTR:
                  begin
                    cbSTR.Checked := True;
                  end;
                ptIBS:
                  begin
                    cbIBS.Checked := True;
                  end;
                ptCHD:
                  begin
                  end;
                ptFHB:
                  begin
                    cbFHB.Checked := True;
                  end;
              else
                Assert(False);
              end;
            end;
            break;
          end;
        end;
        if not Found then
        begin
          MessageDlg('The ' + ALine + ' package was not recognized; '
            + 'it will be skipped.', mtWarning, [mbOK], 0);
        end;
      end;
    end;
  finally
    AStringList.Free;
  end;
end;

procedure TfrmModflowImport.ExportBoundaries;
var
  Index: integer;
  EditContours: TTypedEditContours;
  AStringList: TStringList;
  UnitIndex: integer;
  LayerName: string;
  Layer: TLayerOptions;
begin
  if frmModflow.cbHFB.Checked then
  begin
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      LayerName := ModflowTypes.GetMFHFBLayerType.ANE_LayerName
        + IntToStr(UnitIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
      try
        Layer.AllowIntersection[CurrentModelHandle] := True;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
  end;

  AStringList := TStringList.Create;
  try
    for Index := 0 to EditContoursList.Count - 1 do
    begin
      EditContours := EditContoursList[Index] as TTypedEditContours;
      if EditContours.BoundaryType = btMF2K_FHB then
      begin
        EditContours.GetParameterIndicies;
      end;

      EditContours.WriteContours(0, cbRowsPositive.Checked,
        cbColumnsPositive.Checked, AStringList);
      ImportText(AStringList, EditContours.ArgusLayerHandle);
    end;
  finally
    AStringList.Free;
  end;
end;

procedure TfrmModflowImport.ShowInstructions;
begin
  Beep;
  MessageDlg('You are almost finished importing your model.  '
    + 'You must do the last step manually.  '
    + 'Make the grid layer the active layer and click on the grid with '
    + 'the "Magic Wand" tool.  '
    + 'In the dialog box, click on the "Deactivate" button.  '
    + 'Then check to make sure that all cells whose centers are inside the grid '
    + 'have been deactivated properly.  '
    + 'If an active cell should be an inactive cell or vice versa, select that '
    + 'cell and then select "Edit|Toggle Active".  '
    + 'You should also check that all information imported into the model as '
    + 'closed contours is interpreted correctly by Argus ONE.  '
    + 'If it is not interpreted correctly, try making minor changes to the '
    + 'contours.'
    , mtInformation, [mbOK, mbHelp], btnModflowImportHelpContext);
end;

procedure TfrmModflowImport.MakeGroupLayer;
var
  GroupLayer: T_ANE_NamedGroupLayer;
  DataLayerTemplate: string;
  ANE_LayerTemplate: ANE_STR;
begin
  GroupLayer := T_ANE_NamedGroupLayer.Create('Imported Data', nil, -1);
  try
    DataLayerTemplate := GroupLayer.WriteLayer(CurrentModelHandle);

    GetMem(ANE_LayerTemplate, Length(DataLayerTemplate) + 1);
    try
      StrPCopy(ANE_LayerTemplate, DataLayerTemplate);
      ANE_LayerAddByTemplate(CurrentModelHandle,
        ANE_LayerTemplate, nil);
      ANE_ProcessEvents(CurrentModelHandle);
    finally
      FreeMem(ANE_LayerTemplate);
    end;

  finally
    GroupLayer.Free;
  end;
end;

procedure TfrmModflowImport.btnNextClick(Sender: TObject);
var
  NextPage: integer;
  {LayerIndex,}Index: integer;
  ImportLayer: TImportLayer;
  Term: TTerminate;
  procedure SetPage;
  begin
    Pages.Add(pcMain.ActivePageIndex);
    pcMain.ActivePageIndex := NextPage;
    btnBack.Enabled := True;
  end;
  procedure GoToFollowingPage;
  begin
    NextPage := pcMain.ActivePageIndex + 1;
    SetPage;
  end;
begin
  case pcMain.ActivePageIndex of
    0, 1, 2:
      begin
        GoToFollowingPage;
      end;
    3:
      begin
        if rgModelType.ItemIndex = 0 then
        begin
          NextPage := tabNameFile.PageIndex;
        end
        else
        begin
          NextPage := tabSelectNameFile.PageIndex;
        end;
        SetPage;
      end;
    4:
      begin
        rgPreprocessorClick(nil);
        GoToFollowingPage;
      end;
    5:
      begin
        CreateNameFile;
        GoToFollowingPage;
      end;
    6:
      begin
        if SaveNameFile then
        begin
          NextPage := tabModelProperties.PageIndex;
          SetPage;
        end;
      end;
    7:
      begin
        GoToFollowingPage;
      end;
    8:
      begin
        frmModflow.Importing := True;
        try
          if rgModelType.ItemIndex <= 1 then
          begin
            Hide;
            frmModflow.rgFlowPackage.ItemIndex := 0;
            frmModflow.rgSolMeth.ItemIndex := 2;
            MakeGroupLayer;
            GetPackages;
            try
              InitializeModflow;
              frmModflow.btnOKClick(frmModflow.btnOK);
              frmModflow.MFLayerStructure.OK(CurrentModelHandle);
              ANE_ProcessEvents(CurrentModelHandle);
              ExportGrid;
              MakeGridDensity;

              for Index := 0 to ImportLayerList.Count - 1 do
              begin
                ImportLayer := ImportLayerList[Index] as TImportLayer;
                ImportLayer.ExportData(AGrid.Perturbation);
              end;
              MakeBoundaries;
              ExportBoundaries;
              ShowInstructions;
            finally
              if MFHandle <> 0 then
              begin
                @Term := GetProcAddress(MFHandle, 'TERMINATE');
                if @Term <> nil then
                begin
                  Term;
                end;
              end;
            end;
          end
          else
          begin
            ImportModflow2000;
          end;
        finally
          frmModflow.Importing := False
        end;
      end;
  else
    Assert(False);
  end;
end;

function TfrmModflowImport.SaveNameFile: boolean;
var
  NameFile: TStringList;
  RowIndex, ColIndex: integer;
  Col, Row: Integer;
  ALine: string;
  Directory, FileName: string;
  FileNames: TStringList;
  Filetypes: TStringList;
  FileNumbers: TIntegerList;
  FileType: string;
  AUnitNumber: integer;
begin
  result := false;
  FileNames := TStringList.Create;
  Filetypes := TStringList.Create;
  FileNumbers := TIntegerList.Create;
  try
    Directory := ExtractFilePath(edName.Text);
    for RowIndex := 1 to dgNameFile.RowCount - 1 do
    begin
      for ColIndex := 0 to dgNameFile.ColCount - 1 do
      begin
        if dgNameFile.Cells[ColIndex, RowIndex] = '' then
        begin
          Row := RowIndex;
          Col := ColIndex + 1;
          Beep;
          MessageDlg('Error: The name file at column: ' + IntToStr(Col) +
            '; row: ' + IntToStr(Row) + ' is a blank.', mtError, [mbOK], 0);
          Exit;
        end;
      end;

      FileType := dgNameFile.Cells[1, RowIndex];
      if Filetypes.IndexOf(FileType) > -1 then
      begin
        Beep;
        MessageDlg('Error: the file type ' + FileType
          + ' occurs in the name file more than once.',
          mtError, [mbOK], 0);
        Exit;
      end;
      Filetypes.Add(FileType);

      FileName := dgNameFile.Cells[2, RowIndex];
      if FileNames.IndexOf(FileName) > -1 then
      begin
        Beep;
        MessageDlg('Error: the file name ' + FileName
          + ' occurs in the name file more than once.',
          mtError, [mbOK], 0);
        Exit;
      end;
      FileNames.Add(FileName);
      FileName := Directory + FileName;
      if not FileExists(FileName)
        and (dgNameFile.Cells[0, RowIndex] <> 'LIST') then
      begin
        Beep;
        if MessageDlg('Warning: ' + FileName + ' does not exist.  If this '
          + 'file is an output file, then the file doesn''t need to exist '
          + 'now but if it is an imput file than the file needs to exist.  '
          + 'Do you want to continue?',
          mtWarning, [mbYes, mbNo], 0) = mrNo then
        begin
          Exit;
        end;
      end;

    end;
    NameFile := TStringList.Create;
    try
      for RowIndex := 1 to dgNameFile.RowCount - 1 do
      begin
        try
          AUnitNumber := StrToInt(dgNameFile.Cells[1, RowIndex]);
          if FileNumbers.IndexOf(AUnitNumber) > -1 then
          begin
            Beep;
            MessageDlg('Error: the unit number ' + dgNameFile.Cells[1, RowIndex]
              + ' occurs in the name file more than once.',
              mtError, [mbOK], 0);
            Exit;
          end;
          FileNumbers.Add(AUnitNumber);

        except on EConvertError do
          begin
            Beep;
            Row := RowIndex;
            Col := 1;
            MessageDlg('Error: The unit number (' + dgNameFile.Cells[1, RowIndex]
              + ') at column: ' + IntToStr(Col) +
              '; row: ' + IntToStr(Row) + ' is not an integer.', mtError,
                [mbOK], 0);
            Exit;
          end;
        end;
        ALine := dgNameFile.Cells[0, RowIndex] + ' '
          + dgNameFile.Cells[1, RowIndex] + ' ';
        if (Pos(' ', dgNameFile.Cells[2, RowIndex]) > 0) and
          (dgNameFile.Cells[2, RowIndex][1] <> '''') then
        begin
          ALine := ALine + '''' + dgNameFile.Cells[2, RowIndex] + '''';
        end
        else
        begin
          ALine := ALine + dgNameFile.Cells[2, RowIndex];
        end;
        NameFile.Add(ALine);
      end;
      NameFile.SaveToFile(edName.Text);
    finally
      NameFile.Free;
    end;
  finally
    FileNames.Free;
    Filetypes.Free;
    FileNumbers.Free;
  end;
  result := True;
end;

procedure TfrmModflowImport.FormCreate(Sender: TObject);
var
  TabIndex: integer;
  ATab: TTabSheet;
  ColumnIndex: integer;
  APickList: TStringList;
  Column: TColumn;
begin
  inherited;
  MF2K_HfbList:= TObjectList.Create;
  MF2K_HfbNamesList := TStringList.Create;
  HeadObservationList := TObjectList.Create;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  AssignHelpFile('MODFLOW.chm');
  EditContoursList := TObjectList.Create;
  ImportLayerList := TObjectList.Create;
  Pages := TIntegerList.Create;
  for TabIndex := 0 to pcMain.PageCount - 1 do
  begin
    ATab := pcMain.Pages[TabIndex];
    ATab.TabVisible := False;
  end;
  pcMain.ActivePage := TabInitial;
  TimeInfoList := TObjectList.Create;
  ModflowArrayNames := TStringList.Create;
  ModflowArrayNames.Add('Domain Outline');
  ModflowArrayNames.Add('IBOUND');
  ModflowArrayNames.Add('Initial Head');
  ModflowArrayNames.Add('Confined Storage Coefficient');
  ModflowArrayNames.Add('Specific Yield');
  ModflowArrayNames.Add('Transmissivity');
  ModflowArrayNames.Add('Hydraulic Conductivity');
  ModflowArrayNames.Add('Bottom of Layer');
  ModflowArrayNames.Add('Top of Layer');
  ModflowArrayNames.Add('Vertical Conductance');
  ModflowArrayNames.Add('WETDRY');
  ModflowArrayNames.Add('Evapotranspiration');
  ModflowArrayNames.Add('Recharge');

  APickList := TStringList.Create;
  try
    APickList.Assign(dgIUNIT.Columns[0].PickList);
    for ColumnIndex := 0 to dgIUNIT.Columns.Count - 1 do
    begin
      Column := dgIUNIT.Columns[ColumnIndex];
      Column.PickList.Assign(APickList);
      Column.LimitToList := True;
      Column.Title.Caption := IntToStr(ColumnIndex + 1);
    end;

  finally
    APickList.Free;
  end;
  dgNameFile.Cells[0, 1] := 'LIST';
  dgNameFile.Cells[0, 2] := 'BAS';
  dgNameFile.Cells[1, 1] := '6';
  dgNameFile.Cells[1, 2] := '5';
  FreeFormResources(self);
end;

procedure TfrmModflowImport.CreateNameFile;
var
  BasFile: TStringList;
  IUNIT_String: string;
  IUNITIndex: integer;
  UnitNumberString: string;
  UnitNumber: integer;
  FileIndex: integer;
  FileType: string;
begin
  OpenDialog1.Filter := 'Basic package files (*.bas)|*.bas|All Files (*.*)|*.*';
  OpenDialog1.FilterIndex := 1;
  OpenDialog1.Title := 'Select Basic package input file';
  OpenDialog1.InitialDir := GetCurrentDir;
  if OpenDialog1.Execute then
  begin
    dgNameFile.Cells[2, 2] := ExtractFileName(OpenDialog1.FileName);
    BasFile := TStringList.Create;
    try
      BasFile.LoadFromFile(OpenDialog1.FileName);
      IUNIT_String := BasFile[3];
    finally
      BasFile.Free;
    end;
    FileIndex := 2;
    for IUNITIndex := 0 to 23 do
    begin
      UnitNumberString := Trim(Copy(IUNIT_String, IUNITIndex * 3 + 1, 3));
      if UnitNumberString = '' then
      begin
        UnitNumber := 0;
      end
      else
      begin
        UnitNumber := StrToInt(UnitNumberString);
      end;
      if UnitNumber <> 0 then
      begin
        FileType := dgIUNIT.Cells[IUNITIndex, 1];
        if (FileType <> '') and (FileType <> 'None') then
        begin
          Inc(FileIndex);
          if dgNameFile.RowCount < FileIndex + 1 then
          begin
            dgNameFile.RowCount := FileIndex + 1;
          end;
          dgNameFile.Cells[0, FileIndex] := FileType;
          dgNameFile.Cells[1, FileIndex] := UnitNumberString;
        end;
      end;
    end;
    adeNFiles.Text := IntToStr(dgNameFile.RowCount - 1);
    ShowMessage('You will need to fill in the rest of the name '
      + 'file manually.');
  end;
end;

procedure TfrmModflowImport.FormDestroy(Sender: TObject);
begin
  Pages.Free;
  TimeInfoList.Free;
  ModflowArrayNames.Free;
  FreeAndNil(AGrid);
  ImportLayerList.Free;
  EditContoursList.Free;
  HeadObservationList.Free;
  if MFHandle <> 0 then
  begin
    FreeLibrary(MFHandle);
  end;
  MF2K_HfbList.Free;
  MF2K_HfbNamesList.Free;
  inherited;
end;

procedure TfrmModflowImport.btnBackClick(Sender: TObject);
begin
  btnNext.Enabled := True;
  pcMain.ActivePageIndex := Pages[Pages.Count - 1];
  Pages.Delete(Pages.Count - 1);
  btnBack.Enabled := Pages.Count > 0;
  btnNext.ModalResult := mrNone;
  btnNext.Caption := '&Next';
end;

procedure TfrmModflowImport.btnSelectNameFileClick(Sender: TObject);
begin
  OpenDialog1.Filter :=
    'Name Files (*.nam;*.in;*.mfn)|*.nam;*.in;*.mfn|All Files (*.*)|*.*';
  OpenDialog1.FilterIndex := 1;
  OpenDialog1.Title := 'Select name file';
  OpenDialog1.FileName := edName.Text;
  OpenDialog1.InitialDir := GetCurrentDir;
  if OpenDialog1.Execute then
  begin
    edName.Text := OpenDialog1.FileName;
    EdNameDuplicate.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmModflowImport.CreateBatchFile;
var
  MODFLOW_bf: TStringList;
  MODFLOW_bfName: string;
  PathName: string;
begin
  MODFLOW_bf := TStringList.Create;
  try
    PathName := ExtractFileName(edName.Text);
    if (Pos(' ', PathName) > 0) and (PathName <> '''') then
    begin
      MODFLOW_bf.Add('''' + PathName + '''');
    end
    else
    begin
      MODFLOW_bf.Add(PathName);
    end;
    MODFLOW_bfName := ExtractFileDir(edName.Text) + '\modflow.bf';
    SetCurrentDir(ExtractFileDir(edName.Text));
    MODFLOW_bf.SaveToFile(MODFLOW_bfName);
  finally
    MODFLOW_bf.Free;
  end;
end;

procedure TfrmModflowImport.InitializeModflow;
var
  {    IDLLPE  is the stress period for which data is desired.}
  Init: TInit;
  RowIndex, ColIndex: Integer;
  ColWidths, RowWidths: TRealList;
  AWidth: double;
  StressPeriodIndex: integer;
  APeriodInfo: TPeriodInfo;
  LibPath: string;
begin
  TimeInfoList.Clear;
  CreateBatchFile;

  if GetDllDirectory(GetDLLName, LibPath) then
  begin
    LibPath := LibPath + '\' + 'modflw96.dll';
    MFHandle := LoadLibrary(PChar(LibPath));
    if MFHandle = 0 then
    begin
      Beep;
      MessageDlg('insufficient free memory to load modflw96.dll. Close some '
        + 'programs and try again.', mtError, [mbOK], 0);
    end
    else
    begin
      Screen.Cursor := crHourGlass;
      try // 1
        begin
          @Init := GetProcAddress(MFHandle, 'INIT');
          @GetValue := GetProcAddress(MFHandle, 'GETVALUE');
          if (@Init = nil) or (@GetValue = nil) then
          begin
            if (@Init = nil) and (@GetValue = nil) then
            begin
              Raise Exception.Create(
                '"INIT" and "GETVALUE" procedures not found in modflw96.dll.');
            end
            else if (@Init = nil) then
            begin
              Raise Exception.Create(
                '"INIT" procedure not found in modflw96.dll.');
            end
            else
            begin
              Raise Exception.Create(
                '"GETVALUE" procedure not found in modflw96.dll.');
            end;
          end
          else
          begin
            {need to initialize all values to 0 except IDLLPE.}
            NRCHOP := 0;
            NRESOP := 0;
            NEVTOP := 0;
            ICHFLG := 0;

            CallInit(0, Init);
            SetValues;

            //process MODFLOW data.

            MaxWidth := 0;
            ColWidths := TRealList.Create;
            RowWidths := TRealList.Create;
            try // try3
              if ColWidths.Capacity < NCOL then
              begin
                ColWidths.Capacity := NCOL;
              end;
              if RowWidths.Capacity < NROW then
              begin
                RowWidths.Capacity := NROW;
              end;
              for ColIndex := 0 to NCOL - 1 do
              begin
                AWidth := GetDELR(ColIndex);
                ColWidths.Add(AWidth);
                if AWidth > MaxWidth then
                begin
                  MaxWidth := AWidth;
                end;
              end;
              for RowIndex := 0 to NROW - 1 do
              begin
                AWidth := GetDELC(RowIndex);
                RowWidths.Add(AWidth);
                if AWidth > MaxWidth then
                begin
                  MaxWidth := AWidth;
                end;
              end;

              AGrid.Free;
              AGrid := T2DBlockCenteredGrid.Create(ColWidths, RowWidths,
                InternationalStrToFloat(adeOrX.Text),
                  InternationalStrToFloat(adeOrY.Text),
                InternationalStrToFloat(adeGridAngle.Text) * Pi / 180,
                cbRowsPositive.Checked, cbColumnsPositive.Checked, self);

              for StressPeriodIndex := 0 to NPER - 1 do
              begin
                CallInit(StressPeriodIndex, Init);

                APeriodInfo := TPeriodInfo.Create;
                TimeInfoList.Add(APeriodInfo);
                APeriodInfo.NSTP := NSTP;
                APeriodInfo.TSMULT := TSMULT;
                APeriodInfo.DELT := DELT;
                SetStressPeriodValues(StressPeriodIndex + 1, APeriodInfo);

                if (IUNITX[4] <> 0) or (IUNITX[7] <> 0) then
                begin
                  try
                    if (IUNITX[4] <> 0) then
                    begin
                      for ColIndex := 0 to NCOL - 1 do
                      begin
                        for RowIndex := 0 to NROW - 1 do
                        begin
                          AGrid.EvapSurface[ColIndex, RowIndex,
                            StressPeriodIndex]
                            := GetSURF(ColIndex, RowIndex);
                          AGrid.EvapRate[ColIndex, RowIndex, StressPeriodIndex]
                            := GetEVTR(ColIndex, RowIndex);
                          AGrid.EvapExtDepth[ColIndex, RowIndex,
                            StressPeriodIndex]
                            := GetEXDP(ColIndex, RowIndex);
                          if NEVTOP = 2 then
                          begin
                            AGrid.EvapLayer[ColIndex, RowIndex,
                              StressPeriodIndex]
                              := GetIEVT(ColIndex, RowIndex);
                          end;
                        end;
                      end;
                    end;
                  except
                    Beep;
                    MessageDlg('Error reading Evapotranspiration package input',
                      mtError, [mbOK], 0);
                    raise;
                  end;
                  try
                    if (IUNITX[7] <> 0) then
                    begin
                      for ColIndex := 0 to NCOL - 1 do
                      begin
                        for RowIndex := 0 to NROW - 1 do
                        begin
                          AGrid.RechRate[ColIndex, RowIndex, StressPeriodIndex]
                            := GetRECH(ColIndex, RowIndex);
                          if NRCHOP = 2 then
                          begin
                            AGrid.RechLayer[ColIndex, RowIndex,
                              StressPeriodIndex]
                              := GetIRCH(ColIndex, RowIndex);
                          end;
                        end;
                      end;
                    end;
                  except
                    Beep;
                    MessageDlg('Error reading Recharge package input',
                      mtError, [mbOK], 0);
                    raise;
                  end;
                end;

              end;

              try
                AGrid.MakeHFBBoundaries;
              except
                Beep;
                MessageDlg('Error reading Horizontal Flow Barrier package input',
                  mtError, [mbOK], 0);
                raise;
              end;
              for StressPeriodIndex := 0 to NPER - 1 do
              begin
                CallInit(StressPeriodIndex, Init);
                try
                  AGrid.MakeWellBoundaries(StressPeriodIndex);
                except
                  Beep;
                  MessageDlg('Error reading Well package input in stress period '
                    + IntToStr(StressPeriodIndex + 1),
                    mtError, [mbOK], 0);
                  raise;
                end;
                try
                  AGrid.MakeDrainBoundaries(StressPeriodIndex);
                except
                  Beep;
                  MessageDlg('Error reading Drain package input in stress period '
                    + IntToStr(StressPeriodIndex + 1),
                    mtError, [mbOK], 0);
                  raise;
                end;
                try
                  AGrid.MakeRiverBoundaries(StressPeriodIndex);
                except
                  Beep;
                  MessageDlg('Error reading River package input in stress period '
                    + IntToStr(StressPeriodIndex + 1),
                    mtError, [mbOK], 0);
                  raise;
                end;
                try
                  AGrid.MakeStreamBoundaries(StressPeriodIndex);
                except
                  Beep;
                  MessageDlg('Error reading Stream package input in stress period '
                    + IntToStr(StressPeriodIndex + 1),
                    mtError, [mbOK], 0);
                  raise;
                end;
                try
                  AGrid.MakeFHBFlowBoundaries(StressPeriodIndex);
                  AGrid.MakeFHBHeadBoundaries(StressPeriodIndex);
                except
                  Beep;
                  MessageDlg('Error reading Flow and Head Boundary package input in stress period '
                    + IntToStr(StressPeriodIndex + 1),
                    mtError, [mbOK], 0);
                  raise;
                end;
                try
                  AGrid.MakeGHBBoundaries(StressPeriodIndex);
                except
                  Beep;
                  MessageDlg('Error reading General-Head Boundary package input in stress period '
                    + IntToStr(StressPeriodIndex + 1),
                    mtError, [mbOK], 0);
                  raise;
                end;
              end;

            finally // try3
              ColWidths.Free;
              RowWidths.Free;
            end; // try3

            SetDataItems;
          end; // if @Init <> nil then
        end; // try1
      finally
        begin
          Screen.Cursor := crDefault;
        end;
      end;
    end;
  end;
end;

procedure TfrmModflowImport.SetStressPeriodValues(Period: integer;
  PeriodInfo: TPeriodInfo);
begin
  with frmModflow do
  begin
    dgTime.Cells[Ord(tdLength), Period] := FloatToStr(PeriodInfo.PERLEN);
    dgTime.Cells[Ord(tdNumSteps), Period] := FloatToStr(PeriodInfo.NSTP);
    dgTime.Cells[Ord(tdMult), Period] := FloatToStr(PeriodInfo.TSMULT);
  end;
end;

procedure TfrmModflowImport.SetValues;
const
  MaxFactor = 4;
  EnglishFactors: array[0..MaxFactor] of double = (1.486, 89.16, 5349.6,
    128390.4, 46784593);
  MetricFactors: array[0..MaxFactor] of double = (1., 60., 3600.,
    86400., 31447600);
  function IsNearlySame(Val1, Val2: double): boolean;
  const
    Epsilon = 1E-3;
  begin
    result := (Val1 = Val2);
    if not result then
    begin
      result := Abs((Val1 - Val2) / (Val1 + Val2)) < Epsilon;
    end;
  end;
  procedure ComboChange(AComboBox: TComboBox);
  begin
    if Assigned(AComboBox.OnChange) then
    begin
      AComboBox.OnChange(AComboBox);
    end;
  end;
var
  FactorIndex, UnitIndex: integer;
  LayCon1stDigit, LayCon2ndDigit: integer;
  Col, Row: integer;
  CanSelect: Boolean;
  GeoValue: string;
begin
  with frmModflow do
  begin
    if IAPART = 0 then
    begin
      comboIAPART.itemIndex := 0
    end
    else
    begin
      comboIAPART.itemIndex := 1
    end;
    ComboChange(comboIAPART);

    cbCHTOCH.Checked := ICHFLG <> 0;

    if ISTRT = 0 then
    begin
      comboISTRT.ItemIndex := 0;
    end
    else
    begin
      comboISTRT.ItemIndex := 1;
    end;
    ComboChange(comboISTRT);

    if (ITMUNI < 6) and (ITMUNI > -1) then
    begin
      comboTimeUnits.ItemIndex := ITMUNI;
    end
    else
    begin
      comboTimeUnits.ItemIndex := 0;
    end;
    ComboChange(comboTimeUnits);

    edNumUnitsEnter(nil);
    edNumUnits.Text := IntToStr(NLAY);
    edNumUnitsExit(edNumUnits);

    if ISS = 0 then
    begin
      comboSteady.ItemIndex := 0;
    end
    else
    begin
      comboSteady.ItemIndex := 1;
    end;
    ComboChange(comboSteady);

    for UnitIndex := 0 to NLAY - 1 do
    begin
      LayCon1stDigit := LAYAVGX[UnitIndex] div 10;
      LayCon2ndDigit := LAYCOX[UnitIndex];
      Assert((LayCon1stDigit > -1) and (LayCon1stDigit < 4));
      Assert((LayCon2ndDigit > -1) and (LayCon2ndDigit < 4));

      Row := UnitIndex + 1;

      Col := Ord(nuiSim);
      GeoValue := dgGeol.Columns[Col].PickList[1];
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiTrans);
      GeoValue := dgGeol.Columns[Col].PickList[LayCon1stDigit];
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiType);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      GeoValue := dgGeol.Columns[Col].PickList[LayCon2ndDigit];
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      if (rgFlowPackage.ItemIndex = 0) and (LayCon2ndDigit = 0) then
      begin
        Col := Ord(nuiSpecT);
        dgGeol.Cells[Col, Row] := dgGeol.Columns[Col].PickList[1]
      end;

      Col := Ord(nuiAnis);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      GeoValue := FloatToStr(GetTRPY(UnitIndex));
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiVertDisc);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      GeoValue := '1';
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiSpecVCONT);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      if UnitIndex < NLAY - 1 then
      begin
        GeoValue := dgGeol.Columns[Col].PickList[1];
      end
      else
      begin
        GeoValue := dgGeol.Columns[Col].PickList[0];
      end;
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      CanSelect := True;
      Col := Ord(nuiSpecT);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      if CanSelect then
      begin
        GeoValue := dgGeol.Columns[Col].PickList[1];
        dgGeol.Cells[Col, Row] := GeoValue;
        dgGeolSetEditText(dgGeol, Col, Row, GeoValue);
      end;

      CanSelect := True;
      Col := Ord(nuiSpecSF1);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      if CanSelect then
      begin
        GeoValue := dgGeol.Columns[Col].PickList[1];
        dgGeol.Cells[Col, Row] := GeoValue;
        dgGeolSetEditText(dgGeol, Col, Row, GeoValue);
      end;
    end;

    edNumPerEnter(nil);
    edNumPer.Text := IntToStr(NPER);
    edNumPerExit(edNumPer);

    if IHDWET = 0 then
    begin
      comboWetEq.ItemIndex := 0;
    end
    else
    begin
      comboWetEq.ItemIndex := 1;
    end;
    ComboChange(comboWetEq);

    if IWDFLG = 0 then
    begin
      comboWetCap.ItemIndex := 0;
    end
    else
    begin
      comboWetCap.ItemIndex := 1;
    end;
    ComboChange(comboWetCap);

    adeWetIterations.Text := IntToStr(IWETIT);

    if cbEVT.Checked then
    begin
      if (NEVTOP > 0) and (NEVTOP < 4) then
      begin
        comboEvtOption.ItemIndex := NEVTOP - 1;
      end
      else
      begin
        comboEvtOption.ItemIndex := 0;
      end;
      ComboChange(comboEvtOption);
      if cbETLayer.Enabled then
      begin
        cbETLayer.Checked := True;
      end;
    end;

    if cbRCH.Checked then
    begin
      if (NRCHOP > 0) and (NRCHOP < 4) then
      begin
        comboRchOpt.ItemIndex := NRCHOP - 1;
        if NRCHOP = 2 then
        begin
        end;
      end
      else
      begin
        comboRchOpt.ItemIndex := 0
      end;
      ComboChange(comboRchOpt);
      if cbRechLayer.Enabled then
      begin
        cbRechLayer.Checked := True;
      end;
    end;

    if SolverFound then
    begin

      case frmModflow.rgSolMeth.ItemIndex of
        0: // SIP
          begin
            adeSIPMaxIter.Text := IntToStr(MXITER);
            adeSIPNumParam.Text := IntToStr(NPARM);
            if IPCALC = 0 then
            begin
              comboSIPIterSeed.ItemIndex := 0;
            end
            else
            begin
              comboSIPIterSeed.ItemIndex := 1;
            end;
            ComboChange(comboSIPIterSeed);
            adeSIPPrint.Text := IntToStr(IPRSIP);
            adeSIPAcclParam.Text := FloatToStr(ACCL);
            adeSIPConv.Text := FloatToStr(HCLOSE);
            adeSIPIterSeed.Text := FloatToStr(WSEED);
          end;
        1: // DE4
          begin
            adeDE4MaxUp.Text := IntToStr(MXUP);
            adeDE4MaxLow.Text := IntToStr(MXLOW);
            adeDE4Band.Text := IntToStr(MXBW);
            adeDE4MaxIter.Text := IntToStr(ITMX);
            if (IFREQ > 0) and (IFREQ < 4) then
            begin
              comboDE4Freq.ItemIndex := IFREQ - 1;
            end
            else
            begin
              comboDE4Freq.ItemIndex := 0;
            end;
            ComboChange(comboDE4Freq);
            adeDE4TimeStep.Text := IntToStr(IPRD4);
            if (MUTD4 > -1) and (MUTD4 < 3) then
            begin
              comboDE4Print.ItemIndex := IFREQ;
            end
            else
            begin
              comboDE4Print.ItemIndex := 0;
            end;
            ComboChange(comboDE4Print);
            adeDE4Accl.Text := FloatToStr(ACCL);
            adeDE4Conv.Text := FloatToStr(HCLOSE);
          end;
        2: // PCG2
          begin
            adePCGMaxOuter.Text := IntToStr(MXITER);
            adePCGMaxInner.Text := IntToStr(ITER1);
            if (NPCOND > 0) and (NPCOND < 3) then
            begin
              comboPCGPrecondMeth.ItemIndex := NPCOND - 1;
            end
            else
            begin
              comboPCGPrecondMeth.ItemIndex := 0;
            end;
            ComboChange(comboPCGPrecondMeth);
            if (NBPOL > 0) and (NBPOL < 3) then
            begin
              comboPCGEigenValue.ItemIndex := NBPOL - 1;
            end
            else
            begin
              comboPCGEigenValue.ItemIndex := 0;
            end;
            ComboChange(comboPCGEigenValue);
            adePCGPrintInt.Text := IntToStr(IPRPCG);
            if (MUTPCG > -1) and (MUTPCG < 4) then
            begin
              comboPCGPrint.ItemIndex := MUTPCG;
            end
            else
            begin
              comboPCGPrint.ItemIndex := 0;
            end;
            ComboChange(comboPCGPrint);
            adePCGMaxHeadChange.Text := FloatToStr(HCLOSE);
            adePCGMaxResChange.Text := FloatToStr(RCLOSE);
            adePCGRelax.Text := FloatToStr(RELAX);
            adePCGDamp.Text := FloatToStr(DAMP);
          end;
        3: // SOR
          begin
            adeSORMaxIter.Text := IntToStr(MXITER);
            adeSORPri.Text := IntToStr(IPRSOR);
            adeSORAccl.Text := FloatToStr(ACCL);
            adeSORConv.Text := FloatToStr(HCLOSE);
          end;
      else
        Assert(False);
      end;
    end;
    if cbRES.Checked then
    begin
      if (NRESOP > 0) and (NRESOP < 4) then
      begin
        comboResOption.ItemIndex := NRESOP - 1;
      end
      else
      begin
        comboResOption.ItemIndex := 0;
      end;
      ComboChange(comboResOption);
      if cbRESLayer.Enabled then
      begin
        cbRESLayer.Checked := True;
      end;
    end;
    if cbFHB.Checked then
    begin
      if (IFHBSS > -1) and (IFHBSS < 2) then
      begin
        comboFHBSteadyStateOption.ItemIndex := IFHBSS;
      end
      else
      begin
        comboFHBSteadyStateOption.ItemIndex := 0;
      end;
      ComboChange(comboFHBSteadyStateOption);
      adeFHBNumTimesEnter(adeFHBNumTimes);
      adeFHBNumTimes.Text := IntToStr(NBDTIM);
      adeFHBNumTimesExit(adeFHBNumTimes);
    end;
    if cbSTR.Checked then
    begin
      cbStreamDiversions.Checked := NDIV > 0;
      cbStreamCalcFlow.Checked := ICALC > 0;
      cbStreamTrib.Checked := NTRIB > 0;
      for FactorIndex := 0 to MaxFactor do
      begin
        if IsNearlySame(StrCONST, EnglishFactors[FactorIndex]) then
        begin
          comboModelUnits.ItemIndex := 1;
          break;
        end;
        if IsNearlySame(StrCONST, MetricFactors[FactorIndex]) then
        begin
          comboModelUnits.ItemIndex := 0;
          break;
        end;
        ComboChange(comboModelUnits);
      end;
    end;
    adeWettingFact.Text := FloatToStr(WETFCT);
    adeHNOFLO.Text := FloatToStr(HNOFLO);
    adeTitle1.Text := HEADX1;
    adeTitle2.Text := HEADX2;

  end;
end;

procedure TfrmModflowImport.CallInit(StressPeriod: integer; Init: TInit);
var
  {    IDLLPE  is the stress period for which data is desired.}
  IDLLPE: longint;
  Index: integer;
  len1, len2: longint;
begin
  IDLLPE := StressPeriod + 1;
  HEADX1 := '';
  for index := 1 to 81 do
  begin
    HEADX1 := HEADX1 + ' ';
  end; // for index := 1 to 81 do

  HEADX2 := HEADX1;
  len1 := length(HEADX1);
  len2 := length(HEADX2);
  {get data from modflw96.dll.}
  INIT(IAPART, ICHFLG, ISTRT, ISUM, ITMUNI, LCIBOU,
    LCSTRT, NCOL, NLAY, NPER, NROW, NSTP, ISS, IHDWET, IWDFLG,
    IWETIT, LCBOT, LCCC, LCCV, LCDELC, LCDELR, LCHY, LCSC1, LCSC2,
    LCTOP, LCTRPY, LCWETD, IWELAL, LCWELL, MXWELL, NWELVL, NWELLS,
    IDRNAL, LCDRAI, MXDRN, NDRAIN, NDRNVL, LCRIVR, MXRIVR, NRIVER,
    NRIVVL, IRIVAL, LCIEVT, LCEVTR, LCEXDP, LCSURF, NEVTOP, LCBNDS,
    NBOUND, MXBND, NGHBVL, IGHBAL, LCIRCH, LCRECH, NRCHOP, MXITER,
    NPARM, IPCALC, IPRSIP, MXUP, MXLOW, MXBW, ITMX, IFREQ, IPRD4,
    MUTD4, IPRSOR, ITER1, NPCOND, NBPOL, IPRPCG, MUTPCG, {INBAS,} NRESOP,
    IFHBCB, IFHBD3, IFHBD4, IFHBD5, IFHBSS, LCFLLC, LCBDTM,
    LCFLRT, LCHDLC, LCSBHD, NBDTIM, NFHBX1, NFHBX2, NFLW, NHED,
    LCHFBR, NHFB, MXSTRM, NSTREM, ISTCB1, ISTCB2, NSS, NTRIB, NDIV, ICALC,
    LCSTRM, LCTBAR, LCTRIB, LCIVAR, ICSTRM,
    IDLLPE,
    WETFCT, TSMULT, ACCL, HCLOSE, RCLOSE, RELAX, DAMP,
    WSEED, StrCONST, DELT, HDRY, HNOFLO,
    LAYCOX, LAYAVGX, IUNITX,
    HEADX1, HEADX2, len1, len2);
end;

function TfrmModflowImport.GetDELR(Col: Integer): Single;
var
  I: longInt;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    I := Col + 1;
    mf2kInterface.GetDELR(I, MF2K_Importer.NCOL, result);
  end
  else
  begin
    result := xx[Get1DIndex(NCOL, Col, LCDELR)];
  end;
end;

function TfrmModflowImport.GetDELC(Row: Integer): Single;
var
  I: longInt;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    I := Row + 1;
    mf2kInterface.GetDELC(I, MF2K_Importer.NROW, result);
  end
  else
  begin
    result := xx[Get1DIndex(NROW, Row, LCDELC)];
  end;

end;

function TfrmModflowImport.GetSURF(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetSURF(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
  end
  else
  begin
    result := xx[Get2DIndex(NCOL, NROW, Col, Row, LCSURF)];
  end;
end;

function TfrmModflowImport.GetEVTR(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetEVTR(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
  end
  else
  begin
    result := xx[Get2DIndex(NCOL, NROW, Col, Row, LCEVTR)];
  end;
end;

function TfrmModflowImport.GetEXDP(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetEXDP(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
  end
  else
  begin
    result := xx[Get2DIndex(NCOL, NROW, Col, Row, LCEXDP)];
  end;
end;

function TfrmModflowImport.GetIEVT(Col, Row: Integer): Single;
var
  IResult: longint;
  ICol, IRow: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetIEVT(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, IResult);
    result := IResult;
  end
  else
  begin
    result := xx[Get2DIndex(NCOL, NROW, Col, Row, LCIEVT)];
  end;
end;

function TfrmModflowImport.GetIEVT(Col, Row, StressPeriodIndex: Integer):
  Single;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    if self.MF2K_Importer.NEVTOP = 2 then
    begin
      Assert((Col >= 0) and (Col <= NCOL) and (Row >= 0) and (NROW <= NROW)
        and (StressPeriodIndex >= 0) and (StressPeriodIndex <= NPER));
      result := AGrid.EvapLayer[Col, Row, StressPeriodIndex]
    end
    else
    begin
      result := 1;
    end;
  end
  else
  begin
    if NEVTOP = 2 then
    begin
      Assert((Col >= 0) and (Col <= NCOL) and (Row >= 0) and (NROW <= NROW)
        and (StressPeriodIndex >= 0) and (StressPeriodIndex <= NPER));
      result := AGrid.EvapLayer[Col, Row, StressPeriodIndex]
    end
    else
    begin
      result := 1;
    end;
  end;
end;

function TfrmModflowImport.GetIETS(Col, Row: Integer): Single;
var
  ICol, IRow, IResult: longint;
begin
  Assert(rgModelType.ItemIndex = 2);
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetIETS(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, IResult);
    result := IResult;
end;

function TfrmModflowImport.GetETSR(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  Assert(rgModelType.ItemIndex = 2);
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetETSR(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
end;

function TfrmModflowImport.GetETSX(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  Assert(rgModelType.ItemIndex = 2);
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetETSX(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
end;

function TfrmModflowImport.GetETSS(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  Assert(rgModelType.ItemIndex = 2);
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetETSS(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
end;

function TfrmModflowImport.GetPXDP(Col, Row, Seg: Integer): Single;
var
  ICol, IRow, ISeg: longint;
begin
  Assert(rgModelType.ItemIndex = 2);
    ICol := Col + 1;
    IRow := Row + 1;
    ISeg := Seg;
    mf2kInterface.GetPXDP(ICol, IRow, ISeg, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NETSEG, result);
end;

function TfrmModflowImport.GetPETM(Col, Row, Seg: Integer): Single;
var
  ICol, IRow, ISeg: longint;
begin
  Assert(rgModelType.ItemIndex = 2);
    ICol := Col + 1;
    IRow := Row + 1;
    ISeg := Seg;
    mf2kInterface.GetPETM(ICol, IRow, ISeg, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NETSEG, result);
end;

function TfrmModflowImport.GetRECH(Col, Row: Integer): Single;
var
  ICol, IRow: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetRECH(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, result);
  end
  else
  begin
    result := xx[Get2DIndex(NCOL, NROW, Col, Row, LCRECH)];
  end;
end;

function TfrmModflowImport.GetRECH(Col, Row, StressPeriodIndex: Integer):
  Single;
begin
  Assert((Col >= 0) and (Col <= NCOL) and (Row >= 0) and (NROW <= NROW)
    and (StressPeriodIndex >= 0) and (StressPeriodIndex <= NPER));
  result := AGrid.RechRate[Col, Row, StressPeriodIndex]
end;

function TfrmModflowImport.GetIRCH(Col, Row: Integer): Single;
var
  IResult: longint;
  ICol, IRow: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IRow := Row + 1;
    mf2kInterface.GetIRCH(ICol, IRow, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, IResult);
    result := IResult;
  end
  else
  begin
    result := xx[Get2DIndex(NCOL, NROW, Col, Row, LCIRCH)];
  end;
end;

function TfrmModflowImport.GetIRCH(Col, Row, StressPeriodIndex: Integer):
  Single;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    if self.MF2K_Importer.NRCHOP = 2 then
    begin
      result := AGrid.RechLayer[Col, Row, StressPeriodIndex]
    end
    else
    begin
      result := 1;
    end;
  end
  else
  begin
    if NRCHOP = 2 then
    begin
      result := AGrid.RechLayer[Col, Row, StressPeriodIndex]
    end
    else
    begin
      result := 1;
    end;
  end;
end;

procedure TfrmModflowImport.SetDataItems;
var
  LayerIndex, TimeIndex: integer;
  ImportLayer: TImportLayer;
  Name: string;
  Width: double;
  temp: double;
  Index: integer;
  ALayer: T_ANE_InfoLayer;
  AParam: T_ANE_Param;
  ALayerList: T_ANE_LayerList;
  ParameterList: T_ANE_ParameterList;
begin
  Width := 0;
  with AGrid do
  begin
    with ColPositions do
    begin
      for Index := 1 to Count - 1 do
      begin
        temp := Abs(Items[Index - 1] - Items[Index]);
        if temp > Width then
        begin
          Width := temp;
        end;
      end;
    end;
    with RowPositions do
    begin
      for Index := 1 to Count - 1 do
      begin
        temp := Abs(Items[Index - 1] - Items[Index]);
        if temp > Width then
        begin
          Width := temp;
        end;
      end;
    end;
  end;

  ImportLayer := TImportLayer.Create;
  ImportLayerList.Add(ImportLayer);
  ImportLayer.LayerIndex := 0;
  ImportLayer.LayerName := ModflowTypes.GetMFDomainOutType.ANE_LayerName;
  ImportLayer.ImportMethod := imDomainOutline;
  ImportLayer.GridDensity := Width;
  ImportLayer.FunctionList.Add(GetActiveCell, False);
  ImportLayer.LinkedLayerList.Add(nil);
  ImportLayer.LinkedParameterList.Add(nil);
  ImportLayer.ExtraExpressionList.Add('');
  ImportLayer.ExtraEndExpressionList.Add('');
  ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);

  for LayerIndex := 1 to NLAY do
  begin
    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);
    ImportLayer.LayerIndex := LayerIndex;
    ImportLayer.LayerName := ModflowTypes.GetInactiveLayerType.ANE_LayerName
      + IntToStr(LayerIndex);
    ImportLayer.ImportMethod := imZones;
    ImportLayer.FunctionList.Add(GetIboundSign, False);
    ImportLayer.LinkedLayerList.Add(nil);
    ImportLayer.LinkedParameterList.Add(nil);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');
    ImportLayer.UseFunctionList.Add(IsCell);

    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);
    ImportLayer.LayerIndex := LayerIndex;
    ImportLayer.LayerName
      := ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
      + IntToStr(LayerIndex);
    ImportLayer.ImportMethod := imPointContours;
    ImportLayer.FunctionList.Add(GetSHead, False);
    ImportLayer.LinkedLayerList.Add(nil);
    ImportLayer.LinkedParameterList.Add(nil);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');
    ImportLayer.UseFunctionList.Add(IsPrescribedHeadCell);

    ALayerList := frmModflow.MFLayerStructure.ListsOfIndexedLayers.
      Items[LayerIndex - 1];

    ALayer := ALayerList.GetLayerByName(ModflowTypes.GetInitialHeadLayerType.
      ANE_LayerName) as T_ANE_InfoLayer;
    Assert(ALayer <> nil);
    AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
      GetMFInitialHeadParamType.ANE_ParamName);
    Assert(AParam <> nil);
    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);
    ImportLayer.LayerIndex := LayerIndex;
    Name := 'Imported Initial Head Unit' + IntToStr(LayerIndex);
    ImportLayer.LayerName := 'Imported MODFLOW Data' + IntToStr(LayerIndex);
    ImportLayer.ParameterNames.Add(Name);
    ImportLayer.ImportMethod := imDataLayer;
    ImportLayer.FunctionList.Add(GetSHead, False);
    ImportLayer.LinkedLayerList.Add(ALayer);
    ImportLayer.LinkedParameterList.Add(AParam);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');
    ImportLayer.UseFunctionList.Add(IsActiveCell);

    if IUNITX[0] <> 0 then
    begin
      // ISS = 0 for transient simulations.
      if ISS = 0 then
      begin
        if (LAYCOX[LayerIndex - 1] = 0) or
          (LAYCOX[LayerIndex - 1] = 2) or
          (LAYCOX[LayerIndex - 1] = 3) then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFConfStorageLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFConfStorageParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported confined Storage Unit' + IntToStr(LayerIndex);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC1, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end
        else if (LAYCOX[LayerIndex - 1] = 1) then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFSpecYieldLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFSpecYieldParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported Specific Yield Unit' + IntToStr(LayerIndex);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC1, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
        if (LAYCOX[LayerIndex - 1] = 2) or
          (LAYCOX[LayerIndex - 1] = 3) then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFSpecYieldLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFSpecYieldParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported Specific Yield Unit' + IntToStr(LayerIndex);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC2, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;

      end;
      if (LAYCOX[LayerIndex - 1] = 0) or
        (LAYCOX[LayerIndex - 1] = 2) then
      begin
        ALayer :=
          ALayerList.GetLayerByName(ModflowTypes.GetMFTransmisivityLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFTransmisivityParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported Transmissivity Unit' + IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetTrans, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if (LAYCOX[LayerIndex - 1] = 1) or
        (LAYCOX[LayerIndex - 1] = 3) then
      begin
        ALayer :=
          ALayerList.GetLayerByName(ModflowTypes.GetHydraulicCondLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFKxParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported Horizontal Hydraulic Conductivity Unit' +
          IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetHY, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if (LAYCOX[LayerIndex - 1] = 1) or
        (LAYCOX[LayerIndex - 1] = 3) then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetBottomElevLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFBottomElevParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported Bottom Unit' + IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetBOT, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if (LAYCOX[LayerIndex - 1] = 2) or
        (LAYCOX[LayerIndex - 1] = 3) then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFTopElevLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFTopElevParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported Top Unit' + IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetTOP, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if LayerIndex < NLAY then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFVcontLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFVcontParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported VCONT Unit' + IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetVCONT, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if IWDFLG <> 0 then
      begin
        if (LAYCOX[LayerIndex - 1] = 1) or
          (LAYCOX[LayerIndex - 1] = 3) then
        begin
          ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFWettingThreshParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported WetDry Threshhold Unit' + IntToStr(LayerIndex);
          ImportLayer.LayerName := Name;
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.ImportMethod := imDataLayer;
          ImportLayer.FunctionList.Add(GetWETDRYThreshhold, False);
          ImportLayer.UseFunctionList.Add(IsActiveCell);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');

          ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFWettingFlagParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported WetDry Flag Unit' + IntToStr(LayerIndex);
          ImportLayer.LayerName := Name;
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.ImportMethod := imZones;
          ImportLayer.FunctionList.Add(GetWETDRYFlag, False);
          ImportLayer.UseFunctionList.Add(IsActiveCell);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end; // If IWDFLG <>0 then
    end;
    ALayerList := frmModflow.MFLayerStructure.UnIndexedLayers;
    if LayerIndex = 1 then
    begin
      if IUNITX[4] <> 0 then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetETLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := LayerIndex;
        Name := 'Imported Evapotranspiration';
        ImportLayer.LayerName := Name;
        ImportLayer.ParameterNames.Add('ET Surface');
        ImportLayer.ParameterNames.Add('ET Extinction Depth');
        ImportLayer.ImportMethod := imDataLayer;
        ImportLayer.FunctionList.Add(GetSURF, False);
        ImportLayer.FunctionList.Add(GetEXDP, False);
        ImportLayer.TimeFunctionList.Add(GetEVTR, False);
        ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedLayerList.Add(ALayer);

        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFETSurfaceParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFETExtDepthParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
        for TimeIndex := 1 to NPER do
        begin
          ImportLayer.ParameterNames.Add('Evapotranspiration Rate' +
            IntToStr(TimeIndex));
          ParameterList := ALayer.IndexedParamList2.Items[TimeIndex - 1];
          AParam := ParameterList.GetParameterByName(ModflowTypes.
            GetMFETExtFluxParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;

        if NEVTOP = 2 then
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported ET Layer';
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.LayerName := Name;
          ImportLayer.ImportMethod := imZones;
          ImportLayer.FunctionList.Add(GetIEVT, False);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFModflowLayerParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;

      if IUNITX[7] <> 0 then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetRechargeLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := LayerIndex;
        Name := 'Imported Recharge';
        ImportLayer.LayerName := Name;
        ImportLayer.ImportMethod := imDataLayer;
        ImportLayer.TimeFunctionList.Add(GetRECH, False);
        for TimeIndex := 1 to NPER do
        begin
          ImportLayer.ParameterNames.Add('Recharge Rate' + IntToStr(TimeIndex));
          ParameterList := ALayer.IndexedParamList2.Items[TimeIndex - 1];
          AParam := ParameterList.GetParameterByName(ModflowTypes.
            GetMFRechStressParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
        ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);

        if NRCHOP = 2 then
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported Recharge Layer';
          ImportLayer.LayerName := Name;
          ImportLayer.ImportMethod := imZones;
          ImportLayer.ParameterNames.Add(Name);
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.FunctionList.Add(GetIRCH, False);
          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFModflowLayerParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;
    end;
  end;
end;

procedure TfrmModflowImport.ExportGrid;
var
  Position1, Position2: extended;
  AStringList: TStringList;
  Index: integer;
  LayerName: string;
  LayerHandle: ANE_PTR;
  Project: TProjectOptions;
  GridLayer: TLayerOptions;
  Angle: double;
  OriginX, OriginY: double;
begin
  if (AGrid <> nil) then
  begin
    try
      Screen.Cursor := crHourGlass;

      Angle := InternationalStrToFloat(adeGridAngle.Text) * Pi / 180;
      OriginX := InternationalStrToFloat(adeOrX.Text);
      OriginY := InternationalStrToFloat(adeOrY.Text);
      if not cbColumnsPositive.Checked then
      begin
        Position1 := AGrid.ColPositions.Items[0];
        Position2 := AGrid.ColPositions.Items[AGrid.ColPositions.Count - 1];
        OriginY := (OriginY + (Position2 - Position1) * Sin(Angle));
        OriginX := (OriginX + (Position2 - Position1) * Cos(Angle));
      end;
      if not cbRowsPositive.Checked then
      begin
        Position1 := AGrid.RowPositions.Items[0];
        Position2 := AGrid.RowPositions.Items[AGrid.RowPositions.Count - 1];
        OriginY := (OriginY + (Position2 - Position1) * Cos(Angle));
        OriginX := (OriginX - (Position2 - Position1) * Sin(Angle));
      end;

      AStringList := TStringList.Create;
      try
        AStringList.Add(IntToStr(AGrid.RowPositions.Count - 1) + Chr(9) +
          IntToStr(AGrid.ColPositions.Count - 1) + Chr(9) + '0' + Chr(9) +
          adeGridAngle.Text);

        AStringList.Add(InternationalFloatToStr(OriginY));
        Position2 := 0;
        if cbRowsPositive.Checked then
        begin
          Position2 := 0;
          for Index := 0 to AGrid.RowPositions.Count - 1 do
          begin
            Position1 := AGrid.RowPositions.Items[Index];
            if Index <> 0 then
            begin
              AStringList.Add(InternationalFloatToStr(Position1 - Position2));
            end;
            Position2 := Position1;
          end;
        end
        else
        begin
          for Index := AGrid.RowPositions.Count - 1 downto 0 do
          begin
            Position1 := AGrid.RowPositions.Items[Index];
            if Index <> AGrid.RowPositions.Count - 1 then
            begin
              AStringList.Add(InternationalFloatToStr(Position1 - Position2));
            end;
            Position2 := Position1;
          end;
        end;
        AStringList.Add('');

        AStringList.Add(InternationalFloatToStr(OriginX));
        Position2 := 0;
        if cbColumnsPositive.Checked then
        begin
          for Index := 0 to AGrid.ColPositions.Count - 1 do
          begin
            Position1 := AGrid.ColPositions.Items[Index];
            if Index <> 0 then
            begin
              AStringList.Add(InternationalFloatToStr(Position1 - Position2));
            end;
            Position2 := Position1;
          end;
        end
        else
        begin
          Position2 := 0;
          for Index := AGrid.ColPositions.Count - 1 downto 0 do
          begin
            Position1 := AGrid.ColPositions.Items[Index];
            if Index <> AGrid.ColPositions.Count - 1 then
            begin
              AStringList.Add(InternationalFloatToStr(Position1 - Position2));
            end;
            Position2 := Position1;
          end;
        end;
        AStringList.Add('');
        LayerName := 'MODFLOW FD Grid';
        Project := TProjectOptions.Create;
        try
          LayerHandle := Project.GetLayerByName(CurrentModelHandle, LayerName);
        finally
          Project.Free;
        end;

        if LayerHandle <> nil then
        begin
          GridLayer := nil;
          try
            GridLayer := TLayerOptions.Create(LayerHandle);
            GridLayer.GridReverseXDirection[CurrentModelHandle]
              := not cbColumnsPositive.Checked;
            GridLayer.GridReverseYDirection[CurrentModelHandle]
              := not cbRowsPositive.Checked;
          finally
            GridLayer.Free(CurrentModelHandle);
          end;

          ImportText(AStringList, LayerHandle);
        end;
      finally
        AStringList.Free;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;


procedure TfrmModflowImport.ImportText(Strings: TStringList; layerHandle:
  ANE_PTR);
var
  ImportText: string;
  AString: ANE_STR;
begin
  ImportText := GetArgusStr(Strings);
  if ImportText = '' then
  begin
    Exit;
  end;


  ANE_LayerClear(CurrentModelHandle, layerHandle, False);
  GetMem(AString, Length(ImportText) + 1);
  try
    StrPCopy(AString, ImportText);
    ANE_ImportTextToLayerByHandle(CurrentModelHandle, layerHandle, AString);
    ANE_ProcessEvents(CurrentModelHandle);
  finally
    FreeMem(AString);
  end;
end;

procedure TfrmModflowImport.MakeGridDensity;
  function IsNearlySame(Val1, Val2: double): boolean;
  const
    Epsilon = 1E-7;
  begin
    result := (Val1 = Val2);
    if not result then
    begin
      result := Abs((Val1 - Val2) / (Val1 + Val2)) < Epsilon;
    end;
  end;
const
  Epsilon = 1E-6;
var
  MinX, MaxX, MinY, MaxY: extended;
  Position1, Position2: extended;
  XOffSet1, XOffSet2, YOffset1, YOffset2: double;
  Width1, Width2: extended;
  PositionIndex: integer;
  LowerPosition: boolean;
  AnEditContours: TEditContours;
  AContour: TContour2;
  ARealValue: TRealValue;
  X1, Y1, X2, Y2: extended;
  APoint: TPoint;
  ContourStringList: TStringList;
  CellCount: integer;
  LayerName: string;
  LayerHandle: ANE_PTR;
  Project: TProjectOptions;
begin
  if (AGrid <> nil) then
  begin
    try
      Screen.Cursor := crHourGlass;
      Position1 := AGrid.ColPositions.Items[0];
      Position2 := AGrid.ColPositions.Items[AGrid.ColPositions.Count - 1];
      MinX := Min(Position1, Position2);
      MaxX := Max(Position1, Position2);
      Position1 := AGrid.RowPositions.Items[0];
      Position2 := AGrid.RowPositions.Items[AGrid.RowPositions.Count - 1];
      MinY := Min(Position1, Position2);
      MaxY := Max(Position1, Position2);
      XOffSet1 := MinX - (MaxX - MinX) / 10;
      XOffSet2 := MinX - (MaxX - MinX) / 5;
      YOffset1 := MaxY + (MaxY - MinY) / 10;
      YOffset2 := MaxY + (MaxY - MinY) / 5;
      LowerPosition := True;
      AnEditContours := TEditContours.Create(AGrid.OriginX,
        AGrid.OriginY, AGrid.GridAngle);

      try
        if AGrid.ColPositions.Count > 1 then
        begin
          Position1 := AGrid.ColPositions.Items[0];
          Position2 := AGrid.ColPositions.Items[1];
          Width1 := Abs(Position2 - Position1);
          for PositionIndex := 2 to AGrid.ColPositions.Count - 1 do
          begin
            Width2 := Abs(AGrid.ColPositions.Items[PositionIndex]
              - AGrid.ColPositions.Items[PositionIndex - 1]);
            if not IsNearlySame(Width2, Width1) then
            begin
              AContour := TContour2.Create;
              AnEditContours.ContourList.Add(AContour);

              ARealValue := TRealValue.Create;
              ARealValue.Value := Width1 * (1 + Epsilon);
              AContour.ValueList.Add(ARealValue);

              CellCount := Round((Position2 - Position1) / Width1);

              X1 := Position1;
              X2 := Position1 + CellCount * Width1;
              Position2 := X2;
              if LowerPosition then
              begin
                Y1 := YOffset1;
              end
              else
              begin
                Y1 := YOffset2;
              end;
              Y2 := Y1;

              APoint := TPoint.Create(X1, Y1);
              AContour.FPoints.Add(APoint);

              APoint := TPoint.Create(X2, Y2);
              AContour.FPoints.Add(APoint);

              LowerPosition := not LowerPosition;
              Position1 := Position2;
              Width1 := Width2;
            end;
            Position2 := AGrid.ColPositions.Items[PositionIndex];

            if (PositionIndex = AGrid.ColPositions.Count - 1) then
            begin
              AContour := TContour2.Create;
              AnEditContours.ContourList.Add(AContour);

              ARealValue := TRealValue.Create;
              ARealValue.Value := Width1 * (1 + Epsilon);
              AContour.ValueList.Add(ARealValue);

              CellCount := Round((Position2 - Position1) / Width1);

              X1 := Position1;
              X2 := Position1 + CellCount * Width1;
              Position2 := X2;
              if LowerPosition then
              begin
                Y1 := YOffset1;
              end
              else
              begin
                Y1 := YOffset2;
              end;
              Y2 := Y1;

              APoint := TPoint.Create(X1, Y1);
              AContour.FPoints.Add(APoint);

              APoint := TPoint.Create(X2, Y2);
              AContour.FPoints.Add(APoint);

              LowerPosition := not LowerPosition;
              Position1 := Position2;
              Width1 := Width2;
            end;
          end;
        end;

        if AGrid.RowPositions.Count > 1 then
        begin
          Position1 := AGrid.RowPositions.Items[0];
          Position2 := AGrid.RowPositions.Items[1];
          Width1 := Abs(Position2 - Position1);
          for PositionIndex := 2 to AGrid.RowPositions.Count - 1 do
          begin
            Width2 := Abs(AGrid.RowPositions.Items[PositionIndex]
              - AGrid.RowPositions.Items[PositionIndex - 1]);
            if not IsNearlySame(Width2, Width1) then
            begin
              AContour := TContour2.Create;
              AnEditContours.ContourList.Add(AContour);

              ARealValue := TRealValue.Create;
              ARealValue.Value := Width1 * (1 + Epsilon);
              AContour.ValueList.Add(ARealValue);

              CellCount := Round((Position2 - Position1) / Width1);

              Y1 := Position1;
              Y2 := Position1 + CellCount * Width1;
              Position2 := Y2;
              if LowerPosition then
              begin
                X1 := XOffset1;
              end
              else
              begin
                X1 := XOffset2;
              end;
              X2 := X1;

              APoint := TPoint.Create(X1, Y1);
              AContour.FPoints.Add(APoint);

              APoint := TPoint.Create(X2, Y2);
              AContour.FPoints.Add(APoint);

              LowerPosition := not LowerPosition;
              Position1 := Position2;
              Width1 := Width2;
            end;
            Position2 := AGrid.RowPositions.Items[PositionIndex];
            if (PositionIndex = AGrid.RowPositions.Count - 1) then
            begin
              AContour := TContour2.Create;
              AnEditContours.ContourList.Add(AContour);

              ARealValue := TRealValue.Create;
              ARealValue.Value := Width1 * (1 + Epsilon);
              AContour.ValueList.Add(ARealValue);

              CellCount := Round((Position2 - Position1) / Width1);

              Y1 := Position1;
              Y2 := Position1 + CellCount * Width1;
              Position2 := Y2;
              if LowerPosition then
              begin
                X1 := XOffset1;
              end
              else
              begin
                X1 := XOffset2;
              end;
              X2 := X1;

              APoint := TPoint.Create(X1, Y1);
              AContour.FPoints.Add(APoint);

              APoint := TPoint.Create(X2, Y2);
              AContour.FPoints.Add(APoint);

              LowerPosition := not LowerPosition;
              Position1 := Position2;
              Width1 := Width2;
            end;
          end;
        end;
        ContourStringList := TStringList.Create;
        try
          AnEditContours.WriteContours(0,
            cbRowsPositive.Checked, cbColumnsPositive.Checked,
              ContourStringList);
          LayerName := 'MODFLOW Grid Refinement';
          Project := TProjectOptions.Create;
          try
            LayerHandle := Project.GetLayerByName(CurrentModelHandle,
              LayerName);
          finally
            Project.Free;
          end;
          if LayerHandle <> nil then
          begin
            ImportText(ContourStringList, LayerHandle);
          end;
        finally
          ContourStringList.Free;
        end;
      finally
        AnEditContours.Free;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmModflowImport.MakeDataLayer(DataValues: TObjectList;
  ParameterNames: TStringList; LayerHandle: ANE_PTR);
var
  DataValue: TDataValues;
  Values: pMatrix;
  PosX, PosY: PDoubleArray;
  Names: PParamNamesArray;
  NameIndex, ValueIndex: integer;
  AName: string;
begin
  inherited;
  posX := nil;
  posY := nil;
  Values := nil;
  Names := nil;
  try
    begin
      GetMem(posX, DataValues.Count * SizeOf(double));
      GetMem(posY, DataValues.Count * SizeOf(double));
      GetMem(Values, ParameterNames.Count * SizeOf(pMatrix));
      GetMem(Names, ParameterNames.Count * SizeOf(ANE_STR));
      try
        begin
          for NameIndex := 0 to ParameterNames.Count - 1 do
          begin
            Values^[NameIndex] := nil;
          end;

          for NameIndex := 0 to ParameterNames.Count - 1 do
          begin
            GetMem(Values[NameIndex], DataValues.Count * SizeOf(DOUBLE));
          end;

          for NameIndex := 0 to ParameterNames.Count - 1 do
          begin
            AName := ParameterNames[NameIndex];
            GetMem(Names^[NameIndex - 1], (Length(AName) + 1));
            StrPCopy(Names^[NameIndex - 1], AName);
          end;

          for ValueIndex := 0 to DataValues.Count - 1 do
          begin
            DataValue := DataValues[ValueIndex] as TDataValues;

            PosX^[ValueIndex] := DataValue.X;
            PosY^[ValueIndex] := DataValue.Y;
            for NameIndex := 0 to ParameterNames.Count - 1 do
            begin
              Values[NameIndex]^[ValueIndex] := DataValue.Values[NameIndex];
            end;
          end;

          ANE_DataLayerSetData(CurrentModelHandle,
            LayerHandle,
            DataValues.Count,
            @PosX^,
            @PosY^,
            ParameterNames.Count,
            @Values^,
            @Names^);
          ANE_ProcessEvents(CurrentModelHandle);

        end;
      finally
        begin
          for NameIndex := ParameterNames.Count - 1 downto 0 do
          begin
            FreeMem(Values[NameIndex]);
            FreeMem(Names^[NameIndex]);
          end;
        end;
      end;
    end
  finally
    begin
      FreeMem(Values);
      FreeMem(posY);
      FreeMem(posX);
      FreeMem(Names);
    end;
  end;
end;

function TfrmModflowImport.NumberOfBarriers: integer;
begin
  result := NHFB;
end;

function TfrmModflowImport.GetHFBR(hfbCell: Integer;
  hfbValue: THFBLocations): Single;
begin
  // HFB package
  result := xx[Get2DIndex(Ord(High(THFBLocations)) + 1, NHFB, Ord(hfbValue),
    hfbCell, LCHFBR)];
end;

function TfrmModflowImport.GetHFBR(hfbCell, hfbValue: Integer): Single;
begin
  // HFB package
  result := xx[Get2DIndex(Ord(High(THFBLocations)) + 1, NHFB, hfbValue, hfbCell,
    LCHFBR)];
end;

function TfrmModflowImport.NumberOfDrains: integer;
begin
  result := NDRAIN;
end;

function TfrmModflowImport.UseCell(Col, Row, Layer: integer): boolean;
begin
  result := True;
end;

function TfrmModflowImport.CalculateStreamStage: boolean;
begin
  Result := (ICALC > 0);
end;

function TfrmModflowImport.NumStreamTributaries: integer;
begin
  result := NTRIB;
end;

function TfrmModflowImport.UseStreamTributaries: Boolean;
begin
  result := (NTRIB > 0);
end;

function TfrmModflowImport.UseStreamDiversions: Boolean;
begin
  result := (NDIV > 0);
end;

function TfrmModflowImport.NumberOfFHBTimes: integer;
begin
  result := NBDTIM;
end;

function TfrmModflowImport.NumberOfWells: integer;
begin
  result := NWELLS;
end;

function TfrmModflowImport.NumberOfStreamCells: integer;
begin
  result := NSTREM;
end;

function TfrmModflowImport.NumberOfRivers: integer;
begin
  result := NRIVER;
end;

function TfrmModflowImport.NumberOfFHBFlows: integer;
begin
  result := NFLW;
end;

function TfrmModflowImport.NumberOfFHBHeads: integer;
begin
  result := NHED;
end;

function TfrmModflowImport.NumberOfGHBBoundaries: integer;
begin
  result := NBOUND;
end;

function TfrmModflowImport.GetDrain(DrainCell,
  DrainValue: Integer): Single;
begin
  result := xx[Get2DIndex(NDRNVL, MXDRN, DrainValue, DrainCell, LCDRAI)];
end;

function TfrmModflowImport.GetDrain(DrainCell: Integer;
  DrainValue: TDrainValues): Single;
begin
  result := xx[Get2DIndex(NDRNVL, MXDRN, Ord(DrainValue), DrainCell, LCDRAI)];
end;

function TfrmModflowImport.GetFlowLoc(fhbCell: Integer;
  fhbValue: TFHBLocations): Single;
begin
  // FHB package
  result := xx[Get2DIndex(Ord(High(TFHBLocations)) + 1, NFLW, Ord(fhbValue),
    fhbCell, LCFLLC)];
end;

function TfrmModflowImport.GetFlowLoc(fhbCell, fhbValue: Integer): Single;
begin
  // FHB package
  result := xx[Get2DIndex(Ord(High(TFHBLocations)) + 1, NFLW, fhbValue, fhbCell,
    LCFLLC)];
end;

function TfrmModflowImport.GetHeadLoc(fhbCell: Integer;
  fhbValue: TFHBLocations): Single;
begin
  // FHB package
  result := xx[Get2DIndex(Ord(High(TFHBLocations)) + 1, NHED, Ord(fhbValue),
    fhbCell, LCHDLC)];
end;

function TfrmModflowImport.GetHeadLoc(fhbCell, fhbValue: Integer): Single;
begin
  // FHB package
  result := xx[Get2DIndex(Ord(High(TFHBLocations)) + 1, NHED, fhbValue, fhbCell,
    LCHDLC)];
end;

function TfrmModflowImport.GetGHB(ghbCell, ghbValue: Integer): Single;
begin
  result := xx[Get2DIndex(NGHBVL, MXBND, ghbValue, ghbCell, LCBNDS)];
end;

function TfrmModflowImport.GetGHB(ghbCell: Integer;
  ghbValue: TGHBValues): Single;
begin
  result := xx[Get2DIndex(NGHBVL, MXBND, Ord(ghbValue), ghbCell, LCBNDS)];
end;

function TfrmModflowImport.GetIbound(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY, IVALUE: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetIBOUND(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, IVALUE);
    result := IVALUE;
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, Layer, LCIBOU)];
  end;
end;

function TfrmModflowImport.GetIboundSign(Col, Row, Layer: Integer): Single;
begin
  result := GetIbound(Col, Row, Layer);
  if result <> 0 then
    result := 1;
end;

function TfrmModflowImport.GetRIVR(RiverCell, RiverValue: Integer): Single;
begin
  result := xx[Get2DIndex(NRIVVL, MXRIVR, RiverValue, RiverCell, LCRIVR)];
end;

function TfrmModflowImport.GetRIVR(RiverCell: Integer;
  RiverValue: TRiverValues): Single;
begin
  result := xx[Get2DIndex(NRIVVL, MXRIVR, Ord(RiverValue), RiverCell, LCRIVR)];
end;

function TfrmModflowImport.GetICSTRM(strCell: Integer;
  strValue: TStreamIntValues): Single;
begin
  // stream package
  result := Round(xx[Get2DIndex(Ord(High(TStreamIntValues)) + 1, MXSTRM,
      Ord(strValue), strCell, ICSTRM)]);
end;

function TfrmModflowImport.GetICSTRM(strCell, strValue: Integer): Single;
begin
  // stream package
  result := Round(xx[Get2DIndex(Ord(High(TStreamIntValues)) + 1, MXSTRM,
      strValue, strCell, ICSTRM)]);
end;

function TfrmModflowImport.GetWELL(WellCell, WellValue: Integer): Single;
begin
  result := xx[Get2DIndex(NWELVL, MXWELL, WellValue, WellCell, LCWELL)];
end;

function TfrmModflowImport.GetWELL(WellCell: Integer;
  WellValue: TWellValues): Single;
begin
  result := xx[Get2DIndex(NWELVL, MXWELL, Ord(WellValue), WellCell, LCWELL)];
end;

function TfrmModflowImport.GetSTRM(strCell: Integer;
  strValue: TStreamRealValues): Single;
begin
  // stream package
  result := xx[Get2DIndex(Ord(High(TStreamRealValues)) + 1, MXSTRM,
    Ord(strValue), strCell, LCSTRM)];
end;

function TfrmModflowImport.GetSTRM(strCell, strValue: Integer): Single;
begin
  // stream package
  result := xx[Get2DIndex(Ord(High(TStreamRealValues)) + 1, MXSTRM,
    strValue, strCell, LCSTRM)];
end;

function TfrmModflowImport.GetITRBAR(strSegment,
  Tributary: Integer): Single;
begin
  // stream package
  result := xx[Get2DIndex(NSS, NTRIB, strSegment, Tributary, LCTBAR)];
end;

function TfrmModflowImport.GetIDIVAR(strSegment: Integer): Single;
begin
  // stream package
  result := xx[Get1DIndex(NSS, strSegment, LCIVAR)];
end;

function TfrmModflowImport.GetFLWRAT(fhbCell, fhbTime: Integer): Single;
begin
  // FHB package
  result := xx[Get2DIndex(NBDTIM, NFLW, fhbTime, fhbCell, LCFLRT)];
end;

function TfrmModflowImport.GetSBHED(fhbCell, fhbTime: Integer): Single;
begin
  // FHB package
  result := xx[Get2DIndex(NBDTIM, NHED, fhbTime, fhbCell, LCSBHD)];
end;

function TfrmModflowImport.BlockIndex(RowIndex,
  ColIndex: integer): integer;
begin
  Assert(ColIndex >= 0);
  Assert(ColIndex < NCOL);
  Assert(RowIndex >= 0);
  Assert(RowIndex < NROW);
  if not cbColumnsPositive.Checked then
  begin
    ColIndex := NCOL - ColIndex - 1;
  end;
  if not cbRowsPositive.Checked then
  begin
    RowIndex := NROW - RowIndex - 1;
  end;
  result := RowIndex * NCOL + ColIndex;
  Assert((result >= 0) and (result <= NCOL * NROW - 1));
end;

procedure TfrmModflowImport.SetCellCenters(GridLayerHandle: ANE_PTR);
var
  RowIndex: integer;
  ColIndex: integer;
  ABlock: TBlockObjectOptions;
  ALocation: TLocation;
begin
  SetLength(CellCenters, NROW, NCOL);
  for RowIndex := 0 to NROW - 1 do
  begin
    for ColIndex := 0 to NCOL - 1 do
    begin
      try
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          GridLayerHandle, BlockIndex(RowIndex, ColIndex));

        ABlock.GetCenter(CurrentModelHandle, ALocation.X, ALocation.Y);
        CellCenters[RowIndex, ColIndex] := ALocation;
      finally
        FreeAndNil(ABlock);
      end;
    end;
  end;
end;

function TfrmModflowImport.GetActiveCell(Col, Row, Layer: Integer): Single;
var
  LayerIndex: integer;
begin
  result := 0;
  for LayerIndex := 0 to NLAY - 1 do
  begin
    if GetIbound(Col, Row, LayerIndex) <> 0 then
    begin
      result := 1;
      break;
    end;
  end;
end;

function TfrmModflowImport.IsActiveCellOnAnyLayer(Col, Row,
  Layer: Integer): boolean;
begin
  result := (GetActiveCell(Col, Row, Layer) <> 0);
end;

function TfrmModflowImport.GetTRPY(Layer: Integer): Single;
var
  ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ILAY := Layer + 1;
    mf2kInterface.GetTRPY(ILAY, self.MF2K_Importer.NLAY, result);
  end
  else
  begin
    result := xx[Get1DIndex(NLAY, Layer, LCTRPY)];
  end;
end;

//function TfrmModflowImport.IsInactiveCell(Col, Row,
//  Layer: Integer): boolean;
//begin
//  result := (GetIbound(Col, Row, Layer) = 0);
//end;
//
//function TfrmModflowImport.IsActiveLayer(Col, Row,
//  Layer: Integer): boolean;
//begin
//  result := frmModflow.Simulated(Layer + 1);
//end;

function TfrmModflowImport.IsCell(Col, Row,
  Layer: Integer): boolean;
begin
  result := True;
end;

function TfrmModflowImport.IsActiveCell(Col, Row,
  Layer: Integer): boolean;
begin
  result := (GetIbound(Col, Row, Layer) <> 0);
end;

function TfrmModflowImport.IsPrescribedHeadCell(Col, Row,
  Layer: Integer): boolean;
begin
  result := (GetIbound(Col, Row, Layer) < 0);
end;

function TfrmModflowImport.GetSHead(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetSTRT(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, Layer, LCSTRT)];
  end;
end;

{ TImportLayer }

constructor TImportLayer.Create;
begin
  inherited;
  LinkedLayerList := TList.Create;
  LinkedParameterList := TList.Create;
  FunctionList := T3DFunctionList.Create;
  TimeFunctionList := T3DFunctionList.Create;
  UseFunctionList := TUse3DFunctionList.Create;
  ParameterNames := TStringList.Create;
  ExtraExpressionList := TStringList.Create;
  ExtraEndExpressionList := TStringList.Create;
end;

destructor TImportLayer.Destroy;
begin
  LinkedLayerList.Free;
  LinkedParameterList.Free;
  FunctionList.Free;
  TimeFunctionList.Free;
  UseFunctionList.Free;
  ParameterNames.Free;
  ExtraExpressionList.Free;
  ExtraEndExpressionList.Free;
  inherited;
end;

procedure TImportLayer.SetExpressions;
var
  Expression: string;
  PIndex: integer;
  Index, TimeIndex: integer;
  Layer: T_ANE_InfoLayer;
  Parameter: T_ANE_Param;
  ParamOptions: TParameterOptions;
  procedure SetAnExpression;
  begin
    Inc(PIndex);
    Layer := LinkedLayerList[PIndex];
    Parameter := LinkedParameterList[PIndex];
    if Layer = nil then
    begin
      Assert(Parameter = nil);
    end
    else
    begin
      Assert(Parameter <> nil);
      ParamOptions := TParameterOptions.CreateWithName(Layer.GetLayerHandle
        (frmModflowImport.CurrentModelHandle),
        frmModflowImport.CurrentModelHandle, Parameter.OldName);
      try
        Expression := ExtraExpressionList[PIndex] + LayerName + '.' +
          ParameterNames[PIndex] + ExtraEndExpressionList[PIndex];
        ParamOptions.Expr[frmModflowImport.CurrentModelHandle] := Expression;
      finally
        ParamOptions.Free;
      end;
    end;
  end;
begin
  PIndex := -1;
  for Index := 0 to FunctionList.Count - 1 do
  begin
    SetAnExpression;
  end;
  for Index := 0 to TimeFunctionList.Count - 1 do
  begin
    for TimeIndex := 0 to frmModflowImport.NPER - 1 do
    begin
      SetAnExpression;
    end;
  end;
end;

procedure TImportLayer.ExportData(const Offset: double);
begin
  Assert((FunctionList.Count + TimeFunctionList.Count * frmModflowImport.NPER
    = LinkedLayerList.Count)
    and (LinkedLayerList.Count = LinkedParameterList.Count));
  case ImportMethod of
    imPointContours:
      begin
        MakePointContours;
      end;
    imZones, imDomainOutline:
      begin
        MakeZoneData(Offset);
      end;
    imDataLayer:
      begin
        MakeDataLayer;
      end;
  else
    Assert(False);
  end;
  SetExpressions;
end;

procedure TImportLayer.MakeDataLayer;
var
  AStringList: TStringList;
  LayerHandle: ANE_PTR;
  NamedDataLayer: T_ANE_NamedDataLayer;
  Index: integer;
  DataLayerTemplate: string;
  ANE_LayerTemplate: ANE_STR;
begin
  if (frmModflowImport.AGrid <> nil) then
  begin
    Screen.Cursor := crHourGlass;
    AStringList := nil;
    try
      begin
        AStringList := frmModflowImport.AGrid.MakeDataPoints
          (FunctionList, TimeFunctionList, UseFunctionList, LayerIndex - 1,
          frmModflowImport.NPER,
          frmModflowImport.cbRowsPositive.Checked,
          frmModflowImport.cbColumnsPositive.Checked);

        NamedDataLayer := T_ANE_NamedDataLayer.Create(LayerName, nil, -1);
        try
          for Index := 0 to ParameterNames.Count - 1 do
          begin
            T_ANE_NamedDataParam.Create(ParameterNames[Index],
              NamedDataLayer.ParamList, -1);
          end;
          NamedDataLayer.Interp := leQT_Nearest;
          NamedDataLayer.Visible := False;

          DataLayerTemplate := NamedDataLayer.WriteLayer
            (frmModflowImport.CurrentModelHandle);

          GetMem(ANE_LayerTemplate, Length(DataLayerTemplate) + 1);
          try
            StrPCopy(ANE_LayerTemplate, DataLayerTemplate);
            LayerHandle :=
              ANE_LayerAddByTemplate(frmModflowImport.CurrentModelHandle,
              ANE_LayerTemplate, nil);
            ANE_ProcessEvents(frmModflowImport.CurrentModelHandle);
          finally
            FreeMem(ANE_LayerTemplate);
          end;

        finally
          NamedDataLayer.Free;
        end;

        if AStringList.Count > 2 then
        begin
          if LayerHandle <> nil then
          begin
            frmModflowImport.ImportText(AStringList, LayerHandle);
          end;
        end;
      end;
    finally
      begin
        Screen.Cursor := crDefault;
        AStringList.Free;
      end;
    end;
  end; // if AGrid <> nil then
end;

procedure TImportLayer.MakePointContours;
var
  AStringList: TStringList;
  AnEditContours: TEditContours;
  Project: TProjectOptions;
  LayerHandle: ANE_PTR;
  NamedInfoLayer: T_ANE_NamedInfoLayer;
  NamedLayerParam: T_ANE_NamedLayerParam;
  Index: integer;
  DataLayerTemplate: string;
  ANE_LayerTemplate: ANE_STR;
begin
  if (frmModflowImport.AGrid <> nil) then
  begin
    Screen.Cursor := crHourGlass;
    AStringList := TStringList.Create;
    try
      begin
        AnEditContours := nil;
        try
          AnEditContours := frmModflowImport.AGrid.MakePointContourFromLayer
            (FunctionList, UseFunctionList, LayerIndex - 1);
          AnEditContours.WriteContours
            (0, frmModflowImport.cbRowsPositive.Checked,
            frmModflowImport.cbColumnsPositive.Checked, AStringList);
        finally
          begin
            AnEditContours.Free;
          end;
        end;

        if AStringList.Count > 1 then
        begin
          Project := TProjectOptions.Create;
          try
            LayerHandle := Project.GetLayerByName
              (frmModflowImport.CurrentModelHandle, LayerName);
            if LayerHandle = nil then
            begin
              NamedInfoLayer := T_ANE_NamedInfoLayer.Create(LayerName, nil, -1);
              try
                NamedInfoLayer.Visible := False;
                for Index := 0 to ParameterNames.Count - 1 do
                begin
                  NamedLayerParam :=
                    T_ANE_NamedLayerParam.Create(ParameterNames[Index],
                    NamedInfoLayer.ParamList, -1);
                  if Index < Length(ParameterTypes) then
                  begin
                    NamedLayerParam.ValueType := ParameterTypes[Index];
                  end;
                end;

                DataLayerTemplate := NamedInfoLayer.WriteLayer
                  (frmModflowImport.CurrentModelHandle);

                GetMem(ANE_LayerTemplate, Length(DataLayerTemplate) + 1);
                try
                  StrPCopy(ANE_LayerTemplate, DataLayerTemplate);
                  LayerHandle :=
                    ANE_LayerAddByTemplate(frmModflowImport.CurrentModelHandle,
                    ANE_LayerTemplate, nil);
                  ANE_ProcessEvents(frmModflowImport.CurrentModelHandle);
                finally
                  FreeMem(ANE_LayerTemplate);
                end;

              finally
                NamedInfoLayer.Free;
              end;

            end;
          finally
            Project.Free;
          end;

          if LayerHandle <> nil then
          begin
            frmModflowImport.ImportText(AStringList, LayerHandle);
          end;
        end;
      end;
    finally
      begin
        Screen.Cursor := crDefault;
        AStringList.Free;
      end;
    end;
  end; // if AGrid <> nil then
end;

function TfrmModflowImport.GetSC1(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetSC1(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result,
      MF2K_Importer.IUNIT[0]);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, Layer, LCSC1)];
  end;
end;

function TfrmModflowImport.GetSC2(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
  LayerIndex: integer;
begin
  LayerIndex := GetKT(Layer);
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetSC2(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result,
      MF2K_Importer.IUNIT[0]);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, LayerIndex, LCSC2)];
  end;
end;

function TfrmModflowImport.GetTrans(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetCC(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, Layer, LCCC)];
  end;
end;

function TfrmModflowImport.GetHK(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  ICol := Col + 1;
  IROW := Row + 1;
  ILAY := Layer + 1;
  mf2kInterface.GetHK(ICol, IROW, ILAY, MF2K_Importer.NCOL,
    MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
end;

function TfrmModflowImport.GetVKA(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  ICol := Col + 1;
  IROW := Row + 1;
  ILAY := Layer + 1;
  mf2kInterface.GetVKA(ICol, IROW, ILAY, MF2K_Importer.NCOL,
    MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
end;

function TfrmModflowImport.GetVKCB(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  ICol := Col + 1;
  IROW := Row + 1;
  ILAY := Layer + 1;
  mf2kInterface.GetVKCB(ICol, IROW, ILAY, MF2K_Importer.NCOL,
    MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
end;

function TfrmModflowImport.GetIZONE(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY, IVALUE: longint;
begin
  ICol := Col + 1;
  IROW := Row + 1;
  ILAY := Layer + 1;
  mf2kInterface.GetIZONE(ICol, IROW, ILAY, MF2K_Importer.NCOL,
    MF2K_Importer.NROW, MF2K_Importer.NLAY, IVALUE);
  result := IVALUE;
end;

function TfrmModflowImport.GetRMLT(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  ICol := Col + 1;
  IROW := Row + 1;
  ILAY := Layer + 1;
  mf2kInterface.GetRMLT(ICol, IROW, ILAY, MF2K_Importer.NCOL,
    MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
end;

function TfrmModflowImport.GetHANI(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  ICol := Col + 1;
  IROW := Row + 1;
  ILAY := Layer + 1;
  mf2kInterface.GetHANI(ICol, IROW, ILAY, MF2K_Importer.NCOL,
    MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
end;

function TfrmModflowImport.GetHY(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
  LayerIndex: integer;
begin
  LayerIndex := GetKB(Layer);
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := LayerIndex + 1;
    mf2kInterface.GetHY(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, LayerIndex, LCHY)];
  end;
end;

function TfrmModflowImport.GetKT(Layer: Integer): Integer;
var
  Index: integer;
begin
  if (Layer < 0) or (Layer > NLAY - 1) then
  begin
    ERangeError.Create('Range Error');
  end;

  // use for SC2 and TOP arrays
  result := 0;
  for Index := 0 to Layer - 1 do
  begin
    if rgModelType.ItemIndex = 2 then
    begin
      if (MF2K_Importer.LAYCON[Index] = 2) or (MF2K_Importer.LAYCON[Index] = 3)
        then
      begin
        Inc(result);
      end;
    end
    else
    begin
      if (LAYCOX[Index] = 2) or (LAYCOX[Index] = 3) then
      begin
        Inc(result);
      end;
    end;
  end;
end;

function TfrmModflowImport.GetKB(Layer: Integer): Integer;
var
  Index: integer;
begin
  if (Layer < 0) or (Layer > NLAY - 1) then
  begin
    ERangeError.Create('Range Error');
  end;
  // use for HY, BOT, and WETDRY arrays
  result := 0;
  if rgModelType.ItemIndex = 2 then
  begin
    for Index := 0 to Layer - 1 do
    begin
      if (MF2K_Importer.LAYCON[Index] = 1) or (MF2K_Importer.LAYCON[Index] = 3)
        then
      begin
        Inc(result);
      end;
    end;
  end
  else
  begin
    for Index := 0 to Layer - 1 do
    begin
      if (LAYCOX[Index] = 1) or (LAYCOX[Index] = 3) then
      begin
        Inc(result);
      end;
    end;
  end;
end;

function TfrmModflowImport.GetBOT(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY, NLAY_PLUS_ONE: longint;
  LayerIndex: integer;
  LayerPlus: integer;
  SimLayerCount: Integer;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;

    SimLayerCount := 0;
    LayerPlus := 0;
    for LayerIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(LayerIndex) then
      begin
        Inc(SimLayerCount);
        if SimLayerCount -1 = Layer then
        begin
          Break;
        end;
      end
      else
      begin
        Inc(LayerPlus);
      end;
    end;

//    LayerPlus := 0;
//    for LayerIndex := 1 to Layer+1 do
//    begin
//      if not frmModflow.Simulated(LayerIndex) then
//      begin
//        Inc(LayerPlus);
//      end;
//    end;

    ILAY := Layer + 2 + LayerPlus;
    NLAY_PLUS_ONE := MF2K_Importer.NLAY + 1;
    mf2kInterface.GetBOTM(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, NLAY_PLUS_ONE, result);
  end
  else
  begin
    LayerIndex := GetKB(Layer);
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, LayerIndex, LCBOT)];
  end;
end;

function TfrmModflowImport.GetTOP(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY, NLAY_PLUS_ONE: longint;
  LayerIndex: integer;
  LayerPlus: integer;
  SimLayerCount: Integer;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;

    SimLayerCount := 0;
    LayerPlus := 0;
    for LayerIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(LayerIndex) then
      begin
        Inc(SimLayerCount);
        if SimLayerCount -1 = Layer then
        begin
          Break;
        end;
      end
      else
      begin
        Inc(LayerPlus);
      end;
    end;

//    LayerPlus := 0;
//    for LayerIndex := 1 to Layer+1 do
//    begin
//      if not frmModflow.Simulated(LayerIndex) then
//      begin
//        Inc(LayerPlus);
//      end;
//    end;
    ILAY := Layer + 1 + LayerPlus;
    NLAY_PLUS_ONE := MF2K_Importer.NLAY + 1;
    mf2kInterface.GetBOTM(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, NLAY_PLUS_ONE, result);
  end
  else
  begin
    LayerIndex := GetKT(Layer);
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, LayerIndex, LCTOP)];
  end;
end;

function TfrmModflowImport.GetVCONT(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetCV(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, Layer, LCCV)];
  end;
end;

function TfrmModflowImport.GetHUFTOP(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetHUFTOP(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NHUF, result);
  end
  else
  begin
    Assert(False);
  end;
end;

function TfrmModflowImport.GetHUFThickness(Col, Row, Layer: Integer): Single;
var
  ICOL, IROW, ILAY: longint;
begin
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := Layer + 1;
    mf2kInterface.GetHUFTHK(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NHUF, result);
  end
  else
  begin
    Assert(False);
  end;
end;

function TfrmModflowImport.GetWETDRY(Col, Row, Layer: Integer): Single;
var
  LayerIndex: integer;
  ICOL, IROW, ILAY: longint;
begin
  LayerIndex := GetKB(Layer);
  if rgModelType.ItemIndex = 2 then
  begin
    ICol := Col + 1;
    IROW := Row + 1;
    ILAY := LayerIndex + 1;
    mf2kInterface.GetWETDRY(ICol, IROW, ILAY, MF2K_Importer.NCOL,
      MF2K_Importer.NROW, MF2K_Importer.NLAY, result,
      MF2K_Importer.IUNIT[0]);
  end
  else
  begin
    result := xx[Get3DIndex(NCOL, NROW, NLAY, Col, Row, LayerIndex, LCWETD)];
  end;
end;

function TfrmModflowImport.GetWETDRYThreshhold(Col, Row, Layer: Integer):
  Single;
begin
  result := Abs(GetWETDRY(Col, Row, Layer));
end;

function TfrmModflowImport.GetWETDRYFlag(Col, Row, Layer: Integer): Single;
var
  WetDry: Single;
begin
  WetDry := GetWETDRY(Col, Row, Layer);
  if WetDry > 0 then
  begin
    result := 1;
  end
  else if WetDry < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

function TfrmModflowImport.GetSURF(Col, Row, StressPeriodIndex: Integer):
  Single;
begin
  Assert((Col >= 0) and (Col <= NCOL) and (Row >= 0) and (NROW <= NROW)
    and (StressPeriodIndex >= 0) and (StressPeriodIndex <= NPER));

  result := AGrid.EvapSurface[Col, Row, StressPeriodIndex]
end;

function TfrmModflowImport.GetEVTR(Col, Row, StressPeriodIndex: Integer):
  Single;
begin
  result := AGrid.EvapRate[Col, Row, StressPeriodIndex]
end;

function TfrmModflowImport.GetEXDP(Col, Row, StressPeriodIndex: Integer):
  Single;
begin
  Assert((Col >= 0) and (Col <= NCOL) and (Row >= 0) and (NROW <= NROW)
    and (StressPeriodIndex >= 0) and (StressPeriodIndex <= NPER));
  result := AGrid.EvapExtDepth[Col, Row, StressPeriodIndex]
end;

procedure TImportLayer.MakeZoneData(const Offset: double);
var
  AStringList: TStringList;
  LayerHandle: ANE_PTR;
  Project: TProjectOptions;
  AZoneList: TZoneList;
  NamedInfoLayer: T_ANE_NamedInfoLayer;
  NamedLayerParam: T_ANE_NamedLayerParam;
  Index: integer;
  InfoLayerTemplate: string;
  UseValue: boolean;
  ANE_LayerTemplate: ANE_STR;
  ABoolean: ANE_BOOL;
begin
  AStringList := nil;
  AZoneList := nil;
  if (frmModflowImport.AGrid <> nil) then
  begin
    try
      Screen.Cursor := crHourGlass;
      AStringList := TStringList.Create;
      UseValue := ImportMethod = imDomainOutline;
      AZoneList := frmModflowImport.AGrid.LayerZones(FunctionList,
        LayerIndex - 1, UseFunctionList, UseValue, GridDensity);
      AZoneList.WriteZones(0, frmModflowImport.cbRowsPositive.Checked,
        frmModflowImport.cbColumnsPositive.Checked, AStringList, Offset);

      if AStringList.Count > 1 then
      begin
        Project := TProjectOptions.Create;
        try
          LayerHandle :=
            Project.GetLayerByName(frmModflowImport.CurrentModelHandle,
            LayerName);
          if LayerHandle = nil then
          begin
            NamedInfoLayer := T_ANE_NamedInfoLayer.Create(LayerName, nil, -1);
            try
              NamedInfoLayer.Interp := leExact;
              NamedInfoLayer.Visible := False;
              for Index := 0 to ParameterNames.Count - 1 do
              begin
                NamedLayerParam :=
                  T_ANE_NamedLayerParam.Create(ParameterNames[Index],
                  NamedInfoLayer.ParamList, -1);
                if Index < Length(ParameterTypes) then
                begin
                  NamedLayerParam.ValueType := ParameterTypes[Index];
                end;
              end;

              InfoLayerTemplate := NamedInfoLayer.WriteLayer
                (frmModflowImport.CurrentModelHandle);

              GetMem(ANE_LayerTemplate, Length(InfoLayerTemplate) + 1);
              try
                StrPCopy(ANE_LayerTemplate, InfoLayerTemplate);
                LayerHandle :=
                  ANE_LayerAddByTemplate(frmModflowImport.CurrentModelHandle,
                  ANE_LayerTemplate, nil);
                ANE_ProcessEvents(frmModflowImport.CurrentModelHandle);
              finally
                FreeMem(ANE_LayerTemplate);
              end;
            finally
              NamedInfoLayer.Free;
            end;
          end;
          ABoolean := True;
          ANE_LayerPropertySet(frmModflowImport.CurrentModelHandle, LayerHandle,
            'Allow Intersection', kPIEBoolean, @ABoolean);
        finally
          Project.Free;
        end;

        if LayerHandle <> nil then
        begin
          //ClipBoard.AsText := AStringList.Text;

          frmModflowImport.ImportText(AStringList, LayerHandle);
        end;
      end;
    finally
      Screen.Cursor := crDefault;
      AStringList.Free;
      AZoneList.Free;
    end;
  end;
end;

procedure TfrmModflowImport.MakeWellBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  WellBoundary: TWellBoundary;
  Column, Row, Layer: integer;
  Top, Bottom: string;
  TopName, BottomName: string;
  QRoot: string;
  QName: string;
  Q: string;
  StressPeriod: integer;
  UseTop, UseBottom: boolean;
begin
  UseBottom := False;
  UseTop := False;
  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;
  if BoundaryList.Count > 0 then
  begin
    WellBoundary := BoundaryList[0];
    Column := WellBoundary.Col;
    Row := WellBoundary.Row;
    Layer := WellBoundary.Layer - 1;
    UseTop := (LAYCOX[Layer] = 2) or (LAYCOX[Layer] = 3);
    if UseTop then
    begin
      Top := InternationalFloatToStr(frmModflowImport.GetTOP(Column, Row, Layer));
      TopName := ModflowTypes.GetMFWellTopParamType.ANE_ParamName;
    end;
    UseBottom := (LAYCOX[Layer] = 1) or (LAYCOX[Layer] = 3);
    if UseBottom then
    begin
      Bottom := InternationalFloatToStr(frmModflowImport.GetBOT(Column, Row, Layer));
      BottomName := ModflowTypes.GetMFWellBottomParamType.ANE_ParamName;
    end;
    QRoot := ModflowTypes.GetMFWellStressParamType.ANE_ParamName;
  end;
  try
    while BoundaryList.Count > 0 do
    begin
      UsedStressPeriods.Clear;

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      BoundaryContour.AddCopyOfPoint(APoint);

      if UseTop then
      begin
        BoundaryContour.SetAValue(TopName, Top);
      end;
      if UseBottom then
      begin
        BoundaryContour.SetAValue(BottomName, Bottom);
      end;

      for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
      begin
        WellBoundary := BoundaryList[BoundaryIndex];
        StressPeriod := WellBoundary.StressPeriod + 1;
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          UsedStressPeriods.Add(StressPeriod);
          BoundaryList.Delete(BoundaryIndex);
          Q := InternationalFloatToStr(WellBoundary.Q);
          QName := QRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(QName, Q);
        end;
      end;
      for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
      begin
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          QName := QRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(QName, '0');
        end;
      end;
      BoundaryContour.SetValue;
    end;
  finally
    UsedStressPeriods.Free;
  end;
end;

procedure TfrmModflowImport.MakeMF2K_WellBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  WellBoundary: TMF2K_WellBoundary;
  Column, Row, Layer: integer;
  Top, Bottom: string;
  TopName, BottomName: string;
  QRoot: string;
  QName: string;
  Q: string;
  StressPeriod: integer;
  PName: string;
begin
  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;
  if BoundaryList.Count > 0 then
  begin
    WellBoundary := BoundaryList[0];
    Column := WellBoundary.Col-1;
    Row := WellBoundary.Row-1;
    Layer := WellBoundary.Layer - 1;

    Top := InternationalFloatToStr(frmModflowImport.GetTOP(Column, Row, Layer));
    TopName := ModflowTypes.GetMFWellTopParamType.ANE_ParamName;
    Bottom := InternationalFloatToStr(frmModflowImport.GetBOT(Column, Row, Layer));
    BottomName := ModflowTypes.GetMFWellBottomParamType.ANE_ParamName;

    QRoot := ModflowTypes.GetMFWellStressParamType.ANE_ParamName;
    PName := ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  end;
  try
    while BoundaryList.Count > 0 do
    begin
      UsedStressPeriods.Clear;

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      BoundaryContour.AddCopyOfPoint(APoint);

      BoundaryContour.SetAValue(TopName, Top);
      BoundaryContour.SetAValue(BottomName, Bottom);

      for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
      begin
        WellBoundary := BoundaryList[BoundaryIndex];
        StressPeriod := WellBoundary.StressPeriod + 1;
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          UsedStressPeriods.Add(StressPeriod);
          BoundaryList.Delete(BoundaryIndex);
          Q := InternationalFloatToStr(WellBoundary.Q);
          QName := QRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(QName, Q);
          BoundaryContour.SetAValue(PName, WellBoundary.ParameterName);
        end;
      end;
      for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
      begin
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          QName := QRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(QName, '0');
        end;
      end;
      BoundaryContour.SetValue;
    end;
  finally
    UsedStressPeriods.Free;
  end;
end;

procedure TfrmModflowImport.MakeHFBBoundaries(
  BoundaryList: TTypedBoundaryList);
var
  BarrierHydraulicConductivity: double;
  ABoundary: THorizontalFlowBoundary;
  EditContours: TtypedEditContours;
  HydraulicConductivityName: string;
  HydraulicConductivitySt: string;
  BoundaryContour: TBoundaryContour;
  ASegment: TSegment;
begin
  BarrierHydraulicConductivity := 0;
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    BarrierHydraulicConductivity := ABoundary.HydChr;
    HydraulicConductivityName :=
      ModflowTypes.GetMFHFBHydCondParamType.ANE_ParamName;

    EditContours := GetATypedEditContours(
      BoundaryList.BoundaryType, BoundaryList.Layer);

    BoundaryContour := TBoundaryContour.Create(EditContours);
    EditContours.ContourList.Add(BoundaryContour);

    ASegment := nil;
    if ABoundary.Col = ABoundary.Col2 then
    begin
      Assert(Abs(ABoundary.Row - ABoundary.Row2) = 1);
      ASegment := AGrid.HorSegments[ABoundary.Col,
        Min(ABoundary.Row, ABoundary.Row2)+1];
    end
    else if ABoundary.Row = ABoundary.Row2 then
    begin
      Assert(Abs(ABoundary.Col - ABoundary.Col2) = 1);
      ASegment := AGrid.VerSegments[Min(ABoundary.Col, ABoundary.Col2)+1,
        ABoundary.Row];
    end
    else
    begin
      Assert(False);
    end;

    BoundaryContour.AddCopyOfPoint(ASegment.StartPoint);
    BoundaryContour.AddCopyOfPoint(ASegment.EndPoint);

//    BarrierHydraulicConductivity := BarrierHydraulicConductivity/ASegment.Length;
    HydraulicConductivitySt := InternationalFloatToStr(BarrierHydraulicConductivity);


    BoundaryContour.SetAValue(HydraulicConductivityName,
      HydraulicConductivitySt);
    BoundaryContour.SetAValue(ModflowTypes.
      GetMFHFBBarrierThickParamType.ANE_ParamName, '1');
    BoundaryContour.SetAValue(ModflowTypes.
      GetAdjustForAngleParamType.ANE_ParamName, '1');
    BoundaryContour.SetAValue(ModflowTypes.
      GetMFModflowParameterNameParamType.ANE_ParamName, '0');
    BoundaryContour.SetValue;
  end;
end;

procedure TfrmModflowImport.MakeDrainBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TDrainBoundary;
  StressPeriod: integer;
  OnOffRoot, ConductanceName, ElevationName: string;
  ConductanceSt, Elevation: string;
  Conductance: single;
  StressPeriodIndex: integer;
  OnOffName: string;
begin
  Conductance := 0;
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    OnOffRoot := ModflowTypes.GetMFDrainOnParamType.ANE_ParamName;
    ConductanceName := ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName;
    ElevationName := ModflowTypes.GetMFDrainElevationParamType.ANE_ParamName;
    Conductance := ABoundary.Cond;
    ConductanceSt := InternationalFloatToStr(Conductance);
    Elevation := InternationalFloatToStr(ABoundary.Elevation);
  end;
  if Conductance <> 0 then
  begin
    EditContours := GetATypedEditContours(
      BoundaryList.BoundaryType, BoundaryList.Layer);
    UsedStressPeriods := TIntegerList.Create;
    try
      while BoundaryList.Count > 0 do
      begin
        UsedStressPeriods.Clear;

        BoundaryContour := TBoundaryContour.Create(EditContours);
        EditContours.ContourList.Add(BoundaryContour);

        BoundaryContour.AddCopyOfPoint(APoint);
        BoundaryContour.SetAValue(ConductanceName, ConductanceSt);
        BoundaryContour.SetAValue(ElevationName, Elevation);
        for StressPeriodIndex := 1 to NPER do
        begin
          OnOffName := OnOffRoot + IntToStr(StressPeriodIndex);
          BoundaryContour.SetAValue(OnOffName, '0');
        end;

        for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
        begin
          ABoundary := BoundaryList[BoundaryIndex];
          StressPeriod := ABoundary.StressPeriod + 1;
          if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
          begin
            UsedStressPeriods.Add(StressPeriod);
            BoundaryList.Delete(BoundaryIndex);
            OnOffName := OnOffRoot + IntToStr(StressPeriod);
            BoundaryContour.SetAValue(OnOffName, '1');
          end;
        end;
        for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
        begin
          if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
          begin
            OnOffName := OnOffRoot + IntToStr(StressPeriod);
            BoundaryContour.SetAValue(OnOffName, '0');
          end;
        end;
        BoundaryContour.SetValue;
      end;
    finally
      UsedStressPeriods.Free;
    end;
  end;
end;

procedure TfrmModflowImport.MakeMF2K_DrainBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TMF2KDrainBoundary;
  StressPeriod: integer;
  OnOffRoot, ConductanceName, ElevationName: string;
  ConductanceSt, Elevation: string;
  Conductance: single;
  StressPeriodIndex: integer;
  OnOffName: string;
  PName: string;
begin
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    OnOffRoot := ModflowTypes.GetMFDrainOnParamType.ANE_ParamName;
    ConductanceName := ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName;
    ElevationName := ModflowTypes.GetMFDrainElevationParamType.ANE_ParamName;
    Conductance := ABoundary.Cond;
    ConductanceSt := InternationalFloatToStr(Conductance);
    Elevation := InternationalFloatToStr(ABoundary.Elevation);
    PName := ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  end;

  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;
  try
    while BoundaryList.Count > 0 do
    begin
      UsedStressPeriods.Clear;

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      BoundaryContour.AddCopyOfPoint(APoint);
      BoundaryContour.SetAValue(ConductanceName, ConductanceSt);
      BoundaryContour.SetAValue(ElevationName, Elevation);
      for StressPeriodIndex := 1 to NPER do
      begin
        OnOffName := OnOffRoot + IntToStr(StressPeriodIndex);
        BoundaryContour.SetAValue(OnOffName, '0');
      end;

      for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
      begin
        ABoundary := BoundaryList[BoundaryIndex];
        StressPeriod := ABoundary.StressPeriod + 1;
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          UsedStressPeriods.Add(StressPeriod);
          BoundaryList.Delete(BoundaryIndex);
          OnOffName := OnOffRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(OnOffName, '1');
          BoundaryContour.SetAValue(PName, ABoundary.ParameterName);
        end;
      end;
      for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
      begin
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          OnOffName := OnOffRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(OnOffName, '0');
        end;
      end;
      BoundaryContour.SetValue;
    end;
  finally
    UsedStressPeriods.Free;
  end;
end;

procedure TfrmModflowImport.MakeRiverBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TRiverBoundary;
  StressPeriod: integer;
  StageRoot, OnOffRoot, ConductanceName, BottomName: string;
  ConductanceSt, Bottom: string;
  Conductance: single;
  StressPeriodIndex: integer;
  OnOffName, StageName: string;
  Stage: string;
begin
  Conductance := 0;
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    StageRoot := ModflowTypes.GetMFRiverStageParamType.ANE_ParamName;
    OnOffRoot := ModflowTypes.GetMFOnOffParamType.ANE_ParamName;
    ConductanceName := ModflowTypes.GetMFRiverConductanceParamType.ANE_ParamName;
    BottomName := ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName;
    Conductance := ABoundary.Cond;
    ConductanceSt := InternationalFloatToStr(Conductance);
    Bottom := InternationalFloatToStr(ABoundary.RBot);
  end;
  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;
  if Conductance <> 0 then
  begin
    try
      while BoundaryList.Count > 0 do
      begin
        UsedStressPeriods.Clear;

        BoundaryContour := TBoundaryContour.Create(EditContours);
        EditContours.ContourList.Add(BoundaryContour);

        BoundaryContour.AddCopyOfPoint(APoint);
        BoundaryContour.SetAValue(ConductanceName, ConductanceSt);
        BoundaryContour.SetAValue(BottomName, Bottom);
        for StressPeriodIndex := 1 to NPER do
        begin
          OnOffName := OnOffRoot + IntToStr(StressPeriodIndex);
          BoundaryContour.SetAValue(OnOffName, '0');
        end;

        for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
        begin
          ABoundary := BoundaryList[BoundaryIndex];
          StressPeriod := ABoundary.StressPeriod + 1;
          if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
          begin
            UsedStressPeriods.Add(StressPeriod);
            BoundaryList.Delete(BoundaryIndex);
            Stage := InternationalFloatToStr(ABoundary.Stage);
            StageName := StageRoot + IntToStr(StressPeriod);
            OnOffName := OnOffRoot + IntToStr(StressPeriod);
            BoundaryContour.SetAValue(StageName, Stage);
            BoundaryContour.SetAValue(OnOffName, '1');
          end;
        end;
        for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
        begin
          if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
          begin
            OnOffName := OnOffRoot + IntToStr(StressPeriod);
            BoundaryContour.SetAValue(OnOffName, '0');
          end;
        end;
        BoundaryContour.SetValue;
      end;
    finally
      UsedStressPeriods.Free;
    end;
  end;
end;

procedure TfrmModflowImport.MakeGHBBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TGHBBoundary;
  StressPeriod: integer;
  HeadRoot, OnOffRoot, ConductanceName: string;
  ConductanceSt: string;
  Conductance: single;
  StressPeriodIndex: integer;
  OnOffName, HeadName: string;
  Head: string;
begin
  Conductance := 0;
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    HeadRoot := ModflowTypes.GetMFGHBHeadParamType.ANE_ParamName;
    OnOffRoot := ModflowTypes.GetMFOnOffParamType.ANE_ParamName;
    ConductanceName := ModflowTypes.GetMFGhbConductanceParamType.ANE_ParamName;
    Conductance := ABoundary.Cond;
    ConductanceSt := InternationalFloatToStr(Conductance);
  end;
  if Conductance <> 0 then
  begin
    EditContours := GetATypedEditContours(
      BoundaryList.BoundaryType, BoundaryList.Layer);
    UsedStressPeriods := TIntegerList.Create;
    try
      while BoundaryList.Count > 0 do
      begin
        UsedStressPeriods.Clear;

        BoundaryContour := TBoundaryContour.Create(EditContours);
        EditContours.ContourList.Add(BoundaryContour);

        BoundaryContour.AddCopyOfPoint(APoint);
        BoundaryContour.SetAValue(ConductanceName, ConductanceSt);
        for StressPeriodIndex := 1 to NPER do
        begin
          OnOffName := OnOffRoot + IntToStr(StressPeriodIndex);
          BoundaryContour.SetAValue(OnOffName, '0');
        end;

        for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
        begin
          ABoundary := BoundaryList[BoundaryIndex];
          StressPeriod := ABoundary.StressPeriod + 1;
          if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
          begin
            UsedStressPeriods.Add(StressPeriod);
            BoundaryList.Delete(BoundaryIndex);
            Head := InternationalFloatToStr(ABoundary.BoundaryHead);
            HeadName := HeadRoot + IntToStr(StressPeriod);
            OnOffName := OnOffRoot + IntToStr(StressPeriod);
            BoundaryContour.SetAValue(HeadName, Head);
            BoundaryContour.SetAValue(OnOffName, '1');
          end;
        end;
        for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
        begin
          if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
          begin
            OnOffName := OnOffRoot + IntToStr(StressPeriod);
            BoundaryContour.SetAValue(OnOffName, '0');
          end;
        end;
        BoundaryContour.SetValue;
      end;
    finally
      UsedStressPeriods.Free;
    end;
  end;
end;

procedure TfrmModflowImport.MakeBoundaries;
var
  ABoundary, AnotherBoundary: TCustomBoundary;
  ColIndex, RowIndex, BoundaryIndex: integer;
  ACell: TCell;
  ListOfBoundaryLists: TObjectList;
  MainBoundaryList: TList;
  BoundaryList: TTypedBoundaryList;
  CenterPoint: TPoint;
  ListIndex: integer;
begin
  ListOfBoundaryLists := TObjectList.Create;
  MainBoundaryList := TList.Create;
  try
    for ColIndex := 0 to NCOL - 1 do
    begin
      for RowIndex := 0 to NROW - 1 do
      begin
        ACell := AGrid.Cells[ColIndex, RowIndex];
        if ACell.BoundaryCount > 0 then
        begin
          CenterPoint := ACell.CenterPoint;
          try
            ListOfBoundaryLists.Clear;
            MainBoundaryList.Clear;
            MainBoundaryList.Capacity := ACell.BoundaryCount;
            for BoundaryIndex := 0 to ACell.BoundaryCount - 1 do
            begin
              MainBoundaryList.Add(ACell.BoundaryList[BoundaryIndex]);
            end;
            while MainBoundaryList.Count > 0 do
            begin
              BoundaryList := TTypedBoundaryList.Create;
              ListOfBoundaryLists.Add(BoundaryList);

              ABoundary := MainBoundaryList[MainBoundaryList.Count - 1];
              MainBoundaryList.Delete(MainBoundaryList.Count - 1);
              BoundaryList.Add(ABoundary);

              for BoundaryIndex := MainBoundaryList.Count - 1 downto 0 do
              begin
                AnotherBoundary := MainBoundaryList[BoundaryIndex];
                if ABoundary.SimilarBoundary(AnotherBoundary) then
                begin
                  MainBoundaryList.Delete(BoundaryIndex);
                  BoundaryList.Add(AnotherBoundary);
                end;
              end;
              BoundaryList.Sort(StressPeriodBoundarySort);
            end;
            for ListIndex := 0 to ListOfBoundaryLists.Count - 1 do
            begin
              BoundaryList := ListOfBoundaryLists[ListIndex]
                as TTypedBoundaryList;
              case BoundaryList.BoundaryType of
                btWell:
                  begin
                    MakeWellBoundaries(BoundaryList, CenterPoint);
                  end;
                btRiver:
                  begin
                    MakeRiverBoundaries(BoundaryList, CenterPoint);
                  end;
                btDrain:
                  begin
                    MakeDrainBoundaries(BoundaryList, CenterPoint);
                  end;
                btGHB:
                  begin
                    MakeGHBBoundaries(BoundaryList, CenterPoint);
                  end;
                btFHBFlux:
                  begin
                  end;
                btFHBHead:
                  begin
                  end;
                btStream:
                  begin
                  end;
                btHFB:
                  begin
                    MakeHFBBoundaries(BoundaryList);
                  end;
              else
                Assert(False);
              end;

            end;

            // now make boundaries
          finally
            CenterPoint.Free;
          end;
        end;
      end;
    end;
  finally
    ListOfBoundaryLists.Free;
    MainBoundaryList.Free;
  end;
end;

procedure TfrmModflowImport.MakeMF2KBoundaries;
var
  ABoundary, AnotherBoundary: TCustomBoundary;
  ColIndex, RowIndex, BoundaryIndex: integer;
  ACell: TCell;
  ListOfBoundaryLists: TObjectList;
  MainBoundaryList: TList;
  BoundaryList: TTypedBoundaryList;
  CenterPoint: TPoint;
  ListIndex: integer;
begin
  MakeMF2K_HFBBoundaries;
  MF2K_HfbList.Clear;
  MF2K_HfbNamesList.Clear;
  ListOfBoundaryLists := TObjectList.Create;
  MainBoundaryList := TList.Create;
  try
    for ColIndex := 0 to NCOL - 1 do
    begin
      for RowIndex := 0 to NROW - 1 do
      begin
        ACell := AGrid.Cells[ColIndex, RowIndex];
        if ACell.BoundaryCount > 0 then
        begin
          CenterPoint := ACell.CenterPoint;
          try
            ListOfBoundaryLists.Clear;
            MainBoundaryList.Clear;
            MainBoundaryList.Capacity := ACell.BoundaryCount;
            for BoundaryIndex := 0 to ACell.BoundaryCount - 1 do
            begin
              MainBoundaryList.Add(ACell.BoundaryList[BoundaryIndex]);
            end;
            while MainBoundaryList.Count > 0 do
            begin
              BoundaryList := TTypedBoundaryList.Create;
              ListOfBoundaryLists.Add(BoundaryList);

              ABoundary := MainBoundaryList[MainBoundaryList.Count - 1];
              MainBoundaryList.Delete(MainBoundaryList.Count - 1);
              BoundaryList.Add(ABoundary);

              for BoundaryIndex := MainBoundaryList.Count - 1 downto 0 do
              begin
                AnotherBoundary := MainBoundaryList[BoundaryIndex];
                if ABoundary.SimilarBoundary(AnotherBoundary) then
                begin
                  MainBoundaryList.Delete(BoundaryIndex);
                  BoundaryList.Add(AnotherBoundary);
                end;
              end;
              BoundaryList.Sort(StressPeriodBoundarySort);
            end;
            for ListIndex := 0 to ListOfBoundaryLists.Count - 1 do
            begin
              BoundaryList := ListOfBoundaryLists[ListIndex]
                as TTypedBoundaryList;
              case BoundaryList.BoundaryType of
                btMF2K_Well:
                  begin
                    MakeMF2K_WellBoundaries(BoundaryList, CenterPoint);
                  end;
                btMF2K_River:
                  begin
                    MakeMF2K_RiverBoundaries(BoundaryList, CenterPoint);
                  end;
                btMF2K_Drain:
                  begin
                    MakeMF2K_DrainBoundaries(BoundaryList, CenterPoint);
                  end;
                btMF2K_GHB:
                  begin
                    MakeMF2K_GHB_Boundaries(BoundaryList, CenterPoint);
                  end;
                btFHBFlux:
                  begin
                  end;
                btFHBHead:
                  begin
                  end;
                btStream, btHFB:
                  begin
                  end;
                btMF2K_CHD:
                  begin
                    MakeMF2K_CHD_Boundaries(BoundaryList, CenterPoint);
                  end;
              else
                Assert(False);
              end;

            end;

            // now make boundaries
          finally
            CenterPoint.Free;
          end;
        end;
      end;
    end;
  finally
    ListOfBoundaryLists.Free;
    MainBoundaryList.Free;
  end;
end;

{ TTypedBoundaryList }

function TTypedBoundaryList.Add(Item: Pointer): Integer;
var
  ACustomBoundary: TCustomBoundary;
begin
  ACustomBoundary := Item;
  if Count = 0 then
  begin
    FBoundaryType := GetType(ACustomBoundary);
    FLayer := ACustomBoundary.Layer;
  end
  else
  begin
    Assert(FBoundaryType = GetType(ACustomBoundary));
    Assert(FLayer = ACustomBoundary.Layer);
  end;
  result := inherited Add(Item);
end;

function TTypedBoundaryList.GetType(
  Boundary: TCustomBoundary): TBoundaryType;
begin
  result := btDrain;
  if Boundary is TDrainBoundary then
    result := btDrain
  else if Boundary is TGHBBoundary then
    result := btGHB
  else if Boundary is THorizontalFlowBoundary then
    result := btHFB
  else if Boundary is TRiverBoundary then
    result := btRiver
  else if Boundary is TStreamBoundary then
    result := btStream
  else if Boundary is TWellBoundary then
    result := btWell
  else if Boundary is TFHBHeadBoundary then
    result := btFHBHead
  else if Boundary is TFHBFlowBoundary then
    result := btFHBFlux
  else if Boundary is TMF2K_WellBoundary then
    result := btMF2K_Well
  else if Boundary is TMF2KDrainBoundary then
    result := btMF2K_Drain
  else if Boundary is TMF2K_GHBBoundary then
    result := btMF2K_GHB
  else if Boundary is TMF2K_RiverBoundary then
    result := btMF2K_River
  else if Boundary is TMF2K_CHD_Boundary then
    result := btMF2K_CHD
  else
    Assert(False);
end;

{ TtypedEditContours }

constructor TtypedEditContours.Create(AnOriginX, AnOriginY, AGridAngle: double;
  ABoundaryType: TBoundaryType; ALayer: integer);
begin
  inherited Create(AnOriginX, AnOriginY, AGridAngle);
  FBoundaryType := ABoundaryType;
  FLayer := ALayer;
  ParameterNames := TStringList.Create;
  ParameterIndicies := TIntegerList.Create;
  GetParameterIndicies;
end;

destructor TtypedEditContours.Destroy;
begin
  ParameterNames.Free;
  ParameterIndicies.Free;
  inherited;
end;

procedure TtypedEditContours.GetParameterIndicies;
var
  ALayer: T_ANE_InfoLayer;
  LayerHandle: ANE_PTR;
  ParameterName: string;
  AParam: T_ANE_Param;
  LayerOptions: TLayerOptions;
  ParameterIndex: integer;
  ParameterListIndex: integer;
  ParameterList: T_ANE_ParameterList;
  procedure GetParameters(IndexString: string);
  var
    ParameterLoopIndex: integer;
  begin
    for ParameterLoopIndex := 0 to ParameterList.Count - 1 do
    begin
      AParam := ParameterList.Items[ParameterLoopIndex];
      ParameterName := AParam.OldName;
      ParameterIndex := LayerOptions.GetParameterIndex
        (frmModflow.CurrentModelHandle, ParameterName);
      Assert(ParameterIndex > -1);
      ParameterNames.Add(AParam.ANE_ParamName + IndexString);
      ParameterIndicies.Add(ParameterIndex);
    end;
  end;
begin
  ALayer := PieLayer;
  LayerHandle := ArgusLayerHandle;
  if LayerHandle <> nil then
  begin
    ParameterNames.Clear;
    ParameterIndicies.Clear;
    LayerOptions := TLayerOptions.Create(LayerHandle);
    try
      ParameterList := ALayer.ParamList;
      GetParameters('');
      for ParameterListIndex := 0 to ALayer.IndexedParamListNeg1.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamListNeg1.Items[ParameterListIndex];
        GetParameters(intToStr(ParameterListIndex + 1));
      end;
      for ParameterListIndex := 0 to ALayer.IndexedParamList0.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamList0.Items[ParameterListIndex];
        GetParameters(intToStr(ParameterListIndex + 1));
      end;
      for ParameterListIndex := 0 to ALayer.IndexedParamList1.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamList1.Items[ParameterListIndex];
        GetParameters(intToStr(ParameterListIndex + 1));
      end;
      for ParameterListIndex := 0 to ALayer.IndexedParamList2.Count - 1 do
      begin
        ParameterList := ALayer.IndexedParamList2.Items[ParameterListIndex];
        GetParameters(intToStr(ParameterListIndex + 1));
      end;
    finally
      LayerOptions.Free(frmModflow.CurrentModelHandle);
    end;
    SetMaxValue;
  end
end;

function TtypedEditContours.ArgusLayerHandle: ANE_PTR;
var
  AneLayer: T_ANE_InfoLayer;
begin
  AneLayer := PieLayer;

  if AneLayer = nil then
  begin
    result := nil;
  end
  else
  begin
    result := AneLayer.GetLayerHandle(frmModflow.CurrentModelHandle);
  end;
end;

function TtypedEditContours.PieLayer: T_ANE_InfoLayer;
var
  LayerName: string;
begin
  result := nil;
  if FLayer > frmModflow.MODFLOWLayerCount then
  begin
    Exit;
  end;

  case FBoundaryType of
    btWell, btMF2K_Well:
      begin
        LayerName := ModflowTypes.GetMFWellLayerType.ANE_LayerName;
      end;
    btRiver, btMF2K_River:
      begin
        LayerName := ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName;
      end;
    btDrain, btMF2K_Drain:
      begin
        LayerName := ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName;
      end;
    btGHB, btMF2K_GHB:
      begin
        LayerName := ModflowTypes.GetPointGHBLayerType.ANE_LayerName;
      end;
    btFHBFlux:
      begin
        LayerName := ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName;
      end;
    btFHBHead:
      begin
        LayerName := ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName;
      end;
    btStream:
      begin
        LayerName := ModflowTypes.GetMFStreamLayerType.ANE_LayerName;
      end;
    btHFB:
      begin
        LayerName := ModflowTypes.GetMFHFBLayerType.ANE_LayerName;
      end;
    btMF2K_FHB:
      begin
        LayerName := ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName;
      end;
    btMF2K_CHD:
      begin
        LayerName := ModflowTypes.GetMFPointLineCHD_LayerType.ANE_LayerName;
      end;
    btMF2K_HFB:
      begin
        LayerName := ModflowTypes.GetMFHFBLayerType.ANE_LayerName;
      end;
  else
    Assert(False);
  end;

  result := frmModflow.MFLayerStructure.ListsOfIndexedLayers.
    Items[Layer - 1].GetLayerByName(LayerName) as T_ANE_InfoLayer;

end;

constructor TBoundaryContour.Create(AnEditContours: TtypedEditContours);
var
  ParameterIndex: integer;
begin
  inherited Create;
  EditContours := AnEditContours;
  Values := TStringList.Create;
  Values.Capacity := EditContours.ParameterNames.Count;
  for ParameterIndex := 0 to EditContours.ParameterNames.Count - 1 do
  begin
    Values.Add(kNa);
  end;
  SetParamName;
end;

destructor TBoundaryContour.Destroy;
begin
  Values.Free;
  inherited;
end;

function TBoundaryContour.GetAValue(const ParameterName: string): string;
var
  Index: integer;
begin
  Index := EditContours.ParameterNames.IndexOf(ParameterName);
  Assert((Index > -1) and (Index < Values.Count));

  result := Values[Index];
end;

procedure TBoundaryContour.SetAValue(const ParameterName: string; AValue: string);
var
  Index: integer;
  IsIndex: integer;
begin
  Index := EditContours.ParameterNames.IndexOf(ParameterName);
  Assert((Index > -1) and (Index < Values.Count));

  AValue := Trim(AValue);
  if Pos(' ', AValue) >= 1 then
  begin
    AValue := '"' + AValue + '"';
  end;

  Values[Index] := AValue;

  if (ParameterName = TModflowParameterNameParam.ANE_ParamName)
    and (AValue <> '0') and (AValue <> KNA)and (AValue <> '""')
    and (AValue <> '') then
  begin
    IsIndex := EditContours.ParameterNames.IndexOf(
      TIsParameterParam.ANE_ParamName);
    if IsIndex >= 0 then
    begin
      Values[IsIndex] := '1';
    end;

  end;

end;

procedure TBoundaryContour.SetParamName;
var
  AName: string;
begin
  AName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  if EditContours.ParameterNames.IndexOf(AName) > -1 then
  begin
    SetAValue(AName, '0');
  end;
end;

procedure TBoundaryContour.SetValue;
var
  TempValues: TStringList;
  Index: integer;
  MaxIndex: integer;
  ParamIndex: integer;
begin
  TempValues := TStringList.Create;
  try
    MaxIndex := EditContours.MaxValue;
    TempValues.Capacity := MaxIndex + 1;
    for Index := 0 to MaxIndex do
    begin
      TempValues.Add(kNa);
    end;
    for Index := 0 to EditContours.ParameterIndicies.Count - 1 do
    begin
      ParamIndex := EditContours.ParameterIndicies[Index];
      TempValues[ParamIndex] := Values[Index];
    end;
    if TempValues.Count = 0 then
    begin
      Value := '';
    end
    else
    begin
      Value := TempValues[0];
      for Index := 1 to TempValues.Count - 1 do
      begin
        Value := Value + Char(9) + TempValues[Index];
      end;
    end;
  finally
    TempValues.Free;
  end;
end;

procedure TtypedEditContours.SetMaxValue;
begin
  MaxValue := ParameterIndicies.MaxValue;
end;

function TfrmModflowImport.GetATypedEditContours(
  BoundaryType: TBoundaryType; Layer: integer): TtypedEditContours;
var
  Index: integer;
  AnEditContours: TtypedEditContours;
begin
  for Index := 0 to EditContoursList.Count - 1 do
  begin
    AnEditContours := EditContoursList[Index] as TtypedEditContours;
    if AnEditContours.BoundaryType = BoundaryType then
    begin
      case AnEditContours.BoundaryType of
        btMF2K_FHB:
          begin
            if AnEditContours.FLayer = Layer then
            begin
              result := AnEditContours;
              Exit;
            end;
          end;
      else
        begin
          if AnEditContours.FLayer = Layer then
          begin
            result := AnEditContours;
            Exit;
          end;
        end;
      end;

    end;
  end;
  result := TtypedEditContours.Create(InternationalStrToFloat(adeOrX.Text),
    InternationalStrToFloat(adeOry.Text),
    InternationalStrToFloat(adeGridAngle.Text) * Pi / 180,
    BoundaryType, Layer);
  EditContoursList.Add(result);
end;

procedure TfrmModflowImport.EdNameDuplicateChange(Sender: TObject);
begin
  inherited;
  edName.Text := EdNameDuplicate.Text;
  btnNext.Enabled := FileExists(EdNameDuplicate.Text);
end;

procedure TfrmModflowImport.rgPreprocessorClick(Sender: TObject);
begin
  inherited;
  if rgPreprocessor.ItemIndex = 0 then
  begin
    dgNameFile.Cells[1, 2] := '5';
  end
  else
  begin
    dgNameFile.Cells[1, 2] := '1';
  end;

  case rgPreprocessor.ItemIndex of
    0: // USGS
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'TLK';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'DE4';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'PCG';
        dgIUNIT.Cells[13, 1] := 'GFD';
        dgIUNIT.Cells[14, 1] := 'None';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'RES';
        dgIUNIT.Cells[17, 1] := 'STR';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'FHB';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'None';
        dgIUNIT.Cells[23, 1] := 'None';
      end;
    1: // Kerr Lab
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'None';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'None';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'PCG';
        dgIUNIT.Cells[13, 1] := 'STR';
        dgIUNIT.Cells[14, 1] := 'None';
        dgIUNIT.Cells[15, 1] := 'None';
        dgIUNIT.Cells[16, 1] := 'None';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'None';
        dgIUNIT.Cells[19, 1] := 'None';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'None';
        dgIUNIT.Cells[23, 1] := 'None';
      end;
    2: // MODFLOW386
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'None';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'None';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'None';
        dgIUNIT.Cells[13, 1] := 'STR';
        dgIUNIT.Cells[14, 1] := 'PCG';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'None';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'None';
        dgIUNIT.Cells[23, 1] := 'None';
      end;
    3: // Visual MODFLOW
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'None';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'None';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'PCG';
        dgIUNIT.Cells[13, 1] := 'STR';
        dgIUNIT.Cells[14, 1] := 'GFD';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'None';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'None';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'BCF';
        dgIUNIT.Cells[23, 1] := 'BCF';
      end;
    4: // GMS
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'None';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'None';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'PCG';
        dgIUNIT.Cells[13, 1] := 'GFD';
        dgIUNIT.Cells[14, 1] := 'None';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'None';
        dgIUNIT.Cells[17, 1] := 'STR';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'BCF';
        dgIUNIT.Cells[23, 1] := 'BCF';
      end;
    5: // Processing MODFLOW
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'TLK';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'None';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'PCG';
        dgIUNIT.Cells[13, 1] := 'STR';
        dgIUNIT.Cells[14, 1] := 'GFD';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'RES';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'BCF';
        dgIUNIT.Cells[23, 1] := 'BCF';
      end;
    6: // IGWMC
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'None';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'PCG';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'STR';
        dgIUNIT.Cells[13, 1] := 'None';
        dgIUNIT.Cells[14, 1] := 'None';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'None';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'None';
        dgIUNIT.Cells[23, 1] := 'None';
      end;
    7: // S. S. Papadopulos
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'None';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'None';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'PCG';
        dgIUNIT.Cells[13, 1] := 'STR';
        dgIUNIT.Cells[14, 1] := 'None';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'None';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'None';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'None';
        dgIUNIT.Cells[23, 1] := 'None';
      end;
    8: // Groundwater Vistas
      begin
        dgIUNIT.Cells[0, 1] := 'BCF';
        dgIUNIT.Cells[1, 1] := 'WEL';
        dgIUNIT.Cells[2, 1] := 'DRN';
        dgIUNIT.Cells[3, 1] := 'RIV';
        dgIUNIT.Cells[4, 1] := 'EVT';
        dgIUNIT.Cells[5, 1] := 'TLK';
        dgIUNIT.Cells[6, 1] := 'GHB';
        dgIUNIT.Cells[7, 1] := 'RCH';
        dgIUNIT.Cells[8, 1] := 'SIP';
        dgIUNIT.Cells[9, 1] := 'DE4';
        dgIUNIT.Cells[10, 1] := 'SOR';
        dgIUNIT.Cells[11, 1] := 'OC';
        dgIUNIT.Cells[12, 1] := 'None';
        dgIUNIT.Cells[13, 1] := 'STR';
        dgIUNIT.Cells[14, 1] := 'PCG';
        dgIUNIT.Cells[15, 1] := 'HFB';
        dgIUNIT.Cells[16, 1] := 'RES';
        dgIUNIT.Cells[17, 1] := 'None';
        dgIUNIT.Cells[18, 1] := 'IBS';
        dgIUNIT.Cells[19, 1] := 'CHD';
        dgIUNIT.Cells[20, 1] := 'GFD';
        dgIUNIT.Cells[21, 1] := 'None';
        dgIUNIT.Cells[22, 1] := 'None';
        dgIUNIT.Cells[23, 1] := 'None';
      end;
  end;
end;

procedure TfrmModflowImport.dgNameFileEditButtonClick(Sender: TObject);
var
  Col, Row: integer;
  Name: string;
  FileType: string;
begin
  inherited;
  Row := dgNameFile.Selection.Top;
  FileType := dgNameFile.Cells[0, Row];
  OpenDialog1.Filter := FileType + ' Files (*.' + FileType + ')|*.' + FileType +
    '|All Files (*.*)|*.*';
  OpenDialog1.FilterIndex := 1;
  OpenDialog1.Title := 'Select ' + FileType + ' input file';
  OpenDialog1.FileName := '';
  OpenDialog1.InitialDir := GetCurrentDir;
  if OpenDialog1.Execute then
  begin
    Col := dgNameFile.Selection.Left;
    Name := ExtractFileName(OpenDialog1.FileName);
    if Pos(' ', Name) > 0 then
    begin
      dgNameFile.Cells[Col, Row] := '''' + Name + '''';
    end
    else
    begin
      dgNameFile.Cells[Col, Row] := Name;
    end;
  end;
end;

procedure TfrmModflowImport.edNameChange(Sender: TObject);
begin
  inherited;
  EdNameDuplicate.Text := edName.Text;
  btnNext.Enabled := edName.Text <> '';
end;

procedure TfrmModflowImport.tabCreateNameFileShow(Sender: TObject);
begin
  inherited;
  edNameChange(Sender)
end;

procedure TfrmModflowImport.tabModelPropertiesShow(Sender: TObject);
begin
  inherited;
  btnNext.ModalResult := mrOK;
  btnNext.Caption := '&Finish';
end;

procedure TfrmModflowImport.adeNFilesChange(Sender: TObject);
begin
  inherited;
  dgNameFile.RowCount := StrToInt(adeNFiles.Text) + 1;
end;

procedure TfrmModflowImport.dgNameFileSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  if (ARow > 0) and (ACol = 1) and (Value <> '') then
  begin
    try
      StrToInt(Value);
    except on EConvertError do
      begin
        Beep;
        MessageDlg('Error: ' + Value + ' is not an integer.', mtError, [mbOK],
          0);
      end;
    end;
  end;
end;

function TfrmModflowImport.GetXX(IXINDEX: integer): single;
var
  MyIxIndex: longint;
begin
  MyIxIndex := IXINDEX + 1;
  GetValue(MyIxIndex, result);
end;

procedure TfrmModflowImport.pcMainChange(Sender: TObject);
begin
  inherited;
  FreePageControlResources(pcMain, Handle);
end;

procedure TfrmModflowImport.Button1Click(Sender: TObject);
var
  AStringList: TStringList;
  Index: integer;
begin
  inherited;
  if OpenDialog2.Execute then
  begin
    AStringList := TStringList.Create;
    try
      for Index := 0 to OpenDialog2.Files.Count - 1 do
      begin
        AStringList.LoadFromFile(OpenDialog2.Files[Index]);
        AStringList.SaveToFile(OpenDialog2.Files[Index]);
      end;
    finally
      AStringList.Free;
    end;
    ShowMessage('Done');
  end;

end;

procedure TfrmModflowImport.AssignMF2K_Packages;
begin
  if MF2K_Importer.IUNIT[0] > 0 then
  begin
    // BCF package
    frmModflow.rgFlowPackage.ItemIndex := 0;
  end;
  if MF2K_Importer.IUNIT[1] > 0 then
  begin
    // Well package
    frmModflow.cbWEL.Checked := True;
    frmModflow.cbUseAreaWells.Checked := False;
  end;
  if MF2K_Importer.IUNIT[2] > 0 then
  begin
    // Drain package
    frmModflow.cbDRN.Checked := True;
    frmModflow.cbUseAreaDrains.Checked := False;
  end;
  if MF2K_Importer.IUNIT[3] > 0 then
  begin
    // River package
    frmModflow.cbRIV.Checked := True;
    frmModflow.cbUseAreaRivers.Checked := False;
  end;
  if MF2K_Importer.IUNIT[4] > 0 then
  begin
    // Evapotranspiration package
    frmModflow.cbEVT.Checked := True;
  end;
  // IUNIT[5] not used
  if MF2K_Importer.IUNIT[6] > 0 then
  begin
    // GHB package
    frmModflow.cbGHB.Checked := True;
    frmModflow.cbUseAreaGHBs.Checked := False;
  end;
  if MF2K_Importer.IUNIT[7] > 0 then
  begin
    // Recharge package
    frmModflow.cbRCH.Checked := True;
  end;
  if MF2K_Importer.IUNIT[8] > 0 then
  begin
    // SIP package
    frmModflow.rgSolMeth.ItemIndex := 0;
  end;
  if MF2K_Importer.IUNIT[9] > 0 then
  begin
    // DE4 package
    frmModflow.rgSolMeth.ItemIndex := 1;
  end;
  if MF2K_Importer.IUNIT[10] > 0 then
  begin
    // DE4 package
    frmModflow.rgSolMeth.ItemIndex := 3;
  end;
  // MF2K_Importer.IUNIT[11] = output control
  if MF2K_Importer.IUNIT[12] > 0 then
  begin
    // PCG package
    frmModflow.rgSolMeth.ItemIndex := 2;
  end;
  if MF2K_Importer.IUNIT[13] > 0 then
  begin
    // LMG package
    frmModflow.rgSolMeth.ItemIndex := 4;
  end;
  // MF2K_Importer.IUNIT[14] = ground water transport
  if MF2K_Importer.IUNIT[15] > 0 then
  begin
    // FHB package
    frmModflow.cbFHB.Checked := True;
  end;
  if MF2K_Importer.IUNIT[16] > 0 then
  begin
    // Reservoir package
    frmModflow.cbRES.Checked := True;
  end;
  if MF2K_Importer.IUNIT[17] > 0 then
  begin
    // Stream package
    frmModflow.cbSTR.Checked := True;
  end;
  if MF2K_Importer.IUNIT[18] > 0 then
  begin
    // IBS package
    frmModflow.cbIBS.Checked := True;
  end;
  if MF2K_Importer.IUNIT[19] > 0 then
  begin
    // CHD package
    frmModflow.cbCHD.Checked := True;
    frmModflow.cbUseAreaCHD.Checked := False;
  end;
  if MF2K_Importer.IUNIT[20] > 0 then
  begin
    // HFB package
    frmModflow.cbHFB.Checked := True;
  end;
  if MF2K_Importer.IUNIT[21] > 0 then
  begin
    // Lake package
    frmModflow.cbLAK.Checked := True;
  end;
  if MF2K_Importer.IUNIT[22] > 0 then
  begin
    // LPF package
    frmModflow.rgFlowPackage.ItemIndex := 1;
  end;
  // MF2K_Importer.IUNIT[23] discretization
  if MF2K_Importer.IUNIT[24] > 0 then
  begin
    // Sensitivity process
    frmModflow.cbSensitivity.Checked := True;
  end;
  if MF2K_Importer.IUNIT[25] > 0 then
  begin
    // parameter estimation process
    frmModflow.cbParamEst.Checked := True;
  end;
  if MF2K_Importer.IUNIT[26] > 0 then
  begin
    // observation process
    frmModflow.cbObservations.Checked := True;
    frmModflow.cbCreateObsOutput.Checked := True;
  end;
  if MF2K_Importer.IUNIT[27] > 0 then
  begin
    // Head observation package
    frmModflow.cbWeightedHeadObservations.Checked := True;
  end;
  if MF2K_Importer.IUNIT[28] > 0 then
  begin
    // Advection observation package
    frmModflow.cbAdvObs.Checked := True;
  end;
  // MF2K_Importer.IUNIT[29] = COB?
  // MF2K_Importer.IUNIT[30] = Zone arrays
  // MF2K_Importer.IUNIT[31] = multiplier arrays
  if MF2K_Importer.IUNIT[32] > 0 then
  begin
    // drain observation package
    frmModflow.cbDRNObservations.Checked := True;
  end;
  if MF2K_Importer.IUNIT[33] > 0 then
  begin
    // river observation package
    frmModflow.cbRIVObservations.Checked := True;
  end;
  if MF2K_Importer.IUNIT[34] > 0 then
  begin
    // GHB observation package
    frmModflow.cbGHBObservations.Checked := True;
  end;
  if MF2K_Importer.IUNIT[35] > 0 then
  begin
    // Stream observation package
    frmModflow.cbStreamObservations.Checked := True;
  end;
  if MF2K_Importer.IUNIT[36] > 0 then
  begin
    // HUF package
    frmModflow.rgFlowPackage.ItemIndex := 2;
  end;
  if MF2K_Importer.IUNIT[37] > 0 then
  begin
    // head flux observation package
    frmModflow.cbHeadFluxObservations.Checked := True;
  end;
  if MF2K_Importer.IUNIT[38] > 0 then
  begin
    // Evapotranspiration Segments package
    frmModflow.cbETS.Checked := True;
  end;
  if MF2K_Importer.IUNIT[39] > 0 then
  begin
    // Drain Return package
    frmModflow.cbDRT.Checked := True;
  end;
  if MF2K_Importer.IUNIT[40] > 0 then
  begin
    // Drain Return observations package
    frmModflow.cbDRTObservations.Checked := True;
  end;
  // MF2K_Importer.IUNIT[41] = not used
  if MF2K_Importer.IUNIT[42] > 0 then
  begin
    // Hydrograph package
    frmModflow.cbHYD.Checked := True;
  end;
  // MF2K_Importer.IUNIT[43] = sfr, not yet released
  // MF2K_Importer.IUNIT[44] = SFOB?
  // MF2K_Importer.IUNIT[45] = Gage package
  // MF2K_Importer.IUNIT[46] = LVDA
  // MF2K_Importer.IUNIT[47] = not used
  if MF2K_Importer.IUNIT[48] > 0 then
  begin
    // link to MT3D package
    frmModflow.cbMT3D.Checked := True;
  end;
  if MF2K_Importer.IUNIT[49] > 0 then
  begin
    // Multi-node well package
    frmModflow.cbMNW.Checked := True;
  end;
  if (MF2K_Importer.IUNIT[50] > 0) or (MF2K_Importer.IUNIT[51] > 0) then
  begin
    // DAFLOW package
    frmModflow.cbDAFLOW.Checked := True;
  end;
  // MF2K_Importer.IUNIT[52] = KDEP
  if MF2K_Importer.IUNIT[53] > 0 then
  begin
    // Subsidence package
    frmModflow.cbSub.Checked := True;
  end;
  if MF2K_Importer.IUNIT[41] > 0 then
  begin
    // GMG package
    frmModflow.rgSolMeth.ItemIndex := 5;
  end;

end;

procedure TfrmModflowImport.SetUpHufUnits;
var
  Index, UnitIndex: integer;
  Value: single;
  Layer, IValue: longint;
  Dummy: boolean;
  CellText: string;
  HufUnit: TString11;
begin
  if MF2K_Importer.IUNIT[36] <> 0 then
  begin
    frmModflow.framHUF1.adeHufUnitCount.Text := IntToStr(MF2K_Importer.NHUF);
    frmModflow.framHUF1adeHufUnitCountExit(nil);
    for Index := 1 to MF2K_Importer.NHUF do
    begin
      Layer := Index;

      HufUnit := '           ';
      GetHGUNAME(Layer, HufUnit, 11);
      frmModflow.framHUF1.dgHufUnits.Cells[0,Index] := Trim(HufUnit);

      GetHGUHANI(Layer, Value);
      frmModflow.framHUF1.dgHufUnits.Cells[1,Index] := FloatToStr(Value);

      GetHGUVANI(Layer, Value);
      frmModflow.framHUF1.dgHufUnits.Cells[2,Index] := FloatToStr(Value);
    end;
    for Index := 1 to MF2K_Importer.NLAY do
    begin
      Layer := Index;
      UnitIndex := frmModflow.GetUnitIndex(Index);

      GetHufLaytype(Layer, IValue);
      if IValue <> 0 then
      begin
        IValue := 1;
      end;
      MF2K_Importer.LAYCON[Index-1] := IValue;
      {Dummy := True;
      frmModflow.dgGeolSelectCell(nil, Ord(nuiType), UnitIndex, Dummy);
      CellText := frmModflow.dgGeol.Columns[Ord(nuiType)].
        PickList[IValue];
      frmModflow.dgGeol.Cells[Ord(nuiType), UnitIndex] := CellText;
      frmModflow.dgGeolSetEditText(nil, Ord(nuiType), UnitIndex,
        CellText); }

      GetHufLaywet(Layer, IValue);
      if IValue <> 0 then
      begin
        IValue := 1;
        frmModflow.comboWetCap.ItemIndex := 1;
      end;
      Dummy := True;
      frmModflow.dgGeolSelectCell(nil, Ord(nuiWettingActive), UnitIndex, Dummy);
      CellText := frmModflow.dgGeol.Columns[Ord(nuiWettingActive)].
        PickList[IValue];
      frmModflow.dgGeol.Cells[Ord(nuiWettingActive), UnitIndex] := CellText;
      frmModflow.dgGeolSetEditText(nil, Ord(nuiWettingActive), UnitIndex,
        CellText);
    end;
  end;
end;

procedure TfrmModflowImport.SetUpGeoUnits;
var
  TotalLayers: integer;
  Index: integer;
  GeoUnit: integer;
  SimString, NonSimString: string;
  Dummy: boolean;
  UnitName: string;
  LAYWET: integer;
  WetString: string;
begin
  TotalLayers := MF2K_Importer.NLAY;
  for Index := 0 to MF2K_Importer.NLAY - 1 do
  begin
    if MF2K_Importer.LAYCBD[Index] <> 0 then
    begin
      Inc(TotalLayers);
    end;
  end;
  frmModflow.edNumUnitsEnter(nil);
  frmModflow.edNumUnits.Text := IntToStr(TotalLayers);
  frmModflow.edNumUnitsExit(nil);
  GeoUnit := 0;
  NonSimString := frmModflow.dgGeol.Columns[Ord(nuiSim)].PickList[0];
  SimString := frmModflow.dgGeol.Columns[Ord(nuiSim)].PickList[1];
  for Index := 1 to MF2K_Importer.NLAY do
  begin
    Inc(GeoUnit);
    UnitName := 'Simulated Unit' + IntToStr(Index);
    frmModflow.dgGeolSelectCell(nil, Ord(nuiName), GeoUnit, Dummy);
    frmModflow.dgGeol.Cells[Ord(nuiName), GeoUnit] := UnitName;
    frmModflow.dgGeolSetEditText(nil, Ord(nuiName), GeoUnit, UnitName);

    frmModflow.dgGeolSelectCell(nil, Ord(nuiSim), GeoUnit, Dummy);
    frmModflow.dgGeol.Cells[Ord(nuiSim), GeoUnit] := SimString;
    frmModflow.dgGeolSetEditText(nil, Ord(nuiSim), GeoUnit, SimString);

    LAYWET := 0;
    if MF2K_Importer.IUNIT[22] <> 0 then
    begin
      LAYWET := MF2K_Importer.LAYWET[Index - 1];
      if LAYWET <> 0 then
      begin
        LAYWET := 1;
        frmModflow.comboWetCap.ItemIndex := 1;
        frmModflow.comboWetCapChange(nil);
      end;
    end
    else if MF2K_Importer.IUNIT[0] <> 0 then
    begin
      if (MF2K_Importer.IWDFLG <> 0) and (MF2K_Importer.LAYCON[Index - 1] in [1,
        3]) then
      begin
        LAYWET := 1;
      end;
    end;
    WetString :=
      frmModflow.dgGeol.Columns[Ord(nuiWettingActive)].PickList[LAYWET];
    frmModflow.dgGeolSelectCell(nil, Ord(nuiWettingActive), GeoUnit, Dummy);
    frmModflow.dgGeol.Cells[Ord(nuiWettingActive), GeoUnit] := WetString;
    frmModflow.dgGeolSetEditText(nil, Ord(nuiWettingActive), GeoUnit,
      SimString);

    if MF2K_Importer.LAYCBD[Index - 1] <> 0 then
    begin
      Inc(GeoUnit);
      UnitName := 'Confining Bed' + IntToStr(Index);
      frmModflow.dgGeolSelectCell(nil, Ord(nuiName), GeoUnit, Dummy);
      frmModflow.dgGeol.Cells[Ord(nuiName), GeoUnit] := UnitName;
      frmModflow.dgGeolSetEditText(nil, Ord(nuiName), GeoUnit, UnitName);

      frmModflow.dgGeolSelectCell(nil, Ord(nuiSim), GeoUnit, Dummy);
      frmModflow.dgGeol.Cells[Ord(nuiSim), GeoUnit] := NonSimString;
      frmModflow.dgGeolSetEditText(nil, Ord(nuiSim), GeoUnit, NonSimString);
    end;
  end;
end;

procedure TfrmModflowImport.SetUpStressPeriods;
var
  TimeIndex: integer;
  Dummy: boolean;
  NewValue: string;
  TransientString, SteadyStateString: string;
begin
  frmModflow.edNumPerEnter(nil);
  frmModflow.edNumPer.Text := IntToStr(MF2K_Importer.NPER);
  frmModflow.edNumPerExit(nil);

  TransientString := frmModflow.dgTime.Columns[Ord(tdSsTr)].PickList[0];
  SteadyStateString := frmModflow.dgTime.Columns[Ord(tdSsTr)].PickList[1];
  for TimeIndex := 1 to MF2K_Importer.NPER do
  begin
    frmModflow.sgTimeSelectCell(nil, Ord(tdLength), TimeIndex, Dummy);
    NewValue := SingleToStr(MF2K_Importer.PERLEN[TimeIndex - 1]);
    frmModflow.dgTime.Cells[Ord(tdLength), TimeIndex] := NewValue;
    frmModflow.sgTimeSetEditText(nil, Ord(tdLength), TimeIndex, NewValue);

    frmModflow.sgTimeSelectCell(nil, Ord(tdNumSteps), TimeIndex, Dummy);
    NewValue := IntToStr(MF2K_Importer.NSTP[TimeIndex - 1]);
    frmModflow.dgTime.Cells[Ord(tdNumSteps), TimeIndex] := NewValue;
    frmModflow.sgTimeSetEditText(nil, Ord(tdNumSteps), TimeIndex, NewValue);

    frmModflow.sgTimeSelectCell(nil, Ord(tdMult), TimeIndex, Dummy);
    NewValue := SingleToStr(MF2K_Importer.TSMULT[TimeIndex - 1]);
    frmModflow.dgTime.Cells[Ord(tdMult), TimeIndex] := NewValue;
    frmModflow.sgTimeSetEditText(nil, Ord(tdMult), TimeIndex, NewValue);

    frmModflow.sgTimeSelectCell(nil, Ord(tdSsTr), TimeIndex, Dummy);
    if MF2K_Importer.ISSFLG[TimeIndex - 1] = 0 then
    begin
      NewValue := TransientString;
    end
    else
    begin
      NewValue := SteadyStateString;
    end;
    frmModflow.dgTime.Cells[Ord(tdSsTr), TimeIndex] := NewValue;
    frmModflow.sgTimeSetEditText(nil, Ord(tdSsTr), TimeIndex, NewValue);
  end;
end;

procedure TfrmModflowImport.SetUpMiscOptions;
  procedure ComboChange(AComboBox: TComboBox);
  begin
    if Assigned(AComboBox.OnChange) then
    begin
      AComboBox.OnChange(AComboBox);
    end;
  end;
var
  UnitIndex: integer;
  LAYAVG, LAYCON: integer;
  Row, Col: integer;
  GeoValue: string;
  CanSelect: boolean;
  Index: integer;
  HeadObs: THeadObservation;
  HeadObsTimeCount: integer;
  I: longInt;
  Value: single;
  Dummy: boolean;
begin
  with frmModflow do
  begin
    if MF2K_Importer.ISS = 0 then
    begin
      comboSteady.ItemIndex := 0;
    end
    else
    begin
      comboSteady.ItemIndex := 1;
    end;
    ComboChange(comboSteady);
    if MF2K_Importer.ITMUNI in [0..5] then
    begin
      comboTimeUnits.ItemIndex := MF2K_Importer.ITMUNI;
      ComboChange(comboTimeUnits);
    end;

    if MF2K_Importer.LENUNI in [0..3] then
    begin
      comboLengthUnits.ItemIndex := MF2K_Importer.LENUNI;
      ComboChange(comboLengthUnits);
    end;

    if MF2K_Importer.IUNIT[0] <> 0 then
    begin
      if MF2K_Importer.IWDFLG = 0 then
      begin
        comboWetCap.ItemIndex := 0;
      end
      else
      begin
        comboWetCap.ItemIndex := 1;
      end;
      ComboChange(comboWetCap);
    end;

    adeHDRY.Text := SingleToStr(MF2K_Importer.HDRY);
    adeWettingFact.Text := SingleToStr(MF2K_Importer.WETFCT);
    adeWetIterations.Text := IntToStr(MF2K_Importer.IWETIT);
    if MF2K_Importer.IHDWET = 0 then
    begin
      comboWetEq.ItemIndex := 0;
    end
    else
    begin
      comboWetEq.ItemIndex := 1;
    end;

    Row := 0;
    for UnitIndex := 0 to MF2K_Importer.NLAY - 1 do
    begin
      LAYAVG := MF2K_Importer.LAYAVG[UnitIndex];
      LAYCON := MF2K_Importer.LAYCON[UnitIndex];

      if rgFlowPackage.ItemIndex = 0 then
      begin
        Assert(LAYAVG in [0, 10, 20, 30]);
        LAYAVG := LAYAVG div 10;
      end;

      Assert((LAYCON > -1) and (LAYCON < 4));
      Assert((LAYAVG > -1) and (LAYAVG < 4));

      Inc(Row);

      Col := Ord(nuiSim);
      GeoValue := dgGeol.Columns[Col].PickList[1];
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiTrans);
      GeoValue := dgGeol.Columns[Col].PickList[LAYAVG];
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiType);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      GeoValue := dgGeol.Columns[Col].PickList[LAYCON];
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiAnis);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      GeoValue := FloatToStr(GetTRPY(UnitIndex));
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiVertDisc);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      GeoValue := '1';
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      Col := Ord(nuiSpecVCONT);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      if UnitIndex < NLAY - 1 then
      begin
        GeoValue := dgGeol.Columns[Col].PickList[1];
      end
      else
      begin
        GeoValue := dgGeol.Columns[Col].PickList[0];
      end;
      dgGeol.Cells[Col, Row] := GeoValue;
      dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

      CanSelect := True;
      Col := Ord(nuiSpecT);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      if CanSelect then
      begin
        GeoValue := dgGeol.Columns[Col].PickList[1];
        dgGeol.Cells[Col, Row] := GeoValue;
        dgGeolSetEditText(dgGeol, Col, Row, GeoValue);
      end;

      CanSelect := True;
      Col := Ord(nuiSpecSF1);
      dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
      if CanSelect then
      begin
        GeoValue := dgGeol.Columns[Col].PickList[1];
        dgGeol.Cells[Col, Row] := GeoValue;
        dgGeolSetEditText(dgGeol, Col, Row, GeoValue);
      end;

      if MF2K_Importer.IUNIT[22] <> 0 then
      begin
        Col := Ord(nuiSpecAnis);
        dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
        if MF2K_Importer.CHANI[UnitIndex] <= 0 then
        begin
          GeoValue := dgGeol.Columns[Col].Picklist[1];
        end
        else
        begin
          GeoValue := dgGeol.Columns[Col].Picklist[0];
        end;
        dgGeol.Cells[Col, Row] := GeoValue;
        dgGeolSetEditText(dgGeol, Col, Row, GeoValue);

        if MF2K_Importer.CHANI[UnitIndex] > 0 then
        begin
          Col := Ord(nuiAnis);
          dgGeolSelectCell(dgGeol, Col, Row, CanSelect);
          GeoValue := InternationalFloatToStr(MF2K_Importer.CHANI[UnitIndex]);
          dgGeol.Cells[Col, Row] := GeoValue;
          dgGeolSetEditText(dgGeol, Col, Row, GeoValue);
        end;
      end;

      if MF2K_Importer.LAYCBD[UnitIndex] <> 0 then
      begin
        Inc(Row);
      end;
    end;
  end;

  if frmModflow.cbRCH.Checked then
  begin
    frmModflow.comboRchOpt.ItemIndex := MF2K_Importer.NRCHOP - 1;
    ComboChange(frmModflow.comboRchOpt);
    if MF2K_Importer.NRCHOP = 2 then
    begin
      frmModflow.cbRechLayer.Checked := True;
    end;

  end;
  if frmModflow.cbEVT.Checked then
  begin
    frmModflow.comboEvtOption.ItemIndex := MF2K_Importer.NEVTOP - 1;
    frmModflow.comboEvtOptionChange(frmModflow.comboEvtOption);
    if frmModflow.comboEvtOption.ItemIndex = 1 then
    begin
      frmModflow.cbETLayer.Checked := True;
    end;

  end;
  if frmModflow.cbFHB.Checked then
  begin
    frmModflow.adeFHBNumTimesEnter(nil);
    frmModflow.adeFHBNumTimes.Text := IntToStr(MF2K_Importer.NBDTIM);
    frmModflow.adeFHBNumTimesExit(nil);
    for Index := 1 to MF2K_Importer.NBDTIM do
    begin
      I := Index;
      GetFhbBDTIM(I, MF2K_Importer.NBDTIM, Value);
      GeoValue := FloatToStr(Value);
      Dummy := True;
      frmModflow.sgFHBTimesSelectCell(nil, 1, Index, Dummy);
      frmModflow.sgFHBTimes.Cells[1, Index] := GeoValue;
      frmModflow.sgFHBTimesSetEditText(nil, 1, Index, GeoValue);
    end;
  end;

  case frmModflow.rgSolMeth.ItemIndex of
    0: // SIP
      begin
        frmModflow.adeSIPMaxIter.Text := IntToStr(MF2K_Importer.MXITER);
        frmModflow.adeSIPNumParam.Text := IntToStr(MF2K_Importer.NPARM);
        frmModflow.adeSIPAcclParam.Text := SingleToStr(MF2K_Importer.ACCL);
        frmModflow.adeSIPConv.Text := SingleToStr(MF2K_Importer.HCLOSE);
        if MF2K_Importer.IPCALC <> 0 then
        begin
          MF2K_Importer.IPCALC := 1;
        end;
        frmModflow.comboSIPIterSeed.ItemIndex := MF2K_Importer.IPCALC;
        frmModflow.adeSIPIterSeed.Text := SingleToStr(MF2K_Importer.WSEED);
        frmModflow.adeSIPPrint.Text := IntToStr(MF2K_Importer.IPRSIP);
      end;
    1: // DE4
      begin
        frmModflow.adeDE4MaxIter.Text := IntToStr(MF2K_Importer.ITMX);
        frmModflow.adeDE4MaxUp.Text := IntToStr(MF2K_Importer.MXUP);
        frmModflow.adeDE4MaxLow.Text := IntToStr(MF2K_Importer.MXLOW);
        frmModflow.adeDE4Band.Text := IntToStr(MF2K_Importer.MXBW);
        frmModflow.comboDE4Freq.ItemIndex := MF2K_Importer.IFREQ + 1;
        frmModflow.comboDE4Print.ItemIndex := MUTD4;
        frmModflow.adeDE4Accl.Text := SingleToStr(MF2K_Importer.ACCL);
        frmModflow.adeDE4Conv.Text := SingleToStr(MF2K_Importer.HCLOSE);
        frmModflow.adeDE4TimeStep.Text := IntToStr(MF2K_Importer.IPRD4);
      end;
    2: // PCG2
      begin
        frmModflow.adePCGMaxOuter.Text := IntToStr(MF2K_Importer.MXITER);
        frmModflow.adePCGMaxInner.Text := IntToStr(MF2K_Importer.ITER1);
        frmModflow.comboPCGPrecondMeth.ItemIndex := MF2K_Importer.NPCOND - 1;
        frmModflow.adePCGMaxHeadChange.Text :=
          SingleToStr(MF2K_Importer.HCLOSE);
        frmModflow.adePCGMaxResChange.Text := SingleToStr(MF2K_Importer.RCLOSE);
        frmModflow.adePCGRelax.Text := SingleToStr(MF2K_Importer.RELAX);
        if MF2K_Importer.NBPOL = 2 then
        begin
          frmModflow.comboPCGEigenValue.ItemIndex := 1;
        end
        else
        begin
          frmModflow.comboPCGEigenValue.ItemIndex := 0;
        end;

        frmModflow.adePCGPrintInt.Text := IntToStr(MF2K_Importer.IPRPCG);
        frmModflow.comboPCGPrint.ItemIndex := MF2K_Importer.MUTPCG;
        frmModflow.adePCGDamp.Text := SingleToStr(MF2K_Importer.DAMP);
      end;
    3: // SOR
      begin
        frmModflow.adeSORMaxIter.Text := IntToStr(MF2K_Importer.MXITER);
        frmModflow.adeSORAccl.Text := SingleToStr(MF2K_Importer.ACCL);
        frmModflow.adeSORConv.Text := SingleToStr(MF2K_Importer.HCLOSE);
        frmModflow.adeSORPri.Text := IntToStr(MF2K_Importer.IPRSOR);
      end;
    4: // lmg
      begin
        frmModflow.adeAMG_Stor1.Text := SingleToStr(MF2K_Importer.STOR1);
        frmModflow.adeAMG_Stor2.Text := SingleToStr(MF2K_Importer.STOR2);
        frmModflow.adeAMG_Stor3.Text := SingleToStr(MF2K_Importer.STOR3);
        frmModflow.cbAMG_ICG.Checked := MF2K_Importer.ICG = 1;
        frmModflow.ade_AMG_MXITER.Text := IntToStr(MF2K_Importer.MXITER);
        frmModflow.ade_AMG_MXCYC.Text := IntToStr(MF2K_Importer.MXCYC);
        frmModflow.ade_AMG_BCLOSE.Text := SingleToStr(MF2K_Importer.BCLOSE);
        if MF2K_Importer.DAMP = -1 then
        begin
          frmModflow.combo_AMG_DampingMethod.ItemIndex := 1;
        end
        else if MF2K_Importer.DAMP = -2 then
        begin
          frmModflow.combo_AMG_DampingMethod.ItemIndex := 2;
          frmModflow.ade_AMG_DUP.Text := SingleToStr(MF2K_Importer.DUP);
          frmModflow.ade_AMG_DLOW.Text := SingleToStr(MF2K_Importer.DLOW);
        end
        else if MF2K_Importer.DAMP > 0 then
        begin
          frmModflow.combo_AMG_DampingMethod.ItemIndex := 0;
          frmModflow.ade_AMG_DAMP.Text := SingleToStr(MF2K_Importer.DAMP);
        end
        else
        begin
          frmModflow.combo_AMG_DampingMethod.ItemIndex := 0;
          frmModflow.ade_AMG_DAMP.Text := '1';
        end;
        frmMODFLOW.combo_AMG_DampingMethodChange(nil);

        case MF2K_Importer.IOUTAMG of
          0:
            begin
              frmModflow.rb_AMG_IOUTAMG_0.Checked := True;
            end;
          1:
            begin
              frmModflow.rb_AMG_IOUTAMG_1.Checked := True;
            end;
          2:
            begin
              frmModflow.rb_AMG_IOUTAMG_2.Checked := True;
            end;
          3:
            begin
              frmModflow.rb_AMG_IOUTAMG_3.Checked := True;
            end;
        end;
      end;
    5:
      begin
        frmModflow.adeGmgRclose.Text := SingleToStr(MF2K_Importer.RCLOSE);
        frmModflow.adeGmgIiter.Text := IntToStr(MF2K_Importer.IITER);
        frmModflow.adeGmgHclose.Text := SingleToStr(MF2K_Importer.HCLOSE);
        frmModflow.adeGmgMxiter.Text := IntToStr(MF2K_Importer.MXITER);
        frmModflow.adeGmgDamp.Text := SingleToStr(MF2K_Importer.DAMP);
        frmModflow.comboGmgIadamp.ItemIndex := MF2K_Importer.IADAMP;
        frmModflow.comboGmgIoutgmg.ItemIndex := MF2K_Importer.IOUTGMG;
        frmModflow.comboGmgIsm.ItemIndex := MF2K_Importer.ISM;
        frmModflow.comboGmgIsc.ItemIndex := MF2K_Importer.ISC;
        frmModflow.comboGmgIscChange(nil);
        frmModflow.adeGmgRelax.Text := DoubleToStr(MF2K_Importer.GMGRELAX);

      end;
  end;
  if HeadObservationList.Count > 0 then
  begin
    frmModflow.cbWeightedHeadObservations.Checked := True;
    HeadObsTimeCount := 1;
    for Index := 0 to HeadObservationList.Count -1 do
    begin
      HeadObs := HeadObservationList[Index] as THeadObservation;
      if HeadObs.TimeList.Count > HeadObsTimeCount then
      begin
        HeadObsTimeCount := HeadObs.TimeList.Count;
      end;
    end;
    if HeadObsTimeCount > 1 then
    begin
      frmModflow.adeObsHeadCountEnter(nil);
      frmModflow.adeObsHeadCount.Text := IntToStr(HeadObsTimeCount);
      frmModflow.adeObsHeadCountExit(nil);
    end;
  end;
  if frmModflow.cbETS.Checked then
  begin
    frmModflow.comboEtsOption.ItemIndex := MF2K_Importer.NETSOP -1;
    frmModflow.comboEtsOptionChange(nil);
    if frmModflow.comboEtsOption.ItemIndex = 1 then
    begin
      frmModflow.cbETSLayer.Checked := True;
    end;

    frmModflow.adeIntElev.Text := IntToStr(MF2K_Importer.NETSEG-1);
    frmModflow.adeIntElevExit(nil);
  end;

end;

procedure TfrmModflowImport.SetZoneNames;
var
  Index: integer;
  NewName: string;
begin
  if MF2K_Importer.IUNIT[30] > 0 then
  begin
    frmModflow.adeZoneCount.Text := IntToStr(MF2K_Importer.NZONAR);
    frmModflow.adeZoneCountExit(nil);
    for Index := 1 to MF2K_Importer.NZONAR do
    begin
      NewName := ZONNAM(Index);
      frmModflow.sgZoneArrays.Cells[1, Index] := NewName;
      frmModflow.sgZoneArraysSetEditText(nil, 1, Index, NewName);
    end;
  end;
end;

procedure TfrmModflowImport.SetMultiplierNames;
var
  Index: integer;
  NewName: string;
  NewFunction: string;
  Dummy: boolean;
  DontUseFunction: string;
  UseFunction: string;
begin
  if MF2K_Importer.IUNIT[31] > 0 then
  begin
    DontUseFunction := frmModflow.dgMultiplier.Columns[2].PickList[0];
    UseFunction := frmModflow.dgMultiplier.Columns[2].PickList[1];
    frmModflow.adeMultCountEnter(nil);
    frmModflow.adeMultCount.Text := IntToStr(MF2K_Importer.NMLTAR);
    frmModflow.adeMultCountExit(nil);
    for Index := 1 to MF2K_Importer.NMLTAR do
    begin
      NewName := MLTNAM(Index);
      frmModflow.dgMultiplierSelectCell(nil, 1, Index, Dummy);
      frmModflow.dgMultiplier.Cells[1, Index] := NewName;
      frmModflow.dgMultiplierSetEditText(nil, 1, Index, NewName);
      NewFunction := MultiplierFunction(Index);
      if NewFunction = '' then
      begin
        frmModflow.dgMultiplierSelectCell(nil, 2, Index, Dummy);
        frmModflow.dgMultiplier.Cells[2, Index] := DontUseFunction;
        frmModflow.dgMultiplierSetEditText(nil, 2, Index, DontUseFunction);
        frmModflow.dgMultiplierSelectCell(nil, 3, Index, Dummy);
        frmModflow.dgMultiplier.Cells[3, Index] := '1';
        frmModflow.dgMultiplierSetEditText(nil, 3, Index, '1');
      end
      else
      begin
        frmModflow.dgMultiplierSelectCell(nil, 2, Index, Dummy);
        frmModflow.dgMultiplier.Cells[2, Index] := UseFunction;
        frmModflow.dgMultiplierSetEditText(nil, 2, Index, UseFunction);
        frmModflow.dgMultiplierSelectCell(nil, 3, Index, Dummy);
        frmModflow.dgMultiplier.Cells[3, Index] := NewFunction;
        frmModflow.dgMultiplierSetEditText(nil, 3, Index, NewFunction);
      end;
    end;
  end;
end;

procedure TfrmModflowImport.ReadParameters;
var
  LPF_ParameterTypes: TStringList;
  ParameterIndex: integer;
  IPSUM: longint;
  ParameterName, ParameterType, DisplayedType, DisplayedValue: string;
  Value: single;
  NewCount: integer;
  Dummy: boolean;
  I, ISTART, ISTOP: longint;
  ClusterCount: integer;
  InstanceIndex: integer;
  ClusterIndex, ValueIndex, IVALUE, ZoneCount, ZI, NUMINST, IIndex: longint;
  DataGrid: TDataGrid;
  StringGrid: TStringGrid;
  RowIndex, ZoneIndex, ClusterRowIndex: integer;
  ParameterGrid: TDataGrid;
  InstanceGrids: TRBWStringGrid3d;
  adeParamCount: TArgusDataEntry;
  ClusterGrids: TRBWDataGrid3d;
  ClusterStart, ClusterEnd: integer;
  ClusterGridIndex: integer;
  procedure AssignClusters;
  var
    ClusterLoopIndex, ZoneIndex: integer;
    IVALUE: longint;
  begin
    if ClusterCount > 0 then
    begin
      Assert(ClusterGridIndex <= ClusterEnd);
      DataGrid := ClusterGrids.Grids[ClusterGridIndex];
      ClusterRowIndex := 0;
      for ClusterLoopIndex := 0 to ClusterCount - 1 do
      begin
        Inc(ClusterRowIndex);
        Inc(ClusterIndex);
        Assert(ClusterIndex <= ISTOP);

        ValueIndex := 1;
        GetIPCLST(ValueIndex, ClusterIndex, IVALUE);
        DisplayedValue := IntToStr(IVALUE);
        if Assigned(DataGrid.OnSelectCell) then
        begin
          DataGrid.OnSelectCell(DataGrid, 0, ClusterRowIndex,
            Dummy);
        end;
        DataGrid.Cells[0, ClusterRowIndex] := DisplayedValue;
        if Assigned(DataGrid.OnSetEditText) then
        begin
          DataGrid.OnSetEditText(DataGrid, 0, ClusterRowIndex,
            DisplayedValue);
        end;

        ValueIndex := 2;
        GetIPCLST(ValueIndex, ClusterIndex, IVALUE);
        DisplayedValue := DataGrid.Columns[1].Picklist[IVALUE];
        if Assigned(DataGrid.OnSelectCell) then
        begin
          DataGrid.OnSelectCell(DataGrid, 1, ClusterRowIndex,
            Dummy);
        end;
        DataGrid.Cells[1, ClusterRowIndex] := DisplayedValue;
        if Assigned(DataGrid.OnSetEditText) then
        begin
          DataGrid.OnSetEditText(DataGrid, 1, ClusterRowIndex,
            DisplayedValue);
        end;

        ValueIndex := 3;
        GetIPCLST(ValueIndex, ClusterIndex, IVALUE);
        DisplayedValue := DataGrid.Columns[2].Picklist[IVALUE];
        if Assigned(DataGrid.OnSelectCell) then
        begin
          DataGrid.OnSelectCell(DataGrid, 2, ClusterRowIndex,
            Dummy);
        end;
        DataGrid.Cells[2, ClusterRowIndex] := DisplayedValue;
        if Assigned(DataGrid.OnSetEditText) then
        begin
          DataGrid.OnSetEditText(DataGrid, 2, ClusterRowIndex,
            DisplayedValue);
        end;

        ValueIndex := 4;
        GetIPCLST(ValueIndex, ClusterIndex, ZoneCount);
        for ZoneIndex := 5 to ZoneCount do
        begin
          ZI := ZoneIndex;
          GetIPCLST(ZI, ClusterIndex, IVALUE);
          DisplayedValue := IntToStr(IVALUE);
          if Assigned(DataGrid.OnSelectCell) then
          begin
            DataGrid.OnSelectCell(DataGrid, ZoneIndex - 2, ClusterRowIndex,
              Dummy);
          end;
          DataGrid.Cells[ZoneIndex - 2, ClusterRowIndex] := DisplayedValue;
          if Assigned(DataGrid.OnSetEditText) then
          begin
            DataGrid.OnSetEditText(DataGrid, ZoneIndex - 2, ClusterRowIndex,
              DisplayedValue);
          end;
        end;
      end;
    end;
  end;
begin
  LPF_ParameterTypes := TStringList.Create;
  try
    LPF_ParameterTypes.Add('HK');
    LPF_ParameterTypes.Add('VK');
    LPF_ParameterTypes.Add('VANI');
    LPF_ParameterTypes.Add('SS');
    LPF_ParameterTypes.Add('SY');
    LPF_ParameterTypes.Add('VKCB');
    LPF_ParameterTypes.Add('HANI');
    GetIPSUM(IPSUM);
    for ParameterIndex := 1 to IPSUM do
    begin
      I := ParameterIndex;
      ParameterName := PARNAM(ParameterIndex);
      ParameterType := PARTYP(ParameterIndex);
      ParameterValue(I, Value);
      DisplayedValue := SingleToStr(Value);

      if (frmModflow.rgFlowPackage.ItemIndex = 1)
        and (LPF_ParameterTypes.IndexOf(ParameterType) >= 0) then
      begin
        NewCount := StrToInt(frmModflow.adeLPFParamCount.Text) + 1;
        frmModflow.adeLPFParamCountEnter(nil);
        frmModflow.adeLPFParamCount.Text := IntToStr(NewCount);
        frmModflow.adeLPFParamCountExit(nil);

        frmModflow.dgParametersSelectCell(frmModflow.dgLPFParameters,
          Ord(lppName), NewCount, Dummy);
        frmModflow.dgLPFParameters.Cells[Ord(lppName), NewCount] :=
          ParameterName;
        frmModflow.dgParametersSetEditText(frmModflow.dgLPFParameters,
          Ord(lppName), NewCount, ParameterName);

        DisplayedType := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
          PickList[LPF_ParameterTypes.IndexOf(ParameterType)];

        frmModflow.dgParametersSelectCell(frmModflow.dgLPFParameters,
          Ord(lppType), NewCount, Dummy);
        frmModflow.dgLPFParameters.Cells[Ord(lppType), NewCount] :=
          DisplayedType;
        frmModflow.dgParametersSetEditText(frmModflow.dgLPFParameters,
          Ord(lppType), NewCount, DisplayedType);

        frmModflow.dgParametersSelectCell(frmModflow.dgLPFParameters,
          Ord(lppInitialValue), NewCount, Dummy);
        frmModflow.dgLPFParameters.Cells[Ord(lppInitialValue), NewCount] :=
          DisplayedValue;
        frmModflow.dgParametersSetEditText(frmModflow.dgLPFParameters,
          Ord(lppInitialValue), NewCount, DisplayedValue);

        GetClusterRange(I, ISTART, ISTOP);
        ClusterCount := ISTOP - ISTART + 1;
        DisplayedValue := IntToStr(ClusterCount);

        frmModflow.dgParametersSelectCell(frmModflow.dgLPFParameters,
          Ord(lppClusterCount), NewCount, Dummy);
        frmModflow.dgLPFParameters.Cells[Ord(lppClusterCount), NewCount] :=
          DisplayedValue;
        frmModflow.dgParametersSetEditText(frmModflow.dgLPFParameters,
          Ord(lppClusterCount), NewCount, DisplayedValue);

        if ClusterCount > 0 then
        begin
          DataGrid := frmModflow.dg3dLPFParameterClusters.Grids[NewCount - 1];
          RowIndex := 0;
          for InstanceIndex := ISTART to ISTOP do
          begin
            Inc(RowIndex);
            ClusterIndex := InstanceIndex;

            ValueIndex := 1;
            GetIPCLST(ValueIndex, ClusterIndex, IVALUE);
            IVALUE := frmModflow.ModflowLayerToUnit(IVALUE);
            if ParameterType = 'VKCB' then
            begin
              Inc(IVALUE);
            end;
            DisplayedValue := IntToStr(IVALUE);
            frmModflow.dg3dLPFParameterClustersSelectCell(DataGrid, 0, RowIndex,
              Dummy);
            DataGrid.Cells[0, RowIndex] := DisplayedValue;
            frmModflow.dg3dLPFParameterClustersSetEditText(DataGrid, 0,
              RowIndex,
              DisplayedValue);

            ValueIndex := 2;
            GetIPCLST(ValueIndex, ClusterIndex, IVALUE);
            DisplayedValue := DataGrid.Columns[1].Picklist[IVALUE];
            frmModflow.dg3dLPFParameterClustersSelectCell(DataGrid, 1, RowIndex,
              Dummy);
            DataGrid.Cells[1, RowIndex] := DisplayedValue;
            frmModflow.dg3dLPFParameterClustersSetEditText(DataGrid, 1,
              RowIndex,
              DisplayedValue);

            ValueIndex := 3;
            GetIPCLST(ValueIndex, ClusterIndex, IVALUE);
            DisplayedValue := DataGrid.Columns[2].Picklist[IVALUE];
            frmModflow.dg3dLPFParameterClustersSelectCell(DataGrid, 2, RowIndex,
              Dummy);
            DataGrid.Cells[2, RowIndex] := DisplayedValue;
            frmModflow.dg3dLPFParameterClustersSetEditText(DataGrid, 2,
              RowIndex,
              DisplayedValue);

            ValueIndex := 4;
            GetIPCLST(ValueIndex, ClusterIndex, ZoneCount);
            for ZoneIndex := 5 to ZoneCount do
            begin
              ZI := ZoneIndex;
              GetIPCLST(ZI, ClusterIndex, IVALUE);
              DisplayedValue := IntToStr(IVALUE);
              frmModflow.dg3dLPFParameterClustersSelectCell(DataGrid,
                ZoneIndex - 2, RowIndex, Dummy);
              DataGrid.Cells[ZoneIndex - 2, RowIndex] := DisplayedValue;
              frmModflow.dg3dLPFParameterClustersSetEditText(DataGrid,
                ZoneIndex - 2, RowIndex, DisplayedValue);
            end;
          end;
        end;
      end
      else if (ParameterType = 'RIV') or (ParameterType = 'Q')
        or (ParameterType = 'DRN') or (ParameterType = 'GHB')
        or (ParameterType = 'CHD') then
      begin
        ParameterGrid := nil;
        InstanceGrids := nil;
        adeParamCount := nil;
        if ParameterType = 'RIV' then
        begin
          ParameterGrid := frmModflow.dgRIVParametersN;
          InstanceGrids := frmModflow.sg3dRIVParamInstances;
          adeParamCount := frmModflow.adeRIVParamCount;
        end
        else if ParameterType = 'Q' then
        begin
          ParameterGrid := frmModflow.dgWELParametersN;
          InstanceGrids := frmModflow.sg3dWelParamInstances;
          adeParamCount := frmModflow.adeWELParamCount;
        end
        else if ParameterType = 'DRN' then
        begin
          ParameterGrid := frmModflow.dgDRNParametersN;
          InstanceGrids := frmModflow.sg3dDRNParamInstances;
          adeParamCount := frmModflow.adeDRNParamCount;
        end
        else if ParameterType = 'GHB' then
        begin
          ParameterGrid := frmModflow.dgGHBParametersN;
          InstanceGrids := frmModflow.sg3dGHBParamInstances;
          adeParamCount := frmModflow.adeGHBParamCount;
        end
        else if ParameterType = 'CHD' then
        begin
          ParameterGrid := frmModflow.dgCHDParameters;
          InstanceGrids := frmModflow.sg3dCHDParamInstances;
          adeParamCount := frmModflow.adeCHDParamCount;
        end;

        NewCount := StrToInt(adeParamCount.Text) + 1;
        if Assigned(adeParamCount.OnEnter) then
        begin
          adeParamCount.OnEnter(adeParamCount);
        end;
        adeParamCount.Text := IntToStr(NewCount);
        if Assigned(adeParamCount.OnExit) then
        begin
          adeParamCount.OnExit(nil);
        end;

        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, 0, NewCount, Dummy);
        end;
        ParameterGrid.Cells[0, NewCount] := ParameterName;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, 0, NewCount,
            ParameterName);
        end;

        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, 2, NewCount, Dummy);
        end;
        ParameterGrid.Cells[2, NewCount] := DisplayedValue;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, 2, NewCount,
            DisplayedValue);
        end;

        StringGrid := InstanceGrids.Grids[NewCount - 1];
        GetInstanceCount(I, NUMINST);
        DisplayedValue := IntToStr(NUMINST);
        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, 3, NewCount, Dummy);
        end;
        ParameterGrid.Cells[3, NewCount] := DisplayedValue;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, 3, NewCount,
            DisplayedValue);
        end;

        GetInstanceStart(I, IVALUE);
        RowIndex := 0;
        for InstanceIndex := 0 to NUMINST - 1 do
        begin
          IIndex := IVALUE + InstanceIndex;
          Inc(RowIndex);
          DisplayedValue := INAME(IIndex);
          if Assigned(InstanceGrids.OnSelectCell) then
          begin
            StringGrid.OnSelectCell(StringGrid, 0, RowIndex, Dummy);
          end;
          StringGrid.Cells[0, RowIndex] := DisplayedValue;
          if Assigned(InstanceGrids.OnSetEditText) then
          begin
            StringGrid.OnSetEditText(StringGrid, 0, RowIndex, DisplayedValue);
          end;
        end;
      end
      else if (ParameterType = 'RCH') or (ParameterType = 'EVT') or (ParameterType = 'ETS') then
      begin
        ParameterGrid := nil;
        InstanceGrids := nil;
        adeParamCount := nil;
        ClusterGrids := nil;
        if ParameterType = 'RCH' then
        begin
          ParameterGrid := frmModflow.dgRCHParametersN;
          InstanceGrids := frmModflow.sg3dRCHParamInstances;
          adeParamCount := frmModflow.adeRCHParamCount;
          ClusterGrids := frmModflow.dg3dRCHParameterClusters;
        end
        else if ParameterType = 'EVT' then
        begin
          ParameterGrid := frmModflow.dgEVTParametersN;
          InstanceGrids := frmModflow.sg3dEVTParamInstances;
          adeParamCount := frmModflow.adeEVTParamCount;
          ClusterGrids := frmModflow.dg3dEVTParameterClusters;
        end
        else if ParameterType = 'ETS' then
        begin
          ParameterGrid := frmModflow.dgETSParametersN;
          InstanceGrids := frmModflow.sg3dETSParamInstances;
          adeParamCount := frmModflow.adeETSParamCount;
          ClusterGrids := frmModflow.dg3dETSParameterClusters;
        end;

        ClusterStart := ClusterGrids.PageCount;

        NewCount := StrToInt(adeParamCount.Text) + 1;
        if Assigned(adeParamCount.OnEnter) then
        begin
          adeParamCount.OnEnter(adeParamCount);
        end;
        adeParamCount.Text := IntToStr(NewCount);
        if Assigned(adeParamCount.OnExit) then
        begin
          adeParamCount.OnExit(nil);
        end;

        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, Ord(lppName),
            NewCount, Dummy);
        end;
        ParameterGrid.Cells[Ord(lppName), NewCount] := ParameterName;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, Ord(lppName),
            NewCount, ParameterName);
        end;

        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, Ord(lppInitialValue),
            NewCount, Dummy);
        end;
        ParameterGrid.Cells[Ord(lppInitialValue), NewCount] := DisplayedValue;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, Ord(lppInitialValue),
            NewCount, DisplayedValue);
        end;

        GetClusterRange(I, ISTART, ISTOP);
        ClusterCount := ISTOP - ISTART + 1;
        GetInstanceCount(I, NUMINST);
        if NUMINST > 0 then
        begin
          ClusterCount := ClusterCount div NUMINST;
        end;
        DisplayedValue := IntToStr(ClusterCount);

        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, Ord(lppClusterCount),
            NewCount, Dummy);
        end;
        ParameterGrid.Cells[Ord(lppClusterCount), NewCount] := DisplayedValue;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, Ord(lppClusterCount),
            NewCount, DisplayedValue);
        end;

        DisplayedValue := IntToStr(NUMINST);
        if Assigned(ParameterGrid.OnSelectCell) then
        begin
          ParameterGrid.OnSelectCell(ParameterGrid, Ord(lppInstances),
            NewCount, Dummy);
        end;
        ParameterGrid.Cells[Ord(lppInstances), NewCount] := DisplayedValue;
        if Assigned(ParameterGrid.OnSetEditText) then
        begin
          ParameterGrid.OnSetEditText(ParameterGrid, Ord(lppInstances),
            NewCount, DisplayedValue);
        end;

        ClusterEnd := ClusterGrids.PageCount - 1;

        ClusterGridIndex := ClusterStart - 1;
        GetInstanceStart(I, IVALUE);
        RowIndex := 0;
        ClusterIndex := ISTART - 1;

        StringGrid := InstanceGrids.Grids[NewCount - 1];

        for InstanceIndex := 0 to NUMINST - 1 do
        begin
          Inc(ClusterGridIndex);
          IIndex := IVALUE + InstanceIndex;
          Inc(RowIndex);
          DisplayedValue := INAME(IIndex);
          if Assigned(InstanceGrids.OnSelectCell) then
          begin
            StringGrid.OnSelectCell(StringGrid, 0, RowIndex, Dummy);
          end;
          StringGrid.Cells[0, RowIndex] := DisplayedValue;
          if Assigned(InstanceGrids.OnSetEditText) then
          begin
            StringGrid.OnSetEditText(StringGrid, 0, RowIndex, DisplayedValue);
          end;

          AssignClusters;
        end;

        if NUMINST <= 0 then
        begin
          Inc(ClusterGridIndex);
          AssignClusters;
        end;
      end;
    end;
  finally
    LPF_ParameterTypes.Free;
  end;
end;

procedure TfrmModflowImport.CreateMf2kGridStructure;
var
  ColWidths: TRealList;
  RowWidths: TRealList;
  ColIndex, RowIndex: integer;
  AWidth: double;
begin
  MaxWidth := 0;
  ColWidths := TRealList.Create;
  RowWidths := TRealList.Create;
  try
    if ColWidths.Capacity < MF2K_Importer.NCOL then
    begin
      ColWidths.Capacity := MF2K_Importer.NCOL;
    end;
    if RowWidths.Capacity < MF2K_Importer.NROW then
    begin
      RowWidths.Capacity := MF2K_Importer.NROW;
    end;
    for ColIndex := 0 to MF2K_Importer.NCOL - 1 do
    begin
      AWidth := GetDELR(ColIndex);
      ColWidths.Add(AWidth);
      if AWidth > MaxWidth then
      begin
        MaxWidth := AWidth;
      end;
    end;
    for RowIndex := 0 to MF2K_Importer.NROW - 1 do
    begin
      AWidth := GetDELC(RowIndex);
      RowWidths.Add(AWidth);
      if AWidth > MaxWidth then
      begin
        MaxWidth := AWidth;
      end;
    end;

    AGrid.Free;
    AGrid := T2DBlockCenteredGrid.Create(ColWidths, RowWidths,
      InternationalStrToFloat(adeOrX.Text),
        InternationalStrToFloat(adeOrY.Text),
      InternationalStrToFloat(adeGridAngle.Text) * Pi / 180,
      cbRowsPositive.Checked, cbColumnsPositive.Checked, self);
  finally
    ColWidths.Free;
    RowWidths.Free;
  end;
end;

procedure TfrmModflowImport.ChangeHOB_Expressions;
var
  LayerName: string;
  Layer: TLayerOptions;
  LayerHandle: ANE_PTR;
  Project : TProjectOptions;
  ParamIndex: integer;
  ParamName: string;
  ParameterIndex: ANE_INT32;
  Param: TParameterOptions;
begin
  LayerName := ModflowTypes.GetMFHeadObservationsLayerType.ANE_LayerName;

  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(CurrentModelHandle,LayerName);
  finally
    Project.Free;
  end;

  if LayerHandle <> nil then
  begin
    Layer := TLayerOptions.Create(LayerHandle);
    try
      ParamIndex := 1;
      ParamName := ModflowTypes.GetMFIsObservationParamType.WriteParamName +
        IntToStr(ParamIndex);
      ParameterIndex := Layer.GetParameterIndex(CurrentModelHandle, ParamName);
      while ParameterIndex >= 0 do
      begin
        Param := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          Param.Expr[CurrentModelHandle] := '0'
        finally
          Param.Free;
        end;
        Inc(ParamIndex);
        ParamName := ModflowTypes.GetMFIsObservationParamType.WriteParamName +
          IntToStr(ParamIndex);
        ParameterIndex := Layer.GetParameterIndex(CurrentModelHandle, ParamName);
      end;
    finally
      Layer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TfrmModflowImport.ReadSteadyMF2K;
begin
  frmModflow.rbMODFLOW2000.Checked := True;
  MF2K_Importer.ReadSteady;

  NCOL := MF2K_Importer.NCOL;
  NROW := MF2K_Importer.NROW;
  NLAY := MF2K_Importer.NLAY;
  NPER := MF2K_Importer.NPER;

  AssignMF2K_Packages;
  SetUpGeoUnits;
  SetUpHufUnits;
  SetUpMiscOptions;
  SetUpStressPeriods;
  SetZoneNames;
  SetMultiplierNames;
  ReadParameters;
  frmModflow.btnOKClick(frmModflow.btnOK);
  frmModflow.MFLayerStructure.OK(CurrentModelHandle);
  ANE_ProcessEvents(CurrentModelHandle);
  ChangeHOB_Expressions;
  ANE_ProcessEvents(CurrentModelHandle);
  CreateMf2kGridStructure;
end;

procedure TfrmModflowImport.AssignEvapArrays(const StressPeriodIndex: integer);
var
  ColIndex, RowIndex: integer;
  ParameterUsed: boolean;
begin
  if (MF2K_Importer.IUNIT[4] <> 0) then
  begin
    ParameterUsed := not (StrToInt(frmModflow.adeEVTParamCount.Text) = 0);
    for ColIndex := 0 to MF2K_Importer.NCOL - 1 do
    begin
      for RowIndex := 0 to MF2K_Importer.NROW - 1 do
      begin
        AGrid.EvapSurface[ColIndex, RowIndex, StressPeriodIndex]
          := GetSURF(ColIndex, RowIndex);
        if not ParameterUsed then
        begin
          AGrid.EvapRate[ColIndex, RowIndex, StressPeriodIndex]
            := GetEVTR(ColIndex, RowIndex);
        end;
        AGrid.EvapExtDepth[ColIndex, RowIndex, StressPeriodIndex]
          := GetEXDP(ColIndex, RowIndex);
        if MF2K_Importer.NEVTOP = 2 then
        begin
          AGrid.EvapLayer[ColIndex, RowIndex, StressPeriodIndex]
            := GetIEVT(ColIndex, RowIndex);
        end;
      end;
    end;
  end;
end;

procedure TfrmModflowImport.AssignRechargeArrays(const StressPeriodIndex:
  integer);
var
  ColIndex, RowIndex: integer;
  ParameterUsed: boolean;
begin
  if (MF2K_Importer.IUNIT[7] <> 0) then
  begin
    ParameterUsed := not (StrToInt(frmModflow.adeRCHParamCount.Text) = 0);
    for ColIndex := 0 to MF2K_Importer.NCOL - 1 do
    begin
      for RowIndex := 0 to MF2K_Importer.NROW - 1 do
      begin
        if not ParameterUsed then
        begin
          AGrid.RechRate[ColIndex, RowIndex, StressPeriodIndex]
            := GetRECH(ColIndex, RowIndex);
        end;
        if MF2K_Importer.NRCHOP = 2 then
        begin
          AGrid.RechLayer[ColIndex, RowIndex, StressPeriodIndex]
            := GetIRCH(ColIndex, RowIndex);
        end;
      end;
    end;
  end;
end;

procedure TfrmModflowImport.AssignETS_Arrays(const StressPeriodIndex:
  integer);
var
  ColIndex, RowIndex, SegIndex: integer;
  ParameterUsed: boolean;
begin
  if (MF2K_Importer.IUNIT[38] <> 0) then
  begin
    ParameterUsed := not (StrToInt(frmModflow.adeETSParamCount.Text) = 0);
    if StressPeriodIndex = 0 then
    begin
      for ColIndex := 0 to MF2K_Importer.NCOL - 1 do
      begin
        for RowIndex := 0 to MF2K_Importer.NROW - 1 do
        begin
          AGrid.ETS_ExtinctionDepth[ColIndex, RowIndex]
            := GetETSX(ColIndex, RowIndex);
          AGrid.ETS_Surface[ColIndex, RowIndex]
            := GetETSS(ColIndex, RowIndex);
          if MF2K_Importer.NETSOP = 2 then
          begin
            AGrid.ETS_Layer[ColIndex, RowIndex]
              := GetIETS(ColIndex, RowIndex);
          end;
          for SegIndex := 1 to MF2K_Importer.NETSEG -1 do
          begin
            AGrid.ETS_IntermediateDepth[ColIndex, RowIndex, SegIndex-1] :=
              AGrid.ETS_ExtinctionDepth[ColIndex, RowIndex]
              * GetPXDP(ColIndex, RowIndex, SegIndex);

            AGrid.ETS_IntermediateRate[ColIndex, RowIndex, SegIndex-1]
              := GetPETM(ColIndex, RowIndex, SegIndex);
          end;

        end;
      end;

    end;

    for ColIndex := 0 to MF2K_Importer.NCOL - 1 do
    begin
      for RowIndex := 0 to MF2K_Importer.NROW - 1 do
      begin
        if not ParameterUsed then
        begin
          AGrid.ETS_MaxRate[ColIndex, RowIndex, StressPeriodIndex]
            := GetETSR(ColIndex, RowIndex);
        end;
      end;
    end;
  end;
end;

procedure TfrmModflowImport.SetParametersInactive(
  const StressPeriodIndex: longint);
var
  ColIndex: integer;
  RowIndex: integer;
  NoString: string;
  GridList: TList;
  GridIndex: integer;
  Grid: TDataGrid;
begin
  GridList := TList.Create;
  try
    GridList.Add(frmModflow.dgRCHParametersN);
    GridList.Add(frmModflow.dgEVTParametersN);
    GridList.Add(frmModflow.dgETSParametersN);
    for GridIndex := 0 to GridList.Count - 1 do
    begin
      Grid := GridList[GridIndex];
      {if GridIndex < 2 then
      begin  }
        ColIndex := 5 + StressPeriodIndex;
      {end
      else
      begin
        ColIndex := 4 + StressPeriodIndex;
      end; }
      NoString := Grid.Columns[ColIndex].PickList[0];
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        Grid.Cells[ColIndex, RowIndex] := NoString;
      end;
    end;
  finally
    GridList.Free;
  end;
end;

procedure TfrmModflowImport.SetActiveParameters(const StressPeriodIndex,
  CurrentNameCount: longint);
var
  I: longint;
  PARAM, INSTANCE: string;
  ColIndex: integer;
  RowIndex: integer;
  NoString, YesString: string;
  ParamRow: integer;
  Index: integer;
  GridList: TList;
  GridIndex: integer;
  Grid: TDataGrid;
begin
  GridList := TList.Create;
  try
    //GridList.Add(frmModflow.dgRCHParametersN);
    //GridList.Add(frmModflow.dgEVTParametersN);
    GridList.Add(frmModflow.dgRIVParametersN);
    GridList.Add(frmModflow.dgWELParametersN);
    GridList.Add(frmModflow.dgDRNParametersN);
    GridList.Add(frmModflow.dgGHBParametersN);
    GridList.Add(frmModflow.dgCHDParameters);
    for GridIndex := 0 to GridList.Count - 1 do
    begin
      Grid := GridList[GridIndex];
      {if GridIndex < 2 then
      begin
        ColIndex := 5 + StressPeriodIndex;
      end
      else
      begin }
        ColIndex := 4 + StressPeriodIndex;
      //end;
      NoString := Grid.Columns[ColIndex].PickList[0];
      for RowIndex := 1 to Grid.RowCount - 1 do
      begin
        Grid.Cells[ColIndex, RowIndex] := NoString;
      end;
    end;

{    GridList.Insert(0, frmModflow.dgRCHParametersN);
    GridList.Insert(1, frmModflow.dgEVTParametersN);
    GridList.Insert(2, frmModflow.dgETSParametersN);}
    for Index := 1 to CurrentNameCount do
    begin
      I := Index;
      GetCurrentParamNameAndInstance(I, PARAM, INSTANCE);
      for GridIndex := 0 to GridList.Count - 1 do
      begin
        Grid := GridList[GridIndex];
        ParamRow := Grid.Cols[Ord(lppName)].IndexOf(PARAM);
        if ParamRow > 0 then
        begin
          {if GridIndex < 3 then
          begin
            ColIndex := 5 + StressPeriodIndex;
          end
          else
          begin }
            ColIndex := 4 + StressPeriodIndex;
          //end;
          YesString := Grid.Columns[ColIndex].PickList[1];
          if INSTANCE = '' then
          begin
            Grid.Cells[ColIndex, ParamRow] := YesString;
          end
          else
          begin
            Grid.Cells[ColIndex, ParamRow] := INSTANCE;
          end;
          break;
        end;
      end;
    end;
  finally
    GridList.Free;
  end;
end;

procedure TfrmModflowImport.ReadStressPeriod(const StressPeriodIndex: integer);
begin
  // For the first stress period, StressPeriodIndex = 0.
  SetParametersInactive(StressPeriodIndex);
  MF2K_Importer.ReadTransient(StressPeriodIndex);
  AssignEvapArrays(StressPeriodIndex);
  AssignRechargeArrays(StressPeriodIndex);
  AssignETS_Arrays(StressPeriodIndex);
  GetStressPeriodCounts(MF2K_Importer.NNPWEL, MF2K_Importer.NNPDRN,
    MF2K_Importer.NNPRIV, MF2K_Importer.NNPGHB, MF2K_Importer.NNPCHD,
    MF2K_Importer.CurrentNameCount);
  SetActiveParameters(StressPeriodIndex, MF2K_Importer.CurrentNameCount);
  AGrid.MakeMF2K_WellBoundaries(StressPeriodIndex);
  AGrid.MakeMF2KDrainBoundaries(StressPeriodIndex);
  AGrid.MakeMF2K_GHB_Boundaries(StressPeriodIndex);
  AGrid.MakeMF2K_RiverBoundaries(StressPeriodIndex);
  AGrid.MakeMF2K_CHD_Boundaries(StressPeriodIndex);
end;

procedure TfrmModflowImport.SetMf2K_DataItems;
var
  LayerIndex, TimeIndex, LI, HUF_Index, SegmentIndex: integer;
  Layer, IValue: longint;
  ImportLayer: TImportLayer;
  Name: string;
  Width: double;
  temp: double;
  Index: integer;
  ALayer: T_ANE_InfoLayer;
  AParam: T_ANE_Param;
  ALayerList: T_ANE_LayerList;
  ParameterList: T_ANE_ParameterList;
  SomeTransient: boolean;
  DefinedByParameters: boolean;
  ParameterTypeString: string;
  ZoneList: T_ANE_IndexedLayerList;
  MultList: T_ANE_IndexedLayerList;
  ZoneIndex, MultIndex, MI: integer;
  UseMultString: string;
begin
  Width := 0;
  with AGrid do
  begin
    with ColPositions do
    begin
      for Index := 1 to Count - 1 do
      begin
        temp := Abs(Items[Index - 1] - Items[Index]);
        if temp > Width then
        begin
          Width := temp;
        end;
      end;
    end;
    with RowPositions do
    begin
      for Index := 1 to Count - 1 do
      begin
        temp := Abs(Items[Index - 1] - Items[Index]);
        if temp > Width then
        begin
          Width := temp;
        end;
      end;
    end;
  end;

  ImportLayer := TImportLayer.Create;
  ImportLayerList.Add(ImportLayer);
  ImportLayer.LayerIndex := 0;
  ImportLayer.LayerName := ModflowTypes.GetMFDomainOutType.ANE_LayerName;
  ImportLayer.ImportMethod := imDomainOutline;
  ImportLayer.GridDensity := Width;
  ImportLayer.FunctionList.Add(GetActiveCell, False);
  ImportLayer.LinkedLayerList.Add(nil);
  ImportLayer.LinkedParameterList.Add(nil);
  ImportLayer.ExtraExpressionList.Add('');
  ImportLayer.ExtraEndExpressionList.Add('');
  ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);

  MultList := frmModflow.MFLayerStructure.FirstListsOfIndexedLayers.
    Items[1];
  ZoneList := frmModflow.MFLayerStructure.FirstListsOfIndexedLayers.
    Items[2];

  MI := 0;
  UseMultString := frmModflow.dgMultiplier.Columns[2].PickList[0];
  for MultIndex := 1 to frmModflow.dgMultiplier.RowCount - 1 do
  begin
    if frmModflow.dgMultiplier.Cells[2, MultIndex] = UseMultString then
    begin
      Inc(MI);
      ImportLayer := TImportLayer.Create;
      ImportLayerList.Add(ImportLayer);

      ImportLayer.LayerIndex := MultIndex;

      Name := frmModflow.dgMultiplier.Cells[1, MultIndex];
      ImportLayer.LayerName := ' Imported ' + Name + ' Layer';
      ImportLayer.ParameterNames.Add(Name);
      ImportLayer.ImportMethod := imDataLayer;
      ImportLayer.GridDensity := Width;
      ImportLayer.FunctionList.Add(GetRMLT, False);
      ALayer := MultList.Items[MI] as T_ANE_InfoLayer;
      Assert(ALayer <> nil);
      AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
        GetMFMultiplierParamType.ANE_ParamName);
      Assert(AParam <> nil);
      ImportLayer.LinkedLayerList.Add(ALayer);
      ImportLayer.LinkedParameterList.Add(AParam);
      ImportLayer.ExtraExpressionList.Add('');
      ImportLayer.ExtraEndExpressionList.Add('');
      ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
    end;
  end;

  for ZoneIndex := 1 to ZoneList.Count - 1 do
  begin
    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);

    ImportLayer.LayerIndex := ZoneIndex;
    ImportLayer.LayerName := ' Imported ' + frmModflow.sgZoneArrays.Cells[1,
      ZoneIndex] + ' Layer';
    SetLength(ImportLayer.ParameterTypes, 1);
    ImportLayer.ParameterTypes[0] := pvInteger;
    ImportLayer.ParameterNames.Add(frmModflow.sgZoneArrays.Cells[1, ZoneIndex]);
    ImportLayer.ImportMethod := imDataLayer;
    ImportLayer.GridDensity := Width;
    ImportLayer.FunctionList.Add(GetIZONE, False);
    ALayer := ZoneList.Items[ZoneIndex] as T_ANE_InfoLayer;
    Assert(ALayer <> nil);
    AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
      GetMFZoneParamType.ANE_ParamName);
    Assert(AParam <> nil);
    ImportLayer.LinkedLayerList.Add(ALayer);
    ImportLayer.LinkedParameterList.Add(AParam);
    ImportLayer.ExtraExpressionList.Add('Round(');
    ImportLayer.ExtraEndExpressionList.Add(')');
    ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
  end;

  LI := 0;
  for LayerIndex := 1 to NLAY do
  begin
    Inc(LI);

    ALayerList := frmModflow.MFLayerStructure.ListsOfIndexedLayers.
      Items[LI - 1];

    ALayer := ALayerList.GetLayerByName(ModflowTypes.GetInactiveLayerType.
      ANE_LayerName) as T_ANE_InfoLayer;
    Assert(ALayer <> nil);
    AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
      GetMFInactiveParamType.ANE_ParamName);
    Assert(AParam <> nil);
    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);
    ImportLayer.LayerIndex := LayerIndex;
    Name := 'Imported IBOUND Unit' + IntToStr(LI);
    ImportLayer.LayerName := Name;
    ImportLayer.ParameterNames.Add(Name);
    ImportLayer.ImportMethod := imDataLayer;
    ImportLayer.FunctionList.Add(GetIboundSign, False);
    ImportLayer.LinkedLayerList.Add(ALayer);
    ImportLayer.LinkedParameterList.Add(AParam);
    ImportLayer.ExtraExpressionList.Add('Round(');
    ImportLayer.ExtraEndExpressionList.Add(')');
//    ImportLayer.UseFunctionList.Add(IsActiveLayer);

    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);
    ImportLayer.LayerIndex := LayerIndex;
    ImportLayer.LayerName
      := ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
      + IntToStr(LI);
    ImportLayer.ImportMethod := imPointContours;
    ImportLayer.FunctionList.Add(GetSHead, False);
    ImportLayer.LinkedLayerList.Add(nil);
    ImportLayer.LinkedParameterList.Add(nil);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');
    ImportLayer.UseFunctionList.Add(IsPrescribedHeadCell);

    ALayer := ALayerList.GetLayerByName(ModflowTypes.GetInitialHeadLayerType.
      ANE_LayerName) as T_ANE_InfoLayer;
    Assert(ALayer <> nil);
    AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
      GetMFInitialHeadParamType.ANE_ParamName);
    Assert(AParam <> nil);
    ImportLayer := TImportLayer.Create;
    ImportLayerList.Add(ImportLayer);
    ImportLayer.LayerIndex := LayerIndex;
    Name := 'Imported Initial Head Unit' + IntToStr(LI);
    ImportLayer.LayerName := 'Imported MODFLOW Data' + IntToStr(LI);
    ImportLayer.ParameterNames.Add(Name);
    ImportLayer.ImportMethod := imDataLayer;
    ImportLayer.FunctionList.Add(GetSHead, False);
    ImportLayer.LinkedLayerList.Add(ALayer);
    ImportLayer.LinkedParameterList.Add(AParam);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');
    ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);

    ALayer := ALayerList.GetLayerByName(ModflowTypes.GetBottomElevLayerType.
      ANE_LayerName) as T_ANE_InfoLayer;
    Assert(ALayer <> nil);
    AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
      GetMFBottomElevParamType.ANE_ParamName);
    Assert(AParam <> nil);
    Name := 'Imported Bottom Unit' + IntToStr(LI);
    ImportLayer.ParameterNames.Add(Name);
    ImportLayer.FunctionList.Add(GetBOT, False);
    ImportLayer.LinkedLayerList.Add(ALayer);
    ImportLayer.LinkedParameterList.Add(AParam);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');

    ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFTopElevLayerType.
      ANE_LayerName) as T_ANE_InfoLayer;
    Assert(ALayer <> nil);
    AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
      GetMFTopElevParamType.ANE_ParamName);
    Assert(AParam <> nil);
    Name := 'Imported Top Unit' + IntToStr(LI);
    ImportLayer.ParameterNames.Add(Name);
    ImportLayer.FunctionList.Add(GetTOP, False);
    ImportLayer.LinkedLayerList.Add(ALayer);
    ImportLayer.LinkedParameterList.Add(AParam);
    ImportLayer.ExtraExpressionList.Add('');
    ImportLayer.ExtraEndExpressionList.Add('');

    if MF2K_Importer.IUNIT[36] <> 0 then
    begin
      Layer := LayerIndex;
      GetHufLaytype(Layer, IVAlue);
      if IVAlue <> 0 then
      begin
        GetHufLaywet(Layer, IVAlue);
        if IVAlue <> 0 then
        begin
          ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFWettingThreshParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported WetDry Threshhold Unit' + IntToStr(LI);
          ImportLayer.LayerName := Name;
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.ImportMethod := imDataLayer;
          ImportLayer.FunctionList.Add(GetWETDRYThreshhold, False);
          ImportLayer.UseFunctionList.Add(IsCell);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');

          ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFWettingFlagParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported WetDry Flag Unit' + IntToStr(LI);
          ImportLayer.LayerName := Name;
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.ImportMethod := imZones;
          ImportLayer.FunctionList.Add(GetWETDRYFlag, False);
          ImportLayer.UseFunctionList.Add(IsCell);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;
    end;
    if MF2K_Importer.IUNIT[22] <> 0 then
    begin
      // HK
      DefinedByParameters := False;
      ParameterTypeString := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
        PickList[0];
      for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
      begin
        if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
          = ParameterTypeString then
        begin
          DefinedByParameters := True;
          break;
        end;
      end;

      if not DefinedByParameters then
      begin
        ALayer :=
          ALayerList.GetLayerByName(ModflowTypes.GetHydraulicCondLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFKxParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported hydraulic conductivity Unit' + IntToStr(LI);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetHK, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;

      if MF2K_Importer.CHANI[LayerIndex] < 0 then
      begin
        // HANI
        DefinedByParameters := False;
        ParameterTypeString := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
          PickList[6];
        for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
        begin
          if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
            = ParameterTypeString then
          begin
            DefinedByParameters := True;
            break;
          end;
        end;

        if not DefinedByParameters then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFAnistropyLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFAnistropyParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported horizontal anisotropy Unit' + IntToStr(LI);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetHANI, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;

      SomeTransient := False;
      for Index := 0 to MF2K_Importer.NPER - 1 do
      begin
        if MF2K_Importer.ISSFLG[Index] = 0 then
        begin
          SomeTransient := true;
          break;
        end;
      end;

      if SomeTransient then
      begin
        DefinedByParameters := False;
        ParameterTypeString := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
          PickList[3];
        for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
        begin
          if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
            = ParameterTypeString then
          begin
            DefinedByParameters := True;
            break;
          end;
        end;

        if not DefinedByParameters then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFSpecStorageLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFSpecStorageParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported specific storage Unit' + IntToStr(LI);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC1, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;

        if (MF2K_Importer.LAYTYP[LayerIndex - 1] <> 0) then
        begin
          DefinedByParameters := False;
          ParameterTypeString :=
            frmModflow.dgLPFParameters.Columns[Ord(lppType)].
            PickList[4];
          for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
          begin
            if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
              = ParameterTypeString then
            begin
              DefinedByParameters := True;
              break;
            end;
          end;
          if not DefinedByParameters then
          begin
            ALayer :=
              ALayerList.GetLayerByName(ModflowTypes.GetMFSpecYieldLayerType.
              ANE_LayerName) as T_ANE_InfoLayer;
            Assert(ALayer <> nil);
            AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
              GetMFSpecYieldParamType.ANE_ParamName);
            Assert(AParam <> nil);
            Name := 'Imported specific yield Unit' + IntToStr(LI);
            ImportLayer.ParameterNames.Add(Name);
            ImportLayer.FunctionList.Add(GetSC2, False);
            ImportLayer.LinkedLayerList.Add(ALayer);
            ImportLayer.LinkedParameterList.Add(AParam);
            ImportLayer.ExtraExpressionList.Add('');
            ImportLayer.ExtraEndExpressionList.Add('');
          end;
        end;
      end;

      // vka
      DefinedByParameters := False;
      ParameterTypeString := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
        PickList[1];
      for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
      begin
        if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
          = ParameterTypeString then
        begin
          DefinedByParameters := True;
          break;
        end;
      end;
      ParameterTypeString := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
        PickList[2];
      for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
      begin
        if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
          = ParameterTypeString then
        begin
          DefinedByParameters := True;
          break;
        end;
      end;
      if MF2K_Importer.LAYVKA[LayerIndex - 1] = 0 then
      begin
        // vertical hydraulic conductivity
        if not DefinedByParameters then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetHydraulicCondLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFKzParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported vertical hydraulic conductivity Unit' +
            IntToStr(LI);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetVKA, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end
      else
      begin
        // ratio of horizontal to vertical hydraulic conductivity
        if not DefinedByParameters then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetHydraulicCondLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFKzParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported hydraulic conductivity ratio Unit' + IntToStr(LI);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetVKA, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('Kx/');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;

      // wetdry

      if (MF2K_Importer.LAYTYP[LayerIndex - 1] <> 0)
        and (MF2K_Importer.LAYWET[LayerIndex - 1] <> 0) then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFWettingThreshParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := LayerIndex;
        Name := 'Imported WetDry Threshhold Unit' + IntToStr(LI);
        ImportLayer.LayerName := Name;
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.ImportMethod := imDataLayer;
        ImportLayer.FunctionList.Add(GetWETDRYThreshhold, False);
        ImportLayer.UseFunctionList.Add(IsCell);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');

        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFWettingFlagParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := LayerIndex;
        Name := 'Imported WetDry Flag Unit' + IntToStr(LI);
        ImportLayer.LayerName := Name;
        SetLength(ImportLayer.ParameterTypes, 1);
        ImportLayer.ParameterTypes[0] := pvInteger;
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.ImportMethod := imZones;
        ImportLayer.FunctionList.Add(GetWETDRYFlag, False);
        ImportLayer.UseFunctionList.Add(IsCell);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');

      end;

      // vkcb
      if MF2K_Importer.LAYCBD[LayerIndex - 1] <> 0 then
      begin
        Inc(LI);
        ALayerList := frmModflow.MFLayerStructure.ListsOfIndexedLayers.
          Items[LI - 1];

        DefinedByParameters := False;
        ParameterTypeString := frmModflow.dgLPFParameters.Columns[Ord(lppType)].
          PickList[5];
        for Index := 1 to frmModflow.dgLPFParameters.RowCount - 1 do
        begin
          if frmModflow.dgLPFParameters.Cells[Ord(lppType), Index]
            = ParameterTypeString then
          begin
            DefinedByParameters := True;
            break;
          end;
        end;
        if not DefinedByParameters then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetHydraulicCondLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFKzParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported vertyical hydraulic conductivity ratio Unit' +
            IntToStr(LI);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetVKCB, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;

    end;
    if MF2K_Importer.IUNIT[0] <> 0 then
    begin
      // ISS = 0 for transient simulations.
      if MF2K_Importer.ISS = 0 then
      begin
        if (MF2K_Importer.LAYCON[LayerIndex - 1] = 0) or
          (MF2K_Importer.LAYCON[LayerIndex - 1] = 2) or
          (MF2K_Importer.LAYCON[LayerIndex - 1] = 3) then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFConfStorageLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFConfStorageParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported confined Storage Unit' + IntToStr(LayerIndex);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC1, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end
        else if (MF2K_Importer.LAYCON[LayerIndex - 1] = 1) then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFSpecYieldLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFSpecYieldParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported Specific Yield Unit' + IntToStr(LayerIndex);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC1, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
        if (MF2K_Importer.LAYCON[LayerIndex - 1] = 2) or
          (MF2K_Importer.LAYCON[LayerIndex - 1] = 3) then
        begin
          ALayer :=
            ALayerList.GetLayerByName(ModflowTypes.GetMFSpecYieldLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFSpecYieldParamType.ANE_ParamName);
          Assert(AParam <> nil);
          Name := 'Imported Specific Yield Unit' + IntToStr(LayerIndex);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.FunctionList.Add(GetSC2, False);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;

      end;
      if (MF2K_Importer.LAYCON[LayerIndex - 1] = 0) or
        (MF2K_Importer.LAYCON[LayerIndex - 1] = 2) then
      begin
        ALayer :=
          ALayerList.GetLayerByName(ModflowTypes.GetMFTransmisivityLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFTransmisivityParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported Transmissivity Unit' + IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetTrans, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if (MF2K_Importer.LAYCON[LayerIndex - 1] = 1) or
        (MF2K_Importer.LAYCON[LayerIndex - 1] = 3) then
      begin
        ALayer :=
          ALayerList.GetLayerByName(ModflowTypes.GetHydraulicCondLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFKxParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported Horizontal Hydraulic Conductivity Unit' +
          IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetHY, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if LayerIndex < NLAY then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFVcontLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFVcontParamType.ANE_ParamName);
        Assert(AParam <> nil);
        Name := 'Imported VCONT Unit' + IntToStr(LayerIndex);
        ImportLayer.ParameterNames.Add(Name);
        ImportLayer.FunctionList.Add(GetVCONT, False);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
      end;
      if MF2K_Importer.IWDFLG <> 0 then
      begin
        if (MF2K_Importer.LAYCON[LayerIndex - 1] = 1) or
          (MF2K_Importer.LAYCON[LayerIndex - 1] = 3) then
        begin
          ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFWettingThreshParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported WetDry Threshhold Unit' + IntToStr(LayerIndex);
          ImportLayer.LayerName := Name;
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.ImportMethod := imDataLayer;
          ImportLayer.FunctionList.Add(GetWETDRYThreshhold, False);
          ImportLayer.UseFunctionList.Add(IsCell);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');

          ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFWettingLayerType.
            ANE_LayerName) as T_ANE_InfoLayer;
          Assert(ALayer <> nil);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFWettingFlagParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported WetDry Flag Unit' + IntToStr(LayerIndex);
          ImportLayer.LayerName := Name;
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.ImportMethod := imZones;
          ImportLayer.FunctionList.Add(GetWETDRYFlag, False);
          ImportLayer.UseFunctionList.Add(IsCell);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end; // If IWDFLG <>0 then
      if MF2K_Importer.IUNIT[0] <> 0 then
      begin
        if MF2K_Importer.LAYCBD[LayerIndex - 1] <> 0 then
        begin
          Inc(LI);
        end;
      end;

    end;
    ALayerList := frmModflow.MFLayerStructure.UnIndexedLayers;
    if LayerIndex = 1 then
    begin
      if MF2K_Importer.IUNIT[38] <> 0 then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetMFSegmentedETLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := LayerIndex;
        Name := 'Imported Segmented Evapotranspiration';
        ImportLayer.LayerName := Name;
        ImportLayer.ParameterNames.Add('ET Surface');
        ImportLayer.ParameterNames.Add('ET Extinction Depth');
        ImportLayer.ImportMethod := imDataLayer;
        ImportLayer.FunctionList.Add(GetETSS, False);
        ImportLayer.FunctionList.Add(GetETSX, False);

        ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedLayerList.Add(ALayer);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetSegETSurfaceParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetSegETExtDepthParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');

        if StrToInt(frmModflow.adeETSParamCount.Text) = 0 then
        begin
          ImportLayer.TimeFunctionList.Add(GetETSR, False);
          for TimeIndex := 1 to NPER do
          begin
            ImportLayer.ParameterNames.Add('Evapotranspiration Rate' +
              IntToStr(TimeIndex));
            ParameterList := ALayer.IndexedParamList2.Items[TimeIndex - 1];
            AParam := ParameterList.GetParameterByName(ModflowTypes.
              GetSegET_MaxFluxParamType.ANE_ParamName);
            Assert(AParam <> nil);
            ImportLayer.LinkedLayerList.Add(ALayer);
            ImportLayer.LinkedParameterList.Add(AParam);
            ImportLayer.ExtraExpressionList.Add('');
            ImportLayer.ExtraEndExpressionList.Add('');
          end;
        end;

        for SegmentIndex := 1 to StrToInt(frmModflow.adeIntElev.Text) do
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := SegmentIndex;
          Name := 'Imported Segmented ET Rates' + IntToStr(SegmentIndex);
          ImportLayer.LayerName := Name;

          ImportLayer.ParameterNames.Add('Depth' + IntToStr(SegmentIndex));
          ImportLayer.ParameterNames.Add('Proportion' + IntToStr(SegmentIndex));
          ImportLayer.ImportMethod := imDataLayer;
          ImportLayer.FunctionList.Add(GetETS_IntermediateDepth, False);
          ImportLayer.FunctionList.Add(GetETS_IntermediateRate, False);

          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          AParam := ALayer.IndexedParamList0.Items[SegmentIndex-1].
            GetParameterByName(ModflowTypes.
            GetSegET_IntermediateDepthParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
          AParam := ALayer.IndexedParamList0.Items[SegmentIndex-1].
            GetParameterByName(ModflowTypes.
            GetSegET_IntermediateProportionParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;


        if MF2K_Importer.NETSOP = 2 then
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported Segmented ET Layer';
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.LayerName := Name;
          ImportLayer.ImportMethod := imZones;
          ImportLayer.FunctionList.Add(GetIETS, False);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFModflowLayerParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;
      if MF2K_Importer.IUNIT[4] <> 0 then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetETLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := LayerIndex;
        Name := 'Imported Evapotranspiration';
        ImportLayer.LayerName := Name;
        ImportLayer.ParameterNames.Add('ET Surface');
        ImportLayer.ParameterNames.Add('ET Extinction Depth');
        ImportLayer.ImportMethod := imDataLayer;
        ImportLayer.FunctionList.Add(GetSURF, False);
        ImportLayer.FunctionList.Add(GetEXDP, False);
        if StrToInt(frmModflow.adeEVTParamCount.Text) = 0 then
        begin
          ImportLayer.TimeFunctionList.Add(GetEVTR, False);
        end;

        ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
        ImportLayer.LinkedLayerList.Add(ALayer);
        ImportLayer.LinkedLayerList.Add(ALayer);

        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFETSurfaceParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFETExtDepthParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
        if StrToInt(frmModflow.adeEVTParamCount.Text) = 0 then
        begin
          for TimeIndex := 1 to NPER do
          begin
            ImportLayer.ParameterNames.Add('Evapotranspiration Rate' +
              IntToStr(TimeIndex));
            ParameterList := ALayer.IndexedParamList2.Items[TimeIndex - 1];
            AParam := ParameterList.GetParameterByName(ModflowTypes.
              GetMFETExtFluxParamType.ANE_ParamName);
            Assert(AParam <> nil);
            ImportLayer.LinkedLayerList.Add(ALayer);
            ImportLayer.LinkedParameterList.Add(AParam);
            ImportLayer.ExtraExpressionList.Add('');
            ImportLayer.ExtraEndExpressionList.Add('');
          end;
        end;

        if MF2K_Importer.NEVTOP = 2 then
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported ET Layer';
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.LayerName := Name;
          ImportLayer.ImportMethod := imZones;
          ImportLayer.FunctionList.Add(GetIEVT, False);
          ImportLayer.ParameterNames.Add(Name);
          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFModflowLayerParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;

      if MF2K_Importer.IUNIT[7] <> 0 then
      begin
        ALayer := ALayerList.GetLayerByName(ModflowTypes.GetRechargeLayerType.
          ANE_LayerName) as T_ANE_InfoLayer;
        Assert(ALayer <> nil);
        if StrToInt(frmModflow.adeRCHParamCount.Text) = 0 then
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported Recharge';
          ImportLayer.LayerName := Name;
          ImportLayer.ImportMethod := imDataLayer;
          ImportLayer.TimeFunctionList.Add(GetRECH, False);
          for TimeIndex := 1 to NPER do
          begin
            ImportLayer.ParameterNames.Add('Recharge Rate' +
              IntToStr(TimeIndex));
            ParameterList := ALayer.IndexedParamList2.Items[TimeIndex - 1];
            AParam := ParameterList.GetParameterByName(ModflowTypes.
              GetMFRechStressParamType.ANE_ParamName);
            Assert(AParam <> nil);
            ImportLayer.LinkedLayerList.Add(ALayer);
            ImportLayer.LinkedParameterList.Add(AParam);
            ImportLayer.ExtraExpressionList.Add('');
            ImportLayer.ExtraEndExpressionList.Add('');
          end;
          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
        end;

        if MF2K_Importer.NRCHOP = 2 then
        begin
          ImportLayer := TImportLayer.Create;
          ImportLayerList.Add(ImportLayer);
          ImportLayer.LayerIndex := LayerIndex;
          Name := 'Imported Recharge Layer';
          ImportLayer.LayerName := Name;
          ImportLayer.ImportMethod := imZones;
          ImportLayer.ParameterNames.Add(Name);
          SetLength(ImportLayer.ParameterTypes, 1);
          ImportLayer.ParameterTypes[0] := pvInteger;
          ImportLayer.FunctionList.Add(GetIRCH, False);
          ImportLayer.UseFunctionList.Add(IsActiveCellOnAnyLayer);
          ImportLayer.LinkedLayerList.Add(ALayer);
          AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
            GetMFModflowLayerParamType.ANE_ParamName);
          Assert(AParam <> nil);
          ImportLayer.LinkedParameterList.Add(AParam);
          ImportLayer.ExtraExpressionList.Add('');
          ImportLayer.ExtraEndExpressionList.Add('');
        end;
      end;
    end;
  end;
  if MF2K_Importer.IUNIT[36] > 0  then
  begin
    for HUF_Index := 1 to MF2K_Importer.NHUF do
    begin
        ALayer := frmModflow.MFLayerStructure.UnIndexedLayers2.
          Items[HUF_Index] as T_ANE_InfoLayer;
        Assert(ALayer is ModflowTypes.GetMFHUF_LayerType);

        ImportLayer := TImportLayer.Create;
        ImportLayerList.Add(ImportLayer);
        ImportLayer.LayerIndex := HUF_Index;
        Name := 'Imported HUF Layer' + IntToStr(HUF_Index);
        ImportLayer.LayerName := Name;
        ImportLayer.ImportMethod := imDataLayer;
        ImportLayer.ParameterNames.Add('Top');
        ImportLayer.ParameterNames.Add('Thickness');
        SetLength(ImportLayer.ParameterTypes, 2);
        ImportLayer.ParameterTypes[0] := pvReal;
        ImportLayer.ParameterTypes[1] := pvReal;
        ImportLayer.FunctionList.Add(GetHUFTOP, False);
        ImportLayer.FunctionList.Add(GetHUFThickness, False);
        ImportLayer.UseFunctionList.Add(IsCell);

        ImportLayer.LinkedLayerList.Add(ALayer);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFHUFTopParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');

        ImportLayer.LinkedLayerList.Add(ALayer);
        AParam := ALayer.ParamList.GetParameterByName(ModflowTypes.
          GetMFHUFThicknessParamType.ANE_ParamName);
        Assert(AParam <> nil);
        ImportLayer.LinkedParameterList.Add(AParam);
        ImportLayer.ExtraExpressionList.Add('');
        ImportLayer.ExtraEndExpressionList.Add('');
    end;
  end;
end;

procedure TfrmModflowImport.SetExpressionsForNonSimulatedLayers;
var
  UnitIndex: integer;
  LayerName: string;
  Layer: TLayerOptions;
  ParameterName: string;
  Parameter: TParameterOptions;
  Expression: string;
begin
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
  begin
    if not frmModflow.Simulated(UnitIndex) then
    begin
      LayerName := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName +
        IntToStr(UnitIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, frmModflow.CurrentModelHandle);
      try
        ParameterName := ModflowTypes.GetMFTopElevParamType.WriteParamName +
          IntToStr(UnitIndex);
        Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
          ParameterName, frmModflow.CurrentModelHandle);
        try
          Expression := ModflowTypes.GetBottomElevLayerType.ANE_LayerName
            + IntToStr(UnitIndex-1) + '.' +
            ModflowTypes.GetMFBottomElevParamType.WriteParamName
            + IntToStr(UnitIndex-1);
          Parameter.Expr[frmModflow.CurrentModelHandle] := Expression;
        finally
          Parameter.Free;
        end;
      finally
        Layer.Free(frmModflow.CurrentModelHandle);
      end;

      LayerName := ModflowTypes.GetBottomElevLayerType.ANE_LayerName +
        IntToStr(UnitIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, frmModflow.CurrentModelHandle);
      try
        ParameterName := ModflowTypes.GetMFBottomElevParamType.WriteParamName +
          IntToStr(UnitIndex);
        Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
          ParameterName, frmModflow.CurrentModelHandle);
        try
          Expression := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName
            + IntToStr(UnitIndex+1) + '.' +
            ModflowTypes.GetMFTopElevParamType.WriteParamName
            + IntToStr(UnitIndex+1);
          Parameter.Expr[frmModflow.CurrentModelHandle] := Expression;
        finally
          Parameter.Free;
        end;
      finally
        Layer.Free(frmModflow.CurrentModelHandle);
      end;
    end;
  end;
end;

procedure TfrmModflowImport.ImportModflow2000;
var
  StressPeriodIndex: integer;
  Index: integer;
  ImportLayer: TImportLayer;
begin
  Hide;
  CreateBatchFile;
  MakeGroupLayer;
  MF2K_Importer := TMF2K_Importer.Create;
  try
    try
      ReadSteadyMF2K;

      MF2K_Importer.InitializeTransient;
      for StressPeriodIndex := 0 to MF2K_Importer.NPER - 1 do
      begin
        CurrentStressPeriod := StressPeriodIndex +1;
        ReadStressPeriod(StressPeriodIndex);
      end;
      ExportGrid;
      MakeGridDensity;

      // SetMf2K_DataItems creates instances of TImportLayer that are used
      // to export spatial data to Argus ONE.
      SetMf2K_DataItems;
      for Index := 0 to ImportLayerList.Count - 1 do
      begin
        ImportLayer := ImportLayerList[Index] as TImportLayer;
        ImportLayer.ExportData(AGrid.Perturbation);
      end;
      MakeMF2KBoundaries;
      ExportBoundaries;
      ExportHeadObservations;
      SetExpressionsForNonSimulatedLayers;
    finally
      MF2K_Importer.Close;
    end;
  finally
    MF2K_Importer.Free;
  end;

  ShowInstructions;
end;

function TtypedEditContours.GetLayer: integer;
var
  LayerIndex: integer;
  LI: integer;
begin
  LI := 0;
  for LayerIndex := 1 to frmModflow.UnitCount do
  begin
    if frmModflow.Simulated(LayerIndex) then
    begin
      Inc(LI);
      if LI = FLayer then
      begin
        result := LayerIndex;
        Exit;
      end;
    end;
  end;
  result := frmModflow.UnitCount + 1;
//  Assert(False);
end;

procedure TfrmModflowImport.MakeMF2K_GHB_Boundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TMF2K_GHBBoundary;
  StressPeriod: integer;
  HeadRoot, OnOffRoot, ConductanceName: string;
  ConductanceSt: string;
  Conductance: single;
  StressPeriodIndex: integer;
  OnOffName, HeadName: string;
  Head: string;
  PName: string;
begin
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    HeadRoot := ModflowTypes.GetMFGHBHeadParamType.ANE_ParamName;
    OnOffRoot := ModflowTypes.GetMFOnOffParamType.ANE_ParamName;
    ConductanceName := ModflowTypes.GetMFGhbConductanceParamType.ANE_ParamName;
    Conductance := ABoundary.Cond;
    ConductanceSt := InternationalFloatToStr(Conductance);
    PName := ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  end;

  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;
  try
    while BoundaryList.Count > 0 do
    begin

      UsedStressPeriods.Clear;

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      BoundaryContour.AddCopyOfPoint(APoint);
      BoundaryContour.SetAValue(ConductanceName, ConductanceSt);
      for StressPeriodIndex := 1 to NPER do
      begin
        OnOffName := OnOffRoot + IntToStr(StressPeriodIndex);
        BoundaryContour.SetAValue(OnOffName, '0');
      end;

      for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
      begin
        ABoundary := BoundaryList[BoundaryIndex];
        StressPeriod := ABoundary.StressPeriod + 1;
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          UsedStressPeriods.Add(StressPeriod);
          BoundaryList.Delete(BoundaryIndex);
          Head := InternationalFloatToStr(ABoundary.BoundaryHead);
          HeadName := HeadRoot + IntToStr(StressPeriod);
          OnOffName := OnOffRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(HeadName, Head);
          BoundaryContour.SetAValue(OnOffName, '1');
          BoundaryContour.SetAValue(PName, ABoundary.ParameterName);
        end;
      end;
      for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
      begin
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          OnOffName := OnOffRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(OnOffName, '0');
        end;
      end;
      BoundaryContour.SetValue;
    end;

  finally
    UsedStressPeriods.Free;
  end;
end;

procedure TfrmModflowImport.MakeMF2K_RiverBoundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TMF2K_RiverBoundary;
  StressPeriod: integer;
  StageRoot, OnOffRoot, ConductanceName, BottomName: string;
  ConductanceSt, Bottom: string;
  Conductance: single;
  StressPeriodIndex: integer;
  OnOffName, StageName: string;
  Stage: string;
  PName: string;
begin
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];
    StageRoot := ModflowTypes.GetMFRiverStageParamType.ANE_ParamName;
    OnOffRoot := ModflowTypes.GetMFOnOffParamType.ANE_ParamName;
    ConductanceName := ModflowTypes.GetMFRiverConductanceParamType.ANE_ParamName;
    BottomName := ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName;
    Conductance := ABoundary.Cond;
    ConductanceSt := InternationalFloatToStr(Conductance);
    Bottom := InternationalFloatToStr(ABoundary.RBot);
    PName := ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  end;
  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;

  try
    while BoundaryList.Count > 0 do
    begin

      UsedStressPeriods.Clear;

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      BoundaryContour.AddCopyOfPoint(APoint);
      BoundaryContour.SetAValue(ConductanceName, ConductanceSt);
      BoundaryContour.SetAValue(BottomName, Bottom);
      for StressPeriodIndex := 1 to NPER do
      begin
        OnOffName := OnOffRoot + IntToStr(StressPeriodIndex);
        BoundaryContour.SetAValue(OnOffName, '0');
      end;

      for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
      begin
        ABoundary := BoundaryList[BoundaryIndex];
        StressPeriod := ABoundary.StressPeriod + 1;
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          UsedStressPeriods.Add(StressPeriod);
          BoundaryList.Delete(BoundaryIndex);
          Stage := InternationalFloatToStr(ABoundary.Stage);
          StageName := StageRoot + IntToStr(StressPeriod);
          OnOffName := OnOffRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(StageName, Stage);
          BoundaryContour.SetAValue(OnOffName, '1');
          BoundaryContour.SetAValue(PName, ABoundary.ParameterName);
        end;
      end;
      for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
      begin
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          OnOffName := OnOffRoot + IntToStr(StressPeriod);
          BoundaryContour.SetAValue(OnOffName, '0');
        end;
      end;
      BoundaryContour.SetValue;
    end;
  finally
    UsedStressPeriods.Free;
  end;
end;

procedure TfrmModflowImport.ExportHeadObservations;
var
  AnEditContour: TEditContours;
  Index: integer;
  HeadObs: THeadObservation;
  Contour: TContour2;
  APoint: TPoint;
  X, Y: double;
  ExportStringList: TStringList;
  LayerHandle: ANE_PTR;
  LayerName: string;
  Project : TProjectOptions;
begin
  if HeadObservationList.Count > 0 then
  begin
    AnEditContour := TEditContours.Create(AGrid.OriginX, AGrid.OriginY,
      AGrid.GridAngle);
    try
      for Index := 0 to HeadObservationList.Count -1 do
      begin
        HeadObs := HeadObservationList[Index] as THeadObservation;
        Contour := TContour2.Create;
        AnEditContour.ContourList.Add(Contour);
        HeadObs.Coordinates(X, Y);
        APoint := TPoint.Create(X, Y);
        try
          Contour.AddCopyOfPoint(APoint);
          Contour.Value := HeadObs.ParmeterValues;
          Contour.FixValue(frmModflowImport.CurrentModelHandle);
        finally
          APoint.Free;
        end;
      end;

      ExportStringList := TStringList.Create;
      try
        AnEditContour.WriteContours(0, cbRowsPositive.Checked,
          cbColumnsPositive.Checked, ExportStringList);

        LayerName := ModflowTypes.GetMFWeightedHeadObservationsLayerType.
          ANE_LayerName + '1';

        Project := TProjectOptions.Create;
        try
          LayerHandle := Project.GetLayerByName(
            frmModflowImport.CurrentModelHandle, LayerName);
        finally
          Project.Free;
        end;
        Assert(LayerHandle <> nil);

        ImportText(ExportStringList, LayerHandle);
      finally
        ExportStringList.Free;
      end;
    finally
      AnEditContour.Free;
    end;
  end;
end;

function TfrmModflowImport.CreateNewHeadObservation: THeadObservation;
begin
  result := THeadObservation.Create;
  HeadObservationList.Add(result);
  CurrentHeadObservation := result;
end;

{ THeadObservation }

procedure THeadObservation.Coordinates(out X, Y: double);
var
  Below, Above: double;
begin
  // Get the X and Y coordinates of the observation point in the
  // local grid coordinate system.

  Below := frmModflowImport.AGrid.ColPositions[COLUMN-1];
  Above := frmModflowImport.AGrid.ColPositions[COLUMN];
  X := (Above - Below) * (COFF + 0.5) + Below;

  Below := frmModflowImport.AGrid.RowPositions[ROW-1];
  Above := frmModflowImport.AGrid.RowPositions[ROW];
  Y := (Above - Below) * (ROFF + 0.5) + Below;
end;

constructor THeadObservation.Create;
begin
  inherited;
  ProportionList:= TObjectList.Create;
  TimeList:= TObjectList.Create;
end;

destructor THeadObservation.Destroy;
begin
  ProportionList.Free;
  TimeList.Free;
  inherited;
end;

type
  TUnitLink = record
    MFLayer: integer;
    Proportion: double;
  end;

function THeadObservation.ParmeterValues: string;
var
  TopElev, BotElev: double;
  TopLayer: integer;
  BottomLayer: integer;
  ObservationTime: THeadObservationTime;
  LocalStatFlag : integer;
  LocalPlotSymbol : integer;
  LocalITT : integer;
  LocalObjectName: string;
  Index: integer;
  ML: TMLayer;
  UnitArray: array of TUnitLink;
  MFLayer: integer;
  TopBot: double;
begin
  // Get the top and bottom layer of the observation.
  Assert(frmModflowImport <> nil);
  if ProportionList.Count > 0 then
  begin
    TopLayer := (ProportionList[0] as TMLayer).Layer;
    BottomLayer := TopLayer;
    for Index := 1 to ProportionList.Count -1 do
    begin
      ML := ProportionList[Index] as TMLayer;
      if ML.Layer < TopLayer then
      begin
        TopLayer := ML.Layer;
      end
      else if ML.Layer > BottomLayer then
      begin
        BottomLayer := ML.Layer;
      end;
    end;
  end
  else
  begin
    TopLayer := Layer;
    BottomLayer := Layer;
  end;
  // Get the top and bottom elevations of the observation.
  TopElev := frmModflowImport.GetTop(COLUMN-1, ROW-1, TopLayer-1);
  BotElev := frmModflowImport.GetBOT(COLUMN-1, ROW-1, BottomLayer-1);
  TopBot := frmModflowImport.GetBOT(COLUMN-1, ROW-1, TopLayer-1);
  TopElev := TopElev - (TopElev - TopBot)/100;

  // If TimeList.Count > 0, the appropriate values of StatFlat an PlotSymbol
  // are the ones from the first THeadObservationTime.
  if TimeList.Count > 0 then
  begin
    ObservationTime := TimeList[0] as THeadObservationTime;
    LocalStatFlag := ObservationTime.STATFLAG;
    LocalPlotSymbol := ObservationTime.PLOTSYMBOL;
    LocalITT := ITT;
    LocalObjectName := ObservationTime.OBSNAM;
  end
  else
  begin
    LocalStatFlag := STATFLAG;
    LocalPlotSymbol := PLOTSYMBOL;
    LocalITT := 2;
    LocalObjectName := OBSNAM;
  end;
  // put quotes around LocalObjectName so that if it contains spaces,
  // it will still be read by Argus properly.
  LocalObjectName := '"' + LocalObjectName + '"';

  // Start setting the result.
  result := InternationalFloatToStr(TopElev) + #9 +
    InternationalFloatToStr(BotElev) + #9 +
    IntToStr(TopLayer) + #9 +
    IntToStr(BottomLayer) + #9 +
    IntToStr(LocalStatFlag) + #9 +
    IntToStr(LocalPlotSymbol) + #9 +
    IntToStr(LocalITT) + #9 +
    LocalObjectName + #9;


  // Get layer proportions for the observation.
  SetLength(UnitArray, frmModflow.dgGeol.RowCount -1);
  MFLayer := 0;
  for Index := 1 to frmModflow.dgGeol.RowCount -1 do
  begin
    if frmModflow.Simulated(Index) then
    begin
      Inc(MFLayer);
      UnitArray[Index-1].MFLayer := MFLayer
    end
    else
    begin
      UnitArray[Index-1].MFLayer := 0;
    end;
    UnitArray[Index-1].Proportion := 0;
  end;

  if ProportionList.Count > 0 then
  begin
    for Index := 0 to ProportionList.Count -1 do
    begin
      ML := ProportionList[Index] as TMLayer;
      for MFLayer := 0 to Length(UnitArray) -1 do
      begin
        if UnitArray[MFLayer].MFLayer = ML.Layer then
        begin
          UnitArray[MFLayer].Proportion := ML.Proportion;
          break;
        end;
      end;
    end;
  end
  else
  begin
    // For an observation that is not a multilayer observation, just assign
    // a proportion of 1 to the layer for which it will be used.
    for MFLayer := 0 to Length(UnitArray) -1 do
    begin
      if UnitArray[MFLayer].MFLayer = Layer then
      begin
        UnitArray[MFLayer].Proportion := 1;
        break;
      end;
    end;
  end;
  for MFLayer := 0 to Length(UnitArray) -1 do
  begin
    result := result + InternationalFloatToStr(UnitArray[MFLayer].Proportion) + #9;
  end;


  // write the time-dependent values.
  if TimeList.Count > 0 then
  begin
    for Index := 0 to TimeList.Count -1 do
    begin
      // be sure to put quotes around OBSNAM.
      ObservationTime := TimeList[Index] as THeadObservationTime;
      result := result + '"' + ObservationTime.OBSNAM + '"'  + #9 +
        InternationalFloatToStr(ObservationTime.HOBS) + #9 +
        IntToStr(ObservationTime.IREFSP) + #9 +
        InternationalFloatToStr(ObservationTime.TOFFSET) + #9 +
        InternationalFloatToStr(ObservationTime.STATh) + #9 +
        InternationalFloatToStr(ObservationTime.STATdd) + #9 +
        '1' + #9 + '0';
      if Index < TimeList.Count -1 then
      begin
        result := result + #9;
      end;
    end;
  end
  else
  begin
    // If there is only one observation time, TimeList.Count = 0 and
    // the values to use should be those of self rather than of a
    // THeadObservationTime.
    result := result + LocalObjectName + #9 +
      InternationalFloatToStr(HOBS) + #9 +
      IntToStr(IREFSP) + #9 +
      InternationalFloatToStr(TOFFSET) + #9 +
      InternationalFloatToStr(STATISTIC) + #9 +
      InternationalFloatToStr(STATISTIC) + #9 +
      '1' + #9 + '0';
  end;
end;


{ TFHBContour }

procedure TFHBContour.Update;
var
  ACell: TCell;
  TopParamName: string;
  BottomParameterName: string;
  Top: String;
  Bottom: string;
  Index: integer;
  IString: string;
  HeadParamString: string;
  FluxParamString: string;
  ParameterIndex: integer;
begin
  Values.Capacity := EditContours.ParameterNames.Count;
  for ParameterIndex := 0 to EditContours.ParameterNames.Count - 1 do
  begin
    Values.Add(kNa);
  end;

  ACell := frmModflowImport.AGrid.Cells[Col -1, Row-1];
  FPoints.Add(ACell.CenterPoint);

  TopParamName := ModflowTypes.GetMFFHBTopElevParamType.ANE_ParamName;
  BottomParameterName := ModflowTypes.GetMFFHBBotElevParamType.ANE_ParamName;

  Top := InternationalFloatToStr(frmModflowImport.GetTOP(Col-1, Row-1, Layer-1));
  Bottom := InternationalFloatToStr(frmModflowImport.GetBOT(Col-1, Row-1, Layer-1));

  SetAValue(TopParamName, Top);
  SetAValue(BottomParameterName, Bottom);

  for Index := 0 to Length(HeadValues)-1 do
  begin
    IString := IntToStr(Index+1);
    HeadParamString :=
      ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName + IString;
    SetAValue(HeadParamString, InternationalFloatToStr(HeadValues[Index]));
  end;

  for Index := 0 to Length(FlowValues)-1 do
  begin
    IString := IntToStr(Index+1);
    FluxParamString :=
      ModflowTypes.GetMFFHBPointFluxParamType.ANE_ParamName + IString;
    SetAValue(FluxParamString, InternationalFloatToStr(FlowValues[Index]));
  end;
  SetValue;
end;

procedure TFHBContour.WriteContour(OriginX, OriginY, GridAngle,
  Perturbation: double; RowDirectionPositive,
  ColumnDirectionPositive: boolean; ContourStringList: TStringList);
begin
  UpDate;
  inherited;
end;

function TfrmModflowImport.GetETSS(Col, Row, Dummy: Integer): Single;
begin
  result := AGrid.ETS_Surface[Col, Row]
end;

function TfrmModflowImport.GetETSX(Col, Row, Dummy: Integer): Single;
begin
  result := AGrid.ETS_ExtinctionDepth[Col, Row]
end;

function TfrmModflowImport.GetIETS(Col, Row, Dummy: Integer): Single;
begin
  result := AGrid.ETS_Layer[Col, Row]
end;

function TfrmModflowImport.GetETS_IntermediateDepth(Col, Row, Segment: Integer): Single;
begin
  result := AGrid.ETS_IntermediateDepth[Col, Row, Segment]
end;

function TfrmModflowImport.GetETS_IntermediateRate(Col, Row, Segment: Integer): Single;
begin
  result := AGrid.ETS_IntermediateRate[Col, Row, Segment]
end;

function TfrmModflowImport.GetETSR(Col, Row, StressPeriod: Integer): Single;
begin
  result := AGrid.ETS_MaxRate[Col, Row, StressPeriod]
end;

procedure TfrmModflowImport.MakeMF2K_CHD_Boundaries(
  BoundaryList: TTypedBoundaryList; APoint: TPoint);
var
  BoundaryContour: TBoundaryContour;
  UsedStressPeriods: TIntegerList;
  EditContours: TtypedEditContours;
  BoundaryIndex: integer;
  ABoundary: TMF2K_CHD_Boundary;
  StressPeriod: integer;
  StartHeadRoot, EndHeadRoot: string;
  StartHeadSt, EndHeadSt: string;
  StartHeadName, EndHeadName: string;
  ElevationName: String;
  Elevation: double;
  ElevationSt: String;
  PName: string;
  Column, Row, Layer: integer;
begin
  if BoundaryList.Count > 0 then
  begin
    ABoundary := BoundaryList[0];

    Column := ABoundary.Col-1;
    Row := ABoundary.Row-1;
    Layer := ABoundary.Layer - 1;
    Elevation := (frmModflowImport.GetTOP(Column, Row, Layer)
      + frmModflowImport.GetBOT(Column, Row, Layer)) / 2;

    StartHeadRoot := ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName;
    EndHeadRoot := ModflowTypes.GetMFCHD_EndHeadParamType.ANE_ParamName;

    ElevationName := ModflowTypes.GetMFCHD_ElevationParamType.ANE_ParamName;
    ElevationSt := InternationalFloatToStr(Elevation);

    PName := ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName;
  end;

  EditContours := GetATypedEditContours(
    BoundaryList.BoundaryType, BoundaryList.Layer);
  UsedStressPeriods := TIntegerList.Create;
  try
    while BoundaryList.Count > 0 do
    begin

      UsedStressPeriods.Clear;

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      BoundaryContour.AddCopyOfPoint(APoint);
      BoundaryContour.SetAValue(ElevationName, ElevationSt);
//      BoundaryContour.SetAValue(ConductanceName, ConductanceSt);

{      for StressPeriodIndex := 1 to NPER do
      begin
        StartHeadName := StartHeadRoot + IntToStr(StressPeriodIndex);
        BoundaryContour.SetAValue(StartHeadName, StartHeadSt);
      end;  }

      for BoundaryIndex := BoundaryList.Count - 1 downto 0 do
      begin
        ABoundary := BoundaryList[BoundaryIndex];
        StressPeriod := ABoundary.StressPeriod + 1;
        if UsedStressPeriods.IndexOf(StressPeriod) < 0 then
        begin
          UsedStressPeriods.Add(StressPeriod);
          BoundaryList.Delete(BoundaryIndex);

          StartHeadSt := InternationalFloatToStr(ABoundary.StartingHead);
          StartHeadName := StartHeadRoot + IntToStr(StressPeriod);
          EndHeadSt := InternationalFloatToStr(ABoundary.EndingHead);
          EndHeadName := EndHeadRoot + IntToStr(StressPeriod);

          BoundaryContour.SetAValue(StartHeadName, StartHeadSt);
          BoundaryContour.SetAValue(EndHeadName, EndHeadSt);
          BoundaryContour.SetAValue(PName, ABoundary.ParameterName);
        end;
      end;

      // If the values for a stress period have not be explicitly
      // specified, use the values from the previous stress period.
      if BoundaryList.Count > 0 then
      begin
        ABoundary := BoundaryList[0];
        for StressPeriod := 1 to frmModflow.dgTime.RowCount - 1 do
        begin
          if (UsedStressPeriods.IndexOf(StressPeriod) < 0)
            and (UsedStressPeriods.IndexOf(StressPeriod-1) >= 0) then
          begin
            UsedStressPeriods.Add(StressPeriod);

            StartHeadName := StartHeadRoot + IntToStr(StressPeriod-1);
            StartHeadSt := BoundaryContour.GetAValue(StartHeadName);
            EndHeadName := EndHeadRoot + IntToStr(StressPeriod-1);
            EndHeadSt := BoundaryContour.GetAValue(EndHeadName);

            StartHeadName := StartHeadRoot + IntToStr(StressPeriod);
            EndHeadName := EndHeadRoot + IntToStr(StressPeriod);

            BoundaryContour.SetAValue(StartHeadName, StartHeadSt);
            BoundaryContour.SetAValue(EndHeadName, EndHeadSt);
            // only one parameter name can be assigned for all the stress periods.
            BoundaryContour.SetAValue(PName, ABoundary.ParameterName);
          end;
        end;
      end;        
      BoundaryContour.SetValue;
    end;

  finally
    UsedStressPeriods.Free;
  end;
end;

procedure TfrmModflowImport.StoreMF2K_HFBBoundary(const Layer, Row1, Col1,
  Row2, Col2: integer; const Hydchr: single; const ParamName: string);
var
  Item: THFB_Storage;
begin
   Item := THFB_Storage.Create;
   Item.Layer := Layer;
   Item.Row1 := Row1;
   Item.Col1 := Col1;
   Item.Row2 := Row2;
   Item.Col2 := Col2;
   Item.HYDCHR := Hydchr;
   Item.ParamName := ParamName;
   MF2K_HfbList.Add(Item);
end;

procedure TfrmModflowImport.MakeMF2K_HFBBoundaries;
var
//  BarrierHydraulicConductivity: double;
  EditContours: TtypedEditContours;
  HydraulicConductivitySt: string;
  BoundaryContour: TBoundaryContour;
  ASegment: TSegment;
  Item: THFB_Storage;
  Index: integer;
  Epsilon: double;
begin
  for Index := frmModflow.dgHFBParameters.RowCount -1 downto 1 do
  begin
    if MF2K_HfbNamesList.IndexOf(frmModflow.
      dgHFBParameters.Cells[0, Index]) < 0 then
    begin
      frmModflow.dgHFBParameters.Row := Index;
      frmModflow.btnDeleteHFB_ParameterClick(frmModflow.btnDeleteHFB_Parameter);
    end;

  end;


  Epsilon := AGrid.PerturbAmount;
  for Index := 0 to MF2K_HfbList.Count -1 do
  begin
    Item := MF2K_HfbList[Index] as THFB_Storage;

    With Item do
    begin
      EditContours := GetATypedEditContours(
        btMF2K_HFB, Layer);

      BoundaryContour := TBoundaryContour.Create(EditContours);
      EditContours.ContourList.Add(BoundaryContour);

      ASegment := nil;
      if Col1 = Col2 then
      begin
        Assert(Abs(Row1 - Row2) = 1);
        ASegment := AGrid.HorSegments[Col1-1,
          Min(Row1, Row2)];
      end
      else if Row1 = Row2 then
      begin
        Assert(Abs(Col1 - Col2) = 1);
        ASegment := AGrid.VerSegments[Min(Col1, Col2),
          Row1-1];
      end
      else
      begin
        Assert(False);
      end;

      ASegment.StartPoint.X := ASegment.StartPoint.X + Epsilon;
      ASegment.StartPoint.Y := ASegment.StartPoint.Y + Epsilon;
      ASegment.EndPoint.X := ASegment.EndPoint.X + Epsilon;
      ASegment.EndPoint.Y := ASegment.EndPoint.Y + Epsilon;

      BoundaryContour.AddCopyOfPoint(ASegment.StartPoint);
      BoundaryContour.AddCopyOfPoint(ASegment.EndPoint);

      HydraulicConductivitySt := InternationalFloatToStr(Hydchr);


      BoundaryContour.SetAValue(ModflowTypes.
        GetMFHFBHydCondParamType.ANE_ParamName, HydraulicConductivitySt);
      BoundaryContour.SetAValue(ModflowTypes.
        GetMFHFBBarrierThickParamType.ANE_ParamName, '1');
      BoundaryContour.SetAValue(ModflowTypes.
        GetAdjustForAngleParamType.ANE_ParamName, '1');
      BoundaryContour.SetAValue(ModflowTypes.
        GetMFModflowParameterNameParamType.ANE_ParamName, '0');
      if ParamName <> '' then
      begin
        BoundaryContour.SetAValue(ModflowTypes.
          GetMFModflowParameterNameParamType.ANE_ParamName, ParamName);
      end;
      BoundaryContour.SetValue;
    end;
  end;
end;

end.

