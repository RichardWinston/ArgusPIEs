unit UpdateOldFiles;

interface

uses AnePIE;

procedure UpdateOldNamesAndExpressions(aneHandle : ANE_PTR );

implementation

uses OptionsUnit, SLSutraMesh, SLDispersivity, SLSourcesOfFluid,
     SLEnergySoluteSources, SLSpecifiedPressure, SLSpecConcOrTemp,
     SLInitConcOrTemp, frmSutraUnit, GlobalVariables;

procedure UpdateOldNamesAndExpressions(aneHandle : ANE_PTR );
Var
  MeshHandle : ANE_PTR;
  MeshLayer : TLayerOptions;
  LayerHandle : ANE_PTR;
  Layer : TLayerOptions;
  Project : TProjectOptions;
  ParameterIndex : integer;
  Parameter : TParameterOptions;
  OldLayerName, NewLayerName, OldParameterName, NewParameterName : string;
begin
    Project := TProjectOptions.Create;
    try
      NewLayerName :=  TSutraMeshLayer.WriteNewRoot;
      MeshHandle := Project.GetLayerByName(aneHandle, NewLayerName);
      MeshLayer := TLayerOptions.Create(MeshHandle);
      try
        OldParameterName := 'THICK';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TZParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add(NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TZParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        OldParameterName := 'ATMAX';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TAT1MAXParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TAT1MAXParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        OldParameterName := 'ATMIN';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TAT1MINParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TAT1MINParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;
      finally
        MeshLayer.Free(aneHandle);
      end;
      NewLayerName :=  TDispersivityLayer.WriteNewRoot;
      LayerHandle := Project.GetLayerByName(aneHandle, NewLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        OldParameterName := 'trandisp_in_max_permdir';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TMaxTransDisp1Param.WriteParamName;
          if OldParameterName <> NewParameterName then
          begin
            Parameter.Rename(aneHandle,TMaxTransDisp1Param.WriteParamName);
            frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
              OldParameterName + '" renamed "' + NewLayerName + '.' +
              NewParameterName + '".');
          end;
        finally
          Parameter.Free;
        end;

        OldParameterName := 'trandisp_in_min_permdir';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TMinTransDisp1Param.WriteParamName;
          if OldParameterName <> NewParameterName then
          begin
            Parameter.Rename(aneHandle,NewParameterName);
            frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
              OldParameterName + '" renamed "' + NewLayerName + '.' +
              NewParameterName + '".');
          end;
        finally
          Parameter.Free;
        end;

      finally
        Layer.Free(aneHandle);
      end;
    finally
      Project.Free;
    end;



  if frmSutra.rbGeneral.Checked then
  begin
    Project := TProjectOptions.Create;
    try
      NewLayerName :=  TSutraMeshLayer.WriteNewRoot;
      MeshHandle := Project.GetLayerByName(aneHandle, NewLayerName);
      MeshLayer := TLayerOptions.Create(MeshHandle);
      try
{        OldParameterName := 'THICK';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TZParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add(NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TZParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
        finally
          Parameter.Free;
        end;  }

        NewParameterName := TPORParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TPORParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

{        OldParameterName := 'ATMAX';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TAT1MAXParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TAT1MAXParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
        finally
          Parameter.Free;
        end;

        OldParameterName := 'ATMIN';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TAT1MINParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TAT1MINParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
        finally
          Parameter.Free;
        end;  }

        NewParameterName := TQINParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TQINParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TUINParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TUINParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TQUINParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TQUINParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TTimeDepEnergySoluteSourceParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TTimeDepEnergySoluteSourceParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TpUBCParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TpUBCParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TUBCParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TUBCParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TTimeDepSpecConcTempParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TTimeDepSpecConcTempParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TUVECParam.WriteParamName;
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TUVECParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

      finally
        MeshLayer.Free(aneHandle);
      end;

{      NewLayerName :=  TDispersivityLayer.WriteNewRoot;
      LayerHandle := Project.GetLayerByName(aneHandle, NewLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        OldParameterName := 'trandisp_in_max_permdir';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TMaxTransDisp1Param.WriteParamName;
          Parameter.Rename(aneHandle,TMaxTransDisp1Param.WriteParamName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;

        OldParameterName := 'trandisp_in_min_permdir';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TMinTransDisp1Param.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;

      finally
        Layer.Free(aneHandle);
      end;}

      NewLayerName :=  TFluidSourcesLayer.WriteNewRoot;
      LayerHandle := Project.GetLayerByName(aneHandle, NewLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        OldParameterName := 'conc_or_temp_of_source';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TConcTempSourceParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;

        NewParameterName := TResultantFluidSourceParam.WriteParamName;
        ParameterIndex := Layer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TResultantFluidSourceParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;

        NewParameterName := TQINUINParam.WriteParamName;
        ParameterIndex := Layer.GetParameterIndex(aneHandle, NewParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TQINUINParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;
      finally
        Layer.Free(aneHandle);
      end;

      OldLayerName :=  'Sources of Energy or Solute';
      LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        NewLayerName :=  TSoluteEnergySourcesLayer.WriteNewRoot;
        Layer.Rename(aneHandle,NewLayerName);
        frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
          '" renamed "' + NewLayerName  + '".');

        OldParameterName := 'RESULTANT_ENERGY_OR_SOLUTE_SOURCES';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TResultantSoluteEnergySourceParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');

          Parameter.Expr[aneHandle] := TResultantSoluteEnergySourceParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression has been changed.');
{          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            NewParameterName + '" expression needs to be changed.');}
        finally
          Parameter.Free;
        end;
      finally
        Layer.Free(aneHandle);
      end;

      NewLayerName :=  TSpecifiedPressureLayer.WriteNewRoot;
      LayerHandle := Project.GetLayerByName(aneHandle, NewLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        OldParameterName := 'conc_or_temp';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TConcOrTempParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;

      finally
        Layer.Free(aneHandle);
      end;

      OldLayerName :=  'Specified Conc or Temp';
      LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        NewLayerName :=  TSpecConcTempLayer.WriteNewRoot;
        Layer.Rename(aneHandle,NewLayerName);
        frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
          '" renamed "' + NewLayerName  + '".');

        OldParameterName := 'specified_conc_or_temp';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TSpecConcTempParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;

      finally
        Layer.Free(aneHandle);
      end;

      OldLayerName :=  'Initial Conc or Temp';
      LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        NewLayerName :=  TInitialConcTempLayer.WriteNewRoot;
        Layer.Rename(aneHandle,NewLayerName);
        frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
          '" renamed "' + NewLayerName  + '".');

        OldParameterName := 'initial_conc_or_temp';
        ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := TInitialConcTempParam.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;

      finally
        Layer.Free(aneHandle);
      end;

    finally
      Project.Free;
    end;
  end;

end;

end.
