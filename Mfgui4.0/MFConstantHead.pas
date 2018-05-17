unit MFConstantHead;

interface

uses ANE_LayerUnit;

type
  TConstantHead = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

{  TConstantHeadTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TConstantHeadPointLineLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TConstantHeadAreaLayer = Class(TConstantHeadPointLineLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;  }


implementation

uses Variables;

resourcestring
  rsConstantHead = 'Constant Head';

{ TConstantHead }

class function TConstantHead.ANE_ParamName: string;
begin
  result := rsConstantHead
end;

function TConstantHead.Units: string;
begin
  result := LengthUnit
end;

end.
