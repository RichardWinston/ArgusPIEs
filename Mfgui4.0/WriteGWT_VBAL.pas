unit WriteGWT_VBAL;

interface

uses Sysutils, Classes, contnrs, Forms, Grids, ANEPIE,
  WriteModflowDiscretization, OptionsUnit, CopyArrayUnit;

type
  TGwtVbalRecord = record
    Layer, Row, Column : integer;
    ContourIndex: integer;
  end;

  TGwtVbal = Class;

  TGwtVbalList = Class(TObjectList)
    public
    function Add(AVbal : TGwtVbalRecord) : integer; overload;
    function GetVbalByLocation(Layer, Row, Column : integer) : TGwtVbal;
    procedure Sort;
  end;

  TGwtVBalWriter = class(TCustomBoundaryWriter)
  private
    VbalList : TGwtVbalList;
    NBAL : integer;
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
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    function GetBoundaryThickness(DivIndex, LayersPerUnit: integer; Top,
      UnitThickness, BoundaryTop, BoundaryBottom: double): double;
    function GetLayersAbove(UnitIndex : integer): Integer;
    procedure SortVbal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    function BoundaryUsed(Layer, Row, Column : integer) : boolean; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
  end;

  TGwtVbal = Class(TObject)
  private
    Vbal : TGwtVbalRecord;
    procedure WriteVbal(ConstConcWriter : TGwtVBalWriter);
  end;


implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, RealListUnit,
  GetFractionUnit, IntListUnit, WriteNameFileUnit, UnitNumbers,
  UtilityFunctions;

function VbalSortFunction(Item1, Item2: Pointer): Integer;
var
  Well1, Well2 : TGwtVbal;
begin
  Well1 := Item1;
  Well2 := Item2;
  result := Well1.Vbal.Layer - Well2.Vbal.Layer;
  if Result <> 0 then Exit;
  result := Well1.Vbal.Row - Well2.Vbal.Row;
  if Result <> 0 then Exit;
  result := Well1.Vbal.Column - Well2.Vbal.Column;
end;


{ TGwtVBalWriter }


procedure TGwtVBalWriter.GetParamIndicies(out TopIndex, BottomIndex: ANE_INT16;
  out TopName, BottomName: string; const
  CurrentModelHandle: ANE_PTR; WellLayer : TLayerOptions);
begin
  TopName := ModflowTypes.GetMFWellTopParamType.WriteParamName;
  TopIndex := WellLayer.GetParameterIndex(CurrentModelHandle, TopName);

  BottomName := ModflowTypes.GetMFWellBottomParamType.WriteParamName;
  BottomIndex := WellLayer.GetParameterIndex(CurrentModelHandle, BottomName);
end;

Function TGwtVBalWriter.GetBoundaryThickness(DivIndex, LayersPerUnit : integer;
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
function TGwtVBalWriter.GetLayersAbove(UnitIndex : integer): Integer;
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

procedure TGwtVBalWriter.EvaluatePointLineLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  VbalLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  TopIndex : ANE_INT16;
  BottomIndex : ANE_INT16;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  AVbal : TGwtVbalRecord;
  CellIndex : integer;
  Top, Bottom : double;
  ConcBoundList : TGwtVbalList;
  ContourTop, ContourBottom : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  TopName, BottomName: string;
  Used : boolean;
  LayersPerUnit : integer;
  DivIndex : integer;
  BoundaryTop, BoundaryBottom : ANE_Double;
  UnitThickness, DivThickness : double;
  Layer : integer;
  BoundaryThickness : double;
  TopErrors, BottomErrors, ThicknessErrors: TStringList;
  AString : string;
  ContourType: TArgusContourType;
begin
  // point or line Constant-Concentration Boundaries
  TopErrors := TStringList.Create;
  BottomErrors := TStringList.Create;
  ThicknessErrors := TStringList.Create;
  try
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);

    LayerName := ModflowTypes.GetGWT_VolumeBalancingLayerClass.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    VbalLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ContourCount := VbalLayer.NumObjects(CurrentModelHandle,pieContourObject);
      if ContourCount > 0 then
      begin
        GetParamIndicies(TopIndex, BottomIndex, TopName,
          BottomName, CurrentModelHandle, VbalLayer);

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

            ContourTop := Contour.GetFloatParameter(CurrentModelHandle,TopIndex);
            ContourBottom := Contour.GetFloatParameter(CurrentModelHandle,BottomIndex);

            for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
            begin
              if not ContinueExport then break;
              Application.ProcessMessages;
              AVbal.Row := GGetCellRow(ContourIndex, CellIndex);
              AVbal.Column := GGetCellColumn(ContourIndex, CellIndex);
              Top := Discretization.Elevations[AVbal.Column-1,AVbal.Row-1,UnitIndex-1];
              Bottom := Discretization.Elevations[AVbal.Column-1,AVbal.Row-1,UnitIndex];
              UnitThickness := Discretization.Thicknesses[AVbal.Column-1,AVbal.Row-1,UnitIndex-1];

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
              end;

              if (BoundaryTop > Top) or (BoundaryTop < Bottom) then
              begin
                if ShowWarnings then
                begin
                  if BoundaryTop > Top then
                  begin
                    TopErrors.Add(Format
                      ('[%d, %d] Top Elevation > top of unit', [AVbal.Row, AVbal.Column]));
                  end;
                  if BoundaryTop < Bottom then
                  begin
                    BottomErrors.Add(Format
                      ('[%d, %d] Top Elevation < bottom of unit', [AVbal.Row, AVbal.Column]));
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
                      ('[%d, %d] Bottom Elevation > top of unit', [AVbal.Row, AVbal.Column]));
                  end;
                  if BoundaryBottom < Bottom then
                  begin
                    BottomErrors.Add(Format
                      ('[%d, %d] Bottom Elevation < bottom of unit', [AVbal.Row, AVbal.Column]));
                  end;
                end;
                BoundaryBottom := Bottom;
              end;

              BoundaryThickness := BoundaryTop - BoundaryBottom;
              if ShowWarnings and (BoundaryThickness <= 0) then
              begin
                ThicknessErrors.Add(Format
                  ('[%d, %d]', [AVbal.Row, AVbal.Column]));
              end;
              if BoundaryThickness > 0 then
              begin
                if not ContinueExport then break;
                Application.ProcessMessages;
                for DivIndex := 1 to LayersPerUnit do
                begin
                  DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                    Top, UnitThickness, BoundaryTop, BoundaryBottom);
                  if DivThickness > 0 then
                  begin
                    AVbal.Layer := Layer + DivIndex;
                    VbalList.Add(AVbal);
                  end;
                end;
              end;
            end;
          finally
            Contour.Free;
          end;
        end; // for ContourIndex := 0 to ContourCount -1 do
      end;
    finally
      VbalLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
    end;
    if TopErrors.Count > 0 then
    begin
      AString := 'Warning: Some VBAL location top elevations extend outside of the geologic '
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
      AString := 'Warning: Some VBAL location bottom elevations extend outside of the geologic '
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
      AString := 'Warning: Some VBAL location vertical extents are <= 0 in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);  

      AString := 'These vbal locations will be skipped.';
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

procedure TGwtVBalWriter.EvaluateAreaLayer(const
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
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  AVbalLocation : TGwtVbalRecord;
  Top, Bottom : double;
  ContourTop, ContourBottom : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  IsParamName, ParamName, TopName, BottomName: string;
  ColIndex, RowIndex : integer;
  IsNA : boolean;
  Used : boolean;
  LayersPerUnit : integer;
  DivIndex : integer;
  BoundaryTop, BoundaryBottom : ANE_Double;
  UnitThickness, DivThickness : double;
  Layer : integer;
  Index : integer;
  VbalIndex : integer;
  Expression : string;
  TopErrors, BottomErrors, ThicknessErrors : TStringList;
  AString : string;
  BoundaryThickness : double;
begin
  TopErrors := TStringList.Create;
  BottomErrors := TStringList.Create;
  ThicknessErrors := TStringList.Create;
  try
    Layer := GetLayersAbove(UnitIndex);
    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
      [Ord(nuiVertDisc),UnitIndex]);

    LayerName := ModflowTypes.GetGWT_VolumeBalancingLayerClass.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    ResetAreaValues;

    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    ConcentrationlLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ContourCount := ConcentrationlLayer.NumObjects(CurrentModelHandle,pieContourObject);
      frmProgress.pbActivity.Max := Discretization.NCOL * Discretization.NROW;

      for ColIndex := 1 to Discretization.NCOL do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        AVbalLocation.Column := ColIndex;
        for RowIndex := 1 to Discretization.NROW do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          AVbalLocation.Row := RowIndex;
          Top := Discretization.Elevations[AVbalLocation.Column-1,AVbalLocation.Row-1,UnitIndex-1];
          Bottom := Discretization.Elevations[AVbalLocation.Column-1,AVbalLocation.Row-1,UnitIndex];
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
                ('[%d, %d]', [AVbalLocation.Column, AVbalLocation.Row]));
            end;
            if BoundaryThickness > 0 then
            begin
              if not ContinueExport then break;
              Application.ProcessMessages;
              if TopError1 then
              begin
                TopErrors.Add(Format
                  ('[%d, %d] Top Elevation > top of unit', [AVbalLocation.Row, AVbalLocation.Column]));
              end;
              if BottomError1 then
              begin
                BottomErrors.Add(Format
                  ('[%d, %d] Top Elevation < bottom of unit', [AVbalLocation.Row, AVbalLocation.Column]));
              end;
              if TopError2 then
              begin
                TopErrors.Add(Format
                  ('[%d, %d] Bottom Elevation > top of unit', [AVbalLocation.Row, AVbalLocation.Column]));
              end;
              if BottomError2 then
              begin
                BottomErrors.Add(Format
                  ('[%d, %d] Bottom Elevation < bottom of unit', [AVbalLocation.Row, AVbalLocation.Column]));
              end;

              for DivIndex := 1 to LayersPerUnit do
              begin
                DivThickness := GetBoundaryThickness(DivIndex, LayersPerUnit,
                  Top, UnitThickness, BoundaryTop, BoundaryBottom);
                if DivThickness > 0 then
                begin
                  AVbalLocation.Layer := Layer + DivIndex;
                  VbalList.Add(AVbalLocation);
                end;  // if DivThickness > 0 then
              end; // for DivIndex := 1 to LayersPerUnit do
            end;
          end;  // if not IsNA then
        end; // for RowIndex:=  to Discretization.NROW do
      end; // for ColIndex := 1 to Discretization.NCOL; do
    finally
      ConcentrationlLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
    end;
    if TopErrors.Count > 0 then
    begin
      AString := 'Warning: Some VBAL location elevations extend outside of the geologic '
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
      AString := 'Warning: Some VBAL location bottom elevations extend outside of the geologic '
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
      AString := 'Warning: Some VBAL location vertical extents are <= 0 in unit '
        + IntToStr(UnitIndex) + '.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'These VBAL location will be skipped.';
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

procedure TGwtVBalWriter.EvaluateDataSets6and7(
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
          frmProgress.lblActivity.Caption := 'Evaluating VBAL in Unit '
            + IntToStr(UnitIndex);
          EvaluatePointLineLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          // area wells
          frmProgress.lblActivity.Caption := 'Evaluating VBAL in Unit '
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

procedure TGwtVBalWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  FileName : string;
begin
  frmProgress.pbPackage.Max := 5 + Discretization.NUNITS*3 ;
  frmProgress.lblPackage.Caption := 'VBAL Package';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;
  if ContinueExport then
  begin
    EvaluateDataSets6and7(CurrentModelHandle, Discretization);
  end;

  if ContinueExport then
  begin
    SortVbal;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;


  if ContinueExport then
  begin

    FileName := GetCurrentDir + '\' + Root + rsVBAL;
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

procedure TGwtVBalWriter.SortVbal;
begin
  frmProgress.lblActivity.Caption := 'Sorting VBAL cells';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := 1;
  VbalList.Sort;
  frmProgress.pbActivity.StepIt;
end;


procedure TGwtVBalWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization : TDiscretizationWriter);
begin
  frmProgress.pbPackage.Max := 2 ;
  frmProgress.lblPackage.Caption := 'VBAL Package';
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
    SortVbal;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TGwtVBalWriter.WriteDatasets5To7;
begin
  if not ContinueExport then Exit;
  frmProgress.lblActivity.Caption := 'Writing Data Set 1';
  WriteDataSet1;
  Application.ProcessMessages;
  if NBAL > 0 then
  begin
    frmProgress.lblActivity.Caption := 'Writing Data Set 2';
    WriteDataSet2;
    Application.ProcessMessages;
  end;
end;

procedure TGwtVBalWriter.WriteDataSet1;
begin
  NBAL := VbalList.Count;
  WriteLn(FFile, NBAL);
end;

procedure TGwtVBalWriter.WriteDataSet2;
var
  AVbal : TGwtVbal;
  VbalIndex : integer;
begin
  for VbalIndex := 0 to VbalList.Count -1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    AVbal := VbalList[VbalIndex] as TGwtVbal;
    AVbal.WriteVbal(self);
  end;
end;

function TGwtVBalWriter.BoundaryUsed(Layer, Row, Column: integer): boolean;
var
  AVbal : TGwtVbal;
begin
  AVbal := VbalList.GetVbalByLocation(Layer, Row, Column);
  result := AVbal <> nil;
end;

constructor TGwtVBalWriter.Create;
begin
  inherited;
  VbalList := TGwtVbalList.Create;
end;

destructor TGwtVBalWriter.Destroy;
begin
  VbalList.Free;
  inherited;
end;

{ TGwtVbalList }

function TGwtVbalList.Add(AVbal : TGwtVbalRecord): integer;
var
  VbalObject : TGwtVbal;
  Index : integer;
  Identical : boolean;
begin
  for Index := 0 to Count -1 do
  begin
    VbalObject := Items[Index] as TGwtVbal;
    With VbalObject do
    begin
    if (Vbal.Layer = AVbal.Layer) and
       (Vbal.Row = AVbal.Row) and
       (Vbal.Column = AVbal.Column) and
       (Vbal.ContourIndex = AVbal.ContourIndex) then
       begin
         Identical := True;

         if Identical then
         begin
           result := Index;
           Exit;
         end;
       end;
    end;
  end;
  VbalObject := TGwtVbal.Create;
  result := Add(VbalObject);
  VbalObject.Vbal.Layer := AVbal.Layer;
  VbalObject.Vbal.Row := AVbal.Row;
  VbalObject.Vbal.Column := AVbal.Column;
  VbalObject.Vbal.ContourIndex := AVbal.ContourIndex;
end;


function TGwtVbalList.GetVbalByLocation(Layer, Row, Column: integer): TGwtVbal;
var
  Index : integer;
  AVbal : TGwtVbal;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    AVbal := Items[Index] as TGwtVbal;
    if (AVbal.Vbal.Layer = Layer) and (AVbal.Vbal.Row = Row)
      and (AVbal.Vbal.Column = Column) then
    begin
      result := AVbal;
      Exit;
    end;
  end;
end;

procedure TGwtVbalList.Sort;
begin
  inherited Sort(VbalSortFunction);
end;

{ TGwtConstConc }

procedure TGwtVbal.WriteVbal(ConstConcWriter : TGwtVBalWriter);
begin
  Write(ConstConcWriter.FFile, Vbal.Layer, ' ',  Vbal.Row, ' ',
    Vbal.Column, ' ');

  WriteLn(ConstConcWriter.FFile);
end;

end.
