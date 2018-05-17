unit WriteBCF_Unit;

interface

uses Sysutils, Classes, Forms, ANEPIE, WriteModflowDiscretization,
  WriteLakesUnit, WriteReservoirUnit;

type
  TFlowWriter = class(TModflowWriter)
  public
    function Trans(ColIndex, RowIndex, UnitIndex: integer;
      Discretization : TDiscretizationWriter) : double; virtual; abstract;
  end;

  TBCFWriter = class(TFlowWriter)
  private
    IWDFLG : integer;
    LayCon : array of integer;
    UnitLayCon: array of integer;
    NeedWetDry : boolean;
    NLAY : integer;
    ConfinedStorage : array of array of array of ANE_DOUBLE;
    HY : array of array of array of ANE_DOUBLE;
    Kz : array of array of array of ANE_DOUBLE;
    Sy : array of array of array of ANE_DOUBLE;
    VCONT : array of array of array of ANE_DOUBLE;
    WETDRY : array of array of array of ANE_DOUBLE;
    procedure SetLayConLength(Discretization: TDiscretizationWriter);
    procedure SetPropertyArrayLengths(Discretization : TDiscretizationWriter);
    procedure SetSsArray(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure SetSyArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure SetVCONTArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure SetWetdryArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure WriteDataSet1;
    procedure WriteDataSet2(Discretization: TDiscretizationWriter);
    procedure WriteDataSet3(Discretization: TDiscretizationWriter);
    procedure WriteDataSets4to9(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
      LakeWriter : TLakeWriter; ReservoirWriter : TReservoirWriter);
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
      Discretization : TDiscretizationWriter; LakeWriter : TLakeWriter;
      ReservoirWriter : TReservoirWriter; LayerIndex : integer);
    procedure SetHYArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure SetLaycon(Discretization: TDiscretizationWriter);
    procedure CheckConfinedStorage(Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure CheckSpecificYield(Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure CheckHydraulicConductivity(
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
  public
    procedure SetHY(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
      LakeWriter : TLakeWriter; ReservoirWriter : TReservoirWriter);
    function Trans(ColIndex, RowIndex, UnitIndex: integer;
      Discretization : TDiscretizationWriter) : double; override;
    class procedure AssignUnitNumbers;
  end;

implementation

uses Variables, ModflowUnit, OptionsUnit, ProgressUnit, WriteNameFileUnit,
  UnitNumbers, UtilityFunctions;

{ TBCFWriter }

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
    SetLength(Kz, NCOL, NROW, NUNITS);
    SetLength(VCONT, NCOL, NROW, NLAY);

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
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
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

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] <>
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
              ConfinedStorage[ColIndex, RowIndex, UnitIndex-1] := 0;
            end;
          end;
        end
        else
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

                if BasicPkg.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
                begin
                  ConfinedStorage[ColIndex, RowIndex, UnitIndex-1] := 0;
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
    CheckConfinedStorage(Discretization, BasicPkg);
  end;
end;

procedure TBCFWriter.SetSyArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  LayerType : Integer;
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

        if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] <>
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
        begin
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
              Sy[ColIndex, RowIndex, UnitIndex-1] := 0;
            end;
          end;
        end
        else
        begin
          LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);

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
                    Sy[ColIndex, RowIndex, UnitIndex-1] :=
                      ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
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
    CheckSpecificYield(Discretization, BasicPkg);
  end;
end;

procedure TBCFWriter.SetHYArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
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
  Count : integer;
begin
  Count := 0;
  for UnitIndex := 1 to Discretization.NUNITS do
  begin
    if frmMODFLOW.Simulated(UnitIndex) then
    begin
      LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
        (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);
      LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

      if (LayerType <> 1) or (LayersPerUnit > 1) then
      begin
        Inc(Count);
      end;
    end;
  end;
  frmProgress.lblActivity.Caption := 'evaluating hydraulic conductivity';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
    * Count;

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if (frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] <>
        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1]) then
      begin
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            HY[ColIndex, RowIndex, UnitIndex-1] := 0;
          end;
        end;
      end
      else
      begin
        LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
          (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex]);
        LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);
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

            if BasicPkg.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
            begin
              HY[ColIndex, RowIndex, UnitIndex-1] := 0;
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
                if SpecifyTrans then
                begin
                  HY[ColIndex, RowIndex, UnitIndex-1] := AValue;
                end
                else
                begin
                  if (LayerType = 0) or (LayerType = 2) then
                  begin
                    HY[ColIndex, RowIndex, UnitIndex-1] := AValue *
                      Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
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

procedure TBCFWriter.SetWetdryArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  LayerType: Integer;
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

procedure TBCFWriter.SetVCONTArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex, InnerUnitIndex : integer;
  {LayerType,} LayersPerUnit : array of Integer;
  SpecifyVCont : boolean;
  AValue, AValue2 : ANE_DOUBLE;
  LayerIndex : integer;
  Simulated : array of boolean;
  SpecVContArray : array of boolean;
  Layer : integer;
  StartLayer : integer;
  NeedKz, NeedKzAbove : boolean;
  DiscretizationIndex : integer;
  KzValue, NextKzValue : double;
  ErrorList : TStringList;
  AString : string;
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
    SetLength(LayersPerUnit, Discretization.NUNITS);
    try
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        LayersPerUnit[UnitIndex-1]
          := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

        SpecifyVCont := frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].
          PickList.IndexOf(frmModflow.dgGeol.Cells
          [Ord(nuiSpecVCONT),UnitIndex]) = 1;

        if frmMODFLOW.Simulated(UnitIndex) then
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

        if frmMODFLOW.Simulated(UnitIndex) then
        begin
          for DiscretizationIndex := 1 to LayersPerUnit[UnitIndex-1] do
          begin
            Inc(Layer);
          end;
        end;

        if frmMODFLOW.Simulated(UnitIndex) then
        begin
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
                if StartLayer < Layer then
                begin
                  if Kz[ColIndex, RowIndex, UnitIndex-1] = 0 then
                  begin
                    AValue := 0;
                  end
                  else
                  begin
                    AValue := Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
                      / LayersPerUnit[UnitIndex-1]
                      / Kz[ColIndex, RowIndex, UnitIndex-1];
                  end;

                  if AValue <> 0 then
                  begin
                    AValue := 1/AValue;
                  end;
                  for LayerIndex := StartLayer to Layer-1 do
                  begin
                    VCont[ColIndex, RowIndex, LayerIndex] := AValue;
                  end;
                end;
                try
                  KzValue := Kz[ColIndex, RowIndex, UnitIndex-1];
                  if KzValue = 0 then
                  begin
                    AValue := 0;
                  end
                  else
                  begin
                    AValue :=
                      Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
                      / LayersPerUnit[UnitIndex-1]
                      / 2 / KzValue;
                  end;
                  if AValue <> 0 then
                  begin
                    for InnerUnitIndex := UnitIndex+1 to Discretization.NUNITS do
                    begin
                      NextKzValue := Kz[ColIndex, RowIndex, InnerUnitIndex-1];
                      if NextKzValue = 0 then
                      begin
                        AValue := 0;
                        break;
                      end
                      else if Simulated[InnerUnitIndex-1] then
                      begin

                        AValue := AValue +
                          Discretization.Thicknesses[ColIndex, RowIndex, InnerUnitIndex-1]
                        / LayersPerUnit[InnerUnitIndex-1]
                          / 2 /Kz[ColIndex, RowIndex, InnerUnitIndex-1];
                        break;
                      end
                      else
                      begin
                        AValue := AValue +
                          Discretization.Thicknesses[ColIndex, RowIndex, InnerUnitIndex-1]
                          / Kz[ColIndex, RowIndex, InnerUnitIndex-1];
                      end;
                    end;
                  end;
                  if AValue <> 0 then
                  begin
                    AValue := 1/AValue;
                  end
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
      end;
    finally
      GridLayer.Free(CurrentModelHandle);
    end;
  end;

  if ShowWarnings and ContinueExport and (Discretization.NLAY > 1) then
  begin
    ErrorList := TStringList.Create;
    try
      for LayerIndex := 0 to Discretization.NLAY -1 do
      begin
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            if (BasicPkg.MFIBOUND[ColIndex,RowIndex,LayerIndex] <> 0)
              and (VCONT[ColIndex,RowIndex,LayerIndex] <= 0)
              and (LayerIndex < Discretization.NLAY -1)
              and (BasicPkg.MFIBOUND[ColIndex,RowIndex,LayerIndex+1] <> 0) then
            begin
              ErrorList.Add(Format('[%d, %d, %d]', [LayerIndex+1, ColIndex+1,RowIndex+1]));
            end
          end;
        end;
      end;
      if ErrorList.Count > 0 then
      begin
        AString := 'Warning: Vertical conductance <= 0.';
        frmProgress.reErrors.Lines.Add(AString);
        AString := AString + ' [Layer, Col, Row]';
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(ErrorList);
      end;
    finally
      ErrorList.Free;
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
      Write(FFile, frmModflow.GetUnitNumber('BUD'), ' ');
    end
    else
    begin
      Write(FFile, 0, ' ');
    end;
    HDRY := InternationalStrToFloat(adeHDRY.Text);
    IWDFLG := comboWetCap.ItemIndex;
    WETFCT := InternationalStrToFloat(adeWettingFact.Text);
    IWETIT := StrToInt(adeWetIterations.Text);
    IHDWET := comboWetEq.ItemIndex;
    Writeln(FFile, HDRY, ' ', IWDFLG, ' ', WETFCT, ' ', IWETIT, ' ', IHDWET);
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
        TRPY := InternationalStrToFloat(dgGeol.Cells[Ord(nuiAnis),UnitIndex]);
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
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
  LakeWriter : TLakeWriter; ReservoirWriter : TReservoirWriter);
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
      SetSsArray(CurrentModelHandle, Discretization, BasicPkg);
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
      SetHYArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetVCONTArray(CurrentModelHandle, Discretization, BasicPkg);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetWetdryArray(CurrentModelHandle, Discretization, BasicPkg);
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
                WriteWETDRY(UnitIndex, Discretization, LakeWriter,
                  ReservoirWriter, LayerNumber-1);
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

procedure TBCFWriter.WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter;
  LakeWriter : TLakeWriter; ReservoirWriter : TReservoirWriter);
var
  FileName : String;
begin
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Block Centered Flow';

    FileName := GetCurrentDir + '\' + Root + rsBCF;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataSet1;
      WriteDataSet2(Discretization);
      WriteDataSet3(Discretization);
      WriteDataSets4to9(CurrentModelHandle, Discretization, BasicPkg,
        LakeWriter, ReservoirWriter);
      Flush(FFile);
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
        FreeFormattedReal(HY[ColIndex,RowIndex,UnitNumber-1]));

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
          FreeFormattedReal(Sy[ColIndex,RowIndex,UnitNumber-1]));

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
          FreeFormattedReal(ConfinedStorage[ColIndex,RowIndex,UnitNumber-1]));

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
        FreeFormattedReal(Sy[ColIndex,RowIndex,UnitNumber-1]));

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
  frmProgress.lblActivity.Caption := 'writing vertical conductance';
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
        FreeFormattedReal(VCONT[ColIndex,RowIndex,LayerNumber-1]));

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);

  end;
end;

procedure TBCFWriter.WriteWETDRY(UnitNumber: integer;
  Discretization: TDiscretizationWriter; LakeWriter: TLakeWriter;
  ReservoirWriter : TReservoirWriter; LayerIndex : integer);
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

procedure TBCFWriter.SetLayConLength(Discretization: TDiscretizationWriter);
begin
  SetLength(LayCon, NLAY);
  SetLength(UnitLayCon, Discretization.NUNITS);
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
    SetLayConLength(Discretization);

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
          UnitLayCon[UnitIndex-1] := ActualLayerType;

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

function TBCFWriter.Trans(ColIndex, RowIndex, UnitIndex: integer;
  Discretization: TDiscretizationWriter): double;
var
  LayerIndex : integer;
  LayerLayCon : integer;
  LayersPerUnit : integer;
begin
  LayersPerUnit := StrToInt(frmModflow.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]);

  LayerIndex := frmModflow.MODFLOWLayersAboveCount(UnitIndex);
  LayerLayCon := LayCon[LayerIndex];

  if (LayerLayCon = 0) or (LayerLayCon = 2) then
  begin
    result := HY[ColIndex, RowIndex, UnitIndex-1]
  end
  else
  begin
    result := HY[ColIndex, RowIndex, UnitIndex-1]
      * Discretization.Thicknesses[ColIndex, RowIndex, UnitIndex-1]
      / LayersPerUnit;
  end;
end;

procedure TBCFWriter.SetHY(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter);
begin
  SetLaycon(Discretization);
  with Discretization do
  begin
    SetLength(HY, NCOL, NROW, NUNITS);
  end;
  SetHYArray(CurrentModelHandle, Discretization, BasicPkg);

  CheckHydraulicConductivity(Discretization, BasicPkg);
end;

procedure TBCFWriter.SetLaycon(Discretization: TDiscretizationWriter);
var
  UnitIndex, DivIndex, LayerNumber, LayersPerUnit : integer;
  LayerType, ActualLayerType : integer;
begin
  LayerNumber := 0;
  with frmMODFLOW do
  begin
    NLAY := frmMODFLOW.MODFLOWLayerCount;
    SetLayConLength(Discretization);
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
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
          UnitLayCon[UnitIndex-1] := ActualLayerType;
        end;
      end;
    end;
  end;

end;

procedure TBCFWriter.CheckConfinedStorage(
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  UnitIndex, ColIndex, RowIndex : integer;
  ErrorStringList : TStringList;
  AString : string;
  CS : double;
  IB : integer;
begin
  if ShowWarnings then
  begin
    ErrorStringList := TStringList.Create;
    try
      frmProgress.lblActivity.Caption := 'checking confined storage';
      frmProgress.pbActivity.Position := 0;
      With Discretization do
      begin
        frmProgress.pbActivity.Max := NROW * NCOL * NUNITS;
        for UnitIndex := 0 to NUNITS -1 do
        begin
          if not frmModflow.Simulated(UnitIndex+1) or
            (UnitLayCon[UnitIndex] = 1) then
          begin
            Continue;
          end;

          for ColIndex := 0 to NCOL -1 do
          begin
            for RowIndex := 0 to NROW -1 do
            begin
              IB := BasicPkg.IBOUND[ColIndex, RowIndex, UnitIndex];
              CS := ConfinedStorage[ColIndex, RowIndex, UnitIndex];
              if (IB <> 0) and (CS <= 0) then
              begin
                ErrorStringList.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
              end;
              frmProgress.pbActivity.StepIt;
            end;
          end;
          if ErrorStringList.Count > 0 then
          begin
            AString := 'Warning: confined storage <= 0 in Unit '
               + IntToStr(UnitIndex + 1) + '.';
            frmProgress.reErrors.Lines.Add(AString);
            AString := AString + ' [Col,Row]';
            ErrorMessages.Add('');
            ErrorMessages.Add(AString);
            ErrorMessages.AddStrings(ErrorStringList);
          end;
          ErrorStringList.Clear;
        end;
      end;
    finally
      ErrorStringList.Free;
    end;
  end;
end;

procedure TBCFWriter.CheckSpecificYield(
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  UnitIndex, ColIndex, RowIndex : integer;
  ErrorStringList : TStringList;
  AString : string;
  SYValue : double;
  IB : integer;
  LayerType : integer;
begin
  if ShowWarnings then
  begin
    ErrorStringList := TStringList.Create;
    try
      frmProgress.lblActivity.Caption := 'checking specific yield';
      frmProgress.pbActivity.Position := 0;
      With Discretization do
      begin
        frmProgress.pbActivity.Max := NROW * NCOL * NUNITS;
        for UnitIndex := 0 to NUNITS -1 do
        begin

          LayerType := frmModflow.dgGeol.Columns[Ord(nuiType)].PickList.IndexOf
            (frmModflow.dgGeol.Cells[Ord(nuiType),UnitIndex+1]);
          if (LayerType <> 0) then
          begin
            for ColIndex := 0 to NCOL -1 do
            begin
              for RowIndex := 0 to NROW -1 do
              begin
                IB := BasicPkg.IBOUND[ColIndex, RowIndex, UnitIndex];
                SYValue := Sy[ColIndex, RowIndex, UnitIndex];
                if (IB <> 0) and ((SYValue <= 0) or (SYValue > 1)) then
                begin
                  ErrorStringList.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
                end;
                frmProgress.pbActivity.StepIt;
              end;
            end;
          end;
          if ErrorStringList.Count > 0 then
          begin
            AString := 'Warning: specific yield <= 0 or > 1 in Unit '
               + IntToStr(UnitIndex + 1) + '.';
            frmProgress.reErrors.Lines.Add(AString);
            AString := AString + ' [Col,Row]';
            ErrorMessages.Add('');
            ErrorMessages.Add(AString);
            ErrorMessages.AddStrings(ErrorStringList);
          end;
          ErrorStringList.Clear;
        end;
      end;
    finally
      ErrorStringList.Free;
    end;

  end;
end;

procedure TBCFWriter.CheckHydraulicConductivity(
  Discretization: TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
var
  UnitIndex, ColIndex, RowIndex : integer;
  ErrorStringList : TStringList;
  AString : string;
  Kx : double;
  IB : integer;
begin
  if ShowWarnings then
  begin
    ErrorStringList := TStringList.Create;
    try
      frmProgress.lblActivity.Caption := 'checking hydraulic conductivity';
      frmProgress.pbActivity.Position := 0;
      With Discretization do
      begin
        frmProgress.pbActivity.Max := NROW * NCOL * NUNITS;
        for UnitIndex := 0 to NUNITS -1 do
        begin
          for ColIndex := 0 to NCOL -1 do
          begin
            for RowIndex := 0 to NROW -1 do
            begin
              IB := BasicPkg.IBOUND[ColIndex, RowIndex, UnitIndex];
              Kx := HY[ColIndex, RowIndex, UnitIndex];
              if (IB <> 0) and (Kx <= 0) then
              begin
                ErrorStringList.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
              end;
              frmProgress.pbActivity.StepIt;
            end;
          end;
          if ErrorStringList.Count > 0 then
          begin
            AString := 'Warning: hydraulic conductivity <= 0 in Unit '
               + IntToStr(UnitIndex + 1) + '.';
            frmProgress.reErrors.Lines.Add(AString);
            AString := AString + ' [Col,Row]';
            ErrorMessages.Add('');
            ErrorMessages.Add(AString);
            ErrorMessages.AddStrings(ErrorStringList);
          end;
          ErrorStringList.Clear;
        end;
      end;
    finally
      ErrorStringList.Free;
    end;

  end;
end;

class procedure TBCFWriter.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowBCF.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end;
  end;

end;

end.
