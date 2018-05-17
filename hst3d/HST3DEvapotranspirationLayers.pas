unit HST3DEvapotranspirationLayers;

interface

uses ANE_LayerUnit;

type
  TETNodeLayerParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TETLandSurfParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TETExtinctDepthParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//     {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMaxETParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TXEvapParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
    function Units : string; override;
  end;

  TYEvapParam = Class(TXEvapParam)
    class Function ANE_ParamName : string ; override;
  end;

  TETTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;


  THorETLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

{  TVerETLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end; }

const
  kETElev : string = 'Land Surface Elevation';
  kETDepth : string = 'Evapotranspiration Extinction Depth';
  kETMax : string = 'Max Evapotranspiration';
  kETHorLay : string = 'Horizontal Evapotranspiration Boundary';
//  kETVerLay : string = 'Vertical Evapotranspiration Boundary NL';
  KETXEvap : string = 'X Direction Evapotranspiration';
  KETYEvap : string = 'Y Direction Evapotranspiration';
  KEtElevation : string = 'Node Layer';

implementation

uses HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit;

{ TETLandSurfParam }
class Function TETLandSurfParam.ANE_ParamName : string ;
begin
  result := kETElev;
end;

{constructor TETLandSurfParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

function TETLandSurfParam.Units : string;
begin
  result := 'm or ft';
end;

{ TETExtinctDepthParam }
class Function TETExtinctDepthParam.ANE_ParamName : string ;
begin
  result := kETDepth;
end;

{constructor TETExtinctDepthParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

function TETExtinctDepthParam.Units : string;
begin
  result := 'm or ft';
end;

{ TMaxETParam }
class Function TMaxETParam.ANE_ParamName : string ;
begin
  result := kETMax;
end;

{constructor TMaxETParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'L^3/L^2-t';
end;}

function TMaxETParam.Units : string;
begin
  result := 'L^3/L^2-t';
end; 

{ TETTimeParameters }
constructor TETTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(kETMax);
  TTime.Create(self, -1);
  TMaxETParam.Create(self, -1);
end;

{ THorETLayer }
constructor THorETLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;

  ParamList.ParameterOrder.Add(KEtElevation);
  ParamList.ParameterOrder.Add(kETElev);
  ParamList.ParameterOrder.Add(kETDepth);
  TETNodeLayerParam.Create(ParamList, -1);
  TETLandSurfParam.Create(ParamList, -1);
  TETExtinctDepthParam.Create(ParamList, -1);
  With PIE_Data do
  begin
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TETTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function THorETLayer.ANE_LayerName : string ;
begin
  result := kETHorLay;
end;

procedure THorETLayer.CreateParamterList2;
begin
  Interp := leExact;
  Lock := Lock + [llEvalAlg];
  TETTimeParameters.Create(self.IndexedParamList2, -1);
end;

{ TVerETLayer }
{constructor TVerETLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  ParamList.ParameterOrder.Add(kETElev);
  ParamList.ParameterOrder.Add(kETDepth);
  ParamList.ParameterOrder.Add(KETXEvap);
  ParamList.ParameterOrder.Add(KETYEvap);
  TETLandSurfParam.Create(ParamList, -1);
  TETExtinctDepthParam.Create(ParamList, -1);
  TXEvapParam.Create(ParamList, -1);
  TYEvapParam.Create(ParamList, -1);
  With PIE_Data do
  begin
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TETTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function TVerETLayer.ANE_LayerName : string ;
begin
  result := kETVerLay;
end;

procedure TVerETLayer.CreateParamterList2;
begin
  Lock := Lock + [llEvalAlg];
  TETTimeParameters.Create(self.IndexedParamList2, -1);
end;  }

{ TXEvapParam }

class function TXEvapParam.ANE_ParamName: string;
begin
  result := KETXEvap;
end;

constructor TXEvapParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TXEvapParam.Units: string;
begin
  result := 'True or False';
end;

function TXEvapParam.Value: string;
begin
  result := '1';
end;

{ TYEvapParam }

class function TYEvapParam.ANE_ParamName: string;
begin
  result := KETYEvap;
end;
             
{ TETEvapElevParam }

class function TETNodeLayerParam.ANE_ParamName: string;
begin
  result := KEtElevation;
end;

constructor TETNodeLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger
end;

function TETNodeLayerParam.Units: string;
begin
  result := 'm or ft';
end;

function TETNodeLayerParam.Value: string;
begin
  result := '1';
end;

end.
