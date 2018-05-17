unit StringPIEFunctions;

interface

uses AnePIE, ANECB, SysUtils;

procedure GetSpreadSheetName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetGridSheetName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetContourSheetName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


procedure GetContourNameColumnName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;



implementation

uses  ExcelLink;

procedure GetSpreadSheetName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  Result : ANE_STR;
begin
  ANE_GetPIEProjectHandle(funHandle, @frmExcelLink );
  result := PChar(frmExcelLink.SpreadsheetName) ;
  ANE_STR_PTR(reply)^ := result;
end;

procedure GetGridSheetName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  Result : ANE_STR;
begin
  ANE_GetPIEProjectHandle(funHandle, @frmExcelLink );
  result := PChar(frmExcelLink.GridSheet) ;
  ANE_STR_PTR(reply)^ := result;
end;

procedure GetContourSheetName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  Result : ANE_STR;
begin
  ANE_GetPIEProjectHandle(funHandle, @frmExcelLink );
  result := PChar(frmExcelLink.ContourSheet) ;
  ANE_STR_PTR(reply)^ := result;
end;

procedure GetContourNameColumnName (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  Result : ANE_INT32;
begin
  ANE_GetPIEProjectHandle(funHandle, @frmExcelLink );
  Try
    begin
      result := StrToInt(frmExcelLink.ContourNameColumn) ;
    end
  except On Exception do
    begin
      result := 1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;


end.
