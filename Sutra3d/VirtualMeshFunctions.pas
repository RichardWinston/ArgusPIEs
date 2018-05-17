unit VirtualMeshFunctions;

interface

uses SysUtils, Classes, Controls, Forms, AnePIE;

procedure MakeVirtualMesh (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure FreeVirtualMesh (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParsePorosity (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMorphedNodeValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParseInitialPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParseInitialConcentration (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParsePermMax (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParsePermMiddle (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParsePermMin (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ParseFloatExpression (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMorphedElementValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMorphedElementAngleValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetXNodeCoordinate (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetYNodeCoordinate (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetZNodeCoordinate (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetBandwidth(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetNodeNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet15B (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet14B (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet22 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet17 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet18 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet19 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet20 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSetICS2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSetICS3 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ExportDataSet8D (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{
procedure Dummy (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}

type TPolyhedronOptions = (poMemory, poStoreAll, poReadFromFile, poCompute);

var
  ExportingElements : boolean;
  UseOldNodePositions : boolean;
  PolyhedronChoice : TPolyhedronOptions = poCompute;
                                
implementation

uses Dialogs, frmSutraUnit, ANE_LayerUnit, ArgusFormUnit, ParamArrayUnit,
  ZFunction, OverriddenArrayUnit, VirtualMeshUnit, SLSutraMesh,
  UnsatZoneFunctions, SourcesOfFluidFunctions, SourcesOfSoluteFunctions,
  SpecifiedPressFunctions, SpecifiedConcTempFunctions, ObservationFunctions,
  doublePolyhedronUnit, OptionsUnit, Get3DElementValue, UtilityFunctions;

procedure OpenDataBases(const Root : string);
var
  CurDir : string;
  BminBmaxFile : string;
  PolyhedronFile : string;
begin
{  frmPolyhedronChoice := TfrmPolyhedronChoice.Create(Application);
  try
}

    CurDir := GetCurrentDir + '\';
    BminBmaxFile := CurDir + Root +'PolyhedronBox.sut';
    PolyhedronFile := CurDir + Root +'Polyhedron.sut';
{    if FileExists(BminBmaxFile) and FileExists(PolyhedronFile) then
    begin
      frmPolyhedronChoice.rbRead.Enabled := True;
//      UseOldNodePositions := not MessageDlg('Have the locations of any of the nodes changed '
//        + 'since the node locations were last stored?', mtInformation,
//        [mbYes, mbNo], 0) = mrYes;
    end
    else
    begin
      frmPolyhedronChoice.rbRead.Enabled := False;
//      UseOldNodePositions := False;
    end;
    frmPolyhedronChoice.ShowModal;
    if frmPolyhedronChoice.rbMemory.Checked then
    begin
      PolyhedronChoice := poMemory
    end
    else if frmPolyhedronChoice.rbStore.Checked then
    begin
      PolyhedronChoice := poStoreAll
    end
    else if frmPolyhedronChoice.rbRead.Checked then
    begin
      PolyhedronChoice := poReadFromFile
    end
    else if frmPolyhedronChoice.rbCompute.Checked then
    begin
      PolyhedronChoice := poCompute
    end
    else Assert(False);  }
    if PolyhedronChoice in [poStoreAll,poReadFromFile] then
    begin
      OpenPolyhedronBoxStream(BminBmaxFile);
      OpenPolyhedronStream(PolyhedronFile);
    end;
{  finally
    frmPolyhedronChoice.Free;
  end; }

end;

procedure MakeVirtualMesh (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    ExportingElements := False;
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      OpenDataBases(frmSutra.edRoot.Text);

      result := frmSutra.MakeVirtualMesh ;

    end;
    finally
      begin
        EditWindowOpen := False;
        ANE_BOOL_PTR(reply)^ := result;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

Procedure CloseDataBases;
begin
  ClosePolyhedronBoxStream;
  ClosePolyhedronStream;
end;

procedure FreeVirtualMesh (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  result := false;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin
      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      CloseDataBases;

      result := frmSutra.FreeVirtualMesh ;
      CurrentVertex := nil;
      OverridenParameters.ClearArrays;

    end;
    finally
      begin
        EditWindowOpen := False;
        ANE_BOOL_PTR(reply)^ := result;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParsePorosity (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.ParsePorosity ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMorphedNodeValue (const refPtX : ANE_DOUBLE_PTR      ;
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
  Expression : ANE_STR;
begin
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

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      NodeIndex :=  param1_ptr^ -1;
      NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

      Expression := param^[1];

      result := frmSutra.GetMorphedNodeValue(NodeIndex, string(Expression)) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParseInitialPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.ParseInitialPressure ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParseInitialConcentration (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.ParseInitialConcentration ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParsePermMax (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    CurrentElement := nil;
    ExportingElements := True;

    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.ParsePermMaximum ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParsePermMiddle (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := True;
    CurrentElement := nil;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.ParsePermMiddle ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParsePermMin (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := True;
    CurrentElement := nil;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.ParsePermMinimum ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ParseFloatExpression (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  Expression : ANE_STR;
begin
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

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;

      Expression := param^[0];

      result := frmSutra.ParseFloatExpression(String(Expression)) ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;



procedure GetMorphedElementValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  ElementIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
  Expression : ANE_STR;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := True;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      ElementIndex :=  param1_ptr^ -1;

      Expression := param^[1];


      result := frmSutra.GetMorphedElementValue(ElementIndex, String(Expression)) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMorphedElementAngleValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  ElementIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
  Expression : ANE_STR;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := True;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      ElementIndex :=  param1_ptr^ -1;

      Expression := param^[1];

      
      result := frmSutra.GetMorphedElementAngleValue(ElementIndex, String(Expression)) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetXNodeCoordinate (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      NodeIndex :=  param1_ptr^ -1;
      NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

      result := frmSutra.GetXValue(NodeIndex) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;


procedure GetYNodeCoordinate (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      NodeIndex :=  param1_ptr^ -1;
      NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

      result := frmSutra.GetYValue(NodeIndex) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;


procedure GetZNodeCoordinate (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      NodeIndex :=  param1_ptr^ -1;
      NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

      result := frmSutra.GetZValue(NodeIndex) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetBandwidth(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      result := frmSutra.VirtualMesh.BandWidth;
      ANE_INT32_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;   

procedure GetNodeNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  param : PParameter_array;
  NodeIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  ElementIndex : ANE_INT32;
  param2_ptr : ANE_INT32_PTR;
  AnElement : TVirtualElement;
  ANode : TVirtualNode;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      ElementIndex :=  param1_ptr^ -1;
      param2_ptr :=  param^[1];
      NodeIndex :=  param2_ptr^ -1;

      AnElement := frmSutra.VirtualMesh.VirtualElements[ElementIndex];
      ANode := AnElement.Nodes[NodeIndex];
      result := ANode.NodeIndex;
      result := frmSutra.VirtualMesh.NodeIndexToNodeNumber(result) + 1;

      ANE_INT32_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure ExportDataSet15B (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  ElementIndex : ANE_INT32;
  param : PParameter_array;
//resultList : TStringList;
  FileName : ANE_STR;
//AString: String;
  F : TextFile;
  ElementNumber : integer;
begin
//  Result := True;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    CurrentElement := nil;
    ExportingElements := True;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          InitializeElementUnsatZones(funHandle);
          with frmSutra do
          begin
            result := ParsePermMaximum;
            if result then
            begin
              result := ParsePermMiddle;
            end;

            if result then
            begin
              result := ParsePermMinimum;
            end;

            if result then
            begin
              result := ParseFloatExpression(TANGLE1Param.WriteParamName);
            end;

            if result then
            begin
              result := ParseFloatExpression(TANGLE2Param.WriteParamName);
            end;

            if result then
            begin
              result := ParseFloatExpression(TANGLE3Param.WriteParamName);

            end;

            if result then
            begin
              result := ParseFloatExpression(TALMAXParam.WriteParamName);
            end;

            if result then
            begin
              result := ParseFloatExpression(TALMIDParam.WriteParamName);
            end;

            if result then
            begin
              result := ParseFloatExpression(TALMINParam.WriteParamName);

            end;

            if result then
            begin
              result := ParseFloatExpression(TAT1MAXParam.WriteParamName);
            end;

            if result then
            begin
              result := ParseFloatExpression(TAT1MIDParam.WriteParamName);
            end;

            if result then
            begin
              result := ParseFloatExpression(TAT1MINParam.WriteParamName);
            end;

            {$IFDEF SutraIce}
            if result and (frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked) then
            begin
              result := ParseFloatExpression(TSIGS.WriteParamName);
            end;
            {$ENDIF}
          end;

          if result then
          begin
            param := @parameters^;
            FileName :=  param^[0];

            try
              AssignFile(F, GetCurrentDir + '\' + String(FileName));
              Rewrite(F);
              WriteLn(F, '#Start_inp15B');
              for ElementIndex := 0 to frmSutra.VirtualMesh.ElementCount -1 do
              begin
                ElementNumber := frmSutra.VirtualMesh.ElementIndexToElementNumber(ElementIndex);
                CurrentElement := frmSutra.VirtualMesh.VirtualElements[ElementNumber];
                if frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked then
                begin
                  WriteLn(F,
                    ElementIndex +1, ' ',
                    frmSutra.VirtualMesh.VirtualElements[ElementNumber].IntValue, ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TPMAXParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TPMIDParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TPMINParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementAngleValue(ElementNumber, TANGLE1Param.WriteParamName), ' ',
                    frmSutra.GetMorphedElementAngleValue(ElementNumber, TANGLE2Param.WriteParamName), ' ',
                    frmSutra.GetMorphedElementAngleValue(ElementNumber, TANGLE3Param.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TALMAXParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TALMIDParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TALMINParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TAT1MAXParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TAT1MIDParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TAT1MINParam.WriteParamName), ' '
                    {$IFDEF SutraIce}
                    , frmSutra.GetMorphedElementValue(ElementNumber, TSIGS.WriteParamName), ' '
                    {$ENDIF}
                    );
                end
                else
                begin
                  WriteLn(F,
                    ElementIndex +1, ' ',
                    frmSutra.VirtualMesh.VirtualElements[ElementNumber].IntValue, ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TPMAXParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TPMIDParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TPMINParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementAngleValue(ElementNumber, TANGLE1Param.WriteParamName), ' ',
                    frmSutra.GetMorphedElementAngleValue(ElementNumber, TANGLE2Param.WriteParamName), ' ',
                    frmSutra.GetMorphedElementAngleValue(ElementNumber, TANGLE3Param.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TALMAXParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TALMIDParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TALMINParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TAT1MAXParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TAT1MIDParam.WriteParamName), ' ',
                    frmSutra.GetMorphedElementValue(ElementNumber, TAT1MINParam.WriteParamName), ' '
                    );
                end;
              end;
            finally
              CloseFile(F);
            end;
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
        CurrentElement := nil;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure ExportDataSet14B (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
  param : PParameter_array;
  FileName : ANE_STR;
  ANode : TVirtualNode;
  F : TextFile;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    ExportingElements := False;
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          result := frmSutra.ParsePorosity;
          {$IFDEF SutraIce}
          if frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked then
          begin
            result := result and frmSutra.ParseCs1;
          end;
          {$ENDIF}
          if result then
          begin
            InitializeNodeUnsatZones(funHandle);

            param := @parameters^;
            FileName :=  param^[0];

            try
              AssignFile(F, GetCurrentDir + '\' + String(FileName));
              Rewrite(F);
              WriteLn(F, '#Start_inp14B');
              for NodeNumber := 0 to frmSutra.VirtualMesh.NodeCount -1 do
              begin
                NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeNumber);
                ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
                if frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked then
                begin
                  WriteLn(F,
                    NodeNumber +1, ' ',
                    ANode.IntValue, ' ',
                    ANode.X, ' ',
                    ANode.Y, ' ',
                    ANode.Z, ' ',
                    frmSutra.GetMorphedNodeValue(NodeNumber, TPORParam.WriteParamName), ' '
                    {$IFDEF SutraIce}
                    , frmSutra.GetMorphedNodeValue(NodeNumber, TCS1Parameter.WriteParamName), ' '
                    {$ENDIF}
                    );
                end
                else
                begin
                  WriteLn(F,
                    NodeNumber +1, ' ',
                    ANode.IntValue, ' ',
                    ANode.X, ' ',
                    ANode.Y, ' ',
                    ANode.Z, ' ',
                    frmSutra.GetMorphedNodeValue(NodeNumber, TPORParam.WriteParamName), ' '
                    );
                end;
              end;
            finally
              CloseFile(F);
            end;
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
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

procedure ExportDataSet17 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
//  param1_ptr : ANE_INT32_PTR;
  param : PParameter_array;
//  resultList : TStringList;  
  FileName : ANE_STR;
//  AString: String;
  ANode : TVirtualNode;
  F : TextFile;
begin
  Result := 0;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := -1;
  end
  else // if EditWindowOpen
  begin
    ExportingElements := False;
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;


          InitializeFluidSources(funHandle);

          param := @parameters^;
          FileName :=  param^[0];

          try
            AssignFile(F, GetCurrentDir + '\' + String(FileName));
            Rewrite(F);
              WriteLn(F, '#Start_inp17');
            for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
            begin
              ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
              if ANode.Used then
              begin
                Inc(result);
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(NodeIndex)+1;
                if ANode.Transient then
                begin
                  NodeNumber := -NodeNumber;
                end;

                WriteLn(F,
                  NodeNumber, ' ',
                  ANode.Value1, ' ',
                  ANode.Value2, ' ',
                  '''Data Set 17 ',
                  ANode.Comment,
                  '''');
              end

            end;
            if result > 0 then
            begin
              WriteLn(F,
                '0 Data Set 17');
            end;
          finally
            CloseFile(F);
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := -1;
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

procedure ExportDataSet18 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
//  param1_ptr : ANE_INT32_PTR;
  param : PParameter_array;
//  resultList : TStringList;
  FileName : ANE_STR;
//  AString: String;
  ANode : TVirtualNode;
  F : TextFile;
begin
  Result := 0;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := -1;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          InitializeEnergySoluteSources(funHandle);

          param := @parameters^;
          FileName :=  param^[0];

          try
            AssignFile(F, GetCurrentDir + '\' + String(FileName));
            Rewrite(F);
            WriteLn(F, '#Start_inp18');
            for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
            begin
              ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
              if ANode.Used then
              begin
                Inc(result);
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(NodeIndex)+1;
                if ANode.Transient then
                begin
                  NodeNumber := -NodeNumber;
                end;
                WriteLn(F,
                  NodeNumber, ' ',
                  ANode.Value1, ' ',
                  '''Data Set 18 ',
                  ANode.Comment,
                  '''');
              end

            end;
            if result > 0 then
            begin
              WriteLn(F,
                '0 Data Set 18');
            end;
          finally
            CloseFile(F);
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := -1;
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

procedure ExportDataSet19 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
//  param1_ptr : ANE_INT32_PTR;
  param : PParameter_array;
//  resultList : TStringList;
  FileName : ANE_STR;
//  AString: String;
  ANode : TVirtualNode;
  F : TextFile;
begin
  Result := 0;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := -1;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          InitializeSpecifiedPressureNodes(funHandle);

          param := @parameters^;
          FileName :=  param^[0];

          try
            AssignFile(F, GetCurrentDir + '\' + String(FileName));
            Rewrite(F);
            WriteLn(F, '#Start_inp19');
            for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
            begin
              ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
              if ANode.Used then
              begin
                Inc(result);
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(NodeIndex)+1;
                if ANode.Transient then
                begin
                  NodeNumber := -NodeNumber;
                end;
                WriteLn(F,
                  NodeNumber, ' ',
                  ANode.Value1, ' ',
                  ANode.Value2, ' ',
                  '''Data Set 19 ',
                  ANode.Comment,
                  '''');
              end

            end;
            if result > 0 then
            begin
              WriteLn(F,
                '0 Data Set 19');
            end;
          finally
            CloseFile(F);
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := -1;
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

procedure ExportDataSet20 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
  param : PParameter_array;
  FileName : ANE_STR;
  ANode : TVirtualNode;
  F : TextFile;
begin
  Result := 0;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := -1;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          InitializeSpecifiedConcTempNodes(funHandle);

          param := @parameters^;
          FileName :=  param^[0];

          try
            AssignFile(F, GetCurrentDir + '\' + String(FileName));
            Rewrite(F);
            WriteLn(F, '#Start_inp20');
            for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
            begin
              ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
              if ANode.Used then
              begin
              Inc(result);
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(NodeIndex)+1;
              if ANode.Transient then
              begin
                NodeNumber := -NodeNumber;
              end;
              WriteLn(F,
                NodeNumber, ' ',
                ANode.Value1, ' ',
                {$IFDEF OldSutraIce}
                ANode.Conductance, ' ',
                {$ENDIF}
                '''Data Set 20 ',
                ANode.Comment,
                  '''');
              end

            end;
            if result > 0 then
            begin
              WriteLn(F,
                '0 Data Set 20');
            end;
          finally
            CloseFile(F);
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := -1;
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

procedure ExportDataSet22 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  NodeIndex : ANE_INT32;
  ElementIndex, NodeNumber : integer;
//  param1_ptr : ANE_INT32_PTR;
  param : PParameter_array;
//  resultList : TStringList;
  FileName : ANE_STR;
//  AString: String;
  ANode : TVirtualNode;
  AnElement : TVirtualElement;
  F : TextFile;
begin
  Result := True;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

{          result := frmSutra.ParsePorosity;
          if result then
          begin
            InitializeNodeUnsatZones(funHandle);  }

            param := @parameters^;
            FileName :=  param^[0];

            try
              AssignFile(F, GetCurrentDir + '\' + String(FileName));
              Rewrite(F);

              WriteLn(F, '#Start_inp22');
              WriteLn(F, '''INCIDENCE''');
              for ElementIndex := 0 to frmSutra.VirtualMesh.ElementCount -1 do
              begin
                Write(F, ElementIndex +1, ' ');

                AnElement := frmSutra.VirtualMesh.VirtualElements[frmSutra.VirtualMesh.ElementIndexToElementNumber(ElementIndex)];

                NodeIndex := 4;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 5;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 6;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 7;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 0;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 1;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 2;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Write(F, NodeNumber, ' ');

                NodeIndex := 3;
                ANode := AnElement.Nodes[NodeIndex];
                NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
                Writeln(F, NodeNumber, ' ');

              end;
            finally
              CloseFile(F);
            end;
//          end;

{          resultList := TStringList.Create;
          try
            resultList.Add('''INCIDENCE''');

            for ElementIndex := 0 to frmSutra.VirtualMesh.ElementCount -1 do
            begin
              AString := Format('%d ', [ElementIndex +1]);

              AnElement := frmSutra.VirtualMesh.VirtualElements[ElementIndex];
              NodeIndex := 0;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 3;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 2;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 1;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 4;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 7;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 6;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              NodeIndex := 5;
              ANode := AnElement.Nodes[NodeIndex];
              NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(ANode.NodeIndex) + 1;
              AString := AString + IntToStr(NodeNumber) + ' ';

              resultList.Add(AString);
            end;
            resultList.SaveToFile(String(FileName));
          finally
            resultList.Free;
          end; }

        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
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

{
procedure Dummy (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
  param1_ptr : ANE_INT32_PTR;
  param : PParameter_array;
  resultList : TStringList;
  FileName : ANE_STR;
  AString: String;
  ANode : TVirtualNode;
begin
  Result := True;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
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
          NodeIndex :=  param1_ptr^ -1;
          NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

          Result := True;

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
}

procedure ExportDataSetICS2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  NodeNumber : integer;
  param : PParameter_array;
  FileName : ANE_STR;
  F : TextFile;
  RestartFile : TextFile;
  Index : integer;
  Line : string;
  ReadPressures, InterpolatePressures : boolean;
  Limit : integer;
  MeshLayerName : string;
  MeshLayer : TLayerOptions;
  ANode: TVirtualNode;
  PressureValue: double;
  Splitter: TStringList;
  NodeIndex: Integer;
  Changed: Boolean;
begin
//  Result := True;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    Splitter := TStringList.Create;
    try  // try 1
    begin
      Splitter.Delimiter := ' ';
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;
          ReadPressures := (frmSutra.rgInitialValues.ItemIndex = 1) or
            (frmSutra.rgInitialValues.ItemIndex = 3);
          InterpolatePressures := (frmSutra.rgInterpolateInitialValues.ItemIndex = 1) or
            (frmSutra.rgInterpolateInitialValues.ItemIndex = 3);
          if ReadPressures then
          begin
            if FileExists(frmSutra.edRestartFile.Text) then
            begin
              result := True;
            end
            else
            begin
              result := False;
              Beep;
              MessageDlg('The restart file, ' + frmSutra.edRestartFile.Text
                + ', does not exist.', mtError, [mbOK], 0);
            end;

          end
          else if InterpolatePressures then
          begin
            if frmSutra.ElementInterp <> nil then
            begin
              result := True;
            end
            else
            begin
              result := False;
              Beep;
              MessageDlg('Interpolated values have not been stored', mtError, [mbOK], 0);
            end;
          end
          else
          begin
            result := frmSutra.ParseInitialPressure;
          end;
          Result := Result and frmSutra.ParseInitialPressureOverride;

          if result then
          begin

            param := @parameters^;
            FileName :=  param^[0];

            try
              AssignFile(F, GetCurrentDir + '\' + String(FileName));
              Rewrite(F);
              WriteLn(F, '#Start_ics2');
              WriteLn(F, '''NONUNIFORM''');

              if ReadPressures then
              begin
                AssignFile(RestartFile, frmSutra.edRestartFile.Text);
                try
                  Reset(RestartFile);
                  ReadLn(RestartFile);
                  ReadLn(RestartFile);
                  if frmSutra.VirtualMesh = nil then
                  begin
                    Limit := frmSutra.GetLayerCount;
                    if frmSutra.rb3D_va.Checked then
                    begin
                      MeshLayerName := TSutraMeshLayer.ANE_LayerName;
                    end
                    else
                    begin
                      MeshLayerName := TSutraMeshLayer.ANE_LayerName + '1';
                    end;
                    MeshLayer := TLayerOptions.CreateWithName(MeshLayerName,funHandle);
                    try
                      Limit := Limit * MeshLayer.NumObjects(funHandle, pieNodeObject)
                    finally
                      MeshLayer.Free(funHandle);
                    end;
                  end
                  else
                  begin
                    Limit := frmSutra.VirtualMesh.NodeCount;
                  end;
                  Limit := (Limit - 1) div 4 + 1;
                  result := True;
                  NodeNumber := 0;
                  for Index := 0 to Limit -1 do
                  begin
                    ReadLn(RestartFile, Line);
                    if frmSutra.cbPressureOverride.Enabled and frmSutra.cbPressureOverride.Checked then
                    begin
                      Splitter.DelimitedText := Line;
                      Assert(Splitter.Count <= 4);
                      Assert(Splitter.Count > 0);
                      Changed := False;
                      for NodeIndex := 0 to Splitter.Count - 1 do
                      begin
                        ANode := frmSutra.VirtualMesh.VirtualNodes[
                          frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeNumber)];
                        CurrentVertex  := ANode;

                        if not ANode.MorphedIsNA(frmSutra.CurrentModelHandle,
                          TPVEC_OverrideParam.WriteParamName) then
                        begin
                          PressureValue := frmSutra.GetMorphedNodeValue(NodeNumber,
                            TPVEC_OverrideParam.WriteParamName);
                          Splitter[NodeIndex] := InternationalFloatToStr(PressureValue);
                          Changed := True;
                        end;

                        Inc(NodeNumber);
                      end;
                      if Changed then
                      begin
                        Line := Splitter.DelimitedText;
                      end;
                    end;
                    WriteLn(F, Line);
                    if EOF(RestartFile) then
                    begin
                      result := False;
                      Beep;
                      MessageDlg('The end of the restart file, '
                        + frmSutra.edRestartFile.Text
                        + ', was reached before reading all the data required '
                        + 'for data set 2 of the initial conditions file.',
                        mtError, [mbOK], 0);
                      break;
                    end;
                  end;
                finally
                  CloseFile(RestartFile);
                end;
              end
              else if InterpolatePressures then
              begin
                for NodeNumber := 0 to frmSutra.VirtualMesh.NodeCount -1 do
                begin
                  with frmSutra.VirtualMesh do
                  begin
                    ANode := VirtualNodes[NodeNumberToNodeIndex(NodeNumber)];
                    CurrentVertex  := ANode;

                    if ANode.MorphedIsNA(frmSutra.CurrentModelHandle,
                      TPVEC_OverrideParam.WriteParamName) then
                    begin
                      PressureValue := frmSutra.ElementInterp.GetInterpolatedValue
                        (ANode.X, ANode.Y, ANode.Z, piPressure);
                    end
                    else
                    begin
                      PressureValue := frmSutra.GetMorphedNodeValue(NodeNumber,
                        TPVEC_OverrideParam.WriteParamName)
                    end;

                    WriteLn(F, PressureValue, '');
    //                  frmSutra.GetMorphedNodeValue(NodeIndex, TPVECParam.WriteParamName), ' ');
//                      frmSutra.GetMorphedNodeValue(NodeNumber, TPVECParam.WriteParamName), ' ');
                  end;

                end;
              end
              else
              begin
                for NodeNumber := 0 to frmSutra.VirtualMesh.NodeCount -1 do
                begin
  //                NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeNumber);
  //                ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
                  WriteLn(F,
  //                  frmSutra.GetMorphedNodeValue(NodeIndex, TPVECParam.WriteParamName), ' ');
                    frmSutra.GetMorphedNodeValue(NodeNumber, TPVECParam.WriteParamName), ' ');

                end;
              end;
            finally
              CloseFile(F);
            end;
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := False;
        end;
      end;
    end;
    finally
      Splitter.Free;
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure ExportDataSetICS3 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  NodeNumber : integer;
  param : PParameter_array;
  FileName : ANE_STR;
  F : TextFile;
  RestartFile : TextFile;
  Index : integer;
  Line : string;
  ReadConcentrations, InterpolateConcentrations : boolean;
  Limit : integer;
  MeshLayerName : string;
  MeshLayer : TLayerOptions;
  ANode: TVirtualNode;
  Splitter: TStringList;
  Changed: Boolean;
  NodeIndex: Integer;
  UValue: ANE_DOUBLE;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    Splitter := TStringList.Create;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          ReadConcentrations := (frmSutra.rgInitialValues.ItemIndex = 2) or
            (frmSutra.rgInitialValues.ItemIndex = 3);
          InterpolateConcentrations := (frmSutra.rgInterpolateInitialValues.ItemIndex = 2) or
            (frmSutra.rgInterpolateInitialValues.ItemIndex = 3);
          Splitter.Delimiter := ' ';
          if ReadConcentrations then
          begin
            if FileExists(frmSutra.edRestartFile.Text) then
            begin
              result := True;
            end
            else
            begin
              result := False;
              Beep;
              MessageDlg('The restart file, ' + frmSutra.edRestartFile.Text
                + ', does not exist.', mtError, [mbOK], 0);
            end;

          end
          else if InterpolateConcentrations then
          begin
            if frmSutra.ElementInterp <> nil then
            begin
              result := True;
            end
            else
            begin
              result := False;
              Beep;
              MessageDlg('Interpolated values have not been stored', mtError, [mbOK], 0);
            end;
          end
          else
          begin
            result := frmSutra.ParseInitialConcentration;
          end;

          result := result and frmSutra.ParseInitialConcentrationOverride;

          if result then
          begin

            param := @parameters^;
            FileName :=  param^[0];

            try
              AssignFile(F, GetCurrentDir + '\' + String(FileName));
              Rewrite(F);
              WriteLn(F, '#Start_ics3');
              WriteLn(F, '''NONUNIFORM''');

              if ReadConcentrations then
              begin
                AssignFile(RestartFile, frmSutra.edRestartFile.Text);
                try
                  Reset(RestartFile);
                  ReadLn(RestartFile);
                  ReadLn(RestartFile);
                  if frmSutra.VirtualMesh = nil then
                  begin
                    Limit := frmSutra.GetLayerCount;
                    if frmSutra.rb3D_va.Checked then
                    begin
                      MeshLayerName := TSutraMeshLayer.ANE_LayerName;
                    end
                    else
                    begin
                      MeshLayerName := TSutraMeshLayer.ANE_LayerName + '1';
                    end;
                    MeshLayer := TLayerOptions.CreateWithName(MeshLayerName,funHandle);
                    try
                      Limit := Limit * MeshLayer.NumObjects(funHandle, pieNodeObject)
                    finally
                      MeshLayer.Free(funHandle);
                    end;
                  end
                  else
                  begin
                    Limit := frmSutra.VirtualMesh.NodeCount;
                  end;
                  Limit := (Limit - 1) div 4 + 1;
//                  Limit := (frmSutra.VirtualMesh.NodeCount - 1) div 4 + 1;
                  for Index := 0 to Limit -1 do
                  begin
                    ReadLn(RestartFile);
                  end;
                  ReadLn(RestartFile);
                  result := True;
                  for Index := 0 to Limit -1 do
                  begin
                    ReadLn(RestartFile, Line);

                    if frmSutra.cbConcentrationOverride.Enabled and frmSutra.cbConcentrationOverride.Checked then
                    begin
                      Splitter.DelimitedText := Line;
                      Assert(Splitter.Count <= 4);
                      Assert(Splitter.Count > 0);
                      Changed := False;
                      for NodeIndex := 0 to Splitter.Count - 1 do
                      begin
                        ANode := frmSutra.VirtualMesh.VirtualNodes[
                          frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeNumber)];
                        CurrentVertex  := ANode;

                        if not ANode.MorphedIsNA(frmSutra.CurrentModelHandle,
                          TUVEC_OverrideParam.WriteParamName) then
                        begin
                          UValue := frmSutra.GetMorphedNodeValue(NodeNumber,
                            TUVEC_OverrideParam.WriteParamName);
                          Splitter[NodeIndex] := InternationalFloatToStr(UValue);
                          Changed := True;
                        end;

                        Inc(NodeNumber);
                      end;
                      if Changed then
                      begin
                        Line := Splitter.DelimitedText;
                      end;
                    end;

                    WriteLn(F, Line);
                    if EOF(RestartFile) then
                    begin
                      result := False;
                      Beep;
                      MessageDlg('The end of the restart file, '
                        + frmSutra.edRestartFile.Text
                        + ', was reached before reading all the data required '
                        + 'for data set 3 of the initial conditions file.',
                        mtError, [mbOK], 0);
                      break;
                    end;
                  end;
                finally
                  CloseFile(RestartFile);
                end;
              end
              else if InterpolateConcentrations then
              begin
                for NodeNumber := 0 to frmSutra.VirtualMesh.NodeCount -1 do
                begin
                  with frmSutra.VirtualMesh do
                  begin
                    ANode := VirtualNodes[NodeNumberToNodeIndex(NodeNumber)];
                    CurrentVertex  := ANode;

                    if ANode.MorphedIsNA(frmSutra.CurrentModelHandle,
                      TUVEC_OverrideParam.WriteParamName) then
                    begin
                      UValue := frmSutra.ElementInterp.GetInterpolatedValue
                        (ANode.X, ANode.Y, ANode.Z, piConcentration);
                    end
                    else
                    begin
                      UValue := frmSutra.GetMorphedNodeValue(NodeNumber,
                        TUVEC_OverrideParam.WriteParamName)
                    end;


                    WriteLn(F, UValue, '');
    //                  frmSutra.GetMorphedNodeValue(NodeIndex, TPVECParam.WriteParamName), ' ');
//                      frmSutra.GetMorphedNodeValue(NodeNumber, TPVECParam.WriteParamName), ' ');
                  end;

                end;
              end
              else
              begin
                for NodeNumber := 0 to frmSutra.VirtualMesh.NodeCount -1 do
                begin
  //                NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeNumber);
  //                ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
                  WriteLn(F,
  //                  frmSutra.GetMorphedNodeValue(NodeIndex, TUVECParam.WriteParamName), ' ');
                    frmSutra.GetMorphedNodeValue(NodeNumber, TUVECParam.WriteParamName), ' ');

                end;
              end;
            finally
              CloseFile(F);
            end;
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := False;
        end;
      end;
    end;
    finally
      Splitter.Free;
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure ExportDataSet8D (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
//  param1_ptr : ANE_INT32_PTR;
  param : PParameter_array;
//  resultList : TStringList;
  FileName : ANE_STR;
//  AString: String;
  ANode : TVirtualNode;
  F : TextFile;
begin
  Result := 0;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := -1;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    ExportingElements := False;
    try  // try 1
    begin
      try
        begin

          // Get the Sutra Form
          frmSutra := TArgusForm.GetFormFromArgus(funHandle)
            as TfrmSutra;

          InitializeObservationsFunction(funHandle);

          param := @parameters^;
          FileName :=  param^[0];

          try
            AssignFile(F, GetCurrentDir + '\' + String(FileName));
            Rewrite(F);
            WriteLn(F, '#Start_inp8D');
            WriteLn(F, '# Data Set 8D');
//            if GetObservationsPresent then
//            begin
//              {$IFDEF SUTRA21}
              Writeln(F, frmSutra.adeNOBLIN.Text + ' ');
//              {$ELSE}
//              Writeln(F, frmSutra.adeNOBCYC.Text + ' ');
//              {$ENDIF}
              for NodeIndex := 0 to frmSutra.VirtualMesh.NodeCount -1 do
              begin
                ANode := frmSutra.VirtualMesh.VirtualNodes[NodeIndex];
                if ANode.Used then
                begin
                  Inc(result);
                  NodeNumber := frmSutra.VirtualMesh.NodeIndexToNodeNumber(NodeIndex)+1;
//                  {$IFDEF SUTRA21}
                    Write(F, '''N_', NodeNumber, ''' ');
                    Writeln(F, ANode.X, ' ', ANode.Y, ' ',
                      ANode.Z, ' ', '''Timed_Obs'' ''OBS''', ' # ', ANode.Comment);
//                  {$ELSE}
//                    Writeln(F, NodeNumber, ' ');
//                  {$ENDIF}
                end

              end;
              if result > 0 then
              begin
//                {$IFDEF SUTRA21}
                  WriteLn(F, '-');
//                {$ELSE}
//                  WriteLn(F, '0');
//                {$ENDIF}
              end;
//            end;
          finally
            CloseFile(F);
          end;
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := -1;
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

Initialization
  ExportingElements := False;

end.
