unit ZFunction;

interface

uses AnePIE, VirtualMeshUnit;

procedure GetZ (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetLayer (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  CurrentVertex : TVirtualNode;
  CurrentElement : TVirtualElement;

implementation

uses
  VirtualMeshFunctions;

procedure GetZ (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
begin
  if ExportingElements then
  begin
    if CurrentElement = nil then
    begin
      result := 1;
    end
    else
    begin
      result := CurrentElement.ElZ;
    end;
  end
  else
  begin
    if CurrentVertex = nil then
    begin
      result := 1;
    end
    else
    begin
      result := CurrentVertex.Z;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetLayer (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
begin
  if ExportingElements then
  begin
    if CurrentElement = nil then
    begin
      result := 1;
    end
    else
    begin
      result := CurrentElement.Layer;
    end;
  end
  else
  begin
    if CurrentVertex = nil then
    begin
      result := 1;
    end
    else
    begin
      result := CurrentVertex.Layer;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

end.
