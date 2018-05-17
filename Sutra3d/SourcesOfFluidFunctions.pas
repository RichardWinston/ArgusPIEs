unit SourcesOfFluidFunctions;

interface

uses SysUtils, Dialogs, Contnrs, AnePIE, ANECB;

procedure InitializeFluidSources(funHandle : ANE_PTR ) ;

procedure InitializeSourcesOfFluid (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSourcesOfFluid (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSourcesOfFluidConcentration (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                                
implementation

uses Classes, OptionsUnit, VirtualMeshFunctions, VirtMeshUtilFunctions,
  VirtualMeshUnit, SLSourcesOfFluid, frmSutraUnit,
  SLGeneralParameters, doublePolyhedronUnit, ANE_LayerUnit, ArgusFormUnit,
  ParamArrayUnit, OverriddenArrayUnit, SLSutraMesh, UtilityFunctions,
  ZFunction;

procedure InitializeVerticalSheetSources(const funHandle : ANE_PTR;
  Var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
  TotFluidSource, SpecificFluidSource, ConcTemp, TimeDep,
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
  ConcentrationOrTemp : double;
  TotSourceExpr, SpecSourceExpr, SourceExpr, ConcExpr, TransientExpr : string;
  SourceOverRide, ConcOverRide, TransientOverRide: boolean;
  TotSourceOpt, SpecSourceOpt, ConcTempOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiVerticalSheets),Ord(btiFluidSource)]) do
  begin
    // get the layer
    LayerName := TVerticalSheet3DFluidSourceLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        TotFluidSource := ALayer.GetParameterIndex
          (funHandle, TTotalFluidSourceParam.WriteParamName);
        SpecificFluidSource := ALayer.GetParameterIndex
          (funHandle, TSpecificFluidSourceParam.WriteParamName);
        ConcTemp := ALayer.GetParameterIndex
          (funHandle, TConcTempSourceParam.WriteParamName);
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

        Assert((TotFluidSource >= 0) and
          (SpecificFluidSource >= 0) and
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
          TotFluidSource);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificFluidSource);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTemp);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          begin
            TotSourceExpr :=  TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr  := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            ConcTempOpt.Free;
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

          SourceChoice :=
            AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
          case SourceChoice of
            1: // total source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, TotFluidSource);
                SourceOverRide := OverridenParameters.OverriddenFluidSource
                  [ContourIndex1,fspTotalSource];
                SourceExpr := TotSourceExpr;
              end;
            2: // specific source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, SpecificFluidSource);
                SourceOverRide := OverridenParameters.OverriddenFluidSource
                  [ContourIndex1,fspSpecificSource];
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
              end;
          end;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try

            ConcentrationOrTemp := AContour.GetFloatParameter(funHandle,
              ConcTemp);
            ConcOverRide := OverridenParameters.OverriddenFluidSource
              [ContourIndex1,fspConcentration];
            TransientOverRide := OverridenParameters.OverriddenFluidSource
              [ContourIndex1,fspTransient];

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

                    if APlane.Value2 = 0 then
                    begin
                      APlane.Value2 := ConcentrationOrTemp;
                    end
                    else if APlane.Value2 <> ConcentrationOrTemp then
                    begin
                    raise EInvalidSource.Create
                      ('Error: Two or more different concentrations or '
                       + 'temparatures assigned to one surface');
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
              ALayer, SourceExpr, ConcExpr, TransientExpr,
              SourceOverRide, ConcOverRide, TransientOverRide,
              True, Comment, Transient, (SourceChoice = 2));

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
  Var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
  TotFluidSource, SpecificFluidSource, ConcTemp, TimeDep,
    SourceChoiceParamIndex, ContourType,
    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  Area : extended;
  SourceChoice : SmallInt;
  AValue : extended;
  ConcentrationOrTemp : double;
  TotSourceExpr, SpecSourceExpr, SourceExpr, ConcExpr, TransientExpr : string;
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  TotSourceOpt, SpecSourceOpt, ConcTempOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
//  ContoursPresent : boolean;
begin
//  ContoursPresent := False;
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSlantedSheets),Ord(btiFluidSource)]) do
  begin
    // get the layer
    LayerName := TSlantedSheet3DFluidSourceLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        TotFluidSource := ALayer.GetParameterIndex
          (funHandle, TTotalFluidSourceParam.WriteParamName);
        SpecificFluidSource := ALayer.GetParameterIndex
          (funHandle, TSpecificFluidSourceParam.WriteParamName);
        ConcTemp := ALayer.GetParameterIndex
          (funHandle, TConcTempSourceParam.WriteParamName);
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

        Assert((TotFluidSource >= 0) and
          (SpecificFluidSource >= 0) and
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
          TotFluidSource);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificFluidSource);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTemp);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          begin
            TotSourceExpr :=  TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr  := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;


        for ContourIndex := 0 to
          ALayer.NumObjects(funHandle, pieContourObject) -1 do
        begin
//          ContoursPresent := True;
          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
          Transient := AContour.GetBoolParameter(funHandle,TimeDep);

          SourceChoice :=
            AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
          case SourceChoice of
            1: // total source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, TotFluidSource);
                SourceOverRide := OverridenParameters.OverriddenFluidSource
                  [ContourIndex1,fspTotalSource];
                SourceExpr := TotSourceExpr;
              end;
            2: // specific source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, SpecificFluidSource);
                SourceOverRide := OverridenParameters.OverriddenFluidSource
                  [ContourIndex1,fspSpecificSource];
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
              end;
          end;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try

            ConcentrationOrTemp := AContour.GetFloatParameter(funHandle,
              ConcTemp);
            ConcOverRide := OverridenParameters.OverriddenFluidSource
              [ContourIndex1,fspConcentration];
            TransientOverRide := OverridenParameters.OverriddenFluidSource
              [ContourIndex1,fspTransient];

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

                    if APlane.Value2 = 0 then
                    begin
                      APlane.Value2 := ConcentrationOrTemp;
                    end
                    else if APlane.Value2 <> ConcentrationOrTemp then
                    begin
                    raise EInvalidSource.Create
                      ('Error: Two or more different concentrations or '
                       + 'temparatures assigned to one surface');
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
              ALayer, SourceExpr, ConcExpr, TransientExpr,
              SourceOverRide, ConcOverRide, TransientOverRide,
              True, Comment, Transient, (SourceChoice = 2));

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
  QinParamIndex, UinParamIndex, IsSourceIndex, TransientIndex : SmallInt;
  LayerOptions : TLayerOptions;
  LayerHandle : ANE_PTR;
  ProjectOptions : TProjectOptions;
  Value1, Value2 : double;
  LayerName, parameterName : string;
  Comment : string;
  LayerUsed : boolean;
  VerticallyAligned : boolean;
  Expression: string;
//  CommentBase: string;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    VirtualLayerIndex := 0;
    VerticallyAligned := frmSutra.rb3D_va.Checked;
    for LayerIndex := 0 to StrToInt(frmSutra.adeVertDisc.text) do
    begin
      if LayerIndex = 0 then
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSourcesOfFluid,0,True);
      end
      else
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSourcesOfFluid,
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

          parameterName := TQINParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;
          QinParamIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(QinParamIndex<>-1);

          parameterName := TUINParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;

          UinParamIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(UinParamIndex<>-1);

          parameterName := TIsFluidSource.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;

          IsSourceIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(IsSourceIndex<>-1);

          parameterName := TTimeDepFluidSourceParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;

          TransientIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(TransientIndex<>-1);

  //        parameterName := TPBC_CommentParam.WriteParamName;
//          if VerticallyAligned then
//          begin
//            parameterName := parameterName + IntToStr(LayerIndex + 1);
//          end;
//          CommentIndex := LayerOptions.GetParameterIndex(funHandle,
//            parameterName);
//          Assert(CommentIndex<>-1);


          for NodeIndex := 0 to AMesh.NodeCount -1 do
          begin
            ARealNode := AMesh.Nodes[NodeIndex];
            IsBoundary := ARealNode.BooleanParameterValue(funHandle,
              IsSourceIndex);
            if IsBoundary then
            begin
//              if LayerIndex = 0 then
//              begin
//                CommentBase := Format(' Top of Unit: 1 Node: %d', [NodeIndex+1]);
//              end
//              else
//              begin
//                CommentBase := Format(' Bottom of Unit: %d. Node: %d',
//                  [LayerIndex,NodeIndex+1]);
//              end;



              if LayerIndex = 0 then
              begin
                Comment := Format('Top of Unit: 1 Node: %d; User Comment: ',
                  [NodeIndex+1]);
                Expression := TTopFluidSourcesLayer.WriteNewRoot
                  + '.' + TCommentParam.WriteParamName;
              end
              else
              begin
                Comment := Format('Bottom of Unit: %d. Node: %d; User Comment: ',
                  [LayerIndex,NodeIndex+1]);
                Expression := TBottomFluidSourcesLayer.WriteNewRoot + IntToStr(LayerIndex)
                  + '.' + TCommentParam.WriteParamName;
              end;

              Comment := Comment + LayerOptions.StringValueAtXY(funHandle,
                ARealNode.X, ARealNode.Y, Expression);

              VirtualNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex
                (VirtualLayerIndex,NodeIndex);
              AVirtualNode := frmSutra.VirtualMesh.VirtualNodes[VirtualNodeIndex];
              CurrentVertex := AVirtualNode;
              Value1 := ARealNode.RealParameterValue(funHandle, QinParamIndex);
              Value2 := ARealNode.RealParameterValue(funHandle, UinParamIndex);
              AVirtualNode.Transient := ARealNode.BooleanParameterValue(funHandle, TransientIndex);

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
                if not AVirtualNode.Used then
                begin
                  AVirtualNode.Value2 := Value2;
                  AVirtualNode.Used := True;
                end
                else if AVirtualNode.Value2 <> Value2 then
                begin
                raise EInvalidSource.Create
                  ('Error: Two or more different concentrations or '
                   + 'temparatures assigned to source at Node '
                   + IntToStr(NodeIndex +1));
                end;
              end;

            end;
          end;
        finally
          LayerOptions.Free(funHandle);
        end;
      end;
    end;
  finally
    ProjectOptions.Free;
  end;
end;


procedure EvaluateNonSurfaceSources(var ContourIndex1 : ANE_INT32;
  const   ALayer : TLayerOptions;
  const TotFluidSourceParamIndex, SpecificFluidSourceParamIndex,
    ConcTempParamIndex, TimeDepParamIndex, TopElevParamIndex, BotElevParamIndex,
    SourceChoiceParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  const funHandle, LayerHandle : ANE_PTR;
  const LayerName, TotSourceExpr, SpecSourceExpr, ConcExpr, TransientExpr : string;
    const AllowableObjectTypes: TAllowableObjectTypes);
var
  ContourList : TObjectList;
  ContourIndex : ANE_INT32;
  AContour : TContourObjectOptions;
  Comment : string;
  ThisContourType : integer;
  ListOfSegments : TList;
  SourceChoice : SmallInt;
  AValue : extended;
  SourceOverridden, ConcOverridden, TransientOverridden : boolean;
  SourceExpr : string;
  ConcentrationOrTemp : double;
  SegmentIndex : integer;
  Transient : boolean;
  ErrorStart: string;
begin
  Assert((TotFluidSourceParamIndex >= 0) and
    (ConcTempParamIndex >= 0) and
    (TimeDepParamIndex >= 0) and
    (TopElevParamIndex >= 0) and
    (BotElevParamIndex >= 0) and
    (ContourTypeParamIndex >= 0) and
    (CommentIndex >= 0));

  // loop over the contours.
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

    for ContourIndex := 0 to
      ALayer.NumObjects(funHandle, pieContourObject) -1 do
    begin
      Inc(ContourIndex1);
      // get a contour
      AContour := ContourList[ContourIndex] as TContourObjectOptions;

      Comment := AContour.GetStringParameter(funHandle,CommentIndex);
      Transient := AContour.GetBoolParameter(funHandle,TimeDepParamIndex);

      // get the segments in the contour.
      ListOfSegments := TList.Create;
      try

        ThisContourType :=  AContour.GetIntegerParameter(funHandle,
          ContourTypeParamIndex);

        if not (ThisContourType in AllowableObjectTypes) then
        begin
          raise EInvalidSource.Create
            ('Error: A invalid contour type was used on ' + LayerName + '.');
        end;

        GetCountourLocations(funHandle, ThisContourType, TopElevParamIndex,
          BotElevParamIndex, ContourTypeParamIndex,
          ListOfSegments, AContour, FollowMeshParamIndex);

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
                  GetFloatParameter(funHandle, TotFluidSourceParamIndex);
              SourceOverridden := OverridenParameters.OverriddenFluidSource
                [ContourIndex1,fspTotalSource];
              SourceExpr := TotSourceExpr;
            end;
          2: // specific source
            begin
              AValue := AContour.
                  GetFloatParameter(funHandle, SpecificFluidSourceParamIndex);
              SourceOverridden := OverridenParameters.OverriddenFluidSource
                [ContourIndex1,fspSpecificSource];
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

        ConcentrationOrTemp := AContour.GetFloatParameter(funHandle,
          ConcTempParamIndex);
        ConcOverridden := OverridenParameters.OverriddenFluidSource
          [ContourIndex1,fspConcentration];
        TransientOverridden := OverridenParameters.OverriddenFluidSource
          [ContourIndex1,fspTransient];

        AssignNodeValues(funHandle, ThisContourType, ListOfSegments,
          SourceChoice, FollowMeshParamIndex, AValue, ConcentrationOrTemp,
          {$IFDEF OldSutraIce} 0, {$ENDIF}
          LayerName, AContour, ALayer,
          SourceExpr, ConcExpr, TransientExpr, {$IFDEF OldSutraIce} '', {$ENDIF}
          SourceOverridden, ConcOverridden, TransientOverridden,
          {$IFDEF OldSutraIce} True, {$ENDIF}
          True,
          Comment, ContourList, Transient, (SourceChoice = 2), ErrorStart);


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
  Var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  TotFluidSourceParamIndex, ConcTempParamIndex,
    TimeDepParamIndex, ElevParamIndex,
    ContourTypeParamIndex, CommentIndex : SmallInt;
  TotSourceExpr, ConcExpr, TransientExpr : string;
  TotSourceOpt, ConcTempOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiPoints),Ord(btiFluidSource)]) do
  begin
    // get the layer
    LayerName := TPoint3DFluidSourceLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        TotFluidSourceParamIndex := ALayer.GetParameterIndex
          (funHandle, TTotalFluidSourceParam.WriteParamName);
        ConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle, TConcTempSourceParam.WriteParamName);
        TimeDepParamIndex := ALayer.GetParameterIndex
          (funHandle, TTimeDependanceParam.WriteParamName);
        ElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TElevationParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotFluidSourceParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepParamIndex);
        try
          begin
            TotSourceExpr := TotSourceOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        EvaluateNonSurfaceSources(ContourIndex1, ALayer,
          TotFluidSourceParamIndex, -1,
          ConcTempParamIndex, TimeDepParamIndex, ElevParamIndex,
          ElevParamIndex, -1, ContourTypeParamIndex,
          -1, CommentIndex, funHandle, LayerHandle,
          LayerName, TotSourceExpr, '', ConcExpr, TransientExpr, [1]);
      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;
  end;
end;

procedure InitializeLineSources(const funHandle : ANE_PTR;
  Var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  TotFluidSourceParamIndex, SpecificFluidSourceParamIndex, ConcTempParamIndex,
    TimeDepParamIndex, BeginElevParamIndex, EndElevParamIndex,
    SourceChoiceParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  TotSourceExpr, SpecSourceExpr, ConcExpr, TransientExpr: string;
  TotSourceOpt, SpecSourceOpt, ConcTempOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiLines),Ord(btiFluidSource)]) do
  begin
    // get the layer
    LayerName := TLine3DFluidSourceLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        TotFluidSourceParamIndex := ALayer.GetParameterIndex
          (funHandle, TTotalFluidSourceParam.WriteParamName);
        SpecificFluidSourceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSpecificFluidSourceParam.WriteParamName);
        ConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle, TConcTempSourceParam.WriteParamName);
        TimeDepParamIndex := ALayer.GetParameterIndex
          (funHandle, TTimeDependanceParam.WriteParamName);
        BeginElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TBeginElevaParam.WriteParamName);
        EndElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TEndElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSourceChoice.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle, TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotFluidSourceParamIndex);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificFluidSourceParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepParamIndex);
        try
          begin
            TotSourceExpr := TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        EvaluateNonSurfaceSources(ContourIndex1, ALayer,
          TotFluidSourceParamIndex, SpecificFluidSourceParamIndex,
          ConcTempParamIndex, TimeDepParamIndex, BeginElevParamIndex,
          EndElevParamIndex, SourceChoiceParamIndex, ContourTypeParamIndex,
          FollowMeshParamIndex, CommentIndex,
          funHandle, LayerHandle,
          LayerName, TotSourceExpr, SpecSourceExpr, ConcExpr, TransientExpr, [1,2]);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeSolidSources(const funHandle : ANE_PTR;
  Var ContourIndex1 : ANE_INT32);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  TotFluidSourceParamIndex, SpecificFluidSourceParamIndex, ConcTempParamIndex,
    TimeDepParamIndex, TopElevParamIndex, BotElevParamIndex,
    SourceChoiceParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  TotSourceExpr, SpecSourceExpr, ConcExpr, TransientExpr: string;
  TotSourceOpt, SpecSourceOpt, ConcTempOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSolids),Ord(btiFluidSource)]) do
  begin
    // get the layer
    LayerName := TVolFluidSourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        TotFluidSourceParamIndex := ALayer.GetParameterIndex
          (funHandle, TTotalFluidSourceParam.WriteParamName);
        SpecificFluidSourceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSpecificFluidSourceParam.WriteParamName);
        ConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle, TConcTempSourceParam.WriteParamName);
        TimeDepParamIndex := ALayer.GetParameterIndex
          (funHandle, TTimeDependanceParam.WriteParamName);
        TopElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TZeroTopElevParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TBottomElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSourceChoice.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle, TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotFluidSourceParamIndex);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificFluidSourceParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepParamIndex);
        try
          begin
            TotSourceExpr := TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr  := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        EvaluateNonSurfaceSources(ContourIndex1, ALayer,
          TotFluidSourceParamIndex, SpecificFluidSourceParamIndex,
          ConcTempParamIndex, TimeDepParamIndex, TopElevParamIndex,
          BotElevParamIndex, SourceChoiceParamIndex,
          ContourTypeParamIndex, FollowMeshParamIndex, CommentIndex,
          funHandle, LayerHandle,
          LayerName, TotSourceExpr, SpecSourceExpr, ConcExpr, TransientExpr, [3]);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;


procedure InitializeFluidSources(funHandle : ANE_PTR ) ;
Var
  ContourIndex1 : ANE_INT32;
  Index : integer;
  Node : TVirtualNode;
begin
  // Initialize the values of the nodes to 0.
  frmSutra.VirtualMesh.InitializeNodeValues;

  ContourIndex1 := -1;
  InitializeSolidSources(funHandle, ContourIndex1);
  InitializePointSources(funHandle, ContourIndex1);
  InitializeLineSources(funHandle, ContourIndex1);
  InitializeVerticalSheetSources(funHandle, ContourIndex1);
  InitializeSlantedSheetSources(funHandle, ContourIndex1);
  for Index := 0 to frmSutra.VirtualMesh.NodeCount -1 do
  begin
    Node := frmSutra.VirtualMesh.VirtualNodes[Index];
    if Node.Used then
    begin
      if Node.Value5 <> 0 then
      begin
        Node.Value2 := Node.Value2 + Node.Value4/Node.Value5;
      end;
    end;
  end;
  InitializeArgusSources(funHandle, True);
  for Index := 0 to frmSutra.VirtualMesh.NodeCount -1 do
  begin
    Node := frmSutra.VirtualMesh.VirtualNodes[Index];
    if Node.Used then
    begin
      if Node.Value1 <= 0 then
      begin
        Node.Value2 := 0;
      end
    end;
  end;
end;

procedure InitializeSourcesOfFluid (const refPtX : ANE_DOUBLE_PTR      ;
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

          InitializeFluidSources(funHandle);
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

procedure GetSourcesOfFluid (const refPtX : ANE_DOUBLE_PTR      ;
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
          NodeIndex :=  param1_ptr^ - 1;
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

procedure GetSourcesOfFluidConcentration (const refPtX : ANE_DOUBLE_PTR      ;
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
          NodeIndex :=  param1_ptr^ - 1;
          NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

          result := frmSutra.VirtualMesh.VirtualNodes[NodeIndex].Value2
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
