unit UcodePriorInfoFunctions;

interface

uses SysUtils, Classes, Dialogs, AnePIE;

procedure Sutra_PriorInfoName (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure Sutra_PriorInfoUseFlag (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure Sutra_PriorInfoEqExpression (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure Sutra_PriorInfoEqValue (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure Sutra_PriorInfoStatistic (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure Sutra_PriorInfoStatFlag (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

implementation

uses ParamArrayUnit, UtilityFunctions, ANE_LayerUnit, ArgusFormUnit, frmSutraUnit;

var
  ParamName: string;

procedure Sutra_PriorInfoName (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
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

      ParamName := Trim(frmSutra.dgPriorEquations.Cells[Ord(picName),Row]);
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

procedure Sutra_PriorInfoUseFlag (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_BOOL;
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

      result := frmSutra.dgPriorEquations.Checked[Ord(picUseEquation),Row];

      ANE_BOOL_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure Sutra_PriorInfoEqExpression (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
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

      ParamName := Trim(frmSutra.dgPriorEquations.Cells[Ord(picEquation),Row]);
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

procedure Sutra_PriorInfoEqValue (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_DOUBLE;
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

      result := StrToFloat(frmSutra.dgPriorEquations.Cells[Ord(picValue),Row]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure Sutra_PriorInfoStatistic (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;
  result : ANE_DOUBLE;
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

      result := StrToFloat(frmSutra.dgPriorEquations.Cells[Ord(picStatistic),Row]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure Sutra_PriorInfoStatFlag (const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
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

      ParamName := Trim(frmSutra.dgPriorEquations.Cells[Ord(picStatFlag),Row]);
      Index := frmSutra.dgPriorEquations.Columns[Ord(picStatFlag)].PickList.IndexOf(ParamName);
      Assert((Index >= 0) and (Index <= 4));
      case Index of
        0:
          begin
            ParamName := 'VAR';
          end;
        1:
          begin
            ParamName := 'SD';
          end;
        2:
          begin
            ParamName := 'CV';
          end;
        3:
          begin
            ParamName := 'WT';
          end;
        4:
          begin
            ParamName := 'SQRWT';
          end;
      else Assert(False);
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

end.
