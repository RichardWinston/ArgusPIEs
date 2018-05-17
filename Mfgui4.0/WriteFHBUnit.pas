unit WriteFHBUnit;

interface

uses Sysutils, Classes, Forms, ANEPIE, WriteModflowDiscretization, OptionsUnit,
  CopyArrayUnit, WriteBFLX_Unit;

type
  TBoundaryType = (btHead, btFlux);

  TFHBRecord = record
    Layer, Row, Column: integer;
    IAUX: integer;
    MT3D_Concentrations: T2DDoubleArray; // [StressPeriod, Species]
  end;

  TFHBList = class(TList)
    procedure Clear; override;
  end;

  TFHBPkgWriter = class(TListWriter)
  private
    FHBList: TFHBList;
    HeadErrors: TStringList;
    FluxErrors: TStringList;
    PointErrors, LineErrors, AreaErrors: integer;
    procedure EvaluateDataSets5to8(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure EvaluatePointFHBLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateLineFHBLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaFHBLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure GetParamIndicies(var FHBTopIndex, FHBBottomIndex, IFACE_Index:
      ANE_INT16; var FHBTopName, FHBBottomName, IFACE_Name: string; const
      CurrentModelHandle: ANE_PTR; FHBLayer: TLayerOptions);
    procedure WriteDataSets1to3(FlowList, HeadList: TList);
    procedure WriteDataSet4;
    procedure WriteDataSet5or7(List: TList; DataSet: integer);
    procedure WriteHeader(DataSet: integer);
    procedure WriteDataSet6or8(List: TList; DataSet: integer);
    procedure WriteErrors;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Evaluate(
      const CurrentModelHandle: ANE_PTR; Discretization: TDiscretizationWriter);
    procedure RecordIFACE(const BFLX_Writer: TBFLX_Writer);
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization: TDiscretizationWriter);
    procedure WriteMT3DConcentrations(const StressPeriod: integer;
      const Lines: TStrings);
    class procedure AssignUnitNumbers;
  end;

  TFHB_Cell = class(TObject)
  private
    FHB_Record: TFHBRecord;
    Values: array of double;
    Concentrations: array of double;
    Count: integer;
    BoundaryType: TBoundaryType;
    procedure WriteFHB_Cell(FHBWriter: TFHBPkgWriter);
    procedure WriteConcentations(FHBWriter: TFHBPkgWriter);
    procedure WriteMT3DConcentrations(const StressPeriod: integer;
      const Lines: TStrings);
  public
    constructor Create(A_FHB_Record: TFHBRecord; ValueCount: integer);

  end;

implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, WriteNameFileUnit,
  GetFractionUnit, UnitNumbers, UtilityFunctions, MFFlowAndHeadBound;

const
  CNSTM: double = 1;
  IFHBPT: integer = 1;

  { TFHBPkgWriter }

procedure TFHBPkgWriter.WriteErrors;
var
  ErrorString: string;
begin
  if HeadErrors.Count > 0 then
  begin
    ErrorString :=
      'Error: Boundary type changed from Head to Flux in FHB package.';
    frmProgress.reErrors.Lines.Add(ErrorString);

    ErrorString := ErrorString + ' [Unit, Row, Column, Stress Period]';
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.AddStrings(HeadErrors);
  end;
  if FluxErrors.Count > 0 then
  begin
    ErrorString :=
      'Error: Boundary type changed from Flux to Head in FHB package.';
    frmProgress.reErrors.Lines.Add(ErrorString);

    ErrorString := ErrorString + ' [Unit, Row, Column, Stress Period]';
    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.AddStrings(FluxErrors);
  end;
end;

procedure TFHBPkgWriter.GetParamIndicies(var FHBTopIndex, FHBBottomIndex,
  IFACE_Index: ANE_INT16; var FHBTopName, FHBBottomName, IFACE_Name: string;
  const CurrentModelHandle: ANE_PTR; FHBLayer: TLayerOptions);
begin
  FHBTopName := ModflowTypes.GetMFFHBTopElevParamType.WriteParamName;
  FHBTopIndex := FHBLayer.GetParameterIndex(CurrentModelHandle, FHBTopName);

  FHBBottomName := ModflowTypes.GetMFFHBBotElevParamType.WriteParamName;
  FHBBottomIndex := FHBLayer.GetParameterIndex(CurrentModelHandle,
    FHBBottomName);

  if TCustomFHBLayer.UseIFACE then
  begin
    IFACE_Name := ModflowTypes.GetMFIFACEParamType.WriteParamName;
    IFACE_Index := FHBLayer.GetParameterIndex(CurrentModelHandle,
      IFACE_Name);
  end
  else
  begin
    IFACE_Name := '';
    IFACE_Index := -1;
  end;
end;

procedure TFHBPkgWriter.EvaluatePointFHBLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex: integer;
  ProjectOptions: TProjectOptions; Discretization: TDiscretizationWriter);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  FHBLayer: TLayerOptions;
  TopIndex: ANE_INT16;
  BottomIndex: ANE_INT16;
  IFACE_Index: ANE_INT16;
  IFACE_Name: string;
  TimeIndex: integer;
  TimeParamName: string;
  HeadIndicies: array of Integer;
  FluxIndicies: array of Integer;
  BoundaryTypeIndicies: array of Integer;
  HeadConcentrationIndicies: array of Integer;
  FluxConcentrationIndicies: array of Integer;
  IFACEIndex: Integer;
  ContourCount: integer;
  ContourIndex: integer;
  Contour: TContourObjectOptions;
  ParameterName: string;
  A_FHB_Cell: TFHBRecord;
  CellIndex: integer;
  Top, Bottom, LayerTop, LayerBottom: double;
  StressPeriodCount: integer;
  StressPeriodIndex: integer;
  //  FHBList : TFHBList;
  FHBTopName, FHBBottomName: string;
  Used: boolean;
  BoundaryType, PreviousBoundaryType: integer;
  FHBTop, FHBBottom: double;
  StartLayer, EndLayer: integer;
  LayerIndex: integer;
  FHB_Cell: TFHB_Cell;
  AValue: double;
  LayersPerUnit: integer;
  Fraction: double;
  Mt3DStressPeriodCount, SpeciesCount: integer;
  MT3DSpeciesIndicies: array of array of integer;
  SpeciesIndex: integer;
begin
  // point FHB boundaries
  Fraction := 0;
  PreviousBoundaryType := 0;
  SpeciesCount := 0;
  A_FHB_Cell.IAUX := 0;

  StressPeriodCount := frmModflow.sgFHBTimes.RowCount - 1;
  if frmMODFLOW.comboFHBSteadyStateOption.ItemIndex = 0 then
  begin
    StressPeriodCount := 1;
  end;
  SetLength(HeadIndicies, StressPeriodCount);
  SetLength(FluxIndicies, StressPeriodCount);
  SetLength(BoundaryTypeIndicies, StressPeriodCount);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    SetLength(HeadConcentrationIndicies, StressPeriodCount);
    SetLength(FluxConcentrationIndicies, StressPeriodCount);
  end;
  if frmModflow.cbMT3D.Checked then
  begin
    Mt3DStressPeriodCount := frmModflow.dgTime.RowCount - 1;
    if frmMODFLOW.comboFHBSteadyStateOption.ItemIndex = 0 then
    begin
      Mt3DStressPeriodCount := 1;
    end;
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(A_FHB_Cell.MT3D_Concentrations, Mt3DStressPeriodCount,
      SpeciesCount);
    SetLength(MT3DSpeciesIndicies, Mt3DStressPeriodCount, SpeciesCount);
  end;

  LayerName := ModflowTypes.GetMFPointFHBLayerType.WriteNewRoot
    + IntToStr(UnitIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
  FHBLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := FHBLayer.NumObjects(CurrentModelHandle, pieContourObject);
    if ContourCount > 0 then
    begin
      GetParamIndicies(TopIndex, BottomIndex, IFACE_Index,
        FHBTopName, FHBBottomName, IFACE_Name,
        CurrentModelHandle, FHBLayer);

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then
          break;
        Application.ProcessMessages;

        TimeParamName :=
          ModflowTypes.GetMFFHBPointAreaHeadParamType.WriteParamName
          + IntToStr(TimeIndex);
        HeadIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFFHBPointFluxParamType.WriteParamName
          + IntToStr(TimeIndex);
        FluxIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName :=
          ModflowTypes.GetMFFHBPointBoundaryTypeParamType.WriteParamName
          + IntToStr(TimeIndex);
        BoundaryTypeIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFFHBHeadConcParamType.WriteParamName
            + IntToStr(TimeIndex);
          HeadConcentrationIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFFHBFluxConcParamType.WriteParamName
            + IntToStr(TimeIndex);
          FluxConcentrationIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end;
      end;
      if frmModflow.cbMT3D.Checked then
      begin
        for TimeIndex := 1 to Mt3DStressPeriodCount do
        begin
          for SpeciesIndex := 1 to SpeciesCount do
          begin
            case SpeciesIndex of
              1:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName;
                end;
              2:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName;
                end;
              3:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName;
                end;
              4:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName;
                end;
              5:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName;
                end;
            else
              Assert(False);
            end;
            TimeParamName := TimeParamName + IntToStr(TimeIndex);
            MT3DSpeciesIndicies[TimeIndex - 1, SpeciesIndex - 1] :=
              FHBLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end;
        end;
      end;

      frmProgress.pbActivity.Max := ContourCount;
      for ContourIndex := 0 to ContourCount - 1 do
      begin
        frmProgress.pbActivity.StepIt;
        if not ContinueExport then
          break;
        Application.ProcessMessages;
        Contour := TContourObjectOptions.Create
          (CurrentModelHandle, LayerHandle, ContourIndex);
        try
          if Contour.NumberOfNodes(CurrentModelHandle) <> 1 then
          begin
            Inc(PointErrors);
          end
          else
          begin
            FHBTop := Contour.GetFloatParameter(CurrentModelHandle, TopIndex);
            FHBBottom := Contour.GetFloatParameter(CurrentModelHandle,
              BottomIndex);
            if TCustomFHBLayer.UseIFACE then
            begin
              A_FHB_Cell.IAUX := Contour.GetIntegerParameter(CurrentModelHandle,
                IFACE_Index);
            end;

            LayersPerUnit := frmModflow.DiscretizationCount(UnitIndex);

            for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
            begin
              if not ContinueExport then
                break;
              Application.ProcessMessages;
              A_FHB_Cell.Row := GGetCellRow(ContourIndex, CellIndex);
              A_FHB_Cell.Column := GGetCellColumn(ContourIndex, CellIndex);
              Top := Discretization.Elevations[A_FHB_Cell.Column - 1,
                A_FHB_Cell.Row - 1, UnitIndex - 1];
              Bottom := Discretization.Elevations[A_FHB_Cell.Column - 1,
                A_FHB_Cell.Row - 1, UnitIndex];

              StartLayer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, FHBTop);
              EndLayer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, FHBBottom);

              for LayerIndex := StartLayer to EndLayer do
              begin
                A_FHB_Cell.Layer := LayerIndex;
                FHB_Cell := TFHB_Cell.Create(A_FHB_Cell, StressPeriodCount);
                FHBList.Add(FHB_Cell);
                for StressPeriodIndex := 0 to StressPeriodCount - 1 do
                begin
                  if not ContinueExport then
                    break;
                  Application.ProcessMessages;
                  BoundaryType :=
                    Contour.GetIntegerParameter(CurrentModelHandle,
                    BoundaryTypeIndicies[StressPeriodIndex]);
                  Used := BoundaryType <> 0;
                  if Used then
                  begin
                    if BoundaryType = 1 then
                    begin
                      if StressPeriodIndex = 0 then
                      begin
                        FHB_Cell.BoundaryType := btHead;
                        PreviousBoundaryType := BoundaryType;
                      end
                      else
                      begin
                        if PreviousBoundaryType <> BoundaryType then
                        begin
                          HeadErrors.Add(Format('[%d, %d, %d, %d]', [UnitIndex,
                            A_FHB_Cell.Row, A_FHB_Cell.Column, StressPeriodIndex
                              + 1]));
                        end;
                      end;
                      FHB_Cell.Values[StressPeriodIndex] :=
                        Contour.GetFloatParameter(CurrentModelHandle,
                        HeadIndicies[StressPeriodIndex]);
                    end
                    else
                    begin
                      if StressPeriodIndex = 0 then
                      begin
                        FHB_Cell.BoundaryType := btFlux;
                        PreviousBoundaryType := BoundaryType;
                        Fraction := frmModflow.FractionForLayer(Top, Bottom,
                          FHBTop, FHBBottom, UnitIndex, LayerIndex);
                      end
                      else
                      begin
                        if PreviousBoundaryType <> BoundaryType then
                        begin
                          FluxErrors.Add(Format('[%d, %d, %d, %d]', [UnitIndex,
                            A_FHB_Cell.Row, A_FHB_Cell.Column, StressPeriodIndex
                              + 1]));
                        end;
                      end;
                      AValue := Contour.GetFloatParameter(CurrentModelHandle,
                        FluxIndicies[StressPeriodIndex]);

                      FHB_Cell.Values[StressPeriodIndex] := AValue * Fraction;
                    end;

                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      if BoundaryType = 1 then
                      begin
                        FHB_Cell.Concentrations[StressPeriodIndex] :=
                          Contour.GetFloatParameter(CurrentModelHandle,
                          HeadConcentrationIndicies[StressPeriodIndex]);
                      end
                      else
                      begin
                        FHB_Cell.Concentrations[StressPeriodIndex] :=
                          Contour.GetFloatParameter(CurrentModelHandle,
                          FluxConcentrationIndicies[StressPeriodIndex]);
                      end;
                    end;

                  end;
                end;
                if frmModflow.cbMT3D.Checked then
                begin
                  for StressPeriodIndex := 0 to Mt3DStressPeriodCount - 1 do
                  begin
                    if not ContinueExport then
                      break;
                    Application.ProcessMessages;
                    for SpeciesIndex := 0 to SpeciesCount - 1 do
                    begin
                      if not ContinueExport then
                        break;
                      Application.ProcessMessages;
                      FHB_Cell.FHB_Record.MT3D_Concentrations[StressPeriodIndex,
                        SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        MT3DSpeciesIndicies[StressPeriodIndex, SpeciesIndex]);
                    end;
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
    FHBLayer.Free(CurrentModelHandle);
  end;
end;

procedure TFHBPkgWriter.EvaluateLineFHBLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex: integer;
  ProjectOptions: TProjectOptions; Discretization: TDiscretizationWriter);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  FHBLayer: TLayerOptions;
  GridLayer: TLayerOptions;
  TopIndex, BottomIndex, IFACE_Index: ANE_INT16;
  TimeIndex: integer;
  TimeParamName: string;
  StartHeadIndicies: array of Integer;
  EndHeadIndicies: array of Integer;
  FluxIndicies: array of Integer;
  BoundaryTypeIndicies: array of Integer;
  HeadConcentrationIndicies: array of Integer;
  FluxConcentrationIndicies: array of Integer;
  EndHeadUsedIndicies: array of Integer;
  ContourCount: integer;
  ContourIndex: integer;
  Contour: TContourObjectOptions;
  ParameterName: string;
  A_FHB_Cell: TFHBRecord;
  CellIndex: integer;
  Top, Bottom: double;
  StressPeriodCount: integer;
  StressPeriodIndex: integer;
  ContourConductance: double;
  ContourLength: double;
  BlockIndex: integer;
  ABlock: TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  FHBTopName, FHBBottomName, IFACE_Name: string;
  StartHeadNames, EndHeadNames, FluxNames: TStringList;
  BoundaryTypeNames, EndHeadUsedNames: TStringList;
  //  HeadConcentrationNames : TStringList;
  //  FluxConcentrationNames : TStringList;
  Used: boolean;
  FHBTop, FHBBottom: double;
  BoundaryType, PreviousBoundaryType: integer;
  StartHead, EndHead: double;
  LineFraction: double;
  EndHeadUsed: boolean;
  LayerIndex, StartLayer, EndLayer: integer;
  FHB_Cell: TFHB_Cell;
  BottomElevationsErrors, TopElevationErrors: TStringList;
  AString: string;
  Fraction: double;
  Mt3DStressPeriodCount, SpeciesCount: integer;
  MT3DSpeciesIndicies: array of array of integer;
  //  MT3DSpeciesNames : array of array of string;
  SpeciesIndex: integer;
begin
  SpeciesCount := 0;
  PreviousBoundaryType := 0;
  Fraction := 0;
  TopElevationErrors := TStringList.Create;
  BottomElevationsErrors := TStringList.Create;
  try

    // line FHB boundaries
    A_FHB_Cell.IAUX := 0;
    StressPeriodCount := frmModflow.sgFHBTimes.RowCount - 1;
    if frmMODFLOW.comboFHBSteadyStateOption.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(StartHeadIndicies, StressPeriodCount);
    SetLength(EndHeadIndicies, StressPeriodCount);
    SetLength(EndHeadUsedIndicies, StressPeriodCount);
    SetLength(FluxIndicies, StressPeriodCount);
    SetLength(BoundaryTypeIndicies, StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(HeadConcentrationIndicies, StressPeriodCount);
      SetLength(FluxConcentrationIndicies, StressPeriodCount);
    end;
    if frmModflow.cbMT3D.Checked then
    begin
      Mt3DStressPeriodCount := frmModflow.dgTime.RowCount - 1;
      if frmMODFLOW.comboFHBSteadyStateOption.ItemIndex = 0 then
      begin
        Mt3DStressPeriodCount := 1;
      end;
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(A_FHB_Cell.MT3D_Concentrations, Mt3DStressPeriodCount,
        SpeciesCount);
      SetLength(MT3DSpeciesIndicies, Mt3DStressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFLineFHBLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle, LayerName);
    LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
    FHBLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    StartHeadNames := TStringList.Create;
    EndHeadNames := TStringList.Create;
    FluxNames := TStringList.Create;
    BoundaryTypeNames := TStringList.Create;
    EndHeadUsedNames := TStringList.Create;

    try
      ContourCount := FHBLayer.NumObjects(CurrentModelHandle, pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(TopIndex, BottomIndex, IFACE_Index,
          FHBTopName, FHBBottomName, IFACE_Name,
          CurrentModelHandle, FHBLayer);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then
            break;
          Application.ProcessMessages;

          TimeParamName :=
            ModflowTypes.GetMFFHBLineHeadStartParamType.WriteParamName
            + IntToStr(TimeIndex);
          StartHeadNames.Add(TimeParamName);
          StartHeadIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName :=
            ModflowTypes.GetMFFHBLineHeadEndParamType.WriteParamName
            + IntToStr(TimeIndex);
          EndHeadNames.Add(TimeParamName);
          EndHeadIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFFHBLineFluxParamType.WriteParamName
            + IntToStr(TimeIndex);
          FluxNames.Add(TimeParamName);
          FluxIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName :=
            ModflowTypes.GetMFFHBLineBoundaryTypeParamType.WriteParamName
            + IntToStr(TimeIndex);
          BoundaryTypeNames.Add(TimeParamName);
          BoundaryTypeIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName :=
            ModflowTypes.GetMFFHBEndHeadUsedParamType.WriteParamName
            + IntToStr(TimeIndex);
          EndHeadUsedNames.Add(TimeParamName);
          EndHeadUsedIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          if frmMODFLOW.cbMOC3D.Checked then
          begin
            TimeParamName :=
              ModflowTypes.GetMFFHBHeadConcParamType.WriteParamName
              + IntToStr(TimeIndex);
            //            HeadConcentrationNames.Add(TimeParamName);
            HeadConcentrationIndicies[TimeIndex - 1] :=
              FHBLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);

            TimeParamName :=
              ModflowTypes.GetMFFHBFluxConcParamType.WriteParamName
              + IntToStr(TimeIndex);
            //            FluxConcentrationNames.Add(TimeParamName);
            FluxConcentrationIndicies[TimeIndex - 1] :=
              FHBLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end; // if frmMODFLOW.cbMOC3D.Checked then

        end; // for TimeIndex := 1 to StressPeriodCount do
        if frmModflow.cbMT3D.Checked then
        begin
          for TimeIndex := 1 to Mt3DStressPeriodCount do
          begin
            for SpeciesIndex := 1 to SpeciesCount do
            begin
              case SpeciesIndex of
                1:
                  begin
                    TimeParamName :=
                      ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName;
                  end;
                2:
                  begin
                    TimeParamName :=
                      ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName;
                  end;
                3:
                  begin
                    TimeParamName :=
                      ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName;
                  end;
                4:
                  begin
                    TimeParamName :=
                      ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName;
                  end;
                5:
                  begin
                    TimeParamName :=
                      ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName;
                  end;
              else
                Assert(False);
              end;
              TimeParamName := TimeParamName + IntToStr(TimeIndex);
              MT3DSpeciesIndicies[TimeIndex - 1, SpeciesIndex - 1] :=
                FHBLayer.GetParameterIndex
                (CurrentModelHandle, TimeParamName);
            end;
          end;
        end;

        frmProgress.pbActivity.Max := ContourCount;
        for ContourIndex := 0 to ContourCount - 1 do
        begin
          if not ContinueExport then
            break;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          Contour := TContourObjectOptions.Create
            (CurrentModelHandle, LayerHandle, ContourIndex);
          try
            if Contour.ContourType(CurrentModelHandle) <> ctOpen then
            begin
              Inc(LineErrors);
            end
            else
            begin
              FHBTop := Contour.GetFloatParameter(CurrentModelHandle, TopIndex);
              FHBBottom := Contour.GetFloatParameter(CurrentModelHandle,
                BottomIndex);
              if TCustomFHBLayer.UseIFACE then
              begin
                A_FHB_Cell.IAUX := Contour.GetIntegerParameter(CurrentModelHandle,
                  IFACE_Index);
              end;

              for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
              begin
                if not ContinueExport then
                  break;
                Application.ProcessMessages;
                A_FHB_Cell.Row := GGetCellRow(ContourIndex, CellIndex);
                A_FHB_Cell.Column := GGetCellColumn(ContourIndex, CellIndex);
                ContourLength := GGetCellSumSegmentLength(ContourIndex,
                  CellIndex);
                LineFraction := GGetFractionOfLine(ContourIndex, CellIndex);
                Top := Discretization.Elevations[A_FHB_Cell.Column - 1,
                  A_FHB_Cell.Row - 1, UnitIndex - 1];
                Bottom := Discretization.Elevations[A_FHB_Cell.Column - 1,
                  A_FHB_Cell.Row - 1, UnitIndex];

                if ShowWarnings and ((FHBTop > Top) or (FHBTop < Bottom)) then
                begin
                  TopElevationErrors.Add(Format('[%d, %d]',
                    [A_FHB_Cell.Column, A_FHB_Cell.Row]));
                end;
                if ShowWarnings and ((FHBBottom > Top) or (FHBBottom < Bottom))
                  then
                begin
                  BottomElevationsErrors.Add(Format('[%d, %d]',
                    [A_FHB_Cell.Column, A_FHB_Cell.Row]));
                end;
                StartLayer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, FHBTop);
                EndLayer := frmModflow.ModflowLayer(UnitIndex, Top, Bottom, FHBBottom);

                for LayerIndex := StartLayer to EndLayer do
                begin
                  A_FHB_Cell.Layer := LayerIndex;
                  FHB_Cell := TFHB_Cell.Create(A_FHB_Cell, StressPeriodCount);
                  FHBList.Add(FHB_Cell);

                  for StressPeriodIndex := 0 to StressPeriodCount - 1 do
                  begin
                    if not ContinueExport then
                      break;
                    Application.ProcessMessages;
                    BoundaryType :=
                      Contour.GetIntegerParameter(CurrentModelHandle,
                      BoundaryTypeIndicies[StressPeriodIndex]);
                    Used := BoundaryType <> 0;
                    if Used then
                    begin
                      if BoundaryType = 1 then
                      begin
                        if StressPeriodIndex = 0 then
                        begin
                          FHB_Cell.BoundaryType := btHead;
                          PreviousBoundaryType := BoundaryType;
                        end
                        else
                        begin
                          if PreviousBoundaryType <> BoundaryType then
                          begin
                            HeadErrors.Add(Format('[%d, %d, %d, %d]',
                              [UnitIndex,
                              A_FHB_Cell.Row, A_FHB_Cell.Column,
                                StressPeriodIndex + 1]));
                          end;
                        end;
                        StartHead :=
                          Contour.GetFloatParameter(CurrentModelHandle,
                          StartHeadIndicies[StressPeriodIndex]);
                        EndHeadUsed :=
                          Contour.GetBoolParameter(CurrentModelHandle,
                          EndHeadUsedIndicies[StressPeriodIndex]);
                        if EndHeadUsed then
                        begin
                          EndHead :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            EndHeadIndicies[StressPeriodIndex]);
                          FHB_Cell.Values[StressPeriodIndex] := StartHead -
                            (StartHead - EndHead) * LineFraction;
                        end
                        else
                        begin
                          FHB_Cell.Values[StressPeriodIndex] := StartHead;
                        end;
                      end
                      else
                      begin
                        if StressPeriodIndex = 0 then
                        begin
                          FHB_Cell.BoundaryType := btFlux;
                          PreviousBoundaryType := BoundaryType;
                          Fraction := frmModflow.FractionForLayer(Top, Bottom,
                            FHBTop, FHBBottom, UnitIndex, LayerIndex);
                        end
                        else
                        begin
                          if PreviousBoundaryType <> BoundaryType then
                          begin
                            FluxErrors.Add(Format('[%d, %d, %d, %d]',
                              [UnitIndex,
                              A_FHB_Cell.Row, A_FHB_Cell.Column,
                                StressPeriodIndex + 1]));
                          end;
                        end;
                        FHB_Cell.Values[StressPeriodIndex] := Fraction
                          * Contour.GetFloatParameter(CurrentModelHandle,
                          FluxIndicies[StressPeriodIndex]) * ContourLength;
                      end;

                      if frmMODFLOW.cbMOC3D.Checked then
                      begin
                        if BoundaryType = 1 then
                        begin
                          FHB_Cell.Concentrations[StressPeriodIndex] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            HeadConcentrationIndicies[StressPeriodIndex]);
                        end
                        else
                        begin
                          FHB_Cell.Concentrations[StressPeriodIndex] :=
                            Contour.GetFloatParameter(CurrentModelHandle,
                            FluxConcentrationIndicies[StressPeriodIndex]);
                        end;
                      end;
                    end;

                  end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do

                  if frmModflow.cbMT3D.Checked then
                  begin
                    for StressPeriodIndex := 0 to Mt3DStressPeriodCount - 1 do
                    begin
                      if not ContinueExport then
                        break;
                      Application.ProcessMessages;
                      for SpeciesIndex := 0 to SpeciesCount - 1 do
                      begin
                        if not ContinueExport then
                          break;
                        Application.ProcessMessages;
                        FHB_Cell.FHB_Record.MT3D_Concentrations[StressPeriodIndex, SpeciesIndex]
                          := Contour.GetFloatParameter(CurrentModelHandle,
                          MT3DSpeciesIndicies[StressPeriodIndex, SpeciesIndex]);
                      end;
                    end;
                  end;

                end;
              end; // for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
            end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
          finally
            Contour.Free;
          end;

        end; // for ContourIndex := 0 to ContourCount -1 do
      end;
      if TopElevationErrors.Count > 0 then
      begin
        AString := 'Warning: Some FHB Line top elevations lie outside '
          + 'geologic unit ' + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'They will be treated as if they are in the nearest '
          + 'layer of the unit above the non-simulated unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Col, Row]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(TopElevationErrors);
      end;
      if BottomElevationsErrors.Count > 0 then
      begin
        AString := 'Warning: Some FHB Line bottom elevations lie outside '
          + 'geologic unit ' + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'They will be treated as if they are in the nearest '
          + 'layer of the unit above the non-simulated unit.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Col, Row]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(BottomElevationsErrors);
      end;
    finally
      FHBLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      //      HeadConcentrationNames.Free;
      //      FluxConcentrationNames.Free;
      StartHeadNames.Free;
      EndHeadNames.Free;
      FluxNames.Free;
      BoundaryTypeNames.Free;
      EndHeadUsedNames.Free;
    end;

  finally
    TopElevationErrors.Free;
    BottomElevationsErrors.Free;
  end;
end;

procedure TFHBPkgWriter.EvaluateAreaFHBLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex: integer;
  ProjectOptions: TProjectOptions; Discretization: TDiscretizationWriter);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  FHBLayer: TLayerOptions;
  GridLayer: TLayerOptions;
  TimeIndex: integer;
  TimeParamName: string;
  HeadIndicies: array of Integer;
  FluxIndicies: array of Integer;
  BoundaryTypeIndicies: array of Integer;
  HeadConcentrationIndicies: array of Integer;
  FluxConcentrationIndicies: array of Integer;
  ContourCount: integer;
  ContourIndex: integer;
  Contour: TContourObjectOptions;
  ParameterName: string;
  A_FHB_Cell: TFHBRecord;
  StressPeriodCount: integer;
  StressPeriodIndex: integer;
  ContourConductance: double;
  ContourIntersectArea: double;
  BlockIndex: integer;
  ABlock: TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  HeadNames, FluxNames, BoundaryTypeNames: TStringList;
  HeadConcentrationNames: TStringList;
  FluxConcentrationNames: TStringList;
  ColIndex, RowIndex: integer;
  AreaBoundaryInBlock: boolean;
  IsNA: boolean;
  CellArea: double;
  Used: boolean;
  Expression: string;
  LayersAbove, LayerIndex: integer;
  BoundaryType, PreviousBoundaryType: integer;
  FHB_Cell: TFHB_Cell;
  Fraction: double;
  Top, Bottom: double;
  Mt3DStressPeriodCount, SpeciesCount: integer;
  MT3DSpeciesIndicies: array of array of integer;
  MT3DSpeciesNames: array of array of string;
  SpeciesIndex: integer;
  IFACE_Index: ANE_INT16;
  IFACE_Name: string;
begin
  // area FHB boundaries
  SpeciesCount := 0;
  if frmModflow.cbUseAreaFHBs.Checked then
  begin
    A_FHB_Cell.IAUX := 0;
    LayersAbove := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex);
    StressPeriodCount := frmModflow.sgFHBTimes.RowCount - 1;
    if frmMODFLOW.comboFHBSteadyStateOption.ItemIndex = 0 then
    begin
      StressPeriodCount := 1;
    end;
    SetLength(HeadIndicies, StressPeriodCount);
    SetLength(FluxIndicies, StressPeriodCount);
    SetLength(BoundaryTypeIndicies, StressPeriodCount);
    if frmMODFLOW.cbMOC3D.Checked then
    begin
      SetLength(HeadConcentrationIndicies, StressPeriodCount);
      SetLength(FluxConcentrationIndicies, StressPeriodCount);
    end;
    if frmModflow.cbMT3D.Checked then
    begin
      Mt3DStressPeriodCount := frmModflow.dgTime.RowCount - 1;
      if frmMODFLOW.comboFHBSteadyStateOption.ItemIndex = 0 then
      begin
        Mt3DStressPeriodCount := 1;
      end;
      SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
      SetLength(A_FHB_Cell.MT3D_Concentrations, Mt3DStressPeriodCount,
        SpeciesCount);
      SetLength(MT3DSpeciesIndicies, Mt3DStressPeriodCount, SpeciesCount);
      SetLength(MT3DSpeciesNames, Mt3DStressPeriodCount, SpeciesCount);
    end;

    LayerName := ModflowTypes.GetMFAreaFHBLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle, LayerName);
    SetAreaValues;
    LayerHandle := ProjectOptions.GetLayerByName(CurrentModelHandle, LayerName);
    FHBLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    HeadNames := TStringList.Create;
    FluxNames := TStringList.Create;
    HeadConcentrationNames := TStringList.Create;
    FluxConcentrationNames := TStringList.Create;
    BoundaryTypeNames := TStringList.Create;
    try
      IFACE_Index := -1;
      if TCustomFHBLayer.UseIFACE then
      begin
        IFACE_Name := ModflowTypes.GetMFIFACEParamType.WriteParamName;
        IFACE_Index := FHBLayer.GetParameterIndex(CurrentModelHandle,
          IFACE_Name);
      end;

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then
          break;
        Application.ProcessMessages;

        TimeParamName :=
          ModflowTypes.GetMFFHBPointAreaHeadParamType.WriteParamName
          + IntToStr(TimeIndex);
        HeadNames.Add(TimeParamName);
        HeadIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName := ModflowTypes.GetMFFHBAreaFluxParamType.WriteParamName
          + IntToStr(TimeIndex);
        FluxNames.Add(TimeParamName);
        FluxIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        TimeParamName :=
          ModflowTypes.GetMFFHBAreaBoundaryTypeParamType.WriteParamName
          + IntToStr(TimeIndex);
        BoundaryTypeNames.Add(TimeParamName);
        BoundaryTypeIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

        if frmMODFLOW.cbMOC3D.Checked then
        begin
          TimeParamName := ModflowTypes.GetMFFHBHeadConcParamType.WriteParamName
            + IntToStr(TimeIndex);
          HeadConcentrationNames.Add(TimeParamName);
          HeadConcentrationIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetMFFHBFluxConcParamType.WriteParamName
            + IntToStr(TimeIndex);
          FluxConcentrationNames.Add(TimeParamName);
          FluxConcentrationIndicies[TimeIndex - 1] := FHBLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);
        end; // if frmMODFLOW.cbMOC3D.Checked then
      end; // for TimeIndex := 1 to StressPeriodCount do
      if frmModflow.cbMT3D.Checked then
      begin
        for TimeIndex := 1 to Mt3DStressPeriodCount do
        begin
          for SpeciesIndex := 1 to SpeciesCount do
          begin
            case SpeciesIndex of
              1:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName;
                end;
              2:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName;
                end;
              3:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName;
                end;
              4:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName;
                end;
              5:
                begin
                  TimeParamName :=
                    ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName;
                end;
            else
              Assert(False);
            end;
            TimeParamName := TimeParamName + IntToStr(TimeIndex);
            MT3DSpeciesNames[TimeIndex - 1, SpeciesIndex - 1] := TimeParamName;
            MT3DSpeciesIndicies[TimeIndex - 1, SpeciesIndex - 1] :=
              FHBLayer.GetParameterIndex
              (CurrentModelHandle, TimeParamName);
          end;
        end;
      end;

      ContourCount := FHBLayer.NumObjects(CurrentModelHandle, pieContourObject);
      frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW *
        (ContourCount + 1);

      for ColIndex := 1 to Discretization.NCOL do
      begin
        if not ContinueExport then
          break;
        Application.ProcessMessages;
        for RowIndex := 1 to Discretization.NROW do
        begin
          if not ContinueExport then
            break;
          Application.ProcessMessages;
          AreaBoundaryInBlock := False;

          for ContourIndex := 0 to ContourCount - 1 do
          begin
            if not ContinueExport then
              break;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
            Contour := TContourObjectOptions.Create
              (CurrentModelHandle, LayerHandle, ContourIndex);
            try
              if Contour.ContourType(CurrentModelHandle) <> ctClosed then
              begin
                Inc(AreaErrors);
              end
              else
              begin
                ContourIntersectArea := GContourIntersectCell(ContourIndex,
                  ColIndex, RowIndex);
                if ContourIntersectArea > 0 then
                begin

                  AreaBoundaryInBlock := True;

                  A_FHB_Cell.Row := RowIndex;
                  A_FHB_Cell.Column := ColIndex;
                  if TCustomFHBLayer.UseIFACE then
                  begin
                    A_FHB_Cell.IAUX := Contour.GetIntegerParameter(
                      CurrentModelHandle, IFACE_Index);
                  end;

                  for LayerIndex := 1 to
                    frmModflow.DiscretizationCount(UnitIndex) do
                  begin
                    A_FHB_Cell.Layer := LayersAbove + LayerIndex;

                    BoundaryType :=
                      Contour.GetIntegerParameter(CurrentModelHandle,
                      BoundaryTypeIndicies[0]);
                    Used := BoundaryType <> 0;
                    if BoundaryType = 1 then
                    begin
                      // heads:
                      // test if center of cell is inside the contour.
                      BlockIndex := Discretization.BlockIndex(RowIndex - 1,
                        ColIndex - 1);
                      ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                        Discretization.GridLayerHandle, BlockIndex);
                      try
                        ABlock.GetCenter(CurrentModelHandle, X, Y);
                      finally
                        ABlock.Free;
                      end;
                      Used := GPointInsideContour(ContourIndex, X, Y);

                    end;

                    if Used then
                    begin
                      FHB_Cell := TFHB_Cell.Create(A_FHB_Cell,
                        StressPeriodCount);

                      FHBList.Add(FHB_Cell);

                      for StressPeriodIndex := 0 to StressPeriodCount - 1 do
                      begin
                        if not ContinueExport then
                          break;
                        Application.ProcessMessages;
                        BoundaryType :=
                          Contour.GetIntegerParameter(CurrentModelHandle,
                          BoundaryTypeIndicies[StressPeriodIndex]);
                        Used := BoundaryType <> 0;
                        if Used then
                        begin
                          if BoundaryType = 1 then
                          begin
                            if StressPeriodIndex = 0 then
                            begin
                              FHB_Cell.BoundaryType := btHead;
                              PreviousBoundaryType := BoundaryType;
                            end
                            else
                            begin
                              if PreviousBoundaryType <> BoundaryType then
                              begin
                                HeadErrors.Add(Format('[%d, %d, %d, %d]',
                                  [UnitIndex,
                                  A_FHB_Cell.Row, A_FHB_Cell.Column,
                                    StressPeriodIndex + 1]));
                              end;
                            end;

                            FHB_Cell.Values[StressPeriodIndex] :=
                              Contour.GetFloatParameter(CurrentModelHandle,
                              HeadIndicies[StressPeriodIndex]);
                            
                          end
                          else
                          begin
                            if StressPeriodIndex = 0 then
                            begin
                              FHB_Cell.BoundaryType := btFlux;
                              PreviousBoundaryType := BoundaryType;
                            end
                            else
                            begin
                              if PreviousBoundaryType <> BoundaryType then
                              begin
                                FluxErrors.Add(Format('[%d, %d, %d, %d]',
                                  [UnitIndex,
                                  A_FHB_Cell.Row, A_FHB_Cell.Column,
                                    StressPeriodIndex + 1]));
                              end;
                            end;
                            FHB_Cell.Values[StressPeriodIndex] :=
                              ContourIntersectArea *
                              Contour.GetFloatParameter(CurrentModelHandle,
                              FluxIndicies[StressPeriodIndex]);
                          end;
                          if frmMODFLOW.cbMOC3D.Checked then
                          begin
                            if BoundaryType = 1 then
                            begin
                              FHB_Cell.Concentrations[StressPeriodIndex] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                HeadConcentrationIndicies[StressPeriodIndex]);
                            end
                            else
                            begin
                              FHB_Cell.Concentrations[StressPeriodIndex] :=
                                Contour.GetFloatParameter(CurrentModelHandle,
                                FluxConcentrationIndicies[StressPeriodIndex]);
                            end;
                          end;
                        end;
                      end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do

                      if frmModflow.cbMT3D.Checked then
                      begin
                        for StressPeriodIndex := 0 to Mt3DStressPeriodCount - 1
                          do
                        begin
                          if not ContinueExport then
                            break;
                          Application.ProcessMessages;
                          for SpeciesIndex := 0 to SpeciesCount - 1 do
                          begin
                            if not ContinueExport then
                              break;
                            Application.ProcessMessages;
                            FHB_Cell.FHB_Record.MT3D_Concentrations[StressPeriodIndex, SpeciesIndex]
                              := Contour.GetFloatParameter(CurrentModelHandle,
                              MT3DSpeciesIndicies[StressPeriodIndex,
                                SpeciesIndex]);
                          end;
                        end;
                      end;
                    end;

                  end;
                end;
              end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
            finally
              Contour.Free;
            end;

          end; // for ContourIndex := 0 to ContourCount -1 do
          if not ContinueExport then
            break;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;

          CellArea := GContourIntersectCellRemainder(ColIndex, RowIndex);
          if (CellArea > 0) and not AreaBoundaryInBlock then
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex - 1, ColIndex - 1);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
            finally
              ABlock.Free;
            end;

            A_FHB_Cell.Row := RowIndex;
            A_FHB_Cell.Column := ColIndex;
            if TCustomFHBLayer.UseIFACE then
            begin
              Expression := LayerName + '.' + IFACE_Name;
              A_FHB_Cell.IAUX := GridLayer.IntegerValueAtXY
                (CurrentModelHandle, X, Y, Expression);
            end;


            for LayerIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
            begin
              Expression := LayerName + '.' + BoundaryTypeNames[0];
              //                Expression := DefaultValue(Expression);

              BoundaryType := GridLayer.IntegerValueAtXY
                (CurrentModelHandle, X, Y, Expression);
              Used := BoundaryType <> 0;
              if Used then
              begin
                A_FHB_Cell.Layer := LayersAbove + LayerIndex;
                FHB_Cell := TFHB_Cell.Create(A_FHB_Cell, StressPeriodCount);
                FHBList.Add(FHB_Cell);

                for StressPeriodIndex := 0 to StressPeriodCount - 1 do
                begin
                  if not ContinueExport then
                    break;
                  Application.ProcessMessages;

                  Expression := LayerName + '.' +
                    BoundaryTypeNames[StressPeriodIndex];
                  //                Expression := DefaultValue(Expression);

                  BoundaryType := GridLayer.IntegerValueAtXY
                    (CurrentModelHandle, X, Y, Expression);
                  Used := BoundaryType <> 0;
                  if Used then
                  begin
                    if BoundaryType = 1 then
                    begin
                      if StressPeriodIndex = 0 then
                      begin
                        FHB_Cell.BoundaryType := btHead;
                      end
                      else if FHB_Cell.BoundaryType <> btHead then
                      begin
                        HeadErrors.Add(Format('[%d, %d, %d, %d]', [UnitIndex,
                          A_FHB_Cell.Row, A_FHB_Cell.Column, StressPeriodIndex +
                            1]));
                      end;

                      Expression := LayerName + '.' +
                        HeadNames[StressPeriodIndex];
                    end
                    else
                    begin
                      if StressPeriodIndex = 0 then
                      begin
                        FHB_Cell.BoundaryType := btFlux;
                      end
                      else if FHB_Cell.BoundaryType <> btFlux then
                      begin
                        FluxErrors.Add(Format('[%d, %d, %d, %d]', [UnitIndex,
                          A_FHB_Cell.Row, A_FHB_Cell.Column, StressPeriodIndex +
                            1]));
                      end;
                      Expression := LayerName + '.' +
                        FluxNames[StressPeriodIndex];
                    end;

                    //                Expression := DefaultValue(Expression);

                    FHB_Cell.Values[StressPeriodIndex] := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, Expression);
                    if FHB_Cell.BoundaryType = btFlux then
                    begin
                      FHB_Cell.Values[StressPeriodIndex] :=
                        FHB_Cell.Values[StressPeriodIndex] * CellArea;
                    end;
                    if frmMODFLOW.cbMOC3D.Checked then
                    begin
                      if BoundaryType = 1 then
                      begin
                        Expression := LayerName + '.' +
                          HeadConcentrationNames[StressPeriodIndex];
                      end
                      else
                      begin
                        Expression := LayerName + '.' +
                          FluxConcentrationNames[StressPeriodIndex];
                      end;
                      //                    Expression := DefaultValue(Expression);

                      FHB_Cell.Concentrations[StressPeriodIndex] :=
                        GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, Expression);
                    end; // if frmMODFLOW.cbMOC3D.Checked then
                  end;
                end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do

                if frmModflow.cbMT3D.Checked then
                begin
                  for StressPeriodIndex := 0 to Mt3DStressPeriodCount - 1 do
                  begin
                    if not ContinueExport then
                      break;
                    Application.ProcessMessages;
                    for SpeciesIndex := 0 to SpeciesCount - 1 do
                    begin
                      if not ContinueExport then
                        break;
                      Application.ProcessMessages;
                      Expression := LayerName + '.'
                        + MT3DSpeciesNames[StressPeriodIndex, SpeciesIndex];
                      FHB_Cell.FHB_Record.MT3D_Concentrations
                        [StressPeriodIndex, SpeciesIndex] :=
                          GridLayer.RealValueAtXY
                        (CurrentModelHandle, X, Y, Expression);
                    end;
                  end;
                end;

              end;
            end;

          end;

        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do

    finally
      FHBLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      HeadNames.Free;
      FluxNames.Free;
      HeadConcentrationNames.Free;
      FluxConcentrationNames.Free;
      BoundaryTypeNames.Free;
    end;
  end;
end;

procedure TFHBPkgWriter.EvaluateDataSets5to8(
  const CurrentModelHandle: ANE_PTR; Discretization: TDiscretizationWriter);
var
  UnitIndex: integer;
  ProjectOptions: TProjectOptions;
  Index: integer;
  ACell: TFHB_Cell;
  ValueIndex: integer;
  DeleteCell: boolean;
begin
  ProjectOptions := TProjectOptions.Create;
  try

    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if not ContinueExport then
        break;
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
          frmProgress.lblActivity.Caption :=
            'Evaluating point Specified-Flow and Specified-Head boundaries in Unit ' +
            IntToStr(UnitIndex);
          EvaluatePointFHBLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // line general-head boundaries
          frmProgress.lblActivity.Caption :=
            'Evaluating line Specified-Flow and Specified-Head boundaries in Unit ' +
            IntToStr(UnitIndex);

          EvaluateLineFHBLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area general-head boundaries
          frmProgress.lblActivity.Caption :=
            'Evaluating area Specified-Flow and Specified-Head boundaries in Unit ' +
            IntToStr(UnitIndex);
          EvaluateAreaFHBLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
      end;
    end;
    for Index := FHBList.Count -1 downto 0 do
    begin
      ACell := FHBList[Index];
      if ACell.BoundaryType = btFlux then
      begin
        DeleteCell := True;
        for ValueIndex := 0 to Length(ACell.Values) -1 do
        begin
          if ACell.Values[ValueIndex] <> 0 then
          begin
            DeleteCell := False;
            break;
          end;
        end;
        if DeleteCell then
        begin
          FHBList.Delete(Index);
          ACell.Free;
        end;
      end;
    end;

  finally
    ProjectOptions.Free;
  end;

end;

procedure TFHBPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter);
var
  FileName: string;
  FlowList, HeadList: TList;
  ErrorMessage: string;
begin
  FlowList := TList.Create;
  HeadList := TList.Create;
  try
    frmProgress.pbPackage.Max := 6 + Discretization.NUNITS * 3;
    frmProgress.pbPackage.Position := 0;
    if ContinueExport then
    begin
      frmProgress.lblPackage.Caption :=
        'Specified-Flow and Specified-Head Boundary';
      Application.ProcessMessages;

      EvaluateDataSets5to8(CurrentModelHandle, Discretization);
      //      frmProgress.pbPackage.StepIt;
      //      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      FileName := GetCurrentDir + '\' + Root + rsFHB;
      AssignFile(FFile, FileName);
      try
        if ContinueExport then
        begin
          Rewrite(FFile);
          //          WriteDataReadFrom(FileName);
          frmProgress.lblActivity.Caption := 'Writing Data Sets 1 to 3';
          WriteDataSets1to3(FlowList, HeadList);
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
          WriteDataSet5or7(FlowList, 5);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 6';
          WriteDataSet6or8(FlowList, 6);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 7';
          WriteDataSet5or7(HeadList, 7);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 8';
          WriteDataSet6or8(HeadList, 8);
          frmProgress.pbPackage.StepIt;
          Flush(FFile);
          Application.ProcessMessages;
        end;
      finally
        CloseFile(FFile);
      end;

      Application.ProcessMessages;
    end;

    WriteErrors;
    if PointErrors > 0 then
    begin
      ErrorMessage := 'Warning: ' + IntToStr(PointErrors)
        + ' contours in the FHB (Flow and Head Boundary) package '
        + 'are open or closed contours but are on a layer '
        + 'reserved for point contours.  '
        + 'These contours will be ignored.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(ErrorMessage);
    end;
    if LineErrors > 0 then
    begin
      ErrorMessage := 'Warning: ' + IntToStr(LineErrors)
        + ' contours in the FHB (Flow and Head Boundary) package '
        + 'are point or closed contours but are on a layer '
        + 'reserved for open contours.  '
        + 'These contours will be ignored.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(ErrorMessage);
    end;
    if AreaErrors > 0 then
    begin
      ErrorMessage := 'Warning: ' + IntToStr(AreaErrors)
        + ' contours in the FHB (Flow and Head Boundary) package '
        + 'are point or open contours but are on a layer '
        + 'reserved for closed contours.  '
        + 'These contours will be ignored.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add(ErrorMessage);
    end;
  finally
    FlowList.Free;
    HeadList.Free;
  end;
end;

procedure TFHBPkgWriter.WriteDataSet5or7(List: TList; DataSet: integer);
var
  Index: integer;
  FHB_Cell: TFHB_Cell;
begin
  if List.Count > 0 then
  begin
    frmProgress.pbActivity.Max := List.Count;
    frmProgress.pbActivity.Position := 0;
    WriteHeader(DataSet);
    for Index := 0 to List.Count - 1 do
    begin
      FHB_Cell := List[Index];
      FHB_Cell.WriteFHB_Cell(self);
      frmProgress.pbActivity.StepIt;
    end;
  end;
end;

procedure TFHBPkgWriter.WriteDataSet6or8(List: TList; DataSet: integer);
var
  Index: integer;
  FHB_Cell: TFHB_Cell;
begin
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    if List.Count > 0 then
    begin
      frmProgress.pbActivity.Max := List.Count;
      frmProgress.pbActivity.Position := 0;
      WriteHeader(DataSet);
      for Index := 0 to List.Count - 1 do
      begin
        FHB_Cell := List[Index];
        FHB_Cell.WriteConcentations(self);
        frmProgress.pbActivity.StepIt;
      end;
    end;
  end;
end;

procedure TFHBPkgWriter.WriteDataSets1to3(FlowList, HeadList: TList);
var
  NBDTIM, NFLW, NHED, IFHBSS, IFHBCB, NFHBX1, NFHBX2: integer;
  Index: integer;
  FHBCell: TFHB_Cell;
  Weight: double;
begin
  NBDTIM := StrToInt(frmModflow.adeFHBNumTimes.Text);
  FlowList.Clear;
  HeadList.Clear;
  for Index := 0 to FHBList.Count - 1 do
  begin
    FHBCell := FHBList[Index];
    if FHBCell.BoundaryType = btHead then
    begin
      HeadList.Add(FHBCell);
    end
    else
    begin
      FlowList.Add(FHBCell);
    end;
  end;
  NFLW := FlowList.Count;
  NHED := HeadList.Count;
  IFHBSS := frmModflow.comboFHBSteadyStateOption.ItemIndex;

  if frmModflow.cbFlowFHB.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IFHBCB := frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      IFHBCB := frmModflow.GetUnitNumber('FHBBUD')
    end;
  end
  else
  begin
    IFHBCB := 0
  end;

  if frmModflow.cbMOC3D.Checked then
  begin
    NFHBX1 := 1;
    NFHBX2 := 1;
  end
  else
  begin
    NFHBX1 := 0;
    NFHBX2 := 0;
  end;

  Writeln(FFile, NBDTIM, ' ', NFLW, ' ', NHED, ' ', IFHBSS, ' ',
    IFHBCB, ' ', NFHBX1, ' ', NFHBX2, ' Data set 1');

  if frmModflow.cbMOC3D.Checked then
  begin
    Weight := InternationalStrToFloat(frmModflow.adeFHBFluxConcWeight.Text);
    Writeln(FFile, '''CONCENTRATION'' ', FreeFormattedReal(Weight),
      ' Data set 2');
    //    Writeln(FFile,'''CONCENTRATION'' ', Weight, ' Data set 2');

    Weight := InternationalStrToFloat(frmModflow.adeFHBHeadConcWeight.Text);
    Writeln(FFile, '''CONCENTRATION'' ', FreeFormattedReal(Weight),
      ' Data set 3');
    //    Writeln(FFile,'''CONCENTRATION'' ', Weight, ' Data set 3');
  end
end;

procedure TFHBPkgWriter.WriteDataSet4;
var
  Index: integer;
begin
  WriteHeader(4);
  for Index := 1 to frmModflow.sgFHBTimes.RowCount - 1 do
  begin
    Write(FFile,
      FreeFormattedReal(InternationalStrToFloat(frmModflow.sgFHBTimes.Cells[1,
      Index])));
  end;
  Write(FFile, 'Data set 4');
  Writeln(FFile);
end;

procedure TFHBPkgWriter.WriteHeader(DataSet: integer);
begin
  WriteLn(FFile, frmModflow.GetUnitNumber('FHB'), ' ', CNSTM, ' ', IFHBPT,
    ' Data Set ', DataSet);
end;

constructor TFHBPkgWriter.Create;
begin
  inherited;
  HeadErrors := TStringList.Create;
  FluxErrors := TStringList.Create;
  FHBList := TFHBList.Create;
  //  FlowList := TList.Create;
  //  HeadList := TList.Create;
end;

destructor TFHBPkgWriter.Destroy;
begin
  FHBList.Free;
  //  FlowList.Free;
  //  HeadList.Free;
  HeadErrors.Free;
  FluxErrors.Free;
  inherited;
end;

procedure TFHBPkgWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
begin
  frmProgress.pbPackage.Max := Discretization.NUNITS * 3;
  frmProgress.pbPackage.Position := 0;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption :=
      'Specified-Flow and Specified-Head Boundary';
    Application.ProcessMessages;

    EvaluateDataSets5to8(CurrentModelHandle, Discretization);
  end;
end;

procedure TFHBPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  Index: integer;
  Cell: TFHB_Cell;
begin
  for Index := 0 to FHBList.Count - 1 do
  begin
    Cell := FHBList[Index];
    Cell.WriteMT3DConcentrations(StressPeriod, Lines);
  end;
end;

procedure TFHBPkgWriter.RecordIFACE(const BFLX_Writer: TBFLX_Writer);
var
  Index: integer;
  FHB_Cell: TFHB_Cell;
begin
  for Index := 0 to FHBList.Count - 1 do
  begin
    FHB_Cell := FHBList[Index];
    if FHB_Cell.BoundaryType = btHead then
    begin
      BFLX_Writer.IFACE[FHB_Cell.FHB_Record.Layer,
        FHB_Cell.FHB_Record.Row, FHB_Cell.FHB_Record.Column]
        := FHB_Cell.FHB_Record.IAUX;
    end;
  end;
end;

class procedure TFHBPkgWriter.AssignUnitNumbers;
begin
  if frmModflow.cbFlowFHB.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      frmModflow.GetUnitNumber('BUD')
    end
    else
    begin
      frmModflow.GetUnitNumber('FHBBUD')
    end;
  end;
  frmModflow.GetUnitNumber('FHB');
end;

{ TFHBList }

procedure TFHBList.Clear;
var
  Index: integer;
begin
  for Index := Count - 1 downto 0 do
  begin
    TFHB_Cell(Items[Index]).Free;
  end;

  inherited;

end;

{ TFHB_Cell }

constructor TFHB_Cell.Create(A_FHB_Record: TFHBRecord; ValueCount: integer);
var
  Index: integer;
begin
  inherited Create;
  FHB_Record.Layer := A_FHB_Record.Layer;
  FHB_Record.Row := A_FHB_Record.Row;
  FHB_Record.Column := A_FHB_Record.Column;
  FHB_Record.IAUX := A_FHB_Record.IAUX;
  Copy2DDoubleArray(A_FHB_Record.MT3D_Concentrations,
    FHB_Record.MT3D_Concentrations);

  Count := ValueCount;
  SetLength(Values, ValueCount);
  SetLength(Concentrations, ValueCount);
  for Index := 0 to Count - 1 do
  begin
    Values[Index] := 0;
    Concentrations[Index] := 0;
  end;

end;

procedure TFHB_Cell.WriteConcentations(FHBWriter: TFHBPkgWriter);
var
  Index: integer;
begin
  for Index := 0 to Count - 1 do
  begin
    Write(FHBWriter.FFile, FHBWriter.FreeFormattedReal(Concentrations[Index]));
  end;
  WriteLn(FHBWriter.FFile);
end;

procedure TFHB_Cell.WriteFHB_Cell(FHBWriter: TFHBPkgWriter);
var
  Index: integer;
begin
  Write(FHBWriter.FFile, FHB_Record.Layer, ' ', FHB_Record.Row, ' ',
    FHB_Record.Column, ' ', FHB_Record.IAUX, ' ');
  for Index := 0 to Count - 1 do
  begin
    Write(FHBWriter.FFile, FHBWriter.FreeFormattedReal(Values[Index]));
  end;
  WriteLn(FHBWriter.FFile);
end;

procedure TFHB_Cell.WriteMT3DConcentrations(const StressPeriod: integer;
  const Lines: TStrings);
var
  BoundaryInteger: integer;
  ALine: string;
  SpeciesIndex: integer;
begin
  Assert((Length(FHB_Record.MT3D_Concentrations) >= StressPeriod)
    and (Length(FHB_Record.MT3D_Concentrations[StressPeriod - 1]) >= 1));
  if BoundaryType = btHead then
  begin
    BoundaryInteger := 1;
  end
  else
  begin
    BoundaryInteger := 23;
  end;

  ALine := TModflowWriter.FixedFormattedInteger(FHB_Record.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(FHB_Record.Row, 10)
    + TModflowWriter.FixedFormattedInteger(FHB_Record.Column, 10)
    +
      TModflowWriter.FixedFormattedReal(FHB_Record.MT3D_Concentrations[StressPeriod
      - 1, 0], 10)
    + TModflowWriter.FixedFormattedInteger(BoundaryInteger, 10) + ' ';
  for SpeciesIndex := 0 to Length(FHB_Record.MT3D_Concentrations[StressPeriod -
    1]) - 1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (FHB_Record.MT3D_Concentrations[StressPeriod - 1, SpeciesIndex]);
  end;
  Lines.Add(ALine);

end;

end.

