unit SuperfishUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Controls, Dialogs, Classes, Forms,

  // We need to use the appropriate units. In this example, we have an import
  // PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
  AnePIE, ImportPIE, NodeElementUnit, BoundaryContourUnit;

procedure GSuperFishnetPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;

procedure GGetXCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR; numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR; aneHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GGetYCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR; numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR; aneHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GSetCounts(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR; numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR; aneHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, frmSutraUnit, ParamNamesAndTypes, FunctionPIE,
  ParamArrayUnit, ANE_LayerUnit, ArgusFormUnit, SLGroupLayers, SLSutraMesh,
  SLFishnetMeshLayout, UtilityFunctions;

// global variables.
var
  XCount, YCount: ANE_INT32;

function GetSutraMeshHandles(aneHandle: ANE_PTR;
  out SutraMeshHandle: ANE_PTR; N, Extension: string): boolean;
begin
  SutraMeshHandle := GetLayerHandle(aneHandle,
    TSutraMeshLayer.ANE_LayerName + Extension + N);
  result := (SutraMeshHandle <> nil);

  if not result then
  begin
    Beep;
    MessageDlg(TSutraMeshLayer.ANE_LayerName + Extension + N + ' not found!',
      mtError, [mbOK], 0);
  end;
end;

function GetSutraBasicHandles(aneHandle: ANE_PTR; out SutraMeshHandle,
  FishNetLayoutHandle: ANE_PTR; N, Extension: string): boolean;
begin
  result := GetSutraMeshHandles(aneHandle, SutraMeshHandle, N, Extension);

  if result then
  begin
    FishNetLayoutHandle := GetLayerHandle(aneHandle,
      TFishnetMeshLayout.ANE_LayerName + Extension + N);

    result := (FishNetLayoutHandle <> nil);

    if not result then
    begin
      Beep;
      MessageDlg(TFishnetMeshLayout.ANE_LayerName + N + ' not found!', mtError,
        [mbOK], 0);
    end;
  end;
end;

function GetParamIndicies(aneHandle: ANE_PTR; FishNetLayoutHandle: ANE_PTR;
  var XElementIndex, YElementIndex: integer; N, Extension: string): boolean;
begin
  XElementIndex := UGetParameterIndex(aneHandle,
    FishNetLayoutHandle, TElemInXParam.ANE_ParamName);
  result := (XElementIndex > -1);
  if not result then
  begin
    Beep;
    MessageDlg(TElemInXParam.ANE_ParamName + ' not found on '
      + TFishnetMeshLayout.ANE_LayerName + Extension + N + '!', mtError, [mbOK],
      0);
  end;

  if result then
  begin
    YElementIndex := UGetParameterIndex(aneHandle,
      FishNetLayoutHandle, TElemInYParam.ANE_ParamName);
    result := (YElementIndex > -1);
    if not result then
    begin
      Beep;
      MessageDlg(TElemInYParam.ANE_ParamName + ' not found on '
        + TFishnetMeshLayout.ANE_LayerName + Extension + N + '!', mtError,
        [mbOK], 0);
    end;
  end;
end;

procedure GSuperFishnetPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;
var
  SutraMeshHandle, FishNetLayoutHandle: ANE_PTR;
  OK: boolean;
  XElementIndex, YElementIndex: integer;
  Fishnet: TFishnet;
  MeshStringList: TStringList;
  ImportText: string;
  N: string;
  MeshLayer: TLayerOptions;
  AString: ANE_STR;
  CurrentLayer: TLayerOptions;
  CurrentLayerName: string;
  Root1, Root2: string;
  Extension: string;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
      ' project if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    try // try 1
      begin
        try
          CurrentLayer := TLayerOptions.Create(ANE_LayerGetCurrent(aneHandle));
          try
            CurrentLayerName := CurrentLayer.Name[aneHandle];
          finally
            CurrentLayer.Free(aneHandle);
          end;

          Root1 := TSutraMeshLayer.ANE_LayerName;
          Root2 := TFishnetMeshLayout.ANE_LayerName;

          if (CurrentLayerName = Root1) or (CurrentLayerName = Root2) then
          begin
            N := '';
          end
          else if Pos(Root1, CurrentLayerName) > 0 then
          begin
            N := CurrentLayerName;
            Delete(N, Pos(Root1, CurrentLayerName), Length(Root1));
          end
          else if Pos(Root2, CurrentLayerName) > 0 then
          begin
            N := CurrentLayerName;
            Delete(N, Pos(Root2, CurrentLayerName), Length(Root2));
          end
          else
          begin
            Beep;
            MessageDlg('You must be on the ' + Root1 +
              ' layer to create a fishnet mesh.',
              mtError, [mbOK], 0);
            Exit;
          end;
          Extension := '';
          if Pos(KBottom, N) > 0 then
          begin
            Delete(N, Pos(KBottom, N), Length(KBottom));
            Extension := KBottom;
          end
          else if Pos(KTop, N) > 0 then
          begin
            Delete(N, Pos(KTop, N), Length(KTop));
            Extension := KTop;
          end;

          if N <> '' then
          begin
            try
              StrToInt(N);
            except on EConvertError do
              begin
                Beep;
                MessageDlg('You must be on the ' + Root1 +
                  ' layer to create a fishnet mesh.',
                  mtError, [mbOK], 0);
                Exit;
              end;
            end;
          end;

          frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
            as TfrmSutra;

          OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
            FishNetLayoutHandle, N, Extension);

          if OK then
          begin
            OK := GetParamIndicies(aneHandle, FishNetLayoutHandle,
              XElementIndex, YElementIndex, N, Extension);
          end;

          if OK then
          begin
            MeshLayer := TLayerOptions.Create(FishNetLayoutHandle);
            try
              Fishnet := TFishnet.Create(MeshLayer, XElementIndex,
                YElementIndex,
                aneHandle);
              try
                if Fishnet.error then Exit;
                Fishnet.CreateMesh;

                if OK then
                begin
                  MeshStringList := TStringList.Create;
                  try
                    Fishnet.WriteMesh(MeshStringList);
                    ImportText := MeshStringList.Text;
                    GetMem(AString, Length(ImportText) + 1);
                    try
                      StrPCopy(AString, ImportText);

                      ANE_ImportTextToLayer(aneHandle, AString);
                    finally
                      FreeMem(AString);
                    end;
                  finally
                    MeshStringList.Free;
                  end;
                end;
              finally
                Fishnet.Free
              end;
            finally
              MeshLayer.Free(aneHandle);
            end;
          end;
        except on E: Exception do
          begin
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
          end;
        end;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else

end;

procedure GGetXCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR; numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR; aneHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
begin
  if XCount < YCount then
  begin
    result := XCount
  end
  else
  begin
    result := YCount
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetYCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR; numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR; aneHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
begin
  if XCount >= YCount then
  begin
    result := XCount
  end
  else
  begin
    result := YCount
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GSetCounts(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR; numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR; aneHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  SutraMeshHandle, FishNetLayoutHandle: ANE_PTR;
  OK: boolean;
  XElementIndex, YElementIndex: integer;
  Fishnet: TFishnet;
  N: string;
  result: ANE_BOOL;
  ANE_N: ANE_STR;
  param: PParameter_array;
  MeshLayer: TLayerOptions;
  Extension: string;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
      ' project if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    try // try 1
      begin

        frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
          as TfrmSutra;

        result := True;

        param := @parameters^;
        ANE_N := param^[0];

        N := string(ANE_N);
        if N = '1' then
        begin
          N := '';
          Extension := kTop;
        end
        else
        begin
          Assert(N = '');
          Extension := '';
        end;

        try
          OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
            FishNetLayoutHandle, N, Extension);

          if OK then
          begin
            OK := GetParamIndicies(aneHandle, FishNetLayoutHandle,
              XElementIndex, YElementIndex, N, Extension);
          end;

          if OK then
          begin
            MeshLayer := TLayerOptions.Create(FishNetLayoutHandle);
            try
              Fishnet := TFishnet.Create(MeshLayer, XElementIndex,
                YElementIndex,
                aneHandle);
              try
                XCount := Fishnet.ColumnNodeCount;
                YCount := Fishnet.RowNodeCount;
              finally
                Fishnet.Free
              end;
            finally
              MeshLayer.Free(aneHandle);
            end;
          end;
        except on E: Exception do
          begin
            result := False;
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
          end;
        end;
        ANE_BOOL_PTR(reply)^ := result;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

end.

