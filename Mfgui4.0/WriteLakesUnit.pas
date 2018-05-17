unit WriteLakesUnit;

interface

uses SysUtils, Classes, Dialogs, Forms, contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization;

type
  TLakeData = record
    LakeNumber: integer;
    InitialStage: double;
    MinimumStage: double;
    MaximumStage: double;
    Gage: boolean;
    GageOutputType: integer;
    CenterLake: integer;
    Sill: double;
  end;

  TMOC3DLakeData = record
    InitialConcentration: double;
  end;

  TLakeDataIndicies = record
    LakeNumber: ANE_INT16;
    InitialStage: ANE_INT16;
    MinimumStage: ANE_INT16;
    MaximumStage: ANE_INT16;
    Gage: ANE_INT16;
    GageOutputType: ANE_INT16;
    BottomElevation: ANE_INT16;
    CenterLake: ANE_INT16;
    Sill: ANE_INT16;
  end;

  TLakeLeakanceIndicies = record
    HydraulicConductivity: ANE_INT16;
    Thickness: ANE_INT16;
  end;

  TMOC3DLakeDataIndicies = record
    InitialConcentration: ANE_INT16;
  end;

  TLakeTimeData = record
    Precip: double;
    Evap: double;
    Runoff: double;
    Withdrawal: double;
  end;

  TLakeTimeDataIndicies = record
    Precip: ANE_INT16;
    Evap: ANE_INT16;
    Runoff: ANE_INT16;
    Withdrawal: ANE_INT16;
  end;

  TMOC3DLakeTimeData = record
    PrecipConc: double;
    RunoffConc: double;
    AugmentConc: double;
  end;

  TMOC3DLakeTimeDataIndicies = record
    PrecipConc: ANE_INT16;
    RunoffConc: ANE_INT16;
    AugmentConc: ANE_INT16;
  end;

  TMoc3dLakeList = class;
  TLakeWriter = class;
  TLakeTimeList = class;

  TLakeObject = class(TObject)
    //    OriginalNumber : integer;
    Data: TLakeData;
    Moc3dLakeList: TMoc3dLakeList;
    LakeTimeList: TLakeTimeList;
    SubLakes: TList;
    procedure WriteData(Writer: TLakeWriter; IsTransient: boolean);
    constructor Create;
    destructor Destroy; override;
    procedure WriteTimeData(Writer: TLakeWriter; TimeIndex: integer);
    procedure WriteSubLakes(Writer: TLakeWriter);
  end;

  TLakeList = class(TObjectList)
    function Add(AValue: TLakeData): integer;
    procedure WriteData(Writer: TLakeWriter; IsTransient: boolean);
    procedure WriteTimeData(Writer: TLakeWriter; TimeIndex: integer);
    function GetLakeByLakeNumber(LakeNumber: integer): TLakeObject;
    function MFLakeNumber(ArgusLakeNumber: integer): integer;
  end;

  TMOC3DLakeObject = class(TObject)
    Moc3dData: TMOC3DLakeData;
    procedure WriteData(Writer: TLakeWriter);
  end;

  TMoc3dLakeList = class(TObjectList)
    function Add(AValue: TMOC3DLakeData): integer;
    procedure WriteData(Writer: TLakeWriter);
  end;

  TMoc3dLakeTimeList = class;

  TLakeTimeObject = class(TObject)
    TimeData: TLakeTimeData;
    MocTimeData: TMoc3dLakeTimeList;
    constructor Create;
    destructor Destroy; override;
    procedure WriteData(const Writer: TLakeWriter; const Lake: TLakeObject;
      const StressPeriod: integer);
    //    Procedure WriteTimeData(Writer : TLakeWriter; TimeIndex : integer);
  end;

  TLakeTimeList = class(TObjectList)
    function Add(AValue: TLakeTimeData): integer;
    procedure WriteData(const Writer: TLakeWriter; const Lake: TLakeObject; const TimeIndex: integer);
  end;

  TMOC3DLakeTimeObject = class(TObject)
    MOC3DTimeData: TMOC3DLakeTimeData;
    procedure WriteData(Writer: TLakeWriter; Withdrawal: double);
  end;

  TMoc3dLakeTimeList = class(TObjectList)
    function Add(AValue: TMOC3DLakeTimeData): integer;
    procedure WriteData(Writer: TLakeWriter; Withdrawal: double);
  end;

  TCellCenter = record
    X: double;
    Y: double;
  end;

  TCustomMF96Writer = class(TListWriter)
  protected
    CellCenters: array of array of TCellCenter;
    FColumnsReversed: boolean;
    FRowsReversed: boolean;
    FDiscretization: TDiscretizationWriter;
    Grid: TLayerOptions; // created in SetGridReversed
    LayersPerUnit: array of Integer;
    ModelHandle: ANE_PTR;
    NCOL, NROW, NLAY, NUNITS: integer;
    Simulated: array of boolean;
    function BlockIndex(RowIndex, ColIndex: integer): integer;
    function Elevation(Modflow2000: boolean; Col, Row, UnitIndex: integer)
      : double;
    procedure InitializeCellCenters;
    procedure SetGridReversed;
    procedure SetSimulated;
  end;

  TLakeWriter = class(TCustomMF96Writer)
  private
    LakeLayer: TLayerOptions;
    LakeDataIndicies: TLakeDataIndicies;
    MOC3DLakeDataIndicies: array of TMOC3DLakeDataIndicies;
    LakeTimeDataIndicies: array of TLakeTimeDataIndicies;
    MOC3DLakeTimeDataIndicies: array of array of TMOC3DLakeTimeDataIndicies;
    LakeLeakanceArray: array of array of array of double;
    LakeList: TLakeList;
    Transient: boolean;
    ITMP: integer;
    ITMP1: integer;
    SubLakeErrors: TStringList;
    AreaErrors: integer;
    GridAngle: ANE_DOUBLE;
    TimeVaryingLeakance: Boolean;
    procedure Initialize;
    function GetLakeIndicies(IsTransient: boolean): TLakeDataIndicies;
    function GetLakeMoc3dIndicies(ConsituentNumber: integer):
      TMOC3DLakeDataIndicies;
    function GetLakeTimeIndicies(StressPeriod: integer): TLakeTimeDataIndicies;
    function GetLakeMoc3dTimeIndicies(StressPeriod, ConsituentNumber: integer):
      TMOC3DLakeTimeDataIndicies;
    procedure MakeLake;
    function EvaluateContour(LakeContour: TContourObjectOptions): TLakeObject;
    procedure EvaluateMOC3DData(LakeContour: TContourObjectOptions; Lake:
      TLakeObject);
    procedure EvaluateTimeData(LakeContour: TContourObjectOptions;
      Lake: TLakeObject);
    procedure EvaluateMOC3DTimeData(LakeContour: TContourObjectOptions;
      LakeTimeObject: TLakeTimeObject; StressIndex: integer);
    procedure EvaluateCells(Modflow2000: boolean; ContourIndex: integer;
      Lake: TLakeObject; BasicWriter: TBasicPkgWriter);
    procedure EvaluateSubLakes;
    procedure WriteDataSet1(const Modflow2000: boolean);
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4(StressPeriod: integer);
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure WriteDataSets7and8;
    procedure WriteDataSet9(StressPeriod: integer);
    procedure WriteErrors;
    procedure GageInitialize;
    procedure EvaluateGages;
    function MakeLakeLayer: string;
    procedure EvaluateContourForGages(LakeContour: TContourObjectOptions);
    function GetLakeGageIndicies: TLakeDataIndicies;
    procedure EvaluateLeakance(StressPeriod: integer);
    procedure SetGridAngle;
    //    function GetLakeLeakanceIndicies(
    //      UnitNumber: integer): TLakeLeakanceIndicies;
  public
    LakeNumberArray: array of array of array of integer;
    procedure WriteFile2000(const CurrentModelHandle: ANE_PTR;
      Root: string; Discretization: TDiscretizationWriter;
      BasicWriter: TBasicPkgWriter);
    procedure WriteFile96(const CurrentModelHandle: ANE_PTR;
      Root: string; BasicWriter: TBasicPkgWriter);
    constructor Create;
    destructor Destroy; override;
    procedure InitializeArrays(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicWriter: TBasicPkgWriter;
      Modflow2000: boolean);
    procedure InitializeGages(const CurrentModelHandle: ANE_PTR);
    function MFLakeNumber(ArgusLakeNumber: integer): integer;
    procedure EvaluateLayer(Modflow2000: boolean;
      BasicWriter: TBasicPkgWriter);
    class procedure AssignUnitNumbers(const Modflow2000: boolean);
  end;

  {procedure GInitializeLakeGages (const refPtX : ANE_DOUBLE_PTR      ;
      const refPtY : ANE_DOUBLE_PTR     ;
      numParams : ANE_INT16          ;
      const parameters : ANE_PTR_PTR ;
      funHandle : ANE_PTR            ;
      reply : ANE_PTR		       	); cdecl;}

implementation

uses Variables, ModflowUnit, PointInsideContourUnit, WriteNameFileUnit,
  UtilityFunctions, ANE_LayerUnit, ArgusFormUnit, InitializeBlockUnit,
  FreeBlockUnit, ParamArrayUnit, RunUnit, ProgressUnit, UnitNumbers,
  WriteGageUnit;

function Moc3dConstiuents: integer;
begin
  if frmModflow.cbMOC3D.Checked and UseSolute then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;

{ TCustomMF96Writer }

function TCustomMF96Writer.BlockIndex(RowIndex,
  ColIndex: integer): integer;
var
  ErrorString: string;
begin
  if not ((ColIndex >= 0) and (ColIndex < NCOL) and (RowIndex >= 0)
    and (RowIndex < NROW)) then
  begin
    ErrorString := 'Illegal row or column number in '
      + 'TLakeWriter.BlockIndex.';
    raise Exception.Create(ErrorString);
  end;
  if FColumnsReversed then
  begin
    ColIndex := NCOL - ColIndex - 1;
  end;
  if FRowsReversed then
  begin
    RowIndex := NROW - RowIndex - 1;
  end;
  result := RowIndex * NCOL + ColIndex;
end;

function TCustomMF96Writer.Elevation(Modflow2000: boolean; Col, Row,
  UnitIndex: integer): double;
var
  ParamName: string;
  ABlock: TBlockObjectOptions;
  ParamIndex: ANE_INT16;
begin
  if Modflow2000 then
  begin
    result := FDiscretization.Elevations[Col, Row, UnitIndex];
  end
  else
  begin
    ABlock := TBlockObjectOptions.Create(ModelHandle, Grid.LayerHandle,
      BlockIndex(Row, Col));
    try
      if UnitIndex = 0 then
      begin
        ParamName := ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName
          + '1';
      end
      else
      begin
        ParamName := ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName
          + IntToStr(UnitIndex);
      end;
      ParamIndex := Grid.GetParameterIndex(ModelHandle, ParamName);
      result := ABlock.GetFloatParameter(ModelHandle, ParamIndex);
    finally
      ABlock.Free;
    end;
  end;
end;

procedure TCustomMF96Writer.InitializeCellCenters;
var
  ColIndex, RowIndex: integer;
  ABlockIndex: integer;
  ABlock: TBlockObjectOptions;
  X, Y: double;
begin
  SetLength(CellCenters, NCOL, NROW);
  for ColIndex := 0 to NCOL - 1 do
  begin
    for RowIndex := 0 to NROW - 1 do
    begin
      ABlockIndex := BlockIndex(RowIndex, ColIndex);
      ABlock := TBlockObjectOptions.Create(ModelHandle, Grid.LayerHandle,
        ABlockIndex);
      try
        ABlock.GetCenter(ModelHandle, X, Y);
        CellCenters[ColIndex, RowIndex].X := X;
        CellCenters[ColIndex, RowIndex].Y := Y;
      finally
        ABlock.Free;
      end;
    end;
  end;
end;

procedure TCustomMF96Writer.SetGridReversed;
begin
  Grid := TLayerOptions.CreateWithName
    (ModflowTypes.GetGridLayerType.ANE_LayerName, ModelHandle);

  FColumnsReversed := Grid.GridReverseXDirection[ModelHandle];
  FRowsReversed := Grid.GridReverseYDirection[ModelHandle];
end;

procedure TCustomMF96Writer.SetSimulated;
var
  UnitIndex: integer;
  UnitCount: integer;
begin
  UnitCount := StrToInt(frmModflow.edNumUnits.Text);

  SetLength(LayersPerUnit, UnitCount);
  SetLength(Simulated, UnitCount);
  for UnitIndex := 1 to UnitCount do
  begin
    LayersPerUnit[UnitIndex - 1] := StrToInt(frmModflow.dgGeol.Cells
      [Ord(nuiVertDisc), UnitIndex]);
    Simulated[UnitIndex - 1] := frmModflow.dgGeol.Columns[Ord(nuiSim)].PickList.
      IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSim), UnitIndex]) = 1;
  end;

end;

{ TLakeWriter }

procedure TLakeWriter.GageInitialize;
begin
  WriteGageUnit.InitializeLakeGages;
  MakeLakeLayer;
  LakeDataIndicies := GetLakeGageIndicies;
end;

procedure TLakeWriter.Initialize;
var
  ColIndex, RowIndex, UnitIndex: integer;
  //  UnitCount : integer;
  ConstituentIndex: integer;
  StressPeriodCount: integer;
  StressPeriodIndex: integer;
  //  ABlockIndex : integer;
  //  ABlock : TBlockObjectOptions;
  //  X, Y : double;
begin
  SetGridAngle;
  Transient := not frmModflow.IsAnySteady;
  MakeLake;
  NUNITS := StrToInt(frmModflow.edNumUnits.Text);

  SetLength(LakeNumberArray, NCOL, NROW, NLAY);
  SetLength(LakeLeakanceArray, NCOL, NROW, NLAY);
  for ColIndex := 0 to NCOL - 1 do
  begin
    for RowIndex := 0 to NROW - 1 do
    begin
      for UnitIndex := 0 to NLAY - 1 do
      begin
        LakeNumberArray[ColIndex, RowIndex, UnitIndex] := 0;
        LakeLeakanceArray[ColIndex, RowIndex, UnitIndex] := 0;
      end;
    end;
  end;
  SetSimulated;

  LakeDataIndicies := GetLakeIndicies(Transient);

  SetLength(MOC3DLakeDataIndicies, Moc3dConstiuents);
  for ConstituentIndex := 0 to Moc3dConstiuents - 1 do
  begin
    MOC3DLakeDataIndicies[ConstituentIndex]
      := GetLakeMoc3dIndicies(ConstituentIndex);
  end;

  StressPeriodCount := StrToInt(frmModflow.edNumPer.Text);
  SetLength(LakeTimeDataIndicies, StressPeriodCount);
  for StressPeriodIndex := 1 to StressPeriodCount do
  begin
    LakeTimeDataIndicies[StressPeriodIndex - 1] :=
      GetLakeTimeIndicies(StressPeriodIndex);
  end;
  SetLength(MOC3DLakeTimeDataIndicies, StressPeriodCount, Moc3dConstiuents);
  for StressPeriodIndex := 1 to StressPeriodCount do
  begin
    for ConstituentIndex := 0 to Moc3dConstiuents - 1 do
    begin
      MOC3DLakeTimeDataIndicies[StressPeriodIndex - 1, ConstituentIndex]
        := GetLakeMoc3dTimeIndicies(StressPeriodIndex, ConstituentIndex);
    end;
  end;

  InitializeCellCenters;
end;

procedure TLakeWriter.InitializeArrays(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicWriter: TBasicPkgWriter;
  Modflow2000: boolean);
begin
  WriteGageUnit.InitializeLakeGages;
  FDiscretization := Discretization;
  ModelHandle := CurrentModelHandle;
  SetGridReversed;
  try
    NCOL := FDiscretization.NCOL;
    NROW := FDiscretization.NROW;
    NLAY := FDiscretization.NLAY;
    //    NPER := StrToInt(frmModflow.edNumPer.Text);
    Initialize;
    EvaluateLayer(Modflow2000, BasicWriter);

  finally
    Grid.Free(CurrentModelHandle);
  end;

end;

procedure TLakeWriter.WriteErrors;
var
  ErrorString: string;
begin
  if SubLakeErrors.Count > 0 then
  begin
    ErrorString := 'Warning: Nonexistent center lake in Lake package';
    frmProgress.reErrors.Lines.Add(ErrorString);

    ErrorString := ErrorString + ' [LakeNumber, CenterLake]';
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.AddStrings(SubLakeErrors);
  end;
  if AreaErrors > 0 then
  begin
    ErrorString := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the LAK (Lake) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorString);
    ErrorMessages.Add(ErrorString);
  end;
end;

procedure TLakeWriter.SetGridAngle;
var
  GridLayer: TGridLayerOptions;
begin
  GridLayer := TGridLayerOptions.Create(ModelHandle,
    FDiscretization.GridLayerHandle);
  try
    GridAngle := GridLayer.GridAngle(ModelHandle);
  finally
    GridLayer.Free(ModelHandle);
  end;

end;

procedure TLakeWriter.WriteFile2000(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter;
  BasicWriter: TBasicPkgWriter);
var
  TimeIndex: integer;
  NPER: integer;
  FileName: string;
begin
  WriteGageUnit.InitializeLakeGages;
  FDiscretization := Discretization;
  ModelHandle := CurrentModelHandle;
  SetGridReversed;
  try
    NCOL := FDiscretization.NCOL;
    NROW := FDiscretization.NROW;
    NLAY := FDiscretization.NLAY;
    NPER := StrToInt(frmModflow.edNumPer.Text);
    TimeVaryingLeakance := frmModflow.comboLakSteadyLeakance.ItemIndex = 1;
    Initialize;

    frmProgress.pbPackage.Max := 4;
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbActivity.Position := 0;
    frmProgress.lblPackage.Caption := 'Lake';

    EvaluateLayer(True, BasicWriter);

    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
      Exit;

    FileName := Root + rsLak;
    AssignFile(FFile, FileName);
    try
      Rewrite(FFile);
      WriteDataSet1(True);
      WriteDataSet2;
      WriteDataSet3;

      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then
        Exit;

      frmProgress.pbActivity.Max := NPER;
      frmProgress.pbActivity.Position := 0;
      for TimeIndex := 1 to NPER do
      begin
        WriteDataSet4(TimeIndex);
        if (TimeIndex = 1) or TimeVaryingLeakance then
        begin
          if TimeVaryingLeakance then
          begin
            EvaluateLeakance(TimeIndex);
          end;
          WriteDataSet5;
          WriteDataSet6;
          WriteDataSets7and8;
        end;
        if ITMP1 > 0 then
        begin
          WriteDataSet9(TimeIndex);
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then
          Exit;
      end;

      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then
        Exit;

    finally
      CloseFile(FFile);
    end;

  finally
    Grid.Free(CurrentModelHandle);
    WriteErrors;
  end;
end;

{function TLakeWriter.GetLakeLeakanceIndicies(UnitNumber : integer) :
  TLakeLeakanceIndicies;
var
  LakeLeakanceLayer : TLayerOptions;
  LayerName : string;
begin
  LayerName := ModflowTypes.GetMFLakeLeakanceLayerType.ANE_LayerName
    + IntToStr(UnitNumber);
  LakeLeakanceLayer := TLayerOptions.CreateWithName(LayerName,ModelHandle);
  try
    result.HydraulicConductivity := LakeLeakanceLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFLakeHydraulicCondParamType.ANE_ParamName);

    result.Thickness := LakeLeakanceLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFLakeThicknessParamType.ANE_ParamName);
  finally
    LakeLeakanceLayer.Free(ModelHandle);
  end;

end; }

function TLakeWriter.GetLakeGageIndicies: TLakeDataIndicies;
begin
  result.LakeNumber := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeNumberParamType.ANE_ParamName);
  result.Gage := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFGageParamType.ANE_ParamName);
  result.GageOutputType := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFGageOutputTypeParamType.ANE_ParamName);
end;

function TLakeWriter.GetLakeIndicies(
  IsTransient: boolean): TLakeDataIndicies;
begin
  result := GetLakeGageIndicies;

  {  result.LakeNumber := LakeLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFLakeNumberParamType.ANE_ParamName); }

  result.InitialStage := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeInitialStageParamType.ANE_ParamName);

  if IsTransient then
  begin
    result.MinimumStage := -1;
    result.MaximumStage := -1;
  end
  else
  begin
    result.MinimumStage := LakeLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFLakeMinimumStageParamType.ANE_ParamName);

    result.MaximumStage := LakeLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFLakeMaximumStageParamType.ANE_ParamName);
  end;

  {  result.Gage := LakeLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFGageParamType.ANE_ParamName);  }

  result.BottomElevation := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeBottomParamType.ANE_ParamName);

  if frmModflow.cbSubLakes.Checked then
  begin
    result.CenterLake := LakeLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFCenterLakeParamType.ANE_ParamName);

    result.Sill := LakeLayer.GetParameterIndex
      (ModelHandle, ModflowTypes.GetMFLakeSillParamType.ANE_ParamName);
  end
  else
  begin
    result.CenterLake := -1;
    result.Sill := -1;
  end;

end;

function TLakeWriter.GetLakeMoc3dIndicies(
  ConsituentNumber: integer): TMOC3DLakeDataIndicies;
begin
  // ConsituentNumber not used in current version of the GUI
  // it is included to facilitate conversion of the GUI to support
  // multiple constituents.
  result.InitialConcentration := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeInitialConcParamType.ANE_ParamName);

end;

function TLakeWriter.GetLakeMoc3dTimeIndicies(StressPeriod,
  ConsituentNumber: integer): TMOC3DLakeTimeDataIndicies;
begin
  // ConsituentNumber not used in current version of the GUI
  // it is included to facilitate conversion of the GUI to support
  // multiple constituents.
  result.PrecipConc := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakePrecipConcParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  result.RunoffConc := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeRunoffConcParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  result.AugmentConc := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeAugmentationConcParamType.ANE_ParamName
    + IntToStr(StressPeriod));
end;

function TLakeWriter.GetLakeTimeIndicies(
  StressPeriod: integer): TLakeTimeDataIndicies;
begin
  result.Precip := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakePrecipParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  result.Evap := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeEvapParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  result.Runoff := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeRunoffParamParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  result.Withdrawal := LakeLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFLakeWithdrawalsParamType.ANE_ParamName
    + IntToStr(StressPeriod));
end;

function TLakeWriter.MakeLakeLayer: string;
begin
  result := ModflowTypes.GetMFLakeLayerType.ANE_LayerName;
  LakeLayer := TLayerOptions.CreateWithName(result, ModelHandle);
end;

procedure TLakeWriter.MakeLake;
var
  LayerName: string;
begin
  LayerName := MakeLakeLayer;
  AddVertexLayer(ModelHandle, LayerName);
end;

procedure TLakeWriter.EvaluateGages;
var
  CountourCount: integer;
  ContourIndex: integer;
  LakeContour: TContourObjectOptions;
begin
  CountourCount := LakeLayer.NumObjects(ModelHandle, pieContourObject);
  for ContourIndex := 0 to CountourCount - 1 do
  begin
    LakeContour := TContourObjectOptions.Create(ModelHandle,
      LakeLayer.LayerHandle, ContourIndex);
    try
      if LakeContour.ContourType(ModelHandle) = ctClosed then
      begin
        EvaluateContourForGages(LakeContour);
      end;
    finally
      LakeContour.Free;
    end;
  end;
end;

procedure TLakeWriter.EvaluateLayer(Modflow2000: boolean;
  BasicWriter: TBasicPkgWriter);
var
  CountourCount: integer;
  ContourIndex: integer;
  LakeContour: TContourObjectOptions;
  Lake: TLakeObject;
  LakeNumberErrors: TStringList;
begin
  SetGridAngle;
  LakeNumberErrors := TStringList.Create;
  try
    if not TimeVaryingLeakance then
    begin
      EvaluateLeakance(1);
    end;
//    EvaluateLeakance;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
      Exit;

    CountourCount := LakeLayer.NumObjects(ModelHandle, pieContourObject);
    frmProgress.pbActivity.Max := CountourCount;
    frmProgress.pbActivity.Position := 0;
    frmProgress.lblActivity.Caption := 'Evaluating Lakes';
    for ContourIndex := 0 to CountourCount - 1 do
    begin
      LakeContour := TContourObjectOptions.Create(ModelHandle,
        LakeLayer.LayerHandle,
        ContourIndex);
      try
        if LakeContour.ContourType(ModelHandle) <> ctClosed then
        begin
          Inc(AreaErrors);
        end
        else
        begin
          Lake := EvaluateContour(LakeContour);
          if Lake.Data.LakeNumber <= 0 then
          begin
            LakeNumberErrors.Add(IntToStr(Lake.Data.LakeNumber));
          end;
          EvaluateCells(Modflow2000, ContourIndex, Lake, BasicWriter);
          EvaluateTimeData(LakeContour, Lake);
        end;
      finally
        LakeContour.Free;
      end;
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then
        Exit;
    end;
    EvaluateSubLakes;

    if LakeNumberErrors.Count > 0 then
    begin
      frmProgress.reErrors.Lines.Add('');
      ErrorMessages.Add('');
      frmProgress.reErrors.Lines.Add('Error: Lake number < 1');
      ErrorMessages.Add('Error: Lake number < 1');
      ErrorMessages.Add('Lake number(s)');
      ErrorMessages.AddStrings(LakeNumberErrors);
    end;

  finally
    LakeNumberErrors.Free;
  end;

end;

procedure TLakeWriter.EvaluateContourForGages(LakeContour:
  TContourObjectOptions);
var
  LakeData: TLakeData;
begin
  LakeData.LakeNumber := LakeContour.GetIntegerParameter
    (ModelHandle, LakeDataIndicies.LakeNumber);

  LakeData.Gage := LakeContour.GetBoolParameter
    (ModelHandle, LakeDataIndicies.Gage);

  if LakeData.Gage then
  begin
    LakeGageList.Add(-LakeData.LakeNumber);

    LakeData.GageOutputType := LakeContour.GetIntegerParameter
      (ModelHandle, LakeDataIndicies.GageOutputType);

    LakeGageOutputTypeList.Add(LakeData.GageOutputType);

  end;
end;

function TLakeWriter.EvaluateContour(LakeContour: TContourObjectOptions):
  TLakeObject;
var
  LakeData: TLakeData;
  LakeIndex: integer;
  LakeObject: TLakeObject;
begin
  LakeData.LakeNumber := LakeContour.GetIntegerParameter
    (ModelHandle, LakeDataIndicies.LakeNumber);

  LakeData.InitialStage := LakeContour.GetFloatParameter
    (ModelHandle, LakeDataIndicies.InitialStage);

  if LakeDataIndicies.MinimumStage > -1 then
  begin
    LakeData.MinimumStage := LakeContour.GetFloatParameter
      (ModelHandle, LakeDataIndicies.MinimumStage);
  end
  else
  begin
    LakeData.MinimumStage := 0;
  end;

  if LakeDataIndicies.MaximumStage > -1 then
  begin
    LakeData.MaximumStage := LakeContour.GetFloatParameter
      (ModelHandle, LakeDataIndicies.MaximumStage);
  end
  else
  begin
    LakeData.MaximumStage := 0;
  end;

  LakeData.Gage := LakeContour.GetBoolParameter
    (ModelHandle, LakeDataIndicies.Gage);

  if LakeData.Gage then
  begin
    LakeGageList.Add(-LakeData.LakeNumber);

    LakeData.GageOutputType := LakeContour.GetIntegerParameter
      (ModelHandle, LakeDataIndicies.GageOutputType);

    LakeGageOutputTypeList.Add(LakeData.GageOutputType);
  end;

  if LakeDataIndicies.CenterLake > -1 then
  begin
    LakeData.CenterLake := LakeContour.GetIntegerParameter
      (ModelHandle, LakeDataIndicies.CenterLake);
  end
  else
  begin
    LakeData.CenterLake := 0;
  end;

  if LakeDataIndicies.Sill > -1 then
  begin
    LakeData.Sill := LakeContour.GetFloatParameter
      (ModelHandle, LakeDataIndicies.Sill);
  end
  else
  begin
    LakeData.Sill := 0;
  end;

  LakeIndex := LakeList.Add(LakeData);
  LakeObject := LakeList.Items[LakeIndex] as TLakeObject;
  EvaluateMOC3DData(LakeContour, LakeObject);
  result := LakeObject;
end;

constructor TLakeWriter.Create;
begin
  inherited;
  LakeList := TLakeList.Create;
  SubLakeErrors := TStringList.Create;
end;

destructor TLakeWriter.Destroy;
begin
  LakeList.Free;
  SubLakeErrors.Free;
  if LakeLayer <> nil then
  begin
    LakeLayer.Free(ModelHandle);
  end;
  inherited;
end;

procedure TLakeWriter.EvaluateMOC3DData(LakeContour: TContourObjectOptions;
  Lake: TLakeObject);
var
  Indicies: TMOC3DLakeDataIndicies;
  Moc3dData: TMOC3DLakeData;
  ConstituentIndex: integer;
begin
  for ConstituentIndex := 0 to Moc3dConstiuents - 1 do
  begin
    Indicies := MOC3DLakeDataIndicies[ConstituentIndex];
    Moc3dData.InitialConcentration := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.InitialConcentration);
    Lake.Moc3dLakeList.Add(Moc3dData);
  end;
end;

procedure TLakeWriter.EvaluateTimeData(LakeContour: TContourObjectOptions;
  Lake: TLakeObject);
var
  Indicies: TLakeTimeDataIndicies;
  TimeData: TLakeTimeData;
  StressIndex: integer;
  TimeObjectIndex: integer;
  LakeTimeObject: TLakeTimeObject;
  Max: integer;
begin
  if frmModflow.comboLakSteady.ItemIndex = 0 then
  begin
    Max := 1;
  end
  else
  begin
    Max := StrToInt(frmModflow.edNumPer.Text);
  end;
  for StressIndex := 0 to Max - 1 do
  begin
    Indicies := LakeTimeDataIndicies[StressIndex];

    TimeData.Precip := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.Precip);

    TimeData.Evap := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.Evap);

    TimeData.Runoff := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.Runoff);

    TimeData.Withdrawal := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.Withdrawal);

    TimeObjectIndex := Lake.LakeTimeList.Add(TimeData);
    LakeTimeObject := Lake.LakeTimeList.Items[TimeObjectIndex] as
      TLakeTimeObject;

    EvaluateMOC3DTimeData(LakeContour, LakeTimeObject, StressIndex);
  end;

end;

procedure TLakeWriter.EvaluateMOC3DTimeData(
  LakeContour: TContourObjectOptions; LakeTimeObject: TLakeTimeObject;
  StressIndex: integer);
var
  Indicies: TMOC3DLakeTimeDataIndicies;
  Moc3dTimeData: TMOC3DLakeTimeData;
  ConstituentIndex: integer;
begin
  for ConstituentIndex := 0 to Moc3dConstiuents - 1 do
  begin
    Indicies := MOC3DLakeTimeDataIndicies[StressIndex, ConstituentIndex];

    Moc3dTimeData.PrecipConc := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.PrecipConc);

    Moc3dTimeData.RunoffConc := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.RunoffConc);

    Moc3dTimeData.AugmentConc := LakeContour.GetFloatParameter
      (ModelHandle, Indicies.AugmentConc);

    LakeTimeObject.MocTimeData.Add(Moc3dTimeData);
  end;

end;

procedure TLakeWriter.EvaluateLeakance(StressPeriod: integer);
var
  ColIndex, RowIndex: integer;
  CellCenter: TCellCenter;
  X, Y: double;
  UnitIndex: integer;
  ModflowLayerIndex: integer;
  LeakanceExpression: string;
  Leakance: double;
  DiscretizationCount: integer;
  DiscretizationIndex: integer;
begin
  if TimeVaryingLeakance then
  begin
    frmProgress.lblActivity.Caption :=
      'Evaluating Lake Leakance: Stress Period '
      + IntToStr(StressPeriod);
  end
  else
  begin
    frmProgress.lblActivity.Caption := 'Evaluating Lake Leakance';
  end;
  frmProgress.pbActivity.Max := NCOL * NROW;
  frmProgress.pbActivity.Position := 0;
  Application.ProcessMessages;
  for ColIndex := 0 to NCOL - 1 do
  begin
    for RowIndex := 0 to NROW - 1 do
    begin
      CellCenter := CellCenters[ColIndex, RowIndex];
      X := CellCenter.X;
      Y := CellCenter.Y;
      ModflowLayerIndex := -1;
      for UnitIndex := 1 to NUNITS do
      begin
        if Simulated[UnitIndex - 1] then
        begin
          if TimeVaryingLeakance then
          begin
            LeakanceExpression :=
              ModflowTypes.GetMFLakeLeakanceLayerType.ANE_LayerName
              + IntToStr(UnitIndex)
              + '.'
              + ModflowTypes.GetMFLakeHydraulicCondParamType.ANE_ParamName
              + IntToStr(StressPeriod)
              + '/'
              + ModflowTypes.GetMFLakeLeakanceLayerType.ANE_LayerName
              + IntToStr(UnitIndex)
              + '.'
              + ModflowTypes.GetMFLakeThicknessParamType.ANE_ParamName
              + IntToStr(StressPeriod)
          end
          else
          begin
            LeakanceExpression :=
              ModflowTypes.GetMFLakeLeakanceLayerType.ANE_LayerName
              + IntToStr(UnitIndex)
              + '.'
              + ModflowTypes.GetMFLakeHydraulicCondParamType.ANE_ParamName
              + '/'
              + ModflowTypes.GetMFLakeLeakanceLayerType.ANE_LayerName
              + IntToStr(UnitIndex)
              + '.'
              + ModflowTypes.GetMFLakeThicknessParamType.ANE_ParamName;
          end;

          Leakance := Grid.RealValueAtXY(ModelHandle, X, Y, LeakanceExpression);
          DiscretizationCount := LayersPerUnit[UnitIndex - 1];
          for DiscretizationIndex := 0 to DiscretizationCount - 1 do
          begin
            Inc(ModflowLayerIndex);
            LakeLeakanceArray[ColIndex, RowIndex, ModflowLayerIndex]
              := Leakance;
          end;
        end;
      end;
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then
        Exit;
    end;
  end;
end;

procedure TLakeWriter.EvaluateCells(Modflow2000: boolean; ContourIndex: integer;
  Lake: TLakeObject; BasicWriter: TBasicPkgWriter);
var
  ColIndex, RowIndex: integer;
  CellCenter: TCellCenter;
  X, Y: double;
  UnitIndex: integer;
  Top, Bottom: double;
  ModflowLayerIndex: integer;
  DiscretizationCount: integer;
  LayerThickness: double;
  DiscretizationIndex: integer;
  LakeElevation: double;
  BottomExpression: string;
  CellCenterElevation: double;
  BottomFound: boolean;
  LakeNumber: integer;
//  TempX, TempY: double;
begin
  LakeNumber := LakeList.IndexOf(Lake) + 1;

  BottomExpression := ModflowTypes.GetMFLakeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFLakeBottomParamType.ANE_ParamName;

  for ColIndex := 0 to NCOL - 1 do
  begin
    for RowIndex := 0 to NROW - 1 do
    begin
      CellCenter := CellCenters[ColIndex, RowIndex];
      X := CellCenter.X;
      Y := CellCenter.Y;
      RotatePointsToGrid(X, Y, GridAngle);
      if GPointInsideContour(ContourIndex, X, Y) then
      begin
        LakeElevation := Grid.RealValueAtXY(ModelHandle, CellCenter.X,
          CellCenter.Y, BottomExpression);
        ModflowLayerIndex := -1;
        BottomFound := False;
        for UnitIndex := 1 to NUNITS do
        begin
          if Simulated[UnitIndex - 1] then
          begin
            Top := Elevation(Modflow2000, ColIndex, RowIndex, UnitIndex - 1);
            Bottom := Elevation(Modflow2000, ColIndex, RowIndex, UnitIndex);
            DiscretizationCount := LayersPerUnit[UnitIndex - 1];
            LayerThickness := (Top - Bottom) / DiscretizationCount;
            for DiscretizationIndex := 0 to DiscretizationCount - 1 do
            begin
              CellCenterElevation := Top
                - (DiscretizationIndex + 0.5) * LayerThickness;
              Inc(ModflowLayerIndex);
              if (LakeElevation <= CellCenterElevation) then
              begin
                LakeNumberArray[ColIndex, RowIndex, ModflowLayerIndex]
                  := LakeNumber;
                BasicWriter.MFIBOUND[ColIndex, RowIndex, ModflowLayerIndex] :=
                  0;
              end
              else
              begin
                BottomFound := True;
                break;
              end;
            end;
            if BottomFound then
            begin
              break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TLakeWriter.MFLakeNumber(ArgusLakeNumber: integer): integer;
begin
  result := LakeList.MFLakeNumber(ArgusLakeNumber);
end;

procedure TLakeWriter.EvaluateSubLakes;
var
  ALake, CenterLake: TLakeObject;
  Index: integer;
begin
  if frmModflow.cbSubLakes.Checked then
  begin
    for Index := 0 to LakeList.Count - 1 do
    begin
      ALake := LakeList.Items[Index] as TLakeObject;
      //      ALake.OriginalNumber := Index + 1;
      if ALake.Data.CenterLake <> 0 then
      begin
        CenterLake := LakeList.GetLakeByLakeNumber(ALake.Data.CenterLake);
        if (CenterLake = nil) then
        begin
          if ShowWarnings then
          begin
            SubLakeErrors.Add(Format('[%d, %d]', [ALake.Data.LakeNumber,
              ALake.Data.CenterLake]));
          end;
        end
        else
        begin
          CenterLake.SubLakes.Add(ALake);
        end;
      end;
    end;
  end;
end;

procedure TLakeWriter.WriteDataSet1(const Modflow2000: boolean);
var
  NLAKES, ILKCB: integer;
begin
  NLAKES := self.LakeList.Count;
  if frmModflow.cbFlowLak.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      if Modflow2000 then
      begin
        ILKCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        ILKCB := frmModflow.GetUnitNumber('BUDUnit');
      end;
    end
    else
    begin
      ILKCB := frmModflow.GetUnitNumber('LAKBUD');
    end;
  end
  else
  begin
    ILKCB := 0;
  end;
  Writeln(FFile, NLAKES, ' ', ILKCB);
end;

procedure TLakeWriter.WriteDataSet2;
var
  THETA: double;
  NSSITR: integer;
  SSCNCR: double;
  SURFDEPTH: double;
begin
  THETA := InternationalStrToFloat(frmModflow.adeLakTheta.Text);
  NSSITR := StrToInt(frmModflow.adeLakIterations.Text);
  SSCNCR := InternationalStrToFloat(frmModflow.adeLakeConvCriterion.Text);
  SURFDEPTH := InternationalStrToFloat(frmModflow.adeSurfDepth.Text);
  // Negative values of THETA are required in order to read
  // NSSITR and SSCNCR in transient simulations or SURFDEPTH in any simulation.
  WriteLn(FFile, -THETA, ' ', NSSITR, ' ', SSCNCR, ' ', SURFDEPTH);
//  if Transient then
//  begin
//    WriteLn(FFile, -THETA, ' ', NSSITR, ' ', SSCNCR, ' ', SURFDEPTH);
////    WriteLn(FFile, THETA);
//  end
//  else
//  begin
//    WriteLn(FFile, THETA, ' ', NSSITR, ' ', SSCNCR, ' ', SURFDEPTH);
//  end;
end;

procedure TLakeWriter.WriteDataSet3;
var
  ALake: TLakeObject;
  Index: Integer;
begin
  frmProgress.pbActivity.Max := LakeList.Count;
  frmProgress.pbActivity.Position := 0;
  for Index := 0 to LakeList.Count - 1 do
  begin
    ALake := LakeList.Items[Index] as TLakeObject;
    ALake.WriteData(self, Transient);
    frmProgress.pbActivity.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then
      Exit;
  end;

end;

procedure TLakeWriter.WriteDataSet4(StressPeriod: integer);
var
  LWRT: integer;
begin
  if (StressPeriod = 1) or TimeVaryingLeakance then
  begin
    ITMP := 1;
  end
  else
  begin
    ITMP := -1;
  end;
  if (StressPeriod = 1) or (frmModflow.comboLakSteady.ItemIndex = 1) then
  begin
    ITMP1 := 1;
  end
  else
  begin
    ITMP1 := -1;
  end;
  if frmModflow.cbLakePrint.Checked then
  begin
    LWRT := 0;
  end
  else
  begin
    LWRT := 1;
  end;
  WriteLn(FFile, ITMP, ' ', ITMP1, ' ', LWRT);
end;

procedure TLakeWriter.WriteDataSet5;
var
  LayerIndex, RowIndex, ColIndex: integer;
begin
  for LayerIndex := 0 to NLAY - 1 do
  begin
    WriteU2DINTHeader;
    for RowIndex := 0 to NROW - 1 do
    begin
      for ColIndex := 0 to NCOL - 1 do
      begin
        Write(FFile, LakeNumberArray[ColIndex, RowIndex, LayerIndex], ' ');
      end;
      WriteLn(FFile);
    end;
  end;
end;

procedure TLakeWriter.WriteDataSet6;
var
  LayerIndex, RowIndex, ColIndex: integer;
begin
  for LayerIndex := 0 to NLAY - 1 do
  begin
    WriteU2DRELHeader;
    for RowIndex := 0 to NROW - 1 do
    begin
      for ColIndex := 0 to NCOL - 1 do
      begin
        Write(FFile, LakeLeakanceArray[ColIndex, RowIndex, LayerIndex], ' ');
      end;
      WriteLn(FFile);
    end;
  end;
end;

procedure TLakeWriter.WriteDataSets7and8;
var
  NSLMS: integer;
  Index: integer;
  ALake: TLakeObject;
begin
  NSLMS := 0;
  for Index := 0 to LakeList.Count - 1 do
  begin
    ALake := LakeList.Items[Index] as TLakeObject;
    if ALake.SubLakes.Count > 0 then
    begin
      Inc(NSLMS);
    end;
  end;

  Writeln(FFile, NSLMS);
  if NSLMS > 0 then
  begin
    for Index := 0 to LakeList.Count - 1 do
    begin
      ALake := LakeList.Items[Index] as TLakeObject;
      ALake.WriteSubLakes(self);
    end;
  end;
end;

procedure TLakeWriter.WriteDataSet9(StressPeriod: integer);
var
  Index: integer;
  ALake: TLakeObject;
begin
  for Index := 0 to LakeList.Count - 1 do
  begin
    ALake := LakeList.Items[Index] as TLakeObject;
    ALake.WriteTimeData(self, StressPeriod - 1);
  end;
end;

procedure TLakeWriter.WriteFile96(const CurrentModelHandle: ANE_PTR;
  Root: string; BasicWriter: TBasicPkgWriter);
var
  MinX, MaxX, MinY, MaxY: ANE_DOUBLE;
  GridLayerHandle: ANE_PTR;
  TimeIndex: integer;
  NPER: integer;
  FileName: string;
begin
  WriteGageUnit.InitializeLakeGages;
  GetGrid(CurrentModelHandle,
    ModflowTypes.GetGridLayerType.WriteNewRoot,
    GridLayerHandle, NROW, NCOL,
    MinX, MaxX, MinY, MaxY, GridAngle);
  NLAY := frmMODFLOW.MODFLOWLayerCount;
  NPER := StrToInt(frmMODFLOW.edNumPer.Text);

  ModelHandle := CurrentModelHandle;
  SetGridReversed;
  try
    TimeVaryingLeakance := frmModflow.comboLakSteadyLeakance.ItemIndex = 1;
    Initialize;
    EvaluateLayer(False, BasicWriter);

    FileName := Root + rsLak;
    AssignFile(FFile, FileName);
    try
      Rewrite(FFile);
      WriteDataSet1(False);
      WriteDataSet2;
      WriteDataSet3;
      for TimeIndex := 1 to NPER do
      begin
        WriteDataSet4(TimeIndex);
        if (TimeIndex = 1) or TimeVaryingLeakance then
        begin
          if TimeVaryingLeakance then
          begin
            EvaluateLeakance(TimeIndex);
          end;
          WriteDataSet5;
          WriteDataSet6;
          WriteDataSets7and8;
        end;
        if ITMP1 > 0 then
        begin
          WriteDataSet9(TimeIndex);
        end;
      end;
    finally
      CloseFile(FFile);
    end;

  finally
    Grid.Free(CurrentModelHandle);
    WriteErrors;
  end;

end;

procedure TLakeWriter.InitializeGages(const CurrentModelHandle: ANE_PTR);
begin
  ModelHandle := CurrentModelHandle;

  GageInitialize;
  EvaluateGages;
end;

class procedure TLakeWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowLak.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      if Modflow2000 then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('BUDUnit');
      end;
    end
    else
    begin
      frmModflow.GetUnitNumber('LAKBUD');
    end;
  end
end;

{ TLakeObject }

constructor TLakeObject.Create;
begin
  Moc3dLakeList := TMoc3dLakeList.Create;
  LakeTimeList := TLakeTimeList.Create;
  SubLakes := TList.Create;
end;

destructor TLakeObject.Destroy;
begin
  Moc3dLakeList.Free;
  LakeTimeList.Free;
  SubLakes.Free;
  inherited;
end;

procedure TLakeObject.WriteData(Writer: TLakeWriter; IsTransient: boolean);
begin
  Write(Writer.FFile,
    Data.InitialStage, ' ');
  if not IsTransient then
  begin
    Write(Writer.FFile,
      Data.MinimumStage, ' ',
      Data.MaximumStage, ' ');
  end;
  Moc3dLakeList.WriteData(Writer);
end;

procedure TLakeObject.WriteSubLakes(Writer: TLakeWriter);
var
  Index: integer;
  SubLake: TLakeObject;
begin
  if SubLakes.Count > 0 then
  begin
    Write(Writer.FFile, SubLakes.Count + 1, ' ', Writer.LakeList.IndexOf(self) +
      1, ' ');
    for Index := 0 to SubLakes.Count - 1 do
    begin
      SubLake := SubLakes[Index];
      Write(Writer.FFile, Writer.LakeList.IndexOf(SubLake) + 1, ' ');
    end;
    WriteLn(Writer.FFile);

    for Index := 0 to SubLakes.Count - 1 do
    begin
      SubLake := SubLakes[Index];
      Write(Writer.FFile, SubLake.Data.Sill, ' ');
    end;
    WriteLn(Writer.FFile);
  end;

end;

procedure TLakeObject.WriteTimeData(Writer: TLakeWriter;
  TimeIndex: integer);
begin
  LakeTimeList.WriteData(Writer, self, TimeIndex);
end;

{ TMOC3DLakeObject }

procedure TMOC3DLakeObject.WriteData(Writer: TLakeWriter);
begin
  Write(Writer.FFile, Moc3dData.InitialConcentration, ' ');
end;

{ TMoc3dLakeList }

function TMoc3dLakeList.Add(AValue: TMOC3DLakeData): integer;
var
  MOC3DLakeObject: TMOC3DLakeObject;
begin
  MOC3DLakeObject := TMOC3DLakeObject.Create;
  MOC3DLakeObject.Moc3dData := AValue;
  result := inherited Add(MOC3DLakeObject);
end;

procedure TMoc3dLakeList.WriteData(Writer: TLakeWriter);
var
  Index: integer;
  MOC3DLakeObject: TMOC3DLakeObject;
begin
  for Index := 0 to Count - 1 do
  begin
    MOC3DLakeObject := Items[Index] as TMOC3DLakeObject;
    MOC3DLakeObject.WriteData(Writer);
  end;
  Writeln(Writer.FFile);
end;

{ TLakeTimeObject }

constructor TLakeTimeObject.Create;
begin
  MocTimeData := TMoc3dLakeTimeList.Create;
end;

destructor TLakeTimeObject.Destroy;
begin
  MocTimeData.Free;
  inherited;
end;

procedure TLakeTimeObject.WriteData(const Writer: TLakeWriter;
  const Lake: TLakeObject; const StressPeriod: integer);
begin
  // Data set 9a.
  Write(Writer.FFile,
    TimeData.Precip, ' ',
    TimeData.Evap, ' ',
    TimeData.Runoff, ' ',
    TimeData.Withdrawal);
  if (StressPeriod > 1) and frmModflow.IsSteady(StressPeriod) then
  begin
    Write(Writer.FFile, ' ', Lake.Data.MinimumStage, ' ', Lake.Data.MaximumStage);
  end;
  Writeln(Writer.FFile);

  // Data set 9b.
  MocTimeData.WriteData(Writer, TimeData.Withdrawal);
end;

{procedure TLakeTimeObject.WriteTimeData(Writer: TLakeWriter;
  TimeIndex: integer);
begin
//  MocTimeData.WriteData(
end;}

{ TMOC3DLakeTimeObject }

procedure TMOC3DLakeTimeObject.WriteData(Writer: TLakeWriter; Withdrawal:
  double);
begin
  Write(Writer.FFile,
    MOC3DTimeData.PrecipConc, ' ',
    MOC3DTimeData.RunoffConc, ' ');
  if Withdrawal < 0 then
  begin
    Writeln(Writer.FFile,
      MOC3DTimeData.AugmentConc);
  end
  else
  begin
    Writeln(Writer.FFile);
  end;
end;

{ TMoc3dLakeTimeList }

function TMoc3dLakeTimeList.Add(AValue: TMOC3DLakeTimeData): integer;
var
  MOC3DLakeTimeObject: TMOC3DLakeTimeObject;
begin
  MOC3DLakeTimeObject := TMOC3DLakeTimeObject.Create;
  MOC3DLakeTimeObject.MOC3DTimeData := AValue;
  result := inherited Add(MOC3DLakeTimeObject);
end;

procedure TMoc3dLakeTimeList.WriteData(Writer: TLakeWriter; Withdrawal: double);
var
  Index: integer;
  MOC3DLakeTimeObject: TMOC3DLakeTimeObject;
begin
  for Index := 0 to Count - 1 do
  begin
    MOC3DLakeTimeObject := Items[Index] as TMOC3DLakeTimeObject;
    MOC3DLakeTimeObject.WriteData(Writer, Withdrawal);
  end;
end;

{ TLakeTimeList }

function TLakeTimeList.Add(AValue: TLakeTimeData): integer;
var
  LakeTimeObject: TLakeTimeObject;
begin
  LakeTimeObject := TLakeTimeObject.Create;
  LakeTimeObject.TimeData := AValue;
  result := inherited Add(LakeTimeObject);
end;

procedure TLakeTimeList.WriteData(const Writer: TLakeWriter;
  const Lake: TLakeObject; const TimeIndex: integer);
var
  LakeTimeObject: TLakeTimeObject;
begin
  LakeTimeObject := Items[TimeIndex] as TLakeTimeObject;
  LakeTimeObject.WriteData(Writer, Lake, TimeIndex+1);
end;

{ TLakeList }

function TLakeList.Add(AValue: TLakeData): integer;
var
  LakeObject: TLakeObject;
begin
  LakeObject := TLakeObject.Create;
  LakeObject.Data := AValue;
  result := inherited Add(LakeObject);
end;

function TLakeList.GetLakeByLakeNumber(LakeNumber: integer): TLakeObject;
var
  LakeObject: TLakeObject;
  Index: integer;
begin
  result := nil;
  for Index := 0 to Count - 1 do
  begin
    LakeObject := Items[Index] as TLakeObject;
    if LakeObject.Data.LakeNumber = LakeNumber then
    begin
      result := LakeObject;
      Exit;
    end;
  end;
end;

function TLakeList.MFLakeNumber(ArgusLakeNumber: integer): integer;
var
  LakeObject: TLakeObject;
  Index: integer;
begin
  result := 0;
  for Index := 0 to Count - 1 do
  begin
    LakeObject := Items[Index] as TLakeObject;
    if LakeObject.Data.LakeNumber = ArgusLakeNumber then
    begin
      result := Index + 1;
      Exit;
    end;
  end;
end;

procedure TLakeList.WriteData(Writer: TLakeWriter; IsTransient: boolean);
var
  Index: integer;
  LakeObject: TLakeObject;
begin
  for Index := 0 to Count - 1 do
  begin
    LakeObject := Items[Index] as TLakeObject;
    LakeObject.WriteData(Writer, IsTransient);
  end;
end;

procedure TLakeList.WriteTimeData(Writer: TLakeWriter; TimeIndex: integer);
var
  Index: integer;
  LakeObject: TLakeObject;
begin
  for Index := 0 to Count - 1 do
  begin
    LakeObject := Items[Index] as TLakeObject;
    LakeObject.WriteTimeData(Writer, TimeIndex);
  end;
end;

{procedure GInitializeLakeGages (const refPtX : ANE_DOUBLE_PTR      ;
    const refPtY : ANE_DOUBLE_PTR     ;
    numParams : ANE_INT16          ;
    const parameters : ANE_PTR_PTR ;
    funHandle : ANE_PTR            ;
    reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
  LakeWriter : TLakeWriter;
begin
  try
    try
      LakeWriter := TLakeWriter.Create;
      try
        LakeWriter.InitializeGages(funHandle);;
      finally
        LakeWriter.Free;
      end;

      Result := True;
    except on E : Exception do
      begin
        Result := False;
        Beep;
        MessageDlg(E.message, mtError, [mbOK], 0);
      end;
    end;

  finally
    ANE_BOOL_PTR(reply)^ := result;
  end;

end;  }

end.

