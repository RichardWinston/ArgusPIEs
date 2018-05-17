unit WriteDrainUnit;

interface

uses Sysutils, Classes, contnrs, Forms, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit;

type
  TDrainRecord = record
    Layer, Row, Column : integer;
    Elevation, CondFact : double;
    IFACE : integer;
    CellGroupNumber : integer;
    BottomElevation: double;
  end;

  TDrain = class;

  TDrainList = Class(TObjectList)
  private
    function Add(ADrain : TDrainRecord) : integer; overload;
    function GetDrainByLocation(Layer, Row, Column: integer): TDrain;
    procedure Sort;
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  private
    procedure FillBoundaryList(Layer, Row, Column: integer;
      BoundaryList : TObjectList);
  end;

  TDrainParamValue = Class(TObject)
  private
    Value : double;
    StressPeriodsUsed: Array of boolean;
    InstanceNamesUsed: array of string;
    DrainList : TDrainList;
    Instances : TStringList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  TDrainPkgWriter = class(TCustomBoundaryWriterWithObservations)
  private
    ParameterNames : TStringList;
    DrainTimes : TList;
    MXL : integer;
    ITMP, NP : integer;
    PointErrors, LineErrors, AreaErrors: integer;
    Procedure AddParameterNameCell(ParameterName : string;
      ADrainRecord : TDrainRecord; Const Instance : integer);
    Procedure AddParameterName(RowIndex : integer);
    procedure EvaluateDataSets6and7(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(var IsParamIndex, ParamNameIndex,
      ConductanceIndex, ElevationIndex, CellGroupNumberIndex,
      BottomElevIndex: ANE_INT16; var IsParamName, ParamName,
      ConductanceName, ElevationName, CellGroupName, BottomElevName: string;
      const CurrentModelHandle: ANE_PTR; DrainLayer : TLayerOptions;
      const PointLayer: boolean);
    procedure AddParameterNames;
    procedure EvaluatePointDrainLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization : TDiscretizationWriter);
    procedure EvaluateLineDrainLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaDrainLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3And4;
    procedure WriteDatasets5To7;
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    procedure WriteDataSet7(StressPeriodIndex : integer);
    procedure SortDrains;
    function GetParameterInstanceCount(
      const ParameterName: string): integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    function BoundaryUsed(Layer, Row, Column : integer) : boolean; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure FillBoundaryList(Layer, Row, Column: integer;
      BoundaryList: TObjectList); override;
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines : TStrings);
    class procedure AssignUnitNumbers;
  end;

  TDrain = Class(TObject)
  private
    Drain : TDrainRecord;
    procedure WriteDrain(DrainWriter : TDrainPkgWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;


implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

function DrainSortFunction(Item1, Item2: Pointer): Integer;
var
  Drain1, Drain2 : TDrain;
begin
  Drain1 := Item1;
  Drain2 := Item2;
  result := Drain1.Drain.Layer - Drain2.Drain.Layer;
  if Result <> 0 then Exit;
  result := Drain1.Drain.Row - Drain2.Drain.Row;
  if Result <> 0 then Exit;
  result := Drain1.Drain.Column - Drain2.Drain.Column;
end;

{ TDrainPkgWriter }

procedure TDrainPkgWriter.AddParameterNameCell(ParameterName : string;
      ADrainRecord : TDrainRecord; Const Instance : integer);
var
  ParamIndex : integer;
  AParamValue : TDrainParamValue;
  DrainList : TDrainList;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Drain package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
    if AParamValue.Instances.Count > 0 then
    begin
      DrainList := AParamValue.Instances.Objects[Instance] as TDrainList;
    end
    else
    begin
      DrainList := AParamValue.DrainList;
    end;
    DrainList.Add(ADrainRecord);
//    AParamValue.DrainList.Add(ADrainRecord);
  end;
end;


procedure TDrainPkgWriter.GetParamIndicies(var IsParamIndex, ParamNameIndex,
  ConductanceIndex, ElevationIndex, CellGroupNumberIndex,
  BottomElevIndex: ANE_INT16; var IsParamName, ParamName,
  ConductanceName, ElevationName, CellGroupName, BottomElevName: string; const
  CurrentModelHandle: ANE_PTR; DrainLayer : TLayerOptions; const PointLayer: boolean);
begin
  IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
  IsParamIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

  ParamName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  ParamNameIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  if PointLayer or frmModflow.cbCondDrn.Checked then
  begin
    ConductanceName := ModflowTypes.GetMFDrainConductanceParamType.WriteParamName;
  end
  else
  begin
    ConductanceName := ModflowTypes.GetMFDrainConductanceParamType.WriteFactorName;
  end;
  ConductanceIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, ConductanceName);

  ElevationName := ModflowTypes.GetMFDrainElevationParamType.WriteParamName;
  ElevationIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, ElevationName);

  CellGroupName := ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName;
  CellGroupNumberIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, CellGroupName);

  if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
  begin
    BottomElevName := ModflowTypes.GetMFDrainBottomElevParamType.WriteParamName;
    BottomElevIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, BottomElevName);
  end
  else
  begin
    BottomElevName := '';
    BottomElevIndex := -1;
  end;

end;

function TDrainPkgWriter.GetParameterInstanceCount(const ParameterName : string) : integer;
var
  ParamIndex : integer;
  AParamValue : TDrainParamValue;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    result := -1;
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Drain package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
    result := AParamValue.Instances.Count;
    if result = 0 then
    begin
      result := 1;
    end
  end;
end;

procedure TDrainPkgWriter.EvaluatePointDrainLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  DrainLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  ElevationIndex : ANE_INT16;
  CellGroupNumberIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ADrain : TDrainRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  DrainList : TDrainList;
  IsParamName, ParamName, ConductanceName, ElevationName, CellGroupName: string;
  Used : boolean;
  DrainErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
  BottomElevIndex: ANE_INT16;
  BottomName: string;
begin
  // point drains
  InstanceLimit := 0;
  DrainErrors := TStringList.Create;
  try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboDrnSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(IsOnIndicies,StressPeriodCount);
    if ModflowTypes.GetMFPointDrainLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;

    LayerName := ModflowTypes.GetMFPointDrainLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    DrainLayer := TLayerOptions.Create(LayerHandle);
    try
      ContourCount := DrainLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          ConductanceIndex, ElevationIndex, CellGroupNumberIndex,
          BottomElevIndex, IsParamName,
          ParamName, ConductanceName, ElevationName, CellGroupName, BottomName,
          CurrentModelHandle, DrainLayer, True);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFDrainOnParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if ModflowTypes.GetMFPointDrainLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACEIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end;
        end;


        frmProgress.pbActivity.Max := ContourCount;
        for ContourIndex := 0 to ContourCount -1 do
        begin
          frmProgress.pbActivity.StepIt;
          if not ContinueExport then break;
          Application.ProcessMessages;
          Contour := TContourObjectOptions.Create
            (CurrentModelHandle,LayerHandle,ContourIndex);
          try
            if Contour.NumberOfNodes(CurrentModelHandle) <> 1 then
            begin
              Inc(PointErrors);
            end
            else
            begin
              if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
              begin
                ADrain.BottomElevation := Contour.
                  GetFloatParameter(CurrentModelHandle, BottomElevIndex);
              end
              else
              begin
                ADrain.BottomElevation := 0;
              end;

              IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
              if IsParam then
              begin
                ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                InstanceLimit := GetParameterInstanceCount(ParameterName);
              end;

              ADrain.CondFact := Contour.GetFloatParameter(CurrentModelHandle,ConductanceIndex);
              Conductance := ADrain.CondFact;
              ADrain.Elevation := Contour.GetFloatParameter(CurrentModelHandle,ElevationIndex);
              ADrain.CellGroupNumber  := Contour.GetIntegerParameter(CurrentModelHandle,CellGroupNumberIndex);

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                ADrain.Row := GGetCellRow(ContourIndex, CellIndex);
                ADrain.Column := GGetCellColumn(ContourIndex, CellIndex);
                Top := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex-1];
                Bottom := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex];
                if ShowWarnings then
                begin
                  if ADrain.Elevation > Top then
                  begin
                    DrainErrors.Add(Format
                      ('[%d, %d] Elevation > top of unit', [ADrain.Row, ADrain.Column]));
                  end;
                  if ADrain.Elevation < Bottom then
                  begin
                    DrainErrors.Add(Format
                      ('[%d, %d] Elevation < bottom of unit', [ADrain.Row, ADrain.Column]));
                  end;
                end;
                ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                if IsParam then
                begin
                  for StressPeriodIndex := 0 to InstanceLimit-1 do
                  begin
                    Used := Contour.
                      GetFloatParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]) <> 0;
                    if Used then
                    begin
                      ADrain.CondFact := Conductance;
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                    end;
                    if ModflowTypes.GetMFPointDrainLayerType.UseIFACE then
                    begin
                      ADrain.IFACE := Contour.GetIntegerParameter
                        (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                    end;
                    AddParameterNameCell(ParameterName,ADrain, StressPeriodIndex);
                  end;
                end
                else
                begin
                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    Used := Contour.GetFloatParameter(CurrentModelHandle,
                      IsOnIndicies[StressPeriodIndex]) <> 0;
                    if Used then
                    begin
                      if ModflowTypes.GetMFPointDrainLayerType.UseIFACE then
                      begin
                        ADrain.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end;
                      DrainList := DrainTimes[StressPeriodIndex];
                      DrainList.Add(ADrain);
                    end;
                  end;
                end;
              end;
            end;
          finally
            Contour.Free;
          end;

        end;
      end;
    finally
      DrainLayer.Free(CurrentModelHandle);
    end;
    if DrainErrors.Count > 0 then
    begin
      AString := 'Warning: Some point drains extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Drains below the bottom of the unit will be placed in '
        + 'the bottom layer of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := 'Drains above the top of the unit will be placed in '
        + 'the top layer of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(DrainErrors);
    end;
  finally
    DrainErrors.Free;
  end;
end;

procedure TDrainPkgWriter.EvaluateLineDrainLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  DrainLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  ElevationIndex : ANE_INT16;
  CellGroupNumberIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ADrain : TDrainRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  DrainList : TDrainList;
  ContourConductance : double;
  ContourLength : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, ElevationName, CellGroupName: string;
//  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  Used : boolean;
  DrainErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
  BottomElevIndex: ANE_INT16;
  BottomName: string;
begin
  // line drains
  ContourConductance := 0;
  IsParam := False;
  DrainErrors := TStringList.Create;
  try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboDrnSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(IsOnIndicies,StressPeriodCount);
    if ModflowTypes.GetLineDrainLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;

    LayerName := ModflowTypes.GetLineDrainLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    DrainLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  //  ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    try
      ContourCount := DrainLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          ConductanceIndex, ElevationIndex, CellGroupNumberIndex,
          BottomElevIndex, IsParamName,
          ParamName, ConductanceName, ElevationName, CellGroupName, BottomName,
          CurrentModelHandle, DrainLayer, False);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFDrainOnParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if ModflowTypes.GetLineDrainLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACENames.Add(TimeParamName);
            IFACEIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; //  if ModflowTypes.GetLineDrainLayerType.UseIFACE then
        end; // for TimeIndex := 1 to StressPeriodCount do

        frmProgress.pbActivity.Max := ContourCount;
        for ContourIndex := 0 to ContourCount -1 do
        begin
          if not ContinueExport then break;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          Contour := TContourObjectOptions.Create
            (CurrentModelHandle,LayerHandle,ContourIndex);
          try
            if Contour.ContourType(CurrentModelHandle) <> ctOpen then
            begin
              Inc(LineErrors);
            end
            else
            begin
              if not frmMODFLOW.cbAltDrn.Checked then
              begin
                ContourConductance := Contour.GetFloatParameter
                  (CurrentModelHandle,ConductanceIndex);
                ADrain.Elevation := Contour.GetFloatParameter
                  (CurrentModelHandle,ElevationIndex);
                IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
                if IsParam then
                begin
                  ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                  InstanceLimit := GetParameterInstanceCount(ParameterName);
                end; // if IsParam then
                ADrain.CellGroupNumber := Contour.GetIntegerParameter
                  (CurrentModelHandle,CellGroupNumberIndex);
                if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
                begin
                  ADrain.BottomElevation := Contour.GetFloatParameter
                    (CurrentModelHandle,BottomElevIndex);
                end
                else
                begin
                  ADrain.BottomElevation := 0;
                end;
              end; // if not frmMODFLOW.cbAltDrn.Checked then

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                ADrain.Row := GGetCellRow(ContourIndex, CellIndex);
                ADrain.Column := GGetCellColumn(ContourIndex, CellIndex);
                ContourLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);
                Top := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex-1];
                Bottom := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex];
                if frmMODFLOW.cbAltDrn.Checked then
                begin
                  BlockIndex := Discretization.BlockIndex(ADrain.Row-1,ADrain.Column-1);
                  ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                    Discretization.GridLayerHandle, BlockIndex);
                  try
                    ABlock.GetCenter(CurrentModelHandle, X, Y);
                  finally
                    ABlock.Free;
                  end;
                  ContourConductance := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + ConductanceName);
                  if frmModflow.cbCondDrn.Checked then
                  begin
                    ADrain.CondFact := ContourConductance;
                  end
                  else
                  begin
                    ADrain.CondFact := ContourConductance*ContourLength;
                  end;
                  Conductance := ADrain.CondFact;
                  IsParam := GridLayer.BooleanValueAtXY(CurrentModelHandle,
                    X, Y, LayerName + '.' + IsParamName);
                  if IsParam then
                  begin
                    ParameterName := GridLayer.StringValueAtXY(CurrentModelHandle,
                      X, Y, LayerName + '.' + ParamName);
                    InstanceLimit := GetParameterInstanceCount(ParameterName);
                  end; // if IsParam then
                  ADrain.CellGroupNumber := GridLayer.IntegerValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + CellGroupName);
                  if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
                  begin
                    ADrain.BottomElevation := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + BottomName);
                  end
                  else
                  begin
                    ADrain.BottomElevation := 0;
                  end;
                end
                else // if frmMODFLOW.cbAltDrn.Checked then
                begin
                  if frmModflow.cbCondDrn.Checked then
                  begin
                    ADrain.CondFact := ContourConductance;
                  end
                  else
                  begin
                    ADrain.CondFact := ContourConductance*ContourLength;
                  end;
                  Conductance := ADrain.CondFact;
                  if ShowWarnings then
                  begin
                    if ADrain.Elevation > Top then
                    begin
                      DrainErrors.Add(Format
                        ('[%d, %d] Elevation > top of unit', [ADrain.Row, ADrain.Column]));
                    end;
                    if ADrain.Elevation < Bottom then
                    begin
                      DrainErrors.Add(Format
                        ('[%d, %d] Elevation < bottom of unit', [ADrain.Row, ADrain.Column]));
                    end;
                  end;
                end; // if frmMODFLOW.cbAltDrn.Checked then else
                if IsParam then
                begin
                  for StressPeriodIndex := 0 to InstanceLimit-1 do
                  begin
                    Used := Contour.
                      GetFloatParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]) <> 0;
                    if Used then
                    begin
                      ADrain.CondFact := Conductance;
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                    end;
                    if frmMODFLOW.cbAltDrn.Checked then
                    begin
                      ADrain.Elevation := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ElevationName);
                      if ShowWarnings then
                      begin
                        if ADrain.Elevation > Top then
                        begin
                          DrainErrors.Add(Format
                            ('[%d, %d] Elevation > top of unit',
                            [ADrain.Row, ADrain.Column]));
                        end;
                        if ADrain.Elevation < Bottom then
                        begin
                          DrainErrors.Add(Format
                            ('[%d, %d] Elevation < bottom of unit',
                            [ADrain.Row, ADrain.Column]));
                        end;
                      end;

                      ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom,
                        ADrain.Elevation);
                      if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                      begin
                        ADrain.IFACE := GridLayer.IntegerValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.'
                          + IFACENames[StressPeriodIndex]);
                      end; // if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                    end
                    else // if frmMODFLOW.cbAltDrn.Checked then
                    begin
                      // set Elevation here
                      ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom,
                        ADrain.Elevation);
                      if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                      begin
                        ADrain.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end;  // if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                    end;
                    AddParameterNameCell(ParameterName,ADrain, StressPeriodIndex);
                  end;
                end
                else // if IsParam then
                begin
                  if frmMODFLOW.cbAltDrn.Checked then
                  begin
                    ADrain.Elevation := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + ElevationName);
                    if ShowWarnings then
                    begin
                      if ADrain.Elevation > Top then
                      begin
                        DrainErrors.Add(Format
                          ('[%d, %d] Elevation > top of unit',
                          [ADrain.Row, ADrain.Column]));
                      end;
                      if ADrain.Elevation < Bottom then
                      begin
                        DrainErrors.Add(Format
                          ('[%d, %d] Elevation < bottom of unit',
                          [ADrain.Row, ADrain.Column]));
                      end;
                    end;
                    ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom,
                    ADrain.Elevation);
                  end
                  else
                  begin
                    ADrain.Elevation := Contour.GetFloatParameter(
                      CurrentModelHandle, ElevationIndex);
                    if ShowWarnings then
                    begin
                      if ADrain.Elevation > Top then
                      begin
                        DrainErrors.Add(Format
                          ('[%d, %d] Elevation > top of unit',
                          [ADrain.Row, ADrain.Column]));
                      end;
                      if ADrain.Elevation < Bottom then
                      begin
                        DrainErrors.Add(Format
                          ('[%d, %d] Elevation < bottom of unit',
                          [ADrain.Row, ADrain.Column]));
                      end;
                    end;
                    ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom,
                      ADrain.Elevation);
                  end;
                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    Used := Contour.GetFloatParameter
                      (CurrentModelHandle,IsOnIndicies[StressPeriodIndex]) <> 0;
                    if Used then
                    begin
                      if frmMODFLOW.cbAltDrn.Checked then
                      begin
                        if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                        begin
                          ADrain.IFACE := GridLayer.IntegerValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.'
                          + IFACENames[StressPeriodIndex]);
                        end; // if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                      end
                      else
                      begin
                        if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                        begin
                          ADrain.IFACE := Contour.GetIntegerParameter
                            (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                        end; // if ModflowTypes.GetLineDrainLayerType.UseIFACE then
                      end;
                      DrainList := DrainTimes[StressPeriodIndex];
                      DrainList.Add(ADrain);
                    end;
                  end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                end; // if IsParam then else
              end; // for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
            end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
          finally
            Contour.Free;
          end;

        end; // for ContourIndex := 0 to ContourCount -1 do
      end;
    finally
      DrainLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
  //    StageNames.Free;
  //    ConcentrationNames.Free;
      IFACENames.Free;
    end;
    if DrainErrors.Count > 0 then
    begin
      AString := 'Warning: Some line drains extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Drains below the bottom of the unit will be placed in '
        + 'the bottom layer of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := 'Drains above the top of the unit will be placed in '
        + 'the top layer of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(DrainErrors);
    end;
  finally
    DrainErrors.Free;
  end;
end;

procedure TDrainPkgWriter.EvaluateAreaDrainLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  DrainLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  ElevationIndex : ANE_INT16;
  CellGroupNumberIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ADrain : TDrainRecord;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  DrainList : TDrainList;
  ContourConductance : double;
  ContourIntersectArea : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, ElevationName, CellGroupName: string;
  IsOnNames : TStringList;
  IFACENames : TStringList;
  ColIndex, RowIndex : integer;
  AreaBoundaryInBlock : boolean;
  IsNA : boolean;
  CellArea : double;
  Used : boolean;
  Expression : string;
  DrainErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
  BottomElevIndex: ANE_INT16;
  BottomName: string;
begin
  // area drains
  if frmMODFLOW.cbUseAreaDrains.Checked then
  begin
    DrainErrors := TStringList.Create;
    try
      StressPeriodCount := frmModflow.dgTime.RowCount -1;
      if frmMODFLOW.comboDrnSteady.ItemIndex = 0 then
      begin
        StressPeriodCount := 1;
      end;
      SetLength(IsOnIndicies,StressPeriodCount);
      if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
      begin
        SetLength(IFACEIndicies,StressPeriodCount);
      end;

      LayerName := ModflowTypes.GetAreaDrainLayerType.WriteNewRoot
        + IntToStr(UnitIndex);
      AddVertexLayer(CurrentModelHandle,LayerName);
      SetAreaValues;
      LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
      DrainLayer := TLayerOptions.Create(LayerHandle);
      GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
      IFACENames := TStringList.Create;
      IsOnNames := TStringList.Create;
      try
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          ConductanceIndex, ElevationIndex, CellGroupNumberIndex,
          BottomElevIndex, IsParamName,
          ParamName, ConductanceName, ElevationName, CellGroupName, BottomName,
          CurrentModelHandle, DrainLayer, False);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFDrainOnParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnNames.Add(TimeParamName);
          IsOnIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACENames.Add(TimeParamName);
            IFACEIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; //  if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
        end; // for TimeIndex := 1 to StressPeriodCount do

        ContourCount := DrainLayer.NumObjects(CurrentModelHandle,pieContourObject);
        if frmModflow.cbAltDrn.Checked then
        begin
          frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;
        end
        else
        begin
          frmProgress.pbActivity.Max := Discretization.NCOL
            * Discretization.NROW * ContourCount;
          if not frmModflow.cbAreaDrainContour.Checked then
          begin
          frmProgress.pbActivity.Max := frmProgress.pbActivity.Max +
            Discretization.NCOL * Discretization.NROW;
          end;
        end;

        for ColIndex := 1 to Discretization.NCOL do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          for RowIndex := 1 to Discretization.NROW do
          begin
            if not ContinueExport then break;
            Application.ProcessMessages;
            AreaBoundaryInBlock := False;
            if not frmModflow.cbAltDrn.Checked then
            begin

              for ContourIndex := 0 to ContourCount -1 do
              begin
                if not ContinueExport then break;
                frmProgress.pbActivity.StepIt;
                Application.ProcessMessages;
                Contour := TContourObjectOptions.Create
                  (CurrentModelHandle,LayerHandle,ContourIndex);
                try
                  if Contour.ContourType(CurrentModelHandle) <> ctClosed then
                  begin
                    Inc(AreaErrors);
                  end
                  else
                  begin
                    ContourIntersectArea := GContourIntersectCell(ContourIndex, ColIndex, RowIndex);
                    if ContourIntersectArea > 0 then
                    begin
                      IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
                      if IsParam then
                      begin
                        ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                        InstanceLimit := GetParameterInstanceCount(ParameterName);
                      end; // if IsParam then

                      AreaBoundaryInBlock := True;
                      ContourConductance := Contour.GetFloatParameter
                        (CurrentModelHandle,ConductanceIndex);
                      ADrain.Elevation := Contour.GetFloatParameter
                        (CurrentModelHandle,ElevationIndex);
                      ADrain.CellGroupNumber := Contour.GetIntegerParameter
                        (CurrentModelHandle,CellGroupNumberIndex);
                      if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
                      begin
                        ADrain.BottomElevation := Contour.GetFloatParameter
                          (CurrentModelHandle,BottomElevIndex);
                      end
                      else
                      begin
                        ADrain.BottomElevation := 0;
                      end;

                      ADrain.Row := RowIndex;
                      ADrain.Column := ColIndex;
                      Top := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex-1];
                      Bottom := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex];
                      if frmModflow.cbCondDrn.Checked then
                      begin
                        ADrain.CondFact := ContourConductance;
                      end
                      else
                      begin
                        ADrain.CondFact := ContourConductance*ContourIntersectArea;
                      end;
                      Conductance := ADrain.CondFact;
                      if ShowWarnings then
                      begin
                        if ADrain.Elevation > Top then
                        begin
                          DrainErrors.Add(Format
                            ('[%d, %d] Elevation > top of unit', [ADrain.Row, ADrain.Column]));
                        end;
                        if ADrain.Elevation < Bottom then
                        begin
                          DrainErrors.Add(Format
                            ('[%d, %d] Elevation < bottom of unit', [ADrain.Row, ADrain.Column]));
                        end;
                      end;
                      ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                      if IsParam then
                      begin
                        for StressPeriodIndex := 0 to InstanceLimit-1 do
                        begin
                          Used := Contour.GetFloatParameter
                            (CurrentModelHandle,IsOnIndicies[StressPeriodIndex]) <> 0;
                          if Used then
                          begin
                            ADrain.CondFact := Conductance;
                          end
                          else
                          begin
                            ADrain.CondFact := 0;
                          end;
                          if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                          begin
                            ADrain.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end;  // if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                          AddParameterNameCell(ParameterName,ADrain, StressPeriodIndex);
                        end;
                      end
                      else // if IsParam then
                      begin
                        for StressPeriodIndex := 0 to StressPeriodCount-1 do
                        begin
                          if not ContinueExport then break;
                          Application.ProcessMessages;
                          Used := Contour.GetFloatParameter
                            (CurrentModelHandle,IsOnIndicies[StressPeriodIndex]) <> 0;
                          if Used then
                          begin
                            ADrain.CondFact := Conductance;
                          end
                          else
                          begin
                            ADrain.CondFact := 0;
                          end;
                            if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                            begin
                              ADrain.IFACE := Contour.GetIntegerParameter
                                (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                            end; // if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                            DrainList := DrainTimes[StressPeriodIndex];
                            DrainList.Add(ADrain);
                        end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                      end; // if IsParam then else
                    end;
                  end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
                finally
                  Contour.Free;
                end;

              end; // for ContourIndex := 0 to ContourCount -1 do
            end; // if not frmModflow.cbAltDrn.Checked then
            if not ContinueExport then break;

            if frmModflow.cbAreaDrainContour.Checked then
            begin
              // only use contours.
              Continue;
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;

            if frmModflow.cbAltDrn.Checked then
            begin
              CellArea := GGetCellArea(ColIndex,RowIndex);
            end
            else
            begin
              CellArea := GContourIntersectCellRemainder(ColIndex,RowIndex);
            end;
            if (CellArea > 0) and
              (frmModflow.cbAltDrn.Checked or not AreaBoundaryInBlock) then
            begin
              BlockIndex := Discretization.BlockIndex(RowIndex -1, ColIndex -1);
              ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                Discretization.GridLayerHandle,BlockIndex);
              try
                ABlock.GetCenter(CurrentModelHandle,X,Y);
              finally
                ABlock.Free;
              end;

              Expression := LayerName + '.' + ConductanceName;

              IsNA := GridLayer.BooleanValueAtXY(CurrentModelHandle,X,Y,
                Expression + '=$N/A');
              if not IsNA then
              begin
                ContourConductance := GridLayer.RealValueAtXY
                  (CurrentModelHandle,X,Y, Expression);

                Expression := LayerName + '.' + IsParamName;

                IsParam := GridLayer.BooleanValueAtXY
                  (CurrentModelHandle,X,Y, Expression);
                if IsParam then
                begin
                  Expression := LayerName + '.' + ParamName;

                  ParameterName := GridLayer.StringValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  InstanceLimit := GetParameterInstanceCount(ParameterName);
                end; // if IsParam then

                if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
                begin
                  Expression := LayerName + '.' + BottomName;
                  ADrain.BottomElevation := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                end
                else
                begin
                  ADrain.BottomElevation := 0;
                end;

                Expression := LayerName + '.' + ElevationName;
                ADrain.Elevation := GridLayer.RealValueAtXY
                  (CurrentModelHandle,X,Y, Expression);

                Expression := LayerName + '.' + CellGroupName;
                ADrain.CellGroupNumber := GridLayer.IntegerValueAtXY
                  (CurrentModelHandle,X,Y, Expression);

                ADrain.Row := RowIndex;
                ADrain.Column := ColIndex;
                Top := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex-1];
                Bottom := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex];
                ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                if frmModflow.cbCondDrn.Checked then
                begin
                  ADrain.CondFact := ContourConductance;
                end
                else
                begin
                  ADrain.CondFact := ContourConductance*CellArea;
                end;
                Conductance := ADrain.CondFact;
                if ShowWarnings then
                begin
                  if ADrain.Elevation > Top then
                  begin
                    DrainErrors.Add(Format
                      ('[%d, %d] Elevation > top of unit', [ADrain.Row, ADrain.Column]));
                  end;
                  if ADrain.Elevation < Bottom then
                  begin
                    DrainErrors.Add(Format
                      ('[%d, %d] Elevation < bottom of unit', [ADrain.Row, ADrain.Column]));
                  end;
                end;
                ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                if IsParam then
                begin
                  for StressPeriodIndex := 0 to InstanceLimit-1 do
                  begin
                    Used := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, LayerName + '.' + IsOnNames[StressPeriodIndex]) <> 0;
                    if Used then
                    begin
                      ADrain.CondFact := Conductance;
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                    end;
                    if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                    begin
                      Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                      ADrain.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                    end;  // if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                    AddParameterNameCell(ParameterName,ADrain, StressPeriodIndex);
                  end;
                end
                else // if IsParam then
                begin
                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;

                    Expression := LayerName + '.' + IsOnNames[StressPeriodIndex];

                    Used := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression) <> 0;
                    if Used then
                    begin
                      ADrain.CondFact := Conductance;
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                    end;
                      ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                      if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                      begin
                        Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                        ADrain.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                      end; // if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
                      DrainList := DrainTimes[StressPeriodIndex];
                      DrainList.Add(ADrain);
                  end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                end; // if IsParam then else
              end;
            end;
          end; // for RowIndex:=  to Discretization.NROW do
        end; // for ColIndex := 1 to Discretization.NCOL; do

      finally
        DrainLayer.Free(CurrentModelHandle);
        GridLayer.Free(CurrentModelHandle);
        IFACENames.Free;
        IsOnNames.Free;
      end;
      if DrainErrors.Count > 0 then
      begin
        AString := 'Warning: Some area drains extend outside of the geologic '
          + 'unit in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'Drains below the bottom of the unit will be placed in '
          + 'the bottom layer of the unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := 'Drains above the top of the unit will be placed in '
          + 'the top layer of the unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(DrainErrors);
      end;
    finally
      DrainErrors.Free;
    end;
  end;
end;

procedure TDrainPkgWriter.EvaluateDataSets6and7(
  const CurrentModelHandle: ANE_PTR; Discretization : TDiscretizationWriter);
var
  UnitIndex : integer;
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try

    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;

      if not frmMODFLOW.Simulated(UnitIndex) then
      begin
        frmProgress.pbPackage.StepIt;
        frmProgress.pbPackage.StepIt;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end
      else
      begin
        if ContinueExport then
        begin
          // point drains
          frmProgress.lblActivity.Caption := 'Evaluating Point Drains in Unit ' + IntToStr(UnitIndex);
          EvaluatePointDrainLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // line drains
          frmProgress.lblActivity.Caption := 'Evaluating Line Drains in Unit ' + IntToStr(UnitIndex);
          EvaluateLineDrainLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area drains
          frmProgress.lblActivity.Caption := 'Evaluating Area Drains in Unit ' + IntToStr(UnitIndex);
          EvaluateAreaDrainLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
      end;
    end;
  finally
    ProjectOptions.Free;
  end;


end;

procedure TDrainPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TDrainParamValue;
//  ADrainList : TDrainList;
  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    DrainTimes.Add(TDrainList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS*3 ;
  frmProgress.pbPackage.Position := 0;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Drain';
    Application.ProcessMessages;

    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
//    frmProgress.pbPackage.StepIt;
//    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SortDrains;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsDRN;
    AssignFile(FFile,FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
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
        frmProgress.lblActivity.Caption := 'Writing Data Sets 3 and 4';
        WriteDataSets3And4;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDatasets5To7;
        frmProgress.pbPackage.StepIt;
        Flush(FFile);
        Application.ProcessMessages;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
  if PointErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
      + ' contours in the DRN (drain) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the DRN (drain) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the DRN (drain) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TDrainPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TDrainParamValue;
//  ADrainList : TDrainList;
//  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    DrainTimes.Add(TDrainList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 2 ;
  frmProgress.pbPackage.Position := 0;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Drain';
    Application.ProcessMessages;

    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SortDrains;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
  if PointErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
      + ' contours in the DRN (drain) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the DRN (drain) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the DRN (drain) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TDrainPkgWriter.AddParameterNames;
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgDRNParametersN.RowCount -1 do
  begin
    AddParameterName(RowIndex);
  end;

end;

procedure TDrainPkgWriter.AddParameterName(RowIndex : integer);
var
  ParamIndex : integer;
  AParamValue : TDrainParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgDRNParametersN.Cells[0,RowIndex]);
  ParamIndex := ParameterNames.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TDrainParamValue.Create(RowIndex);
    ParameterNames.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different drain parameters with the same name: ' + ParameterName
      + ' in the Drain package.  Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create
//      ('Error: Two different drain parameters with the same name: '
//      + '"ParameterName".');
  end;
end;

procedure TDrainPkgWriter.WriteDataSet1;
var
  NPDRN : integer;
  ParamIndex : integer;
  AParam : TDrainParamValue;
  ParamErrors : TStringList;
  AString : string;
  DrainList : TDrainList;
begin
  ParamErrors := TStringList.Create;
  try
    MXL := 0;
    if ParameterNames.Count > 0 then
    begin
  //    NPDRN := ParameterNames.Count;
      NPDRN := 0;
      for ParamIndex := 0 to ParameterNames.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AParam := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
        if AParam.Instances.Count > 0 then
        begin
          DrainList := AParam.Instances.Objects[0] as TDrainList;
          MXL := MXL + DrainList.Count * AParam.Instances.Count;
        end
        else
        begin
          MXL := MXL + AParam.DrainList.Count;
          DrainList := nil;
        end;
//        MXL := MXL + AParam.DrainList.Count;
        if (AParam.DrainList.Count > 0) or
          ((AParam.Instances.Count > 0) and (DrainList.Count > 0)) then
        begin
          Inc(NPDRN);
        end
        else
        begin
          ParamErrors.Add(ParameterNames[ParamIndex]);
        end;
      end;
      Writeln(FFile, 'PARAMETER ', NPDRN, ' ', MXL);
    end;
    if ParamErrors.Count > 0 then
    begin
      ParamErrors.Insert(0,'Warning: The following drain parameters have no '
        + 'cells associated with them.  They will be skipped.');
      ParamErrors.Insert(0,'');

      AString := 'Warning: Some drains parameters have no cells. '
        + 'They will be skipped.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.AddStrings(ParamErrors);
    end;

  finally
    ParamErrors.Free;
  end;


end;

procedure TDrainPkgWriter.WriteDataSet2;
var
  Index, MXACTD, IDRNCB : integer;
  ADrainList : TDrainList;
  Option : string;
begin
  MXACTD := 0;
  for Index := 0 to DrainTimes.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    ADrainList := DrainTimes[Index];
    if ADrainList.Count > MXACTD then
    begin
      MXACTD := ADrainList.Count
    end;
  end;
  MXACTD := MXACTD + MXL;
  if frmModflow.cbFlowDrn.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IDRNCB := frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IDRNCB := frmModflow.GetUnitNumber('DRNBUD');
    end;
  end
  else
  begin
      IDRNCB := 0;
  end;
  Option := '';
  if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
  begin
    Option := Option + ' AUXILIARY IFACE'
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Option := Option + ' CBCALLOCATE AUXILIARY CONCENTRATION'
  end;
  if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
  begin
    Option := Option + ' AUXILIARY DRNBELEV'
  end;
  if not frmModflow.cbPrintCellLists.Checked then
  begin
    Option := Option + ' NOPRINT';
  end;
  Writeln(FFile, MXACTD, ' ', IDRNCB, Option);
end;

procedure TDrainPkgWriter.WriteDataSets3And4;
const
  PARTYP = '''DRN'' ';
var
  ParamIndex, DrainIndex, InstanceIndex : integer;
  AParam : TDrainParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  ADrain : TDrain;
  DrainList : TDrainList;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    PARNAM := ParameterNames[ParamIndex];
    AParam := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
    Parval := AParam.Value;
    if AParam.Instances.Count > 0 then
    begin
      DrainList := AParam.Instances.Objects[0] as TDrainList;
    end
    else
    begin
      DrainList := AParam.DrainList;
    end;

    NLST := DrainList.Count;
//    NLST := AParam.DrainList.Count;
    if NLST > 0 then
    begin
      Write(FFile, '''', PARNAM, ''' ', PARTYP, ' ', FreeFormattedReal(Parval), NLST);
      if AParam.Instances.Count > 0 then
      begin
        Write(FFile, ' INSTANCES ', AParam.Instances.Count);
      end;
      Writeln(FFile);
      if AParam.Instances.Count > 0 then
      begin
        for InstanceIndex := 0 to AParam.Instances.Count-1 do
        begin
          Writeln(FFile, AParam.Instances[InstanceIndex]);
          DrainList := AParam.Instances.Objects[InstanceIndex] as TDrainList;
          for DrainIndex := 0 to DrainList.Count -1 do
          begin
            if not ContinueExport then break;
            Application.ProcessMessages;
            ADrain := DrainList[DrainIndex] as TDrain;
            ADrain.WriteDrain(self);
          end;
        end;
      end
      else
      begin
        for DrainIndex := 0 to AParam.DrainList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          ADrain := AParam.DrainList[DrainIndex] as TDrain;
          ADrain.WriteDrain(self);
        end;
      end;
    end;
  end;
end;

procedure TDrainPkgWriter.WriteDatasets5To7;
var
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    if not ContinueExport then break;
    frmProgress.lblActivity.Caption := 'Writing Data Set 5 in Stress Period '
      + IntToStr(StressPeriodIndex);
    WriteDataSet5(StressPeriodIndex);
    Application.ProcessMessages;
    if ITMP > 0 then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 6 in Stress Period '
        + IntToStr(StressPeriodIndex);
      WriteDataSet6(StressPeriodIndex);
      Application.ProcessMessages;
    end;
    if NP > 0 then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 7 in Stress Period '
        + IntToStr(StressPeriodIndex);
      WriteDataSet7(StressPeriodIndex);
      Application.ProcessMessages;
    end;
  end;


end;

procedure TDrainPkgWriter.SortDrains;
var
  ParamIndex, InstanceIndex : integer;
  AParam : TDrainParamValue;
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  DrainList : TDrainList;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting Drains';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParameterNames.Count + StressPeriodCount;

  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
    AParam.DrainList.Sort;
    for InstanceIndex := 0 to AParam.Instances.Count -1 do
    begin
      DrainList := AParam.Instances.Objects[InstanceIndex] as TDrainList;
      DrainList.Sort;
    end;

    frmProgress.pbActivity.StepIt;
  end;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    DrainList := DrainTimes[StressPeriodIndex];
    DrainList.Sort;
    frmProgress.pbActivity.StepIt;
  end;
end;


procedure TDrainPkgWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  DrainList : TDrainList;
  ParamIndex : integer;
  AParam : TDrainParamValue;
begin
  DrainList := DrainTimes[StressPeriodIndex];
  ITMP := DrainList.Count;
  if (StressPeriodIndex >= 1) and (frmMODFLOW.comboDrnSteady.ItemIndex = 0) then
  begin
    ITMP := -1;
  end;
  NP := 0;
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Inc(NP);
    end;
  end;
  WriteLn(FFile, ITMP, ' ', NP);
end;

procedure TDrainPkgWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  DrainList : TDrainList;
  ADrain : TDrain;
  DrainIndex : integer;
begin
  DrainList := DrainTimes[StressPeriodIndex];
  for DrainIndex := 0 to DrainList.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    ADrain := DrainList[DrainIndex] as TDrain;
    ADrain.WriteDrain(self);
  end;
end;

procedure TDrainPkgWriter.WriteDataSet7(StressPeriodIndex: integer);
var
  ParamIndex : integer;
  AParam : TDrainParamValue;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex]
      and ((AParam.DrainList.Count > 0) or (AParam.Instances.Count > 0)) then
    begin
      Write(FFile, ParameterNames[ParamIndex]);
      if AParam.Instances.Count > 0 then
      begin
        Write(FFile, ' ', AParam.InstanceNamesUsed[StressPeriodIndex]);
      end;

      Writeln(FFile);
    end;
  end;
end;

function TDrainPkgWriter.BoundaryUsed(Layer, Row,
  Column: integer): boolean;
var
  ListIndex, InstanceIndex : integer;
  DrainList : TDrainList;
  ADrain : Tdrain;
  AParamValue : TDrainParamValue;
  Index : integer;
begin
  result := False;
  for ListIndex := 0 to DrainTimes.Count -1 do
  begin
    DrainList := DrainTimes[ListIndex];
    ADrain := DrainList.GetDrainByLocation(Layer, Row, Column);
    result := ADrain <> nil;
    if result then Exit;
  end;

  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TDrainParamValue;
    ADrain := AParamValue.DrainList.GetDrainByLocation(Layer, Row, Column);
    result := ADrain <> nil;
    if result then Exit;
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      DrainList := AParamValue.Instances.Objects[InstanceIndex] as TDrainList;
      ADrain := DrainList.GetDrainByLocation(Layer, Row, Column);
      result := ADrain <> nil;
      if result then Exit;
    end;
  end;

end;

constructor TDrainPkgWriter.Create;
begin
  inherited;
  PointErrors := 0;
  LineErrors := 0;
  AreaErrors := 0;
  ParameterNames := TStringList.Create;
  DrainTimes := TList.Create;
end;

destructor TDrainPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TDrainParamValue;
  ADrainList : TDrainList;
begin
  for Index := ParameterNames.Count -1 downto 0 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TDrainParamValue;
    AParamValue.Free;
  end;
  ParameterNames.Free;

  for Index := DrainTimes.Count -1 downto 0 do
  begin
    ADrainList := DrainTimes[Index];
    ADrainList.Free;
  end;
  DrainTimes.Free;
  inherited;

end;

procedure TDrainPkgWriter.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index, InstanceIndex : integer;
  AParamValue : TDrainParamValue;
  DrainList : TDrainList;
begin
  if DrainTimes.Count > 0 then
  begin
    DrainList := DrainTimes[0];
    DrainList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TDrainParamValue;
    AParamValue.DrainList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      DrainList := AParamValue.Instances.Objects[InstanceIndex] as TDrainList;
      DrainList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    end;
  end;

end;


procedure TDrainPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  ParamIndex, InstanceIndex : integer;
  AParam : TDrainParamValue;
  DrainList : TDrainList;
  InstanceName : string;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainParamValue;

    if AParam.Instances.Count > 0 then
    begin
      InstanceName := AParam.InstanceNamesUsed[StressPeriod -1];
      InstanceIndex := AParam.Instances.IndexOf(InstanceName);
      if  InstanceIndex >= 0 then
      begin
        DrainList := AParam.Instances.Objects[InstanceIndex] as TDrainList;
        DrainList.WriteMT3DConcentrations(Lines);
      end;
    end
    else
    begin
      AParam.DrainList.WriteMT3DConcentrations(Lines);
    end;
  end;
  DrainList := DrainTimes[StressPeriod-1];
  DrainList.WriteMT3DConcentrations(Lines);
end;

class procedure TDrainPkgWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowDrn.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      frmModflow.GetUnitNumber('DRNBUD');
    end;
  end;
end;

{ TDrainParamValue }

constructor TDrainParamValue.Create(RowIndex : Integer);
var
  TimeIndex, InstanceIndex : Integer;
  StressPeriodCount : integer;
  dgColumn : integer;
  AStringGrid : TStringGrid;
begin
  Instances := TStringList.Create;
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;
  SetLength(StressPeriodsUsed, StressPeriodCount);
  SetLength(InstanceNamesUsed, StressPeriodCount);
  AStringGrid := frmModflow.sg3dDRNParamInstances.Grids[RowIndex-1];
  for InstanceIndex := 1 to AStringGrid.RowCount -1 do
  begin
    Instances.AddObject(AStringGrid.Cells[0,InstanceIndex], TDrainList.Create);
  end;

  DrainList := TDrainList.Create;
  for TimeIndex := 0 to StressPeriodCount -1 do
  begin
    dgColumn := TimeIndex + 4;
    StressPeriodsUsed[TimeIndex]
      := (frmModflow.dgDRNParametersN.Cells[dgColumn,RowIndex]
          <> frmModflow.dgDRNParametersN.Columns[dgColumn].PickList[0]);
    InstanceNamesUsed[TimeIndex] := frmModflow.dgDRNParametersN.
      Cells[dgColumn,RowIndex];
  end;
  Value := InternationalStrToFloat(frmModflow.dgDRNParametersN.Cells[2,RowIndex]);
end;

destructor TDrainParamValue.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to Instances.Count-1 do
  begin
    Instances.Objects[Index].Free;
  end;

  Instances.Free;
  DrainList.Free;
  inherited;
end;

{ TDrainList }

function TDrainList.Add(ADrain: TDrainRecord): integer;
var
  DrainObject : TDrain;
  Index : integer;
begin
  for Index := 0 to Count -1 do
  begin
    DrainObject := Items[Index] as TDrain;
    With DrainObject do
    begin
    if (Drain.Layer = ADrain.Layer) and
       (Drain.Row = ADrain.Row) and
       (Drain.Column = ADrain.Column) and
       (Drain.Elevation = ADrain.Elevation) and
       (Drain.IFACE = ADrain.IFACE) and
       (Drain.CellGroupNumber = ADrain.CellGroupNumber) and
       (Drain.BottomElevation = ADrain.BottomElevation) then
       begin
         Drain.CondFact := Drain.CondFact + ADrain.CondFact;
         result := Index;
         Exit;
       end;
    end;
  end;
  DrainObject := TDrain.Create;
  result := Add(DrainObject);
  DrainObject.Drain := ADrain;
end;

procedure TDrainList.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index : integer;
  ADrain : TDrain;
begin
  for Index := 0 to Count -1 do
  begin
    ADrain := Items[Index] as TDrain;
    if (ADrain.Drain.Layer = Layer) and (ADrain.Drain.Row = Row)
      and (ADrain.Drain.Column = Column) then
    begin
      BoundaryList.Add(TBoundaryCell.Create(ADrain.Drain.CellGroupNumber));
    end;
  end;
end;

function TDrainList.GetDrainByLocation(Layer, Row, Column: integer): TDrain;
var
  Index : integer;
  ADrain : TDrain;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ADrain := Items[Index] as TDrain;
    if (ADrain.Drain.Layer = Layer) and (ADrain.Drain.Row = Row)
      and (ADrain.Drain.Column = Column) then
    begin
      result := ADrain;
      Exit;
    end;
  end;
end;

procedure TDrainList.Sort;
begin
  inherited Sort(DrainSortFunction);
end;


procedure TDrainList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  ADrain : TDrain;
begin
  for Index := 0 to Count -1 do
  begin
    ADrain := Items[Index] as TDrain;
    ADrain.WriteMT3DConcentrations(Lines);
  end;
end;

{ TDrain }

procedure TDrain.WriteDrain(DrainWriter : TDrainPkgWriter);
begin
  Write(DrainWriter.FFile, Drain.Layer, ' ',  Drain.Row, ' ',  Drain.Column, ' ',
    DrainWriter.FreeFormattedReal(Drain.Elevation),
    DrainWriter.FreeFormattedReal(Drain.CondFact)
    {Format('%.13e %.13e', [Drain.Elevation, Drain.CondFact])});
  if ModflowTypes.GetAreaDrainLayerType.UseIFACE then
  begin
    Write(DrainWriter.FFile, ' ',  Drain.IFACE);
  end;
  if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
  begin
    Write(DrainWriter.FFile, ' ',
      DrainWriter.FreeFormattedReal(Drain.BottomElevation));
  end;

  WriteLn(DrainWriter.FFile);
end;

procedure TDrain.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  ALine := TModflowWriter.FixedFormattedInteger(Drain.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Drain.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Drain.Column, 10)
    + TModflowWriter.FixedFormattedReal(0, 10)
    + TModflowWriter.FixedFormattedInteger(3, 10) + ' ';
  for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal(0);
  end;
  Lines.Add(ALine);
end;

end.
