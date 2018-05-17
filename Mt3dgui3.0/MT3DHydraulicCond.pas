unit MT3DHydraulicCond;

interface

uses  MFHydraulicCond, ANE_LayerUnit ;

const
  kMT3DLongDisp = 'MT3D Longitudinal Dispersivity';

type
  TMT3DLongDisp = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMT3DHydraulicCondLayer = Class(THydraulicCondLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer) ;override;
  end;

implementation

uses Variables;

class Function TMT3DLongDisp.Ane_ParamName : string ;
begin
  result := kMT3DLongDisp;
end;

function TMT3DLongDisp.Units : string;
begin
  result := 'L';
end;

function TMT3DLongDisp.Value : string;
begin
  result := '10';
end;

//---------------------------
constructor TMT3DHydraulicCondLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetMT3DLongDispParamClassType.Create(ParamList, -1);
  end;

end;

end.
 