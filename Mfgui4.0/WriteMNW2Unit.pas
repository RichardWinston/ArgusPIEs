{@name is used to create the input files for the MNW version 2 package.

@Seealso(WriteMultiNodeWellUnit)}
unit WriteMNW2Unit;

interface

uses Sysutils, Forms, Classes, contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization;

type
  TSteadyMnw2SteadyParameterIndicies = record
    WellIdIndex: ANE_INT16;
    ConstrainPumpingIndex: ANE_INT16;
    PartialPenetrationFlagIndex: ANE_INT16;
    SpecifyPumpIndex: ANE_INT16;
    PumpElevationIndex: ANE_INT16;
    LimitingWaterLevelIndex: ANE_INT16;
    PumpingLimitTypeIndex: ANE_INT16;
    InactivationPumpingIndex: ANE_INT16;
    ReactivationPumpingIndex: ANE_INT16;
    LossTypeIndex: ANE_INT16;
    WellRadiusIndex: ANE_INT16;
    SkinRadiusIndex: ANE_INT16;
    SkinKIndex: ANE_INT16;
    BIndex: ANE_INT16;
    CIndex: ANE_INT16;
    PIndex: ANE_INT16;
    CellToWellConductanceIndex: ANE_INT16;
    PumpTypeIndex: ANE_INT16;
    DischargeElevationIndex: ANE_INT16;
    MonitorWellIndex: ANE_INT16;
    MonitorExternalFlowsIndex: ANE_INT16;
    MonitorInternalFlowsIndex: ANE_INT16;
    MonitorConcentrationsIndex: ANE_INT16;
  end;

  TVertWellSteadyParameterIndicies = record
    NodeCountIndex: ANE_INT16;
  end;

  TGeneralSteadyParameterIndicies = record
    OrderIndex: ANE_INT16;
    UpperElevIndex: ANE_INT16;
    LowerElevIndex: ANE_INT16;
  end;

  TWellScreenIndicies = record
    TopWellScreenIndex: ANE_INT16;
    BottomWellScreenIndex: ANE_INT16;
  end;

  TMnwTimeIndicies = record
    ActiveIndex: ANE_INT16;
    PumpingRateIndex: ANE_INT16;
    HeadCapacityMultiplierIndex: ANE_INT16;
    LimitingWaterLevelIndex: ANE_INT16;
    PumpingLimitTypeIndex: ANE_INT16;
    InactivationPumpingRateIndex: ANE_INT16;
    ReactivationPumpingRateIndex: ANE_INT16;
    ConcentrationIndex: ANE_INT16;
    IfaceIndex: ANE_INT16;
  end;

  TMnwTimeIndexArray = array of TMnwTimeIndicies;

  TLossType = (ltNone, ltThiem, ltSkin, ltGeneral, ltSpecifyCwc);

  TPumpLimits = record
// Hlim
    LimitingWaterLevel: ANE_DOUBLE;
    // QCUT
    PumpingLimitType: ANE_INT32;
    // Qfrcmn
    InactivationPumpingRate: ANE_DOUBLE;
    // Qfrcmx
    ReactivationPumpingRate: ANE_DOUBLE;
  end;

  TSteadyMnw2SteadyValues = record
    WellId: string;
    // Qlimit
    ConstrainPumping: ANE_BOOL;
    // PPFLAG
    PartialPenetrationFlag: ANE_BOOL;
    // PUMPLOC
    SpecifyPump: ANE_BOOL;
    // Zpump
    PumpElevation: ANE_DOUBLE;
    PumpLimits: TPumpLimits;
    // Hlim
//    LimitingWaterLevel: ANE_DOUBLE;
    // QCUT
//    PumpingLimitType: ANE_INT32;
    // Qfrcmn
//    InactivationPumpingRate: ANE_DOUBLE;
    // Qfrcmx
//    ReactivationPumpingRate: ANE_DOUBLE;
    // LOSSTYPE
    LossType: TLossType;
    WellRadius: ANE_DOUBLE;
    // Rskin
    SkinRadius: ANE_DOUBLE;
    // Kskin
    SkinK: ANE_DOUBLE;
    B: ANE_DOUBLE;
    C: ANE_DOUBLE;
    P: ANE_DOUBLE;
    // CWC
    CellToWellConductance: ANE_DOUBLE;
    // PUMPCAP
    PumpType: string;
    PUMPCAP: integer;
    // Hlift
    DischargeElevation: ANE_DOUBLE;
    MonitorWell: ANE_BOOL;
    MonitorExternalFlows: ANE_BOOL;
    MonitorInternalFlows: ANE_BOOL;
    MonitorConcentrations: ANE_INT32;
  end;

  TVertWellSteadyValues = record
    NodeCount: ANE_INT32;
  end;

  TGeneralSteadyValues = record
    Order: ANE_INT32;
    UpperElev: ANE_DOUBLE;
    LowerElev: ANE_DOUBLE;
  end;

  TWellScreenValues = record
    // Ztop
    TopWellScreen: ANE_DOUBLE;
    // Zbotm
    BottomWellScreen: ANE_DOUBLE;
  end;

  TMnwTimeValues = record
    // WELLID
    Active: ANE_BOOL;
    // Qdes
    PumpingRate: ANE_DOUBLE;
    // CapMult
    HeadCapacityMultiplier: ANE_DOUBLE;
    Concentration: ANE_DOUBLE;
    IFACE: ANE_INT32;
    PumpLimits: TPumpLimits;
  end;

  TMnwTimeValuesArray = array of TMnwTimeValues;

  TVerticalMnw2Well = class(TObject)
  private
    Row: integer;
    Column: integer;
    SteadyValues: TSteadyMnw2SteadyValues;
    VertSteadyValues: TVertWellSteadyValues;
    WellScreens: array of TWellScreenValues;
    TimeValues: TMnwTimeValuesArray;
  end;

  TWellCell = class(TObject)
    Row: integer;
    Column: integer;
    Layer: integer;
  end;

  TGeneralMnw2WellSection = class(TObject)
  private
    FCells: TList;
    SteadyValues: TSteadyMnw2SteadyValues;
    GeneralSteadyValues: TGeneralSteadyValues;
    TimeValues: TMnwTimeValuesArray;
  public
    Constructor Create;
    Destructor Destroy; override;
  end;

  TGeneralMnw2Well = class(TObject)
  private
    FWellSections: TList;
    PumpCell: TWellCell;
  public
    Constructor Create;
    Destructor Destroy; override;
  end;

  TPumpRow = record
    LIFTn: double;
    Qn: double;
  end;

  TPump = class(TObject)
    Name: string;
    LIFTq0: double;
    LIFTqmax: double;
    HWtol: double;
    LiftTable: array of TPumpRow;
  end;

  TMnw2Writer = class(TListWriter)
  private
    ModelHandle: ANE_PTR;
    Dis: TDiscretizationWriter;
    MNW2_VertLayer: TLayerOptions;
    MNW2_GeneralLayer: TLayerOptions;
    FVerticalSteadyIndicies: TSteadyMnw2SteadyParameterIndicies;
    FGeneralSteadyIndicies: TSteadyMnw2SteadyParameterIndicies;
    FVerticalIndicies: TVertWellSteadyParameterIndicies;
    FGeneralIndicies: TGeneralSteadyParameterIndicies;
    FWellScreenIndicies: array of TWellScreenIndicies;
    FVerticalTimeIndicies: TMnwTimeIndexArray;
    FGeneralTimeIndicies: TMnwTimeIndexArray;
    FUseVerticalLayers: Boolean;
    FUseGeneralLayers: Boolean;
    FVertLayerName: string;
    FGeneralLayerName: string;
    FNonPointVertContourErrors: TStringList;
    FInvalidLossTypeVerticalErrors: TStringList;
    FInvalidLossTypeGeneralErrors: TStringList;
    FNotInGridVertContourErrors: TStringList;
    FInvalidLossTypeErrors: TStringList;
    FInvalidWellScreenErrors: TStringList;
    FClosedContourErrors: TStringList;
    FUpSlopingWellWarnings: TStringList;
    FInvalidWellElevations: TStringList;
    FRadiusToLargeErrors: TStringList;
    FVerticalWells: TList;
    FGeneralWellSections: TList;
    FGeneralWells: TList;
    FPumpList: TList;
    FPumpSortedList: TStringList;
    FDuplicatePumpNameErrors: TStringList;
    FWellIds: TStringList;
    FWellIdErrors: TStringList;
//    FMonitoringWellsDefined: boolean;
    FMonitoringWellCount: integer;
    Bas: TBasicPkgWriter;
    FTopTooHighErrors: TStringList;
    FBottomTooLowErrors: TStringList;
    FInactiveVarticalCellErrors: TStringList;
    FInvalidWellRadiusErrors: TStringList;
    FInactiveGeneralCellErrors: TStringList;
    procedure SetSteadyIndicies(const Layer: TLayerOptions;
      var Indicies: TSteadyMnw2SteadyParameterIndicies);
    procedure SetVertIndicies;
    procedure SetGeneralIndicies;
    procedure SetWellScreenIndicies(Const ScreenIndex: integer;
      var Indicies: TWellScreenIndicies);
    procedure SetTimeIndicies(const Layer: TLayerOptions;
      Const TimeIndex: integer; var Indicies: TMnwTimeIndicies);
    procedure GetLayersAndParameterIndicies;
    procedure ChooseLayersToUse;
    procedure Evaluate;
    procedure EvaluateVerticalContour(ContourIndex: ANE_INT32);
    procedure EvaluateGeneralContour(ContourIndex: ANE_INT32);
    procedure AssignSteadyValues(SteadyIndicies: TSteadyMnw2SteadyParameterIndicies;
      Contour: TContourObjectOptions; var SteadyValues: TSteadyMnw2SteadyValues);
    procedure AssignWellScreens(Well: TVerticalMnw2Well;
      Contour: TContourObjectOptions);
    procedure AssignValuesForAStressPeriod(Contour: TContourObjectOptions;
      var Values: TMnwTimeValues; Indicies: TMnwTimeIndicies);
    procedure AssignTimeVaryingData(var TimeValues: TMnwTimeValuesArray;
      const TimeIndicies: TMnwTimeIndexArray; Contour: TContourObjectOptions);
    procedure ReportErrors(WellLayerName: string);
    procedure ReportVerticalWellErrors;
    procedure AssignGeneralSteadyValues(
      var GeneralSteadyValues: TGeneralSteadyValues; Contour: TObjectOptions);
    procedure AssignGeneralCells(ContourIndex: ANE_INT32;
      Well: TGeneralMnw2WellSection; CellCount: ANE_INT32);
    procedure CreateGeneralWells;
    procedure ReportGeneralWellErrors;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet2AGeneral(GeneralWell: TGeneralMnw2Well);
    procedure WriteDataSet2AVertical(VerticalWell: TVerticalMnw2Well);
    procedure WriteDataSet2B(const SteadyValues: TSteadyMnw2SteadyValues;
      Vertical: Boolean);
    procedure WriteDataSet2C(const SteadyValues: TSteadyMnw2SteadyValues;
      Vertical: boolean);
    procedure WriteDataSet2DVertical(VerticalWell: TVerticalMnw2Well);
    procedure GetWellCharacteristics(
      const SteadyValues: TSteadyMnw2SteadyValues; var Rw, Rskin, Kskin, B, C,
      P, CWC: ANE_DOUBLE);
    procedure WriteWellCharacteristics(
      const SteadyValues: TSteadyMnw2SteadyValues;
      const Rw, Rskin, Kskin, B, C, P, CWC: ANE_DOUBLE;
      const DataSet: string);
    procedure WriteDataSet2DGeneral(GeneralWell: TGeneralMnw2Well);
    procedure WriteDataSet2eVertical(SteadyValues: TSteadyMnw2SteadyValues);
    procedure WriteDataSet2eGeneral(GeneralWell: TGeneralMnw2Well);
    procedure WriteDataSet2f(SteadyValues: TSteadyMnw2SteadyValues);
    procedure WriteDataSet2g_2h(SteadyValues: TSteadyMnw2SteadyValues);
    procedure WriteDataSets3_4;
    procedure WriteDataSet3(StressPeriodIndex: Integer; var ITMP: Integer);
    procedure GetQLimit(const SteadyValues: TSteadyMnw2SteadyValues;
      var Qlimit: Integer);
    procedure WriteDataSet4a(SteadyValues: TSteadyMnw2SteadyValues;
      TimeValues: TMnwTimeValues);
    procedure WritePumpingLimits(const PumpLimits: TPumpLimits;
      const DataSet: string);
    procedure WriteDataSet4b(SteadyValues: TSteadyMnw2SteadyValues;
      TimeValues: TMnwTimeValues);
    procedure AssignWellId(SteadyIndicies: TSteadyMnw2SteadyParameterIndicies;
      Contour: TContourObjectOptions; var SteadyValues: TSteadyMnw2SteadyValues);
    procedure WriteDataSet4(ITMP: Integer; StressPeriodIndex: Integer);
    procedure AssignWellCharacteristics(
      var SteadyValues: TSteadyMnw2SteadyValues; Contour: TContourObjectOptions;
      SteadyIndicies: TSteadyMnw2SteadyParameterIndicies);
    procedure ReadPumps;
    procedure EvaluateVerticalWells;
    procedure EvaluateGeneralWells;
    procedure WriteMnwiDataSet1;
    procedure WriteMnwiDataSet2;
    procedure WriteMnwiDataSet3Line(SteadyValues: TSteadyMnw2SteadyValues;
      const Root: string);
    procedure WriteMnwiDataSet3(const Root: string);
    procedure ReportWellIdErrors;
  public
    class procedure AssignUnitNumbers;
    Constructor Create;
    destructor Destroy; override;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      Root: string; Discretization: TDiscretizationWriter;
      BasicWriter: TBasicPkgWriter);
  end;

implementation

uses Math, Variables, ModflowUnit, ProgressUnit, GetCellUnit, GetFractionUnit, 
  BL_SegmentUnit, JvPageList, frameMnw2PumpUnit, WriteNameFileUnit;

function SortWellSections(Item1, Item2: Pointer): Integer;
var
  Section1, Section2: TGeneralMnw2WellSection;
begin
  Section1 := Item1;
  Section2 := Item2;
  result := Section1.GeneralSteadyValues.Order -
    Section2.GeneralSteadyValues.Order;
  if result = 0 then
  begin
    result := Sign(Section1.GeneralSteadyValues.UpperElev -
      Section2.GeneralSteadyValues.UpperElev)
  end;
end;

{ TMnw2Writer }

constructor TMnw2Writer.Create;
begin
  FRadiusToLargeErrors := TStringList.Create;
  FDuplicatePumpNameErrors := TStringList.Create;
  FInvalidLossTypeGeneralErrors := TStringList.Create;
  FInvalidLossTypeVerticalErrors := TStringList.Create;
  FInvalidWellElevations := TStringList.Create;
  FUpSlopingWellWarnings := TStringList.Create;
  FNonPointVertContourErrors := TStringList.Create;
  FNotInGridVertContourErrors := TStringList.Create;
  FInvalidLossTypeErrors := TStringList.Create;
  FInvalidWellScreenErrors := TStringList.Create;
  FClosedContourErrors := TStringList.Create;
  FVerticalWells := TObjectList.Create;
  FGeneralWellSections := TObjectList.Create;
  FGeneralWells := TObjectList.Create;
  FPumpList := TObjectList.Create;
  FPumpSortedList := TStringList.Create;
  FPumpSortedList.CaseSensitive := False;
  FPumpSortedList.Sorted := True;
  FWellIds := TStringList.Create;
  FWellIds.Sorted := True;
  FWellIdErrors := TStringList.Create;
  FTopTooHighErrors := TStringList.Create;
  FBottomTooLowErrors := TStringList.Create;
  FInactiveVarticalCellErrors := TStringList.Create;
  FInvalidWellRadiusErrors := TStringList.Create;
  FInactiveGeneralCellErrors := TStringList.Create;
//  FMonitoringWellsDefined := False;
end;

destructor TMnw2Writer.Destroy;
begin
  FInactiveGeneralCellErrors.Free;
  FInvalidWellRadiusErrors.Free;
  FTopTooHighErrors.Free;
  FBottomTooLowErrors.Free;
  FInactiveVarticalCellErrors.Free;
  FWellIdErrors.Free;
  FWellIds.Free;
  FPumpSortedList.Free;
  FPumpList.Free;
  FGeneralWells.Free;
  FGeneralWellSections.Free;
  FVerticalWells.Free;
  FClosedContourErrors.Free;
  FInvalidWellScreenErrors.Free;
  FInvalidLossTypeErrors.Free;
  FNotInGridVertContourErrors.Free;
  FNonPointVertContourErrors.Free;
  FUpSlopingWellWarnings.Free;
  FInvalidWellElevations.Free;
  FInvalidLossTypeVerticalErrors.Free;
  FInvalidLossTypeGeneralErrors.Free;
  FDuplicatePumpNameErrors.Free;
  FRadiusToLargeErrors.Free;
  MNW2_VertLayer.Free(ModelHandle);
  MNW2_GeneralLayer.Free(ModelHandle);
  inherited;
end;

procedure TMnw2Writer.WriteDataSet4b(SteadyValues: TSteadyMnw2SteadyValues;
  TimeValues: TMnwTimeValues);
var
  Qlimit: Integer;
begin
  GetQLimit(SteadyValues, Qlimit);
  if Qlimit < 0 then
  begin
    WritePumpingLimits(TimeValues.PumpLimits, '4b');
  end;
end;

procedure TMnw2Writer.WritePumpingLimits(const PumpLimits: TPumpLimits;
  const DataSet: string);
var
  Qfrcmn: ANE_DOUBLE;
  Qfrcmx: ANE_DOUBLE;
  Hlim: ANE_DOUBLE;
  QCUT: ANE_INT32;
begin
  Hlim := PumpLimits.LimitingWaterLevel;
  QCUT := PumpLimits.PumpingLimitType;
  if QCUT = 0 then
  begin
    WriteLn(FFile, FreeFormattedReal(Hlim), FreeFormattedReal(QCUT), '# Data Set ', DataSet, ' Hlim QCUT');
  end
  else
  begin
    Qfrcmn := PumpLimits.InactivationPumpingRate;
    Qfrcmx := PumpLimits.ReactivationPumpingRate;
    WriteLn(FFile, FreeFormattedReal(Hlim), QCUT, ' ',
      FreeFormattedReal(Qfrcmn), FreeFormattedReal(Qfrcmx),
      ' #Data Set ', DataSet, ' Hlim QCUT Qfrcmn Qfrcmx');
  end;
end;

procedure TMnw2Writer.WriteDataSet4a(SteadyValues: TSteadyMnw2SteadyValues;
  TimeValues: TMnwTimeValues);
var
  Qdes: ANE_DOUBLE;
  CapMult: ANE_DOUBLE;
  Cprime: ANE_DOUBLE;
  WELLID: string;
  Data: string;
  IFACE: ANE_INT32;
begin
  // 4a
  WELLID := SteadyValues.WellId;
  if Pos(' ', WELLID) > 0 then
  begin
    WELLID := '"' + WELLID + '"';
  end;
  Qdes := TimeValues.PumpingRate;
  Write(FFile, WELLID, ' ', FreeFormattedReal(Qdes));
  Data := ' # Data set 4a WELLID Qdes';
  if SteadyValues.PUMPCAP > 0 then
  begin
    CapMult := TimeValues.HeadCapacityMultiplier;
    Write(FFile, FreeFormattedReal(CapMult));
    Data := Data + ' CapMult';
  end;
  if {(Qdes > 0) and} frmModflow.cbMOC3D.Checked then
  begin
    Cprime := TimeValues.Concentration;
    Write(FFile, FreeFormattedReal(Cprime));
    Data := Data + ' Cprime';
  end;
  if frmModflow.cbMODPATH.Checked then
  begin
    IFACE := TimeValues.IFACE;
    Write(FFile, ' ', IFACE);
    Data := Data + ' IFACE';
  end;
  Writeln(FFile, Data);
end;

procedure TMnw2Writer.GetQLimit(const SteadyValues: TSteadyMnw2SteadyValues;
  var Qlimit: Integer);
begin
  if SteadyValues.ConstrainPumping then
  begin
    if frmModflow.cbMnw2TimeVarying.Checked then
    begin
      Qlimit := -1;
    end
    else
    begin
      Qlimit := 1;
    end;
  end
  else
  begin
    Qlimit := 0;
  end;
end;

procedure TMnw2Writer.WriteDataSet3(StressPeriodIndex: Integer;
  var ITMP: Integer);
var
  WellIndex: Integer;
  VerticalWell: TVerticalMnw2Well;
  TimeValues: TMnwTimeValues;
  GeneralWell: TGeneralMnw2Well;
  WellSection: TGeneralMnw2WellSection;
begin
  if (StressPeriodIndex >= 1)
    and (frmModflow.comboMnw2SteadyState.ItemIndex = 0) then
  begin
    ITMP := -1;
    WriteLn(FFile, -1);
  end
  else
  begin
    ITMP := 0;
    for WellIndex := 0 to FVerticalWells.Count - 1 do
    begin
      VerticalWell := FVerticalWells[WellIndex];
      TimeValues := VerticalWell.TimeValues[StressPeriodIndex];
      if TimeValues.Active then
      begin
        Inc(ITMP);
      end;
    end;
    for WellIndex := 0 to FGeneralWells.Count - 1 do
    begin
      GeneralWell := FGeneralWells[WellIndex];
      WellSection := GeneralWell.FWellSections[0];
      TimeValues := WellSection.TimeValues[StressPeriodIndex];
      if TimeValues.Active then
      begin
        Inc(ITMP);
      end;
    end;
  end;
  WriteLn(FFile, ITMP, ' # Data set 3 ITMP');
end;

procedure TMnw2Writer.WriteDataSet2g_2h(SteadyValues: TSteadyMnw2SteadyValues);
var
  RowIndex: Integer;
  Hlift: ANE_DOUBLE;
  Pump: TPump;
  PumpPosition: Integer;
begin
  PumpPosition := FPumpSortedList.IndexOf(SteadyValues.PumpType);
  if PumpPosition >= 0 then
  begin
    Pump := FPumpSortedList.Objects[PumpPosition] as TPump;
    Hlift := SteadyValues.DischargeElevation;
    WriteLn(FFile, FreeFormattedReal(Hlift), FreeFormattedReal(Pump.LIFTq0),
      FreeFormattedReal(Pump.LIFTqmax), FreeFormattedReal(Pump.HWtol),
      ' #Data set 2g Hlift LIFTq0 LIFTqmax HWtol');
    for RowIndex := 0 to Length(Pump.LiftTable) - 1 do
    begin
      WriteLn(FFile, FreeFormattedReal(Pump.LiftTable[RowIndex].LIFTn),
        FreeFormattedReal(Pump.LiftTable[RowIndex].Qn),
        '# Data set 2h LIFTn Qn');
    end;
  end;
end;

procedure TMnw2Writer.WriteDataSets3_4;
var
  StressPeriodIndex: Integer;
  ITMP: Integer;
begin
  for StressPeriodIndex := 0 to Dis.NPER - 1 do
  begin
    WriteDataSet3(StressPeriodIndex, ITMP);
    WriteDataSet4(ITMP, StressPeriodIndex);
  end;
end;

procedure TMnw2Writer.WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicWriter: TBasicPkgWriter);
var
  FileName: string;
begin
  ModelHandle := CurrentModelHandle;
  Dis := Discretization;
  Bas := BasicWriter;
  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsMNW2;
    AssignFile(FFile, FileName);
    try
      Application.ProcessMessages;
      if ContinueExport then
      begin
        Rewrite(FFile);
        Evaluate;
        WriteDataReadFrom(FileName);
        WriteDataSet1;
        WriteDataSet2;
        WriteDataSets3_4;
      end;
    finally
      CloseFile(FFile);
    end;

    frmModflow.MonitoringWellNameFileLines.Clear;
    if frmModflow.cbMnwi.Checked and frmModflow.cbUseMnwi.Checked then
    begin
      FileName := GetCurrentDir + '\' + Root + rsMNWI;
      AssignFile(FFile, FileName);
      try
        Application.ProcessMessages;
        if ContinueExport then
        begin
          Rewrite(FFile);
          WriteMnwiDataSet1;
          WriteMnwiDataSet2;
          Application.ProcessMessages;
          if not ContinueExport then
          begin
            Exit;
          end;
          WriteMnwiDataSet3(Root);
        end;
      finally
        CloseFile(FFile);
      end;
    end;
  end;
end;

procedure TMnw2Writer.WriteMnwiDataSet3(const Root: string);
var
  WellIndex: Integer;
  VerticalWell: TVerticalMnw2Well;
  SteadyValues: TSteadyMnw2SteadyValues;
  GeneralWell: TGeneralMnw2Well;
  WellSection: TGeneralMnw2WellSection;
begin
  for WellIndex := 0 to FVerticalWells.Count - 1 do
  begin
    VerticalWell := FVerticalWells[WellIndex];
    SteadyValues := VerticalWell.SteadyValues;
    WriteMnwiDataSet3Line(SteadyValues, Root);
  end;
  for WellIndex := 0 to FGeneralWells.Count - 1 do
  begin
    GeneralWell := FGeneralWells[WellIndex];
    WellSection := GeneralWell.FWellSections[0];
    SteadyValues := WellSection.SteadyValues;
    WriteMnwiDataSet3Line(SteadyValues, Root);
  end;
end;

procedure TMnw2Writer.WriteMnwiDataSet3Line(
  SteadyValues: TSteadyMnw2SteadyValues; const Root: string);
var
  CONCflag: ANE_INT32;
  QBHflag: Integer;
  QNDflag: Integer;
  OutputUnitNumber: integer;
  OutputFileName: string;
  WELLID: string;
begin
  if SteadyValues.MonitorWell
    or SteadyValues.MonitorExternalFlows
    or SteadyValues.MonitorInternalFlows
    or (SteadyValues.MonitorConcentrations in [0..3]) then
  begin
    WELLID := SteadyValues.WellId;
    OutputFileName := Root + '.' + WELLID + rsMNWIOut;
    OutputUnitNumber := frmModflow.GetUnitNumber(WELLID);
    frmModflow.MonitoringWellNameFileLines.Add('DATA ' + IntToStr(OutputUnitNumber)
      + ' ' + OutputFileName);
    if Pos(' ', WELLID) > 0 then
    begin
      WELLID := '"' + WELLID + '"';
    end;
    if SteadyValues.MonitorExternalFlows then
    begin
      QNDflag := 1;
    end
    else
    begin
      QNDflag := 0;
    end;
    if SteadyValues.MonitorInternalFlows then
    begin
      QBHflag := 1;
    end
    else
    begin
      QBHflag := 0;
    end;
    CONCflag := SteadyValues.MonitorConcentrations;
    if not (CONCflag in [0..3]) then
    begin
      CONCflag := 0;
    end;
    WriteLn(FFile, WELLID, ' ', OutputUnitNumber, ' ',
      QNDflag, ' ', QBHflag, ' ', CONCflag,
      ' # WELLID UNIT QNDflag QBHflag CONCflag');
  end;
end;

procedure TMnw2Writer.WriteMnwiDataSet2;
var
  MNWOBS: Integer;
begin
  MNWOBS := FMonitoringWellCount;
  WriteLn(FFile, MNWOBS, ' # MNWOBS');
end;

procedure TMnw2Writer.WriteMnwiDataSet1;
var
  BYNDflag: Integer;
  QSUMflag: Integer;
  WEL1flag: Integer;
begin
  if frmModflow.cbMnwiWel1flag.Checked then
  begin
    WEL1flag := frmModflow.GetUnitNumber('WEL1flag');
  end
  else
  begin
    WEL1flag := 0;
  end;
  if frmModflow.cbMnwiQsumFlag.Checked then
  begin
    QSUMflag := frmModflow.GetUnitNumber('QSUMflag');
  end
  else
  begin
    QSUMflag := 0;
  end;
  if frmModflow.cbMnwiByNdFlag.Checked then
  begin
    BYNDflag := frmModflow.GetUnitNumber('BYNDflag');
  end
  else
  begin
    BYNDflag := 0;
  end;
  WriteLn(FFile, WEL1flag, ' ', QSUMflag, ' ', ' ', BYNDflag, ' # WEL1flag, QSUMflag, BYNDflag');
end;

procedure TMnw2Writer.EvaluateGeneralWells;
var
  ContourIndex: ANE_INT32;
  ContourCount: ANE_INT32;
begin
  if FUseGeneralLayers then
  begin
    AddVertexLayer(ModelHandle, FGeneralLayerName);
    frmProgress.pbPackage.StepIt;
    ContourCount := MNW2_GeneralLayer.NumObjects(ModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      frmProgress.pbActivity.Position := 0;
      frmProgress.pbActivity.Max := ContourCount;
      for ContourIndex := 0 to ContourCount - 1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then
          Exit;
        EvaluateGeneralContour(ContourIndex);
        frmProgress.pbActivity.StepIt;
      end;
    end;
    CreateGeneralWells;
    // still need to check on errors in well ordering.
    ReportGeneralWellErrors;
    ReportErrors(FGeneralLayerName);
  end;
end;

procedure TMnw2Writer.EvaluateVerticalWells;
var
  ContourCount: ANE_INT32;
  ContourIndex: ANE_INT32;
begin
  if FUseVerticalLayers then
  begin
    AddVertexLayer(ModelHandle, FVertLayerName);
    frmProgress.pbPackage.StepIt;
    ContourCount := MNW2_VertLayer.NumObjects(ModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      frmProgress.pbActivity.Position := 0;
      frmProgress.pbActivity.Max := ContourCount;
      for ContourIndex := 0 to ContourCount - 1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then
          break;
        EvaluateVerticalContour(ContourIndex);
        frmProgress.pbActivity.StepIt;
      end;
    end;
    ReportVerticalWellErrors;
    ReportErrors(FVertLayerName);
  end;
end;

procedure TMnw2Writer.ReadPumps;
var
  Qn: Double;
  LIFTn: Double;
  RowIndex: Integer;
  TableLength: Integer;
  Pump: TPump;
  PumpName: string;
  Frame: TframeMnw2Pump;
  Page: TJvCustomPage;
  PumpIndex: Integer;
  ErrorString: string;
begin
  for PumpIndex := 0 to frmModflow.plMnwPumps.PageCount - 1 do
  begin
    Page := frmModflow.plMnwPumps.Pages[PumpIndex];
    Frame := Page.Controls[0] as TframeMnw2Pump;
    PumpName := Trim(Frame.edPumpName.Text);
    if PumpName <> '' then
    begin
      if FPumpSortedList.IndexOf(PumpName) >= 0 then
      begin
        FDuplicatePumpNameErrors.Add(PumpName);
      end;
      Pump := TPump.Create;
      Pump.Name := PumpName;
      FPumpSortedList.AddObject(PumpName, Pump);
      FPumpList.Add(Pump);
      Pump.LIFTq0 := StrToFloatDef(Frame.adeLiftQ0.Text, 0);
      Pump.LIFTqmax := StrToFloatDef(Frame.adeLiftQMax.Text, 0);
      Pump.HWtol := StrToFloatDef(Frame.adeHWtol.Text, 0);
      SetLength(Pump.LiftTable, Frame.rdgLiftQ_Table.RowCount - 1);
      TableLength := 0;
      for RowIndex := 1 to Frame.rdgLiftQ_Table.RowCount - 1 do
      begin
        if TryStrToFloat(Frame.rdgLiftQ_Table.
          Cells[Ord(pcLift), RowIndex], LIFTn)
          and TryStrToFloat(Frame.rdgLiftQ_Table.
          Cells[Ord(pcQ), RowIndex], Qn) then
        begin
          Pump.LiftTable[TableLength].LIFTn := LIFTn;
          Pump.LiftTable[TableLength].Qn := Qn;
          Inc(TableLength);
        end;
      end;
      SetLength(Pump.LiftTable, TableLength);
    end;
  end;
  if FDuplicatePumpNameErrors.Count > 0 then
  begin
    ErrorString := 'Two or more pumps defined in the MNW2 package have the same name.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Duplicate pump names.');
    ErrorMessages.AddStrings(FDuplicatePumpNameErrors);
  end;
end;

procedure TMnw2Writer.AssignWellCharacteristics(
  var SteadyValues: TSteadyMnw2SteadyValues; Contour: TContourObjectOptions;
  SteadyIndicies: TSteadyMnw2SteadyParameterIndicies);
begin
//  if SteadyValues.LossType in [ltThiem, ltSkin, ltGeneral] then
//  begin
    if SteadyIndicies.WellRadiusIndex >= 0 then
    begin
      SteadyValues.WellRadius := Contour.GetFloatParameter(ModelHandle,
        SteadyIndicies.WellRadiusIndex);
    end;
//  end;
//  if SteadyValues.LossType = ltSkin then
//  begin
    if SteadyIndicies.SkinRadiusIndex >= 0 then
    begin
      SteadyValues.SkinRadius := Contour.GetFloatParameter(ModelHandle,
        SteadyIndicies.SkinRadiusIndex);
    end;
    if SteadyIndicies.SkinKIndex >= 0 then
    begin
      SteadyValues.SkinK := Contour.GetFloatParameter(ModelHandle,
        SteadyIndicies.SkinKIndex);
    end;
//  end;
//  if SteadyValues.LossType = ltGeneral then
//  begin
    if SteadyIndicies.BIndex >= 0 then
    begin
      SteadyValues.B := Contour.GetFloatParameter(ModelHandle,
        SteadyIndicies.BIndex);
    end;
    if SteadyIndicies.CIndex >= 0 then
    begin
      SteadyValues.C := Contour.GetFloatParameter(ModelHandle,
        SteadyIndicies.CIndex);
    end;
    if SteadyIndicies.PIndex >= 0 then
    begin
      SteadyValues.P := Contour.GetFloatParameter(ModelHandle,
        SteadyIndicies.PIndex);
    end;
//  end;
//  if SteadyValues.LossType = ltSpecifyCwc then
//  begin
    if SteadyIndicies.CellToWellConductanceIndex >= 0 then
    begin
      SteadyValues.CellToWellConductance := Contour.GetFloatParameter(
        ModelHandle, SteadyIndicies.CellToWellConductanceIndex);
    end;
//  end;
end;

procedure TMnw2Writer.WriteDataSet4(ITMP: Integer; StressPeriodIndex: Integer);
var
  WELLID: string;
  SteadyValues: TSteadyMnw2SteadyValues;
  VerticalWell: TVerticalMnw2Well;
  WellIndex: Integer;
  WellSection: TGeneralMnw2WellSection;
  GeneralWell: TGeneralMnw2Well;
  TimeValues: TMnwTimeValues;
begin
  if ITMP > 0 then
  begin
    for WellIndex := 0 to FVerticalWells.Count - 1 do
    begin
      VerticalWell := FVerticalWells[WellIndex];
      SteadyValues := VerticalWell.SteadyValues;
      WELLID := SteadyValues.WellId;
      TimeValues := VerticalWell.TimeValues[StressPeriodIndex];
      if TimeValues.Active then
      begin
        WriteDataSet4a(SteadyValues, TimeValues);
        WriteDataSet4b(SteadyValues, TimeValues);
      end;
    end;
    for WellIndex := 0 to FGeneralWells.Count - 1 do
    begin
      GeneralWell := FGeneralWells[WellIndex];
      WellSection := GeneralWell.FWellSections[0];
      SteadyValues := WellSection.SteadyValues;
      TimeValues := WellSection.TimeValues[StressPeriodIndex];
      if TimeValues.Active then
      begin
        WriteDataSet4a(SteadyValues, TimeValues);
        WriteDataSet4b(SteadyValues, TimeValues);
      end;
    end;
  end;
end;

procedure TMnw2Writer.AssignWellId(
  SteadyIndicies: TSteadyMnw2SteadyParameterIndicies;
  Contour: TContourObjectOptions; var SteadyValues: TSteadyMnw2SteadyValues);
begin
  SteadyValues.WellId := Trim(Contour.GetStringParameter(ModelHandle,
    SteadyIndicies.WellIdIndex));
end;

procedure TMnw2Writer.WriteDataSet2f(SteadyValues: TSteadyMnw2SteadyValues);
var
  QLimit: Integer;
begin
  GetQLimit(SteadyValues, QLimit);
  if QLimit > 0 then
  begin
    WritePumpingLimits(SteadyValues.PumpLimits, '2f');
  end;
end;

procedure TMnw2Writer.WriteDataSet2eGeneral(GeneralWell: TGeneralMnw2Well);
var
  Cell: TWellCell;
begin
  if GeneralWell.PumpCell <> nil then
  begin
    Cell := GeneralWell.PumpCell;
    WriteLn(FFile, Cell.Layer, ' ', Cell.Row, ' ', Cell.Column,
      ' # Data set 2e, Layer Row Column');
  end;
end;

procedure TMnw2Writer.WriteDataSet2eVertical(
  SteadyValues: TSteadyMnw2SteadyValues);
var
  Zpump: ANE_DOUBLE;
begin
  if SteadyValues.SpecifyPump then
  begin
    Zpump := SteadyValues.PumpElevation;
    WriteLn(FFile, FreeFormattedReal(Zpump), '#Data set 2e Zpump');
  end;
end;

procedure TMnw2Writer.WriteDataSet2DGeneral(GeneralWell: TGeneralMnw2Well);
var
  WellSection: TGeneralMnw2WellSection;
  Rskin: ANE_DOUBLE;
  Rw: ANE_DOUBLE;
  SectionIndex: Integer;
  Cell: TWellCell;
  CellIndex: Integer;
  CWC: ANE_DOUBLE;
  P: ANE_DOUBLE;
  C: ANE_DOUBLE;
  B: ANE_DOUBLE;
  Kskin: ANE_DOUBLE;
begin
  for SectionIndex := 0 to GeneralWell.FWellSections.Count - 1 do
  begin
    WellSection := GeneralWell.FWellSections[SectionIndex];
    GetWellCharacteristics(WellSection.SteadyValues, Rw,
      Rskin, Kskin, B, C, P, CWC);
    for CellIndex := 0 to WellSection.FCells.Count - 1 do
    begin
      Cell := WellSection.FCells[CellIndex];
      Write(FFile, Cell.Layer, ' ', Cell.Row, ' ', Cell.Column, ' ');
      WriteWellCharacteristics(WellSection.SteadyValues,
        Rw, Rskin, Kskin, B, C, P, CWC, '2d');
      if WellSection.SteadyValues.LossType = ltNone then
      begin
        Writeln(FFile);
      end;

    end;
  end;
end;

procedure TMnw2Writer.WriteDataSet2DVertical(VerticalWell: TVerticalMnw2Well);
var
  Zbotm: ANE_DOUBLE;
  Ztop: ANE_DOUBLE;
  AScreen: TWellScreenValues;
  ScreenIndex: Integer;
  COL: Integer;
  ROW: Integer;
begin
  ROW := VerticalWell.Row;
  COL := VerticalWell.Column;
  for ScreenIndex := 0 to Length(VerticalWell.WellScreens) - 1 do
  begin
    AScreen := VerticalWell.WellScreens[ScreenIndex];
    Ztop := AScreen.TopWellScreen;
    Zbotm := AScreen.BottomWellScreen;
    WriteLn(FFile, FreeFormattedReal(Ztop), FreeFormattedReal(Zbotm),
      ROW, ' ', COL,
      ' Data set 2d Ztop Zbotm ROW COL');
  end;
end;

procedure TMnw2Writer.WriteDataSet2B(
  const SteadyValues: TSteadyMnw2SteadyValues; Vertical: Boolean);
var
  PPFLAG: Integer;
  Qlimit: Integer;
  PUMPLOC: Integer;
  LOSSTYPE: string;
  PUMPCAP: Integer;
begin
  case SteadyValues.LossType of
    ltNone:
      LOSSTYPE := 'NONE ';
    ltThiem:
      LOSSTYPE := 'THIEM ';
    ltSkin:
      LOSSTYPE := 'SKIN ';
    ltGeneral:
      LOSSTYPE := 'GENERAL ';
    ltSpecifyCwc:
      LOSSTYPE := 'SPECIFYcwc ';
    else
      Assert(False);
  end;
  if SteadyValues.SpecifyPump then
  begin
    if Vertical then
    begin
      PUMPLOC := -1;
    end
    else
    begin
      PUMPLOC := 1;
    end;
  end
  else
  begin
    PUMPLOC := 0;
  end;
  GetQLimit(SteadyValues, Qlimit);
  if SteadyValues.PartialPenetrationFlag then
  begin
    PPFLAG := 1;
  end
  else
  begin
    PPFLAG := 0;
  end;
  PUMPCAP := SteadyValues.PUMPCAP;

  WriteLn(FFile, LOSSTYPE, ' ', PUMPLOC, ' ',
    Qlimit, ' ', PPFLAG, ' ', PUMPCAP,
    ' # Data set 2b LOSSTYPE PUMPLOC Qlimit PPFLAG PUMPCAP');
end;

procedure TMnw2Writer.GetWellCharacteristics(
  const SteadyValues: TSteadyMnw2SteadyValues;
  var Rw, Rskin, Kskin, B, C, P, CWC: ANE_DOUBLE);
begin
  Rw := 0;
  Rskin := 0;
  Kskin := 0;
  B := 0;
  C := 0;
  P := 0;
  CWC := 0;
  case SteadyValues.LossType of
    ltNone: ;  // do nothing
    ltThiem:
      begin
        Rw := SteadyValues.WellRadius;
      end;
    ltSkin:
      begin
        Rw := SteadyValues.WellRadius;
        Rskin := SteadyValues.SkinRadius;
        Kskin := SteadyValues.SkinK;
      end;
    ltGeneral:
      begin
        Rw := SteadyValues.WellRadius;
        B := SteadyValues.B;
        C := SteadyValues.C;
        P := SteadyValues.P;
      end;
    ltSpecifyCwc:
      begin
        CWC := SteadyValues.CellToWellConductance;
      end;
    else Assert(False);
  end;
end;

procedure TMnw2Writer.WriteWellCharacteristics(
  const SteadyValues: TSteadyMnw2SteadyValues;
  const Rw, Rskin, Kskin, B, C, P, CWC: ANE_DOUBLE;
  const DataSet: string);
begin
  case SteadyValues.LossType of
    ltNone: ;  // do nothing
    ltThiem:
      begin
        WriteLn(FFile, FreeFormattedReal(Rw), '# Data set ', DataSet, ' Rw');
      end;
    ltSkin:
      begin
        WriteLn(FFile, FreeFormattedReal(Rw), FreeFormattedReal(Rskin),
          FreeFormattedReal(Kskin),
          ' #Data set ', DataSet, ' Rw Rskin Kskin');
      end;
    ltGeneral:
      begin
        WriteLn(FFile, FreeFormattedReal(Rw), FreeFormattedReal(B),
          FreeFormattedReal(C), FreeFormattedReal(P),
          ' #Data set ', DataSet, ' Rw B C P');
      end;
    ltSpecifyCwc:
      begin
        WriteLn(FFile, FreeFormattedReal(CWC),
          '# Data set ', DataSet, ' CWC');
      end;
    else Assert(False);
  end;
end;

procedure TMnw2Writer.WriteDataSet2C(
  const SteadyValues: TSteadyMnw2SteadyValues; Vertical: boolean);
var
  Rw: ANE_DOUBLE;
  Rskin: ANE_DOUBLE;
  Kskin: ANE_DOUBLE;
  B: ANE_DOUBLE;
  C: ANE_DOUBLE;
  P: ANE_DOUBLE;
  CWC: ANE_DOUBLE;
  DataSet: string;
begin
  if Vertical then
  begin
    DataSet := '2c';
  end
  else
  begin
    DataSet := '2d';
  end;
  GetWellCharacteristics(SteadyValues, Rw, Rskin, Kskin, B, C, P, CWC);
  if not Vertical then
  begin
    Rw := -Rw;
    Rskin := -Rskin;
    Kskin := -Kskin;
    B := -B;
    C := -C;
    P := -P;
    CWC := -CWC;
  end;
  WriteWellCharacteristics(SteadyValues, Rw,
    Rskin, Kskin, B, C, P, CWC, DataSet);
end;

procedure TMnw2Writer.WriteDataSet2AVertical(VerticalWell: TVerticalMnw2Well);
var
  NNODES: Integer;
  WELLID: string;
begin
  WELLID := VerticalWell.SteadyValues.WellId;
  if Length(WELLID) > 20 then
  begin
    SetLength(WELLID, 20);
  end;
  if Pos(' ', WELLID) > 0 then
  begin
    WELLID := '"' + WELLID + '"';
  end;
  NNODES := -Length(VerticalWell.WellScreens);
  WriteLn(FFile, WELLID, ' ', NNODES,
  ' # Data set 2a WELLID, NNODES');
  if FWellIds.IndexOf(WELLID) >= 0 then
  begin
    FWellIdErrors.Add(WELLID);
  end;
  FWellIds.Add(WELLID)
end;

procedure TMnw2Writer.WriteDataSet2AGeneral(GeneralWell: TGeneralMnw2Well);
var
  SectionIndex: Integer;
  WellSection: TGeneralMnw2WellSection;
  NNODES: Integer;
  WELLID: string;
begin
  WellSection := GeneralWell.FWellSections[0];
  WELLID := WellSection.SteadyValues.WellId;
  if Length(WELLID) > 20 then
  begin
    SetLength(WELLID, 20);
  end;
  if Pos(' ', WELLID) > 0 then
  begin
    WELLID := '"' + WELLID + '"';
  end;
  NNODES := 0;
  for SectionIndex := 0 to GeneralWell.FWellSections.Count - 1 do
  begin
    WellSection := GeneralWell.FWellSections[SectionIndex];
    NNODES := NNODES + WellSection.FCells.Count;
  end;
  WriteLn(FFile, WELLID, ' ', NNODES,
    ' # Data set 2a, WELLID NNODES');
  if FWellIds.IndexOf(WELLID) >= 0 then
  begin
    FWellIdErrors.Add(WELLID);
  end;
  FWellIds.Add(WELLID)
end;

procedure TMnw2Writer.ReportWellIdErrors;
var
  ErrorString: string;
begin
  if FWellIdErrors.Count > 0 then
  begin
    ErrorString := 'One or more wells in the MNW2 package have '
      + 'duplicate well IDs.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.AddStrings(FWellIdErrors);
  end;
  if FInvalidWellRadiusErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours in the MNW2 package have '
      + 'negative or zero well radii.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FInvalidWellRadiusErrors);
  end;

end;

procedure TMnw2Writer.ReportGeneralWellErrors;
var
  ErrorString: string;
begin
  if FClosedContourErrors.Count > 0 then
  begin
    ErrorString := 'One or more closed contours are on the '
      + FGeneralLayerName
      + ' layer. Only point and open contours can be used on the '
      + FGeneralLayerName
      + ' layer. These contours will be skipped.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FClosedContourErrors);
  end;
  if FUpSlopingWellWarnings.Count > 0 then
  begin
    ErrorString := 'In one or more multi-node wells on the '
      + FGeneralLayerName + ' layer,'
      + ' the upper elevation '
      + 'is below the lower elevation.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Column and Row.');
    ErrorMessages.AddStrings(FUpSlopingWellWarnings);
  end;
  if FInvalidWellElevations.Count > 0 then
  begin
    ErrorString := 'In one or more multi-node wells on the '
      + FGeneralLayerName
      + ' layer, an invalid pump elevation was specified.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Column and Row.');
    ErrorMessages.AddStrings(FInvalidWellElevations);
  end;
  if FInvalidLossTypeGeneralErrors.Count > 0 then
  begin
    ErrorString := 'In one or more multi-node wells on the '
      + FGeneralLayerName
      + ' layer, a well has more than one cell but the LOSSTYPE '
      + 'is specified as "NONE".';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Column and Row.');
    ErrorMessages.AddStrings(FInvalidLossTypeGeneralErrors);
  end;

  if FInactiveGeneralCellErrors.Count > 0 then
  begin
    ErrorString := 'In one or more multi-node wells on the '
      + FGeneralLayerName
      + ' layer, a well intersects an inactive cell.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Column, Row, MODFLOW-Layer.');
    ErrorMessages.AddStrings(FInactiveGeneralCellErrors);
  end;
end;

procedure TMnw2Writer.CreateGeneralWells;
var
  Well: TGeneralMnw2Well;
  WellPosition: Integer;
  WellSection: TGeneralMnw2WellSection;
  SectionIndex: Integer;
  GeneralWellSorter: TStringList;
  WellIndex: Integer;
  PumpElevation: ANE_DOUBLE;
  CellIndex: Integer;
  Cell: TWellCell;
  PriorRow: Integer;
  PriorCol: Integer;
  TestLayer: Integer;
  LossType: TLossType;
begin
  GeneralWellSorter := TStringList.Create;
  try
    GeneralWellSorter.Sorted := True;
    GeneralWellSorter.CaseSensitive := False;
    for SectionIndex := 0 to FGeneralWellSections.Count - 1 do
    begin
      WellSection := FGeneralWellSections[SectionIndex];
      WellPosition := GeneralWellSorter.IndexOf(WellSection.SteadyValues.WellId);
      if WellPosition < 0 then
      begin
        Well := TGeneralMnw2Well.Create;
        GeneralWellSorter.AddObject(WellSection.SteadyValues.WellId, Well);
        FGeneralWells.Add(Well);
      end
      else
      begin
        Well := GeneralWellSorter.Objects[WellPosition] as TGeneralMnw2Well;
      end;
      Well.FWellSections.Add(WellSection);
    end;
  finally
    GeneralWellSorter.Free;
  end;
  for WellIndex := 0 to FGeneralWells.Count - 1 do
  begin
    Well := FGeneralWells[WellIndex];
    Well.FWellSections.Sort(SortWellSections);
    WellSection := Well.FWellSections[0];
    LossType := WellSection.SteadyValues.LossType;
    for SectionIndex := 1 to Well.FWellSections.Count - 1 do
    begin
      WellSection := Well.FWellSections[SectionIndex];
      WellSection.SteadyValues.LossType := LossType;
    end;
    if ((WellSection.FCells.Count > 1) or (Well.FWellSections.Count > 1))
       and (WellSection.SteadyValues.LossType = ltNone) then
    begin
      Cell := WellSection.FCells[0];
      FInvalidLossTypeGeneralErrors.Add(IntToStr(Cell.Column) + ', '
        + IntToStr(Cell.Row));
    end;

    if WellSection.SteadyValues.SpecifyPump then
    begin
      PumpElevation := WellSection.SteadyValues.PumpElevation;
      for SectionIndex := 0 to Well.FWellSections.Count - 1 do
      begin
        WellSection := Well.FWellSections[SectionIndex];
        WellSection.SteadyValues.LossType := LossType;
        PriorRow := -1;
        PriorCol := -1;
        TestLayer := -1;
        for CellIndex := 0 to WellSection.FCells.Count - 1 do
        begin
          Cell := WellSection.FCells[CellIndex];
          if (Cell.Row <> PriorRow) or (Cell.Column <> PriorCol) then
          begin
            TestLayer := Dis.ElevationToLayer(
              Cell.Column, Cell.Row, PumpElevation)
          end;
          if Cell.Layer = TestLayer then
          begin
            Well.PumpCell := Cell;
            Break;
          end;
        end;
        if Well.PumpCell <> nil then
        begin
          break;
        end;
      end;
      if Well.PumpCell = nil then
      begin
        WellSection := Well.FWellSections[0];
        Cell := WellSection.FCells[0];
        FInvalidWellElevations.Add(
          IntToStr(Cell.Column) + ' ' + IntToStr(Cell.Row));
      end;
    end;
  end;
end;

procedure TMnw2Writer.AssignGeneralCells(ContourIndex: ANE_INT32;
  Well: TGeneralMnw2WellSection; CellCount: ANE_INT32);
var
  Cell: TWellCell;
  LayerIndex: Integer;
  LastLayer: Integer;
  FirstLayer: Integer;
  Column: ANE_INT32;
  Row: ANE_INT32;
  CellIndex: Integer;
  ContourLength: ANE_DOUBLE;
  DeltaLayer: integer;
  SegmentPosition: ANE_DOUBLE;
  SegmentLength: ANE_DOUBLE;
  FirstCellLayer: integer;
  LastCellLayer: integer;
begin
  Row := GGetCellRow(ContourIndex, 0);
  Column := GGetCellColumn(ContourIndex, 0);
  if Well.GeneralSteadyValues.UpperElev
    < Well.GeneralSteadyValues.LowerElev then
  begin
    FUpSlopingWellWarnings.Add(IntToStr(Column) + ', ' + IntToStr(Row));
  end;
  FirstLayer := Dis.ElevationToLayer(Column, Row,
    Well.GeneralSteadyValues.UpperElev);
  Row := GGetCellRow(ContourIndex, CellCount - 1);
  Column := GGetCellColumn(ContourIndex, CellCount - 1);
  LastLayer := Dis.ElevationToLayer(Column, Row,
    Well.GeneralSteadyValues.LowerElev);
  DeltaLayer := LastLayer - FirstLayer;
  ContourLength := GGetLineLength(ContourIndex);
  SegmentPosition := 0.0;
  for CellIndex := 0 to CellCount - 1 do
  begin
    Row := GGetCellRow(ContourIndex, CellIndex);
    Column := GGetCellColumn(ContourIndex, CellIndex);
    if DeltaLayer = 0 then
    begin
      Cell := TWellCell.Create;
      Well.FCells.Add(Cell);
      Cell.Row := Row;
      Cell.Column := Column;
      Cell.Layer := FirstLayer;
      if Bas.MFIBOUND[Cell.Column-1, Cell.Row-1, Cell.Layer-1] = 0  then
      begin
        FInactiveGeneralCellErrors.Add(IntToStr(Cell.Column) + ', '
          + IntToStr(Cell.Row) + ', ' + IntToStr(Cell.Layer))
      end;
    end
    else
    begin
      FirstCellLayer := Round(SegmentPosition*DeltaLayer/ContourLength)
        + FirstLayer;
      SegmentLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);
      SegmentPosition := SegmentPosition + SegmentLength;
      LastCellLayer := Round(SegmentPosition*DeltaLayer/ContourLength)
        + FirstLayer;
      if FirstCellLayer <= LastCellLayer then
      begin
        for LayerIndex := FirstCellLayer to LastCellLayer do
        begin
          Cell := TWellCell.Create;
          Well.FCells.Add(Cell);
          Cell.Row := Row;
          Cell.Column := Column;
          Cell.Layer := LayerIndex;
          if Bas.MFIBOUND[Cell.Column-1, Cell.Row-1, Cell.Layer-1] = 0  then
          begin
            FInactiveGeneralCellErrors.Add(IntToStr(Cell.Column) + ', '
              + IntToStr(Cell.Row) + ', ' + IntToStr(Cell.Layer))
          end;
        end;
      end
      else
      begin
        for LayerIndex := FirstCellLayer downto LastCellLayer do
        begin
          Cell := TWellCell.Create;
          Well.FCells.Add(Cell);
          Cell.Row := Row;
          Cell.Column := Column;
          Cell.Layer := LayerIndex;
          if Bas.MFIBOUND[Cell.Column-1, Cell.Row-1, Cell.Layer-1] = 0  then
          begin
            FInactiveGeneralCellErrors.Add(IntToStr(Cell.Column) + ', '
              + IntToStr(Cell.Row) + ', ' + IntToStr(Cell.Layer))
          end;
        end;
      end;
    end;
  end;
end;

procedure TMnw2Writer.AssignGeneralSteadyValues(
  var GeneralSteadyValues: TGeneralSteadyValues; Contour: TObjectOptions);
begin
  GeneralSteadyValues.Order := Contour.GetIntegerParameter(ModelHandle,
    FGeneralIndicies.OrderIndex);
  GeneralSteadyValues.UpperElev := Contour.GetFloatParameter(ModelHandle,
    FGeneralIndicies.UpperElevIndex);
  GeneralSteadyValues.LowerElev := Contour.GetFloatParameter(ModelHandle,
    FGeneralIndicies.LowerElevIndex);
end;

procedure TMnw2Writer.ReportVerticalWellErrors;
var
  ErrorString: string;
begin
  if FNonPointVertContourErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + FVertLayerName
      + 'layer is not a point contour. These contours will be skipped.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FNonPointVertContourErrors);
  end;
  if FInvalidWellScreenErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + FVertLayerName
      + 'layer has a well screen that has length less than or equal to zero.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FInvalidWellScreenErrors);
  end;
  if FTopTooHighErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + FVertLayerName
      + 'layer has a well screen whose top is above the top of the grid.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FTopTooHighErrors);
  end;
  if FBottomTooLowErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + FVertLayerName
      + 'layer has a well screen whose bottom is below the bottom of the grid.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FBottomTooLowErrors);
  end;
  if FInactiveVarticalCellErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + FVertLayerName
      + 'layer has a well screen that intersects an inactive cell.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FInactiveVarticalCellErrors);
  end;
  if FInvalidLossTypeVerticalErrors.Count > 0 then
  begin
    ErrorString := 'In one or more multi-node wells on the '
      + FVertLayerName
      + ' layer, a well has more than one cell but the LOSSTYPE '
      + 'is specified as "NONE".';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FInvalidLossTypeVerticalErrors);
  end;
end;

procedure TMnw2Writer.ReportErrors(WellLayerName: string);
var
  ErrorString: string;
begin
  if FNotInGridVertContourErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + WellLayerName
      + 'layer are not on the grid. These contours will be skipped.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('X,Y locations of contours.');
    ErrorMessages.AddStrings(FNotInGridVertContourErrors);
    FNotInGridVertContourErrors.Clear;
  end;
  if FInvalidLossTypeErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + WellLayerName
      + 'layer have values of LossType that are invalid.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('LossType and X,Y locations of contours.');
    ErrorMessages.AddStrings(FInvalidLossTypeErrors);
    FInvalidLossTypeErrors.Clear;
  end;
  if FRadiusToLargeErrors.Count > 0 then
  begin
    ErrorString := 'One or more contours on the ' + WellLayerName
      + 'layer have values of well radius '
      + 'that are larger than the length or width of the cell.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Row, Column.');
    ErrorMessages.AddStrings(FRadiusToLargeErrors);
    FRadiusToLargeErrors.Clear;
  end;
end;

procedure TMnw2Writer.AssignTimeVaryingData(var TimeValues: TMnwTimeValuesArray;
  const TimeIndicies: TMnwTimeIndexArray; Contour: TContourObjectOptions);
var
  TimeIndex: Integer;
  TimeCount: Integer;
  TimeVaryingData: Boolean;
begin
  TimeVaryingData := frmModflow.comboMnw2SteadyState.ItemIndex = 1;
  if TimeVaryingData then
  begin
    TimeCount := Dis.NPER;
  end
  else
  begin
    TimeCount := 1;
  end;
  SetLength(TimeValues, TimeCount);
  for TimeIndex := 0 to TimeCount - 1 do
  begin
    AssignValuesForAStressPeriod(Contour, TimeValues[TimeIndex],
      TimeIndicies[TimeIndex]);
  end;
end;

procedure TMnw2Writer.AssignValuesForAStressPeriod(Contour: TContourObjectOptions;
  var Values: TMnwTimeValues; Indicies: TMnwTimeIndicies);
begin
  Values.Active := Contour.GetBoolParameter(ModelHandle, Indicies.ActiveIndex);
  Values.PumpingRate := Contour.GetFloatParameter(ModelHandle,
    Indicies.PumpingRateIndex);
  if Indicies.HeadCapacityMultiplierIndex >= 0 then
  begin
    Values.HeadCapacityMultiplier := Contour.GetFloatParameter(ModelHandle,
      Indicies.HeadCapacityMultiplierIndex);
  end;
  if Indicies.LimitingWaterLevelIndex >= 0 then
  begin
    Values.PumpLimits.LimitingWaterLevel := Contour.GetFloatParameter(ModelHandle,
      Indicies.LimitingWaterLevelIndex);
  end;
  if Indicies.PumpingLimitTypeIndex >= 0 then
  begin
    Values.PumpLimits.PumpingLimitType := Contour.GetIntegerParameter(ModelHandle,
      Indicies.PumpingLimitTypeIndex);
  end;
  if Indicies.InactivationPumpingRateIndex >= 0 then
  begin
    Values.PumpLimits.InactivationPumpingRate := Contour.GetFloatParameter(ModelHandle,
      Indicies.InactivationPumpingRateIndex);
  end;
  if Indicies.ReactivationPumpingRateIndex >= 0 then
  begin
    Values.PumpLimits.ReactivationPumpingRate := Contour.GetFloatParameter(ModelHandle,
      Indicies.ReactivationPumpingRateIndex);
  end;
  if Indicies.ConcentrationIndex >= 0 then
  begin
    Values.Concentration := Contour.GetFloatParameter(ModelHandle,
      Indicies.ConcentrationIndex);
  end;
  if Indicies.IfaceIndex >= 0 then
  begin
    Values.IFACE := Contour.GetIntegerParameter(ModelHandle,
      Indicies.IfaceIndex);
  end;
end;

procedure TMnw2Writer.AssignWellScreens(Well: TVerticalMnw2Well;
  Contour: TContourObjectOptions);
var
  ScreenIndex: Integer;
  InvalidScreen: Boolean;
  X: ANE_DOUBLE;
  Y: ANE_DOUBLE;
  TopLayer: Integer;
  BottomLayer: Integer;
  LayerIndex: Integer;
  AnElevation: ANE_DOUBLE;
  TopTooHigh: Boolean;
  BotomTooLow: Boolean;
  InactiveCell: Boolean;
begin
  Well.VertSteadyValues.NodeCount := Abs(Contour.GetIntegerParameter(ModelHandle,
    FVerticalIndicies.NodeCountIndex));
  SetLength(Well.WellScreens, Well.VertSteadyValues.NodeCount);
  InvalidScreen := False;
  TopTooHigh := False;
  BotomTooLow := False;
  InactiveCell := False;
  for ScreenIndex := 0 to Well.VertSteadyValues.NodeCount - 1 do
  begin
    Well.WellScreens[ScreenIndex].TopWellScreen :=
      Contour.GetFloatParameter(ModelHandle,
      FWellScreenIndicies[ScreenIndex].TopWellScreenIndex);
    Well.WellScreens[ScreenIndex].BottomWellScreen :=
      Contour.GetFloatParameter(ModelHandle,
      FWellScreenIndicies[ScreenIndex].BottomWellScreenIndex);
    if Well.WellScreens[ScreenIndex].TopWellScreen <=
      Well.WellScreens[ScreenIndex].BottomWellScreen then
    begin
      InvalidScreen := True;
    end
    else if Well.WellScreens[ScreenIndex].TopWellScreen
      > DIS.Elevations[Well.Column-1, Well.Row-1, 0] then
    begin
      TopTooHigh := True;
    end     
    else if Well.WellScreens[ScreenIndex].BottomWellScreen
      < DIS.Elevations[Well.Column-1, Well.Row-1, DIS.NUNITS] then
    begin
      BotomTooLow := True;
    end     
    else
    begin
      TopLayer := 0;
      BottomLayer := DIS.NUNITS;
      for LayerIndex := TopLayer to BottomLayer do
      begin
        AnElevation := DIS.Elevations[Well.Column-1, Well.Row-1, LayerIndex];
        if Well.WellScreens[ScreenIndex].TopWellScreen <= AnElevation then
        begin
          TopLayer := LayerIndex;
          break;
        end;
      end;
      for LayerIndex := TopLayer to BottomLayer do
      begin
        AnElevation := DIS.Elevations[Well.Column-1, Well.Row-1, LayerIndex];
        if Well.WellScreens[ScreenIndex].BottomWellScreen >= AnElevation then
        begin
          BottomLayer := LayerIndex;
          break;
        end;
      end;
      for LayerIndex := TopLayer to BottomLayer - 1 do
      begin
        if Bas.IBOUND[Well.Column-1, Well.Row-1, LayerIndex] = 0 then
        begin
          InactiveCell := True;
        end;
      end;
    end;
  end;
  if InvalidScreen or TopTooHigh or BotomTooLow or InactiveCell then
  begin
    Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
    if InvalidScreen then
    begin
      FInvalidWellScreenErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
    end;
    if TopTooHigh then
    begin
      FTopTooHighErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
    end;
    if BotomTooLow then
    begin
      FBottomTooLowErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
    end;
    if InactiveCell then
    begin
      FInactiveVarticalCellErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
    end;

  end;
end;

procedure TMnw2Writer.AssignSteadyValues(
  SteadyIndicies: TSteadyMnw2SteadyParameterIndicies;
  Contour: TContourObjectOptions; var SteadyValues: TSteadyMnw2SteadyValues);
var
  X: ANE_DOUBLE;
  Y: ANE_DOUBLE;
  LossTypeString: string;
  PumpPosition: Integer;
  Pump: TPump;
begin
  AssignWellId(SteadyIndicies, Contour, SteadyValues);
  SteadyValues.ConstrainPumping := Contour.GetBoolParameter(ModelHandle,
    SteadyIndicies.ConstrainPumpingIndex);
  SteadyValues.PartialPenetrationFlag := Contour.GetBoolParameter(ModelHandle,
    SteadyIndicies.PartialPenetrationFlagIndex);
  SteadyValues.SpecifyPump := Contour.GetBoolParameter(ModelHandle,
    SteadyIndicies.SpecifyPumpIndex);
  SteadyValues.PumpElevation := Contour.GetFloatParameter(ModelHandle,
    SteadyIndicies.PumpElevationIndex);
  if SteadyIndicies.LimitingWaterLevelIndex >= 0 then
  begin
    SteadyValues.PumpLimits.LimitingWaterLevel := Contour.GetFloatParameter(ModelHandle,
      SteadyIndicies.LimitingWaterLevelIndex);
  end;
  if SteadyIndicies.PumpingLimitTypeIndex >= 0 then
  begin
    SteadyValues.PumpLimits.PumpingLimitType := Contour.GetIntegerParameter(ModelHandle,
      SteadyIndicies.PumpingLimitTypeIndex);
  end;
  if SteadyIndicies.InactivationPumpingIndex >= 0 then
  begin
    SteadyValues.PumpLimits.InactivationPumpingRate := Contour.GetFloatParameter(ModelHandle,
      SteadyIndicies.InactivationPumpingIndex);
  end;
  if SteadyIndicies.ReactivationPumpingIndex >= 0 then
  begin
    SteadyValues.PumpLimits.ReactivationPumpingRate := Contour.GetFloatParameter(ModelHandle,
      SteadyIndicies.ReactivationPumpingIndex);
  end;
  if SteadyIndicies.LossTypeIndex >= 0 then
  begin
    LossTypeString := UpperCase(Trim(Contour.GetStringParameter(ModelHandle,
      SteadyIndicies.LossTypeIndex)));
    if LossTypeString = 'NONE' then
    begin
      SteadyValues.LossType := ltNone;
    end
    else if LossTypeString = 'THIEM' then
    begin
      SteadyValues.LossType := ltThiem;
      if SteadyIndicies.WellRadiusIndex < 0 then
      begin
        Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
        FInvalidLossTypeErrors.Add(LossTypeString + ' '
          + FloatToStr(X) + ', ' + FloatToStr(Y));
      end;
    end
    else if LossTypeString = 'SKIN' then
    begin
      SteadyValues.LossType := ltSkin;
      if (SteadyIndicies.WellRadiusIndex < 0)
        or (SteadyIndicies.SkinRadiusIndex < 0)
        or (SteadyIndicies.SkinKIndex < 0) then
      begin
        Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
        FInvalidLossTypeErrors.Add(LossTypeString + ' '
          + FloatToStr(X) + ', ' + FloatToStr(Y));
      end;
    end
    else if LossTypeString = 'GENERAL' then
    begin
      SteadyValues.LossType := ltGeneral;
      if (SteadyIndicies.WellRadiusIndex < 0)
        or (SteadyIndicies.BIndex < 0)
        or (SteadyIndicies.CIndex < 0)
        or (SteadyIndicies.PIndex < 0) then
      begin
        Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
        FInvalidLossTypeErrors.Add(LossTypeString + ' '
          + FloatToStr(X) + ', ' + FloatToStr(Y));
      end;
    end
    else if LossTypeString = 'SPECIFYCWC' then
    begin
      SteadyValues.LossType := ltSpecifyCwc;
      if SteadyIndicies.CellToWellConductanceIndex < 0 then
      begin
        Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
        FInvalidLossTypeErrors.Add(LossTypeString + ' '
          + FloatToStr(X) + ', ' + FloatToStr(Y));
      end;
    end
    else
    begin
      SteadyValues.LossType := ltNone;
      Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
      FInvalidLossTypeErrors.Add(LossTypeString + ' '
        + FloatToStr(X) + ', ' + FloatToStr(Y));
    end;
  end;
  AssignWellCharacteristics(SteadyValues, Contour, SteadyIndicies);
  if (SteadyValues.LossType in [ltThiem, ltSkin, ltGeneral])
    and (SteadyValues.WellRadius < 0) then
  begin
    Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
    FInvalidWellRadiusErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
  end;
  if SteadyIndicies.PumpTypeIndex >= 0 then
  begin
    SteadyValues.PumpType := Trim(Contour.GetStringParameter(ModelHandle,
      SteadyIndicies.PumpTypeIndex));
    PumpPosition := FPumpSortedList.IndexOf(SteadyValues.PumpType);
    if PumpPosition < 0 then
    begin
      SteadyValues.PUMPCAP := 0;
    end
    else
    begin
      Pump := FPumpSortedList.Objects[PumpPosition] as TPump;
      SteadyValues.PUMPCAP := Length(Pump.LiftTable);
    end;
  end;
  if SteadyIndicies.DischargeElevationIndex >= 0 then
  begin
    SteadyValues.DischargeElevation := Contour.GetFloatParameter(ModelHandle,
      SteadyIndicies.DischargeElevationIndex);
  end;
  if SteadyIndicies.MonitorWellIndex >= 0 then
  begin
    SteadyValues.MonitorWell := Contour.GetBoolParameter(ModelHandle,
      SteadyIndicies.MonitorWellIndex);
  end
  else
  begin
    SteadyValues.MonitorWell := False;
  end;
  if SteadyIndicies.MonitorExternalFlowsIndex >= 0 then
  begin
    SteadyValues.MonitorExternalFlows := Contour.GetBoolParameter(ModelHandle,
      SteadyIndicies.MonitorExternalFlowsIndex);
  end
  else
  begin
    SteadyValues.MonitorExternalFlows := False;
  end;

  if SteadyIndicies.MonitorInternalFlowsIndex >= 0 then
  begin
    SteadyValues.MonitorInternalFlows := Contour.GetBoolParameter(ModelHandle,
      SteadyIndicies.MonitorInternalFlowsIndex);
  end
  else
  begin
    SteadyValues.MonitorInternalFlows := False;
  end;


  if SteadyIndicies.MonitorConcentrationsIndex >= 0 then
  begin
    SteadyValues.MonitorConcentrations := Contour.GetIntegerParameter(ModelHandle,
      SteadyIndicies.MonitorConcentrationsIndex);
  end
  else
  begin
    SteadyValues.MonitorConcentrations := -1;
  end;

  if SteadyValues.MonitorWell
    or SteadyValues.MonitorExternalFlows
    or SteadyValues.MonitorInternalFlows
    or (SteadyValues.MonitorConcentrations in [0..3]) then
  begin
    Inc(FMonitoringWellCount);
  end;
end;

procedure TMnw2Writer.Evaluate;
begin
  ReadPumps;
  ChooseLayersToUse;
  GetLayersAndParameterIndicies;
  FMonitoringWellCount := 0;
  EvaluateVerticalWells;
  if not ContinueExport then
    Exit;
  EvaluateGeneralWells;
  if not ContinueExport then
    Exit;
end;

procedure TMnw2Writer.EvaluateGeneralContour(ContourIndex: ANE_INT32);
var
  CellCount: ANE_INT32;
  Contour: TContourObjectOptions;
  Well: TGeneralMnw2WellSection;
  X: ANE_DOUBLE;
  Y: ANE_DOUBLE;
  CellIndex: Integer;
  Cell: TWellCell;
begin
  Contour := TContourObjectOptions.Create(ModelHandle, MNW2_GeneralLayer.LayerHandle,
    ContourIndex);
  try
    if Contour.ContourType(ModelHandle) = ctClosed then
    begin
      Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
      FClosedContourErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
      Exit;
    end;

    CellCount := GGetCountOfACellList(ContourIndex);
    if CellCount = 0 then
    begin
      Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
      FNotInGridVertContourErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
      Exit;
    end;

    Well := TGeneralMnw2WellSection.Create;
    FGeneralWellSections.Add(Well);
    AssignGeneralSteadyValues(Well.GeneralSteadyValues, Contour);
    AssignGeneralCells(ContourIndex, Well, CellCount);
    if Well.GeneralSteadyValues.Order = 1 then
    begin
      AssignSteadyValues(FGeneralSteadyIndicies, Contour, Well.SteadyValues);
      AssignTimeVaryingData(Well.TimeValues, FGeneralTimeIndicies, Contour);
    end
    else
    begin
      AssignWellId(FGeneralSteadyIndicies, Contour, Well.SteadyValues);
      AssignWellCharacteristics(Well.SteadyValues, Contour, FGeneralSteadyIndicies);
      if (Well.SteadyValues.LossType in [ltThiem, ltSkin, ltGeneral])
        and (Well.SteadyValues.WellRadius < 0) then
      begin
        Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
        FInvalidWellRadiusErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
      end;
    end;

    if Well.SteadyValues.LossType in [ltThiem, ltSkin, ltGeneral] then
    begin
      for CellIndex := 0 to Well.FCells.Count - 1 do
      begin
        Cell := Well.FCells[CellIndex];
        if (Well.SteadyValues.WellRadius > Dis.DELC[Cell.Row -1])
          or (Well.SteadyValues.WellRadius > Dis.DELR[Cell.Column -1]) then
        begin
          FRadiusToLargeErrors.Add(IntToStr(Cell.Row) + ', ' + IntToStr(Cell.Column));
        end;
      end;
    end;

  finally
    Contour.Free;
  end;

end;

procedure TMnw2Writer.EvaluateVerticalContour(ContourIndex: ANE_INT32);
var
  CellCount: ANE_INT32;
  Contour: TContourObjectOptions;
  X: ANE_DOUBLE;
  Y: ANE_DOUBLE;
  Well: TVerticalMnw2Well;
  ScreenIndex: Integer;
  AScreen: TWellScreenValues;
  ALayer: Integer;
  MultipleLayers: Boolean;
begin
  Contour := TContourObjectOptions.Create(ModelHandle, MNW2_VertLayer.LayerHandle,
    ContourIndex);
  try
    if Contour.ContourType(ModelHandle) <> ctPoint then
    begin
      Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
      FNonPointVertContourErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
      Exit;
    end;

    CellCount := GGetCountOfACellList(ContourIndex);
    if CellCount = 0 then
    begin
      Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
      FNotInGridVertContourErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
      Exit;
    end;

    Well := TVerticalMnw2Well.Create;
    FVerticalWells.Add(Well);

    Well.Row := GGetCellRow(ContourIndex, 0);
    Well.Column := GGetCellColumn(ContourIndex, 0);

    AssignSteadyValues(FVerticalSteadyIndicies, Contour, Well.SteadyValues);
    AssignWellScreens(Well, Contour);
    AssignTimeVaryingData(Well.TimeValues, FVerticalTimeIndicies, Contour);

    if (Well.SteadyValues.LossType = ltNone) then
    begin
      MultipleLayers := False;
      if Length(Well.WellScreens) > 0 then
      begin
        AScreen := Well.WellScreens[0];
        ALayer := Dis.ElevationToLayer(Well.Column, Well.Row,
          AScreen.TopWellScreen);
        for ScreenIndex := 0 to Length(Well.WellScreens) - 1 do
        begin
          AScreen := Well.WellScreens[ScreenIndex];
          if ALayer <> Dis.ElevationToLayer(Well.Column, Well.Row,
            AScreen.TopWellScreen) then
          begin
            MultipleLayers := True;
            break;
          end;
          if ALayer <> Dis.ElevationToLayer(Well.Column, Well.Row,
            AScreen.BottomWellScreen) then
          begin
            MultipleLayers := True;
            break;
          end;
        end;
      end;
      if MultipleLayers then
      begin
        Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);
        FInvalidLossTypeVerticalErrors.Add(FloatToStr(X) + ', ' + FloatToStr(Y));
      end;
    end;

    if Well.SteadyValues.LossType in [ltThiem, ltSkin, ltGeneral] then
    begin
      if (Well.SteadyValues.WellRadius > Dis.DELC[Well.Row -1])
        or (Well.SteadyValues.WellRadius > Dis.DELR[Well.Column -1]) then
      begin
        FRadiusToLargeErrors.Add(IntToStr(Well.Row) + ', ' + IntToStr(Well.Column));
      end;
    end;

  finally
    Contour.Free;
  end;
end;

procedure TMnw2Writer.ChooseLayersToUse;
begin
  FUseVerticalLayers := frmModflow.rgMnw2WellType.ItemIndex in [0,2];
  FUseGeneralLayers := frmModflow.rgMnw2WellType.ItemIndex in [1,2];
end;

procedure TMnw2Writer.GetLayersAndParameterIndicies;
var
  MaxWellScreens: Integer;
  ScreenIndex: Integer;
  NumberOfTimes: Integer;
  TimeIndex: Integer;
begin
  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  if FUseVerticalLayers then
  begin
    FVertLayerName := ModflowTypes.GetMFMNW2_VerticalWellLayerType.WriteNewRoot;
    MNW2_VertLayer := TLayerOptions.CreateWithName(FVertLayerName, ModelHandle);
    SetSteadyIndicies(MNW2_VertLayer, FVerticalSteadyIndicies);
    SetVertIndicies;
    MaxWellScreens := StrToInt(frmMODFLOW.adeMnw2WellScreens.Text);
    SetLength(FWellScreenIndicies, MaxWellScreens);
    for ScreenIndex := 0 to MaxWellScreens - 1 do
    begin
      SetWellScreenIndicies(ScreenIndex, FWellScreenIndicies[ScreenIndex]);
    end;
    SetLength(FVerticalTimeIndicies, NumberOfTimes);
    for TimeIndex := 0 to NumberOfTimes - 1 do
    begin
      SetTimeIndicies(MNW2_VertLayer, TimeIndex, FVerticalTimeIndicies[TimeIndex]);
    end;
  end;
  if FUseGeneralLayers then
  begin
    FGeneralLayerName := ModflowTypes.GetMFMNW2_GeneralWellLayerType.WriteNewRoot;
    MNW2_GeneralLayer := TLayerOptions.CreateWithName(FGeneralLayerName, ModelHandle);
    SetSteadyIndicies(MNW2_GeneralLayer, FGeneralSteadyIndicies);
    SetGeneralIndicies;
    SetLength(FGeneralTimeIndicies, NumberOfTimes);
    for TimeIndex := 0 to NumberOfTimes - 1 do
    begin
      SetTimeIndicies(MNW2_GeneralLayer, TimeIndex, FGeneralTimeIndicies[TimeIndex]);
    end;
  end;
end;

procedure TMnw2Writer.SetGeneralIndicies;
begin
  FGeneralIndicies.OrderIndex := MNW2_GeneralLayer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_OrderParamType.ANE_ParamName);
  FGeneralIndicies.UpperElevIndex := MNW2_GeneralLayer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_UpperElevParamType.ANE_ParamName);
  FGeneralIndicies.LowerElevIndex := MNW2_GeneralLayer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_LowerElevParamType.ANE_ParamName);
end;

procedure TMnw2Writer.SetSteadyIndicies(const Layer: TLayerOptions;
  var Indicies: TSteadyMnw2SteadyParameterIndicies);
var
  LossTypeChoices: TMnw2LossTypeSet;
begin
  Indicies.WellIdIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_WellIdParamType.ANE_ParamName);

  Indicies.ConstrainPumpingIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_ConstrainPumpingParamType.ANE_ParamName);

  Indicies.PartialPenetrationFlagIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_PartialPenetrationFlagParamType.ANE_ParamName);

  Indicies.SpecifyPumpIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_SpecifyPumpParamType.ANE_ParamName);

  Indicies.PumpElevationIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_PumpElevationParamType.ANE_ParamName);

  if frmModflow.cbMnw2Pumpcap.Checked
    and not frmModflow.cbMnw2TimeVarying.Checked then
  begin
    Indicies.LimitingWaterLevelIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType.ANE_ParamName);

    Indicies.PumpingLimitTypeIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType.ANE_ParamName);

    Indicies.InactivationPumpingIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType.ANE_ParamName);

    Indicies.ReactivationPumpingIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.LimitingWaterLevelIndex := -1;
    Indicies.PumpingLimitTypeIndex := -1;
    Indicies.InactivationPumpingIndex := -1;
    Indicies.ReactivationPumpingIndex := -1;
  end;

  LossTypeChoices := frmMODFLOW.Mnw2LossTypeChoices;
  if LossTypeChoices <> [] then
  begin
    Indicies.LossTypeIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_LossTypeParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.LossTypeIndex := -1;
  end;

  if ([ltcThiem, ltcSkin, ltcGeneral] * LossTypeChoices) <> [] then
  begin
    Indicies.WellRadiusIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_WellRadiusParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.WellRadiusIndex := -1;
  end;
  if ltcSkin in LossTypeChoices then
  begin
    Indicies.SkinRadiusIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_SkinRadiusParamType.ANE_ParamName);
    Indicies.SkinKIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_SkinKParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.SkinRadiusIndex := -1;
    Indicies.SkinKIndex := -1;
  end;
  if ltcGeneral in LossTypeChoices then
  begin
    Indicies.BIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_BParamType.ANE_ParamName);
    Indicies.CIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_CParamType.ANE_ParamName);
    Indicies.PIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_PParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.BIndex := -1;
    Indicies.CIndex := -1;
    Indicies.PIndex := -1;
  end;
  if ltcSpecify in LossTypeChoices then
  begin
    Indicies.CellToWellConductanceIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_CellToWellConductanceParamType.ANE_ParamName);
  end;

  if frmMODFLOW.cbMnw2Pumpcap.Checked then
  begin
    Indicies.PumpTypeIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_PumpTypeParamType.ANE_ParamName);
    Indicies.DischargeElevationIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_DischargeElevationParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.PumpTypeIndex := -1;
    Indicies.DischargeElevationIndex := -1;
  end;

  if frmMODFLOW.cbMnwi.Checked then
  begin
  Indicies.MonitorWellIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_MonitorWellFlowParamType.ANE_ParamName);
  Indicies.MonitorExternalFlowsIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_MonitorExternalFlowParamType.ANE_ParamName);
  Indicies.MonitorInternalFlowsIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_MonitorInternalFlowParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.MonitorWellIndex := -1;
    Indicies.MonitorExternalFlowsIndex := -1;
    Indicies.MonitorInternalFlowsIndex := -1;
  end;
  if frmMODFLOW.cbMnwi.Checked and frmModflow.cbMOC3D.Checked then
  begin
    Indicies.MonitorConcentrationsIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_MonitorConcentrationParamType.ANE_ParamName);
  end
  else
  begin
    Indicies.MonitorConcentrationsIndex := -1;
  end;
end;

procedure TMnw2Writer.SetTimeIndicies(const Layer: TLayerOptions;
  const TimeIndex: integer; var Indicies: TMnwTimeIndicies);
var
  TimeString: string;
begin
  TimeString := IntToStr(TimeIndex + 1);
  Indicies.ActiveIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_ActiveParamType.ANE_ParamName + TimeString);
  Assert(Indicies.ActiveIndex >= 0);

  Indicies.PumpingRateIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_PumpingRateParamType.ANE_ParamName + TimeString);
  Assert(Indicies.PumpingRateIndex >= 0);

  if frmModflow.cbMnw2Pumpcap.Checked then
  begin
    Indicies.HeadCapacityMultiplierIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_HeadCapacityMultiplierParamType.ANE_ParamName
      + TimeString);
    Assert(Indicies.HeadCapacityMultiplierIndex >= 0);
  end
  else
  begin
    Indicies.HeadCapacityMultiplierIndex := -1;
  end;

  if frmModflow.cbMnw2Pumpcap.Checked
    and frmModflow.cbMnw2TimeVarying.Checked then
  begin
    Indicies.LimitingWaterLevelIndex :=
      Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_LimitingWaterLevelParamType.ANE_ParamName
      + TimeString);
    Assert(Indicies.LimitingWaterLevelIndex >= 0);
    Indicies.PumpingLimitTypeIndex :=
      Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_PumpingLimitTypeParamType.ANE_ParamName
      + TimeString);
    Assert(Indicies.PumpingLimitTypeIndex >= 0);
    Indicies.InactivationPumpingRateIndex :=
      Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_InactivationPumpingRateParamType.ANE_ParamName
      + TimeString);
    Assert(Indicies.InactivationPumpingRateIndex >= 0);
    Indicies.ReactivationPumpingRateIndex :=
      Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMF_MNW2_ReactivationPumpingRateParamType.ANE_ParamName
      + TimeString);
    Assert(Indicies.ReactivationPumpingRateIndex >= 0);
  end
  else
  begin
    Indicies.LimitingWaterLevelIndex := -1;
    Indicies.PumpingLimitTypeIndex := -1;
    Indicies.InactivationPumpingRateIndex := -1;
    Indicies.ReactivationPumpingRateIndex := -1;
  end;

  if frmModflow.cbMOC3D.Checked then
  begin
    Indicies.ConcentrationIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMFConcentrationParamType.ANE_ParamName + TimeString);
    Assert(Indicies.ConcentrationIndex >= 0);
  end
  else
  begin
    Indicies.ConcentrationIndex := -1;
  end;

  if frmModflow.cbMODPATH.Checked then
  begin
    Indicies.IfaceIndex := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMFIFACEParamType.ANE_ParamName + TimeString);
    Assert(Indicies.IfaceIndex >= 0);
  end
  else
  begin
    Indicies.IfaceIndex := -1;
  end;
end;

procedure TMnw2Writer.SetVertIndicies;
begin
  FVerticalIndicies.NodeCountIndex := MNW2_VertLayer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_NodeCountParamType.ANE_ParamName);
end;

procedure TMnw2Writer.SetWellScreenIndicies(Const ScreenIndex: integer;
  var Indicies: TWellScreenIndicies);
var
  ScreenString: string;
begin
  ScreenString := IntToStr(ScreenIndex+1);

  Indicies.TopWellScreenIndex := MNW2_VertLayer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_TopWellScreenParamType.ANE_ParamName + ScreenString);
    
  Indicies.BottomWellScreenIndex := MNW2_VertLayer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMF_MNW2_BottomWellScreenParamType.ANE_ParamName + ScreenString);
end;

class procedure TMnw2Writer.AssignUnitNumbers;
begin
  if frmModflow.cbOneFlowFile.Checked then
  begin
    frmModflow.GetUnitNumber('BUD');
  end
  else
  begin
    if frmModflow.cbMnw2_PrintFlows.Checked then
    begin
    end
    else if frmModflow.cbFlowMNW.Checked then
    begin
      frmModflow.GetUnitNumber('MNW2BUD');
    end;
  end;
end;

procedure TMnw2Writer.WriteDataSet1;
var
  MNWMAX: integer;
  IWL2CB: integer;
  MNWPRNT: integer;
  Comment: string;
begin
  MNWMAX := FVerticalWells.Count + FGeneralWells.Count;
  if frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbMnw2_PrintFlows.Checked then
    begin
//      IWL2CB := -1;
      IWL2CB := -frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IWL2CB := frmModflow.GetUnitNumber('BUD');
    end;
  end
  else
  begin
    if frmModflow.cbMnw2_PrintFlows.Checked then
    begin
      IWL2CB := -1;
    end
    else if frmModflow.cbFlowMNW.Checked then
    begin
      IWL2CB := frmModflow.GetUnitNumber('MNW2BUD');
    end
    else
    begin
      IWL2CB := 0;
    end;
  end;
  MNWPRNT := frmModflow.comboMnw2Output.ItemIndex;
  Comment := ' # Data set 1 MNWMAX IWL2CB MNWPRNT';
  Write(FFile, MNWMAX, ' ', IWL2CB, ' ', MNWPRNT);
  if frmModflow.cbMODPATH.Checked then
  begin
    Write(FFile, ' AUXILIARY IFACE');
    Comment := Comment + ' Option';
  end;
  Writeln(FFile, Comment);
end;

procedure TMnw2Writer.WriteDataSet2;
var
  WellIndex: Integer;
  VerticalWell: TVerticalMnw2Well;
  GeneralWell: TGeneralMnw2Well;
  WellSection: TGeneralMnw2WellSection;
  SteadyValues: TSteadyMnw2SteadyValues;
begin
  for WellIndex := 0 to FVerticalWells.Count - 1 do
  begin
    VerticalWell := FVerticalWells[WellIndex];
    WriteDataSet2AVertical(VerticalWell);
    WriteDataSet2B(VerticalWell.SteadyValues, True);
    WriteDataSet2C(VerticalWell.SteadyValues, True);
    WriteDataSet2DVertical(VerticalWell);
    WriteDataSet2eVertical(VerticalWell.SteadyValues);
    SteadyValues := VerticalWell.SteadyValues;
    WriteDataSet2f(SteadyValues);
    WriteDataSet2g_2h(SteadyValues);
  end;
  for WellIndex := 0 to FGeneralWells.Count - 1 do
  begin
    GeneralWell := FGeneralWells[WellIndex];
    WriteDataSet2AGeneral(GeneralWell);
    WellSection := GeneralWell.FWellSections[0];
    WriteDataSet2B(WellSection.SteadyValues, False);
    WriteDataSet2C(WellSection.SteadyValues, False);
    WriteDataSet2DGeneral(GeneralWell);
    WriteDataSet2eGeneral(GeneralWell);
    SteadyValues := WellSection.SteadyValues;
    WriteDataSet2f(SteadyValues);
    WriteDataSet2g_2h(SteadyValues);
  end;
  ReportWellIdErrors;
end;

{ TGeneralMnw2WellSection }

constructor TGeneralMnw2WellSection.Create;
begin
  FCells:= TObjectList.Create;
end;

destructor TGeneralMnw2WellSection.Destroy;
begin
  FCells.Free;
  inherited;
end;

{ FGeneralMnw2Well }

constructor TGeneralMnw2Well.Create;
begin
  FWellSections:= TList.Create;
end;

destructor TGeneralMnw2Well.Destroy;
begin
  FWellSections.Free;
  inherited;
end;


end.
