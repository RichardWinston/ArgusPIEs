unit UnsatZoneFunctions;

interface

uses SysUtils, Dialogs, AnePIE, ANECB;

procedure InitializeNodeUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetNodeUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeElementUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetElementUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeElementUnsatZones(funHandle : ANE_PTR);
procedure InitializeNodeUnsatZones(funHandle : ANE_PTR);

implementation

uses Classes, OptionsUnit, SLUnsaturated, VirtualMeshUnit, frmSutraUnit,
  SLGeneralParameters, ArgusFormUnit, ANE_LayerUnit,
  ParamArrayUnit;

procedure InitializeElementUnsatZones(funHandle : ANE_PTR);
var
  VirtLayerIndex : integer;
  VirtElementIndex : integer;
  RealLayerIndex : integer;
  UnsatLayerName : string;
//  RealMeshLayer : TReal2DMesh;
  UnsatZoneLayer : TLayerOptions;
  LayerList : TList;
  LayerHandle : ANE_PTR;
  AVirtElement : TVirtualElement;
  VElementIndex : integer;
  RealMesh : TReal2DMesh;
  RealElement : TRealElement;
  Top, Bottom : double;
  X, Y : double;
  RealIndex : integer;
begin
  frmSutra.VirtualMesh.InitializeIntElementValue;

  if frmSutra.rbSatUnsat.Checked then
  begin
    LayerList := TList.Create;
    try
      LayerList.Capacity := frmSutra.VirtualMesh.RealMeshCount;
      for RealLayerIndex := 0 to frmSutra.VirtualMesh.RealMeshCount-1 do
      begin
        UnsatLayerName := TUnsaturatedLayer.WriteNewRoot
          + IntToStr(RealLayerIndex+1);
        LayerHandle := ANE_LayerGetHandleByName(funHandle, PChar(UnsatLayerName));
        UnsatZoneLayer := TLayerOptions.Create(LayerHandle);
        LayerList.Add(UnsatZoneLayer);
      end;

      for VirtElementIndex := 0 to frmSutra.VirtualMesh.ElementsPerLayer -1 do
      begin
        for VirtLayerIndex := 0 to frmSutra.VirtualMesh.VirtualMeshCount -2 do
        begin
          VElementIndex := frmSutra.VirtualMesh.VirtualElementIndex(VirtLayerIndex,VirtElementIndex);
          AVirtElement := frmSutra.VirtualMesh.VirtualElements[VElementIndex];
          RealIndex := frmSutra.VirtualMesh.RealLayerIndex(VirtLayerIndex);
          for RealLayerIndex := RealIndex to RealIndex + 1 do
          begin
            RealMesh := frmSutra.VirtualMesh.Real2DMeshes[RealLayerIndex];
            RealElement := RealMesh.Elements[VirtElementIndex];
            UnsatZoneLayer := LayerList[RealLayerIndex];
            RealElement.GetCenter(X, Y);

            Top := UnsatZoneLayer.RealValueAtXY(funHandle, X, Y,
              TTopElevaParam.ANE_ParamName);
            Bottom := UnsatZoneLayer.RealValueAtXY(funHandle, X, Y,
              TBottomElevaParam.ANE_ParamName);
            if (Top >= AVirtElement.ElZ) and (AVirtElement.ElZ >= Bottom) then
            begin
              AVirtElement.IntValue := UnsatZoneLayer.IntegerValueAtXY(funHandle, X,
                Y, TRegionParam.ANE_ParamName);
            end;
          end;
        end;
      end;
    finally
      for RealLayerIndex := 0 to LayerList.Count -1 do
      begin
        UnsatZoneLayer := LayerList[RealLayerIndex];
        UnsatZoneLayer.Free(funHandle);
      end;

      LayerList.Free;
    end;
  end;

end;


procedure InitializeNodeUnsatZones(funHandle : ANE_PTR);
var
  VirtLayerIndex : integer;
  VirtNodeIndex : integer;
  RealLayerIndex : integer;
  UnsatLayerName : string;
//  RealMeshLayer : TReal2DMesh;
  UnsatZoneLayer : TLayerOptions;
  LayerList : TList;
  LayerHandle : ANE_PTR;
  AVirtNode : TVirtualNode;
  VNodeIndex : integer;
  RealMesh : TReal2DMesh;
  RealNode : TRealNode;
  Top, Bottom : double;
  RealIndex : integer;
begin
  frmSutra.VirtualMesh.InitializeIntNodeValue;

  if frmSutra.rbSatUnsat.Checked then
  begin
    LayerList := TList.Create;
    try
      LayerList.Capacity := frmSutra.VirtualMesh.RealMeshCount;
      for RealLayerIndex := 0 to frmSutra.VirtualMesh.RealMeshCount-1 do
      begin
        UnsatLayerName := TUnsaturatedLayer.WriteNewRoot
          + IntToStr(RealLayerIndex+1);
        LayerHandle := ANE_LayerGetHandleByName(funHandle, PChar(UnsatLayerName));
        UnsatZoneLayer := TLayerOptions.Create(LayerHandle);
        LayerList.Add(UnsatZoneLayer);
      end;

      for VirtNodeIndex := 0 to frmSutra.VirtualMesh.NodesPerLayer -1 do
      begin
        for VirtLayerIndex := 0 to frmSutra.VirtualMesh.VirtualMeshCount -1 do
        begin
          VNodeIndex := frmSutra.VirtualMesh.VirtualNodeIndex(VirtLayerIndex,VirtNodeIndex);
          AVirtNode := frmSutra.VirtualMesh.VirtualNodes[VNodeIndex];
          RealIndex := frmSutra.VirtualMesh.RealLayerIndex(VirtLayerIndex);
          assert(RealIndex  < frmSutra.VirtualMesh.RealMeshCount);
          assert(RealIndex >=0);
          for RealLayerIndex := RealIndex to RealIndex + 1 do
//          for RealLayerIndex := 0 to frmSutra.VirtualMesh.RealMeshCount-1 do
          begin
            if RealLayerIndex < frmSutra.VirtualMesh.RealMeshCount then
            begin
              RealMesh := frmSutra.VirtualMesh.Real2DMeshes[RealLayerIndex];
              RealNode := RealMesh.Nodes[VirtNodeIndex];
              UnsatZoneLayer := LayerList[RealLayerIndex];
              Top := UnsatZoneLayer.RealValueAtXY(funHandle, RealNode.X, RealNode.Y,
                TTopElevaParam.ANE_ParamName);
              Bottom := UnsatZoneLayer.RealValueAtXY(funHandle, RealNode.X, RealNode.Y,
                TBottomElevaParam.ANE_ParamName);
              if (Top >= AVirtNode.Z) and (AVirtNode.Z >= Bottom) then
              begin
                AVirtNode.IntValue := UnsatZoneLayer.IntegerValueAtXY(funHandle, RealNode.X,
                  RealNode.Y, TRegionParam.ANE_ParamName);
                break;
              end;
            end;
          end;
        end;
      end;
    finally
      for RealLayerIndex := 0 to LayerList.Count -1 do
      begin
        UnsatZoneLayer := LayerList[RealLayerIndex];
        UnsatZoneLayer.Free(funHandle);
      end;

      LayerList.Free;
    end;

  end;

end;

procedure InitializeNodeUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
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
          InitializeNodeUnsatZones(funHandle);

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

procedure InitializeElementUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
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
          InitializeElementUnsatZones(funHandle);

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

procedure GetNodeUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
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

          result := frmSutra.VirtualMesh.VirtualNodes[NodeIndex].IntValue;
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

procedure GetElementUnsatZone (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  ElementIndex : ANE_INT32;
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
          ElementIndex :=  param1_ptr^ - 1;

          result := frmSutra.VirtualMesh.VirtualElements[ElementIndex].IntValue;
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


end.
