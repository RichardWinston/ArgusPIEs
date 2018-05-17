unit WriteRechargeUnit;

interface

uses Sysutils, Classes, Grids, Forms, Dialogs, ANEPIE,
  WriteModflowDiscretization;

type
  TRechargeWriter = class(TModflowWriter)
  private
    NRCHOP : integer;
    NPRCH : integer;
//    ParamNames : TStringlist;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3and4(Discretization: TDiscretizationWriter);
    procedure WriteDataSet5(StressPeriod: integer; var INRECH, INIRCH : integer);
    procedure WriteDataSets5to8(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter);
    procedure WriteRECHArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod : integer;
      BasicPackage :TBasicPkgWriter);
    procedure WritePname(const StressPeriodIndex : integer);
    procedure WriteIRCHArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
  public
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; BasicPackage :TBasicPkgWriter);
    class procedure AssignUnitNumbers;
  end;

implementation

uses Variables, ModflowUnit, OptionsUnit, ProgressUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

{ TRechargeWriter }

procedure TRechargeWriter.WriteRECHArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; StressPeriod : integer;
  BasicPackage :TBasicPkgWriter);
const
  Zero : double = 0.;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  RechargeLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  RechargeLayerHandle : ANE_PTR;
  Project : TProjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
begin
  try
    frmProgress.lblActivity.Caption := 'writing recharge flux';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    Project := TProjectOptions.Create;
    try
      RechargeLayerHandle := Project.GetLayerByName(CurrentModelHandle,
        ModflowTypes.GetRechargeLayerType.WriteNewRoot);

    finally
      Project.Free;
    end;

    if RechargeLayerHandle <> nil then
    begin
      GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
      RechargeLayer := TLayerOptions.Create(RechargeLayerHandle);
      try
        ParameterName := ModflowTypes.GetMFRechStressParamType.WriteParamName
          + IntToStr(StressPeriod);

       Expression := ModflowTypes.GetRechargeLayerType.WriteNewRoot +
         '.' + ParameterName;
        WriteU2DRELHeader;
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            if BasicPackage.CellUsed[ColIndex,RowIndex] then
            begin
              try
                BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  ABlock.GetCenter(CurrentModelHandle, X, Y);
                  AValue := GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                    Expression);
                  if Abs(AValue) < MinSingle then
                  begin
                    AValue := 0.0;
                  end;

                  Write(FFile, AValue,' ');

                finally
                  ABlock.Free;
                end;
              Except on Exception do
                begin
                  ShowMessage(IntToStr(RowIndex) + ' ' + IntToStr(ColIndex));
                  raise;
                end;
              end;
            end
            else
            begin
              Write(FFile, Zero,' ');
            end;
            frmProgress.pbActivity.StepIt;

          end;

          WriteLn(FFile);
        end;

      finally
        GridLayer.Free(CurrentModelHandle);
        RechargeLayer.Free(CurrentModelHandle);
      end;
    end;
  except On Exception do
    begin
      ShowMessage('Argh');
    end;
  end;
end;

procedure TRechargeWriter.WriteIRCHArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; StressPeriod : integer;
  BasicPackage :TBasicPkgWriter);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  AValue : ANE_DOUBLE;
  ALayer : ANE_INT32;
  LayersPerUnit : integer;
  Top, Bottom : ANE_DOUBLE;
  ParameterIndex : ANE_INT16;
  ElevationsAboveModel, ElevationsBelowModel, NonSimulatedElevations : TStringList;
  AString : string;
begin
  ElevationsAboveModel := TStringList.Create;
  ElevationsBelowModel := TStringList.Create;
  NonSimulatedElevations := TStringList.Create;
  try

    frmProgress.lblActivity.Caption := 'writing recharge layer';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      if frmMODFLOW.cbRechLayer.Checked
        and (frmMODFLOW.comboRchOpt.ItemIndex = 1) then
      begin
        ParameterName := ModflowTypes.GetMFGridRechLayerParamType.WriteParamName;
      end
      else
      begin
        ParameterName := ModflowTypes.GetMFGridRechElevParamType.WriteParamName;
      end;
      ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle, ParameterName);

      WriteU2DINTHeader;
      for RowIndex := 0 to Discretization.NROW -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          if BasicPackage.CellUsed[ColIndex,RowIndex] then
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try
              if frmMODFLOW.cbRechLayer.Checked
                and (frmMODFLOW.comboRchOpt.ItemIndex = 1) then
              begin
                ALayer := ABlock.GetIntegerParameter
                  (CurrentModelHandle,ParameterIndex);

              end
              else
              begin
                AValue := ABlock.GetFloatParameter
                  (CurrentModelHandle,ParameterIndex);
                if Abs(AValue) < MinSingle then
                begin
                  AValue := 0.0;
                end;


                if AValue >= Discretization.Elevations[ColIndex,RowIndex,0] then
                begin
                  ALayer := 1;
                  if ShowWarnings and
                    (AValue > Discretization.Elevations[ColIndex,RowIndex,0]) then
                  begin
                    ElevationsAboveModel.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                end
                else if AValue <= Discretization.
                  Elevations[ColIndex,RowIndex,Discretization.NUNITS-1] then
                begin
                  ALayer := Discretization.NLAY;
                  if ShowWarnings and (AValue < Discretization.Elevations
                  [ColIndex,RowIndex,Discretization.NUNITS-1]) then
                  begin
                    ElevationsBelowModel.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                end
                else
                begin
                  ALayer := 0;
                  for UnitIndex := 1 to Discretization.NUNITS-1 do
                  begin
                    Bottom := Discretization.Elevations
                      [ColIndex,RowIndex,UnitIndex];
                    LayersPerUnit := StrToInt(frmMODFLOW.dgGeol.Cells
                      [Ord(nuiVertDisc),UnitIndex]);
                    Top := Discretization.Elevations
                      [ColIndex,RowIndex,UnitIndex-1];
                    if (AValue <= Top) and (AValue > Bottom) then
                    begin
                      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
                        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
                      begin
                        if LayersPerUnit = 1 then
                        begin
                          ALayer := ALayer + 1;
                        end
                        else
                        begin
                          ALayer := ALayer +
                            Trunc((Top-AValue)/(Top-Bottom)*LayersPerUnit) + 1;
                        end;
                      end
                      else
                      begin
                        if ShowWarnings then
                        begin
                          NonSimulatedElevations.Add(Format('[%d, %d, %d]',
                            [ColIndex+1,RowIndex+1, UnitIndex]));
                        end;
                      end;
                      break;
                    end
                    else
                    begin
                      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
                        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
                      begin
                        ALayer := ALayer + LayersPerUnit;
                      end;
                    end;
  //                  end;
                    if AValue <= Bottom then
                    begin
                      break;
                    end;
                  end;

                end;
              end;
              if ALayer <= 0 then
              begin
                ALayer := 1;
              end;

              Write(FFile, ALayer, ' ');

            finally
              ABlock.Free;
            end;
          end
          else
          begin
            Write(FFile, 1, ' ');
          end;

          frmProgress.pbActivity.StepIt;
        end;

        WriteLn(FFile);
      end;

    finally
      GridLayer.Free(CurrentModelHandle);
//      RechargeLayer.Free(CurrentModelHandle);
    end;
//  end;
    if ElevationsAboveModel.Count > 0 then
    begin
      AString := 'Warning: Some recharge elevations lie above the top of the model.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They will be treated as if they are in the top layer of the model.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ElevationsAboveModel);
    end;
    if ElevationsBelowModel.Count > 0 then
    begin
      AString := 'Warning: Some recharge elevations lie below the bottom of the model.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They will be treated as if they are in the bottom layer of the model.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ElevationsBelowModel);
    end;
    if NonSimulatedElevations.Count > 0 then
    begin
      AString := 'Warning: Some recharge elevations lie in non-simulated geologic units.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They will be treated as if they are in the bottom layer of the unit above the non-simulated unit.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row, Unit]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(NonSimulatedElevations);
    end;

  finally
    ElevationsAboveModel.Free;
    ElevationsBelowModel.Free;
    NonSimulatedElevations.Free;
  end;
end;

procedure TRechargeWriter.WriteDataSet1;
begin
  NPRCH := frmModflow.dgRCHParametersN.RowCount -1;

  if NPRCH > 0 then
  begin
    Writeln(FFile, 'PARAMETER', ' ', NPRCH);
  end
end;

procedure TRechargeWriter.WriteDataSet2;
var
  IRCHCB : integer;
  ITOP : integer;
begin
  with frmModflow do
  begin
    NRCHOP:= comboRchOpt.ItemIndex + 1;
    if cbFlowRCH.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        IRCHCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        IRCHCB := frmModflow.GetUnitNumber('RCHBUD');
      end;
    end
    else
    begin
        IRCHCB := 0;
    end;

    Write(FFile, NRCHOP, ' ', IRCHCB);
    if cbMODPATH.Checked then
    begin
      ITOP := comboMODPATH_RechargeITOP.ItemIndex;
      Write(FFile, ' ', ITOP);
    end;
    Writeln(FFile);
  end;
end;

procedure TRechargeWriter.WriteDataSet5(StressPeriod : integer; var INRECH, INIRCH : integer);
var
  ParamIndex : integer;
  ColIndex : integer;
begin
  with frmMODFLOW do
  begin
    if NPRCH = 0 then
    begin
      If (StressPeriod = 1) or (comboRchSteady.ItemIndex = 1) then
      begin
        INRECH:=  1;
      end
      else
      begin
        INRECH:=  -1;
      end;
    end
    else
    begin
      INRECH := 0;
      ColIndex := StressPeriod+4;
      for ParamIndex := 1 to dgRCHParametersN.RowCount -1 do
      begin
        if dgRCHParametersN.Cells[ColIndex,ParamIndex] <>
          dgRCHParametersN.Columns[ColIndex].Picklist[0] then
        begin
          Inc(INRECH);
        end;
      end;

    end;

    IF (NRCHOP = 2) and (StressPeriod = 1) THEN
    begin
      INIRCH := 1;
    end
    else
    begin
      INIRCH := -1;
    end;

    Writeln(FFile, INRECH, ' ', INIRCH);
  end;
end;

procedure TRechargeWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicPackage :TBasicPkgWriter);
var
  FileName : String;
begin

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Recharge';
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := frmMODFLOW.dgRCHParametersN.RowCount
      + frmMODFLOW.dgTime.RowCount;

    FileName := GetCurrentDir + '\' + Root + rsRCH;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;
      WriteDataSet2;
      WriteDataSets3and4(Discretization);
      WriteDataSets5to8(CurrentModelHandle, Discretization, BasicPackage);
      Flush(FFile);
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;


procedure TRechargeWriter.WriteDataSets3and4(Discretization: TDiscretizationWriter);
var
  ParameterIndex : integer;
  AStringGrid, InstanceGrid : TStringGrid;
  PARTYPE : STRING;
  NCLU : integer;
  Zone : integer;
  ZoneString : string;
  Parval : double;
  PageIndex : integer;
  NUMINST : integer;
  InstanceIndex : integer;
  ZoneErrors : TStringList;
  AString : string;
  procedure WriteCluster;
  var
    ClusterIndex, ZoneIndex : integer;
    NoZones : boolean;
  begin
    for ClusterIndex := 1 to AStringGrid.RowCount -1 do
    begin

      Write(FFile,
        '''' + AStringGrid.Cells[1,ClusterIndex] + ''' ',
        '''' + AStringGrid.Cells[2,ClusterIndex] + ''' ');

      NoZones := AStringGrid.Cells[2,ClusterIndex] <> 'ALL';
      for ZoneIndex := 3 to AStringGrid.ColCount -1 do
      begin
        try
          ZoneString := Trim(AStringGrid.Cells[ZoneIndex,ClusterIndex]);
          if ZoneString <> '' then
          begin
            Zone := StrToInt(ZoneString);
            Write(FFile, Zone, ' ');
            NoZones := False;
          end;
        except on EConvertError do
          begin
          end;
        end;
      end;
      if NoZones then
      begin
        ZoneErrors.Add(frmModflow.dgRCHParametersN.Cells[0,ParameterIndex]);
      end;

      Writeln(FFile);

    end;
  end;
begin
  ZoneErrors := TStringList.Create;
  try
    with frmMODFLOW do
    begin
      PageIndex := 0;
      for ParameterIndex := 1 to dgRCHParametersN.RowCount -1 do
      begin
        PARTYPE := 'RCH';
        NCLU := StrToInt(dgRCHParametersN.Cells[3,ParameterIndex]);

        Parval := InternationalStrToFloat(dgRCHParametersN.Cells[2,ParameterIndex]);
        NUMINST := StrToInt(dgRCHParametersN.Cells[4,ParameterIndex]);

        // DataSet3;
        Write(FFile,
          dgRCHParametersN.Cells[0,ParameterIndex], ' ',
          PARTYPE, ' ',
          FreeFormattedReal(Parval),
          NCLU);
        if NUMINST > 1 then
        begin
          Write(FFile, ' INSTANCES ', NUMINST);
        end;
        Writeln(FFile);

        // data set 4
        if NUMINST > 1 then
        begin
          InstanceGrid := sg3dRCHParamInstances.Grids[ParameterIndex-1];
          for InstanceIndex := 1 to InstanceGrid.RowCount -1 do
          begin
            // data set 4a
            Writeln(FFile, InstanceGrid.Cells[0,InstanceIndex]);
            // data set 4b
            AStringGrid:= dg3dRCHParameterClusters.Grids[PageIndex];
            WriteCluster;
            Inc(PageIndex);
          end;
        end
        else
        begin
            // data set 4b
            AStringGrid:= dg3dRCHParameterClusters.Grids[PageIndex];
            WriteCluster;
            Inc(PageIndex);

        end;
        frmProgress.pbPackage.StepIt;
      end;
    end;
    if ZoneErrors.Count <> 0 then
    begin
      AString := 'Error: Some parameters in the Recharge package '
        + 'did not have zones defined correctly.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'No zones were defined for the following parameters.';
      ErrorMessages.Add(AString);

      ErrorMessages.AddStrings(ZoneErrors);
    end;
  finally
    ZoneErrors.Free;
  end;
end;

procedure TRechargeWriter.WritePname(const StressPeriodIndex : integer);
var
  ColIndex : integer;
  ParamIndex : integer;
  PName : string;
  NUMINST : integer;
begin
  with frmMODFLOW do
  begin
    ColIndex := StressPeriodIndex+4;
    for ParamIndex := 1 to dgRCHParametersN.RowCount -1 do
    begin
      if dgRCHParametersN.Cells[ColIndex,ParamIndex] <>
        dgRCHParametersN.Columns[ColIndex].Picklist[0] then
      begin
        PName := dgRCHParametersN.Cells[0,ParamIndex];
        NUMINST := StrToInt(dgRCHParametersN.Cells[4,ParamIndex]);
        if NUMINST > 1 then
        begin
          Writeln(FFile, PName, ' ',
            dgRCHParametersN.Cells[ColIndex,ParamIndex], ' ', IPRN_Real);
        end
        else
        begin
          Writeln(FFile, PName, ' ', IPRN_Real);
        end;
      end;
    end;
  end;
end;

procedure TRechargeWriter.WriteDataSets5to8(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter);
var
  StressPeriodIndex : integer;
  INRECH, INIRCH : integer;
begin
  for StressPeriodIndex := 1 to frmMODFLOW.dgTime.RowCount -1 do
  begin
//    ParamNames.Clear;
    WriteDataSet5(StressPeriodIndex, INRECH, INIRCH);
    if (NPRCH = 0) and (INRECH >= 0) then
    begin
      WriteRECHArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    if (NPRCH > 0) and (INRECH >= 0) then
    begin
      WritePname(StressPeriodIndex);
    end;
    if (NRCHOP = 2) and (INIRCH >= 0) then
    begin
      WriteIRCHArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    frmProgress.pbPackage.StepIt;
  end;

end;

class procedure TRechargeWriter.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowRCH.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('RCHBUD');
      end;
    end;
  end;
end;

end.
