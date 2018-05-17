unit WriteMT3D_Basic;

interface

uses Classes, Forms, AnePIE, WriteModflowDiscretization;

type
  TMT3DObservation = class(TObject)
    Layer : integer;
    Row : integer;
    Column : integer;
  end;

  TMT3DCustomWriter = class(TListWriter)
  public
    procedure RealArrayHeader(Const IPRN : integer);
    procedure IntegerArrayHeader(Const IPRN : integer);
    Procedure Write1DArray(const AnArray : array of Double);
    procedure Write2DArray(const CurrentModelHandle : ANE_PTR;
      const DisWriter : TDiscretizationWriter; const Expression : string);
    procedure Write3DArrays(const CurrentModelHandle : ANE_PTR;
      const DisWriter : TDiscretizationWriter;
      const LayerRoot, Parameter: string; Const UseUnitIndexWithParameterName: boolean);
  end;

  TMt3dBasicWriter = class(TMT3DCustomWriter)
  private
    CurrentModelHandle : ANE_PTR;
    DisWriter : TDiscretizationWriter;
    NPRS : integer;
    procedure WriteDataSets1and2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6; // layer type
    procedure WriteDataSet7; // DELR
    procedure WriteDataSet8; // DELC
    procedure WriteDataSet9; // elevation of top layer
    procedure WriteDataSet10; // layer thicknesses
    procedure WriteDataSet11; // porosity
    procedure WriteDataSet12; // ICBUND
    procedure WriteDataSet13; // Initial concentration
    procedure WriteDataSet14; // CINACT, THKMIN
    procedure WriteDataSet15; // printout controls
    procedure WriteDataSet16; // print frequency
    procedure WriteDataSet17; // printout times
    Procedure WriteDataSets18and19; // observation locations
    procedure WriteDataSet20; // mass balance printout control
    procedure WriteDataSets21to23; // time control
  public
    procedure WriteFile(const ModelHandle: ANE_PTR; const Root: string;
      const Discretization : TDiscretizationWriter);
  end;

implementation

uses Sysutils, Contnrs, OptionsUnit, Variables, ProgressUnit, UtilityFunctions,
  ModflowUnit, WriteNameFileUnit, ReadMt3dArrayUnit, ReadModflowArrayUnit;

resourcestring
  kTrue10  = '         T';
  kFalse10 = '         F';

{ TMt3dBasicWriter }

procedure TMt3dBasicWriter.WriteDataSet10;
var
  ColIndex, RowIndex : integer;
  UnitIndex : Integer;
//  ParameterIndicies : TIntegerList;
  DiscretizationIndex : integer;
  Discretization : integer;
  AValue : Single;
begin
  with DisWriter do
  begin
    Discretization := 0;
    for UnitIndex := 1 to NUNITS do
    begin
      Discretization := Discretization +
        frmMODFLOW.DiscretizationCount(UnitIndex);
    end;

    frmProgress.lblActivity.Caption := 'writing thickness of layers';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := NROW*NCOL*Discretization;

    for UnitIndex := 1 to NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      Discretization := frmMODFLOW.DiscretizationCount(UnitIndex);
      for DiscretizationIndex := 1 to Discretization do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        RealArrayHeader(0);
        for RowIndex := 0 to NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            AValue := Thicknesses[ColIndex,RowIndex,UnitIndex-1]/Discretization;

            Write(self.FFile, Format('%g ', [AValue]));

            frmProgress.pbActivity.StepIt;
          end;
          WriteLn(self.FFile);
        end;

      end;


    end;


  end;
end;

procedure TMt3dBasicWriter.WriteDataSet11;
var
  Porosity : array of array of double;
  UnitIndex : integer;
  ParameterName : string;
  GridLayer : TLayerOptions;
  ParameterIndex: ANE_INT16;
  RowIndex, ColIndex : integer;
  BlockIndex : integer;
  DisIndex : integer;
  Block : TBlockObjectOptions;
  AValue : double;
  LayerCount: integer;
begin
  SetLength(Porosity, DisWriter.NROW, DisWriter.NCOL);
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);

  LayerCount := 0;
  for UnitIndex := 1 to DisWriter.NUNITS do
  begin
    LayerCount := LayerCount + frmModflow.DiscretizationCount(UnitIndex)
  end;
  frmProgress.lblActivity.Caption := 'writing porosity';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := DisWriter.NROW*DisWriter.NCOL*(LayerCount+DisWriter.NUNITS);

  try
    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;
      ParameterName := ModflowTypes.GetMFGridMOCPorosityParamType.ANE_ParamName
        + IntToStr(UnitIndex);
      ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
      for RowIndex := 0 to DisWriter.NROW-1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;
        for ColIndex := 0 to DisWriter.NCOL -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
          Block := TBlockObjectOptions.Create(CurrentModelHandle,DisWriter.GridLayerHandle,
            BlockIndex);
          try
            Porosity[RowIndex,ColIndex] := Block.
              GetFloatParameter(CurrentModelHandle,ParameterIndex);
          finally
            Block.Free;
          end;
          frmProgress.pbActivity.StepIt;
        end;
      end;
      for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        RealArrayHeader(0);
        for RowIndex := 0 to DisWriter.NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          for ColIndex := 0 to DisWriter.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            AValue := Porosity[RowIndex,ColIndex];
            Write(FFile, Format('%g ', [AValue]));
            frmProgress.pbActivity.StepIt;
          end;
          WriteLn(FFile);
        end;
      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
    SetLength(Porosity, 0,0);
  end;

end;

procedure TMt3dBasicWriter.WriteDataSet12;
var
  ICBUND : array of array of integer;
  UnitIndex : integer;
  ParameterName : string;
  GridLayer : TLayerOptions;
  ParameterIndex: ANE_INT16;
  RowIndex, ColIndex : integer;
  BlockIndex : integer;
  DisIndex : integer;
  Block : TBlockObjectOptions;
  AValue : integer;
  LayerCount: integer;
begin
  LayerCount := 0;
  for UnitIndex := 1 to DisWriter.NUNITS do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      LayerCount := LayerCount + frmModflow.DiscretizationCount(UnitIndex) + 1
    end;
  end;
  frmProgress.lblActivity.Caption := 'writing ICBUND';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := DisWriter.NROW*DisWriter.NCOL*LayerCount;

  SetLength(ICBUND, DisWriter.NROW, DisWriter.NCOL);
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
  try
    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        ParameterName := ModflowTypes.GetGridMT3DICBUNDParamClassType.ANE_ParamName
          + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
        for RowIndex := 0 to DisWriter.NROW-1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          for ColIndex := 0 to DisWriter.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
            Block := TBlockObjectOptions.Create(CurrentModelHandle,DisWriter.GridLayerHandle,
              BlockIndex);
            try
              ICBUND[RowIndex,ColIndex] := Block.
                GetIntegerParameter(CurrentModelHandle,ParameterIndex);
            finally
              Block.Free;
            end;
            frmProgress.pbActivity.StepIt;
          end;
        end;
        for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          IntegerArrayHeader(0);
          for RowIndex := 0 to DisWriter.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            for ColIndex := 0 to DisWriter.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;
              AValue := ICBUND[RowIndex,ColIndex];
              Write(FFile, Format('%d ', [AValue]));
              frmProgress.pbActivity.StepIt;
            end;
            WriteLn(FFile);
          end;
        end;
      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
    SetLength(ICBUND, 0,0);
  end;
end;

procedure TMt3dBasicWriter.WriteDataSet13;
var
  ParameterRoots : TStringList;
  NumberOfSpecies : integer;
  SpeciesIndex, UnitIndex, DisIndex : integer;
  SCONC : array of array of double;
  RowIndex, ColIndex : integer;
  ParameterRoot, ParameterName : string;
  GridLayer : TLayerOptions;
  ParameterIndex: ANE_INT16;
  Block : TBlockObjectOptions;
  AValue : double;
  BlockIndex : integer;
  LayerCount: integer;
  StressPeriod: Integer;
  TimeStep: Integer;
  TransportStep: Integer;
  FileName: string;
  AFileStream: TFileStream;
  APrecision: TModflowPrecision;
  NTRANS: Integer;
  KSTP: Integer;
  KPER: Integer;
  TOTIM: TModflowDouble;
  DESC: TModflowDesc;
  NCOL: Integer;
  NROW: Integer;
  ILAY: Integer;
  AnArray: TModflowDoubleArray;
  ErrorMessage: string;
  LayerIndex: Integer;
begin
  ParameterRoots := TStringList.Create;
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
  SetLength(SCONC, DisWriter.NROW, DisWriter.NCOL);
  try
    ParameterRoots.Capacity := 5;
    ParameterRoots.Add(ModflowTypes.GetGridMT3DInitConcCellParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.GetGridMT3DInitConc2ParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.GetGridMT3DInitConc3ParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.GetGridMT3DInitConc4ParamClassType.ANE_ParamName);
    ParameterRoots.Add(ModflowTypes.GetGridMT3DInitConc5ParamClassType.ANE_ParamName);

    NumberOfSpecies := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    Assert(NumberOfSpecies <= ParameterRoots.Count);

    LayerCount := 0;
    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        LayerCount := LayerCount + frmModflow.DiscretizationCount(UnitIndex) + 1
      end;
    end;
    frmProgress.lblActivity.Caption := 'writing initial concentrations';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := DisWriter.NROW*DisWriter.NCOL*LayerCount*NumberOfSpecies;

    StressPeriod := StrToInt(frmMODFLOW.adeMt3dmsBinaryStressPeriod.Text);
    TimeStep := StrToInt(frmMODFLOW.adeMt3dmsBinaryTimeStepChoice.Text);
    TransportStep := StrToInt(frmMODFLOW.adeMt3dmsBinaryTransportStepChoice.Text);

    for SpeciesIndex := 0 to NumberOfSpecies -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;
      FileName := frmMODFLOW.rdgMt3dBinaryInitialConcFiles.
        Cells[Ord(mbffFileName), SpeciesIndex+1];
      if FileName <> '' then
      begin
        KPER := -1;
        KSTP := -1;
        NTRANS := -1;
        FileName := GetCurrentDir + '\' + FileName;
        if not FileExists(FileName) then
        begin
          ErrorMessage := 'Error: ' + FileName
            + ' does not exist.';
          frmProgress.reErrors.Lines.Add(ErrorMessage);
          ErrorMessages.Add('');
          ErrorMessages.Add(ErrorMessage);
          Exit;
        end;
        AFileStream := TFileStream.Create(FileName, fmOpenRead or fmShareCompat);
        try
          APrecision := CheckMt3dArrayPrecision(AFileStream);
          While AFileStream.Position < AFileStream.Size do
          begin
            case APrecision of
              mpSingle:
                begin
                  ReadSinglePrecisionMt3dBinaryRealArray(AFileStream, NTRANS,
                    KSTP, KPER, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
                end;
              mpDouble:
                begin
                  ReadDoublePrecisionMt3dBinaryRealArray(AFileStream, NTRANS,
                    KSTP, KPER, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
                end;
              else Assert(False);
            end;
            if (StressPeriod = KPER) and (KSTP = TimeStep)
              and (TransportStep = NTRANS) then
            begin
              break;
            end;
          end;

          if (StressPeriod <> KPER) or (KSTP <> TimeStep)
            or (TransportStep <> NTRANS) then
          begin
            ErrorMessage := 'Error: the specified stress period, time step, '
              + 'and transport step '
              + 'were not found in the file "' + FileName
              + '".';
            frmProgress.reErrors.Lines.Add(ErrorMessage);
            ErrorMessages.Add('');
            ErrorMessages.Add(ErrorMessage);
            Exit;
          end;

          LayerIndex := 0;
          for UnitIndex := 1 to frmModflow.UnitCount do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            if frmModflow.Simulated(UnitIndex) then
            begin
              for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
              begin
                Inc(LayerIndex);
                if LayerIndex <> ILAY then
                begin
                  ErrorMessage := 'Error: Data for layer ' + IntToStr(LayerIndex)
                    + ' in the specified stress period and time step '
                    + 'were not found in the file "' + FileName
                    + '".';
                  frmProgress.reErrors.Lines.Add(ErrorMessage);
                  ErrorMessages.Add('');
                  ErrorMessages.Add(ErrorMessage);
                  Exit;
                end;

                if (DisWriter.NROW <> NROW) or (DisWriter.NCOL <> NCOL) then
                begin
                  ErrorMessage := 'Error: The number of rows or columns '
                    + 'in the file "' + FileName
                    + '" do not match the number in the model.';
                  frmProgress.reErrors.Lines.Add(ErrorMessage);
                  ErrorMessages.Add('');
                  ErrorMessages.Add(ErrorMessage);
                  Exit;
                end;
                RealArrayHeader(0);
                for RowIndex := 0 to DisWriter.NROW -1 do
                begin
                  Application.ProcessMessages;
                  if not ContinueExport then break;
                  for ColIndex := 0 to DisWriter.NCOL -1 do
                  begin
                    Application.ProcessMessages;
                    if not ContinueExport then break;
                    AValue := AnArray[RowIndex, ColIndex];
                    Write(FFile, Format('%g ', [AValue]));
                    frmProgress.pbActivity.StepIt;
                  end;
                  WriteLn(FFile);
                end;

                if AFileStream.Position < AFileStream.Size then
                begin
                  case APrecision of
                    mpSingle:
                      begin
                        ReadSinglePrecisionMt3dBinaryRealArray(AFileStream, NTRANS,
                          KSTP, KPER, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
                      end;
                    mpDouble:
                      begin
                        ReadDoublePrecisionMt3dBinaryRealArray(AFileStream, NTRANS,
                          KSTP, KPER, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
                      end;
                    else Assert(False);
                  end;
                end
              end;
            end;
          end;
        finally
          AFileStream.Free;
        end;
      end
      else
      begin
        ParameterRoot := ParameterRoots[SpeciesIndex];
        for UnitIndex := 1 to frmModflow.UnitCount do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          if frmModflow.Simulated(UnitIndex) then
          begin
            ParameterName := ParameterRoot + IntToStr(UnitIndex);
            ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
            for RowIndex := 0 to DisWriter.NROW-1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;
              for ColIndex := 0 to DisWriter.NCOL -1 do
              begin
                Application.ProcessMessages;
                if not ContinueExport then break;
                BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
                Block := TBlockObjectOptions.Create(CurrentModelHandle,DisWriter.GridLayerHandle,
                  BlockIndex);
                try
                  SCONC[RowIndex,ColIndex] := Block.
                    GetFloatParameter(CurrentModelHandle,ParameterIndex);
                finally
                  Block.Free;
                end;
                frmProgress.pbActivity.StepIt;
              end;
            end;
            for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
            begin
              RealArrayHeader(0);
              for RowIndex := 0 to DisWriter.NROW -1 do
              begin
                Application.ProcessMessages;
                if not ContinueExport then break;
                for ColIndex := 0 to DisWriter.NCOL -1 do
                begin
                  Application.ProcessMessages;
                  if not ContinueExport then break;
                  AValue := SCONC[RowIndex,ColIndex];
                  Write(FFile, Format('%g ', [AValue]));
                  frmProgress.pbActivity.StepIt;
                end;
                WriteLn(FFile);
              end;
            end;
          end;
        end;
      end
    end;
  finally
    ParameterRoots.Free;
    GridLayer.Free(CurrentModelHandle);
    SetLength(SCONC, 0, 0);
  end;
end;

procedure TMt3dBasicWriter.WriteDataSet14;
var
  CINACT, THKMIN : double;
begin
  CINACT := InternationalStrToFloat(frmModflow.adeMT3DInactive.Text);
  THKMIN := InternationalStrToFloat(frmModflow.adeMT3D_MinimumThickness.Text);
  WriteLn(FFile,
    FixedFormattedReal(CINACT, 10),
    FixedFormattedReal(THKMIN, 10));
end;

procedure TMt3dBasicWriter.WriteDataSet15;
var
  IFMTCN, IFMTNP, IFMTRF, IFMTDP : integer;
  SAVUCN : string;
  StripModifier : integer;
begin
  with frmModflow do
  begin
    StripModifier := 1;
    if comboPrintoutFormat.ItemIndex = 1 then
    begin
      StripModifier := -1;
    end;

    if not cbPrintConc.Checked then
    begin
      IFMTCN := 0;
    end
    else
    begin
      IFMTCN := StripModifier * (comboConcentrationFormat.ItemIndex + 1);
    end;

    if not cbPrintNumParticles.Checked then
    begin
      IFMTNP := 0;
    end
    else
    begin
      IFMTNP := StripModifier * (comboParticlePrintFormat.ItemIndex + 1);
    end;

    if not cbPrintRetardation.Checked then
    begin
      IFMTRF := 0;
    end
    else
    begin
      IFMTRF := StripModifier * (comboRetardationFormat.ItemIndex + 1);
    end;

    if not cbPrintDispCoef.Checked then
    begin
      IFMTDP := 0;
    end
    else
    begin
      IFMTDP := StripModifier * (comboDispersionFormat.ItemIndex + 1);
    end;

    if cbSaveConcAndDisc.Checked then
    begin
      SAVUCN := kTrue10;
    end
    else
    begin
      SAVUCN := kFalse10;
    end;

  end;

  WriteLn(FFile,
    FixedFormattedInteger(IFMTCN, 10),
    FixedFormattedInteger(IFMTNP, 10),
    FixedFormattedInteger(IFMTRF, 10),
    FixedFormattedInteger(IFMTDP, 10),
    SAVUCN);
end;

procedure TMt3dBasicWriter.WriteDataSet16;
begin
  case frmModflow.comboResultsPrinted.ItemIndex of
    0:
      begin
        NPRS := 0;
      end;
    1:
      begin
        NPRS := -StrToInt(frmModflow.adeResultsPrintedN.Text);
      end;
    2:
      begin
        NPRS := frmModflow.sgPrintoutTimes.RowCount -1;
      end;
  else Assert(False);
  end;
  WriteLn(FFile,
    FixedFormattedInteger(NPRS, 10));

end;

procedure TMt3dBasicWriter.WriteDataSet17;
var
  TIMPRS : double;
  Count : integer;
  Index : integer;
begin
  if NPRS > 0 then
  begin
    Count := 0;
    with frmModflow.sgPrintoutTimes do
    begin
      for Index := 1 to RowCount-1 do
      begin
        TIMPRS := InternationalStrToFloat(Cells[1,Index]);
        Write(FFile, FixedFormattedReal(TIMPRS, 10));
        Inc(Count);
        if Count = 8 then
        begin
          Writeln(FFile);
          Count := 0;
        end;
      end;
    end;
    if Count <> 0 then
    begin
      Writeln(FFile);
    end;
  end;
end;

procedure TMt3dBasicWriter.WriteDataSet20;
var
  CHKMAS : string;
  NPRMAS : integer;
begin
  if frmModflow.cbCheckMass.Checked then
  begin
    CHKMAS := kTrue10;
  end
  else
  begin
    CHKMAS := kFalse10;
  end;
  NPRMAS := StrToInt(frmModflow.adeMT3DMassBudPrintFrequency.Text);
  WriteLn(FFile,
    CHKMAS,
    FixedFormattedInteger(NPRMAS, 10));

end;

procedure TMt3dBasicWriter.WriteDataSet3;
begin
  WriteLn(FFile,
    FixedFormattedInteger(DisWriter.NLAY, 10),
    FixedFormattedInteger(DisWriter.NROW, 10),
    FixedFormattedInteger(DisWriter.NCOL, 10),
    FixedFormattedInteger(DisWriter.NPER, 10),
    FixedFormattedInteger(StrToInt(frmModflow.adeMT3DNCOMP.Text), 10),
    FixedFormattedInteger(StrToInt(frmModflow.adeMT3DMCOMP.Text), 10));
end;

procedure TMt3dBasicWriter.WriteDataSet4;
var
  TUNIT, LUNIT, MUNIT : string;

begin
  case frmModflow.comboTimeUnits.ItemIndex of
    0:
      begin
        TUNIT := 'UNDF';
      end;
    1:
      begin
        TUNIT := 'SEC ';
      end;
    2:
      begin
        TUNIT := 'MIN ';
      end;
    3:
      begin
        TUNIT := 'HOUR';
      end;
    4:
      begin
        TUNIT := 'DAY ';
      end;
    5:
      begin
        TUNIT := 'YEAR';
      end;
  else Assert(False);
  end;

  case frmModflow.comboLengthUnits.ItemIndex of
    0:
      begin
        LUNIT := 'UNDF';
      end;
    1:
      begin
        LUNIT := 'FEET';
      end;
    2:
      begin
        LUNIT := 'm   ';
      end;
    3:
      begin
        LUNIT := 'cm  ';
      end;
  else Assert(False);
  end;

  MUNIT := frmModflow.edMT3DMass.Text;
  While Length(MUNIT) < 4 do
  begin
    MUNIT := MUNIT + ' ';
  end;
  SetLength(MUNIT,4);

  WriteLn(FFIle, TUNIT, LUNIT, MUNIT);
end;

procedure TMt3dBasicWriter.WriteDataSet5;
var
  ADV, DSP, SSM, RCT, GCG : string;
begin
  with frmMODFLOW do
  begin

    if cbADV.Checked then
    begin
      ADV := ' T';
    end
    else
    begin
      ADV := ' F';
    end;

    if cbDSP.Checked then
    begin
      DSP := ' T';
    end
    else
    begin
      DSP := ' F';
    end;

    if cbSSM.Checked then
    begin
      SSM := ' T';
    end
    else
    begin
      SSM := ' F';
    end;

    if cbRCT.Checked then
    begin
      RCT := ' T';
    end
    else
    begin
      RCT := ' F';
    end;

    if cbGCG.Checked then
    begin
      GCG := ' T';
    end
    else
    begin
      RCT := ' F';
    end;
  end;

  Writeln(FFile, ADV, DSP, SSM, RCT, GCG, ' F F F F F');
end;

procedure TMt3dBasicWriter.WriteDataSet6;
var
  UnitIndex, DisIndex, LayerType, LayerIndex : integer;
begin
  LayerIndex := 0;
  for UnitIndex := 1 to DisWriter.NUNITS do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      LayerType := frmModflow.ModflowLayerType(UnitIndex);
      for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        Write(FFile, FixedFormattedInteger(LayerType, 2));
        Inc(LayerIndex);
        if (LayerIndex mod 40) = 0 then
        begin
          WriteLn(FFile);
        end;
      end;
    end;
  end;
  if (LayerIndex mod 40) <> 0 then
  begin
    WriteLn(FFile);
  end;
end;

procedure TMt3dBasicWriter.WriteDataSet7;
begin
  Write1DArray(DisWriter.DELR);
end;

procedure TMt3dBasicWriter.WriteDataSet8;
begin
  Write1DArray(DisWriter.DELC);
end;

procedure TMt3dBasicWriter.WriteDataSet9;
var
  RowIndex, ColIndex : integer;
begin
  RealArrayHeader(0);
  with DisWriter do
  begin
    for RowIndex := 0 to NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        Write(self.FFile,
          Elevations[ColIndex,RowIndex,0],
          ' ');

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(self.FFile);
    end;
  end;
end;

procedure TMt3dBasicWriter.WriteDataSets18and19;
var
  ObservationList : TObjectList;
  UnitIndex, DisIndex, RowIndex, ColIndex : integer;
  GridLayer : TLayerOptions;
  ParameterName : string;
  ParameterIndex: ANE_INT16;
  Value : double;
  LayersAbove : Integer;
  Observation : TMT3DObservation;
  DisCount : integer;
  BlockIndex : integer;
  Block : TBlockObjectOptions;
  NOBS, NPROBS : integer;
  ObsIndex : integer;
begin
  ObservationList := TObjectList.Create;
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
  try
    LayersAbove := 0;
    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        ParameterName := ModflowTypes.GetGridMT3DObsLocCellParamClassType.
          ANE_ParamName + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,
          ParameterName);
        DisCount := frmModflow.DiscretizationCount(UnitIndex);
        for RowIndex := 0 to DisWriter.NROW-1 do
        begin
          for ColIndex := 0 to DisWriter.NCOL -1 do
          begin
            BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
            Block := TBlockObjectOptions.Create(CurrentModelHandle,DisWriter.GridLayerHandle,
              BlockIndex);
            try
              Value := Block.
                GetFloatParameter(CurrentModelHandle,ParameterIndex);
              if Value <> 0 then
              begin
                for DisIndex := 1 to DisCount do
                begin
                  Observation := TMT3DObservation.Create;
                  Observation.Layer := LayersAbove + DisIndex;
                  Observation.Row := RowIndex + 1;
                  Observation.Column := ColIndex + 1;
                  ObservationList.Add(Observation);
                end;
              end;
            finally
              Block.Free;
            end;
          end;
        end;
        LayersAbove := LayersAbove + DisCount;
      end;
    end;

    // data set 18
    NOBS := ObservationList.Count;
    NPROBS := StrToInt(frmModflow.adeMT3D_ObservationPrintoutFrequency.Text);
    writeLn(FFile,
      FixedFormattedInteger(NOBS, 10),
      FixedFormattedInteger(NPROBS, 10));

    // data set 19
    for ObsIndex := 0 to ObservationList.Count -1 do
    begin
      Observation := ObservationList[ObsIndex] as TMT3DObservation;
      writeLn(FFile,
        FixedFormattedInteger(Observation.Layer, 10),
        FixedFormattedInteger(Observation.Row, 10),
        FixedFormattedInteger(Observation.Column, 10));

    end;


  finally
    ObservationList.Free;
    GridLayer.Free(CurrentModelHandle);
  end;

end;

procedure TMt3dBasicWriter.WriteDataSets1and2;
begin
  WriteLn(FFile, frmModflow.adeMT3DHeading1.Text);
  WriteLn(FFile, frmModflow.adeMT3DHeading2.Text);
end;

procedure TMt3dBasicWriter.WriteDataSets21to23;
var
  TimeIndex : integer;
  PERLEN : double;
  TSMULT : double;
  NSTP : Integer;
  DT0 : double;
  MXSTRN : Integer;
  TTSMULT, TTSMAX : double;
begin
  with frmModflow do
  begin
    Assert(sgMT3DTime.RowCount = dgTime.RowCount);
    for TimeIndex := 1 to dgTime.RowCount -1 do
    begin
      with dgTime do
      begin
        PERLEN := InternationalStrToFloat(Cells[Ord(tdLength), TimeIndex]);
        TSMULT := InternationalStrToFloat(Cells[Ord(tdMult), TimeIndex]);
        NSTP := StrToInt(Cells[Ord(tdNumSteps), TimeIndex]);
      end;

      with sgMT3DTime do
      begin
        if Cells[Ord(tdmCalculated), TimeIndex] = 'Yes' then
        begin
          DT0 := 0;
        end
        else
        begin
          DT0 := InternationalStrToFloat(Cells[Ord(tdmStepSize), TimeIndex]);
        end;
        MXSTRN := StrToInt(Cells[Ord(tdmMaxSteps), TimeIndex]);
        TTSMULT := InternationalStrToFloat(Cells[Ord(tdmMult), TimeIndex]);
        TTSMAX := InternationalStrToFloat(Cells[Ord(tdmMax), TimeIndex]);
      end;

      // data set 21
      writeln(FFile,
        FixedFormattedReal(PERLEN, 10),
        FixedFormattedInteger(NSTP, 10),
        FixedFormattedReal(TSMULT, 10));

      // data set 22 is never used with MODFLOW

      // data set 23
      writeln(FFile,
        FixedFormattedReal(DT0, 10),
        FixedFormattedInteger(MXSTRN, 10),
        FixedFormattedReal(TTSMULT, 10),
        FixedFormattedReal(TTSMAX, 10));
    end;

  end;

end;

procedure TMt3dBasicWriter.WriteFile(const ModelHandle: ANE_PTR;
  const Root: string; const Discretization: TDiscretizationWriter);
var
  FileName : string;
begin
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 9;
  Assert(Discretization <> nil);
  DisWriter := Discretization;
  CurrentModelHandle := ModelHandle;
  FileName := GetCurrentDir + '\' + Root + rsBTN;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);

    WriteDataSets1and2;
    WriteDataSet3;
    WriteDataSet4;
    WriteDataSet5;
    WriteDataSet6; // layer type

    WriteDataSet7; // DELR
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet8; // DELC
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet9; // elevation of top layer
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet10; // layer thicknesses
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet11; // porosity
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet12; // ICBUND
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet13; // Initial concentration
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet14; // CINACT, THKMIN
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet15; // printout controls
    WriteDataSet16; // print frequency
    WriteDataSet17; // printout times
    WriteDataSets18and19; // observation locations
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet20; // mass balance printout control
    WriteDataSets21to23; // time control
  finally
    CloseFile(FFile);
  end;
end;

{ TMT3DCustomWriter }

procedure TMT3DCustomWriter.IntegerArrayHeader(const IPRN: integer);
begin
  WriteLn(FFile, '       103         1                    ',
    FixedFormattedInteger(IPRN, 10));
end;

procedure TMT3DCustomWriter.RealArrayHeader(const IPRN: integer);
begin
  WriteLn(FFile, '       103        1.                    ',
    FixedFormattedInteger(IPRN, 10));
end;

procedure TMT3DCustomWriter.Write1DArray(const AnArray: array of Double);
const
  MaxItemsPerLine = 10;
var
  Value, NextValue : double;
  Index, Count, ArrayLength {, ItemsCount} : integer;
begin
  RealArrayHeader(0);
  ArrayLength := Length(AnArray);
  Assert(ArrayLength >= 1);
  Value := AnArray[0];
  if ArrayLength = 1 then
  begin
    WriteLn(FFile, FreeFormattedReal(Value));
    Exit;
  end;

//  ItemsCount := 0;
  Count := 1;
//  Write(FFile, FreeFormattedReal(Value));
  for Index := 1 to ArrayLength -1 do
  begin
    NextValue := AnArray[Index];
    if (NextValue <> Value) then
    begin
      if Count > 1 then
      begin
        Write(FFile, Count, '*');
      end;
      Write(FFile, FreeFormattedReal(Value));
      Value := NextValue;
      Count := 1;
      if (Index = ArrayLength-1) then
      begin
        Write(FFile, FreeFormattedReal(Value));
      end;
    end
    else if (Index = ArrayLength-1) then
    begin
      Write(FFile, Count+1, '*');
      Write(FFile, FreeFormattedReal(NextValue));
    end
    else
    begin
      Inc(Count);
    end;
  end;
  WriteLn(FFile);
end;


procedure TMT3DCustomWriter.Write2DArray(const CurrentModelHandle: ANE_PTR;
  const DisWriter: TDiscretizationWriter; const Expression: string);
var
  GridLayer : TLayerOptions;
  RowIndex, ColIndex : integer;
  BlockIndex : integer;
  Block : TBlockObjectOptions;
  AValue : double;
  X, Y: ANE_DOUBLE;
begin
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
  try
    RealArrayHeader(0);
    for RowIndex := 0 to DisWriter.NROW-1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;
      for ColIndex := 0 to DisWriter.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;
        BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
        Block := TBlockObjectOptions.Create(CurrentModelHandle,
          DisWriter.GridLayerHandle, BlockIndex);
        try
          Block.GetCenter(CurrentModelHandle, X, Y);
          AValue := GridLayer.
            RealValueAtXY(CurrentModelHandle, X, Y, Expression);
          Write(FFile, FreeFormattedReal(AValue));
          frmProgress.pbActivity.StepIt;
        finally
          Block.Free;
        end;
      end;
      WriteLn(FFile);
    end;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;

end;

procedure TMT3DCustomWriter.Write3DArrays(
  const CurrentModelHandle: ANE_PTR;
  const DisWriter: TDiscretizationWriter; const LayerRoot,
  Parameter: string; Const UseUnitIndexWithParameterName: boolean);
var
  XArray, YArray : array of array of double;
  AnArray : array of array of double;
  UnitIndex : integer;
  ParameterName : string;
  GridLayer : TLayerOptions;
  RowIndex, ColIndex : integer;
  BlockIndex : integer;
  DisIndex : integer;
  Block : TBlockObjectOptions;
  AValue : double;
  LayerName : string;
  Expression : string;
  X, Y: ANE_DOUBLE;
begin
  SetLength(AnArray, DisWriter.NROW, DisWriter.NCOL);
  SetLength(XArray, DisWriter.NROW, DisWriter.NCOL);
  SetLength(YArray, DisWriter.NROW, DisWriter.NCOL);
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
  try
    for RowIndex := 0 to DisWriter.NROW-1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;
      for ColIndex := 0 to DisWriter.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;
        BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
        Block := TBlockObjectOptions.Create(CurrentModelHandle,
          DisWriter.GridLayerHandle, BlockIndex);
        try
          Block.GetCenter(CurrentModelHandle, X, Y);
          XArray[RowIndex,ColIndex] := X;
          YArray[RowIndex,ColIndex] := Y;
        finally
          Block.Free;
        end;
      end;
    end;


    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        LayerName := LayerRoot + IntToStr(UnitIndex);
        if UseUnitIndexWithParameterName then
        begin
          ParameterName := Parameter + IntToStr(UnitIndex);
        end
        else
        begin
          ParameterName := Parameter;
        end;

        Expression := LayerName + '.' + ParameterName;
        for RowIndex := 0 to DisWriter.NROW-1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          for ColIndex := 0 to DisWriter.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            X := XArray[RowIndex,ColIndex];
            Y := YArray[RowIndex,ColIndex];
            AnArray[RowIndex,ColIndex] := GridLayer.
              RealValueAtXY(CurrentModelHandle, X, Y, Expression);
          end;
        end;
        for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          RealArrayHeader(0);
          for RowIndex := 0 to DisWriter.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;
            for ColIndex := 0 to DisWriter.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;
              AValue := AnArray[RowIndex,ColIndex];
              Write(FFile, Format('%g ', [AValue]));
              frmProgress.pbActivity.StepIt;
            end;
            WriteLn(FFile);
          end;
        end;
      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
    SetLength(AnArray, 0,0);
    SetLength(XArray, 0,0);
    SetLength(YArray, 0,0);
  end;

end;

end.
