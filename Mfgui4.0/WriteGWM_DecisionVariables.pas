unit WriteGWM_DecisionVariables;

interface

uses SysUtils, Classes, Forms, Contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization;

type
  TGWM_LayerParameters = record
    VariableNameIndex: ANE_INT16;
    FluxTypeIndex: ANE_INT16;
    FluxStatIndex: ANE_INT16;
    FluxVariableRatioIndex: ANE_INT16;
    MinIndex: ANE_INT16;
    MaxIndex: ANE_INT16;
    ReferenceIndex: ANE_INT16;
    BaseIndex: ANE_INT16;
  end;

  TGWM_Cell = class
    Layer: integer;
    Row: integer;
    Column: integer;
    Ratio: double;
    UnitNumber: integer;
  end;

  TGWM_TimeIndicies = array of ANE_INT16;
  TStressPeriodArray = array of boolean;

  TWriteGWM_DecisionVariablesAndConstraintsWriter = class;

  TGWM_CellList = class(TObjectList)
  private
    FDecisionType: string;
    FStatisticType: string;
    FUseInStressPeriods: TStressPeriodArray;
    FName: string;
    Minimum, Maximum, Reference, Base: double;
    function GetItem(const Index: integer): TGWM_Cell;
    procedure SetItem(const Index: integer; const Value: TGWM_Cell);
    procedure SetDecisionType(const Value: string);
    procedure SetStatisticType(const Value: string);
    function GetUseInStressPeriod(const Index: integer): boolean;
    procedure SetUseInStressPeriod(const Index: integer; const Value: boolean);
    procedure SetName(const Value: string);
    procedure AdjustRatios(const RatioErrors: TStringList);
    procedure WriteVarconDataSet2(
      const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter);
    procedure WriteSolnDataSet6(const Writer: TModflowWriter);
  public
    function Add(const Item: TGWM_Cell): integer; overload;
    function Add(const Layer, Row, Column, UnitNumber: integer;
      const Ratio: double): integer; overload;
    constructor Create;
    property DecisionType: string read FDecisionType write SetDecisionType;
    property Items[const Index: integer]: TGWM_Cell read GetItem write SetItem;
      default;
    property Name: string read FName write SetName;
    property StatisticType: string read FStatisticType write SetStatisticType;
    function TimeCount: integer;
    property UseInStressPeriod[const Index: integer]: boolean
      read GetUseInStressPeriod write SetUseInStressPeriod;
    procedure WriteDecvarDataSet3(
      const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter;
      const TypeErrors, StatErrors, TimeErrors, RatioErrors: TStringList);
  end;

  TGWM_GroupList = class(TObjectList)
  private
    function GetItem(const Index: integer): TGWM_CellList;
    procedure SetItem(const Index: integer; const Value: TGWM_CellList);
    procedure WriteVarconDataSet2(
      const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter);
    procedure WriteSolnDataSet6(const Writer: TModflowWriter);
  public
    function Add(const Item: TGWM_CellList): integer; overload;
    property Items[const Index: integer]: TGWM_CellList
      read GetItem write SetItem; default;
    procedure WriteDecvarDataSet3(
      const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter;
      const TypeErrors, StatErrors, TimeErrors, RatioErrors: TStringList);
    function GetByName(AName: string): TGWM_CellList;
  end;

  TCustomGWM_Writer = class(TListWriter)
  protected
    CurrentModelHandle: ANE_PTR;
    ProjectOptions: TProjectOptions;
    Discretization: TDiscretizationWriter;
    procedure GetTimeIndicies(const Layer: TLayerOptions;
      var TimeIndicies: TGWM_TimeIndicies);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TWriteGWM_DecisionVariablesAndConstraintsWriter = class(TCustomGWM_Writer)
  private
    GroupList: TGWM_GroupList;
    DataSet4: TStringList;
    DataSet5: TStringList;
    procedure EvaluateContour(const UnitIndex, ContourIndex: integer;
      const FluxLayer: TLayerOptions;
      const LayerIndicies: TGWM_LayerParameters;
      const TimeIndicies: TGWM_TimeIndicies; const ModflowLayers: TLayerArray;
      const RatioExpression: string);
    procedure EvaluateDecvar3AndVarcon2;
    procedure EvaluateDataSet4;
    procedure EvaluateDataSet5;
    procedure EvaluateLayer(const UnitIndex: integer);
    procedure GetLayerParameters(const Layer: TLayerOptions;
      var LayerIndicies: TGWM_LayerParameters;
      var TimeIndicies: TGWM_TimeIndicies; var RatioExpression: string);
    procedure WriteDecvarDataSet1;
    procedure WriteDecvarDataSet2;
    procedure WriteDecvarDataSet3;
    procedure WriteDecvarDataSet4;
    procedure WriteDecvarDataSet5;
    procedure WriteDecisionVariables(const Root: string);
    procedure WriteConstraints(const Root: string);
    procedure WriteVarconDataSet1;
    procedure WriteVarconDataSet2;
    procedure WriteVarconDataSet3;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFiles(const CurrentModelHandle: ANE_PTR;
      const Root: string; Discretization: TDiscretizationWriter);
    procedure WriteSolnDataSet6(const Writer: TModflowWriter);
    procedure PartialEvaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure WriteDecVarFile(const CurrentModelHandle: ANE_PTR;
      const Root: string; Discretization: TDiscretizationWriter);
    procedure WriteConstraintFile(const CurrentModelHandle: ANE_PTR;
      const Root: string; Discretization: TDiscretizationWriter);
  end;

function FixGWM_Name(AString: string): string;

function EvaluateStressPeriods(
  const StressPeriods: TStressPeriodArray): string;

implementation

uses DataGrid, Variables, ProgressUnit, GetCellUnit, PointInsideContourUnit,
  ModflowUnit, WriteNameFileUnit, UtilityFunctions, WriteGWM_Solution;

function EvaluateStressPeriods(
  const StressPeriods: TStressPeriodArray): string;
var
  Count:     integer;
  TimeIndex: integer;
  Previous:  boolean;
begin
  Previous := False;
  result   := '';
  Count    := 0;
  for TimeIndex := 1 to Length(StressPeriods) do
  begin
    if StressPeriods[TimeIndex - 1] then
    begin
      if not Previous or (TimeIndex = Length(StressPeriods)) then
      begin
        if Length(result) > 0 then
        begin
          if Previous then
          begin
            result := result + '-';
          end
          else
          begin
            result := result + ':';
          end;
        end;
        result := result + IntToStr(TimeIndex);
      end;
      Inc(Count);
    end
    else
    if Previous then
    begin
      if Count > 1 then
      begin
        result := result + '-' + IntToStr(TimeIndex - 1);
      end;
      Count := 0;
    end;
    Previous := StressPeriods[TimeIndex - 1];
  end;
end;

function FixGWM_Name(AString: string): string;
var
  CharIndex: integer;
begin
  // limit length of AString to 10 characters with no blank spaces.
  AString := Trim(AString);
  if Length(AString) > 10 then
  begin
    SetLength(AString, 10);
  end;
  for CharIndex := 1 to Length(AString) do
  begin
    if AString[CharIndex] = ' ' then
    begin
      AString[CharIndex] := '_';
    end;
  end;
  result := AString;
end;

{ TWriteGWM_DecisionVariablesAndConstraintsWriter }

constructor TWriteGWM_DecisionVariablesAndConstraintsWriter.Create;
begin
  inherited;
  GroupList := TGWM_GroupList.Create;
  DataSet4  := TStringList.Create;
  DataSet5  := TStringList.Create;
end;

destructor TWriteGWM_DecisionVariablesAndConstraintsWriter.Destroy;
begin
  GroupList.Free;
  DataSet4.Free;
  DataSet5.Free;
  inherited;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.EvaluateContour(
  const UnitIndex, ContourIndex: integer; const FluxLayer: TLayerOptions;
  const LayerIndicies: TGWM_LayerParameters;
  const TimeIndicies: TGWM_TimeIndicies; const ModflowLayers: TLayerArray;
  const RatioExpression: string);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  CellList: TGWM_CellList;
  TimeIndex: integer;
  CellIndex: integer;
  Column, Row, Layer: integer;
  Ratio: double;
  Minimum, Maximum, Reference, Base: double;
  LayerIndex: integer;
  BlockIndex: integer;
  ABlock: TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
//  ColIndex, RowIndex: integer;
  AName: string;
  NewList: boolean;
begin
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (CurrentModelHandle, FluxLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(CurrentModelHandle);
    if (ContourType <> ctPoint) or (CellCount = 0) then
    begin
      Exit;
    end;

    Minimum := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.MinIndex);
    Maximum := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.MaxIndex);
    Reference := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.ReferenceIndex);
    if frmModflow.rgGWM_SolutionType.ItemIndex = 3 then
    begin
      Base := Contour.GetFloatParameter(CurrentModelHandle,
        LayerIndicies.BaseIndex);
    end
    else
    begin
      Base := 0;
    end;

    AName := Contour.GetStringParameter(CurrentModelHandle,
        LayerIndicies.VariableNameIndex);

    CellList := GroupList.GetByName(AName);
    NewList := CellList = nil;
    if NewList then
    begin
      CellList := TGWM_CellList.Create;
    end;
    try
      CellList.Minimum := Minimum;
      CellList.Maximum := Maximum;
      CellList.Reference := Reference;
      CellList.Base := Base;

      {case ContourType of
        ctPoint, ctOpen:
        begin  }
          for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
          begin
            if not ContinueExport then
            begin
              break;
            end;
            Application.ProcessMessages;
            Row    := GGetCellRow(ContourIndex, CellIndex);
            Column := GGetCellColumn(ContourIndex, CellIndex);
            if ContourType = ctPoint then
            begin
              Ratio := Contour.GetFloatParameter(CurrentModelHandle,
                LayerIndicies.FluxVariableRatioIndex);
            end
            else
            begin
              BlockIndex := Discretization.BlockIndex(Row - 1, Column - 1);
              ABlock     := TBlockObjectOptions.Create(CurrentModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                ABlock.GetCenter(CurrentModelHandle, X, Y);
              finally
                ABlock.Free;
              end;
              Ratio := FluxLayer.RealValueAtXY(CurrentModelHandle,
                X, Y, RatioExpression);
            end;

            for LayerIndex := 0 to Length(ModflowLayers) - 1 do
            begin
              Layer := ModflowLayers[LayerIndex];
              CellList.Add(Layer, Row, Column, UnitIndex, Ratio);
            end;
          end;
{        end;
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
                Ratio := FluxLayer.RealValueAtXY(CurrentModelHandle,
                  X, Y, RatioExpression);
                for LayerIndex := 0 to Length(ModflowLayers) - 1 do
                begin
                  Layer := ModflowLayers[LayerIndex];
                  CellList.Add(Layer, Row, Column, UnitIndex, Ratio);
                end;
              end;
            end;
          end;
        end;
        else
        begin
          Assert(False);
        end;
      end;}

      CellList.DecisionType := Contour.GetStringParameter(CurrentModelHandle,
        LayerIndicies.FluxTypeIndex);
      CellList.StatisticType := Contour.GetStringParameter(CurrentModelHandle,
        LayerIndicies.FluxStatIndex);
      CellList.Name := Contour.GetStringParameter(CurrentModelHandle,
        LayerIndicies.VariableNameIndex);

      for TimeIndex := 0 to CellList.TimeCount - 1 do
      begin
        CellList.UseInStressPeriod[TimeIndex] := Contour.GetBoolParameter(
          CurrentModelHandle, TimeIndicies[TimeIndex]);
      end;

    finally
      if NewList then
      begin
        if CellList.Count > 0 then
        begin
          GroupList.Add(CellList);
        end
        else
        begin
          CellList.Free;
        end;
      end;
    end;
  finally
    Contour.Free;
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.EvaluateLayer(
  const UnitIndex: integer);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  FluxLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  LayerIndicies: TGWM_LayerParameters;
  TimeIndicies:  TGWM_TimeIndicies;
  ModflowLayers: TLayerArray;
  RatioExpression: string;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFFluxVariableLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  FluxLayer   := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := FluxLayer.NumObjects(CurrentModelHandle, pieContourObject);
    if ContourCount > 0 then
    begin
      GetLayerParameters(FluxLayer, LayerIndicies, TimeIndicies,
        RatioExpression);
      RatioExpression := LayerName + '.' + RatioExpression;

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateContour(UnitIndex, ContourIndex, FluxLayer,
          LayerIndicies, TimeIndicies, ModflowLayers, RatioExpression);
      end;
    end;
  finally
    FluxLayer.Free(CurrentModelHandle);
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.GetLayerParameters(
  const Layer: TLayerOptions; var LayerIndicies: TGWM_LayerParameters;
  var TimeIndicies: TGWM_TimeIndicies; var RatioExpression: string);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFFluxVariableNameParamType.ANE_ParamName;
  LayerIndicies.VariableNameIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFFluxTypeParamType.ANE_ParamName;
  LayerIndicies.FluxTypeIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.FluxTypeIndex >= 0);

  Name := ModflowTypes.GetMFFluxStatParamType.ANE_ParamName;
  LayerIndicies.FluxStatIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.FluxStatIndex >= 0);

  Name := ModflowTypes.GetMFFluxVariableRatioParamType.ANE_ParamName;
  LayerIndicies.FluxVariableRatioIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.FluxVariableRatioIndex >= 0);
  RatioExpression := Name;



  Name := ModflowTypes.GetMFFluxMinimumParamType.ANE_ParamName;
  LayerIndicies.MinIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.MinIndex >= 0);

  Name := ModflowTypes.GetMFFluxMaximumParamType.ANE_ParamName;
  LayerIndicies.MaxIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.MaxIndex >= 0);

  Name := ModflowTypes.GetMFFluxReferenceParamType.ANE_ParamName;
  LayerIndicies.ReferenceIndex := Layer.GetParameterIndex(
    CurrentModelHandle, Name);
  Assert(LayerIndicies.ReferenceIndex >= 0);

  if frmModflow.rgGWM_SolutionType.ItemIndex = 3 then
  begin
    Name := ModflowTypes.GetMFFluxBaseParamType.ANE_ParamName;
    LayerIndicies.BaseIndex := Layer.GetParameterIndex(
      CurrentModelHandle, Name);
    Assert(LayerIndicies.BaseIndex >= 0);
  end;

  GetTimeIndicies(Layer, TimeIndicies);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecvarDataSet3;
var
  TypeErrors, StatErrors, TimeErrors, RatioErrors: TStringList;
  ErrorString: string;
begin
  TypeErrors  := TStringList.Create;
  StatErrors  := TStringList.Create;
  TimeErrors  := TStringList.Create;
  RatioErrors := TStringList.Create;
  try
    GroupList.WriteDecvarDataSet3(self, TypeErrors, StatErrors,
      TimeErrors, RatioErrors);
    if TypeErrors.Count > 0 then
    begin
      ErrorString := 'In GWM, one or more "' + ModflowTypes.
        GetMFFluxTypeParamType.ANE_ParamName + '" parameters have ' +
        'been specified incorrectly on a "' + ModflowTypes.
        GetMFFluxVariableLayerType.ANE_LayerName + '.';

      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.Add('(' +
        ModflowTypes.GetMFFluxVariableNameParamType.ANE_ParamName +
        ', ' + ModflowTypes.GetMFFluxTypeParamType.ANE_ParamName + ')');
      ErrorMessages.AddStrings(TypeErrors);
    end;
    if StatErrors.Count > 0 then
    begin
      ErrorString := 'In GWM, one or more "' + ModflowTypes.
        GetMFFluxStatParamType.ANE_ParamName + '" parameters have ' +
        'been specified incorrectly on a "' + ModflowTypes.
        GetMFFluxVariableLayerType.ANE_LayerName + '.';

      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.Add('(' +
        ModflowTypes.GetMFFluxVariableNameParamType.ANE_ParamName +
        ', ' + ModflowTypes.GetMFFluxStatParamType.ANE_ParamName + ')');
      ErrorMessages.AddStrings(TypeErrors);
    end;
    if TimeErrors.Count > 0 then
    begin
      ErrorString := 'One or more Decision variables in GWM is ' +
        'never used in any stress period.';

      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.Add('(' +
        ModflowTypes.GetMFFluxVariableNameParamType.ANE_ParamName + ')');
      ErrorMessages.AddStrings(TimeErrors);
    end;
    if RatioErrors.Count > 0 then
    begin
      ErrorString := 'In GWM, one or more cells on a "' + ModflowTypes.
        GetMFFluxVariableLayerType.ANE_LayerName +
        ' has a ratio less than or equal to zero.';

      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.Add('(' +
        ModflowTypes.GetMFFluxVariableNameParamType.ANE_ParamName +
        ', unit, row, coloumn, ratio)');
      ErrorMessages.AddStrings(RatioErrors);
    end;
  finally
    TypeErrors.Free;
    StatErrors.Free;
    TimeErrors.Free;
    RatioErrors.Free;
  end;

end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.EvaluateDecvar3AndVarcon2;
var
  UnitIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      EvaluateLayer(UnitIndex);
    end;
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.EvaluateDataSet4;
var
  EVNAME, ETYPE, ESP: string;
  RowIndex:  integer;
  UseInStressPeriod: TStressPeriodArray;
  AString:   string;
  ItemIndex: integer;
  TimeIndex: integer;
  TimeCount: integer;
begin
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(UseInStressPeriod, TimeCount);
  Assert(frmModflow.frameGWM_External.dgVariables.ColCount =
    TimeCount + Ord(gecSP1));
  if frmModflow.frameGWM_External.dgVariables.Enabled then
  begin
    for RowIndex := 1 to frmModflow.frameGWM_External.dgVariables.RowCount
      - 1 do
    begin
      EVNAME    := FixGWM_Name(frmModflow.frameGWM_External.
        dgVariables.Cells[Ord(gecName), RowIndex]);
      AString   := frmModflow.frameGWM_External.
        dgVariables.Cells[Ord(gecType), RowIndex];
      ItemIndex := frmModflow.frameGWM_External.
        dgVariables.Columns[Ord(gecType)].PickList.IndexOf(AString);
      case ItemIndex of
        0:
        begin
          ETYPE := 'IM';
        end;
        1:
        begin
          ETYPE := 'EX';
        end;
        2:
        begin
          ETYPE := 'HD';
        end;
        3:
        begin
          ETYPE := 'SF';
        end;
        4:
        begin
          ETYPE := 'ST';
        end;
        5:
        begin
          ETYPE := 'GN';
        end;
        else
        begin
          Assert(False);
        end;
      end;
      for TimeIndex := Ord(gecSP1) to
        frmModflow.frameGWM_External.dgVariables.ColCount - 1 do
      begin
        UseInStressPeriod[TimeIndex - Ord(gecSP1)] :=
          frmModflow.frameGWM_External.dgVariables.Checked[TimeIndex,
          RowIndex];
      end;
      ESP := EvaluateStressPeriods(UseInStressPeriod);

      DataSet4.Add(EVNAME + ' ' + ETYPE + ' ' + ESP);
    end;
  end;

end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.EvaluateDataSet5;
var
  BVName:   string;
  NDV:      integer;
  BVList:   string;
  RowIndex: integer;
  NameGrid: TDataGrid;
  NameRowIndex: integer;
begin
  if frmModflow.frameGWM_Binary.dgVariables.Enabled then
  begin
    for RowIndex := 1 to frmModflow.frameGWM_Binary.dgVariables.RowCount - 1 do
    begin
      BVName   := FixGWM_Name(
        frmModflow.frameGWM_Binary.dgVariables.Cells[Ord(gbcName), RowIndex]);
      NDV      := StrToInt(
        frmModflow.frameGWM_Binary.dgVariables.Cells[Ord(gbcCount), RowIndex]);
      NameGrid := frmModflow.dg3dGWM_BinaryDecVar.Grids[RowIndex - 1];
      BVList   := '';
      for NameRowIndex := 1 to NameGrid.RowCount - 1 do
      begin
        BVList := BVList + FixGWM_Name(NameGrid.Cells[0, NameRowIndex]) + ' ';
      end;
      DataSet5.Add(BVName + ' ' + IntToStr(NDV) + ' ' + BVList);
    end;
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecvarDataSet1;
const
  IPRN = 1;
var
  GWMWFILE: integer;
begin
  if frmModflow.cbGWMWFILE.Checked then
  begin
    GWMWFILE := frmModflow.GetUnitNumber('GWMWFILE');
  end
  else
  begin
    GWMWFILE := 0;
  end;

  WriteLn(FFile, IPRN, ' ', GWMWFILE);

end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteVarconDataSet1;
const
  IPRN = 1;
begin
  WriteLn(FFile, IPRN);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecvarDataSet2;
var
  NFVAR, NEVAR, NBVAR: integer;
begin
  NFVAR := GroupList.Count;
  NEVAR := DataSet4.Count;
  NBVAR := DataSet5.Count;
  WriteLn(FFile, NFVAR, ' ', NEVAR, ' ', NBVAR);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecvarDataSet4;
var
  Index: integer;
begin
  for Index := 0 to DataSet4.Count - 1 do
  begin
    WriteLn(FFile, DataSet4[Index]);
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecvarDataSet5;
var
  Index: integer;
begin
  for Index := 0 to DataSet5.Count - 1 do
  begin
    WriteLn(FFile, DataSet5[Index]);
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecisionVariables(
  const Root: string);
var
  FileName: string;
begin
  frmProgress.pbPackage.Max := Discretization.NUNITS;
  frmProgress.lblPackage.Caption := 'GWM Decision Variables';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;
  if ContinueExport then
  begin
    EvaluateDecvar3AndVarcon2;
    //    frmProgress.pbPackage.StepIt;
    //    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    EvaluateDataSet4;
  end;

  if ContinueExport then
  begin
    EvaluateDataSet5;
  end;

  if ContinueExport then
  begin

    FileName := GetCurrentDir + '\' + Root + rsDECVAR;
    AssignFile(FFile, FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        frmProgress.lblActivity.Caption := 'Writing Data Set 1';
        WriteDecvarDataSet1;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 2';
        WriteDecvarDataSet2;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 3';
        WriteDecvarDataSet3;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 4';
        WriteDecvarDataSet4;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 5';
        WriteDecvarDataSet5;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteConstraints(
  const Root: string);
var
  FileName: string;
begin
  if ContinueExport then
  begin

    FileName := GetCurrentDir + '\' + Root + rsVARCON;
    AssignFile(FFile, FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        frmProgress.lblActivity.Caption := 'Writing Data Set 1';
        WriteVarconDataSet1;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 2';
          WriteVarConDataSet2;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 3';
          WriteVarConDataSet3;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteFiles(
  const CurrentModelHandle: ANE_PTR; const Root: string;
  Discretization: TDiscretizationWriter);
begin
  self.Discretization     := Discretization;
  self.CurrentModelHandle := CurrentModelHandle;
  WriteDecisionVariables(Root);
  frmProgress.pbOverall.StepIt;
  WriteConstraints(Root);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteVarconDataSet2;
begin
  GroupList.WriteVarconDataSet2(self);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteVarconDataSet3;
var
  RowIndex: integer;
  EVNAME: string;
  EVMIN: double;
  EVMAX: double;
begin
  if frmModflow.frameGWM_External.dgVariables.Enabled then
  begin
    for RowIndex := 1 to frmModflow.frameGWM_External.dgVariables.RowCount
      - 1 do
    begin
      EVNAME := FixGWM_Name(frmModflow.frameGWM_External.
        dgVariables.Cells[Ord(gecName), RowIndex]);
      EVMIN := InternationalStrToFloat(frmModflow.frameGWM_External.
        dgVariables.Cells[Ord(gecMin), RowIndex]);
      EVMAX := InternationalStrToFloat(frmModflow.frameGWM_External.
        dgVariables.Cells[Ord(gecMax), RowIndex]);
      writeln(FFile, EVNAME, ' ', EVMIN, ' ', EVMAX);
    end;
  end
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteSolnDataSet6(
  const Writer: TModflowWriter);
begin
  Assert(Writer is TSolutionWriter);
  GroupList.WriteSolnDataSet6(Writer);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.PartialEvaluate(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
begin
  self.Discretization     := Discretization;
  self.CurrentModelHandle := CurrentModelHandle;
  EvaluateDecvar3AndVarcon2;
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteConstraintFile(
  const CurrentModelHandle: ANE_PTR; const Root: string;
  Discretization: TDiscretizationWriter);
begin
  PartialEvaluate(CurrentModelHandle, Discretization);
  WriteConstraints(Root);
end;

procedure TWriteGWM_DecisionVariablesAndConstraintsWriter.WriteDecVarFile(
  const CurrentModelHandle: ANE_PTR; const Root: string;
  Discretization: TDiscretizationWriter);
begin
  self.Discretization     := Discretization;
  self.CurrentModelHandle := CurrentModelHandle;
  WriteDecisionVariables(Root);
end;

{ TGWM_CellList }

function TGWM_CellList.Add(const Item: TGWM_Cell): integer;
begin
  result := inherited Add(Item);
end;

function TGWM_CellList.Add(const Layer, Row, Column, UnitNumber: integer;
  const Ratio: double): integer;
var
  Item: TGWM_Cell;
begin
  Item := TGWM_Cell.Create;
  Item.Layer := Layer;
  Item.Row := Row;
  Item.Column := Column;
  Item.UnitNumber := UnitNumber;
  Item.Ratio := Ratio;
  result := Add(Item);
end;

constructor TGWM_CellList.Create;
begin
  inherited;
  SetLength(FUseInStressPeriods, TimeCount);
end;

function TGWM_CellList.GetItem(const Index: integer): TGWM_Cell;
begin
  result := inherited Items[Index] as TGWM_Cell;
end;

function TGWM_CellList.GetUseInStressPeriod(const Index: integer): boolean;
begin
  result := FUseInStressPeriods[Index];
end;

procedure TGWM_CellList.SetDecisionType(const Value: string);
begin
  FDecisionType := Value;
end;

procedure TGWM_CellList.SetItem(const Index: integer; const Value: TGWM_Cell);
begin
  inherited Items[Index] := Value;
end;

procedure TGWM_CellList.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TGWM_CellList.SetStatisticType(const Value: string);
begin
  FStatisticType := Value;
end;

procedure TGWM_CellList.SetUseInStressPeriod(const Index: integer;
  const Value: boolean);
begin
  FUseInStressPeriods[Index] := Value;
end;

function TGWM_CellList.TimeCount: integer;
begin
  result := frmModflow.dgTime.RowCount - 1;
end;

procedure TGWM_CellList.AdjustRatios(const RatioErrors: TStringList);
var
  CellIndex: integer;
  Cell: TGWM_Cell;
  Sum: double;
begin
  Sum := 0;
  for CellIndex := 0 to Count - 1 do
  begin
    Cell := Items[CellIndex];
    if Cell.Ratio <= 0 then
    begin
      RatioErrors.Add(Name + ', ' + IntToStr(Cell.UnitNumber) +
        ', ' + IntToStr(Cell.Row) + ', ' + IntToStr(Cell.Column) +
        ', ' + FloatToStr(Cell.Ratio));
    end;

    Sum := Sum + Cell.Ratio;
  end;
  if Sum = 1 then
  begin
    Exit;
  end;
  if Sum = 0 then
  begin
    Exit;
  end;
  for CellIndex := 0 to Count - 1 do
  begin
    Cell := Items[CellIndex];
    Cell.Ratio := Cell.Ratio / Sum;
  end;
end;

procedure TGWM_CellList.WriteVarconDataSet2(
  const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter);
var
  FVNAME: string;
  FVMIN: double;
  FVMAX: double;
  FVREF: double;
begin
  FVNAME := FixGWM_Name(Name);
  FVMIN := Minimum;
  FVMAX := Maximum;
  FVREF := Reference;

  WriteLn(Writer.FFile, FVNAME, ' ', FVMIN, ' ', FVMAX, ' ', FVREF);
end;

procedure TGWM_CellList.WriteDecvarDataSet3(
  const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter;
  const TypeErrors, StatErrors, TimeErrors, RatioErrors: TStringList);
var
  FVNAME: string;
  NC:     integer;
  FTYPE:  string;
  FSTAT:  string;
  WSP:    string;
  CellIndex: integer;
  Cell:   TGWM_Cell;
begin
  FVNAME := FixGWM_Name(Name);

  NC := Count;

  FTYPE := UpperCase(DecisionType);
  if Length(FTYPE) > 1 then
  begin
    SetLength(FTYPE, 1);
  end;
  if (FTYPE <> 'W') and (FTYPE <> 'I') then
  begin
    TypeErrors.Add(Name + ', ' + DecisionType);
  end;

  FSTAT := UpperCase(StatisticType);
  if Length(FSTAT) > 1 then
  begin
    SetLength(FSTAT, 1);
  end;
  if (FSTAT <> 'Y') and (FSTAT <> 'N') then
  begin
    StatErrors.Add(Name + ', ' + StatisticType);
  end;

  WSP := EvaluateStressPeriods(FUseInStressPeriods);
  if WSP = '' then
  begin
    TimeErrors.Add(Name);
  end;

  Assert(Count >= 1);
  Cell := Items[0];

  WriteLn(Writer.FFile, FVNAME, ' ', NC, ' ', Cell.Layer, ' ', Cell.Row, ' ',
    Cell.Column, ' ', FTYPE, ' ', FSTAT, ' ', WSP);

  if NC > 1 then
  begin
    AdjustRatios(RatioErrors);
    for CellIndex := 0 to Count - 1 do
    begin
      Cell := Items[CellIndex];
      WriteLn(Writer.FFile, '     ', Cell.Ratio, ' ', Cell.Layer, ' ',
        Cell.Row, ' ', Cell.Column);
    end;
  end;
end;

procedure TGWM_CellList.WriteSolnDataSet6(const Writer: TModflowWriter);
var
  FVNAME: string;
begin
  FVNAME := FixGWM_Name(Name);
  WriteLn(Writer.FFile, FVNAME, ' ', Base);
end;

{ TGWM_GroupList }

function TGWM_GroupList.Add(const Item: TGWM_CellList): integer;
begin
  result := inherited Add(Item);
end;

function TGWM_GroupList.GetItem(const Index: integer): TGWM_CellList;
begin
  result := inherited Items[Index] as TGWM_CellList;
end;

procedure TGWM_GroupList.SetItem(const Index: integer;
  const Value: TGWM_CellList);
begin
  inherited Items[Index] := Value;
end;
procedure TGWM_GroupList.WriteVarconDataSet2(
  const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter);
var
  Index: integer;
  Group: TGWM_CellList;
begin
  for Index := 0 to Count - 1 do
  begin
    Group := Items[Index];
    Group.WriteVarconDataSet2(Writer);
  end;
end;


procedure TGWM_GroupList.WriteDecvarDataSet3(
  const Writer: TWriteGWM_DecisionVariablesAndConstraintsWriter;
  const TypeErrors, StatErrors, TimeErrors, RatioErrors: TStringList);
var
  Index: integer;
  Group: TGWM_CellList;
begin
  for Index := 0 to Count - 1 do
  begin
    Group := Items[Index];
    Group.WriteDecvarDataSet3(Writer, TypeErrors, StatErrors, TimeErrors,
      RatioErrors);
  end;
end;

procedure TGWM_GroupList.WriteSolnDataSet6(const Writer: TModflowWriter);
var
  Index: integer;
  Group: TGWM_CellList;
begin
  for Index := 0 to Count - 1 do
  begin
    Group := Items[Index];
    Group.WriteSolnDataSet6(Writer);
  end;
end;

function TGWM_GroupList.GetByName(AName: string): TGWM_CellList;
var
  Index: integer;
  Item: TGWM_CellList;
begin
  result := nil;
  AName := UpperCase(AName);
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    if UpperCase(Item.Name) = AName then
    begin
      result := Item;
      Exit;
    end;
  end;
end;

{ TCustomGWM_Writer }

constructor TCustomGWM_Writer.Create;
begin
  inherited;
  ProjectOptions := TProjectOptions.Create;
end;

destructor TCustomGWM_Writer.Destroy;
begin
  ProjectOptions.Free;
  inherited;
end;

procedure TCustomGWM_Writer.GetTimeIndicies(
  const Layer: TLayerOptions; var TimeIndicies: TGWM_TimeIndicies);
var
  Name, Root: string;
  TimeIndex:  integer;
  TimeCount:  integer;
begin
  Root := ModflowTypes.GetMFGWM_UseInPeriodParamType.ANE_ParamName;
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(TimeIndicies, TimeCount);
  for TimeIndex := 1 to TimeCount do
  begin
    Name := Root + IntToStr(TimeIndex);
    TimeIndicies[TimeIndex - 1] := Layer.GetParameterIndex(
      CurrentModelHandle, Name);
  end;
end;

end.

