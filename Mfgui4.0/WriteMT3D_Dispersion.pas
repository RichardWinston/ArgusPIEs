unit WriteMT3D_Dispersion;

interface

uses Sysutils, Classes, Forms, AnePIE, WriteMT3D_Basic,
  WriteModflowDiscretization, ModflowUnit;

type
  TMt3dDispersionWriter = class(TMT3DCustomWriter)
  private
    CurrentModelHandle : ANE_PTR;
    DisWriter : TDiscretizationWriter;
    procedure WriteDispersionArray(const Column : MT3DDispersionData);
    procedure WriteDataSet0;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteMolecularDiffusion;
  public
    procedure WriteFile(const ModelHandle: ANE_PTR; const Root: string;
      const Discretization : TDiscretizationWriter);
  end;

implementation

uses UtilityFunctions, OptionsUnit, ProgressUnit, Variables, WriteNameFileUnit;

{ TMt3dDispersionWriter }

procedure TMt3dDispersionWriter.WriteDataSet1;
var
  AL : array of array of double;
  UnitIndex : integer;
  ParameterName : string;
  GridLayer : TLayerOptions;
  ParameterIndex: ANE_INT16;
  RowIndex, ColIndex : integer;
  BlockIndex : integer;
  DisIndex : integer;
  Block : TBlockObjectOptions;
  AValue : double;
begin
  SetLength(AL, DisWriter.NROW, DisWriter.NCOL);
  GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
  try
    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        ParameterName := ModflowTypes.GetGridMT3DLongDispCellParamClassType.ANE_ParamName
          + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
        for RowIndex := 0 to DisWriter.NROW-1 do
        begin
          for ColIndex := 0 to DisWriter.NCOL -1 do
          begin
            BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
            Block := TBlockObjectOptions.Create(CurrentModelHandle,DisWriter.GridLayerHandle,
              BlockIndex);
            try
              AL[RowIndex,ColIndex] := Block.
                GetFloatParameter(CurrentModelHandle,ParameterIndex);
            finally
              Block.Free;
            end;
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
              AValue := AL[RowIndex,ColIndex];
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
    SetLength(AL, 0,0);
  end;

end;

procedure TMt3dDispersionWriter.WriteDataSet2;
begin
  WriteDispersionArray(ddmHorDisp);
end;

procedure TMt3dDispersionWriter.WriteDataSet3;
begin
  WriteDispersionArray(ddmVertDisp);
end;

procedure TMt3dDispersionWriter.WriteMolecularDiffusion;
var
  NumberOfMobileSpecies: integer;
  ParameterNames: TStringList;
  DMCOEF: array of array of double;
  X, Y: array of array of ANE_DOUBLE;
  UnitIndex : integer;
  ParameterName, LayerName : string;
  GridLayer, MolDiffLayer : TLayerOptions;
  ParameterIndex: ANE_INT16;
  RowIndex, ColIndex : integer;
  BlockIndex : integer;
  DisIndex : integer;
  Block : TBlockObjectOptions;
  AValue : double;
  Expression: string;
  ParamIndex: integer;
begin
  NumberOfMobileSpecies := StrToInt(frmModflow.adeMT3DMCOMP.Text);
  ParameterNames := TStringList.Create;
  try
    ParameterNames.Add(ModflowTypes.GetMT3DMolDiffAParamClassType.WriteParamName);
    if NumberOfMobileSpecies >= 2 then
    begin
      ParameterNames.Add(ModflowTypes.GetMT3DMolDiffBParamClassType.WriteParamName);
    end;
    if NumberOfMobileSpecies >= 3 then
    begin
      ParameterNames.Add(ModflowTypes.GetMT3DMolDiffCParamClassType.WriteParamName);
    end;
    if NumberOfMobileSpecies >= 4 then
    begin
      ParameterNames.Add(ModflowTypes.GetMT3DMolDiffDParamClassType.WriteParamName);
    end;
    if NumberOfMobileSpecies >= 5 then
    begin
      ParameterNames.Add(ModflowTypes.GetMT3DMolDiffEParamClassType.WriteParamName);
    end;

    SetLength(DMCOEF, DisWriter.NROW, DisWriter.NCOL);
    SetLength(X, DisWriter.NROW, DisWriter.NCOL);
    SetLength(Y, DisWriter.NROW, DisWriter.NCOL);
    try
      GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
      try
        for RowIndex := 0 to DisWriter.NROW-1 do
        begin
          for ColIndex := 0 to DisWriter.NCOL -1 do
          begin
            BlockIndex := DisWriter.BlockIndex(RowIndex,ColIndex);
            Block := TBlockObjectOptions.Create(CurrentModelHandle,DisWriter.GridLayerHandle,
              BlockIndex);
            try
              Application.ProcessMessages;
              if not ContinueExport then Exit;
              Block.GetCenter(CurrentModelHandle, X[RowIndex, ColIndex],
                Y[RowIndex, ColIndex]);
            finally
              Block.Free;
            end;
          end;
        end;
      finally
        GridLayer.Free(CurrentModelHandle);
      end;

      for ParamIndex := 0 to ParameterNames.Count -1 do
      begin
        ParameterName := ParameterNames[ParamIndex];
        for UnitIndex := 1 to DisWriter.NUNITS do
        begin
          if frmModflow.Simulated(UnitIndex) then
          begin
            LayerName :=
              ModflowTypes.GetMFMT3DMolecularDiffusionLayerType.ANE_LayerName
                + IntToStr(UnitIndex);
            Expression := LayerName + '.' + ParameterName;

            MolDiffLayer := TLayerOptions.
              CreateWithName(LayerName, CurrentModelHandle);
            try
              for RowIndex := 0 to DisWriter.NROW-1 do
              begin
                for ColIndex := 0 to DisWriter.NCOL -1 do
                begin
                  Application.ProcessMessages;
                  if not ContinueExport then Exit;
                  DMCOEF[RowIndex, ColIndex] :=
                    MolDiffLayer.RealValueAtXY(CurrentModelHandle,
                    X[RowIndex, ColIndex], Y[RowIndex, ColIndex],
                    Expression);
                end;
              end;
            finally
              MolDiffLayer.Free(CurrentModelHandle);
            end;
            for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
            begin
              RealArrayHeader(0);
              for RowIndex := 0 to DisWriter.NROW -1 do
              begin
                for ColIndex := 0 to DisWriter.NCOL -1 do
                begin
                  Application.ProcessMessages;
                  if not ContinueExport then Exit;
                  AValue := DMCOEF[RowIndex,ColIndex];
                  Write(FFile, Format('%g ', [AValue]));
                  frmProgress.pbActivity.StepIt;
                end;
                WriteLn(FFile);
              end;
            end;
          end;
        end;
      end;
    finally
      SetLength(DMCOEF, 0,0);
      SetLength(X, 0,0);
      SetLength(Y, 0,0);
    end;
  finally
    ParameterNames.Free;
  end;
end;

procedure TMt3dDispersionWriter.WriteDataSet4;
begin
  if frmModflow.cbMt3dMultiDiffusion.Checked then
  begin
    WriteMolecularDiffusion;
  end
  else
  begin
    WriteDispersionArray(ddmMolDiffCoef);
  end;
end;

procedure TMt3dDispersionWriter.WriteDispersionArray(
  const Column: MT3DDispersionData);
var
  DispArray : array of double;
  UnitIndex, DisIndex, LayerIndex : integer;
  AValue : double;
begin
  SetLength(DispArray, DisWriter.NLAY);
  LayerIndex := 0;
  with frmModflow do
  begin
    for UnitIndex := 1 to DisWriter.NUNITS do
    begin
      if Simulated(UnitIndex) then
      begin
        AValue := InternationalStrToFloat(sgDispersion.
          Cells[Ord(Column),UnitIndex]);
        for DisIndex := 1 to DiscretizationCount(UnitIndex) do
        begin
          Assert(LayerIndex < Length(DispArray));
          DispArray[LayerIndex] := AValue;
          Inc(LayerIndex);
        end;
      end;
    end;
  end;
  Write1DArray(DispArray);

end;

procedure TMt3dDispersionWriter.WriteFile(const ModelHandle: ANE_PTR;
  const Root: string; const Discretization: TDiscretizationWriter);
var
  FileName : string;
begin
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 4;

  Assert(Discretization <> nil);
  DisWriter := Discretization;
  CurrentModelHandle := ModelHandle;
  FileName := GetCurrentDir + '\' + Root + rsDSP;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);

    WriteDataSet0;
    WriteDataSet1;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet2;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet3;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet4;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

  finally
    CloseFile(FFile);
  end;
end;

procedure TMt3dDispersionWriter.WriteDataSet0;
begin
  if frmModflow.cbMt3dMultiDiffusion.Checked then
  begin
    WriteLn(FFile, '$ MultiDiffusion');
  end;
end;

end.
