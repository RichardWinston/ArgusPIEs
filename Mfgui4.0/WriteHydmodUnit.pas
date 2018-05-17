unit WriteHydmodUnit;

interface

uses Sysutils, Forms, Contnrs, AnePIE, OptionsUnit, WriteModflowDiscretization,
  WriteStrUnit;

type
  THydmodIndicies = record
    InterpolateIndex : ANE_INT16;
    LayerIndex : ANE_INT16;
    WriteHeadIndex : ANE_INT16;
    WritedrawdownIndex : ANE_INT16;
    WritePreconsolidationHeadIndex : ANE_INT16;
    WriteCompactionIndex : ANE_INT16;
    WriteSubsidenceIndex : ANE_INT16;
    HydmodLabelIndex : ANE_INT16;
  end;

  THydModRecord = record
    X, Y : double;
    Layer : integer;
    WriteHead : boolean;
    WriteDrawdown : boolean;
    WritePreconsolidationHead : boolean;
    WriteCompaction : boolean;
    WriteSubsidence : boolean;
    Interpolate : boolean;
    HydmodLabel : string;
  end;

  THydmodWriter = class(TListWriter)
  private
    ModelHandle : ANE_PTR;
    DisWriter : TDiscretizationWriter;
    StrWriter : TStrWriter;
    ColPostions, RowPostions : TPostionArray;
    GridAngle, RotatedOriginX, RotatedOriginY : ANE_DOUBLE;
    HydList : TObjectList;
    IBSLayers : array of integer;
    Procedure GetParamIndicies(const Layer : TLayerOptions;
      var Indicies : THydmodIndicies; const UnitIndex : integer);
    procedure EvaluateHydmodLayer(const UnitIndex: integer);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
  public
    property HydFile : TextFile read FFile;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; StreamWriter :TStrWriter);
    class procedure AssignUnitNumbers;
  end;

  THydmodObject = class(TObject)
  private
    Value : THydModRecord;
{    X, Y : double;
    Layer : integer;
    WriteHead : boolean;
    Writedrawdown : boolean;
    WritePreconsolidationHead : boolean;
    WriteCompaction : boolean;
    WriteSubsidence : boolean;
    Interpolate : boolean;
    HydmodLabel : string; }
    procedure Write(HydmodWriter : THydmodWriter);
  end;

implementation

uses UtilityFunctions, Variables, WriteNameFileUnit;

{ THydmodWriter }

class procedure THydmodWriter.AssignUnitNumbers;
begin
  frmModflow.GetUnitNumber('IHYDUN');
end;

procedure THydmodWriter.EvaluateHydmodLayer(const UnitIndex: integer);
var
  LayerName : string;
  Layer : TLayerOptions;
  Contour : TContourObjectOptions;
  ContourIndex : ANE_INT32;
  Indicies : THydmodIndicies;
  NodeIndex : ANE_INT32;
  X, Y : ANE_DOUBLE;
  HydModRecord : THydModRecord;
//  Elevation : double;
  Col, Row: Integer;
//  TopElev, BotElev : double;
  HydmodObject : THydmodObject;
begin
  HydModRecord.WriteHead := False;
  HydModRecord.WriteDrawdown := False;
  HydModRecord.WritePreconsolidationHead := False;
  HydModRecord.WriteCompaction := False;
  HydModRecord.WriteSubsidence := False;
  HydModRecord.Interpolate := False;
  LayerName := ModflowTypes.GetMFHydmodLayerType.ANE_LayerName
    + IntToStr(UnitIndex);
  Layer := TLayerOptions.CreateWithName(LayerName,ModelHandle);
  try
    GetParamIndicies(Layer, Indicies, UnitIndex);
    for ContourIndex := 0 to Layer.NumObjects(ModelHandle, pieContourObject) -1 do
    begin
      Contour := TContourObjectOptions.Create(ModelHandle, Layer.LayerHandle,
        ContourIndex);
      try
{        Elevation := Contour.GetFloatParameter(ModelHandle,
          Indicies.ElevIndex); }

        HydModRecord.Layer := Contour.GetIntegerParameter(ModelHandle,
          Indicies.LayerIndex);
        HydModRecord.WriteHead := Contour.GetBoolParameter(ModelHandle,
          Indicies.WriteHeadIndex);
        HydModRecord.Writedrawdown := Contour.GetBoolParameter(ModelHandle,
          Indicies.WritedrawdownIndex);

        if Indicies.WritePreconsolidationHeadIndex >= 0 then
        begin
          HydModRecord.WritePreconsolidationHead := Contour.GetBoolParameter(ModelHandle,
            Indicies.WritePreconsolidationHeadIndex);
          HydModRecord.WriteCompaction := Contour.GetBoolParameter(ModelHandle,
            Indicies.WriteCompactionIndex);
          HydModRecord.WriteSubsidence := Contour.GetBoolParameter(ModelHandle,
            Indicies.WriteSubsidenceIndex);
        end;
        HydModRecord.Interpolate := Contour.GetBoolParameter(ModelHandle,
          Indicies.InterpolateIndex);
        HydModRecord.HydmodLabel := Contour.GetStringParameter(ModelHandle,
          Indicies.HydmodLabelIndex) + ' ';
        for NodeIndex := 0 to Contour.NumberOfNodes(ModelHandle) -1 do
        begin
          Contour.GetNthNodeLocation(ModelHandle, X, Y, NodeIndex);

          DisWriter.GetColRow(X, Y, Col, Row, GridAngle, RotatedOriginX,
            RotatedOriginY, ColPostions, RowPostions);

          if (Col > 0) and (Row > 0) then
          begin

{            TopElev := DisWriter.Elevations[Col-1, Row-1,UnitIndex-1];
            BotElev := DisWriter.Elevations[Col-1, Row-1,UnitIndex];

            HydModRecord.Layer :=  frmMODFLOW.ModflowLayer(UnitIndex, TopElev,
              BotElev, Elevation); }

            HydModRecord.X := X;
            HydModRecord.Y := Y;

            HydmodObject := THydmodObject.Create;
            HydList.Add(HydmodObject);
            HydmodObject.Value := HydModRecord;
          end;

        end;
      finally
        Contour.Free;
      end;

    end;

  finally
    Layer.Free(ModelHandle);
  end;
end;

procedure THydmodWriter.GetParamIndicies(const Layer: TLayerOptions;
  var Indicies: THydmodIndicies; const UnitIndex : integer);
var
  ParamName : string;
begin
  ParamName := ModflowTypes.GetMFHydmodInterpolateParamType.ANE_ParamName;
  Indicies.InterpolateIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
  Assert(Indicies.InterpolateIndex >= 0);

  ParamName := ModflowTypes.GetMFHydmodModflowLayerParamType.ANE_ParamName;
  Indicies.LayerIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
  Assert(Indicies.LayerIndex >= 0);

  ParamName := ModflowTypes.GetMFHydmodHeadObservationParamType.ANE_ParamName;
  Indicies.WriteHeadIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
  Assert(Indicies.WriteHeadIndex >= 0);

  ParamName := ModflowTypes.GetMFHydmodDrawDownObservationParamType.ANE_ParamName;
  Indicies.WritedrawdownIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
  Assert(Indicies.WritedrawdownIndex >= 0);

  if frmModflow.cbIBS.Checked and frmModflow.cbUseIBS.Checked and frmMODFLOW.UseIBS(UnitIndex) then
  begin
    ParamName := ModflowTypes.GetMFHydmodPreconsolidationObservationParamType.ANE_ParamName;
    Indicies.WritePreconsolidationHeadIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
    Assert(Indicies.WritePreconsolidationHeadIndex >= 0);

    ParamName := ModflowTypes.GetMFHydmodCompactionObservationParamType.ANE_ParamName;
    Indicies.WriteCompactionIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
    Assert(Indicies.WriteCompactionIndex >= 0);

    ParamName := ModflowTypes.GetMFHydmodSubsidenceObservationParamType.ANE_ParamName;
    Indicies.WriteSubsidenceIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
    Assert(Indicies.WriteSubsidenceIndex >= 0);

  end
  else
  begin
    Indicies.WritePreconsolidationHeadIndex := -1;
    Indicies.WriteCompactionIndex := -1;
    Indicies.WriteSubsidenceIndex := -1;
  end;

  ParamName := ModflowTypes.GetMFHydmodLabelParamType.ANE_ParamName;
  Indicies.HydmodLabelIndex := Layer.GetParameterIndex(ModelHandle, ParamName);
  Assert(Indicies.HydmodLabelIndex >= 0);
end;

procedure THydmodWriter.WriteDataSet1;
var
  NHYD, IHYDUN : Integer;
  HYDNOH : double;
  HydmodObject : THydmodObject;
  Index : integer;
begin
  NHYD := 0;
  for Index := 0 to HydList.Count -1 do
  begin
    HydmodObject := HydList[Index] as THydmodObject;
    if HydmodObject.Value.WriteHead then
    begin
      Inc(NHYD);
    end;
    if HydmodObject.Value.Writedrawdown then
    begin
      Inc(NHYD);
    end;
    if HydmodObject.Value.WritePreconsolidationHead then
    begin
      Inc(NHYD);
    end;
    if HydmodObject.Value.WriteCompaction then
    begin
      Inc(NHYD);
    end;
    if HydmodObject.Value.WriteSubsidence then
    begin
      Inc(NHYD);
    end;
  end;
  if StrWriter <> nil then
  begin
    NHYD := NHYD + StrWriter.HydmodCount;
  end;
  IHYDUN := frmModflow.GetUnitNumber('IHYDUN');
  HYDNOH := InternationalStrToFloat(frmModflow.adeHydInactive.Text);
  WriteLn(FFile, NHYD, ' ', IHYDUN, ' ', FreeFormattedReal(HYDNOH));
end;

procedure THydmodWriter.WriteDataSet2;
var
  HydmodObject : THydmodObject;
  Index : integer;
begin
  for Index := 0 to HydList.Count -1 do
  begin
    HydmodObject := HydList[Index] as THydmodObject;
    HydmodObject.Write(self);
  end;
  if StrWriter <> nil then
  begin
    StrWriter.WriteHydmod(self);
  end;
end;

procedure THydmodWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter;
  StreamWriter: TStrWriter);
var
//  LayerHandle : ANE_PTR;
  GridLayer : TGridLayerOptions;
  Index : integer;
  UnitIndex : integer;
  FileName : string;
  LayerIndex : Integer;
  DisIndex : integer;
  IBSLayer : integer;
  ReverseX, ReverseY : boolean;
begin
  ModelHandle := CurrentModelHandle;
  DisWriter := Discretization;
  StrWriter := StreamWriter;
  if frmModflow.cbIBS.Checked and frmModflow.cbUseIBS.Checked then
  begin
    SetLength(IBSLayers, Discretization.NLAY);
    IBSLayer := 1;
    LayerIndex := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        if frmModflow.UseIBS(UnitIndex) then
        begin
          for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
          begin
            IBSLayers[LayerIndex] := IBSLayer;
            Inc(IBSLayer);
            Inc(LayerIndex);
          end;
        end
        else
        begin
          for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
          begin
            IBSLayers[LayerIndex] := 0;
            Inc(LayerIndex);
          end;
        end;
      end;
    end;

  end;


  GridLayer := TGridLayerOptions.CreateWithName
    (ModflowTypes.GetGridLayerType.ANE_LayerName, ModelHandle);
  try
    GridAngle := GridLayer.GridAngle(ModelHandle);
//    RotatedOriginX := GridLayer.ColumnPositions(ModelHandle, 0);
//    RotatedOriginY := GridLayer.RowPositions(ModelHandle, 0);
    ReverseX := GridLayer.GridReverseXDirection[ModelHandle];
    ReverseY := GridLayer.GridReverseYDirection[ModelHandle];
    if ReverseX then
    begin
//      GridAngle := -GridAngle;
      RotatedOriginX := GridLayer.ColumnPositions(ModelHandle, DisWriter.NCOL);
    end
    else
    begin
      RotatedOriginX := GridLayer.ColumnPositions(ModelHandle, 0);
    end;
    if ReverseY then
    begin
//      GridAngle := -GridAngle;
      RotatedOriginY := GridLayer.RowPositions(ModelHandle, DisWriter.NROW);
    end
    else
    begin
      RotatedOriginY := GridLayer.RowPositions(ModelHandle, 0);
    end;

//    RotatePointsToGrid(RotatedOriginX, RotatedOriginY, GridAngle);
  finally
    GridLayer.Free(ModelHandle);
  end;

  SetLength(ColPostions, DisWriter.NCOL + 1);
  SetLength(RowPostions, DisWriter.NROW + 1);

  ColPostions[0] := 0;
  RowPostions[0] := 0;
  if ReverseX then
  begin
    for Index := DisWriter.NCOL-1 downto 0 do
    begin
      ColPostions[DisWriter.NCOL - Index] := ColPostions[DisWriter.NCOL - Index -1] + DisWriter.DELR[Index];
    end;
  end
  else
  begin
    for Index := 0 to DisWriter.NCOL-1 do
    begin
      ColPostions[Index+1] := ColPostions[Index] + DisWriter.DELR[Index];
    end;
  end;

  if ReverseY then
  begin
    for Index := DisWriter.NROW-1 downto 0 do
    begin
      RowPostions[DisWriter.NROW - Index] := RowPostions[DisWriter.NROW - Index -1] + DisWriter.DELC[Index];
    end;
  end
  else
  begin
    for Index := 0 to DisWriter.NROW-1 do
    begin
      RowPostions[Index+1] := RowPostions[Index] + DisWriter.DELC[Index];
    end;
  end;

  HydList := TObjectList.Create;
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      EvaluateHydmodLayer(UnitIndex);
    end;

    FileName := GetCurrentDir + '\' + root + rsHYD;

    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataSet1;
      WriteDataSet2;
    finally
      begin
        CloseFile(FFile);
        Application.ProcessMessages;
      end;
    end;


  finally
    HydList.Free;
  end;

end;

{ THydmodObject }

procedure THydmodObject.Write(HydmodWriter: THydmodWriter);
var
  INTYPE : string;
begin
  if Value.Interpolate then
  begin
    INTYPE := 'I '
  end
  else
  begin
    INTYPE := 'C '
  end;

  if Value.WriteHead then
  begin
    WriteLn(HydmodWriter.FFile, 'BAS HD ', INTYPE,
      Value.Layer, ' ',
      HydmodWriter.FreeFormattedReal(Value.X),
      HydmodWriter.FreeFormattedReal(Value.Y),
      Value.HydmodLabel);
  end;

  if Value.Writedrawdown then
  begin
    WriteLn(HydmodWriter.FFile, 'BAS DD ', INTYPE,
      Value.Layer, ' ',
      HydmodWriter.FreeFormattedReal(Value.X),
      HydmodWriter.FreeFormattedReal(Value.Y),
      Value.HydmodLabel);
  end;

  if Value.WritePreconsolidationHead then
  begin
    WriteLn(HydmodWriter.FFile, 'IBS HC ', INTYPE,
      HydmodWriter.IBSLayers[Value.Layer-1], ' ',
      HydmodWriter.FreeFormattedReal(Value.X),
      HydmodWriter.FreeFormattedReal(Value.Y),
      Value.HydmodLabel);
  end;

  if Value.WriteCompaction then
  begin
    WriteLn(HydmodWriter.FFile, 'IBS CP ', INTYPE, 
      HydmodWriter.IBSLayers[Value.Layer-1], ' ',
      HydmodWriter.FreeFormattedReal(Value.X),
      HydmodWriter.FreeFormattedReal(Value.Y),
      Value.HydmodLabel);
  end;

  if Value.WriteSubsidence then
  begin
    WriteLn(HydmodWriter.FFile, 'IBS SB ', INTYPE,
      HydmodWriter.IBSLayers[Value.Layer-1], ' ',
      HydmodWriter.FreeFormattedReal(Value.X),
      HydmodWriter.FreeFormattedReal(Value.Y),
      Value.HydmodLabel);
  end;

end;

end.
