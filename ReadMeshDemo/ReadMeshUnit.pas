unit ReadMeshUnit;

interface

uses ANEPIE, Forms, SysUtils, Dialogs, Classes;

procedure GReadMeshPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses ParamArrayUnit, QuadMeshUnit, GetANEFunctonsUnit, OptionsUnit;

procedure GReadMeshPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  layerHandle : ANE_PTR;
  result : ANE_BOOL;
  ProjectOptions : TProjectOptions;
  LayerOptions : TLayerOptions;
  Delimiter : Char;
  NumElem, NumNodes, NumNodeParam, NumElemParam :integer;
  AString : String;
  Index : integer;
  param : PParameter_array;
  LayerName : ANE_STR;
  QuadMesh : TQuadMesh;
  ANode : TNode;
  AnElement : TQuadElement;
  AStringList : TStringList;
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
    end;
    AStringList := TStringList.Create;
    try
      layerHandle := nil;
      Delimiter := ' ';
      ProjectOptions := TProjectOptions.Create;
      try
        try
          layerHandle := ProjectOptions.GetLayerByName(funHandle,LayerName);
          ProjectOptions.NodeLinePrefix[funHandle] := NodeLinePrefix;
          ProjectOptions.ElemLinePrefix[funHandle] := ElemLinePrefix;
          ProjectOptions.ExportParameters[funHandle] := True;
          ProjectOptions.ExportWrap[funHandle] := 0;
          ProjectOptions.ExportSeparator[funHandle] := ExportSeparator;
          ProjectOptions.ExportSelectionOnly[funHandle] := False;
          Delimiter := ProjectOptions.ExportDelimiter[funHandle];
          ProjectOptions.ExportDelimiter[funHandle] := ExportDelimiter;
        except on EArgusPropertyError do
          begin
            Beep;
            MessageDlg('Warning: Unable to set one or more project properties. '
              + 'If you have manually set a project property to a non-default value,'
              + ' there may be errors in the export process.', mtWarning, [mbOK], 0);
          end;
        end;
      finally
        ProjectOptions.Free;
      end;


      if layerHandle <> nil then
      begin
        LayerOptions := TLayerOptions.Create(layerHandle);
        try
          LayerOptions.GetStrings(funHandle, AStringList);
          AString := AStringList[0];
          NumElem := StrToInt(GetNextString(AString));
          NumNodes := StrToInt(GetNextString(AString));
          NumElemParam := StrToInt(GetNextString(AString));
          NumNodeParam := StrToInt(Trim(AString));
          QuadMesh := TQuadMesh.Create;
          QuadMesh.NumElem := NumElem;
          QuadMesh.NumNodes := NumNodes;
          QuadMesh.NumElemParam := NumElemParam;
          QuadMesh.NumNodeParam := NumNodeParam;
          MeshNames.AddObject(String(LayerName),QuadMesh);
          for Index := 1 to AStringList.Count -1 do
          begin
            AString := AStringList[Index];
            if Length(AString) > 0 then
            begin
              if AString[1] = NodeLinePrefix then
              begin
                TNode.Create(QuadMesh.NodeList, AString);
              end
              else if AString[1] = ElemLinePrefix then
              begin
                TQuadElement.Create(QuadMesh.ElementList, AString);
              end;
            end;
          end;

          if (NumNodes <> QuadMesh.NodeList.Count)
            or (NumElem <> QuadMesh.ElementList.Count)
            or (NumNodes < 3) or (NumElem < 1)  then
          begin
            raise EMeshCreateError.Create('Invalid Mesh');
          end;
          if QuadMesh.NodeList.Count > 0 then
          begin
            ANode := QuadMesh.NodeList[0];
            if (ANode.Values.Count <> NumNodeParam) then
            begin
              raise EMeshCreateError.Create('Invalid Mesh');
            end;
          end;
          if QuadMesh.ElementList.Count > 0 then
          begin
            AnElement := QuadMesh.ElementList[0];
            if (AnElement.Values.Count <> NumElemParam) then
            begin
              raise EMeshCreateError.Create('Invalid Mesh');
            end;
          end;

        finally
          LayerOptions.Free(funHandle);
        end;
      end;

      ProjectOptions := TProjectOptions.Create;
      try
        try
          ProjectOptions.ExportDelimiter[funHandle] := Delimiter;
        except on EArgusPropertyError do
        end;
      finally
        ProjectOptions.Free;
      end;

    finally
      AStringList.Free;
    end;
    result := True ;

    ANE_BOOL_PTR(reply)^ := result;
  except On E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end;
end;

end.
