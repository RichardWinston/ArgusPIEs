unit ExportElements;

interface

Uses SysUtils, Dialogs, Classes, ANEPIE ;

procedure GExportElementsPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


implementation

uses ParamArrayUnit, QuadMeshUnit, GetANEFunctonsUnit, OptionsUnit;

procedure GExportElementsPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
  Index : integer;
  param : PParameter_array;
  LayerName, ParamName, FileName : ANE_STR;
  QuadMesh : TQuadMesh;
  ProjectOptions : TProjectOptions;
  LayerHandle : ANE_PTR;
  LayerOptions : TLayerOptions;
  ParamIndex : integer;
  FullPath : String;
  AStringList : TStringList;
  AnElement : TQuadElement;
  F : TextFile;
begin
  result := False;
  try // try 1
    param := @parameters^;
    LayerName := param^[0];
    ParamName := param^[1];
    FileName := param^[2];
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
              AStringList := TStringList.Create;
              try
                for Index := 0 to QuadMesh.ElementList.Count -1 do
                begin
                  AnElement := QuadMesh.ElementList[Index];
                  AStringList.Add(AnElement.Values[ParamIndex]);
                end;
                FullPath := GetCurrentDir + '\' + String(FileName);
                if FileExists(FullPath) then
                begin
                  AssignFile(f, FullPath);
                  try
                    Append(f);
                    for Index := 0 to AStringList.Count -1 do
                    begin
                      Writeln(f, AStringList[Index]);
                    end;
                  finally
                    CloseFile(f);
                  end;
                end
                else // if FileExists(FullPath) then
                begin
                  AStringList.SaveToFile(FullPath);
                end; // if FileExists(FullPath) then
                result := True ;
              finally // try 4
                AStringList.Free;
              end; // try 4
            end; // if ParamIndex > -1 then
          finally // try 3
            LayerOptions.Free(funHandle);
          end; // try 3
        end; // if LayerHandle <> nil then
      finally // try 2
        ProjectOptions.Free;
      end; // try 2
    end; // if Index > -1 then

    ANE_BOOL_PTR(reply)^ := result;
  except On E: Exception do // try 1
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      result := False;
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end; // try 1
end;

end.

