unit HST3DSpecifiedStateLayers;

interface

uses ANE_LayerUnit;

type

TSpecifiedPresParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndSpecifiedPresParam = Class(TSpecifiedPresParam)
    class Function ANE_ParamName : string ; override;
  end;

TTempAtSpecifiedPresParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndTempAtSpecifiedPresParam = Class(TTempAtSpecifiedPresParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TMassFracAtSpecifiedPresParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TEndMassFracAtSpecifiedPresParam = Class(TMassFracAtSpecifiedPresParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TScaledMassFracAtSpecifiedPresParam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

TEndScaledMassFracAtSpecifiedPresParam = Class(TScaledMassFracAtSpecifiedPresParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TSpecifiedTempParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndSpecifiedTempParam = Class(TSpecifiedTempParam)
    class Function ANE_ParamName : string ; override;
  end;

TSpecifiedMassFracParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TEndSpecifiedMassFracParam = Class(TSpecifiedMassFracParam)
    class Function ANE_ParamName : string ; override;
  end;

TSpecifiedStateScMassFracParam = Class(T_ANE_LayerParam)
    function Value : string ; override;
    class Function ANE_ParamName : string ; override;
  end;

TEndSpecifiedStateScMassFracParam = Class(TSpecifiedStateScMassFracParam)
    class Function ANE_ParamName : string ; override;
  end;

TSpecifiedStateTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

TSpecifiedStateLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kSpecStateSpePres : string = 'Specified Pressure';
  kEndSpecStateSpePres : string = 'End Specified Pressure';
  kSpecStateSpePresTemp : string = 'Temp at Spec Pres';
  kEndSpecStateSpePresTemp : string = 'End Temp at Spec Pres';
  kSpecStateSpePresMassFrac : string = 'Mass Frac at Spec Pres';
  kEndSpecStateSpePresMassFrac : string = 'End Mass Frac at Spec Pres';
  kSpecStateSpePresScMassFrac : string = 'Scaled Mass Frac at Spec Pres';
  kEndSpecStateSpePresScMassFrac : string = 'End Scaled Mass Frac at Spec Pres';
  kSpecStateTemp : string = 'Specified Temperature';
  kEndSpecStateTemp : string = 'End Specified Temperature';
  kSpecStateMassFrac : string = 'Specified Mass Fraction';
  kEndSpecStateMassFrac : string = 'End Specified Mass Fraction';
  kSpecStateScMassFrac : string = 'Specified Scaled Mass Fraction';
  kEndSpecStateScMassFrac : string = 'End Specified Scaled Mass Fraction';
  kSpecStateLayer : string = 'Specified State NL';


implementation

uses
  HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit, HST3DGridLayer, StdCtrls;

class Function TSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kSpecStateSpePres;
end;

function TSpecifiedPresParam.Units : string;
begin
  result := 'Pa or psi';
end;

class Function TEndSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateSpePres;
end;

function TSpecifiedPresParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TTempAtSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kSpecStateSpePresTemp;
end;

function TTempAtSpecifiedPresParam.Units : string;
begin
  result := 'C or F';
end;

function TTempAtSpecifiedPresParam.Value : string ;
begin
  result := kGridLayer + '.' + kT0;
end;

class Function TEndTempAtSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateSpePresTemp;
end;

function TEndTempAtSpecifiedPresParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TMassFracAtSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kSpecStateSpePresMassFrac;
end;

function TMassFracAtSpecifiedPresParam.Value : string ;
begin
  result := kGridLayer + '.' + kW0;
end;

class Function TEndMassFracAtSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateSpePresMassFrac;
end;

function TEndMassFracAtSpecifiedPresParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TScaledMassFracAtSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kSpecStateSpePresScMassFrac;
end;

function TEndScaledMassFracAtSpecifiedPresParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TEndScaledMassFracAtSpecifiedPresParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateSpePresScMassFrac;
end;

class Function TSpecifiedTempParam.ANE_ParamName : string ;
begin
  result := kSpecStateTemp;
end;

function TSpecifiedTempParam.Units : string;
begin
  result := 'F or C';
end;

function TSpecifiedTempParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TEndSpecifiedTempParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateTemp;
end;

class Function TSpecifiedMassFracParam.ANE_ParamName : string ;
begin
  result := kSpecStateMassFrac;
end;

class Function TEndSpecifiedMassFracParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateMassFrac;
end;

function TSpecifiedMassFracParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TSpecifiedStateScMassFracParam.ANE_ParamName : string ;
begin
  result := kSpecStateScMassFrac;
end;

function TSpecifiedStateScMassFracParam.Value : string ;
begin
  result := '$N/A';
end;

class Function TEndSpecifiedStateScMassFracParam.ANE_ParamName : string ;
begin
  result := kEndSpecStateScMassFrac;
end;

constructor TSpecifiedStateTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(kSpecStateSpePres);
  ParameterOrder.Add(kEndSpecStateSpePres);
  ParameterOrder.Add(kSpecStateSpePresTemp);
  ParameterOrder.Add(kEndSpecStateSpePresTemp);
  ParameterOrder.Add(kSpecStateSpePresMassFrac);
  ParameterOrder.Add(kEndSpecStateSpePresMassFrac);
  ParameterOrder.Add(kSpecStateSpePresScMassFrac);
  ParameterOrder.Add(kEndSpecStateSpePresScMassFrac);  
  ParameterOrder.Add(kSpecStateTemp);
  ParameterOrder.Add(kEndSpecStateTemp);
  ParameterOrder.Add(kSpecStateScMassFrac);
  ParameterOrder.Add(TEndSpecifiedStateScMassFracParam.ANE_ParamName);
  ParameterOrder.Add(kSpecStateMassFrac);
  ParameterOrder.Add(TEndSpecifiedMassFracParam.ANE_ParamName);
  With PIE_Data do
  begin
    TTime.Create(self, -1);
    if HST3DForm.cbSpecPres.Checked then
    begin
      TSpecifiedPresParam.Create(self, -1);                      ;
    end;

    if  (PIE_Data.HST3DForm.cbInterpSpecPres.Checked) and
         PIE_Data.HST3DForm.cbSpecPresInterp.Checked and
         PIE_Data.HST3DForm.cbSpecPres.Checked then
    begin
      TEndSpecifiedPresParam.Create(self, -1);
    end;

    if HST3DForm.cbHeat.Checked and HST3DForm.cbSpecPres.Checked then
    begin
      TTempAtSpecifiedPresParam.Create(self, -1)                ;
    end;

    if PIE_Data.HST3DForm.cbInterpTempSpecPres.Checked and
       PIE_Data.HST3DForm.cbSpecPresInterp.Checked and
       PIE_Data.HST3DForm.cbSpecPres.Checked and
       PIE_Data.HST3DForm.cbHeat.Checked then
    begin
      TEndTempAtSpecifiedPresParam.Create(self, -1);
    end;
    if HST3DForm.cbSolute.Checked and HST3DForm.cbSpecPres.Checked then
    begin
      if (HST3DForm.rgMassFrac.ItemIndex = 0) then
      begin
        TMassFracAtSpecifiedPresParam.Create(self, -1)            ;

      end;

      if PIE_Data.HST3DForm.cbInterpMassSpecPress.Checked
        and PIE_Data.HST3DForm.cbSpecPresInterp.Checked and
        PIE_Data.HST3DForm.cbSpecPres.Checked
        and PIE_Data.HST3DForm.cbSolute.Checked and
        (PIE_Data.HST3DForm.rgMassFrac.ItemIndex = 0) then
      begin
        TEndMassFracAtSpecifiedPresParam.Create(self, -1) ;
      end;

      if (HST3DForm.rgMassFrac.ItemIndex = 1) then
      begin
          TScaledMassFracAtSpecifiedPresParam.Create(self, -1)      ;
      end;
    end;

    if PIE_Data.HST3DForm.cbInterpScMassFracSpecPres.Checked
      and PIE_Data.HST3DForm.cbSpecPresInterp.Checked and
       PIE_Data.HST3DForm.cbSpecPres.Checked and
       PIE_Data.HST3DForm.cbSolute.Checked
       and (PIE_Data.HST3DForm.rgMassFrac.ItemIndex = 1) then
    begin
      TEndScaledMassFracAtSpecifiedPresParam.Create(self, -1)      ;
    end;

    if HST3DForm.cbHeat.Checked and HST3DForm.cbSpecTemp.Checked then
    begin
      TSpecifiedTempParam.Create(self, -1)                     ;
    end;
    if PIE_Data.HST3DForm.cbSpecTempInterp.Checked and
        PIE_Data.HST3DForm.cbSpecTemp.Checked and
        PIE_Data.HST3DForm.cbHeat.Checked then
    begin
      TEndSpecifiedTempParam.Create(self, -1)   ;
    end;

    if HST3DForm.cbSolute.Checked and HST3DForm.cbSpecMass.Checked then
    begin
      if (HST3DForm.rgMassFrac.ItemIndex = 0) then
      begin
        TSpecifiedMassFracParam.Create(self, -1)                  ;
      end;
      if (HST3DForm.rgMassFrac.ItemIndex = 1) then
      begin
        TSpecifiedStateScMassFracParam.Create(self, -1)            ;
      end;
    end;
    if PIE_Data.HST3DForm.cbSpecMassInterp.Checked and
        PIE_Data.HST3DForm.cbSpecMass.Checked and
        PIE_Data.HST3DForm.cbSolute.Checked and
        (PIE_Data.HST3DForm.rgMassFrac.ItemIndex = 0) then
    begin
      TEndSpecifiedMassFracParam.Create(self, -1)            ;
    end;
    if PIE_Data.HST3DForm.cbSpecMassInterp.Checked and
        PIE_Data.HST3DForm.cbSpecMass.Checked and
        PIE_Data.HST3DForm.cbSolute.Checked and
        (PIE_Data.HST3DForm.rgMassFrac.ItemIndex = 1) then
    begin
      TEndSpecifiedStateScMassFracParam.Create(self, -1)            ;
    end;

  end;
end;

constructor TSpecifiedStateLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  With PIE_Data do
  begin
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TSpecifiedStateTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function TSpecifiedStateLayer.ANE_LayerName : string ;
begin
  result := kSpecStateLayer;
end;

procedure TSpecifiedStateLayer.CreateParamterList2;
begin
  TSpecifiedStateTimeParameters.Create(self.IndexedParamList2, -1);
end;

end.
