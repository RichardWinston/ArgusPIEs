unit SpecifiedConcTempFunctions;

interface

uses SysUtils, Dialogs, Contnrs, AnePIE, ANECB;

procedure InitializeSpecifiedConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSpecifiedConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeSpecifiedConcTempNodes(funHandle : ANE_PTR );

implementation

uses Classes, OptionsUnit, VirtualMeshFunctions, VirtMeshUtilFunctions,
  SolidGeom, VirtualMeshUnit, frmSutraUnit,
  SLGeneralParameters, doublePolyhedronUnit, ANE_LayerUnit, ArgusFormUnit,
  ParamArrayUnit, OverriddenArrayUnit, SLSpecConcOrTemp, SLSutraMesh,
  UtilityFunctions, ZFunction;

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
  UBCParamIndex, IsSourceIndex, TransientIndex : SmallInt;
  LayerOptions : TLayerOptions;
  LayerHandle : ANE_PTR;
  ProjectOptions : TProjectOptions;
  Value1 : double;
  LayerName, parameterName : string;
  Comment : string;
  LayerUsed : boolean;
  VerticallyAligned : boolean;
  Transient: Boolean;
  {$IFDEF OldSutraIce}
  Gnuu0Index : SmallInt;
  Conductance: double;
  {$ENDIF}
begin
  ProjectOptions := TProjectOptions.Create;
  try
    VirtualLayerIndex := 0;
    VerticallyAligned := frmSutra.rb3D_va.Checked;
    for LayerIndex := 0 to StrToInt(frmSutra.adeVertDisc.text) do
    begin
      if LayerIndex = 0 then
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSpecConc,0,True);
      end
      else
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSpecConc,LayerIndex-1,
          False);
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
          parameterName := TUBCParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;
          UBCParamIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(UBCParamIndex<>-1);

          parameterName := TIsUBCSource.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;
          IsSourceIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(IsSourceIndex<>-1);


          parameterName := TTimeDepSpecConcTempParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;
          TransientIndex := LayerOptions.GetParameterIndex(funHandle,
            parameterName);
          Assert(TransientIndex<>-1);

          {$IFDEF OldSutraIce}
          Gnuu0Index := -1;
          if frmSutra.rbFreezing.Checked then
          begin
            parameterName := TGNUU0Param.WriteParamName;
            if VerticallyAligned then
            begin
              parameterName := parameterName + IntToStr(LayerIndex + 1);
            end;
            Gnuu0Index := LayerOptions.GetParameterIndex(funHandle,
              parameterName);
            Assert(Gnuu0Index<>-1);
          end;
          {$ENDIF}
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
            Comment := Format('Bottom of Unit: %d. Node: %d',
              [LayerIndex,NodeIndex+1]);
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
            Value1 := ARealNode.RealParameterValue(funHandle, UBCParamIndex);
            Transient := ARealNode.BooleanParameterValue(funHandle, TransientIndex);
            {$IFDEF OldSutraIce}
            if frmSutra.rbFreezing.Checked then
            begin
              Conductance := ARealNode.RealParameterValue(funHandle, Gnuu0Index);
            end
            else
            begin
              Conductance := 0;
            end;
            {$ENDIF}

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
              AVirtualNode.Transient := Transient;
              {$IFDEF OldSutraIce}
              AVirtualNode.Conductance := Conductance;
              {$ENDIF}
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
  SpecifiedConcTemp,
    FollowMeshParamIndex, TopElevParamIndex, EndTopParamIndex,
    BotElevParamIndex, EndBotParamIndex, ContourType,
    CommentIndex, TimeDepIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex: integer;
  APlane : TValuePlane;
  Area : extended;
  AValue : extended;
  DummyValue : double;
  ConcTempExpr, SourceExpr, TransientExpr : string;
  SourceOverRide, DummyOverRide, TransientOverride : boolean;
  ConcTempOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiVerticalSheets),Ord(btiSpecConc)]) do
  begin
    // get the layer
    LayerName := TVerticalSheet3DSpecConcTempLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        SpecifiedConcTemp := ALayer.GetParameterIndex
          (funHandle,TSpecConcTempParam.WriteParamName);
        TopElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TBeginTopElevaParam.WriteParamName);
        EndTopParamIndex := ALayer.GetParameterIndex
          (funHandle,TEndTopElevaParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TBeginBottomElevaParam.WriteParamName);
        EndBotParamIndex := ALayer.GetParameterIndex
          (funHandle,TEndBottomElevaParam.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        TimeDepIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);

        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        Assert((SpecifiedConcTemp >= 0) and
          (FollowMeshParamIndex >= 0) and
          (TopElevParamIndex >= 0) and
          (EndTopParamIndex >= 0) and
          (BotElevParamIndex >= 0) and
          (EndBotParamIndex >= 0) and
          (ContourType >= 0) and
          (CommentIndex >= 0));

        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecifiedConcTemp);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepIndex);
        try
          begin
            ConcTempExpr := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;


        for ContourIndex := 0 to
          ALayer.NumObjects(funHandle,pieContourObject) -1 do
        begin
          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
          Transient := AContour.GetBoolParameter(funHandle,TimeDepIndex);

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try
            AValue := AContour.
                GetFloatParameter(funHandle,SpecifiedConcTemp);
            SourceOverRide := OverridenParameters.OverriddenSpecConcTemp
              [ContourIndex1,scConcentration];
            SourceExpr := ConcTempExpr;

            DummyValue := 0;
            DummyOverRide := True;

            TransientOverride := OverridenParameters.OverriddenSpecConcTemp
              [ContourIndex1,scTransient];

            ThisContourType := AContour.GetIntegerParameter(funHandle,
              ContourType);
            case ThisContourType of
              2: // open contour
                begin
                  GetOpenContourPlanes(funHandle,AContour, TopElevParamIndex,
                    EndTopParamIndex, BotElevParamIndex, EndBotParamIndex,
                    1, FollowMeshParamIndex, ListOfPlanes, Area);

                  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
                  begin
                    APlane := ListOfPlanes[PlaneIndex];
                    APlane.Value1 := AValue;//*APlane.PlaneArea/Area;

                    if APlane.Value2 = 0 then
                    begin
                      APlane.Value2 := DummyValue;
                    end
                    else if APlane.Value2 <> DummyValue then
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

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, 3,
              ALayer, SourceExpr, '', TransientExpr,
              SourceOverRide, DummyOverRide, TransientOverride,
              False,
              Comment, Transient, False);

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
  SpecifiedConcTemp,
    FollowMeshParamIndex, ContourType, TimeDepIndex,
    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex {, NodeIndex} : integer;
  APlane : TValuePlane;
  Area : extended;
  AValue : extended;
  DummyValue : double;
  ConcTempExpr, SourceExpr, TransientExpr : string;
  SourceOverRide, DummyOverRide, TransientOverRide : boolean;
  ConcTempOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSlantedSheets),Ord(btiSpecConc)]) do
  begin
    // get the layer
    LayerName := TSlantedSheet3DSpecConcTempLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        SpecifiedConcTemp := ALayer.GetParameterIndex
          (funHandle,TSpecConcTempParam.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        TimeDepIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);

        X1 := ALayer.GetParameterIndex(funHandle,TX1Param.WriteParamName);
        Y1 := ALayer.GetParameterIndex(funHandle,TY1Param.WriteParamName);
        Z1 := ALayer.GetParameterIndex(funHandle,TZ1Param.WriteParamName);
        X2 := ALayer.GetParameterIndex(funHandle,TX2Param.WriteParamName);
        Y2 := ALayer.GetParameterIndex(funHandle,TY2Param.WriteParamName);
        Z2 := ALayer.GetParameterIndex(funHandle,TZ2Param.WriteParamName);
        X3 := ALayer.GetParameterIndex(funHandle,TX3Param.WriteParamName);
        Y3 := ALayer.GetParameterIndex(funHandle,TY3Param.WriteParamName);
        Z3 := ALayer.GetParameterIndex(funHandle,TZ3Param.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);

        Assert((SpecifiedConcTemp >= 0) and
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

        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecifiedConcTemp);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepIndex);
        try
          begin
            ConcTempExpr := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;


        for ContourIndex := 0 to
          ALayer.NumObjects(funHandle,pieContourObject) -1 do
        begin
          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
          Transient := AContour.GetBoolParameter(funHandle,TimeDepIndex);

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try
            AValue := AContour.
                GetFloatParameter(funHandle,SpecifiedConcTemp);
            SourceOverRide := OverridenParameters.OverriddenSpecConcTemp
              [ContourIndex1,scConcentration];
            SourceExpr := ConcTempExpr;

            DummyValue := 0;
            DummyOverRide := True;

            TransientOverRide := OverridenParameters.OverriddenSpecConcTemp
              [ContourIndex1,scTransient];

            ThisContourType := AContour.GetIntegerParameter(funHandle,
              ContourType);
            case ThisContourType of
              3: // closed contour
                begin
                  GetClosedContourPlanes(funHandle,AContour, ListOfPlanes,
                    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3);
                  Assert(ListOfPlanes.Count = 1);
                  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
                  begin
                    APlane := ListOfPlanes[PlaneIndex];
                    APlane.Value1 := AValue;
                    APlane.PlaneArea := APlane.Area;
                    if APlane.Value2 = 0 then
                    begin
                      APlane.Value2 := DummyValue;
                    end
                    else if APlane.Value2 <> DummyValue then
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

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, 3,
              ALayer, SourceExpr, '', TransientExpr,
              SourceOverRide, DummyOverRide, TransientOverRide,
              False,
              Comment, Transient, False);

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

procedure EvaluateNonPlaneSources(const funHandle, LayerHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32;
  const ALayer : TLayerOptions;
  const SpecConcTempParamIndex, TopElevParamIndex,
    BotElevParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex, TimeDepIndex : SmallInt;
    {$IFDEF OldSutraIce}ConductanceParamIndex : SmallInt; {$ENDIF}
    SpecConcTempExpr, TransientExpr, {$IFDEF OldSutraIce} ConductanceExpr, {$ENDIF}
    LayerName : string;
    const AllowableObjectTypes: TAllowableObjectTypes);
var
  ContourList : TObjectList;
  ContourIndex : ANE_INT32;
  AContour : TContourObjectOptions;
  Comment : string;
  ListOfSegments : TList;
  ThisContourType : integer;
  AValue : extended;
  SourceOverridden, DummyOverridden, TransientOverridden : boolean;
  DummyValue : double;
  SegmentIndex : integer;
  SourceExpr : string;
  Transient : boolean;
  ErrorStart: string;
  {$IFDEF OldSutraIce}
  ConductanceOverridden : boolean;
  ConductanceValue : extended;
  CondExpr: string;
  {$ENDIF}
begin
  Assert((SpecConcTempParamIndex >= 0) and
    (TopElevParamIndex >= 0) and
    (BotElevParamIndex >= 0) and
    (ContourTypeParamIndex >= 0) and
    (CommentIndex >= 0));
  {$IFDEF OldSutraIce}
  Assert(ConductanceParamIndex >= 0);
  {$ENDIF}
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
    for ContourIndex := 0 to
      ALayer.NumObjects(funHandle,pieContourObject) -1 do
    begin
      Inc(ContourIndex1);
      // get a contour
      AContour := ContourList[ContourIndex] as TContourObjectOptions;

      Comment := AContour.GetStringParameter(funHandle,CommentIndex);
      Transient := AContour.GetBoolParameter(funHandle,TimeDepIndex);

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

        GetCountourLocations(funHandle,ThisContourType, TopElevParamIndex,
          BotElevParamIndex, ContourTypeParamIndex,
          ListOfSegments, AContour, FollowMeshParamIndex);

        AValue := AContour.
            GetFloatParameter(funHandle,SpecConcTempParamIndex);
        SourceOverridden := OverridenParameters.OverriddenSpecConcTemp
          [ContourIndex1,scConcentration];
        SourceExpr := SpecConcTempExpr;

        DummyValue := 0;
        DummyOverridden := True;

        TransientOverridden := OverridenParameters.OverriddenSpecConcTemp
          [ContourIndex1,scTransient];

        {$IFDEF OldSutraIce}
        ConductanceValue := AContour.
            GetFloatParameter(funHandle,ConductanceParamIndex);
        ConductanceOverridden := OverridenParameters.OverriddenSpecConcTemp
          [ContourIndex1,scConductance];
        CondExpr := ConductanceExpr;
        {$ENDIF}


        AssignNodeValues(funHandle, ThisContourType, ListOfSegments, 3,
          FollowMeshParamIndex, AValue, DummyValue,
          {$IFDEF OldSutraIce} ConductanceValue, {$ENDIF}
          LayerName, AContour, ALayer,
          SourceExpr, '', TransientExpr,
          {$IFDEF OldSutraIce} CondExpr, {$ENDIF}
          SourceOverridden, DummyOverridden, TransientOverridden,
          {$IFDEF OldSutraIce} ConductanceOverridden, {$ENDIF}
          False,
          Comment, ContourList, Transient, False, ErrorStart);
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
  SpecConcTempParamIndex, ElevParamIndex, ContourTypeParamIndex, TimeDepIndex,
    CommentIndex : SmallInt;
  SpecConcTempExpr, TransientExpr : string;
  SpecConcTempOpt, TransientOpt : TParameterOptions;
{$IFDEF OldSutraIce}
  ConductanceParamIndex : SmallInt;
  ConductanceOpt : TParameterOptions;
  ConductanceExpr : string;
{$ENDIF}
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiPoints),Ord(btiSpecConc)]) do
  begin
    // get the layer
    LayerName := TPoint3DSpecConcTempLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        SpecConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle,TSpecConcTempParam.WriteParamName);
        ElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TElevationParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        TimeDepIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);
        {$IFDEF OldSutraIce}
        ConductanceParamIndex := ALayer.GetParameterIndex(funHandle,
          TConductance.WriteParamName);
        {$ENDIF}

        SpecConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepIndex);
        try
          begin
            SpecConcTempExpr :=  SpecConcTempOpt.Expr[funHandle];
            TransientExpr :=  TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            SpecConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        {$IFDEF OldSutraIce}
        ConductanceOpt := TParameterOptions.Create(LayerHandle,
          ConductanceParamIndex);
        try
          begin
            ConductanceExpr :=  ConductanceOpt.Expr[funHandle];
          end;
        finally
          begin
            ConductanceOpt.Free;
          end;
        end;
        {$ENDIF}

        EvaluateNonPlaneSources(funHandle, LayerHandle,
          ContourIndex1, ALayer,
          SpecConcTempParamIndex, ElevParamIndex,
          ElevParamIndex, ContourTypeParamIndex,
          -1, CommentIndex, TimeDepIndex,
          {$IFDEF OldSutraIce} ConductanceParamIndex, {$ENDIF}
          SpecConcTempExpr, TransientExpr,
          {$IFDEF OldSutraIce} ConductanceExpr, {$ENDIF}
          LayerName, [1]);

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
  SpecConcTempParamIndex,
    BeginParamIndex, EndParamIndex,
    ContourTypeParamIndex, TimeDepIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  SpecConcTempExpr, TransientExpr : string;
  SpecConcTempOpt, TransientOpt : TParameterOptions;
{$IFDEF OldSutraIce}
  ConductanceParamIndex : SmallInt;
  ConductanceOpt : TParameterOptions;
  ConductanceExpr : string;
{$ENDIF}
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiLines),Ord(btiSpecConc)]) do
  begin
    // get the layer
    LayerName := TLine3DSpecConcTempLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        SpecConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle,TSpecConcTempParam.WriteParamName);
        BeginParamIndex := ALayer.GetParameterIndex
          (funHandle,TBeginElevaParam.WriteParamName);
        EndParamIndex := ALayer.GetParameterIndex
          (funHandle,TEndElevaParam.WriteParamName);
        TimeDepIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);
        {$IFDEF OldSutraIce}
        ConductanceParamIndex := ALayer.GetParameterIndex(funHandle,
          TConductance.WriteParamName);
        {$ENDIF}

        SpecConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepIndex);
        try
          begin
            SpecConcTempExpr :=  SpecConcTempOpt.Expr[funHandle];
            TransientExpr :=  TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            SpecConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        {$IFDEF OldSutraIce}
        ConductanceOpt := TParameterOptions.Create(LayerHandle,
          ConductanceParamIndex);
        try
          begin
            ConductanceExpr :=  ConductanceOpt.Expr[funHandle];
          end;
        finally
          begin
            ConductanceOpt.Free;
          end;
        end;
        {$ENDIF}


        EvaluateNonPlaneSources(funHandle, LayerHandle,
          ContourIndex1, ALayer, SpecConcTempParamIndex, BeginParamIndex,
          EndParamIndex, ContourTypeParamIndex,
          FollowMeshParamIndex, CommentIndex, TimeDepIndex,
          {$IFDEF OldSutraIce} ConductanceParamIndex, {$ENDIF}
          SpecConcTempExpr, TransientExpr,
          {$IFDEF OldSutraIce} ConductanceExpr, {$ENDIF}
          LayerName, [1,2]);

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
  SpecConcTempParamIndex,
    TopElevParamIndex, BotElevParamIndex,
    ContourTypeParamIndex, TimeDepIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  SpecConcTempExpr, TransientExpr : string;
  SpecConcTempOpt, TransientOpt : TParameterOptions;
{$IFDEF OldSutraIce}
  ConductanceParamIndex : SmallInt;
  ConductanceOpt : TParameterOptions;
  ConductanceExpr : string;
{$ENDIF}
begin
  // loop over sources of fluit layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSolids),Ord(btiSpecConc)]) do
  begin
    // get the layer
    LayerName := TVolSpecConcTempLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        SpecConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle,TSpecConcTempParam.WriteParamName);
        TopElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TZeroTopElevParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TBottomElevaParam.WriteParamName);
        TimeDepIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle,
          TCommentParam.WriteParamName);
        {$IFDEF OldSutraIce}
        ConductanceParamIndex := ALayer.GetParameterIndex(funHandle,
          TConductance.WriteParamName);
        {$ENDIF}

        SpecConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepIndex);
        try
          begin
            SpecConcTempExpr :=  SpecConcTempOpt.Expr[funHandle];
            TransientExpr :=  TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            SpecConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;
        {$IFDEF OldSutraIce}
        ConductanceOpt := TParameterOptions.Create(LayerHandle,
          ConductanceParamIndex);
        try
          begin
            ConductanceExpr :=  ConductanceOpt.Expr[funHandle];
          end;
        finally
          begin
            ConductanceOpt.Free;
          end;
        end;
        {$ENDIF}

        EvaluateNonPlaneSources(funHandle, LayerHandle, ContourIndex1, ALayer,
          SpecConcTempParamIndex, TopElevParamIndex, BotElevParamIndex,
          ContourTypeParamIndex, FollowMeshParamIndex, CommentIndex,
          TimeDepIndex, {$IFDEF OldSutraIce} ConductanceParamIndex, {$ENDIF}
          SpecConcTempExpr, TransientExpr,
          {$IFDEF OldSutraIce} ConductanceExpr, {$ENDIF} LayerName, [3]);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeSpecifiedConcTempNodes(funHandle : ANE_PTR );
var
  ContourIndex1 : ANE_INT32;
begin
  // Initialize the values of the nodes to 0.
  frmSutra.VirtualMesh.InitializeNodeValues;

  ContourIndex1 := -1;
  InitializeSolidSources(funHandle, ContourIndex1);
  InitializePointSources(funHandle, ContourIndex1);
  InitializeLineSources(funHandle, ContourIndex1);
  InitializeVerticalSheetSources(funHandle, ContourIndex1);
  InitializeSlantedSheetSources(funHandle, ContourIndex1);

  InitializeArgusSources(funHandle, False);
end;

procedure InitializeSpecifiedConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
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

          InitializeSpecifiedConcTempNodes(funHandle);

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

procedure GetSpecifiedConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  NodeIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
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

end.
