unit WriteGWM_StreamConstraints;

interface

uses SysUtils, Classes, contnrs, Forms, AnePIE, OptionsUnit,
  WriteGWM_DecisionVariables, WriteModflowDiscretization, WriteStrUnit,
  WriteGWM_HeadConstraints, WriteStreamUnit;

type
  TStreamConstraintIndicies = record
    VariableNameIndex: ANE_INT16;
    ConstraintTypeIndex: ANE_INT16;
    ConstraintValueIndex: ANE_INT16;
  end;

  TStreamLocation = class(TObject)
    Segment: integer;
    Reach: integer;
  end;

  TStreamLocations = class(TObject)
  private
    Locations: array of array of array of TList;
    function GetItems(const Col, Row, Layer: integer): TList;
    procedure SetItems(const Col, Row, Layer: integer; const Value: TList);
  public
    Constructor Create(const NCol, NRow, NLay: integer);
    Destructor Destroy; override;
    property Items[const Col, Row, Layer: integer]: TList read GetItems write SetItems; default;
    procedure Add(const Col, Row, Layer, Segment, Reach: integer);
  end;

  TStreamConstrainstWriter = class;

  TStreamConstraintCell = Class(TObject)
    Name: string;
    Segment: integer;
    Reach: integer;
    ConstraintType: string;
    ConstraintValue: double;
    StressPeriod: integer;
    procedure Write(const Writer: TStreamConstrainstWriter;
      const Names: TNameCountList; const TypeErrors: TStringList);
  end;

  TStreamConstraintCellList = class(TStringList)
  private
    Names: TNameCountList;
    function GetItems(const Index: integer): TStreamConstraintCell;
    procedure SetItems(const Index: integer;
      const Value: TStreamConstraintCell);
  public
    constructor Create;
    Destructor Destroy; override;
    function Add(Item: TStreamConstraintCell): integer; reintroduce; overload;
    procedure Add(const Name: string; const Segment, Reach: integer;
      const ConstraintType: string; const ConstraintValue: double;
      const StressPeriods: TStressPeriodArray); reintroduce; overload;
    property Items[const Index: integer]: TStreamConstraintCell
      read GetItems write SetItems;
    procedure Write(const Writer: TStreamConstrainstWriter;
      const TypeErrors: TStringList);
  end;

  TStreamConstrainstWriter = class(TCustomGWM_Writer)
  private
    StrWriter: TStrWriter;
    SfrWriter: TStreamWriter;
    StreamConstraintCellList: TStreamConstraintCellList;
    DepletionConstraintCellList: TStreamConstraintCellList;
    StreamLocations: TStreamLocations;
    procedure Evaluate;
    procedure EvaluateStreamConstraints;
    procedure EvaluateDeplectionConstraints;
    procedure EvaluateStreamConstraintsUnit(const UnitIndex: integer);
    procedure EvaluateDeplectionConstraintsUnit(const UnitIndex: integer);
    procedure StoreStreamLocations;
    procedure GetStreamConstraintIndicies(
      const StreamConstraintLayer: TLayerOptions;
      var StreamConstraintIndicies: TStreamConstraintIndicies;
      var TimeIndicies:  TGWM_TimeIndicies);
    procedure GetDepletionConstraintIndicies(
      const DepletionConstraintLayer: TLayerOptions;
      var DepletionConstraintIndicies: TStreamConstraintIndicies;
      var TimeIndicies:  TGWM_TimeIndicies);
    procedure EvaluateStreamConstraintContour(const UnitIndex,
      ContourIndex: integer; const StreamConstraintsLayer: TLayerOptions;
      const LayerIndicies: TStreamConstraintIndicies;
      const TimeIndicies: TGWM_TimeIndicies;
      const ModflowLayers: TLayerArray;
      const CellList: TStreamConstraintCellList);
      procedure WriteDataSet1;
      procedure WriteDataSet2;
      procedure WriteDataSet3;
      procedure WriteDataSet4;
  public
    constructor Create;
    Destructor Destroy; override;
    Procedure WriteFile(const CurrentModelHandle: ANE_PTR; const Root: string;
      Discretization: TDiscretizationWriter; StreamWriter: TStrWriter;
      SfrWriter: TStreamWriter);

  end;

implementation

uses GetCellUnit, PointInsideContourUnit, Variables, ProgressUnit,
  WriteNameFileUnit;

{ TStreamConstrainstWriter }

constructor TStreamConstrainstWriter.Create;
begin
  inherited;
  StreamConstraintCellList:= TStreamConstraintCellList.Create;
  DepletionConstraintCellList:= TStreamConstraintCellList.Create;
end;

destructor TStreamConstrainstWriter.Destroy;
begin
  StreamConstraintCellList.Free;
  DepletionConstraintCellList.Free;
  inherited;
end;

procedure TStreamConstrainstWriter.Evaluate;
begin
  StoreStreamLocations;
  EvaluateStreamConstraints;
  EvaluateDeplectionConstraints;
end;

procedure TStreamConstrainstWriter.EvaluateDeplectionConstraints;
var
  UnitIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      EvaluateDeplectionConstraintsUnit(UnitIndex);
    end;
  end;
end;

procedure TStreamConstrainstWriter.EvaluateDeplectionConstraintsUnit(
  const UnitIndex: integer);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  DepletionConstraintLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  DepletionConstraintIndicies: TStreamConstraintIndicies;
  TimeIndicies:  TGWM_TimeIndicies;
  ModflowLayers: TLayerArray;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFStreamDepletionConstraintLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  DepletionConstraintLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := DepletionConstraintLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetDepletionConstraintIndicies(DepletionConstraintLayer, DepletionConstraintIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateStreamConstraintContour(UnitIndex, ContourIndex,
          DepletionConstraintLayer, DepletionConstraintIndicies, TimeIndicies,
          ModflowLayers, DepletionConstraintCellList);
      end;
    end;
  finally
    DepletionConstraintLayer.Free(CurrentModelHandle);
  end;
end;

procedure TStreamConstrainstWriter.EvaluateStreamConstraints;
var
  UnitIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      EvaluateStreamConstraintsUnit(UnitIndex);
    end;
  end;
end;

procedure TStreamConstrainstWriter.EvaluateStreamConstraintsUnit(
  const UnitIndex: integer);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  StreamConstraintLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  StreamConstraintIndicies: TStreamConstraintIndicies;
  TimeIndicies:  TGWM_TimeIndicies;
  ModflowLayers: TLayerArray;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFStreamConstraintLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  StreamConstraintLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := StreamConstraintLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetStreamConstraintIndicies(StreamConstraintLayer, StreamConstraintIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateStreamConstraintContour(UnitIndex, ContourIndex,
          StreamConstraintLayer, StreamConstraintIndicies, TimeIndicies,
          ModflowLayers, StreamConstraintCellList);
      end;
    end;
  finally
    StreamConstraintLayer.Free(CurrentModelHandle);
  end;
end;

procedure TStreamConstrainstWriter.GetStreamConstraintIndicies(
  const StreamConstraintLayer: TLayerOptions;
  var StreamConstraintIndicies: TStreamConstraintIndicies;
  var TimeIndicies: TGWM_TimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFStreamFlowNameParamType.ANE_ParamName;
  StreamConstraintIndicies.VariableNameIndex :=
    StreamConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(StreamConstraintIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFHeadConstraintTypeParamType.ANE_ParamName;
  StreamConstraintIndicies.ConstraintTypeIndex :=
    StreamConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(StreamConstraintIndicies.ConstraintTypeIndex >= 0);

  Name := ModflowTypes.GetMFStreamflowValueParamType.ANE_ParamName;
  StreamConstraintIndicies.ConstraintValueIndex :=
    StreamConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(StreamConstraintIndicies.ConstraintValueIndex >= 0);

  GetTimeIndicies(StreamConstraintLayer, TimeIndicies);
end;

procedure TStreamConstrainstWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; const Root: string;
  Discretization: TDiscretizationWriter; StreamWriter: TStrWriter;
  SfrWriter: TStreamWriter);
var
  FileName: string;
begin
  self.Discretization     := Discretization;
  self.CurrentModelHandle := CurrentModelHandle;
  self.StrWriter := StreamWriter;
  self.SfrWriter := SfrWriter;

  StreamLocations:= TStreamLocations.Create(Discretization.NCOL,
    Discretization.NROW, Discretization.NLAY);
  try
    frmProgress.lblPackage.Caption := 'GWM Stream Constraints';
    frmProgress.pbPackage.Position := 0;
    Application.ProcessMessages;
    if ContinueExport then
    begin
      Evaluate;
      if ContinueExport then
      begin
        FileName := GetCurrentDir + '\' + Root + rsSTRCON;
        AssignFile(FFile, FileName);
        try
          Rewrite(FFile);
          if ContinueExport then
          begin
            WriteDataReadFrom(FileName);
            frmProgress.lblActivity.Caption := 'Writing Data Set 1';
            WriteDataSet1;
            frmProgress.pbPackage.StepIt;
            Application.ProcessMessages;
          end;
          if ContinueExport then
          begin
            frmProgress.lblActivity.Caption := 'Writing Data Set 2';
            WriteDataSet2;
            frmProgress.pbPackage.StepIt;
            Application.ProcessMessages;
          end;
          if ContinueExport then
          begin
            frmProgress.lblActivity.Caption := 'Writing Data Set 3';
            WriteDataSet3;
            frmProgress.pbPackage.StepIt;
            Application.ProcessMessages;
          end;
          if ContinueExport then
          begin
            frmProgress.lblActivity.Caption := 'Writing Data Set 4';
            WriteDataSet4;
            frmProgress.pbPackage.StepIt;
            Application.ProcessMessages;
          end;
        finally
          CloseFile(FFile);
        end;
      end;
      Application.ProcessMessages;
    end;
  finally
    StreamLocations.Free;
  end;
end;

procedure TStreamConstrainstWriter.EvaluateStreamConstraintContour(
  const UnitIndex, ContourIndex: integer;
  const StreamConstraintsLayer: TLayerOptions;
  const LayerIndicies: TStreamConstraintIndicies;
  const TimeIndicies: TGWM_TimeIndicies; const ModflowLayers: TLayerArray;
  const CellList: TStreamConstraintCellList);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  ContourName, ConstraintType: string;
  CellIndex, ColIndex, RowIndex, LayerIndex, BlockIndex, SegIndex: integer;
  Column, Row, Layer: integer;
  ABlock : TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  StressPeriodArray: TStressPeriodArray;
  TimeCount: integer;
  TimeIndex: integer;
  ConstraintValue: double;
  SegList: TList;
  StreamLocation: TStreamLocation;
begin
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(StressPeriodArray, TimeCount);
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (CurrentModelHandle, StreamConstraintsLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(CurrentModelHandle);
    if (ContourType <> ctClosed) and (CellCount = 0) then
    begin
      Exit;
    end;

    ContourName := Contour.GetStringParameter(CurrentModelHandle,
      LayerIndicies.VariableNameIndex);
    ConstraintType := Contour.GetStringParameter(CurrentModelHandle,
      LayerIndicies.ConstraintTypeIndex);
    ConstraintValue := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.ConstraintValueIndex);

    for TimeIndex := 0 to TimeCount-1 do
    begin
      StressPeriodArray[TimeIndex] := Contour.GetBoolParameter(
        CurrentModelHandle, TimeIndicies[TimeIndex]);
    end;

    case ContourType of
      ctPoint, ctOpen:
      begin
        for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
        begin
          if not ContinueExport then
          begin
            break;
          end;
          Application.ProcessMessages;
          Row    := GGetCellRow(ContourIndex, CellIndex);
          Column := GGetCellColumn(ContourIndex, CellIndex);

          for LayerIndex := 0 to Length(ModflowLayers) - 1 do
          begin
            Layer := ModflowLayers[LayerIndex];
            SegList := StreamLocations[Column, Row, Layer];
            if SegList <> nil then
            begin
              for SegIndex := 0 to SegList.Count -1 do
              begin
                StreamLocation := SegList[SegIndex];
                CellList.Add(ContourName, StreamLocation.Segment,
                  StreamLocation.Reach, ConstraintType, ConstraintValue,
                  StressPeriodArray);
              end;
            end;
          end;
        end;
      end;
      ctClosed:
      begin
        for ColIndex := 1 to Discretization.NCOL do
        begin
          if not ContinueExport then
          begin
            break;
          end;
          Application.ProcessMessages;
          Column := ColIndex;
          for RowIndex := 1 to Discretization.NROW do
          begin
            if not ContinueExport then
            begin
              break;
            end;
            Application.ProcessMessages;
            Row    := RowIndex;
            BlockIndex := Discretization.BlockIndex(Row - 1, Column - 1);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
            finally
              ABlock.Free;
            end;
            if GPointInsideContour(ContourIndex, X, Y) then
            begin
              for LayerIndex := 0 to Length(ModflowLayers) - 1 do
              begin
                Layer := ModflowLayers[LayerIndex];
                SegList := StreamLocations[Column, Row, Layer];
                if SegList <> nil then
                begin
                  for SegIndex := 0 to SegList.Count -1 do
                  begin
                    StreamLocation := SegList[SegIndex];
                    CellList.Add(ContourName, StreamLocation.Segment,
                      StreamLocation.Reach, ConstraintType, ConstraintValue,
                      StressPeriodArray);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      else
      begin
        Assert(False);
      end;
    end;
  finally
    Contour.Free;
  end;  
end;

procedure TStreamConstrainstWriter.StoreStreamLocations;
var
  SegmentIndex, ReachIndex: integer;
  ASegment : TStrSegment;
  AReach: TStrReachObject;
  ASegment2: TSegment;
  AReach2: TStreamReachObject;
begin
  if StrWriter <> nil then
  begin
    for SegmentIndex := 0 to StrWriter.SegmentCount -1 do
    begin
      ASegment := StrWriter.Segments[SegmentIndex];
      for ReachIndex := 0 to ASegment.ReachCount -1 do
      begin
        AReach := ASegment.Reaches[ReachIndex];
        StreamLocations.Add(AReach.Col, AReach.Row, AReach.Layer,
          ASegment.Number, ReachIndex+1);
      end;
    end;
  end;
  if SfrWriter <> nil then
  begin
    for SegmentIndex := 0 to SfrWriter.SegmentCount -1 do
    begin
      ASegment2 := SfrWriter.Segments[SegmentIndex];
      for ReachIndex := 0 to ASegment2.ReachCount -1 do
      begin
        AReach2 := ASegment2.Reaches[ReachIndex];
        StreamLocations.Add(AReach2.Reach.Column, AReach2.Reach.Row, AReach2.Reach.Layer,
          ASegment2.Number, ReachIndex+1);
      end;
    end;
  end;
end;

procedure TStreamConstrainstWriter.GetDepletionConstraintIndicies(
  const DepletionConstraintLayer: TLayerOptions;
  var DepletionConstraintIndicies: TStreamConstraintIndicies;
  var TimeIndicies: TGWM_TimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFStreamDepletionNameParamType.ANE_ParamName;
  DepletionConstraintIndicies.VariableNameIndex :=
    DepletionConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(DepletionConstraintIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFDrawdownConstraintTypeParamType.ANE_ParamName;
  DepletionConstraintIndicies.ConstraintTypeIndex :=
    DepletionConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(DepletionConstraintIndicies.ConstraintTypeIndex >= 0);

  Name := ModflowTypes.GetMFStreamDepletionValueParamType.ANE_ParamName;
  DepletionConstraintIndicies.ConstraintValueIndex :=
    DepletionConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(DepletionConstraintIndicies.ConstraintValueIndex >= 0);

  GetTimeIndicies(DepletionConstraintLayer, TimeIndicies);
end;

procedure TStreamConstrainstWriter.WriteDataSet1;
const
  IPRN = 1;
begin
  WriteLn(FFile, IPRN);
end;

procedure TStreamConstrainstWriter.WriteDataSet2;
var
  NSF, NSD: integer;
begin
  NSF := StreamConstraintCellList.Count;
  NSD := DepletionConstraintCellList.Count;
  WriteLn(FFile, NSF, ' ', NSD);
end;

procedure TStreamConstrainstWriter.WriteDataSet3;
var
  Errors: TStringList;
  ErrorString: string;
begin
  Errors := TStringList.Create;
  try
    StreamConstraintCellList.Write(self, Errors);
    if Errors.Count > 0 then
    begin
      ErrorString := 'Invalid constraint type for streamflow constraints.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.Add('(Name, Segment, Reach, Constraint Type');
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

procedure TStreamConstrainstWriter.WriteDataSet4;
var
  Errors: TStringList;
  ErrorString: string;
begin
  Errors := TStringList.Create;
  try
    DepletionConstraintCellList.Write(self, Errors);
    if Errors.Count > 0 then
    begin
      ErrorString := 'Invalid constraint type for streamflow depletion constraints.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.Add('(Name, Segment, Reach, Constraint Type');
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

{ TStreamConstraintCellList }

function TStreamConstraintCellList.Add(
  Item: TStreamConstraintCell): integer;
begin
  result := inherited AddObject(UpperCase(Item.Name), Item);
end;

procedure TStreamConstraintCellList.Add(const Name: string; const Segment,
  Reach: integer; const ConstraintType: string; const ConstraintValue: double;
  const StressPeriods: TStressPeriodArray);
var
  Item: TStreamConstraintCell;
  StressPeriodIndex: integer;
begin
  for StressPeriodIndex := 0 to Length(StressPeriods) -1 do
  begin
    if StressPeriods[StressPeriodIndex] then
    begin
      Item := TStreamConstraintCell.Create;
      Item.Name := Name;
      Item.Segment := Segment;
      Item.Reach := Reach;
      Item.ConstraintType := ConstraintType;
      Item.ConstraintValue := ConstraintValue;
      Item.StressPeriod := StressPeriodIndex+1;
      Add(Item);
    end;
  end;
end;

constructor TStreamConstraintCellList.Create;
begin
  Sorted := True;
  Duplicates := dupAccept;
  Names:= TNameCountList.Create;
end;

destructor TStreamConstraintCellList.Destroy;
var
  Index: integer;
begin
  Names.Free;
  for Index := 0 to Count -1 do
  begin
    Objects[Index].Free;
  end;
  inherited;
end;

function TStreamConstraintCellList.GetItems(
  const Index: integer): TStreamConstraintCell;
begin
  result := Objects[Index] as TStreamConstraintCell
end;

procedure TStreamConstraintCellList.SetItems(const Index: integer;
  const Value: TStreamConstraintCell);
begin
  Objects[Index] := Value;
end;

procedure TStreamConstraintCellList.Write(
  const Writer: TStreamConstrainstWriter; const TypeErrors: TStringList);
var
  Index: integer;
  Cell: TStreamConstraintCell;
begin
  for Index := 0 to Count -1 do
  begin
    Cell := Items[Index];
    Cell.Write(Writer, Names, TypeErrors);
  end;
end;

{ TStreamLocations }

procedure TStreamLocations.Add(const Col, Row, Layer, Segment,
  Reach: integer);
var
  List: TList;
  StreamLocation: TStreamLocation;
begin
  List := Items[Col, Row, Layer];
  if List = nil then
  begin
    List := TObjectList.Create;
    Items[Col, Row, Layer] := List;
  end;
  StreamLocation := TStreamLocation.Create;
  StreamLocation.Segment := Segment;
  StreamLocation.Reach := Reach;
  List.Add(StreamLocation);
end;

constructor TStreamLocations.Create(const NCol, NRow, NLay: integer);
begin
  SetLength(Locations, NCol, NRow, NLay);
end;

destructor TStreamLocations.Destroy;
var
  Col, Row, Lay: integer;
  NCol, NRow, NLay: integer;
begin
  NCOL := Length(Locations);
  if NCOL > 0 then
  begin
    NRow := Length(Locations[0])
  end
  else
  begin
    NRow := 0;
  end;
  if NRow > 0 then
  begin
    NLay := Length(Locations[0,0])
  end
  else
  begin
    NLay := 0;
  end;

  for Col := 0 to NCOL-1 do
  begin
    for Row := 0 to NRow -1 do
    begin
      for Lay := 0 to NLay -1 do
      begin
        Locations[Col, Row, Lay].Free;
      end;
    end;
  end;
  inherited;
end;

function TStreamLocations.GetItems(const Col, Row, Layer: integer): TList;
begin
  result := Locations[Col-1, Row-1, Layer-1]
end;

procedure TStreamLocations.SetItems(const Col, Row, Layer: integer;
  const Value: TList);
begin
  Locations[Col-1, Row-1, Layer-1] := Value;
end;

{ TStreamConstraintCell }

procedure TStreamConstraintCell.Write(
  const Writer: TStreamConstrainstWriter; const Names: TNameCountList;
  const TypeErrors: TStringList);
var
  OutNAME: string;
  SEG: integer;
  REACH: integer;
  ConstraintTYP: string;
  BND: double;
  NSP: integer;
begin
  OutNAME := Names.NewName(Name);
  SEG := self.Segment;
  Reach := self.Reach;
  ConstraintTYP := UpperCase(self.ConstraintType);
  if Length(ConstraintTYP) > 2 then
  begin
    SetLength(ConstraintTYP,2);
  end;
  if (ConstraintTYP <> 'GE') and (ConstraintTYP <> 'LE') then
  begin
    TypeErrors.Add(Name + ', ' + IntToStr(Seg)  + ', ' + IntToStr(Reach)
       + ', ' + self.ConstraintType);
  end;
  BND := self.ConstraintValue;
  NSP := self.StressPeriod;
  WriteLn(Writer.FFile, OutNAME, ' ', SEG, ' ', REACH, ' ', ConstraintTYP,
    ' ', BND, ' ', NSP); 

end;

end.
