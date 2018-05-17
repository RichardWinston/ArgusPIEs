unit WriteLayerPropertyFlow;

interface

uses Sysutils, Classes, Grids, Forms, ANEPIE, WriteBCF_Unit,
  WriteModflowDiscretization, WriteModflowZonesUnit, WriteMultiplierUnit,
  IntListUnit, WriteLakesUnit, WriteReservoirUnit;

type
  EInvalidType = Class(Exception);

  TLayerPropertyWriter = class(TFlowWriter)
  private
    HKParametersUsed : boolean;
    VKParametersUsed : boolean;
    VANIParametersUsed : boolean;
    SSParametersUsed : boolean;
    SYParametersUsed : boolean;
    VKCBParametersUsed : boolean;
    HANIParametersUsed : boolean;
    HaniUsed : boolean;
    SyUsed : boolean;
    WetDryUsed : boolean;
    HK : array of array of array of ANE_DOUBLE;
    HANI : array of array of array of ANE_DOUBLE;
    Kz : array of array of array of ANE_DOUBLE;
    SS : array of array of array of ANE_DOUBLE;
    Sy : array of array of array of ANE_DOUBLE;
    WETDRY : array of array of array of ANE_DOUBLE;
    procedure SetPropertyArrayLengths(Discretization : TDiscretizationWriter);
    procedure SetHKMember(Col, Row, UnitIndex : integer;
    Value : double);
    procedure WriteDataSet1(Discretization: TDiscretizationWriter);
    procedure WriteLayType(Discretization: TDiscretizationWriter) ;
    procedure WriteLayAvg;
    procedure WriteCHANI;
    procedure WriteLAYVKA;
    procedure WriteLayWet;
    procedure WriteDataSet7;
    procedure WriteDataSets8and9(Discretization: TDiscretizationWriter;
      ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter);
    procedure WriteDataSets10to16(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
      LakeWriter: TLakeWriter; ReservoirWriter : TReservoirWriter;
      ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter);
    procedure WriteHK(UnitNumber: integer;
      Discretization: TDiscretizationWriter);
    procedure SetHaniArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure WriteHANI(UnitNumber: integer;
      Discretization: TDiscretizationWriter);
    procedure SetKzArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure WriteKz(UnitNumber: integer;
      Discretization: TDiscretizationWriter);
    procedure SetSSArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure SetSSMember(Col, Row, UnitIndex: integer; Value: double);
    procedure WriteSS(UnitNumber: integer;
      Discretization: TDiscretizationWriter);
    procedure SetSyArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure WriteSy(UnitNumber: integer;
      Discretization: TDiscretizationWriter);
    procedure SetWetDryArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure WriteWETDRY(UnitNumber: integer;
      Discretization: TDiscretizationWriter; LakeWriter: TLakeWriter;
      ReservoirWriter : TReservoirWriter;
      LayerIndex : integer);
    procedure SetHKArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure SetAHKArrayWithParameters(Discretization: TDiscretizationWriter;
      ZoneWriter: TZoneWriter;
      Multipliers: TMultiplierWriter; ZoneName, MultName: string;
      Zones: TIntegerList; UnitIndex : integer; Parval : Double);
    procedure SetHKArrayWithParameters(
      Discretization: TDiscretizationWriter; ZoneWriter: TZoneWriter;
      Multipliers: TMultiplierWriter);
    procedure WritePrintFormat;
    procedure SetSyUsed(Discretization: TDiscretizationWriter);
    procedure CheckParameterCoverage;
  public
    procedure SetHK(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
      ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter);
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
      ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter;
      LakeWriter: TLakeWriter; ReservoirWriter : TReservoirWriter);
    function Trans(ColIndex, RowIndex, UnitIndex: integer;
      Discretization : TDiscretizationWriter) : double; override;
    class procedure AssignUnitNumbers;
  end;

implementation

uses Variables, ModflowUnit, OptionsUnit, ProgressUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions, DataGrid, StringGrid3d, contnrs;

{ TLayerPropertyWriter }

Type
  TParameterCheck = class
    ParameterType : integer;
    Units : TIntegerList;
    Constructor Create;
    Destructor Destroy; override;
  end;

procedure TLayerPropertyWriter.SetPropertyArrayLengths(
  Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex, UnitIndex : integer;
begin
  with Discretization do
  begin
    SetLength(HK, NCOL, NROW, NUNITS);
    for ColIndex := 0 to NCOL -1 do
    begin
      for RowIndex := 0 to NROW-1 do
      begin
        for UnitIndex := 0 to NUNITS-1 do
        begin
          HK[ColIndex,RowIndex,UnitIndex] := 0;
        end;
      end;
    end;
    if HaniUsed then
    begin
      SetLength(HANI, NCOL, NROW, NUNITS);
    end;
    if not VKParametersUsed and not VANIParametersUsed then
    begin
      SetLength(Kz, NCOL, NROW, NUNITS);
    end;
    if Discretization.Transient and not SSParametersUsed then
    begin
      SetLength(SS, NCOL, NROW, NUNITS);
    end;
    if Discretization.Transient and SyUsed and not SYParametersUsed then
    begin
      SetLength(Sy, NCOL, NROW, NUNITS);
    end;
    if WetDryUsed then
    begin
      SetLength(WETDRY, NCOL, NROW, NUNITS);
    end;
  end;
end;

procedure TLayerPropertyWriter.SetKzArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
begin
  frmProgress.lblActivity.Caption := 'evaluating vertical hydraulic conductivity';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW
    * Discretization.NCOL * Discretization.NUNITS;

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if (frmMODFLOW.Simulated(UnitIndex)
        and not VKParametersUsed and not VANIParametersUsed)
        or
        (not frmMODFLOW.Simulated(UnitIndex)
        and not VKCBParametersUsed ) then

      begin
        ParameterName := ModflowTypes.GetMFGridKzParamType.WriteParamName + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

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
              Kz[ColIndex, RowIndex, UnitIndex-1] :=
               ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
            finally
              ABlock.Free;
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

procedure TLayerPropertyWriter.SetSSArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
begin
  if Discretization.Transient and not SSParametersUsed then
  begin
    frmProgress.lblActivity.Caption := 'evaluating specific storage';
    SetUnitDoubleArray(CurrentModelHandle, Discretization, SetSSMember,
      ModflowTypes.GetMFGridSpecStorParamType.WriteParamName, BasicPkg);
  end;
end;

procedure TLayerPropertyWriter.SetHKArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
begin
  if not HKParametersUsed then
  begin
    frmProgress.lblActivity.Caption := 'evaluating horizontal hydraulic conductivity';
    SetUnitDoubleArray(CurrentModelHandle, Discretization, SetHKMember,
      ModflowTypes.GetMFGridKxParamType.WriteParamName, BasicPkg);
  end;
end;

procedure TLayerPropertyWriter.SetHKArrayWithParameters
  (Discretization: TDiscretizationWriter; ZoneWriter: TZoneWriter;
      Multipliers: TMultiplierWriter);
var
  ParameterIndex, ClusterIndex, ZoneIndex : integer;
  AStringGrid : TStringGrid;
  TypeIndex : integer;
  Parval : double;
  Zone : integer;
  ZoneString : string;
  UnitNumber : integer;
  Mltarr, Zonarr : string;
  ZoneList : TIntegerList;
  Value: string;
begin
  ZoneList := TIntegerList.Create;
  try
    with frmMODFLOW do
    begin
      // loop over the parameters
      for ParameterIndex := 1 to dgLPFParameters.RowCount -1 do
      begin
        // set the Parameter type
        TypeIndex := dgLPFParameters.Columns[1].PickList.IndexOf
          (dgLPFParameters.Cells[1,ParameterIndex]);
        if TypeIndex = 0 then
        begin
          HKParametersUsed := True;

          Value := '';
          if not GetSensitivityValue(dgLPFParameters.Cells[0, ParameterIndex], Value)
            then
          begin
            Value := dgLPFParameters.Cells[2, ParameterIndex];
          end;

          Parval := InternationalStrToFloat(Value);

          AStringGrid:= dg3dLPFParameterClusters.Grids[ParameterIndex-1];

          for ClusterIndex := 1 to AStringGrid.RowCount -1 do
          begin
            // set multiplier array and zone array
            Mltarr := UpperCase(AStringGrid.Cells[1,ClusterIndex]);
            Zonarr := UpperCase(AStringGrid.Cells[2,ClusterIndex]);

            ZoneList.Clear;
            if Zonarr <> 'ALL' then
            begin
              for ZoneIndex := 3 to AStringGrid.ColCount -1 do
              begin
                try
                  ZoneString := Trim(AStringGrid.Cells[ZoneIndex,ClusterIndex]);
                  if ZoneString <> '' then
                  begin
                    Zone := StrToInt(ZoneString);
                    ZoneList.Add(Zone);
                  end;
                except on EConvertError do
                  begin
                  end;
                end;
              end;
            end;

            UnitNumber := StrToInt(AStringGrid.Cells[0,ClusterIndex]);

            if TypeIndex = 0 then
            begin
              SetAHKArrayWithParameters(Discretization, ZoneWriter,
                Multipliers, Zonarr, Mltarr, ZoneList, UnitNumber, Parval);
            end;
          end;
        end;
      end;
    end;
  finally
    ZoneList.Free;
  end;
end;

procedure TLayerPropertyWriter.SetAHKArrayWithParameters
  (Discretization: TDiscretizationWriter; ZoneWriter : TZoneWriter;
  Multipliers : TMultiplierWriter; ZoneName, MultName : string;
  Zones : TIntegerList; UnitIndex : integer; Parval : Double);
var
  ColIndex, RowIndex : integer;
  ZoneIndex, MultIndex : integer;
begin
  for ColIndex := 0 to Discretization.NCOL -1 do
  begin
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      ZoneIndex := ZoneWriter.ZoneNames.IndexOf(ZoneName);
      If (ZoneName = 'ALL') or (Zones.IndexOf
        (ZoneWriter.ZoneArray[ColIndex,RowIndex,ZoneIndex]) > -1) then
      begin
        MultIndex := Multipliers.Names.IndexOf(MultName);
        If (MultName = 'NONE') then
        begin
          HK[ColIndex,RowIndex,UnitIndex-1] := HK[ColIndex,RowIndex,UnitIndex-1]
            + Parval;
        end
        else
        begin
          HK[ColIndex,RowIndex,UnitIndex-1] := HK[ColIndex,RowIndex,UnitIndex-1]
            + (Parval *
            Multipliers.Multipliers[ColIndex,RowIndex,MultIndex]);
        end;
      end;
    end;
  end;
end;

procedure TLayerPropertyWriter.SetHaniArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
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
  if not HANIParametersUsed and HaniUsed then
  begin
    Count := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1])
        and (frmMODFLOW.dgGeol.Cells[Ord(nuiSpecAnis),UnitIndex] =
        frmMODFLOW.dgGeol.Columns[Ord(nuiSpecAnis)].PickList[1]) then
      begin
        Inc(Count);
      end;
    end;

    frmProgress.lblActivity.Caption := 'evaluating anisotropy';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Count;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1])
          and (frmMODFLOW.dgGeol.Cells[Ord(nuiSpecAnis),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSpecAnis)].PickList[1]) then
        begin
          ParameterName := ModflowTypes.GetMFGridAnisoParamType.WriteParamName + IntToStr(UnitIndex);
          ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

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
                HANI[ColIndex, RowIndex, UnitIndex-1] := 1;
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
                  HANI[ColIndex, RowIndex, UnitIndex-1] := AValue;
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

procedure TLayerPropertyWriter.SetSyArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
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
  if SyUsed then
  begin
    Count := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1])
        and (frmMODFLOW.dgGeol.Cells[Ord(nuiType),UnitIndex] <>
        frmMODFLOW.dgGeol.Columns[Ord(nuiType)].PickList[0]) then
      begin
        Inc(Count);
      end;
    end;

    frmProgress.lblActivity.Caption := 'evaluating specific yield';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Count;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1])
          and (frmMODFLOW.dgGeol.Cells[Ord(nuiType),UnitIndex] <>
          frmMODFLOW.dgGeol.Columns[Ord(nuiType)].PickList[0]) then
        begin
          ParameterName := ModflowTypes.GetMFGridSpecYieldParamType.WriteParamName + IntToStr(UnitIndex);
          ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

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
                Sy[ColIndex, RowIndex, UnitIndex-1] := 0;
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
                  Sy[ColIndex, RowIndex, UnitIndex-1] := AValue;
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

procedure TLayerPropertyWriter.SetWetDryArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
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
  LayWet : integer;
begin
  if WetDryUsed then
  begin
    Count := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1])
        and (frmMODFLOW.dgGeol.Cells[Ord(nuiType),UnitIndex] <>
        frmMODFLOW.dgGeol.Columns[Ord(nuiType)].PickList[0]) then

      begin
        if (frmMODFLOW.comboWetCap.ItemIndex = 0)
          or (frmMODFLOW.dgGeol.Columns[Ord(nuiWettingActive)].PickList.IndexOf
          (frmMODFLOW.dgGeol.Cells[Ord(nuiWettingActive),UnitIndex]) = 0) then
        begin
          LayWet := 0;
        end
        else
        begin
          LayWet := 1;
        end;
        if LayWet <> 0 then
        begin
          Inc(Count);
        end;
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

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1])
          and (frmMODFLOW.dgGeol.Cells[Ord(nuiType),UnitIndex] <>
          frmMODFLOW.dgGeol.Columns[Ord(nuiType)].PickList[0]) then
        begin

          if (frmMODFLOW.comboWetCap.ItemIndex = 0)
            or (frmMODFLOW.dgGeol.Columns[Ord(nuiWettingActive)].PickList.IndexOf
            (frmMODFLOW.dgGeol.Cells[Ord(nuiWettingActive),UnitIndex]) = 0) then
          begin
            LayWet := 0;
          end
          else
          begin
            LayWet := 1;
          end;
          if LayWet <> 0 then
          begin
            ParameterName := ModflowTypes.GetMFGridWettingParamType.WriteParamName + IntToStr(UnitIndex);
            ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

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
      end;

    finally
      GridLayer.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TLayerPropertyWriter.SetHKMember(Col, Row, UnitIndex: integer;
  Value: double);
begin
  HK[Col, Row, UnitIndex] := Value;
end;

procedure TLayerPropertyWriter.SetSSMember(Col, Row, UnitIndex: integer;
  Value: double);
begin
  SS[Col, Row, UnitIndex] := Value;
end;

procedure TLayerPropertyWriter.WritePrintFormat;
begin
  WriteLn(FFile, IPRN_Real);
end;

procedure TLayerPropertyWriter.WriteCHANI;
const
  Comment = ' ; CHANI(NLAY)';
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  NLAY : Integer;
  CHANI : double;
begin
  HANIParametersUsed := frmMODFLOW.lpfHaniParametersUsed;
  HaniUsed := False;
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        if HANIParametersUsed or
          (dgGeol.Columns[Ord(nuiSpecAnis)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiSpecAnis),UnitIndex]) = 1) then
        begin
          CHANI := -1;
          HaniUsed := True;
        end
        else
        begin
          CHANI := InternationalStrToFloat(dgGeol.Cells[Ord(nuiAnis),UnitIndex]);
        end;

        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);

          if ((LayerNumber mod 8) = 0) or (LayerNumber = NLAY) then
          begin
            if (LayerNumber = NLAY) then
            begin
              Writeln(FFile, FreeFormattedReal(CHANI), Comment);
            end
            else
            begin
              Writeln(FFile, FreeFormattedReal(CHANI));
            end;
          end
          else
          begin
            Write(FFile, FreeFormattedReal(CHANI));
          end;
        end;
      end;
    end;
  end;
end;

procedure TLayerPropertyWriter.WriteLAYVKA;
const
  Comment = ' ; LAYVKA(NLAY)';
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  NLAY : Integer;
  LAYVKA : integer;
  RowIndex, InnerRowIndex : integer;
  VaniString : string;
  AStringGrid : TStringGrid;
  UnitNumber : integer;
begin
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    VaniString := dgLPFParameters.Columns[1].Picklist[2];
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        LAYVKA := 0;
        for RowIndex := 1 to dgLPFParameters.RowCount -1 do
        begin
          if dgLPFParameters.Cells[1,RowIndex] = VaniString then
          begin
            AStringGrid := dg3dLPFParameterClusters.Grids[RowIndex-1];
            for InnerRowIndex := 1 to AStringGrid.RowCount -1 do
            begin
              UnitNumber := StrToInt(AStringGrid.Cells[0,InnerRowIndex]);
              if UnitNumber = UnitIndex then
              begin
                LAYVKA := 1;
                break;
              end;
            end;

          end;
          if LAYVKA = 1 then
          begin
            break;
          end;
        end;

        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);

          if ((LayerNumber mod 25) = 0) or (LayerNumber = NLAY) then
          begin
            if (LayerNumber = NLAY) then
            begin
              Writeln(FFile, LAYVKA, Comment);
            end
            else
            begin
              Writeln(FFile, LAYVKA);
            end;
          end
          else
          begin
            Write(FFile, LAYVKA, ' ');
          end;
        end;
      end;
    end;
  end;
end;

procedure TLayerPropertyWriter.WriteDataSet1(Discretization: TDiscretizationWriter);
const
  Comment = ' ; ILPFCB, HDRY, NPLPF';
var
  HDRY : double;
  NPGHF : integer;
  ParameterIndex : integer;
  WriteClusters : boolean;
  TypeIndex : integer;
  AString : string;
  Option: string;
begin
  SetSyUsed(Discretization);
  with frmModflow do
  begin
    if cbFlowLPF.Checked then
    begin
      Write(FFile, frmModflow.GetUnitNumber('BUD'), ' ');
    end
    else
    begin
      Write(FFile, 0, ' ');
    end;
    HDRY := InternationalStrToFloat(adeHDRY.Text);
    NPGHF := 0;
    for ParameterIndex := 1 to dgLPFParameters.RowCount -1 do
    begin
      WriteClusters := True;

      // set the Parameter type
      TypeIndex := dgLPFParameters.Columns[1].PickList.IndexOf
        (dgLPFParameters.Cells[1,ParameterIndex]);
      Case TypeIndex of
        0, 1, 2, 5, 6: // HK, VK, VANI, VKCB, HANI
          begin
          end;
        3: // SS
          begin
            if not Discretization.Transient then
            begin
              WriteClusters := False;
            end;
          end;
        4: // SY
          begin
            if not (Discretization.Transient and SyUsed) then
            begin
              WriteClusters := False;
            end;
          end;
        else
          begin
            AString := 'Unsupported LPF parameter type = '
              + IntToStr(TypeIndex)
              + ' ('
              + dgLPFParameters.Cells[1,ParameterIndex]
              + ').';
            Raise EInvalidType.Create(AString);
          end
      end;
      if WriteClusters then
      begin
        Inc(NPGHF);
      end;
    end;
    Write(FFile, FreeFormattedReal(HDRY), NPGHF);
    Option := '';
    if frmModflow.rbModflow2005.Checked then
    begin
      if frmModflow.comboVertCond.ItemIndex = 1 then
      begin
        Option := Option + ' CONSTANTCV';
      end;
      if not frmModflow.cbVertCondCorrection.Checked then
      begin
        Option := Option + ' NOCVCORRECTION';
      end;
    end;
    if Option <> '' then
    begin
      Write(FFile, Option);
    end;
    Write(FFile, Comment);
    if Option <> '' then
    begin
      Write(FFile, ' Option');
    end;
    Writeln(FFile);
  end;
end;


procedure TLayerPropertyWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
  ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter;
  LakeWriter: TLakeWriter; ReservoirWriter : TReservoirWriter);
var
  FileName : String;
begin
  CheckParameterCoverage;

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Layer Property Flow';

    FileName := GetCurrentDir + '\' + Root + rsLPF;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1(Discretization);
      WriteLayType(Discretization);
      WriteLayAvg;
      WriteCHANI;
      WriteLAYVKA;
      WriteLayWet;

      if WetDryUsed then
      begin
        WriteDataSet7;
      end;

      WriteDataSets8and9(Discretization, ZoneWriter, Multipliers);
      WriteDataSets10to16(CurrentModelHandle, Discretization, BasicPkg,
        LakeWriter, ReservoirWriter, ZoneWriter, Multipliers);
      Flush(FFile);

    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;


procedure TLayerPropertyWriter.WriteHK(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
Const
  Comment = ' ; HK(NCOL,NROW)';
var
  ColIndex, RowIndex : integer;
  Errors: TStringList;
  ErrorMessage: string;
begin
  Errors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'writing horizontal hydraulic conductivity';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    WriteU2DRELHeader(Comment);
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if HK[ColIndex,RowIndex,UnitNumber-1] < 0 then
        begin
          Errors.Add(IntToStr(ColIndex+1) + ', ' + IntToStr(RowIndex+1)
            + ', ' + IntToStr(UnitNumber));
        end;

        Write(FFile,
          FreeFormattedReal(HK[ColIndex,RowIndex,UnitNumber-1]));

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
    if Errors.Count > 0 then
    begin
      ErrorMessage := 'Error: Negative horizontal hydraulic conductivities in Unit ' +
        IntToStr(UnitNumber);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);

      ErrorMessage := '(Col, Row, Unit)';
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

procedure TLayerPropertyWriter.WriteKz(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
const
  Comment12 = ' ; VKA(NCOL,NROW)';
  Comment15 = ' ; VKCB(NCOL,NROW)';
var
  ColIndex, RowIndex : integer;
  Errors: TStringList;
  ErrorMessage: string;
begin
  Errors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'writing vertical hydraulic conductivity';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    if frmModflow.Simulated(UnitNumber) then
    begin
      WriteU2DRELHeader(Comment12);
    end
    else
    begin
      WriteU2DRELHeader(Comment15);
    end;

    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if Kz[ColIndex,RowIndex,UnitNumber-1] < 0 then
        begin
          Errors.Add(IntToStr(ColIndex+1) + ', ' + IntToStr(RowIndex+1)
            + ', ' + IntToStr(UnitNumber));
        end;
        Write(FFile,
          FreeFormattedReal(Kz[ColIndex,RowIndex,UnitNumber-1]));

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
    if Errors.Count > 0 then
    begin
      ErrorMessage := 'Error: Negative vertical hydraulic conductivities in Unit ' +
        IntToStr(UnitNumber);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);

      ErrorMessage := '(Col, Row, Unit)';
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

procedure TLayerPropertyWriter.WriteWETDRY(UnitNumber: integer;
  Discretization: TDiscretizationWriter; LakeWriter: TLakeWriter;
  ReservoirWriter : TReservoirWriter;
  LayerIndex : integer);
const
  Comment = ' ; WETDRY(NCOL, NROW)';
var
  ColIndex, RowIndex : integer;
  Number : double;
begin
  frmProgress.lblActivity.Caption := 'writing WETDRY';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

  WriteU2DRELHeader(Comment);
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

procedure TLayerPropertyWriter.WriteSS(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
Const
  Comment = ' ; Ss(NCOL,NROW)';
var
  ColIndex, RowIndex : integer;
  Errors: TStringList;
  ErrorMessage: string;
begin
  Errors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'writing specific storage';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    WriteU2DRELHeader(Comment);
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if SS[ColIndex,RowIndex,UnitNumber-1] < 0 then
        begin
          Errors.Add(IntToStr(ColIndex+1) + ', ' + IntToStr(RowIndex+1)
            + ', ' + IntToStr(UnitNumber));
        end;

        Write(FFile, FreeFormattedReal(SS[ColIndex,RowIndex,UnitNumber-1]));

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
    if Errors.Count > 0 then
    begin
      ErrorMessage := 'Error: Negative specific storage in Unit ' +
        IntToStr(UnitNumber);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);

      ErrorMessage := '(Col, Row, Unit)';
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

procedure TLayerPropertyWriter.WriteSy(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
Const
  Comment = ' ; Sy(NCOL,NROW)';
var
  ColIndex, RowIndex : integer;
  Errors: TStringList;
  ErrorMessage: string;
begin
  Errors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'writing specific yield';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    WriteU2DRELHeader(Comment);
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if SY[ColIndex,RowIndex,UnitNumber-1] < 0 then
        begin
          Errors.Add(IntToStr(ColIndex+1) + ', ' + IntToStr(RowIndex+1)
            + ', ' + IntToStr(UnitNumber));
        end;

        Write(FFile,
          FreeFormattedReal(SY[ColIndex,RowIndex,UnitNumber-1]));

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
    if Errors.Count > 0 then
    begin
      ErrorMessage := 'Error: Negative specific yield in Unit ' +
        IntToStr(UnitNumber);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);

      ErrorMessage := '(Col, Row, Unit)';
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

procedure TLayerPropertyWriter.WriteHANI(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
const
  Comment = ' ; HANI(NCOL,NROW)';
var
  ColIndex, RowIndex : integer;
  Errors: TStringList;
  ErrorMessage: string;
begin
  Errors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'writing anisotropy';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

    WriteU2DRELHeader(Comment);
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if HANI[ColIndex,RowIndex,UnitNumber-1] < 0 then
        begin
          Errors.Add(IntToStr(ColIndex+1) + ', ' + IntToStr(RowIndex+1)
            + ', ' + IntToStr(UnitNumber));
        end;
        Write(FFile,
          FreeFormattedReal(HANI[ColIndex,RowIndex,UnitNumber-1]));

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
    if Errors.Count > 0 then
    begin
      ErrorMessage := 'Error: Negative horizontal anisotropy in Unit ' +
        IntToStr(UnitNumber);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);

      ErrorMessage := '(Col, Row, Unit)';
      ErrorMessages.Add(ErrorMessage);
      ErrorMessages.AddStrings(Errors);
    end;
  finally
    Errors.Free;
  end;
end;

procedure TLayerPropertyWriter.WriteLayAvg;
const
  Comment = ' ; LAYAVG(NLAY)';
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  TransmisivityMethod : integer;
  NLAY : Integer;
begin
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        TransmisivityMethod := dgGeol.Columns[Ord(nuiTrans)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiTrans),UnitIndex]);

        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);

          if ((LayerNumber mod 25) = 0) or (LayerNumber = NLAY) then
          begin
            if LayerNumber = NLAY then
            begin
              Writeln(FFile, TransmisivityMethod, Comment);
            end
            else
            begin
              Writeln(FFile, TransmisivityMethod);
            end;
          end
          else
          begin
            Write(FFile, TransmisivityMethod, ' ');
          end;
        end;
      end;
    end;
  end;

end;

procedure TLayerPropertyWriter.SetSyUsed(Discretization: TDiscretizationWriter);
var
  UnitIndex: integer;
  LayerType, ActualLayerType : integer;
begin
  SyUsed := False;
  with frmMODFLOW do
  begin
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiType),UnitIndex]);
        if (LayerType > 1) then
        begin
          ActualLayerType := 1;
        end
        else
        begin
          ActualLayerType := LayerType;
        end;
        if (ActualLayerType <> 0) and Discretization.Transient then
        begin
          SyUsed := True;
          break;
        end;
      end;
    end;
  end;
end;

procedure TLayerPropertyWriter.WriteLayType(Discretization: TDiscretizationWriter);
const
  Comment = ' ; LAYTYP(NLAY)';
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  LayerType, ActualLayerType : integer;
  NLAY  : integer;
begin
  SyUsed := False;
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiType),UnitIndex]);
        if (LayerType > 1) then
        begin
          ActualLayerType := 1;
        end
        else
        begin
          ActualLayerType := LayerType;
        end;
        if (ActualLayerType <> 0) and Discretization.Transient then
        begin
          SyUsed := True;
        end;
        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);

          if ((LayerNumber mod 25) = 0) or (LayerNumber = NLAY) then
          begin
            if (LayerNumber = NLAY) then
            begin
              Writeln(FFile, ActualLayerType, Comment);
            end
            else
            begin
              Writeln(FFile, ActualLayerType);
            end;
          end
          else
          begin
            Write(FFile, ActualLayerType, ' ');
          end;
        end;
      end;
    end;
  end;

end;

procedure TLayerPropertyWriter.WriteLayWet;
const
  Comment = ' ; LAYWET(NLAY)';
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  NLAY : Integer;
  LayWet : Integer;
  LayerType, ActualLayerType : integer;
begin
  WetDryUsed := false;
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiType),UnitIndex]);
        if (LayerType > 1) then
        begin
          ActualLayerType := 1;
        end
        else
        begin
          ActualLayerType := LayerType;
        end;

        if (ActualLayerType = 0) or (comboWetCap.ItemIndex = 0) or
          (dgGeol.Columns[Ord(nuiWettingActive)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiWettingActive),UnitIndex]) = 0) then
        begin
          LayWet := 0;
        end
        else
        begin
          LayWet := 1;
          WetDryUsed := true;
        end;

        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);

          if ((LayerNumber mod 25) = 0) or (LayerNumber = NLAY) then
          begin
            if (LayerNumber = NLAY) then
            begin
              Writeln(FFile, LayWet, Comment);
            end
            else
            begin
              Writeln(FFile, LayWet);
            end;
          end
          else
          begin
            Write(FFile, LayWet, ' ');
          end;
        end;
      end;
    end;
  end;

end;

procedure TLayerPropertyWriter.WriteDataSet7;
const
  Comment = ' ; WETFCT, IWETIT, IHDWET';
var
  WETFCT : double;
  IWETIT : integer;
  IHDWET : integer;
begin
  with frmModflow do
  begin
    WETFCT := InternationalStrToFloat(adeWettingFact.Text);
    IWETIT := StrToInt(adeWetIterations.Text);
    IHDWET := comboWetEq.ItemIndex;
    Writeln(FFile, WETFCT, ' ', IWETIT, ' ', IHDWET, Comment);
  end;
end;

procedure TLayerPropertyWriter.CheckParameterCoverage;
var
  ParameterGrid : TDataGrid;
  ClusterGrid : TRBWDataGrid3D;
  ParameterIndex : integer;
  AGrid : TStringGrid;
  ParameterType : integer;
  ParameterCheckIndex : integer;
  ParameterCheck : TParameterCheck;
  ParameterCheckList : TObjectList;
  UnitIndex : integer;
  AString : string;
  SimulatedUnits : TIntegerList;
  UnSimulatedUnits : TIntegerList;
  UnConfinedUnits: TIntegerList;
  Errors : TStringList;
  AUnit : integer;
  LayerType: integer;
  function ParameterTypeToString(const ParameterType : integer): string;
  begin
    case ParameterType of
      0:
        begin
          result := 'HK';
        end;
      1:
        begin
          result := 'VK';
        end;
      2:
        begin
          result := 'VANI';
        end;
      3:
        begin
          result := 'SS';
        end;
      4:
        begin
          result := 'SY';
        end;
      5:
        begin
          result := 'VKCB';
        end;
      6:
        begin
          result := 'HANI';
        end;
    else Assert(false);
    end;

  end;
begin
  SimulatedUnits := TIntegerList.Create;
  UnSimulatedUnits := TIntegerList.Create;
  UnConfinedUnits := TIntegerList.Create;
  ParameterCheckList := TObjectList.Create;
  Errors := TStringList.Create;
  try
    with frmModflow do
    begin
      ParameterGrid := dgLPFParameters;
      ClusterGrid := dg3dLPFParameterClusters;
      for ParameterIndex := 1 to ParameterGrid.RowCount -1 do
      begin
        ParameterType := ParameterGrid.Columns[1].PickList.IndexOf(ParameterGrid.Cells[1,ParameterIndex]);
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
              ParameterCheck.Units.AddUnique(StrToInt(AString));
            except On EConvertError do
              begin
              end;
            end;
          end;
        end;
      end;

      for UnitIndex := 1 to UnitCount do
      begin
        if Simulated(UnitIndex) then
        begin
          SimulatedUnits.Add(UnitIndex);
          LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (dgGeol.Cells[Ord(nuiType),UnitIndex]);
          if LayerType <> 0 then
          begin
            UnConfinedUnits.Add(UnitIndex);
          end;
        end
        else
        begin
          UnSimulatedUnits.Add(UnitIndex);
        end;
      end;

      for ParameterCheckIndex := 0 to ParameterCheckList.Count -1 do
      begin
        ParameterCheck := ParameterCheckList[ParameterCheckIndex] as TParameterCheck;
        if ParameterCheck.ParameterType = 5 then
        begin
          for UnitIndex := 0 to UnSimulatedUnits.Count -1 do
          begin
            AUnit := UnSimulatedUnits[UnitIndex];
            if ParameterCheck.Units.IndexOf(AUnit) < 0 then
            begin
              Errors.Add(ParameterTypeToString(ParameterCheck.ParameterType)
                + ', ' + IntToStr(AUnit));
            end;
          end;
        end
        else if ParameterCheck.ParameterType = 4 then
        begin
          for UnitIndex := 0 to UnConfinedUnits.Count -1 do
          begin
            AUnit := UnConfinedUnits[UnitIndex];
            if ParameterCheck.Units.IndexOf(AUnit) < 0 then
            begin
              Errors.Add(ParameterTypeToString(ParameterCheck.ParameterType)
                + ', ' + IntToStr(AUnit));
            end;
          end;
        end
        else
        begin
          for UnitIndex := 0 to SimulatedUnits.Count -1 do
          begin
            AUnit := SimulatedUnits[UnitIndex];
            if ParameterCheck.Units.IndexOf(AUnit) < 0 then
            begin
              Errors.Add(ParameterTypeToString(ParameterCheck.ParameterType)
                + ', ' + IntToStr(AUnit));
            end;
          end;
        end;

      end;
    end;
    if Errors.Count > 0 then
    begin
      AString := 'Error: Some parameter types in the Layer Property Flow package '
        + 'were not applied properly to all appropriate geologic units even '
        + 'though they were applied to some of the units.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'The following parameter types need to be applied to the '
        + 'following geologic units if they are to be applied to any geologic '
        + 'unit. (Parameter type, Geologic unit)';
      ErrorMessages.Add(AString);

      ErrorMessages.AddStrings(Errors);
    end;

  finally
    SimulatedUnits.Free;
    UnSimulatedUnits.Free;
    UnConfinedUnits.Free;
    ParameterCheckList.Free;
    Errors.Free;
  end;
  Application.ProcessMessages;
end;

procedure TLayerPropertyWriter.WriteDataSets8and9
  (Discretization: TDiscretizationWriter; ZoneWriter: TZoneWriter;
      Multipliers: TMultiplierWriter);
const
  Comment8 = ' ; PARNAM, PARTYP, Parval, NCLU';
  Comment9 = ' ; Layer, Mltarr, Zonarr, IZ';
var
  ParameterIndex, ClusterIndex, ZoneIndex : integer;
  AStringGrid : TStringGrid;
  TypeIndex : integer;
  PARTYPE : STRING;
  Parval : double;
  NCLU : integer;
  Zone : integer;
  ZoneString : string;
  WriteClusters : boolean;
  ALine : string;
  UnitNumber : integer;
  LayerIndex : integer;
  LayersAbove : integer;
  DiscretizationN : integer;
  Mltarr, Zonarr : string;
  ZoneList : TIntegerList;
  AString : string;
  ZoneErrors : TStringList;
  UnitErrors: TStringList;
begin
  SetPropertyArrayLengths(Discretization);
  ZoneList := TIntegerList.Create;
  ZoneErrors := TStringList.Create;
  UnitErrors := TStringList.Create;
  try
    with frmMODFLOW do
    begin
      // loop over the parameters
      for ParameterIndex := 1 to dgLPFParameters.RowCount -1 do
      begin
        WriteClusters := True;

        // set the Parameter type
        TypeIndex := dgLPFParameters.Columns[1].PickList.IndexOf
          (dgLPFParameters.Cells[1,ParameterIndex]);
        Case TypeIndex of
          0:
            begin
              PARTYPE := 'HK';
              HKParametersUsed := True;
            end;
          1:
            begin
              PARTYPE := 'VK';
              VKParametersUsed := True;
            end;
          2:
            begin
              PARTYPE := 'VANI';
              VANIParametersUsed := True;
            end;
          3:
            begin
              if Discretization.Transient then
              begin
                PARTYPE := 'SS';
                SSParametersUsed := True;
              end
              else
              begin
                WriteClusters := False;
              end;
            end;
          4:
            begin
              if Discretization.Transient and SyUsed then
              begin
                PARTYPE := 'SY';
                SYParametersUsed := True;
              end
              else
              begin
                WriteClusters := False;
              end;
            end;
          5:
            begin
              PARTYPE := 'VKCB';
              VKCBParametersUsed := True;
            end;
          6:
            begin
              PARTYPE := 'HANI';
              self.HANIParametersUsed := True;
            end;
          else
            begin
              AString := 'Unsupported LPF parameter type = '
                + IntToStr(TypeIndex)
                + ' ('
                + dgLPFParameters.Cells[1,ParameterIndex]
                + ').';
              Raise EInvalidType.Create(AString);
            end
        end;
        if WriteClusters then
        begin
          // Count the number of clusters
          NCLU := 0;
          AStringGrid := dg3dLPFParameterClusters.Grids[ParameterIndex-1];
          for ClusterIndex := 1 to AStringGrid.RowCount -1 do
          begin
            UnitNumber := StrToInt(AStringGrid.Cells[0,ClusterIndex]);
            if (UnitNumber > frmModflow.UnitCount) or (UnitNumber < 0) then
            begin
              UnitErrors.Add(IntToStr(UnitNumber));
            end
            else
            begin
              DiscretizationN := DiscretizationCount(UnitNumber);
              NCLU := NCLU + DiscretizationN;
            end;

          end;

          Parval := InternationalStrToFloat(dgLPFParameters.Cells[2,ParameterIndex]);
          // write data set 8
          Writeln(FFile,
            dgLPFParameters.Cells[0,ParameterIndex], ' ',
            PARTYPE, ' ',
            FreeFormattedReal(Parval),
            NCLU, Comment8);

          for ClusterIndex := 1 to AStringGrid.RowCount -1 do
          begin
            // set multiplier array and zone array
            Mltarr := UpperCase(AStringGrid.Cells[1,ClusterIndex]);
            Zonarr := UpperCase(AStringGrid.Cells[2,ClusterIndex]);

            ALine := Format(' %s %s ',
              [Mltarr,
               Zonarr]);

            ZoneList.Clear;
            if Zonarr <> 'ALL' then
            begin
              for ZoneIndex := 3 to AStringGrid.ColCount -1 do
              begin
                try
                  ZoneString := Trim(AStringGrid.Cells[ZoneIndex,ClusterIndex]);
                  if ZoneString <> '' then
                  begin
                    Zone := StrToInt(ZoneString);
                    ZoneList.Add(Zone);
                    ALine := Format(ALine + '%d ',[Zone]);
                  end;
                except on EConvertError do
                  begin
                  end;
                end;
              end;
              if ZoneList.Count = 0 then
              begin
                ZoneErrors.Add(dgLPFParameters.Cells[0,ParameterIndex]);
              end;

            end;

            UnitNumber := StrToInt(AStringGrid.Cells[0,ClusterIndex]);
            if (UnitNumber > frmModflow.UnitCount) or (UnitNumber < 0) then
            begin
              // this error has already been reported.
              Continue;
            end;

            if (TypeIndex = 5) and frmMODFLOW.Simulated(UnitNumber) then  // VKCB
            begin
              Inc(UnitNumber);
            end;


{            if TypeIndex = 0 then
            begin
              SetAHKArrayWithParameters(Discretization, ZoneWriter,
                Multipliers, Zonarr, Mltarr, ZoneList, UnitNumber, Parval);
            end;   }

            LayersAbove := MODFLOWLayersAboveCount(UnitNumber);
            if TypeIndex = 5 then
            begin
                Writeln(FFile, LayersAbove,ALine, Comment9)
            end
            else
            begin
              DiscretizationN := DiscretizationCount(UnitNumber);
              for LayerIndex := 1 to DiscretizationN do
              begin
                Writeln(FFile, LayerIndex+LayersAbove,ALine, Comment9)
              end;
            end;
          end;
        end;
      end;

    end;
    if ZoneErrors.Count <> 0 then
    begin
      AString := 'Error: Some parameters in the Layer Property Flow package '
        + 'did not have zones defined correctly.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'No zones were defined for the following parameters.';
      ErrorMessages.Add(AString);

      ErrorMessages.AddStrings(ZoneErrors);
    end;
    if UnitErrors.Count > 0 then
    begin
      AString := 'Error: Some parameters clusters in the Layer Property Flow package '
        + 'refer to unit numbers that don''t exist.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);

      AString := 'Incorrect units were defined with the following parameters.';
      ErrorMessages.Add(AString);
      AString := '[Parameter number, Incorrect Unit number.';
      ErrorMessages.Add(AString);

      ErrorMessages.AddStrings(UnitErrors);
    end;
  finally
    ZoneList.Free;
    ZoneErrors.Free;
    UnitErrors.Free;
  end;
end;

procedure TLayerPropertyWriter.WriteDataSets10to16(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
  LakeWriter: TLakeWriter; ReservoirWriter : TReservoirWriter;
  ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter);
var
  UnitIndex, DivIndex, LayersPerUnit : integer;
  LayerType, ActualLayerType : integer;
  Count : integer;
  LayWet : integer;
  MFLayer : integer;
begin
  with frmMODFLOW do
  begin
    Count := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if ContinueExport then
      begin
        if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          dgGeol.Columns[Ord(nuiSim)].PickList[1] then
        begin
          LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

          LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (dgGeol.Cells[Ord(nuiType),UnitIndex]);
          if (LayerType > 1) then
          begin
            ActualLayerType := 1;
          end
          else
          begin
            ActualLayerType := LayerType;
          end;


          if WetDryUsed and (dgGeol.Columns[Ord(nuiWettingActive)].PickList.IndexOf
            (dgGeol.Cells[Ord(nuiWettingActive),UnitIndex]) <> 0) then
          begin
            LayWet := 1;
          end
          else
          begin
            LayWet := 0;
          end;

          for DivIndex := 1 to LayersPerUnit do
          begin
              if ContinueExport and not HKParametersUsed then
              begin
                Inc(Count);
              end;

              if ContinueExport and
                (dgGeol.Cells[Ord(nuiSpecAnis),UnitIndex] =
                dgGeol.Columns[Ord(nuiSpecAnis)].PickList[1]) then
              begin
                Inc(Count);
              end;

              if ContinueExport and not VKParametersUsed
                and not VANIParametersUsed then
              begin
                Inc(Count);
              end;

              if ContinueExport and Discretization.Transient
                and not SSParametersUsed then
              begin
                Inc(Count);
              end;

              if ContinueExport and Discretization.Transient
                and not SYParametersUsed and
                (ActualLayerType <> 0) then
              begin
                Inc(Count);
              end;

              if ContinueExport and not VKCBParametersUsed
                and (DivIndex = LayersPerUnit)
                and (UnitIndex < Discretization.NUNITS)
                and (dgGeol.Cells[Ord(nuiSim),UnitIndex+1] =
                     dgGeol.Columns[Ord(nuiSim)].PickList[0]) then
              begin
                Inc(Count);
              end;

              if ContinueExport and
                (ActualLayerType <> 0) and (LayWet <> 0) then
              begin
                Inc(Count);
              end;
          end;
        end;
      end;
    end;

    frmProgress.pbPackage.Max := 7 + Count ;
    frmProgress.pbPackage.Position := 0;

    if ContinueExport then
    begin
      
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetHKArrayWithParameters(Discretization, ZoneWriter, Multipliers);
      SetHKArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetHaniArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetKzArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetSSArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetSyArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetWetDryArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      MFLayer := -1;
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if ContinueExport then
        begin
          if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
            dgGeol.Columns[Ord(nuiSim)].PickList[1] then
          begin
            LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

            LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
              (dgGeol.Cells[Ord(nuiType),UnitIndex]);
            if (LayerType > 1) then
            begin
              ActualLayerType := 1;
            end
            else
            begin
              ActualLayerType := LayerType;
            end;

            if WetDryUsed and (dgGeol.Columns[Ord(nuiWettingActive)].PickList.IndexOf
              (dgGeol.Cells[Ord(nuiWettingActive),UnitIndex]) <> 0) then
            begin
              LayWet := 1;
            end
            else
            begin
              LayWet := 0;
            end;

            for DivIndex := 1 to LayersPerUnit do
            begin

              Inc(MFLayer);
              // data set 10
              if ContinueExport then
              begin
                if HKParametersUsed then
                begin
                  WritePrintFormat;
                end
                else
                begin
                  WriteHK(UnitIndex, Discretization);
                  frmProgress.pbPackage.StepIt;
                  Application.ProcessMessages;
                end;
              end; // if ContinueExport etc.

              // data set 11
              if ContinueExport and
                (HANIParametersUsed or
                (dgGeol.Cells[Ord(nuiSpecAnis),UnitIndex] =
                dgGeol.Columns[Ord(nuiSpecAnis)].PickList[1])) then
              begin
                if HANIParametersUsed then
                begin
                  WritePrintFormat;
                end
                else
                begin
                  WriteHANI(UnitIndex, Discretization);
                  frmProgress.pbPackage.StepIt;
                  Application.ProcessMessages;
                end;
              end; // if ContinueExport etc.

              if ContinueExport then
              begin
                if VKParametersUsed or VANIParametersUsed then
                begin
                  WritePrintFormat;
                end
                else
                begin
                  WriteKz(UnitIndex, Discretization);
                  frmProgress.pbPackage.StepIt;
                  Application.ProcessMessages;
                end;
              end; // if ContinueExport etc.

              if ContinueExport and Discretization.Transient then
              begin
                if SSParametersUsed then
                begin
                  WritePrintFormat;
                end
                else
                begin
                  WriteSS(UnitIndex, Discretization);
                  frmProgress.pbPackage.StepIt;
                  Application.ProcessMessages;
                end;
              end; // if ContinueExport etc.

              if ContinueExport and Discretization.Transient
                and (ActualLayerType <> 0) then
              begin
                if SYParametersUsed then
                begin
                  WritePrintFormat;
                end
                else
                begin
                  WriteSy(UnitIndex, Discretization);
                  frmProgress.pbPackage.StepIt;
                  Application.ProcessMessages;
                end;
              end; // if ContinueExport etc.

              if ContinueExport
                and (DivIndex = LayersPerUnit)
                and (UnitIndex < Discretization.NUNITS)
                and (dgGeol.Cells[Ord(nuiSim),UnitIndex+1] =
                     dgGeol.Columns[Ord(nuiSim)].PickList[0]) then
              begin
                if VKCBParametersUsed then
                begin
                  WritePrintFormat;
                end
                else // if VKCBParametersUsed then
                begin
                  WriteKz(UnitIndex+1, Discretization);
                  frmProgress.pbPackage.StepIt;
                  Application.ProcessMessages;
                end; // if VKCBParametersUsed then else
              end; // if ContinueExport etc

              if ContinueExport and
                (ActualLayerType <> 0) and (LayWet <> 0) then
              begin
                WriteWETDRY(UnitIndex, Discretization, LakeWriter,
                  ReservoirWriter, MFLayer);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end; // if ContinueExport and
                // (ActualLayerType <> 0) and (LayWet <> 0) then

            end; //  for DivIndex := 1 to LayersPerUnit do
          end; // if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
            // dgGeol.Columns[Ord(nuiSim)].PickList[1] then
        end;  // if ContinueExport then
      end;  // for UnitIndex := 1 to Discretization.NUNITS do
    end;  // if ContinueExport then
  end;

end;

function TLayerPropertyWriter.Trans(ColIndex, RowIndex, UnitIndex: integer;
  Discretization: TDiscretizationWriter): double;
var
  LayersPerUnit : integer;
begin
  LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
  result := HK[ColIndex, RowIndex, UnitIndex-1]
    * Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
    / LayersPerUnit;
end;

procedure TLayerPropertyWriter.SetHK(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter;
  ZoneWriter: TZoneWriter; Multipliers: TMultiplierWriter);
begin
  With Discretization do
  begin
    SetLength(HK, NCOL, NROW, NUNITS);
  end;
  SetHKArrayWithParameters(Discretization, ZoneWriter, Multipliers);
  SetHKArray(CurrentModelHandle, Discretization, BasicPkg);
end;

class procedure TLayerPropertyWriter.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowLPF.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end;
  end;

end;

{ TParameterCheck }

constructor TParameterCheck.Create;
begin
  inherited;
  Units := TIntegerList.Create;
  Units.Sorted := True;
end;

destructor TParameterCheck.Destroy;
begin
  Units.Free;
  inherited;
end;

end.
