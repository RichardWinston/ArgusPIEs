unit InitializeVertexUnit;

interface

uses Classes, SysUtils, {Dialogs,} ANEPIE;

function GInitializeVertex : ANE_BOOL;

procedure GInitializeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit, CellVertexUnit, CombinedListUnit, InitializeLists;

function GInitializeVertex : ANE_BOOL;
begin
  if GridImportOK then
  begin
    ClearAndInitializeMainLists;

    result := True;
  end // if GridImportOK then
  else
  begin
    result := False;
  end;
end;

procedure GInitializeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
begin
  try
    begin
      result := GInitializeVertex;
    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

end.
