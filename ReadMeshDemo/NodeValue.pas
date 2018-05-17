unit NodeValue;

interface

Uses SysUtils, Dialogs, Classes, ANEPIE ;

procedure GNodesValuePIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


implementation

uses ParamArrayUnit, QuadMeshUnit, GetANEFunctonsUnit, OptionsUnit;

procedure GNodesValuePIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_STR;
  Index : integer;
  param : PParameter_array;
  LayerName, ParamName : ANE_STR;
  QuadMesh : TQuadMesh;
  ProjectOptions : TProjectOptions;
  LayerHandle : ANE_PTR;
  LayerOptions : TLayerOptions;
  NodeIndexPtr : ANE_INT32_PTR;
  NodeIndex : ANE_INT32;
  ParamIndex : ANE_INT32;
  ANode : TNode;
begin
  result := '$NAN';
  try // try 1
    param := @parameters^;
    LayerName := param^[0];
    ParamName := param^[1];
    NodeIndexPtr := param^[2];
    NodeIndex :=  NodeIndexPtr^ -1;
    Index := MeshNames.IndexOf(String(LayerName));
    if Index > -1 then
    begin
      QuadMesh := MeshNames.Objects[Index] as TQuadMesh;

      ProjectOptions := TProjectOptions.Create;
      try  // try 2
        LayerHandle := ProjectOptions.GetLayerByName(funHandle, LayerName);
        if LayerHandle <> nil then
        begin
          LayerOptions := TLayerOptions.Create(LayerHandle);
          try // try 3
            ParamIndex := LayerOptions.GetParameterIndex(funHandle, ParamName);
            if ParamIndex > -1 then
            begin
              ANode := QuadMesh.NodeList[NodeIndex];
              result := PChar(ANode.Values[ParamIndex]);
            end; // if ParamIndex > -1 then
          finally // try 3
            LayerOptions.Free(funHandle);
          end; // try 3
        end; // if LayerHandle <> nil then
      finally // try 2
        ProjectOptions.Free;
      end; // try 2
    end; // if Index > -1 then

    ANE_STR_PTR(reply)^ := result;
  except On E: Exception do // try 1
    begin
      result := '$NAN';
      ANE_STR_PTR(reply)^ := result;
    end;
  end; // try 1
end;

end.
 