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
  SolidGeom, VirtualMeshUnit, SLSourcesOfFluid, frmSutraUnit,
  SLGeneralParameters, doublePolyhedronUnit, ANE_LayerUnit, ArgusFormUnit,
  ParamArrayUnit, OverriddenArrayUnit, SLSutraMesh;

procedure InitializeSurfaceSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
  TotFluidSource, SpecificFluidSource, ConcTemp, TimeDep,
    FollowMeshParamIndex, TopElevParamIndex, EndTopParamIndex,
    BotElevParamIndex, EndBotParamIndex, SourceChoiceParamIndex, ContourType,
    X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, CommentIndex  : SmallInt;
  ThisContourType : Integer;
  ListOfPlanes : TList;
  ContourIndex, ContourIndex1 , PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  Area : extended;
  SourceChoice : SmallInt;
  AValue : extended;
  APlaneList : TXYZPlaneList;
  IntersectionPlane : TXYZPlane;
  ANode : TVirtualNode;
  IntersectPlaneIndex : integer;
  ConcentrationOrTemp : double;
  TotSourceExpr, SpecSourceExpr, SourceExpr, ConcExpr : string;
  SourceOverRide, ConcOverRide : boolean;
  TotSourceOpt, SpecSourceOpt, ConcTempOpt : TParameterOptions;
  Comment : string;
begin
  // loop over sources of fluid layers.
  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.adeBoundLayerCount.text) do
  begin
    // get the layer
    LayerName := TSurfaceFluidSourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := ANE_LayerGetHandleByName(funHandle,
      PChar(LayerName));
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
          (funHandle, TTopElevaParam.WriteParamName);
        EndTopParamIndex := ALayer.GetParameterIndex
          (funHandle, TEndTopElevaParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TBottomElevaParam.WriteParamName);
        EndBotParamIndex := ALayer.GetParameterIndex
          (funHandle, TEndBottomElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSourceChoice.WriteParamName);
        ContourType := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle, TFollowMeshParam.WriteParamName);

        X1 := ALayer.GetParameterIndex(funHandle, TX1Param.WriteParamName);
        Y1 := ALayer.GetParameterIndex(funHandle, TY1Param.WriteParamName);
        Z1 := ALayer.GetParameterIndex(funHandle, TZ1Param.WriteParamName);
        X2 := ALayer.GetParameterIndex(funHandle, TX2Param.WriteParamName);
        Y2 := ALayer.GetParameterIndex(funHandle, TY2Param.WriteParamName);
        Z2 := ALayer.GetParameterIndex(funHandle, TZ2Param.WriteParamName);
        X3 := ALayer.GetParameterIndex(funHandle, TX3Param.WriteParamName);
        Y3 := ALayer.GetParameterIndex(funHandle, TY3Param.WriteParamName);
        Z3 := ALayer.GetParameterIndex(funHandle, TZ3Param.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle, TCommentParam.WriteParamName);

        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotFluidSource);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificFluidSource);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTemp);
        try
          begin
            TotSourceExpr :=  TotSourceOpt.Expr[funHandle];
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
            ConcExpr  := ConcTempOpt.Expr[funHandle];
          end;
        finally
          begin
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            ConcTempOpt.Free;
          end;
        end;


        for ContourIndex := 0 to ALayer.NumObjects(funHandle, pieContourObject) -1 do
        begin
          Inc(ContourIndex1);
          // get a contour
          AContour := TContourObjectOptions.Create
            (funHandle,LayerHandle,ContourIndex);

          Comment := AContour.GetStringParameter(funHandle,CommentIndex);

          SourceChoice :=
            AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
          case SourceChoice of
            1: // total source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, TotFluidSource);
                SourceOverRide := OverridenParameters.OverriddenSurfaceFluidSource
                  [ContourIndex1,fspTotalSource];
                SourceExpr := TotSourceExpr;
              end;
            2: // specific source
              begin
                AValue := AContour.
                    GetFloatParameter(funHandle, SpecificFluidSource);
                SourceOverRide := OverridenParameters.OverriddenSurfaceFluidSource
                  [ContourIndex1,fspSpecificSource];
                SourceExpr := SpecSourceExpr;
              end;
            else
              begin
                AValue := 0;
                SourceOverRide := False;
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
              end;
          end;

          // get the segments in the contour.
          ListOfPlanes := TList.Create;
          try

            ConcentrationOrTemp := AContour.GetFloatParameter(funHandle, ConcTemp);
            ConcOverRide := OverridenParameters.OverriddenSurfaceFluidSource
              [ContourIndex1,fspConcentration];

            ThisContourType := AContour.GetIntegerParameter(funHandle, ContourType);
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
                raise EInvalidSource.Create('Error: Only open and '
                  + 'closed contours are allowed on ' + LayerName);
              end;
            end;

            AssignNodeValuesFromPlanes(funHandle, ListOfPlanes, SourceChoice,
              ALayer, SourceExpr, ConcExpr, SourceOverRide, ConcOverRide, True,
              Comment);

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
  QinParamIndex, UinParamIndex, IsSourceIndex : SmallInt;
  LayerOptions : TLayerOptions;
  LayerHandle : ANE_PTR;
  ProjectOptions : TProjectOptions;
  Value1, Value2 : double;
  N : String;
  MultipleUnits : boolean;
  LayerName, parameterName : string;
  Comment : string;
begin
  VirtualLayerIndex := 0;
  ProjectOptions := TProjectOptions.Create;
  try

    for LayerIndex := 0 to StrToInt(frmSutra.adeVertDisc.text) {-1} do
    begin

      if LayerIndex > 0 then
      begin
        VirtualLayerIndex := VirtualLayerIndex
          + frmSutra.VirtualMesh.Discretization[LayerIndex-1]
      end;
      AMesh := frmSutra.VirtualMesh.Real2DMeshes[LayerIndex];

      N := frmSutra.GetN(MultipleUnits);

      LayerName := TSutraMeshLayer.WriteNewRoot;
      if (N = '0') then
      begin
        LayerName := LayerName + IntToStr(LayerIndex+1);
      end;

      LayerHandle := ProjectOptions.GetLayerByName
        (funHandle,LayerName);
      LayerOptions := TLayerOptions.Create(LayerHandle);
      try
        parameterName := TQINParam.WriteParamName;
        if (N <> '0') and MultipleUnits then
        begin
          parameterName := parameterName + IntToStr(LayerIndex + 1);
        end;
        QinParamIndex := LayerOptions.GetParameterIndex(funHandle, parameterName);
        Assert(QinParamIndex<>-1);

        parameterName := TUINParam.WriteParamName;
        if (N <> '0') and MultipleUnits then
        begin
          parameterName := parameterName + IntToStr(LayerIndex + 1);
        end;
        UinParamIndex := LayerOptions.GetParameterIndex(funHandle, parameterName);
        Assert(UinParamIndex<>-1);

        parameterName := TIsFluidSource.WriteParamName;
        if (N <> '0') and MultipleUnits then
        begin
          parameterName := parameterName + IntToStr(LayerIndex + 1);
        end;
        IsSourceIndex := LayerOptions.GetParameterIndex(funHandle, parameterName);
        Assert(IsSourceIndex<>-1);
      finally
        LayerOptions.Free(funHandle);
      end;

      for NodeIndex := 0 to AMesh.NodeCount -1 do
      begin
        Comment := Format('Layer: %d. Node: %d', [LayerIndex+1,NodeIndex+1]);
        ARealNode := AMesh.Nodes[NodeIndex];
        IsBoundary := ARealNode.BooleanParameterValue(funHandle, IsSourceIndex);
        if IsBoundary then
        begin
          VirtualNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex
            (VirtualLayerIndex,NodeIndex);
          AVirtualNode := frmSutra.VirtualMesh.VirtualNodes[VirtualNodeIndex];
          Value1 := ARealNode.RealParameterValue(funHandle, QinParamIndex);
          Value2 := ARealNode.RealParameterValue(funHandle, UinParamIndex);

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

    end;
  finally
    ProjectOptions.Free;
  end;
end;


procedure InitializeUsualSources(funHandle : ANE_PTR);
var
  LayerIndex : integer;
  LayerName : string;
  LayerHandle : ANE_PTR;
  AContour : TContourObjectOptions;
  ALayer : TLayerOptions;
  ContourIndex, ContourIndex1 : ANE_INT32;
  TotFluidSourceParamIndex, SpecificFluidSourceParamIndex, ConcTempParamIndex,
    TimeDepParamIndex, TopElevParamIndex, BotElevParamIndex,
    SourceChoiceParamIndex, ContourTypeParamIndex,
    FollowMeshParamIndex, CommentIndex : SmallInt;
  SourceChoice : SmallInt;
  ListOfSegments : TList;
  SegmentIndex : integer;
  ThisContourType : integer;
  AValue : extended;
  ConcentrationOrTemp : double;
  SourceOverridden, ConcOverridden : boolean;
  TotSourceExpr, SpecSourceExpr, ConcExpr, SourceExpr : string;
  TotSourceOpt, SpecSourceOpt, ConcTempOpt : TParameterOptions;
  Comment : string;
  ContourList : TObjectList;
begin
  // loop over sources of fluit layers.
  ContourIndex1 := -1;
  for LayerIndex := 1 to StrToInt(frmSutra.adeBoundLayerCount.text) do
  begin
    // get the layer
    LayerName := TVolFluidSourcesLayer.WriteNewRoot
      + IntToStr(LayerIndex);
    LayerHandle := ANE_LayerGetHandleByName(funHandle,
      PChar(LayerName));
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
        TopElevParamIndex := ALayer.GetParameterIndex(funHandle, TTopElevaParam.WriteParamName);
        BotElevParamIndex := ALayer.GetParameterIndex
          (funHandle, TBottomElevaParam.WriteParamName);
        SourceChoiceParamIndex := ALayer.GetParameterIndex
          (funHandle, TSourceChoice.WriteParamName);
        ContourTypeParamIndex := ALayer.GetParameterIndex
          (funHandle, TContourType.WriteParamName);
        FollowMeshParamIndex := ALayer.GetParameterIndex
          (funHandle, TFollowMeshParam.WriteParamName);
        CommentIndex := ALayer.GetParameterIndex(funHandle, TCommentParam.WriteParamName);

//        ShowMessage('B');
        TotSourceOpt := TParameterOptions.Create(LayerHandle,
          TotFluidSourceParamIndex);
        SpecSourceOpt := TParameterOptions.Create(LayerHandle,
          SpecificFluidSourceParamIndex);
        ConcTempOpt := TParameterOptions.Create(LayerHandle,
          ConcTempParamIndex);
//        ShowMessage('B1 ' + IntToStr(TotFluidSourceParamIndex) + ' ' +
//          IntToStr(SpecificFluidSourceParamIndex) + ' ' +
//          IntToStr(ConcTempParamIndex));
        try
          begin
            TotSourceExpr := TotSourceOpt.Expr[funHandle];
//        ShowMessage('B2');
            SpecSourceExpr := SpecSourceOpt.Expr[funHandle];
//        ShowMessage('B3');
            ConcExpr  := ConcTempOpt.Expr[funHandle];
//        ShowMessage('B4');
          end;
        finally
          begin
//        ShowMessage('B5');
            TotSourceOpt.Free;
            SpecSourceOpt.Free;
            ConcTempOpt.Free;
//        ShowMessage('B6');
          end;
        end;

//        ShowMessage('C');
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

          for ContourIndex := 0 to ALayer.NumObjects(funHandle, pieContourObject) -1 do
          begin
            Inc(ContourIndex1);
            // get a contour
            AContour := ContourList[ContourIndex] as TContourObjectOptions;

            Comment := AContour.GetStringParameter(funHandle,CommentIndex);

            // get the segments in the contour.
            ListOfSegments := TList.Create;
            try

  //        ShowMessage('D');
              ThisContourType :=  AContour.GetIntegerParameter(funHandle, ContourTypeParamIndex);

              GetCountourLocations(funHandle, ThisContourType, TopElevParamIndex,
                BotElevParamIndex, ContourTypeParamIndex,
                ListOfSegments, AContour, FollowMeshParamIndex);
  //        ShowMessage('E');

              // Assign values to nodes
              SourceChoice :=
                AContour.GetIntegerParameter(funHandle, SourceChoiceParamIndex);
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
                    AValue := 0;
                    SourceOverridden := False;
                    SourceExpr := '';
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
                  end;
              end;

              ConcentrationOrTemp := AContour.GetFloatParameter(funHandle, ConcTempParamIndex);
              ConcOverridden := OverridenParameters.OverriddenFluidSource
                [ContourIndex1,fspConcentration];

  //        ShowMessage('F');
              AssignNodeValues(funHandle, ThisContourType, ListOfSegments, SourceChoice,
                FollowMeshParamIndex, AValue, ConcentrationOrTemp,
                LayerName, AContour, ALayer,
                SourceExpr, ConcExpr, SourceOverridden, ConcOverridden, True,
                Comment, ContourList);


            finally
              for SegmentIndex := 0 to ListOfSegments.Count -1 do
              begin
                TSegmentObject(ListOfSegments[SegmentIndex]).Free;
              end;


              ListOfSegments.Free;
//              AContour.Free;
            end;

          end;

        finally
          ContourList.Free;
        end;


      end;
    finally
      begin
        ALayer.Free(funHandle);
      end;
    end;

  end;
end;

procedure InitializeFluidSources(funHandle : ANE_PTR ) ;
begin
  // Initialize the values of the nodes to 0.
  frmSutra.VirtualMesh.InitializeNodeValues;

//  ShowMessage('2');
  InitializeUsualSources(funHandle);

//  ShowMessage('3');
  InitializeSurfaceSources(funHandle);

//  ShowMessage('4');
  InitializeArgusSources(funHandle, True);
//  ShowMessage('5');
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
