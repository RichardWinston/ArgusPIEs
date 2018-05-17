unit WriteEvapUnit;

interface

uses Sysutils, Classes, Grids, Forms, ANEPIE, WriteModflowDiscretization;

type
  TEvapWriter = class(TModflowWriter)
  private
    NEVTOP : integer;
    NPEVT : integer;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3and4(Discretization: TDiscretizationWriter);
    procedure WriteDataSet5(StressPeriod: integer;
      var INSURF, INEVTR, INEXDP,INIEVT : integer);
    procedure WriteDataSets5to10(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter);
    procedure WriteSURFArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod : integer;
      BasicPackage :TBasicPkgWriter);
    procedure WritePname(const StressPeriod : integer);
    procedure WriteIEVTArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
    procedure WriteEVTRArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
    procedure WriteEXDPArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
  public
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter);
    class procedure AssignUnitNumbers;
  end;

implementation

uses Variables, ModflowUnit, OptionsUnit, ProgressUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

{ TEvapWriter }

procedure TEvapWriter.WriteSURFArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; StressPeriod : integer;
  BasicPackage :TBasicPkgWriter);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ParameterIndex : ANE_INT16;

begin


  frmProgress.lblActivity.Caption := 'writing Evapotranspiration surface';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ParameterName := ModflowTypes.GetMFGridETSurfParamType.WriteParamName;
      ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

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
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try

              AValue := ABlock.GetFloatParameter(CurrentModelHandle,ParameterIndex);
              if Abs(AValue) < MinSingle then
              begin
                AValue := 0.0;
              end;

              Write(FFile, AValue, ' ');

            finally
              ABlock.Free;
            end;
          end
          else
          begin
            Write(FFile, 0.0, ' ');
          end;
          frmProgress.pbActivity.StepIt;
        end;

        WriteLn(FFile);
      end;

    finally
      GridLayer.Free(CurrentModelHandle);
    end;
end;

procedure TEvapWriter.WriteEXDPArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; StressPeriod : integer;
  BasicPackage :TBasicPkgWriter);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ParameterIndex : ANE_INT16;

begin


  frmProgress.lblActivity.Caption := 'writing Evapotranspiration extinction depth';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ParameterName := ModflowTypes.GetMFGridETExtinctionDepthParamType.WriteParamName;
      ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

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
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try
              AValue := ABlock.GetFloatParameter(CurrentModelHandle,ParameterIndex);
              if Abs(AValue) < MinSingle then
              begin
                AValue := 0.0;
              end;

              Write(FFile, AValue, ' ');

            finally
              ABlock.Free;
            end;
          end
          else
          begin
            Write(FFile, 0.0, ' ');
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
end;

procedure TEvapWriter.WriteEVTRArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; StressPeriod : integer;
  BasicPackage :TBasicPkgWriter);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  EvapLayerHandle : ANE_PTR;
  Project : TProjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
begin
  frmProgress.lblActivity.Caption := 'writing Evapotranspiration flux';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

  Project := TProjectOptions.Create;
  try
    EvapLayerHandle := Project.GetLayerByName(CurrentModelHandle,
      ModflowTypes.GetETLayerType.WriteNewRoot);

  finally
    Project.Free;
  end;

  if EvapLayerHandle <> nil then
  begin
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ParameterName := ModflowTypes.GetMFETExtFluxParamType.WriteParamName
        + IntToStr(StressPeriod);

      Expression := ModflowTypes.GetETLayerType.WriteNewRoot
        + '.' + ParameterName;
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
              Write(FFile, AValue, ' ');

            finally
              ABlock.Free;
            end;
          end
          else
          begin
            Write(FFile, 0.0, ' ');
          end;
          frmProgress.pbActivity.StepIt;
        end;

        WriteLn(FFile);
      end;

    finally
      GridLayer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TEvapWriter.WriteIEVTArray(const CurrentModelHandle: ANE_PTR;
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


    frmProgress.lblActivity.Caption := 'writing Evapotranspiration layer';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      if frmMODFLOW.cbETLayer.Checked
        and (frmMODFLOW.comboEvtOption.ItemIndex = 1) then
      begin
        ParameterName := ModflowTypes.GetMFGridETLayerParamType.WriteParamName;
      end
      else
      begin
        ParameterName := ModflowTypes.GetMFGridETSurfParamType.WriteParamName;
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
              if frmMODFLOW.cbETLayer.Checked
                and (frmMODFLOW.comboEvtOption.ItemIndex = 1) then
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
                    (AValue >= Discretization.Elevations[ColIndex,RowIndex,0]) then
                  begin
                    ElevationsAboveModel.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                end
                else if AValue <= Discretization.Elevations
                  [ColIndex,RowIndex,Discretization.NUNITS-1] then
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
                          NonSimulatedElevations.Add(Format('[%d, %d, %d]', [ColIndex+1,RowIndex+1, UnitIndex]));
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
{                    if AValue = Bottom then
                    begin
                      break;
                    end;}
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
      AString := 'Warning: Some evapotranspiration surfaces lie above the top of the model.';
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
      AString := 'Warning: Some evapotranspiration surfaces lie below the bottom of the model.';
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
      AString := 'Warning: Some evapotranspiration surfaces lie in non-simulated geologic units.';
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

procedure TEvapWriter.WriteDataSet1;
begin
  NPEVT := frmModflow.dgEVTParametersN.RowCount -1;

  if NPEVT > 0 then
  begin
    Writeln(FFile, 'PARAMETER', ' ', NPEVT);
  end
end;

procedure TEvapWriter.WriteDataSet2;
var
  IEVTCB : integer;
  ITOP : integer;
begin
  with frmModflow do
  begin
    NEVTOP:= comboEvtOption.ItemIndex + 1;
    if cbFlowEVT.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        IEVTCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        IEVTCB := frmModflow.GetUnitNumber('EVTBUD');
      end;
    end
    else
    begin
        IEVTCB := 0;
    end;

    Write(FFile, NEVTOP, ' ', IEVTCB);
    if cbMODPATH.Checked then
    begin
      ITOP := comboMODPATH_EvapITOP.ItemIndex;
      Write(FFile, ' ', ITOP);
    end;
    Writeln(FFile);
  end;
end;

procedure TEvapWriter.WriteDataSet5(StressPeriod : integer;
  var INSURF, INEVTR, INEXDP,INIEVT : integer);
var
  ParamIndex : integer;
  ColIndex : integer;
begin
  with frmMODFLOW do
  begin
    if StressPeriod = 1 then
    begin
      INSURF := 1;
      INEXDP := 1;
    end
    else
    begin
      INSURF := -1;
      INEXDP := -1;
    end;
    if NPEVT = 0 then
    begin
      If (StressPeriod = 1) or (comboEvtSteady.ItemIndex = 1) then
      begin
        INEVTR:=  1;
      end
      else
      begin
        INEVTR:=  -1;
      end;
    end
    else
    begin
      INEVTR := 0;
      ColIndex := StressPeriod+4;
      for ParamIndex := 1 to dgEVTParametersN.RowCount -1 do
      begin
        if dgEVTParametersN.Cells[ColIndex,ParamIndex] <>
          dgEVTParametersN.Columns[ColIndex].Picklist[0] then
        begin
          Inc(INEVTR);
//          ParamNames.Add(dgEVTParameters.Cells[0,ParamIndex]);
        end;
      end;

    end;

    IF (NEVTOP = 2) and (StressPeriod = 1) THEN
    begin
      INIEVT := 1;
    end
    else
    begin
      INIEVT := -1;
    end;

    Writeln(FFile, INSURF, ' ', INEVTR, ' ', INEXDP, ' ', INIEVT);
  end;
end;

procedure TEvapWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter;
  BasicPackage :TBasicPkgWriter);
var
  FileName : String;
begin

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Evapotranspiration';

    FileName := GetCurrentDir + '\' + Root + rsEVT;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;
      WriteDataSet2;
      WriteDataSets3and4(Discretization);
      WriteDataSets5to10(CurrentModelHandle, Discretization, BasicPackage);
      Flush(FFile);
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;


procedure TEvapWriter.WriteDataSets3and4(Discretization: TDiscretizationWriter);
var
  ParameterIndex, InstanceIndex : integer;
  AStringGrid, InstanceGrid : TStringGrid;
  PARTYPE : STRING;
  NCLU : integer;
  Zone : integer;
  ZoneString : string;
  Parval : double;
  NUMINST : integer;
  PageIndex : integer;
  ZoneErrors : TStringList;
  AString : string;
  procedure WriteCluster;
  var
    ClusterIndex, ZoneIndex: integer;
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
        ZoneErrors.Add(frmModflow.dgEVTParametersN.Cells[0,ParameterIndex]);
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
      for ParameterIndex := 1 to dgEVTParametersN.RowCount -1 do
      begin
        // data set 3
        PARTYPE := 'EVT';
        NCLU := StrToInt(dgEVTParametersN.Cells[3,ParameterIndex]);
        Parval := InternationalStrToFloat(dgEVTParametersN.Cells[2,ParameterIndex]);
        NUMINST := StrToInt(dgEVTParametersN.Cells[4,ParameterIndex]);
        Write(FFile,
          dgEVTParametersN.Cells[0,ParameterIndex], ' ',
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
          InstanceGrid := sg3dEVTParamInstances.Grids[ParameterIndex-1];
          for InstanceIndex := 1 to InstanceGrid.RowCount -1 do
          begin
            // data set 4a
            Writeln(FFile, InstanceGrid.Cells[0,InstanceIndex]);
            // data set 4b
            AStringGrid:= dg3dEVTParameterClusters.Grids[PageIndex];
            WriteCluster;
            Inc(PageIndex);
          end;
        end
        else
        begin
            // data set 4b
            AStringGrid:= dg3dEVTParameterClusters.Grids[PageIndex];
            WriteCluster;
            Inc(PageIndex);
        end;
      end;
    end;
    if ZoneErrors.Count <> 0 then
    begin
      AString := 'Error: Some parameters in the Evapotranspiration package '
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

procedure TEvapWriter.WritePname(const StressPeriod : integer);
var
  ColIndex : integer;
  ParamIndex : integer;
  PName : string;
  NUMINST : integer;
begin
  with frmMODFLOW do
  begin
      ColIndex := StressPeriod+4;
      for ParamIndex := 1 to dgEVTParametersN.RowCount -1 do
      begin
        if dgEVTParametersN.Cells[ColIndex,ParamIndex] <>
          dgEVTParametersN.Columns[ColIndex].Picklist[0] then
        begin
          PName := dgEVTParametersN.Cells[0,ParamIndex];
          NUMINST := StrToInt(dgEVTParametersN.Cells[4,ParamIndex]);
          if NUMINST > 1 then
          begin
            Writeln(FFile, PName, ' ',
              dgEVTParametersN.Cells[ColIndex,ParamIndex], ' ', IPRN_Real);
          end
          else
          begin
            Writeln(FFile, PName, ' 0');
          end;

        end;
      end;
  end;
end;

procedure TEvapWriter.WriteDataSets5to10(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter;
  BasicPackage :TBasicPkgWriter);
var
  StressPeriodIndex : integer;
  INSURF, INEVTR, INEXDP,INIEVT : integer;
begin
  for StressPeriodIndex := 1 to frmMODFLOW.dgTime.RowCount -1 do
  begin
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := frmMODFLOW.dgTime.RowCount *5;
    WriteDataSet5(StressPeriodIndex, INSURF, INEVTR, INEXDP,INIEVT);
    if (INSURF >= 0) then
    begin
      // data set 6
      WriteSURFArray(CurrentModelHandle, Discretization, StressPeriodIndex,
      BasicPackage);
    end;
    frmProgress.pbPackage.StepIt;
    if (NPEVT = 0) and (INEVTR >= 0) then
    begin
      // data set 7
      WriteEVTRArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    frmProgress.pbPackage.StepIt;
    if (NPEVT > 0) and (INEVTR >= 0) then
    begin
      // data set 8
      WritePname(StressPeriodIndex);
    end;
    frmProgress.pbPackage.StepIt;
    if (INEXDP >= 0) then
    begin
      // data set 9
      WriteEXDPArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    frmProgress.pbPackage.StepIt;
    if (NEVTOP = 2) and (INIEVT >= 0) then
    begin
      // data set 10
      WriteIEVTArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    frmProgress.pbPackage.StepIt;
  end;

end;

class procedure TEvapWriter.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowEVT.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('EVTBUD');
      end;
    end;
  end;
end;

end.
