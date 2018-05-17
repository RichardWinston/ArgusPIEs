unit UtilityFunctionsMT3D;

interface

uses
  Sysutils, AnePIE;

function GetGridAngle(anehandle: ANE_PTR; GridLayerName : string;
 var gridLayerHandle : ANE_PTR) : ANE_DOUBLE ;

implementation

uses
  ANECB;

function GetGridAngle(anehandle: ANE_PTR; GridLayerName : string;
 var gridLayerHandle : ANE_PTR) : ANE_DOUBLE ;
var
  Angle : ANE_DOUBLE ;
  ANE_LayerName : ANE_STR;
begin
{  LayerName := AMapLayerType.ANE_LayerName;
  gridLayerHandle := GetLayerHandle(ModelHandle,LayerName); }
  GetMem(ANE_LayerName, Length(GridLayerName) + 1);
  try
    StrPCopy(ANE_LayerName,GridLayerName);
    gridLayerHandle := ANE_LayerGetHandleByName(anehandle,
      ANE_LayerName);
  finally
    FreeMem(ANE_LayerName);
  end;
//  gridLayerHandle
//    := ANE_LayerGetHandleByName(anehandle,
//        PChar(GridLayerName)  );

  // Get grid angle
  ANE_EvaluateStringAtLayer(aneHandle, gridLayerHandle,
      kPIEFloat,
      'If(IsNA(GridAngle()), 0.0, GridAngle())', @Angle);

  result := Angle;
end;

end.
 