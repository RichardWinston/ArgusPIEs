unit SpecifiedPressFunctions;

interface

uses SysUtils, Dialogs, Contnrs, AnePIE, ANECB;

procedure InitializeSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSpecifiedPressureConcentration (const refPtX : ANE_DOUBLE_PTR;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeSpecifiedPressureNodes(funHandle : ANE_PTR );
                                
implementation

uses Classes, OptionsUnit, VirtualMeshFunctions, VirtMeshUtilFunctions,
  SolidGeom, VirtualMeshUnit, SLSpecifiedPressure, frmSutraUnit,
  SLGeneralParameters, doublePolyhedronUnit, ANE_LayerUnit, ArgusFormUnit,
  ParamArrayUnit, OverriddenArrayUnit, SLSutraMesh, UtilityFunctions,
  ZFunction;

procedure InitializeArgusSources(funHandle : ANE_PTR; AddValues : boolean);
const
  Epsilon = 1e-8;
var
  LayerIndex : Integer;
  AMesh : TReal2DMesh;
  NodeIndex : integer;
  ARealNode : TRealNode;
  VirtualLayerIndex : integer;
  AVirtualNode : TVirtualNode;
  VirtualNodeIndex : integer;
  IsBoundary : boolean;
  PBCParamIndex, pUBCParamIndex, IsSourceIndex, CommentIndex, TransientIndex : SmallInt;
  LayerOptions : TLayerOptions;
  LayerHandle : ANE_PTR;
  ProjectOptions : TProjectOptions;
  Value1, Value2 : double;
  LayerName, parameterName {, SpecifiedHeadName} : string;
  Comment, CommentBase : string;
  LayerUsed : boolean;
  VerticallyAligned : boolean;
//  SpecifiedHeadLayer: TLayerOptions;
  Transient: boolean;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    VirtualLayerIndex := 0;
    VerticallyAligned := frmSutra.rb3D_va.Checked;
    for LayerIndex := 0 to StrToInt(frmSutra.adeVertDisc.text) do
    begin
      if LayerIndex = 0 then
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSpecPres,0,True);
      end
      else
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btSpecPres,LayerIndex-1,
          False);
      end;

      if LayerIndex > 0 then
      begin
        VirtualLayerIndex := VirtualLayerIndex
          + frmSutra.VirtualMesh.Discretization[LayerIndex-1]
      end;
      if LayerUsed then
      begin

//        if LayerIndex = 0 then
//        begin
//          SpecifiedHeadName := TTopSpecifiedPressureLayer.WriteNewRoot;
//        end
//        else
//        begin
//          SpecifiedHeadName := TBottomSpecifiedPressureLayer.WriteNewRoot
//            + IntToStr(LayerIndex);
//        end;
//
//        LayerHandle := ProjectOptions.GetLayerByName
//          (funHandle,SpecifiedHeadName);
//        SpecifiedHeadLayer := TLayerOptions.Create(LayerHandle);
//        try
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
            parameterName := TPBCParam.WriteParamName;
            if VerticallyAligned then
            begin
              parameterName := parameterName + IntToStr(LayerIndex + 1);
            end;
            PBCParamIndex := LayerOptions.GetParameterIndex(funHandle,
              parameterName);
            Assert(PBCParamIndex<>-1);

            parameterName := TpUBCParam.WriteParamName;
            if VerticallyAligned then
            begin
              parameterName := parameterName + IntToStr(LayerIndex + 1);
            end;
            pUBCParamIndex := LayerOptions.GetParameterIndex(funHandle,
              parameterName);
            Assert(pUBCParamIndex<>-1);

            parameterName := TIsPBCSource.WriteParamName;
            if VerticallyAligned then
            begin
              parameterName := parameterName + IntToStr(LayerIndex + 1);
            end;
            IsSourceIndex := LayerOptions.GetParameterIndex(funHandle,
              parameterName);
            Assert(IsSourceIndex<>-1);

            parameterName := TTimeDepSpecHeadPresParam.WriteParamName;
            if VerticallyAligned then
            begin
              parameterName := parameterName + IntToStr(LayerIndex + 1);
            end;
            TransientIndex := LayerOptions.GetParameterIndex(funHandle,
              parameterName);
            Assert(TransientIndex<>-1);

            parameterName := TPBC_CommentParam.WriteParamName;
            if VerticallyAligned then
            begin
              parameterName := parameterName + IntToStr(LayerIndex + 1);
            end;
            CommentIndex := LayerOptions.GetParameterIndex(funHandle,
              parameterName);
            Assert(CommentIndex<>-1);

          finally
            LayerOptions.Free(funHandle);
          end;

          for NodeIndex := 0 to AMesh.NodeCount -1 do
          begin

            ARealNode := AMesh.Nodes[NodeIndex];
            IsBoundary := ARealNode.BooleanParameterValue(funHandle,
              IsSourceIndex);
            if IsBoundary then
            begin
              if LayerIndex = 0 then
              begin
                CommentBase := Format(' Top of Unit: 1 Node: %d', [NodeIndex+1]);
              end
              else
              begin
                CommentBase := Format(' Bottom of Unit: %d. Node: %d',
                  [LayerIndex,NodeIndex+1]);
              end;



              VirtualNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex
                (VirtualLayerIndex,NodeIndex);
              AVirtualNode := frmSutra.VirtualMesh.VirtualNodes[VirtualNodeIndex];
              CurrentVertex := AVirtualNode;

              { TODO : 
Insert comments like this in 2D and for other boundary conditions on tops 
and bottoms of units. }

              Comment := 
                ARealNode.StringParameterValue(funHandle, CommentIndex)
                + CommentBase;

              Value1 := ARealNode.RealParameterValue(funHandle, PBCParamIndex);
              Value2 := ARealNode.RealParameterValue(funHandle, pUBCParamIndex);
              Transient := ARealNode.BooleanParameterValue(funHandle, TransientIndex);

              AVirtualNode.Transient := Transient;
              if AVirtualNode.Used
                and not NearlyTheSame(Value1,AVirtualNode.Value1,Epsilon)
              then
              begin
                raise EInvalidSource.Create
                  ('Error: Two different specified pressures or heads assigned '
                   + 'to the same node at Node '
                   + IntToStr(NodeIndex +1)
                   + ' at ' + AVirtualNode.LocationString);
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
                   + 'temparatures assigned to node with specified pressure '
                   + 'or head at Node '
                   + IntToStr(NodeIndex +1)
                   + ' at ' + AVirtualNode.LocationString);
                end;
              end;

            end;
          end;
//        finally
//          SpecifiedHeadLayer.Free(funHandle);
//        end;
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
  SpecifiedPressure, ConcTemp, TimeDep,
    FollowMeshParamIndex, TopElevParamIndex, EndTopParamIndex,
    BotElevParamIndex, EndBotParamIndex, ContourType,
    CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  Area : extended;
  AValue : extended;
  ConcentrationOrTemp : double;
  PressureExpr, SourceExpr, ConcExpr, TransientExpr : string;
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  PressureOpt, ConcTempOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiVerticalSheets),Ord(btiSpecPressure)]) do
  begin
    // get the layer
    LayerName := TVerticalSheet3DSpecifiedPressureLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        SpecifiedPressure := ALayer.GetParameterIndex
          (funHandle,TSpecPressureParam.WriteParamName);
        ConcTemp := ALayer.GetParameterIndex
          (funHandle,TConcOrTempParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
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
        CommentIndex := ALayer.GetParameterIndex
          (funHandle, TCommentParam.WriteParamName);

        Assert((SpecifiedPressure >= 0) and
          (ConcTemp >= 0) and
          (TimeDep >= 0) and
          (FollowMeshParamIndex >= 0) and
          (TopElevParamIndex >= 0) and
          (EndTopParamIndex >= 0) and
          (BotElevParamIndex >= 0) and
          (EndBotParamIndex >= 0) and
          (ContourType >= 0) and
          (CommentIndex >= 0));

        PressureOpt := TParameterOptions.Create(LayerHandle,
          SpecifiedPressure);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTemp);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          begin
            PressureExpr := PressureOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            PressureOpt.Free;
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
          Transient := AContour.GetBoolParameter(funHandle,TimeDep);

          SourceOverRide := OverridenParameters.OverriddenPressure
            [ContourIndex1,ppPressure];
          SourceExpr := PressureExpr;
          if SourceOverRide then
          begin
            AValue := AContour.
              GetFloatParameter(funHandle,SpecifiedPressure);
          end
          else
          begin
            AValue := 0;
          end;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try

            ConcentrationOrTemp := AContour.GetFloatParameter(funHandle,
              ConcTemp);
            ConcOverRide := OverridenParameters.OverriddenPressure
              [ContourIndex1,ppConcentration];
            TransientOverRide := OverridenParameters.OverriddenPressure
              [ContourIndex1,ppTransient];

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

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, 3,
              ALayer, SourceExpr, ConcExpr, TransientExpr,
              SourceOverRide, ConcOverRide, TransientOverRide,
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
  SpecifiedPressure, ConcTemp, TimeDep, ContourType,
    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  Area : extended;
  AValue : extended;
  ConcentrationOrTemp : double;
  PressureExpr, SourceExpr, ConcExpr, TransientExpr : string;
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  PressureOpt, ConcTempOpt, TransientOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSlantedSheets),Ord(btiSpecPressure)]) do
  begin
    // get the layer
    LayerName := TSlantedSheet3DSpecifiedPressureLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
        SpecifiedPressure := ALayer.GetParameterIndex
          (funHandle,TSpecPressureParam.WriteParamName);
        ConcTemp := ALayer.GetParameterIndex
          (funHandle,TConcOrTempParam.WriteParamName);
        TimeDep := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);

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

        Assert((SpecifiedPressure >= 0) and
          (ConcTemp >= 0) and
          (TimeDep >= 0) and
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

        PressureOpt := TParameterOptions.Create(LayerHandle,
          SpecifiedPressure);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTemp);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDep);
        try
          begin
            PressureExpr := PressureOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            PressureOpt.Free;
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
          Transient := AContour.GetBoolParameter(funHandle,TimeDep);

          AValue := AContour.
              GetFloatParameter(funHandle,SpecifiedPressure);
          SourceOverRide := OverridenParameters.OverriddenPressure
            [ContourIndex1,ppPressure];
          SourceExpr := PressureExpr;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try

            ConcentrationOrTemp := AContour.GetFloatParameter(funHandle,
              ConcTemp);
            ConcOverRide := OverridenParameters.OverriddenPressure
              [ContourIndex1,ppConcentration];
            TransientOverRide := OverridenParameters.OverriddenPressure
              [ContourIndex1,ppTransient];

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

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, 3,
              ALayer, SourceExpr, ConcExpr, TransientExpr,
              SourceOverRide, ConcOverRide, TransientOverRide,
              False, Comment, Transient, False);

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

procedure EvaluateNonPlaneContours(funHandle, LayerHandle : ANE_PTR;
  var ContourIndex1 : ANE_INT32;
  const LayerName, SpecPresExpr, ConcExpr, TransientExpr : string;
  const ALayer : TLayerOptions;
  const SpecPresParamIndex, ConcTempParamIndex, TimeDepParamIndex,
    TopElevParamIndex, BotElevParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
    const AllowableObjectTypes: TAllowableObjectTypes);
var
  ContourIndex: ANE_INT32;
  ContourList : TObjectList;
  AContour : TContourObjectOptions;
  Comment : string;
  ListOfSegments : TList;
  ThisContourType : integer;
  AValue : extended;
  SourceOverridden, ConcOverridden, TransientOverRidden : boolean;
  SourceExpr : string;
  ConcentrationOrTemp : double;
  SegmentIndex : integer;
  Transient : boolean;
  ErrorStart: string;
begin
  Assert((SpecPresParamIndex >=0) and
    (ConcTempParamIndex >=0) and
    (TimeDepParamIndex >=0) and
    (TopElevParamIndex >=0) and
    (BotElevParamIndex >=0) and
    (ContourTypeParamIndex >=0) and
    (CommentIndex >=0));
  ContourList := TObjectList.Create;
  try
    for ContourIndex := 0 to ALayer.NumObjects(funHandle,pieContourObject) -1 do
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

        GetCountourLocations(funHandle,ThisContourType, TopElevParamIndex,
          BotElevParamIndex, ContourTypeParamIndex,
          ListOfSegments, AContour, FollowMeshParamIndex);

        // Assign values to nodes
        AValue := AContour.
            GetFloatParameter(funHandle,SpecPresParamIndex);
        SourceOverridden := OverridenParameters.OverriddenPressure
          [ContourIndex1,ppPressure];
        SourceExpr := SpecPresExpr;

        ConcentrationOrTemp := AContour.GetFloatParameter(funHandle,
          ConcTempParamIndex);
        ConcOverridden := OverridenParameters.OverriddenPressure
          [ContourIndex1,ppConcentration];
        TransientOverRidden := OverridenParameters.OverriddenPressure
          [ContourIndex1,ppTransient];

        AssignNodeValues(funHandle, ThisContourType, ListOfSegments, 3,
          FollowMeshParamIndex, AValue, ConcentrationOrTemp,
          {$IFDEF OldSutraIce} 0, {$ENDIF}
          LayerName, AContour, ALayer,
          SourceExpr, ConcExpr, TransientExpr, {$IFDEF OldSutraIce} '', {$ENDIF}
          SourceOverridden, ConcOverridden, TransientOverRidden,
          {$IFDEF OldSutraIce} True, {$ENDIF}
          False, Comment, ContourList, Transient, False, ErrorStart);


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
  SpecPresParamIndex, ConcTempParamIndex, TimeDepParamIndex, ElevParamIndex,
    ContourTypeParamIndex, CommentIndex : SmallInt;
  SpecPresExpr, ConcExpr, TransientExpr : string;
  SpecPresOpt, ConcTempOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiPoints),Ord(btiSpecPressure)]) do
  begin
    // get the layer
    LayerName := TPoint3DSpecifiedPressureLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        SpecPresParamIndex := ALayer.GetParameterIndex
          (funHandle,TSpecPressureParam.WriteParamName);
        ConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle,TConcOrTempParam.WriteParamName);
        TimeDepParamIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);
        ElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TElevationParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex
          (funHandle, TCommentParam.WriteParamName);

        SpecPresOpt := TParameterOptions.Create(LayerHandle,
          SpecPresParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepParamIndex);
        try
          begin
            SpecPresExpr := SpecPresOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            SpecPresOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        EvaluateNonPlaneContours(funHandle, LayerHandle,
          ContourIndex1,
          LayerName, SpecPresExpr, ConcExpr, TransientExpr,
          ALayer,
          SpecPresParamIndex, ConcTempParamIndex, TimeDepParamIndex,
          ElevParamIndex, ElevParamIndex, ContourTypeParamIndex,
          -1, CommentIndex, [1])

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
  SpecPresParamIndex, ConcTempParamIndex,
    TimeDepParamIndex, BeginElevParamIndex,
    EndElevParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  SpecPresExpr, ConcExpr, TransientExpr : string;
  SpecPresOpt, ConcTempOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiLines),Ord(btiSpecPressure)]) do
  begin
    // get the layer
    LayerName := TLine3DSpecifiedPressureLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        SpecPresParamIndex := ALayer.GetParameterIndex
          (funHandle,TSpecPressureParam.WriteParamName);
        ConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle,TConcOrTempParam.WriteParamName);
        TimeDepParamIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);

        BeginElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TBeginElevaParam.WriteParamName);
        EndElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TEndElevaParam.WriteParamName);

        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex
          (funHandle, TCommentParam.WriteParamName);

        SpecPresOpt := TParameterOptions.Create(LayerHandle,
          SpecPresParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepParamIndex);
        try
          begin
            SpecPresExpr := SpecPresOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr  := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            SpecPresOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        EvaluateNonPlaneContours(funHandle, LayerHandle,
          ContourIndex1,
          LayerName, SpecPresExpr, ConcExpr, TransientExpr,
          ALayer,
          SpecPresParamIndex, ConcTempParamIndex, TimeDepParamIndex,
          BeginElevParamIndex, EndElevParamIndex, ContourTypeParamIndex,
          FollowMeshParamIndex, CommentIndex, [1,2])

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

  SpecPresParamIndex, ConcTempParamIndex,
    TimeDepParamIndex, TopElevParamIndex,
    BottomElevParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  SpecPresExpr, ConcExpr, TransientExpr : string;
  SpecPresOpt, ConcTempOpt, TransientOpt : TParameterOptions;
begin
  // loop over sources of fluid layers.
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSolids),Ord(btiSpecPressure)]) do
  begin
    // get the layer
    LayerName := TVolSpecifiedPressureLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        SpecPresParamIndex := ALayer.GetParameterIndex
          (funHandle,TSpecPressureParam.WriteParamName);
        ConcTempParamIndex := ALayer.GetParameterIndex
          (funHandle,TConcOrTempParam.WriteParamName);
        TimeDepParamIndex := ALayer.GetParameterIndex
          (funHandle,TTimeDependanceParam.WriteParamName);

        TopElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TZeroTopElevParam.WriteParamName);
        BottomElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TBottomElevaParam.WriteParamName);

        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex
          (funHandle, TCommentParam.WriteParamName);

        SpecPresOpt := TParameterOptions.Create(LayerHandle,
          SpecPresParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
        TransientOpt := TParameterOptions.Create(LayerHandle,
          TimeDepParamIndex);
        try
          begin
            SpecPresExpr := SpecPresOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
            TransientExpr  := TransientOpt.Expr[funHandle];
          end;
        finally
          begin
            SpecPresOpt.Free;
            ConcTempOpt.Free;
            TransientOpt.Free;
          end;
        end;

        EvaluateNonPlaneContours(funHandle, LayerHandle,
          ContourIndex1,
          LayerName, SpecPresExpr, ConcExpr, TransientExpr,
          ALayer,
          SpecPresParamIndex, ConcTempParamIndex, TimeDepParamIndex,
          TopElevParamIndex, BottomElevParamIndex, ContourTypeParamIndex,
          FollowMeshParamIndex, CommentIndex, [3])

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;
  end;
end;

procedure InitializeSpecifiedPressureNodes(funHandle : ANE_PTR );
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

procedure InitializeSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
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

          InitializeSpecifiedPressureNodes(funHandle );
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

procedure GetSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
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

procedure GetSpecifiedPressureConcentration (const refPtX : ANE_DOUBLE_PTR;
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
