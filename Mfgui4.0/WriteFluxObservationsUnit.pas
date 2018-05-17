unit WriteFluxObservationsUnit;

interface

uses Sysutils, Classes, Forms, Grids, contnrs, ANEPIE, OptionsUnit,
  WriteModflowDiscretization, WriteCHDUnit;

Type
  TObservationCell = record
    Layer : integer;
    Row : integer;
    Column : integer;
    Factor : double;
  end;

  TObservationTime = record
    ObservationName : string[12];
    Time : double;
    Loss : double;
    Statistic : double;
    StatFlag : integer;
    PlotSymbol : integer;
    ObservationIndex : integer;
    ReferenceStressPeriod: integer;
  end;

  TObservationGroupParamaterIndicies = record
    GroupNumberIndex : ANE_INT16;
////    StatisticIndex : ANE_INT16;
    StatFlagIndex : ANE_INT16;
    PlotSymbolIndex : ANE_INT16;
    FactorIndex : ANE_INT16;
    TopLayerIndex : ANE_INT16;
    BottomLayerIndex : ANE_INT16;
  end;

  TObservationTimeParamaterIndicies = record
    ObservationNameIndex : ANE_INT16;
    TimeIndex : ANE_INT16;
    LossIndex : ANE_INT16;
    ObservationIndexIndex : ANE_INT16;
    StatisticIndex : ANE_INT16;
    IsObservationIndex : ANE_INT16;
    IsPredictionIndex : ANE_INT16;
    ReferenceStressPeriodIndex : ANE_INT16;
  end;

  TCellGroupList = Class;
  TObservationTimeObject = Class;

  TCustomObservationWriter = class(TListWriter)
  private
    IOWTQ : integer;
    NQT : integer;
    CellGroups : TCellGroupList;
    ModelHandle : ANE_PTR;
    ObservationIndicies : array of integer;
    ObservationsTimes : array of TObservationTimeObject;
    procedure EvaluateLayer(LayerIndex: integer; GridLayer : TLayerOptions;
      Discretization: TDiscretizationWriter; GridAngle : double;
      ACustomBoundaryWriter : TCustomBoundaryWriter);
    procedure GetContourProperties(
      LayerName : string; GridLayer : TLayerOptions;
      Discretization : TDiscretizationWriter;
      GridAngle : double; ACustomBoundaryWriter : TCustomBoundaryWriter);
    function GetLayerName(LayerIndex: integer): string;
    procedure GetPropertiesOfAContour(Layer, GridLayer : TLayerOptions;
      ContourIndex : ANE_INT32;
      ParamaterIndicies : TObservationGroupParamaterIndicies;
      Discretization : TDiscretizationWriter;
      TopLayerExpression, BottomLayerExpression : string;
      GridAngle : double; ACustomBoundaryWriter : TCustomBoundaryWriter);
    function GetObservationGroupParamIndicies
      (ObservationLayer : TLayerOptions) : TObservationGroupParamaterIndicies;
    function GetTimeParamIndicies(Layer: TLayerOptions;
      TimeIndex: integer): TObservationTimeParamaterIndicies;
    procedure WriteDataSet1(Cells, Times : integer);
    procedure WriteDataSet2;
    procedure WriteDataSets3To5(Data : TStringList);
    procedure EvaluateDataSets3To5(Discretization : TDiscretizationWriter;
      Boundaries: TCustomBoundaryWriterWithObservations;
      DataSets3To5 : TStringList; var Cells, Times : integer;
      BasicWriter : TBasicPkgWriter; CHD_Writer : TCHDPkgWriter);
    procedure SetObservationIndicies;
    function GetObservationIndex(Index : integer) : integer;
    procedure WriteDataSet6;
    procedure WriteDataSet7;
    procedure EvaluateLayers(Discretization: TDiscretizationWriter;
      ACustomBoundaryWriter : TCustomBoundaryWriterWithObservations);
  protected
    UsePredictions : boolean;
    function GetLayerRoot : string; virtual; abstract;
    function GetEVF : double; virtual; abstract;
    function GetIOWTQ : integer; virtual; abstract;
    function GetIPRN : integer; virtual; abstract;
    function GetNumberOfLayers: Integer; virtual; abstract;
    function GetNumberOfTimes: Integer; virtual; abstract;
    function GetFileExtension: string; virtual; abstract;
    function GetPackageName: string; virtual; abstract;
    function GetVarianceStringGrid : TStringGrid; virtual; abstract;
    function UseLayer(Const LayerIndex: integer): boolean; virtual; abstract;
    function GetOutKey: string; virtual; abstract;
  public
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter;
      ACustomBoundaryWriter : TCustomBoundaryWriterWithObservations;
      BasicWriter : TBasicPkgWriter; CHD_Writer : TCHDPkgWriter);
  end;

  TCellList = class(TObjectList)
  private
    function IndexOf(ACell : TObservationCell): Integer;
    function Add(ACell : TObservationCell): Integer;
    procedure WriteDataSet5(
      Boundaries: TCustomBoundaryWriterWithObservations; Lines : TStringList;
      GroupNumber : integer; BasicWriter : TBasicPkgWriter;
      CHD_Writer : TCHDPkgWriter);
  end;

  TTimeList = Class(TObjectList)
  private
    function IndexOf(ATime : TObservationTime): Integer;
    function Add(ATime : TObservationTime): Integer;
    procedure WriteDataSet4(Discretization: TDiscretizationWriter;
      Lines : TStringList);
  end;

  TCellGroup = Class(TObject)
  private
    Index : integer;
    CellList : TCellList;
    TimeList : TTimeList;
    Procedure EvaluateCellGroup(Discretization: TDiscretizationWriter;
      Boundaries: TCustomBoundaryWriterWithObservations; CellGroupLines : TStringList;
      var Cells, Times : integer; BasicWriter : TBasicPkgWriter;
      CHD_Writer : TCHDPkgWriter);
  public
    Constructor Create;
    Destructor Destroy; override;
  end;

  TCellGroupList = Class(TObjectList)
  private
    function GetCellGroupByGroupIndex(Index : integer) : TCellGroup;
  end;

  TObservationTimeObject = Class(TObject)
  private
    Time : TObservationTime;
//    Procedure GetPeriodAndOffset(var StressPeriod : integer;
//      var TimeOffSet : double; Discretization : TDiscretizationWriter);
    Procedure WriteTime(Discretization: TDiscretizationWriter;
      Lines : TStringList);
  end;


implementation

Uses Variables, PointInsideContourUnit, FreeBlockUnit, GetCellUnit,
  UtilityFunctions, FixNameUnit, ProgressUnit;

type
  TObservationCellObject = Class(TObject)
  private
    Cell : TObservationCell;
    Procedure WriteCell(
      Boundaries: TCustomBoundaryWriterWithObservations; Lines : TStringList;
      GroupNumber : integer; BasicWriter : TBasicPkgWriter;
      CHD_Writer : TCHDPkgWriter);
  end;



procedure TCustomObservationWriter.EvaluateLayer(
  LayerIndex : integer;
  GridLayer : TLayerOptions;
  Discretization: TDiscretizationWriter;
  GridAngle : double; ACustomBoundaryWriter : TCustomBoundaryWriter);
var
  LayerName : string;  
begin
  if UseLayer(LayerIndex) then
  begin
    LayerName := GetLayerName(LayerIndex);
    AddVertexLayer(ModelHandle, LayerName);
    GetContourProperties(LayerName, GridLayer, Discretization, GridAngle,
      ACustomBoundaryWriter);
  end;
end;

procedure TCustomObservationWriter.EvaluateLayers
  (Discretization: TDiscretizationWriter;
  ACustomBoundaryWriter : TCustomBoundaryWriterWithObservations);
var
  LayerIndex : integer;
  GridLayer : TLayerOptions;
  GridAngle : ANE_DOUBLE;
  LayerName : String;
  NumberOfLayers : integer;
  GridLayerHandle : ANE_PTR;
begin
  LayerName := ModflowTypes.GetGridLayerType.WriteNewRoot;

  GetGridAngle(ModelHandle, LayerName, GridLayerHandle, GridAngle);
  
  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    NumberOfLayers := GetNumberOfLayers;
    frmProgress.pbActivity.Max := NumberOfLayers;
    frmProgress.pbActivity.Position := 0;
    frmProgress.lblActivity.Caption := 'Evaluating Observation Layers';
    Application.ProcessMessages;
    for LayerIndex := 1 to NumberOfLayers do
    begin
      if ContinueExport then
      begin
        EvaluateLayer(LayerIndex, GridLayer, Discretization, GridAngle,
          ACustomBoundaryWriter);
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
      end;
    end;
  finally
    GridLayer.Free(ModelHandle);
  end;

  frmProgress.pbPackage.StepIt;
end;

function TCustomObservationWriter.GetTimeParamIndicies(Layer : TLayerOptions;
  TimeIndex : integer): TObservationTimeParamaterIndicies;
var
  ParamName, TimeString : string;
begin
  TimeString:= IntToStr(TimeIndex);

  ParamName := ModflowTypes.GetMFObservationNameParamType.WriteParamName
    + TimeString;
  result.ObservationNameIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFTimeParamType.WriteParamName
    + TimeString;
  result.TimeIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFLossParamType.WriteParamName
    + TimeString;
  result.LossIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFObservationNumberParamType.WriteParamName
    + TimeString;
  result.ObservationIndexIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFStatisticParamType.WriteParamName
    + TimeString;
  result.StatisticIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFIsObservationParamType.WriteParamName
    + TimeString;
  result.IsObservationIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFIsPredictionParamType.WriteParamName
    + TimeString;
  result.IsPredictionIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName
    + TimeString;
  result.ReferenceStressPeriodIndex := Layer.GetParameterIndex
    (ModelHandle, ParamName);

end;

procedure TCustomObservationWriter.GetPropertiesOfAContour(
  Layer, GridLayer : TLayerOptions;
  ContourIndex : ANE_INT32;
  ParamaterIndicies : TObservationGroupParamaterIndicies;
  Discretization : TDiscretizationWriter;
  TopLayerExpression, BottomLayerExpression : string;
  GridAngle : double; ACustomBoundaryWriter : TCustomBoundaryWriter);
var
  Contour : TContourObjectOptions;
  ACellGroup : TCellGroup;
  GroupNumber : ANE_INT32;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  X, Y, XR, YR : ANE_DOUBLE;
  ACell : TObservationCell;
  ATime : TObservationTime;
  TopLayer, BottomLayer, LayerIndex : integer;
  TimeIndex : integer;
  TimeIndicies : TObservationTimeParamaterIndicies;
  UseTime : boolean;

//  TopLayerIndex, BottomLayerIndex : ANE_Int16;
begin
{  ParamName := ModflowTypes.GetMFTopLayerParamType.WriteParamName;
  result.TopLayerIndex := ObservationLayer.GetParameterIndex
    (CurrentModelHandle, ParamName); }

{  ParamName := ModflowTypes.GetMFBottomLayerParamType.WriteParamName;
  result.BottomLayerIndex := ObservationLayer.GetParameterIndex
    (CurrentModelHandle, ParamName);  }

  Contour := TContourObjectOptions.Create(ModelHandle,
    Layer.LayerHandle, ContourIndex);
  try
    if ParamaterIndicies.GroupNumberIndex < 0 then
    begin
      // prescribed head fluxes
      GroupNumber := 0;
    end
    else
    begin
      // all other fluxes
      GroupNumber := Contour.GetIntegerParameter(ModelHandle,
        ParamaterIndicies.GroupNumberIndex);
    end;
    if GroupNumber = 0 then
    begin
      ACellGroup := nil;
    end
    else
    begin
      ACellGroup := CellGroups.GetCellGroupByGroupIndex(GroupNumber);
    end;
    if ACellGroup = nil then
    begin
      ACellGroup := TCellGroup.Create;
      ACellGroup.Index := GroupNumber;
      CellGroups.Add(ACellGroup);
    end;
//    ATime.Statistic := Contour.GetFloatParameter(ModelHandle,
//      ParamaterIndicies.StatisticIndex);
    ATime.StatFlag := Contour.GetIntegerParameter(ModelHandle,
      ParamaterIndicies.StatFlagIndex);
    ATime.PlotSymbol := Contour.GetIntegerParameter(ModelHandle,
      ParamaterIndicies.PlotSymbolIndex);
    ACell.Factor := Contour.GetFloatParameter(ModelHandle,
      ParamaterIndicies.FactorIndex);
{
    ATime.ReferenceStressPeriod := Contour.GetIntegerParameter(ModelHandle,
      ParamaterIndicies.ReferenceStressPeriodIndex);
}
    if Contour.ContourType(ModelHandle) = ctClosed then
    begin
      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        ACell.Column := ColIndex+1; //Discretization.ColNumber(ColIndex);
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          ACell.Row := RowIndex+1; //Discretization.RowNumber(RowIndex);
          BlockIndex := Discretization.BlockIndex(RowIndex,ColIndex);
          ABlock := TBlockObjectOptions.Create(ModelHandle,
            GridLayer.LayerHandle, BlockIndex);
          try
            ABlock.GetCenter(ModelHandle, X, Y);
            XR := X;
            YR := Y;
            RotatePointsToGrid(XR, YR, GridAngle);
            if GPointInsideContour(ContourIndex, XR, YR) then
            begin
              TopLayer := GridLayer.IntegerValueAtXY(ModelHandle, X, Y,
                TopLayerExpression);
              BottomLayer := GridLayer.IntegerValueAtXY(ModelHandle, X, Y,
                BottomLayerExpression);
              for LayerIndex := TopLayer to BottomLayer do
              begin
                ACell.Layer := LayerIndex;
                if (ACustomBoundaryWriter = nil) or
                   (ACustomBoundaryWriter.BoundaryUsed(ACell.Layer,
                    ACell.Row, ACell.Column)) then
                begin
                  ACellGroup.CellList.Add(ACell);
                end;
              end;

            end;
          finally
            ABlock.Free;
          end;

        end;


      end;
    end
    else
    begin
      TopLayer := Contour.GetIntegerParameter(ModelHandle,
        ParamaterIndicies.TopLayerIndex);
      BottomLayer := Contour.GetIntegerParameter(ModelHandle,
        ParamaterIndicies.BottomLayerIndex);
      for BlockIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
      begin
        ACell.Row := GGetCellRow(ContourIndex,BlockIndex);
        ACell.Column := GGetCellColumn(ContourIndex,BlockIndex);
        for LayerIndex := TopLayer to BottomLayer do
        begin
          ACell.Layer := LayerIndex;
//          ACellGroup.CellList.Add(ACell);
                if (ACustomBoundaryWriter = nil) or
                   (ACustomBoundaryWriter.BoundaryUsed(ACell.Layer,
                    ACell.Row, ACell.Column)) then
                begin
                  ACellGroup.CellList.Add(ACell);
                end;
        end;
      end;
    end;

    for TimeIndex := 1 to GetNumberOfTimes do
    begin
      TimeIndicies := GetTimeParamIndicies(Layer, TimeIndex);

      if UsePredictions then
      begin
        UseTime := Contour.GetBoolParameter (ModelHandle,
          TimeIndicies.IsPredictionIndex);
      end
      else
      begin
        UseTime := Contour.GetBoolParameter (ModelHandle,
          TimeIndicies.IsObservationIndex);
      end;

      {if (TimeIndex = 1) and not UseTime then
      begin
        break;
      end;}


      if UseTime then
      begin
        ATime.Time := Contour.GetFloatParameter(ModelHandle,
          TimeIndicies.TimeIndex);
        ATime.ReferenceStressPeriod := Contour.GetIntegerParameter(ModelHandle,
          TimeIndicies.ReferenceStressPeriodIndex);
        if (TimeIndex = 1) or (ATime.Time <> 0)
          or (ATime.ReferenceStressPeriod <> 1) then
        begin
          ATime.ObservationName := Contour.GetStringParameter(ModelHandle,
            TimeIndicies.ObservationNameIndex);
          ATime.Loss := Contour.GetFloatParameter(ModelHandle,
            TimeIndicies.LossIndex);
          ATime.Statistic := Contour.GetFloatParameter(ModelHandle,
            TimeIndicies.StatisticIndex);
          if TimeIndicies.ObservationIndexIndex < 0 then
          begin
            ATime.ObservationIndex := -1;
          end
          else
          begin
            ATime.ObservationIndex := Contour.GetIntegerParameter(ModelHandle,
              TimeIndicies.ObservationIndexIndex);
          end;
          ACellGroup.TimeList.Add(ATime);
        end;
      end;
    end;

  finally
    Contour.Free;
  end;

end;

procedure TCustomObservationWriter.GetContourProperties(
  LayerName : string;
  GridLayer : TLayerOptions; Discretization : TDiscretizationWriter;
  GridAngle : double; ACustomBoundaryWriter : TCustomBoundaryWriter);
var
  LayerHandle : ANE_PTR;
  Project : TProjectOptions;
  Layer : TLayerOptions;
  ContourCount : integer;
  ContourIndex : integer;
  ParamaterIndicies : TObservationGroupParamaterIndicies;
  TopLayerExpression, BottomLayerExpression : string;
begin

  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(ModelHandle,LayerName);
  finally
    Project.Free;
  end;
  if LayerHandle <> nil then
  begin
    Layer := TLayerOptions.Create(LayerHandle);
    try
      ParamaterIndicies := GetObservationGroupParamIndicies
        (Layer);
      TopLayerExpression := LayerName + '.'
        + ModflowTypes.GetMFTopLayerParamType.WriteParamName;
      BottomLayerExpression := LayerName + '.'
        + ModflowTypes.GetMFBottomLayerParamType.WriteParamName;
      ContourCount := Layer.NumObjects(ModelHandle,pieContourObject);
      for ContourIndex := 0 to ContourCount -1 do
      begin
        GetPropertiesOfAContour(Layer, GridLayer,
          ContourIndex, ParamaterIndicies, Discretization,
          TopLayerExpression, BottomLayerExpression, GridAngle,
          ACustomBoundaryWriter);
      end;

    finally
      Layer.Free(ModelHandle);
    end;

  end;

end;

function TCustomObservationWriter.GetLayerName(LayerIndex : integer) : string;
begin
   result := GetLayerRoot + IntToStr(LayerIndex);
end;

procedure TCustomObservationWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter;
  ACustomBoundaryWriter : TCustomBoundaryWriterWithObservations;
  BasicWriter : TBasicPkgWriter; CHD_Writer : TCHDPkgWriter);
var
  FileName : string;
  Max : integer;
  DataSets3To5 : TStringList;
  Cells, Times : integer;
begin
  Max := 2;
  if GetIOWTQ > 0 then
  begin
    Inc(Max);
  end;
  frmProgress.lblPackage.Caption := GetPackageName;
  frmProgress.pbPackage.Max := Max;
  frmProgress.pbPackage.Position := 0;
  ModelHandle := CurrentModelHandle;
  CellGroups := TCellGroupList.Create;
  DataSets3To5 := TStringList.Create;
  try
    UsePredictions := frmModflow.UsePredictions;
    FileName := GetCurrentDir + '\' + Root + GetFileExtension;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);

      if ContinueExport then
      begin
        EvaluateLayers(Discretization, ACustomBoundaryWriter);
        Application.ProcessMessages;
      end;

      if ContinueExport then
      begin
        EvaluateDataSets3To5(Discretization, ACustomBoundaryWriter,
          DataSets3To5,Cells, Times, BasicWriter, CHD_Writer);
        Application.ProcessMessages;
      end;

      if ContinueExport then
      begin
        WriteDataSet1(Cells, Times);
        Application.ProcessMessages;
      end;

      if ContinueExport then
      begin
        WriteDataSet2;
        Application.ProcessMessages;
      end;

      if ContinueExport then
      begin
        WriteDataSets3To5(DataSets3To5);
        Application.ProcessMessages;
      end;

      if IOWTQ > 0 then
      begin
        if ContinueExport then
        begin
          WriteDataSet6;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          WriteDataSet7;
          Flush(FFile);
          Application.ProcessMessages;
        end;
      end;

    finally
      CloseFile(FFile);
    end;
  finally
    CellGroups.Free;
    DataSets3To5.Free;
  end;
end;

function TCustomObservationWriter.GetObservationGroupParamIndicies(
  ObservationLayer: TLayerOptions)
  : TObservationGroupParamaterIndicies;
var
  ParamName : string;
begin
  // result.GroupNumberIndex will be -1 for observations of
  // flux at prescribed head cells.
  ParamName := ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName;
  result.GroupNumberIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);


  ParamName := ModflowTypes.GetMFTopLayerParamType.WriteParamName;
  result.TopLayerIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);
  Assert(result.TopLayerIndex >= 0);

  ParamName := ModflowTypes.GetMFBottomLayerParamType.WriteParamName;
  result.BottomLayerIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);
  Assert(result.BottomLayerIndex >= 0);

{  ParamName := ModflowTypes.GetMFStatisticParamType.WriteParamName;
  result.StatisticIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName); }

  ParamName := ModflowTypes.GetMFStatFlagParamType.WriteParamName;
  result.StatFlagIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);
  Assert(result.StatFlagIndex >= 0);

  ParamName := ModflowTypes.GetMFPlotSymbolParamType.WriteParamName;
  result.PlotSymbolIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);
  Assert(result.PlotSymbolIndex >= 0);

  ParamName := ModflowTypes.GetMFFactorParamType.WriteParamName;
  result.FactorIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);
  Assert(result.FactorIndex >= 0);

{
  ParamName := ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName;
  result.ReferenceStressPeriodIndex := ObservationLayer.GetParameterIndex
    (ModelHandle, ParamName);
  Assert(result.ReferenceStressPeriodIndex >= 0);
}
end;
{procedure TCustomObservationWriter.EvaluateDataSets3To5(
  Discretization: TDiscretizationWriter; Boundaries: TCustomBoundaryWriter);
begin
end;}


procedure TCustomObservationWriter.EvaluateDataSets3To5(
  Discretization: TDiscretizationWriter;
  Boundaries: TCustomBoundaryWriterWithObservations;
  DataSets3To5 : TStringList; var Cells, Times : integer;
  BasicWriter : TBasicPkgWriter; CHD_Writer : TCHDPkgWriter);
var
  CellGroupIndex : integer;
  ACellGroup : TCellGroup;
  ThisCellCount, ThisTimeCount : integer;
  Errors: TStringList;
  TimeIndex: integer;
  TimeObject : TObservationTimeObject;
  ErrorMessage: string;
begin
  Errors := TStringList.Create;
  try

    Cells := 0;
    Times := 0;
    if CellGroups.Count > 0 then
    begin
      frmProgress.pbActivity.Max := CellGroups.Count;
      frmProgress.pbActivity.Position := 0;
        frmProgress.lblActivity.Caption := 'Writing cell groups';
      Application.ProcessMessages;
      ThisCellCount := 0;
      ThisTimeCount := 0;
      for CellGroupIndex := 0 to CellGroups.Count -1 do
      begin
        if ContinueExport then
        begin
          ACellGroup := CellGroups.Items[CellGroupIndex] as TCellGroup;
          ACellGroup.EvaluateCellGroup(Discretization, Boundaries,
            DataSets3To5, ThisCellCount, ThisTimeCount, BasicWriter, CHD_Writer);
          Cells := Cells + ThisCellCount;
          Times := Times + ThisTimeCount;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          for TimeIndex := 0 to ACellGroup.TimeList.Count -1 do
          begin
            TimeObject := ACellGroup.TimeList[TimeIndex] as TObservationTimeObject;
            if TimeObject.Time.Statistic <= 0 then
            begin
              ErrorMessage := TimeObject.Time.ObservationName;
              Errors.Add(ErrorMessage);
            end;

          end;

        end;
      end;
    end;
    if Errors.Count > 0 then
    begin
      ErrorMessage := 'Error: Some observations in the ' + GetPackageName
        + ' package have values of '
        + 'Statistic[i] that are less than or equal to 0.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);

      ErrorMessage := 'The names of observations that have this problem '
        + 'are listed below.';
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.AddStrings(Errors);

    end;

    frmProgress.pbPackage.StepIt;

  finally
    Errors.Free;
  end;
end;

procedure TCustomObservationWriter.WriteDataSet2;
const
  TOMULT = 1.0;
var
  EVF : Double;
begin
  EVF := GetEVF;
  IOWTQ := GetIOWTQ;
  if frmMODFLOW.rbModflow2005.Checked then
  begin
    WriteLn(FFile, TOMULT);
  end
  else
  begin
    WriteLn(FFile, TOMULT, ' ', FreeFormattedReal(EVF), IOWTQ);
  end;
end;

procedure TCustomObservationWriter.WriteDataSet1(Cells, Times : integer);
var
  NQ, NQC : integer;
  IUOBSV: integer;
begin
  NQ := CellGroups.Count;

  NQC := Cells;
  NQT := Times;

  if frmMODFLOW.rbModflow2005.Checked then
  begin
    IUOBSV := frmModflow.GetUnitNumber(GetOutKey);
    Writeln(FFile, NQ, ' ', NQC, ' ', NQT, ' ', IUOBSV);
  end
  else
  begin
    Writeln(FFile, NQ, ' ', NQC, ' ', NQT);
  end;
end;

function TCustomObservationWriter.GetObservationIndex(
  Index: integer): integer;
begin
  result := ObservationIndicies[Index-1];
end;

procedure TCustomObservationWriter.SetObservationIndicies;
var
  GroupIndex, TimeIndex : integer;
  ACellGroup : TCellGroup;
  ATime : TObservationTimeObject;
  ObsIndex : integer;
  UseVarianceCovarianceTable : Boolean;
begin
  ObsIndex := 0;
  SetLength(ObservationIndicies, NQT);
  UseVarianceCovarianceTable := GetIOWTQ > 0;
  if  UseVarianceCovarianceTable then
  begin
    SetLength(ObservationsTimes, NQT);
  end;
  for GroupIndex := 0 to CellGroups.Count -1 do
  begin
    ACellGroup := CellGroups.Items[GroupIndex] as TCellGroup;
    for TimeIndex := 0 to ACellGroup.TimeList.Count -1 do
    begin
      ATime := ACellGroup.TimeList.Items[TimeIndex] as TObservationTimeObject;
      ObservationIndicies[ObsIndex] := ATime.Time.ObservationIndex;
      if UseVarianceCovarianceTable then
      begin
        ObservationsTimes[ObsIndex] := ATime;
      end;
      Inc(ObsIndex);
    end;
  end;
end;

procedure TCustomObservationWriter.WriteDataSet6;
var
  IPRN : integer;
begin
  IPRN := GetIPRN;
  WriteLn(FFile, '(', NQT, 'F20.0) ', IPRN);
//  WriteLn(FFile, '(FREE) ', IPRN);
end;

procedure TCustomObservationWriter.WriteDataSet7;
var
  RowIndex, ColIndex : integer;
  Row, Col : integer;
  AStringGrid : TStringGrid;
  ATimeObservation : TObservationTimeObject;
begin
  if NQT > 0 then
  begin
    frmProgress.pbActivity.Max := Sqr(NQT);
    frmProgress.pbActivity.Position := 0;
    frmProgress.lblActivity.Caption := 'Writing variance-covariance matrix';
    Application.ProcessMessages;
    SetObservationIndicies;
    AStringGrid := GetVarianceStringGrid;
    for ColIndex := 1 to NQT do
    begin
      Write(FFile, ' ');
      If ContinueExport then
      begin
        Col := GetObservationIndex(ColIndex);
        for RowIndex := 1 to NQT do
        begin
          If ContinueExport then
          begin
            Row := GetObservationIndex(RowIndex);
            if (Col < 1) or (Row < 1)
              or (Col > AStringGrid.ColCount-1)
              or (Row > AStringGrid.RowCount-1) then
            begin
              if ColIndex = RowIndex then
              begin
                ATimeObservation := ObservationsTimes[ColIndex-1];
                Write(FFile, FreeFormattedReal({WriteFormat,[}ATimeObservation.Time.Statistic{]}));
              end
              else
              begin
                Write(FFile, FreeFormattedReal(0.0));
              end;
            end
            else
            begin
              Write(FFile, FreeFormattedReal(InternationalStrToFloat(AStringGrid.Cells[Col,Row])));
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
          end;
        end;
      end;
      WriteLn(FFile);
    end;
  end;
  frmProgress.pbPackage.StepIt;
end;

{ TObservationCellObject }

procedure TObservationCellObject.WriteCell(
  Boundaries: TCustomBoundaryWriterWithObservations; Lines : TStringList;
  GroupNumber : integer; BasicWriter : TBasicPkgWriter;
  CHD_Writer : TCHDPkgWriter);
var
  Factor : double;
  BoundaryList : TObjectList;
  Index : integer;
  ABoundaryCell : TBoundaryCell;
  Procedure AddLine;
  begin
    if Boundaries = nil then
    begin
      Lines.Add(Format('%d %d %d ', [Cell.Layer, Cell.Row, Cell.Column])
        + BasicWriter.FreeFormattedReal(Factor));
    end
    else
    begin
      Lines.Add(Format('%d %d %d ', [Cell.Layer, Cell.Row, Cell.Column])
        + Boundaries.FreeFormattedReal(Factor));
    end;

  end;
begin
  if Boundaries = nil then
  begin
    if (BasicWriter.MFIBOUND[Cell.Column-1, Cell.Row-1, Cell.Layer-1] < 0)
      or ((CHD_Writer <> nil) and CHD_Writer.BoundaryUsed(Cell.Layer,
      Cell.Row, Cell.Column) ) then
    begin
      Factor := Cell.Factor;
      AddLine;
    end;
  end
  else
  begin
    BoundaryList := TObjectList.Create;
    try
      Boundaries.FillBoundaryList(Cell.Layer, Cell.Row, Cell.Column,
        BoundaryList);
      for Index := 0 to BoundaryList.Count -1 do
      begin
        ABoundaryCell := BoundaryList[Index] as TBoundaryCell;
        if (ABoundaryCell.GroupNumber = 0) or
          (ABoundaryCell.GroupNumber = GroupNumber) then
        begin
          Factor := Cell.Factor;
        end
        else
        begin
          Factor := 0;
        end;
        AddLine;
  //      Lines.Add(Format('%d %d %d %.13e', [Cell.Layer, Cell.Row, Cell.Column, Factor]));
      end;
    finally
      BoundaryList.Free;
    end;
  end;
end;

{ TObservationTimeObject }

{procedure TObservationTimeObject.GetPeriodAndOffset(
  var StressPeriod: integer; var TimeOffSet: double;
  Discretization: TDiscretizationWriter);
begin
  Discretization.GetPeriodAndOffset( Time.Time, StressPeriod, TimeOffSet);
end;  }

procedure TObservationTimeObject.WriteTime(
  Discretization: TDiscretizationWriter;
  Lines : TStringList);
var
  StressPeriod: integer;
  TimeOffSet: double;
  Position : Integer;
  AName : string[12];
begin
  TimeOffSet := Time.Time;
  StressPeriod := Time.ReferenceStressPeriod;

  AName := Trim(Time.ObservationName);
  Position := Pos(' ', AName);
  while (Position > 0) do
  begin
    AName[Position] := '_';
    Position := Pos(' ', AName);
  end;
  AddObservationName(AName);

  if frmMODFLOW.rbModflow2005.Checked then
  begin
    Lines.Add('''' + AName + ''' ' + Format('%d ', [StressPeriod]) + ' '
      + Discretization.FreeFormattedReal(TimeOffSet)
      + Discretization.FreeFormattedReal(Time.Loss));
  end
  else
  begin
    Lines.Add('''' + AName + ''' ' + Format('%d ', [StressPeriod]) + ' '
      + Discretization.FreeFormattedReal(TimeOffSet)
      + Discretization.FreeFormattedReal(Time.Loss)
      + Discretization.FreeFormattedReal(Time.Statistic)
      + Format('%d %d',[Time.StatFlag, Time.PlotSymbol]));
  end;

end;

{ TCellList }

function TCellList.Add(ACell: TObservationCell): Integer;
var
  CellObject : TObservationCellObject;
begin
  result := IndexOf(ACell);
  if result = -1 then
  begin
    CellObject := TObservationCellObject.Create;
    CellObject.Cell := ACell;
    result := inherited Add(CellObject);
  end;
end;

function TCellList.IndexOf(ACell: TObservationCell): Integer;
var
  Index : integer;
  CellObject : TObservationCellObject;
begin
  result := -1;
  for Index := 0 to Count-1 do
  begin
    CellObject := Items[Index] as TObservationCellObject;
    if (CellObject.Cell.Layer = ACell.Layer)
      and (CellObject.Cell.Row = ACell.Row)
      and (CellObject.Cell.Column = ACell.Column) then
    begin
      result := Index;
      break;
    end;
  end;

end;

procedure TCellList.WriteDataSet5(
  Boundaries: TCustomBoundaryWriterWithObservations; Lines : TStringList;
  GroupNumber : integer; BasicWriter : TBasicPkgWriter;
  CHD_Writer : TCHDPkgWriter);
var
  CellIndex : integer;
  ACell : TObservationCellObject;
begin
  for CellIndex := 0 to Count -1 do
  begin
    ACell := Items[CellIndex] as TObservationCellObject;
    ACell.WriteCell(Boundaries, Lines, GroupNumber,
      BasicWriter, CHD_Writer);
  end;

end;

{ TTimeList }

function TTimeList.Add(ATime: TObservationTime): Integer;
var
  TimeObject : TObservationTimeObject;
begin
  result := IndexOf(ATime);
  if result = -1 then
  begin
    TimeObject := TObservationTimeObject.Create;
    TimeObject.Time := ATime;
    result := inherited Add(TimeObject);
  end;
end;

function TTimeList.IndexOf(ATime: TObservationTime): Integer;
var
  Index : integer;
  TimeObject : TObservationTimeObject;
begin
  result := -1;
  for Index := 0 to Count-1 do
  begin
    TimeObject := Items[Index] as TObservationTimeObject;
    if (TimeObject.Time.ObservationName = ATime.ObservationName)
      and (TimeObject.Time.Time = ATime.Time)
      and (TimeObject.Time.Loss = ATime.Loss)
      and (TimeObject.Time.Statistic = ATime.Statistic)
      and (TimeObject.Time.StatFlag = ATime.StatFlag)
      and (TimeObject.Time.PlotSymbol = ATime.PlotSymbol)
      and (TimeObject.Time.ObservationIndex = ATime.ObservationIndex) then
    begin
      result := Index;
      break;
    end;
  end;
end;

procedure TTimeList.WriteDataSet4(
  Discretization: TDiscretizationWriter;
  Lines : TStringList);
var
  TimeIndex : integer;
  ATime : TObservationTimeObject;
begin
  for TimeIndex := 0 to Count -1 do
  begin
    ATime := Items[TimeIndex] as TObservationTimeObject;
    ATime.WriteTime(Discretization, Lines);
  end;
end;

{ TCellGroup }

constructor TCellGroup.Create;
begin
  inherited;
  CellList := TCellList.Create;
  TimeList := TTimeList.Create;
end;

destructor TCellGroup.Destroy;
begin
  CellList.Free;
  TimeList.Free;
  inherited;
end;

procedure TCellGroup.EvaluateCellGroup(
  Discretization: TDiscretizationWriter;
  Boundaries: TCustomBoundaryWriterWithObservations; CellGroupLines : TStringList;
  var  Cells, Times : integer; BasicWriter : TBasicPkgWriter;
  CHD_Writer : TCHDPkgWriter);
var
  CellLines : TStringList;
  TimeLines : TStringList;
begin
  CellLines := TStringList.Create;
  TimeLines := TStringList.Create;
  try
    TimeList.WriteDataSet4(Discretization, TimeLines);
    CellList.WriteDataSet5(Boundaries, CellLines, Index, BasicWriter, CHD_Writer);

    CellGroupLines.Add(IntToStr(TimeLines.Count) + ' ' + IntToStr(CellLines.Count));
    CellGroupLines.AddStrings(TimeLines);
    CellGroupLines.AddStrings(CellLines);
    Times := TimeLines.Count;
    Cells := CellLines.Count;
  finally
    CellLines.Free;
    TimeLines.Free;
  end;

end;

{ TCellGroupList }

function TCellGroupList.GetCellGroupByGroupIndex(
  Index: integer): TCellGroup;
var
  GroupIndex : integer;
  ACellGroup : TCellGroup;
begin
  result := nil;
  for GroupIndex := 0 to Count -1 do
  begin
    ACellGroup := Items[GroupIndex] as TCellGroup;
    if ACellGroup.Index = Index then
    begin
      result := ACellGroup;
      break;
    end;
  end;
end;

procedure TCustomObservationWriter.WriteDataSets3To5(Data : TStringList);
var
  Index : integer;
  ErrorMessage : string;
begin
  if Data.Count = 0 then
  begin
    ErrorMessage := 'Error: no observations were specified for use with the '
      + GetPackageName
      + '.  You should either turn off the '
      + GetPackageName
      + ' or specify some observations to use with it.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end;
  for Index := 0 to Data.Count -1 do
  begin
    WriteLn(FFile, Data[Index]);
  end;

end;

end.
