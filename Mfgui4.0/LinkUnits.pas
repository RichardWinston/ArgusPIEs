unit LinkUnits;

interface

uses Sysutils, Dialogs, AnePIE;

procedure GLinkUnitsPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

uses Variables, OptionsUnit, GetTypesUnit;

Procedure LinkLayerElevations(ModelHandle : ANE_PTR);
var
  Index : integer;
  TopLayer : TLayerOptions;
  LayerName, ParameterName : string;
  TopParameter : TParameterOptions;
  Project : TProjectOptions;
  LayerHandle : ANE_PTR;
begin
  Project := TProjectOptions.Create;
  try
    Index := 2;
    LayerName := ModflowTypes.GetMFTopElevLayerType.WriteNewRoot
      + IntToStr(Index);
    LayerHandle := Project.GetLayerByName(ModelHandle,LayerName);
    if LayerHandle <> nil then
    begin
      TopLayer := TLayerOptions.Create(LayerHandle);
      try
        while LayerHandle <> nil do
        begin
          ParameterName := ModflowTypes.GetMFTopElevParamType.WriteParamName
            + IntToStr(Index);
          TopParameter := TParameterOptions.CreateWithNameAndLayer
            (TopLayer,ParameterName,ModelHandle);
          try
            TopParameter.Expr[ModelHandle] :=
              ModflowTypes.GetBottomElevLayerType.WriteNewRoot
              + IntToStr(Index-1)
              + '.'
              + ModflowTypes.GetMFBottomElevParamType.WriteParamName
              + IntToStr(Index-1);
          finally
            TopParameter.Free;
          end;
          Inc(Index);
          TopLayer.Free(ModelHandle);
          TopLayer := nil;
          LayerName := ModflowTypes.GetMFTopElevLayerType.WriteNewRoot
            + IntToStr(Index);
          LayerHandle := Project.GetLayerByName(ModelHandle,LayerName);
          if LayerHandle <> nil then
          begin
            TopLayer := TLayerOptions.Create(LayerHandle);
          end;
        end;

      finally
        TopLayer.Free(ModelHandle);
      end;
    end;
  finally
    Project.Free;
  end;
  MessageDlg('The tops of all units with unit numbers greater than or equal to '
    + '2 have been linked to the bottoms of the immediately overlying units.',
    mtInformation, [mbOK], 0);
end;

procedure GLinkUnitsPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
begin
  try
    LinkLayerElevations(aneHandle);
  except on E : Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;

end;

end.
 