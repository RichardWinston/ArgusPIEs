unit WriteMT3D_TOB;

interface

uses Sysutils, Classes, AnePIE, OptionsUnit, WriteMT3D_Basic,
  WriteModflowDiscretization;

type
  TConcIndicies = record
    NameIndex: ANE_INT32;
    TimeIndex: ANE_INT32;
    ConcentrationIndex: ANE_INT32;
    SpeciesIndex: ANE_INT32;
    ObservationWeightIndex: ANE_INT32;
  end;

  TConcIndiciesArray = array of TConcIndicies;

  TLayerIndicies = array of ANE_INT32;

  TConcObs = record
    Col: ANE_INT32;
    Row: ANE_INT32;
    RowOffset : double;
    ColOffset : double;
//    CalculateResiduals: boolean;
  end;

  TObsValues = record
    Name: string;
    Time: double;
    Concentration: double;
    Species: integer;
    Weight: double;
  end;

  TObsValuesArray = array of TObsValues;

  TObsLayers = record
    Weight: double;
  end;

  TObsLayersArray = array of TObsLayers;

  TLayerWeight = class(TObject)
  public
    LayerNumber: integer;
    Weight: double;
  end;

  TConcObsObject = class(TObject)
  public
    Location: TConcObs;
    Values: TObsValuesArray;
    LayerWeights: TList;
//    Layers: TObsLayersArray;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TMt3dTobWriter = class(TMT3DCustomWriter)
  private
    Observations: TList;
    PointErrors: integer;
    CurrentModelHandle : ANE_PTR;
    DisWriter : TDiscretizationWriter;
    LocationErrors: TStringList;
    OutName: string;
    MaxConcObs: integer;
    procedure Evaluate;
    procedure EvaluateLayer(LayerIndex: integer);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSets4and5;
    procedure GetIndicies(Layer: TLayerOptions;
      var Indicies: TConcIndiciesArray);
    procedure GetLayerWeightIndicies(Layer: TLayerOptions; var Indicies: TLayerIndicies);
  public
    procedure WriteFile(const ModelHandle: ANE_PTR; const Root: string;
      const Discretization : TDiscretizationWriter);
  end;


implementation

uses contnrs, WriteNameFileUnit, Variables, GetCellVertexUnit, GetCellUnit,
  GridUnit;

  { TMt3dTobWriter }

procedure TMt3dTobWriter.Evaluate;
var
  LayerIndex: integer;
begin

  PointErrors := 0;
  if frmModflow.cb_inConcObs.Checked then
  begin
    for LayerIndex := 1 to StrToInt(frmModflow.adeConcObsLayerCount.Text) do
    begin
      EvaluateLayer(LayerIndex);
    end;
  end;
end;

procedure TMt3dTobWriter.GetIndicies(Layer: TLayerOptions;
  var Indicies: TConcIndiciesArray);
var
  Count: integer;
  ParamName: string;
  Index: integer;
begin
  Count := StrToInt(frmModflow.adeConcObsTimeCount.Text);
  SetLength(Indicies, Count);
  for Index := 1 to Count do
  begin
    ParamName := ModflowTypes.GetMFObservationNameParamType.WriteParamName
      + IntToStr(Index);
    Indicies[Index-1].NameIndex := Layer.GetParameterIndex(CurrentModelHandle,ParamName);
    Assert(Indicies[Index-1].NameIndex >= 0);

    ParamName := ModflowTypes.GetMFTimeParamType.WriteParamName
      + IntToStr(Index);
    Indicies[Index-1].TimeIndex := Layer.GetParameterIndex(CurrentModelHandle,ParamName);
    Assert(Indicies[Index-1].TimeIndex >= 0);

    ParamName := ModflowTypes.GetMFConcObsParamType.WriteParamName
      + IntToStr(Index);
    Indicies[Index-1].ConcentrationIndex := Layer.GetParameterIndex(CurrentModelHandle,ParamName);
    Assert(Indicies[Index-1].ConcentrationIndex >= 0);

    ParamName := ModflowTypes.GetMFSpeciesParamType.WriteParamName
      + IntToStr(Index);
    Indicies[Index-1].SpeciesIndex := Layer.GetParameterIndex(CurrentModelHandle,ParamName);
    Assert(Indicies[Index-1].SpeciesIndex >= 0);

    ParamName := ModflowTypes.GetMFObservationWeightParamType.WriteParamName
      + IntToStr(Index);
    Indicies[Index-1].ObservationWeightIndex := Layer.GetParameterIndex(CurrentModelHandle,ParamName);
    Assert(Indicies[Index-1].ObservationWeightIndex >= 0);
  end;

end;

procedure TMt3dTobWriter.EvaluateLayer(LayerIndex: integer);
var
  LayerName: string;
  Layer: TLayerOptions;
  Indicies: TConcIndiciesArray;
  ContourCount: integer;
  Contour: TContourObjectOptions;
  ContourIndex: ANE_INT32;
  LayerWeightIndicies: TLayerIndicies;
  Observation: TConcObs;
  BlockIndex: integer;
  X, Y: ANE_DOUBLE;
  Below, Above: ANE_DOUBLE;
  Values: TObsValuesArray;
  Layers: TObsLayersArray;
  Index: integer;
  ObsObject: TConcObsObject;
  LayWeight: TLayerWeight;
  UnitIndex: integer;
  ModflowLayer: integer;
  LayIndex: integer;
  DiscrCount: integer;
  TotalWeight: double;
  WeightIndex: integer;
begin
  LayerName := ModflowTypes.GetMT3DWeightedConcentrationObservationsLayerType.
    ANE_LayerName + IntToStr(LayerIndex);
  AddVertexLayer(CurrentModelHandle, LayerName);
  Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
  try
    GetIndicies(Layer, Indicies);
    SetLength(Values, Length(Indicies));
    GetLayerWeightIndicies(Layer, LayerWeightIndicies);
    SetLength(Layers, Length(LayerWeightIndicies));

    ContourCount := Layer.NumObjects(CurrentModelHandle, pieContourObject);
    for ContourIndex := 0 to ContourCount -1 do
    begin
      Contour := TContourObjectOptions.Create(CurrentModelHandle,
        Layer.LayerHandle, ContourIndex);
      try
        if Contour.ContourType(CurrentModelHandle) <> ctPoint then
        begin
          Inc(PointErrors);
        end
        else
        begin
          for Index := 0 to Length(Indicies) -1 do
          begin
            Values[Index].Name := StringReplace(Contour.GetStringParameter(
              CurrentModelHandle, Indicies[Index].NameIndex),
              ' ', '_', [rfReplaceAll]);
            Values[Index].Time := Contour.GetFloatParameter(
              CurrentModelHandle, Indicies[Index].TimeIndex);
            Values[Index].Concentration := Contour.GetFloatParameter(
              CurrentModelHandle, Indicies[Index].ConcentrationIndex);
            Values[Index].Species := Contour.GetIntegerParameter(
              CurrentModelHandle, Indicies[Index].SpeciesIndex);
            Values[Index].Weight := Contour.GetFloatParameter(
              CurrentModelHandle, Indicies[Index].ObservationWeightIndex);
          end;

          for Index := 0 to Length(LayerWeightIndicies) -1 do
          begin
            Layers[Index].Weight := Contour.GetFloatParameter(
              CurrentModelHandle, LayerWeightIndicies[Index]);
          end;

          for BlockIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
          begin
            if BlockIndex > 0 then
            begin
              Continue;
            end;

            Observation.Row := GGetCellRow(ContourIndex,BlockIndex);
            Observation.Col := GGetCellColumn(ContourIndex,BlockIndex);
            if GGetCellVertexCount(ContourIndex,BlockIndex) > 0 then
            begin
              X := GGetCellVertexXPos(ContourIndex, BlockIndex, 0);
              Y := GGetCellVertexYPos(ContourIndex, BlockIndex, 0);

              Below := GGetColumnBoundaryPosition(Observation.Col-1);
              Above := GGetColumnBoundaryPosition(Observation.Col);
              Observation.ColOffset := (X - (Below + Above)/2)/(Above - Below);

              Below := GGetRowBoundaryPosition(Observation.Row-1);
              Above := GGetRowBoundaryPosition(Observation.Row);

              Observation.RowOffset := (Y - (Below + Above)/2)/(Above - Below);

              ObsObject := TConcObsObject.Create;
              Observations.Add(ObsObject);

              ObsObject.Location := Observation;
              ObsObject.Values := Values;
              SetLength(ObsObject.Values, Length(ObsObject.Values));

              ModflowLayer := 0;
              for UnitIndex := 0 to Length(Layers) -1 do
              begin
                if frmModflow.Simulated(UnitIndex + 1) then
                begin
                  DiscrCount := frmModflow.DiscretizationCount(UnitIndex + 1);
                  if (Layers[UnitIndex].Weight > 0) then
                  begin
                    for LayIndex := 1 to DiscrCount do
                    begin
                      LayWeight:= TLayerWeight.Create;
                      ObsObject.LayerWeights.Add(LayWeight);
                      LayWeight.LayerNumber := ModflowLayer + LayIndex;
                      LayWeight.Weight := Layers[UnitIndex].Weight/DiscrCount;
                    end;
                  end;
                  ModflowLayer := ModflowLayer + DiscrCount;
                end;
              end;
              if ObsObject.LayerWeights.Count = 0 then
              begin
                LocationErrors.Add('X = ' + FloatToStr(X)
                  + '; Y = ' + FloatToStr(Y));
              end;
              if ObsObject.LayerWeights.Count > 1 then
              begin
                TotalWeight := 0;

                for WeightIndex := 0 to ObsObject.LayerWeights.Count-1 do
                begin
                  LayWeight := ObsObject.LayerWeights[WeightIndex];
                  TotalWeight := TotalWeight + LayWeight.Weight;
                end;
                for WeightIndex := 0 to ObsObject.LayerWeights.Count-1 do
                begin
                  LayWeight := ObsObject.LayerWeights[WeightIndex];
                  LayWeight.Weight := LayWeight.Weight/TotalWeight;
                end;
              end;

            end;
          end;
        end;

      finally
        Contour.Free;
      end;

    end;

  finally
    Layer.Free(CurrentModelHandle);
  end;

end;

procedure TMt3dTobWriter.WriteDataSet1;
var
  MaxFluxObs: integer;
  MaxFluxCells: integer;
  Obs: TConcObsObject;
  Index: integer;
begin
  MaxConcObs := 0;
  for Index := 0 to Observations.Count -1 do
  begin
    Obs := Observations[Index];
    MaxConcObs := MaxConcObs + Length(Obs.Values);
  end;

  MaxFluxObs := 0;
  MaxFluxCells := 0;
  WriteLn(FFile, MaxConcObs, ' ', MaxFluxObs, ' ', MaxFluxCells);
end;

procedure TMt3dTobWriter.WriteFile(const ModelHandle: ANE_PTR;
  const Root: string; const Discretization: TDiscretizationWriter);
var
  FileName: string;
begin
  Assert(Discretization <> nil);
  DisWriter := Discretization;
  CurrentModelHandle := ModelHandle;

  OutName := StringReplace(Root, ' ', '_', [rfReplaceAll]);
  LocationErrors := TStringList.Create;
  Observations := TObjectList.Create;
  try
    Evaluate;

    FileName := GetCurrentDir + '\' + Root + rsTOB;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
    finally
      WriteDataReadFrom(FileName);
      WriteDataSet1;
      WriteDataSet2;
      if frmModflow.cb_inConcObs.Checked then
      begin
        WriteDataSet3;
        WriteDataSets4and5;
      end;

      CloseFile(FFile);
    end;
  finally
    Observations.Free;
    LocationErrors.Free;
  end;
end;

procedure TMt3dTobWriter.GetLayerWeightIndicies(Layer: TLayerOptions;
  var Indicies: TLayerIndicies);
var
  Count: integer;
  ParamName: string;
  Index: integer;
begin
  Count := StrToInt(frmModflow.edNumUnits.Text);
  SetLength(Indicies, Count);
  for Index := 1 to Count do
  begin
    ParamName := ModflowTypes.GetMFConcWeightParamType.WriteParamName
      + IntToStr(Index);
    Indicies[Index-1] := Layer.GetParameterIndex(CurrentModelHandle,ParamName);
    Assert(Indicies[Index-1] >= 0);
  end;
end;

procedure TMt3dTobWriter.WriteDataSet2;
var
  inConcObs: integer;
  inFluxObs: integer;
  inSaveObs: integer;
begin
  if frmModflow.cb_inConcObs.Checked then
  begin
    inConcObs := frmModflow.GetUnitNumber('OCN')
  end
  else
  begin
    inConcObs := 0;
  end;
  if frmModflow.cb_inFluxObs.Checked then
  begin
    inFluxObs := frmModflow.GetUnitNumber('MFX')
  end
  else
  begin
    inFluxObs := 0;
  end;
  if frmModflow.cb_inSaveObs.Checked then
  begin
    inSaveObs := frmModflow.GetUnitNumber('PST')
  end
  else
  begin
    inSaveObs := 0;
  end;
  Writeln(FFile, OutName, ' ', inConcObs, ' ', inFluxObs, ' ', inSaveObs);
end;

procedure TMt3dTobWriter.WriteDataSet3;
var
  nConcObs: integer;
  CScale: double;
  iOutCobs: integer;
  iConcLOG: integer;
  iConcINTP: integer;
begin
  nConcObs := MaxConcObs;
  CScale := StrToFloat(frmModflow.adeCScale.Text);
  iOutCobs := frmModflow.combo_iOutCobs.ItemIndex;
  if frmModflow.cb_iConcLOG.Checked then
  begin
    iConcLOG := 1;
  end
  else
  begin
    iConcLOG := 0;
  end;
  if frmModflow.cb_iConcINTP.Checked then
  begin
    iConcINTP := 1;
  end
  else
  begin
    iConcINTP := 0;
  end;

  WriteLn(FFile, nConcObs, ' ', FreeFormattedReal(CScale), ' ',
    iOutCobs, ' ', iConcLOG, ' ', iConcINTP);

end;

procedure TMt3dTobWriter.WriteDataSets4and5;
var
  Index: integer;
  Observation: TConcObsObject;
  COBSNAM: string;
  TimeObs: double;
  iComp: integer;
  COBS: double;
  Row: integer;
  Column: integer;
  Layer: integer;
  Roff: double;
  Coff: double;
  DataSet5: string;
  LayerWeight: TLayerWeight;
  LayerIndex: integer;
  ValueIndex: integer;
  weight: double;
begin
  for Index := 0 to Observations.Count -1 do
  begin
    Observation := Observations[Index];
    if Observation.LayerWeights.Count = 0 then
    begin
      Continue;
    end;
    Row := Observation.Location.Row;
    Column := Observation.Location.Col;
    Roff := Observation.Location.RowOffset;
    Coff := Observation.Location.ColOffset;
    if Observation.LayerWeights.Count = 1 then
    begin
      LayerWeight := Observation.LayerWeights[0];
      Layer := LayerWeight.LayerNumber;
    end
    else
    begin
      Layer := -Observation.LayerWeights.Count;
      DataSet5 := '';
      for LayerIndex := 0 to Observation.LayerWeights.Count -1 do
      begin
        LayerWeight := Observation.LayerWeights[LayerIndex];
        DataSet5 := DataSet5 + IntToStr(LayerWeight.LayerNumber) +
          ' ' + FreeFormattedReal(LayerWeight.Weight) + ' ';
      end;
      DataSet5 := Trim(DataSet5);
    end;

    for ValueIndex := 0 to Length(Observation.Values) -1 do
    begin
      COBSNAM := Observation.Values[ValueIndex].Name;
      TimeObs := Observation.Values[ValueIndex].Time;
      iComp := Observation.Values[ValueIndex].Species;
      COBS := Observation.Values[ValueIndex].Concentration;
      weight := Observation.Values[ValueIndex].Weight;

      // data set 4
      writeln(FFile, COBSNAM, ' ', Layer, ' ', Row, ' ', Column, ' ',
        iComp, ' ', FreeFormattedReal(TimeObs), FreeFormattedReal(Roff),
        FreeFormattedReal(Coff), FreeFormattedReal(weight),
        FreeFormattedReal(COBS));
      if Layer < 0 then
      begin
        writeln(FFile, DataSet5);
      end;
    end;
  end;
end;

{ TConcObsObject }

constructor TConcObsObject.Create;
begin
  inherited;
  LayerWeights := TObjectList.Create;
end;

destructor TConcObsObject.Destroy;
begin
  LayerWeights.Free;
  inherited;
end;

end.
