unit WriteSeawatViscosity;

interface

uses SysUtils, Forms, ANEPIE, OptionsUnit, WriteModflowDiscretization;

type
  T2DArray = array of array of ANE_DOUBLE;

  TSeawatViscosityWriter = class(TModflowWriter)
  private
    FModelHandle: ANE_PTR;
    FDiscretization : TDiscretizationWriter;
    FBasicPkg: TBasicPkgWriter;
    MT3DMUFLG: integer;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet3A_to_3D;
    procedure WriteDataSets4and5;
    procedure SetArray(var AnArray: T2DArray; Layer: TLayerOptions;
      const ParameterName: string; UnitIndex: integer);
  public
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; BasicPkg: TBasicPkgWriter);
  end;

implementation

uses ProgressUnit, WriteNameFileUnit, Variables;

{ TSeawatViscosityWriter }

procedure TSeawatViscosityWriter.SetArray(var AnArray: T2DArray;
  Layer: TLayerOptions; const ParameterName: string; UnitIndex: integer);
var
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  X, Y: ANE_DOUBLE;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := FDiscretization.NROW
    * FDiscretization.NCOL;

  for RowIndex := 0 to FDiscretization.NROW -1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    for ColIndex := 0 to FDiscretization.NCOL -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if FBasicPkg.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
      begin
        AnArray[ColIndex, RowIndex] := 0;
      end
      else
      begin
        BlockIndex := FDiscretization.BlockIndex(RowIndex, ColIndex);
        ABlock := TBlockObjectOptions.Create(FModelHandle,
          FDiscretization.GridLayerHandle, BlockIndex);
        try
          ABlock.GetCenter(FModelHandle, X, Y);

          AnArray[ColIndex, RowIndex] := Layer.RealValueAtXY(FModelHandle, X, Y, ParameterName);
        finally
          ABlock.Free;
        end;
      end;

      frmProgress.pbActivity.StepIt;
    end;
  end;

end;

procedure TSeawatViscosityWriter.WriteDataSet1;
begin
  MT3DMUFLG := frmModflow.comboSW_ViscosityMethod.ItemIndex -1;
  if MT3DMUFLG >= 1 then
  begin
    MT3DMUFLG := StrToInt(frmModflow.adeSwViscSpecies.Text);
  end;
  WriteLn(FFile, MT3DMUFLG);
end;

procedure TSeawatViscosityWriter.WriteDataSet2;
var
  VISCMIN, VISCMAX: double;
begin
  VISCMIN := StrToFloat(frmModflow.adeSW_ViscMin.Text);
  VISCMAX := StrToFloat(frmModflow.adeSW_ViscMax.Text);
  WriteLn(FFile, FreeFormattedReal(VISCMIN), FreeFormattedReal(VISCMAX));
end;

procedure TSeawatViscosityWriter.WriteDataSet3;
var
  VISCREF: double;
  DMUDC: double;
  CMUREF: double;
begin
  if MT3DMUFLG >= 0 then
  begin
    VISCREF := StrToFloat(frmModflow.adeSW_RefVisc.Text);
    DMUDC := StrToFloat(frmModflow.adeSW_ViscositySlope.Text);
    CMUREF := StrToFloat(frmModflow.adeSW_RefViscConc.Text);
    WriteLn(FFile, FreeFormattedReal(VISCREF), FreeFormattedReal(DMUDC),
      FreeFormattedReal(CMUREF));
  end;
end;

procedure TSeawatViscosityWriter.WriteDataSet3A_to_3D;
var
  VISCREF: double;
  NSMUEOS: integer;
  MUTEMPOPT: integer;
  MTMUSPEC: integer;
  DMUDC, CMUREF: double;
  MTMUTEMPSPEC: integer;
  Index: integer;
  ColIndex: integer;
  A: double;
begin
  if MT3DMUFLG = -1 then
  begin
    // 3a
    VISCREF := StrToFloat(frmModflow.adeSW_RefVisc.Text);
    WriteLn(FFile, FreeFormattedReal(VISCREF));

    // 3b
    NSMUEOS := StrToInt(frmModflow.adeSW_ViscEquationCount.Text);
    MUTEMPOPT := frmModflow.comboSW_ViscEquation.ItemIndex;
    writeLn(FFile, NSMUEOS, ' ', MUTEMPOPT);

    // 3c
    for Index := 1 to NSMUEOS do
    begin
      MTMUSPEC := StrToInt(frmModflow.rdgSW_ViscEq.Cells[1,Index]);
      DMUDC := StrToFloat(frmModflow.rdgSW_ViscEq.Cells[2,Index]);
      CMUREF := StrToFloat(frmModflow.rdgSW_ViscEq.Cells[3,Index]);
      writeLn(FFile, MTMUSPEC, ' ', FreeFormattedReal(DMUDC),
        FreeFormattedReal(CMUREF));
    end;

    // 3d
    if MUTEMPOPT > 0 then
    begin
      MTMUTEMPSPEC := StrToInt(frmModflow.rdgSW_ViscEqTemp.Cells[0,1]);
      write(FFile, MTMUTEMPSPEC, ' ');
      for ColIndex := 1 to frmModflow.rdgSW_ViscEqTemp.ColCount -1 do
      begin
        A := StrToFloat(frmModflow.rdgSW_ViscEqTemp.Cells[ColIndex,1]);
        write(FFile, FreeFormattedReal(A));
      end;
      WriteLn(FFile);
    end;
  end;
end;

procedure TSeawatViscosityWriter.WriteDataSets4and5;
var
  TimeIndex: integer;
  UnitIndex: integer;
  Viscosity: T2DArray;
  INVISC: integer;
  ParameterName: string;
  LayerName: string;
  Layer: TLayerOptions;
  RowIndex, ColIndex: integer;
begin
  if MT3DMUFLG = 0 then
  begin
    SetLength(Viscosity, FDiscretization.NCOL, FDiscretization.NROW);
    for TimeIndex := 1 to FDiscretization.NPER do
    begin
      ParameterName := '';
      INVISC := -2;
      case frmModflow.comboSW_TimeVaryingViscosity.ItemIndex of
        0:
          begin
            if TimeIndex = 1 then
            begin
              INVISC := 1;
              ParameterName := ModflowTypes.GetMFViscosityParamType.WriteParamName;
            end
            else
            begin
              INVISC := -1;
            end;
          end;
        1:
          begin
            INVISC := 1;
            ParameterName := ModflowTypes.GetMFViscosityParamType.WriteParamName
              + IntToStr(TimeIndex);
          end;
        2:
          begin
            INVISC := 0;
          end;
        3:
          begin
            if TimeIndex = 1 then
            begin
              INVISC := 2;
              ParameterName := ModflowTypes.GetMFViscosityParamType.WriteParamName;
            end
            else
            begin
              INVISC := -1;
            end;
          end;
        4:
          begin
            INVISC := 2;
            ParameterName := ModflowTypes.GetMFViscosityParamType.WriteParamName
              + IntToStr(TimeIndex);
          end;
      else Assert(False);
      end;

      // data set 4
      WriteLn(FFile, INVISC);

      // data set 5
      if INVISC > 0 then
      begin
        for UnitIndex := 1 to frmModflow.UnitCount  do
        begin
          if frmModflow.Simulated(UnitIndex) then
          begin
            LayerName := ModflowTypes.GetMFViscosityLayerType.ANE_LayerName
              + IntToStr(UnitIndex);
            Layer := TLayerOptions.CreateWithName(LayerName, FModelHandle);
            try
              SetArray(Viscosity, Layer, ParameterName, UnitIndex);
              WriteU2DRELHeader;
              for RowIndex := 0 to FDiscretization.NROW -1 do
              begin
                for ColIndex := 0 to FDiscretization.NCOL -1 do
                begin
                  Write(FFile, FreeFormattedReal(Viscosity[ColIndex,RowIndex]));
                  if (ColIndex=FDiscretization.NCOL -1)
                    or (((ColIndex +1) mod 10) = 0) then
                  begin
                    WriteLn(FFile);
                  end;
                end;
              end;
            finally
              Layer.Free(FModelHandle);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSeawatViscosityWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter);
var
  FileName : string;
begin
  Assert(CurrentModelHandle <> nil);
  FModelHandle := CurrentModelHandle;
  Assert(Discretization <> nil);
  FDiscretization := Discretization;
  Assert(BasicPkg <> nil);
  FBasicPkg := BasicPkg;

  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsVSC;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      if ContinueExport then
      begin
        WriteDataReadFrom(FileName);
      end;
      if ContinueExport then
      begin
        WriteDataSet1;
      end;
      if ContinueExport then
      begin
        WriteDataSet2;
      end;
      if ContinueExport then
      begin
        WriteDataSet3;
      end;
      if ContinueExport then
      begin
        WriteDataSet3A_to_3D;
      end;
      if ContinueExport then
      begin
        WriteDataSets4and5;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;

end;

end.
