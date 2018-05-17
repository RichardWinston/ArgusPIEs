unit SourcesOfSoluteFunctions;

interface

uses SysUtils, Dialogs, Contnrs, AnePIE, ANECB;

procedure InitializeSourcesOfEnergySolute (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSourcesOfEnergySolute (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeEnergySoluteSources(funHandle : ANE_PTR );

implementation

uses Classes, OptionsUnit, VirtualMeshFunctions, VirtMeshUtilFunctions,
  VirtualMeshUnit, SLEnergySoluteSources, frmSutraUnit,
  SLGeneralParameters, doublePolyhedronUnit, ANE_LayerUnit, ArgusFormUnit,
  ParamArrayUnit, OverriddenArrayUnit, SLSutraMesh, UtilityFunctions,
  ZFunction;


procedure InitializeArgusSources(funHandle : ANE_PTR; AddValues : boolean);
var
  LayerIndex : Integer;
  AMesh : TReal2DMesh;
  NodeIndex : integer;
  ARealNode : TRealNode;
  VirtualLayerIndex : integer;
  AVirtualNode : TVirtualNode;
  VirtualNodeIndex : integer;
  IsBoundary : boolean;
  QuinParamIndex, IsSourceIndex : SmallInt;
  LayerOptions : TLayerOptions;
  LayerHandle : ANE_PTR;
  ProjectOptions : TProjectOptions;
  Value1 : double;
  LayerName, parameterName : string;
  Comment : string;
  LayerUsed : boolean;
  VerticallyAligned : boolean;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    VirtualLayerIndex := 0;
    VerticallyAligned := frmSutra.rb3D_va.Checked;
    for LayerIndex := 0 to StrToInt(frmSutra.adeVertDisc.text) do
    begin
      if LayerIndex = 0 then
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSourcesOfSolute,0,True);
      end
      else
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSourcesOfSolute,
          LayerIndex-1,False);
      end;

      if LayerIndex > 0 then
      begin
        VirtualLayerIndex := VirtualLayerIndex
          + frmSutra.VirtualMesh.Discretization[LayerIndex-1]
      end;
      if LayerUsed then
      begin
        AMesh := frmSutra.VirtualMesh.Real2DMeshes[LayerIndex];

        LayerName := TSutraMeshLayer.WriteNewRoot;
        if not VerticallyAligned then
        begin
          if LayerIndex = 0 then
          begin
            LayerName := LayerName + KTop;
          end
          else
          begin
            LayerName := LayerName + KBottom + IntToStr(LayerIndex);
          end;
        end;

        LayerHandle := ProjectOptions.GetLayerByName
          (funHandle,LayerName);

        LayerOptions := TLayerOptions.Create(LayerHandle);
        try
          parameterName := TQUINParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;

          QuinParamIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(QuinParamIndex<>-1);

          parameterName := TIsQUINSource.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;
          IsSourceIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(IsSourceIndex<>-1);
        finally
          LayerOptions.Free(funHandle);
        end;

        for NodeIndex := 0 to AMesh.NodeCount -1 do
        begin
          if LayerIndex = 0 then
          begin
            Comment := Format('Top of Unit: 1 Node: %d', [NodeIndex+1]);
          end
          else
          begin
            Comment := Format('Bottom of Unit: %d. Node: %d', [LayerIndex,
              NodeIndex+1]);
          end;
          ARealNode := AMesh.Nodes[NodeIndex];
          IsBoundary := ARealNode.BooleanParameterValue(funHandle,
            IsSourceIndex);
          if IsBoundary then
          begin
            VirtualNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex
              (VirtualLayerIndex,NodeIndex);
            AVirtualNode := frmSutra.VirtualMesh.VirtualNodes[VirtualNodeIndex];
            CurrentVertex := AVirtualNode;
            Value1 := ARealNode.RealParameterValue(funHandle, QuinParamIndex);

            if ((Value1 > 0) and (AVirtualNode.Value1 < 0)) or
               ((Value1 < 0) and (AVirtualNode.Value1 > 0))
            then
            begin
              raise EInvalidSource.Create
                ('Error: Two or more sources of '
                 + 'opposite sign at Node '
                 + IntToStr(NodeIndex +1));
            end
            else
            begin
              if AddValues then
              begin
                AVirtualNode.Value1 := AVirtualNode.Value1 + Value1;
                AVirtualNode.Comment := AVirtualNode.Comment + ' ' + Comment;
              end
              else
              begin
                AVirtualNode.Value1 := Value1;
                AVirtualNode.Comment := Comment;
              end;

              AVirtualNode.Used := True;
            end;

          end;
        end;
      end;
    end;
  finally
    ProjectOptions.Free;
  end;
end;

procedure InitializeVerticalSheetSources(const funHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
  TotEnergySoluteSource, SpecificEnergySoluteSource, ConcTemp, TimeDep,
    FollowMeshParamIndex, TopElevParamIndex, EndTopParamIndex,
    BotElevParamIndex, EndBotParamIndex, SourceChoiceParamIndex, ContourType,
    CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  Area : extended;
  SourceChoice : SmallInt;
  AValue : extended;
  TotSourceExpr, SpecSourceExpr, SourceExpr, TransientExpr : string;
  SourceOverRide, TransientOverride : boolean;
  TotSourceOpt, SpecSourceOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiVerticalSheets),Ord(btiSoluteSource)]) do
  begin
    // get the layer
    LayerName := TVerticalSheet3DSoluteEnergySourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        TotEnergySoluteSource := ALayer.GetParameterIndex
          (funHandle, TTotalSoluteEnergySourceParam.WriteParamName);
        SpecificEnergySoluteSource := ALayer.GetParameterIndex
          (funHandle, TSpecificSoluteEnergySourceParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle, TTimeDependanceParam.WriteParamName);
        TopElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TBeginTopElevaParam.WriteParamName);
        EndTopParamIndex := ALayer.GetParameterIndex
          (funHandle, TEndTopElevaParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TBeginBottomElevaParam.WriteParamName);
        EndBotParamIndex := ALayer.GetParameterIndex
          (funHandle, TEndBottomElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSourceChoice.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle, TFollowMeshParam.WriteParamName);

        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        Assert((TotEnergySoluteSource >= 0) and
          (SpecificEnergySoluteSource >= 0) and
          (ConcTemp >= 0) and
          (TimeDep >= 0) and
          (FollowMeshParamIndex >= 0) and
          (TopElevParamIndex >= 0) and
          (EndTopParamIndex >= 0) and
          (BotElevParamIndex >= 0) and
          (EndBotParamIndex >= 0) and
          (SourceChoiceParamIndex >= 0) and
          (ContourType >= 0) and
          (CommentIndex >= 0));

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotEnergySoluteSource);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificEnergySoluteSource);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          begin
            TotSourceExpr :=  TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            TransientOpt.Free;
          end;
        end;

        for ContourIndex := 0 to
          ALayer.NumObjects(funHandle, pieContourObject) -1 do
        begin
          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
          Transient := AContour.GetBoolParameter(funHandle,TimeDep);
          TransientOverride := OverridenParameters.OverriddenEnSolSource
                  [ContourIndex1,espTransient];

          SourceChoice :=
            AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
          case SourceChoice of
            1: // total source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, TotEnergySoluteSource);
                SourceOverRide := OverridenParameters.OverriddenEnSolSource
                  [ContourIndex1,espTotalSource];
                SourceExpr := TotSourceExpr;
              end;
            2: // specific source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, SpecificEnergySoluteSource);
                SourceOverRide := OverridenParameters.OverriddenEnSolSource
                  [ContourIndex1,espSpecificSource];
                SourceExpr := SpecSourceExpr;
              end;
            else
              begin
                raise EInvalidSource.Create
                  ('Error: ' + LayerName + '.'
                   + TSourceChoice.ANE_ParamName
                   + ' parameter incorrectly assigned a value of '
                   + IntToStr(SourceChoice)
                   + '. Check that you have entered a value for '
                   + TCustomTotalSourceParam.ANE_ParamName
                   + ' or '
                   + TCustomSpecificSourceParam.ANE_ParamName
                   + '.');
                AValue := 0;
                SourceOverRide := False;
                SourceExpr := '';
              end;
          end;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try
            ThisContourType := AContour.GetIntegerParameter(funHandle,
              ContourType);
            case ThisContourType of
              2: // open contour
                begin
                  GetOpenContourPlanes(funHandle, AContour, TopElevParamIndex,
                    EndTopParamIndex, BotElevParamIndex, EndBotParamIndex,
                    SourceChoice, FollowMeshParamIndex, ListOfPlanes, Area);

                  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
                  begin
                    APlane := ListOfPlanes[PlaneIndex];
                    if SourceChoice = 1 then
                    begin
                      APlane.Value1 := AValue*APlane.PlaneArea/Area;
                    end
                    else
                    begin
                      APlane.Value1 := AValue;
                    end;

                  end;

                end;
            else
              begin
                raise EInvalidSource.Create('Error: Only open '
                  + 'contours are allowed on ' + LayerName);
              end;
            end;

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, SourceChoice,
              ALayer, SourceExpr, '', TransientExpr,
              SourceOverRide, True, TransientOverride,
              True, Comment,
              Transient, False);

          finally
            for PlaneIndex := 0 to ListOfPlanes.Count -1 do
            begin
              TValuePlane(ListOfPlanes[PlaneIndex]).Free;
            end;
            ListOfPlanes.Free;
            AContour.Free;
          end;

        end;
      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;
  end;

end;

procedure InitializeSlantedSheetSources(const funHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
  TotEnergySoluteSource, SpecificEnergySoluteSource, ConcTemp, TimeDep,
    SourceChoiceParamIndex, ContourType,
    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  Area : extended;
  SourceChoice : SmallInt;
  AValue : extended;
  TotSourceExpr, SpecSourceExpr, SourceExpr, TransientExpr : string;
  SourceOverRide, TransientOverRide : boolean;
  TotSourceOpt, SpecSourceOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSlantedSheets),Ord(btiSoluteSource)]) do
  begin
    // get the layer
    LayerName := TSlantedSheet3DSoluteEnergySourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        TotEnergySoluteSource := ALayer.GetParameterIndex
          (funHandle, TTotalSoluteEnergySourceParam.WriteParamName);
        SpecificEnergySoluteSource := ALayer.GetParameterIndex
          (funHandle, TSpecificSoluteEnergySourceParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle, TTimeDependanceParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSourceChoice.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);

        X1 := ALayer.GetParameterIndex(funHandle, TX1Param.WriteParamName);
        Y1 := ALayer.GetParameterIndex(funHandle, TY1Param.WriteParamName);
        Z1 := ALayer.GetParameterIndex(funHandle, TZ1Param.WriteParamName);
        X2 := ALayer.GetParameterIndex(funHandle, TX2Param.WriteParamName);
        Y2 := ALayer.GetParameterIndex(funHandle, TY2Param.WriteParamName);
        Z2 := ALayer.GetParameterIndex(funHandle, TZ2Param.WriteParamName);
        X3 := ALayer.GetParameterIndex(funHandle, TX3Param.WriteParamName);
        Y3 := ALayer.GetParameterIndex(funHandle, TY3Param.WriteParamName);
        Z3 := ALayer.GetParameterIndex(funHandle, TZ3Param.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        Assert((TotEnergySoluteSource >= 0) and
          (SpecificEnergySoluteSource >= 0) and
          (ConcTemp >= 0) and
          (TimeDep >= 0) and
          (SourceChoiceParamIndex >= 0) and
          (ContourType >= 0) and
          (X1 >= 0) and
          (Y1 >= 0) and
          (Z1 >= 0) and
          (X2 >= 0) and
          (Y2 >= 0) and
          (Z2 >= 0) and
          (X3 >= 0) and
          (Y3 >= 0) and
          (Z3 >= 0) and
          (CommentIndex >= 0));

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotEnergySoluteSource);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificEnergySoluteSource);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          begin
            TotSourceExpr :=  TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            TransientOpt.Free;
          end;
        end;

        for ContourIndex := 0 to
          ALayer.NumObjects(funHandle, pieContourObject) -1 do
        begin
          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
          Transient := AContour.GetBoolParameter(funHandle,TimeDep);

          TransientOverRide := OverridenParameters.OverriddenEnSolSource
                  [ContourIndex1,espTransient];
          SourceChoice :=
            AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
          case SourceChoice of
            1: // total source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, TotEnergySoluteSource);
                SourceOverRide := OverridenParameters.OverriddenEnSolSource
                  [ContourIndex1,espTotalSource];
                SourceExpr := TotSourceExpr;
              end;
            2: // specific source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, SpecificEnergySoluteSource);
                SourceOverRide := OverridenParameters.OverriddenEnSolSource
                  [ContourIndex1,espSpecificSource];
                SourceExpr := SpecSourceExpr;
              end;
            else
              begin
                raise EInvalidSource.Create
                  ('Error: ' + LayerName + '.'
                   + TSourceChoice.ANE_ParamName
                   + ' parameter incorrectly assigned a value of '
                   + IntToStr(SourceChoice)
                   + '. Check that you have entered a value for '
                   + TCustomTotalSourceParam.ANE_ParamName
                   + ' or '
                   + TCustomSpecificSourceParam.ANE_ParamName
                   + '.');
                AValue := 0;
                SourceOverRide := False;
                SourceExpr := '';
              end;
          end;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try
            ThisContourType := AContour.GetIntegerParameter(funHandle,
              ContourType);
            case ThisContourType of

              3: // closed contour
                begin
                  GetClosedContourPlanes(funHandle, AContour, ListOfPlanes,
                    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3);
                  Assert(ListOfPlanes.Count = 1);
                  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
                  begin
                    APlane := ListOfPlanes[PlaneIndex];
                    APlane.Value1 := AValue;
                    if SourceChoice = 1 then
                    begin
                      APlane.PlaneArea := APlane.Area;
                    end;
                  end;
                end;
            else
              begin
                raise EInvalidSource.Create('Error: Only '
                  + 'closed contours are allowed on ' + LayerName);
              end;
            end;

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, SourceChoice,
              ALayer, SourceExpr, '', TransientExpr,
              SourceOverRide, True, TransientOverRide,
              True, Comment, Transient, False);

          finally
            for PlaneIndex := 0 to ListOfPlanes.Count -1 do
            begin
              TValuePlane(ListOfPlanes[PlaneIndex]).Free;
            end;
            ListOfPlanes.Free;
            AContour.Free;
          end;

        end;
      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;
  end;

end;

procedure EvaluateNonSurfaceContours(var ContourIndex1 : ANE_INT32;
  const TotSoluteEnergySource, SpecificSoluteEnergySource, TimeDep,
  TopElev, BotElev, SourceChoiceParamIndex, ContourType,
  FollowMeshParamIndex, CommentIndex : SmallInt;
  const ALayer : TLayerOptions;
  const funHandle, LayerHandle : ANE_PTR;
  const TotSourceExpr, SpecSourceExpr, TransientExpr, LayerName : string;
    const AllowableObjectTypes: TAllowableObjectTypes);
var
  ContourList : TObjectList;
  ContourIndex : ANE_INT32;
  AContour : TContourObjectOptions;
  Comment : string;
  ListOfSegments : TList;
  SegmentIndex : integer;
  ThisContourType : integer;
  AValue : extended;
  SourceChoice : SmallInt;
  SourceOverridden, TransientOverRidden : boolean;
  SourceExpr : string;
  Transient : boolean;
  ErrorStart: string;
begin
  Assert((TotSoluteEnergySource >= 0) and
    (TimeDep >= 0) and
    (TopElev >= 0) and
    (BotElev >= 0) and
    (ContourType >= 0) and
    (CommentIndex >= 0));

  ContourList := TObjectList.Create;
  try

    for ContourIndex := 0 to
      ALayer.NumObjects(funHandle, pieContourObject) -1 do
    begin
      // get a contour
      AContour := TContourObjectOptions.Create
        (funHandle,LayerHandle,ContourIndex);

      ContourList.Add(AContour);
    end;

    ErrorStart := 'In ' + ALayer.Name[funHandle] + ', no cells intersect '
      + 'the contour located at ';

    // loop over the contours.
    for ContourIndex := 0 to ALayer.NumObjects(funHandle,pieContourObject) -1 do
    begin
      Inc(ContourIndex1);
      // get a contour
      AContour := ContourList[ContourIndex] as TContourObjectOptions;

      Comment := AContour.GetStringParameter(funHandle,CommentIndex);
      Transient := AContour.GetBoolParameter(funHandle,TimeDep);

      // get the segments in the contour.
      ListOfSegments := TList.Create;
      try

        ThisContourType :=  AContour.GetIntegerParameter(funHandle,ContourType);

        if not (ThisContourType in AllowableObjectTypes) then
        begin
          raise EInvalidSource.Create
            ('Error: A invalid contour type was used on ' + LayerName + '.');
        end;

        GetCountourLocations(funHandle, ThisContourType, TopElev, BotElev,
          ContourType, ListOfSegments, AContour, FollowMeshParamIndex);

        TransientOverRidden := OverridenParameters.OverriddenEnSolSource
                [ContourIndex1,espTransient];
        // Assign values to nodes
        if SourceChoiceParamIndex < 0 then
        begin
          SourceChoice := 1;
        end
        else
        begin
          SourceChoice :=
            AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
        end;

        case SourceChoice of
          1: // total source
            begin
              AValue := AContour.
                  GetFloatParameter(funHandle, TotSoluteEnergySource);
              SourceOverridden := OverridenParameters.OverriddenEnSolSource
                [ContourIndex1,espTotalSource];
              SourceExpr := TotSourceExpr;
            end;
          2: // specific source
            begin
              AValue := AContour.
                  GetFloatParameter(funHandle, SpecificSoluteEnergySource);
              SourceOverridden := OverridenParameters.OverriddenEnSolSource
                [ContourIndex1,espSpecificSource];
              SourceExpr := SpecSourceExpr;
            end;
          else
            begin
              raise EInvalidSource.Create
                ('Error: ' + LayerName + '.'
                 + TSourceChoice.ANE_ParamName
                 + ' parameter incorrectly assigned a value of '
                 + IntToStr(SourceChoice)
                 + '. Check that you have entered a value for '
                 + TCustomTotalSourceParam.ANE_ParamName
                 + ' or '
                 + TCustomSpecificSourceParam.ANE_ParamName
                 + '.');
              AValue := 0;
              SourceOverridden := False;
              SourceExpr := '';
            end;
        end;

        AssignNodeValues(funHandle, ThisContourType, ListOfSegments,
          SourceChoice, FollowMeshParamIndex, AValue, 0,
          {$IFDEF OldSutraIce} 0, {$ENDIF}
          LayerName, AContour, ALayer,
          SourceExpr, '', TransientExpr, {$IFDEF OldSutraIce} '', {$ENDIF}
          SourceOverridden, True, TransientOverRidden,
          {$IFDEF OldSutraIce} True, {$ENDIF}
          True, Comment, ContourList,
          Transient, False, ErrorStart);


      finally
        for SegmentIndex := 0 to ListOfSegments.Count -1 do
        begin
          TSegmentObject(ListOfSegments[SegmentIndex]).Free;
        end;

        ListOfSegments.Free;
      end;

    end;
  finally
    ContourList.Free;
  end;
end;


procedure InitializePointSources(const funHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  TotSoluteEnergySource, TimeDep, Elev,
  ContourType, CommentIndex : SmallInt;
  TotSourceExpr, TransientExpr: string;
  TotSourceOpt, TransientOpt: TParameterOptions;
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiPoints),Ord(btiSoluteSource)]) do
  begin
    // get the layer
    LayerName := TPoint3DSoluteEnergySourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        TotSoluteEnergySource := ALayer.GetParameterIndex
          (funHandle,TTotalSoluteEnergySourceParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        Elev := ALayer.GetParameterIndex
          (funHandle,TElevationParam.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotSoluteEnergySource);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          TotSourceExpr := TotSourceOpt.Expr[funHandle];
          TransientExpr := TransientOpt.Expr[funHandle];
        finally
          TotSourceOpt.Free;
          TransientOpt.Free;
        end;

        EvaluateNonSurfaceContours(ContourIndex1,
          TotSoluteEnergySource, -1, TimeDep,
          Elev, Elev, -1, ContourType,
          -1, CommentIndex, ALayer,
          funHandle, LayerHandle, TotSourceExpr,
          '', TransientExpr, LayerName, [1]);
      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeLineSources(const funHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  TotSoluteEnergySource, SpecificSoluteEnergySource, TimeDep, BeginElev,
    EndElev, SourceChoiceParamIndex, ContourType, FollowMeshParamIndex,
    CommentIndex : SmallInt;
  TotSourceExpr, SpecSourceExpr, TransientExpr: string;
  TotSourceOpt, SpecSourceOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiLines),Ord(btiSoluteSource)]) do
  begin
    // get the layer
    LayerName := TLine3DSoluteEnergySourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        TotSoluteEnergySource := ALayer.GetParameterIndex
          (funHandle,TTotalSoluteEnergySourceParam.WriteParamName);
        SpecificSoluteEnergySource := ALayer.GetParameterIndex
          (funHandle,TSpecificSoluteEnergySourceParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        BeginElev := ALayer.GetParameterIndex
          (funHandle,TBeginElevaParam.WriteParamName);
        EndElev := ALayer.GetParameterIndex
          (funHandle,TEndElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle,TSourceChoice.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotSoluteEnergySource);
        SpecSourceOpt:= TParameterOptions.Create(LayerHandle,
          SpecificSoluteEnergySource);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          TotSourceExpr := TotSourceOpt.Expr[funHandle];
          SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
          TransientExpr := TransientOpt.Expr[funHandle];
        finally
          TotSourceOpt.Free;
          SpecSourceOpt.Free;
          TransientOpt.Free;
        end;

        EvaluateNonSurfaceContours(ContourIndex1,
          TotSoluteEnergySource, SpecificSoluteEnergySource, TimeDep,
          BeginElev, EndElev, SourceChoiceParamIndex, ContourType,
          FollowMeshParamIndex, CommentIndex, ALayer,
          funHandle, LayerHandle, TotSourceExpr,
          SpecSourceExpr, TransientExpr, LayerName, [1,2]);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeSolidSources(const funHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  TotSoluteEnergySource, SpecificSoluteEnergySource, TimeDep, TopElev, BotElev,
    SourceChoiceParamIndex, ContourType, FollowMeshParamIndex,
    CommentIndex : SmallInt;
  TotSourceExpr, SpecSourceExpr, TransientExpr {, SourceExpr} : string;
  TotSourceOpt, SpecSourceOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSolids),Ord(btiSoluteSource)]) do
  begin
    // get the layer
    LayerName := TVolSoluteEnergySourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        TotSoluteEnergySource := ALayer.GetParameterIndex
          (funHandle,TTotalSoluteEnergySourceParam.WriteParamName);
        SpecificSoluteEnergySource := ALayer.GetParameterIndex
          (funHandle,TSpecificSoluteEnergySourceParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        TopElev := ALayer.GetParameterIndex
          (funHandle,TZeroTopElevParam.WriteParamName);
        BotElev := ALayer.GetParameterIndex
          (funHandle,TBottomElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle,TSourceChoice.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotSoluteEnergySource);
        SpecSourceOpt:= TParameterOptions.Create(LayerHandle,
          SpecificSoluteEnergySource);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          TotSourceExpr := TotSourceOpt.Expr[funHandle];
          SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
          TransientExpr := TransientOpt.Expr[funHandle];
        finally
          TotSourceOpt.Free;
          SpecSourceOpt.Free;
          TransientOpt.Free;
        end;

        EvaluateNonSurfaceContours(ContourIndex1,
          TotSoluteEnergySource, SpecificSoluteEnergySource, TimeDep,
          TopElev, BotElev, SourceChoiceParamIndex, ContourType,
          FollowMeshParamIndex, CommentIndex, ALayer,
          funHandle, LayerHandle, TotSourceExpr,
          SpecSourceExpr, TransientExpr, LayerName, [3]);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeEnergySoluteSources(funHandle : ANE_PTR );
Var
  ContourIndex1 : ANE_INT32;
begin
  // Initialize the values of the nodes to 0.
  frmSutra.VirtualMesh.InitializeNodeValues;

  ContourIndex1 := -1;
  InitializeSolidSources(funHandle,ContourIndex1);
  InitializePointSources(funHandle,ContourIndex1);
  InitializeLineSources(funHandle,ContourIndex1);
  InitializeVerticalSheetSources(funHandle,ContourIndex1);
  InitializeSlantedSheetSources(funHandle,ContourIndex1);

  InitializeArgusSources(funHandle, True);
end;

procedure InitializeSourcesOfEnergySolute (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    Result := True;
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          InitializeEnergySoluteSources(funHandle);
        end;
      Except on E: Exception do
        begin
          Result := false;
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GetSourcesOfEnergySolute (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  NodeIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
begin
  Result := 0;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          param := @parameters^;
          param1_ptr :=  param^[0];
          NodeIndex :=  param1_ptr^ - 1 ;
          NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

          result := frmSutra.VirtualMesh.VirtualNodes[NodeIndex].Value1
        end;
      Except on Exception do
        begin
          Result := 0;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_DOUBLE_PTR(reply)^ := result;
end;

end.
