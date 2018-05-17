unit OverriddenArrayUnit;

interface

uses SysUtils, Dialogs, AnePIE;

type
  TSpecifiedPressureParameters = (ppPressure, ppConcentration,
    ppTimeDependence, ppTop, ppEndTop, ppBottom, ppEndBottom);

  TFluidSourcesParameters = (fspTotalSource, fspSpecificSource,
    fspConcentration, fspTop, fspBottom);

  TEnergySoluteSourcesParameters = (espTotalSource, espSpecificSource,
    espTop, espBottom);

  TSpecifiedConcentrationParameters = (scConcentration, scTop, scBottom);


procedure SetOverriddenSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecifiedPressureBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecifiedPressureEndBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecifiedPressureConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecifiedPressureTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecifiedPressureTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecifiedPressureEndTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;



procedure SetOverriddenSurfaceSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecifiedPressureBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecifiedPressureConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecifiedPressureTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecifiedPressureTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;





procedure SetOverriddenFluidSourceBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenFluidSourceConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenFluidSourceTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecificFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenTotalFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenEnergySoluteTotalSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenEnergySoluteSpecificSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenEnergySoluteTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenEnergySoluteBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenTotalSurfaceFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecificSurfaceFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceFluidSourceConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceFluidSourceTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceFluidSourceBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceEnergySoluteSpecificSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceEnergySoluteTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceEnergySoluteBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceEnergySoluteTotalSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecConcTempTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecConcTempBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecConcTempTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSurfaceSpecConcTempBottom (const refPtX : ANE_DOUBLE_PTR;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;




type
  TOverridenParameters = Class(TObject)
  private
    FMaxOverriddenPressureParameters : integer;
    FOverriddenPressureParameters : array of
      array[Low(TSpecifiedPressureParameters)..
      High(TSpecifiedPressureParameters)] of boolean;

    FMaxOverriddenSurfacePressureParameters : integer;
    FOverriddenSurfacePressureParameters : array of
      array[Low(TSpecifiedPressureParameters)..
      High(TSpecifiedPressureParameters)] of boolean;

    FMaxOverriddenFluidSource : integer;
    FOverriddenFluidSource : array of
      array[Low(TFluidSourcesParameters)..
      High(TFluidSourcesParameters)] of boolean;

    FMaxOverriddenSurfaceFluidSource : integer;
    FOverriddenSurfaceFluidSource : array of
      array[Low(TFluidSourcesParameters)..
      High(TFluidSourcesParameters)] of boolean;

    FMaxOverriddenEnSolSource : integer;
    FOverriddenEnSolSource : array of
      array[Low(TEnergySoluteSourcesParameters)..
      High(TEnergySoluteSourcesParameters)] of boolean;

    FMaxOverriddenSurfaceEnSolSource : integer;
    FOverriddenSurfaceEnSolSource : array of
      array[Low(TEnergySoluteSourcesParameters)..
      High(TEnergySoluteSourcesParameters)] of boolean;

    FMaxOverriddenSpecConcTemp : integer;
    FOverriddenSpecConcTemp : array of
      array[Low(TSpecifiedConcentrationParameters)..
      High(TSpecifiedConcentrationParameters)] of boolean;

    FMaxOverriddenSurfaceSpecConcTemp : integer;
    FOverriddenSurfaceSpecConcTemp : array of
      array[Low(TSpecifiedConcentrationParameters)..
      High(TSpecifiedConcentrationParameters)] of boolean;

    function GetOverriddenPressure(Contour : integer;
      Parameter : TSpecifiedPressureParameters) : boolean;
    procedure SetOverriddenSpecPressureParameters(Contour: integer;
      Parameter: TSpecifiedPressureParameters; Value: boolean);

    function GetOverriddenSurfacePressure(Contour : integer;
      Parameter : TSpecifiedPressureParameters) : boolean;
    procedure SetOverriddenSurfaceSpecPressureParameters(Contour: integer;
      Parameter: TSpecifiedPressureParameters; Value: boolean);

    function GetOverriddenFluidSource(Contour : integer;
      Parameter : TFluidSourcesParameters) : boolean;
    procedure SetOverriddenFluidSource(Contour: integer;
      Parameter: TFluidSourcesParameters; Value: boolean);

    function GetOverriddenSurfaceFluidSource(Contour: integer;
      Parameter: TFluidSourcesParameters): boolean;
    procedure SetOverriddenSurfaceFluidSource(Contour: integer;
      Parameter: TFluidSourcesParameters; Value: boolean);

    function GetOverriddenEnSolSource(Contour : integer;
      Parameter : TEnergySoluteSourcesParameters) : boolean;
    procedure SetOverriddenEnSolSource(Contour: integer;
      Parameter: TEnergySoluteSourcesParameters; Value: boolean);

    function GetOverriddenSurfaceEnSolSource(Contour : integer;
      Parameter : TEnergySoluteSourcesParameters) : boolean;
    procedure SetOverriddenSurfaceEnSolSource(Contour: integer;
      Parameter: TEnergySoluteSourcesParameters; Value: boolean);

    function GetOverriddenSpecConcTemp(Contour : integer;
      Parameter : TSpecifiedConcentrationParameters) : boolean;
    procedure SetOverriddenSpecConcTemp(Contour: integer;
      Parameter: TSpecifiedConcentrationParameters; Value: boolean);

    function GetOverriddenSurfaceSpecConcTemp(Contour : integer;
      Parameter : TSpecifiedConcentrationParameters) : boolean;
    procedure SetOverriddenSurfaceSpecConcTemp(Contour: integer;
      Parameter: TSpecifiedConcentrationParameters; Value: boolean);

  public
    property OverriddenPressure[Contour : integer;
      Parameter : TSpecifiedPressureParameters] : boolean read GetOverriddenPressure;
    Property PressureCount : integer read FMaxOverriddenPressureParameters;

    property OverriddenSurfacePressure[Contour : integer;
      Parameter : TSpecifiedPressureParameters] : boolean read GetOverriddenSurfacePressure;
    Property SurfacePressureCount : integer read FMaxOverriddenSurfacePressureParameters;

    property OverriddenFluidSource[Contour : integer;
      Parameter : TFluidSourcesParameters] : boolean read GetOverriddenFluidSource;
    Property FluidSourceCount : integer read FMaxOverriddenFluidSource;

    property OverriddenSurfaceFluidSource[Contour : integer;
      Parameter : TFluidSourcesParameters] : boolean read GetOverriddenSurfaceFluidSource;
    Property SurfaceFluidSourceCount : integer read FMaxOverriddenSurfaceFluidSource;

    property OverriddenEnSolSource[Contour : integer;
      Parameter : TEnergySoluteSourcesParameters] : boolean read GetOverriddenEnSolSource;
    Property EnergySolSourceCount : integer read FMaxOverriddenEnSolSource;

    property OverriddenSurfaceEnSolSource[Contour : integer;
      Parameter : TEnergySoluteSourcesParameters] : boolean read GetOverriddenSurfaceEnSolSource;
    Property SurfaceEnergySolSourceCount : integer read FMaxOverriddenSurfaceEnSolSource;

    property OverriddenSpecConcTemp[Contour : integer;
      Parameter : TSpecifiedConcentrationParameters] : boolean read GetOverriddenSpecConcTemp;
    Property SpecConcTempCount : integer read FMaxOverriddenSpecConcTemp;

    property OverriddenSurfaceSpecConcTemp[Contour : integer;
      Parameter : TSpecifiedConcentrationParameters] : boolean read GetOverriddenSurfaceSpecConcTemp;
    Property SurfaceSpecConcTempCount : integer read FMaxOverriddenSurfaceSpecConcTemp;

    Procedure ClearArrays;
    Constructor Create;
  end;

var
  OverridenParameters : TOverridenParameters;

implementation

uses ParamArrayUnit, ANE_LayerUnit;

{ TOverridenParameters }

procedure TOverridenParameters.ClearArrays;
begin
  FMaxOverriddenPressureParameters :=0;
  FMaxOverriddenFluidSource := 0;
  FMaxOverriddenSurfaceFluidSource := 0;
  FMaxOverriddenEnSolSource := 0;
  FMaxOverriddenSurfaceEnSolSource := 0;

  SetLength(FOverriddenPressureParameters,0);
  SetLength(FOverriddenFluidSource,0);
  SetLength(FOverriddenEnSolSource,0);
  SetLength(FOverriddenSurfaceFluidSource,0);
  SetLength(FOverriddenSurfaceEnSolSource,0);
end;

constructor TOverridenParameters.Create;
begin
  inherited;
  FMaxOverriddenPressureParameters := 0;
  FMaxOverriddenSurfacePressureParameters := 0;
  FMaxOverriddenFluidSource := 0;
  FMaxOverriddenSurfaceFluidSource := 0;
  FMaxOverriddenEnSolSource := 0;
  FMaxOverriddenSurfaceEnSolSource := 0;
  FMaxOverriddenSpecConcTemp := 0;
  FMaxOverriddenSurfaceSpecConcTemp := 0;
end;

function TOverridenParameters.GetOverriddenEnSolSource(Contour: integer;
  Parameter: TEnergySoluteSourcesParameters): boolean;
begin
  result := FOverriddenEnSolSource[Contour, Parameter];
end;

function TOverridenParameters.GetOverriddenFluidSource(Contour: integer;
  Parameter: TFluidSourcesParameters): boolean;
begin
  result := FOverriddenFluidSource[Contour, Parameter];
end;

function TOverridenParameters.GetOverriddenSurfaceFluidSource(Contour: integer;
  Parameter: TFluidSourcesParameters): boolean;
begin
  result := FOverriddenSurfaceFluidSource[Contour, Parameter];
end;

function TOverridenParameters.GetOverriddenPressure(Contour: integer;
  Parameter: TSpecifiedPressureParameters): boolean;
begin
  result := FOverriddenPressureParameters[Contour, Parameter];
end;

procedure TOverridenParameters.SetOverriddenEnSolSource(Contour: integer;
  Parameter: TEnergySoluteSourcesParameters; Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TEnergySoluteSourcesParameters;
begin
  if Contour >= FMaxOverriddenEnSolSource then
  begin
    SetLength(FOverriddenEnSolSource,Contour+1);
    for ContourIndex := FMaxOverriddenEnSolSource to Contour do
    begin
      for ParameterIndex := Low(TEnergySoluteSourcesParameters)
        to High(TEnergySoluteSourcesParameters) do
      begin
        FOverriddenEnSolSource[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenEnSolSource := Contour+1;
  end;
  FOverriddenEnSolSource[Contour,Parameter] := Value;
end;

procedure TOverridenParameters.SetOverriddenFluidSource(Contour: integer;
  Parameter: TFluidSourcesParameters; Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TFluidSourcesParameters;
begin
  if Contour >= FMaxOverriddenFluidSource then
  begin
    SetLength(FOverriddenFluidSource,Contour+1);
    for ContourIndex := FMaxOverriddenFluidSource to Contour do
    begin
      for ParameterIndex := Low(TFluidSourcesParameters)
        to High(TFluidSourcesParameters) do
      begin
        FOverriddenFluidSource[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenFluidSource := Contour+1;
  end;
  FOverriddenFluidSource[Contour,Parameter] := Value;
end;

procedure TOverridenParameters.SetOverriddenSurfaceFluidSource(Contour: integer;
  Parameter: TFluidSourcesParameters; Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TFluidSourcesParameters;
begin
  if Contour >= FMaxOverriddenSurfaceFluidSource then
  begin
    SetLength(FOverriddenSurfaceFluidSource,Contour+1);
    for ContourIndex := FMaxOverriddenSurfaceFluidSource to Contour do
    begin
      for ParameterIndex := Low(TFluidSourcesParameters)
        to High(TFluidSourcesParameters) do
      begin
        FOverriddenSurfaceFluidSource[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenSurfaceFluidSource := Contour+1;
  end;
  FOverriddenSurfaceFluidSource[Contour,Parameter] := Value;
end;

procedure TOverridenParameters.SetOverriddenSpecPressureParameters(Contour : integer;
  Parameter : TSpecifiedPressureParameters; Value : boolean);
var
  ContourIndex : integer;
  ParameterIndex : TSpecifiedPressureParameters;
begin
  if Contour >= FMaxOverriddenPressureParameters then
  begin
    SetLength(FOverriddenPressureParameters,Contour+1);
    for ContourIndex := FMaxOverriddenPressureParameters to Contour do
    begin
      for ParameterIndex := Low(TSpecifiedPressureParameters)
        to High(TSpecifiedPressureParameters) do
      begin
        FOverriddenPressureParameters[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenPressureParameters := Contour+1;
  end;
  FOverriddenPressureParameters[Contour,Parameter] := Value;
end;


function TOverridenParameters.GetOverriddenSpecConcTemp(Contour: integer;
  Parameter: TSpecifiedConcentrationParameters): boolean;
begin
  result := FOverriddenSpecConcTemp[Contour, Parameter];
end;

function TOverridenParameters.GetOverriddenSurfaceSpecConcTemp(
  Contour: integer; Parameter: TSpecifiedConcentrationParameters): boolean;
begin
  result := FOverriddenSurfaceSpecConcTemp[Contour, Parameter];
end;

procedure TOverridenParameters.SetOverriddenSpecConcTemp(Contour: integer;
  Parameter: TSpecifiedConcentrationParameters; Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TSpecifiedConcentrationParameters;
begin
  if Contour >= FMaxOverriddenSpecConcTemp then
  begin
    SetLength(FOverriddenSpecConcTemp,Contour+1);
    for ContourIndex := FMaxOverriddenSpecConcTemp to Contour do
    begin
      for ParameterIndex := Low(TSpecifiedConcentrationParameters)
        to High(TSpecifiedConcentrationParameters) do
      begin
        FOverriddenSpecConcTemp[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenSpecConcTemp := Contour+1;
  end;
  FOverriddenSpecConcTemp[Contour,Parameter] := Value;
end;

procedure TOverridenParameters.SetOverriddenSurfaceSpecConcTemp(
  Contour: integer; Parameter: TSpecifiedConcentrationParameters;
  Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TSpecifiedConcentrationParameters;
begin
  if Contour >= FMaxOverriddenSurfaceSpecConcTemp then
  begin
    SetLength(FOverriddenSurfaceSpecConcTemp,Contour+1);
    for ContourIndex := FMaxOverriddenSurfaceSpecConcTemp to Contour do
    begin
      for ParameterIndex := Low(TSpecifiedConcentrationParameters)
        to High(TSpecifiedConcentrationParameters) do
      begin
        FOverriddenSurfaceSpecConcTemp[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenSurfaceSpecConcTemp := Contour+1;
  end;
  FOverriddenSurfaceSpecConcTemp[Contour,Parameter] := Value;
end;



{
function GetOverriddenSpecPressureParameters(Contour : integer;
  Parameter : TSpecifiedPressureParameters): boolean;
begin
  result := OverridenPressures.FOverriddenPressureParameters[Contour,Parameter];
end;
}

procedure SetOverriddenSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppPressure,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecifiedPressureConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppConcentration,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecifiedPressureTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppTimeDependence,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecifiedPressureTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecifiedPressureEndTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppEndTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecifiedPressureBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecifiedPressureEndBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecPressureParameters(ContourIndex,
            ppEndBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;




procedure SetOverriddenSurfaceSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecPressureParameters(ContourIndex,
            ppPressure,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecifiedPressureConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecPressureParameters(ContourIndex,
            ppConcentration,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecifiedPressureTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecPressureParameters(ContourIndex,
            ppTimeDependence,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecifiedPressureTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecPressureParameters(ContourIndex,
            ppTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecifiedPressureBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecPressureParameters(ContourIndex,
            ppBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;






procedure SetOverriddenTotalFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenFluidSource(ContourIndex,
            fspTotalSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecificFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenFluidSource(ContourIndex,
            fspSpecificSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenFluidSourceConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenFluidSource(ContourIndex,
            fspConcentration,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenFluidSourceTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenFluidSource(ContourIndex,
            fspTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenFluidSourceBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenFluidSource(ContourIndex,
            fspBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenEnergySoluteTotalSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenEnSolSource(ContourIndex,
            espTotalSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenEnergySoluteSpecificSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenEnSolSource(ContourIndex,
            espSpecificSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenEnergySoluteTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenEnSolSource(ContourIndex,
            espTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenEnergySoluteBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenEnSolSource(ContourIndex,
            espBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenTotalSurfaceFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceFluidSource(ContourIndex,
            fspTotalSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecificSurfaceFluidSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceFluidSource(ContourIndex,
            fspSpecificSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceFluidSourceConc (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceFluidSource(ContourIndex,
            fspConcentration,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceFluidSourceTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceFluidSource(ContourIndex,
            fspTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceFluidSourceBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceFluidSource(ContourIndex,
            fspBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;



function TOverridenParameters.GetOverriddenSurfaceEnSolSource(
  Contour: integer; Parameter: TEnergySoluteSourcesParameters): boolean;
begin
  result := FOverriddenSurfaceEnSolSource[Contour, Parameter];
end;

procedure TOverridenParameters.SetOverriddenSurfaceEnSolSource(
  Contour: integer; Parameter: TEnergySoluteSourcesParameters;
  Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TEnergySoluteSourcesParameters;
begin
  if Contour >= FMaxOverriddenSurfaceEnSolSource then
  begin
    SetLength(FOverriddenSurfaceEnSolSource,Contour+1);
    for ContourIndex := FMaxOverriddenSurfaceEnSolSource to Contour do
    begin
      for ParameterIndex := Low(TEnergySoluteSourcesParameters)
        to High(TEnergySoluteSourcesParameters) do
      begin
        FOverriddenSurfaceEnSolSource[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenSurfaceEnSolSource := Contour+1;
  end;
  FOverriddenSurfaceEnSolSource[Contour,Parameter] := Value;
end;

function TOverridenParameters.GetOverriddenSurfacePressure(
  Contour: integer; Parameter: TSpecifiedPressureParameters): boolean;
begin
  result := FOverriddenSurfacePressureParameters[Contour, Parameter];
end;

procedure TOverridenParameters.SetOverriddenSurfaceSpecPressureParameters(
  Contour: integer; Parameter: TSpecifiedPressureParameters;
  Value: boolean);
var
  ContourIndex : integer;
  ParameterIndex : TSpecifiedPressureParameters;
begin
  if Contour >= FMaxOverriddenSurfacePressureParameters then
  begin
    SetLength(FOverriddenSurfacePressureParameters,Contour+1);
    for ContourIndex := FMaxOverriddenSurfacePressureParameters to Contour do
    begin
      for ParameterIndex := Low(TSpecifiedPressureParameters)
        to High(TSpecifiedPressureParameters) do
      begin
        FOverriddenSurfacePressureParameters[ContourIndex,ParameterIndex] := False;
      end;
    end;
    FMaxOverriddenSurfacePressureParameters := Contour+1;
  end;
  FOverriddenSurfacePressureParameters[Contour,Parameter] := Value;
end;

procedure SetOverriddenSurfaceEnergySoluteTotalSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceEnSolSource(ContourIndex,
            espTotalSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceEnergySoluteSpecificSource (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceEnSolSource(ContourIndex,
            espSpecificSource,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceEnergySoluteTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceEnSolSource(ContourIndex,
            espTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceEnergySoluteBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceEnSolSource(ContourIndex,
            espBottom,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecConcTemp(ContourIndex,
            scConcentration,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecConcTempTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecConcTemp(ContourIndex,
            scTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSpecConcTempBottom (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSpecConcTemp(ContourIndex,
            scBottom, IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecConcTemp(ContourIndex,
            scConcentration,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecConcTempTop (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecConcTemp(ContourIndex,
            scTop,IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure SetOverriddenSurfaceSpecConcTempBottom (const refPtX : ANE_DOUBLE_PTR;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ContourIndex : ANE_INT32;
  param2_ptr : ANE_BOOL_PTR;
  IsOverridden : boolean;
begin
  Result := False;
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin
      try
        begin


          param := @parameters^;
          param1_ptr :=  param^[0];
          ContourIndex :=  param1_ptr^ -1;
          param2_ptr :=  param^[1];
          IsOverridden :=  param2_ptr^ ;

          OverridenParameters.SetOverriddenSurfaceSpecConcTemp(ContourIndex,
            scBottom, IsOverridden);

          result := True;
        end;
      Except on Exception do
        begin
          Result := False;
        end;
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_BOOL_PTR(reply)^ := result;
end;


Initialization
  OverridenParameters := TOverridenParameters.Create;

Finalization
  OverridenParameters.Free;

end.
