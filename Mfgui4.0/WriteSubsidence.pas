unit WriteSubsidence;

interface

uses SysUtils, Forms, contnrs, AnePIE, OptionsUnit, WriteModflowDiscretization;

type
  TMaterialZoneRecord = record
    Kv: double;
    ElasticSpecificStorage: double;
    InelasticSpecificStorage: double;
  end;

  TMaterialZone = class(TObject)
    Zone: TMaterialZoneRecord;
    ZoneNumber: integer;
    function CompareZones(const AnotherZone: TMaterialZoneRecord): integer;
  end;

  TMaterialList = class(TObjectList)
  private
    function GetItems(const Index: integer): TMaterialZone;
    procedure SetItems(const Index: integer; const Value: TMaterialZone);
  public
    function Add(AZone: TMaterialZoneRecord): TMaterialZone;
    property Items[const Index: integer]: TMaterialZone read GetItems
      write SetItems;
  end;

  TSubsidenceWriter = class(TModflowWriter)
  private
    Discretization: TDiscretizationWriter;
    CurrentModelHandle, GridLayerHandle: ANE_PTR;
    GridLayer: TLayerOptions;
    UnitNNDB, UnitNDB: integer;
    NNDB, NDB: integer;
    ISUBOC: integer;
    IDREST: integer;
    MaterialList: TMaterialList;
    ZoneArray: array of array of array of TMaterialZone;
    procedure EvaluateCounts;
    procedure EvaluateMaterialZones;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSets5to8;
    procedure WriteDataSet9;
    procedure WriteDataSets10to14;
    procedure WriteDataSet15;
    procedure WriteDataSet16;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure WriteFile(const ModelHandle: ANE_PTR; Root: string;
      Dis : TDiscretizationWriter);
    class procedure AssignUnitNumbers;
  end;

implementation

uses UtilityFunctions, Variables, WriteNameFileUnit, ProgressUnit;

{ TSubsidenceWriter }

constructor TSubsidenceWriter.Create;
begin
  inherited;
  MaterialList:= TMaterialList.Create;
end;

destructor TSubsidenceWriter.Destroy;
begin
  MaterialList.Free;
  inherited;
end;

procedure TSubsidenceWriter.EvaluateCounts;
var
  Index: integer;
begin
  NNDB := 0;
  NDB := 0;
  UnitNNDB := 0;
  UnitNDB := 0;
  with frmModflow do
  begin
    for Index := 1 to rdgSub.RowCount -1 do
    begin
      UnitNNDB := NNDB + NoDelayInterbedCount(Index);
      UnitNDB := NDB + DelayInterbedCount(Index);
      NNDB := NNDB + NoDelayInterbedCount(Index)*DiscretizationCount(Index);
      NDB := NDB + DelayInterbedCount(Index)*DiscretizationCount(Index);
    end;
  end;
end;

procedure TSubsidenceWriter.EvaluateMaterialZones;
var
  ZoneIndex: integer;
  LayerIndex: integer;
  ParameterGroupIndex: integer;
  LayerName: string;
  Zone: TMaterialZoneRecord;
  KzName: string;
  ElasticSSName: string;
  InelasticSSName: string;
  ColIndex, RowIndex: integer;
  BlockIndex: integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Expression: string;
  Index: integer;
begin
  EvaluateCounts;
  if UnitNDB > 0 then
  begin
    setLength(ZoneArray, UnitNDB, Discretization.NCOL, Discretization.NROW);
    ZoneIndex := -1;
    for LayerIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      LayerName := ModflowTypes.GetMFDelaySubsidenceLayerType.ANE_LayerName
        + IntToStr(LayerIndex);
      for ParameterGroupIndex := 1 to frmModflow.
        DelayInterbedCount(LayerIndex) do
      begin
        Inc(ZoneIndex);
        KzName := ModflowTypes.GetMFVerticalHydraulicConductivityParamType.
          ANE_ParamName + IntToStr(ParameterGroupIndex);
        ElasticSSName := ModflowTypes.GetMFElasticSpecificStorageParamType.
          ANE_ParamName + IntToStr(ParameterGroupIndex);
        InelasticSSName := ModflowTypes.
          GetMFInelasticSpecificStorageParamType.
          ANE_ParamName + IntToStr(ParameterGroupIndex);
        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
              Expression := LayerName + '.' + KzName;
              Zone.Kv := GridLayer.RealValueAtXY(CurrentModelHandle,
                X, Y, Expression);
              Expression := LayerName + '.' + ElasticSSName;
              Zone.ElasticSpecificStorage := GridLayer.
                RealValueAtXY(CurrentModelHandle, X, Y, Expression);
              Expression := LayerName + '.' + InelasticSSName;
              Zone.InelasticSpecificStorage := GridLayer.
                RealValueAtXY(CurrentModelHandle, X, Y, Expression);
              ZoneArray[ZoneIndex, ColIndex, RowIndex] :=
                MaterialList.Add(Zone);
            finally
              ABlock.Free;
            end;
          end;
        end;
      end;
    end;
    for Index := 0 to MaterialList.Count -1 do
    begin
      MaterialList.Items[Index].ZoneNumber := Index + 1;
    end;
  end;
end;

procedure TSubsidenceWriter.WriteDataSet1;
var
  ISUBCB: integer;
  NMZ: integer;
  NN: integer;
  AC1, AC2: double;
  ITMIN: integer;
  IDSAVE: integer;
begin
  EvaluateMaterialZones;
  with frmModflow do
  begin
    if cbFlowSub.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        ISUBCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        ISUBCB := frmModflow.GetUnitNumber('SUBBUD');
      end;
    end
    else
    begin
        ISUBCB := 0;
    end;

    ISUBOC := StrToInt(adeSubISUBOC.Text);
    NMZ := MaterialList.Count;

    NN := StrToInt(adeSubNN.Text);
    AC1 := InternationalStrToFloat(adeSUB_AC1.Text);
    AC2 := InternationalStrToFloat(adeSUB_AC2.Text);
    ITMIN := StrToInt(adeSUB_ITMIN.Text);
    if cbSubSaveRestart.Checked then
    begin
      IDSAVE := frmModflow.GetUnitNumber('SubIDSAVE');
    end
    else
    begin
      IDSAVE := 0;
    end;
    if cbSubUseRestart.Checked then
    begin
      IDREST := frmModflow.GetUnitNumber('SubIDREST');
    end
    else
    begin
      IDREST := 0;
    end;
  end;
  WriteLn(FFile, ISUBCB, ' ', ISUBOC, ' ', NNDB, ' ', NDB, ' ',  NMZ, ' ',
    NN, ' ', FreeFormattedReal(AC1),  FreeFormattedReal(AC2), ' ', ITMIN, ' ',
    IDSAVE, ' ', IDREST);
end;

procedure TSubsidenceWriter.WriteDataSet2;
var
  UnitIndex, DisIndex: integer;
  MFLayer: integer;
  BedIndex: integer;
begin
  if NNDB > 0 then
  begin
    MFLayer := 0;
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          Inc(MFLayer);
          for BedIndex := 1 to frmModflow.NoDelayInterbedCount(UnitIndex) do
          begin
            Write(FFile, MFLayer, ' ');
          end;
        end;
      end;
    end;
    writeLn(FFile, ' LN');
  end;
end;

procedure TSubsidenceWriter.WriteDataSet3;
var
  UnitIndex, DisIndex: integer;
  MFLayer: integer;
  BedIndex: integer;
begin
  if NDB > 0 then
  begin
    MFLayer := 0;
    for UnitIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          Inc(MFLayer);
          for BedIndex := 1 to frmModflow.DelayInterbedCount(UnitIndex) do
          begin
            Write(FFile, MFLayer, ' ');
          end;
        end;
      end;
    end;
    writeLn(FFile, ' LDN');
  end;
end;

procedure TSubsidenceWriter.WriteDataSet4;
var
  Values: array of array of array of double;
  LayerIndex: integer;
  LayerName: string;
  ColIndex, RowIndex: integer;
  BlockIndex: integer;
  ABlock : TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  ParamCount: integer;
  ParamIndex: integer;
  ParamName: string;
  ParamRoot: string;
  Expression: string;
  DisIndex: integer;
  MFLayer: integer;
begin
  if NDB > 0 then
  begin
    MFLayer := 0;
    ParamRoot := ModflowTypes.GetMFEquivalentNumberParamType.ANE_ParamName;
    for LayerIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      ParamCount := frmModflow.DelayInterbedCount(LayerIndex);
      if ParamCount > 0 then
      begin
        LayerName := ModflowTypes.GetMFDelaySubsidenceLayerType.ANE_LayerName
          + IntToStr(LayerIndex);
        SetLength(Values, frmModflow.DelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
              for ParamIndex := 1 to ParamCount do
              begin
                ParamName := ParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                Values[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);
              end;
            finally
              ABlock.Free;
            end;
          end;
        end;
        for DisIndex := 1 to frmModflow.DiscretizationCount(LayerIndex) do
        begin
          Inc(MFLayer);
          for ParamIndex := 1 to ParamCount do
          begin
            WriteU2DRELHeader('RNB, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(Values[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSubsidenceWriter.WriteDataSet9;
var
  Index: integer;
  Zone: TMaterialZone;
begin
  if NDB > 0 then
  begin
    for Index := 0 to MaterialList.Count -1 do
    begin
      Zone := MaterialList.Items[Index];
      writeLn(FFile, FreeFormattedReal(Zone.Zone.Kv),
        FreeFormattedReal(Zone.Zone.ElasticSpecificStorage),
        FreeFormattedReal(Zone.Zone.InelasticSpecificStorage));
    end;
  end;
end;

procedure TSubsidenceWriter.WriteDataSets5to8;
var
  HC: array of array of array of double;
  Sfe: array of array of array of double;
  Sfv: array of array of array of double;
  COM: array of array of array of double;
  LayerIndex: integer;
  LayerName: string;
  ColIndex, RowIndex: integer;
  BlockIndex: integer;
  ABlock : TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  ParamCount: integer;
  ParamIndex: integer;
  ParamName: string;
  HCParamRoot: string;
  SfeParamRoot: string;
  SfvParamRoot: string;
  COMParamRoot: string;
  Expression: string;
  DisIndex: integer;
  MFLayer: integer;
begin
  if NNDB > 0 then
  begin
    MFLayer := 0;
    HCParamRoot := ModflowTypes.
      GetMFPreconsolidationHeadParamType.ANE_ParamName;
    SfeParamRoot := ModflowTypes.
      GetMFElasticStorageCoefficientParamType.ANE_ParamName;
    SfvParamRoot := ModflowTypes.
      GetMFInelasticStorageCoefficientParamType.ANE_ParamName;
    COMParamRoot := ModflowTypes.
      GetMFStartingCompactionParamType.ANE_ParamName;
    for LayerIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      ParamCount := frmModflow.NoDelayInterbedCount(LayerIndex);
      if ParamCount > 0 then
      begin
        LayerName := ModflowTypes.GetMFNoDelaySubsidenceLayerType.ANE_LayerName
          + IntToStr(LayerIndex);
        SetLength(HC, frmModflow.NoDelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        SetLength(Sfe, frmModflow.NoDelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        SetLength(Sfv, frmModflow.NoDelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        SetLength(COM, frmModflow.NoDelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
              for ParamIndex := 1 to ParamCount do
              begin
                ParamName := HCParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                HC[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);

                ParamName := SfeParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                Sfe[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);

                ParamName := SfvParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                Sfv[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);

                ParamName := COMParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                COM[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);
              end;
            finally
              ABlock.Free;
            end;
          end;
        end;
        for DisIndex := 1 to frmModflow.DiscretizationCount(LayerIndex) do
        begin
          Inc(MFLayer);
          for ParamIndex := 1 to ParamCount do
          begin
            WriteU2DRELHeader('HC, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(HC[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;

            WriteU2DRELHeader('Sfe, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(Sfe[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;

            WriteU2DRELHeader('Sfv, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(Sfv[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;

            WriteU2DRELHeader('COM, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(COM[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSubsidenceWriter.WriteDataSets10to14;
var
  Dstart: array of array of array of double;
  DHC: array of array of array of double;
  DCOM: array of array of array of double;
  DZ: array of array of array of double;
  LayerIndex: integer;
  LayerName: string;
  ColIndex, RowIndex: integer;
  BlockIndex: integer;
  ABlock : TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
  ParamCount: integer;
  ParamIndex: integer;
  ParamName: string;
  DstartParamRoot: string;
  DHCParamRoot: string;
  DCOMParamRoot: string;
  DZParamRoot: string;
  Expression: string;
  DisIndex: integer;
  MFLayer: integer;
  ZoneIndex: integer;
  TempZoneIndex: integer;
  MaterialZone: TMaterialZone;
begin
  if NDB > 0 then
  begin
    MFLayer := 0;
    ZoneIndex := 0;
    DstartParamRoot := ModflowTypes.GetMFStartingHeadParamType.ANE_ParamName;
    DHCParamRoot := ModflowTypes.
      GetMFPreconsolidationHeadParamType.ANE_ParamName;
    DCOMParamRoot := ModflowTypes.
      GetMFStartingCompactionParamType.ANE_ParamName;
    DZParamRoot := ModflowTypes.
      GetMFEquivalentThicknessParamType.ANE_ParamName;
    for LayerIndex := 1 to frmModflow.dgGeol.RowCount -1 do
    begin
      ParamCount := frmModflow.DelayInterbedCount(LayerIndex);
      if ParamCount <= 0 then
      begin
        if frmModflow.Simulated(LayerIndex) then
        begin
          MFLayer := MFLayer + frmModflow.DiscretizationCount(LayerIndex);
        end;
      end
      else
      begin
        LayerName := ModflowTypes.GetMFDelaySubsidenceLayerType.ANE_LayerName
          + IntToStr(LayerIndex);

        if IDREST <= 0 then
        begin
          SetLength(Dstart, frmModflow.DelayInterbedCount(LayerIndex),
            Discretization.NCOL, Discretization.NROW);
          SetLength(DHC, frmModflow.DelayInterbedCount(LayerIndex),
            Discretization.NCOL, Discretization.NROW);
        end;
        SetLength(DCOM, frmModflow.DelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        SetLength(DZ, frmModflow.DelayInterbedCount(LayerIndex),
          Discretization.NCOL, Discretization.NROW);
        for ColIndex := 0 to Discretization.NCOL -1 do
        begin
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayerHandle, BlockIndex);
            try
              ABlock.GetCenter(CurrentModelHandle, X, Y);
              for ParamIndex := 1 to ParamCount do
              begin
                if IDREST <= 0 then
                begin
                  ParamName := DstartParamRoot + IntToStr(ParamIndex);;
                  Expression := LayerName + '.' + ParamName;
                  Dstart[ParamIndex-1, ColIndex, RowIndex] :=
                    GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                    Expression);

                  ParamName := DHCParamRoot + IntToStr(ParamIndex);;
                  Expression := LayerName + '.' + ParamName;
                  DHC[ParamIndex-1, ColIndex, RowIndex] :=
                    GridLayer.RealValueAtXY(CurrentModelHandle, X, Y,
                    Expression);
                end;

                ParamName := DCOMParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                DCOM[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);

                ParamName := DZParamRoot + IntToStr(ParamIndex);;
                Expression := LayerName + '.' + ParamName;
                DZ[ParamIndex-1, ColIndex, RowIndex] :=
                  GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);
              end;
            finally
              ABlock.Free;
            end;
          end;
        end;
        TempZoneIndex := -1;
        for DisIndex := 1 to frmModflow.DiscretizationCount(LayerIndex) do
        begin
          Inc(TempZoneIndex);
          Inc(MFLayer);
          for ParamIndex := 1 to ParamCount do
          begin
            if IDREST <= 0 then
            begin
              WriteU2DRELHeader('Dstart, Layer ' + IntToStr(MFLayer));
              for RowIndex := 0 to Discretization.NROW -1 do
              begin
                for ColIndex := 0 to Discretization.NCOL -1 do
                begin
                  Write(FFile, FreeFormattedReal(Dstart[ParamIndex-1,
                    ColIndex, RowIndex]));
                end;
                WriteLn(FFile);
              end;

              WriteU2DRELHeader('DHC, Layer ' + IntToStr(MFLayer));
              for RowIndex := 0 to Discretization.NROW -1 do
              begin
                for ColIndex := 0 to Discretization.NCOL -1 do
                begin
                  Write(FFile, FreeFormattedReal(DHC[ParamIndex-1,
                    ColIndex, RowIndex]));
                end;
                WriteLn(FFile);
              end;
            end;

            WriteU2DRELHeader('DCOM, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(DCOM[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;

            WriteU2DRELHeader('DZ, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Write(FFile, FreeFormattedReal(DZ[ParamIndex-1,
                  ColIndex, RowIndex]));
              end;
              WriteLn(FFile);
            end;

            WriteU2DINTHeader('NZ, Layer ' + IntToStr(MFLayer));
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                MaterialZone := ZoneArray[ZoneIndex+TempZoneIndex,
                  ColIndex, RowIndex];
                Write(FFile, MaterialZone.ZoneNumber, ' ');
              end;
              WriteLn(FFile);
            end;
          end;
        end;
        Inc(ZoneIndex,frmModflow.DiscretizationCount(LayerIndex));
      end;
    end;
  end;
end;

procedure TSubsidenceWriter.WriteDataSet15;
var
  Index: integer;
begin
  if ISUBOC > 0 then
  begin
    with frmModflow.dgSubOutFormat do
    begin
      for Index := 1 to RowCount -1 do
      begin
        Write(FFile, Columns[1].PickList.IndexOf(Cells[1,Index]), ' ',
          frmModflow.GetUnitNumber('SUB_Iun' + IntToStr(Index)), ' ');
      end;
      Writeln(FFile);
    end;
  end;
end;

procedure TSubsidenceWriter.WriteDataSet16;
var
  RowIndex: integer;
  ColIndex: integer;
begin
  if ISUBOC > 0 then
  begin
    with frmModflow.dgSubOutput do
    begin
      for RowIndex := 1 to RowCount -1 do
      begin
        for ColIndex := 0 to 3 do
        begin
          Write(FFile, StrToInt(Cells[ColIndex,RowIndex]), ' ');
        end;
        for ColIndex := 4 to ColCount -1 do
        begin
          Write(FFile, Columns[ColIndex].PickList.
            IndexOf(Cells[ColIndex,RowIndex]) -1, ' ');
        end;
        WriteLn(FFile);
      end;
    end;
  end;

end;

procedure TSubsidenceWriter.WriteFile(const ModelHandle: ANE_PTR;
  Root: string; Dis: TDiscretizationWriter);
var
  FileName: string;
begin
  Discretization := Dis;
  CurrentModelHandle := ModelHandle;
  GridLayerHandle := Dis.GridLayerHandle;
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    FileName := GetCurrentDir + '\' + Root + rsSUB;
    AssignFile(FFile,FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        WriteDataSet1;
        WriteDataSet2;
        WriteDataSet3;
        WriteDataSet4;
        WriteDataSets5to8;
        WriteDataSet9;
        WriteDataSets10to14;
        WriteDataSet15;
        WriteDataSet16;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;

class procedure TSubsidenceWriter.AssignUnitNumbers;
var
  ISUBOC: integer;
  Index: integer;
begin
  with frmModflow do
  begin
    if cbFlowSub.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('SUBBUD');
      end;
    end;

    if cbSubSaveRestart.Checked then
    begin
      frmModflow.GetUnitNumber('SubIDSAVE');
    end;
    if cbSubUseRestart.Checked then
    begin
      frmModflow.GetUnitNumber('SubIDREST');
    end;
    ISUBOC := StrToInt(adeSubISUBOC.Text);
    if ISUBOC > 0 then
    begin
      with frmModflow.dgSubOutFormat do
      begin
        for Index := 1 to RowCount -1 do
        begin
            frmModflow.GetUnitNumber('SUB_Iun' + IntToStr(Index));
        end;
      end;
    end;
  end;
end;

{ TMaterialList }

function TMaterialList.Add(AZone: TMaterialZoneRecord): TMaterialZone;
  function NewZone: TMaterialZone;
  begin
    result := TMaterialZone.Create;
    result.Zone := AZone;
  end;
var
  AnotherZone: TMaterialZone;
  AboveIndex, BelowIndex, MiddleIndex: integer;
begin
  case Count of
    0:
      begin
        result := NewZone;
        Inherited Add(result);
      end;
    1:
      begin
        AnotherZone := Items[0];
        case AnotherZone.CompareZones(AZone) of
          -1:
            begin
              result := NewZone;
              Inherited Insert(0, result);
            end;
          0:
            begin
              result := AnotherZone;
            end;
          1:
            begin
              result := NewZone;
              Inherited Add(result);
            end;
        else
          Assert(False);
          result := nil;
        end;
      end;
  else
    begin
      AnotherZone:= Items[0];
      case AnotherZone.CompareZones(AZone) of
        -1:
          begin
            result := NewZone;
            Inherited Insert(0, result);
            Exit;
          end;
        0:
          begin
            result := AnotherZone;
            Exit;
          end;
        1:
          begin
          end;
      else
        Assert(False);
        result := nil;
      end;
      BelowIndex := 0;

      AnotherZone:= Items[Count -1];
      case AnotherZone.CompareZones(AZone) of
        -1:
          begin
          end;
        0:
          begin
            result := AnotherZone;
            Exit;
          end;
        1:
          begin
            result := NewZone;
            Inherited Add(result);
            Exit;
          end;
      else
        Assert(False);
        result := nil;
      end;
      AboveIndex := Count -1;

      While (AboveIndex - BelowIndex > 1) do
      begin
        MiddleIndex := (AboveIndex + BelowIndex) div 2;
        AnotherZone := Items[MiddleIndex];
        case AnotherZone.CompareZones(AZone) of
          -1:
            begin
              AboveIndex := MiddleIndex;
            end;
          0:
            begin
              result := AnotherZone;
              Exit;
            end;
          1:
            begin
              BelowIndex := MiddleIndex;
            end;
        else
          Assert(False);
          result := nil;
        end;
      end;
      result := NewZone;
      Inherited Insert(AboveIndex, result);
    end;
  end;
end;

function TMaterialList.GetItems(const Index: integer): TMaterialZone;
begin
  result := inherited Items[Index] as TMaterialZone
end;

procedure TMaterialList.SetItems(const Index: integer;
  const Value: TMaterialZone);
begin
  inherited Items[Index] := Value;
end;

{ TMaterialZone }

function TMaterialZone.CompareZones(
  const AnotherZone: TMaterialZoneRecord): integer;
  function Sign(Value: double): integer;
  begin
    if Value > 0 then
    begin
      result := 1;
    end
    else if Value < 0 then
    begin
      result := -1;
    end
    else
    begin
      result := 0;
    end;
  end;
begin
  result := Sign(AnotherZone.Kv - Zone.Kv);
  if result = 0 then
  begin
    result := Sign(AnotherZone.ElasticSpecificStorage
      - Zone.ElasticSpecificStorage);
  end;
  if result = 0 then
  begin
    result := Sign(AnotherZone.InelasticSpecificStorage
      - Zone.InelasticSpecificStorage);
  end;
end;

end.
