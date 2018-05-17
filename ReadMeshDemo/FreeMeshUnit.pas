unit FreeMeshUnit;

interface

uses ANEPIE, SysUtils, Dialogs;

procedure GFreeMeshPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses ParamArrayUnit, QuadMeshUnit, GetANEFunctonsUnit;

procedure GFreeMeshPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
  Index : integer;
  param : PParameter_array;
  LayerName : ANE_STR;
  QuadMesh : TQuadMesh;
begin
  result := False;
  try
    param := @parameters^;
    LayerName := param^[0];
    Index := MeshNames.IndexOf(String(LayerName));
    if Index > -1 then
    begin
      QuadMesh := MeshNames.Objects[Index] as TQuadMesh;
      QuadMesh.Free;
      MeshNames.Delete(Index);
      result := True ;
    end;

    ANE_BOOL_PTR(reply)^ := result;
  except On E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end;
end;

end.
