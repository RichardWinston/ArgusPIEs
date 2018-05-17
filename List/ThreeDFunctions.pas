unit ThreeDFunctions;

interface

uses AnePIE, Sysutils;

procedure GPIEAdd3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESubtract3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEMultiply3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEDivide3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEMultiply3DListByConstantMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEInvert3DListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses AListUnit;

Type T3DOperation = (opAdd, opSubtract, opMultiply, opDivide);

function Perform3DOperation  (const parameters : ANE_PTR_PTR;
         AnOperation : T3DOperation ) : boolean;
var
  FirstReal, SecondReal, ResultReal : TReal;
  FirstList, SecondList, ResultList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  FirstListIndex : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  SecondListIndex : ANE_INT32;          // X position in list of item
  param3_ptr : ANE_INT32_PTR;
  ResultListIndex : ANE_INT32;          // Y position in list of item
  param : PParameter_array;
  Index : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      FirstListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      SecondListIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      ResultListIndex :=  param3_ptr^;
      FirstList := Main3DList.Items[FirstListIndex];
      SecondList := Main3DList.Items[SecondListIndex];
      ResultList := Main3DList.Items[ResultListIndex];
      If (FirstList.MaxX <> SecondList.MaxX) or (FirstList.MaxX <> ResultList.MaxX) or
         (FirstList.MaxY <> SecondList.MaxY) or (FirstList.MaxY <> ResultList.MaxY) or
         (FirstList.MaxZ <> SecondList.MaxZ) or (FirstList.MaxZ <> ResultList.MaxZ)
      then
      begin
          result := False;
          Inc(ErrorCount);
      end
      else
      begin
        for Index := 0 to FirstList.Count -1 do
        begin
          FirstReal := FirstList.Items[Index];
          SecondReal := SecondList.Items[Index];
          ResultReal := ResultList.Items[Index];
          case AnOperation of
            opAdd      :
            begin
              ResultReal.Value := FirstReal.Value + SecondReal.Value;
            end;
            opSubtract :
            begin
              ResultReal.Value := FirstReal.Value - SecondReal.Value;
            end;
            opMultiply :
            begin
              ResultReal.Value := FirstReal.Value * SecondReal.Value;
            end;
            opDivide   :
            begin
              try
                ResultReal.Value := FirstReal.Value / SecondReal.Value;
              except on EDivByZero do
                ResultReal.Value := 0;
              end;

            end;
          end;
        end;
        result := True;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
end;


procedure GPIEAdd3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  ANE_BOOL_PTR(reply)^ := Perform3DOperation(parameters, opAdd);
end;

procedure GPIESubtract3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  ANE_BOOL_PTR(reply)^ := Perform3DOperation(parameters, opSubtract);
end;

procedure GPIEMultiply3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  ANE_BOOL_PTR(reply)^ := Perform3DOperation(parameters, opMultiply);
end;

procedure GPIEDivide3DListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  ANE_BOOL_PTR(reply)^ := Perform3DOperation(parameters, opDivide);
end;

procedure GPIEMultiply3DListByConstantMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal, ResultReal: TReal;
  A3DList, ResultList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  ResultListIndex : ANE_INT32;          // Y position in list of item
  param3_ptr : ANE_DOUBLE_PTR;
  AConstant : ANE_DOUBLE;          // X position in list of item
  result : ANE_BOOL;
  param : PParameter_array;
  Index : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      ResultListIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      AConstant :=  param3_ptr^;
      A3DList := Main3DList.Items[ListIndex];
      ResultList := Main3DList.Items[ResultListIndex];
      If (A3DList.MaxX <> ResultList.MaxX) or
         (A3DList.MaxY <> ResultList.MaxY) or
         (A3DList.MaxZ <> ResultList.MaxZ)
      then
      begin
          result := False;
          Inc(ErrorCount);
      end
      else
      begin
        for Index := 0 to A3DList.Count -1 do
        begin
          AReal := A3DList.Items[Index];
          ResultReal := ResultList.Items[Index];
          ResultReal.Value := AReal.Value * AConstant;
        end;
        result := True;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEInvert3DListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal, ResultReal: TReal;
  A3DList, ResultList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  ResultListIndex : ANE_INT32;          // Y position in list of item
  result : ANE_BOOL;
  param : PParameter_array;
  Index : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      ResultListIndex :=  param2_ptr^;
      A3DList := Main3DList.Items[ListIndex];
      ResultList := Main3DList.Items[ResultListIndex];
      If (A3DList.MaxX <> ResultList.MaxX) or
         (A3DList.MaxY <> ResultList.MaxY) or
         (A3DList.MaxZ <> ResultList.MaxZ)
      then
      begin
          result := False;
          Inc(ErrorCount);
      end
      else
      begin
        for Index := 0 to A3DList.Count -1 do
        begin
          AReal := A3DList.Items[Index];
          ResultReal := ResultList.Items[Index];
          if AReal.Value = 0 then
          begin
            ResultReal.Value := 0;
            Inc(ErrorCount);
          end
          else
          begin
            ResultReal.Value := 1/AReal.Value;
          end
        end;
        result := True;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;


end.
