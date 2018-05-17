unit FixMoreNamesUnit;

interface

uses SysUtils, AnePIE, Variables;

Procedure FixMoreOldNames(aneHandle : ANE_PTR);

Procedure CheckForMoreNewLayers(aneHandle : ANE_PTR; var ShowMessage : boolean);

implementation

uses ANECB, ANE_LayerUnit, UtilityFunctions;

Procedure FixMoreOldNames(aneHandle : ANE_PTR);
var
  LayerHandle : ANE_PTR;
  ParamIndex : ANE_INT32;
  UnitIndex : Integer;
  ParameterName : string;
  Expression : string;
  GridLayer : T_ANE_GridLayer;
  AParamList : T_ANE_IndexedParameterList;
  ActiveCellParam : T_ANE_GridParam;
  LayerName : string;
  ANE_LayerName : ANE_STR;
begin
  GridLayer := frmMODFLOW.MFLayerStructure.UnIndexedLayers.
    GetLayerByName(ModflowTypes.GetGridLayerType.ANE_LayerName)
    as T_ANE_GridLayer;

  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(aneHandle,LayerName);
{  GetMem(ANE_LayerName, Length(LayerName) + 1);
  try
    StrPCopy(ANE_LayerName,LayerName);
    LayerHandle := ANE_LayerGetHandleByName(ModelHandle,
      ANE_LayerName);
  finally
    FreeMem(ANE_LayerName);
  end;}
//  LayerHandle := ANE_LayerGetHandleByName(aneHandle,
//    PChar(ModflowTypes.GetGridLayerType.ANE_LayerName));

  if LayerHandle <> nil then
  begin
    UnitIndex := 0;
    repeat
      ParamIndex := -1;
      AParamList := GridLayer.IndexedParamList1.
        GetNonDeletedIndParameterListByIndex(UnitIndex)
        as T_ANE_IndexedParameterList;

      if AParamList <> nil then
      begin
        Inc (UnitIndex);

        ParameterName := ModflowTypes.GetGridMFActiveCellParamClassType.
          WriteParamName + IntToStr(UnitIndex);

        ParamIndex := UGetParameterIndex(aneHandle, layerHandle,
          ParameterName);

        if ParamIndex > -1 then
        begin
          ActiveCellParam := AParamList.GetParameterByName(ModflowTypes.
            GetGridMFActiveCellParamClassType.ANE_ParamName) as T_ANE_GridParam;

          Expression := ActiveCellParam.Value;

          USetParameterExpression(aneHandle, layerHandle, ParamIndex,
            Expression);
        end;

      end;

    until (AParamList = nil) or (ParamIndex < 0) ;
  end;

end;

Procedure CheckForMoreNewLayers(aneHandle : ANE_PTR; var ShowMessage : boolean);
begin
  // In customized versions, make additional changes here.
end;

end.
