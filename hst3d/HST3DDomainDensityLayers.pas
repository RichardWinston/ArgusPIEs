unit HST3DDomainDensityLayers;

interface

uses ANE_LayerUnit;

type

//----------------------------------------------------------------------------

TDensityParameter = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Units : string; override;
  end;

//----------------------------------------------------------------------------

TDomainOutlineLayer = Class(T_ANE_DomainOutlineLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

//----------------------------------------------------------------------------

TDensityLayer = Class(T_ANE_DensityLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

//----------------------------------------------------------------------------

const
  kDomDens = 'Grid Density';

implementation
//----------------------------------------------------------------------------

class Function TDensityParameter.ANE_ParamName : string ;
begin
  result := kDomDens;
end;

{constructor TDensityParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := kDomDens;
end;   }

function TDensityParameter.Units : string;
begin
  result := kDomDens;
end;

//----------------------------------------------------------------------------

constructor TDomainOutlineLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  TDensityParameter.Create(ParamList, -1);
end;

//----------------------------------------------------------------------------

constructor TDensityLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := kDomDens;
  TDensityParameter.Create(ParamList, -1);
end;

class Function TDensityLayer.ANE_LayerName : string ;
begin
  result := kDomDens;
end;

function TDensityLayer.Units : string;
begin
  result := kDomDens;
end;

//----------------------------------------------------------------------------

end.
