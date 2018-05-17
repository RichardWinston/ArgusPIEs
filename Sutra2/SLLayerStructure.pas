unit SLLayerStructure;

interface

uses ANE_LayerUnit, AnePIE;

type
  TSutraLayerStructure = class(TLayerStructure)
    public
    procedure UpdateExpressions;
    procedure UpdateOldLayersAndParameters;
    Constructor Create;
    procedure OK(const CurrentModelHandle : ANE_PTR); override;
    procedure SetFishNetMeshAllowIntersection
      (const CurrentModelHandle: ANE_PTR);
  end;

implementation

uses ANECB, GlobalVariables, SLGroupLayers, SLSutraMesh, SLFishnetMeshLayout, SLDomainDensity,
  SLObservation, SLThickness, SLPorosity, SLPermeability, SLDispersivity,
  SLUnsaturated, SLSourcesOfFluid, SLEnergySoluteSources, SLSpecifiedPressure,
  SLSpecConcOrTemp, SLInitialPressure, SLInitConcOrTemp, SLMap, SLDataLayer,
  frmSutraUnit, OptionsUnit;

function RenameLayer(OldName, NewName : string) : boolean; overload;
var
  layerHandle : ANE_PTR;
begin
  result := False;
  layerHandle := ANE_LayerGetHandleByName(frmSutra.CurrentModelHandle,
       PChar(OldName));
  if layerHandle <> nil then
  begin
    result := ANE_LayerRename(frmSutra.CurrentModelHandle , layerHandle,
         PChar(NewName) );
    if result then
    begin
      frmWarnings.memoWarnings.Lines.Add('The layer "' + OldName
        + '" has been renamed "' + NewName +'".');
    end;
  end;
end;

function RenameLayer(ALayerClass : T_ANE_LayerClass) : boolean; overload;
var
  OldName, NewName : string;
begin
  result := False;
  OldName := ALayerClass.WriteNewRoot;
  frmSutra.OldModel := True;
  try
    NewName := ALayerClass.WriteNewRoot;
      if OldName <> NewName then
      begin
        result := RenameLayer( OldName, NewName );
      end;
  finally
    frmSutra.OldModel := False;
  end;
end;


function RenameParameter(layerHandle : ANE_PTR; OldName, NewName : string;
  LayerName : string)
  : boolean; overload;
var
  parameterIndex : ANE_INT32;
begin
  result := False;
  parameterIndex := ANE_LayerGetParameterByName(frmSutra.CurrentModelHandle,
       layerHandle, PChar(OldName));

  if parameterIndex > -1 then
  begin
    result := ANE_LayerRenameParameter(frmSutra.CurrentModelHandle,
       layerHandle, parameterIndex, PChar(NewName));

    if result then
    begin
      frmWarnings.memoWarnings.Lines.Add('On The layer "' + LayerName
        + '", the parameter + "' + OldName
        + '" has been renamed "' + NewName +'".');
    end;
  end;

end;

function RenameParameter(layerHandle : ANE_PTR;
  AParamClass : T_ANE_ParamClass; LayerName : string) : boolean ; overload;
var
  OldName, NewName : string;
begin
  result := False;
  OldName := AParamClass.WriteParamName;
  frmSutra.OldModel := True;
  try
    NewName := AParamClass.WriteParamName;
      if OldName <> NewName then
      begin
          result := RenameParameter(layerHandle, OldName, NewName, LayerName);
      end;
  finally
    frmSutra.OldModel := False;
  end;
end;



{ TSutraLayerStructure }

constructor TSutraLayerStructure.Create;
begin
  inherited;
  RenameAllLayers := True;
  
  UnIndexedLayers.LayerOrder.Add(TSutraModelGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraMeshLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TFishnetMeshLayout.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraDomainOutline.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraMeshDensity.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TObservationLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraHydrogeologyGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TThicknessLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TPorosityLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TPermeabilityLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TDispersivityLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TUnsaturatedLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraHydroSourcesGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TFluidSourcesLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSoluteEnergySourcesLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TSutraHydroBoundariesGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSpecifiedPressureLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSpecConcTempLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraInitialConditionsGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TInitialPressureLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TInitialConcTempLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraMapPointGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraMapLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraDataLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraD3DataLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TSutraD4DataLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraPostMapLayer.ANE_LayerName);


  with frmSutra do
  begin
    TSutraModelGroupLayer.Create(UnIndexedLayers, -1);
    TSutraMeshLayer.Create(UnIndexedLayers, -1);
    if rbGeneral.Checked or (rbSpecific.Checked and (rgMeshType.ItemIndex = 0)) then
    begin
      TFishnetMeshLayout.Create(UnIndexedLayers, -1);
    end;
    TSutraDomainOutline.Create(UnIndexedLayers, -1);
    TSutraMeshDensity.Create(UnIndexedLayers, -1);

    TObservationLayer.Create(UnIndexedLayers, -1);
    TSutraHydrogeologyGroupLayer.Create(UnIndexedLayers, -1);

    if rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked) then
    begin
      TThicknessLayer.Create(UnIndexedLayers, -1);
    end;
    TPorosityLayer.Create(UnIndexedLayers, -1);
    TPermeabilityLayer.Create(UnIndexedLayers, -1);

    TDispersivityLayer.Create(UnIndexedLayers, -1);
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbCrossSection.Checked and rbSatUnsat.Checked)
      then
    begin
      TUnsaturatedLayer.Create(UnIndexedLayers, -1);
    end;
    TSutraHydroSourcesGroupLayer.Create(UnIndexedLayers, -1);
    TFluidSourcesLayer.Create(UnIndexedLayers, -1);
    TSoluteEnergySourcesLayer.Create(UnIndexedLayers, -1);

    TSutraHydroBoundariesGroupLayer.Create(UnIndexedLayers, -1);
    TSpecifiedPressureLayer.Create(UnIndexedLayers, -1);
    TSpecConcTempLayer.Create(UnIndexedLayers, -1);
    TSutraInitialConditionsGroupLayer.Create(UnIndexedLayers, -1);
    TInitialPressureLayer.Create(UnIndexedLayers, -1);

    TInitialConcTempLayer.Create(UnIndexedLayers, -1);
    TSutraMapPointGroupLayer.Create(UnIndexedLayers, -1);
    TSutraMapLayer.Create(UnIndexedLayers, -1);
    TSutraDataLayer.Create(UnIndexedLayers, -1);
  end;
end;


procedure TSutraLayerStructure.OK(const CurrentModelHandle: ANE_PTR);
begin
  inherited;
  SetFishNetMeshAllowIntersection(CurrentModelHandle);
end;

procedure TSutraLayerStructure.SetFishNetMeshAllowIntersection
  (const CurrentModelHandle: ANE_PTR);
var
  ALayerOptions : TLayerOptions;
  ProjectOptions : TProjectOptions;
  FishnetMeshLayerHandle : ANE_PTR;
begin
  if frmSutra.rgMeshType.ItemIndex = 0 then
  begin
    ProjectOptions := TProjectOptions.Create(CurrentModelHandle);
    try
      FishnetMeshLayerHandle := ProjectOptions.GetLayerByName
        (TFishnetMeshLayout.ANE_LayerName);
      if FishnetMeshLayerHandle <> nil then
      begin
        ALayerOptions := TLayerOptions.Create(CurrentModelHandle,FishnetMeshLayerHandle);
        try
          ALayerOptions.AllowIntersection := True;
        finally
          ALayerOptions.Free;
        end;
      end;
    finally
      ProjectOptions.Free;
    end;
  end;
end;

procedure TSutraLayerStructure.UpdateExpressions;
Var
  AMapLayer : T_ANE_MapsLayer;
  AParamLayer : T_ANE_Layer;
  AParam : T_ANE_Param;
  LayerIndex, ParamIndex : integer;
begin
  for LayerIndex := 0 to UnIndexedLayers.Count -1 do
  begin
    AMapLayer := UnIndexedLayers.Items[LayerIndex];
    if AMapLayer.Status <> sDeleted then
    begin
      if AMapLayer is T_ANE_Layer then
      begin
        AParamLayer := T_ANE_Layer(AMapLayer);
        for ParamIndex := 0 to AParamLayer.ParamList.Count -1 do
        begin
          AParam := AParamLayer.ParamList.Items[ParamIndex];
          if AParam.Status <> sDeleted then
          begin
            AParam.SetExpressionNow := True;
          end;
        end;

      end;
    end;
  end;

end;

procedure TSutraLayerStructure.UpdateOldLayersAndParameters;
Var
  AMapLayer : T_ANE_MapsLayer;
  AParamLayer : T_ANE_Layer;
  AParam : T_ANE_Param;
  LayerIndex, ParamIndex : integer;
  OldLayerName, NewLayerName : string;
  OldParamName, NewParamName : string;
  layerHandle : ANE_PTR;
begin
  for LayerIndex := 0 to UnIndexedLayers.Count -1 do
  begin
    AMapLayer := UnIndexedLayers.Items[LayerIndex];
    if AMapLayer.Status <> sDeleted then
    begin
      frmSutra.OldModel := True;
      try
        OldLayerName := AMapLayer.WriteNewRoot;
        frmSutra.OldModel := False;
        NewLayerName := AMapLayer.WriteNewRoot;
          if OldLayerName <> NewLayerName then
          begin
            RenameLayer( OldLayerName, NewLayerName );
          end;
      finally
        frmSutra.OldModel := False;
      end;
      if AMapLayer is T_ANE_Layer then
      begin
        AParamLayer := T_ANE_Layer(AMapLayer);
        layerHandle := AParamLayer.GetLayerHandle(frmSutra.CurrentModelHandle);
        if layerHandle <> nil then
        begin
          for ParamIndex := 0 to AParamLayer.ParamList.Count -1 do
          begin
            AParam := AParamLayer.ParamList.Items[ParamIndex];
            if AParam.Status <> sDeleted then
            begin
              frmSutra.OldModel := True;
              try
                OldParamName := AParam.WriteParamName;
                frmSutra.OldModel := False;
                NewParamName := AParam.WriteParamName;
                  if OldParamName <> NewParamName then
                  begin
                    RenameParameter(layerHandle, OldParamName,
                      NewParamName, NewLayerName);
                  end;
              finally
                frmSutra.OldModel := False;
              end;
            end;
          end;
        end;

      end;
    end;
  end;

end;

end.
