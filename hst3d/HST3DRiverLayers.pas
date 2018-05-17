unit HST3DRiverLayers;

interface

uses ANE_LayerUnit;

type

TRiverPermeability = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TRiverWidth = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TRiverThickness = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TRiverTop = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TRiverHead = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TRiverTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

TRiverLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kRivPerm : string = 'River Bed Permeability';
  kRivWidth : string = 'River Bed Width';
  kRivThick : string = 'River Bed Thickness';
  kRivTop : string = 'River Bed Top Elevation';
  kRivHead : string = 'Head';
  kRivLayer : string = 'River Leakage';

implementation

uses HST3DUnit, HST3DGeneralParameters, HST3D_PIE_Unit, HST3DGridLayer;

{ TRiverPermeability }
class Function TRiverPermeability.ANE_ParamName : string ;
begin
  result := kRivPerm;
end;

{constructor TRiverPermeability.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'm^2 or ft^2';
end;}

function TRiverPermeability.Units : string;
begin
  result := 'm^2 or ft^2';
end;

function TRiverPermeability.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '1.0e-10';
    end
  else
    begin
      result := '1.076391041671e-9'
    end;
end;

{ TRiverWidth }
class Function TRiverWidth.ANE_ParamName : string ;
begin
  result := kRivWidth;
end;

{constructor TRiverWidth.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'm or ft';
end;}

function TRiverWidth.Units : string;
begin
  result := 'm or ft';
end;

function TRiverWidth.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '10';
    end
  else
    begin
      result := '32.80839895013'
    end;
end;

{ TRiverThickness }
class Function TRiverThickness.ANE_ParamName : string ;
begin
  result := kRivThick;
end;

{constructor TRiverThickness.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

function TRiverThickness.Units : string;
begin
  result := 'm or ft';
end;

function TRiverThickness.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '1';
    end
  else
    begin
      result := '3.280839895013'
    end;
end;

{ TRiverTop }
class Function TRiverTop.ANE_ParamName : string ;
begin
  result := kRivTop;
end;

{constructor TRiverTop.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

function TRiverTop.Units : string;
begin
  result := 'm or ft';
end;

function TRiverTop.Value : string;
begin
  result := kGridLayer + '.' + kElevation + '1';
end;

{ TRiverHead }
class Function TRiverHead.ANE_ParamName : string ;
begin
  result := kRivHead;
end;

{constructor TRiverHead.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

function TRiverHead.Units : string;
begin
  result := 'm or ft';
end; 

{ TRiverTimeParameters }
constructor TRiverTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(kRivHead);
  ParameterOrder.Add(kGenParDens);
  ParameterOrder.Add(kGenParVisc);
  ParameterOrder.Add(kGenParTemp);
  ParameterOrder.Add(kGenParMassFrac);
  ParameterOrder.Add(TScaledMassFraction.ANE_ParamName);
  TTime.Create(self, -1)         ;
  TRiverHead.Create(self, -1)         ;
  TDensityLayerParam.Create(self, -1)      ;
  TViscosity.Create(self, -1)    ;
  TTemperature.Create(self, -1)    ;
  With PIE_Data do
  begin
    if HST3DForm.rgMassFrac.ItemIndex = 0
    then
      begin
        TMassFraction.Create(self, -1)      ;
      end
    else
      begin
        TScaledMassFraction.Create(self, -1)    ;
      end;
  end;
end;

{ TRiverLayer }
constructor TRiverLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  ParamList.ParameterOrder.Add(kRivPerm);
  ParamList.ParameterOrder.Add(kRivWidth);
  ParamList.ParameterOrder.Add(kRivThick);
  ParamList.ParameterOrder.Add(kRivTop);
  TRiverPermeability.Create(ParamList, -1) ;
  TRiverWidth.Create(ParamList, -1)        ;
  TRiverThickness.Create(ParamList, -1)    ;
  TRiverTop.Create(ParamList, -1)          ;
  With PIE_Data do
  begin
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TRiverTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function TRiverLayer.ANE_LayerName : string ;
begin
  result := kRivLayer;
end;

procedure TRiverLayer.CreateParamterList2;
begin
  TRiverTimeParameters.Create(self.IndexedParamList2, -1);
end;

end.
