unit WriteWellUnit;

interface

uses Sysutils, Classes, contnrs, Forms, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit, CopyArrayUnit;

type
  TWellRecord = record
    Layer, Row, Column : integer;
    Q : double;
    IFACE : integer;
    Concentration : double;
    MT3DConcentrations : T1DDoubleArray;
    FluidDensity: double;
    ContourIndex: integer;
  end;

  TWell = Class;

  TWellList = Class(TObjectList)
    public
    function Add(AWell : TWellRecord) : integer; overload;
    function GetWellByLocation(Layer, Row, Column : integer) : TWell;
    procedure Sort;
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  end;

  TWellParamValue = Class(TObject)
  private
    Value : double;
    StressPeriodsUsed: Array of boolean;
    InstanceNamesUsed: array of string;
    WellList : TWellList;
    Instances : TStringList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  TWellPkgWriter = class(TCustomBoundaryWriter)
  private
    ParameterNames : TStringList;
    WellTimes : TList;
    MXL : integer;
    ITMP, NP : integer;
    PointErrors, LineErrors, AreaErrors: integer;
    Procedure AddParameterNameCell(ParameterName : string;
      AWell : TWellRecord; Const Instance : integer);
    procedure EvaluateDataSets6and7(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(out IsParamIndex, ParamNameIndex,
      TopIndex, BottomIndex, DensityIndex : ANE_INT16; out IsParamName, ParamName,
      TopName, BottomName, DensityName: string; const
      CurrentModelHandle: ANE_PTR; WellLayer : TLayerOptions);
    procedure AddParameterNames;
    procedure EvaluatePointLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization : TDiscretizationWriter);
    procedure EvaluateLineLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3And4;
    procedure WriteDatasets5To7;
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    procedure WriteDataSet7(StressPeriodIndex : integer);
    function GetBoundaryThickness(DivIndex, LayersPerUnit: integer; Top,
      UnitThickness, BoundaryTop, BoundaryBottom: double): double;
    function GetLayersAbove(UnitIndex : integer): Integer;
    procedure AddParameterNameCellToStringList(NameList: TStringList;
      ParameterName: string; AWell: TWellRecord; Const Instance : integer);
    procedure AddParameterNamesToStringList(NameList: TStringList);
    procedure AddParameterNameToStringList(NameList: TStringList;
      RowIndex: integer);
    procedure SortWells;
    function GetParameterInstanceCount(
      const ParameterName: string): integer;
    procedure MakeWellListsConsistent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    function BoundaryUsed(Layer, Row, Column : integer) : boolean; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines : TStrings);
    class procedure AssignUnitNumbers;
  end;

  TWell = Class(TObject)
  private
    Well : TWellRecord;
    procedure WriteWell(WellWriter : TWellPkgWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;


implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, RealListUnit,
  GetFractionUnit, IntListUnit, WriteNameFileUnit, UnitNumbers,
  UtilityFunctions;

function WellSortFunction(Item1, Item2: Pointer): Integer;
var
  Well1, Well2 : TWell;
begin
  Well1 := Item1;
  Well2 := Item2;
  result := Well1.Well.Layer - Well2.Well.Layer;
  if Result <> 0 then Exit;
  result := Well1.Well.Row - Well2.Well.Row;
  if Result <> 0 then Exit;
  result := Well1.Well.Column - Well2.Well.Column;
end;


{ TWellPkgWriter }

procedure TWellPkgWriter.AddParameterNameCellToStringList(
  NameList : TStringList; ParameterName : string;
  AWell : TWellRecord; Const Instance : integer);
var
  ParamIndex : integer;
  AParamValue : TWellParamValue;
  AWellList : TWellList;
  ErrorMessage : string;
begin
  ParamIndex := NameList.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Well package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end
  else
  begin
    AParamValue := NameList.Objects[ParamIndex] as TWellParamValue;
    if AParamValue.Instances.Count > 0 then
    begin
      AWellList := AParamValue.Instances.Objects[Instance] as TWellList;
    end
    else
    begin
      AWellList := AParamValue.WellList;
    end;
    AWellList.Add(AWell);
  end;
end;


procedure TWellPkgWriter.AddParameterNameCell(ParameterName : string;
      AWell : TWellRecord; Const Instance : integer);
begin
  AddParameterNameCellToStringList(ParameterNames, ParameterName, AWell,
    Instance);
end;


procedure TWellPkgWriter.GetParamIndicies(out IsParamIndex, ParamNameIndex,
  TopIndex, BottomIndex, DensityIndex : ANE_INT16; out IsParamName, ParamName,
  TopName, BottomName, DensityName : string; const
  CurrentModelHandle: ANE_PTR; WellLayer : TLayerOptions);
begin
  IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
  IsParamIndex := WellLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

  ParamName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  ParamNameIndex := WellLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  TopName := ModflowTypes.GetMFWellTopParamType.WriteParamName;
  TopIndex := WellLayer.GetParameterIndex(CurrentModelHandle, TopName);

  BottomName := ModflowTypes.GetMFWellBottomParamType.WriteParamName;
  BottomIndex := WellLayer.GetParameterIndex(CurrentModelHandle, BottomName);

  if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
  begin
    DensityName := ModflowTypes.GetMFBoundaryDensityParamType.WriteParamName;
    DensityIndex := WellLayer.GetParameterIndex(CurrentModelHandle, DensityName);
  end
  else
  begin
    DensityName := '';
    DensityIndex := -1;
  end;
end;

Function TWellPkgWriter.GetBoundaryThickness(DivIndex, LayersPerUnit : integer;
  Top, UnitThickness, BoundaryTop, BoundaryBottom : double) : double;
var
  LayerTop, LayerBottom : double;
  DivWellTop, DivWellBottom : double;
begin
  LayerTop := Top- (UnitThickness/LayersPerUnit)*(DivIndex-1);
  LayerBottom := Top- (UnitThickness/LayersPerUnit)*(DivIndex);
  DivWellTop := BoundaryTop;
  if DivWellTop > LayerTop then
  begin
    DivWellTop := LayerTop
  end;
  DivWellBottom := BoundaryBottom;
  if DivWellBottom < LayerBottom then
  begin
    DivWellBottom := LayerBottom
  end;
  result := DivWellTop - DivWellBottom;
end;

{ TODO : Consider replacing with frmModflow.MODFLOWLayersAboveCount; }
function TWellPkgWriter.GetLayersAbove(UnitIndex : integer): Integer;
var
  LayerIndex : integer;
begin
  result := 0;
  for LayerIndex := 1 to UnitIndex-1 do
  begin
    if frmModflow.dgGeol.Cells[Ord(nuiSim),LayerIndex]
      = frmModflow.dgGeol.Columns[Ord(nuiSim)].PickList[1] then
    begin
      result := result + StrToInt(frmModflow.dgGeol.Cells
        [Ord(nuiVertDisc),LayerIndex]);
    end;
  end;

end;

function TWellPkgWriter.GetParameterInstanceCount(const ParameterName : string) : integer;
var
  ParamIndex : integer;
  AParamValue : TWellParamValue;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    result := -1;
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the Well package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TWellParamValue;
    result := AParamValue.Instances.Count;
    if result = 0 then
    begin
      result := 1;
    end
  end;
end;

procedure TWellPkgWriter.EvaluatePointLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  WellLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  TopIndex : ANE_INT16;
  BottomIndex : ANE_INT16;
//  CellGroupIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  QIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  MT3DConcentrationIndicies : array of array of Integer;
  IFACEIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  AWell : TWellRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  WellList : TWellList;
  IsParamName, ParamName, TopName, BottomName: string;
  WellTop, WellBottom : ANE_Double;
  DivIndex : integer;
  Pumpage : ANE_Double;
  UnitThickness : ANE_Double;
  LayersPerUnit : integer;
  LayerTop, LayerBottom : ANE_Double;
  DivWellTop, DivWellBottom, DivThickness : ANE_Double;
  DivThicknesses : TRealList;
  Layer : integer;
  WellThickness : double;
  TopErrors, BottomErrors, ThicknessErrors, NameErrors : TStringList;
  AString : string;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  DensityIndex: ANE_INT16;
  DensityName: string;
begin
  // point wells
  AWell.Q := 0;
  AWell.IFACE := 0;
  AWell.Concentration := 0;

  TopErrors := TStringList.Create;
  BottomErrors := TStringList.Create;
  ThicknessErrors := TStringList.Create;
  NameErrors := TStringList.Create;
  try
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboWelSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(QIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end;
    if ModflowTypes.GetMFWellLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(AWell.MT3DConcentrations, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFWellLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    WellLayer := TLayerOptions.Create(LayerHandle);
    try
      ContourCount := WellLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          TopIndex, BottomIndex, DensityIndex, IsParamName, ParamName,
          TopName, BottomName, DensityName, CurrentModelHandle, WellLayer);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFWellStressParamType.WriteParamName
            + IntToStr(TimeIndex);
          QIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if frmMODFLOW.cbMOC3D.Checked then
          begin
            TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
              + IntToStr(TimeIndex);
            ConcentrationIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end;
          if ModflowTypes.GetMFWellLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACEIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
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
                := WellLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
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
            if Contour.NumberOfNodes(CurrentModelHandle) <> 1 then
            begin
              Inc(PointErrors);
            end
            else
            begin
              IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
              if IsParam then
              begin
                ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                InstanceLimit := GetParameterInstanceCount(ParameterName);
              end;

              WellTop := Contour.GetFloatParameter(CurrentModelHandle,TopIndex);
              WellBottom := Contour.GetFloatParameter(CurrentModelHandle,BottomIndex);
              if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
              begin
                AWell.FluidDensity := Contour.GetFloatParameter(CurrentModelHandle,DensityIndex);
              end
              else
              begin
                AWell.FluidDensity := 0;
              end;

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                AWell.Row := GGetCellRow(ContourIndex, CellIndex);
                AWell.Column := GGetCellColumn(ContourIndex, CellIndex);
                Top := Discretization.Elevations[AWell.Column-1,AWell.Row-1,UnitIndex-1];
                Bottom := Discretization.Elevations[AWell.Column-1,AWell.Row-1,UnitIndex];
                UnitThickness := Discretization.Thicknesses[AWell.Column-1,AWell.Row-1,UnitIndex-1];
                if (WellTop > Top) or (WellTop < Bottom) then
                begin
                  if ShowWarnings then
                  begin
                    if WellTop > Top then
                    begin
                      TopErrors.Add(Format
                        ('[%d, %d] Top Elevation > top of unit', [AWell.Row, AWell.Column]));
                    end;
                    if WellTop < Bottom then
                    begin
                      BottomErrors.Add(Format
                        ('[%d, %d] Top Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                    end;
                  end;
                  WellTop := Top;
                end;

                if (WellBottom > Top) or (WellBottom < Bottom) then
                begin
                  if ShowWarnings then
                  begin
                    if WellBottom > Top then
                    begin
                      TopErrors.Add(Format
                        ('[%d, %d] Bottom Elevation > top of unit', [AWell.Row, AWell.Column]));
                    end;
                    if WellBottom < Bottom then
                    begin
                      BottomErrors.Add(Format
                        ('[%d, %d] Bottom Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                    end;
                  end;
                  WellBottom := Bottom;
                end;

                WellThickness := WellTop - WellBottom;

                if ShowWarnings and (WellThickness <= 0) then
                begin
                  ThicknessErrors.Add(Format
                    ('[%d, %d]', [AWell.Row, AWell.Column]));
                end;
                if WellThickness > 0 then
                begin
                  if IsParam then
                  begin
                    for StressPeriodIndex := 0 to InstanceLimit-1 do
                    begin
                      Pumpage := Contour.GetFloatParameter(CurrentModelHandle,QIndicies[StressPeriodIndex]);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin
                        AWell.Concentration := Contour.GetFloatParameter
                          (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                      end;

                      if ModflowTypes.GetMFWellLayerType.UseIFACE then
                      begin
                        AWell.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end;
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          AWell.MT3DConcentrations[SpeciesIndex-1] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            MT3DConcentrationIndicies
                              [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;

                      for DivIndex := 1 to LayersPerUnit do
                      begin
                        DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                          Top, UnitThickness, WellTop, WellBottom);

                        if DivThickness > 0 then
                        begin
                          AWell.Layer := Layer + DivIndex;
                          AWell.Q := DivThickness/WellThickness * Pumpage;
                          try
                            AddParameterNameCell(ParameterName,AWell,
                              StressPeriodIndex);
                          except on EInvalidParameterName do
                            begin
                              AString := IntToStr(AWell.Row) + ', '
                                + IntToStr(AWell.Column) + ', '
                                + ParameterName;
                              if NameErrors.IndexOf(AString) < 0 then
                              begin
                                NameErrors.Add(AString);
                              end;
                            end;
                          end;

                        end;
                      end;
                    end;
                  end
                  else
                  begin
                    DivThicknesses := TRealList.Create;
                    try
                      for DivIndex := 1 to LayersPerUnit do
                      begin
                        DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                          Top, UnitThickness, WellTop, WellBottom);
                        DivThicknesses.Add(DivThickness);
                      end;

                      for StressPeriodIndex := 0 to StressPeriodCount-1 do
                      begin
                        if not ContinueExport then break;
                        Application.ProcessMessages;
                        Pumpage := Contour.GetFloatParameter(CurrentModelHandle,QIndicies[StressPeriodIndex]);
                        if Pumpage <> 0 then
                        begin
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            AWell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                          end;

                          if ModflowTypes.GetMFWellLayerType.UseIFACE then
                          begin
                            AWell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end;
                          if frmMODFLOW.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 1 to SpeciesCount do
                            begin
                              AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                MT3DConcentrationIndicies
                                  [StressPeriodIndex, SpeciesIndex-1]);
                            end;
                          end;

                          for DivIndex := 0 to LayersPerUnit-1 do
                          begin
                            DivThickness := DivThicknesses.Items[DivIndex];
                            if DivThickness > 0 then
                            begin
                              AWell.Layer := Layer + DivIndex + 1;
                              AWell.Q := DivThickness/WellThickness * Pumpage;
                              WellList := WellTimes[StressPeriodIndex];
                              WellList.Add(AWell);
                            end;
                          end;
                        end;
                      end;
                    finally
                      DivThicknesses.Free;
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
      WellLayer.Free(CurrentModelHandle);
    end;
    if TopErrors.Count > 0 then
    begin
      AString := 'Warning: Some point well top elevations extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Top elevations outside the unit will be treated as if they '
        + 'are at the top of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(TopErrors);
    end;
    if BottomErrors.Count > 0 then
    begin
      AString := 'Warning: Some point well bottom elevations extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Bottom elevations outside the unit will be treated as if they '
        + 'are at the bottom of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(BottomErrors);
    end;
    if ThicknessErrors.Count > 0 then
    begin
      AString := 'Warning: Some point well vertical extents are <= 0 in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'These wells will be skipped.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ThicknessErrors);
    end;
    if NameErrors.Count > 0 then
    begin
      AString := 'Warning: Some point wells had invalid parameter names in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'These wells will be skipped.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col, Parameter Name]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(NameErrors);
    end;
  finally
    TopErrors.Free;
    BottomErrors.Free;
    ThicknessErrors.Free;
    NameErrors.Free;
  end;
end;

procedure TWellPkgWriter.EvaluateLineLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  WellLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  TopIndex : ANE_INT16;
  BottomIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  QIndicies : array of Integer;
  QTotalIndicies : array of Integer;
  StressIndicatorIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  IFACEIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  AWell : TWellRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  WellList : TWellList;
  ContourTop, ContourBottom : double;
  ContourLength, TotalContourLength : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, TopName, BottomName: string;
  QNames, QTotalNames, StressIndicators : TStringList;
  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  Used : boolean;
  Pumpage : ANE_DOUBLE;
  PumpageTypeIndicator : ANE_INT32;
  LayersPerUnit : integer;
  DivIndex : integer;
  WellTop, WellBottom : ANE_Double;
  UnitThickness, DivThickness : double;
  Pumpages : TRealList;
  PumpageIndicators : TIntegerList;
  Layer : integer;
  WellThickness : double;
  TopErrors, BottomErrors, ThicknessErrors, NameErrors : TStringList;
  AString : string;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  MT3DConcentrationNames : array of array of string;
  MT3DConcentrationIndicies : array of array of Integer;
  DensityIndex: ANE_INT16;
  DensityName: string;
begin
  // line wells
  PumpageTypeIndicator := -1;
  AWell.Q := 0;
  AWell.IFACE := 0;
  AWell.Concentration := 0;
  TopErrors := TStringList.Create;
  BottomErrors := TStringList.Create;
  ThicknessErrors := TStringList.Create;
  NameErrors := TStringList.Create;
  try
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboWelSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(QIndicies,StressPeriodCount);
    SetLength(QTotalIndicies,StressPeriodCount);
    SetLength(StressIndicatorIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end;
    if ModflowTypes.GetMFLineWellLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(AWell.MT3DConcentrations, SpeciesCount);
      SetLength(MT3DConcentrationNames,StressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFLineWellLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    WellLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    QNames := TStringList.Create;
    QTotalNames := TStringList.Create;
    ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    StressIndicators := TStringList.Create;
    try
      ContourCount := WellLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          TopIndex, BottomIndex, DensityIndex, IsParamName, ParamName, TopName,
          BottomName, DensityName, CurrentModelHandle, WellLayer);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFWellStressParamType.WriteParamName
            + IntToStr(TimeIndex);
          QNames.Add(TimeParamName);
          QIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFTotalWellStressParamType.WriteParamName
            + IntToStr(TimeIndex);
          QTotalNames.Add(TimeParamName);
          QTotalIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFWellStressIndicatorParamType.WriteParamName
            + IntToStr(TimeIndex);
          StressIndicators.Add(TimeParamName);
          StressIndicatorIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if frmMODFLOW.cbMOC3D.Checked then
          begin
            TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
              + IntToStr(TimeIndex);
            ConcentrationNames.Add(TimeParamName);
            ConcentrationIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; // if frmMODFLOW.cbMOC3D.Checked then
          if ModflowTypes.GetMFLineWellLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACENames.Add(TimeParamName);
            IFACEIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; //  if frmMODFLOW.cbMODPATH.Checked then
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
                := WellLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
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
            if Contour.ContourType(CurrentModelHandle) <> ctOpen then
            begin
              Inc(LineErrors);
            end
            else
            begin
              if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
              begin
                AWell.FluidDensity := Contour.GetFloatParameter
                  (CurrentModelHandle, DensityIndex);
              end
              else
              begin
                AWell.FluidDensity := 0;
              end;

              Pumpages := TRealList.Create;
              PumpageIndicators := TIntegerList.Create;
              try
                TotalContourLength := GGetLineLength(ContourIndex);

                if not frmMODFLOW.cbAltWel.Checked then
                begin
                  IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
                  if IsParam then
                  begin
                    ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                    InstanceLimit := GetParameterInstanceCount(ParameterName);
                  end; // if IsParam then

                  ContourTop := Contour.GetFloatParameter(CurrentModelHandle,TopIndex);
                  ContourBottom := Contour.GetFloatParameter(CurrentModelHandle,BottomIndex);
                  if IsParam then
                  begin
                    for StressPeriodIndex := 0 to InstanceLimit-1 do
                    begin
                      PumpageTypeIndicator := Contour.GetIntegerParameter
                        (CurrentModelHandle, StressIndicatorIndicies[StressPeriodIndex]);
                      case PumpageTypeIndicator of
                        1:
                          begin
                            Pumpage := Contour.GetFloatParameter
                              (CurrentModelHandle, QIndicies[StressPeriodIndex]);
                          end;
                        2:
                          begin
                            Pumpage := Contour.GetFloatParameter
                              (CurrentModelHandle, QTotalIndicies[StressPeriodIndex]);
                          end;
                        else
                          begin
                            Pumpage := 0;
                          end;
                      end;
                      Pumpages.Add(Pumpage);
                      PumpageIndicators.Add(PumpageTypeIndicator);
                    end;
                  end
                  else
                  begin
                    for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    begin
                      PumpageTypeIndicator := Contour.GetIntegerParameter
                        (CurrentModelHandle, StressIndicatorIndicies[StressPeriodIndex]);
                      case PumpageTypeIndicator of
                        1:
                          begin
                            Pumpage := Contour.GetFloatParameter
                              (CurrentModelHandle, QIndicies[StressPeriodIndex]);
                          end;
                        2:
                          begin
                            Pumpage := Contour.GetFloatParameter
                              (CurrentModelHandle, QTotalIndicies[StressPeriodIndex]);
                          end;
                        else
                          begin
                            Pumpage := 0;
                          end;
                      end;
                      Pumpages.Add(Pumpage);
                      PumpageIndicators.Add(PumpageTypeIndicator);
                    end;
                  end;
                end; // if not frmMODFLOW.cbAltWel.Checked then

                for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;
                  AWell.Row := GGetCellRow(ContourIndex, CellIndex);
                  AWell.Column := GGetCellColumn(ContourIndex, CellIndex);
                  ContourLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);
                  Top := Discretization.Elevations[AWell.Column-1,AWell.Row-1,UnitIndex-1];
                  Bottom := Discretization.Elevations[AWell.Column-1,AWell.Row-1,UnitIndex];
                  UnitThickness := Discretization.Thicknesses[AWell.Column-1,AWell.Row-1,UnitIndex-1];

                  if frmMODFLOW.cbAltWel.Checked then
                  begin
                    BlockIndex := Discretization.BlockIndex(AWell.Row-1,AWell.Column-1);
                    ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                      Discretization.GridLayerHandle, BlockIndex);
                    try
                      ABlock.GetCenter(CurrentModelHandle, X, Y);
                    finally
                      ABlock.Free;
                    end;
                    WellTop := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + TopName);
                    WellBottom := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + BottomName);

                    if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
                    begin
                      AWell.FluidDensity := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + DensityName);
                    end
                    else
                    begin
                      AWell.FluidDensity := 0;
                    end;

                    IsParam := GridLayer.BooleanValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + IsParamName);
                    if IsParam then
                    begin
                      ParameterName := GridLayer.StringValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ParamName);
                      InstanceLimit := GetParameterInstanceCount(ParameterName);
                    end; // if IsParam then
                  end
                  else // if frmMODFLOW.cbAltWel.Checked then
                  begin
                    WellTop := ContourTop;
                    WellBottom := ContourBottom;
                  end; // if frmMODFLOW.cbAltWel.Checked then else

                  if (WellTop > Top) or (WellTop < Bottom) then
                  begin
                    if ShowWarnings then
                    begin
                      if WellTop > Top then
                      begin
                        TopErrors.Add(Format
                          ('[%d, %d] Top Elevation > top of unit', [AWell.Row, AWell.Column]));
                      end;
                      if WellTop < Bottom then
                      begin
                        BottomErrors.Add(Format
                          ('[%d, %d] Top Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                      end;
                    end;
                    WellTop := Top;
                  end;

                  if (WellBottom > Top) or (WellBottom < Bottom) then
                  begin
                    if ShowWarnings then
                    begin
                      if WellBottom > Top then
                      begin
                        TopErrors.Add(Format
                          ('[%d, %d] Bottom Elevation > top of unit', [AWell.Row, AWell.Column]));
                      end;
                      if WellBottom < Bottom then
                      begin
                        BottomErrors.Add(Format
                          ('[%d, %d] Bottom Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                      end;
                    end;
                    WellBottom := Bottom;
                  end;

                  WellThickness := WellTop - WellBottom;
                  if ShowWarnings and (WellThickness <= 0) then
                  begin
                    ThicknessErrors.Add(Format
                      ('[%d, %d]', [AWell.Row, AWell.Column]));
                  end;
                  if WellThickness > 0 then
                  begin
                    if IsParam then
                    begin
                      for StressPeriodIndex := 0 to InstanceLimit-1 do
                      begin
                        if frmMODFLOW.cbAltWel.Checked then
                        begin
                          PumpageTypeIndicator := GridLayer.IntegerValueAtXY
                            (CurrentModelHandle, X, Y, LayerName + '.'
                            + StressIndicators[StressPeriodIndex]);
                          case PumpageTypeIndicator of
                            1:
                              begin
                                Pumpage := GridLayer.RealValueAtXY
                                  (CurrentModelHandle, X, Y, LayerName + '.' + QNames[StressPeriodIndex]);
                              end;
                            2:
                              begin
                                Pumpage := GridLayer.RealValueAtXY
                                  (CurrentModelHandle, X, Y, LayerName + '.' + QTotalNames[StressPeriodIndex]);
                              end;
                            else
                              begin
                                Pumpage := 0;
                              end;
                          end;

                          If Pumpage <> 0 then
                          begin
                            if frmMODFLOW.cbMOC3D.Checked then
                            begin
                              AWell.Concentration := GridLayer.RealValueAtXY
                              (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                            end; // if frmMODFLOW.cbMOC3D.Checked then
                            if ModflowTypes.GetMFLineWellLayerType.UseIFACE then
                            begin
                              AWell.IFACE := GridLayer.IntegerValueAtXY
                              (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                            end; // if frmMODFLOW.cbMODPATH.Checked then
                            if frmMODFLOW.cbMT3D.Checked then
                            begin
                              for SpeciesIndex := 1 to SpeciesCount do
                              begin
                                AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                                  LayerName + '.' + MT3DConcentrationNames
                                  [StressPeriodIndex, SpeciesIndex-1]);
                              end;
                            end;
                          end;
                        end
                        else // if frmMODFLOW.cbAltWel.Checked then
                        begin
                          PumpageTypeIndicator := Contour.GetIntegerParameter
                            (CurrentModelHandle, StressIndicatorIndicies[StressPeriodIndex]);
                          case PumpageTypeIndicator of
                            1:
                              begin
                                Pumpage := Contour.GetFloatParameter
                                  (CurrentModelHandle, QIndicies[StressPeriodIndex]);
                              end;
                            2:
                              begin
                                Pumpage := Contour.GetFloatParameter
                                  (CurrentModelHandle, QTotalIndicies[StressPeriodIndex]);
                              end;
                            else
                              begin
                                Pumpage := 0;
                              end;
                          end;
                          If Pumpage <> 0 then
                          begin
                            if frmMODFLOW.cbMOC3D.Checked then
                            begin
                              AWell.Concentration := Contour.GetFloatParameter
                                (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                            end; // if frmMODFLOW.cbMOC3D.Checked then
                            if ModflowTypes.GetMFLineWellLayerType.UseIFACE then
                            begin
                              AWell.IFACE := Contour.GetIntegerParameter
                                (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                            end;  // if frmMODFLOW.cbMODPATH.Checked then
                            if frmMODFLOW.cbMT3D.Checked then
                            begin
                              for SpeciesIndex := 1 to SpeciesCount do
                              begin
                                AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                  Contour.GetFloatParameter(CurrentModelHandle,
                                  MT3DConcentrationIndicies
                                    [StressPeriodIndex, SpeciesIndex-1]);
                              end;
                            end;
                          end;
                        end;
                        If Pumpage <> 0 then
                        begin
                          for DivIndex := 1 to LayersPerUnit do
                          begin
                            DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                              Top, UnitThickness, WellTop, WellBottom);
                            if DivThickness > 0 then
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                ContourLength;
                              if PumpageTypeIndicator = 2 then
                              begin
                                AWell.Q := AWell.Q / TotalContourLength;
                              end;
                              AWell.Layer := Layer + DivIndex;
                              try
                                AddParameterNameCell(ParameterName,AWell,
                                  StressPeriodIndex);
                              except on EInvalidParameterName do
                                begin
                                  AString := IntToStr(AWell.Row) + ', '
                                    + IntToStr(AWell.Column) + ', '
                                    + ParameterName;
                                  if NameErrors.IndexOf(AString) < 0 then
                                  begin
                                    NameErrors.Add(AString);
                                  end;
                                end;
                              end;

                            end;
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
                          if frmMODFLOW.cbAltWel.Checked then
                          begin
                            PumpageTypeIndicator := GridLayer.IntegerValueAtXY
                              (CurrentModelHandle, X, Y, LayerName + '.'
                              + StressIndicators[StressPeriodIndex]);
                            case PumpageTypeIndicator of
                              1:
                                begin
                                  Pumpage := GridLayer.RealValueAtXY
                                    (CurrentModelHandle, X, Y, LayerName + '.' + QNames[StressPeriodIndex]);
                                end;
                              2:
                                begin
                                  Pumpage := GridLayer.RealValueAtXY
                                    (CurrentModelHandle, X, Y, LayerName + '.' + QTotalNames[StressPeriodIndex]);
                                end;
                              else
                                begin
                                  Pumpage := 0;
                                end;
                            end;
                            if Pumpage <> 0 then
                            begin
                              if frmMODFLOW.cbMOC3D.Checked then
                              begin // if frmMODFLOW.cbMOC3D.Checked then
                                AWell.Concentration := GridLayer.RealValueAtXY
                                (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                              end;
                              if ModflowTypes.GetMFLineWellLayerType.UseIFACE then
                              begin
                                AWell.IFACE := GridLayer.IntegerValueAtXY
                                (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                              end; // if frmMODFLOW.cbMODPATH.Checked then
                              if frmMODFLOW.cbMT3D.Checked then
                              begin
                                for SpeciesIndex := 1 to SpeciesCount do
                                  begin
                                    AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                      GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                                      LayerName + '.' + MT3DConcentrationNames
                                      [StressPeriodIndex, SpeciesIndex-1]);
                                end;
                              end;
                            end;
                          end
                          else
                          begin
                            Pumpage := Pumpages.Items[StressPeriodIndex];
                            if Pumpage <> 0 then
                            begin
                              PumpageTypeIndicator := PumpageIndicators.Items[StressPeriodIndex];
                              if frmMODFLOW.cbMOC3D.Checked then
                              begin
                                AWell.Concentration := Contour.GetFloatParameter
                                  (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                              end; // if frmMODFLOW.cbMOC3D.Checked then
                              if ModflowTypes.GetMFLineWellLayerType.UseIFACE then
                              begin
                                AWell.IFACE := Contour.GetIntegerParameter
                                  (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                              end; // if frmMODFLOW.cbMODPATH.Checked then
                              if frmMODFLOW.cbMT3D.Checked then
                              begin
                                for SpeciesIndex := 1 to SpeciesCount do
                                begin
                                  AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                    Contour.GetFloatParameter(CurrentModelHandle,
                                    MT3DConcentrationIndicies
                                      [StressPeriodIndex, SpeciesIndex-1]);
                                end;
                              end;
                            end;
                          end;
                          if Pumpage <> 0 then
                          begin
                            for DivIndex := 1 to LayersPerUnit do
                            begin
                              DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                                Top, UnitThickness, WellTop, WellBottom);
                              if DivThickness > 0 then
                              begin
                                AWell.Q := DivThickness/WellThickness * Pumpage *
                                  ContourLength;
                                AWell.Layer := Layer + DivIndex;
                                if PumpageTypeIndicator = 2 then
                                begin
                                  AWell.Q := AWell.Q / TotalContourLength;
                                end;
                                WellList := WellTimes[StressPeriodIndex];
                                WellList.Add(AWell);
                              end;
                            end;
                          end;
                      end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    end; // if IsParam then else
                  end;
                end; // for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              finally
                begin
                  Pumpages.Free;
                  PumpageIndicators.Free;
                end;
              end;
            end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
          finally
            Contour.Free;
          end;

        end; // for ContourIndex := 0 to ContourCount -1 do
      end;
    finally
      WellLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      QNames.Free;
      ConcentrationNames.Free;
      IFACENames.Free;
      QTotalNames.Free;
      StressIndicators.Free;
    end;
    if TopErrors.Count > 0 then
    begin
      AString := 'Warning: Some Line well top elevations extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Top elevations outside the unit will be treated as if they '
        + 'are at the top of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(TopErrors);
    end;
    if BottomErrors.Count > 0 then
    begin
      AString := 'Warning: Some Line well bottom elevations extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Bottom elevations outside the unit will be treated as if they '
        + 'are at the bottom of the unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(BottomErrors);
    end;
    if ThicknessErrors.Count > 0 then
    begin
      AString := 'Warning: Some Line well vertical extents are <= 0 in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'These wells will be skipped.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ThicknessErrors);
    end;
    if NameErrors.Count > 0 then
    begin
      AString := 'Warning: Some Line wells had invalid parameter names in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'These wells will be skipped.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col, Parameter Name]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(NameErrors);
    end;

  finally
    TopErrors.Free;
    BottomErrors.Free;
    ThicknessErrors.Free;
    NameErrors.Free;
  end;
end;

procedure TWellPkgWriter.EvaluateAreaLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  TopError1, TopError2 : boolean;
  BottomError1, BottomError2 : boolean;
  LayerName : string;
  LayerHandle : ANE_PTR;
  WellLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  TopIndex : ANE_INT16;
  BottomIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  QIndicies : array of Integer;
  QTotalIndicies : array of Integer;
  StressIndicatorIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  IFACEIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  AWell : TWellRecord;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  WellList : TWellList;
  ContourTop, ContourBottom : double;
  ContourIntersectArea : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, TopName, BottomName: string;
  QNames, QTotalNames, StressIndicators : TStringList;
  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  ColIndex, RowIndex : integer;
  AreaBoundaryInBlock : boolean;
  IsNA : boolean;
  CellArea : double;
  Used : boolean;
  Pumpage : ANE_DOUBLE;
  PumpageTypeIndicator : ANE_INT32;
  LayersPerUnit : integer;
  DivIndex : integer;
  WellTop, WellBottom : ANE_Double;
  UnitThickness, DivThickness : double;
  Pumpages : TRealList;
  PumpageIndicators : TIntegerList;
  Layer : integer;
  TotalContourArea : double;
  ContourAreas: TRealList;
  TempParmNames : TStringList;
  AParamValue, RealParamValue : TWellParamValue;
  Index : integer;
  TotalCellArea : double;
  WellIndex : integer;
  AWellObject : TWell;
  TempWellTimes : TList;
  AWellList : TWellList;
  Expression : string;
  TopErrors, BottomErrors, ThicknessErrors, NameErrors : TStringList;
  AString : string;
  WellThickness : double;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  MT3DConcentrationNames : array of array of string;
  MT3DConcentrationIndicies : array of array of Integer;
  DensityIndex: ANE_INT16;
  DensityName: string;
  ContourAreaArray: array of array of double;
  function CellUsed : boolean;
  var
    SPIndex : integer;
  begin
    result := false;
    Expression := LayerName + '.' + IsParamName;

    IsParam := GridLayer.BooleanValueAtXY
      (CurrentModelHandle,X,Y, Expression);
    if IsParam or (frmModflow.comboWelSteady.ItemIndex = 0) then
    begin
      Expression := LayerName + '.' + StressIndicators[0];
      PumpageTypeIndicator := GridLayer.IntegerValueAtXY
        (CurrentModelHandle,X,Y, Expression);

      result := PumpageTypeIndicator in [1,2];
    end
    else
    begin
      for SPIndex := 0 to StressPeriodCount-1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        Expression := LayerName + '.'
          + StressIndicators[SPIndex];

        PumpageTypeIndicator := GridLayer.IntegerValueAtXY
          (CurrentModelHandle,X,Y, Expression);
        result := PumpageTypeIndicator in [1,2];
        if result then break;
      end;
    end;
  end;
begin
  // area wells
  AWell.Q := 0;
  AWell.IFACE := 0;
  AWell.Concentration := 0;
  if frmModflow.cbUseAreaWells.Checked then
  begin
    TopErrors := TStringList.Create;
    BottomErrors := TStringList.Create;
    ThicknessErrors := TStringList.Create;
    NameErrors := TStringList.Create;
    try
    TotalCellArea := 0;
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboWelSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(QIndicies,StressPeriodCount);
    SetLength(QTotalIndicies,StressPeriodCount);
    SetLength(StressIndicatorIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end; // if frmMODFLOW.cbMOC3D.Checked then
    if ModflowTypes.GetMFAreaWellLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end; // if frmMODFLOW.cbMODPATH.Checked then
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(AWell.MT3DConcentrations, SpeciesCount);
      SetLength(MT3DConcentrationNames,StressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFAreaWellLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
//    if frmModflow.cbAltWel.Checked then
//    begin
//      ResetAreaValues;
//    end
//    else
//    begin
      SetAreaValues;
//    end;

    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    WellLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    QNames := TStringList.Create;
    QTotalNames := TStringList.Create;
    StressIndicators := TStringList.Create;
    ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    ContourAreas:= TRealList.Create;
    TempParmNames := TStringList.Create;
    TempWellTimes := TList.Create;
    try
      for Index := 1 to StressPeriodCount do
      begin
        TempWellTimes.Add(TWellList.Create(False));
      end;
      AddParameterNamesToStringList(TempParmNames);
        GetParamIndicies(IsParamIndex, ParamNameIndex,
          TopIndex, BottomIndex, DensityIndex, IsParamName, ParamName, TopName,
          BottomName, DensityName, CurrentModelHandle, WellLayer);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        TimeParamName := ModflowTypes.GetMFWellStressParamType.WriteParamName
          + IntToStr(TimeIndex);
        QNames.Add(TimeParamName);
        QIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFTotalWellStressParamType.WriteParamName
          + IntToStr(TimeIndex);
        QTotalNames.Add(TimeParamName);
        QTotalIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFWellStressIndicatorParamType.WriteParamName
          + IntToStr(TimeIndex);
        StressIndicators.Add(TimeParamName);
        StressIndicatorIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationNames.Add(TimeParamName);
          ConcentrationIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; // if frmMODFLOW.cbMOC3D.Checked then
        if ModflowTypes.GetMFAreaWellLayerType.UseIFACE then
        begin
          TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
            + IntToStr(TimeIndex);
          IFACENames.Add(TimeParamName);
          IFACEIndicies[TimeIndex -1] := WellLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; //  if frmMODFLOW.cbMODPATH.Checked then
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
              := WellLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
          end;
        end;
      end; // for TimeIndex := 1 to StressPeriodCount do

      ContourCount := WellLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if frmModflow.cbAltWel.Checked then
      begin
        SetLength(ContourAreaArray, StressPeriodCount, ContourCount);
        for StressPeriodIndex := 0 to StressPeriodCount - 1 do
        begin
          for ContourIndex := 0 to ContourCount - 1 do
          begin
            ContourAreaArray[StressPeriodIndex, ContourIndex] := 0;
          end;
        end;
      end;
      if frmModflow.cbAltWel.Checked then
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;

      end
      else // if frmModflow.cbAltWel.Checked then
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW
          * (ContourCount+1);
        if frmModflow.cbAreaWellContour.Checked then
        begin
          frmProgress.pbActivity.Max := frmProgress.pbActivity.Max +
            Discretization.NCOL * Discretization.NROW;
        end;

        for ContourIndex := 0 to ContourCount -1 do
        begin
          if not ContinueExport then break;
          Contour := TContourObjectOptions.Create
            (CurrentModelHandle,LayerHandle,ContourIndex);
          try
            if Contour.ContourType(CurrentModelHandle) <> ctClosed then
            begin
              Inc(AreaErrors);
              ContourAreas.Add(0);
            end
            else
            begin
              TotalContourArea := GContourArea(ContourIndex);
              ContourAreas.Add(TotalContourArea);
            end; // if Contour.ContourType(CurrentModelHandle) <> ctClosed then else
          finally
            begin
              Contour.Free;
            end;
          end;
        end; //  for ContourIndex := 0 to ContourCount -1 do

      end; // if frmModflow.cbAltWel.Checked then else

      for ColIndex := 1 to Discretization.NCOL do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AWell.Column := ColIndex;
        for RowIndex := 1 to Discretization.NROW do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          AWell.Row := RowIndex;
          AreaBoundaryInBlock := False;
          Top := Discretization.Elevations[AWell.Column-1,AWell.Row-1,UnitIndex-1];
          Bottom := Discretization.Elevations[AWell.Column-1,AWell.Row-1,UnitIndex];
          UnitThickness := Discretization.Thicknesses[ColIndex-1,RowIndex-1,UnitIndex-1];
          if not frmModflow.cbAltWel.Checked then
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
                  ContourIntersectArea := GContourIntersectCell(ContourIndex,
                    ColIndex, RowIndex);
                  TotalContourArea := ContourAreas.Items[ContourIndex];
                  if ContourIntersectArea > 0 then
                  begin
                    if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
                    begin
                      AWell.FluidDensity := Contour.GetFloatParameter(CurrentModelHandle, DensityIndex);
                    end
                    else
                    begin
                      AWell.FluidDensity := 0;
                    end;


                    IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
                    if IsParam then
                    begin
                      ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                      InstanceLimit := GetParameterInstanceCount(ParameterName);
                    end; // if IsParam then

                    ContourTop := Contour.GetFloatParameter
                      (CurrentModelHandle,TopIndex);
                    ContourBottom := Contour.GetFloatParameter
                      (CurrentModelHandle,BottomIndex);
                    WellTop := ContourTop;
                    WellBottom := ContourBottom;
                    if (WellTop > Top) or (WellTop < Bottom) then
                    begin
                      if ShowWarnings then
                      begin
                        if WellTop > Top then
                        begin
                          TopErrors.Add(Format
                            ('[%d, %d] Top Elevation > top of unit', [AWell.Row, AWell.Column]));
                        end;
                        if WellTop < Bottom then
                        begin
                          BottomErrors.Add(Format
                            ('[%d, %d] Top Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                        end;
                      end;
                      WellTop := Top;
                    end;

                    if (WellBottom > Top) or (WellBottom < Bottom) then
                    begin
                      if ShowWarnings then
                      begin
                        if WellBottom > Top then
                        begin
                          TopErrors.Add(Format
                            ('[%d, %d] Bottom Elevation > top of unit', [AWell.Row, AWell.Column]));
                        end;
                        if WellBottom < Bottom then
                        begin
                          BottomErrors.Add(Format
                            ('[%d, %d] Bottom Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                        end;
                      end;
                      WellBottom := Bottom;
                    end;
                    WellThickness := WellTop - WellBottom;

                    if ShowWarnings and (WellThickness <= 0) then
                    begin
                      ThicknessErrors.Add(Format
                        ('[%d, %d]', [AWell.Row, AWell.Column]));
                    end;  

                    if WellThickness > 0 then
                    begin

                    if IsParam then
                    begin
                      for StressPeriodIndex := 0 to InstanceLimit-1 do
                      begin
                        PumpageTypeIndicator := Contour.GetIntegerParameter
                          (CurrentModelHandle, StressIndicatorIndicies[StressPeriodIndex]);
                        case PumpageTypeIndicator of
                          1:
                            begin
                              Pumpage := Contour.GetFloatParameter
                                (CurrentModelHandle, QIndicies[StressPeriodIndex]);
                            end;
                          2:
                            begin
                              Pumpage := Contour.GetFloatParameter
                                (CurrentModelHandle, QTotalIndicies[StressPeriodIndex]);
                            end;
                          else
                            begin
                              Pumpage := 0;
                            end;
                        end; //case PumpageTypeIndicator of
                        if Pumpage <> 0 then
                        begin
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            AWell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if ModflowTypes.GetMFAreaWellLayerType.UseIFACE then
                          begin
                            AWell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end;  // if frmMODFLOW.cbMODPATH.Checked then
                          if frmMODFLOW.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 1 to SpeciesCount do
                            begin
                              AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                MT3DConcentrationIndicies
                                  [StressPeriodIndex, SpeciesIndex-1]);
                            end;
                          end;
                          for DivIndex := 1 to LayersPerUnit do
                          begin
                            DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                              Top, UnitThickness, WellTop, WellBottom);
                            if DivThickness > 0 then
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                ContourIntersectArea;
                              if PumpageTypeIndicator = 2 then
                              begin
                                AWell.Q := AWell.Q / TotalContourArea;
                              end; // if PumpageTypeIndicator = 2 then
                              AWell.Layer := Layer + DivIndex;
                              try
                                AddParameterNameCell(ParameterName,AWell,
                                  StressPeriodIndex);
                                AreaBoundaryInBlock := True;
                              except on EInvalidParameterName do
                                begin
                                  AString := IntToStr(AWell.Row) + ', '
                                    + IntToStr(AWell.Column) + ', '
                                    + ParameterName;
                                  if NameErrors.IndexOf(AString) < 0 then
                                  begin
                                    NameErrors.Add(AString);
                                  end;
                                end;
                              end;

                            end; // if DivThickness > 0 then
                          end; // for DivIndex := 1 to LayersPerUnit do
                        end; // if Pumpage <> 0 then
                      end;
                    end
                    else // if IsParam then
                    begin
                      for StressPeriodIndex := 0 to StressPeriodCount-1 do
                      begin
                        if not ContinueExport then break;
                        Application.ProcessMessages;
                        PumpageTypeIndicator := Contour.GetIntegerParameter
                          (CurrentModelHandle, StressIndicatorIndicies[StressPeriodIndex]);
                        case PumpageTypeIndicator of
                          1:
                            begin
                              Pumpage := Contour.GetFloatParameter
                                (CurrentModelHandle, QIndicies[StressPeriodIndex]);
                            end;
                          2:
                            begin
                              Pumpage := Contour.GetFloatParameter
                                (CurrentModelHandle, QTotalIndicies[StressPeriodIndex]);
                            end;
                          else
                            begin
                              Pumpage := 0;
                            end;
                        end; // case PumpageTypeIndicator of
                        if Pumpage <> 0 then
                        begin
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            AWell.Concentration := Contour.GetFloatParameter
                              (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                          end; // if frmMODFLOW.cbMOC3D.Checked then
                          if ModflowTypes.GetMFAreaWellLayerType.UseIFACE then
                          begin
                            AWell.IFACE := Contour.GetIntegerParameter
                              (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                          end; // if frmMODFLOW.cbMODPATH.Checked then
                          if frmMODFLOW.cbMT3D.Checked then
                          begin
                            for SpeciesIndex := 1 to SpeciesCount do
                            begin
                              AWell.MT3DConcentrations[SpeciesIndex-1] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                MT3DConcentrationIndicies
                                  [StressPeriodIndex, SpeciesIndex-1]);
                            end;
                          end;
                          for DivIndex := 1 to LayersPerUnit do
                          begin
                            DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                              Top, UnitThickness, WellTop, WellBottom);
                            if DivThickness > 0 then
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                ContourIntersectArea;
                              if PumpageTypeIndicator = 2 then
                              begin
                                AWell.Q := AWell.Q / TotalContourArea;
                              end; // if PumpageTypeIndicator = 2 then
                              AWell.Layer := Layer + DivIndex;
                              WellList := WellTimes[StressPeriodIndex];
                              WellList.Add(AWell);
                              AreaBoundaryInBlock := True;
                            end;  // if DivThickness > 0 then
                          end; // for DivIndex := 1 to LayersPerUnit do
                        end; // if Pumpage <> 0 then
                      end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    end; // if IsParam then else
                    end;
                  end; // if ContourIntersectArea > 0 then
                end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
              finally
                Contour.Free;
              end;

            end; // for ContourIndex := 0 to ContourCount -1 do
          end; // if not frmModflow.cbAltWel.Checked then
          if not ContinueExport then break;

          if frmModflow.cbAreaWellContour.Checked then
          begin
            // only use contours.
            Continue;
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          if frmModflow.cbAltWel.Checked then
          begin
            CellArea := GGetCellArea(ColIndex,RowIndex);
          end
          else
          begin
            CellArea := GContourIntersectCellRemainder(ColIndex,RowIndex);
          end;
          if not frmModflow.cbAreaWellContour.Checked and (CellArea > 0) and
            (frmModflow.cbAltWel.Checked or not AreaBoundaryInBlock) then
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex -1, ColIndex -1);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle,BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle,X,Y);
            finally
              ABlock.Free;
            end;

            if CellUsed then
            begin
              if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
              begin
                Expression := LayerName + '.' + DensityName;
                AWell.FluidDensity := GridLayer.RealValueAtXY
                  (CurrentModelHandle,X,Y, Expression);
              end
              else
              begin
                AWell.FluidDensity := 0;
              end;

              Expression := LayerName + '.' + TopName;
              IsNA := GridLayer.BooleanValueAtXY(CurrentModelHandle,X,Y,
                Expression + '=$N/A');
              if not IsNA then
              begin
                WellTop := GridLayer.RealValueAtXY
                  (CurrentModelHandle,X,Y, Expression);

                Expression := LayerName + '.' + BottomName;

                WellBottom := GridLayer.RealValueAtXY
                  (CurrentModelHandle,X,Y, Expression);

                TopError1 := False;
                BottomError1 := False;
                if (WellTop > Top) or (WellTop < Bottom) then
                begin
                  if ShowWarnings then
                  begin
                    if WellTop > Top then
                    begin
                      TopError1 := True;
                    end;
                    if WellTop < Bottom then
                    begin
                      BottomError1 := True;
                    end;
                  end;
                  WellTop := Top;
                end;

                TopError2 := False;
                BottomError2 := False;
                if (WellBottom > Top) or (WellBottom < Bottom) then
                begin
                  if ShowWarnings then
                  begin
                    if WellBottom > Top then
                    begin
                      TopError2 := True;
                    end;
                    if WellBottom < Bottom then
                    begin
                      BottomError2 := True;
                    end;
                  end;
                  WellBottom := Bottom;
                end;

                WellThickness := WellTop - WellBottom;

                if ShowWarnings and (WellThickness <= 0) then
                begin
                  ThicknessErrors.Add(Format
                    ('[%d, %d]', [AWell.Column, AWell.Row]));
                end;
                if WellThickness > 0 then
                begin

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

                  if IsParam then
                  begin
                    for StressPeriodIndex := 0 to InstanceLimit-1 do
                    begin
                      Expression := LayerName + '.' + StressIndicators[StressPeriodIndex];

                      PumpageTypeIndicator := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                      case PumpageTypeIndicator of
                        1:
                          begin
                            Expression := LayerName + '.' + QNames[StressPeriodIndex];

                            Pumpage := GridLayer.RealValueAtXY
                              (CurrentModelHandle,X,Y, Expression);
                          end;
                        2:
                          begin
                            Expression := LayerName + '.' + QTotalNames[StressPeriodIndex];

                            Pumpage := GridLayer.RealValueAtXY
                              (CurrentModelHandle,X,Y,  Expression);
                          end;
                        else
                          begin
                            Pumpage := 0;
                          end;
                      end; // case PumpageTypeIndicator of
                      if Pumpage <> 0 then
                      begin
                        if TopError1 then
                        begin
                          TopError1 := False;
                          TopErrors.Add(Format
                            ('[%d, %d] Top Elevation > top of unit', [AWell.Row, AWell.Column]));
                        end;
                        if BottomError1 then
                        begin
                          BottomError1 := False;
                          BottomErrors.Add(Format
                            ('[%d, %d] Top Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                        end;
                        if TopError2 then
                        begin
                          TopError2 := False;
                          TopErrors.Add(Format
                            ('[%d, %d] Bottom Elevation > top of unit', [AWell.Row, AWell.Column]));
                        end;
                        if BottomError2 then
                        begin
                          BottomError2 := False;
                          BottomErrors.Add(Format
                            ('[%d, %d] Bottom Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                        end;
                        if frmMODFLOW.cbMOC3D.Checked then
                        begin
                          Expression := LayerName + '.' + ConcentrationNames[0];

                          AWell.Concentration := GridLayer.RealValueAtXY
                            (CurrentModelHandle,X,Y, Expression);
                        end; // if frmMODFLOW.cbMOC3D.Checked then
                        if ModflowTypes.GetMFAreaWellLayerType.UseIFACE then
                        begin
                          Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                          AWell.IFACE := GridLayer.IntegerValueAtXY
                            (CurrentModelHandle,X,Y, Expression);
                        end;  // if frmMODFLOW.cbMODPATH.Checked then
                        if frmMODFLOW.cbMT3D.Checked then
                        begin
                          for SpeciesIndex := 1 to SpeciesCount do
                          begin
                            AWell.MT3DConcentrations[SpeciesIndex-1] :=
                              GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                              LayerName + '.' + MT3DConcentrationNames
                              [StressPeriodIndex, SpeciesIndex-1]);
                          end;
                        end;
                        ContourIntersectArea := 0;
                        if PumpageTypeIndicator = 2 then
                        begin
                          AWell.ContourIndex := -1;
                          for ContourIndex := 0 to ContourCount - 1 do
                          begin
                            // GContourIntersectCell uses a precalculated value so it is faster
                            ContourIntersectArea := GContourIntersectCell(ContourIndex,
                              AWell.Column, AWell.Row);
                            if ContourIntersectArea > 0 then
                            begin
                              if GPointInsideContour(ContourIndex, X, Y)  then
                              begin
                                ContourAreaArray[StressPeriodIndex, ContourIndex] :=
                                  ContourAreaArray[StressPeriodIndex, ContourIndex] + ContourIntersectArea;
                                AWell.ContourIndex := ContourIndex;
                                break;
                              end;
                            end;
                            ContourIntersectArea := 0;
                          end;
                        end;
                        for DivIndex := 1 to LayersPerUnit do
                        begin
                          DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                            Top, UnitThickness, WellTop, WellBottom);
                          if DivThickness > 0 then
                          begin
                            if (PumpageTypeIndicator = 2) and (ContourIntersectArea <> 0) then
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                ContourIntersectArea;
                            end
                            else
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                CellArea;
                              if (PumpageTypeIndicator = 2) then
                              begin
                                TotalCellArea := TotalCellArea + CellArea;
                              end;
                            end;
                            AWell.Layer := Layer + DivIndex;
                            try
                            if (PumpageTypeIndicator = 2) then
                              begin
                                AddParameterNameCellToStringList
                                  (TempParmNames,ParameterName,AWell,
                                  StressPeriodIndex);
                              end
                              else
                              begin
                                AddParameterNameCell(ParameterName,AWell,
                                  StressPeriodIndex);
                              end; // if PumpageTypeIndicator = 2 then

                            except on EInvalidParameterName do
                              begin
                                AString := IntToStr(AWell.Row) + ', '
                                  + IntToStr(AWell.Column) + ', '
                                  + ParameterName;
                                if NameErrors.IndexOf(AString) < 0 then
                                begin
                                  NameErrors.Add(AString);
                                end;
                              end;
                            end;

                          end; // if DivThickness > 0 then
                        end; // for DivIndex := 1 to LayersPerUnit do
                      end; // if Pumpage <> 0 then
                    end;
                  end
                  else // if IsParam then
                  begin
                    for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    begin
                      if not ContinueExport then break;
                      Application.ProcessMessages;
                      Expression := LayerName + '.'
                        + StressIndicators[StressPeriodIndex];

                      PumpageTypeIndicator := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle,X,Y, Expression);
                      case PumpageTypeIndicator of
                        1:
                          begin
                            Expression := LayerName + '.' + QNames[StressPeriodIndex];

                            Pumpage := GridLayer.RealValueAtXY
                              (CurrentModelHandle,X,Y, Expression);
                          end;
                        2:
                          begin
                            Expression := LayerName + '.'
                              + QTotalNames[StressPeriodIndex];

                            Pumpage := GridLayer.RealValueAtXY
                              (CurrentModelHandle,X,Y, Expression);
                          end;
                        else
                          begin
                            Pumpage := 0;
                          end;
                      end; // case PumpageTypeIndicator of
                      if Pumpage <> 0 then
                      begin
                        if TopError1 then
                        begin
                          TopError1 := False;
                          TopErrors.Add(Format
                            ('[%d, %d] Top Elevation > top of unit', [AWell.Row, AWell.Column]));
                        end;
                        if BottomError1 then
                        begin
                          BottomError1 := False;
                          BottomErrors.Add(Format
                            ('[%d, %d] Top Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                        end;
                        if TopError2 then
                        begin
                          TopError2 := False;
                          TopErrors.Add(Format
                            ('[%d, %d] Bottom Elevation > top of unit', [AWell.Row, AWell.Column]));
                        end;
                        if BottomError2 then
                        begin
                          BottomError2 := False;
                          BottomErrors.Add(Format
                            ('[%d, %d] Bottom Elevation < bottom of unit', [AWell.Row, AWell.Column]));
                        end;
                        begin
                        if frmMODFLOW.cbMOC3D.Checked then
                        begin
                          Expression := LayerName + '.'
                            + ConcentrationNames[StressPeriodIndex];

                          AWell.Concentration := GridLayer.RealValueAtXY
                          (CurrentModelHandle,X,Y, Expression);
                        end;
                        end; // if frmMODFLOW.cbMOC3D.Checked then
                        if ModflowTypes.GetMFAreaWellLayerType.UseIFACE then
                        begin
                          Expression := LayerName + '.'
                            + IFACENames[StressPeriodIndex];

                          AWell.IFACE := GridLayer.IntegerValueAtXY
                          (CurrentModelHandle,X,Y, Expression);
                        end; // if frmMODFLOW.cbMODPATH.Checked then
                        if frmMODFLOW.cbMT3D.Checked then
                        begin
                          for SpeciesIndex := 1 to SpeciesCount do
                          begin
                            AWell.MT3DConcentrations[SpeciesIndex-1] :=
                              GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                              LayerName + '.' + MT3DConcentrationNames
                              [StressPeriodIndex, SpeciesIndex-1]);
                          end;
                        end;
                        ContourIntersectArea := 0;
                        if PumpageTypeIndicator = 2 then
                        begin
//                          TotalContourArea := 0;
                          AWell.ContourIndex := -1;
                          for ContourIndex := 0 to ContourCount - 1 do
                          begin
                            ContourIntersectArea := GContourIntersectCell(ContourIndex,
                              AWell.Column, AWell.Row);
                            if ContourIntersectArea > 0 then
                            begin
                              if GPointInsideContour(ContourIndex, X, Y)  then
                              begin
                                ContourAreaArray[StressPeriodIndex, ContourIndex] :=
                                  ContourAreaArray[StressPeriodIndex, ContourIndex] + ContourIntersectArea;
                                AWell.ContourIndex := ContourIndex;
                                break;
                              end;
                            end;
                            ContourIntersectArea := 0;
                          end;
                        end;
                        for DivIndex := 1 to LayersPerUnit do
                        begin
                          DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                            Top, UnitThickness, WellTop, WellBottom);
                          if DivThickness > 0 then
                          begin
                            if (PumpageTypeIndicator = 2) and (ContourIntersectArea <> 0) then
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                ContourIntersectArea;
                            end
                            else
                            begin
                              AWell.Q := DivThickness/WellThickness * Pumpage *
                                CellArea;
                              if (PumpageTypeIndicator = 2) then
                              begin
                                TotalCellArea := TotalCellArea + CellArea;
                              end;
                            end;

                            AWell.Layer := Layer + DivIndex;
                            if (PumpageTypeIndicator = 2) then
                            begin
//                              TotalCellArea := TotalCellArea + CellArea;
                              AWellList := TempWellTimes[StressPeriodIndex];
                              AWellList.Add(AWell);
                            end
                            else
                            begin
                              WellList := WellTimes[StressPeriodIndex];
                              WellList.Add(AWell);
                            end; // if PumpageTypeIndicator = 2 then
                          end;  // if DivThickness > 0 then
                        end; // for DivIndex := 1 to LayersPerUnit do
                      end; // if Pumpage <> 0 then
                    end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  end; // if IsParam then else
                end;
              end;  // if not IsNA then
            end;
          end;  // if not AreaBoundaryInBlock then
        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do
      for Index := TempParmNames.Count -1 downto 0 do
      begin
        AParamValue := TempParmNames.Objects[Index] as TWellParamValue;
        AParamValue.WellList.OwnsObjects := False;
        RealParamValue := ParameterNames.Objects[Index] as TWellParamValue;
        for WellIndex := AParamValue.WellList.Count -1 downto 0 do
        begin
          AWellObject := AParamValue.WellList[WellIndex] as TWell;
          if AWellObject.Well.ContourIndex < 0 then
          begin
            AWellObject.Well.Q := AWellObject.Well.Q/TotalCellArea;
          end
          else
          begin
            AWellObject.Well.Q := AWellObject.Well.Q/
              ContourAreaArray[Index, AWellObject.Well.ContourIndex]
          end;
          RealParamValue.WellList.Add(AWellObject);
          AParamValue.WellList.Delete(WellIndex);
        end;
        AParamValue.Free;
      end;
      for Index := TempWellTimes.Count -1 downto 0 do
      begin
        WellList := WellTimes[Index];
        AWellList := TempWellTimes[Index];
        for WellIndex := AWellList.Count -1 downto 0 do
        begin
          AWellObject := AWellList[WellIndex] as TWell;
          if AWellObject.Well.ContourIndex < 0 then
          begin
            AWellObject.Well.Q := AWellObject.Well.Q/TotalCellArea;
          end
          else
          begin   
            AWellObject.Well.Q := AWellObject.Well.Q/
              ContourAreaArray[Index,  AWellObject.Well.ContourIndex]
          end;
          WellList.Add(AWellObject);
        end;
        // AWellList doesn't own it's objects so it can be safely free'd.
        AWellList.Free;
      end;
    finally
      WellLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      QNames.Free;
      QTotalNames.Free;
      StressIndicators.Free;
      ConcentrationNames.Free;
      IFACENames.Free;
      ContourAreas.Free;
      TempParmNames.Free;
      TempWellTimes.Free;
    end;
      if TopErrors.Count > 0 then
      begin
        AString := 'Warning: Some Area well top elevations extend outside of the geologic '
          + 'unit in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'Top elevations outside the unit will be treated as if they '
          + 'are at the top of the unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(TopErrors);
      end;
      if BottomErrors.Count > 0 then
      begin
        AString := 'Warning: Some Area well bottom elevations extend outside of the geologic '
          + 'unit in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'Bottom elevations outside the unit will be treated as if they '
          + 'are at the bottom of the unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(BottomErrors);
      end;
      if ThicknessErrors.Count > 0 then
      begin
        AString := 'Warning: Some area well vertical extents are <= 0 in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'These wells will be skipped.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(ThicknessErrors);
      end;
      if NameErrors.Count > 0 then
      begin
        AString := 'Warning: Some area wells had invalid parameter names in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'These wells will be skipped.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col, Parameter Name]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(NameErrors);
      end;

    finally
      TopErrors.Free;
      BottomErrors.Free;
      ThicknessErrors.Free;
      NameErrors.Free;
    end;
  end;
end;

procedure TWellPkgWriter.EvaluateDataSets6and7(
  const CurrentModelHandle: ANE_PTR; Discretization : TDiscretizationWriter);
var
  UnitIndex : integer;
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try
{    while WellTimes.Count < StressPeriodCount do
    begin
      WellTimes.Add(TWellList.Create);
    end;    }

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
          // point wells
          frmProgress.lblActivity.Caption := 'Evaluating Point Wells in Unit '
            + IntToStr(UnitIndex);
          EvaluatePointLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // line wells
          frmProgress.lblActivity.Caption := 'Evaluating Line Wells in Unit '
            + IntToStr(UnitIndex);
          EvaluateLineLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area wells
          frmProgress.lblActivity.Caption := 'Evaluating Area Wells in Unit '
            + IntToStr(UnitIndex);
          EvaluateAreaLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
      end;
    end;
  finally
    ProjectOptions.Free;
  end;
  MakeWellListsConsistent;
end;

procedure TWellPkgWriter.MakeWellListsConsistent;
var
  ParamIndex: integer;
  Param: TWellParamValue;
  WellList1, WellList2 : TWellList;
  InstanceIndex1, InstanceIndex2: integer;
  ItemIndex: integer;
  WellObject : TWell;
  Well: TWellRecord;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    Param := ParameterNames.Objects[ParamIndex] as TWellParamValue;
    for InstanceIndex1 := 0 to Param.Instances.Count -1 do
    begin
      WellList1 := Param.Instances.Objects[InstanceIndex1] as TWellList;
      for InstanceIndex2 := 0 to Param.Instances.Count -1 do
      begin
        if InstanceIndex1 = InstanceIndex2 then
        begin
          Continue;
        end;

        WellList2 := Param.Instances.Objects[InstanceIndex2] as TWellList;
        for ItemIndex := 0 to WellList2.Count -1 do
        begin
          WellObject := WellList2.Items[ItemIndex] as TWell;
          Well := WellObject.Well;
          Well.Q := 0;
          SetLength(Well.MT3DConcentrations, Length(Well.MT3DConcentrations));
          WellList1.Add(Well);
        end;
      end;
    end;
  end;
end;

procedure TWellPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TWellParamValue;
//  AWellList : TWellList;
  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    WellTimes.Add(TWellList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS*3 ;
  frmProgress.lblPackage.Caption := 'Well';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;
  if ContinueExport then
  begin
    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
//    frmProgress.pbPackage.StepIt;
//    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SortWells;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;


  if ContinueExport then
  begin

    FileName := GetCurrentDir + '\' + Root + rsWEL;
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
      + ' contours in the WEL (Well) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the WEL (Well) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the WEL (Well) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TWellPkgWriter.SortWells;
var
  ParamIndex : integer;
  AParam : TWellParamValue;
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  WellList : TWellList;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting Wells';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParameterNames.Count + StressPeriodCount;

  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TWellParamValue;
    AParam.WellList.Sort;
    frmProgress.pbActivity.StepIt;
  end;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    WellList := WellTimes[StressPeriodIndex];
    WellList.Sort;
    frmProgress.pbActivity.StepIt;
  end;
end;


procedure TWellPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization : TDiscretizationWriter);
var
  Index : integer;
  ErrorMessage : string;
//  AParamValue : TWellParamValue;
//  AWellList : TWellList;
//  FileName : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    WellTimes.Add(TWellList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  
  frmProgress.pbPackage.Max := 2 ;
  frmProgress.lblPackage.Caption := 'Well';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;
  if ContinueExport then
  begin
    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SortWells;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
  if PointErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
      + ' contours in the WEL (Well) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the WEL (Well) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the WEL (Well) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
end;

procedure TWellPkgWriter.AddParameterNames;
begin
  AddParameterNamesToStringList(ParameterNames);
end;

procedure TWellPkgWriter.AddParameterNamesToStringList(NameList : TStringList);
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgWELParametersN.RowCount -1 do
  begin
    AddParameterNameToStringList(NameList, RowIndex);
  end;

end;

procedure TWellPkgWriter.AddParameterNameToStringList(NameList : TStringList;
  RowIndex : integer);
var
  ParamIndex : integer;
  AParamValue : TWellParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgWELParametersN.Cells[0,RowIndex]);
  ParamIndex := NameList.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TWellParamValue.Create(RowIndex);
    NameList.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different well parameters with the same name: ' + ParameterName
      + ' in the Well package.    Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create
//      ('Error: Two different well parameters with the same name: '
//      + '"ParameterName".');
  end;
end;

procedure TWellPkgWriter.WriteDataSet1;
var
  NPWEL : integer;
  ParamIndex : integer;
  AParam : TWellParamValue;
  WellList : TWellList;
begin
  MXL := 0;
  if ParameterNames.Count > 0 then
  begin
    NPWEL := ParameterNames.Count;
    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      AParam := ParameterNames.Objects[ParamIndex] as TWellParamValue;
      if AParam.Instances.Count > 0 then
      begin
        WellList := AParam.Instances.Objects[0] as TWellList;
        MXL := MXL + WellList.Count * AParam.Instances.Count;
      end
      else
      begin
        MXL := MXL + AParam.WellList.Count;
      end;
    end;
    Writeln(FFile, 'PARAMETER ', NPWEL, ' ', MXL);
  end;

end;

procedure TWellPkgWriter.WriteDataSet2;
var
  Index, MXACTW, IWELCB : integer;
  AWellList : TWellList;
  Option : string;
begin
  MXACTW := 0;
  for Index := 0 to WellTimes.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AWellList := WellTimes[Index];
    if AWellList.Count > MXACTW then
    begin
      MXACTW := AWellList.Count;
    end;
  end;
  MXACTW := MXACTW + MXL;
  if frmModflow.cbFlowWEL.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IWELCB := frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IWELCB := frmModflow.GetUnitNumber('WELBUD');
    end;
  end
  else
  begin
      IWELCB := 0;
  end;
  Option := '';
  if ModflowTypes.GetMFWellLayerType.UseIFACE then
  begin
    Option := Option + ' AUXILIARY IFACE'
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Option := Option + ' CBCALLOCATE AUXILIARY CONCENTRATION'
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
  begin
    Option := Option + ' AUXILIARY WELDENS'
  end;
  if not frmModflow.cbPrintCellLists.Checked then
  begin
    Option := Option + ' NOPRINT';
  end;
  Writeln(FFile, MXACTW, ' ', IWELCB, Option);
end;

procedure TWellPkgWriter.WriteDataSets3And4;
const
  PARTYP = '''Q'' ';
var
  ParamIndex, WellIndex, InstanceIndex : integer;
  AParam : TWellParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  AWell : TWell;
  WellList : TWellList;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    PARNAM := ParameterNames[ParamIndex];
    AParam := ParameterNames.Objects[ParamIndex] as TWellParamValue;
    Parval := AParam.Value;

    if AParam.Instances.Count > 0 then
    begin
      WellList := AParam.Instances.Objects[0] as TWellList;
    end
    else
    begin
      WellList := AParam.WellList;
    end;

    NLST := WellList.Count;

//    NLST := AParam.WellList.Count;
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
        WellList := AParam.Instances.Objects[InstanceIndex] as TWellList;
        for WellIndex := 0 to WellList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          AWell := WellList[WellIndex] as TWell;
          AWell.WriteWell(self);
        end;
      end;
    end
    else
    begin
      for WellIndex := 0 to AParam.WellList.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AWell := AParam.WellList[WellIndex] as TWell;
        AWell.WriteWell(self);
      end;
    end;
  end;
end;

procedure TWellPkgWriter.WriteDatasets5To7;
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

procedure TWellPkgWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  WellList : TWellList;
  ParamIndex : integer;
  AParam : TWellParamValue;
begin
  WellList := WellTimes[StressPeriodIndex];
  ITMP := WellList.Count;
  if (StressPeriodIndex >= 1) and (frmMODFLOW.comboWelSteady.ItemIndex = 0) then
  begin
    ITMP := -1;
  end;
  NP := 0;
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TWellParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Inc(NP);
    end;
  end;
  WriteLn(FFile, ITMP, ' ', NP);
end;

procedure TWellPkgWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  WellList : TWellList;
  AWell : TWell;
  WellIndex : integer;
begin
  WellList := WellTimes[StressPeriodIndex];
  for WellIndex := 0 to WellList.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AWell := WellList[WellIndex] as TWell;
    AWell.WriteWell(self);
  end;
end;

procedure TWellPkgWriter.WriteDataSet7(StressPeriodIndex: integer);
var
  ParamIndex : integer;
  AParam : TWellParamValue;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TWellParamValue;
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

function TWellPkgWriter.BoundaryUsed(Layer, Row, Column: integer): boolean;
var
  ListIndex : integer;
  WellList : TWellList;
  AWell : TWell;
  AParamValue : TWellParamValue;
  Index : integer;
begin
  result := False;
  for ListIndex := 0 to WellTimes.Count -1 do
  begin
    WellList := WellTimes[ListIndex];
    AWell := WellList.GetWellByLocation(Layer, Row, Column);
    result := AWell <> nil;
    if result then Exit;
  end;

  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TWellParamValue;
    AWell := AParamValue.WellList.GetWellByLocation(Layer, Row, Column);
    result := AWell <> nil;
    if result then Exit;
  end;

end;

constructor TWellPkgWriter.Create;
begin
  inherited;
  PointErrors := 0;
  LineErrors := 0;
  AreaErrors := 0;
  ParameterNames := TStringList.Create;
  WellTimes := TList.Create;
end;

destructor TWellPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TWellParamValue;
  AWellList : TWellList;
begin
  for Index := ParameterNames.Count -1 downto 0 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TWellParamValue;
    AParamValue.Free;
  end;
  ParameterNames.Free;

  for Index := WellTimes.Count -1 downto 0 do
  begin
    AWellList := WellTimes[Index];
    AWellList.Free;
  end;
  WellTimes.Free;
  inherited;

end;

{procedure TWellPkgWriter.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index : integer;
  AParamValue : TWellParamValue;
  WellList : TWellList;
begin
  if WellTimes.Count > 0 then
  begin
    WellList := WellTimes[0];
    WellList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TWellParamValue;
    AParamValue.WellList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
end; }

procedure TWellPkgWriter.WriteMT3DConcentrations(const StressPeriod: integer;
  const Lines: TStrings);
var
  ParamIndex, InstanceIndex : integer;
  AParam : TWellParamValue;
  WellList : TWellList;
  InstanceName : string;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TWellParamValue;

    if AParam.Instances.Count > 0 then
    begin
      InstanceName := AParam.InstanceNamesUsed[StressPeriod -1];
      InstanceIndex := AParam.Instances.IndexOf(InstanceName);
      if  InstanceIndex >= 0 then
      begin
        WellList := AParam.Instances.Objects[InstanceIndex] as TWellList;
        WellList.WriteMT3DConcentrations(Lines);
      end;
    end
    else
    begin
      AParam.WellList.WriteMT3DConcentrations(Lines);
    end;
  end;
  WellList := WellTimes[StressPeriod-1];
  WellList.WriteMT3DConcentrations(Lines);
end;

class procedure TWellPkgWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowWEL.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      frmModflow.GetUnitNumber('WELBUD');
    end;
  end;
end;

{ TWellParamValue }

constructor TWellParamValue.Create(RowIndex : Integer);
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
  AStringGrid := frmModflow.sg3dWelParamInstances.Grids[RowIndex-1];
  for InstanceIndex := 1 to AStringGrid.RowCount -1 do
  begin
    Instances.AddObject(AStringGrid.Cells[0,InstanceIndex], TWellList.Create);
  end;

  WellList := TWellList.Create;
  for TimeIndex := 0 to StressPeriodCount -1 do
  begin
    dgColumn := TimeIndex + 4;
    StressPeriodsUsed[TimeIndex]
      := (frmModflow.dgWELParametersN.Cells[dgColumn,RowIndex]
          <> frmModflow.dgWELParametersN.Columns[dgColumn].PickList[0]);
    InstanceNamesUsed[TimeIndex] := frmModflow.dgWELParametersN.Cells[dgColumn,RowIndex];
  end;
  Value := InternationalStrToFloat(frmModflow.dgWELParametersN.Cells[2,RowIndex]);
end;

destructor TWellParamValue.Destroy;
var
  Index : Integer;
begin
  if Instances <> nil then
  begin
    for Index := 0 to Instances.Count-1 do
    begin
      Instances.Objects[Index].Free;
    end;
  end;

  Instances.Free;
  WellList.Free;
  inherited;
end;

{ TWellList }

function TWellList.Add(AWell : TWellRecord): integer;
var
  WellObject : TWell;
  Index : integer;
  SpeciesIndex : integer;
  Identical : boolean;
begin
  for Index := 0 to Count -1 do
  begin
    WellObject := Items[Index] as TWell;
    With WellObject do
    begin
    if (Well. Layer = AWell.Layer) and
       (Well.Row = AWell.Row) and
       (Well.Column = AWell.Column) and
       (Well.IFACE = AWell.IFACE) and
       (Well.Concentration = AWell.Concentration) and
       (Well.FluidDensity = AWell.FluidDensity) and
       (Well.ContourIndex = AWell.ContourIndex) then
       begin
         Identical := True;
         for SpeciesIndex := 0 to Length(AWell.MT3DConcentrations) -1 do
         begin
           if (Well.MT3DConcentrations[SpeciesIndex] <> AWell.MT3DConcentrations[SpeciesIndex]) then
           begin
             Identical := False;
             break;
           end;
         end;

         if Identical then
         begin
           Well.Q := Well.Q + AWell.Q;
           result := Index;
           Exit;
         end;
       end;
    end;
  end;
  WellObject := TWell.Create;
  result := Add(WellObject);
  WellObject.Well.Layer := AWell.Layer;
  WellObject.Well.Row := AWell.Row;
  WellObject.Well.Column := AWell.Column;
  WellObject.Well.Q := AWell.Q;
  WellObject.Well.IFACE := AWell.IFACE;
  WellObject.Well.Concentration := AWell.Concentration;
  WellObject.Well.FluidDensity := AWell.FluidDensity;
  WellObject.Well.ContourIndex := AWell.ContourIndex;
  Copy1DDoubleArray(AWell.MT3DConcentrations,
    WellObject.Well.MT3DConcentrations);
end;


{procedure TWellList.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index : integer;
  AWell : TWell;
begin
  for Index := 0 to Count -1 do
  begin
    AWell := Items[Index] as TWell;
    if (AWell.Well.Layer = Layer) and (AWell.Well.Row = Row)
      and (AWell.Well.Column = Column) then
    begin
      BoundaryList.Add(TBoundaryCell.Create(AWell.Well.CellGroupNumber));
    end;
  end;
end;  }

function TWellList.GetWellByLocation(Layer, Row, Column: integer): TWell;
var
  Index : integer;
  AWell : TWell;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    AWell := Items[Index] as TWell;
    if (AWell.Well.Layer = Layer) and (AWell.Well.Row = Row)
      and (AWell.Well.Column = Column) then
    begin
      result := AWell;
      Exit;
    end;
  end;
end;

procedure TWellList.Sort;
begin
  inherited Sort(WellSortFunction);
end;

procedure TWellList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  AWell : TWell;
begin
  for Index := 0 to Count -1 do
  begin
    AWell := Items[Index] as TWell;
    AWell.WriteMT3DConcentrations(Lines);
  end;
end;

{ TWell }

procedure TWell.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  Assert(Length(Well.MT3DConcentrations) >=1);
  ALine := TModflowWriter.FixedFormattedInteger(Well.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Well.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Well.Column, 10)
    + TModflowWriter.FixedFormattedReal(Well.MT3DConcentrations[0], 10)
    + TModflowWriter.FixedFormattedInteger(2, 10) + ' ';
  for SpeciesIndex := 0 to Length(Well.MT3DConcentrations)-1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (Well.MT3DConcentrations[SpeciesIndex]);
  end;
  Lines.Add(ALine);
end;

procedure TWell.WriteWell(WellWriter : TWellPkgWriter);
begin
  Write(WellWriter.FFile, Well.Layer, ' ',  Well.Row, ' ',  Well.Column, ' ',
    WellWriter.FreeFormattedReal(Well.Q));
  if ModflowTypes.GetMFWellLayerType.UseIFACE then
  begin
    Write(WellWriter.FFile, ' ',  Well.IFACE, ' ');
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Write(WellWriter.FFile,  WellWriter.FreeFormattedReal(Well.Concentration));
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
  begin
    Write(WellWriter.FFile,  WellWriter.FreeFormattedReal(Well.FluidDensity));
  end;

  WriteLn(WellWriter.FFile);
end;

end.
