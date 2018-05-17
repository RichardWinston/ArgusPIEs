unit riteLayerPropertyFlow;

interface

uses Sysutils, Forms, ANEPIE, WriteModflowDiscretization;

type
  TBCFWriter = class(TModflowWriter)
  private
    IWDFLG : integer;
    LayCon : array of integer;
    NeedWetDry : boolean;
    NLAY : integer;
    ConfinedStorage : array of array of array of ANE_DOUBLE;
    HY : array of array of array of ANE_DOUBLE;
    Kz : array of array of array of ANE_DOUBLE;
    Sy : array of array of array of ANE_DOUBLE;
    VCONT : array of array of array of ANE_DOUBLE;
    WETDRY : array of array of array of ANE_DOUBLE;
    procedure SetHYArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure SetLayConLength(Length : integer);
    procedure SetPropertyArrayLengths(Discretization : TDiscretizationWriter);
    procedure SetSsArray(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure SetSyArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure SetVCONTArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure SetWetdryArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2(Discretization: TDiscretizationWriter);
    procedure WriteDataSet3(Discretization: TDiscretizationWriter);
    procedure WriteDataSets4to9(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure WriteHY(UnitNumber : integer;
      Discretization : TDiscretizationWriter);
    procedure WriteSF1(UnitNumber, LAYCON : integer;
      Discretization : TDiscretizationWriter);
    procedure WriteSf2(UnitNumber: integer;
      Discretization: TDiscretizationWriter);
    procedure WriteTran(UnitNumber : integer;
      Discretization : TDiscretizationWriter);
    procedure WriteVCONT(LayerNumber : integer;
      Discretization : TDiscretizationWriter);
    procedure WriteWETDRY(UnitNumber : integer;
      Discretization : TDiscretizationWriter);

  public
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
  end;

implementation

uses Variables, ModflowUnit, OptionsUnit, ProgressUnit;

{ TBCFWriter }

procedure TBCFWriter.SetLayConLength(Length: integer);
begin
  SetLength(LayCon, Length);
end;

procedure TBCFWriter.SetPropertyArrayLengths(
  Discretization: TDiscretizationWriter);
var
  LayerIndex : integer;
begin
  with Discretization do
  begin
    if Transient then
    begin
      SetLength(ConfinedStorage, NCOL, NROW, NUNITS);
      SetLength(Sy, NCOL, NROW, NUNITS);
    end;
    SetLength(HY, NCOL, NROW, NUNITS);
    if NLAY > 1 then
    begin
      SetLength(Kz, NCOL, NROW, NLAY);
      SetLength(VCONT, NCOL, NROW, NLAY);
    end;

    NeedWetDry := False;
    if IWDFLG <> 0 then
    begin
      for LayerIndex := 0 to NLAY -1 do
      begin
        NeedWetDry := ((LAYCON[LayerIndex] = 1) or (LAYCON[LayerIndex] = 3));
        if NeedWetDry then
        begin
          break;
        end;
      end;
    end;
    if NeedWetDry then
    begin
      SetLength(WETDRY, NCOL, NROW, NUNITS);
    end;
  end;
end;

procedure TBCFWriter.SetSsArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  LayerType, LayersPerUnit : Integer;
  SpecifyConfStorage : boolean;
  AValue : ANE_DOUBLE;
begin
  if Discretization.Transient then
  begin
    frmProgress.lblActivity.Caption := 'evaluating specific storage and '
      + 'storage coefficient';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Discretization.NUNITS;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);
          LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

          if (LayerType <> 1) or (LayersPerUnit > 1) then
          begin
            SpecifyConfStorage := frmModflow.dgGeol.Columns[Ord(nuiSpecSF1)].
              PickList.IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSpecSF1),UnitIndex]) = 1;
            if SpecifyConfStorage then
            begin
              ParameterName := ModflowTypes.GetMFGridConfStoreParamType.WriteParamName + IntToStr(UnitIndex);
            end
            else
            begin
              ParameterName := ModflowTypes.GetMFGridSpecStorParamType.WriteParamName + IntToStr(UnitIndex);
            end;
            ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Application.ProcessMessages;
                if not ContinueExport then break;

                BlockIndex := RowIndex* Discretization.NCOL + ColIndex;
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  AValue :=
                    ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                  if SpecifyConfStorage then
                  begin
                    ConfinedStorage[ColIndex, RowIndex, UnitIndex-1] := AValue;
                  end
                  else
                  begin
                    ConfinedStorage[ColIndex, RowIndex, UnitIndex-1] := AValue *
                      Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
                      / LayersPerUnit;
                  end;
                finally
                  ABlock.Free;
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

procedure TBCFWriter.SetSyArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  LayerType, LayersPerUnit : Integer;
//  AValue : ANE_DOUBLE;
begin
  if Discretization.Transient then
  begin
    frmProgress.lblActivity.Caption := 'evaluating specific yield';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Discretization.NUNITS;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);
//          LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

          if (LayerType <> 0) then
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

                BlockIndex := RowIndex* Discretization.NCOL + ColIndex;
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  Sy[ColIndex, RowIndex, UnitIndex-1] :=
                    ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                finally
                  ABlock.Free;
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

procedure TBCFWriter.SetHYArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  LayerType, LayersPerUnit : Integer;
  SpecifyTrans : boolean;
  AValue : ANE_DOUBLE;
begin
  frmProgress.lblActivity.Caption := 'evaluating hydraulic conductivity';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
    * Discretization.NUNITS;

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
      begin
        LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
          (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);
        LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

        if (LayerType <> 1) or (LayersPerUnit > 1) then
        begin
          SpecifyTrans := frmModflow.dgGeol.Columns[Ord(nuiSpecT)].
            PickList.IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSpecT),UnitIndex]) = 1;
          if SpecifyTrans then
          begin
            ParameterName := ModflowTypes.GetMFGridTransParamType.WriteParamName + IntToStr(UnitIndex);
          end
          else
          begin
            ParameterName := ModflowTypes.GetMFGridKxParamType.WriteParamName + IntToStr(UnitIndex);
          end;
          ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              BlockIndex := RowIndex* Discretization.NCOL + ColIndex;
              ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                AValue :=
                  ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                if SpecifyTrans then
                begin
                  HY[ColIndex, RowIndex, UnitIndex-1] := AValue;
                end
                else
                begin
                  if (LayerType = 0) or (LayerType = 2) then
                  begin
                    HY[ColIndex, RowIndex, UnitIndex-1] := AValue *
                      Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex]
                      / LayersPerUnit;
                  end
                  else
                  begin
                    HY[ColIndex, RowIndex, UnitIndex-1] := AValue;
                  end;
                end;
              finally
                ABlock.Free;
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

procedure TBCFWriter.SetWetdryArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  LayerType {, LayersPerUnit} : Integer;
  AValue : ANE_DOUBLE;
begin
  if (IWDFLG <> 0) then
  begin
    frmProgress.lblActivity.Caption := 'evaluating WETDRY';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Discretization.NUNITS;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);

          if (LayerType = 1) or (LayerType = 3) then
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

                BlockIndex := RowIndex* Discretization.NCOL + ColIndex;
                ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                try
                  AValue :=
                    ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                  WETDRY[ColIndex, RowIndex, UnitIndex-1] := AValue;
                finally
                  ABlock.Free;
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

procedure TBCFWriter.SetVCONTArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex, InnerUnitIndex : integer;
  {LayerType,} LayersPerUnit : Integer;
  SpecifyVCont : boolean;
  AValue, AValue2 : ANE_DOUBLE;
  LayerIndex : integer;
  Simulated : array of boolean;
  SpecVContArray : array of boolean;
  Layer : integer;
  StartLayer : integer;
  NeedKz, NeedKzAbove : boolean;
  DiscretizationIndex : integer;
begin
  if NLAY > 1 then
  begin
    frmProgress.lblActivity.Caption := 'evaluating vertical conductance';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Discretization.NUNITS * 2;

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    SetLength(Simulated, Discretization.NUNITS);
    SetLength(SpecVContArray, Discretization.NUNITS);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        SpecifyVCont := frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].
          PickList.IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT),UnitIndex]) = 1;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          Simulated[UnitIndex-1] := True;
          SpecVContArray[UnitIndex-1] := SpecifyVCont;
        end
        else
        begin
          Simulated[UnitIndex-1] := False;
          SpecVContArray[UnitIndex-1] := False;
        end;

        NeedKz := True;
        if SpecifyVCont then
        begin
          if ((UnitIndex > 1) and (frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].
            PickList.IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT),UnitIndex-1]) = 1)) then
            begin
              NeedKzAbove := False;
            end
            else
            begin
              NeedKzAbove := True;
            end;
            if not NeedKzAbove then
            begin
              if ((UnitIndex < 1) and (frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].
              PickList.IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT),UnitIndex+1]) = 1)) then
              begin
                NeedKz := False;
              end
            end;
        end;

        if NeedKz then
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

              BlockIndex := RowIndex* Discretization.NCOL + ColIndex;
              ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                AValue :=
                  ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                Kz[ColIndex, RowIndex, UnitIndex-1] := AValue;

              finally
                ABlock.Free;
              end;

              frmProgress.pbActivity.StepIt;
            end;
          end;
        end;
      end;

      Layer := -1;
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        StartLayer := Layer + 1;
        SpecifyVCont := frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].
          PickList.IndexOf(frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT),UnitIndex]) = 1;

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
          for DiscretizationIndex := 1 to LayersPerUnit do
          begin
            Inc(Layer);
          end;
        end
        else
        begin
          Inc(Layer);
        end;

        ParameterName := ModflowTypes.GetMFGridVContParamType.WriteParamName + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            if SpecifyVCont then
            begin

              BlockIndex := RowIndex* Discretization.NCOL + ColIndex;
              ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                AValue :=
                  ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
                for LayerIndex := StartLayer to Layer do
                begin
                  VCont[ColIndex, RowIndex, LayerIndex] := AValue;
                end;
              finally
                ABlock.Free;
              end;
            end
            else
            begin
              try
                AValue := Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
                  / Kz[ColIndex, RowIndex, UnitIndex-1];
              except on EZeroDivide do
                begin
                  AValue := 0;
                end;
              end;
              for LayerIndex := StartLayer to Layer-1 do
              begin
                VCont[ColIndex, RowIndex, LayerIndex] := AValue;
              end;
              try
                AValue := Kz[ColIndex, RowIndex, UnitIndex-1]
                  / Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
                  / 2;
                for InnerUnitIndex := UnitIndex+1 to Discretization.NUNITS-1 do
                begin
                  if Simulated[InnerUnitIndex] then
                  begin
                    AValue := AValue + Kz[ColIndex, RowIndex, InnerUnitIndex-1]
                      / Discretization.Thicknesses[ColIndex, RowIndex, InnerUnitIndex-1]
                      / 2;
                    break;
                  end
                  else
                  begin
                    AValue := AValue + Kz[ColIndex, RowIndex, InnerUnitIndex-1]
                      / Discretization.Thicknesses[ColIndex, RowIndex, InnerUnitIndex-1];
                  end;
                end;
                AValue := 1/AValue;
              except
                begin
                  AValue := 0;
                end;
              end;
              VCont[ColIndex, RowIndex, Layer] := AValue;
            end;

            frmProgress.pbActivity.StepIt;
          end;
        end;
      end;
    finally
      GridLayer.Free(CurrentModelHandle);
    end;
  end;



end;

procedure TBCFWriter.WriteDataSet1;
var
  HDRY : double;
  WETFCT : double;
  IWETIT : integer;
  IHDWET : integer;
begin
  with frmModflow do
  begin
    if cbFlowBCF.Checked then
    begin
      Write(FFile, 33, ' ');
    end
    else
    begin
      Write(FFile, 0, ' ');
    end;
    HDRY := StrToFloat(adeHDRY.Text);
    IWDFLG := comboWetCap.ItemIndex;
    WETFCT := StrToFloat(adeWettingFact.Text);
    IWETIT := StrToInt(adeWetIterations.Text);
    IHDWET := comboWetEq.ItemIndex;
    Writeln(FFile, HDRY, ' ', IWDFLG, ' ', WETFCT, ' ', IWETIT, ' ', IHDWET);
  end;
end;

procedure TBCFWriter.WriteDataSet2(Discretization: TDiscretizationWriter);
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  TransmisivityMethod, LayerType, ActualLayerType : integer;
begin
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    SetLayConLength(NLAY);
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        TransmisivityMethod := dgGeol.Columns[Ord(nuiTrans)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiTrans),UnitIndex]);
        LayerType := dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
          (dgGeol.Cells[Ord(nuiType),UnitIndex]);
        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);

          if (LayerNumber > 1) and (LayerType = 1) then
          begin
            ActualLayerType := 3;
          end
          else
          begin
            ActualLayerType := LayerType;
          end;

          LAYCON[LayerNumber-1] := ActualLayerType;

          if ((LayerNumber mod 25) = 0) or (LayerNumber = NLAY) then
          begin
            Writeln(FFile, TransmisivityMethod, ActualLayerType);
          end
          else
          begin
            Write(FFile, TransmisivityMethod, ActualLayerType, ' ');
          end;
        end;
      end;
    end;
  end;

end;

procedure TBCFWriter.WriteDataSet3(Discretization: TDiscretizationWriter);
var
  UnitIndex, DivIndex : integer;
  TRPY : double;
  LayerNumber : integer;
  LayersPerUnit : integer;
begin
  WriteU2DRELHeader;
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        TRPY := StrToFloat(dgGeol.Cells[Ord(nuiAnis),UnitIndex]);
        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);
          if ((LayerNumber mod 5) = 0) or (LayerNumber = NLAY) then
          begin
            Writeln(FFile, TRPY);
          end
          else
          begin
            Write(FFile, TRPY, ' ');
          end;
        end;
      end;
    end;
  end;
end;

procedure TBCFWriter.WriteDataSets4to9(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  LayerType : integer;
  Count : integer;
begin
  with frmMODFLOW do
  begin
    Count := 0;
    LayerNumber := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
        for DivIndex := 1 to LayersPerUnit do
        begin
          Inc(LayerNumber);
          LayerType := LAYCON[LayerNumber-1];
          if Discretization.Transient then
          begin
            Inc(Count);
          end;
          if (LayerType = 0) or (LayerType = 2) then
          begin
            Inc(Count);
          end;
          if (LayerType = 1) or (LayerType = 3) then
          begin
            Inc(Count);
          end;
          if (LayerNumber <> NLAY) then
          begin
            Inc(Count);
          end;
          if Discretization.Transient and ((LayerType = 2) or (LayerType = 3)) then
          begin
            Inc(Count);
          end;
          if (IWDFLG <> 0) and ((LayerType = 1) or (LayerType = 3)) then
          begin
            Inc(Count);
          end;
        end;
      end;
    end;

    frmProgress.pbPackage.Max := 6 + Count ;
    frmProgress.pbPackage.Position := 0;

    if ContinueExport then
    begin
      SetPropertyArrayLengths(Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetSsArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetSyArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetHYArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetVCONTArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetWetdryArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      LayerNumber := 0;
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if ContinueExport then
        begin
          if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
            dgGeol.Columns[Ord(nuiSim)].PickList[1] then
          begin
            LayersPerUnit := StrToInt(dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
            for DivIndex := 1 to LayersPerUnit do
            begin
              Inc(LayerNumber);
              LayerType := LAYCON[LayerNumber-1];
              if ContinueExport and Discretization.Transient then
              begin
                WriteSF1(UnitIndex, LayerType, Discretization);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end;
              if ContinueExport and (LayerType = 0) or (LayerType = 2) then
              begin
                WriteTran(UnitIndex, Discretization);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end;
              if ContinueExport and (LayerType = 1) or (LayerType = 3) then
              begin
                WriteHY(UnitIndex, Discretization);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end;
              if ContinueExport and (LayerNumber <> NLAY) then
              begin
                WriteVCONT(LayerNumber, Discretization);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end;
              if ContinueExport and Discretization.Transient and ((LayerType = 2) or (LayerType = 3)) then
              begin
                WriteSf2(UnitIndex, Discretization);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end;
              if ContinueExport and (IWDFLG <> 0) and ((LayerType = 1) or (LayerType = 3)) then
              begin
                WriteWETDRY(UnitIndex, Discretization);
                frmProgress.pbPackage.StepIt;
                Application.ProcessMessages;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

end;

procedure TBCFWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);
var
  FileName : String;
begin


  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Block Centered Flow';

    FileName := GetCurrentDir + '\' + Root + '.bcf';
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataSet1;
      WriteDataSet2(Discretization);
      WriteDataSet3(Discretization);
      WriteDataSets4to9(CurrentModelHandle, Discretization);
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;

procedure TBCFWriter.WriteHY(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  frmProgress.lblActivity.Caption := 'writing hydraulic conductivity or transmissivity';
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

      Write(FFile,
        HY[ColIndex,RowIndex,UnitNumber-1],
        ' ');

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TBCFWriter.WriteSF1(UnitNumber, LAYCON: integer;
  Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  frmProgress.lblActivity.Caption := 'writing primary storage coefficient';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;

  WriteU2DRELHeader;
  if LAYCON = 1 then
  begin
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        Write(FFile,
          Sy[ColIndex,RowIndex,UnitNumber-1],
          ' ');

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
  end
  else
  begin
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        Write(FFile,
          ConfinedStorage[ColIndex,RowIndex,UnitNumber-1],
          ' ');

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
  end;


end;

procedure TBCFWriter.WriteSf2(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  frmProgress.lblActivity.Caption := 'writing secondary storage coefficient';
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

      Write(FFile,
        Sy[ColIndex,RowIndex,UnitNumber-1],
        ' ');

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;

end;

procedure TBCFWriter.WriteTran(UnitNumber : Integer;
  Discretization: TDiscretizationWriter);
begin
  WriteHY(UnitNumber,Discretization);
end;

procedure TBCFWriter.WriteVCONT(LayerNumber : integer;
      Discretization : TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  frmProgress.lblActivity.Caption := 'writing vertical conductnace';
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

      Write(FFile,
        VCONT[ColIndex,RowIndex,LayerNumber-1],
        ' ');

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TBCFWriter.WriteWETDRY(UnitNumber: integer;
  Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
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

      Write(FFile,
        WETDRY[ColIndex,RowIndex,UnitNumber-1],
        ' ');

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

end. 
