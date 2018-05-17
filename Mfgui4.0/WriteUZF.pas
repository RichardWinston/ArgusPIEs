unit WriteUZF;

interface

uses SysUtils, Forms, ANEPIE, IntListUnit, WriteModflowDiscretization,
  WriteLakesUnit, WriteStreamUnit;

type
  TUzfWriter = class(TModflowWriter)
  private
    FModelHandle: ANE_PTR;
    FDiscretization : TDiscretizationWriter;
    FBasicPackage :TBasicPkgWriter;
    FLakePackage: TLakeWriter;
    FSfrWriter: TStreamWriter;
    IRUNFLG: integer;
    IUZFOPT: integer;
    procedure WriteIUZFBND;
    procedure WriteIRUNBND;
    procedure WriteVKS;
    procedure WriteEPS;
    procedure WriteTHTS;
    procedure WriteTHTI;
    procedure EvaluateGages; overload;
    procedure WriteGages;
    procedure WriteFINF(StressPeriod: integer);
    procedure WritePET(StressPeriod: integer);
    procedure WriteEXTDP;
    procedure WriteEXTWC;
    procedure WriteDataSet1;
    function ProgressMax: integer;
    procedure WriteDataSets9To16;
  public
    GageColumnNumbers: TIntegerList;
    GageRowNumbers: TIntegerList;
    GageOutputTypes: TIntegerList;
    FirstGageUnitNumber: integer;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter;
      LakePackage: TLakeWriter; SfrWriter: TStreamWriter);
    Constructor Create;
    Destructor Destroy; override;
    procedure EvaluateGages(Discretization : TDiscretizationWriter;
      BasicPackage :TBasicPkgWriter; LakePackage: TLakeWriter;
      SfrWriter: TStreamWriter); overload;
  end;

implementation

uses UtilityFunctions, Variables, OptionsUnit, ProgressUnit, WriteNameFileUnit;

{ TUzfWriter }

procedure TUzfWriter.WriteIUZFBND;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_INT32;
  ParameterIndex : ANE_INT16;
begin
  frmProgress.lblActivity.Caption := 'writing UZF IUZFBND';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfModflowLayerParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DINTHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try
            AValue := ABlock.GetIntegerParameter(FModelHandle,ParameterIndex);
            if (AValue <= 0) or (AValue > FDiscretization.NLAY) then
            begin
              AValue := 0;
            end
            else
            begin
              if FBasicPackage.MFIBOUND[ColIndex, RowIndex, AValue-1] <= 0  then
              begin
                AValue := 0;
              end;
            end;
            Write(FFile, AValue, ' ');
          finally
            ABlock.Free;
          end;
        end
        else
        begin
          Write(FFile, 0, ' ');
        end;
        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
  finally
    GridLayer.Free(FModelHandle);
  end;
end;

function TUzfWriter.ProgressMax: integer;
begin
  // IUZFBND, EPS, THTS, Gages
  result := 4;

  // IRUNBND
  if frmModflow.cbUzfIRUNFLG.Checked and
    (frmModflow.cbLAK.Checked or frmModflow.cbSFR.Checked) then
  begin
    result := result + 1;
  end;

  // VKS
  if not frmModflow.cbUzfIUZFOPT.Checked then
  begin
    result := result + 1;
  end;

  // THTI
  if not frmModflow.IsSteady(1) then
  begin
    result := result + 1;
  end;

  // FINF
  if frmModflow.comboUzfTransient.ItemIndex = 0 then
  begin
    result := result + 1;
  end
  else
  begin
    result := result + (frmModflow.dgTime.RowCount -1);
  end;

  // PET
  if frmModflow.cbUzfIETFLG.Checked then
  begin
    if frmModflow.comboUzfTransient.ItemIndex = 0 then
    begin
      result := result + 1;
    end
    else
    begin
      result := result + (frmModflow.dgTime.RowCount -1);
    end;
  end;

  // EXTDP, EXTWC
  if frmModflow.cbUzfIETFLG.Checked then
  begin
    result := result + 2;
  end;
end;

procedure TUzfWriter.WriteDataSets9To16;
var
  StressPeriod: integer;
  TransientStress: boolean;
begin
  TransientStress := frmModflow.comboUzfTransient.ItemIndex = 1;
  for StressPeriod := 1 to FDiscretization.NPER do
  begin
    // data sets 9 and 10
    if TransientStress or (StressPeriod = 1) then
    begin
      // data set 9
      Writeln(FFile, 1);
      // data set 10
      WriteFINF(StressPeriod);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;
    end
    else
    begin
      // data set 9
      Writeln(FFile, -1);
    end;

    if frmModflow.cbUzfIETFLG.Checked then
    begin
      // data sets 11 and 12
      if TransientStress or (StressPeriod = 1) then
      begin
        // data set 11
        Writeln(FFile, 1);
        // data set 12
        WritePET(StressPeriod);
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then Exit;
      end
      else
      begin
        // data set 11
        Writeln(FFile, -1);
      end;

      // data sets 13 and 14
      if (StressPeriod = 1) then
      begin
        // data set 13
        Writeln(FFile, 1);
        // data set 14
        WriteEXTDP;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then Exit;
      end
      else
      begin
        // data set 13
        Writeln(FFile, -1);
      end;

      // data sets 15 and 16
      if (StressPeriod = 1) then
      begin
        // data set 15
        Writeln(FFile, 1);
        // data set 16
        WriteEXTWC;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then Exit;
      end
      else
      begin
        // data set 15
        Writeln(FFile, -1);
      end;
    end;


  end;

end;

procedure TUzfWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter;
  BasicPackage: TBasicPkgWriter; LakePackage: TLakeWriter;
  SfrWriter: TStreamWriter);
var
  FileName : String;
begin
  FModelHandle := CurrentModelHandle;
  FDiscretization := Discretization;
  FBasicPackage := BasicPackage;
  FLakePackage := LakePackage;
  FSfrWriter := SfrWriter;

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Unsaturated Zone Flow';
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := ProgressMax;

    EvaluateGages;

    FileName := GetCurrentDir + '\' + Root + rsUZF;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;

      // data set 2
      WriteIUZFBND;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      // data set 3
      if IRUNFLG > 0 then
      begin
        WriteIRUNBND;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then Exit;
      end;

      // data set 4
      if IUZFOPT = 1 then
      begin
        WriteVKS;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then Exit;
      end;

      // data set 5
      WriteEPS;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      // data set 6
      WriteTHTS;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      // data set 7
      if not frmModflow.IsSteady(1) then
      begin
        WriteTHTI;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then Exit;
      end;

      // data set 8
      WriteGages;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      WriteDataSets9To16;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      Flush(FFile);
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;

end;

procedure TUzfWriter.WriteIRUNBND;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_INT32;
  ParameterIndex : ANE_INT16;
  StreamError: boolean;
  LakeError: boolean;
  InvalidSegments: TIntegerList;
  InvalidLakes: TIntegerList;
  SegmentNumber: integer;
  LakeNumber: integer;
  ErrorMessage: string;
  Index: integer;
begin
  frmProgress.lblActivity.Caption := 'writing UZF IUZFBND';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;
  StreamError := False;
  LakeError := False;

  InvalidSegments := TIntegerList.Create;
  InvalidLakes := TIntegerList.Create;
  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfDownstreamStreamOrLakeParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DINTHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try
            AValue := ABlock.GetIntegerParameter(FModelHandle,ParameterIndex);
          finally
            ABlock.Free;
          end;

          if AValue > 0 then
          begin
            if FSfrWriter = nil then
            begin
              StreamError := True;
              AValue := 0;
            end
            else
            begin
              SegmentNumber := FSfrWriter.ConvertSegmentNumber(AValue);
              if SegmentNumber <= 0 then
              begin
                if InvalidSegments.IndexOf(AValue) < 0 then
                begin
                  InvalidSegments.Add(AValue);
                end;
//                AValue := SegmentNumber;
              end
              else
              begin
                AValue := SegmentNumber;
              end;
            end;
          end
          else if AValue < 0 then
          begin
            if FLakePackage = nil then
            begin
              LakeError := True;
              AValue := 0;
            end
            else
            begin
              LakeNumber := FLakePackage.MFLakeNumber(-AValue);
              if LakeNumber <= 0 then
              begin
                if InvalidLakes.IndexOf(AValue) < 0 then
                begin
                  InvalidLakes.Add(AValue);
                end;
//                AValue :=  -LakeNumber;
              end
              else
              begin
                AValue := -LakeNumber;
              end;
            end;
          end;

          Write(FFile, AValue, ' ');
        end
        else
        begin
          Write(FFile, 0, ' ');
        end;
        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;

    if StreamError then
    begin
      ErrorMessage := 'Error: In '
      + ModflowTypes.GetGridLayerType.ANE_LayerName + '.'
      + ParameterName
      + ', positive values indicate that excess infiltration in the UZF package '
      + 'is to be routed to a stream but the SFR package is not being used.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
    end;

    if LakeError then
    begin
      ErrorMessage := 'Error: In '
      + ModflowTypes.GetGridLayerType.ANE_LayerName + '.'
      + ParameterName
      + ', negative values indicate that excess infiltration in the UZF package '
      + 'is to be routed to a lake but the LAK package is not being used.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
    end;

    if InvalidSegments.Count > 0 then
    begin
      ErrorMessage := 'Error: In '
      + ModflowTypes.GetGridLayerType.ANE_LayerName + '.'
      + ParameterName
      + ', positive values indicate that excess infiltration in the UZF package '
      + 'is to be routed to a stream but some of the segments that were '
      + 'specified are invalid.  ';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.Add('The following segment numbers are invalid.');
      for Index := 0 to InvalidSegments.Count -1 do
      begin
        ErrorMessages.Add(IntToStr(InvalidSegments[Index]));
      end;
    end;

    if InvalidLakes.Count > 0 then
    begin
      ErrorMessage := 'Error: In '
      + ModflowTypes.GetGridLayerType.ANE_LayerName + '.'
      + ParameterName
      + ', negative values indicate that excess infiltration in the UZF package '
      + 'is to be routed to a lake but some of the lakes that were '
      + 'specified are invalid.  ';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.Add('The following lake numbers are invalid.');
      for Index := 0 to InvalidLakes.Count -1 do
      begin
        ErrorMessages.Add(IntToStr(InvalidLakes[Index]));
      end;
    end;
  finally
    GridLayer.Free(FModelHandle);
    InvalidSegments.Free;
    InvalidLakes.Free;
  end;


end;

procedure TUzfWriter.WriteVKS;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
//  EvapLayerHandle : ANE_PTR;
//  Project : TProjectOptions;
//  X, Y : ANE_DOUBLE;
//  Expression : string;
  ParameterIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'writing vertical saturated hydraulic conductivity';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfSaturatedKzParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetFloatParameter(FModelHandle,ParameterIndex);
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WriteEPS;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
//  EvapLayerHandle : ANE_PTR;
//  Project : TProjectOptions;
//  X, Y : ANE_DOUBLE;
//  Expression : string;
  ParameterIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'writing Brooks-Corey Epsilon';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfBrooksCoreyEpsilonParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetFloatParameter(FModelHandle,ParameterIndex);
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WriteTHTS;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ParameterIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'writing saturated water content';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfSaturatedWaterContentParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetFloatParameter(FModelHandle,ParameterIndex);
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WriteTHTI;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ParameterIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'writing initial water content';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfInitialWaterContentParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetFloatParameter(FModelHandle,ParameterIndex);
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
    GridLayer.Free(FModelHandle);
  end;
end;

constructor TUzfWriter.Create;
begin
  inherited;
  GageColumnNumbers := TIntegerList.Create;
  GageRowNumbers := TIntegerList.Create;
  GageOutputTypes := TIntegerList.Create;
end;

destructor TUzfWriter.Destroy;
begin
  GageColumnNumbers.Free;
  GageRowNumbers.Free;
  GageOutputTypes.Free;
  inherited;
end;

procedure TUzfWriter.EvaluateGages;
var
//  UnitNumber: integer;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_INT32;
  ParameterIndex: ANE_INT32;
//  OutputType: integer;
begin
  if frmModflow.cbUzrOutput.Checked then
  begin
    GageColumnNumbers.Add(0);
    GageRowNumbers.Add(0);
    GageOutputTypes.Add(0);
  end;

  frmProgress.lblActivity.Caption := 'writing UZF gages';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfOutputChoiceParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetIntegerParameter(FModelHandle,ParameterIndex);
            if AValue > 0 then
            begin
              GageColumnNumbers.Add(ColIndex+1);
              GageRowNumbers.Add(RowIndex+1);
              GageOutputTypes.Add(AValue);
            end;


          finally
            ABlock.Free;
          end;
        end;
        frmProgress.pbActivity.StepIt;
      end;
    end;

    if GageColumnNumbers.Count > 0 then
    begin
      FirstGageUnitNumber := frmModflow.GetNextNUnitNumber(GageColumnNumbers.Count);
    end;

  finally
    GridLayer.Free(FModelHandle);
  end;

end;

procedure TUzfWriter.WriteGages;
var
  Index: integer;
begin
  for Index := 0 to GageColumnNumbers.Count -1 do
  begin
    if GageColumnNumbers[Index] = 0 then
    begin
      WriteLn(FFile, -(FirstGageUnitNumber+Index));
    end
    else
    begin
      WriteLn(FFile,
        GageRowNumbers[Index], ' ',
        GageColumnNumbers[Index], ' ',
        FirstGageUnitNumber+Index, ' ',
        GageOutputTypes[Index]);
    end;
  end;
end;

procedure TUzfWriter.WriteFINF(StressPeriod: integer);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
//  UZFLayerHandle : ANE_PTR;
//  Project : TProjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
begin
  frmProgress.lblActivity.Caption := 'writing UZV infiltration rate';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFUzfInfiltrationRateParamType.WriteParamName
      + IntToStr(StressPeriod);

    Expression := ModflowTypes.GetMFUzfFlowLayerType.WriteNewRoot
      + '.' + ParameterName;
    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try
            ABlock.GetCenter(FModelHandle, X, Y);
            AValue := GridLayer.RealValueAtXY(FModelHandle, X, Y,
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WritePET(StressPeriod: integer);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
//  UZFLayerHandle : ANE_PTR;
//  Project : TProjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
begin
  frmProgress.lblActivity.Caption := 'writing UZV potential ET rate';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFUzfPotentialEvapotranspirationParamType.WriteParamName
      + IntToStr(StressPeriod);

    Expression := ModflowTypes.GetMFUzfFlowLayerType.WriteNewRoot
      + '.' + ParameterName;
    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try
            ABlock.GetCenter(FModelHandle, X, Y);
            AValue := GridLayer.RealValueAtXY(FModelHandle, X, Y,
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WriteEXTDP;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ParameterIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'writing UZF extinction depth';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfExtinctionDepthParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetFloatParameter(FModelHandle,ParameterIndex);
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WriteEXTWC;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ParameterIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'writing UZF extinction water content';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW * FDiscretization.NCOL;

  GridLayer := TLayerOptions.Create(FDiscretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridUzfExtinctionWaterContentParamType.WriteParamName;
    ParameterIndex := GridLayer.GetParameterIndex(FModelHandle,ParameterName);

    WriteU2DRELHeader;
    for RowIndex := 0 to FDiscretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to FDiscretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if FBasicPackage.CellUsed[ColIndex,RowIndex] then
        begin
          BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(FModelHandle,
            FDiscretization.GridLayerHandle, BlockIndex);
          try

            AValue := ABlock.GetFloatParameter(FModelHandle,ParameterIndex);
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
    GridLayer.Free(FModelHandle);
  end;
end;

procedure TUzfWriter.WriteDataSet1;
var
  NUZTOP: integer;
  IETFLG: integer;
  IUZFCB1: integer;
  IUZFCB2: integer;
  NTRAIL2: integer;
  NSETS2: integer;
  NUZGAG: integer;
  SURFDEP: double;
begin
  NUZTOP := frmModflow.comboUzfNUZTOP.ItemIndex + 1;
  if frmModflow.cbUzfIUZFOPT.Checked then
  begin
    IUZFOPT := 2;
  end
  else
  begin
    IUZFOPT := 1;
  end;

  if frmModflow.cbUzfIRUNFLG.Checked and
      (frmModflow.cbLAK.Checked or frmModflow.cbSFR.Checked) then
  begin
    IRUNFLG := 1;
  end
  else
  begin
    IRUNFLG := 0;
  end;

  if frmModflow.cbUzfIETFLG.Checked then
  begin
    IETFLG := 1;
  end
  else
  begin
    IETFLG := 0;
  end;

  IUZFCB1 := 0;

  if frmModflow.cbFlowUZF.Checked or frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbOneFlowFile.Checked then
    begin
      IUZFCB2 := frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IUZFCB2 := frmModflow.GetUnitNumber('UZFBUD1');
    end;
  end
  else
  begin
      IUZFCB2 := 0;
  end;

  NTRAIL2 := StrToInt(frmModflow.adeUzfNTRAIL2.Output);
  NSETS2 := StrToInt(frmModflow.adeUzfNSETS2.Output);
  NUZGAG := GageOutputTypes.Count;
  SURFDEP := InternationalStrToFloat(frmModflow.adeSurfDep.Text);

  if IUZFOPT > 0 then
  begin
    WriteLn(FFile, NUZTOP, ' ', IUZFOPT, ' ', IRUNFLG, ' ', IETFLG, ' ',
      IUZFCB1, ' ', IUZFCB2, ' ', NTRAIL2, ' ', NSETS2, ' ', NUZGAG, ' ',
      FreeFormattedReal(SURFDEP));
  end
  else
  begin
    WriteLn(FFile, NUZTOP, ' ', IUZFOPT, ' ', IRUNFLG, ' ', IETFLG, ' ',
      IUZFCB1, ' ', IUZFCB2, ' ', NUZGAG, ' ',
      FreeFormattedReal(SURFDEP));
  end;
end;

procedure TUzfWriter.EvaluateGages(Discretization: TDiscretizationWriter;
  BasicPackage: TBasicPkgWriter; LakePackage: TLakeWriter;
  SfrWriter: TStreamWriter);
begin
  FDiscretization := Discretization;
  FBasicPackage := BasicPackage;
  FLakePackage := LakePackage;
  FSfrWriter := SfrWriter;
  EvaluateGages;
end;

end.
