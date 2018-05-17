unit WriteETSUnit;

interface

uses Sysutils, Classes, Grids, Forms, ANEPIE, WriteModflowDiscretization;

type
  TEtsWriter = class(TModflowWriter)
  private
    NETSOP : integer;
    NPETS : integer;
    NETSEG : integer;
    ETSX : array of array of double;
    PXDP, PETM : array of array of double;
    procedure WriteDataSet1;
    procedure WriteDataSets2and3(Discretization: TDiscretizationWriter);
    procedure WriteDataSet4(StressPeriod: integer;
      var INETSS, INETSR, INETSX,INIETS, INSGDF : integer);
    procedure WriteDataSets4to11(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter);
    procedure WriteETSSArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod : integer;
      BasicPackage :TBasicPkgWriter);
    procedure WritePname(const StressPeriod : integer);
    procedure WriteIETSArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
    procedure WriteETSRArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
    procedure WriteETSXArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; StressPeriod: integer;
      BasicPackage :TBasicPkgWriter);
    procedure WritePXDPArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; SegmentIndex: integer;
      BasicPackage: TBasicPkgWriter);
    procedure WritePETMArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; SegmentIndex: integer;
      BasicPackage: TBasicPkgWriter);
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

{ TEtsWriter }

procedure TEtsWriter.WriteETSSArray(const CurrentModelHandle: ANE_PTR;
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
      ParameterName := ModflowTypes.GetGridETS_SurfaceParamType.WriteParamName;
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

procedure TEtsWriter.WriteETSXArray(const CurrentModelHandle: ANE_PTR;
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
  setLength(ETSX, Discretization.NROW, Discretization.NCOL);

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ParameterName := ModflowTypes.GetGridETS_ExtinctDepthParamType.WriteParamName;
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

              ETSX[RowIndex, ColIndex] := AValue;
              Write(FFile, AValue, ' ');

            finally
              ABlock.Free;
            end;
          end
          else
          begin
            ETSX[RowIndex, ColIndex] := 0;
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

procedure TEtsWriter.WriteETSRArray(const CurrentModelHandle: ANE_PTR;
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
//  ParameterIndex : ANE_INT16;

begin


  frmProgress.lblActivity.Caption := 'writing Evapotranspiration flux';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

  Project := TProjectOptions.Create;
  try
    EvapLayerHandle := Project.GetLayerByName(CurrentModelHandle,
      ModflowTypes.GetMFSegmentedETLayerType.WriteNewRoot);

  finally
    Project.Free;
  end;

  if EvapLayerHandle <> nil then
  begin
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      ParameterName := ModflowTypes.GetSegET_MaxFluxParamType.WriteParamName
        + IntToStr(StressPeriod);

      Expression := ModflowTypes.GetMFSegmentedETLayerType.WriteNewRoot
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

procedure TEtsWriter.WriteIETSArray(const CurrentModelHandle: ANE_PTR;
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
      if frmMODFLOW.cbETSLayer.Checked
        and (frmMODFLOW.comboEtsOption.ItemIndex = 1) then
      begin
        ParameterName := ModflowTypes.GetGridETS_LayerParamType.WriteParamName;
      end
      else
      begin
        ParameterName := ModflowTypes.GetGridETS_SurfaceParamType.WriteParamName;
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
              if frmMODFLOW.cbETSLayer.Checked
                and (frmMODFLOW.comboEtsOption.ItemIndex = 1) then
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
                    end; }
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
      AString := 'Warning: Some ETS surfaces lie above the top of the model.';
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
      AString := 'Warning: Some ETS surfaces lie below the bottom of the model.';
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
      AString := 'Warning: Some ETS surfaces lie in non-simulated geologic units.';
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

procedure TEtsWriter.WritePXDPArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; SegmentIndex : integer;
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
  ProportionsLessThanZero, ProportionsGreaterThanOne : TStringList;
  ZeroExtinctionDepth, DecliningProportion : TStringList;
  AString : string;
begin

  ProportionsLessThanZero := TStringList.Create;
  ProportionsGreaterThanOne := TStringList.Create;
  ZeroExtinctionDepth := TStringList.Create;
  DecliningProportion := TStringList.Create;
  try

    frmProgress.lblActivity.Caption := 'writing ETS extinction depth proportion ';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
    if ShowWarnings and (SegmentIndex = 1) then
    begin
      SetLength(PXDP,Discretization.NROW, Discretization.NCOL);
    end;

    Project := TProjectOptions.Create;
    try
      EvapLayerHandle := Project.GetLayerByName(CurrentModelHandle,
        ModflowTypes.GetMFSegmentedETLayerType.WriteNewRoot);

    finally
      Project.Free;
    end;

    if EvapLayerHandle <> nil then
    begin
      GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
      try
        ParameterName := ModflowTypes.GetSegET_IntermediateDepthParamType.WriteParamName
          + IntToStr(SegmentIndex);

        Expression := ModflowTypes.GetMFSegmentedETLayerType.WriteNewRoot
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

                if ETSX[RowIndex,ColIndex] = 0 then
                begin
                  AValue := 0;
                  if ShowWarnings and (SegmentIndex = 1) then
                  begin
                      ZeroExtinctionDepth.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                end
                else
                begin
                  AValue := AValue/ETSX[RowIndex,ColIndex];
                  if ShowWarnings and (SegmentIndex > 1) then
                  begin
                    If AValue < PXDP[RowIndex,ColIndex] then
                    begin
                      DecliningProportion.Add(Format('[%d, %d, %d]', [ColIndex+1,RowIndex+1, SegmentIndex]));
                    end;
                    PXDP[RowIndex,ColIndex] := AValue;
                  end;
                end;

                if AValue < 0 then
                begin
                  AValue := 0;
                  if ShowWarnings then
                  begin
                    ProportionsLessThanZero.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                end;
                if AValue > 1 then
                begin
                  AValue := 1;
                  if ShowWarnings then
                  begin
                    ProportionsGreaterThanOne.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
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
    if ProportionsLessThanZero.Count > 0 then
    begin
      AString := 'Warning: Some ETS extinction depth proportions are less than 0.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They have been changed to 0.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ProportionsLessThanZero);
    end;
    if ProportionsGreaterThanOne.Count > 0 then
    begin
      AString := 'Warning: Some ETS extinction depth proportions are greater than 1.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They have been changed to 1.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ProportionsGreaterThanOne);
    end;
    if ZeroExtinctionDepth.Count > 0 then
    begin
      AString := 'Warning: Some ETS extinction depths = 0.0';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ZeroExtinctionDepth);
    end;
    if DecliningProportion.Count > 0 then
    begin
      AString := 'Warning: Some ETS intermediate depths are less than previous depths';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row, Intermediate Depth number]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(DecliningProportion);
    end;
  finally
    ProportionsLessThanZero.Free;
    ProportionsGreaterThanOne.Free;
    ZeroExtinctionDepth.Free;
    DecliningProportion.Free;
  end;

end;

procedure TEtsWriter.WritePETMArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; SegmentIndex : integer;
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
  ProportionsLessThanZero, ProportionsGreaterThanOne : TStringList;
  IncreasingProportion : TStringList;
  AString : string;
begin

  ProportionsLessThanZero := TStringList.Create;
  ProportionsGreaterThanOne := TStringList.Create;
  IncreasingProportion := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'writing ETS flux proportion ';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
    if ShowWarnings and (SegmentIndex = 1) then
    begin
      SetLength(PETM,Discretization.NROW, Discretization.NCOL);
    end;

    Project := TProjectOptions.Create;
    try
      EvapLayerHandle := Project.GetLayerByName(CurrentModelHandle,
        ModflowTypes.GetMFSegmentedETLayerType.WriteNewRoot);

    finally
      Project.Free;
    end;

    if EvapLayerHandle <> nil then
    begin
      GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
      try
        ParameterName := ModflowTypes.GetSegET_IntermediateProportionParamType.WriteParamName
          + IntToStr(SegmentIndex);

        Expression := ModflowTypes.GetMFSegmentedETLayerType.WriteNewRoot
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

                if AValue < 0 then
                begin
                  AValue := 0;
                  if ShowWarnings then
                  begin
                    ProportionsLessThanZero.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                end;
                if AValue > 1 then
                begin
                  AValue := 1;
                  if ShowWarnings then
                  begin
                    ProportionsGreaterThanOne.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                  end;
                  if ShowWarnings and (SegmentIndex > 1) then
                  begin
                    If AValue > ETSX[RowIndex,ColIndex] then
                    begin
                      IncreasingProportion.Add(Format('[%d, %d, %d]', [ColIndex+1,RowIndex+1, SegmentIndex]));
                    end;
                    ETSX[RowIndex,ColIndex] := AValue
                  end;
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
    if ProportionsLessThanZero.Count > 0 then
    begin
      AString := 'Warning: Some ETS extinction flow proportions are less than 0.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They have been changed to 0.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ProportionsLessThanZero);
    end;
    if ProportionsGreaterThanOne.Count > 0 then
    begin
      AString := 'Warning: Some ETS extinction flow proportions are greater than 1.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'They have been changed to 1.0.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ProportionsGreaterThanOne);
    end;
    if IncreasingProportion.Count > 0 then
    begin
      AString := 'Warning: Some ETS intermediate flux fractions are greater than previous flux fractions';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := AString + ' [Col, Row, Intermediate Flux Fractions number]';
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(IncreasingProportion);
    end;
  finally
    ProportionsLessThanZero.Free;
    ProportionsGreaterThanOne.Free;
    IncreasingProportion.Free;
  end;
end;

procedure TEtsWriter.WriteDataSet1;
var
  IETSCB : integer;
//  ITOP : integer;
begin
  with frmModflow do
  begin
    NETSOP:= comboEtsOption.ItemIndex + 1;
    NPETS := dgETSParametersN.RowCount -1;;
    NETSEG := StrToInt(adeIntElev.Text) + 1;
    if cbFlowETS.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        IETSCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        IETSCB := frmModflow.GetUnitNumber('ETSBUD');
      end;
    end
    else
    begin
        IETSCB := 0;
    end;

    Write(FFile, NETSOP, ' ', IETSCB, ' ', NPETS, ' ', NETSEG);
{    if cbMODPATH.Checked then
    begin
      ITOP := comboMODPATH_EvapITOP.ItemIndex;
      Write(FFile, ' ', ITOP);
    end; }
    Writeln(FFile);
  end;
end;

procedure TEtsWriter.WriteDataSet4(StressPeriod : integer;
  var INETSS, INETSR, INETSX,INIETS, INSGDF : integer);
var
  ParamIndex : integer;
  ColIndex : integer;
begin
  with frmMODFLOW do
  begin
    if StressPeriod = 1 then
    begin
      INETSS := 1;
      INETSX := 1;
    end
    else
    begin
      INETSS := -1;
      INETSX := -1;
    end;
    if NPETS = 0 then
    begin
      If (StressPeriod = 1) or (comboEtsSteady.ItemIndex = 1) then
      begin
        INETSR:=  1;
      end
      else
      begin
        INETSR:=  -1;
      end;
    end
    else
    begin
      INETSR := 0;
      ColIndex := StressPeriod+4;
      for ParamIndex := 1 to dgETSParametersN.RowCount -1 do
      begin
        if dgETSParametersN.Cells[ColIndex,ParamIndex] <>
          dgETSParametersN.Columns[ColIndex].Picklist[0] then
        begin
          Inc(INETSR);
//          ParamNames.Add(dgETSParameters.Cells[0,ParamIndex]);
        end;
      end;

    end;

    IF ((NETSOP = 2) or (NETSEG > 1)) and (StressPeriod = 1) THEN
    begin
      INIETS := 1;
    end
    else
    begin
      INIETS := -1;
    end;

    if (NETSEG > 1) and (StressPeriod = 1) then
    begin
      INSGDF := 1;
    end
    else
    begin
      INSGDF := -1;
    end;

    Writeln(FFile, INETSS, ' ', INETSR, ' ', INETSX, ' ', INIETS, ' ', INSGDF);
  end;
end;

procedure TEtsWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter;
  BasicPackage :TBasicPkgWriter);
var
  FileName : String;
begin

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Evapotranspiration Segments';

    FileName := GetCurrentDir + '\' + Root + rsETS;
    AssignFile(FFile,FileName);
    try
//      ParamNames := TStringList.Create;
//      try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;
//      WriteDataSet2;
      WriteDataSets2and3(Discretization);
      WriteDataSets4to11(CurrentModelHandle, Discretization, BasicPackage);
{      finally
        ParamNames.Free;
      end;}
      Flush(FFile);
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;


procedure TEtsWriter.WriteDataSets2and3(Discretization: TDiscretizationWriter);
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
        ZoneErrors.Add(frmModflow.dgETSParametersN.Cells[0,ParameterIndex]);
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
      for ParameterIndex := 1 to dgETSParametersN.RowCount -1 do
      begin
        // data set 2
        PARTYPE := 'ETS';
        NCLU := StrToInt(dgETSParametersN.Cells[3,ParameterIndex]);
        Parval := InternationalStrToFloat(dgETSParametersN.Cells[2,ParameterIndex]);
        NUMINST := StrToInt(dgETSParametersN.Cells[4,ParameterIndex]);
        Write(FFile,
          dgETSParametersN.Cells[0,ParameterIndex], ' ',
          PARTYPE, ' ',
          FreeFormattedReal(Parval),
          NCLU);
        if NUMINST > 1 then
        begin
          Write(FFile, ' INSTANCES ', NUMINST);
        end;
        Writeln(FFile);

        // data set 3
        if NUMINST > 1 then
        begin
          InstanceGrid := sg3dETSParamInstances.Grids[ParameterIndex-1];
          for InstanceIndex := 1 to InstanceGrid.RowCount -1 do
          begin
            // data set 3a
            Writeln(FFile, InstanceGrid.Cells[0,InstanceIndex]);
            // data set 3b
            AStringGrid:= dg3dETSParameterClusters.Grids[PageIndex];
            WriteCluster;
            Inc(PageIndex);
          end;
        end
        else
        begin
            // data set 3b
            AStringGrid:= dg3dETSParameterClusters.Grids[PageIndex];
            WriteCluster;
            Inc(PageIndex);
        end;
  {      AStringGrid:= dg3dETSParameterClusters.Grids[ParameterIndex-1];
        WriteCluster;}
      end;

    end;
    if ZoneErrors.Count <> 0 then
    begin
      AString := 'Error: Some parameters in the Evapotranspiration Segments package '
        + 'did not have zones defined correctly.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'No zones were defined for the following parameters.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add(AString);

      ErrorMessages.AddStrings(ZoneErrors);
    end;
  finally
    ZoneErrors.Free;
  end;
end;

procedure TEtsWriter.WritePname(const StressPeriod : integer);
var
  ColIndex : integer;
  ParamIndex : integer;
  PName : string;
  NUMINST : integer;
begin
  with frmMODFLOW do
  begin
      ColIndex := StressPeriod+4;
      for ParamIndex := 1 to dgETSParametersN.RowCount -1 do
      begin
        if dgETSParametersN.Cells[ColIndex,ParamIndex] <>
          dgETSParametersN.Columns[ColIndex].Picklist[0] then
        begin
          PName := dgETSParametersN.Cells[0,ParamIndex];
          NUMINST := StrToInt(dgETSParametersN.Cells[4,ParamIndex]);
          if NUMINST > 1 then
          begin
            Writeln(FFile, PName, ' ',
              dgETSParametersN.Cells[ColIndex,ParamIndex], ' ', IPRN_Real);
          end
          else
          begin
            Writeln(FFile, PName, ' ', IPRN_Real);
          end;
        end;
      end;
  end;
end;

procedure TEtsWriter.WriteDataSets4to11(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter;
  BasicPackage :TBasicPkgWriter);
var
  StressPeriodIndex : integer;
  INETSS, INETSR, INETSX,INIETS, INSGDF : integer;
  SegmentIndex : integer;
begin
  for StressPeriodIndex := 1 to frmMODFLOW.dgTime.RowCount -1 do
  begin
//    ParamNames.Clear;
    WriteDataSet4(StressPeriodIndex, INETSS, INETSR, INETSX, INIETS, INSGDF);
    if (INETSS >= 0) then
    begin
    // data set 5
        WriteETSSArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    if (NPETS = 0) and (INETSR >= 0) then
    begin
    // data set 6
      WriteETSRArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    if (NPETS > 0) and (INETSR > 0) then
    begin
    // data set 7
      WritePname(StressPeriodIndex);
    end;
    if (INETSX >= 0) then
    begin
    // data set 8
      WriteETSXArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    if (NETSOP = 2) and (INIETS >= 0) then
    begin
    // data set 9
      WriteIETSArray(CurrentModelHandle, Discretization, StressPeriodIndex,
        BasicPackage);
    end;
    if (NETSEG > 1) and (INSGDF >= 0) then
    begin
      for SegmentIndex := 1 to NETSEG -1 do
      begin
    // data set 10
        WritePXDPArray(CurrentModelHandle, Discretization, SegmentIndex,
          BasicPackage);
    // data set 11
        WritePETMArray(CurrentModelHandle, Discretization, SegmentIndex,
          BasicPackage);
      end;
    end;

  end;

end;

class procedure TEtsWriter.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowETS.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('ETSBUD');
      end;
    end;
  end;
end;

end.
