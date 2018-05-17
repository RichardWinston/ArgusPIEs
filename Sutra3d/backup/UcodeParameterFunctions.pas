unit UcodeParameterFunctions;

interface

uses SysUtils, Classes, Dialogs, AnePIE, RbwParser;

procedure GetEstParamName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetDeriveParamEquation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetSubstitutedDeriveParamEquation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetUseXY_InDeriveParamEquation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetParameterEstimated (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetConstrain (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetInitialValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
procedure GetMinimumValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
procedure GetMaximumValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetLowerConstraint (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetUpperConstraint (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetPerturbationParameter (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{procedure GetParamFormat (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;}

procedure GetParameterLogTransformed (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

//procedure GetPriorInformation (const refPtX : ANE_DOUBLE_PTR  ;
//			       const refPtY : ANE_DOUBLE_PTR  ;
//			       numParams : ANE_INT16          ;
//			       const parameters : ANE_PTR_PTR ;
//			       funHandle : ANE_PTR            ;
//			       reply : ANE_PTR		      ); cdecl;

procedure GetParameterUsed (const refPtX : ANE_DOUBLE_PTR ;
			   const refPtY : ANE_DOUBLE_PTR  ;
			   numParams : ANE_INT16          ;
			   const parameters : ANE_PTR_PTR ;
			   funHandle : ANE_PTR            ;
			   reply : ANE_PTR		  ); cdecl;
                               
implementation

uses ParamArrayUnit, UtilityFunctions, ANE_LayerUnit, ArgusFormUnit,
  frmSutraUnit, OptionsUnit;

var
  ParamName: string;

procedure GetEstParamName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_STR;
  param : PParameter_array;
  Index: integer;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      Row :=  param1_ptr^;

      ParamName := Trim(frmSutra.dgEstimate.Cells[Ord(ucParameter),Row]);
      for Index := 1 to Length(ParamName) do
      begin
        if ParamName[Index] = ' ' then
        begin
          ParamName[Index] := '_';
        end;
      end;

      result := PChar(ParamName);

      ANE_STR_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetDeriveParamEquation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_STR;
  param : PParameter_array;
//  Index: integer;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      Row :=  param1_ptr^;

      ParamName := Trim(frmSutra.dgEstimate.Cells[Ord(ucExpression),Row]);
      ParamName := StringReplace(ParamName, ' ', '', [rfReplaceAll]);

      result := PChar(ParamName);

      ANE_STR_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

function SubstituteFormula(funHandle : ANE_PTR; Position: integer; ParameterNames,
   VariableNames: TStringList): string;
var
  AFormula: string; 
  VariableIndex: integer;
  VIndex: integer;
  PIndex: integer;
  Layer: TLayerOptions;
  X, Y: ANE_DOUBLE;
  SubFunction: string;
  Params: TStringList;
  Functions: TStringList;
  VariableName: string;
  VarIndex: integer;
  PName: string;
  PLength: integer;
  Found: Boolean;
  CharIndex: integer;
  FollowingCharIndex: integer;
begin
  Params := TStringList.Create;
  Functions := TStringList.Create;
  try
    for VariableIndex := 0 to Length(frmSutra.UcodeParameters[Position].VariablesUsed)-1 do
    begin
      VariableName := frmSutra.UcodeParameters[Position].VariablesUsed[VariableIndex];
      VIndex := VariableNames.IndexOf(VariableName);
      if VIndex >= 0 then
      begin
        if not frmSutra.ArgusFactors[VIndex].ValueHasBeenSet then
        begin
          Layer := TLayerOptions.Create(frmSutra.ArgusFactors[VIndex].LayerHandle);
          X := frmSutra.XVar.Value;
          Y := frmSutra.YVar.Value;
          frmSutra.ArgusFactors[VIndex].Variable.Value :=
            Layer.RealValueAtXY(funHandle, X, Y,
            frmSutra.ArgusFactors[VIndex].Name);
          frmSutra.ArgusFactors[VIndex].ValueHasBeenSet := True;
        end;
      end
      else
      begin
        PIndex := ParameterNames.IndexOf(VariableName);
        if PIndex >= 0 then
        begin
          if frmSutra.UcodeParameters[PIndex].Formula <> '' then
          begin
            if frmSutra.UcodeParameters[PIndex].DependsOnXY then
            begin
              SubFunction := SubstituteFormula(funHandle, PIndex,
                ParameterNames, VariableNames);
            end
            else
            begin
              SubFunction := frmSutra.UcodeParameters[PIndex].DecompiledFormula;
            end;
            Params.Add(VariableName);
            Functions.Add(SubFunction);
          end;
        end;
      end;
    end;
  finally
    AFormula := frmSutra.UcodeParameters[Position].Expression.Decompile;
    for VarIndex := 0 to Params.Count -1 do
    begin
      PName := Params[VarIndex];
      PIndex := ParameterNames.IndexOf(PName);
      PLength := Length(PName);
      Found := True;
      While Found do
      begin
        Found := False;
        for CharIndex := 1 to Length(AFormula) do
        begin
          if Copy(AFormula, CharIndex, PLength) = PName then
          begin
            If (CharIndex = 1) or (AFormula[CharIndex-1] = '(')
              or (AFormula[CharIndex-1] = ' ') then
            begin
              FollowingCharIndex := CharIndex + PLength;
              if FollowingCharIndex <= Length(AFormula) + 1 then
              begin
                if (FollowingCharIndex = Length(AFormula) + 1)
                  or (AFormula[FollowingCharIndex] = ')')
                  or (AFormula[FollowingCharIndex] = ' ') then
                begin
                  Delete(AFormula, CharIndex, PLength);
                  Insert('(' + Functions[PIndex] + ')', AFormula, CharIndex);

                  Found := True;
                  break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    result := AFormula;
  end;

end;

procedure GetSubstitutedDeriveParamEquation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_DOUBLE_PTR;
  param3_ptr : ANE_DOUBLE_PTR;
  Row : ANE_INT32;
  result : ANE_STR;
  param : PParameter_array;
  X, Y: ANE_DOUBLE;
  AFormula: string;
  ParameterNames: TStringList;
  VariableNames: TStringList;
  Position: integer;
  Index: integer;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      Row :=  param1_ptr^;
      param2_ptr :=  param^[1];
      X :=  param2_ptr^;
      param3_ptr :=  param^[2];
      Y :=  param3_ptr^;

      Assert(Length(frmSutra.UcodeParameters) <> 0);
      for Index := 0 to Length(frmSutra.ArgusFactors) -1 do
      begin
        frmSutra.ArgusFactors[Index].ValueHasBeenSet := False;
      end;

      VariableNames := TStringList.Create;
      ParameterNames := TStringList.Create;
      try
        Assert(frmSutra.XVar <> nil);
        frmSutra.XVar.Value := X;
        Assert(frmSutra.YVar <> nil);
        frmSutra.YVar.Value := Y;

        for Index := 0 to Length(frmSutra.ArgusFactors) -1 do
        begin
          VariableNames.Add(frmSutra.ArgusFactors[Index].Name);
        end;

        for Index := 0 to Length(frmSutra.UcodeParameters) -1 do
        begin
          ParameterNames.Add(frmSutra.UcodeParameters[Index].Name);
        end;

        Position := Row-1;

        if frmSutra.UcodeParameters[Position].DependsOnXY then
        begin
          AFormula := SubstituteFormula(funHandle, Position, ParameterNames,
            VariableNames);
        end
        else
        begin
          AFormula := frmSutra.UcodeParameters[Position].DecompiledFormula;
        end

      finally
        VariableNames.Free;
        ParameterNames.Free;
      end;

      ParamName := StringReplace(AFormula, ' ', '', [rfReplaceAll]);

      result := PChar(ParamName);

      ANE_STR_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetUseXY_InDeriveParamEquation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
  Index: integer;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      Row :=  param1_ptr^;

      if frmSutra.UcodeCompiler = nil then
      begin
        frmSutra.UcodeCompiler := TRbwParser.Create(nil);
      end;

      if (Length(frmSutra.ArgusFactors) = 0)
        and (Length(frmSutra.UcodeParameters) = 0) then
      begin
        frmSutra.UpdateVariables(funHandle);
      end;
      for Index := 0 to Length(frmSutra.ArgusFactors) -1 do
      begin
        frmSutra.ArgusFactors[Index].ValueHasBeenSet := False;
      end;

      result := frmSutra.UcodeParameters[Row-1].DependsOnXY;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetParameterEstimated (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := frmSutra.dgEstimate.Checked[Ord(ucEstimate),Row] ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetConstrain (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := frmSutra.dgEstimate.Checked[Ord(ucConstrain),Row] ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetInitialValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := InternationalStrToFloat(frmSutra.dgEstimate.Cells[Ord(ucInitialValue),Row]);
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMinimumValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := InternationalStrToFloat(frmSutra.dgEstimate.Cells[Ord(ucMin),Row]);
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMaximumValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := InternationalStrToFloat(frmSutra.dgEstimate.Cells[Ord(ucMax),Row]);
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetLowerConstraint (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := InternationalStrToFloat(frmSutra.dgEstimate.Cells[Ord(ucLowerConstraint),Row]);
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;


procedure GetUpperConstraint (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := InternationalStrToFloat(frmSutra.dgEstimate.Cells[Ord(ucUpperConstraint),Row]);
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;


procedure GetPerturbationParameter (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  Row : ANE_INT32;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := InternationalStrToFloat(frmSutra.dgEstimate.Cells[Ord(ucPerturbation),Row]);
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

{procedure GetParamFormat (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_STR;
  SResult: string;
  param : PParameter_array;
  Index: integer;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      Row :=  param1_ptr^;


      SResult := Trim(frmSutra.dgEstimate.Cells[Ord(ucParameter),Row]);
      while Length(SResult) < 11 do
      begin
        SResult := SResult + ',';
      end;
      for Index := 1 to Length(SResult) do
      begin
        if SResult[Index] = ' ' then
        begin
          SResult[Index] := '_';
        end;
      end;
      SResult := '!' + SResult + '!';

      result := PChar(SResult);


      ANE_STR_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;  }

procedure GetParameterLogTransformed (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  Row : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
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
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;

      result := frmSutra.dgEstimate.Checked[Ord(ucLog),Row] ;
      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

{var
  PriorInformationEquation: string;

procedure GetPriorInformation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_STR;
  param : PParameter_array;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      Row :=  param1_ptr^;

      PriorInformationEquation := frmSutra.PriorInfoEquation(Row);

      result := PChar(PriorInformationEquation);

      ANE_STR_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;   }

procedure GetParameterUsed (const refPtX : ANE_DOUBLE_PTR ;
			   const refPtY : ANE_DOUBLE_PTR  ;
			   numParams : ANE_INT16          ;
			   const parameters : ANE_PTR_PTR ;
			   funHandle : ANE_PTR            ;
			   reply : ANE_PTR		  ); cdecl;
var
  param1 : ANE_STR;
  result : ANE_INT32;
  param : PParameter_array;
  Params: TStringList;
  Index: integer;
  Parameter: string;
begin
  if EditWindowOpen then
  begin
    Beep;
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
      param1 :=  param^[0];
      Parameter := string(param1);

      Params := TStringList.Create;
      try
        Params.Assign(frmSutra.dgEstimate.Cols[Ord(ucParameter)]);
        while Params.Count > frmSutra.dgEstimate.RowCount do
        begin
          Params.Delete(Params.Count -1);
        end;
        Params.Delete(0);
        result := 0;
        for Index := 0 to Params.Count -1 do
        begin
          if Params[Index] = Parameter then
          begin
            result := Index+1;
            Break;
          end;
        end;
      finally
        Params.Free;
      end;

      ANE_INT32_PTR(reply)^ := result;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

end.
