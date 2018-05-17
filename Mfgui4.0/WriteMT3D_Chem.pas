unit WriteMT3D_Chem;

interface

uses Sysutils, Forms, AnePIE, WriteMT3D_Basic, WriteModflowDiscretization;

type
  TMt3dChemWriter = class(TMT3DCustomWriter)
  private
    ISOTHM : integer;
    IREACT : integer;
    IRCTOP : integer;
    IGETSC : integer;
    CurrentModelHandle : ANE_PTR;
    DisWriter : TDiscretizationWriter;
    procedure Write1DChemArray(const Col : integer);
    procedure WriteDataSet1;
    procedure WriteDataSet2A;
    procedure WriteDataSet2B;
    procedure WriteDataSet2C;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
  public
    procedure WriteFile(const ModelHandle: ANE_PTR; const Root: string;
      const Discretization : TDiscretizationWriter);
  end;


implementation

uses ProgressUnit, UtilityFunctions, OptionsUnit, Variables, ModflowUnit,
  WriteNameFileUnit;

{ TMt3dChemWriter }

procedure TMt3dChemWriter.Write1DChemArray(const Col: integer);
var
  Value : double;
  UnitIndex, DivIndex : integer;
begin
  RealArrayHeader(0);
  for UnitIndex := 1 to frmModflow.UnitCount do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      Value := InternationalStrToFloat(frmModflow.sgReaction.Cells[
        Col,UnitIndex]);
      for DivIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        writeLn(FFile, FreeFormattedReal(Value));
      end;
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet1;
begin
  ISOTHM := frmModflow.comboMT3DIsotherm.ItemIndex;
  IREACT := frmModflow.comboMT3DIREACT.ItemIndex;
  if IREACT = 2 then
  begin
    IREACT := 100;
  end;

  if not frmModflow.cbMT3D_OneDArrays.Checked then
  begin
    IRCTOP := 2;
  end
  else
  begin
    IRCTOP := 1;
  end;
  if frmModflow.cbMT3D_StartingConcentration.Checked then
  begin
    IGETSC := 1;
  end
  else
  begin
    IGETSC := 0;
  end;
  writeln(FFile,
    FixedFormattedInteger(ISOTHM, 10),
    FixedFormattedInteger(IREACT, 10),
    FixedFormattedInteger(IRCTOP, 10),
    FixedFormattedInteger(IGETSC, 10));

end;

procedure TMt3dChemWriter.WriteDataSet2A;
var
  ParameterName : string;
  LayerRoot : string;
begin
  if (ISOTHM > 0) and (ISOTHM <> 5) then
  begin
    frmProgress.lblActivity. Caption := 'Writing Bulk Density';
    if frmMODFLOW.cbMT3D_OneDArrays.Checked then
    begin
      Write1DChemArray(Ord(rdmBulkDensity));
    end
    else
    begin
      LayerRoot := ModflowTypes.GetMT3DBulkDensityLayerType.ANE_LayerName;

      ParameterName := LayerRoot;
//      ModflowTypes.
//        GetMT3DBulkDensityParamClassType.ANE_ParamName;

      Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, True);
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet2B;
var
  LayerRoot, ParameterName : string;
begin
  if (ISOTHM >= 5) then
  begin
    frmProgress.lblActivity. Caption := 'Writing Immobile Porosity';
    if frmMODFLOW.cbMT3D_OneDArrays.Checked then
    begin
      Write1DChemArray(Ord(rdmDualPorosity));
    end
    else
    begin
      LayerRoot := ModflowTypes.GetMFMOCImPorosityLayerType.ANE_LayerName;

      ParameterName := ModflowTypes.
        GetMFMOCImPorosityParamType.ANE_ParamName;

      Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, True);
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet2C;
var
  LayerRoot, ParameterName : string;
  SpeciesIndex : integer;
  Col : integer;
begin
  if IGETSC > 0 then
  begin
    frmProgress.lblActivity. Caption := 'Writing Starting Concentration of Sorbed Phase';
    if frmMODFLOW.cbMT3D_OneDArrays.Checked then
    begin
      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        Col := Ord(rdmStartingConcentration) + (SpeciesIndex-1)*5;
        Write1DChemArray(Col);
      end;
    end
    else
    begin
      LayerRoot := ModflowTypes.GetMFMOCImInitConcLayerType.ANE_LayerName;

      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        case SpeciesIndex of
          1: ParameterName := ModflowTypes.
               GetMFMOCImInitConcParamType.ANE_ParamName;
          2: ParameterName := ModflowTypes.
               GetMT3DImInitConc2ParamClassType.ANE_ParamName;
          3: ParameterName := ModflowTypes.
               GetMT3DImInitConc3ParamClassType.ANE_ParamName;
          4: ParameterName := ModflowTypes.
               GetMT3DImInitConc4ParamClassType.ANE_ParamName;
          5: ParameterName := ModflowTypes.
               GetMT3DImInitConc5ParamClassType.ANE_ParamName;
        else Assert(False);
        end;

        Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, True);
      end;
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet3;
var
  LayerRoot, ParameterName : string;
  SpeciesIndex : integer;
  Col : integer;
begin
  if ISOTHM > 0 then
  begin
    frmProgress.lblActivity. Caption := 'Writing First Sorption Parameter';
    if frmMODFLOW.cbMT3D_OneDArrays.Checked then
    begin
      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        if SpeciesIndex = 1 then
        begin
          Col := Ord(rdmSorpConst1)
        end
        else
        begin
          Col := Ord(rdmStartingConcentration) + 1 + (SpeciesIndex-2)*5
        end;
        Write1DChemArray(Col);
      end;
    end
    else
    begin
      LayerRoot := ModflowTypes.GetMT3DSorptionLayerType.ANE_LayerName;

      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        case SpeciesIndex of
          1: ParameterName := ModflowTypes.
               GetMT3DSP1AParamClassType.ANE_ParamName;
          2: ParameterName := ModflowTypes.
               GetMT3DSP1BParamClassType.ANE_ParamName;
          3: ParameterName := ModflowTypes.
               GetMT3DSP1CParamClassType.ANE_ParamName;
          4: ParameterName := ModflowTypes.
               GetMT3DSP1DParamClassType.ANE_ParamName;
          5: ParameterName := ModflowTypes.
               GetMT3DSP1EParamClassType.ANE_ParamName;
        else Assert(False);
        end;

        Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, False);
      end;
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet4;
var
  LayerRoot, ParameterName : string;
  SpeciesIndex : integer;
  Col : integer;
begin
  if ISOTHM > 0 then
  begin
    frmProgress.lblActivity. Caption := 'Writing Second Sorption Parameter';
    if frmMODFLOW.cbMT3D_OneDArrays.Checked then
    begin
      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        if SpeciesIndex = 1 then
        begin
          Col := Ord(rdmSorpConst2)
        end
        else
        begin
          Col := Ord(rdmStartingConcentration) + 2 + (SpeciesIndex-2)*5
        end;
        Write1DChemArray(Col);
      end;
    end
    else
    begin
      LayerRoot := ModflowTypes.GetMT3DSorptionLayerType.ANE_LayerName;

      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        case SpeciesIndex of
          1: ParameterName := ModflowTypes.
               GetMT3DSP2AParamClassType.ANE_ParamName;
          2: ParameterName := ModflowTypes.
               GetMT3DSP2BParamClassType.ANE_ParamName;
          3: ParameterName := ModflowTypes.
               GetMT3DSP2CParamClassType.ANE_ParamName;
          4: ParameterName := ModflowTypes.
               GetMT3DSP2DParamClassType.ANE_ParamName;
          5: ParameterName := ModflowTypes.
               GetMT3DSP2EParamClassType.ANE_ParamName;
        else Assert(False);
        end;

        Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, False);
      end;
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet5;
var
  LayerRoot, ParameterName : string;
  SpeciesIndex : integer;
  Col : integer;
begin
  if IREACT > 0 then
  begin
    frmProgress.lblActivity. Caption := 'Writing First Order Reaction Rate for the Dissolved Phase';
    if frmMODFLOW.cbMT3D_OneDArrays.Checked then
    begin
      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        if SpeciesIndex = 1 then
        begin
          Col := Ord(rdmRateConstDiss)
        end
        else
        begin
          Col := Ord(rdmStartingConcentration) + 3 + (SpeciesIndex-2)*5
        end;
        Write1DChemArray(Col);
      end;
    end
    else
    begin
      LayerRoot := ModflowTypes.GetMT3DReactionLayerType.ANE_LayerName;

      for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
      begin
        case SpeciesIndex of
          1: ParameterName := ModflowTypes.
               GetMT3DRC1AParamClassType.ANE_ParamName;
          2: ParameterName := ModflowTypes.
               GetMT3DRC1BParamClassType.ANE_ParamName;
          3: ParameterName := ModflowTypes.
               GetMT3DRC1CParamClassType.ANE_ParamName;
          4: ParameterName := ModflowTypes.
               GetMT3DRC1DParamClassType.ANE_ParamName;
          5: ParameterName := ModflowTypes.
               GetMT3DRC1EParamClassType.ANE_ParamName;
        else Assert(False);
        end;

        Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, False);
      end;
    end;
  end;
end;

procedure TMt3dChemWriter.WriteDataSet6;
var
  LayerRoot, ParameterName : string;
  SpeciesIndex : integer;
  Col : integer;
  UnitIndex, DisIndex, RowIndex, ColIndex : integer;
  AValue : double;
begin
  if IREACT > 0 then
  begin
    frmProgress.lblActivity. Caption := 'Writing Second Order Reaction Rate for the Sorbed Phase';
    if (frmModflow.comboMT3DIsotherm.ItemIndex > 0)
      and (frmModflow.comboMT3DIsotherm.ItemIndex <> 5) then
    begin
      if frmMODFLOW.cbMT3D_OneDArrays.Checked then
      begin
        for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
        begin
          if SpeciesIndex = 1 then
          begin
            Col := Ord(rdmRateConstDiss)
          end
          else
          begin
            Col := Ord(rdmStartingConcentration) + 4 + (SpeciesIndex-2)*5
          end;
          Write1DChemArray(Col);
        end;
      end
      else
      begin
        LayerRoot := ModflowTypes.GetMT3DReactionLayerType.ANE_LayerName;

        for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
        begin
          case SpeciesIndex of
            1: ParameterName := ModflowTypes.
                 GetMT3DRC2AParamClassType.ANE_ParamName;
            2: ParameterName := ModflowTypes.
                 GetMT3DRC2BParamClassType.ANE_ParamName;
            3: ParameterName := ModflowTypes.
                 GetMT3DRC2CParamClassType.ANE_ParamName;
            4: ParameterName := ModflowTypes.
                 GetMT3DRC2DParamClassType.ANE_ParamName;
            5: ParameterName := ModflowTypes.
                 GetMT3DRC2EParamClassType.ANE_ParamName;
          else Assert(False);
          end;

          Write3DArrays(CurrentModelHandle, DisWriter, LayerRoot, ParameterName, False);
        end;
      end;
    end
    else
    begin
      if frmMODFLOW.cbMT3D_OneDArrays.Checked then
      begin
        for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
        begin
          if SpeciesIndex = 1 then
          begin
            Col := Ord(rdmRateConstDiss)
          end
          else
          begin
            Col := Ord(rdmStartingConcentration) + 4 + (SpeciesIndex-2)*5
          end;
          Write1DChemArray(Col);
        end;
      end
      else
      begin
        for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
        begin
          for UnitIndex := 1 to DisWriter.NUNITS do
          begin
            if frmModflow.Simulated(UnitIndex) then
            begin
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
                    AValue := 0;
                    Write(FFile, Format('%g ', [AValue]));
                    frmProgress.pbActivity.StepIt;
                  end;
                  WriteLn(FFile);
                end;
              end;
            end;
          end;
        end;
      end;

    end;

  end;
end;

procedure TMt3dChemWriter.WriteFile(const ModelHandle: ANE_PTR;
  const Root: string; const Discretization: TDiscretizationWriter);
var
  FileName : string;
begin
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 7;

  Assert(Discretization <> nil);
  DisWriter := Discretization;
  CurrentModelHandle := ModelHandle;
  FileName := GetCurrentDir + '\' + Root + rsRCT;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    WriteDataSet1;
    WriteDataSet2A;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet2B;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet2C;
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
    if not ContinueExport then Exit;

    WriteDataSet5;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet6;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

  finally
    CloseFile(FFile);
  end;
end;

end.
