unit WriteHUF_Unit;

interface

uses Sysutils, Classes, Forms, Grids, DataGrid, ANEPIE, WriteModflowDiscretization,
  WriteBCF_Unit, WriteModflowZonesUnit, WriteMultiplierUnit, WriteLakesUnit,
  WriteReservoirUnit, ProgressUnit, ModflowUnit;

type
  THUF_Writer = class(TFlowWriter)
  private
    WettingIsActive : boolean;
    WETDRY : array of array of array of ANE_DOUBLE;
    Tops : array of array of array of ANE_DOUBLE;
    Thicknesses : array of array of array of ANE_DOUBLE;
    procedure SetWetDryArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure EvaluateDataSets6to8(const CurrentModelHandle: ANE_PTR;
      const Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
      LakeWriter: TLakeWriter; ReservoirWriter: TReservoirWriter);
    procedure WriteDataSets6to8(const CurrentModelHandle: ANE_PTR;
      const Discretization: TDiscretizationWriter);
    procedure WriteDataSet9;
    procedure WriteDataSets10to11;
    procedure WriteDataSet12;
    procedure WriteWETDRY(UnitNumber: integer;
      Discretization: TDiscretizationWriter; LakeWriter: TLakeWriter;
      ReservoirWriter: TReservoirWriter; LayerIndex: integer);
    procedure CheckParameterCoverage;
    procedure WriteLVDA_DataSet1;
    procedure WriteLVDA_DataSets2to3;
    function ParameterTypeToString(
      const ParameterType: hufParameterType): string;
    procedure WriteKDEP_DataSet1;
    procedure WriteKDEP_DataSet2(const CurrentModelHandle: ANE_PTR;
      const Discretization : TDiscretizationWriter;
      const BasicPackage: TBasicPkgWriter);
    procedure WriteKDEP_DataSets3to4;
    procedure WriteClusters(const AllowedTypes: THufParameterTypes);
  public
    function Trans(ColIndex, RowIndex, UnitIndex: integer;
      Discretization : TDiscretizationWriter) : double; override;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter;
      ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter;
      LakeWriter: TLakeWriter; ReservoirWriter: TReservoirWriter);
    class procedure AssignUnitNumbers;
  end;

implementation

uses contnrs, UtilityFunctions, OptionsUnit, Variables, framHUF_Unit,
  WriteNameFileUnit, StringGrid3d, Dialogs;

Type
  TParameterCheck = class
    ParameterType : hufParameterType;
    Units : TStringList;
    Constructor Create;
    Destructor Destroy; override;
  end;



{ THUF_Writer }

function THUF_Writer.ParameterTypeToString(const ParameterType : hufParameterType): string;
begin
  case ParameterType of
    hufHK:
      begin
        result := 'HK';
      end;
    hufHani:
      begin
        result := 'HANI';
      end;
    hufVK:
      begin
        result := 'VK';
      end;
    hufVANI:
      begin
        result := 'VANI';
      end;
    hufSS:
      begin
        result := 'SS';
      end;
    hufSY:
      begin
        result := 'SY';
      end;
    hufKDEP:
      begin
        result := 'KDEP';
      end;
    hufSYTP:
      begin
        result := 'SYTP';
      end;
    hufLVDA:
      begin
        result := 'LVDA';
      end;
  else Assert(false);
  end;
end;


procedure THUF_Writer.CheckParameterCoverage;
var
  ParameterGrid : TDataGrid;
  ClusterGrid : TRBWDataGrid3D;
  ParameterIndex : integer;
  AGrid : TStringGrid;
  ParameterType : hufParameterType;
  ParameterCheckIndex : integer;
  ParameterCheck : TParameterCheck;
  ParameterCheckList : TObjectList;
  UnitIndex : integer;
  AString : string;
  Units, GeoUnits : TStringList;
  Errors : TStringList;
  AUnit : string;
begin
  Units := TStringList.Create;
  GeoUnits := TStringList.Create;
  ParameterCheckList := TObjectList.Create;
  Errors := TStringList.Create;
  try
    Units.Sorted := True;
    with frmModflow do
    begin
      ParameterGrid := dgHUFParameters;
      ClusterGrid := dg3dHUFParameterClusters;
      for ParameterIndex := 1 to ParameterGrid.RowCount -1 do
      begin
        ParameterType := frmModflow.EvaluateHUFParameter(ParameterIndex);
        if ParameterType in [hufKDEP, hufSYTP] then
        begin
          Continue;
        end;

        ParameterCheck := nil;
        for ParameterCheckIndex := 0 to ParameterCheckList.Count -1 do
        begin
          ParameterCheck := ParameterCheckList[ParameterCheckIndex] as TParameterCheck;
          if ParameterCheck.ParameterType = ParameterType then
          begin
            break;
          end
          else
          begin
            ParameterCheck := nil;
          end;
        end;
        if ParameterCheck = nil then
        begin
          ParameterCheck := TParameterCheck.Create;
          ParameterCheck.ParameterType := ParameterType;
          ParameterCheckList.Add(ParameterCheck);
        end;

        AGrid := ClusterGrid.Grids[ParameterIndex-1];
        for UnitIndex := 1 to AGrid.RowCount -1 do
        begin
          AString := AGrid.Cells[0,UnitIndex];
          if AString <> '' then
          begin
            try
              ParameterCheck.Units.Add(AString);
            except On EConvertError do
              begin
              end;
            end;
          end;
        end;
      end;

      for UnitIndex := 1 to framHUF1.dgHufUnits.RowCount -1 do
      begin
        Units.Add(framHUF1.dgHufUnits.Cells[0,UnitIndex]);
      end;

      for UnitIndex := 1 to dgGeol.RowCount -1 do
      begin
        if Simulated(UnitIndex) then
        begin
          GeoUnits.Add(IntToStr(UnitIndex));
        end;
      end;


      for ParameterCheckIndex := 0 to ParameterCheckList.Count -1 do
      begin
        ParameterCheck := ParameterCheckList[ParameterCheckIndex]
          as TParameterCheck;
        if ParameterCheck.ParameterType = hufLVDA then
        begin
          // LVDA
          for UnitIndex := 0 to GeoUnits.Count -1 do
          begin
            AUnit := GeoUnits[UnitIndex];
            if ParameterCheck.Units.IndexOf(AUnit) < 0 then
            begin
              Errors.Add(ParameterTypeToString(ParameterCheck.ParameterType)
                + ', ' + AUnit);
            end;
          end;
        end
        else
        begin
          for UnitIndex := 0 to Units.Count -1 do
          begin
            AUnit := Units[UnitIndex];
            if ParameterCheck.Units.IndexOf(AUnit) < 0 then
            begin
              Errors.Add(ParameterTypeToString(ParameterCheck.ParameterType)
                + ', ' + AUnit);
            end;
          end;
        end;


      end;
    end;
    if Errors.Count > 0 then
    begin
      AString := 'Error: Some parameter types in the Hydrogeologic Unit Flow package '
        + 'were not applied properly to all appropriate HUF geologic units even '
        + 'though they were applied to some of the HUF geologic units.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'The following parameter types need to be applied to the '
        + 'following HUF geologic units if they are to be applied to any HUF geologic '
        + 'unit. (Parameter type, HUF Geologic unit)';
      ErrorMessages.Add(AString);

      ErrorMessages.AddStrings(Errors);
    end;

  finally
    Units.Free;
    GeoUnits.Free;
    ParameterCheckList.Free;
    Errors.Free;
  end;
  Application.ProcessMessages;
end;

procedure THUF_Writer.EvaluateDataSets6to8(
  const CurrentModelHandle: ANE_PTR;
  const Discretization: TDiscretizationWriter);
var
  HUF_Index : integer;
  LayerName : string;
  RowIndex, ColIndex, BlockIndex: integer;
  ABlock : TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  TopParamName, ThickParamName : string;
  TopExpression, ThicknessExpression: string;
  Layer : TLayerOptions;
begin
  TopParamName := ModflowTypes.GetMFHUFTopParamType.ANE_ParamName;
  ThickParamName := ModflowTypes.GetMFHUFThicknessParamType.ANE_ParamName;
  with frmModflow.framHUF1.dgHufUnits do
  begin
    setLength(Tops, Discretization.NCOL, Discretization.NROW, RowCount -1);
    setLength(Thicknesses, Discretization.NCOL, Discretization.NROW, RowCount -1);
    for HUF_Index := 1 to RowCount -1 do
    begin
      frmProgress.lblActivity.Caption := 'evaluating tops and thicknesses of HUF unit ' + IntToStr(HUF_Index);
      LayerName := Cells[0,HUF_Index];
      TopExpression := LayerName + '.' + TopParamName;
      ThicknessExpression := LayerName + '.' + ThickParamName;
      frmProgress.pbActivity.Position := 0;
      frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
      Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
      try
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
            finally
              ABlock.Free;
            end;

            Tops[ColIndex, RowIndex, HUF_Index-1] :=
              Layer.RealValueAtXY(CurrentModelHandle, X, Y, TopExpression);
            Thicknesses[ColIndex, RowIndex, HUF_Index-1] :=
              Layer.RealValueAtXY(CurrentModelHandle, X, Y, ThicknessExpression);
            if Thicknesses[ColIndex, RowIndex, HUF_Index-1] <0 then
            begin
              Thicknesses[ColIndex, RowIndex, HUF_Index-1] := 0;
            end;
            frmProgress.pbActivity.StepIt;
          end;
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then break;
    end;
  end;
end;

procedure THUF_Writer.SetWetDryArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  AValue : ANE_DOUBLE;
  Count : integer;
begin
  if WettingIsActive then
  begin
    SetLength(WETDRY, Discretization.NCOL, Discretization.NROW,
      Discretization.NUNITS);
    Count := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if frmMODFLOW.Simulated(UnitIndex)
        and (frmMODFLOW.ModflowLayerWet(UnitIndex) <> 0) then
      begin
        Inc(Count);
      end;
    end;


    frmProgress.lblActivity.Caption := 'evaluating WETDRY';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Count;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if frmMODFLOW.Simulated(UnitIndex)
          and (frmMODFLOW.ModflowLayerWet(UnitIndex) <> 0) then
        begin
          ParameterName := ModflowTypes.GetMFGridWettingParamType.WriteParamName
            + IntToStr(UnitIndex);
          ParameterIndex := GridLayer.GetParameterIndex
            (CurrentModelHandle,ParameterName);

          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              if BasicPkg.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
              begin
                WETDRY[ColIndex, RowIndex, UnitIndex-1] := 0;
              end
              else
              begin
                BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  AValue :=
                    ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                  if Abs(AValue) < MinSingle then
                  begin
                    AValue := 0.0;
                  end;
                  WETDRY[ColIndex, RowIndex, UnitIndex-1] := AValue;
                finally
                  ABlock.Free;
                end;
              end;
              frmProgress.pbActivity.StepIt;
            end;
          end;
        end;
      end;
    finally
      GridLayer.Free(CurrentModelHandle);
    end;
  end;
end;

function THUF_Writer.Trans(ColIndex, RowIndex, UnitIndex: integer;
  Discretization: TDiscretizationWriter): double;
begin
  result := 1;
end;

procedure THUF_Writer.WriteDataSet1{(Discretization: TDiscretizationWriter)};
var
  IHUFCB, NHUF, NPHUF, IOHUFHEADS, IOHUFFLOWS : integer;
  HDRY : double;
  Index: integer;
  ParamIndex: hufParameterType;
begin
  with frmModflow do
  begin
    if cbFlowHUF.Checked then
    begin
      IHUFCB := GetUnitNumber('BUD')
    end
    else
    begin
      IHUFCB := 0;
    end;
    HDRY := InternationalStrToFloat(adeHDRY.Text);
    NHUF := framHUF1.dgHufUnits.RowCount -1;
    NPHUF := 0;
    for Index := 1 to dgHUFParameters.RowCount -1 do
    begin
      ParamIndex := frmModflow.EvaluateHUFParameter(Index);
      Assert(ParamIndex in [Low(hufParameterType)..High(hufParameterType)]);
      if not (ParamIndex in [hufKDEP, hufLVDA]) then
      begin
        Inc(NPHUF);
      end;
    end;

    IOHUFHEADS := 0;
    if frmModflow.cbSaveHufHeads.Checked then
    begin
      case frmModflow.comboExportHead.ItemIndex of
        1:
          begin
            IOHUFHEADS := GetUnitNumber('HHD');
          end;
        0,2:
          begin
            IOHUFHEADS := GetUnitNumber('HBH');
          end;
      else Assert(False);
      end;
    end;


    if cbSaveHufFlows.Checked then
    begin
      IOHUFFLOWS := GetUnitNumber('HFLW');
    end
    else
    begin
      IOHUFFLOWS := 0;
    end;

    writeLn(FFile, IHUFCB, ' ', FreeFormattedReal(HDRY), NHUF, ' ', NPHUF,
      ' ', IOHUFHEADS, ' ', IOHUFFLOWS);
  end;
end;

procedure THUF_Writer.WriteDataSet12;
const
  PRINTCODE = '12';
  PRINTFLAGS = 'ALL';
var
  HUF_Index : integer;
  HGUNAM : string;
begin
  with frmModflow.framHUF1.dgHufUnits do
  begin
    for HUF_Index := 1 to RowCount -1 do
    begin
      HGUNAM := Cells[0,HUF_Index];
      writeln(FFile, 'PRINT ', HGUNAM, ' ', PRINTCODE, ' ', PRINTFLAGS);
    end;
  end;
end;

procedure THUF_Writer.WriteDataSet2;
var
  UnitIndex, DisIndex : integer;
  LTHUF : integer;
begin
  with frmModflow do
  begin
    for UnitIndex := 1 to UnitCount do
    begin
      if Simulated(UnitIndex) then
      begin
        LTHUF := ModflowLayerType(UnitIndex);
        for DisIndex := 1 to DiscretizationCount(UnitIndex) do
        begin
          writeln(FFile, LTHUF);
        end;
      end;
    end;
  end;
end;

procedure THUF_Writer.WriteDataSet3;
var
  UnitIndex, DisIndex : integer;
  LAYWT : integer;
begin
  WettingIsActive := False;
  with frmModflow do
  begin
    for UnitIndex := 1 to UnitCount do
    begin
      if Simulated(UnitIndex) then
      begin
        LAYWT := ModflowLayerWet(UnitIndex);
        for DisIndex := 1 to DiscretizationCount(UnitIndex) do
        begin
          writeln(FFile, LAYWT);
        end;
        if LAYWT = 1 then
        begin
          WettingIsActive := True;
        end;
      end;
    end;
  end;
end;

procedure THUF_Writer.WriteDataSet4;
var
  WETFCT : double;
  IWETIT, IHDWET: integer;
begin
  if WettingIsActive then
  begin
    with frmModflow do
    begin
      WETFCT := InternationalStrToFloat(adeWettingFact.Text);
      IWETIT := StrToInt(adeWetIterations.Text);
      IHDWET := comboWetEq.ItemIndex;
      Writeln(FFile, FreeFormattedReal(WETFCT), IWETIT, ' ', IHDWET);
    end;
  end;
end;


procedure THUF_Writer.WriteDataSet5(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter;
  LakeWriter: TLakeWriter; ReservoirWriter: TReservoirWriter);
var
  LayerIndex, UnitIndex, DiscretizationIndex : integer;
begin
  if WettingIsActive then
  begin
    LayerIndex := 0;
    SetWetDryArray(CurrentModelHandle, Discretization, BasicPkg);
    for UnitIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        for DiscretizationIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          if (frmMODFLOW.ModflowLayerWet(UnitIndex) <> 0)then
          begin
            WriteWETDRY(UnitIndex, Discretization, LakeWriter,
              ReservoirWriter, LayerIndex);
          end;
          Inc(LayerIndex);
        end;
      end;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then break;
    end;
  end;
end;

procedure THUF_Writer.WriteDataSet9;
var
  HUF_Index : integer;
  HGUNAM : string;
  HGUHANI, HGUVANI : DOUBLE;
begin
  with frmModflow.framHUF1.dgHufUnits do
  begin
    for HUF_Index := 1 to RowCount -1 do
    begin
      HGUNAM := Cells[Ord(hufName), HUF_Index];
      HGUHANI := InternationalStrToFloat(Cells[Ord(hufHorzAniso), HUF_Index]);
      HGUVANI := InternationalStrToFloat(Cells[Ord(hufVertAniso), HUF_Index]);
      writeln(FFile, HGUNAM, ' ', FreeFormattedReal(HGUHANI),
        FreeFormattedReal(HGUVANI));
    end;

  end;
end;

procedure THUF_Writer.WriteDataSets10to11;
begin
  WriteClusters([hufHK, hufHani, hufVK, hufVANI, hufSS, hufSY, hufSYTP]);
end;

procedure THUF_Writer.WriteDataSets6to8(const CurrentModelHandle: ANE_PTR;
  const Discretization: TDiscretizationWriter);
var
  HUF_Index : integer;
  LayerName : string;
  RowIndex, ColIndex: integer;
begin
  EvaluateDataSets6to8(CurrentModelHandle, Discretization);
  with frmModflow.framHUF1.dgHufUnits do
  begin
    for HUF_Index := 1 to RowCount -1 do
    begin
      // data set 6
      LayerName := Cells[0,HUF_Index];
      WriteLn(FFile, LayerName);

      // data set 7
      frmProgress.lblActivity.Caption := 'writing top of HUF unit ' + IntToStr(HUF_Index);
      WriteU2DRELHeader;
      frmProgress.pbActivity.Position := 0;
      frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
      for RowIndex := 0 to Discretization.NROW -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          write(FFile, FreeFormattedReal(
            Tops[ColIndex, RowIndex, HUF_Index-1]));
          frmProgress.pbActivity.StepIt;
        end;
        writeln(FFile);
      end;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then break;

      // data set 8
      frmProgress.lblActivity.Caption := 'writing thickness of HUF unit ' + IntToStr(HUF_Index);
      WriteU2DRELHeader;
      frmProgress.pbActivity.Position := 0;
      frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
      for RowIndex := 0 to Discretization.NROW -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          write(FFile, FreeFormattedReal(
            Thicknesses[ColIndex, RowIndex, HUF_Index-1]));
          frmProgress.pbActivity.StepIt;
        end;
        writeln(FFile);
      end;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then break;
    end;
  end;
end;

procedure THUF_Writer.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
  ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter;
  LakeWriter: TLakeWriter; ReservoirWriter : TReservoirWriter);
var
  FileName : String;
  MaxProgress: integer;
begin
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Hydrogeologic Unit Flow';

    frmProgress.pbPackage.Position := 0;
    MaxProgress := 1;
    if frmModflow.HufParameterUsed(hufLVDA) then
    begin
      Inc(MaxProgress);
    end;
    if frmModflow.HufParameterUsed(hufKDEP) then
    begin
      Inc(MaxProgress);
    end;

    frmProgress.pbPackage.Max := MaxProgress;

    FileName := GetCurrentDir + '\' + Root + rsHUF;
    AssignFile(FFile,FileName);
    try
      frmProgress.pbPackage.Position := 0;
      frmProgress.pbPackage.Max := frmModflow.framHUF1.dgHufUnits.RowCount*3;
      if WettingIsActive then
      begin
        frmProgress.pbPackage.Max := frmProgress.pbPackage.Max
          + frmModflow.UnitCount*2
      end;

      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;
      WriteDataSet2;
      WriteDataSet3;
      WriteDataSet4;
      WriteDataSet5(CurrentModelHandle, Discretization, BasicPkg,
        LakeWriter, ReservoirWriter);

      Application.ProcessMessages;
      if not ContinueExport then Exit;

      WriteDataSets6to8(CurrentModelHandle, Discretization);

      Application.ProcessMessages;
      if not ContinueExport then Exit;

      WriteDataSet9;
      WriteDataSets10to11;
      WriteDataSet12;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    finally
      CloseFile(FFile);
    end;

    if frmModflow.HufParameterUsed(hufLVDA) then
    begin
      FileName := GetCurrentDir + '\' + Root + rsLVDA;
      AssignFile(FFile,FileName);
      try
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        WriteLVDA_DataSet1;
        WriteLVDA_DataSets2to3;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      finally
        CloseFile(FFile);
      end;
    end;

    if frmModflow.HufParameterUsed(hufKDEP) then
    begin
      FileName := GetCurrentDir + '\' + Root + rsKDEP;
      AssignFile(FFile,FileName);
      try
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        WriteKDEP_DataSet1;
        WriteKDEP_DataSet2(CurrentModelHandle, Discretization, BasicPkg);
        WriteKDEP_DataSets3to4;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      finally
        CloseFile(FFile);
      end;
    end;
    CheckParameterCoverage;

    Application.ProcessMessages;
  end;
end;

procedure THUF_Writer.WriteLVDA_DataSet1;
var
  NPLVDA: integer;
  Index: integer;
  ParamIndex: hufParameterType;
begin
  with frmModflow do
  begin
    NPLVDA := 0;
    for Index := 1 to dgHUFParameters.RowCount -1 do
    begin
      ParamIndex := frmModflow.EvaluateHUFParameter(Index);
      Assert(ParamIndex in [Low(hufParameterType)..High(hufParameterType)]);
      if ParamIndex = hufLVDA then
      begin
        Inc(NPLVDA);
      end;
    end;

    writeLn(FFile, NPLVDA);
  end;
end;

procedure THUF_Writer.WriteLVDA_DataSets2to3;
begin
  WriteClusters([hufLVDA]);
end;

procedure THUF_Writer.WriteWETDRY(UnitNumber: integer;
  Discretization: TDiscretizationWriter; LakeWriter: TLakeWriter;
  ReservoirWriter : TReservoirWriter;
  LayerIndex : integer);
var
  ColIndex, RowIndex : integer;
  Number : double;
begin
  frmProgress.lblActivity.Caption := 'writing WETDRY';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

  WriteU2DRELHeader;
  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;
      Number := WETDRY[ColIndex,RowIndex,UnitNumber-1];
      if (LakeWriter <> nil) and
        (LakeWriter.LakeNumberArray[ColIndex,RowIndex,LayerIndex] <> 0) then
      begin
        Number := 0;
      end;
      if (ReservoirWriter <> nil) and (ReservoirWriter.
        ReservoirLayerArray[ColIndex,RowIndex] > LayerIndex+1) then
      begin
        Number := 0;
      end;
      Write(FFile, FreeFormattedReal(Number));

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;


procedure THUF_Writer.WriteKDEP_DataSet1;
var
  NPKDEP, IFKDEP: integer;
  Index: integer;
  ParamIndex: hufParameterType;
begin
  with frmModflow do
  begin
    NPKDEP := 0;
    for Index := 1 to dgHUFParameters.RowCount -1 do
    begin
      ParamIndex := frmModflow.EvaluateHUFParameter(Index);
      Assert(ParamIndex in [Low(hufParameterType)..High(hufParameterType)]);
      if ParamIndex = hufKDEP then
      begin
        Inc(NPKDEP);
      end;
    end;

    if frmModflow.cbHUF_ReferenceSurface.Checked then
    begin
      IFKDEP := 1;
    end
    else
    begin
      IFKDEP := 0;
    end;

    writeLn(FFile, NPKDEP, ' ', IFKDEP);
  end;
end;

procedure THUF_Writer.WriteKDEP_DataSet2(const CurrentModelHandle: ANE_PTR;
  const Discretization: TDiscretizationWriter;
  const BasicPackage: TBasicPkgWriter);
const
  Zero : double = 0.;
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  ReferenceSurfaceLayer : TLayerOptions;
  AValue : ANE_DOUBLE;
  ReferenceSurfaceLayerHandle : ANE_PTR;
  Project : TProjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
begin
  if not frmModflow.cbHUF_ReferenceSurface.Checked then
  begin
    Exit;
  end;
  try
    frmProgress.lblActivity.Caption := 'writing HUF Reference Surface';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    Project := TProjectOptions.Create;
    try
      ReferenceSurfaceLayerHandle := Project.GetLayerByName(CurrentModelHandle,
        ModflowTypes.GetMFHUF_ReferenceSurfaceLayerClassType.WriteNewRoot);
    finally
      Project.Free;
    end;

    if ReferenceSurfaceLayerHandle <> nil then
    begin
      GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
      ReferenceSurfaceLayer := TLayerOptions.Create(ReferenceSurfaceLayerHandle);
      try
        ParameterName := ModflowTypes.GetMFHUF_ReferenceSurfaceParamClassType.
          WriteParamName;

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

                  Write(FFile, AValue, ' ');

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
        ReferenceSurfaceLayer.Free(CurrentModelHandle);
      end;
    end;
  except On Exception do
    begin
      ShowMessage('Argh');
    end;
  end;
end;

procedure THUF_Writer.WriteClusters(
  const AllowedTypes: THufParameterTypes);
var
  PARNAM : string;
  PARTYPE : string;
  Parval : double;
  NCLU : integer;
  ParameterIndex, ClusterIndex : integer;
  TypeIndex : hufParameterType;
  ADataGrid : TDataGrid;
  HGUNAM : string;
  Mltarr, Zonarr : string;
  Zones : string;
  ZoneIndex : integer;
  AZone : string;
  ZoneErrors : TStringList;
  AString : string;
begin
  ZoneErrors := TStringList.Create;
  try
    with frmModflow do
    begin
      for ParameterIndex := 1 to dgHUFParameters.RowCount -1 do
      begin
          // data set 3
        with dgHUFParameters do
        begin
          PARNAM := Cells[0,ParameterIndex];
          Parval := InternationalStrToFloat(Cells[2,ParameterIndex]);
          NCLU := StrToInt(Cells[3,ParameterIndex]);
          TypeIndex := frmModflow.EvaluateHUFParameter(ParameterIndex);
          if not (TypeIndex in AllowedTypes) then
          begin
            Continue;
          end;
          PARTYPE := ParameterTypeToString(TypeIndex);
          Writeln(FFile, PARNAM, ' ', PARTYPE, ' ',
            FreeFormattedReal(Parval), NCLU);

        end;
        // data set 11
        ADataGrid := dg3dHUFParameterClusters.Grids[ParameterIndex-1];
        with ADataGrid do
        begin
          for ClusterIndex := 1 to RowCount -1 do
          begin
            HGUNAM := Cells[0,ClusterIndex];
            Mltarr := Cells[1,ClusterIndex];
            Zonarr := Cells[2,ClusterIndex];
            Zones := '';
            if Zonarr <> 'ALL' then
            begin
              for ZoneIndex := 3 to ColCount -1 do
              begin
                AZone := Trim(Cells[ZoneIndex,ClusterIndex]);
                if AZone = '' then
                begin
                  break;
                end
                else
                begin
                  Zones := Zones + AZone + ' ';
                end;
              end;
              Zones := Trim(Zones);
              if Zones = '' then
              begin
                ZoneErrors.Add(PARNAM);
              end;
            end;
            writeln(FFile, HGUNAM, ' ', Mltarr, ' ', Zonarr, ' ', Zones);
          end;
        end;
      end;
    end;
    if ZoneErrors.Count <> 0 then
    begin
      AString := 'Error: Some parameters in the HydroGeologic Unit Flow package '
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

procedure THUF_Writer.WriteKDEP_DataSets3to4;
begin
  WriteClusters([hufKDEP]);
end;

class procedure THUF_Writer.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowHUF.Checked then
    begin
      GetUnitNumber('BUD')
    end;

    if frmModflow.cbSaveHufHeads.Checked then
    begin
      case frmModflow.comboExportHead.ItemIndex of
        1:
          begin
            GetUnitNumber('HHD');
          end;
        0,2:
          begin
            GetUnitNumber('HBH');
          end;
      else Assert(False);
      end;
    end;

    if cbSaveHufFlows.Checked then
    begin
      GetUnitNumber('HFLW');
    end;

  end;
end;

{ TParameterCheck }

constructor TParameterCheck.Create;
begin
  inherited;
  Units := TStringList.Create;
  Units.Sorted := True;
  Units.Duplicates := dupIgnore
end;

destructor TParameterCheck.Destroy;
begin
  Units.Free;
  inherited;
end;

end.
