unit WriteGHBUnit;

interface

uses Sysutils, Classes, contnrs, Forms, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit, CopyArrayUnit;

type
  TGHBRecord = record
    Layer, Row, Column : integer;
    Bhead, CondFact : double;
    IFACE : integer;
    Concentration : double;
    CellGroupNumber : integer;
    MT3DConcentrations : T1DDoubleArray;
    Elevation: double;
    FluidDensity: double;
  end;

  TGHB_Cell = class;

  TGHBList = Class(TObjectList)
  private
    function Add(A_GHB_Cell : TGHBRecord) : integer; overload;
    procedure FillBoundaryList(Layer, Row, Column: integer;
      BoundaryList: TObjectList);
    function GetGHBByLocation(Layer, Row, Column: integer): TGHB_Cell;
    procedure Sort;
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  end;

  TGHBParamValue = Class(TObject)
  private
    Value : double;
    StressPeriodsUsed: Array of boolean;
    InstanceNamesUsed: array of string;
    GHBList : TGHBList;
    Instances : TStringList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  TGHBPkgWriter = class(TCustomBoundaryWriterWithObservations)
  private
    ParameterNames : TStringList;
    GHB_Times : TList;
    MXL : integer;
    ITMP, NP : integer;
    PointErrors, LineErrors, AreaErrors: integer;
    Procedure AddParameterNameCell(ParameterName : string;
      A_GHB_Cell : TGHBRecord; Const Instance : integer);
    Procedure AddParameterName(RowIndex : integer);
    procedure EvaluateDataSets6and7(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure EvaluatePointGHBLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(out IsParamIndex, ParamNameIndex,
      ConductanceIndex, CellGroupNumberIndex, ElevIndex, DensityIndex: ANE_INT16;
      out IsParamName, ParamName, ConductanceName, CellGroupName,
      ElevationName, DensityName: string;
      const CurrentModelHandle: ANE_PTR; GHBLayer : TLayerOptions; const PointLayer: boolean);
    procedure AddParameterNames;
    procedure EvaluateLineGHBLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaGHBLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3And4;
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    procedure WriteDataSet7(StressPeriodIndex : integer);
    procedure WriteDatasets5To7;
    procedure SortCells;
    function GetParameterInstanceCount(const ParameterName: string): integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    function BoundaryUsed(Layer, Row, Column : integer) : boolean; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    Procedure FillBoundaryList(Layer, Row, Column : integer;
      BoundaryList : TObjectList); override;
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines : TStrings);
    class procedure AssignUnitNumbers;
  end;

  TGHB_Cell = Class(TObject)
  private
    GHB_Record : TGHBRecord;
    procedure WriteGHB_Cell(GHBWriter : TGHBPkgWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;


implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

function GHBSortFunction(Item1, Item2: Pointer): Integer;
var
  GHB_Cell1, GHB_Cell2 : TGHB_Cell;
begin
  GHB_Cell1 := Item1;
  GHB_Cell2 := Item2;
  result := GHB_Cell1.GHB_Record.Layer - GHB_Cell2.GHB_Record.Layer;
  if Result <> 0 then Exit;
  result := GHB_Cell1.GHB_Record.Row - GHB_Cell2.GHB_Record.Row;
  if Result <> 0 then Exit;
  result := GHB_Cell1.GHB_Record.Column - GHB_Cell2.GHB_Record.Column;
end;


{ TGHBPkgWriter }

procedure TGHBPkgWriter.AddParameterNameCell(ParameterName : string;
      A_GHB_Cell : TGHBRecord; Const Instance : integer);
var
  ParamIndex : integer;
  AParamValue : TGHBParamValue;
  GHBList : TGHBList;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the General-Head Boundary package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
    if AParamValue.Instances.Count > 0 then
    begin
      GHBList := AParamValue.Instances.Objects[Instance] as TGHBList;
    end
    else
    begin
      GHBList := AParamValue.GHBList;
    end;
    GHBList.Add(A_GHB_Cell);
  end;
end;


procedure TGHBPkgWriter.GetParamIndicies(out IsParamIndex, ParamNameIndex,
  ConductanceIndex, CellGroupNumberIndex, ElevIndex, DensityIndex: ANE_INT16;
  out IsParamName, ParamName,
  ConductanceName, CellGroupName, ElevationName, DensityName: string; const
  CurrentModelHandle: ANE_PTR; GHBLayer : TLayerOptions; const PointLayer: boolean);
begin
  IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
  IsParamIndex := GHBLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

  ParamName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  ParamNameIndex := GHBLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  if PointLayer or frmModflow.cbCondGhb.Checked then
  begin
    ConductanceName := ModflowTypes.GetMFGhbConductanceParamType.WriteParamName;
  end
  else
  begin
    ConductanceName := ModflowTypes.GetMFGhbConductanceParamType.WriteFactorName;
  end;
  ConductanceIndex := GHBLayer.GetParameterIndex(CurrentModelHandle, ConductanceName);

  CellGroupName := ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName;
  CellGroupNumberIndex := GHBLayer.GetParameterIndex(CurrentModelHandle, CellGroupName);

  if ModflowTypes.GetMFElevationParamType.UseInGHB then
  begin
    ElevationName := ModflowTypes.GetMFElevationParamType.WriteParamName;
    ElevIndex := GHBLayer.GetParameterIndex(CurrentModelHandle, ElevationName);
  end
  else
  begin
    ElevationName := '';
    ElevIndex := -1;
  end;

  if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
  begin
    DensityName := ModflowTypes.GetMFBoundaryDensityParamType.WriteParamName;
    DensityIndex := GHBLayer.GetParameterIndex(CurrentModelHandle, DensityName);
  end
  else
  begin
    DensityName := '';
    DensityIndex := -1;
  end;
end;

function TGHBPkgWriter.GetParameterInstanceCount(const ParameterName : string) : integer;
var
  ParamIndex : integer;
  AParamValue : TGHBParamValue;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    result := -1;
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the General-Head Boundary package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
    result := AParamValue.Instances.Count;
    if result = 0 then
    begin
      result := 1;
    end
  end;
end;


procedure TGHBPkgWriter.EvaluatePointGHBLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  GHBLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  CellGroupIndex : ANE_INT16;
//  RBOT_Index : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  BheadIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  A_GHB_Cell : TGHBRecord;
  CellIndex : integer;
//  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  GHBList : TGHBList;
  IsParamName, ParamName, ConductanceName, CellGroupName: string;
  Used : boolean;
  Conductance : double;
  TopLayer, BottomLayer, LayerIndex : integer;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  MT3DConcentrationIndicies : array of array of Integer;
  ElevIndex, DensityIndex: ANE_INT16;
  ElevationName, DensityName: string;
begin
  SpeciesCount := 0;
  A_GHB_Cell.Bhead := 0;
  A_GHB_Cell.CondFact := 0;
  A_GHB_Cell.IFACE := 0;
  A_GHB_Cell.Concentration := 0;
  A_GHB_Cell.CellGroupNumber := 0;

  // point general-head boundaries
  TopLayer := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex) + 1;
  BottomLayer := TopLayer + frmMODFLOW.DiscretizationCount(UnitIndex) - 1;
  StressPeriodCount := frmModflow.dgTime.RowCount -1;
  if frmMODFLOW.comboGHBSteady.ItemIndex = 0 then
  begin
    StressPeriodCount := 1;
  end;
  SetLength(BheadIndicies,StressPeriodCount);
  SetLength(IsOnIndicies,StressPeriodCount);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    SetLength(ConcentrationIndicies,StressPeriodCount);
  end;
  if ModflowTypes.GetPointGHBLayerType.UseIFACE then
  begin
    SetLength(IFACEIndicies,StressPeriodCount);
  end;
  if frmMODFLOW.cbMT3D.Checked then
  begin
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
    SetLength(A_GHB_Cell.MT3DConcentrations, SpeciesCount);
  end;

  LayerName := ModflowTypes.GetPointGHBLayerType.WriteNewRoot
    + IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle,LayerName);
  LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
  GHBLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := GHBLayer.NumObjects(CurrentModelHandle,pieContourObject);
    if ContourCount > 0 then
    begin
      GetParamIndicies(IsParamIndex, ParamNameIndex,
        ConductanceIndex, CellGroupIndex, ElevIndex, DensityIndex,
        IsParamName, ParamName,
        ConductanceName, CellGroupName, ElevationName, DensityName,
        CurrentModelHandle, GHBLayer, True);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        TimeParamName := ModflowTypes.GetMFGHBHeadParamType.WriteParamName
          + IntToStr(TimeIndex);
        BheadIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFOnOffParamType.WriteParamName
          + IntToStr(TimeIndex);
        IsOnIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end;
        if ModflowTypes.GetPointGHBLayerType.UseIFACE then
        begin
          TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
            + IntToStr(TimeIndex);
          IFACEIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end;
        if frmMODFLOW.cbMT3D.Checked then
        begin
          for SpeciesIndex := 1 to SpeciesCount do
          begin
            case SpeciesIndex of
              1: TimeParamName := ModflowTypes.GetMFConcentrationParamType.ANE_ParamName;
              2: TimeParamName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
              3: TimeParamName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
              4: TimeParamName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
              5: TimeParamName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
            else Assert(False);
            end;
            TimeParamName := TimeParamName + IntToStr(TimeIndex);
            MT3DConcentrationIndicies[TimeIndex -1, SpeciesIndex-1]
              := GHBLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
          end;
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
          if Contour.NumberOfNodes(CurrentModelHandle) = 1 then
          begin
            if ModflowTypes.GetMFElevationParamType.UseInGHB then
            begin
              A_GHB_Cell.Elevation := Contour.GetFloatParameter(CurrentModelHandle,ElevIndex);
            end
            else
            begin
              A_GHB_Cell.Elevation := 0;
            end;
            if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
            begin
              A_GHB_Cell.FluidDensity := Contour.GetFloatParameter(CurrentModelHandle,DensityIndex);
            end
            else
            begin
              A_GHB_Cell.FluidDensity := 0;
            end;

            IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
            if IsParam then
            begin
              ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
              InstanceLimit := GetParameterInstanceCount(ParameterName);
            end;

            A_GHB_Cell.CondFact := Contour.GetFloatParameter(CurrentModelHandle,ConductanceIndex);
            Conductance := A_GHB_Cell.CondFact;
  //          A_GHB_Cell.RBot := Contour.GetFloatParameter(CurrentModelHandle,RBOT_Index);
            A_GHB_Cell.CellGroupNumber := Contour.GetIntegerParameter
              (CurrentModelHandle,CellGroupIndex);

            for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
            begin
              if not ContinueExport then break;
              Application.ProcessMessages;
              A_GHB_Cell.Row := GGetCellRow(ContourIndex, CellIndex);
              A_GHB_Cell.Column := GGetCellColumn(ContourIndex, CellIndex);
//              Top := Discretization.Elevations[A_GHB_Cell.Column-1,A_GHB_Cell.Row-1,UnitIndex-1];
//              Bottom := Discretization.Elevations[A_GHB_Cell.Column-1,A_GHB_Cell.Row-1,UnitIndex];
              if IsParam then
              begin
                for StressPeriodIndex := 0 to InstanceLimit-1 do
                begin
                  Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                  if Used then
                  begin
                    A_GHB_Cell.CondFact := Conductance;
                  end
                  else
                  begin
                    A_GHB_Cell.CondFact := 0;
                  end;
                  A_GHB_Cell.Bhead := Contour.GetFloatParameter(CurrentModelHandle,BheadIndicies[StressPeriodIndex]);
                  if frmMODFLOW.cbMOC3D.Checked then
                  begin
                    A_GHB_Cell.Concentration := Contour.GetFloatParameter
                      (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                  end;
                  if ModflowTypes.GetPointGHBLayerType.UseIFACE then
                  begin
                    A_GHB_Cell.IFACE := Contour.GetIntegerParameter
                      (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                  end;
                  if frmMODFLOW.cbMT3D.Checked then
                  begin
                    for SpeciesIndex := 1 to SpeciesCount do
                    begin
                      A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                        Contour.GetFloatParameter(CurrentModelHandle,
                        MT3DConcentrationIndicies
                          [StressPeriodIndex, SpeciesIndex-1]);
                    end;
                  end;
                  for LayerIndex := TopLayer to BottomLayer do
                  begin
                    A_GHB_Cell.Layer := LayerIndex;
                    AddParameterNameCell(ParameterName,A_GHB_Cell, StressPeriodIndex);
                  end;
                end;
              end
              else
              begin
                for StressPeriodIndex := 0 to StressPeriodCount-1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;
                  Used := Contour.GetBoolParameter(CurrentModelHandle,
                    IsOnIndicies[StressPeriodIndex]);
                  if Used then
                  begin
                    A_GHB_Cell.CondFact := Conductance;
                  end
                  else
                  begin
                    A_GHB_Cell.CondFact := 0;
                  end;
                  A_GHB_Cell.Bhead := Contour.GetFloatParameter(CurrentModelHandle,
                    BheadIndicies[StressPeriodIndex]);
                  if frmMODFLOW.cbMOC3D.Checked then
                  begin
                    A_GHB_Cell.Concentration := Contour.GetFloatParameter
                      (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                  end;
                  if ModflowTypes.GetPointGHBLayerType.UseIFACE then
                  begin
                    A_GHB_Cell.IFACE := Contour.GetIntegerParameter
                      (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                  end;
                  if frmMODFLOW.cbMT3D.Checked then
                  begin
                    for SpeciesIndex := 1 to SpeciesCount do
                    begin
                      A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                        Contour.GetFloatParameter(CurrentModelHandle,
                        MT3DConcentrationIndicies
                          [StressPeriodIndex, SpeciesIndex-1]);
                    end;
                  end;
                  GHBList := GHB_Times[StressPeriodIndex];
                  for LayerIndex := TopLayer to BottomLayer do
                  begin
                    A_GHB_Cell.Layer := LayerIndex;
                    GHBList.Add(A_GHB_Cell);
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
    GHBLayer.Free(CurrentModelHandle);
  end;
end;

procedure TGHBPkgWriter.EvaluateLineGHBLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  GHBLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  CellGroupIndex : ANE_INT16;
//  RBOT_Index : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  BheadIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  A_GHB_Cell : TGHBRecord;
  CellIndex : integer;
//  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  GHBList : TGHBList;
  ContourConductance : double;
  ContourLength : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, CellGroupName: string;
  BheadNames : TStringList;
  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  Used : boolean;
  TopLayer, BottomLayer, LayerIndex : integer;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  MT3DConcentrationNames : array of array of string;
  MT3DConcentrationIndicies : array of array of Integer;
  ElevIndex, DensityIndex: ANE_INT16;
  ElevationName, DensityName: string;
begin
  // line general-head boundaries
  ContourConductance := 0;
  SpeciesCount := 0;
  IsParam := False;
  A_GHB_Cell.Bhead := 0;
  A_GHB_Cell.CondFact := 0;
  A_GHB_Cell.IFACE := 0;
  A_GHB_Cell.Concentration := 0;
  A_GHB_Cell.CellGroupNumber := 0;

  TopLayer := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex) + 1;
  BottomLayer := TopLayer + frmMODFLOW.DiscretizationCount(UnitIndex) - 1;
  StressPeriodCount := frmModflow.dgTime.RowCount -1;
  if frmMODFLOW.comboGHBSteady.ItemIndex = 0 then
  begin
    StressPeriodCount := 1;
  end;
  SetLength(BheadIndicies,StressPeriodCount);
  SetLength(IsOnIndicies,StressPeriodCount);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    SetLength(ConcentrationIndicies,StressPeriodCount);
  end;
  if ModflowTypes.GetLineGHBLayerType.UseIFACE then
  begin
    SetLength(IFACEIndicies,StressPeriodCount);
  end;
  if frmMODFLOW.cbMT3D.Checked then
  begin
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
    SetLength(A_GHB_Cell.MT3DConcentrations, SpeciesCount);
    SetLength(MT3DConcentrationNames,StressPeriodCount, SpeciesCount);
  end;

  LayerName := ModflowTypes.GetLineGHBLayerType.WriteNewRoot
    + IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle,LayerName);
  LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
  GHBLayer := TLayerOptions.Create(LayerHandle);
  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  BheadNames := TStringList.Create;
  ConcentrationNames := TStringList.Create;
  IFACENames := TStringList.Create;
  try
    ContourCount := GHBLayer.NumObjects(CurrentModelHandle,pieContourObject);
    if ContourCount > 0 then
    begin
      GetParamIndicies(IsParamIndex, ParamNameIndex,
        ConductanceIndex, CellGroupIndex, ElevIndex, DensityIndex,
        IsParamName, ParamName,
        ConductanceName, CellGroupName, ElevationName, DensityName,
        CurrentModelHandle, GHBLayer, False);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        TimeParamName := ModflowTypes.GetMFGHBHeadParamType.WriteParamName
          + IntToStr(TimeIndex);
        BheadNames.Add(TimeParamName);
        BheadIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFOnOffParamType.WriteParamName
          + IntToStr(TimeIndex);
        IsOnIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationNames.Add(TimeParamName);
          ConcentrationIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; // if frmMODFLOW.cbMOC3D.Checked then
        if ModflowTypes.GetLineGHBLayerType.UseIFACE then
        begin
          TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
            + IntToStr(TimeIndex);
          IFACENames.Add(TimeParamName);
          IFACEIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; //  if ModflowTypes.GetLineGHBLayerType.UseIFACE then
        if frmMODFLOW.cbMT3D.Checked then
        begin
          for SpeciesIndex := 1 to SpeciesCount do
          begin
            case SpeciesIndex of
              1: TimeParamName := ModflowTypes.GetMFConcentrationParamType.ANE_ParamName;
              2: TimeParamName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
              3: TimeParamName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
              4: TimeParamName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
              5: TimeParamName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
            else Assert(False);
            end;
            TimeParamName := TimeParamName + IntToStr(TimeIndex);
            MT3DConcentrationNames[TimeIndex -1, SpeciesIndex-1] := TimeParamName;
            MT3DConcentrationIndicies[TimeIndex -1, SpeciesIndex-1]
              := GHBLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
          end;
        end;
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
          if Contour.ContourType(CurrentModelHandle) = ctOpen then
          begin
            if not frmMODFLOW.cbAltGHB.Checked then
            begin
              ContourConductance := Contour.GetFloatParameter(CurrentModelHandle,ConductanceIndex);
              IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
              if IsParam then
              begin
                ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                InstanceLimit := GetParameterInstanceCount(ParameterName);
              end; // if IsParam then
              A_GHB_Cell.CellGroupNumber := Contour.GetIntegerParameter
                (CurrentModelHandle,CellGroupIndex);
              if ModflowTypes.GetMFElevationParamType.UseInGHB then
              begin
                A_GHB_Cell.Elevation := Contour.GetFloatParameter(CurrentModelHandle,ElevIndex);
              end
              else
              begin
                A_GHB_Cell.Elevation := 0;
              end;
              if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
              begin
                A_GHB_Cell.FluidDensity := Contour.GetFloatParameter(CurrentModelHandle,DensityIndex);
              end
              else
              begin
                A_GHB_Cell.FluidDensity := 0;
              end;
            end; // if not frmMODFLOW.cbAltGHB.Checked then

            for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
            begin
              if not ContinueExport then break;
              Application.ProcessMessages;
              A_GHB_Cell.Row := GGetCellRow(ContourIndex, CellIndex);
              A_GHB_Cell.Column := GGetCellColumn(ContourIndex, CellIndex);
              ContourLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);
//              Top := Discretization.Elevations[A_GHB_Cell.Column-1,A_GHB_Cell.Row-1,UnitIndex-1];
//              Bottom := Discretization.Elevations[A_GHB_Cell.Column-1,A_GHB_Cell.Row-1,UnitIndex];
              if frmMODFLOW.cbAltGHB.Checked then
              begin
                BlockIndex := Discretization.BlockIndex(A_GHB_Cell.Row-1,A_GHB_Cell.Column-1);
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  ABlock.GetCenter(CurrentModelHandle, X, Y);
                finally
                  ABlock.Free;
                end;
                ContourConductance := GridLayer.RealValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.' + ConductanceName);
                if frmModflow.cbCondGhb.Checked then
                begin
                  A_GHB_Cell.CondFact := ContourConductance;
                end
                else
                begin
                  A_GHB_Cell.CondFact := ContourConductance*ContourLength;
                end;

                IsParam := GridLayer.BooleanValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.' + IsParamName);
                if IsParam then
                begin
                  ParameterName := GridLayer.StringValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + ParamName);
                  InstanceLimit := GetParameterInstanceCount(ParameterName);
                end; // if IsParam then
                A_GHB_Cell.CellGroupNumber := GridLayer.IntegerValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.' + CellGroupName);
                if ModflowTypes.GetMFElevationParamType.UseInGHB then
                begin
                  A_GHB_Cell.Elevation := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + ElevationName);
                end
                else
                begin
                  A_GHB_Cell.Elevation := 0;
                end;
                if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
                begin
                  A_GHB_Cell.FluidDensity := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + DensityName);
                end
                else
                begin
                  A_GHB_Cell.FluidDensity := 0;
                end;
              end
              else // if frmMODFLOW.cbAltGHB.Checked then
              begin
                if frmModflow.cbCondGhb.Checked then
                begin
                  A_GHB_Cell.CondFact := ContourConductance;
                end
                else
                begin
                  A_GHB_Cell.CondFact := ContourConductance*ContourLength;
                end;
              end; // if frmMODFLOW.cbAltGHB.Checked then else
              if IsParam then
              begin
                for StressPeriodIndex := 0 to InstanceLimit-1 do
                begin
                  Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                  if Used then
                  begin
                    if frmMODFLOW.cbAltGHB.Checked then
                    begin
                      A_GHB_Cell.Bhead := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + BheadNames[StressPeriodIndex]);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin // if frmMODFLOW.cbMOC3D.Checked then
                        A_GHB_Cell.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                      end;
                      if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      begin
                        A_GHB_Cell.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                      end; // if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                            GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                            LayerName + '.' + MT3DConcentrationNames
                            [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end
                    else // if frmMODFLOW.cbAltGHB.Checked then
                    begin
                      A_GHB_Cell.Bhead := Contour.GetFloatParameter(CurrentModelHandle,BheadIndicies[StressPeriodIndex]);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin
                        A_GHB_Cell.Concentration := Contour.GetFloatParameter
                          (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMOC3D.Checked then
                      if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      begin
                        A_GHB_Cell.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end;  // if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            MT3DConcentrationIndicies
                              [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end;
                    for LayerIndex := TopLayer to BottomLayer do
                    begin
                      A_GHB_Cell.Layer := LayerIndex;
                      AddParameterNameCell(ParameterName,A_GHB_Cell,StressPeriodIndex);
                    end;

                  end;
                end;
              end
              else // if IsParam then
              begin
                if frmMODFLOW.cbAltGHB.Checked then
                begin
  //                A_GHB_Cell.RBot := GridLayer.RealValueAtXY
  //                  (CurrentModelHandle, X, Y, LayerName + '.' + RBotName);
                end;
                for StressPeriodIndex := 0 to StressPeriodCount-1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;
                  Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                  if Used then
                  begin
                    if frmMODFLOW.cbAltGHB.Checked then
                    begin
                      A_GHB_Cell.Bhead := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + BheadNames[StressPeriodIndex]);

                      if frmMODFLOW.cbMOC3D.Checked then
                      begin // if frmMODFLOW.cbMOC3D.Checked then
                        A_GHB_Cell.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                      end;
                      if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      begin
                        A_GHB_Cell.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                      end; // if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                            GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                            LayerName + '.' + MT3DConcentrationNames
                            [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end
                    else
                    begin
                      A_GHB_Cell.Bhead := Contour.GetFloatParameter(CurrentModelHandle,
                        BheadIndicies[StressPeriodIndex]);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin
                        A_GHB_Cell.Concentration := Contour.GetFloatParameter
                          (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMOC3D.Checked then
                      if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      begin
                        A_GHB_Cell.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end; // if ModflowTypes.GetLineGHBLayerType.UseIFACE then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            MT3DConcentrationIndicies
                              [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end;
                    GHBList := GHB_Times[StressPeriodIndex];
                    for LayerIndex := TopLayer to BottomLayer do
                    begin
                      A_GHB_Cell.Layer := LayerIndex;
                      GHBList.Add(A_GHB_Cell);
                    end;
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
    GHBLayer.Free(CurrentModelHandle);
    GridLayer.Free(CurrentModelHandle);
    BheadNames.Free;
    ConcentrationNames.Free;
    IFACENames.Free;
  end;
end;

procedure TGHBPkgWriter.EvaluateAreaGHBLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  GHBLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  CellGroupIndex : ANE_INT16;
//  RBOT_Index : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  BheadIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  A_GHB_Cell : TGHBRecord;
//  CellIndex : integer;
//  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  GHBList : TGHBList;
  ContourConductance : double;
  ContourIntersectArea : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, CellGroupName: string;
  BheadNames : TStringList;
  IsOnNames : TStringList;
  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  ColIndex, RowIndex : integer;
  AreaBoundaryInBlock : boolean;
  IsNA : boolean;
  CellArea : double;
  Used : boolean;
  Expression : string;
  TopLayer, BottomLayer, LayerIndex : integer;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  MT3DConcentrationNames : array of array of string;
  MT3DConcentrationIndicies : array of array of Integer;
  ElevIndex, DensityIndex: ANE_INT16;
  ElevationName, DensityName: string;
begin
  // area general-head boundaries
  A_GHB_Cell.Bhead := 0;
  A_GHB_Cell.CondFact := 0;
  A_GHB_Cell.IFACE := 0;
  A_GHB_Cell.Concentration := 0;
  A_GHB_Cell.CellGroupNumber := 0;

  if frmMODFLOW.cbUseAreaGHBs.Checked then
  begin
    TopLayer := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex) + 1;
    BottomLayer := TopLayer + frmMODFLOW.DiscretizationCount(UnitIndex) - 1;
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboGHBSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(BheadIndicies,StressPeriodCount);
    SetLength(IsOnIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end;
    if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(A_GHB_Cell.MT3DConcentrations, SpeciesCount);
      SetLength(MT3DConcentrationNames,StressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetAreaGHBLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    SetAreaValues;
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    GHBLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    BheadNames := TStringList.Create;
    ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    IsOnNames := TStringList.Create;
    try
      GetParamIndicies(IsParamIndex, ParamNameIndex,
        ConductanceIndex, CellGroupIndex, ElevIndex, DensityIndex,
        IsParamName, ParamName,
        ConductanceName, CellGroupName, ElevationName, DensityName,
        CurrentModelHandle, GHBLayer, False);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        TimeParamName := ModflowTypes.GetMFGHBHeadParamType.WriteParamName
          + IntToStr(TimeIndex);
        BheadNames.Add(TimeParamName);
        BheadIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFOnOffParamType.WriteParamName
          + IntToStr(TimeIndex);
        IsOnNames.Add(TimeParamName);
        IsOnIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationNames.Add(TimeParamName);
          ConcentrationIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; // if frmMODFLOW.cbMOC3D.Checked then
        if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
        begin
          TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
            + IntToStr(TimeIndex);
          IFACENames.Add(TimeParamName);
          IFACEIndicies[TimeIndex -1] := GHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; //  if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
        if frmMODFLOW.cbMT3D.Checked then
        begin
          for SpeciesIndex := 1 to SpeciesCount do
          begin
            case SpeciesIndex of
              1: TimeParamName := ModflowTypes.GetMFConcentrationParamType.ANE_ParamName;
              2: TimeParamName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
              3: TimeParamName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
              4: TimeParamName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
              5: TimeParamName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
            else Assert(False);
            end;
            TimeParamName := TimeParamName + IntToStr(TimeIndex);
            MT3DConcentrationNames[TimeIndex -1, SpeciesIndex-1] := TimeParamName;
            MT3DConcentrationIndicies[TimeIndex -1, SpeciesIndex-1]
              := GHBLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
          end;
        end;
      end; // for TimeIndex := 1 to StressPeriodCount do

      frmProgress.pbActivity.Position := 0;
      ContourCount := GHBLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if frmModflow.cbAltGHB.Checked then
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;
      end
      else
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW
          * ContourCount;
        if not frmModflow.cbAreaGHBContour.Checked then
        begin
          frmProgress.pbActivity.Max := frmProgress.pbActivity.Max
            + Discretization.NCOL * Discretization.NROW
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
          if not frmModflow.cbAltGHB.Checked then
          begin

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
                  ContourIntersectArea := GContourIntersectCell(ContourIndex, ColIndex, RowIndex);
                  if ContourIntersectArea > 0 then
                  begin
                    if ModflowTypes.GetMFElevationParamType.UseInGHB then
                    begin
                      A_GHB_Cell.Elevation := Contour.GetFloatParameter(CurrentModelHandle,ElevIndex);
                    end
                    else
                    begin
                      A_GHB_Cell.Elevation := 0;
                    end;
                    if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
                    begin
                      A_GHB_Cell.FluidDensity := Contour.GetFloatParameter(CurrentModelHandle,DensityIndex);
                    end
                    else
                    begin
                      A_GHB_Cell.FluidDensity := 0;
                    end;
                    IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
                    if IsParam then
                    begin
                      ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                      InstanceLimit := GetParameterInstanceCount(ParameterName);
                    end; // if IsParam then

                    AreaBoundaryInBlock := True;
                    ContourConductance := Contour.GetFloatParameter
                      (CurrentModelHandle,ConductanceIndex);
                    A_GHB_Cell.CellGroupNumber := Contour.GetIntegerParameter(CurrentModelHandle, CellGroupIndex);

                    A_GHB_Cell.Row := RowIndex;
                    A_GHB_Cell.Column := ColIndex;
                    if frmModflow.cbCondGhb.Checked then
                    begin
                      A_GHB_Cell.CondFact := ContourConductance;
                    end
                    else
                    begin
                      A_GHB_Cell.CondFact := ContourConductance*ContourIntersectArea;
                    end;
                    if IsParam then
                    begin
                      for StressPeriodIndex := 0 to InstanceLimit-1 do
                      begin
                        Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                        if Used then
                        begin
                          A_GHB_Cell.Bhead := Contour.GetFloatParameter(CurrentModelHandle,BheadIndicies[StressPeriodIndex]);
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            A_GHB_Cell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                          begin
                            A_GHB_Cell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end;  // if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                          if frmMODFLOW.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 1 to SpeciesCount do
                            begin
                              A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                MT3DConcentrationIndicies
                                  [StressPeriodIndex, SpeciesIndex-1]);
                            end;
                          end;
                          for LayerIndex := TopLayer to BottomLayer do
                          begin
                            A_GHB_Cell.Layer := LayerIndex;
                            AddParameterNameCell(ParameterName,A_GHB_Cell,StressPeriodIndex);
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
                        Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                        if Used then
                        begin
                          A_GHB_Cell.Bhead := Contour.GetFloatParameter(CurrentModelHandle,
                            BheadIndicies[StressPeriodIndex]);
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            A_GHB_Cell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                          begin
                            A_GHB_Cell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end; // if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                          if frmMODFLOW.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 1 to SpeciesCount do
                            begin
                              A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                MT3DConcentrationIndicies
                                  [StressPeriodIndex, SpeciesIndex-1]);
                            end;
                          end;
                          GHBList := GHB_Times[StressPeriodIndex];
                          for LayerIndex := TopLayer to BottomLayer do
                          begin
                            A_GHB_Cell.Layer := LayerIndex;
                            GHBList.Add(A_GHB_Cell);
                          end;
                        end;
                      end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    end; // if IsParam then else
                  end;
                end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
              finally
                Contour.Free;
              end;

            end; // for ContourIndex := 0 to ContourCount -1 do
          end; // if not frmModflow.cbAltGHB.Checked then
          if not ContinueExport then break;

          if frmModflow.cbAreaGHBContour.Checked then
          begin
            // only use contours.
            Continue;
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;

          if frmModflow.cbAltGHB.Checked then
          begin
            CellArea := GGetCellArea(ColIndex,RowIndex);
          end
          else
          begin
            CellArea := GContourIntersectCellRemainder(ColIndex,RowIndex);
          end;
          if (CellArea > 0) and
            (frmModflow.cbAltGHB.Checked or not AreaBoundaryInBlock) then
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex -1, ColIndex -1);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle,BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle,X,Y);
            finally
              ABlock.Free;
            end;
              if ModflowTypes.GetMFElevationParamType.UseInGHB then
              begin
                A_GHB_Cell.Elevation := GridLayer.RealValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.' + ElevationName);
              end
              else
              begin
                A_GHB_Cell.Elevation := 0;
              end;
              if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
              begin
                A_GHB_Cell.FluidDensity := GridLayer.RealValueAtXY
                  (CurrentModelHandle, X, Y, LayerName + '.' + DensityName);
              end
              else
              begin
                A_GHB_Cell.FluidDensity := 0;
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

              Expression := LayerName + '.' + CellGroupName;
              A_GHB_Cell.CellGroupNumber := GridLayer.IntegerValueAtXY
                (CurrentModelHandle,X,Y, Expression);

              A_GHB_Cell.Row := RowIndex;
              A_GHB_Cell.Column := ColIndex;
              if frmModflow.cbCondGhb.Checked then
              begin
                A_GHB_Cell.CondFact := ContourConductance;
              end
              else
              begin
                A_GHB_Cell.CondFact := ContourConductance*CellArea;
              end;
              if IsParam then
              begin
                for StressPeriodIndex := 0 to InstanceLimit-1 do
                begin
                  Used := GridLayer.BooleanValueAtXY
                    (CurrentModelHandle,X,Y, LayerName + '.' + IsOnNames[StressPeriodIndex]);
                  if Used then
                  begin
                    Expression := LayerName + '.' + BheadNames[StressPeriodIndex];

                    A_GHB_Cell.Bhead := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      Expression := LayerName + '.' + ConcentrationNames[StressPeriodIndex];

                      A_GHB_Cell.Concentration := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                    begin
                      Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                      A_GHB_Cell.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                    end;  // if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                    if frmMODFLOW.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 1 to SpeciesCount do
                      begin
                        A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                          GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                          LayerName + '.' + MT3DConcentrationNames
                          [StressPeriodIndex, SpeciesIndex-1]);
                      end;
                    end;
                    for LayerIndex := TopLayer to BottomLayer do
                    begin
                      A_GHB_Cell.Layer := LayerIndex;
                      AddParameterNameCell(ParameterName,A_GHB_Cell,StressPeriodIndex);
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

                  Expression := LayerName + '.' + IsOnNames[StressPeriodIndex];

                  Used := GridLayer.BooleanValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  if Used then
                  begin
                    Expression := LayerName + '.' + BheadNames[StressPeriodIndex];

                    A_GHB_Cell.Bhead := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      Expression := LayerName + '.' + ConcentrationNames[StressPeriodIndex];

                      A_GHB_Cell.Concentration := GridLayer.RealValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    end; // if frmMODFLOW.cbMOC3D.Checked then
                    if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                    begin
                      Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                      A_GHB_Cell.IFACE := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                    end; // if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
                    if frmMODFLOW.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 1 to SpeciesCount do
                      begin
                        A_GHB_Cell.MT3DConcentrations[SpeciesIndex-1] :=
                          GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                          LayerName + '.' + MT3DConcentrationNames
                          [StressPeriodIndex, SpeciesIndex-1]);
                      end;
                    end;
                    GHBList := GHB_Times[StressPeriodIndex];
                    for LayerIndex := TopLayer to BottomLayer do
                    begin
                      A_GHB_Cell.Layer := LayerIndex;
                      GHBList.Add(A_GHB_Cell);
                    end;
                  end;
                end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
              end; // if IsParam then else
            end;
          end;
        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do

    finally
      GHBLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      BheadNames.Free;
      ConcentrationNames.Free;
      IFACENames.Free;
      IsOnNames.Free;
    end;
  end;
end;

procedure TGHBPkgWriter.EvaluateDataSets6and7(
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
          // point general-head boundaries
          frmProgress.lblActivity.Caption := 'Evaluating point general-head boundaries in Unit ' + IntToStr(UnitIndex);
          EvaluatePointGHBLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // line general-head boundaries
          frmProgress.lblActivity.Caption := 'Evaluating line general-head boundaries in Unit ' + IntToStr(UnitIndex);
          EvaluateLineGHBLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area general-head boundaries
          frmProgress.lblActivity.Caption := 'Evaluating area general-head boundaries in Unit ' + IntToStr(UnitIndex);
          EvaluateAreaGHBLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
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

procedure TGHBPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TGHBParamValue;
//  AGHBList : TGHBList;
  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    GHB_Times.Add(TGHBList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS *3 ;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'General-Head Boundary';
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
    FileName := GetCurrentDir + '\' + Root + rsGHB;
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
      + ' contours in the GHB (General Head Boundary) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the GHB (General Head Boundary) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the GHB (General Head Boundary) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
end;

procedure TGHBPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TGHBParamValue;
//  AGHBList : TGHBList;
//  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    GHB_Times.Add(TGHBList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 2 ;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'General-Head Boundary';
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

  if PointErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
      + ' contours in the GHB (General Head Boundary) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the GHB (General Head Boundary) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the GHB (General Head Boundary) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TGHBPkgWriter.AddParameterNames;
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgGHBParametersN.RowCount -1 do
  begin
    AddParameterName(RowIndex);
  end;

end;

procedure TGHBPkgWriter.AddParameterName(RowIndex : integer);
var
  ParamIndex : integer;
  AParamValue : TGHBParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgGHBParametersN.Cells[0,RowIndex]);
  ParamIndex := ParameterNames.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TGHBParamValue.Create(RowIndex);
    ParameterNames.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different general-head boundary parameters with the same name: ' + ParameterName
      + ' in the General-Head boundary package.  Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create
//      ('Error: Two different general-head boundary parameters with the same name: '
//      + '"ParameterName".');
  end;
end;

procedure TGHBPkgWriter.WriteDataSet1;
var
  NPGHB : integer;
  ParamIndex : integer;
  AParam : TGHBParamValue;
  GHBList : TGHBList;
begin
  MXL := 0;
  if ParameterNames.Count > 0 then
  begin
    NPGHB := ParameterNames.Count;
    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      AParam := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
      if AParam.Instances.Count > 0 then
      begin
        GHBList := AParam.Instances.Objects[0] as TGHBList;
        MXL := MXL + GHBList.Count * AParam.Instances.Count;
      end
      else
      begin
        MXL := MXL + AParam.GHBList.Count;
      end;
//      MXL := MXL + AParam.GHBList.Count;
    end;
    Writeln(FFile, 'PARAMETER ', NPGHB, ' ', MXL);
  end;
end;

procedure TGHBPkgWriter.WriteDataSet2;
var
  Index, MXACTB, IGHBCB : integer;
  AGHBList : TGHBList;
  Option : string;
begin
  MXACTB := 0;
  for Index := 0 to GHB_Times.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AGHBList := GHB_Times[Index];
    if AGHBList.Count > MXACTB then
    begin
      MXACTB := AGHBList.Count
    end;
  end;
  MXACTB := MXACTB + MXL;
  if frmModflow.cbFlowGHB.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IGHBCB := frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IGHBCB := frmModflow.GetUnitNumber('GHBBUD');
    end;
  end
  else
  begin
      IGHBCB := 0;
  end;
  Option := '';
  if ModflowTypes.GetAreaGHBLayerType.UseIFACE
    or frmModflow.cbMOC3D.Checked then
  begin
    // Because of what appears to be a bug in GWT, IFACE is required
    // in the GHB package all the time.
    // See also TGHB_Cell.WriteGHB_Cell.
    Option := Option + ' AUXILIARY IFACE'
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Option := Option + ' CBCALLOCATE AUXILIARY CONCENTRATION'
  end;
  if ModflowTypes.GetMFElevationParamType.UseInGHB then
  begin
    Option := Option + ' AUXILIARY GHBELEV'
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
  begin
    Option := Option + ' AUXILIARY GHBDENS'
  end;
  if not frmModflow.cbPrintCellLists.Checked then
  begin
    Option := Option + ' NOPRINT';
  end;
  Writeln(FFile, MXACTB, ' ', IGHBCB, Option);
end;

procedure TGHBPkgWriter.WriteDataSets3And4;
const
  PARTYP = '''GHB'' ';
var
  ParamIndex, GHBIndex, InstanceIndex : integer;
  AParam : TGHBParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  A_GHB_Cell : TGHB_Cell;
  GHBList : TGHBList;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    PARNAM := ParameterNames[ParamIndex];
    AParam := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
    Parval := AParam.Value;
    if AParam.Instances.Count > 0 then
    begin
      GHBList := AParam.Instances.Objects[0] as TGHBList;
    end
    else
    begin
      GHBList := AParam.GHBList;
    end;

    NLST := GHBList.Count;

//    NLST := AParam.GHBList.Count;
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
        GHBList := AParam.Instances.Objects[InstanceIndex] as TGHBList;
        for GHBIndex := 0 to GHBList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          A_GHB_Cell := GHBList[GHBIndex] as TGHB_Cell;
          A_GHB_Cell.WriteGHB_Cell(self);
        end;
      end;
    end
    else
    begin
      for GHBIndex := 0 to AParam.GHBList.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        A_GHB_Cell := AParam.GHBList[GHBIndex] as TGHB_Cell;
        A_GHB_Cell.WriteGHB_Cell(self);
      end;
    end;
  end;
end;

procedure TGHBPkgWriter.WriteDatasets5To7;
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

procedure TGHBPkgWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  GHBList : TGHBList;
  ParamIndex : integer;
  AParam : TGHBParamValue;
begin
  GHBList := GHB_Times[StressPeriodIndex];
  ITMP := GHBList.Count;
  if (StressPeriodIndex >= 1) and (frmMODFLOW.comboGHBSteady.ItemIndex = 0) then
  begin
    ITMP := -1;
  end;
  NP := 0;
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Inc(NP);
    end;
  end;
  WriteLn(FFile, ITMP, ' ', NP);
end;

procedure TGHBPkgWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  GHBList : TGHBList;
  A_GHB_Cell : TGHB_Cell;
  GHBIndex : integer;
begin
  if ITMP > 0 then
  begin
    GHBList := GHB_Times[StressPeriodIndex];
    for GHBIndex := 0 to GHBList.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      A_GHB_Cell := GHBList[GHBIndex] as TGHB_Cell;
      A_GHB_Cell.WriteGHB_Cell(self);
    end;
  end;
end;

procedure TGHBPkgWriter.WriteDataSet7(StressPeriodIndex: integer);
var
  ParamIndex : integer;
  AParam : TGHBParamValue;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Write(FFile, ParameterNames[ParamIndex]);
      if AParam.Instances.Count > 0 then
      begin
        Write(FFile, ' ', AParam.InstanceNamesUsed[StressPeriodIndex]);
      end;

      Writeln(FFile);
//      WriteLn(FFile, ParameterNames[ParamIndex]);
    end;
  end;
end;

function TGHBPkgWriter.BoundaryUsed(Layer, Row, Column: integer): boolean;
var
  ListIndex, InstanceIndex : integer;
  GHBList : TGHBList;
  ACell : TGHB_Cell;
  AParamValue : TGHBParamValue;
  Index : integer;
begin
  result := False;
  for ListIndex := 0 to GHB_Times.Count -1 do
  begin
    GHBList := GHB_Times[ListIndex];
    ACell := GHBList.GetGHBByLocation(Layer, Row, Column);
    result := ACell <> nil;
    if result then Exit;
  end;

  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TGHBParamValue;
    ACell := AParamValue.GHBList.GetGHBByLocation(Layer, Row, Column);
    result := ACell <> nil;
    if result then Exit;
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      GHBList := AParamValue.Instances.Objects[InstanceIndex] as TGHBList;
      ACell := GHBList.GetGHBByLocation(Layer, Row, Column);
      result := ACell <> nil;
      if result then Exit;
    end;
  end;

end;

constructor TGHBPkgWriter.Create;
begin
  inherited;
  ParameterNames := TStringList.Create;
  GHB_Times := TList.Create;
end;

destructor TGHBPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TGHBParamValue;
  AGHBList : TGHBList;
begin
  for Index := ParameterNames.Count -1 downto 0 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TGHBParamValue;
    AParamValue.Free;
  end;
  ParameterNames.Free;

  for Index := GHB_Times.Count -1 downto 0 do
  begin
    AGHBList := GHB_Times[Index];
//      AGHBList.Clear;
    AGHBList.Free;
  end;
  GHB_Times.Free;
  inherited;

end;

procedure TGHBPkgWriter.SortCells;
var
  ParamIndex, InstanceIndex : integer;
  AParam : TGHBParamValue;
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  GHBList : TGHBList;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting General Head Boundaries';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParameterNames.Count + StressPeriodCount;

  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TGHBParamValue;
    AParam.GHBList.Sort;
    for InstanceIndex := 0 to AParam.Instances.Count -1 do
    begin
      GHBList := AParam.Instances.Objects[InstanceIndex] as TGHBList;
      GHBList.Sort;
    end;
    frmProgress.pbActivity.StepIt;
  end;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    GHBList := GHB_Times[StressPeriodIndex];
    GHBList.Sort;
    frmProgress.pbActivity.StepIt;
  end;
end;

procedure TGHBPkgWriter.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index, InstanceIndex : integer;
  AParamValue : TGHBParamValue;
  GHBList : TGHBList;
begin
  if GHB_Times.Count > 0 then
  begin
    GHBList := GHB_Times[0];
    GHBList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TGHBParamValue;
    AParamValue.GHBList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      GHBList := AParamValue.Instances.Objects[InstanceIndex] as TGHBList;
      GHBList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    end;
  end;
end;

procedure TGHBPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  ParamIndex, InstanceIndex : integer;
  AParam : TGHBParamValue;
  GHBList : TGHBList;
  InstanceName : string;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TGHBParamValue;

    if AParam.Instances.Count > 0 then
    begin
      InstanceName := AParam.InstanceNamesUsed[StressPeriod -1];
      InstanceIndex := AParam.Instances.IndexOf(InstanceName);
      if  InstanceIndex >= 0 then
      begin
        GHBList := AParam.Instances.Objects[InstanceIndex] as TGHBList;
        GHBList.WriteMT3DConcentrations(Lines);
      end;
    end
    else
    begin
      AParam.GHBList.WriteMT3DConcentrations(Lines);
    end;
  end;
  GHBList := GHB_Times[StressPeriod-1];
  GHBList.WriteMT3DConcentrations(Lines);
end;

class procedure TGHBPkgWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowGHB.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      frmModflow.GetUnitNumber('GHBBUD');
    end;
  end;
end;

{ TGHBParamValue }

constructor TGHBParamValue.Create(RowIndex : Integer);
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
  AStringGrid := frmModflow.sg3dGHBParamInstances.Grids[RowIndex-1];
  for InstanceIndex := 1 to AStringGrid.RowCount -1 do
  begin
    Instances.AddObject(AStringGrid.Cells[0,InstanceIndex], TGHBList.Create);
  end;

  GHBList := TGHBList.Create;
  for TimeIndex := 0 to StressPeriodCount -1 do
  begin
    dgColumn := TimeIndex + 4;
    StressPeriodsUsed[TimeIndex]
      := (frmModflow.dgGHBParametersN.Cells[dgColumn,RowIndex]
          <> frmModflow.dgGHBParametersN.Columns[dgColumn].PickList[0]);
    InstanceNamesUsed[TimeIndex] := frmModflow.dgGHBParametersN.
      Cells[dgColumn,RowIndex];
  end;
  Value := InternationalStrToFloat(frmModflow.dgGHBParametersN.Cells[2,RowIndex]);
end;

destructor TGHBParamValue.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to Instances.Count-1 do
  begin
    Instances.Objects[Index].Free;
  end;

  Instances.Free;
  GHBList.Free;
  inherited;
end;

{ TGHBList }

function TGHBList.Add(A_GHB_Cell: TGHBRecord): integer;
var
  GHBObject : TGHB_Cell;
  Index : integer;
  SpeciesIndex : integer;
  Identical : boolean;
begin
  for Index := 0 to Count -1 do
  begin
    GHBObject := Items[Index] as TGHB_Cell;
    With GHBObject do
    begin
    if (GHB_Record.Layer = A_GHB_Cell.Layer) and
       (GHB_Record.Row = A_GHB_Cell.Row) and
       (GHB_Record.Column = A_GHB_Cell.Column) and
       (GHB_Record.Bhead = A_GHB_Cell.Bhead) and
       (GHB_Record.IFACE = A_GHB_Cell.IFACE) and
       (GHB_Record.Concentration = A_GHB_Cell.Concentration) and
       (GHB_Record.CellGroupNumber = A_GHB_Cell.CellGroupNumber) and
       (GHB_Record.Elevation = A_GHB_Cell.Elevation) and
       (GHB_Record.FluidDensity = A_GHB_Cell.FluidDensity) then
       begin
         Identical := True;
         for SpeciesIndex := 0 to Length(A_GHB_Cell.MT3DConcentrations) -1 do
         begin
           if (GHB_Record.MT3DConcentrations[SpeciesIndex] <> A_GHB_Cell.MT3DConcentrations[SpeciesIndex]) then
           begin
             Identical := False;
             break;
           end;
         end;

         if Identical then
         begin
           GHB_Record.CondFact := GHB_Record.CondFact + A_GHB_Cell.CondFact;
           result := Index;
           Exit;
         end;
       end;
    end;
  end;
  GHBObject := TGHB_Cell.Create;
  result := Add(GHBObject);
  GHBObject.GHB_Record.Layer := A_GHB_Cell.Layer;
  GHBObject.GHB_Record.Row := A_GHB_Cell.Row;
  GHBObject.GHB_Record.Column := A_GHB_Cell.Column;
  GHBObject.GHB_Record.Bhead := A_GHB_Cell.Bhead;
  GHBObject.GHB_Record.CondFact := A_GHB_Cell.CondFact;
  GHBObject.GHB_Record.IFACE := A_GHB_Cell.IFACE;
  GHBObject.GHB_Record.Concentration := A_GHB_Cell.Concentration;
  GHBObject.GHB_Record.CellGroupNumber := A_GHB_Cell.CellGroupNumber;
  GHBObject.GHB_Record.Elevation := A_GHB_Cell.Elevation;
  GHBObject.GHB_Record.FluidDensity := A_GHB_Cell.FluidDensity;
  Copy1DDoubleArray(A_GHB_Cell.MT3DConcentrations,
    GHBObject.GHB_Record.MT3DConcentrations);
end;

procedure TGHBList.FillBoundaryList(Layer, Row, Column : integer;
  BoundaryList : TObjectList);
var
  Index : integer;
  AGHB_Cell : TGHB_Cell;
begin
  for Index := 0 to Count -1 do
  begin
    AGHB_Cell := Items[Index] as TGHB_Cell;
    if (AGHB_Cell.GHB_Record.Layer = Layer) and (AGHB_Cell.GHB_Record.Row = Row)
      and (AGHB_Cell.GHB_Record.Column = Column) then
    begin
      BoundaryList.Add(TBoundaryCell.Create(AGHB_Cell.GHB_Record.CellGroupNumber));
    end;
  end;
end;


function TGHBList.GetGHBByLocation(Layer, Row, Column: integer): TGHB_Cell;
var
  Index : integer;
  ACell : TGHB_Cell;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TGHB_Cell;
    if (ACell.GHB_Record.Layer = Layer) and (ACell.GHB_Record.Row = Row)
      and (ACell.GHB_Record.Column = Column) then
    begin
      result := ACell;
      Exit;
    end;
  end;
end;

procedure TGHBList.Sort;
begin
  inherited Sort(GHBSortFunction);
end;

procedure TGHBList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  ACell : TGHB_Cell;
begin
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TGHB_Cell;
    ACell.WriteMT3DConcentrations(Lines);
  end;
end;

{ TGHB_Cell }

procedure TGHB_Cell.WriteGHB_Cell(GHBWriter : TGHBPkgWriter);
begin
  Write(GHBWriter.FFile, GHB_Record.Layer, ' ',  GHB_Record.Row, ' ',
    GHB_Record.Column, ' ',
    GHBWriter.FreeFormattedReal(GHB_Record.Bhead),
    GHBWriter.FreeFormattedReal(GHB_Record.CondFact)
    );
  if ModflowTypes.GetAreaGHBLayerType.UseIFACE then
  begin
    Write(GHBWriter.FFile, ' ',  GHB_Record.IFACE, ' ');
  end
  else if frmModflow.cbMOC3D.Checked then
  begin
    Write(GHBWriter.FFile, ' ',  0, ' ');
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Write(GHBWriter.FFile, GHBWriter.FreeFormattedReal(GHB_Record.Concentration));
  end;
  if ModflowTypes.GetMFElevationParamType.UseInGHB then
  begin
    Write(GHBWriter.FFile, GHBWriter.FreeFormattedReal(GHB_Record.Elevation));
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
  begin
    Write(GHBWriter.FFile, GHBWriter.FreeFormattedReal(GHB_Record.FluidDensity));
  end;

  WriteLn(GHBWriter.FFile);
end;

procedure TGHB_Cell.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  Assert(Length(GHB_Record.MT3DConcentrations) >=1);
  ALine := TModflowWriter.FixedFormattedInteger(GHB_Record.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(GHB_Record.Row, 10)
    + TModflowWriter.FixedFormattedInteger(GHB_Record.Column, 10)
    + TModflowWriter.FixedFormattedReal(GHB_Record.MT3DConcentrations[0], 10)
    + TModflowWriter.FixedFormattedInteger(5, 10) + ' ';
  for SpeciesIndex := 0 to Length(GHB_Record.MT3DConcentrations)-1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (GHB_Record.MT3DConcentrations[SpeciesIndex]);
  end;
  Lines.Add(ALine);
end;

end.
