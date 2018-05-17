unit WriteGWM_StateVariables;

interface

uses
  WriteModflowDiscretization, AnePIE, SysUtils, OptionsUnit, Classes, Forms,
  Contnrs, WriteStreamUnit, WriteStrUnit, IntListUnit;

type
  THeadIndicies = record
    ElevationIndex: ANE_INT16;
  end;

  TStreamIndicies = record
    SegementIndex: ANE_INT16;
  end;

  TGwmStateTimeIndices = record
    NameIndex: ANE_INT16;
    StressPeriodIndex: ANE_INT16;
  end;

  TGWM_StateTimeIndicies = array of TGwmStateTimeIndices;

  TGwmStateTimeValues = record
    Name: string;
    StressPeriod: ANE_INT32;
  end;

  TStateStressPeriodArray = array of TGwmStateTimeValues;

  TGWM_StateWriter = class;

  TCustomGwmCell = class(TObject)
    StressPeriods: TStateStressPeriodArray;
    class function FixName(AName: string): string;
    function NumberOfCells: integer;
  end;

  TGWM_HeadStateCell = class(TCustomGwmCell)
    Layer: integer;
    Row: integer;
    Column: integer;
    StressPeriods: TStateStressPeriodArray;
    procedure Write(const Writer: TGWM_StateWriter);
  end;

  TGWM_StreamStateCell = class(TCustomGwmCell)
    Segment: integer;
    Reach: integer;
    procedure Write(const Writer: TGWM_StateWriter);
  end;

  TGWM_HeadStateCellList = class(TObjectList)
  private
//    NameCountList: TNameCountList;
    function GetItems(const Index: integer): TGWM_HeadStateCell;
    procedure SetItems(const Index: integer;
      const Value: TGWM_HeadStateCell);
  public
    constructor Create;
    Destructor Destroy; override;
    function Add(Item: TGWM_HeadStateCell): integer; overload;
    function Add(const Layer, Row,
      Column: integer; const StressPeriods: TStateStressPeriodArray):
      TGWM_HeadStateCell; overload;
    property Items[const Index: integer]: TGWM_HeadStateCell
      read GetItems write SetItems;
    procedure Write(const Writer: TGWM_StateWriter);
    function NumberOfCells: integer;
  end;

  TGWM_StreamStateCellList = class(TObjectList)
  private
//    NameCountList: TNameCountList;
    function GetItems(const Index: integer): TGWM_StreamStateCell;
    procedure SetItems(const Index: integer;
      const Value: TGWM_StreamStateCell);
  public
    constructor Create;
    Destructor Destroy; override;
    function Add(Item: TGWM_StreamStateCell): integer; overload;
    function Add(const Segment, Reach: integer;
      const StressPeriods: TStateStressPeriodArray):
      TGWM_StreamStateCell; overload;
    property Items[const Index: integer]: TGWM_StreamStateCell
      read GetItems write SetItems;
    procedure Write(const Writer: TGWM_StateWriter);
    function NumberOfCells: integer;
  end;

  TStorageParamKind = (spkAll, spkZone);

  T2D_ZoneArray = array of array of ANE_INT32;

  TStorageZone = class(TObject)
  private
    // indexed by Col, Row
    FZone: T2D_ZoneArray;
    FModflowLayers: TLayerArray;
    FZoneNumbers: TIntegerList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TStorageZoneList = class(TObject)
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TStorageZone;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TStorageZone): integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStorageZone read GetItem; default;
  end;

  TStorageVar = class(TObject)
  private
    FName: string;
    FStartStressPeriod: integer;
    FEndStressPeriod: Integer;
    FStorageParamKind: TStorageParamKind;
    FZoneValues: TIntegerList;
    procedure WriteSelf(const Writer: TGWM_StateWriter; StorageZoneList: TStorageZoneList);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TStorageVarList = class (TObject)
  private
    FList: TList;
    FStorageZoneList: TStorageZoneList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TStorageVar;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TStorageVar): integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStorageVar read GetItem; default;
    property StorageZoneList: TStorageZoneList read FStorageZoneList;
    procedure Write(const Writer: TGWM_StateWriter);
  end;

  TGWM_StateWriter = class(TListWriter)
  private
    HeadCellList: TGWM_HeadStateCellList;
    StreamCellList: TGWM_StreamStateCellList;
    FStorageVarList: TStorageVarList;
    FDiscretization: TDiscretizationWriter;
    FCurrentModelHandle: ANE_PTR;
    ProjectOptions: TProjectOptions;
    FSfrWriter: TStreamWriter;
    FStrWriter: TStrWriter;
    procedure AddIncorrectContourTypeMessage(const LayerName: string;
      const IncorrectContours: TStringList);
    Procedure EvaluateHeadStateContour(const UnitIndex,
      ContourIndex: integer; const HeadStateLayer: TLayerOptions;
      const LayerIndicies: THeadIndicies;
      const TimeIndicies: TGWM_StateTimeIndicies; const ModflowLayers: TLayerArray;
      const CellList: TGWM_HeadStateCellList; const ContourTypeErrors: TStringList);
    Procedure EvaluateStreamStateContour(const UnitIndex,
      ContourIndex: integer; const StreamLayer: TLayerOptions;
      const LayerIndicies: TStreamIndicies;
      const TimeIndicies: TGWM_StateTimeIndicies; const ModflowLayers: TLayerArray;
      const CellList: TGWM_StreamStateCellList; const ContourTypeErrors: TStringList);
    procedure GetTimeIndicies(const Layer: TLayerOptions;
      var TimeIndicies: TGWM_StateTimeIndicies);
    procedure GetHeadStateIndicies(
      const HeadStateLayer: TLayerOptions;
      var HeadIndicies: THeadIndicies;
      var StressPeriodIndicies:  TGWM_StateTimeIndicies);
    procedure GetStreamStateIndicies(
      const StreamStateLayer: TLayerOptions;
      var StreamIndicies: TStreamIndicies;
      var StressPeriodIndicies:  TGWM_StateTimeIndicies);
    procedure EvaluateHeadVariableUnit(UnitIndex: integer);
    procedure EvaluateStreamVariableUnit(UnitIndex: integer);
    procedure EvaluateHeadVariables;
    procedure EvaluateStreamVariables;
    procedure EvaluateStorageVariables;
    procedure Evaluate;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      const Root: string; Discretization: TDiscretizationWriter;
      SfrWriter: TStreamWriter; StrWriter: TStrWriter);
  end;


implementation

uses
  Variables, ProgressUnit, GetCellUnit, RbwDataGrid4, ModflowUnit,
  WriteNameFileUnit;

{ TGWM_StateWriter }

procedure TGWM_StateWriter.AddIncorrectContourTypeMessage(
  const LayerName: string; const IncorrectContours: TStringList);
var
  ErrorMessage: string;
begin
  if IncorrectContours.Count > 0 then
  begin
    ErrorMessage := 'One or more contours on ' + LayerName
      + ' is of the wrong type.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorMessage);
    ErrorMessages.Add('The following contours are of the incorrect type.');
    ErrorMessages.AddStrings(IncorrectContours);
  end;
end;

constructor TGWM_StateWriter.Create;
begin
  inherited;
  ProjectOptions := TProjectOptions.Create;
  HeadCellList:= TGWM_HeadStateCellList.Create;
  StreamCellList:= TGWM_StreamStateCellList.Create;
  FStorageVarList:= TStorageVarList.Create;
end;

destructor TGWM_StateWriter.Destroy;
begin
  FStorageVarList.Free;
  StreamCellList.Free;
  HeadCellList.Free;
  ProjectOptions.Free;
  inherited;
end;

procedure TGWM_StateWriter.Evaluate;
begin
  EvaluateHeadVariables;
  EvaluateStreamVariables;
  EvaluateStorageVariables;
end;


procedure TGWM_StateWriter.EvaluateHeadStateContour(const UnitIndex,
  ContourIndex: integer; const HeadStateLayer: TLayerOptions;
  const LayerIndicies: THeadIndicies;
  const TimeIndicies: TGWM_StateTimeIndicies; const ModflowLayers: TLayerArray;
  const CellList: TGWM_HeadStateCellList; const ContourTypeErrors: TStringList);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  ContourName: string;
  CellIndex: integer;
  Column, Row, Layer: integer;
  StressPeriodArray: TStateStressPeriodArray;
  TimeCount: integer;
  TimeIndex: integer;
  Elevation: double;
  TopElevation: ANE_DOUBLE;
  BottomElevation: ANE_DOUBLE;
  LayIndex: Integer;
begin
  TimeCount := StrToInt(frmModflow.rdeGwmStateTimeCount.Output);
  SetLength(StressPeriodArray, TimeCount);
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (FCurrentModelHandle, HeadStateLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(FCurrentModelHandle);
    ContourName := Contour.GetStringParameter(FCurrentModelHandle,
      TimeIndicies[0].NameIndex);
    if (ContourType <> ctPoint) or (CellCount = 0) then
    begin
      ContourTypeErrors.Add(ContourName);
      Exit;
    end;
    if (CellCount = 0) then
    begin
      Exit;
    end;

    Elevation := Contour.GetFloatParameter(FCurrentModelHandle,
      LayerIndicies.ElevationIndex);

    for TimeIndex := 0 to TimeCount-1 do
    begin
      StressPeriodArray[TimeIndex].Name := Contour.GetStringParameter(
        FCurrentModelHandle, TimeIndicies[TimeIndex].NameIndex);
      StressPeriodArray[TimeIndex].StressPeriod := Contour.GetIntegerParameter(
        FCurrentModelHandle, TimeIndicies[TimeIndex].StressPeriodIndex);
    end;

    for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
    begin
      if not ContinueExport then
      begin
        break;
      end;
      Application.ProcessMessages;
      Row    := GGetCellRow(ContourIndex, CellIndex);
      Column := GGetCellColumn(ContourIndex, CellIndex);


      if Length(ModflowLayers) > 1 then
      begin
        TopElevation := FDiscretization.Elevations[Column-1, Row-1, UnitIndex-1];
        BottomElevation := FDiscretization.Elevations[Column-1, Row-1, UnitIndex];
        if Elevation >= TopElevation then
        begin
          Layer := ModflowLayers[0];
        end
        else if Elevation <= BottomElevation then
        begin
          Layer := ModflowLayers[Length(ModflowLayers)-1];
        end
        else if TopElevation = BottomElevation then
        begin
          Layer := ModflowLayers[Length(ModflowLayers) div 2];
        end
        else
        begin
          LayIndex :=
            Trunc((Elevation - BottomElevation)
            /(TopElevation - BottomElevation)
            *Length(ModflowLayers));
          Layer := ModflowLayers[LayIndex];
        end;
      end
      else
      begin
        Layer := ModflowLayers[0];
      end;

      CellList.Add(Layer, Row, Column, StressPeriodArray);
    end;

  finally
    Contour.Free;
  end;
end;

procedure TGWM_StateWriter.EvaluateHeadVariables;
var
  UnitIndex: Integer;
begin
  if frmModflow.cbGwmHeadVariables.Checked then
  begin
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        EvaluateHeadVariableUnit(UnitIndex);
      end;
    end;
  end;
end;

procedure TGWM_StateWriter.EvaluateHeadVariableUnit(UnitIndex: integer);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  HeadStateLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  HeadIndicies: THeadIndicies;
  TimeIndicies:  TGWM_StateTimeIndicies;
  ModflowLayers: TLayerArray;
  ContourTypeErrors: TStringList;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFGwmHeadStateLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(FCurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(FCurrentModelHandle, LayerName);
  ContourTypeErrors:= TStringList.Create;
  HeadStateLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := HeadStateLayer.NumObjects(FCurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetHeadStateIndicies(HeadStateLayer, HeadIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateHeadStateContour(UnitIndex, ContourIndex,
          HeadStateLayer, HeadIndicies, TimeIndicies,
          ModflowLayers, HeadCellList, ContourTypeErrors);
      end;
    end;
    AddIncorrectContourTypeMessage(LayerName, ContourTypeErrors);
  finally
    ContourTypeErrors.Free;
    HeadStateLayer.Free(FCurrentModelHandle);
  end;
end;

procedure TGWM_StateWriter.EvaluateStorageVariables;
var
  NSVAR: Integer;
  MyVar: TStorageVar;
  Grid: TRbwDataGrid4;
  ZonesUsed: Boolean;
  UnitIndex: Integer;
  ModflowLayers: TLayerArray;
  ZoneValues: T2D_ZoneArray;
  ZoneParamName: string;
  GridLayer: TLayerOptions;
  VarIndex: Integer;
  ZoneParamIndex: ANE_INT32;
  RowIndex: Integer;
  ColIndex: Integer;
  BlockIndex: Integer;
  ABlock: TObjectOptions;
  StorageZone: TStorageZone;
  ZoneValue: Integer;
begin
  if frmModflow.IsAnyTransient then
  begin
    NSVAR := StrToInt(frmModflow.rdeGwmStorageStateVarCount.Output);
    Grid := frmModflow.rdgGwmStorageVariables;
    ZonesUsed := False;
    for VarIndex := 1 to NSVAR do
    begin
      MyVar := TStorageVar.Create();
      try
        MyVar.FName := Grid.Cells[Ord(gwscName), VarIndex];
        Assert(MyVar.FName <> '');
        MyVar.FStartStressPeriod :=
          StrToInt(Grid.Cells[Ord(gscStartSP), VarIndex]);
        MyVar.FEndStressPeriod := StrToInt(Grid.Cells[Ord(gscEndsSp), VarIndex]);
        MyVar.FStorageParamKind :=
          TStorageParamKind (Grid.ItemIndex[Ord(gscZoneChoice), VarIndex]);
          for ColIndex := Ord(gscZoneNumber) to Grid.ColCount - 1 do
          begin
            if TryStrToInt(Grid.Cells[Ord(gscZoneNumber), VarIndex], ZoneValue) then
            begin
              MyVar.FZoneValues.AddUnique(ZoneValue);
            end;
          end;
//        MyVar.FZoneValue := StrToInt(Grid.Cells[Ord(gscZoneNumber), VarIndex]);
        FStorageVarList.Add(MyVar);
        if MyVar.FStorageParamKind = spkZone then
        begin
          ZonesUsed := True;
        end;
      except
        MyVar.Free;
      end;
    end;
    if ZonesUsed then
    begin
      GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
      try
        SetLength(ZoneValues, FDiscretization.NCOL, FDiscretization.NROW);
        for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
        begin
          if frmModflow.Simulated(UnitIndex) then
          begin
            ZoneParamName := ModflowTypes.
              GetMF_GridGwmZoneParamType.ANE_ParamName + IntToStr(UnitIndex);
            ZoneParamIndex := GridLayer.GetParameterIndex(FCurrentModelHandle, ZoneParamName);

            StorageZone := TStorageZone.Create;

            for RowIndex := 0 to FDiscretization.NROW -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              for ColIndex := 0 to FDiscretization.NCOL -1 do
              begin
                BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
                ABlock := TBlockObjectOptions.Create(FCurrentModelHandle,
                  FDiscretization.GridLayerHandle, BlockIndex);
                try
                  ZoneValues[ColIndex, RowIndex] :=
                    ABlock.GetIntegerParameter(FCurrentModelHandle, ZoneParamIndex);
                  StorageZone.FZoneNumbers.AddUnique(ZoneValues[ColIndex, RowIndex]);
                finally
                  ABlock.Free;
                end;
              end;
            end;

            StorageZone.FZone := ZoneValues;
            SetLength(StorageZone.FZone, Length(StorageZone.FZone), Length(StorageZone.FZone[0]));

            GetLayers(UnitIndex, ModflowLayers);
            StorageZone.FModflowLayers := Copy(ModflowLayers);

            FStorageVarList.StorageZoneList.Add(StorageZone);
          end;
        end;
      finally
        GridLayer.Free(FCurrentModelHandle);
      end;
    end;
  end;
end;

procedure TGWM_StateWriter.EvaluateStreamStateContour(const UnitIndex,
  ContourIndex: integer; const StreamLayer: TLayerOptions;
  const LayerIndicies: TStreamIndicies;
  const TimeIndicies: TGWM_StateTimeIndicies;
  const ModflowLayers: TLayerArray;
  const CellList: TGWM_StreamStateCellList;
  const ContourTypeErrors: TStringList);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  ContourName: string;
  CellIndex: integer;
  Column, Row, Layer: integer;
  StressPeriodArray: TStateStressPeriodArray;
  TimeCount: integer;
  TimeIndex: integer;
  SegmentNumber: integer;
  TopElevation: ANE_DOUBLE;
  BottomElevation: ANE_DOUBLE;
  LayIndex: Integer;
  FirstLayer: Integer;
  LastLayer: Integer;
  SegmentIndex: Integer;
  AnSfrSegment: TSegment;
  SelectedSfrSegment: TSegment;
  ReachIndex: Integer;
  SfrReach: TStreamReachObject;
  SegNumber: Integer;
  ReachNum: Integer;
  AnStrSegment: TStrSegment;
  SelectedStrSegment: TStrSegment;
  StrReach: TStrReachObject;
begin
  TimeCount := StrToInt(frmModflow.rdeGwmStateTimeCount.Output);
  SetLength(StressPeriodArray, TimeCount);
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (FCurrentModelHandle, StreamLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(FCurrentModelHandle);
    ContourName := Contour.GetStringParameter(FCurrentModelHandle,
      TimeIndicies[0].NameIndex);
    if (ContourType <> ctPoint) or (CellCount = 0) then
    begin
      ContourTypeErrors.Add(ContourName);
      Exit;
    end;
    if (CellCount = 0) then
    begin
      Exit;
    end;

    SegmentNumber := Contour.GetIntegerParameter(FCurrentModelHandle,
      LayerIndicies.SegementIndex);

    FirstLayer := ModflowLayers[0];
    LastLayer := ModflowLayers[Length(ModflowLayers)-1];

    for TimeIndex := 0 to TimeCount-1 do
    begin
      StressPeriodArray[TimeIndex].Name := Contour.GetStringParameter(
        FCurrentModelHandle, TimeIndicies[TimeIndex].NameIndex);
      StressPeriodArray[TimeIndex].StressPeriod := Contour.GetIntegerParameter(
        FCurrentModelHandle, TimeIndicies[TimeIndex].StressPeriodIndex);
    end;

    Assert((FSfrWriter <> nil) or (FStrWriter <> nil));

    SelectedSfrSegment := nil;
    if FSfrWriter <> nil then
    begin
      for SegmentIndex := 0 to FSfrWriter.SegmentCount - 1 do
      begin
        AnSfrSegment := FSfrWriter.Segments[SegmentIndex];
        if AnSfrSegment.UserAssignedNumber = SegmentNumber then
        begin
          SelectedSfrSegment := AnSfrSegment;
          break;
        end;
      end;
    end;

    SelectedStrSegment := nil;
    if FStrWriter <> nil then
    begin
      for SegmentIndex := 0 to FStrWriter.SegmentCount - 1 do
      begin
        AnStrSegment := FStrWriter.Segments[SegmentIndex];
        if AnStrSegment.UserAssignedNumber = SegmentNumber then
        begin
          SelectedStrSegment := AnStrSegment;
          break;
        end;
      end;
    end;

    for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
    begin
      if not ContinueExport then
      begin
        break;
      end;
      SegNumber := -1;
      ReachNum := -1;
      Application.ProcessMessages;
      Row    := GGetCellRow(ContourIndex, CellIndex);
      Column := GGetCellColumn(ContourIndex, CellIndex);

      if SelectedSfrSegment <> nil then
      begin
        for ReachIndex := 0 to SelectedSfrSegment.ReachCount - 1 do
        begin
          SfrReach := SelectedSfrSegment.Reaches[ReachIndex];
          if (SfrReach.Reach.Row = Row)
            and (SfrReach.Reach.Column = Column)
            and (SfrReach.Reach.Layer >= FirstLayer)
            and (SfrReach.Reach.Layer <= LastLayer) then
          begin
            SegNumber := SelectedSfrSegment.Number;
            ReachNum := ReachIndex+1;
            break;
          end;
        end;
      end;

      if SegNumber < 0 then
      begin
        if SelectedStrSegment <> nil then
        begin
          for ReachIndex := 0 to SelectedStrSegment.ReachCount - 1 do
          begin
            StrReach := SelectedStrSegment.Reaches[ReachIndex];
            if (StrReach.Row = Row)
              and (StrReach.Col = Column)
              and (StrReach.Layer >= FirstLayer)
              and (StrReach.Layer <= LastLayer) then
            begin
              SegNumber := SelectedStrSegment.Number;
              ReachNum := ReachIndex+1;
              break;
            end;
          end;
        end;
      end;

      if SegNumber > 0 then
      begin
        CellList.Add(SegNumber, ReachNum, StressPeriodArray);
      end;
    end;

  finally
    Contour.Free;
  end;
end;

procedure TGWM_StateWriter.EvaluateStreamVariables;
var
  UnitIndex: Integer;
begin
  if frmModflow.cbGwmStreamVariables.Checked then
  begin
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        EvaluateStreamVariableUnit(UnitIndex);
      end;
    end;
  end;
end;

procedure TGWM_StateWriter.EvaluateStreamVariableUnit(UnitIndex: integer);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  ContourTypeErrors: TStringList;
  StreamStateLayer: TLayerOptions;
  ContourCount: ANE_INT32;
  StreamIndicies: TStreamIndicies;
  TimeIndicies: TGWM_StateTimeIndicies;
  ContourIndex: Integer;
  ModflowLayers: TLayerArray;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFGwmStreamStateLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(FCurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(FCurrentModelHandle, LayerName);
  ContourTypeErrors:= TStringList.Create;
  StreamStateLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := StreamStateLayer.NumObjects(FCurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetStreamStateIndicies(StreamStateLayer, StreamIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateStreamStateContour(UnitIndex, ContourIndex,
          StreamStateLayer, StreamIndicies, TimeIndicies, ModflowLayers,
          StreamCellList, ContourTypeErrors);
      end;
    end;
    AddIncorrectContourTypeMessage(LayerName, ContourTypeErrors);
  finally
    ContourTypeErrors.Free;
    StreamStateLayer.Free(FCurrentModelHandle);
  end;
end;

procedure TGWM_StateWriter.GetHeadStateIndicies(
  const HeadStateLayer: TLayerOptions; var HeadIndicies: THeadIndicies;
  var StressPeriodIndicies: TGWM_StateTimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMF_GwmElevationParamType.ANE_ParamName;
  HeadIndicies.ElevationIndex :=
    HeadStateLayer.GetParameterIndex(FCurrentModelHandle, Name);
  Assert(HeadIndicies.ElevationIndex >= 0);

  GetTimeIndicies(HeadStateLayer, StressPeriodIndicies);
end;

procedure TGWM_StateWriter.GetStreamStateIndicies(
  const StreamStateLayer: TLayerOptions; var StreamIndicies: TStreamIndicies;
  var StressPeriodIndicies: TGWM_StateTimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMF_GwmSegmentParamType.ANE_ParamName;
  StreamIndicies.SegementIndex :=
    StreamStateLayer.GetParameterIndex(FCurrentModelHandle, Name);
  Assert(StreamIndicies.SegementIndex >= 0);

  GetTimeIndicies(StreamStateLayer, StressPeriodIndicies);
end;

procedure TGWM_StateWriter.GetTimeIndicies(const Layer: TLayerOptions;
  var TimeIndicies: TGWM_StateTimeIndicies);
var
  Name, SP_Root, NameRoot: string;
  TimeIndex:  integer;
  TimeCount:  integer;
begin
  SP_Root := ModflowTypes.GetMF_GwmStressPeriodParamType.ANE_ParamName;
  NameRoot := ModflowTypes.GetMF_GwmNameParamType.ANE_ParamName;
  TimeCount := StrToInt(frmModflow.rdeGwmStateTimeCount.Output);
  SetLength(TimeIndicies, TimeCount);
  for TimeIndex := 1 to TimeCount do
  begin
    Name := SP_Root + IntToStr(TimeIndex);
    TimeIndicies[TimeIndex - 1].StressPeriodIndex := Layer.GetParameterIndex(
      FCurrentModelHandle, Name);
    Name := NameRoot + IntToStr(TimeIndex);
    TimeIndicies[TimeIndex - 1].NameIndex := Layer.GetParameterIndex(
      FCurrentModelHandle, Name);
  end;
end;

procedure TGWM_StateWriter.WriteDataSet1;
begin
  WriteLn(FFile, '1 #IPRN');
end;

procedure TGWM_StateWriter.WriteDataSet2;
var
  NHVAR: Integer;
  NRVAR: Integer;
  NSVAR: Integer;
begin
  NHVAR := HeadCellList.Count;
  NRVAR := StreamCellList.Count;
  NSVAR := FStorageVarList.Count;
  WriteLn(FFile, NHVAR, ' ', NRVAR, ' ', NSVAR, ' #NHVAR, NRVAR, NSVAR');
end;

procedure TGWM_StateWriter.WriteDataSet3;
begin
  HeadCellList.Write(self);
end;

procedure TGWM_StateWriter.WriteDataSet4;
begin
  StreamCellList.Write(self);
end;

procedure TGWM_StateWriter.WriteDataSet5;
begin
  FStorageVarList.Write(self);
end;

procedure TGWM_StateWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  const Root: string; Discretization: TDiscretizationWriter;
  SfrWriter: TStreamWriter; StrWriter: TStrWriter);
var
  FileName: string;
begin
  FDiscretization := Discretization;
  FCurrentModelHandle := CurrentModelHandle;
  FSfrWriter := SfrWriter;
  FStrWriter := StrWriter;

  Evaluate;

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'GWM State File';

    FileName := GetCurrentDir + '\' + Root + rsSTAVAR;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);

      WriteDataSet1;
      WriteDataSet2;
      WriteDataSet3;
      WriteDataSet4;
      WriteDataSet5;
    finally
      CloseFile(FFile);
    end;
  end;

end;

{ TGWM_HeadStateCellList }

function TGWM_HeadStateCellList.Add(const Layer, Row,
  Column: integer;
  const StressPeriods: TStateStressPeriodArray): TGWM_HeadStateCell;
begin
  result:= TGWM_HeadStateCell.Create;
  result.Layer := Layer;
  result.Row := Row;
  result.Column := Column;
  result.StressPeriods := Copy(StressPeriods);

  Add(result);
end;

function TGWM_HeadStateCellList.Add(Item: TGWM_HeadStateCell): integer;
begin
  result := inherited Add(Item);
end;

constructor TGWM_HeadStateCellList.Create;
begin
  inherited;
//  NameCountList:= TNameCountList.Create;
end;

destructor TGWM_HeadStateCellList.Destroy;
begin
//  NameCountList.Free;
  inherited;
end;

function TGWM_HeadStateCellList.GetItems(
  const Index: integer): TGWM_HeadStateCell;
begin
  result := inherited Items[Index] as TGWM_HeadStateCell;
end;

function TGWM_HeadStateCellList.NumberOfCells: integer;
var
  Index: integer;
  Item: TGWM_HeadStateCell;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    result := result + Item.NumberOfCells;
  end;
end;

procedure TGWM_HeadStateCellList.SetItems(const Index: integer;
  const Value: TGWM_HeadStateCell);
begin
  inherited Items[Index] := Value;
end;

procedure TGWM_HeadStateCellList.Write(const Writer: TGWM_StateWriter);
var
  Index: integer;
  Item: TGWM_HeadStateCell;
begin
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    Item.Write(Writer);
  end;
end;

{ TGWM_HeadStateCell }

procedure TGWM_HeadStateCell.Write(const Writer: TGWM_StateWriter);
var
  Index: Integer;
  ExportedName: string;
begin
  for Index := 0 to Length(StressPeriods) -1 do
  begin
    ExportedName := FixName(StressPeriods[Index].Name);
    WriteLn(Writer.FFile, ExportedName, ' ', Layer, ' ', Row, ' ', Column, ' ',
       StressPeriods[Index].StressPeriod, ' # SVNAME, LAY, ROW, COL, SVSP');
  end;
end;

{ TGWM_StreamStateCell }

procedure TGWM_StreamStateCell.Write(const Writer: TGWM_StateWriter);
var
  Index: Integer;
  ExportedName: string;
begin
  for Index := 0 to Length(StressPeriods) -1 do
  begin
    ExportedName := FixName(StressPeriods[Index].Name);
    WriteLn(Writer.FFile, ExportedName, ' ', Segment, ' ', Reach, ' ', 
       StressPeriods[Index].StressPeriod, ' # SVNAME, SEG, RECAHC, SVSP');
  end;
end;

{ TCustomGwmCell }

class function TCustomGwmCell.FixName(AName: string): string;
begin
  result := AName;
  if Length(result) > 10 then
  begin
    SetLength(result, 10);
  end;
  result := StringReplace(result, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
end;

function TCustomGwmCell.NumberOfCells: integer;
begin
  result := Length(StressPeriods);
end;

{ TGWM_StreamStateCellList }

function TGWM_StreamStateCellList.Add(const Segment, Reach: integer;
  const StressPeriods: TStateStressPeriodArray): TGWM_StreamStateCell;
begin
  result:= TGWM_StreamStateCell.Create;
  result.Segment := Segment;
  result.Reach := Reach;
  result.StressPeriods := Copy(StressPeriods);

  Add(result);

end;

function TGWM_StreamStateCellList.Add(Item: TGWM_StreamStateCell): integer;
begin
  result := inherited Add(Item);
end;

constructor TGWM_StreamStateCellList.Create;
begin
  inherited;
//  NameCountList:= TNameCountList.Create;
end;

destructor TGWM_StreamStateCellList.Destroy;
begin
//  NameCountList.Free;
  inherited;
end;

function TGWM_StreamStateCellList.GetItems(
  const Index: integer): TGWM_StreamStateCell;
begin
  result := inherited Items[Index] as TGWM_StreamStateCell;
end;

function TGWM_StreamStateCellList.NumberOfCells: integer;
var
  Index: integer;
  Item: TGWM_StreamStateCell;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    result := result + Item.NumberOfCells;
  end;
end;

procedure TGWM_StreamStateCellList.SetItems(const Index: integer;
  const Value: TGWM_StreamStateCell);
begin
  inherited Items[Index] := Value;
end;

procedure TGWM_StreamStateCellList.Write(const Writer: TGWM_StateWriter);
var
  Index: integer;
  Item: TGWM_StreamStateCell;
begin
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    Item.Write(Writer);
  end;
end;

{ TStorageVarList }

function TStorageVarList.Add(Item: TStorageVar): integer;
begin
  result := FList.Add(Item);
end;

constructor TStorageVarList.Create;
begin
  FList := TObjectList.Create;
  FStorageZoneList:= TStorageZoneList.Create;
end;

destructor TStorageVarList.Destroy;
begin
  FStorageZoneList.Free;
  FList.Free;
  inherited;
end;

function TStorageVarList.GetCount: Integer;
begin
  result := FList.Count;
end;

function TStorageVarList.GetItem(Index: Integer): TStorageVar;
begin
  result := FList[Index];
end;

procedure TStorageVarList.Write(const Writer: TGWM_StateWriter);
var
  Index: Integer;
begin
  for Index := 0 to Count - 1 do
  begin
    Items[Index].WriteSelf(Writer, StorageZoneList);
  end;
end;

{ TStorageZoneList }

function TStorageZoneList.Add(Item: TStorageZone): integer;
begin
  result := FList.Add(Item)
end;

constructor TStorageZoneList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TStorageZoneList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TStorageZoneList.GetCount: Integer;
begin
  result := FList.Count;
end;

function TStorageZoneList.GetItem(Index: Integer): TStorageZone;
begin
  result := FList[index];
end;

{ TStorageZone }

constructor TStorageZone.Create;
begin
  FZoneNumbers:= TIntegerList.Create;
  FZoneNumbers.Sorted := True;
end;

destructor TStorageZone.Destroy;
begin
  FZoneNumbers.Free;
  inherited;
end;

{ TStorageVar }

constructor TStorageVar.Create;
begin
  FZoneValues := TIntegerList.Create;
  FZoneValues.Sorted := True;
end;

destructor TStorageVar.Destroy;
begin
  FZoneValues.Free;
  inherited;
end;

procedure TStorageVar.WriteSelf(const Writer: TGWM_StateWriter;
  StorageZoneList: TStorageZoneList);
var
  CZONE: string;
  ZoneListIndex: Integer;
  Zone: TStorageZone;
  ZoneArray : T2D_ZoneArray;
  Dis: TDiscretizationWriter;
  ColIndex: Integer;
  RowIndex: Integer;
  LayerIndex: Integer;
  NSVZL: Integer;
  ZoneIndex: Integer;begin
  // 5a
  case FStorageParamKind of
    spkAll: CZONE := 'ALL';
    spkZone: CZONE := 'Zone';
    else Assert(False);
  end;
  Writeln(Writer.FFile, FName, ' ', FStartStressPeriod, ' ',FEndStressPeriod, ' ',
    CZONE, ' # SVNAME, SPSTRT, SPEND, CZONE ');
  if FStorageParamKind = spkZone then
  begin
    // 5b
    NSVZL := 0;
    for ZoneListIndex := 0 to StorageZoneList.Count - 1 do
    begin
      Zone := StorageZoneList[ZoneListIndex];
      for ZoneIndex := 0 to FZoneValues.Count - 1 do
      begin
        if Zone.FZoneNumbers.IndexOf(FZoneValues[ZoneIndex]) >= 0 then
        begin
          Inc(NSVZL, Length(Zone.FModflowLayers));
          break;
        end;
      end;
    end;
    WriteLn(Writer.FFile, NSVZL, ' # NSVZL');

    Dis := Writer.FDiscretization;
    SetLength(ZoneArray, Dis.NCOL, Dis.NROW);
    // 5c, 5d
    for ZoneListIndex := 0 to StorageZoneList.Count - 1 do
    begin
      Zone := StorageZoneList[ZoneListIndex];
      for ZoneIndex := 0 to FZoneValues.Count - 1 do
      begin
        if Zone.FZoneNumbers.IndexOf(FZoneValues[ZoneIndex]) >= 0 then
//      if Zone.FZoneNumbers.IndexOf(FZoneValue) >= 0 then
        begin
          for RowIndex := 0 to Dis.NROW - 1 do
          begin
            for ColIndex := 0 to Dis.NCOL - 1 do
            begin
              if FZoneValues.IndexOf(Zone.FZone[ColIndex,RowIndex]) >= 0 then
              begin
                ZoneArray[ColIndex,RowIndex] := 1;
              end
              else
              begin
                ZoneArray[ColIndex,RowIndex] := 0;
              end;
            end;
          end;

          for LayerIndex := 0 to Length(Zone.FModflowLayers) - 1 do
          begin
            // 5c
            WriteLn(Writer.FFile, Zone.FModflowLayers[LayerIndex], ' # LNUM');
            // 5d
            Writer.WriteU2DINTHeader;
            for RowIndex := 0 to Dis.NROW -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              for ColIndex := 0 to Dis.NCOL -1 do
              begin
                Application.ProcessMessages;
                if not ContinueExport then break;

                Write(Writer.FFile, ZoneArray[ColIndex, RowIndex], ' ');

                frmProgress.pbActivity.StepIt;
              end;
              WriteLn(Writer.FFile);
            end;
          end;
        end;
        break;
      end;

    end;


  end;
end;

end.
