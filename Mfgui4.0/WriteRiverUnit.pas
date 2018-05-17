unit WriteRiverUnit;

interface

uses Sysutils, Classes, contnrs, Forms, Dialogs, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit, CopyArrayUnit;

type
  TReachRecord = record
    Layer, Row, Column : integer;
    Stage, CondFact, RBot : double;
    IFACE : integer;
    Concentration : double;
    CellGroupNumber : integer;
    MT3DConcentrations : T1DDoubleArray;
    Thickness: double;
    FluidDensity: double;
  end;

  TReach = class;

  TReachList = Class(TObjectList)
    function Add(AReach : TReachRecord) : integer; overload;
    function GetReachByLocation(Layer, Row, Column : integer) : TReach;
    procedure Sort;
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  private
    procedure FillBoundaryList(Layer, Row, Column: integer;
      BoundaryList : TObjectList);
  end;

  TRiverParamValue = Class(TObject)
  private
    Value : double;
    StressPeriodsUsed: Array of boolean;
    InstanceNamesUsed: array of string;
    ReachList : TReachList;
    Instances : TStringList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  TRiverPkgWriter = class(TCustomBoundaryWriterWithObservations)
  private
    ParameterNames : TStringList;
    ReachTimes : TList;
    MXL : integer;
    ITMP, NP : integer;
    PointErrors, LineErrors, AreaErrors: integer;
    Procedure AddParameterNameCell(ParameterName : string;
      AReach : TReachRecord; Const Instance : integer);
    Procedure AddParameterName(RowIndex : integer);
    procedure EvaluateDataSets6and7(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(out IsParamIndex, ParamNameIndex,
      ConductanceIndex, RBOT_Index, CellGroupIndex, ThicknessIndex,
      FluidDensityIndex: ANE_INT16;
      out IsParamName, ParamName, ConductanceName, RBotName, CellGroupName,
      ThicknessName, FluidDensityName: string;
      const CurrentModelHandle: ANE_PTR; RiverLayer : TLayerOptions;
      const PointLayer: boolean);
    procedure AddParameterNames;
    procedure EvaluatePointRiverLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization : TDiscretizationWriter);
    procedure EvaluateLineRiverLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaRiverLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3And4;
    procedure WriteDatasets5To7;
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    procedure WriteDataSet7(StressPeriodIndex : integer);
    procedure SortReaches;
    function GetParameterInstanceCount(const ParameterName: string): integer;
  public
    constructor Create;
    Destructor Destroy; override;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
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

  TReach = Class(TObject)
  private
    Reach : TReachRecord;
    procedure WriteReach(RiverWriter : TRiverPkgWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;


implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

function ReachSortFunction(Item1, Item2: Pointer): Integer;
var
  Reach1, Reach2 : TReach;
begin
  Reach1 := Item1;
  Reach2 := Item2;
  result := Reach1.Reach.Layer - Reach2.Reach.Layer;
  if Result <> 0 then Exit;
  result := Reach1.Reach.Row - Reach2.Reach.Row;
  if Result <> 0 then Exit;
  result := Reach1.Reach.Column - Reach2.Reach.Column;
end;

{ TRiverPkgWriter }

procedure TRiverPkgWriter.AddParameterNameCell(ParameterName : string;
      AReach : TReachRecord; Const Instance : integer);
var
  ParamIndex : integer;
  AParamValue : TRiverParamValue;
  AReachList : TReachList;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the River package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
    if AParamValue.Instances.Count > 0 then
    begin
      AReachList := AParamValue.Instances.Objects[Instance] as TReachList;
    end
    else
    begin
      AReachList := AParamValue.ReachList;
    end;
    AReachList.Add(AReach);
  end;
end;


procedure TRiverPkgWriter.GetParamIndicies(out IsParamIndex, ParamNameIndex,
  ConductanceIndex, RBOT_Index, CellGroupIndex, ThicknessIndex,
  FluidDensityIndex: ANE_INT16;
  out IsParamName, ParamName, ConductanceName, RBotName, CellGroupName,
  ThicknessName, FluidDensityName: string;
  const CurrentModelHandle: ANE_PTR; RiverLayer : TLayerOptions;
  const PointLayer: boolean);
begin
  IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
  IsParamIndex := RiverLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

  ParamName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  ParamNameIndex := RiverLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  if PointLayer or frmModflow.cbCondRiv.Checked then
  begin
    ConductanceName := ModflowTypes.GetMFRiverConductanceParamType.WriteParamName;
  end
  else
  begin
    ConductanceName := ModflowTypes.GetMFRiverConductanceParamType.WriteFactorName;
  end;
  ConductanceIndex := RiverLayer.GetParameterIndex(CurrentModelHandle, ConductanceName);

  RBotName := ModflowTypes.GetMFRiverBottomParamType.WriteParamName;
  RBOT_Index := RiverLayer.GetParameterIndex(CurrentModelHandle, RBotName);

  CellGroupName := ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName;
  CellGroupIndex := RiverLayer.GetParameterIndex(CurrentModelHandle, CellGroupName);

  if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
  begin
    ThicknessName := ModflowTypes.GetMFRiverBedThicknessParamType.WriteParamName;
    ThicknessIndex := RiverLayer.GetParameterIndex(CurrentModelHandle, ThicknessName);
  end
  else
  begin
    ThicknessName := '';
    ThicknessIndex := -1;
  end;

  if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
  begin
    FluidDensityName := ModflowTypes.GetMFBoundaryDensityParamType.WriteParamName;
    FluidDensityIndex := RiverLayer.GetParameterIndex(CurrentModelHandle, FluidDensityName);
  end
  else
  begin
    FluidDensityName := '';
    FluidDensityIndex := -1;
  end;
end;

function TRiverPkgWriter.GetParameterInstanceCount(const ParameterName : string) : integer;
var
  ParamIndex : integer;
  AParamValue : TRiverParamValue;
  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    result := -1;
    ErrorMessage := 'Error: Invalid parameter name: ' + ParameterName
      + ' in the River package.  Contours using this parameter name will be '
      + 'ignored.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
    result := AParamValue.Instances.Count;
    if result = 0 then
    begin
      result := 1;
    end
  end;
end;

procedure TRiverPkgWriter.EvaluatePointRiverLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  RiverLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  RBOT_Index : ANE_INT16;
  CellGroupIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  StageIndicies : array of ANE_INT32;
  ConcentrationIndicies : array of ANE_INT32;
  MT3DConcentrationIndicies : array of array of ANE_INT32;
  IFACEIndicies : array of ANE_INT32;
  IsOnIndicies : array of ANE_INT32;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  AReach : TReachRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  ReachList : TReachList;
  IsParamName, ParamName, ConductanceName, RBotName, CellGroupName: string;
  Used : boolean;
  RiverErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  ThicknessIndex : ANE_INT16;
  ThicknessName: string;
  FluidDensityIndex: ANE_INT16;
  FluidDensityName: string;
begin
  SpeciesCount := 0;
  AReach.Stage := 0;
  AReach.CondFact := 0;
  AReach.RBot := 0;
  AReach.IFACE := 0;
  AReach.Concentration := 0;

  // point rivers
  RiverErrors := TStringList.Create;
  try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboRivSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(StageIndicies,StressPeriodCount);
    SetLength(IsOnIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end;
    if ModflowTypes.GetMFPointRiverLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(AReach.MT3DConcentrations, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFPointRiverLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    RiverLayer := TLayerOptions.Create(LayerHandle);
    try
      ContourCount := RiverLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex, ConductanceIndex,
        RBOT_Index, CellGroupIndex, ThicknessIndex, FluidDensityIndex,
          IsParamName, ParamName, ConductanceName, RBotName, CellGroupName,
          ThicknessName, FluidDensityName, CurrentModelHandle,
          RiverLayer, True);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFRiverStageParamType.WriteParamName
            + IntToStr(TimeIndex);
          StageIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFOnOffParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if frmMODFLOW.cbMOC3D.Checked then
          begin
            TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
              + IntToStr(TimeIndex);
            ConcentrationIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end;
          if ModflowTypes.GetMFPointRiverLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACEIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
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
                := RiverLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
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
              if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
              begin
                AReach.Thickness := Contour.GetFloatParameter
                  (CurrentModelHandle,ThicknessIndex);
              end
              else
              begin
                AReach.Thickness := 0;
              end;
              if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
              begin
                AReach.FluidDensity := Contour.GetFloatParameter
                  (CurrentModelHandle,FluidDensityIndex);
              end
              else
              begin
                AReach.FluidDensity := 0;
              end;

              IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
              if IsParam then
              begin
                ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
                InstanceLimit := GetParameterInstanceCount(ParameterName);
              end;

              AReach.CondFact := Contour.GetFloatParameter(CurrentModelHandle,ConductanceIndex);
              Conductance := AReach.CondFact;
              AReach.RBot := Contour.GetFloatParameter
                (CurrentModelHandle,RBOT_Index);
              AReach.CellGroupNumber := Contour.GetIntegerParameter
                (CurrentModelHandle,CellGroupIndex);

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                AReach.Row := GGetCellRow(ContourIndex, CellIndex);
                AReach.Column := GGetCellColumn(ContourIndex, CellIndex);
                Top := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex-1];
                Bottom := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex];
                if IsParam then
                begin
                  for StressPeriodIndex := 0 to InstanceLimit-1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                    if Used then
                    begin
                      AReach.CondFact := Conductance;
                    end
                    else
                    begin
                      AReach.CondFact := 0;
                    end;
                    AReach.Stage := Contour.GetFloatParameter(CurrentModelHandle,StageIndicies[StressPeriodIndex]);
                    if ShowWarnings then
                    begin
                      if AReach.Stage > Top then
                      begin
                        RiverErrors.Add(Format
                          ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                      end;
                      if AReach.Stage < Bottom then
                      begin
                        RiverErrors.Add(Format
                          ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                      end;
                    end;
                    AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      AReach.Concentration := Contour.GetFloatParameter
                        (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                    end;
                    if ModflowTypes.GetMFPointRiverLayerType.UseIFACE then
                    begin
                      AReach.IFACE := Contour.GetIntegerParameter
                        (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                    end;
                    if frmMODFLOW.cbMT3D.Checked then
                    begin
                      for SpeciesIndex := 1 to SpeciesCount do
                      begin
                        AReach.MT3DConcentrations[SpeciesIndex-1] :=
                          Contour.GetFloatParameter(CurrentModelHandle,
                          MT3DConcentrationIndicies
                            [StressPeriodIndex, SpeciesIndex-1]);
                      end;
                    end;
                    AddParameterNameCell(ParameterName,AReach,StressPeriodIndex);
                  end;
//                  end
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
                      AReach.CondFact := Conductance;
                    end
                    else
                    begin
                      AReach.CondFact := 0;
                    end;
                    AReach.Stage := Contour.GetFloatParameter(CurrentModelHandle,
                      StageIndicies[StressPeriodIndex]);
                    if ShowWarnings then
                    begin
                      if AReach.Stage > Top then
                      begin
                        RiverErrors.Add(Format
                          ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                      end;
                      if AReach.Stage < Bottom then
                      begin
                        RiverErrors.Add(Format
                          ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                      end;
                    end;
                    AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      AReach.Concentration := Contour.GetFloatParameter
                        (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                    end;
                    if ModflowTypes.GetMFPointRiverLayerType.UseIFACE then
                    begin
                      AReach.IFACE := Contour.GetIntegerParameter
                        (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                    end;
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          AReach.MT3DConcentrations[SpeciesIndex-1] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            MT3DConcentrationIndicies
                              [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    ReachList := ReachTimes[StressPeriodIndex];
                    ReachList.Add(AReach);
//                    end;
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
      RiverLayer.Free(CurrentModelHandle);
    end;
    if RiverErrors.Count > 0 then
    begin
      AString := 'Warning: Some point river stages extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Rivers below the bottom of the unit will be treated as if they '
        + 'are at the bottom of the unit for the purposes of determining in which '
        + 'layer within the unit the river belongs.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := 'Rivers above the top of the unit will be treated as if they '
        + 'are at the top of the unit for the purposes of determining in which '
        + 'layer within the unit the river belongs.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(RiverErrors);
    end;
  finally
    RiverErrors.Free;
  end;
end;

procedure TRiverPkgWriter.EvaluateLineRiverLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  RiverLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  RBOT_Index : ANE_INT16;
  CellGroupIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  StageIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  MT3DConcentrationIndicies : array of array of Integer;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  MT3DConcentrationNames : array of array of string;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  AReach : TReachRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  ReachList : TReachList;
  ContourConductance : double;
  ContourLength : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, RBotName, CellGroupName: string;
  StageNames : TStringList;
  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  Used : boolean;
  RiverErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  ThicknessIndex : ANE_INT16;
  ThicknessName: string;
  FluidDensityIndex: ANE_INT16;
  FluidDensityName: string;
begin
  // line rivers
  IsParam := False;
  SpeciesCount := 0;
  SetLength(AReach.MT3DConcentrations, 0);
  AReach.Stage := 0;
  AReach.CondFact := 0;
  AReach.RBot := 0;
  AReach.IFACE := 0;
  AReach.Concentration := 0;
  RiverErrors := TStringList.Create;
  try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboRivSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(StageIndicies,StressPeriodCount);
    SetLength(IsOnIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end;
    if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(AReach.MT3DConcentrations, SpeciesCount);
      SetLength(MT3DConcentrationNames,StressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFLineRiverLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    RiverLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    StageNames := TStringList.Create;
    ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    try
      ContourCount := RiverLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(IsParamIndex, ParamNameIndex, ConductanceIndex,
          RBOT_Index, CellGroupIndex, ThicknessIndex, FluidDensityIndex,
          IsParamName, ParamName, ConductanceName, RBotName, CellGroupName,
          ThicknessName, FluidDensityName,
          CurrentModelHandle, RiverLayer, False);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetMFRiverStageParamType.WriteParamName
            + IntToStr(TimeIndex);
          StageNames.Add(TimeParamName);
          StageIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFOnOffParamType.WriteParamName
            + IntToStr(TimeIndex);
          IsOnIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if frmMODFLOW.cbMOC3D.Checked then
          begin
            TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
              + IntToStr(TimeIndex);
            ConcentrationNames.Add(TimeParamName);
            ConcentrationIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; // if frmMODFLOW.cbMOC3D.Checked then
          if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
          begin
            TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
              + IntToStr(TimeIndex);
            IFACENames.Add(TimeParamName);
            IFACEIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
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
                := RiverLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
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
              if not frmMODFLOW.cbAltRiv.Checked then
              begin
                ContourConductance := Contour.GetFloatParameter(CurrentModelHandle,ConductanceIndex);
                AReach.RBot := Contour.GetFloatParameter(CurrentModelHandle,RBOT_Index);
                IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
                if IsParam then
                begin
                  ParameterName := Contour.GetStringParameter
                    (CurrentModelHandle,ParamNameIndex);
                  InstanceLimit := GetParameterInstanceCount(ParameterName);
                end; // if IsParam then
                AReach.CellGroupNumber := Contour.GetIntegerParameter
                  (CurrentModelHandle,CellGroupIndex);
                if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
                begin
                  AReach.Thickness := Contour.GetFloatParameter
                    (CurrentModelHandle,ThicknessIndex);
                end
                else
                begin
                  AReach.Thickness := 0;
                end;
                if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
                begin
                  AReach.FluidDensity := Contour.GetFloatParameter
                    (CurrentModelHandle,FluidDensityIndex);
                end
                else
                begin
                  AReach.FluidDensity := 0;
                end;

              end; // if not frmMODFLOW.cbAltRiv.Checked then

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                AReach.Row := GGetCellRow(ContourIndex, CellIndex);
                AReach.Column := GGetCellColumn(ContourIndex, CellIndex);
                ContourLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);
                Top := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex-1];
                Bottom := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex];
                if frmMODFLOW.cbAltRiv.Checked then
                begin
                  BlockIndex := Discretization.BlockIndex(AReach.Row-1,AReach.Column-1);
                  ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                    Discretization.GridLayerHandle, BlockIndex);
                  try
                    ABlock.GetCenter(CurrentModelHandle, X, Y);
                  finally
                    ABlock.Free;
                  end;
                  ContourConductance := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + ConductanceName);
                  if frmModflow.cbCondRiv.Checked then
                  begin
                    AReach.CondFact := ContourConductance;
                  end
                  else
                  begin
                    AReach.CondFact := ContourConductance*ContourLength;
                  end;
                  Conductance := AReach.CondFact;

                  IsParam := GridLayer.BooleanValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + IsParamName);
                  if IsParam then
                  begin
                    ParameterName := GridLayer.StringValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + ParamName);
                    InstanceLimit := GetParameterInstanceCount(ParameterName);
                  end; // if IsParam then
                  AReach.CellGroupNumber := GridLayer.IntegerValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + CellGroupName);
                  if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
                  begin
                    AReach.Thickness := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + ThicknessName);
                  end
                  else
                  begin
                    AReach.Thickness := 0;
                  end;
                  if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
                  begin
                    AReach.FluidDensity := GridLayer.RealValueAtXY
                    (CurrentModelHandle, X, Y, LayerName + '.' + FluidDensityName);
                  end
                  else
                  begin
                    AReach.FluidDensity := 0;
                  end;
                end
                else // if frmMODFLOW.cbAltRiv.Checked then
                begin
                  if frmModflow.cbCondRiv.Checked then
                  begin
                    AReach.CondFact := ContourConductance;
                  end
                  else
                  begin
                    AReach.CondFact := ContourConductance*ContourLength;
                  end;
                  Conductance := AReach.CondFact;
                end; // if frmMODFLOW.cbAltRiv.Checked then else
                if IsParam then
                begin
                  for StressPeriodIndex := 0 to InstanceLimit-1 do
                  begin
                    Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                    if Used then
                    begin
                      AReach.CondFact := Conductance;
                    end
                    else
                    begin
                      AReach.CondFact := 0;
                    end;
                    if frmMODFLOW.cbAltRiv.Checked then
                    begin
                      AReach.Stage := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + StageNames[StressPeriodIndex]);
                      if ShowWarnings then
                      begin
                        if AReach.Stage > Top then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                        end;
                        if AReach.Stage < Bottom then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                        end;
                      end;
                      AReach.RBot := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + RBotName);

                      AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin // if frmMODFLOW.cbMOC3D.Checked then
                        AReach.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                      end;
                      if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
                      begin
                        AReach.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMODPATH.Checked then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          AReach.MT3DConcentrations[SpeciesIndex-1] :=
                            GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                            LayerName + '.' + MT3DConcentrationNames
                            [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end
                    else // if frmMODFLOW.cbAltRiv.Checked then
                    begin
                      AReach.Stage := Contour.GetFloatParameter(CurrentModelHandle,StageIndicies[StressPeriodIndex]);
                      if ShowWarnings then
                      begin
                        if AReach.Stage > Top then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                        end;
                        if AReach.Stage < Bottom then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                        end;
                      end;
                      AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin
                        AReach.Concentration := Contour.GetFloatParameter
                          (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMOC3D.Checked then
                      if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
                      begin
                        AReach.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end;  // if frmMODFLOW.cbMODPATH.Checked then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          AReach.MT3DConcentrations[SpeciesIndex-1] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            MT3DConcentrationIndicies
                              [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end;
                    AddParameterNameCell(ParameterName,AReach,StressPeriodIndex);
                  end;
                end
                else // if IsParam then
                begin
                  if frmMODFLOW.cbAltRiv.Checked then
                  begin
                    AReach.RBot := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + RBotName);
                  end;
                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                    if Used then
                    begin
                      AReach.CondFact := Conductance;
                    end
                    else
                    begin
                      AReach.CondFact := 0;
                    end;
                    if frmMODFLOW.cbAltRiv.Checked then
                    begin
                      AReach.Stage := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + StageNames[StressPeriodIndex]);
                      if ShowWarnings then
                      begin
                        if AReach.Stage > Top then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                        end;
                        if AReach.Stage < Bottom then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                        end;
                      end;

                      AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin // if frmMODFLOW.cbMOC3D.Checked then
                        AReach.Concentration := GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                      end;
                      if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
                      begin
                        AReach.IFACE := GridLayer.IntegerValueAtXY
                        (CurrentModelHandle, X, Y, LayerName + '.' + IFACENames[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMODPATH.Checked then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          AReach.MT3DConcentrations[SpeciesIndex-1] :=
                            GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                            LayerName + '.' + MT3DConcentrationNames
                            [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end
                    else
                    begin
                      AReach.Stage := Contour.GetFloatParameter(CurrentModelHandle,
                        StageIndicies[StressPeriodIndex]);
                      if ShowWarnings then
                      begin
                        if AReach.Stage > Top then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                        end;
                        if AReach.Stage < Bottom then
                        begin
                          RiverErrors.Add(Format
                            ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                        end;
                      end;
                      AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                      if frmMODFLOW.cbMOC3D.Checked then
                      begin
                        AReach.Concentration := Contour.GetFloatParameter
                          (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMOC3D.Checked then
                      if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
                      begin
                        AReach.IFACE := Contour.GetIntegerParameter
                          (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                      end; // if frmMODFLOW.cbMODPATH.Checked then
                      if frmMODFLOW.cbMT3D.Checked then
                      begin
                        for SpeciesIndex := 1 to SpeciesCount do
                        begin
                          AReach.MT3DConcentrations[SpeciesIndex-1] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            MT3DConcentrationIndicies
                              [StressPeriodIndex, SpeciesIndex-1]);
                        end;
                      end;
                    end;
                    ReachList := ReachTimes[StressPeriodIndex];
                    ReachList.Add(AReach);
//                    end;
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
      RiverLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      StageNames.Free;
      ConcentrationNames.Free;
      IFACENames.Free;
    end;
    if RiverErrors.Count > 0 then
    begin
      AString := 'Warning: Some line river stages extend outside of the geologic '
        + 'unit in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Rivers below the bottom of the unit will be treated as if they '
        + 'are at the bottom of the unit for the purposes of determining in which '
        + 'layer within the unit the river belongs.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := 'Rivers above the top of the unit will be treated as if they '
        + 'are at the top of the unit for the purposes of determining in which '
        + 'layer within the unit the river belongs.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := '[Row, Col]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(RiverErrors);
    end;
  finally
    RiverErrors.Free;
  end;
end;

procedure TRiverPkgWriter.EvaluateAreaRiverLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  RiverLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductanceIndex : ANE_INT16;
  RBOT_Index : ANE_INT16;
  CellGroupIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  StageIndicies : array of Integer;
  ConcentrationIndicies : array of Integer;
  IFACEIndicies : array of Integer;
  IsOnIndicies : array of Integer;
  MT3DConcentrationIndicies : array of array of Integer;
  MT3DConcentrationNames : array of array of string;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  AReach : TReachRecord;
//  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  ReachList : TReachList;
  ContourConductance : double;
  ContourIntersectArea : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, ConductanceName, RBotName, CellGroupName: string;
  StageNames : TStringList;
  IsOnNames : TStringList;
  ConcentrationNames : TStringList;
  IFACENames : TStringList;
  ColIndex, RowIndex : integer;
  AreaBoundaryInBlock : boolean;
  IsNA : boolean;
  CellArea : double;
  Used : boolean;
  Expression : string;
  RiverErrors : TStringList;
  AString : string;
  Conductance : double;
  InstanceLimit : integer;
  SpeciesIndex : integer;
  SpeciesCount : integer;
  ThicknessIndex : ANE_INT16;
  ThicknessName: string;
  FluidDensityIndex: ANE_INT16;
  FluidDensityName: string;
begin
  // area rivers
  AReach.Stage := 0;
  AReach.CondFact := 0;
  AReach.RBot := 0;
  AReach.IFACE := 0;
  AReach.Concentration := 0;

  if frmModflow.cbUseAreaRivers.Checked then
  begin
    RiverErrors := TStringList.Create;
    try
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    if frmMODFLOW.comboRivSteady.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(StageIndicies,StressPeriodCount);
    SetLength(IsOnIndicies,StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(ConcentrationIndicies,StressPeriodCount);
    end;
    if ModflowTypes.GetMFAreaRiverLayerType.UseIFACE then
    begin
      SetLength(IFACEIndicies,StressPeriodCount);
    end;
    if frmMODFLOW.cbMT3D.Checked then
    begin
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(MT3DConcentrationIndicies,StressPeriodCount, SpeciesCount);
      SetLength(AReach.MT3DConcentrations, SpeciesCount);
      SetLength(MT3DConcentrationNames,StressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFAreaRiverLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    SetAreaValues;
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    RiverLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    StageNames := TStringList.Create;
    ConcentrationNames := TStringList.Create;
    IFACENames := TStringList.Create;
    IsOnNames := TStringList.Create;
    try
      GetParamIndicies(IsParamIndex, ParamNameIndex, ConductanceIndex,
        RBOT_Index, CellGroupIndex, ThicknessIndex, FluidDensityIndex,
        IsParamName, ParamName, ConductanceName, RBotName, CellGroupName,
        ThicknessName, FluidDensityName,
        CurrentModelHandle, RiverLayer, False);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        TimeParamName := ModflowTypes.GetMFRiverStageParamType.WriteParamName
          + IntToStr(TimeIndex);
        StageNames.Add(TimeParamName);
        StageIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFOnOffParamType.WriteParamName
          + IntToStr(TimeIndex);
        IsOnNames.Add(TimeParamName);
        IsOnIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationNames.Add(TimeParamName);
          ConcentrationIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; // if frmMODFLOW.cbMOC3D.Checked then
        if ModflowTypes.GetMFAreaRiverLayerType.UseIFACE then
        begin
          TimeParamName := ModflowTypes.GetMFIFACEParamType.WriteParamName
            + IntToStr(TimeIndex);
          IFACENames.Add(TimeParamName);
          IFACEIndicies[TimeIndex -1] := RiverLayer.GetParameterIndex
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
              := RiverLayer.GetParameterIndex(CurrentModelHandle, TimeParamName);
          end;
        end;
      end; // for TimeIndex := 1 to StressPeriodCount do

      ContourCount := RiverLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if frmModflow.cbAltRiv.Checked then
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;
      end
      else
      begin
        frmProgress.pbActivity.Max := Discretization.NCOL
          * Discretization.NROW * ContourCount;
        if not frmModflow.cbAreaRiverContour.Checked then
        begin
          frmProgress.pbActivity.Max := frmProgress.pbActivity.Max
            + Discretization.NCOL * Discretization.NROW;
        end;
      end;

      for ColIndex := 1 to Discretization.NCOL do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        for RowIndex := 1 to Discretization.NROW do
        begin
          try
          if not ContinueExport then break;
          Application.ProcessMessages;
          AreaBoundaryInBlock := False;
          if not frmModflow.cbAltRiv.Checked then
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
                  if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
                  begin
                    AReach.Thickness := Contour.GetFloatParameter(
                      CurrentModelHandle,ThicknessIndex);
                  end
                  else
                  begin
                    AReach.Thickness := 0;
                  end;
                  if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
                  begin
                    AReach.FluidDensity := Contour.GetFloatParameter(
                      CurrentModelHandle,FluidDensityIndex);
                  end
                  else
                  begin
                    AReach.FluidDensity := 0;
                  end;

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
                    AReach.RBot := Contour.GetFloatParameter
                      (CurrentModelHandle,RBOT_Index);
                    AReach.CellGroupNumber := Contour.GetIntegerParameter(CurrentModelHandle, CellGroupIndex);

                    AReach.Row := RowIndex;
                    AReach.Column := ColIndex;
                    Top := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex-1];
                    Bottom := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex];
                    if frmModflow.cbCondRiv.Checked then
                    begin
                      AReach.CondFact := ContourConductance;
                    end
                    else
                    begin
                      AReach.CondFact := ContourConductance*ContourIntersectArea;
                    end;
                    Conductance := AReach.CondFact;
                    if IsParam then
                    begin
                      for StressPeriodIndex := 0 to InstanceLimit-1 do
                      begin
                        Used := Contour.GetBoolParameter(CurrentModelHandle,IsOnIndicies[StressPeriodIndex]);
                        if Used then
                        begin
                          AReach.CondFact := Conductance;
                        end
                        else
                        begin
                          AReach.CondFact := 0;
                        end;
                        AReach.Stage := Contour.GetFloatParameter(CurrentModelHandle,StageIndicies[StressPeriodIndex]);
                        if ShowWarnings then
                        begin
                          if AReach.Stage > Top then
                          begin
                            RiverErrors.Add(Format
                              ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                          end;
                          if AReach.Stage < Bottom then
                          begin
                            RiverErrors.Add(Format
                              ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                          end;
                        end;
                        AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                        if frmMODFLOW.cbMOC3D.Checked then
                        begin
                          AReach.Concentration := Contour.GetFloatParameter
                            (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                        end; // if frmMODFLOW.cbMOC3D.Checked then
                        if ModflowTypes.GetMFAreaRiverLayerType.UseIFACE then
                        begin
                          AReach.IFACE := Contour.GetIntegerParameter
                            (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                        end;  // if frmMODFLOW.cbMODPATH.Checked then
                        if frmMODFLOW.cbMT3D.Checked then
                        begin
                          for SpeciesIndex := 1 to SpeciesCount do
                          begin
                            AReach.MT3DConcentrations[SpeciesIndex-1] :=
                              Contour.GetFloatParameter(CurrentModelHandle,
                              MT3DConcentrationIndicies
                                [StressPeriodIndex, SpeciesIndex-1]);
                          end;
                        end;
                        AddParameterNameCell(ParameterName,AReach,StressPeriodIndex);
                      end;
  //                    end;
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
                          AReach.CondFact := Conductance;
                        end
                        else
                        begin
                          AReach.CondFact := 0;
                        end;
                        AReach.Stage := Contour.GetFloatParameter(CurrentModelHandle,
                          StageIndicies[StressPeriodIndex]);
                        if ShowWarnings then
                        begin
                          if AReach.Stage > Top then
                          begin
                            RiverErrors.Add(Format
                              ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                          end;
                          if AReach.Stage < Bottom then
                          begin
                            RiverErrors.Add(Format
                              ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                          end;
                        end;
                        AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                        if frmMODFLOW.cbMOC3D.Checked then
                        begin
                          AReach.Concentration := Contour.GetFloatParameter
                            (CurrentModelHandle,ConcentrationIndicies[StressPeriodIndex]);
                        end; // if frmMODFLOW.cbMOC3D.Checked then
                        if ModflowTypes.GetMFAreaRiverLayerType.UseIFACE then
                        begin
                          AReach.IFACE := Contour.GetIntegerParameter
                            (CurrentModelHandle,IFACEIndicies[StressPeriodIndex]);
                        end; // if frmMODFLOW.cbMODPATH.Checked then
                        if frmMODFLOW.cbMT3D.Checked then
                        begin
                          for SpeciesIndex := 1 to SpeciesCount do
                          begin
                            AReach.MT3DConcentrations[SpeciesIndex-1] :=
                              Contour.GetFloatParameter(CurrentModelHandle,
                              MT3DConcentrationIndicies
                                [StressPeriodIndex, SpeciesIndex-1]);
                          end;
                        end;
                        ReachList := ReachTimes[StressPeriodIndex];
                        ReachList.Add(AReach);
  //                      end;
                      end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    end; // if IsParam then else
                  end;
                end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
              finally
                Contour.Free;
              end;

            end; // for ContourIndex := 0 to ContourCount -1 do
          end; // if not frmModflow.cbAltRiv.Checked then
          if not ContinueExport then break;

          if frmModflow.cbAreaRiverContour.Checked then
          begin
            // only use contours.
            Continue;
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;

          if frmModflow.cbAltRiv.Checked then
          begin
            CellArea := GGetCellArea(ColIndex,RowIndex);
          end
          else
          begin
            CellArea := GContourIntersectCellRemainder(ColIndex,RowIndex);
          end;
          if not frmModflow.cbAreaRiverContour.Checked and (CellArea > 0) and
            (frmModflow.cbAltRiv.Checked or not AreaBoundaryInBlock) then
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex -1, ColIndex -1);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle,BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle,X,Y);
            finally
              ABlock.Free;
            end;

            if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
            begin
              Expression := LayerName + '.' + ThicknessName;
              AReach.Thickness := GridLayer.RealValueAtXY(CurrentModelHandle,X,Y,
                Expression);
            end
            else
            begin
              AReach.Thickness := 0;
            end;
            if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
            begin
              Expression := LayerName + '.' + FluidDensityName;
              AReach.FluidDensity := GridLayer.RealValueAtXY(CurrentModelHandle,X,Y,
                Expression);
            end
            else
            begin
              AReach.FluidDensity := 0;
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

              Expression := LayerName + '.' + RBotName;

              AReach.RBot := GridLayer.RealValueAtXY
                (CurrentModelHandle,X,Y, Expression);

              Expression := LayerName + '.' + CellGroupName;
              AReach.CellGroupNumber := GridLayer.IntegerValueAtXY
                (CurrentModelHandle,X,Y, Expression);

              AReach.Row := RowIndex;
              AReach.Column := ColIndex;
              Top := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex-1];
              Bottom := Discretization.Elevations[AReach.Column-1,AReach.Row-1,UnitIndex];
              if frmModflow.cbCondRiv.Checked then
              begin
                AReach.CondFact := ContourConductance;
              end
              else
              begin
                AReach.CondFact := ContourConductance*CellArea;
              end;
              Conductance := AReach.CondFact;
              if IsParam then
              begin
                for StressPeriodIndex := 0 to InstanceLimit-1 do
                begin
                  Used := GridLayer.BooleanValueAtXY
                    (CurrentModelHandle,X,Y, LayerName + '.' + IsOnNames[StressPeriodIndex]);
                  if Used then
                  begin
                    AReach.CondFact := Conductance;
                  end
                  else
                  begin
                    AReach.CondFact := 0;
                  end;
                  Expression := LayerName + '.' + StageNames[StressPeriodIndex];

                  AReach.Stage := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  if ShowWarnings then
                  begin
                    if AReach.Stage > Top then
                    begin
                      RiverErrors.Add(Format
                        ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                    end;
                    if AReach.Stage < Bottom then
                    begin
                      RiverErrors.Add(Format
                        ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                    end;
                  end;
                  AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                  if frmMODFLOW.cbMOC3D.Checked then
                  begin
                    Expression := LayerName + '.' + ConcentrationNames[StressPeriodIndex];

                    AReach.Concentration := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  end; // if frmMODFLOW.cbMOC3D.Checked then
                  if ModflowTypes.GetMFAreaRiverLayerType.UseIFACE then
                  begin
                    Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                    AReach.IFACE := GridLayer.IntegerValueAtXY
                      (CurrentModelHandle,X,Y, Expression);
                  end;  // if frmMODFLOW.cbMODPATH.Checked then
                  if frmMODFLOW.cbMT3D.Checked then
                  begin
                    for SpeciesIndex := 1 to SpeciesCount do
                    begin
                      AReach.MT3DConcentrations[SpeciesIndex-1] :=
                        GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                        LayerName + '.' + MT3DConcentrationNames
                        [StressPeriodIndex, SpeciesIndex-1]);
                    end;
                  end;
                  AddParameterNameCell(ParameterName,AReach, StressPeriodIndex);
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
                    AReach.CondFact := Conductance;
                  end
                  else
                  begin
                    AReach.CondFact := 0;
                  end;
                  Expression := LayerName + '.' + StageNames[StressPeriodIndex];

                  AReach.Stage := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  if ShowWarnings then
                  begin
                    if AReach.Stage > Top then
                    begin
                      RiverErrors.Add(Format
                        ('[%d, %d] Elevation > top of unit', [AReach.Row, AReach.Column]));
                    end;
                    if AReach.Stage < Bottom then
                    begin
                      RiverErrors.Add(Format
                        ('[%d, %d] Elevation < bottom of unit', [AReach.Row, AReach.Column]));
                    end;
                  end;
                  AReach.Layer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, AReach.Stage);
                  if frmMODFLOW.cbMOC3D.Checked then
                  begin
                    Expression := LayerName + '.' + ConcentrationNames[StressPeriodIndex];

                    AReach.Concentration := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  end; // if frmMODFLOW.cbMOC3D.Checked then
                  if ModflowTypes.GetMFAreaRiverLayerType.UseIFACE then
                  begin
                    Expression := LayerName + '.' + IFACENames[StressPeriodIndex];

                    AReach.IFACE := GridLayer.IntegerValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
                  end; // if frmMODFLOW.cbMODPATH.Checked then
                  if frmMODFLOW.cbMT3D.Checked then
                  begin
                    for SpeciesIndex := 1 to SpeciesCount do
                    begin
                      AReach.MT3DConcentrations[SpeciesIndex-1] :=
                        GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                        LayerName + '.' + MT3DConcentrationNames
                        [StressPeriodIndex, SpeciesIndex-1]);
                    end;
                  end;
                  ReachList := ReachTimes[StressPeriodIndex];
                  ReachList.Add(AReach);
                end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
              end; // if IsParam then else
            end;
          end;
          except on Exception do
            begin
              Beep;
              MessageDlg('Error in cell (Row,Column) (' + IntToStr(RowIndex)
                + ',' + IntToStr(ColIndex) + ')', mtError, [mbOK], 0);
              raise;
            end;
          end;
        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do

    finally
      RiverLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      StageNames.Free;
      ConcentrationNames.Free;
      IFACENames.Free;
      IsOnNames.Free;
    end;
      if RiverErrors.Count > 0 then
      begin
        AString := 'Warning: Some area river stages extend outside of the geologic '
          + 'unit in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'Rivers below the bottom of the unit will be treated as if they '
          + 'are at the bottom of the unit for the purposes of determining in which '
          + 'layer within the unit the river belongs.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := 'Rivers above the top of the unit will be treated as if they '
          + 'are at the top of the unit for the purposes of determining in which '
          + 'layer within the unit the river belongs.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(RiverErrors);
      end;
    finally
      RiverErrors.Free;
    end;
  end;
end;

procedure TRiverPkgWriter.EvaluateDataSets6and7(
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
          // point rivers
          frmProgress.lblActivity.Caption := 'Evaluating Point Rivers in Unit ' + IntToStr(UnitIndex);
          EvaluatePointRiverLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // line rivers
          frmProgress.lblActivity.Caption := 'Evaluating Line Rivers in Unit ' + IntToStr(UnitIndex);
          EvaluateLineRiverLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area rivers
          frmProgress.lblActivity.Caption := 'Evaluating Area Rivers in Unit ' + IntToStr(UnitIndex);
          EvaluateAreaRiverLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
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

procedure TRiverPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TRiverParamValue;
//  AReachList : TReachList;
  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    ReachTimes.Add(TReachList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS *3 ;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'River';
    Application.ProcessMessages;

    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
//    frmProgress.pbPackage.StepIt;
//    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SortReaches;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsRIV;
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
      + ' contours in the RIV (River) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the RIV (River) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the RIV (River) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TRiverPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization : TDiscretizationWriter);
var
  Index : integer;
//  AParamValue : TRiverParamValue;
//  AReachList : TReachList;
//  FileName : string;
  ErrorMessage : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    ReachTimes.Add(TReachList.Create);
  end;
  if ContinueExport then
  begin
    AddParameterNames;
  end;
  frmProgress.pbPackage.Max := 2 ;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'River';
    Application.ProcessMessages;

    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SortReaches;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if PointErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
      + ' contours in the RIV (River) package '
      + 'are open or closed contours but are on a layer '
      + 'reserved for point contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if LineErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
      + ' contours in the RIV (River) package '
      + 'are point or closed contours but are on a layer '
      + 'reserved for open contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;
  if AreaErrors > 0 then
  begin
    ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
      + ' contours in the RIV (River) package '
      + 'are point or open contours but are on a layer '
      + 'reserved for closed contours.  '
      + 'These contours will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
  end;

end;

procedure TRiverPkgWriter.AddParameterNames;
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgRIVParametersN.RowCount -1 do
  begin
    AddParameterName(RowIndex);
  end;

end;

procedure TRiverPkgWriter.AddParameterName(RowIndex : integer);
var
  ParamIndex : integer;
  AParamValue : TRiverParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgRIVParametersN.Cells[0,RowIndex]);
  ParamIndex := ParameterNames.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TRiverParamValue.Create(RowIndex);
    ParameterNames.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different river parameters with the same name: '
      + '"ParameterName".    Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create
//      ('Error: Two different river parameters with the same name: '
//      + '"ParameterName".');
  end;
end;

procedure TRiverPkgWriter.WriteDataSet1;
var
  NPRIV : integer;
  ParamIndex : integer;
  AParam : TRiverParamValue;
  ReachList : TReachList;
begin
  MXL := 0;
  if ParameterNames.Count > 0 then
  begin
    NPRIV := ParameterNames.Count;
    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      AParam := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
      if AParam.Instances.Count > 0 then
      begin
        ReachList := AParam.Instances.Objects[0] as TReachList;
        MXL := MXL + ReachList.Count * AParam.Instances.Count;
      end
      else
      begin
        MXL := MXL + AParam.ReachList.Count;
      end;

    end;
    Writeln(FFile, 'PARAMETER ', NPRIV, ' ', MXL);
  end;

end;

procedure TRiverPkgWriter.WriteDataSet2;
var
  Index, MXACTR, IRIVCB : integer;
  AReachList : TReachList;
  Option : string;
begin
  MXACTR := 0;
  for Index := 0 to ReachTimes.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AReachList := ReachTimes[Index];
    if AReachList.Count > MXACTR then
    begin
      MXACTR := AReachList.Count
    end;
  end;
  MXACTR := MXACTR + MXL;
  if frmModflow.cbFlowRiv.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IRIVCB := frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IRIVCB := frmModflow.GetUnitNumber('RIVBUD');
    end;
  end
  else
  begin
      IRIVCB := 0;
  end;
  Option := '';
  if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
  begin
    Option := Option + ' AUXILIARY IFACE'
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Option := Option + ' CBCALLOCATE AUXILIARY CONCENTRATION'
  end;
  if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
  begin
    Option := Option + ' AUXILIARY RBDTHK'
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
  begin
    Option := Option + ' AUXILIARY RIVDEN'
  end;
  if not frmModflow.cbPrintCellLists.Checked then
  begin
    Option := Option + ' NOPRINT';
  end;
  Writeln(FFile, MXACTR, ' ', IRIVCB, Option);
end;

procedure TRiverPkgWriter.WriteDataSets3And4;
const
  PARTYP = '''RIV'' ';
var
  ParamIndex, ReachIndex, InstanceIndex : integer;
  AParam : TRiverParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  AReach : TReach;
  AReachList : TReachList;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    PARNAM := ParameterNames[ParamIndex];
    AParam := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
    Parval := AParam.Value;
    if AParam.Instances.Count > 0 then
    begin
      AReachList := AParam.Instances.Objects[0] as TReachList;
    end
    else
    begin
      AReachList := AParam.ReachList;
    end;

    NLST := AReachList.Count;
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
        AReachList := AParam.Instances.Objects[InstanceIndex] as TReachList;
        for ReachIndex := 0 to AReachList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          AReach := AReachList[ReachIndex] as TReach;
          AReach.WriteReach(self);
        end;
      end;
    end
    else
    begin
      for ReachIndex := 0 to AParam.ReachList.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AReach := AParam.ReachList[ReachIndex] as TReach;
        AReach.WriteReach(self);
      end;
    end
  end;
end;

procedure TRiverPkgWriter.WriteDatasets5To7;
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

procedure TRiverPkgWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  ReachList : TReachList;
  ParamIndex : integer;
  AParam : TRiverParamValue;
begin
  ReachList := ReachTimes[StressPeriodIndex];
  ITMP := ReachList.Count;
  if (StressPeriodIndex >= 1) and (frmMODFLOW.comboRivSteady.ItemIndex = 0) then
  begin
    ITMP := -1;
  end;
  NP := 0;
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
    if AParam.StressPeriodsUsed[StressPeriodIndex] then
    begin
      Inc(NP);
    end;
  end;
  WriteLn(FFile, ITMP, ' ', NP);
end;

procedure TRiverPkgWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  ReachList : TReachList;
  AReach : TReach;
  ReachIndex : integer;
begin
  if ITMP > 0 then
  begin
    ReachList := ReachTimes[StressPeriodIndex];
    for ReachIndex := 0 to ReachList.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      AReach := ReachList[ReachIndex] as TReach;
      AReach.WriteReach(self);
    end;
  end;
end;

procedure TRiverPkgWriter.WriteDataSet7(StressPeriodIndex: integer);
var
  ParamIndex : integer;
  AParam : TRiverParamValue;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
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

function TRiverPkgWriter.BoundaryUsed(Layer, Row,
  Column: integer): boolean;
var
  ListIndex, InstanceIndex : integer;
  ReachList : TReachList;
  AReach : TReach;
  AParamValue : TRiverParamValue;
  Index : integer;
begin
  result := False;
  for ListIndex := 0 to ReachTimes.Count -1 do
  begin
    ReachList := ReachTimes[ListIndex];
    AReach := ReachList.GetReachByLocation(Layer, Row, Column);
    result := AReach <> nil;
    if result then Exit;
  end;

  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TRiverParamValue;
    AReach := AParamValue.ReachList.GetReachByLocation(Layer, Row, Column);
    result := AReach <> nil;
    if result then Exit;
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      ReachList := AParamValue.Instances.Objects[InstanceIndex] as TReachList;
      AReach := ReachList.GetReachByLocation(Layer, Row, Column);
      result := AReach <> nil;
      if result then Exit;
    end;

  end;

end;

constructor TRiverPkgWriter.Create;
begin
  inherited;
  PointErrors := 0;
  LineErrors := 0;
  AreaErrors := 0;
  ParameterNames := TStringList.Create;
  ReachTimes := TList.Create;
end;

destructor TRiverPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TRiverParamValue;
  AReachList : TReachList;
begin
    for Index := ParameterNames.Count -1 downto 0 do
    begin
      AParamValue := ParameterNames.Objects[Index] as TRiverParamValue;
      AParamValue.Free;
    end;
    ParameterNames.Free;

    for Index := ReachTimes.Count -1 downto 0 do
    begin
      AReachList := ReachTimes[Index];
      AReachList.Free;
    end;
    ReachTimes.Free;
  inherited;

end;

procedure TRiverPkgWriter.SortReaches;
var
  ParamIndex : integer;
  AParam : TRiverParamValue;
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  ReachList : TReachList;
  InstanceIndex : integer;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting Rivers';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParameterNames.Count + StressPeriodCount;

  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TRiverParamValue;
    AParam.ReachList.Sort;
    for InstanceIndex := 0 to AParam.Instances.Count -1 do
    begin
      ReachList := AParam.Instances.Objects[InstanceIndex] as TReachList;
      ReachList.Sort;
    end;

    frmProgress.pbActivity.StepIt;
  end;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    ReachList := ReachTimes[StressPeriodIndex];
    ReachList.Sort;
    frmProgress.pbActivity.StepIt;
  end;
end;

procedure TRiverPkgWriter.FillBoundaryList(Layer, Row, Column: integer;
  BoundaryList: TObjectList);
var
  Index, InstanceIndex : integer;
  AParamValue : TRiverParamValue;
  ReachList : TReachList;
begin
  if ReachTimes.Count > 0 then
  begin
    ReachList := ReachTimes[0];
    ReachList.FillBoundaryList(Layer, Row, Column, BoundaryList);
  end;
  for Index := 0 to ParameterNames.Count -1 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TRiverParamValue;
    AParamValue.ReachList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    for InstanceIndex := 0 to AParamValue.Instances.Count -1 do
    begin
      ReachList := AParamValue.Instances.Objects[InstanceIndex] as TReachList;
      ReachList.FillBoundaryList(Layer, Row, Column, BoundaryList);
    end;
  end;

end;

procedure TRiverPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  ParamIndex, InstanceIndex : integer;
  AParam : TRiverParamValue;
  ReachList : TReachList;
  InstanceName : string;
begin
  for ParamIndex := 0 to ParameterNames.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AParam := ParameterNames.Objects[ParamIndex] as TRiverParamValue;

    if AParam.Instances.Count > 0 then
    begin
      InstanceName := AParam.InstanceNamesUsed[StressPeriod -1];
      InstanceIndex := AParam.Instances.IndexOf(InstanceName);
      if  InstanceIndex >= 0 then
      begin
        ReachList := AParam.Instances.Objects[InstanceIndex] as TReachList;
        ReachList.WriteMT3DConcentrations(Lines);
      end;
    end
    else
    begin
      AParam.ReachList.WriteMT3DConcentrations(Lines);
    end;
  end;
  ReachList := ReachTimes[StressPeriod-1];
  ReachList.WriteMT3DConcentrations(Lines);
end;

class procedure TRiverPkgWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowRiv.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      frmModflow.GetUnitNumber('RIVBUD');
    end;
  end;
end;

{ TRiverParamValue }

constructor TRiverParamValue.Create(RowIndex : Integer);
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
    Instances.AddObject(AStringGrid.Cells[0,InstanceIndex], TReachList.Create);
  end;

  ReachList := TReachList.Create;
  for TimeIndex := 0 to StressPeriodCount -1 do
  begin
    dgColumn := TimeIndex + 4;
    StressPeriodsUsed[TimeIndex]
      := (frmModflow.dgRIVParametersN.Cells[dgColumn,RowIndex]
          <> frmModflow.dgRIVParametersN.Columns[dgColumn].PickList[0]);
    InstanceNamesUsed[TimeIndex] := frmModflow.dgRIVParametersN.
      Cells[dgColumn,RowIndex];
  end;

  Value := InternationalStrToFloat(frmModflow.dgRIVParametersN.Cells[2,RowIndex]);

end;

destructor TRiverParamValue.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to Instances.Count-1 do
  begin
    Instances.Objects[Index].Free;
  end;

  Instances.Free;
  ReachList.Free;
  inherited;
end;

{ TReachList }

function TReachList.Add(AReach: TReachRecord): integer;
var
  ReachObject : TReach;
  Index : integer;
  SpeciesIndex : integer;
  Identical : boolean;
begin
  for Index := 0 to Count -1 do
  begin
    ReachObject := Items[Index] as TReach;
    With ReachObject do
    begin
    if (Reach.Layer = AReach.Layer) and
       (Reach.Row = AReach.Row) and
       (Reach.Column = AReach.Column) and
       (Reach.Stage = AReach.Stage) and
       (Reach.RBot = AReach.RBot) and
       (Reach.IFACE = AReach.IFACE) and
       (Reach.Concentration = AReach.Concentration) and
       (Reach.CellGroupNumber = AReach.CellGroupNumber) and
       (Reach.Thickness = AReach.Thickness) and
       (Reach.FluidDensity = AReach.FluidDensity) then
       begin
         Identical := True;
         for SpeciesIndex := 0 to Length(Reach.MT3DConcentrations) -1 do
         begin
           if (Reach.MT3DConcentrations[SpeciesIndex] <> AReach.MT3DConcentrations[SpeciesIndex]) then
           begin
             Identical := False;
             break;
           end;
         end;
         if Identical then
         begin
           Reach.CondFact := Reach.CondFact + AReach.CondFact;
           result := Index;
           Exit;
         end;
       end;
    end;
  end;

  ReachObject := TReach.Create;
  result := Add(ReachObject);
  ReachObject.Reach.Layer := AReach.Layer;
  ReachObject.Reach.Row := AReach.Row;
  ReachObject.Reach.Column := AReach.Column;
  ReachObject.Reach.Stage := AReach.Stage;
  ReachObject.Reach.CondFact := AReach.CondFact;
  ReachObject.Reach.RBot := AReach.RBot;
  ReachObject.Reach.IFACE := AReach.IFACE;
  ReachObject.Reach.Concentration := AReach.Concentration;
  ReachObject.Reach.CellGroupNumber := AReach.CellGroupNumber;
  ReachObject.Reach.Thickness := AReach.Thickness;
  ReachObject.Reach.FluidDensity := AReach.FluidDensity;
  Copy1DDoubleArray(AReach.MT3DConcentrations,
    ReachObject.Reach.MT3DConcentrations);
end;

procedure TReachList.FillBoundaryList(Layer, Row, Column : integer;
  BoundaryList : TObjectList);
var
  Index : integer;
  AReach : TReach;
begin
  for Index := 0 to Count -1 do
  begin
    AReach := Items[Index] as TReach;
    if (AReach.Reach.Layer = Layer) and (AReach.Reach.Row = Row)
      and (AReach.Reach.Column = Column) then
    begin
      BoundaryList.Add(TBoundaryCell.Create(AReach.Reach.CellGroupNumber));
    end;
  end;
end;

function TReachList.GetReachByLocation(Layer, Row,
  Column: integer): TReach;
var
  Index : integer;
  AReach : TReach;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    AReach := Items[Index] as TReach;
    if (AReach.Reach.Layer = Layer) and (AReach.Reach.Row = Row)
      and (AReach.Reach.Column = Column) then
    begin
      result := AReach;
      Exit;
    end;
  end;
end;

procedure TReachList.Sort;
begin
  inherited Sort(ReachSortFunction);
end;

procedure TReachList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  AReach : TReach;
begin
  for Index := 0 to Count -1 do
  begin
    AReach := Items[Index] as TReach;
    AReach.WriteMT3DConcentrations(Lines);
  end;
end;

{ TReach }

procedure TReach.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  Assert(Length(Reach.MT3DConcentrations) >=1);
  ALine := TModflowWriter.FixedFormattedInteger(Reach.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Reach.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Reach.Column, 10)
    + TModflowWriter.FixedFormattedReal(Reach.MT3DConcentrations[0], 10)
    + TModflowWriter.FixedFormattedInteger(4, 10) + ' ';
  for SpeciesIndex := 0 to Length(Reach.MT3DConcentrations)-1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (Reach.MT3DConcentrations[SpeciesIndex]);
  end;
  Lines.Add(ALine);
end;

procedure TReach.WriteReach(RiverWriter : TRiverPkgWriter);
begin
  Write(RiverWriter.FFile, Reach.Layer, ' ',  Reach.Row, ' ',  Reach.Column, ' ',
    RiverWriter.FreeFormattedReal(Reach.Stage),
    RiverWriter.FreeFormattedReal(Reach.CondFact),
    RiverWriter.FreeFormattedReal(Reach.RBot));
  if ModflowTypes.GetMFLineRiverLayerType.UseIFACE then
  begin
    Write(RiverWriter.FFile, ' ',  Reach.IFACE, ' ');
  end;
  if frmModflow.cbMOC3D.Checked then
  begin
    Write(RiverWriter.FFile, RiverWriter.FreeFormattedReal(Reach.Concentration));
  end;
  if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
  begin
    Write(RiverWriter.FFile, RiverWriter.FreeFormattedReal(Reach.Thickness));
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
  begin
    Write(RiverWriter.FFile, RiverWriter.FreeFormattedReal(Reach.FluidDensity));
  end;

  WriteLn(RiverWriter.FFile);
end;

end.
