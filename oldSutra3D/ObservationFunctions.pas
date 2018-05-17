unit ObservationFunctions;

interface

uses SysUtils, Dialogs, AnePIE, ANECB;

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

procedure GetObservationsUsed (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure InitializeObservationsFunction(funHandle : ANE_PTR);
function GetObservationsPresent : boolean;

implementation

uses Classes, OptionsUnit, SLObservation, VirtualMeshUnit, frmSutraUnit,
  SLGeneralParameters, ArgusFormUnit, ANE_LayerUnit,
  ParamArrayUnit;

Var
  ObservationsPresent : boolean = False;

function GetObservationsPresent : boolean;
begin
  result := ObservationsPresent;
end;

procedure InitializeObservationsFunction(funHandle : ANE_PTR);
var
  VirtLayerIndex : integer;
  VirtNodeIndex : integer;
  RealLayerIndex : integer;
  ObservationLayerName : string;
//  RealMeshLayer : TReal2DMesh;
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
      ObservationLayerName := TObservationLayer.WriteNewRoot
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


end;

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

procedure GetObservationsUsed (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
//  NodeIndex : ANE_INT32;
//  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
//  param : PParameter_array;
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

          result := ObservationsPresent
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

end.
