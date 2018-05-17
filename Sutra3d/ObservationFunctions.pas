unit ObservationFunctions;

interface

uses SysUtils, Dialogs, Contnrs, AnePIE, ANECB;

procedure InitializeObservations (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetObservation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeObservationsFunction(funHandle : ANE_PTR);

procedure InitializeSimulationTimes (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSimulationTimeStep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSimulationSimulationTime (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetObservationContourCount (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Classes, OptionsUnit, SLObservation, VirtualMeshUnit, frmSutraUnit,
  SLGeneralParameters, ArgusFormUnit, ANE_LayerUnit,
  ParamArrayUnit, VirtMeshUtilFunctions, OverriddenArrayUnit,
  doublePolyhedronUnit, UtilityFunctions, SLSutraMesh, ZFunction;

//Var
//  ObservationsPresent : boolean = False;

{function GetObservationsPresent : boolean;
begin
  result := ObservationsPresent;
end; }

procedure InitializeArgusSources(funHandle : ANE_PTR);
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
  InobParamIndex : SmallInt;
  LayerOptions : TLayerOptions;
  LayerHandle : ANE_PTR;
  ProjectOptions : TProjectOptions;
//  Value1, Value2 : double;
//  N : String;
//  MultipleUnits : boolean;
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
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btObservation,0,True);
      end
      else
      begin
        LayerUsed := frmSutra.ArgusBoundaryLayerUsed(btObservation,LayerIndex-1,False);
      end;

      if LayerIndex > 0 then
      begin
        VirtualLayerIndex := VirtualLayerIndex
          + frmSutra.VirtualMesh.Discretization[LayerIndex-1]
      end;
      if LayerUsed then
      begin
        AMesh := frmSutra.VirtualMesh.Real2DMeshes[LayerIndex];

//        N := frmSutra.GetN(MultipleUnits);

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
{        if (N = '0') then
        begin
          LayerName := LayerName + IntToStr(LayerIndex+1);
        end;  }

        LayerHandle := ProjectOptions.GetLayerByName
          (funHandle,LayerName);
        LayerOptions := TLayerOptions.Create(LayerHandle);
        try
          parameterName := TINOBParam.WriteParamName;
          if VerticallyAligned then
          begin
            parameterName := parameterName + IntToStr(LayerIndex + 1);
          end;
          InobParamIndex := LayerOptions.GetParameterIndex(funHandle,parameterName);
          Assert(InobParamIndex<>-1);


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
            Comment := Format('Bottom of Unit: %d. Node: %d', [LayerIndex,NodeIndex+1]);
          end;

          ARealNode := AMesh.Nodes[NodeIndex];
          IsBoundary := ARealNode.IntegerParameterValue(funHandle, InobParamIndex) <> 0;
          if IsBoundary then
          begin
            VirtualNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex
              (VirtualLayerIndex,NodeIndex);
            AVirtualNode := frmSutra.VirtualMesh.VirtualNodes[VirtualNodeIndex];
            CurrentVertex := AVirtualNode;
            AVirtualNode.Used := True;
            AVirtualNode.Comment := AVirtualNode.Comment +  Comment;
          end;
        end;
      end;

    end;
  finally
    ProjectOptions.Free;
  end;
end;


procedure EvaluateNonSurfaceSources(var ContourIndex1 : ANE_INT32;
  const ALayer : TLayerOptions;
  const TopElevParamIndex, BotElevParamIndex,
    ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex{, TimeDepIndex} : SmallInt;
  const funHandle, LayerHandle : ANE_PTR;
  const LayerName : string);
var
  ContourList : TObjectList;
  ContourIndex : ANE_INT32;
  AContour : TContourObjectOptions;
  Comment : string;
  ThisContourType : integer;
  ListOfSegments : TList;
  SegmentIndex : integer;
  Transient : boolean;
  ErrorStart: string;
begin
  // loop over the contours.
  ContourList := TObjectList.Create;
  try

    for ContourIndex := 0 to ALayer.NumObjects(funHandle, pieContourObject) -1 do
    begin
      // get a contour
      AContour := TContourObjectOptions.Create
        (funHandle,LayerHandle,ContourIndex);

      ContourList.Add(AContour);
    end;

    ErrorStart := 'In ' + ALayer.Name[funHandle] + ', no cells intersect '
      + 'the contour located at ';

    for ContourIndex := 0 to ALayer.NumObjects(funHandle, pieContourObject) -1 do
    begin
      Inc(ContourIndex1);
      // get a contour
      AContour := ContourList[ContourIndex] as TContourObjectOptions;

      Comment := AContour.GetStringParameter(funHandle,CommentIndex);
{      if TimeDepIndex >= 0 then
      begin
        Transient := AContour.GetBoolParameter(funHandle,TimeDepIndex);
      end
      else
      begin   }
        Transient := false;
//      end;


      // get the segments in the contour.
      ListOfSegments := TList.Create;
      try

        ThisContourType :=  AContour.GetIntegerParameter(funHandle, ContourTypeParamIndex);

        GetCountourLocations(funHandle, ThisContourType, TopElevParamIndex,
          BotElevParamIndex, ContourTypeParamIndex,
          ListOfSegments, AContour, FollowMeshParamIndex);

        AssignNodeValues(funHandle, ThisContourType, ListOfSegments, 1,
          FollowMeshParamIndex, 1, 0, {$IFDEF OldSutraIce} 0, {$ENDIF}
          LayerName, AContour, ALayer,
          '', '', '', {$IFDEF OldSutraIce} '', {$ENDIF}
          True, True, True, {$IFDEF OldSutraIce} True, {$ENDIF} True,
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

procedure InitializePointSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  ContourIndex1 : ANE_INT32;
  {SpecConcTempParamIndex,}
  ElevParamIndex, //TimeDepIndex,
  ContourTypeParamIndex : ANE_INT16;
//  ANE_LayerNameStr : ANE_STR;
    {FollowMeshParamIndex,} CommentIndex : SmallInt;
//  SpecConcTempExpr : string;
//  SpecConcTempOpt : TParameterOptions;
begin
  // loop over sources of fluit layers.
  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiPoints),Ord(btiObservations)]) do
  begin
    // get the layer
    LayerName := TPoint3DObservationLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle, LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr,LayerName);
      LayerHandle := ANE_LayerGetHandleByName(funHandle, ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end;      }
//    LayerHandle := ANE_LayerGetHandleByName(funHandle,
//      PChar(LayerName));
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        ElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TElevationParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
//        TimeDepIndex := ALayer.GetParameterIndex
//          (funHandle,TTimeDependanceParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle, TCommentParam.WriteParamName);


        EvaluateNonSurfaceSources(ContourIndex1, ALayer,
          ElevParamIndex, ElevParamIndex, ContourTypeParamIndex,
          -1, CommentIndex, {TimeDepIndex,} funHandle, LayerHandle,
          LayerName);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeLineSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  ContourIndex1 : ANE_INT32;
//  SpecConcTempParamIndex,
    BeginParamIndex, EndParamIndex,
    ContourTypeParamIndex, //TimeDepIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
//  SpecConcTempExpr : string;
//  SpecConcTempOpt : TParameterOptions;
begin
  // loop over sources of fluit layers.
  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiLines),Ord(btiObservations)]) do
  begin
    // get the layer
    LayerName := TLine3DObservationLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle,LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr,LayerName);
      LayerHandle := GetLayerByName(funHandle, ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end;               }
//    LayerHandle := ANE_LayerGetHandleByName(funHandle,
//      PChar(LayerName));
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        BeginParamIndex := ALayer.GetParameterIndex
          (funHandle,TBeginElevaParam.WriteParamName);
        EndParamIndex := ALayer.GetParameterIndex
          (funHandle,TEndElevaParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
//        TimeDepIndex := ALayer.GetParameterIndex
//          (funHandle,TTimeDependanceParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex
          (funHandle, TCommentParam.WriteParamName);

        EvaluateNonSurfaceSources(ContourIndex1, ALayer,
          BeginParamIndex, EndParamIndex, ContourTypeParamIndex,
          FollowMeshParamIndex, CommentIndex, //TimeDepIndex,
          funHandle, LayerHandle,
          LayerName);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeSolidSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  ALayer : TLayerOptions;
  ContourIndex1 : ANE_INT32;
    TopElevParamIndex, BotElevParamIndex,
    ContourTypeParamIndex, //TimeDepIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
begin
  // loop over sources of fluit layers.
  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSolids),Ord(btiObservations)]) do
  begin
    // get the layer
    LayerName := TVol3DObservationLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle,LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr,LayerName);
      LayerHandle := GetLayerByName(funHandle, ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end;     }
//    LayerHandle := ANE_LayerGetHandleByName(funHandle,
//      PChar(LayerName));
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin

        // get the parameter indicies.
        TopElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TZeroTopElevParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle,TBottomElevaParam.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle,TFollowMeshParam.WriteParamName);
//        TimeDepIndex := ALayer.GetParameterIndex
//          (funHandle,TTimeDependanceParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex
          (funHandle, TCommentParam.WriteParamName);

        EvaluateNonSurfaceSources(ContourIndex1, ALayer,
          TopElevParamIndex, BotElevParamIndex, ContourTypeParamIndex,
          FollowMeshParamIndex, CommentIndex, //TimeDepIndex,
          funHandle, LayerHandle,
          LayerName);

      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeVerticalSheetSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
    FollowMeshParamIndex, TopElevParamIndex, EndTopParamIndex,
    BotElevParamIndex, EndBotParamIndex, ContourType, //TimeDepIndex,
    CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex {, NodeIndex} : integer;
  APlane : TValuePlane;
  Area : extended;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
//  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiVerticalSheets),Ord(btiObservations)]) do
  begin
    // get the layer
    LayerName := TVerticalSheet3DObservationLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle,LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr,LayerName);
      LayerHandle := GetLayerByName(funHandle, ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end;   }
//    LayerHandle := ANE_LayerGetHandleByName(funHandle,
//      PChar(LayerName));
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
//        SpecifiedConcTemp := ALayer.GetParameterIndex
//          (funHandle,TSpecConcTempParam.WriteParamName);
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
//        TimeDepIndex := ALayer.GetParameterIndex
//          (funHandle,TTimeDependanceParam.WriteParamName);

        CommentIndex := ALayer.GetParameterIndex(funHandle, TCommentParam.WriteParamName);

{        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecifiedConcTemp);
        try
          begin
            ConcTempExpr := ConcTempOpt.Expr[funHandle];
          end;
        finally
          begin
            ConcTempOpt.Free;
          end;
        end; }


        for ContourIndex := 0 to ALayer.NumObjects(funHandle,pieContourObject) -1 do
        begin
//          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
//          Transient := AContour.GetBoolParameter(funHandle,TimeDepIndex);
          Transient := False;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try
//            AValue := 1;
//            SourceOverRide := True;
//            SourceExpr := '';

//            DummyValue := 0;;
//            DummyOverRide := True;

            ThisContourType := AContour.GetIntegerParameter(funHandle,ContourType);
            case ThisContourType of
              2: // open contour
                begin
                  GetOpenContourPlanes(funHandle,AContour, TopElevParamIndex,
                    EndTopParamIndex, BotElevParamIndex, EndBotParamIndex,
                    1, FollowMeshParamIndex, ListOfPlanes, Area);

                  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
                  begin
                    APlane := ListOfPlanes[PlaneIndex];
                    APlane.Value1 := APlane.PlaneArea/Area;
                  end;

                end;
            else
              begin
                raise EInvalidSource.Create('Error: Only open '
                  + 'contours are allowed on ' + LayerName);
              end;
            end;

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, 3,
              ALayer, '', '', '', True, True, True, False,
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

procedure InitializeSlantedSheetSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
//  SpecifiedConcTemp,
    {FollowMeshParamIndex,} ContourType, //TimeDepIndex,
    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, PlaneIndex {, NodeIndex} : integer;
  APlane : TValuePlane;
//  Area : extended;
//  AValue : extended;
//  DummyValue : double;
//  {ConcTempExpr,} SourceExpr : string;
//  SourceOverRide, DummyOverRide : boolean;
//  ConcTempOpt : TParameterOptions;
  Comment : string;
  Transient : boolean;
begin
  // loop over sources of fluid layers.
//  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.dgBoundaryCountsNew.
    Cells[Ord(otiSlantedSheets),Ord(btiObservations)]) do
  begin
    // get the layer
    LayerName := TSlantedSheet3DObservationLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := GetLayerHandle(funHandle,LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr,LayerName);
      LayerHandle := GetLayerByName(funHandle, ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end;   }
//    LayerHandle := ANE_LayerGetHandleByName(funHandle,
//      PChar(LayerName));
    ALayer := TLayerOptions.Create(LayerHandle);
    try
      begin
        // get the parameter indicies.
//        SpecifiedConcTemp := ALayer.GetParameterIndex
//          (funHandle,TSpecConcTempParam.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle,TContourType.WriteParamName);
//        FollowMeshParamIndex := ALayer.GetParameterIndex
//          (funHandle,TFollowMeshParam.WriteParamName);
//        TimeDepIndex := ALayer.GetParameterIndex
//          (funHandle,TTimeDependanceParam.WriteParamName);

        X1 := ALayer.GetParameterIndex(funHandle,TX1Param.WriteParamName);
        Y1 := ALayer.GetParameterIndex(funHandle,TY1Param.WriteParamName);
        Z1 := ALayer.GetParameterIndex(funHandle,TZ1Param.WriteParamName);
        X2 := ALayer.GetParameterIndex(funHandle,TX2Param.WriteParamName);
        Y2 := ALayer.GetParameterIndex(funHandle,TY2Param.WriteParamName);
        Z2 := ALayer.GetParameterIndex(funHandle,TZ2Param.WriteParamName);
        X3 := ALayer.GetParameterIndex(funHandle,TX3Param.WriteParamName);
        Y3 := ALayer.GetParameterIndex(funHandle,TY3Param.WriteParamName);
        Z3 := ALayer.GetParameterIndex(funHandle,TZ3Param.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle, TCommentParam.WriteParamName);

{        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          SpecifiedConcTemp);
        try
          begin
            ConcTempExpr := ConcTempOpt.Expr[funHandle];
          end;
        finally
          begin
            ConcTempOpt.Free;
          end;
        end;    }


        for ContourIndex := 0 to ALayer.NumObjects(funHandle,pieContourObject) -1 do
        begin
//          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);
//          Transient := AContour.GetBoolParameter(funHandle,TimeDepIndex);
          Transient := False;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try
{            AValue := AContour.
                GetFloatParameter(funHandle,SpecifiedConcTemp);
            SourceOverRide := OverridenParameters.OverriddenSurfaceSpecConcTemp
              [ContourIndex1,scConcentration];
            SourceExpr := ConcTempExpr;  }
//            AValue := 1;
//            SourceOverRide := True;
//            SourceExpr := '';

//            DummyValue := 0;;
//            DummyOverRide := True;

            ThisContourType := AContour.GetIntegerParameter(funHandle,ContourType);
            case ThisContourType of
              3: // closed contour
                begin
                  GetClosedContourPlanes(funHandle,AContour, ListOfPlanes,
                    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3);
                  Assert(ListOfPlanes.Count = 1);
                  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
                  begin
                    APlane := ListOfPlanes[PlaneIndex];
                    APlane.Value1 := 1;
                    APlane.PlaneArea := APlane.Area;
                  end;
                end;
            else
              begin
                raise EInvalidSource.Create('Error: Only '
                  + 'closed contours are allowed on ' + LayerName);
              end;
            end;

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, 3,
              ALayer, '', '', '', True, True, True, False,
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

procedure InitializeObservationsFunction(funHandle : ANE_PTR);
begin
  InitializeArgusSources(funHandle);
  InitializeSolidSources(funHandle);
  InitializePointSources(funHandle);
  InitializeLineSources(funHandle);
  InitializeVerticalSheetSources(funHandle);
  InitializeSlantedSheetSources(funHandle);
end;
{var
  VirtLayerIndex : integer;
  VirtNodeIndex : integer;
  RealLayerIndex : integer;
  ObservationLayerName : string;
  ObservationLayer : TLayerOptions;
  LayerList : TList;
  LayerHandle : ANE_PTR;
  AVirtNode : TVirtualNode;
  VNodeIndex : integer;
  RealMesh : TReal2DMesh;
  RealNode : TRealNode;
  Top, Bottom : double;
begin
  ObservationsPresent := False;
  frmSutra.VirtualMesh.InitializeIntNodeValue;

  LayerList := TList.Create;
  try
    LayerList.Capacity := frmSutra.VirtualMesh.RealMeshCount;
    for RealLayerIndex := 0 to frmSutra.VirtualMesh.RealMeshCount-1 do
    begin
      ObservationLayerName := T2DObservationLayer.WriteNewRoot
        + IntToStr(RealLayerIndex+1);
      LayerHandle := ANE_LayerGetHandleByName(funHandle, PChar(ObservationLayerName));
      ObservationLayer := TLayerOptions.Create(LayerHandle);
      LayerList.Add(ObservationLayer);
    end;

    for VirtNodeIndex := 0 to frmSutra.VirtualMesh.NodesPerLayer -1 do
    begin
      for VirtLayerIndex := 0 to frmSutra.VirtualMesh.VirtualMeshCount -1 do
      begin
        VNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex(VirtLayerIndex,VirtNodeIndex);
        AVirtNode := frmSutra.VirtualMesh.VirtualNodes[VNodeIndex];
        try
          Assert(not AVirtNode.Used);
        except
          ShowMessage(IntToStr(VirtNodeIndex) + ' ' + IntToStr(VirtLayerIndex) +
            ' ' + IntToStr(VNodeIndex));
          raise;
        end;
        for RealLayerIndex := 0 to frmSutra.VirtualMesh.RealMeshCount-1 do
        begin
          RealMesh := frmSutra.VirtualMesh.Real2DMeshes[RealLayerIndex];
          RealNode := RealMesh.Nodes[VirtNodeIndex];
          ObservationLayer := LayerList[RealLayerIndex];
          Top := ObservationLayer.RealValueAtXY(funHandle, RealNode.X, RealNode.Y,
            TTopElevaParam.ANE_ParamName);
          Bottom := ObservationLayer.RealValueAtXY(funHandle, RealNode.X, RealNode.Y,
            TBottomElevaParam.ANE_ParamName);
          if (Top >= AVirtNode.Z) and (AVirtNode.Z >= Bottom) then
          begin
            AVirtNode.Used := ObservationLayer.BooleanValueAtXY(funHandle, RealNode.X,
              RealNode.Y, TIsObservedParam.ANE_ParamName);
            if AVirtNode.Used then
            begin
              ObservationsPresent := True;
              break;
            end;
          end;
        end;
      end;
    end;
  finally
    for RealLayerIndex := 0 to LayerList.Count -1 do
    begin
      ObservationLayer := LayerList[RealLayerIndex];
      ObservationLayer.Free(funHandle);
    end;

    LayerList.Free;
  end;


end; }

procedure InitializeObservations (const refPtX : ANE_DOUBLE_PTR      ;
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

          // Initialize the values of the nodes to 0.
          InitializeObservationsFunction(funHandle);

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

procedure GetObservation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  NodeIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
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

          result := frmSutra.VirtualMesh.VirtualNodes[NodeIndex].Used;
        end;
      Except on Exception do
        begin
          Result := False;
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

procedure InitializeSimulationTimes (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
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
          frmSutra := TArgusForm.GetFormFromArgus(funHandle) as TfrmSutra;
          result := frmSutra.InitializeSimulationTimeSteps;
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
  ANE_INT32_PTR(reply)^ := result;
end;          

procedure GetSimulationTimeStep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  Time : ANE_DOUBLE;
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
begin
  Result := -1;
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
          Time :=  param1_ptr^;
          Result := frmSutra.TimeToTimeStep(Time);
        end;
      Except on Exception do
        begin
          Result := -1
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GetSimulationSimulationTime (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  TimeIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
begin
  Result := -1;
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
          TimeIndex :=  param1_ptr^;
          Assert(TimeIndex >= 0);
          Result := frmSutra.ElapsedSimulationTime(TimeIndex);
        end;
      Except on Exception do
        begin
          Result := -1
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

procedure GetObservationContourCount (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  Layer: T_ANE_MapsLayer;
  LayerHandle: ANE_PTR;
  LayerOptions: TLayerOptions;
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

          Layer := frmSutra.SutraLayerStructure.UnIndexedLayers.GetLayerByName(
            T2dUcodeHeadObservationLayer.ANE_LayerName);
          if (Layer <> nil) then
          begin
            LayerHandle := Layer.GetLayerHandle(funHandle);
            LayerOptions := TLayerOptions.Create(LayerHandle);
            try
              Result := Result + LayerOptions.NumObjects(funHandle,pieContourObject);
            finally
              LayerOptions.Free(funHandle);
            end;
          end;

          Layer := frmSutra.SutraLayerStructure.UnIndexedLayers.GetLayerByName(
            T2dUcodeConcentrationObservationLayer.ANE_LayerName);
          if (Layer <> nil) then
          begin
            LayerHandle := Layer.GetLayerHandle(funHandle);
            LayerOptions := TLayerOptions.Create(LayerHandle);
            try
              Result := Result + LayerOptions.NumObjects(funHandle,pieContourObject);
            finally
              LayerOptions.Free(funHandle);
            end;
          end;

          Layer := frmSutra.SutraLayerStructure.UnIndexedLayers.GetLayerByName(
            T2dUcodeFluxObservationLayer.ANE_LayerName);
          if (Layer <> nil) then
          begin
            LayerHandle := Layer.GetLayerHandle(funHandle);
            LayerOptions := TLayerOptions.Create(LayerHandle);
            try
              Result := Result + LayerOptions.NumObjects(funHandle,pieContourObject);
            finally
              LayerOptions.Free(funHandle);
            end;
          end;

          Layer := frmSutra.SutraLayerStructure.UnIndexedLayers.GetLayerByName(
            T2dUcodeSoluteFluxObservationLayer.ANE_LayerName);
          if (Layer <> nil) then
          begin
            LayerHandle := Layer.GetLayerHandle(funHandle);
            LayerOptions := TLayerOptions.Create(LayerHandle);
            try
              Result := Result + LayerOptions.NumObjects(funHandle,pieContourObject);
            finally
              LayerOptions.Free(funHandle);
            end;
          end;

          Layer := frmSutra.SutraLayerStructure.UnIndexedLayers.GetLayerByName(
            T2dUcodeSaturationObservationLayer.ANE_LayerName);
          if (Layer <> nil) then
          begin
            LayerHandle := Layer.GetLayerHandle(funHandle);
            LayerOptions := TLayerOptions.Create(LayerHandle);
            try
              Result := Result + LayerOptions.NumObjects(funHandle,pieContourObject);
            finally
              LayerOptions.Free(funHandle);
            end;
          end;
        end;
      Except on Exception do
        begin
          Result := -1
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_INT32_PTR(reply)^ := result;
end;



end.
