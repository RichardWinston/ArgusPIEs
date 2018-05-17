unit WriteCHDUnit;

interface

uses Sysutils, Classes, contnrs, Grids, Forms, ANEPIE, OptionsUnit,
  WriteModflowDiscretization, CopyArrayUnit, WriteBFLX_Unit;

type
  TCHDRecord = record
    Layer, Row, Column : integer;
    Shead, Ehead : double;
    IFACE : integer;
    Concentration : double;
    MT3D_Concentrations : T1DDoubleArray;
    SeawatOption: integer;
    Density: double;
  end;

  TCHDParamIndicies = record
    IsParamIndex: ANE_INT16;
    ParamNameIndex: ANE_INT16;
    ElevationIndex: ANE_INT16;
    IsParamName: string;
    ParamNameName: string;
    ElevationName: string;
  end;

  TCHDTimeParamIndicies = record
    SheadIndex: ANE_INT16;
    EHeadIndex: ANE_INT16;
    IFaceIndex: ANE_INT16;
    ConcentrationIndex: ANE_INT16;
    MT3D_ConcentrationIndicies : array of ANE_INT16;
    SeawatOptionIndex: ANE_INT16;
    DensityIndex: ANE_INT16;
    SheadName: string;
    EHeadName: string;
    IFaceName: string;
    ConcentrationName: string;
    MT3D_ConcentrationNames : array of string;
    SeawatOptionName: string;
    DensityName: string;
  end;

  TCHD_Cell = class;

  TCHDList = Class(TObjectList)
  private
    function Add(A_Cell : TCHDRecord) : integer; overload;
    procedure FillBoundaryList(Layer, Row, Column: integer;
      BoundaryList: TObjectList);
    function GetCHDByLocation(Layer, Row, Column: integer): TCHD_Cell;
    procedure Sort;
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  end;

  TCHDParamValue = Class(TObject)
  private
    Value : double;
    StressPeriodsUsed: Array of boolean;
    InstanceNamesUsed: array of string;
    CHDList : TCHDList;
    Instances : TStringList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  TCHDPkgWriter = class(TCustomBoundaryWriterWithObservations)
  private
    ParameterNames : TStringList;
    CHD_Times : TList;
    MXL : integer;
    ITMP, NP : integer;
    PointLineContourErrors, AreaContourErrors: integer;
    SpeciesCount : integer;
    SeawatOption1Used: boolean;
    Procedure AddParameterName(RowIndex : integer);
    Procedure AddParameterNameCell(ParameterName : string;
      A_Cell : TCHDRecord; Const Instance : integer);
    procedure AddParameterNames;
    procedure EvaluateAreaCHDLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateDataSets6and7(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure EvaluatePointLineCHDLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(var Indicies: TCHDParamIndicies;
      const CurrentModelHandle: ANE_PTR; CHDLayer : TLayerOptions);
    procedure GetTimeParamIndicies(var Indicies: TCHDTimeParamIndicies;
      const CurrentModelHandle: ANE_PTR; CHDLayer : TLayerOptions;
      const StressPeriod : integer);
    function GetParameterInstanceCount(const ParameterName: string): integer;
    procedure SortCells;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    procedure WriteDataSet7(StressPeriodIndex : integer);
    procedure WriteDataSets3And4;
    procedure WriteDatasets5To7;
    procedure RecordIFACE_Parameters(const BFLX_Writer: TBFLX_Writer);
    procedure RecordIFACE_Normal(const BFLX_Writer: TBFLX_Writer);
  public
    function BoundaryUsed(Layer, Row, Column : integer) : boolean; override;
    constructor Create;
    destructor Destroy; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    Procedure FillBoundaryList(Layer, Row, Column : integer;
      BoundaryList : TObjectList); override;
    procedure RecordIFACE(const BFLX_Writer: TBFLX_Writer);
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines : TStrings);
  end;

  TCHD_Cell = class(TObject)
  private
    Cell : TCHDRecord;
    procedure WriteCell(CHDWriter : TCHDPkgWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;

implementation

uses Variables, ProgressUnit, GetCellUnit, ModflowLayerFunctions,
  PointInsideContourUnit, WriteNameFileUnit, UtilityFunctions, ANE_LayerUnit;

function CHDSortFunction(Item1, Item2: Pointer): Integer;
var
  Cell1, Cell2 : TCHD_Cell;
begin
  Cell1 := Item1;
  Cell2 := Item2;
  result := Cell1.Cell.Layer - Cell2.Cell.Layer;
  if Result <> 0 then Exit;
  result := Cell1.Cell.Row - Cell2.Cell.Row;
  if Result <> 0 then Exit;
  result := Cell1.Cell.Column - Cell2.Cell.Column;
end;

{ TCHDList }

function TCHDList.Add(A_Cell: TCHDRecord): integer;
var
  CHDObject : TCHD_Cell;
  Index : integer;
begin
  for Index := 0 to Count -1 do
  begin
    CHDObject := Items[Index] as TCHD_Cell;
    With CHDObject do
    begin
    if (A_Cell.Layer = Cell.Layer) and
       (A_Cell.Row = Cell.Row) and
       (A_Cell.Column = Cell.Column) then
       begin
         result := Index;
         Exit;
       end;
    end;
  end;
  CHDObject := TCHD_Cell.Create;
  result := Add(CHDObject);
  CHDObject.Cell.Layer := A_Cell.Layer;
  CHDObject.Cell.Row := A_Cell.Row;
  CHDObject.Cell.Column := A_Cell.Column;
  CHDObject.Cell.Shead := A_Cell.Shead;
  CHDObject.Cell.Ehead := A_Cell.Ehead;
  CHDObject.Cell.IFACE := A_Cell.IFACE;
  CHDObject.Cell.Concentration := A_Cell.Concentration;
  Copy1DDoubleArray(A_Cell.MT3D_Concentrations,
    CHDObject.Cell.MT3D_Concentrations);
  CHDObject.Cell.SeawatOption := A_Cell.SeawatOption;
  CHDObject.Cell.Density := A_Cell.Density;
end;

procedure TCHDList.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index : integer;
  A_Cell : TCHD_Cell;
begin
  for Index := 0 to Count -1 do
  begin
    A_Cell := Items[Index] as TCHD_Cell;
    if (A_Cell.Cell.Layer = Layer) and (A_Cell.Cell.Row = Row)
      and (A_Cell.Cell.Column = Column) then
    begin
      BoundaryList.Add(TBoundaryCell.Create(Index));
    end;
  end;
end;

function TCHDList.GetCHDByLocation(Layer, Row, Column: integer): TCHD_Cell;
var
  Index : integer;
  ACell : TCHD_Cell;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TCHD_Cell;
    if (ACell.Cell.Layer = Layer) and (ACell.Cell.Row = Row)
      and (ACell.Cell.Column = Column) then
    begin
      result := ACell;
      Exit;
    end;
  end;
end;

procedure TCHDList.Sort;
begin
  inherited Sort(CHDSortFunction);
end;

procedure TCHDList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  ACell : TCHD_Cell;
begin
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TCHD_Cell;
    ACell.WriteMT3DConcentrations(Lines);
  end;
end;

{ TCHDParamValue }

constructor TCHDParamValue.Create(RowIndex: Integer);
var
//  Index : integer;
  TimeIndex, InstanceIndex : Integer;
  StressPeriodCount : integer;
  dgColumn : integer;
  AStringGrid : TStringGrid;
begin
  Instances := TStringList.Create;
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;
  SetLength(StressPeriodsUsed, StressPeriodCount);
  SetLength(InstanceNamesUsed, StressPeriodCount);
  AStringGrid := frmModflow.sg3dCHDParamInstances.Grids[RowIndex-1];
  for InstanceIndex := 1 to AStringGrid.RowCount -1 do
  begin
    Instances.AddObject(AStringGrid.Cells[0,InstanceIndex], TCHDList.Create);
  end;

  CHDList := TCHDList.Create;
  for TimeIndex := 0 to StressPeriodCount -1 do
  begin
    dgColumn := TimeIndex + 4;
    StressPeriodsUsed[TimeIndex]
      := (frmModflow.dgCHDParameters.Cells[dgColumn,RowIndex]
          <> frmModflow.dgCHDParameters.Columns[dgColumn].PickList[0]);
    InstanceNamesUsed[TimeIndex] := frmModflow.dgCHDParameters.
      Cells[dgColumn,RowIndex];
  end;
  Value := InternationalStrToFloat(frmModflow.dgCHDParameters.Cells[2,RowIndex]);
end;

destructor TCHDParamValue.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to Instances.Count-1 do
  begin
    Instances.Objects[Index].Free;
  end;

  Instances.Free;
  CHDList.Free;
  inherited;
end;

{ TCHD_Cell }

procedure TCHD_Cell.WriteCell(CHDWriter: TCHDPkgWriter);
begin
  Write(CHDWriter.FFile, Cell.Layer, ' ',  Cell.Row, ' ',
    Cell.Column, ' ',
    CHDWriter.FreeFormattedReal(Cell.Shead),
    CHDWriter.FreeFormattedReal(Cell.Ehead));
  if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
  begin
    Write(CHDWriter.FFile, ' ',  Cell.IFACE);
  end;
  if frmModflow.cbSeaWat.Checked then
  begin
    Write(CHDWriter.FFile, ' ',  Cell.SeawatOption,
    ' ', CHDWriter.FreeFormattedReal(Cell.Density));
  end;

  if frmModflow.cbMOC3D.Checked then
  begin
    Write(CHDWriter.FFile, ' ', CHDWriter.FreeFormattedReal(Cell.Concentration));
  end;
  WriteLn(CHDWriter.FFile);

end;

procedure TCHD_Cell.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  Assert(Length(Cell.MT3D_Concentrations) >=1);
  ALine := TModflowWriter.FixedFormattedInteger(Cell.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Cell.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Cell.Column, 10)
    + TModflowWriter.FixedFormattedReal(Cell.MT3D_Concentrations[0], 10)
    + TModflowWriter.FixedFormattedInteger(1, 10) + ' ';
  for SpeciesIndex := 0 to Length(Cell.MT3D_Concentrations)-1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (Cell.MT3D_Concentrations[SpeciesIndex]);
  end;
  Lines.Add(ALine);
end;

{ TCHDPkgWriter }

procedure TCHDPkgWriter.AddParameterName(RowIndex: integer);
var
  ParamIndex : integer;
  AParamValue : TCHDParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgCHDParameters.Cells[0,RowIndex]);
  ParamIndex := ParameterNames.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TCHDParamValue.Create(RowIndex);
    ParameterNames.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different parameters with the same name: ' + ParameterName
      + ' in the Constant-Head Boundary package.  Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end;
end;

procedure TCHDPkgWriter.AddParameterNameCell(ParameterName: string;
  A_Cell: TCHDRecord; const Instance: integer);
var
  ParamIndex : integer;
  AParamValue : TCHDParamValue;
  CHDList : TCHDList;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Constant-Head Boundary package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
    if AParamValue.Instances.Count > 0 then
    begin
      CHDList := AParamValue.Instances.Objects[Instance] as TCHDList;
    end
    else
    begin
      CHDList := AParamValue.CHDList;
    end;
    CHDList.Add(A_Cell);
  end;
end;

procedure TCHDPkgWriter.AddParameterNames;
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgCHDParameters.RowCount -1 do
  begin
    AddParameterName(RowIndex);
  end;
end;

function TCHDPkgWriter.BoundaryUsed(Layer, Row, Column: integer): boolean;
var
  ListIndex, InstanceIndex : integer;
  CHDList : TCHDList;
  ACell : TCHD_Cell;
  AParamValue : TCHDParamValue;
  Index : integer;
begin
  result := False;
  for ListIndex := 0 to CHD_Times.Count -1 do
  begin
    CHDList := CHD_Times[ListIndex];
    ACell := CHDList.GetCHDByLocation(Layer, Row, Column);
    result := ACell <> nil;
    if result then Exit;
  end;

  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TCHDParamValue;
    ACell := AParamValue.CHDList.GetCHDByLocation(Layer, Row, Column);
    result := ACell <> nil;
    if result then Exit;
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      CHDList := AParamValue.Instances.Objects[InstanceIndex] as TCHDList;
      ACell := CHDList.GetCHDByLocation(Layer, Row, Column);
      result := ACell <> nil;
      if result then Exit;
    end;
  end;
end;

constructor TCHDPkgWriter.Create;
begin
  inherited;
  PointLineContourErrors := 0;
  AreaContourErrors := 0;
  ParameterNames := TStringList.Create;
  CHD_Times := TList.Create;
end;

destructor TCHDPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TCHDParamValue;
  ACHDList : TCHDList;
begin
  for Index := ParameterNames.Count -1 downto 0 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TCHDParamValue;
    AParamValue.Free;
  end;
  ParameterNames.Free;

  for Index := CHD_Times.Count -1 downto 0 do
  begin
    ACHDList := CHD_Times[Index];
    ACHDList.Free;
  end;
  CHD_Times.Free;
  inherited;

end;

procedure TCHDPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  Index : integer;
  ErrorMessage : string;
begin
  SeawatOption1Used := False;
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    CHD_Times.Add(TCHDList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 2 ;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Constant-Head Boundary';
    Application.ProcessMessages;

    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
  if ContinueExport then
  begin
    SortCells;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
  if PointLineContourErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaContourErrors)
      + ' contours in the CHD package '
      + 'are closed contours but are on a layer '
      + 'reserved for point or open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaContourErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaContourErrors)
      + ' contours in the CHD package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
end;

procedure TCHDPkgWriter.EvaluateAreaCHDLayer(
  const CurrentModelHandle: ANE_PTR; UnitIndex: integer;
  ProjectOptions: TProjectOptions; Discretization: TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  CHDLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  Indicies : TCHDParamIndicies;
  TimeIndex : integer;
  TimeParamName : string;
  TimeIndicies : array of TCHDTimeParamIndicies;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  A_Cell : TCHDRecord;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  CHDList : TCHDList;
  ContourConductance : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  ColIndex, RowIndex : integer;
  AreaBoundaryInBlock : boolean;
  IsNA : boolean;
  Used : boolean;
  Expression : string;
  TopLayer, BottomLayer, LayerIndex : integer;
  InstanceLimit : integer;
  InContour : boolean;
  SpeciesIndex : integer;
  ContourIntersectArea: double;
  NotNA_Expression: string;
begin
  // area CHD boundaries
  if frmMODFLOW.cbUseAreaCHD.Checked then
  begin
    TopLayer := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex) + 1;
    BottomLayer := TopLayer + frmMODFLOW.DiscretizationCount(UnitIndex) - 1;
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    SetLength(TimeIndicies,StressPeriodCount);
    SetLength(A_Cell.MT3D_Concentrations, SpeciesCount);

    LayerName := ModflowTypes.GetMFAreaCHD_LayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    SetAreaValues;
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    CHDLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      GetParamIndicies(Indicies, CurrentModelHandle, CHDLayer);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        GetTimeParamIndicies(TimeIndicies[TimeIndex-1], CurrentModelHandle,
          CHDLayer, TimeIndex);
      end; // for TimeIndex := 1 to StressPeriodCount do

      ContourCount := CHDLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if frmModflow.cbAltCHD.Checked then
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;
      end
      else
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL
          * Discretization.NROW * ContourCount;
        if not frmModflow.cbAreaCHDContour.Checked then
        begin
          frmProgress.pbActivity.Max := frmProgress.pbActivity.Max +
            Discretization.NCOL * Discretization.NROW;
        end;
      end;

      NotNA_Expression := '(' + LayerName + '.'
        + ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName + '1'
        + '<>' + kNA + ')&(' + LayerName + '.'
        + ModflowTypes.GetMFCHD_EndHeadParamType.ANE_ParamName + '1'
        + '<>' + kNA + ')';

      for ColIndex := 1 to Discretization.NCOL do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        for RowIndex := 1 to Discretization.NROW do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          BlockIndex := Discretization.BlockIndex(RowIndex -1, ColIndex -1);
          ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
            Discretization.GridLayerHandle,BlockIndex);
          try
            ABlock.GetCenter(CurrentModelHandle,X,Y);
          finally
            ABlock.Free;
          end;
          AreaBoundaryInBlock := False;
          if not frmModflow.cbAltCHD.Checked then
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
                  Inc(AreaContourErrors);
                end
                else
                begin
                  InContour := False;
                  ContourIntersectArea := GContourIntersectCell(ContourIndex,
                    ColIndex, RowIndex);
                  if ContourIntersectArea > 0 then
                  {InContour := GPointInsideContour(ContourIndex, X, Y);
                  if InContour then }
                  begin
                    if GridLayer.BooleanValueAtXY(CurrentModelHandle, X, Y,
                      NotNA_Expression) then
                    begin
                      InContour := True;
                      IsParam := Contour.GetBoolParameter(CurrentModelHandle,Indicies.IsParamIndex);
                      if IsParam then
                      begin
                        ParameterName := Contour.GetStringParameter(CurrentModelHandle,Indicies.ParamNameIndex);
                        InstanceLimit := GetParameterInstanceCount(ParameterName);
                      end; // if IsParam then

                      AreaBoundaryInBlock := True;

                      A_Cell.Row := RowIndex;
                      A_Cell.Column := ColIndex;
                      if IsParam then
                      begin
                        for StressPeriodIndex := 0 to InstanceLimit-1 do
                        begin
                          A_Cell.SHead := Contour.GetFloatParameter
                            (CurrentModelHandle,
                            TimeIndicies[StressPeriodIndex].SheadIndex);
                          A_Cell.EHead := Contour.GetFloatParameter
                            (CurrentModelHandle,
                            TimeIndicies[StressPeriodIndex].EheadIndex);
                          if frmMODFLOW.cbSeaWat.Checked then
                          begin
                            A_Cell.SeawatOption := Contour.GetIntegerParameter
                              (CurrentModelHandle,
                              TimeIndicies[StressPeriodIndex].SeawatOptionIndex);
                            if A_Cell.SeawatOption = 1 then
                            begin
                              SeawatOption1Used := True;
                              A_Cell.Density := Contour.GetFloatParameter
                                (CurrentModelHandle,
                                TimeIndicies[StressPeriodIndex].DensityIndex);
                            end
                            else
                            begin
                              // Density is not used so set it to a default value.
                              A_Cell.Density := 1025;
                            end;

                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            A_Cell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,
                              TimeIndicies[StressPeriodIndex].ConcentrationIndex);
                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                          begin
                            A_Cell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,
                              TimeIndicies[StressPeriodIndex].IFACEIndex);
                          end;  // if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                          if frmModflow.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 0 to SpeciesCount -1 do
                            begin
                              A_Cell.MT3D_Concentrations[SpeciesIndex]
                                := Contour.GetFloatParameter
                                (CurrentModelHandle, TimeIndicies
                                [StressPeriodIndex].MT3D_ConcentrationIndicies
                                [SpeciesIndex]);
                            end;
                          end;
                          for LayerIndex := TopLayer to BottomLayer do
                          begin
                            A_Cell.Layer := LayerIndex;
                            AddParameterNameCell(ParameterName,A_Cell,StressPeriodIndex);
                          end;
                        end;
                      end
                      else // if IsParam then
                      begin
                        for StressPeriodIndex := 0 to StressPeriodCount-1 do
                        begin
                          if not ContinueExport then break;
                          Application.ProcessMessages;
                          A_Cell.SHead := Contour.GetFloatParameter
                            (CurrentModelHandle,
                            TimeIndicies[StressPeriodIndex].SheadIndex);
                          A_Cell.EHead := Contour.GetFloatParameter
                            (CurrentModelHandle,
                            TimeIndicies[StressPeriodIndex].EheadIndex);
                          if frmMODFLOW.cbSeaWat.Checked then
                          begin
                            A_Cell.SeawatOption := Contour.GetIntegerParameter
                              (CurrentModelHandle,
                              TimeIndicies[StressPeriodIndex].SeawatOptionIndex);
                            if A_Cell.SeawatOption = 1 then
                            begin
                              SeawatOption1Used := True;
                              A_Cell.Density := Contour.GetFloatParameter
                                (CurrentModelHandle,
                                TimeIndicies[StressPeriodIndex].DensityIndex);
                            end
                            else
                            begin
                              // Density is not used so set it to a default value.
                              A_Cell.Density := 1025;
                            end;

                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            A_Cell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,
                              TimeIndicies[StressPeriodIndex].ConcentrationIndex);
                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                          begin
                            A_Cell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,
                              TimeIndicies[StressPeriodIndex].IFACEIndex);
                          end;  // if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                          if frmModflow.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 0 to SpeciesCount -1 do
                            begin
                              A_Cell.MT3D_Concentrations[SpeciesIndex]
                                := Contour.GetFloatParameter
                                (CurrentModelHandle, TimeIndicies
                                [StressPeriodIndex].MT3D_ConcentrationIndicies
                                [SpeciesIndex]);
                            end;
                          end;
                          CHDList := CHD_Times[StressPeriodIndex];
                          for LayerIndex := TopLayer to BottomLayer do
                          begin
                            A_Cell.Layer := LayerIndex;
                            CHDList.Add(A_Cell);
                          end;
                        end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                      end; // if IsParam then else
                    end;
                  end;
                end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
              finally
                Contour.Free;
              end;

            end; // for ContourIndex := 0 to ContourCount -1 do
          end; // if not frmModflow.cbAltGHB.Checked then
          if not ContinueExport then break;

          if frmModflow.cbAreaCHDContour.Checked then
          begin
            // only use contours.
            Continue;
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;


          if (frmModflow.cbAltCHD.Checked or not AreaBoundaryInBlock) then
          begin

            Expression := LayerName + '.' + TimeIndicies[0].SheadName;

            IsNA := GridLayer.BooleanValueAtXY(CurrentModelHandle,X,Y,
              Expression + '=$N/A');
            if not IsNA then
            begin

              Expression := LayerName + '.' + Indicies.IsParamName;

              IsParam := GridLayer.BooleanValueAtXY
                (CurrentModelHandle,X,Y, Expression);
              if IsParam then
              begin
                Expression := LayerName + '.' + Indicies.ParamNameName;

                ParameterName := GridLayer.StringValueAtXY
                  (CurrentModelHandle,X,Y, Expression);
                InstanceLimit := GetParameterInstanceCount(ParameterName);
              end; // if IsParam then

              A_Cell.Row := RowIndex;
              A_Cell.Column := ColIndex;
              if IsParam then
              begin
                for StressPeriodIndex := 0 to InstanceLimit-1 do
                begin
                  begin
                    Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].SHeadName;
                    A_Cell.SHead := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].EHeadName;
                    A_Cell.EHead := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    if frmMODFLOW.cbSeaWat.Checked then
                    begin
                      Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].SeawatOptionName;

                      A_Cell.SeawatOption := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                      if A_Cell.SeawatOption = 1 then
                      begin
                        SeawatOption1Used := True;
                        Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].DensityName;

                        A_Cell.Density := GridLayer.RealValueAtXY
                          (CurrentModelHandle,X,Y, Expression);
                      end
                      else
                      begin
                        A_Cell.Density := 1025;
                      end;
                    end; // if frmMODFLOW.cbSeaWat.Checked then
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].ConcentrationName;

                      A_Cell.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                    begin
                      Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].IFACEName;

                      A_Cell.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                    end;  // if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then  }
                    if frmModflow.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 0 to SpeciesCount -1 do
                      begin
                        Expression := LayerName + '.' + TimeIndicies
                          [StressPeriodIndex].MT3D_ConcentrationNames[SpeciesIndex];

                        A_Cell.MT3D_Concentrations[SpeciesIndex]
                          := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, Expression);
                      end;
                    end;
                    for LayerIndex := TopLayer to BottomLayer do
                    begin
                      A_Cell.Layer := LayerIndex;
                      AddParameterNameCell(ParameterName,A_Cell,StressPeriodIndex);
                    end;

                  end;
                end;
              end
              else // if IsParam then
              begin
                for StressPeriodIndex := 0 to StressPeriodCount-1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;

                  Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].SHeadName;
                  A_Cell.Shead := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].EHeadName;
                  A_Cell.Ehead := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  if frmMODFLOW.cbSeaWat.Checked then
                  begin
                    Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].SeawatOptionName;
                    A_Cell.SeawatOption := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    if A_Cell.SeawatOption = 1 then
                    begin
                      SeawatOption1Used := True;
                      Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].DensityName;
                      A_Cell.Density := GridLayer.RealValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                    end
                    else
                    begin
                      // Density is not used so set it to a default value.
                      A_Cell.Density := 1025;
                    end;
                  end; // if frmMODFLOW.cbSeaWat.Checked then
                  if frmMODFLOW.cbMOC3D.Checked then
                  begin
                    Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].ConcentrationName;
                    A_Cell.Concentration := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                  end; // if frmMODFLOW.cbMOC3D.Checked then
                  if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                  begin
                    Expression := LayerName + '.' + TimeIndicies[StressPeriodIndex].IFACEName;
                    A_Cell.IFACE := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                  end; // if ModflowTypes.GetMFAreaCHD_LayerType.UseIFACE then
                  for SpeciesIndex := 0 to SpeciesCount -1 do
                  begin
                    Expression := LayerName + '.' + TimeIndicies
                      [StressPeriodIndex].MT3D_ConcentrationNames[SpeciesIndex];

                    A_Cell.MT3D_Concentrations[SpeciesIndex]
                      := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, Expression);
                  end;
                  CHDList := CHD_Times[StressPeriodIndex];
                  for LayerIndex := TopLayer to BottomLayer do
                  begin
                    A_Cell.Layer := LayerIndex;
                    CHDList.Add(A_Cell);
                  end;
                end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
              end; // if IsParam then else
            end;
          end;
        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do
    finally
      CHDLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TCHDPkgWriter.EvaluateDataSets6and7(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  UnitIndex : integer;
  ProjectOptions : TProjectOptions;
begin
  if frmModflow.cbMT3D.Checked then
  begin
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  end;
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
        Application.ProcessMessages;
      end
      else
      begin
        if ContinueExport then
        begin
          // point and line constant-head boundaries
          frmProgress.lblActivity.Caption := 'Evaluating point/line constant-head boundaries in Unit ' + IntToStr(UnitIndex);
          EvaluatePointLineCHDLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area constant-head boundaries
          frmProgress.lblActivity.Caption := 'Evaluating area general-head boundaries in Unit ' + IntToStr(UnitIndex);
          EvaluateAreaCHDLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
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

procedure TCHDPkgWriter.EvaluatePointLineCHDLayer(
  const CurrentModelHandle: ANE_PTR; UnitIndex: integer;
  ProjectOptions: TProjectOptions; Discretization: TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  CHDLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  Indicies : TCHDParamIndicies;
  TimeIndicies : array of TCHDTimeParamIndicies;
  TimeIndex : integer;
  TimeParamName : string;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  A_Cell : TCHDRecord;
  CellIndex : integer;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  CHDList : TCHDList;
  ContourShead, ContourEhead : double;
  ContourLength : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Used : boolean;
  TopLayer, BottomLayer, LayerIndex : integer;
  InstanceLimit : integer;
  Elevation : double;
  Top, Bottom : double;
  SpeciesIndex : integer;
begin
  IsParam := False;
  // line CHD boundaries
  TopLayer := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex) + 1;
  BottomLayer := TopLayer + frmMODFLOW.DiscretizationCount(UnitIndex) - 1;
  StressPeriodCount := frmModflow.dgTime.RowCount -1;

  SetLength(TimeIndicies,StressPeriodCount);
  SetLength(A_Cell.MT3D_Concentrations, SpeciesCount);

  LayerName := ModflowTypes.GetMFPointLineCHD_LayerType.WriteNewRoot
    + IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle,LayerName);
  LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
  CHDLayer := TLayerOptions.Create(LayerHandle);
  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    ContourCount := CHDLayer.NumObjects(CurrentModelHandle,pieContourObject);
    if ContourCount > 0 then
    begin
      GetParamIndicies(Indicies, CurrentModelHandle, CHDLayer);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        GetTimeParamIndicies(TimeIndicies[TimeIndex-1], CurrentModelHandle,
          CHDLayer, TimeIndex);
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
          if Contour.ContourType(CurrentModelHandle) = ctClosed then
          begin
            Inc(PointLineContourErrors);
          end
          else
          begin
            if not frmMODFLOW.cbAltCHD.Checked then
            begin
              IsParam := Contour.GetBoolParameter(CurrentModelHandle,
                Indicies.IsParamIndex);
              if IsParam then
              begin
                ParameterName := Contour.GetStringParameter(CurrentModelHandle,
                  Indicies.ParamNameIndex);
                InstanceLimit := GetParameterInstanceCount(ParameterName);
              end; // if IsParam then
            end; // if not frmMODFLOW.cbAltCHD.Checked then

            for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
            begin
              if not ContinueExport then break;
              Application.ProcessMessages;
              A_Cell.Row := GGetCellRow(ContourIndex, CellIndex);
              A_Cell.Column := GGetCellColumn(ContourIndex, CellIndex);
              Top := Discretization.Elevations[A_Cell.Column-1,A_Cell.Row-1,UnitIndex-1];
              Bottom := Discretization.Elevations[A_Cell.Column-1,A_Cell.Row-1,UnitIndex];
              if frmMODFLOW.cbAltCHD.Checked then
              begin
                BlockIndex := Discretization.BlockIndex(A_Cell.Row-1,A_Cell.Column-1);
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  ABlock.GetCenter(CurrentModelHandle, X, Y);
                finally
                  ABlock.Free;
                end;
                Elevation := GridLayer.RealValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.'
                  + Indicies.ElevationName);

                A_Cell.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, Elevation);

                IsParam := GridLayer.BooleanValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.'
                  + Indicies.IsParamName);
                if IsParam then
                begin
                  ParameterName := GridLayer.StringValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.'
                    + Indicies.ParamNameName);
                  InstanceLimit := GetParameterInstanceCount(ParameterName);
                end; // if IsParam then
              end
              else // if frmMODFLOW.cbAltGHB.Checked then
              begin
                Elevation := Contour.GetFloatParameter
                  (CurrentModelHandle, Indicies.ElevationIndex);
                A_Cell.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, Elevation);
              end; // if frmMODFLOW.cbAltGHB.Checked then else
              if IsParam then
              begin
                for StressPeriodIndex := 0 to InstanceLimit-1 do
                begin
                  if frmMODFLOW.cbAltGHB.Checked then
                  begin
                    A_Cell.Shead := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.'
                      + TimeIndicies[StressPeriodIndex].SheadName);
                    A_Cell.Ehead := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.'
                      + TimeIndicies[StressPeriodIndex].EheadName);

                    if frmMODFLOW.cbSeaWat.Checked then
                    begin // if frmMODFLOW.cbMOC3D.Checked then
                      A_Cell.SeawatOption := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + TimeIndicies[StressPeriodIndex].SeawatOptionName);
                      if A_Cell.SeawatOption = 1 then
                      begin
                        SeawatOption1Used := True;
                        A_Cell.Density := GridLayer.RealValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.'
                          + TimeIndicies[StressPeriodIndex].DensityName);
                      end
                      else
                      begin
                        // not used so set to a default value.
                        A_Cell.Density := 1025;
                      end;
                    end;

                    if frmMODFLOW.cbMOC3D.Checked then
                    begin // if frmMODFLOW.cbMOC3D.Checked then
                      A_Cell.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + TimeIndicies[StressPeriodIndex].ConcentrationName);
                    end;
                    if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    begin
                      A_Cell.IFACE := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.'
                      + TimeIndicies[StressPeriodIndex].IFaceName);
                    end; // if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    if frmModflow.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 0 to SpeciesCount -1 do
                      begin
                        A_Cell.MT3D_Concentrations[SpeciesIndex]
                          := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + TimeIndicies[StressPeriodIndex].MT3D_ConcentrationNames[SpeciesIndex]);
                      end;
                    end;
                  end
                  else // if frmMODFLOW.cbAltGHB.Checked then
                  begin
                    A_Cell.Shead := Contour.GetFloatParameter
                      (CurrentModelHandle,
                      TimeIndicies[StressPeriodIndex].SheadIndex);
                    A_Cell.Ehead := Contour.GetFloatParameter
                      (CurrentModelHandle,
                      TimeIndicies[StressPeriodIndex].EheadIndex);
                    if frmMODFLOW.cbSeaWat.Checked then
                    begin
                      A_Cell.SeawatOption := Contour.GetIntegerParameter
                        (CurrentModelHandle,
                        TimeIndicies[StressPeriodIndex].SeawatOptionIndex);
                      if A_Cell.SeawatOption = 1 then
                      begin
                        SeawatOption1Used := True;
                        A_Cell.Density := Contour.GetFloatParameter
                          (CurrentModelHandle,
                          TimeIndicies[StressPeriodIndex].DensityIndex);
                      end
                      else
                      begin
                        // density is not used so set it to a default value.
                        A_Cell.Density := 1025;
                      end;

                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      A_Cell.Concentration := Contour.GetFloatParameter
                        (CurrentModelHandle,
                        TimeIndicies[StressPeriodIndex].ConcentrationIndex);
                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    begin
                      A_Cell.IFACE := Contour.GetIntegerParameter
                        (CurrentModelHandle,
                        TimeIndicies[StressPeriodIndex].IFACEIndex);
                    end;  // if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    if frmModflow.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 0 to SpeciesCount -1 do
                      begin
                        A_Cell.MT3D_Concentrations[SpeciesIndex]
                          := Contour.GetFloatParameter
                          (CurrentModelHandle, TimeIndicies
                          [StressPeriodIndex].MT3D_ConcentrationIndicies
                          [SpeciesIndex]);
                      end;
                    end;
                  end;
                  AddParameterNameCell(ParameterName,A_Cell,StressPeriodIndex);
                end;
              end
              else // if IsParam then
              begin
                for StressPeriodIndex := 0 to StressPeriodCount-1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;
                  if frmMODFLOW.cbAltCHD.Checked then
                  begin
                    A_Cell.Shead := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.'
                      + TimeIndicies[StressPeriodIndex].SheadName);
                    A_Cell.Ehead := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.'
                      + TimeIndicies[StressPeriodIndex].EheadName);
                    if frmMODFLOW.cbSeaWat.Checked then
                    begin // if frmMODFLOW.cbMOC3D.Checked then
                      A_Cell.SeawatOption := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + TimeIndicies[StressPeriodIndex].SeawatOptionName);
                      if A_Cell.SeawatOption = 1 then
                      begin
                        SeawatOption1Used := True;
                        A_Cell.Density := GridLayer.RealValueAtXY
                          (CurrentModelHandle, X, Y, LayerName + '.'
                          + TimeIndicies[StressPeriodIndex].DensityName);
                      end
                      else
                      begin
                        // density is not used so set it to a default value.
                        A_Cell.Density := 1025;
                      end;

                    end;
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin // if frmMODFLOW.cbMOC3D.Checked then
                      A_Cell.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + TimeIndicies[StressPeriodIndex].ConcentrationName);
                    end;
                    if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    begin
                      A_Cell.IFACE := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.'
                      + TimeIndicies[StressPeriodIndex].IFaceName);
                    end; // if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    if frmModflow.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 0 to SpeciesCount -1 do
                      begin
                        A_Cell.MT3D_Concentrations[SpeciesIndex]
                          := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.'
                        + TimeIndicies[StressPeriodIndex].MT3D_ConcentrationNames[SpeciesIndex]);
                      end;
                    end;
                  end
                  else
                  begin
                    A_Cell.Shead := Contour.GetFloatParameter
                      (CurrentModelHandle,
                      TimeIndicies[StressPeriodIndex].SheadIndex);
                    A_Cell.Ehead := Contour.GetFloatParameter
                      (CurrentModelHandle,
                      TimeIndicies[StressPeriodIndex].EheadIndex);
                    if frmMODFLOW.cbSeaWat.Checked then
                    begin
                      A_Cell.SeawatOption := Contour.GetIntegerParameter
                        (CurrentModelHandle,
                        TimeIndicies[StressPeriodIndex].SeawatOptionIndex);
                      if A_Cell.SeawatOption = 1 then
                      begin
                        SeawatOption1Used := True;
                        A_Cell.Density := Contour.GetFloatParameter
                          (CurrentModelHandle,
                          TimeIndicies[StressPeriodIndex].DensityIndex);
                      end
                      else
                      begin
                        // Density is not used so set it to a default value.
                        A_Cell.Density := 1025;
                      end;

                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      A_Cell.Concentration := Contour.GetFloatParameter
                        (CurrentModelHandle,
                        TimeIndicies[StressPeriodIndex].ConcentrationIndex);
                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    begin
                      A_Cell.IFACE := Contour.GetIntegerParameter
                        (CurrentModelHandle,
                        TimeIndicies[StressPeriodIndex].IFACEIndex);
                    end;  // if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
                    if frmModflow.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 0 to SpeciesCount -1 do
                      begin
                        A_Cell.MT3D_Concentrations[SpeciesIndex]
                          := Contour.GetFloatParameter
                          (CurrentModelHandle, TimeIndicies
                          [StressPeriodIndex].MT3D_ConcentrationIndicies
                          [SpeciesIndex]);
                      end;
                    end;
                  end;
                  CHDList := CHD_Times[StressPeriodIndex];
                  CHDList.Add(A_Cell);
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
    CHDLayer.Free(CurrentModelHandle);
    GridLayer.Free(CurrentModelHandle);
  end;
end;

procedure TCHDPkgWriter.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index, InstanceIndex : integer;
  AParamValue : TCHDParamValue;
  CHDList : TCHDList;
begin
  if CHD_Times.Count > 0 then
  begin
    CHDList := CHD_Times[0];
    CHDList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TCHDParamValue;
    AParamValue.CHDList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      CHDList := AParamValue.Instances.Objects[InstanceIndex] as TCHDList;
      CHDList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    end;
  end;
end;

function TCHDPkgWriter.GetParameterInstanceCount(
  const ParameterName: string): integer;
var
  ParamIndex : integer;
  AParamValue : TCHDParamValue;
  ErrorMessage : string;
begin
  result := 1;
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Constant-Head Boundary package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
    result := AParamValue.Instances.Count;
    if result = 0 then
    begin
      result := 1;
    end
  end;
end;

procedure TCHDPkgWriter.GetParamIndicies(var Indicies: TCHDParamIndicies;
  const CurrentModelHandle: ANE_PTR; CHDLayer: TLayerOptions);
begin
  with Indicies do
  begin
    IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
    IsParamIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

    ParamNameName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
    ParamNameIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, ParamNameName);

    ElevationName := ModflowTypes.GetMFCHD_ElevationParamType.WriteParamName;
    ElevationIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, ElevationName);
  end;
end;

procedure TCHDPkgWriter.GetTimeParamIndicies(
  var Indicies: TCHDTimeParamIndicies; const CurrentModelHandle: ANE_PTR;
  CHDLayer: TLayerOptions; const StressPeriod: integer);
var
  StressPeriodString : string;
  SpeciesIndex : integer;
  Parametername : string;
begin
  StressPeriodString := IntToStr(StressPeriod);
  with Indicies do
  begin
    SheadName := ModflowTypes.GetMFCHD_StartHeadParamType.WriteParamName + StressPeriodString;
    SheadIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, SheadName);
    Assert(SheadIndex >= 0);

    EHeadName := ModflowTypes.GetMFCHD_EndHeadParamType.WriteParamName + StressPeriodString;
    EHeadIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, EHeadName);
    Assert(EHeadIndex >= 0);

    if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
    begin
      IFaceName := ModflowTypes.GetMFIFACEParamType.WriteParamName + StressPeriodString;
      IFaceIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, IFaceName);
      Assert(IFaceIndex >= 0);
    end;

    if frmMODFLOW.cbMOC3D.Checked then
    begin
      ConcentrationName := ModflowTypes.GetMFConcentrationParamType.WriteParamName + StressPeriodString;
      ConcentrationIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, ConcentrationName);
      Assert(ConcentrationIndex >= 0);
    end;

    if frmMODFLOW.cbSeaWat.Checked then
    begin
      SeawatOptionName := ModflowTypes.GetMFSeawatDensityOptionParamType.WriteParamName + StressPeriodString;
      SeawatOptionIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, SeawatOptionName);
      Assert(SeawatOptionIndex >= 0);

      DensityName := ModflowTypes.GetMFChdFluidDensityParamType.WriteParamName + StressPeriodString;
      DensityIndex := CHDLayer.GetParameterIndex(CurrentModelHandle, DensityName);
      Assert(DensityIndex >= 0);
    end;

    if frmModflow.cbMT3D.Checked then
    begin
      SetLength(MT3D_ConcentrationIndicies, SpeciesCount);
      SetLength(MT3D_ConcentrationNames, SpeciesCount);

      for SpeciesIndex := 1 to SpeciesCount do
      begin
        case SpeciesIndex of
          1: ParameterName := ModflowTypes.GetMFConcentrationParamType.Ane_ParamName;
          2: ParameterName := ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName;
          3: ParameterName := ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName;
          4: ParameterName := ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName;
          5: ParameterName := ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName;
        else Assert(False);
        end;
        ParameterName := ParameterName + StressPeriodString;
        Indicies.MT3D_ConcentrationNames[SpeciesIndex-1] := ParameterName;
        MT3D_ConcentrationIndicies[SpeciesIndex-1]
          := CHDLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
        Assert(Indicies.MT3D_ConcentrationIndicies[SpeciesIndex-1] > -1);
      end;
    end;
  end;
end;

procedure TCHDPkgWriter.RecordIFACE(const BFLX_Writer: TBFLX_Writer);
begin
  RecordIFACE_Parameters(BFLX_Writer);
  RecordIFACE_Normal(BFLX_Writer);
end;

procedure TCHDPkgWriter.RecordIFACE_Normal(const BFLX_Writer: TBFLX_Writer);
var
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  CHDList: TCHDList;
  CHDIndex: integer;
  A_Cell: TCHD_Cell;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    if not ContinueExport then break;
    CHDList := CHD_Times[StressPeriodIndex];
    for CHDIndex := 0 to CHDList.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      A_Cell := CHDList[CHDIndex] as TCHD_Cell;
      BFLX_Writer.IFACE[A_Cell.Cell.Layer, A_Cell.Cell.Row,
        A_Cell.Cell.Column] := A_Cell.Cell.IFACE;
    end;
  end;
end;

procedure TCHDPkgWriter.RecordIFACE_Parameters(const BFLX_Writer: TBFLX_Writer);
var
  ParamIndex: integer;
  AParam: TCHDParamValue;
  CHDList: TCHDList;
  CHDIndex: integer;
  A_Cell: TCHD_Cell;
  InstanceIndex: integer;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;

    if AParam.Instances.Count > 0 then
    begin
      for InstanceIndex := 0 to AParam.Instances.Count-1 do
      begin
        CHDList := AParam.Instances.Objects[InstanceIndex] as TCHDList;
        for CHDIndex := 0 to CHDList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          A_Cell := CHDList[CHDIndex] as TCHD_Cell;
          BFLX_Writer.IFACE[A_Cell.Cell.Layer, A_Cell.Cell.Row,
            A_Cell.Cell.Column] := A_Cell.Cell.IFACE;
        end;
      end;
    end
    else
    begin
      for CHDIndex := 0 to AParam.CHDList.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        A_Cell := AParam.CHDList[CHDIndex] as TCHD_Cell;
        BFLX_Writer.IFACE[A_Cell.Cell.Layer, A_Cell.Cell.Row,
          A_Cell.Cell.Column] := A_Cell.Cell.IFACE;
      end;
    end;
  end;

end;

procedure TCHDPkgWriter.SortCells;
var
  ParamIndex, InstanceIndex : integer;
  AParam : TCHDParamValue;
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  CHDList : TCHDList;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting Constant Head Boundaries';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParameterNames.Count + StressPeriodCount;

  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
    AParam.CHDList.Sort;
    for InstanceIndex := 0 to AParam.Instances.Count -1 do
    begin
      CHDList := AParam.Instances.Objects[InstanceIndex] as TCHDList;
      CHDList.Sort;
    end;
    frmProgress.pbActivity.StepIt;
  end;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    CHDList := CHD_Times[StressPeriodIndex];
    CHDList.Sort;
    frmProgress.pbActivity.StepIt;
  end;
end;

procedure TCHDPkgWriter.WriteDataSet1;
var
  NPCHD : integer;
  ParamIndex : integer;
  AParam : TCHDParamValue;
  CHDList : TCHDList;
begin
  MXL := 0;
  if ParameterNames.Count > 0 then
  begin
    NPCHD := ParameterNames.Count;
    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
      if AParam.Instances.Count > 0 then
      begin
        CHDList := AParam.Instances.Objects[0] as TCHDList;
        MXL := MXL + CHDList.Count * AParam.Instances.Count;
      end
      else
      begin
        MXL := MXL + AParam.CHDList.Count;
      end;
    end;
    Writeln(FFile, 'PARAMETER ', NPCHD, ' ', MXL);
  end;
end;

procedure TCHDPkgWriter.WriteDataSet2;
var
  Index, MXACTC : integer;
  ACHDList : TCHDList;
  Option : string;
begin
  MXACTC := 0;
  for Index := 0 to CHD_Times.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    ACHDList := CHD_Times[Index];
    if ACHDList.Count > MXACTC then
    begin
      MXACTC := ACHDList.Count
    end;
  end;
  MXACTC := MXACTC + MXL;
  Option := '';
  if ModflowTypes.GetMFPointLineCHD_LayerType.UseIFACE then
  begin
    Option := Option + ' AUXILIARY IFACE'
  end;
  if frmModflow.cbSeaWat.Checked then
  begin
    Option := Option + ' AUXILIARY CHDDENSOPT';
    if SeawatOption1Used then
    begin
      Option := Option + ' AUXILIARY CHDDEN';
    end;
  end;

  if frmModflow.cbMOC3D.Checked {and (frmModflow.rgMOC3DSolver.ItemIndex > 0)} then
  begin
    Option := Option + ' AUXILIARY CONCENTRATION'
  end;
  if not frmModflow.cbPrintCellLists.Checked then
  begin
    Option := Option + ' NOPRINT';
  end;
  Writeln(FFile, MXACTC, Option);
end;

procedure TCHDPkgWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  CHDList : TCHDList;
  ParamIndex : integer;
  AParam : TCHDParamValue;
begin
  CHDList := CHD_Times[StressPeriodIndex];
  ITMP := CHDList.Count;
  NP := 0;
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Inc(NP);
    end;
  end;
  WriteLn(FFile, ITMP, ' ', NP);
end;

procedure TCHDPkgWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  CHDList : TCHDList;
  A_Cell : TCHD_Cell;
  CHDIndex : integer;
begin
  if ITMP > 0 then
  begin
    CHDList := CHD_Times[StressPeriodIndex];
    for CHDIndex := 0 to CHDList.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      A_Cell := CHDList[CHDIndex] as TCHD_Cell;
      A_Cell.WriteCell(self);
    end;
  end;
end;

procedure TCHDPkgWriter.WriteDataSet7(StressPeriodIndex: integer);
var
  ParamIndex : integer;
  AParam : TCHDParamValue;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
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

procedure TCHDPkgWriter.WriteDataSets3And4;
const
  PARTYP = '''CHD'' ';
var
  ParamIndex, CHDIndex, InstanceIndex : integer;
  AParam : TCHDParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  A_Cell : TCHD_Cell;
  CHDList : TCHDList;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    PARNAM := ParameterNames[ParamIndex];
    AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;
    Parval := AParam.Value;
    if AParam.Instances.Count > 0 then
    begin
      CHDList := AParam.Instances.Objects[0] as TCHDList;
    end
    else
    begin
      CHDList := AParam.CHDList;
    end;

    NLST := CHDList.Count;

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
        CHDList := AParam.Instances.Objects[InstanceIndex] as TCHDList;
        for CHDIndex := 0 to CHDList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          A_Cell := CHDList[CHDIndex] as TCHD_Cell;
          A_Cell.WriteCell(self);
        end;
      end;
    end
    else
    begin
      for CHDIndex := 0 to AParam.CHDList.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        A_Cell := AParam.CHDList[CHDIndex] as TCHD_Cell;
        A_Cell.WriteCell(self);
      end;
    end;
  end;
end;

procedure TCHDPkgWriter.WriteDatasets5To7;
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

procedure TCHDPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter);
var
  Index : integer;
  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    CHD_Times.Add(TCHDList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS *3 ;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Constant-Head Boundary';
    Application.ProcessMessages;

    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
  end;

  if ContinueExport then
  begin
    SortCells;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsCHD;
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
    if PointLineContourErrors > 0 then
    begin
      ErrorMessage := 'Warning: ' + IntToStr(AreaContourErrors)
        + ' contours in the CHD package '
        + 'are closed contours but are on a layer '
        + 'reserved for point or open contours.  '
        + 'These contours will be ignored.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(ErrorMessage);
    end;
    if AreaContourErrors > 0 then
    begin
      ErrorMessage := 'Warning: ' + IntToStr(AreaContourErrors)
        + ' contours in the CHD package '
        + 'are point or open contours but are on a layer '
        + 'reserved for closed contours.  '
        + 'These contours will be ignored.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(ErrorMessage);
    end;


    Application.ProcessMessages;
  end;

end;

procedure TCHDPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  ParamIndex, InstanceIndex : integer;
  AParam : TCHDParamValue;
  CHDList : TCHDList;
  InstanceName : string;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TCHDParamValue;

    if AParam.Instances.Count > 0 then
    begin
      InstanceName := AParam.InstanceNamesUsed[StressPeriod -1];
      InstanceIndex := AParam.Instances.IndexOf(InstanceName);
      if  InstanceIndex >= 0 then
      begin
        CHDList := AParam.Instances.Objects[InstanceIndex] as TCHDList;
        CHDList.WriteMT3DConcentrations(Lines);
      end;
    end
    else
    begin
      AParam.CHDList.WriteMT3DConcentrations(Lines);
    end;
  end;
  CHDList := CHD_Times[StressPeriod-1];
  CHDList.WriteMT3DConcentrations(Lines);
end;

end.
