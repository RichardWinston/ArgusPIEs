unit WriteGWM_HeadConstraints;

interface

uses SysUtils, Classes, Forms, Contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization, WriteGWM_DecisionVariables;

type
  THeadAndDrawdownIndicies = record
    VariableNameIndex: ANE_INT16;
    ConstraintTypeIndex: ANE_INT16;
    ConstraintValueIndex: ANE_INT16;
  end;

  THeadDifferenceIndicies= record
    VariableNameIndex: ANE_INT16;
    ConstraintValueIndex: ANE_INT16;
    ElevationIndex: ANE_INT16;
    FirstIndex: ANE_INT16;
  end;

  TGradientIndicies= record
    VariableNameIndex: ANE_INT16;
    GradientValueIndex: ANE_INT16;
    LengthIndex: ANE_INT16;
    StartElevationIndex: ANE_INT16;
    EndElevationIndex: ANE_INT16;
    FirstIndex: ANE_INT16;
  end;

  TGWM_HeadConstraintsWriter = class;

  // @name is used to count the number of copies of a string added to it.
  // Don't use Insert or Objects with @name.
  TNameCountList = class(TStringList)
  public
    {@name converts S to upper case and checks if the upper case version has
     already been added.  If not it adds it and returns 1.  If so, it returns
     the number of times it has already been added (including this time)}
    function Add(const S: string): Integer; override;
    constructor Create;
    function NewName(AName: string): string;
  end;

  TGWM_HeadOrDrawdownCell = class(TObject)
    Layer: integer;
    Row: integer;
    Column: integer;
    Name: string;
    ConstraintType: string;
    BND: double;
    StressPeriods: TStressPeriodArray;
    procedure Write(const Writer: TGWM_HeadConstraintsWriter);
    function NumberOfHeads: integer;
  end;

  TGWM_HeadOrDrawdownCellList = class(TObjectList)
  private
    NameCountList: TNameCountList;
    function GetItems(const Index: integer): TGWM_HeadOrDrawdownCell;
    procedure SetItems(const Index: integer;
      const Value: TGWM_HeadOrDrawdownCell);
  public
    constructor Create;
    Destructor Destroy; override;
    function Add(Item: TGWM_HeadOrDrawdownCell): integer; overload;
    function Add(const Name, ConstraintType: string; const Layer, Row,
      Column: integer; const Bound: double; const StressPeriods: TStressPeriodArray):
      TGWM_HeadOrDrawdownCell; overload;
    property Items[const Index: integer]: TGWM_HeadOrDrawdownCell
      read GetItems write SetItems;
    procedure Write(const Writer: TGWM_HeadConstraintsWriter);
    function NumberOfHeads: integer;
  end;

  TGWM_CellDifference = class(TObject)
    Layer1: integer;
    Row1: integer;
    Column1: integer;
    Layer2: integer;
    Row2: integer;
    Column2: integer;
    Name: string;
    Difference: double;
    StressPeriods: TStressPeriodArray;
    constructor Create;
    procedure Write(const Writer: TGWM_HeadConstraintsWriter);
    function NumberOfHeads: integer;
  end;

  TGWM_DifferenceCellList = class(TStringList)
  private
    function GetItems(const Index: integer): TGWM_CellDifference;
    procedure SetItems(const Index: integer;
      const Value: TGWM_CellDifference);
  public
    constructor Create;
    Destructor Destroy; override;
    function Add(Item: TGWM_CellDifference): integer; reintroduce; overload;
    function Add(const Name: string; const Layer, Row,
      Column: integer; const Difference: double; const First: boolean;
      const StressPeriods: TStressPeriodArray; const DuplicateErrors,
      InvalidDifferencesErrors: TStringList):
      TGWM_CellDifference; reintroduce; overload;
    property Items[const Index: integer]: TGWM_CellDifference
      read GetItems write SetItems;
    procedure Write(const Writer: TGWM_HeadConstraintsWriter);
    function NumberOfHeads: integer;
  end;

  TGWM_Gradient = class(TObject)
    Layer1: integer;
    Row1: integer;
    Column1: integer;
    Layer2: integer;
    Row2: integer;
    Column2: integer;
    Name: string;
    Gradient: double;
    Length: double;
    StressPeriods: TStressPeriodArray;
    constructor Create;
    procedure Write(const Writer: TGWM_HeadConstraintsWriter);
    function NumberOfHeads: integer;
  end;

  TGWM_GradientList = class(TStringList)
  private
    function GetItems(const Index: integer): TGWM_Gradient;
    procedure SetItems(const Index: integer;
      const Value: TGWM_Gradient);
  public
    constructor Create;
    Destructor Destroy; override;
    function Add(Item: TGWM_Gradient): integer; reintroduce; overload;
    function Add(const Name: string; const Layer, Row,
      Column: integer; const Gradient, GradientLength: double; const First: boolean;
      const StressPeriods: TStressPeriodArray; const DuplicateErrors,
      GradientErrors, LengthErrors: TStringList):
      TGWM_Gradient; reintroduce; overload;
    property Items[const Index: integer]: TGWM_Gradient
      read GetItems write SetItems;
    procedure Write(const Writer: TGWM_HeadConstraintsWriter);
    function NumberOfHeads: integer;
  end;

  TGWM_HeadConstraintsWriter = class(TCustomGWM_Writer)
  private
    HeadCellList: TGWM_HeadOrDrawdownCellList;
    DrawdownCellList: TGWM_HeadOrDrawdownCellList;
    DifferenceCellList: TGWM_DifferenceCellList;
    GradientList: TGWM_GradientList;
    Procedure EvaluateHeadBoundConstraints;
    Procedure EvaluateDrawdownConstraints;
    Procedure EvaluateHeadDifferenceConstraints;
    Procedure EvaluateGradientConstraints;
    Procedure EvaluateHeadBoundConstraintsUnit(const UnitIndex: integer);
    Procedure EvaluateDrawdownConstraintsUnit(const UnitIndex: integer);
    Procedure EvaluateHeadDifferenceConstraintsUnit(const UnitIndex: integer;
      const DuplicateErrors, InvalidDifferencesErrors: TStringList);
    Procedure EvaluateGradientConstraintsUnit(const UnitIndex: integer;
      const DuplicateErrors, InvalidGradientErrors, LengthErrors: TStringList);
    Procedure EvaluateHeadOrDrawdownContour(const UnitIndex,
      ContourIndex: integer; const HeadConstraintsLayer: TLayerOptions;
      const LayerIndicies: THeadAndDrawdownIndicies;
      const TimeIndicies: TGWM_TimeIndicies; const ModflowLayers: TLayerArray;
      const CellList: TGWM_HeadOrDrawdownCellList; const ContourTypeErrors: TStringList);
    Procedure EvaluateHeadDifferenceContour(const UnitIndex,
      ContourIndex: integer; const HeadDifferenceLayer: TLayerOptions;
      const LayerIndicies: THeadDifferenceIndicies;
      const TimeIndicies: TGWM_TimeIndicies;const DuplicateErrors,
      InvalidDifferencesErrors, ContourTypeErrors: TStringList);
    Procedure EvaluateGradientContour(const UnitIndex,
      ContourIndex: integer; const GradientLayer: TLayerOptions;
      const LayerIndicies: TGradientIndicies;
      const TimeIndicies: TGWM_TimeIndicies;const DuplicateErrors,
      InvalidDifferencesErrors, LengthErrors, ContourTypeErrors: TStringList);
    procedure GetHeadConstraintIndicies(
      const HeadConstraintLayer: TLayerOptions;
      var HeadBoundaryIndicies: THeadAndDrawdownIndicies;
      var TimeIndicies:  TGWM_TimeIndicies);
    procedure GetDrawdownConstraintIndicies(
      const DrawdownConstrainLayer: TLayerOptions;
      var DrawdownIndicies: THeadAndDrawdownIndicies;
      var TimeIndicies:  TGWM_TimeIndicies);
    procedure GetHeadDifferentIndicies(const HeadDifferenceLayer: TLayerOptions;
      var HeadDifferenceIndicies: THeadDifferenceIndicies;
      var TimeIndicies:  TGWM_TimeIndicies);
    procedure GetGradientIndicies(const GradientLayer: TLayerOptions;
      var GradientIndicies: TGradientIndicies;
      var TimeIndicies:  TGWM_TimeIndicies);
    Procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure Evaluate;
    procedure AddIncorrectContourTypeMessage(const LayerName: string;
      const IncorrectContours: TStringList);
  public
    constructor Create;
    Destructor Destroy; override;
    Procedure WriteFile(const CurrentModelHandle: ANE_PTR; const Root: string;
      Discretization: TDiscretizationWriter);
  end;

implementation

uses Variables, ProgressUnit, GetCellUnit, PointInsideContourUnit,
  WriteNameFileUnit;

function ConvertName(Root: string; StressPeriodIndex: integer): string;
var
  StressPeriod: string;
begin
  StressPeriod := '_' + IntToStr(StressPeriodIndex + 1);
  result := Copy(Root, 1, 10-Length(StressPeriod)) + StressPeriod;
end;

{ TGWM_HeadConstraintsWriter }

constructor TGWM_HeadConstraintsWriter.Create;
begin
  inherited;
  HeadCellList:= TGWM_HeadOrDrawdownCellList.Create;
  DrawdownCellList:= TGWM_HeadOrDrawdownCellList.Create;
  DifferenceCellList := TGWM_DifferenceCellList.Create;
  GradientList:= TGWM_GradientList.Create;
end;

destructor TGWM_HeadConstraintsWriter.Destroy;
begin
  HeadCellList.Free;
  DrawdownCellList.Free;
  DifferenceCellList.Free;
  GradientList.Free;
  inherited;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateDrawdownConstraints;
var
  UnitIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      EvaluateDrawdownConstraintsUnit(UnitIndex);
    end;
  end;
end;

procedure TGWM_HeadConstraintsWriter.AddIncorrectContourTypeMessage(const
  LayerName: string; const IncorrectContours: TStringList);
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

procedure TGWM_HeadConstraintsWriter.EvaluateDrawdownConstraintsUnit(
  const UnitIndex: integer);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  DrawdownConstraintLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  DrawdownIndicies: THeadAndDrawdownIndicies;
  TimeIndicies:  TGWM_TimeIndicies;
  ModflowLayers: TLayerArray;
  ContourTypeErrors: TStringList;
//  ErrorMessage: string;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFDrawdownConstraintLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  ContourTypeErrors:= TStringList.Create;
  DrawdownConstraintLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := DrawdownConstraintLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetDrawdownConstraintIndicies(DrawdownConstraintLayer, DrawdownIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateHeadOrDrawdownContour(UnitIndex, ContourIndex,
          DrawdownConstraintLayer, DrawdownIndicies, TimeIndicies,
          ModflowLayers, DrawdownCellList, ContourTypeErrors);
      end;
    end;
    AddIncorrectContourTypeMessage(LayerName, ContourTypeErrors);
  finally
    DrawdownConstraintLayer.Free(CurrentModelHandle);
    ContourTypeErrors.Free;
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateGradientConstraints;
var
  UnitIndex: integer;
  DuplicateErrors, GradientErrors, LengthErrors{, ContourTypeErrors}: TStringList;
  ErrorString: string;
begin
  DuplicateErrors := TStringList.Create;
  GradientErrors := TStringList.Create;
  LengthErrors := TStringList.Create;
  try
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        EvaluateGradientConstraintsUnit(UnitIndex, DuplicateErrors,
          GradientErrors, LengthErrors);
      end;
    end;

    if DuplicateErrors.Count > 0 then
    begin
      ErrorString := 'Error calculating gradient constraints in GWM.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.AddStrings(DuplicateErrors);
    end;

    if GradientErrors.Count > 0 then
    begin
      ErrorString := 'Errors specifying gradient constraint values in GWM.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.AddStrings(GradientErrors);
    end;
    if LengthErrors.Count > 0 then
    begin
      ErrorString := 'Errors specifying gradient lengths in GWM.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.AddStrings(LengthErrors);
    end;

  finally
    DuplicateErrors.Free;
    GradientErrors.Free;
    LengthErrors.Free;
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateGradientConstraintsUnit(
  const UnitIndex: integer; const DuplicateErrors,
  InvalidGradientErrors, LengthErrors: TStringList);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  GradientLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  GradientIndicies: TGradientIndicies;
  TimeIndicies:  TGWM_TimeIndicies;
  ContourTypeErrors: TStringList;
begin
  LayerName := ModflowTypes.GetMFGradientLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  ContourTypeErrors:= TStringList.Create;
  GradientLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := GradientLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetGradientIndicies(GradientLayer, GradientIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateGradientContour(UnitIndex, ContourIndex,
          GradientLayer, GradientIndicies, TimeIndicies,
          DuplicateErrors, InvalidGradientErrors, LengthErrors,
          ContourTypeErrors);
      end;
    end;
    AddIncorrectContourTypeMessage(LayerName, ContourTypeErrors);
  finally
    ContourTypeErrors.Free;
    GradientLayer.Free(CurrentModelHandle);
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateGradientContour(
  const UnitIndex, ContourIndex: integer;
  const GradientLayer: TLayerOptions;
  const LayerIndicies: TGradientIndicies;
  const TimeIndicies: TGWM_TimeIndicies;const DuplicateErrors,
  InvalidDifferencesErrors, LengthErrors, ContourTypeErrors: TStringList);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  ContourName: string;
  GradientValue, Length: double;
  StartElevation, EndElevation: double;
  First: boolean;
  CellIndex {, ColIndex, RowIndex, LayerIndex, BlockIndex}: integer;
  Column, Row, Layer: integer;
  StressPeriodArray: TStressPeriodArray;
  TimeCount: integer;
  TimeIndex: integer;
  UnitTop, UnitBottom: double;
begin
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(StressPeriodArray, TimeCount);
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (CurrentModelHandle, GradientLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(CurrentModelHandle);
    ContourName := Contour.GetStringParameter(CurrentModelHandle,
      LayerIndicies.VariableNameIndex);
    if (ContourType = ctClosed) then
    begin
      ContourTypeErrors.Add(ContourName);
      Exit;
    end;
    if (CellCount = 0) then
    begin
      Exit;
    end;


    GradientValue := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.GradientValueIndex);
    Length := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.LengthIndex);
    StartElevation := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.StartElevationIndex);
    EndElevation := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.EndElevationIndex);
    First := Contour.GetBoolParameter(CurrentModelHandle,
      LayerIndicies.FirstIndex);

    for TimeIndex := 0 to TimeCount-1 do
    begin
      StressPeriodArray[TimeIndex] := Contour.GetBoolParameter(
        CurrentModelHandle, TimeIndicies[TimeIndex]);
    end;

    for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
    begin
      if not ContinueExport then
      begin
        break;
      end;

      if (CellIndex <> 0) and
        (CellIndex <> GGetCountOfACellList(ContourIndex) - 1) then
      begin
        Continue;
      end;

      if GGetCountOfACellList(ContourIndex) > 1 then
      begin
        First := True;
      end;

      if (CellIndex > 0) then
      begin
        First := False;
      end;

      Application.ProcessMessages;
      Row    := GGetCellRow(ContourIndex, CellIndex);
      Column := GGetCellColumn(ContourIndex, CellIndex);

      UnitTop := Discretization.Elevations[Column-1,Row-1,UnitIndex-1];
      UnitBottom := Discretization.Elevations[Column-1,Row-1,UnitIndex];
      if not First then
      begin
        Layer := frmMODFLOW.ModflowLayer(UnitIndex, UnitTop,
          UnitBottom, EndElevation);
      end
      else
      begin
        Layer := frmMODFLOW.ModflowLayer(UnitIndex, UnitTop,
          UnitBottom, StartElevation);
      end;


      GradientList.Add(ContourName, Layer, Row, Column,
        GradientValue, Length, First, StressPeriodArray, DuplicateErrors,
        InvalidDifferencesErrors, LengthErrors);
    end;
  finally
    Contour.Free;
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateHeadBoundConstraints;
var
  UnitIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      EvaluateHeadBoundConstraintsUnit(UnitIndex);
    end;
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateHeadBoundConstraintsUnit(
  const UnitIndex: integer);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  HeadConstraintLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  HeadBoundaryIndicies: THeadAndDrawdownIndicies;
  TimeIndicies:  TGWM_TimeIndicies;
  ModflowLayers: TLayerArray;
  ContourTypeErrors: TStringList;
begin
  GetLayers(UnitIndex, ModflowLayers);
  LayerName := ModflowTypes.GetMFHeadConstraintLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  ContourTypeErrors:= TStringList.Create;
  HeadConstraintLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := HeadConstraintLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetHeadConstraintIndicies(HeadConstraintLayer, HeadBoundaryIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateHeadOrDrawdownContour(UnitIndex, ContourIndex,
          HeadConstraintLayer, HeadBoundaryIndicies, TimeIndicies,
          ModflowLayers, HeadCellList, ContourTypeErrors);
      end;
    end;
    AddIncorrectContourTypeMessage(LayerName, ContourTypeErrors);
  finally
    ContourTypeErrors.Free;
    HeadConstraintLayer.Free(CurrentModelHandle);
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateHeadOrDrawdownContour(
  const UnitIndex, ContourIndex: integer;
  const HeadConstraintsLayer: TLayerOptions;
  const LayerIndicies: THeadAndDrawdownIndicies;
  const TimeIndicies: TGWM_TimeIndicies; const ModflowLayers: TLayerArray;
  const CellList: TGWM_HeadOrDrawdownCellList;
  const ContourTypeErrors: TStringList);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  ContourName, ConstraintType: string;
  CellIndex, LayerIndex: integer;
  Column, Row, Layer: integer;
  StressPeriodArray: TStressPeriodArray;
  TimeCount: integer;
  TimeIndex: integer;
  ConstraintValue: double;
begin
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(StressPeriodArray, TimeCount);
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (CurrentModelHandle, HeadConstraintsLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(CurrentModelHandle);
    ContourName := Contour.GetStringParameter(CurrentModelHandle,
      LayerIndicies.VariableNameIndex);
    if (ContourType <> ctPoint) or (CellCount = 0) then
    begin
      ContourTypeErrors.Add(ContourName);
      Exit;
    end;
    if (CellCount = 0) then
    begin
      Exit;
    end;

    ConstraintType := Contour.GetStringParameter(CurrentModelHandle,
      LayerIndicies.ConstraintTypeIndex);
    ConstraintValue := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.ConstraintValueIndex);

    for TimeIndex := 0 to TimeCount-1 do
    begin
      StressPeriodArray[TimeIndex] := Contour.GetBoolParameter(
        CurrentModelHandle, TimeIndicies[TimeIndex]);
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

      for LayerIndex := 0 to Length(ModflowLayers) - 1 do
      begin
        Layer := ModflowLayers[LayerIndex];
        CellList.Add(ContourName, ConstraintType, Layer, Row, Column,
          ConstraintValue, StressPeriodArray);
      end;
    end;
  finally
    Contour.Free;
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateHeadDifferenceConstraints;
var
  UnitIndex: integer;
  DuplicateErrors, InvalidDifferencesErrors: TStringList;
  ErrorString: string;
begin
  DuplicateErrors := TStringList.Create;
  InvalidDifferencesErrors := TStringList.Create;
  try
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        EvaluateHeadDifferenceConstraintsUnit(UnitIndex,
          DuplicateErrors, InvalidDifferencesErrors);
      end;
    end;

    if DuplicateErrors.Count > 0 then
    begin
      ErrorString := 'Error calculating head difference constraints in GWM.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.AddStrings(DuplicateErrors);
    end;

    if InvalidDifferencesErrors.Count > 0 then
    begin
      ErrorString := 'Errors specifying head difference constraint values in GWM.';
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorString);
      ErrorMessages.AddStrings(InvalidDifferencesErrors);
    end;
  finally
    DuplicateErrors.Free;
    InvalidDifferencesErrors.Free;
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateHeadDifferenceConstraintsUnit(
  const UnitIndex: integer; const DuplicateErrors,
  InvalidDifferencesErrors: TStringList);
var
  LayerName:     string;
  LayerHandle:   ANE_PTR;
  HeadDifferenceLayer:     TLayerOptions;
  ContourCount:  integer;
  ContourIndex:  integer;
  HeadDifferenceIndicies: THeadDifferenceIndicies;
  TimeIndicies:  TGWM_TimeIndicies;
  ContourTypeErrors: TStringList;
begin
  LayerName := ModflowTypes.GetMFHeadDifferenceLayerType.WriteNewRoot +
    IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);

  ContourTypeErrors:= TStringList.Create;
  HeadDifferenceLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := HeadDifferenceLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
    if ContourCount > 0 then
    begin
      GetHeadDifferentIndicies(HeadDifferenceLayer, HeadDifferenceIndicies,
        TimeIndicies);

      for ContourIndex := 0 to ContourCount - 1 do
      begin
        if not ContinueExport then
        begin
          break;
        end;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        EvaluateHeadDifferenceContour(UnitIndex, ContourIndex,
          HeadDifferenceLayer, HeadDifferenceIndicies, TimeIndicies,
          DuplicateErrors, InvalidDifferencesErrors, ContourTypeErrors);
        AddIncorrectContourTypeMessage(LayerName, ContourTypeErrors);
      end;
    end;
  finally
    ContourTypeErrors.Free;
    HeadDifferenceLayer.Free(CurrentModelHandle);
  end;
end;

procedure TGWM_HeadConstraintsWriter.EvaluateHeadDifferenceContour(
  const UnitIndex, ContourIndex: integer;
  const HeadDifferenceLayer: TLayerOptions;
  const LayerIndicies: THeadDifferenceIndicies;
  const TimeIndicies: TGWM_TimeIndicies; const DuplicateErrors,
  InvalidDifferencesErrors, ContourTypeErrors: TStringList);
var
  Contour: TContourObjectOptions;
  CellCount: integer;
  ContourType: TArgusContourType;
  ContourName: string;
  ConstraintValue: double;
  Elevation: double;
  First: boolean;
  CellIndex{, ColIndex, RowIndex, LayerIndex, BlockIndex}: integer;
  Column, Row, Layer: integer;
//  ABlock : TBlockObjectOptions;
//  X, Y: ANE_DOUBLE;
  StressPeriodArray: TStressPeriodArray;
  TimeCount: integer;
  TimeIndex: integer;
//  ACell: TGWM_HeadOrDrawdownCell;
  UnitTop, UnitBottom: double;
begin
  TimeCount := frmModflow.dgTime.RowCount - 1;
  SetLength(StressPeriodArray, TimeCount);
  CellCount := GGetCountOfACellList(ContourIndex);
  Contour   := TContourObjectOptions.Create
    (CurrentModelHandle, HeadDifferenceLayer.LayerHandle, ContourIndex);
  try
    ContourType := Contour.ContourType(CurrentModelHandle);
    ContourName := Contour.GetStringParameter(CurrentModelHandle,
      LayerIndicies.VariableNameIndex);
    if (ContourType = ctClosed) then
    begin
      ContourTypeErrors.Add(ContourName);
      Exit;
    end;
    if (CellCount = 0) then
    begin
      Exit;
    end;


    ConstraintValue := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.ConstraintValueIndex);
    Elevation := Contour.GetFloatParameter(CurrentModelHandle,
      LayerIndicies.ElevationIndex);
    First := Contour.GetBoolParameter(CurrentModelHandle,
      LayerIndicies.FirstIndex);

    for TimeIndex := 0 to TimeCount-1 do
    begin
      StressPeriodArray[TimeIndex] := Contour.GetBoolParameter(
        CurrentModelHandle, TimeIndicies[TimeIndex]);
    end;

    {case ContourType of
      ctPoint, ctOpen:
      begin }
        for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
        begin
          if not ContinueExport then
          begin
            break;
          end;

          if (CellIndex <> 0) and
            (CellIndex <> GGetCountOfACellList(ContourIndex) - 1) then
          begin
            Continue;
          end;

          if GGetCountOfACellList(ContourIndex) > 1 then
          begin
            First := True;
          end;

          if (CellIndex > 0) then
          begin
            First := False;
          end;

          Application.ProcessMessages;
          Row    := GGetCellRow(ContourIndex, CellIndex);
          Column := GGetCellColumn(ContourIndex, CellIndex);

          UnitTop := Discretization.Elevations[Column-1,Row-1,UnitIndex-1];
          UnitBottom := Discretization.Elevations[Column-1,Row-1,UnitIndex];
          Layer := frmMODFLOW.ModflowLayer(UnitIndex, UnitTop,
            UnitBottom, Elevation);

          DifferenceCellList.Add(ContourName, Layer, Row, Column,
            ConstraintValue, First, StressPeriodArray, DuplicateErrors,
            InvalidDifferencesErrors);
        end;
{      end;
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
              UnitTop := Discretization.Elevations[Column-1,Row-1,UnitIndex-1];
              UnitBottom := Discretization.Elevations[Column-1,Row-1,UnitIndex];
              Layer := frmMODFLOW.ModflowLayer(UnitIndex, UnitTop, UnitBottom,
                Elevation);
              DifferenceCellList.Add(ContourName, Layer, Row, Column,
                ConstraintValue, First, StressPeriodArray, DuplicateErrors,
                InvalidDifferencesErrors);
            end;
          end;
        end;
      end;
      else
      begin
        Assert(False);
      end;
    end;}
  finally
    Contour.Free;
  end;
end;

procedure TGWM_HeadConstraintsWriter.GetHeadConstraintIndicies(
  const HeadConstraintLayer: TLayerOptions;
  var HeadBoundaryIndicies: THeadAndDrawdownIndicies;
  var TimeIndicies: TGWM_TimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFHeadConstraintNameParamType.ANE_ParamName;
  HeadBoundaryIndicies.VariableNameIndex :=
    HeadConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadBoundaryIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFHeadConstraintTypeParamType.ANE_ParamName;
  HeadBoundaryIndicies.ConstraintTypeIndex :=
    HeadConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadBoundaryIndicies.ConstraintTypeIndex >= 0);

  Name := ModflowTypes.GetMFHeadConstraintBoundaryParamType.ANE_ParamName;
  HeadBoundaryIndicies.ConstraintValueIndex :=
    HeadConstraintLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadBoundaryIndicies.ConstraintValueIndex >= 0);

  GetTimeIndicies(HeadConstraintLayer, TimeIndicies);
end;

procedure TGWM_HeadConstraintsWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; const Root: string;
  Discretization: TDiscretizationWriter);
var
  FileName: string;
begin
  self.Discretization     := Discretization;
  self.CurrentModelHandle := CurrentModelHandle;
  frmProgress.pbPackage.Max := Discretization.NUNITS;
  frmProgress.lblPackage.Caption := 'GWM Head Constraints';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;
  if ContinueExport then
  begin
    Evaluate;
    if ContinueExport then
    begin
      FileName := GetCurrentDir + '\' + Root + rsHEDCON;
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
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 5';
          WriteDataSet5;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 5';
          WriteDataSet6;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
      finally
        CloseFile(FFile);
      end;
    end;
    Application.ProcessMessages;
  end;
end;

procedure TGWM_HeadConstraintsWriter.GetDrawdownConstraintIndicies(
  const DrawdownConstrainLayer: TLayerOptions;
  var DrawdownIndicies: THeadAndDrawdownIndicies;
  var TimeIndicies: TGWM_TimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFDrawdownConstraintNameParamType.ANE_ParamName;
  DrawdownIndicies.VariableNameIndex :=
    DrawdownConstrainLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(DrawdownIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFDrawdownConstraintTypeParamType.ANE_ParamName;
  DrawdownIndicies.ConstraintTypeIndex :=
    DrawdownConstrainLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(DrawdownIndicies.ConstraintTypeIndex >= 0);

  Name := ModflowTypes.GetMFHeadConstraintBoundaryParamType.ANE_ParamName;
  DrawdownIndicies.ConstraintValueIndex :=
    DrawdownConstrainLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(DrawdownIndicies.ConstraintValueIndex >= 0);

  GetTimeIndicies(DrawdownConstrainLayer, TimeIndicies);
end;

procedure TGWM_HeadConstraintsWriter.GetHeadDifferentIndicies(
  const HeadDifferenceLayer: TLayerOptions;
  var HeadDifferenceIndicies: THeadDifferenceIndicies;
  var TimeIndicies: TGWM_TimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFHeadDifferenceNameParamType.ANE_ParamName;
  HeadDifferenceIndicies.VariableNameIndex :=
    HeadDifferenceLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadDifferenceIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFHeadDifferenceValueParamType.ANE_ParamName;
  HeadDifferenceIndicies.ConstraintValueIndex :=
    HeadDifferenceLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadDifferenceIndicies.ConstraintValueIndex >= 0);

  Name := ModflowTypes.GetMFElevationParamType.ANE_ParamName;
  HeadDifferenceIndicies.ElevationIndex :=
    HeadDifferenceLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadDifferenceIndicies.ElevationIndex >= 0);

  Name := ModflowTypes.GetMFFirstParamType.ANE_ParamName;
  HeadDifferenceIndicies.FirstIndex :=
    HeadDifferenceLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(HeadDifferenceIndicies.FirstIndex >= 0);

  GetTimeIndicies(HeadDifferenceLayer, TimeIndicies);
end;

procedure TGWM_HeadConstraintsWriter.GetGradientIndicies(
  const GradientLayer: TLayerOptions;
  var GradientIndicies: TGradientIndicies;
  var TimeIndicies: TGWM_TimeIndicies);
var
  Name: string;
begin
  Name := ModflowTypes.GetMFGradientNameParamType.ANE_ParamName;
  GradientIndicies.VariableNameIndex :=
    GradientLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(GradientIndicies.VariableNameIndex >= 0);

  Name := ModflowTypes.GetMFGradientValueParamType.ANE_ParamName;
  GradientIndicies.GradientValueIndex :=
    GradientLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(GradientIndicies.GradientValueIndex >= 0);

  Name := ModflowTypes.GetMFGradientLengthParamType.ANE_ParamName;
  GradientIndicies.LengthIndex :=
    GradientLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(GradientIndicies.LengthIndex >= 0);

  Name := ModflowTypes.GetMFGradientStartElevationParamType.ANE_ParamName;
  GradientIndicies.StartElevationIndex :=
    GradientLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(GradientIndicies.StartElevationIndex >= 0);

  Name := ModflowTypes.GetMFGradientEndElevationParamType.ANE_ParamName;
  GradientIndicies.EndElevationIndex :=
    GradientLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(GradientIndicies.EndElevationIndex >= 0);

  Name := ModflowTypes.GetMFFirstParamType.ANE_ParamName;
  GradientIndicies.FirstIndex :=
    GradientLayer.GetParameterIndex(CurrentModelHandle, Name);
  Assert(GradientIndicies.FirstIndex >= 0);

  GetTimeIndicies(GradientLayer, TimeIndicies);
end;

procedure TGWM_HeadConstraintsWriter.WriteDataSet1;
const
  IPRN = 1;
begin
  WriteLn(FFile, IPRN);
end;

procedure TGWM_HeadConstraintsWriter.WriteDataSet2;
var
  NHB, NDD, NDF, NGD: integer;
begin
  NHB := HeadCellList.NumberOfHeads;
  NDD := DrawdownCellList.NumberOfHeads;
  NDF := DifferenceCellList.NumberOfHeads;
  NGD := GradientList.NumberOfHeads;
  writeLn(FFile, NHB, ' ', NDD, ' ', NDF, ' ', NGD);
end;

procedure TGWM_HeadConstraintsWriter.WriteDataSet3;
begin
  HeadCellList.Write(self);
end;

procedure TGWM_HeadConstraintsWriter.WriteDataSet4;
begin
  DrawdownCellList.Write(self);
end;

procedure TGWM_HeadConstraintsWriter.WriteDataSet5;
begin
  DifferenceCellList.Write(self);
end;

procedure TGWM_HeadConstraintsWriter.WriteDataSet6;
begin
  GradientList.Write(self);
end;

procedure TGWM_HeadConstraintsWriter.Evaluate;
begin
  EvaluateHeadBoundConstraints;
  EvaluateDrawdownConstraints;
  EvaluateHeadDifferenceConstraints;
  EvaluateGradientConstraints;
end;

{ TNameCountList }

function TNameCountList.Add(const S: string): Integer;
var
  ACount: integer;
  Position: integer;
  AName: string;
begin
  AName := UpperCase(S);
  Position := IndexOf(AName);
  if Position < 0 then
  begin
    Position := inherited Add(AName);
    Objects[Position] := TObject(1);
    result := 1;
  end
  else
  begin
    ACount := integer(Objects[Position]);
    Inc(ACount);
    Objects[Position] := TObject(ACount);
    result := ACount;
  end;
end;

constructor TNameCountList.Create;
begin
  inherited;
  Sorted := True;
end;

function TNameCountList.NewName(AName: string): string;
var
  Root: string;
  ACount: integer;
begin
  result := AName;
  If Length(result) > 10 then
  begin
    SetLength(result, 10);
  end;
  Root := result;
  ACount := Add(result);
  if ACount > 1 then
  begin
    result := result + IntToStr(ACount);
    while Length(result) > 10 do
    begin
      result := Root;
      SetLength(result, Length(result) -1);
      Root := result;
      ACount := Add(result);
      result := result + IntToStr(ACount);
    end;
  end;
end;

{ TGWM_HeadOrDrawdownCellList }

function TGWM_HeadOrDrawdownCellList.Add(
  Item: TGWM_HeadOrDrawdownCell): integer;
begin
  result := inherited Add(Item);
end;

function TGWM_HeadOrDrawdownCellList.Add(const Name,
  ConstraintType: string; const Layer, Row, Column: integer;
  const Bound: double; const StressPeriods: TStressPeriodArray): TGWM_HeadOrDrawdownCell;
begin
  result:= TGWM_HeadOrDrawdownCell.Create;
  result.Layer := Layer;
  result.Row := Row;
  result.Column := Column;
  result.Name := NameCountList.NewName(Name);;
  result.ConstraintType := ConstraintType;
  result.BND := Bound;
  result.StressPeriods := StressPeriods;
  Add(result);
end;

constructor TGWM_HeadOrDrawdownCellList.Create;
begin
  inherited;
  NameCountList:= TNameCountList.Create;
end;

destructor TGWM_HeadOrDrawdownCellList.Destroy;
begin
  NameCountList.Free;
  inherited;
end;

function TGWM_HeadOrDrawdownCellList.GetItems(
  const Index: integer): TGWM_HeadOrDrawdownCell;
begin
  result := inherited Items[Index] as TGWM_HeadOrDrawdownCell;
end;

function TGWM_HeadOrDrawdownCellList.NumberOfHeads: integer;
var
  Index: integer;
  Item: TGWM_HeadOrDrawdownCell;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    result := result + Item.NumberOfHeads;
  end;
end;

procedure TGWM_HeadOrDrawdownCellList.SetItems(const Index: integer;
  const Value: TGWM_HeadOrDrawdownCell);
begin
  inherited Items[Index] := Value;
end;

procedure TGWM_HeadOrDrawdownCellList.Write(
  const Writer: TGWM_HeadConstraintsWriter);
var
  Index: integer;
  Item: TGWM_HeadOrDrawdownCell;
begin
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    Item.Write(Writer);
  end;
end;

{ TGWM_CellDifference }

constructor TGWM_CellDifference.Create;
begin
  inherited;
  Layer1 := 0;
  Row1 := 0;
  Column1 := 0;
  Layer2 := 0;
  Row2 := 0;
  Column2 := 0;
end;

function TGWM_CellDifference.NumberOfHeads: integer;
var
  Index: integer;
begin
  result := 0;
  for Index := 0 to Length(StressPeriods) -1 do
  begin
    if StressPeriods[Index] then
    begin
      Inc(result);
    end;
  end;
end;

procedure TGWM_CellDifference.Write(
  const Writer: TGWM_HeadConstraintsWriter);
var
  Index: integer;
  ExportedName: string;
begin
  for Index := 0 to Length(StressPeriods) -1 do
  begin
    if StressPeriods[Index] then
    begin
      ExportedName := ConvertName(Name, Index);
      WriteLn(Writer.FFile, ExportedName, ' ', Layer1, ' ', Row1, ' ', Column1, ' ',
        Layer2, ' ', Row2, ' ', Column2, ' ', Difference, ' ',
        Index + 1);
    end;
  end;
//  WriteLn(Writer.FFile, Name, ' ', Layer1, ' ', Row1, ' ', Column1, ' ',
//    Layer2, ' ', Row2, ' ', Column2, ' ', Difference, ' ',
//    EvaluateStressPeriods(StressPeriods));
end;

{ TGWM_DifferenceCellList }

function TGWM_DifferenceCellList.Add(Item: TGWM_CellDifference): integer;
begin
  result := inherited AddObject(UpperCase(Item.Name), Item);
end;

function TGWM_DifferenceCellList.Add(const Name: string; const Layer, Row,
  Column: integer; const Difference: double; const First: boolean;
  const StressPeriods: TStressPeriodArray; const DuplicateErrors,
  InvalidDifferencesErrors: TStringList): TGWM_CellDifference;
var
  Position: integer;
begin
  Position := IndexOf(UpperCase(Name));
  if Position >= 0 then
  begin
    result := Items[Position];
    if First then
    begin
      if result.Layer1 <> 0 then
      begin
        DuplicateErrors.Add(
          'duplicated names used for "first" cells (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(Layer) + ', '
          + IntToStr(Row) + ', '
          + IntToStr(Column) + ')')
      end;
      result.Layer1 := Layer;
      result.Row1 := Row;
      result.Column1 := Column;
      result.StressPeriods := StressPeriods;
      if result.Difference <> Difference then
      begin
        InvalidDifferencesErrors.Add(
          'Cell differences not specified consistently (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + ')')
      end;
    end
    else
    begin
      if result.Layer2 <> 0 then
      begin
        DuplicateErrors.Add(
          'duplicated names used for "second" cells (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + '); '
          + IntToStr(Layer) + ', '
          + IntToStr(Row) + ', '
          + IntToStr(Column) + ')')
      end;
      result.Layer2 := Layer;
      result.Row2 := Row;
      result.Column2 := Column;
      if result.Difference <> Difference then
      begin
        InvalidDifferencesErrors.Add(
          'Cell differences not specified consistently (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + ')')
      end;
    end;
  end
  else
  begin
    result := TGWM_CellDifference.Create;
    result.Name := Name;
    if First then
    begin
      result.Layer1 := Layer;
      result.Row1 := Row;
      result.Column1 := Column;
      result.StressPeriods := StressPeriods;
    end
    else
    begin
      result.Layer2 := Layer;
      result.Row2 := Row;
      result.Column2 := Column;
    end;
    result.Difference := Difference;
    Add(Result);
  end;
end;

constructor TGWM_DifferenceCellList.Create;
begin
  inherited;
  Sorted := True;
end;

destructor TGWM_DifferenceCellList.Destroy;
var
  Index: integer;
begin
  for Index := 0 to Count -1 do
  begin
    Objects[Index].Free;
  end;
  inherited;
end;

function TGWM_DifferenceCellList.GetItems(
  const Index: integer): TGWM_CellDifference;
begin
  result := Objects[Index] as TGWM_CellDifference;
end;

function TGWM_DifferenceCellList.NumberOfHeads: integer;
var
  Index: integer;
  Item: TGWM_CellDifference;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    result := result + Item.NumberOfHeads;
  end;
end;

procedure TGWM_DifferenceCellList.SetItems(const Index: integer;
  const Value: TGWM_CellDifference);
begin
  Objects[Index] := Value;
end;

procedure TGWM_DifferenceCellList.Write(
  const Writer: TGWM_HeadConstraintsWriter);
var
  Index: integer;
  Item: TGWM_CellDifference;
begin
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    Item.Write(Writer);
  end;
end;

{ TGWM_Gradient }

constructor TGWM_Gradient.Create;
begin
  inherited;
  Layer1 := 0;
  Row1 := 0;
  Column1 := 0;
  Layer2 := 0;
  Row2 := 0;
  Column2 := 0;
end;

function TGWM_Gradient.NumberOfHeads: integer;
var
  Index: integer;

begin
  result := 0;
  for Index := 0 to System.Length(StressPeriods) -1 do
  begin
    if StressPeriods[Index] then
    begin
      Inc(result);
    end;
  end;
end;

procedure TGWM_Gradient.Write(const Writer: TGWM_HeadConstraintsWriter);
var
  Index: integer;
  ExportedName: string;
begin
  for Index := 0 to System.Length(StressPeriods)-1 do
  begin
    if StressPeriods[Index] then
    begin
      ExportedName := ConvertName(Name, Index);
      WriteLn(Writer.FFile, ExportedName, ' ', Layer1, ' ', Row1, ' ', Column1, ' ',
        Layer2, ' ', Row2, ' ', Column2, ' ', Length, ' ', Gradient, ' ',
        Index+1);
    end;

  end;
//  WriteLn(Writer.FFile, Name, ' ', Layer1, ' ', Row1, ' ', Column1, ' ',
//    Layer2, ' ', Row2, ' ', Column2, ' ', Length, ' ', Gradient, ' ',
//    EvaluateStressPeriods(StressPeriods));
end;

{ TGWM_GradientList }

function TGWM_GradientList.Add(const Name: string; const Layer, Row,
  Column: integer; const Gradient, GradientLength: double; const First: boolean;
  const StressPeriods: TStressPeriodArray; const DuplicateErrors,
  GradientErrors, LengthErrors: TStringList): TGWM_Gradient;
var
  Position: integer;
begin
  Position := IndexOf(UpperCase(Name));
  if Position >= 0 then
  begin
    result := Items[Position];
    if First then
    begin
      if result.Layer1 <> 0 then
      begin
        DuplicateErrors.Add(
          'duplicated names used for "first" cells (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(Layer) + ', '
          + IntToStr(Row) + ', '
          + IntToStr(Column) + ')')
      end;
      result.Layer1 := Layer;
      result.Row1 := Row;
      result.Column1 := Column;
      result.StressPeriods := StressPeriods;
      if result.Gradient <> Gradient then
      begin
        GradientErrors.Add(
          'Gradient not specified consistently (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + ')')
      end;
      if result.Length <> GradientLength then
      begin
        LengthErrors.Add(
          'Gradient lengths not specified consistently (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + ')')
      end;
    end
    else
    begin
      if result.Layer2 <> 0 then
      begin
        DuplicateErrors.Add(
          'duplicated names used for "second" cells (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + '); '
          + IntToStr(Layer) + ', '
          + IntToStr(Row) + ', '
          + IntToStr(Column) + ')')
      end;
      result.Layer2 := Layer;
      result.Row2 := Row;
      result.Column2 := Column;
      if result.Gradient <> Gradient then
      begin
        GradientErrors.Add(
          'Gradient not specified consistently (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + ')')
      end;
      if result.Length <> GradientLength then
      begin
        LengthErrors.Add(
          'Gradient lengths not specified consistently (L,R,C); (L,R,C): ('
          + IntToStr(result.Layer1) + ', '
          + IntToStr(result.Row1) + ', '
          + IntToStr(result.Column1) + '); '
          + IntToStr(result.Layer2) + ', '
          + IntToStr(result.Row2) + ', '
          + IntToStr(result.Column2) + ')')
      end;
    end;
  end
  else
  begin
    result := TGWM_Gradient.Create;
    result.Name := Name;
    if First then
    begin
      result.Layer1 := Layer;
      result.Row1 := Row;
      result.Column1 := Column;
      result.StressPeriods := StressPeriods;
    end
    else
    begin
      result.Layer2 := Layer;
      result.Row2 := Row;
      result.Column2 := Column;
    end;
    result.Gradient := Gradient;
    result.Length := GradientLength;
    Add(Result);
  end;
end;

function TGWM_GradientList.Add(Item: TGWM_Gradient): integer;
begin
  result := inherited AddObject(UpperCase(Item.Name), Item);
end;

constructor TGWM_GradientList.Create;
begin
  inherited;
  Sorted := True;
end;

destructor TGWM_GradientList.Destroy;
var
  Index: integer;
begin
  for Index := 0 to Count -1 do
  begin
    Objects[Index].Free;
  end;
  inherited;
end;

function TGWM_GradientList.GetItems(const Index: integer): TGWM_Gradient;
begin
  result := Objects[Index] as TGWM_Gradient
end;

function TGWM_GradientList.NumberOfHeads: integer;
var
  Index: integer;
  Item: TGWM_Gradient;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    result := result + Item.NumberOfHeads;
  end;
end;

procedure TGWM_GradientList.SetItems(const Index: integer;
  const Value: TGWM_Gradient);
begin
  Objects[Index] := Value;
end;

procedure TGWM_GradientList.Write(
  const Writer: TGWM_HeadConstraintsWriter);
var
  Index: integer;
  Item: TGWM_Gradient;
begin
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    Item.Write(Writer);
  end;
end;

{ TGWM_HeadOrDrawdownCell }

function TGWM_HeadOrDrawdownCell.NumberOfHeads: integer;
var
  Index: integer;
begin
  result := 0;
  for Index := 0 to Length(StressPeriods) -1 do
  begin
    if StressPeriods[Index] then
    begin
      Inc(result);
    end;
  end;
end;

procedure TGWM_HeadOrDrawdownCell.Write(
  const Writer: TGWM_HeadConstraintsWriter);
var
  Index: integer;
  ExportedName: string;
begin
  for Index := 0 to Length(StressPeriods) -1 do
  begin
    if StressPeriods[Index] then
    begin
      ExportedName := ConvertName(Name, Index);
      WriteLn(Writer.FFile, ExportedName, ' ', Layer, ' ', Row, ' ', Column, ' ',
        ConstraintType, ' ', BND, ' ', Index + 1);
    end;
  end;
end;

end.
