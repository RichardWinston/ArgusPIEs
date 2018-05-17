unit SLCustomLayers;

interface

uses ANE_LayerUnit;

type
  TSutraInfoLayer = class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    // see T_ANE_MapsLayer
  end;

  TSutraGroupLayer = class(T_ANE_GroupLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    // see T_ANE_MapsLayer
  end;

implementation

{ TSutraInfoLayer }

constructor TSutraInfoLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Visible := False;
end;

{ TSutraGroupLayer }

constructor TSutraGroupLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Visible := False;
end;

end.
