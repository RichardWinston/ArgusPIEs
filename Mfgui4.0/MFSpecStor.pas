unit MFSpecStor;

interface

{MFSpecStor defines the "Specific Storage Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit, MFGenParam;

type
  TSpecStorageParam = class(TCustomParentUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function UnitSimulated : boolean; override;
  end;

  TSpecStorageLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFSpecStorage = 'Specific Storage Unit';

class Function TSpecStorageParam.ANE_ParamName : string ;
begin
  result := kMFSpecStorage;
end;

function TSpecStorageParam.UnitSimulated: boolean;
begin
  result := inherited UnitSimulated;
  if not result then
  begin
    if frmModflow.cbTLK.Checked and frmModflow.cbTLKRetain.Checked then
    begin
      result := True;
    end;
  end;
end;

function TSpecStorageParam.Value : string;
begin
  result := '1.E-5';
end;

//---------------------------
constructor TSpecStorageLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := le624;
  Lock := Lock - [llType];
  ModflowTypes.GetMFSpecStorageParamType.Create(ParamList, -1);
end;

class Function TSpecStorageLayer.ANE_LayerName : string ;
begin
  result := kMFSpecStorage;
end;

function TSpecStorageLayer.Units : string;
begin
  result := '1/' + LengthUnit;
end;

end.
