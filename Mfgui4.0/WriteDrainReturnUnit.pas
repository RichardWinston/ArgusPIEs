unit WriteDrainReturnUnit;

interface

uses Sysutils, Classes, contnrs, Forms, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit;

type
  TDrainReturnRecord = record
    Layer, Row, Column : integer;
    Elevation, CondFact : double;
    IFACE : integer;
    CellGroupNumber : integer;
    ReturnIndex : integer;
    ReturnFraction : double;
  end;

  TDrainReturnLocationRecord = record
    Layer, Row, Column : integer;
    ReturnIndex : integer;
  end;


  TDrainReturn = class;

  TDrainReturnList = Class(TObjectList)
  private
    function Add(ADrain : TDrainReturnRecord) : integer; overload;
    function GetDrainByLocation(Layer, Row, Column: integer): TDrainReturn;
    procedure Sort;
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  private
    procedure FillBoundaryList(Layer, Row, Column: integer;
      BoundaryList : TObjectList);
  end;

  TDrainReturnLocation = class;

  TDrainReturnLocationList = class(TObjectList)
    function Add(ADrain : TDrainReturnLocationRecord) : integer; overload;
    function GetDrainByReturnIndex(ReturnIndex: integer): TDrainReturnLocation;
  end;

  TDrainReturnParamValue = Class(TObject)
  private
    Value : double;
    StressPeriodsUsed: Array of boolean;
    InstanceNamesUsed: array of string;
    DrainList : TDrainReturnList;
    Instances : TStringList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  TDrainReturnPkgWriter = class(TCustomBoundaryWriterWithObservations)
  private
    ParameterNames : TStringList;
    DrainTimes : TList;
    MXL : integer;
    ITMP, NP : integer;
    DrainReturnLocationList : TDrainReturnLocationList;
    PointErrors, LineErrors, AreaErrors: integer;
    Procedure AddParameterNameCell(ParameterName : string;
      ADrainRecord : TDrainReturnRecord; Const Instance : integer);
    Procedure AddParameterName(RowIndex : integer);
    procedure EvaluateDataSets5and6(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(var IsParamIndex, ParamNameIndex,
      ConductanceIndex, ElevationIndex,
      CellGroupNumberIndex: ANE_INT16; var IsParamName, ParamName,
      ConductanceName, ElevationName,
      CellGroupName: string; const
      CurrentModelHandle: ANE_PTR; DrainLayer : TLayerOptions; const PointLayer: boolean);
    procedure AddParameterNames;
    procedure EvaluatePointDrainReturnLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization : TDiscretizationWriter);
    procedure EvaluateLineDrainReturnLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaDrainReturnLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
//    procedure WriteDataSet2;
    procedure WriteDataSets2And3;
    procedure WriteDatasets4To6;
    procedure WriteDataSet4(StressPeriodIndex : integer);
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    procedure SortDrains;
    procedure EvaluateDrainReturnLocations(
      const CurrentModelHandle: ANE_PTR; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
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

  TDrainReturn = Class(TObject)
  private
    Drain : TDrainReturnRecord;
    procedure WriteDrainReturn(DrainWriter : TDrainReturnPkgWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;

  TDrainReturnLocation = Class(TObject)
  private
    Drain : TDrainReturnLocationRecord;
  end;

implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

function DrainSortFunction(Item1, Item2: Pointer): Integer;
var
  Drain1, Drain2 : TDrainReturn;
begin
  Drain1 := Item1;
  Drain2 := Item2;
  result := Drain1.Drain.Layer - Drain2.Drain.Layer;
  if Result <> 0 then Exit;
  result := Drain1.Drain.Row - Drain2.Drain.Row;
  if Result <> 0 then Exit;
  result := Drain1.Drain.Column - Drain2.Drain.Column;
end;

{ TDrainReturnPkgWriter }

procedure TDrainReturnPkgWriter.AddParameterNameCell(ParameterName : string;
      ADrainRecord : TDrainReturnRecord; Const Instance : integer);
var
  ParamIndex : integer;
  AParamValue : TDrainReturnParamValue;
  DrainList : TDrainReturnList;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Drain-Return package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
    if AParamValue.Instances.Count > 0 then
    begin
      DrainList := AParamValue.Instances.Objects[Instance] as TDrainReturnList;
    end
    else
    begin
      DrainList := AParamValue.DrainList;
    end;
    DrainList.Add(ADrainRecord);
//    AParamValue.DrainList.Add(ADrainRecord);
  end;
end;


procedure TDrainReturnPkgWriter.GetParamIndicies(var IsParamIndex, ParamNameIndex,
  ConductanceIndex, ElevationIndex,
  CellGroupNumberIndex: ANE_INT16;
  var IsParamName, ParamName,
  ConductanceName, ElevationName,
  CellGroupName: string; const
  CurrentModelHandle: ANE_PTR; DrainLayer : TLayerOptions; const PointLayer: boolean);
begin
  IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
  IsParamIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

  ParamName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  ParamNameIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  if PointLayer or frmModflow.cbCondDrnRtn.Checked then
  begin
    ConductanceName := ModflowTypes.GetMFDrainReturnConductanceParamType.WriteParamName;
  end
  else
  begin
    ConductanceName := ModflowTypes.GetMFDrainReturnConductanceParamType.WriteFactorName;
  end;
  ConductanceIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, ConductanceName);

  ElevationName := ModflowTypes.GetMFDrainElevationParamType.WriteParamName;
  ElevationIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, ElevationName);

  CellGroupName := ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName;
  CellGroupNumberIndex := DrainLayer.GetParameterIndex(CurrentModelHandle, CellGroupName);
end;

procedure TDrainReturnPkgWriter.EvaluateDrainReturnLocations(const
  CurrentModelHandle: ANE_PTR;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  DrainReturnLayer : TLayerOptions;
  ContourCount : integer;
  ElevationIndex, IndexIndex : ANE_INT16;
  ElevationName, IndexName : string;
  ContourIndex, CellIndex : integer;
  Errors : TStringList;
  Contour : TContourObjectOptions;
  NonPointContour : boolean;
  AString : string;
  Elevation : double;
  DrainReturnLocationRecord : TDrainReturnLocationRecord;
begin
  NonPointContour := False;
  Errors := TStringList.Create;
  try

    LayerName := ModflowTypes.GetMFDrainReturnLayerType.WriteNewRoot;
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    DrainReturnLayer := TLayerOptions.Create(LayerHandle);
    try
      ContourCount := DrainReturnLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        ElevationName := ModflowTypes.GetMFDrainElevationParamType.WriteParamName;
        ElevationIndex := DrainReturnLayer.GetParameterIndex(CurrentModelHandle, ElevationName);

        IndexName := ModflowTypes.GetDrainReturnIndexParamType.WriteParamName;
        IndexIndex := DrainReturnLayer.GetParameterIndex(CurrentModelHandle, IndexName);

        frmProgress.pbActivity.Max := ContourCount;
        for ContourIndex := 0 to ContourCount -1 do
        begin
          frmProgress.pbActivity.StepIt;
          if not ContinueExport then break;
          Application.ProcessMessages;
          Contour := TContourObjectOptions.Create
            (CurrentModelHandle,LayerHandle,ContourIndex);
          try
            if Contour.NumberOfNodes(CurrentModelHandle) = 1 then
            begin
              Elevation := Contour.GetFloatParameter(CurrentModelHandle,
                ElevationIndex);
              DrainReturnLocationRecord.ReturnIndex :=
                Contour.GetIntegerParameter(CurrentModelHandle,IndexIndex);

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                DrainReturnLocationRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                DrainReturnLocationRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                DrainReturnLocationRecord.Layer := Discretization.
                  ElevationToLayer(DrainReturnLocationRecord.Column,
                  DrainReturnLocationRecord.Row, Elevation);
                DrainReturnLocationList.Add(DrainReturnLocationRecord);
              end;
            end
            else
            begin
              NonPointContour := True;
            end;
          finally
            Contour.Free;
          end;


        end;
      end;
    finally
      DrainReturnLayer.Free(CurrentModelHandle);
    end;
    if NonPointContour then
    begin
      AString := 'Error: Only Point contours should be used in the '
        + LayerName + ' layer .';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);
    end;
  finally
    Errors.Free;
  end;
end;

function TDrainReturnPkgWriter.GetParameterInstanceCount(const ParameterName : string) : integer;
var
  ParamIndex : integer;
  AParamValue : TDrainReturnParamValue;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    result := -1;
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Drain-Return package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
    result := AParamValue.Instances.Count;
    if result = 0 then
    begin
      result := 1;
    end
  end;
end;

procedure TDrainReturnPkgWriter.EvaluatePointDrainReturnLayer(const
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
  ReturnIndexIndicies : array of Integer;
  RetrunFractionIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ADrain : TDrainReturnRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  DrainList : TDrainReturnList;
  IsParamName, ParamName, ConductanceName, ElevationName : string;
  CellGroupName: string;
  Used : boolean;
  DrainErrors : TStringList;
  AString : string;
  Conductance : double;
  Elevation : double;
  InstanceLimit : integer;
begin
  // point drains
  DrainErrors := TStringList.Create;
  try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboDrtSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(IsOnIndicies,StressPeriodCount);
    SetLength(ReturnIndexIndicies,StressPeriodCount);
    SetLength(RetrunFractionIndicies,StressPeriodCount);
    if ModflowTypes.GetMFPointDrainReturnLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;

    LayerName := ModflowTypes.GetMFPointDrainReturnLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    DrainLayer := TLayerOptions.Create(LayerHandle);
    try
      ContourCount := DrainLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          ConductanceIndex, ElevationIndex,
          CellGroupNumberIndex, IsParamName, ParamName,
          ConductanceName, ElevationName, 
          CellGroupName, CurrentModelHandle, DrainLayer, True);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFDrainOnParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetDrainReturnIndexParamType.WriteParamName
            + IntToStr(TimeIndex);
          ReturnIndexIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetDrainReturnFractionParamType.WriteParamName
            + IntToStr(TimeIndex);
          RetrunFractionIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if ModflowTypes.GetMFPointDrainReturnLayerType.UseIFACE then
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
              InstanceLimit := 0;
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
                      ADrain.ReturnIndex  := Contour.GetIntegerParameter(CurrentModelHandle,ReturnIndexIndicies[StressPeriodIndex]);
                      ADrain.ReturnFraction  := Contour.GetFloatParameter(CurrentModelHandle,RetrunFractionIndicies[StressPeriodIndex]);
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                      ADrain.ReturnIndex := 0;
                      ADrain.ReturnFraction := 0;
                    end;
                    if ModflowTypes.GetMFPointDrainReturnLayerType.UseIFACE then
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
                      ADrain.ReturnIndex  := Contour.GetIntegerParameter(CurrentModelHandle,ReturnIndexIndicies[StressPeriodIndex]);
                      ADrain.ReturnFraction  := Contour.GetFloatParameter(CurrentModelHandle,RetrunFractionIndicies[StressPeriodIndex]);
                      if ModflowTypes.GetMFPointDrainReturnLayerType.UseIFACE then
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
      AString := 'Warning:  In Drain Return package, some point drains extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Drains below the bottom of the unit will be treated as if they '
        + 'are at the bottom of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := 'Drains above the top of the unit will be treated as if they '
        + 'are at the top of the unit.';
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

procedure TDrainReturnPkgWriter.EvaluateLineDrainReturnLayer(const
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
  ReturnIndexIndicies : array of Integer;
  RetrunFractionIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ADrain : TDrainReturnRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  DrainList : TDrainReturnList;
  ContourConductance : double;
  ContourLength : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, ElevationName, CellGroupName: string;
//  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  ReturnIndexNames : TStringList;
  ReturnFractionNames : TStringList;
  Used : boolean;
  DrainErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
begin
  ContourConductance := 0;
  // line drains
  DrainErrors := TStringList.Create;
  try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboDrtSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(IsOnIndicies,StressPeriodCount);
    SetLength(ReturnIndexIndicies,StressPeriodCount);
    SetLength(RetrunFractionIndicies,StressPeriodCount);
    if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;

    LayerName := ModflowTypes.GetMFLineDrainReturnLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    DrainLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  //  ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    ReturnIndexNames := TStringList.Create;
    ReturnFractionNames := TStringList.Create;
    try
      ContourCount := DrainLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        IFACENames.Capacity := StressPeriodCount;
        ReturnIndexNames.Capacity := StressPeriodCount;
        ReturnFractionNames.Capacity := StressPeriodCount;

        GetParamIndicies(IsParamIndex, ParamNameIndex,
          ConductanceIndex, ElevationIndex,
          CellGroupNumberIndex, IsParamName, ParamName, ConductanceName,
          ElevationName,
          CellGroupName, CurrentModelHandle, DrainLayer, False);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFDrainOnParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetDrainReturnIndexParamType.WriteParamName
            + IntToStr(TimeIndex);
          ReturnIndexNames.Add(TimeParamName);
          ReturnIndexIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetDrainReturnFractionParamType.WriteParamName
            + IntToStr(TimeIndex);
          ReturnFractionNames.Add(TimeParamName);
          RetrunFractionIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACENames.Add(TimeParamName);
            IFACEIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; //  if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
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

              IsParam := False;
              if not frmMODFLOW.cbAltDrt.Checked then
              begin
                ContourConductance := Contour.GetFloatParameter
                  (CurrentModelHandle,ConductanceIndex);
                ADrain.Elevation := Contour.GetFloatParameter
                  (CurrentModelHandle,ElevationIndex);
                IsParam := Contour.GetBoolParameter(CurrentModelHandle,
                  IsParamIndex);
                if IsParam then
                begin
                  ParameterName := Contour.GetStringParameter(
                    CurrentModelHandle,ParamNameIndex);
                  InstanceLimit := GetParameterInstanceCount(ParameterName);
                end; // if IsParam then
                ADrain.CellGroupNumber := Contour.GetIntegerParameter
                  (CurrentModelHandle,CellGroupNumberIndex);
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
                if frmMODFLOW.cbAltDrt.Checked then
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
                  if frmModflow.cbCondDrnRtn.Checked then
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
                    ParameterName := GridLayer.StringValueAtXY(
                      CurrentModelHandle, X, Y, LayerName + '.' + ParamName);
                    InstanceLimit := GetParameterInstanceCount(ParameterName);
                  end; // if IsParam then
                  ADrain.CellGroupNumber := GridLayer.IntegerValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + CellGroupName);
                end
                else // if frmMODFLOW.cbAltDrn.Checked then
                begin
                  if frmModflow.cbCondDrnRtn.Checked then
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
                    if frmMODFLOW.cbAltDrt.Checked then
                    begin
                      ADrain.Elevation := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ElevationName);
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
                      ADrain.ReturnIndex  := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + ReturnIndexNames[StressPeriodIndex]);
                      ADrain.ReturnFraction  := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + ReturnFractionNames[StressPeriodIndex]);
                      if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                      begin
                        ADrain.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                      end; // if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                    end
                    else // if frmMODFLOW.cbAltDrn.Checked then
                    begin
    //                  ADrainRecord.Elevation := Contour.GetFloatParameter(CurrentModelHandle,StageIndicies[0]);
                      // set Elevation here
                      ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                      ADrain.ReturnIndex  := Contour.GetIntegerParameter
                        (CurrentModelHandle,ReturnIndexIndicies[StressPeriodIndex]);
                      ADrain.ReturnFraction  := Contour.GetFloatParameter
                        (CurrentModelHandle,RetrunFractionIndicies[StressPeriodIndex]);
                      if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                      begin
                        ADrain.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end;  // if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                    end;
                    AddParameterNameCell(ParameterName,ADrain, StressPeriodIndex);
                  end;
                end
                else // if IsParam then
                begin
                  if frmMODFLOW.cbAltDrt.Checked then
                  begin
                    ADrain.Elevation := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + ElevationName);
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
                  end
                  else
                  begin
                    ADrain.Elevation := Contour.GetFloatParameter(CurrentModelHandle,
                      ElevationIndex);
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
                  end;
                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    Used := Contour.GetFloatParameter
                      (CurrentModelHandle,IsOnIndicies[StressPeriodIndex]) <> 0;
                    if Used then
                    begin
                      if frmMODFLOW.cbAltDrt.Checked then
                      begin
                        ADrain.ReturnIndex  := GridLayer.IntegerValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.'
                          + ReturnIndexNames[StressPeriodIndex]);
                        ADrain.ReturnFraction  := GridLayer.RealValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.'
                          + ReturnFractionNames[StressPeriodIndex]);
                        if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                        begin
                          ADrain.IFACE := GridLayer.IntegerValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                        end; // if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                      end
                      else
                      begin
                        ADrain.ReturnIndex  := Contour.GetIntegerParameter
                          (CurrentModelHandle,ReturnIndexIndicies[StressPeriodIndex]);
                        ADrain.ReturnFraction  := Contour.GetFloatParameter
                          (CurrentModelHandle,RetrunFractionIndicies[StressPeriodIndex]);
                        if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
                        begin
                          ADrain.IFACE := Contour.GetIntegerParameter
                            (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                        end; // if ModflowTypes.GetMFLineDrainReturnLayerType.UseIFACE then
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
      ReturnIndexNames.Free;
      ReturnFractionNames.Free;
    end;
    if DrainErrors.Count > 0 then
    begin
      AString := 'Warning:  In Drain Return package, some line drains extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Drains below the bottom of the unit will be treated as if they '
        + 'are at the bottom of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := 'Drains above the top of the unit will be treated as if they '
        + 'are at the top of the unit.';
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

procedure TDrainReturnPkgWriter.EvaluateAreaDrainReturnLayer(const
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
//  ReturnIndexIndex, ReturnFractionIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ReturnIndexIndicies : array of Integer;
  RetrunFractionIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ADrain : TDrainReturnRecord;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  DrainList : TDrainReturnList;
  ContourConductance : double;
  ContourIntersectArea : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, ElevationName, CellGroupName: string;
//  ReturnIndexName, ReturnFractionName : string;
//  StageNames : TStringList;
  IsOnNames : TStringList;
  IFACENames : TStringList;
  ReturnIndexNames : TStringList;
  ReturnFractionNames : TStringList;
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
begin
  // area drains
  if frmModflow.cbUseAreaDrainReturns.Checked then
  begin
    DrainErrors := TStringList.Create;
    try
      StressPeriodCount := frmModflow.dgTime.RowCount -1;
      if frmMODFLOW.comboDrtSteady.ItemIndex = 0 then
      begin
        StressPeriodCount := 1;
      end;
      SetLength(IsOnIndicies,StressPeriodCount);
      SetLength(ReturnIndexIndicies,StressPeriodCount);
      SetLength(RetrunFractionIndicies,StressPeriodCount);
      if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
      begin
        SetLength(IFACEIndicies,StressPeriodCount);
      end;

      LayerName := ModflowTypes.GetMFAreaDrainReturnLayerType.WriteNewRoot
        + IntToStr(UnitIndex);
      AddVertexLayer(CurrentModelHandle,LayerName);
      SetAreaValues;
      LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
      DrainLayer := TLayerOptions.Create(LayerHandle);
      GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    //  StageNames := TStringList.Create;
    //  ConcentrationNames := TStringList.Create;
      IFACENames := TStringList.Create;
      ReturnIndexNames := TStringList.Create;
      ReturnFractionNames := TStringList.Create;
      IsOnNames := TStringList.Create;
      try
        IFACENames.Capacity := StressPeriodCount;
        ReturnIndexNames.Capacity := StressPeriodCount;
        ReturnFractionNames.Capacity := StressPeriodCount;
        IsOnNames.Capacity := StressPeriodCount;

        GetParamIndicies(IsParamIndex, ParamNameIndex,
          ConductanceIndex, ElevationIndex,
          CellGroupNumberIndex, IsParamName, ParamName,
          ConductanceName,
          ElevationName, CellGroupName,
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

          TimeParamName := ModflowTypes.GetDrainReturnIndexParamType.WriteParamName
            + IntToStr(TimeIndex);
          ReturnIndexNames.Add(TimeParamName);
          ReturnIndexIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetDrainReturnFractionParamType.WriteParamName
            + IntToStr(TimeIndex);
          ReturnFractionNames.Add(TimeParamName);
          RetrunFractionIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACENames.Add(TimeParamName);
            IFACEIndicies[TimeIndex -1] := DrainLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; //  if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
        end; // for TimeIndex := 1 to StressPeriodCount do

        ContourCount := DrainLayer.NumObjects(CurrentModelHandle,pieContourObject);
        if frmModflow.cbAltDrt.Checked then
        begin
          frmProgress.pbActivity.Max :=
            Discretization.NCOL * Discretization.NROW;
        end
        else
        begin
          frmProgress.pbActivity.Max := Discretization.NCOL
            * Discretization.NROW * ContourCount;
          if not frmModflow.cbAreaDrainRetrunContour.Checked then
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
            if not frmModflow.cbAltDrt.Checked then
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

                      ADrain.Row := RowIndex;
                      ADrain.Column := ColIndex;
                      Top := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex-1];
                      Bottom := Discretization.Elevations[ADrain.Column-1,ADrain.Row-1,UnitIndex];
                      if frmModflow.cbCondDrnRtn.Checked then
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
                          ADrain.ReturnIndex := Contour.GetIntegerParameter
                            (CurrentModelHandle,ReturnIndexIndicies[StressPeriodIndex]);
                          ADrain.ReturnFraction := Contour.GetFloatParameter
                            (CurrentModelHandle,RetrunFractionIndicies[StressPeriodIndex]);
                          if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
                          begin
                            ADrain.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end;  // if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
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
                            ADrain.ReturnIndex := Contour.GetIntegerParameter
                              (CurrentModelHandle,ReturnIndexIndicies[StressPeriodIndex]);
                            ADrain.ReturnFraction := Contour.GetFloatParameter
                              (CurrentModelHandle,RetrunFractionIndicies[StressPeriodIndex]);
                          end
                          else
                          begin
                            ADrain.CondFact := 0;
                            ADrain.ReturnIndex := 0;
                            ADrain.ReturnFraction := 0;
                          end;
                          if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
                          begin
                            ADrain.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end; // if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
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

            if frmModflow.cbAreaDrainRetrunContour.Checked then
            begin
              // only use contours.
              Continue;
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;

            if frmModflow.cbAltDrt.Checked then
            begin
              CellArea := GGetCellArea(ColIndex,RowIndex);
            end
            else
            begin
              CellArea := GContourIntersectCellRemainder(ColIndex,RowIndex);
            end;
            if (CellArea > 0) and
              (frmModflow.cbAltDrt.Checked or not AreaBoundaryInBlock) then
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
                if frmModflow.cbCondDrnRtn.Checked then
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
                      ADrain.ReturnIndex := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, LayerName + '.' + ReturnIndexNames[StressPeriodIndex]);
                      ADrain.ReturnFraction := GridLayer.RealValueAtXY
                        (CurrentModelHandle,X,Y, LayerName + '.' + ReturnFractionNames[StressPeriodIndex]);
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                      ADrain.ReturnIndex := 0;
                      ADrain.ReturnFraction := 0;
                    end;
                    if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
                    begin
                      Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                      ADrain.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                    end;  // if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
                    AddParameterNameCell(ParameterName,ADrain,StressPeriodIndex);
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
                      Expression := LayerName + '.' + ReturnIndexNames[StressPeriodIndex];
                      ADrain.ReturnIndex := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                      Expression := LayerName + '.' + ReturnFractionNames[StressPeriodIndex];
                      ADrain.ReturnFraction := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    end
                    else
                    begin
                      ADrain.CondFact := 0;
                      ADrain.ReturnIndex := 0;
                      ADrain.ReturnFraction := 0;
                    end;
                    ADrain.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, ADrain.Elevation);
                    if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
                    begin
                      Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                      ADrain.IFACE := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    end; // if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
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
        ReturnIndexNames.Free;
        ReturnFractionNames.Free;
      end;
      if DrainErrors.Count > 0 then
      begin
        AString := 'Warning: In Drain Return package, some area drains extend outside of the geologic '
          + 'unit in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'Drains below the bottom of the unit will be treated as if they '
          + 'are at the bottom of the unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := 'Drains above the top of the unit will be treated as if they '
          + 'are at the top of the unit.';
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

procedure TDrainReturnPkgWriter.EvaluateDataSets5and6(
  const CurrentModelHandle: ANE_PTR; Discretization : TDiscretizationWriter);
var
  UnitIndex : integer;
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try

    EvaluateDrainReturnLocations(CurrentModelHandle, ProjectOptions,
      Discretization);

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
          frmProgress.lblActivity.Caption := 'Evaluating Point Return Drains in Unit ' + IntToStr(UnitIndex);
          EvaluatePointDrainReturnLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // line drains
          frmProgress.lblActivity.Caption := 'Evaluating Line Return Drains in Unit ' + IntToStr(UnitIndex);
          EvaluateLineDrainReturnLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area drains
          frmProgress.lblActivity.Caption := 'Evaluating Area Return Drains in Unit ' + IntToStr(UnitIndex);
          EvaluateAreaDrainReturnLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
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

procedure TDrainReturnPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
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
    DrainTimes.Add(TDrainReturnList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS *3 ;
  frmProgress.pbPackage.Position := 0;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Drain Return';
    Application.ProcessMessages;

    EvaluateDataSets5and6(CurrentModelHandle, Discretization);
  end;

  if ContinueExport then
  begin
    SortDrains;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsDRT;
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
{      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 2';
        WriteDataSet2;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;    }
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Sets 2 and 3';
        WriteDataSets2And3;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDatasets4To6;
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
      + ' contours in the DRT (drain-return) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the DRT (drain-return) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the DRT (drain-return) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TDrainReturnPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
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
    DrainTimes.Add(TDrainReturnList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 2 ;
  frmProgress.pbPackage.Position := 0;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Drain Return';
    Application.ProcessMessages;

    EvaluateDataSets5and6(CurrentModelHandle, Discretization);
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
      + ' contours in the DRT (drain-return) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the DRT (drain-return) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the DRT (drain-return) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TDrainReturnPkgWriter.AddParameterNames;
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgDRTParametersN.RowCount -1 do
  begin
    AddParameterName(RowIndex);
  end;

end;

procedure TDrainReturnPkgWriter.AddParameterName(RowIndex : integer);
var
  ParamIndex : integer;
  AParamValue : TDrainReturnParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgDRTParametersN.Cells[0,RowIndex]);
  ParamIndex := ParameterNames.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TDrainReturnParamValue.Create(RowIndex);
    ParameterNames.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different drain-return parameters with the same name: ' + ParameterName
      + ' in the Drain-Return boundary package.  Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create
//      ('Error: Two different drain parameters with the same name: '
//      + '"ParameterName".');
  end;
end;

procedure TDrainReturnPkgWriter.WriteDataSet1;
var
  NPDRT : integer;
  ParamIndex : integer;
  AParam : TDrainReturnParamValue;
  ParamErrors : TStringList;
  AString : string;
  Index, MXADRT, IDRTCB : integer;
  ADrainList : TDrainReturnList;
  Option : string;
begin
  ParamErrors := TStringList.Create;
  try
    MXL := 0;
    NPDRT := 0;
    if ParameterNames.Count > 0 then
    begin
      for ParamIndex := 0 to ParameterNames.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AParam := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
        if AParam.Instances.Count > 0 then
        begin
          ADrainList := AParam.Instances.Objects[0] as TDrainReturnList;
          MXL := MXL + ADrainList.Count * AParam.Instances.Count;
        end
        else
        begin
          MXL := MXL + AParam.DrainList.Count;
        end;
//        MXL := MXL + AParam.DrainList.Count;
        if AParam.DrainList.Count > 0 then
        begin
          Inc(NPDRT);
        end
        else
        begin
          ParamErrors.Add(ParameterNames[ParamIndex]);
        end;
      end;
//      Writeln(FFile, 'PARAMETER ', NPDRT, ' ', MXL);
    end;

    MXADRT := 0;
    for Index := 0 to DrainTimes.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      ADrainList := DrainTimes[Index];
      if ADrainList.Count > MXADRT then
      begin
        MXADRT := ADrainList.Count
      end;
    end;
    MXADRT := MXADRT + MXL;
    if frmModflow.cbFlowDrt.Checked or frmModflow.cbOneFlowFile.Checked then
    begin
      if frmModflow.cbOneFlowFile.Checked then
      begin
        IDRTCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        IDRTCB := frmModflow.GetUnitNumber('DRTBUD');
      end;
    end
    else
    begin
        IDRTCB := 0;
    end;
    Option := ' RETURNFLOW';
    if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
    begin
      Option := Option + ' AUXILIARY IFACE'
    end;
    if frmModflow.cbMOC3D.Checked then
    begin
      Option := Option + ' CBCALLOCATE AUXILIARY CONCENTRATION'
    end;
    if not frmModflow.cbPrintCellLists.Checked then
    begin
      Option := Option + ' NOPRINT';
    end;
    Writeln(FFile, MXADRT, ' ', IDRTCB, ' ', NPDRT, ' ', MXL, Option);

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

procedure TDrainReturnPkgWriter.WriteDataSets2And3;
const
  PARTYP = '''DRT'' ';
var
  ParamIndex, DrainIndex, InstanceIndex : integer;
  AParam : TDrainReturnParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  ADrain : TDrainReturn;
  DrainList : TDrainReturnList;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    PARNAM := ParameterNames[ParamIndex];
    AParam := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
    Parval := AParam.Value;
    if AParam.Instances.Count > 0 then
    begin
      DrainList := AParam.Instances.Objects[0] as TDrainReturnList;
    end
    else
    begin
      DrainList := AParam.DrainList;
    end;

    NLST := DrainList.Count;
//    NLST := AParam.DrainList.Count;
    if NLST > 0 then
    begin
      WriteLn(FFile, '''', PARNAM, ''' ', PARTYP, ' ', FreeFormattedReal(Parval), NLST);
      if AParam.Instances.Count > 0 then
      begin
        for InstanceIndex := 0 to AParam.Instances.Count-1 do
        begin
          Writeln(FFile, AParam.Instances[InstanceIndex]);
          DrainList := AParam.Instances.Objects[InstanceIndex] as TDrainReturnList;
          for DrainIndex := 0 to DrainList.Count -1 do
          begin
            if not ContinueExport then break;
            Application.ProcessMessages;
            ADrain := DrainList[DrainIndex] as TDrainReturn;
            ADrain.WriteDrainReturn(self);
          end;
        end;
      end
      else
      begin
        for DrainIndex := 0 to AParam.DrainList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          ADrain := AParam.DrainList[DrainIndex] as TDrainReturn;
          ADrain.WriteDrainReturn(self);
        end;
      end;
    end;
  end;
end;

procedure TDrainReturnPkgWriter.WriteDatasets4To6;
var
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    if not ContinueExport then break;
    frmProgress.lblActivity.Caption := 'Writing Data Set 4 in Stress Period '
      + IntToStr(StressPeriodIndex);
    WriteDataSet4(StressPeriodIndex);
    Application.ProcessMessages;
    if ITMP > 0 then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 5 in Stress Period '
        + IntToStr(StressPeriodIndex);
      WriteDataSet5(StressPeriodIndex);
      Application.ProcessMessages;
    end;
    if NP > 0 then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 6 in Stress Period '
        + IntToStr(StressPeriodIndex);
      WriteDataSet6(StressPeriodIndex);
      Application.ProcessMessages;
    end;
  end;


end;

procedure TDrainReturnPkgWriter.SortDrains;
var
  ParamIndex, InstanceIndex : integer;
  AParam : TDrainReturnParamValue;
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  DrainList : TDrainReturnList;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting Drains';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParameterNames.Count + StressPeriodCount;

  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
    AParam.DrainList.Sort;
    for InstanceIndex := 0 to AParam.Instances.Count -1 do
    begin
      DrainList := AParam.Instances.Objects[InstanceIndex] as TDrainReturnList;
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


procedure TDrainReturnPkgWriter.WriteDataSet4(StressPeriodIndex: integer);
var
  DrainList : TDrainReturnList;
  ParamIndex : integer;
  AParam : TDrainReturnParamValue;
begin
  DrainList := DrainTimes[StressPeriodIndex];
  ITMP := DrainList.Count;
  if (StressPeriodIndex >= 1) and (frmMODFLOW.comboDrtSteady.ItemIndex = 0) then
  begin
    ITMP := -1;
  end;
  NP := 0;
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Inc(NP);
    end;
  end;
  WriteLn(FFile, ITMP, ' ', NP);
end;

procedure TDrainReturnPkgWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  DrainList : TDrainReturnList;
  ADrain : TDrainReturn;
  DrainIndex : integer;
begin
  DrainList := DrainTimes[StressPeriodIndex];
  for DrainIndex := 0 to DrainList.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    ADrain := DrainList[DrainIndex] as TDrainReturn;
    ADrain.WriteDrainReturn(self);
  end;
end;

procedure TDrainReturnPkgWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  ParamIndex : integer;
  AParam : TDrainReturnParamValue;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] and (AParam.DrainList.Count > 0) then
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

function TDrainReturnPkgWriter.BoundaryUsed(Layer, Row,
  Column: integer): boolean;
var
  ListIndex, InstanceIndex : integer;
  DrainList : TDrainReturnList;
  ADrain : TDrainReturn;
  AParamValue : TDrainReturnParamValue;
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
    AParamValue := ParameterNames.Objects[Index] as TDrainReturnParamValue;
    ADrain := AParamValue.DrainList.GetDrainByLocation(Layer, Row, Column);
    result := ADrain <> nil;
    if result then Exit;
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      DrainList := AParamValue.Instances.Objects[InstanceIndex] as TDrainReturnList;
      ADrain := DrainList.GetDrainByLocation(Layer, Row, Column);
      result := ADrain <> nil;
      if result then Exit;
    end;
  end;

end;

constructor TDrainReturnPkgWriter.Create;
begin
  inherited;
  PointErrors := 0;
  LineErrors := 0;
  AreaErrors := 0;
  ParameterNames := TStringList.Create;
  DrainTimes := TList.Create;
  DrainReturnLocationList := TDrainReturnLocationList.Create;
end;

destructor TDrainReturnPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TDrainReturnParamValue;
  ADrainList : TDrainReturnList;
begin
  for Index := ParameterNames.Count -1 downto 0 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TDrainReturnParamValue;
    AParamValue.Free;
  end;
  ParameterNames.Free;

  for Index := DrainTimes.Count -1 downto 0 do
  begin
    ADrainList := DrainTimes[Index];
    ADrainList.Free;
  end;
  DrainTimes.Free;
  DrainReturnLocationList.Free;
  inherited;

end;

procedure TDrainReturnPkgWriter.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index, InstanceIndex : integer;
  AParamValue : TDrainReturnParamValue;
  DrainList : TDrainReturnList;
begin
  if DrainTimes.Count > 0 then
  begin
    DrainList := DrainTimes[0];
    DrainList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TDrainReturnParamValue;
    AParamValue.DrainList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      DrainList := AParamValue.Instances.Objects[InstanceIndex] as TDrainReturnList;
      DrainList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    end;
  end;

end;


class procedure TDrainReturnPkgWriter.AssignUnitNumbers;
begin
    if frmModflow.cbFlowDrt.Checked or frmModflow.cbOneFlowFile.Checked then
    begin
      if frmModflow.cbOneFlowFile.Checked then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('DRTBUD');
      end;
    end;
end;

procedure TDrainReturnPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  ParamIndex, InstanceIndex : integer;
  AParam : TDrainReturnParamValue;
  DrainList : TDrainReturnList;
  InstanceName : string;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TDrainReturnParamValue;

    if AParam.Instances.Count > 0 then
    begin
      InstanceName := AParam.InstanceNamesUsed[StressPeriod -1];
      InstanceIndex := AParam.Instances.IndexOf(InstanceName);
      if  InstanceIndex >= 0 then
      begin
        DrainList := AParam.Instances.Objects[InstanceIndex] as TDrainReturnList;
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

{ TDrainReturnParamValue }

constructor TDrainReturnParamValue.Create(RowIndex : Integer);
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
  AStringGrid := frmModflow.sg3dRIVParamInstances.Grids[RowIndex-1];
  for InstanceIndex := 1 to AStringGrid.RowCount -1 do
  begin
    Instances.AddObject(AStringGrid.Cells[0,InstanceIndex], TDrainReturnList.Create);
  end;

  DrainList := TDrainReturnList.Create;
  for TimeIndex := 0 to StressPeriodCount -1 do
  begin
    dgColumn := TimeIndex + 4;
    StressPeriodsUsed[TimeIndex]
      := (frmModflow.dgDRTParametersN.Cells[dgColumn,RowIndex]
          <> frmModflow.dgDRTParametersN.Columns[dgColumn].PickList[0]);
    InstanceNamesUsed[TimeIndex] := frmModflow.dgRIVParametersN.
      Cells[dgColumn,RowIndex];
  end;
  Value := InternationalStrToFloat(frmModflow.dgDRTParametersN.Cells[2,RowIndex]);
end;

destructor TDrainReturnParamValue.Destroy;
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

{ TDrainReturnList }

function TDrainReturnList.Add(ADrain: TDrainReturnRecord): integer;
var
  DrainObject : TDrainReturn;
  Index : integer;
begin
  for Index := 0 to Count -1 do
  begin
    DrainObject := Items[Index] as TDrainReturn;
    With DrainObject do
    begin
    if (Drain.Layer = ADrain.Layer) and
       (Drain.Row = ADrain.Row) and
       (Drain.Column = ADrain.Column) and
       (Drain.Elevation = ADrain.Elevation) and
       (Drain.IFACE = ADrain.IFACE) and
       (Drain.CellGroupNumber = ADrain.CellGroupNumber) and
       (Drain.ReturnIndex = ADrain.ReturnIndex) and
       (Drain.ReturnFraction = ADrain.ReturnFraction) then
       begin
         Drain.CondFact := Drain.CondFact + ADrain.CondFact;
         result := Index;
         Exit;
       end;
    end;
  end;
  DrainObject := TDrainReturn.Create;
  result := Add(DrainObject);
  DrainObject.Drain := ADrain;
end;

procedure TDrainReturnList.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index : integer;
  ADrain : TDrainReturn;
begin
  for Index := 0 to Count -1 do
  begin
    ADrain := Items[Index] as TDrainReturn;
    if (ADrain.Drain.Layer = Layer) and (ADrain.Drain.Row = Row)
      and (ADrain.Drain.Column = Column) then
    begin
      BoundaryList.Add(TBoundaryCell.Create(ADrain.Drain.CellGroupNumber));
    end;
  end;
end;

function TDrainReturnList.GetDrainByLocation(Layer, Row, Column: integer): TDrainReturn;
var
  Index : integer;
  ADrain : TDrainReturn;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ADrain := Items[Index] as TDrainReturn;
    if (ADrain.Drain.Layer = Layer) and (ADrain.Drain.Row = Row)
      and (ADrain.Drain.Column = Column) then
    begin
      result := ADrain;
      Exit;
    end;
  end;
end;

procedure TDrainReturnList.Sort;
begin
  inherited Sort(DrainSortFunction);
end;


{ TDrain }

procedure TDrainReturn.WriteDrainReturn(DrainWriter : TDrainReturnPkgWriter);
var
  DrainReturnLocation : TDrainReturnLocation;
begin
  DrainReturnLocation := nil;
  if Drain.ReturnIndex <> 0 then
  begin
    DrainReturnLocation := DrainWriter.DrainReturnLocationList.
      GetDrainByReturnIndex(Drain.ReturnIndex);
  end;


  Write(DrainWriter.FFile, Drain.Layer, ' ',  Drain.Row, ' ',  Drain.Column, ' ',
    DrainWriter.FreeFormattedReal(Drain.Elevation),
    DrainWriter.FreeFormattedReal(Drain.CondFact));

  if DrainReturnLocation = nil then
  begin
    Write(DrainWriter.FFile, '1 1 1 0. ');
  end
  else
  begin
    Write(DrainWriter.FFile, DrainReturnLocation.Drain.Layer, ' ',
      DrainReturnLocation.Drain.Row, ' ',  DrainReturnLocation.Drain.Column, ' ',
      DrainWriter.FreeFormattedReal(Drain.ReturnFraction));
  end;
  if ModflowTypes.GetMFAreaDrainReturnLayerType.UseIFACE then
  begin
    Write(DrainWriter.FFile, ' ',  Drain.IFACE);
  end;
  WriteLn(DrainWriter.FFile);
end;

procedure TDrainReturnList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  ADrain : TDrainReturn;
begin
  for Index := 0 to Count -1 do
  begin
    ADrain := Items[Index] as TDrainReturn;
    ADrain.WriteMT3DConcentrations(Lines);
  end;
end;

{ TDrainReturnLocationList }

function TDrainReturnLocationList.Add(
  ADrain: TDrainReturnLocationRecord): integer;
var
  DrainObject : TDrainReturnLocation;
  Index : integer;
begin
  for Index := 0 to Count -1 do
  begin
    DrainObject := Items[Index] as TDrainReturnLocation;
    With DrainObject do
    begin
    if (Drain.Layer = ADrain.Layer) and
       (Drain.Row = ADrain.Row) and
       (Drain.Column = ADrain.Column) and
       (Drain.ReturnIndex = ADrain.ReturnIndex) then
       begin
         result := Index;
         Exit;
       end;
    end;
  end;
  DrainObject := TDrainReturnLocation.Create;
  result := Add(DrainObject);
  DrainObject.Drain := ADrain;
end;

function TDrainReturnLocationList.GetDrainByReturnIndex(
  ReturnIndex: integer): TDrainReturnLocation;
var
  Index : Integer;
  ADrainReturnLocation : TDrainReturnLocation;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ADrainReturnLocation := Items[Index] as TDrainReturnLocation;
    if ADrainReturnLocation.Drain.ReturnIndex = ReturnIndex then
    begin
      result := ADrainReturnLocation;
      Exit;
    end;
  end;
end;

procedure TDrainReturn.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  ALine := TModflowWriter.FixedFormattedInteger(Drain.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Drain.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Drain.Column, 10)
    + TModflowWriter.FixedFormattedReal(0, 10)
    + TModflowWriter.FixedFormattedInteger(28, 10) + ' ';
  for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal(0);
  end;
  Lines.Add(ALine);
end;

end.
