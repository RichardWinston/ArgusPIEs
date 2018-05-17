unit WriteDaflow;

interface

uses Sysutils, Classes, contnrs, Forms, Math, AnePIE,
  WriteModflowDiscretization, OptionsUnit;

type
  TDaflowSteadyIndicies = record
    BedElevIndex: ANE_INT32;
    BedThicknessIndex: ANE_INT32;
    BedSlopeIndex: ANE_INT32;
    BedKIndex: ANE_INT32;
    UpJunctionIndex: ANE_INT32;
    DownJunctionIndex: ANE_INT32;
    UpFlowFractionIndex: ANE_INT32;
    InitialFlowIndex: ANE_INT32;
    TortuosityIndex: ANE_INT32;
    A0Index: ANE_INT32;
    A1Index: ANE_INT32;
    A2Index: ANE_INT32;
    W1Index: ANE_INT32;
    W2Index: ANE_INT32;
    PrintIndex: ANE_INT32;
    OverridenBedElevIndex: ANE_INT32;
    OverridenInitialFlowIndex: ANE_INT32;
  end;

  TDaflowTransientIndicies = record
    TimeIndex: ANE_INT32;
    RefStressIndex: ANE_INT32;
    BoundaryFlowIndex: ANE_INT32;
    NewBoundaryIndex: ANE_INT32;
  end;

  TDaflowWriter = class(TListWriter)
  private
    ModelHandle: ANE_PTR;
    SubBranches: TObjectList;
    Branches: TObjectList;
    GridAngle: ANE_DOUBLE;
    DisWriter: TDiscretizationWriter;
    JunctionArray: array of integer;
    Times: array of double;
    NJNCT : integer;
    NHR: integer;
    JTS: integer;
    DT: double;
    InternalDT: double;
    DistanceConversionFactor: double;
    procedure Evaluate;
    procedure InitializeTimeVariables;
    procedure InitializeConversionFactor;
    procedure EvaluateUnit(const UnitIndex: integer);
    function GetSteadyIndicies(const Layer: TLayerOptions; out ElevParamName,
      InitialFlowParamName: string): TDaflowSteadyIndicies;
    function GetTransientIndicies(const Layer: TLayerOptions;
      const TimeIndex: integer): TDaflowTransientIndicies;
    procedure SortJunctions;
    procedure CombineSubBranches;
    procedure InitializeTimes;
    function GetTimeStep(const RefStressPeriod: integer; Time: double;
      const RefErrors, TimeErrors: TStringList): integer;
    procedure WriteDataGroup1;
    procedure WriteDataGroup2;
    procedure WriteDataGroup3;
    procedure WriteDaflowFile;
    Procedure WriteLink;
    class function DaflowFixedFormattedReal(const Value : double;
      const Width : integer) : string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFiles(const Root : string;
      const DiscretizationWriter : TDiscretizationWriter);
    class procedure AssignUnitNumbers;
  end;

  TSubreachRecord = record
    Column: integer;
    Row: integer;
    Layer: integer;
    BedElevation: double;
    Distance: double;
    InitialFlow: double;
  end;

  TSubBranch = class;

  TSubreach = class(TObject)
  private
    Properties: TSubreachRecord;
//    function SameCell(AReach: TSubreach): boolean;
    procedure WriteGroup2Record3(const Writer: TDaflowWriter;
      const SubBranch: TSubBranch; var StartingIndex: integer;
      const DistanceConversionFactor: double);
  end;

  TSubreachList = class(TObjectList)
  private
    function GetItem(const Index: integer): TSubreach;
    procedure Sort;
  public
    function Add(const ReachProperties: TSubreachRecord): integer;
    property Items[const Index: integer]: TSubreach read GetItem;
  end;

  TSteadyProperties = record
    BedThickness: double;
    BedSlope: double;
    BedK: double;
    UpJunction: integer;
    DownJunction: integer;
    UpFlowFraction: double;
    Tortuosity: double;
    A0: double;
    A1: double;
    A2: double;
    W1: double;
    W2: double;
    Print: boolean;
  end;

  TTransientPropertiesRecord = record
    TimeStep: integer;
    BoundaryFlow: double;
  end;

  TTransientProperties = class(TObject)
    Properties: TTransientPropertiesRecord;
  end;

  TTransientPropertiesList = class(TObjectList)
  private
    function GetItem(const Index: integer): TTransientProperties;
  public
    function Add(const TransientProperties: TTransientPropertiesRecord):
      integer;
    property Items[const Index: integer]: TTransientProperties read GetItem;
  end;

  TSubBranch = class(TObject)
  private
    SteadyProperties: TSteadyProperties;
    SubReachList: TSubreachList;
    TransientPropertiesList: TTransientPropertiesList;
    function BoundaryCount(const TimeStep: integer): integer;
    procedure GetBoundaryIndicies(const TimeStep: integer; out Below,
      Above: integer);
    procedure WriteGroup2Record3(const Writer: TDaflowWriter;
      var StartingIndex: integer; const DistanceConversionFactor: double;
      var PriorReach: TSubReach);
    procedure WriteDataGroup3Record2(const Writer: TDaflowWriter;
      const BranchNumber, PriorNodes, TimeStep: integer);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TBranch = class(TObject)
  private
    BranchNumber: integer;
    SubBranches: TList;
    function BoundaryCount(const TimeStep: integer): integer;
    procedure WriteDataGroup2(const Writer: TDaflowWriter;
      const DistanceConversionFactor: double);
    procedure WriteDataGroup3Record2(const Writer: TDaflowWriter;
      const TimeStep: integer);
    procedure WriteLink(const Writer: TDaflowWriter);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses Variables, GetCellUnit, UtilityFunctions, ModflowLayerFunctions,
  ProgressUnit, BL_SegmentUnit, CellVertexUnit, IntListUnit, ModflowUnit,
  WriteNameFileUnit;

type
  TJunctionSortObject = class(TObject)
    Junction: integer;
    Count: integer;
  end;

  { TDaflowWriter }

class procedure TDaflowWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowDaflow.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      frmModflow.GetUnitNumber('DAFLOWBUD')
    end;
  end;
end;

procedure TDaflowWriter.CombineSubBranches;
var
  OuterIndex, InnerIndex: integer;
  SubBranch, NextBranch: TSubBranch;
  Branch: TBranch;
  Temp: TList;
  Errors: TStringList;
  AString: string;
begin
  Temp := TList.Create;
  Errors := TStringList.Create;
  try
    for OuterIndex := 0 to SubBranches.Count - 1 do
    begin
      SubBranch := SubBranches[OuterIndex] as TSubBranch;
      Temp.Add(SubBranch);
      if SubBranch.SteadyProperties.UpJunction
        = SubBranch.SteadyProperties.DownJunction then
      begin
        Errors.Add(IntToStr(SubBranch.SteadyProperties.UpJunction));
      end;
    end;
    if Errors.Count > 0 then
    begin
      AString := 'In the DAFLOW package, every contour must have an Upstream '
        + 'Junction that is different from its Downstream Junction.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'The following Junctions don''t meet that criterion.';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(Errors);
    end;

    for OuterIndex := Temp.Count - 1 downto 0 do
    begin
      SubBranch := Temp[OuterIndex];
      if JunctionArray[SubBranch.SteadyProperties.UpJunction] <> 0 then
      begin
        Branch := TBranch.Create;
        Branches.Add(Branch);
        Branch.BranchNumber := Branches.Count;
        Branch.SubBranches.Add(SubBranch);
        Temp.Delete(OuterIndex);
      end;
    end;

    While Temp.Count > 0 do
    begin
      for OuterIndex := 0 to Branches.Count - 1 do
      begin
        Branch := Branches[OuterIndex] as TBranch;
        SubBranch := Branch.SubBranches[Branch.SubBranches.Count-1];
//        while JunctionArray[SubBranch.SteadyProperties.UpJunction] = 0 do
        begin
          for InnerIndex := 0 to Temp.Count - 1 do
          begin
            NextBranch := Temp[InnerIndex];
            if (SubBranch.SteadyProperties.DownJunction =
              NextBranch.SteadyProperties.UpJunction)
              and (JunctionArray[SubBranch.SteadyProperties.DownJunction] = 0) then
            begin
              Branch.SubBranches.Add(NextBranch);
              SubBranch := NextBranch;
              Temp.Delete(InnerIndex);
              break;
            end;
            if InnerIndex = Temp.Count - 1 then
            begin
              Errors.Add(IntToStr(SubBranch.SteadyProperties.DownJunction));
            end;
          end;
        end;
      end;
    end;
  finally
    Temp.Free;
    Errors.Free;
  end;
end;

constructor TDaflowWriter.Create;
begin
  inherited;
  SubBranches := TObjectList.Create;
  Branches := TObjectList.Create;
end;

class function TDaflowWriter.DaflowFixedFormattedReal(const Value: double;
  const Width: integer): string;
begin
  result := FixedFormattedReal(Value, Width);
  if Pos('.', result) <= 0 then
  begin
    result := FixedFormattedReal(Value, Width-1);
    if Pos('.', result) <= 0 then
    begin
      result := result + '.';
    end
    else
    begin
      result := ' ' + result;
    end;
  end;
end;

destructor TDaflowWriter.Destroy;
begin
  SubBranches.Free;
  Branches.Free;
  inherited;
end;

procedure TDaflowWriter.Evaluate;
var
  UnitIndex: integer;
  GridLayerName: string;
  Dummy: ANE_PTR;
begin
  frmProgress.LblActivity.Caption := 'Evaluating DAFLOW data';
  InitializeConversionFactor;
  InitializeTimes;
  InitializeTimeVariables;
  GridLayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  GetGridAngle(ModelHandle, GridLayerName, Dummy, GridAngle);
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      EvaluateUnit(UnitIndex);
    end;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
    begin
      Exit;
    end;
  end;
  SortJunctions;
  Application.ProcessMessages;
  if not ContinueExport then
  begin
    Exit;
  end;
  CombineSubBranches;
  Application.ProcessMessages;
  if not ContinueExport then
  begin
    Exit;
  end;
end;

procedure TDaflowWriter.EvaluateUnit(const UnitIndex: integer);
var
  LayerName: string;
  Layer: TLayerOptions;
  SteadyIndicies: TDaflowSteadyIndicies;
  TimeIndicies: array of TDaflowTransientIndicies;
  TimeIndex: integer;
  TimeCount: integer;
  ContourIndex: integer;
  Contour: TContourObjectOptions;
  SubBranch: TSubBranch;
  IsBedElevationOverriden: boolean;
  BedElevation: double;
  TransientProperties: TTransientPropertiesRecord;
  NewBoundary: boolean;
  CellCount: integer;
  CellIndex: integer;
  CellProperties: TSubreachRecord;
  X, Y: double;
  ElevParamName: string;
  Top, Bottom: double;
  SegmentIndex: integer;
  CellDistance, SegmentDistance: double;
  InitialFlow: double;
  OverriddenInitialFlow: boolean;
  InitialFlowParamName: string;
  Time: double;
  RefStress: integer;
  RefErrors, TimeErrors: TStringList;
  ErrorString: string;
  InternalCellDistance: double;
  ContourCount: integer;
  MinCellWidth: double;
  Index: integer;
begin
  MinCellWidth := DisWriter.DELC[0];
  for Index := 0 to Length(DisWriter.DELC) -1 do
  begin
    if MinCellWidth < DisWriter.DELC[Index] then
    begin
      MinCellWidth := DisWriter.DELC[Index];
    end;
  end;
  for Index := 0 to Length(DisWriter.DELR) -1 do
  begin
    if MinCellWidth < DisWriter.DELR[Index] then
    begin
      MinCellWidth := DisWriter.DELR[Index];
    end;
  end;

  LayerName := ModflowTypes.GetMFDaflowLayerType.ANE_LayerName
    + IntToStr(UnitIndex);
  AddVertexLayer(ModelHandle, LayerName);
  RefErrors := TStringList.Create;
  TimeErrors := TStringList.Create;
  Layer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
  try
    SteadyIndicies := GetSteadyIndicies(Layer, ElevParamName,
      InitialFlowParamName);

    TimeCount := StrToInt(frmModflow.adeDAF_BoundaryTimes.Text);
    SetLength(TimeIndicies, TimeCount);
    for TimeIndex := 1 to TimeCount do
    begin
      TimeIndicies[TimeIndex - 1] := GetTransientIndicies(Layer, TimeIndex);
    end;

    ContourCount := Layer.NumObjects(ModelHandle, pieContourObject);
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := ContourCount;
    for ContourIndex := 0 to ContourCount -1 do
    begin
      Contour := TContourObjectOptions.Create(ModelHandle, Layer.LayerHandle,
        ContourIndex);
      try
        SubBranch := TSubBranch.Create;
        SubBranches.Add(SubBranch);

        SubBranch.SteadyProperties.BedThickness := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.BedThicknessIndex);
        SubBranch.SteadyProperties.BedSlope := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.BedSlopeIndex);
        SubBranch.SteadyProperties.BedK := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.BedKIndex);
        // CND in DAFLOW is always in Length/seconds so convert to
        // units used by DAFLOW.
        case frmModflow.comboTimeUnits.ItemIndex of
          0: // Undefined
            begin
            end;
          1: // Seconds
            begin
            end;
          2: // Minutes
            begin
              SubBranch.SteadyProperties.BedK :=
                SubBranch.SteadyProperties.BedK/60;
            end;
          3: // Hours
            begin
              SubBranch.SteadyProperties.BedK :=
                SubBranch.SteadyProperties.BedK/3600;
            end;
          4: // Days
            begin
              SubBranch.SteadyProperties.BedK :=
                SubBranch.SteadyProperties.BedK/3600/24;
            end;
          5: // Years
            begin
              SubBranch.SteadyProperties.BedK :=
                SubBranch.SteadyProperties.BedK/3600/24/365.25;
            end;
        else
          begin
            Assert(False);
          end;
        end;

        SubBranch.SteadyProperties.UpJunction := Contour.GetIntegerParameter(
          ModelHandle, SteadyIndicies.UpJunctionIndex);
        SubBranch.SteadyProperties.DownJunction := Contour.GetIntegerParameter(
          ModelHandle, SteadyIndicies.DownJunctionIndex);
        SubBranch.SteadyProperties.UpFlowFraction := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.UpFlowFractionIndex);
        SubBranch.SteadyProperties.Tortuosity := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.TortuosityIndex);
        SubBranch.SteadyProperties.A0 := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.A0Index);
        SubBranch.SteadyProperties.A1 := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.A1Index);
        SubBranch.SteadyProperties.A2 := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.A2Index);
        SubBranch.SteadyProperties.W1 := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.W1Index);
        SubBranch.SteadyProperties.W2 := Contour.GetFloatParameter(
          ModelHandle, SteadyIndicies.W2Index);
        SubBranch.SteadyProperties.Print := Contour.GetBoolParameter(
          ModelHandle, SteadyIndicies.PrintIndex);
        OverriddenInitialFlow := Contour.GetBoolParameter(
          ModelHandle, SteadyIndicies.OverridenInitialFlowIndex);
        InitialFlow := 0;
        if OverriddenInitialFlow then
        begin
          InitialFlow := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.InitialFlowIndex);
        end;

        BedElevation := 0;
        IsBedElevationOverriden := Contour.GetBoolParameter(
          ModelHandle, SteadyIndicies.OverridenBedElevIndex);
        if IsBedElevationOverriden then
        begin
          BedElevation := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.BedElevIndex);
        end;

        for TimeIndex := 0 to TimeCount - 1 do
        begin
          NewBoundary := Contour.GetBoolParameter(
            ModelHandle, TimeIndicies[TimeIndex].NewBoundaryIndex);
          if NewBoundary then
          begin
            Time := Contour.GetFloatParameter(
              ModelHandle, TimeIndicies[TimeIndex].TimeIndex);
            RefStress := Contour.GetIntegerParameter(
              ModelHandle, TimeIndicies[TimeIndex].RefStressIndex);
            TransientProperties.TimeStep := GetTimeStep(RefStress, Time,
              RefErrors, TimeErrors);
            TransientProperties.BoundaryFlow := Contour.GetFloatParameter(
              ModelHandle, TimeIndicies[TimeIndex].BoundaryFlowIndex);
            SubBranch.TransientPropertiesList.Add(TransientProperties);
          end
          else
          begin
            break;
          end;
        end;

        CellCount := GGetCountOfACellList(ContourIndex);
        for CellIndex := 0 to CellCount - 1 do
        begin
          if not ContinueExport then
            break;
          CellProperties.Row := GGetCellRow(ContourIndex, CellIndex);
          CellProperties.Column := GGetCellColumn(ContourIndex, CellIndex);
          Top := DisWriter.Elevations[CellProperties.Column - 1,
            CellProperties.Row - 1, UnitIndex - 1];
          Bottom := DisWriter.Elevations[CellProperties.Column - 1,
            CellProperties.Row - 1, UnitIndex];
          CellDistance := GGetCellDistanceOnContourBeforeCell(ContourIndex,
            CellIndex);
          SegmentDistance := 0;
          if IsBedElevationOverriden then
          begin
            CellProperties.BedElevation := BedElevation;
            CellProperties.Layer := frmModflow.ModflowLayer
              (UnitIndex, Top, Bottom, CellProperties.BedElevation);
          end;
          if OverriddenInitialFlow then
          begin
            CellProperties.InitialFlow := InitialFlow;
          end;

          for SegmentIndex := 0 to GGetSegmentCount(ContourIndex, CellIndex) - 1
            do
          begin
            if not IsBedElevationOverriden or not OverriddenInitialFlow then
            begin
              GetRotatedSegmentCenter(ContourIndex, CellIndex, SegmentIndex, X,
                Y);
              RotatePointsFromGrid(X, Y, GridAngle);
              if not IsBedElevationOverriden then
              begin
                CellProperties.BedElevation := Layer.RealValueAtXY(ModelHandle,
                  X, Y, ElevParamName);
                CellProperties.Layer := frmModflow.ModflowLayer
                  (UnitIndex, Top, Bottom, CellProperties.BedElevation);
              end;
              if not OverriddenInitialFlow then
              begin
                CellProperties.InitialFlow := Layer.RealValueAtXY(ModelHandle,
                  X, Y, InitialFlowParamName);
              end;

            end;
            InternalCellDistance := GGetCellSegmentLength(
              ContourIndex, CellIndex, SegmentIndex);
            SegmentDistance := SegmentDistance + InternalCellDistance;
            CellProperties.Distance := (CellDistance + SegmentDistance)
              * SubBranch.SteadyProperties.Tortuosity
              * DistanceConversionFactor;
            if InternalCellDistance * //DistanceConversionFactor *
              SubBranch.SteadyProperties.Tortuosity/MinCellWidth > 0.001 then
            begin
              SubBranch.SubReachList.Add(CellProperties);
            end;
          end;
        end;
        CellCount := GGetCountOfAnOutsideCellList(ContourIndex);
        for CellIndex := 0 to CellCount - 1 do
        begin
          if not ContinueExport then
            break;
          CellProperties.Row := 0;
          CellProperties.Column := 0;
          CellProperties.Layer := 0;
          if IsBedElevationOverriden then
          begin
            CellProperties.BedElevation := BedElevation;
          end;
          CellDistance :=
            GGetCellDistanceOnContourBeforeOutsideCell(ContourIndex, CellIndex);
          SegmentDistance := 0;
          for SegmentIndex := 0 to GGetOutsideSegmentCount(ContourIndex, CellIndex) - 1
            do
          begin
            if not IsBedElevationOverriden or not OverriddenInitialFlow then
            begin
              GetRotatedOutsideSegmentCenter(ContourIndex, CellIndex, SegmentIndex, X,
                Y);
              RotatePointsFromGrid(X, Y, GridAngle);
              if not IsBedElevationOverriden then
              begin
                CellProperties.BedElevation := Layer.RealValueAtXY(ModelHandle,
                  X, Y, ElevParamName);
              end;
              if not OverriddenInitialFlow then
              begin
                CellProperties.InitialFlow := Layer.RealValueAtXY(ModelHandle,
                  X, Y, InitialFlowParamName);
              end;
            end;
            InternalCellDistance := GGetOutsideCellSegmentLength(
              ContourIndex, CellIndex, SegmentIndex);
            SegmentDistance := SegmentDistance + InternalCellDistance;
            CellProperties.Distance := (CellDistance + SegmentDistance)
              * SubBranch.SteadyProperties.Tortuosity
              * DistanceConversionFactor;
            if InternalCellDistance * //DistanceConversionFactor *
              SubBranch.SteadyProperties.Tortuosity/MinCellWidth > 0.001 then
            begin
              SubBranch.SubReachList.Add(CellProperties);
            end;
          end;
        end;
        SubBranch.SubReachList.Sort;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then
        begin
          Exit;
        end;
      finally
        Contour.Free;
      end;
    end;
    if RefErrors.Count > 0 then
    begin
      ErrorString := 'In DAFLOW, the Reference stress period for boundary '
        + 'conditions must always be '
        + 'greater than or equal to 1 and less than or equal to the number of '
        + 'stress periods.';
      frmProgress.reErrors.Lines.Add(ErrorString);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);

      ErrorString := 'The following reference stress periods do not meet '
        + 'this criterion.';
      ErrorMessages.Add(ErrorString);

      ErrorMessages.AddStrings(RefErrors);
    end;
    if TimeErrors.Count > 0 then
    begin
      ErrorString := 'In DAFLOW, the time for boundary conditions must always '
        + 'be greater than or equal to 0.';
      frmProgress.reErrors.Lines.Add(ErrorString);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);

      ErrorString := 'The following times do not meet this criterion.';
      ErrorMessages.Add(ErrorString);

      ErrorMessages.AddStrings(TimeErrors);
    end;


  finally
    Layer.Free(ModelHandle);
    RefErrors.Free;
    TimeErrors.Free;
  end;
end;

function TDaflowWriter.GetSteadyIndicies(const Layer: TLayerOptions;
  out ElevParamName, InitialFlowParamName: string): TDaflowSteadyIndicies;
var
  ParameterName: string;
begin
  ParameterName :=
    ModflowTypes.GetMFDaflowBedElevationParamClassType.ANE_ParamName;
  result.BedElevIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.BedElevIndex > -1);
  ElevParamName := ParameterName;

  ParameterName :=
    ModflowTypes.GetMFDaflowBedThicknessParamClassType.ANE_ParamName;
  result.BedThicknessIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.BedThicknessIndex > -1);

  ParameterName := ModflowTypes.GetMFDaflowBedSlopeParamClassType.ANE_ParamName;
  result.BedSlopeIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.BedSlopeIndex > -1);

  ParameterName :=
    ModflowTypes.GetMFDaflowBedHydraulicConductivityParamClassType.ANE_ParamName;
  result.BedKIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.BedKIndex > -1);

  ParameterName :=
    ModflowTypes.GetMFDaflowUpstreamJunctionParamClassType.ANE_ParamName;
  result.UpJunctionIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.UpJunctionIndex > -1);

  ParameterName :=
    ModflowTypes.GetMFDaflowDownstreamJunctionParamClassType.ANE_ParamName;
  result.DownJunctionIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.DownJunctionIndex > -1);

  ParameterName :=
    ModflowTypes.GetMFDaflowUpstreamFlowFractionParamClassType.ANE_ParamName;
  result.UpFlowFractionIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.UpFlowFractionIndex > -1);

  ParameterName :=
    ModflowTypes.GetMFDaflowInitialFlowParamClassType.ANE_ParamName;
  result.InitialFlowIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.InitialFlowIndex > -1);
  InitialFlowParamName := ParameterName;

  ParameterName :=
    ModflowTypes.GetMFDaflowTortuosityParamClassType.ANE_ParamName;
  result.TortuosityIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.TortuosityIndex > -1);

  ParameterName := ModflowTypes.GetMFDaflowA0ParamClassType.ANE_ParamName;
  result.A0Index := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.A0Index > -1);

  ParameterName := ModflowTypes.GetMFDaflowA1ParamClassType.ANE_ParamName;
  result.A1Index := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.A1Index > -1);

  ParameterName := ModflowTypes.GetMFDaflowA2ParamClassType.ANE_ParamName;
  result.A2Index := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.A2Index > -1);

  ParameterName := ModflowTypes.GetMFDaflowW1ParamClassType.ANE_ParamName;
  result.W1Index := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.W1Index > -1);

  ParameterName := ModflowTypes.GetMFDaflowW2ParamClassType.ANE_ParamName;
  result.W2Index := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.W2Index > -1);

  ParameterName := ModflowTypes.GetMFDaflowPrintParamClassType.ANE_ParamName;
  result.PrintIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.PrintIndex > -1);

  ParameterName := ModflowTypes.GetMFDaflowOverridenBedElevationParamClassType.
    ANE_ParamName;
  result.OverridenBedElevIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.OverridenBedElevIndex > -1);

  ParameterName := ModflowTypes.GetMFDaflowOverrideInitialFlowParamClassType.
    ANE_ParamName;
  result.OverridenInitialFlowIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.OverridenInitialFlowIndex > -1);
end;

function TDaflowWriter.GetTimeStep(const RefStressPeriod: integer;
  Time: double; const RefErrors, TimeErrors: TStringList): integer;
var
  AString: string;
begin
  if (RefStressPeriod <= 0) or (RefStressPeriod >= Length(Times)) then
  begin
    AString := IntToStr(RefStressPeriod);
    RefErrors.Add(AString);
    result := 0;
    Exit;
  end;
  if Time < 0 then
  begin
    AString := FloatToStr(Time);
    TimeErrors.Add(AString);
    result := 0;
    Exit;
  end;
  Time := Time + Times[RefStressPeriod - 1];
  if DT = 0 then
  begin
    result := 0;
    Exit;
  end;
  result := Round(Time/InternalDT);
end;

function TDaflowWriter.GetTransientIndicies(const Layer: TLayerOptions;
  const TimeIndex: integer): TDaflowTransientIndicies;
var
  ParameterName: string;
  TimeString: string;
begin
  TimeString := IntToStr(TimeIndex);

  ParameterName := ModflowTypes.GetMFTimeParamType.ANE_ParamName + TimeString;
  result.TimeIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.TimeIndex > -1);

  ParameterName := ModflowTypes.GetMFReferenceStressPeriodParamClassType.
    ANE_ParamName + TimeString;
  result.RefStressIndex := Layer.GetParameterIndex(ModelHandle, ParameterName);
  Assert(result.RefStressIndex > -1);

  ParameterName := ModflowTypes.GetMFDaflowBoundaryFlowParamClassType.
    ANE_ParamName + TimeString;
  result.BoundaryFlowIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.BoundaryFlowIndex > -1);

  ParameterName := ModflowTypes.GetMFDaflowIsNewBoundaryParamClassType.
    ANE_ParamName + TimeString;
  result.NewBoundaryIndex := Layer.GetParameterIndex(ModelHandle,
    ParameterName);
  Assert(result.NewBoundaryIndex > -1);
end;

function SortJunctionsFunction(Item1, Item2: Pointer): Integer;
begin
  result := TJunctionSortObject(Item2).Count - TJunctionSortObject(Item1).Count;
end;

procedure TDaflowWriter.InitializeConversionFactor;
var
  LengthIndex: integer;
begin
  LengthIndex := frmModflow.comboLengthUnits.ItemIndex;
  DistanceConversionFactor := 1;
  case LengthIndex of
    0:
      begin
        // undefined
        DistanceConversionFactor := 1
      end;
    1:
      begin
        // feet
        DistanceConversionFactor := 1/5280;
      end;
    2:
      begin
        // m
        DistanceConversionFactor := 1/1000;
      end;
    3:
      begin
        // cm
        DistanceConversionFactor := 1/1000/100;
      end;
  else Assert(False);
  end;

end;

procedure TDaflowWriter.InitializeTimes;
var
  StressPeriodIndex: integer;
  PERLEN: double;
  NPER: integer;
  ElapsedPeriodLength: double;
  ARow: integer;
begin
  NPER := frmModflow.dgTime.RowCount - 1;
  SetLength(Times, NPER + 1);
  ElapsedPeriodLength := 0;
  for StressPeriodIndex := 0 to NPER - 1 do
  begin
    ARow := StressPeriodIndex + 1;
    PERLEN := InternationalStrToFloat(frmMODFLOW.dgTime.Cells[
      Ord(tdLength), ARow]);
    Times[StressPeriodIndex] := ElapsedPeriodLength;
    ElapsedPeriodLength := ElapsedPeriodLength + PERLEN;
  end;
  Times[NPER] := ElapsedPeriodLength;
end;

procedure TDaflowWriter.InitializeTimeVariables;
var
  NHRTime: double;
  JTSTime: double;
  Factor: double;
begin
  with frmModflow do
  begin
    DT := InternationalStrToFloat(adeDAF_TimeStepSize.Text);
    JTSTime := InternationalStrToFloat(adeDAF_StartTime.Text);
    NHRTime := InternationalStrToFloat(adeDAF_EndTime.Text);
    Factor := 1;
    case comboDAF_TimeStepUnits.ItemIndex of
      0:
        begin
          // seconds
          Factor := 1/3600
        end;
      1:
        begin
          // minutes
          Factor := 1 /60;
        end;
      2:
        begin
          // hours
          Factor := 1;
        end;
      3:
        begin
          // days
          Factor := 24;
        end;
      4:
        begin
          Factor := 24*365;
          // years
        end;
    else Assert(False);
    end;
    JTS := Round(JTSTime/DT);
    NHR := Round(NHRTime/DT)-JTS;
    DT := DT*Factor;
    case frmModflow.comboTimeUnits.ItemIndex of
      0:
        begin
          // undefined
          Factor := 1;
        end;
      1:
        begin
          // seconds
          Factor := 3600;
        end;
      2:
        begin
          // minutes
          Factor := 60;
        end;
      3:
        begin
          // hours
          Factor := 1;
        end;
      4:
        begin
          // days
          Factor := 1/24;
        end;
      5:
        begin
          // years
          Factor := 1/24/365;
        end;
    else Assert(False);
    end;
    InternalDT := DT*Factor;
  end;

end;

procedure TDaflowWriter.SortJunctions;
var
  JunctionList: TIntegerList;
  SubBranchIndex: integer;
  SubBranch: TSubBranch;
  SortJunctionList: TObjectList;
  JunctionIndex: integer;
  JunctionSort: TJunctionSortObject;
  Junction: integer;
  MaxJunction: integer;
begin
  NJNCT := 0;
  JunctionList := TIntegerList.Create;
  try
    for SubBranchIndex := 0 to SubBranches.Count - 1 do
    begin
      SubBranch := SubBranches[SubBranchIndex] as TSubBranch;
      JunctionList.Add(SubBranch.SteadyProperties.UpJunction);
      JunctionList.Add(SubBranch.SteadyProperties.DownJunction);
    end;
    JunctionList.Sort;
    MaxJunction := JunctionList[JunctionList.Count - 1];
    SortJunctionList := TObjectList.Create;
    try
      JunctionSort := nil;
      for JunctionIndex := 0 to JunctionList.Count - 1 do
      begin
        Junction := JunctionList[JunctionIndex];
        if (JunctionSort = nil) or (JunctionSort.Junction <> Junction) then
        begin
          JunctionSort := TJunctionSortObject.Create;
          SortJunctionList.Add(JunctionSort);
          JunctionSort.Junction := Junction;
          JunctionSort.Count := 0;
        end;
        Inc(JunctionSort.Count);
      end;
      SortJunctionList.Sort(SortJunctionsFunction);
      SetLength(JunctionArray, MaxJunction + 1);
      for JunctionIndex := 0 to MaxJunction do
      begin
        JunctionArray[JunctionIndex] := 0;
      end;

      Junction := 0;
      for JunctionIndex := 0 to SortJunctionList.Count - 1 do
      begin
        JunctionSort := SortJunctionList[JunctionIndex] as TJunctionSortObject;
        if JunctionSort.Count <> 2 then
        begin
          Inc(Junction);
          JunctionArray[JunctionSort.Junction] := Junction;
        end;
        if JunctionSort.Count > 2 then
        begin
          Inc(NJNCT);
        end;
      end;
    finally
      SortJunctionList.Free;
    end;
  finally
    JunctionList.Free;
  end;
end;

procedure TDaflowWriter.WriteDaflowFile;
begin
  WriteDataGroup1;
  WriteDataGroup2;
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
  if not ContinueExport then
  begin
    Exit;
  end;
  WriteDataGroup3;
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
  if not ContinueExport then
  begin
    Exit;
  end;
end;

procedure TDaflowWriter.WriteDataGroup1;
var
  Title: string;
  NBRCH: integer;
  JGO: integer;
  IENG: integer;
  QP: double;
begin
  NBRCH := Branches.Count;
  with frmModflow do
  begin
    Title := adeDAFLOW_Title.Text;
    JGO := StrToInt(adeDAF_PrintoutInterval.Text);
    QP := InternationalStrToFloat(adeDAF_PeakDischarge.Text);
    IENG := 0;
    case comboLengthUnits.ItemIndex of
      0:
        begin
          // undefined
          IENG := 0;
        end;
      1:
        begin
          // feet
          IENG := 1;
        end;
      2,3:
        begin
          // meters, centimeters
          IENG := 0;
        end;
    else Assert(False);
    end;
  end;
  // record 1
  Writeln(FFile, Title);
  // record 2
  Writeln(FFile, Format('No. of Branches     %10d', [NBRCH]));
  // record 3
  Writeln(FFile, Format('Internal Junctions  %10d', [NJNCT]));
  // record 4
  Writeln(FFile, Format('Time Steps Modeled  %10d', [NHR]));
  // record 5
  Writeln(FFile, Format('Model Starts        %10d time steps after midnight.', [JTS]));
  // record 6
  Writeln(FFile, Format('Output Given Every  %10d Time Steps in "flow.out"', [JGO]));
  // record 7
  Writeln(FFile, Format('0=Metric,1=English  %10d', [IENG]));
  // record 8
  Writeln(FFile,
    'Time Step Size     ',
    DaflowFixedFormattedReal(DT,11),
    ' hours'
    );
  // record 9
  Writeln(FFile,
    'Peak Discharge     ',
    DaflowFixedFormattedReal(QP,11)
    );
end;

procedure TDaflowWriter.WriteDataGroup2;
var
  Index: integer;
  Branch: TBranch;
begin
  frmProgress.LblActivity.Caption := 'Writing Data Group 2';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Branches.Count;
  for Index := 0 to Branches.Count -1 do
  begin
    Branch := Branches[Index] as TBranch;
    Branch.WriteDataGroup2(self,DistanceConversionFactor);
    frmProgress.pbActivity.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
    begin
      Exit;
    end;
  end;

end;

procedure TDaflowWriter.WriteDataGroup3;
var
  TimeIndex: integer;
  NBC: integer;
  BranchIndex: integer;
  Branch: TBranch;
begin
  frmProgress.LblActivity.Caption := 'Writing Data Group 3';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := NHR;
  for TimeIndex := JTS to NHR + JTS-1 do
  begin
    NBC := 0;
    for BranchIndex := 0 to Branches.Count -1 do
    begin
      Branch := Branches[BranchIndex] as TBranch;
      NBC := NBC + Branch.BoundaryCount(TimeIndex);
    end;
    Writeln(FFile, Format('for time %4d NBC=%3d', [TimeIndex-JTS+1, NBC]));
    if NBC > 0 then
    begin
      for BranchIndex := 0 to Branches.Count -1 do
      begin
        Branch := Branches[BranchIndex] as TBranch;
        Branch.WriteDataGroup3Record2(self, TimeIndex);
      end;
    end;
    frmProgress.pbActivity.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
    begin
      Exit;
    end;
  end;
end;

procedure TDaflowWriter.WriteFiles(const Root: string;
  const DiscretizationWriter: TDiscretizationWriter);
Var
  FileName: string;
  ErrorMessages: TStringList;
begin
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'DAFLOW';

    ErrorMessages := TStringList.Create;
    try
      frmModflow.DaflowWarnings(ErrorMessages);
      if ErrorMessages.Count > 0 then
      begin
        frmProgress.reErrors.Lines.AddStrings(ErrorMessages);
        ErrorMessages.Add('');
        ErrorMessages.AddStrings(ErrorMessages);
      end;
    finally
      ErrorMessages.Free;
    end;

    DisWriter := DiscretizationWriter;
    ModelHandle:= frmModflow.CurrentModelHandle;

    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := (frmModflow.dgGeol.RowCount - 1) + 3;

    Evaluate;
    if not ContinueExport then
    begin
      Exit;
    end;
    FileName := GetCurrentDir + '\' + Root + rsDAF;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDaflowFile;
    finally
      begin
        CloseFile(FFile);
        Application.ProcessMessages;
      end;
    end;
    if not ContinueExport then
    begin
      Exit;
    end;
    FileName := GetCurrentDir + '\' + Root + rsDAFG;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteLink;
      frmProgress.pbPackage.StepIt;
    finally
      begin
        CloseFile(FFile);
        Application.ProcessMessages;
      end;
    end;
  end;
end;

procedure TDaflowWriter.WriteLink;
var
  Index: integer;
  Branch: TBranch;
  Title: string;
  IDAFCB, IDBG, IDAFBK: integer;
begin
  frmProgress.LblActivity.Caption := 'Writing ground-water information';
  if frmModflow.cbFlowDaflow.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IDAFCB := frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      IDAFCB := frmModflow.GetUnitNumber('DAFLOWBUD')
    end;
  end
  else
  begin
      IDAFCB := -1;
  end;

  if frmModflow.cbDAF_Debug.Checked then
  begin
    IDBG := 1;
  end
  else
  begin
    IDBG := 0;
  end;

  if frmModflow.cbDAF_CentralDifferencing.Checked then
  begin
    IDAFBK := 0;
  end
  else
  begin
    IDAFBK := 1;
  end;

  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Branches.Count;

  Title := frmModflow.adeDAFLOW_Title.Text;
  WriteLn(FFile, Title);
  WriteLn(FFile);
  WriteLn(FFile, 'Branch, Node, Bed Elev., Bed Thick, K, Layer, Row, Column');

  for Index := 0 to Branches.Count -1 do
  begin
    Branch := Branches[Index] as TBranch;
    Branch.WriteLink(self);
    frmProgress.pbActivity.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
    begin
      Exit;
    end;
  end;
  writeln(FFile, 'IDAFCB IDBG IDAFBK');
  writeln(FFile, IDAFCB, ' ', IDBG, ' ', IDAFBK);
end;

{ TSubreachList }

function TSubreachList.Add(const ReachProperties: TSubreachRecord): integer;
var
  Subreach: TSubreach;
begin
  Subreach := TSubreach.Create;
  Subreach.Properties := ReachProperties;
  result := inherited Add(Subreach);
end;

function TSubreachList.GetItem(const Index: integer): TSubreach;
begin
  result := inherited Items[Index] as TSubreach;
end;

function SubreachSort(Item1, Item2: Pointer): Integer;
var
  Difference: double;
begin
  Difference := TSubreach(Item1).Properties.Distance
    - TSubreach(Item2).Properties.Distance;
  if Difference > 0 then
  begin
    result := 1;
  end
  else if Difference < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

procedure TSubreachList.Sort;
begin
  inherited Sort(SubreachSort);
end;

{ TSubBranch }

function TSubBranch.BoundaryCount(const TimeStep: integer): integer;
var
  Below, Above: integer;
  Properties: TTransientProperties;
begin
  result := 0;
  if TransientPropertiesList.Count > 0 then
  begin
    GetBoundaryIndicies(TimeStep, Below, Above);
    Properties := TransientPropertiesList.Items[Below];
    if Properties.Properties.TimeStep = TimeStep then
    begin
      result := 1;
    end;
    if Above > Below then
    begin
      Properties := TransientPropertiesList.Items[Above];
      if Properties.Properties.TimeStep = TimeStep then
      begin
        result := result + 1;
      end;
    end;
  end;
end;

constructor TSubBranch.Create;
begin
  inherited;
  SubReachList := TSubReachList.Create;
  TransientPropertiesList := TTransientPropertiesList.Create;
end;

destructor TSubBranch.Destroy;
begin
  SubReachList.Free;
  TransientPropertiesList.Free;
  inherited;
end;

procedure TSubBranch.GetBoundaryIndicies(const TimeStep: integer;
  out Below, Above: integer);
var
  Middle: integer;
  Properties: TTransientProperties;
begin
  Below := 0;
  Above := TransientPropertiesList.Count - 1;
  while Above - Below > 1 do
  begin
    Middle := (Above + Below) div 2;
    Properties := TransientPropertiesList.Items[Middle];
    if Properties.Properties.TimeStep > TimeStep then
    begin
      Above := Middle;
    end
    else
    begin
      Below := Middle;
    end;
  end;
end;

procedure TSubBranch.WriteDataGroup3Record2(const Writer: TDaflowWriter;
  const BranchNumber, PriorNodes, TimeStep: integer);
var
  Below, Above: integer;
  Properties: TTransientProperties;
  procedure WriteBoundary;
  begin
    Writeln(Writer.FFile,
      Format('Branch    %3d Node%3d Q',
      [BranchNumber, PriorNodes + 1]),
      Writer.DaflowFixedFormattedReal(Properties.Properties.BoundaryFlow, 15)
      );
  end;
begin
  if TransientPropertiesList.Count > 0 then
  begin
    GetBoundaryIndicies(TimeStep, Below, Above);
    Properties := TransientPropertiesList.Items[Below];
    if Properties.Properties.TimeStep = TimeStep then
    begin
      WriteBoundary
    end;
    if Above > Below then
    begin
      Properties := TransientPropertiesList.Items[Above];
      if Properties.Properties.TimeStep = TimeStep then
      begin
        WriteBoundary
      end;
    end;
  end;
end;

procedure TSubBranch.WriteGroup2Record3(const Writer: TDaflowWriter;
  var StartingIndex: integer; const DistanceConversionFactor: double;
  var PriorReach: TSubReach);
var
  Index: integer;
  SubReach: TSubreach;
begin
  SubReach := nil; 
  for Index := 0 to SubReachList.Count - 1 do
  begin
{    if (Index = 0) and (StartingIndex <> 1) then
    begin
      Continue;
    end;      }
    SubReach := SubReachList.Items[Index];
//    if (Index = 0) and SubReach.SameCell(PriorReach) then
//    begin
//      Continue;
//    end;

    SubReach.WriteGroup2Record3(Writer, self, StartingIndex,
      DistanceConversionFactor);
  end;
  PriorReach := SubReach;
end;

{ TTransientPropertiesList }

function TTransientPropertiesList.Add(
  const TransientProperties: TTransientPropertiesRecord): integer;
var
  Properties: TTransientProperties;
begin
  Properties := TTransientProperties.Create;
  Properties.Properties := TransientProperties;
  result := inherited Add(Properties);
end;

function TTransientPropertiesList.GetItem(
  const Index: integer): TTransientProperties;
begin
  result := inherited Items[index] as TTransientProperties;
end;

{ TBranch }

function TBranch.BoundaryCount(const TimeStep: integer): integer;
var
  Index: integer;
  SubBranch: TSubBranch;
begin
  result := 0;
  for Index := 0 to SubBranches.Count -1 do
  begin
    SubBranch := SubBranches[Index];
    result := Result + SubBranch.BoundaryCount(TimeStep);
  end;
end;

constructor TBranch.Create;
begin
  inherited;
  SubBranches := TList.Create;
end;

destructor TBranch.Destroy;
begin
  SubBranches.Free;
  inherited;
end;

procedure TBranch.WriteDataGroup2(const Writer: TDaflowWriter;
  const DistanceConversionFactor: double);
var
  NXSEC: integer;
  PF: double;
  JNCU: integer;
  JNCD: integer;
  SubBranch: TSubBranch;
  Index: integer;
  StartIndex: integer;
  SubReach, SubReachNMinus1: TSubreach;
  OldDistance: double;
  Delta: double;
  PriorReach, FirstReach: TSubReach;

begin
  // record 1;
  // The first and last reaches are printed twice.
  NXSEC := 2;
  PriorReach := nil;
  for Index := 0 to SubBranches.Count - 1 do
  begin
    SubBranch := SubBranches[Index];
    NXSEC := NXSEC + SubBranch.SubReachList.Count;
    FirstReach := SubBranch.SubReachList.Items[0];
//    if FirstReach.SameCell(PriorReach) then
//    begin
//      Dec(NXSEC);
//    end;
    PriorReach := SubBranch.SubReachList.Items[SubBranch.SubReachList.Count -1];
  end;
  SubBranch := SubBranches[0];
  PF := SubBranch.SteadyProperties.UpFlowFraction;
  JNCU := Writer.JunctionArray[SubBranch.SteadyProperties.UpJunction];
  SubBranch := SubBranches[SubBranches.Count - 1];
  JNCD := Writer.JunctionArray[SubBranch.SteadyProperties.DownJunction];
  Writeln(Writer.FFile,
    Format('Branch has   %3d xsect, routes ', [NXSEC]),
    Writer.DaflowFixedFormattedReal(PF, 6),
    Format('of flow from    %3d to     %3d', [JNCU, JNCD]));
  // record 2
  Writeln(Writer.FFile, 'Grd      Mi/Km IOUT   Disch       A1         A2         AO     Slope    W1     W2');
  // record 3
  StartIndex := 1;
  // you need a short extra cross section at the end.
  // Make it by first shortening the last subreach,
  // exporting the subreaches, restoring the length
  // of the last subreach and exporting the last cross
  // section a second time.
  SubBranch := SubBranches[SubBranches.Count - 1];
  OldDistance := 0;
  if SubBranch.SubReachList.Count > 0 then
  begin
    SubReach := SubBranch.SubReachList.Items[SubBranch.SubReachList.Count -1];
    OldDistance := SubReach.Properties.Distance;
    if SubBranch.SubReachList.Count > 1 then
    begin
      SubReachNMinus1 := SubBranch.SubReachList.Items[SubBranch.SubReachList.Count -2];
      Delta := (OldDistance - SubReachNMinus1.Properties.Distance)/100
    end
    else
    begin
      Delta := 0.02;
    end;
    SubReach.Properties.Distance := SubReach.Properties.Distance - Delta;
  end;

  PriorReach := nil;
  for Index := 0 to SubBranches.Count - 1 do
  begin
    SubBranch := SubBranches[Index];
    SubBranch.WriteGroup2Record3(Writer, StartIndex, DistanceConversionFactor,
      PriorReach);
  end;

  // Restore the old distance and export the final cross section.
  if SubBranch.SubReachList.Count > 0 then
  begin
    SubReach := SubBranch.SubReachList.Items[SubBranch.SubReachList.Count -1];
    SubReach.Properties.Distance := OldDistance;
    SubReach.WriteGroup2Record3(Writer, SubBranch, StartIndex, DistanceConversionFactor);
  end;  
end;

procedure TBranch.WriteDataGroup3Record2(const Writer: TDaflowWriter;
  const TimeStep: integer);
var
  Index: integer;
  SubBranch: TSubBranch;
  PriorNodes: integer;
begin
  PriorNodes := 0;
  for Index := 0 to SubBranches.Count - 1 do
  begin
    SubBranch := SubBranches[Index];
    SubBranch.WriteDataGroup3Record2(Writer, BranchNumber, PriorNodes,
      TimeStep);
    if Index = 0 then
    begin
      PriorNodes := PriorNodes + SubBranch.SubReachList.Count;
    end
    else
    begin
      PriorNodes := PriorNodes + SubBranch.SubReachList.Count - 1;
    end;
  end;
end;

procedure TBranch.WriteLink(const Writer: TDaflowWriter);
var
  SubBranchIndex, SubReachIndex: integer;
  NodeNumber: integer;
  SubBranch: TSubBranch;
  SubReach: TSubReach;
  StartNode: integer;
begin
  NodeNumber := 1;
  for SubBranchIndex := 0 to SubBranches.Count -1 do
  begin
    SubBranch := SubBranches[SubBranchIndex];
    if SubBranchIndex = 0 then
    begin
      StartNode := 0;
    end
    else
    begin
      StartNode := 0;
    end;

    for SubReachIndex := StartNode to SubBranch.SubReachList.Count -1 do
    begin
      SubReach := SubBranch.SubReachList.Items[SubReachIndex];
      Inc(NodeNumber);
//      if SubReach.Properties.Layer <> 0 then
//      begin
        WriteLn(Writer.FFile,
          BranchNumber, ' ',
          NodeNumber, ' ',
          Writer.FreeFormattedReal(SubReach.Properties.BedElevation),
          Writer.FreeFormattedReal(SubBranch.SteadyProperties.BedThickness),
          Writer.FreeFormattedReal(SubBranch.SteadyProperties.BedK), ' ',
          SubReach.Properties.Layer, ' ',
          SubReach.Properties.Row, ' ',
          SubReach.Properties.Column);
//      end;
    end;

  end;

end;

{ TSubreach }

//function TSubreach.SameCell(AReach: TSubreach): boolean;
//begin
//  result := (AReach <> nil) and (AReach.Properties.Column = Properties.Column)
//    and (AReach.Properties.Row = Properties.Row)
//    and (AReach.Properties.Layer = Properties.Layer)
//end;

procedure TSubreach.WriteGroup2Record3(const Writer: TDaflowWriter;
  const SubBranch: TSubBranch; var StartingIndex: integer;
  const DistanceConversionFactor: double);
var
  X: double;
  IOUT: integer;
  F: double;
  A0: double;
  A1: double;
  A2: double;
  SL: double;
  W1: double;
  W2: double;
begin
  X := Properties.Distance {* SubBranch.SteadyProperties.Tortuosity
    * DistanceConversionFactor};
  if SubBranch.SteadyProperties.Print then
  begin
    IOUT := 1;
  end
  else
  begin
    IOUT := 0;
  end;
  F := Properties.InitialFlow;
  A0 := SubBranch.SteadyProperties.A0;
  A1 := SubBranch.SteadyProperties.A1;
  A2 := SubBranch.SteadyProperties.A2;
  W1 := SubBranch.SteadyProperties.W1;
  W2 := SubBranch.SteadyProperties.W2;
  SL := SubBranch.SteadyProperties.BedSlope;

  if StartingIndex = 1 then
  begin
  writeLn(Writer.FFile,
    Format('%3d', [StartingIndex]),
    // Write the distance for the first cross section as zero rather than X.
    Writer.DaflowFixedFormattedReal(0, 11),
    '  ', IOUT,
    Writer.DaflowFixedFormattedReal(F, 11),
    Writer.DaflowFixedFormattedReal(A1, 10),
    Writer.DaflowFixedFormattedReal(A2, 10),
    Writer.DaflowFixedFormattedReal(A0, 10),
    Writer.DaflowFixedFormattedReal(SL, 10),
    Writer.DaflowFixedFormattedReal(W1, 7),
    Writer.DaflowFixedFormattedReal(W2, 7)
    );
    Inc(StartingIndex);
  end;

  writeLn(Writer.FFile,
    Format('%3d', [StartingIndex]),
    Writer.DaflowFixedFormattedReal(X, 11),
    '  ', IOUT,
    Writer.DaflowFixedFormattedReal(F, 11),
    Writer.DaflowFixedFormattedReal(A1, 10),
    Writer.DaflowFixedFormattedReal(A2, 10),
    Writer.DaflowFixedFormattedReal(A0, 10),
    Writer.DaflowFixedFormattedReal(SL, 10),
    Writer.DaflowFixedFormattedReal(W1, 7),
    Writer.DaflowFixedFormattedReal(W2, 7)
    );
  Inc(StartingIndex);
end;

end.

