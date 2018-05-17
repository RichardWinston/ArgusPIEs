unit MFMOC_VolumeBalancing;

interface

uses SysUtils, ANE_LayerUnit;

type
  TGWT_VolumeBalancingLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses
  Variables;



const
  StrVolumeBalancingUni = 'Volume Balancing Unit';

{ TGWT_VolumneBalancingLayer }

class function TGWT_VolumeBalancingLayer.ANE_LayerName: string;
begin
  result := StrVolumeBalancingUni;
end;

constructor TGWT_VolumeBalancingLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := Lock + [llType, llEvalAlg];
  Interp := leExact;

  ModflowTypes.GetGWT_TopElevParam.Create(ParamList, -1);
  ModflowTypes.GetGWT_BottomElevParam.Create(ParamList, -1);

end;

end.
