unit VirtMeshUtilFunctions;

interface

uses SysUtils, Classes, contnrs, AnePIE, OptionsUnit, SolidGeom

          {$IFDEF DEBUG}
          , Dialogs, DebugUnit
          {$ENDIF}
;

Type
  EInvalidSource = Class(Exception);

type
  TValuePlane = class(TXYZPlane)
    PlaneArea : extended;
    Value1 : extended;
    Value2 : extended;
    Value3 : extended;
  end;


procedure AssignNodeValues(ModelHandle: ANE_PTR; ThisContourType: integer;
  ListOfSegments : TList;
  SourceChoice, FollowMeshParamIndex : SmallInt;
  AValue, SubsidiaryValue : extended;
  {$IFDEF OldSutraIce} ConductanceValue : extended; {$ENDIF}
  LayerName : string;
  AContour : TContourObjectOptions; ALayer : TLayerOptions;
  SourceExpr, ConcExpr, TransientExpr : string;
  {$IFDEF OldSutraIce} CondExpr : string; {$ENDIF}
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  {$IFDEF OldSutraIce} ConductanceOverridden : boolean; {$ENDIF}
  AddValues : boolean; const Comment : string; const ContourList : TObjectList;
  const SourceTransient, SpecifiedSource : boolean; const ErrorStart: string);

procedure AssignNodeValuesFromPlanes(ModelHandle: ANE_PTR; ListOfPlanes : TList;
  SourceChoice : SmallInt; ALayer : TLayerOptions;
  SourceExpr, ConcExpr, TransientExpr : string;
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  AddValues : boolean; const Comment : string; const SourceTransient, SpecifiedSource : boolean);

procedure GetClosedContourPlanes(ModelHandle: ANE_PTR; AContour : TContourObjectOptions;
  ListOfPlanes : TList; X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3  : SmallInt);

procedure GetCountourLocations(ModelHandle: ANE_PTR; var ThisContourType: integer;
  TopElev, BotElev, ContourType : Integer;
  ListOfSegments : TList; AContour : TContourObjectOptions;
  FollowMeshParamIndex : SmallInt);

Procedure GetOpenContourPlanes(ModelHandle: ANE_PTR; AContour: TContourObjectOptions;
  TopElevParamIndex, EndTopParamIndex, BotElevParamIndex, EndBotParamIndex,
  SourceChoice, FollowMeshParamIndex : SmallInt; ListOfPlanes : TList;
  var Area : extended );
  
implementation

uses ANECB, doublePolyhedronUnit, VirtualMeshUnit,
  frmSutraUnit, SLGeneralParameters, VirtualMeshFunctions, ZFunction;

procedure AssignNodeValues(ModelHandle: ANE_PTR; ThisContourType: integer;
  ListOfSegments : TList;
  SourceChoice, FollowMeshParamIndex : SmallInt;
  AValue, SubsidiaryValue : extended;
  {$IFDEF OldSutraIce} ConductanceValue : extended; {$ENDIF}
  LayerName : string;
  AContour : TContourObjectOptions; ALayer : TLayerOptions;
  SourceExpr, ConcExpr, TransientExpr : string;
  {$IFDEF OldSutraIce} CondExpr : string; {$ENDIF}
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  {$IFDEF OldSutraIce} ConductanceOverridden : boolean; {$ENDIF}
  AddValues : boolean; const Comment : string; const ContourList : TObjectList;
  const SourceTransient, SpecifiedSource : boolean; const ErrorStart: string);
var
  oldValue : double;
  SegLength, TotLength : extended;
  Volumn, TotVolume, Area : extended;
  ASegment : TSegmentObject;
  q : TPointd;
  NodeIndex, SegmentIndex, InnerSegmentIndex : integer;
  ANode, AnotherNode : TVirtualNode;
  InPolyhedronResult : TInPolyhedronResult;
  IntersectingSegments: TSegmentList;
  AnIntersectingSegment : TSegmentObject;
  NodeX, NodeY, NodeZ : ANE_DOUBLE;
  Expression : string;
  TopElevValue, BotElevValue : extended;
  FollowMesh : boolean;
  NodesPerLayer : integer;
  TempList, SortedList : TList;
  Min, Max : double;
  UsedNodes : TList;
  APolyhedron : TPolyhedron;
  LocalContours : TList;
  ContourIndex : integer;
  AnotherContour : TContourObjectOptions;
  XPoint, YPoint : ANE_DOUBLE;
  InsideAnother : boolean;
  Location : double;
  BoundaryFound: boolean;
  ErrorMessage: string;
  Transient: boolean;
  procedure GetMinMax(Dimension : integer);
  var
    SegmentIndex : integer;
  begin
    Assert((Dimension = X) or (Dimension = Y) or (Dimension = Z));
    if ListOfSegments.Count > 0 then
    begin
      ASegment := ListOfSegments[0];
      Min := ASegment.StartLoc[Dimension];
      Max := ASegment.StartLoc[Dimension];
      for SegmentIndex := 0 to ListOfSegments.Count -1 do
      begin
        ASegment := ListOfSegments[SegmentIndex];
        if ASegment.StartLoc[Dimension] < Min then
        begin
          Min := ASegment.StartLoc[Dimension]
        end;
        if ASegment.StartLoc[Dimension] > Max then
        begin
          Max := ASegment.StartLoc[Dimension]
        end;
        if ASegment.EndLoc[Dimension] < Min then
        begin
          Min := ASegment.EndLoc[Dimension]
        end;
        if ASegment.EndLoc[Dimension] > Max then
        begin
          Max := ASegment.EndLoc[Dimension]
        end;
      end;
    end;
  end;
begin

  UsedNodes := TList.Create;
  LocalContours := TList.Create;
  try
    if ThisContourType = 3 then
    begin
      for ContourIndex := 0 to ContourList.Count -1 do
      begin
        AnotherContour := ContourList[ContourIndex] as TContourObjectOptions;
        if (AnotherContour <> AContour)
          and (AnotherContour.ContourType(ModelHandle) = ctClosed) then
        begin
          AnotherContour.GetNthNodeLocation(ModelHandle, XPoint, YPoint, 0);
          if AContour.IsInside(ModelHandle, XPoint, YPoint) then
          begin
            LocalContours.Add(AnotherContour);
          end;
        end;
      end;
    end;
    Volumn := 0;
    TotVolume := 0;
    TotLength := 0;
    if FollowMeshParamIndex < 0 then
    begin
      FollowMesh := False;
    end
    else
    begin
      FollowMesh := AContour.GetBoolParameter(ModelHandle, FollowMeshParamIndex);
    end;

    NodesPerLayer := frmSutra.VirtualMesh.Real2DMeshes[0].NodeCount;

    if ThisContourType = 1 then
    begin
      ASegment := ListOfSegments[0];
      q[X] := ASegment.StartLoc[X];
      q[Y] := ASegment.StartLoc[Y];
      q[Z] := ASegment.StartLoc[Z];
    end;

    if (ThisContourType = 1) and FollowMesh then
    begin
      for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
      begin
        ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
        CurrentVertex := ANode;
        ANode.Value3 := 0;
        ANode.Value4 := 0;
        AnotherNode := frmSutra.VirtualMesh.VirtualNodes
          [ANode.NodeIndex mod NodesPerLayer];
        q[Z] := AnotherNode.Z;
        InPolyhedronResult := AnotherNode.PolyHedron.InPolyHedron(q);
        AnotherNode.FreePolyHedron;
        if InPolyhedronResult <> ipExterior then
        begin
          if ANode.NodeIndex >= NodesPerLayer then
          begin
            AnotherNode := frmSutra.VirtualMesh.VirtualNodes
              [ANode.NodeIndex-NodesPerLayer];
            if (ASegment.StartLoc[Z] > (ANode.Z + AnotherNode.Z)/2) then
            begin
              InPolyhedronResult := ipExterior;
            end;
            if (ipExterior <> ipExterior) and
              (ANode.NodeIndex + NodesPerLayer < frmSutra.VirtualMesh.NodeCount )
            then
            begin
              AnotherNode := frmSutra.VirtualMesh.VirtualNodes
                [ANode.NodeIndex+NodesPerLayer];
              if (ASegment.StartLoc[Z] <= (ANode.Z + AnotherNode.Z)/2) then
              begin
                InPolyhedronResult := ipExterior;
              end;
            end;
          end;
        end;

        case InPolyhedronResult of
          ipVertex, ipEdge, ipFace, ipInterior:
            begin
              if not SourceOverRide then
              begin
                AValue := ALayer.RealValueAtXY(ModelHandle,
                  ANode.X, ANode.Y, SourceExpr);
              end;
              if not ConcOverRide then
              begin
                SubsidiaryValue := ALayer.RealValueAtXY(ModelHandle,
                  ANode.X, ANode.Y, ConcExpr);
              end;
              {$IFDEF OldSutraIce}
              if not ConductanceOverridden then
              begin
                ConductanceValue := ALayer.RealValueAtXY(ModelHandle,
                  ANode.X, ANode.Y, CondExpr);
              end;
              {$ENDIF}

              if TransientOverRide then
              begin
                Transient := SourceTransient;
              end
              else if TransientExpr = '0' then
              begin
                Transient := False;
              end
              else if TransientExpr = '1' then
              begin
                Transient := True;
              end
              else
              begin
                Transient := ALayer.BooleanValueAtXY(ModelHandle, ANode.X, ANode.Y,TransientExpr);
              end;

              {$IFDEF OldSutraIce}
              ANode.Conductance := ConductanceValue;
              {$ENDIF}

              case SourceChoice of
                1: // total source
                  begin
                    if ((AValue > 0) and (ANode.Value1 < 0)) or
                       ((AValue < 0) and (ANode.Value1 > 0))
                    then
                    begin
                      // to do: warning message here.
                      {raise EInvalidSource.Create
                        ('Error: Two or more sources of '
                         + 'opposite sign at Node '
                         + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString); }
                    end;
//                    else
                    begin
                      if Transient then
                      begin
                        ANode.Transient := True;
                      end;
                      oldValue := ANode.Value1;
                      if AddValues then
                      begin
{                        if SpecifiedSource then
                        begin
                          ANode.Value5 := ANode.Value5 + AValue;
                        end;  }
                        ANode.Value1 := ANode.Value1 + AValue;
                        ANode.Comment := ANode.Comment + ' ' + Comment;
                      end
                      else
                      begin
                        ANode.Value1 := AValue;
                        ANode.Comment := Comment;
                      end;
                      if AddValues and (AValue < 0) then
                      begin
                        SubsidiaryValue := 0;
                      end;
                      if AddValues then
                      begin
{                        if SpecifiedSource then
                        begin
                          ANode.Value4 := ANode.Value4 + AValue*SubsidiaryValue;
                        end
                        else
                        begin }
                        ANode.Value2 := ANode.Value2 + {AValue*}SubsidiaryValue;
//                        end;
  //                      ANode.Used := True;
                        if not ANode.Used then
                        begin
  //                        ANode.Value2 := SubsidiaryValue;
                          ANode.Used := True;
                        end;
                        UsedNodes.Add(ANode);
                      end
                      else
                      begin
                        if not ANode.Used then
                        begin
                          ANode.Value2 := SubsidiaryValue;
                          ANode.Used := True;
                          UsedNodes.Add(ANode);
                        end
                        else if ANode.Value2 <> SubsidiaryValue then
                        begin
                          raise EInvalidSource.Create
                            ('Error: Two or more different concentrations or '
                             + 'temparatures assigned to source at Node '
                             + IntToStr(ANode.NodeIndex +1)
                             + ' at ' + ANode.LocationString);
                        end;
                      end;
                      break;
                    end;
                  end;
                2:  // specific source
                  begin
                    raise EInvalidSource.Create
                      ('Error: specific source assigned to '
                       + 'point source at Node '
                       + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString);
                  end;
                3:  // prescribed source
                  begin
                    if ANode.Used and (ANode.Value1 <> AValue) then
                    begin
                      raise EInvalidSource.Create
                        ('Error: Two or more different prescribed '
                         + 'values assigned to source at Node '
                         + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString);
                    end;
                    ANode.Value1 := AValue;
                    ANode.Comment := Comment;
                    if Transient then
                    begin
                      ANode.Transient := True;
                    end;
                    if not ANode.Used then
                    begin
                      ANode.Value2 := SubsidiaryValue;
                      ANode.Used := True;
                      UsedNodes.Add(ANode);
                    end
                    else if ANode.Value2 <> SubsidiaryValue then
                    begin
                    raise EInvalidSource.Create
                      ('Error: Two or more different concentrations or '
                       + 'temparatures assigned to source at Node '
                       + IntToStr(ANode.NodeIndex +1));
                    end;
                  end;
                else
                  begin
                    raise EInvalidSource.Create
                      ('Error: ' + LayerName + '.'
                       + TSourceChoice.ANE_ParamName
                       + ' parameter incorrectly assigned'
                       + ' to point source '
                       + ' at Node '
                       + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString
                       + '. Check that you have entered a value for '
                       + TCustomTotalSourceParam.ANE_ParamName
                       + ' or '
                       + TCustomSpecificSourceParam.ANE_ParamName
                       + '.');
                  end;
              end;
            end;
          ipExterior:
            begin
              // do nothing for exterior points
            end;
        end;
      end;
    end
    else // if (ThisContourType = 1) and FollowMesh then
    begin
      TempList := TList.Create;
      SortedList := TList.Create;
      try

        if (ThisContourType = 3) and FollowMesh then
        begin
          GetMinMax(X);
          TempList.Clear;
          for NodeIndex := 0 to frmSutra.VirtualMesh.SortedNodeList.Count -1 do
          begin
            ANode := frmSutra.VirtualMesh.SortedNodeList[NodeIndex];
            Location := ANode.TopRealX;
            if (Location <= Max) and (Location >= Min) then
            begin
              TempList.Add(ANode);
            end;
          end;

          GetMinMax(Y);
          SortedList.Clear;
          for NodeIndex := 0 to TempList.Count -1 do
          begin
            ANode := TempList[NodeIndex];
            Location := ANode.TopRealY;
            if (Location <= Max) and (Location >= Min) then
            begin
              SortedList.Add(ANode);
            end;
          end;

        end
        else
        begin

          GetMinMax(X);
          GetNodesInRange(frmSutra.VirtualMesh.SortedNodeList, TempList,
            Min, Max, X);

          TempList.Sort(SortNodesYMin);
          GetMinMax(Y);
          GetNodesInRange(TempList, SortedList,
            Min, Max, Y);
        end;


  {    // Z values may not have been set
       TempList.Sort(SortNodesZMin);
        GetMinMax(Z);
        GetNodesInRange(TempList, SortedList,
          Min, Max, Z);    }

        BoundaryFound := False;
        for NodeIndex := 0 to SortedList.Count -1 do
        begin
          ANode := SortedList[NodeIndex];
          CurrentVertex := ANode;
          ANode.Value3 := 0;
          ANode.Value4 := 0;
          Case ThisContourType of
            1: // point contour
              begin
                InPolyhedronResult := ANode.PolyHedron.InPolyHedron(q);
                ANode.FreePolyHedron;
                case InPolyhedronResult of
                  ipVertex, ipEdge, ipFace, ipInterior:
                    begin
                      BoundaryFound := True;
                      if not SourceOverRide then
                      begin
                        AValue := ALayer.RealValueAtXY(ModelHandle, ANode.X, ANode.Y,SourceExpr);
                      end;
                      if not ConcOverRide then
                      begin
                        SubsidiaryValue := ALayer.RealValueAtXY(ModelHandle, ANode.X, ANode.Y,ConcExpr);
                      end;
                      {$IFDEF OldSutraIce}
                      if not ConductanceOverridden then
                      begin
                        ConductanceValue := ALayer.RealValueAtXY(ModelHandle,
                          ANode.X, ANode.Y, CondExpr);
                      end;
                      {$ENDIF}
                      if TransientOverRide then
                      begin
                        Transient := SourceTransient;
                      end
                      else if TransientExpr = '0' then
                      begin
                        Transient := False;
                      end
                      else if TransientExpr = '1' then
                      begin
                        Transient := True;
                      end
                      else
                      begin
                        Transient := ALayer.BooleanValueAtXY(ModelHandle, ANode.X, ANode.Y,TransientExpr);
                      end;

                      {$IFDEF OldSutraIce}
                      ANode.Conductance := ConductanceValue;
                      {$ENDIF}
                      case SourceChoice of
                        1: // total source
                          begin
                            if ((AValue > 0) and (ANode.Value1 < 0)) or
                               ((AValue < 0) and (ANode.Value1 > 0))
                            then
                            begin
                              // to do; show error message.
{                              raise EInvalidSource.Create
                                ('Error: Two or more sources of '
                                 + 'opposite sign at Node '
                                 + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString); }
                            end;
//                            else
                            begin
                              if Transient then
                              begin
                                ANode.Transient := True;
                              end;
                              OldValue := ANode.Value1;
                              if AddValues then
                              begin
                                ANode.Value1 := ANode.Value1 + AValue;
                                ANode.Comment := ANode.Comment + ' ' + Comment;
                              end
                              else
                              begin
                                ANode.Value1 := AValue;
                                ANode.Comment := Comment;
                              end;
                              if AddValues and (AValue < 0) then
                              begin
                                SubsidiaryValue := 0;
                              end;
                              if AddValues then
                              begin
                                ANode.Value4 := ANode.Value4 + AValue*SubsidiaryValue;
                                ANode.Value2 := ANode.Value2 + {AValue*}SubsidiaryValue;
  //                              ANode.Used := True;

                                if not ANode.Used then
                                begin
  //                                ANode.Value2 := SubsidiaryValue;
                                  ANode.Used := True;
                                end;
                                UsedNodes.Add(ANode);
                              end
                              else
                              begin
                                if not ANode.Used then
                                begin
                                  ANode.Value2 := SubsidiaryValue;
                                  ANode.Used := True;
                                  UsedNodes.Add(ANode);
                                end
                              else if ANode.Value2 <> SubsidiaryValue then
                              begin
                                // to do: warning message here.
                                raise EInvalidSource.Create
                                  ('Error: Two or more different concentrations or '
                                   + 'temparatures assigned to source at Node '
                                   + IntToStr(ANode.NodeIndex +1)
                                 + ' at ' + ANode.LocationString);
                                end;
                              end;
                              break;
                            end;
                          end;
                        2:  // specific source
                          begin
                            raise EInvalidSource.Create
                              ('Error: specific source assigned to '
                               + 'point source at Node '
                               + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString);
                          end;
                        3:  // prescribed source
                          begin
                            if ANode.Used and (ANode.Value1 <> AValue) then
                            begin
                              raise EInvalidSource.Create
                                ('Error: Two or more different prescribed '
                                 + 'values assigned to source at Node '
                                 + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString);
                            end;
                            ANode.Value1 := AValue;
                            ANode.Comment := Comment;
                            if Transient then
                            begin
                              ANode.Transient := True;
                            end;
                            if not ANode.Used then
                            begin
                              ANode.Value2 := SubsidiaryValue;
                              ANode.Used := True;
                              UsedNodes.Add(ANode);
                            end
                            else if ANode.Value2 <> SubsidiaryValue then
                            begin
                            raise EInvalidSource.Create
                              ('Error: Two or more different concentrations or '
                               + 'temparatures assigned to source at Node '
                               + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString);
                            end;
                          end;
                        else
                          begin
                            raise EInvalidSource.Create
                              ('Error: ' + LayerName + '.'
                               + TSourceChoice.ANE_ParamName
                               + ' parameter incorrectly assigned'
                               + ' to point source '
                               + ' at Node '
                               + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString
                               + '. Check that you have entered a value for '
                               + TCustomTotalSourceParam.ANE_ParamName
                               + ' or '
                               + TCustomSpecificSourceParam.ANE_ParamName
                               + '.');
                          end;
                      end;
                    end;
                  ipExterior:
                    begin
                      // do nothing for exterior points
                    end;
                end;
              end;
            2: // open contour
              begin
                for SegmentIndex := 0 to ListOfSegments.Count -1 do
                begin
                  ASegment := ListOfSegments[SegmentIndex];
                  IntersectingSegments := ANode.PolyHedron.
                    SegmentIntersection(ASegment);
                  ANode.FreePolyHedron;
                  try
                    if IntersectingSegments.Count > 0 then
                    begin
                      BoundaryFound := True;
                      if not SourceOverRide then
                      begin
                        AValue := ALayer.RealValueAtXY(ModelHandle,
                          ANode.X, ANode.Y,SourceExpr);
                      end;
                      if not ConcOverRide then
                      begin
                        SubsidiaryValue := ALayer.RealValueAtXY(ModelHandle,
                          ANode.X, ANode.Y,ConcExpr);
                      end;
                      {$IFDEF OldSutraIce}
                      if not ConductanceOverridden then
                      begin
                        ConductanceValue := ALayer.RealValueAtXY(ModelHandle,
                          ANode.X, ANode.Y, CondExpr);
                      end;
                      {$ENDIF}
                      if TransientOverRide then
                      begin
                        Transient := SourceTransient;
                      end
                      else if TransientExpr = '0' then
                      begin
                        Transient := False;
                      end
                      else if TransientExpr = '1' then
                      begin
                        Transient := True;
                      end
                      else
                      begin
                        Transient := ALayer.BooleanValueAtXY(ModelHandle, ANode.X, ANode.Y,TransientExpr);
                      end;
                      {$IFDEF OldSutraIce}
                      ANode.Conductance := ConductanceValue;
                      {$ENDIF}
                      case SourceChoice of
                        1: // total source
                          begin
                            for InnerSegmentIndex := 0 to
                              IntersectingSegments.Count -1 do
                            begin
                              AnIntersectingSegment :=
                                IntersectingSegments[InnerSegmentIndex];
                              SegLength := AnIntersectingSegment.Length;
                              TotLength := TotLength + SegLength;
                              oldValue := ANode.Value3;
                              if Transient then
                              begin
                                ANode.Transient := True;
                              end;
                              ANode.Value3 := ANode.Value3
                                + SegLength * AValue;
                              ANode.Comment := ANode.Comment + ' ' + Comment;

                              if AddValues and (AValue < 0) then
                              begin
                                SubsidiaryValue := 0;
                              end;

                              if AddValues then
                              begin
                                ANode.Value4 := ANode.Value4 + SegLength*AValue*SubsidiaryValue;
                                ANode.Value2 := ANode.Value2 + {SegLength*AValue*}SubsidiaryValue;
  //                              ANode.Used := True;

                                if not ANode.Used then
                                begin
  //                                ANode.Value2 := SubsidiaryValue;
                                  ANode.Used := True;
                                end;
                                UsedNodes.Add(ANode);
                              end
                              else
                              begin
                                if not ANode.Used then
                                begin
                                  ANode.Value2 := SubsidiaryValue;
                                  ANode.Used := True;
                                  UsedNodes.Add(ANode);
                                end
                                else if ANode.Value2 <> SubsidiaryValue then
                                begin
                                  // to do: warning message here.
                                  raise EInvalidSource.Create
                                    ('Error: Two or more different concentrations or '
                                     + 'temparatures assigned to source at Node '
                                     + IntToStr(ANode.NodeIndex +1)
                                   + ' at ' + ANode.LocationString);
                                end;
                              end;

                            end;
                          end;
                        2: // specific source
                          begin
                            for InnerSegmentIndex := 0 to
                              IntersectingSegments.Count -1 do
                            begin
                              AnIntersectingSegment :=
                                IntersectingSegments[InnerSegmentIndex];
                              SegLength := AnIntersectingSegment.Length;
                              if SegLength <> 0 then
                              begin
                                if ((AValue > 0) and
                                    (ANode.Value1 < 0)) or
                                   ((AValue < 0) and
                                    (ANode.Value1 > 0)) then
                                begin
                              // to do; show error message.
{                                  raise EInvalidSource.Create
                                    ('Error: Two or more sources of '
                                     + 'opposite sign at Node '
                                     + IntToStr(ANode.NodeIndex +1)
                                     + ' at ' + ANode.LocationString); }
                                end;
//                                else
                                begin
                                  if Transient then
                                  begin
                                    ANode.Transient := True;
                                  end;
                                  OldValue := ANode.Value1;
                                  if AddValues then
                                  begin
                                    if SpecifiedSource then
                                    begin
                                      ANode.Value5 := ANode.Value5
                                        + SegLength * AValue;
                                    end;
                                    ANode.Value1 := ANode.Value1
                                      + SegLength * AValue;
                                    ANode.Comment := ANode.Comment + ' ' + Comment;
                                  end
                                  else
                                  begin
                                    ANode.Value1 := SegLength * AValue;
                                    ANode.Comment := Comment;
                                  end;
  //                                ANode.Value1 := ANode.Value1
  //                                  + SegLength * AValue;
                                  if AddValues and (AValue < 0) then
                                  begin
                                    SubsidiaryValue := 0;
                                  end;

                                  if AddValues then
                                  begin
                                    if SpecifiedSource then
                                    begin
                                      ANode.Value4 := ANode.Value4 + SegLength*AValue*SubsidiaryValue;
                                    end
                                    else
                                    begin
                                      ANode.Value2 := ANode.Value2 + {SegLength{*AValue*}SubsidiaryValue;
                                    end;

  //                                  ANode.Used := True;

                                    if not ANode.Used then
                                    begin
  //                                    ANode.Value2 := SubsidiaryValue;
                                      ANode.Used := True;
                                    end;
                                    UsedNodes.Add(ANode);
                                  end
                                  else
                                  begin
                                    if not ANode.Used then
                                    begin
                                      ANode.Value2 := SubsidiaryValue;
                                      ANode.Used := True;
                                      UsedNodes.Add(ANode);
                                    end
                                    else if ANode.Value2 <> SubsidiaryValue then
                                    begin
                                      raise EInvalidSource.Create
                                        ('Error: Two or more different concentrations or '
                                         + 'temparatures assigned to source at Node '
                                         + IntToStr(ANode.NodeIndex +1)
                                         + ' at ' + ANode.LocationString);
                                    end;
                                  end;
                                end;
                              end;
                            end;
                          end;
                        3:  // prescribed source
                          begin
                            if ANode.Used and (ANode.Value1 <> AValue) then
                            begin
                              raise EInvalidSource.Create
                                ('Error: Two or more different prescribed '
                                 + 'values assigned to source at Node '
                                 + IntToStr(ANode.NodeIndex +1)
                                 + ' at ' + ANode.LocationString);
                            end;
                            if Transient then
                            begin
                              ANode.Transient := True;
                            end;
                            ANode.Value1 := AValue;
                            ANode.Comment := Comment;
                            if not ANode.Used then
                            begin
                              ANode.Value2 := SubsidiaryValue;
                              ANode.Used := True;
                              UsedNodes.Add(ANode);
                            end
                            else if ANode.Value2 <> SubsidiaryValue then
                            begin
                            raise EInvalidSource.Create
                              ('Error: Two or more different concentrations or '
                               + 'temparatures assigned to source at Node '
                               + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString);
                            end;
                          end;
                        else
                          begin
                            raise EInvalidSource.Create
                              ('Error: ' + LayerName + '.'
                               + TSourceChoice.ANE_ParamName
                               + ' parameter incorrectly assigned'
                               + ' to line source '
                               + ' at Node '
                               + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString
                               + '. Check that you have entered a value for '
                               + TCustomTotalSourceParam.ANE_ParamName
                               + ' or '
                               + TCustomSpecificSourceParam.ANE_ParamName
                               + '.');
                          end;
                      end;
                    end;
                  finally
                    for InnerSegmentIndex := 0 to
                      IntersectingSegments.Count -1 do
                    begin
                      AnIntersectingSegment := IntersectingSegments
                        [InnerSegmentIndex];
                      AnIntersectingSegment.Free;
                    end;

                    IntersectingSegments.Free;
                  end;

                end;

              end;
            3: // close contour
              begin
                // need to test whether node is inside contour.
                if FollowMesh then
                begin
                  NodeX := ANode.TopRealX;
                  NodeY := ANode.TopRealY;
                end
                else
                begin
                  NodeX := ANode.X;
                  NodeY := ANode.Y;
                end;

                if AContour.IsInside(ModelHandle, NodeX, NodeY) then
                begin
                  InsideAnother := False;
                  for ContourIndex := 0 to LocalContours.Count -1 do
                  begin
                    AnotherContour := LocalContours[ContourIndex];
                    if AnotherContour.IsInside(ModelHandle, NodeX, NodeY) then
                    begin
                      InsideAnother := True;
                      Break;
                    end;
                  end;

                  if not InsideAnother then
                  begin
                    BoundaryFound := True;
                    Expression := LayerName + '.'
                      + TZeroTopElevParam.ANE_ParamName;
                    TopElevValue := ALayer.RealValueAtXY
                      (ModelHandle, NodeX, NodeY, Expression);
                    Expression := LayerName + '.'
                      + TBottomElevaParam.ANE_ParamName;
                    BotElevValue := ALayer.RealValueAtXY
                      (ModelHandle, NodeX, NodeY, Expression);
                    NodeZ := ANode.Z;
                    if ((TopElevValue >= NodeZ)
                      or NearlyTheSame(TopElevValue,NodeZ,Epsilon)) and
                      ((BotElevValue <= NodeZ)
                       or NearlyTheSame(BotElevValue,NodeZ,Epsilon)) then
                    begin
                      ANode.Comment := ANode.Comment + ' ' + Comment;
                      if not SourceOverRide then
                      begin
                        AValue := ALayer.RealValueAtXY(ModelHandle, ANode.X, ANode.Y,SourceExpr);
                      end;
                      if not ConcOverRide then
                      begin
                        SubsidiaryValue := ALayer.RealValueAtXY(ModelHandle, ANode.X, ANode.Y,ConcExpr);
                      end;
                      {$IFDEF OldSutraIce}
                      if not ConductanceOverridden then
                      begin
                        ConductanceValue := ALayer.RealValueAtXY(ModelHandle,
                          ANode.X, ANode.Y, CondExpr);
                      end;
                      {$ENDIF}
                      if TransientOverRide then
                      begin
                        Transient := SourceTransient;
                      end
                      else if TransientExpr = '0' then
                      begin
                        Transient := False;
                      end
                      else if TransientExpr = '1' then
                      begin
                        Transient := True;
                      end
                      else
                      begin
                        Transient := ALayer.BooleanValueAtXY(ModelHandle, ANode.X, ANode.Y,TransientExpr);
                      end;
                      {$IFDEF OldSutraIce}
                      ANode.Conductance := ConductanceValue;
                      {$ENDIF}
                      case SourceChoice of
                        1: // total source
                          begin
                            ANode.PolyHedron.GetProps(Volumn,Area);
                            ANode.FreePolyHedron;
                            TotVolume := TotVolume + Volumn;
                            if Transient then
                            begin
                              ANode.Transient := True;
                            end;
                            oldValue := ANode.Value3;
                            ANode.Value3 := Volumn * AValue;

                            if AddValues and (AValue < 0) then
                            begin
                              SubsidiaryValue := 0;
                            end;

                            if AddValues then
                            begin
                              ANode.Value4 := ANode.Value4 + Volumn*AValue*SubsidiaryValue;
                              ANode.Value2 := ANode.Value2 + {Volumn*{AValue*}SubsidiaryValue;
  //                            ANode.Used := True;
                              if not ANode.Used then
                              begin
  //                              ANode.Value2 := SubsidiaryValue;
                                ANode.Used := True;
                              end;
                              UsedNodes.Add(ANode);
                            end
                            else
                            begin
                              if not ANode.Used then
                              begin
                                ANode.Value2 := SubsidiaryValue;
                                ANode.Used := True;
                                UsedNodes.Add(ANode);
                              end
                              else if ANode.Value2 <> SubsidiaryValue then
                              begin
                                raise EInvalidSource.Create
                                  ('Error: Two or more different concentrations or '
                                   + 'temparatures assigned to source at Node '
                                   + IntToStr(ANode.NodeIndex +1)
                                     + ' at ' + ANode.LocationString);
                              end;
                            end;
                          end;
                        2:  // specific source
                          begin
                            ANode.PolyHedron.GetProps(Volumn,Area);
                            ANode.FreePolyHedron;
                            if ((AValue > 0) and (ANode.Value1 < 0)) or
                               ((AValue < 0) and (ANode.Value1 > 0)) then
                            begin
                              // show error message
{                              raise EInvalidSource.Create
                                ('Error: Two or more sources of opposite '
                                 + 'sign at Node '
                                 + IntToStr(ANode.NodeIndex +1)
                                 + ' at ' + ANode.LocationString); }
                            end;
//                            else
                            begin
                              if Transient then
                              begin
                                ANode.Transient := True;
                              end;
                              OldValue := ANode.Value1;
                              if AddValues then
                              begin
                                if SpecifiedSource then
                                begin
                                  ANode.Value5 := ANode.Value5 + AValue*Volumn;
                                end;

                                ANode.Value3 := ANode.Value3 + AValue*Volumn;
                                TotVolume := TotVolume + Volumn;
                                ANode.Comment := ANode.Comment + ' ' + Comment;
                              end
                              else
                              begin
                                ANode.Value1 := AValue;
                                ANode.Comment := Comment;
                              end;
                              if AddValues and (AValue < 0) then
                              begin
                                SubsidiaryValue := 0;
                              end;
                              if AddValues then
                              begin
                                if SpecifiedSource then
                                begin
                                  ANode.Value4 := ANode.Value4 + Volumn*AValue*SubsidiaryValue;
                                end
                                else
                                begin
                                  ANode.Value2 := ANode.Value2 + {Volumn*{AValue*}SubsidiaryValue;
                                end;
  //                              ANode.Used := True;
                                if not ANode.Used then
                                begin
  //                                ANode.Value2 := SubsidiaryValue;
                                  ANode.Used := True;
                                end;
                                UsedNodes.Add(ANode);
                              end
                              else
                              begin
                                if not ANode.Used then
                                begin
                                  ANode.Value2 := SubsidiaryValue;
                                  ANode.Used := True;
                                  UsedNodes.Add(ANode);
                                end
                                else if ANode.Value2 <> SubsidiaryValue then
                                begin
                                  // to do: show error message.
                                  raise EInvalidSource.Create
                                    ('Error: Two or more different concentrations or '
                                     + 'temparatures assigned to source at Node '
                                     + IntToStr(ANode.NodeIndex +1)
                                     + ' at ' + ANode.LocationString);
                                end;
                              end;
                            end;
                          end;
                        3:  // prescribed source
                          begin
                            if ANode.Used and (ANode.Value1 <> AValue) then
                            begin
                              raise EInvalidSource.Create
                                ('Error: Two or more different prescribed '
                                 + 'values assigned to source at Node '
                                 + IntToStr(ANode.NodeIndex +1)
                                 + ' at ' + ANode.LocationString);
                            end;
                            if Transient then
                            begin
                              ANode.Transient := True;
                            end;
                            ANode.Value1 := AValue;
                            ANode.Comment := Comment;
                            if not ANode.Used then
                            begin
                              ANode.Value2 := SubsidiaryValue;
                              ANode.Used := True;
                              UsedNodes.Add(ANode);
                            end
                            else if ANode.Value2 <> SubsidiaryValue then
                            begin
                              raise EInvalidSource.Create
                                ('Error: Two or more different concentrations or '
                                 + 'temparatures assigned to source at Node '
                                 + IntToStr(ANode.NodeIndex +1)
                                 + ' at ' + ANode.LocationString);
                            end;
                          end;
                        else
                          begin
                            raise EInvalidSource.Create
                              ('Error: ' + LayerName + '.'
                               + TSourceChoice.ANE_ParamName
                               + ' parameter incorrectly assigned'
                               + ' to polyhedron source '
                               + ' at Node '
                               + IntToStr(ANode.NodeIndex +1)
                                 + ' at ' + ANode.LocationString
                               + '. Check that you have entered a value for '
                               + TCustomTotalSourceParam.ANE_ParamName
                               + ' or '
                               + TCustomSpecificSourceParam.ANE_ParamName
                               + '.');
                          end;
                      end;

                    end;
                  end;
                end;

              end;
            else
              begin
                Assert(False);
              end;
          end;
        end;
        if not BoundaryFound then
        begin
          ASegment := ListOfSegments[0];
          ErrorMessage := ErrorStart + FloatToStr(ASegment.StartLoc[X]) +
            ', ' + FloatToStr(ASegment.StartLoc[Y]);
          Expression := 'SUTRA_ProgressBarAddLine("' + ErrorMessage + '")';
          ALayer.BooleanValueAtXY(ModelHandle, ASegment.StartLoc[X],
             ASegment.StartLoc[Y], Expression);
        end;
      finally
        TempList.Free;
        SortedList.Free;
      end;

    end;
    if TotVolume <> 0 then
    begin
      for NodeIndex := 0 to UsedNodes.Count -1 do
      begin
        ANode := UsedNodes[NodeIndex];
        case SourceChoice of
          1: // total source
            begin
              AValue := ANode.Value3/TotVolume;
            end;
          2: // specific source
            begin
              AValue := ANode.Value3;
            end;
          3: // perscribed source
            begin
              AValue := ANode.Value3/TotVolume;
            end;
        else Assert(False);
        end;

        if ((AValue > 0) and (ANode.Value1 < 0)) or
           ((AValue < 0) and (ANode.Value1 > 0)) then
        begin
          // show warning message
{          raise EInvalidSource.Create
            ('Error: Two or more sources of '
             + 'opposite sign at Node '
             + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString); }
        end;
//        else
        begin
          if AddValues then
          begin
            ANode.Value1 := ANode.Value1 + AValue;
//            ANode.Comment := ANode.Comment + ' ' + Comment;
          end
          else
          begin
            ANode.Value1 := AValue;
            ANode.Comment := Comment;
          end;
        end;
{        if AddValues then
        begin
          AValue := ANode.Value4/TotVolume;
          ANode.Value2 := ANode.Value2 + AValue;
        end;  }
      end;

    end;
    if TotLength <> 0 then
    begin
      for NodeIndex := 0 to UsedNodes.Count -1 do
      begin
        ANode := UsedNodes[NodeIndex];
        AValue := ANode.Value3/TotLength;
        if ((AValue > 0) and (ANode.Value1 < 0)) or
           ((AValue < 0) and (ANode.Value1 > 0)) then
        begin
          // to do: show error message
{          raise EInvalidSource.Create
            ('Error: Two or more sources of '
             + 'opposite sign at Node '
             + IntToStr(ANode.NodeIndex +1)
                               + ' at ' + ANode.LocationString); }
        end;
//        else
        begin
          if AddValues then
          begin
            ANode.Value1 := ANode.Value1 + AValue;
//            ANode.Comment := ANode.Comment + ' ' + Comment;
          end
          else
          begin
            ANode.Value1 := AValue;
            ANode.Comment := Comment;
          end;
        end;
{        if AddValues then
        begin
          AValue := ANode.Value4/TotLength;
          ANode.Value2 := ANode.Value2 + AValue;
        end;   }
      end;
    end;
  finally
    UsedNodes.Free;
    LocalContours.Free;
  end;
  if AddValues and SpecifiedSource then
  begin
    for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
    begin
      ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
      if ANode.Value5 <> 0 then
      begin
        ANode.Value2 := ANode.Value2 + ANode.Value4/ANode.Value5;
        ANode.Value5 := 0;
      end;

    end;

  end;
end;

procedure AssignNodeValuesFromPlanes(ModelHandle: ANE_PTR; ListOfPlanes : TList;
  SourceChoice : SmallInt; ALayer : TLayerOptions;
  SourceExpr, ConcExpr, TransientExpr : string;
  SourceOverRide, ConcOverRide, TransientOverRide : boolean;
  AddValues : boolean; const Comment : string; const SourceTransient,
  SpecifiedSource : boolean);
var
  PlaneIndex, NodeIndex : integer;
  APlane : TValuePlane;
  APlaneList : TXYZPlaneList;
  IntersectPlaneIndex : integer;
  IntersectionPlane : TXYZPlane;
  ANode : TVirtualNode;
  AValue1, AValue2 : double;
  TempList, SortedList : TList;
  Transient: boolean;
 { OldValue,} NewValue : double;
    {$IFDEF DEBUG}
    Index : integer;
    {$ENDIF}
begin
  for PlaneIndex := 0 to ListOfPlanes.Count -1 do
  begin
    APlane := ListOfPlanes[PlaneIndex];
    {$IFDEF DEBUG}
    for Index := 0 to APlane.Count -1 do
    begin
      WriteDebugOutput('APlane.Outline[' + IntToStr(Index)
        + '] = ' +
        FloatToStr(APlane.Outline[Index].X) + ', ' +
        FloatToStr(APlane.Outline[Index].Y) + ', ' +
        FloatToStr(APlane.Outline[Index].Z));
    end;

    {$ENDIF}
    APlane.SetBox;

    TempList := TList.Create;
    SortedList := TList.Create;
    try
      GetNodesInRange(frmSutra.VirtualMesh.SortedNodeList, SortedList,
        APlane.bmin[X], APlane.bmax[X], X);


      SortedList.Sort(SortNodesYMin);
      GetNodesInRange(SortedList, TempList, APlane.bmin[Y], APlane.bmax[Y], Y);

      TempList.Sort(SortNodesZMin);
      GetNodesInRange(TempList, SortedList, APlane.bmin[Z], APlane.bmax[Z], Z);

      for NodeIndex := 0 to SortedList.Count -1 do
      begin
        ANode := SortedList[NodeIndex];
        CurrentVertex := ANode;
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('NodeIndex = ' + IntToStr(NodeIndex));
          {$ENDIF}
        if SourceOverRide then
        begin
          AValue1 := APlane.Value1;
        end
        else
        begin
          AValue1 := ALayer.RealValueAtXY(ModelHandle, ANode.X, ANode.Y, SourceExpr);
        end;
        if ConcOverRide then
        begin
          AValue2 := APlane.Value2;
        end
        else
        begin
          AValue2 := ALayer.RealValueAtXY(ModelHandle, ANode.X, ANode.Y, ConcExpr);
        end;
        if TransientOverRide then
        begin
          Transient := SourceTransient;
        end
        else if TransientExpr = '0' then
        begin
          Transient := False;
        end
        else if TransientExpr = '1' then
        begin
          Transient := True;
        end
        else
        begin
          Transient := ALayer.BooleanValueAtXY(ModelHandle, ANode.X, ANode.Y,TransientExpr);
        end;
        APlaneList := ANode.PolyHedron.PolygonIntersect(APlane);
        ANode.FreePolyHedron;
        try
          for IntersectPlaneIndex := 0 to APlaneList.Count -1 do
          begin
            IntersectionPlane := APlaneList[IntersectPlaneIndex];
//            OldValue := ANode.Value1;
            NewValue := 0;
            if Transient then
            begin
              ANode.Transient := True;
            end;
            if SourceChoice = 1 then
            begin
              if AddValues then
              begin
                NewValue := AValue1*IntersectionPlane.Area/APlane.PlaneArea;
                ANode.Value1 := ANode.Value1 + NewValue;

                ANode.Comment := ANode.Comment + ' ' + Comment;
              end
              else
              begin
                ANode.Value1 := AValue1*IntersectionPlane.Area/APlane.PlaneArea;
                ANode.Comment := Comment;
              end;
            end
            else if SourceChoice = 2 then
            begin
              if AddValues then
              begin
                NewValue := AValue1*IntersectionPlane.Area;
                if SpecifiedSource then
                begin
                  ANode.Value5 := ANode.Value5 + NewValue;
                end;

                ANode.Value1 := ANode.Value1 + NewValue;
                ANode.Comment := ANode.Comment + ' ' + Comment;
              end
              else
              begin
                ANode.Value1 := AValue1*IntersectionPlane.Area;
                ANode.Comment := Comment;
              end;
            end
            else if SourceChoice = 3 then
            begin
              if ANode.Used and (ANode.Value1 <> AValue1) then
              begin

                raise EInvalidSource.Create
                  ('Error: Two or more different prescribed '
                   + 'values assigned to source at Node '
                   + IntToStr(ANode.NodeIndex +1));
              end;
              ANode.Value1 := AValue1;
              ANode.Comment := Comment;
            end
            else
            begin
              Assert(False);
            end;
            if AddValues then
            begin
              if SpecifiedSource then
              begin
                ANode.Value4 := ANode.Value4 + NewValue*AValue2;
              end
              else
              begin
                ANode.Value2 := ANode.Value2 + {NewValue*}AValue2;
              end;
              ANode.Used := True;
            end
            else
            begin
              if not ANode.Used then
              begin
                ANode.Value2 := AValue2;
                ANode.Used := True;
              end
              else if ANode.Value2 <> AValue2 then
              begin
                  raise EInvalidSource.Create
                    ('Error: Two or more different concentrations or '
                     + 'temparatures assigned to source at Node '
                     + IntToStr(ANode.NodeIndex +1));
              end;
            end;
          end;
        finally
          for IntersectPlaneIndex := 0 to APlaneList.Count -1 do
          begin
            TXYZPlane(APlaneList[IntersectPlaneIndex]).Free;
          end;
          APlaneList.Free;
        end;

      end;
    finally
      TempList.Free;
      SortedList.Free;
    end;
  end;
{  if AddValues and SpecifiedSource then
  begin
    for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
    begin
      ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
      if ANode.Value5 <> 0 then
      begin
        ANode.Value2 := ANode.Value2 + ANode.Value4/ANode.Value5;
        ANode.Value4 := 0;
        ANode.Value5 := 0;
      end;

    end;

  end; }


end;

procedure GetCountourLocations(ModelHandle: ANE_PTR;
  var ThisContourType: integer;
  TopElev, BotElev, ContourType : Integer;
  ListOfSegments : TList; AContour : TContourObjectOptions;
  FollowMeshParamIndex : SmallInt);
var
  NodeCount : integer;
  SegmentIndex : integer;
  IncLength : double;
  XLoc,YLoc,ZTop,ZBot : ANE_DOUBLE;
  ASegment, AnotherSegment : TSegmentObject;
  Length : double;
  FollowMesh : boolean;
  TempList, TempNodeList, NodeList, TempNewSegList : TList;
  ARealMesh : TReal2DMesh;
  ANode, AnotherNode : TRealNode;
  NodeIndex : integer;
  NodesPerLayer : integer;
  Limit : integer;
  NodePosition : integer;
  AVirtNode, AnotherVirtNode : TVirtualNode;
  denom : double;
begin
  Length := 0;

  // loop over nodes.
  NodeCount := AContour.NumberOfNodes(ModelHandle);
  for SegmentIndex := 0 to NodeCount -1 do
  begin
    // get the node location.
    AContour.GetNthNodeLocation(ModelHandle, XLoc,YLoc,SegmentIndex);
    if (SegmentIndex < NodeCount-1 ) or (SegmentIndex = 0) then
    begin
      // create a segment and set node locations
      ASegment := TSegmentObject.Create;
      ListOfSegments.Add(ASegment);
      ASegment.StartLoc[X] := XLoc;
      ASegment.StartLoc[Y] := YLoc;
      ASegment.StartLoc[Z] := 0;
      ASegment.EndLoc[X] := XLoc;
      ASegment.EndLoc[Y] := YLoc;
      ASegment.EndLoc[Z] := 0;
    end;
    if SegmentIndex > 0 then
    begin
      // set the end of the previous segment
      AnotherSegment := ListOfSegments[SegmentIndex-1];
      AnotherSegment.EndLoc[X] := XLoc;
      AnotherSegment.EndLoc[Y] := YLoc;
      Length := Length + AnotherSegment.Length;
    end;
  end;
  // Assign Z elevations to point and open contours.
  ZTop := AContour.GetFloatParameter(ModelHandle, TopElev);
  if TopElev = BotElev then
  begin
    ZBot := ZTop;
  end
  else
  begin
    ZBot := AContour.GetFloatParameter(ModelHandle, BotElev);
  end;

  if (Length = 0) or (NodeCount = 1) then // point contour
  begin
    for SegmentIndex := 0 to ListOfSegments.Count -1 do
    begin
      ASegment := ListOfSegments[SegmentIndex];
      ASegment.StartLoc[Z] := ZTop;
      ASegment.EndLoc[Z] := ZTop;
    end;
    ASegment := ListOfSegments[ListOfSegments.Count -1];
    ASegment.EndLoc[Z] := ZBot;
  end
  else
  begin
    if ThisContourType = 2 then // open contour
    begin
      IncLength := 0;
      for SegmentIndex := 0 to ListOfSegments.Count -1 do
      begin
        ASegment := ListOfSegments[SegmentIndex];
        IncLength := IncLength + ASegment.Length;

        if SegmentIndex > 0 then
        begin
          AnotherSegment := ListOfSegments[SegmentIndex-1];
          ASegment.StartLoc[Z] := AnotherSegment.EndLoc[Z]
        end
        else
        begin
          ASegment.StartLoc[Z] := ZTop;
        end;
        ASegment.EndLoc[Z] := ZTop + IncLength/Length*(ZBot-ZTop);
      end;
    end;
  end;
  if ThisContourType = 1 then
  begin
    if ListOfSegments.Count > 0 then
    begin
      ASegment := ListOfSegments[0];
      if ASegment.StartLoc[Z] <> ASegment.EndLoc[Z] then
      begin
        ThisContourType := 2;
      end;
    end
    else
    begin
      ThisContourType := -2;
    end;
  end;
  if FollowMeshParamIndex < 0 then
  begin
    FollowMesh := False;
  end
  else
  begin
    FollowMesh := AContour.GetBoolParameter(ModelHandle, FollowMeshParamIndex);
  end;
  if FollowMesh and (ThisContourType = 2) then
  begin
    ARealMesh := frmSutra.VirtualMesh.Real2DMeshes[0];
    NodesPerLayer := ARealMesh.NodeCount;
    TempList := TList.Create;
    TempNodeList := TList.Create;
    NodeList := TList.Create;
    TempNewSegList := TList.Create;
    try
      TempList.Capacity :=  ListOfSegments.Count;
      ListOfSegments.Capacity :=  ListOfSegments.Count;
      for SegmentIndex := 0 to ListOfSegments.Count -1 do
      begin
        TempList.Add(ListOfSegments[SegmentIndex]);
      end;
      for SegmentIndex := ListOfSegments.Count -1 downto 0 do
      begin
        ListOfSegments.Delete(SegmentIndex);
      end;
      for SegmentIndex := 0 to TempList.Count -1 do
      begin
        ASegment := TempList[SegmentIndex];

        ARealMesh.NodesOnSegment(ASegment, TempNodeList);
        for NodeIndex := 0 to TempNodeList.Count -1 do
        begin
          ANode := TempNodeList[NodeIndex];
          if NodeList.IndexOf(ANode) < 0 then
          begin
            NodeList.Add(ANode);
          end;
        end;
        TempNodeList.Clear;

      end;
      Length := 0;
      for NodeIndex := 0 to NodeList.Count -2 do
      begin
        ANode := NodeList[NodeIndex];
        AnotherNode := NodeList[NodeIndex+1];
        ASegment := TSegmentObject.Create;
        ASegment.StartLoc[X] := ANode.X;
        ASegment.StartLoc[Y] := ANode.Y;
        ASegment.StartLoc[Z] := 0;
        ASegment.EndLoc[X] := AnotherNode.X;
        ASegment.EndLoc[Y] := AnotherNode.Y;
        ASegment.EndLoc[Z] := 0;
        ListOfSegments.Add(ASegment);
        Length := Length + ASegment.Length;
      end;

      IncLength := 0;
      for SegmentIndex := 0 to ListOfSegments.Count -1 do
      begin
        ASegment := ListOfSegments[SegmentIndex];
        IncLength := IncLength + ASegment.Length;

        if SegmentIndex > 0 then
        begin
          AnotherSegment := ListOfSegments[SegmentIndex-1];
          ASegment.StartLoc[Z] := AnotherSegment.EndLoc[Z]
        end
        else
        begin
          ASegment.StartLoc[Z] := ZTop;
        end;
        ASegment.EndLoc[Z] := ZTop + IncLength/Length*(ZBot-ZTop);
      end;

      Limit := (frmSutra.VirtualMesh.NodeCount div NodesPerLayer) -2;
      for SegmentIndex := 0 to NodeList.Count -2 do
      begin
        ANode := NodeList[SegmentIndex];
        ASegment := ListOfSegments[SegmentIndex];
        NodePosition := ANode.NodeIndex ;
        for NodeIndex := 0 to Limit do
        begin
          AVirtNode := frmSutra.VirtualMesh.
            VirtualNodes[NodeIndex*NodesPerLayer+NodePosition];
          AnotherVirtNode := frmSutra.VirtualMesh.
            VirtualNodes[(NodeIndex+1)*NodesPerLayer+NodePosition];
          if (NodeIndex = 0) and (ASegment.StartLoc[Z] >= AVirtNode.Z) then
          begin
            ASegment.StartLoc[X] := AVirtNode.X;
            ASegment.StartLoc[Y] := AVirtNode.Y;
            break;
          end
          else if (NodeIndex = Limit) and (ASegment.StartLoc[Z] <= AnotherVirtNode.Z) then
          begin
            ASegment.StartLoc[X] := AnotherVirtNode.X;
            ASegment.StartLoc[Y] := AnotherVirtNode.Y;
            break;
          end
          else if (ASegment.StartLoc[Z] <= AVirtNode.Z)
              and (AnotherVirtNode.Z    < ASegment.StartLoc[Z]) then
          begin
            denom := AnotherVirtNode.Z - AVirtNode.Z;
            if denom = 0 then
            begin
              ASegment.StartLoc[X] := AVirtNode.X;
              ASegment.StartLoc[Y] := AVirtNode.Y;
            end
            else
            begin
              ASegment.StartLoc[X] := AVirtNode.X +
                (AnotherVirtNode.X - AVirtNode.X)
                * (ASegment.StartLoc[Z] - AVirtNode.Z)/denom;
              ASegment.StartLoc[Y] := AVirtNode.Y +
                (AnotherVirtNode.Y - AVirtNode.Y)
                * (ASegment.StartLoc[Z] - AVirtNode.Z)/denom;
            end;
            break;
          end;


        end;

        ANode := NodeList[SegmentIndex+1];
        NodePosition := ANode.NodeIndex ;
        for NodeIndex := 0 to Limit do
        begin
          AVirtNode := frmSutra.VirtualMesh.
            VirtualNodes[NodeIndex*NodesPerLayer+NodePosition];
          AnotherVirtNode := frmSutra.VirtualMesh.
            VirtualNodes[(NodeIndex+1)*NodesPerLayer+NodePosition];
          if (NodeIndex = 0) and (ASegment.EndLoc[Z] >= AVirtNode.Z) then
          begin
            ASegment.EndLoc[X] := AVirtNode.X;
            ASegment.EndLoc[Y] := AVirtNode.Y;
            break;
          end
          else if (NodeIndex = Limit) and
            (ASegment.EndLoc[Z] <= AnotherVirtNode.Z) then
          begin
            ASegment.EndLoc[X] := AnotherVirtNode.X;
            ASegment.EndLoc[Y] := AnotherVirtNode.Y;
            break;
          end
          else if (ASegment.EndLoc[Z] <= AVirtNode.Z)
              and (AnotherVirtNode.Z    < ASegment.EndLoc[Z]) then
          begin
            denom := AnotherVirtNode.Z - AVirtNode.Z;
            if denom = 0 then
            begin
              ASegment.EndLoc[X] := AVirtNode.X;
              ASegment.EndLoc[Y] := AVirtNode.Y;
            end
            else
            begin
              ASegment.EndLoc[X] := AVirtNode.X +
                (AnotherVirtNode.X - AVirtNode.X)
                * (ASegment.EndLoc[Z] - AVirtNode.Z)/denom;
              ASegment.EndLoc[Y] := AVirtNode.Y +
                (AnotherVirtNode.Y - AVirtNode.Y)
                * (ASegment.EndLoc[Z] - AVirtNode.Z)/denom;
            end;
            break;
          end;
        end;
//        AnotherNode := NodeList[SegmentIndex+1];
      end;

    finally
      for SegmentIndex := 0 to TempList.Count -1 do
      begin
        TSegmentObject(TempList[SegmentIndex]).Free;
      end;
      TempNewSegList.Free;
      TempList.Free;
      TempNodeList.Free;
      NodeList.Free;
    end;

  end;
end;

procedure GetClosedContourPlanes(ModelHandle: ANE_PTR; AContour : TContourObjectOptions;
  ListOfPlanes : TList; X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3  : SmallInt);
var
  NodeCount : integer;
  APlane : TValuePlane;
  APoint : TPointObject;
  XLoc,YLoc : double;
  NodeIndex : integer;
  Elevations : TElevationsLocations;
begin
  NodeCount := AContour.NumberOfNodes(ModelHandle);
  APlane := TValuePlane.Create(NodeCount-1);
  ListOfPlanes.Add(APlane);
  APoint := TPointObject.Create;
  try
    for NodeIndex := 0 to NodeCount -2 do
    begin
      // get the node location.
      AContour.GetNthNodeLocation(ModelHandle, XLoc,YLoc,NodeIndex);
      APoint.X := XLoc;
      APoint.Y := YLoc;
      APlane.Outline[NodeIndex] := APoint.XYZLocation;
    end;

    APoint.X := AContour.GetFloatParameter(ModelHandle, X1);
    APoint.Y := AContour.GetFloatParameter(ModelHandle, Y1);
    APoint.Z := AContour.GetFloatParameter(ModelHandle, Z1);
    Elevations[0] := APoint.XYZLocation;

    APoint.X := AContour.GetFloatParameter(ModelHandle, X2);
    APoint.Y := AContour.GetFloatParameter(ModelHandle, Y2);
    APoint.Z := AContour.GetFloatParameter(ModelHandle, Z2);
    Elevations[1] := APoint.XYZLocation;

    APoint.X := AContour.GetFloatParameter(ModelHandle, X3);
    APoint.Y := AContour.GetFloatParameter(ModelHandle, Y3);
    APoint.Z := AContour.GetFloatParameter(ModelHandle, Z3);
    Elevations[2] := APoint.XYZLocation;

    APlane.Elevations := Elevations;
  finally
    APoint.Free;
  end;
end;

Procedure GetOpenContourPlanes(ModelHandle: ANE_PTR;
  AContour: TContourObjectOptions; TopElevParamIndex, EndTopParamIndex,
  BotElevParamIndex, EndBotParamIndex, SourceChoice,
  FollowMeshParamIndex : SmallInt; ListOfPlanes : TList; var Area : extended );
var
  TopElev, EndTop, BotElev, EndBot : double;
  TopNodeList, BottomNodeList : TList;
  XLoc,YLoc, OldXLoc, OldYLoc : double;
  NodeCount : integer;
  Length, IncLength : extended;
  ContourIndex, PlaneIndex, NodeIndex, InnerNodeIndex : integer;
  APoint, AnotherPoint, CenterPoint : TPointObject;
  APlane : TValuePlane;
  InnerMostNodeIndex : integer;
  FollowMesh : boolean;
  TempListOfPlanes : TList;
  StartLoc, StopLoc : TXYZLocation;
  LocIndex : integer;
  SegmentList : TList;
  ASegment, AnotherSegment : TSegmentObject;
  SegmentIndex : integer;
  Converter : TPointObject;
  ARealMesh : TReal2DMesh;
  NodeList, TempNodeList : TList;
  TopSegment, BottomSegment : TSegmentObject;
  ANode, AnotherNode : TRealNode;
  ListOfTopSegments, ListOfBottomSegments : TList;
  StartNodePosition, EndNodePosition : integer;
  NodesPerLayer : integer;
  Limit : integer;
  TopStartVirtNode, BottomStartVirtNode, TopEndVirtNode, BottomEndVirtNode : TVirtualNode;
begin
  TopElev := AContour.GetFloatParameter(ModelHandle, TopElevParamIndex);
  EndTop := AContour.GetFloatParameter(ModelHandle, EndTopParamIndex);
  BotElev := AContour.GetFloatParameter(ModelHandle, BotElevParamIndex);
  EndBot := AContour.GetFloatParameter(ModelHandle, EndBotParamIndex);
  TopNodeList := TList.Create;
  BottomNodeList := TList.Create;
  try
    NodeCount := AContour.NumberOfNodes(ModelHandle);
    TopNodeList.Capacity := NodeCount;
    BottomNodeList.Capacity := NodeCount;
    Length := 0;
    for NodeIndex := 0 to NodeCount -1 do
    begin
      // get the node location.
      AContour.GetNthNodeLocation(ModelHandle, XLoc,YLoc,NodeIndex);
      APoint := TPointObject.Create;
      APoint.X := XLoc;
      APoint.Y := YLoc;
      TopNodeList.Add(APoint);
      APoint := TPointObject.Create;
      APoint.X := XLoc;
      APoint.Y := YLoc;
      BottomNodeList.Add(APoint);
      if NodeIndex > 0 then
      begin
        Length := Length + Sqrt(Sqr(XLoc-OldXLoc)+Sqr(YLoc-OldYLoc));
      end;
      OldXLoc := XLoc;
      OldYLoc := YLoc;
    end;
    IncLength := 0;
    if TopNodeList.Count > 0 then
    begin
      APoint := TopNodeList[0];
      APoint.Z := TopElev;
      APoint := BottomNodeList[0];
      APoint.Z := BotElev;
      for NodeIndex := 1 to TopNodeList.Count -1 do
      begin
        APoint := TopNodeList[NodeIndex];
        AnotherPoint := TopNodeList[NodeIndex-1];
        IncLength := IncLength + Sqrt(
          Sqr(APoint.X-AnotherPoint.X)+
          Sqr(APoint.Y-AnotherPoint.Y));
        APoint.Z := TopElev + (EndTop-TopElev)*IncLength/Length;
        APoint := BottomNodeList[NodeIndex];
        APoint.Z := BotElev + (EndBot-BotElev)*IncLength/Length;
      end;
      for NodeIndex := 1 to TopNodeList.Count -1 do
      begin
        APlane := TValuePlane.Create(4);
        ListOfPlanes.Add(APlane);

        APoint := TopNodeList[NodeIndex-1];
        APlane.Outline[0] := APoint.XYZLocation;

        APoint := TopNodeList[NodeIndex];
        APlane.Outline[1] := APoint.XYZLocation;

        APoint := BottomNodeList[NodeIndex];
        APlane.Outline[2] := APoint.XYZLocation;

        APoint := BottomNodeList[NodeIndex-1];
        APlane.Outline[3] := APoint.XYZLocation;

        if (APlane.Outline[0].X = APlane.Outline[APlane.Count-1].X) and
           (APlane.Outline[0].Y = APlane.Outline[APlane.Count-1].Y) and
           (APlane.Outline[0].Z = APlane.Outline[APlane.Count-1].Z) then
        begin
          APlane.Count := APlane.Count -1;
        end;
        for InnerNodeIndex := APlane.Count -1 downto 1 do
        begin
          if (APlane.Outline[InnerNodeIndex].X
               = APlane.Outline[InnerNodeIndex-1].X) and
             (APlane.Outline[InnerNodeIndex].Y
               = APlane.Outline[InnerNodeIndex-1].Y) and
             (APlane.Outline[InnerNodeIndex].Z
               = APlane.Outline[InnerNodeIndex-1].Z) then
          begin
            if APlane.Count = 3 then
            begin
              ListOfPlanes.Remove(APlane);
              APlane.Free;
//              APlane := nil;
              break;
            end
            else
            begin
              for InnerMostNodeIndex := InnerNodeIndex to APlane.Count -2 do
              begin
                APlane.Outline[InnerMostNodeIndex]
                  := APlane.Outline[InnerMostNodeIndex+1]
              end;
              APlane.Count := APlane.Count -1;
            end;
          end;
        end;
      end;

{start Follow mesh here}
{
 Overview:
 divide the planes up into triangles. each triangle will have corners at
 two adjacent nodes and the third point at the center of  the face of an
 element.
}
      FollowMesh := AContour.GetBoolParameter(ModelHandle, FollowMeshParamIndex);
      if FollowMesh then
      begin
        ARealMesh := frmSutra.VirtualMesh.Real2DMeshes[0];
        NodesPerLayer := ARealMesh.NodeCount;
        Limit := (frmSutra.VirtualMesh.NodeCount div NodesPerLayer) -2;

        TempListOfPlanes := TList.Create;
        Converter := TPointObject.Create;
        TempNodeList := TList.Create;
        NodeList := TList.Create;
        try
          TempListOfPlanes.Capacity := ListOfPlanes.Count;
          for PlaneIndex := 0 to ListOfPlanes.Count -1 do
          begin
            TempListOfPlanes.Add(ListOfPlanes[PlaneIndex]);
          end;
          ListOfPlanes.Clear;
          for PlaneIndex := 0 to TempListOfPlanes.Count -1 do
          begin
            NodeList.Clear;
            APlane := TempListOfPlanes[PlaneIndex];
            SegmentList := TList.Create;
            try
              SegmentList.Capacity := 2;
              for LocIndex := 0 to APlane.Count -2 do
              begin
                StartLoc := APlane.Outline[LocIndex];
                StopLoc := APlane.Outline[LocIndex+1];
                if (StartLoc.X <> StopLoc.X) or (StartLoc.Y <> StopLoc.Y) then
                begin
                  ASegment := TSegmentObject.Create;
                  Converter.XYZLocation := StartLoc;
                  ASegment.StartLoc := Converter.Location;
                  Converter.XYZLocation := StopLoc;
                  ASegment.EndLoc := Converter.Location;
                  SegmentList.Add(ASegment);
                end;
              end;
              Assert(SegmentList.Count = 2);
              TopSegment := SegmentList[0];
//              BottomSegment := SegmentList[1];

              ARealMesh.NodesOnSegment(TopSegment, TempNodeList);
              if TempNodeList.Count > 0 then
              begin
                NodeList.Capacity := TempNodeList.Count;
                for NodeIndex := 0 to TempNodeList.Count -1 do
                begin
                  ANode := TempNodeList[NodeIndex];
                  if NodeList.IndexOf(ANode) < 0 then
                  begin
                    NodeList.Add(ANode);
                  end;
                end;
              end;
              TempNodeList.Clear;

              ListOfTopSegments := TList.Create;
              ListOfBottomSegments := TList.Create;
              try

                ListOfTopSegments.Capacity := NodeList.Count -1;
                ListOfBottomSegments.Capacity := NodeList.Count -1;
                Length := 0;
                for NodeIndex := 0 to NodeList.Count -2 do
                begin
                  ANode := NodeList[NodeIndex];
                  AnotherNode := NodeList[NodeIndex+1];
                  ASegment := TSegmentObject.Create;
                  ASegment.StartLoc[X] := ANode.X;
                  ASegment.StartLoc[Y] := ANode.Y;
                  ASegment.StartLoc[Z] := 0;
                  ASegment.EndLoc[X] := AnotherNode.X;
                  ASegment.EndLoc[Y] := AnotherNode.Y;
                  ASegment.EndLoc[Z] := 0;
                  ListOfTopSegments.Add(ASegment);
                  Length := Length + ASegment.Length;
                  ASegment := TSegmentObject.Create;
                  ASegment.StartLoc[X] := ANode.X;
                  ASegment.StartLoc[Y] := ANode.Y;
                  ASegment.StartLoc[Z] := 0;
                  ASegment.EndLoc[X] := AnotherNode.X;
                  ASegment.EndLoc[Y] := AnotherNode.Y;
                  ASegment.EndLoc[Z] := 0;
                  ListOfBottomSegments.Add(ASegment);
                end;

                IncLength := 0;
                for SegmentIndex := 0 to ListOfTopSegments.Count -1 do
                begin
                  ASegment := ListOfTopSegments[SegmentIndex];
                  IncLength := IncLength + ASegment.Length;

                  if SegmentIndex > 0 then
                  begin
                    AnotherSegment := ListOfTopSegments[SegmentIndex-1];
                    ASegment.StartLoc[Z] := AnotherSegment.EndLoc[Z]
                  end
                  else
                  begin
                    ASegment.StartLoc[Z] := TopElev;
                  end;
                  ASegment.EndLoc[Z] := TopElev + IncLength/Length*(EndTop-TopElev);
                end;

                IncLength := 0;
                for SegmentIndex := 0 to ListOfBottomSegments.Count -1 do
                begin
                  ASegment := ListOfBottomSegments[SegmentIndex];
                  IncLength := IncLength + ASegment.Length;

                  if SegmentIndex > 0 then
                  begin
                    AnotherSegment := ListOfBottomSegments[SegmentIndex-1];
                    ASegment.StartLoc[Z] := AnotherSegment.EndLoc[Z]
                  end
                  else
                  begin
                    ASegment.StartLoc[Z] := BotElev;
                  end;
                  ASegment.EndLoc[Z] := BotElev + IncLength/Length*(EndBot-BotElev);
                end;

                // loop over top and bottom segments, identify nodes that
                // are in the segments, make planes.

                for SegmentIndex := 0 to ListOfTopSegments.Count -1 do
                begin
                  TopSegment := ListOfTopSegments[SegmentIndex];
                  BottomSegment := ListOfBottomSegments[SegmentIndex];
                  ANode := NodeList[SegmentIndex];
                  AnotherNode := NodeList[SegmentIndex+1];
                  StartNodePosition := ANode.NodeIndex;
                  EndNodePosition := AnotherNode.NodeIndex;
                  for NodeIndex := 0 to Limit do
                  begin
                    TopStartVirtNode := frmSutra.VirtualMesh.
                      VirtualNodes[NodeIndex*NodesPerLayer+StartNodePosition];
                    BottomStartVirtNode := frmSutra.VirtualMesh.
                      VirtualNodes[(NodeIndex+1)*NodesPerLayer+StartNodePosition];
                    TopEndVirtNode := frmSutra.VirtualMesh.
                      VirtualNodes[NodeIndex*NodesPerLayer+EndNodePosition];
                    BottomEndVirtNode := frmSutra.VirtualMesh.
                      VirtualNodes[(NodeIndex+1)*NodesPerLayer+EndNodePosition];

                    if (TopSegment.StartLoc[Z] >= TopStartVirtNode.Z) and
                       (TopStartVirtNode.Z >= BottomSegment.StartLoc[Z]) and
                       (TopSegment.StartLoc[Z] >= BottomStartVirtNode.Z) and
                       (BottomStartVirtNode.Z >= BottomSegment.StartLoc[Z]) and
                       (TopSegment.EndLoc[Z] >= TopEndVirtNode.Z) and
                       (TopEndVirtNode.Z >= BottomSegment.EndLoc[Z]) and
                       (TopSegment.EndLoc[Z] >= BottomEndVirtNode.Z) and
                       (BottomEndVirtNode.Z >= BottomSegment.EndLoc[Z]) then
                    begin
                      CenterPoint := TPointObject.Create;
                      APoint := TPointObject.Create;
                      try
                        CenterPoint.X := (TopStartVirtNode.X + BottomStartVirtNode.X +
                          TopEndVirtNode.X + BottomEndVirtNode.X)/4;
                        CenterPoint.Y := (TopStartVirtNode.Y + BottomStartVirtNode.Y +
                          TopEndVirtNode.Y + BottomEndVirtNode.Y)/4;
                        CenterPoint.Z := (TopStartVirtNode.Z + BottomStartVirtNode.Z +
                          TopEndVirtNode.Z + BottomEndVirtNode.Z)/4;

                        // first plane
                        APlane := TValuePlane.Create(3);
                        ListOfPlanes.Add(APlane);

                        APoint.X := TopStartVirtNode.X;
                        APoint.Y := TopStartVirtNode.Y;
                        APoint.Z := TopStartVirtNode.Z;
                        APlane.Outline[0] := APoint.XYZLocation;

                        APoint.X := TopEndVirtNode.X;
                        APoint.Y := TopEndVirtNode.Y;
                        APoint.Z := TopEndVirtNode.Z;
                        APlane.Outline[1] := APoint.XYZLocation;

                        APlane.Outline[2] := CenterPoint.XYZLocation;

                        // second plane
                        APlane := TValuePlane.Create(3);
                        ListOfPlanes.Add(APlane);

                        APoint.X := TopEndVirtNode.X;
                        APoint.Y := TopEndVirtNode.Y;
                        APoint.Z := TopEndVirtNode.Z;
                        APlane.Outline[0] := APoint.XYZLocation;

                        APoint.X := BottomEndVirtNode.X;
                        APoint.Y := BottomEndVirtNode.Y;
                        APoint.Z := BottomEndVirtNode.Z;
                        APlane.Outline[1] := APoint.XYZLocation;

                        APlane.Outline[2] := CenterPoint.XYZLocation;

                        // third plane
                        APlane := TValuePlane.Create(3);
                        ListOfPlanes.Add(APlane);

                        APoint.X := BottomEndVirtNode.X;
                        APoint.Y := BottomEndVirtNode.Y;
                        APoint.Z := BottomEndVirtNode.Z;
                        APlane.Outline[0] := APoint.XYZLocation;

                        APoint.X := BottomStartVirtNode.X;
                        APoint.Y := BottomStartVirtNode.Y;
                        APoint.Z := BottomStartVirtNode.Z;
                        APlane.Outline[1] := APoint.XYZLocation;

                        APlane.Outline[2] := CenterPoint.XYZLocation;

                        // fourth plane
                        APlane := TValuePlane.Create(3);
                        ListOfPlanes.Add(APlane);

                        APoint.X := BottomStartVirtNode.X;
                        APoint.Y := BottomStartVirtNode.Y;
                        APoint.Z := BottomStartVirtNode.Z;
                        APlane.Outline[0] := APoint.XYZLocation;

                        APoint.X := TopStartVirtNode.X;
                        APoint.Y := TopStartVirtNode.Y;
                        APoint.Z := TopStartVirtNode.Z;
                        APlane.Outline[1] := APoint.XYZLocation;

                        APlane.Outline[2] := CenterPoint.XYZLocation;
                      finally
                        APoint.Free;
                        CenterPoint.Free;
                      end;

                    end;

                  end;

                end;



              finally
                for SegmentIndex := 0 to ListOfTopSegments.Count -1 do
                begin
                  TSegmentObject(ListOfTopSegments[SegmentIndex]).Free;
                end;

                ListOfTopSegments.Free;

                for SegmentIndex := 0 to ListOfBottomSegments.Count -1 do
                begin
                  TSegmentObject(ListOfBottomSegments[SegmentIndex]).Free;
                end;

                ListOfBottomSegments.Free;
              end;




            finally
              for SegmentIndex := 0 to SegmentList.Count -1 do
              begin
                TSegmentObject(SegmentList[SegmentIndex]).Free;
              end;

              SegmentList.Free;
            end;

          end;
        finally
          for PlaneIndex := 0 to TempListOfPlanes.Count -1 do
          begin
            TValuePlane(TempListOfPlanes[PlaneIndex]).Free;
          end;

          TempListOfPlanes.Free;
          Converter.Free;
          TempNodeList.Free;
          NodeList.Free;
        end;

      end;

{end Follow mesh here}


      Area := 0;
      if SourceChoice = 1 then
      begin
        for PlaneIndex := 0 to ListOfPlanes.Count -1 do
        begin
          APlane := ListOfPlanes[PlaneIndex];
          APlane.PlaneArea := APlane.Area;
          Area := Area + APlane.PlaneArea;
        end;
      end;
    end;
  finally
    for NodeIndex := 0 to TopNodeList.Count -1 do
    begin
      TPointObject(TopNodeList[NodeIndex]).Free;
    end;
    for NodeIndex := 0 to BottomNodeList.Count -1 do
    begin
      TPointObject(BottomNodeList[NodeIndex]).Free;
    end;

    TopNodeList.Free;
    BottomNodeList.Free;
  end;
end;

end.
