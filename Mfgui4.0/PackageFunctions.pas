unit PackageFunctions;

interface

uses SysUtils, Classes, Dialogs, contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization, WriteLakesUnit, WriteReservoirUnit;

procedure InitializeBlock(funHandle : ANE_PTR);
procedure GFreeBlock(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GExportLake (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GInitializeLake (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GLakeNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GExportReservoir (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GInitializeReservoir (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GReservoirNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetIbound (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Variables, ModflowUnit, PointInsideContourUnit, WriteNameFileUnit,
  UtilityFunctions, ANE_LayerUnit, ArgusFormUnit, InitializeBlockUnit,
  FreeBlockUnit, ParamArrayUnit, RunUnit, ProgressUnit;

var
  GridInitialized : boolean = False;
  LakeWriter : TLakeWriter = nil;
  ReservoirWriter : TReservoirWriter = nil;
  DiscretizationWriter : TDiscretizationWriter = nil;
  BasicPkgWriter : TBasicPkgWriter = nil;

procedure GExportLake (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Root : string;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try
      result := True;
      try
        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        Root := frmMODFLOW.adeFileName.Text;

        if not GridInitialized then
        begin
          InitializeBlock(funHandle);
        end;
        if DiscretizationWriter = nil then
        begin
          DiscretizationWriter := TDiscretizationWriter.Create;
          DiscretizationWriter.SetVariables(funHandle);
        end;
        if BasicPkgWriter = nil then
        begin
          BasicPkgWriter := TBasicPkgWriter.Create;
          BasicPkgWriter.InitializeButDontWrite(funHandle,DiscretizationWriter);
        end;
        LakeWriter := TLakeWriter.Create;
        LakeWriter.WriteFile96(funHandle, Root, BasicPkgWriter);
      except
        result := False;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GInitializeLake (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Root : string;
//  BasicPkgWriter : TBasicPkgWriter;
//  DiscretizationWriter : TDiscretizationWriter;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try
      result := True;
      try
        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        Root := frmMODFLOW.adeFileName.Text;

        if not GridInitialized then
        begin
          InitializeBlock(funHandle);
        end;

        if DiscretizationWriter = nil then
        begin
          DiscretizationWriter := TDiscretizationWriter.Create;
          DiscretizationWriter.SetVariables(funHandle);
        end;
        if BasicPkgWriter = nil then
        begin
          BasicPkgWriter := TBasicPkgWriter.Create;
          BasicPkgWriter.InitializeButDontWrite(funHandle,DiscretizationWriter);
        end;
        LakeWriter := TLakeWriter.Create;
        LakeWriter.InitializeArrays(funHandle, DiscretizationWriter,
          BasicPkgWriter, False);

      except
        result := False;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GInitializeReservoir (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Root : string;
//  BasicPkgWriter : TBasicPkgWriter;
//  DiscretizationWriter : TDiscretizationWriter;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try
      result := True;
      try
        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        Root := frmMODFLOW.adeFileName.Text;

        if not GridInitialized then
        begin
          InitializeBlock(funHandle);
        end;

        if DiscretizationWriter = nil then
        begin
          DiscretizationWriter := TDiscretizationWriter.Create;
          DiscretizationWriter.SetVariables(funHandle);
        end;
        if BasicPkgWriter = nil then
        begin
          BasicPkgWriter := TBasicPkgWriter.Create;
          BasicPkgWriter.InitializeButDontWrite(funHandle,DiscretizationWriter);
        end;
        ReservoirWriter := TReservoirWriter.Create;
        ReservoirWriter.InitializeArrays(funHandle, DiscretizationWriter,
          BasicPkgWriter, False);

      except
        result := False;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GLakeNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  ColIndex, RowIndex, LayerIndex : ANE_INT32;
  param : PParameter_array;
  paramPtr : ANE_INT32_PTR;
  Result : ANE_INT32;
begin
  if LakeWriter = nil then
  begin
    Result := 0;
  end
  else
  begin
    param := @parameters^;
    paramPtr :=  param^[0];
    ColIndex :=  paramPtr^;
    paramPtr :=  param^[1];
    RowIndex :=  paramPtr^;
    paramPtr :=  param^[2];
    LayerIndex :=  paramPtr^;
    result := LakeWriter.LakeNumberArray[ColIndex-1,RowIndex-1,LayerIndex-1];
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GReservoirNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  ColIndex, RowIndex : ANE_INT32;
  param : PParameter_array;
  paramPtr : ANE_INT32_PTR;
  Result : ANE_INT32;
begin
  if ReservoirWriter = nil then
  begin
    Result := 0;
  end
  else
  begin
    param := @parameters^;
    paramPtr :=  param^[0];
    ColIndex :=  paramPtr^;
    paramPtr :=  param^[1];
    RowIndex :=  paramPtr^;
    result := ReservoirWriter.ReservoirLayerArray[ColIndex-1,RowIndex-1];
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure InitializeBlock(funHandle : ANE_PTR);
begin
  GInitializeBlock(funHandle,
    PChar(ModflowTypes.GetGridLayerType.ANE_LayerName), 0);
  GridInitialized := True;
end;

procedure GFreeBlock(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
begin
  result := True;
  try
    if GridInitialized then
      begin
        GListFreeBlock;
      end;
    GridInitialized := False;
    LakeWriter.Free;
    LakeWriter := nil;
    DiscretizationWriter.Free;
    DiscretizationWriter := nil;
    BasicPkgWriter.Free;
    BasicPkgWriter := nil;
    ReservoirWriter.Free;
    ReservoirWriter := nil;
  except
    result := False;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GExportReservoir (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Root : string;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try
      result := True;
      try
        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        Root := frmMODFLOW.adeFileName.Text;

        if not GridInitialized then
        begin
          InitializeBlock(funHandle);
        end;
        if DiscretizationWriter = nil then
        begin
          DiscretizationWriter := TDiscretizationWriter.Create;
          DiscretizationWriter.SetVariables(funHandle);
        end;
        if BasicPkgWriter = nil then
        begin
          BasicPkgWriter := TBasicPkgWriter.Create;
          BasicPkgWriter.InitializeButDontWrite(funHandle,DiscretizationWriter);
        end;
        ReservoirWriter := TReservoirWriter.Create;
        ReservoirWriter.WriteFile96(funHandle, Root, BasicPkgWriter);
      except
        result := False;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GGetIbound (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  ColIndex, RowIndex, LayerIndex : ANE_INT32;
  param : PParameter_array;
  paramPtr : ANE_INT32_PTR;
  Result : ANE_INT32;
begin
  if BasicPkgWriter = nil then
  begin
    Result := 0;
  end
  else
  begin
    param := @parameters^;
    paramPtr :=  param^[0];
    ColIndex :=  paramPtr^;
    paramPtr :=  param^[1];
    RowIndex :=  paramPtr^;
    paramPtr :=  param^[2];
    LayerIndex :=  paramPtr^;
    result := BasicPkgWriter.MFIBOUND[ColIndex-1,RowIndex-1,LayerIndex-1];
  end;
  ANE_INT32_PTR(reply)^ := result;
end;


Initialization

finalization
  LakeWriter.Free;
  DiscretizationWriter.Free;
  BasicPkgWriter.Free;
  ReservoirWriter.Free;
end.
