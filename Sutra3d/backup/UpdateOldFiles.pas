unit UpdateOldFiles;

interface

uses Sysutils, AnePIE;

procedure UpdateOldNamesAndExpressions(aneHandle : ANE_PTR );
procedure UpdateOldNamesAndExpressions2(aneHandle : ANE_PTR );
{$IFDEF SutraIce}
procedure RenameRegionLayerAndParameter(aneHandle : ANE_PTR );
{$ENDIF}

implementation

uses OptionsUnit, SLSutraMesh, SLDispersivity, SLSourcesOfFluid,
     SLEnergySoluteSources, SLSpecifiedPressure, SLSpecConcOrTemp,
     SLInitConcOrTemp, frmSutraUnit, GlobalVariables, SLObservation,
  ANE_LayerUnit, SLUnsaturated;

procedure RenameLayers(OldLayerRoot, NewLayerRoot : string;
  Project : TProjectOptions; aneHandle : ANE_PTR);
var
  LayerIndex: integer;
  OldLayerName: string;
  LayerHandle : ANE_PTR;
  Layer: TLayerOptions;
  NewLayerName: string;
begin
  LayerIndex := 1;
  OldLayerName := OldLayerRoot + IntToStr(LayerIndex);
  LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
  While LayerHandle <> nil do
  begin
    Layer := TLayerOptions.Create(LayerHandle);
    try
      NewLayerName :=  NewLayerRoot + IntToStr(LayerIndex);
      Layer.Rename(aneHandle,NewLayerName);
      frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
        '" renamed "' + NewLayerName  + '".');
    finally
      Layer.Free(aneHandle);
    end;
    Inc(LayerIndex);
    OldLayerName := OldLayerRoot + IntToStr(LayerIndex);
    LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
  end;
end;

procedure RenameALayer(const OldLayerName: string;
  LayerClass: T_ANE_MapsLayerClass; Project : TProjectOptions;
  aneHandle : ANE_PTR );
var
  LayerHandle : ANE_PTR;
  Layer: TLayerOptions;
  NewLayerName: string;
begin
  LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
  if LayerHandle <> nil then
  begin
    Layer := TLayerOptions.Create(LayerHandle);
    try
      NewLayerName :=  LayerClass.WriteNewRoot;
      Layer.Rename(aneHandle,NewLayerName);
      frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
        '" renamed "' + NewLayerName  + '".');
    finally
      Layer.Free(aneHandle);
    end;
  end;
end;

procedure RenameAParameter(const OldParameterName, LayerName: string;
  ParamClass: T_ANE_ParamClass; aneHandle : ANE_PTR;
  Project : TProjectOptions);
var
  ParameterIndex: ANE_INT32;
  NewParameterName: string;
  Parameter: TParameterOptions;
  LayerHandle : ANE_PTR;
  Layer: TLayerOptions;
begin
  LayerHandle := Project.GetLayerByName(aneHandle, LayerName);
  if LayerHandle <> nil then
  begin
    Layer := TLayerOptions.Create(LayerHandle);
    try
      ParameterIndex := Layer.GetParameterIndex(aneHandle, OldParameterName);
      if ParameterIndex >= 0 then
      begin
        Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
        try
          NewParameterName := ParamClass.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add(LayerName + '.' +
            OldParameterName + '" renamed "' + LayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;
      end;
    finally
      Layer.Free(aneHandle);
    end;
  end;
end;

procedure RenameParameters(const LayerRoot, OldParameterName: string;
  Project : TProjectOptions; ParamClass: T_ANE_ParamClass;
  aneHandle : ANE_PTR);
var
  LayerIndex: integer;
  LayerName: string;
  LayerHandle : ANE_PTR;
  Layer: TLayerOptions;
  NewLayerName: string;
begin
  LayerIndex := 1;
  LayerName := LayerRoot + IntToStr(LayerIndex);
  LayerHandle := Project.GetLayerByName(aneHandle, LayerName);
  While LayerHandle <> nil do
  begin
    RenameAParameter(OldParameterName, LayerName,
      ParamClass, aneHandle, Project);
    Inc(LayerIndex);
    LayerName := LayerRoot + IntToStr(LayerIndex);
    LayerHandle := Project.GetLayerByName(aneHandle, LayerName);
  end;
end;

{$IFDEF SutraIce}
procedure RenameRegionLayerAndParameter(aneHandle : ANE_PTR );
var
  Project : TProjectOptions;
  OldLayerName, OldLayerRoot: string;
begin
  Project := TProjectOptions.Create;
  try
    OldLayerName :=  'Unsaturated Properties';
    RenameALayer(OldLayerName, TUnsaturatedLayer, Project, aneHandle);
    RenameAParameter('region', TUnsaturatedLayer.WriteNewRoot,
      TRegionParam, aneHandle, Project);

    OldLayerRoot := 'Unsaturated Properties Unit';
    RenameLayers(OldLayerRoot,
      TUnsaturatedLayer.WriteNewRoot, Project, aneHandle);
    RenameParameters(TUnsaturatedLayer.WriteNewRoot, 'region', Project,
      TRegionParam, aneHandle);

  finally
    Project.Free;
  end;
end;
{$ENDIF}


procedure UpdateOldNamesAndExpressions2(aneHandle : ANE_PTR );
Var
  MeshHandle : ANE_PTR;
  MeshLayer : TLayerOptions;
  Project : TProjectOptions;
  ParameterIndex : integer;
  Parameter : TParameterOptions;
  NewLayerName, OldParameterName, NewParameterName : string;
  OldLayerName: string;
  LayerHandle : ANE_PTR;
  Layer: TLayerOptions;
begin
  Project := TProjectOptions.Create;
  try
    NewLayerName :=  TSutraMeshLayer.WriteNewRoot;
    MeshHandle := Project.GetLayerByName(aneHandle, NewLayerName);
    if MeshHandle <> nil then
    begin
      MeshLayer := TLayerOptions.Create(MeshHandle);
      try
        OldParameterName := 'ANGLEX';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        if ParameterIndex >= 0 then
        begin
          Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
          try
            NewParameterName := TANGLE1Param.WriteParamName;
            Parameter.Rename(aneHandle,NewParameterName);
            frmWarnings.memoWarnings.Lines.Add(NewLayerName + '.' +
              OldParameterName + '" renamed "' + NewLayerName + '.' +
              NewParameterName + '".');
          finally
            Parameter.Free;
          end;
        end;

        OldParameterName := 'INOB';
        ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
        if ParameterIndex >= 0 then
        begin
          Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
          try
            Parameter.Expr[aneHandle] := TINOBParam.UsualValue;
            frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
              OldParameterName + '" expression has been changed.');
          finally
            Parameter.Free;
          end;
        end;

      finally
        MeshLayer.Free(aneHandle);
      end;
    end;

    OldLayerName :=  'Observation';
    LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
    if LayerHandle <> nil then
    begin
      Layer := TLayerOptions.Create(LayerHandle);
      try
        NewLayerName :=  T2DObservationLayer.WriteNewRoot;
        Layer.Rename(aneHandle,NewLayerName);
        frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
          '" renamed "' + NewLayerName  + '".');
      finally
        Layer.Free(aneHandle);
      end;
    end;

    RenameLayers('Observation Points',
      TPoint3DObservationLayer.WriteNewRoot, Project, aneHandle);
    RenameLayers('Observation Lines',
      TLine3DObservationLayer.WriteNewRoot, Project, aneHandle);
    RenameLayers('Observation Sheets Vertical',
      TVerticalSheet3DObservationLayer.WriteNewRoot, Project, aneHandle);
    RenameLayers('Observation Sheets Slanted',
      TSlantedSheet3DObservationLayer.WriteNewRoot, Project, aneHandle);
    RenameLayers('Observation Solids',
      TVol3DObservationLayer.WriteNewRoot, Project, aneHandle);
  finally
    Project.Free;
  end;

end;

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
      OldParameterName := 'ANGLEX';
      ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
      if ParameterIndex >= 0 then
      begin
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          NewParameterName := TANGLE1Param.WriteParamName;
          Parameter.Rename(aneHandle,NewParameterName);
          frmWarnings.memoWarnings.Lines.Add(NewLayerName + '.' +
            OldParameterName + '" renamed "' + NewLayerName + '.' +
            NewParameterName + '".');
        finally
          Parameter.Free;
        end;
      end;


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

      OldParameterName := 'INOB';
      ParameterIndex := MeshLayer.GetParameterIndex(aneHandle, OldParameterName);
      if ParameterIndex >= 0 then
      begin
        Parameter := TParameterOptions.Create(MeshHandle, ParameterIndex);
        try
          Parameter.Expr[aneHandle] := TINOBParam.UsualValue;
          frmWarnings.memoWarnings.Lines.Add('"' + NewLayerName + '.' +
            OldParameterName + '" expression has been changed.');
        finally
          Parameter.Free;
        end;
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

      NewLayerName :=  T2DFluidSourcesLayer.WriteNewRoot;
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
        NewLayerName :=  T2DSoluteEnergySourcesLayer.WriteNewRoot;
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

      NewLayerName :=  T2DSpecifiedPressureLayer.WriteNewRoot;
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
        NewLayerName :=  T2DSpecConcTempLayer.WriteNewRoot;
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

      OldLayerName :=  'Observation';
      LayerHandle := Project.GetLayerByName(aneHandle, OldLayerName);
      if LayerHandle <> nil then
      begin
        Layer := TLayerOptions.Create(LayerHandle);
        try
          NewLayerName :=  T2DObservationLayer.WriteNewRoot;
          Layer.Rename(aneHandle,NewLayerName);
          frmWarnings.memoWarnings.Lines.Add('"' + OldLayerName +
            '" renamed "' + NewLayerName  + '".');
        finally
          Layer.Free(aneHandle);
        end;
      end;


    finally
      Project.Free;
    end;
  end;

end;

end.
