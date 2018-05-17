unit OverriddenArrayUnit;

interface

uses SysUtils, Dialogs, AnePIE;

type
  TSpecifiedPressureParameters = (ppPressure, ppConcentration, ppTransient);

  TFluidSourcesParameters = (fspTotalSource, fspSpecificSource,
    fspConcentration, fspTransient);

  TEnergySoluteSourcesParameters = (espTotalSource, espSpecificSource,
    espTransient);

  TSpecifiedConcentrationParameters = (scConcentration, scTransient
  {$IFDEF OldSutraIce},
    scConductance
  {$ENDIF}
    );


procedure SetOverriddenSpecifiedPressure (const refPtX : ANE_DOUBLE_PTR      ;
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

procedure SetOverriddenEnergySoluteTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenFluidSourceTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure SetOverriddenSpecConcTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{$IFDEF OldSutraIce}
procedure SetOverriddenSpecConcConductance (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
{$ENDIF}

procedure SetOverriddenFluidSourceConc (const refPtX : ANE_DOUBLE_PTR      ;
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

procedure SetOverriddenSpecConcTemp (const refPtX : ANE_DOUBLE_PTR      ;
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

    FMaxOverriddenFluidSource : integer;
    FOverriddenFluidSource : array of
      array[Low(TFluidSourcesParameters)..
      High(TFluidSourcesParameters)] of boolean;

    FMaxOverriddenEnSolSource : integer;
    FOverriddenEnSolSource : array of
      array[Low(TEnergySoluteSourcesParameters)..
      High(TEnergySoluteSourcesParameters)] of boolean;

    FMaxOverriddenSpecConcTemp : integer;
    FOverriddenSpecConcTemp : array of
      array[Low(TSpecifiedConcentrationParameters)..
      High(TSpecifiedConcentrationParameters)] of boolean;

    function GetOverriddenPressure(Contour : integer;
      Parameter : TSpecifiedPressureParameters) : boolean;
    procedure SetOverriddenSpecPressureParameters(Contour: integer;
      Parameter: TSpecifiedPressureParameters; Value: boolean);

    function GetOverriddenFluidSource(Contour : integer;
      Parameter : TFluidSourcesParameters) : boolean;
    procedure SetOverriddenFluidSource(Contour: integer;
      Parameter: TFluidSourcesParameters; Value: boolean);

    function GetOverriddenEnSolSource(Contour : integer;
      Parameter : TEnergySoluteSourcesParameters) : boolean;
    procedure SetOverriddenEnSolSource(Contour: integer;
      Parameter: TEnergySoluteSourcesParameters; Value: boolean);

    function GetOverriddenSpecConcTemp(Contour : integer;
      Parameter : TSpecifiedConcentrationParameters) : boolean;
    procedure SetOverriddenSpecConcTemp(Contour: integer;
      Parameter: TSpecifiedConcentrationParameters; Value: boolean);

  public
    property OverriddenPressure[Contour : integer;
      Parameter : TSpecifiedPressureParameters] : boolean
      read GetOverriddenPressure;
    Property PressureCount : integer read FMaxOverriddenPressureParameters;

    property OverriddenFluidSource[Contour : integer;
      Parameter : TFluidSourcesParameters] : boolean
      read GetOverriddenFluidSource;
    Property FluidSourceCount : integer read FMaxOverriddenFluidSource;

    property OverriddenEnSolSource[Contour : integer;
      Parameter : TEnergySoluteSourcesParameters] : boolean
      read GetOverriddenEnSolSource;
    Property EnergySolSourceCount : integer read FMaxOverriddenEnSolSource;

    property OverriddenSpecConcTemp[Contour : integer;
      Parameter : TSpecifiedConcentrationParameters] : boolean
      read GetOverriddenSpecConcTemp;
    Property SpecConcTempCount : integer read FMaxOverriddenSpecConcTemp;

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
  FMaxOverriddenEnSolSource := 0;
  FMaxOverriddenSpecConcTemp := 0;

  SetLength(FOverriddenPressureParameters,0);
  SetLength(FOverriddenFluidSource,0);
  SetLength(FOverriddenEnSolSource,0);
  SetLength(FOverriddenSpecConcTemp,0);
end;

constructor TOverridenParameters.Create;
begin
  inherited;
  FMaxOverriddenPressureParameters := 0;
  FMaxOverriddenFluidSource := 0;
  FMaxOverriddenEnSolSource := 0;
  FMaxOverriddenSpecConcTemp := 0;
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
            ppTransient,IsOverridden);

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

procedure SetOverriddenEnergySoluteTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
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
            espTransient,IsOverridden);

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

procedure SetOverriddenFluidSourceTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
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
            fspTransient,IsOverridden);

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

procedure SetOverriddenSpecConcTimeDep (const refPtX : ANE_DOUBLE_PTR      ;
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
            scTransient,IsOverridden);

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

{$IFDEF OldSutraIce}
procedure SetOverriddenSpecConcConductance (const refPtX : ANE_DOUBLE_PTR      ;
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
            scConductance,IsOverridden);

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
{$ENDIF}

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

Initialization
  OverridenParameters := TOverridenParameters.Create;

Finalization
  OverridenParameters.Free;

end.
