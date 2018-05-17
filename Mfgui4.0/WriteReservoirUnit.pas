unit WriteReservoirUnit;

interface

uses SysUtils, Classes, contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization, WriteNameFileUnit, WriteLakesUnit, CopyArrayUnit;

type
{  TReservoirData = record
    ReservoirNumber : integer;
  end;

{  TReservoirDataIndicies = record
    ReservoirNumber : ANE_INT16;
  end; }

  TReservoirTimeData = record
    StartingStage : double;
    EndingStage : double;
    MT3DConcentrations : T1DDoubleArray;
  end;

  TReservoirTimeDataIndicies = record
    StartingStage : ANE_INT16;
    EndingStage : ANE_INT16;
    MT3DConcentrationIndicies : array of ANE_INT16;
  end;

  TReservoirWriter = class;

  TReservoirTimeObject  = Class(TObject)
    TimeData : TReservoirTimeData;
{    constructor Create;
    Destructor Destroy; override; }
    procedure WriteData(Writer : TReservoirWriter);
  end;

  TReservoirTimeList = class(TObjectList)
    function Add(AValue : TReservoirTimeData) : integer;
{    procedure WriteData(Writer : TReservoirWriter; TimeIndex : integer);}
  end;

  TReservoirObject = Class(TObject)
//    Data : TReservoirData;
    ReservoirTimeList : TReservoirTimeList;
{    procedure WriteData(Writer : TReservoirWriter; IsTransient : boolean);}
    constructor Create;
    Destructor Destroy; override;
    Procedure WriteTimeData(Writer : TReservoirWriter; TimeIndex : integer);
{    procedure WriteSubReservoirs(Writer : TReservoirWriter);  }
  end;

  TReservoirList = Class(TObjectList)
    function Add : integer;
{    procedure WriteData(Writer : TReservoirWriter; IsTransient : boolean);
    procedure WriteTimeData(Writer : TReservoirWriter; TimeIndex : integer);}
//    function GetReservoirByNumber(ReservoirNumber : integer): TReservoirObject;
  end;

  TReservoirWriter = class(TCustomMF96Writer)
  private
    NRESOP : integer;
//    FDiscretization : TDiscretizationWriter;
    ReservoirLayer : TLayerOptions;
//    ReservoirDataIndicies : TReservoirDataIndicies;
    ReservoirList : TReservoirList;
    ReservoirTimeDataIndicies : array of TReservoirTimeDataIndicies;
    SpecifyLayerDirectly : boolean;
    ReservoirNumberArray : array of array of integer;
    LandSurface : array of array of double;
    HydraulicConductivity : array of array of double;
    Thickness : array of array of double;
    AreaErrors : integer;
    GridAngle: double;
    procedure Initialize;
    procedure EvaluateLayer(Modflow2000: boolean;
      BasicWriter: TBasicPkgWriter);
    function EvaluateContour(
      ReservoirContour: TContourObjectOptions): TReservoirObject;
    procedure EvaluateCells(Modflow2000: boolean; ContourIndex: integer;
      Reservoir: TReservoirObject; BasicWriter: TBasicPkgWriter);
    Procedure EvaluateTimeData(ReservoirContour : TContourObjectOptions;
      Reservoir: TReservoirObject);
    procedure SetGridAngle;
    procedure MakeReservoir;
//    function GetReservoirIndicies: TReservoirDataIndicies;
    function GetReservoirTimeIndicies(
      StressPeriod: integer): TReservoirTimeDataIndicies;
    procedure WriteDataSet1(MF2000 : boolean);
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure WriteDataSet7(TimeIndex : integer);
  public
    ReservoirLayerArray : array of array of integer;
    constructor Create;
    Destructor Destroy; override;
    procedure InitializeArrays(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicWriter: TBasicPkgWriter;
      Modflow2000: boolean);
    procedure WriteFile2000(const CurrentModelHandle: ANE_PTR;
      Root: string; Discretization: TDiscretizationWriter;
      BasicWriter : TBasicPkgWriter);
    procedure WriteFile96(const CurrentModelHandle: ANE_PTR; Root: string;
      BasicWriter: TBasicPkgWriter);
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines : TStrings);
    class procedure AssignUnitNumbers(MF2000 : boolean);
  end;


implementation

uses PointInsideContourUnit, UtilityFunctions, Variables, UnitNumbers,
  ProgressUnit;

{ TReservoirTimeList }

function TReservoirTimeList.Add(AValue: TReservoirTimeData): integer;
var
  ReservoirTimeObject : TReservoirTimeObject;
begin
  ReservoirTimeObject := TReservoirTimeObject.Create;
  result := inherited Add(ReservoirTimeObject);
  ReservoirTimeObject.TimeData.StartingStage := AValue.StartingStage;
  ReservoirTimeObject.TimeData.EndingStage := AValue.EndingStage;
  Copy1DDoubleArray(AValue.MT3DConcentrations,
    ReservoirTimeObject.TimeData.MT3DConcentrations);
end;

{ TReservoirList }

function TReservoirList.Add: integer;
var
  ReservoirObject : TReservoirObject;
begin
  ReservoirObject := TReservoirObject.Create;
  result := inherited Add(ReservoirObject);
end;

{function TReservoirList.GetReservoirByNumber(
  ReservoirNumber: integer): TReservoirObject;
var
  ReservoirObject : TReservoirObject;
  Index : integer;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ReservoirObject := Items[Index] as TReservoirObject;
    if ReservoirObject.Data.ReservoirNumber = ReservoirNumber then
    begin
      result := ReservoirObject;
      Exit;
    end;
  end;
end; }

{ TReservoirWriter }

procedure TReservoirWriter.EvaluateCells(Modflow2000: boolean; ContourIndex: integer;
  Reservoir : TReservoirObject; BasicWriter : TBasicPkgWriter);
var
  ColIndex, RowIndex : integer;
  CellCenter : TCellCenter;
  X, Y : double;
  RotatedX, RotatedY: double;
  UnitIndex : integer;
  Top, Bottom : double;
  ModflowLayerIndex : integer;
  DiscretizationCount : integer;
  LayerThickness : double;
  DiscretizationIndex : integer;
  ReservoirElevation : double;
  BottomExpression : String;
  CellBottomElevation : double;
  BottomFound : boolean;
  ReservoirNumber : integer;
//  LeakanceExpression : string;
//  Leakance : double;
  LayerNumberExpression : string;
  HydraulicConductivityExpression, ThicknessExpression : string;
begin
  ReservoirNumber := ReservoirList.IndexOf(Reservoir) + 1;

  BottomExpression := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFReservoirLandSurfaceParamType.ANE_ParamName;

  LayerNumberExpression := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFModflowLayerParamType.ANE_ParamName;

  HydraulicConductivityExpression := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFReservoirKzParamType.ANE_ParamName;

  ThicknessExpression := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFReservoirBedThicknessParamType.ANE_ParamName;

  for ColIndex := 0 to NCOL-1 do
  begin
    for RowIndex := 0 to NROW -1 do
    begin
      CellCenter := CellCenters[ColIndex,RowIndex];
      X := CellCenter.X;
      Y := CellCenter.Y;
      RotatedX := X;
      RotatedY := Y;
      RotatePointsToGrid(RotatedX, RotatedY, GridAngle);
      if GPointInsideContour(ContourIndex, RotatedX, RotatedY) then
      begin
        ReservoirNumberArray[ColIndex,RowIndex] := ReservoirNumber;

        ReservoirElevation :=
          Grid.RealValueAtXY(ModelHandle, X, Y, BottomExpression);
        LandSurface[ColIndex,RowIndex] := ReservoirElevation;

        HydraulicConductivity[ColIndex,RowIndex] :=
          Grid.RealValueAtXY(ModelHandle, X, Y, HydraulicConductivityExpression);

        Thickness[ColIndex,RowIndex] :=
          Grid.RealValueAtXY(ModelHandle, X, Y, ThicknessExpression);

        if SpecifyLayerDirectly then
        begin
          ReservoirLayerArray[ColIndex,RowIndex] :=
            Grid.IntegerValueAtXY(ModelHandle, X, Y, LayerNumberExpression);
        end
        else
        begin
          ReservoirLayerArray[ColIndex,RowIndex] := 1;
          ModflowLayerIndex := 1;
          BottomFound := False;
          for UnitIndex := 1 to NUNITS do
          begin
            if Simulated[UnitIndex-1] then
            begin
              Top := Elevation(Modflow2000,ColIndex,RowIndex,UnitIndex-1);
              Bottom := Elevation(Modflow2000,ColIndex,RowIndex,UnitIndex);
              DiscretizationCount := LayersPerUnit[UnitIndex-1];
              LayerThickness := (Top - Bottom)/DiscretizationCount;

              for DiscretizationIndex := 0 to DiscretizationCount-1 do
              begin
                CellBottomElevation := Top
                  - (DiscretizationIndex+1)*LayerThickness;
                Inc(ModflowLayerIndex);
                if  (ReservoirElevation <= CellBottomElevation) then
                begin
                  begin
                    ReservoirLayerArray[ColIndex,RowIndex]
                      := ModflowLayerIndex;
                    BasicWriter.MFIBOUND
                      [ColIndex,RowIndex,ModflowLayerIndex-2] := 0;
                  end;
                end
                else
                begin
                  BottomFound := True;
                  break;
                end;
              end;
              If BottomFound then
              begin
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TReservoirWriter.EvaluateContour
  (ReservoirContour: TContourObjectOptions) : TReservoirObject;
var
  ReservoirIndex : integer;
begin
  ReservoirIndex := ReservoirList.Add;
  result := ReservoirList.Items[ReservoirIndex] as TReservoirObject;
end;

procedure TReservoirWriter.EvaluateLayer(Modflow2000: boolean;
  BasicWriter : TBasicPkgWriter);
var
  CountourCount : integer;
  ContourIndex : integer;
  ReservoirContour : TContourObjectOptions;
  Reservoir : TReservoirObject;
begin
  CountourCount := ReservoirLayer.NumObjects(ModelHandle, pieContourObject);
  for ContourIndex := 0 to CountourCount -1 do
  begin
    ReservoirContour := TContourObjectOptions.Create(ModelHandle, ReservoirLayer.LayerHandle,
      ContourIndex);
    if ReservoirContour.ContourType(ModelHandle) <> ctClosed then
    begin
      Inc(AreaErrors);
    end
    else
    begin
      Reservoir := EvaluateContour(ReservoirContour);
      EvaluateCells(Modflow2000, ContourIndex, Reservoir, BasicWriter);
      EvaluateTimeData(ReservoirContour,Reservoir);
    end;
  end;
end;

procedure TReservoirWriter.EvaluateTimeData(
  ReservoirContour: TContourObjectOptions; Reservoir: TReservoirObject);
var
  Indicies : TReservoirTimeDataIndicies;
  TimeData : TReservoirTimeData;
  StressIndex : integer;
//  TimeObjectIndex : integer;
//  ReservoirTimeObject : TReservoirTimeObject;
  Max : integer;
  SpeciesIndex, SpeciesCount : integer;
begin
  if frmModflow.comboResSteady.ItemIndex = 0 then
  begin
    Max := 1;
  end
  else
  begin
    Max := StrToInt(frmModflow.edNumPer.Text);
  end;
  for StressIndex := 0 to Max -1 do
  begin
    Indicies := ReservoirTimeDataIndicies[StressIndex];

    TimeData.StartingStage := ReservoirContour.GetFloatParameter
      (ModelHandle, Indicies.StartingStage);

    TimeData.EndingStage := ReservoirContour.GetFloatParameter
      (ModelHandle, Indicies.EndingStage);

    if frmModflow.cbMT3D.Checked then
    begin
      SpeciesCount := Length(Indicies.MT3DConcentrationIndicies);
      SetLength(TimeData.MT3DConcentrations, SpeciesCount);
      for SpeciesIndex := 0 to SpeciesCount-1 do
      begin
        TimeData.MT3DConcentrations[SpeciesIndex]
          := ReservoirContour.GetFloatParameter
          (ModelHandle, Indicies.MT3DConcentrationIndicies[SpeciesIndex]);
      end;

    end;

    Reservoir.ReservoirTimeList.Add(TimeData);
  end;

end;

procedure TReservoirWriter.Initialize;
var
  ColIndex, RowIndex : integer;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
begin
  SpecifyLayerDirectly := (frmModflow.comboResOption.ItemIndex = 1) and
    frmModflow.cbRESLayer.Checked;
  SetGridAngle;
  MakeReservoir;
  NUNITS := StrToInt(frmModflow.edNumUnits.Text);

  SetLength(ReservoirLayerArray, NCOL, NROW);
  SetLength(ReservoirNumberArray, NCOL, NROW);
  SetLength(LandSurface, NCOL, NROW);
  SetLength(HydraulicConductivity, NCOL, NROW);
  SetLength(Thickness, NCOL, NROW);

  for ColIndex := 0 to NCOL -1 do
  begin
    for RowIndex := 0 to NROW -1 do
    begin
        ReservoirLayerArray[ColIndex, RowIndex] := 0;
        ReservoirNumberArray[ColIndex, RowIndex] := 0;
        LandSurface[ColIndex, RowIndex] := 0;
        HydraulicConductivity[ColIndex, RowIndex] := 0;
        Thickness[ColIndex, RowIndex] := 0;
    end;
  end;
  SetSimulated;

//  ReservoirDataIndicies := GetReservoirIndicies;

  StressPeriodCount := StrToInt(frmModflow.edNumPer.Text);
  SetLength(ReservoirTimeDataIndicies, StressPeriodCount);
  for StressPeriodIndex := 1 to StressPeriodCount do
  begin
    ReservoirTimeDataIndicies[StressPeriodIndex-1] :=
      GetReservoirTimeIndicies(StressPeriodIndex);
  end;

  InitializeCellCenters;

end;

{function TReservoirWriter.GetReservoirIndicies: TReservoirDataIndicies;
begin
  result.ReservoirNumber := ReservoirLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFReservoirNumberParamType.ANE_ParamName);
end;  }

function TReservoirWriter.GetReservoirTimeIndicies(
  StressPeriod: integer): TReservoirTimeDataIndicies;
var
  SpeciesCount, SpeciesIndex : integer;
  TimeParamName : string;
begin
  result.StartingStage := ReservoirLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFReservoirStartingStageParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  result.EndingStage := ReservoirLayer.GetParameterIndex
    (ModelHandle, ModflowTypes.GetMFReservoirEndingStageParamType.ANE_ParamName
    + IntToStr(StressPeriod));
  if frmModflow.cbMT3D.Checked then
  begin
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(result.MT3DConcentrationIndicies, SpeciesCount);
    for SpeciesIndex := 1 to SpeciesCount do
    begin
      case SpeciesIndex of
        1: TimeParamName := ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName;
        2: TimeParamName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
        3: TimeParamName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
        4: TimeParamName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
        5: TimeParamName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
      else Assert(False);
      end;
      TimeParamName := TimeParamName + IntToStr(StressPeriod);
      result.MT3DConcentrationIndicies[SpeciesIndex-1]
        := ReservoirLayer.GetParameterIndex(ModelHandle, TimeParamName);
    end;
  end;
end;


procedure TReservoirWriter.MakeReservoir;
var
  LayerName : string;
begin
  LayerName := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName;
  ReservoirLayer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
  AddVertexLayer(ModelHandle, LayerName);
end;

procedure TReservoirWriter.InitializeArrays(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicWriter : TBasicPkgWriter;
  Modflow2000 : boolean);
var
  ErrorMessage : string;
begin
  AreaErrors := 0;
  FDiscretization := Discretization;
  ModelHandle := CurrentModelHandle;
  SetGridReversed; // side effect: Creates Grid.
  try
    NCOL := FDiscretization.NCOL;
    NROW := FDiscretization.NROW;
    NLAY := FDiscretization.NLAY;
    Initialize;
    EvaluateLayer(Modflow2000, BasicWriter);


  finally
    Grid.Free(CurrentModelHandle);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the RES (Reservoir) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TReservoirWriter.WriteFile96(const CurrentModelHandle: ANE_PTR;
  Root: string; BasicWriter : TBasicPkgWriter);
var
  MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE;
  GridLayerHandle : ANE_PTR;
  TimeIndex : integer;
  NPER : integer;
  FileName : string;
begin
  GetGrid(CurrentModelHandle,
    ModflowTypes.GetGridLayerType.WriteNewRoot,
    GridLayerHandle, NROW, NCOL,
    MinX, MaxX, MinY, MaxY, GridAngle);
  NLAY := frmMODFLOW.MODFLOWLayerCount;
  NPER := StrToInt(frmMODFLOW.edNumPer.Text);

  ModelHandle := CurrentModelHandle;
  SetGridReversed; // side effect: Creates Grid.
  try
    Initialize;
    EvaluateLayer(False, BasicWriter);

    FileName := Root + rsRes;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataSet1(False);
      WriteDataSet2;
      WriteDataSet3;
      WriteDataSet4;
      WriteDataSet5;
      WriteDataSet6;
      for TimeIndex := 1 to NPER do
      begin
        WriteDataSet7(TimeIndex);
      end;
    finally
      CloseFile(FFile);
    end;

  finally
    Grid.Free(CurrentModelHandle);
//    WriteErrors;
  end;

end;


procedure TReservoirWriter.WriteFile2000(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter;
  BasicWriter: TBasicPkgWriter);
var
  TimeIndex : integer;
  NPER : integer;
  FileName : string;
  ErrorMessage : string;
begin
  FDiscretization := Discretization;
  ModelHandle := CurrentModelHandle;
  SetGridReversed; // side effect: Creates Grid.
  try
    NCOL := FDiscretization.NCOL;
    NROW := FDiscretization.NROW;
    NLAY := FDiscretization.NLAY;
    NPER := StrToInt(frmModflow.edNumPer.Text);
    Initialize;
    EvaluateLayer(True, BasicWriter);

    FileName := Root + rsRes;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataSet1(True);
      WriteDataSet2;
      WriteDataSet3;
      WriteDataSet4;
      WriteDataSet5;
      WriteDataSet6;
      for TimeIndex := 1 to NPER do
      begin
        WriteDataSet7(TimeIndex);
      end;
    finally
      CloseFile(FFile);
    end;

  finally
    Grid.Free(CurrentModelHandle);
//    WriteErrors;
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the Res (Reservoir) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
end;

constructor TReservoirWriter.Create;
begin
  inherited;
  ReservoirList := TReservoirList.Create;
end;

destructor TReservoirWriter.Destroy;
begin
  ReservoirList.Free;
  inherited;
end;


procedure TReservoirWriter.WriteDataSet1(MF2000 : boolean);
var
  NRES, IRESCB, IRESPT, NPTS : integer;
begin
  NRES := ReservoirList.Count;
  if frmModflow.cbFlowLak.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      if MF2000 then
      begin
        IRESCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        IRESCB := frmModflow.GetUnitNumber('BUDUnit');
      end;
    end
    else
    begin
      IRESCB := frmModflow.GetUnitNumber('RESBUD');
    end;
  end
  else
  begin
      IRESCB := 0;
  end;
  NRESOP := frmModflow.comboResOption.ItemIndex + 1;
  if frmModflow.cb95PrintRes.Checked then
  begin
    IRESPT := 1;
  end
  else
  begin
    IRESPT := 0;
  end;
  NPTS := StrToInt(frmModflow.adeResPointsCount.Text);
  Writeln(FFile, Format('%10d %9d %9d %9d %9d',
    [NRES, IRESCB, NRESOP, IRESPT, NPTS]));
end;

procedure TReservoirWriter.WriteDataSet2;
var
  RowIndex, ColIndex : integer;
begin
  WriteU2DINTHeader;
  for RowIndex := 0 to NROW -1 do
  begin
    for ColIndex := 0 to NCOL -1 do
    begin
      Write(FFile, ReservoirNumberArray[ColIndex,RowIndex], ' ');
    end;
    WriteLn(FFile);
  end;
end;

procedure TReservoirWriter.WriteDataSet3;
var
  RowIndex, ColIndex : integer;
begin
  if NRESOP = 2 then
  begin
    WriteU2DINTHeader;
    for RowIndex := 0 to NROW -1 do
    begin
      for ColIndex := 0 to NCOL -1 do
      begin
        Write(FFile, ReservoirLayerArray[ColIndex,RowIndex], ' ');
      end;
      WriteLn(FFile);
    end;
  end;
end;

procedure TReservoirWriter.WriteDataSet4;
var
  RowIndex, ColIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to NROW -1 do
  begin
    for ColIndex := 0 to NCOL -1 do
    begin
      Write(FFile, LandSurface[ColIndex,RowIndex], ' ');
    end;
    WriteLn(FFile);
  end;
end;

procedure TReservoirWriter.WriteDataSet5;
var
  RowIndex, ColIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to NROW -1 do
  begin
    for ColIndex := 0 to NCOL -1 do
    begin
      Write(FFile, HydraulicConductivity[ColIndex,RowIndex], ' ');
    end;
    WriteLn(FFile);
  end;
end;

procedure TReservoirWriter.WriteDataSet6;
var
  RowIndex, ColIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to NROW -1 do
  begin
    for ColIndex := 0 to NCOL -1 do
    begin
      Write(FFile, Thickness[ColIndex,RowIndex], ' ');
    end;
    WriteLn(FFile);
  end;
end;

procedure TReservoirWriter.WriteDataSet7(TimeIndex: integer);
var
  Index : integer;
  Reservoir : TReservoirObject;
begin
  for Index := 0 to ReservoirList.Count -1 do
  begin
    Reservoir := ReservoirList[Index] as TReservoirObject;
    Reservoir.WriteTimeData(self, TimeIndex-1);
  end;

end;


procedure TReservoirWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  ColIndex, RowIndex, Layer : integer;
  ResNumber : integer;
  Reservoir : TReservoirObject;
  ReservoirTimeObject : TReservoirTimeObject;
  ALine : string;
  SpeciesIndex : integer;
begin
  for ColIndex := 0 to NCOL -1 do
  begin
    for RowIndex := 0 to NROW -1 do
    begin
      ResNumber := ReservoirNumberArray[ColIndex,RowIndex];
      if ResNumber > 0 then
      begin
        Reservoir := ReservoirList[ResNumber-1] as TReservoirObject;
        ReservoirTimeObject := Reservoir.ReservoirTimeList[StressPeriod-1]
          as TReservoirTimeObject;
        Layer := ReservoirLayerArray[ColIndex,RowIndex];

        Assert(Length(ReservoirTimeObject.TimeData.MT3DConcentrations) >=1);
        ALine := TModflowWriter.FixedFormattedInteger(Layer, 10)
          + TModflowWriter.FixedFormattedInteger(RowIndex + 1, 10)
          + TModflowWriter.FixedFormattedInteger(ColIndex + 1, 10)
          + TModflowWriter.FixedFormattedReal(ReservoirTimeObject.TimeData.MT3DConcentrations[0], 10)
          + TModflowWriter.FixedFormattedInteger(22, 10) + ' ';
        for SpeciesIndex := 0 to
          Length(ReservoirTimeObject.TimeData.MT3DConcentrations)-1 do
        begin
          ALine := ALine + TModflowWriter.FreeFormattedReal
            (ReservoirTimeObject.TimeData.MT3DConcentrations[SpeciesIndex]);
        end;
        Lines.Add(ALine);


      end;
    end;
  end;
end;

procedure TReservoirWriter.SetGridAngle;
var
  GridLayer : TGridLayerOptions;
begin
  GridLayer := TGridLayerOptions.CreateWithName(ModflowTypes.GetGridLayerType.
    ANE_LayerName, ModelHandle);
  try
    GridAngle := GridLayer.GridAngle(ModelHandle);
  finally
    GridLayer.Free(ModelHandle);
  end;
end;

class procedure TReservoirWriter.AssignUnitNumbers(MF2000 : boolean);
begin
  if frmModflow.cbFlowLak.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      if MF2000 then
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
      frmModflow.GetUnitNumber('RESBUD');
    end;
  end
end;

{ TReservoirObject }

constructor TReservoirObject.Create;
begin
  inherited;
  ReservoirTimeList := TReservoirTimeList.Create;
end;

destructor TReservoirObject.Destroy;
begin
  ReservoirTimeList.Free;
  inherited;
end;

procedure TReservoirObject.WriteTimeData(Writer: TReservoirWriter;
  TimeIndex: integer);
var
  ReservoirTimeObject : TReservoirTimeObject;
begin
  if frmModflow.comboResSteady.ItemIndex = 0 then
  begin
    TimeIndex := 0;
  end;
  ReservoirTimeObject := ReservoirTimeList[TimeIndex] as TReservoirTimeObject;
  ReservoirTimeObject.WriteData(Writer);
end;

{ TReservoirTimeObject }

procedure TReservoirTimeObject.WriteData(Writer: TReservoirWriter);
var
  StartString, EndString : String;
begin
  StartString := Format('%10g', [TimeData.StartingStage]);
  While Length(StartString) < 10 do
  begin
    StartString := ' ' + StartString;
  end;
  EndString := Format('%10g', [TimeData.EndingStage]);
  While Length(EndString) < 10 do
  begin
    EndString := ' ' + EndString;
  end;
  Writeln(Writer.FFile, StartString, EndString);

end;

end.
