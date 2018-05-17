unit SLLayerStructure;

interface

uses ANE_LayerUnit, AnePIE, SysUtils;

type
  TSutraLayerStructure = class(TLayerStructure)
  public
    procedure UpdateExpressions;
    procedure UpdateOldLayersAndParameters;
    constructor Create;
  end;

implementation

uses ANECB, GlobalVariables, SLGroupLayers, SLSutraMesh, SLFishnetMeshLayout,
  SLDomainDensity, SLObservation, SLThickness, SLPorosity, SLPermeability,
  SLDispersivity, SLUnsaturated, SLSourcesOfFluid, SLEnergySoluteSources,
  SLSpecifiedPressure, SLSpecConcOrTemp, SLInitialPressure, SLInitConcOrTemp,
  SLMap, SLDataLayer, frmSutraUnit, OptionsUnit, SLGeoUnit, UtilityFunctions,
  SLSutraMeshGeoUnit, SLSpecificHeat, SLThermalConductivity;

function RenameLayer(OldName, NewName: string): boolean; overload;
var
  layerHandle: ANE_PTR;
begin
  result := False;
  LayerHandle := GetLayerHandle(frmSutra.CurrentModelHandle, OldName);
  if layerHandle <> nil then
  begin
    result := ULayerRename(frmSutra.CurrentModelHandle, layerHandle,
      NewName);
    if result then
    begin
      frmWarnings.memoWarnings.Lines.Add('The layer "' + OldName
        + '" has been renamed "' + NewName + '".');
    end;
  end;
end;

function RenameLayer(ALayerClass: T_ANE_LayerClass): boolean; overload;
var
  OldName, NewName: string;
begin
  result := False;
  OldName := ALayerClass.WriteNewRoot;
  frmSutra.OldModel := True;
  try
    NewName := ALayerClass.WriteNewRoot;
    if OldName <> NewName then
    begin
      result := RenameLayer(OldName, NewName);
    end;
  finally
    frmSutra.OldModel := False;
  end;
end;

function RenameParameter(layerHandle: ANE_PTR; OldName, NewName: string;
  LayerName: string)
  : boolean; overload;
var
  parameterIndex: ANE_INT32;
begin
  result := False;
  parameterIndex := UGetParameterIndex(frmSutra.CurrentModelHandle,
    layerHandle, OldName);

  if parameterIndex > -1 then
  begin
    result := URenameParameter(frmSutra.CurrentModelHandle,
      layerHandle, parameterIndex, NewName);

    if result then
    begin
      frmWarnings.memoWarnings.Lines.Add('On The layer "' + LayerName
        + '", the parameter + "' + OldName
        + '" has been renamed "' + NewName + '".');
    end;
  end;

end;

function RenameParameter(layerHandle: ANE_PTR;
  AParamClass: T_ANE_ParamClass; LayerName: string): boolean; overload;
var
  OldName, NewName: string;
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
var
  Index: integer;
  UnitCount: integer;
begin
  inherited;
  RenameAllLayers := True;

  UnIndexedLayers0.LayerOrder.Add(TSutraModelGroupLayer.ANE_LayerName);

  UnIndexedLayers0.LayerOrder.Add(TSutraMeshLayer.ANE_LayerName);
  UnIndexedLayers0.LayerOrder.Add(TFishnetMeshLayout.ANE_LayerName);

  UnIndexedLayers3.LayerOrder.Add(T3DObjectsGroupLayer.ANE_LayerName);

  IntermediateUnIndexedLayers.LayerOrder.Add(TSutraTopGroupLayer.ANE_LayerName);
  IntermediateUnIndexedLayers.LayerOrder.Add(TTopElevLayer.ANE_LayerName);
  IntermediateUnIndexedLayers.LayerOrder.Add(TTopFluidSourcesLayer.ANE_LayerName);
  IntermediateUnIndexedLayers.LayerOrder.Add(TTopSoluteEnergySourcesLayer.ANE_LayerName);
  IntermediateUnIndexedLayers.LayerOrder.Add(TTopSpecifiedPressureLayer.ANE_LayerName);
  IntermediateUnIndexedLayers.LayerOrder.Add(TTopSpecConcTempLayer.ANE_LayerName);
  IntermediateUnIndexedLayers.LayerOrder.Add(TTopObservationLayer.ANE_LayerName);


  UnIndexedLayers.LayerOrder.Add(TSutraDomainOutline.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraMeshDensity.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2DObservationLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(T2dUcodeHeadObservationLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2dUcodeConcentrationObservationLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2dUcodeFluxObservationLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2dUcodeSoluteFluxObservationLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2dUcodeSaturationObservationLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TSutraHydrogeologyGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TThicknessLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TPorosityLayer.ANE_LayerName);
  {$IFDEF SutraIce}
  UnIndexedLayers.LayerOrder.Add(TSpecificHeatLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TThermalConductivityLayer.ANE_LayerName);
  {$ENDIF}
  UnIndexedLayers.LayerOrder.Add(TPermeabilityLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TDispersivityLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TUnsaturatedLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraHydroSourcesGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2DFluidSourcesLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2DSoluteEnergySourcesLayer.ANE_LayerName);

  UnIndexedLayers.LayerOrder.Add(TSutraHydroBoundariesGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2DSpecifiedPressureLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(T2DSpecConcTempLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TSutraInitialConditionsGroupLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TInitialPressureLayer.ANE_LayerName);
//  UnIndexedLayers.LayerOrder.Add(TInitialPressureOverrideLayer.ANE_LayerName);
  UnIndexedLayers.LayerOrder.Add(TInitialConcTempLayer.ANE_LayerName);

  with frmSutra do
  begin
    TSutraMapPointGroupLayer.Create(PostProcessingLayers, -1);
    TSutraMapLayer.Create(PostProcessingLayers, -1);
    TSutraDataLayer.Create(PostProcessingLayers, -1);
    TSutraModelGroupLayer.Create(UnIndexedLayers0, -1);
    TSutraDomainOutline.Create(UnIndexedLayers, -1);
    TSutraMeshDensity.Create(UnIndexedLayers, -1);
    if not Is3D then
    begin
      TSutraMeshLayer.Create(UnIndexedLayers0, -1);
      if rbGeneral.Checked or rbFishnet.Checked then
      begin
        TFishnetMeshLayout.Create(UnIndexedLayers0, -1);
      end;

      T2DObservationLayer.Create(UnIndexedLayers, -1);

      if frmSutra.cbInverse.Checked or
        frmSutra.cbPreserveInverseModelParameters.Checked then
      begin
        T2dUcodeHeadObservationLayer.Create(UnIndexedLayers, -1);
        T2dUcodeConcentrationObservationLayer.Create(UnIndexedLayers, -1);
        T2dUcodeFluxObservationLayer.Create(UnIndexedLayers, -1);
        T2dUcodeSoluteFluxObservationLayer.Create(UnIndexedLayers, -1);
        if frmSutra.rbSatUnsat.Checked then
        begin
          T2dUcodeSaturationObservationLayer.Create(UnIndexedLayers, -1);
        end;
      end;

      TSutraHydrogeologyGroupLayer.Create(UnIndexedLayers, -1);

      if rbGeneral.Checked or rbUserSpecifiedThickness.Checked then
      begin
        TThicknessLayer.Create(UnIndexedLayers, -1);
      end;
      TPorosityLayer.Create(UnIndexedLayers, -1);
      {$IFDEF SutraIce}
      if (rbFreezing.Checked or rbEnergy.Checked) then
      begin
        TSpecificHeatLayer.Create(UnIndexedLayers, -1);
      end;
      if (rbFreezing.Checked or rbEnergy.Checked) then
      begin
        TThermalConductivityLayer.Create(UnIndexedLayers, -1);
      end;
      {$ENDIF}

      TPermeabilityLayer.Create(UnIndexedLayers, -1);

      TDispersivityLayer.Create(UnIndexedLayers, -1);
      if rbGeneral.Checked or
        (rbCrossSection.Checked and
        (rbSatUnsat.Checked or rbFreezing.Checked)) then
      begin
        TUnsaturatedLayer.Create(UnIndexedLayers, -1);
      end;
      TSutraHydroSourcesGroupLayer.Create(UnIndexedLayers, -1);
      T2DFluidSourcesLayer.Create(UnIndexedLayers, -1);
      T2DSoluteEnergySourcesLayer.Create(UnIndexedLayers, -1);

      TSutraHydroBoundariesGroupLayer.Create(UnIndexedLayers, -1);
      T2DSpecifiedPressureLayer.Create(UnIndexedLayers, -1);
      T2DSpecConcTempLayer.Create(UnIndexedLayers, -1);
      TSutraInitialConditionsGroupLayer.Create(UnIndexedLayers, -1);
      TInitialPressureLayer.Create(UnIndexedLayers, -1);

      TInitialConcTempLayer.Create(UnIndexedLayers, -1);
    end
    else
    begin
      TSutraTopGroupLayer.Create(IntermediateUnIndexedLayers, -1);
      TTopElevLayer.Create(IntermediateUnIndexedLayers, -1);
      T3DObjectsGroupLayer.Create(UnIndexedLayers3, -1);

      UnitCount := StrToInt(adeVertDisc.Text);
      for Index := 0 to UnitCount-1 do
      begin
        TSutraGeoUnit.Create(ListsOfIndexedLayers, Index);
      end;
      for Index := 0 to UnitCount do
      begin
        TSutraMeshGeoUnit.Create(ZerothListsOfIndexedLayers, Index);
      end;

    end;
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiFluidSource)]
      := T_TypedIndexedLayerList.Create(TVolFluidSourcesLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiPoints), Ord(btiFluidSource)]
      := T_TypedIndexedLayerList.Create(TPoint3DFluidSourceLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiLines), Ord(btiFluidSource)]
      := T_TypedIndexedLayerList.Create(TLine3DFluidSourceLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiVerticalSheets),
      Ord(btiFluidSource)]
      := T_TypedIndexedLayerList.Create(TVerticalSheet3DFluidSourceLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSlantedSheets),
      Ord(btiFluidSource)]
      := T_TypedIndexedLayerList.Create(TSlantedSheet3DFluidSourceLayer,
      FirstListsOfIndexedLayers, -1);

    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiSoluteSource)]
      := T_TypedIndexedLayerList.Create(TVolSoluteEnergySourcesLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiPoints), Ord(btiSoluteSource)]
      := T_TypedIndexedLayerList.Create(TPoint3DSoluteEnergySourcesLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiLines), Ord(btiSoluteSource)]
      := T_TypedIndexedLayerList.Create(TLine3DSoluteEnergySourcesLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiVerticalSheets),
      Ord(btiSoluteSource)]
      := T_TypedIndexedLayerList.Create(
      TVerticalSheet3DSoluteEnergySourcesLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSlantedSheets),
      Ord(btiSoluteSource)]
      := T_TypedIndexedLayerList.Create(TSlantedSheet3DSoluteEnergySourcesLayer,
      FirstListsOfIndexedLayers, -1);

    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiSpecPressure)]
      := T_TypedIndexedLayerList.Create(TVolSpecifiedPressureLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiPoints), Ord(btiSpecPressure)]
      := T_TypedIndexedLayerList.Create(TPoint3DSpecifiedPressureLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiLines), Ord(btiSpecPressure)]
      := T_TypedIndexedLayerList.Create(TLine3DSpecifiedPressureLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiVerticalSheets),
      Ord(btiSpecPressure)]
      := T_TypedIndexedLayerList.Create(TVerticalSheet3DSpecifiedPressureLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSlantedSheets),
      Ord(btiSpecPressure)]
      := T_TypedIndexedLayerList.Create(TSlantedSheet3DSpecifiedPressureLayer,
      FirstListsOfIndexedLayers, -1);

    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiSpecConc)]
      := T_TypedIndexedLayerList.Create(TVolSpecConcTempLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiPoints), Ord(btiSpecConc)]
      := T_TypedIndexedLayerList.Create(TPoint3DSpecConcTempLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiLines), Ord(btiSpecConc)]
      := T_TypedIndexedLayerList.Create(TLine3DSpecConcTempLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiVerticalSheets),
      Ord(btiSpecConc)]
      := T_TypedIndexedLayerList.Create(TVerticalSheet3DSpecConcTempLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSlantedSheets), Ord(btiSpecConc)]
      := T_TypedIndexedLayerList.Create(TSlantedSheet3DSpecConcTempLayer,
      FirstListsOfIndexedLayers, -1);

    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSolids), Ord(btiObservations)]
      := T_TypedIndexedLayerList.Create(TVol3DObservationLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiPoints), Ord(btiObservations)]
      := T_TypedIndexedLayerList.Create(TPoint3DObservationLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiLines), Ord(btiObservations)]
      := T_TypedIndexedLayerList.Create(TLine3DObservationLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiVerticalSheets),
      Ord(btiObservations)]
      := T_TypedIndexedLayerList.Create(TVerticalSheet3DObservationLayer,
      FirstListsOfIndexedLayers, -1);
    frmSutra.dgBoundaryCountsNew.Objects[Ord(otiSlantedSheets),
      Ord(btiObservations)]
      := T_TypedIndexedLayerList.Create(TSlantedSheet3DObservationLayer,
      FirstListsOfIndexedLayers, -1);

    if frmSutra.SetAllBoundaryCounts then
    begin
      T3DObjectsGroupLayer.Create(UnIndexedLayers3, -1);
    end;

  end;
end;

procedure TSutraLayerStructure.UpdateExpressions;
var
  AMapLayer: T_ANE_MapsLayer;
  AParamLayer: T_ANE_Layer;
  AParam: T_ANE_Param;
  LayerIndex, ParamIndex: integer;
begin
  for LayerIndex := 0 to UnIndexedLayers.Count - 1 do
  begin
    AMapLayer := UnIndexedLayers.Items[LayerIndex];
    if AMapLayer.Status <> sDeleted then
    begin
      if AMapLayer is T_ANE_Layer then
      begin
        AParamLayer := T_ANE_Layer(AMapLayer);
        for ParamIndex := 0 to AParamLayer.ParamList.Count - 1 do
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
var
  AMapLayer: T_ANE_MapsLayer;
  AParamLayer: T_ANE_Layer;
  AParam: T_ANE_Param;
  LayerIndex, ParamIndex: integer;
  OldLayerName, NewLayerName: string;
  OldParamName, NewParamName: string;
  layerHandle: ANE_PTR;
begin
  for LayerIndex := 0 to UnIndexedLayers.Count - 1 do
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
          RenameLayer(OldLayerName, NewLayerName);

          frmWarnings.memoWarnings.Lines.Add(OldLayerName
            + ' renamed ' + NewLayerName + '.');
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
          for ParamIndex := 0 to AParamLayer.ParamList.Count - 1 do
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
                  frmWarnings.memoWarnings.Lines.Add(AParamLayer.WriteNewRoot +
                    '.' + OldParamName + ' renamed ' + AParamLayer.WriteNewRoot
                    + '.' + NewParamName + '.');
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

