unit WriteGWTConstantConc;

interface

uses Sysutils, Classes, contnrs, Forms, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit, CopyArrayUnit;

type
  TGwtConstConcRecord = record
    Layer, Row, Column : integer;
    Concentration : double;
    ContourIndex: integer;
  end;

  TGwtConstConc = Class;

  TGwtConstConcList = Class(TObjectList)
    public
    function Add(AConstConc : TGwtConstConcRecord) : integer; overload;
    function GetConstConcByLocation(Layer, Row, Column : integer) : TGwtConstConc;
    procedure Sort;
  end;

  TGwtConstConcWriter = class(TCustomBoundaryWriter)
  private
    ConcentrationTimes : TList;
    ITMP : integer;
    procedure EvaluateDataSets6and7(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(out TopIndex, BottomIndex: ANE_INT16;
      out TopName, BottomName: string; const
      CurrentModelHandle: ANE_PTR; WellLayer : TLayerOptions);
    procedure EvaluatePointLineLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure EvaluateAreaLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDatasets5To7;
    procedure WriteDataSet5(StressPeriodIndex : integer);
    procedure WriteDataSet6(StressPeriodIndex : integer);
    function GetBoundaryThickness(DivIndex, LayersPerUnit: integer; Top,
      UnitThickness, BoundaryTop, BoundaryBottom: double): double;
    function GetLayersAbove(UnitIndex : integer): Integer;
    procedure SortConstConc;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    function BoundaryUsed(Layer, Row, Column : integer) : boolean; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
//    class procedure AssignUnitNumbers;
  end;

  TGwtConstConc = Class(TObject)
  private
    ConstConc : TGwtConstConcRecord;
    procedure WriteConstConc(ConstConcWriter : TGwtConstConcWriter);
  end;


implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, RealListUnit,
  GetFractionUnit, IntListUnit, WriteNameFileUnit, UnitNumbers,
  UtilityFunctions;

function ConstConcSortFunction(Item1, Item2: Pointer): Integer;
var
  Well1, Well2 : TGwtConstConc;
begin
  Well1 := Item1;
  Well2 := Item2;
  result := Well1.ConstConc.Layer - Well2.ConstConc.Layer;
  if Result <> 0 then Exit;
  result := Well1.ConstConc.Row - Well2.ConstConc.Row;
  if Result <> 0 then Exit;
  result := Well1.ConstConc.Column - Well2.ConstConc.Column;
end;


{ TGwtConstConcWriter }


procedure TGwtConstConcWriter.GetParamIndicies(out TopIndex, BottomIndex: ANE_INT16;
  out TopName, BottomName: string; const
  CurrentModelHandle: ANE_PTR; WellLayer : TLayerOptions);
begin
  TopName := ModflowTypes.GetMFWellTopParamType.WriteParamName;
  TopIndex := WellLayer.GetParameterIndex(CurrentModelHandle, TopName);

  BottomName := ModflowTypes.GetMFWellBottomParamType.WriteParamName;
  BottomIndex := WellLayer.GetParameterIndex(CurrentModelHandle, BottomName);
end;

Function TGwtConstConcWriter.GetBoundaryThickness(DivIndex, LayersPerUnit : integer;
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
function TGwtConstConcWriter.GetLayersAbove(UnitIndex : integer): Integer;
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

procedure TGwtConstConcWriter.EvaluatePointLineLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  ConcentrationLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  TopIndex : ANE_INT16;
  BottomIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  ConcentrationIndicies : array of Integer;
  ConcentrationUsedIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  AConcBoundary : TGwtConstConcRecord;
  CellIndex : integer;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  ConcBoundList : TGwtConstConcList;
  ContourTop, ContourBottom : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  TopName, BottomName: string;
  ConcentrationNames, ConcentrationUsedNames: TStringList;
  Used : boolean;
  Concentration : ANE_DOUBLE;
  LayersPerUnit : integer;
  DivIndex : integer;
  BoundaryTop, BoundaryBottom : ANE_Double;
  UnitThickness, DivThickness : double;
  Concentrations : TRealList;
  Layer : integer;
  BoundaryThickness : double;
  TopErrors, BottomErrors, ThicknessErrors: TStringList;
  AString : string;
  ConcentrationUsedList: TIntegerList;
  ConcentrationUsed: boolean;
  ContourType: TArgusContourType;
begin
  // pint or line Constant-Concentration Boundaries
  AConcBoundary.Concentration := 0;
  TopErrors := TStringList.Create;
  BottomErrors := TStringList.Create;
  ThicknessErrors := TStringList.Create;
  try
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    SetLength(ConcentrationIndicies,StressPeriodCount);
    SetLength(ConcentrationUsedIndicies,StressPeriodCount);

    LayerName := ModflowTypes.GetGWT_TimeVaryConcLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    ConcentrationLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    ConcentrationNames := TStringList.Create;
    ConcentrationUsedNames := TStringList.Create;
    try
      ContourCount := ConcentrationLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(TopIndex, BottomIndex, TopName,
          BottomName, CurrentModelHandle, ConcentrationLayer);

        for TimeIndex := 1 to StressPeriodCount do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;

          TimeParamName := ModflowTypes.GetGwt_ConcBoundaryClass.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationNames.Add(TimeParamName);
          ConcentrationIndicies[TimeIndex -1] := ConcentrationLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

          TimeParamName := ModflowTypes.GetGWT_ConcentrationUsedParamType.WriteParamName
            + IntToStr(TimeIndex);
          ConcentrationUsedNames.Add(TimeParamName);
          ConcentrationUsedIndicies[TimeIndex -1] := ConcentrationLayer.GetParameterIndex
            (CurrentModelHandle, TimeParamName);

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
            ContourType := Contour.ContourType(CurrentModelHandle);
            if ContourType = ctClosed then
            begin
              Continue;
            end;
//            else
            begin
              Concentrations := TRealList.Create;
              ConcentrationUsedList:= TIntegerList.Create;
              try

//                if not frmMODFLOW.cbAltWel.Checked then
                begin
                  ContourTop := Contour.GetFloatParameter(CurrentModelHandle,TopIndex);
                  ContourBottom := Contour.GetFloatParameter(CurrentModelHandle,BottomIndex);
                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    Concentration := Contour.GetFloatParameter
                      (CurrentModelHandle, ConcentrationIndicies[StressPeriodIndex]);
                    Concentrations.Add(Concentration);

                    ConcentrationUsed := Contour.GetBoolParameter(
                      CurrentModelHandle, ConcentrationUsedIndicies[StressPeriodIndex]);
                    ConcentrationUsedList.Add(Ord(ConcentrationUsed));
                  end;
                end; // if not frmMODFLOW.cbAltWel.Checked then

                for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;
                  AConcBoundary.Row := GGetCellRow(ContourIndex, CellIndex);
                  AConcBoundary.Column := GGetCellColumn(ContourIndex, CellIndex);
//                  ContourLength := GGetCellSumSegmentLength(ContourIndex, CellIndex);
                  Top := Discretization.Elevations[AConcBoundary.Column-1,AConcBoundary.Row-1,UnitIndex-1];
                  Bottom := Discretization.Elevations[AConcBoundary.Column-1,AConcBoundary.Row-1,UnitIndex];
                  UnitThickness := Discretization.Thicknesses[AConcBoundary.Column-1,AConcBoundary.Row-1,UnitIndex-1];

                  if ContourType = ctPoint then
                  begin

                    Contour.GetNthNodeLocation(CurrentModelHandle, X, Y, 0);
                    BoundaryTop := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + TopName);
                    BoundaryBottom := GridLayer.RealValueAtXY
                      (CurrentModelHandle, X, Y, LayerName + '.' + BottomName);
                  end
                  else // if ContourType = ctPoint then
                  begin
                    BoundaryTop := ContourTop;
                    BoundaryBottom := ContourBottom;
                  end; // if frmMODFLOW.cbAltWel.Checked then else

                  if (BoundaryTop > Top) or (BoundaryTop < Bottom) then
                  begin
                    if ShowWarnings then
                    begin
                      if BoundaryTop > Top then
                      begin
                        TopErrors.Add(Format
                          ('[%d, %d] Top Elevation > top of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                      end;
                      if BoundaryTop < Bottom then
                      begin
                        BottomErrors.Add(Format
                          ('[%d, %d] Top Elevation < bottom of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                      end;
                    end;
                    BoundaryTop := Top;
                  end;

                  if (BoundaryBottom > Top) or (BoundaryBottom < Bottom) then
                  begin
                    if ShowWarnings then
                    begin
                      if BoundaryBottom > Top then
                      begin
                        TopErrors.Add(Format
                          ('[%d, %d] Bottom Elevation > top of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                      end;
                      if BoundaryBottom < Bottom then
                      begin
                        BottomErrors.Add(Format
                          ('[%d, %d] Bottom Elevation < bottom of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                      end;
                    end;
                    BoundaryBottom := Bottom;
                  end;

                  BoundaryThickness := BoundaryTop - BoundaryBottom;
                  if ShowWarnings and (BoundaryThickness <= 0) then
                  begin
                    ThicknessErrors.Add(Format
                      ('[%d, %d]', [AConcBoundary.Row, AConcBoundary.Column]));
                  end;
                  if BoundaryThickness > 0 then
                  begin
                    begin
                      for StressPeriodIndex := 0 to StressPeriodCount-1 do
                      begin
                        if not ContinueExport then break;
                        Application.ProcessMessages;
                          if ContourType = ctPoint then
                          begin
                            Concentration := GridLayer.RealValueAtXY
                              (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationNames[StressPeriodIndex]);
                            ConcentrationUsed := GridLayer.BooleanValueAtXY
                              (CurrentModelHandle, X, Y, LayerName + '.' + ConcentrationUsedNames[StressPeriodIndex]);
                          end
                          else
                          begin
                            Concentration := Concentrations.Items[StressPeriodIndex];
                            ConcentrationUsed := Boolean(ConcentrationUsedList[StressPeriodIndex]);
                          end;
                          if ConcentrationUsed then
                          begin
                            for DivIndex := 1 to LayersPerUnit do
                            begin
                              DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                                Top, UnitThickness, BoundaryTop, BoundaryBottom);
                              if DivThickness > 0 then
                              begin
                                AConcBoundary.Concentration := Concentration;
                                AConcBoundary.Layer := Layer + DivIndex;
                                ConcBoundList := ConcentrationTimes[StressPeriodIndex];
                                ConcBoundList.Add(AConcBoundary);
                              end;
                            end;
                          end;
                      end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
                    end; // if IsParam then else
                  end;
                end; // for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
              finally
                begin
                  Concentrations.Free;
                  ConcentrationUsedList.Free;
                end;
              end;
            end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
          finally
            Contour.Free;
          end;

        end; // for ContourIndex := 0 to ContourCount -1 do
      end;
    finally
      ConcentrationLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      ConcentrationNames.Free;
      ConcentrationUsedNames.Free;
    end;
    if TopErrors.Count > 0 then
    begin
      AString := 'Warning: Some Constant-Concentration Boundaries top elevations extend outside of the geologic '
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
      AString := 'Warning: Some Constant-Concentration Boundaries bottom elevations extend outside of the geologic '
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
      AString := 'Warning: Some Constant-Concentration Boundaries vertical extents are <= 0 in unit '
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
  finally
    TopErrors.Free;
    BottomErrors.Free;
    ThicknessErrors.Free;
  end;
end;

procedure TGwtConstConcWriter.EvaluateAreaLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  TopError1, TopError2 : boolean;
  BottomError1, BottomError2 : boolean;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ConcentrationlLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  TopIndex : ANE_INT16;
  BottomIndex : ANE_INT16;
  TimeIndex : integer;
  TimeParamName : string;
  ConcentrationIndicies : array of Integer;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  AConcBoundary : TGwtConstConcRecord;
  Top, Bottom : double;
  StressPeriodCount : integer;
  StressPeriodIndex : integer;
  ConcentrationList : TGwtConstConcList;
  ContourTop, ContourBottom : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, TopName, BottomName: string;
  ConcentrationNames: TStringList;
  ColIndex, RowIndex : integer;
  AreaBoundaryInBlock : boolean;
  IsNA : boolean;
  Used : boolean;
  Concentration : ANE_DOUBLE;
  LayersPerUnit : integer;
  DivIndex : integer;
  BoundaryTop, BoundaryBottom : ANE_Double;
  UnitThickness, DivThickness : double;
  Layer : integer;
  Index : integer;
  ConstConcIndex : integer;
  AConcentrationObject : TGwtConstConc;
  TempConcentrationTimes : TList;
  AConcentrationList : TGwtConstConcList;
  Expression : string;
  TopErrors, BottomErrors, ThicknessErrors : TStringList;
  AString : string;
  BoundaryThickness : double;
  function CellUsed : boolean;
  var
    SPIndex : integer;
  begin
    result := false;
    for SPIndex := 0 to StressPeriodCount-1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      Expression := LayerName + '.'
        + ConcentrationNames[SPIndex];

      result := not GridLayer.BooleanValueAtXY(CurrentModelHandle,X,Y,
        Expression + '=$N/A');
      if result then break;
    end;
  end;
begin
  AConcBoundary.Concentration := 0;
  TopErrors := TStringList.Create;
  BottomErrors := TStringList.Create;
  ThicknessErrors := TStringList.Create;
  try
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);
    StressPeriodCount := frmModflow.dgTime.RowCount -1;
    SetLength(ConcentrationIndicies,StressPeriodCount);

    LayerName := ModflowTypes.GetGWT_TimeVaryConcLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    TopName := ModflowTypes.GetGWT_TopElevParam.WriteParamName;
    BottomName := ModflowTypes.GetGWT_BottomElevParam.WriteParamName;
    AddVertexLayer(CurrentModelHandle,LayerName);
    ResetAreaValues;

    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    ConcentrationlLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    ConcentrationNames := TStringList.Create;
    TempConcentrationTimes := TList.Create;
    try
      for Index := 1 to StressPeriodCount do
      begin
        TempConcentrationTimes.Add(TGwtConstConcList.Create(False));
      end;

      for TimeIndex := 1 to StressPeriodCount do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;

        TimeParamName := ModflowTypes.GetMFConcentrationParamType.WriteParamName
          + IntToStr(TimeIndex);
        ConcentrationNames.Add(TimeParamName);
        ConcentrationIndicies[TimeIndex -1] := ConcentrationlLayer.GetParameterIndex
          (CurrentModelHandle, TimeParamName);

      end; // for TimeIndex := 1 to StressPeriodCount do

      ContourCount := ConcentrationlLayer.NumObjects(CurrentModelHandle,pieContourObject);
      frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;

      for ColIndex := 1 to Discretization.NCOL do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AConcBoundary.Column := ColIndex;
        for RowIndex := 1 to Discretization.NROW do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          AConcBoundary.Row := RowIndex;
          AreaBoundaryInBlock := False;
          Top := Discretization.Elevations[AConcBoundary.Column-1,AConcBoundary.Row-1,UnitIndex-1];
          Bottom := Discretization.Elevations[AConcBoundary.Column-1,AConcBoundary.Row-1,UnitIndex];
          UnitThickness := Discretization.Thicknesses[ColIndex-1,RowIndex-1,UnitIndex-1];
          if not ContinueExport then break;

          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;

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
            Expression := LayerName + '.' + TopName;
            IsNA := GridLayer.BooleanValueAtXY(CurrentModelHandle,X,Y,
              Expression + '=$N/A');
            if not IsNA then
            begin
              BoundaryTop := GridLayer.RealValueAtXY
                (CurrentModelHandle,X,Y, Expression);

              Expression := LayerName + '.' + BottomName;

              BoundaryBottom := GridLayer.RealValueAtXY
                (CurrentModelHandle,X,Y, Expression);

              TopError1 := False;
              BottomError1 := False;
              if (BoundaryTop > Top) or (BoundaryTop < Bottom) then
              begin
                if ShowWarnings then
                begin
                  if BoundaryTop > Top then
                  begin
                    TopError1 := True;
                  end;
                  if BoundaryTop < Bottom then
                  begin
                    BottomError1 := True;
                  end;
                end;
                BoundaryTop := Top;
              end;

              TopError2 := False;
              BottomError2 := False;
              if (BoundaryBottom > Top) or (BoundaryBottom < Bottom) then
              begin
                if ShowWarnings then
                begin
                  if BoundaryBottom > Top then
                  begin
                    TopError2 := True;
                  end;
                  if BoundaryBottom < Bottom then
                  begin
                    BottomError2 := True;
                  end;
                end;
                BoundaryBottom := Bottom;
              end;

              BoundaryThickness := BoundaryTop - BoundaryBottom;

              if ShowWarnings and (BoundaryThickness <= 0) then
              begin
                ThicknessErrors.Add(Format
                  ('[%d, %d]', [AConcBoundary.Row, AConcBoundary.Column]));
              end;
              if BoundaryThickness > 0 then
              begin
                for StressPeriodIndex := 0 to StressPeriodCount-1 do
                begin
                  if not ContinueExport then break;
                  Application.ProcessMessages;

                  Expression := LayerName + '.' + ConcentrationNames[StressPeriodIndex];

                  Concentration := GridLayer.RealValueAtXY
                    (CurrentModelHandle,X,Y, Expression);
//                        if Concentration <> 0 then
                  begin
                    if TopError1 then
                    begin
                      TopError1 := False;
                      TopErrors.Add(Format
                        ('[%d, %d] Top Elevation > top of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                    end;
                    if BottomError1 then
                    begin
                      BottomError1 := False;
                      BottomErrors.Add(Format
                        ('[%d, %d] Top Elevation < bottom of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                    end;
                    if TopError2 then
                    begin
                      TopError2 := False;
                      TopErrors.Add(Format
                        ('[%d, %d] Bottom Elevation > top of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                    end;
                    if BottomError2 then
                    begin
                      BottomError2 := False;
                      BottomErrors.Add(Format
                        ('[%d, %d] Bottom Elevation < bottom of unit', [AConcBoundary.Row, AConcBoundary.Column]));
                    end;
//                          ContourIntersectArea := 0;
                    for DivIndex := 1 to LayersPerUnit do
                    begin
                      DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                        Top, UnitThickness, BoundaryTop, BoundaryBottom);
                      if DivThickness > 0 then
                      begin
                        begin
                          AConcBoundary.Concentration := Concentration;
                        end;

                        AConcBoundary.Layer := Layer + DivIndex;
                        begin
                          ConcentrationList := ConcentrationTimes[StressPeriodIndex];
                          ConcentrationList.Add(AConcBoundary);
                        end; // if PumpageTypeIndicator = 2 then
                      end;  // if DivThickness > 0 then
                    end; // for DivIndex := 1 to LayersPerUnit do
                  end; // if Pumpage <> 0 then
                end; // for StressPeriodIndex := 0 to StressPeriodCount-1 do
              end;
            end;  // if not IsNA then
          end;
        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do
      for Index := TempConcentrationTimes.Count -1 downto 0 do
      begin
        ConcentrationList := ConcentrationTimes[Index];
        AConcentrationList := TempConcentrationTimes[Index];
        for ConstConcIndex := AConcentrationList.Count -1 downto 0 do
        begin
          AConcentrationObject := AConcentrationList[ConstConcIndex] as TGwtConstConc;
          ConcentrationList.Add(AConcentrationObject);
        end;
        // AWellList doesn't own it's objects so it can be safely free'd.
        AConcentrationList.Free;
      end;
    finally
      ConcentrationlLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
      ConcentrationNames.Free;
      TempConcentrationTimes.Free;
    end;
      if TopErrors.Count > 0 then
      begin
        AString := 'Warning: Some GWT Constant Concentration elevations extend outside of the geologic '
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
        AString := 'Warning: Some GWT Constant Concentration bottom elevations extend outside of the geologic '
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
        AString := 'Warning: Some GWT Constant Concentration vertical extents are <= 0 in unit '
          + IntToStr(UnitIndex) + '.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := 'These GWT Constant Concentrations will be skipped.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add(AString);

        AString := '[Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(ThicknessErrors);
      end;
  finally
    TopErrors.Free;
    BottomErrors.Free;
    ThicknessErrors.Free;
  end;
end;

procedure TGwtConstConcWriter.EvaluateDataSets6and7(
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
          // line wells
          frmProgress.lblActivity.Caption := 'Evaluating Constant-Concentration in Unit '
            + IntToStr(UnitIndex);
          EvaluatePointLineLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area wells
          frmProgress.lblActivity.Caption := 'Evaluating Constant-Concentration in Unit '
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
end;

procedure TGwtConstConcWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  Index : integer;
  FileName : string;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    ConcentrationTimes.Add(TGwtConstConcList.Create);
  end;
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS*3 ;
  frmProgress.lblPackage.Caption := 'Constant-Concentration Boundary';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;
  if ContinueExport then
  begin
    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
  end;

  if ContinueExport then
  begin
    SortConstConc;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;


  if ContinueExport then
  begin

    FileName := GetCurrentDir + '\' + Root + rsCCBD;
    AssignFile(FFile,FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
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

end;

procedure TGwtConstConcWriter.SortConstConc;
var
  StressPeriodIndex : integer;
  StressPeriodCount : integer;
  ConstConcList : TGwtConstConcList;
begin
  StressPeriodCount :=  frmModflow.dgTime.RowCount -1;

  frmProgress.lblActivity.Caption := 'Sorting Constant-Concentration Boundaries';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := StressPeriodCount;

  for StressPeriodIndex := 0 to StressPeriodCount -1 do
  begin
    ConstConcList := ConcentrationTimes[StressPeriodIndex];
    ConstConcList.Sort;
    frmProgress.pbActivity.StepIt;
  end;
end;


procedure TGwtConstConcWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization : TDiscretizationWriter);
var
  Index : integer;
begin
  for Index := 1 to frmModflow.dgTime.RowCount -1 do
  begin
    ConcentrationTimes.Add(TGwtConstConcList.Create);
  end;

  frmProgress.pbPackage.Max := 2 ;
  frmProgress.lblPackage.Caption := 'Constant-Concentration Boundary Package';
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
    SortConstConc;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TGwtConstConcWriter.WriteDatasets5To7;
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
  end;
end;

procedure TGwtConstConcWriter.WriteDataSet5(StressPeriodIndex: integer);
var
  ConstConclList : TGwtConstConcList;
begin
  ConstConclList := ConcentrationTimes[StressPeriodIndex];
  ITMP := ConstConclList.Count;
  WriteLn(FFile, ITMP);
end;

procedure TGwtConstConcWriter.WriteDataSet6(StressPeriodIndex: integer);
var
  ConstConcLList : TGwtConstConcList;
  AConstConc : TGwtConstConc;
  WellIndex : integer;
begin
  ConstConcLList := ConcentrationTimes[StressPeriodIndex];
  for WellIndex := 0 to ConstConcLList.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AConstConc := ConstConcLList[WellIndex] as TGwtConstConc;
    AConstConc.WriteConstConc(self);
  end;
end;

function TGwtConstConcWriter.BoundaryUsed(Layer, Row, Column: integer): boolean;
var
  ListIndex : integer;
  ConstConcList : TGwtConstConcList;
  AConstConc : TGwtConstConc;
begin
  result := False;
  for ListIndex := 0 to ConcentrationTimes.Count -1 do
  begin
    ConstConcList := ConcentrationTimes[ListIndex];
    AConstConc := ConstConcList.GetConstConcByLocation(Layer, Row, Column);
    result := AConstConc <> nil;
    if result then Exit;
  end;
end;

constructor TGwtConstConcWriter.Create;
begin
  inherited;
  ConcentrationTimes := TList.Create;
end;

destructor TGwtConstConcWriter.Destroy;
var
  Index : integer;
  AWellList : TGwtConstConcList;
begin
  for Index := ConcentrationTimes.Count -1 downto 0 do
  begin
    AWellList := ConcentrationTimes[Index];
    AWellList.Free;
  end;
  ConcentrationTimes.Free;
  inherited;
end;

//class procedure TGwtConstConcWriter.AssignUnitNumbers;
//begin
//  if frmModflow.cbFlowWEL.Checked or frmModflow.cbOneFlowFile.Checked then
//  begin
//    if frmModflow.cbOneFlowFile.Checked then
//    begin
//      frmModflow.GetUnitNumber('BUD');
//    end
//    else
//    begin
//      frmModflow.GetUnitNumber('WELBUD');
//    end;
//  end;
//end;

{ TGwtConstConcList }

function TGwtConstConcList.Add(AConstConc : TGwtConstConcRecord): integer;
var
  ConstConcObject : TGwtConstConc;
  Index : integer;
  Identical : boolean;
begin
  for Index := 0 to Count -1 do
  begin
    ConstConcObject := Items[Index] as TGwtConstConc;
    With ConstConcObject do
    begin
    if (ConstConc. Layer = AConstConc.Layer) and
       (ConstConc.Row = AConstConc.Row) and
       (ConstConc.Column = AConstConc.Column) and
       (ConstConc.ContourIndex = AConstConc.ContourIndex) then
       begin
         Identical := True;

         if Identical then
         begin
           ConstConc.Concentration := ConstConc.Concentration + AConstConc.Concentration;
           result := Index;
           Exit;
         end;
       end;
    end;
  end;
  ConstConcObject := TGwtConstConc.Create;
  result := Add(ConstConcObject);
  ConstConcObject.ConstConc.Layer := AConstConc.Layer;
  ConstConcObject.ConstConc.Row := AConstConc.Row;
  ConstConcObject.ConstConc.Column := AConstConc.Column;
  ConstConcObject.ConstConc.Concentration := AConstConc.Concentration;
  ConstConcObject.ConstConc.ContourIndex := AConstConc.ContourIndex;
end;


function TGwtConstConcList.GetConstConcByLocation(Layer, Row, Column: integer): TGwtConstConc;
var
  Index : integer;
  AConstConc : TGwtConstConc;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    AConstConc := Items[Index] as TGwtConstConc;
    if (AConstConc.ConstConc.Layer = Layer) and (AConstConc.ConstConc.Row = Row)
      and (AConstConc.ConstConc.Column = Column) then
    begin
      result := AConstConc;
      Exit;
    end;
  end;
end;

procedure TGwtConstConcList.Sort;
begin
  inherited Sort(ConstConcSortFunction);
end;


{ TGwtConstConc }

procedure TGwtConstConc.WriteConstConc(ConstConcWriter : TGwtConstConcWriter);
begin
  Write(ConstConcWriter.FFile, ConstConc.Layer, ' ',  ConstConc.Row, ' ',
    ConstConc.Column, ' ',
    ConstConcWriter.FreeFormattedReal(ConstConc.Concentration));

  WriteLn(ConstConcWriter.FFile);
end;

end.
