unit GetCounts;

interface

uses Sysutils, ANEPIE;

procedure GNumElemPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GNumNodesPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GNumElemParamPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GNumNodeParamPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


implementation

uses ParamArrayUnit, QuadMeshUnit , GetANEFunctonsUnit{, OptionsUnit};

procedure GNumElemPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  Index : integer;
  param : PParameter_array;
  LayerName : ANE_STR;
  QuadMesh : TQuadMesh;
begin
  result := 0;
  try // try 1
    param := @parameters^;
    LayerName := param^[0];
    Index := MeshNames.IndexOf(String(LayerName));
    if Index > -1 then
    begin
      QuadMesh := MeshNames.Objects[Index] as TQuadMesh;
      result := QuadMesh.NumElem;
    end; // if Index > -1 then

    ANE_INT32_PTR(reply)^ := result;
  except On E: Exception do // try 1
    begin
      ANE_INT32_PTR(reply)^ := result;
    end;
  end; // try 1
end;

procedure GNumNodesPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  Index : integer;
  param : PParameter_array;
  LayerName : ANE_STR;
  QuadMesh : TQuadMesh;
begin
  result := 0;
  try // try 1
    param := @parameters^;
    LayerName := param^[0];
    Index := MeshNames.IndexOf(String(LayerName));
    if Index > -1 then
    begin
      QuadMesh := MeshNames.Objects[Index] as TQuadMesh;
      result := QuadMesh.NumNodes;
    end; // if Index > -1 then

    ANE_INT32_PTR(reply)^ := result;
  except On E: Exception do // try 1
    begin
      ANE_INT32_PTR(reply)^ := result;
    end;
  end; // try 1
end;

procedure GNumElemParamPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  Index : integer;
  param : PParameter_array;
  LayerName : ANE_STR;
  QuadMesh : TQuadMesh;
begin
  result := 0;
  try // try 1
    param := @parameters^;
    LayerName := param^[0];
    Index := MeshNames.IndexOf(String(LayerName));
    if Index > -1 then
    begin
      QuadMesh := MeshNames.Objects[Index] as TQuadMesh;
      result := QuadMesh.NumElemParam;
    end; // if Index > -1 then

    ANE_INT32_PTR(reply)^ := result;
  except On E: Exception do // try 1
    begin
      ANE_INT32_PTR(reply)^ := result;
    end;
  end; // try 1
end;

procedure GNumNodeParamPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  Index : integer;
  param : PParameter_array;
  LayerName : ANE_STR;
  QuadMesh : TQuadMesh;
begin
  result := 0;
  try // try 1
    param := @parameters^;
    LayerName := param^[0];
    Index := MeshNames.IndexOf(String(LayerName));
    if Index > -1 then
    begin
      QuadMesh := MeshNames.Objects[Index] as TQuadMesh;
      result := QuadMesh.NumNodeParam;
    end; // if Index > -1 then

    ANE_INT32_PTR(reply)^ := result;
  except On E: Exception do // try 1
    begin
      ANE_INT32_PTR(reply)^ := result;
    end;
  end; // try 1
end;




end.
