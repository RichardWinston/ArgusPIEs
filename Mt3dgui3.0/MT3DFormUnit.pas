unit MT3DFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ModflowUnit, Menus, ComCtrls, ExtCtrls, StdCtrls, Grids, 
  ArgusDataEntry, Buttons, MT3DLayerStructureUnit, MFLayerStructureUnit,
  DataGrid, ASLink, VersInfo;


type
  TfrmMT3D = class(TfrmMODFLOW)
    tabMT3DBas: TTabSheet;
    sgMT3DTime: TStringGrid;
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
    lblMT3DParticleMult: TLabel;
    lblMT3DInterpMeth: TLabel;
    lblMT3DSinkParticlePlacement: TLabel;
    lblMT3DSinParticlePlanes: TLabel;
    lblMT3DSinkParticleN: TLabel;
    lblMT3DCritConcGrad: TLabel;
    lblMT3DNPLANE: TLabel;
    lblMT3DNPMIN: TLabel;
    lblMT3DNPMAX: TLabel;
    lblMT3DSRMULT: TLabel;
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
    adeMT3DParticleMult: TArgusDataEntry;
    comboMT3DInterpMeth: TComboBox;
    comboMT3DInitPartSinkChoice: TComboBox;
    adeMT3DSinkParticlePlaneCount: TArgusDataEntry;
    adeMT3DSinkParticleCount: TArgusDataEntry;
    adeMT3DCritRelConcGrad: TArgusDataEntry;
    comboMT3DIsotherm: TComboBox;
    comboMT3DIREACT: TComboBox;
    sgReaction: TStringGrid;
    tabMT3DOut: TTabSheet;
    cbPrintLinkFile: TCheckBox;
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
    sgPrintoutTimes: TStringGrid;
    lblMT3D_TIMPRS: TLabel;
    btmDeleteMT3DPrintTime: TButton;
    btmInsertMT3DPrintTime: TButton;
    btmAddMT3DPrintTime: TButton;
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
    adeMT3DPath: TArgusDataEntry;
    rbRunMT3D: TRadioButton;
    rbCreateMT3D: TRadioButton;
    tabMT3DDisp: TTabSheet;
    gboxMT3DDispersion: TGroupBox;
    sgDispersion: TStringGrid;
    tabStrLake: TTabSheet;
    gbLake: TGroupBox;
    cbLAK: TCheckBox;
    lblLAK: TLabel;
    comboLAKSteady: TComboBox;
    adeMaxLakEquations: TArgusDataEntry;
    lblLakeEquationMax: TLabel;
    adeLakeNumSubSteps: TArgusDataEntry;
    lblLakeNumSubSteps: TLabel;
    adeMaxLakeStreams: TArgusDataEntry;
    lblLAKMaxLakeStream: TLabel;
    comboLakeBottomCond: TComboBox;
    lblLakeBottomCond: TLabel;
    comboLakeSideCond: TComboBox;
    lblLakeSideCond: TLabel;
    lblExportStream: TLabel;
    cbExpLak: TCheckBox;
    lblExportLake: TLabel;
    cbPrintLake: TCheckBox;
    rgMODFLOWVersion: TRadioGroup;
    cbExpLakFlow: TCheckBox;
    lblExpLakeFlow: TLabel;
    gboxMT3DBasic: TGroupBox;
    lblMT3DHeading1: TLabel;
    lblMT3DHeading2: TLabel;
    lblMT3DInactiveConc: TLabel;
    lblMT3DLengthUnit: TLabel;
    lblMT3DMassUnit: TLabel;
    lblMT3DAdvOpt: TLabel;
    lblMT3DDispOpt: TLabel;
    lblMT3DSourceSink: TLabel;
    lblMT3DChemReact: TLabel;
    lblMT3D_CINACT: TLabel;
    lblMT3D_LUNIT: TLabel;
    lblMT3D_MUNIT: TLabel;
    adeMT3DHeading1: TArgusDataEntry;
    adeMT3DHeading2: TArgusDataEntry;
    adeMT3DInactive: TArgusDataEntry;
    edMT3DLength: TEdit;
    edMT3DMass: TEdit;
    cbADV: TCheckBox;
    cbDSP: TCheckBox;
    cbSSM: TCheckBox;
    cbRCT: TCheckBox;
    cbMT3D: TCheckBox;
    cbSPG: TCheckBox;
    cbSPGRetain: TCheckBox;
    comboSpgSteady: TComboBox;
    cbAltSpg: TCheckBox;
    lblSeepage: TLabel;
    cbFlowSpg: TCheckBox;
    lblExpSeepageFlow: TLabel;
    cbExpSPG: TCheckBox;
    lblExportSeepage: TLabel;
    cbMT3D_TVC: TCheckBox;
    procedure FormCreate(Sender: TObject);  override;
    procedure edNumPerExit(Sender: TObject); override;
    procedure btnInsertTimeClick(Sender: TObject); override;
    procedure btnDeleteTimeClick(Sender: TObject); override;
    procedure UnitChange(Sender: TObject); virtual;
    procedure sgMT3DTimeSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgMT3DTimeSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String); virtual;
    procedure sgMT3DTimeDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure comboMT3DAdvSolSchemeChange(Sender: TObject); virtual;
    procedure comboMT3DInitPartPlaceChange(Sender: TObject); virtual;
    procedure comboMT3DInitPartSinkChoiceChange(Sender: TObject); virtual;
    procedure cbMT3DClick(Sender: TObject); virtual;
    procedure cbADVClick(Sender: TObject); virtual;
    procedure cbDSPClick(Sender: TObject); virtual;
    procedure cbRCHClick(Sender: TObject); override;
    procedure cbRIVClick(Sender: TObject); override;
    procedure cbWELClick(Sender: TObject); override;
    procedure cbDRNClick(Sender: TObject); override;
    procedure cbGHBClick(Sender: TObject); override;
    procedure cbEVTClick(Sender: TObject); override;
    procedure comboResultsPrintedChange(Sender: TObject); virtual;
    procedure cbPrintConcClick(Sender: TObject); virtual;
    procedure cbPrintRetardationClick(Sender: TObject); virtual;
    procedure cbPrintDispCoefClick(Sender: TObject); virtual;
    procedure cbPrintNumParticlesClick(Sender: TObject); virtual;
    procedure sgTimeSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String); override;
    procedure btnAddTimeClick(Sender: TObject); override;
    procedure edNumUnitsExit(Sender: TObject);  override;
    procedure btnDeleteUnitClick(Sender: TObject); override;
    procedure btnInsertUnitClick(Sender: TObject); override;
    procedure btnAddUnitClick(Sender: TObject); override;
    procedure dgGeolSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String); override;
    procedure sgReactionSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgReactionDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState); virtual;
    procedure comboMT3DIsothermChange(Sender: TObject); virtual;
    procedure comboMT3DIREACTChange(Sender: TObject); virtual;
    procedure cbRCTClick(Sender: TObject); virtual;
    procedure sgReactionSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String); virtual;
    procedure sgReactionExit(Sender: TObject); virtual;
    procedure sgMT3DTimeExit(Sender: TObject); virtual;
    procedure sgDispersionSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgDispersionSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String); virtual;
    procedure btmAddMT3DPrintTimeClick(Sender: TObject); virtual;
    procedure btmInsertMT3DPrintTimeClick(Sender: TObject); virtual;
    procedure btmDeleteMT3DPrintTimeClick(Sender: TObject); virtual;
    procedure sgPrintoutTimesSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean); virtual;
    procedure sgPrintoutTimesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String); virtual;
    procedure sgDispersionExit(Sender: TObject); virtual;
    procedure sgPrintoutTimesExit(Sender: TObject);
    procedure cbLAKClick(Sender: TObject); virtual;
    procedure adeMaxLakeStreamsEnter(Sender: TObject); virtual;
    procedure adeMaxLakeStreamsExit(Sender: TObject); virtual;
    procedure adeMaxLakeStreamsChange(Sender: TObject); virtual;
    procedure adeMaxLakEquationsExit(Sender: TObject); virtual;
    procedure cbRBWSTRClick(Sender: TObject); virtual;
    procedure cbRBWUseTributariesClick(Sender: TObject); virtual;
    procedure cbRBWUseDiversionsClick(Sender: TObject); virtual;
    procedure cbRBWCalculateStageClick(Sender: TObject); virtual;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; override;
    procedure comboTimeUnitsChange(Sender: TObject); override;
    procedure pageControlMainChange(Sender: TObject); override;
    procedure cbSTRClick(Sender: TObject); override;
    procedure btnOKClick(Sender: TObject); override;
    procedure cbSPGClick(Sender: TObject); virtual;
    procedure cbAltSpgClick(Sender: TObject); virtual;
    procedure cbSSMClick(Sender: TObject); virtual;
    procedure cbFHBClick(Sender: TObject); override;
    procedure cbMT3D_TVCClick(Sender: TObject); virtual;
  private
    { Private declarations }
  public
//    MFLayerStructure : TMT3DLayerStructure;
    PreviousMT3DTimeText : string;
    PreviousMT3DChemText : string;
    PreviousMT3DDispText : string;
    PreviousMT3DPrintoutTimeText : string;
    PreviousLakeStreamsText : string;
    procedure StreamWarning; override;
    procedure FhbWarning; virtual;
    procedure LakeWarning; virtual;
    procedure SeepageWarning; virtual;
    procedure ReadOldStreamPrint(var LineIndex: integer; FirstList, IgnoreList,
      DataToRead: TStringList; const VersionControl: TControl); virtual;
    procedure ReadOldLakeGeoData(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure InitializeGrids ; override;
//    Procedure AssociateUnits; override;
//    Procedure AssociateTimes; override;
    Procedure InsertTimeParameters (Position : Integer) ; override;
//    procedure DeleteTimeParameters (Position : Integer); override;
//    procedure CreateGeologicLayer(Position : integer); override;
//    procedure DeleteGeologicLayer(Position : integer); override;
//    function MFLayerStructure : TLayerStructure; override;
    procedure EnableSSM; virtual;
//    procedure AssignHelpFile ; override;
    procedure ReadOldStream(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadOldStreamSteady(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadOldStreamTrib(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadOldStreamDiv(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadOldStreamICALC(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    procedure ReadOldStreamModelUnits(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
      DataToRead : TStringList; const VersionControl : TControl); virtual;
    { Public declarations }
    procedure ModelComponentName(AStringList: TStringList); override;
  end;

type MT3DTimeData = (tdmN, tdmLength, tdmStepSize,tdmMaxSteps, tdmCalculated);
type MT3DDispersionData = (ddmN, ddmName, ddmHorDisp,ddmVertDisp, ddmMolDiffCoef);
type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);
type MT3DPrintoutTimes = (ptmN, ptmTime);

{type MT3DReactData = (rdmN, rdmName, rdmBulkDensity, rdmFirstSorb,
     rdmSecondSorb,   }


{var
  frmMT3D: TfrmMT3D; }

ResourceString
  rsTransStep = 'Transport step size (DTO)';
  rsMaxTransStep = 'Max. no. of transport steps (MXSTRN)';
  rsTranCalculated = 'Transport step size calculated (DTO)';
//  rsMT3DDllFileName = 'MT3DProject.dll';
  rsHorzDispRatio = 'Horz. Dispersivity Ratio (TRPT)';
  rsVertDispRatio = 'Vert. Dispersivity Ratio (TRPV)';
  rsMolDifCoef = 'Molecular Diffusion Coef. (DMCOEF)';
  rsBulkDensity = 'Bulk Density (RHOB)';
  rsSorpConst1 = '1''st Sorption Const. (SP1)';
  rsSorpConst2 = '2''nd Sorption Const. (SP2)';
  rsRateConstDis = 'Rate Const. Disolved (RC1)';
  rsRateConstSorb = 'Rate Const. Sorbed (RC2)';
  rsTime = 'Time';

implementation

{$R *.DFM}

uses ANE_LayerUnit, MT3DGrid, MFGrid, MT3DGeneralParameters,
     MFMOCObsWell, Variables, UtilityFunctions, MFRBWLake, {MFRBWStreamUnit,}
     ArgusFormUnit;

{procedure TfrmMT3D.AssignHelpFile(HelpFileName : string) ;
var
    DllDirectory : String;
begin
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + HelpFileName;
    end
  else
    begin
      ShowMessage(DLLName + ' not found.');
    end;
end;   }

{function TfrmMT3D.MFLayerStructure : TLayerStructure;
begin
  result := MFLayerStructure ;
end;  }

{Procedure TfrmMT3D.AssociateUnits;
var
  GeolUnitIndex : Integer;
  AGeologicUnit : TMT3DGeologicUnit;
  ListOfParameterLists, AParameterList : TList;
  ParameterListIndex, ParameterIndex : integer;
  AParamList : T_ANE_IndexedParameterList;
begin
  for GeolUnitIndex := 0 to MFLayerStructure.ListsOfIndexedLayers.Count -1 do
  begin
    AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.GetNonDeletedIndLayerListByIndex(GeolUnitIndex)
      as TMT3DGeologicUnit;
    sgcUnits.Objects[0, GeolUnitIndex + 1] := AGeologicUnit;
  end;
  ListOfParameterLists
    := MFLayerStructure.MakeParameter1Lists(StrToInt(edNumUnits.Text));
  for ParameterListIndex := 0 to ListOfParameterLists.Count -1 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    sgcUnits.Objects[1, ParameterListIndex+1] := AParameterList;
    if (ParameterListIndex < MaxObsWellLayers) then
    begin
      for ParameterIndex := 0 to AParameterList.Count -1 do
      begin
        AParamList := AParameterList.Items[ParameterIndex];
        if (AParamList is ModflowTypes.GetMOCElevParamListType) then
        begin
          AParameterList.Delete(ParameterIndex);
          break;
        end;
      end;
    end;
  end;
  ListOfParameterLists.Free;
end;  } 


Procedure TfrmMT3D.InsertTimeParameters (Position : integer) ;
begin
  inherited;
{    if cbRCH.Checked then
    begin
      MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetRechargeLayerType,
        ModflowTypes.GetMFRechElevParamListType, Position);
    end;
    if cbRCH.Checked and cbMOC3D.Checked then
    begin
      MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMOCRechargeConcLayerType,
        ModflowTypes.GetMOCRechargeConcTimeParamListType, Position);
    end;
    if cbEVT.Checked then
    begin
      MFLayerStructure.UnIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetETLayerType, ModflowTypes.GetETTimeParamListType, Position);
    end;
    if cbWEL.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFWellTimeParamListType, Position);
    end;
    if cbWEL.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFWellLayerType, ModflowTypes.GetMFWellTimeParamListType, Position);
    end;
    if cbRIV.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFLineRiverLayerType, ModflowTypes.GetMFRiverTimeParamListType, Position);
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaRiverLayerType, ModflowTypes.GetMFRiverTimeParamListType, Position);
    end;
    if cbDRN.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetLineDrainLayerType, ModflowTypes.GetMFDrainTimeParamListType, Position);
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetAreaDrainLayerType, ModflowTypes.GetMFDrainTimeParamListType, Position);
    end;
    if cbGHB.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetPointGHBLayerType, ModflowTypes.GetGHBTimeParamListType, Position);
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetLineGHBLayerType, ModflowTypes.GetGHBTimeParamListType, Position);
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetAreaGHBLayerType, ModflowTypes.GetGHBTimeParamListType, Position);
    end;   }
    if cbLAK.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFLakeLayerType, ModflowTypes.GetMFLakeTimeParamListType, Position);
    end;
    if cbSPG.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFLineSeepageLayerType,
        ModflowTypes.GetMFSeepageTimeParamListType, Position);
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetMFAreaSeepageLayerType,
        ModflowTypes.GetMFSeepageTimeParamListType, Position);
    end;
    if cbMT3D.Checked and cbSSM.Checked then
    begin
      MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
        ModflowTypes.GetPrescribedHeadLayerType,
        ModflowTypes.GetMT3DPrescribedHeadTimeParamListType, Position);
      if cbMT3D_TVC.Checked then
      begin
        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
          ModflowTypes.GetMT3DPointTimeVaryConcLayerType,
          ModflowTypes.GetMT3DPointTimeVaryConcTimeParamListType, Position);
        MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList2(
          ModflowTypes.GetMT3DAreaTimeVaryConcLayerType,
          ModflowTypes.GetMT3DAreaTimeVaryConcTimeParamListType, Position);
      end;
    end;
end;


{procedure TfrmMT3D.CreateGeologicLayer(Position : integer);
var
  AMFGridLayer : TMFGridLayer;
begin
  ModflowTypes.GetGeologicUnitType.Create
    (MFLayerStructure.ListsOfIndexedLayers, Position);

  AMFGridLayer := MFLayerStructure.UnIndexedLayers.GetLayerByName
    (ModflowTypes.GetGridLayerType.ANE_LayerName) as ModflowTypes.GetGridLayerType;

  ModflowTypes.GetMFGeologicUnitParametersType.Create
    (AMFGridLayer.IndexedParamList1, Position);
end; }

{procedure TfrmMT3D.DeleteGeologicLayer(Position : integer);
var
  UnitParamIndex : integer;
  AGeologicUnitParameters : TGeologicUnitParameters;
  AGeologicUnit : TMT3DGeologicUnit;
  AUnitParamList : TList;
//  AGeologicUnitParametersClass : TMFGeologicUnitParametersClass;
begin
  AGeologicUnit := sgcUnits.Objects[0,Position] as ModflowTypes.GetMT3DGeologicUnitType;
  AGeologicUnit.DeleteSelf;
  sgcUnits.Objects[0,Position] := nil;

  AUnitParamList := sgcUnits.Objects[1,Position] as TList;
  for UnitParamIndex := AUnitParamList.Count -1 downto 0 do
  begin
    AGeologicUnitParameters := AUnitParamList.Items[UnitParamIndex];
    AGeologicUnitParameters.DeleteSelf;
//    AGeologicUnitParametersClass := GetMFGeologicUnitParametersType;
//    (AUnitParamList.Items[UnitParamIndex] as AGeologicUnitParametersClass).DeleteSelf
  end;
  AUnitParamList.Free;
  sgcUnits.Objects[1,Position] := nil;
end;  }


procedure TfrmMT3D.InitializeGrids;
var
  RowIndex : integer;
begin
  inherited InitializeGrids;

  sgMT3DTime.Cells[Ord(tdmN),0] := rsN;
  sgMT3DTime.Cells[Ord(tdmLength),0] := rsLength;
  sgMT3DTime.Cells[Ord(tdmStepSize),0] := rsTransStep;
  sgMT3DTime.Cells[Ord(tdmMaxSteps),0] := rsMaxTransStep;
  sgMT3DTime.Cells[Ord(tdmCalculated),0] := rsTranCalculated;

  for RowIndex := 1 to sgMT3DTime.RowCount - 1 do
  begin
    sgMT3DTime.Cells[Ord(tdmN),RowIndex] := IntToStr(RowIndex);
  end;


  sgDispersion.RowCount :=  dgGeol.RowCount;
  sgReaction.RowCount :=  dgGeol.RowCount;

  sgDispersion.Cells[Ord(ddmN),0] := rsN;
  sgDispersion.Cells[Ord(ddmName),0] := rsName;
  sgDispersion.Cells[Ord(ddmHorDisp),0] := rsHorzDispRatio;
  sgDispersion.Cells[Ord(ddmVertDisp),0] := rsVertDispRatio;
  sgDispersion.Cells[Ord(ddmMolDiffCoef),0] := rsMolDifCoef;

  for RowIndex := 1 to sgDispersion.RowCount - 1 do
  begin
    sgDispersion.Cells[Ord(ddmN),RowIndex] := IntToStr(RowIndex);
    sgDispersion.Cells[Ord(ddmName),RowIndex] := dgGeol.Cells[Ord(nuiName),RowIndex]
  end;

  sgReaction.Cells[Ord(rdmN),0] := rsN;
  sgReaction.Cells[Ord(ddmName),0] := rsName;
  sgReaction.Cells[Ord(rdmBulkDensity),0] := rsBulkDensity;
  sgReaction.Cells[Ord(rdmSorpConst1),0] := rsSorpConst1;
  sgReaction.Cells[Ord(rdmSorpConst2),0] := rsSorpConst2;
  sgReaction.Cells[Ord(rdmRateConstDiss),0] := rsRateConstDis;
  sgReaction.Cells[Ord(rdmRateConstSorp),0] := rsRateConstSorb;

  for RowIndex := 1 to sgReaction.RowCount - 1 do
  begin
    sgReaction.Cells[Ord(rdmN),RowIndex] := IntToStr(RowIndex);
    sgReaction.Cells[Ord(rdmName),RowIndex] := dgGeol.Cells[Ord(nuiName),RowIndex]
  end;

//  rsTime = 'Time';
//type MT3DPrintoutTimes = (ptmN, ptmTime);
  sgPrintoutTimes.Cells[Ord(ptmN),0] := rsN;
  sgPrintoutTimes.Cells[Ord(ptmTime),0] := rsTime;
  for RowIndex := 1 to sgPrintoutTimes.RowCount - 1 do
  begin
    sgPrintoutTimes.Cells[Ord(ptmN),RowIndex] := IntToStr(RowIndex);
  end;

//  sgReaction.Cells[
end;

procedure TfrmMT3D.EnableSSM;
begin
  if cbRCH.Checked or cbRIV.Checked or cbWEL.Checked or cbDRN.Checked
     or cbGHB.Checked or cbEVT.Checked or cbSTR.Checked
  then
    begin
      cbSSM.Checked;
      cbSSM.Enabled := False;
    end
  else
    begin
      cbSSM.Enabled := True;
    end;
end;

procedure TfrmMT3D.FormCreate(Sender: TObject);
var
  RowIndex : integer;
  OldGeolContGrid : TSpecialHandlingObject;

  OldStream : TSpecialHandlingObject;
  OldStreamDiv : TSpecialHandlingObject;
  OldStreamICALC : TSpecialHandlingObject;
  OldStreamModelUnits : TSpecialHandlingObject;
  OldStreamSteady : TSpecialHandlingObject;
  OldStreamTrib : TSpecialHandlingObject;
  OldStreamPrintFlows : TSpecialHandlingObject;
begin
  inherited;

  OldGeolContGrid := TSpecialHandlingObject.Create('sgcUnits',ReadOldLakeGeoData);
  SpecialHandlingList.Add(OldGeolContGrid);

  OldStream := TSpecialHandlingObject.Create('cbRBWSTR',ReadOldStream);
  SpecialHandlingList.Add(OldStream);

  OldStreamDiv := TSpecialHandlingObject.Create('cbRBWUseDiversions',ReadOldStreamDiv);
  SpecialHandlingList.Add(OldStreamDiv);

  OldStreamICALC := TSpecialHandlingObject.Create('cbRBWCalculateStage',ReadOldStreamICALC);
  SpecialHandlingList.Add(OldStreamICALC);

  OldStreamModelUnits := TSpecialHandlingObject.Create('comboRBWStreamModelLength',ReadOldStreamModelUnits);
  SpecialHandlingList.Add(OldStreamModelUnits);

  OldStreamSteady := TSpecialHandlingObject.Create('comboRBWSTRSteady',ReadOldStreamSteady);
  SpecialHandlingList.Add(OldStreamSteady);

  OldStreamTrib := TSpecialHandlingObject.Create('cbRBWUseTributaries',ReadOldStreamTrib);
  SpecialHandlingList.Add(OldStreamTrib);

  OldStreamPrintFlows := TSpecialHandlingObject.Create('cbExpStrFlow',ReadOldStreamPrint);
  SpecialHandlingList.Add(OldStreamPrintFlows);

  FirstList.Add('cbLAK');
  FirstList.Add('adeMaxLakeStreams');

  IgnoreList.Add('rbRunMT3D');
  IgnoreList.Add('rbCreateMT3D');
  IgnoreList.Add('cbExpStr');
  IgnoreList.Add('cbExpLak');
  IgnoreList.Add('cbExportMT3DBTN');
  IgnoreList.Add('cbExportMT3DADV');
  IgnoreList.Add('cbExportMT3DDSP');
  IgnoreList.Add('cbExportMT3DSSM');
  IgnoreList.Add('cbExportMT3DRCT');
  IgnoreList.Add('rgMODFLOWVersion');
  IgnoreList.Add('cbExpSPG');

  for RowIndex := 1 to sgMT3DTime.RowCount - 1 do
  begin
    sgMT3DTime.Cells[Ord(tdmLength), RowIndex]
      := sgTime.Cells[Ord(tdLength), RowIndex];
    sgMT3DTime.Cells[Ord(tdmStepSize), RowIndex] := '1';
    sgMT3DTime.Cells[Ord(tdmMaxSteps), RowIndex] := '1000';
    sgMT3DTime.Cells[Ord(tdmCalculated), RowIndex] := 'Yes';
  end;    

{type MT3DDispersionData = (ddmN, ddmName, ddmHorDisp,ddmVertDisp, ddmMolDiffCoef);
type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);
type MT3DPrintoutTimes = (ptmN, ptmTime);
}
  for RowIndex := 1 to sgReaction.RowCount - 1 do
  begin
    sgReaction.Cells[Ord(rdmBulkDensity), RowIndex] := '0.3';
    sgReaction.Cells[Ord(rdmSorpConst1), RowIndex] := '1';
    sgReaction.Cells[Ord(rdmSorpConst2), RowIndex] := '1';
    sgReaction.Cells[Ord(rdmRateConstDiss), RowIndex] := '1e-006';
    sgReaction.Cells[Ord(rdmRateConstSorp), RowIndex] := '1e-006';
  end;
  for RowIndex := 1 to sgDispersion.RowCount - 1 do
  begin
    sgDispersion.Cells[Ord(ddmHorDisp), RowIndex] := '0.2';
    sgDispersion.Cells[Ord(ddmVertDisp), RowIndex] := '0.2';
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
  comboLAKSteady.ItemIndex := 1;
  comboLakeBottomCond.ItemIndex := 0;
  comboLakeSideCond.ItemIndex := 1;
  comboSpgSteady.ItemIndex := 1;
end;

procedure TfrmMT3D.edNumPerExit(Sender: TObject);
var
  NewNumPeriods : integer;
  RowIndex, ColIndex : integer;
begin
//  if Sender = edNumPer then
//  begin
    inherited;
//  end;
  NewNumPeriods := StrToInt(edNumPer.Text);
  If NewNumPeriods > PrevNumPeriods
  then
  begin
    sgMT3DTime.RowCount := NewNumPeriods + 1;
    For RowIndex := PrevNumPeriods + 1 to sgMT3DTime.RowCount -1 do
    begin
      sgMT3DTime.Cells[Ord(tdN),RowIndex] := IntToStr(RowIndex);
      For ColIndex := 1 to sgMT3DTime.ColCount -1 do
      begin
        sgMT3DTime.Cells[ColIndex,RowIndex]
          := sgMT3DTime.Cells[ColIndex,RowIndex-1];
      end;
    end;
  end
  else
  begin
    sgMT3DTime.RowCount := NewNumPeriods + 1;
  end;

end;

procedure TfrmMT3D.btnInsertTimeClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
begin
  inherited;
//  edNumPerExit(Sender);
  CurrentRow := sgTime.Selection.Top;
  for RowIndex := sgMT3DTime.RowCount -2 downto CurrentRow do
  begin
    sgMT3DTime.Cells[0,RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgMT3DTime.ColCount -1 do
    begin
      sgMT3DTime.Cells[ColIndex,RowIndex +1] := sgMT3DTime.Cells[ColIndex,RowIndex];
    end;
  end;

end;

procedure TfrmMT3D.btnDeleteTimeClick(Sender: TObject);
Var
  CurrrentRow : integer;
  RowIndex, ColIndex : integer;
begin
  inherited;
//  edNumPerExit(Sender);
  CurrrentRow := sgTime.Selection.Top;
  for RowIndex := CurrrentRow +1 to sgMT3DTime.RowCount -1 do
  begin
    For ColIndex := 1 to sgMT3DTime.ColCount -1 do
    begin
      sgMT3DTime.Cells[ColIndex,RowIndex-1] := sgMT3DTime.Cells[ColIndex,RowIndex];
    end;
  end;

end;

procedure TfrmMT3D.UnitChange(Sender: TObject);
var
  AnEdit : TEdit;
begin
  inherited;
  AnEdit := Sender as TEdit;
  if Length(AnEdit.Text) > 4 then
  begin
    AnEdit.Text := Copy(AnEdit.Text, 1, 4);
  end;  
end;

procedure TfrmMT3D.sgMT3DTimeSelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
begin
  inherited;
  if Col = Ord(tdmLength) then
  begin
    CanSelect := False;
  end;
  PreviousMT3DTimeText := sgMT3DTime.Cells[Col, Row];
  if Col = Ord(tdmStepSize) then
    begin
      if sgMT3DTime.Cells[Ord(tdmCalculated),Row] = 'Yes'
      then
        begin
          sgMT3DTime.Options := sgMT3DTime.Options - [goEditing];
        end
      else
        begin
          sgMT3DTime.Options := sgMT3DTime.Options + [goEditing];
        end;
    end
  else if Col = Ord(tdmMaxSteps) then
    begin
      sgMT3DTime.Options := sgMT3DTime.Options + [goEditing];
    end
  else if Col = Ord(tdmCalculated) then
    begin
      sgMT3DTime.Options := sgMT3DTime.Options - [goEditing];
      if sgMT3DTime.Cells[Ord(tdmCalculated),Row] = 'Yes'
      then
        begin
          sgMT3DTime.Cells[Ord(tdmCalculated),Row] := 'No';
        end
      else
        begin
          sgMT3DTime.Cells[Ord(tdmCalculated),Row] := 'Yes';
        end;
      sgMT3DTime.Invalidate;
    end;

end;

procedure TfrmMT3D.sgMT3DTimeSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inherited;
  if (ACol > 1) and (ARow > 0) then
  begin
    if not (sgMT3DTime.Cells[ACol,ARow] = '') then
    begin
      if ACol = Ord(tdmStepSize) then
        begin
          try
            begin
              StrToFloat(sgMT3DTime.Cells[ACol,ARow]) ;
            end;
          except on EConvertError do
            begin
              sgMT3DTime.Cells[ACol,ARow] := PreviousMT3DTimeText;
            end;
          end;
        end
      else if ACol = Ord(tdmMaxSteps) then
        begin
          try
            begin
              StrToInt(sgMT3DTime.Cells[ACol,ARow]) ;
            end;
          except on EConvertError do
            begin
              sgMT3DTime.Cells[ACol,ARow] := PreviousMT3DTimeText;
            end;
          end;
        end;
    end;
  end;
end;

procedure TfrmMT3D.sgMT3DTimeDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if ((Col = Ord(tdmStepSize)) or (Col = Ord(tdmLength))) and (Row > 0) then
  begin
    if (Col = Ord(tdmStepSize)) then
    begin
      if sgMT3DTime.Cells[Ord(tdmCalculated),Row] = 'Yes'
      then
      begin
        sgMT3DTime.Canvas.Brush.Color := clBtnFace;
      end
      else
      begin
        sgMT3DTime.Canvas.Brush.Color := clWindow;
      end;
    end
    else
    begin
          sgMT3DTime.Canvas.Brush.Color := clBtnFace;
    end;



    sgMT3DTime.Canvas.Font.Color := clBlack;
    // draw the text
    sgMT3DTime.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgMT3DTime.Cells[Col,Row]);
    // draw the right and lower cell boundaries in black.
    sgMT3DTime.Canvas.Pen.Color := clBlack;
    sgMT3DTime.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgMT3DTime.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgMT3DTime.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

procedure TfrmMT3D.comboMT3DAdvSolSchemeChange(Sender: TObject);
begin
  inherited;
  Case comboMT3DAdvSolScheme.ItemIndex of
    0:
      begin
        comboMT3DParticleTrackingAlg.Enabled := False;
        adeMT3DConcWeight.Enabled := False;
        adeMT3DMaxParticleCount.Enabled := False;
        adeMT3DNeglSize.Enabled := False;
        adeMT3DInitPartSmall.Enabled := False;
        adeMT3DInitPartSmall.Enabled := False;

        comboMT3DInitPartPlace.Enabled := False;
        adeMT3DParticlePlaneCount.Enabled := False;
        adeMT3DMinPartPerCell.Enabled := False;
        adeMT3DMaxPartPerCell.Enabled := False;
        adeMT3DParticleMult.Enabled := False;
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
        adeMT3DInitPartSmall.Enabled := True;

        comboMT3DInitPartPlace.Enabled := True;
        adeMT3DParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);
        adeMT3DMinPartPerCell.Enabled := True;
        adeMT3DMaxPartPerCell.Enabled := True;
        adeMT3DParticleMult.Enabled := True;
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
        adeMT3DInitPartSmall.Enabled := False;

        comboMT3DInitPartPlace.Enabled := False;
        adeMT3DParticlePlaneCount.Enabled := False;
        adeMT3DMinPartPerCell.Enabled := False;
        adeMT3DMaxPartPerCell.Enabled := False;
        adeMT3DParticleMult.Enabled := False;
        comboMT3DInitPartSinkChoice.Enabled := False;
        adeMT3DSinkParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);
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
        adeMT3DInitPartSmall.Enabled := True;

        comboMT3DInitPartPlace.Enabled := False;
        adeMT3DParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);
        adeMT3DMinPartPerCell.Enabled := False;
        adeMT3DMaxPartPerCell.Enabled := False;
        adeMT3DParticleMult.Enabled := False;
        comboMT3DInitPartSinkChoice.Enabled := False;
        adeMT3DSinkParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);
        adeMT3DSinkParticleCount.Enabled := False;
        adeMT3DCritRelConcGrad.Enabled := False;
      end;
  end;
  SetComboColor(comboMT3DParticleTrackingAlg);
  SetComboColor(comboMT3DInitPartPlace);
  SetComboColor(comboMT3DInitPartSinkChoice);
end;

procedure TfrmMT3D.comboMT3DInitPartPlaceChange(Sender: TObject);
begin
  inherited;
  adeMT3DParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);

end;

procedure TfrmMT3D.comboMT3DInitPartSinkChoiceChange(Sender: TObject);
begin
  inherited;
  adeMT3DSinkParticlePlaneCount.Enabled := (comboMT3DInitPartPlace.ItemIndex = 1);

end;

procedure TfrmMT3D.cbMT3DClick(Sender: TObject);
begin
  inherited;
//  tabMT3DBas.TabVisible := cbMT3D.Checked;
  adeMT3DHeading1.Enabled := cbMT3D.Checked;
  adeMT3DHeading2.Enabled := cbMT3D.Checked;
  adeMT3DInactive.Enabled := cbMT3D.Checked;
  edMT3DLength.Enabled := cbMT3D.Checked;
  edMT3DMass.Enabled := cbMT3D.Checked;
  cbADV.Enabled := cbMT3D.Checked;
  cbDSP.Enabled := cbMT3D.Checked;
  cbSSM.Enabled := cbMT3D.Checked;
  cbRCT.Enabled := cbMT3D.Checked;
  sgMT3DTime.Enabled := cbMT3D.Checked;


  tabMT3DOut.TabVisible := cbMT3D.Checked;
  cbADVClick(Sender);
  cbDSPClick(Sender);
  cbRCTClick(Sender);
  StreamWarning;
  FhbWarning;
  LakeWarning;
  SeepageWarning;

  // layers
  MFLayerStructure.UnIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DDomOutlineLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DInactiveAreaLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPorosityLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DObservationsLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointConstantConcLayerType, cbMT3D.Checked
     and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaConstantConcLayerType, cbMT3D.Checked
     and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointTimeVaryConcLayerType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointInitConcLayerType, cbMT3D.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaInitConcLayerType, cbMT3D.Checked);

  // parameters
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DPorosityParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DICBUNDParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMFActiveCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DActiveCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DInitConcCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DObsLocCellParamClassType, cbMT3D.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DLongDispCellParamClassType, cbMT3D.Checked);


  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetRechargeLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRCH.Checked and cbSSM.Checked);



  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointDrainLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbDRN.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineDrainLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbDRN.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaDrainLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbDRN.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbGHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbGHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbGHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRIV.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRIV.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRIV.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbWEL.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked);



  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetHydraulicCondLayerType,
     ModflowTypes.GetMT3DLongDispParamClassType, cbMT3D.Checked);

end;

procedure TfrmMT3D.cbADVClick(Sender: TObject);
begin
  inherited;
  tabMT3DAdv1.TabVisible := cbMT3D.Checked and cbADV.Checked;
  tabMT3DAdv2.TabVisible := cbMT3D.Checked and cbADV.Checked;

end;

procedure TfrmMT3D.cbDSPClick(Sender: TObject);
begin
  inherited;
  tabMT3DDisp.TabVisible := cbMT3D.Checked
    and cbDSP.Checked;

end;

procedure TfrmMT3D.cbRCHClick(Sender: TObject);
begin
  inherited;
  EnableSSM;
end;

procedure TfrmMT3D.cbRIVClick(Sender: TObject);
begin
  inherited;
  EnableSSM;
  StreamWarning;

end;

procedure TfrmMT3D.cbWELClick(Sender: TObject);
begin
  inherited;
  EnableSSM;

end;

procedure TfrmMT3D.cbDRNClick(Sender: TObject);
begin
  inherited;
  EnableSSM;

end;

procedure TfrmMT3D.cbGHBClick(Sender: TObject);
begin
  inherited;
  EnableSSM;

end;

procedure TfrmMT3D.cbEVTClick(Sender: TObject);
begin
  inherited;
  EnableSSM;

end;

procedure TfrmMT3D.comboResultsPrintedChange(Sender: TObject);
begin
  inherited;
  adeResultsPrintedN.Enabled := (comboResultsPrinted.ItemIndex = 1);
  sgPrintoutTimes.Enabled := (comboResultsPrinted.ItemIndex = 2);
  if sgPrintoutTimes.Enabled
  then
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

procedure TfrmMT3D.cbPrintConcClick(Sender: TObject);
begin
  inherited;
  comboConcentrationFormat.Enabled := cbPrintConc.Checked;
  SetComboColor(comboConcentrationFormat);
end;

procedure TfrmMT3D.cbPrintRetardationClick(Sender: TObject);
begin
  inherited;
  comboRetardationFormat.Enabled := cbPrintRetardation.Checked;
  SetComboColor(comboRetardationFormat);

end;

procedure TfrmMT3D.cbPrintDispCoefClick(Sender: TObject);
begin
  inherited;
  comboDispersionFormat.Enabled := cbPrintDispCoef.Checked;
  SetComboColor(comboDispersionFormat);

end;

procedure TfrmMT3D.cbPrintNumParticlesClick(Sender: TObject);
begin
  inherited;
  comboParticlePrintFormat.Enabled := cbPrintNumParticles.Checked;
  SetComboColor(comboParticlePrintFormat);

end;

procedure TfrmMT3D.sgTimeSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
  inherited;
  if Ord(tdLength) = ACol then
  begin
    sgMT3DTime.Cells[ACol, ARow] := sgTime.Cells[Ord(tdmLength), ARow];
  end;
end;

procedure TfrmMT3D.btnAddTimeClick(Sender: TObject);
begin
  inherited;
//  edNumPerExit(edNumPer);
end;

procedure TfrmMT3D.edNumUnitsExit(Sender: TObject);
var
  NewNumUnits : Integer;
  RowIndex, ColIndex : integer;
begin
{  if Sender = edNumUnits then
  begin  }
    inherited;
//  end;
  NewNumUnits := StrToInt(edNumUnits.Text);
  If NewNumUnits > PrevNumUnits
  then
    begin
      sgReaction.RowCount := NewNumUnits + 1;
      For RowIndex := PrevNumUnits + 1 to sgReaction.RowCount -1 do
      begin
        sgReaction.Cells[Ord(rdmN),RowIndex] := IntToStr(RowIndex);
        sgReaction.Cells[Ord(rdmName),RowIndex] := dgGeol.Cells[Ord(nuiName),RowIndex];
        For ColIndex := 2 to sgReaction.ColCount -1 do
        begin
          sgReaction.Cells[ColIndex,RowIndex]
            := sgReaction.Cells[ColIndex,RowIndex-1];
        end;
      end;

      sgDispersion.RowCount := NewNumUnits + 1;
      For RowIndex := PrevNumUnits + 1 to sgDispersion.RowCount -1 do
      begin
        sgDispersion.Cells[Ord(ddmN),RowIndex] := IntToStr(RowIndex);
        sgDispersion.Cells[Ord(ddmName),RowIndex] := dgGeol.Cells[Ord(nuiName),RowIndex];
        For ColIndex := 2 to sgReaction.ColCount -1 do
        begin
          sgDispersion.Cells[ColIndex,RowIndex]
            := sgDispersion.Cells[ColIndex,RowIndex-1];
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


end;

procedure TfrmMT3D.btnDeleteUnitClick(Sender: TObject);
Var
  CurrrentRow : integer;
  RowIndex, ColIndex : integer;
begin
  edNumUnitsEnter(Sender);
  inherited;
  edNumUnitsExit(Sender);
  CurrrentRow := dgGeol.Selection.Top;

  for RowIndex := CurrrentRow +1 to sgReaction.RowCount -1 do
  begin
    For ColIndex := 1 to sgReaction.ColCount -1 do
    begin
      sgReaction.Cells[ColIndex,RowIndex-1] := sgReaction.Cells[ColIndex,RowIndex];
    end;
  end;
  sgReaction.RowCount := sgReaction.RowCount -1;

  for RowIndex := CurrrentRow +1 to sgDispersion.RowCount -1 do
  begin
    For ColIndex := 1 to sgDispersion.ColCount -1 do
    begin
      sgDispersion.Cells[ColIndex,RowIndex-1] := sgDispersion.Cells[ColIndex,RowIndex];
    end;
  end;
  sgDispersion.RowCount := sgDispersion.RowCount -1;
//        sgReaction.RowCount := NewNumUnits + 1;
//        sgDispersion.RowCount := NewNumUnits + 1;

end;

procedure TfrmMT3D.btnInsertUnitClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
begin
  inherited;
  edNumUnitsExit(Sender);
  CurrentRow := dgGeol.Selection.Top;

  for RowIndex := sgReaction.RowCount -2 downto CurrentRow do
  begin
    sgReaction.Cells[0,RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgReaction.ColCount -1 do
    begin
      sgReaction.Cells[ColIndex,RowIndex +1] := sgReaction.Cells[ColIndex,RowIndex];
    end;
  end;

  for RowIndex := sgDispersion.RowCount -2 downto CurrentRow do
  begin
    sgDispersion.Cells[0,RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgDispersion.ColCount -1 do
    begin
      sgDispersion.Cells[ColIndex,RowIndex +1] := sgDispersion.Cells[ColIndex,RowIndex];
    end;
  end;

end;

procedure TfrmMT3D.btnAddUnitClick(Sender: TObject);
begin
  inherited;
//  edNumUnitsExit(Sender);
end;

procedure TfrmMT3D.dgGeolSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
  inherited;
  if Ord(nuiName) = ACol then
  begin
    sgReaction.Cells[Ord(rdmName), ARow] := dgGeol.Cells[Ord(nuiName), ARow];
    sgDispersion.Cells[Ord(ddmName), ARow] := dgGeol.Cells[Ord(nuiName), ARow];
  end;
end;

procedure TfrmMT3D.sgReactionSelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
begin
  inherited;
  if Col = Ord(rdmName) then
  begin
    CanSelect := False;
  end;
  PreviousMT3DChemText := sgReaction.Cells[Col, Row];
{
type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);
}
  if (Col = Ord(rdmBulkDensity)) or (Col = Ord(rdmSorpConst1)) then
    begin
      if comboMT3DIsotherm.ItemIndex > 0
      then
        begin
          sgReaction.Options := sgReaction.Options + [goEditing];
        end
      else
        begin
          sgReaction.Options := sgReaction.Options - [goEditing];
        end;

    end
  else if Col = Ord(rdmSorpConst2) then
    begin
      if comboMT3DIsotherm.ItemIndex > 1
      then
        begin
          sgReaction.Options := sgReaction.Options + [goEditing];
        end
      else
        begin
          sgReaction.Options := sgReaction.Options - [goEditing];
        end;

    end
  else if (Col = Ord(rdmRateConstDiss)) or (Col = Ord(rdmRateConstSorp)) then
    begin
      if comboMT3DIREACT.ItemIndex > 0
      then
        begin
          sgReaction.Options := sgReaction.Options + [goEditing];
        end
      else
        begin
          sgReaction.Options := sgReaction.Options - [goEditing];
        end;

    end;

end;

procedure TfrmMT3D.sgReactionDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if (Row > sgReaction.FixedRows-1) and (Col > sgReaction.FixedCols -1) then
  begin
      if (Col = Ord(rdmBulkDensity)) or (Col = Ord(rdmSorpConst1)) then
        begin
          if comboMT3DIsotherm.ItemIndex > 0
          then
            begin
              sgReaction.Canvas.Brush.Color := clWindow;
            end
          else
            begin
              sgReaction.Canvas.Brush.Color := clBtnFace;
            end;

        end
      else if Col = Ord(rdmSorpConst2) then
        begin
          if comboMT3DIsotherm.ItemIndex > 1
          then
            begin
              sgReaction.Canvas.Brush.Color := clWindow;
            end
          else
            begin
              sgReaction.Canvas.Brush.Color := clBtnFace;
            end;

        end
      else if (Col = Ord(rdmRateConstDiss)) or (Col = Ord(rdmRateConstSorp)) then
        begin
          if comboMT3DIREACT.ItemIndex > 0
          then
            begin
              sgReaction.Canvas.Brush.Color := clWindow;
            end
          else
            begin
              sgReaction.Canvas.Brush.Color := clBtnFace;
            end;

        end;


    sgReaction.Canvas.Font.Color := clBlack;
    // draw the text
    sgReaction.Canvas.TextRect(Rect,Rect.Left,Rect.Top,sgReaction.Cells[Col,Row]);
    // draw the right and lower cell boundaries in black.
    sgReaction.Canvas.Pen.Color := clBlack;
    sgReaction.Canvas.MoveTo(Rect.Right,Rect.Top);
    sgReaction.Canvas.LineTo(Rect.Right,Rect.Bottom);
    sgReaction.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end
end;

procedure TfrmMT3D.comboMT3DIsothermChange(Sender: TObject);
begin
  inherited;
  sgReaction.Invalidate;
end;

procedure TfrmMT3D.comboMT3DIREACTChange(Sender: TObject);
begin
  inherited;
  sgReaction.Invalidate;

end;

procedure TfrmMT3D.cbRCTClick(Sender: TObject);
begin
  inherited;
  tabMT3DChem.TabVisible := cbMT3D.Checked
    and cbRCT.Checked;

end;

procedure TfrmMT3D.sgReactionSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inherited;
  if (ACol > 1) and (ARow > 0) then
  begin
    if not (sgReaction.Cells[ACol,ARow] = '') then
    begin
      try
        begin
          StrToFloat(sgReaction.Cells[ACol,ARow]) ;
        end;
      except on EConvertError do
        begin
            sgReaction.Cells[ACol,ARow] := PreviousMT3DChemText;
        end;
      end;
    end;
  end;

end;

procedure TfrmMT3D.sgReactionExit(Sender: TObject);
var
  RowIndex, ColIndex : integer;
begin
  inherited;
  For RowIndex := sgReaction.FixedRows to sgReaction.RowCount -1 do
  begin
    For ColIndex := Ord(rdmBulkDensity) to sgReaction.ColCount -1 do
    begin
      if sgReaction.Cells[ColIndex,RowIndex] = '' then
      begin
        sgReaction.Cells[ColIndex,RowIndex] := '0';
      end;
    end;
  end;
end;

procedure TfrmMT3D.sgMT3DTimeExit(Sender: TObject);
var
  RowIndex, ColIndex : integer;
begin
  inherited;
  For RowIndex := sgMT3DTime.FixedRows to sgMT3DTime.RowCount -1 do
  begin
    For ColIndex := sgMT3DTime.FixedCols to sgMT3DTime.ColCount -1 do
    begin
      if sgMT3DTime.Cells[ColIndex,RowIndex] = '' then
      begin
        sgMT3DTime.Cells[ColIndex,RowIndex] := '0';
      end;
    end;
  end;

end;

procedure TfrmMT3D.sgDispersionSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  inherited;
  if Col = Ord(ddmName) then
  begin
    CanSelect := False;
  end;
  PreviousMT3DDispText := sgDispersion.Cells[Col, Row];
end;

procedure TfrmMT3D.sgDispersionSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inherited;
    if (ACol > 1) and (ARow > 0) then
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
    end;

end;

procedure TfrmMT3D.btmAddMT3DPrintTimeClick(Sender: TObject);
begin
  inherited;
  sgPrintoutTimes.RowCount := sgPrintoutTimes.RowCount +1;
  sgPrintoutTimes.Cells[Ord(ptmN), sgPrintoutTimes.RowCount-1]
    := IntToStr(sgPrintoutTimes.RowCount-1);
  sgPrintoutTimes.Cells[Ord(ptmTime), sgPrintoutTimes.RowCount-1]
    := sgPrintoutTimes.Cells[1, sgPrintoutTimes.RowCount-2];
  btmDeleteMT3DPrintTime.Enabled
    := sgPrintoutTimes.Enabled and (sgPrintoutTimes.RowCount > 2);
end;

procedure TfrmMT3D.btmInsertMT3DPrintTimeClick(Sender: TObject);
var
  CurrentRow : Integer;
  RowIndex, ColIndex : integer;
begin
  inherited;
  btmAddMT3DPrintTimeClick(Sender);
  CurrentRow := sgPrintoutTimes.Selection.Top;

  for RowIndex := sgReaction.RowCount -2 downto CurrentRow do
  begin
    sgPrintoutTimes.Cells[Ord(ptmN),RowIndex] := IntToStr(RowIndex);
    for ColIndex := 1 to sgPrintoutTimes.ColCount -1 do
    begin
      sgPrintoutTimes.Cells[ColIndex,RowIndex +1] := sgPrintoutTimes.Cells[ColIndex,RowIndex];
    end;
  end;

end;

procedure TfrmMT3D.btmDeleteMT3DPrintTimeClick(Sender: TObject);
var
  CurrentRow : Integer;
  RowIndex, ColIndex : integer;
begin
  inherited;
  CurrentRow := sgPrintoutTimes.Selection.Top;

  for RowIndex := CurrentRow +1 to sgPrintoutTimes.RowCount -1 do
  begin
    For ColIndex := 1 to sgPrintoutTimes.ColCount -1 do
    begin
      sgPrintoutTimes.Cells[ColIndex,RowIndex-1] := sgPrintoutTimes.Cells[ColIndex,RowIndex];
    end;
  end;
  sgPrintoutTimes.RowCount := sgPrintoutTimes.RowCount -1;
  btmDeleteMT3DPrintTime.Enabled
    := sgPrintoutTimes.Enabled and (sgPrintoutTimes.RowCount > 2);

end;

procedure TfrmMT3D.sgPrintoutTimesSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  inherited;
  PreviousMT3DPrintoutTimeText := sgPrintoutTimes.Cells[Col, Row];

end;

procedure TfrmMT3D.sgPrintoutTimesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inherited;
  if (ACol > 0) and (ARow > 0) then
  begin
    if not (sgPrintoutTimes.Cells[ACol,ARow] = '') then
    begin
      try
        begin
          StrToFloat(sgPrintoutTimes.Cells[ACol,ARow]) ;
        end;
      except on EConvertError do
        begin
            sgPrintoutTimes.Cells[ACol,ARow] := PreviousMT3DPrintoutTimeText;
        end;
      end;
    end;
  end;

end;

procedure TfrmMT3D.sgDispersionExit(Sender: TObject);
var
  RowIndex, ColIndex : integer;
begin
  inherited;
  For RowIndex := sgDispersion.FixedRows to sgDispersion.RowCount -1 do
  begin
    For ColIndex := Ord(ddmHorDisp) to sgDispersion.ColCount -1 do
    begin
      if sgDispersion.Cells[ColIndex,RowIndex] = '' then
      begin
        sgDispersion.Cells[ColIndex,RowIndex] := '0';
      end;
    end;
  end;

end;

procedure TfrmMT3D.sgPrintoutTimesExit(Sender: TObject);
var
  RowIndex, ColIndex, RowIndex2 : integer;
  TempString : string;
begin
  inherited;
  For RowIndex := sgPrintoutTimes.FixedRows to sgPrintoutTimes.RowCount -1 do
  begin
    For ColIndex := sgPrintoutTimes.FixedCols to sgPrintoutTimes.ColCount -1 do
    begin
      if sgPrintoutTimes.Cells[ColIndex,RowIndex] = '' then
      begin
        sgPrintoutTimes.Cells[ColIndex,RowIndex] := '0';
      end;
    end;
  end;
  for RowIndex := sgPrintoutTimes.FixedRows to sgPrintoutTimes.RowCount -2 do
  begin
    for RowIndex2 := RowIndex +1 to sgPrintoutTimes.RowCount -1 do
    begin
      if StrToFloat(sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex]) >
         StrToFloat(sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex2]) then
      begin
        TempString := sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex];
        sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex]
          := sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex2];
        sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex2] := TempString;
      end;
    end


  end;

end;

procedure TfrmMT3D.cbLAKClick(Sender: TObject);
begin
  inherited;
  comboLAKSteady.Enabled := cbLAK.Checked;
  SetComboColor(comboLAKSteady);
  LakeWarning;
  
  adeMaxLakeStreams.Enabled := cbLAK.Checked and cbSTR.Checked;
  if not adeMaxLakeStreams.Enabled then
  begin
    adeMaxLakeStreamsEnter(Sender);
    adeMaxLakeStreams.Text := '0';
    adeMaxLakeStreamsExit(Sender);
  end;
  adeLakeNumSubSteps.Enabled := cbLAK.Checked;
  adeMaxLakEquations.Enabled := cbLAK.Checked and (StrToInt(adeMaxLakeStreams.Text)>0);
  cbExpLakFlow.Enabled := cbLAK.Checked;

  comboLakeBottomCond.Enabled := cbLAK.Checked;
  SetComboColor(comboLakeBottomCond);

  comboLakeSideCond.Enabled := cbLAK.Checked;
  SetComboColor(comboLakeSideCond);

  cbPrintLake.Enabled := cbLAK.Checked;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLakeLayerType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakeParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakeToRightParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakeToLeftParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakeToNorthParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakeToSouthParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakeAboveParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakebedBottomParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakebedTopParamClassType, cbLAK.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMT3DLakebedKzParamClassType, cbLAK.Checked);



end;

procedure TfrmMT3D.adeMaxLakeStreamsEnter(Sender: TObject);
begin
  inherited;
  PreviousLakeStreamsText := adeMaxLakeStreams.Text;

end;

procedure TfrmMT3D.adeMaxLakeStreamsExit(Sender: TObject);
var
  NumStreams, OldNumStreams: Integer;
  StreamIndex : integer;
  ALakeLayer : T_ANE_InfoLayer;
  UnitIndex : integer;
  AGeologicUnit : TMT3DGeologicUnit;
  AParamList : T_ANE_ParameterList;
//  NumUnits : integer;
begin
  inherited;
  NumStreams := StrToInt(adeMaxLakeStreams.Text);
  OldNumStreams := StrToInt(PreviousLakeStreamsText);
  if NumStreams > OldNumStreams
  then
    begin
      for StreamIndex := OldNumStreams to NumStreams -1 do
      begin
        if cbLAK.Checked then
        begin
          MFLayerStructure.ListsOfIndexedLayers.MakeIndexedList1(
            ModflowTypes.GetMFLakeLayerType, ModflowTypes.GetMFLakeStreamParamListType, StreamIndex);
        end;
      end;
    end
  else
    begin
      for UnitIndex := 0 to MFLayerStructure.ListsOfIndexedLayers.Count -1 do
      begin
        AGeologicUnit := MFLayerStructure.ListsOfIndexedLayers.Items[UnitIndex]
          as TMT3DGeologicUnit;
        ALakeLayer := AGeologicUnit.
          GetLayerByName(ModflowTypes.GetMFLakeLayerType.ANE_LayerName) as T_ANE_InfoLayer;
        if not (ALakeLayer = nil) then
        begin
          for StreamIndex := OldNumStreams -1 downto NumStreams do
          begin
            AParamList := ALakeLayer.IndexedParamList1.
              GetNonDeletedIndParameterListByIndex(StreamIndex);
            if not (AParamList = nil) then
            begin
              AParamList.DeleteSelf;
            end;
          end;
        end;
      end;
    end;

end;

procedure TfrmMT3D.adeMaxLakeStreamsChange(Sender: TObject);
begin
  inherited;
  adeMaxLakEquations.Enabled := cbLAK.Checked and (StrToInt(adeMaxLakeStreams.Text)>0);

end;

procedure TfrmMT3D.adeMaxLakEquationsExit(Sender: TObject);
var
  numEquations : integer;
begin
  inherited;
  if StrToInt(adeMaxLakeStreams.Text) > 0 then
  begin
    numEquations := StrToInt(adeMaxLakEquations.Text);

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCutOff1Param, cbLAK.Checked and (numEquations > 0));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCutOff2Param, cbLAK.Checked and (numEquations > 1));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCutOff3Param, cbLAK.Checked and (numEquations > 2));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCutOff4Param, cbLAK.Checked and (numEquations > 3));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCutOff5Param, cbLAK.Checked and (numEquations > 4));


    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCnst1Param, cbLAK.Checked and (numEquations > 0));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCnst2Param, cbLAK.Checked and (numEquations > 1));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCnst3Param, cbLAK.Checked and (numEquations > 2));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCnst4Param, cbLAK.Checked and (numEquations > 3));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeCnst5Param, cbLAK.Checked and (numEquations > 4));


    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqElev1Param, cbLAK.Checked and (numEquations > 0));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqElev2Param, cbLAK.Checked and (numEquations > 1));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqElev3Param, cbLAK.Checked and (numEquations > 2));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqElev4Param, cbLAK.Checked and (numEquations > 3));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqElev5Param, cbLAK.Checked and (numEquations > 4));


    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqExp1Param, cbLAK.Checked and (numEquations > 0));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqExp2Param, cbLAK.Checked and (numEquations > 1));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqExp3Param, cbLAK.Checked and (numEquations > 2));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqExp4Param, cbLAK.Checked and (numEquations > 3));

    MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter1
      (ModflowTypes.GetMFLakeLayerType, TLakeEqExp5Param, cbLAK.Checked and (numEquations > 4));

  end;

end;

procedure TfrmMT3D.cbRBWSTRClick(Sender: TObject);
begin
  inherited;
{  adeMaxLakeStreams.Enabled := cbLAK.Checked and cbRBWSTR.Checked;
  cbRBWUseTributaries.Enabled := cbRBWSTR.Checked;
  cbRBWUseDiversions.Enabled := cbRBWSTR.Checked;
  cbRBWCalculateStage.Enabled := cbRBWSTR.Checked;
  comboRBWSTRSteady.Enabled := cbRBWSTR.Checked;
  comboRBWStreamModelLength.Enabled := cbRBWSTR.Checked;
  cbExpStrFlow.Enabled := cbRBWSTR.Checked;
  
{  if not adeMaxLakeStreams.Enabled then
  begin
    adeMaxLakeStreamsEnter(Sender);
    adeMaxLakeStreams.Text := '0';
    adeMaxLakeStreamsExit(Sender);
  end;  }

{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFRBWStreamLayerType, cbRBWSTR.Checked);  }

end;

procedure TfrmMT3D.cbRBWUseTributariesClick(Sender: TObject);
begin
  inherited;
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFRBWStreamLayerType, TRBWStreamDownstreamSegmentParam,
      cbRBWSTR.Checked and cbRBWUseTributaries.Checked);  }

end;

procedure TfrmMT3D.cbRBWUseDiversionsClick(Sender: TObject);
begin
  inherited;
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (ModflowTypes.GetMFRBWStreamLayerType, TRBWStreamDiversionSegmentParam,
      cbRBWSTR.Checked and cbRBWUseDiversions.Checked);   }

end;

procedure TfrmMT3D.cbRBWCalculateStageClick(Sender: TObject);
begin
  inherited;
{  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFRBWStreamLayerType, TRBWStreamSlopeParam,
     cbRBWSTR.Checked and cbRBWCalculateStage.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFRBWStreamLayerType, TRBWStreamRoughParam,
     cbRBWSTR.Checked and cbRBWCalculateStage.Checked);

  if cbRBWCalculateStage.Checked and (comboTimeUnits.ItemIndex = 0) then
  begin
    comboTimeUnits.ItemIndex := 1;
  end;      }
end;

function TfrmMT3D.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
Var
  HelpFileName : string;
begin
  if Data >= 15000
  then
    begin
      HelpFileName := 'Lake.hlp';
      AssignHelpFile(HelpFileName);
      result := True;
    end
  else
    begin
      HelpFileName := 'Modflow.hlp';
      AssignHelpFile(HelpFileName);
      result := inherited FormHelp(Command, Data, CallHelp);
    end;

end;

procedure TfrmMT3D.comboTimeUnitsChange(Sender: TObject);
begin
  inherited;
  if cbStreamCalcFlow.Checked and (comboTimeUnits.ItemIndex = 0) then
  begin
    ShowMessage('You must specify a time unit if stream stage will be calculated.');
  end;

end;

procedure TfrmMT3D.pageControlMainChange(Sender: TObject);
begin
  inherited;
  if (pageControlMain.ActivePage = tabStrLake)
    or (pageControlMain.ActivePage = tabMT3DBas)
    or (pageControlMain.ActivePage = tabMT3DAdv1)
    or (pageControlMain.ActivePage = tabMT3DAdv2)
    or (pageControlMain.ActivePage = tabMT3DDisp)
    or (pageControlMain.ActivePage = tabMT3DChem)
    or (pageControlMain.ActivePage = tabMT3DOut) then
  begin
    AssignHelpFile('Lake.hlp');
  end;
end;

procedure TfrmMT3D.ReadOldStream(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadCheckBox( LineIndex,FirstList, IgnoreList, cbSTR, DataToRead,VersionControl);
end;

procedure TfrmMT3D.ReadOldStreamDiv(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadCheckBox( LineIndex,FirstList, IgnoreList, cbStreamDiversions, DataToRead,VersionControl);
end;

procedure TfrmMT3D.ReadOldStreamICALC(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadCheckBox( LineIndex,FirstList, IgnoreList, cbStreamCalcFlow, DataToRead,VersionControl);
end;

procedure TfrmMT3D.ReadOldStreamModelUnits(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadComboBox( LineIndex,FirstList, IgnoreList, comboModelUnits, DataToRead,VersionControl);
end;

procedure TfrmMT3D.ReadOldStreamSteady(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadComboBox( LineIndex,FirstList, IgnoreList, comboStreamOption, DataToRead,VersionControl);
end;

procedure TfrmMT3D.ReadOldStreamTrib(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadCheckBox( LineIndex,FirstList, IgnoreList, cbStreamTrib, DataToRead,VersionControl);
end;

procedure TfrmMT3D.ReadOldStreamPrint(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadCheckBox( LineIndex,FirstList, IgnoreList, cbStrPrintFlows, DataToRead,VersionControl);
end;

procedure TfrmMT3D.cbSTRClick(Sender: TObject);
begin
  inherited;
  EnableSSM;
  adeMaxLakeStreams.Enabled := cbLAK.Checked and cbSTR.Checked;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbSTR.Checked);

  StreamWarning;
end;

procedure TfrmMT3D.StreamWarning;
begin
  inherited;
  if cbSTR.Checked and cbRIV.Checked and cbMT3D.Checked then
  begin
    Beep;
    MessageDlg('The current version of MT3D does not allow you to '
      + 'use the River and Stream packages in the same model. '
      + 'You should fix this before trying to run MT3D.', mtWarning,
      [mbOK], 0);
  end;
end;


procedure TfrmMT3D.ReadOldLakeGeoData(var LineIndex : integer; FirstList, IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl);
begin
  ReadStringGrid( LineIndex,FirstList, IgnoreList, dgGeol, DataToRead,VersionControl)
end;

procedure TfrmMT3D.btnOKClick(Sender: TObject);
begin
  inherited;
  StreamWarning;

end;



procedure TfrmMT3D.cbSPGClick(Sender: TObject);
begin
  inherited;
  SeepageWarning;
  // enable or disable other controls depending on whether drains are active.
  comboSpgSteady.Enabled := cbSPG.Checked;   // steady stress
  SetComboColor(comboSpgSteady);

  cbSPGRetain.Enabled := cbSPG.Checked;
  cbAltSpg.Enabled := cbSPG.Checked;

  // cell-by-cell flows related to seepage
  cbFlowSpg.Enabled := cbSPG.Checked;

  // add or remove seepage layers
  // depending on whether seepage is selected.
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFLineSeepageLayerType, cbSPG.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMFAreaSeepageLayerType, cbSPG.Checked);

  // add or remove grid seepage parameter from the grid layer
  // depending on whether seepage is selected.
  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridSeepageParamClassType,
     cbSPG.Checked);

  // associates lists of time-related parameters with sgTime grid.
  AssociateTimes;

end;

procedure TfrmMT3D.cbAltSpgClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow
    (ModflowTypes.GetGridLayerType, ModflowTypes.GetGridSeepageParamClassType,
     ModflowTypes.GetGridSeepageParamClassType.ANE_ParamName, True);

end;

procedure TfrmMT3D.cbSSMClick(Sender: TObject);
begin
  inherited;
  cbMT3D_TVC.Enabled := cbSSM.Checked;

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointConstantConcLayerType, cbMT3D.Checked
     and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaConstantConcLayerType, cbMT3D.Checked
     and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointTimeVaryConcLayerType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetETLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbEVT.Checked and cbSSM.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetRechargeLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRCH.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointDrainLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbDRN.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineDrainLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbDRN.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaDrainLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbDRN.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPointGHBLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbGHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetLineGHBLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbGHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetAreaGHBLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbGHB.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFPointRiverLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRIV.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFLineRiverLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRIV.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFAreaRiverLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbRIV.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFWellLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbWEL.Checked and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetPrescribedHeadLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType, cbMT3D.Checked
     and cbSSM.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (ModflowTypes.GetMFStreamLayerType,
     ModflowTypes.GetMT3DConcentrationParamClassType,
     cbMT3D.Checked and cbSTR.Checked and cbSSM.Checked);


end;

procedure TfrmMT3D.FhbWarning;
begin
  if cbFHB.Checked and cbMT3D.Checked then
  begin
    Beep;
    MessageDlg('The current version of MT3D is incompatible with the '
      + 'Flow and Head Boundary Package.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMT3D.cbFHBClick(Sender: TObject);
begin
  inherited;
  FhbWarning;
end;

procedure TfrmMT3D.LakeWarning;
begin
  if cbLAK.Checked and cbMT3D.Checked then
  begin
    Beep;
    MessageDlg('The current version of MT3D is incompatible with the '
      + 'Lake Package.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMT3D.SeepageWarning;
begin
  if cbLAK.Checked and cbMT3D.Checked then
  begin
    Beep;
    MessageDlg('The current version of MT3D is incompatible with the '
      + 'Seepage Package.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMT3D.cbMT3D_TVCClick(Sender: TObject);
begin
  inherited;
  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DPointTimeVaryConcLayerType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer
    (ModflowTypes.GetMT3DAreaTimeVaryConcLayerType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter1
    (ModflowTypes.GetGridLayerType,
     ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType, cbMT3D.Checked
     and cbSSM.Checked and cbMT3D_TVC.Checked);

  MFLayerStructure.UnIndexedLayers.SetIndexed1ExpressionNow(
    ModflowTypes.GetGridLayerType, ModflowTypes.GetGridMFActiveCellParamClassType,
    ModflowTypes.GetGridMFActiveCellParamClassType.ANE_ParamName, True);

end;

procedure TfrmMT3D.ModelComponentName(AStringList : TStringList);
begin
  inherited;
  AStringList.Add(adeMT3DPath.Name);
end;


{procedure TfrmMT3D.ModelPaths(var AStringList : TStringList);
var
  IgnoreList : TStringList;
  Index : integer;
  Name : string;
begin
//  inherited;
  // create a string list that can be used to set the model paths
  // in an .ini file
  IgnoreList := TStringList.Create;
  try
    for Index := 0 to ComponentCount-1 do
    begin
      Name := Components[Index].Name;
      if (Name <> adeMODFLOWPath.Name) and
         (Name <> adeMOC3DPath.Name) and
         (Name <> adeZonebudgetPath.Name) and
         (Name <> adeMODPATHPath.Name) and
         (Name <> adeMT3DPath.Name)
         then
      begin
        IgnoreList.Add(Name);
      end;
    end;
    AStringList.Text := FormToString(lblVersion, IgnoreList, rsDeveloper);
  finally
    IgnoreList.Free;
  end;

end; }

end.
